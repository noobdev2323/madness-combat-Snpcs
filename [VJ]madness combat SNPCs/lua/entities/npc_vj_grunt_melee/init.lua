AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
--------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/madness/npc/grunt_npc.mdl"}
ENT.melee = 0
ENT.VJ_NPC_Class = {"CLASS_AAHW"}

function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
	local melee = math.random(1,4)
	if melee == 1 then
		self.melee = 1
		self.knife = ents.Create("prop_physics")
		self.knife:SetModel("models/madness/weapons/w_knife.mdl")
		self.knife:SetLocalPos(self:GetPos())
		self.knife:SetOwner(self)
		self.knife:SetParent(self)
		//self.knife:SetLocalAngles(Angle(-120,0,90))
		//self.knife:Fire("SetParentAttachmentMaintainOffset","anim_attachment_LH")
		self.knife:Fire("SetParentAttachment","Head")
		self.knife:Spawn()
		self.knife:Activate()
		self.knife:SetSolid(SOLID_NONE)
		self.knife:AddEffects(EF_BONEMERGE)
		
		self.MeleeAttackDamage = 35
		self.MeleeAttackDamageType = DMG_SLASH
		self.AnimTbl_MeleeAttack = {"stab"}
		self.SoundTbl_MeleeAttack = {"weapons/impact - sword 4.wav","weapons/impact - sword 6.wav","weapons/impact - sword 5.wav","weapons/impact - sword 8.wav"}
	end
	if melee == 2 then
		self.melee = 2
		self.hammer = ents.Create("prop_physics")
		self.hammer:SetModel("models/madness/weapons/w_Hammer.mdl")
		self.hammer:SetLocalPos(self:GetPos())
		self.hammer:SetOwner(self)
		self.hammer:SetParent(self)
		//self.hammer:SetLocalAngles(Angle(-120,0,90))
		//self.hammer:Fire("SetParentAttachmentMaintainOffset","anim_attachment_LH")
		self.hammer:Fire("SetParentAttachment","Head")
		self.hammer:Spawn()
		self.hammer:Activate()
		self.hammer:SetSolid(SOLID_NONE)
		self.hammer:AddEffects(EF_BONEMERGE)
		self.MeleeAttackDamageType = DMG_CLUB
		self.AnimTbl_MeleeAttack = {"attack"}
		self.SoundTbl_MeleeAttack = {"grunt/punch/impact - punch04.wav","grunt/punch/impact - punch03.wav","grunt/punch/impact - punch02.wav"}
		self.MeleeAttackDamage = 30
	end
	if melee == 3 then
		self.melee = 3
		self.pipe = ents.Create("prop_physics")
		self.pipe:SetModel("models/madness/weapons/iron_pipe.mdl")
		self.pipe:SetLocalPos(self:GetPos())
		self.pipe:SetOwner(self)
		self.pipe:SetParent(self)
		//self.hammer:SetLocalAngles(Angle(-120,0,90))
		//self.hammer:Fire("SetParentAttachmentMaintainOffset","anim_attachment_LH")
		self.pipe:Fire("SetParentAttachment","Head")
		self.pipe:Spawn()
		self.pipe:Activate()
		self.pipe:SetSolid(SOLID_NONE)
		self.pipe:AddEffects(EF_BONEMERGE)
		self.MeleeAttackDamageType = DMG_CLUB
		self.AnimTbl_MeleeAttack = {"attack"}
		self.AnimTbl_IdleStand = {"ACT_IDLE_PISTOL"}
		self.SoundTbl_MeleeAttack = {"grunt/punch/impact - punch04.wav","grunt/punch/impact - punch03.wav","grunt/punch/impact - punch02.wav"}
		self.MeleeAttackDamage = 40
	end
	if melee == 4 then
		self.melee = 4
		self.pipe = ents.Create("prop_physics")
		self.pipe:SetModel("models/madness/weapons/Mallet.mdl")
		self.pipe:SetLocalPos(self:GetPos())
		self.pipe:SetOwner(self)
		self.pipe:SetParent(self)
		//self.hammer:SetLocalAngles(Angle(-120,0,90))
		//self.hammer:Fire("SetParentAttachmentMaintainOffset","anim_attachment_LH")
		self.pipe:Fire("SetParentAttachment","Head")
		self.pipe:Spawn()
		self.pipe:Activate()
		self.pipe:SetSolid(SOLID_NONE)
		self.pipe:AddEffects(EF_BONEMERGE)
		self.MeleeAttackDamageType = DMG_CLUB
		self.AnimTbl_MeleeAttack = {"attack"}
		self.AnimTbl_IdleStand = {"ACT_IDLE_PISTOL"}
		self.SoundTbl_MeleeAttack = {"grunt/punch/impact - punch04.wav","grunt/punch/impact - punch03.wav","grunt/punch/impact - punch02.wav"}
		self.MeleeAttackDamage = 40
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
if self.melee == 2 then
	self:CreateGibEntity("prop_physics","models/madness/weapons/props/hammer_prop.mdl",{Pos=self:LocalToWorld(Vector(-50,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
end
if self.melee == 1 then
	self:CreateGibEntity("prop_physics","models/madness/weapons/props/knife_prop.mdl",{Pos=self:LocalToWorld(Vector(-50,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
end
if self.melee == 3 then
	self:CreateGibEntity("prop_physics","models/madness/weapons/iron_pipe.mdl",{Pos=self:LocalToWorld(Vector(-50,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
end
if self.melee == 4 then
	self:CreateGibEntity("prop_physics","models/madness/weapons/Mallet.mdl",{Pos=self:LocalToWorld(Vector(-50,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
end
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/