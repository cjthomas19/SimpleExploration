CircleJoystick = class()

function CircleJoystick:init(x,y)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.joy=vec2(x,y)
    self.tId=nil
end

function CircleJoystick:draw()
    -- Codea does not automatically call this method
    noStroke()
    fill(255, 255, 255, 255)
    ellipse(self.x,self.y,100,100)
    stroke(211, 211, 211, 255)
    strokeWidth(20)
    line(self.x, self.y, self.joy.x, self.joy.y)
    noStroke()
    fill(255, 0, 0, 255)
    ellipse(self.joy.x, self.joy.y, 50, 50)
    
    for i,v in pairs(touches) do
        if vec2(v.x,v.y):dist(vec2(self.x,self.y))<=50 and v.state~=ENDED then
            self.tId=i
        end
    end
    if self.tId~=nil then
        self.dif=vec2(touches[self.tId].x, touches[self.tId].y)-vec2(self.x,self.y)
        self.dif=self.dif:normalize()
        self.acc=self.dif
        if vec2(touches[self.tId].x, touches[self.tId].y):dist(vec2(self.x,self.y))>=50 then
        self.joy=self.dif*50+vec2(self.x,self.y)
        else self.joy.x, self.joy.y=touches[self.tId].x, touches[self.tId].y 
        end
        if touches[self.tId].state==ENDED then
            self.tId=nil
            self.joy=vec2(self.x,self.y)
            self.acc=vec2(0,0)
            self.rotation=0
        else
self.rotation=-math.deg(math.atan2(self.x-touches[self.tId].x,self.y-touches[self.tId].y))+180
        end
    end
    if not self.acc then
        self.acc=vec2(0,0)
    end
    if not self.rotation then
        self.rotation=0
    end
end
