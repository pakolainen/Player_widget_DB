--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_dgun_unstall.lua
--  brief:   disable energy drains while stalling and trying to dgun
--  author:  Masure
--  version: 1.00
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--params
local energyAim = 600
local disabledUnits = {} 
local coms = {}
local MyTeamId = Spring.GetMyTeamID()
local unstallHysteresis = 10
local unstallTime = 0

function widget:GetInfo()
  return {
    name      = "D-Gun unstall",
    desc      = "Disable energy drains while you try to dgun and stalling E",
    author    = "Masure",
    date      = "Oct 17, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -3,
    enabled   = false  --  loaded by default?
  }
end

function widget:Initialize()
  local _, _, spec = Spring.GetPlayerInfo(MyTeamId)
  if spec then
    widgetHandler:RemoveWidget()
    return false
  end
  local units = Spring.GetTeamUnits(MyTeamId)
  for _,UID in ipairs(units) do
  
    local UDID = Spring.GetUnitDefID(UID)
    local UD = UnitDefs[UDID]
	
	if (UD == nil) then break end
    if (UD.TEDClass == "COMMANDER") then
	  table.insert(coms,UID)
    end
  end

end


function widget:UnitCreated(unitID, unitDefID, unitTeam)
  local UD
  UD = UnitDefs[unitDefID]
  if (UD.TEDClass == "COMMANDER") then
	table.insert(coms,UID)
  end
end

function widget:UnitGiven(unitID, unitDefID, unitTeam)
  local UD
  UD = UnitDefs[unitDefID]
  if (UD.TEDClass == "COMMANDER") then
	table.insert(coms,UID)
  end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	for comIndex,comID in ipairs(coms) do
      if (unitID == comID) then
        table.remove(coms,comIndex)
        break
      end
    end
end

function widget:UnitTaken(unitID, unitDefID, unitTeam)
	for comIndex,comID in ipairs(coms) do
      if (unitID == comID) then
        table.remove(coms,comIndex)
        break
      end
    end
end

------------------------------------------------------------------------------

------------------------------------------------------------------------------

function widget:Update(deltaTime)

	local bDgunOrder = false
	local units = Spring.GetTeamUnits(MyTeamId)
	
	unstallTime = unstallTime - deltaTime
	
	-- try to find a dgun order
	--------------------------------------
	--com parsing
	for _, comID in ipairs(coms) do
		
		bDgunOrder = findCmdId(comID, CMD.DGUN)
		
		if bDgunOrder then
			break
		end 
	end
	
	-- DGUN ORDER GIVEN ?
	if bDgunOrder then 	
		
		local eCur, eMax, eUse, eInc, _, _, _, eRec = Spring.GetTeamResources(MyTeamId, "energy")
		
		
		-- Set unstallTime to Default Hysteresis 
		unstallTime = unstallHysteresis

		-- NEED TO DISABLE UNITS ???
		if eMax > energyAim and eCur < energyAim then 
			for _,unitID in ipairs(units) do
				
				
				if disabledUnits[unitID] == nil then
				
					local UDID = Spring.GetUnitDefID(unitID)
					local UD = UnitDefs[UDID]
				
					if UD.buildSpeed > 0 and UD.TEDClass ~= "COMMANDER" then
						
						if UD.isFactory then
							Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
							disabledUnits[unitID] = true
							echo(">>> SENDS WAIT FACTORY " .. unitID)
						else
							if findCmdId(unitID, CMD.WAIT) == false then				
							
							Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
							disabledUnits[unitID] = true
							echo(">>> SENDS WAIT BUILDER " .. unitID)
													
							end
						end
						

					
					else
						if UnitDefs[UDID].isMetalMaker then
						
							Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 0 }, { })   -- turns Units OFF and sends Deactivatesc() function call to COB 
							disabledUnits[unitID] = true	
							echo(">>> TURN OFF MMAKER " .. unitID)
						end
					end
					
				end
			end
			
			--echo("UNITS DISABLED : " .. tableCount(disabledUnits))
			
		end --need to disable unit
	
	-- NO DGUN ORDER QUEUED
	else
		
		-- Hysteresis ended ?
		if unstallTime < 1 then
		
			-- disabled units parsing
			for unitID,_ in pairs(disabledUnits) do
				
				--valid unit
				--if units[unitID] ~= nil then
				
					local UDID = Spring.GetUnitDefID(unitID)
					
				if UDID  ~= nil then
				
				local UD = UnitDefs[UDID]
					local bWaitOrder = false

					
					if UD.buildSpeed > 0 and UD.TEDClass ~= "COMMANDER"  then
					
							if UD.isFactory then
							
								Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
								disabledUnits[unitID] = nil
								--echo(">>> UNWAIT FACTORY " .. unitID)
							else
								--if findCmdId(unitID, CMD.WAIT) == false then				
								
									Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
									disabledUnits[unitID] = nil
									--echo(">>> UNWAIT BUILDER " .. unitID)
														
								--end
							end
						
						--Deprecated > can't find wait order properly
						--if (findCmdId(unitID, CMD.WAIT) == true) or (findCmdId(unitID, 105) == true) then				
							
						--	Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
						--	disabledUnits[unitID] = nil
							
						--	echo(">>> UNWAIT " .. unitID)
						--else
							--echo(">>> NO WAIT FOUND")
						--end
						
						

					else
					  if UD.isMetalMaker then
						Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 1 }, { })   -- turns Units OFF and sends Deactivatesc() function call to COB 
						disabledUnits[unitID] = nil
						--echo("TURN ON MMAKER " .. unitID)	
					  end
					end
				else
					--echo(units[unitID])
					--echo("removed invalid unitID" .. unitID)	
					disabledUnits[unitID] = nil
				end --valid unit
			end -- disabled units parsing
			
			--echo("UNITS DISABLED : " .. tableCount(disabledUnits))
		else
			--echo("Hysteresis time left " .. unstallTime)	
		end -- Hysteresis ended ?
	end -- DGUN ORDER GIVEN ?
end -- function update



function echo(msg)
	Spring.SendCommands({"echo " .. msg})
end  


function findCmdId(pUnitID, pCmdID)

	local cQueue = Spring.GetCommandQueue(pUnitID)
	
	if pUnitID == 8 then
	
	echo("UNIT " .. pUnitID .. " QUEUE " .. tableCount(cQueue) )
	
	end
	
	if cQueue ~= nil then

		for _, cmdOrder in ipairs(cQueue) do
				
				if pUnitID == 8 then
					echo(cmdOrder.id)
				end 
			
			if cmdOrder.id == pCmdID then
				return true
			end
		end --queue parsing
		
	end 
	
	return false
end

function tableCount(pTable)

local i = 0

	for _, _ in pairs (pTable) do
		i=i+1
	end 
	return i
end


-- function widget:CommandNotify(id, params, options)
  -- if (id == CMD.DGUN) then
  -- echo("DGUN")
	-- echo("Commanders : " .. table.getn(coms))
  -- end  
  -- return false
-- end

