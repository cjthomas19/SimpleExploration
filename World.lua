World = class()

function World:init(seed,th)
    -- you can accept and set parameters here
    self.seed = seed --should be a value between 0 and 1
    self.threshold = th --should be a value between -1 and 1, depending on the size of mountains desired
    self.blocks = readImage("Project:blocks")
    self.mesh = mesh()
    self.mesh.texture = self.blocks
    self.lightMesh = mesh()
    self.worldMap = {}
    for x=1,30 do
        self.worldMap[x] = {}
        for y=1,30 do
            local n = noise(x/10,y/10,seed*3)
            local i = self.mesh:addRect((x-1)*WIDTH/30+WIDTH/60, (y-1)*HEIGHT/30+HEIGHT/60, WIDTH/30,HEIGHT/30)
            local ii = self.lightMesh:addRect((x-1)*WIDTH/30+WIDTH/60, (y-1)*HEIGHT/30+HEIGHT/60, WIDTH/30,HEIGHT/30)
            if n>=self.threshold then
                self.worldMap[x][y] = block(1,0,i,ii)
                self.mesh:setRectTex(i,0.2,0.8,0.2,0.2)
                self.lightMesh:setRectColor(ii,0,0,0,255)
            else
                self.worldMap[x][y] = block(0,5,i,ii)
                self.mesh:setRectTex(i,0,0.8,0.2,0.2)
                self.lightMesh:setRectColor(ii,0,0,0,0)
            end
        end
    end
    for x = 1,30 do
        for y = 1,30 do
            self:updateLighting(x,y)
        end
    end
end

function World:draw()
    -- Codea does not automatically call this method
    noStroke()
    noSmooth()
    self.mesh:draw()
    if not y then
        self.lightMesh:draw()
    end
end

function World:testPoint(x,y)
    local val
    local bx,by = x/(WIDTH/30) + 1, y/(HEIGHT/30) + 1
    local bx,by = math.floor(bx),math.floor(by)
    val = self.worldMap[bx][by].id
    return val
end

function World:updateLighting(x,y)
    local maxl = self.worldMap[x][y].lightl
    for xx=-1,1 do
        for yy=-1,1 do
            if x+xx>0 and x+xx<31 and y+yy>0 and y+yy<31 then
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
function World:touched(touch)
    -- Codea does not automatically call this method
end
