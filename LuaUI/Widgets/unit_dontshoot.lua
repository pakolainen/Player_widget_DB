--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Don't Shoot",
    desc      = "Sets the Commander on hold fire while cloaked.",
    author    = "quantum",
    date      = "sept 06, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -1,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- Speedups
local GiveOrderToUnit  = Spring.GiveOrderToUnit
local GetUnitStates    = Spring.GetUnitStates
local GetUnitDefID     = Spring.GetUnitDefID
local GetGameFrame     = Spring.GetGameFrame
local GetMyTeamID      = Spring.GetMyTeamID
local GetSelectedUnits = Spring.GetSelectedUnits

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
  if Spring.GetSpectatingState() or Spring.IsReplay() then
    widgetHandler:RemoveWidget()
    return true
  end
end

function widget:CommandNotify(commandID, params, options)
  if (commandID == CMD.CLOAK) then
  
    local selUnits = GetSelectedUnits()
    
    for i,unitID in pairs(selUnits) do
    
      local unitDef = GetUnitDefID(unitID)
      
      if (unitDef ~= nil) and UnitDefs[unitDef].isCommander then
      
        local states = GetUnitStates(unitID)
        if (not states) then
          return
        end
        if states.cloak then
          GiveOrderToUnit(unitID, CMD.FIRE_STATE, {2}, {})
        else
          GiveOrderToUnit(unitID, CMD.FIRE_STATE, {0}, {}) 
        end
        
      end
    end
  end   
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
