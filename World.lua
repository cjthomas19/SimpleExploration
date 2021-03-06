World = class()

function World:init(seed,th)
    -- you can accept and set parameters here
    self.entities = {}
    self.blockdata = {
    {id = 1,breakTime = 0,lightSource = true},
    {id = 2,breakTime = 25, item = 2},
    {id = 3,breakTime = 100, item = 3},
    {id = 4,breakTime = 100, item = 4},
    {id = 5,breakTime = 100, item = 5},
    {id = 6,breakTime = 100, item = 6},
    {id = 7,breakTime = 100, item = 7},
    {id = 8,breakTime = 100, item = 8},
    {id = 9,breakTime = 10,item = 12},
    {id = 10, breakTime = 100, item = 15,lightSource = true,giveOffLight = true},
    {id = 11, breakTime = 200, item = 24},
    {},
    {id = 13, breakTime = 1000, item = 1,lightSource = false, giveOffLight = false}
    } --values for each block
    self.itemData = {
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {itemType = "material"},
    {},
    {itemType = "block",blockId = 10},
    {itemType = "pickaxe",level = 1,mspeed = 1,swingLength = 90},
    {itemType = "pickaxe",level = 2,mspeed = 0.75},
    {itemType = "pickaxe",level = 3,mspeed = 0.5},
    {itemType = "pickaxe",level = 4,mspeed = 0.25},
    {},
    {itemType = "weapon"},
    {itemType = "weapon"},
    {itemType = "block",blockId = 11},
    {itemType = "block",blockId = 11},
    }
    self.seed = seed --should be a value between 0 and 1
    self.threshold = th --should be a value between -1 and 1, depending on the size of mountains desired
    self.mapSize = 40 -- the size of the map
    self.light = true -- whether or not the lightmap should be drawn
    self:basicGen() -- begin generating the noisemap
    self:generateOres() -- place ores in the stone
    self:placeBorders()
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
    self.worldMap[x][y].outside = true
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
                self.worldMap[x][y] = block(2,0,i,ii,self.blockdata[2].breakTime,false)
                self:setMeshBlock(i,2)
                self.lightMesh:setRectColor(ii,0,0,0,255)
            else
                self.worldMap[x][y] = block(1,5,i,ii,self.blockdata[1].breakTime,true)
                self:setMeshBlock(i,1)
                self.lightMesh:setRectColor(ii,0,0,0,0)
            end
        end
    end
    for x,v in pairs(self.worldMap) do
        for y,b in pairs(v) do
            if b.id == 1 then
                if math.random(20) == 20 then
                    self.worldMap[x][y] = block(9,5,b.meshIndex,b.lmi,self.blockdata[9].breakTime,true)
                    self:setMeshBlock(b.meshIndex,9)
                end
            end
        end
    end
end

function World:placeBorders()
    for i = 1,self.mapSize do
        local o1 = self.worldMap[i][1]
        local o2 = self.worldMap[i][self.mapSize]
        local o3 = self.worldMap[1][i]
        local o4 = self.worldMap[self.mapSize][i]
        self.worldMap[i][1] = block(13,5,o1.meshIndex,o1.lmi,self.blockdata[13].breakTime,true)
        self:setMeshBlock(o1.meshIndex,13)
        self.worldMap[i][self.mapSize] = block(13,5,o2.meshIndex,o2.lmi,self.blockdata[13].breakTime,true)
        self:setMeshBlock(o2.meshIndex,13)
        
        self.worldMap[1][i] = block(13,5,o3.meshIndex,o3.lmi,self.blockdata[13].breakTime,true)
        self:setMeshBlock(o3.meshIndex,13)
        self.worldMap[self.mapSize][i] = block(13,5,o3.meshIndex,o3.lmi,self.blockdata[13].breakTime,true)
        self:setMeshBlock(o4.meshIndex,13)
    end
end

function World:setMeshBlock(index,id)
    self.mesh:setRectTex(index,((id-1)%5)/5+0.01,(5 - math.ceil(id/5))/5 + 0.01,0.19,0.19) -- correctly map the texture
