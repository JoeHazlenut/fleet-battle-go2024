local love = require "love"

function love.conf (t)
   t.version = "11.5"

   t.window.title = "Fleet Battle Enigma"
   t.window.width = 960
   t.window.height = 540
   t.window.fullscreen = false
   t.window.fullscreentype = "desktop"

   t.consule = false

   t.modules.joystick = false
   t.modules.physics = false
   t.modules.touch = false
   t.modules.video = false
end
