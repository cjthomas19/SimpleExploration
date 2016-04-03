

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
    d1 = SquareButton(WIDTH-175,125,50,50,"Project:Left",function()  end,1)
    d2 = SquareButton(WIDTH-75,125,50,50,"Project:Right",function()  end,1)
    d3 = SquareButton(WIDTH-125,175,50,50,"Project:Up",function()  end,1)
    d4 = SquareButton(WIDTH-125,75,50,50,"Project:Down",function()  end,1)
    touches = {}
    p = Player(w:convertFromWorld(2,2))
    g = guiHandler()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(0, 0, 0, 255)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    w:draw()
    if g.state == STATE_MAIN then
        c:draw()
        d1:draw()
        d2:draw()
        d3:draw()
        d4:draw()
        if d1.pressed then
            p:useItem(90)
        elseif d2.pressed then
            p:useItem(270)
        elseif d3.pressed then
            p:useItem(0)
        elseif d4.pressed then
            p:useItem(180)
        else
            p.placed = false
            p.swingPos = nil
        end
    end
    p:move(c.acc*2.5)
    if c.tId then
        p.rotation = c.rotation
        p:incMesh()
    end
    g:draw()
end

function touched(t)
    if g.state == STATE_MAIN then
        c:touched(t)
        d1:touched(t)
        d2:touched(t)
        d3:touched(t)
        d4:touched(t)
    end
    g:touched(t)
end