end

function World:draw()
    -- Codea does not automatically call this method
    pushMatrix()
    noStroke()
    noSmooth()
    scale(2)
    pushMatrix()
    translate(-p.pos.x+(WIDTH/4),-p.pos.y+(HEIGHT/4))
    self.mesh:draw()
    popMatrix()
    p:draw()
    pushMatrix()
    translate(-p.pos.x+WIDTH/4,-p.pos.y+HEIGHT/4)
    self:renderEntities()
    if self.light and g.state == STATE_MAIN then
        self.lightMesh:draw() -- only draw if self.light is true
    end
    popMatrix()
    popMatrix()
    p:drawHeldItem()
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
                curPos = curPos + ADJ[math.random(1,4)] -- update position
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
                if self.blockdata[self.worldMap[xx+x][yy+y].id].lightSource == true then --make it so that only air can transfer light
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
        for xx=-5,5 do
            for yy=-5,5 do
                if x+xx>0 and x+xx<self.mapSize + 1 and y+yy>0 and y+yy<self.mapSize + 1 then
                    if self.worldMap[x+xx][y+yy].outside == true or self.blockdata[self.worldMap[x+xx][y+yy].id].giveOffLight == true then
                        self.worldMap[x+xx][y+yy].lightl = 5
                    else
                        self.worldMap[x+xx][y+yy].lightl = 0
                    end
                end
            end
        end
        
        for i=-5,5 do
            for ii=-5,5 do
                if x+i>0 and x+i<self.mapSize + 1 and y+ii>0 and y+ii<self.mapSize + 1 then
                    self:updateLighting(x+i,y+ii) -- update the lighting around the block
                end
            end
        end
        for i=5,-5,-1 do
            for ii=5,-5,-1 do
                if x+i>0 and x+i<self.mapSize + 1 and y+ii>0 and y+ii<self.mapSize + 1 then
                    self:updateLighting(x+i,y+ii) -- update the lighting around the block
                end
            end
        end
        self:setMeshBlock(self.worldMap[x][y].meshIndex,1) -- update the block
        local xx,yy = self:convertFromWorld(x,y)
        self:summonItem(xx,yy,self.blockdata[id].item,1)
    end
end

function World:placeBlock(x,y,id,lightl)
    if self.worldMap[x][y].id == 1 then
        self.worldMap[x][y].id = id
        self.worldMap[x][y].lightl = lightl or self.worldMap[x][y].lightl
        self.worldMap[x][y].h = self.blockdata[id].breakTime
        for xx=-5,5 do
            for yy=-5,5 do
                if x+xx>0 and x+xx<self.mapSize + 1 and y+yy>0 and y+yy<self.mapSize + 1 then
                    if self.worldMap[x+xx][y+yy].outside == true or self.blockdata[self.worldMap[x+xx][y+yy].id].giveOffLight == true then
                        self.worldMap[x+xx][y+yy].lightl = 5
                    else
                        self.worldMap[x+xx][y+yy].lightl = 0
                    end
                end
            end
        end
        for i=-5,5 do
            for ii=-5,5 do
                if x+i>0 and x+i<self.mapSize + 1 and y+ii>0 and y+ii<self.mapSize + 1 then
                    self:updateLighting(x+i,y+ii) -- update the lighting around the block
                end
            end
        end
        for i=5,-5,-1 do
            for ii=5,-5,-1 do
                if x+i>0 and x+i<self.mapSize + 1 and y+ii>0 and y+ii<self.mapSize + 1 then
                    self:updateLighting(x+i,y+ii) -- update the lighting around the block
                end
            end
        end
        self:setMeshBlock(self.worldMap[x][y].meshIndex,self.worldMap[x][y].id)
        
    end
end

function World:killEntity(i)
    self.entities[i] = nil
end
function World:summonItem(x,y,dataVal,count)
    table.insert(self.entities,entityItem(x,y,#self.entities+1,dataVal,count,1))
end
