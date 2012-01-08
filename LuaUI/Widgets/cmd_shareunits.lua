--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    cmd_shareunits.lua
--  brief:   gives the selected units to a specified player
--  author:  Jan Holthusen
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "ShareUnits",
    desc      = "Adds '/luaui shareunits <Name/TeamID>' to give selected units.",
    author    = "MelTraX",
    date      = "Jan 31, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:TextCommand(command)
  if (string.find(command, 'shareunits ') ~= 1) then
    return false
  end
  local selUnits = Spring.GetSelectedUnits()
  if table.getn(selUnits) == 0 then
   return false
  end
  local cmd = string.sub(command, 12)
  local players = Spring.GetPlayerList()
  myname, _, _, _, _, _, _ = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  for test,pid in ipairs(players) do
   name, active, spec, teamID, allyTeamID, _, _ = Spring.GetPlayerInfo(pid)
   if active and not spec and (cmd == name or cmd == tostring(teamID))
      and Spring.GetMyTeamID() ~= teamID and allyTeamID == Spring.GetMyAllyTeamID() then
    x, y, z = Spring.GetUnitPosition(selUnits[1])
	if table.getn(selUnits) > 1 then
	 unitName = table.getn(selUnits) .. " units"
	else
	 unitName = UnitDefs[Spring.GetUnitDefID(selUnits[1])].humanName
	end
    Spring.ShareResources(teamID, "units")
    Spring.MarkerAddPoint(x, y, z, myname .. " gives " .. unitName .. " to " .. name)
    return true
   end
  end
  return false
end


--------------------------------------------------------------------------------
