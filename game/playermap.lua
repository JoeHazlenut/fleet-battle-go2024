local Map = require "game.Map"

local activeshipimg = LOVE.graphics.newImage("assets/new/ships_active.png")
local activeshiptype = ""

local playermap = Map:new(Map.types.player)

local stepspossible = 0
local moveoption_draw_start_r = 0
local moveoption_draw_start_c = 0
local facing = 0
local activeshipsize = 0

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

            if activeshiptype == col then
               LOVE.graphics.draw(activeshipimg, Map.shipquads[col], self.region.x + (tilenumber - 1) * TILESIZE, self.region.y + (rownumber - 1) * TILESIZE, rotation, nil, nil, roffsetx, roffsety)
            else
               LOVE.graphics.draw(Map.shipimage, Map.shipquads[col], self.region.x + (tilenumber - 1) * TILESIZE, self.region.y + (rownumber - 1) * TILESIZE, rotation, nil, nil, roffsetx, roffsety)
            end
         end

         if self.infolayer[rownumber][tilenumber] ~= 0 then
            LOVE.graphics.draw(Map.toolimage, Map.toolquads[self.infolayer[rownumber][tilenumber]], self.region.x + (tilenumber - 1) * TILESIZE, self.region.y + (rownumber - 1) * TILESIZE)
         end
      end

      if activeshiptype ~= "" then
         LOVE.graphics.setColor(1, 1, 0, 0.015)
         if facing == SHIPFACING.up then
            for cntr = 1, stepspossible do
               if moveoption_draw_start_r - cntr > 0 then
                  if self.shiplayer[moveoption_draw_start_r - cntr][moveoption_draw_start_c] == 0 then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1 - cntr) * TILESIZE), TILESIZE, TILESIZE)
                  else
                     stepspossible = cntr - 1
                     break
                  end
               end
            end
         elseif facing == SHIPFACING.right then
            for cntr = 1, stepspossible do
               if moveoption_draw_start_c + cntr < 16 then
                  if self.shiplayer[moveoption_draw_start_r][moveoption_draw_start_c + cntr] == 0 then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1 + cntr) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1) * TILESIZE), TILESIZE, TILESIZE)
                  else
                     stepspossible = cntr - 1
                     break
                  end
               end
            end
         elseif facing == SHIPFACING.down then
            for cntr = 1, stepspossible do
               if moveoption_draw_start_r + cntr < 16 then
                  if self.shiplayer[moveoption_draw_start_r + cntr][moveoption_draw_start_c] == 0 then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1 + cntr) * TILESIZE), TILESIZE, TILESIZE)
                  else
                     stepspossible = cntr - 1
                     break
                  end
               end
            end
         elseif facing == SHIPFACING.left then
            for cntr = 1, stepspossible do
               if moveoption_draw_start_c - cntr > 0 then
                  if self.shiplayer[moveoption_draw_start_r][moveoption_draw_start_c - cntr] == 0 then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1 - cntr) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1) * TILESIZE), TILESIZE, TILESIZE)
                  else
                     stepspossible = cntr - 1
                     break
                  end
               end
            end
         end
      end

      LOVE.graphics.setColor(1, 1, 1, 1)
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
   else -- val is a lower case letter, so we clicked the middle of the ship, we need to find the facing
      local step = 1
      while (r + step < 16) do
         local tilecontent = playermap.shiplayer[r + step][c]
         if tilecontent == 0 then
            break
         elseif tilecontent == string.upper(shiptype) then
            return r + step, c, SHIPFACING.down
         end
         step = step + 1
      end

      step = 1
      while (r - step > 0) do
         local tilecontent = playermap.shiplayer[r - step][c]
         if tilecontent == 0 then
            break
         elseif tilecontent == string.upper(shiptype) then
            return r - step, c, SHIPFACING.up
         end
         step = step + 1
      end

      step = 1
      while (c + step < 16) do
         local tilecontent = playermap.shiplayer[r][c + step]
         if tilecontent == 0 then
            break
         elseif tilecontent == string.upper(shiptype) then
            return r, c + step, SHIPFACING.right
         end
         step = step + 1
      end

      step = 1
      while (c - step > 0) do
         local tilencontent = playermap.shiplayer[r][c - step]
         if tilencontent == 0 then
            break
         elseif tilencontent == string.upper(shiptype) then
            return r, c - step, SHIPFACING.left
         end
         step = step + 1
      end
   end
end

function playermap:onMouseClick(mx, my, button, other, player)
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local row = math.floor((my - self.region.y) / TILESIZE) + 1
      local col = math.floor((mx - self.region.x) / TILESIZE) + 1

      if button == 1 then
         if self:getCursorKey() == MAPTOOLS.move then
            local selection = self.shiplayer[row][col]
            local ship = string.upper(selection)
            if string.find(shiptypes_str, ship) then
               activeshiptype = ship
               moveoption_draw_start_r, moveoption_draw_start_c, facing = getShipFacing(row, col, selection, ship)

               if ship == "A" then
                  stepspossible = 5
                  activeshipsize = 2
               elseif ship == "B" then
                  stepspossible = 3
                  activeshipsize = 3
               elseif ship == "C" then
                  stepspossible = 4
                  activeshipsize = 3
               elseif ship == "D" then
                  stepspossible = 3
                  activeshipsize = 4
               elseif ship == "E" then
                  stepspossible = 2
                  activeshipsize = 5
               else
                  stepspossible = 0
               end
            end
         end
      end
      if button == 2 then
         activeshiptype = ""
         activeshipsize = 0
         player:resetPreviews()
      end

      if activeshiptype ~= "" then
         for cntr = 1, stepspossible do
            if facing == SHIPFACING.up and col == moveoption_draw_start_c then
               if row == moveoption_draw_start_r - cntr then
                  player:moveShip(moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  activeshipsize = 0
                  activeshiptype = ""
                  moveoption_draw_start_c = 0
                  moveoption_draw_start_r = 0
                  break
               end
            elseif facing == SHIPFACING.right and row == moveoption_draw_start_r then
               if col == moveoption_draw_start_c + cntr then
                  player:moveShip(moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  activeshipsize = 0
                  activeshiptype = ""
                  moveoption_draw_start_c = 0
                  moveoption_draw_start_r = 0
                  break
               end
            elseif facing == SHIPFACING.down and col == moveoption_draw_start_c then
               if row == moveoption_draw_start_r + cntr then
                  player:moveShip(moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  activeshipsize = 0
                  activeshiptype = ""
                  moveoption_draw_start_c = 0
                  moveoption_draw_start_r = 0
                  break
               end
            elseif facing == SHIPFACING.left and row == moveoption_draw_start_r then
               if col == moveoption_draw_start_c - cntr then
                  player:moveShip(moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  activeshipsize = 0
                  activeshiptype = ""
                  moveoption_draw_start_c = 0
                  moveoption_draw_start_r = 0
                  break
               end
            end
         end
      end
   else
      activeshiptype = ""
      activeshipsize = 0
      player:resetPreviews()
   end

   Map.onMouseClick(self, mx, my, button, other)
end

function playermap:isShipSelected ()
   if activeshiptype ~= "" then
      return true
   else
      return false
   end
end

return playermap