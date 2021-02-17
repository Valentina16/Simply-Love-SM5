local Players = GAMESTATE:GetHumanPlayers()
local NumPanes = SL.Global.GameMode=="Casual" and 1 or 6

if ThemePrefs.Get("WriteCustomScores") then
	WriteScores()
end

local t = Def.ActorFrame{}

if SL.Global.GameMode ~= "Casual" then
	-- add a lua-based InputCalllback to this screen so that we can navigate
	-- through multiple panes of information; pass a reference to this ActorFrame
	-- and the number of panes there are to InputHandler.lua
	t.OnCommand=function(self)
		if SL.Global.GameMode ~= "Casual" then
			SCREENMAN:GetTopScreen():AddInputCallback( LoadActor("./InputHandler.lua", {self, NumPanes}) )
		end
	end
end

-- -----------------------------------------------------------------------
-- First, add actors that would be the same whether 1 or 2 players are joined.

-- code for triggering a screenshot and animating a "screenshot" texture
t[#t+1] = LoadActor("./Shared/ScreenshotHandler.lua")

-- the title of the song and its graphical banner, if there is one
t[#t+1] = LoadActor("./Shared/TitleAndBanner.lua")

-- text to display BPM range (and ratemod if ~= 1.0) immediately under the banner
t[#t+1] = LoadActor("./Shared/BPM_RateMod.lua")

-- store some attributes of this playthrough of this song in the global SL table
-- for later retrieval on ScreenEvaluationSummary
t[#t+1] = LoadActor("./Shared/GlobalStorage.lua")

-- help text that appears if we're in Casual gamemode
t[#t+1] = LoadActor("./Shared/CasualHelpText.lua")

-- -----------------------------------------------------------------------
-- Then, load player-specific actors.

for player in ivalues(Players) do

	if not SL[ToEnumShortString(player)].ActiveModifiers.StarGradeCounter
	then
		-- store player stats for later retrieval on EvaluationSummary and NameEntryTraditional
		-- this doesn't draw anything to the screen, it just runs some code
		t[#t+1] = LoadActor("./PerPlayer/Storage.lua", player)

		-- the per-player upper half of ScreenEvaluation, including: letter grade, nice
		-- stepartist, difficulty text, difficulty meter, machine/personal HighScore text
		t[#t+1] = LoadActor("./PerPlayer/Upper/default.lua", player)

		-- the per-player lower half of ScreenEvaluation, including:
		-- judgment scatterplot, modifier list, disqualified text
		t[#t+1] = LoadActor("./PerPlayer/Lower/default.lua", player)
	else
		t[#t+1] = Def.ActorFrame{
			Name=ToEnumShortString(player).."_AF_Upper",
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:x(_screen.cx - 155)
				elseif player == PLAYER_2 then
					self:x(_screen.cx + 155)
				end
			end,
			
			-- store player stats for later retrieval on EvaluationSummary and NameEntryTraditional
			-- this doesn't draw anything to the screen, it just runs some code
			LoadActor("./PerPlayer/Storage.lua", player),

			-- the per-player upper half of ScreenEvaluation, including: letter grade, nice
			-- stepartist, difficulty text, difficulty meter, machine/personal HighScore text
			LoadActor("./PerPlayer/Upper/default.lua", player),

			-- profile card
			LoadActor(THEME:GetPathG("", "_profilecard/profilecard.lua"), {player = player, 
				loweraf = ProfileCardLowerAF(player)})..{
					InitCommand = function(self) self:xy((player == PLAYER_1 and -1 or 1) * WideScale(104,168),100) end
			}
		}

		-- the per-player lower half of ScreenEvaluation, including:
		-- judgment scatterplot, modifier list, disqualified text
		t[#t+1] = LoadActor("./PerPlayer/Lower/default.lua", player)
	end
end

-- -----------------------------------------------------------------------
-- Finally, load Panes.

t[#t+1] = LoadActor("./Panes/default.lua", NumPanes)

return t
