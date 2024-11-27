local Commander = require "game.Commander"
local msgmanager = require "game.messagemanager"

local enemy = Commander:new()

function enemy:chooseAttackPosition ()
    math.randomseed(os.clock())
    local rando_r = math.random(1, 15)
    local rando_c = math.random(1, 15)

    self:attack(rando_r, rando_c)
    msgmanager.logAttack(COMNMANDER_UID.enemy, rando_r, rando_c)
end

function enemy:update (dt)
    self:chooseAttackPosition()
end

return enemy