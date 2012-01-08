function widget:GetInfo()
	return {
		name = "Build Range Display",
		desc = "Displays the build range for the starting unit when choosing start positions.\nUseful for immobile commanders",
		author = "KDR_11k (David Becker)",
		date = "2009-01-21",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local sides={}

local glColor=gl.Color
local glDrawGroundCircle=gl.DrawGroundCircle
local sGetTeamList=Spring.GetTeamList
local sGetTeamStartPosition=Spring.GetTeamStartPosition
local sGetTeamInfo=Spring.GetTeamInfo

function widget:Initialize()
	for _,d in ipairs(Spring.GetSideData()) do
		sides[d.sideName]=UnitDefNames[d.startUnit].buildDistance
	end
end

function widget:DrawWorld()
	glColor(.25,1,.5,1)
	for _,t in ipairs(sGetTeamList()) do
		local x,y,z = sGetTeamStartPosition(t)
		if x then
			local _,_,_,_,s = sGetTeamInfo(t)
			if sides[s] then
				glDrawGroundCircle(x,y,z,sides[s],60)
			end
		end
	end
	glColor(1,1,1,1)
end

function widget:GameFrame(f)
	if f > 1 then
		widgetHandler:RemoveWidget()
	end
end
