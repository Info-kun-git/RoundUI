-- RoundUI Library v1.0 by info-kun-git

local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local core = game:GetService("CoreGui")
local players = game:GetService("Players")

local lp = players.LocalPlayer
local mouse = lp:GetMouse()

local rui = {}
local page = {}
local section = {}
local elem = {}

rui.__index = rui
page.__index = page
section.__index = section
elem.__index = elem

local utils = {}

do
    function utils:createBtn(obj)
        local btn = Instance.new("TextButton")
        btn.Font = Enum.Font.SourceSans
        btn.Text = ""
        btn.TextColor3 = Color3.new(0,0,0)
        btn.TextSize = 14
        btn.AnchorPoint = Vector2.new(0.5,0.5)
        btn.BackgroundColor3 = Color3.new(1,1,1)
        btn.BackgroundTransparency = 1
        btn.Position = UDim2.new(0.5,0,0.5,0)
        btn.Size = UDim2.new(1,0,1,0)
        btn.Name = "Btn"
        btn.Parent = obj
        return btn
    end

    function utils:lerp(a,b,t)
        return a + (b - a) * t
    end

    function utils:initDrag(frame, handle)
        handle = handle or frame
        local dragging = false
        local offset
        
        handle.MouseButton1Down:Connect(function()
            dragging = true
            offset = Vector2.new(mouse.X, mouse.Y) - frame.AbsolutePosition
        end)
        
        mouse.Button1Up:Connect(function()
            dragging = false
        end)
        
        rs.RenderStepped:Connect(function()
            if dragging and offset then
                frame.Position = UDim2.fromOffset(
                    mouse.X - offset.X + (frame.AbsoluteSize.X * frame.AnchorPoint.X),
                    mouse.Y - offset.Y + (frame.AbsoluteSize.Y * frame.AnchorPoint.Y)
                )
            end
        end)
    end

    function utils:tween(obj, props, time)
        local t = ts:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Sine), props)
        t:Play()
        return t
    end

    function utils:clamp(v, min, max)
        return math.max(min, math.min(max, v))
    end

    function utils:round(num, places)
        local mult = 10^(places or 0)
        return math.floor(num * mult + 0.5) / mult
    end
end

function rui.new(info)
    local name = info.Name or "RoundUI"
    local color = info.Color or Color3.fromRGB(204, 0, 0)
    local size = info.Size or UDim2.new(0, 300, 0, 200)
    
    local scr = Instance.new("ScreenGui")
    scr.Name = name
    scr.ResetOnSpawn = false
    scr.Parent = core
    
    local main = Instance.new("Frame")
    main.Size = size
    main.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    main.BackgroundColor3 = color
    main.BorderSizePixel = 0
    main.Parent = scr
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = main
    
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 40)
    top.Position = UDim2.new(0, 0, 0, 0)
    top.BackgroundColor3 = Color3.fromRGB(255, 51, 51)
    top.BorderSizePixel = 0
    top.Parent = main
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 20)
    topCorner.Parent = top
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.Text = name
    title.TextColor3 = Color3.fromRGB(153, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Fondamento
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top
    
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(0.9, 0, 0.5, -15)
    minBtn.Text = "-"
    minBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.Font = Enum.Font.Fondamento
    minBtn.TextSize = 18
    minBtn.Parent = top
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 15)
    minCorner.Parent = minBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(0.95, 0, 0.5, -15)
    closeBtn.Text = "×"
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 153, 153)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.Fondamento
    closeBtn.TextSize = 20
    closeBtn.Parent = top
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeBtn
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scroll
    
    utils:initDrag(main, top)
    
    local minimized = false
    local originalSize = main.Size
    local originalPos = main.Position
    
    utils:createBtn(minBtn).MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            minBtn.Text = "+"
            utils:tween(main, {Size = UDim2.new(0, 220, 0, 40)}, 0.3)
            utils:tween(main, {Position = UDim2.new(0.5, -110, 0.5, -20)}, 0.3)
            content.Visible = false
        else
            minBtn.Text = "-"
            utils:tween(main, {Size = originalSize}, 0.3)
            utils:tween(main, {Position = originalPos}, 0.3)
            content.Visible = true
        end
    end)
    
    utils:createBtn(closeBtn).MouseButton1Click:Connect(function()
        scr:Destroy()
    end)
    
    return setmetatable({
        scr = scr,
        main = main,
        content = scroll,
        color = color,
        name = name
    }, rui)
end

function rui:createPage(name)
    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(1, 0, 0, 35)
    pg.BackgroundColor3 = Color3.fromRGB(255, 153, 153)
    pg.Parent = self.content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = pg
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0.8, 0)
    txt.Position = UDim2.new(0.1, 0, 0.1, 0)
    txt.Text = name
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Fondamento
    txt.TextSize = 18
    txt.Parent = pg
    
    return setmetatable({
        frame = pg,
        name = name
    }, page)
end

