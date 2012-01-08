local versionNumber = "v1.4"

function widget:GetInfo()
	return {
		name = "Nested Buildmenu",
		desc = versionNumber .. " Nests large buildmenus. Commands are nested_buildmenu_X:\n"
				.. "press [number] to press an icon (numbered left to right, up to down, starting at 1)\n"
				.. "size, cols, cancelonly, uselists to tweak",
		author = "Evil4Zerggin",
		date = "3 January 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = false
	}
end

------------------------------------------------
--config
------------------------------------------------
local startCategory = "Econ"

--sizing
local mainSize = 64
--relative to mainSize
local lineWidth = 0.03125
local textSize = 0.25

local numCols = 3

--nesting
local nestThreshold = 12
local cancelOnly = false

local mainX, mainY = 0, 512

local useLists = false

local drawFrames --looks for cancelFrameFile
local cancelFrameFile = "Images/nested_buildmenu/frame_Cancel.png"
local frameDir = ":l:" .. LUAUI_DIRNAME .. "Images/nested_buildmenu/frame_"
local frameExt = ".png"

function widget:GetConfigData(data)
	return {
		mainX = mainX,
		mainY = mainY,
		mainSize = mainSize,
		numCols = numCols,
		cancelOnly = cancelOnly,
		useLists = useLists,
	}
end

function widget:SetConfigData(data)
	mainX = data.mainX or 0
	mainY = data.mainY or 512
	mainSize = data.mainSize or 64
	numCols = data.numCols or 3
	cancelOnly = data.cancelOnly
	useLists = data.useLists
end

------------------------------------------------
--speedups
------------------------------------------------
local GetSelectedUnitsCounts = Spring.GetSelectedUnitsCounts
local GetMouseState = Spring.GetMouseState
local GetModKeyState = Spring.GetModKeyState
local GetCmdDescIndex = Spring.GetCmdDescIndex
local SetActiveCommand = Spring.SetActiveCommand
local IsGUIHidden = Spring.IsGUIHidden

local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local glTexRect = gl.TexRect
local glShape = gl.Shape
local glTranslate = gl.Translate
local glScale = gl.Scale
local glLoadIdentity = gl.LoadIdentity
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glText = gl.Text
local glGetTextWidth = gl.GetTextWidth
local glTexture = gl.Texture

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local ceil = math.ceil
local floor = math.floor
local max = math.max
local sort = table.sort
local strFind = string.find

local GL_LINES = GL.LINES
local GL_LINE = GL.LINE
local GL_FILL = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK

------------------------------------------------
--vars
------------------------------------------------
local vsx, vsy
local numIcons
local category
local once
local activeClick
local buildIDs = {}
--format: unitDefID = {category, ordering}
local unitDefInfo = {}
local mouseOffsetX, mouseOffsetY

local tweakList, mainList

local TEXT_CORRECT_Y = 1.25

local BUILD_CATEGORIES = {
	"Econ",
	"Fac",
	"Aux",
	"Def",
	"Strat",
	"Fort",
	"Sensor",
	"Mobile",
	"Misc",
}

local categoryCounts = {}
--one unit from each category
local categoryUnits = {}

local tweak = false

------------------------------------------------
--H4X
------------------------------------------------

local function GetRealTextWidth(text)
	return glGetTextWidth(text) * vsx / vsy * 1.33333333
end

------------------------------------------------
--util
------------------------------------------------
local function energyToExtraM(energy)   -- mex overdrive equation
  return math.sqrt(energy*0.2*WG.mexSquaredSum + WG.mexMetal*WG.mexMetal) - WG.mexMetal
end


local function TransformMain(x, y)
	return (x - mainX) / mainSize, (y - mainY) / mainSize
end

