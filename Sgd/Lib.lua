local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local player       = Players.LocalPlayer

-- ANTI-DUPE
do
	local pg = player:WaitForChild("PlayerGui")
	local ex = pg:FindFirstChild("4557HubGui")
	if ex then ex:Destroy() end
	if _G["4557Running"] then
		_G["4557Running"] = false
		if _G["4557Connection"] then
			_G["4557Connection"]:Disconnect()
			_G["4557Connection"] = nil
		end
	end
	_G["4557Running"] = true
end

local Lib   = {}
Lib.__index = Lib

local _gui = Instance.new("ScreenGui")
_gui.Name           = "4557HubGui"
_gui.ResetOnSpawn   = false
_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_gui.Parent         = player.PlayerGui

local WIN_W             = 220
local WIN_MAR           = 15
local WIN_Y             = 10
local TITLE_H           = 40
local MAX_ITEMS_VISIBLE = 4
local ITEM_H            = 55
local MAX_WIN_H         = TITLE_H + (ITEM_H * MAX_ITEMS_VISIBLE) + 16

local _windows     = {}
local _loaded      = false
local _pendingShow = {}
local _flags       = {}

local function _corner(obj, r)
	local c = Instance.new("UICorner", obj)
	c.CornerRadius = UDim.new(0, r or 6)
end

local function _stroke(obj, color, thick)
	local s = Instance.new("UIStroke", obj)
	s.Color     = color or Color3.fromRGB(50,50,50)
	s.Thickness = thick or 1
end

local function _style(obj)
	_corner(obj); _stroke(obj)
end

local function _tween(obj, t, props)
	TweenService:Create(obj,
		TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		props
	):Play()
end

local function _clampFrame(frame)
	local sc  = workspace.CurrentCamera.ViewportSize
	local pos = frame.Position
	local x   = math.clamp(pos.X.Offset, 0, math.max(0, sc.X - frame.AbsoluteSize.X))
	local y   = math.clamp(pos.Y.Offset, 0, math.max(0, sc.Y - frame.AbsoluteSize.Y))
	if x ~= pos.X.Offset or y ~= pos.Y.Offset then
		frame.Position = UDim2.new(0, x, 0, y)
	end
end

local function _reposition()
	local vis = {}
	for _, w in ipairs(_windows) do
		if w.shown then table.insert(vis, w.frame) end
	end
	local n = #vis
	if n == 0 then return end
	local cam = workspace.CurrentCamera.ViewportSize
	local sw, sh = cam.X, cam.Y
	local pos = {}
	if n == 1 then
		pos = { (sw / 2) - (WIN_W / 2) }
	elseif n == 2 then
		pos = { WIN_MAR, sw - WIN_W - WIN_MAR }
	else
		local gap = math.max((sw - WIN_MAR*2 - WIN_W*n) / (n-1), WIN_MAR)
		for i = 1, n do pos[i] = WIN_MAR + (i-1)*(WIN_W + gap) end
	end
	for i, frame in ipairs(vis) do
		local x = math.clamp(pos[i] or WIN_MAR, 0, sw - WIN_W)
		-- Center vertically on screen (falls back to WIN_Y margin if the window is taller than the screen)
		local y = math.max(WIN_Y, (sh / 2) - (frame.AbsoluteSize.Y / 2))
		_tween(frame, 0.35, { Position = UDim2.new(0, x, 0, y) })
	end
end

function Lib:GetFlag(flag)
	return _flags[flag]
end

function Lib:CreateWindow(title)

	local winData = { shown = false }
	table.insert(_windows, winData)

	local frame = Instance.new("Frame")
	frame.Size             = UDim2.new(0, WIN_W, 0, TITLE_H)
	frame.Position = UDim2.new(
		0, (workspace.CurrentCamera.ViewportSize.X / 2) - (WIN_W / 2),
		0, (workspace.CurrentCamera.ViewportSize.Y / 2) - (TITLE_H / 2)
	)
	frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	frame.ClipsDescendants = true
	frame.Active           = true
	frame.Visible          = false
	frame.ZIndex           = 10
	frame.Parent           = _gui
	_corner(frame)
	-- NOTE: no stroke on the whole frame anymore (removes the flat black outline).
	-- Only the header (titleBar) gets a border, and it's an animated/smooth one (see below).
	winData.frame = frame

	local titleBar = Instance.new("TextLabel")
	titleBar.Size             = UDim2.new(1,0,0,TITLE_H)
	titleBar.Text             = string.upper(title or "Window")
	titleBar.Font             = Enum.Font.LuckiestGuy
	titleBar.TextSize         = 16
	titleBar.TextColor3       = Color3.new(1,1,1)
	titleBar.BackgroundColor3 = Color3.fromRGB(16,16,16) -- lighter than the body so the drag handle is visible
	titleBar.Active           = true
	titleBar.ZIndex           = 12
	titleBar.Parent           = frame
	_corner(titleBar)

	-- Smooth animated border around the HEADER only (not the whole GUI)
	local headerStroke = Instance.new("UIStroke")
	headerStroke.Name         = "HeaderGlow"
	headerStroke.Color        = Color3.fromRGB(255,65,65)
	headerStroke.Thickness    = 1.3
	headerStroke.Transparency = 0.35
	headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	headerStroke.Parent       = titleBar
	TweenService:Create(
		headerStroke,
		TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ Transparency = 0.85 }
	):Play()

	local colBtn = Instance.new("TextButton")
	colBtn.Size               = UDim2.new(0,30,0,30)
	colBtn.Position           = UDim2.new(1,-35,0.5,-15)
	colBtn.Text               = " "
	colBtn.BackgroundTransparency = 1
	colBtn.Font               = Enum.Font.GothamBold
	colBtn.TextSize           = 20
	colBtn.TextColor3         = Color3.new(1,1,1)
	colBtn.Parent             = titleBar

	-- FIXED BOTTOM LABEL
	local bottomLabel = Instance.new("TextLabel")