function page:createSection(name)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(0.9, 0, 0, 35)
    sec.BackgroundColor3 = Color3.fromRGB(255, 51, 51)
    sec.Parent = self.frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sec
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0.8, 0)
    txt.Position = UDim2.new(0.1, 0, 0.1, 0)
    txt.Text = name
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Fondamento
    txt.TextSize = 16
    txt.Parent = sec
    
    return setmetatable({
        frame = sec,
        name = name
    }, section)
end

function section:createButton(info)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, 45)
    btn.Text = info.Name or "Button"
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Fondamento
    btn.TextSize = 16
    btn.Parent = self.frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local btnClick = utils:createBtn(btn)
    
    btnClick.MouseButton1Click:Connect(function()
        if info.Callback then
            pcall(info.Callback)
        end
    end)
    
    return {
        btn = btn,
        setText = function(self, txt)
            btn.Text = txt
        end
    }
end

function section:createToggle(info)
    local tog = Instance.new("Frame")
    tog.Size = UDim2.new(0.8, 0, 0, 35)
    tog.Position = UDim2.new(0.1, 0, 0, 45)
    tog.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    tog.Parent = self.frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tog
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.6, 0, 1, 0)
    txt.Position = UDim2.new(0.05, 0, 0, 0)
    txt.Text = info.Name or "Toggle"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Fondamento
    txt.TextSize = 16
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = tog
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(0.8, -10, 0.5, -10)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 153, 153)
    indicator.Parent = tog
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 10)
    indCorner.Parent = indicator
    
    local state = info.Default or false
    local callback = info.Callback or function() end
    
    local function update()
        if state then
            indicator.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        else
            indicator.BackgroundColor3 = Color3.fromRGB(255, 153, 153)
        end
        callback(state)
    end
    
    local btn = utils:createBtn(tog)
    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)
    
    update()
    
    return {
        tog = tog,
        get = function() return state end,
        set = function(self, val)
            state = val
            update()
        end
    }
end

function section:createSlider(info)
    local min = info.Min or 0
    local max = info.Max or 100
    local default = info.Default or min
    
    local slide = Instance.new("Frame")
    slide.Size = UDim2.new(0.8, 0, 0, 50)
    slide.Position = UDim2.new(0.1, 0, 0, 45)
    slide.BackgroundColor3 = Color3.fromRGB(255, 51, 51)
    slide.Parent = self.frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = slide
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0, 20)
    txt.Position = UDim2.new(0.1, 0, 0.1, 0)
    txt.Text = info.Name or "Slider"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Fondamento
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = slide
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.8, 0, 0, 6)
    track.Position = UDim2.new(0.1, 0, 0.7, -3)
    track.BackgroundColor3 = Color3.fromRGB(255, 153, 153)
    track.Parent = slide
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = slide
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 6)
    handleCorner.Parent = handle
    
    local valueTxt = Instance.new("TextLabel")
    valueTxt.Size = UDim2.new(0.8, 0, 0, 20)
    valueTxt.Position = UDim2.new(0.1, 0, 0.4, 0)
    valueTxt.Text = tostring(default)
    valueTxt.TextColor3 = Color3.new(1,1,1)
    valueTxt.BackgroundTransparency = 1
    valueTxt.Font = Enum.Font.Fondamento
    valueTxt.TextSize = 14
    valueTxt.TextXAlignment = Enum.TextXAlignment.Left
    valueTxt.Parent = slide
    
    local dragging = false
    local callback = info.Callback or function() end
    
    local function update(posX)
        local percent = utils:clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = utils:round(min + (max - min) * percent, 2)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(percent, -6, 0.7, -6)
        valueTxt.Text = tostring(value)
        
        callback(value)
    end
    
    track.MouseButton1Down:Connect(function()
        dragging = true
        update(mouse.X)
    end)
    
    mouse.Button1Up:Connect(function()
        dragging = false
    end)
    
    mouse.Move:Connect(function()
        if dragging then
            update(mouse.X)
        end
    end)
    
    update(track.AbsolutePosition.X + (default - min) / (max - min) * track.AbsoluteSize.X)
    
    return {
        slide = slide,
        get = function()
            return tonumber(valueTxt.Text)
        end,
        set = function(self, val)
            val = utils:clamp(val, min, max)
            update(track.AbsolutePosition.X + (val - min) / (max - min) * track.AbsoluteSize.X)
        end
    }
end

function section:createLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 0, 30)
    label.Position = UDim2.new(0.1, 0, 0, 45)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Fondamento
    label.TextSize = 16
    label.TextWrapped = true
    label.Parent = self.frame
    
    return {
        label = label,
        set = function(self, txt)
            label.Text = txt
        end
    }
end

-- пример использования:
-- local ui = rui.new({Name = "Test UI", Color = Color3.fromRGB(204, 0, 0)})
-- local pg = ui:createPage("Main")
-- local sec = pg:createSection("Controls")
-- sec:createButton({Name = "Click Me", Callback = function() print("Clicked!") end})
-- sec:createToggle({Name = "Enable", Default = false, Callback = function(state) print("Toggle:", state) end})
-- sec:createSlider({Name = "Volume", Min = 0, Max = 100, Default = 50, Callback = function(val) print("Value:", val) end})
-- sec:createLabel("Welcome to RoundUI!")

return rui