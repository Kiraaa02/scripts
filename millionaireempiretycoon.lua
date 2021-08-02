getgenv().magic = true;

while Wait() do
if getgenv().magic == false then break end
game:GetService("ReplicatedStorage").updateCollector:FireServer(1e18)
game:GetService("ReplicatedStorage").rebirthEvent:FireServer()
for i,v in pairs(workspace:GetDescendants()) do
   if v.Name == "Giver" and v:FindFirstChild("TouchInterest") then
       firetouchinterest(v,game.Players.LocalPlayer.Character.HumanoidRootPart,0)
       wait()
       firetouchinterest(v,game.Players.LocalPlayer.Character.HumanoidRootPart,1)
   end
end
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetDescendants()) do
v:Destroy()
end
end