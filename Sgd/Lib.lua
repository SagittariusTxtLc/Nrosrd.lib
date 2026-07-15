-- Save this script to GitHub/Pastebin.
-- Fully Fixed, Connected, and Outlined Compact Roblox UI Library

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}

-- Utility to create smooth UI corners easily
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- Utility to add a clean, smooth border outline
local function AddStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(45, 45, 45)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Utility to make elements draggable
local function MakeDraggable(dragFrame, parentFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parentFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parentFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Library:CreateWindow(titleText)
    -- Protect against duplicate GUIs & safely check parent environments
    local targetParent = game:GetService("CoreGui")
    local oldGui = targetParent:FindFirstChild("Compact_Roblox_Lib")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Compact_Roblox_Lib"
    ScreenGui.Parent = targetParent
    ScreenGui.ResetOnSpawn = false

    -- Main Frame (Black & Smooth)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 360) 
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 8)
    AddStroke(MainFrame, Color3.fromRGB(35, 35, 35), 1) -- Base frame subtle border

    -- Header (Perfectly connected to the top, with its own clean border)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -12, 0, 36)
    Header.Position = UDim2.new(0, 6, 0, 6)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    AddCorner(Header, 6)
    AddStroke(Header, Color3.fromRGB(50, 50, 50), 1) -- Smooth border around the Header
    MakeDraggable(Header, MainFrame)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "UI Library"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Scrollable Container for elements (Using Native Automatic Scaling to avoid bugs)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -12, 1, -56)
    Container.Position = UDim2.new(0, 6, 0, 48)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Container.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Elements = {}

    -- 1. BUTTON
    function Elements:CreateButton(text, callback)
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Size = UDim2.new(1, -4, 0, 34)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Text = ""
        ButtonFrame.Parent = Container
        AddCorner(ButtonFrame, 6)
        AddStroke(ButtonFrame, Color3.fromRGB(35, 35, 35), 1)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.8, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ButtonFrame

        local Symbol = Instance.new("TextLabel")
        Symbol.Size = UDim2.new(0.2, -10, 1, 0)
        Symbol.Position = UDim2.new(0.8, 0, 0, 0)
        Symbol.BackgroundTransparency = 1
        Symbol.Text = "➔"
        Symbol.TextColor3 = Color3.fromRGB(140, 140, 140)
        Symbol.Font = Enum.Font.SourceSansBold
        Symbol.TextSize = 13
        Symbol.TextXAlignment = Enum.TextXAlignment.Right
        Symbol.Parent = ButtonFrame

        ButtonFrame.MouseButton1Click:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            task.wait(0.08)
            TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            callback()
        end)
    end

    -- 2. TOGGLE
    function Elements:CreateToggle(text, default, callback)
        local toggled = default or false

        local ToggleFrame = Instance.new("TextButton")
        ToggleFrame.Size = UDim2.new(1, -4, 0, 34)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Text = ""
        ToggleFrame.Parent = Container
        AddCorner(ToggleFrame, 6)
        AddStroke(ToggleFrame, Color3.fromRGB(35, 35, 35), 1)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        -- Switch Track
        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 34, 0, 18)
        Switch.Position = UDim2.new(1, -44, 0.5, -9)
        Switch.BackgroundColor3 = toggled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 50)
        Switch.BorderSizePixel = 0
        Switch.Parent = ToggleFrame
        AddCorner(Switch, 9)

        -- Switch Slider Dot
        local SliderCircle = Instance.new("Frame")
        SliderCircle.Size = UDim2.new(0, 12, 0, 12)
        SliderCircle.Position = toggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderCircle.BorderSizePixel = 0
        SliderCircle.Parent = Switch
        AddCorner(SliderCircle, 6)

        local function updateToggle()
            local targetSwitchColor = toggled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 50)
            local targetCirclePos = toggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            
            TweenService:Create(Switch, TweenInfo.new(0.12), {BackgroundColor3 = targetSwitchColor}):Play()
            TweenService:Create(SliderCircle, TweenInfo.new(0.12), {Position = targetCirclePos}):Play()
            callback(toggled)
        end

        ToggleFrame.MouseButton1Click:Connect(function()
            toggled = not toggled
            updateToggle()
        end)
    end

    -- 3. SLIDER
    function Elements:CreateSlider(text, min, max, default, callback)
        local SliderValue = math.clamp(default or min, min, max)

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -4, 0, 48)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = Container
        AddCorner(SliderFrame, 6)
        AddStroke(SliderFrame, Color3.fromRGB(35, 35, 35), 1)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 0, 22)
        Label.Position = UDim2.new(0, 10, 0, 4)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        -- Slider Value Box (Gray, smooth, clickable)
        local ValueButton = Instance.new("TextBox")
        ValueButton.Size = UDim2.new(0, 40, 0, 18)
        ValueButton.Position = UDim2.new(1, -50, 0, 4)
        ValueButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ValueButton.BorderSizePixel = 0
        ValueButton.Text = tostring(SliderValue)
        ValueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueButton.Font = Enum.Font.SourceSansBold
        ValueButton.TextSize = 11
        ValueButton.ClipsDescendants = true
        ValueButton.Parent = SliderFrame
        AddCorner(ValueButton, 4)
        AddStroke(ValueButton, Color3.fromRGB(60, 60, 60), 1)

        -- Slider Bar
        local SlideBar = Instance.new("TextButton")
        SlideBar.Size = UDim2.new(1, -20, 0, 4)
        SlideBar.Position = UDim2.new(0, 10, 0.75, -2)
        SlideBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        SlideBar.BorderSizePixel = 0
        SlideBar.Text = ""
        SlideBar.AutoButtonColor = false
        SlideBar.Parent = SliderFrame
        AddCorner(SlideBar, 2)

        -- Trail
        local SlideTrail = Instance.new("Frame")
        SlideTrail.Size = UDim2.new(0, 0, 1, 0)
        SlideTrail.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        SlideTrail.BorderSizePixel = 0
        SlideTrail.Parent = SlideBar
        AddCorner(SlideTrail, 2)

        -- Slider Dot/Handle
        local SliderDot = Instance.new("Frame")
        SliderDot.Size = UDim2.new(0, 10, 0, 10)
        SliderDot.Position = UDim2.new(0, -5, 0.5, -5)
        SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderDot.BorderSizePixel = 0
        SliderDot.Parent = SlideBar
        AddCorner(SliderDot, 5)

        local isDragging = false

        local function updateSlider(percentage)
            percentage = math.clamp(percentage, 0, 1)
            SliderValue = math.floor(min + ((max - min) * percentage))
            
            SlideTrail.Size = UDim2.new(percentage, 0, 1, 0)
            SliderDot.Position = UDim2.new(percentage, -5, 0.5, -5)
            ValueButton.Text = tostring(SliderValue)
            
            callback(SliderValue)
        end

        local function updateFromMouse()
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = SlideBar.AbsolutePosition.X
            local barWidth = SlideBar.AbsoluteSize.X
            local percentage = (mousePos - barPos) / barWidth
            updateSlider(percentage)
        end

        SlideBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                updateFromMouse()
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateFromMouse()
            end
        end)

        ValueButton.FocusLost:Connect(function()
            local num = tonumber(ValueButton.Text)
            if num then
                num = math.clamp(num, min, max)
                local percentage = (num - min) / (max - min)
                updateSlider(percentage)
            else
                ValueButton.Text = tostring(SliderValue)
            end
        end)

        local startPercent = (SliderValue - min) / (max - min)
        updateSlider(startPercent)
    end

    -- 4. DROP-DOWN
    function Elements:CreateDropdown(text, list, callback)
        local isOpened = false
        local dropdownSizeY = 34
        local itemHeight = 28
        local totalMaxHeight = 135

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, -4, 0, dropdownSizeY)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = Container
        AddCorner(DropdownFrame, 6)
        AddStroke(DropdownFrame, Color3.fromRGB(35, 35, 35), 1)

        local DropdownBar = Instance.new("TextButton")
        DropdownBar.Size = UDim2.new(1, 0, 0, 34)
        DropdownBar.BackgroundTransparency = 1
        DropdownBar.Text = ""
        DropdownBar.Parent = DropdownFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.8, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = DropdownBar

        local Indicator = Instance.new("TextLabel")
        Indicator.Size = UDim2.new(0.2, -10, 1, 0)
        Indicator.Position = UDim2.new(0.8, 0, 0, 0)
        Indicator.BackgroundTransparency = 1
        Indicator.Text = "v"
        Indicator.TextColor3 = Color3.fromRGB(140, 140, 140)
        Indicator.Font = Enum.Font.SourceSansBold
        Indicator.TextSize = 13
        Indicator.TextXAlignment = Enum.TextXAlignment.Right
        Indicator.Parent = DropdownBar

        local OptionScroll = Instance.new("ScrollingFrame")
        OptionScroll.Size = UDim2.new(1, -10, 1, -34)
        OptionScroll.Position = UDim2.new(0, 5, 0, 34)
        OptionScroll.BackgroundTransparency = 1
        OptionScroll.BorderSizePixel = 0
        OptionScroll.ScrollBarThickness = 2
        OptionScroll.CanvasSize = UDim2.new(0, 0, 0, #list * itemHeight)
        OptionScroll.Parent = DropdownFrame

        local OptionLayout = Instance.new("UIListLayout")
        OptionLayout.Parent = OptionScroll
        OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptionLayout.Padding = UDim.new(0, 2)

        local function toggleDropdown()
            isOpened = not isOpened
            local targetHeight = 34
            local targetSymbol = "v"

            if isOpened then
                local calculatedHeight = 34 + (#list * itemHeight) + 4
                targetHeight = math.clamp(calculatedHeight, 34, totalMaxHeight)
                targetSymbol = "-"
            end

            TweenService:Create(DropdownFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -4, 0, targetHeight)
            }):Play()

            Indicator.Text = targetSymbol
        end

        DropdownBar.MouseButton1Click:Connect(toggleDropdown)

        for i, optionName in ipairs(list) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, itemHeight - 2)
            OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = optionName
            OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptionButton.Font = Enum.Font.SourceSansMedium
            OptionButton.TextSize = 12
            OptionButton.Parent = OptionScroll
            AddCorner(OptionButton, 4)

            OptionButton.MouseButton1Click:Connect(function()
                Label.Text = text .. " (" .. optionName .. ")"
                callback(optionName)
                toggleDropdown()
            end)
        end
    end

    return Elements
end

return Library
