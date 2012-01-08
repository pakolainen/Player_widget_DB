function widget:GetInfo()
	return {
	name      = "Cursor Autoscale", --v1
	desc      = "Scales cursor according to resolution",
	author    = "Regret",
	date      = "August 19, 2009",
	license   = "Public Domain",
	layer     = -999999,
	enabled   = true,
	handler   = true,
	}
end
local normalresolution_y = 768 --when cursor size == texture size

local sGetMouseCursor = Spring.GetMouseCursor
local sSetMouseCursor = Spring.SetMouseCursor

--hijack spring functions
local SetCursor = {}
local function fakeSetMouseCursor(name,scale)
	SetCursor.name = name
	SetCursor.scale = scale
end
local GetCursor = {name = "cursornormal", scale = 1}
local function fakeGetMouseCursor()
	return GetCursor.name,GetCursor.scale
end
function widget:Initialize()
	Spring.GetMouseCursor = fakeGetMouseCursor
	Spring.SetMouseCursor = fakeSetMouseCursor
	
	SetCursor.name = nil
	SetCursor.scale = nil
end
function widget:Shutdown()
	Spring.GetMouseCursor = sGetMouseCursor --restore spring functions
	Spring.SetMouseCursor = sSetMouseCursor
end
-----

local vsx,vsy = widgetHandler:GetViewSizes()
if (vsx == 1) then --hax for windowed mode
	vsx,vsy = Spring.GetWindowGeometry()
end
function widget:ViewResize(viewSizeX, viewSizeY)
	vsx,vsy = widgetHandler:GetViewSizes()
end

function widget:DrawScreen()
	local cursor = sGetMouseCursor()
	local scale = vsy/normalresolution_y
	
	if (SetCursor.name) then
		cursor = Cursor.name
	end
	if (SetCursor.scale) then
		scale = Cursor.scale
	end
	
	sSetMouseCursor(cursor,scale)
	
	SetCursor.name = nil
	SetCursor.scale = nil
	
	GetCursor.name = cursor
	GetCursor.scale = scale
end
