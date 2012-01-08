
function widget:GetInfo()
  return {
    name      = "Wind Helper",
	version   = "0.95",
    desc      = "Shows wind info and when to build wind\nThe next wind vector turning point displays the immediate wind forecast\nForecast text tells the forecast from integrated winds\n(current economy and wind mean affects what to build but not the forecasts)",
    author    = "Pako",
    date      = "18.09.2009",
    license   = "GNU GPL, v2 or later",
    layer     = 1,
    enabled   = true  --  loaded by default?
  }
end

local WhiteStr   = "\255\255\255\255"
local GreyStr    = "\255\210\210\210"
local GreenStr   = "\255\092\255\092"
local BlueStr    = "\255\170\170\255" 
local YellowStr  = "\255\255\255\152"
local OrangeStr  = "\255\255\190\128"
local RedStr     = "\255\255\70\56"

local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end


local averageS=0
local paverageS
local averageW=0
local firstn=0
local windS=0

local avgWind

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function windColor(windisgood)
if windisgood > 20 then
		return GreenStr
	elseif windisgood > 11 then
		return YellowStr
	elseif windisgood > 5 then
		return OrangeStr
	else
      return RedStr
	end
end

local circleDivs = 16
local circleList

local averageSmin

local windowX  
local 	windowY  
local 	windowMoving 
local resizeWindow 
local windowW = 150
local windowH = 80

function widget:Shutdown()
  Spring.SetConfigInt("WindHelperWindowX", windowX)
  Spring.SetConfigInt("WindHelperWindowY", windowY)
  Spring.SetConfigInt("WindHelperWindowH", windowH)
  Spring.SetConfigInt("WindHelperWindowW", windowW)
end

function widget:Initialize()

	windowX = Spring.GetConfigInt("WindHelperWindowX", 200)
	windowY = Spring.GetConfigInt("WindHelperWindowY", 200)
	windowW = Spring.GetConfigInt("WindHelperWindowW", 150)
	windowH = Spring.GetConfigInt("WindHelperWindowH", 80)
	windowMoving = false

circleList = gl.CreateList(function()
    --[[glBeginEnd(GL_TRIANGLE_FAN, function()
		gl.Color(0.7,0.7,0.7,0.5)
      for i = 0, circleDivs - 1 do
        local r = 2.0 * math.pi * (i / circleDivs)
        local cosv = math.cos(r)
        local sinv = math.sin(r)
       -- glTexCoord(cosv, sinv)
        glVertex(cosv, sinv)
      end
    end)--]]
    if (true) then
      gl.BeginEnd(GL.LINE_LOOP, function()
        for i = 0, circleDivs - 1 do
          local r = 2.0 * math.pi * (i / circleDivs)
          local cosv = math.cos(r)
          local sinv = math.sin(r)
          --gl.TexCoord(cosv, sinv)
          gl.Vertex(cosv, sinv)
        end
      end)
    end
  end)
  

	local Minwind = Game.windMin
	local Maxwind = Game.windMax
	
	local windisgood =round((Maxwind + Minwind)*0.4)
	
	local colorStr = windColor(windisgood*2)
	
	avgWind = colorStr.."Wind mean: " .. windisgood.." ± ".. (Maxwind - Minwind)/2
	
	averageSmin = (Maxwind + Minwind)*0.4
	
end


local function inBox(x, y)
  if x > windowX and x < windowX + windowW and
    y < windowY and y > windowY - windowH then
	
	if x > windowX+windowW-16 and
    y > windowY-14 then
	widgetHandler:RemoveWidget(widget)
	return false
	end
	
	if x > windowX+windowW-12 and y < windowY-windowH+12 then
	return 1
	else
	return 2
	end
  end
  return false
end

function widget:MousePress(x, y, button)
    if button == 1 and inBox(x, y) then
	 if inBox(x,y) == 2 then 
		windowMoving = true
	else
	   resizeWindow = true
	end
		return true
	end
  return false
end

function widget:MouseRelease(x, y, button)
  windowMoving = false
  resizeWindow = false
end

function widget:MouseMove(x, y, dx, dy, button)
  if windowMoving then
    windowX = windowX + dx
    windowY = windowY + dy
  elseif resizeWindow then
	windowW = x - windowX
	windowH = windowY - y
  end
  return false
