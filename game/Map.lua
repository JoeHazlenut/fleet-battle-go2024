------------------------------EXTERNAL----------------------------
SHIPTYPES = {
   sub2 = "A",
   boad3 = "B",
   sub3 = "C",
   boad4 = "D",
   boad5 = "E"
}

MAPTOOLS = {
   exclaim = 1,
   question = 2,
   up = 3,
   right = 4,
   down = 5,
   left = 6,
   ring = 7,
   aim = 8,
   selector = 9
}


local Map = {
   types = {enemy = 0, player = 1},
   toolquads = {
      LOVE.graphics.newQuad(2 * TILESIZE, 0 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- exclaim
      LOVE.graphics.newQuad(2 * TILESIZE, 1 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- questionmark
      LOVE.graphics.newQuad(2 * TILESIZE, 2 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- up
      LOVE.graphics.newQuad(2 * TILESIZE, 3 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- right
      LOVE.graphics.newQuad(2 * TILESIZE, 4 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- down
      LOVE.graphics.newQuad(2 * TILESIZE, 5 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  --left
      LOVE.graphics.newQuad(2 * TILESIZE, 6 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- circle
      LOVE.graphics.newQuad(2 * TILESIZE, 7 * TILESIZE, TILESIZE, TILESIZE, 72, 240),  -- aim
      LOVE.graphics.newQuad(2 * TILESIZE, 8 * TILESIZE, TILESIZE, TILESIZE, 72, 240)   -- selector
   },
   shipquads = {}
}
Map.__index = Map

Map.shipquads["A"] = LOVE.graphics.newQuad(0, 0, 2 * TILESIZE, TILESIZE, 120, 120)
Map.shipquads["B"] = LOVE.graphics.newQuad(0, 1 * TILESIZE, 3 * TILESIZE, TILESIZE, 120, 120)
Map.shipquads["C"] = LOVE.graphics.newQuad(0, 2 * TILESIZE, 3 * TILESIZE, TILESIZE, 120, 120)
Map.shipquads["D"] = LOVE.graphics.newQuad(0, 3 * TILESIZE, 4 * TILESIZE, TILESIZE, 120, 120)
Map.shipquads["E"] = LOVE.graphics.newQuad(0, 4 * TILESIZE, 5 * TILESIZE, TILESIZE, 120, 120)

function Map.init(toolimg, shipimg)
   Map.toolimage = toolimg
   Map.shipimage = shipimg

   return Map
end

function Map:update ()
end

function Map:draw ()
   local mx, my = LOVE.mouse.getPosition()
   if SCALEFACTOR ~= 1 then
      mx = mx * INPUTCORRECTION
      my = my * INPUTCORRECTION
   end

   local shiptypes_str = "ABCDE"
   local rotation = 0
   local roffsetx = 0
   local roffsety = 0

   for rownumber, row in ipairs(self.shiplayer) do
      for tilenumber, col in ipairs(row) do
         if string.find(shiptypes_str, col) then
            if (tilenumber + 1) < 16 and row[tilenumber + 1] == string.lower(col) then
               rotation = math.rad(0)
               roffsetx = 0
               roffsety = 0
            elseif (tilenumber - 1) > 0 and row[tilenumber - 1] == string.lower(col) then
               rotation = math.rad(180)
               roffsetx = TILESIZE
               roffsety = TILESIZE
            elseif (rownumber + 1) < 16 and self.shiplayer[rownumber + 1][tilenumber] == string.lower(col) then
               rotation = math.rad(90)
               roffsetx = 0
               roffsety = TILESIZE
            elseif (rownumber - 1) > 0 and self.shiplayer[rownumber - 1][tilenumber] == string.lower(col) then
               rotation = math.rad(-90)
               roffsetx = TILESIZE
               roffsety = 0
            else
               error("FATAL: Ship does not seem to have any adjacend tiles, which should not happen!")
            end

            LOVE.graphics.draw(Map.shipimage, Map.shipquads[col], self.region.x + (tilenumber - 1) * TILESIZE, self.region.y + (rownumber - 1) * TILESIZE, rotation, nil, nil, roffsetx, roffsety)
         end
         if self.infolayer[rownumber][tilenumber] ~= 0 then
            LOVE.graphics.draw(Map.toolimage, Map.toolquads[self.infolayer[rownumber][tilenumber]], self.region.x + (tilenumber - 1) * TILESIZE, self.region.y + (rownumber - 1) * TILESIZE)
         end
      end
   end

   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local tile_x = math.floor((mx - self.region.x) / TILESIZE)
      local tile_y = math.floor((my - self.region.y) / TILESIZE)
      LOVE.graphics.draw(self.cursorimg, self.currentcursor, (self.region.x + tile_x * TILESIZE), (self.region.y + tile_y * TILESIZE))
   end
end

function Map:new(type)
   local map = {
      shiplayer = {
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
      },
      infolayer = {

         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      },
      region = {x = 0, y = 0, size = 15 * TILESIZE},
      currentcursor = self.toolquads[MAPTOOLS.selector],
      cursorimg = Map.toolimage,
   }

   if type == self.types.enemy then
      map.region.x = 48
      map.region.y = 2 * TILESIZE
   else
      map.region.x = 552
      map.region.y = 2 * TILESIZE
   end

   setmetatable(map, Map)

   return map
end

function Map:setCurrentCursor (key)
   self.currentcursor = Map.toolquads[key]
   self.cursorimg = Map.toolimage
end

function Map:setCursorToShip (key)
   self.currentcursor = Map.shipquads[key]
   self.cursorimg = Map.shipimage
end

function Map:onMouseClick(mx, my, button) --TODO: WTF????
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local tile_x = math.floor((my - self.region.y) / TILESIZE) + 1
      local tile_y = math.floor((mx - self.region.x) / TILESIZE) + 1

      local selection = self.infolayer[tile_x][tile_y]
      local maptool_indx = 0
      if selection ~= self.currentcursor then
         for indx, quad in ipairs(Map.toolquads) do
            if quad == self.currentcursor then
               maptool_indx = indx
               break
            end
         end
         if maptool_indx < 9 then
            self.infolayer[tile_x][tile_y] = maptool_indx
         end
      end
    end
end

function Map:onLeftClickPlaceShip (mx, my, type, facing)
   print(type)
   print(facing)
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local xtile = math.floor((mx - self.region.x) / TILESIZE) + 1
      local ytile = math.floor((my - self.region.y) / TILESIZE) + 1

      if self.shiplayer[ytile][xtile] == 0 then

         local shipsize = 1
         if type == "B" or type == "C" then
            shipsize = 2
         elseif type == "D" then
            shipsize = 3
         elseif type == "E" then
            shipsize = 4
         end

         local tiles = {}
         
         if facing == SHIPFACING.up then
            local y = ytile
            for step = 1, shipsize do
               y = y + 1
               if y < 16 then
                  table.insert(tiles, y)
               else
                  return false
               end
            end
            for i, row in pairs(tiles) do
               self.shiplayer[row][xtile] = string.lower(type)
            end
      
         elseif facing == SHIPFACING.right then
            local x = xtile
            for step = 1, shipsize do
               x = x - 1
               if x > 0 then
                  table.insert(tiles, x)
               else
                  return false
               end
            end
            for i, col in pairs(tiles) do
               self.shiplayer[ytile][col] = string.lower(type)
            end

         elseif facing == SHIPFACING.down then
            local y = ytile
            for step = 1, shipsize do
               y = y - 1
               if y > 0 then
                  table.insert(tiles, y)
               else
                  return false
               end
            end
            for i, row in pairs(tiles) do
               self.shiplayer[row][xtile] = string.lower(type)
            end

         elseif facing == SHIPFACING.left then
            local x = xtile
            for step = 1, shipsize do
               x = x + 1
               if x < 16 then
                  table.insert(tiles, x)
               else
                  return false
               end
            end
            for i, col in pairs(tiles) do
               self.shiplayer[ytile][col] = string.lower(type)
            end
         end

         self.shiplayer[ytile][xtile] = type
         self:printSL()
         return true
      end
   end
end

function Map:printSL()
   for i, row in ipairs(self.shiplayer) do
      local rowstring = ""
      for j, val in ipairs(row) do
         rowstring = rowstring .. tostring(val) .. "|"
      end
      print(rowstring)
   end
end

return Map