local json = require 'libs.json'
local jsonp = require 'libs.jsonformat'
LoadOBJ = require 'objtovfd'
mat4_mt = {}
math.sind = function (x)
    return math.sin(math.rad(x))
end
math.cosd = function (x)
    return math.cos(math.rad(x))
end

function math.newM(m)
	m = m or {
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0
	}
	m._m = m
	return setmetatable(m, mat4_mt)
end

function math.from_perspective(fovy, aspect, near, far)
	assert(aspect ~= 0)
	assert(near   ~= far)

	local t   = math.tan(math.rad(fovy) / 2)
	local out = math.newM()
	out[1]    =  1 / (t * aspect)
	out[6]    =  1 / t
	out[11]   = -(far + near) / (far - near)
	out[12]   = -1
	out[15]   = -(2 * far * near) / (far - near)
	out[16]   =  0

	return out
end

function math.distance(x,y,z)
    return math.sqrt((x * x) + ((y * y) + (z * z)))
end

function AllmeshAdd(Meshes)
    local res = {}
    table.foreach(Meshes, function (key, mesh)
        table.foreach(mesh, function (key, vert)
            table.insert(res, vert)
        end)
    end)
end

function love.load()
    love.window.setMode(1280, 720, {resizable = true})
    WIDTH, HEIGHT = love.graphics.getDimensions()

	love.graphics.setBackgroundColor(0.2, 0.2, 0.2, 0)

    Canvas = love.graphics.newCanvas(WIDTH, HEIGHT, { type = "2d", format = "normal", readable = true })
    depthbuffer = love.graphics.newCanvas(WIDTH, HEIGHT, { type = "2d", format = "depth24", readable = true })

    VertFormat = {
        {"VertexPosition", "float", 3},
        {"VertexTexCoord", "float", 2},
        {"VertexNormal", "float", 3},
        {"VertexColor", "byte", 4},
    }
    shader3D = love.graphics.newShader(love.filesystem.read('3Dpixel.glsl'), love.filesystem.read('3DVertex.glsl'))
    projmatrix = math.from_perspective(45, WIDTH/HEIGHT, 0.01, 1000.0)
    love.graphics.setMeshCullMode("back")
    objects = {}


    Camera = {}
    Camera.pos = {}
    Camera.rot = {}

    Camera.pos.x = 0.0
    Camera.pos.y = 0.0
    Camera.pos.z = 0.0
    Camera.rot.x = 0.0
    Camera.rot.y = 0.0
    Camera.rot.z = 0.0

    love.graphics.setDepthMode("lequal", true)

    --objects

    earth = LoadOBJ('sphere.obj')
        
    mesh = love.graphics.newMesh(VertFormat, earth, "triangles")
    mesh:setTexture(love.graphics.newImage('earth.png'))

    --
    
end

function love.update(dt)
    WIDTH, HEIGHT = love.graphics.getDimensions()
    projmatrix = math.from_perspective(45, WIDTH/HEIGHT, 1.0, 1000.0)
    local speed = 50

    if love.keyboard.isDown("w") then
        Camera.pos.x = Camera.pos.x + ((math.sind(Camera.rot.y) * speed) * dt)
        Camera.pos.z = Camera.pos.z + ((math.cosd(Camera.rot.y) * speed) * dt)
    end
    if love.keyboard.isDown("s") then
        Camera.pos.x = Camera.pos.x + ((math.sind(Camera.rot.y) * -speed) * dt)
        Camera.pos.z = Camera.pos.z + ((math.cosd(Camera.rot.y) * -speed) * dt)
    end
end

function love.draw()
    love.graphics.setCanvas({Canvas, depthstencil = depthbuffer})
    love.graphics.setShader(shader3D)

    love.graphics.clear(0.2, 0.2, 0.2, 1)

    local camrotS = {math.sind(0-Camera.rot.x), math.sind(0-Camera.rot.y), math.sind(0-Camera.rot.z), 0}
    local camrotC = {math.cosd(0-Camera.rot.x), math.cosd(0-Camera.rot.y), math.cosd(0-Camera.rot.z), 0}
    local campos = {Camera.pos.x, Camera.pos.y, Camera.pos.z, 0}

    local sunpos = {0,100,0,0}

    shader3D:send("isCanvasEnabled", love.graphics.getCanvas() ~= nil)
    shader3D:send("proj", "column", projmatrix)
    shader3D:send("campos", campos)
    shader3D:send("camrotS", camrotS)
    shader3D:send("camrotC", camrotC)
    shader3D:send('SunPos', sunpos)

    shader3D:send('MeshVerts', earth)
    love.graphics.draw(mesh)

    love.graphics.setShader()
    love.graphics.setCanvas()

    love.graphics.draw(Canvas)
end

function makeObject(name, pos, rot, vfd, textname)
    
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

    Camera.rot.y = Camera.rot.y - xoffset
    Camera.rot.x = Camera.rot.x - yoffset

    if Camera.rot.x > 89 then
        Camera.rot.x = 89
		end
    if Camera.rot.x < -89 then
        Camera.rot.x = -89
		end
end