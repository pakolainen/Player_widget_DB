function widget:GetInfo()
  return {
    name      = "Dgun Helper 1.2",
    desc      = "Shows you where to dgun and turns your commander for you and stuff",
    author    = "TheFatController",
    date      = "January 24, 2009",
    license   = "MIT/X11",
    layer     = 0,
    enabled   = true  -- loaded by default
  }
end

local GetActiveCommand    = Spring.GetActiveCommand
local GetSelectedUnits    = Spring.GetSelectedUnits
local GetUnitsInCylinder  = Spring.GetUnitsInCylinder
local GetUnitPosition     = Spring.GetUnitPosition
local GetUnitDirection    = Spring.GetUnitDirection
local GetUnitVelocity     = Spring.GetUnitVelocity
local GetUnitSeparation   = Spring.GetUnitSeparation
local GetUnitRadius       = Spring.GetUnitRadius
local GiveOrderToUnit     = Spring.GiveOrderToUnit
local GetUnitTeam         = Spring.GetUnitTeam
local AreTeamsAllied      = Spring.AreTeamsAllied
local GetMyTeamID         = Spring.GetMyTeamID
local glDrawGroundCircle  = gl.DrawGroundCircle

local canDgun = {}
local dgun = {}
local RANGE = 400
local MAGICNUMBER = 9.6
local UPDATE = 0.4
local timer = 0
local lastCo = 0
local friendlyUnits = {}

function widget:UnitFinished(unitID, unitDefID, unitTeam)
  if UnitDefs[unitDefID].isCommander then
    canDgun[unitID] = true
  end
  friendlyUnits[unitID] = true
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  canDgun[unitID] = nil
  friendlyUnits[unitID] = nil
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
  if not (AreTeamsAllied(GetMyTeamID(), newTeam)) then
    friendlyUnits[unitID] = nil
  end
end

function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
  if (AreTeamsAllied(GetMyTeamID(), oldTeam)) then
    friendlyUnits[unitID] = true
  end
end

local function drawBlobs(unitID)
  local comX,_,comZ = GetUnitPosition(unitID)
  local nearUnits = GetUnitsInCylinder(comX,comZ,RANGE)
  local x,y,z,hX,hZ,dist
  for _,nearUnitID in ipairs(nearUnits) do
    if (nearUnitID ~= unitID) then
      hX,_,hZ = GetUnitVelocity(nearUnitID)
      if hX and hZ then
        dist = (GetUnitSeparation(unitID, nearUnitID) / MAGICNUMBER)
        x,y,z = GetUnitPosition(nearUnitID)
        x = x + (hX * dist)
        z = z + (hZ * dist)
        if friendlyUnits[nearUnitID] then 
          gl.Color(0,1,0)
        else
          gl.Color(1,0,0)
        end
        glDrawGroundCircle(x,y,z,GetUnitRadius(nearUnitID),18)
      end
    end
  end
end

function widget:Update(deltaTime)
  timer = timer + deltaTime
  if (timer < UPDATE) then return end
  timer = 0
  if next(dgun) then
    local x,y = Spring.GetMouseState()
    local getOver,getCo = Spring.TraceScreenRay(x,y)
    if (getOver == "ground") and (lastCo ~= (math.floor(getCo[1]/60) .. math.floor(getCo[2]/60) .. math.floor(getCo[3]/60))) then    
      for unitID in pairs(dgun) do
        local uX,uY,uZ = GetUnitPosition(unitID)
        local angle = math.atan2((getCo[1]-uX),(getCo[3]-uZ))
        GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
        GiveOrderToUnit(unitID, CMD.INSERT, {0, CMD.MOVE, CMD.OPT_SHIFT, (uX + (math.sin(angle) * 16)), uY, (uZ + (math.cos(angle) * 16))}, CMD.OPT_ALT)
      end
      lastCo = math.floor(getCo[1]/60) .. math.floor(getCo[2]/60) .. math.floor(getCo[3]/60)
    elseif (getOver == "unit") and (getCo ~= lastCo) then 
      local cmd = CMD.RECLAIM
      if friendlyUnits[getCo] then
        cmd = CMD.REPAIR
      end
      lastCo = getCo
      for unitID in pairs(dgun) do
        GiveOrderToUnit(unitID, cmd, {getCo}, {""})
      end
    end
  end
end

function widget:DrawWorldPreUnit()
  gl.DepthTest(true)
  local _,cmd=GetActiveCommand()
  if cmd == CMD.DGUN then
    local selUnits = GetSelectedUnits()
    for _,unitID in ipairs(selUnits) do
      if canDgun[unitID] then
        drawBlobs(unitID)
        dgun[unitID] = true
      end
    end
  else
    dgun = {}
  end
  gl.DepthTest(false)
end
