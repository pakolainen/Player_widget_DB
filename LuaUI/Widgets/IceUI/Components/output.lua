--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    output.lua
--  brief:   components that just display stuff
--  author:  Jan Holthusen
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local GL_QUADS         = GL.QUADS
local glBeginEnd       = gl.BeginEnd
local glColor          = gl.Color
local glDrawMiniMap    = gl.DrawMiniMap
local glGetTextWidth   = gl.GetTextWidth
local glRect           = gl.Rect
local glResetMatrices  = gl.ResetMatrices
local glResetState     = gl.ResetState
local glShape          = gl.Shape
local glTexRect        = gl.TexRect
local glText           = gl.Text
local glTexture        = gl.Texture
local glVertex         = gl.Vertex
local spAreTeamsAllied = Spring.AreTeamsAllied
local spGetMyTeamID    = Spring.GetMyTeamID
local spGetPlayerInfo  = Spring.GetPlayerInfo
local spGetPlayerList  = Spring.GetPlayerList
local spGetTeamInfo    = Spring.GetTeamInfo
local spGetUnitDefID   = Spring.GetUnitDefID
local spSendCommands   = Spring.SendCommands
local glCreateList     = gl.CreateList
local glCallList       = gl.CallList
local glDeleteList     = gl.DeleteList

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

empty = {
  className = "empty"
}
empty = GenMeta(empty, component)
function empty:New()
  local newObject = GenMeta({}, empty)
  newObject:Init()
  return newObject
end

color = {
  className = "color",
  color = { 0.54, 0.54, 0.54, 0.8 },
  displayList = nil
}
color = GenMeta(color, component)
function color:New(newColor)
  local newObject = GenMeta({}, color)
  newObject:Init()
  if newColor then
    if newColor.key then
      newObject.colorListener = profileManager:RegisterColorListener(newColor, newObject, function(newColor)
        newObject:SetColor(newColor)
      end)
    else
      newObject:SetColor(newColor)
    end
  else
    newObject.colorListener = profileManager:RegisterColorListener({
      key = 'background',
      desc = 'Background Color',
      color =  { 0.54, 0.54, 0.54, 0.8 }
    }, newObject, function(newColor)
      newObject:SetColor(newColor)
    end)
  end
  return newObject
end
function color:DrawScreen()
  if self.color[4] > 0 then
    glColor(self.color)
    glRect(self:GetX(), self:GetY()+1, self:GetR(), self:GetB()+1)
  end
end
function color:SetColor(newColor)
  self.color = newColor
end
function color:OnParentChange()
  if self.colorListener then
    profileManager:CallColorListener(self.colorListener)
  end
end
function color:OnDestroy()
  if self.colorListener then
    profileManager:UnregisterColorListener(self.colorListener)
    self.colorListener = nil
  end
end

gradient = {
  className = "gradient",
  topLeft = { 0.54, 0.54, 0.54, 0.8 },
  topRight = { 0.54, 0.54, 0.54, 0.8 },
  bottomRight = { 0.78, 0.78, 0.78, 1.0 },
  bottomLeft = { 0.78, 0.78, 0.78, 1.0 },
  displayList = nil
}
gradient = GenMeta(gradient, component)
function gradient:New(newTopLeft, newTopRight, newBottomRight, newBottomLeft)
  local newObject = GenMeta({}, gradient)
  newObject:Init()
  if newTopLeft     then newObject.topLeft     = newTopLeft     end
  if newTopRight    then newObject.topRight    = newTopRight    end
  if newBottomRight then newObject.bottomRight = newBottomRight end
  if newBottomLeft  then newObject.bottomLeft  = newBottomLeft  end
  return newObject
end
function gradient:DrawScreen()
  glColor(1,1,1)
  glShape(GL_QUADS, {
    { v = { self:GetR(), self:GetB()+1 }, color = self.bottomRight },
    { v = { self:GetX(), self:GetB()+1 }, color = self.bottomLeft  },
    { v = { self:GetX(), self:GetY()+1 }, color = self.topLeft     },
    { v = { self:GetR(), self:GetY()+1 }, color = self.topRight    }
  })
end
function gradient:DrawScreenWithDisplayLists()
  glCallList(self.displayList)
