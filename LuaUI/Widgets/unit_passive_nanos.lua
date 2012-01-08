
function widget:GetInfo()
	return {
		name      = "Passive Nanos",
		desc      = "Toggle for active/passive nanos",
		author    = "Niobium",
		version   = "1.0",
		date      = "10th Mar 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------
local buttonWidth = 32
local buttonHeight = 32
local buttonBorderSize = 2

--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------
local wl, wt = 200, 200
local buttonTex -- Set on :Initialize
local passiveOn = false
local areDragging = false

--------------------------------------------------------------------------------
-- Speedups
--------------------------------------------------------------------------------
local glColor = gl.Color
local glRect = gl.Rect
local glTexture = gl.Texture
local glTexRect = gl.TexRect

local spGetMyTeamID = Spring.GetMyTeamID
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGiveOrderToUnitArray = Spring.GiveOrderToUnitArray
local spGetTeamUnits = Spring.GetTeamUnits
local spGetUnitDefID = Spring.GetUnitDefID

local armNano = UnitDefNames.armnanotc.id
local corNano = UnitDefNames.cornanotc.id

local CMD_PASSIVE = 34571

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function widget:Initialize()
	local _, _, _, _, mySide = Spring.GetTeamInfo(spGetMyTeamID())
	if mySide and (mySide == "core") then
		buttonTex = "#" .. corNano
	else
		buttonTex = "#" .. armNano
	end
end

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------
function widget:GetConfigData()
	local wWidth, wHeight = Spring.GetWindowGeometry()
	return {wl / wWidth, wt / wHeight, passiveOn}
end
function widget:SetConfigData(data)
	local wWidth, wHeight = Spring.GetWindowGeometry()
	wl = math.floor(wWidth * (data[1] or 0.75))
	wt = math.floor(wHeight * (data[2] or 0.50))
	passiveOn = data[3]
end

--------------------------------------------------------------------------------
-- Drawing
--------------------------------------------------------------------------------
function widget:DrawScreen()
	
	glColor(0, 0, 0, 1)
	glRect(wl - buttonBorderSize, wt + buttonBorderSize, wl + buttonWidth + buttonBorderSize, wt - buttonHeight - buttonBorderSize)
	
	if passiveOn then
		glColor(0.5, 0.5, 0.5, 1)
	else
		glColor(1, 1, 1, 1)
	end
	
	glTexture(buttonTex)
		glTexRect(wl, wt - buttonHeight, wl + buttonWidth, wt)
	glTexture(false)
end

--------------------------------------------------------------------------------
-- Unit
--------------------------------------------------------------------------------
function widget:UnitCreated(uID, uDefID, uTeam)
	if passiveOn and ((uDefID == armNano) or (uDefID == corNano)) and (uTeam == spGetMyTeamID()) then
		spGiveOrderToUnit(uID, CMD_PASSIVE, {1}, {})
	end
end
function widget:UnitGiven(uID, uDefID, newTeam, oldTeam)
	if ((uDefID == armNano) or (uDefID == corNano)) and (newTeam == spGetMyTeamID()) then
		spGiveOrderToUnit(uID, CMD_PASSIVE, {passiveOn and 1 or 0}, {})
	end
end

--------------------------------------------------------------------------------
-- Mouse
--------------------------------------------------------------------------------
function widget:IsAbove(mx, my)
	return (mx >= wl) and (mx <= wl + buttonWidth) and (my <= wt) and (my >= wt - buttonHeight)
end
function widget:GetTooltip(mx, my)
	return (passiveOn and "Switch to active nanos" or "Switch to passive nanos") .. "\nHold right-click to drag"
end
function widget:MousePress(mx, my, mButton)
	
	if not widget:IsAbove(mx, my) then return false end
	
	if mButton == 1 then
		
		passiveOn = not passiveOn
		
		local myNanos = {}
		local myUnits = spGetTeamUnits(spGetMyTeamID())
		for u = 1, #myUnits do
			local uID = myUnits[u]
			local uDefID = spGetUnitDefID(uID)
			if (uDefID == armNano) or (uDefID == corNano) then
				myNanos[#myNanos + 1] = uID
			end
		end
		
		spGiveOrderToUnitArray(myNanos, CMD_PASSIVE, {passiveOn and 1 or 0}, {})
		return true
	else
		if mButton == 3 then
			areDragging = true
			return true
		end
	end
	
	return false
end
function widget:MouseMove(mx, my, dx, dy, mButton)
	if areDragging then
		wl = wl + dx
		wt = wt + dy
	end
end
function widget:MouseRelease()
	areDragging = false
end
