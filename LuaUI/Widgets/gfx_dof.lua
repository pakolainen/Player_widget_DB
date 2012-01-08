--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "DepthOfField2",
    desc      = "",
    author    = "jK, Satirik",
    date      = "Nov, 2010",
    license   = "GNU GPL, v2 or later",
    layer     = -10000,
    enabled   = true
  }
end

options = {
	quality = {
		name = 'Quality',
		type = 'number',
		min = 1,
		max = 10,
		step = 1,
		value = 4,
	},
	intensity = {
		name = 'Intensity',
		type = 'number',
		min = 0.1,
		max = 4.,
		step = 0.1,
		value = 1.0,
	},
	focusCurveExp = {
		name = 'Non linear focused area',
		type = 'number',
		min = 1.,
		max = 4.,
		step = 0.1,
		value = 2.0,
	},
	focusRangeMultiplier = {
		name = 'Focus range multiplier',
		type = 'number',
		min = 0.1,
		max = 3.0,
		step = 0.1,
		value = 1.0,
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--hardware capability

local canRTT    = (gl.RenderToTexture ~= nil)
local canCTT    = (gl.CopyToTexture ~= nil)
local canShader = (gl.CreateShader ~= nil)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local GL_DEPTH_BITS = 0x0D56

local GL_DEPTH_COMPONENT   = 0x1902
local GL_DEPTH_COMPONENT16 = 0x81A5
local GL_DEPTH_COMPONENT24 = 0x81A6
local GL_DEPTH_COMPONENT32 = 0x81A7

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local blurShader
local dofShader
local screencopy
local depthcopy

local focusLoc
local focusRangeLoc
local viewXLoc
local viewYLoc
local qualityLoc
local intensityLoc
local focusCurveExpLoc
local focusRangeMultiplierLoc

local oldvs = 0
local vsx, vsy   = widgetHandler:GetViewSizes()
function widget:ViewResize(viewSizeX, viewSizeY)
  vsx, vsy  = viewSizeX,viewSizeY

  if (gl.DeleteTextureFBO) then
    gl.DeleteTexture(depthcopy)
    gl.DeleteTextureFBO(blurtex)
    gl.DeleteTextureFBO(blurtex2)
    gl.DeleteTexture(screencopy)
  end

  depthcopy = gl.CreateTexture(vsx,vsy, {
    border = false,
    format = GL_DEPTH_COMPONENT24,
    min_filter = GL.NEAREST,
    mag_filter = GL.NEAREST,
  })
  screencopy = gl.CreateTexture(vsx, vsy, {
    border = false,
    min_filter = GL.NEAREST,
    mag_filter = GL.NEAREST,
  })

  if (screencopy == nil) then
    Spring.Echo("blur api: texture error")
    widgetHandler:RemoveWidget()
    return false
  end
end

function widget:GetConfigData()
  return {
    quality  = options.quality.value,
	intensity = options.intensity.value,
	focusCurveExp = options.focusCurveExp.value,
	focusRangeMultiplier = options.focusRangeMultiplier.value,
  }
end

function widget:SetConfigData(data)
  options.quality.value  = data.quality or 2.
  options.intensity.value = data.intensity or 1.
  options.focusCurveExp.value = data.focusCurveExp or 2.
  options.focusRangeMultiplier.value = data.focusRangeMultiplier or 1.
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function CheckHardware()
  if (not canCTT) then
    Spring.Echo("blur api: your hardware is missing the necessary CopyToTexture feature")
    widgetHandler:RemoveWidget()
    return false
  end

  if (not canRTT) then
    Spring.Echo("blur api: your hardware is missing the necessary RenderToTexture feature")
    widgetHandler:RemoveWidget()
    return false
  end

  if (not canShader) then
    Spring.Echo("blur api: your hardware does not support shaders")
    widgetHandler:RemoveWidget()
    return false
  end

  return true
end

function widget:Initialize()
  if (not CheckHardware()) then return false end

  dofShader = gl.CreateShader({
    fragment = [[
      uniform sampler2D tex0;
      uniform sampler2D tex1;
      uniform sampler2D tex2;

      uniform float focus;
      uniform float focusRange;
	  uniform float viewX;
	  uniform float viewY;
	  uniform float quality;
	  uniform float intensity;
	  uniform float focusCurveExp;
	  uniform float focusRangeMultiplier;
	  
      void main(void)
      {
		vec2 texCoord = vec2(gl_TextureMatrix[0] * gl_TexCoord[0]);
	  	gl_FragColor = vec4(0.0,0.0,0.0,1.0);
		
		float focus = texture2D(tex2, vec2(0.5,0.5)).z;
		
		int k,l;
		float zValue = texture2D(tex2, texCoord).z;
		float dmix = clamp(abs(focus-zValue)*focusRange*focusRangeMultiplier ,0.0,1.0);
		
		if(dmix > 0.05 || focus>zValue)
		{
			zValue = 0;
			for(k = -1; k <= 1; k++){
			  for(l = -1; l <= 1; l++){
				zValue += texture2D(tex2, texCoord + vec2(0.005*k,0.005*l)).z/9.;
			  }
			}
			dmix = clamp(abs(focus-zValue)*focusRange*focusRangeMultiplier ,0.0,1.0);
		}
		if(focusCurveExp>1.){
			dmix = (exp(focusCurveExp*dmix)-1.)/exp(focusCurveExp);
		}
		
		
		int halfSizeKernel = quality; // quality
		float dy = (8./halfSizeKernel)*dmix/viewY*intensity;
		float dx = (8./halfSizeKernel)*dmix/viewX*intensity;
		int i,j;
		float sumKernel = 0;
		for(j = -halfSizeKernel; j <= halfSizeKernel; j++)
			for(i = -halfSizeKernel; i <= halfSizeKernel; i++){
				sumKernel += (halfSizeKernel+1-abs(i)+halfSizeKernel+1-abs(j))/2.;
			}
		for(j = -halfSizeKernel; j <= halfSizeKernel; j++)
			for(i = -halfSizeKernel; i <= halfSizeKernel; i++){
				gl_FragColor.rgb+= (halfSizeKernel+1-abs(i)+halfSizeKernel+1-abs(j))/(2*sumKernel)*texture2D(tex0, texCoord + vec2(j*dy,i*dx)).rgb;
			}
		//gl_FragColor.rgb = vec3(dmix,dmix,dmix);
      }
    ]],
    uniform = {
      focus      = 0.9955,
      focusRange = 1./0.0005,
    },
    uniformInt = {
      tex0 = 0,
      tex1 = 1,
      tex2 = 2,
    }
  })

  -- create blurtexture
  depthcopy = gl.CreateTexture(vsx,vsy, {
    border = false,
    format = GL_DEPTH_COMPONENT24,
    min_filter = GL.NEAREST,
    mag_filter = GL.NEAREST,
  })
  screencopy = gl.CreateTexture(vsx, vsy, {
    border = false,
    min_filter = GL.NEAREST,
    mag_filter = GL.NEAREST,
  })

  -- debug?
  if (screencopy == nil) then
    Spring.Echo("blur api: texture error")
    widgetHandler:RemoveWidget()
    return false
  end

  focusLoc      = gl.GetUniformLocation(dofShader,"focus")
  focusRangeLoc = gl.GetUniformLocation(dofShader,"focusRange")
  viewXLoc = gl.GetUniformLocation(dofShader,"viewX")
  viewYLoc = gl.GetUniformLocation(dofShader,"viewY")
  qualityLoc = gl.GetUniformLocation(dofShader,"quality")
  intensityLoc = gl.GetUniformLocation(dofShader,"intensity")
  focusCurveExpLoc = gl.GetUniformLocation(dofShader,"focusCurveExp")
  focusRangeMultiplierLoc = gl.GetUniformLocation(dofShader,"focusRangeMultiplier")
end


function widget:Shutdown()
  if (gl.DeleteTextureFBO) then
    gl.DeleteTexture(depthcopy)
    gl.DeleteTexture(screencopy)
    gl.DeleteTextureFBO(blurtex)
    gl.DeleteTextureFBO(blurtex2)
  end
  if (gl.DeleteShader) then
    gl.DeleteShader(blurShader or 0)
    gl.DeleteShader(dofShader or 0)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:DrawScreenEffects()
  local zfocus = 0.9995

  local msx,msy = widgetHandler:GetViewSizes()
  msx,msy = 0.5*msx,0.5*msy
  local type,mpos = Spring.TraceScreenRay(msx,msy,true)
  if (type=="ground") then
    _,_,zfocus  = Spring.WorldToScreenCoords(mpos[1],mpos[2],mpos[3])
  end
  
  viewX,viewY = gl.GetViewSizes()
  
  local focusRange = 0.8*(1-zfocus) -- + ((1-zfocus)*(1-zfocus)*10)
  --zfocus = zfocus - zfocus^10000

    gl.CopyToTexture(depthcopy, 0, 0, 0, 0, vsx, vsy)
    gl.CopyToTexture(screencopy, 0, 0, 0, 0, vsx, vsy)

    gl.Texture(screencopy)

    gl.UseShader(dofShader)
      gl.Uniform(focusLoc,zfocus)
      gl.Uniform(focusRangeLoc,1/focusRange)
	  gl.Uniform(viewXLoc,viewX)
	  gl.Uniform(viewYLoc,viewY)
	  gl.Uniform(qualityLoc,options.quality.value)
	  gl.Uniform(intensityLoc,options.intensity.value)
	  gl.Uniform(focusCurveExpLoc,options.focusCurveExp.value)
	  gl.Uniform(focusRangeMultiplierLoc,options.focusRangeMultiplier.value)
    gl.Texture(0,screencopy)
    gl.Texture(2,depthcopy)
    gl.TexRect(0,vsy,vsx,0)

    gl.Texture(0,false)
    gl.Texture(1,false)
    gl.Texture(2,false)
    gl.UseShader(0)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