end
function gradient:OnResizeWithDisplayLists()
  if self.displayList then glDeleteList(self.displayList) end
  self.displayList = glCreateList(function()
    local x, y, r, b = self:GetX(), self:GetY()+1, self:GetR(), self:GetB()+1
    glBeginEnd(GL_QUADS, function()
      glColor(self.bottomLeft)
      glVertex(x,b)
      glColor(self.bottomRight)
      glVertex(r,b)
      glColor(self.topRight)
      glVertex(r,y)
      glColor(self.topLeft)
      glVertex(x,y)
    end)
  end)
end

text = {
  className = "text",
  text = "",
  lines = 1,
  scaleIfLess = true,
  align = "left",
  valign = "middle",
  margins = { 2, 2, 2, 2 },
  trim = false,
  fontHandler = true,
  font = "FreeSansBold",
  availableFontSizes = {},
  color = {1,1,1,1}
}
text = GenMeta(text, component)
function text:New(newTable)
  if type(newTable) == 'string' then newTable = { text=newTable } end
  local newObject = GenMeta(newTable, text)
  newObject:Init()
  if text.availableFontSizes[newObject.font] == nil then
    local fontFiles = VFS.DirList(FONTS_DIRNAME, "*.lua", VFS.RAW_FIRST)
    text.availableFontSizes[newObject.font] = {}
    for _,filename in ipairs(fontFiles) do
      --string.lower() to workaround a Spring bug that returns filenames in a mod archive in lowercase
      local err, _, size = string.find(string.lower(filename), string.lower(self.font).."_(%d+)\.")
      if err ~= nil then
        table.insert(text.availableFontSizes[newObject.font], tonumber(size))
      end
    end
    table.sort(text.availableFontSizes[newObject.font])
  end
  if not newObject.fontHandler or #text.availableFontSizes[newObject.font] < 2 then
    newObject.DrawScreen = newObject.NonFontHandlerDrawScreen
    newObject.SetText = newObject.NonFontHandlerSetText
  end
  newObject:SetText(newObject.text)
  return newObject
end
function text:DrawScreen()
  if self.text ~= "" then
    for i=1,self.lines do
      glColor(self.color)
      fontHandler.UseFont(":n:" .. FONTS_DIRNAME .. self.font .. "_" .. (self.sizes[i] or "12"))
      fontHandler.Draw((self.texts[i] or ""), self.xPoss[i] or 0, self.yPoss[i] or 0)
    end
  end
end
function text:NonFontHandlerDrawScreen()
  if self.text ~= "" then
    for i=1,self.lines do
      glText(self.texts[i] or "", self.xPoss[i] or  0, self.yPoss[i] or 0,
             self.sizes[i] or  0, self.optss[i] or "")
      glColor(1, 1, 1)
    end
  end
end

-- kindly provided by jnwhiteh from #lua on irc.freenode.net
local function decolorize(str)
    -- Escape any | so we can use them as an escape character
    local result = string.gsub(str,"|", "||")
    -- Replace any color strings with a more sane representation
    result = result:gsub("\255...",
                         function(cap)
                            local r, g, b = cap:byte(2), cap:byte(3), cap:byte(4)
                            local ctag = string.format("|%03d%03d%03d", r, g, b)
                            return ctag
                         end)
    -- Stop color from bleeding to the next line
--    result = result:gsub("\n", "|r\n")
    return result
end
local function colorize(str)
   local result =
      str:gsub("|[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]",
               function(cap)
                  local r,g,b = cap:sub(2,4),cap:sub(5,7),cap:sub(8,10)
--                  print(r..g..b)
                  local ctag = "\255" .. string.char(tonumber(r)) .. string.char(tonumber(g)) .. string.char(tonumber(b))
                  return ctag
               end)
   return result:gsub("||", "|")
end

function coloredLines(str)
   local itr = decolorize(str):gmatch("[^\n]+")
   return function()
             local res = itr()
             return res and colorize(res) or nil
          end
end

