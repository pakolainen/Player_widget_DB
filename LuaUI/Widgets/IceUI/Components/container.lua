--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    container.lua
--  brief:   components that can contain other components
--  author:  Jan Holthusen
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local GL_FILL           = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_LINE           = GL.LINE
local glColor           = gl.Color
local glPolygonMode     = gl.PolygonMode
local glRect            = gl.Rect
local spEcho            = Spring.Echo
local spGetMouseState   = Spring.GetMouseState
local glCreateList      = gl.CreateList
local glCallList        = gl.CallList
local glDeleteList      = gl.DeleteList

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

window = {
  className = "window",
  isClickthrough = false
}
window = GenMeta(window, component)
function window:New(newName, newContent, resizeTo, moveTo)
  local newObject = GenMeta({}, window)
  newObject:Init()
  newObject.legacyOptions = {}
  newObject.options = {}
  newObject.name = newName
  local overLayColor1 = { 1, 1, 1, 0.5 }
  local overLayColor2 = { 1, 1, 1, 0.7 }
  local tweakSizes = { 8, -16, 8 }
  local newBorder = border:New(
    layers:New({
      color:New(),
      newContent,
      frames:New("cols",{
        frames:New("rows",{
          color:New(overLayColor1),
          color:New(overLayColor2),
          color:New(overLayColor1)
        }, tweakSizes),
        frames:New("rows",{
          color:New(overLayColor2),
          color:New(overLayColor1),
          color:New(overLayColor2)
        }, tweakSizes),
        frames:New("rows",{
          color:New(overLayColor1),
          color:New(overLayColor2),
          color:New(overLayColor1)
        }, tweakSizes)
      }, tweakSizes)
    })
  )
  newBorder[1][3]:AddCommand(command:New({
    button = 2,
    desc = "raise this window",
    OnRelease = function(self)
      windowManager:RaiseWindow(self.owner:GetWindow())
    end
  }))
  newBorder[1][3]:AddCommand(command:New({
    button = 3,
    desc = "lower this window",
    OnRelease = function(self)
      windowManager:LowerWindow(self.owner:GetWindow())
    end
  }))
  local names = {{"NW","W","SW"},{"N","","S"},{"NE","E","SE"}}
  local resiX = {{  -1, -1,  -1},{  0, 0,  0},{   1,  1,   1}}
  local resiY = {{   1,  0,  -1},{  1, 0, -1},{   1,  0,  -1}}
  local moveX = {{   1,  1,   1},{  0, 1,  0},{   0,  0,   0}}
  local moveY = {{  -1,  0,   0},{ -1,-1,  0},{  -1,  0,   0}}
  for i=1,3 do
    for j=1,3 do
      local resiX = resiX[i][j]
      local resiY = resiY[i][j]
      local moveX = moveX[i][j]
      local moveY = moveY[i][j]
      newBorder[1][3][i][j]:AddCommand(command:New({
        drag=true,
        desc="resize this window ("..names[i][j]..")",
        OnDrag=function(self, x, y, dx, dy)
          local window = self.owner:GetWindow()
          local screenW, screenH = Spring.GetViewGeometry()

          local newW = (              window:GetW() + resiX * dx) / screenW
          local newH = (              window:GetH() + resiY * dy) / screenH
          local newX = (              window:GetX() + moveX * dx) / screenW
          local newY = (screenH - 1 - window:GetY() + moveY * dy) / screenH

          newW = math.min(math.max(newW, 20/screenW), 1)
          newH = math.min(math.max(newH, 20/screenH), 1)
          window:ResizeTo(newW, newH)

          newX = math.min(math.max(newX, 0), 1-newW)
          newY = math.min(math.max(newY, 0), 1-newH)
          window:MoveTo(newX, newY)
        end
      }))
    end
  end
  newBorder[1][3][2][2].commands[1]["0000"].desc = "move this window"
  newBorder[1][3]:SetVisibility(false)
  newBorder:SetParent(newObject)
  local metaT = getmetatable(newObject.children)
  setmetatable(newObject.children, nil)
  metaT.__newindex = getmetatable(newObject).__newindex
  setmetatable(newObject, metaT)
  newObject[1] = newBorder.children[1][2]

  local newResizeTo = profileManager:LoadValue('Window Positions', { newObject.name }, "size") or resizeTo
  local newMoveTo = profileManager:LoadValue('Window Positions', { newObject.name }, "position") or moveTo

  if newResizeTo ~= nil then newObject:ResizeTo(newResizeTo[1], newResizeTo[2]) end
  if newMoveTo   ~= nil then newObject:MoveTo(newMoveTo[1], newMoveTo[2]) end
  return newObject
