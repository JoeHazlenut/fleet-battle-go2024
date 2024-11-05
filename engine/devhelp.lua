-----------------------INTERNAL--------------------
LOVE.graphics.setLineWidth(1)

local gridsize = 32
local columns = 1280 / 32
local rows = 720 / 32

local devhelp = {
   active = false,
}

-----------------------EXTERNAL--------------------
function devhelp.showGrid ()
   LOVE.graphics.setColor(1, 1, 1, 1)

   for col = 1, columns do
      LOVE.graphics.line(col * 32, 0, col * 32, 720)
   end

   for row = 1, rows do
      LOVE.graphics.line(0, row * 32, 1280, row * 32)
   end

   local mx, my = LOVE.mouse.getPosition()
   LOVE.graphics.setColor(0, 1, 0, 0.1)
   LOVE.graphics.rectangle("fill", math.floor(mx / gridsize) * 32, math.floor(my / gridsize) * 32, gridsize, gridsize)
   LOVE.graphics.setColor(0, 1, 0, 1)
   LOVE.graphics.rectangle("line", math.floor(mx / gridsize) * 32, math.floor(my / gridsize) * 32, gridsize, gridsize)
   LOVE.graphics.setColor(1, 1, 1, 1)
end

return devhelp