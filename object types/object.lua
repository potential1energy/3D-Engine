local class = require 'object types.class'
local object = class:derive('object')

function object:new(name, pos, rot, vfd, texname)
    self.vfd = vfd
    self.texture = love.graphics.newImage(texname)
    self.pos = pos
    self.rot = rot
    self.name = name
end

function object:draw()
    local VertFormat = {{"VertexPosition", "float", 3}, {"VertexTexCoord", "float", 2}, {"VertexColor", "byte", 4}}
    local meshes
    table.foreach(self.vfd, function (key, face)
        table.insert(meshes, love.graphics.newMesh(VertFormat, face))
    end)
    table.foreach(meshes, function (key, value)
        love.graphics.draw(meshes, 0, 0)
    end)
end