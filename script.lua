print("made by Stoven_Chaos")
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))();
local win = lib:Window("STARVING ARTISTS", Color3.fromRGB(188, 19, 254), Enum.KeyCode.RightControl);
local delay = nil;
local timer = nil;
local removeprint = false;
local paintgui = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame;
local Artstab = win:Tab("Arts");
local Visualstab = win:Tab("Visuals");
local Otherstab = win:Tab("Others");
local function toggletimer()
	if (timer == true) then
		local textLabel = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.NextButton.Label;
		local mins = (removeprint and 15) or 5;
		local secs = 0;
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="Timer",Text="The timer has started.",Duration=5});
		task.spawn(function()
			repeat
				if (string.len(secs) < 2) then
					textLabel.Text = mins .. ":0" .. secs;
				else
					textLabel.Text = mins .. ":" .. secs;
				end
				if (secs == 0) then
					secs = 60;
					mins = mins - 1;
				end
				secs = secs - 1;
				wait(1);
			until (mins == 0) and (secs == 0) 
			textLabel.Text = "Ready!!";
			local new = Instance.new("Sound")
			new.Parent = game.SoundService
			new.SoundId = "rbxassetid://9699523130"
			new.PlayOnRemove = true
			new:Destroy();
			game:GetService("StarterGui"):SetCore("SendNotification", {Title="Timer",Text="The timer has ended.",Duration=5});
		end);
	end
end
local function generate(url)
	local image = url;
	local resolutionX = 32;
	local resolutionY = 32;
	local grid = nil;
	local s, e = pcall(function()
		if game.Players.LocalPlayer.PlayerGui("MainGui"):FindFirstChild("PaintFrame"):FindFirstChild("Grid") then
			grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid;
		elseif game.Players.LocalPlayer.PlayerGui("PaintFrame"):FindFirstChild("GridHolder"):FindFirstChild("Grid") then
			grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid;
		else
			warn("cannot execute script");
			return;
		end
	end);
	if e then
		local s1, e1 = pcall(function()
			grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid;
		end);
		if e1 then
			warn("cannot execute script");
			return;
		end
	end
	local h = game:GetService("HttpService");
	function getjson(url)
		local begin = game:HttpGet("https://f818fcf9-3b10-4c92-8176-0bef47a8421d.id.repl.co/get?url=" .. url);
		if (begin == "the file size is too big!") then
			return "fstb";
		else
			local json = h:JSONDecode(begin);
			return json;
		end
	end
	function import(url)
		local pixels = getjson(url);
		local cells = {};
		local index = 1;
		if (pixels == "fstb") then
			game.StarterGui:SetCore("SendNotification", {Title="error",Text=("the file size exceeds three megabytes, " .. "to prevent people from crashing the vps, i have set" .. " the cap to amount. sorry for the inconvenience")});
		else
			grid["1"].BackgroundColor3 = Color3.fromRGB(pixels[1][1], pixels[1][2], pixels[1][3]);
			for y = 1, resolutionX, 1 do
				for x = 1, resolutionY, 1 do
					pcall(function()
						local pixel = pixels[index];
						index = index + 1;
						local r = pixels[index][1];
						local g = pixels[index][2];
						local b = pixels[index][3];
						grid[tostring(index)].BackgroundColor3 = Color3.fromRGB(r, g, b);
						table.insert(cells, pixel);
					end);
				end
			end
			pcall(function()
				local pixel = pixels[index];
				index = index + 1;
				local r = pixels[index][1];
				local g = pixels[index][2];
				local b = pixels[index][3];
				grid[tostring(index)].BackgroundColor3 = Color3.fromRGB(r, g, b);
				table.insert(cells, pixel);
			end);
			game.StarterGui:SetCore("SendNotification", {Title="done",Text="finished importing, check the drawing grid"});
		end
	end
	import(image);
	toggletimer()
