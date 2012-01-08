local versionNumber = "1.0"

function widget:GetInfo()
  return {
    name      = "Commander Name Tags" .. versionNumber,
    desc      = "Displays a name tag above each commander.",
    author    = "Evil4Zerggin",
    date      = "18 April 2008",
    license   = "GNU GPL, v2 or later",
    layer     = -10,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
local heightOffset = 24
local fontSize = 6
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
local glColor             = gl.Color
local glText              = gl.Text
local glPushMatrix        = gl.PushMatrix
local glTranslate         = gl.Translate
local glBillboard         = gl.Billboard
local glPopMatrix         = gl.PopMatrix

--------------------------------------------------------------------------------
-- helper functions
--------------------------------------------------------------------------------

local function GetUnitPlayerName(unitID)
  local team = GetUnitTeam(unitID)
  local player
  _, player = GetTeamInfo(team)
  local name = GetPlayerInfo(player)
  local r, g, b, a = GetTeamColor(team)
  return name, {r, g, b, a,}
end

local function DrawUnitPlayerName(unitID, height)
  local ux, uy, uz = GetUnitViewPosition(unitID)
  local name, color = GetUnitPlayerName(unitID)
  
  glPushMatrix()
  glTranslate(ux, uy + height, uz )
  glBillboard()
  
  glColor(color)
  glText(name, 0, 0, fontSize, "cn")
  
  glPopMatrix()
end

--------------------------------------------------------------------------------
-- callins
--------------------------------------------------------------------------------

function widget:DrawWorld()
  local visibleUnits = GetVisibleUnits(ALL_UNITS,nil,true)
  for i=1,#visibleUnits do
    local unitID    = visibleUnits[i]
    local unitDefID = GetUnitDefID(unitID)
    local unitDef   = UnitDefs[unitDefID or -1]
    local height    = unitDef.height+heightOffset
    if (unitDef and unitDef.isCommander) then
      DrawUnitPlayerName(unitID, height)
    end
  end
end
