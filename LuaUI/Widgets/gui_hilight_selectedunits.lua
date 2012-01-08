--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_highlight_unit.lua
--  brief:   highlights the unit/feature under the cursor
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "HighlightSelectedUnits",
    desc      = "Highlights the selelected units",
    author    = "zwzsg, from trepan HighlightUnit",
    date      = "Apr 24, 2009",
    license   = "GNU GPL, v2 or later",
    layer     = 25,
    enabled   = true
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local GL_BACK                   = GL.BACK
local GL_EYE_LINEAR             = GL.EYE_LINEAR
local GL_EYE_PLANE              = GL.EYE_PLANE
local GL_FILL                   = GL.FILL
local GL_FRONT                  = GL.FRONT
local GL_FRONT_AND_BACK         = GL.FRONT_AND_BACK
local GL_INVERT                 = GL.INVERT
local GL_LINE                   = GL.LINE
local GL_ONE                    = GL.ONE
local GL_ONE_MINUS_SRC_ALPHA    = GL.ONE_MINUS_SRC_ALPHA
local GL_POINT                  = GL.POINT
local GL_QUAD_STRIP             = GL.QUAD_STRIP
local GL_SRC_ALPHA              = GL.SRC_ALPHA
local GL_T                      = GL.T
local GL_TEXTURE_GEN_MODE       = GL.TEXTURE_GEN_MODE
local GL_TRIANGLE_FAN           = GL.TRIANGLE_FAN
local glBeginEnd                = gl.BeginEnd
local glBlending                = gl.Blending
local glCallList                = gl.CallList
local glColor                   = gl.Color
local glCreateList              = gl.CreateList
local glCulling                 = gl.Culling
local glDeleteList              = gl.DeleteList
local glDeleteTexture           = gl.DeleteTexture
local glDepthTest               = gl.DepthTest
local glFeature                 = gl.Feature
local glGetTextWidth            = gl.GetTextWidth
local glLineWidth               = gl.LineWidth
local glLogicOp                 = gl.LogicOp
local glPointSize               = gl.PointSize
local glPolygonMode             = gl.PolygonMode
local glPolygonOffset           = gl.PolygonOffset
local glPopMatrix               = gl.PopMatrix
local glPushMatrix              = gl.PushMatrix
local glScale                   = gl.Scale
local glSmoothing               = gl.Smoothing
local glTexCoord                = gl.TexCoord
local glTexGen                  = gl.TexGen
local glText                    = gl.Text
local glTexture                 = gl.Texture
local glTranslate               = gl.Translate
local glUnit                    = gl.Unit
local glVertex                  = gl.Vertex
local spDrawUnitCommands        = Spring.DrawUnitCommands
local spGetFeatureAllyTeam      = Spring.GetFeatureAllyTeam
local spGetFeatureDefID         = Spring.GetFeatureDefID
local spGetFeaturePosition      = Spring.GetFeaturePosition
local spGetFeatureRadius        = Spring.GetFeatureRadius
local spGetFeatureTeam          = Spring.GetFeatureTeam
local spGetModKeyState          = Spring.GetModKeyState
local spGetMouseState           = Spring.GetMouseState
local spGetMyAllyTeamID         = Spring.GetMyAllyTeamID
local spGetMyPlayerID           = Spring.GetMyPlayerID
local spGetMyTeamID             = Spring.GetMyTeamID
local spGetPlayerControlledUnit = Spring.GetPlayerControlledUnit
local spGetPlayerInfo           = Spring.GetPlayerInfo
local spGetSelectedUnits        = Spring.GetSelectedUnits
local spGetSpectatingState      = Spring.GetSpectatingState
local spGetTeamColor            = Spring.GetTeamColor
local spGetTeamInfo             = Spring.GetTeamInfo
local spGetUnitAllyTeam         = Spring.GetUnitAllyTeam
local spGetUnitDefID            = Spring.GetUnitDefID
local spGetUnitHealth           = Spring.GetUnitHealth
local spGetUnitIsCloaked        = Spring.GetUnitIsCloaked
local spGetUnitTeam             = Spring.GetUnitTeam
local spIsCheatingEnabled       = Spring.IsCheatingEnabled
local spTraceScreenRay          = Spring.TraceScreenRay
local spSetTeamColor            = Spring.SetTeamColor

--------------------------------------------------------------------------------

include("colors.h.lua")
include("fonts.lua")

local font = 'FreeMonoBold'
local fontSize = 16
local fontName = ':n:'..LUAUI_DIRNAME..'Fonts/'..font..'_'..fontSize
local previousTeamColor
local myTeamId = nil


local showName = (1 > 0)

