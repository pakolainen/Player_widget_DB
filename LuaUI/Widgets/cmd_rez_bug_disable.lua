
function widget:GetInfo()
  return {
    name      = "Rez bug disable",
    desc      = "Disables resurrecting partially reclaimed wrecks",
    author    = "Pako",
    date      = "13.07.2009",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local GetCommandQueue = Spring.GetCommandQueue
local GetMyTeamID = Spring.GetMyTeamID
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetTeamUnits = Spring.GetTeamUnits
local GetUnitDefID = Spring.GetUnitDefID
local GetFeatureResources = Spring.GetFeatureResources
local Echo = Spring.Echo

local RECTOR = UnitDefNames['armrectr'].id
local NECRO = UnitDefNames['cornecro'].id


local watchList = {}
local UPDATE = 1
local timeCounter = 0.0


function widget:Initialize()
  if Spring.GetSpectatingState() or Spring.IsReplay() then
    widgetHandler:RemoveWidget()
    return false
  end
  
  local teamUnits = GetTeamUnits(GetMyTeamID())
  for _,unitID in ipairs(teamUnits) do
    local unitDefID = GetUnitDefID(unitID)
    if (unitDefID == RECTOR or unitDefID == NECRO) then
      watchList[unitID] = true
    end
  end

end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
  if (unitDefID == RECTOR or unitDefID == NECRO) and (unitTeam == GetMyTeamID()) then
    watchList[unitID] = true
  end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  watchList[unitID] = nil
end

function widget:UnitTaken(unitID, unitDefID, unitTeam)
  watchList[unitID] = nil
end


function widget:Update(deltaTime)

  if (next(watchList) == nil) then return false end
    
  if (timeCounter > UPDATE) then
    timeCounter = 0
	
  if Spring.GetSpectatingState() then
    widgetHandler:RemoveWidget()
    return false
  end
    
    for unitID,_ in pairs(watchList) do
	
	  cQueue = GetCommandQueue(unitID)
	  if(cQueue and #cQueue>0 and cQueue[1].id == CMD.RESURRECT) then
	  _,_,_,_,reclaimLeft = GetFeatureResources(cQueue[1].params[1]-Game.maxUnits)
	  if(reclaimLeft and reclaimLeft~=1.0)then
	  GiveOrderToUnit(unitID, CMD.REMOVE, {cQueue[1].tag}, {})
	  GiveOrderToUnit(unitID, CMD.INSERT, {0, CMD.RECLAIM, CMD.OPT_SHIFT, cQueue[1].params[1]}, {"alt"})
	  Echo("Rez_bug widget: resurrect cancelled")
	  end
	  end
	  
    end
	
  else
    timeCounter = (timeCounter + deltaTime)
  end
end
