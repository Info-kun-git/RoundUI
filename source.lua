-- RoundUI Library v1.2 by info-kun-git

local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local core = game:GetService("CoreGui")
local plrs = game:GetService("Players")

local lp = plrs.LocalPlayer
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
        local dragInput
        local dragStart
        local startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        uis.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
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
    local color = info.Color or Color3.fromRGB(102, 204, 153) -- soft green
    local size = info.Size or UDim2.new(0, 300, 0, 200)
    local uiWidth = size.X.Offset
    
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
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = main
    
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 40)
    top.Position = UDim2.new(0, 0, 0, 0)
    top.BackgroundColor3 = Color3.fromRGB(76, 153, 115) -- darker green
    top.BorderSizePixel = 0
    top.Parent = main
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 15)
    topCorner.Parent = top
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.Text = name
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top
    
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 70, 1, 0)
    btnContainer.Position = UDim2.new(1, -75, 0, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = top
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = btnContainer
    
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Text = "-"
    minBtn.BackgroundColor3 = Color3.fromRGB(120, 180, 150)
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    minBtn.TextSize = 18
    minBtn.Parent = btnContainer
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Text = "×"
    closeBtn.BackgroundColor3 = Color3.fromRGB(240, 120, 120)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    closeBtn.TextSize = 20
    closeBtn.Parent = btnContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
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
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scroll
    
    -- Автоматический расчет ширины для элементов
    local elementWidth = uiWidth * 0.85 -- 85% от ширины UI
    
    -- Исправленная функция drag (работающая версия)
    local dragging = false
    local dragStart
    local startPos
    
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local dragInput = input
        end
    end)
    
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    local minimized = false
    local originalSize = main.Size
    local originalPos = main.Position
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            minBtn.Text = "+"
            utils:tween(main, {Size = UDim2.new(0, 200, 0, 40)}, 0.3)
            utils:tween(main, {Position = UDim2.new(0.5, -100, 0.5, -20)}, 0.3)
            content.Visible = false
        else
            minBtn.Text = "-"
            utils:tween(main, {Size = originalSize}, 0.3)
            utils:tween(main, {Position = originalPos}, 0.3)
            content.Visible = true
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        scr:Destroy()
    end)
    
    return setmetatable({
        scr = scr,
        main = main,
        content = scroll,
        color = color,
        name = name,
        uiWidth = uiWidth,
        elementWidth = elementWidth
    }, rui)
end

function rui:createPage(name)
    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(0.9, 0, 0, 35)
    pg.BackgroundColor3 = Color3.fromRGB(120, 180, 150)
    pg.Parent = self.content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = pg
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0.8, 0)
    txt.Position = UDim2.new(0.1, 0, 0.1, 0)
    txt.Text = name
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    txt.TextSize = 16
    txt.Parent = pg
    
    return setmetatable({
        frame = pg,
        name = name,
        parent = self
    }, page)
end

function page:createSection(name)
    local elementWidth = self.parent.elementWidth
    
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(0, elementWidth, 0, 40)
    sec.BackgroundColor3 = Color3.fromRGB(140, 200, 170)
    sec.Parent = self.frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = sec
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0.8, 0)
    txt.Position = UDim2.new(0.1, 0, 0.1, 0)
    txt.Text = name
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    txt.TextSize = 14
    txt.Parent = sec
    
    local elemContainer = Instance.new("Frame")
    elemContainer.Size = UDim2.new(1, 0, 1, 45)
    elemContainer.Position = UDim2.new(0, 0, 0, 45)
    elemContainer.BackgroundTransparency = 1
    elemContainer.Parent = sec
    
    local elemLayout = Instance.new("UIListLayout")
    elemLayout.Padding = UDim.new(0, 8)
    elemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    elemLayout.Parent = elemContainer
    
    return setmetatable({
        frame = sec,
        container = elemContainer,
        name = name,
        elementWidth = elementWidth,
        parent = self
    }, section)
end

function section:createButton(info)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, self.elementWidth * 0.9, 0, 35)
    btn.Text = info.Name or "Button"
    btn.BackgroundColor3 = Color3.fromRGB(100, 160, 220)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    btn.TextSize = 14
    btn.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
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
    tog.Size = UDim2.new(0, self.elementWidth * 0.9, 0, 35)
    tog.BackgroundColor3 = Color3.fromRGB(140, 200, 170)
    tog.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tog
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.6, 0, 1, 0)
    txt.Position = UDim2.new(0.05, 0, 0, 0)
    txt.Text = info.Name or "Toggle"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = tog
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 40, 0, 20)
    toggleFrame.Position = UDim2.new(0.85, -20, 0.5, -10)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleFrame.Parent = tog
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.new(1,1,1)
    toggleCircle.Parent = toggleFrame
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = toggleCircle
    
    local state = info.Default or false
    local callback = info.Callback or function() end
    
    local function update()
        if state then
            toggleCircle.Position = UDim2.new(1, -18, 0.5, -8)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
        else
            toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
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
    slide.Size = UDim2.new(0, self.elementWidth * 0.9, 0, 50)
    slide.BackgroundColor3 = Color3.fromRGB(140, 200, 170)
    slide.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = slide
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0, 20)
    txt.Position = UDim2.new(0.1, 0, 0.1, 0)
    txt.Text = info.Name or "Slider"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = slide
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.8, 0, 0, 6)
    track.Position = UDim2.new(0.1, 0, 0.6, -3)
    track.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    track.Parent = slide
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.BackgroundColor3 = Color3.new(1,1,1)
    handle.Parent = slide
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 6)
    handleCorner.Parent = handle
    
    local valueTxt = Instance.new("TextLabel")
    valueTxt.Size = UDim2.new(0.8, 0, 0, 20)
    valueTxt.Position = UDim2.new(0.1, 0, 0.35, 0)
    valueTxt.Text = tostring(default)
    valueTxt.TextColor3 = Color3.new(1,1,1)
    valueTxt.BackgroundTransparency = 1
    valueTxt.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    valueTxt.TextSize = 12
    valueTxt.TextXAlignment = Enum.TextXAlignment.Left
    valueTxt.Parent = slide
    
    local dragging = false
    local callback = info.Callback or function() end
    
    local function update(posX)
        local percent = utils:clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = utils:round(min + (max - min) * percent, 2)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(0.1 + percent * 0.8, -6, 0.6, -6)
        valueTxt.Text = tostring(value)
        
        callback(value)
    end
    
    track.MouseButton1Down:Connect(function()
        dragging = true
        update(mouse.X)
    end)
    
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    rs.RenderStepped:Connect(function()
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
    label.Size = UDim2.new(0, self.elementWidth * 0.9, 0, 30)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.fromName("Montserrat Alternates Bold")
    label.TextSize = 14
    label.TextWrapped = true
    label.Parent = self.container
    
    return {
        label = label,
        set = function(self, txt)
            label.Text = txt
        end
    }
end

return rui