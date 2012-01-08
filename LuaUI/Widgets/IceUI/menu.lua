local hideMenu = function()
  menuWindow:SetVisibility(false)
end

local function newButton(caption, func)
  return button:New({
    caption = caption,
    OnPress = function()
      func()
      hideMenu()
    end
  })
end

local menuButton = {}

local displayMenu = function()
  if menuWindow == nil then
    menuWindow = window:New(
      "gameMenu",
      frames:New("rows", {
        newButton("Widgets", function()
          for _,v in ipairs(windowManager.children) do
            if v.name == "widget selector" then
              v:SetVisibility()
              return
            end
          end
          Spring.SendCommands({"luaui selector"})
        end),
        newButton("Options", function()
          Spring.SendCommands({"luaui tweakgui"})
        end),
        newButton("Screenshot", function()
          Spring.SendCommands({"screenshot"})
        end),
        newButton("Pause", function()
          Spring.SendCommands({"pause"})
        end),
        newButton("Exit", function()
          Spring.SendCommands({"quit"})
        end),
        newButton("Cancel", function() end)
      }),
      { 95/1280, 146/800 }, { 229/1280, 26/800 }
    )

    -- hide menu with ESC
    function menuWindow:KeyPress(key, isRepeat)
      local a,c,m,s = Spring.GetModKeyState()
      if not a and not c and not m and not s and self.visible and key == 27 then -- ESC
        self:SetVisibility(false)
        return true
      end
    end
  else
    menuWindow:SetVisibility()
  end
  local _, screenH = Spring.GetViewGeometry()
  menuWindow:MoveTo(menuButton:GetX(), screenH - 1 - menuButton:GetB())
end

menuButton = window:New(
  "Game Menu",
  margin:New(
    button:New({
      caption = "Menu",
      OnPress = displayMenu
    })
  ),
  { 95/1280, 24/800 }, { 229/1280, 1 }
)
