
function widget:GetInfo()
  return {
    name      = "Reclaim stopper",
    desc      = "Auto stops the reclaim of a building at ...% (hold 'q' key when giving the reclaim command)",
    author    = "Floris",
    date      = "Jan 17, 2011",
    version   = "1.0",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


-- Notes:
---- If you use about 10 or more reclaimers it might fully reclaim things, especially small t1 buildings
---- Reclaimers that were already doing a normal reclaim on the target building will not inherit the automatic reclaim stopping



-- Config
local stopAtPercentage		= 0.7					-- note: it isnt very acurate, the actual outcome depends on you ping, how many reclaimers you use, and probably how fast your system is, so dont pick a value too low here
local hotKeycode			= 113					-- ASCII key code   (113 = q)
local textSize1				= 5
local textSize2				= 4.6
local textColor1			= {1, 0.8, 0, 1}		-- R,G,B,Opacity
local textColor2			= {1, 0.7, 0, 0.85}		-- R,G,B,Opacity
local textHeight			= 66



-- Shortcuts
local Echo					= Spring.Echo
local GiveOrderToUnit		= Spring.GiveOrderToUnit
local GetUnitDefID			= Spring.GetUnitDefID
local GetUnitHealth			= Spring.GetUnitHealth
local ALL_UNITS				= Spring.ALL_UNITS
local GetPlayerInfo			= Spring.GetPlayerInfo
local GetMyPlayerId			= Spring.GetMyPlayerID
local GetKeyState			= Spring.GetKeyState
local GetUnitCommands		= Spring.GetUnitCommands
local GetUnitViewPosition	= Spring.GetUnitViewPosition
local IsUnitInView			= Spring.IsUnitInView
local _, _, _, _, _, myPing	= GetPlayerInfo(GetMyPlayerId())

local targetUnits				= {}	-- contains all units the reclaimstopper reclaimers will reclaim (the unit key in the array will include all the reclaimer id's aswell)




local deactivated = false
function reclaimstopper(cmd, line, words)
  if ((words[1])and(words[1]~="0")) or (deactivated) then
    deactivated = false
  else
    deactivated = true
  end
end



function widget:Initialize()
  if Spring.GetSpectatingState() or Spring.IsReplay() then
    widgetHandler:RemoveWidget()
    return true
  else
    Spring.SendCommands({"reclaimstopper 0"})
    widgetHandler:AddAction("reclaimstopper", reclaimstopper)
    return true
  end
end



function widget:DrawWorld()
    
  -- draw indicator text
  for targetUnitID, targetUnitReclaimers in next, targetUnits, nil do
    if IsUnitInView(targetUnitID) then
      local ux, uy, uz = GetUnitViewPosition(targetUnitID)
      gl.PushMatrix()
      gl.Translate(ux, uy+textHeight, uz)
      gl.Billboard()
      gl.Color(textColor1)
      gl.Text("Reclaim", 0, -3.0, textSize1, "cn")
      gl.Color(textColor2)
      gl.Text("stopper", 0, -8.0, textSize2, "cn")
      gl.PopMatrix()
    end
  end
end



-- loop targets and check if the assigned reclaimer(s) are still going to reclaim their targets
function checkTargetReclaimersQueue()
  for targetUnitID, targetUnitReclaimers in next, targetUnits, nil do
    local assignedReclaimerCount = 0
	for reclaimerunitId, value in next, targetUnitReclaimers, nil do
	  local unitCommands = GetUnitCommands(reclaimerunitId)
	  local foundAssignedCommand = 0
	  
	  -- loop reclaimer command queue
	  if unitCommands ~= nil then			-- check it so it doesn't error when a reclaimer unit has been killed (or reclaimed)
        for iCommand=1, #unitCommands do
		  local unitCommand = unitCommands[iCommand]
		  if unitCommand.id == CMD.RECLAIM then
		    local unitCommandTargetId = unitCommand.params[1]
		    if unitCommandTargetId == targetUnitID then
		  	  assignedReclaimerCount = assignedReclaimerCount + 1
		  	  foundAssignedCommand = 1
		    end
		  end
		end
	  end
	  
	  if foundAssignedCommand == 0 and targetUnits[targetUnitID][reclaimerunitId] < 2 then			-- value 1 is a directly assigned reclaimer, value 2 is a reclaimer guarding another reclaimer
	    targetUnits[targetUnitID][reclaimerunitId] = nil	-- remove reclaimer
	  end
	end
	if assignedReclaimerCount == 0 then
	  targetUnits[targetUnitID] = nil		-- remove target
	end
  end
end



function widget:GameFrame(n)
  
  checkTargetReclaimersQueue()
  
  -- loop target units, check health, remove reclaimers from target
  for targetUnitID, targetUnitReclaimers in next, targetUnits, nil do
    local targetUnitDefID = GetUnitDefID(targetUnitID)
    local targetUnitDef   = UnitDefs[targetUnitDefID]
    if targetUnitDef then
      local health, maxHealth, paralyzeDamage, capture, build = GetUnitHealth(targetUnitID)
        if build == 1 and maxHealth == nil or maxHealth < 0 then
          maxHealth = 1
        else
        
        -- start watching it from 60% and onwards
        local checkTotalReclaimerSpeedAt = (maxHealth / 100) * 60
        if health < checkTotalReclaimerSpeedAt then
          local totalReclaimers				= 0
          local totalReclaimerSpeed			= 0
           
          -- count total reclaim speed of all combined reclaimers
          for reclaimerunitId, reclaimerType in next, targetUnitReclaimers, nil do
            local reclaimerUnitDefID = GetUnitDefID(reclaimerunitId)
            local reclaimerUnitDef   = UnitDefs[reclaimerUnitDefID]
            if reclaimerUnitDef.reclaimSpeed ~= nil then
              totalReclaimers = totalReclaimers + 1
              totalReclaimerSpeed = totalReclaimerSpeed + reclaimerUnitDef.reclaimSpeed	-- is directly reclaiming
             end
          end
          
	      -- calculate stop percentage (to know when to stop reclaim)
          local targetBuildTime			  = targetUnitDef.buildTime
          local _, _, _, _, _, myNewPing  = GetPlayerInfo(GetMyPlayerId())
	      local correctedPing			  = myNewPing + 0.04
	      local currentPercentage		  = (health/maxHealth) * 100
	      local correctionPercentage	  = (correctedPing * (totalReclaimerSpeed/targetBuildTime)) * 100
	     local correctedPercentage	 	  = stopAtPercentage + correctionPercentage
          --Echo("Reclaim stopper:        debug: ", correctedPercentage, totalReclaimers)
	      
          
	      if totalReclaimerSpeed ~= nil and currentPercentage < correctedPercentage * totalReclaimers then
            
            -- loop reclaimer units
            local removeReclaimers = 1		-- number or reclaimers that stop reclaiming
            local stopRepeating = 0
            local reclaimerType = 2
            local reclaimerRemoved = 0
            
            for reclaimerType = 2, 1, -1 do
              for reclaimerunitId, reclaimerunitType in next, targetUnitReclaimers, nil do
                local unitCommands = GetUnitCommands(reclaimerunitId)
                
                if reclaimerunitType == reclaimerType and stopRepeating == 0 then
                  
                  -- loop reclaimer command queue... and remove the reclaim command
                  for iCommand=1, #unitCommands do
                    local unitCommand = unitCommands[iCommand]
                    if unitCommand.id == CMD.RECLAIM then
                      local unitCommandTargetId = unitCommand.params[1]
                      if unitCommandTargetId == targetUnitID then
                        local removeReclaimer = 0
                        if totalReclaimers == 1 and currentPercentage < correctedPercentage then
                          removeReclaimer = 1
                        end
                        if totalReclaimers > 1 and removeReclaimers >= 1 then
                          removeReclaimer = 1
                        end
                        if removeReclaimer == 1 then
                          GiveOrderToUnit(reclaimerunitId, CMD.REMOVE, {unitCommand.tag}, 0)
                          totalReclaimers = totalReclaimers - 1
                          removeReclaimers = removeReclaimers - 1
                          reclaimerRemoved = 1
                          targetUnits[targetUnitID][reclaimerunitId] = nil		-- remove reclaimer
                          stopRepeating = 1
                        end
                      end
                    end
                  end
                end
              end
            end
            
            if totalReclaimers == 0 then
              targetUnits[targetUnitID] = nil			-- remove target
               --Echo("Reclaim stopper:        debug: ", targetUnitID)
            end
          end
          
        end
      end
    end
  end
end



-- detect a new reclaimstopper reclaim command
function widget:UnitCommand(unitId, unitDefId, unitTeam, cmdId, cmdOpts, cmdParams)

  -- is reclaim command?
  if cmdId == CMD.RECLAIM and #cmdParams == 1 then
    local targetUnit = cmdParams[1]
    if targetUnit < Game.maxUnits and GetKeyState(hotKeycode) then
      if targetUnits[targetUnit] == nil then
        targetUnits[targetUnit] = {}
      end
      targetUnits[targetUnit][unitId] = 1		-- add reclaimer
    else
      targetUnits[targetUnit] = nil			-- remove target (if it existed or not)
    end
  end
  return true
end



function widget:Shutdown()
  widgetHandler:RemoveAction("reclaimstopper", reclaimstopper)
  Spring.SendCommands({"reclaimstopper 1"})
end