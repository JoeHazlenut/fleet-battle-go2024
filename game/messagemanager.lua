COMNMANDER_UID = {player = 1, enemy = 2}

local rowstr = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"}
local start_msg_indx = 1

local function generatePseudoDecryptedString ()
   math.randomseed(os.clock())
   local len = math.random(35, 45)
   local randostr = ""
   for i = 1, len do
      local option = math.random(1, 3)
      if option == 1 then -- a-z
         randostr = randostr .. string.char(math.random(97, 122))
      elseif option == 2 then -- A-Z
         randostr = randostr .. string.char(math.random(65, 90))
      elseif option == 3 then -- 0-9 
         randostr = randostr .. string.char(math.random(48, 57))
      end
   end

   return randostr
end

local msgmanager = {
   font = LOVE.graphics.newFont("assets/pixelfont.ttf", 8),
   renderstart_x = 270,
   renderstart_y = 443,
   msgqueue = {}
}

function msgmanager.reset ()
   msgmanager.msgqueue = nil
   collectgarbage()
   msgmanager.msgqueue = {}
   start_msg_indx = #msgmanager.msgqueue
end

function msgmanager.logAttack(commander_uid, r, c)
   if commander_uid == COMNMANDER_UID.player then
      msgmanager.msgqueue[#msgmanager.msgqueue + 1] = {type = commander_uid, clean = "Attack position '" .. rowstr[r] .. c .. "'.", decrypted = generatePseudoDecryptedString(), show_clean = true}
   else
      msgmanager.msgqueue[#msgmanager.msgqueue + 1] = {type = commander_uid, clean = "Attack position '" .. rowstr[r] .. c .. "'.", decrypted = generatePseudoDecryptedString(), show_clean = false}
   end

   if #msgmanager.msgqueue > 6 then
      start_msg_indx = start_msg_indx + 1
   end
end

function msgmanager.logMovement (commander_uid, shiptype, facing, start_r, start_c, goal_r, goal_c) -- TODO: either remove unused params, or maybe we need them for giving away position
   local direction_str = ""
   if facing == SHIPFACING.up then
      direction_str = "north"
   elseif facing == SHIPFACING.right then
      direction_str = "east"
   elseif facing == SHIPFACING.down then
      direction_str = "south"
   elseif facing == SHIPFACING.left then
      direction_str = "west"
   end

   if commander_uid == COMNMANDER_UID.player then
      msgmanager.msgqueue[#msgmanager.msgqueue + 1] =  {type = commander_uid, clean = "Move ship type " .. shiptype .. " from '" .. rowstr[start_r] .. start_c .. "' towards " .. direction_str .. ".", decrypted = generatePseudoDecryptedString(), show_clean = true}
   else
      msgmanager.msgqueue[#msgmanager.msgqueue + 1] =  {type = commander_uid, clean = "Move ship type " .. shiptype .. " from '" .. rowstr[start_r] .. start_c .. "' towards " .. direction_str .. ".", decrypted = generatePseudoDecryptedString(), show_clean = false}
   end

   if #msgmanager.msgqueue > 6 then
      start_msg_indx = start_msg_indx + 1
   end
end

function msgmanager.logTurnShip (commander_uid, shiptype, facing)
   local direction_str = ""
   if facing == SHIPFACING.up then
      direction_str = "north"
   elseif facing == SHIPFACING.right then
      direction_str = "east"
   elseif facing == SHIPFACING.down then
      direction_str = "south"
   elseif facing == SHIPFACING.left then
      direction_str = "west"
   end

   if commander_uid == COMNMANDER_UID.player then
      msgmanager.msgqueue[#msgmanager.msgqueue + 1] = {type = commander_uid, clean = "Turn ship type " .. shiptype .. " towards " .. direction_str .. ".", decrypted = generatePseudoDecryptedString(), show_clean = true}
   else
      msgmanager.msgqueue[#msgmanager.msgqueue + 1] = {type = commander_uid, clean = "Turn ship type " .. shiptype .. " towards " .. direction_str .. ".", decrypted = generatePseudoDecryptedString(), show_clean = false}
   end

   if #msgmanager.msgqueue > 6 then
      start_msg_indx = start_msg_indx + 1
   end
end

function msgmanager.draw ()
   if #msgmanager.msgqueue == 0 then
      return
   end

   local vertical_offset = 15
   local amount = 0
   LOVE.graphics.setFont(msgmanager.font)

   local current_indx = start_msg_indx
   local end_indx = start_msg_indx + 6
   while current_indx ~= end_indx do
      if msgmanager.msgqueue[current_indx] then
         if msgmanager.msgqueue[current_indx].type == COMNMANDER_UID.player then
         LOVE.graphics.setColor(0, 1, 0, 1)
         else
            LOVE.graphics.setColor(1, 0, 0, 1)
         end
         if msgmanager.msgqueue[current_indx].show_clean then
            LOVE.graphics.print(msgmanager.msgqueue[current_indx].clean, msgmanager.renderstart_x, msgmanager.renderstart_y + amount * vertical_offset)
         else
            LOVE.graphics.print(msgmanager.msgqueue[current_indx].decrypted, msgmanager.renderstart_x, msgmanager.renderstart_y + amount * vertical_offset)
         end
      else
         break
      end

      amount = amount + 1
      current_indx = current_indx + 1
   end
end

function msgmanager:getMostRecentEnemyMsg ()
   local current_indx = start_msg_indx
   local end_indx = start_msg_indx + math.min(6, #msgmanager.msgqueue)

   local msgs = {}

   while current_indx ~= end_indx do
      if msgmanager.msgqueue[current_indx].type == COMNMANDER_UID.enemy and msgmanager.msgqueue[current_indx].show_clean == false then
         table.insert(msgs, msgmanager.msgqueue[current_indx])
      end

      current_indx = current_indx + 1
   end

   return msgs[1], msgs[2], msgs[3]
end

return msgmanager