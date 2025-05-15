while not game:IsLoaded() do
    task.wait()
end

if game.PlaceId ~= 12355337193 then
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local shootRemote = ReplicatedStorage.Remotes.Shoot

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local espEnabled = false
local silentAimEnabled = false

local r15BodyParts = {
    "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg",
    "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"
}
local gui = Instance.new("ScreenGui")
gui.Name = "CheatMenu"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.5, -160, 0.4, -185)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

frame.Size = UDim2.new(0, 0, 0, 0)
frame.BackgroundTransparency = 1

local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = {}
goal.Size = UDim2.new(0, 320, 0, 370)
goal.BackgroundTransparency = 0
local tween = TweenService:Create(frame, tweenInfo, goal)
tween:Play()


local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 16)

local shadow = Instance.new("ImageLabel", frame)
shadow.Size = UDim2.new(1, 16, 1, 16)
shadow.Position = UDim2.new(0, -8, 0, -8)
shadow.ZIndex = 0
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Mehmet.lol"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextStrokeTransparency = 0.8

local checkboxContainer = Instance.new("Frame", frame)
checkboxContainer.Size = UDim2.new(1, 0, 0, 120) 
checkboxContainer.Position = UDim2.new(0, 0, 0, 50)
checkboxContainer.BackgroundTransparency = 1
checkboxContainer.ClipsDescendants = true
local uiList = Instance.new("UIListLayout", checkboxContainer)
uiList.Padding = UDim.new(0, 20)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Padding = UDim.new(0, 25)
local function createCheckbox(text, initialState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 280, 0, 36)
    container.BackgroundTransparency = 1
    container.Parent = checkboxContainer

    local checkbox = Instance.new("Frame", container)
    checkbox.Size = UDim2.new(0, 28, 0, 28)
    checkbox.Position = UDim2.new(0, 10, 0.5, -14)
    checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    checkbox.BorderSizePixel = 0
    checkbox.Name = "Box"
    local cbCorner = Instance.new("UICorner", checkbox)
    cbCorner.CornerRadius = UDim.new(0, 6)

    local checkmark = Instance.new("TextLabel", checkbox)
    checkmark.Size = UDim2.new(0, 18, 0, 18)
    checkmark.Position = UDim2.new(0.5, -9, 0.5, -9)
    checkmark.BackgroundTransparency = 1
    checkmark.Text = "X"
    checkmark.TextColor3 = Color3.fromRGB(255, 100, 100)
    checkmark.TextScaled = true
    checkmark.Font = Enum.Font.GothamBold
    checkmark.Visible = initialState

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 48, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.RichText = false

    local function toggle()
        checkmark.Visible = not checkmark.Visible
        callback(checkmark.Visible)
    end

    checkbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)
    label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)

    return {
        container = container,
        checkbox = checkbox,
        checkmark = checkmark,
        label = label,
        toggle = toggle
    }
end
local espCheckbox = createCheckbox("Enable ESP", false, function(state)
    espEnabled = state
    if not state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end)
local silentAimCheckbox = createCheckbox("Enable Silent Aim", false, function(state)
    silentAimEnabled = state
end)
local sliderContainer = Instance.new("Frame", frame)
sliderContainer.Size = UDim2.new(0, 280, 0, 70)
sliderContainer.Position = UDim2.new(0, 20, 0, 180)
sliderContainer.BackgroundTransparency = 1
local speedLabel = Instance.new("TextLabel", sliderContainer)
speedLabel.Size = UDim2.new(1, 0, 0, 24)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Player Speed: 16"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 20
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
local sliderBar = Instance.new("Frame", sliderContainer)
sliderBar.Size = UDim2.new(1, 0, 0, 20)
sliderBar.Position = UDim2.new(0, 0, 0, 40)
sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderBar.BorderSizePixel = 0
sliderBar.ClipsDescendants = true
sliderBar.Name = "SliderBar"
local sliderCorner = Instance.new("UICorner", sliderBar)
sliderCorner.CornerRadius = UDim.new(0, 10)
local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size = UDim2.new((16 - 8) / (100 - 8), 0, 1, 0) 
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
sliderFill.BorderSizePixel = 0
sliderFill.Name = "SliderFill"
local fillCorner = Instance.new("UICorner", sliderFill)
fillCorner.CornerRadius = UDim.new(0, 10)
local knob = Instance.new("TextButton", sliderBar)
knob.Size = UDim2.new(0, 28, 0, 28)
knob.Position = UDim2.new((16 - 8) / (100 - 8), -14, 0.5, -14)
knob.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
knob.BorderSizePixel = 0
knob.AutoButtonColor = false
knob.Text = ""
local knobCorner = Instance.new("UICorner", knob)
knobCorner.CornerRadius = UDim.new(0, 14)
local minSpeed, maxSpeed = 8, 100
local currentSpeed = 16
local function updateSpeed(newSpeed)
    currentSpeed = math.clamp(newSpeed, minSpeed, maxSpeed)
    speedLabel.Text = "Player Speed: " .. math.floor(currentSpeed)
    local ratio = (currentSpeed - minSpeed) / (maxSpeed - minSpeed)
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    knob.Position = UDim2.new(ratio, -14, 0.5, -14)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
    end
end
local dragging = false
local function updateSlider(input)
    local pos = input.Position.X - sliderBar.AbsolutePosition.X
    local size = sliderBar.AbsoluteSize.X
    local ratio = math.clamp(pos / size, 0, 1)
    local speedValue = minSpeed + ratio * (maxSpeed - minSpeed)
    updateSpeed(speedValue)
end
knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateSlider(input)
        dragging = true
    end
end)
sliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
updateSpeed(16)
local function isVisible(targetPos)
    local origin = Camera.CFrame.Position
    local direction = (targetPos - origin)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        local hitPos = result.Position
        if (hitPos - targetPos).Magnitude < 2 then
            return true
        else
            return false
        end
    else
        return true
    end
end
local function updateHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local highlight = player.Character:FindFirstChild("Highlight")
            local visible = isVisible(head.Position)

            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "Highlight"
                highlight.Adornee = player.Character
                highlight.Parent = player.Character
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
            end

            if visible then
                highlight.FillColor = Color3.fromRGB(0, 255, 0) 
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0) 
            end
        else
            if player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end
local function isRagdoll(model)
    return not model:FindFirstChild("Animate")
end

local function isOnScreen(character)
    local head = character:FindFirstChild("Head")
    if not head then return false end
    local _, onScreen = Camera:WorldToViewportPoint(head.Position)
    return onScreen
end
local function getClosestPlayerToMouse()
    local closest = nil
    local shortest = math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        if isRagdoll(char) or not isOnScreen(char) then continue end

        local dist = (Mouse.Hit.Position - char.HumanoidRootPart.Position).Magnitude
        if dist < shortest then
            shortest = dist
            closest = p
        end
    end

    return closest
end
task.spawn(function()
    while true do
        task.wait(0.3)
        if espEnabled then
            updateHighlights()
        end
    end
end)
Mouse.Button1Down:Connect(function()
    if not silentAimEnabled then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local target = getClosestPlayerToMouse()
        if target and target.Character then
            local part = target.Character[r15BodyParts[math.random(1, #r15BodyParts)]]
            if part then
                shootRemote:FireServer(Vector3.new(1, 1, 1), Vector3.new(1, 1, 1), part, Vector3.new(1, 1, 1))
            end
        end
    end
end)
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        gui.Enabled = guiVisible
    end
end)