function text:SetText(newText)
  self.texts = {}
  self.sizes = {}
  self.xPoss = {}
  self.yPoss = {}
  self.text = newText
  local actualLines = self.lines
  if self.scaleIfLess then
    local linesInText = 0
    for _ in coloredLines(self.text) do
      linesInText = linesInText + 1
    end
    actualLines = math.min(self.lines, linesInText)
  end
  if self.text ~= "" then
    local i = 1
    local sizeWithMargins = self:GetH()/actualLines
    local size = sizeWithMargins - self.margins[2] - self.margins[4]
    for line in coloredLines(self.text) do
      local sizeIndex = 1
      local sizeTable = self.availableFontSizes[self.font]
      for j=2,#sizeTable do
        if sizeTable[j] < size then
          sizeIndex = j
        else
          break
        end
      end
      fontHandler.UseFont(":n:" .. FONTS_DIRNAME .. self.font .. "_" .. sizeTable[sizeIndex])
      while fontHandler.GetTextWidth(line) > math.max(self:GetW()-self.margins[1]-self.margins[3], 2) do
        if self.trim then
          line = string.sub(line, 1, -2)
        else
          if sizeIndex == 1 then
            break
          end
          sizeIndex = sizeIndex - 1
          fontHandler.UseFont(":n:" .. FONTS_DIRNAME .. self.font .. "_" .. sizeTable[sizeIndex])
        end
      end
      self.sizes[i] = sizeTable[sizeIndex]
      self.texts[i] = line
      local yBase = self:GetY()-(sizeWithMargins*i) + 5
      if self.valign == "top" then
        self.yPoss[i] = math.floor(yBase - self.margins[2] +  sizeWithMargins - 4 - self.sizes[i])
      elseif self.valign == "middle" then
        self.yPoss[i] = math.floor(yBase + self.margins[4]/2 - self.margins[2]/2 + (sizeWithMargins - 4 - self.sizes[i])/2)
      else
        self.yPoss[i] = math.floor(yBase + self.margins[4])
      end
      local width = fontHandler.GetTextWidth(line)
      if self.align == "left" then
        self.xPoss[i] = math.floor(self:GetX() + self.margins[1])
      elseif self.align == "center" then
        self.xPoss[i] = math.floor(self:GetX()+self:GetW()/2 + self.margins[1]/2 - self.margins[3]/2 - width/2)
      else
        self.xPoss[i] = math.floor(self:GetX()+self:GetW() - self.margins[3] - width)
      end
      if i == actualLines then break end
      i = i + 1
    end
  end
  fontHandler.UseDefaultFont()
end
function text:NonFontHandlerSetText(newText)
  self.texts = {}
  self.sizes = {}
  self.xPoss = {}
  self.yPoss = {}
  self.optss = {}
  self.text = newText
  local actualLines = self.lines
  if self.scaleIfLess then
    local linesInText = 0
    for _ in coloredLines(self.text) do
      linesInText = linesInText + 1
    end
    actualLines = math.min(self.lines, linesInText)
  end
  if self.text ~= "" then
    local i = 1
    local size = self:GetH()/actualLines
    for line in coloredLines(self.text) do
      self.sizes[i] = size - self.margins[2] - self.margins[4]
      while glGetTextWidth(line)*self.sizes[i] > math.max(self:GetW()-self.margins[1]-self.margins[3], 2) do
        if self.trim then
          line = string.sub(line, 1, -2)
        else
          self.sizes[i] = self.sizes[i] - 0.1
        end
      end
      self.texts[i] = line
      if self.valign == "top" then
        self.yPoss[i] = self:GetY()-(size*i) + 1 - self.margins[2] +  size - 4 - self.sizes[i]
      elseif self.valign == "middle" then
        self.yPoss[i] = self:GetY()-(size*i) + 1 + self.margins[4]/2 - self.margins[2]/2 + (size - 4 - self.sizes[i])/2
      else
        self.yPoss[i] = self:GetY()-(size*i) + 1 + self.margins[4]
      end
      if self.align == "left" then
        self.xPoss[i] = self:GetX() + self.margins[1]
        self.optss[i] = "o"
      elseif self.align == "center" then
        self.xPoss[i] = self:GetX()+self:GetW()/2 + self.margins[1]/2 - self.margins[3]/2
        self.optss[i] = "co"
      else
        self.xPoss[i] = self:GetX()+self:GetW() - self.margins[3]
        self.optss[i] = "ro"
      end
      if i == actualLines  then break end
      i = i + 1
    end
  end
end
function text:OnResize()
  self:SetText(self.text)
end

local win = window:New("Formatting", empty:New({}), {0, 0}, {0, 0})
win:AddOption(option:New({
                            name = "displayMinus",
                            value = false,
                            type = 'bool',
                            description = "Display a minus sign for negative numbers."
                         }))
win:AddOption(option:New({
                            name = "displaySI",
                            value = true,
                            type = 'bool',
                            description = "Display numbers with SI units (k,m,..)."
                         }))


number = {
  className = "number",
  number = 0.0,
  align = "right",
  colored = true
}
number = GenMeta(number, text)
function number:New(newTable)
  local newObject = text:New(newTable)
  newObject.children = GenMeta(newObject.children, number)
  newObject:SetNumber(newObject.number)
  return newObject
