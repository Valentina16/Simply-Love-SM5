local player = ...
local StarGradeCounterActive = ThemePrefs.Get("ShowStarsCountsOnEval")

if StarGradeCounterActive then return end

-- Read the stars count file
ReadStarsCountFile(player)

ProfileCardLowerAF = function()
	local ProfileCardFrame = Def.ActorFrame{}
    local positions = {{-34, 2}, {12, 2}, {-34, 24}, {12, 24}}
	for i = 1, 4 do
		ProfileCardFrame[#ProfileCardFrame+1] = LoadActor(THEME:GetPathG("", "_GradesSmall/LetterGradeSmall.lua"), {grade = i, itg = true})..{
			OnCommand = function(self) self:zoom(0.2):xy(positions[i][1], positions[i][2]) end
		}
		ProfileCardFrame[#ProfileCardFrame+1] = LoadFont("Common Normal")..{
			Text = tostring(SL[ToEnumShortString(player)].StarsGradesCount[i]),
			InitCommand = function(self) self:zoom(0.75):xy(positions[i][1] + 32, positions[i][2]+1)
				:maxwidth(20/0.75):horizalign("right") end
		}
	end
	return ProfileCardFrame
end

return LoadActor(THEME:GetPathG("", "_profilecard/profilecard.lua"), {player = player, LowerCardFrame = ProfileCardLowerAF()})..{
    InitCommand = function(self) self:xy((player == PLAYER_1 and -1 or 1) * WideScale(104,168),100) end
}