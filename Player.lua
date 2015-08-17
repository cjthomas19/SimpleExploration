Player = class(entity)

function Player:init(x,y)
    -- you can accept and set parameters here
    entity.init(self,x,y,1,vec2(WIDTH/(w.mapSize + 10), WIDTH/(w.mapSize+10) * 11/26))
    self.pos = vec2(x,y)
    self.img = readImage("Project:player")
    self.rotation = 0
    self.breakTimer = 0
    self.inventory = {}
    self.craftSlots = {{}}
    self.output = nil
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

function Player:destroy()
    
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
    bx,by = bx + ADJ[num].x, by + ADJ[num].y
    if bx>0 and bx < w.mapSize + 1 and by > 0 and by < w.mapSize + 1 then
        if self.breakTimer > w.worldMap[bx][by].h then
            w:breakBlock(bx,by)
            self.breakTimer = 0
        end
    end
end

function Player:give(i,count,stack)
    local stacked = false
    for a,v in pairs(self.inventory) do
        if i == v.id and stack then
            v.count = v.count + count
            stacked = true
        end
    end
    if not stacked then
        table.insert(self.inventory,item(i,count,((#self.inventory)%4)*WIDTH/10 + WIDTH/20,(math.ceil((#self.inventory+1)/4)-1)*HEIGHT/10+HEIGHT/20))
    end
end
