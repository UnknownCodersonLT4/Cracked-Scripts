-- Fixed Anti-Lag Script with Proper UI Implementation
local success, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/SLH-Seth/LUNA-UI-LIBRARY/refs/heads/main/Code", true))()
end)

if not success then
    warn("Failed to load Luna UI Library")
    return
end

local window = library:AddWindow("Anti-Lag Pro", {
    main_color = Color3.fromRGB(25, 25, 25),
    min_size = Vector2.new(450, 500),
    can_resize = true
})

-- Main Tab
local mainTab = window:AddTab("Main")
local blackScreenSection = mainTab:AddSection("Black Screen", true)
local worldSection = mainTab:AddSection("World Optimization", true)
local charSection = mainTab:AddSection("Character Optimization", true)
local extrasSection = mainTab:AddSection("Extras", true)

-- Anti-Lag System
local AntiLag = {
    BlackScreen = {
        Enabled = false,
        Gui = nil
    },
    WorldOptimized = false,
    CharOptimized = false
}

-- Black Screen Functions
function AntiLag:ToggleBlackScreen(state)
    if state then
        -- Create black screen
        self.BlackScreen.Gui = Instance.new("ScreenGui")
        self.BlackScreen.Gui.Name = "AntiLagBlackScreen"
        self.BlackScreen.Gui.ResetOnSpawn = false
        self.BlackScreen.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.BlackScreen.Gui.Parent = game:GetService("CoreGui")
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.Position = UDim2.new(0, 0, 0, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BorderSizePixel = 0
        frame.ZIndex = 999
        frame.Parent = self.BlackScreen.Gui
        
        -- Optimize lighting
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Brightness = 0
        self.BlackScreen.Enabled = true
    else
        -- Remove black screen
        if self.BlackScreen.Gui then
            self.BlackScreen.Gui:Destroy()
        end
        game:GetService("Lighting").Brightness = 1
        self.BlackScreen.Enabled = false
    end
end

-- World Optimization
function AntiLag:OptimizeWorld(state)
    if state then
        settings().Rendering.QualityLevel = 1
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj:Destroy()
            elseif obj:IsA("Decal") then
                obj.Transparency = 1
            end
        end
        self.WorldOptimized = true
    else
        settings().Rendering.QualityLevel = 10
        self.WorldOptimized = false
    end
end

-- Character Optimization
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

-- UI Elements
local blackScreenToggle = blackScreenSection:AddSwitch("Black Screen", false, function(state)
    AntiLag:ToggleBlackScreen(state)
end)

local worldOptimizeToggle = worldSection:AddSwitch("World Optimization", false, function(state)
    AntiLag:OptimizeWorld(state)
end)

local charOptimizeToggle = charSection:AddSwitch("Character Optimization", false, function(state)
    AntiLag.CharOptimized = state
    if state then
        AntiLag:OptimizeCharacter(game.Players.LocalPlayer.Character)
    end
end)

-- Character added event
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if AntiLag.CharOptimized then
        AntiLag:OptimizeCharacter(char)
    end
end)

-- Extreme FPS Mode
extrasSection:AddButton("Extreme FPS Mode", function()
    blackScreenToggle:Set(true)
    worldOptimizeToggle:Set(true)
    charOptimizeToggle:Set(true)
    
    -- Additional optimizations
    game:GetService("RunService"):Set3dRenderingEnabled(false)
    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Destroy()
        end
    end
end)

-- Reset Button
extrasSection:AddButton("Reset All", function()
    blackScreenToggle:Set(false)
    worldOptimizeToggle:Set(false)
    charOptimizeToggle:Set(false)
    game:GetService("RunService"):Set3dRenderingEnabled(true)
end)

-- Status Label
local statusLabel = mainTab:AddLabel("Status: Inactive")

-- Update status
task.spawn(function()
    while task.wait(0.5) do
        local status = {}
        if AntiLag.BlackScreen.Enabled then table.insert(status, "Black Screen") end
        if AntiLag.WorldOptimized then table.insert(status, "World Opt") end
        if AntiLag.CharOptimized then table.insert(status, "Char Opt") end
        
        if #status > 0 then
            statusLabel:Update("Status: "..table.concat(status, " | "))
        else
            statusLabel:Update("Status: Inactive")
        end
    end
end)
