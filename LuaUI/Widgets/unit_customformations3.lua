
function widget:GetInfo()
	return {
		name      = "customformations3",
		desc      = "Allows you to draw your own formation line.",
		author    = "bishop181", -- Based on 'Custom Formations2 (v3.0)' by Niobium Which is based on 'Custom Formations' by jK and gunblob
		version   = "v3.1.01",
		date      = "June, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 10000,
		enabled   = false,
		handler   = true,
	}
end

--------------------------------------------------------------------------------
-- User Configurable Constants
--------------------------------------------------------------------------------
-- Minimum spacing between commands (Squared) when drawing a path for a single unit, must be >16*16 (Or orders overlap and cancel)
local minPathSpacingSq = 50 * 50

-- How long should algorithms take. (~0.1 gives visible stutter, default: 0.05)
local maxHngTime = 0.05 -- Desired maximum time for hungarian algorithm
local maxNoXTime = 0.05 -- Strict maximum time for backup algorithm

local defaultHungarianUnits	= 20 -- Need a baseline to start from when no config data saved
local minHungarianUnits		= 10 -- If we kept reducing maxUnits it can get to a point where it can never increase, so we enforce minimums on the algorithms.
local unitIncreaseThresh	= 0.85 -- We only increase maxUnits if the units are great enough for time to be meaningful

-- Alpha loss per second after releasing mouse
local lineFadeRate = 2.0

-- What commands are eligible for custom formations
local formationCmds = {
	[CMD.MOVE] = true,
	[CMD.FIGHT] = true,
	[CMD.ATTACK] = true,
	[CMD.PATROL] = true,
	[CMD.UNLOAD_UNIT] = true,
	[38521] = true -- Jump
}

-- What commands require alt to be held (Must also appear in formationCmds)
local requiresAlt = {
	[CMD.ATTACK] = true,
	[CMD.UNLOAD_UNIT] = true
}

-- What commands are issued at a position or unit/feature ID (Only used by GetUnitPosition)
local positionCmds = {
	[CMD.MOVE]=true,		[CMD.ATTACK]=true,		[CMD.RECLAIM]=true,		[CMD.RESTORE]=true,		[CMD.RESURRECT]=true,
	[CMD.PATROL]=true,		[CMD.CAPTURE]=true,		[CMD.FIGHT]=true, 		[CMD.DGUN]=true,		[38521]=true, -- jump
	[CMD.UNLOAD_UNIT]=true,	[CMD.UNLOAD_UNITS]=true,[CMD.LOAD_UNITS]=true,
}

--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------
local maxHungarianUnits = defaultHungarianUnits -- Also set when loading config

local fNodes = {} -- Formation nodes, filled as we draw
local fDists = {} -- fDists[i] = distance from node 1 to node i
local totaldxy = 0 -- Measure of distance mouse has moved, used to unjag lines drawn in minimap

local dimmCmd = nil -- The dimming command (Used for color)
local dimmNodes = {} -- The current nodes of dimming line
local dimmAlpha = 0 -- The current alpha of dimming line

local pathCandidate = false -- True if we should start a path on mouse move
local draggingPath = false -- True if we are dragging a path for unit(s) to follow
local lastPathPos = nil -- The last point added to the path, used for min-distance check

local usingCmd = nil -- The command to execute across the line
local usingRMB = false -- If the command is the default it uses right click, otherwise it is active and uses left click
local inMinimap = false -- Is the line being drawn in the minimap
local endShift = false -- True to reset command when shift is released

local MiniMapFullProxy = (Spring.GetConfigInt("MiniMapFullProxy", 0) == 1)

--------------------------------------------------------------------------------
-- Speedups
--------------------------------------------------------------------------------
local GL_LINE_STRIP = GL.LINE_STRIP
local glVertex = gl.Vertex
local glLineStipple = gl.LineStipple
local glLineWidth = gl.LineWidth
local glColor = gl.Color
local glBeginEnd = gl.BeginEnd
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glScale = gl.Scale
local glTranslate = gl.Translate
local glLoadIdentity = gl.LoadIdentity

local spGetActiveCommand = Spring.GetActiveCommand
local spSetActiveCommand = Spring.SetActiveCommand
local spGetDefaultCommand = Spring.GetDefaultCommand
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spGetModKeyState = Spring.GetModKeyState
local spGetInvertQueueKey = Spring.GetInvertQueueKey
local spIsAboveMiniMap = Spring.IsAboveMiniMap
local spGetSelectedUnitCount = Spring.GetSelectedUnitsCount
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGiveOrder = Spring.GiveOrder
local spGetUnitIsTransporting = Spring.GetUnitIsTransporting
local spGetCommandQueue = Spring.GetCommandQueue
local spGetUnitPosition = Spring.GetUnitPosition
local spTraceScreenRay = Spring.TraceScreenRay
local spGetGroundHeight = Spring.GetGroundHeight
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitDefID =  Spring.GetUnitDefID
local spGetUnitHealth = Spring.GetUnitHealth
local Echo = Spring.Echo

