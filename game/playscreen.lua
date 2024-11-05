local Map = require "game/Map"

---------------------Internal-------------------
local images = {
   bg = LOVE.graphics.newImage("assets/background.png"),
   msgfont = LOVE.graphics.newFont("assets/pixelfont.otf")
}

local enemymap = Map:new(Map.types.enemy)
local playermap = Map:new(Map.types.player)

--------------------External--------------------
local playscreen = {}

function playscreen.update (dt)
   enemymap:update(dt)
   playermap:update(dt)
end

function playscreen.draw ()
   LOVE.graphics.draw(images.bg)
   enemymap:draw()
   playermap:draw()
end

return playscreen