-- MyUILib.lua (v2 - tabs + fixed dropdown)
local UILib = {}
UILib.__index = UILib

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

function UILib.new(title)
    local self = setmetatable({}, UILib)

    self.ScreenGui = create("ScreenGui", {
        Name = "MyUILib",
        ResetOnSpawn = false,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })

    self.Main = create("Frame", {
        Size = UDim2.new(0, 320, 0, 450),
        Position = UDim2.new(0.5, -160, 0.5, -225),
        BackgroundColor3 = Color3.fromRGB(45, 45, 60),
        Parent = self.ScreenGui
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.Main})

    self.TitleBar = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
        Text = "",
        AutoButtonColor = false,
        Parent = self.Main
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.TitleBar})
    create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Main",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    local collapseArrow = create("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -35, 0, 0),
        BackgroundTransparency = 1,
        Text = "^",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = self.TitleBar
    })

    self.Body = create("Frame", {
        Size = UDim2.new(1, -10, 1, -50),
        Position = UDim2.new(0, 5, 0, 45),
        BackgroundTransparency = 1,
        Parent = self.Main
    })
    create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = self.Body
    })

    local bodyVisible = true
    self.TitleBar.MouseButton1Click:Connect(function()
        bodyVisible = not bodyVisible
        self.Body.Visible = bodyVisible
        collapseArrow.Text = bodyVisible and "^" or "v"
        self.Main.Size = bodyVisible and UDim2.new(0,320,0,450) or UDim2.new(0,320,0,40)
    end)

    -- drag support
    local dragging, dragStart, startPos
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return self
end

function UILib:Tab(name)
    local tab = {}

    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(60, 60, 90),
        Text = "",
        AutoButtonColor = false,
        Parent = self.Body
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = header})
    create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    local arrow = create("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -35, 0, 0),
        BackgroundTransparency = 1,
        Text = "^",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = header
    })

    local content = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Body
    })
    create("UIListLayout", {Padding = UDim.new(0, 6), Parent = content})

    local expanded = true
    header.MouseButton1Click:Connect(function()
        expanded = not expanded
        content.Visible = expanded
        arrow.Text = expanded and "^" or "v"
    end)

    tab.Container = content
    setmetatable(tab, {__index = UILib})
    return tab
end

local function baseRow(parent, height)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, height or 34),
        BackgroundColor3 = Color3.fromRGB(60, 60, 80),
        Parent = parent
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = row})
    return row
end

function UILib:Button(text, callback)
    local row = baseRow(self.Container or self.Body)
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = row
    })
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

function UILib:Toggle(text, default, callback)
    local row = baseRow(self.Container or self.Body)
    create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = row
    })
    local state = default or false
    local circle = create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        BackgroundColor3 = state and Color3.fromRGB(80,180,100) or Color3.fromRGB(100,100,100),
        Text = "",
        Parent = row
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
    circle.MouseButton1Click:Connect(function()
        state = not state
        circle.BackgroundColor3 = state and Color3.fromRGB(80,180,100) or Color3.fromRGB(100,100,100)
        if callback then callback(state) end
    end)
    return {Set = function(v) state = v; circle.BackgroundColor3 = v and Color3.fromRGB(80,180,100) or Color3.fromRGB(100,100,100) end}
end

function UILib:TextBox(placeholder, callback)
    local row = baseRow(self.Container or self.Body)
    local box = create("TextBox", {
        Size = UDim2.new(1, -20, 1, -8),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
        PlaceholderText = placeholder or "",
        Text = "",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        ClearTextOnFocus = false,
        Parent = row
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box})
    box.FocusLost:Connect(function(enterPressed)
        if callback then callback(box.Text, enterPressed) end
    end)
    return box
end

function UILib:Keybind(text, defaultKey, callback)
    local row = baseRow(self.Container or self.Body)
    create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = row
    })
    local currentKey = defaultKey or Enum.KeyCode.None
    local keyBtn = create("TextButton", {
        Size = UDim2.new(0, 60, 0, 24),
        Position = UDim2.new(1, -70, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(35,35,50),
        Text = currentKey.Name,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = row
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = keyBtn})

    local listening = false
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
    end)
    UIS.InputBegan:Connect(function(input, gpe)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            keyBtn.Text = currentKey.Name
            listening = false
        elseif not gpe and input.KeyCode == currentKey then
            if callback then callback() end
        end
    end)
    return keyBtn
end

function UILib:Dropdown(text, options, callback)
    local row = baseRow(self.Container or self.Body, 34)
    local label = create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = row
    })
    local arrow = create("TextLabel", {
        Size = UDim2.new(0, 25, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = row
    })
    local list = create("Frame", {
        Size = UDim2.new(1, 0, 0, #options * 26),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Color3.fromRGB(35,35,50),
        Visible = false,
        ZIndex = 5,
        Parent = row
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = list})
    create("UIListLayout", {Parent = list})

    local open = false
    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            Text = tostring(opt),
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            ZIndex = 5,
            Parent = list
        })
        optBtn.MouseButton1Click:Connect(function()
            label.Text = text .. ": " .. tostring(opt)
            list.Visible = false
            open = false
            arrow.Text = "v"
            if callback then callback(opt) end
        end)
    end

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            open = not open
            list.Visible = open
            arrow.Text = open and "^" or "v"
        end
    end)
    return list
end

return UILib
