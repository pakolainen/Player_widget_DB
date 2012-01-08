
function widget:GetInfo()
	return {
		name      = "Unit Stats",
		desc      = "Shows detailed unit stats",
		author    = "Niobium",
		date      = "Jan 11, 2009",
		version   = 1.2,
		license   = "GNU GPL, v2 or later",
		layer     = 6,
		enabled   = true,  --  loaded by default?
		handler   = true
	}
end

---- v1.2 changes
-- Fixed drains for burst weapons (Removed 0.125 minimum)
-- Show remaining costs for units under construction

---- v1.1 changes
-- Added extra text to help explain numbers
-- Added grouping of duplicate weapons
-- Added sonar radius
-- Fixed radar/jammer detection
-- Fixed stockpiling unit drains
-- Fixed turnrate/acceleration scale
-- Fixed very low reload times

------------------------------------------------------------------------------------
-- Globals
------------------------------------------------------------------------------------
local fontSize = 16
local xOffset = 25
local yOffset = 25

local cX, cY

------------------------------------------------------------------------------------
-- Speedups
------------------------------------------------------------------------------------
local white = '\255\255\255\255'
local green = '\255\1\255\1'
local yellow = '\255\255\255\1'
local orange = '\255\255\128\1'
local blue = '\255\128\128\255'

local metalColor = '\255\196\196\255' -- Light blue
local energyColor = '\255\255\255\128' -- Light yellow
local buildColor = '\255\128\255\128' -- Light green

local max = math.max
local floor = math.floor
local format = string.format
local char = string.char

local glColor = gl.Color
local glText = gl.Text

local spGetMyTeamID = Spring.GetMyTeamID
local spGetTeamResources = Spring.GetTeamResources
local spGetTeamInfo = Spring.GetTeamInfo
local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamColor = Spring.GetTeamColor

local spGetModKeyState = Spring.GetModKeyState
local spGetMouseState = Spring.GetMouseState
local spTraceScreenRay = Spring.TraceScreenRay

local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitExp = Spring.GetUnitExperience
local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitExperience = Spring.GetUnitExperience
local spGetUnitSensorRadius = Spring.GetUnitSensorRadius

local uDefs = UnitDefs
local wDefs = WeaponDefs

------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------
local function DrawText(t1, t2)
	glText(t1, cX, cY, fontSize, "o")
	glText(t2, cX + 60, cY, fontSize, "o")
	cY = cY - fontSize
end

local function GetTeamColorCode(teamID)
	
	if not teamID then return "\255\255\255\255" end
	
	local R, G, B = spGetTeamColor(teamID)
	
	if not R then return "\255\255\255\255" end
	
	R = floor(R * 255)
	G = floor(G * 255)
	B = floor(B * 255)
	
	if (R < 11) then R = 11	end -- Note: char(10) terminates string
	if (G < 11) then G = 11	end
	if (B < 11) then B = 11	end
	
	return "\255" .. char(R) .. char(G) .. char(B)
end

local function GetTeamName(teamID)
	
	if not teamID then return 'Error:NoTeamID' end
	
	local _, teamLeader = spGetTeamInfo(teamID)
	if not teamLeader then return 'Error:NoLeader' end
	
	local leaderName = spGetPlayerInfo(teamLeader)
	return leaderName or 'Error:NoName'
end

------------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------------
function widget:Initialize()
	local highlightWidget = widgetHandler:FindWidget("HighlightUnit")
	if highlightWidget then
		widgetHandler:RemoveWidgetCallIn("DrawScreen", highlightWidget)
	end
end

function widget:Shutdown()
	local highlightWidget = widgetHandler:FindWidget("HighlightUnit")
	if highlightWidget then
		widgetHandler:UpdateWidgetCallIn("DrawScreen", highlightWidget)
	end
end

