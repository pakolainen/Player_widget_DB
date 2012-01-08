--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_iceui.lua
--  brief:   gui elements handler
--  author:  Jan Holthusen
--
--  Copyright (C) 2007-2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name    = "IceUI",
    desc    = "The new and shiny GUI (revision 83).",
    author  = "MelTraX",
    date    = "2009-08-29",
    license = "GNU GPL, v2 or later",
    layer   = 5,
    enabled = true,  --  loaded by default?
    handler = true
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local glSlaveMiniMap      = gl.SlaveMiniMap
local spEcho              = Spring.Echo
local spGetCurrentTooltip = Spring.GetCurrentTooltip
local spGetDirList        = Spring.GetDirList
local spGetGameFrame      = Spring.GetGameFrame
local spGetModKeyState    = Spring.GetModKeyState
local spGetMyTeamID       = Spring.GetMyTeamID
local spSendCommands      = Spring.SendCommands

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

debugMode = {
  -- options
  loadingDisabled  = false, -- handy if you want to tweak the default position of windows..
  debugMode        = false,
  logFunctionCalls = false,
  profilerEnabled  = false,
  callInProfiles   = { "Update", "DrawScreen" },
  notLogThese      = { "DrawScreen", "DrawWorld", "AddConsoleLine", "Update", "IsAbove" }, --"Initialize",
  maxCallTreeDepth = 2,
  -- helper variables
  inProtectedArea  = nil,
  callTreeDepth    = 0,
  functionCalls    = 0,
  profile          = {},
  tableToInspect   = nil,
  Inspect          = function() -- overwritten by the inspector
    -- Spring.Echo('Please remove debugMode.Inspect() for release.')
  end
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  some constants and includes

GUI_DIRNAME        = LUAUI_DIRNAME .. 'Widgets/IceUI/'
COMPONENTS_DIRNAME = GUI_DIRNAME .. 'Components/'
ELEMENTS_DIRNAME   = GUI_DIRNAME
TEXTURES_DIRNAME   = GUI_DIRNAME .. 'Images/'
PROFILES_DIRNAME   = GUI_DIRNAME .. 'Profiles/'
FONTS_DIRNAME      = GUI_DIRNAME .. 'Fonts/'

include("colors.h.lua")
include("utils.lua")
include("fonts.lua")

local gl = gl

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  helper functions

-- this function converts its boolean parameters into a string of with corresponding 1 or 0 characters
function BoolsToString(...)
  local boolString = ""
  for _,v in ipairs({...}) do
    boolString = boolString .. (v and "1" or "0")
  end
  return boolString
end

function MetakeyStatesAsBinaryString()
  return BoolsToString(spGetModKeyState())
end

-- view the lua documentation for more information on metatables
-- this function assigns a metatable to a table and provides debug info if necessary
function GenMeta(OriginalTable, TableToIndex, NewIndexFunction)
  if not debugMode.debugMode then
    return setmetatable(OriginalTable, { __index = TableToIndex, __newindex = NewIndexFunction})
  else
    local mt = {__index = TableToIndex}
    local pr = debugMode.profile
    pr.callCount = pr.callCount or {}
    pr.time = pr.time or {}
    pr.timePerCall = pr.timePerCall or {}
    pr.callIns = pr.callIns or {}
    pr.callInsPercent = pr.callInsPercent or {}
    for _,v in ipairs(debugMode.callInProfiles) do
      pr.callIns[v] = pr.callIns[v] or {}
      pr.callInsPercent[v] = pr.callInsPercent[v] or {}
    end
    mt.__newindex = function(t, i, v)
      -- this function gets called if you do a OriginalTable[i] = v (only if OriginalTable[i] was nil before)
      -- at first some wierd local variables.. I don't really know why I need all those but it works this way so don't change anything!
      local NewIndexFunction = NewIndexFunction
      local i, iS, oldV, newV = i, tostring(i), v, v
      if type(oldV) == "function" then
        local ident = t.name or t.className or "table"
        -- if debugMode.profilerEnabled then save the time it took to execute the given function in debugMode.profile
        pr.time[ident] = pr.time[ident] or {}
        pr.callCount[ident] = pr.callCount[ident] or {}
        pr.timePerCall[ident] = pr.timePerCall[ident] or {}
        pr.time[ident][iS] = pr.time[ident][iS] or 0
        pr.callCount[ident][iS] = pr.callCount[ident][iS] or 0
        if debugMode.profilerEnabled then
          newV = function(...)
            local startTime = os.clock()
            local returnValues = {oldV(...)}
            pr.time[ident][iS] = pr.time[ident][iS] + os.clock() - startTime
            pr.callCount[ident][iS] = pr.callCount[ident][iS] + 1
            pr.timePerCall[ident][iS] = pr.time[ident][iS] / pr.callCount[ident][iS]
            for _,v in ipairs(debugMode.callInProfiles) do
              if iS == v then
                pr.callIns[v][ident] = pr.callIns[v][ident] or 0
                pr.callIns[v][ident] = pr.callIns[v][ident] + os.clock() - startTime
                if ident == "widget" then
                  local total = 0
                  for i,v in pairs(pr.callIns[v]) do
                    if i ~= "widget" then
                      total = total + v
                    end
                  end
                  local percent = 1 - total / (pr.callIns[v]["widget"] or 1)
                  pr.callInsPercent[v]["overhead"] = math.floor(percent*100) .. "%"
                  pr.callInsPercent[v][ident] = number.Format({colored=false}, pr.timePerCall[ident][iS]) .. "s"
                else
                  local percent = pr.callIns[v][ident] / (pr.callIns[v]["widget"] or 1)
                  pr.callInsPercent[v][ident] = math.floor(percent*100) .. "%"
                end
              end
              if pr.callIns[v][ident] == 0 then
                pr.callIns[v][ident] = nil
              end
            end
            return unpack(returnValues)
          end
        end
        local oldV = newV
        -- if debugMode.logFunctionCalls then print all function calls and their duration in the console
        if debugMode.logFunctionCalls then
          newV = function(...)
            local startTime = os.clock()
            local startCalls = debugMode.functionCalls
            if debugMode.inProtectedArea == nil then
              for _,func in ipairs(debugMode.notLogThese) do
                if func == i then debugMode.inProtectedArea = ident .. iS end
              end
            end
            if debugMode.inProtectedArea == nil and debugMode.callTreeDepth < debugMode.maxCallTreeDepth then
              local indentation = string.rep(" --", debugMode.callTreeDepth)
              spEcho(spGetGameFrame() .. indentation .. " begin " .. ident .. ":" .. iS)
            end
            debugMode.callTreeDepth = debugMode.callTreeDepth + 1
            local returnValues = {oldV(...)}
            debugMode.functionCalls = debugMode.functionCalls + 1
            debugMode.callTreeDepth = debugMode.callTreeDepth - 1
            if debugMode.inProtectedArea == nil and debugMode.callTreeDepth < debugMode.maxCallTreeDepth then
              local indentation = string.rep(" --", debugMode.callTreeDepth)
              local took = " (took " .. (os.clock() - startTime) .. "s"
              took = took .. " - " .. (debugMode.functionCalls - startCalls) .. " calls)"
              spEcho(spGetGameFrame() .. indentation .. " end " .. ident .. ":" .. iS .. took)
            end
            if debugMode.inProtectedArea == ident .. iS then
              debugMode.inProtectedArea = nil
            end
            return unpack(returnValues)
          end
        end
      end
      if type(NewIndexFunction) == "function" then
        NewIndexFunction(t, i, newV)
      else
        rawset(t, i, newV)
      end
    end
    return setmetatable(OriginalTable, mt)
  end
end

function table.icopy(inputTable)
  local outputTable = {}
  for i, v in ipairs(inputTable) do
    outputTable[i] = inputTable[i]
  end
  return outputTable
end
function table.copy(inputTable)
  local outputTable = {}
  for i, v in pairs(inputTable) do
    if type(v) == 'table' then
      outputTable[i] = table.copy(inputTable[i])
    else
      outputTable[i] = inputTable[i]
    end
  end
  return outputTable
end
function table.empty(inputTable)
  for _,_ in pairs(inputTable) do
    return false
  end
  return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  the windowManager

windowManager = {
  className = "windowManager",
  callInList = { "Initialize", "TweakEntered", "TweakExited", "TweakUpdate", "TeamChanged" },
  currentTeam = 0,
  isTweak = false,
  isAbove = false,
  isAboveX = -1,
  isAboveY = -1,
  timeFrame = 0,
  helpTooltip = false,
  children = {},
  dimensions = nil,
  mouseOwner = nil,
  activeCommand = nil,
  currentCommands = {{},{},{}},
  currentTooltip = "No tooltip available.",
  currentHelp = "No help available."
}
windowManager = GenMeta(windowManager)

function windowManager:AddChild(newChild)
  table.insert(self.children, newChild)
end

function windowManager:RemoveChild(oldChild)
  for i,v in ipairs(self.children) do
    if v == oldChild then
      table.remove(self.children, i)
    end
  end
end

function windowManager:Resize(newWidth, newHeight)
  self.dimensions.absolute.width = newWidth
  self.dimensions.absolute.height = newHeight
  self.dimensions.absolute.y = newHeight-1
  self.dimensions:NotifyListeners()
end

-- posts a notice window (like a message box)
function windowManager:Notice(message)
  for i=75,string.len(message),75 do
    message = string.sub(message, 0, i-1) .. "\n" .. string.sub(message, i)
  end
  local noticeWin = window:New(
    "notice",
    margin:New(
      text:New({
        lines = 10,
        text = message
      }), {5,5,5,5}
    ),
    {.4,.2}, {.3,.4}
  )
  noticeWin:AddCommand(command:New({
    desc = "close this dialog",
    OnPress = function(self)
      self.owner:GetWindow():Destroy()
    end
  }))
end

-- register a component's functions in the windowManager's lists
-- checks a component for every function in windowManager.callInList and registers it if necessary
function windowManager:RegisterFunctions(component)
  for _,listname in ipairs(self.callInList) do
    -- check if the component has the selected function
    if type(component[listname]) == "function" then
      -- check to see if this function already appears in the list
      local alreadyRegistered = false
      for i,v in ipairs(self[listname..'List']) do
        if v == component then
          alreadyRegistered = true
          break
        end
      end
      -- if not, lets make sure its put in there
      if not alreadyRegistered then
        --if listname == 'DrawScreen' then
          --Spring.Echo('inserting '..listname, Spring.GetGameFrame())
        --end
        table.insert(self[listname..'List'], component)
      end
    end
  end
end

-- unregisters all of a component's functions (removes them from every call list)
function windowManager:UnRegisterFunctions(component)
  for _,functionName in ipairs(windowManager.callInList) do
    if type(component[functionName]) == "function" and not component.persistentCallins[functionName] then
      self:RemoveCallin(component, functionName)
    end
  end
end

-- unregisters one callin
function windowManager:RemoveCallin(component, functionName)
  for i,v in ipairs(self[functionName..'List']) do
    if v == component then
      table.remove(self[functionName..'List'], i)
      break
    end
  end
end

function windowManager:RaiseWindow(window)
  for i,wChild in ipairs(self.children) do
    if wChild == window then
      local temp=wChild
      table.remove(self.children, i)
      -- make our window the last one in the children table
      table.insert(self.children, wChild)
      break
    end
  end
end

function windowManager:LowerWindow(window)
  for i,wChild in ipairs(self.children) do
    if wChild == window then
      local temp=wChild
      table.remove(self.children, i)
      -- make our window the first one in the children table
      table.insert(self.children, 1, wChild)
      break
    end
  end
end

function windowManager:ModalDialog(allowed, callback)
  local backups = {}
  local Reset = function()
    for i,v in pairs(backups) do
      widget[i] = v
    end
  end
  for _,v in ipairs{ 'KeyRelease', 'MouseRelease', 'KeyPress', 'MousePress', 'MouseMove', 'MouseWheel' } do
    if not backups[v] then
      backups[v] = widget[v]
    end
    widget[v] = function(...)
      if allowed:IsAbove(Spring.GetMouseState()) then
        local returnValue = { backups[v](...) }
        if returnValue then
          Reset()
        end
        return unpack(returnValue)
      else
        if callback(v, ...) then
          Reset()
          return backups[v](...)
        end
        return true
      end
    end
  end
end

function windowManager:GetWindowList()
  local windows = { }
  for _,window in ipairs(windowManager.children) do
    local name  = window.name
    if name:sub(1,1):upper() == name:sub(1,1) and window.className == "window" then
      table.insert(windows, name)
    end
  end
  return windows
end
function windowManager:GetWindow(name)
  for _,window in ipairs(windowManager.children) do
    if name == window.name and window.className == "window" then
      return window
    end
  end
end

local function LoadKeyMap(name)
  local chunk, err = loadfile(PROFILES_DIRNAME .. name .. '.lua')
  if (chunk == nil) then
    return {}
  else
    local tmp = {}
    setfenv(chunk, tmp)
    return chunk() or {}
  end
end
local allChars = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXY"..
                 "Z[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"..
                 ""..
                 ""
function windowManager:GetUserInput(maxlen, callback)
  local DefaultKeyPress = windowManager.KeyPressWrapper
  local keyMap = LoadKeyMap('en')
  local onKeyboard = {}
  for _,v in pairs(keyMap) do
    onKeyboard[v] = true
  end

  local function GetButtons(chars, perRow)
    local buttons = {}
    for i=1,string.len(chars) do
      local char = string.sub(chars,i,i)
      if not onKeyboard[char] then
        table.insert(buttons, button:New{caption=char, OnPress=function(self) self.parent[2]:Append(char) end})
        table.insert(buttons, { .5+.03*((i-1)%perRow-perRow/2), .3+.05*math.floor((i-1)/perRow) })
        table.insert(buttons, { .02, .04 })
      end
    end
    return unpack(buttons)
  end
  local overlay = free:New(
    color:New({ 0,0,0,0.8 }), { nil, nil }, { nil, nil },
    text:New({ text=YellowStr..'Input: '..WhiteStr, align='center' }), { nil, nil}, { nil, .5 }
    --GetButtons(allChars, 24)
  )
  overlay:MoveTo(0,0)
  overlay:ResizeTo()
  function overlay:KeyPress(input, modKeys)
    if input == 13 or input == 27 then
      if type(callback) == 'function' then
        callback(input==13 and string.sub(self[2].text, 16) or nil)
      end
      windowManager.KeyPressWrapper = DefaultKeyPress
      self:Destroy()
      return true
    end

    local keyInput = keyMap[input..BoolsToString(modKeys.alt, modKeys.ctrl, modKeys.shift)]
    if keyInput then
      self[2]:Append(keyInput)
      return true
    end

    if not modKeys.alt and not modKeys.ctrl then
      local symbols = { [32]=1, [44]=1, [45]=1, [46]=1 }
      if input > 96 and input < 123 or (input > 47 and input < 58 or symbols[input]) and not modKeys.shift then
        if not modKeys.shift then
          self[2]:Append(string.char(input))
        else
          self[2]:Append(string.upper(string.char(input)))
        end
      end
      if input == 8 and string.len(self[2].text) > 15 then
        self[2]:SetText(string.sub(self[2].text,1,-2))
      end
    end
    return true
  end
  windowManager.KeyPressWrapper = function(self, input, modKeys)
    return overlay:KeyPress(input, modKeys)
  end
  function overlay:KeyRelease()
    return true
  end
  overlay[2].Append = function(self, char)
    if string.len(self.text) < 15+maxlen then
      self:SetText(self.text..char)
    end
  end
end
function windowManager:CreateKeyboardLayout(name)
  local keyMap = {}
  local function GetKey(char, left, callback)
    local overlay = free:New(
      color:New({ 0,0,0,0.8 }), { nil, nil }, { nil, nil },
      text:New({ text='Please enter this symbol (press ESC if it\'s not on your keyboard or a box): \''..char.."'\n(Symbols left: \'"..left.."')", align='center', lines=2 }), { nil, nil}, { nil, nil }
    )
    overlay:MoveTo()
    overlay:ResizeTo()
    function overlay:KeyPress(input, modKeys)
      Spring.Echo(input)
      if input == 304 or input == 306 or input == 308 or input == 311 then return end
      callback(input~=27 and input or nil, input~=27 and modKeys or nil)
      self:Destroy()
      return true
    end
    function overlay:KeyRelease()
      return true
    end
  end
  local function Wrapper(i)
    if i<string.len(allChars) then
      local char = string.sub(allChars,i,i)
      GetKey(char, string.sub(allChars,i), function(input, modKeys)
        if input and modKeys then
          keyMap[input..BoolsToString(modKeys.alt, modKeys.ctrl, modKeys.shift)] = char
        end
        Wrapper(i+1)
      end)
    else
      Spring.CreateDir(GUI_DIRNAME)
      Spring.CreateDir(PROFILES_DIRNAME)
      table.save(keyMap, PROFILES_DIRNAME .. name .. '.lua')
    end
  end
  Wrapper(1)
end

function windowManager:CallInXFrames(frames, func)
  local WidgetGameFrame = widget.GameFrame
  widget.GameFrame = function(...)
    frames = frames - 1
    if frames == 0 then
      func()
      widget.GameFrame = WidgetGameFrame
      widgetHandler:UpdateWidgetCallIn('GameFrame', widget)
    end
    WidgetGameFrame(...)
  end
  widgetHandler:UpdateWidgetCallIn('GameFrame', widget)
end
windowManager = GenMeta(windowManager, windowManager.children)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  the profileManager (handling different configFiles)

profileManager = {
  className = "profileManager",
  currentProfile = {},
  colors = {},
  colorListeners = {}
}
profileManager = GenMeta(profileManager)
function profileManager:SaveValue(section, path, optionName, optionValue)
  if not self:SectionExists(section) then
    Spring.Echo('SaveValue: Section '..section..' does not exist.')
    return
  end
  if type(path) ~= 'table' then
    Spring.Echo('SaveValue: Path is not a table.')
    return
  end

  local target = self.currentProfile
  for _,v in ipairs({ section, unpack(path) }) do
    if type(target[v]) ~= 'table' then
      if type(target[v]) == 'nil' then
        target[v] = {}
      else
        Spring.Echo('SaveValue: Path contained a non table value.')
        return
      end
    end
    target = target[v]
  end

  if type(optionValue) == 'table' then
    optionValue = table.copy(optionValue)
  end
  target[optionName] = optionValue
end
function profileManager:LoadValue(section, path, optionName)
  if not self:SectionExists(section) then
    Spring.Echo('LoadValue: Section '..section..' does not exist.')
    return
  end
  if type(path) ~= 'table' then
    Spring.Echo('LoadValue: Path is not a table.')
    return
  end

  local target = self.currentProfile
  for _,v in ipairs({ section, unpack(path) }) do
    if type(target[v]) ~= 'table' then
      --Spring.Echo('LoadValue: Path contained a non table value.', table.concat(path, ', '))
      return
    end
    target = target[v]
  end

  return target[optionName]
end

function profileManager:GetColors()
  return self.colors
end
function profileManager:GetColorDefinition(key, windowName)
  local color = self:LoadValue('Colors', { windowName }, key)
  if not color then
    color = self:LoadValue('Colors', { 'global' }, key) or self.colors[key]
  end
  return color
end
function profileManager:UpdateColor(color, windowName)
  if windowName then -- it's nil if the team was changed for example
    self:SaveValue('Colors', { windowName }, color.key, color)
  end

  for listenerID in pairs(self.colorListeners[color.key]) do
    self:CallColorListener(listenerID)
  end
  for _,v in ipairs(self:GetInheritingColors(color.key)) do
    self:UpdateColor(unpack(v))
  end
end
function profileManager:RegisterColorListener(color, component, callback)
  if not color.inherit then
    color.inherit = {
      type = 'none',
      key  = 'teamcolor'
    }
  end

  if self.colors[color.key] == nil then
    self.colors[color.key] = color
    self.colors[color.key].callbacks = {}
  end

  local listenerID = #self.colorListeners+1
  self.colorListeners[listenerID] = { key=color.key, component=component, callback=callback }
  if self.colorListeners[color.key] == nil then
    self.colorListeners[color.key] = {}
  end
  self.colorListeners[color.key][listenerID] = true
  self:CallColorListener(listenerID)
  return listenerID
end
function profileManager:UnregisterColorListener(listenerID)
  self.colorListeners[self.colorListeners[listenerID].key][listenerID] = nil
  self.colorListeners[listenerID] = nil
end
function profileManager:CallColorListener(listenerID)
  local listener = self.colorListeners[listenerID]
  if not listener then
    return
  end
  local key = listener.key
  local component = listener.component
  local callback = listener.callback

  local window = component and component:GetWindow()
  local color = self:GetColorDefinition(key, (window and window.name) or 'global')

  if color.inherit.type ~= 'none' then
    local inheritedColor = {}
    if color.inherit.key == 'teamcolor' then
      inheritedColor = { Spring.GetTeamColor(Spring.GetMyTeamID()) }
    elseif color.inherit.key == 'global' then
      self:UnregisterColorListener(
        self:RegisterColorListener(color, nil, function(newColor)
          inheritedColor = newColor
        end)
      )
    else
      self:UnregisterColorListener(
        self:RegisterColorListener(self.colors[color.inherit.key], component, function(newColor)
          inheritedColor = newColor
        end)
      )
    end
    if color.inherit.type == 'alpha' or color.inherit.type == 'both' then
      color.color[4] = inheritedColor[4]
    end
    if color.inherit.type == 'color' or color.inherit.type == 'both' then
      for i=1,3 do
        color.color[i] = inheritedColor[i]
      end
    end
  end
  callback(color.color)
end
function profileManager:TeamChanged()
  for _,v in ipairs(self:GetInheritingColors('teamcolor')) do
    self:UpdateColor(unpack(v))
  end
end
function profileManager:GetInheritingColors(key)
  local colors = {}
  if self.currentProfile.Colors then
    for i,v in pairs(self.currentProfile.Colors) do
      for j,w in pairs(v) do
        if w.inherit.type ~= 'none' and w.inherit.key == key then
          table.insert(colors, { w, i })
        end
      end
    end
  end
  return colors
end

function profileManager:WriteToFile(file, sections)
  if not debugMode.loadingDisabled then
    Spring.CreateDir(GUI_DIRNAME)
    Spring.CreateDir(PROFILES_DIRNAME)
    table.save(self.currentProfile, PROFILES_DIRNAME .. file .. '.lua')
  end
end
function profileManager:ReadFromFile(file, sections)
  if not debugMode.loadingDisabled then
    local content = VFS.LoadFile(PROFILES_DIRNAME .. file .. '.lua')
    if content then
      local chunk, err = loadstring(content)
      if (chunk == nil) then
        Spring.Echo('Loading IceUI profile failed: ' .. err)
        return false
      else
        local tmp = {}
        setfenv(chunk, tmp)
        self.currentProfile = chunk()
        if (not self.currentProfile) then
          self.currentProfile = {} -- safety
        end
        return true
      end
    else
      return false
    end
  end
end
function profileManager:GetProfileList()
  local profiles = {}
  for _,v in ipairs(VFS.DirList(PROFILES_DIRNAME, "*.lua", VFS.RAW_FIRST)) do
     local _,_,name = string.find(v, ".*/(.*).lua")
     if name == nil then
        _,_,name = string.find(v, ".*\\(.*).lua")
     end
     if name ~= 'current' and name:sub(1,1):upper() == name:sub(1,1) then
        table.insert(profiles, name)
     end
  end
  return profiles
end
function profileManager:GetSectionList()
  return { 'Window Settings', 'Window Positions', 'Colors', 'Widget Settings', 'Active Widgets', 'Spring Settings' }
end
function profileManager:SectionExists(section)
  for _,v in ipairs(self:GetSectionList()) do
    if section == v then
      return true
    end
  end
  return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  invisible objects

local dimensions = {
  className = "dimensions"
}
dimensions = GenMeta(dimensions)
function dimensions:New(newTable)
  local newObject = GenMeta(newTable, dimensions)
  newObject.absolute = {
    x = 0,
    y = 0,
    width = 0,
    height = 0
  }
  newObject.relative = {}
  newObject.snappedTo = {}
  newObject.linkedTo = {}
  newObject.notifyList = {}
  return newObject
end
function dimensions:ResizeTo(newWidth, newHeight)
  if type(newWidth)  == 'number' and newWidth  < 0 and newWidth  > -1 then newWidth  = 1 + newWidth  end
  if type(newHeight) == 'number' and newHeight < 0 and newHeight > -1 then newHeight = 1 + newHeight end

  if type(newWidth) ~= 'boolean' then
    self.relative.width = newWidth
  end
  if type(newHeight) ~= 'boolean' then
    self.relative.height = newHeight
  end

  if not widget.init then
    self:CalculateAbsolute()
  end
end
function dimensions:MoveTo(newX, newY)
  if type(newX) == 'number' and newX < 0 and newX > -1 then newX = 1 + newX end
  if type(newY) == 'number' and newY < 0 and newY > -1 then newY = 1 + newY end
  self.relative.x = newX
  self.relative.y = newY
  if not widget.init then
    self:CalculateAbsolute()
  end
end
function dimensions:CalculateAbsolute()
  local pDim = self.owner.parent.dimensions
  for i,_ in pairs(self.absolute) do
    if self.relative[i] == nil then
      self.absolute[i] = pDim.absolute[i]
    elseif type(self.relative[i]) == 'function' then
      self.absolute[i] = self.relative[i](pDim)
    elseif i == "height" or i == "width" then
      if     self.relative[i] < 0 then self.absolute[i] = pDim.absolute[i] + self.relative[i]
      elseif self.relative[i] < 1 then self.absolute[i] = pDim.absolute[i] * self.relative[i]
      else                             self.absolute[i] =                    self.relative[i] end
    else
      local factor = 1
      local sizeDim = "width"
      if i == "y" then
        factor = -1
        sizeDim = "height"
      end
      if     self.relative[i] < 0 then self.absolute[i] = pDim.absolute[i] + (pDim.absolute[sizeDim] + self.relative[i])*factor
      elseif self.relative[i] < 1 then self.absolute[i] = pDim.absolute[i] + (pDim.absolute[sizeDim] * self.relative[i])*factor
      else                             self.absolute[i] = pDim.absolute[i] + self.relative[i]*factor end
    end
    self.absolute[i] = math.floor(self.absolute[i]+0.5)
  end
  if self.owner.OnResize then
    self.owner:OnResize()
  end
  self:NotifyListeners()
end
function dimensions:SetParent(newParent)
  if self.parent ~= nil then
    self.parent:RemoveListener(self)
  end
end
function dimensions:AddListener(newListener)
  table.insert(self.notifyList, newListener)
end
function dimensions:RemoveListener(oldListener)
  table.remove(self.notifyList, oldListener)
end
function dimensions:NotifyListeners()
  for _, child in pairs(self.owner.children) do
    if type(child.dimensions) == "table" then -- inserted for DEBUG mode
      child.dimensions:CalculateAbsolute()
    else
      --debugMode.tableToInspect = child
    end
  end
  for _, listener in pairs(self.notifyList) do
    listener:CalculateAbsolute()
  end
end

command = {
  className = "command",
  button = 1,
  alt = false,
  ctrl = false,
  meta = false,
  shift = false,
  drag = false,
  toggle = false,
  desc = "do nothing (standard description)",
  requiresWidget = nil,
  requiresWidgetAuthor = nil
}
command = GenMeta(command)
function command:New(newTable)
  local newObject = GenMeta(newTable, command)
  local rW, rWA, kW = newObject.requiresWidget, newObject.requiresWidgetAuthor, widgetHandler.knownWidgets
  if rW and kW[rW] == nil or rWA and kW[rW].author ~= rWA then
    newObject.desc = GreyStr .. newObject.desc .. " (requires " .. rW .. " widget)"
    local oldDescFunction = newObject.GetDescription
    if oldDescFunction then
      newObject.GetDescription = function(...)
        local newDesc = oldDescFunction(...)
        newDesc = GreyStr .. newDesc .. " (requires " .. rW .. " widget)"
        return newDesc
      end
    end
  end
  return newObject
end
function command:GetTooltip(x, y)
  local relX, relY = self:GetRelativePosition(x, y)
  local description
  if type(self.GetDescription) == "function" then
    description = self:GetDescription(relX, relY)
  else
    description = self.desc
  end
  return description
end
function command:MousePress(x, y)
  local returnValue = self:MousePressOrRelease(self.OnPress, self.OnDragStart, x, y)
  if not self.drag and self.OnPress == nil and self.OnRelease == nil then
    windowManager:Notice("You have to specify at least one of OnPress() or OnRelease() for normal commands!")
  end
  if self.drag and self.OnDrag == nil then
    windowManager:Notice("You have to specify at least an OnDrag(dx,dy)-function for drag commands!")
  end
  return returnValue
end
function command:MouseMove(x, y, dx, dy)
  if self.OnDrag then
    local relX, relY = self:GetRelativePosition(x, y)
    return self:OnDrag(relX, relY, dx, dy)
  end
end
function command:MouseRelease(x, y)
  return self:MousePressOrRelease(self.OnRelease, self.OnDragStop, x, y)
end
function command:MousePressOrRelease(clickFunction, dragFunction, x, y)
  local relX, relY = self:GetRelativePosition(x, y)
  if not self.drag then
    if clickFunction then
      return clickFunction(self, relX, relY)
    end
  else
    if dragFunction then
      return dragFunction(self, relX, relY)
    else
      return self:OnDrag(relX, relY, 0, 0)
    end
  end
end
function command:GetRelativePosition(x, y)
  local relX = math.min(math.max((x-self.owner:GetX()) / self.owner:GetW(), 0), 1)
  local relY = math.min(math.max((self.owner:GetY()-y) / self.owner:GetH(), 0), 1)
  return relX, relY
end

option = {
  className = "option",
  owner = nil,
  type = "bool",
  name = "",
  value = "",
  description = "Standard option description."
}
option = GenMeta(option)
function option:New(newTable)
  local newObject = GenMeta(newTable, option)
  return newObject
end
function option:GetValue()
  local savedValue = profileManager:LoadValue('Window Settings', { self.owner.name }, self.name)
  if savedValue ~= nil then
    self.value = savedValue
  end
  return self.value
end
function option:SetValue(newValue)
  profileManager:SaveValue('Window Settings', { self.owner.name }, self.name, newValue)
  self.value = newValue
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  init the screen size

windowManager.dimensions = dimensions:New({})
windowManager.dimensions.owner = windowManager
windowManager:Resize(Spring.GetViewGeometry())

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  the top level component class
--  everything visible inherits from this

component = {
  className = "component",
  parent = windowManager,
  tooltip = "",
  help = "",
  updateEvery = 2,
  maxChildren = 0,
  visible = true,
  permaInvisible = false
}
component = GenMeta(component)

function component:New(newTable)
  local newObject = GenMeta(newTable, component)
  newObject:Init()
  return newObject
end

function component:Init()
  self.dimensions = dimensions:New({})
  self.dimensions.owner = self
  self.dimensions:SetParent(self.parent.dimensions)
  self.children = {}
  self.persistentCallins = {}
  self.commands = {{},{},{}}
  self:PersistentCallin("Initialize")
  self:PersistentCallin("Shutdown")
  windowManager:RegisterFunctions(self)
  local metaT = getmetatable(self)
  setmetatable(self.children, metaT)
  -- attach a metatable that will automatically register new functions
  self = GenMeta(self, self.children, function(t, i, v)
    rawset(t, i, v)
    if type(v) == "function" then
      windowManager:RegisterFunctions(t)
    end
  end)
  self.parent:AddChild(self, 1)
end
function component:SetContent(newContent, index)
  if index == nil then index = 1 end
  if index > self.maxChildren then
    windowManager:Notice("trying to set content to more than possible children")
    return
  end
  if self.children[index] then
    self.children[index]:Destroy(true)
  end
  newContent:SetParent(self, index)
end
function component:SetParent(newParent, newIndex)
  if self.parent == newParent then
    return
  end
  self.parent:RemoveChild(self)
  self.parent = newParent
  self.parent:AddChild(self, newIndex)
  self.dimensions:SetParent(newParent.dimensions)
  self.dimensions:CalculateAbsolute()
  self:ParentChanged(newParent)
end
function component:ParentChanged(newParent)
  if type(self.OnParentChange) == 'function' then
    self:OnParentChange(newParent)
  end
  for _,child in ipairs(self.children) do
    child:ParentChanged()
  end
end
function component:AddChild(newChild, newIndex)
  if newIndex == nil then newIndex = 1 end
  self.children[newIndex] = newChild
end
function component:RemoveChild(oldChild)
  local index = oldChild
  if type(oldChild) == "table" then
    for i,v in ipairs(self.children) do
      if v == oldChild then
        index = i
      end
    end
  end
  if type(index) == "number" then
    for i=index, #self.children do
      self.children[i] = self.children[i+1]
    end
  end
end
function component:PersistentCallin(callin)
  self.persistentCallins[callin] = true
end

-- this function finds the path of a table in a tabular tree
-- it is ordered as a table index={...}
-- note: I am leaving this function in, though I can think of no current use for it
function component:GetPath()
  local pathTable = {}
  local pointer = self
  while pointer.parent do
    for i,v in ipairs(pointer.parent.children) do
      if v == pointer then
        table.insert(pathTable, 1, i)
        break
      end
    end
    pointer = pointer.parent
  end
  table.insert(pathTable, 1000) -- end the table with a ridiculously high number
  return pathTable
end
function component:AddCommand(newCommand)
  local cmdString = BoolsToString(newCommand.alt,newCommand.ctrl,newCommand.meta,newCommand.shift)
  newCommand.owner = self
  self.commands[newCommand.button][cmdString] = newCommand
end
function component:RemoveCommand(button, cmdString)
  if self.commands[button][cmdString] then
    if windowManager.currentCommands[button][cmdString] == self.commands[button][cmdString] then
      windowManager.currentCommands[button][cmdString] = nil
    end
    if windowManager.activeCommand == self.commands[button][cmdString] then
      windowManager.activeCommand = nil
    end
    self.commands[button][cmdString].owner = nil
    self.commands[button][cmdString] = nil
  end
end
function component:SetVisibility(newVisible, inheritedCall)
  if newVisible == self.visible and not self.permaInvisible then return end
  if newVisible == nil then
    newVisible = not self.visible
  end
  if inheritedCall == nil then
    self.permaInvisible = not newVisible
  end
  if inheritedCall == nil or self.permaInvisible == false then
    self.visible = newVisible
    if self.visible then
      windowManager:RegisterFunctions(self)
    else
      windowManager:UnRegisterFunctions(self)
    end
    for _,v in ipairs(self.children) do
      v:SetVisibility(newVisible, true)
    end
  end
  if newVisible and self.Update then
    self:Update()
  end
end
function component:ResizeTo(width, height)
  if (width and width == 0) or (height and height == 0) then
    self:SetVisibility(false)
  else
    self:SetVisibility(true)
    self.dimensions:ResizeTo(width, height)
  end
end
function component:ResizeBy(dx, dy)
  self:ResizeTo(self:GetW() + dx, self:GetH() + dy)
end
function component:MoveTo(newX, newY)
  self.dimensions:MoveTo(newX, newY)
end
function component:MoveBy(dx, dy)
  if dx == 0 and dy == 0 then
    return
  end
  local _, screenH = Spring.GetViewGeometry()
  self:MoveTo(self:GetX() + dx, screenH - 1 - self:GetY() + dy)
end
function component:GetX()
  return self.dimensions.absolute.x
end
function component:GetR()
  return self:GetX() + self:GetW()
end
function component:GetY()
  return self.dimensions.absolute.y
end
function component:GetB()
  return self:GetY() - self:GetH()
end
function component:GetW()
  return self.dimensions.absolute.width
end
function component:GetH()
  return self.dimensions.absolute.height
end
function component:Draw()
  if not self.visible then return end
  if type(self.DrawScreen) == "function" then
    self:DrawScreen()
  end
  for i,v in ipairs(self.children) do
    v:Draw()
  end
end
function component:IsAbove(x, y)
  return x >= self:GetX() and x < self:GetR() and y <= self:GetY() and y > self:GetB()
end
function component:GetWindow()
  if not self.className or self.className == 'windowManager' then
    return nil
  elseif self.className == 'window' then
    return self
  else
    return self.parent:GetWindow()
  end
end

-- completely remove this component from everything
function component:Destroy(calledFromSetContent)
  self:DestroyChildren()
  if type(self.OnDestroy) == 'function' then
    self:OnDestroy()
  end
  windowManager:UnRegisterFunctions(self)
  if not calledFromSetContent then
    self.parent:RemoveChild(self)
  end
end
function component:DestroyChildren()
  for i=#self.children,1,-1 do
    self.children[i]:Destroy()
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  widget call-ins


--  call-ins that aren't used by the window manager directly
--  but can be used by every component
local function GeneralDistribute(functionName, arguments)
  for _,window in ipairs(windowManager[functionName.."List"]) do
    local window = window
    local returnValue = {window[functionName](window, unpack(arguments))}
    if #returnValue > 0 then
      return unpack(returnValue)
    end
  end
end


widget.className = "widget"
widget = GenMeta(widget)
function widget:Initialize()
  -- wrap the KeyPress callin so we can change it later on
  windowManager.KeyPressWrapper = widgetHandler.KeyPress
  widgetHandler.KeyPress = function(...) return windowManager.KeyPressWrapper(...) end

  widget.init = true

  -- make a list of call-ins by searching the widgetHandler
  for i,v in pairs(widgetHandler) do
    if string.sub(i, -4, -1) == "List" and type(v) == "table" and i ~= "orderList" and i ~= "IsAboveList" and i ~= "DrawScreenList" then
      table.insert(windowManager.callInList, string.sub(i, 0, -5))
    end
  end

  --create a call function list for every function in windowManager.callInList
  for _,listname in ipairs(windowManager.callInList) do
    windowManager[listname..'List'] = {}
  end

  for _, functionName in ipairs(windowManager.callInList) do
    if widget[functionName] == nil then
      local functionName = functionName
      widget[functionName] = function(self, ...)
        return GeneralDistribute(functionName, {...})
      end
      if widgetHandler[functionName .. "List"] ~= nil then
        widgetHandler:UpdateWidgetCallIn(functionName, widget)
      end
    end
  end

  --  tweak call-ins are forwarded to the normal ones
  --  because I use the tweak mode a bit different

  local tweakNames = {"IsAbove", "GetTooltip", "MousePress", "MouseMove",
                      "MouseRelease", "MouseWheel", "KeyPress", "KeyRelease"}
  for _, tweakName in ipairs(tweakNames) do
    local tweakName = tweakName
    widget["Tweak" .. tweakName] = function(self, ...)
      return widget[tweakName](widget, ...)
    end
    if widgetHandler[tweakName .. "List"] ~= nil then
      widgetHandler:UpdateWidgetCallIn("Tweak" .. tweakName, widget)
    end
  end

  glSlaveMiniMap(true)
  -- remove all the other ui elements
  spSendCommands({
    "resbar 0",
    "console 0",
    "tooltip 0",
    "minimap slavemode 1",
    --"minimap minimize 1",
  })
  --widgetHandler:ConfigLayoutHandler(false)

  if not profileManager:ReadFromFile('current') then
    profileManager:ReadFromFile('Default')
  end
  windowManager:RegisterFunctions(profileManager)

  local dirsToLoad = { COMPONENTS_DIRNAME, ELEMENTS_DIRNAME }
  local errorTable = {}

  -- load all components specified in our previously defined directories
  for _,sDir in ipairs(dirsToLoad) do
    local componentFiles = VFS.DirList(sDir, "*.lua", VFS.RAW_FIRST) -- spGetDirList(v, "*.lua")
    for _,filename in ipairs(componentFiles) do
      local content = VFS.LoadFile(filename)
      local chunk, err = loadstring(content)
      if chunk then
        setfenv(chunk, widget)
        if debugMode.debugMode then
          spEcho("loading " .. filename)
        end
        chunk()
      else
        spEcho("Error while loading " .. filename .. ".. ("..err..")")
      end
    end
  end

  widget.init = false
  windowManager.dimensions:NotifyListeners()

  -- show all our errors
  for _,v in ipairs(errorTable) do
    windowManager:Notice(v)
  end
  if type(settingsWindow) == 'table' and type(settingsWindow.WrapOptions) == 'function' then
    settingsWindow:WrapOptions()
  end
  GeneralDistribute("Initialize", {})
end

function widget:Shutdown()
  GeneralDistribute("Shutdown", {})
  profileManager:WriteToFile('current')

  glSlaveMiniMap(false)
  spSendCommands({
    "resbar 1",
    "console 1",
    "tooltip 1",
    "minimap minimize 0",
  })
end

function widget:ViewResize(viewSizeX, viewSizeY)
  windowManager:Resize(viewSizeX, viewSizeY)
  GeneralDistribute("ViewResize", {})
end

function widget:Update(dt)
  -- handle tweak mode enter/exit calls
  local whIsTweak = widgetHandler.tweakMode
  if whIsTweak == nil then whIsTweak = widgetHandler:InTweakMode() end
  if whIsTweak ~= windowManager.isTweak then
    windowManager.isTweak = whIsTweak
    if windowManager.isTweak then
      GeneralDistribute('TweakEntered', {})
    else
      GeneralDistribute('TweakExited', {})
    end
  end

  -- handle tweak mode update calls
  if windowManager.isTweak then
    GeneralDistribute('TweakUpdate', {})
  end

  -- handle update calls
  for frame=math.floor(windowManager.timeFrame),math.floor(windowManager.timeFrame + dt*30) do
    for i,component in ipairs(windowManager.UpdateList) do
      if (frame+i) % component.updateEvery == 0 and component.visible then
        -- FIXME: this still gets called too often
        component:Update()
      end
    end
  end


  -- check for team changes (as spec)
  local newTeam = spGetMyTeamID()
  if windowManager.currentTeam ~= newTeam then
    GeneralDistribute('TeamChanged', {windowManager.currentTeam, newTeam})
    GeneralDistribute('Update', {})
    windowManager.currentTeam = newTeam
  end
  windowManager.timeFrame = windowManager.timeFrame + dt*30
end

function widget:DrawScreen()
  if not Spring.IsGUIHidden() then
    -- reset everything to default
    gl.ResetMatrices()
    gl.ResetState()
    fontHandler.UseDefaultFont()

    for i,v in ipairs(windowManager.children) do
      v:Draw()
    end

    -- reset everything to default
    gl.ResetMatrices()
    gl.ResetState()
    fontHandler.UseDefaultFont()
  end
end

function widget:DrawScreenEffects()
  if not Spring.IsGUIHidden() then
    GeneralDistribute("DrawScreenEffects", {})
  end
end

function widget:IsAbove(x, y)
  --if windowManager.isAboveY == y and windowManager.isAboveX == x then
  --  return windowManager.isAbove
  --end
  windowManager.isAboveY = y
  windowManager.isAboveX = x
  windowManager.mouseOwner = windowManager
  windowManager.isAbove = false
  windowManager.currentCommands = {{},{},{}}
  windowManager.currentTooltip = "No tooltip available."
  windowManager.currentHelp = "No help available."
  while table.getn(windowManager.mouseOwner.children) > 0 do
    local foundSomeone = false
    for _,window in ipairs(windowManager.mouseOwner.children) do
      if window.visible and (not window.isClickthrough or widgetHandler.tweakMode) and window:IsAbove(x, y) then
        windowManager.isAbove = true
        foundSomeone = true
        windowManager.mouseOwner = window
        if window.tooltip ~= "" then
          windowManager.currentTooltip = window.tooltip
        end
        if window.help ~= "" then
          windowManager.currentHelp = window.help
        end
        for i,v in ipairs(window.commands) do
          for j,w in pairs(v) do
            windowManager.currentCommands[i][j] = w
          end
        end
      end
    end
    if not foundSomeone then break end
  end
  return windowManager.isAbove
end

function widget:GetTooltip(x, y)
  local tooltip = ""
  if windowManager.helpTooltip then
    tooltip = windowManager.currentHelp
  else
    local a,c,m,s = spGetModKeyState()
    local cmdString = MetakeyStatesAsBinaryString()
    local metaString = a and "A" or ""
    metaString = metaString .. (c and "C" or "")
    metaString = metaString .. (m and "M" or "")
    metaString = metaString .. (s and "S" or "")
    if metaString ~= "" then
      metaString = metaString .. WhiteStr .. " + "
    end
    tooltip = windowManager.currentTooltip .. "\n"
    local buttonStrings = {GreenStr .. "Left", YellowStr .. "Middle", RedStr .. "Right"}
    for i=1,3 do
      local buttonStr = GreyStr .. " to do nothing (yet)"
      local currentCommand = windowManager.currentCommands[i][cmdString]
      if currentCommand ~= nil then
        local DragStr = currentCommand.drag and CyanStr.." and drag" or ""
        buttonStr = DragStr .. WhiteStr .. " to " .. currentCommand:GetTooltip(x, y)
      end
      tooltip = tooltip .. BlueStr .. metaString .. buttonStrings[i] .. "-click" .. buttonStr .. "."
      if i<3 then
        tooltip = tooltip .. "\n"
      end
    end
  end
  return tooltip
end

function widget:MousePress(x, y, button)
  if not windowManager.isAbove then return false end
  local cmdString = MetakeyStatesAsBinaryString()
  if windowManager.currentCommands[button] then
    currentCommand = windowManager.currentCommands[button][cmdString] -- ERROR index ?
  end
  if currentCommand then
    windowManager.activeCommand = currentCommand
    currentCommand:MousePress(x, y)
  end
  return true
end

function widget:MouseMove(x, y, dx, dy, button)
  if windowManager.activeCommand ~= nil and windowManager.activeCommand.drag then
    return windowManager.activeCommand:MouseMove(x, y, dx, dy)
  end
  return false
end

function widget:MouseRelease(x, y, button)
  if windowManager.activeCommand ~= nil then
    local returnValue = windowManager.activeCommand:MouseRelease(x, y)
    windowManager.activeCommand = nil
    return returnValue
  end
  return -1
end