end
function number:SetNumber(newNumber)
  self:SetText(self:Format(newNumber))
end
function number:Format(newNumber)
  local SI_prefixes = { "y", "z", "a", "f", "p", "n", "u", "m", "", "k", "M", "G", "T", "P", "E", "Z", "Y" }

  local newString = "Are you kidding?"
  if math.abs(newNumber) < 10^27 and math.abs(newNumber) > 10^-27 or newNumber == 0 then
    local colorStr  = newNumber < 0 and "\255\255\128\128" or GreenStr
    colorStr        = (self.colored and newNumber ~= 0) and colorStr or ""
    local originalNumber = newNumber
    local prefix    = (win:Option("displayMinus") and originalNumber < 0) and "-" or ""
    if win:Option("displaySI") then
       local newNumber = math.abs(newNumber)
       local logNumber = newNumber == 0 and 0 or math.log(newNumber)/math.log(10)
       local suffix    = newNumber == 0 and 0 or math.floor(logNumber/3)
       local number    = (newNumber + (0.5*10^(math.floor(logNumber)-2))) / 10^(suffix*3)
       local fNumber   = string.sub(number, 1, tonumber(number) > 100 and 3 or 4)

       newString       = colorStr .. prefix .. fNumber .. SI_prefixes[suffix+9]
    else
       local newNumber = math.floor(math.abs(newNumber)*100+0.5)
       local decimal = newNumber % 100
       local integer = math.floor(newNumber / 100)
       local decPart = (integer > 100 or decimal == 0) and "" or "." .. decimal
       newString = colorStr .. prefix .. integer .. decPart
    end
  end

  return newString
end

texture = {
  className = "texture",
  filename = "playerlogo.png",
  imgSize = 32,
  innerX = 0,
  innerY = 0,
  innerW = 17,
  innerH = 16,
  color = Colors.white,
  stretch = true
}
texture = GenMeta(texture, component)
function texture:New(newTable)
  local newObject = GenMeta(newTable, texture)
  newObject:Init()
  return newObject
end
function texture:DrawScreen()
  if self.stretch then
    local iX, iY, iW, iH, iS = self.innerX, self.innerY, self.innerW, self.innerH, self.imgSize
    glColor(Colors.white)
    glTexture(":n:" .. TEXTURES_DIRNAME .. self.filename)
    glTexRect(self:GetX(), self:GetY()+1, self:GetR(), self:GetB()+1, iX/iS, iY/iS, (iX+iW)/iS, (iY+iH)/iS)
    glTexture(false)
  else
    local iX, iY, iW, iH, iS = self.innerX, self.innerY, self.innerW, self.innerH, self.imgSize
    local deltaX, deltaY = (self:GetW() - self.innerW) / 2, (self:GetH() - self.innerH) / 2
    glColor(Colors.white)
    glTexture(":n:" .. TEXTURES_DIRNAME .. self.filename)
    glTexRect(
      self:GetX()  +deltaX,
      self:GetY()+1-deltaY,
      self:GetR()  -deltaX,
      self:GetB()+1+deltaY,
      iX/iS, iY/iS, (iX+iW)/iS, (iY+iH)/iS
    )
    glTexture(false)
  end
end
function texture:SetFilename(newFilename)
  self.filename = newFilename
end

teamLogo = {
  className = "teamLogo",
  teamID = 0
}
teamLogo = GenMeta(teamLogo, component)
function teamLogo:New(newTeamID)
  local newObject = GenMeta({}, teamLogo)
  newObject:Init()
  local newLayers = layers:New({
    color:New({ 0.5, 0.5, 0.5, 0.5 }),
    margin:New(
      texture:New({
        imgSize = 64,
        innerW = 15,
        innerH = 14,
        innerY = 16
      })
    ),
    texture:New({
      imgSize = 64
    }),
    margin:New(
      texture:New({
        imgSize = 64,
        innerW = 15,
        innerH = 14,
        innerX = 17
      })
    )
  })
  newLayers:SetParent(newObject)
  newObject:SetTeamID(newTeamID or newObject.teamID)
  return newObject
