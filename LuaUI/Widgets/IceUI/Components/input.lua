--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    input.lua
--  brief:   components that take user input
--  author:  Jan Holthusen
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local spGetMouseState = Spring.GetMouseState

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

colorpicker = {
  className = "colorpicker",
  framesType = "cols",
  disabled = false
}
colorpicker = GenMeta(colorpicker, component)
function colorpicker:New(newTable)
  local newObject = GenMeta(newTable, colorpicker)
  newObject:Init()
  newObject.color = newObject.color or Colors.white
  local newContent = frames:New(newObject.framesType, {
    bar:New({}),
    bar:New({}),
    bar:New({}),
    bar:New({})
  })
  local colorStrings = { "redness", "greenness", "blueness", "transparency" }
  for i=1,4 do
    local i = i
    newContent[i]:AddCommand(command:New({
      desc = "adjust the " .. colorStrings[i] .. " of this color",
      drag = true,
      OnDrag = function(self, x, _, _, _)
        if not self.owner.parent.parent.disabled then
          self.owner:SetValue(x)
          self.owner.color[i] = x or 1
          self.owner.parent.parent.color[i] = x or 1
          if self.owner.parent.parent.OnChange then
            self.owner.parent.parent:OnChange(self.owner.parent.parent.color)
          end
        end
      end
    }))
  end
  newContent:SetParent(newObject)
  newObject:SetColor(newObject.color)
  return newObject
end
function colorpicker:SetColor(newColor)
  self.color = newColor
  for i=1,4 do
    self[1][i].color[1] = 0.0
    self[1][i].color[2] = 0.0
    self[1][i].color[3] = 0.0
    self[1][i].color[4] = 1.0
    self[1][i].color[i] = self.color[i]
    self[1][i]:SetValue(self.color[i])
  end
end
function colorpicker:SetState(disabled)
  if type(disabled) ~= 'boolean' then
    disabled = not self.disabled
  end
  self.disabled = disabled
end
function colorpicker:UpdateDefinition(newTable)
  for i,v in pairs(newTable) do
    if i == 'value' then i = 'color' end
    self[i] = v
  end

  self:SetColor(self.color)
  self:SetState(self.disabled)
end

button = {
  className = "button",
  caption = "Button",
  updateEvery = 3
}
button = GenMeta(button, component)
function button:New(newTable)
  local newObject = GenMeta(newTable, button)
  newObject:Init()

  local highlightColor = {
    key = 'highlight',
    desc = 'Highlight Color',
    color =  {1,1,1,.5}
  }

  local newContent = border:New(
    layers:New({
      color:New(highlightColor),
      margin:New(
        text:New({
          text = newObject.caption,
          align = "center"
        })
      )
    })
  )
  newContent[1][1]:SetVisibility(false)
  newContent:SetParent(newObject)
  newObject:AddCommand(command:New({
    desc = "press button '" .. newObject.caption .."'",
    OnRelease = function(self)
      if self.owner.OnPress then
        self.owner:OnPress()
      else
        windowManager:Notice("What's a button good for without an OnPress function?")
      end
    end
  }))

  return newObject
end
function button:Update()
  self[1][1][1]:SetVisibility(self:IsAbove(spGetMouseState()))
end

toggleButton = {
  className = "toggleButton",
  caption = "Button",
  active = false,
  updateEvery = 3
}
toggleButton = GenMeta(toggleButton, component)
function toggleButton:New(newTable)
  local newObject = GenMeta(newTable, toggleButton)
  newObject:Init()

  local highlightColor = {
    key = 'highlight',
    desc = 'Highlight Color',
    color =  {1,1,1,.5}
  }

  local newContent = border:New(
    layers:New({
      color:New(highlightColor),
      margin:New(
        text:New({
          text = newObject.caption,
          align = "center",
          trim = true
        })
      )
    })
  )
  newContent[1][1]:SetVisibility(false)
  newContent:SetParent(newObject)
  newObject:AddCommand(command:New({
    desc = "press toggleButton '" .. newObject.caption .."'",
    OnRelease = function(self)
      self.owner.active = not self.owner.active
      if self.owner.OnChange then
        self.owner:OnChange(self.owner.active)
      else
        windowManager:Notice("What's a toggleButton good for without an OnChange function?")
      end
    end
  }))

  return newObject
end
function toggleButton:Update()
  self[1][1][1]:SetVisibility(self:IsAbove(spGetMouseState()) or self.active)
end

