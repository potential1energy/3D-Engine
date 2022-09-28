require 'engine.engine'

function love.load()
    love.window.setMode(1280, 720, {resizable = true})
    WIDTH, HEIGHT = love.graphics.getDimensions()

    e3d.load3d()

	love.graphics.setBackgroundColor(0.2, 0.2, 0.2, 0)

    --objects

    e3d.objects.makeObject('earth', 'assets/sphere.obj', 'assets/earth.png')

    --
    
end

function love.update(dt)
    WIDTH, HEIGHT = love.graphics.getDimensions()
    local speed = 50

    if love.keyboard.isDown("w") then
        e3d.Camera.pos.x = e3d.Camera.pos.x + ((math.sind(e3d.Camera.rot.y) * speed) * dt)
        e3d.Camera.pos.z = e3d.Camera.pos.z + ((math.cosd(e3d.Camera.rot.y) * speed) * dt)
    end
    if love.keyboard.isDown("s") then
        e3d.Camera.pos.x = e3d.Camera.pos.x + ((math.sind(e3d.Camera.rot.y) * -speed) * dt)
        e3d.Camera.pos.z = e3d.Camera.pos.z + ((math.cosd(e3d.Camera.rot.y) * -speed) * dt)
    end

    e3d.update3d(dt)
end

function love.draw()
    e3d.draw3d()
end

firstMouse = true

function love.mousemoved(x, y, dx, dy)
    if firstMouse then
			love.mouse.setPosition(WIDTH / 2, HEIGHT / 2)
			love.mouse.setRelativeMode(true)
			lastX = x
			lastY = y
			firstMouse = false
		end

    xoffset = dx
    yoffset = dy
    lastX = x
    lastY = y

    sensitivity = 0.05
    xoffset = xoffset * sensitivity
    yoffset = yoffset * sensitivity

    e3d.Camera.rot.y = e3d.Camera.rot.y - xoffset
    e3d.Camera.rot.x = e3d.Camera.rot.x - yoffset

    if e3d.Camera.rot.x > 89 then
        e3d.Camera.rot.x = 89
	end
    if e3d.Camera.rot.x < -89 then
        e3d.Camera.rot.x = -89
	end
end