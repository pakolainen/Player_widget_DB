include("cmdcolors.h.lua")
function widget:GetInfo()
  return {
    name      = "LOSColors",
    desc      = "Sets LOS colors from cmdcolors.txt",
    author    = "dizekat",
    date      = "Jan 07, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false
  }
end

function widget:Initialize()
	local alwaysColor=cmdColors["alwayscolor"];
	local losColor=cmdColors["loscolor"];
	local radarColor=cmdColors["radarcolor"];
	local jamColor=cmdColors["jamcolor"];
	if alwaysColor and losColor and radarColor and jamColor then		
		local red = {alwaysColor[1],losColor[1],radarColor[1],jamColor[1]}
		local green = {alwaysColor[2],losColor[2],radarColor[2],jamColor[2]}
		local blue = {alwaysColor[3],losColor[3],radarColor[3],jamColor[3]}
		Spring.SetLosViewColors(red,green,blue)
	end
end