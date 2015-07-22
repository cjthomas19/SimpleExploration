

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    w = World(math.random(),0)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    w:draw()
end

