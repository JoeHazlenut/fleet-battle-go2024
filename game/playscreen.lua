
---------------------Internal-------------------
local images = {
   bg = LOVE.graphics.newImage("assets/background.png"),
   toolimage = LOVE.graphics.newImage("assets/map_tools.png"),
   shipimage = LOVE.graphics.newImage("assets/ships.png"),
   msgfont = LOVE.graphics.newFont("assets/pixelfont.otf")
}

local Map = require "game/Map".init(images.toolimage, images.shipimage)

local enemymap = Map:new(Map.types.enemy)
local playermap = Map:new(Map.types.player)
local maptools = require "game/maptools"

--------------------External--------------------
local playscreen = {}

function playscreen.update (dt)
   maptools.update(dt)
   enemymap:update(dt)
   playermap:update(dt)
end

function playscreen.draw ()
   LOVE.graphics.draw(images.bg)
   maptools.draw()
   enemymap:draw()
   playermap:draw()
end

function playscreen.onMouseClick(mx, my, button)
   maptools.onMouseClick(mx, my, button)
   playermap:onMouseClick(mx, my, button)
   enemymap:onMouseClick(mx, my, button)
end

return playscreen