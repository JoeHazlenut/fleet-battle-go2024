LOVE.graphics.setLineWidth(1)

local devhelp = {
   active = false,
   gridsize = 32,
   columns = 1280 / 32,
   rows = 720 / 32
}


function devhelp.showGrid ()
   LOVE.graphics.setColor(255, 255, 255, 1)

   for col = 1, devhelp.columns do
      LOVE.graphics.line(col * 32, 0, col * 32, 720)
   end

   for row = 1, devhelp.rows do
      LOVE.graphics.line(0, row * 32, 1280, row * 32)
   end

end

return devhelp