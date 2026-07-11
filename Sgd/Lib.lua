local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReplicatedMenuUI"
    ScreenGui.ResetOnSpawn = false
    
    -- Exploit protection check
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Main Container Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 240, 0, 380)
    MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(180, 180, 180) -- Light grey border frame
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame

    -- Main Header (Dark Blue)
    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Size = UDim2.new(1, -4, 0, 36)
    MainHeader.Position = UDim2.new(0, 2, 0, 2)
    MainHeader.BackgroundColor3 = Color3.fromRGB(14, 85, 156) -- Vibrant deep blue
    MainHeader.BorderSizePixel = 0
    MainHeader.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 5)
    HeaderCorner.Parent = MainHeader

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, -40, 1, 0)
    MainTitle.Position = UDim2.new(0, 10, 0, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = title or "Main"
    MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.TextSize = 20
    MainTitle.Font = Enum.Font.SourceSans
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.Parent = MainHeader

    local MainChevron = Instance.new("TextLabel")
    MainChevron.Size = UDim2.new(0, 30, 1, 0)
    MainChevron.Position = UDim2.new(1, -30, 0, 0)
    MainChevron.BackgroundTransparency = 1
    MainChevron.Text = "^"
    MainChevron.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainChevron.TextSize = 16
    MainChevron.Font = Enum.Font.SourceSansBold
    MainChevron.Parent = MainHeader

    -- Item Container
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -4, 1, -42)
    Container.Position = UDim2.new(0, 2, 0, 40)
    Container.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Container.BorderSizePixel = 0
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ScrollBarThickness = 0
    Container.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    local Window = {}

    function Window:CreateSection(sectionTitle)
        -- Section Header (Medium Blue)
        local SectionHeader = Instance.new("Frame")
        SectionHeader.Size = UDim2.new(1, 0, 0, 32)
        SectionHeader.BackgroundColor3 = Color3.fromRGB(56, 116, 179)
        SectionHeader.BorderSizePixel = 0
        SectionHeader.Parent = Container

        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 5)
        SectionCorner.Parent = SectionHeader

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, -40, 1, 0)
        SectionLabel.Position = UDim2.new(0, 10, 0, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = sectionTitle or "Player"
        SectionLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        SectionLabel.TextSize = 18
        SectionLabel.Font = Enum.Font.SourceSans
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = SectionHeader

        local SectionChevron = Instance.new("TextLabel")
        SectionChevron.Size = UDim2.new(0, 30, 1, 0)
        SectionChevron.Position = UDim2.new(1, -30, 0, 0)
        SectionChevron.BackgroundTransparency = 1
        SectionChevron.Text = "^"
        SectionChevron.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionChevron.TextSize = 14
        SectionChevron.Font = Enum.Font.SourceSansBold
        SectionChevron.Parent = SectionHeader

        -- Container for elements under this section
        local ElementContainer = Instance.new("Frame")
        ElementContainer.Size = UDim2.new(1, 0, 0, 0)
        ElementContainer.BackgroundTransparency = 1
        ElementContainer.Parent = Container

        local ElementLayout = Instance.new("UIListLayout")
        ElementLayout.Padding = UDim.new(0, 4)
        ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementLayout.Parent = ElementContainer

        ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ElementContainer.Size = UDim2.new(1, 0, 0, ElementLayout.AbsoluteContentSize.Y)
        end)

        local Section = {}

        -- Base style helper to look exactly like the image elements
        local function ApplyElementStyle(frame, name)
            frame.Size = UDim2.new(1, 0, 0, 28)
            frame.BackgroundColor3 = Color3.fromRGB(74, 126, 175) -- Muted blue-grey row color
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(225, 235, 245)
            label.Font = Enum.Font.SourceSans
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            return label
        end

        -- BUTTON
        function Section:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 28)
            Button.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            Button.BorderSizePixel = 0
            Button.Text = text or "button"
            Button.TextColor3 = Color3.fromRGB(225, 235, 245)
            Button.Font = Enum.Font.SourceSans
            Button.TextSize = 16
            Button.Parent = ElementContainer
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

            Button.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function Section:CreateToggle(text, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = ElementContainer
            ApplyElementStyle(ToggleFrame, text)

            -- Circular outer ring from screenshot
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = UDim2.new(1, -24, 0, 6)
            Circle.BackgroundTransparency = 1
            Circle.SizeConstraint = Enum.SizeConstraint.RelativeYY
            Circle.Parent = ToggleFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(225, 235, 245)
            Stroke.Thickness = 2
            Stroke.Parent = Circle

            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local InnerCircle = Instance.new("Frame")
            InnerCircle.Size = UDim2.new(0, 0, 0, 0)
            InnerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
            InnerCircle.BackgroundColor3 = Color3.fromRGB(238, 108, 0) -- Orange activation dot
            InnerCircle.BorderSizePixel = 0
            InnerCircle.Parent = Circle
            Instance.new("UICorner", InnerCircle).CornerRadius = UDim.new(1, 0)

            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Size = UDim2.new(1, 0, 1, 0)
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Text = ""
            ClickBtn.Parent = ToggleFrame

            local toggled = false
            ClickBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(InnerCircle, TweenInfo.new(0.15), {
                    Size = toggled and UDim2.new(0, 8, 0, 8) or UDim2.new(0, 0, 0, 0),
                    Position = toggled and UDim2.new(0.5, -4, 0.5, -4) or UDim2.new(0.5, 0, 0.5, 0)
                }):Play()
                callback(toggled)
            end)
        end

        -- TEXT BOX
        function Section:CreateTextBox(text, callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Parent = ElementContainer
            ApplyElementStyle(BoxFrame, text)

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0.4, 0, 0, 18)
            TextBox.Position = UDim2.new(1, -102, 0, 5)
            TextBox.BackgroundColor3 = Color3.fromRGB(14, 85, 156) -- Navy blue input fill
            TextBox.BorderSizePixel = 0
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.SourceSans
            TextBox.TextSize = 14
            TextBox.Parent = BoxFrame
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 3)

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then callback(TextBox.Text) end
            end)
        end

        -- KEYBIND
        function Section:CreateKeybind(text, default, callback)
            local BindFrame = Instance.new("Frame")
            BindFrame.Parent = ElementContainer
            ApplyElementStyle(BindFrame, text)

            local BindLabel = Instance.new("TextLabel")
            BindLabel.Size = UDim2.new(0, 40, 1, 0)
            BindLabel.Position = UDim2.new(1, -45, 0, 0)
            BindLabel.BackgroundTransparency = 1
            BindLabel.Text = default.Name
            BindLabel.TextColor3 = Color3.fromRGB(225, 235, 245)
            BindLabel.Font = Enum.Font.SourceSans
            BindLabel.TextSize = 16
            BindLabel.TextXAlignment = Enum.TextXAlignment.Right
            BindLabel.Parent = BindFrame

            local CurrentBind = default
            local Listening = false

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(1, 0, 1, 0)
            BindBtn.BackgroundTransparency = 1
            BindBtn.Text = ""
            BindBtn.Parent = BindFrame

            BindBtn.MouseButton1Click:Connect(function()
                Listening = true
                BindLabel.Text = "..."
            end)

            UIS.InputBegan:Connect(function(input)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentBind = input.KeyCode
                    BindLabel.Text = input.KeyCode.Name
                    Listening = false
                    callback(CurrentBind)
                end
            end)
        end

        -- SLIDER (Matches orange meter visual from image)
        function Section:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = ElementContainer
            ApplyElementStyle(SliderFrame, text)

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 1, 0)
            ValueLabel.Position = UDim2.new(1, -45, 0, -2)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(225, 235, 245)
            ValueLabel.Font = Enum.Font.SourceSans
            ValueLabel.TextSize = 16
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            -- Orange background slide bar line
            local BarBG = Instance.new("Frame")
            BarBG.Size = UDim2.new(1, -20, 0, 3)
            BarBG.Position = UDim2.new(0, 10, 1, -6)
            BarBG.BackgroundColor3 = Color3.fromRGB(14, 85, 156) -- Unfilled Track (Navy Blue)
            BarBG.BorderSizePixel = 0
            BarBG.Parent = SliderFrame

            local BarFill = Instance.new("Frame")
            BarFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            BarFill.BackgroundColor3 = Color3.fromRGB(238, 108, 0) -- Bright Orange track fill from image
            BarFill.BorderSizePixel = 0
            BarFill.Parent = BarBG

            local Sliding = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteWidth, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                BarFill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    UpdateSlider(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false
                end
            end)
        end

        -- DROPDOWN
        function Section:CreateDropdown(text, list, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = ElementContainer
            ApplyElementStyle(DropdownFrame, text)

            local Chevron = Instance.new("TextLabel")
            Chevron.Size = UDim2.new(0, 30, 1, 0)
            Chevron.Position = UDim2.new(1, -30, 0, 0)
            Chevron.BackgroundTransparency = 1
            Chevron.Text = "v"
            Chevron.TextColor3 = Color3.fromRGB(225, 235, 245)
            Chevron.TextSize = 12
            Chevron.Font = Enum.Font.SourceSansBold
            Chevron.Parent = DropdownFrame

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 1, 0)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.Parent = DropdownFrame

            local ListContainer = Instance.new("Frame")
            ListContainer.Size = UDim2.new(1, 0, 0, 0)
            ListContainer.BackgroundColor3 = Color3.fromRGB(64, 114, 160)
            ListContainer.BorderSizePixel = 0
            ListContainer.ClipsDescendants = true
            ListContainer.Parent = ElementContainer
            Instance.new("UICorner", ListContainer).CornerRadius = UDim.new(0, 4)

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = ListContainer

            for _, item in pairs(list) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Size = UDim2.new(1, 0, 0, 24)
                ItemBtn.BackgroundTransparency = 1
                ItemBtn.Text = "   " .. tostring(item)
                ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                ItemBtn.Font = Enum.Font.SourceSans
                ItemBtn.TextSize = 14
                ItemBtn.Parent = ListContainer

                ItemBtn.MouseButton1Click:Connect(function()
                    DropdownFrame.Frame.TextLabel.Text = item
                    TweenService:Create(ListContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    callback(item)
                end)
            end

            local expanded = false
            DropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetHeight = expanded and (#list * 24) or 0
                TweenService:Create(ListContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                Chevron.Text = expanded and "^" or "v"
            end)
        end

        return Section
    end
    return Window
end

return Library
