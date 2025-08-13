local spoofedUsername = "imyourGodbro4"
local spoofedWindowTitle = "Zyroo | Private Cracked by Henne LMFAO"


local library = loadstring(game:HttpGet("https://files.catbox.moe/88dz8c.txt", true))()


local realAddWindow = library.AddWindow
library.AddWindow = function(self, title, options)
    title = spoofedWindowTitle 
    return realAddWindow(self, title, options)
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


local SAVE_FILE = "Zyroo_AutoKiller.txt"
getgenv().AutoKiller = false

if isfile(SAVE_FILE) then
    getgenv().AutoKiller = readfile(SAVE_FILE) == "true"
end


local window = library:AddWindow("Zyroo | Private", { 
    main_color = Color3.fromRGB(138, 43, 226),
    min_size = Vector2.new(564, 680), 
    can_resize = true, 
})


print("Spoofed window title:", window.Title) 
