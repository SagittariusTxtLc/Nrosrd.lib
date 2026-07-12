local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {}

-- Draggable Engine
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- Item Container Factory (Uniform background and sharp border stroke)
local function CreateItemContainer(parent, height)
    local ContainerFrame = Instance.new("Frame", parent)
    ContainerFrame.Size = UDim2.new(1, 0, 0, height)
    ContainerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContainerFrame.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner", ContainerFrame)
    Corner.CornerRadius = UDim.new(0, 4)
    
    local Stroke = Instance.new("UIStroke", ContainerFrame)
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    return ContainerFrame
end

function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 260, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.BorderSizePixel = 0
    MakeDraggable(MainFrame)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    
    local HeaderFrame = Instance.new("Frame", MainFrame)
    HeaderFrame.Size = UDim2.new(1, 0, 0, 35)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    HeaderFrame.BorderSizePixel = 0
    
    local HeaderCorner = Instance.new("UICorner", HeaderFrame)
    HeaderCorner.CornerRadius = UDim.new(0, 4)
    
    local CornerMask = Instance.new("Frame", HeaderFrame)
    CornerMask.Size = UDim2.new(1, 0, 0, 4)
    CornerMask.Position = UDim2.new(0, 0, 1, -4)
    CornerMask.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    CornerMask.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", HeaderFrame)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "  " .. titleText
    Title.TextColor3 = Color3.fromRGB(245, 245, 245)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    
    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -16, 1, -47)
    Container.Position = UDim2.new(0, 8, 0, 41)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 2)
    end)
    
    local Elements = {}
    
    function Elements:Button(text, callback)
        local Item = CreateItemContainer(Container, 32)
        
        local Btn = Instance.new("TextButton", Item)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1
        Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        Btn.Text = text
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextYAlignment = Enum.TextYAlignment.Center
        
        Btn.MouseButton1Click:Connect(callback)
    end
    
    function Elements:Toggle(text, default, callback)
        local Enabled = default or false
        local Item = CreateItemContainer(Container, 32)
        
        local TglBtn = Instance.new("TextButton", Item)
        TglBtn.Size = UDim2.new(1, 0, 1, 0)
        TglBtn.BackgroundTransparency = 1
        TglBtn.Text = "  " .. text
        TglBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
        TglBtn.Font = Enum.Font.SourceSans
        TglBtn.TextSize = 13
        TglBtn.TextXAlignment = Enum.TextXAlignment.Left
        TglBtn.TextYAlignment = Enum.TextYAlignment.Center
        
        local Indicator = Instance.new("Frame", Item)
        Indicator.Size = UDim2.new(0, 12, 0, 12)
        Indicator.Position = UDim2.new(1, -20, 0.5, -6) -- Absolute Center Anchor
        Indicator.BackgroundColor3 = Enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 3)
        
        TglBtn.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            TweenService:Create(Indicator, TweenInfo.new(0.08), {BackgroundColor3 = Enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)}):Play()
            callback(Enabled)
        end)
    end
    
    function Elements:Slider(text, min, max, default, callback)
        local Item = CreateItemContainer(Container, 42)
        
        local Label = Instance.new("TextLabel", Item)
        Label.Size = UDim2.new(1, -12, 0, 18)
        Label.Position = UDim2.new(0, 8, 0, 3)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Center
        Label.Font = Enum.Font.SourceSans
        Label.TextSize = 12
        
        local Track = Instance.new("TextButton", Item)
        Track.Size = UDim2.new(1, -16, 0, 4)
        Track.Position = UDim2.new(0, 8, 0, 28)
        Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Track.Text = ""
        Instance.new("UICorner", Track)
        
        local Fill = Instance.new("Frame", Track)
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        Instance.new("UICorner", Fill)
        
        local function UpdateSlider(input)
            local percentage = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteWidth, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            Fill.Size = UDim2.new(percentage, 0, 1, 0)
            Label.Text = text .. ": " .. value
            callback(value)
        end
        
        local sliding = false
        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true UpdateSlider(input) end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)
    end
    
    function Elements:TextBox(placeholder, callback)
        local Item = CreateItemContainer(Container, 32)
        
        local Box = Instance.new("TextBox", Item)
        Box.Size = UDim2.new(1, -10, 1, 0)
        Box.Position = UDim2.new(0, 5, 0, 0)
        Box.BackgroundTransparency = 1
        Box.TextColor3 = Color3.fromRGB(235, 235, 235)
        Box.PlaceholderText = placeholder
        Box.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
        Box.Text = ""
        Box.Font = Enum.Font.SourceSans
        Box.TextSize = 13
        Box.TextYAlignment = Enum.TextYAlignment.Center
        
        Box.FocusLost:Connect(function(enterPressed)
            callback(Box.Text, enterPressed)
        end)
    end
    
    function Elements:Dropdown(text, options, callback)
        local Expanded = false
        local Item = CreateItemContainer(Container, 32)
        Item.ClipsDescendants = true
        
        local MainBtn = Instance.new("TextButton", Item)
        MainBtn.Size = UDim2.new(1, 0, 0, 32)
        MainBtn.BackgroundTransparency = 1
        MainBtn.Text = "  " .. text
        MainBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
        MainBtn.TextXAlignment = Enum.TextXAlignment.Left
        MainBtn.TextYAlignment = Enum.TextYAlignment.Center
        MainBtn.Font = Enum.Font.SourceSans
        MainBtn.TextSize = 13
        
        local OptList = Instance.new("Frame", Item)
        OptList.Size = UDim2.new(1, -12, 1, -38)
        OptList.Position = UDim2.new(0, 6, 0, 35)
        OptList.BackgroundTransparency = 1
        
        local OptLayout = Instance.new("UIListLayout", OptList)
        OptLayout.Padding = UDim.new(0, 3)
        
        for _, opt in ipairs(options) do
            local OptBtn = Instance.new("TextButton", OptList)
            OptBtn.Size = UDim2.new(1, 0, 0, 24)
            OptBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            OptBtn.Text = opt
            OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptBtn.Font = Enum.Font.SourceSans
            OptBtn.TextSize = 12
            OptBtn.TextYAlignment = Enum.TextYAlignment.Center
            Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 3)
            
            local OptStroke = Instance.new("UIStroke", OptBtn)
            OptStroke.Thickness = 1
            OptStroke.Color = Color3.fromRGB(50, 50, 50)
            
            OptBtn.MouseButton1Click:Connect(function()
                MainBtn.Text = "  " .. text .. " (" .. opt .. ")"
                Expanded = false
                TweenService:Create(Item, TweenInfo.new(0.10), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                callback(opt)
            end)
        end
        
        MainBtn.MouseButton1Click:Connect(function()
            Expanded = not Expanded
            local targetHeight = Expanded and (36 + (#options * 27)) or 32
            TweenService:Create(Item, TweenInfo.new(0.10), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
        end)
    end

    return Elements
end

return Library
