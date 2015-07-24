Player = class()

function Player:init(x,y)
    -- you can accept and set parameters here
    self.pos = vec2(x,y)
    self.d = WIDTH/32
end

function Player:draw()
    -- Codea does not automatically call this method
    fill(255,0,0)  
    ellipse(self.pos.x,self.pos.y,self.d)
end

function Player:touched(touch)
    -- Codea does not automatically call this method
end

function Player:move(amount)
    local newX,newY = self.pos.x + amount.x, self.pos.y + amount.y
    local collX,collY = self:testColl(newX,newY)
    if not collX then
        self.pos.x = self.pos.x + amount.x
    end
    if not collY then
        self.pos.y = self.pos.y + amount.y
    end
end

function Player:testColl(x,y)
    local bx,by = w:convertToWorld(self.pos.x,self.pos.y)
    local collX,collY = false, false
    for xx=-1,1 do
        for yy=-1,1 do
            if bx + xx > 0 and bx + xx < 31 and by + yy > 0 and by + yy < 31 and w.worldMap[bx+xx][by+yy].id == 1 then
                if self.pos.x >= ((bx+xx) - 1) * WIDTH/30 - self.d/2 and self.pos.x <= ((bx+xx) - 1) * WIDTH/30 + WIDTH/30 + self.d/2 and not (y<(by+yy-1) * WIDTH/30 - self.d/2 or y>(by+yy-1) * WIDTH/30 + WIDTH/30 + self.d/2) then
                   collY = true 
                end
                if self.pos.y >= ((by+yy) - 1) * WIDTH/30 - self.d/2 and self.pos.y <= ((by+yy) - 1) * WIDTH/30 + WIDTH/30 + self.d/2 and not (x<(bx+xx-1)*WIDTH/30 - self.d/2 or x>(bx+xx-1) * WIDTH/30 + WIDTH/30 + self.d/2) then
                    collX = true
                end
            end
        end
    end
    return collX,collY
end
