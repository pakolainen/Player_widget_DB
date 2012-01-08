local camera = window:New(
  "Camera",
  frames:New("rows", {
    texture:New({
      filename = "camera.png",
      innerW = 32,
      innerH = 32
    }),
    text:New({
      text = "TA",
      align = "center"
    })
  }, { 32/47, -32/47 }),
  { 34/1024, 49/768 }, {148/1024, 1}
)

camera.curCamera  = 1
camera.cameraCmds = {"viewta", "viewfps", "viewtw", "viewrot", "viewfree"}
camera.cameraStrs = {"TA", "FPS", "TW", "ROT", "FREE"}

camera:AddCommand(command:New({
  desc = "cycle through game cameras",
  OnRelease = function(self)
    self.owner.curCamera = self.owner.curCamera % #self.owner.cameraCmds + 1
    self.owner[1][2]:SetText(self.owner.cameraStrs[self.owner.curCamera])
    Spring.SendCommands({self.owner.cameraCmds[self.owner.curCamera]})
  end
}))
