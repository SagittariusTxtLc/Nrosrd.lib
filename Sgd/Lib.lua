-- Setup
makefolder("edge_ui_library")

-- Variables
local players = game:GetService("Players")
local tween_service = game:GetService("TweenService")
local user_input_service = game:GetService("UserInputService")
local http_service = game:GetService('HttpService')
local core_gui = game:GetService("CoreGui")

local local_player = players.LocalPlayer
local mouse = local_player:GetMouse()

-- HARDCODED UPDATED COLORS (No more manual configuration needed)
getgenv().color_scheme = {
    dark_color = Color3.fromRGB(20, 20, 20),           -- Header GUI Black
    dark_hover_color = Color3.fromRGB(30, 30, 30),     -- Header Hover
    background_color = Color3.fromRGB(45, 45, 45),     -- Main GUI Background Gray
    section_background_color = Color3.fromRGB(35, 35, 35), -- Sections Dark Gray
    misc_elements_color = Color3.fromRGB(55, 55, 55),  -- Outlines / Borders Gray
    elements_color = Color3.fromRGB(40, 40, 40),       -- Interactive elements Background
    elements_hover_color = Color3.fromRGB(50, 50, 50), -- Element Hover
    enabled_color = Color3.fromRGB(0, 150, 255),       -- Enabled Toggle/Accent (Clean Blue)
    enabled_hover_color = Color3.fromRGB(0, 120, 220),
    scroll_bar_color = Color3.fromRGB(80, 80, 80)
}

local library = {}

