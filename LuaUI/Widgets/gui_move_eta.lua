
function widget:GetInfo()
  return {
    name      = "Move ETA",
    desc      = "[v0.8] Displays the estimated time of arrival for Move, Fight and build commands of selected units.\nPress META to prevent cumulative ETA",
    author    = "Pako",
    date      = "05.08.2009",
    license   = "GNU GPL, v2 or later",
    layer     = -1,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local GetUnitDefID     		= Spring.GetUnitDefID
local GetModKeyState 		= Spring.GetModKeyState
local GetGameSpeed 			= Spring.GetGameSpeed
local glPopMatrix           = gl.PopMatrix
local glPushMatrix          = gl.PushMatrix
local glTranslate           = gl.Translate
local glBillboard           = gl.Billboard
local glText                = gl.Text


local function sqDistance(x1,y1,z1,x2,y2,z2)
  local dx,dy,dz = x1-x2,y1-y2,z1-z2
  return (dx*dx)+(dy*dy)+(dz*dz)
end

local function getPathDist(x,y,z,cx,cy,cz, moveType, radius)
	
	local dist = 0

	local path = Spring.RequestPath(moveType or 1, x,y,z,cx,cy,cz, radius)
	if path == nil then --startpoint is blocked
		x,y,z,cx,cy,cz = cx,cy,cz,x,y,z
		path = Spring.RequestPath(moveType or 1, x,y,z,cx,cy,cz, radius)
		if path == nil then return -1 end --if startpoint  and endpoint is blocked path is not calculated
	end
	
	local xyzs, iii = path.GetEstimatedPath(path)

	x,y,z = xyzs[1][1],xyzs[1][2],xyzs[1][3]--???
	for i,pxyz in ipairs(xyzs) do

		local px,py,pz = pxyz[1],pxyz[2],pxyz[3]
		dist = dist + sqDistance(px,py,pz,x,y,z)^0.5
		x,y,z = px,py,pz
	end
	

	return dist
end

local function calcBuildETA(builderID, buildingID)
	  if builderID == nil or buildingID == nil then return 0 end
	  local buildProgress = 0
	  local metal
	  local def
	  if buildingID<0 then
		def = UnitDefs[(-buildingID)]
	  else
		def = UnitDefs[GetUnitDefID(buildingID)]
		_,_,_,_,buildProgress = Spring.GetUnitHealth(buildingID)
		_, metal, _,_ = Spring.GetUnitResources(builderID)
	  end
	  local buildTime = def.buildTime
	  local buildSpeed = UnitDefs[GetUnitDefID(builderID)].buildSpeed	  
	  local buildPower = buildSpeed *((metal and (((metal/def.metalCost))/(buildSpeed/buildTime))) or 1) --stall adjusted buildSpeed
	  local ETA = buildTime*(1-(buildProgress or 0))/buildPower
	if ETA ~= ETA or ETA > 10000 then 
	 return 0
	else
	 return ETA
	end
end

local lastGameUpdate = 0
local ETAs = {}


function widget:Update(dt)

	lastGameUpdate = lastGameUpdate+dt
	if lastGameUpdate < 0.3 then return end
	lastGameUpdate = 0
	
	 ETAs = {}
	 
  local a,c,meta,shift = GetModKeyState()
  if (shift==false) then return end
  
  local ETAxyz = {}
  local selUnits = Spring.GetSelectedUnits()
  for i,unitID in ipairs(selUnits) do
	if i > 5 then break end --only up to 5 units
	  local buildingID = Spring.GetUnitIsBuilding(unitID)
	  local cQueue = Spring.GetCommandQueue(unitID)
	  local buildETA = calcBuildETA(unitID, buildingID)	 
	  local builderID=unitID
	  local x,y,z
	  if buildingID then 
		x,y,z = Spring.GetUnitPosition(unitID)
		unitID=buildingID 
		if cQueue and #cQueue>0 and not(cQueue[1].id<0) then buildingID = nil  end	--hack to prevent discarding lab's first order
	  end 

      local unitDef = Spring.GetUnitDefID(unitID)
      
      if (unitDef ~= nil) and (cQueue~=nil) and #cQueue > 0 --and UnitDefs[unitDef].canMove == true 
	  then
	    local etaC = buildETA

		for ii,cmm in ipairs(cQueue) do
			if meta then
				etaC=0
			end
			if (cmm.id==CMD.MOVE or cmm.id==CMD.FIGHT or cmm.id<0) and cmm.params then 
				if x == nil then
					x,y,z = Spring.GetUnitPosition(unitID)
				end
				local cx,cy,cz = cmm.params[1], cmm.params[2], cmm.params[3]
				local dist = getPathDist(x,y,z,cx,cy,cz, UnitDefs[unitDef].moveData.id, UnitDefs[unitDef].radius)

				if dist then
					local buildETA2 = 0					
					local speed = UnitDefs[unitDef].speed
					if speed == nil or speed == 0 then 
					speed = UnitDefs[Spring.GetUnitDefID(buildingID or 0) or 216].speed or 50 
					if speed == 0 then speed=50 end
					end
					if cmm.id<0 and not ( ii == 1 and buildingID) then
						local defID = -cmm.id
						buildETA2 = calcBuildETA(builderID, -defID)		
						local buildDist = (UnitDefs[defID].radius + UnitDefs[unitDef].buildDistance)/4
						local dist=dist-buildDist
						if meta then
							dist=0
						end
						local xyz = cx,cy,cz
						if ETAxyz[xyz] == nil then -- else could just move cz to up/down
							ETAxyz[xyz] = true
							table.insert(ETAs, {x=cx, y=cy, z=cz, ETA=etaC + dist / speed + buildETA2})
						end
						local comDist = sqDistance(x,y,z,cx,cy,cz)^0.5
						cx = cx - (cx-x)*(buildDist/comDist)
						--cy = cy - (cy-y)*(buildDist/comDist)
						cz = cz - (cz-z)*(buildDist/comDist)
					end			
					local ETA = dist / speed -- acceleration & breaking???
					local xyz = cx,cy,cz
					if ( ii == 1 and buildingID) then 
						ETA=0 --discard the ETA of walking to center of the building 
					else
						x,y,z = cx,cy,cz --pathing from  the center of a created building fails  
					end
					etaC = etaC + ETA
					if ETAxyz[xyz] == nil then -- else could just move cz to up/down
							ETAxyz[xyz] = true
							table.insert(ETAs, {x=cx, y=cy, z=cz, ETA=etaC})
					end
					etaC = etaC + buildETA2
				end
			end
		end
      end
  end
  
  
  
end

function widget:DrawWorld()
  if #ETAs == 0 then return end
  gl.DepthTest(true)

  for _, ETA in ipairs(ETAs) do
    glPushMatrix()
	glTranslate(ETA.x, ETA.y + 20, ETA.z )
	glBillboard()
	glText(math.ceil(ETA.ETA).."s", 0.0, 0.0, 8, "cn")
	glPopMatrix()  
  end

  gl.DepthTest(false)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
