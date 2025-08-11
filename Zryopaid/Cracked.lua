local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local BlackScreen = {}

function BlackScreen:Create()
    -- Create black screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlackScreenUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 999
    Frame.Parent = ScreenGui

    -- Optimize lighting
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 0
    settings().Rendering.QualityLevel = 1

    -- Remove unnecessary visual effects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        elseif effect:IsA("Sky") then
            effect:Destroy()
        end
    end

    -- Create optimized sky
    local newSky = Instance.new("Sky")
    newSky.SkyboxBk = "rbxassetid://0"
    newSky.SkyboxDn = "rbxassetid://0"
    newSky.SkyboxFt = "rbxassetid://0"
    newSky.SkyboxLf = "rbxassetid://0"
    newSky.SkyboxRt = "rbxassetid://0"
    newSky.SkyboxUp = "rbxassetid://0"
    newSky.Parent = Lighting

    -- Optimize character visuals
    local function optimizeCharacter(character)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.SmoothPlastic
                part.Reflectance = 0
            elseif part:IsA("ParticleEmitter") or part:IsA("Decal") then
                part:Destroy()
            end
        end
    end

    if LocalPlayer.Character then
        optimizeCharacter(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(optimizeCharacter)

    self.ScreenGui = ScreenGui
end

function BlackScreen:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- Restore some lighting settings
    Lighting.GlobalShadows = true
    Lighting.Brightness = 1
    settings().Rendering.QualityLevel = 10
end

return BlackScreen
