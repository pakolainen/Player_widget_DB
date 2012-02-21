--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Last Msg Pos",
    version   = "0.91",
    desc      = "Enables 'F3' shift traversing backwards, faster than engine camera move",
    author    = "Pako",
    date      = "2010.11.26",
    license   = "GNU GPL, v2 or later",
    layer     = -1,
    enabled   = true
  }
end

function widget:Initialize()
  widgetHandler:AddAction("lastmsgpos", LastMsgPos) --gets called before the engine action
  --could bind Any+F3 to shift to work..but really should be fixed in the bindings...
end

function widget:Shutdown()
  widgetHandler:RemoveAction("lastmsgpos", LastMsgPos)
end

local nCount = 0
local nPoint = 0

function LastMsgPos(cmd, optLine, optWords, _,isRepeat, release)
  if release then return true end
  
  local a,c,m, shift = Spring.GetModKeyState()
  local poss = Spring.GetLastMessagePositions()
  if not poss then return false end
  nCount = #poss
  if shift then
    nPoint = nPoint - 1
  else
    nPoint = nPoint + 1
  end
  nPoint = math.min(nCount, math.max(1, nPoint))
  local x,y,z = unpack(poss[nPoint])
  Spring.SetCameraTarget(x,y,z, 0.4)
  return true
end

function widget:MapDrawCmd(playerID, cmdType)
  if cmdType == "point" then
    nPoint = 0
  end
end