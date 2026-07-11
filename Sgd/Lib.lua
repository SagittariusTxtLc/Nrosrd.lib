local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OptimizedMenuUI"
    ScreenGui.ResetOnSpawn = false
    
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Main Container Frame (Grey Background)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 215, 0, 10) -- Starts small, dynamic sizing handles the rest
    MainFrame.Position = UDim2.new(0.5, -107, 0.5, -150) -- Perfect screen centering
    MainFrame.BackgroundColor3 = Color3.fromRGB(185, 185, 185)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 5)
    MainCorner.Parent = MainFrame

    local MainPadding = Instance.new("UIPadding")
    MainPadding.PaddingTop = UDim.new(0, 2)
    MainPadding.PaddingBottom = UDim.new(0, 2)
    MainPadding.PaddingLeft = UDim.new(0, 2)
    MainPadding.PaddingRight = UDim.new(0, 2)
    MainPadding.Parent = MainFrame

    local GlobalLayout = Instance.new("UIListLayout")
    GlobalLayout.Padding = UDim.new(0, 3)
    GlobalLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GlobalLayout.Parent = MainFrame

    -- Dynamic Auto-Sizing for the Background Wrapper
    GlobalLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        MainFrame.Size = UDim2.new(0, 215, 0, GlobalLayout.AbsoluteContentSize.Y + 4)
    end)

    -- Smooth Draggable Logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end

    -- Header (Dark Blue Top Bar)
    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Size = UDim2.new(1, 0, 0, 30)
    MainHeader.BackgroundColor3 = Color3.fromRGB(14, 85, 156)
    MainHeader.BorderSizePixel = 0
    MainHeader.LayoutOrder = 0
    MainHeader.Parent = MainFrame

    Instance.new("UICorner", MainHeader).CornerRadius = UDim.new(0, 4)

    MainHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    MainHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, -30, 1, 0)
    MainTitle.Position = UDim2.new(0, 8, 0, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = title or "Main"
    MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.TextSize = 15
    MainTitle.Font = Enum.Font.SourceSans
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.Parent = MainHeader

    local MainChevron = Instance.new("TextButton")
    MainChevron.Size = UDim2.new(0, 25, 1, 0)
    MainChevron.Position = UDim2.new(1, -25, 0, 0)
    MainChevron.BackgroundTransparency = 1
    MainChevron.Text = "^"
    MainChevron.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainChevron.TextSize = 13
    MainChevron.Font = Enum.Font.SourceSansBold
    MainChevron.Parent = MainHeader

    local Window = {}
    local ContentVisible = true

    function Window:CreateSection(sectionTitle)
        -- Section Header (Medium Blue)
        local SectionHeader = Instance.new("Frame")
        SectionHeader.Size = UDim2.new(1, 0, 0, 28)
        SectionHeader.BackgroundColor3 = Color3.fromRGB(56, 116, 179)
        SectionHeader.BorderSizePixel = 0
        SectionHeader.LayoutOrder = 1
        SectionHeader.Parent = MainFrame

        Instance.new("UICorner", SectionHeader).CornerRadius = UDim.new(0, 4)

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, -30, 1, 0)
        SectionLabel.Position = UDim2.new(0, 8, 0, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = sectionTitle or "Player"
        SectionLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        SectionLabel.TextSize = 14
        SectionLabel.Font = Enum.Font.SourceSans
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = SectionHeader

        local SectionChevron = Instance.new("TextButton")
        SectionChevron.Size = UDim2.new(0, 25, 1, 0)
        SectionChevron.Position = UDim2.new(1, -25, 0, 0)
        SectionChevron.BackgroundTransparency = 1
        SectionChevron.Text = "^"
        SectionChevron.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionChevron.TextSize = 11
        SectionChevron.Font = Enum.Font.SourceSansBold
        SectionChevron.Parent = SectionHeader

        -- Element Container (Controlled for Expand/Collapse functionality)
        local ElementContainer = Instance.new("Frame")
        ElementContainer.Size = UDim2.new(1, 0, 0, 0)
        ElementContainer.BackgroundTransparency = 1
        ElementContainer.ClipsDescendants = true
        ElementContainer.LayoutOrder = 2
        ElementContainer.Parent = MainFrame

        local ElementLayout = Instance.new("UIListLayout")
        ElementLayout.Padding = UDim.new(0, 3)
        ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementLayout.Parent = ElementContainer

        local function AdjustContainerHeight()
            if ContentVisible then
                ElementContainer.Size = UDim2.new(1, 0, 0, ElementLayout.AbsoluteContentSize.Y)
            else
                ElementContainer.Size = UDim2.new(1, 0, 0, 0)
            end
        end

        ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AdjustContainerHeight)

        -- Collapse / Open Actions
        local function ToggleVisibility()
            ContentVisible = not ContentVisible
            SectionChevron.Text = ContentVisible and "^" or "v"
            AdjustContainerHeight()
        end
        SectionChevron.MouseButton1Click:Connect(ToggleVisibility)
        MainChevron.MouseButton1Click:Connect(ToggleVisibility)

        local Section = {}

        local function ApplyElementStyle(frame, name)
            frame.Size = UDim2.new(1, 0, 0, 25)
            frame.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.Position = UDim2.new(0, 8, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(225, 235, 245)
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            return label
        end

        -- BUTTON
        function Section:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 25)
            Button.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            Button.BorderSizePixel = 0
            Button.Text = text or "button"
            Button.TextColor3 = Color3.fromRGB(225, 235, 245)
            Button.Font = Enum.Font.SourceSans
            Button.TextSize = 14
            Button.Parent = ElementContainer
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
            Button.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function Section:CreateToggle(text, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = ElementContainer
            ApplyElementStyle(ToggleFrame, text)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = UDim2.new(1, -20, 0, 5.5)
            Circle.BackgroundTransparency = 1
            Circle.Parent = ToggleFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(225, 235, 245)
            Stroke.Thickness = 1.5
            Stroke.Parent = Circle

            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local InnerCircle = Instance.new("Frame")
            InnerCircle.Size = UDim2.new(0, 0, 0, 0)
            InnerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
            InnerCircle.BackgroundColor3 = Color3.fromRGB(238, 108, 0)
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
                TweenService:Create(InnerCircle, TweenInfo.new(0.1), {
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
            TextBox.Size = UDim2.new(0, 55, 0, 15)
            TextBox.Position = UDim2.new(1, -63, 0, 5)
            TextBox.BackgroundColor3 = Color3.fromRGB(14, 85, 156)
            TextBox.BorderSizePixel = 0
            TextBox.Text = ""
            TextBox.ClearTextOnFocus = false
            TextBox.TextEditable = true
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.SourceSans
            TextBox.TextSize = 12
            TextBox.Active = true
            TextBox.Parent = BoxFrame
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 3)

            TextBox.FocusLost:Connect(function(enterPressed)
                callback(TextBox.Text)
            end)
        end

        -- KEYBIND
        function Section:CreateKeybind(text, default, callback)
            local BindFrame = Instance.new("Frame")
            BindFrame.Parent = ElementContainer
            ApplyElementStyle(BindFrame, text)

            local BindLabel = Instance.new("TextLabel")
            BindLabel.Size = UDim2.new(0, 30, 1, 0)
            BindLabel.Position = UDim2.new(1, -35, 0, 0)
            BindLabel.BackgroundTransparency = 1
            BindLabel.Text = default.Name
            BindLabel.TextColor3 = Color3.fromRGB(225, 235, 245)
            BindLabel.Font = Enum.Font.SourceSans
            BindLabel.TextSize = 14
            BindLabel.TextXAlignment = Enum.TextXAlignment.Right
            BindLabel.Parent = BindFrame

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
                    BindLabel.Text = input.KeyCode.Name
                    Listening = false
                    callback(input.KeyCode)
                end
            end)
        end

        -- SLIDER (Fixed, Smooth, Handles Manual Inputs with Numeric Field Custom Borders)
        function Section:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = ElementContainer
            ApplyElementStyle(SliderFrame, text)

            -- Customized Input Box Layout for Number Styling
            local ValueContainer = Instance.new("Frame")
            ValueContainer.Size = UDim2.new(0, 32, 0, 16)
            ValueContainer.Position = UDim2.new(1, -40, 0, 4)
            ValueContainer.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            ValueContainer.BackgroundTransparency = 1
            ValueContainer.Parent = SliderFrame

            local ValueBox = Instance.new("TextBox")
            ValueBox.Size = UDim2.new(1, 0, 1, 0)
            ValueBox.BackgroundTransparency = 1
            ValueBox.Text = tostring(default)
            ValueBox.TextColor3 = Color3.fromRGB(225, 235, 245)
            ValueBox.Font = Enum.Font.SourceSans
            ValueBox.TextSize = 13
            ValueBox.ClearTextOnFocus = false
            ValueBox.Parent = ValueContainer

            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = Color3.fromRGB(110, 160, 210)
            UIStroke.Thickness = 1
            UIStroke.Parent = ValueContainer
            Instance.new("UICorner", ValueContainer).CornerRadius = UDim.new(0, 3)

            local BarBG = Instance.new("Frame")
            BarBG.Size = UDim2.new(1, -50, 0, 3)
            BarBG.Position = UDim2.new(0, 8, 1, -5)
            BarBG.BackgroundColor3 = Color3.fromRGB(14, 85, 156)
            BarBG.BorderSizePixel = 0
            BarBG.Parent = SliderFrame

            local BarFill = Instance.new("Frame")
            BarFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            BarFill.BackgroundColor3 = Color3.fromRGB(238, 108, 0)
            BarFill.BorderSizePixel = 0
            BarFill.Parent = BarBG

            local Sliding = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteWidth, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                BarFill.Size = UDim2.new(pos, 0, 1, 0)
                ValueBox.Text = tostring(val)
                callback(val)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = true
                    UpdateSlider(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Sliding = false
                end
            end)

            -- Manual Input Text Filtering & Validation
            ValueBox:GetPropertyChangedSignal("Text"):Connect(function()
                ValueBox.Text = ValueBox.Text:gsub("%D+", "") -- Strips all characters that aren't digits
            end)

            ValueBox.FocusLost:Connect(function()
                local numValue = tonumber(ValueBox.Text)
                if not numValue then numValue = min end
                numValue = math.clamp(numValue, min, max)
                ValueBox.Text = tostring(numValue)
                
                local progress = (numValue - min) / (max - min)
                TweenService:Create(BarFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
                callback(numValue)
            end)
        end

        -- DROPDOWN
        function Section:CreateDropdown(text, list, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = ElementContainer
            ApplyElementStyle(DropdownFrame, text)

            local Chevron = Instance.new("TextLabel")
            Chevron.Size = UDim2.new(0, 25, 1, 0)
            Chevron.Position = UDim2.new(1, -25, 0, 0)
            Chevron.BackgroundTransparency = 1
            Chevron.Text = "v"
            Chevron.TextColor3 = Color3.fromRGB(225, 235, 245)
            Chevron.TextSize = 10
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
                ItemBtn.Size = UDim2.new(1, 0, 0, 22)
                ItemBtn.BackgroundTransparency = 1
                ItemBtn.Text = "   " .. tostring(item)
                ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                ItemBtn.Font = Enum.Font.SourceSans
                ItemBtn.TextSize = 13
                ItemBtn.Parent = ListContainer

                ItemBtn.MouseButton1Click:Connect(function()
                    DropdownFrame.TextLabel.Text = item
                    TweenService:Create(ListContainer, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    callback(item)
                end)
            end

            local expanded = false
            DropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetHeight = expanded and (#list * 22) or 0
                TweenService:Create(ListContainer, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                Chevron.Text = expanded and "^" or "v"
            end)
        end

        return Section
    end
    return Window
end

return Library
