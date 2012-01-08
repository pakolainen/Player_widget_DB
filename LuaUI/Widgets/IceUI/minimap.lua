local minimap = window:New(
  "Minimap",
  minimap:New({}),
  {146/1024, 146/768}, {1, 1}
)

function minimap:ViewResize()
  self[1]:OnResize()
end

minimap:SetClickthrough(true)