radioButtons = {
  className = "radioButtons",
  captions = { "One", "Two" },
  activeButton = 1,
  disabled = false
}
radioButtons = GenMeta(radioButtons, component)
function radioButtons:New(newTable)
  local newObject = GenMeta(newTable, radioButtons)
  newObject:Init()
  local newButtons = {}
  for i=1,table.getn(newObject.captions) do
    local i = i
    newButtons[i] = margin:New(toggleButton:New({
      active = i == newObject.activeButton,
      caption = newObject.captions[i],
      OnChange = function(self, newActive)
        local button = self.parent.parent
        local radio = button.parent
        if not radio.disabled then
          if radio.activeButton == i then
            self.active = true
          else
            radio:ActivateButton(i)
          end
        else
          self.active = not self.active
        end
      end
    }))
  end
  local newContent = frames:New("cols", newButtons)
  newContent:SetParent(newObject)
  return newObject
end
function radioButtons:ActivateButton(index)
  local last = self.activeButton
  self.activeButton = index
  for i=1,#self.captions do
    self[1][i][1].active = false
  end
  self[1][self.activeButton][1].active = true
  if type(self.OnChange) == 'function' and last ~= self.activeButton then
    self:OnChange(index, self.captions[index])
  elseif type(self.OnChange) ~= 'function' then
    windowManager:Notice("What are radioButtons good for without an OnChange function?")
  end
end
function radioButtons:SetState(disabled)
  if type(disabled) ~= 'boolean' then
    disabled = not self.disabled
  end
  self.disabled = disabled
end
function radioButtons:UpdateDefinition(newTable)
  for i,v in pairs(newTable) do
    self[i] = v
  end

  self:ActivateButton(self.activeButton)
  self:SetState(self.disabled)
end

