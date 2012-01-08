--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_windcheck.lua
--  brief:   Returns if wind is viable on the map
--  author:  Edible
--
--  Licensed under the terms of the GNU GPL, v2 or later.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:GetInfo()
  return {
    name      = "Windcheck v1.1",
    desc      = "Shows if wind is viable",
    author    = "Ed",
    date      = "Feb 11, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 1,
    enabled   = true  --  loaded by default?
  }
end

function widget:Initialize()
end


include("colors.h.lua")
local gl = gl  --  use a local copy for faster access
local DeltaTime = 1



    
--local wx, wy, wz = Spring.GetWind()

--------------------------------------------------------------------------------
--
--  DrawScreen
--
WhiteStr   = "\255\255\255\255"
GreyStr    = "\255\210\210\210"
GreenStr   = "\255\092\255\092"
BlueStr    = "\255\170\170\255" 
YellowStr  = "\255\255\255\152"
OrangeStr  = "\255\255\190\128"
RedStr     = "\255\170\170\255"

local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end


function widget:DrawScreen()
    local timer = widgetHandler:GetHourTimer()
	local Minwind = Game.windMin
	local Maxwind = Game.windMax
	
	if (Spring.GetGameSeconds() > 1) then -- Remove it when game starts
		widgetHandler:RemoveWidget()
	end 
	
	local windisgood = ((Maxwind + Minwind) / 2)
    --if (math.mod(timer, 0.5) < 0.25) then
      colorStr = RedStr
    --else
    --colorStr = YellowStr
    --end
    local windisgood = (  "The average wind is " .. windisgood .. ", and " .. Minwind .. " is the minimum, " .. Maxwind .. " is the maximum")
    local timer = widgetHandler:GetHourTimer()
    gl.Text(colorStr .. windisgood,
            (vsx * 0.5), (vsy * 0.4) - 50, 24, "oc")
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

	
	
	

