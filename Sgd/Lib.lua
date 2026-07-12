--[[
    UI Library for Roblox
    Features: Button, Toggle, Slider, Dropdown
    Mobile-friendly with smooth borders
]]

local UILibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Create main GUI
function UILibrary:CreateGUI(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Smooth Border
    local Border = Instance.new("UICorner")
    Border.CornerRadius = UDim.new(0, 12)
    Border.Parent = MainFrame
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "UI Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = MainFrame
    
    -- Scrolling Frame for content
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    
    return {
        Frame = MainFrame,
        ScrollingFrame = ScrollingFrame,
        Layout = UIListLayout
    }
end

-- BUTTON
function UILibrary:CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "ButtonFrame"
    ButtonFrame.Size = UDim2.new(1, -20, 0, 45)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.BackgroundTransparency = 0.3
    ButtonFrame.Parent = parent
    
    local Border = Instance.new("UICorner")
    Border.CornerRadius = UDim.new(0, 8)
    Border.Parent = ButtonFrame
    
    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Name = "ButtonLabel"
    ButtonLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Text = text or "Button"
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.TextSize = 18
    ButtonLabel.Font = Enum.Font.GothamMedium
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = ButtonFrame
    
    local Symbol = Instance.new("TextLabel")
    Symbol.Name = "Symbol"
    Symbol.Size = UDim2.new(0, 30, 1, 0)
    Symbol.Position = UDim2.new(1, -40, 0, 0)
    Symbol.BackgroundTransparency = 1
    Symbol.Text = "→"
    Symbol.TextColor3 = Color3.fromRGB(255, 255, 255)
    Symbol.TextSize = 20
    Symbol.Font = Enum.Font.GothamMedium
    Symbol.TextXAlignment = Enum.TextXAlignment.Center
    Symbol.Parent = ButtonFrame
    
    local function onClick()
        if callback then callback() end
        local tween = TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.5})
        tween:Play()
        tween.Completed:Connect(function()
            local tween2 = TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.3})
            tween2:Play()
        end)
    end
    
    ButtonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            onClick()
        end
    end)
    
    return ButtonFrame
end

-- TOGGLE
function UILibrary:CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleFrame.BackgroundTransparency = 0.3
    ToggleFrame.Parent = parent
    
    local Border = Instance.new("UICorner")
    Border.CornerRadius = UDim.new(0, 8)
    Border.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text or "Toggle"
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 18
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    -- Switch background (track)
    local SwitchTrack = Instance.new("Frame")
    SwitchTrack.Name = "SwitchTrack"
    SwitchTrack.Size = UDim2.new(0, 50, 0, 25)
    SwitchTrack.Position = UDim2.new(1, -60, 0.5, -12.5)
    SwitchTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SwitchTrack.BackgroundTransparency = 0.3
    SwitchTrack.Parent = ToggleFrame
    
    local TrackBorder = Instance.new("UICorner")
    TrackBorder.CornerRadius = UDim.new(1, 0)
    TrackBorder.Parent = SwitchTrack
    
    -- Switch knob
    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Name = "SwitchKnob"
    SwitchKnob.Size = UDim2.new(0, 21, 0, 21)
    SwitchKnob.Position = UDim2.new(0, 2, 0.5, -10.5)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    SwitchKnob.Parent = SwitchTrack
    
    local KnobBorder = Instance.new("UICorner")
    KnobBorder.CornerRadius = UDim.new(1, 0)
    KnobBorder.Parent = SwitchKnob
    
    local toggled = default or false
    
    local function updateToggle(state)
        toggled = state
        if toggled then
            local tween1 = TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(76, 175, 80)})
            tween1:Play()
            local tween2 = TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10.5)})
            tween2:Play()
        else
            local tween1 = TweenService:Create(SwitchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)})
            tween1:Play()
            local tween2 = TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10.5)})
            tween2:Play()
        end
        if callback then callback(toggled) end
    end
    
    updateToggle(toggled)
    
    SwitchTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateToggle(not toggled)
        end
    end)
    
    return ToggleFrame, function() return toggled end
end

