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
      LOVE.graphics.newQuad(2 * 32, 0 * 32, 32, 32, 96, 320),  -- exclaim
      LOVE.graphics.newQuad(2 * 32, 1 * 32, 32, 32, 96, 320),  -- questionmark
      LOVE.graphics.newQuad(2 * 32, 2 * 32, 32, 32, 96, 320),  -- up
      LOVE.graphics.newQuad(2 * 32, 3 * 32, 32, 32, 96, 320),  -- right
      LOVE.graphics.newQuad(2 * 32, 4 * 32, 32, 32, 96, 320),  -- down
      LOVE.graphics.newQuad(2 * 32, 5 * 32, 32, 32, 96, 320),  --left
      LOVE.graphics.newQuad(2 * 32, 6 * 32, 32, 32, 96, 320),  -- circle
      LOVE.graphics.newQuad(2 * 32, 7 * 32, 32, 32, 96, 320),  -- aim
      LOVE.graphics.newQuad(2 * 32, 8 * 32, 32, 32, 96, 320)   -- selector
   },
   shipquads = {}
}
Map.__index = Map

Map.shipquads["A"] = LOVE.graphics.newQuad(0, 0, 2 * 32, 32, 160, 160)
Map.shipquads["B"] = LOVE.graphics.newQuad(0, 1 * 32, 3 * 32, 32, 160, 160)
Map.shipquads["C"] = LOVE.graphics.newQuad(0, 2 * 32, 3 * 32, 32, 160, 160)
Map.shipquads["D"] = LOVE.graphics.newQuad(0, 3 * 32, 4 * 32, 32, 160, 160)
Map.shipquads["E"] = LOVE.graphics.newQuad(0, 4 * 32, 5 * 32, 32, 160, 160)

function Map.init(toolimg, shipimg)
   Map.toolimage = toolimg
   Map.shipimage = shipimg

   return Map
end

function Map:update ()
end

function Map:draw ()
   local mx, my = LOVE.mouse.getPosition()
   local shiptypes_str = "ABCDE"
   local rotation = 0
   local roffsetx = 0
   local roffsety = 0

   for rownumber, row in ipairs(self.shiplayer) do
      for tilenumber, col in ipairs(row) do
         if string.find(shiptypes_str, col) then
            if (tilenumber + 1) < 15 and row[tilenumber + 1] == string.lower(col) then
               rotation = math.rad(0)
               roffsetx = 0
               roffsety = 0
            elseif (tilenumber - 1) > 0 and row[tilenumber - 1] == string.lower(col) then
               rotation = math.rad(180)
               roffsetx = 32
               roffsety = 32
            elseif (rownumber + 1) < 15 and self.shiplayer[rownumber + 1][tilenumber] == string.lower(col) then
               rotation = math.rad(90)
               roffsetx = 0
               roffsety = 32
            elseif (rownumber - 1) > 0 and self.shiplayer[rownumber - 1][tilenumber] == string.lower(col) then
               rotation = math.rad(-90)
               roffsetx = 32
               roffsety = 0
            else
               error("FATAL: Ship does not seem to have any adjacend tiles, which should not happen!")
            end
            LOVE.graphics.draw(Map.shipimage, Map.shipquads[col], self.region.x + (tilenumber - 1) * 32, self.region.y + (rownumber - 1) * 32, rotation, nil, nil, roffsetx, roffsety)
         end
         if self.infolayer[rownumber][tilenumber] ~= 0 then
            LOVE.graphics.draw(Map.toolimage, Map.toolquads[self.infolayer[rownumber][tilenumber]], self.region.x + tilenumber * 32, self.region.y + rownumber * 32)
         end
      end
   end

   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local tile_x = math.floor((mx - self.region.x) / 32)
      local tile_y = math.floor((my - self.region.y) / 32)
      LOVE.graphics.draw(Map.toolimage, self.currentcursor, (self.region.x + tile_x * 32), (self.region.y + tile_y * 32))
   end
end

function Map:new(type)
   local map = {
      shiplayer = {
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      },
      infolayer = {
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      },

      region = {x = 0, y = 0, size = 14 * 32},
      currentcursor = self.toolquads[MAPTOOLS.selector]
   }

   if type == self.types.enemy then
      map.region.x = 64
      map.region.y = 32
   else
      map.region.x = 768
      map.region.y = 32
   end

   setmetatable(map, Map)

   return map
end

function Map:setCurrentCursor(key)
   self.currentcursor = Map.toolquads[key]
end

function Map:onMouseClick(mx, my, button)
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local tile_x = math.floor((my - self.region.y) / 32)
      local tile_y = math.floor((mx - self.region.x) / 32)

      local selection = self.infolayer[tile_x][tile_y]
      local maptool_indx = 0
      if selection ~= self.currentcursor then
         for indx, quad in ipairs(self.toolquads) do
            if quad == self.currentcursor then
               maptool_indx = indx
               break
            end
         end
         self.infolayer[tile_x][tile_y] = maptool_indx
      end
   end
end

return Map