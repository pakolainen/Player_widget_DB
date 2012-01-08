function widget:GetInfo()
  return {
    name      = "Team View",
    desc      = "Centers the view on the team you're selecting.",
    author    = "BoredJoe",
    date      = "09/01/2008",
    license   = "",
    layer     = 5,
    enabled   = false
}
end

local center = true
local localID

function widget:Update()
if (localID ~= Spring.GetMyTeamID()) then
	center = true

  local playerID = Spring.GetMyPlayerID()
  _, _, spec, _, _, _, _, _ = Spring.GetPlayerInfo(playerID)
  local averagex, averagey, averagez, count = 0, 0, 0, 0

  if ( spec == true ) then
      if  center then
          for _,unitID in ipairs(Spring.GetAllUnits()) do    
             teamID = Spring.GetUnitTeam(unitID)
             if teamID == Spring.GetMyTeamID() then
                local x, y, z = Spring.GetUnitPosition(unitID)
		    averagex = (averagex + x)
		    averagey = (averagey + y)
		    averagez = (averagez + z)
    		    count = (count + 1)
             end
          end
	    averagex = averagex / count
	    averagey = averagey / count
	    averagez = averagez / count
	    localID = Spring.GetMyTeamID()
	  if count ~= 0 then
          Spring.SetCameraTarget(averagex, averagey, averagez)
          center = false
	  end
      end
    end
  end
end



		