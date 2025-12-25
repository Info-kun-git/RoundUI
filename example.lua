-- main script using RoundUI
local rui = loadstring(game:HttpGet("https://github.com/Info-kun-git/RoundUI/blob/main/source.lua?raw=true"))()

local ui = rui.new({
    Name = "Super Ring Parts v4",
    Color = Color3.fromRGB(204, 0, 0),
    Size = UDim2.new(0, 220, 0, 190)
})

local pg = ui:createPage("Main")
local sec = pg:createSection("Controls")

local toggleBtn = sec:createButton({
    Name = "Ring Parts Off",
    Callback = function()
        print("Yo")
    end
})

local radiusSlider = sec:createSlider({
    Name = "Radius",
    Min = 1,
    Max = 1000,
    Default = 50,
    Callback = function(val)
        -- ваш код radius
    end
})

-- и так далее для остальных элементов