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

------------------------------EXTERNAL----------------------------
local Map = {
   toolimage = LOVE.graphics.newImage("assets/map_tools.png"),
   types = {enemy = 0, player = 1},
   quads = {
      LOVE.graphics.newQuad(2 * 32, 0 * 32, 32, 32, 96, 320),  -- exclaim
      LOVE.graphics.newQuad(2 * 32, 1 * 32, 32, 32, 96, 320),  -- questionmark
      LOVE.graphics.newQuad(2 * 32, 2 * 32, 32, 32, 96, 320),  -- up
      LOVE.graphics.newQuad(2 * 32, 3 * 32, 32, 32, 96, 320),  -- right
      LOVE.graphics.newQuad(2 * 32, 4 * 32, 32, 32, 96, 320),  -- down
      LOVE.graphics.newQuad(2 * 32, 5 * 32, 32, 32, 96, 320),  --left
      LOVE.graphics.newQuad(2 * 32, 6 * 32, 32, 32, 96, 320),  -- circle
      LOVE.graphics.newQuad(2 * 32, 7 * 32, 32, 32, 96, 320),  -- aim
      LOVE.graphics.newQuad(2 * 32, 8 * 32, 32, 32, 96, 320)   -- selector
   }
}
Map.__index = Map

function Map:update ()
end

function Map:draw ()
   local mx, my = LOVE.mouse.getPosition()
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local tile_x = math.floor((mx - self.region.x) / 32)
      local tile_y = math.floor((my - self.region.y) / 32)
      LOVE.graphics.draw(self.toolimage, self.current_cursor_quad, (self.region.x + tile_x * 32), (self.region.y + tile_y * 32))
   end
end

function Map:new(type)
   local map = {
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
      region = {x = 0, y = 0, size = 14 * 32},
      current_cursor_quad = self.quads[MAPTOOLS.ring]
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
   self.current_cursor = Map.quads[key]
end

return Map