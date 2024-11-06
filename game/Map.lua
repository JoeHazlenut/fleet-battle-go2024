local Map = {
   toolimage = LOVE.graphics.newImage("assets/map_tools.png"),
   types = {enemy = 0, player = 1},
   quads = {
      cursor = LOVE.graphics.newQuad(2 * 32, 8 * 32, 32, 32, 96, 288)
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
      current_cursor_quad = self.quads.cursor
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

return Map