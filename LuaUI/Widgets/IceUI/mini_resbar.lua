local resbar = window:New(
  "Mini Resources",
  frames:New("rows", {
    text:New({
      text = "Resources"
    }),
    frames:New("cols", {
      margin:New(
        bar:New({
          help = "This bar shows your current metal level.\nIt is updated every 20 frames."
        }), {.1,.2,.1,.2}
      ),
      number:New({})
    }, {0.8, 0.2}),
    frames:New("cols", {
      margin:New(
        bar:New({
          help = "This bar shows your current energy level.\nIt is updated every 20 frames.",
          color = Colors.yellow
        }), {.1,.2,.1,.2}
      ),
      number:New({})
    }, {0.8, 0.2})
  }, {0.4, 0.3, 0.3}),
  {200/1024, 60/768}, {549, 1}
)
resbar.updateEvery = 20
function resbar:Update()
  local mlev, mstr, mpul, minc, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "metal")
  self[1][2][1][1]:SetValue(mlev/mstr)
  self[1][2][1][1].tooltip = "You currently have "..math.floor(mlev).." metal."
  self[1][2][2]:SetNumber(minc-mpul)
  self[1][2][2].tooltip = "Your income is "..GreenStr..math.floor(minc)..WhiteStr..
                                " and your pull is "..RedStr..math.floor(mpul)..WhiteStr.." metal."
  local elev, estr, epul, einc, _, _, _, _ = Spring.GetTeamResources(Spring.GetMyTeamID(), "energy")
  self[1][3][1][1]:SetValue(elev/estr)
  self[1][3][1][1].tooltip = "You currently have "..math.floor(elev).." energy."
  self[1][3][2]:SetNumber(einc-epul)
  self[1][3][2].tooltip = "Your income is "..GreenStr..math.floor(einc)..WhiteStr..
                          " and your pull is "..RedStr..math.floor(epul)..WhiteStr.." energy."
end
resbar[1][2][1][1]:AddCommand(command:New({
  drag = true,
  OnDrag = function(self, x, _)
    _, active, spec, _, _, _, _ = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
    if active and not spec then
      Spring.SetShareLevel("metal", x)
    end
  end,
  GetDescription = function(_, x, _)
    return "set metal share level to "..math.floor(x*100+0.5).."%"
  end
}))  
resbar[1][3][1][1]:AddCommand(command:New({
  drag = true,
  OnDrag = function(self, x, _)
    _, active, spec, _, _, _, _ = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
    if active and not spec then
      Spring.SetShareLevel("energy", x)
    end
  end,
  GetDescription = function(_, x, _)
    return "set energy share level to "..math.floor(x*100+0.5).."%"
  end
}))  
