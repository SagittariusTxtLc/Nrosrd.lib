local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {}

-- Smooth Dragging Implementation
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
            TweenService:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

-- URL Execution Handler (Converts and executes Pastebin/GitHub links)
function Library:ExecuteLink(url)
    if not url or url == "" then return end
    
    -- Format GitHub standard links to raw
    if string.find(url, "github.com") and not string.find(url, "raw.githubusercontent.com") then
        url = string.gsub(url, "github.com", "raw.githubusercontent.com")
        url = string.gsub(url, "/blob/", "/")
    end
    -- Format Pastebin standard links to raw
    if string.find(url, "pastebin.com") and not string.find(url, "/raw/") then
        url = string.gsub(url, "pastebin.com/", "pastebin.com/raw/")
    end

    local success, content = pcall(function() return game:HttpGet(url) end)
    if success then
        local func, err = loadstring(content)
        if func then 
            task.spawn(func) 
        else 
            warn("Loadstring failed: " .. tostring(err)) 
        end
    else
        warn("HttpGet failed: " .. tostring(content))
    end
end

-- Window Construction
function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 280, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MakeDraggable(MainFrame)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundTransparency = 1
    Title.Text = "  " .. titleText
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 15
    
    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -16, 1, -45)
    Container.Position = UDim2.new(0, 8, 0, 35)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ScrollBarThickness = 3
    Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    local Elements = {}
    
    -- TextBox configured specifically to handle URL execution inputs
    function Elements:LinkExecutor()
        local Box = Instance.new("TextBox", Container)
        Box.Size = UDim2.new(1, 0, 0, 32)
        Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.PlaceholderText = "Paste Pastebin / GitHub link here..."
        Box.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
        Box.Text = ""
        Box.Font = Enum.Font.SourceSans
        Box.TextSize = 13
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
        
        Box.FocusLost:Connect(function(enterPressed)
            if enterPressed and Box.Text ~= "" then
                local url = Box.Text
                Box.Text = "Executing Link..."
                Library:ExecuteLink(url)
                task.wait(1)
                Box.Text = ""
            end
        end)
    end

    function Elements:Button(text, callback)
        local Btn = Instance.new("TextButton", Container)
        Btn.Size = UDim2.new(1, 0, 0, 28)
        Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        Btn.Text = text
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        Btn.MouseButton1Click:Connect(callback)
    end
    
    function Elements:Toggle(text, default, callback)
        local Enabled = default or false
        local TglFrame = Instance.new("TextButton", Container)
        TglFrame.Size = UDim2.new(1, 0, 0, 28)
        TglFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        TglFrame.Text = "  " .. text
        TglFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
        TglFrame.Font = Enum.Font.SourceSans
        TglFrame.TextSize = 13
        TglFrame.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 4)
        
        local Indicator = Instance.new("Frame", TglFrame)
        Indicator.Size = UDim2.new(0, 14, 0, 14)
        Indicator.Position = UDim2.new(1, -20, 0, 7)
        Indicator.BackgroundColor3 = Enabled and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(55, 55, 55)
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 3)
        
        TglFrame.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            TweenService:Create(Indicator, TweenInfo.new(0.1), {BackgroundColor3 = Enabled and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(55, 55, 55)}):Play()
            callback(Enabled)
        end)
    end
    
    function Elements:Slider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame", Container)
        SliderFrame.Size = UDim2.new(1, 0, 0, 38)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)
        
        local Label = Instance.new("TextLabel", SliderFrame)
        Label.Size = UDim2.new(1, -10, 0, 18)
        Label.Position = UDim2.new(0, 6, 0, 2)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.SourceSans
        Label.TextSize = 12
        
        local Track = Instance.new("TextButton", SliderFrame)
        Track.Size = UDim2.new(1, -12, 0, 5)
        Track.Position = UDim2.new(0, 6, 0, 24)
        Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Track.Text = ""
        Instance.new("UICorner", Track)
        
        local Fill = Instance.new("Frame", Track)
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
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
        local Box = Instance.new("TextBox", Container)
        Box.Size = UDim2.new(1, 0, 0, 28)
        Box.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        Box.TextColor3 = Color3.fromRGB(230, 230, 230)
        Box.PlaceholderText = placeholder
        Box.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
        Box.Text = ""
        Box.Font = Enum.Font.SourceSans
        Box.TextSize = 13
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
        
        Box.FocusLost:Connect(function(enterPressed)
            callback(Box.Text, enterPressed)
        end)
    end
    
    function Elements:Dropdown(text, options, callback)
        local Expanded = false
        local DropFrame = Instance.new("Frame", Container)
        DropFrame.Size = UDim2.new(1, 0, 0, 28)
        DropFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        DropFrame.ClipsDescendants = true
        Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4)
        
        local MainBtn = Instance.new("TextButton", DropFrame)
        MainBtn.Size = UDim2.new(1, 0, 0, 28)
        MainBtn.BackgroundTransparency = 1
        MainBtn.Text = "  " .. text
        MainBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
        MainBtn.TextXAlignment = Enum.TextXAlignment.Left
        MainBtn.Font = Enum.Font.SourceSans
        MainBtn.TextSize = 13
        
        local OptList = Instance.new("Frame", DropFrame)
        OptList.Size = UDim2.new(1, 0, 1, -28)
        OptList.Position = UDim2.new(0, 0, 0, 28)
        OptList.BackgroundTransparency = 1
        
        local OptLayout = Instance.new("UIListLayout", OptList)
        OptLayout.Padding = UDim.new(0, 2)
        
        for _, opt in ipairs(options) do
            local OptBtn = Instance.new("TextButton", OptList)
            OptBtn.Size = UDim2.new(1, 0, 0, 24)
            OptBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            OptBtn.Text = opt
            OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptBtn.Font = Enum.Font.SourceSans
            OptBtn.TextSize = 12
            Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 3)
            
            OptBtn.MouseButton1Click:Connect(function()
                MainBtn.Text = "  " .. text .. " (" .. opt .. ")"
                Expanded = false
                TweenService:Create(DropFrame, TweenInfo.new(0.12), {Size = UDim2.new(1, 0, 0, 28)}):Play()
                callback(opt)
            end)
        end
        
        MainBtn.MouseButton1Click:Connect(function()
            Expanded = not Expanded
            local targetHeight = Expanded and (28 + (#options * 26)) or 28
            TweenService:Create(DropFrame, TweenInfo.new(0.12), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
        end)
    end

    return Elements
end

return Library
