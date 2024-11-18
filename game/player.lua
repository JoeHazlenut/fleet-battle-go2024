PLAYER_ACTIONS = {
   attack = 1,
   descypher = 2,
   move = 3,
   turn = 4
}

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
         if ap.preview then
            LOVE.graphics.draw(src, apquads.preview, ap.x, ap.y)
         else
            LOVE.graphics.draw(src, apquads.ready, ap.x, ap.y)
         end
      end
   end
end

function player:highlightApCosts (pa_code)
   local cost = 0
   if pa_code == PLAYER_ACTIONS.descypher then
      cost = 2
   else
      cost = 1
   end

   local indx = #self.show_ap
   while cost > 0 do
      local ap_ref = self.show_ap[indx]
      if (ap_ref.preview == false) and (ap_ref.used == false) then
         ap_ref.preview = true
         cost = cost - 1
      end
      indx = indx - 1
   end
end

return player