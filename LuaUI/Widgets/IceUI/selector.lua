local groupDescs = {
  api     = "For Developers",
  camera  = "Camera",
  cmd     = "Commands",
  dbg     = "For Developers",
  gfx     = "Effects",
  gui     = "GUI",
  hook    = "Commands",
  ico     = "GUI",
  init    = "Initialization",
  minimap = "Minimap",
  snd     = "Sound",
  test    = "For Developers",
  unit    = "Units"
}

local selector = window:New(
  "widget selector",
  empty:New(),
  { 0.6, 0.6 }, { 0.2, 0.2 }
)
selector:SetVisibility(false)

local groupMap = {}
for i,v in pairs(groupDescs) do
  if groupMap[v] == nil then
    groupMap[v] = {}
  end
  table.insert(groupMap[v], i)
end

local function GetMaxHeight(rowCount)
  local desiredAspectRatio = 5.5
  local selectorWidth  = selector:GetW()
  local selectorHeight = selector:GetH()
  local selectorAR     = selectorWidth/selectorHeight
  return math.ceil(selectorAR/desiredAspectRatio * rowCount)
end

local function GetElement(name, cmd, configName)
  local state
  if configName ~= nil then
    state = Spring.GetConfigInt(configName)
  else
    state = profileManager:LoadValue('Window Positions', { 'DefaultGUI' }, name) or 0
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
      profileManager:SaveValue('Window Positions', { 'DefaultGUI' }, name, state)
    end
  end
  returnValue:AddCommand(command:New({
    desc = "toggle default "..name,
    OnRelease = Update
  }))
  Update()
  return returnValue
end

local function GetDefaultGUIOptions()
  return {
    text:New({ text="Default GUI" }),
    GetElement("Clock",                 "clock"), --,                "ShowClock"),
    GetElement("Console",               "console"),
    GetElement("FPS",                   "fps"), --,                  "ShowFPS"),
    GetElement("Health Bars",           "showhealthbars"),
    GetElement("Player Info",           "info",                 "ShowPlayerInfo"),
    GetElement("Resource bars",         "resbar"),
    GetElement("Simple Minimap Colors", "minimap simplecolors", "SimpleMiniMapColors"),
    GetElement("Tooltip",               "tooltip")
  }
end

local function GetIceUIWindow(index)
  local window = windowManager.children[index]
  local savedState = profileManager:LoadValue('Window Positions', { window.name }, 'enabled')
  local displayName = window.name
  if savedState == nil then
    savedState = true
  end
  window:SetVisibility(savedState)
  local color = RedStr
  if window.visible then
    color = GreenStr
  end
  local returnValue = text:New({ text=color .. displayName })
  returnValue:AddCommand(command:New({
    desc = "toggle " .. displayName,
    OnRelease = function()
      window:SetVisibility()
      local color = RedStr
      if window.visible then
        color = GreenStr
      end
      returnValue:SetText(color .. displayName)
      profileManager:SaveValue('Window Positions', { window.name }, 'enabled', window.visible)
    end
  }))
  returnValue:AddCommand(command:New({
    button = 2,
    desc = "lower " .. displayName,
    OnRelease = function()
      windowManager:LowerWindow(window)
    end
  }))
  returnValue:AddCommand(command:New({
    button = 3,
    desc = "raise " .. displayName,
    OnRelease = function()
      windowManager:RaiseWindow(window)
    end
  }))
  return returnValue
end

local function GetIceUIWindows()
  local rows = { }
  for i=1,#windowManager.children do
    local name  = windowManager.children[i].name
    if windowManager.children[i].className == "window" and name:sub(1,1):upper() == name:sub(1,1) then
      table.insert(rows, GetIceUIWindow(i))
    end
  end
  table.sort(rows, function(row1, row2)
    return string.sub(row1.text, 4, -1) < string.sub(row2.text, 4, -1)
  end)
  table.insert(rows, 1, empty:New())
  table.insert(rows, 2, text:New({ text="IceUI Windows" }))
  return rows
