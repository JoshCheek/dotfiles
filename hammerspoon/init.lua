----- Config Reloading -----
hs.hotkey.bind({"cmd", "alt", "ctrl"}, ";", function() hs.reload() end)
hs.alert.show("Hammerspoon Config loaded")

----- Window Management -----
-- There's a grid class, but I'm not using it, b/c it puts things in the wrong places
-- namely, my dock is hidden, but it allocates space to the dock
-- "screen" means "monitor", "frame"  means "dimensions"
function windowAdjuster(x, y, w, h)
  return function()
    local duration    = 0 -- don't animate
    local window      = hs.window.frontmostWindow()
    local screen      = window:screen()
    local frameUsable = screen:frame()     -- no dock / menu
    local frameFull   = screen:fullFrame() -- b/c the above calculates width wrong
    local heightGap   = frameFull.h - frameUsable.h
    local frame       = {
      x = x*frameFull.w/2,
      y = y*frameUsable.h/2 + heightGap,
      w = w*frameFull.w/2,
      h = h*frameUsable.h/2,
    }
    window:setFrame(frame, duration)
  end
end

local mash = {"cmd", "alt", "ctrl"}
hs.hotkey.bind(mash, "F", windowAdjuster(0, 0, 2, 2))
hs.hotkey.bind(mash, "L", windowAdjuster(0, 0, 1, 2))
hs.hotkey.bind(mash, "R", windowAdjuster(1, 0, 1, 2))
hs.hotkey.bind(mash, "T", windowAdjuster(0, 0, 2, 1))
hs.hotkey.bind(mash, "B", windowAdjuster(0, 1, 2, 1))
hs.hotkey.bind(mash, "1", windowAdjuster(0, 0, 1, 1))
hs.hotkey.bind(mash, "2", windowAdjuster(1, 0, 1, 1))
hs.hotkey.bind(mash, "3", windowAdjuster(1, 1, 1, 1))
hs.hotkey.bind(mash, "4", windowAdjuster(0, 1, 1, 1))


-- ----- Hello world -----
-- -- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
-- --   -- big text in the middle of the screen
-- --   hs.alert.show("Hello World!")
-- --
-- --   -- notification in the top-right
-- --   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- -- end)


-- ----- App Management -----
-- -- hs.application.launchOrFocus("Safari")
-- -- local safari = hs.appfinder.appFromName("Safari")

----- Caffeinate -----
-- http://www.hammerspoon.org/docs/hs.menubar.html
-- http://www.hammerspoon.org/docs/hs.caffeinate.html
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  -- See also setIcon: http://www.hammerspoon.org/docs/hs.menubar.html#setIcon
  if state then
    caffeine:setTitle("☕️")
  else
    caffeine:setTitle("😴")
  end
end

if caffeine then
  caffeine:setClickCallback(function()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
  end)
  hs.caffeinate.set("displayIdle", true)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end


-- ----- Application Watcher -----
-- -- appWatcher = hs.application.watcher.new(function()
-- --   if (eventType == hs.application.watcher.activated) then
-- --     if (appName == "Finder") then
-- --       -- Bring all Finder windows forward when one gets activated
-- --       appObject:selectMenuItem({"Window", "Bring All to Front"})
-- --     end
-- --   end
-- -- end)
-- -- appWatcher:start()

-- ----- Defeating Paste Blockers -----
-- -- hs.hotkey.bind({"cmd", "alt"}, "V", function()
-- -- 	hs.eventtap.keyStrokes(hs.pasteboard.getContents())
-- -- end)


-- ----- Drawing on around the mouse pointer -----
-- mouseCircle = nil
-- mouseCircleTimer = nil

-- function mouseHighlight()
--   -- Delete an existing highlight if it exists
--   if mouseCircle then
--     mouseCircle:delete()
--     if mouseCircleTimer then
--       mouseCircleTimer:stop()
--     end
--   end
--   -- Get the current co-ordinates of the mouse pointer
--   mousepoint = hs.mouse.getAbsolutePosition()
--   -- Prepare a big red circle around the mouse pointer
--   mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
--   mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
--   mouseCircle:setFill(false)
--   mouseCircle:setStrokeWidth(5)
--   mouseCircle:show()

--   -- Set a timer to delete the circle after 3 seconds
--   mouseCircleTimer = hs.timer.doAfter(3, function()
--     mouseCircle:delete()
--   end)
-- end
-- hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)
