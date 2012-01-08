if debugMode.debugMode then
  local ROWS = 30
  local COLS = 2

  local function NewCell()
    return text:New({})
  end
  local function NewRow()
    local newContent = {}
    for i=1,COLS do
      table.insert(newContent, NewCell())
    end
    return frames:New("cols", newContent)
  end
  local function NewTable()
    local newContent = {}
    for i=1,ROWS do
      table.insert(newContent, NewRow())
    end
    return frames:New("rows", newContent)
  end
  local inspector = window:New(
    "Inspector",
    frames:New("rows", {
      frames:New("cols", {
        button:New({
          caption = "Widgets",
          OnPress = function(self)
            local widgetTable = {}
            for i,v in ipairs(widgetHandler.widgets) do
              widgetTable[v:GetInfo().name] = v
            end
            self.parent.parent[2]:SetInspect(widgetTable)
          end
        }),
        button:New({
          caption = "WM",
          OnPress = function(self)
            self.parent.parent[2]:SetInspect(windowManager)
          end
        }),
        button:New({
          caption = "Profile",
          OnPress = function(self)
            self.parent.parent[2]:SetInspect(debugMode.profile)
          end
        }),
        button:New({
          caption = "Back",
          OnPress = function(self)
            local history = self.parent.parent[2].history
            if table.getn(history) > 0 then
              self.parent.parent[2].inspect = nil
              local last = history[table.getn(history)]
              table.remove(history, table.getn(history))
              self.parent.parent[2]:SetInspect(last[1], last[2])
            end
          end
        }),
        button:New({
          caption = "Scroll up",
          OnPress = function(self)
            self.parent.parent[2]:MouseWheel(true)
          end
        })
      }),
      NewTable(),
      frames:New("cols", {
        button:New({
          caption = "Widget Profile",
          OnPress = function(self)
            self.parent.parent[2]:SetInspect(debugMode.profile.timePerCall.widget)
          end
        }),
        button:New({
          caption = "SaveData",
          OnPress = function(self)
            self.parent.parent[2]:SetInspect(profileManager.currentProfile)
          end
        }),
        button:New({
          caption = "Scroll down",
          OnPress = function(self)
            self.parent.parent[2]:MouseWheel(false)
          end
        })
      })
    }, { 20, -40, 20 }),
    { 300, 570 }, { -301, -620 }
  )

  inspector[1][2].updateEvery = 50
  inspector[1][2].Update = function(self)
    self:SetInspect()
  end
  inspector[1][2].MouseWheel = function(self, up, value)
    local x, y = Spring.GetMouseState()
    if inspector:IsAbove(x, y) then
      local newOffset = self.offset + ROWS
      if up then
        newOffset = math.max(self.offset - ROWS, 0)
      end
      self:SetInspect(nil, newOffset)
      return true
    end
  end

  inspector[1][2].offset = 0
  inspector[1][2].history = {}
  inspector[1][2].SetInspect = function(self, newInspect, newOffset)
    if self.inspect and newInspect then
      table.insert(self.history, { self.inspect, self.offset })
    end
    if newInspect then
      self.inspect = newInspect
      self.inspectSort = { }
      for i,v in pairs(newInspect) do
        table.insert(self.inspectSort,i)
      end
      table.sort(self.inspectSort, function(a,b)
        if type(a) == "number" and type(b) == "number" then
          return a < b
        else
          return tostring(a) < tostring(b)
        end
      end)
      --foreachi(self.inspectSort,function (i,v) process(t[v]) end)
      self.offset = 0
    end
    self.knownTables = {}
    for i=1,ROWS do
      for j=1,COLS do
        self[i][j]:SetText("")
        self[i][j]:RemoveCommand(1, "0000")
      end
    end
    if newOffset then self.offset = newOffset end
    local curY = 1
    for iS, vS in pairs(self.inspectSort) do
      v = self.inspect[vS]
      i = vS
      if curY > ROWS + self.offset then break end
      if curY > self.offset then
        self[curY-self.offset][1]:SetText(GreenStr .. i)
        if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
          local v = v
          local i = i
          local theTable = self.inspect
          if type(v) == "number" then
            self[curY-self.offset][2]:SetText(tostring(number:Format(v)))
          else
            self[curY-self.offset][2]:SetText(tostring(v))
          end
          if type(v) == "boolean" then
            self[curY-self.offset][2]:AddCommand(command:New({
              desc = "toggle " .. i,
              OnPress = function(self)
                theTable[i] = not theTable[i]
                self.owner:SetText(tostring(theTable[i]))
              end
            }))
          else
            self[curY-self.offset][2]:AddCommand(command:New({
              desc = "display this value in a new window",
              OnPress = function(self)
                windowManager:Notice(tostring(v))
              end
            }))
          end
        end
        if type(v) == "function" then
          local i = i
          local v = v
          local theVSelf = self.inspect
          self[curY-self.offset][2]:SetText(BlackStr .. "function")
          self[curY-self.offset][2]:AddCommand(command:New({
            desc = "call function " .. i,
            OnPress = function(self)
              local returnTable = {pcall(v)}
              if not returnTable[1] then
                returnTable = {pcall(v, theVSelf)}
              end
              self.owner.parent.parent:SetInspect(returnTable)
            end
          }))
        end
        if type(v) == "table" then
          local v = v
          local detail = v.name or v.className or #v or 'nil'
          self[curY-self.offset][2]:SetText(RedStr..(tostring(v) or "nil").." ("..detail..")")
          self[curY-self.offset][2]:AddCommand(command:New({
            desc = "inspect table " .. (tostring(v) or "nil"),
            OnPress = function(self)
              self.owner.parent.parent:SetInspect(v)
            end
          }))
        end
      end
      curY = curY + 1
    end
    local metaT = getmetatable(self.inspect)
    if metaT ~= nil and curY-self.offset <= ROWS and curY-self.offset >= 1 then
      local metaT = metaT
      self[curY-self.offset][1]:SetText(YellowStr .. "metatable")
      if type(metaT) == "table" then
        self[curY-self.offset][2]:SetText(RedStr..tostring(metaT).." (getn: "..table.getn(metaT)..")")
        self[curY-self.offset][2]:AddCommand(command:New({
          desc = "inspect table " .. tostring(metaT),
          OnPress = function(self)
            self.owner.parent.parent:SetInspect(metaT)
          end
        }))
      elseif type(metaT) == "function" then
        self[curY-self.offset][2]:SetText(BlackStr.."function")
      end
    end
    if curY <= self.offset then
      self:SetInspect(nil, self.offset - ROWS)
    end
  end

  WG.Inspect = function(table)
    if type(table) == "table" then
      inspector[1][2]:SetInspect(table)
    end
  end
  debugMode.Inspect = WG.Inspect
  WG.Inspect(Spring.GetModOptions())
  WG.Inspect(Game)

  -- old inspect mode
  inspector.inspect = false
  inspector.inspectDepth = 2
  function inspector:DrawScreen()
    if self.inspect then
      local x,y = Spring.GetMouseState()
      local what, which = Spring.TraceScreenRay(x, y)
      if what == "unit" then
        drawTable({type(UnitDefs[Spring.GetUnitDefID(which)])},self.inspectDepth)
      elseif debugMode.tableToInspect then
        drawTable(debugMode.tableToInspect,self.inspectDepth)
      else
        drawTable(windowManager.mouseOwner,self.inspectDepth)
      end
    end
  end
  inspector:AddCommand(command:New({
    button = 2,
    meta = true,
    desc = "toggle inspection mode",
    OnPress=function(self)
      self.owner.inspect = not self.owner.inspect
    end
  }))
  inspector:AddCommand(command:New({
    meta = true,
    desc = "increase inspection depth",
    OnPress=function(self)
      self.owner.inspectDepth = self.owner.inspectDepth + 1
    end
  }))
  inspector:AddCommand(command:New({
    button = 3,
    meta = true,
    desc = "decrease inspection depth",
    OnPress=function(self)
      self.owner.inspectDepth = self.owner.inspectDepth - 1
    end
  }))
  inspector:AddCommand(command:New({
    button = 2,
    desc = "reload LuaUI",
    OnRelease = function()
      Spring.SendCommands({"luaui reload"})
    end
  }))

  function drawTable(theTable, maxDepth, initX, initY, level, knownTables)
    if type(theTable) ~= "table" then
      return nil
    end
    local TEXT_HEIGHT = 9
    local INDENT = 100
    if maxDepth    == nil then maxDepth    = 10  end
    if initX       == nil then initX       = 20  end
    if initY       == nil then initY       = 730 end
    if level       == nil then level       = 1   end
    if knownTables == nil then knownTables = {}  end
    if initY       <= 0   then return        0   end
    local currentY = initY
    for i, v in pairs(knownTables) do
      if v == theTable then
        gl.Text(MagentaStr .. "--> " .. i, initX, currentY, TEXT_HEIGHT, "O")
        return 0
      end
    end
    table.insert(knownTables, theTable)
    gl.Text(MagentaStr .. table.getn(knownTables), initX-1-INDENT, currentY, TEXT_HEIGHT, "or")
    if level == maxDepth+1 then
      gl.Text(RedStr..tostring(theTable).." (max Depth - getn: "..table.getn(theTable)..")", initX, currentY, TEXT_HEIGHT, "O")
      return 0
    end
    gl.Text(GreenStr .. "__tostring", initX, currentY, TEXT_HEIGHT, "o")
    gl.Text(tostring(theTable), initX+INDENT, currentY, TEXT_HEIGHT, "o")
    currentY = currentY - TEXT_HEIGHT - 1
    for i, v in pairs(theTable) do
      gl.Text(GreenStr .. tostring(i), initX, currentY, TEXT_HEIGHT, "o")
      if type(v) == "string" or type(v) == "number" then
        gl.Text(v, initX+INDENT, currentY, TEXT_HEIGHT, "o")
      end
      if type(v) == "boolean" then
        if v then
          gl.Text("true", initX+INDENT, currentY, TEXT_HEIGHT, "o")
        else
          gl.Text("false", initX+INDENT, currentY, TEXT_HEIGHT, "o")
        end
      end
      if type(v) == "table" then
        currentY = currentY - drawTable(v, maxDepth, initX + INDENT, currentY, level+1, knownTables)
      end
      if type(v) == "function" then
        gl.Text(BlackStr .. "function", initX+INDENT, currentY, TEXT_HEIGHT, "O")
      end
      currentY = currentY - TEXT_HEIGHT - 1
    end
    if currentY == initY then
      gl.Text(BlackStr .. "empty table", initX, currentY, TEXT_HEIGHT, "O")
    end
    local metaT = getmetatable(theTable)
    if metaT ~= nil then
      gl.Text(YellowStr .. "metatable", initX, currentY, TEXT_HEIGHT, "o")
      currentY = currentY - drawTable(metaT, maxDepth, initX+INDENT, currentY, level+1, knownTables)
    end
    return initY-currentY
  end

  -- taller console window
  local historyConsole = window:New(
    "Debug Console",
    text:New({
      logging = true,
      lines = 50,
      AddConsoleLine = function(self, newLine)
        debugMode.tableToInspect=widgetManager
        if self.logging then
          self:SetText(newLine .. "\n" .. self.text)
        end
      end
    }),
    { 200, 700 }, { 800, 30 }
  )
  historyConsole:AddCommand(command:New({
    desc = "(un)pause logging",
    OnPress = function(self)
      self.owner[1].logging = not self.owner[1].logging
    end
  }))
end