local mapSizeX, mapSizeZ = Game.mapSizeX, Game.mapSizeZ
local maxUnits = Game.maxUnits

local osclock = os.clock
local tsort = table.sort
local ceil = math.ceil
local sqrt = math.sqrt
local huge = math.huge

local CMD_INSERT = CMD.INSERT
local CMD_MOVE = CMD.MOVE
local CMD_ATTACK = CMD.ATTACK
local CMD_UNLOADUNIT = CMD.UNLOAD_UNIT
local CMD_UNLOADUNITS = CMD.UNLOAD_UNITS
local CMD_OPT_ALT = CMD.OPT_ALT
local CMD_OPT_CTRL = CMD.OPT_CTRL
local CMD_OPT_META = CMD.OPT_META
local CMD_OPT_SHIFT = CMD.OPT_SHIFT
local CMD_OPT_RIGHT = CMD.OPT_RIGHT

local SECOND_ROW = 56

local keyShift = 304

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------
local function GetUnitsGroup(mUnits)

	local rows=0 --allways start from 0

	local higmidlow = {}
	local found=false
	local min1=0
	local max1=0

	
	
	-- for id,unitDef in pairs(UnitDefs) do
		--for name,param in unitDef:pairs() do
		--end
	-- end
	
	
	--this loop works out how many rows there should be & sets the max & min hp/cost
	for i=1, #mUnits do
	
		local unit = mUnits[i]
	
	
		if UnitDefs[spGetUnitDefID(unit)]["buildSpeed"] >0 then --if it can build, do nothing, since it it will go in last row anyway, This stop having the command in selection, messing everything up
			-- ensure there are atleast 2 rows
			if(rows==0) then
				rows=1
			end
			if(rows == 1 and #higmidlow > 0) then --make sure theres actuly stuff to go in the front row
				rows=2
			end
		else
			local temp = UnitDefs[spGetUnitDefID(unit)]["metalCost"]/UnitDefs[spGetUnitDefID(unit)]["health"]

			
			for j,t in ipairs(higmidlow) do
				if(t == temp) then
					found=true
				end
			end
			if found==false then -- add row
				rows=rows+1
				table.insert(higmidlow, temp)
				
				if ((temp<min1) or (min1==0)) then
					min1 = temp
				end
				if temp>max1 then
					max1 = temp
				end
			end
			found=false
		end
	end
	
	
	if(rows>3) then rows=3 end
	local out = {}
	
	--initilize out (the return table)
	
	for i=1, rows do -- initilize the rows
		--if (out[i]==nil) then out[i] = {} end
		out[i] = out[i] or {}
	end
	
	-- put the units in their appropriat rows
	for j=1, #mUnits do
		local unit = mUnits[j]
	
		local temp = UnitDefs[spGetUnitDefID(unit)]["metalCost"]/UnitDefs[spGetUnitDefID(unit)]["health"]
		
		
		if(UnitDefs[spGetUnitDefID(unit)]["buildSpeed"]>0) then -- if cant fight put in last row
			table.insert(out[rows], unit)
		else
		
			
		
			local temp1 = temp
		
			if(UnitDefs[spGetUnitDefID(unit)]['highTrajectoryType']==0) then -- if low trajectory, add weight
				temp=temp/1.30 --increase chance of being in front row, 
				-- arrr, some artilary doesnt have a high trajectory
			else
				temp=temp/0.85 --artilary @ back
			end
			
			
			local tmphealth, tmpmaxhelth = spGetUnitHealth(unit);
			-- if is dammaged, move back
			if(tmphealth/tmpmaxhelth < 0.9) then --add weight
				temp=temp/0.40 --buy alot
			end
			
			for i=1, rows do --for each unit
				if (out[i]==nil) then out[i] = {} end
				if temp <= (((max1 - min1)/rows) * i) + min1 or i == rows then --if is last, then put in last row
					table.insert(out[i], unit)
					break
				end
			end
		end
	end
	--[[
	for i,a in ipairs(out) do
		for j, b in ipairs(a) do
		end
	end
	]]--
	return out
end
local function GetModKeys()
	
	local alt, ctrl, meta, shift = spGetModKeyState()
	
	if spGetInvertQueueKey() then -- Shift inversion
		shift = not shift
	end
	
	return alt, ctrl, meta, shift
end
local function GetUnitFinalPosition(uID)
	
	local ux, uy, uz = spGetUnitPosition(uID)
	local cmds = spGetCommandQueue(uID)
	for i = #cmds, 1, -1 do
		
		local cmd = cmds[i]
		if (cmd.id < 0) or positionCmds[cmd.id] then
			
			local params = cmd.params
			if (#params >= 3) then
				return params[1], params[2], params[3]
			else
				if (#params == 1) then
					
					local pID = params[1]
					local px, py, pz
					
					if pID > maxUnits then
						px, py, pz = spGetFeaturePosition(pID - maxUnits)
					else
						px, py, pz = spGetUnitPosition(pID)
					end
					
					if px then
						return px, py, pz
					end
				end
			end
		end
	end
	
	return ux, uy, uz
end
local function SetColor(cmdID, alpha)
	if (cmdID == CMD_MOVE) then glColor(0.5, 1.0, 0.5, alpha) -- Green
	elseif (cmdID == CMD_ATTACK) then glColor(1.0, 0.2, 0.2, alpha) -- Red
	elseif (cmdID == CMD_UNLOADUNIT) then glColor(1.0, 1.0, 0.0, alpha) -- Yellow
	else glColor(0.5, 0.5, 1.0, alpha) -- Blue
	end
end
local function CanUnitExecute(uID, cmdID)
	
	if cmdID == CMD_UNLOADUNIT then
		local transporting = spGetUnitIsTransporting(uID)
		return (transporting and #transporting > 0)
	end
	
	return (spFindUnitCmdDesc(uID, cmdID) ~= nil)
end
local function GetExecutingUnits(cmdID)
	local units = {}
	local selUnits = spGetSelectedUnits()
	for i = 1, #selUnits do
		local uID = selUnits[i]
		if CanUnitExecute(uID, cmdID) then
			units[#units + 1] = uID
		end
	end
	return units
end
local function AddFNode(pos)
	
	local n = #fNodes
	if n == 0 then
		fNodes[1] = pos
		fDists[1] = 0
	else
		local prevNode = fNodes[n]
		local dx, dz = pos[1] - prevNode[1], pos[3] - prevNode[3]
		local distSq = dx*dx + dz*dz
		if distSq == 0.0 then -- Don't add if duplicate
			return false
		end
		
		fNodes[n + 1] = pos
		fDists[n + 1] = fDists[n] + sqrt(distSq)
	end
	
	totaldxy = 0
	return true
end

local function GetInterpNodes2(number)


	local spacing = fDists[#fNodes] / (number - 1)
	
	local interpNodes = {}
	
	local sPos = fNodes[1]
	local sX = sPos[1]
	local sZ = sPos[3]
	local sDist = 0
	
	local eIdx = 2
	local ePos = fNodes[2]
	local eX = ePos[1]
	local eZ = ePos[3]
	local eDist = fDists[2]
	
	interpNodes[1] = {sX, spGetGroundHeight(sX, sZ), sZ}
	
	for n = 1, (number - 2) do
		local reqDist = n * spacing
		while (reqDist > eDist) do
			
			sX = eX
			sZ = eZ
			sDist = eDist
			
			eIdx = eIdx + 1
			ePos = fNodes[eIdx]
			eX = ePos[1]
			eZ = ePos[3]
			eDist = fDists[eIdx]
		end
		
		local nFrac = (reqDist - sDist) / (eDist - sDist)
		local nX = sX * (1 - nFrac) + eX * nFrac
		local nZ = sZ * (1 - nFrac) + eZ * nFrac
		interpNodes[n + 1] = {nX, spGetGroundHeight(nX, nZ), nZ}
	end
	
	ePos = fNodes[#fNodes]
	eX = ePos[1]
	eZ = ePos[3]
	interpNodes[number] = {eX, spGetGroundHeight(eX, eZ), eZ}
	
	return interpNodes
end

local function GetInterpNodes(number, row) 


	if row==nil or row==0 or row==1 then
		return GetInterpNodes2(number) --old method, should be quicker.
	else
		row = row-1
	end
	
	local spacing = fDists[#fNodes] / (number - 1)
	
	local interpNodes = {}
	
	local sPos = fNodes[1]
	local sX = sPos[1]
	local sZ = sPos[3]
	local sDist = 0
	
	local eIdx = 2
	local ePos = fNodes[2]
	local eX = ePos[1]
	local eZ = ePos[3]
	local eDist = fDists[2]
	
	local tX =0
	local tZ =0
	local tDist={}
	local normX =0
	local normY =0
	local newX = 0
	local newZ = 0
	
	local nX = 0 --needs to be outside, because i need to use it
	local nZ = 0
	
	local dev = 0
	
	-- /////////////////////////
		local reqDist = 1 * spacing
		local tDist = 0
		local tIdx = 2
		if(#fNodes<=2 or number == 1 or true) then
		
		
			tIdx = 5
			ePos = fNodes[2]
			tX = ePos[1] --find the correct node
			tZ = ePos[3]
			tDist = fDists[tIdx]
		else
			--needs fixing, will break if only 2 or less nodes. needs to use frac
			while (reqDist > tDist) do --aa quap, if unit is 2 it breaks
				
				--sX = eX
				--sZ = eZ
				--sDist = eDist --acumilativ dist
				tIdx = tIdx + 1
				ePos = fNodes[tIdx]
				tX = ePos[1] --find the correct node
				tZ = ePos[3]
				tDist = fDists[tIdx]
			end
		end
		
		nX = tX
		nZ = tZ
		
		
		--needs rotating the other way
	
		
		normX = tX - sX -- put origen to 0
		normZ = tZ - sZ --put origen to 0
		normX = -normX
		normZ = -normZ
		-- rotate
		newX = 0 + normZ
		newZ = -normX + 0
		-- normalize
		dev = newX*newX + newZ*newZ
		dev = sqrt(dev)/(SECOND_ROW*row) --length should be 16
		newX=newX/dev
		newZ=newZ/dev
		-- reset the origen
		newX = newX + sX
		newZ = newZ + sZ
		
	interpNodes[1] = {newX, spGetGroundHeight(newX, newZ), newZ}
	-- /////////////////////////
	
	for n = 1, (number - 2) do --leave the last one, since i might be crashing things
	
			
		local reqDist = n * spacing
		while (reqDist > eDist) do
			
			sX = eX
			sZ = eZ
			sDist = eDist --acumilativ dist
			
			eIdx = eIdx + 1
			ePos = fNodes[eIdx]
			
			
			eX = ePos[1] --find the correct node
			eZ = ePos[3]
			eDist = fDists[eIdx]
		end
		
		
		
		local nFrac = (reqDist - sDist) / (eDist - sDist)
		nX = sX * (1 - nFrac) + eX * nFrac
		nZ = sZ * (1 - nFrac) + eZ * nFrac
		normX = sX - nX -- put origen to 0
		normZ = sZ - nZ --put origen to 0
		-- rotate
		newX = 0 + normZ
		newZ = -normX + 0
		-- normalize
		dev = newX*newX + newZ*newZ
		dev = sqrt(dev)/(SECOND_ROW*row) --length should be 16
		newX=newX/dev
		newZ=newZ/dev
		-- reset the origen
		newX = newX + nX
		newZ = newZ + nZ
		
		interpNodes[n + 1] = {newX, spGetGroundHeight(newX, newZ), newZ}
	end
	
	--ePos = fNodes[#fNodes]
	--eX = ePos[1]
	--eZ = ePos[3]
	
	--t/ last node
	
	ePos = fNodes[#fNodes]
	eX = ePos[1]
	eZ = ePos[3]
	
	if(#fNodes > 1) then --problem less nodes than units, so make nX & nZ
		-- nX = fNodes[eIdx][1] --since eIdx shouldnt be incremented
		-- nZ=fNodes[eIdx][3]
		-- nX
		-- nZ
	else
		ePos = fNodes[#fNodes-1]
		nX = ePos[1]
		nZ = ePos[3]
		
	end
	normX = nX - eX
	normZ = nZ - eZ
	
	
	newX = -newX
	newZ = -newZ
	--rotate
	newX = 0 + normZ
	newZ = -normX + 0
	
	
	--normalize
	dev = newX*newX + newZ*newZ
	dev=sqrt(dev)/(SECOND_ROW*row)
	newX = newX/dev
	newZ =newZ/dev
	-- reset the origen
	newX = newX + eX
	newZ = newZ + eZ
	
	interpNodes[number] = {newX, spGetGroundHeight(newX, newZ), newZ }
	
	return interpNodes
end
local function GetCmdOpts(alt, ctrl, meta, shift, right)
	
	local opts = { alt=alt, ctrl=ctrl, meta=meta, shift=shift, right=right }
	local coded = 0
	
	if alt   then coded = coded + CMD_OPT_ALT   end
	if ctrl  then coded = coded + CMD_OPT_CTRL  end
	if meta  then coded = coded + CMD_OPT_META  end
	if shift then coded = coded + CMD_OPT_SHIFT end
	if right then coded = coded + CMD_OPT_RIGHT end
	
	opts.coded = coded
	return opts
end
local function GetCmdOptsArray(cmdOpts)
	
	local optsArray = {}
	
	if cmdOpts.alt   then optsArray[             1] = "alt"   end
	if cmdOpts.ctrl  then optsArray[#optsArray + 1] = "ctrl"  end
	if cmdOpts.meta  then optsArray[#optsArray + 1] = "meta"  end
	if cmdOpts.shift then optsArray[#optsArray + 1] = "shift" end
	if cmdOpts.right then optsArray[#optsArray + 1] = "right" end
	
	return optsArray
end
local function GiveNotifyingOrder(cmdID, cmdParams, cmdOpts)
	
	if widgetHandler:CommandNotify(cmdID, cmdParams, cmdOpts) then
		return
	end
	
	spGiveOrder(cmdID, cmdParams, GetCmdOptsArray(cmdOpts))
end
local function GiveNotifyingOrderToUnit(uID, cmdID, cmdParams, cmdOpts)
	
	for _, w in ipairs(widgetHandler.widgets) do
		if w.UnitCommandNotify and w:UnitCommandNotify(uID, cmdID, cmdParams, cmdOpts) then
			return
		end
	end
	
	spGiveOrderToUnit(uID, cmdID, cmdParams, GetCmdOptsArray(cmdOpts))
end

--------------------------------------------------------------------------------
-- Mouse/keyboard Callins
--------------------------------------------------------------------------------
function widget:MousePress(mx, my, mButton)
	
	-- Get command that would've been issued
	local _, activeCmdID = spGetActiveCommand()
	if activeCmdID then
		if mButton ~= 1 then return false end
		
		usingCmd = activeCmdID
		usingRMB = false
	else
		if mButton ~= 3 then return false end
		
		local _, defaultCmdID = spGetDefaultCommand()
		if not defaultCmdID then return false end
		
		usingCmd = defaultCmdID
		usingRMB = true
	end
	
	-- Without this, the unloads issued will use the area of the last area unload
	if usingCmd == CMD_UNLOADUNITS then
		usingCmd = CMD_UNLOADUNIT
	end
	
	-- Is this command eligible for a custom formation ?
	local alt, ctrl, meta, shift = GetModKeys()
	if not (formationCmds[usingCmd] and (alt or not requiresAlt[usingCmd])) then
		return false
	end
	
	-- Get clicked position
	inMinimap = spIsAboveMiniMap(mx, my)
	if inMinimap and not MiniMapFullProxy then return false end
	local _, pos = spTraceScreenRay(mx, my, true, inMinimap)
	if not pos then return false end
	
	-- Setup formation node array
	AddFNode(pos)
	
	-- Is this line a path candidate
	pathCandidate = (spGetSelectedUnitCount() == 1) or (alt and not requiresAlt[usingCmd])
	
	-- We handled the mouse press
	return true
end
function widget:MouseMove(mx, my, dx, dy, mButton)
	
	-- It is possible for MouseMove to fire after MouseRelease
	if #fNodes == 0 then
		return false
	end
	
	-- Minimap-specific checks
	if inMinimap then
		totaldxy = totaldxy + dx*dx + dy*dy
		if (totaldxy < 5) or not spIsAboveMiniMap(mx, my) then
			return false
		end
	end
	
	-- Get clicked position
	local _, pos = spTraceScreenRay(mx, my, true, inMinimap)
	if not pos then return false end
	
	-- Add the new formation node
	if not AddFNode(pos) then return false end
	
	-- Have we started drawing a line?
	if #fNodes == 2 then
		
		-- We have enough nodes to start drawing now
		widgetHandler:UpdateWidgetCallIn("DrawInMiniMap", self)
		widgetHandler:UpdateWidgetCallIn("DrawWorld", self)
		
		-- If the line is a path, start the units moving to this node
		if pathCandidate then
			
			local alt, ctrl, meta, shift = GetModKeys()
			local cmdOpts = GetCmdOpts(false, ctrl, meta, shift, usingRMB) -- using alt uses springs box formation, so we set it off always
			GiveNotifyingOrder(usingCmd, pos, cmdOpts)
			lastPathPos = pos
			
			draggingPath = true
		end
	else
		-- Are we dragging a path?
		if draggingPath then
			
			local dx, dz = pos[1] - lastPathPos[1], pos[3] - lastPathPos[3]
			if (dx*dx + dz*dz) > minPathSpacingSq then
				
				local alt, ctrl, meta, shift = GetModKeys()
				local cmdOpts = GetCmdOpts(false, ctrl, meta, true, usingRMB) -- using alt uses springs box formation, so we set it off always
				GiveNotifyingOrder(usingCmd, pos, cmdOpts)
				lastPathPos = pos
			end
		end
	end
	
	return false
end
function widget:MouseRelease(mx, my, mButton)
	
	
	-- It is possible for MouseRelease to fire after MouseRelease
	if #fNodes == 0 then
		return false
	end
	
	-- Modkeys / command reset
	local alt, ctrl, meta, shift = GetModKeys()
	if not usingRMB then
		if shift then
			endShift = true -- Reset on release of shift
		else
			spSetActiveCommand(0) -- Reset immediately
		end
	end
	
	-- Add final position (Sometimes we don't get the last MouseMove before this MouseRelease)
	if (not inMinimap) or spIsAboveMiniMap(mx, my) then
		local _, pos = spTraceScreenRay(mx, my, true, inMinimap)
		if pos then
			AddFNode(pos)
		end
	end
	
	-- Unit Path
	if draggingPath then
		draggingPath = false
		
	else
		-- Get command options
		local cmdOpts = GetCmdOpts(alt, ctrl, meta, shift, usingRMB)
		
		-- Single click ? (no line drawn)
		if (#fNodes == 1) then
			GiveNotifyingOrder(usingCmd, fNodes[1], cmdOpts)
		else
			-- Order is a formation
			local mUnits = GetExecutingUnits(usingCmd)
			if #mUnits > 0 then
				
				local groupunits = GetUnitsGroup(mUnits)
				for i=1, #groupunits do
					
					mUnits = groupunits[i]
					
					local interpNodes = GetInterpNodes(#mUnits,i)
					
					local orders
					if (#mUnits <= maxHungarianUnits) then

						orders = GetOrdersHungarian(interpNodes, mUnits, #mUnits, shift and not meta)
					else
						orders = GetOrdersNoX(interpNodes, mUnits, #mUnits, shift and not meta)
					end
					
					if meta then
						local altOpts = GetCmdOpts(true, false, false, false, false)
						for i = 1, #orders do
							local orderPair = orders[i]
							local orderPos = orderPair[2]
							GiveNotifyingOrderToUnit(orderPair[1], CMD_INSERT, {0, usingCmd, cmdOpts.coded, orderPos[1], orderPos[2], orderPos[3]}, altOpts)
						end
					else
						for i = 1, #orders do
							local orderPair = orders[i]
							GiveNotifyingOrderToUnit(orderPair[1], usingCmd, orderPair[2], cmdOpts)
						end
					end
				end
			end
		end
	end
	
	if #fNodes > 1 then
		dimmCmd = usingCmd
		dimmNodes = fNodes
		dimmAlpha = 1.0
		widgetHandler:UpdateWidgetCallIn("Update", self)
	end
	
	fNodes = {}
	fDists = {}
	
	return true
end
function widget:KeyRelease(key)
	if (key == keyShift) and endShift then
		spSetActiveCommand(0)
		endShift = false
	end
end

--------------------------------------------------------------------------------
-- Drawing
--------------------------------------------------------------------------------
local function tVerts(verts)
	for i = 1, #verts do
		local v = verts[i]
		glVertex(v[1], v[2], v[3])
	end
end
local function tVertsMinimap(verts)
	for i = 1, #verts do
		local v = verts[i]
		glVertex(v[1], v[3], 1)
	end
end
local function DrawFormationLines(vertFunction, lineStipple)
	
	glLineStipple(lineStipple, 4095)
	glLineWidth(2.0)
	
	if #fNodes > 1 then
		SetColor(usingCmd, 1.0)
		glBeginEnd(GL_LINE_STRIP, vertFunction, fNodes)
	end
	
	if #dimmNodes > 1 then
		SetColor(dimmCmd, dimmAlpha)
		glBeginEnd(GL_LINE_STRIP, vertFunction, dimmNodes)
	end
	
	glLineWidth(1.0)
	glLineStipple(false)
end

function widget:DrawWorld()
	
	DrawFormationLines(tVerts, 2)
end
function widget:DrawInMiniMap()
	
	glPushMatrix()
		glLoadIdentity()
		glTranslate(0, 1, 0)
		glScale(1 / mapSizeX, -1 / mapSizeZ, 1)
		
		DrawFormationLines(tVertsMinimap, 1)
	glPopMatrix()
end
function widget:Update(deltaTime)
	
	dimmAlpha = dimmAlpha - lineFadeRate * deltaTime
	
	if dimmAlpha <= 0 then
		
		dimmNodes = {}
		widgetHandler:RemoveWidgetCallIn("Update", self)
		
		if #fNodes == 0 then
			widgetHandler:RemoveWidgetCallIn("DrawWorld", self)
			widgetHandler:RemoveWidgetCallIn("DrawInMiniMap", self)
		end
	end
end

---------------------------------------------------------------------------------------------------------
-- Config
---------------------------------------------------------------------------------------------------------
function widget:GetConfigData() -- Saving
	return {
		['maxHungarianUnits'] = maxHungarianUnits,
	}
end
function widget:SetConfigData(data) -- Loading
	maxHungarianUnits = data['maxHungarianUnits'] or defaultHungarianUnits
end

---------------------------------------------------------------------------------------------------------
-- Matching Algorithms
---------------------------------------------------------------------------------------------------------
function GetOrdersNoX(nodes, units, unitCount, shifted)
	
	
	
	-- Remember when  we start
	-- This is for capping total time
	-- Note: We at least complete initial assignment
	local startTime = osclock()
	
	---------------------------------------------------------------------------------------------------------
	-- Find initial assignments
	---------------------------------------------------------------------------------------------------------
	local unitSet = {}
	local fdist = -1
	local fm
	
	for u = 1, unitCount do
		
		-- Get unit position
		local ux, uz
		if shifted then
			ux, _, uz = GetUnitFinalPosition(units[u])
		else
			ux, _, uz = spGetUnitPosition(units[u])
		end
		unitSet[u] = {ux, units[u], uz, -1} -- Such that x/z are in same place as in nodes (So we can use same sort function)
		
		-- Work on finding furthest points (As we have ux/uz already)
		for i = u - 1, 1, -1 do
			
			local up = unitSet[i]
			local vx, vz = up[1], up[3]
			local dx, dz = vx - ux, vz - uz
			local dist = dx*dx + dz*dz
			
			if (dist > fdist) then
				fdist = dist
				fm = (vz - uz) / (vx - ux)
			end
		end
	end
	
	-- Maybe nodes are further apart than the units
	for i = 1, unitCount - 1 do
		
		local np = nodes[i]
		local nx, nz = np[1], np[3]
		
		for j = i + 1, unitCount do
			
			local mp = nodes[j]
			local mx, mz = mp[1], mp[3]
			local dx, dz = mx - nx, mz - nz
			local dist = dx*dx + dz*dz
			
			if (dist > fdist) then
				fdist = dist
				fm = (mz - nz) / (mx - nx)
			end
		end
	end
	
	local function sortFunc(a, b)
		-- y = mx + c
		-- c = y - mx
		-- c = y + x / m (For perp line)
		return (a[3] + a[1] / fm) < (b[3] + b[1] / fm)
	end
	
	tsort(unitSet, sortFunc)
	tsort(nodes, sortFunc)
	
	for u = 1, unitCount do
		unitSet[u][4] = nodes[u]
	end
	
	---------------------------------------------------------------------------------------------------------
	-- Main part of algorithm
	---------------------------------------------------------------------------------------------------------
	
	-- M/C for each finished matching
	local Ms = {}
	local Cs = {}
	
	-- Stacks to hold finished and still-to-check units
	local stFin = {}
	local stFinCnt = 0
	local stChk = {}
	local stChkCnt = 0
	
	-- Add all units to check stack
	for u = 1, unitCount do
		stChk[u] = u
	end
	stChkCnt = unitCount
	
	-- Begin algorithm
	while ((stChkCnt > 0) and (osclock() - startTime < maxNoXTime)) do
		
		-- Get unit, extract position and matching node position
		local u = stChk[stChkCnt]
		local ud = unitSet[u]
		local ux, uz = ud[1], ud[3]
		local mn = ud[4]
		local nx, nz = mn[1], mn[3]
		
		-- Calculate M/C
		local Mu = (nz - uz) / (nx - ux)
		local Cu = uz - Mu * ux
		
		-- Check for clashes against finished matches
		local clashes = false
		
		for i = 1, stFinCnt do
			
			-- Get opposing unit and matching node position
			local f = stFin[i]
			local fd = unitSet[f]
			local tn = fd[4]
			
			-- Get collision point
			local ix = (Cs[f] - Cu) / (Mu - Ms[f])
			local iz = Mu * ix + Cu
			
			-- Check bounds
			if ((ux - ix) * (ix - nx) >= 0) and
			   ((uz - iz) * (iz - nz) >= 0) and
			   ((fd[1] - ix) * (ix - tn[1]) >= 0) and
			   ((fd[3] - iz) * (iz - tn[3]) >= 0) then
				
				-- Lines cross
				
				-- Swap matches, note this retains solution integrity
				ud[4] = tn
				fd[4] = mn
				
				-- Remove clashee from finished
				stFin[i] = stFin[stFinCnt]
				stFinCnt = stFinCnt - 1
				
				-- Add clashee to top of check stack
				stChkCnt = stChkCnt + 1
				stChk[stChkCnt] = f
				
				-- No need to check further
				clashes = true
				break
			end
		end
		
		if not clashes then
			
			-- Add checked unit to finished
			stFinCnt = stFinCnt + 1
			stFin[stFinCnt] = u
			
			-- Remove from to-check stack (Easily done, we know it was one on top)
			stChkCnt = stChkCnt - 1
			
			-- We can set the M/C now
			Ms[u] = Mu
			Cs[u] = Cu
		end
	end
	
	---------------------------------------------------------------------------------------------------------
	-- Return orders
	---------------------------------------------------------------------------------------------------------
	local orders = {}
	for i = 1, unitCount do
		local unit = unitSet[i]
		orders[i] = {unit[2], unit[4]}
	end
	return orders
end
function GetOrdersHungarian(nodes, units, unitCount, shifted)
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-- (the following code is written by gunblob)
	--   this code finds the optimal solution (slow, but effective!)
	--   it uses the hungarian algorithm from http://www.public.iastate.edu/~ddoty/HungarianAlgorithm.html
	--   if this violates gpl license please let gunblob and me know
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	local t = osclock()
	
	--------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------
	-- cache node<->unit distances
	
	local distances = {}
	--for i = 1, unitCount do distances[i] = {} end
	
	for i = 1, unitCount do
		
		local uID = units[i]
		local ux, uz 
		
		if shifted then
			ux, _, uz = GetUnitFinalPosition(uID)
		else
			ux, _, uz = spGetUnitPosition(uID)
		end
		
		distances[i] = {}
		local dists = distances[i]
		for j = 1, unitCount do
			
			local nodePos = nodes[j]
			local dx, dz = nodePos[1] - ux, nodePos[3] - uz
			dists[j] = ceil(sqrt(dx*dx + dz*dz) + 0.5)
			 -- Integer distances = greatly improved algorithm speed
		end
	end
	
	--------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------
	-- find optimal solution and send orders
	
	local result = findHungarian(distances, unitCount)
	
	--------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------
	-- determine needed time and optimize the maxUnits limit
	
	local delay = osclock() - t
	
	if (delay > maxHngTime) and (maxHungarianUnits > minHungarianUnits) then
		
		-- Delay is greater than desired, we have to reduce units
		maxHungarianUnits = maxHungarianUnits - 1
	else
		-- Delay is less than desired, so thats OK
		-- To make judgements we need number of units to be close to max
		-- Because we are making predictions of time and we want them to be accurate
		if (#units > maxHungarianUnits*unitIncreaseThresh) then
			
			-- This implementation of Hungarian algorithm is O(n3)
			-- Because we have less than maxUnits, but are altering maxUnits...
			-- We alter the time, to 'predict' time we would be getting at maxUnits
			-- We then recheck that against maxHngTime
			
			local nMult = maxHungarianUnits / #units
			
			if ((delay*nMult*nMult*nMult) < maxHngTime) then
				maxHungarianUnits = maxHungarianUnits + 1
			else
				if (maxHungarianUnits > minHungarianUnits) then
					maxHungarianUnits = maxHungarianUnits - 1
				end
			end
		end
	end
	
	-- Return orders
	local orders = {}
	for i = 1, unitCount do
		local rPair = result[i]
		orders[i] = {units[rPair[1]], nodes[rPair[2]]}
	end
	
	return orders
end

function findHungarian(array, n)
	
	-- Vars
	local starmask = {}
	local colcover = {}
	local rowcover = {}
	local starscol = {}
	
	-- Initialization
	for i = 1, n do
		
		rowcover[i] = false
		colcover[i] = false
		starscol[i] = false
		
		starmask[i] = {}
		local starRow = starmask[i]
		for j = 1, n do
			starRow[j] = 0
		end
	end
	
	-- Subtract minimum from rows
	for i = 1, n do
		
		local aRow = array[i]
		local starRow = starmask[i]
		local minVal = aRow[1]
		
		-- Find minimum
		for j = 2, n do
			if aRow[j] < minVal then
				minVal = aRow[j]
			end
		end
		
		-- Subtract minimum
		for j = 1, n do
			aRow[j] = aRow[j] - minVal
		end
		
		-- Star zeroes
		for j = 1, n do
			if (aRow[j] == 0) and not colcover[j] then
				starRow[j] = 1
				colcover[j] = true
				starscol[i] = j
				break
			end
		end
	end
	
	return stepCoverStarCol(array, starmask, colcover, rowcover, n, starscol)
end
function stepCoverStarCol(array, starmask, colcover, rowcover, n, starscol)
	
	-- Are we done? (All columns covered)
	for i = 1, n do
		if not colcover[i] then
			return stepPrimeZeroes(array, starmask, colcover, rowcover, n, starscol)
		end
	end
	
	-- All columns were covered
	-- Return the solution
	local pairings = {}
	for i = 1, n do
		pairings[i] = {i, starscol[i]}
	end
	
	return pairings
end
function stepPrimeZeroes(array, starmask, colcover, rowcover, n, starscol)
	
	-- Infinite loop
	while true do
		
		
		for i = 1, n do
			
			if not rowcover[i] then
				
				local aRow = array[i]
				local starRow = starmask[i]
				
				for j = 1, n do
					
					if (aRow[j] == 0) and not colcover[j] then
						
						starRow[j] = 2
						
						local starpos = starscol[i]
						if starpos then
							
							rowcover[i] = true
							colcover[starpos] = false
							break -- This row is now covered
						else
							return stepFiveStar(array, starmask, colcover, rowcover, i, j, n, starscol)
						end
					end
				end
			end
		end
		
		-- Find minimum uncovered
		local minVal = huge
		for i = 1, n do
			
			if not rowcover[i] then
				
				local aRow = array[i]
				
				for j = 1, n do
					if (aRow[j] < minVal) and not colcover[j] then
						minVal = aRow[j]
					end
				end
				
				-- Lowest we can go is zero, break early if so
				if minVal == 0 then
					break
				end
			end
		end
		
		-- Only update if things will change
		if minVal ~= 0 then
			
			-- Covered rows = +
			-- Uncovered cols = -
			for i = 1, n do
				local aRow = array[i]
				if rowcover[i] then
					for j = 1, n do
						if colcover[j] then
							aRow[j] = aRow[j] + minVal
						end
					end
				else
					for j = 1, n do
						if not colcover[j] then
							aRow[j] = aRow[j] - minVal
						end
					end
				end
			end
		end
	end
end
function stepFiveStar(array, starmask, colcover, rowcover, row, col, n, starscol)
	
	local stars = {}
	local primes = {}
	local orow, ocol = row, col
	
	local nStars = 0
	local nPrimes = 0
	
	repeat
		local noFind = true
		
		for i = 1, n do
			
			local starRow = starmask[i]
			if starRow[col] == 1 then
				
				noFind = false
				
				nStars = nStars + 1
				stars[nStars] = {i, col}
				
				for j = 1, n do
					
					if starRow[j] == 2 then
						
						nPrimes = nPrimes + 1
						primes[nPrimes] = {i, j}
						
						col = j
						break
					end
				end
				
				break
			end
		end
	until noFind
	
	for s = 1, nStars do
		local star = stars[s]
		local r, c = star[1], star[2]
		starmask[r][c] = 0
		starscol[r] = false
	end
	
	-- Apply initial prime
	starmask[orow][ocol] = 1
	starscol[orow] = ocol
	
	for p = 1, nPrimes do
		local prime = primes[p]
		local r, c = prime[1], prime[2]
		starmask[r][c] = 1
		starscol[r] = c
	end
	
	for i = 1, n do
		colcover[i] = false
	end
	
	for i = 1, n do
		
		rowcover[i] = false
		
		local starRow = starmask[i]
		for j = 1, n do
			if starRow[j] == 2 then
				starRow[j] = 0
				break
			end
		end
		
		local scol = starscol[i]
		if scol then
			colcover[scol] = true
		end
	end
	
	return stepCoverStarCol(array, starmask, colcover, rowcover, n, starscol)
end