end
function window:SetContent(newContent)
  self.children[1][1]:SetContent(newContent,2)
  self[1] = newContent
end
function window:TweakEntered()
  self.children[1][1][3]:SetVisibility(true)
end
function window:TweakExited()
  self.children[1][1][3]:SetVisibility(false)
end
function window:AddOption(newOption)
  newOption.owner = self
  self.legacyOptions[newOption.name] = newOption
end
function window:Option(optionName)
  return self.legacyOptions[optionName]:GetValue()
end
function window:ResizeTo(width, height)
  local size = profileManager:LoadValue('Window Positions', { self.name }, "size") or { width, height }
  if type(width) ~= "boolean" then
    size[1] = width
  end
  if type(height) ~= "boolean" then
    size[2] = height
  end
  if type(self.resizesItself) == 'table' then
    local moveBy = { 0, 0 }
    if self.options.resizeDirectionW ~= nil and self.options.resizeDirectionW.value ~= "right" then
      moveBy[1] = width and self:GetW()-width or 0
      if self.options.resizeDirectionW.value == "both" then
        moveBy[1] = moveBy[1]/2
      end
    end
    if self.options.resizeDirectionH ~= nil and self.options.resizeDirectionH.value ~= "bottom" then
      moveBy[2] = height and self:GetH()-height or 0
      if self.options.resizeDirectionH.value == "both" then
        moveBy[2] = moveBy[2]/2
      end
    end
    self:MoveBy(moveBy[1], moveBy[2])
  end
  component.ResizeTo(self, width, height)
  local toSave = { self.dimensions.relative.width, self.dimensions.relative.height }
  profileManager:SaveValue('Window Positions', { self.name }, "size", toSave)
end
function window:MoveTo(newX, newY)
  component.MoveTo(self, newX, newY)
  local toSave = { self.dimensions.relative.x, self.dimensions.relative.y }
  profileManager:SaveValue('Window Positions', { self.name }, "position", toSave )
end
function window:SetClickthrough(isClickthrough)
  self.isClickthrough = isClickthrough
end
function window:ResizesItself(width, height)
  if self.resizesItself ~= nil and width == self.resizesItself[1] and height == self.resizesItself[2] then
    return
  end
  self.resizesItself = { width, height }
  if not type(self.options) == "table" then
    self.options = {}
  end
  if not height then
    self.options.resizeDirectionH = nil
  end
  if width then
    self.options.resizeDirectionW = {
      name  = "Resize to direction (width)",
      desc  = "This window changes its size depending on its contents. To which side should it resize?",
      type  = "list",
      items = { "left", "both", "right" },
      value = "right"
    }
  else
    self.options.resizeDirectionW = nil
  end
  if height then
    self.options.resizeDirectionH = {
      name  = "Resize to direction (height)",
      desc  = "This window changes its size depending on its contents. To which side should it resize?",
      type  = "list",
      items = { "top", "both", "bottom" },
      value = "bottom"
    }
  end
  return
end

