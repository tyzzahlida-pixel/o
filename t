-- Place this script inside a LocalScript in StarterPlayerScripts

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local hitboxSizeMultiplier = 2 -- Multiplier for hitbox size
local fovValue = 300 -- Initial FOV
local fovMin = 0
local fovMax = 600
local fovEnabled = true

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local FOVButton = Instance.new("TextButton")
FOVButton.Size = UDim2.new(0, 130, 0, 30)
FOVButton.Position = UDim2.new(0, 10, 0, 10)
FOVButton.Text = "FOV ON"
FOVButton.Parent = ScreenGui

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0, 150, 0, 30)
FOVLabel.Position = UDim2.new(0, 10, 0, 50)
FOVLabel.Text = "FOV: " .. fovValue
FOVLabel.Parent = ScreenGui

-- Function to toggle FOV
local function toggleFOV()
    fovEnabled = not fovEnabled
    FOVButton.Text = fovEnabled and "FOV ON" or "FOV OFF"
end

FOVButton.MouseButton1Click:Connect(toggleFOV)

-- Function to adjust FOV
local function adjustFOV(delta)
    fovValue = math.clamp(fovValue + delta, fovMin, fovMax)
    FOVLabel.Text = "FOV: " .. fovValue
end

-- Key bindings for FOV adjustment
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Up then
            adjustFOV(10)
        elseif input.KeyCode == Enum.KeyCode.Down then
            adjustFOV(-10)
        end
    end
end)

-- Increase hitbox size
local function resizeHitboxes(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * hitboxSizeMultiplier
        end
    end
end

-- When character spawns, resize hitboxes
Player.CharacterAdded:Connect(function(character)
    -- Wait for parts to load
    wait(1)
    resizeHitboxes(character)
end)

-- For existing character
if Player.Character then
    resizeHitboxes(Player.Character)
end

-- Modify camera FOV dynamically
RunService.RenderStepped:Connect(function()
    if fovEnabled then
        Camera.FieldOfView = fovValue
    end
end)