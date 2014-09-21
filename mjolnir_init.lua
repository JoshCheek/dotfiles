-- https://github.com/sdegutis/mjolnir
-- in case he deletes it: https://github.com/JoshCheek/mjolnir/
--
-- this file goes in: ~/.mjolnir/init.lua


----- GENERAL NOTES -----
--
-- console:
--   muast assign all vars as globals or they don't show
--
-- frame has:
--   x (distance from left side of screen)
--   y (distance from top of screen)
--   w (width)
--   h (height)
--
-- docs:
--   dash
--   https://github.com/sdegutis/mjolnir/blob/master/mods
--
-- Other things I can require:
--   local Application = require "mjolnir.application"
--   local Fnutils = require "mjolnir.fnutils"
--   local Screen = require "mjolnir.screen"


----- REQUIRE HELPER LIBS -----
local Hotkey = require "mjolnir.hotkey"
local Window = require "mjolnir.window"


----- HELPER FUNCTIONS -----
local half = function(n) return n / 2 end
local zero = function(n) return 0     end
local full = function(n) return n     end


----- FINDING WINDOWS -----
local currentWindow = function()
  return Window.focusedwindow()
end


----- FUNCTIONS TO MOVE WINDOWS AROUND -----
-- might be nice to have a vertical half and horizontal half
-- I'd probably need to figure out how to make my own classes in order to do this
-- and not be totally annoyed by it, though.

local windowFromScreen = function(win, transformations)
  local windowFrame = win:frame()
  local screenFrame = win:screen():frame()
  local width       = screenFrame.x + screenFrame.w
  local height      = screenFrame.y + screenFrame.h

  if transformations.x then windowFrame.x = transformations.x(width)  end
  if transformations.w then windowFrame.w = transformations.w(width)  end
  if transformations.y then windowFrame.y = transformations.y(height) end
  if transformations.h then windowFrame.h = transformations.h(height) end
  win:setframe(windowFrame)
end

local windowTopLeft = function(win)
  windowFromScreen(win, {x=zero, y=zero, w=half, h=half})
end

local windowTopRight = function(win)
  windowFromScreen(win, {x=half, y=zero, w=half, h=half})
end

local windowBotLeft = function(win)
  windowFromScreen(win, {x=zero, y=half, w=half, h=half})
end

local windowBotRight = function(win)
  windowFromScreen(win, {x=half, y=half, w=half, h=half})
end

local windowFullScreen = function(win)
  windowFromScreen(win, {x=zero, y=zero, w=full, h=full})
end

local windowLeft = function(win)
  windowFromScreen(win, {x=zero, y=zero, w=half, h=full})
end

local windowRight = function(win)
  windowFromScreen(win, {x=half, y=zero, w=half, h=full})
end

local windowTop = function(win)
  windowFromScreen(win, {x=zero, y=zero, w=full, h=half})
end

local windowBot = function(win)
  windowFromScreen(win, {x=zero, y=half, w=full, h=half})
end


----- HOTKEYS -----
local forWindow = function(win, f)
  return function()
    f(win())
  end
end

local mash = {"cmd", "alt", "ctrl"}

Hotkey.bind(mash, "F", forWindow(currentWindow, windowFullScreen))
Hotkey.bind(mash, "L", forWindow(currentWindow, windowLeft))
Hotkey.bind(mash, "R", forWindow(currentWindow, windowRight))
Hotkey.bind(mash, "T", forWindow(currentWindow, windowTop))
Hotkey.bind(mash, "B", forWindow(currentWindow, windowBot))
Hotkey.bind(mash, "1", forWindow(currentWindow, windowTopLeft))
Hotkey.bind(mash, "2", forWindow(currentWindow, windowTopRight))
Hotkey.bind(mash, "3", forWindow(currentWindow, windowBotRight))
Hotkey.bind(mash, "4", forWindow(currentWindow, windowBotLeft))

