
local versionNumber = "1.1"

function widget:GetInfo()
	return {
		name      = "Autodestruction Alert",
		desc      = "Alert if commander tries to autodestruct",
		author    = "Jools",
		date      = "June 22, 2011",
		license   = "GNU GPL v2",
		layer     = 0,
		enabled   = true
	}
end

local SDImminent = false
local snd = LUAUI_DIRNAME .. 'Sounds/siren3.ogg'
local sndc = LUAUI_DIRNAME .. 'Sounds/pop.wav'
local verbose = false -- Set to true if you want a text alert as well

function widget:Initialize()
	if Spring.GetSpectatingState() or Spring.IsReplay() then
		widgetHandler:RemoveWidget()
		return true
	end
end

function widget:KeyPress(key, mods, isRepeat)
	if (key == 0x064) and (not isRepeat) and mods.ctrl then		
		local sU = Spring.GetSelectedUnits()
		if (sU and #sU>=1) then
			for _,unit in ipairs (sU) do
				local ud = UnitDefs[Spring.GetUnitDefID(unit)]
				if (ud.customParams.iscommander) then
					if not SDImminent then
						if verbose then Spring.Echo("Autodestruction detected") end
						Spring.PlaySoundStream(snd,1.5)
						SDImminent = true
					else
						if verbose then Spring.Echo("Autodestruction cancelled") end
						Spring.StopSoundStream()
						Spring.PlaySoundFile(sndc)
						SDImminent = false
					end
				end
			end
		end
	end
	return false
end	