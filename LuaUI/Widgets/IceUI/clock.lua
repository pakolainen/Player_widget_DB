-- function GetTimeString() taken from trepans clock widget
local function GetTimeString()
  local secs = math.floor(Spring.GetGameSeconds())
  if (timeSecs ~= secs) then
    timeSecs = secs
    local h = math.floor(secs / 3600)
    local m = math.floor((secs % 3600) / 60)
    local s = math.floor(secs % 60)
    if (h > 0) then
      timeString = string.format('%02i:%02i:%02i', h, m, s)
    else
      timeString = string.format('%02i:%02i', m, s)
    end
  end
  return timeString
end

local label = text:New{
  text = "Time unknown",
  align = "center"
}

label.updateEvery = 30
function label:Update()
  self:SetText(GetTimeString())
end

local clock = window:New(
  "Clock",
  label,
  {0.047656249254942, 0.028750000521541}, {0.95156252384186, 0.97000002861023}
)
clock.tooltip = "This is the time you spent in this game. It depends on the gamespeed."
