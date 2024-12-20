if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
   require("lldebugger").start()
end

LOVE = require "love"
------------------Window-Variables-----------------------
DESIGNWIDTH = 960
DESIGNHEIGHT = 540
TILESIZE = 24

local translationfactor = {x = 1, y = 1}
SCALEFACTOR = 1
INPUTCORRECTION = 1 / SCALEFACTOR

local current_screen = {draw = function (scale) LOVE.graphics.clear(1, 0, 0, 1) end}

---------------------------LOAD---------------------------

function CHANGE_SCREEN (screen)
   current_screen = nil
   collectgarbage()
   current_screen = screen
   current_screen.reset()
end

function LOVE.load (arg)
   for _, option in pairs(arg) do
      if option == "-d" then
         DEVHELP = require "engine/devhelp"
      end
   end

   LOVE.graphics.setDefaultFilter("nearest", "nearest")

   SCREENS = {
      titlescreen = require "game.titlescreen",
      playscreen = require "game.playscreen"
   }

   CHANGE_SCREEN(SCREENS.titlescreen)

   collectgarbage()
end

-------------------------UPDATE---------------------------
function LOVE.update (dt)
   current_screen.update(dt)
end

---------------------------DRAW---------------------------
function LOVE.draw ()
   LOVE.graphics.clear(0, 0, 0, 1)
   LOVE.graphics.push()
   LOVE.graphics.translate(translationfactor.x, translationfactor.y)
   LOVE.graphics.scale(SCALEFACTOR, SCALEFACTOR)

   current_screen.draw(SCALEFACTOR)

   if DEVHELP then
      if DEVHELP.gridmode then
         DEVHELP.showGrid()
      elseif DEVHELP.debugmode then
         DEVHELP.showSystemMetrics()
      end
   end

   LOVE.graphics.scale(1 / SCALEFACTOR, 1 / SCALEFACTOR)
   LOVE.graphics.translate(-translationfactor.x, -translationfactor.y)
   LOVE.graphics.pop()

   LOVE.graphics.setColor(1, 1, 1, 1)
end

-----------------------INPUT-EVENTS---------------------
function LOVE.keypressed (key, scancode, isrepeat)
   if key == "escape" then
      LOVE.event.quit()
   elseif key == "f" then
      LOVE.window.setFullscreen(not LOVE.window.getFullscreen())

      if LOVE.window.getFullscreen() then
         local screenw, screenh = LOVE.window.getDesktopDimensions()
         local aspectratio = screenw / screenh

         if aspectratio > 1 then
            SCALEFACTOR = math.floor(screenh / DESIGNHEIGHT)
         else
            SCALEFACTOR = math.floor(screenw / DESIGNWIDTH)
         end

         translationfactor.x = math.floor(screenw / 2 - (SCALEFACTOR * DESIGNWIDTH) / 2)
         translationfactor.y = math.floor(screenh / 2 - (SCALEFACTOR * DESIGNHEIGHT) / 2)

         INPUTCORRECTION = 1 / SCALEFACTOR
      else
         SCALEFACTOR = 1
         translationfactor.x = 1
         translationfactor.y = 1

         INPUTCORRECTION = 1 / SCALEFACTOR
      end
   end

   if DEVHELP then
      if key == "g" then
         DEVHELP.gridmode = not DEVHELP.gridmode
      elseif key == "d" then
         DEVHELP.debugmode = not DEVHELP.debugmode
      elseif key == "w" then
         PLAYER_WON = true
      elseif key == "l" then
         PLAYER_LOST = true
      end
   end
end

function LOVE.mousepressed (x, y, button, istouch, presses)
   if SCALEFACTOR ~= 1 then
      x = x * INPUTCORRECTION
      y = y * INPUTCORRECTION
   end
   current_screen.onMouseClick(x, y, button)
end