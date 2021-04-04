-- per-player upper half of ScreenEvaluation

local player = ...
local StarGradeCounterActive = ThemePrefs.Get("ShowStarsCountsOnEval")
local xPosition = StarGradeCounterActive and 200 or 155

return Def.ActorFrame{
	Name=ToEnumShortString(player).."_AF_Upper",
	OnCommand=function(self)
		if player == PLAYER_1 then
			self:x(_screen.cx - xPosition)
		elseif player == PLAYER_2 then
			self:x(_screen.cx + xPosition)
		end
	end,

	-- letter grade
	LoadActor("./LetterGrade.lua", player),

	-- nice
	LoadActor("./nice.lua", player),

	-- stepartist
	LoadActor("./StepArtist.lua", player),

	-- difficulty text and meter
	LoadActor("./Difficulty.lua", player),

	-- Record Texts (Machine and/or Personal)
	LoadActor("./RecordTexts.lua", player),

	-- Show how many stars have the profile
	LoadActor("./ProfileCardStars.lua", player)
}