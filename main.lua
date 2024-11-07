LOVE = require "love"

------------------Window-Variables-----------------------
DESIGNWIDTH = 960
DESIGNHEIGHT = 540
TILESIZE = 24

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
   current_screen.update(dt)
end

---------------------------DRAW---------------------------
function LOVE.draw ()
   current_screen.draw()

   if DEVHELP then
      if DEVHELP.gridmode then
         DEVHELP.showGrid()
      elseif DEVHELP.debugmode then
         DEVHELP.showSystemMetrics()
      end
   end

   LOVE.graphics.setColor(1, 1, 1, 1)
end

-----------------------INPUT-EVENTS---------------------
function love.keypressed (key, scancode, isrepeat)
   if key == "escape" then
      LOVE.event.quit()
   elseif key == "f" then
      LOVE.window.setFullscreen(not LOVE.window.getFullscreen())
      print(LOVE.window.getDesktopDimensions())
   end

   if DEVHELP then
      if key == "g" then
         DEVHELP.gridmode = not DEVHELP.gridmode
      elseif key == "d" then
         DEVHELP.debugmode = not DEVHELP.debugmode
      end
   end
end

function love.mousepressed (x, y, button, istouch, presses)
   print("mouse")
   current_screen.onMouseClick(x, y, button)
end