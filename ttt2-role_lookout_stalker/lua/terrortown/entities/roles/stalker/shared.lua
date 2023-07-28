if SERVER then
	
	AddCSLuaFile()
	
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_stalk.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/icon_stalk.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(212, 21, 66, 255)
	self.abbr = "stalk"
self.score.surviveBonusMultiplier = 0.3 -- bonus multiplier for every survive while another player was killed
  self.score.killsMultiplier = 5 -- multiplier for kill of player of another team
  self.score.teamKillsMultiplier = -10 -- multiplier for teamkill
  self.preventFindCredits = false
  self.preventKillCredits = false
  self.preventTraitorAloneCredits = false


  self.isOmniscientRole = true

  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
  self.defaultTeam = TEAM_TRAITOR

	-- conVarData
	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 0, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 50,
    traitorButton = 1, -- can use traitor buttons
    shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

function ROLE:Initialize()
    roles.SetBaseRole(self, ROLE_TRAITOR)
	
	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage("en", self.name, "Stalker")
		LANG.AddToLanguage("en", "info_popup_" .. self.name, [[You are a Stalker! Use your cameras to track people!]])
		LANG.AddToLanguage("en", "body_found_" .. self.abbr, "This person was a Stalker!")
		LANG.AddToLanguage("en", "search_role_" .. self.abbr, "This person was a Stalker!")
		LANG.AddToLanguage("en", "target_" .. self.name, "Stalker")
		LANG.AddToLanguage("en", "ttt2_desc_" .. self.name, [[The Stalker is a Traitor who has the ability to place cameras around the map and on people!]])

		
	end
end

if SERVER then
	-- Give Loadout on respawn and rolechange	
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt_player_tracker")
		ply:GiveEquipmentWeapon("weapon_ttt_ttt2_camera")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt_player_tracker")
		ply:StripWeapon("weapon_ttt_ttt2_camera")
	end
end
