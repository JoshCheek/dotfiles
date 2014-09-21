-- https://github.com/sdegutis/mjolnir
-- in case he deletes it: https://github.com/JoshCheek/mjolnir/
--
-- this file goes in: ~/.mjolnir/init.lua


----- GENERAL NOTES -----
--  helpers:
--    function ks(t) for k, v in pairs(t) do print(k) end end
--    print(whatever)
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
--   local Screen  = require "mjolnir.screen"
--   local Hotkey  = require "mjolnir.hotkey"
--   local Window  = require "mjolnir.window"


----- HELPER FUNCTIONS -----
local half = function(n) return n / 2 end
local zero = function(n) return 0     end
local full = function(n) return n     end


----- FUNCTIONS TO MOVE WINDOWS AROUND -----
-- might be nice to have a vertical half and horizontal half
-- I'd probably need to figure out how to make my own classes in order to do this
-- and not be totally annoyed by it, though.

local newFrame = function(frame, sizes, transformations)
  frame.x = transformations.x(sizes.width)
  frame.w = transformations.w(sizes.width)
  frame.y = transformations.y(sizes.height)
  frame.h = transformations.h(sizes.height)
  return frame
end

local windowTopLeft = function(frame, sizes)
  return newFrame(frame, sizes, {x=zero, y=zero, w=half, h=half})
end

local windowTopRight = function(frame, sizes)
  return newFrame(frame, sizes, {x=half, y=zero, w=half, h=half})
end

local windowBotLeft = function(frame, sizes)
  return newFrame(frame, sizes, {x=zero, y=half, w=half, h=half})
end

local windowBotRight = function(frame, sizes)
  return newFrame(frame, sizes, {x=half, y=half, w=half, h=half})
end

local windowFullScreen = function(frame, sizes)
  return newFrame(frame, sizes, {x=zero, y=zero, w=full, h=full})
end

local windowLeft = function(frame, sizes)
  return newFrame(frame, sizes, {x=zero, y=zero, w=half, h=full})
end

local windowRight = function(frame, sizes)
  return newFrame(frame, sizes, {x=half, y=zero, w=half, h=full})
end

local windowTop = function(frame, sizes)
  return newFrame(frame, sizes, {x=zero, y=zero, w=full, h=half})
end

local windowBot = function(frame, sizes)
  return newFrame(frame, sizes, {x=zero, y=half, w=full, h=half})
end


----- WINDOW MANAGEMENT -----
local Window = require "mjolnir.window"
local currentWindow = function()
  return Window.focusedwindow()
end

local updateWindow = function(getWindow, f)
  return function()
    local window      = getWindow()
    local screenFrame = window:screen():frame()
    local newFrame    = f(window:frame(), {width  = (screenFrame.x + screenFrame.w),
                                           height = (screenFrame.y + screenFrame.h)})
    window:setframe(newFrame)
  end
end


----- HOTKEYS -----
local mash = {"cmd", "alt", "ctrl"}

local Hotkey = require "mjolnir.hotkey"
Hotkey.bind(mash, "F", updateWindow(currentWindow, windowFullScreen))
Hotkey.bind(mash, "L", updateWindow(currentWindow, windowLeft))
Hotkey.bind(mash, "R", updateWindow(currentWindow, windowRight))
Hotkey.bind(mash, "T", updateWindow(currentWindow, windowTop))
Hotkey.bind(mash, "B", updateWindow(currentWindow, windowBot))
Hotkey.bind(mash, "1", updateWindow(currentWindow, windowTopLeft))
Hotkey.bind(mash, "2", updateWindow(currentWindow, windowTopRight))
Hotkey.bind(mash, "3", updateWindow(currentWindow, windowBotRight))
Hotkey.bind(mash, "4", updateWindow(currentWindow, windowBotLeft))

