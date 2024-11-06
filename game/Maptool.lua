local Maptool = {}
Maptool.__index = Maptool

function Maptool:update (mx, my)
   if (mx > self.x and mx < self.x + 32) and (my > self.y and my < self.y + 32) then
      self.active = true
   else
      self.active = false
   end
end

function Maptool:draw ()
   if self.active then
      LOVE.graphics.draw(self.srcimg, self.activeq, self.x, self.y)
   else
      LOVE.graphics.draw(self.srcimg, self.passiveq, self.x, self.y)
   end
end

function Maptool:new (passivquad, activequad, img, x, y)
   local newtool = {
      srcimg = img,
      passiveq = passivquad,
      activeq = activequad,
      active = false,
      x = x or 0,
      y = y or 0
   }
   setmetatable(newtool, Maptool)

   return newtool
end


return Maptool