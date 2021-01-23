local player, controller = unpack(...)

local isFAPlus = SL.Global.GameMode == "FA+"

local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local PercentDP = stats:GetPercentDancePoints()
local percent = FormatPercentScore(PercentDP)
-- Format the Percentage string, removing the % symbol
percent = percent:gsub("%%", "")

local FAPlusPercent = ""

if isFAPlus then
	local notes = stats:GetRadarPossible():GetValue("RadarCategory_TapsAndHolds")
	local blues = stats:GetTapNoteScores("TapNoteScore_W1")

	FAPlusPercent = (notes ~= 0) and string.format("%0.2f", math.floor(10000*(blues/notes))/100) or "0.00"
end

local PercentageContainer_ITG = {
	QuadY = _screen.cy - 26,
	NormalPercentY = 0,
	FAPlusPercentY = 0,
	Height = 60
}

local PercentageContainer_FAPlus = {
	QuadY = _screen.cy - 11,
	NormalPercentY = -15,
	FAPlusPercentY = 25,
	Height = 90
}

local PercentageContainer = isFAPlus and PercentageContainer_FAPlus or PercentageContainer_ITG

local t = Def.ActorFrame{
	Name="PercentageContainer"..ToEnumShortString(player),
	OnCommand=function(self)
		self:y(PercentageContainer.QuadY)
	end
}

-- dark background quad behind player percent score
t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:diffuse(color("#101519")):zoomto(158.5, PercentageContainer.Height)
		self:horizalign(controller==PLAYER_1 and left or right)
		self:x(150 * (controller == PLAYER_1 and -1 or 1))
	end
}

-- main percent text
t[#t+1] = LoadFont("Wendy/_wendy white")..{
	Name="Percent",
	Text= percent,
	InitCommand=function(self)
		self:horizalign(right):zoom(0.585)
		self:y(PercentageContainer.NormalPercentY)
		self:x( (controller == PLAYER_1 and 1.5 or 141))
	end
}


if isFAPlus then
	t[#t+1] = LoadFont("Common Normal")..{
		Text="FA+ [15ms]",
		InitCommand=function(self) self:zoom(0.7):horizalign(right):maxwidth(76) end,
		BeginCommand=function(self)
			self:x((controller == PLAYER_1 and -88) or 52 )
			self:y(PercentageContainer.FAPlusPercentY + 1)
			self:diffuse(SL.JudgmentColors[SL.Global.GameMode][1])
		end
	}

	t[#t+1] = LoadFont("Wendy/_wendy white")..{
		Text = FAPlusPercent,
		InitCommand = function(self) self:zoom(0.35):horizalign(right) end,
		BeginCommand = function(self)
			self:y(PercentageContainer.FAPlusPercentY)
			self:x( (controller == PLAYER_1 and 0 or 139))
			self:diffuse(SL.JudgmentColors[SL.Global.GameMode][1])
		end
	}
end


return t