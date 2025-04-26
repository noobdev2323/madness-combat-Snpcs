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
ENT.CombatFaceEnemy = false -- If enemy exists and is visible
ENT.ConstantlyFaceEnemy = false -- Should it face the enemy constantly?
ENT.NextProcessTime = 2

local weps = {
	"weapon_vj_madness_glock_20",
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
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/