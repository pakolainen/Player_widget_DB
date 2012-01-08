--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_nowaste.lua
--  brief:   Saves metal that can be lost.
--  original author:  Janis Lukss
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
return {
name      = "NoWaste",
desc      = "Saves metal by stopping production of a unit from a factory that might be close to destruction.",
author    = "Pendrokar",
date      = "Jul 7, 2009",
license   = "GNU GPL, v2 or later",
layer     = 0,
enabled   = false -- loaded by default?
}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local lowhp = 0.10 --Factories with lower HP than this will pause production
local percentagedone = 0.90 --percentage of a building unit over which production stop is not allowed
local myteamid = Spring.GetMyTeamID()

function widget:Initialize()
end

function widget:Shutdown()
       if Spring.GetSpectatingState() then
               widgetHandler:RemoveWidget()
               return
       end
end

function widget:UnitDamaged(unitID, unitDefID, unitTeam)
	if(unitTeam == myteamid) then
		local ud = UnitDefs[unitDefID]
		if(ud.isBuilding or ud.isFactory) then
			local health, maxhealth = Spring.GetUnitHealth(unitID)
			if((health/maxhealth < lowhp) and health > 0) then
				local factcmds = Spring.GetFactoryCommands(unitID)
				if (not factcmds) then return end
				if (not factcmds[1]) then return end
				if (not factcmds[1]["id"]) then return end
				if(factcmds[1]["id"] < 0) then
					local factradius = Spring.GetUnitRadius(unitID)
					local x,y,z = Spring.GetUnitPosition(unitID)
					local bunit = Spring.GetUnitsInSphere(x,y,z, factradius)
					for k,i in pairs(bunit) do
						if(i ~= unitID) then
							bunit = i
							break
						end
					end
					local bmeter = 0
					if(bunit) then
						 _,_,_,_,bmeter = Spring.GetUnitHealth(bunit)
					end
					if (not bmeter) then return end
					if(bmeter < percentagedone) then
						local bunitdef = Spring.GetUnitDefID(bunit)
						Spring.GiveOrderToUnit(unitID, -bunitdef, {}, {"right"})
						Spring.GiveOrderToUnit(unitID, -bunitdef, {}, {"alt"})
						Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
					end
				end
			end
		end
	end
end
