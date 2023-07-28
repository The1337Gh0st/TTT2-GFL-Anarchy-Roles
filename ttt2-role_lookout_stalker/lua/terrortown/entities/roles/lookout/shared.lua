if SERVER then
	
	AddCSLuaFile()
	
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_look.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_look.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(141, 182, 0, 255)
	self.abbr = "look"
	self.surviveBonus = 0.5
	self.score.killsMultiplier = 10
	self.score.teamKillsMultiplier = -10

	self.fallbackTable = {}
	self.unknownTeam = true
	
	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT

	-- conVarData
	self.conVarData = {
		pct = 0.13,
		maximum = 32,
		minPlayers = 8,

		credits = 2,
		creditsTraitorKill = 0,
		creditsTraitorDead = 1,

		togglable = true,
		shopFallback = NONE
	}
end

function ROLE:Initialize()
    roles.SetBaseRole(self, ROLE_INNOCENT)
	
	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage("en", self.name, "Lookout")
		LANG.AddToLanguage("en", "info_popup_" .. self.name, [[You are a Lookout!
	Try to place some cameras around!]])
		LANG.AddToLanguage("en", "body_found_" .. self.abbr, "This was a Lookout...")
		LANG.AddToLanguage("en", "search_role_" .. self.abbr, "This person was a Lookout!")
		LANG.AddToLanguage("en", "target_" .. self.name, "Lookout")
		LANG.AddToLanguage("en", "ttt2_desc_" .. self.name, [[The Lookout is an Innocent who has the ability to place cameras around the map and on people!]])

	end
end

if SERVER then
	-- Give Loadout on respawn and rolechange	
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt_dete_playercam")
		ply:GiveEquipmentWeapon("weapon_ttt_ttt2_camera")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt_dete_playercam")
		ply:StripWeapon("weapon_ttt_ttt2_camera")
	end
end
