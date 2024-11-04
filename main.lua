LOVE = require "love"

------------------Graphic-Variables-----------------------
local designwidth = 1280
local designheight = 720
local scalefactor = 2
local translationfactor = {x = 2, y = 2}

--------------------Asset-Variables-----------------------
local images = {}
local font = nil

---------------------------LOAD---------------------------
function LOVE.load (args)
   love.graphics.setDefaultFilter("nearest", "nearest")

   images.bg = love.graphics.newImage("assets/background.png")
   images.maptools = love.graphics.newImage("assets/map_tools.png")
   font = love.graphics.newFont("assets/pixelfont.otf")
end

-------------------------UPDATE---------------------------
function LOVE.update (dt)
end

---------------------------DRAW---------------------------
function LOVE.draw ()
   love.graphics.draw(images.bg)
end

-----------------------KEYBOARD-EVENTS---------------------
function love.keypressed (key, scancode, isrepeat)
   if key == "escape" then
      LOVE.event.quit()
   elseif key == "f" then
      LOVE.window.setFullscreen(not LOVE.window.getFullscreen())
   end
end