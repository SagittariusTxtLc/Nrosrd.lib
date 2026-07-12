--[[
    Custom Roblox UI Library
    Components: Window, Button, Toggle, Slider, Dropdown

    HOW TO HOST:
    1. Upload this file to GitHub (as a raw file) or Pastebin (as raw).
    2. Get the RAW link (GitHub: click "Raw" button, Pastebin: use pastebin.com/raw/CODE).
    3. In your usage script, load it with:
         local Library = loadstring(game:HttpGet("RAW_LINK_HERE"))()

    This script must be loaded with loadstring(game:HttpGet(...))() -- it returns
    the Library table as its last line.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ================= THEME (edit these to restyle everything) =================
local Theme = {
    Background              = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency  = 0.5,
    Header                  = Color3.fromRGB(30, 30, 30), -- dark gray
    Section                 = Color3.fromRGB(18, 18, 18),
    Stroke                  = Color3.fromRGB(55, 55, 55),
    Text                    = Color3.fromRGB(240, 240, 240),
    SubText                 = Color3.fromRGB(160, 160, 160),
    Accent                  = Color3.fromRGB(255, 255, 255),
    SwitchOff               = Color3.fromRGB(60, 60, 60),
    SwitchOn                = Color3.fromRGB(230, 230, 230),
}

-- ================= HELPERS =================
local function create(class, props, children)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do
        inst[prop] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 8)})
end

local function stroke(color, thickness)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function tween(inst, props, duration, style)
    local info = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

-- ================= LIBRARY =================
local Library = {}
Library.__index = Library

