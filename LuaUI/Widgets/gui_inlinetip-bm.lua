--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "InlineTip-BM",
    desc      = "v0.3 Prints unit name next to cursor when hovering over buildpic.",
    author    = "CarRepairer",
    date      = "2008-08-20",
    license   = "GNU GPL, v2 or later",
    layer     = 1, 
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Spring          = Spring
local gl, GL          = gl, GL
local widgetHandler   = widgetHandler
local panelFont       = LUAUI_DIRNAME.."Fonts/KOMTXT___16"



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local fhDraw          = fontHandler.Draw
local glColor         = gl.Color
local GetCurrentTooltip = Spring.GetCurrentTooltip
local GetMouseState = Spring.GetMouseState 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

fontHandler.UseFont(panelFont)
local panelFontSize  = fontHandler.GetFontSize()
fontHandler.DisableCache()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function getShortTooltip()
	local tooltip = GetCurrentTooltip()

	if tooltip:find('Build') == 1 then
		return tooltip:gsub('([^-]*)\-.*', '%1')
	elseif tooltip:find('Morph') == 5 then
		return tooltip:gsub('([^(time)]*)\(time).*', '%1')
	end
	return false
	
end


function widget:DrawScreen()

	local curTooltip = getShortTooltip()

	if (curTooltip) then
		fontHandler.DisableCache()

		fontHandler.UseFont(panelFont)
		glColor(1,1,1,1)
	
		local mx, my = GetMouseState()
		fhDraw(curTooltip, mx + 15, my - 15)
	end

end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
end

function widget:Shutdown()
	fontHandler.FreeFonts()
	fontHandler.FreeCache()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
