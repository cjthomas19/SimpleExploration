CircleJoystick = class()

function CircleJoystick:init(x,y)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.joy=vec2(x,y)
    self.tId=nil
    self.rotation = 0
    self.acc=vec2(0,0)
    self.rotation=0
end

function CircleJoystick:draw()
    -- Codea does not automatically call this method
    noStroke()
    smooth()
    fill(255, 255, 255, 127)
    ellipse(self.x,self.y,100,100)
    stroke(211, 211, 211, 127)
    strokeWidth(20)
    line(self.x, self.y, self.joy.x, self.joy.y)
    noStroke()
    fill(255, 0, 0, 127)
    ellipse(self.joy.x, self.joy.y, 50, 50)
    
end

function CircleJoystick:touched(t)
    if vec2(t.x,t.y):dist(vec2(self.x,self.y))<=50 and t.state~=ENDED then
        self.tId=t.id
    end
    if self.tId~=nil and self.tId == t.id and t.x ~= self.x and t.y ~= self.y then
        self.dif=vec2(t.x, t.y)-vec2(self.x,self.y)
        self.dif=self.dif:normalize()
        self.acc=self.dif
        if vec2(t.x, t.y):dist(vec2(self.x,self.y))>=50 then
            self.joy=self.dif*50+vec2(self.x,self.y)
        else self.joy.x, self.joy.y=t.x, t.y
        end
        if t.state==ENDED then
            self.tId=nil
            self.joy=vec2(self.x,self.y)
            self.acc=vec2(0,0)
            self.rotation=0
        else
            self.rotation=-math.deg(math.atan2(self.x-t.x,self.y-t.y))+180
        end
    end
    if not self.acc then
        self.acc=vec2(0,0)
    end
    if not self.rotation then
        self.rotation=0
    end
end
