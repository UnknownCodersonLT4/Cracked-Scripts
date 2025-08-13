local spoofedUsername = "imyourGodbro4"
local spoofedWindowTitle = "Zyroo | Private Cracked by Henne LMFAO"

local zyrooLib
local loadSuccess, loadError = pcall(function()
    zyrooLib = loadstring(game:HttpGet("https://files.catbox.moe/88dz8c.txt", true))()
end)

if not loadSuccess then
    warn("Failed to load Zyroo lib:", loadError)
    zyrooLib = nil
end

if zyrooLib and zyrooLib.AddWindow then
    local originalAddWindow = zyrooLib.AddWindow
    zyrooLib.AddWindow = function(self, title, options)
        title = spoofedWindowTitle
        return originalAddWindow(self, title, options)
    end
    print("Window title spoofing activated!")
end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local gameMT = getrawmetatable(game)
setreadonly(gameMT, false)
local oldGameIndex = gameMT.__index

gameMT.__index = newcclosure(function(t, k)
    if t == lp and (k == "Name" or k == "Username") then
        return spoofedUsername
    end
    return oldGameIndex(t, k)
end)

setreadonly(gameMT, true)

local function loadModifiedScript()
    local success, scriptContent = pcall(function()
        return game:HttpGet("https://pastefy.app/mCTC42bW/raw", true)
    end)

    if success then
        local modifiedScript = scriptContent:gsub(
            'AddWindow%(%s*["\'](.-)["\']',
            'AddWindow("'..spoofedWindowTitle..'"'
        )
        
        local executeSuccess, err = pcall(loadstring(modifiedScript))
        if executeSuccess then
            print("External script loaded with title spoofing!")
        else
            warn("Failed to execute modified script:", err)
        end
    else
        warn("Failed to fetch external script:", scriptContent)
    end
end

loadModifiedScript()

task.wait(3)

if zyrooLib then
    local testWindow = zyrooLib:AddWindow("Verification Window", {
        main_color = Color3.fromRGB(138, 43, 226),
        min_size = Vector2.new(300, 200),
        can_resize = false
    })
    
    testWindow:AddLabel("Spoofing Status:")
    testWindow:AddLabel("Username: "..spoofedUsername)
    testWindow:AddLabel("Window Title: "..spoofedWindowTitle)
end

print("Spoofing complete!")
print("Username:", game.Players.LocalPlayer.Name)
