ENT.Base 			= "npc_vj_mag_agent_torture" -- List of all base types: https://github.com/DrVrej/VJ-Base/wiki/Base-Types
ENT.Type 			= "ai"
ENT.PrintName 		= "mag agent torture rebel"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "madness combat"

if (CLIENT) then
	local Name = "mag agent torture rebel"
	local LangName = "npc_vj_mag_agent_torture_rebel"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end