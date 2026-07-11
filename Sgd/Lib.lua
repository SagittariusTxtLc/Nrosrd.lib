local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PerfectBorderMenuUI"
    ScreenGui.ResetOnSpawn = false
    
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Main Container Frame (Grey Background)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 220, 0, 32)
    MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150) -- Middle screen spawn
    MainFrame.BackgroundColor3 = Color3.fromRGB(185, 185, 185)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame

    -- Padding to ensure a perfect smooth border around all items inside the grey background
    local MainPadding = Instance.new("UIPadding")
    MainPadding.PaddingTop = UDim.new(0, 2)
    MainPadding.PaddingBottom = UDim.new(0, 2)
    MainPadding.PaddingLeft = UDim.new(0, 2)
    MainPadding.PaddingRight = UDim.new(0, 2)
    MainPadding.Parent = MainFrame

    -- Global Header (Dark Blue)
    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Size = UDim2.new(1, 0, 0, 28)
    MainHeader.BackgroundColor3 = Color3.fromRGB(14, 85, 156)
    MainHeader.BorderSizePixel = 0
    MainHeader.Parent = MainFrame

    Instance.new("UICorner", MainHeader).CornerRadius = UDim.new(0, 4)

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, -30, 1, 0)
    MainTitle.Position = UDim2.new(0, 8, 0, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = title or "Main"
    MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.TextSize = 13
    MainTitle.Font = Enum.Font.GothamMedium
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.Parent = MainHeader

    -- Right side toggle symbol ("v" for open, "-" for close)
    local MainMinimizeBtn = Instance.new("TextButton")
    MainMinimizeBtn.Size = UDim2.new(0, 25, 1, 0)
    MainMinimizeBtn.Position = UDim2.new(1, -25, 0, 0)
    MainMinimizeBtn.BackgroundTransparency = 1
    MainMinimizeBtn.Text = "v"
    MainMinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainMinimizeBtn.TextSize = 13
    MainMinimizeBtn.Font = Enum.Font.GothamBold
    MainMinimizeBtn.Parent = MainHeader

    -- Elements Container Box
    local Container = Instance.new("Frame")
    Container.Name = "ItemsContainer"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.Position = UDim2.new(0, 0, 0, 31)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.Parent = MainFrame

    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Padding = UDim.new(0, 3)
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Parent = Container

    -- State management variables
    local uiVisible = true
    local currentContentHeight = 0

    -- Dynamic calculation to ensure the grey border layout wraps perfectly
    local function RecalculateWindowSize()
        currentContentHeight = ContainerLayout.AbsoluteContentSize.Y
        if uiVisible then
            Container.Size = UDim2.new(1, 0, 0, currentContentHeight)
            MainFrame.Size = UDim2.new(0, 220, 0, currentContentHeight + 32)
        else
            MainFrame.Size = UDim2.new(0, 220, 0, 32)
        end
    end

    ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalculateWindowSize)

    -- Smooth Dragging System (Desktop & Mobile)
    local dragging, dragInput, dragStart, startPos
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
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)

    -- Toggle minimization handler via symbols
    MainMinimizeBtn.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        Container.Visible = uiVisible
        MainMinimizeBtn.Text = uiVisible and "v" or "-"
        
        TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = uiVisible and UDim2.new(0, 220, 0, currentContentHeight + 32) or UDim2.new(0, 220, 0, 32)
        }):Play()
    end)

    local Window = {}

    function Window:CreateSection(sectionTitle)
        local SectionHeader = Instance.new("Frame")
        SectionHeader.Size = UDim2.new(1, 0, 0, 26)
        SectionHeader.BackgroundColor3 = Color3.fromRGB(56, 116, 179)
        SectionHeader.BorderSizePixel = 0
        SectionHeader.Parent = Container

        Instance.new("UICorner", SectionHeader).CornerRadius = UDim.new(0, 4)

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, -30, 1, 0)
        SectionLabel.Position = UDim2.new(0, 8, 0, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = sectionTitle or "Section"
        SectionLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        SectionLabel.TextSize = 13
        SectionLabel.Font = Enum.Font.GothamMedium
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = SectionHeader

        local SectionChevron = Instance.new("TextButton")
        SectionChevron.Size = UDim2.new(0, 25, 1, 0)
        SectionChevron.Position = UDim2.new(1, -25, 0, 0)
        SectionChevron.BackgroundTransparency = 1
        SectionChevron.Text = "^"
        SectionChevron.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionChevron.TextSize = 11
        SectionChevron.Font = Enum.Font.GothamBold
        SectionChevron.Parent = SectionHeader

        local ElementContainer = Instance.new("Frame")
        ElementContainer.Size = UDim2.new(1, 0, 0, 0)
        ElementContainer.BackgroundTransparency = 1
        ElementContainer.ClipsDescendants = true
        ElementContainer.Parent = Container

        local ElementLayout = Instance.new("UIListLayout")
        ElementLayout.Padding = UDim.new(0, 3)
        ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementLayout.Parent = ElementContainer

        local sectionVisible = true
        local function updateSectionSize()
            ElementContainer.Size = UDim2.new(1, 0, 0, sectionVisible and ElementLayout.AbsoluteContentSize.Y or 0)
            RecalculateWindowSize()
        end
        ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)

        SectionChevron.MouseButton1Click:Connect(function()
            sectionVisible = not sectionVisible
            SectionChevron.Text = sectionVisible and "^" or "v"
            updateSectionSize()
        end)

        local Section = {}

        local function StyleRow(frame, labelText)
            frame.Size = UDim2.new(1, 0, 0, 24)
            frame.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.5, 0, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = Color3.fromRGB(225, 235, 245)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            return lbl
        end

        -- BUTTON
        function Section:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 24)
            Button.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            Button.Text = text or "button"
            Button.TextColor3 = Color3.fromRGB(225, 235, 245)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 12
            Button.Parent = ElementContainer
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
            Button.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function Section:CreateToggle(text, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = ElementContainer
            StyleRow(ToggleFrame, text)

            local Ring = Instance.new("Frame")
            Ring.Size = UDim2.new(0, 13, 0, 13)
            Ring.Position = UDim2.new(1, -20, 0, 5)
            Ring.BackgroundTransparency = 1
            Ring.Parent = ToggleFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(225, 235, 245)
            Stroke.Thickness = 1.5
            Stroke.Parent = Ring
            Instance.new("UICorner", Ring).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 0, 0, 0)
            Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
            Dot.BackgroundColor3 = Color3.fromRGB(238, 108, 0)
            Dot.Parent = Ring
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local HitBtn = Instance.new("TextButton")
            HitBtn.Size = UDim2.new(1, 0, 1, 0)
            HitBtn.BackgroundTransparency = 1
            HitBtn.Text = ""
            HitBtn.Parent = ToggleFrame

            local enabled = false
            HitBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                TweenService:Create(Dot, TweenInfo.new(0.1), {
                    Size = enabled and UDim2.new(0, 7, 0, 7) or UDim2.new(0, 0, 0, 0),
                    Position = enabled and UDim2.new(0.5, -3.5, 0.5, -3.5) or UDim2.new(0.5, 0, 0.5, 0)
                }):Play()
                callback(enabled)
            end)
        end

        -- TEXTBOX
        function Section:CreateTextBox(text, callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Parent = ElementContainer
            StyleRow(BoxFrame, text)

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0, 55, 0, 14)
            TextBox.Position = UDim2.new(1, -63, 0, 5)
            TextBox.BackgroundColor3 = Color3.fromRGB(14, 85, 156)
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 11
            TextBox.ClearTextOnFocus = false
            TextBox.TextEditable = true
            TextBox.Parent = BoxFrame
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 3)

            TextBox.FocusLost:Connect(function()
                callback(TextBox.Text)
            end)
        end

        -- KEYBIND
        function Section:CreateKeybind(text, default, callback)
            local BindFrame = Instance.new("Frame")
            BindFrame.Parent = ElementContainer
            StyleRow(BindFrame, text)

            local BindLbl = Instance.new("TextLabel")
            BindLbl.Size = UDim2.new(0, 40, 1, 0)
            BindLbl.Position = UDim2.new(1, -45, 0, 0)
            BindLbl.BackgroundTransparency = 1
            BindLbl.Text = default.Name
            BindLbl.TextColor3 = Color3.fromRGB(225, 235, 245)
            BindLbl.Font = Enum.Font.Gotham
            BindLbl.TextSize = 12
            BindLbl.TextXAlignment = Enum.TextXAlignment.Right
            BindLbl.Parent = BindFrame

            local listening = false
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.Parent = BindFrame

            Btn.MouseButton1Click:Connect(function()
                listening = true
                BindLbl.Text = "..."
            end)

            UIS.InputBegan:Connect(function(input)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    BindLbl.Text = input.KeyCode.Name
                    callback(input.KeyCode)
                end
            end)
        end

        -- SLIDER
        function Section:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = ElementContainer
            StyleRow(SliderFrame, text)

            local InputContainer = Instance.new("Frame")
            InputContainer.Size = UDim2.new(0, 32, 0, 15)
            InputContainer.Position = UDim2.new(1, -40, 0, 4)
            InputContainer.BackgroundColor3 = Color3.fromRGB(74, 126, 175)
            InputContainer.Parent = SliderFrame

            local OutLine = Instance.new("UIStroke")
            OutLine.Color = Color3.fromRGB(110, 160, 210)
            OutLine.Thickness = 1
            OutLine.Parent = InputContainer
            Instance.new("UICorner", InputContainer).CornerRadius = UDim.new(0, 3)

            local ValueBox = Instance.new("TextBox")
            ValueBox.Size = UDim2.new(1, 0, 1, 0)
            ValueBox.BackgroundTransparency = 1
            ValueBox.Text = tostring(default)
            ValueBox.TextColor3 = Color3.fromRGB(225, 235, 245)
            ValueBox.Font = Enum.Font.Gotham
            ValueBox.TextSize = 11
            ValueBox.ClearTextOnFocus = false
            ValueBox.Parent = InputContainer

            local TrackBG = Instance.new("Frame")
            TrackBG.Size = UDim2.new(1, -50, 0, 3)
            TrackBG.Position = UDim2.new(0, 8, 1, -5)
            TrackBG.BackgroundColor3 = Color3.fromRGB(14, 85, 156)
            TrackBG.BorderSizePixel = 0
            TrackBG.Parent = SliderFrame

            local TrackFill = Instance.new("Frame")
            TrackFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            TrackFill.BackgroundColor3 = Color3.fromRGB(238, 108, 0)
            TrackFill.BorderSizePixel = 0
            TrackFill.Parent = TrackBG

            local SliderKnob = Instance.new("Frame")
            SliderKnob.Size = UDim2.new(0, 7, 0, 7)
            SliderKnob.Position = UDim2.new(1, -3, 0.5, -3.5)
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Parent = TrackFill
            Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

            local active = false
            local function move(input)
                local ratio = math.clamp((input.Position.X - TrackBG.AbsolutePosition.X) / TrackBG.AbsoluteWidth, 0, 1)
                local val = math.floor(min + (max - min) * ratio)
                TrackFill.Size = UDim2.new(ratio, 0, 1, 0)
                ValueBox.Text = tostring(val)
                callback(val)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    active = true
                    move(input)
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    move(input)
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    active = false
                end
            end)

            ValueBox:GetPropertyChangedSignal("Text"):Connect(function()
                ValueBox.Text = ValueBox.Text:gsub("%D+", "")
            end)
            ValueBox.FocusLost:Connect(function()
                local num = tonumber(ValueBox.Text) or min
                num = math.clamp(num, min, max)
                ValueBox.Text = tostring(num)
                TweenService:Create(TrackFill, TweenInfo.new(0.1), {Size = UDim2.new((num - min) / (max - min), 0, 1, 0)}):Play()
                callback(num)
            end)
        end

        -- DROPDOWN
        function Section:CreateDropdown(text, list, callback)
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = ElementContainer
            StyleRow(DropFrame, text)

            local Chev = Instance.new("TextLabel")
            Chev.Size = UDim2.new(0, 25, 1, 0)
            Chev.Position = UDim2.new(1, -25, 0, 0)
            Chev.BackgroundTransparency = 1
            Chev.Text = "v"
            Chev.TextColor3 = Color3.fromRGB(225, 235, 245)
            Chev.TextSize = 10
            Chev.Font = Enum.Font.GothamBold
            Chev.Parent = DropFrame

            local ListFrame = Instance.new("Frame")
            ListFrame.Size = UDim2.new(1, 0, 0, 0)
            ListFrame.BackgroundColor3 = Color3.fromRGB(64, 114, 160)
            ListFrame.BorderSizePixel = 0
            ListFrame.ClipsDescendants = true
            ListFrame.Parent = ElementContainer
            Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 4)

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = ListFrame

            for _, choice in pairs(list) do
                local Item = Instance.new("TextButton")
                Item.Size = UDim2.new(1, 0, 0, 20)
                Item.BackgroundTransparency = 1
                Item.Text = "   " .. tostring(choice)
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextXAlignment = Enum.TextXAlignment.Left
                Item.Font = Enum.Font.Gotham
                Item.TextSize = 11
                Item.Parent = ListFrame

                Item.MouseButton1Click:Connect(function()
                    DropFrame.TextLabel.Text = choice
                    TweenService:Create(ListFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    RecalculateWindowSize()
                    callback(choice)
                end)
            end

            local open = false
            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = DropFrame

            Trigger.MouseButton1Click:Connect(function()
                open = not open
                local tween = TweenService:Create(ListFrame, TweenInfo.new(0.12), {Size = open and UDim2.new(1, 0, 0, #list * 20) or UDim2.new(1, 0, 0, 0)})
                tween:Play()
                
                local connection
                connection = ListFrame:GetPropertyChangedSignal("Size"):Connect(RecalculateWindowSize)
                tween.Completed:Connect(function()
                    connection:Disconnect()
                    RecalculateWindowSize()
                end)
                
                Chev.Text = open and "^" or "v"
            end)
        end

        return Section
    end
    return Window
end

return Library
