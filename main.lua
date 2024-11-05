LOVE = require "love"

------------------Graphic-Variables-----------------------
local designwidth = 1280
local designheight = 720

local current_screen = {draw = function () LOVE.graphics.clear(1, 0, 0, 1) end}

---------------------------LOAD---------------------------
function LOVE.load (arg)
   for _, option in pairs(arg) do
      if option == "-d" then
         DEVHELP = require "engine/devhelp"
      end
   end

   love.graphics.setDefaultFilter("nearest", "nearest")

   current_screen = require "game/playscreen"

   collectgarbage()
end

-------------------------UPDATE---------------------------
function LOVE.update (dt)
end

---------------------------DRAW---------------------------
function LOVE.draw ()
   current_screen.draw()

   if DEVHELP and DEVHELP.active then
      DEVHELP.showGrid()
   end
end

-----------------------KEYBOARD-EVENTS---------------------
function love.keypressed (key, scancode, isrepeat)
   if key == "escape" then
      LOVE.event.quit()
   elseif key == "f" then
      LOVE.window.setFullscreen(not LOVE.window.getFullscreen())
   end

   if DEVHELP then
      if key == "g" then
         DEVHELP.active = true
      end
   end
end