function love.load()
    wf = require 'libraries/windfield'

    world =wf.newWorld(0, 500)
-- (0,100) represents x and y as gravity, since its +100 so the rectangle goes downward.
--350 : position of x
--100 : position of y
-- 80 : width of rectangle
-- 80: height
    player = world:newRectangleCollider(350, 100, 80, 80)
    ground = world:newRectangleCollider(100,400,600,100)
    ground:setType('static')

end

function love.update(dt)
--to limit force
    local px, py = player:getLinearVelocity()

--to use force
    if love.keyboard.isDown('left') and px > -300 then
        player:applyForce(-5000, 0)
    elseif love.keyboard.isDown('right') and py < 300 then
        player:applyForce(5000,0)
    end
    


    world:update(dt)
end

function love.draw()
    world:draw()
end

function love.keypressed(key)
    if key == 'space' then
        player:applyLinearImpulse(0,-5000)
    end
end