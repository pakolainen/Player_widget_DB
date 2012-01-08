function widget:GetInfo()
  return {
    name      = "Anti-Comnap v1.1",
    desc      = "tries to prevent comnaps by moving the com and warning points",
    author    = "[]lennart",
    date      = "23 Februar, 2009",
    license   = "GNU GPL v2",
    layer     = -1,
    enabled   = true  --  loaded by default?
  }
end

--1.1 crashfix by vbs

local GiveOrderToUnit    = Spring.GiveOrderToUnit
local GetUnitPosition    = Spring.GetUnitPosition
local GetCommandQueue    = Spring.GetCommandQueue
local Echo               = Spring.Echo
local GetSelectedUnits   = Spring.GetSelectedUnits
local GetUnitDefID       = Spring.GetUnitDefID
local GetUnitIsCloaked   = Spring.GetUnitIsCloaked
local AreTeamsAllied     = Spring.AreTeamsAllied
local myTeamID           = Spring.GetMyTeamID()
local GetUnitTeam        = Spring.GetUnitTeam
local GetTeamUnitsSorted = Spring.GetTeamUnitsSorted
local spGetMyPlayerID    = Spring.GetMyPlayerID
local spGetPlayerInfo    = Spring.GetPlayerInfo
local MarkerAddPoint     = Spring.MarkerAddPoint


local px --used to prevent com from "travelling" when escaping naps
local py
local pz
local enemytranslist={}  --keep track of enemy transports
local allycomlist={}     --and of allied coms

local function setUnitToPatrol(unitID, x, y, z)
  if((px==nil) or (((px-x)^2+(py-y)^2+(pz-z)^2)^0.5>200)) then
    px=x
	py=y
	pz=z
--    Echo("setting com to patrol")
  end
  local cQueue=GetCommandQueue(unitID)
  if ((cQueue[0]~=nil) and (cQueue[1]~=nil)) then
    if ((cQuese[0].id==CMD.MOVE) and (cQueue[1].id==CMD.MOVE)) then return true end
  end  
  --GiveOrderToUnit(unitID, CMD.MOVE, {(x-50),y,z},{""})
  GiveOrderToUnit(unitID, CMD.INSERT, {0,CMD.MOVE,CMD.OPT_SHIFT,(px-35),py,pz}, {"alt"})
  GiveOrderToUnit(unitID, CMD.INSERT, {0,CMD.MOVE,CMD.OPT_SHIFT,(px+35),py,pz}, {"alt"})
end  


function widget:UnitEnteredLos(unitID, unitTeam)
  local unitDef = GetUnitDefID(unitID)
  if ((unitDef ~= nil) and UnitDefs[unitDef]["isTransport"] 
     and not(AreTeamsAllied(myTeamID, unitTeam))) then
	enemytranslist[unitID]=true
--	Echo("spotted enemy trans")
  end
end

-- both following functions clear the enemytranslist var, but they are not necessary,
-- as <widget:GameFrame(..)> will delete any ids where the position is not accessible
--[[
function widget:UnitLeftLos(unitID, unitTeam)
  if (enemytranslist[unitID]~=nil) then
    enemytranslist[unitID]=nil
  end
end
function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  if (enemytranslist[unitID]~=nil) then
    enemytranslist[unitID]=nil
  end
end
--]]

function widget:UnitCreated(unitID, unitDefID, teamID)
  if(UnitDefs[unitDefID].isCommander and AreTeamsAllied(myTeamID, teamID)) then
    allycomlist[unitID]=teamID
  end
end
--here the same applies as for the both functions above; if the location is
--not accessible the unit will get removed (from the list) anyways
--[[
function widget:UnitDestroyed(unitID, unitDefID, teamID)
  allycomlist[unitID]=nil
end
--]]

local function updateComlist()
  allycomlist={}
  local allUnits=Spring.GetAllUnits()
  if(allUnits~=nil) then
    for i,unitID in ipairs(allUnits) do
      unitTeamID=GetUnitTeam(unitID)
	  local udefId = GetUnitDefID(unitID)
	  if(udefId ~= nil and UnitDefs[udefId].isCommander and AreTeamsAllied(myTeamID,unitTeamID)) then
	    allycomlist[unitID]=unitTeamID
      end
    end
  end
--  Echo("<anti-comnap> updated commander list.")
end

function widget:Initialize()
--Echo("widget started!!")
  updateComlist()
end

-- this callin is needed to make the widget work even with cheating (for testing the widget).
function widget:PlayerChanged()
  updateComlist()
end

local function checkSpecState()
	local playerID = spGetMyPlayerID()
	local _, _, spec, _, _, _, _, _ = spGetPlayerInfo(playerID)
		
	if ( spec == true ) then
		spEcho("<anti-comnap> Spectator mode. Widget removed.")
		widgetHandler:RemoveWidget()
		return false
	end
	
	return true	
end


function widget:GameFrame(frameNum)
  if ((frameNum%32)==0) then
    checkSpecState()
	
	for ComUnitID, ComTeamID in pairs(allycomlist) do
	  x,y,z=GetUnitPosition(ComUnitID)
	  if(x==nil) then
	    allycomlist[ComUnitID]=nil
      else
	    for unitID,_ in pairs(enemytranslist) do
	      local ex, ey, ez = GetUnitPosition(unitID)
	      if(ex==nil) then
	        enemytranslist[unitID]=nil
	      else
            local dist = ((x-ex)^2 + (y-ey)^2 +(z-ez)^2)^0.5
			if(dist<1000) then --1000 is the current warning distance (for allies mostly)
			  MarkerAddPoint(ex,ey,ez,"comnap warning!")
			end
            if(dist<500) then --the distance at which your com will start moving
              if(ComTeamID==myTeamID) then
                setUnitToPatrol(ComUnitID,x,y,z)
			  end
            end
		  end
		end
      end
    end

-- this hopefully got obsolete with the gamestart-callin
--[[
    if(frameNum==32) then --make list at game start
	  updateComlist()
	end
--]]	

-- for testing whether coms are in list:
--[[
	if((frameNum%1024)==0) then
	  for unitID,_ in pairs(allycomlist) do
	    local x,y,z = GetUnitPosition(unitID)
		if(x~=nil) then
          MarkerAddPoint(x,y,z)
		end
	  end
	end
--]]
  end
end
	