free = {
  className = "free",
  maxChildren = 1000
}
free = GenMeta(free, component)
function free:New(...)
  local arg = {...}
  if #arg % 3 ~= 0 then
    spEcho("free:New needs three parameters for each child (the child, position, size)")
  end
  local newObject = GenMeta({}, free)
  newObject:Init()
  for i=1,#arg/3 do
    local j = (i-1)*3 + 1
    newObject:SetContent(arg[j], i)
    arg[j]:MoveTo(unpack(arg[j+1]))
    arg[j]:ResizeTo(unpack(arg[j+2]))
  end
  return newObject
end

layers = {
  className = "layers",
  maxChildren = 2
}
layers = GenMeta(layers, component)
function layers:New(newContent)
  local newObject = GenMeta({}, layers)
  newObject:Init()
  if newContent then
    newObject.maxChildren = #newContent
    for i,v in ipairs(newContent) do
      newObject:SetContent(v, i)
    end
  end
  return newObject
end

tabs = {
  className = "tabs",
  activeTab = 1
}
tabs = GenMeta(tabs, component)
function tabs:New(newContent, newCaptions)
  local newObject = GenMeta({}, tabs)
  newObject:Init()
  if newCaptions then newObject.captions = newCaptions end
  local frameContent = frames:New("rows", {
    layers:New({
      empty:New(),
      text:New({
        align = "center",
        text = newCaptions[1]
      })
    }),
    layers:New(newContent)
  }, { 20, -20 })
  frameContent:SetParent(newObject)
  newObject:SetCaptions()
  
  frameContent.updateEvery = 3
  frameContent[1].Update = function(self)
    self[1]:SetVisibility(self:IsAbove(spGetMouseState()))
    self[2]:SetVisibility(not self:IsAbove(spGetMouseState()))
  end
  for i,v in ipairs(frameContent[2].children) do
    v:SetVisibility(i == newObject.activeTab)
  end
  local metaT = getmetatable(newObject.children)
  setmetatable(newObject.children, nil)
  metaT.__newindex = getmetatable(newObject).__newindex
  setmetatable(newObject, metaT)
  for i,v in ipairs(newContent) do
    newObject[i] = v
  end

  frameContent[1]:Update()
  return newObject
end
function tabs:SetContent(newContent, index)
  self.children[1][2]:SetContent(newContent, index)
end
function tabs:SetCaptions()
  local thisTabs = self
  self.children[1][1]:SetContent(radioButtons:New({
    captions = thisTabs.captions,
    activeButton = self.activeTab,
    OnChange = function(_, newIndex)
      thisTabs:ActivateTab(newIndex)
    end
  }))
  if table.getn(self.captions) > 1 then
    for i=1,table.getn(self.captions) do
      local i=i
      self.children[1][1][1][1][i][1]:AddCommand(command:New({
        button = 2,
        desc = "open this tab in a new window",
        OnPress = function(self)
          local thisCaption, thisContent, thisDimensions = thisTabs:UndockContent(i)
          local _, screenH = Spring.GetViewGeometry()
          local newX    = thisTabs:GetWindow():GetX()+thisTabs:GetWindow():GetW()-thisTabs:GetW()
          local undockedWindow = window:New(
            "undockedTab_"..thisCaption,
            frames:New("rows", {
              text:New({
                align = "center",
                text = thisCaption
              }),
              thisContent
            }, { 20, -20 }),
            thisDimensions, { newX, screenH-thisTabs:GetWindow():GetY()-1 }
          )
          undockedWindow:MoveTo(newX, screenH-thisTabs:GetWindow():GetY()-1)
          undockedWindow:ResizeTo(unpack(thisDimensions))
          thisTabs:GetWindow():MoveBy(-thisTabs:GetW()-1,0)
          undockedWindow[1][1]:AddCommand(command:New({
            button = 2,
            desc = "reattach this window to the tabs",
            OnPress = function(self)
              thisTabs:RedockContent(thisCaption, thisContent)
              thisContent:ResizeTo()
              thisContent:MoveTo()
              thisContent:SetVisibility(false)
              undockedWindow:Destroy()
              thisTabs:GetWindow():MoveBy(thisTabs:GetW()+1,0)
            end
          }))
          thisContent:SetVisibility(true)
        end
      }))
    end
  end
