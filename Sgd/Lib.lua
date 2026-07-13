local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(windowTitle)
    windowTitle = windowTitle or "UI Library"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- MAIN WINDOW FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 420, 0, 260) -- Perfect balanced width and height
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    -- HEADER GUI (Perfectly attached to top; no bottom rounded border gap)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50) -- Adjusted height to 50px
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 14)
    HeaderCorner.Parent = Header

    -- FUSION STRIP: Hides bottom header curvature to cleanly connect with MainFrame
    local HeaderHide = Instance.new("Frame")
    HeaderHide.Size = UDim2.new(1, 0, 0, 15)
    HeaderHide.Position = UDim2.new(0, 0, 1, -15)
    HeaderHide.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    HeaderHide.BorderSizePixel = 0
    HeaderHide.ZIndex = 1
    HeaderHide.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 16, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowTitle
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18 -- Bold header text sizing
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = Header

    -- SCROLLING FRAME CONTAINER (With clean white scroll bar tracker)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -24, 1, -68)
    Container.Position = UDim2.new(0, 12, 0, 58)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 4
    Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255) -- White scrollbar
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ClipsDescendants = true -- Keeps scrolling items inside bounds
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)

    -- Dynamic auto-scrolling framework
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- ANTI-MISTOUCH SINGLE-TOUCH DRAGGING CONTROLLER
    local dragging = false
    local activeTouchInput = nil
    local dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if not dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            activeTouchInput = input
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == activeTouchInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if dragging and input == activeTouchInput then
            dragging = false
            activeTouchInput = nil
        end
    end)

    local Elements = {}

    -- BUTTON ELEMENT
    function Elements:CreateButton(text, callback)
        callback = callback or function() end
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Size = UDim2.new(1, -6, 0, 42)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        ButtonFrame.AutoButtonColor = true
        ButtonFrame.Text = ""
        ButtonFrame.Parent = Container

        local BCorn = Instance.new("UICorner")
        BCorn.CornerRadius = UDim.new(0, 8)
        BCorn.Parent = ButtonFrame

        local ButtonText = Instance.new("TextLabel")
        ButtonText.Size = UDim2.new(0.7, 0, 1, 0)
        ButtonText.Position = UDim2.new(0, 12, 0, 0)
        ButtonText.BackgroundTransparency = 1
        ButtonText.Text = text
        ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonText.TextSize = 16 -- Upgraded text sizes
        ButtonText.Font = Enum.Font.SourceSans
        ButtonText.TextXAlignment = Enum.TextXAlignment.Left
        ButtonText.Parent = ButtonFrame

        local Symbol = Instance.new("TextLabel")
        Symbol.Size = UDim2.new(0.2, 0, 1, 0)
        Symbol.Position = UDim2.new(0.8, -12, 0, 0)
        Symbol.BackgroundTransparency = 1
        Symbol.Text = "➔"
        Symbol.TextColor3 = Color3.fromRGB(255, 255, 255)
        Symbol.TextSize = 16
        Symbol.TextXAlignment = Enum.TextXAlignment.Right
        Symbol.Parent = ButtonFrame

        ButtonFrame.MouseButton1Click:Connect(function() callback() end)
    end

    -- TOGGLE ELEMENT
    function Elements:CreateToggle(text, callback)
        callback = callback or function() end
        local toggled = false

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -6, 0, 42)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        ToggleFrame.Parent = Container

        local TCorn = Instance.new("UICorner")
        TCorn.CornerRadius = UDim.new(0, 8)
        TCorn.Parent = ToggleFrame

        local ToggleText = Instance.new("TextLabel")
        ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleText.Position = UDim2.new(0, 12, 0, 0)
        ToggleText.BackgroundTransparency = 1
        ToggleText.Text = text
        ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleText.TextSize = 16 -- Upgraded text sizes
        ToggleText.Font = Enum.Font.SourceSans
        ToggleText.TextXAlignment = Enum.TextXAlignment.Left
        ToggleText.Parent = ToggleFrame

        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Size = UDim2.new(0, 42, 0, 22)
        SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
        SwitchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SwitchBg.Text = ""
        SwitchBg.Parent = ToggleFrame

        local SCorn = Instance.new("UICorner")
        SCorn.CornerRadius = UDim.new(1, 0)
        SCorn.Parent = SwitchBg

        local SwitchBall = Instance.new("Frame")
        SwitchBall.Size = UDim2.new(0, 16, 0, 16)
        SwitchBall.Position = UDim2.new(0, 3, 0.5, -8)
        SwitchBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SwitchBall.Parent = SwitchBg

        local BCorn2 = Instance.new("UICorner")
        BCorn2.CornerRadius = UDim.new(1, 0)
        BCorn2.Parent = SwitchBall

        SwitchBg.MouseButton1Click:Connect(function()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            local targetColor = toggled and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(50, 50, 50)
            TweenService:Create(SwitchBall, TweenInfo.new(0.18), {Position = targetPos}):Play()
            TweenService:Create(SwitchBg, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
            callback(toggled)
        end)
    end

    -- SLIDER ELEMENT
    function Elements:CreateSlider(text, min, max, default, callback)
        min = min or 0 max = max or 100 default = default or min callback = callback or function() end
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -6, 0, 60)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        SliderFrame.Parent = Container

        local SCorn = Instance.new("UICorner")
        SCorn.CornerRadius = UDim.new(0, 8)
        SCorn.Parent = SliderFrame

        local SliderText = Instance.new("TextLabel")
        SliderText.Size = UDim2.new(0.6, 0, 0, 28)
        SliderText.Position = UDim2.new(0, 12, 0, 2)
        SliderText.BackgroundTransparency = 1
        SliderText.Text = text
        SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderText.TextSize = 16 -- Upgraded text sizes
        SliderText.Font = Enum.Font.SourceSans
        SliderText.TextXAlignment = Enum.TextXAlignment.Left
        SliderText.Parent = SliderFrame

        local ValueBox = Instance.new("TextBox")
        ValueBox.Size = UDim2.new(0, 46, 0, 20)
        ValueBox.Position = UDim2.new(1, -58, 0, 6)
        ValueBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ValueBox.Text = tostring(default)
        ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueBox.TextSize = 13
        ValueBox.Font = Enum.Font.SourceSans
        ValueBox.ClearTextOnFocus = false
        ValueBox.Parent = SliderFrame

        local BoxCorn = Instance.new("UICorner")
        BoxCorn.CornerRadius = UDim.new(0, 4)
        BoxCorn.Parent = ValueBox

        local SliderBar = Instance.new("TextButton")
        SliderBar.Size = UDim2.new(1, -24, 0, 6)
        SliderBar.Position = UDim2.new(0, 12, 0, 40)
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
        SliderDot.Size = UDim2.new(0, 14, 0, 14)
        SliderDot.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
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
            SliderDot.Position = UDim2.new(percentage, -7, 0.5, -7)
            callback(value)
        end

        local active = false
        local function checkInput(input)
            local absPos = SliderBar.AbsolutePosition
            local absSize = SliderBar.AbsoluteSize
            update((input.Position.X - absPos.X) / absSize.X)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                active = true
                checkInput(input)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                checkInput(input)
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                active = false
            end
        end)
    end

    -- DROPDOWN ELEMENT (Fixed Background Rendering & Clipping Visibility)
    function Elements:CreateDropdown(text, options, callback)
        options = options or {} callback = callback or function() end
        local open = false

        local DropdownContainer = Instance.new("Frame")
        DropdownContainer.Size = UDim2.new(1, -6, 0, 64)
        DropdownContainer.BackgroundTransparency = 1
        DropdownContainer.ClipsDescendants = false -- FIXED: Ensures the dropdown lists drop outside container limits cleanly
        DropdownContainer.Parent = Container

        local DropdownText = Instance.new("TextLabel")
        DropdownText.Size = UDim2.new(1, 0, 0, 22)
        DropdownText.Position = UDim2.new(0, 4, 0, 0)
        DropdownText.BackgroundTransparency = 1
        DropdownText.Text = text
        DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownText.TextSize = 14
        DropdownText.Font = Enum.Font.SourceSans
        DropdownText.TextXAlignment = Enum.TextXAlignment.Left
        DropdownText.Parent = DropdownContainer

        local DropdownBar = Instance.new("TextButton")
        DropdownBar.Size = UDim2.new(1, 0, 0, 38)
        DropdownBar.Position = UDim2.new(0, 0, 0, 24)
        DropdownBar.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        DropdownBar.Text = ""
        DropdownBar.ZIndex = 3
        DropdownBar.Parent = DropdownContainer

        local DCorn = Instance.new("UICorner")
        DCorn.CornerRadius = UDim.new(0, 8)
        DCorn.Parent = DropdownBar

        local SelectedLabel = Instance.new("TextLabel")
        SelectedLabel.Size = UDim2.new(0.8, 0, 1, 0)
        SelectedLabel.Position = UDim2.new(0, 12, 0, 0)
        SelectedLabel.BackgroundTransparency = 1
        SelectedLabel.Text = "Select an Option..."
        SelectedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        SelectedLabel.TextSize = 16 -- Upgraded text sizes
        SelectedLabel.Font = Enum.Font.SourceSans
        SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
        SelectedLabel.ZIndex = 4
        SelectedLabel.Parent = DropdownBar

        local Indicator = Instance.new("TextLabel")
        Indicator.Size = UDim2.new(0.2, 0, 1, 0)
        Indicator.Position = UDim2.new(0.8, -12, 0, 0)
        Indicator.BackgroundTransparency = 1
        Indicator.Text = "▼"
        Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.TextSize = 12
        Indicator.TextXAlignment = Enum.TextXAlignment.Right
        Indicator.ZIndex = 4
        Indicator.Parent = DropdownBar

        -- DROPDOWN BACKDROP CONTAINER BACKGROUND
        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Position = UDim2.new(0, 0, 0, 64)
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22) -- Dark, visible option container background
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.ZIndex = 5 -- Ensures it layer overlays smoothly over items beneath it
        OptionsFrame.ClipsDescendants = true
        OptionsFrame.Parent = DropdownContainer

        local OptCorn = Instance.new("UICorner")
        OptCorn.CornerRadius = UDim.new(0, 8)
        OptCorn.Parent = OptionsFrame

        local OptLayout = Instance.new("UIListLayout")
        OptLayout.Parent = OptionsFrame
        OptLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function refreshLayout()
            if open then
                local targetHeight = OptLayout.AbsoluteContentSize.Y
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 66 + targetHeight)}):Play()
            else
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                TweenService:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 64)}):Play()
            end
        end

        DropdownBar.MouseButton1Click:Connect(function()
            open = not open
            Indicator.Text = open and "▲" or "▼"
            refreshLayout()
        end)

        for _, optName in ipairs(options) do
            local OptButton = Instance.new("TextButton")
            OptButton.Size = UDim2.new(1, 0, 0, 36)
            OptButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            OptButton.BackgroundTransparency = 1
            OptButton.Font = Enum.Font.SourceSans
            OptButton.Text = "   " .. tostring(optName)
            OptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptButton.TextSize = 16 -- Upgraded text sizes
            OptButton.TextXAlignment = Enum.TextXAlignment.Left
            OptButton.ZIndex = 6
            OptButton.Parent = OptionsFrame

            OptButton.MouseButton1Click:Connect(function()
                SelectedLabel.Text = tostring(optName)
                SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                open = false
                Indicator.Text = "▼"
                refreshLayout()
                callback(optName)
            end)
        end
    end

    return Elements
end

return Library
