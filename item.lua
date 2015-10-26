item = class()

function item:init(id,count,x,y,sf)
    -- you can accept and set parameters here
    self.id = id
    self.sf = sf or 1
    self.x = x
    self.y = y
    self.count = count
    self.mesh = mesh()
    self.mesh.texture = items
    self.index = self.mesh:addRect(0,0,WIDTH/10,HEIGHT/10)
    self.mesh:setRectTex(self.index,((self.id-1)%5)/5 + 0.01,(5 - math.ceil(self.id/5))/5 + 0.01,0.19,0.19) 
    self.itemType = w.itemData[id].itemType
    self.level = w.itemData[id].level
    self.mspeed = w.itemData[id].mspeed
end

function item:draw()
    -- Codea does not automatically call this method
    pushMatrix()
    translate(self.x,self.y)
    scale(self.sf)
    self.mesh:draw()
    fill(0)
    text(self.count, WIDTH/40,-HEIGHT/30)
    popMatrix()
end


function item:drawAt(x,y,rot,bool)
    pushMatrix()
    translate(x,y)
    rotate(rot)
    if bool then
        translate(0,HEIGHT/80)
    end
    scale(1/4)
    self.mesh:draw()
    popMatrix()
end
