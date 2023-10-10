print("made by Stoven_Chaos")
local delay = nil;
local timer = nil;
local removeprint = false;
local paintgui = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame;
local data = {};
local function send(title,text)
	game.StarterGui:SetCore("SendNotification", {Title=title,Text=text});
end
local function toggletimer()
	if (timer == true) then
		local textLabel = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.NextButton.Label;
		local mins = (removeprint and 15) or 5;
		local secs = 0;
		send("Timer","The timer has started.");
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
			send("Timer","The timer has ended.");
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
			send("error",("the file size exceeds three megabytes, " .. "to prevent people from crashing the vps, i have set" .. " the cap to amount. sorry for the inconvenience"));
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
			send("done","finished importing, check the drawing grid");
		end
	end
	import(image);
	toggletimer()
end
send("Loading...","this might lagged a little")
task.wait(.7)
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
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))();
local win = lib:Window("STARVING ARTISTS", Color3.fromRGB(188, 19, 254), Enum.KeyCode.RightControl);
local Artstab = win:Tab("Arts");
local Visualstab = win:Tab("Visuals");
local Otherstab = win:Tab("Others");
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
Artstab:Dropdown("Select Generated Art", {"Cat", "Cat2", "Cat3", "Cat4", "Dog", "Luffy", "Yae Miko"}, function(art)
	if art == "Cat" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161385120691920926/Untitled42_20231011032157.png?ex=65381b2e&is=6525a62e&hm=c816fc2a3d468f4d02c642bbf7df515b000b7f1bbd49d810032f37ffe5003d5a&")
	elseif art == "Dog" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161385120259915809/Untitled42_20231011032517.png?ex=65381b2e&is=6525a62e&hm=78e437c786439fcbcca029d1402f6c92f8f6188c9c1104270e26fded626435dc&")
	elseif art == "Luffy" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161385121019072532/Untitled42_20231011031417.png?ex=65381b2e&is=6525a62e&hm=e85404e111d09d260b12bac4c1e937a5d11c4ef581be2910d3c6a03083445b78&")
	elseif art == "Cat2" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161388012744220823/Untitled44_20231011034103.png?ex=65381ddf&is=6525a8df&hm=8ab6d35a39bb1da4590b3daec2fc63605fecf505c923d50a8ff85e5574cc0644&")
	elseif art == "Yae Miko" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161400367012126820/Untitled45_20231011043009.png?ex=65382961&is=6525b461&hm=a28f34b27ec18498f72b47df53b909620e9068b6de7fa7bba0de754dbeb1fc8e&")
	elseif art == "Cat3" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161403141732962314/Untitled46_20231011044109.png?ex=65382bf6&is=6525b6f6&hm=066f578b4ae89c04e58f0616794f66ac1faef65fb59ac16024d0320ab9d4763c&")
	elseif art == "Cat4" then
		generate("https://cdn.discordapp.com/attachments/1046553567101730906/1161405290877558966/Untitled47_20231011044909.png?ex=65382df7&is=6525b8f7&hm=d107d2176dbcdb3f91b7768072c94b0e00443287db8abe0c1091f34a95e66976&")
	end
end);
