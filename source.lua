-- RoundUI Library v1.3
-- Auto-scale, Safe Appear (Hidden), Textbox added

local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local core = game:GetService("CoreGui")
local plrs = game:GetService("Players")
local http = game:GetService("HttpService") -- Для генерации случайных имен

local lp = plrs.LocalPlayer
local mouse = lp:GetMouse()
local camera = workspace.CurrentCamera

local rui = {}
local page = {}
local section = {}
local elem = {}

rui.__index = rui
page.__index = page
section.__index = section
elem.__index = elem

-- Настройки темы
local THEME_FONT = Enum.Font.GothamBold 
local PADDING_SIZE = 6

local utils = {}

do
    -- Функция для защиты GUI (Safe Appear)
    function utils:secureParent(gui)
        -- 1. Генерируем случайное имя, чтобы игра не нашла GUI по названию
        gui.Name = http:GenerateGUID(false)
        
        -- 2. Пытаемся использовать защищенную папку (gethui), если её нет - CoreGui
        if (getgenv and getgenv().gethui) then
            gui.Parent = getgenv().gethui()
        elseif (syn and syn.protect_gui) then 
            syn.protect_gui(gui)
            gui.Parent = core
        else
            gui.Parent = core
        end
    end

    function utils:createBtn(obj)
        local btn = Instance.new("TextButton")
        btn.Font = THEME_FONT
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

    function utils:initDrag(frame, handle)
        handle = handle or frame
        local dragging = false
        local dragInput, dragStart, startPos

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
end

function rui.new(info)
    local name = info.Name or "RoundUI"
    local color = info.Color or Color3.fromRGB(102, 204, 153)
    
    -- АВТОМАТИЧЕСКИЙ РАСЧЕТ РАЗМЕРА (Optimal Size)
    -- Берем размер экрана
    local viewport = camera.ViewportSize
    -- Ширина: 35% от экрана, но не меньше 350px и не больше 600px
    local optimalWidth = math.clamp(viewport.X * 0.35, 350, 600)
    -- Высота: 40% от экрана, но не меньше 250px и не больше 500px
    local optimalHeight = math.clamp(viewport.Y * 0.4, 250, 500)
    
    local size = UDim2.new(0, optimalWidth, 0, optimalHeight)
    
    local scr = Instance.new("ScreenGui")
    scr.ResetOnSpawn = false
    -- ПРИМЕНЯЕМ ЗАЩИТУ (SAFE APPEAR)
    utils:secureParent(scr)
    
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
    top.BackgroundColor3 = Color3.fromRGB(76, 153, 115)
    top.BorderSizePixel = 0
    top.Parent = main
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 15)
    topCorner.Parent = top
    
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = top.BackgroundColor3
    topCover.BorderSizePixel = 0
    topCover.Parent = top
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = name
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Font = THEME_FONT
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
    minBtn.Font = THEME_FONT
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
    closeBtn.Font = THEME_FONT
    closeBtn.TextSize = 20
    closeBtn.Parent = btnContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -50)
    content.Position = UDim2.new(0, 5, 0, 45)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.Parent = content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, PADDING_SIZE)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    
    utils:initDrag(main, top)
    
    local minimized = false
    local originalSize = main.Size
    
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            minBtn.Text = "+"
            utils:tween(main, {Size = UDim2.new(0, 200, 0, 40)}, 0.3)
            content.Visible = false
        else
            minBtn.Text = "-"
            utils:tween(main, {Size = originalSize}, 0.3)
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
        name = name
    }, rui)
end

function rui:createPage(name)
    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(1, 0, 0, 30) 
    pg.BackgroundColor3 = Color3.fromRGB(120, 180, 150)
    pg.BackgroundTransparency = 1
    pg.Parent = self.content
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = "- " .. name .. " -"
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.BackgroundTransparency = 1
    txt.Font = THEME_FONT
    txt.TextSize = 16
    txt.TextTransparency = 0.2
    txt.Parent = pg
    
    return setmetatable({
        frame = pg,
        name = name
    }, page)
end

function page:createSection(name)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.BackgroundTransparency = 1
    sec.Parent = self.frame.Parent
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 0)
    header.AutomaticSize = Enum.AutomaticSize.Y -- Авто-высота текста
    header.Text = name
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.BackgroundTransparency = 1
    header.Font = THEME_FONT
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextSize = 14
    header.TextWrapped = true -- ИСПРАВЛЕНИЕ: перенос текста
    header.Parent = sec
    
    -- Добавим немного отступа снизу для хедера
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 5)
    pad.Parent = header
    
    local elemContainer = Instance.new("Frame")
    elemContainer.Size = UDim2.new(1, 0, 0, 0)
    elemContainer.Position = UDim2.new(0, 0, 0, 25) -- Начинаем чуть ниже
    elemContainer.AutomaticSize = Enum.AutomaticSize.Y
    elemContainer.BackgroundTransparency = 1
    elemContainer.Parent = sec
    
    local elemLayout = Instance.new("UIListLayout")
    elemLayout.Padding = UDim.new(0, PADDING_SIZE)
    elemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    elemLayout.SortOrder = Enum.SortOrder.LayoutOrder
    elemLayout.Parent = elemContainer
    
    return setmetatable({
        frame = sec,
        container = elemContainer,
        name = name
    }, section)
end

function section:createContainerElement()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(140, 200, 170)
    frame.Parent = self.container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    return frame
end

