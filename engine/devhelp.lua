-----------------------INTERNAL--------------------
LOVE.graphics.setLineWidth(1)

local columns = DESIGNWIDTH / TILESIZE
local rows = DESIGNHEIGHT / TILESIZE

local devhelp = {
   gridmode = false,
   debugmode = false,
   font = LOVE.graphics.newFont(14)
}

-----------------------EXTERNAL--------------------
function devhelp.showGrid ()
   LOVE.graphics.setColor(1, 1, 1, 0.5)

   for col = 1, columns do
      LOVE.graphics.line(col * TILESIZE, 0, col * TILESIZE, 720)
   end

   for row = 1, rows do
      LOVE.graphics.line(0, row * TILESIZE, 1280, row * TILESIZE)
   end

   local mx, my = LOVE.mouse.getPosition()
   if SCALEFACTOR ~= 1 then
      mx = mx * INPUTCORRECTION
      my = my * INPUTCORRECTION
   end

   LOVE.graphics.setColor(0, 1, 0, 0.1)
   LOVE.graphics.rectangle("fill", math.floor(mx / TILESIZE) * TILESIZE, math.floor(my / TILESIZE) * TILESIZE, TILESIZE, TILESIZE)
   LOVE.graphics.setColor(0, 1, 0, 1)
   LOVE.graphics.rectangle("line", math.floor(mx / TILESIZE) * TILESIZE, math.floor(my / TILESIZE) * TILESIZE, TILESIZE, TILESIZE)
end

function devhelp.showSystemMetrics ()
   LOVE.graphics.setColor(0, 0, 0, 0.1)
   LOVE.graphics.rectangle("fill", 0, 620, 200, 100)

   LOVE.graphics.setFont(devhelp.font)
   LOVE.graphics.setColor(0, 0, 0, 1)
   LOVE.graphics.print("FPS: " .. LOVE.timer.getFPS(), 10, 640)
   LOVE.graphics.print("MEM: " .. collectgarbage("count"), 10, 680)
end

function devhelp.showShips (playermap, enemymap)
   for rindx = 1, 15 do
      for cindx = 1, 15 do
         if playermap.shiplayer[rindx][cindx] ~= 0 then
            LOVE.graphics.setColor(1, 1, 0, 0.2)
            LOVE.graphics.rectangle("fill", (cindx - 1) * TILESIZE + playermap.region.x, (rindx - 1) * TILESIZE + playermap.region.y, TILESIZE, TILESIZE)
         end
         if enemymap.shiplayer[rindx][cindx] ~= 0 then
            LOVE.graphics.setColor(1, 0, 0, 0.2)
            LOVE.graphics.rectangle("fill", (cindx - 1) * TILESIZE + enemymap.region.x, (rindx - 1) * TILESIZE + enemymap.region.y, TILESIZE, TILESIZE)
         end
      end
   end
end

return devhelp