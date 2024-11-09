local Button = {}
Button.__index = Button

function Button:new (img, normalq, hoverq, selectedq, x, y, w, h, callback)
   local newbutton = {
      srcimg = img,
      nq = normalq,
      hq = hoverq,
      sq = selectedq,
      x = x or 0,
      y = y or 0,
      w = w or 0,
      h = h or 0,
      hot = false,
      active = false,
      action = callback
   }

   setmetatable(newbutton, Button)

   return newbutton
end

function Button:isMouseInside(mx, my)
   if (mx > self.x and mx < self.x + self.w) and (my > self.y and my < self.y + self.h) then
      if not self.active then
         self.hot = true
      end
   else
      self.hot = false
   end

   return self.hot
end

function Button:draw ()
   if self.hot then
      LOVE.graphics.draw(self.srcimg, self.hq, self.x, self.y)
   elseif self.active then
      LOVE.graphics.draw(self.srcimg, self.sq, self.x, self.y)
   else
      LOVE.graphics.draw(self.srcimg, self.nq, self.x, self.y)
   end
end

return Button