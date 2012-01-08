-- TODO if team0 dies, all specs are "dead" (hmm, team0 was a spec too) [hmm, or not]
local console = window:New(
  "Console",
  empty:New(),
  {634/1024, 8*18+2}, {260/1024, 25/768}
)
local function NewLine()
  local newLine = frames:New("cols", {
    margin:New(
      teamLogo:New(),
      {1, 1, 1, -17}
    ),
    text:New({})},
    {19,-19}
  )
  newLine.SetLine = function(self, newTeamID, newText, newTimer)
    self[1][1]:SetVisibility(newTeamID ~= nil)
    if newTeamID then
      self[1][1]:SetTeamID(newTeamID)
    end
    self.timer = newTimer
    self[2]:SetText(newText)
  end
  newLine.GetLine = function(self)
    teamID = self[1][1].visible and self[1][1].teamID or nil
    return teamID, self[2].text, self.timer
  end
  return newLine
end
local function GetLines()
  local returnTable = {}
  for i=1,console.options.lines.value do
    table.insert(returnTable, NewLine())
  end
  return returnTable
end
local function SetConsoleContent()
  console:SetContent(frames:New("rows", GetLines()))
  console:ExitHistoryMode()
end
console.options = {
  lines = {
    name  = 'Lines',
    desc  = 'How many lines should the console display?',
    type  = 'number', min = 2, max = 40, step = 1,
    value = 8,
    OnChange = function(self)
      SetConsoleContent()
      console.options.systemLines.max = self.value
    end
  },
  systemLines = {
    name  = 'System lines',
    desc  = 'Up to how many lines should the system messages take up?',
    type  = 'number', min = 1, max = 8, step = 1,
    value = 3,
    OnChange = SetConsoleContent
  },
  decayChat = {
    name  = "Decay chat",
    desc  = "If set, chat messages will disappear after a while.",
    type  = "bool",
    value = false,
    OnChange = function()
      console:ExitHistoryMode()
    end
  },
  hideUnitMsgs = {
    name  = "Hide unit messages",
    desc  = "Hide \"Can't reach destination!\" messages.",
    type  = "bool",
    value = true
  },
  hideStartPoints = {
    name  = "Hide start points",
    desc  = "Hide \"Start X\" point messages.",
    type  = "bool",
    value = true
  },
  hidePoints = {
    name  = "Hide all points",
    desc  = "Hides all messages about added points. Useful if you have another widget visualizing points.",
    type  = "bool",
    value = false
  },
  hideBuildposMsgs = {
    name  = "Hide \"Build pos blocked\" messages",
    desc  = "Hide messages about blocked build positions.",
    type  = "bool",
    value = false
  },
  specToSystem = {
    name  = "Spectator chat to system console",
    desc  = "Display spectator chat messages in the upper area with the system messages.",
    type  = "bool",
    value = false
  },
  hidePlayernames = {
    name  = "Hide playernames",
    desc  = "Hide the names of players in front chat messages.",
    type  = "bool",
    value = false
  },
  historyWithCtrl = {
    name  = "History with CTRL",
    desc  = "Only show the chat history if CTRL is pressed.",
    type  = "bool",
    value = false
  },
  separateMessages = {
    name  = "Separate messages",
    desc  = "Separate system and chat messages.",
    type  = "bool",
    value = true
  },
  addSystemToHistory = {
    name  = "Add system messages to history",
    desc  = "Also add system messages to the history.",
    type  = "bool",
    value = false
  },
  hideIfEmpty = {
    name  = "Hide if empty",
    desc  = "Hide the console if it's empty.",
    type  = "bool",
    value = false
  }
}

console.chatBuffer = {}
console.historyMode = false
console.historyModeLast = 0

console.currentLine = 1
console.currentSystemLine = 1
console.updateEvery = 75
console.help = "This is the console. Textual feedback from the game and other\n"..
               "players will popup here. (press <ENTER> to chat)\n"..
               "- Allied chat is displayed in green.. (begin with \"a:\" for ally chat)\n"..
               "- Yellow font marks points. (press <F3> to go to it)"

