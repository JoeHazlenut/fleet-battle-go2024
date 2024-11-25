local Commander = {}
Commander.__index = Commander

function Commander:new ()
   local nc = {
      ap = 3,
      msgturndict = {}
   }

   setmetatable(nc, Commander)

   return nc
end

function Commander:init (ownmap, enemymap)
   self.om = ownmap
   self.em = enemymap

   return self
end

function Commander:attack (r, c)
   local target = self.em.shiplayer[r][c]
   if target ~= 0 then
      self.em.shiplayer[r][c] = "X"
      self.em.infolayer[r][c] = MAPTOOLS.hit
   else
      self.em.infolayer[r][c] = MAPTOOLS.miss
   end

   self.ap = self.ap - 1
end

function Commander:decipher ()
end

function Commander:moveShip (start_r, start_c, goal_r, goal_c, shipsize, facing)
   print("Commander move ship")
   if facing == SHIPFACING.up then
      for step = 0, shipsize - 1 do
         local relocationsign = self.om.shiplayer[start_r + step][start_c]
         self.om.shiplayer[start_r + step][start_c] = 0
         self.om.shiplayer[goal_r + step][goal_c] = relocationsign
      end
   elseif facing == SHIPFACING.right then
      for step = 0, shipsize do
         local relocationsign = self.om.shiplayer[start_r][start_c - step]
         self.om.shiplayer[start_r][start_c - step] = 0
         self.om.shiplayer[goal_r][goal_c - step] = relocationsign
      end
   elseif facing == SHIPFACING.down then
      for step = 0, shipsize do
         local relocationsign = self.om.shiplayer[start_r - step][start_c]
         self.om.shiplayer[start_r - step][start_c] = 0
         self.om.shiplayer[goal_r - step][goal_c] = relocationsign
      end
   elseif facing == SHIPFACING.left then
      for step = 0, shipsize do
         local relocationsign = self.om.shiplayer[start_r][start_c + step]
         self.om.shiplayer[start_r][start_c + step] = 0
         self.om.shiplayer[goal_r][goal_c + step] = relocationsign
      end
   end

   self.ap = self.ap - 1
end

function Commander:turnShip (shiptype, start_r, start_c, goal_r, goal_c, shipsize, facing)
   self.om.shiplayer[goal_r][goal_c] = shiptype
   local new_facing  = 0
   for cntr = 1, shipsize - 1 do
      if facing == SHIPFACING.up then
         self.om.shiplayer[start_r - cntr][start_c] = 0

         if start_c - goal_c > 0 then
            self.om.shiplayer[goal_r][goal_c + cntr] = string.lower(shiptype)
            new_facing = SHIPFACING.left
         else
            self.om.shiplayer[goal_r][goal_c - cntr] = string.lower(shiptype)
            new_facing = SHIPFACING.right
         end
      elseif facing == SHIPFACING.right then
         self.om.shiplayer[start_r][start_c + cntr] = 0

         if start_r - goal_r > 0 then
            self.om.shiplayer[goal_r + cntr][goal_c] = string.lower(shiptype)
            new_facing = SHIPFACING.down
         else
            self.om.shiplayer[goal_r - cntr][goal_c] = string.lower(shiptype)
            new_facing = SHIPFACING.up
         end
      elseif facing == SHIPFACING.down then
         self.om.shiplayer[start_r + cntr][start_c] = 0

         if start_c - goal_c > 0 then
            self.om.shiplayer[goal_r][goal_c + cntr] = string.lower(shiptype)
            new_facing = SHIPFACING.right
         else
            self.om.shiplayer[goal_r][goal_c - cntr] = string.lower(shiptype)
            new_facing = SHIPFACING.left
         end
      elseif facing == SHIPFACING.left then
         self.om.shiplayer[start_r][start_c - cntr] = 0

         if start_r - goal_r > 0 then
            self.om.shiplayer[goal_r + cntr][goal_c] = string.lower(shiptype)
            new_facing = SHIPFACING.up
         else
            self.om.shiplayer[goal_r - cntr][goal_c] = string.lower(shiptype)
            new_facing = SHIPFACING.down
         end
      end
   end

   self.ap = self.ap - 1

   return new_facing
end


function Commander:onClick (mx, my)
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
      self:attack(r, c)
      selected_map:setCurrentCursor(MAPTOOLS.selector)
   end
end

return Commander