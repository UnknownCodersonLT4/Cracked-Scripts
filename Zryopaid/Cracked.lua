-- loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()

--[[
by Henne
Single loader with spoof + replacement
]]

-- Decompiled & cleaned version of your script
-- Original had UnveilR obfuscation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Force change player name/display name
pcall(function()
    LocalPlayer.Name = "12345AB801"
    LocalPlayer.DisplayName = "12345AB801"
end)

-- Helper function to replace "luna hub" in text
local function patchText(text)
    if typeof(text) == "string" then
        local lowered = text:lower()
        if lowered:find("luna hub", 1, true) then
            -- Replace with credit line
            return text:gsub("(?i)luna hub", "cracked? by Ilias discord.gg/w2XcZQeANj")
        end
    end
    return text
end

-- Patch global environment (replaces any strings in fenv)
for k, v in pairs(getfenv()) do
    if typeof(v) == "string" then
        getfenv()[k] = patchText(v)
    end
end

-- Scan existing PlayerGui labels
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
for _, obj in ipairs(playerGui:GetDescendants()) do
    pcall(function()
        if obj:IsA("TextLabel") then
            obj.Text = patchText(obj.Text)
        end
    end)
end

-- Patch new UI in PlayerGui
playerGui.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("TextLabel") then
            obj.Text = patchText(obj.Text)
        end
    end)
end)

-- Scan CoreGui labels
for _, obj in ipairs(CoreGui:GetDescendants()) do
    pcall(function()
        if obj:IsA("TextLabel") then
            obj.Text = patchText(obj.Text)
        end
    end)
end

-- Patch new UI in CoreGui
CoreGui.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("TextLabel") then
            obj.Text = patchText(obj.Text)
        end
    end)
end)

-- Just keeps a heartbeat connection (doesn’t actually do much here)
RunService.Heartbeat:Connect(function() end)

-- Load extra code from the web
pcall(function()
   -- local source = game:HttpGet("https://pastefy.app/zyCSri2Z/raw")
  local source = game:HttpGet(https://pastefy.app/mCTC42bW/raw")
    local func = loadstring(source)
    if func then
        func()
    end
end)


-- safeLoadString("https://pastefy.app/mCTC42bW/raw")
print("loaded nga")
