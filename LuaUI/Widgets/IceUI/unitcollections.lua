local QCount = {}
local NEAR_IDLE = 0 -- this means that factories with only 0 build items left will be shown as idle (will use this later)

-- taken from gui_idle_builders_new.lua by Ray
local function IsIdleBuilder(unitID)
  local udef = Spring.GetUnitDefID(unitID)
  local ud = UnitDefs[udef]
        local qCount = 0
  if ud.buildSpeed > 0 then  --- can build
    local bQueue = Spring.GetFullBuildQueue(unitID)
    if not bQueue[1] then  --- has no build queue
      local _, _, _, _, buildProg = Spring.GetUnitHealth(unitID)
      if buildProg == 1 then  --- isnt under construction
        if ud.isFactory then
          return true
        else
          local cQueue = Spring.GetCommandQueue(unitID)
          if not cQueue[1] then
            return true
          end
        end
      end
                elseif ud.isFactory then
                        for _, thing in ipairs(bQueue) do
                                for _, count in pairs(thing) do
                                        qCount = qCount + count
                                end
                        end
                        if qCount <= NEAR_IDLE then
                                QCount[unitID] = qCount
                                return true
                        end
    end
  end
  return false
end



local content = {
  {
    caption = 'Idle',
    UnitFilter = IsIdleBuilder,
    GetCaption = function(unitID)
      return ''
    end,
    GetProgress = function(unitID)
      return 1
    end
  },
  {
    caption = 'Stockpile',
    UnitFilter = function(unitID)
      return UnitDefs[Spring.GetUnitDefID(unitID) or -1].canStockpile
    end,
    GetCaption = function(unitID)
      return Spring.GetUnitStockpile(unitID)
    end,
    GetProgress = function(unitID)
      local _,_,progress = Spring.GetUnitStockpile(unitID)
      return progress
    end
  },
  {
    caption = 'Building',
    UnitFilter = function(unitID)
      local _,_,_,_,build = Spring.GetUnitHealth(unitID)
      return build<1
    end,
    GetCaption = function(unitID)
      local _,_,_,_,build = Spring.GetUnitHealth(unitID)
      return math.floor(build*100)..'%'
    end,
    GetProgress = function(unitID)
      local _,_,_,_,build = Spring.GetUnitHealth(unitID)
      return build
    end,
    --middleClick = { 'make this highest priority (doesn\'t work yet)', function(unitID)
    --  Spring.Echo(unitID)
    --end}
  },
  {
    caption = 'Damaged',
    UnitFilter = function(unitID)
      local health,maxHealth,_,_,build = Spring.GetUnitHealth(unitID)
      return health/maxHealth<.8 and build==1
    end,
    GetCaption = function(unitID)
      local health,maxHealth,_,_,build = Spring.GetUnitHealth(unitID)
      return math.floor(health/maxHealth*100)..'%'
    end,
    GetProgress = function(unitID)
      local health,maxHealth,_,_,build = Spring.GetUnitHealth(unitID)
      return health/maxHealth
    end
  }
}

local unitcoll = window:New(
  "Unit Collections",
  color:New(),
  {84/1024, 84/768}, {-54/1024, 256/768}
)

unitcoll.options = {
  horizontal = {
    name  = "Horizontal",
    desc  = "Arrange icons horizontally.",
    type  = "bool",
    value = false,
    OnChange = function(self)
      unitcoll:ResizesItself(self.value, not self.value)
    end
  },
  maxCount = {
    name  = "Maximum amount of icons",
    desc  = "To avoid going off screen, the unit collections window can only display a certain amount of icons.",
    type  = 'number', min = 5, max = 40, step = 1,
    value = 12
  }
}
unitcoll:ResizesItself(false, true)

function unitcoll:Initialize()
  local tabContent = {}
  local tabCaptions = {}
  for _,tab in ipairs(content) do
    local caption = tab.caption
    local container = free:New()
    container.updateEvery = 10
    container.Update = function(self)
      if not self:GetWindow().visible then
        return
      end
      local units = Spring.GetTeamUnits(Spring.GetMyTeamID())
      local count = 0
      self:DestroyChildren()
      for _,unitID in ipairs(units) do
        if count < unitcoll.options.maxCount.value and tab.UnitFilter(unitID) then
          count = count + 1
          local pic = buildpic:New(Spring.GetUnitDefID(unitID))
          pic:AddCommand(command:New({
            button = 1,
            desc = 'select this unit',
            OnPress = function(self)
              Spring.SelectUnitArray({ unitID })
            end
          }))
          pic:AddCommand(command:New({
            button = 1,
            shift = true,
            desc = 'add this unit to selection',
            OnPress = function(self)
              Spring.SelectUnitArray({ unitID }, true)
            end
          }))
          if tab.middleClick ~= nil then
            pic:AddCommand(command:New({
              button = 2,
              desc = tab.middleClick[1],
              OnPress = function(self)
                tab.middleClick[2](unitID)
              end
            }))
          end
          pic:AddCommand(command:New({
            button = 3,
            desc = 'go to this unit',
            OnPress = function(self)
              Spring.SetCameraTarget(Spring.GetUnitPosition(unitID))
            end
          }))

          self:SetContent(pic, count*3-2)
          self:SetContent(progress:New(tab.GetProgress(unitID)), count*3-1)
          self:SetContent(text:New({text=tab.GetCaption(unitID),align='center',valign='bottom'}), count*3)
          if self:GetWindow().options.horizontal.value then
            for i=0,2 do
              self[count*3-i]:ResizeTo(self:GetH(), nil)
              self[count*3-i]:MoveTo(self:GetH()*(count-1), nil)
            end
          else
            for i=0,2 do
              self[count*3-i]:ResizeTo(nil, self:GetW())
              self[count*3-i]:MoveTo(nil, self:GetW()*(count-1))
            end
          end
        end
      end
      if self:GetWindow().options.horizontal.value then
        if count > 0 then
          self:GetWindow():ResizeTo(self:GetH()*count + 2, false)
        else
          self:SetContent(empty:New(), 1)
          self:GetWindow():ResizeTo(self:GetWindow():GetH() - 20, false)
        end
      else
        if count > 0 then
          self:GetWindow():ResizeTo(false, self:GetW()*count + 2 + 20)
        else
          self:SetContent(empty:New(), 1)
          self:GetWindow():ResizeTo(false, self:GetWindow():GetW() + 20)
        end
      end
    end
    table.insert(tabContent, container)
    table.insert(tabCaptions, caption)
  end
  self:SetContent(tabs:New(tabContent, tabCaptions, 'etc_tabs'))
end
