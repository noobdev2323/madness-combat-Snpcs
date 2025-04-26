AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
ENT.Base 			= "obj_vj_spawner_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "agent Spawner"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "VJ Base Spawners"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/madness/npc/gibs/gib02.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=0},Entities = {"npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent"}},
	{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=50,vUp=0},Entities = {"npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent"}},
	{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=50,vUp=0},Entities = {"npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent"}},
	{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-50,vUp=0},Entities = {"npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent"}},
	{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-50,vUp=0},Entities = {"npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent","npc_vj_agent"}},
}