end
function tabs:ActivateTab(id)
  self.children[1][2][self.activeTab]:SetVisibility(false)
  self.children[1][2][id]:SetVisibility(true)
  self.children[1][1][2]:SetText(self.captions[id])
  self.activeTab = id
  if self.children[1][2][id].Update then
    self.children[1][2][id]:Update()
  end
end
function tabs:UndockContent(id)
  self:ActivateTab(1)

  local content = self.children[1][2][id]
  local returnValues = { self.captions[id], content, { content:GetW(), content:GetH() + 22 } }
  content:SetParent(windowManager)
  for i=id, table.getn(self.captions) do
    self.captions[i] = self.captions[i+1]
  end
  self:SetCaptions()
  self:ActivateTab(self.activeTab)
  return unpack(returnValues)
end
function tabs:RedockContent(caption, content)
  self.captions[table.getn(self.captions)+1] = caption
  content:SetParent(self.children[1][2], table.getn(self.captions))
  self:SetCaptions()
end

frames = {
  className = "frames",
  framesType = "cols",
  maxChildren = 2
}
frames = GenMeta(frames, component)
function frames:New(newType, newContent, newSizes)
  local newObject = GenMeta({}, frames)
  newObject:Init()
  if newContent then
    newObject.maxChildren = table.getn(newContent)
  end
  newObject.framesType = newType
  newObject.sizes = newSizes
  if newObject.sizes == nil then
    newObject.sizes = {}
    if newObject.maxChildren > 1 then
      for i=1,newObject.maxChildren do
        newObject.sizes[i] = 1/newObject.maxChildren
      end
    end
  end
  if newContent then
    for i,v in ipairs(newContent) do
      newObject:SetContent(v, i)
    end
  end
  return newObject
end
function frames:SetContent(newContent, frame)
  component.SetContent(self, newContent, frame)
  if newContent ~= nil then
    self:ResizeFrame(frame)
    self.dimensions:CalculateAbsolute()
  end
end
function frames:ResizeFrame(frame)
  if self.framesType == "cols" then
    self[frame]:MoveTo(self:GetFramePos(frame),0)
    self[frame]:ResizeTo(self.sizes[frame],nil)
  else
    self[frame]:MoveTo(0,self:GetFramePos(frame))
    self[frame]:ResizeTo(nil,self.sizes[frame])
  end
end
function frames:GetFramePos(frame)
  if frame == 1 then
    return 0
  else
    local lastSize = self.sizes[frame-1] or 1
    return self:GetFramePos(frame-1) + lastSize
  end
end
function frames:SetSizes(newSizes)
  self.sizes = newSizes
  for i=1,self.maxChildren do
    self:ResizeFrame(i)
  end
end

margin = {
  className = "margin",
  maxChildren = 1
}
margin = GenMeta(margin, component)
function margin:New(newContent, newWidths)
  local newObject = GenMeta({}, margin)
  newObject:Init()
  if type(newWidths) == 'nil' then
    newObject.widths = {1,1,1,1}
  elseif type(newWidths) == 'table' then
    newObject.widths = newWidths
  elseif type(newWidths) == 'number' then
    newObject.widths = {newWidths,newWidths,newWidths,newWidths}
  end
  if newContent then newObject:SetContent(newContent) end
  return newObject
end
function margin:SetContent(newContent)
  component.SetContent(self, newContent)
  newContent:MoveTo(self.widths[1],self.widths[2])
  local newWidth  = -self.widths[1]-self.widths[3]
  if newWidth == 0 then newWidth = nil end
  local newHeight = -self.widths[2]-self.widths[4]
  if newHeight == 0 then newHeight = nil end
  newContent:ResizeTo(newWidth,newHeight)
end

