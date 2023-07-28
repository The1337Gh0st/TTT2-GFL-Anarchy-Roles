if SERVER then
	
	AddCSLuaFile()
	
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_maker.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(141, 182, 0, 255)
	self.abbr = "maker"
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
    roles.SetBaseRole(self, ROLE_DETECTIVE)
	
	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage("en", self.name, "Maker")
		LANG.AddToLanguage("en", "info_popup_" .. self.name, [[You are a Maker!
	Go place some Minecraft Blocks!]])
		LANG.AddToLanguage("en", "body_found_" .. self.abbr, "This was a Maker...")
		LANG.AddToLanguage("en", "search_role_" .. self.abbr, "This person was a Maker!")
		LANG.AddToLanguage("en", "target_" .. self.name, "Maker")
		LANG.AddToLanguage("en", "ttt2_desc_" .. self.name, [[The Maker is a Detective who has the ability to place minecraft blocks around the map!]])

	end
end

if SERVER then
	-- Give Loadout on respawn and rolechange	
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("minecraft_swep")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("minecraft_swep")
	end
end
