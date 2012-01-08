function widget:GetInfo()
  return {
    name      = "FastSwitch",
    desc      = "Spacebar switches camera to your base or your camera, whichever is more distant from you",
    author    = "Beherith",
    date      = "9/15/2008",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

--Choose which spacebar modifier key you want:
local useALT =false
local useCTRL =true







local spacebar=false
local unitList = {}
local homecamx
local homecamy
local homecamz
local firstframe=true

function widget:Update()

local t = Spring.GetGameSeconds()
  if  t > 0 and firstframe then
    unitList = Spring.GetTeamUnits(Spring.GetMyTeamID())
    homecamx, homecamy, homecamz = Spring.GetUnitPosition(unitList[1])
	firstframe=false
  end
  if  t > 1 then
	local alt,ctrl,meta,space = Spring.GetModKeyState()
--	Spring.Echo(meta)
--	Spring.Echo(space)

	local modifierused 
	if useALT then modifierused= alt
	else modifierused=ctrl end

	if (meta) and modifierused then
--		Spring.Echo("I smell space")
		if spacebar then			
			return
		else
			--HERE WE MOVE
			local newpos
			--comander pos:
			unitList = Spring.GetTeamUnits(Spring.GetMyTeamID())
    		local x, y, z = Spring.GetUnitPosition(unitList[1])
			local cx,cy,cz = Spring.GetCameraPosition()
			
			if 	((cx-x)*(cx-x)+(cy-y)*(cy-y)+(cz-z)*(cz-z))< ((cx-homecamx)*(cx-homecamx)+(cy-homecamy)*(cy-homecamy)+(cz-homecamz)*(cz-homecamz))then
				Spring.SetCameraTarget(homecamx,homecamy,homecamz,0.2)
			else
				Spring.SetCameraTarget(x,y,z,0.2)
			end
			spacebar= meta;

		end
	else
		if spacebar then			
			spacebar= meta;
		else
			return			
		end		
	end
  end
end