border = {
  className = "border",
  color = { 0.22, 0.22, 0.22, 0.8 },
  maxChildren = 1,
  displayList = nil
}
border = GenMeta(border, component)
function border:New(newContent, newColor)
  local newObject = GenMeta({}, border)
  newObject:Init()
  if newContent then newObject:SetContent(newContent) end
  if newColor   then
    newObject:SetColor(newColor)
  else
    newObject.colorListener = profileManager:RegisterColorListener({
      key = 'border',
      desc = 'Border Color',
      color =  { 0.22, 0.22, 0.22, 0.8 }
    }, newObject, function(newColor)
      newObject:SetColor(newColor)
    end)
  end
  return newObject
end
function border:DrawScreen()
  gl.Color(self.color)
  gl.Shape(GL.LINE_LOOP, {
    { v = { self:GetR() - 0.5, self:GetB() + 1.5 }},
    { v = { self:GetX() + 0.5, self:GetB() + 1.5 }},
    { v = { self:GetX() + 0.5, self:GetY() + 0.5 }},
    { v = { self:GetR() - 0.5, self:GetY() + 0.5 }}
  })
end
function border:DrawScreenWithDisplayList()
  glCallList(self.displayList)
end
function border:SetContent(newContent)
  component.SetContent(self, newContent)
  newContent:MoveTo(1,1)
  newContent:ResizeTo(-2,-2)
end
function border:SetColor(newColor)
  self.color = newColor
  --self:OnResize() -- display lists
end
function border:OnResizeWithDisplayList()
  if self.displayList then glDeleteList(self.displayList) end
  self.displayList = glCreateList(function()
    gl.Color(self.color)
    gl.Shape(GL.LINE_LOOP, {
      { v = { self:GetR() - 0.5, self:GetB() + 1.5 }},
      { v = { self:GetX() + 0.5, self:GetB() + 1.5 }},
      { v = { self:GetX() + 0.5, self:GetY() + 0.5 }},
      { v = { self:GetR() - 0.5, self:GetY() + 0.5 }}
    })
  end)
end
function border:OnParentChange()
  if self.colorListener then
    profileManager:CallColorListener(self.colorListener)
  end
end
function border:OnDestroy()
  if self.colorListener then
    profileManager:UnregisterColorListener(self.colorListener)
    self.colorListener = nil
  end
end

scrollable = {
  className = 'scrollable',
  maxChildren = 1,
  offset = 0
}
scrollable = GenMeta(scrollable, component)
function scrollable:New(newContent)
  local newObject = GenMeta({}, scrollable)
  newObject:Init()

  local frameContent = frames:New("cols", {
    newContent,
    frames:New('rows', {
      texture:New{
        filename = "scrollbar.png",
        imgSize = 32,
        innerX = 0,
        innerY = 16,
        innerW = 16,
        innerH = 16,
        stretch = false
      },
      color:New({1,1,1,.5}),
      texture:New{
        filename = "scrollbar.png",
        imgSize = 32,
        innerX = 0,
        innerY = 0,
        innerW = 16,
        innerH = 16,
        stretch = false
      }
    }, { 16, -32, 16 })
  }, { -20, 20 })
  newObject.colorListener = profileManager:RegisterColorListener({
    key = 'highlight',
    desc = 'Highlight Color',
    color =  {1,1,1,.5}
  }, frameContent[2][2], function(newColor)
    frameContent[2][2]:SetColor(newColor)
  end)
  frameContent:SetParent(newObject)

  frameContent[2]:AddCommand(command:New({
    desc = 'scroll a page',
    OnPress = function(self, _,y)
      local owner = self.owner.parent.parent
      local oHeight = owner:GetH()
      local iHeight = owner:GetY()-owner:GetMinBottom()+owner.offset
      local oTop    = owner:GetY()
      local iTop    = owner:GetY()+owner.offset

      if y<(iTop-oTop)/(iHeight-oHeight)*(1-oHeight/iHeight) then
        owner:ScrollBy(-oHeight)
      else
        owner:ScrollBy(oHeight)
      end
    end
  }))
  frameContent[2][1]:AddCommand(command:New({
    desc = 'scroll up',
    OnPress = function(self, _,y)
      self.owner.parent.parent.parent:ScrollBy(-40)
    end
  }))
  frameContent[2][2]:AddCommand(command:New({
    drag = true,
    desc = 'scroll',
    OnDrag = function(self, _, _, _, dy)
      local owner = self.owner.parent.parent.parent
      local oHeight = owner:GetH()
      local iHeight = owner:GetY()-owner:GetMinBottom()+owner.offset
      local sHeight = oHeight - 34

      owner:ScrollBy(-dy/sHeight*iHeight)
    end
  }))
  frameContent[2][3]:AddCommand(command:New({
    desc = 'scroll down',
    OnPress = function(self, _,y)
      self.owner.parent.parent.parent:ScrollBy(40)
    end
  }))
  local metaT = getmetatable(newObject.children)
  setmetatable(newObject.children, nil)
  metaT.__newindex = getmetatable(newObject).__newindex
  setmetatable(newObject, metaT)
  newObject[1] = frameContent.children[1]

  newObject:UpdateScrollbar()
  return newObject