function console:GetTeam(line)
  line = string.gsub(line, "  ", " ")
  for i,v in ipairs(Spring.GetPlayerList()) do
    local name, active, spec, teamID = Spring.GetPlayerInfo(v)
    if name and name ~= "" and not self.options.specToSystem.value or not spec then
      local playerFound = string.find(line, "<"..name..">", 1, true)
      local specFound   = string.find(line, "["..name.."]", 1, true)
      if playerFound == 1 or playerFound == 3 or specFound == 1 or specFound == 3 then
        if specFound == 3 then
          -- Springie doesn't insert a space after nick
          specFound = 2
        end
        line = string.sub(line, string.len(name)+3+(playerFound or specFound), -1)
        if not Spring.AreTeamsAllied(teamID, Spring.GetMyTeamID()) then
          line = "\255\255\196\196" .. line
        else
          line = string.gsub(line, "Allies: ", GreenStr)
        end
        if line == "" or line == "\255\255\196\196" or line == GreenStr then line = line .. "<empty message>" end
        local _, _, isDead = Spring.GetTeamInfo(teamID)
        if spec and not isDead then teamID = -1 end
        if not self.options.hidePlayernames.value or spec then
          line = "\255\196\196\196"..name..": \255\255\255\255" .. line
        end
        return teamID, line
      elseif line == "Player "..name.." left" or line == "Spectator "..name.." left" or
             line == "Lost connection to "..name or string.find(line, "Sync error for "..name, 1, true) then
        if line:find("Sync error", 1, true) then
          line = RedStr .. line:sub(0, name:len()+15) .. ". He plays a different game now. This can't be undone. Ask him to give his units to someone else."
        elseif not spec then
          line = RedStr .. line
        else
          line = GreenStr .. line
        end
        local _, _, isDead = Spring.GetTeamInfo(teamID)
        if spec and not isDead then teamID = -1 end
        return teamID, line
      elseif string.find(line, name.." added point: ", 1, true) then
        line = string.sub(line, string.len(name)+15, -1)
        if line == "" then line = "<empty point>" end
        local _, _, isDead = Spring.GetTeamInfo(teamID)
        if spec and not isDead then teamID = -1 end
        line = YellowStr .. line
        if not self.options.hidePlayernames.value or spec then
          line = "\255\196\196\196"..name..": " .. line
        end
        return teamID, line
      end
    end
  end
  return nil, line
end
function console:AddConsoleLine(line)
  if self.options.hideUnitMsgs.value and string.find(line, ": Can't reach destination!") then
    return
  end
  if self.options.hidePoints.value and string.find(line, " added point:") then
    return
  end
  if self.options.hideStartPoints.value and string.find(line, " added point: Start ") then
    return
  end
  if self.options.hideBuildposMsgs.value and string.find(line, ": Build pos blocked") then
    return
  end
  if line == 'Reloaded ctrlpanel with: IceUI_ctrlpanel.txt' then
    return
  end

  local teamID, line = self:GetTeam(line) -- FIXME "Player tettenman left" created an icon
  local start, stop, current = self.currentSystemLine, console.options.lines.value, "currentLine"

  -- write cache lines to the buffer for scrolling
  if teamID ~= nil or self.options.addSystemToHistory.value then
    table.insert(self.chatBuffer, { teamID, line })
  end

  if self.historyMode then
    return
  end

  if teamID == nil and self.options.separateMessages.value then
    start, stop, current = 1, console.options.systemLines.value, "currentSystemLine"
    if self.currentSystemLine <= console.options.systemLines.value and self.currentLine <= console.options.lines.value then
      for i=self.currentSystemLine+1,self.currentLine do
        local j=self.currentLine + self.currentSystemLine+1 - i
        self[1][j]:SetLine(self[1][j-1]:GetLine())
      end
      self.currentLine = self.currentLine + 1
    end
  end
  if self[current] == stop + 1 then
    for i=start,stop-1 do
      self[1][i]:SetLine(self[1][i+1]:GetLine())
    end
  end
  self[current] = math.min(self[current], stop)
  local newTimer = math.floor(string.len(line)/2 + 10)
  if teamID and not self.options.decayChat.value then
    newTimer = -1
  end
  self[1][self[current]]:SetLine(teamID, line, newTimer)
  self[current] = self[current] + 1
  if self.options.hideIfEmpty.value then
    self:SetVisibility(true)
  end
