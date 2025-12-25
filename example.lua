local rui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Info-kun-git/RoundUI/main/source.lua?raw=true"))()

local ui = rui.new({
    Name = "RoundUI v1.4",
    Color = Color3.fromRGB(102, 204, 153)
})

local mainPage = ui:createPage("Home")

local openSec = mainPage:createSection("Open by Default", false) 
openSec:createButton({
    Name = "I am Visible",
    Callback = function() print("Clicked") end
})

local closedSec = mainPage:createSection("Closed by Default", true)
closedSec:createSlider({
    Name = "Hidden Slider",
    Min = 0,
    Max = 100,
    Default = 25,
    Callback = function(v) print(v) end
})

local mixedSec = mainPage:createSection("Input Controls", false)
mixedSec:createTextbox({
    Name = "Value Input",
    Placeholder = "Enter text...",
    Callback = function(t) print("Typed: " .. t) end
})
mixedSec:createToggle({
    Name = "Enabled b",
    Default = true,
    Callback = function(s) print("Status: " .. tostring(s)) end
})

print("RoundUI Loaded. Check sections with ʌ/v buttons!")
