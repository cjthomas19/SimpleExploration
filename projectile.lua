projectile = class(entity)

function projectile:init(x,y,dir,id,index)
    -- you can accept and set parameters here
    entity.init(x,y,index,10)
end

function projectile:draw()
    -- Codea does not automatically call this method
end

function projectile:touched(touch)
    -- Codea does not automatically call this method
end
