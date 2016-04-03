craftRecipes = class()

function craftRecipes:init()
    -- you can accept and set parameters here
    recipes = {
    {
    recipe = {3,3,3,nil,nil,nil},
    result = {id = 10,count = 1}
    },
    {
    recipe = {2,2,2,nil,nil,nil},
    result = {id = 9,count = 1}
    },
    {
    recipe = {4,4,4,nil,nil,nil},
    result = {id = 11,count = 1}
    },
    {
    recipe = {12,12,12,nil,nil,nil},
    result = {id = 13,count = 1}
    },
    {
    recipe = {nil,12,nil,13,13,13},
    result = {id = 16,count = 1}
    },
    {
    recipe = {nil,12,nil,9,9,9},
    result = {id = 17,count = 1}
    },
    {
    recipe = {nil,12,nil,10,10,10},
    result = {id = 18, count = 1}
    },
    {
    recipe = {nil,12,nil,11,11,11},
    result = {id = 19, count = 1}
    },
    {
    recipe = {9,nil,nil,9,nil,nil},
    result = {id = 14, count = 1}
    },
    {
    recipe = {12,6,14,nil,6,nil},
    result = {id = 21, count = 1}
    },
    {
    recipe = {9,5,9,9,7,9},
    result = {id = 15,count = 1}
    },
    {
    recipe = {2,2,nil,2,2,nil},
    result = {id = 24, count = 2}
    }
    }
end

function craftRecipes:getResult(r)
    local match = true
    for i,v in pairs(recipes) do
        for i=1,6 do
            if r[i] ~= v.recipe[i] then
                match = false
            end
        end
        if match then return v.result 
        else match=true
        end
    end
    return nil
end

function craftRecipes:touched(touch)
    -- Codea does not automatically call this method
end
