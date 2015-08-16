World = class()

function World:init(seed,th)
    -- you can accept and set parameters here
    self.entities = {}
    self.blockdata = {
    {id = 1,breakTime = 0},
    {id = 2,breakTime = 0, item = 2},
    {id = 3,breakTime = 100, item = 3},
    {id = 4,breakTime = 100, item = 4},
    {id = 5,breakTime = 100, item = 5},
    {id = 6,breakTime = 100, item = 6},
    {id = 7,breakTime = 100, item = 7},
    {id = 8,breakTime = 100, item = 8}
    } --values for each block
    self.seed = seed --should be a value between 0 and 1
    self.threshold = th --should be a value between -1 and 1, depending on the size of mountains desired
    self.mapSize = 40 -- the size of the map
    self.light = true -- whether or not the lightmap should be drawn
    self:basicGen() -- begin generating the noisemap
    self:generateOres() -- place ores in the stone
    self:placePlayer(2,2) -- position the player's starting point
    for x = 1,self.mapSize do
        for y = 1,self.mapSize do
            self:updateLighting(x,y) --loop through each block and confirm the lighting is correct
        end
    end
end

function World:placePlayer(x,y)
    self.worldMap[x][y].id = 1 --set the player's starting poing to id 1 (air)
    self.worldMap[x][y].lightl = 5 --set the player's starting point to be in light level 5
    self:setMeshBlock(self.worldMap[x][y].meshIndex,1) -- change the texture
    self.lightMesh:setRectColor(self.worldMap[x][y].lmi,0,0,0,0) -- change the lighting mesh
end

function World:basicGen()
    self.blocks = readImage("Project:blocks") -- read the image for the texture
    self.mesh = mesh() -- initialize the mesh
    self.mesh.texture = self.blocks -- attach the texture to the mesh
    self.lightMesh = mesh() -- initialize the light mesh
    self.worldMap = {} -- initialize the world map
    for x=1,self.mapSize do
        self.worldMap[x] = {}
        for y=1,self.mapSize do
            local n = noise(x/10,y/10,self.seed*3) -- generate the noise value
            local i = self.mesh:addRect((x-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), (y-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), WIDTH/self.mapSize,WIDTH/self.mapSize)
            local ii = self.lightMesh:addRect((x-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), (y-1)*WIDTH/self.mapSize+WIDTH/(self.mapSize * 2), WIDTH/self.mapSize,WIDTH/self.mapSize)
            -- create the initial rectangles
            
            if n>=self.threshold then -- compare noise to threshold and set blocks accordingly
                self.worldMap[x][y] = block(2,0,i,ii,self.blockdata[2].breakTime)
                self:setMeshBlock(i,2)
                self.lightMesh:setRectColor(ii,0,0,0,255)
            else
                self.worldMap[x][y] = block(1,5,i,ii,self.blockdata[1].breakTime)
                self:setMeshBlock(i,1)
                self.lightMesh:setRectColor(ii,0,0,0,0)
            end
        end
    end
end

function World:setMeshBlock(index,id)
    self.mesh:setRectTex(index,((id-1)%5)/5 + 0.01,(5 - math.ceil(id/5))/5 + 0.01,0.19,0.19) -- correctly map the texture
end

function World:draw()
    -- Codea does not automatically call this method
    noStroke()
    noSmooth()
    self.mesh:draw()
    p:draw()
    if self.light and not p.invShow then
        self.lightMesh:draw() -- only draw if self.light is true
    end
    self:renderEntities()
end

function World:generateOres()
    for i=3,8 do -- loop through each data value for the ores
        for try=1,5 do -- 5 spawn tries per ore
            local curPos = vec2(math.random(self.mapSize),math.random(self.mapSize))
            local toChange = {}
            for iteration = 1,10 do -- 10 ores per spawn try using drunkard's walk
                if curPos.x > 0 and curPos.x < self.mapSize + 1 and curPos.y > 0 and curPos.y < self.mapSize + 1 and self.worldMap[curPos.x][curPos.y].id == 2 then
                    self:setMeshBlock(self.worldMap[curPos.x][curPos.y].meshIndex,i) -- change block
                    self.worldMap[curPos.x][curPos.y].id = i 
                    self.worldMap[curPos.x][curPos.y].h = self.blockdata[i].breakTime
                end
                curPos = curPos + adj[math.random(1,4)] -- update position
            end
        end
        
    end
end

function World:testPoint(x,y)
    local val
    val = self.worldMap[x][y].id -- return value at the certain point
    return val
end

function World:updateLighting(x,y)
    local maxl = self.worldMap[x][y].lightl -- set preliminary max light
    for xx=-1,1 do
        for yy=-1,1 do
            if x+xx>0 and x+xx< self.mapSize + 1 and y+yy>0 and y+yy<self.mapSize + 1 then
                if self.worldMap[xx+x][yy+y].id == 1 then --make it so that only air can transfer light
                    if not (xx==0 and yy==0) then -- cant transfer light to itself
                        if self.worldMap[xx+x][yy+y].lightl > maxl + 1 then -- compare to maxl
                            maxl = self.worldMap[xx+x][yy+y].lightl - 1 -- set maxl
                        end
                    end
                end
            end
        end
    end
    if maxl > self.worldMap[x][y].lightl then -- redundant, to be removed
        self.worldMap[x][y].lightl = maxl  -- set light level
    end
    self.lightMesh:setRectColor(self.worldMap[x][y].lmi,0,0,0,((5-self.worldMap[x][y].lightl)/5)*255) -- change mesh
end
function World:convertToWorld(x,y)
    local bx,by = x/(WIDTH/self.mapSize) + 1, y/(WIDTH/self.mapSize) + 1
    bx,by = math.floor(bx),math.floor(by) -- reverse conversions
    return bx,by
end

function World:convertFromWorld(x,y)
    local rx,ry = (x-1) * WIDTH/self.mapSize + WIDTH/(self.mapSize * 2), (y-1) * WIDTH/self.mapSize + WIDTH/(self.mapSize * 2) -- conversions
    return rx,ry
end
function World:renderEntities()
    -- Codea does not automatically call this method
    for i,v in pairs(self.entities) do
        v:draw()
    end
end

function World:breakBlock(x,y)
    if self.worldMap[x][y].id ~= 1 then -- if not air then
        local id = self.worldMap[x][y].id
        sound(SOUND_HIT, 33341)
        self.worldMap[x][y].id = 1 -- set to air
        for i=-5,5 do
            for ii=-5,5 do
                if x+i>0 and x+i<self.mapSize + 1 and y+ii>0 and y+ii<self.mapSize + 1 then
                    self:updateLighting(x+i,y+ii) -- update the lighting around the block
                end
            end
        end
        self:setMeshBlock(self.worldMap[x][y].meshIndex,1) -- update the block
        --p:give(self.blockdata[id].item,1)
        local xx,yy = self:convertFromWorld(x,y)
        self:summonItem(xx,yy,self.blockdata[id].item,1)
    end
end
function World:killEntity(i)
    self.entities[i] = nil
end
function World:summonItem(x,y,dataVal,count)
    self.entities[#self.entities+1] = entityItem(x,y,#self.entities+1,item(dataVal,count))
end
