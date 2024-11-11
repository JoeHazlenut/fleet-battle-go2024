local Button = {
   font = LOVE.graphics.newFont("assets/pixelfont.ttf", 8),
   color = {0.44, 0.8, 0.44, 1}
}
Button.__index = Button

function Button:new (img, normalq, hoverq, selectedq, x, y, w, h, callback, text)
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
      action = callback,
      txt = text,
      visible = true
   }

   if newbutton.txt then
      newbutton.txtx = newbutton.x + (newbutton.w / 2) - (Button.font:getWidth(newbutton.txt) / 2)
      newbutton.txty = newbutton.y + (newbutton.h / 2) - (Button.font:getHeight(newbutton.txt) / 2)
   end

   setmetatable(newbutton, Button)

   return newbutton
end

function Button:isMouseInside(mx, my)
   if self.visible then
      if (mx > self.x and mx < self.x + self.w) and (my > self.y and my < self.y + self.h) then
         if not self.active then
            self.hot = true
         end
      else
         self.hot = false
      end

      return self.hot
   end
end

function Button:draw ()
   if self.visible then
      if self.hot then
         LOVE.graphics.draw(self.srcimg, self.hq, self.x, self.y)
      elseif self.active then
         LOVE.graphics.draw(self.srcimg, self.sq, self.x, self.y)
      else
         LOVE.graphics.draw(self.srcimg, self.nq, self.x, self.y)
      end

      --TODO: individual colors
      if self.txt then
         LOVE.graphics.setFont(Button.font)
         LOVE.graphics.setColor(Button.color)
         LOVE.graphics.print(self.txt, self.txtx, self.txty)
      end
   end
end

return Button