World = class()

function World:init(seed,th)
    -- you can accept and set parameters here
    self.blockdata = {
    {id = 0,texX = 0,texY = 0.81},
    {id = 1,texX = 0.21,texY = 0.81}
    }
    self.seed = seed --should be a value between 0 and 1
    self.threshold = th --should be a value between -1 and 1, depending on the size of mountains desired
    self.mapSize = 40
    self.light = true
    self.blocks = readImage("Project:blocks")
    self.mesh = mesh()
    self.mesh.texture = self.blocks
    self.lightMesh = mesh()
    self.worldMap = {}
    for x=1,self.mapSize do
        self.worldMap[x] = {}
        for y=1,self.mapSize do
            local n = noise(x/10,y/10,seed*3)
            local i = self.mesh:addRect((x-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), (y-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), WIDTH/self.mapSize,WIDTH/self.mapSize)
            local ii = self.lightMesh:addRect((x-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), (y-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), WIDTH/self.mapSize,WIDTH/self.mapSize)
            if n>=self.threshold then
                self.worldMap[x][y] = block(1,0,i,ii)
                self.mesh:setRectTex(i,self.blockdata[2].texX,self.blockdata[2].texY,0.19,0.19)
                self.lightMesh:setRectColor(ii,0,0,0,255)
            else
                self.worldMap[x][y] = block(0,5,i,ii)
                self.mesh:setRectTex(i,self.blockdata[1].texX,self.blockdata[1].texY,0.19,0.19)
                self.lightMesh:setRectColor(ii,0,0,0,0)
            end
        end
    end
    self.worldMap[2][2].id = 0
    self.worldMap[2][2].lightl = 5
    self.mesh:setRectTex(self.worldMap[2][2].meshIndex,0,0.8,0.2,0.2)
    self.lightMesh:setRectColor(self.worldMap[2][2].lmi,0,0,0,0)
    for x = 1,self.mapSize do
        for y = 1,self.mapSize do
            self:updateLighting(x,y)
        end
    end
end

function World:draw()
    -- Codea does not automatically call this method
    noStroke()
    noSmooth()
    self.mesh:draw()
    p:draw()
    if self.light then
        self.lightMesh:draw()
    end
    
end

function World:testPoint(x,y)
    local val
    val = self.worldMap[x][y].id
    return val
end

function World:updateLighting(x,y)
    local maxl = self.worldMap[x][y].lightl
    for xx=-1,1 do
        for yy=-1,1 do
            if x+xx>0 and x+xx< self.mapSize + 1 and y+yy>0 and y+yy<self.mapSize + 1 then
                if self.worldMap[xx+x][yy+y].id == 0 then
                    if not (xx==0 and yy==0) then
                        if self.worldMap[xx+x][yy+y].lightl > maxl then
                            maxl = self.worldMap[xx+x][yy+y].lightl - 1
                        end
                    end
                end
            end
        end
    end
    if maxl > self.worldMap[x][y].lightl then
        self.worldMap[x][y].lightl = maxl
    end
    self.lightMesh:setRectColor(self.worldMap[x][y].lmi,0,0,0,((5-self.worldMap[x][y].lightl)/5)*255)
end
function World:convertToWorld(x,y)
    local bx,by = x/(WIDTH/self.mapSize) + 1, y/(WIDTH/self.mapSize) + 1
    bx,by = math.floor(bx),math.floor(by)
    return bx,by
end

function World:convertFromWorld(x,y)
    local rx,ry = (x-1) * WIDTH/self.mapSize + WIDTH/(self.mapSize * 2), (y-1) * WIDTH/self.mapSize + WIDTH/(self.mapSize * 2)
    return rx,ry
end
function World:touched(touch)
    -- Codea does not automatically call this method
end

function World:breakBlock(x,y)
    if self.worldMap[x][y].id ~= 0 then
        self.worldMap[x][y].id = 0
        for i=-5,5 do
            for ii=-5,5 do
                if x+i>0 and x+i<self.mapSize and y+ii>0 and y+ii<self.mapSize then
                    self:updateLighting(x+i,y+ii)
                end
            end
        end
        self.mesh:setRectTex(self.worldMap[x][y].meshIndex,self.blockdata[1].texX,self.blockdata[1].texY,0.19,0.19)
    end
end
