local msgmanager = require "game.messagemanager"

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

local attacks = {}
local frame_wait_cntr = 60

local player = Commander:new()

player.show_ap = {
   {x = 445, y = 365, used = false, preview = false},
   {x = 473, y = 365, used = false, preview = false},
   {x = 501, y = 365, used = false, preview = false},
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
      selected_map.infolayer[r][c] = MAPTOOLS.shooter
      self.show_ap[self.ap].used = true -- this is the difference to the metatables method
      self:attack(r, c)
      selected_map:setCurrentCursor(MAPTOOLS.selector)
   end
end

function player:attack (r, c)
   self.show_ap[self.ap].used = true
   attacks[#attacks + 1] = function () Commander.attack(self, r, c) end
   msgmanager.logAttack(COMNMANDER_UID.player, r, c)
   self.ap = self.ap - 1

   return true
end

function player:executeAttacks ()
   if #attacks > 0 then
        if frame_wait_cntr >= 0 then
            frame_wait_cntr = frame_wait_cntr - 1
        else
            local attack = table.remove(attacks, 1)
            attack()
            frame_wait_cntr = 60
        end
    end

    if #attacks == 0 then
        return true
    end
end

function player:decipher ()
   if #msgmanager.msgqueue < 3 then
      return
   end

   Commander.decipher(self, COMNMANDER_UID.player, msgmanager:getMostRecentEnemyMsg())
end

function player:moveShip (shiptype, start_r, start_c, goal_r, goal_c, shipsize, facing)
   print("Player moveship")
   self.show_ap[self.ap].used = true
   Commander.moveShip(self, start_r, start_c, goal_r, goal_c, shipsize, facing)
   msgmanager.logMovement(COMNMANDER_UID.player, shiptype, facing, start_c, start_r, goal_c, goal_r)

   return true
end

function player:turnShip (shiptype, start_r, start_c, goal_r, goal_c, shipsize, facing)
   self.show_ap[self.ap].used = true
   facing = Commander.turnShip(self, shiptype, start_r, start_c, goal_r, goal_c, shipsize, facing)
   msgmanager.logTurnShip(COMNMANDER_UID.player, shiptype, facing)

   return true
end

function player:resetForTurn ()
   Commander.resetForTurn(self)
   for indx, ap in pairs(self.show_ap) do
      ap.used = false
      ap.preview = false
   end
   self:resetPreviews()
end

return player