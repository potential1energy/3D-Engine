local class = require 'object types.class'
local object = class:derive('object')

function object:new(name, verts, texture, pos, rot)
    local VertFormat = {{"VertexPosition", "float", 3}, {"VertexTexCoord", "float", 2}, {"VertexColor", "byte", 4}}
    self.verts = verts
    self.texture = love.graphics.newImage(texture)
    self.mesh = love.graphics.newMesh(VertFormat, self.verts, "triangles")
    self.mesh:setTexture(self.texture)
    self.pos = pos or {0,0,0}
    self.rot = rot or {0,0,0}
    self.name = name
end

function object:update(dt)
    
end

function object:draw()
    shader3D:send("ObjectTransform", {self.pos[1], self.pos[2], self.pos[3], 0})
    love.graphics.draw(self.mesh)
end

return object