function widget:GetInfo()
  return {
    name      = "FPSManager",
    desc      = "(v1.1) Tries to keep the framerate around 35 by adjusting the "..
                "detail level.  This version is old and obsolete. CA has a newer version!",
    author    = "quantum",
    date      = "May 28, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
----------------------------Configuration---------------------------------------
local maxFps     = 40
local minFps     = 30
local tolerance  = 10
------------     increase detail -------------  reduce detail   ---------- increase detail2  ----  reduce detail2 ----------------------
--------------------------------------------------------------------------------
levelTableUp = { 
								 {"advshading 1"     						   										}, --level 1
	               {"shadows 1 1024"   						   										}, --level 2
	               {"water 1"          						   										}, --level 3					
	               {"shadows 1 2048"   						   										}, --level 4					
	               {"water 3"          						   										}, --level 5					
	               {"seti BumpWaterReflection 0"  ,"seti BumpWaterShoreWaves 0"  ,"water 4" 	}, --level 6					
	               {"seti BumpWaterReflection 0"  ,"seti BumpWaterShoreWaves 1"  ,"water 4" 	}, --level 7					
	               {"seti BumpWaterReflection 1"  ,"seti BumpWaterShoreWaves 1"  ,"water 4" 	}, --level 8					
	               {"shadows 4096"     						} --level 9
	             --{"water 2"         						,  "water 3"      }  --level 10 (off)
						   }
						   
levelTableDown = { 
								 {"advshading 0"  }, --level 1
	               {"shadows 0"     }, --level 2
	               {"water 0"       }, --level 3
	               {"shadows 1 1024"}, --level 4
	               {"water 1"       }, --level 5
	               {"water 3" 			}, --level 6					
	               {"seti BumpWaterReflection 0"  ,"seti BumpWaterShoreWaves 0"  ,"water 4" 	}, --level 7					
	               {"seti BumpWaterReflection 0"  ,"seti BumpWaterShoreWaves 1"  ,"water 4" 	}, --level 8					
	               {"shadows 1 2048"} --level 9
	             --{"water 3"      }  --level 10 (off)
						   }
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local SendCommands  = Spring.SendCommands
local counter       = 0
local detailLevel   = 1
local fpsTable      = {}
local raisePoints   = 0
local lowerPoints   = 0


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function RaiseDetail()
  raisePoints = raisePoints + 1
  if ((detailLevel <= #levelTableUp) and
      (raisePoints > tolerance)) then
--    SendCommands({levelTableUp[detailLevel][1]})

		for i=1, #levelTableUp[detailLevel] do
    	SendCommands({levelTableUp[detailLevel][i]})
		end

    
    detailLevel = detailLevel + 1
	raisePoints = 0
  end
end


local function LowerDetail()
  lowerPoints = lowerPoints + 1
  if ((detailLevel > 1) and
      (lowerPoints > tolerance)) then
--    SendCommands({levelTableDown[detailLevel - 1][1]})
    
		for i=1, #levelTableDown[detailLevel - 1] do
    	SendCommands({levelTableDown[detailLevel - 1][i]})
		end
    
    
    detailLevel = detailLevel - 1
    lowerPoints = 0
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function widget:Initialize()
  SendCommands({"water 0", "shadows 0", "advshading 0"})
end


function widget:Update(t)
  counter  = counter + 1
  table.insert(fpsTable, Spring.GetFPS())
  if (#fpsTable > 30) then
    table.remove(fpsTable, 1)
  end
  if (counter % 30 < 0.1) then
    counter = 0
    sum = 0
    for _, v in ipairs(fpsTable) do
      sum = sum + v
    end
    average = (sum / #fpsTable)
    if (average > maxFps) then
      RaiseDetail()
    else
      raisePoints = 0
    end
    if (average < minFps) then
      LowerDetail()
    else
      lowerPoints = 0
    end
  end
end
