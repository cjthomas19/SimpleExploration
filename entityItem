entityItem = class(entity)

function entityItem:init(x,y,i,id,count)
    -- you can accept and set parameters here
    self.item = item(id,count,x,y,1/4)
    self.i = i
    entity.init(self,x,y,i,vec2(WIDTH/10 * self.item.sf,HEIGHT/10 * self.item.sf))
end

function entityItem:draw()
    -- Codea does not automatically call this method
    self.item:draw()
    if self:testCollWithPlayer(p) then
        p:give(self.item.id,self.item.count,true)
        w:killEntity(self.i)
    end
end
