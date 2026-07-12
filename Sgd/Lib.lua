-- UILib.lua - Educational UI Library
local UILib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Main GUI Holder
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UILib_Gui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Background Black with Smooth Border)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Smooth Border (Stroke)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Draggable
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BackgroundTransparency = 0
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "UI Library"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = TitleBar

-- Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ScrollingFrame.Parent = MainFrame

local CanvasLayout = Instance.new("UIListLayout")
CanvasLayout.Padding = UDim.new(0, 8)
CanvasLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
CanvasLayout.Parent = ScrollingFrame

-- Functions
local function CreateElement(parent, type, props)
    local element = Instance.new(type)
    for k, v in pairs(props) do
        element[k] = v
    end
    element.Parent = parent
    return element
end

-- 🔘 BUTTON
function UILib:Button(text, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, -10, 0, 35)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ButtonFrame.BackgroundTransparency = 0
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ScrollingFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ButtonFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ButtonFrame
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -25, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "›"
    Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.TextSize = 18
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(callback)
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    return ButtonFrame
end

-- 🔄 TOGGLE
function UILib:Toggle(text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.BackgroundTransparency = 0
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollingFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    -- Switch
    local SwitchBg = Instance.new("Frame")
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SwitchBg.BackgroundTransparency = 0
    SwitchBg.BorderSizePixel = 0
    SwitchBg.Parent = ToggleFrame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg
    
    local SwitchDot = Instance.new("Frame")
    SwitchDot.Size = UDim2.new(0, 16, 0, 16)
    SwitchDot.Position = UDim2.new(0, 2, 0.5, -8)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchDot.BackgroundTransparency = 0
    SwitchDot.BorderSizePixel = 0
    SwitchDot.Parent = SwitchBg
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = SwitchDot
    
    local toggled = default or false
    
    local function UpdateSwitch()
        local targetPos = toggled and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = toggled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(60, 60, 60)
        TweenService:Create(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(SwitchDot, TweenInfo.new(0.3), {Position = targetPos}):Play()
    end
    
    UpdateSwitch()
    
    SwitchBg.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateSwitch()
        callback(toggled)
    end)
    
    return ToggleFrame
end

-- 📊 SLIDER
function UILib:Slider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 55)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.BackgroundTransparency = 0
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollingFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SliderFrame
    
    -- Name Label
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.6, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 15, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = SliderFrame
    
    -- Number Box
    local NumberBox = Instance.new("TextButton")
    NumberBox.Size = UDim2.new(0, 50, 0, 22)
    NumberBox.Position = UDim2.new(1, -60, 0, 4)
    NumberBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    NumberBox.BackgroundTransparency = 0
    NumberBox.BorderSizePixel = 0
    NumberBox.Text = tostring(default)
    NumberBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    NumberBox.TextSize = 13
    NumberBox.Font = Enum.Font.GothamMedium
    NumberBox.Parent = SliderFrame
    
    local NumCorner = Instance.new("UICorner")
    NumCorner.CornerRadius = UDim.new(0, 4)
    NumCorner.Parent = NumberBox
    
    -- Slider Bar
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -30, 0, 4)
    SliderBar.Position = UDim2.new(0, 15, 0, 38)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.BackgroundTransparency = 0
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    -- Trail
    local Trail = Instance.new("Frame")
    Trail.Size = UDim2.new(0, 0, 1, 0)
    Trail.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    Trail.BackgroundTransparency = 0
    Trail.BorderSizePixel = 0
    Trail.Parent = SliderBar
    
    local TrailCorner = Instance.new("UICorner")
    TrailCorner.CornerRadius = UDim.new(1, 0)
    TrailCorner.Parent = Trail
    
    -- Dot
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = UDim2.new(0, -6, 0.5, -6)
    Dot.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    Dot.BackgroundTransparency = 0
    Dot.BorderSizePixel = 0
    Dot.Parent = SliderBar
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot
    
    local value = default or min
    local function UpdateSlider(val)
        val = math.clamp(val, min, max)
        value = val
        local percent = (val - min) / (max - min)
        Trail.Size = UDim2.new(percent, 0, 1, 0)
        Dot.Position = UDim2.new(percent, -6, 0.5, -6)
        NumberBox.Text = tostring(math.floor(val))
        callback(val)
    end
    
    UpdateSlider(value)
    
    NumberBox.MouseButton1Click:Connect(function()
        local newVal = tonumber(game:GetService("GuiService"):PromptUserInput("Enter Value:", tostring(math.floor(value))))
        if newVal then
            UpdateSlider(newVal)
        end
    end)
    
    local draggingSlider = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
            local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            UpdateSlider(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            UpdateSlider(min + (max - min) * percent)
        end
    end)
    
    return SliderFrame
end

-- 📋 DROP-DOWN
function UILib:DropDown(name, options, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, -10, 0, 35)
    DropFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropFrame.BackgroundTransparency = 0
    DropFrame.BorderSizePixel = 0
    DropFrame.Parent = ScrollingFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -40, 1, 0)
    NameLabel.Position = UDim2.new(0, 15, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = DropFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 25, 1, 0)
    ToggleBtn.Position = UDim2.new(1, -30, 0, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = "v"
    ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    ToggleBtn.TextSize = 16
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = DropFrame
    
    local DropContainer = Instance.new("Frame")
    DropContainer.Size = UDim2.new(1, 0, 0, 0)
    DropContainer.Position = UDim2.new(0, 0, 0, 35)
    DropContainer.BackgroundTransparency = 1
    DropContainer.ClipsDescendants = true
    DropContainer.Parent = DropFrame
    
    local DropList = Instance.new("UIListLayout")
    DropList.Padding = UDim.new(0, 2)
    DropList.Parent = DropContainer
    
    local expanded = false
    local selected = nil
    
    local function UpdateHeight()
        local count = DropContainer:GetChildren()
        local height = 0
        for _, child in pairs(count) do
            if child:IsA("Frame") then
                height = height + 37
            end
        end
        local targetSize = expanded and UDim2.new(1, 0, 0, height) or UDim2.new(1, 0, 0, 0)
        TweenService:Create(DropContainer, TweenInfo.new(0.3), {Size = targetSize}):Play()
        ToggleBtn.Text = expanded and "−" or "v"
        -- Update canvas
        task.wait(0.35)
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollingFrame:GetChildren()[ScrollingFrame:GetChildren().Name ~= "UIListLayout" and #ScrollingFrame:GetChildren() or 0] * 45)
    end
    
    for _, option in pairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, 0, 0, 35)
        OptionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        OptionBtn.BackgroundTransparency = 0
        OptionBtn.BorderSizePixel = 0
        OptionBtn.Text = option
        OptionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionBtn.TextSize = 13
        OptionBtn.Font = Enum.Font.GothamMedium
        OptionBtn.Parent = DropContainer
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 4)
        OptCorner.Parent = OptionBtn
        
        OptionBtn.MouseButton1Click:Connect(function()
            selected = option
            NameLabel.Text = name .. ": " .. option
            expanded = false
            UpdateHeight()
            callback(option)
        end)
    end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        UpdateHeight()
    end)
    
    return DropFrame
end

return UILib
