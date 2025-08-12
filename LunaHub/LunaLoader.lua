--[[
by Henne
]]

local spoofedUsername = "gorgeportabes"
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

local loadedScripts = {}

local function safeLoadString(url)
    if url == "https://pastebin.com/raw/6BCs7peN" then
        url = "https://raw.githubusercontent.com/imhenne187/cracking/refs/heads/main/LunaHub/LunaWhitelist.lua"
    elseif url == "https://raw.githubusercontent.com/SLH-Seth/LUNA-UI-LIBRARY/refs/heads/main/Code" then
        url = "https://raw.githubusercontent.com/imhenne187/cracking/refs/heads/main/LunaHub/LunaLibrary.lua"
    end

    if loadedScripts[url] then
        return
    end

    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and typeof(result) == "string" then
        loadedScripts[url] = true
        pcall(loadstring(result))
    end
end

safeLoadString("https://raw.githubusercontent.com/imhenne187/cracking/refs/heads/main/LunaHub/LunaHub.lua")
