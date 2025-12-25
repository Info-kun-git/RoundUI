# RoundUI
> If u will fork and change RoUI, I will steal your commits HEHEHE
---
---
---
# RoundUI v1.4 Documentation

RoundUI is a chill ui library
---

## 1. Setup & Import

### Import lib

```lua
local rui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Info-kun-git/RoundUI/main/source.lua?raw=true"))()
```
### Create Window/UI
```
local ui = rui.new({
    Name = "Title",
    Color = Color3.fromRGB(102, 204, 153) 
})
```
> Idk any others RGB, sorry for that ugly color

### Create page 
Pages act as category headers within the scrolling container.
local combatPage = ui:createPage("Combat")

4. Sections (Collapsible)
Sections group elements together. They feature a ʌ/v button to expand or collapse content.
Syntax: page:createSection("Title", isClosed)
 * Title (string): The label for the section.
 * isClosed (boolean): If set to true, the section will be collapsed by default.
<!-- end list -->
-- An expanded section
local mainSec = combatPage:createSection("Main Cheats", false)

-- A collapsed section
local miscSec = combatPage:createSection("Misc Settings", true)

5. UI Elements
Button
Simple clickable element to trigger functions.
mainSec:createButton({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

Toggle
A switch for boolean (on/off) values.
mainSec:createToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm is now:", state)
    end
})

Slider
Used for selecting numerical values within a range.
mainSec:createSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

Textbox
Allows users to input strings. The value is passed to the callback when focus is lost (Enter pressed or clicking away).
mainSec:createTextbox({
    Name = "Webhook URL",
    Placeholder = "https://discord...",
    Callback = function(text)
        print("User saved URL:", text)
    end
})

Label
Displays simple text information.
mainSec:createLabel("Version: 1.4.0 Stable")

6. Functional Script Example
local rui = loadstring(game:HttpGet("[https://raw.githubusercontent.com/Info-kun-git/RoundUI/main/source.lua](https://raw.githubusercontent.com/Info-kun-git/RoundUI/main/source.lua)"))()

local ui = rui.new({
    Name = "RoundUI v1.4",
    Color = Color3.fromRGB(100, 150, 250)
})

local main = ui:createPage("Main")
local movement = main:createSection("Movement", false)

movement:createSlider({
    Name = "Speed",
    Min = 16, Max = 100, Default = 16,
    Callback = function(v) print("Speed:", v) end
})

local config = main:createSection("Config", true)
config:createTextbox({
    Name = "Filename",
    Placeholder = "my_config...",
    Callback = function(val) print("Config name set to:", val) end
})


Would you like me to add any specific advanced features like Color Pickers or Keybinds to this documentation?

