--
-- StepsInfo.lua - display step artist & group in Step Statistics panel
-- Club Fantastic Project
--

local player = ...
local PlayerState  = GAMESTATE:GetPlayerState(player)

local NoteFieldIsCentered = (GetNotefieldX(player) == _screen.cx)
local IsUltraWide = (GetScreenAspectRatio() > 21/9)

local af = Def.ActorFrame{}

af.InitCommand=function(self)
	self:SetUpdateFunction(Update)
	self:x(SL_WideScale(150,202) * (player==PLAYER_1 and -1 or 1))
	self:y(25)

	if NoteFieldIsCentered and IsUsingWideScreen() then
		self:x( 154 * (player==PLAYER_1 and -1 or 1) )
	end

	-- flip alignment when ultrawide and both players joined
	if IsUltraWide and #GAMESTATE:GetHumanPlayers() > 1 then
		self:x(self:GetX() * -1)
	end
end

local FormatGroup = function(song)
    if song then
        local fmt = "%s: %s"
        return fmt:format(THEME:GetString("ScreenSelectMusic", "Group"), song:GetGroupName())
    end
    return ""
end

local FormatStepArtist = function()
    if not GAMESTATE:IsCourseMode() then
        -- there doesn't appear to be a way to easily the current steps object
        -- for the current course. probably missed something, but gotta get
        -- this out sooner rather than later
        local artist = GAMESTATE:GetCurrentSteps(player):GetAuthorCredit()
        if artist then
            local fmt = "%s: %s"
            return fmt:format(THEME:GetString("ScreenSelectMusic", "STEPS"), artist)
        end
    end
    return ""
end

af[#af+1] = LoadFont("Common Normal")..{
    Name="StepsInfo_StepArtist",
	InitCommand=function(self)
        self:xy(0,0)
        self:zoom(0.75)
        self:maxwidth(250)
        self:halign(PlayerNumber:Reverse()[player]):vertalign(bottom)

		if IsUltraWide and #GAMESTATE:GetHumanPlayers() > 1 then
			self:halign( PlayerNumber:Reverse()[OtherPlayer[player]] )
			self:x(50 * (player==PLAYER_1 and -1 or 1))
		end

        self:queuecommand("CurrentSongChangedMessage")
    end,
    CurrentSongChangedMessageCommand=function(self, params)
        self:settext(FormatStepArtist())
    end
}

af[#af+1] = LoadFont("Common Normal")..{
    Name="StepsInfo_Group",
	InitCommand=function(self)
        self:xy(0,20)
        self:zoom(0.75)
        self:maxwidth(250)
        self:halign(PlayerNumber:Reverse()[player]):vertalign(bottom)

		if IsUltraWide and #GAMESTATE:GetHumanPlayers() > 1 then
			self:halign( PlayerNumber:Reverse()[OtherPlayer[player]] )
			self:x(50 * (player==PLAYER_1 and -1 or 1))
		end

        self:queuecommand("CurrentSongChangedMessage")
    end,
    CurrentSongChangedMessageCommand=function(self, params)
        self:settext(FormatGroup(GAMESTATE:GetCurrentSong()))
    end
}

return af
