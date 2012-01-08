local volume = bar:New({})
local label = text:New{
  text = "Volume: Unknown",
  align = "center"
}

function volume:Initialize()
  local volume = Spring.GetConfigInt("snd_volmaster", 60)
  volume = volume * 0.01
  self:SetValue(volume)
  label:SetText("Volume: " .. string.format("%i%%", 100 * volume))
end

volume:AddCommand(command:New{
  drag = true,
  desc = "change the volume",
  OnDrag = function(self, x)
    self.owner:SetValue(x)
    Spring.SendCommands({"set snd_volmaster " .. x*100})
    label:SetText("Volume: " .. string.format("%i%%", 100 * x))
  end
})

window:New(
  "Volume Slider",
  layers:New{
    volume,
    label
  },
  {0.109375, 0.028750000521541}, {0.84140622615814, 0.97000002861023}
)
