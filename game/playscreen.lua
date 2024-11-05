---------------------Internal-------------------
local images = {
   bg = LOVE.graphics.newImage("assets/background.png"),
   msgfont = LOVE.graphics.newFont("assets/pixelfont.otf")
}


--------------------External--------------------
local playscreen = {}

function playscreen.update (dt)
end

function playscreen.draw ()
   LOVE.graphics.draw(images.bg)
end

return playscreen