end
Otherstab:Toggle("Hide PaintFrame", false, function(toggle)
	if toggle then
		paintgui.Visible = false;
	else
		paintgui.Visible = true;
	end
end);
Otherstab:Toggle("Anti AFK", false, function(toggle)
	local virtualUser = game:GetService("VirtualUser");
	local player = game:GetService("Players").LocalPlayer;
	local antiAfk = false;
	if (toggle and not antiAfk) then
		antiAfk = true;
		player.Idled:Connect(function()
			virtualUser:CaptureController();
			virtualUser:ClickButton2(Vector2.new());
		end);
	else
		antiAfk = false;
		player.Idled:Disconnect();
	end
end);
Otherstab:Textbox("Goto player", true, function(t)
	local Players = game:GetService("Players");
	local targetPlayer = nil;
	for _, player in ipairs(Players:GetPlayers()) do
		if ((player.DisplayName == t) or (player.Name == t)) then
			targetPlayer = player;
			break;
		end
	end
	if targetPlayer then
		local targetCharacter = targetPlayer.Character;
		if targetCharacter then
			local targetPosition = targetCharacter.HumanoidRootPart.Position;
			game:GetService("Players").LocalPlayer.Character:MoveTo(targetPosition);
		end
	end
end);
Otherstab:Button("Serverhop", function()
	local TeleportService = game:GetService("TeleportService");
	local HttpService = game:GetService("HttpService");
	local placeId = game.PlaceId;
	local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")).data;
	local randomServer = servers[math.random(1, #servers)];
	TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, game.Players.LocalPlayer);
end);
Otherstab:Button("Rejoin", function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer);
end);
Visualstab:Toggle("Remove print emoji", false, function(t)
	removeprint = t;
end);
Visualstab:Toggle("Timer", false, function(t)
	timer = t;
end);
Visualstab:Toggle("Delay", false, function(t)
	delay = t;
end);
Artstab:Textbox("Generate from URL", true, function(link)
	generate(link)
end);
Artstab:Dropdown("Select Art", {"Tanjiro2","Cat18","Kazuha","Cat17","Cat16","Cat15","Cat14","Cat13","Cake","Raiden_Shogun","Nahida","Tanjiro","Dori","Cat12","Cat11","Cat10","Diona","Cat9","Anya","Klee","Cat8","Cat7","Cat6","Cat5","Cat4","Cat3","Cat2","Cat1","Cat"}, function(option)
	local data = {};
	data['Tanjiro2'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Tanjiro2.lua'))()
	data['Cat18'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat18.lua'))()
	data['Kazuha'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Kazuha.lua'))()
	data['Cat17'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat17.lua'))()
	data['Cat16'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat16.lua'))()
	data['Cat15'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat15.lua'))()
	data['Cat14'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat14.lua'))()
	data['Cat13'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat13.lua'))()
	data['Cake'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cake.lua'))()
	data['Raiden_Shogun'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Raiden%20Shogun.lua'))()
	data['Nahida'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Nahida.lua'))()
	data['Tanjiro'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Tanjiro.lua'))()
	data['Dori'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Dori.lua'))()
	data['Cat12'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat12.lua'))()
	data['Cat11'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat11.lua'))()
	data['Cat10'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat10.lua'))()
	data['Diona'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Diona.lua'))()
	data['Cat9'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat9.lua'))()
	data['Anya'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Anya.lua'))()
	data['Klee'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Klee.lua'))()
	data['Cat8'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat8.lua'))()
	data['Cat7'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat7.lua'))()
	data['Cat6'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat6.lua'))()
	data['Cat5'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat5.lua'))()
	data['Cat4'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat4.lua'))()
	data['Cat3'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat3.lua'))()
	data['Cat2'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat2.lua'))()
	data['Cat1'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat1.lua'))()
	data['Cat'] = loadstring(game:HttpGet('https://raw.githubusercontent.com/Stevenanl/A/main/Cat.lua'))()
	local Pixels = data[option];
	local UI = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid;
	toggletimer()
	for i, v in pairs(Pixels) do
		if ((delay == true) and not removeprint) then
			UI[i].BackgroundColor3 = Color3.fromRGB(v.R, v.G, v.B), wait(0.05);
		elseif ((delay == true) and removeprint) then
			UI[i].BackgroundColor3 = Color3.fromRGB(v.R, v.G, v.B), wait(0.87);
		else
			UI[i].BackgroundColor3 = Color3.fromRGB(v.R, v.G, v.B);
		end
	end
end);
Artstab:Dropdown("Select Generated Art", {"Cat", "Dog", "Luffy"}, function(art)
	if art == "Cat" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1160648397909413888/Untitled31_20231009024207.png?ex=65356d0d&is=6522f80d&hm=d96b803f715c254e92f5b8518a894ee8d69a3291db8cd1d4e9866f7c8aa9c69d&")
	elseif art == "Dog" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1160678891736801391/Untitled39_20231009044251.png?ex=65358974&is=65231474&hm=d46cdcaae142c0aef5887cea043320a3f1231f70dfa04b77f64d1caf141256ae&")
	elseif art == "Luffy" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1160676017086672966/Untitled38_20231009043147.png?ex=653586c6&is=652311c6&hm=21b490d6548a0ac9e2e9dab6a99993e77a13b42016a37952aa0b7461cc3fa30b&")
	end
end);
