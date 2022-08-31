repeat wait() until game:IsLoaded()
wait(0.5)
for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end

for i, v in pairs(game.ReplicatedStorage:GetDescendants()) do
	if v.Name:find("AAC") then
		v:Destroy() -- anticheat 
	end
end

for i, v in pairs(game.Workspace:GetChildren()) do -- anticheat
    if v.Name:find("Hollow0") or v.Name:find("Angel") or v.Name:find("HollowDeadly") or (v.Name:find("Hollow1") or v.Name:find("WoodlandHunter")) then
        v:Destroy()
    end
end

local lPlayer = game.Players.LocalPlayer

-- shit breaks when u let many enemy spawn while this is on cuz no distance check
local mobFarmEnabled = false
local function mobFarm()
	local list = {} -- fix
	while mobFarmEnabled do
		task.wait()
		for _, mob in ipairs(workspace:GetChildren()) do
			coroutine.wrap(function()
				if mob:FindFirstChild("EnemyMain") then
					if table.find(list, mob) then
						return
					else
						table.insert(list, mob)
					end
					local humanoid = mob:WaitForChild("Humanoid")
					while humanoid.Health > 0 and mobFarmEnabled do -- loop until mob is dead
						task.wait()
						local character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
						-- get any sword in your backpack or character
						local sword = lPlayer.Backpack:FindFirstChild("BladeMain", true) or character:FindFirstChild("BladeMain", true)
						if sword then
							sword = sword.Parent
							coroutine.wrap(function()
								pcall(function() -- fixes breaking after you die
									if sword.Parent ~= character then
										sword.Parent = character -- force equip it
									end
									local Distance = (lPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
									if Distance < 25 then --if distance between player1 and player2 is lower than 10
										sword.RemoteFunction:InvokeServer("hit", { humanoid, sword.Damage.Value })
									end
								end)
							end)()
						end
					end
					table.remove(list, table.find(list, mob))
				end
			end)()
		end
	end
end

-- damn why cant this things be as simple as getgenv
-- shit breaks when u die 

local bringFarmToggle = false
local function bringFarm()
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local bringList = {}
while bringFarmToggle do
	task.wait()
	for i,v in pairs(workspace:GetChildren()) do
		if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("EnemyMain") then
			coroutine.wrap(function()
				pcall(function()
                    local Character = Player.Character or Player.CharacterAdded:Wait()
                    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart",3)
                    if HumanoidRootPart then
					v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame*CFrame.new(0,0,-3)
				end
            end)
        end)()
    end
end
end
end


local teleportFarmToggle = false
local function teleportFarm()
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local teleportList = {}
while teleportFarmToggle do
    task.wait()
    for i,v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("EnemyMain") then
            coroutine.wrap(function()
                pcall(function()
                    local Character = Player.Character or Player.CharacterAdded:Wait()
                    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart",3)
                    if HumanoidRootPart then
                        HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame*CFrame.new(0,0,-4)
					end
				end)
			end)()
		end
	end
end
end


-- only shit that doesn't break
local godmodeHealEnabled = false
local function godmodeHeal()
	while godmodeHealEnabled do
		task.wait()
		while lPlayer.Backpack:FindFirstChild("Heal", true) or lPlayer.Character:FindFirstChild("Heal", true) do -- if any healing item is found then start
			task.wait()
			if not godmodeHealEnabled then
				return
			end
			-- get any healing item
			local heal = lPlayer.Backpack:FindFirstChild("Heal", true) or lPlayer.Character:FindFirstChild("Heal", true)
			if heal then -- I realize this is redundant because of the loop condition but whatever I was tired
				heal = heal.Parent
				coroutine.wrap(function() -- coroutine to do it as fast as the loop loops
					heal.RemoteFunction:InvokeServer("hit", { lPlayer.Character:WaitForChild("Humanoid"), heal.Heal.Value, lPlayer.Character:WaitForChild("Torso") })
				end)()
			end
		end
	end
end

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Lib
local mainWindow = library:CreateWindow({
	Name = "Balanced Craftwars Overhaul | RCtrl to toggle GUI",
	Themeable = false,
})
library.configuration.hideKeybind = Enum.KeyCode.RightControl
local mainTab = mainWindow:CreateTab({ Name = "Main" })
local mobFarmSection = mainTab:CreateSection({ Name = "Mob Farm", Side = "Left" })
local mobFarmToggle = mobFarmSection:CreateToggle({
	Name = "Kill Aura",
	Callback = function(v)
		mobFarmEnabled = v
		if v then
			coroutine.wrap(mobFarm)()
		end
	end,
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local teleportFarmToggle = mobFarmSection:CreateToggle({
	Name = "Teleport Mob",
	Callback = function(v)
		teleportFarmToggle = v
		if v and Player.Character or Player.CharacterAdded:Wait(1) then
			pcall(function()
		    coroutine.wrap(teleportFarm)()
			end)
		end
	end,
})

local autoattackToggle = false
local function attack()
	while autoattackToggle do
		wait(0.2) -- perfect wait timing
		local user = game:GetService("VirtualUser") -- auto attack
		local player = game.Players.LocalPlayer
		local mouse = player:GetMouse()
		user:CaptureController()
		user:ClickButton1(Vector2.new(mouse.x,mouse.y))
	end
end
local autoattackToggle = mobFarmSection:CreateToggle({
	Name = "Auto Attack",
	Callback = function(v)
		autoattackToggle = v
		if v then
			coroutine.wrap(attack)()
		end
	end,
})

local anchorToggle = false
local function anchor()
local anchor = {}
while anchorToggle do
    task.wait()
	for i, v in pairs(game.Workspace:GetDescendants()) do
		if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("EnemyMain") then
			v.HumanoidRootPart.Anchored = true
			if anchorToggle == false then
			    v.HumanoidRootPart.Anchored = false
			end
		end
	end
end
end

local anchorToggle = mobFarmSection:CreateToggle({
	Name = "Anchor Mob",
	Callback = function(v)
		anchorToggle = v
		if v then
			pcall(function()
		    coroutine.wrap(anchor)()
		end)
	end
	end,
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local bringFarmToggle = mobFarmSection:CreateToggle({
	Name = "Bring Mob",
	Callback = function(v)
		bringFarmToggle = v
		if v and Player.Character or Player.CharacterAdded:Wait(1) then
			pcall(function()
		    coroutine.wrap(bringFarm)()
		end)
	end
	end,
})

local lPlayer = game.Players.LocalPlayer
local damageToggle = false
local function damage()
	local list = {} -- fix
	while damageToggle do
		task.wait()
		for _, mob in ipairs(workspace:GetChildren()) do
			coroutine.wrap(function()
				if mob:FindFirstChild("EnemyMain") then
					if table.find(list, mob) then
						return
					else
						table.insert(list, mob)
					end
					local humanoid = mob:WaitForChild("Humanoid")
					while humanoid.Health > 0 and damageToggle do -- loop until mob is dead
						task.wait()
						local character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
						-- get any sword in your backpack or character
						local sword = lPlayer.Backpack:FindFirstChild("BladeMain", true) or character:FindFirstChild("BladeMain", true)
						if sword then
							sword = sword.Parent
							coroutine.wrap(function()
								pcall(function() -- fixes breaking after you die
									if sword.Parent ~= character then
										sword.Parent = character -- force equip it
									end
									for i = 1, 10 do
									local Distance = (lPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
									if Distance < 25 then --if distance between player1 and player2 is lower than 10
										sword.RemoteFunction:InvokeServer("hit", { humanoid, sword.Damage.Value })
									end
								end
								end)
							end)()
						end
					end
					table.remove(list, table.find(list, mob))
				end
			end)()
		end
	end
end

local eggFarmSection = mainTab:CreateSection({ Name = "Misc", Side = "Right" })

local damageToggle = eggFarmSection:CreateToggle({
	Name = "Damage Multiplier",
	Callback = function(v)
		damageToggle = v
		if v then
			coroutine.wrap(damage)()
		end
	end,
})


local noclipfloatToggle = false
local function noclipfloat()
local noclipfix = {}
while noclipfloatToggle do
	wait()
		local Players, Player = game:GetService("Players"), game:GetService("Players").LocalPlayer
		getgenv().FuckYouSkid = true
		getgenv().NoPlatformNoclip = true
		getgenv().CanCollide = true
		if noclipfloatToggle == false then
		getgenv().FuckYouSkid = false
		getgenv().NoPlatformNoclip = false
		getgenv().CanCollide = false
	end

	if setfflag then
		setfflag("HumanoidParallelRemoveNoPhysics", "False")
		setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
	end

	game:GetService("RunService").Stepped:Connect(
		function()
			wait() -- fixed the lagging fucking shit
			if getgenv().FuckYouSkid then
				for i, v in pairs(Player.Character:GetChildren()) do
					if v:IsA("BasePart") and getgenv().CanCollide then
						v.CanCollide = false
					elseif v:IsA("Humanoid") and getgenv().NoPlatformNoclip then
						v:ChangeState(11)
					end
				end
			end
		end
	)
end
end
local noclipfloatToggle = eggFarmSection:CreateToggle({
	Name = "Noclip - Float",
	Callback = function(v)
		noclipfloatToggle = v
		if v then
		    coroutine.wrap(noclipfloat)()
		end
	end,
})

local freezeToggle = false
local function freezing()
	local freeze = {}
	while freezeToggle do
		wait() -- task.wait fucks it
		for i, v in pairs(game.Workspace:GetDescendants()) do
			game.Players.LocalPlayer.Character.Head.Anchored = true
			if freezeToggle == false then
				game.Players.LocalPlayer.Character.Head.Anchored = false
			end
		end
	end
end
local freezeToggle = eggFarmSection:CreateToggle({
	Name = "Freeze - Anchor",
	Callback = function(v)
		freezeToggle = v
		if v then
			pcall(function()
		    coroutine.wrap(freezing)()
		end)
	end
end,
})

-- more better than flying in this game | servers as an anti stun | anti fling
eggFarmSection:AddButton({
	Name = "InfiniteJump",
	Callback = function(v)
		local InfiniteJumpEnabled = true
		game:GetService("UserInputService").JumpRequest:connect(function()
			if InfiniteJumpEnabled then
				game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
			end
		end)
	end
})
eggFarmSection:AddButton({
	Name = "Fullbright",
	Callback = function(v)
        game.Lighting.GlobalShadows = true
        game.Lighting.Ambient = Color3.new(1,1,1)
        game.Lighting.FogEnd = 1000000
    end
})
-- Fpscounter by DekuDimz
eggFarmSection:AddButton({
	Name = "Fpscounter",
	Callback = function(v)

repeat wait() until game:IsLoaded() wait(2)
local ScreenGui = Instance.new("ScreenGui")
local Fps = Instance.new("TextLabel")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Fps.Name = "Fps"
Fps.Parent = ScreenGui
Fps.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Fps.BackgroundTransparency = 1.000
Fps.Position = UDim2.new(0.0, 0, 0, 900)
Fps.Size = UDim2.new(0, 125, 0, 25)
Fps.Font = Enum.Font.SourceSans
Fps.TextColor3 = Color3.fromRGB(255, 255, 255)
Fps.TextScaled = true
Fps.TextSize = 14.000
Fps.TextWrapped = true
-- Scripts:
local script = Instance.new('LocalScript', Fps)
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function(frame) -- This will fire every time a frame is rendered
script.Parent.Text = ("FPS: "..math.round(1/frame)) 
end)
end
})
-- Fpsbooster by e261
eggFarmSection:AddButton({
	Name = "Fpsbooster",
	Callback = function(v)
		repeat wait() until game:IsLoaded()
local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
sethiddenproperty(l,"Technology",2)
sethiddenproperty(t,"Decoration",false)
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = 0
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i, v in pairs(w:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") and decalsyeeted then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    elseif v:IsA("SpecialMesh") and decalsyeeted  then
        v.TextureId=0
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.Graphic=0
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"]=0
    end
end
for i = 1,#l:GetChildren() do
    e=l:GetChildren()[i]
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end
w.DescendantAdded:Connect(function(v)
    wait()--prevent errors and shit
   if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") and decalsyeeted then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    elseif v:IsA("SpecialMesh") and decalsyeeted then
        v.TextureId=0
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.ShirtGraphic=0
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"]=0
    end
end)
end
})

-- Serverhop by CharWars
eggFarmSection:AddButton({
	Name = "Serverhop",
	Callback = function(v)
		local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
Teleport()
	end
})

eggFarmSection:AddButton({
	Name = "Btools",
	Callback = function(v)
		local tool1 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
		local tool2 = Instance.new("HopperBin",game.Players.LocalPlayer.Backpack)
		tool1.BinType = "Clone"
		tool2.BinType = "Hammer"
	end
})

-- this ui loops whatever inside this shit so walkspeed is futile in this game
eggFarmSection:AddSlider({
	Name = "Walkspeed",
	Flag = "eggFarmSection",
	Value = game:service('Players').LocalPlayer.Character.Humanoid.WalkSpeed,
	Min = 0,
	Max = 500,
	Format = function(Value)
	    game:service('Players').LocalPlayer.Character.Humanoid.WalkSpeed = Value
		if Value == 0 then
			return "WalkSpeed: nil"
			else
				return "WalkSpeed: " .. tostring(Value)
			end
		end
})

-- this ui loops whatever inside this shit so walkspeed is futile in this game
eggFarmSection:AddSlider({
	Name = "JumpHeight",
	Flag = "eggFarmSection",
	Value = game:service('Players').LocalPlayer.Character.Humanoid.JumpPower,
	Min = 0,
	Max = 500,
	Format = function(Value)
	    game:service('Players').LocalPlayer.Character.Humanoid.JumpPower = Value
		if Value == 0 then
			return "JumpHeight: nil"
			else
				return "JumpHeight: " .. tostring(Value)
			end
		end
})

local godmodeSection = mainTab:CreateSection({ Name = "Godmodes / Semi-Godmodes", Side = "Left" })
local godmodeHealToggle = godmodeSection:CreateToggle({
	Name = "Any Healing Staff",
	Callback = function(v)
		godmodeHealEnabled = v
		if v then
			coroutine.wrap(godmodeHeal)()
		end
	end,
})

local instructions2 = godmodeSection:CreateLabel({
	Name = "You need the items below", 
})
-- 8/20/2022
-- all shit below breaks when u die
local godmodetitanToggle = false
local function godmodetitan()
    while godmodetitanToggle do task.wait()
        while lPlayer.Backpack:FindFirstChild("Titanstone Potion", true) or lPlayer.Character:FindFirstChild("Titanstone Potion", true) do
            if not godmodetitanToggle then return end
            local revenge = lPlayer.Backpack:FindFirstChild("Titanstone Potion", true) or lPlayer.Character:FindFirstChild("Titanstone Potion", true)
            if revenge then
                coroutine.wrap(function()
                    pcall(function()
                        revenge.RemoteFunction:InvokeServer("inserteffect", game:GetService("Players").LocalPlayer.Character)
                    end)
                end)()
            end
            task.wait(1)
        end
    end
end

local godmodetitanToggle = godmodeSection:CreateToggle({
	Name = "Titanstone Potion",
	Callback = function(v)
		godmodetitanToggle = v
		if v then
			coroutine.wrap(godmodetitan)()
		end
	end,
})

local godmoderageToggle = false
local function godmoderage()
    while godmoderageToggle do task.wait()
        while lPlayer.Backpack:FindFirstChild("Atrocitus' Rage", true) or lPlayer.Character:FindFirstChild("Atrocitus' Rage", true) do
            if not godmoderageToggle then return end
            local revenge = lPlayer.Backpack:FindFirstChild("Atrocitus' Rage", true) or lPlayer.Character:FindFirstChild("Atrocitus' Rage", true)
            if revenge then
                coroutine.wrap(function()
                    pcall(function()
                        revenge.RemoteFunction:InvokeServer("inserteffect", game:GetService("Players").LocalPlayer.Character)
                    end)
                end)()
            end
            task.wait(1)
        end
    end
end
local godmoderageToggle = godmodeSection:CreateToggle({
	Name = "Atrocitus' Rage",
	Callback = function(v)
		godmoderageToggle = v
		if v then
			coroutine.wrap(godmoderage)()
		end
	end,
})
local godmodetitanToggle = false
local function godmodetitan()
    while godmodetitanToggle do task.wait()
        while lPlayer.Backpack:FindFirstChild("Titanstone Potion", true) or lPlayer.Character:FindFirstChild("Titanstone Potion", true) do
            if not godmodetitanToggle then return end
            local revenge = lPlayer.Backpack:FindFirstChild("Titanstone Potion", true) or lPlayer.Character:FindFirstChild("Titanstone Potion", true)
            if revenge then
                coroutine.wrap(function()
                    pcall(function()
                        revenge.RemoteFunction:InvokeServer("inserteffect", game:GetService("Players").LocalPlayer.Character)
                    end)
                end)()
            end
            task.wait(1)
        end
    end
end

local natureToggle = false
local function nature()
    while natureToggle do task.wait()
        while lPlayer.Backpack:FindFirstChild("Nature's Brew", true) or lPlayer.Character:FindFirstChild("Nature's Brew", true) do
            if not natureToggle then return end
            local revenge = lPlayer.Backpack:FindFirstChild("Nature's Brew", true) or lPlayer.Character:FindFirstChild("Nature's Brew", true)
            if revenge then
                coroutine.wrap(function()
                    pcall(function()
                        revenge.RemoteFunction:InvokeServer("inserteffect", game:GetService("Players").LocalPlayer.Character)
                    end)
                end)()
            end
            task.wait(1)
        end
    end
end

local natureToggle = godmodeSection:CreateToggle({
	Name = "Nature's Brew",
	Callback = function(v)
		natureToggle = v
		if v then
			coroutine.wrap(nature)()
		end
	end,
})

local miscSection = mainTab:CreateSection({ Name = "Discord", Side = "Right" }) local Label = miscSection:CreateButton({ 
    Name = "Server: xTTjhJb7Hp",
	Callback = function(v)
		setclipboard("https://discord.com/invite/xTTjhJb7Hp")
	end
})



local instructions3 = miscSection:Label({
	Name = "Script by Zero2"
})
local instructions4 = miscSection:Label({
    Name = "UI by Pepsi"
})
spawn(function()
    for i, v in pairs(game:GetService("Workspace").Map.Ores:GetChildren()) do -- delete anticheat mob
        if v:IsA("Model") then
            v:Destroy()
        end
    end
end)
local lPlayer = game.Players.LocalPlayer
local oreFolder = workspace:FindFirstChild("Mine") or workspace:FindFirstChild("Ores", true)
local oreList = {}
local oreListMode = "Whitelist"
local oreFarmEnabled = false
local function oreFarm()
	while oreFarmEnabled do
		task.wait()
		local function mine(ore)
			if ore:IsA("Model") and ore:FindFirstChild("MineralMain") then
				-- all this crap to make sure the ore is loaded before trying to mine it
				local properties = ore:WaitForChild("Properties")
				local hitpoints = properties:WaitForChild("Hitpoint")
				local toughness = properties:WaitForChild("Toughness")
				local owner = properties:WaitForChild("Owner")
				-- get any pickaxe in your backpack or character
				local pickaxe = lPlayer.Backpack:FindFirstChild("PickaxeControl", true) or lPlayer.Character:FindFirstChild("PickaxeControl", true)
				local character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
				local rPart = character:WaitForChild("HumanoidRootPart")
				if pickaxe then
					pickaxe = pickaxe.Parent
					local power = pickaxe:WaitForChild("Power")
					if toughness.Value <= power.Value then -- can't mine ores higher than your pickaxe level
						local oldPosition = rPart.CFrame -- save old position
						workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable -- freeze camera
						while hitpoints.Value > 0 do -- loop until ore is mined
							task.wait()
							coroutine.wrap(function()
								if pickaxe.Parent ~= character then
									pickaxe.Parent = character -- force equip it
								end
								rPart.CFrame = ore.Base.CFrame - Vector3.new(0, 5, 0) -- tp to the ore
								pickaxe.RemoteFunction:InvokeServer("hit", { hitpoints, toughness, owner })
							end)()
						end
						workspace.CurrentCamera.CameraType = Enum.CameraType.Custom -- unfreeze the camera
						pickaxe.Parent = lPlayer.Backpack -- unequip it
						rPart.CFrame = oldPosition -- go back to old position
                        if oreFarmEnabled == false then game.Players.LocalPlayer.Character.Humanoid.Health = 0
                        end
                    end
                end
            end
        end
		-- this is self-explanatory
		for _, ore in pairs(oreFolder:GetChildren()) do
			if oreListMode == "Whitelist" then
				if table.find(oreList, ore.Name) then
					mine(ore)
				end
			elseif oreListMode == "Blacklist" then
				if not table.find(oreList, ore.Name) then
					mine(ore)
				end
			end
		end
	end
end

local oreFarmSection = mainTab:CreateSection({ Name = "Ore Farm", Side = "Left" })
local oreFarmToggle = oreFarmSection:CreateToggle({
	Name = "Enabled",
	Callback = function(v)
		oreFarmEnabled = v
		if v then
			coroutine.wrap(oreFarm)()
		end
	end,
})

local oreFarmListMode = oreFarmSection:AddDropdown({
	Name = "List Mode",
	List = { "Whitelist", "Blacklist" },
	Callback = function(v)
		oreListMode = v
	end,
})
local oreFarmList = oreFarmSection:AddDropdown({
	Name = "Ore List",
	Multi = true,
	List = {
		"Crystal",
		"Iron",
		"Gold",
		"Diamond",
		"Cobalt",
		"Viridis",
		"Oureclasium",
		"Tungsten",
		"Titanium",
		"Mithril",
		"Adamantine",
		"Titanstone",
		"Gemstone of Purity",
		"Gemstone of Hatred",
		"Purite",
		"Hatrite",
		"Hevenite",
		"Moonstone",
		"Hellite",
		"Forbidden Crystal",
        "Astral Silver",
        "Duranite",
	},
	Callback = function(v)
		oreList = v
	end,
})
-- laggy ass sunken set and ocean set armour
oreFarmSection:AddButton({
	Name = "BeneathTeleporter",
	Callback = function(v)
        game:GetService("Workspace").Map.BeneathTeleporter.RemoteFunction:InvokeServer("Confirm")
    end
})

local randomSection = mainTab:CreateSection({ Name = "Killaura", Side = "Left" })
local randomToggle = false
local function r1()
    while randomToggle do task.wait()
        while lPlayer.Backpack:FindFirstChild("Atlarus Carpcalibur", true) or lPlayer.Character:FindFirstChild("Atlarus Carpcalibur", true) do
            if not randomToggle then return end
            local revenge = lPlayer.Backpack:FindFirstChild("Atlarus Carpcalibur", true) or lPlayer.Character:FindFirstChild("Atlarus Carpcalibur", true)
            if revenge then
                coroutine.wrap(function()
                    pcall(function()
						local A_2 = {
							[1] = 3, 
							[2] = 1
						}
                        revenge.RemoteFunction:InvokeServer("hit", A_2)
                    end)
                end)()
            end
            task.wait()
        end
    end
end

local randomToggle2 = false
local function r2()
		while randomToggle2 do
			task.wait()
			for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
				if v.name == "Atlarus Carpcalibur" then
				    if randomToggle2 == true then repeat
				        task.wait()
						v.Parent = game.Players.LocalPlayer.Character
					until randomToggle2 == false
				end
			end
		end
end
end

local randomToggle = randomSection:CreateToggle({
	Name = "Atlarus Carpcalibur",
	Callback = function(v)
		randomToggle = v
		if v then
		    coroutine.wrap(r1)()
		end
	end,
})
local randomToggle2 = randomSection:CreateToggle({
	Name = "Equip",
	Callback = function(v)
		randomToggle2 = v
		if v then
		    coroutine.wrap(r2)()
		end
	end,
})


