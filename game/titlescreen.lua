local Button = require "engine.Button"

local images = {
   bgimg = LOVE.graphics.newImage("assets/titlescreen.png"),
   buttonimg = LOVE.graphics.newImage("assets/titlebuttons.png")
}

local font = LOVE.graphics.newFont("assets/pixelfont.ttf", 32)

local title = "Fleet Battle Enigma"
local title_x = DESIGNWIDTH / 2 - font:getWidth(title) / 2
local button_x = DESIGNWIDTH / 2 - 68
local button_y = DESIGNHEIGHT / 2

local buttons = {
   Button:new(images.buttonimg, LOVE.graphics.newQuad(0, 0, 136, 40, 136, 80), LOVE.graphics.newQuad(0, 40, 136, 40, 136, 80), nil, button_x, button_y + 50, 136, 40, function() CHANGE_SCREEN(SCREENS.playscreen) end, "PLAY", {0.73, 0.6, 0.38, 1}, 16),
   Button:new(images.buttonimg, LOVE.graphics.newQuad(0, 0, 136, 40, 136, 80), LOVE.graphics.newQuad(0, 40, 136, 40, 136, 80), nil, button_x, button_y + 100, 136, 40, function() print("Settings") end, "SETTINGS", {0.73, 0.6, 0.38, 1}, 16),
   Button:new(images.buttonimg, LOVE.graphics.newQuad(0, 0, 136, 40, 136, 80), LOVE.graphics.newQuad(0, 40, 136, 40, 136, 80), nil, button_x, button_y + 150, 136, 40, function() LOVE.event.quit() end, "QUIT", {0.73, 0.6, 0.38, 1}, 16),
}

local titlescreen = {}

function titlescreen.update (dt)

   local mx, my = LOVE.mouse.getPosition()
   if SCALEFACTOR ~= 1 then
      mx = mx * INPUTCORRECTION
      my = my * INPUTCORRECTION
   end

   for _, b in pairs(buttons) do
      b:isMouseInside(mx, my)
   end
end

function titlescreen.draw ()
   LOVE.graphics.draw(images.bgimg)

   for _, b in pairs(buttons) do
      b:draw()
      LOVE.graphics.setColor(1, 1, 1, 1)
   end


   LOVE.graphics.setFont(font)
   LOVE.graphics.setColor(0.73, 0.6, 0.38, 1)
   LOVE.graphics.print(title, title_x, 156)

end

function titlescreen.onMouseClick (mx, my, button)
   for _, b in pairs(buttons) do
      if b.hot then
         b.action()
      end
   end
end

return titlescreen