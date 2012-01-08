local _, _, iAmSpec, _ = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
--iAmSpec = false
local teamTable = Spring.GetTeamList(Spring.GetMyAllyTeamID())

local function TeamName(teamID)
  local playerList = Spring.GetPlayerList(teamID)
  local teamName = ""
  for _,v in ipairs(playerList) do
    local name, _, spec = Spring.GetPlayerInfo(v)
    if not spec and name ~= "Player" then
      teamName = teamName .. (name or "nil") .. ", "
    end
  end
  if teamName == "" then
    if side == "spec" then
      teamName = teamName .. "a spectator, "
    else
      teamName = teamName .. "an AI or a player who left, "
    end
  end
  return string.sub(teamName, 0, -3)
end

if iAmSpec then
  teamTable = Spring.GetTeamList()
  -- remove Gaia
  table.remove(teamTable, #teamTable)
  table.sort(teamTable, function(v1, v2)
    local ally1 = -1
    local ally2 = -1
    for _,allyTeam in ipairs(Spring.GetAllyTeamList()) do
      for _,team in ipairs(Spring.GetTeamList(allyTeam)) do
        if v1 == team then
          ally1 = allyTeam
        end
        if v2 == team then
          ally2 = allyTeam
        end
      end
    end
    return ally1 < ally2
  end)
end

local function NewTextRow(teamID, updateFunction)
  local returnFrames = frames:New("cols", {
    text:New({
      align = "right",
      text = "0"
    }),
    text:New({
      align = "right",
      text = "0"
    })
  })
  returnFrames.updateEvery = 50
  returnFrames.Update = updateFunction
  return returnFrames
end
local function NewNumberRow(teamID, updateFunction)
  local returnFrames = frames:New("cols", {
    number:New({}),
    number:New({})
  })
  returnFrames.updateEvery = 50
  returnFrames.Update = updateFunction
  return returnFrames
end

local function ResBar(teamID)
  local returnFrames = frames:New("rows", {
    frames:New("cols", {
      bar:New({}),
      border:New(
        color:New(Colors.green)
      )
    }, { -8, 8}),
    frames:New("cols", {
      bar:New({ color = Colors.yellow }),
      border:New(
        color:New(Colors.green)
      )
    }, { -8, 8})
  })
  if not iAmSpec and teamID ~= Spring.GetMyTeamID() then
    returnFrames[1][1]:AddCommand(command:New({
      OnRelease = function(self, x)
        local omlev, _, _, _, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "metal")
        Spring.ShareResources(teamID, "metal", math.floor(x*omlev+0.5))
      end,
      GetDescription = function(self, x)
        local omlev, _, _, _, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "metal")
        return "give "..TeamName(teamID).." "..YellowStr..math.floor(x*omlev+0.5)..WhiteStr.." metal"
      end
    }))
    returnFrames[2][1]:AddCommand(command:New({
      OnRelease = function(self, x)
        local oelev, _, _, _, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "energy")
        Spring.ShareResources(teamID, "energy", math.floor(x*oelev+0.5))
      end,
      GetDescription = function(self, x)
        local oelev, _, _, _, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "energy")
        return "give "..TeamName(teamID).." "..YellowStr..math.floor(x*oelev+0.5)..WhiteStr.." energy"
      end
    }))
  end
  returnFrames.updateEvery = 50
  function returnFrames:Update()
    local omlev, omstr, ompul, ominc, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "metal")
    local mlev, mstr, mpul, minc, _, _, _, _ = Spring.GetTeamResources(teamID, "metal")
    if minc then
      local rCol = math.min(math.max(2-((minc-mpul)/ominc+2)/2,0),1)
      local gCol = math.min(math.max(((minc-mpul)/ominc+2)/2,0),1)
      self[1][1]:SetValue(mlev/mstr)
      self[1][1].tooltip = TeamName(teamID).." currently has "..YellowStr..math.floor(mlev)..WhiteStr.." metal"..
                           " and can store "..YellowStr..math.floor(mstr).."."
      self[1][2].tooltip = TeamName(teamID).."s income is "..GreenStr..math.floor(minc)..WhiteStr..
                           " and his/her pull is "..RedStr..math.floor(mpul)..WhiteStr.." metal."
      self[1][2][1].color = { rCol, gCol, 0.0, 1.0 }
      local oelev, oestr, oepul, oeinc, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "energy")
      local elev, estr, epul, einc, _, _, _, _ = Spring.GetTeamResources(teamID, "energy")
      local rCol = math.min(math.max(2-((einc-epul)/oeinc+2)/2,0),1)
      local gCol = math.min(math.max(((einc-epul)/oeinc+2)/2,0),1)
      self[2][1]:SetValue(elev/estr)
      self[2][1].tooltip = TeamName(teamID).." currently has "..YellowStr..math.floor(elev)..WhiteStr.." energy"..
                           " and can store "..YellowStr..math.floor(estr).."."
      self[2][2].tooltip = TeamName(teamID).."s income is "..GreenStr..math.floor(einc)..WhiteStr..
                           " and his/her pull is "..RedStr..math.floor(epul)..WhiteStr.." energy."
      self[2][2][1].color = { rCol, gCol, 0.0, 1.0 }
    end
  end
  return returnFrames
end
local function MetalStats(teamID)
  return NewNumberRow(teamID, function(self)
    local _, _, mpul, minc, _, _, _, _ = Spring.GetTeamResources(teamID, "metal")
    self[1]:SetNumber(minc or 0)
    self[2]:SetNumber(-(mpul or 0))
  end)