end
function console:Update()
  local i = 1
  while i < self.currentLine do
    if self[1][i].timer then
      self[1][i].timer = self[1][i].timer - 1
    end
    if self[1][i].timer == 0 then
      for j=i,self.currentLine-2 do
        self[1][j]:SetLine(self[1][j+1]:GetLine())
      end
      self.currentLine = self.currentLine - 1
      self[1][self.currentLine]:SetLine(nil, "", -1)
      if i < self.currentSystemLine then
        self.currentSystemLine = self.currentSystemLine - 1
      end
    end
    i = i + 1
  end
  if self.currentLine == 1 and self.options.hideIfEmpty.value then
    self:SetVisibility(false)
  end
end
function console:MouseWheel(up, value)
  local _, ctrl = Spring.GetModKeyState()
  if self.options.historyWithCtrl.value and not ctrl then
    return
  end
  local x, y = Spring.GetMouseState()
  if self:IsAbove(x, y) then
    if self.historyMode then
      self:HistoryScroll(up)
    else
      if up then
        self:EnterHistoryMode()
      end
    end
    return true
  end
end

function console:HistoryScroll(up)
  if up == true and self.historyModeLast > (console.options.lines.value - 1) then
    self.historyModeLast = self.historyModeLast - (console.options.lines.value - 1)
  end
  if up == false then
    self.historyModeLast = self.historyModeLast + (console.options.lines.value - 1)
  end

  if self.historyModeLast > #self.chatBuffer then
    self:ExitHistoryMode()
    return
  end

  for i=1,console.options.lines.value-1 do
    j=self.historyModeLast-console.options.lines.value+i+1
    if j > 0 then
      self[1][i]:SetLine(self.chatBuffer[j][1], self.chatBuffer[j][2], -1)
    else
      self[1][i]:SetLine(nil, "", -1)
    end
  end
end
function console:EnterHistoryMode()
  self.historyMode = true
  self.historyModeLast = #self.chatBuffer
  self[1][console.options.lines.value]:SetLine(nil, "...", -1)
  self:HistoryScroll()
end
function console:ExitHistoryMode()
  self.historyMode = false
  self.historyModeLast = 0

  local chatLines = #self.chatBuffer
  if self.options.addSystemToHistory.value and self.options.separateMessages.value then
    for _,v in ipairs(self.chatBuffer) do
      if v[1] == nil then
        chatLines = chatLines - 1
      end
    end
  end

  local skipped=0
  for i=console.options.lines.value,1,-1 do
    j=#self.chatBuffer+i-math.min(console.options.lines.value, chatLines)-skipped

    if self.options.addSystemToHistory.value and self.options.separateMessages.value then
      if i <= chatLines then
        while j > #self.chatBuffer or self.chatBuffer[j][1] == nil do
          skipped = skipped + 1
          j = j - 1
        end
      else
        skipped = skipped - 1
      end
    end

    if j > 0 and j <= #self.chatBuffer and i <= chatLines and not self.options.decayChat.value then
      self[1][i]:SetLine(self.chatBuffer[j][1], self.chatBuffer[j][2], -1)
    else
      self[1][i]:SetLine(nil, "", -1)
    end
  end
  self.currentSystemLine = 1
  if chatLines < console.options.lines.value then
    self.currentLine = chatLines + 1
  else
    self.currentLine = console.options.lines.value + 1
  end
  if self.options.decayChat.value then
    self.currentLine = 1
    if self.options.hideIfEmpty.value then
      self:SetVisibility(false)
    end
  end
end

SetConsoleContent()
console:SetClickthrough(true)
console:PersistentCallin("AddConsoleLine")
