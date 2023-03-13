function love.load()
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0)

    camera = require 'libraries/camera'
    cam = camera()
    anim8 = require 'libraries/anim8'
    
    love.graphics.setBackgroundColor(0.5, 0.6, 0.8)
    love.graphics.setDefaultFilter("nearest", "nearest")   --clarify the pixels

    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')

-- HUMP : Helper Utilities for Massive Progression, collection of tools such as camera.

    function love.conf(t)
        t.window.title = "Chammak Challo"
        t.window.icon = "images/twit.png"
    end

    player = {}
    --(x,y,width,height,how far caved in the corners)
    player.collider = world:newBSGRectangleCollider(300, 150, 50, 80, 7)
    player.collider:setFixedRotation(true)
    player.x = 400 -- player position on x-axis
    player.y = 200 -- player position on y-axis
    player.speed = 300
    player.images = love.graphics.newImage('images/parrot.png')
    player.imagesheet = love.graphics.newImage('images/player-sheet.png')
    
    --Open source software anim8 used.
    player.grid = anim8.newGrid( 12, 18, player.imagesheet:getWidth(), player.imagesheet:getHeight() )
    
    --animations saved in a table
    --frame is going to change after every 0.2sec
    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )

    player.anim = player.animations.down

    background = love.graphics.newImage('images/background.png')

    sounds = {}
    --static means whole file is loaded into memory
    --stream means audio is streamed in chunks 
    sounds.blip = love.audio.newSource("sounds/alert1.mp3", "static")
    sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
    sounds.music:setLooping(true)

    sounds.music:play()

    --add a walls table
    walls = {}
    if gameMap.layers["Walls"] then
        for i, obj in pairs(gameMap.layers["Walls"].objects) do
           --adding wall collider
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    electric = {}
    if gameMap.layers["electric"] then
        for i, obj in pairs(gameMap.layers["electric"].objects) do
            --adding wall collider
             local ec = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
             ec:setType('static')
             table.insert(electric, ec)  
        end
    end

    text = {}
    if gameMap.layers["text"] then
        for i, obj in pairs(gameMap.layers["text"].objects) do
            --adding wall collider
             local tex = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
             tex:setType('static')
             table.insert(text, tex)    
        end
    end
end

function love.update(dt)

    -- the image is continuously moving even when no arrow keys are pressed.
    local isMoving = false
    local vx = 0 --velocity of collider in x position
    local vy = 0 --velocity in y
    
    --corresponds to the arrow keys
    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end 
    if love.keyboard.isDown("left") then
        vx = player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end   
    if love.keyboard.isDown("down") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true
    end  
    if love.keyboard.isDown("up") then
        vy = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end 

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.collider:setLinearVelocity(vx, vy)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then
        cam.x = w/2
    end

    if cam.y < h/2 then
        cam.y = h/2
    end

end

function love.draw()
    cam:attach()
        --gameMap:drawLayer(gameMap.layers["Trees"])
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["electric"])
        gameMap:drawLayer(gameMap.layers["text"])
        local bachekadimension = player.anim:draw(player.imagesheet, player.x, player.y, nil, 5, nil, 6, 9)
        --world:draw()
    cam:detach()

    function love.keypressed(key)
        if key == "f" then
            sounds.blip:play()
        end

        if key =="q" then
            sounds.music:stop()
        end
    end

end

    --mode
    --love.graphics.circle("fill", player.x, player.y, 10)
    --love.graphics.draw(background, 0, 0)
    --love.graphics.draw(player.images, player.x, player.y)
    --nil is used to rotate the image since we don't want it
    --scale aspect 10