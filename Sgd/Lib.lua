-- Save this script to GitHub/Pastebin.
-- It returns a library creation function.

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}

-- Utility to create smooth UI corners easily
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
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
    -- Protect against duplicate GUIs
    local oldGui = game:GetService("CoreGui"):FindFirstChild("Compact_Roblox_Lib")
    if oldGui then oldGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Compact_Roblox_Lib"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- Main Frame (Black & Smooth)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 400) -- Compact, fits nicely
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 8)

    -- Header (Smooth & Sleek)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -12, 0, 35)
    Header.Position = UDim2.new(0, 6, 0, 6)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    AddCorner(Header, 6)
    MakeDraggable(Header, MainFrame)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -15, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "UI Library"
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Scrollable Container for elements
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -12, 1, -55)
    Container.Position = UDim2.new(0, 6, 0, 47)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 3
    Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)

    -- Auto-adjust CanvasSize
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    local Elements = {}

    -- 1. BUTTON
    function Elements:CreateButton(text, callback)
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Text = ""
        ButtonFrame.Parent = Container
        AddCorner(ButtonFrame, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.8, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 15
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ButtonFrame

        local Symbol = Instance.new("TextLabel")
        Symbol.Size = UDim2.new(0.2, -10, 1, 0)
        Symbol.Position = UDim2.new(0.8, 0, 0, 0)
        Symbol.BackgroundTransparency = 1
        Symbol.Text = "➔"
        Symbol.TextColor3 = Color3.fromRGB(150, 150, 150)
        Symbol.Font = Enum.Font.SourceSansBold
        Symbol.TextSize = 14
        Symbol.TextXAlignment = Enum.TextXAlignment.Right
        Symbol.Parent = ButtonFrame

        ButtonFrame.MouseButton1Click:Connect(function()
            -- Pop effect
            TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            task.wait(0.1)
            TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            callback()
        end)
    end

    -- 2. TOGGLE
    function Elements:CreateToggle(text, default, callback)
        local toggled = default or false

        local ToggleFrame = Instance.new("TextButton")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Text = ""
        ToggleFrame.Parent = Container
        AddCorner(ToggleFrame, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 15
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        -- Switch (The Toggle Track)
        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 36, 0, 20)
        Switch.Position = UDim2.new(1, -46, 0.5, -10)
        Switch.BackgroundColor3 = toggled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
        Switch.BorderSizePixel = 0
        Switch.Parent = ToggleFrame
        AddCorner(Switch, 10)

        -- Switch Slider Dot
        local SliderCircle = Instance.new("Frame")
        SliderCircle.Size = UDim2.new(0, 14, 0, 14)
        SliderCircle.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderCircle.BorderSizePixel = 0
        SliderCircle.Parent = Switch
        AddCorner(SliderCircle, 7)

        local function updateToggle()
            local targetSwitchColor = toggled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
            local targetCirclePos = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = targetSwitchColor}):Play()
            TweenService:Create(SliderCircle, TweenInfo.new(0.15), {Position = targetCirclePos}):Play()
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
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = Container
        AddCorner(SliderFrame, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 0, 25)
        Label.Position = UDim2.new(0, 10, 0, 2)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.Font = Enum.Font.SourceSansMedium
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        -- Slider Value Box (Gray background, smooth borders, clickable)
        local ValueButton = Instance.new("TextBox")
        ValueButton.Size = UDim2.new(0, 45, 0, 18)
        ValueButton.Position = UDim2.new(1, -55, 0, 5)
        ValueButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ValueButton.BorderSizePixel = 0
        ValueButton.Text = tostring(SliderValue)
        ValueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueButton.Font = Enum.Font.SourceSansBold
        ValueButton.TextSize = 12
        ValueButton.ClipsDescendants = true
        ValueButton.Parent = SliderFrame
        AddCorner(ValueButton, 4)

        -- Slider Bar
        local SlideBar = Instance.new("TextButton")
        SlideBar.Size = UDim2.new(1, -20, 0, 4)
        SlideBar.Position = UDim2.new(0, 10, 0.75, -2)
        SlideBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
        SliderDot.Size = UDim2.new(0, 12, 0, 12)
        SliderDot.Position = UDim2.new(0, -6, 0.5, -6)
        SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderDot.BorderSizePixel = 0
        SliderDot.Parent = SlideBar
        AddCorner(SliderDot, 6)

        local isDragging = false

        local function updateSlider(percentage)
            percentage = math.clamp(percentage, 0, 1)
            SliderValue = math.floor(min + ((max - min) * percentage))
            
            SlideTrail.Size = UDim2.new(percentage, 0, 1, 0)
            SliderDot.Position = UDim2.new(percentage, -6, 0.5, -6)
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

        -- Allow editing directly via the number textbox
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

        -- Initialize Default Value
        local startPercent = (SliderValue - min) / (max - min)
        updateSlider(startPercent)
    end

    -- 4. DROP-DOWN
    function Elements:CreateDropdown(text, list, callback)
        local isOpened = false
        local dropdownSizeY = 35
        local itemHeight = 30
        local totalMaxHeight = 150 -- Compact dropdown constraint

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0, dropdownSizeY)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = Container
        AddCorner(DropdownFrame, 6)

        -- Interactive Bar
        local DropdownBar = Instance.new("TextButton")
        DropdownBar.Size = UDim2.new(1, 0, 0, 35)
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
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = DropdownBar

        local Indicator = Instance.new("TextLabel")
        Indicator.Size = UDim2.new(0.2, -10, 1, 0)
        Indicator.Position = UDim2.new(0.8, 0, 0, 0)
        Indicator.BackgroundTransparency = 1
        Indicator.Text = "v"
        Indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
        Indicator.Font = Enum.Font.SourceSansBold
        Indicator.TextSize = 14
        Indicator.TextXAlignment = Enum.TextXAlignment.Right
        Indicator.Parent = DropdownBar

        -- Container inside dropdown for options
        local OptionScroll = Instance.new("ScrollingFrame")
        OptionScroll.Size = UDim2.new(1, -10, 1, -35)
        OptionScroll.Position = UDim2.new(0, 5, 0, 35)
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
            local targetHeight = 35
            local targetSymbol = "v"

            if isOpened then
                local calculatedHeight = 35 + (#list * itemHeight) + 5
                targetHeight = math.clamp(calculatedHeight, 35, totalMaxHeight)
                targetSymbol = "-"
            end

            -- Smooth Animations
            TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, targetHeight)
            }):Play()

            Indicator.Text = targetSymbol
            
            -- Force layout refresh in main container
            task.wait(0.2)
            Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end

        DropdownBar.MouseButton1Click:Connect(toggleDropdown)

        for i, optionName in ipairs(list) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, itemHeight - 2)
            OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = optionName
            OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptionButton.Font = Enum.Font.SourceSansMedium
            OptionButton.TextSize = 13
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
