Player = class()

function Player:init(x,y)
    -- you can accept and set parameters here
    self.pos = vec2(x,y)
    self.img = readImage("Project:player")
    self.d = vec2(WIDTH/(w.mapSize + 10), WIDTH/(w.mapSize+10) * 11/26)
    self.rotation = 0
    self.breakTimer = 0
    self.inventory = {}
    self.invShow = false
end

function Player:draw()
    -- Codea does not automatically call this method
    fill(255,0,0)
    pushMatrix()
    translate(self.pos.x,self.pos.y)
    rotate(self.rotation)
    sprite(self.img, 0,0,self.d.x,self.d.y)
    popMatrix()
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
            if bx + xx > 0 and bx + xx < w.mapSize + 1 and by + yy > 0 and by + yy < w.mapSize + 1 and w.worldMap[bx+xx][by+yy].id ~= 1 then
                if self.pos.x >= ((bx+xx) - 1) * WIDTH/w.mapSize - self.d.x/2 and self.pos.x <= ((bx+xx) - 1) * WIDTH/w.mapSize + WIDTH/w.mapSize + self.d.x/2 and not (y<(by+yy-1) * WIDTH/w.mapSize - self.d.x/2 or y>(by+yy-1) * WIDTH/w.mapSize + WIDTH/w.mapSize + self.d.x/2) then
                    collY = true
                end
                if self.pos.y >= ((by+yy) - 1) * WIDTH/w.mapSize - self.d.x/2 and self.pos.y <= ((by+yy) - 1) * WIDTH/w.mapSize + WIDTH/w.mapSize + self.d.x/2 and not (x<(bx+xx-1)*WIDTH/w.mapSize - self.d.x/2 or x>(bx+xx-1) * WIDTH/w.mapSize + WIDTH/w.mapSize + self.d.x/2) then
                    collX = true
                end
            end
        end
    end
    return collX,collY
end

function Player:breakBlock(rot)
    local num
    if rot<=45 or rot>315 then
        num = 1
    elseif rot>45 and rot<=135 then
        num = 2
    elseif rot>135 and rot<=225 then
        num = 3
    else
        num=4
    end
    self.breakTimer = self.breakTimer + 1
    local bx,by = w:convertToWorld(self.pos.x,self.pos.y)
    bx,by = bx + adj[num].x, by + adj[num].y
    if bx>0 and bx < w.mapSize + 1 and by > 0 and by < w.mapSize + 1 then
        if self.breakTimer > w.worldMap[bx][by].h then
            w:breakBlock(bx,by)
            self.breakTimer = 0
        end
    end
end

function Player:give(i,count)
    local stacked = false
    for a,v in pairs(self.inventory) do
        if i == v.id then
            v.count = v.count + count
            stacked = true
        end
    end
    if not stacked then
        table.insert(self.inventory,item(i,count))
    end
end
