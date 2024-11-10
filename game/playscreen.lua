---------------------Internal-------------------
local images = {
   bg = LOVE.graphics.newImage("assets/new/background.png"),
   selectbg = LOVE.graphics.newImage("assets/new/background_select.png"),
   toolimage = LOVE.graphics.newImage("assets/new/tools.png"),
   shipimage = LOVE.graphics.newImage("assets/new/ships.png"),
   selectimage = LOVE.graphics.newImage("assets/new/place_ship_ui.png"),
   shipbuttonimg = LOVE.graphics.newImage("assets/new/ships_buttons.png"),
   msgfont = LOVE.graphics.newFont("assets/pixelfont.otf")
}

local Map = require "game/Map".init(images.toolimage, images.shipimage)
local playermap = require "game/playermap"

local enemymap = Map:new(Map.types.player)

local Maptool = require "game/Maptool"

SHIPFACING = {up = 1, right = 2, down = 3, left = 4}

--TODO: change magic numbers to texture:getWidth etc.
local maptools = {
   Maptool:new(LOVE.graphics.newQuad(0, 0, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 0, TILESIZE, TILESIZE, 72, 240), images.toolimage, 19 * TILESIZE, 2 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 1 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 1 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 20 * TILESIZE, 2 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 2 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 2 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 19 * TILESIZE, 3 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 3 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 3 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 20 * TILESIZE, 3 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 4 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 4 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 19 * TILESIZE, 4 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 5 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 5 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 20 * TILESIZE, 4 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 6 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 6 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 19 * TILESIZE, 5 * TILESIZE),
   Maptool:new(LOVE.graphics.newQuad(0, 7 * TILESIZE, TILESIZE, TILESIZE, 72, 240), LOVE.graphics.newQuad(TILESIZE, 7 * TILESIZE, TILESIZE, TILESIZE, 72, 240), images.toolimage, 20 * TILESIZE, 5 * TILESIZE),
}

local Button = require "engine/Button"

