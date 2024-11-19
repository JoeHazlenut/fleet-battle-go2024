local Map = require "game.Map"

local playermap = Map:new(Map.types.player)

local shiptypes_str = "ABCDE"

function playermap:draw ()
   local mx, my = LOVE.mouse.getPosition()
   if SCALEFACTOR ~= 1 then
      mx = mx * INPUTCORRECTION
      my = my * INPUTCORRECTION
   end

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

function playermap:drawPlaceShips (shipcursor_facing)
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

      rotation = 0
      roffsetx = 0
      roffsety = 0
      if shipcursor_facing then
         if shipcursor_facing == 1 then
            rotation = math.rad(90)
            roffsetx = 0
            roffsety = TILESIZE
         elseif shipcursor_facing == 2 then
            rotation = math.rad(180)
            roffsetx = TILESIZE
            roffsety = TILESIZE
         elseif shipcursor_facing == 3 then
            rotation = math.rad(-90)
            roffsetx = TILESIZE
            roffsety = 0
         end
      end

      LOVE.graphics.draw(self.cursorimg, self.currentcursor, (self.region.x + tile_x * TILESIZE), (self.region.y + tile_y * TILESIZE), rotation, nil, nil, roffsetx, roffsety)
   end
end

local function getShipFacing (r, c, val, shiptype)
   if val == shiptype then
      if (r + 1 < 16) and (playermap.shiplayer[r + 1][c] == string.lower(val)) then
         return r, c, SHIPFACING.up
      elseif (r - 1 > 0) and (playermap.shiplayer[r - 1][c] == string.lower(val)) then
         return r, c, SHIPFACING.down
      elseif (c + 1 < 16) and (playermap.shiplayer[r][c + 1] == string.lower(val)) then
         return r, c, SHIPFACING.left
      elseif (c - 1 > 0) and (playermap.shiplayer[r][c - 1] == string.lower(val)) then
         return r, c, SHIPFACING.right
      end
   else
      print("Not yet implemented")
      return 0, 0, 0
   end
end

function playermap:onMouseClick(mx, my, button, other)
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local row = math.floor((my - self.region.y) / TILESIZE) + 1
      local col = math.floor((mx - self.region.x) / TILESIZE) + 1

      if button == 1 then
         if self:getCursorKey() == MAPTOOLS.move then
            local selection = self.shiplayer[row][col]
            local ship = string.upper(selection)
            if string.find(shiptypes_str, ship) then
               -- here we now that we have a ship
               local drawstart_r = 0
               local drawstart_c = 0
               local facing = 0
               drawstart_r, drawstart_c, facing = getShipFacing(row, col, selection, ship)
               print("from: " .. tostring(drawstart_r) .. "/" .. tostring(drawstart_c) .. " into direction: " .. tostring(facing))
            end
         end
      end
   end

   Map.onMouseClick(self, mx, my, button, other)
end

return playermap