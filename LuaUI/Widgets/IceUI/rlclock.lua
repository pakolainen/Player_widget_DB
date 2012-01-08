local label = text:New{
  text = "OS Time unknown",
  align = "center"
}

label.updateEvery = 30
function label:Update()
  local prefix = self:GetWindow():Option("displayPrefix") and "Time: " or ""
  local format = self:GetWindow():Option("displaySeconds") and "%H:%M:%S" or "%H:%M"
  self:SetText(prefix .. os.date(format))
end

local clock = window:New(
  "OS Clock",
  label,
  {0.047656249254942, 0.028750000521541}, {0.95156252384186, 0.94249999523163}
)
clock.tooltip = "This shows the actual time coming from your computer."

clock:AddOption(option:New({
  name = "displaySeconds",
  value = false,
  description = "Display seconds."
}))
clock:AddOption(option:New({
  name = "displayPrefix",
  value = false,
  description = "Display 'Time: ' in front of the time."
}))
