local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Main Frame (Adjusted to be compact and mobile-friendly)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 290, 0, 240) -- Made more compact to eliminate dead space
    MainFrame.Position = UDim2.new(0.5, -145, 0.5, -120)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 35)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "UI Window"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 15
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    -- Container for elements
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -20, 1, -45)
    Container.Position = UDim2.new(0, 10, 0, 40)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    local Elements = {}

    -- BUTTON ELEMENT
    function Elements:CreateButton(text, callback)
        callback = callback or function() end
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Button.AutoButtonColor = false
        Button.Text = ""
        Button.Parent = Container

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 6)
        BCorner.Parent = Button

        local BText = Instance.new("TextLabel")
        BText.Size = UDim2.new(1, -40, 1, 0)
        BText.Position = UDim2.new(0, 10, 0, 0)
        BText.BackgroundTransparency = 1
        BText.Text = text
        BText.TextColor3 = Color3.fromRGB(230, 230, 230)
        BText.TextSize = 14
        BText.Font = Enum.Font.SourceSans
        BText.TextXAlignment = Enum.TextXAlignment.Left
        BText.Parent = Button

        local BSplash = Instance.new("TextLabel")
        BSplash.Size = UDim2.new(0, 30, 1, 0)
        BSplash.Position = UDim2.new(1, -35, 0, 0)
        BSplash.BackgroundTransparency = 1
        BSplash.Text = "⚡"
        BSplash.TextColor3 = Color3.fromRGB(180, 180, 180)
        BSplash.TextSize = 14
        BSplash.TextXAlignment = Enum.TextXAlignment.Right
        BSplash.Parent = Button

        Button.MouseButton1Click:Connect(callback)
    end

    -- TOGGLE ELEMENT
    function Elements:CreateToggle(text, callback)
        callback = callback or function() end
        local toggled = false

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ToggleFrame.Parent = Container

        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 6)
        TCorner.Parent = ToggleFrame

        local TText = Instance.new("TextLabel")
        TText.Size = UDim2.new(1, -60, 1, 0)
        TText.Position = UDim2.new(0, 10, 0, 0)
        TText.BackgroundTransparency = 1
        TText.Text = text
        TText.TextColor3 = Color3.fromRGB(230, 230, 230)
        TText.TextSize = 14
        TText.Font = Enum.Font.SourceSans
        TText.TextXAlignment = Enum.TextXAlignment.Left
        TText.Parent = ToggleFrame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 40, 0, 20)
        Switch.Position = UDim2.new(1, -50, 0.5, -10)
        Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Switch.Text = ""
        Switch.Parent = ToggleFrame

        local SCorner = Instance.new("UICorner")
        SCorner.CornerRadius = UDim.new(1, 0)
        SCorner.Parent = Switch

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 16, 0, 16)
        Knob.Position = UDim2.new(0, 2, 0.5, -8)
        Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Knob.Parent = Switch

        local KCorner = Instance.new("UICorner")
        KCorner.CornerRadius = UDim.new(1, 0)
        KCorner.Parent = Knob

        local function toggle()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = toggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 45)
            
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            callback(toggled)
        end

        Switch.MouseButton1Click:Connect(toggle)
    end

    -- SLIDER ELEMENT (Fixed for Mobile Touch + PC Mouse support)
    function Elements:CreateSlider(text, min, max, default, callback)
        callback = callback or function() end
        min = min or 0
        max = max or 100
        default = default or min

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = Container

        local SName = Instance.new("TextLabel")
        SName.Size = UDim2.new(0.5, 0, 0, 20)
        SName.BackgroundTransparency = 1
        SName.Text = text
        SName.TextColor3 = Color3.fromRGB(230, 230, 230)
        SName.TextSize = 14
        SName.Font = Enum.Font.SourceSans
        SName.TextXAlignment = Enum.TextXAlignment.Left
        SName.Parent = SliderFrame

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(0, 45, 0, 20)
        Box.Position = UDim2.new(1, -45, 0, 0)
        Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Box.Text = tostring(default)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.Font = Enum.Font.SourceSans
        Box.TextSize = 12
        Box.ClipsDescendants = true
        Box.Parent = SliderFrame

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 4)
        BoxCorner.Parent = Box

        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, 0, 0, 6)
        Track.Position = UDim2.new(0, 0, 0, 32)
        Track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Track.Parent = SliderFrame

        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = Track

        local Trail = Instance.new("Frame")
        Trail.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Trail.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        Trail.Parent = Track

        local TrailCorner = Instance.new("UICorner")
        TrailCorner.CornerRadius = UDim.new(1, 0)
        TrailCorner.Parent = Trail

        local Dot = Instance.new("ImageButton")
        Dot.Size = UDim2.new(0, 14, 0, 14)
        Dot.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dot.Parent = Track

        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = Dot

        local function updateSlider(percentage)
            percentage = math.clamp(percentage, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            Box.Text = tostring(value)
            Trail.Size = UDim2.new(percentage, 0, 1, 0)
            Dot.Position = UDim2.new(percentage, -7, 0.5, -7)
            callback(value)
        end

        -- Robust Dragging Handling (Supports Mouse and Touch)
        local dragging = false

        local function checkInput(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relativeX = input.Position.X - Track.AbsolutePosition.X
                local percentage = relativeX / Track.AbsoluteSize.X
                updateSlider(percentage)
            end
        end

        Dot.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        UserInputService.InputChanged:Connect(checkInput)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        Box.FocusLost:Connect(function()
            local num = tonumber(Box.Text)
            if num then
                num = math.clamp(num, min, max)
                local percentage = (num - min) / (max - min)
                updateSlider(percentage)
            else
                Box.Text = tostring(min)
                updateSlider(0)
            end
        end)
    end

    -- DROP-DOWN ELEMENT
    function Elements:CreateDropdown(text, list, callback)
        list = list or {}
        callback = callback or function() end
        local expanded = false

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0, 55)
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = Container

        local DName = Instance.new("TextLabel")
        DName.Size = UDim2.new(1, 0, 0, 20)
        DName.BackgroundTransparency = 1
        DName.Text = text
        DName.TextColor3 = Color3.fromRGB(230, 230, 230)
        DName.TextSize = 14
        DName.Font = Enum.Font.SourceSans
        DName.TextXAlignment = Enum.TextXAlignment.Left
        DName.Parent = DropdownFrame

        local Bar = Instance.new("TextButton")
        Bar.Size = UDim2.new(1, 0, 0, 30)
        Bar.Position = UDim2.new(0, 0, 0, 22)
        Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Bar.Text = ""
        Bar.Parent = DropdownFrame

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0, 6)
        BarCorner.Parent = Bar

        local SelectedText = Instance.new("TextLabel")
        SelectedText.Size = UDim2.new(1, -40, 1, 0)
        SelectedText.Position = UDim2.new(0, 10, 0, 0)
        SelectedText.BackgroundTransparency = 1
        SelectedText.Text = "Select Option..."
        SelectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
        SelectedText.TextSize = 13
        SelectedText.Font = Enum.Font.SourceSans
        SelectedText.TextXAlignment = Enum.TextXAlignment.Left
        SelectedText.Parent = Bar

        local Symbol = Instance.new("TextLabel")
        Symbol.Size = UDim2.new(0, 30, 1, 0)
        Symbol.Position = UDim2.new(1, -35, 0, 0)
        Symbol.BackgroundTransparency = 1
        Symbol.Text = "v"
        Symbol.TextColor3 = Color3.fromRGB(200, 200, 200)
        Symbol.TextSize = 12
        Symbol.Font = Enum.Font.SourceSansBold
        Symbol.Parent = Bar

        local OptionsList = Instance.new("Frame")
        OptionsList.Size = UDim2.new(1, 0, 0, #list * 30)
        OptionsList.Position = UDim2.new(0, 0, 0, 55)
        OptionsList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        OptionsList.Parent = DropdownFrame

        local OListCorner = Instance.new("UICorner")
        OListCorner.CornerRadius = UDim.new(0, 6)
        OListCorner.Parent = OptionsList

        local OLayout = Instance.new("UIListLayout")
        OLayout.Parent = OptionsList

        for _, item in ipairs(list) do
            local Opt = Instance.new("TextButton")
            Opt.Size = UDim2.new(1, 0, 0, 30)
            Opt.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Opt.BackgroundTransparency = 1
            Opt.Text = "  " .. tostring(item)
            Opt.TextColor3 = Color3.fromRGB(200, 200, 200)
            Opt.TextSize = 13
            Opt.Font = Enum.Font.SourceSans
            Opt.TextXAlignment = Enum.TextXAlignment.Left
            Opt.Parent = OptionsList

            Opt.MouseButton1Click:Connect(function()
                SelectedText.Text = tostring(item)
                expanded = false
                Symbol.Text = "v"
                TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 55)}):Play()
                callback(item)
            end)
        end

        Bar.MouseButton1Click:Connect(function()
            expanded = not expanded
            local targetHeight = expanded and (55 + (#list * 30)) or 55
            Symbol.Text = expanded and "-" or "v"
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
        end)
    end

    return Elements
end

return Library