function Library.new(title)
    local old = PlayerGui:FindFirstChild("CustomUILibrary")
    if old then old:Destroy() end

    local screenGui = create("ScreenGui", {
        Name = "CustomUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui,
    })

    local main = create("Frame", {
        Name = "Main",
        Parent = screenGui,
        Size = UDim2.new(0, 300, 0, 380),
        Position = UDim2.new(0.5, -150, 0.5, -190),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = Theme.BackgroundTransparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, {corner(10), stroke(Theme.Stroke, 1)})

    local header = create("Frame", {
        Name = "Header",
        Parent = main,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
    }, {corner(10)})

    -- flatten bottom corners of header so it sits flush against the body
    create("Frame", {
        Parent = header,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 0,
    })

    create("TextLabel", {
        Parent = header,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Window",
        Font = Enum.Font.GothamMedium,
        TextSize = 15,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local container = create("ScrollingFrame", {
        Name = "Container",
        Parent = main,
        Size = UDim2.new(1, -16, 1, -48),
        Position = UDim2.new(0, 8, 0, 42),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Stroke,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })

    create("UIListLayout", {
        Parent = container,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    -- dragging by header
    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        header.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    local Window = setmetatable({
        ScreenGui = screenGui,
        Main = main,
        Container = container,
    }, Library)

    return Window
end

-- ================= BUTTON =================
function Library:AddButton(text, callback)
    callback = callback or function() end

    local btn = create("TextButton", {
        Parent = self.Container,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Section,
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
    }, {corner(8), stroke()})

    create("TextLabel", {
        Parent = btn,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local icon = create("TextLabel", {
        Parent = btn,
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "â¯",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Theme.Section}, 0.15) end)

    btn.MouseButton1Click:Connect(function()
        tween(icon, {TextColor3 = Theme.Text}, 0.1)
        task.delay(0.12, function()
            tween(icon, {TextColor3 = Theme.SubText}, 0.2)
        end)
        callback()
    end)

    return btn
end

-- ================= TOGGLE =================
function Library:AddToggle(text, default, callback)
    callback = callback or function() end
    local state = default or false

    local row = create("Frame", {
        Parent = self.Container,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Section,
        BorderSizePixel = 0,
    }, {corner(8), stroke()})

    create("TextLabel", {
        Parent = row,
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local switch = create("Frame", {
        Parent = row,
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = state and Theme.SwitchOn or Theme.SwitchOff,
        BorderSizePixel = 0,
    }, {corner(10)})

    local dot = create("Frame", {
        Parent = switch,
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
    }, {corner(8)})

    local clickArea = create("TextButton", {
        Parent = row,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
    })

    local function update()
        tween(switch, {BackgroundColor3 = state and Theme.SwitchOn or Theme.SwitchOff}, 0.2)
        tween(dot, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
    end

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        update()
        callback(state)
    end)

    return {
        Set = function(_, value)
            state = value
            update()
            callback(state)
        end,
        Get = function() return state end,
    }
end

-- ================= SLIDER =================
function Library:AddSlider(text, min, max, default, callback)
    callback = callback or function() end
    min = min or 0
    max = max or 100
    local value = math.clamp(default or min, min, max)

    local holder = create("Frame", {
        Parent = self.Container,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Section,
        BorderSizePixel = 0,
    }, {corner(8), stroke()})

    create("TextLabel", {
        Parent = holder,
        Size = UDim2.new(1, -80, 0, 22),
        Position = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local valueBox = create("TextBox", {
        Parent = holder,
        Size = UDim2.new(0, 46, 0, 20),
        Position = UDim2.new(1, -58, 0, 6),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Text = tostring(value),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Theme.Text,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
    }, {corner(6), stroke()})

    local bar = create("Frame", {
        Parent = holder,
        Size = UDim2.new(1, -24, 0, 4),
        Position = UDim2.new(0, 12, 0, 34),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
    }, {corner(2)})

    local fill = create("Frame", {
        Parent = bar,
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, {corner(2)})

    local dot = create("Frame", {
        Parent = bar,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, {corner(6), stroke(Color3.fromRGB(0, 0, 0), 2)})

    local dragging = false

    local function setValue(newValue, fire)
        newValue = math.clamp(math.floor(newValue + 0.5), min, max)
        value = newValue
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        dot.Position = UDim2.new(pct, -6, 0.5, -6)
        valueBox.Text = tostring(value)
        if fire ~= false then callback(value) end
    end

    local function updateFromX(xPos)
        local pct = math.clamp((xPos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        setValue(min + (pct * (max - min)))
    end

    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    valueBox.FocusLost:Connect(function()
        local num = tonumber(valueBox.Text)
        if num then
            setValue(num)
        else
            valueBox.Text = tostring(value)
        end
    end)

    return {
        Set = function(_, newValue) setValue(newValue) end,
        Get = function() return value end,
    }
end

-- ================= DROPDOWN =================
function Library:AddDropdown(text, options, callback)
    callback = callback or function() end
    options = options or {}
    local open = false
    local selected = nil

    local holder = create("Frame", {
        Parent = self.Container,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Section,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, {corner(8), stroke()})

    local header = create("TextButton", {
        Parent = holder,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = "",
    })

    create("TextLabel", {
        Parent = header,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local arrow = create("TextLabel", {
        Parent = header,
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "v",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Theme.SubText,
    })

    local list = create("Frame", {
        Parent = holder,
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.new(0, 8, 0, 40),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    })

    create("UIListLayout", {
        Parent = list,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    for _, option in ipairs(options) do
        local optBtn = create("TextButton", {
            Parent = list,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            AutoButtonColor = false,
            Text = option,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Theme.SubText,
            BorderSizePixel = 0,
        }, {corner(6)})

        optBtn.MouseButton1Click:Connect(function()
            selected = option
            arrow.Text = "v"
            open = false
            tween(holder, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
            callback(option)
        end)
    end

    header.MouseButton1Click:Connect(function()
        open = not open
        local listHeight = (#options * 34)
        if open then
            arrow.Text = "-"
            tween(holder, {Size = UDim2.new(1, 0, 0, 40 + listHeight)}, 0.25)
        else
            arrow.Text = "v"
            tween(holder, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
        end
    end)

    return {
        Get = function() return selected end,
    }
end

return Library
