/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "[VJ]madness combat SNPCs"
local AddonName = "[VJ]madness combat SNPCs"
local AddonType = "madness_combat_SNPCs"
local AutorunFile = "vj_madness_combat_SNPCs.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')
	local vCat = "madness combat"
--grunt
VJ.AddNPC("grunt","npc_vj_grunt",vCat)
VJ.AddNPC("grunt_melee","npc_vj_grunt_melee",vCat)
--zombie
VJ.AddNPC("zombie_grunt","npc_vj_zombie_grunt",vCat)
--agent
VJ.AddNPC("agent","npc_vj_agent",vCat)
--mag
VJ.AddNPC("mag agent torture","npc_vj_mag_agent_torture",vCat)
VJ.AddNPC("mag agent torture rebel","npc_vj_mag_agent_torture_rebel",vCat)
--spawner
VJ.AddNPC("grunt spawner","sent_vj_grunt_spawner",vCat)
-- Blood
game.AddDecal("VJ_GRUNT_BLOOD", {"decals/grunt/Blood01","decals/grunt/Blood02","decals/grunt/Blood03","decals/grunt/Blood04"})

VJ.AddConVar("grunt_corpse_gibbable", 1, {FCVAR_ARCHIVE})
--load gibs
util.PrecacheModel("madness/npc/gibs/gib01.mdl")
util.PrecacheModel("madness/npc/gibs/gib02.mdl")

	
	local defGibs_Yellow = {""}
	local defGibs_Red = {"models/madness/npc/gibs/gib02.mdl","models/madness/npc/gibs/gib01.mdl","models/madness/npc/gibs/gib02.mdl","models/madness/npc/gibs/gib01.mdl","models/madness/npc/gibs/feet.mdl","models/madness/npc/gibs/gib02.mdl"}
	
	function VJ_ApplyCorpseEffects(ent, corpse, gibTbl, extraOptions)
		extraOptions = extraOptions or {} -- CollideSound, ExpSound, Gibbable, CanBleed, ExtraGibs
		corpse.HLR_Corpse = true
		corpse.HLR_Corpse_Type = ent.BloodColor
		if ent.HasBloodParticle then corpse.HLR_Corpse_Particle = ent.CustomBlood_Particle end
		corpse.HLR_Corpse_Decal = ent.HasBloodDecal and VJ_PICK(ent.CustomBlood_Decal) or ""
		corpse.HLR_Corpse_Gibbable = extraOptions.Gibbable != false
		if !gibTbl then
			if corpse.HLR_Corpse_Type == "Yellow" then
				gibTbl = defGibs_Yellow
			elseif corpse.HLR_Corpse_Type == "Red" then
				gibTbl = defGibs_Red
			end
		end
		if extraOptions.ExtraGibs then
			gibTbl = table.Copy(gibTbl) -- So Lua doesn't override the localized tables above
			gibTbl = table.Add(gibTbl, extraOptions.ExtraGibs)
		end
		corpse.HLR_Corpse_Gibs = gibTbl
		corpse.HLR_Corpse_CollideSound = extraOptions.CollideSound or "Default"
		corpse.Corpse_gibSound = extraOptions.ExpSound or {"vj_gib/gibbing1.wav","vj_gib/gibbing2.wav","vj_gib/gibbing3.wav"}
		corpse.HLR_Corpse_StartT = CurTime() + 1
	end
	
	local defPos = Vector(0, 0, 0)
	local colorYellow = VJ_Color2Byte(Color(255, 221, 35))
	local colorRed = VJ_Color2Byte(Color(130, 19, 10))
	hook.Add("EntityTakeDamage", "VJ_grunt_EntityTakeDamage", function(target, dmginfo)
		if target.HLR_Corpse && !target.Dead && CurTime() > target.HLR_Corpse_StartT && target:GetColor().a > 50 then
			local dmgForce = dmginfo:GetDamageForce()
			-- Damage & Gibs
			if GetConVar("grunt_corpse_gibbable"):GetInt() == 1 && !dmginfo:IsBulletDamage() && target.HLR_Corpse_Gibbable then
				local noDamage = false
				local dmgType = dmginfo:GetDamageType()
				
				-- DMG_CRUSH is usually when the ragdoll is slammed to a wall, we want it to only gib if it's hit hard enough!
				if dmgType == DMG_CRUSH && dmginfo:GetDamage() < 500 then
					noDamage = true
				end
				-- If DMG_BLAST, then increase the damage to make it easier to gib
				if bit.band(dmgType, DMG_BLAST) != 0 then
					dmginfo:ScaleDamage(2)
				end
				if !noDamage then target:SetHealth(target:Health() - dmginfo:GetDamage()) end
				if target:Health() <= 0 then
					local centerPos = target:GetPos() + target:OBBCenter()
					target.Dead = true
					VJ_EmitSound(target, VJ_PICK(target.Corpse_gibSound), 90, 100)
					
					-- Spawn gibs
					local gibMaxs = target:OBBMaxs()
					local gibMins = target:OBBMins()
					for _, v in ipairs(target.HLR_Corpse_Gibs) do
						local gib = ents.Create("obj_vj_gib")
						gib:SetModel(v)
						gib:SetPos(centerPos + Vector(math.random(gibMins.x, gibMaxs.x), math.random(gibMins.y, gibMaxs.y), 10))
						gib:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
						gib.BloodType = target.HLR_Corpse_Type
						gib.Collide_Decal = target.HLR_Corpse_Decal
						gib.CollideSound = target.HLR_Corpse_CollideSound or "Default"
						gib:Spawn()
						gib:Activate()
						local phys = gib:GetPhysicsObject()
						if IsValid(phys) then
							phys:AddVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250)) + (dmgForce / 70))
							phys:AddAngleVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
						end
						if GetConVar("vj_npc_fadegibs"):GetInt() == 1 then
							timer.Simple(GetConVar("vj_npc_fadegibstime"):GetInt(), function()
								SafeRemoveEntity(gib)
							end)
						end
					end
					
					local bloodIsYellow = target.HLR_Corpse_Type == "Yellow"
					local bloodIsRed = target.HLR_Corpse_Type == "Red"
					
					-- Death effects & decals
					if bloodIsYellow or bloodIsRed then
						local maxDist = gibMaxs:Length()
						local splatDecal = bloodIsYellow and "VJ_HLR_Blood_Yellow_Large" or "VJ_GRUNT_BLOOD"
						local tr = util.TraceLine({start = centerPos, endpos = centerPos - Vector(0, 0, maxDist), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos + Vector(0, 0, maxDist), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos - Vector(maxDist, 0, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos + Vector(maxDist, 0, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos - Vector(0, maxDist, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						tr = util.TraceLine({start = centerPos, endpos = centerPos + Vector(0, maxDist, 0), filter = target})
						util.Decal(splatDecal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)
						/*local dmgPos = dmginfo:GetDamagePosition()
						if pos == defPos then pos = target:GetPos() + target:OBBCenter() end
						VJ_CreateTestObject(dmgPos, Angle(0, 0, 0), Color(0, 225, 255))
						VJ_CreateTestObject(dmgPos + dmgPos:GetNormal() * 10)
						local tr = util.TraceLine({start = dmgPos, endpos = dmgPos + dmgPos:GetNormal() * 10, filter = target})
						VJ_CreateTestObject(tr.HitPos, Angle(0, 0, 0), Color(94, 255, 0))
						util.Decal("VJ_GRUNT_BLOOD", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, target)*/
						
						local effectBlood = EffectData()
						effectBlood:SetOrigin(centerPos)
						effectBlood:SetColor(bloodIsYellow and colorYellow or colorRed)
						effectBlood:SetScale(120)
						util.Effect("VJ_Blood1", effectBlood)
						
						local VJ_Blood1 = EffectData()
						VJ_Blood1:SetOrigin(centerPos)
						VJ_Blood1:SetScale(8)
						VJ_Blood1:SetFlags(3)
						VJ_Blood1:SetColor(bloodIsYellow and 1 or 0)
						util.Effect("VJ_Blood1", VJ_Blood1)
						util.Effect("VJ_Blood1", VJ_Blood1)
						
						if bloodIsYellow then
							local effectdata = EffectData()
							effectdata:SetOrigin(centerPos)
							effectdata:SetScale(1)
							util.Effect("StriderBlood", effectdata)
							util.Effect("StriderBlood", effectdata)
						end
					end
					target:Remove()
				end
			end
		end
	end)

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end