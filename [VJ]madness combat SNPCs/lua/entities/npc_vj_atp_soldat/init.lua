AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/madness/npc/atp_soldat_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.melee = 0
ENT.CombatFaceEnemy = false -- If enemy exists and is visible
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.NextProcessTime = 2
ENT.CustomBlood_Decal = {"VJ_GRUNT_YELLOW_BLOOD"} -- Decals to spawn when it's damaged
ENT.BloodColor = "Yellow" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 14 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {"item_healthvial"} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
ENT.MeleeAttackAnimationFaceEnemy = false -- Should it face the enemy while playing the melee attack animation?
local weps = {
	"weapon_vj_madness_mp5",
}

function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work

	local gmodweaponoverride = GetConVar("gmod_npcweapon"):GetString()
	
	if gmodweaponoverride == "" then --Checks if the weapon has a manual override, if not then select our own random weapon
		self:Give(VJ_PICK(weps))
		elseif gmodweaponoverride == "none" then --Do nothing because we are being given nothing lol
		else self:Give(gmodweaponoverride) --Give manually overridden weapon
	end
end

function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 then
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce
		
	if dmgType == DMG_SLASH && dmginfo:IsDamageType(DMG_SLASH) and self:Health() < (self:GetMaxHealth() * 0.7) then 
		if self:GetBodygroup(0) == 1 then
            return
        end	
		if self:GetBodygroup(0) == 4 then
            return
        end	
		self:SetBodygroup(0, 1)
		self:TakeDamage(self:Health())
		self:CreateGibEntity("obj_vj_gib","models/madness/npc/gibs/head_chunk7.mdl",{BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD",Pos=self:LocalToWorld(Vector(0,0,57)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(350,350)+self:GetForward()*math.Rand(-200,300)})
	end	


	if self:IsOnFire() then
	if self.Dead == false then
	self.AnimTbl_Death = {"ACT_BURNING","ACT_INFECTED","ACT_FLINCH"}
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
	end
    end
	if hitgroup == HITGROUP_GEAR and self.totalDamage[hitgroup] > 2000	 then    -- Dismember heads code
	self:SetBodygroup(5, 1)
	end
    if hitgroup == HITGROUP_HEAD and self.totalDamage[hitgroup] > 15000	 then    -- Dismember heads code
		if self:GetBodygroup(0) == 2 then
            return
        end	
		if self:GetBodygroup(0) == 4 then
            return
        end	
	
		local head_damege_test = math.random(1,2)
		if head_damege_test == 1 then
			self:SetBodygroup(0, 2)
		end
		if head_damege_test == 2 then
			self:SetBodygroup(0, 3)
		end
	VJ_EmitSound(self, "grunt/die.wav")
	self:TakeDamage(self:Health(), attacker, attacker)
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
	end
end
local colorRed = VJ_Color2Byte(Color(255,217,0))
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(255,217,0)))
		bloodeffect:SetScale(100)
		util.Effect("VJ_Blood1",bloodeffect)
	end
self:CreateGibEntity("prop_physics","models/madness/npc/gibs/gib04.mdl",{Pos=self:LocalToWorld(Vector(0,-20,40)),Ang=self:GetAngles()+Angle(0,0,0),Vel=self:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib03.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib03.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib04.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib03.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib04.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib03.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
self:CreateGibEntity("obj_vj_gib", "models/madness/npc/gibs/gib04.mdl", {BloodType="Yellow", BloodDecal="VJ_GRUNT_YELLOW_BLOOD"})
return true
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