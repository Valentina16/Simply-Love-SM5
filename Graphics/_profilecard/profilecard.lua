local args = ...
local player = args.player
local LowerCardFrame = args.loweraf
local PlayerNumber = tonumber(player:sub(-1))
local profile = PROFILEMAN:GetProfile(player)
local hassubtitle = false

local FallbackImg = "fallbackav.png"
local guestprofile = false
if profile then
    local ppath = PROFILEMAN:GetProfileDir("ProfileSlot_Player"..PlayerNumber).."/avatar.png"
    if ppath == "/avatar.png" then guestprofile = true end
    if not guestprofile then FallbackImg = FILEMAN:DoesFileExist(ppath) and ppath or "fallbackav.png" end
else

end

if not LowerCardFrame then LowerCardFrame = Def.ActorFrame{} end
LowerCardFrame.InitCommand = function(self) self:y(24) end

local namezoom = (not hassubtitle) and 1.2 or 1.05

local w = 96
local h = 128

local ProfileCardCointainerFrame = Def.ActorFrame{
    Def.Quad{
        InitCommand = function(self)
            self:zoomto(w, h)
        end
    },
    Def.Quad{
        InitCommand = function(self)
            self:zoomto(w - 2, h - 2)
            self:diffuse(0.1,0.1,0.1,1)
        end
    },
    LoadFont("Common Normal")..{
        Text = (not guestprofile) and profile:GetDisplayName() or "Guest",
        InitCommand = function(self)
            self:y(-h/2 + 13)
            self:zoom(namezoom)
            self:maxwidth((w - 3) / namezoom)
            if hassubtitle then self:addy(-3) end
        end
    },
    LoadFont("Common Normal")..{
        Text = "",
        InitCommand = function(self)
            self:zoom(0.6)
            self:y(-h/2 + 26)
            self:maxwidth((w-3)/0.6)
        end
    },
    LoadActor(FallbackImg)..{
        InitCommand = function(self)
            self:zoomto(48,48)
            self:y(-h/2 + 52)
            if hassubtitle then self:addy(4) end
        end
    },
    LowerCardFrame,
    LoadFont("Common Normal")..{
        Text = (not guestprofile) and "" or "",
        InitCommand = function(self)
            self:zoom(0.8)
            self:y(44)
        end
    }
}

return ProfileCardCointainerFrame