end
function teamLogo:SetTeamID(newTeamID)
  local leftOffsets = { arm =  0, core = 16, dead = 16, spec = 32, unknown = 48 }
  local  topOffsets = { arm = 17, core = 17, dead = 49, spec = 49, unknown = 49 }
  local dimmSpecsBy = -0.3
  self.teamID = newTeamID
  local c = {}
  local side = ""
  if newTeamID == -1 then
    setmetatable(c, {__newindex = function(t, i, v) rawset(t, i, math.max(0, math.min(1, v + dimmSpecsBy))) end })
    c[1], c[2], c[3] = Spring.GetTeamColor(0)
    c[4] = 1
    side = "spec"
    newTeamID = 0
  else
    _, _, isDead, _, side = spGetTeamInfo(newTeamID)
    c[1], c[2], c[3] = Spring.GetTeamColor(newTeamID)
    c[4] = 1
    if isDead then
      side = "dead"
    end
  end
  self[1][1]:SetColor(c)

  self[1][2][1].innerX = leftOffsets[side] or leftOffsets.unknown
  self[1][2][1].innerY =  topOffsets[side] or  topOffsets.unknown
  local playerList = spGetPlayerList(newTeamID)
  local tooltip = "Teamlogo of "
  for _,v in ipairs(playerList) do
    local name, _, spec = spGetPlayerInfo(v)
    if not spec and name ~= "Player" then
      tooltip = tooltip .. (name or "nil") .. ", "
    end
  end
  if tooltip == "Teamlogo of " then
    if side == "spec" then
      tooltip = tooltip .. "a spectator, "
    else
      tooltip = tooltip .. "an AI, "
    end
  end
  self.tooltip = string.sub(tooltip, 0, -3) .. "."
  self[1][4][1]:SetVisibility(not (spAreTeamsAllied(spGetMyTeamID(), newTeamID) or side == "spec"))
end
function teamLogo:TeamDied(teamID)
  if self.teamID == teamID then
    self:SetTeamID(teamID)
  end
end
function teamLogo:TeamChanged()
  self:SetTeamID(self.teamID)
end

buildpic = {
  className = "buildpic",
  unitDefID = 43
}
buildpic = GenMeta(buildpic, component)
function buildpic:New(newUnitDefID)
  local newObject = GenMeta({}, buildpic)
  newObject:Init()
  newObject:SetUnitDefID(newUnitDefID or newObject.unitDefID)
  return newObject
end
function buildpic:DrawScreen()
  glColor(Colors.white)
  glTexture("#" .. self.unitDefID)
  glTexRect(self:GetX(), self:GetY()+1, self:GetR(), self:GetB()+1, false, true)
  glTexture(false)
end
function buildpic:SetUnitDefID(newUnitDefID)
  self.unitDefID = newUnitDefID
end
function buildpic:SetUnitID(newUnitID)
  self.unitDefID = spGetUnitDefID(newUnitID)
end

progress = {
  className = 'progress',
  progress = 0
}
progress = GenMeta(progress, component)
function progress:New(newProgress)
  local newObject = GenMeta({}, progress)
  newObject:Init()
  newObject:SetProgress(newProgress)

  newObject.colorListener = profileManager:RegisterColorListener({
    key = 'highlight',
    desc = 'Highlight Color',
    color =  {1,1,1,.5}
  }, newObject, function(newColor)
    newObject.color = newColor
  end)

  return newObject
end
function progress:DrawScreen()
  glColor(self.color)
  glShape(GL.TRIANGLE_FAN, self.list)
  glColor(1,1,1,1)
end
function progress:SetProgress(newProgress)
  -- taken from gui_buildbar.lua by jK (inverted)
  self.progress = math.min(math.max(newProgress, 0), 1)
  local left = self:GetX()
  local width = self:GetW()
  local right = left+width
  local top = self:GetY()+1
  local height = self:GetH()
  local bottom = top-height
  local progress = 1-self.progress
  local push = table.insert
  local tan = math.tan

  local xcen = (left+right)/2
  local ycen = (top+bottom)/2

  local alpha = 360*progress
  local alpha_rad = math.rad(alpha)
  local beta_rad  = math.pi/2 - alpha_rad
  self.list = {}
  push(self.list, {v = { xcen,  ycen }})
  push(self.list, {v = { xcen,  top }})

  local x,y
  x = (top-ycen)*tan(alpha_rad) + xcen
  if (alpha<90)and(x<right) then
    push(self.list, {v = { width-x+left*2,  top }})
  else
    push(self.list, {v = { left,  top }})
    y = (right-xcen)*tan(beta_rad) + ycen
    if (alpha<180)and(y>bottom) then
      push(self.list, {v = { left,  y }})
    else
      push(self.list, {v = { left,  bottom }})
      x = (top-ycen)*tan(-alpha_rad) + xcen
      if (alpha<270)and(x>left) then
        push(self.list, {v = { width-x+left*2,  bottom }})
      else
        push(self.list, {v = { right,  bottom }})
        y = (right-xcen)*tan(-beta_rad) + ycen
        if (alpha<350)and(y<top) then
          push(self.list, {v = { right,  y }})
        else
          push(self.list, {v = { right,  top }})
          x = (top-ycen)*tan(alpha_rad) + xcen
          push(self.list, {v = { width-x+left*2,  top }})
        end
      end
    end
  end
