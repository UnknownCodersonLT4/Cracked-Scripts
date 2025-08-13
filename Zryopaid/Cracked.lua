local spoofedUsername = "imyourGodbro4"
local spoofedWindowTitle = "Zyroo | Private Cracked by Henne LMFAO"

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
            'AddWindow%s*%(%s*["\']Zyroo%s*|%s*Private["\']%s*,',
            'AddWindow("'..spoofedWindowTitle..'",'
        )
        
        local executeSuccess, err = pcall(loadstring(modifiedScript))
        if executeSuccess then
            print("Script loaded with title spoofing!")
        else
            warn("Execution error:", err)
        end
    else
        warn("Download error:", scriptContent)
    end
end

loadModifiedScript()

task.wait(3)

print("Spoofing active!")
print("Username:", game.Players.LocalPlayer.Name)
