include("spring.h.lua")
include("opengl.h.lua")

local camerastack, cameraIndex, lastCameraIndex, returnSpeed
local windowX, windowY, windowMoving
local cam1,cam2,cam3,backcam
function widget:GetInfo()
  return {
    name      = "CycleCamera2",
    desc      = "Save and Cycle through Camera positions",
    author    = "gunblob, modified by Beherith to suit his needs",
    date      = "dec 30, 2007",
    license   = "Free",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end

function widget:Initialize()
  camerastack = {}
  cameraIndex = -1
  lastCameraIndex = -1
  returnSpeed = 0.3
  windowX = Spring.GetConfigInt("CycleCameraWindowX", 200)
  windowY = Spring.GetConfigInt("CycleCameraWindowY", 200)
  windowMoving = false
end

function widget:Shutdown()
  Spring.SetConfigInt("CycleCameraWindowX", windowX)
  Spring.SetConfigInt("CycleCameraWindowY", windowY)
end

function SaveCamera()
  cameraIndex = cameraIndex + 1
  local camerastate = Spring.GetCameraState()
  table.insert(camerastack, cameraIndex, camerastate)
  lastCameraIndex = lastCameraIndex + 1
end

function DeleteCamera()
  if cameraIndex >= 0 then
    table.remove(camerastack, cameraIndex)
    lastCameraIndex = lastCameraIndex - 1
    if cameraIndex > lastCameraIndex then
      cameraIndex = cameraIndex - 1
    end
  end
end

function PrevCamera()
  if TryCamera(cameraIndex - 1) then
    cameraIndex = cameraIndex - 1
  elseif TryCamera(lastCameraIndex) then
    cameraIndex = lastCameraIndex
  end
end

function NextCamera()
  if TryCamera(cameraIndex + 1) then
    cameraIndex = cameraIndex + 1
  elseif TryCamera(0) then
    cameraIndex = 0
  end
end

function CurrentCamera()
  TryCamera(cameraIndex)
end

function FirstCamera(button)
	if button==3 then
		cam1=Spring.GetCameraState()
	elseif cam1 then
		backcam=Spring.GetCameraState()
		Spring.SetCameraState(cam1, returnSpeed)
	end	 	
end

function SecondCamera(button)
	if button==3 then
		cam2=Spring.GetCameraState()
	elseif cam2 then
		backcam=Spring.GetCameraState()
		Spring.SetCameraState(cam2, returnSpeed)
	end	 	
end

function ThirdCamera(button)
	if button==3 then
		cam3=Spring.GetCameraState()
	elseif cam3 then
		backcam=Spring.GetCameraState()
		Spring.SetCameraState(cam3, returnSpeed)
	end	 	
end


function BackCamera()
	if backcam then
		Spring.SetCameraState(backcam, returnSpeed)
	end
		
end


function widget:TextCommand(command)
  --Echo(command)
  if command == "savecamera" then
    SaveCamera()
  elseif command == "deletecamera" then
    DeleteCamera()
  elseif command == "nextcamera" then
    NextCamera()
  elseif command == "currentcamera" then
    CurrentCamera()
  elseif command == "prevcamera" then
    PrevCamera()
  elseif command == "savefirstcamera" then
    FirstCamera(3)
  elseif command == "loadfirstcamera" then
    FirstCamera(0)
  elseif command == "savesecondcamera" then
    SecondCamera(3)
  elseif command == "loadsecondcamera" then
    SecondCamera(0)
  elseif command == "savethirdcamera" then
    ThirdCamera(3)
  elseif command == "loadthirdcamera" then
    ThirdCamera(0)
  elseif command == "backcamera" then
    BackCamera(0)
  end
end

function TryCamera(index)
  local cameraState = camerastack[index]
  if cameraState then
	backcam=Spring.GetCameraState()
    Spring.SetCameraState(cameraState, returnSpeed)
    return true
  end
  return false
end

local buttonBoxes = {}

function addButton(button)
  table.insert(buttonBoxes, button)
end

function inBox(button, x, y, mouseButton)
  if x > windowX + button.x and x < windowX + button.x + button.width and
    y > windowY + button.y and y < windowY + button.y + button.height then
    return true
  end
  return false
end

function DrawButton(button)
  gl.Color(button.colour[1],button.colour[2],button.colour[3],button.colour[4])
  gl.Shape(GL.QUADS, {
    {v = {windowX + button.x, windowY + button.y}},
    {v = {windowX + button.x, windowY + button.y + button.height}},
    {v = {windowX + button.x + button.width, windowY + button.y + button.height}},
    {v = {windowX + button.x + button.width, windowY + button.y}}
  })
end


--drag bar
addButton{x = 0, y = 80, width = 100, height = 20, 
    MousePress = function (x, y, button)
      windowMoving = true
    end,
    colour = {0.0, 0.3, 0.8, 0.5}}

--save button
addButton{x = 0, y = 60, width = 50, height = 20, 
    MousePress = function (x, y, button)
      SaveCamera()
    end,
    colour = {0.7, 0.9, 0.7, 0.5}}

--delete button
addButton{x = 50, y = 60, width = 50, height = 20, 
    MousePress = function (x, y, button)
      DeleteCamera()
    end,
    colour = {0.5, 0.2, 0.2, 0.5}}

--prev button
addButton{x = 0, y = 40, width = 33, height = 20, 
    MousePress = function (x, y, button)
      PrevCamera()
    end,
    colour = {0.5, 0.3, 0.3, 0.5}}

--current button
addButton{x = 33, y = 40, width = 33, height = 20, 
    MousePress = function (x, y, button)
      CurrentCamera()
    end,
    colour = {0.3, 0.5, 0.3, 0.5}}

--next button
addButton{x = 66, y = 40, width = 34, height = 20, 
    MousePress = function (x, y, button)
      NextCamera()
    end,
    colour = {0.3, 0.3, 0.5, 0.5}}

--first cam
addButton{x = 0, y = 20, width = 33, height = 20, 
    MousePress = function (x, y, button)
		FirstCamera(button)
    end,
    colour = {0.5, 0.5, 0.3, 0.5}}

--second cam
addButton{x = 33, y = 20, width = 33, height = 20, 
    MousePress = function (x, y, button)
		SecondCamera(button)
    end,
    colour = {0.3, 0.5, 0.5, 0.5}}

--third cam
addButton{x = 66, y = 20, width = 34, height = 20, 
    MousePress = function (x, y, button)
		ThirdCamera(button)

    end,
    colour = {0.5, 0.3, 0.5, 0.5}}


--back button
addButton{x = 25, y = 0, width = 50, height = 20, 
    MousePress = function (x, y, button)
		BackCamera()
		
    end,
    colour = {0.2, 0.2, 0.2, 0.5}}





function widget:MousePress(x, y, button)
  for _, box in ipairs(buttonBoxes) do
    if inBox(box, x, y, button) then
      box.MousePress(x, y, button)
      return true
    end
  end
  return false
end

function widget:MouseRelease(x, y, button)
  windowMoving = false
  return -1
end

function widget:MouseMove(x, y, dx, dy, button)
  if windowMoving then
    windowX = windowX + dx
    windowY = windowY + dy
  end
  return false
end


function widget:DrawScreen()
  for _, button in ipairs(buttonBoxes) do
    DrawButton(button)
  end

  gl.Color(0.0, 0.0, 0.0, 1.0)
  gl.Text("CycleCamera " .. cameraIndex + 1 .. "/" .. lastCameraIndex + 1,
    windowX + 5, windowY + 85, 10, "t")

 	gl.Text("Del",windowX + 62, windowY + 60, 16, "t") --draw the other stuff too
	gl.Text("Save",windowX + 5, windowY + 60, 16, "t")
	gl.Text("<<<",windowX + 1, windowY + 40, 16, "t")
	gl.Text("[ ]",windowX + 40, windowY + 40, 16, "t")
	gl.Text(">>>",windowX + 68, windowY + 40, 16, "t")

	gl.Text("1",windowX + 12, windowY + 20, 16, "t")
	gl.Text("2",windowX + 45, windowY + 20, 16, "t")
	gl.Text("3",windowX + 78, windowY + 20, 16, "t")

	gl.Text("Back",windowX + 30, windowY + 0, 16, "t")
end

function Echo(message)
  Spring.SendCommands({"echo " .. message})
end

