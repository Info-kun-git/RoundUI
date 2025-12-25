# RoundUI Documentation
> AUTOMATICALLY CREATED BY COPILOT

RoundUI is a lightweight, easy-to-use Lua UI library inspired by popular Roblox UI libraries (for example, Rayfield). It provides a small set of rounded, themed UI components you can drop into your project and customize.

## Features
- Simple API to create windows, sections, and common controls
- Themed and easily customizable (colors, rounding, fonts)
- Lightweight single-file implementation (source.lua)
- Built-in callbacks and events for interactive components

## Requirements
- Lua / Roblox environment supporting standard UI creation (see README and source.lua for specifics)

## Installation
1. Copy `source.lua` into your project.
2. Require or load `source.lua` according to your environment. Example:

Lua (generic):

local RoundUI = require(path.to.source) -- adjust for your project

-- or, if using a script loader, place source.lua next to your script and use:
-- local RoundUI = require(script.Parent:WaitForChild("source"))


## Quick Start

1. Create a window

i.e. (example usage — adjust to match how you `require` the module in your environment):

local UI = RoundUI.new("My UI")

local page = UI:CreatePage("Main")
local section = page:CreateSection("General")

-- Add a button
section:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked")
    end,
})

-- Add a toggle
section:CreateToggle({
    Name = "Enable",
    Default = false,
    Callback = function(value)
        print("Toggle is now", value)
    end,
})

-- Add a textbox
section:CreateTextBox({
    Name = "Input",
    Placeholder = "Type here...",
    Callback = function(text)
        print("Text entered:", text)
    end,
})

This quick-start shows common patterns: create a UI instance, add pages/sections, then add components with callbacks.

## API Overview (basic)

Note: This is a concise overview. See `source.lua` for the full implementation and all available options.

- RoundUI.new(title, options)
  - Creates a new UI root/window. Options typically include theme, size, and default styles.
  - Returns a UI object with methods to create pages and configure the window.

- UI:CreatePage(title, options)
  - Creates a tab or page inside the window. Returns a Page object.

- Page:CreateSection(title)
  - Creates a grouped section within a page. Returns a Section object.

Component creation (methods on Section):
- Section:CreateButton(tbl)
  - tbl.Name (string), tbl.Callback (function), optional styling fields.

- Section:CreateToggle(tbl)
  - tbl.Name, tbl.Default (boolean), tbl.Callback(value)

- Section:CreateTextBox(tbl)
  - tbl.Name, tbl.Placeholder, tbl.Default (string), tbl.Callback(text)

- Section:CreateSlider(tbl)
  - tbl.Name, tbl.Min, tbl.Max, tbl.Default, tbl.Callback(value)

- Section:CreateDropdown(tbl)
  - tbl.Name, tbl.Options (array), tbl.Default, tbl.Callback(selection)

- Section:CreateColorPicker(tbl)
  - tbl.Name, tbl.Default (color), tbl.Callback(color)

- Section:CreateLabel(tbl)
  - tbl.Text (string), used for static text descriptions.

- Section:CreateKeybind(tbl)
  - tbl.Name, tbl.Default (key), tbl.Callback(key, state)

Each component supports common styling options (color, rounding, size) depending on the library implementation.

## Theming & Customization
- Themes: Pass a theme table when creating the UI to set default colors and fonts.
- Per-component styling: Most component constructors accept optional fields for color, size, and rounding.
- Global settings: The UI object usually exposes methods or properties to change global theme at runtime.

Example:

UI:SetTheme({
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 170, 255),
    TextColor = Color3.fromRGB(230, 230, 230),
})

## Events and Callbacks
- Components are driven by callback functions you supply at construction time.
- Typical callback signatures shown in the API Overview (e.g., Toggle => function(value)).

## Example

A small, complete example (combine with your environment's require/load pattern):

local UI = RoundUI.new("Example UI")
local page = UI:CreatePage("Home")
local section = page:CreateSection("Actions")

section:CreateButton({ Name = "Greet", Callback = function() print("Hello from RoundUI") end })
section:CreateToggle({ Name = "Auto", Default = true, Callback = function(v) print("Auto =", v) end })
section:CreateTextBox({ Name = "Name", Placeholder = "Enter name...", Callback = function(t) print("Name:", t) end })

## Troubleshooting
- If components don't appear, confirm you required/loaded `source.lua` correctly and that your environment supports UI construction.
- Check the output/console for runtime errors; they often indicate missing resources or misnamed parameters.

## Contributing
- Fork the repository, make changes in a feature branch, and open a PR.
- Keep changes focused and provide examples or tests where applicable.

## License
- See repository LICENSE or README for license details.

## References
- README.md (project overview)
- source.lua (implementation & full API)
- example.lua (usage patterns)
