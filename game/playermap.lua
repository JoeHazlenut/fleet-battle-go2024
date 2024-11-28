local Map = require "game.Map"

local activeshipimg = LOVE.graphics.newImage("assets/new/ships_active.png")
local activeshiptype = ""

local playermap = Map:new(Map.types.player)

local stepspossible = 0
local moveoption_draw_start_r = 0
local moveoption_draw_start_c = 0
local facing = 0
local activeshipsize = 0

local turntiles = {}

local movemode = 0

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

         -- ------------MOVE------------------
         if movemode == MAPTOOLS.move then
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
         -- ------------TURN------------------
         elseif movemode == MAPTOOLS.turn then
            local num_tiles_to_draw = activeshipsize - 1
            -- ----------ship facing up--------------
            if facing == SHIPFACING.up then
               local draw_start_row = moveoption_draw_start_r + activeshipsize - 1
               local draw_left = true
               local draw_right = true

               if moveoption_draw_start_c - num_tiles_to_draw > 0 then -- left
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[draw_start_row][moveoption_draw_start_c - step] ~= 0 then
                        draw_left = false
                     end
                  end
               else
                  draw_left = false
               end

               if moveoption_draw_start_c + num_tiles_to_draw < 16 then -- right
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[draw_start_row][moveoption_draw_start_c + step] ~= 0 then
                        draw_right = false
                     end
                  end
               else
                  draw_right = false
               end

               for step = 1, num_tiles_to_draw do
                  if draw_left then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1 - step) * TILESIZE), (self.region.y + (draw_start_row - 1) * TILESIZE), TILESIZE, TILESIZE)
                  end
                  if draw_right then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1 + step) * TILESIZE), (self.region.y + (draw_start_row - 1) * TILESIZE), TILESIZE, TILESIZE)
                  end
               end

            -- -------------ship facing right----------------
            elseif facing == SHIPFACING.right then
               local draw_start_col = moveoption_draw_start_c - activeshipsize + 1
               local draw_down = true
               local draw_up = true

               if moveoption_draw_start_r - num_tiles_to_draw > 0 then -- up
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[moveoption_draw_start_r - step][draw_start_col] ~= 0 then
                        draw_up = false
                     end
                  end
               else
                  draw_up = false
               end

               if moveoption_draw_start_r + num_tiles_to_draw < 16 then -- right
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[moveoption_draw_start_r + step][draw_start_col] ~= 0 then
                        draw_down = false
                     end
                  end
               else
                  draw_down = false
               end

               for step = 1, num_tiles_to_draw do
                  if draw_up then
                     LOVE.graphics.rectangle("fill", (self.region.x + (draw_start_col - 1) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1 - step) * TILESIZE), TILESIZE, TILESIZE)
                  end
                  if draw_down then
                     LOVE.graphics.rectangle("fill", (self.region.x + (draw_start_col - 1) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1 + step) * TILESIZE), TILESIZE, TILESIZE)
                  end
               end

            -- ----------ship facing down ------------------
            elseif facing == SHIPFACING.down then
               local draw_start_row = moveoption_draw_start_r - activeshipsize + 1
               local draw_left = true
               local draw_right = true

               if moveoption_draw_start_c - num_tiles_to_draw > 0 then -- left
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[draw_start_row][moveoption_draw_start_c - step] ~= 0 then
                        draw_left = false
                     end
                  end
               else
                  draw_left = false
               end

               if moveoption_draw_start_c + num_tiles_to_draw < 16 then -- right
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[draw_start_row][moveoption_draw_start_c + step] ~= 0 then
                        draw_right = false
                     end
                  end
               else
                  draw_right = false
               end

               for step = 1, num_tiles_to_draw do
                  if draw_left then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1 - step) * TILESIZE), (self.region.y + (draw_start_row - 1) * TILESIZE), TILESIZE, TILESIZE)
                  end
                  if draw_right then
                     LOVE.graphics.rectangle("fill", (self.region.x + (moveoption_draw_start_c - 1 + step) * TILESIZE), (self.region.y + (draw_start_row - 1) * TILESIZE), TILESIZE, TILESIZE)
                  end
               end

            -- ------------ship facing left---------------------
            elseif facing == SHIPFACING.left then
               local draw_start_col = moveoption_draw_start_c + activeshipsize - 1
               local draw_down = true
               local draw_up = true

               if moveoption_draw_start_r - num_tiles_to_draw > 0 then -- up
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[moveoption_draw_start_r - step][draw_start_col] ~= 0 then
                        draw_up = false
                     end
                  end
               else
                  draw_up = false
               end

               if moveoption_draw_start_r + num_tiles_to_draw < 16 then -- right
                  for step = 1, num_tiles_to_draw do
                     if self.shiplayer[moveoption_draw_start_r + step][draw_start_col] ~= 0 then
                        draw_down = false
                     end
                  end
               else
                  draw_down = false
               end

               for step = 1, num_tiles_to_draw do
                  if draw_up then
                     LOVE.graphics.rectangle("fill", (self.region.x + (draw_start_col - 1) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1 - step) * TILESIZE), TILESIZE, TILESIZE)
                  end
                  if draw_down then
                     LOVE.graphics.rectangle("fill", (self.region.x + (draw_start_col - 1) * TILESIZE), (self.region.y + (moveoption_draw_start_r - 1 + step) * TILESIZE), TILESIZE, TILESIZE)
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

