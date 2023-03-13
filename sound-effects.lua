--With Sound Effects

function love.load()
    player ={}
    player.x = 400
    player.y = 200
    player.sound = 5

    sounds = {}
    --static means whole file is loaded into memory
    --stream means audio is streamed in chunks 
    sounds.blip = love.audio.newSource("sounds/blip.wav", "static")
    sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
    sounds.music:setLooping(true)

    sounds.music:play()
end

function love.update(dt)

end

function love.draw()
    love.graphics.circle("fill", player.x, player.y, 100)
end

function love.keypressed(key)
    if key == "space" then
        sounds.blip:play()
    end

    if key =="z" then
        sounds.music:stop()
    end
end