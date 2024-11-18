
local Commander = {}
Commander.__index = Commander

function Commander:new ()
   local nc = {ap = 3}

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

function Commander:moveShip (r, c)
end

function Commander:turnShip (r, c)
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

   --selected_map:printIL()
   --selected_map:printSL()
end

return Commander