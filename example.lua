-- RoundUI Example
-- URL of lib (lol): https://github.com/Info-kun-git/RoundUI/blob/main/source.lua?raw=true

local rui = loadstring(game:HttpGet("https://github.com/Info-kun-git/RoundUI/blob/main/source.lua?raw=true"))()

local ui = rui.new({
    Name = "RoundUI Example",
    Color = Color3.fromRGB(102, 204, 153),
    Size = UDim2.new(0, 300, 0, 350)
})

local mainPage = ui:createPage("Main Controls")

local controlsSec = mainPage:createSection("Controls")

local button = controlsSec:createButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked!")
    end
})

local toggleState = false
local toggle = controlsSec:createToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(state)
        toggleState = state
        if state then
            print("Toggle enabled!")
        else
            print("Toggle disabled!")
        end
    end
})

local sliderValue = 50
local slider = controlsSec:createSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        sliderValue = value
        print("Slider value:", value)
    end
})

controlsSec:createLabel("Welcome to RoundUI!")
controlsSec:createLabel("Drag the top bar to move")

local statusSec = mainPage:createSection("Status")

local statusLabel = statusSec:createLabel("Ready")

local updateBtn = statusSec:createButton({
    Name = "Update Status",
    Callback = function()
        statusLabel:set("Updated at: " .. os.date("%X"))
        print("Status updated!")
    end
})

local toggleSec = mainPage:createSection("More Toggles")

local toggle2 = toggleSec:createToggle({
    Name = "Option A",
    Default = true,
    Callback = function(state)
        print("Option A:", state)
    end
})

local toggle3 = toggleSec:createToggle({
    Name = "Option B",
    Default = false,
    Callback = function(state)
        print("Option B:", state)
    end
})

print("RoundUI Example loaded successfully!")
print("UI is draggable - click and drag the top bar")
print("Use +/- button to minimize/expand")