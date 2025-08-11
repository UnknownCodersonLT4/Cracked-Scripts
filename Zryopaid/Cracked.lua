local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/UnknownCodersonLT4/Cracked-Scripts/refs/heads/main/Zryopaid/ui.lua", true))()

local window = library:AddWindow("Luna Hub | Anti-Lag", {
    main_color = Color3.fromRGB(0, 0, 0),
    min_size = Vector2.new(562, 730),
    can_resize = true,
})

local tab = window:AddTab("Lag Reduction")
local section1 = tab:AddSection("Black Screen Mode")
local section2 = tab:AddSection("Performance Boost")
local section3 = tab:AddSection("Character Optimizer")

-- Anti-Lag Module
local AntiLag = {
    BlackGui = nil,
    Optimized = false
}

function AntiLag:EnableBlackScreen()
    -- Create fullscreen black frame
    if not self.BlackGui then
        self.BlackGui = Instance.new("ScreenGui")
        self.BlackGui.Name = "UltraBlackScreen"
        self.BlackGui.ResetOnSpawn = false
        self.BlackGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.BlackGui.Parent = game.CoreGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(10, 0, 10, 0)
        frame.Position = UDim2.new(-5, 0, -5, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BorderSizePixel = 0
        frame.ZIndex = 99999
        frame.Parent = self.BlackGui
    end

    -- Lighting optimizations
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    game:GetService("Lighting").Brightness = 0
end

function AntiLag:DisableBlackScreen()
    if self.BlackGui then
        self.BlackGui:Destroy()
        self.BlackGui = nil
        game:GetService("Lighting").Brightness = 1
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end

function AntiLag:OptimizeWorld()
    if self.Optimized then return end
    self.Optimized = true
    
    -- Graphics settings
    settings().Rendering.QualityLevel = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    
    -- Optimize workspace
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Material = Enum.Material.SmoothPlastic
            descendant.Reflectance = 0
        elseif descendant:IsA("ParticleEmitter") then
            descendant:Destroy()
        elseif descendant:IsA("Decal") then
            descendant.Transparency = 1
        end
    end
end

function AntiLag:OptimizeCharacter(char)
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.SmoothPlastic
            part.Reflectance = 0
        elseif part:IsA("ParticleEmitter") then
            part.Enabled = false
        end
    end
end

function AntiLag:ResetOptimizations()
    self.Optimized = false
    settings().Rendering.QualityLevel = 10
    game:GetService("RunService"):Set3dRenderingEnabled(true)
end

-- UI Elements
local blackScreenToggle = section1:AddSwitch("Black Screen Mode", function(state)
    if state then
        AntiLag:EnableBlackScreen()
    else
        AntiLag:DisableBlackScreen()
    end
end)

local worldOptimizeToggle = section2:AddSwitch("World Optimization", function(state)
    if state then
        AntiLag:OptimizeWorld()
    else
        AntiLag:ResetOptimizations()
    end
end)

local characterOptimizeToggle = section3:AddSwitch("Character Optimization", function(state)
    if state then
        AntiLag:OptimizeCharacter(game.Players.LocalPlayer.Character)
        game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
            AntiLag:OptimizeCharacter(char)
        end)
    end
end)

local fpsBoostBtn = section2:AddButton("Extreme FPS Boost", function()
    AntiLag:EnableBlackScreen()
    AntiLag:OptimizeWorld()
    game:GetService("RunService"):Set3dRenderingEnabled(false)
    
    -- Disable all sounds
    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Destroy()
        end
    end
    
    library:SendNotification("Extreme FPS Mode Activated", 5)
end)

local resetBtn = tab:AddButton("Reset All Optimizations", function()
    AntiLag:DisableBlackScreen()
    AntiLag:ResetOptimizations()
    blackScreenToggle:Set(false)
    worldOptimizeToggle:Set(false)
    characterOptimizeToggle:Set(false)
    library:SendNotification("All optimizations reset", 3)
end)

-- Initialize character optimization if enabled
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if characterOptimizeToggle:Get() then
        AntiLag:OptimizeCharacter(char)
    end
end)

-- Status label
local statusLabel = tab:AddLabel("Current Status: Inactive")
statusLabel:Update("Current Status: Monitoring")

-- Auto-update status
task.spawn(function()
    while task.wait(1) do
        local status = {}
        if AntiLag.BlackGui then table.insert(status, "Black Screen") end
        if AntiLag.Optimized then table.insert(status, "World Optimized") end
        if characterOptimizeToggle:Get() then table.insert(status, "Char Optimized") end
        
        if #status > 0 then
            statusLabel:Update("Current Status: "..table.concat(status, " | "))
        else
            statusLabel:Update("Current Status: Inactive")
        end
    end
end)