function widget:DrawScreen()
	
	local alt, ctrl, meta, shift = spGetModKeyState()
	if not meta then return end
	
	local mx, my = spGetMouseState()
	local rType, uID = spTraceScreenRay(mx, my)
	if rType ~= 'unit' or not uID then return end
	
	local uDefID = spGetUnitDefID(uID)
	if not uDefID then return end
	
	local uDef = uDefs[uDefID]
	local _, _, _, _, buildProg = spGetUnitHealth(uID)
	local uTeam = spGetUnitTeam(uID)
	
	cX = mx + xOffset
	cY = my + yOffset
	glColor(1.0, 1.0, 1.0, 1.0)
	
	------------------------------------------------------------------------------------
	-- Owner, unit name, unit ID
	------------------------------------------------------------------------------------
	glText(GetTeamColorCode(uTeam) .. GetTeamName(uTeam) .. "'s " .. yellow .. uDef.humanName .. white .. " (" .. uDef.name .. ", #" .. uID .. ")", cX, cY, fontSize, "o")
	cY = cY - 2 * fontSize
	
	------------------------------------------------------------------------------------
	-- Units under construction
	------------------------------------------------------------------------------------
	if buildProg and buildProg < 1 then
		
		local myTeamID = spGetMyTeamID()
		local mCur, mStor, mPull, mInc, mExp, mShare, mSent, mRec = spGetTeamResources(myTeamID, 'metal')
		local eCur, eStor, ePull, eInc, eExp, eShare, eSent, eRec = spGetTeamResources(myTeamID, 'energy')
		
		local mTotal = uDef.metalCost
		local eTotal = uDef.energyCost
		local buildRem = 1 - buildProg
		local mRem = mTotal * buildRem
		local eRem = eTotal * buildRem
		local mEta = (mRem - mCur) / (mInc + mRec)
		local eEta = (eRem - eCur) / (eInc + eRec)
		
		DrawText("Prog:", format("%d%%", 100 * buildProg))
		DrawText("M:", format("%d / %d (" .. yellow .. "%d" .. white .. ", %ds)", mTotal * buildProg, mTotal, mRem, mEta))
		DrawText("E:", format("%d / %d (" .. yellow .. "%d" .. white .. ", %ds)", eTotal * buildProg, eTotal, eRem, eEta))
		--DrawText("MaxBP:", format(white .. '%d', buildRem * uDef.buildTime / math.max(mEta, eEta)))
		cY = cY - fontSize
	end
	
	------------------------------------------------------------------------------------
	-- Generic information, cost, move, class
	------------------------------------------------------------------------------------
	DrawText("Cost:", format(metalColor .. '%d' .. white .. ' / ' ..
							energyColor .. '%d' .. white .. ' / ' ..
							buildColor .. '%d', uDef.metalCost, uDef.energyCost, uDef.buildTime)
			)
	
	if not (uDef.isBuilding or uDef.isFactory) then
		DrawText("Move:", format("%.1f / %.1f / %.0f (Speed / Accel / Turn)", uDef.speed, 900 * uDef.maxAcc, 30 * uDef.turnRate * (180 / 32767)))
	end
	
	DrawText("Class:", Game.armorTypes[uDef.armorType or 0] or '???')
	
	if uDef.buildSpeed > 0 then	DrawText('Build:', yellow .. uDef.buildSpeed) end
	
	cY = cY - fontSize
	
	------------------------------------------------------------------------------------
	-- Sensors and Jamming
	------------------------------------------------------------------------------------
	local losRadius = spGetUnitSensorRadius(uID, 'los') or 0
	local airLosRadius = spGetUnitSensorRadius(uID, 'airLos') or 0
	local radarRadius = spGetUnitSensorRadius(uID, 'radar') or 0
	local sonarRadius = spGetUnitSensorRadius(uID, 'sonar') or 0
	local jammingRadius = spGetUnitSensorRadius(uID, 'radarJammer') or 0
	-- local sonarJammingRadius = spGetUnitSensorRadius(uID, 'sonarJammer')
	local seismicRadius = spGetUnitSensorRadius(uID, 'seismic') or 0
	
	DrawText('Los:', losRadius .. (airLosRadius > losRadius and format(' (AirLos: %d)', airLosRadius) or ''))
	
	if radarRadius   > 0 then DrawText('Radar:', '\255\77\255\77' .. radarRadius) end
	if sonarRadius   > 0 then DrawText('Sonar:', '\255\128\128\255' .. sonarRadius) end
	if jammingRadius > 0 then DrawText('Jam:'  , '\255\255\77\77' .. jammingRadius) end
	if seismicRadius > 0 then DrawText('Seis:' , '\255\255\26\255' .. seismicRadius) end
	
	if uDef.stealth then DrawText("Other:", "Stealth") end
	
	cY = cY - fontSize
	
	------------------------------------------------------------------------------------
	-- Weapons
	------------------------------------------------------------------------------------
	--[[
	local uExp = spGetUnitExperience(uID)
	if uExp and (uExp > 0.25) then
		uExp = uExp / (1 + uExp)
		DrawText("Exp:", format("+%d%% damage, +%d%% firerate, +%d%% health", 100 * uExp, 100 / (1 - uExp * 0.4) - 100, 70 * uExp))
		cY = cY - fontSize
	end
	]]--
	
	local wepCounts = {} -- wepCounts[wepDefID] = #
	local wepsCompact = {} -- uWepsCompact[1..n] = wepDefID
	
	local uWeps = uDef.weapons
	for i = 1, #uWeps do
		local wDefID = uWeps[i].weaponDef
		local wCount = wepCounts[wDefID]
		if wCount then
			wepCounts[wDefID] = wCount + 1
		else
			wepCounts[wDefID] = 1
			wepsCompact[#wepsCompact + 1] = wDefID
		end
	end
	
	for i = 1, #wepsCompact do
		
		local wDefId = wepsCompact[i]
		local uWep = wDefs[wDefId]
		
		if uWep.range > 16 then
			
			local oDmg = uWep.damages[0]
			local oBurst = uWep.salvoSize * uWep.projectiles
			local oRld = uWep.stockpile and uWep.stockpileTime or uWep.reload
			local wepCount = wepCounts[wDefId]
			
			if wepCount > 1 then
				DrawText("Weap:", format(yellow .. "%dx" .. white .. " %s", wepCount, uWep.type))
			else
				DrawText("Weap:", uWep.type)
			end
			
			DrawText("Info:", format("%d range, %d aoe, %d%% edge", uWep.range, uWep.areaOfEffect, 100 * uWep.edgeEffectiveness))
			
			local dmgString
			if oBurst > 1 then
				dmgString = format(yellow .. "%d (x%d)" .. white .. " / " .. yellow .. "%.2f" .. white .. " = " .. yellow .. "%.2f", oDmg, oBurst, oRld, oBurst * oDmg / oRld)
			else
				dmgString = format(yellow .. "%d" .. white .. " / " .. yellow .. "%.2f" .. white .. " = " .. yellow .. "%.2f", oDmg, oRld, oDmg / oRld)
			end
			
			if wepCount > 1 then
				dmgString = dmgString .. white .. " (Each)"
			end
			
			DrawText("Dmg:", dmgString)
			
			if uWep.metalCost > 0 or uWep.energyCost > 0 then
				
				-- Stockpiling weapons are weird
				-- They take the correct amount of resources overall
				-- They take the correct amount of time
				-- They drain (32/30) times more resources than they should (And the listed drain is real, having lower income than listed drain WILL stall you)
				local drainAdjust = uWep.stockpile and 32/30 or 1
				
				DrawText('Cost:', format(metalColor .. '%d' .. white .. ', ' ..
										 energyColor .. '%d' .. white .. ' = ' ..
										 metalColor .. '-%d' .. white .. ', ' ..
										 energyColor .. '-%d' .. white .. ' per second',
										 uWep.metalCost,
										 uWep.energyCost,
										 drainAdjust * uWep.metalCost / oRld,
										 drainAdjust * uWep.energyCost / oRld))
			end
			
			cY = cY - fontSize
		end
	end
end

------------------------------------------------------------------------------------