end
local function EnergyStats(teamID)
  return NewNumberRow(teamID, function(self)
    local _, _, epul, einc, _, _, _, _ = Spring.GetTeamResources(teamID, "energy")
    self[1]:SetNumber(einc or 0)
    self[2]:SetNumber(-(epul or 0))
  end)
end
local function KillsLosses(teamID)
  return NewTextRow(teamID, function(self)
    local killed, died, _, _, _, _ = Spring.GetTeamUnitStats(teamID)
    self[1]:SetText(killed or 0)
    self[2]:SetText(died or 0)
  end)
end
local function Ping(teamID)
  return NewTextRow(teamID, function(self)
    local _, _, _, _, _, pingTime, cpuUsage = Spring.GetPlayerInfo(teamID)
    local pingReal = math.floor(((pingTime-1)*1000)/30)
    local cpuReal = math.floor((cpuUsage or 0)*100)
    self[1]:SetText(pingColor .. pingReal)
    self[2]:SetText(cpuReal.."%")
  end)
end
local function CPU(teamID)
  return NewTextRow(teamID, function(self)
    local rawPlayerList = Spring.GetPlayerList(teamID)
    local playerList = {}
    for i,v in ipairs(rawPlayerList) do
      local _, isActive, isSpec = Spring.GetPlayerInfo(v)
      if not isSpec and isActive then
        table.insert(playerList, v)
      end
    end
    if #playerList ~= 1 then
      self[1]:SetText(#playerList)
      self[2]:SetText("players")
    else
      local _, _, _, _, _, pingTime, cpuUsage = Spring.GetPlayerInfo(playerList[1])

      local realPing = math.floor((pingTime or 0)*1000+.5)
      local pingColor = GreenStr
      pingColor = (realPing > 700) and YellowStr or pingColor
      pingColor = (realPing > 1500) and RedStr or pingColor

      local realCPU = math.floor((cpuUsage or 0)*100+.5)
      local cpuColor = GreenStr
      cpuColor = (realCPU > 30) and YellowStr or cpuColor
      cpuColor = (realCPU > 45) and RedStr or cpuColor

      self[1]:SetText(pingColor .. realPing)
      self[2]:SetText(cpuColor .. realCPU .. "%")
    end
  end)
end
local function Names(teamID)
  return text:New({ text = TeamName(teamID) })
end

local function NewRow(teamID, contentFunction)
  local returnContent = margin:New(
    contentFunction(teamID)
  )
  returnContent.teamID = teamID
  return returnContent
end
local function NewContent(contentFunction)
  local contentTable = {}
  for i,v in ipairs(teamTable) do
    table.insert(contentTable, NewRow(v, contentFunction))
  end
  local returnFrames = frames:New("rows", contentTable)
  return returnFrames
end
local function LogoColumn()
  local contentTable = {empty:New()}
  local heightsTable = {20}
  for _,teamID in ipairs(teamTable) do
    table.insert(contentTable, margin:New(teamLogo:New(teamID)))
    table.insert(heightsTable, 18)
  end
  local returnFrames = frames:New("rows", contentTable, heightsTable)
  local i=1
  for _,teamID in ipairs(teamTable) do
    local teamID = teamID
    i=i+1
    if iAmSpec then
      returnFrames[i][1]:AddCommand(command:New({
        desc = "spec "..TeamName(teamID),
        OnRelease = function()
          Spring.SendCommands({"specteam "..teamID})
        end
      }))
    elseif teamID ~= Spring.GetMyTeamID() then
      returnFrames[i][1]:AddCommand(command:New({
        requiresWidget = "ShareUnits",
        desc = "give selected units to "..TeamName(teamID),
        OnRelease = function()
          Spring.SendCommands({"luaui shareunits "..teamID})
        end
      }))
      returnFrames[i][1]:AddCommand(command:New({
        button = 3,
        desc = "ally/unally with "..TeamName(teamID),
        OnRelease = function()
          Spring.SendCommands({"ally "..teamID})
        end
      }))
    end
    returnFrames[i][1]:AddCommand(command:New({
      button = 2,
      desc = "go to "..TeamName(teamID).."s commander",
      OnRelease = function()
        local units = Spring.GetTeamUnits(teamID)
        if units then
          for _,v in ipairs(units) do
            local unitDefID = Spring.GetUnitDefID(v)
            if UnitDefs[unitDefID].isCommander then
              Spring.SetCameraTarget(Spring.GetUnitPosition(v))
              return true
            end
          end
        end
        Spring.Echo("No Commander found!")
      end
    }))
  end
  return returnFrames
end

local height = 2 + 20 + 18*#teamTable
local playerInfo = window:New(
  "Player Info",
  frames:New("cols", {
    LogoColumn(),
    tabs:New({
      NewContent(ResBar),
      NewContent(MetalStats),
      NewContent(EnergyStats),
      NewContent(KillsLosses),
      --NewContent(Ping),
      NewContent(CPU),
      NewContent(Names)
    }, { "Resource Bars", "Metal Stats", "Energy Stats", "Kills & Losses", "Ping & CPU", "Names" })
  }, { 19, -19 }),
  { 128/1024, height }, { -129/1024, 25/768 }
)

function playerInfo:Initialize()
  if Spring.GetGameFrame() == 0 then
    self[1][2]:ActivateTab(5)
  end
  local savedSize = profileManager:LoadValue('Window Settings', { 'Player Info' }, 'size') or {128/1024, 0}
  playerInfo:ResizeTo(savedSize[1], height)
end

function playerInfo:Update()
  if Spring.GetGameFrame() > 0 then
    self[1][2]:ActivateTab(1)
    windowManager:RemoveCallin(self, "Update")
    self.Update = nil
  end
end

playerInfo:ResizesItself(false, true)
