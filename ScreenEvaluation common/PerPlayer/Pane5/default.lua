local player = ...

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
local PercentDP = stats:GetPercentDancePoints()


local score = FormatPercentScore(PercentDP)
score = tostring(tonumber((score:gsub("%%", ""))) * 100)

local failed = stats:GetFailed() and "1" or "0"
local rate = tostring(SL.Global.ActiveModifiers.MusicRate * 100)
Trace("Score: " .. score .. " Failed: " .. failed .. " Rate: " .. rate)

local currentSteps = GAMESTATE:GetCurrentSteps(player)
local difficulty = ""
if currentSteps then
	difficulty = currentSteps:GetDifficulty();
	-- GetDifficulty() returns a value from the Difficulty Enum
	-- "Difficulty_Hard" for example.
	-- Strip the characters up to and including the underscore.
	difficulty = ToEnumShortString(difficulty)
end
local style = ""
if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
	style = "dance-double"
else
	style = "dance-single"
end
local hash = GenerateHash(style, difficulty):sub(1, 12)

local qrcode_size = 168
local url = ("http://www.groovestats.com/qr.php?h=%s&s=%s&f=%s&r=%s"):format(hash, score, failed, rate)
Trace(url)

-- ------------------------------------------

local pane = Def.ActorFrame{
	Name="Pane5",
	InitCommand=function(self)
		self:visible(false)
	end
}

pane[#pane+1] = qrcode_amv( url, qrcode_size )..{
	OnCommand=function(self)
		self:xy(-23,190)
	end
}

pane[#pane+1] = LoadActor("../Pane2/Percentage.lua", player)

pane[#pane+1] = LoadFont("_miso")..{
	Text="GrooveStats QR",
	InitCommand=function(self) self:xy(-140, 222):align(0,0) end
}

pane[#pane+1] = Def.Quad{
	InitCommand=function(self) self:xy(-140, 245):zoomto(96,1):align(0,0):diffuse(1,1,1,0.33) end
}

pane[#pane+1] = LoadFont("_miso")..{
	Text="Scan with your phone to upload this score to your GrooveStats account.",
	InitCommand=function(self) self:zoom(0.8):xy(-140,255):wrapwidthpixels(96/0.8):align(0,0):vertspacing(-4) end
}

pane[#pane+1] = LoadFont("_miso")..{
	Text="Coming Soon!",
	InitCommand=function(self) self:zoom(0.85):xy(-140,344):wrapwidthpixels(145/0.85):align(0,0):vertspacing(-4) end
}

return pane