Beetle = class(entity)

function Beetle:init(x,y,t)
    -- you can accept and set parameters here
    entity.init(self,x,y,vec2(14,14))
    self.d = vec2(14,14)
    self.mesh = mesh()
    self.mesh.texture = readImage("Project:"..t.."_beetle")
    i = self.mesh:addRect(0,0,self.d.x,self.d.y)
    self.mesh:setRectTex(i,0,0,0.2,1)
    self.anim = {1,2,3,2,1,4,5,4}
    self.dir = vec2(0,0.5)
    self.animTimer = 1
    self.index = 1
    self.rot = 0
    self.type = t
end

function Beetle:draw()
    -- Codea does not automatically call this method
    --self.pos.x = self.pos.x + self.dir.x
    --self.pos.y = self.pos.y + self.dir.y
    
    pushMatrix()
    translate(self.pos.x,self.pos.y)
     rotate(self.rot)
    self.mesh:draw()
    popMatrix()
    if self.type == "green" then
        if self:move(self.dir) then
            self.dir = vec2(self.dir.y,-self.dir.x)
            self.rot = self.rot - 90
        end
        self:incMesh()
    elseif self.type == "red" then
        if p.pos:dist(self.pos) < 100 and p.pos ~= self.pos then
            self.dir = (p.pos-self.pos):normalize()
            self:move(self.dir)
            local dif = p.pos-self.pos
            self.rot = -math.deg(math.atan2(dif.x,dif.y))
            print(self.rot)
            self:incMesh()
        end
    elseif self.type == "yellow" then
        if p.pos:dist(self.pos) < 100 and p.pos ~= self.pos then
            self.dir = -(p.pos-self.pos):normalize()
            self:move(self.dir)
            local dif = self.pos-p.pos
            self.rot = -math.deg(math.atan2(dif.x,dif.y))
            self:incMesh()
        end
    elseif self.type == "blue" then
        self.dir = vec2(math.random(-1,1),math.random(-1,1))
        self.rot = -math.deg(math.atan2(self.dir.x,self.dir.y))
        self:move(self.dir)
    end
end

function Beetle:incMesh()
    self.animTimer = self.animTimer + 1
    if self.animTimer > 3 then
        self.animTimer = 0
        self.index = self.index + 1
        if self.index > 8 then
            self.index = 1
        end
        self.mesh:setRectTex(1,(self.anim[self.index]-1)/5,0,0.2,1)
    end
    
end