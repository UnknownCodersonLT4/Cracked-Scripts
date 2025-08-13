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


local realLibrary
local function hookLibrary()
    if not library or not library.AddWindow then 
        task.wait(1)
        return hookLibrary()
    end
    
    realLibrary = library
    local realAddWindow = library.AddWindow
    library.AddWindow = function(self, title, ...)
        title = spoofedWindowTitle
        return realAddWindow(self, title, ...)
    end
    print("Window title spoofing activated!")
end


local function loadModifiedScript()
    local success, scriptContent = pcall(function()
        return game:HttpGet("https://pastefy.app/mCTC42bW/raw", true)
    end)

    if success then
        local executeSuccess, err = pcall(loadstring(scriptContent))
        if executeSuccess then
            print("External script loaded!")
            hookLibrary() 
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
