settingsWindow = {}
local function SaveOptionsTableValue(section, path, name, option)
  local meta = getmetatable(option).__index
  local shallowCopy = {}
  for i,v in pairs(meta) do
    if type(v) ~= 'function' and v ~= getmetatable(meta).__index[i] or type(v) == 'table' then
      shallowCopy[i] = v
    end
  end
  if next(shallowCopy) then
    profileManager:SaveValue(section, path, name, shallowCopy)
  else
    profileManager:SaveValue(section, path, name, nil)
  end
end
function UnwrapOptionsTable(options)
  setmetatable(options, nil)
  for i,option in pairs(options) do
    options[i] = getmetatable(getmetatable(option).__index).__index
  end
  return options
end
local function WrapOptionsTable(options, loadSection, loadPath)
  options = setmetatable(options, {__newindex=function(_, index, value)
    UnwrapOptionsTable(options)
    options[index] = value
    WrapOptionsTable(options, loadSection, loadPath)
    settingsWindow:TweakEntered()
  end})
  if type(options) == 'table' then
    for i,option in pairs(options) do
      local originalValue = option.value
      local saved = profileManager:LoadValue(loadSection, loadPath, i) or {}
      if type(saved) ~= 'table' then
        -- backwards compatibility
        saved = { value = saved }
      end
      local data = setmetatable(saved, {__index=option})
      options[i] = setmetatable({}, {__index=data, __newindex=function(_, index, value)
        if data[index] ~= value or type(value) == 'table' then
          data[index] = value
          local temp = {}
          temp[index] = value
          if settingsWindow.visible and options[i].gui and options[i].gui.UpdateDefinition then
            options[i].gui:UpdateDefinition(temp)
          end
          SaveOptionsTableValue(loadSection, loadPath, i, options[i])
        end
      end})
    end
    for i,option in pairs(options) do
      if options[i].value ~= originalValue and type(option.OnChange) == 'function' then
        options[i]:OnChange()
      end
    end
  end
  return options
end

settingsWindow = window:New(
  "settings",
  frames:New('rows', {
    tabs:New({
      scrollable:New(free:New()),
      scrollable:New(free:New()),
      scrollable:New(free:New()),
      scrollable:New(free:New())
      --scrollable:New(free:New()),
      --scrollable:New(free:New())
    }, { 'Settings', 'Colors', 'Widget Settings', 'Profiles' }), --, 'Game Settings', 'Controls' }),
    margin:New(
      text:New({
        lines = 5,
        Update = function(self)
          self:SetText(Spring.GetCurrentTooltip())
        end
      }),
      10
    )
  }, { 0.75, 0.25 }),
  { 0.5, 0.5 }, { 0.25, 0.25 }
)
local settingsFrame = settingsWindow[1][1]

function settingsWindow:WrapOptions()
  for _,w in ipairs(widgetHandler.widgets) do
    if type(w.options) == 'table' then
      w.options = WrapOptionsTable(w.options, 'Widget Settings', {w.whInfo.name})
    end
  end

  for _,w in ipairs(windowManager.children) do
    if type(w.options) == 'table' then
      w.options = WrapOptionsTable(w.options, 'Window Settings', {w.name})
    end
  end

  widgetHandler.OriginalInsertWidget = widgetHandler.InsertWidget
  widgetHandler.InsertWidget = function(self, widget)
    if type(widget) == 'table' and type(widget.options) == 'table' then
      widget.options = WrapOptionsTable(widget.options, 'Widget Settings', {widget.name})
    end
    return self:OriginalInsertWidget(widget)
  end
end
function settingsWindow:Initialize()
  self:TweakExited()
end
function settingsWindow:Shutdown()
  widgetHandler.InsertWidget = widgetHandler.OriginalInsertWidget
  widgetHandler.OriginalInsertWidget = nil

  for _,w in ipairs(widgetHandler.widgets) do
    if type(w.options) == 'table' then
      w.options = UnwrapOptionsTable(w.options)
    end
  end
end
settingsWindow:PersistentCallin("TweakEntered")