function library.new_window(title_text)
	local edge_ui_library = Instance.new("ScreenGui")
	local main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local header = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Frame = Instance.new("Frame")
	local title = Instance.new("TextLabel")
	local close = Instance.new("ImageButton")
	local hide = Instance.new("ImageButton")
	local container = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local Frame_2 = Instance.new("Frame")
	local tabs = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")

	edge_ui_library.Name = "edge_ui_library"
	edge_ui_library.Parent = core_gui
	edge_ui_library.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	main.Name = "main"
	main.Parent = edge_ui_library
	main.BackgroundColor3 = getgenv().color_scheme.background_color
	main.Position = UDim2.new(0.5, -275, 0.5, -175)
	main.Size = UDim2.new(0, 550, 0, 350)

	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = main

	header.Name = "header"
	header.Parent = main
	header.BackgroundColor3 = getgenv().color_scheme.dark_color
	header.Size = UDim2.new(1, 0, 0, 30)

	UICorner_2.CornerRadius = UDim.new(0, 6)
	UICorner_2.Parent = header

	Frame.Parent = header
	Frame.BackgroundColor3 = getgenv().color_scheme.dark_color
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0, 0, 1, -5)
	Frame.Size = UDim2.new(1, 0, 0, 5)

	title.Name = "title"
	title.Parent = header
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1.000
	title.Position = UDim2.new(0, 10, 0, 0)
	title.Size = UDim2.new(1, -70, 1, 0)
	title.Font = Enum.Font.SourceSansSemibold
	title.Text = title_text or "Edge UI Library"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16.000
	title.TextXAlignment = Enum.TextXAlignment.Left

	close.Name = "close"
	close.Parent = header
	close.BackgroundTransparency = 1.000
	close.Position = UDim2.new(1, -25, 0, 5)
	close.Size = UDim2.new(0, 20, 0, 20)
	close.ZIndex = 2
	close.Image = "rbxassetid://3926305904"
	close.ImageRectOffset = Vector2.new(284, 4)
	close.ImageRectSize = Vector2.new(24, 24)

	hide.Name = "hide"
	hide.Parent = header
	hide.BackgroundTransparency = 1.000
	hide.Position = UDim2.new(1, -50, 0, 5)
	hide.Size = UDim2.new(0, 20, 0, 20)
	hide.ZIndex = 2
	hide.Image = "rbxassetid://3926307971"
	hide.ImageRectOffset = Vector2.new(884, 284)
	hide.ImageRectSize = Vector2.new(36, 36)

	container.Name = "container"
	container.Parent = main
	container.BackgroundColor3 = getgenv().color_scheme.background_color
	container.Position = UDim2.new(0, 140, 0, 30)
	container.Size = UDim2.new(1, -140, 1, -30)

	UICorner_3.CornerRadius = UDim.new(0, 6)
	UICorner_3.Parent = container

	Frame_2.Parent = container
	Frame_2.BackgroundColor3 = getgenv().color_scheme.background_color
	Frame_2.BorderSizePixel = 0
	Frame_2.Size = UDim2.new(0, 5, 1, 0)

	tabs.Name = "tabs"
	tabs.Parent = main
	tabs.Active = true
	tabs.BackgroundColor3 = getgenv().color_scheme.dark_color
	tabs.BorderSizePixel = 0
	tabs.Position = UDim2.new(0, 0, 0, 30)
	tabs.Size = UDim2.new(0, 135, 1, -30)
	tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabs.ScrollBarThickness = 2
	tabs.ScrollBarImageColor3 = getgenv().color_scheme.scroll_bar_color

	UIListLayout.Parent = tabs
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIPadding.Parent = tabs
	UIPadding.PaddingTop = UDim.new(0, 5)

	-- FIX: Optimized non-freezing Draggable system
	local dragging, dragInput, dragStart, startPos
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	user_input_service.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	close.MouseButton1Click:Connect(function()
		edge_ui_library:Destroy()
	end)

	local hidden = false
	hide.MouseButton1Click:Connect(function()
		hidden = not hidden
		container.Visible = not hidden
		tabs.Visible = not hidden
		tween_service:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingStyle.Out), {Size = hidden and UDim2.new(0, 550, 0, 30) or UDim2.new(0, 550, 0, 350)}):Play()
	end)

	local tabs_table = {}
	function tabs_table.new_tab(tab_text)
		local button = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local tab = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local UIPadding = Instance.new("UIPadding")

		button.Name = "button"
		button.Parent = tabs
		button.BackgroundColor3 = getgenv().color_scheme.dark_color
		button.BorderSizePixel = 0
		button.Size = UDim2.new(1, -10, 0, 30)
		button.Font = Enum.Font.SourceSansSemibold
		button.Text = tab_text or "Tab"
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 16.000
		button.AutoButtonColor = false

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = button

		tab.Name = "tab"
		tab.Parent = container
		tab.Active = true
		tab.BackgroundColor3 = getgenv().color_scheme.background_color
		tab.BorderSizePixel = 0
		tab.Size = UDim2.new(1, 0, 1, 0)
		tab.Visible = false
		tab.CanvasSize = UDim2.new(0, 0, 0, 0)
		tab.ScrollBarThickness = 4
		tab.ScrollBarImageColor3 = getgenv().color_scheme.scroll_bar_color

		UIListLayout.Parent = tab
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 10)

		UIPadding.Parent = tab
		UIPadding.PaddingTop = UDim.new(0, 10)
		UIPadding.PaddingBottom = UDim.new(0, 10)

		local function update_canvas_size()
			tab.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
		end
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update_canvas_size)

		if #container:GetChildren() == 2 then
			tab.Visible = true
			button.BackgroundColor3 = getgenv().color_scheme.elements_color
		end

		button.MouseEnter:Connect(function()
			if not tab.Visible then
				tween_service:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = getgenv().color_scheme.dark_hover_color}):Play()
			end
		end)

		button.MouseLeave:Connect(function()
			if not tab.Visible then
				tween_service:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = getgenv().color_scheme.dark_color}):Play()
			end
		end)

		button.MouseButton1Click:Connect(function()
			for _, v in pairs(container:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			for _, v in pairs(tabs:GetChildren()) do
				if v:IsA("TextButton") then
					v.BackgroundColor3 = getgenv().color_scheme.dark_color
				end
			end
			tab.Visible = true
			button.BackgroundColor3 = getgenv().color_scheme.elements_color
		end)

		local sections_table = {}
		function sections_table.new_section(section_text)
			local section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")
			local UIPadding = Instance.new("UIPadding")
			local title = Instance.new("TextLabel")
			local line = Instance.new("Frame")

			section.Name = "section"
			section.Parent = tab
			section.BackgroundColor3 = getgenv().color_scheme.section_background_color
			section.Size = UDim2.new(1, -20, 0, 40)

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = section

			UIListLayout.Parent = section
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			UIPadding.Parent = section
			UIPadding.PaddingBottom = UDim.new(0, 10)
			UIPadding.PaddingTop = UDim.new(0, 5)

			title.Name = "title"
			title.Parent = section
			title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			title.BackgroundTransparency = 1.000
			title.Size = UDim2.new(1, -20, 0, 20)
			title.Font = Enum.Font.SourceSansSemibold
			title.Text = section_text or "Section"
			title.TextColor3 = Color3.fromRGB(255, 255, 255)
			title.TextSize = 16.000
			title.TextXAlignment = Enum.TextXAlignment.Left

			line.Name = "line"
			line.Parent = section
			line.BackgroundColor3 = getgenv().color_scheme.misc_elements_color
			line.BorderSizePixel = 0
			line.Size = UDim2.new(1, -20, 0, 1)

			local function update_section_size()
				section.Size = UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 15)
			end
			UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update_section_size)

			local elements_table = {}

			function elements_table.new_button(button_text, callback)
				local callback = callback or function() end
				local button = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				button.Name = "button"
				button.Parent = section
				button.BackgroundColor3 = getgenv().color_scheme.elements_color
				button.Size = UDim2.new(1, -20, 0, 30)
				button.Font = Enum.Font.SourceSansSemibold
				button.Text = button_text or "Button"
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.TextSize = 16.000
				button.AutoButtonColor = false

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = button

				UIStroke.Parent = button
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				button.MouseEnter:Connect(function()
					tween_service:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = getgenv().color_scheme.elements_hover_color}):Play()
				end)
				button.MouseLeave:Connect(function()
					tween_service:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = getgenv().color_scheme.elements_color}):Play()
				end)
				button.MouseButton1Click:Connect(callback)
			end

			function elements_table.new_toggle(toggle_text, callback)
				local callback = callback or function() end
				local toggle = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local title = Instance.new("TextLabel")
				local button = Instance.new("TextButton")
				local UICorner_2 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				toggle.Name = "toggle"
				toggle.Parent = section
				toggle.BackgroundColor3 = getgenv().color_scheme.elements_color
				toggle.Size = UDim2.new(1, -20, 0, 30)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = toggle

				UIStroke.Parent = toggle
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1

				title.Name = "title"
				title.Parent = toggle
				title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				title.BackgroundTransparency = 1.000
				title.Position = UDim2.new(0, 10, 0, 0)
				title.Size = UDim2.new(1, -50, 1, 0)
				title.Font = Enum.Font.SourceSansSemibold
				title.Text = toggle_text or "Toggle"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16.000
				title.TextXAlignment = Enum.TextXAlignment.Left

				button.Name = "button"
				button.Parent = toggle
				button.BackgroundColor3 = getgenv().color_scheme.dark_color
				button.Position = UDim2.new(1, -30, 0, 5)
				button.Size = UDim2.new(0, 20, 0, 20)
				button.Font = Enum.Font.SourceSans
				button.Text = ""
				button.TextColor3 = Color3.fromRGB(0, 0, 0)
				button.TextSize = 14.000
				button.AutoButtonColor = false

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = button

				local enabled = false
				button.MouseButton1Click:Connect(function()
					enabled = not enabled
					local target_color = enabled and getgenv().color_scheme.enabled_color or getgenv().color_scheme.dark_color
					tween_service:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = target_color}):Play()
					callback(enabled)
				end)
			end

			function elements_table.new_text_box(text_box_text, callback)
				local callback = callback or function() end
				local text_box = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local title = Instance.new("TextLabel")
				local TextBox = Instance.new("TextBox")
				local UICorner_2 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				text_box.Name = "text_box"
				text_box.Parent = section
				text_box.BackgroundColor3 = getgenv().color_scheme.elements_color
				text_box.Size = UDim2.new(1, -20, 0, 30)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = text_box

				UIStroke.Parent = text_box
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1

				title.Name = "title"
				title.Parent = text_box
				title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				title.BackgroundTransparency = 1.000
				title.Position = UDim2.new(0, 10, 0, 0)
				title.Size = UDim2.new(1, -120, 1, 0)
				title.Font = Enum.Font.SourceSansSemibold
				title.Text = text_box_text or "Text box"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16.000
				title.TextXAlignment = Enum.TextXAlignment.Left

				TextBox.Parent = text_box
				TextBox.BackgroundColor3 = getgenv().color_scheme.dark_color
				TextBox.Position = UDim2.new(1, -110, 0, 5)
				TextBox.Size = UDim2.new(0, 100, 0, 20)
				TextBox.Font = Enum.Font.SourceSansSemibold
				TextBox.Text = ""
				TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.TextSize = 14.000
				TextBox.ClipsDescendants = true

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = TextBox

				TextBox.FocusLost:Connect(function(enterPressed)
					if enterPressed then
						callback(TextBox.Text)
					end
				end)
			end

			function elements_table.new_key_bind(key_bind_text, default_key, callback)
				local callback = callback or function() end
				local old_key = default_key and default_key.Name or "None"
				local key_bind = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local title = Instance.new("TextLabel")
				local button = Instance.new("TextButton")
				local UICorner_2 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				key_bind.Name = "key_bind"
				key_bind.Parent = section
				key_bind.BackgroundColor3 = getgenv().color_scheme.elements_color
				key_bind.Size = UDim2.new(1, -20, 0, 30)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = key_bind

				UIStroke.Parent = key_bind
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1

				title.Name = "title"
				title.Parent = key_bind
				title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				title.BackgroundTransparency = 1.000
				title.Position = UDim2.new(0, 10, 0, 0)
				title.Size = UDim2.new(1, -120, 1, 0)
				title.Font = Enum.Font.SourceSansSemibold
				title.Text = key_bind_text or "Key bind"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16.000
				title.TextXAlignment = Enum.TextXAlignment.Left

				button.Name = "button"
				button.Parent = key_bind
				button.BackgroundColor3 = getgenv().color_scheme.dark_color
				button.Position = UDim2.new(1, -110, 0, 5)
				button.Size = UDim2.new(0, 100, 0, 20)
				button.Font = Enum.Font.SourceSansSemibold
				button.Text = old_key
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.TextSize = 14.000

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = button

				local alignment = Instance.new("UITextSizeConstraint")
				alignment.MaxTextSize = 14
				alignment.Parent = button

				local connection
				button.MouseButton1Click:Connect(function()
					button.Text = "..."
					if connection then connection:Disconnect() end
					connection = user_input_service.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							button.Text = input.KeyCode.Name
							old_key = input.KeyCode
							connection:Disconnect()
						end
					end)
				end)

				user_input_service.InputBegan:Connect(function(input, gameProcessedEvent)
					if not gameProcessedEvent and old_key and input.KeyCode == old_key then
						callback(old_key)
					end
				end)
			end

			function elements_table.new_slider(slider_text, min, max, callback)
				local callback = callback or function() end
				local slider = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local title = Instance.new("TextLabel")
				local value_display = Instance.new("TextLabel")
				local slider_bar = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local slider_fill = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				slider.Name = "slider"
				slider.Parent = section
				slider.BackgroundColor3 = getgenv().color_scheme.elements_color
				slider.Size = UDim2.new(1, -20, 0, 50)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = slider

				UIStroke.Parent = slider
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1

				title.Name = "title"
				title.Parent = slider
				title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				title.BackgroundTransparency = 1.000
				title.Position = UDim2.new(0, 10, 0, 5)
				title.Size = UDim2.new(1, -70, 0, 20)
				title.Font = Enum.Font.SourceSansSemibold
				title.Text = slider_text or "Slider"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16.000
				title.TextXAlignment = Enum.TextXAlignment.Left

				value_display.Name = "value_display"
				value_display.Parent = slider
				value_display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				value_display.BackgroundTransparency = 1.000
				value_display.Position = UDim2.new(1, -60, 0, 5)
				value_display.Size = UDim2.new(0, 50, 0, 20)
				value_display.Font = Enum.Font.SourceSansSemibold
				value_display.Text = tostring(min)
				value_display.TextColor3 = Color3.fromRGB(255, 255, 255)
				value_display.TextSize = 16.000
				value_display.TextXAlignment = Enum.TextXAlignment.Right

				slider_bar.Name = "slider_bar"
				slider_bar.Parent = slider
				slider_bar.BackgroundColor3 = getgenv().color_scheme.dark_color
				slider_bar.Position = UDim2.new(0, 10, 0, 30)
				slider_bar.Size = UDim2.new(1, -20, 0, 10)

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = slider_bar

				slider_fill.Name = "slider_fill"
				slider_fill.Parent = slider_bar
				slider_fill.BackgroundColor3 = getgenv().color_scheme.enabled_color
				slider_fill.Size = UDim2.new(0, 0, 1, 0)

				UICorner_3.CornerRadius = UDim.new(0, 4)
				UICorner_3.Parent = slider_fill

				local function update_slider(input)
					local size_x = math.clamp((input.Position.X - slider_bar.AbsolutePosition.X) / slider_bar.AbsoluteSize.X, 0, 1)
					slider_fill.Size = UDim2.new(size_x, 0, 1, 0)
					local calculated_val = math.floor(min + (max - min) * size_x)
					value_display.Text = tostring(calculated_val)
					callback(calculated_val)
				end

				local sliding = false
				slider_bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						sliding = true
						update_slider(input)
					end
				end)

				user_input_service.InputChanged:Connect(function(input)
					if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
						update_slider(input)
					end
				end)

				user_input_service.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						sliding = false
					end
				end)
			end

			function elements_table.new_dropdown(dropdown_text, array, callback)
				local callback = callback or function() end
				local dropdown = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local title = Instance.new("TextLabel")
				local ImageButton = Instance.new("ImageButton")
				local dropdown_content = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UIListLayout = Instance.new("UIListLayout")
				local UIStroke = Instance.new("UIStroke")

				dropdown.Name = "dropdown"
				dropdown.Parent = section
				dropdown.BackgroundColor3 = getgenv().color_scheme.elements_color
				dropdown.Size = UDim2.new(1, -20, 0, 30)
				dropdown.ClipsDescendants = true

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = dropdown

				UIStroke.Parent = dropdown
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1

				title.Name = "title"
				title.Parent = dropdown
				title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				title.BackgroundTransparency = 1.000
				title.Position = UDim2.new(0, 10, 0, 0)
				title.Size = UDim2.new(1, -40, 0, 30)
				title.Font = Enum.Font.SourceSansSemibold
				title.Text = dropdown_text or "Dropdown"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16.000
				title.TextXAlignment = Enum.TextXAlignment.Left

				ImageButton.Parent = dropdown
				ImageButton.BackgroundTransparency = 1.000
				ImageButton.Position = UDim2.new(1, -25, 0, 5)
				ImageButton.Size = UDim2.new(0, 20, 0, 20)
				ImageButton.Image = "rbxassetid://3926305904"
				ImageButton.ImageRectOffset = Vector2.new(564, 284)
				ImageButton.ImageRectSize = Vector2.new(36, 36)

				dropdown_content.Name = "dropdown_content"
				dropdown_content.Parent = dropdown
				dropdown_content.BackgroundColor3 = getgenv().color_scheme.dark_color
				dropdown_content.Position = UDim2.new(0, 10, 0, 35)
				dropdown_content.Size = UDim2.new(1, -20, 0, 0)
				dropdown_content.Visible = false

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = dropdown_content

				UIListLayout.Parent = dropdown_content
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)

				local function change_state(open)
					dropdown_content.Visible = open
					local target_size = open and UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 10) or UDim2.new(1, -20, 0, 0)
					local main_target_size = open and UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 50) or UDim2.new(1, -20, 0, 30)
					
					tween_service:Create(dropdown_content, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = target_size}):Play()
					tween_service:Create(dropdown, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = main_target_size}):Play()
					tween_service:Create(ImageButton, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Rotation = open and 180 or 0}):Play()
				end

				local function add_buttons(items)
					for _, v in pairs(dropdown_content:GetChildren()) do
						if v:IsA("TextButton") then v:Destroy() end
					end
					for _, v in pairs(items) do
						local button = Instance.new("TextButton")
						local UICorner = Instance.new("UICorner")

						button.Name = "button"
						button.Parent = dropdown_content
						button.BackgroundColor3 = getgenv().color_scheme.elements_color
						button.Size = UDim2.new(1, -10, 0, 25)
						button.Font = Enum.Font.SourceSansSemibold
						button.Text = tostring(v)
						button.TextColor3 = Color3.fromRGB(255, 255, 255)
						button.TextSize = 14.000

						UICorner.CornerRadius = UDim.new(0, 4)
						UICorner.Parent = button

						button.MouseButton1Click:Connect(function()
							title.Text = dropdown_text .. " - " .. tostring(v)
							change_state(false)
							callback(v)
						end)
					end
				end

				ImageButton.MouseButton1Click:Connect(function()
					local is_open = not dropdown_content.Visible
					if is_open then
						local data = (type(array) == "function") and array() or array
						add_buttons(data)
					end
					change_state(is_open)
				end)
			end

			function elements_table.new_dropdown2(dropdown_text, array, callback)
				local callback = callback or function() end
				local dropdown = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local title = Instance.new("TextLabel")
				local ImageButton = Instance.new("ImageButton")
				local dropdown_content = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UIListLayout = Instance.new("UIListLayout")
				local UIStroke = Instance.new("UIStroke")

				dropdown.Name = "dropdown"
				dropdown.Parent = section
				dropdown.BackgroundColor3 = getgenv().color_scheme.elements_color
				dropdown.Size = UDim2.new(1, -20, 0, 30)
				dropdown.ClipsDescendants = true

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = dropdown

				UIStroke.Parent = dropdown
				UIStroke.Color = getgenv().color_scheme.misc_elements_color
				UIStroke.Thickness = 1

				title.Name = "title"
				title.Parent = dropdown
				title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				title.BackgroundTransparency = 1.000
				title.Position = UDim2.new(0, 10, 0, 0)
				title.Size = UDim2.new(1, -40, 0, 30)
				title.Font = Enum.Font.SourceSansSemibold
				title.Text = dropdown_text or "Multi Dropdown"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16.000
				title.TextXAlignment = Enum.TextXAlignment.Left

				ImageButton.Parent = dropdown
				ImageButton.BackgroundTransparency = 1.000
				ImageButton.Position = UDim2.new(1, -25, 0, 5)
				ImageButton.Size = UDim2.new(0, 20, 0, 20)
				ImageButton.Image = "rbxassetid://3926305904"
				ImageButton.ImageRectOffset = Vector2.new(564, 284)
				ImageButton.ImageRectSize = Vector2.new(36, 36)

				dropdown_content.Name = "dropdown_content"
				dropdown_content.Parent = dropdown
				dropdown_content.BackgroundColor3 = getgenv().color_scheme.dark_color
				dropdown_content.Position = UDim2.new(0, 10, 0, 35)
				dropdown_content.Size = UDim2.new(1, -20, 0, 0)
				dropdown_content.Visible = false

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = dropdown_content

				UIListLayout.Parent = dropdown_content
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)

				local selected_elements = {}

				local function change_state(open)
					dropdown_content.Visible = open
					local target_size = open and UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 10) or UDim2.new(1, -20, 0, 0)
					local main_target_size = open and UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 50) or UDim2.new(1, -20, 0, 30)
					
					tween_service:Create(dropdown_content, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = target_size}):Play()
					tween_service:Create(dropdown, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = main_target_size}):Play()
					tween_service:Create(ImageButton, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Rotation = open and 180 or 0}):Play()
				end

				local function add_buttons(items)
					for _, v in pairs(dropdown_content:GetChildren()) do
						if v:IsA("TextButton") then v:Destroy() end
					end
					for _, v in pairs(items) do
						local button = Instance.new("TextButton")
						local UICorner = Instance.new("UICorner")

						button.Name = "button"
						button.Parent = dropdown_content
						button.BackgroundColor3 = table.find(selected_elements, v) and getgenv().color_scheme.enabled_color or getgenv().color_scheme.elements_color
						button.Size = UDim2.new(1, -10, 0, 25)
						button.Font = Enum.Font.SourceSansSemibold
						button.Text = tostring(v)
						button.TextColor3 = Color3.fromRGB(255, 255, 255)
						button.TextSize = 14.000

						UICorner.CornerRadius = UDim.new(0, 4)
						UICorner.Parent = button

						button.MouseButton1Click:Connect(function()
							local index = table.find(selected_elements, v)
							if index then
								table.remove(selected_elements, index)
								tween_service:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {BackgroundColor3 = getgenv().color_scheme.elements_color}):Play()
							end
							callback(selected_elements)
						end)
					end
				end

				ImageButton.MouseButton1Click:Connect(function()
					local is_open = not dropdown_content.Visible
					if is_open then
						local data = (type(array) == "function") and array() or array
						add_buttons(data)
					end
					change_state(is_open)
				end)
			end

			return elements_table
		end
		return sections_table
	end
	return tabs_table
end

return library
