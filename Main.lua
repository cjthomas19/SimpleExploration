

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    w = World(math.random(),0)
    parameter.watch("1/DeltaTime")
    c = CircleJoystick(100,100)
    touches = {}
    p = Player(w:convertFromWorld(2,2))
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    w:draw()
    p:draw()
    c:draw()
    p:move(c.acc * 4)
end

function touched(t)
    touches[t.id] = t
end
