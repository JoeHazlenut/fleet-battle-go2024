local Commander = require "game.Commander"
local msgmanager = require "game.messagemanager"

local attacks = {}
local frame_wait_cntr = 60

local enemy = Commander:new()

function enemy:update (dt)
    self:chooseAttackPosition()
end

function enemy:decipher ()
    -- make the enemy know what the player does
    msgmanager.logDecipher(COMNMANDER_UID.player)
end

function enemy:chooseAttackPosition ()
    math.randomseed(os.clock())
    local rando_r = math.random(1, 15)
    local rando_c = math.random(1, 15)

    attacks[#attacks + 1] = function () self:attack(rando_r, rando_c) end
    msgmanager.logAttack(COMNMANDER_UID.enemy, rando_r, rando_c)

    self.ap = self.ap - 1
end

function enemy:executeAttacks ()
    if #attacks > 0 then
        if frame_wait_cntr >= 0 then
            frame_wait_cntr = frame_wait_cntr - 1
        else
            local attack = table.remove(attacks, 1)
            attack()
            frame_wait_cntr = 60
        end
    end

    if #attacks == 0 then
        return true
    end
end

return enemy