end

local function GetWidgetRows(group)
  local rows = {}
  for name,data in pairs(widgetHandler.knownWidgets) do
    local name = name
    local data = data
    local _, _, category = string.find(data.basename, "([^_]*)")
    local ungrouped = group == "Ungrouped" and not groupDescs[category]
    if name ~= "WidgetSelector" and (groupDescs[category] == group or ungrouped) then
      local newText = text:New({ text=name, tooltip=data.desc, updateEvery=200 })
      newText.Update = function(self)
        local order = widgetHandler.orderList[name]
        local enabled = order and (order > 0)
        local color = (data.active and GreenStr) or (enabled  and YellowStr) or RedStr
        local displayName = color .. name
        if data.fromZip then
          displayName = color .. name .. WhiteStr .. ' (mod)'
        end
        self:SetText(displayName)
      end
      newText:Update()
      newText:AddCommand(command:New({
        desc = "toggle " .. name .. " by " .. (data.author or "Unknown"),
        OnRelease = function(self)
          widgetHandler:ToggleWidget(name)
          self.owner:Update()
        end
      }))
      newText:AddCommand(command:New({
        button = 2,
        desc = "lower this " .. (data.fromZip and "mod " or "") .. "widget",
        OnRelease = function()
          widgetHandler:LowerWidget(widgetHandler:FindWidget(name))
        end
      }))
      newText:AddCommand(command:New({
        button = 3,
        desc = "raise this " .. (data.fromZip and "mod " or "") .. "widget",
        OnRelease = function()
          widgetHandler:RaiseWidget(widgetHandler:FindWidget(name))
        end
      }))
      table.insert(rows, newText)
    end
  end
  table.sort(rows, function(row1, row2)
    local mod1 = string.sub(row1.text, -5, -1) == '(mod)'
    local mod2 = string.sub(row2.text, -5, -1) == '(mod)'
    if mod1 ~= mod2 then
      return mod1  -- mod widgets first
    end
    return string.sub(row1.text, 4, -1) < string.sub(row2.text, 4, -1)
  end)
  if #rows > 0 then
    table.insert(rows, 1, empty:New())
    table.insert(rows, 2, text:New({ text=group }))
    return rows
  else
    return {}
  end
end

local function GetGroupedCols()
  local allRows = GetDefaultGUIOptions()
  for _,v in ipairs(GetIceUIWindows()) do
    table.insert(allRows, v)
  end
  for i,_ in pairs(groupMap) do
    for _,v in ipairs(GetWidgetRows(i)) do
      table.insert(allRows, v)
    end
  end
  for _,v in ipairs(GetWidgetRows("Ungrouped")) do
    table.insert(allRows, v)
  end
  local maxHeight = GetMaxHeight(#allRows)
  local cols = {}
  for i,v in ipairs(allRows) do
    local index = math.ceil(i/maxHeight)
    if cols[index] == nil then
      cols[index] = {}
    end
    table.insert(cols[index], v)
  end
  while #cols[#cols] < maxHeight do
    table.insert(cols[#cols], empty:New())
  end
  local colElements = {}
  for i,v in ipairs(cols) do
    colElements[i] = frames:New("rows", v)
  end
  return frames:New("cols", colElements)
end

function selector:Initialize()
  GetGroupedCols():SetParent(selector.children[1][1][2])
end

function selector:KeyPress(key, isRepeat)
  local a,c,m,s = Spring.GetModKeyState()
  if not a and not c and not m and not s and key == 292 then -- F11
    self:SetVisibility()
    windowManager:RaiseWindow(self)
    return true
  end
  if not a and not c and not m and not s and self.visible and key == 27 then -- ESC
    self:SetVisibility(false)
    return true
  end
end
selector:PersistentCallin("KeyPress")
