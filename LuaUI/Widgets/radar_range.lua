function widget:GetInfo()
  return {
    name      = "Radar Ranges",
    desc      = "Draws radar ranges on the map when radar units are selected.",
    author    = "AF",
    date      = "28/07/2007",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

function widget:DrawWorldPreUnit()
  local units = Spring.GetSelectedUnits()
  gl.LineWidth(5)
  for _,uid in ipairs(Spring.GetSelectedUnits()) do
--  for _,uid in pairs(units) do
   local udid = Spring.GetUnitDefID(uid)
    local ud = udid and UnitDefs[udid] or nil
    if (ud and (ud.radarRadius > 400)) then
     gl.Color(0.5, 0.5, 1, 0.5)
     local x, y, z = Spring.GetUnitBasePosition(uid)
      if (x) then
        gl.DrawGroundCircle(x, y, z, ud.radarRadius, 128)
      end
   end
   if (ud and (ud.jammerRadius > 200)) then
     gl.Color(1, 0, 0, 0.5)
     local x, y, z = Spring.GetUnitBasePosition(uid)
      if (x) then
        gl.DrawGroundCircle(x, y, z, ud.jammerRadius, 128)
      end
   end
  end
  gl.LineWidth(1)
end