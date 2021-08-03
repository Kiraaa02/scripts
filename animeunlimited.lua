-- No security games is so fun
while Wait() do
if getgenv().treasure == false then break end
for i,v in pairs(game:GetService("Workspace").Treasure:GetDescendants()) do
if v:IsA("ClickDetector") then
fireclickdetector(v)
end
end
end