function section:createButton(info)
    local btnFrame = self:createContainerElement()
    btnFrame.BackgroundColor3 = Color3.fromRGB(100, 160, 220)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = info.Name or "Button"
    btn.BackgroundTransparency = 1
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = THEME_FONT
    btn.TextSize = 14
    btn.Parent = btnFrame
    
    btn.MouseButton1Click:Connect(function()
        if info.Callback then
            pcall(info.Callback)
        end
        utils:tween(btnFrame, {BackgroundColor3 = Color3.fromRGB(120, 180, 240)}, 0.1)
        wait(0.1)
        utils:tween(btnFrame, {BackgroundColor3 = Color3.fromRGB(100, 160, 220)}, 0.2)
    end)
    
    return {
        btn = btn,
        setText = function(self, txt)
            btn.Text = txt
        end
    }
end

-- НОВАЯ ФУНКЦИЯ: TEXTBOX
function section:createTextbox(info)
    local boxFrame = self:createContainerElement()
    boxFrame.BackgroundColor3 = Color3.fromRGB(130, 190, 160) -- Чуть темнее для поля ввода
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.4, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = info.Name or "Textbox"
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Font = THEME_FONT
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = boxFrame

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.5, 0, 0.7, 0)
    inputFrame.AnchorPoint = Vector2.new(1, 0.5)
    inputFrame.Position = UDim2.new(1, -10, 0.5, 0)
    inputFrame.BackgroundColor3 = Color3.fromRGB(100, 160, 130)
    inputFrame.Parent = boxFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = inputFrame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -10, 1, 0)
    input.Position = UDim2.new(0, 5, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = info.Placeholder or "Type here..."
    input.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = THEME_FONT
    input.TextSize = 13
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = inputFrame

    local callback = info.Callback or function() end

    -- Срабатывает когда нажали Enter или кликнули вне поля
    input.FocusLost:Connect(function(enterPressed)
        callback(input.Text)
    end)

    return {
        input = input,
        get = function() return input.Text end,
        set = function(self, txt) input.Text = txt end
    }
end

function section:createToggle(info)
    local tog = self:createContainerElement()
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.6, 0, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.Text = info.Name or "Toggle"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = THEME_FONT
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = tog
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 40, 0, 20)
    toggleFrame.AnchorPoint = Vector2.new(1, 0.5)
    toggleFrame.Position = UDim2.new(1, -10, 0.5, 0)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleFrame.Parent = tog
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleFrame
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.new(1,1,1)
    toggleCircle.Parent = toggleFrame
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = info.Default or false
    local callback = info.Callback or function() end
    
    local function update()
        if state then
            utils:tween(toggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
            utils:tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(76, 175, 80)}, 0.2)
        else
            utils:tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
            utils:tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}, 0.2)
        end
        callback(state)
    end
    
    local btn = utils:createBtn(tog)
    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)
    
    if state then
        toggleCircle.Position = UDim2.new(1, -18, 0.5, -8)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    end
    
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
    
    local slide = self:createContainerElement()
    slide.Size = UDim2.new(1, -4, 0, 45)
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 0, 20)
    txt.Position = UDim2.new(0, 10, 0, 2)
    txt.Text = info.Name or "Slider"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.BackgroundTransparency = 1
    txt.Font = THEME_FONT
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = slide
    
    local valueTxt = Instance.new("TextLabel")
    valueTxt.Size = UDim2.new(0, 50, 0, 20)
    valueTxt.AnchorPoint = Vector2.new(1, 0)
    valueTxt.Position = UDim2.new(1, -10, 0, 2)
    valueTxt.Text = tostring(default)
    valueTxt.TextColor3 = Color3.new(1,1,1)
    valueTxt.BackgroundTransparency = 1
    valueTxt.Font = THEME_FONT
    valueTxt.TextSize = 12
    valueTxt.TextXAlignment = Enum.TextXAlignment.Right
    valueTxt.Parent = slide
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 28)
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
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.BackgroundColor3 = Color3.new(1,1,1)
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local dragging = false
    local callback = info.Callback or function() end
    
    local function update(inputPos)
        local barSize = track.AbsoluteSize.X
        local barPos = track.AbsolutePosition.X
        if barSize == 0 then return end
        
        local percent = utils:clamp((inputPos - barPos) / barSize, 0, 1)
        local value = utils:round(min + (max - min) * percent, 2)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(percent, 0, 0.5, 0)
        valueTxt.Text = tostring(value)
        
        callback(value)
    end
    
    local btn = utils:createBtn(slide)
    
    btn.MouseButton1Down:Connect(function()
        dragging = true
        update(mouse.X)
    end)
    
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    rs.RenderStepped:Connect(function()
        if dragging then
            update(mouse.X)
        end
    end)
    
    local startPercent = (default - min) / (max - min)
    fill.Size = UDim2.new(startPercent, 0, 1, 0)
    handle.Position = UDim2.new(startPercent, 0, 0.5, 0)
    
    return {
        slide = slide,
        get = function() return tonumber(valueTxt.Text) end,
        set = function(self, val)
            val = utils:clamp(val, min, max)
            local percent = (val - min) / (max - min)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            handle.Position = UDim2.new(percent, 0, 0.5, 0)
            valueTxt.Text = tostring(val)
        end
    }
end

function section:createLabel(text)
    local frame = self:createContainerElement()
    frame.Size = UDim2.new(1, -4, 0, 30)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = THEME_FONT
    label.TextSize = 14
    label.TextWrapped = true
    label.Parent = frame
    
    return {
        label = label,
        set = function(self, txt) label.Text = txt end
    }
end

return rui
