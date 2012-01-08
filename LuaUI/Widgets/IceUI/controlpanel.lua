local PageNumCmd = {
  name    = "1",
  texture = "",
  tooltip = "Active Page Number\n(click to toggle buildiconsfirst)",
  actions = { "buildiconsfirst", "firstmenu" }
}
local function NoTextureHandler(xIcons, yIcons, cmdCount, commands)
  -- default handler from trepans layout.lua (this one has textures disabled)
  include("colors.h.lua")

  local FrameTex   = ""
  local FrameScale = "&0.1x0.1&"

  widgetHandler.commands   = commands
  widgetHandler.commands.n = cmdCount
  widgetHandler:CommandsChanged()

  -- FIXME: custom commands  
  if (cmdCount <= 0) then
    return "", xIcons, yIcons, {}, {}, {}, {}, {}, {}, {}, {}
  end
  
  local menuName = ''
  local removeCmds = {}
  local customCmds = widgetHandler.customCommands
  local onlyTexCmds = {}
  local reTexCmds = {}
  local reNamedCmds = {}
  local reTooltipCmds = {}
  local reParamsCmds = {}
  local iconList = {}

  local cmdsFirst = (commands[1].id >= 0)

  if (showPanelLabel) then
    if (cmdsFirst) then
      menuName =   RedStr .. 'Commands'
    else
      menuName = GreenStr .. 'Build Orders'
    end
  end

  local ipp = (xIcons * yIcons)  -- iconsPerPage

  local prevCmd = cmdCount - 1
  local nextCmd = cmdCount - 0
  local prevPos = ipp - xIcons
  local nextPos = ipp - 1
  if (prevCmd >= 1) then reTexCmds[prevCmd] = FrameTex end
  if (nextCmd >= 1) then reTexCmds[nextCmd] = FrameTex end

  local pageNumCmd = -1
  local pageNumPos = (prevPos + nextPos) / 2
  if (xIcons > 2) then
    local color
    if (commands[1].id < 0) then color = GreenStr else color = RedStr end
    local activePage = Spring.GetActivePage() or 0
    local pageNum = '' .. (activePage + 1) .. ''
    
    PageNumCmd.name = color .. '   ' .. pageNum .. '   '
    table.insert(customCmds, PageNumCmd)
    pageNumCmd = cmdCount + 1
  end

  local pos = 0;
  local firstSpecial = (xIcons * (yIcons - 1))

  for cmdSlot = 1, (cmdCount - 2) do

    -- fill the last row with special buttons
    while ((pos % ipp) >= firstSpecial) do
      pos = pos + 1
    end
    local onLastRow = (math.abs(pos % ipp) < 0.1)

    if (onLastRow) then
      local pageStart = math.floor(ipp * math.floor(pos / ipp))
      if (pageStart > 0) then
        iconList[prevPos + pageStart] = prevCmd
        iconList[nextPos + pageStart] = nextCmd
        if (pageNumCmd > 0) then
          iconList[pageNumPos + pageStart] = pageNumCmd
        end
      end
      if (pageStart == ipp) then
        iconList[prevPos] = prevCmd
        iconList[nextPos] = nextCmd
        if (pageNumCmd > 0) then
          iconList[pageNumPos] = pageNumCmd
        end
      end
    end

    -- add the command icons to iconList
    local cmd = commands[cmdSlot]

    if ((cmd ~= nil) and (cmd.hidden == false)) then

      iconList[pos] = cmdSlot
      pos = pos + 1

      local cmdTex = cmd.texture
      if (#cmdTex > 0) then
        if (cmdTex:byte(1) ~= 38) then  --  '&' == 38
          reTexCmds[cmdSlot] = FrameScale..cmdTex..'&'..FrameTex
        end
      else
        if (cmd.id >= 0) then
          reTexCmds[cmdSlot] = FrameTex
        else
          reTexCmds[cmdSlot] = FrameScale..'#'..(-cmd.id)..'&'..FrameTex
          table.insert(onlyTexCmds, cmdSlot)
        end
      end

      if (translations) then
        local trans = translations[cmd.id]
        if (trans) then
          reTooltipCmds[cmdSlot] = trans.desc
          if (not trans.params) then
            if (cmd.id ~= CMD.STOCKPILE) then
              reNamedCmds[cmdSlot] = trans.name
            end
          else
            local num = tonumber(cmd.params[1])
            if (num) then
              num = (num + 1)
              cmd.params[num] = trans.params[num]
              reParamsCmds[cmdSlot] = cmd.params
            end
          end
        end
      end
    end
  end

  return menuName, xIcons, yIcons,
         removeCmds, customCmds,
         onlyTexCmds, reTexCmds,
         reNamedCmds, reTooltipCmds, reParamsCmds,
         iconList
end
local controlPanel = window:New(
  "Control Panel",
  empty:New(),
  { 0.17656250298023, 0.69875001907349 }, { 0.0015625000232831, 0.21375000476837 }
)


local function getAspectRatio(selectedRatio)
  local nonSquare = {
    ca = 4/3
  }

  if type(selectedRatio) == 'number' then
    return selectedRatio
  elseif selectedRatio == 'preset' then
    return nonSquare[Game.modShortName] or 1
  else
    return 1
  end
end


controlPanel.options = {
  buildiconsfirst = {
    name  = 'Display build icons first',
    desc  = 'Do you want build icons or commands at the top of the panel?',
    type  = 'bool',
    value = Spring.GetConfigInt('BuildIconsFirst') == 1,

    OnChange = function(self)
      local gotSelection = #Spring.GetSelectedUnits() > 0
      Spring.SetConfigInt('BuildIconsFirst', self.value and 1 or 0)

      if not gotSelection then
        Spring.SelectUnitArray({Spring.GetTeamUnits(Spring.GetMyTeamID())[1]})
      end

      windowManager:CallInXFrames(2, function()
        Spring.SendCommands("buildiconsfirst")
        if not gotSelection then
          Spring.SelectUnitArray({})
        end
      end)
    end
  },
  removeTextures = {
    name  = 'Remove textures',
    desc  = 'If checked, IceUI replaces the default layout handler with one that disables the background textures.',
    type  = 'bool',
    value = false,
    OnChange = function(self)
      if self.value then
        widgetHandler:ConfigLayoutHandler(NoTextureHandler)
      else
        widgetHandler:ConfigLayoutHandler(true)
      end
    end
  },
  outlinefont = {
    name  = 'Outline font',
    desc  = 'Should the font on the control panel be outlined?',
    type  = 'bool',
    value = false
  },
  dropShadows = {
    name  = 'Dropshadows',
    desc  = 'Should the font on the control have a dropshadow?',
    type  = 'bool',
    value = true
  },
  useOptionLEDs = {
    name  = 'Use option LEDs',
    desc  = 'Display LEDs underneath buttons that have several states (like On/Off, Hold/Maneuver/Roam).',
    type  = 'bool',
    value = true
  },
  selectGaps = {
    name  = 'Select through icon margin',
    desc  = 'Should the margin between icons let mouse clicks through or should they belong to the icon?',
    type  = 'bool',
    value = true
  },
  selectThrough = {
    name  = 'Select through',
    desc  = 'Do you want to be able to give orders and select units if you click on unoccupied space of the control panel?',
    type  = 'bool',
    value = false
  },
  newAttackMode = {
    name  = 'Area attack',
    desc  = 'If selected, you can drag a circle or rectangle to attack all enemies in the area in turn.\n'..
            'Listed because it\'s also configured through ctrlpanel.txt.',
    type  = 'bool',
    value = true
  },
  attackRect = {
    name  = 'Rectangular area attack',
    desc  = 'Use a rectangle instead of a circle for an area attack order.\n'..
            'Listed because it\'s also configured through ctrlpanel.txt.',
    type  = 'bool',
    value = true
  },
  invColorSelect = {
    name  = 'Rectangular area attack - inverted color',
    desc  = 'When using rectangular area attack, this inverts the colors of the highlighted terrain.\n'..
            'Listed because it\'s also configured through ctrlpanel.txt.',
    type  = 'bool',
    value = true
  },
  frontByEnds = {
    name  = 'Line move - end to end',
    desc  = 'When ordering units to move into a line, this lets you select the end points instead of the middle and one end point.\n'..
            'Listed because it\'s also configured through ctrlpanel.txt. Has no effect if you use the custom formation widget.',
    type  = 'bool',
    value = false
  },
  textureAlpha = {
    name  = 'Buildpic and texture transparency',
    desc  = 'How much of the battlefield do you want to see through the buildpics and textures?',
    type  = 'number', min = 0, max = 100, step = 1,
    value = 80
  },
  textBorder = {
    name  = 'Text margin',
    desc  = 'How much space should be between the text of the orders and their border?',
    type  = 'number', min = 0, max = 20, step = 1,
    value = 3
  },
  iconBorder = {
    name  = 'Icon margin',
    desc  = 'How much space should be between the individual items?',
    type  = 'number', min = 0, max = 20, step = 1,
    value = 0
  },
  frameBorder = {
    name  = 'Frame margin',
    desc  = 'How much space should be between the buttons and the window frame?',
    type  = 'number', min = 0, max = 20, step = 1,
    value = 0
  },
  aspect = {
    name  = 'Buildpics aspect ratio',
    desc  = 'Most mods use square buildpics but some adapted to the 4:3 ratio used by Springs default control panel.',
    type  = 'list',
    items = {
      { 
        key  = 1,
        name = '1:1',
        desc = '1:1',
      },
      {
        key  = 4/3,
        name = '4:3',
        desc = '4:3',
      },
      {
        key  = 'preset',
        name = 'Preset',
        desc = 'Read the correct aspect ratio from an internal list.\n'..
               'Please tell MelTraX if it\'s wrong for any mod.',
      }
    },
    value = 'preset'
  },
  columns = {
    name  = 'Columns',
    desc  = 'Number of columns.',
    type  = 'number', min = 2, max = 10, step = 1,
    value = 3
  },
  align = {
    name  = 'Vertical align',
    desc  = 'The Vertical alignment of the control panel in its associated window.',
    type  = 'list',
    items = {
      { 
        key  = 1,
        name = 'Top',
        desc = 'Move the control panel to the top of its associated window.',
      },
      {
        key  = 0.5,
        name = 'Middle',
        desc = 'Move the control panel to the middle of its associated window.',
      },
      {
        key  = 0,
        name = 'Bottom',
        desc = 'Move the control panel to the bottom of its associated window.',
      }
    },
    value = 0.5
  }
}

for _,option in pairs(controlPanel.options) do
  if type(option.OnChange) ~= 'function' then
    option.OnChange = function() controlPanel:OnResize() end
  end
end

-- in order to paint under the control panel we need to use DrawScreenEffects instead of DrawScreen
controlPanel.children[1][1][1].DrawScreenEffects = controlPanel.children[1][1][1].DrawScreen
controlPanel.children[1][1][1].DrawScreen = function() end
controlPanel:SetClickthrough(true)

function controlPanel:OnResize()
  local file = io.open('IceUI_ctrlpanel.txt', 'w')
  local cols = self.options.columns.value
  local screenW, screenH = Spring.GetViewGeometry()
  local aspect = getAspectRatio(self.options.aspect.value)

  local x = self:GetX()+1.0
  local b = self:GetB()+1.5
  local w = self:GetW()-2.0-self.options.frameBorder.value*2
  local h = self:GetH()-1.5-self.options.frameBorder.value*2/screenW*screenH

  if file then
    file:write('outlinefont    ' .. (self.options.outlinefont.value and 1 or 0) .. '\n')
    file:write('dropShadows    ' .. (self.options.dropShadows.value and 1 or 0) .. '\n')
    file:write('useOptionLEDs  ' .. (self.options.useOptionLEDs.value and 1 or 0) .. '\n')
    file:write('textureAlpha   ' .. self.options.textureAlpha.value/100 .. '\n')
    file:write('frameAlpha     0\n')
    file:write('selectGaps     ' .. (self.options.selectGaps.value and 1 or 0) .. '\n')
    file:write('selectThrough  ' .. (self.options.selectThrough.value and 1 or 0) .. '\n')

    file:write('newAttackMode  ' .. (self.options.newAttackMode.value and 1 or 0) .. '\n')
    file:write('attackRect     ' .. (self.options.attackRect.value and 1 or 0) .. '\n')
    file:write('invColorSelect ' .. (self.options.invColorSelect.value and 1 or 0) .. '\n')
    file:write('frontByEnds    ' .. (self.options.frontByEnds.value and 1 or 0) .. '\n')

    local yIconSize = w/cols/aspect/screenH - (self.options.iconBorder.value/screenH-self.options.iconBorder.value/screenW)*2
    local yIcons    = math.floor(h/screenH/yIconSize)
    local yOffset   = self.options.align.value*(h/screenH-yIcons*yIconSize)

    file:write('xIcons         ' .. cols .. '\n')
    file:write('yIcons         ' .. yIcons .. '\n')
    file:write('prevPageSlot   auto\n')
    file:write('deadIconSlot   none\n')
    file:write('nextPageSlot   auto\n')
    file:write('xIconSize      ' .. w/cols/screenW-self.options.iconBorder.value/screenW*2 .. '\n')
    file:write('yIconSize      ' .. yIconSize-self.options.iconBorder.value/screenW*2 .. '\n')

    file:write('textBorder     ' .. self.options.textBorder.value/screenW .. '\n')
    file:write('iconBorder     ' .. self.options.iconBorder.value/screenW .. '\n')
    file:write('frameBorder    ' .. self.options.frameBorder.value/screenW .. '\n')

    file:write('xPos           ' .. x/screenW .. '\n')
    file:write('yPos           ' .. b/screenH + yOffset .. '\n')
    file:write('xSelectionPos  -1\n')
    file:write('ySelectionPos  -1\n')

    file:close()
    Spring.SendCommands('ctrlpanel IceUI_ctrlpanel.txt')
    --os.remove('IceUI_ctrlpanel.txt')
  end
end
function controlPanel:Initialize()
  if self.options.removeTextures.value then
    widgetHandler:ConfigLayoutHandler(NoTextureHandler)
  end
end
function controlPanel:Shutdown()
  if self.options.removeTextures.value then
    widgetHandler:ConfigLayoutHandler(true)
  end
end

