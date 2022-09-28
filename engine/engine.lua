
--Imports
LoadOBJ = require 'engine.parts.objloader'
require 'engine.parts.math'

--Classes
Object3D = require 'object types.object'


--Code
e3d = {}
e3d.objects = {}
e3d.objects.objects = {}

function e3d.load3d() -- Load the 3D engine.
    Canvas = love.graphics.newCanvas(WIDTH, HEIGHT, { type = "2d", format = "normal", readable = true })
    depthbuffer = love.graphics.newCanvas(WIDTH, HEIGHT, { type = "2d", format = "depth24", readable = true })

    VertFormat = { {"VertexPosition", "float", 3}, {"VertexTexCoord", "float", 2}, {"VertexNormal", "float", 3}, {"VertexColor", "byte", 4} }

    shader3D = love.graphics.newShader(love.filesystem.read('engine/shaders/3Dpixel.glsl'), love.filesystem.read('engine/shaders/3DVertex.glsl'))
    projmatrix = math.from_perspective(45, WIDTH/HEIGHT, 0.01, 1000.0)
    love.graphics.setMeshCullMode("back")

    e3d.Camera = {}
    e3d.Camera.pos = {}
    e3d.Camera.rot = {}

    e3d.Camera.pos.x = 0.0
    e3d.Camera.pos.y = 0.0
    e3d.Camera.pos.z = 0.0
    e3d.Camera.rot.x = 0.0
    e3d.Camera.rot.y = 0.0
    e3d.Camera.rot.z = 0.0

    love.graphics.setDepthMode("lequal", true)
end

function e3d.update3d(dt) -- Update the 3D engine.
    projmatrix = math.from_perspective(45, WIDTH/HEIGHT, 1.0, 1000.0)
    for key, object in pairs(e3d.objects.objects) do
        object:update(dt)
    end
end

function e3d.draw3d() -- Draw all 3D objects.
    love.graphics.setCanvas({Canvas, depthstencil = depthbuffer})
    love.graphics.setShader(shader3D)

    love.graphics.clear(0.2, 0.2, 0.2, 1)

    local camrotS = {math.sind(0-e3d.Camera.rot.x), math.sind(0-e3d.Camera.rot.y), math.sind(0-e3d.Camera.rot.z), 0}
    local camrotC = {math.cosd(0-e3d.Camera.rot.x), math.cosd(0-e3d.Camera.rot.y), math.cosd(0-e3d.Camera.rot.z), 0}
    local campos = {e3d.Camera.pos.x, e3d.Camera.pos.y, e3d.Camera.pos.z, 0}

    shader3D:send("isCanvasEnabled", love.graphics.getCanvas() ~= nil)
    shader3D:send("proj", "column", projmatrix)
    shader3D:send("campos", campos)
    shader3D:send("camrotS", camrotS)
    shader3D:send("camrotC", camrotC)

    for key, object in pairs(e3d.objects.objects) do
        object:draw()
    end


    love.graphics.setShader()
    love.graphics.setCanvas()

    love.graphics.draw(Canvas)
end

-- Functions

function e3d.objects.makeObject(name, vert, texture, pos, rot, scale) --Make and return the index of an object.
    table.insert(e3d.objects.objects, Object3D(name, LoadOBJ(vert), texture, pos, rot, scale))
    return #e3d.objects.objects
end