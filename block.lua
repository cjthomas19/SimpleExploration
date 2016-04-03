block = class()

function block:init(id,lightLevel, meshIndex,lightMeshIndex,breakt,out)
    -- you can accept and set parameters here
    self.id = id
    self.meshIndex = meshIndex
    self.lmi = lightMeshIndex
    self.lightl = lightLevel
    self.h = breakt
    self.outside = out
end

function block:draw()
    -- Codea does not automatically call this method
end

function block:touched(touch)
    -- Codea does not automatically call this method
end
