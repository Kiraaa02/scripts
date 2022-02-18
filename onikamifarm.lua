while Wait(0.1) do
if getgenv().treasure == false then break end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1122.8292236328125, 212.28228759765625, -1751.1221923828125)
    local A_2 = "LetterQuestGuy"
    local Event = game:GetService("ReplicatedStorage").Remotes.GiverQuest
    Event:FireServer(A_2)
task.wait(1)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(265.4073791503906, 252.47171020507812, -2272.247802734375)
    local A_1 = "LetterQuest"
    local Event = game:GetService("ReplicatedStorage").Remotes.GiverQuest
    Event:FireServer(A_1)
task.wait(1)
end
