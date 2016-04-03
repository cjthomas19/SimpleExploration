SquareButton = class()

function SquareButton:init(x,y,w,h,tex,func,funcCalledMode)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.pressed = false
    self.tex=tex
    self.tId = nil
    self.func = func or function() end
    self.fcm = funcCalledMode or 1
end

function SquareButton:draw()
    -- Codea does not automatically call this method
    sprite(self.tex,self.x,self.y,self.w,self.h)
    if self.pressed then noStroke() fill(0,0,0,50) rect(self.x-self.w/2,self.y-self.h/2,self.w,self.h) end
end

function SquareButton:touched(t)
    if t.id ~= c.tId and t.x>self.x-self.w/2 and t.x<self.x+self.w/2 and t.y>self.y-self.h/2 and t.y<self.y+self.h/2 and t.state~=ENDED and t.state~=CANCELLED then
            self.pressed = true
            self.tId = t.id
            self.col = self.darkCol
            if self.fcm == 1 then
                self.func()
            end
        end
    if self.tId == t.id and t.state==ENDED and t.x>self.x-self.w/2 and t.x<self.x+self.w/2 and t.y>self.y-self.h/2 and t.y<self.y+self.h/2 then
        self.pressed = false
        self.tId = nil
        if self.fcm == 2 then
            self.func()
        end
    elseif self.tId == t.id and t.state == ENDED then
        self.pressed = false
        self.tId = nil
    end
end
