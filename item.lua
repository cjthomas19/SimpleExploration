item = class()

function item:init(id,count,x,y,sf)
    -- you can accept and set parameters here
    self.id = id
    self.sf = sf
    self.x = x
    self.y = y
    self.count = count
    self.mesh = mesh()
    self.mesh.texture = readImage("Project:items")
    self.index = self.mesh:addRect(0,0,WIDTH/10,HEIGHT/10)
    self.mesh:setRectTex(self.index,((self.id-1)%5)/5 + 0.01,(5 - math.ceil(self.id/5))/5 + 0.01,0.19,0.19) 
end

function item:draw()
    -- Codea does not automatically call this method
    pushMatrix()
    translate(self.x,self.y)
    scale(self.sf or 1)
    self.mesh:draw()
    fill(0)
    text(self.count, WIDTH/40,-HEIGHT/30)
    popMatrix()
end

function item:touched(touch)
    -- Codea does not automatically call this method
end
