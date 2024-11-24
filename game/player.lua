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
      if ap.preview then
         LOVE.graphics.draw(src, apquads.preview, ap.x, ap.y)
      else
         LOVE.graphics.draw(src, apquads.ready, ap.x, ap.y)
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

   self.pending_action = true
end

function player:resetPreviews ()
   for indx, ap in ipairs(self.show_ap) do
      if ap.preview == true and ap.used == false then
         ap.preview = false
      end
   end

   self.pending_action = false
end

function player:onClick(mx, my)
   local r = 0
   local c = 0
   local selected_map = nil

   if self.om:isInputInsideRegion(mx, my) then
      r = math.floor(((my - self.om.region.y) / TILESIZE) + 1)
      c = math.floor(((mx - self.om.region.x) / TILESIZE) + 1)
      selected_map = self.om
   elseif self.em:isInputInsideRegion(mx, my) then
      r = math.floor(((my - self.em.region.y) / TILESIZE) + 1)
      c = math.floor(((mx - self.em.region.x) / TILESIZE) + 1)
      selected_map = self.em
   else
      return -- Input not inside a map, and so we just do nothing
   end

   local actioncode = selected_map:getCursorKey()

   if actioncode == MAPTOOLS.shooter then
      self.show_ap[self.ap].used = true -- this is the difference to the metatables method
      self:attack(r, c)
      selected_map:setCurrentCursor(MAPTOOLS.selector)
   end
end

function player:attack (r, c)
   self.show_ap[self.ap].used = true
   Commander.attack(self, r, c)
end

function player:moveShip (start_r, start_c, goal_r, goal_c, shipsize, facing)
   self.show_ap[self.ap].used = true
   Commander.moveShip(self, start_r, start_c, goal_r, goal_c, shipsize, facing)
end

function player:turnShip (shiptype, start_r, start_c, goal_r, goal_c, shipsize, facing)
   self.show_ap[self.ap].used = true
   Commander.turnShip(self, shiptype, start_r, start_c, goal_r, goal_c, shipsize, facing)
end

return player