-------------------PLACESHIPS-------------------
local placeShipState = {
   nr = 1,
   buttons = {
      Button:new(images.shipbuttonimg, LOVE.graphics.newQuad(0, 0, 2 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(5 * TILESIZE, 0, 2 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(10 * TILESIZE, 0, 2 * TILESIZE, TILESIZE, 360, 144), 29 * TILESIZE, 5 * TILESIZE, 2 * TILESIZE, TILESIZE, function () playermap:setCursorToShip("A") return "A", SHIPFACING.left end),
      Button:new(images.shipbuttonimg, LOVE.graphics.newQuad(0, TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(5 * TILESIZE, TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(10 * TILESIZE, TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), 29 * TILESIZE, 7 * TILESIZE, 3 * TILESIZE, TILESIZE, function () playermap:setCursorToShip("B") return "B", SHIPFACING.left end),
      Button:new(images.shipbuttonimg, LOVE.graphics.newQuad(0, 2 * TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(5 * TILESIZE, 2 * TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(10 * TILESIZE, 2 * TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), 29 * TILESIZE, 9 * TILESIZE, 3 * TILESIZE, TILESIZE, function () playermap:setCursorToShip("C") return "C", SHIPFACING.left end),
      Button:new(images.shipbuttonimg, LOVE.graphics.newQuad(0, 3 * TILESIZE, 4 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(5 * TILESIZE, 3 * TILESIZE, 4 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(10 * TILESIZE, 3 * TILESIZE, 4 * TILESIZE, TILESIZE, 360, 144), 29 * TILESIZE, 11 * TILESIZE, 4 * TILESIZE, TILESIZE, function () playermap:setCursorToShip("D") return "D", SHIPFACING.left end),
      Button:new(images.shipbuttonimg, LOVE.graphics.newQuad(0, 4 * TILESIZE, 5 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(5 * TILESIZE, 4 * TILESIZE, 5 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(10 * TILESIZE, 4 * TILESIZE, 5 * TILESIZE, TILESIZE, 360, 144), 29 * TILESIZE, 13 * TILESIZE, 4 * TILESIZE, TILESIZE, function () playermap:setCursorToShip("E") return "E", SHIPFACING.left end),
   },
   font = LOVE.graphics.newFont("assets/pixelfont.otf", 18),
   selship = {},
   ships_to_place = 5,
   confbutton = Button:new(images.shipbuttonimg, LOVE.graphics.newQuad(0, 5 * TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(3 * TILESIZE, 5 * TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), LOVE.graphics.newQuad(6 * TILESIZE, 5 * TILESIZE, 3 * TILESIZE, TILESIZE, 360, 144), 24 * TILESIZE, 15 * TILESIZE, 3 * TILESIZE, TILESIZE, function () print("confirm") end, "CONFIRM")
}

function placeShipState.update (dt)
   local mx, my = LOVE.mouse.getPosition()
   if SCALEFACTOR ~= 1 then
      mx = mx * INPUTCORRECTION
      my = my * INPUTCORRECTION
   end

   for _, button in pairs(placeShipState.buttons) do
      button:isMouseInside(mx, my)
   end

   if placeShipState.ships_to_place <= 0 then
      placeShipState.confbutton:isMouseInside(mx, my)
   end
end

function placeShipState.draw ()
   LOVE.graphics.draw(images.selectbg)

   playermap:drawPlaceShips(placeShipState.selship.facing)

   for _, button in pairs(placeShipState.buttons) do
      button:draw()
   end

   if placeShipState.ships_to_place <= 0 then
      placeShipState.confbutton:draw()
   end

   LOVE.graphics.setFont(placeShipState.font)
   LOVE.graphics.setColor(0.52, 0.96,  0.52, 0.8)
   LOVE.graphics.print("Place Ships:", 24 * TILESIZE, 3 * TILESIZE)
   LOVE.graphics.print("Type A: ", 24 * TILESIZE, 5 * TILESIZE)
   LOVE.graphics.print("Type B: ", 24 * TILESIZE, 7 * TILESIZE)
   LOVE.graphics.print("Type C: ", 24 * TILESIZE, 9 * TILESIZE)
   LOVE.graphics.print("Type D: ", 24 * TILESIZE, 11 * TILESIZE)
   LOVE.graphics.print("Type E: ", 24 * TILESIZE, 13* TILESIZE)
end

function placeShipState.onMouseClick (mx, my, button)
   for _, button in pairs(placeShipState.buttons) do
      if button.hot and not button.active then
         button.active = true
         button.hot = false
         if button.action then
            placeShipState.selship.letter, placeShipState.selship.facing = button.action()
         end
      elseif button.active and not button.hot then
         button.active = false
         button.hot = false
      end
   end

   if button == 1 then
      if playermap:onLeftClickPlaceShip(mx, my, placeShipState.selship.letter, placeShipState.selship.facing) then
         playermap:setCurrentCursor(MAPTOOLS.selector)
         placeShipState.ships_to_place = placeShipState.ships_to_place - 1
      end
   elseif button == 2 then
      placeShipState.selship.facing = placeShipState.selship.facing + 1
      if placeShipState.selship.facing > SHIPFACING.left then
         placeShipState.selship.facing = SHIPFACING.up
      end
   end

   if placeShipState.confbutton.hot then
      placeShipState.confbutton.action()
   end
end

----------------------BATTLE--------------------
local battleState = {
   nr = 2
}

function battleState.update (dt)
   local mx, my = LOVE.mouse.getPosition()
   if SCALEFACTOR ~= 1 then
      mx = mx * INPUTCORRECTION
      my = my * INPUTCORRECTION
   end
   for _, tool in ipairs(maptools) do
      tool:update(mx, my)
   end

   enemymap:update(dt)
   playermap:update(dt)
end

function battleState.draw ()
   LOVE.graphics.draw(images.bg)

   for _, tool in ipairs(maptools) do
      tool:draw()
   end

   enemymap:draw()
   playermap:draw()
end

function battleState.onMouseClick (mx, my, button)
   for key, tool in ipairs(maptools) do
      if tool.active then
         playermap:setCurrentCursor(key)
         enemymap:setCurrentCursor(key)
      end
   end

   playermap:onMouseClick(mx, my, button)
   enemymap:onMouseClick(mx, my, button)
end

--------------------External--------------------
GAMESTATES = {
   PLACESHIPS = 1,
   BATTLE = 2,
   WIN = 3,
   LOOSE = 4
}

local playscreen = {
   state = placeShipState
}

function playscreen.reset ()
   playscreen.state = placeShipState
end

function playscreen.update (dt)
   playscreen.state.update(dt)
end

function playscreen.draw ()
   playscreen.state.draw()
end

function playscreen.onMouseClick(mx, my, button)
   playscreen.state.onMouseClick(mx, my, button)
end

return playscreen