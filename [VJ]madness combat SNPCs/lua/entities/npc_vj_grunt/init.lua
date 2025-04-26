AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.BloodPoolSize = "Tiny" -- What's the size of the blood pool?
ENT.CustomBlood_Decal = {"VJ_GRUNT_BLOOD"} -- Decals to spawn when it's damaged
ENT.CanOpenDoors = true -- Can it open doors?
ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using poseparameters?

--------------------------------------------------------------------------------------------------------------


ENT.SoundTbl_MeleeAttack = {"grunt/punch/impact - punch01.wav","grunt/punch/impact - punch03.wav","grunt/punch/impact - punch05.wav","grunt/punch/impact - punch07.wav","grunt/punch/impact - punch11.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"grunt/punch/swoosh1.wav","grunt/punch/swoosh2.wav","grunt/punch/swoosh3.wav","grunt/punch/swoosh4.wav"}
ENT.SoundTbl_Pain = {"grunt/punch/impact - punch03.wav","grunt/punch/impact - punch04.wav"}



	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu

ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"punch01","punch02"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 90 -- How far does the damage go?
ENT.MeleeAttackAnimationAllowOtherTasks = false 
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH} -- If it uses normal based animation, use this
ENT.FlinchDamageTypes = {DMG_CLUB} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 1 -- How much time until it can flinch again?
ENT.FlinchAnimationDecreaseLengthAmount = 4 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.CallForHelp = false 
ENT.HasDeathAnimation = true  -- Should it play death animations?

