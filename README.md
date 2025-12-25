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
> Note: The UI size is calculated automatically based on your screen resolution. Tested on phone, idk about PC =)

### Create Page
> Pages act as category headers within the scrolling container.
```lua
local mainPage = ui:createPage("Main Category")
```

### Create Section
< Sections group your elements. You can set them to be closed or open by default.
-- false = open, true = closed
```lua
local mySection = mainPage:createSection("Combat", false)
```

### Button
```lua
mySection:createButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Toggle
```lua
mySection:createToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Toggle is now:", state)
    end
})
```
### Slider
```lua
mySection:createSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        print("Slider value:", value)
    end
})
```

### Textbox
> The text value is what the user typed into the box.
```lua
mySection:createTextbox({
    Name = "Username",
    Placeholder = "Type here...",
    Callback = function(text)
        print("User entered:", text)
    end
})
```

### Label
```lua
mySection:createLabel("This is just a text label")
```

### Rn it's all I have
> am a big fan of turtlebrand
