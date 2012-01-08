function widget:GetInfo()
  return {
    name      = "Scout Helper l",
	version   = "Beta 1.6 lite",
    desc      = "Displays a map of LOS where gradient for out of LOS is constantly darkened",
    author    = "Pako",
    date      = "13.09.2009",
    license   = "",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local floor = math.floor
local ceil = math.ceil
local abs = math.abs

local RADAR_PLANES = {}
RADAR_PLANES[UnitDefNames['armawac'].id] = true
RADAR_PLANES[UnitDefNames['armsehak'].id] = true
RADAR_PLANES[UnitDefNames['corawac'].id] = true
RADAR_PLANES[UnitDefNames['corhunt'].id] = true

local RADAR_TOWERS = {}
RADAR_TOWERS[UnitDefNames['armrad'].id] = true 

local radars = {}

local LOSPoints = {}

local areas = {}


local gridSize = 128  --dont change without changing 5 other points
local areaSize = 32		--dont change without changing 5 other points



include("cmdcolors.h.lua")

function widget:Initialize()

----------set engine LOS/radar view on 
	local alwaysColor=cmdColors["alwayscolor"];
	local losColor=cmdColors["loscolor"];
	local radarColor=cmdColors["radarcolor"];
	--local jamColor=cmdColors["jamcolor"]; 
	
	local red = 	{0.4,0.05,0.05,0.05}
	local green = 	{0.4,0.03,0.07,0.0}
	local blue = 	{0.4,0.05,0.05,0.0}
	if alwaysColor and losColor and radarColor and jamColor then		
		red = {alwaysColor[1],losColor[1],radarColor[1],jamColor[1]}
		green = {alwaysColor[2],losColor[2],radarColor[2],jamColor[2]}
		blue = {alwaysColor[3],losColor[3],radarColor[3],jamColor[3]}
	end
	Spring.SetLosViewColors(red,green,blue)
	
	Spring.SendCommands('togglelos 1')
----------

  widgetHandler:AddAction("showScoutLOS", showLOS)
  Spring.SendCommands({"unbind Any+l togglelos"})
  Spring.SendCommands({"bind l luaui showScoutLOS"})
  
  local spec, fullView = Spring.GetSpectatingState()
  
  
  for x=0,ceil(Game.mapSizeX/gridSize) do
  LOSPoints[x] = {}
  for z=0,ceil(Game.mapSizeZ/gridSize) do
		LOSPoints[x][z] = 0.3
	end
	end
	
	local areasX = ceil(Game.mapSizeX/gridSize/areaSize)
	local areasZ = ceil(Game.mapSizeZ/gridSize/areaSize) --should we divide by screen size so that 4 areas usually in screen???
	for x=0, areasX do
		areas[x] = {}
		for z=0, areasZ do
			local mx, mz = (x*areaSize), (z*areaSize)
			local mxe, mze = (mx+areaSize), (mz+areaSize)
			if mxe > Game.mapSizeX/gridSize then
				mxe = Game.mapSizeX/gridSize
			end
			if mze > Game.mapSizeZ/gridSize then
				mze = Game.mapSizeZ/gridSize
			end
			areas[x][z] = {x=mx,z=mz,xe=mxe,ze=mze, updated = 0, viewDrawList = nil, changes=0, inView = false}
	end
	end
end

do
 local state = 0  --0 == LOS&scout LOS, 1 == LOS, 2 == none, 3 == scoutLOS
 function showLOS(cmd, line, words) --TODO print the current mode
   state = (state + 1)
   local lstate = state%4
    if (lstate==0) then
	  Spring.SendCommands({"togglelos"}) 
    elseif lstate == 1 then
		widgetHandler:RemoveCallIn('DrawWorld')
	elseif lstate == 2 then
		 Spring.SendCommands({"togglelos"})
	 elseif lstate == 3 then
		widgetHandler:UpdateCallIn('DrawWorld')
		  if not spec then
			Spring.SendCommands({"specfullview"})
		  end
    end
  end
  --return false
end --//end do



local function sq_distance(x,z,xx,zz)
  return (x-xx)^2 + (z-zz)^2
end


local function DrawLOSViewVertices(LOSPoints,xs,zs,xe,ze,h)

	local Scale = gridSize
	local sggh = Spring.GetGroundHeight
	local Vertex = gl.Vertex
	local glColor = gl.Color
	local sten = {zs, ze, zs}
	
	for x=xs,xe-1,1 do
		local ind = x%2
		for z=sten[ind+1], sten[ind+2], 1+(-ind*2) do
			local i,j = x*Scale, z*Scale
			for ii=0,1 do
				local alc = LOSPoints[x+ii][z]
--[[				if alc < 0 then
				 if alc > -1 then
					glColor(0.03,0.06,alc+0.7,-alc)
				 else
					glColor(0,0.3,0.3,0.2)
				 end
				else
--]]					glColor(0.07,0.07,0.07,alc)
--				end
				Vertex(i,h+sggh(i,j),j)
				i=i+Scale
			end
		end
	end
	
end

local function DrawLOSView(LOSPoints,xs,zs,xe,ze)
	--gl.Blending(false)
	gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA)
	gl.DepthTest(GL.LEQUAL)
	gl.BeginEnd(GL.TRIANGLE_STRIP,DrawLOSViewVertices,LOSPoints,xs,zs,xe,ze, 50)
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA)
end


