block = class()

function block:init(id, meshIndex)
    -- you can accept and set parameters here
    self.id = id
    self.meshIndex = meshIndex
end

function block:draw()
    -- Codea does not automatically call this method
end

function block:touched(touch)
    -- Codea does not automatically call this method
end
