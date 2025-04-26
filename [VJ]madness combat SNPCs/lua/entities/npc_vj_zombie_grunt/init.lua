AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/madness/npc/zeds_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
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
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE
ENT.agent = 0
--------------------------------------------------------------------------------------------------------------



ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {} -- Death Animations
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
ENT.SoundTbl_MeleeAttack = {"vj_gib/gibbing2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"grunt/punch/swoosh1.wav"}

	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 1 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?

ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttackTime = 0.5 -- How much time until player's Speed resets
ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"ACT_BITE"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 60 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.MeleeAttackAnimationAllowOtherTasks = false 
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.1	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 10
ENT.MeleeAttackDamageType = DMG_GENERIC
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH} -- If it uses normal based animation, use this
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 1 -- How much time until it can flinch again?
ENT.FlinchAnimationDecreaseLengthAmount = 4 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce

	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 12000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 5 then
            return
        end	
	self:SetBodygroup(0, 5)
	self:SetBodygroup(1, 1)
	self:SetBodygroup(6,0)
	VJ_EmitSound(self, "grunt/die.wav")
	self.head_gib = true
	if self.HasGibOnDeathEffects == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(30)
		util.Effect("VJ_GRUNT_BLOOD",bloodeffect)
	end

	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib01.mdl",{Pos=self:LocalToWorld(Vector(30,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib05.mdl",{Pos=self:LocalToWorld(Vector(0,0,59)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib05.mdl",{Pos=self:LocalToWorld(Vector(0,-10,69)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,400)+self:GetForward()*math.Rand(100,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
	self:RemoveAllDecals()
    end
	if dmgType == DMG_SLASH && dmginfo:IsDamageType(DMG_SLASH) and self:Health() < (self:GetMaxHealth() * 0.3) then 
			VJ_EmitSound(self, "vj_gib/gibbing1.wav")
			self:SetBodygroup(0, 4)
			self:SetBodygroup(6,0)
			self.HasDeathRagdoll = false
			if self:GetBodygroup(6) == 1 then
				self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
				self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_zeds_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
			end
			if self:GetBodygroup(6) == 0 then
				self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/grunt_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
				self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/zeds_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
			end
			self:TakeDamage(self:Health())
	end	
	if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 5 then
            return
        end	
		if self:GetBodygroup(0) == 2 then
			if self.HasGibDeathParticles == true then
				local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
				bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
				bloodeffect:SetScale(30)
				util.Effect("VJ_Blood1",bloodeffect)
			end
			self:SetBodygroup(0, 4)
			self:SetBodygroup(6,0)
			self:TakeDamage(self:Health())
		end	
		if self:GetBodygroup(0) == 3 then
			if self.HasGibDeathParticles == true then
				local bloodeffect = EffectData()
				bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
				bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
				bloodeffect:SetScale(30)
				util.Effect("VJ_Blood1",bloodeffect)
			end
			self:SetBodygroup(0, 4)
			self:SetBodygroup(6,0)
			self:TakeDamage(self:Health())
		end	
		if self:GetBodygroup(0) == 4 then
            return
        end	

	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(30)
		util.Effect("VJ_Blood1",bloodeffect)
	end
	local head_gore = math.random(1,2)


	if head_gore == 1 then
		VJ_EmitSound(self, "vj_gib/gibbing1.wav")
		self:SetBodygroup(1, 1)
	end
	if head_gore == 2 then
		VJ_EmitSound(self, "vj_gib/gibbing1.wav")	
		self:SetBodygroup(0,math.random(2,3))
	end
    end
		
	if dmgType == DMG_SLASH && dmginfo:IsDamageType(DMG_SLASH) and self:Health() < (self:GetMaxHealth() * 0.7) then 
		if self:GetBodygroup(0) == 1 then
            return
        end	
		if self:GetBodygroup(0) == 4 then
            return
        end	
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,27)) +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(30)
			util.Effect("VJ_Blood1",bloodeffect)
		end
		self:SetBodygroup(0, 1)
		self:TakeDamage(self:Health())
		self:CreateGibEntity("obj_vj_gib","models/madness/npc/gibs/gib02.mdl",{BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD",Pos=self:LocalToWorld(Vector(0,0,57)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
		self:CreateGibEntity("obj_vj_gib","models/madness/npc/gibs/gib02.mdl",{BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD",Pos=self:LocalToWorld(Vector(0,0,56)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,300)})
	end	
	
	if hitgroup == HITGROUP_LEFTLEG and self.totalDamage[hitgroup] > 4000	 then    -- Dismember heads code
		if self:GetBodygroup(4) == 1 then
            return
        end	
	self:SetBodygroup(4, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_DIE"}
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	
	if hitgroup == HITGROUP_RIGHTLEG and self.totalDamage[hitgroup] > 4000	 then   
		if self:GetBodygroup(5) == 1 then
            return
        end	
		
	self:SetBodygroup(5, 1)
	VJ_EmitSound(self, "grunt/die.wav")
	self.AnimTbl_Death = {"ACT_DIE"}
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/feet.mdl",{Pos=self:LocalToWorld(Vector(0,-20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:TakeDamage(self:Health(), attacker, attacker)
    end
	if hitgroup == HITGROUP_STOMACH and self.totalDamage[hitgroup] > 12000	 then    
		if self:GetBodygroup(0) == 4 then
            return
        end	
		VJ_EmitSound(self, "vj_gib/gibbing1.wav")
		self:SetBodygroup(0, 4)
		self.HasDeathRagdoll = false

		if self:GetBodygroup(6) == 1 then
			self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
			self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/agent_zeds_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
		end
		if self:GetBodygroup(6) == 0 then
			self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/grunt_half.mdl",{Pos=self:LocalToWorld(Vector(0,0,0)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,100)+self:GetForward()*math.Rand(-50,50)})
			self:CreateGibEntity("prop_ragdoll","models/madness/npc/gibs/zeds_half2.mdl",{Pos=self:LocalToWorld(Vector(0,0,25)),Ang=self:GetAngles(),Vel=self:GetRight()*math.Rand(-100,1000)+self:GetForward()*math.Rand(-1000,0600)})
		end
		self:TakeDamage(self:Health())
    end
	if hitgroup == HITGROUP_STOMACH and self.totalDamage[hitgroup] > 1000	 then    
	self:SetBodygroup(2, 1)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(10,-10,0)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(10)
		util.Effect("VJ_Blood1",bloodeffect)
	end
    end
	if hitgroup == HITGROUP_CHEST and self.totalDamage[hitgroup] > 1000	 then   
		self:SetBodygroup(7, 1)
		
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(10,10,10)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(10)
		util.Effect("VJ_Blood1",bloodeffect)
	end
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
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib02.mdl",{Pos=self:LocalToWorld(Vector(0,-20,0)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib02.mdl",{Pos=self:LocalToWorld(Vector(0,-20,40)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_GRUNT_BLOOD"})
	local head_gib = math.random(1,2)
	if head_gib == 1 then
		self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib02.mdl",{Pos=self:LocalToWorld(Vector(0,0,54)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
	end
	return true
end
----------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	if hitgroup == HITGROUP_HEAD and self.HasGibDeathParticles == true and IsValid( corpseEnt ) and self.head_gib == true then
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
	if self:GetBodygroup(5) == 1 then
		madness_colidebone(corpseEnt,"ValveBiped.Bip01_R_Foot")
	end	
	if self:GetBodygroup(4) == 1 then
		madness_colidebone(corpseEnt,"ValveBiped.Bip01_L_Foot")
	end	
	if self:GetBodygroup(0) == 5 then
		madness_colidebone(corpseEnt,"ValveBiped.Bip01_Head1")
	end	
	VJ_ApplyCorpseEffects(self, corpseEnt, gibs)
end

ENT.InfectionClasses = {
	npc_vj_grunt = true,
	npc_vj_armed_grunt = true,
	npc_vj_agent = true,
}

function ENT:CustomOnMeleeAttack_AfterChecks(TheHitEntity) 
	local victim = TheHitEntity
	local playercontroller = self.VJ_TheControllerEntity
	local cameramode = self.VJ_TheControllerEntity.VJC_Camera_Mode
	if victim.infected then return end
	if victim:IsNPC() && self.InfectionClasses[victim:GetClass()] && victim:Health() > 0 then -- make sure our victim is a valid infection target
		victim.infected = true 
		victim:VJ_ACT_PLAYACTIVITY("ACT_INFECTED",true,false,false)
		victim.TurningSpeed = 0
		VJ_EmitSound(victim,"grunt/punch/impact - punch09 - splat.wav")
		victim.HasDeathRagdoll = false
		local zClass = "npc_vj_zombie_grunt" --Fallback class for the zombie NPC we will spawn
		local zOffset = 50
		local zAnimT = 0.5 --Duration of the "I got crabbed!" animation
		local zPos = victim:GetPos()
		victim.VJ_NPC_Class = {"CLASS_ZOMBIE"} --Stop NPCs from attacking victim
		victim.BringFriendsOnDeath = false
		if victim:GetClass() == "npc_vj_grunt" or  victim:GetClass() == "npc_vj_armed_grunt" then
			victim:SetBodygroup(0,2)
			zClass = "npc_vj_zombie_grunt"
		elseif victim:GetClass() == "npc_vj_agent" then
			victim:SetBodygroup(0,2)
			zClass = "npc_vj_zombie_agent"
	end
		timer.Simple(zAnimT,function() -- Overridden to 30 seconds because Barney's infection animation loops instead of lasting a long time.
			if IsValid(victim) then
			
				local zombie = ents.Create(zClass)
				zombie:SetPos(zPos)
				zombie:SetAngles(victim:GetAngles())
				zombie:SetColor(victim:GetColor())
				zombie:SetMaterial(victim:GetMaterial())
				zombie:Spawn()
				zombie:AddEffects(32) -- hide zombie
				if IsValid(victim) then
					undo.ReplaceEntity(victim,zombie)
				end
				timer.Simple(0.2,function() --The zombie actually spawns in early and is hidden, this is to move the getup animation in place before showing the zombie model
					if IsValid(zombie) then
						SafeRemoveEntity(victim)
						zombie:SetPos(zPos)
						
						zombie:RemoveEffects(32)
						if zombie.HasGibDeathParticles == true then
							local bloodeffect = EffectData()
							bloodeffect:SetOrigin(zombie:GetPos() +zombie:OBBCenter())
							bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
							bloodeffect:SetScale(50)
							util.Effect("VJ_Blood1",bloodeffect)
						end
					end
				end)
			end
		end)
	end
end -- return true to disable the attack and move onto the next entity!
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/