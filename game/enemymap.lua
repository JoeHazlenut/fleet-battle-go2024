---@diagnostic disable: assign-type-mismatch
local Map = require "game.Map"

local enemymap = Map:new (Map.types.enemy)

local function allTilesFree(r, c, facing, numtiles)
   if enemymap.shiplayer[r][c] ~= 0 then
      return false
   end

   for step = 1, numtiles - 1 do
      if facing == SHIPFACING.right or facing == SHIPFACING.left then
         if facing == SHIPFACING.right then
            if enemymap.shiplayer[r][c - step] ~= 0 then
               return false
            end
         else
            if enemymap.shiplayer[r][c + step] ~= 0 then
               return false
            end
         end
      else
         if facing == SHIPFACING.up then
            if enemymap.shiplayer[r + step][c] ~= 0 then
               return false
            end
         else
            if enemymap.shiplayer[r - step][c] ~= 0 then
               return false
            end
         end
      end
   end

   return true
end

local function allInsideMap (r, c, facing, numtiles)
   if facing == SHIPFACING.up then
      return ((r + numtiles) < 16) and (r > 0) and (c > 0) and (c < 16)
   elseif facing == SHIPFACING.right then
      return ((c - numtiles) > 0) and (c < 16) and (r < 16) and (r > 0)
   elseif facing == SHIPFACING.down then
      return ((r - numtiles) > 0) and (r < 16) and (c < 16) and (c > 0)
   else -- left
      return ((c + numtiles) < 16) and (c > 0) and (r < 16) and (r > 0)
   end
end

function enemymap:generateEnemyBoard ()
   local numships = 5
   local shiptypes = {"A", "B", "C", "D", "E"}

   math.randomseed(os.time())
   local boardmax = 15

   for typekey = 1, numships do
      local shiptype = shiptypes[typekey]
      local numshiptiles = 0

      if shiptype == "A" then -- 2 tile ship
         numshiptiles = 2
      elseif shiptype == "B" or shiptype == "C" then -- 3 tile ship/sub
         numshiptiles = 3
      elseif shiptype == "D" then -- 4 tile ship
         numshiptiles = 4
      else
         numshiptiles = 5 -- 5 tile ship
      end

      local randfacing = math.random(SHIPFACING.up, SHIPFACING.left)
      local randrow = math.random(1, boardmax)
      local randcol = math.random(1, boardmax)

      while (allInsideMap(randrow, randcol, randfacing, numshiptiles) == false) or (allTilesFree(randrow, randcol, randfacing, numshiptiles) == false) do
         randrow = math.random(1, boardmax)
         randcol = math.random(1, boardmax)
      end

      local typechar = string.lower(shiptype)
      self.shiplayer[randrow][randcol] = shiptype
      if randfacing == SHIPFACING.up then
         for step = 1, numshiptiles - 1 do
            self.shiplayer[randrow + step][randcol] = typechar
         end
      elseif randfacing == SHIPFACING.right then
         for step = 1, numshiptiles  - 1 do
            self.shiplayer[randrow][randcol - step] = typechar
         end
      elseif randfacing == SHIPFACING.down then
         for step = 1, numshiptiles  - 1 do
            self.shiplayer[randrow - step][randcol] = typechar
         end
      else
         for step = 1, numshiptiles - 1 do
            self.shiplayer[randrow][randcol + step] = typechar
         end
      end
   end

   self:printSL()
end

--[[function enemymap:onMouseClick(mx, my, button, other)
   print("Enemy on Clikc")
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      print("In region: " .. self:getCursorKey())
      local tile_x = math.floor((my - self.region.y) / TILESIZE) + 1
      local tile_y = math.floor((mx - self.region.x) / TILESIZE) + 1
      if self:getCursorKey() == MAPTOOLS.shooter then
         print("Key is Shooter")
         self.infolayer[tile_x][tile_y] = MAPTOOLS.shooter
      end
   end

   Map.onMouseClick(self, mx, my, button, other)
end]]

return enemymap