end
function progress:OnResize()
  self:SetProgress(self.progress)
end
function progress:OnParentChange()
  if self.colorListener then
    profileManager:CallColorListener(self.colorListener)
  end
end
function progress:OnDestroy()
  if self.colorListener then
    profileManager:UnregisterColorListener(self.colorListener)
    self.colorListener = nil
  end
end

minimap = {
  className = "minimap",
}
minimap = GenMeta(minimap, component)
function minimap:New(newTable)
  local newObject = GenMeta(newTable, minimap)
  newObject:Init()
  return newObject
end
function minimap:DrawScreen()
  glDrawMiniMap()
  glResetState()
  glResetMatrices()
end
function minimap:OnResize()
  local _, screenH = Spring.GetViewGeometry()
  local savedSize = { self:GetW(), self:GetH() }

  local newHeight = Game.mapY/Game.mapX*savedSize[1]
  local newWidth = Game.mapX/Game.mapY*savedSize[2]
  local newX = self:GetX()
  local newY = self:GetY()
  if (Game.mapX > Game.mapY and newHeight < savedSize[2]) or newWidth > savedSize[1] then
    newY = newY + (newHeight-savedSize[2])/2
    newWidth = savedSize[1]
  else
    newX = newX - (newWidth-savedSize[1])/2
    newHeight = savedSize[2]
  end

  spSendCommands({string.format("minimap geometry %i %i %i %i", newX, screenH-1-newY, newWidth, newHeight)})
end

bar = {
  className = "bar",
  value = 1
}
bar = GenMeta(bar, component)
function bar:New(newTable)
  local newObject = GenMeta(newTable, bar)
  newObject:Init()
  newObject.color = newObject.color or { 1.0, 1.0, 1.0, 1.0 }
  local newContent = border:New(
    frames:New("cols", {
      color:New(newObject.color),
      frames:New("rows", {
        gradient:New(
          { 0.54, 0.54, 0.54, 0.8 },
          { 0.54, 0.54, 0.54, 0.8 },
          { 0.78, 0.78, 0.78, 1.0 },
          { 0.78, 0.78, 0.78, 1.0 }
        ),
        gradient:New(
          { 0.78, 0.78, 0.78, 1.0 },
          { 0.78, 0.78, 0.78, 1.0 },
          { 0.75, 0.75, 0.75, 1.0 },
          { 0.75, 0.75, 0.75, 1.0 }
        )
      }, { 0.8, 0.2 })
    })
  )
  newContent:SetParent(newObject)
  newObject:SetValue(newObject.value)
  return newObject
end
function bar:SetValue(newValue)
  if newValue ~= newValue then
    -- NaN
    newValue = 0
  end
  self.value = math.min(math.max(newValue, 0), 1)
  local fullValue = self.value
  local emptyValue = 1 - self.value
  if fullValue  == 1 then fullValue  = nil end
  if emptyValue == 1 then emptyValue = nil end
  self[1][1]:SetSizes({fullValue, emptyValue})
end
function bar:SetColor(newColor)
  self[1][1][1].color = newColor
end

healthbar = {
  className = "healthbar",
  showNumbers = true
}
healthbar = GenMeta(healthbar, component)
function healthbar:New(newTable)
  local newObject = GenMeta(newTable, healthbar)
  newObject:Init()
  local newLayers = layers:New({
    bar:New({}),
    text:New({ align = "center" })
  })
  newLayers:SetParent(newObject)
  return newObject
end
function healthbar:SetValue(newCur, newMax)
  local caption = newCur .. " / " .. newMax
  if glGetTextWidth(caption) * (self:GetH()-4) > self:GetW() then
    caption = newCur
  end
  self[1][2]:SetText(caption)
  self[1][1]:SetValue(newCur/newMax)
  local rCol = math.min(math.max(2*(1-newCur/newMax),0),1)
  local gCol = math.min(math.max(2*(newCur/newMax),0),1)
  self[1][1]:SetColor({ rCol, gCol, 0, 1 })
end
