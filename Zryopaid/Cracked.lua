-- loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()

--[[
by Henne
Single loader with spoof + replacement
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


local function safeLoadString(url)
    local ok, res = pcall(function()
        local code = game:HttpGet(url)
        code = code:gsub("Zyroo | Private", "cracked? by Ilias discord.gg/w2XcZQeANj")
        loadstring(code)()
    end)
    if not ok then
        warn("Failed to load:", url, res)
    end
end

safeLoadString("https://pastefy.app/mCTC42bW/raw")
print("loaded")