--nil if no icon, 0 for cancel button, iconID otherwise
local function GetIconID(tx, ty)
	if (tx < 0 or tx >= numCols or ty >= 0) then 
		return nil
	else
		result = -numCols * (floor(ty) + 1) + floor(tx) + 1
		if (tweak) then
			if (result == 1) then
				return 1
			else
				return nil
			end
		elseif (category == "main") then
			if (result <= #BUILD_CATEGORIES) then
				return result
			else
				return nil
			end
		elseif (category ~= "all") then
			result = result - 1
		end
		if (result > #buildIDs) then
			return nil
		else
			return result
		end
	end
end

local function DrawTextWithBackground(text, x, y, size, opt)
	local width = GetRealTextWidth(text) * size
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	
	glColor(0.25, 0.25, 0.25, 0.75)
	if (opt) then
		if (strFind(opt, "r")) then
			glRect(x, y, x - width, y + size * TEXT_CORRECT_Y)
			return
		elseif (strFind(opt, "c")) then
			glRect(x + width * 0.5, y, x - width * 0.5, y + size * TEXT_CORRECT_Y)
			return
		end
		glRect(x, y, x + width, y + size * TEXT_CORRECT_Y)
	else
		glRect(x, y, x + width, y + size * TEXT_CORRECT_Y)
	end
	
	glText(text, x, y, size, opt)
	
end

------------------------------------------------
--build categories
------------------------------------------------
local function SetupBuildCategories()
	--determine ordering
	
	local orderingInfo = {}
	for unitDefID, unitDef in ipairs(UnitDefs) do
		orderingInfo[unitDefID] = {unitDefID, unitDef.power, unitDef.customParams.sortname or unitDef.humanName}
	end
	
	local function BuildComparator(a, b)
		return a[2] < b[2] or (a[2] == b[2] and a[3] < b[3])
	end
	
	sort(orderingInfo, BuildComparator)
	
	local ordering = {}
	for index, info in ipairs(orderingInfo) do
		ordering[info[1]] = index
	end
	
	--fill table
	for unitDefID, unitDef in ipairs(UnitDefs) do
		unitDefInfo[unitDefID] = {}
		if (unitDef.customParams.buildcategory) then --explicit build category
			unitDefInfo[unitDefID][1] = unitDef.customParams.buildcategory
		elseif (unitDef.speed > 0) then --mobiles
			unitDefInfo[unitDefID][1] = "Mobile"
		elseif (unitDef.extractsMetal > 0) then --mexes
			unitDefInfo[unitDefID][1] = "Econ"
		elseif (unitDef.isFeature or unitDef.canKamikaze) then --fortifications: features and mines
			unitDefInfo[unitDefID][1] = "Fort"
		elseif (unitDef.type == "Factory" and unitDef.buildOptions and unitDef.buildOptions[1]) then --factories with buildoptions
			unitDefInfo[unitDefID][1] = "Fac"
		elseif (unitDef.buildSpeed > 0) then
			unitDefInfo[unitDefID][1] = "Aux"
		elseif (unitDef.stockpileWeaponDef or unitDef.shieldWeaponDef or unitDef.maxWeaponRange > 2048) then
			unitDefInfo[unitDefID][1] = "Strat"
		elseif (unitDef.weapons[1]) then
			unitDefInfo[unitDefID][1] = "Def"
		elseif (unitDef.radarRadius > 0 
				or unitDef.sonarRadius > 0 
				or unitDef.seismicRadius > 0
				or unitDef.jammerRadius > 0 
				or unitDef.sonarJamRadius > 0) then
			unitDefInfo[unitDefID][1] = "Sensor"
		elseif (unitDef.makesMetal > 0
				or unitDef.metalMake - unitDef.metalUpkeep > 0
				or unitDef.tidalGenerator > 0
				or unitDef.windGenerator > 0
				or unitDef.totalEnergyOut > 0
				or unitDef.metalStorage > 0
				or unitDef.energyStorage > 0
				or unitDef.name == "armwin"
				or unitDef.name == "corwin"
				) then
			unitDefInfo[unitDefID][1] = "Econ"
		else
			unitDefInfo[unitDefID][1] = "Misc"
		end
		unitDefInfo[unitDefID][2] = ordering[unitDefID]
		
		--debug
		--Spring.Echo(unitDef.humanName .. ": " .. unitDefInfo[unitDefID][1] .. ", " .. unitDefInfo[unitDefID][2])
	end
end
------------------------------------------------
--drawing
------------------------------------------------
--(0, 0) to (3, -3)
local function DrawMain()
	glLineWidth(lineWidth)
	
	for i=1,#BUILD_CATEGORIES do
		local squareX, squareY = (i - 1) % numCols, - floor((i - 1) / numCols)
		local textX, textY = (i - 1) % numCols + 0.5, -0.5 - floor((i - 1) / numCols) - textSize * 0.6
		local name = BUILD_CATEGORIES[i]
		if (categoryCounts[name] == 1) then --single option tex
			glColor(1, 1, 1, 1)
			glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
			
			--frames
			if (drawFrames) then
				glTexture(true)
				glTexture(frameDir .. name .. frameExt)
				glTexRect(squareX, squareY - 1, squareX + 1, squareY)
				glTexture(false)
			end
			
			glTexture(true)
			glTexture('#' .. categoryUnits[name])
			glTexRect(squareX, squareY - 1, squareX + 1, squareY)
			glTexture(false)
		else --background
			glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
			if (drawFrames) then
				glColor(1, 1, 1, 1)
				glTexture(true)
				glTexture(frameDir .. name .. frameExt)
				glTexRect(squareX, squareY - 1, squareX + 1, squareY)
				glTexture(false)
			else
				glColor(0.25, 0.25, 0.25, 0.75)
				glRect(squareX, squareY - 1, squareX + 1, squareY)
			end
		end
		
		--text
		if (categoryCounts[name] > 0) then
			glColor(1, 1, 1, 1)
			glText(name, textX, textY, textSize, "cn")
		else
			glColor(0, 0, 0, 1)
			glText(name, textX, textY, textSize, "cn")
		end
		
		--grid
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
		glColor(1, 1, 1, 1)
		glTexRect(squareX, squareY - 1, squareX + 1, squareY)
	end
	
end

--(0, 0) to (3, -Y)
local function DrawBuild()
	glLineWidth(lineWidth)
	
	if (category ~= "all") then
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
		if (drawFrames) then
			glColor(1, 1, 1, 1)
			glTexture(true)
			glTexture(":l:" .. LUAUI_DIRNAME .. cancelFrameFile)
			glTexRect(0, 0, 1, -1)
			glTexture(false)
		else
			glColor(0.25, 0.25, 0.25, 0.75)
			glRect(0, 0, 1, -1)
		end
		glColor(1, 1, 1, 1)
		glText("Cancel", 0.5, -0.5, textSize, "cn")
		glText(category, 0.5, -0.5 - textSize * TEXT_CORRECT_Y, textSize, "cn")
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
		glRect(0, 0, 1, -1)
	end
	
	glColor(1, 1, 1, 1)
	
	for i=1,#buildIDs do
		
		local buildID = buildIDs[i]
		--top left reserved for cancel unless category is "all"
		local realI = i
		if (category == "all") then
			realI = realI - 1
		end
		local x, y = realI % numCols, - floor(realI / numCols)
		
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
		
		--test
		if (drawFrames) then
			glTexture(true)
			if (category == "all") then
				glTexture(frameDir .. unitDefInfo[buildID][1] .. frameExt) 
			else
				glTexture(frameDir .. category .. frameExt)
			end
			glTexRect(x, y - 1, x + 1, y)
			glTexture(false)
		end
		
		glTexture(true)
		glTexture('#' .. buildID)
		glTexRect(x, y - 1, x + 1, y)
		glTexture(false)
		
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
		glRect(x, y - 1, x + 1, y)
	end
end

local function DrawTweak()
	glLineWidth(lineWidth)
	
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	glColor(0.25, 0.25, 0.25, 0.75)
	glRect(0, 0, 1, -1)
	glColor(1, 1, 1, 1)
	glText("Move", 0.5, -0.5, textSize, "cn")
	glText("Menu", 0.5, -0.5 - textSize * TEXT_CORRECT_Y, textSize, "cn")
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
	glRect(0, 0, 1, -1)
end

local function DrawUnitTooltip(unitDef, tx, ty)
	if (not unitDef) then return end
	DrawTextWithBackground(
			"\255\255\255\255" .. unitDef.humanName .. 
			" - " .. unitDef.tooltip
			, tx + textSize, ty + textSize * TEXT_CORRECT_Y, textSize)
	local metalCost, energyCost, buildTime = ceil(unitDef.metalCost), ceil(unitDef.energyCost), ceil(unitDef.buildTime)
	if (metalCost ~= energyCost or metalCost ~= buildTime) then
		DrawTextWithBackground(
				"(\255\192\192\192" .. metalCost ..
				"\255\255\255\255" .. " / " ..
				"\255\255\255\1" .. energyCost ..
				"\255\255\255\255" .. " / " ..
				"\255\1\255\1" .. buildTime ..
				"\255\255\255\255" .. ")"
				, tx + textSize, ty, textSize
				)
	else
		DrawTextWithBackground(
			"(\255\255\255\255" .. metalCost .. ")"
			, tx + textSize, ty, textSize)
	end
	local avgWind = 0
	if (unitDef.name=="armwin" or unitDef.name=="corwin") then
		avgWind = (Game.windMin + Game.windMax) * 0.05
	end

	local eMake = (unitDef.energyMake or 0) - (unitDef.energyUpkeep or 0) + (unitDef.tidalGenerator or 0) * Game.tidal + avgWind
	if (eMake > 0.2) then -- produces energy
		local mMake = 0
		if (WG.mexMetal ~= nil) then 
			mMake = energyToExtraM((WG.energy or 0)+ eMake)  - energyToExtraM((WG.energy or 0))
		end
		local sPayback = ""
		if mMake > 0 then 
			local payback = (unitDef.metalCost or 0)/ mMake + (unitDef.energyCost or 0)/eMake	
			sPayback = "- payback time ".. floor(payback/60) .."min " ..floor(payback%60) .. "s"
		end
		DrawTextWithBackground("Produces " .. string.format("%g",ceil(eMake*10)/10) .. " energy "..sPayback, tx+ textSize, ty -textSize* TEXT_CORRECT_Y, textSize)
	end
end

local function DrawTooltip(x, y)
	local tx, ty = TransformMain(x, y)
	local iconID = GetIconID(tx, ty)
	if (not iconID) then return end
	
	--highlight
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	glColor(1, 1, 1, 0.25)
	if (category == "all" or category == "main" or tweak) then
		local x, y = (iconID - 1) % numCols, - floor((iconID - 1) / numCols)
		glRect(x, y - 1, x + 1, y) 
	else
		local x, y = iconID % numCols, - floor(iconID / numCols)
		glRect(x, y - 1, x + 1, y) 
	end
	
	if (tweak) then
		if (iconID == 1) then
			DrawTextWithBackground("\255\255\255\255Drag to move menu", tx + textSize, ty, textSize)
		end
	elseif (category == "main") then
		local name = BUILD_CATEGORIES[iconID]
		if (categoryCounts[name] == 1) then --single unit is not nested
			local buildID = categoryUnits[name]
			local unitDef = UnitDefs[buildID]
			DrawUnitTooltip(unitDef, tx, ty)
		else
			DrawTextWithBackground("\255\255\255\255" .. name, tx + textSize, ty + textSize * TEXT_CORRECT_Y, textSize)
			DrawTextWithBackground("\255\255\255\255(" .. categoryCounts[name] .. " options)", tx + textSize, ty, textSize)
		end
	else
		if (iconID == 0) then
			DrawTextWithBackground("\255\255\255\255Cancel", tx + textSize, ty, textSize)
		else
			local unitDefID = buildIDs[iconID]
			local unitDef = UnitDefs[unitDefID]
			DrawUnitTooltip(unitDef, tx, ty)
		end
	end
	
end

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
	--keep panel in-screen
	if (mainX < 0) then
		mainX = 0
	elseif (mainX > vsx - mainSize * numCols) then
		mainX = vsx - mainSize * numCols
	end
	local numRows = ceil(max(nestThreshold, #BUILD_CATEGORIES) / numCols)
	if (mainY < mainSize * numRows) then
		mainY = mainSize * numRows
	elseif (mainY > vsy) then
		mainY = vsy
	end
end

function widget:DrawScreen()
	if (once) then
		local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
		widget:ViewResize(viewSizeX, viewSizeY)
		once = false
	end
	
	if IsGUIHidden() then return end
	
	glPushMatrix()
		glTranslate(mainX, mainY, 0)
		glScale(mainSize, mainSize, 1)
		if (useLists) then
			if (tweak) then
				glCallList(tweakList)
			else
				glCallList(mainList)
			end
		else
			if (tweak) then
				DrawTweak()
			elseif (category == "main") then
				DrawMain()
			else
				DrawBuild()
			end
		end
		local mx, my = GetMouseState()
		DrawTooltip(mx, my)
	glPopMatrix()
	
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	glColor(1, 1, 1, 1)
	glLineWidth(1)
end

------------------------------------------------
--updates
------------------------------------------------

local function BuildInfoComparator(a, b)
	return unitDefInfo[a][2] < unitDefInfo[b][2]
end

local function UpdateLists()
	if (mainList) then
		glDeleteList(mainList)
	end
	
	if (not useLists) then return end
	
	if (category == "main") then
		mainList = glCreateList(DrawMain)
	elseif (not tweak) then
		mainList = glCreateList(DrawBuild)
	end
end

local function UpdateBuildIDs()
	for i = 1, #BUILD_CATEGORIES do
		local name = BUILD_CATEGORIES[i]
		categoryCounts[name] = 0
		categoryUnits[name] = nil
	end
	
	local alreadySeen = {}
	local totalNumber = 0
	local allBuildIDs = {}
	buildIDs = {}
	local i = 1
	
	local selectedCounts = GetSelectedUnitsCounts()
	for unitDefID, count in pairs(selectedCounts) do
		local unitDef = UnitDefs[unitDefID]
		if (unitDef and unitDef.type == "Builder" and unitDef.buildOptions[1]) then
			for _, buildID in ipairs(unitDef.buildOptions) do
				if (not alreadySeen[buildID]) then
					alreadySeen[buildID] = true
					allBuildIDs[totalNumber + 1] = buildID
					totalNumber = totalNumber + 1
					local buildCategory = unitDefInfo[buildID][1]
					if (categoryCounts[buildCategory]) then
						categoryCounts[buildCategory] = categoryCounts[buildCategory] + 1
						categoryUnits[buildCategory] = buildID
					end
					if (buildCategory == category or category == "all") then
						buildIDs[i] = buildID
						i = i + 1
					end
				end
				
			end
		end
	end
	
	tweak = false
	if (totalNumber == 0) then 
		tweak = true
	elseif (totalNumber <= nestThreshold) then
		category = "all"
		buildIDs = allBuildIDs
	elseif (#buildIDs == 0 
			or (totalNumber > nestThreshold and category == "all")) then
		category = "main"
	end
	
	sort(buildIDs, BuildInfoComparator)
	
	UpdateLists()
end

--doesn't work in all mods
--[[
function widget:SelectionChanged(selection)
	UpdateBuildIDs()
end
]]

function widget:CommandsChanged()
	UpdateBuildIDs()
end


------------------------------------------------
--mouse
------------------------------------------------

local function ProcessIcon(iconID, instantOnly)
	if (tweak) then
		if (iconID == 1 and not instantOnly) then
			activeClick = "move"
			return true
		else
			return false
		end
	elseif (category == "main") then
		local name = BUILD_CATEGORIES[iconID]
		if (not name) then return false end
		if (categoryCounts[name] == 1) then --single unit is not nested
			local alt, ctrl, meta, shift = GetModKeyState()
			local _, _, left, _, right = GetMouseState()
			local buildID = categoryUnits[name]
			local index = GetCmdDescIndex(-buildID)
			SetActiveCommand(index, button, left, right, alt, ctrl, meta, shift)
		else
			category = name
			UpdateBuildIDs()
		end
		return true
	else
		if (iconID > 0 and iconID <= #buildIDs) then
			local alt, ctrl, meta, shift = GetModKeyState()
			local _, _, left, _, right = GetMouseState()
			local index = GetCmdDescIndex(-buildIDs[iconID])
			SetActiveCommand(index, button, left, right, alt, ctrl, meta, shift)
		elseif (iconID ~= 0) then
			return false
		end
		--return to main menu?
		if (iconID == 0 or not cancelOnly) then
			category = "main"
			UpdateLists()
		end
		return true
	end
end

local function ReleaseActiveClick(x, y)
	local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
	widget:ViewResize(viewSizeX, viewSizeY)
	activeClick = nil
end

function widget:MousePress(x, y, button)
	if (IsGUIHidden()) then return end
	local tx, ty = TransformMain(x, y)
	local iconID = GetIconID(tx, ty)
	if (not iconID) then return end
	
	return ProcessIcon(iconID, false)
end

function widget:MouseRelease(x, y, button)
	if (activeClick) then
		ReleaseActiveClick(x, y)
		return true
	end
	return false
end

function widget:MouseMove(x, y, dx, dy, button)
	if (activeClick == "move") then
		mainX = mainX + dx
		mainY = mainY + dy
	end
end

------------------------------------------------
--bindings
------------------------------------------------

local function PressIcon(_,_,words)
	if (IsGUIHidden()) then return end
	local iconID = tonumber(words[1])
	if (not iconID) then return end
	
	--account for cancel button
	if (category ~= "all" and category ~= "main" and not tweak) then
		iconID = iconID - 1
	end
	
	ProcessIcon(iconID, true)
end

local function ChangeSize(_,_,words)
	local newSize = tonumber(words[1])
	if (newSize and newSize >= 1) then
		mainSize = newSize
		local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
		widget:ViewResize(viewSizeX, viewSizeY)
	else
		Spring.Echo("<Nested Buildmenu>: Invalid size.")
	end
end

local function ChangeCols(_,_,words)
	local newCols = tonumber(words[1])
	if (newCols and newCols >= 1) then
		numCols = newCols
		local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
		widget:ViewResize(viewSizeX, viewSizeY)
	else
		Spring.Echo("<Nested Buildmenu>: Invalid number of columns.")
	end
end

local function ToggleCancelOnly()
	cancelOnly = not cancelOnly
	if (cancelOnly) then
		Spring.Echo("<Nested Buildmenu>: Now only returns to main menu on cancel.")
	else
		Spring.Echo("<Nested Buildmenu>: Now only automatically returns to main menu.")
	end
end

local function ToggleUseLists()
	useLists = not useLists
	if (useLists) then
		Spring.Echo("<Nested Buildmenu>: Now using display lists.")
		tweakList = glCreateList(DrawTweak)
		UpdateLists()
	else
		Spring.Echo("<Nested Buildmenu>: Now not using display lists.")
		if (tweakList) then
			glDeleteList(tweakList)
		end
		if (mainList) then
			glDeleteList(mainList)
		end
	end
end

------------------------------------------------
--other callins
------------------------------------------------
function widget:Initialize()
	once = true
	SetupBuildCategories()
	category = startCategory
	tweak = true
	UpdateBuildIDs()
	widgetHandler:AddAction("nested_buildmenu_press", PressIcon, nil, "t")
	widgetHandler:AddAction("nested_buildmenu_size", ChangeSize, nil, "t")
	widgetHandler:AddAction("nested_buildmenu_cols", ChangeCols, nil, "t")
	widgetHandler:AddAction("nested_buildmenu_cancelonly", ToggleCancelOnly, nil, "t")
	widgetHandler:AddAction("nested_buildmenu_uselists", ToggleUseLists, nil, "t")
	
	drawFrames = VFS.FileExists(LUAUI_DIRNAME .. cancelFrameFile)
	
	tweakList = glCreateList(DrawTweak)
end

function widget:Shutdown()
	widgetHandler:RemoveAction("nested_buildmenu_press")
	widgetHandler:RemoveAction("nested_buildmenu_size")
	widgetHandler:RemoveAction("nested_buildmenu_cols")
	widgetHandler:RemoveAction("nested_buildmenu_cancelonly")
	widgetHandler:RemoveAction("nested_buildmenu_uselists")
	
	if (tweakList) then
		glDeleteList(tweakList)
	end
	if (mainList) then
		glDeleteList(mainList)
	end
end

