---@diagnostic disable: assign-type-mismatch
local Map = require "game/Map"

local enemymap = Map:new (Map.types.enemy)

local function allTilesFree(r, c, facing, numtiles)
   if enemymap.shiplayer[r][c] ~= 0 then
      return false
   end

   for step = 1, numtiles - 1 do
      if facing == SHIPFACING.right or facing == SHIPFACING.left then
         if facing == SHIPFACING.right then
            print("right")
            if enemymap.shiplayer[r][c - step] ~= 0 then
               print("Checking: " .. r .. "/" .. c - step)
               return false
            end
         else
            print("left")
            if enemymap.shiplayer[r][c + step] ~= 0 then
               print("Checking: " .. r .. "/" .. c + step)
               return false
            end
         end
      else
         if facing == SHIPFACING.up then
            print("up: " .. tostring(facing))
            if enemymap.shiplayer[r + step][c] ~= 0 then
               print("Checking: " .. r + step .. "/" .. c)
               return false
            end
         else
            print("down: " .. tostring(facing))
            if enemymap.shiplayer[r - step][c] ~= 0 then
               print("Checking: " .. r - step .. "/" .. c)
               return false
            end
         end
      end
   end

   print("All tiles free")
   return true
end

local function allInsideMap (r, c, facing, numtiles)
   local allgood = false
   if facing == SHIPFACING.up then
      allgood = (r - numtiles >= 1) and (r <= 15) and (c >= 1) and (c <= 15)
   elseif facing == SHIPFACING.right then
      allgood = (c - numtiles >= 1) and (c <= 15) and (r <= 15) and (r >= 1)
   elseif facing == SHIPFACING.down then
      allgood = (c + numtiles <= 15) and (c >= 1) and (r <= 15) and (r >= 1)
   else
      allgood = (r + numtiles <= 15) and (r >= 1) and (c <= 15) and (c >= 1)
   end

   print("All Inside with: facing - " .. facing .. " and tiles " .. numtiles  .. " " .. tostring(allgood))

   return allgood
end

function enemymap:generateEnemyBoard ()
   local numships = 5
   local shiptypes = {"A", "B", "C", "D", "E"}

   math.randomseed(os.time())
   local boardmax = 15

   for typekey = 1, numships do
      local shiptype = shiptypes[typekey]
      local numshiptiles = 0
      
      print("Placing: " .. shiptype)

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
         print("reroll the tiles")
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

return enemymap