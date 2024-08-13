AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE

function ENT:CustomOnInitialize()
	self.totalDamage = {} --need to gib work
	self.GetDamageType = {} --need to gib work
	self:SetColor(Color(0,255,0,255))
end