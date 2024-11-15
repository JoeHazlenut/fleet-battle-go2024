local Commander = require "game.Commander"

local apquads = {
   ready = LOVE.graphics.newQuad(0, 0, 14, 14, 42, 14),
   preview = LOVE.graphics.newQuad(14, 0, 14, 14, 42, 14)
}

local player = Commander:new()

player.show_ap = {
   {x = 445, y = 319, used = false, preview = false},
   {x = 473, y = 319, used = false, preview = false},
   {x = 501, y = 319, used = false, preview = false},
}

function player:draw (src)
   for cntr = 1, self.ap do
      local ap = self.show_ap[cntr]
      if not ap.used then
         if ap.prieview then
            LOVE.graphics.draw(src, apquads.preview, ap.x, ap.y)
         else
            LOVE.graphics.draw(src, apquads.ready, ap.x, ap.y)
         end
      end
   end
end

return player