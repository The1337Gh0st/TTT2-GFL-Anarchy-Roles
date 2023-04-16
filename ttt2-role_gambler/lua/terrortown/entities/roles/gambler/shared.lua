if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_gambler.vmt")
	--util.AddNetworkString("gambler_message")
end

--roles.InitCustomTeam(ROLE.name, {
	--icon = "vgui/ttt/dynamic/roles/icon_gambler",
--	color = Color(128, 0, 0, 255)
--})

function ROLE:PreInitialize()
	self.color = Color(128, 0, 0, 255)

	self.abbr = "gambler"
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
		pct = 0.15, 							-- necessary: percentage of getting this role selected (per player)
		maximum = 1, 							-- maximum amount of roles in a round
		minPlayers = 8, 						-- minimum amount of players until this role is able to get selected
		credits = 0, 							-- the starting credits of a specific role
		togglable = true, 						-- option to toggle a role for a client if possible (F1 menu)
		random = 20,							-- what percentage chance the role will show up each round
		shopFallback = SHOP_DISABLED,	-- the fallback shop for the role to use,
		traitorButton = 1
	}
end


function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
	end
	
if	SERVER then

	function ROLE:GiveRoleLoadout(ply, isRoleChange)
	ply:GiveEquipmentItem("item_ttt_radar")
	ply:GiveArmor(GetConVar("ttt2_gambler_armor_value"):GetInt())
	ply:GiveEquipmentWeapon("weapon_ttt_gambler_case")
end

function ROLE:RemoveRoleLoadout(ply, isRoleChange)
ply:RemoveEquipmentItem("item_ttt_radar")
		ply:RemoveArmor(GetConVar("ttt2_gambler_armor_value"):GetInt())
		ply:StripWeapon("weapon_ttt_gambler_case")
	end

end
