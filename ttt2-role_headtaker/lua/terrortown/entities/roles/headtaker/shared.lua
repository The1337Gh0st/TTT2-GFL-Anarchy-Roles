if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_head.vmt")
end

roles.InitCustomTeam(ROLE.name, {
	icon = "vgui/ttt/dynamic/roles/icon_head",
	color = Color(255, 110, 5, 255)
})

function ROLE:PreInitialize()
	self.color = Color(255, 110, 5, 255)

	self.abbr = "head"
	self.score.surviveBonusMultiplier = 0
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -10
	self.score.bodyFoundMuliplier = 0
--	self.isOmniscientRole = true

	self.fallbackTable = {}



	self.defaultTeam = TEAM_HEADTAKER

	self.conVarData = {
		pct = 0.14,
		maximum = 1,
		minPlayers = 7,
		togglable = true,
		random = 50
	}
end

function ROLE:Initialize()
	if SERVER and JESTER then
		-- add a easy role filtering to receive all jesters
		-- but just do it, when the role was created, then update it with recommended function
		-- theoretically this function is not necessary to call, but maybe there are some modifications
		-- of other addons. So it's better to use this function
		-- because it calls hooks and is doing some networking
		self.networkRoles = {JESTER}
	end
end

if SERVER then

	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
	
	SetGlobalInt("HeadtakerWalk",ply:GetWalkSpeed())
SetGlobalInt("HeadtakerRun",ply:GetRunSpeed())

	local speedscale = GetConVar("ttt2_headtaker_movement_scale"):GetFloat()


ply:GiveEquipmentWeapon("weapon_ttt_headtaker")

		ply:GiveArmor(GetConVar("ttt2_headtaker_armor_value"):GetInt())	
		ply:SetHealth(GetConVar("ttt2_headtaker_health"):GetInt())
    ply:SetMaxHealth(GetConVar("ttt2_headtaker_health"):GetInt())
	ply:GiveEquipmentItem("item_ttt_radar")
	ply:GiveEquipmentItem("item_ttt_climb")
	
	ply:SetWalkSpeed(ply:GetWalkSpeed()*speedscale)
		ply:SetRunSpeed(ply:GetRunSpeed()*speedscale)

	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)

ply:StripWeapon("weapon_ttt_headtaker")

		ply:RemoveArmor(GetConVar("ttt2_headtaker_armor_value"):GetInt())
		ply:SetHealth(100)
    ply:SetMaxHealth(100)
ply:RemoveEquipmentItem("item_ttt_radar")
ply:RemoveEquipmentItem("item_ttt_climb")

ply:SetWalkSpeed(GetGlobalInt("HeadtakerWalk"))
  	ply:SetRunSpeed(GetGlobalInt("HeadtakerRun"))


	end
end
