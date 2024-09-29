-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Doors.lua"))()
-- Chest_Vine ActivateEventPrompt
game.StarterGui:SetCore("ResetButtonCallback", true);
local function send(message)
	require(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption(message, nil, 5);
end
local function sendchat(message)
	game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(message);
end
if myowndoorsscript then send("nuh uh") return end
local ws = workspace;
local plrs = game:GetService("Players");
local plr = plrs.LocalPlayer;
local alive = plr:GetAttribute("Alive");
local pg = plr.PlayerGui;
local char = plr.Character or plr.CharacterAdded:Wait()
local collision = char:WaitForChild("Collision");
local hum = char.Humanoid;
local rs = game:GetService("ReplicatedStorage");
local AuraToggle = true;
local ESPToggle = true;
local FlyToggle = false;
local ChatWarnToggle = false;
local InstantToggle = true;
local SeekToggle = false;
local SpeedToggle = false;
local espstuff = {};
local GameData = rs.GameData;
local mg = pg.MainUI.Initiator.Main_Game;
local cutscenes= mg:FindFirstChild("Cutscenes", true)
local Floor = GameData.Floor;
local CR = ws.CurrentRooms;
local Mod = rs.LiveModifiers;
local LTR = GameData.LatestRoom;
local ClientModules = rs.ClientModules;
local ModuleEvents = require(ClientModules.Module_Events);
local Modules = mg.RemoteListener.Modules;
local EntityInfo = ((Floor.Value == "Fools") and rs:WaitForChild("EntityInfo")) or rs:WaitForChild("RemotesFolder");
local MotorReplication = EntityInfo.MotorReplication;
local ESP_Items = {AlarmClock={"AlarmClock",1.5},AlarmClockModel={"AlarmClock",1.5},BandagePack={"BandagePack",1.5},BatteryPack={"BatteryPack",1.5},KeyObtain={"Key",1.5},FuseObtain={"Fuse",1.5},Glowsticks={"Glowsticks",1.5},Bulklight={"BulkLight",1.5},Straplight={"StrapLight",1.5},LaserPointer={"LaserPointer",1.5},Shears={"Shears",1.5},ShieldMini={"Mini Shield",1.5},ShieldBig={"Big Shield",1.5},StarVial={"Starlight Vial",1.5},LiveHintBook={"Book",1.5},Lighter={"Lighter",1.5},Lockpick={"Lockpicks",1.5},Vitamins={"Vitamins",1.5},Crucifix={"Crucifix",1.5},CrucifixWall={"Crucifix",1.5},SkeletonKey={"Skeleton Key",1.5},Flashlight={"Flashlight",1.5},Candle={"Candle",1.5},LiveBreakerPolePickup={"Fuse",1.5},Battery={"Battery",1.5},PickupItem={"Paper",1.5},ElectricalKeyObtain={"Electrical Key",1.5},Shakelight={"Shakelight",1.5},Scanner={"Scanner",1.5}};
local ESP_Entities = {FigureRig={"Figure",1.5},Grumbo={"Grumble",5},GiggleCeiling={"Giggle",5},RushMoving={"Rush",5},AmbushMoving={"Ambush",5},BackdoorRush={"Blitz",5},FigureRagdoll={"Figure",7},FigureLibrary={"Figure",7},SeekMovingNewClone={"Seek",5.5},SeekMoving={"Seek",5.5},A60={"A-60",10},A120={"A-120",10},Wardrobe={"Wardrobe",5}};
local ESP_Other = {Toolshed_Small={"Toolshed",5},Chest_Vine={"ChestVine",5},MinesAnchor={"Anchor",5},Door={"Door",5},LeverForGate={"Lever",3},TimerLever={"Lever",3},GoldPile={"Gold",0.5},Bandage={"Bandage",0.5}};
local EyesOnMap = false;
local OldEnabled = {};
local OldEsp = {};
local prox = {};
local RunService = game:GetService("RunService");
Lighting = game:GetService("Lighting");
local lag;
local function lagdetect()
	if (Floor.Value == "Mines") then
		if ((ws:FindFirstChild("SeekMoving")) or (ws:FindFirstChild("SeekMovingNewClone"))) then
			lag = true;
		else
			lag = false;
		end
	else
		lag = false;
	end
end
local alreadypassedfirstfigure = false;
local NoGold = Mod:FindFirstChild("GoldSpawnNone");
local NoItem = Mod:FindFirstChild("ItemSpawnNone");
local howmanyplayers = 0;
local multiplayer = false;
local InfiniteCrucifixMovingEntitiesVelocity = {RushMoving={threshold=52,minDistance=55},RushNew={threshold=52,minDistance=55},AmbushMoving={threshold=70,minDistance=80}};
for i, v in pairs(plrs:GetChildren()) do
	howmanyplayers += 1
end
if howmanyplayers > 1 then
	multiplayer = true;
end
local virtualUser = game:GetService("VirtualUser");
plr.Idled:Connect(function()
	virtualUser:CaptureController();
	virtualUser:ClickButton2(Vector2.new());
end);
function IsInViewOfPlayer(instance: Instance, range: number | nil)
	if not instance then
		return false;
	end
	if not collision then
		return false;
	end
	local raycastParams = RaycastParams.new();
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude;
	raycastParams.FilterDescendantsInstances = {char};
	local direction = (instance:GetPivot().Position - collision.Position).unit * (range or 8999999488);
	local raycast = ws:Raycast(collision.Position, direction, raycastParams);
	if (raycast and raycast.Instance:IsDescendantOf(instance)) then
		return true;
	end
	return false;
end
pcall(function() getgenv().myowndoorsscript = true end)
local function setup(room)
	lagdetect();
	if not lag then
		local function check(v)
			local DetectCR = LTR.Value;
			if v:IsA("Model") then
				if (v.Name == "DrawerContainer") then
					local function open(knob)
						if knob then
							local prompt = knob:WaitForChild("ActivateEventPrompt");
							local interactions = prompt:GetAttribute("Interactions");
							if not interactions then
								task.spawn(function()
									repeat
										task.wait(0.1);
										if (plr:DistanceFromCharacter(knob.Position) <= 14) then
											fireproximityprompt(prompt);
										end
									until prompt:GetAttribute("Interactions") or not AuraToggle 
								end);
							end
						end
					end
					if (NoGold and NoItem) then
						return;
					elseif (Floor.Value == "Retro") then
						local knob = v:WaitForChild("End");
						open(knob);
					elseif (Floor.Value == "Backdoor") then
						local knob = v:WaitForChild("Knob");
						open(knob);
					elseif (Floor.Value == "Mines") then
						local knob = v:WaitForChild("Metal");
						open(knob);
					else
						local knob = v:WaitForChild("Knobs");
						open(knob);
					end
				elseif (v.Name == "Locker_Small") then
					if (NoGold and NoItem) then
						return;
					else
						local knob = v:WaitForChild("Door");
						if knob then
							local prompt = knob:WaitForChild("ActivateEventPrompt");
							local interactions = prompt:GetAttribute("Interactions");
							if not interactions then
								task.spawn(function()
									repeat
										task.wait(0.1);
										if (plr:DistanceFromCharacter(knob.Position) <= 14) then
											fireproximityprompt(prompt);
										end
									until prompt:GetAttribute("Interactions") or not AuraToggle 
								end);
							end
						end
					end
				elseif ((v.Name == "Toolbox") or (v.Name == "Toolshed_Small")) then
					local prompt = v:WaitForChild("ActivateEventPrompt");
					local interactions = prompt:GetAttribute("Interactions");
					local knob = v.Main;
					if not interactions then
						task.spawn(function()
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(knob.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif ((v.Name == "Door") and (Floor.Value == "Retro")) then
					local prompt = v:WaitForChild("ActivateEventPrompt");
					local interactions = prompt:GetAttribute("Interactions");
					local function equip()
						local keyplr = plr.Backpack:FindFirstChild("Key");
						local keyplruse = char:FindFirstChild("Key");
						if not keyplruse then
							if keyplr then
								keyplr.Parent = char;
							end
						end
					end
					if not interactions then
						task.spawn(function()
							equip();
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(v.PrimaryPart.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif (v.Name == "Green_Herb") then
					local knob = v:WaitForChild("Plant")
					local prompt = knob:WaitForChild("HerbPrompt")
					local interactions = prompt:GetAttribute("Interactions");
					if not interactions then
						task.spawn(function()
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(knob.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif (v.Name == "GoldPile") then
					local prompt = v:WaitForChild("LootPrompt");
					local interactions = prompt:GetAttribute("Interactions");
					if not interactions then
						task.spawn(function()
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(v.PrimaryPart.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif ((v.Name:sub(1, 8) == "ChestBox") or (v.Name == "RolltopContainer")) then
					if (NoGold and NoItem) then
						return;
					else
						local prompt = v:WaitForChild("ActivateEventPrompt");
						local interactions = prompt:GetAttribute("Interactions");
						if not interactions then
							task.spawn(function()
								repeat
									task.wait(0.1);
									if (plr:DistanceFromCharacter(v.PrimaryPart.Position) <= 14) then
										fireproximityprompt(prompt);
									end
								until prompt:GetAttribute("Interactions") or not AuraToggle 
							end);
						end
					end
				elseif ((v.Name == "AlarmClockModel") or (v.Name == "AlarmClock") or (v.Name == "KeyObtain") or (v.Name == "StarVial") or (v.Name == "ElectricalKeyObtain") or (v.Name == "PickupItem") or (v.Name == "CrucifixWall") or (v.Name == "Bandage") or (v.Name == "Battery") or (v.Name == "Candle") or (v.Name == "FuseObtain")) then
					local prompt = v:WaitForChild("ModulePrompt");
					local interactions = prompt:GetAttribute("Interactions");
					if not interactions then
						task.spawn(function()
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(v.PrimaryPart.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif ((v.Name == "LeverForGate") or (v.Name == "TimerLever") or (v.Name == "LiveHintBook") or (v.Name == "LiveBreakerPolePickup")) then
					local prompt = v:WaitForChild("ActivateEventPrompt");
					local interactions = prompt:GetAttribute("Interactions");
					if not interactions then
						task.spawn(function()
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(v.PrimaryPart.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif ((v.Name == "BatteryPack") or (v.Name == "BandagePack") or (v.Name == "Lighter") or (v.Name == "Lockpick") or (v.Name == "ShieldMini") or (v.Name == "ShieldBig") or (v.Name == "Crucifix") or (v.Name == "SkeletonKey") or (v.Name == "Vitamins") or (v.Name == "Flashlight") or (v.Name == "Shakelight") or (v.Name == "Scanner") or (v.Name == "Glowsticks") or (v.Name == "LaserPointer") or (v.Name == "Shears") or (v.Name == "Bulklight") or (v.Name == "Straplight")) then
					local prompt = v:WaitForChild("ModulePrompt");
					local interactions = prompt:GetAttribute("Interactions");
					local stop = CR:FindFirstChild("52");
					if (stop and v:IsDescendantOf(stop)) then
						return;
					else
						task.spawn(function()
							repeat
								task.wait(0.1);
								if (plr:DistanceFromCharacter(v.PrimaryPart.Position) <= 14) then
									fireproximityprompt(prompt);
								end
							until prompt:GetAttribute("Interactions") or not AuraToggle 
						end);
					end
				elseif (v.Name == "MinesGenerator") then
					task.wait(2);
					local prompt;
					local prompt2 = v.Lever:WaitForChild("LeverPrompt");
					local fuse = false;
					local fuses = v.Fuses;
					local fusecomplete = false;
					local leverpulled = false;
					local knob = v.GeneratorMain;
					local function findprompt()
						for i, p in pairs(v:GetDescendants()) do
							if (p.Name == "FusesPrompt") then
								prompt = p;
							end
						end
					end
					local function detect()
						if (fuses[3].Fuse.Transparency == 0) then
							fusecomplete = true;
						else
							fusecomplete = false;
						end
					end
					local function findfuse()
						if (plr.Backpack:FindFirstChild("GeneratorFuse") or ws[plr.Name]:FindFirstChild("GeneratorFuse")) then
							fuse = true;
						else
							fuse = false;
						end
					end
					task.spawn(function()
						repeat
							task.wait(0.1);
							detect();
							findfuse();
							if (plr:DistanceFromCharacter(knob.Position) <= 14) then
								if (not fuse and fusecomplete) then
									task.spawn(function()
										repeat
											task.wait(0.1);
											if (plr:DistanceFromCharacter(knob.Position) <= 14) then
												fireproximityprompt(prompt2);
											end
										until prompt2:GetAttribute("Interactions") or not AuraToggle 
										leverpulled = true;
									end);
								elseif (fuse and not fusecomplete) then
									findprompt();
									fireproximityprompt(prompt);
								end
							end
						until (leverpulled == true) or not AuraToggle 
					end);
				elseif (v.Name == "MinesGateButton") then
					task.wait(2);
					local knob = v.Button;
					local prompt = knob:WaitForChild("ActivateEventPrompt");
					local fusecomplete = false;
					local blep;
					for i, fuses in pairs(CR:GetDescendants()) do
						if (fuses.Name == "MinesGenerator") then
							blep = fuses;
						end
					end
					local function detect()
						if (blep.Fuses[3].Fuse.Transparency == 0) then
							fusecomplete = true;
						else
							fusecomplete = false;
						end
					end
					task.spawn(function()
						repeat
							task.wait(0.1);
							detect();
							if (plr:DistanceFromCharacter(knob.Position) <= 14) then
								if (fusecomplete == true) then
									fireproximityprompt(prompt);
								end
							end
						until (prompt:GetAttribute("Interactions") and fusecomplete) or not AuraToggle 
					end);
				end
			elseif v:IsA("MeshPart") then
				if (v.Name == "Lock") then
					task.wait(2);
					local main;
					local prompt = v:FindFirstChild("UnlockPrompt");
					local unlocksound = mg.PromptService.Holding;
					local key;
					for i, findkey in pairs(CR:GetDescendants()) do
						if ((findkey.Name == "KeyObtain") and findkey:IsA("Model")) then
							key = findkey;
						end
					end
					task.spawn(function()
						repeat
							task.wait(0.1);
							local keyplr = plr.Backpack:FindFirstChild("Key");
							local keyplruse = char:FindFirstChild("Key");
							local function equip()
								if keyplruse then
									main = true;
								elseif keyplr then
									main = false;
								end
							end
							if ((plr:DistanceFromCharacter(v.Position) <= 14) and InstantToggle) then
								if (keyplr or keyplruse) then
									fireproximityprompt(prompt);
								end
							elseif ((plr:DistanceFromCharacter(v.Position) <= 14) and not InstantToggle) then
								equip();
								if main then
									local use = keyplruse.Animations.use;
									local anim = hum:LoadAnimation(use);
									anim:Play();
									unlocksound:Play();
									task.wait(0.75);
									unlocksound:Stop();
									fireproximityprompt(prompt);
								else
									local use = keyplr.Animations.offhand;
									local anim = hum:LoadAnimation(use);
									anim:Play();
									unlocksound:Play();
									task.wait(0.75);
									unlocksound:Stop();
									fireproximityprompt(prompt);
								end
							end
						until (key.Parent == nil) or not AuraToggle 
					end);
				end
			end
		end
		local subaddcon;
		subaddcon = room.DescendantAdded:Connect(function(v)
			check(v);
		end);
		for i, v in pairs(room:GetDescendants()) do
			check(v);
		end
		task.spawn(function()
			repeat
				task.wait();
			until not AuraToggle 
			subaddcon:Disconnect();
		end);
	end
end
local AuraFunction;
AuraFunction = CR.ChildAdded:Connect(function(room)
	if (AuraToggle == true) then
		setup(room);
	end
end);
for i, room in pairs(CR:GetChildren()) do
	if (AuraToggle == true) then
		setup(room);
	end
end
ws.ChildAdded:Connect(function(child)
	if (((child.Name == "RushMoving") or (child.Name == "AmbushMoving")) and alive and char) then
		task.wait(1.5);
		local hasStoppedMoving = false;
		local lastPosition = child:GetPivot().Position;
		local lastVelocity = Vector3.new(0, 0, 0);
		local frameCount = 0;
		local nextTimer = tick();
		local maxSavedFrames = 10;
		local currentSavedFrames = 0;
		local physicsTickRate = (1 / 60) * 0.9;
		local oldFrameHz = 0;
		local frameHz = 0;
		local frameRate = 1;
		local nextTimerHz = tick();
		local entityName = child.Name;
		local crucifixConnection;
		crucifixConnection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
			if (not alive or not char) then
				crucifixConnection:Disconnect();
				return;
			end
			local currentTimer = tick();
			frameCount += 1
			frameHz += 1
			if ((currentTimer - nextTimerHz) >= frameRate) then
				oldFrameHz = frameHz;
				frameHz = 0;
				nextTimerHz = currentTimer;
				physicsTickRate = (1 / oldFrameHz) * 0.9;
			end
			if ((physicsTickRate == 0) or not ((currentTimer - nextTimer) >= physicsTickRate)) then
				return;
			end
			frameCount = 0;
			nextTimer = currentTimer;
			local currentPosition = child:GetPivot().Position;
			local velocity = (currentPosition - lastPosition) / deltaTime;
			velocity = Vector3.new(velocity.X, 0, velocity.Z);
			local smoothedVelocity = lastVelocity:Lerp(velocity, 0.3);
			local entityVelocity = math.floor(smoothedVelocity.Magnitude);
			lastVelocity = smoothedVelocity;
			lastPosition = currentPosition;
			local inView = IsInViewOfPlayer(child, InfiniteCrucifixMovingEntitiesVelocity[entityName].minDistance);
			local distanceFromPlayer = (child:GetPivot().Position - char:GetPivot().Position).Magnitude;
			local isInRangeOfPlayer = distanceFromPlayer <= InfiniteCrucifixMovingEntitiesVelocity[entityName].minDistance;
			if (entityVelocity <= InfiniteCrucifixMovingEntitiesVelocity[entityName].threshold) then
				if ((entityVelocity <= 0.5) and (currentSavedFrames <= maxSavedFrames)) then
					currentSavedFrames += 1
				end
				if not hasStoppedMoving then
					hasStoppedMoving = true;
				end
				if not inView then
					return;
				end
				if not isInRangeOfPlayer then
					return;
				end
				print("[HEURISTIC FINISH] --> Item dropped!");
				if char:FindFirstChild("Crucifix") then
					ws.Drops.ChildAdded:Once(function(droppedItem)
						if (droppedItem.Name == "Crucifix") then
							local targetProximityPrompt = droppedItem:WaitForChild("ModulePrompt", 3) or droppedItem:FindFirstChildOfClass("ProximityPrompt");
							repeat
								task.wait();
								fireproximityprompt(targetProximityPrompt);
							until not droppedItem:IsDescendantOf(ws) 
						end
					end);
					print("[TOOL] Crucifix dropped!");
					game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("DropItem"):FireServer(char.Crucifix);
				end
				return;
			end
			currentSavedFrames = 0;
			if hasStoppedMoving then
				hasStoppedMoving = false;
			end
		end);
		local childRemovedConnection;
		childRemovedConnection = ws.ChildRemoved:Connect(function(model)
			if (model ~= child) then
				return;
			end
			crucifixConnection:Disconnect();
			childRemovedConnection:Disconnect();
		end);
	end
end);
local infitems = game:GetService("ProximityPromptService").PromptTriggered:Connect(function(prompt, player)
    if player ~= plr then return end
    if Floor.Value == "Fools" then infitems:Disconnect() end
    local isChestVine = prompt.Name == "ActivateEventPrompt" and prompt.Parent.Name == "Chest_Vine" and prompt.Parent:GetAttribute("Locked")
    local isDoorLock = prompt.Name == "UnlockPrompt" and prompt.Parent.Name == "Lock" and not prompt.Parent.Parent:GetAttribute("Opened")
    local isSkeletonDoor = prompt.Name == "SkullPrompt" and prompt.Parent.Name == "SkullLock" and not (prompt.Parent:FindFirstChild("Door") and prompt.Parent.Door.Transparency == 1)
    local isChestBox = prompt.Name == "ActivateEventPrompt" and prompt.Parent.Name == "ChestBoxLocked" and prompt.Parent:GetAttribute("Locked")
    local isRoomsDoorLock = prompt.Parent.Parent.Parent.Name == "RoomsDoor_Entrance" and prompt.Enabled
    local equippedTool = char:FindFirstChildOfClass("Tool")
    local toolId = equippedTool and equippedTool:GetAttribute("ID")
    if isDoorLock or isSkeletenDoor or isChestBox or isRoomsDoorLock then
        if equippedTool:GetAttribute("UniversalKey") then
            task.wait(isChestBox and 0.15 or 0)
            ws.Drops.ChildAdded:Once(function(droppedItem)
        		if (droppedItem.Name == "Lockpick") or (droppedItem.Name == "SkeletonKey") then
			        local targetProximityPrompt = droppedItem:WaitForChild("ModulePrompt", 3) or droppedItem:FindFirstChildOfClass("ProximityPrompt");
			        repeat
				        task.wait(.15);
		        		fireproximityprompt(targetProximityPrompt);
	        		until not droppedItem:IsDescendantOf(ws) 
        		end
        	end);
            EntityInfo.DropItem:FireServer(equippedTool)
        end
    end
    if isChestVine then
        task.wait(.15)
        local shears = char:FindFirstChild("Shears")
        if shears then
            local durability = shears:GetAttribute("Durability")
            if durability < 1 then
                ws.Drops.ChildAdded:Once(function(droppedItem)
	            	if (droppedItem.Name == "Shears") then
		            	local targetProximityPrompt = droppedItem:WaitForChild("ModulePrompt", 3) or droppedItem:FindFirstChildOfClass("ProximityPrompt");
	            		repeat
            				task.wait(.15);
	            			fireproximityprompt(targetProximityPrompt);
            			until not droppedItem:IsDescendantOf(ws) 
            		end
            	end);
                EntityInfo.DropItem:FireServer(shears)
            end
        end
    end
end)
ws.Camera.DescendantAdded:Connect(function(child)
	if ((child.Name == "Screech") or (child.Name == "ScreechRetro")) then
		local args = {[1]=true};
		if (Floor.Value == "Fools") then
			game:GetService("ReplicatedStorage"):WaitForChild("EntityInfo"):WaitForChild("Screech"):FireServer(unpack(args));
		else
			game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("Screech"):FireServer(unpack(args));
		end
		send("hey, there\'s.. something behind you")
	end
	-- laggy. child:Destroy();
end);
local ScreechSafeRooms = {};
if Mod:FindFirstChild("LightsOut") then
	ModuleEvents.shatter = function(Room)
		table.insert(ScreechSafeRooms, tostring(Room));
	end;
	task.spawn(function()
		while true do
			task.wait(0.1);
			if CR[plr:GetAttribute("CurrentRoom")]:GetAttribute("IsDark") then
				Lighting.Ambient = Color3.fromRGB(67, 51, 56);
			end
		end
	end);
	CR.ChildAdded:Connect(function(a)
		ModuleEvents.toggle(LTR.Value, true, Color3.fromRGB(0, 0, 0));
	end);
	CR.DescendantAdded:Connect(function(light)
		if ((light.Name == "HelpLight") or (light.Name == "HelpParticle")) then
			if (light.Enabled == false) then
				light.Enabled = true;
			end
			if (light.ClassName == "SpotLight") then
				light.Brightness = 20;
			end
		end
	end);
	for _, light in pairs(CR:GetDescendants()) do
		if ((light.Name == "HelpLight") or (light.Name == "HelpParticle")) then
			if (light.Enabled == false) then
				light.Enabled = true;
			end
			if (light.ClassName == "SpotLight") then
				light.Brightness = 20;
			end
		end
	end
end
if Mod:FindFirstChild("Jammin") then
	game.SoundService.Main.Jamming.Enabled = false;
	mg.Health.Jam.Playing = false;
end
--[[ was thinking about adding an antilag but im not sure if it will make it less laggier
local Terrain = ws:FindFirstChildOfClass('Terrain')
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
for i,v in pairs(game:GetDescendants()) do
	if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
		v.Material = "Plastic"
		v.Reflectance = 0
	elseif v:IsA("Decal") then
		v.Transparency = 1
	elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
		v.Lifetime = NumberRange.new(0)
	elseif v:IsA("Explosion") then
		v.BlastPressure = 1
		v.BlastRadius = 1
	end
end
]]
for i,v in pairs(Lighting:GetDescendants()) do
	if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
		v.Enabled = false
	end
end
local function check(Object)
	lagdetect()
	if not lag then
		task.spawn(function()
			if Object:IsA("ProximityPrompt") then
				Object.MaxActivationDistance *= 2
				Object.RequiresLineOfSight = false;
				if InstantToggle then
					Object.HoldDuration = -Object.HoldDuration;
				end
				table.insert(prox, Object);
			elseif (Object.Name == "DoorFake") then
				Object:WaitForChild("Hidden").CanTouch = false;
				Object.Door.Color = Color3.new(0.5, 0, 0) or Color3.fromRGB(129, 111, 100);
				Object.Door.Sign.Color = Color3.new(0.5, 0, 0) or Color3.fromRGB(129, 111, 100);
				for _, DoorNumber in pairs({Object.Sign.Stinker,Object.Sign.Stinker.Highlight,Object.Sign.Stinker.Shadow}) do
					DoorNumber.Text = "DUPE" or string.format("%0.4i", LTR.Value);
				end
				if Object:FindFirstChild("Lock") then
					task.wait(3);
					Object.Lock:Destroy();
				end
			elseif ((Object.Name == "Collision") and (Object.Parent.Name == "TriggerEventCollision")) then
				if SeekToggle then
					if (hum.Health ~= 0) then
						task.wait(0.4);
						Object.CanCollide = true;
						Object.CFrame = char.Collision.CFrame;
						Object.CanCollide = false;
						Object.CFrame = char.Collision.CFrame;
						send("Triggered.");
					end
				end
			elseif Object:IsA("BasePart") then
				if (Object.Name == "Egg") then
					Object.CanTouch = false;
				end
			elseif Object:IsA("Model") then
				if (Object.Name == "Snare") then
					Object:WaitForChild("Hitbox", 5).CanTouch = false;
				end
			end
		end);
	end
	if ((Object.Name == "Collision") and (Object.Parent.Name == "MinecartCollision")) then
		if multiplayer then
			LTR.Changed:Wait()
			task.wait(1.5);
			if (hum.Health ~= 0) then
				Object.CanCollide = true;
				Object.CFrame = char.Collision.CFrame;
				Object.CanCollide = false;
				Object.CFrame = char.Collision.CFrame;
				send("skipped to minecart.");
			end
		else
			task.wait(.5)
			if (hum.Health ~= 0) then
				Object.CanCollide = true;
				Object.CFrame = char.Collision.CFrame;
				Object.CanCollide = false;
				Object.CFrame = char.Collision.CFrame;
				send("skipped to minecart.");
			end
		end
	end
	if Object.Name == "KillBrick" then
		local safepart = Instance.new("Part", Object.Parent)
		safepart.Name = "SafeBrick"
		safepart.Position = Object.Position
		safepart.Transparency = 1
		safepart.Size = Vector3.new(100, 1.2, 100)
		safepart.Anchored = true
		local pivot = safepart:GetPivot()
		safepart:PivotTo(pivot * CFrame.new(0,15,0))
	end
end
for i, Object in pairs(CR:GetDescendants()) do
	check(Object)
end
CR.DescendantAdded:Connect(function(Object)
	check(Object)
end);
local function ApplySettings(Object)
	lagdetect();
	if not lag and ESPToggle then
		task.spawn(function()
			task.wait();
			if ((ESP_Items[Object.Name] or ESP_Entities[Object.Name] or ESP_Other[Object.Name]) and (Object.ClassName == "Model")) then
				if Object:FindFirstChild("RushNew") then
					if not Object.RushNew:WaitForChild("PlaySound").Playing then
						return;
					end
				end
				local Color = (ESP_Items[Object.Name] and Color3.new(1, 1)) or (ESP_Entities[Object.Name] and Color3.new(1)) or Color3.new(0, 1, 1);
				if ((Object.Name == "RushMoving") or (Object.Name == "AmbushMoving") or (Object.Name == "Eyes") or (Object.Name == "A60") or (Object.Name == "A120") or (Object.Name == "BackdoorLookman") or (Object.Name == "BackdoorRush")) then
					for i = 1, 100 do
						if Object:FindFirstChildOfClass("Part") then
							break;
						end
						if (i == 100) then
							return;
						end
					end
					Object:FindFirstChildOfClass("Part").Transparency = 0.99;
					Instance.new("Humanoid", Object);
				end
				local function ApplyHighlight(IsValid, Bool)
					if IsValid then
						if Bool then
							local TXT = IsValid[1];
							if (IsValid[1] == "Door") then--[[ Broken.
								local RoomName;
								if (Floor.Value == "Rooms") then
									RoomName = "";
								else
									CR:WaitForChild(tonumber(Object.Parent.Name) + 1, math.huge);
									local OldString = CR[tonumber(Object.Parent.Name) + 1]:GetAttribute("OriginalName"):sub(7, 99);
									local NewString = "";
									for i = 1, #OldString do
										if (i == 1) then
											NewString = NewString .. OldString:sub(i, i);
											continue
										end
										if ((OldString:sub(i, i) == OldString:sub(i, i):upper()) and (OldString:sub(i - 1, i - 1) ~= "_")) then
											NewString = NewString .. " ";
										end
										if (OldString:sub(i, i) ~= "_") then
											NewString = NewString .. OldString:sub(i, i);
										end
									end
									RoomName = " (" .. NewString .. ")";
								end
								TXT = "Door " .. (((Floor.Value == "Rooms") and "A-") or "") .. (tonumber(Object.Parent.Name) + 1) .. LTR.Value;]]
								TXT = "";
							end
							if (IsValid[1] == "Wardrobe") then
								TXT = "";
							end
							if (IsValid[1] == "Anchor") then
								local sign = Object:WaitForChild("Sign", 5)
								if sign and sign:FindFirstChild("TextLabel") then
									TXT = string.format("Anchor %s", sign.TextLabel.Text);
								end
							end
							if (IsValid[1] == "Gold") then
								TXT = Object:GetAttribute("GoldValue") .. " Gold";
							end
							local UI = Instance.new("BillboardGui", Object);
							UI.Name = Object.Name .. "Highlight";
							UI.Size = UDim2.new(0, 1000, 0, 30);
							UI.AlwaysOnTop = true;
							UI.StudsOffset = Vector3.new(0, IsValid[2], 0);
							local Label = Instance.new("TextLabel", UI);
							Label.Size = UDim2.new(1, 0, 0.4, 0);
							Label.BackgroundTransparency = 1;
							Label.TextScaled = true;
							Label.Text = TXT;
							Label.TextColor3 = Color;
							Label.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
							Label.TextStrokeTransparency = 0;
							Label.TextStrokeColor3 = Color3.new(Color.R / 2, Color.G / 2, Color.B / 2);
							table.insert(espstuff, UI);
						elseif Object:FindFirstChild("BillboardGui") then
							Object.BillboardGui:Destroy();
						end
						local Target = Object;
						if ((IsValid[1] == "Door") and (Object.Parent.Name ~= "49") and (Object.Parent.Name ~= "50")) then
							Target = Object:WaitForChild("Door");
						end
						if Bool then
							local Highlight = Instance.new("Highlight", Target);
							Highlight.Name = Object.Name .. "Highlight";
							Highlight.FillTransparency = 0.85;
							Highlight.FillColor = Color;
							Highlight.OutlineColor = Color;
							Highlight.OutlineTransparency = 0.75;
							table.insert(espstuff, Highlight);
						elseif Target:FindFirstChild("Highlight") then
							Target.Highlight:Destroy();
						end
					end
				end
				ApplyHighlight(ESP_Items[Object.Name], ESPToggle);
				ApplyHighlight(ESP_Entities[Object.Name], ESPToggle);
				ApplyHighlight(ESP_Other[Object.Name], ESPToggle);
			end
		end);
	end
	if ((Object.Name == "RushMoving") and (Floor.Value ~= "Rooms")) then
		repeat
			task.wait();
		until (plr:DistanceFromCharacter(Object:GetPivot().Position) < 1000) or (not Object.Parent == ws) or (hum.Health == 0) 
		if (Object.Parent == ws) then
			send("Rush Spawned!");
			if ChatWarnToggle then
				task.wait(1.4);
				sendchat("rush, hide!!");
			end
		end
	elseif ((Object.Name == "AmbushMoving") and (Floor.Value ~= "Rooms")) then
		repeat
			task.wait();
		until (plr:DistanceFromCharacter(Object:GetPivot().Position) < 1000) or (not Object.Parent == ws) or (hum.Health == 0) 
		if (Object.Parent == ws) then
			send("Ambush Spawned!");
			if ChatWarnToggle then
				task.wait(1.4);
				local blephaso = ((Floor.Value == "Mines") and "ambush, get ready to switch lockers!!") or "ambush, hide!!";
				sendchat(blephaso);
			end
		end
	elseif (Object.Name == "A60") then
		send("A-60 Spawned!");
		if ChatWarnToggle then
			task.wait(1.4);
			sendchat("a-60, hide!!");
		end
	elseif (Object.Name == "A120") then
		send("A-120 Spawned!");
		if ChatWarnToggle then
			task.wait(1.4);
			sendchat("a-120, hide!!");
		end
	elseif (Object.Name == "BackdoorRush") then
		send("Blitz Spawned!");
		if ChatWarnToggle then
			task.wait(1.4);
			sendchat("blitz, hide!!");
		end
	end
	if (Object.Name == "FigureRig") then
		if (Floor.Value == "Mines") then
			if not alreadypassedfirstfigure then
				alreadypassedfirstfigure = true;
			elseif alreadypassedfirstfigure then
				if ChatWarnToggle then
					sendchat("figure is next door, be careful!!");
				end
			end
		end
	end--[[
	task.spawn(function()
		if Object:IsA('ForceField') then
			RunService.Heartbeat:Wait()
			Object:Destroy()
		elseif Object:IsA('Sparkles') then
			RunService.Heartbeat:Wait()
			Object:Destroy()
		elseif Object:IsA('Smoke') or Object:IsA('Fire') then
			RunService.Heartbeat:Wait()
			Object:Destroy()
		end
		if Object:IsA("Part") or Object:IsA("UnionOperation") or Object:IsA("MeshPart") or Object:IsA("CornerWedgePart") or Object:IsA("TrussPart") then
			Object.Material = "Plastic"
			Object.Reflectance = 0
		elseif Object:IsA("Decal") then
			Object.Transparency = 1
		elseif Object:IsA("ParticleEmitter") or Object:IsA("Trail") then
			Object.Lifetime = NumberRange.new(0)
		elseif Object:IsA("Explosion") then
			Object.BlastPressure = 1
			Object.BlastRadius = 1
		end
	end)]]
end
for _, Player in pairs(game.Players:GetPlayers()) do
	if (Player ~= plr) then
		ESP_Other[Player.Name] = {Player.DisplayName,4};
	end
end
--tried to bypass wet floor but failed horribly 😭
for _, v in pairs(char:GetDescendants()) do
	if ((v.Name == "Massless") and (v == true)) then
		v = false;
	end
	if ((v.Name == "Collision") and (v.Parent == char)) then
		v.Size = Vector3.new(2, 1 + 1, 5 - 3);
		task.wait(0.2);
		v.Size = Vector3.new(1873 - (474 + 1396), 6.5 - 2, 3 + 0);
	end
end
for _, Object in pairs(ws:GetDescendants()) do
	ApplySettings(Object);
end
ws.DescendantAdded:Connect(ApplySettings);
--[[ broken.
ws.ChildRemoved:Connect(function(Object)
	if (Object.Name == "Eyes") or Object.Name == "BackdoorLookman" then
		if Floor.Value == "Backdoor" and not ws:FindFirstChild("BackdoorLookman") or not ws:FindFirstChild("Eyes") then
			EyesOnMap = false;
		end
	end
end);]]
local mt = getrawmetatable(game);
local old_mt = mt.__namecall;
setreadonly(mt, false);
mt.__namecall = newcclosure(function(remote, ...)
	args = {...};
	if EyesOnMap then
		if (tostring(remote) == "MotorReplication") then
			args[2] = -120;
		end
	end
	return old_mt(remote, table.unpack(args));
end);
setreadonly(mt, true);
if Floor.Value ~= "Backdoor" then
	Lighting = game:GetService("Lighting")
	Lighting.FogEnd = 100000;
	for i, v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy();
		end
	end
end
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Parent = pg;
ScreenGui.Name = "blephaha";
ScreenGui.ResetOnSpawn = false;
local FigureButton;
local EBFButton;
local AuraButton = Instance.new("TextButton");
AuraButton.Parent = ScreenGui;
AuraButton.Text = "UnAura";
AuraButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
AuraButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
AuraButton.Size = UDim2.new(0, 30, 0, 30);
AuraButton.Visible = true;
AuraButton.Active = true;
local ESPButton = Instance.new("TextButton");
ESPButton.Parent = ScreenGui;
ESPButton.Text = "NoEsp";
ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
ESPButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
ESPButton.Size = UDim2.new(0, 30, 0, 30);
ESPButton.Visible = true;
ESPButton.Active = true;
local FlyButton = Instance.new("TextButton");
FlyButton.Parent = ScreenGui;
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
FlyButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
FlyButton.Size = UDim2.new(0, 30, 0, 30);
FlyButton.Visible = true;
FlyButton.Active = true;
FlyButton.Text = "Fly";
local ChatWarnButton = Instance.new("TextButton");
ChatWarnButton.Parent = ScreenGui;
ChatWarnButton.Text = "Warn";
ChatWarnButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
ChatWarnButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
ChatWarnButton.Size = UDim2.new(0, 30, 0, 30);
ChatWarnButton.Visible = true;
ChatWarnButton.Active = true;
local InstantButton = Instance.new("TextButton");
InstantButton.Parent = ScreenGui;
InstantButton.Text = "NoInsta";
InstantButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
InstantButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
InstantButton.Size = UDim2.new(0, 30, 0, 30);
InstantButton.Visible = true;
InstantButton.Active = true;
local SpeedButton = Instance.new("TextButton");
SpeedButton.Parent = ScreenGui;
SpeedButton.Text = "SW";
SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
SpeedButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
SpeedButton.Size = UDim2.new(0, 30, 0, 30);
SpeedButton.Visible = true;
SpeedButton.Active = true;
local SeekButton;
if ((Floor.Value ~= "Hotel") and (Floor.Value ~= "Fools")) then
	AuraButton.Position = UDim2.new(0, 150, 0, -30);
	ESPButton.Position = UDim2.new(0, 190, 0, -30);
	FlyButton.Position = UDim2.new(0, 230, 0, -30);
	ChatWarnButton.Position = UDim2.new(0, 270, 0, -30);
	InstantButton.Position = UDim2.new(0, 310, 0, -30);
	if (Floor.Value == "Mines") then
		SpeedButton.Position = UDim2.new(0, 390, 0, -30);
	else
		SpeedButton.Position = UDim2.new(0, 350, 0, -30);
	end
else
	AuraButton.Position = UDim2.new(0, 190, 0, -30);
	ESPButton.Position = UDim2.new(0, 230, 0, -30);
	FlyButton.Position = UDim2.new(0, 270, 0, -30);
	ChatWarnButton.Position = UDim2.new(0, 310, 0, -30);
	InstantButton.Position = UDim2.new(0, 350, 0, -30);
	SpeedButton.Position = UDim2.new(0, 470, 0, -30);
end
if ((Floor.Value == "Hotel") or (Floor.Value == "Mines") or (Floor.Value == "Fools")) then
	SeekButton = Instance.new("TextButton");
	SeekButton.Parent = ScreenGui;
	SeekButton.Text = "NoSeek";
	SeekButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
	SeekButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
	SeekButton.Position = ((Floor.Value == "Hotel") and UDim2.new(0, 390, 0, -30)) or UDim2.new(0, 350, 0, -30);
	SeekButton.Size = UDim2.new(0, 30, 0, 30);
	SeekButton.Visible = true;
	SeekButton.Active = true;
	if (Floor.Value == "Hotel") then
		FigureButton = Instance.new("TextButton");
		FigureButton.Parent = ScreenGui;
		FigureButton.Text = "Open50";
		FigureButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		FigureButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
		FigureButton.Position = UDim2.new(0, 150, 0, -30);
		FigureButton.Size = UDim2.new(0, 30, 0, 30);
		FigureButton.Visible = true;
		FigureButton.Active = true;
		EBFButton = Instance.new("TextButton");
		EBFButton.Parent = ScreenGui;
		EBFButton.Text = "EBF";
		EBFButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		EBFButton.BorderColor3 = Color3.fromRGB(0, 100, 0);
		EBFButton.Position = UDim2.new(0, 430, 0, -30);
		EBFButton.Size = UDim2.new(0, 30, 0, 30);
		EBFButton.Visible = true;
		EBFButton.Active = true;
		EBFButton.MouseButton1Down:Connect(function()
			while task.wait(1) do
				EntityInfo.EBF:FireServer();
			end
		end);
		FigureButton.MouseButton1Down:Connect(function()
			local Paper = ws:FindFirstChild("LibraryHintPaper", true) or ws:FindFirstChild("LibraryHintPaperHard", true) or game.Players:FindFirstChild("LibraryHintPaper", true) or game.Players:FindFirstChild("LibraryHintPaperHard", true);
			if not Paper then
				send("Someone needs to have the Hint Paper to use this.");
				return;
			end
			local HintsNeeded = ((Floor.Value == "Fools") and 8) or 3;
			local Hints = 0;
			for _, Collected in pairs(pg.PermUI.Hints:GetChildren()) do
				if (Collected.Name == "Icon") then
					if Collected:IsA("ImageLabel") then
						for _, Icon in pairs(Paper.UI:GetChildren()) do
							if tonumber(Icon.Name) then
								if (Icon.ImageRectOffset == Collected.ImageRectOffset) then
									Hints += 1
								end
							end
						end
					end
				end
			end
			if (Hints < HintsNeeded) then
				send("You need to collect at least " .. (HintsNeeded - Hints) .. " more correct hint" .. (((Hints ~= 2) and "s") or "") .. " to use this.");
				return;
			end
			local t = {};
			for i = 1, ((Floor.Value == "Hotel") and 5) or 10 do
				local Icon = Paper.UI[i];
				local Number = -1;
				for _, Collected in pairs(pg.PermUI.Hints:GetChildren()) do
					if (Collected.Name == "Icon") then
						if (Collected.ImageRectOffset == Icon.ImageRectOffset) then
							Number = tonumber(Collected.TextLabel.Text);
						end
					end
				end
				table.insert(t, Number);
			end
			for one = 0, ((t[1] == -1) and 9) or 0 do
				for two = 0, ((t[2] == -1) and 9) or 0 do
					for three = 0, ((t[3] == -1) and 9) or 0 do
						for four = 0, ((t[4] == -1) and 9) or 0 do
							for five = 0, ((t[5] == -1) and 9) or 0 do
								if (Floor.Value == "Fools") then
									for six = 0, ((t[6] == -1) and 9) or 0 do
										for seven = 0, ((t[7] == -1) and 9) or 0 do
											for eight = 0, ((t[8] == -1) and 9) or 0 do
												for nine = 0, ((t[9] == -1) and 9) or 0 do
													for ten = 0, ((t[10] == -1) and 9) or 0 do
														EntityInfo.PL:FireServer((((t[1] == -1) and one) or t[1]) .. (((t[2] == -1) and two) or t[2]) .. (((t[3] == -1) and three) or t[3]) .. (((t[4] == -1) and four) or t[4]) .. (((t[5] == -1) and five) or t[5]) .. (((t[6] == -1) and six) or t[6]) .. (((t[7] == -1) and seven) or t[7]) .. (((t[8] == -1) and eight) or t[8]) .. (((t[9] == -1) and nine) or t[9]) .. (((t[10] == -1) and ten) or t[10]));
														send("Successfuly opened.");
													end
												end
											end
										end
									end
								else
									EntityInfo.PL:FireServer((((t[1] == -1) and one) or t[1]) .. (((t[2] == -1) and two) or t[2]) .. (((t[3] == -1) and three) or t[3]) .. (((t[4] == -1) and four) or t[4]) .. (((t[5] == -1) and five) or t[5]));
									send("Successfuly opened.");
									FigureButton.Visible = false;
									if (hum.Health == 0) then
										ESPButton.Position = UDim2.new(0, 150, 0, -30);
										ChatWarnButton.Position = UDim2.new(0, 190, 0, -30);
									else
										AuraButton.Position = UDim2.new(0, 150, 0, -30);
										ESPButton.Position = UDim2.new(0, 190, 0, -30);
										FlyButton.Position = UDim2.new(0, 230, 0, -30);
										ChatWarnButton.Position = UDim2.new(0, 270, 0, -30);
										InstantButton.Position = UDim2.new(0, 310, 0, -30);
										SeekButton.Position = UDim2.new(0, 350, 0, -30);
										EBFButton.Position = UDim2.new(0, 390, 0, -30);
										SpeedButton.Position = UDim2.new(0, 430, 0, -30);
									end
								end
							end
						end
					end
				end
			end
		end);
	end
	SeekButton.MouseButton1Down:Connect(function()
		if SeekToggle then
			SeekButton.Text = "NoSeek";
			SeekButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
			SeekToggle = false;
		elseif not SeekToggle then
			SeekButton.Text = "Seek";
			SeekButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
			SeekToggle = true;
			for _, Object in pairs(ws:GetDescendants()) do
				if ((Object.Name == "Collision") and (Object.Parent.Name == "TriggerEventCollision")) then
					task.wait(0.4);
					Object.CanCollide = true;
					Object.CFrame = char.Collision.CFrame;
					Object.CanCollide = false;
					Object.CFrame = char.Collision.CFrame;
					send("Triggered.");
				end
			end
		end
	end);
end
AuraButton.MouseButton1Down:Connect(function()
	if not AuraToggle then
		AuraToggle = true;
		AuraButton.Text = "UnAura";
		AuraButton.BackgroundColor3 = Color3.fromRGB(355, 0, 0);
		for i, room in pairs(CR:GetChildren()) do
			if room:FindFirstChild("Assets") then
				setup(room);
			end
		end
		AuraFunction = CR.ChildAdded:Connect(function(room)
			if (AuraToggle == true) then
				setup(room);
			end
		end);
	elseif AuraToggle then
		AuraToggle = false;
		AuraFunction:Disconnect()
		AuraButton.Text = "Aura";
		AuraButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
	end
end);
local connect;
ESPButton.MouseButton1Down:Connect(function()
	if not ESPToggle then
		ESPToggle = true;
		connect:Disconnect();
		ESPButton.Text = "NoEsp";
		ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
		for _, Object in pairs(ws:GetDescendants()) do
			if (ESP_Items[Object.Name] or ESP_Entities[Object.Name] or (ESP_Other[Object.Name] and (Object.ClassName == "Model"))) then
				ApplySettings(Object);
			end
		end
	elseif ESPToggle then
		ESPToggle = false;
		ESPButton.Text = "EspOn";
		ESPButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		local function removeesp()
			for _, highlight in pairs(espstuff) do
				highlight:Destroy();
			end
		end
		removeesp();
		connect = ws.DescendantAdded:Connect(removeesp);
	end
end);
local function randomString()
	local length = math.random(10, 20);
	local array = {};
	for i = 1, length do
		array[i] = string.char(math.random(32, 126));
	end
	return table.concat(array);
end
local function getRoot(hehau)
	local rootPart = hehau:FindFirstChild("HumanoidRootPart") or hehau:FindFirstChild("Torso") or hehau:FindFirstChild("UpperTorso");
	return rootPart;
end
local iyflyspeed = 0.43;
local velocityHandlerName = randomString();
local gyroHandlerName = randomString();
local mfly1;
local mfly2;
local function unmobilefly()
	pcall(function()
		FlyToggle = false;
		local root = getRoot(char);
		root:FindFirstChild(velocityHandlerName):Destroy();
		root:FindFirstChild(gyroHandlerName):Destroy();
		char:FindFirstChildWhichIsA("Humanoid").PlatformStand = false;
		mfly1:Disconnect();
		mfly2:Disconnect();
	end);
end
local function mobilefly()
	unmobilefly();
	FlyToggle = true;
	local root = getRoot(char);
	local camera = ws.CurrentCamera;
	local v3none = Vector3.new();
	local v3zero = Vector3.new(0, 0, 0);
	local v3inf = Vector3.new(8999999488, 8999999488, 8999999488);
	local controlModule = require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"));
	local bv = Instance.new("BodyVelocity");
	bv.Name = velocityHandlerName;
	bv.Parent = root;
	bv.MaxForce = v3zero;
	bv.Velocity = v3zero;
	local bg = Instance.new("BodyGyro");
	bg.Name = gyroHandlerName;
	bg.Parent = root;
	bg.MaxTorque = v3inf;
	bg.P = 1000;
	bg.D = 50;
	mfly1 = plr.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity");
		bv.Name = velocityHandlerName;
		bv.Parent = root;
		bv.MaxForce = v3zero;
		bv.Velocity = v3zero;
		local bg = Instance.new("BodyGyro");
		bg.Name = gyroHandlerName;
		bg.Parent = root;
		bg.MaxTorque = v3inf;
		bg.P = 1000;
		bg.D = 50;
	end);
	mfly2 = RunService.RenderStepped:Connect(function()
		root = getRoot(char);
		camera = ws.CurrentCamera;
		if (char:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName)) then
			local humanoid = char:FindFirstChildWhichIsA("Humanoid");
			local VelocityHandler = root:FindFirstChild(velocityHandlerName);
			local GyroHandler = root:FindFirstChild(gyroHandlerName);
			VelocityHandler.MaxForce = v3inf;
			GyroHandler.MaxTorque = v3inf;
			humanoid.PlatformStand = true;
			GyroHandler.CFrame = camera.CoordinateFrame;
			VelocityHandler.Velocity = v3none;
			local direction = controlModule:GetMoveVector();
			if (direction.X > 0) then
				VelocityHandler.Velocity = VelocityHandler.Velocity + (camera.CFrame.RightVector * direction.X * iyflyspeed * 50);
			end
			if (direction.X < 0) then
				VelocityHandler.Velocity = VelocityHandler.Velocity + (camera.CFrame.RightVector * direction.X * iyflyspeed * 50);
			end
			if (direction.Z > 0) then
				VelocityHandler.Velocity = VelocityHandler.Velocity - (camera.CFrame.LookVector * direction.Z * iyflyspeed * 50);
			end
			if (direction.Z < 0) then
				VelocityHandler.Velocity = VelocityHandler.Velocity - (camera.CFrame.LookVector * direction.Z * iyflyspeed * 50);
			end
		end
	end);
end
FlyButton.MouseButton1Down:connect(function()
	if not FlyToggle then
		FlyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
		FlyButton.Text = "NoFly";
		if SpeedToggle then
			SpeedToggle = false;
			SpeedButton.Text = "SW";
			SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		end
		mobilefly();
	elseif FlyToggle then
		unmobilefly();
		FlyButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		FlyButton.Text = "Fly";
	end
end);
ChatWarnButton.MouseButton1Down:Connect(function()
	if ChatWarnToggle then
		ChatWarnButton.Text = "Warn";
		ChatWarnButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		ChatWarnToggle = false;
	elseif not ChatWarnToggle then
		ChatWarnButton.Text = "NoWarn";
		ChatWarnButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
		ChatWarnToggle = true;
	end
end);
InstantButton.MouseButton1Down:Connect(function()
	if InstantToggle then
		InstantToggle = false;
		InstantButton.Text = "Insta";
		InstantButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		for _, Object in pairs(prox) do
			Object.HoldDuration = -Object.HoldDuration;
		end
	elseif not InstantToggle then
		InstantToggle = true;
		InstantButton.Text = "NoInsta";
		InstantButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
		for _, Object in pairs(prox) do
			Object.HoldDuration = -Object.HoldDuration;
		end
	end
end);
local hb = RunService.Heartbeat;
SpeedButton.MouseButton1Down:Connect(function()
	if SpeedToggle then
		SpeedToggle = false;
		SpeedButton.Text = "SW";
		SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
	elseif not SpeedToggle then
		SpeedToggle = true;
		SpeedButton.Text = "NoSW";
		SpeedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
		if FlyToggle then
			unmobilefly();
			FlyButton.Text = "Fly";
			FlyButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50);
		end
		while SpeedToggle and char and hum and hum.Parent do
			local delta = hb:Wait();
			if (hum.MoveDirection.Magnitude > 0) then
				char:TranslateBy(hum.MoveDirection * tonumber(0.6) * delta * 10);
			end
		end
	end
end);
char:GetAttributeChangedSignal("Hiding"):Connect(function()
	if char:GetAttribute("Hiding") then
        for _, obj in pairs(CR:GetDescendants()) do
            if not obj:IsA("ObjectValue") and obj.Name ~= "HiddenPlayer" then continue end

            if obj.Value == char then
                task.spawn(function()
                    local affectedParts = {}
                    for _, v in pairs(obj.Parent:GetChildren()) do
                        if not v:IsA("BasePart") then continue end

                        v.Transparency = 0.9
                        table.insert(affectedParts, v)
                    end

                    repeat task.wait()
                        for _, part in pairs(affectedParts) do
                            task.wait()
                            part.Transparency = 0.9
                        end
                    until not char:GetAttribute("Hiding")
                    
                    for _, v in pairs(affectedParts) do
                        v.Transparency = 0
                    end
                end)

                break
            end
        end
    end
end)
plr:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if plr:GetAttribute("CurrentRoom") == 49 or plr:GetAttribute("CurrentRoom") == 50 or plr:GetAttribute("CurrentRoom") == 99 then
        if Floor.Value == "Mines" then
            ws:FindFirstChild("SeekMovingNewClone").Name = "ThisIsTotallyNotSeek"
            ws:FindFirstChild("SeekMoving").Name = "ThisIsTotallyNotSeek"
        end
    elseif plr:GetAttribute("CurrentRoom") == 51 then
        if Floor.Value == "Hotel" then
            if FigureButton.Visible == true then
                FigureButton.Visible = false
                if (hum.Health == 0) then
					ESPButton.Position = UDim2.new(0, 150, 0, -30);
					ChatWarnButton.Position = UDim2.new(0, 190, 0, -30);
				else
					AuraButton.Position = UDim2.new(0, 150, 0, -30);
					ESPButton.Position = UDim2.new(0, 190, 0, -30);
					FlyButton.Position = UDim2.new(0, 230, 0, -30);
					ChatWarnButton.Position = UDim2.new(0, 270, 0, -30);
					InstantButton.Position = UDim2.new(0, 310, 0, -30);
					SeekButton.Position = UDim2.new(0, 350, 0, -30);
					EBFButton.Position = UDim2.new(0, 390, 0, -30);
					SpeedButton.Position = UDim2.new(0, 430, 0, -30);
				end
            end
        end
    elseif plr:GetAttribute("CurrentRoom") == 100 then
        if Floor.Value == "Hotel" then
            --something
        end
    end
end);
plr:GetAttributeChangedSignal("Alive"):Connect(function()
	if plr:GetAttribute("Alive") then
		AuraToggle = true;
		FlyToggle = true;
		InstantToggle = true;
		SeekToggle = true;
		SpeedToggle = true;
		AuraButton.Visible = true;
		FlyButton.Visible = true;
		InstantButton.Visible = true;
		SpeedButton.Visible = true;
		SeekButton.Visible = true;
		if (Floor.Value == "Hotel") then
			if (FigureButton.Visible == false) then
				ESPButton.Position = UDim2.new(0, 190, 0, -30);
				ChatWarnButton.Position = UDim2.new(0, 270, 0, -30);
			else
				ESPButton.Position = UDim2.new(0, 230, 0, -30);
				ChatWarnButton.Position = UDim2.new(0, 310, 0, -30);
			end
			EBFButton.Visible = true;
		else
			ESPButton.Position = UDim2.new(0, 190, 0, -30);
			ChatWarnButton.Position = UDim2.new(0, 270, 0, -30);
		end
	else
		AuraToggle = false;
		FlyToggle = false;
		InstantToggle = false;
		SeekToggle = false;
		SpeedToggle = false;
		AuraButton.Visible = false;
		FlyButton.Visible = false;
		InstantButton.Visible = false;
		SpeedButton.Visible = false;
		SeekButton.Visible = false;
		if (Floor.Value == "Hotel") then
			if (FigureButton.Visible == false) then
				ESPButton.Position = UDim2.new(0, 150, 0, -30);
				ChatWarnButton.Position = UDim2.new(0, 190, 0, -30);
			else
				ESPButton.Position = UDim2.new(0, 190, 0, -30);
				ChatWarnButton.Position = UDim2.new(0, 230, 0, -30);
			end
			EBFButton.Visible = false;
		else
			ESPButton.Position = UDim2.new(0, 150, 0, -30);
			ChatWarnButton.Position = UDim2.new(0, 190, 0, -30);
		end
		pcall(function() AuraFunction:Disconnect() end)
	end
end)
pcall(function() if cutscenes then cutscenes.FigureHotelEnd.Name = "laggycutscene" end end)