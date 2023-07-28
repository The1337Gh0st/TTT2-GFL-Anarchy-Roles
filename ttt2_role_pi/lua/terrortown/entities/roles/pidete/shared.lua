if SERVER then
	-- materials
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_pidete.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(0, 130, 127, 255)

	self.abbr = "pidete"
	self.score.killsMultiplier = 8
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 3
	self.unknownTeam = true

	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT

	--self.isPublicRole = true
	self.isPolicingRole = true

	-- conVarData
	self.conVarData = {
		pct = 0.13,
		maximum = 32,
		minPlayers = 16,
		minKarma = 600,

		credits = 1,
		creditsAwardDeadEnable = 1,
		creditsAwardKillEnable = 0,

		togglable = true,
		shopFallback = SHOP_FALLBACK_DETECTIVE
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_DETECTIVE)
end

if SERVER then
	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt_wtester")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:RemoveEquipmentWeapon("weapon_ttt_wtester")
	end
	end