-- SLIDER
function UILibrary:CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Size = UDim2.new(1, -20, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderFrame.BackgroundTransparency = 0.3
    SliderFrame.Parent = parent
    
    local Border = Instance.new("UICorner")
    Border.CornerRadius = UDim.new(0, 8)
    Border.Parent = SliderFrame
    
    -- Header
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 25)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Size = UDim2.new(0.6, 0, 1, 0)
    SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text or "Slider"
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 18
    SliderLabel.Font = Enum.Font.GothamMedium
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = HeaderFrame
    
    -- Number Display (clickable)
    local NumberDisplay = Instance.new("TextLabel")
    NumberDisplay.Name = "NumberDisplay"
    NumberDisplay.Size = UDim2.new(0, 60, 1, 0)
    NumberDisplay.Position = UDim2.new(1, -70, 0, 0)
    NumberDisplay.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    NumberDisplay.BackgroundTransparency = 0.3
    NumberDisplay.Text = tostring(default or min)
    NumberDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    NumberDisplay.TextSize = 16
    NumberDisplay.Font = Enum.Font.GothamMedium
    NumberDisplay.Parent = HeaderFrame
    
    local NumberBorder = Instance.new("UICorner")
    NumberBorder.CornerRadius = UDim.new(0, 6)
    NumberBorder.Parent = NumberDisplay
    
    -- Slider Bar
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -20, 0, 4)
    SliderBar.Position = UDim2.new(0, 10, 0, 45)
    SliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SliderBar.BackgroundTransparency = 0.3
    SliderBar.Parent = SliderFrame
    
    local BarBorder = Instance.new("UICorner")
    BarBorder.CornerRadius = UDim.new(1, 0)
    BarBorder.Parent = SliderBar
    
    -- Trail (filled part)
    local Trail = Instance.new("Frame")
    Trail.Name = "Trail"
    Trail.Size = UDim2.new(0, 0, 1, 0)
    Trail.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    Trail.BackgroundTransparency = 0.3
    Trail.Parent = SliderBar
    
    local TrailBorder = Instance.new("UICorner")
    TrailBorder.CornerRadius = UDim.new(1, 0)
    TrailBorder.Parent = Trail
    
    -- Dot (handle)
    local Dot = Instance.new("Frame")
    Dot.Name = "Dot"
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(0, -8, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
    Dot.Parent = SliderBar
    
    local DotBorder = Instance.new("UICorner")
    DotBorder.CornerRadius = UDim.new(1, 0)
    DotBorder.Parent = Dot
    
    local currentValue = default or min
    local isDragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        local percent = (value - min) / (max - min)
        Trail.Size = UDim2.new(percent, 0, 1, 0)
        Dot.Position = UDim2.new(percent, -8, 0.5, -8)
        NumberDisplay.Text = tostring(math.round(value))
        if callback then callback(value) end
    end
    
    updateSlider(currentValue)
    
    -- Click on number to change
    NumberDisplay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local newValue = tonumber(UserInputService:GetStringAsync("Enter new value:"))
            if newValue then
                updateSlider(newValue)
            end
        end
    end)
    
    -- Drag slider
    local function onDrag(input)
        if isDragging then
            local relativeX = input.Position.X - SliderBar.AbsolutePosition.X
            local percent = math.clamp(relativeX / SliderBar.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            updateSlider(value)
        end
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            onDrag(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onDrag(input)
        end
    end)
    
    return SliderFrame, function() return currentValue end
end

-- DROPDOWN
function UILibrary:CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "DropdownFrame"
    DropdownFrame.Size = UDim2.new(1, -20, 0, 45)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownFrame.BackgroundTransparency = 0.3
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = parent
    
    local Border = Instance.new("UICorner")
    Border.CornerRadius = UDim.new(0, 8)
    Border.Parent = DropdownFrame
    
    -- Header
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 45)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "DropdownLabel"
    DropdownLabel.Size = UDim2.new(0.7, 0, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = text or "Dropdown"
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 18
    DropdownLabel.Font = Enum.Font.GothamMedium
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = HeaderFrame
    
    local ToggleSymbol = Instance.new("TextLabel")
    ToggleSymbol.Name = "ToggleSymbol"
    ToggleSymbol.Size = UDim2.new(0, 30, 1, 0)
    ToggleSymbol.Position = UDim2.new(1, -40, 0, 0)
    ToggleSymbol.BackgroundTransparency = 1
    ToggleSymbol.Text = "v"
    ToggleSymbol.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleSymbol.TextSize = 20
    ToggleSymbol.Font = Enum.Font.GothamMedium
    ToggleSymbol.TextXAlignment = Enum.TextXAlignment.Center
    ToggleSymbol.Parent = HeaderFrame
    
    -- Options container
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Name = "OptionsContainer"
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 0, 0, 45)
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.Parent = DropdownFrame
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.Padding = UDim.new(0, 2)
    OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsList.Parent = OptionsContainer
    
    local isOpen = false
    local selectedOption = nil
    
    local function toggleDropdown()
        isOpen = not isOpen
        local targetSize = isOpen and UDim2.new(1, 0, 0, #options * 35 + 10) or UDim2.new(1, 0, 0, 0)
        local targetSymbol = isOpen and "-" or "v"
        
        local tween = TweenService:Create(OptionsContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
        tween:Play()
        
        local tween2 = TweenService:Create(ToggleSymbol, TweenInfo.new(0.2), {Text = targetSymbol})
        tween2:Play()
        
        local newHeight = 45 + (isOpen and #options * 35 + 10 or 0)
        local tween3 = TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, newHeight)})
        tween3:Play()
    end
    
    -- Create options
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = "Option_" .. i
        OptionButton.Size = UDim2.new(1, -10, 0, 30)
        OptionButton.Position = UDim2.new(0, 5, 0, 0)
        OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.BackgroundTransparency = 0.5
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 16
        OptionButton.Font = Enum.Font.GothamMedium
        OptionButton.AutoButtonColor = false
        OptionButton.Parent = OptionsContainer
        
        local OptionBorder = Instance.new("UICorner")
        OptionBorder.CornerRadius = UDim.new(0, 6)
        OptionBorder.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownLabel.Text = option
            toggleDropdown()
            if callback then callback(option) end
        end)
    end
    
    HeaderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleDropdown()
        end
    end)
    
    return DropdownFrame, function() return selectedOption end
end

return UILibrary