local function resetActionVariables ()
   activeshipsize = 0
   activeshiptype = ""
   moveoption_draw_start_c = 0
   moveoption_draw_start_r = 0
   movemode = 0
end

function playermap:onMouseClick(mx, my, button, other, player)
   if (mx > self.region.x and mx < self.region.x + self.region.size) and
   (my > self.region.y and my < self.region.y + self.region.size) then
      local row = math.floor((my - self.region.y) / TILESIZE) + 1
      local col = math.floor((mx - self.region.x) / TILESIZE) + 1

      if movemode == 0 then
         movemode = self:getCursorKey()
      end

      if button == 1 then
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
      elseif button == 2 then
         activeshiptype = ""
         activeshipsize = 0
         player:resetPreviews()
      end

      local action_taken = false

      if activeshiptype ~= "" and movemode == MAPTOOLS.move then
         print("Click and tool is move")
         for cntr = 1, stepspossible do
            if facing == SHIPFACING.up and col == moveoption_draw_start_c then
               if row == moveoption_draw_start_r - cntr then
                  action_taken = player:moveShip(activeshiptype, moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  break
               end
            elseif facing == SHIPFACING.right and row == moveoption_draw_start_r then
               if col == moveoption_draw_start_c + cntr then
                  action_taken = player:moveShip(activeshiptype, moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  break
               end
            elseif facing == SHIPFACING.down and col == moveoption_draw_start_c then
               if row == moveoption_draw_start_r + cntr then
                  action_taken = player:moveShip(activeshiptype, moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  break
               end
            elseif facing == SHIPFACING.left and row == moveoption_draw_start_r then
               if col == moveoption_draw_start_c - cntr then
                  action_taken = player:moveShip(activeshiptype, moveoption_draw_start_r, moveoption_draw_start_c, row, col, activeshipsize, facing)
                  break
               end
            end
         end

      elseif activeshiptype ~= "" and movemode == MAPTOOLS.turn then
         local turn_row_up = moveoption_draw_start_r + activeshipsize - 1
         local turn_col_right = moveoption_draw_start_c - activeshipsize + 1
         local turn_row_down = moveoption_draw_start_r - activeshipsize + 1
         local turn_col_left = moveoption_draw_start_c + activeshipsize - 1

         for cntr = 1, activeshipsize - 1 do
            if facing == SHIPFACING.up and row == turn_row_up then
               if (col == moveoption_draw_start_c + cntr) then
                  local goal_c = moveoption_draw_start_c + activeshipsize - 1
                  action_taken = player:turnShip(activeshiptype, turn_row_up, moveoption_draw_start_c, turn_row_up, goal_c, activeshipsize, facing)
               elseif (col == moveoption_draw_start_c - cntr) then
                  local goal_c = moveoption_draw_start_c - activeshipsize + 1
                  action_taken = player:turnShip(activeshiptype, turn_row_up, moveoption_draw_start_c, turn_row_up, goal_c, activeshipsize, facing)
               end
            elseif facing == SHIPFACING.right and col == turn_col_right then
               if (row == moveoption_draw_start_r + cntr) then
                  local goal_r = moveoption_draw_start_r + activeshipsize - 1
                  action_taken = player:turnShip(activeshiptype, moveoption_draw_start_r, turn_col_right, goal_r, turn_col_right, activeshipsize, facing)
               elseif (row == moveoption_draw_start_r - cntr) then
                  local goal_r = moveoption_draw_start_r - activeshipsize + 1
                  action_taken = player:turnShip(activeshiptype, moveoption_draw_start_r, turn_col_right, goal_r, turn_col_right, activeshipsize, facing)
               end
            elseif facing == SHIPFACING.down and row == turn_row_down then
               if (col == moveoption_draw_start_c + cntr) then
                  local goal_c = moveoption_draw_start_c + activeshipsize - 1
                  action_taken = player:turnShip(activeshiptype, turn_row_down, moveoption_draw_start_c, turn_row_down, goal_c, activeshipsize, facing)
               elseif (col == moveoption_draw_start_c - cntr) then
                  local goal_c = moveoption_draw_start_c - activeshipsize + 1
                  action_taken = player:turnShip(activeshiptype, turn_row_down, moveoption_draw_start_c, turn_row_down, goal_c, activeshipsize, facing)
               end
            elseif facing == SHIPFACING.left and col == turn_col_left then
               if (row == moveoption_draw_start_r + cntr) then
                  local goal_r = moveoption_draw_start_r + activeshipsize - 1
                  action_taken = player:turnShip(activeshiptype, moveoption_draw_start_r, turn_col_left, goal_r, turn_col_left, activeshipsize, facing)
               elseif (row == moveoption_draw_start_r - cntr) then
                  local goal_r = moveoption_draw_start_r - activeshipsize + 1
                  action_taken = player:turnShip(activeshiptype, moveoption_draw_start_r, turn_col_left, goal_r, turn_col_left, activeshipsize, facing)
               end
            end
         end
      end

      if action_taken then
         resetActionVariables()
      end
   else
      resetActionVariables()
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