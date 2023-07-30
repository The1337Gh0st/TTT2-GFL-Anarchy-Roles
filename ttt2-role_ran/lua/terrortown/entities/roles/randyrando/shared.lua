if SERVER then
  AddCSLuaFile()

  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_rnd.vmt")
end

roles.InitCustomTeam(ROLE.name, {
    icon = "vgui/ttt/dynamic/roles/icon_rnd",
    color = Color(131,62,90, 255)
})

function ROLE:PreInitialize()
  self.color = Color(131,62,90, 255)

  self.abbr = "rnd" -- abbreviation
  self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
  self.score.killsMultiplier = 10 -- multiplier for kill of player of another team
  self.score.teamKillsMultiplier = -10 -- multiplier for teamkill
  self.isOmniscientRole = true

  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
  self.defaultTeam = TEAM_RANDYRANDO
  self.fallbackTable = {}

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 12, -- minimum amount of players until this role is able to get selected
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 25,
    credits = 1
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

  function ROLE:GiveRoleLoadout(ply, isRoleChange) -- gives it a loadout on round start
       ply:GiveEquipmentWeapon("weapon_ttt2mg_randomat_rdr")
       ply:GiveEquipmentWeapon("ttt_randomgun")
	   ply:GiveEquipmentItem("item_ttt_radar")
	   ply:GiveArmor(GetConVar("ttt_rnd_armor_value"):GetInt())
  end


  function ROLE:RemoveRoleLoadout(ply, isRoleChange) -- removes loadout on role change
        ply:StripWeapon("weapon_ttt2mg_randomat_rdr")
        ply:StripWeapon("ttt_randomgun")
  end
end