local function updateArea(area, dt)

local gplos = Spring.GetPositionLosState
local glos = Spring.IsPosInLos
local sggh = Spring.GetGroundHeight
local abs = abs
local gS = gridSize
local gridsX = ceil(Game.mapSizeX/gridSize)
local changes = 1

	for x=area.x, area.xe-1 do
		for z=area.z, area.ze-1 do
				--local _,inLos, inRadar = gplos(x*gridSize,80,z*gridSize)
				local inLos = glos(x*gS,sggh(x*gS, z*gS),z*gS)
				local point = LOSPoints[x][z]
				local jm = -2

				if not inLos then
					jm = 0.01*abs(0.55 - point)*dt + 0.001*dt
				end

				jm = point + jm
				if jm > 0.8 then
					jm = 0.8
				elseif jm < 0 then
					jm = 0
				end
				if abs(point - jm) > 0.1 then
					changes = changes + 1
				end
				LOSPoints[x][z] = jm
		end
	end
	area.changes = changes + area.changes
	if area.changes > 5 then
			area.changes = 0
			gl.DeleteList(area.viewDrawList)
			area.viewDrawList = nil
			area.viewDrawList=gl.CreateList(DrawLOSView, LOSPoints,area.x,area.z,area.xe,area.ze)
	end
end

local function updateWorld()
local gameSec = Spring.GetGameSeconds()
local update = 0
for x=0,#areas do
	for z=0,#areas[x] do
		local dt = gameSec - areas[x][z].updated
		if (areas[x][z].inView and dt > 0.3 + update/3) or dt > 10 + update*2 then  --how this scales for diff size maps/ areasizes ??????????
		--Spring.Echo("update "..x..z)
			update = update + 2
			updateArea(areas[x][z], dt)
			areas[x][z].updated = gameSec
		end
	end
end
return update
end



local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end


local update = 0
local defUpd = 0

local updateInt = 0.5
local dtTime = 0
local tt = false

function widget:Update(dt)
dtTime = dtTime + dt

tt = not tt
if tt then return end

 local ground, xyz  = Spring.TraceScreenRay(0,vsy-1, true, false)
 local xs,zs,xe,ze
 if ground == "ground" then
	xs = xyz[1]
	zs = xyz[3]
 end
 
 ground, xyz  = Spring.TraceScreenRay(vsx-1,0, true, false)
  if ground == "ground" then
	xe = xyz[1]
	ze = xyz[3]
 end
 
 if not xs or not ze then
	ground, xyz  = Spring.TraceScreenRay(0,0, true, false)
	if ground == "ground" then
		xs = xyz[1]
		ze = xyz[3]
	end
 end
 
  if not xe or not zs then
	ground, xyz  = Spring.TraceScreenRay(vsx-1,vsy-1, true, false)
	if ground == "ground" then
		xe = xyz[1]
		zs = xyz[3]
	end
 end
  local gaSize = gridSize*areaSize
xs = floor(xs and xs/gaSize or 0)
ze = floor(ze and ze/gaSize or ceil(Game.mapSizeZ/gaSize))
zs = floor(zs and zs/gaSize or 0)
xe = floor(xe and xe/gaSize or ceil(Game.mapSizeX/gaSize))

for x=0,#areas do
	for z=0,#areas[x] do
		if x >= xs and x <= xe and z >= zs and z <= ze then
			areas[x][z].inView = true
		else
			areas[x][z].inView = false
		end
	end
end
 
	if dtTime < updateInt then return end 	--TODO use update
	dtTime=0

	update = update + updateWorld()
 
end

function widget:Shutdown()

  widgetHandler:RemoveAction("showScoutLOS", showLOS)
  Spring.SendCommands({"unbind l luaui"})
  Spring.SendCommands({"bind Any+l togglelos"})

for x=0,#areas do
	for z=0,#areas[x] do
		if areas[x][z].viewDrawList then
			gl.DeleteList(areas[x][z].viewDrawList)
		end
	end
end
end

local Color = gl.Color

function widget:DrawWorld()

Color( 1, 1, 1, 1 )

for x=0,#areas do
	for z=0,#areas[x] do
		if  areas[x][z].inView and --this maybe actually unnecessary
			areas[x][z].viewDrawList then
				gl.CallList(areas[x][z].viewDrawList)
		end
	end
end

Color( 1, 1, 1, 1 )
end
