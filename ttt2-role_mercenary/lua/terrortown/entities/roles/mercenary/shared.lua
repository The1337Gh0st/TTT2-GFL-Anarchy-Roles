AddCSLuaFile()

if SERVER then
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mercenary.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(256, 36, 0, 255)

	self.abbr = "mercenary"
	self.score.surviveBonusMultiplier = 0.3 -- bonus multiplier for every survive while another player was killed
  self.score.killsMultiplier = 5 -- multiplier for kill of player of another team
  self.score.teamKillsMultiplier = -10 -- multiplier for teamkill
  self.preventFindCredits = false
  self.preventKillCredits = false
  self.preventTraitorAloneCredits = false
  self.isOmniscientRole = true



	self.defaultTeam = TEAM_TRAITOR
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.conVarData = {
		pct = 0.15,
		maximum = 2,
		minPlayers = 7,
		minKarma = 400,

		credits = 0,
		creditsAwardDeadEnable = 0,
		creditsAwardKillEnable = 1,

		togglable = true,
		shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
end

if SERVER then
	-- modify roles table of rolesetup addon

	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		

		ply:GiveArmor(GetConVar("ttt2_mercenary_armor_value"):GetInt())
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:RemoveArmor(GetConVar("ttt2_mercenary_armor_value"):GetInt())
	end
end
