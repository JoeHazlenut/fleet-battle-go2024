local rowstr = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"}
local msg_indx = {clean_msg = 1, decrypted_msg = 2}

local function generatePseudoDecryptedString ()
   math.randomseed(os.time())
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
   player_turnmsgdict = {},
   enemy_turnmsgdict = {},
   renderstart_player_x = 270,
   renderstart_player_y = 443,
   renderstart_enemy_x = 270,
   renderstart_enemy_y = 492
}

-- TODO: just for testing, remove 
msgmanager.enemy_turnmsgdict[1] = {
   {("Attack position 'E6'."), generatePseudoDecryptedString()},
   {("Move ship type C fom 'D12' towards south."), generatePseudoDecryptedString()},
   {("Turn ship type A west."), generatePseudoDecryptedString()}
}

function msgmanager.reset ()
   msgmanager.player_turnmsgdict = {}
   msgmanager.enemy_turnmsgdict = {}
end

function msgmanager.logPlayerAttack (r, c)
   if msgmanager.player_turnmsgdict[TURN_NUMBER] == nil then
      msgmanager.player_turnmsgdict[TURN_NUMBER] = {}
   end

   msgmanager.player_turnmsgdict[TURN_NUMBER][#msgmanager.player_turnmsgdict[TURN_NUMBER] + 1] = {("Attack position '" .. rowstr[r] .. c .. "'."), generatePseudoDecryptedString()}
end

function msgmanager.logPlayerMovement (shiptype, facing, start_r, start_c, goal_r, goal_c)
   print("Logging move")
   if msgmanager.player_turnmsgdict[TURN_NUMBER] == nil then
      print("Creating new entry")
      msgmanager.player_turnmsgdict[TURN_NUMBER] = {}
   end

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

   msgmanager.player_turnmsgdict[TURN_NUMBER][#msgmanager.player_turnmsgdict[TURN_NUMBER] + 1] = {("Move ship type " .. shiptype .. " from '" .. rowstr[start_r] .. start_c .. "' towards " .. direction_str .. "."), generatePseudoDecryptedString()}
end

function msgmanager.logPlayerTurnShip (shiptype, facing)
   if msgmanager.player_turnmsgdict[TURN_NUMBER] == nil then
      msgmanager.player_turnmsgdict[TURN_NUMBER] = {}
   end

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

   msgmanager.player_turnmsgdict[TURN_NUMBER][#msgmanager.player_turnmsgdict[TURN_NUMBER] + 1] = {("Turn ship type " .. shiptype .. " towards " .. direction_str .. "."), generatePseudoDecryptedString()}
end

function msgmanager.draw ()
   local vertical_offset = 15
   LOVE.graphics.setFont(msgmanager.font)

   if msgmanager.player_turnmsgdict[TURN_NUMBER] then
      LOVE.graphics.setColor(0, 1, 0, 1)
      for msg_num = 1, 3 do
         local player_action_msg = msgmanager.player_turnmsgdict[TURN_NUMBER][msg_num]
         if player_action_msg then
            LOVE.graphics.print(player_action_msg[msg_indx.clean_msg], msgmanager.renderstart_player_x, msgmanager.renderstart_player_y + (msg_num - 1) * vertical_offset)
         end
      end
      LOVE.graphics.setColor(1, 1, 0, 1)
      LOVE.graphics.print("-----------------------------------------------------", msgmanager.renderstart_player_x, msgmanager.renderstart_player_y + 40)
   end

   if msgmanager.enemy_turnmsgdict[TURN_NUMBER] then
      LOVE.graphics.setColor(1, 0, 0, 1)
      for msg_num = 1, 3 do
         local enemy_action_msg = msgmanager.enemy_turnmsgdict[TURN_NUMBER][msg_num]
         if enemy_action_msg then
            LOVE.graphics.print(enemy_action_msg[msg_indx.decrypted_msg], msgmanager.renderstart_enemy_x, msgmanager.renderstart_enemy_y + (msg_num - 1) * vertical_offset)
         end
      end
   end
end

return msgmanager