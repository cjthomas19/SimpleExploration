World = class()

function World:init(seed,th)
    -- you can accept and set parameters here
    self.seed = seed --should be a value between 0 and 1
    self.threshold = th --should be a value between -1 and 1, depending on the size of mountains desired
    self.worldMap = {}
    for x=1,30 do
        self.worldMap[x] = {}
        for y=1,30 do
            local n = noise(x/10,y/10,seed*3)
            if n>=self.threshold then
                self.worldMap[x][y] = 1
            else 
                self.worldMap[x][y] = 0
            end
            
        end
    end
end

function World:draw()
    -- Codea does not automatically call this method
    noStroke()
    noSmooth()
    for x,p in pairs(self.worldMap) do
        for y,val in pairs(p) do
            if val == 1 then
                fill(156, 156, 156, 255)
            elseif val == 0 then
                fill(83, 50, 31, 255)
            end
            rect((x-1)*WIDTH/30,(y-1)*HEIGHT/30,WIDTH/30,HEIGHT/30)
        end
    end
end

function World:touched(touch)
    -- Codea does not automatically call this method
end
