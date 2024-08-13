AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/madness/npc/mag_agent_torture_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
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
--------------------------------------------------------------------------------------------------------------



ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse
	-- ====== Corpse Variables ====== --
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathCorpseEntityClass = "UseDefaultBehavior" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
ENT.DeathCorpseModel = {} -- The corpse model that it will spawn when it dies | Leave empty to use the NPC's model | Put as many models as desired, the base will pick a random one.
ENT.DeathCorpseCollisionType = COLLISION_GROUP_DEBRIS -- Collision type for the corpse | SNPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.DeathCorpseSkin = -1 -- Used to override the death skin | -1 = Use the skin that the SNPC had before it died
ENT.DeathCorpseSetBodyGroup = true -- Should it get the models bodygroups and set it to the corpse? When set to false, it uses the model's default bodygroups
ENT.DeathCorpseBodyGroup = VJ_Set(-1, -1) -- #1 = the category of the first bodygroup | #2 = the value of the second bodygroup | Set -1 for #1 to let the base decide the corpse's bodygroup
ENT.DeathCorpseSubMaterials = nil -- Apply a table of indexes that correspond to a sub material index, this will cause the base to copy the NPC's sub material to the corpse.
ENT.DeathCorpseFade = false -- Fades the ragdoll on death
ENT.DeathCorpseFadeTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = true -- If false, force will not be applied to the corpse
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed

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
ENT.MeleeAttackDamageType = DMG_BLAST
ENT.HasMeleeAttackKnockBack = true
ENT.AnimTbl_MeleeAttack = {"punch01","punch02"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 150 -- How far does the damage go?
ENT.MeleeAttackAnimationAllowOtherTasks = false 
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 69
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH} -- If it uses normal based animation, use this
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 1 -- How much time until it can flinch again?
ENT.FlinchAnimationDecreaseLengthAmount = 4 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(30, 30, 150), Vector(-25, -25, 0))
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
end
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*math.random(400, 400) + self:GetUp()*10
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce

	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 4 then
            return
        end	
	self:SetBodygroup(5, 1)
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
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/