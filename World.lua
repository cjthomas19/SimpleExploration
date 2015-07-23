World = class()

function World:init(seed,th)
    -- you can accept and set parameters here
    self.seed = seed --should be a value between 0 and 1
    self.threshold = th --should be a value between -1 and 1, depending on the size of mountains desired
    self.mesh = mesh()
    self.worldMap = {}
    for x=1,30 do
        self.worldMap[x] = {}
        for y=1,30 do
            local n = noise(x/10,y/10,seed*3)
            local i = self.mesh:addRect((x-1)*WIDTH/30+WIDTH/60,(y-1)*HEIGHT/30+HEIGHT/60, WIDTH/30,HEIGHT/30)
            if n>=self.threshold then
                self.worldMap[x][y] = block(0,i)
                self.mesh:setRectColor(i,156,156,156)
            else 
                self.worldMap[x][y] = block(0,i)
                self.mesh:setRectColor(i,83,50,31)
            end
            
        end
    end
end

function World:draw()
    -- Codea does not automatically call this method
    noStroke()
    noSmooth()
    self.mesh:draw()
end

function World:touched(touch)
    -- Codea does not automatically call this method
end
