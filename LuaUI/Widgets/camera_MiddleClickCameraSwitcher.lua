function widget:GetInfo()
   return {
      name      = "MiddleClickCameraSwitcher",
      desc      = "^^^^^^^^^^^^^^^^^^^^^^^^^",
      author    = "Auswaschbar",
      version   = "v1.0",
      date      = "Dec, 2009",
      license   = "GNU GPL, v3 or later",
      layer     = 9000,
      enabled   = true,
   }
end

-- FPSController          // 0
-- OverheadController     // 1
-- TWController           // 2
-- RotOverheadController  // 3
-- FreeController         // 4
-- SmoothController       // 5
-- OrbitController        // 6
-- OverviewController     // 7
   
function widget:MousePress(mx, my, button)
   local alt,ctrl,meta,shift = Spring.GetModKeyState()
   if (button == 2 and (shift or ctrl)) then
      local oldcamstate = Spring.GetCameraState()
      local newcamstate =
      {
         mode = (oldcamstate.mode + 1) % 6, -- exclude overview and orbit
         px = oldcamstate.px,
         py = oldcamstate.py,
         pz = oldcamstate.pz,
      }
      Spring.SetCameraState(newcamstate, 1)
      return true
   end
   return false
end 