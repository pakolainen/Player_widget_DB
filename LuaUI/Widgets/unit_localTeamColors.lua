local versionNumber = "1.2"

function widget:GetInfo()
	return {
		name      = "Local Team Colors",
		desc      = "[v" .. string.format("%s", versionNumber ) .. "] Changes team colors of known players",
		author    = "very_bad_soldier",
		date      = "April 25, 2009",
		license   = "GNU GPL v2",
		layer     = 0,
		enabled   = true
	}
end

--[[
ideas:
-recolor duplicated colors
-recolor "bad" colors: black and white
-recolor player with same clantag (maybe hardcoded clantag-base-colors?)
--]]

local debug = false

local customColors = {}
--An entry should look like this:
--customColors["[x]very_bad_soldier"] = { r = 1.0, g = 0.65098, b = 0.0 }

local colorThresh = 100

-------------------------------------------------------------
local spSetTeamColor 		= Spring.SetTeamColor
local spGetTeamColor		= Spring.GetTeamColor
local spGetTeamOrigColor	= Spring.GetTeamOrigColor
local spGetTeamList			= Spring.GetTeamList
local spGetTeamInfo			= Spring.GetTeamInfo
local spGetPlayerRoster		= Spring.GetPlayerRoster
local spEcho				= Spring.Echo

local sqrt					= math.sqrt
local huge					= math.huge
---------------------------------------------------------------
local teamList = {}
local originalColors = {}

--calculate distance between two rgb colors by laws of human perception
--stolen from: http://www.compuphase.com/cmetric.htm
function GetColorDistance(color1, color2 )
  local rmean = ( color1.r + color2.r ) / 2;
  local r = color1.r - color2.r;
  local g = color1.g - color2.g;
  local b = color1.b - color2.b;
  
  local a = ((512+rmean)*r*r)
  local b = ((767-rmean)*b*b)
  return sqrt(( a * 256 ) + 4*g*g + ( b * 256 ));
end

function GetSameColorTeam( ownerTeamId, color )
	local minDist = huge
	local minTeamId = nil
	
	printDebug("SameTeamColor: " )
	
	for key, team in pairs(teamList) do
		--printDebug("k: " .. key)
		--printDebug("team: " )
		--printDebug( team)
		
		if ( ownerTeamId ~= key ) then
			--printDebug("Player v=" .. customColors[player[1]]["r"] )
				
			local r,g,b = spGetTeamOrigColor( key )
			local colTab = { r = r, g = g, b = b }
			printDebug("Searching team for similar color: " .. key .. " r=" .. r .. " g=" .. g .. " b=" .. b )
					
			local colDist = GetColorDistance( color, colTab )
			printDebug( "d: " .. colDist )
			
			if ( colDist < minDist ) then
				minDist = colDist
				minTeamId = key
			end
		else
			printDebug("Team skipped, same id as owner")
		end
	end
	
	return minTeamId, minDist
end

function widget:Initialize()
	printDebug("Init:" )
	local teamIds = spGetTeamList()
	for _, teamId in pairs(teamIds) do
		local teamNum, leader, isDead, isAiTeam, side, allyTeam = spGetTeamInfo( teamId )
		if ( teamNum ~= nil and leader ~= -1 ) then --leader == -1 -> Gaia? i hope so
			teamList[teamId] = { teamNum, leader, isDead, isAiTeam, side, allyTeam }
			printDebug( "team " .. teamId .. ":" )
			printDebug( teamList[teamId] )
		end
	end
end


function widget:GameStart()
	local playerList = spGetPlayerRoster()
	printDebug( playerList )
	for _, player in pairs(playerList) do
		if ( type( player ) == "table" ) then
			printDebug("PLAYER")
			if ( customColors[player[1]] ~= nil ) then
				--printDebug("Player found: r=" .. customColors[player[1]]["r"] )
				
				local sameColorTeamId, colorDist = GetSameColorTeam( player[1], customColors[player[1]] )
				printDebug("Nearest Color distance: " .. colorDist )
				local r,g,b = spGetTeamOrigColor( player[3] )
				if ( sameColorTeamId ~= nil and colorDist < colorThresh ) then
					spSetTeamColor( sameColorTeamId, r, g, b )
				end
				
				--save old color
				originalColors[ player[3] ] = { teamId = player[3], r = r, g = g, b = b }
				
				printDebug( "Player recolored: " .. player[1] )
				spSetTeamColor( player[3], customColors[player[1]]["r"], customColors[player[1]]["g"], customColors[player[1]]["b"] )
			end
		end
	end
end

function widget:ResetColors()
	for _, oldColor in pairs(originalColors) do
		printDebug( "Reset color for team: " .. oldColor["teamId"] )
		spSetTeamColor( oldColor["teamId"], oldColor["r"], oldColor["g"], oldColor["b"] )
	end
end

function widget:Shutdown()
	ResetColors()
end

function printDebug( value )
	if ( debug ) then
		if ( type( value ) == "boolean" ) then
			if ( value == true ) then spEcho( "true" )
				else spEcho("false") end
		elseif ( type(value ) == "table" ) then
			spEcho("Dumping table:")
			for key,val in pairs(value) do 
				spEcho(key,val) 
			end
		else
			spEcho( value )
		end
	end
end
