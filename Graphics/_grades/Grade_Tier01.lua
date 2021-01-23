local pss = ...
local isQuintStar = false

--note: we don't actually need to check anything other than these values, because in the correct file loaded by having a quad already
if SL.Global.GameMode == "FA+" and pss and pss:GetTapNoteScores('TapNoteScore_W2') == 0 then
	
	isQuintStar = true
	-- SOUND:PlayOnce('something cool!')
end

local function Spin(self)
	r = math.min(math.random(3,51),36)
	s = math.random()*7+1
	z = self:GetZ()
	l = r/36

	if z >= 36 then
		z = z-36
		self:z(z)
		self:rotationz(z*10)
	end

	z = z + r
	self:linear(l)
	self:rotationz(z*10)
	self:z(z)
	self:sleep(s)
	self:queuecommand("Spin")
end

--tfw you have no idea how SM5 bezier works, time to learn !
--[[
    Def.Quad {
	    OnCommand=function(self) self:zoom(20):x(-100):sleep(2):bezier(1,{0,0,0.9,0,0.1,1,1,1}):x(100) end
    },
]]

local af

if isQuintStar then -- quint time, wooooooo

	af = Def.ActorFrame{

		-- top left
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:diffuse(.9,.9,.9,1):x(-54):y(-54):basezoomx(0.35):basezoomy(0.35):
							skewx(1):zoomx(2):zoomy(0):sleep(1.0):bezier(.25,{0,0,0.9,0,0.1,1,1,1}):zoom(1):skewx(0):
							pulse():effectmagnitude(1,0.9,0):sleep(60):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},

		-- top right
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:diffuse(.9,.9,.9,1):x(54):y(-54):basezoomx(0.35):basezoomy(0.35):effectoffset(0.2):
							skewx(1):zoomx(2):zoomy(0):sleep(1.2):bezier(.25,{0,0,0.9,0,0.1,1,1,1}):zoom(1):skewx(0):
							pulse():effectmagnitude(0.9,1,0):sleep(3):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},

		-- bottom right
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:diffuse(.9,.9,.9,1):x(54):y(54):basezoomx(0.35):basezoomy(0.35):effectoffset(0.6):
							skewx(1):zoomx(2):zoomy(0):sleep(1.4):bezier(.25,{0,0,0.9,0,0.1,1,1,1}):zoom(1):skewx(0):
							pulse():effectmagnitude(1,0.9,0):sleep(48):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},

		-- bottom left
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:diffuse(.9,.9,.9,1):x(-54):y(54):basezoomx(0.35):basezoomy(0.35):effectoffset(0.4):
							skewx(1):zoomx(2):zoomy(0):sleep(1.6):bezier(.25,{0,0,0.9,0,0.1,1,1,1}):zoom(1):skewx(0):
							pulse():effectmagnitude(0.9,1,0):sleep(11):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},
		
		-- center
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:x(0):y(0):basezoomx(0.52):basezoomy(0.44):effectoffset(0.8):
							skewx(1):zoomx(2):zoomy(0):sleep(2.5):bezier(1,{0,0,0.9,0,0.1,1,1,1}):zoom(1):skewx(0):
							pulse():effectmagnitude(0.9,1,0):sleep(32) end
		}

	}

else --default animation for quads in Simply Love
	
	af =  Def.ActorFrame{
	
		-- top left
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:x(-46):y(-46):zoom(0.5):pulse():effectmagnitude(1,0.9,0):sleep(60):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},

		-- top right
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:x(46):y(-46):zoom(0.5):effectoffset(0.2):pulse():effectmagnitude(0.9,1,0):sleep(3):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},

		-- bottom left
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:x(-46):y(46):zoom(0.5):effectoffset(0.4):pulse():effectmagnitude(0.9,1,0):sleep(11):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		},

		-- bottom right
		LoadActor("star.lua", pss)..{
			OnCommand=function(self) self:x(46):y(46):zoom(0.5):effectoffset(0.6):pulse():effectmagnitude(1,0.9,0):sleep(48):queuecommand("Spin") end,
			SpinCommand=function(self) Spin(self) end
		}
		
	}
	
end

return af