function settingsWindow:CheckIceUI()
  self:ResetTab(1)
  for _,w in ipairs(windowManager.children) do
    local foundOption = false

    if type(w.legacyOptions) == 'table' and next(w.legacyOptions) ~= nil and w.visible then
      self:AddCaption(1, w.name)
      foundOption = true
      for i,v in pairs(w.legacyOptions) do
        if v.type == "bool" then
          self:AddSetting(1, {
            type = 'bool',
            name = v.description,
            desc = '',
            value = v:GetValue(),
            OnChange = function(self)
              v:SetValue(self.value)
            end
          })
        end
      end
    end

    if type(w.options) == 'table' and not table.empty(w.options) then
      if not foundOption then
        self:AddCaption(1, w.name)
      end
      for i,option in pairs(w.options) do
        local meta     = getmetatable(option).__index
        local metameta = getmetatable(meta  ).__index
        meta.OnChange = function(self)
          if type(metameta.OnChange) == 'function' then
            metameta.OnChange(option)
          end
          SaveOptionsTableValue('Window Settings', { w.name }, i, option)
        end
        metameta.gui = self:AddSetting(1, option)
      end
    end

  end
  settingsFrame[1]:UpdateScrollbar()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  colors


local colorListeners = {}
local colorGuiList = {}
local selectedWindow = 'global'
local loadingColorDefinition = false

local function GetInheritableColorKeys(key)
  local colorkeys = { 'teamcolor' }
  if selectedWindow ~= 'global' then
    table.insert(colorkeys, 'global')
  end
  for k,_ in pairs(profileManager:GetColors()) do
    if k ~= key then
      table.insert(colorkeys, k)
    end
  end
  return colorkeys
end
local function DisplayNewColorDefinition(gui, color)
  if not gui[2] then
    Spring.Echo('FAIL! Please tell MelTraX.')
    debugMode.Inspect(gui)
    return
  end
  loadingColorDefinition = true
  gui[2][2]:SetValue(color.inherit.type)
  gui[2][5]:SetValue(color.inherit.key)
  gui[4]:SetColor(color.color)
  loadingColorDefinition = false
end
local function OnWindowSelected(window)
  selectedWindow = window
  for key,gui in pairs(colorGuiList) do
    gui[2][5]:UpdateDefinition({ items = GetInheritableColorKeys(key) })
    DisplayNewColorDefinition(gui, profileManager:GetColorDefinition(key, window))
  end
end
local function SetColor(colorKeyToChange, color, inheritType, inheritFrom)
  if not loadingColorDefinition then
    local colorToChange = profileManager:GetColorDefinition(colorKeyToChange, selectedWindow)
    if type(color)       == 'table'  then colorToChange.color        = color       end
    if type(inheritType) == 'string' then colorToChange.inherit.type = inheritType end
    if type(inheritFrom) == 'string' then colorToChange.inherit.key  = inheritFrom end
    profileManager:UpdateColor(colorToChange, selectedWindow)
  end
end
local function UnregisterListeners()
  for _,v in ipairs(colorListeners) do
    profileManager:UnregisterColorListener(v)
  end
  colorListeners = {}
end

local function GetSingleColorSelector(color)
  local c = color.color

  local content = frames:New('rows', {
    margin:New(
      text:New(color.desc),
      { 10, 10, 10, 10 }
    ),
    frames:New('cols', {
      text:New('Inherit:'),
      dropdown:New{
        items={ 'none', 'color', 'alpha', 'both' },
        value=color.inherit.type,
        OnChange=function(_,v) SetColor(color.key, nil, v, nil) end
      },
      empty:New(),
      text:New('From:'),
      dropdown:New{
        items=GetInheritableColorKeys(color.key),
        value=color.inherit.key,
        OnChange=function(_,v) SetColor(color.key, nil, nil, v) end
      }
    }, { 0.1, 0.1, 0.03, 0.1, 0.3 }),
    empty:New(),
    colorpicker:New({ OnChange=function(_,v) SetColor(color.key, v, nil, nil) end })
  }, { 50, 18, 5, 15 })

  table.insert(
    colorListeners,
    profileManager:RegisterColorListener(color, windowManager:GetWindow(selectedWindow), function(newColor)
      DisplayNewColorDefinition(content, profileManager:GetColorDefinition(color.key, selectedWindow))
    end)
  )
  colorGuiList[color.key] = content

  return content
