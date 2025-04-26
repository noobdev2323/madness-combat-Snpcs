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
ENT.BloodColor = "Green" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = false -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.BloodPoolSize = "Tiny" -- What's the size of the blood pool?
ENT.CustomBlood_Decal = {} -- Decals to spawn when it's damaged
ENT.CanOpenDoors = true -- Can it open doors?
ENT.VJ_NPC_Class = {"CLASS_VR"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE
--------------------------------------------------------------------------------------------------------------



ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.DeathAnimationChance = 1 -- Put 1 if you want it to play the animation all the time
ENT.DeathAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it turns into a corpse

ENT.SoundTbl_MeleeAttack = {"grunt/punch/impact - punch01.wav","grunt/punch/impact - punch03.wav","grunt/punch/impact - punch05.wav","grunt/punch/impact - punch07.wav","grunt/punch/impact - punch11.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"grunt/punch/swoosh1.wav","grunt/punch/swoosh2.wav","grunt/punch/swoosh3.wav","grunt/punch/swoosh4.wav"}

	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
ENT.AllowIgnition = false -- Can this SNPC be set on fire?

ENT.RunAwayOnUnknownDamage = false -- Should run away on damage
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
	self:SetMaterial("models/grunt/debugwireframe") -- set material
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce

	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 4 then
            return
        end	
	self:SetBodygroup(0, 5)
	self:SetBodygroup(1, 1)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(5,238,5)))
		bloodeffect:SetScale(50)
		util.Effect("VJ_Blood1",bloodeffect)
	end
	self:TakeDamage(self:Health(), attacker, attacker)
    end

	if dmgType == DMG_SLASH && dmginfo:IsDamageType(DMG_SLASH) and self:Health() < (self:GetMaxHealth() * 0.7) then 
		if self:GetBodygroup(0) == 1 then
            return
        end	
		if self:GetBodygroup(0) == 4 then
            return
        end	
		self:SetBodygroup(0, 1)
		self:TakeDamage(self:Health())
		VJ_EmitSound(self, "weapons/impact - sword 7.wav")
	end	
	
	if hitgroup == HITGROUP_LEFTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(3) == 1 then
            return
        end	
	self:SetBodygroup(3, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_DIE"}
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if hitgroup == HITGROUP_RIGHTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(4) == 1 then
            return
        end	
		
	self:SetBodygroup(4, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_DIE"}
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	end
end
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt:Fire("FadeAndRemove","",0.1)
	for i = 0, corpseEnt:GetPhysicsObjectCount() - 1 do
		local colide = corpseEnt:GetPhysicsObjectNum( i )
		colide:EnableGravity(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(0,255,42)))
			bloodeffect:SetScale(100)
			util.Effect("VJ_Blood1",bloodeffect)
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