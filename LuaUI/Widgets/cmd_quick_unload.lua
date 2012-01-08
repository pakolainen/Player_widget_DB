
function widget:GetInfo()
  return {
    name      = "Quick Unload",
    desc      = "Gives an unload order with Ctrl+E",
    author    = "Google Frog",
    date      = "Jan 31, 2009",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

include("keysym.h.lua")

local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetCommandQueue = Spring.GetCommandQueue
local spGetUnitPosition = Spring.GetUnitPosition
local spGetSelectedUnits = Spring.GetSelectedUnits

local radius = 120

function widget:KeyPress(key, modifier, isRepeat)

  if (key == KEYSYMS.E) and modifier.ctrl then
	
	local selUnits = spGetSelectedUnits()

	for i, unit in ipairs(selUnits) do 
	
	  local cQueue = spGetCommandQueue(unit)
	  
	  if (#cQueue == 0) or not modifier.shift then
	    local x,y,z = spGetUnitPosition(unit)
        spGiveOrderToUnit(unit, CMD.UNLOAD_UNITS, {x,y,z,radius}, CMD.OPT_RIGHT)
	  else
	    local c = #cQueue
		
		if not (cQueue[c].params[3]) and (c > 1)then
		  c = #cQueue-1
		end
		
		if (cQueue[c].params[3]) then
	      local x = cQueue[c].params[1]
		  local y = cQueue[c].params[2]
		  local z = cQueue[c].params[3]
		  spGiveOrderToUnit(unit, CMD.UNLOAD_UNITS, {x,y,z,radius}, CMD.OPT_SHIFT)
		end
	  end   
	
	end
	
  end
  
end

