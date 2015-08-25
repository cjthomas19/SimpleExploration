Player = class(entity)

function Player:init(x,y)
    -- you can accept and set parameters here
    entity.init(self,x,y,1,vec2(WIDTH/(w.mapSize + 10), WIDTH/(w.mapSize+10) * 11/26))
    self.anim = {2,5,2,3,4,3}
    self.index = 1
    self.mesh = mesh()
    self.mesh.texture = readImage("Project:player")
    local i = self.mesh:addRect(0,0,self.d.x,self.d.y)
    self.mesh:setRectTex(1,(self.anim[self.index]-1)/5,0,0.2,1)
    self.rotation = 0
    self.useTimer = 0
    self.inventory = {}
    self.craftSlots = {}
    self.output = nil
    self.invShow = false
    self.percent = 0
    self.inventory[1] = item(16,1,WIDTH/20,HEIGHT/20)
    self.animTimer = 1
end

function Player:draw()
    -- Codea does not automatically call this method
    fill(255,0,0)
    pushMatrix()
    translate(WIDTH/4,HEIGHT/4)
    rotate(self.rotation)
    self.mesh:draw()
    popMatrix()
end

function Player:incMesh()
    self.animTimer = self.animTimer + 1
    if self.animTimer > 3 then
        self.animTimer = 0
        self.index = self.index + 1
        if self.index > 6 then
            self.index = 1
        end
        self.mesh:setRectTex(1,(self.anim[self.index]-1)/5,0,0.2,1)
    end
    
end

function Player:drawHeldItem()
    if p.inventory[1] then
        p.inventory[1]:draw()
    end
end

function Player:destroy()
    
end

function Player:idTable()
    local tbl = {}
    for i,v in pairs(self.craftSlots) do
        tbl[i] = v.id
    end
    return tbl
end

function Player:decreaseCraftQuant(q)
    for i,v in pairs(p.craftSlots) do
        v.count = v.count - q
        if v.count <= 0 then
            p.craftSlots[i] = nil
        end
    end
end

function Player:useItem(rot)
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
    self.useTimer = self.useTimer + 1
    local bx,by = w:convertToWorld(self.pos.x,self.pos.y)
    bx,by = bx + ADJ[num].x, by + ADJ[num].y
    if bx>0 and bx < w.mapSize + 1 and by > 0 and by < w.mapSize + 1 then
        if self.inventory[1] and w.worldMap[bx][by].h>10 and self.inventory[1].itemType == "pickaxe" and self.useTimer >= w.worldMap[bx][by].h * self.inventory[1].mspeed and self.inventory[1].level >= w.worldMap[bx][by].h/50 then
            w:breakBlock(bx,by)
            self.useTimer = 0
        elseif w.worldMap[bx][by].h<=10 and self.useTimer >= w.worldMap[bx][by].h then
            w:breakBlock(bx,by)
            self.useTimer = 0
        end
    end
end

function Player:give(i,count,stack)
    local stacked = false
    
    for a,v in pairs(self.inventory) do
        if i == v.id and stack then
            v.count = v.count + count
            stacked = true
            return 0
        end
    end
    if not stacked then
        table.insert(self.inventory,item(i,count,((#self.inventory)%4)*WIDTH/10 + WIDTH/20,(math.ceil((#self.inventory+1)/4)-1)*HEIGHT/10+HEIGHT/20))
    end
end
