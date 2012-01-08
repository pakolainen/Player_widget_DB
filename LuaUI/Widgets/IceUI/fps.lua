local label = text:New{
  text = "FPS unknown",
  align = "center"
}

label.updateEvery = 30
function label:Update()
  self:SetText(Spring.GetFPS())
end

local fps = window:New(
  "FPS",
  label,
  {0.047656249254942, 0.028750000521541}, {0.95156252384186, 0.94249999523163}
)
fps.tooltip = "This is the number of frames per second Spring renders."
fps:AddCommand(command:New({
  button = 2,
  desc   = "reload IceUI",
  OnPress = function()
    widgetHandler:ToggleWidget("IceUI")
    widgetHandler:ToggleWidget("IceUI")
  end
}))