bottomLabel.Size                   = UDim2.new(1,0,0,0)
bottomLabel.AnchorPoint            = Vector2.new(0,1)
bottomLabel.Position               = UDim2.new(0,0,1,0)
bottomLabel.BackgroundColor3       = Color3.fromRGB(0,0,0)  -- same as title
bottomLabel.BackgroundTransparency = 0
bottomLabel.TextColor3             = Color3.fromRGB(255,255,255)
bottomLabel.Font                   = Enum.Font.GothamBlack  -- same as title
bottomLabel.TextSize               = 16                      -- same as title
bottomLabel.Text                   = ""
bottomLabel.Visible                = false
bottomLabel.ZIndex                 = 11
bottomLabel.Parent                 = frame

-- Rounded same as GUI
local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0,6)
labelCorner.Parent       = bottomLabel

-- Top divider line
local line = Instance.new("Frame")
line.Size             = UDim2.new(1,0,0,1)
line.Position         = UDim2.new(0,0,0,0)
line.BackgroundColor3 = Color3.fromRGB(0,0,0)
line.BorderSizePixel  = 0
line.Parent           = bottomLabel

	local scrollH = MAX_WIN_H - TITLE_H

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size                 = UDim2.new(1,-4,0, scrollH)
	scroll.Position             = UDim2.new(0,0,0, TITLE_H)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness   = 0
	scroll.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
	scroll.CanvasSize           = UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
    scroll.ScrollingDirection   = Enum.ScrollingDirection.Y
	scroll.Parent               = frame

	local layout = Instance.new("UIListLayout")
	layout.Padding   = UDim.new(0,6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent    = scroll

	local pad = Instance.new("UIPadding")
	pad.PaddingTop    = UDim.new(0,5)
	pad.PaddingBottom = UDim.new(0,5)
	pad.PaddingLeft   = UDim.new(0,5)
	pad.PaddingRight  = UDim.new(0,5)
	pad.Parent        = scroll

	local collapsed   = false
	local contentH    = 0
	local labelH      = 0

	local function updateCanvas()
		task.defer(function()
			contentH = layout.AbsoluteContentSize.Y + 10
			if collapsed then return end
			local overflow = (contentH + TITLE_H + labelH) > MAX_WIN_H
			scroll.ScrollBarThickness = 0
			local targetH = math.clamp(contentH + TITLE_H + labelH, TITLE_H + 40, MAX_WIN_H)
			frame.Size = UDim2.new(0, WIN_W, 0, targetH)
		end)
	end

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

	colBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        colBtn.Text = " "
        -- show title + label only
        _tween(frame, 0.25, { Size = UDim2.new(0, WIN_W, 0, TITLE_H + labelH) })
    else
        colBtn.Text = " "
        -- show everything
        local targetH = math.clamp(contentH + TITLE_H + labelH, TITLE_H + 40, MAX_WIN_H)
        _tween(frame, 0.25, { Size = UDim2.new(0, WIN_W, 0, targetH) })
    end
end)

	local dragging  = false
	local dragInput = nil   -- the exact InputObject (finger/mouse) that started the drag
	local dragStart = nil
	local startPos  = nil
	local targetPos = nil

	titleBar.InputBegan:Connect(function(i)
		if dragging then return end -- already being dragged by another finger, ignore new touches (mistouch fix)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragInput = i
			dragStart = i.Position
			startPos  = frame.Position
			targetPos = frame.Position
		end
	end)

	-- Only the SAME InputObject that began the drag is allowed to move the frame.
	-- This is what stops a second finger touching elsewhere from hijacking/dragging the GUI.
	UIS.InputChanged:Connect(function(i)
		if not dragging or i ~= dragInput then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement
		or i.UserInputType == Enum.UserInputType.Touch then
			local sc    = workspace.CurrentCamera.ViewportSize
			local delta = i.Position - dragStart
			local newX  = math.clamp(startPos.X.Offset + delta.X, 0, math.max(0, sc.X - frame.AbsoluteSize.X))
			local newY  = math.clamp(startPos.Y.Offset + delta.Y, 0, math.max(0, sc.Y - frame.AbsoluteSize.Y))
			targetPos   = UDim2.new(0, newX, 0, newY)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if dragging and i == dragInput then
			dragging  = false
			dragInput = nil
			_clampFrame(frame)
		end
	end)

	-- Smooth follow: the frame glides toward targetPos instead of snapping instantly (Smooth Draggable)
	RunService.RenderStepped:Connect(function(dt)
		if not dragging or not targetPos then return end
		local curr = frame.Position
		local a = 1 - math.exp(-dt * 16) -- frame-rate independent smoothing factor
		frame.Position = UDim2.new(
			curr.X.Scale, curr.X.Offset + (targetPos.X.Offset - curr.X.Offset) * a,
			curr.Y.Scale, curr.Y.Offset + (targetPos.Y.Offset - curr.Y.Offset) * a
		)
	end)

	if _loaded then
		winData.shown = true; frame.Visible = true; _reposition()
	else
		table.insert(_pendingShow, function()
			winData.shown = true; frame.Visible = true
		end)
	end

	local Win    = {}
	local _order = 0
	local function nxt() _order += 1; return _order end

	function Win:SetTitle(text)    titleBar.Text = string.upper(text or "Window") end
	function Win:SetPosition(x, y) frame.Position = UDim2.new(0, x, 0, y) end

	function Win:SetLabel(text)
    labelH               = TITLE_H  -- same height as title!
    bottomLabel.Size     = UDim2.new(1,0,0,TITLE_H)
    bottomLabel.Text     = text or ""
    bottomLabel.Visible  = true

    -- Smooth fade in
    bottomLabel.BackgroundTransparency = 1
    TweenService:Create(bottomLabel,
        TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { BackgroundTransparency = 0 }
    ):Play()

    scroll.Size = UDim2.new(1,0,0, MAX_WIN_H - TITLE_H - TITLE_H)
    updateCanvas()
