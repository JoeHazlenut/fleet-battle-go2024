
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

local Maptool = require "game/Maptool"

local maptools = {
   Maptool:new(LOVE.graphics.newQuad(0, 0, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 0, 32, 32, 96, 320), images.toolimage, 19 * 32, 2 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 1 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 1 * 32, 32, 32, 96, 320), images.toolimage, 20 * 32, 2 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 2 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 2 * 32, 32, 32, 96, 320), images.toolimage, 19 * 32, 3 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 3 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 3 * 32, 32, 32, 96, 320), images.toolimage, 20 * 32, 3 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 4 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 4 * 32, 32, 32, 96, 320), images.toolimage, 19 * 32, 4 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 5 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 5 * 32, 32, 32, 96, 320), images.toolimage, 20 * 32, 4 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 6 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 6 * 32, 32, 32, 96, 320), images.toolimage, 19 * 32, 5 * 32),
   Maptool:new(LOVE.graphics.newQuad(0, 7 * 32, 32, 32, 96, 320), LOVE.graphics.newQuad(32, 7 * 32, 32, 32, 96, 320), images.toolimage, 20 * 32, 5 * 32),
}

--------------------External--------------------
local playscreen = {}

function playscreen.update (dt)
   local mx, my = LOVE.mouse.getPosition()
   for _, tool in ipairs(maptools) do
      tool:update(mx, my)
   end

   enemymap:update(dt)
   playermap:update(dt)
end

function playscreen.draw ()
   LOVE.graphics.draw(images.bg)

   for _, tool in ipairs(maptools) do
      tool:draw()
   end

   enemymap:draw()
   playermap:draw()
end

function playscreen.onMouseClick(mx, my, button)
   for key, tool in ipairs(maptools) do
      if tool.active then
         playermap:setCurrentCursor(key)
         enemymap:setCurrentCursor(key)
      end
   end

   playermap:onMouseClick(mx, my, button)
   enemymap:onMouseClick(mx, my, button)
end

return playscreen