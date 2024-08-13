AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/madness/npc/agent_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.melee = 0

function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
	local melee = math.random(1,2)
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
end
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce
		if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 4 then
            return
        end	
	self:SetBodygroup(5, 1)
	self:SetBodygroup(0, 4)
	self:SetBodygroup(1, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk.mdl",{Pos=self:LocalToWorld(Vector(30,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk2.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk3.mdl",{Pos=self:LocalToWorld(Vector(0,0,59)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk4.mdl",{Pos=self:LocalToWorld(Vector(0,0,60)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk5.mdl",{Pos=self:LocalToWorld(Vector(0,-10,69)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,400)+self:GetForward()*math.Rand(100,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if self:IsOnFire() then
	if self.Dead == false then
	self.AnimTbl_Death = {"ACT_BURNING"}
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
	end
    end
	
    if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 2 then
            return
        end	
		if self:GetBodygroup(0) == 4 then
            return
        end	
	
		local head_damege_test = math.random(1,2)
		if head_damege_test == 1 then
			self:SetBodygroup(0, 2)
			self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk.mdl",{Pos=self:LocalToWorld(Vector(30,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
		end
		if head_damege_test == 2 then
			self:SetBodygroup(0, 3)
		end
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	if hitgroup == HITGROUP_CHEST and self.totalDamage[hitgroup] > 3000	 then  
	if self:GetBodygroup(0) == 4 then
        return
    end
		self:RemoveAllDecals()
		VJ_EmitSound(self, "vj_gib/bones_snapping2.wav")
		self:SetBodygroup(0, 4)
		self:SetBodygroup(5, 1)
		self:SetBodygroup(1, 1)
		self:TakeDamage(self:Health(), attacker, attacker)
		self:CreateGibEntity("prop_physics","models/madness/npc/gibs/Head.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})		
	end	
	
	if hitgroup == HITGROUP_LEFTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(3) == 1 then
            return
        end	
	self:SetBodygroup(3, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_DIE"}
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if hitgroup == HITGROUP_RIGHTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(4) == 1 then
            return
        end	
		
	self:SetBodygroup(4, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_DIE"}
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,-20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	if hitgroup == HITGROUP_STOMACH and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		if self:GetBodygroup(1) == 2 then
            return
        end	
	self:SetBodygroup(1, 2)
	VJ_EmitSound(self, "grunt/die.wav")
	self.HasDeathRagdoll = false
	self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
	self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
if self.melee == 2 then
	self:CreateGibEntity("prop_physics","models/madness/weapons/props/hammer_prop.mdl",{Pos=self:LocalToWorld(Vector(0,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
end
if self.melee == 1 then
	self:CreateGibEntity("prop_physics","models/madness/weapons/props/knife_prop.mdl",{Pos=self:LocalToWorld(Vector(0,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
end
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/