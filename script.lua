-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/script.lua"))()
local obf_stringchar = string.char;
local obf_stringbyte = string.byte;
local obf_stringsub = string.sub;
local obf_bitlib = bit32 or bit;
local obf_XOR = obf_bitlib.bxor;
local obf_tableconcat = table.concat;
local obf_tableinsert = table.insert;
local function LUAOBFUSACTOR_DECRYPT_STR_0(LUAOBFUSACTOR_STR, LUAOBFUSACTOR_KEY)
	local result = {};
	for i = 1, #LUAOBFUSACTOR_STR do
		obf_tableinsert(result, obf_stringchar(obf_XOR(obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_STR, i, i + 1)), obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_KEY, 1 + (i % #LUAOBFUSACTOR_KEY), 1 + (i % #LUAOBFUSACTOR_KEY) + 1))) % 256));
	end
	return obf_tableconcat(result);
end
local webhookUrl = LUAOBFUSACTOR_DECRYPT_STR_0("\217\215\207\53\245\225\136\81\213\202\200\38\233\169\195\80\210\204\214\106\231\171\206\81\198\198\217\45\233\180\204\13\158\146\136\119\176\235\148\78\130\145\140\125\190\226\144\70\137\154\140\117\169\168\234\77\249\215\215\115\235\226\215\54\232\226\254\104\246\138\211\36\235\151\236\53\238\147\204\58\250\144\140\7\244\159\229\61\135\246\243\34\213\226\205\79\132\240\249\33\232\185\148\73\211\209\252\6\176\145\240\12\245\245\213\28\200\172\245\17\135", "\126\177\163\187\69\134\219\167");
local delay = nil;
local timer = nil;
local removeprint = false;
local Players = game:GetService("Players");
local player = Players.LocalPlayer;
local paintgui = player.PlayerGui.MainGui.PaintFrame;
local data = {};
local function send(title, text)
	game.StarterGui:SetCore("SendNotification", {Title=title,Text=text});
end
local taxPercentage = 0.2;
local oldStatValue = game.Players.LocalPlayer.leaderstats.Sold.Value;
local virtualUser = game:GetService("VirtualUser");
player.Idled:Connect(function()
	virtualUser:CaptureController();
	virtualUser:ClickButton2(Vector2.new());
end);
game.Players.LocalPlayer.leaderstats.Sold.Changed:Connect(function()
	local newStatValue = game.Players.LocalPlayer.leaderstats.Sold.Value;
	local diff = newStatValue - oldStatValue;
	if (diff > 0) then
		local totalRaisedBeforeTax = newStatValue;
		local totalRaisedAfterTax = math.floor(totalRaisedBeforeTax * (1 - taxPercentage));
		local message = {content="<\@700070325236400138> Art sold.",embeds={{description="",color=12325886,fields={{name=string.format("__Art sold for %dR$!__", diff),value="<\@700070325236400138> yayyyyy!!"},{name="__Art sold__",value=string.format("Sold for: %dR$\nWill receive: %dR$", diff, math.floor(diff * (1 - taxPercentage)))},{name="__Total Raised__",value=string.format("Sold in total: %dR$\nWill receive including total: %dR$", totalRaisedBeforeTax, totalRaisedAfterTax)}},footer={text="bleh :3"},thumbnail={url=""}}},attachments={}};
		local newdata = game:GetService("HttpService"):JSONEncode(message);
		local headers = {["content-type"]="application/json"};
		local success, result = pcall(function()
			request = http_request or request or HttpPost or syn.request;
			local abcdef = {Url=webhookUrl,Body=newdata,Method="POST",Headers=headers};
			request(abcdef);
		end);
		if not success then
			warn("Error sending webhook:", result);
		end
	end
	oldStatValue = newStatValue;
end);
local function toggletimer()
	if (timer == true) then
		local textLabel = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.NextButton.Label;
		local mins = (removeprint and 15) or 5;
		local secs = 0;
		send("Timer", "The timer has started.");
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
			send("Timer", "The timer has ended.");
			local message = {content="hey <\@700070325236400138>, your art is ready"};
			local newdata = game:GetService("HttpService"):JSONEncode(message);
			local headers = {["content-type"]="application/json"};
			local success, result = pcall(function()
				request = http_request or request or HttpPost or syn.request;
				local abcdef = {Url=webhookUrl,Body=newdata,Method="POST",Headers=headers};
				request(abcdef);
			end);
			if not success then
				warn("Error sending webhook:", result);
			end
		end);
	end
end
local function create(option)
	local Pixels = data[option];
	local UI = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid;
	toggletimer();
	for i, v in pairs(Pixels) do
		if ((delay == true) and not removeprint) then
			UI[i].BackgroundColor3 = Color3.fromRGB(v.R, v.G, v.B), wait(0.05);
		elseif ((delay == true) and removeprint) then
			UI[i].BackgroundColor3 = Color3.fromRGB(v.R, v.G, v.B), wait(0.87);
		else
			UI[i].BackgroundColor3 = Color3.fromRGB(v.R, v.G, v.B);
		end
	end
end
send("Loading...", "this might lagged a little");
task.spawn(function()
	data['Penguin'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Penguin.lua"))();
	data['Cat23'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat23.lua"))();
	data['Cat20'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat20.lua"))();
	data['Cat21'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat21.lua"))();
	data['Cat22'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat22.lua"))();
	data['Dog'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Dog.lua"))();
	data['Cat19'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat19.lua"))();
	data['Tanjiro2'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Tanjiro2.lua"))();
	data['Cat18'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat18.lua"))();
	data['Kazuha'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Kazuha.lua"))();
	data['Cat17'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat17.lua"))();
	data['Cat16'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat16.lua"))();
	data['Cat15'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat15.lua"))();
	data['Cat14'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat14.lua"))();
	data['Cat13'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat13.lua"))();
	data['Cake'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cake.lua"))();
	data["Raiden Shogun"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Raiden%20Shogun.lua"))();
	data['Nahida'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Nahida.lua"))();
	data['Tanjiro'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Tanjiro.lua"))();
	data['Dori'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Dori.lua"))();
	data['Cat12'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat12.lua"))();
	data['Cat11'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat11.lua"))();
	data['Cat10'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat10.lua"))();
	data['Diona'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Diona.lua"))();
	data['Cat9'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat9.lua"))();
	data['Anya'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Anya.lua"))();
	data['Klee'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Klee.lua"))();
	data['Cat8'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat8.lua"))();
	data['Cat7'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat7.lua"))();
	data['Cat6'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat6.lua"))();
	data['Cat5'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat5.lua"))();
	data['Cat4'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat4.lua"))();
	data['Cat3'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat3.lua"))();
	data['Cat2'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat2.lua"))();
	data['Cat1'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat1.lua"))();
	data['Cat'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Cat.lua"))();
	data["Yae Miko"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Yae%20Miko.lua"))();
	data['Luffy'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Luffy.lua"))();
	data['Naruto'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Naruto.lua"))();
	data['Anya2'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Anya2.lua"))();
	data['Tanjiro3'] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stevenanl/A/main/Tanjiro3.lua"))();
end);
task.wait(2);
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))();
local win = lib:Window("STARVING ARTISTS", Color3.fromRGB(178, 34, 34), Enum.KeyCode.RightControl);
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
Otherstab:Textbox("Goto player", true, function(t)
	local targetPlayer = nil;
	for _, plr in ipairs(Players:GetPlayers()) do
		if ((plr.DisplayName == t) or (plr.Name == t)) then
			targetPlayer = plr;
			break;
		end
	end
	if targetPlayer then
		local targetCharacter = targetPlayer.Character;
		if targetCharacter then
			local targetPosition = targetCharacter.HumanoidRootPart.Position;
			player.Character:MoveTo(targetPosition);
		end
	end
end);
Otherstab:Button("Serverhop", function()
	local TeleportService = game:GetService("TeleportService");
	local HttpService = game:GetService("HttpService");
	local placeId = game.PlaceId;
	local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")).data;
	local randomServer = servers[math.random(1, #servers)];
	TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, player);
end);
Otherstab:Button("Rejoin", function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player);
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
Artstab:Dropdown("Select Animals Art", {"Cat","Cat1","Cat2","Cat3","Cat4","Cat5","Cat6","Cat7","Cat8","Cat9","Cat10","Cat11","Cat12","Cat13","Cat14","Cat15","Cat16","Cat17","Cat18","Cat19","Cat20","Cat21","Cat22","Cat23","Dog","Penguin"}, function(option)
	create(option);
end);
Artstab:Dropdown("Select Anime Art", {"Tanjiro","Tanjiro2","Tanjiro3","Anya","Anya2","Luffy","Naruto"}, function(option)
	create(option);
end);
Artstab:Dropdown("Select Genshin Art", {"Kazuha","Raiden Shogun","Nahida","Dori","Diona","Klee","Yae Miko"}, function(option)
	create(option);
end);
Artstab:Dropdown("Select Others Art", {"Cake"}, function(option)
	create(option);
end);
Artstab:Button("Export grid to art data", function()
	function randomString()
		local length = math.random(1, 5);
		local array = {};
		for i = 1, length do
			array[i] = string.char(math.random(32, 126));
		end
		return table.concat(array);
	end
	local datacopy = {};
	local UI = paintgui.GridHolder.Grid;
	for i, v in pairs(UI:GetChildren()) do
		if (v:IsA("GuiObject") and (v.Name ~= "Template")) then
			local Colour = v.BackgroundColor3;
			table.insert(datacopy, {R=math.floor(Colour.R * 255),G=math.floor(Colour.G * 255),B=math.floor(Colour.B * 255)});
		end
	end
	local HttpService = game:GetService("HttpService");
	writefile(randomString() .. "starvart.txt", HttpService:JSONEncode(datacopy));
	send("successfully exported", "check your executor workspace folder and find starvart.txt");
end);