end
local function GetGradientColorSelector(caption, checkboxCaption)
  return margin:New(
    frames:New('rows', {
      text:New({ text=caption, align='center' }),
      checkbox:New({ caption=checkboxCaption, OnChange=function() end }),
      checkbox:New({ caption='Team color', OnChange=function() end }),
      colorpicker:New({ framesType='rows' })
    }, { 24, 18, 18, -60 }),
    4
  )
end

function settingsWindow:CheckColors()
  UnregisterListeners()
  self:ResetTab(2)
  self:AddSetting(2, {
    type = 'list',
    name = 'Window',
    value = selectedWindow,
    items = { 'global', unpack(windowManager:GetWindowList()) },
    OnChange = function(self)
      if self == nil or self.value == nil then
        Spring.Echo('THIS SHOULDN\'T HAPPEN! PLEASE TELL MELTRAX! (settings.lua self==nil)')
      else
        OnWindowSelected(self.value)
      end
    end
  })
  for _,color in pairs(profileManager:GetColors()) do
    local addHeight = 0
    local addContent = {}
    local content = settingsFrame[2][1]

    addContent = GetSingleColorSelector(color)
    addHeight = 83

    content:SetContent(addContent, #content.children+1)
    if content.currentY == nil then content.currentY = 0 end

    content[#content.children]:MoveTo(nil, content.currentY)
    content[#content.children]:ResizeTo(nil, addHeight)

    content.currentY = content.currentY + addHeight
  end
  settingsFrame[2]:UpdateScrollbar()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  widget settings


function settingsWindow:CheckWidgets()
  self:ResetTab(3)
  for _,w in ipairs(widgetHandler.widgets) do
    if type(w.options) == 'table' then
      self:AddCaption(3, w.whInfo.name)
      for i,option in pairs(w.options) do
        local meta     = getmetatable(option).__index
        local metameta = getmetatable(meta  ).__index
        meta.OnChange = function(self)
          if type(metameta.OnChange) == 'function' then
            metameta.OnChange(option)
          end
          SaveOptionsTableValue('Widget Settings', {w.whInfo.name}, i, option)
        end
        metameta.gui = self:AddSetting(3, meta)
      end
    end
  end
  settingsFrame[3]:UpdateScrollbar()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  profiles


function settingsWindow:Profiles()
  self:ResetTab(4)
  self:AddCaption(4, "Save Profile")
  local username = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  self:AddButton(4, {
    caption = "Save Profile",
    tooltip = "Saves the current profile to a file named User (" .. username .. ").lua.",
    OnPress = function()
      profileManager:WriteToFile('User (' .. username .. ')')
    end
  })
  self:AddCaption(4, "Load Profile")
  local profiles = {{
    key  = "Current",
    name = "Current",
    desc = "Current"
  }}
  for _,v in ipairs(profileManager:GetProfileList()) do
    table.insert(profiles, {
      key  = v,
      name = v,
      desc = v
    })
  end
  self:AddSetting(4, {
    name   = 'Profile',
    desc   = 'Selecting a profile here will immediately load it.',
    type   = 'list',
    items  = profiles,
    value  = 'Current',
    OnChange = function(self)
      profileManager:ReadFromFile(self.value)
      widgetHandler:ToggleWidget("IceUI")
      widgetHandler:ToggleWidget("IceUI")
    end
  })
  settingsFrame[4]:UpdateScrollbar()
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  game settings


local function GameSetting(settingType, cmd, configName, setting)
  if configName ~= nil then
    setting.value = Spring.GetConfigInt(configName)
    if settingType == 'bool' then
      setting.value = Spring.GetConfigInt(configName) == 1
    end
  end
  setting.OnChange = function(self)
    local intValue = self.value
    if settingType == 'bool' then
      intValue = self.value and 1 or 0
    end
    Spring.SendCommands{ cmd .. " " .. intValue }
    Spring.SetConfigInt(configName, intValue)
  end
  setting.type = settingType
  return setting
end

function settingsWindow:GameSettings()
  self:ResetTab(4)

  self:AddCaption(4, "Video")
  self:AddSetting(4, GameSetting('bool', 'advshading', 'AdvUnitShading', {
    name     = 'Reflective units',
    desc     = 'Units use a better shader to make them reflective\n(needs restart if it was off at game start).'
  }))
  self:AddSetting(4, GameSetting('bool', 'shadows', 'Shadows', {
    name     = 'Shadows',
    desc     = 'Units and features cast shadows (this can be very slow). Requires "Reflective units" for units.'
  }))

  settingsFrame[4]:UpdateScrollbar()
end



function settingsWindow:TweakEntered()
  self:CheckIceUI()
  self:CheckColors()
  self:CheckWidgets()
  self:Profiles()
  --self:GameSettings()
  settingsFrame[2]:UpdateScrollbar()
  self:MoveTo(0.25, 0.25)
  self:ResizeTo(0.5, 0.5)
  self:SetVisibility(true)
  windowManager:LowerWindow(self)
  debugMode.Inspect(profileManager)
end
function settingsWindow:TweakExited()
  self:SetVisibility(false)
  UnregisterListeners()
end



function settingsWindow:ResetTab(tab)
  local content = settingsFrame[tab][1]

  content.currentY = 0
  for i=#content.children,1,-1 do
    content.children[i]:Destroy()
  end
end
function settingsWindow:AddSetting(tab, option)
  local addHeight = 0
  local addContent = {}
  local content = settingsFrame[tab][1]



  if option.type == 'bool' then
    addContent = checkbox:New({
      value = option.value,
      caption = option.name,
      disabled = option.disabled,
      OnChange = function(self, newValue)
        option.value = newValue
        if option.OnChange ~= nil then
          option:OnChange()
        end
      end,
      tooltip = option.desc
    })
    addHeight = 18
  end



  if option.type == 'number' then
    addContent = numberSlider:New({
      value = option.value,
      max = option.max,
      min = option.min,
      step = option.step,
      caption = option.name,
      disabled = option.disabled,
      OnChange = function(self, newValue)
        option.value = newValue
        if option.OnChange ~= nil then
          option:OnChange()
        end
      end,
      tooltip = option.desc
    })
    addHeight = 18
  end



  if option.type == 'list' and #option.items < 4 then
    local GenerateButtons = function()
      local captions = {}
      for _,item in ipairs(option.items) do
        table.insert(captions, type(item) == 'table' and item.name or item)
      end
      local active = 1
      local keys = {}
      for i,item in ipairs(option.items) do
        local key = type(item) == 'table' and item.key or item
        if key == option.value then
          active = i
        end
        table.insert(keys, key)
      end
      local buttons = radioButtons:New({
        captions = captions,
        activeButton = active,
        disabled = option.disabled,
        OnChange = function(self, newValue)
          option.value = keys[newValue]
          if option.OnChange ~= nil then
            option:OnChange()
          end
        end
      })
      for i,item in ipairs(option.items) do
        buttons[1][i].tooltip = item.desc
      end
      return buttons
    end
    addContent = frames:New('cols', {
      text:New({ text=option.name, color = option.disabled and {.5,.5,.5,1} or nil }),
      GenerateButtons()
    }, { 1/3, 2/3 })
    function addContent:UpdateDefinition(newTable)
      if newTable.forceUpdate then
        option.items = option.items
        self:SetContent(GenerateButtons(), 2)
        option.forceUpdate = nil
      else
        if newTable.value then
          for i,item in ipairs(option.items) do
            if item.key == newTable.value or item == newTable.value then
              newTable.activeButton = i
            end
          end
          newTable.value = nil
        end
        self[2]:UpdateDefinition(newTable)
        self[1].color = self[2].disabled and {.5,.5,.5,1} or nil
      end
    end
    addContent.tooltip = option.desc
    addHeight = 18
  end



  if option.type == 'list' and #option.items >= 4 then
    addContent = frames:New('cols', {
      text:New{ text=option.name, color = option.disabled and {.5,.5,.5,1} or nil },
      dropdown:New{
        items = option.items,
        value = option.value,
        disabled = option.disabled,
        OnChange = function(self, newValue)
          option.value = newValue
          if option.OnChange ~= nil then
            option:OnChange()
          end
        end
      }
    }, { 1/3, 2/3 })
    addContent.tooltip = option.desc
    addHeight = 18
  end



  if option.type == 'string' then
    addContent = frames:New('cols', {
      text:New({ text=option.name, color = option.disabled and {.5,.5,.5,1} or nil }),
      text:New({
        text = option.value,
        color = option.disabled and {.5,.5,.5,1} or nil
      })
    }, { 1/3, 2/3 })
    addContent[2]:AddCommand(command:New{
      desc = 'change this string',
      OnPress = function(self)
        if not option.disabled then
          windowManager:GetUserInput(option.maxlen, function(text)
            if not text then return end
            option.value = text
            self.owner:SetText(text)
            if option.OnChange ~= nil then
              option:OnChange()
            end
          end)
        end
      end
    })
    function addContent:UpdateDefinition(newTable)
      if newTable.value then self[2]:SetText(newTable.value) end
      if newTable.name  then self[1]:SetText(newTable.name ) end
      if newTable.desc  then self.tooltip =  newTable.desc   end
      self[1].color = option.disabled and {.5,.5,.5,1} or nil
      self[2].color = option.disabled and {.5,.5,.5,1} or nil
    end
    addContent.tooltip = option.desc
    addHeight = 18
  end



  if option.type == 'color' then
    addContent = frames:New('cols', {
      text:New({ text=option.name, color = option.disabled and {.5,.5,.5,1} or nil }),
      colorpicker:New({
        color = option.value,
        disabled = option.disabled,
        OnChange = function(self, newValue)
          option.value = newValue
          if option.OnChange ~= nil then
            option:OnChange()
          end
        end
      })
    }, { 1/3, 2/3 })
    function addContent:UpdateDefinition(newTable)
      self[2]:UpdateDefinition(newTable)
      self[1].color = self[2].disabled and {.5,.5,.5,1} or nil
    end
    addContent.tooltip = option.desc
    addHeight = 18
  end



  if addHeight > 0 then
    content:SetContent(addContent, #content.children+1)
    if content.currentY == nil then content.currentY = 0 end

    content[#content.children]:MoveTo(nil, content.currentY)
    content[#content.children]:ResizeTo(nil, addHeight)

    content.currentY = content.currentY + addHeight
  end
  return addContent
end
function settingsWindow:AddCaption(tab, caption)
  local content = settingsFrame[tab][1]

  content:SetContent(margin:New(
    text:New({ text = caption }),
    { 10, 10, 10, 10 }
  ),#content.children+1)

  if content.currentY == nil then content.currentY = 0 end

  content[#content.children]:MoveTo(nil, content.currentY)
  content[#content.children]:ResizeTo(nil, 50)

  content.currentY = content.currentY + 50
end
function settingsWindow:AddButton(tab, options)
  local content = settingsFrame[tab][1]

  content:SetContent(margin:New(
    button:New(options),
    { 10, 10, 10, 10 }
  ),#content.children+1)

  if content.currentY == nil then content.currentY = 0 end

  content[#content.children]:MoveTo(nil, content.currentY)
  content[#content.children]:ResizeTo(nil, 50)

  content.currentY = content.currentY + 50
end



function settingsWindow:GetElement(name, cmd, configName)
  local state
  if configName ~= nil then
    state = Spring.GetConfigInt(configName)
  else
    state = profileManager:LoadValue("DefaultGUI", name) or 0
  end
  state = (state - 1) * -1
  local returnValue = text:New({ text=name })
  local function Update()
    state = (state - 1) * -1
    Spring.SendCommands({ cmd .. " " .. state })
    local color = RedStr
    if state == 1 then
      color = GreenStr
    end
    returnValue:SetText(color .. name)
    if configName ~= nil then
      Spring.SetConfigInt(configName, state)
    else
      profileManager:SaveValue("DefaultGUI", name, state)
    end
  end
  returnValue:AddCommand(command:New({
    desc = "toggle default "..name,
    OnRelease = Update
  }))
  Update()
  return returnValue
end
