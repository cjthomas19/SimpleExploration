Player = class(entity)

function Player:init(x,y)
    -- you can accept and set parameters here
    entity.init(self,x,y,vec2(WIDTH/(w.mapSize + 10), WIDTH/(w.mapSize+10) * 11/26))
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
    self.inventory[1] = item(15,1,WIDTH/20,HEIGHT/20)
    self.inventory[2] = item(16,1,2*WIDTH/20,HEIGHT/20)
    self.animTimer = 1
    self.placed = false
end

function Player:draw()
    -- Codea does not automatically call this method
    fill(255,0,0)
    pushMatrix()
    translate(WIDTH/4,HEIGHT/4)
    rotate(self.rotation)
    self.mesh:draw()
    if self.swingPos then
        self.inventory[1]:drawAt(self.d.x/2,0,self.swingPos,true)
    end
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

--[[function Player:useItem(rot)
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
if (w.worldMap[bx][by].h<=10 and self.useTimer >= w.worldMap[bx][by].h) then
self:breakBlock(bx,by)
end
end
]]--
function Player:useItem(rot)
    self.useTimer = self.useTimer + 1
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
    local bx,by = w:convertToWorld(self.pos.x,self.pos.y)
    bx,by = bx + ADJ[num].x, by + ADJ[num].y
    if self.inventory[1] and self.inventory[1].itemType == "pickaxe" then
        if not self.swingPos then
            if w.worldMap[bx][by].id ~= 1 then
                self.swingPos = -10
            end
        else
            if w.worldMap[bx][by].id ~= 1 then
                self.swingPos = self.swingPos + 1 
                if self.swingPos >= 10 then
                    self.swingPos = nil
                end
            else
                self.swingPos = nil
            end
        end
        if self.useTimer >= w.worldMap[bx][by].h * self.inventory[1].mspeed and self.inventory[1].level >= w.worldMap[bx][by].h/50 then
            self:breakBlock(bx,by)
        end
    elseif self.inventory[1] and self.inventory[1].itemType == "weapon" then
        if not self.swingPos then
            self.swingPos = -40
        else
            self.swingPos = self.swingPos + 4
            if self.swingPos >= 40 then
                self.swingPos = -40

            end
        end
    elseif self.inventory[1] and self.inventory[1].itemType == "block" then
        if w.blockdata[w.itemData[self.inventory[1].id].blockId].giveOffLight == true then
            self:placeBlock(bx,by,w.itemData[self.inventory[1].id].blockId,5)
        else
            self:placeBlock(bx,by,w.itemData[self.inventory[1].id].blockId,0)
        end
        self.useTimer = 0
        self.placed = true
    elseif self.placed == false then
        if w.worldMap[bx][by].h<=10 and self.useTimer >= w.worldMap[bx][by].h then
            self:breakBlock(bx,by)
            print(false)
        end
        
    end
end

function Player:breakBlock(bx,by)
    if bx>0 and bx < w.mapSize + 1 and by > 0 and by < w.mapSize + 1 then
        w:breakBlock(bx,by)
        self.useTimer = 0
    end
end
function Player:placeBlock(bx,by,id,lightl)
    if w.worldMap[bx][by].id == 1 then
        self:give(self.inventory[1].id,-1,true)
        w:placeBlock(bx,by,id,lightl)
    end
end

function Player:give(i,count,stack)
    local stacked = false
    for a,v in pairs(self.inventory) do
        if i == v.id and stack then
            v.count = v.count + count
            if v.count < 1 then
                self.inventory[a] = nil
            end
            stacked = true
            return 0
        end
    end
    if not stacked then
        table.insert(self.inventory,item(i,count,((#self.inventory)%4)*WIDTH/10 + WIDTH/20,(math.ceil((#self.inventory+1)/4)-1)*HEIGHT/10+HEIGHT/20))
    end
end
