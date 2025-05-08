game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Script Loaded", Text = "Aimbot is active", Duration = 5})

while not game:IsLoaded() do
    task.wait()
end

if game.PlaceId ~= 12355337193 then
    return
end

local plrs = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local shootRemote = rs.Remotes.Shoot

local function isTeammate(model)
    local highlight = model:FindFirstChild("Highlight")
    return highlight and highlight.FillColor == Color3.fromRGB(30, 214, 134)
end

local function isRagdoll(model)
    return not model:FindFirstChild("Animate")
end

local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

local r15BodyParts = {
    "Head",
    "UpperTorso",
    "LowerTorso",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "LeftFoot",
    "RightUpperLeg",
    "RightLowerLeg",
    "RightFoot"
}

local function isCharacterOnScreen(playerCharacter)
    local playerHead = playerCharacter:WaitForChild("Head")
    local screenPos, isOnScreen = camera:WorldToViewportPoint(playerHead.Position)
    return isOnScreen
end

local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, otherPlayer in plrs:GetPlayers() do
        local char = otherPlayer.Character
        if (not char) or otherPlayer == plr or isTeammate(char) or isRagdoll(char) or (not workspace:FindFirstChild(otherPlayer.Name)) or (not isCharacterOnScreen(char)) then
            continue
        end
        if char:FindFirstChild("HumanoidRootPart") then
            local playerPosition = char.HumanoidRootPart.Position
            local mousePosition = mouse.Hit.Position
            local distance = (mousePosition - playerPosition).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    return closestPlayer
end

mouse.Button1Down:Connect(function()
    if plr.Character:FindFirstChildOfClass("Tool") then
        local closestPlayer = getClosestPlayerToMouse()
        if closestPlayer then
            shootRemote:FireServer(Vector3.new(1,1,1), Vector3.new(1,1,1), closestPlayer.Character[r15BodyParts[math.random(1,#r15BodyParts)]], Vector3.new(1,1,1))
        end
    end
end)
