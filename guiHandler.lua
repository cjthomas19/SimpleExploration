guiHandler = class()

function guiHandler:init()
    -- you can accept and set parameters
    self.buttons = {inv = SquareButton(WIDTH-100,HEIGHT-100,50,50,readImage("Project:inv"),function() g.state = STATE_INV end,2),back = SquareButton(WIDTH-100,100,50,50,readImage("Project:back"),function() g.state = STATE_MAIN end,2),split = SquareButton(WIDTH-200,100,50,50,readImage("Project:split"),function() self.split = true end,2),craft = SquareButton(WIDTH-300,100,50,50,readImage("Project:craft"),function() local a = cr:getResult(p:idTable())
        if a then
            p:decreaseCraftQuant(1)
            p:give(a.id,a.count,true)
        end
    end,2)}
    self.state = STATE_MAIN
    self.guiScreens = {inv = readImage("Project:inventoryBackdrop")}
    self.touchState = 0
end

function guiHandler:draw(i)
    -- Codea does not automatically call this method
    if self.state == STATE_MAIN then
        self.buttons.inv:draw()
    elseif self.state == STATE_INV then
        self:showInventory()
        self.buttons.back:draw()
        self.buttons.split:draw()
        self.buttons.craft:draw()
    end
end

function guiHandler:touched(touch)
    -- Codea does not automatically call this method
    local tx,ty = math.ceil(touch.x/(WIDTH/10)),math.ceil(touch.y/(HEIGHT/10))
    local ttx,tty = math.ceil((touch.x-5.5*WIDTH/10)/(WIDTH/10)),math.ceil((touch.y-7*HEIGHT/10)/(HEIGHT/10))
    if self.state == STATE_MAIN then
        self.buttons.inv:touched(touch)
    elseif self.state == STATE_INV then
        self.buttons.back:touched(touch)
        self.buttons.split:touched(touch)
        self.buttons.craft:touched(touch)
        if not self.buttons.inv.pressed and not self.buttons.back.pressed and not self.buttons.split.pressed then
            if touch.x<4 * WIDTH/10 and not self.heldItemIndex and not self.split then
                if p.inventory[(ty-1)*4 + tx] then
                    self.holdingItemTouch = touch.id
                    self.heldItemIndex = (ty-1)*4 + tx
                    self.touchState = 1
                end
            elseif self.split and touch.x<4 * WIDTH/10 and not self.heldItemIndex then
                self:splitItem((ty-1)*4 + tx)
                self.split = false
            elseif not self.split and not self.heldItemIndex and touch.x>5.5*WIDTH/10 and touch.x<8.5*WIDTH/10 and touch.y>7*HEIGHT/10 and touch.y<9*HEIGHT/10 then
                if p.craftSlots[(tty-1)*3 + ttx] then
                    self.holdingItemTouch = touch.id
                    self.heldItemIndex = (tty-1)*3 + ttx
                    self.touchState = 2
                end
            end
        end
    end
    if self.holdingItemTouch == touch.id then
        if touch.state ~= ENDED then
            if self.touchState == 1 then
                p.inventory[self.heldItemIndex].x,p.inventory[self.heldItemIndex].y = touch.x,touch.y
            elseif self.touchState == 2 then p.craftSlots[self.heldItemIndex].x,p.craftSlots[self.heldItemIndex].y = touch.x,touch.y
            end
        else
            if touch.x<4 * WIDTH/10 and not self.split then
                if self.touchState == 1 then
                    self:moveItem(self.heldItemIndex,(ty-1)*4 + tx,1)
                elseif self.touchState == 2 then
                    self:moveItem(self.heldItemIndex,(ty-1)*4 + tx,3)
                end
                self.holdingItemTouch = nil
                self.heldItemIndex = nil
            elseif touch.x>5.5*WIDTH/10 and touch.x<8.5*WIDTH/10 and touch.y>7*HEIGHT/10 and touch.y<9*HEIGHT/10 then
                if self.touchState == 1 then
                    self:moveItem(self.heldItemIndex,(tty-1)*3 + ttx,2)
                elseif self.touchState == 2 then
                    self:moveItem(self.heldItemIndex,(tty-1)*3+ttx,4)
                end
                self.holdingItemTouch = nil
                self.heldItemIndex = nil
            else
                if self.touchState == 1 then
                    p.inventory[self.heldItemIndex].x,p.inventory[self.heldItemIndex].y = ((self.heldItemIndex-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil(self.heldItemIndex/4)-1)*HEIGHT/10+HEIGHT/20
                elseif self.touchState == 2 then
                    p.craftSlots[self.heldItemIndex].x,p.craftSlots[self.heldItemIndex].y = ((self.heldItemIndex-1)%3)*WIDTH/10 + WIDTH/20 + 5.5*WIDTH/10, (math.ceil(self.heldItemIndex/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
                end
                self.holdingItemTouch = nil
                self.heldItemIndex = nil
            end
        end
    end
end

function guiHandler:splitItem(i)
    if p.inventory[i] and p.inventory[i].count>1 then
        p:give(p.inventory[i].id,math.ceil(p.inventory[i].count/2),false)
        p.inventory[i].count = math.floor(p.inventory[i].count/2)
    end
end


--[[function guiHandler:moveItem(i,ii,tab1,tab2)
    if not tab2 then tab2 = tab1 print(1)end
    if tab2[i] then
        if tab2[ii].id == tab1[i].id then
            tab2[ii].count = tab2[ii].count + tab1[i].count
            tab1[i] = nil
            tab2[ii].x,tab2[ii].y = ((ii-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((ii)/4)-1)*HEIGHT/10+HEIGHT/20
        else
            local a = tab1[i]
            local b = tab2[ii]
            tab1[i] = item(b.id,b.count,b.x,b.y)
            tab2[ii] = item(b.id,b.count,b.x,b.y)
        end
    else
        local a = tab1[i]
        tab2[ii] = item(a.id,a.count,a.x,a.y)
        tab1[i] = nil
    end
end]]--

function guiHandler:showInventory()
    sprite(self.guiScreens.inv,WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
    for i,v in pairs(p.inventory) do
        v:draw()
    end
    for i,v in pairs(p.craftSlots) do
        v:draw()
    end
end
function guiHandler:moveItem(i,ii,mode)
    if i ~= ii and mode == 1 then
        if not p.inventory[ii] then
            local a = p.inventory[i]
            p.inventory[ii] = item(a.id,a.count,a.x,a.y)
            p.inventory[ii].x,p.inventory[ii].y = ((ii-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((ii)/4)-1)*HEIGHT/10+HEIGHT/20
            p.inventory[i] = nil
        else
            if p.inventory[i].id ~= p.inventory[ii].id then
                local a = p.inventory[i]
                local b = p.inventory[ii]
                p.inventory[i] = item(b.id,b.count,b.x,b.y)
                p.inventory[ii] = item(a.id,a.count,a.x,a.y)
                p.inventory[ii].x,p.inventory[ii].y = ((ii-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((ii)/4)-1)*HEIGHT/10+HEIGHT/20
                p.inventory[i].x,p.inventory[i].y = ((i-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((i)/4)-1)*HEIGHT/10+HEIGHT/20
            else
                p.inventory[ii].count = p.inventory[ii].count + p.inventory[i].count
                p.inventory[ii].x,p.inventory[ii].y = ((ii-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((ii)/4)-1)*HEIGHT/10+HEIGHT/20
                p.inventory[i] = nil
            end
        end
    elseif mode == 1 then
        p.inventory[i].x,p.inventory[i].y = ((i-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((i)/4)-1)*HEIGHT/10+HEIGHT/20
    elseif mode == 2 then
        if p.craftSlots[ii] then
            if p.inventory[i].id ~= p.craftSlots[ii].id then
                local a = p.inventory[i]
                local b = p.craftSlots[ii]
                p.inventory[i] = item(b.id,b.count,b.x,b.y)
                p.craftSlots[ii] = item(a.id,a.count,a.x,a.y)
                p.inventory[i].x,p.inventory[i].y = ((i-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((i)/4)-1)*HEIGHT/10+HEIGHT/20
                p.craftSlots[ii].x,p.craftSlots[ii].y = ((ii-1)%3)*WIDTH/10 + WIDTH/20 + 5.5*WIDTH/10, (math.ceil(ii/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
            elseif p.inventory[i].id == p.craftSlots[ii].id then
                p.craftSlots[ii].count = p.craftSlots[ii].count + p.inventory[i].count
                p.inventory[i] = nil
                p.craftSlots[ii].x,p.craftSlots[ii].y = ((ii-1)%3)*WIDTH/10 + WIDTH/20 + 5.5*WIDTH/10, (math.ceil(ii/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
            end
        else
            local a = p.inventory[i]
            p.craftSlots[ii] = item(a.id,a.count,a.x,a.y)
            p.inventory[i] = nil
            p.craftSlots[ii].x,p.craftSlots[ii].y = ((ii-1)%3)*WIDTH/10 + WIDTH/20 + 5.5*WIDTH/10, (math.ceil(ii/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
        end
    elseif mode == 3 then
        if not p.inventory[ii] then
            local a = p.craftSlots[i]
            p.inventory[ii] = item(a.id,a.count,a.x,a.y)
            p.craftSlots[i] = nil
            p.inventory[ii].x,p.inventory[ii].y = ((ii-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((ii)/4)-1)*HEIGHT/10+HEIGHT/20
        elseif p.inventory[ii].id~=p.craftSlots[i].id then
            local a = p.craftSlots[i]
            local b = p.inventory[ii]
            p.inventory[ii] = item(a.id,a.count,a.x,a.y)
            p.craftSlots[i] = item(b.id,b.count,b.x,b.y)
            p.inventory[ii].x,p.inventory[ii].y = ((ii-1)%4)*WIDTH/10 + WIDTH/20,(math.ceil((ii)/4)-1)*HEIGHT/10+HEIGHT/20
            p.craftSlots[i].x,p.craftSlots[i].y = ((i-1)%3)*WIDTH/10 + WIDTH/20 + 5.5*WIDTH/10, (math.ceil(i/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
        else
            p.inventory[ii].count = p.inventory[ii].count + p.craftSlots[i].count
            p.craftSlots[i] = nil
        end
    elseif mode == 4 and i~=ii then
        if not p.craftSlots[ii] then
            local a = p.craftSlots[i]
            p.craftSlots[ii] = item(a.id,a.count,a.x,a.y)
            p.craftSlots[ii].x,p.craftSlots[ii].y = ((ii-1)%3)*WIDTH/10 + WIDTH/20+5.5*WIDTH/10,(math.ceil((ii)/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
            p.craftSlots[i] = nil
        elseif p.craftSlots[ii].id~=p.craftSlots[i].id then
            local a = p.craftSlots[i]
            local b = p.craftSlots[ii]
            p.craftSlots[i] = item(b.id,b.count,b.x,b.y)
            p.craftSlots[ii] = item(a.id,a.count,a.x,a.y)
            p.craftSlots[i].x,p.craftSlots[i].y = ((i-1)%3)*WIDTH/10 + WIDTH/20+5.5*WIDTH/10,(math.ceil((i)/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
            p.craftSlots[ii].x,p.craftSlots[ii].y = ((ii-1)%3)*WIDTH/10 + WIDTH/20+5.5*WIDTH/10,(math.ceil((ii)/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
        else
            p.craftSlots[ii].count = p.craftSlots[ii].count + p.craftSlots[i].count
            p.craftSlots[i] = nil
        end
    elseif mode==4 and i==ii then
        p.craftSlots[ii].x,p.craftSlots[ii].y = ((ii-1)%3)*WIDTH/10 + WIDTH/20+5.5*WIDTH/10,(math.ceil((ii)/3)-1)*HEIGHT/10+HEIGHT/20+7*HEIGHT/10
    end
end
