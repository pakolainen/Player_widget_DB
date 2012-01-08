--[[
When this widget is enabled, air transports guarding factories will 
automatically take new units built at the factory to the destination of the factory
--]]

function widget:GetInfo()
  return {
    name      = "Transportation Assister",
    desc      = "Transports guarding factories will automatically move new units. Stops units that are about to be picked.",
    author    = "Ray, Licho(mod)",
    date      = "Mar 23, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



function widget:Initialize()
	local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
	if spec then
		widgetHandler:RemoveWidget()
		return false
	end
end

function widget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders) 
	if unitTeam ~= Spring.GetMyTeamID() then return end

	local cQueue = Spring.GetCommandQueue(factID)
	local UD = UnitDefs[Spring.GetUnitDefID(unitID)]
	local transID = null
	if (not UD.springCategories["notair"] or not UD.springCategories["notship"]) or (UD.builder and UD.canAssist) then return end
	for _, elem in ipairs(cQueue) do
		if elem.id ~= CMD.MOVE then
			return
		end
	end

	transID = IdleTransport(factID)
	if transID ~= null then
		MoveUnit(unitID, factID)
		TransportUnit(unitID, transID, factID)
	end
	
end


function TransportUnit(unitID, transID, factID)
	local transCQueue = Spring.GetCommandQueue(transID)
	local params = {}
	local newParams
	local tries = 0
	if table.getn(transCQueue) > 2 then
		Spring.GiveOrderToUnit(transID, CMD.GUARD, {factID}, {"shift"})
		Spring.GiveOrderToUnit(transID, CMD.LOAD_UNITS, {unitID}, {"shift"})
	else
		Spring.GiveOrderToUnit(transID, CMD.LOAD_UNITS, {unitID}, {""})
	end
	local fCQueue = Spring.GetCommandQueue(factID)
	
	local UD = UnitDefs[Spring.GetUnitDefID(transID)]
		
	for num, elem in ipairs(fCQueue) do
		params = elem.params
		newParams = params

		if num ~= table.getn(fCQueue) then
			Spring.GiveOrderToUnit(transID, CMD.MOVE, newParams, {"shift"})
		else
			newParams[4] = 250
			Spring.GiveOrderToUnit(transID, CMD.UNLOAD_UNITS, newParams, {"shift"})
		end
	end
	Spring.GiveOrderToUnit(transID, CMD.STOP, {}, {"shift"})
	Spring.GiveOrderToUnit(transID, CMD.GUARD, {factID}, {"shift"})
end 

function MoveUnit(unitID, factID)
	local fX, fY, fZ = Spring.GetUnitPosition(factID)
	local bF = Spring.GetUnitBuildFacing(factID)
	local xAdd
	local yAdd
	if bF == 0 then
		xAdd = 0
		yAdd = 70
	elseif bF == 1 then
		xAdd = 70
		yAdd = 0
	elseif bF == 2 then
		xAdd = 0
		yAdd = -70
	else
		xAdd = -70
		yAdd = 0
	end
	Spring.GiveOrderToUnit(unitID, CMD.MOVE, {fX + xAdd, fY, fZ + yAdd} , {""})

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function IdleTransport(factID)
	local cQueue
	local leastQCount
	local idleTrans = null
	local lastCmd
	local uList = Spring.GetTeamUnits(Spring.GetMyTeamID())
	local leastDist = null
	for _, ID in ipairs(uList) do -- cycle through every unit
		UD = UnitDefs[Spring.GetUnitDefID(ID)]
		if UD.isTransport then
			cQueue = Spring.GetCommandQueue(ID)
			lastCmd = table.getn(cQueue)
			
			if (lastCmd > 0 and cQueue[lastCmd].id == CMD.GUARD and cQueue[lastCmd].params[1] == factID) or (lastCmd > 1 and cQueue[lastCmd-1].id == CMD.GUARD and cQueue[lastCmd-1].params[1] == factID) then
					
				if idleTrans ~= null then
					if table.getn(Spring.GetCommandQueue(ID)) < table.getn(Spring.GetCommandQueue(idleTrans)) then
						leastQCount = table.getn(Spring.GetCommandQueue(ID))
						idleTrans = ID
					end
				else
					leastQCount = table.getn(Spring.GetCommandQueue(ID))
					idleTrans = ID
				end
			end
			
		end
	end
	
	if idleTrans == null then 
		return null 
	end
	
	for _, ID in ipairs(uList) do -- cycle through every unit
		UD = UnitDefs[Spring.GetUnitDefID(ID)]
		if UD.isTransport then
			cQueue = Spring.GetCommandQueue(ID)
			lastCmd = table.getn(cQueue)
				
			if (lastCmd > 0 and cQueue[lastCmd].id == CMD.GUARD and cQueue[lastCmd].params[1] == factID) or (lastCmd > 1 and (cQueue[lastCmd-1].id == CMD.GUARD and cQueue[lastCmd-1].params[1] == factID)) then
				if lastCmd == leastQCount or lastCmd == leastQCount + 1 then
					if leastDist ~= null then
						if DistFromFac(ID, factID) < leastDist then
							leastDist = DistFromFac(ID, factID)
							idleTrans = ID
						end
					else
						leastDist = DistFromFac(ID, factID)
						idleTrans = ID
					end
				end
			end
		end
	end
	
	return idleTrans
	
end


function DistFromFac(unitID, factID)
	
	local uX, uY, uZ = Spring.GetUnitPosition(unitID)
	local fX, fY, fZ = Spring.GetUnitPosition(factID)
    return math.sqrt((uX - fX)^2 + (uZ - fZ)^2)

end

function echo(msg)
  Spring.SendCommands({"echo " .. msg})
end


local timer = 0

function widget:Update(deltaTime)
	timer = timer + deltaTime
	if (timer > 1) then

		local uList = Spring.GetTeamUnits(Spring.GetMyTeamID())		

		for _, ID in ipairs(uList) do -- cycle through every unit
			UD = UnitDefs[Spring.GetUnitDefID(ID)]
			if UD.isTransport then
				cQueue = Spring.GetCommandQueue(ID)

				if (cQueue[1] ~= nil and cQueue[1].id == CMD.LOAD_UNITS) then
					local uid = cQueue[1].params[1]
 					for _, eid in ipairs(uList) do
						if (eid == uid) then
							Spring.GiveOrderToUnit(uid, CMD.STOP, {}, {""}) 
						end
					end
				end 
			end
		end

		timer = 0
	end
end


