local rui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Info-kun-git/RoundUI/main/source.lua"))()

local ui = rui.new({
    Name = "RoundUI Example",
    Color = Color3.fromRGB(102, 204, 153)
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
        print("Toggle state:", state)
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

local userText = ""
local textbox = controlsSec:createTextbox({
    Name = "Enter Name",
    Placeholder = "Username...",
    Callback = function(text)
        userText = text
        print("User typed:", text)
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

print("RoundUI Example loaded successfully!")