local customTex = LUAUI_DIRNAME .. 'Images/highlight_strip.png'
local texName = LUAUI_DIRNAME .. 'Images/highlight_strip.png'
--local texName = 'bitmaps/laserfalloff.tga'

local cylDivs = 64
local cylList = 0

local outlineWidth = 3

local vsx, vsy = widgetHandler:GetViewSizes()
function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end

local smoothPolys = (glSmoothing ~= nil) and false

--------------------------------------------------------------------------------

function widget:Initialize()
  cylList = glCreateList(DrawCylinder, cylDivs)
  if nil~=0 then
   Spring.Echo("nil~=0")
  end
end


function widget:Shutdown()
  glDeleteList(cylList)
  glDeleteTexture(customTex)
  if myTeamId then
    spSetTeamColor(myTeamId,unpack(previousTeamColor))
  end
end

--------------------------------------------------------------------------------

function DrawCylinder(divs)
  local cos = math.cos
  local sin = math.sin
  local divRads = (2.0 * math.pi) / divs
  -- top
  glBeginEnd(GL_TRIANGLE_FAN, function()
    for i = 1, divs do
      local a = i * divRads
      glVertex(sin(a), 1.0, cos(a))
    end
  end)
  -- bottom
  glBeginEnd(GL_TRIANGLE_FAN, function()
    for i = 1, divs do
      local a = -i * divRads
      glVertex(sin(a), -1.0, cos(a))
    end
  end)
  -- sides
  glBeginEnd(GL_QUAD_STRIP, function()
    for i = 0, divs do
      local a = i * divRads
      glVertex(sin(a),  1.0, cos(a))
      glVertex(sin(a), -1.0, cos(a))
    end
  end)
end

--------------------------------------------------------------------------------

local function HilightModel(drawFunc, drawData, outline)
  glDepthTest(true)
  glPolygonOffset(-2, -2)
  glBlending(GL_SRC_ALPHA, GL_ONE)

  if (smoothPolys) then
    glSmoothing(nil, nil, true)
  end

  local scale = 20
  local shift = (2 * widgetHandler:GetHourTimer()) % scale
  glTexCoord(0, 0)
  glTexGen(GL_T, GL_TEXTURE_GEN_MODE, GL_EYE_LINEAR)
  glTexGen(GL_T, GL_EYE_PLANE, 0, (1 / scale), 0, shift)
  glTexture(texName)

  drawFunc(drawData)

  glTexture(false)
  glTexGen(GL_T, false)

  -- more edge highlighting
  if (outline) then
    glLineWidth(outlineWidth)
    glPointSize(outlineWidth)
    glPolygonOffset(10, 100)
    glPolygonMode(GL_FRONT_AND_BACK, GL_POINT)
    drawFunc(drawData)
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    drawFunc(drawData)
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
    glPointSize(1)
    glLineWidth(1)
  end

  if (smoothPolys) then
    glSmoothing(nil, nil, false)
  end

  glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  glPolygonOffset(false)
  glDepthTest(false)
end

--------------------------------------------------------------------------------

local function SetUnitColor(unitID, alpha)
  local health,maxHealth,paralyzeDamage,captureProgress,buildProgress=spGetUnitHealth(unitID)
  gl.Color(
    health>maxHealth/2 and 2-2*health/maxHealth or 1, -- red
    health>maxHealth/2 and 1 or 2*health/maxHealth, -- green
    0, -- blue
    alpha) -- alpha
end

local function UnitDrawFunc(unitID)
  glUnit(unitID, true)
end

local function HilightUnit(unitID)
  local outline = (spGetUnitIsCloaked(unitID) ~= true)
  SetUnitColor(unitID, outline and 0.5 or 0.25)
  HilightModel(UnitDrawFunc, unitID, outline)
end



local function GreyTeamColor()
  local spectating, fullView, fullSelect = spGetSpectatingState()
  local redo = (myTeamId and ((myTeamId~=spGetMyTeamID() or (spectating and fullSelect)))) or not (myTeamId or (spectating and fullSelect))
  if redo then
    if myTeamId then
      spSetTeamColor(myTeamId,unpack(previousTeamColor))
    end
    myTeamId=spGetMyTeamID()
    if (spectating and fullSelect) then
      myTeamId = nil
    end
    if myTeamId then
      previousTeamColor = {spGetTeamColor(myTeamId)}
      spSetTeamColor(spGetMyTeamID(),0.5,0.5,0.5)
    end
  end
end

--------------------------------------------------------------------------------

function widget:DrawWorld()
  GreyTeamColor() -- Comment this with some -- if you don't want your team to turn grey
  for _,u in ipairs(spGetSelectedUnits()) do
    HilightUnit(u)
  end
end

widget.DrawWorldReflection = widget.DrawWorld

widget.DrawWorldRefraction = widget.DrawWorld

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