end

	function Win:Destroy()
		frame:Destroy()
		for i, w in ipairs(_windows) do
			if w.frame == frame then
				table.remove(_windows, i)
				break
			end
		end
		_reposition()
	end

	function Win:AddSection(cfg)
		local text = type(cfg) == "table" and cfg.text or cfg
		local sec = Instance.new("Frame")
		sec.Size                   = UDim2.new(1,0,0,26)
		sec.BackgroundTransparency = 1
		sec.LayoutOrder            = nxt()
		sec.Parent                 = scroll
		local lineL = Instance.new("Frame")
		lineL.Size             = UDim2.new(0.28,0,0,1)
		lineL.Position         = UDim2.new(0,5,0.5,0)
		lineL.BackgroundColor3 = Color3.fromRGB(65,65,65)
		lineL.BorderSizePixel  = 0
		lineL.Parent           = sec
		local lineR = Instance.new("Frame")
		lineR.Size             = UDim2.new(0.28,0,0,1)
		lineR.Position         = UDim2.new(0.72,0,0.5,0)
		lineR.BackgroundColor3 = Color3.fromRGB(65,65,65)
		lineR.BorderSizePixel  = 0
		lineR.Parent           = sec
		local sLbl = Instance.new("TextLabel")
		sLbl.Size                   = UDim2.new(0.4,0,1,0)
		sLbl.Position               = UDim2.new(0.3,0,0,0)
		sLbl.BackgroundTransparency = 1
		sLbl.Text                   = text or ""
		sLbl.TextColor3             = Color3.fromRGB(110,110,110)
		sLbl.Font                   = Enum.Font.GothamBlack
		sLbl.TextSize               = 13
		sLbl.Parent                 = sec
		updateCanvas()
	end

		function Win:AddButton(cfg)
		local text     = cfg.text or "Button"
		local flag     = cfg.flag
		local callback = cfg.callback
		local btn = Instance.new("TextButton")
		btn.Size             = UDim2.new(1,0,0,40)
		btn.Text             = text
		btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
		btn.TextColor3       = Color3.fromRGB(255,255,255)
		btn.Font             = Enum.Font.GothamBlack
		btn.TextSize         = 16
		btn.LayoutOrder      = nxt()
		btn.TextXAlignment   = Enum.TextXAlignment.Center -- Changed to Center
		btn.Parent           = scroll
		_style(btn)
		local bp = Instance.new("UIPadding")
		bp.PaddingLeft  = UDim.new(0,10)
		bp.PaddingRight = UDim.new(0,10) -- Adjusted padding for centering
		bp.Parent       = btn

		btn.MouseButton1Click:Connect(function()
			_tween(btn, 0.2, { BackgroundColor3 = Color3.fromRGB(255, 65, 65) })
			task.delay(0.1, function()
				_tween(btn, 0.2, { BackgroundColor3 = Color3.fromRGB(25,25,25) })
			end)
			if callback then pcall(callback) end
		end)
		if flag then _flags[flag] = false end
		updateCanvas()
		return btn
	end

	function Win:AddToggle(cfg)
		local text     = cfg.text or "Toggle"
		local flag     = cfg.flag
		local default  = cfg.default or false
		local callback = cfg.callback
		local state    = default
		local row = Instance.new("TextButton")
		row.Size             = UDim2.new(1,0,0,40)
		row.BackgroundColor3 = Color3.fromRGB(25,25,25)
		row.Text             = ""
		row.LayoutOrder      = nxt()
		row.Parent           = scroll
		_style(row)
		local lbl = Instance.new("TextLabel")
		lbl.Size               = UDim2.new(1,-50,1,0)
		lbl.Position           = UDim2.new(0,10,0,0)
		lbl.BackgroundTransparency = 1
		lbl.Text               = text
		lbl.Font               = Enum.Font.GothamBlack
		lbl.TextSize           = 16
		lbl.TextColor3         = Color3.new(1,1,1)
		lbl.TextXAlignment     = Enum.TextXAlignment.Left
		lbl.Parent             = row
		local box = Instance.new("Frame")
		box.Size             = UDim2.new(0,24,0,24)
		box.Position         = UDim2.new(1,-34,0.5,-12)
		box.BackgroundColor3 = state and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(40,40,40)
		box.Parent           = row
		_corner(box)
		if flag then _flags[flag] = state end
		row.MouseButton1Click:Connect(function()
			state = not state
			_tween(box, 0.15, { BackgroundColor3 = state and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(40,40,40) })
			if flag then _flags[flag] = state end
			if callback then pcall(callback, state) end
		end)
		updateCanvas()
		local T = {}
		function T:Set(v)
			state = v
			_tween(box, 0.15, { BackgroundColor3 = v and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(40,40,40) })
			if flag then _flags[flag] = v end
		end
		function T:Get() return state end
		return T
	end

	function Win:AddSlider(cfg)
		local text     = cfg.text or "Slider"
		local flag     = cfg.flag
		local min      = cfg.min or 0
		local max      = cfg.max or 100
		local default  = cfg.default or min
		local callback = cfg.callback
		local val = math.clamp(default, min, max)
		local cont = Instance.new("Frame")
		cont.Size             = UDim2.new(1,0,0,70)
		cont.BackgroundColor3 = Color3.fromRGB(25,25,25)
		cont.LayoutOrder      = nxt()
		cont.Parent           = scroll
		_style(cont)
		local tLbl = Instance.new("TextLabel")
		tLbl.Size               = UDim2.new(0.6,0,0,20)
		tLbl.Position           = UDim2.new(0,10,0,5)
		tLbl.Text               = text
		tLbl.Font               = Enum.Font.GothamBlack
		tLbl.TextSize           = 16
		tLbl.TextXAlignment     = Enum.TextXAlignment.Left
		tLbl.TextColor3         = Color3.new(1,1,1)
		tLbl.BackgroundTransparency = 1
		tLbl.Parent             = cont
		local numBox = Instance.new("Frame")
		numBox.Size             = UDim2.new(0.15,0,0,24)
		numBox.Position         = UDim2.new(0.85,0,0,5)
		numBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
		numBox.BorderSizePixel  = 0
		numBox.Parent           = cont
		_corner(numBox)
		local valTxt = Instance.new("TextBox")
		valTxt.Size               = UDim2.new(1,0,1,0)
		valTxt.BackgroundTransparency = 1
		valTxt.Text               = tostring(val)
		valTxt.Font               = Enum.Font.GothamBlack
		valTxt.TextSize           = 14
		valTxt.TextColor3         = Color3.fromRGB(200,200,200)
		valTxt.ClearTextOnFocus   = false
		valTxt.TextXAlignment     = Enum.TextXAlignment.Center
		valTxt.TextYAlignment     = Enum.TextYAlignment.Center
		valTxt.Parent             = numBox
		local bar = Instance.new("Frame")
		bar.Size             = UDim2.new(0.95,-10,0,10)
		bar.Position         = UDim2.new(0,10,0.6,0)
		bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
		bar.Parent           = cont
		_corner(bar)
		local ip = (val-min)/(max-min)
		local fill = Instance.new("Frame")
		fill.Size             = UDim2.new(ip,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
		fill.Parent           = bar
		_corner(fill)
		local knob = Instance.new("Frame")
		knob.Size        = UDim2.new(0,16,0,16)
		knob.AnchorPoint = Vector2.new(0.5,0.5)
		knob.Position    = UDim2.new(ip,0,0.5,0)
		knob.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
		knob.Parent      = bar
		_corner(knob)
		if flag then _flags[flag] = val end
		local sliderDrag = false
		local function setPos(pos)
			pos           = math.clamp(pos,0,1)
			fill.Size     = UDim2.new(pos,0,1,0)
			knob.Position = UDim2.new(pos,0,0.5,0)
			val           = math.floor(min + pos*(max-min))
			valTxt.Text   = tostring(val)
			if flag then _flags[flag] = val end
			if callback then pcall(callback, val) end
		end
		bar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
				sliderDrag = true
				setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if not sliderDrag then return end
			if i.UserInputType == Enum.UserInputType.MouseMovement
			or i.UserInputType == Enum.UserInputType.Touch then
				setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
				sliderDrag = false
			end
		end)
		valTxt.FocusLost:Connect(function(enter)
			if enter then
				local v = tonumber(valTxt.Text)
				if v then
					val = math.clamp(v, min, max)
					local p = (val-min)/(max-min)
					fill.Size     = UDim2.new(p,0,1,0)
					knob.Position = UDim2.new(p,0,0.5,0)
					valTxt.Text   = tostring(val)
					if flag then _flags[flag] = val end
					if callback then pcall(callback, val) end
				else valTxt.Text = tostring(val) end
			end
		end)
		updateCanvas()
		local S = {}
		function S:Set(v)
			val = math.clamp(v, min, max)
			local p = (val-min)/(max-min)
			fill.Size     = UDim2.new(p,0,1,0)
			knob.Position = UDim2.new(p,0,0.5,0)
			valTxt.Text   = tostring(val)
			if flag then _flags[flag] = val end
		end
		function S:Get() return val end
		return S
	end

	function Win:AddDropdown(cfg)
		local headerText = cfg.text or "Dropdown"
		local flag       = cfg.flag
		local options    = cfg.values or {}
		local callback   = cfg.callback
		local selected   = "Select Option"
		local dropBtn = Instance.new("TextButton")
		dropBtn.Size             = UDim2.new(1,0,0,50)
		dropBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
		dropBtn.Text             = ""
		dropBtn.LayoutOrder      = nxt()
		dropBtn.Parent           = scroll
		_style(dropBtn)
		local headLbl = Instance.new("TextLabel")
		headLbl.Size               = UDim2.new(1,-10,0,18)
		headLbl.Position           = UDim2.new(0,5,0,2)
		headLbl.BackgroundTransparency = 1
		headLbl.Text               = headerText
		headLbl.TextColor3         = Color3.fromRGB(170,170,170)
		headLbl.Font               = Enum.Font.GothamBlack
		headLbl.TextSize           = 13
		headLbl.TextXAlignment     = Enum.TextXAlignment.Left
		headLbl.Parent             = dropBtn
		local selLbl = Instance.new("TextLabel")
		selLbl.Size               = UDim2.new(1,-25,1.3,0)
		selLbl.Position           = UDim2.new(0,5,0,0)
		selLbl.BackgroundTransparency = 1
		selLbl.Text               = selected
		selLbl.TextColor3         = Color3.new(1,1,1)
		selLbl.Font               = Enum.Font.GothamBlack
		selLbl.TextSize           = 16
		selLbl.TextXAlignment     = Enum.TextXAlignment.Left
		selLbl.Parent             = dropBtn
		local arrowLbl = Instance.new("TextLabel")
		arrowLbl.Size               = UDim2.new(0,20,1,0)
		arrowLbl.Position           = UDim2.new(1,-20,0,0)
		arrowLbl.BackgroundTransparency = 1
		arrowLbl.Text               = "â–¼"
		arrowLbl.TextColor3         = Color3.fromRGB(200,200,200)
		arrowLbl.Font               = Enum.Font.GothamBlack
		arrowLbl.TextSize           = 20
		arrowLbl.TextXAlignment     = Enum.TextXAlignment.Center
		arrowLbl.Parent             = dropBtn
		local dropFrame = Instance.new("Frame")
		dropFrame.Size             = UDim2.new(1,0,0,0)
		dropFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
		dropFrame.ClipsDescendants = true
		dropFrame.Active           = false
		dropFrame.LayoutOrder      = nxt()
		dropFrame.Parent           = scroll
		_corner(dropFrame)
		Instance.new("UIListLayout", dropFrame)
		local open = false
		if flag then _flags[flag] = selected end
		for _, v in ipairs(options) do
			local opt = Instance.new("TextButton")
			opt.Size             = UDim2.new(1,0,0,30)
			opt.Active           = true
			opt.Text             = v
			opt.BackgroundColor3 = Color3.fromRGB(30,30,30)
			opt.TextColor3       = Color3.new(1,1,1)
			opt.Font             = Enum.Font.GothamBlack
			opt.TextSize         = 14
			opt.Parent           = dropFrame
			_style(opt)
			opt.MouseButton1Click:Connect(function()
				selected        = v
				selLbl.Text     = v
				open            = false
				arrowLbl.Text   = "â–¼"
				if flag then _flags[flag] = v end
				_tween(dropFrame, 0.2, { Size = UDim2.new(1,0,0,0) })
				task.wait(0.21); updateCanvas()
				if callback then pcall(callback, v) end
			end)
		end
		dropBtn.MouseButton1Click:Connect(function()
			open = not open
			arrowLbl.Text = open and "â–²" or "â–¼"
			local h = open and (#options * 30) or 0
			_tween(dropFrame, 0.25, { Size = UDim2.new(1,0,0,h) })
			task.delay(0.26, updateCanvas)
		end)
		updateCanvas()
		local D = {}
		function D:Get() return selected end
		function D:Set(v) selected = v; selLbl.Text = v; if flag then _flags[flag] = v end end
		return D
	end

	function Win:CreateFolder(folderName)
		local tabBtn = Instance.new("TextButton")
		tabBtn.Size             = UDim2.new(1,0,0,40)
		tabBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
		tabBtn.TextColor3       = Color3.fromRGB(180,180,180)
		tabBtn.Font             = Enum.Font.GothamBlack
		tabBtn.TextSize         = 16
		tabBtn.Text             = "â–¶  " .. (folderName or "Folder")
		tabBtn.TextXAlignment   = Enum.TextXAlignment.Left
		tabBtn.LayoutOrder      = nxt()
		tabBtn.Parent           = scroll
		_style(tabBtn)
		local tp = Instance.new("UIPadding")
		tp.PaddingLeft = UDim.new(0,10); tp.Parent = tabBtn

		local content = Instance.new("Frame")
		content.Size                   = UDim2.new(1,0,0,0)
		content.BackgroundTransparency = 1
		content.ClipsDescendants       = true
		content.LayoutOrder            = nxt()
		content.Parent                 = scroll

		local cLayout = Instance.new("UIListLayout")
		cLayout.Padding   = UDim.new(0,4)
		cLayout.SortOrder = Enum.SortOrder.LayoutOrder
		cLayout.Parent    = content

		local cPad = Instance.new("UIPadding")
		cPad.PaddingLeft   = UDim.new(0,0)
		cPad.PaddingRight  = UDim.new(0,0)
		cPad.PaddingBottom = UDim.new(0,4)
		cPad.Parent        = content

		local folderOpen = false
		local function updateFolder()
			task.defer(function()
				if folderOpen then
					local h = cLayout.AbsoluteContentSize.Y + 8
					_tween(content, 0.25, { Size = UDim2.new(1,0,0,h) })
				else
					for _, obj in ipairs(content:GetDescendants()) do
						if obj:IsA("Frame") and obj.ClipsDescendants and obj ~= content then
							obj.Size = UDim2.new(1,0,0,0)
						end
					end
					_tween(content, 0.25, { Size = UDim2.new(1,0,0,0) })
				end
				task.wait(0.26)
				updateCanvas()
			end)
		end

		tabBtn.MouseButton1Click:Connect(function()
			folderOpen = not folderOpen
			tabBtn.Text       = (folderOpen and "â–¼  " or "â–¶  ") .. (folderName or "Folder")
			tabBtn.TextColor3 = folderOpen and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
			updateFolder()
		end)

		local Folder  = {}
		local _fOrder = 0
		local function fnxt() _fOrder += 1; return _fOrder end

		    function Folder:AddButton(cfg)
			local text     = cfg.text or "Button"
			local flag     = cfg.flag
			local callback = cfg.callback
			local btn = Instance.new("TextButton")
			btn.Size             = UDim2.new(1,0,0,40)
			btn.Text             = text
			btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
			btn.TextColor3       = Color3.fromRGB(255,255,255)
			btn.Font             = Enum.Font.GothamBlack
			btn.TextSize         = 16
			btn.LayoutOrder      = fnxt()
			btn.TextXAlignment   = Enum.TextXAlignment.Center -- Changed to Center
			btn.Parent           = content
			_style(btn)
			local bp = Instance.new("UIPadding")
			bp.PaddingLeft  = UDim.new(0,10)
			bp.PaddingRight = UDim.new(0,10) -- Adjusted padding for centering
			bp.Parent       = btn

			btn.MouseButton1Click:Connect(function()
				_tween(btn, 0.2, { BackgroundColor3 = Color3.fromRGB(255, 65, 65) })
				task.delay(0.1, function()
					_tween(btn, 0.2, { BackgroundColor3 = Color3.fromRGB(20,20,20) })
				end)
				if callback then pcall(callback) end
			end)
			if flag then _flags[flag] = false end
			updateCanvas()
			return btn
		end

		function Folder:AddToggle(cfg)
			local text     = cfg.text or "Toggle"
			local flag     = cfg.flag
			local default  = cfg.default or false
			local callback = cfg.callback
			local state    = default
			local row = Instance.new("TextButton")
			row.Size             = UDim2.new(1,0,0,36)
			row.BackgroundColor3 = Color3.fromRGB(20,20,20)
			row.Text             = ""
			row.LayoutOrder      = fnxt()
			row.Parent           = content
			_style(row)
			local lbl = Instance.new("TextLabel")
			lbl.Size               = UDim2.new(1,-50,1,0)
			lbl.Position           = UDim2.new(0,10,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text               = text
			lbl.Font               = Enum.Font.GothamBlack
			lbl.TextSize           = 14
			lbl.TextColor3         = Color3.new(1,1,1)
			lbl.TextXAlignment     = Enum.TextXAlignment.Left
			lbl.Parent             = row
			local box = Instance.new("Frame")
			box.Size             = UDim2.new(0,22,0,22)
			box.Position         = UDim2.new(1,-32,0.5,-11)
			box.BackgroundColor3 = state and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(40,40,40)
			box.Parent           = row
			_corner(box)
			if flag then _flags[flag] = state end
			row.MouseButton1Click:Connect(function()
				state = not state
				_tween(box, 0.15, { BackgroundColor3 = state and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(40,40,40) })
				if flag then _flags[flag] = state end
				if callback then pcall(callback, state) end
			end)
			updateCanvas()
			local T = {}
			function T:Set(v)
				state = v
				_tween(box, 0.15, { BackgroundColor3 = v and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(40,40,40) })
				if flag then _flags[flag] = v end
			end
			function T:Get() return state end
			return T
		end

		function Folder:AddSlider(cfg)
			local text     = cfg.text or "Slider"
			local flag     = cfg.flag
			local min      = cfg.min or 0
			local max      = cfg.max or 100
			local default  = cfg.default or min
			local callback = cfg.callback
			local val = math.clamp(default, min, max)
			local cont = Instance.new("Frame")
			cont.Size             = UDim2.new(1,0,0,65)
			cont.BackgroundColor3 = Color3.fromRGB(20,20,20)
			cont.LayoutOrder      = fnxt()
			cont.Parent           = content
			_style(cont)
			local tLbl = Instance.new("TextLabel")
			tLbl.Size               = UDim2.new(0.6,0,0,20)
			tLbl.Position           = UDim2.new(0,10,0,5)
			tLbl.Text               = text
			tLbl.Font               = Enum.Font.GothamBlack
			tLbl.TextSize           = 14
			tLbl.TextXAlignment     = Enum.TextXAlignment.Left
			tLbl.TextColor3         = Color3.new(1,1,1)
			tLbl.BackgroundTransparency = 1
			tLbl.Parent             = cont
			local numBox = Instance.new("Frame")
			numBox.Size             = UDim2.new(0.15,0,0,22)
			numBox.Position         = UDim2.new(0.85,0,0,5)
			numBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
			numBox.BorderSizePixel  = 0
			numBox.Parent           = cont
			_corner(numBox)
			local valTxt = Instance.new("TextBox")
			valTxt.Size               = UDim2.new(1,0,1,0)
			valTxt.BackgroundTransparency = 1
			valTxt.Text               = tostring(val)
			valTxt.Font               = Enum.Font.GothamBlack
			valTxt.TextSize           = 13
			valTxt.TextColor3         = Color3.fromRGB(200,200,200)
			valTxt.ClearTextOnFocus   = false
			valTxt.TextXAlignment     = Enum.TextXAlignment.Center
			valTxt.TextYAlignment     = Enum.TextYAlignment.Center
			valTxt.Parent             = numBox
			local bar = Instance.new("Frame")
			bar.Size             = UDim2.new(0.95,-10,0,8)
			bar.Position         = UDim2.new(0,10,0.62,0)
			bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
			bar.Parent           = cont
			_corner(bar)
			local ip = (val-min)/(max-min)
			local fill = Instance.new("Frame")
			fill.Size             = UDim2.new(ip,0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
			fill.Parent           = bar
			_corner(fill)
			local knob = Instance.new("Frame")
			knob.Size        = UDim2.new(0,14,0,14)
			knob.AnchorPoint = Vector2.new(0.5,0.5)
			knob.Position    = UDim2.new(ip,0,0.5,0)
			knob.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
			knob.Parent      = bar
			_corner(knob)
			if flag then _flags[flag] = val end
			local sliderDrag = false
			local function setPos(pos)
				pos           = math.clamp(pos,0,1)
				fill.Size     = UDim2.new(pos,0,1,0)
				knob.Position = UDim2.new(pos,0,0.5,0)
				val           = math.floor(min + pos*(max-min))
				valTxt.Text   = tostring(val)
				if flag then _flags[flag] = val end
				if callback then pcall(callback, val) end
			end
			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
					sliderDrag = true
					setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
				end
			end)
			UIS.InputChanged:Connect(function(i)
				if not sliderDrag then return end
				if i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch then
					setPos((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
				end
			end)
			UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
					sliderDrag = false
				end
			end)
			valTxt.FocusLost:Connect(function(enter)
				if enter then
					local v = tonumber(valTxt.Text)
					if v then
						val = math.clamp(v, min, max)
						local p = (val-min)/(max-min)
						fill.Size     = UDim2.new(p,0,1,0)
						knob.Position = UDim2.new(p,0,0.5,0)
						valTxt.Text   = tostring(val)
						if flag then _flags[flag] = val end
						if callback then pcall(callback, val) end
					else valTxt.Text = tostring(val) end
				end
			end)
			updateCanvas()
			local S = {}
			function S:Set(v)
				val = math.clamp(v, min, max)
				local p = (val-min)/(max-min)
				fill.Size     = UDim2.new(p,0,1,0)
				knob.Position = UDim2.new(p,0,0.5,0)
				valTxt.Text   = tostring(val)
				if flag then _flags[flag] = val end
			end
			function S:Get() return val end
			return S
		end

		function Folder:AddDropdown(cfg)
			local headerText = cfg.text or "Dropdown"
			local flag       = cfg.flag
			local options    = cfg.values or {}
			local callback   = cfg.callback
			local selected   = "=== Select Option ==="
			local dropBtn = Instance.new("TextButton")
			dropBtn.Size             = UDim2.new(1,0,0,46)
			dropBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
			dropBtn.Text             = ""
			dropBtn.LayoutOrder      = fnxt()
			dropBtn.Parent           = content
			_style(dropBtn)
			local headLbl = Instance.new("TextLabel")
			headLbl.Size               = UDim2.new(1,-10,0,16)
			headLbl.Position           = UDim2.new(0,5,0,2)
			headLbl.BackgroundTransparency = 1
			headLbl.Text               = headerText
			headLbl.TextColor3         = Color3.fromRGB(170,170,170)
			headLbl.Font               = Enum.Font.GothamBlack
			headLbl.TextSize           = 12
			headLbl.TextXAlignment     = Enum.TextXAlignment.Left
			headLbl.Parent             = dropBtn
			local selLbl = Instance.new("TextLabel")
			selLbl.Size               = UDim2.new(1,-25,1.3,0)
			selLbl.Position           = UDim2.new(0,5,0,0)
			selLbl.BackgroundTransparency = 1
			selLbl.Text               = selected
			selLbl.TextColor3         = Color3.new(1,1,1)
			selLbl.Font               = Enum.Font.GothamBlack
			selLbl.TextSize           = 14
			selLbl.TextXAlignment     = Enum.TextXAlignment.Left
			selLbl.Parent             = dropBtn
			local arrowLbl = Instance.new("TextLabel")
			arrowLbl.Size               = UDim2.new(0,20,1,0)
			arrowLbl.Position           = UDim2.new(1,-20,0,0)
			arrowLbl.BackgroundTransparency = 1
			arrowLbl.Text               = "â–¼"
			arrowLbl.TextColor3         = Color3.fromRGB(200,200,200)
			arrowLbl.Font               = Enum.Font.GothamBlack
			arrowLbl.TextSize           = 18
			arrowLbl.TextXAlignment     = Enum.TextXAlignment.Center
			arrowLbl.Parent             = dropBtn
			local dropFrame = Instance.new("Frame")
			dropFrame.Size             = UDim2.new(1,0,0,0)
			dropFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
			dropFrame.ClipsDescendants = true
			dropFrame.LayoutOrder      = fnxt()
			dropFrame.Parent           = content
			_corner(dropFrame)
			local dropLayout = Instance.new("UIListLayout")
			dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
			dropLayout.Parent    = dropFrame
			local open      = false
			local OPT_H     = 28
			local LINE_H    = 1
			local optCount  = #options
			-- total open height includes a 1px dark gray divider line between each option
			local openH = (optCount * OPT_H) + math.max(0, optCount - 1) * LINE_H
			if flag then _flags[flag] = selected end
			for idx, v in ipairs(options) do
				local opt = Instance.new("TextButton")
				opt.Size             = UDim2.new(1,0,0,OPT_H)
				opt.Text             = v
				opt.BackgroundColor3 = Color3.fromRGB(25,25,25)
				opt.TextColor3       = Color3.new(1,1,1)
				opt.Font             = Enum.Font.GothamBlack
				opt.TextSize         = 13
				opt.LayoutOrder      = idx * 2
				opt.Parent           = dropFrame
				_style(opt) -- rounded corners + smooth border on each option

				if idx < optCount then
					local divider = Instance.new("Frame")
					divider.Size             = UDim2.new(1,0,0,LINE_H)
					divider.BackgroundColor3 = Color3.fromRGB(45,45,45) -- dark gray line between items
					divider.BorderSizePixel  = 0
					divider.LayoutOrder      = idx * 2 + 1
					divider.Parent           = dropFrame
				end

				opt.MouseButton1Click:Connect(function()
					selected = v
					selLbl.Text = v
					open = false
					TweenService:Create(arrowLbl, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = 0 }):Play()
					if flag then _flags[flag] = v end
					_tween(dropFrame, 0.22, { Size = UDim2.new(1,0,0,0) })
					task.wait(0.23)
					updateFolder(); updateCanvas()
					if callback then pcall(callback, v) end
				end)
			end
			dropBtn.MouseButton1Click:Connect(function()
				open = not open
				-- smoothly rotate the arrow instead of instantly swapping the glyph
				TweenService:Create(arrowLbl, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = open and 180 or 0 }):Play()
				local h = open and openH or 0
				_tween(dropFrame, 0.28, { Size = UDim2.new(1,0,0,h) })
				task.delay(0.29, function()
					updateFolder(); updateCanvas()
				end)
			end)
			updateCanvas()
			local D = {}
			function D:Get() return selected end
			function D:Set(v) selected = v; selLbl.Text = v; if flag then _flags[flag] = v end end
			return D
		end

		return Folder
	end

	updateCanvas()
	return Win
end 

function Lib:Start()
	_loaded = true
	for _, fn in ipairs(_pendingShow) do fn() end
	_pendingShow = {}
	_reposition()
end

function Lib:GetFlag(flag)
	return _flags[flag]
end

return Lib