end

local color = {0.8,0.3}
function widget:MouseWheel(up,value)
local x,y = Spring.GetMouseState()
if inBox(x, y)==1 then
	if up then
		color[1] = (color[1] + 0.1)%1
	else
		color[2] = (color[2] + 0.1)%1
	end
	return true
end
end

local prevWindDir
local prevWindVec
local changeVec
local nextWindDir

function widget:GameFrame(n)
if firstn==0 then
firstn=n
local dirX,  dirY,  dirZ = Spring.GetWind() 
prevWindDir = {dirX,  dirY,  dirZ}
prevWindVec = {dirX,  dirY,  dirZ}
end
	local dirX,  dirY,  dirZ,  strength,  normDirX, normDirY, normDirZ = Spring.GetWind() 
	windS = strength
	averageS=averageS+strength
	averageSmin = (averageSmin*(60*30)+strength)/(60*30+1)

	local cVec = {prevWindVec[1]-dirX, prevWindVec[2]-dirY, prevWindVec[3]-dirZ} 
	if (not changeVec) or math.abs(cVec[1] + cVec[2] + cVec[3]-changeVec[1]-changeVec[3])>0.001 then --when wind is changing direction calculate the next turn point
		prevWindDir = {dirX,  dirY,  dirZ}
		changeVec = cVec
		nextWindDir = {-cVec[1]*900+prevWindDir[1], cVec[2]*900+prevWindDir[2], -cVec[3]*900+prevWindDir[3]}
	end
	
	prevWindVec = {dirX,  dirY,  dirZ}
	
end

local timeCounter = 0
local windisgood = 0
local colorStr
local wind = " "


function widget:Update(deltaTime)
	timeCounter = timeCounter+deltaTime
  if (timeCounter < 1) then return end
    timeCounter = 0
	
	local Minwind = Game.windMin
	local Maxwind = Game.windMax
	
	local windisgood =round((Maxwind + Minwind)*0.4)
	
	local curColorStr = windColor(windS)
	
	local eCur, eMax, pullE, incomeE, expenseE, shareE, sentE, receivedE = Spring.GetTeamResources(Spring.GetMyTeamID(), "energy")
    local mCur, mMax, pullM, mInc, expenseM, shareM, sentM, receivedM  = Spring.GetTeamResources(Spring.GetMyTeamID(), "metal")
    local ePercent = (eCur / eMax)
	
	local goodMetal, goodEnergy, stalling
	
	if (ePercent < 0.3) and (pullE > incomeE) then
      stalling = true
      goodEnergy = false
    elseif (ePercent > 0.5) or (eCur >= 500) then
      stalling = false
      if (ePercent > 0.9) and ((eMax - eCur) < 250) then
        goodEnergy = true
      else
        goodEnergy = false
      end
    end
	
    if ( mCur > 50 and pullM < mInc*3) then goodMetal = true else goodMetal = false end
	
	local buildWind = (Maxwind + Minwind)*0.4 - 7.5
	local buildSolar = 0
	local buildAdvSolar = 0
	
	if stalling == true or incomeE < 100 then buildAdvSolar = -5 end
	if stalling then buildSolar = 2 end
	if goodEnergy then
		buildAdvSolar = buildAdvSolar+2
	end
	if goodMetal then
		buildSolar = buildSolar+1
		buildAdvSolar = buildAdvSolar+3
	else
		buildWind = buildWind + 2
	end
	if mInc > 20 then buildAdvSolar = buildAdvSolar+3 end
	
	local buildStr
	
	if mInc < 30 or incomeE < 1500 then
	if buildWind > buildSolar and buildWind > buildAdvSolar then
		buildStr = GreenStr.."\nBuild wind"
	elseif buildSolar > buildAdvSolar then
		buildStr = GreyStr.."\nBuild solar"
	else
		buildStr = BlueStr.."\nBuild adv. solar"
	end
	else
	buildStr = ""
	end
	  
	local n = Spring.GetGameFrame()
	
	local foreCast = OrangeStr.."Average wind"
	local intAvg = averageS/(n-firstn)
	local winds = intAvg / ((Maxwind + Minwind)*0.4)
	if winds < 0.9 then
		
		foreCast = YellowStr.."Above average winds"
		
		if averageSmin < (Maxwind + Minwind)*0.4*0.8 then
			foreCast = GreenStr.."Good wind soon"
		end
	elseif winds > 1.15 then
		foreCast = RedStr.."Below average wind"
	end
	if windowH < 40 then
		wind = (curColorStr.."Current wind: "..round(windS)..buildStr)
	else
    wind = ( avgWind..buildStr..curColorStr.."\nCurrent wind: "..round(windS)..((paverageS and (WhiteStr.."\nIntegrated wind average is: "..intAvg)) or "").."\n\255\255\255\255ForeCast:\n"..foreCast)
	end
