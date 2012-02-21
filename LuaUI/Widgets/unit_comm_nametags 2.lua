

function widget:GetInfo()
  return {
    name      = "Commander Name Tags 2",
    version   = "2.1",
    desc      = "Displays a name tag above each commander.",
    author    = "Evil4Zerggin and CarRepairer, Pako",
    date      = "2011.05.26",
    license   = "GNU GPL, v2 or later",
    layer     = 10000,
    enabled   = true  --  loaded by default?
  }
end

--TODO
--fetch enemy commander IDs from _WG table so no need to check all units coming to LOS
--clean all unnecassary shit
--better zooming and color contrast for name text
--put (2nd) (3th) for commanders of a player with multiple coms

--------------------------------------------------------------------------------
-- config
--------------------------------------------------------------------------------

local showStickyTags = false --comms literally wear name tags
local heightOffset = 22
local xOffset = 0
local yOffset = 0
local fontSize = 20


local comList = {
    [UnitDefNames["armcom"].id] = {},
    [UnitDefNames["corcom"].id] = {},
  }
--------------------------------------------------------------------------------
-- speed-ups
--------------------------------------------------------------------------------

local GetUnitTeam         = Spring.GetUnitTeam
local GetTeamInfo         = Spring.GetTeamInfo
local GetPlayerInfo       = Spring.GetPlayerInfo
local GetTeamColor        = Spring.GetTeamColor
local GetUnitViewPosition = Spring.GetUnitViewPosition
local GetVisibleUnits     = Spring.GetVisibleUnits
local GetUnitDefID        = Spring.GetUnitDefID
local GetAllUnits         = Spring.GetAllUnits
local GetUnitHeading      = Spring.GetUnitHeading

local glColor             = gl.Color
--local glText              = gl.Text
local glPushMatrix        = gl.PushMatrix
local glPopMatrix         = gl.PopMatrix
local glTranslate         = gl.Translate
local glBillboard         = gl.Billboard
local glDrawFuncAtUnit    = gl.DrawFuncAtUnit

local glDepthTest      = gl.DepthTest
local glAlphaTest      = gl.AlphaTest
local glTexture        = gl.Texture
local glTexRect        = gl.TexRect
local glRotate         = gl.Rotate

--------------------------------------------------------------------------------
-- local variables
--------------------------------------------------------------------------------

--key: unitID
--value: attributes = {name, color, height, currentAttributes, torsoPieceID}
--currentAttributes = {name, color, height}
local comms = {}

--------------------------------------------------------------------------------
-- helper functions
--------------------------------------------------------------------------------
local teams = {}
local function getPlayerName(team)
  local players = Spring.GetPlayerList(team)
  local playerIDs = {}
  local name = ""
  if #players > 0 then
	for i,m in ipairs(players) do --stupid bugs
		local n,_,spec,tID = GetPlayerInfo(m)
		if (not spec) and team == tID and n then
			name = name..n.."\n"
			playerIDs[m] = m
		end
	end
  else
    _, name = Spring.GetAIInfo(team)
    name = "AI: "..name
  end
  return name or 'Left\nFucker', playerIDs
end
--gets the name, color, and height of the commander
local function GetCommAttributes(unitID)
  local team = GetUnitTeam(unitID)
  local name, playerIDs = getPlayerName(team)
  local r, g, b, a = GetTeamColor(team)

  local height = 50
  local pm = spGetUnitPieceMap(unitID)
  local pmt = pm["torso"]
  if (pmt == nil) then
    pmt = pm["chest"]
  end
  return {name, {r, g, b, a}, height, pmt, playerIDs}
end


local spec

function widget:Initialize()
spec = Spring.GetSpectatingState()
comms = {}
  local allUnits = GetAllUnits()
  for _, unitID in pairs(allUnits) do
    local unitDefID = GetUnitDefID(unitID)
    if (unitDefID and comList[unitDefID]) then
      comms[unitID] = GetCommAttributes(unitID, unitDefID)
    end
  end
end

function spGetUnitPieceMap(unitID,piecename)
  local pieceMap = {}
  for piecenum,piecename in pairs(Spring.GetUnitPieceList(unitID)) do
    pieceMap[piecename] = piecenum
  end
  return pieceMap
end

local dd = 0

function widget:DrawScreenEffects()
local glColor = gl.Color
local glText = gl.Text
 for unitID, attributes in pairs(comms) do
	local x,y,z = Spring.GetUnitPosition(unitID)
	if x then
	local xx,yy,zz = Spring.WorldToScreenCoords(x,y+40,z)
	if xx and yy then
	glColor(0,0,0, (1.003 - zz)*150%1)

	attributes[2][4] = (1.005 - zz)*200%1
	--glColor(attributes[2])
	glText(attributes[1], xx,yy, 18, "cn")
	glColor(attributes[2])
	glText(attributes[1], xx-2,yy+2, 18, "cn")
	end
	end
end
glColor(1,1,1,1)
end


function widget:UnitCreated( unitID,  unitDefID,  unitTeam)
  if (unitDefID and comList[unitDefID]) then
    comms[unitID] = GetCommAttributes(unitID, unitDefID)
  end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  comms[unitID] = nil
end

function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
  widget:UnitCreated( unitID,  unitDefID,  unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
  widget:UnitCreated( unitID,  unitDefID,  unitTeam)
end

function widget:UnitEnteredLos(unitID, unitTeam)
  if comList[GetUnitDefID(unitID)] then
    widget:UnitCreated( unitID,  GetUnitDefID(unitID),  unitTeam)
  end
end

function widget:PlayerChanged(playerID)
 for unitID, attributes in pairs(comms) do
    if attributes[5][playerID] then
      comms[unitID][1] = comms[unitID][1]..'Left Fucker'
    end
  end

if not spec then
	spec = Spring.GetSpectatingState()
	if spec then
		widget:Initialize() --doesn't seem to work if not full LOS yet
	end
end

end