dropdown = {
  className = "dropdown",
  items = { "One", "Two" },
  value = 'One',
  disabled = false
}
dropdown = GenMeta(dropdown, component)
function dropdown:New(newTable)
  if newTable.items and not newTable.value then
    newTable.value = newTable.items[1]
  end
  local newObject = GenMeta(newTable, dropdown)
  newObject:Init()
  local newContent = border:New(frames:New("cols", {
    text:New{ text = newObject.value },
    texture:New{
      filename = "scrollbar.png",
      imgSize = 32,
      innerX = 0,
      innerY = 0,
      innerW = 16,
      innerH = 16,
      stretch = false
    }
  }, { -16, 16 }))
  newContent:AddCommand(command:New{
    desc = 'change this dropdown box',
    OnPress = function()
      if not newObject.disabled then
        local buttons = {}
        for _,v in ipairs(newObject.items) do
          local tooltip = v
          if type(v) == 'table' then
            tooltip = v.desc
          end
          table.insert(buttons, button:New{
            caption = type(v)=='table' and v.name or v,
            tooltip = tooltip,
            OnPress = function(self)
              newObject:SetValue(type(v)=='table' and v.key or v)
              self:GetWindow():Destroy()
            end
          })
        end
        local selection = window:New(
          'dropdown selection',
          frames:New('rows', buttons),
          {}, {}
        )
        selection:MoveTo(newObject:GetX(), -newObject:GetY()+newObject:GetH())
        selection:ResizeTo(newObject:GetW(), 20*#newObject.items)
        windowManager:ModalDialog(selection, function(callin, ...)
          if callin ~= 'MouseRelease' and callin ~= 'MouseMove' then
            selection:Destroy()
          end
          return callin ~= 'MouseRelease' and callin ~= 'MouseMove'
        end)
      end
    end
  })
  newContent:SetParent(newObject)
  newObject:SetText()
  return newObject
end
function dropdown:SetValue(newValue)
  if newValue ~= self.value then
    self.value = newValue
    self:SetText()
    if type(self.OnChange) == 'function' then
      self:OnChange(newValue)
    else
      windowManager:Notice("What is a dropdown good for without an OnChange function?")
    end
  end
end
function dropdown:SetText()
  if type(self.items[1]) == 'table' then
    for i,v in ipairs(self.items) do
      if v.key == self.value then
        self[1][1][1]:SetText(v.name)
      end
    end
  else
    self[1][1][1]:SetText(self.value)
  end
end
function dropdown:SetState(disabled)
  if type(disabled) ~= 'boolean' then
    disabled = not self.disabled
  end
  self.disabled = disabled
  self[1][1][1].color = disabled and {.5,.5,.5,1} or nil
end
function dropdown:UpdateDefinition(newTable)
  for i,v in pairs(newTable) do
    self[i] = v
  end
  self:SetValue(self.value)
  self:SetState(self.disabled)
end

checkbox = {
  className = "checkbox",
  caption = "Standard Checkbox",
  disabled = false,
  value = true
}
checkbox = GenMeta(checkbox, component)
function checkbox:New(newTable)
  local newObject = GenMeta(newTable, checkbox)
  newObject:Init()
  local newContent = frames:New("cols", {
    margin:New(
      border:New(
        margin:New(
          texture:New({
            filename = "checkbox.png",
            imgSize = 16,
            innerX = 0,
            innerY = 0,
            innerW = 12,
            innerH = 12
          })
        )
      )
    ),
    text:New({text = newObject.caption})
  }, {18, -18})
  newContent:SetParent(newObject)
  newObject:AddCommand(command:New({
    desc = "toggle '" .. newObject.caption .."'",
    OnRelease = function(self)
      if not self.owner.disabled then
        self.owner:SetValue()
      end
    end
  }))
  newObject:SetValue(newObject.value)
  newObject:SetState(newObject.disabled)
  return newObject
end
function checkbox:SetValue(newValue)
  local last = self.value
  if newValue == nil then newValue = not self.value end
  self.value = newValue
  self[1][1][1][1]:SetVisibility(self.value)
  if type(self.OnChange) == 'function' and last ~= self.value then
    self:OnChange(self.value)
  elseif type(self.OnChange) ~= 'function' then
    windowManager:Notice("What's a checkbox good for without an OnChange function?")
  end
end
function checkbox:SetState(disabled)
  if type(disabled) ~= 'boolean' then
    disabled = not self.disabled
  end
  self.disabled = disabled
  self[1][2].color = disabled and {.5,.5,.5,1} or nil
end
function checkbox:UpdateDefinition(newTable)
  for i,v in pairs(newTable) do
    self[i] = v
  end
  self:SetValue(self.value)
  self:SetState(self.disabled)
end

numberSlider = {
  className = 'numberSlider',
  caption = 'Standard slider',
  disabled = false,
  value = 1,
  max = 1,
  min = 0,
  step = 0.01
}
numberSlider = GenMeta(numberSlider, component)
function numberSlider:New(newTable)
  local newObject = GenMeta(newTable, numberSlider)
  newObject:Init()
  local newContent = frames:New(newObject.framesType, {
    text:New({ text=newObject.caption }),
    bar:New({}),
    number:New({ colored=false })
  }, {1/3, 1/2, 1/6})
  newContent[2]:AddCommand(command:New({
    desc = "adjust this slider",
    drag = true,
    OnDrag = function(self, x, _, _, _)
      local owner = self.owner.parent.parent
      if not owner.disabled then
        owner:SetValue(x*(owner.max-owner.min)+owner.min)
      end
    end
  }))
  newContent:SetParent(newObject)
  newObject.startValue = newObject.value
  newObject:SetValue(newObject.value)
  newObject:SetState(newObject.disabled)
  return newObject
end
function numberSlider:SetValue(newValue)
  local last = self.value
  if self.step > 0 then
    local old = self.startValue
    local min = math.ceil ((self.min-old)/self.step)*self.step+old
    local max = math.floor((self.max-old)/self.step)*self.step+old
    self.value = math.min(math.max(math.floor((newValue-old)/self.step+.5)*self.step+old, min), max)
  else
    self.value = newValue
  end

  self[1][2]:SetValue((self.value-self.min)/(self.max-self.min))
  self[1][3]:SetNumber(self.value)

  if type(self.OnChange) == 'function' and last ~= self.value then
    self:OnChange(self.value)
  end
end
function numberSlider:SetState(disabled)
  if type(disabled) ~= 'boolean' then
    disabled = not self.disabled
  end
  self.disabled = disabled
  self[1][1].color = disabled and {.5,.5,.5,1} or nil
  self[1][2]:SetColor(disabled and {.5,.5,.5,1} or {1,1,1,1})
  self[1][3].color = disabled and {.5,.5,.5,1} or nil
end
function numberSlider:UpdateDefinition(newTable)
  for i,v in pairs(newTable) do
    self[i] = v
  end
  self:SetValue(self.value)
  self:SetState(self.disabled)
end

textfield = {
  className = 'textfield'
}
textfield = GenMeta(textfield, component)
function textfield:New(newTable)
  local newObject = GenMeta(newTable, numberSlider)
  newObject:Init()
  newObject:AddCommand(command:New({
    desc = 'enter a new string',
    OnRelease = function(self)
    end
  }))
  return newObject
end
