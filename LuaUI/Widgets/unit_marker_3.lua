function widget:GetInfo()
	return {
		name      = "Unit Marker 3",
		version   = "3.2 beta",
		desc      = "Marks spotted units of interest.",
		author    = "Pako",
		date      = "2010.05.02",
		license   = "GNU GPL v2",
		layer     = 0,
		enabled   = true
	}
end

local comList = {
  ["ATFA"] = {
    [UnitDefNames["armcom"].id] = {}, --[teamID] = {pos}
    [UnitDefNames["corcom"].id] = {},
  }
}

local unitList = {}
--MARKER LIST ------------------------------------
unitList["ATFA"] = {
[UnitDefNames["armamd"].id] = "Antinuke",
[UnitDefNames["corfmd"].id] = "Antinuke",
[UnitDefNames["armsilo"].id] = 	{["en"]="Nuke", 	["fi"]="Ydinsiilo",	["ru"]="нюк"},
[UnitDefNames["corsilo"].id] = 	{["en"]="Nuke", 	["fi"]="Ydinsiilo",	["ru"]="нюк"},

[UnitDefNames["aafus"].id] = 	{["en"]="Adv. fusion", 	["fi"]="Atomivoimala",	["ru"]="Афуз" },
[UnitDefNames["cafus"].id] = 	{["en"]="Adv. fusion", 	["fi"]="Atomivoimala",	["ru"]="Афуз" },

[UnitDefNames["amgeo"].id] = 	{["en"]="Moho Geo", 	["fi"]="Kaasuvoimala",	["ru"]="Хазардус" },
[UnitDefNames["cmgeo"].id] = 	{["en"]="Moho Geo", 	["fi"]="Kaasuvoimala",	["ru"]="Хазардус" },

[UnitDefNames["armbrtha"].id] = {["en"]="LRPC", 	["fi"]="Tykki",		["ru"]="Берта" },
[UnitDefNames["corint"].id] = 	{["en"]="LRPC", 	["fi"]="Tykki" ,	["ru"]="Царь Пушка"},

[UnitDefNames["armemp"].id] = 	{["en"]="EMP Silo", 	["fi"]="EMP-siilo",	["ru"]="ЕМП" },

[UnitDefNames["armvulc"].id] = 	{["en"]="Vulcan", 	["fi"]="Sarjatulitykki",["ru"]="Пиздец" },
[UnitDefNames["corbuzz"].id] = 	{["en"]="Buzz", 	["fi"]="Sahatykki", 	["ru"]="Царь Пушка" },

[UnitDefNames["cortron"].id] = 	{["en"]="Tactical Nuke",["fi"]="Taktinen ohjus" },

[UnitDefNames["armshltx"].id] = {["en"]="Gantry", 	["fi"]="Roboottilabra" },
[UnitDefNames["corgant"].id] = 	{["en"]="Gantry", 	["fi"]="Roboottilabra" },

[UnitDefNames["corkrog"].id] = 	{["en"]="Kroggy",	 ["fi"]="Iso robootti" },

[UnitDefNames["corblackhy"].id]={["en"]="Fagship", 	["fi"]="Homovene" },
[UnitDefNames["aseadragon"].id]={["en"]="Fagship", 	["fi"]="Homovene" }
}

--END OF MARKER LIST---------------------------------------


local myLang = "en" -- --set this if you want to bypass lobby country

local myPlayerID
local curModID
local curUnitList
local curComList

local knownUnits = {} --all units that have been marked already, so they wont get marked again

local teamNames = {}

local function GetTeamName(teamID)
  local name = teamNames[teamID]
  if (name) then
    return name
  end

  local teamNum, teamLeader = Spring.GetTeamInfo(teamID)
  if (teamLeader == nil) then
    return "@ Left Fucker @"
  end

  name = Spring.GetPlayerInfo(teamLeader)
  teamNames[teamID] = name
  return name or "Gaia"
end

function widget:Initialize()
		
	curModID = string.upper(Game.modShortName or "")
	
	if ( unitList[curModID] == nil ) then
	  _,curUnitList = next(unitList)
	  _,curComList = next(comList)
	  curComList = curComList or {}
	else
		curUnitList = unitList[curModID]	
		curComList = comList[curModID] or {}
	end
	
	myLang = myLang or string.lower(select(8,Spring.GetPlayerInfo(Spring.GetMyPlayerID())))
end


local IsUnitAllied = Spring.IsUnitAllied
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitPosition = Spring.GetUnitPosition

local lastComMark = 0

function widget:UnitEnteredLos(unitID, allyTeam)
	if ( IsUnitAllied( unitID ) ) then return end

	local udefId = GetUnitDefID(unitID)
	local x, y, z = GetUnitPosition(unitID)
	
	if udefId and x then
	  if curUnitList[udefId] then
		--the unit is in the list -> has to get marked
		if ( knownUnits[unitID] == nil ) or ( knownUnits[unitID] ~= udefId ) then
			--unit wasnt marked already or unit changed
			knownUnits[unitID] = udefId
			setMarkerForUnit( unitID, udefId,  x,y,z )
		end
	  elseif curComList[udefId] and lastComMark+5 < Spring.GetGameSeconds() then --always mark the commanders
	    lastComMark = Spring.GetGameSeconds()
	    local teamID = Spring.GetUnitTeam(unitID)
	    local pos = curComList[udefId][teamID]
	    if pos then
	      Spring.MarkerErasePosition(unpack(pos))
	    end
	    curComList[udefId][teamID] = {x,y,z}
	    Spring.MarkerAddPoint(x,y,z,GetTeamName(teamID).."'s com")
	  end
	end
end


function setMarkerForUnit( unitId, udefId, x,y,z )

  local markerText = curUnitList[udefId]

  if type(markerText)=="table" then 	
	local lang = markerText[myLang]
	markerText = lang or markerText["en"]
  end
  if markerText then
	Spring.MarkerAddPoint(x,y,z,markerText)
  end
end


