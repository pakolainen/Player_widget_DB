
----------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Mobile Anti Marker",
    desc      = "Marks mobile antis",
    author    = "Niobium",
    date      = "10th Jan 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

----------------------------------------------------------------

local spGetMyPlayerID		= Spring.GetMyPlayerID
local spGetPlayerInfo		= Spring.GetPlayerInfo
local spGetMyAllyTeamID	= Spring.GetMyAllyTeamID
local spGetUnitDefID	= Spring.GetUnitDefID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitVelocity = Spring.GetUnitVelocity
local spMarkerAddPoint	= Spring.MarkerAddPoint

----------------------------------------------------------------

local marked = {}

----------------------------------------------------------------

function widget:Initialize() 
	widget:Update()
end

function widget:Update()

	local _, _, spec = spGetPlayerInfo(spGetMyPlayerID())

	if (spec == true) then
		spEcho("<MobileAntiMarker> Spectator mode. Widget removed.")
		widgetHandler:RemoveWidget()
		return false
	end
end


function widget:UnitEnteredLos(uID, allyTeam)

	if (marked[uID]) then return end

	if (allyTeam == spGetMyAllyTeamID()) then return end
	
	local uDefID = spGetUnitDefID(uID)

	-- if (uDefID == nil) then return end -- Shouldn't need as we have LOS
	
	if ((UnitDefs[uDefID].name ~= 'armscab') and (UnitDefs[uDefID].name ~= 'cormabm')) then return end

	local vx, vy, vz = spGetUnitVelocity(uID)

	if ((vx ~= 0) or (vy ~= 0) or (vz ~= 0)) then
		local x, y, z = spGetUnitPosition(uID)
		spMarkerAddPoint(x, y, z, "Mobile Anti (Moving)")
	else
		local x, y, z = spGetUnitPosition(uID)
		spMarkerAddPoint(x, y, z, "Mobile Anti (Stationary)")
	end

	marked[uID] = true
end

----------------------------------------------------------------
