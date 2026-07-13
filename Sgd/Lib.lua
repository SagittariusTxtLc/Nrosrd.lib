local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(windowTitle)
    windowTitle = windowTitle or "UI Library"
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0.5
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Header Frame
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    -- Hide bottom corners of header to look seamless
    local HeaderHide = Instance.new("Frame")
    HeaderHide.Size = UDim2.new(1, 0, 0, 10)
    HeaderHide.Position = UDim2.new(0, 0, 1, -10)
    HeaderHide.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HeaderHide.BorderSizePixel = 0
    HeaderHide.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowTitle
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Container for elements
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -50)
    Container.Position = UDim2.new(0, 10, 0, 45)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 4
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- Make GUI Draggable
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
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
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Elements = {}

    -- BUTTON ELEMENT
    function Elements:CreateButton(text, callback)
        callback = callback or function() end
        
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Size = UDim2.new(1, -6, 0, 35)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ButtonFrame.AutoButtonColor = true
        ButtonFrame.Text = ""
        ButtonFrame.Parent = Container

        local BCorn = Instance.new("UICorner")
        BCorn.CornerRadius = UDim.new(0, 6)
        BCorn.Parent = ButtonFrame

        local ButtonText = Instance.new("TextLabel")
        ButtonText.Size = UDim2.new(0.7, 0, 1, 0)
        ButtonText.Position = UDim2.new(0, 10, 0, 0)
        ButtonText.BackgroundTransparency = 1
        ButtonText.Text = text
        ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonText.TextSize = 14
        ButtonText.Font = Enum.Font.SourceSansMedium
        ButtonText.TextXAlignment = Enum.TextXAlignment.Left
        ButtonText.Parent = ButtonFrame

        local Symbol = Instance.new("TextLabel")
        Symbol.Size = UDim2.new(0.2, 0, 1, 0)
        Symbol.Position = UDim2.new(0.8, -10, 0, 0)
        Symbol.BackgroundTransparency = 1
        Symbol.Text = "➔"
        Symbol.TextColor3 = Color3.fromRGB(180, 180, 180)
        Symbol.TextSize = 14
        Symbol.TextXAlignment = Enum.TextXAlignment.Right
        Symbol.Parent = ButtonFrame

        ButtonFrame.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    -- TOGGLE ELEMENT
    function Elements:CreateToggle(text, callback)
        callback = callback or function() end
        local toggled = false

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -6, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleFrame.Parent = Container

        local TCorn = Instance.new("UICorner")
        TCorn.CornerRadius = UDim.new(0, 6)
        TCorn.Parent = ToggleFrame

        local ToggleText = Instance.new("TextLabel")
        ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleText.Position = UDim2.new(0, 10, 0, 0)
        ToggleText.BackgroundTransparency = 1
        ToggleText.Text = text
        ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleText.TextSize = 14
        ToggleText.Font = Enum.Font.SourceSansMedium
        ToggleText.TextXAlignment = Enum.TextXAlignment.Left
        ToggleText.Parent = ToggleFrame

        -- Switch Object
        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Size = UDim2.new(0, 40, 0, 20)
        SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
        SwitchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SwitchBg.Text = ""
        SwitchBg.Parent = ToggleFrame

        local SCorn = Instance.new("UICorner")
        SCorn.CornerRadius = UDim.new(1, 0)
        SCorn.Parent = SwitchBg

        local SwitchBall = Instance.new("Frame")
        SwitchBall.Size = UDim2.new(0, 16, 0, 16)
        SwitchBall.Position = UDim2.new(0, 2, 0.5, -8)
        SwitchBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SwitchBall.Parent = SwitchBg

        local BCorn2 = Instance.new("UICorner")
        BCorn2.CornerRadius = UDim.new(1, 0)
        BCorn2.Parent = SwitchBall

        SwitchBg.MouseButton1Click:Connect(function()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = toggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
            
            TweenService:Create(SwitchBall, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            callback(toggled)
        end)
    end

    -- SLIDER ELEMENT
    function Elements:CreateSlider(text, min, max, default, callback)
        min = min or 0
        max = max or 100
        default = default or min
        callback = callback or function() end

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -6, 0, 55)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.Parent = Container

        local SCorn = Instance.new("UICorner")
        SCorn.CornerRadius = UDim.new(0, 6)
        SCorn.Parent = SliderFrame

        local SliderText = Instance.new("TextLabel")
        SliderText.Size = UDim2.new(0.6, 0, 0, 25)
        SliderText.Position = UDim2.new(0, 10, 0, 2)
        SliderText.BackgroundTransparency = 1
        SliderText.Text = text
        SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderText.TextSize = 14
        SliderText.Font = Enum.Font.SourceSansMedium
        SliderText.TextXAlignment = Enum.TextXAlignment.Left
        SliderText.Parent = SliderFrame

        -- Clickable / Editable Value Box
        local ValueBox = Instance.new("TextBox")
        ValueBox.Size = UDim2.new(0, 45, 0, 20)
        ValueBox.Position = UDim2.new(1, -55, 0, 4)
        ValueBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        ValueBox.Text = tostring(default)
        ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueBox.TextSize = 12
        ValueBox.Font = Enum.Font.SourceSans
        ValueBox.ClearTextOnFocus = false
        ValueBox.Parent = SliderFrame

        local BoxCorn = Instance.new("UICorner")
        BoxCorn.CornerRadius = UDim.new(0, 4)
        BoxCorn.Parent = ValueBox

        -- Slider Mechanics
        local SliderBar = Instance.new("TextButton")
        SliderBar.Size = UDim2.new(1, -20, 0, 6)
        SliderBar.Position = UDim2.new(0, 10, 0, 36)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = SliderFrame

        local BarCorn = Instance.new("UICorner")
        BarCorn.CornerRadius = UDim.new(1, 0)
        BarCorn.Parent = SliderBar

        local SliderTrail = Instance.new("Frame")
        SliderTrail.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderTrail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderTrail.BorderSizePixel = 0
        SliderTrail.Parent = SliderBar

        local TrailCorn = Instance.new("UICorner")
        TrailCorn.CornerRadius = UDim.new(1, 0)
        TrailCorn.Parent = SliderTrail

        local SliderDot = Instance.new("Frame")
        SliderDot.Size = UDim2.new(0, 12, 0, 12)
        SliderDot.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
        SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderDot.Parent = SliderBar

        local DotCorn = Instance.new("UICorner")
        DotCorn.CornerRadius = UDim.new(1, 0)
        DotCorn.Parent = SliderDot

        local function update(percentage)
            percentage = math.clamp(percentage, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            ValueBox.Text = tostring(value)
            SliderTrail.Size = UDim2.new(percentage, 0, 1, 0)
            SliderDot.Position = UDim2.new(percentage, -6, 0.5, -6)
            callback(value)
        end

        -- Slide Logic via Mouse Dragging
        local active = false
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                active = true
                local absPos = SliderBar.AbsolutePosition
                local absSize = SliderBar.AbsoluteSize
                update((input.Position.X - absPos.X) / absSize.X)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if active and input.UserInputType == Enum.UserInputType.MouseMovement then
                local absPos = SliderBar.AbsolutePosition
                local absSize = SliderBar.AbsoluteSize
                update((input.Position.X - absPos.X) / absSize.X)
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                active = false
            end
        end)

        -- Handle Box Entry Update
        ValueBox.FocusLost:Connect(function()
            local num = tonumber(ValueBox.Text)
            if num then
                num = math.clamp(num, min, max)
                local perc = (num - min) / (max - min)
                update(perc)
            else
                ValueBox.Text = tostring(min + (max - min) * (SliderTrail.Size.X.Scale))
            end
        end)
    end

    -- DROPDOWN ELEMENT
    function Elements:CreateDropdown(text, options, callback)
        options = options or {}
        callback = callback or function() end
        local open = false

        local DropdownContainer = Instance.new("Frame")
        DropdownContainer.Size = UDim2.new(1, -6, 0, 60)
        DropdownContainer.BackgroundTransparency = 1
        DropdownContainer.ClipsDescendants = true
        DropdownContainer.Parent = Container

        local DropdownText = Instance.new("TextLabel")
        DropdownText.Size = UDim2.new(1, 0, 0, 20)
        DropdownText.Position = UDim2.new(0, 5, 0, 0)
        DropdownText.BackgroundTransparency = 1
        DropdownText.Text = text
        DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownText.TextSize = 14
        DropdownText.Font = Enum.Font.SourceSansMedium
        DropdownText.TextXAlignment = Enum.TextXAlignment.Left
        DropdownText.Parent = DropdownContainer

        local DropdownBar = Instance.new("TextButton")
        DropdownBar.Size = UDim2.new(1, 0, 0, 35)
        DropdownBar.Position = UDim2.new(0, 0, 0, 22)
        DropdownBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropdownBar.Text = ""
        DropdownBar.Parent = DropdownContainer

        local DCorn = Instance.new("UICorner")
        DCorn.CornerRadius = UDim.new(0, 6)
        DCorn.Parent = DropdownBar

        local SelectedLabel = Instance.new("TextLabel")
        SelectedLabel.Size = UDim2.new(0.8, 0, 1, 0)
        SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
        SelectedLabel.BackgroundTransparency = 1
        SelectedLabel.Text = "Select an Option..."
        SelectedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        SelectedLabel.TextSize = 14
        SelectedLabel.Font = Enum.Font.SourceSans
        SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
        SelectedLabel.Parent = DropdownBar

        local Indicator = Instance.new("TextLabel")
        Indicator.Size = UDim2.new(0.2, 0, 1, 0)
        Indicator.Position = UDim2.new(0.8, -10, 0, 0)
        Indicator.BackgroundTransparency = 1
        Indicator.Text = "v"
        Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.TextSize = 14
        Indicator.TextXAlignment = Enum.TextXAlignment.Right
        Indicator.Parent = DropdownBar

        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Position = UDim2.new(0, 0, 0, 62)
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Parent = DropdownContainer

        local OptCorn = Instance.new("UICorner")
        OptCorn.CornerRadius = UDim.new(0, 6)
        OptCorn.Parent = OptionsFrame

        local OptLayout = Instance.new("UIListLayout")
        OptLayout.Parent = OptionsFrame
        OptLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function refreshLayout()
            if open then
                local targetHeight = OptLayout.AbsoluteContentSize.Y
                TweenService:Create(OptionsFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(DropdownContainer, TweenInfo.new(0.25), {Size = UDim2.new(1, -6, 0, 65 + targetHeight)}):Play()
            else
                TweenService:Create(OptionsFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                TweenService:Create(DropdownContainer, TweenInfo.new(0.25), {Size = UDim2.new(1, -6, 0, 60)}):Play()
            end
        end

        DropdownBar.MouseButton1Click:Connect(function()
            open = not open
            Indicator.Text = open and "-" or "v"
            refreshLayout()
        end)

        for _, optName in ipairs(options) do
            local OptButton = Instance.new("TextButton")
            OptButton.Size = UDim2.new(1, 0, 0, 30)
            OptButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            OptButton.BackgroundTransparency = 1
            OptButton.Font = Enum.Font.SourceSans
            OptButton.Text = "   " .. tostring(optName)
            OptButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptButton.TextSize = 14
            OptButton.TextXAlignment = Enum.TextXAlignment.Left
            OptButton.Parent = OptionsFrame

            OptButton.MouseButton1Click:Connect(function()
                SelectedLabel.Text = tostring(optName)
                open = false
                Indicator.Text = "v"
                refreshLayout()
                callback(optName)
            end)
        end
    end

    return Elements
end

return Library