---------------------------------------------------------------------------------------------------------------------------------------------
--custom
ENT.madness_head_gib = false
ENT.infected = false
function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
end
function madness_colidebone(ragdoll,bone_name)
	local colide = ragdoll:GetPhysicsObjectNum(ragdoll:TranslateBoneToPhysBone( ragdoll:LookupBone(bone_name) ) ) --get bone id
	colide:EnableCollisions(false)
	colide:SetMass(0.01)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
	if not self:IsValid() then
		return 
	end
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce

	if dmginfo:IsDamageType(DMG_BUCKSHOT) and hitgroup == HITGROUP_HEAD or hitgroup == 9 and damageForce > 9000 then 
		if GetConVar("vj_madness_DMG_BUCKSHOT_alwaysgib"):GetInt() == 1 then
		gib_my_head(self)
		end
	end	
	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		gib_my_head(self)
    end
	if hitgroup == 9 and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		gib_my_head(self)
    end
	
	if self:IsOnFire() and GetConVar("vj_madness_die_instantly_in_fire"):GetInt() == 1 then
		if self:Alive() then
		self.AnimTbl_Death = {"ACT_BURNING","ACT_INFECTED","ACT_FLINCH"}
		VJ_EmitSound(self, "grunt/die.wav")
		self:TakeDamage(self:Health(), attacker, attacker)
	end
    end
	if hitgroup == 8 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self.madness_head_gib == true then
            return
        end	
	self:SetBodygroup(0, 4)
	self:RemoveAllDecals()
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	if dmgType == DMG_SLASH && dmginfo:IsDamageType(DMG_SLASH) and self:Health() < (self:GetMaxHealth() * 0.2) then 
	if self.madness_head_gib == true then return end
		local slice = math.random(1,2)
		if slice == 1 then
			VJ_EmitSound(self, "vj_gib/gibbing1.wav")
			self.madness_head_gib = true
			self.HasDeathRagdoll = false
			self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/grunt_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
			self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/grunt_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
			self:TakeDamage(self:Health())
		else
			VJ_EmitSound(self, "vj_gib/gibbing1.wav")
			self:SetBodygroup(0, 5)
			self:SetBodygroup(1, 1)
				self.madness_head_gib = true
			self:CreateGibEntity("prop_physics","models/madness/npc/gibs/Head.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})		
			self:TakeDamage(self:Health())
		end
	end	
		
	if dmginfo:IsDamageType(DMG_SLASH) and self:Health() < (self:GetMaxHealth() * 0.7) then 
		if self.madness_head_gib == true then return end
		self.head_gib = true
		self:SetBodygroup(0, 1)
		self:TakeDamage(self:Health())
		VJ_EmitSound(self, "weapons/impact - sword 7.wav")
		self:CreateGibEntity("obj_vj_gib","models/madness/npc/gibs/head_chunk6.mdl",{BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD",Pos=self:LocalToWorld(Vector(0,0,57)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-350,350)})
	end	

	
    if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
	if self.madness_head_gib == true then return end
	self.madness_head_gib = true
	self:SetBodygroup(0, 3)
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if hitgroup == 9 and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self.madness_head_gib == true then
            return
        end	
	self.madness_head_gib = true
	self:SetBodygroup(0, 2)
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk.mdl",{Pos=self:LocalToWorld(Vector(30,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if hitgroup == HITGROUP_CHEST and self.totalDamage[hitgroup] > 3000	 then  
	if self:GetBodygroup(0) == 5 then
        return
    end
		self:RemoveAllDecals()
		VJ_EmitSound(self, "vj_gib/bones_snapping2.wav")
		self.madness_head_DESTROID = true
		self:SetBodygroup(0, 5)
		self:SetBodygroup(5, 1)
		self:SetBodygroup(1, 1)
		self:TakeDamage(self:Health(), attacker, attacker)
		self:CreateGibEntity("prop_physics","models/madness/npc/gibs/Head.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})		
	end	
	
	if hitgroup == HITGROUP_RIGHTARM and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code

	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_PAIN"}
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	if hitgroup == HITGROUP_LEFTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(3) == 1 then
            return
        end	

	VJ_EmitSound(self, "grunt/die.wav")
	self.gib_my_L_leg = true
	self:SetBodygroup(3, 1)
	self.AnimTbl_Death = {"ACT_DIE"}
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if hitgroup == HITGROUP_RIGHTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(4) == 1 then
            return
        end	

	VJ_EmitSound(self, "grunt/die.wav")
	self.gib_my_madness_R_leg = true
	self:SetBodygroup(4, 1)
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
	if self:GetClass() == "npc_vj_agent" then
		self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
		self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
	else
		self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/grunt_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
		self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/grunt_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
	end	
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = VJ_Color2Byte(Color(255, 0, 0))
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(50)
			util.Effect("VJ_Blood1",bloodeffect)
		
			local bloodspray = EffectData()
			bloodspray:SetOrigin(self:GetPos())
			bloodspray:SetScale(8)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("bloodspray",bloodspray)
			util.Effect("bloodspray",bloodspray)
		end
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,-20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib02.mdl",{Pos=self:LocalToWorld(Vector(0,-20,40)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	local head_gib = math.random(1,2)
	if head_gib == 1 then
		self:CreateGibEntity("prop_physics","models/madness/npc/gibs/Head.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	end
	return true
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	if self.HasGibDeathParticles == true and self.madness_head_DESTROID == true and IsValid( corpseEnt ) then
		local bloodeffect = ents.Create("info_particle_system")
		bloodeffect:SetKeyValue("effect_name","blood_advisor_puncture_withdraw")
		bloodeffect:SetPos(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head")).Pos)
		bloodeffect:SetAngles(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head")).Ang)
		bloodeffect:SetParent(corpseEnt)
		bloodeffect:Fire("SetParentAttachment","head")
		bloodeffect:Spawn()
		bloodeffect:Activate()
		bloodeffect:Fire("Start","",0)
		bloodeffect:Fire("Kill","",3.5)
	end
	if self.madness_head_DESTROID == true then
		madness_colidebone(corpseEnt,"ValveBiped.Bip01_Head1")
	end
	if self.gib_my_madness_R_leg == true then
		madness_colidebone(corpseEnt,"ValveBiped.Bip01_R_Foot")
	end
	if self.gib_my_L_leg == true then
		madness_colidebone(corpseEnt,"ValveBiped.Bip01_L_Foot")
	end
	VJ_ApplyCorpseEffects(self, corpseEnt, gibs)
end
function gib_my_head(self)
	if self.madness_head_gib == true then return end
	self.madness_head_gib = true
	self.madness_head_DESTROID = true
	self:SetBodygroup(0, 5)
	self:SetBodygroup(1, 1)
	self:SetBodygroup(5, 1)
	self:RemoveAllDecals()
	VJ_EmitSound(self, "grunt/die.wav")
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(30)
		util.Effect("VJ_Blood1",bloodeffect)
	end
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk.mdl",{Pos=self:LocalToWorld(Vector(30,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk2.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk3.mdl",{Pos=self:LocalToWorld(Vector(0,0,59)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk4.mdl",{Pos=self:LocalToWorld(Vector(0,0,60)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/head_chunk5.mdl",{Pos=self:LocalToWorld(Vector(0,-10,69)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,400)+self:GetForward()*math.Rand(100,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
end

---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/