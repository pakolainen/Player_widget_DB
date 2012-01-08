function widget:GetInfo()
  return {
    name      = "Comblast Range 1.0",
    desc      = "ffffffffff",
    author    = "TheFatController",
    date      = "January 24, 2009",
    license   = "MIT/X11",
    layer     = 0,
    enabled   = true  -- loaded by default
  }
end

local GetUnitPosition     = Spring.GetUnitPosition
local glDrawGroundCircle  = gl.DrawGroundCircle
local GetUnitDefID = Spring.GetUnitDefID

local commanders = {}
local comCount = 0

function widget:UnitFinished(unitID, unitDefID, unitTeam)
  if UnitDefs[unitDefID].isCommander then
    commanders[unitID] = true
    comCount = (comCount + 1)
  end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  if commanders[unitID] then
    commanders[unitID] = nil
    comCount = (comCount - 1)
  end
end

function widget:UnitEnteredLos(unitID, unitTeam)
  local unitDefID = GetUnitDefID(unitID)
  if UnitDefs[unitDefID].isCommander then
    commanders[unitID] = true
    comCount = (comCount + 1)
  end  
end

function widget:UnitLeftLos(unitID, unitDefID, unitTeam)
  if commanders[unitID] then
    commanders[unitID] = nil
    comCount = (comCount - 1)
  end
end

function widget:DrawWorldPreUnit()
  if (comCount < 1) then return end
  gl.DepthTest(true)
  gl.Color(1,0,0,0.50)
  for unitID in pairs(commanders) do
    x,y,z = GetUnitPosition(unitID)
    glDrawGroundCircle(x,y,z,380,32)
  end
  gl.DepthTest(false)
end
