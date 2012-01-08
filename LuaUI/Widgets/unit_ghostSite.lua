local versionNumber = "1.34"

function widget:GetInfo()
	return {
		name      = "Ghost Site",
		desc      = "[v" .. string.format("%s", versionNumber ) .. "] Displays ghosted buildings in progress, features and wreckages",
		author    = "very_bad_soldier",
		date      = "April 7, 2009",
		license   = "GNU GPL v2",
		layer     = 0,
		enabled   = true
	}
end


-- CONFIGURATION
local debug = false		--generates debug message
local updateInt = 1 	--seconds for the ::update loop
local dontTrackEnemyWrecks = tonumber(Spring.GetModOptions().mo_enemywrecks) or 0
-- END OF CONFIG

local lastTime
local ghostSites = {}
local ghostFeatures = {}
local ignoreFeature = {}

local floor                 = math.floor
local max					= math.max
local udefTab				= UnitDefs
local fdefTab				= FeatureDefs
local glColor               = gl.Color
local glDepthTest           = gl.DepthTest
local glRotate				= gl.Rotate
local glTexture             = gl.Texture
local glTexEnv				= gl.TexEnv
local glLineWidth           = gl.LineWidth
local glPopMatrix           = gl.PopMatrix
local glPushMatrix          = gl.PushMatrix
local glTranslate           = gl.Translate
local glFeatureShape		= gl.FeatureShape
local glUnitShape			= gl.UnitShape
local spGetGameSeconds      = Spring.GetGameSeconds
local spGetMyPlayerID       = Spring.GetMyPlayerID
local spGetPlayerInfo       = Spring.GetPlayerInfo
local spGetAllFeatures		= Spring.GetAllFeatures
local spGetFeaturePosition  = Spring.GetFeaturePosition
local spGetFeatureDefID		= Spring.GetFeatureDefID
local spGetMyAllyTeamID		= Spring.GetMyAllyTeamID
local spGetFeatureAllyTeam	= Spring.GetFeatureAllyTeam
local spGetFeatureTeam		= Spring.GetFeatureTeam
local spGetUnitHealth 		= Spring.GetUnitHealth
local spGetFeatureHealth 	= Spring.GetFeatureHealth
local spGetFeatureResurrect = Spring.GetFeatureResurrect
local spGetPositionLosState = Spring.GetPositionLosState
local spIsUnitAllied		= Spring.IsUnitAllied
local spGetUnitDirection    = Spring.GetUnitDirection
local spGetFeatureDirection = Spring.GetFeatureDirection
local spGetUnitBasePosition = Spring.GetUnitBasePosition
local spGetUnitPosition     = Spring.GetUnitPosition
local spGetUnitHealth 	    = Spring.GetUnitHealth
local spEcho                = Spring.Echo
local spGetUnitDefID        = Spring.GetUnitDefID
local spIsSphereInView  	= Spring.IsSphereInView
local spGetUnitBuildFacing  = Spring.GetUnitBuildFacing
local mdeg = math.deg
local matan2 = math.atan2

local DrawGhostFeatures
local DrawGhostSites
local ScanFeatures
local DeleteGhostFeatures
local DeleteGhostSites
local ResetGl
local CheckSpecState
local printDebug
local firstScan = true

function widget:Update()
	local timef = spGetGameSeconds()
	local time = floor(timef)

	-- update timers once every <updateInt> seconds
	if (time % updateInt == 0 and time ~= lastTime) then	
		lastTime = time
		--do update stuff:
		
		if ( CheckSpecState() == false ) then
			return false
		end
		
		ScanFeatures()
		
		DeleteGhostSites()
		DeleteGhostFeatures()
	end
end

function widget:DrawWorld()
	DrawGhostSites()
	
	DrawGhostFeatures()
	
	ResetGl()
end

function widget:UnitEnteredLos(unitID, allyTeam)
	if ( spIsUnitAllied( unitID ) ) then
		return
	end
	
	local _,_,_,_,buildProgress = spGetUnitHealth( unitID )
	local udef = udefTab[spGetUnitDefID(unitID)]
	if ( --[[wtf? allyTeam == 0 and --]] ( udef.isBuilding == true or udef.isFactory == true) and buildProgress ~= 1 ) then
		local x, y, z = spGetUnitBasePosition(unitID)
		
		local dx,_,dz = spGetUnitDirection(unitID)
		local angle = mdeg(matan2(dx,dz))	
		ghostSites[unitID] = { unitDefId = spGetUnitDefID(unitID), x=x, y=y, z=z, teamId = allyTeam, angle = angle }
	end
end

function DrawGhostFeatures()
	glColor(1.0, 1.0, 1.0, 0.35 )
  
	glTexture(0,"$units1")
	--glTexture(1,"$units1")

	glTexEnv( GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, 34160 )				--GL_COMBINE_RGB_ARB
	--use the alpha given by glColor for the outgoing alpha.
	glTexEnv( GL.TEXTURE_ENV, 34162, GL.REPLACE )			--GL_COMBINE_ALPHA
	glTexEnv( GL.TEXTURE_ENV, 34184, 34167 )			--GL_SOURCE0_ALPHA_ARB			GL_PRIMARY_COLOR_ARB
	
	--------------------------Draw-------------------------------------------------------------
	for unitID, ghost in pairs( ghostFeatures ) do
		local x, y, z = ghost.x, ghost.y, ghost.z
		local _, losState, _ = spGetPositionLosState(x, y, z)
		
		local udef = fdefTab[ ghost["featDefId"] ]
		local radius = max( udef["xsize"], udef["zsize"] ) * 0.5
		local inView = spIsSphereInView( x, y, z, radius )
	
		if ( losState == false and inView ) then
			--glow effect?
			--gl.Blending(GL.SRC_ALPHA, GL.ONE)
			glPushMatrix()
			glTranslate(x, y, z)
			glRotate(ghost.angle,0,y,0)

			glFeatureShape(ghost["featDefId"], ghost["teamId"] )
			  
			glPopMatrix()
		end
	end
	--------------------------Clean up-------------------------------------------------------------
	glTexEnv( GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, 8448 )				--GL_MODULATE
	--use the alpha given by glColor for the outgoing alpha.
	glTexEnv( GL.TEXTURE_ENV, 34162, 8448 )											--GL_MODULATE
	----gl.TexEnv( GL.TEXTURE_ENV, 34184, 5890 )			--GL_SOURCE0_ALPHA_ARB			GL_TEXTURE