end

local Minwind = Game.windMin
local Maxwind = Game.windMax


local glScale = gl.Scale
local glVertex = gl.Vertex
local glColor = gl.Color

function widget:DrawScreen()
local glScale = glScale
local glVertex = glVertex
local glColor = glColor

gl.PushMatrix()
gl.Translate(windowX,windowY,0) 

 local r,g,b,a,inc,inc2 = 0.2,color[1],color[2],0.2,0.3, 0.6
  if windowMoving then
	a = 1
  end

  local x,y,reuna = 0, 0-windowH, 5

 gl.Shape(GL.TRIANGLE_STRIP, {
    {v = {x, y},c = {r,g,b,a}},
    {v = {x + windowW, y}, c = {r+inc,g+inc,b+inc,a}},
	{v = {x, y + windowH}},
	{v = {x + windowW, y + windowH}, c = {r+inc2,g+inc2,b+inc2,a-inc2}},
	
	{v = {x+windowW-reuna, y+windowH-reuna}, c = {0,0,0,1}},
	{v = {x+reuna, y + windowH-reuna}, c = {r+inc,g+inc,b+inc,a}},
	{v = {x + windowW-reuna, y + windowH-reuna},c = {r,g,b,a-inc2}},
	{v = {x+reuna, y+reuna}, c = {r+inc2,g+inc2,b+inc2,a}},
    {v = {x + windowW-reuna, y+reuna}, c = {r+inc,g+inc,b+inc,a}},
	
  })
glColor(1,1,1,0.88)
if windowH > 40 then
gl.Texture('LuaUI/Images/x.png')
gl.TexRect(x + windowW-16,y + windowH-14,x + windowW,y + windowH)
end
gl.Texture('LuaUI/Images/r.png')
gl.TexRect(x + windowW-12,y,x + windowW,y + 12)
gl.Texture(false)
local textSize = windowH/6
if windowH < 40 then
	textSize = windowH/3
end
   gl.Text(wind, textSize/2, -textSize/2, textSize, "ao")
   if nextWindDir and windowH > 40 then
   glColor(1,1,1,0.7)
   gl.Translate(windowW+windowH/2,-windowH/2,0)
   local edgOf = -200
   local scale = windowH/Maxwind/2
   glScale(scale,scale,1)
 glScale(Minwind,Minwind,1)
 gl.CallList(circleList)
 glScale(1/Minwind,1/Minwind,1)
 glScale(Maxwind,Maxwind,1)
 gl.CallList(circleList)
 glScale(1/Maxwind,1/Maxwind,1)
 glColor(0.1,0.9,0.2,0.8)
 local curX, curZ = prevWindVec[1], prevWindVec[3]
   gl.BeginEnd(GL.LINES, function()
		 glVertex(nextWindDir[1]+1, nextWindDir[3]+1,0)
		 glVertex(nextWindDir[1]-1, nextWindDir[3]-1,0)
		 glVertex(nextWindDir[1]+1, nextWindDir[3]-1,0)
		 glVertex(nextWindDir[1]-1, nextWindDir[3]+1,0)
		 glColor(0.1,0.5,0.1,0.9)
		 glVertex(0,0,0)
		 glVertex(curX,curZ,0)

		 local n = curX*curZ
		 n = n<0 and -1 or 1
		 glVertex(curX, curZ,0)
		 glVertex((curX+n*curZ)*0.4,(curZ-n*curX)*0.4)
		 
		 glVertex(curX, curZ,0)
		 glVertex((curX-n*curZ)*0.4,(curZ+n*curX)*0.4)
		 
		 
   end
   )
   
   end
   gl.PopMatrix()
end
	