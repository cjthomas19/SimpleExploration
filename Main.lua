

-- Use this function to perform your initial setup
displayMode(FULLSCREEN_NO_BUTTONS)
function setup()
    --Define constants
    items = readImage("Project:items")
    cr = craftRecipes()
    ADJ = {
    vec2(0,1),
    vec2(-1,0),
    vec2(0,-1),
    vec2(1,0)
    }
    STATE_MAIN=1
    STATE_INV=2

    w = World(math.random(1000)/1000,0)
    parameter.watch("1/DeltaTime")
    c = CircleJoystick(100,100)
    b = CircleJoystick(WIDTH-100,100)
    touches = {}
    p = Player(w:convertFromWorld(2,2))
    g = gui()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    w:draw()
    if g.state == STATE_MAIN then
        c:draw()
        b:draw()
    end
    p:move(c.acc*4)
    if c.tId then
        p.rotation = c.rotation
    end
    if b.tId then
        p:breakBlock(b.rotation)
    end
    g:draw()
end

function touched(t)
    if g.state == STATE_MAIN then
        c:touched(t)
        b:touched(t)
    end
    g:touched(t)
end
