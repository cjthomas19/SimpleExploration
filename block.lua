block = class()

function block:init(id,lightLevel, meshIndex,lightMeshIndex)
    -- you can accept and set parameters here
    self.id = id
    self.meshIndex = meshIndex
    self.lmi = lightMeshIndex
    self.lightl = lightLevel
end

function block:draw()
    -- Codea does not automatically call this method
end

function block:touched(touch)
    -- Codea does not automatically call this method
end
