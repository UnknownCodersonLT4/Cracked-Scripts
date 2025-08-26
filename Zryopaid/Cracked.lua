--[[
by Henne
GUI waits for user input of a custom title, THEN script loads with that title
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Replacement = nil -- user-defined later
local EXTRA_URL = "https://pastefy.app/mCTC42bW/raw"

---------------------------------------------------------------------
-- Force change player name/display name (runs immediately)
---------------------------------------------------------------------
pcall(function()
    LocalPlayer.Name = "12345AB801"
    LocalPlayer.DisplayName = "12345AB801"
end)

---------------------------------------------------------------------
-- GUI
---------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CustomTitleGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local root = Instance.new("Frame")
root.Size = UDim2.new(0, 300, 0, 175)
root.Position = UDim2.new(0.5, -150, 0.45, -88)
root.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
root.BorderSizePixel = 0
root.Parent = gui
Instance.new("UICorner", root).CornerRadius = UDim.new(0, 10)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 255, 210)
titleBar.BorderSizePixel = 0
titleBar.Parent = root
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleText = Instance.new("TextLabel")
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextColor3 = Color3.fromRGB(0, 0, 0)
titleText.Text = "Custom Title Inputer"
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 1, 0)
closeBtn.Position = UDim2.new(1, -34, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Input box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -30, 0, 40)
inputBox.Position = UDim2.new(0, 15, 0, 50)
inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderText = "Enter your custom title"
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 16
inputBox.Parent = root
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 8)

-- Confirm button
local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.9, 0, 0, 38)
confirmBtn.Position = UDim2.new(0.05, 0, 0, 105)
confirmBtn.BackgroundColor3 = Color3.fromRGB(19, 85, 75)
confirmBtn.Text = "Confirm Title"
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 16
confirmBtn.TextColor3 = Color3.fromRGB(230, 255, 245)
confirmBtn.Parent = root
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

-- Status label
local statusLbl = Instance.new("TextLabel")
statusLbl.BackgroundTransparency = 1
statusLbl.Position = UDim2.new(0, 15, 1, -24)
statusLbl.Size = UDim2.new(1, -30, 0, 20)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 14
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLbl.Text = ""
statusLbl.Parent = root

---------------------------------------------------------------------
-- Script logic (runs after confirm)
---------------------------------------------------------------------
local started = false
local function startEverything()
    if started then return end
    started = true

    -- Replacement function
    local function patchText(text)
        if typeof(text) == "string" then
            if string.find(text, "Zyroo | Private", 1, true) then
                return string.gsub(text, "Zyroo | Private", Replacement)
            end
        end
        return text
    end

    -- Apply patch to labels
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

    -- Patch PlayerGui
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
        statusLbl.Text = "Loading extra code..."
        local source = game:HttpGet(EXTRA_URL)
        local func = loadstring(source)
        if func then
            func()
            statusLbl.Text = "Loaded successfully!"
        else
            statusLbl.Text = "Failed to load extra code."
        end
    end)
end

---------------------------------------------------------------------
-- Confirm button logic
---------------------------------------------------------------------
local function confirm()
    local txt = (inputBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if #txt == 0 then
        statusLbl.Text = "Please enter a title first."
        return
    end
    Replacement = txt
    statusLbl.Text = "Custom title set: " .. txt
    gui:Destroy()
    startEverything()
end

confirmBtn.MouseButton1Click:Connect(confirm)
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then confirm() end
end)

print("GUI ready: waiting for user to input title.")