end
function scrollable:Draw()
  gl.Scissor(self:GetX(),self:GetB()+1,self:GetW(),self:GetH())
  component.Draw(self)
  gl.ResetState()
  gl.ResetMatrices()
end
function scrollable:MouseWheel(up, value)
  local x, y = Spring.GetMouseState()
  if self:IsAbove(x, y) then
    self:ScrollBy(40 * (up and -1 or 1))
    return true
  end
end
function scrollable:ScrollBy(dy)
  if self:NeedsScrollbar() then
    self.offset = math.min(
      math.max(self.offset + dy, 0),
      self:GetB()-self:GetMinBottom()+self.offset
    )

    local self = self
    self.children[1][1]:MoveTo(nil, function(parentDimensions)
      return parentDimensions.absolute.y + self.offset
    end)
    self[1]:ResizeTo(-20, self:GetY()-self:GetMinBottom()+self.offset)
    self:UpdateScrollbar()
  end
end
function scrollable:GetMinBottom(parent)
  local minBottom = 100000
  if parent == nil then parent = self end

  for _,child in ipairs(parent.children) do
    local new = child:GetB()
    if minBottom > new then
      minBottom = new
    end
    new = self:GetMinBottom(child)
    if minBottom > new then
      minBottom = new
    end
  end

  return minBottom
end
function scrollable:NeedsScrollbar()
  return self:GetH() > self:GetMinBottom()-self.offset
end
function scrollable:SetContent(newContent)
  self.children[1]:SetContent(newContent, 1)
  self[1] = newContent
end
function scrollable:UpdateScrollbar()
  if self:NeedsScrollbar() then
    local oHeight = self:GetH()
    local sHeight = oHeight - 34
    local iHeight = self:GetY()-self:GetMinBottom()+self.offset

    self.children[1][2][1]:SetVisibility(true)
    self.children[1][2][2]:SetVisibility(true)
    self.children[1][2][3]:SetVisibility(true)
    self.children[1][2][2]:ResizeTo(nil, oHeight/iHeight*sHeight)
    self.children[1][2][2]:MoveTo(nil, 17 + self.offset/iHeight*sHeight)
  else
    self.children[1][2][1]:SetVisibility(false)
    self.children[1][2][2]:SetVisibility(false)
    self.children[1][2][3]:SetVisibility(false)
  end
end
function scrollable:OnResize()
  self:UpdateScrollbar()
end
function scrollable:OnParentChange()
  self:UpdateScrollbar()
  if self.colorListener then
    profileManager:CallColorListener(self.colorListener)
  end
end
function scrollable:OnDestroy()
  if self.colorListener then
    profileManager:UnregisterColorListener(self.colorListener)
    self.colorListener = nil
  end
end