end

function DrawGhostSites()
	glColor(0.3, 1.0, 0.3, 0.25)
	glDepthTest(true)

	for unitID, ghost in pairs( ghostSites ) do
		--	printDebugTable( weapon )
		local x, y, z = ghost.x, ghost.y, ghost.z
		local _, losState, _ = spGetPositionLosState(x, y, z)
		
		local udef = udefTab[ ghost["unitDefId"] ]
		local radius = max( udef["xsize"], udef["zsize"] ) * 0.5
		local inView = spIsSphereInView( x, y, z, radius )
	
		if ( losState == false and inView ) then
			--glow effect?
			--gl.Blending(GL.SRC_ALPHA, GL.ONE)
			    
			glPushMatrix()
			glTranslate( x, y, z)
			glRotate(ghost.angle,0,y,0)
			
			glUnitShape(ghost["unitDefId"], ghost["teamId"] )
			      
			glPopMatrix()
		end
	end
end

function ScanFeatures()	
	local features = spGetAllFeatures()

	if firstScan then
	  local sfind = string.find
	  for _, fID in ipairs(features) do
	    local fDefId = spGetFeatureDefID(fID)
	    local fName = FeatureDefs[fDefId].name
	    if sfind(fName, 'tree') or sfind(fName, 'rock') then
	      ignoreFeature[fDefId] = true
	    end
	  end
	  firstScan = false
	  return
	end
		
	local myAllyID = spGetMyAllyTeamID()
	
	for _, fID in ipairs(features) do
		local fDefId = spGetFeatureDefID(fID)
		
		if not ignoreFeature[fDefId] then
		
			local fAllyID = spGetFeatureAllyTeam(fID)
			local fTeamID = spGetFeatureTeam( fID )

			local resName, _ = spGetFeatureResurrect(fID)
											
			if ( (resName == "" or dontTrackEnemyWrecks == 0) and fAllyID >= 0 and myAllyID ~= fAllyID and ghostFeatures[fID] == nil ) then
				printDebug("Ghost Feature added: " .. fDefId )
				local x, y, z = spGetFeaturePosition(fID)
				local dx,_,dz = spGetFeatureDirection(fID)
				local angle = mdeg(matan2(dx,dz))			
				ghostFeatures[fID] = { featDefId = fDefId, x=x, y=y, z=z, teamId = fTeamID, angle=angle }
			end
		end
	end
end

function DeleteGhostFeatures()
	for featureID, ghost in pairs(ghostFeatures) do
		local a, b, c = spGetPositionLosState(ghost.x, ghost.y, ghost.z)
		local losState = b
		local featDefID = spGetFeatureDefID(featureID)
			
		--local health,_,_ = spGetFeatureHealth( unitID )
	
		if ( featDefID == nil and losState) then	
			printDebug("Ghost Feature deleted: " .. featureID )
			ghostFeatures[featureID] = nil
		end
	end
end

function DeleteGhostSites()
	for unitID, ghost in pairs(ghostSites) do
		local a, b, c = spGetPositionLosState(ghost.x, ghost.y, ghost.z)
		local losState = b
		local udefID = spGetUnitDefID(unitID)
			
		local _,_,_,_,buildProgress = spGetUnitHealth( unitID )
	
		if ( ( udefID == nil or buildProgress == 1 ) and losState) then	
			printDebug("Ghost deleted: " .. unitID )
			ghostSites[unitID] = nil
		end
	end
end

function widget:GameStart()
  if widgetHandler.widgets then
	  for i, widget in ipairs(widgetHandler.widgets) do
		if (widget:GetInfo().name == 'Defense Range') then
		  local version = tonumber(string.match(widget:GetInfo().desc,'%d+%.%d+'))
		  if version and (version < tonumber("6")) then
			spEcho("<Ghost Site> Old DefenseRange found! Widget removed.")
			widgetHandler:RemoveWidget()
		  end
		end
	  end
  end
end

--Commons
function ResetGl() 
	glColor( { 1.0, 1.0, 1.0, 1.0 } )
	glLineWidth( 1.0 )
	glDepthTest(false)
	glTexture(false)
end

function CheckSpecState()
	local playerID = spGetMyPlayerID()
	local _, _, spec, _, _, _, _, _ = spGetPlayerInfo(playerID)
		
	if ( spec == true ) then
		spEcho("<Ghost Site> Spectator mode. Widget removed.")
		widgetHandler:RemoveWidget()
		return false
	end
	
	return true	
end

function printDebug( value )
	if ( debug ) then
		if ( type( value ) == "boolean" ) then
			if ( value == true ) then spEcho( "true" )
				else spEcho("false") end
		elseif ( type(value ) == "table" ) then
			spEcho("Dumping table:")
			for key,val in pairs(value) do 
				spEcho(key,val) 
			end
		else
			spEcho( value )
		end
	end
end
