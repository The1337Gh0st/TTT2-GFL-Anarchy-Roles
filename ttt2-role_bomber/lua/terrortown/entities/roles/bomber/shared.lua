if SERVER then
  AddCSLuaFile()
  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_bomber.vmt")

end

roles.InitCustomTeam("bomber", {
    icon = "vgui/ttt/dynamic/roles/icon_bomber",
    color = Color(184, 148, 114, 255)
})




function ROLE:PreInitialize()
  self.color = Color(184, 148, 114, 255)

  self.abbr = "bomber"
  self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 3
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0
	self.isOmniscientRole = true


  self.defaultEquipment = SPECIAL_EQUIPMENT
  self.defaultTeam = TEAM_BOMBER

  self.conVarData = {
    pct = 0.17,
    maximum = 1,
    minPlayers = 8,
    togglable = true,
    traitorButton = 1,
    random = 20,
    shopFallback = SHOP_DISABLED
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
    -- Set Model if Set Var
    SetGlobalInt("BomberWalk",ply:GetWalkSpeed())
SetGlobalInt("BomberRun",ply:GetRunSpeed())

	local speedscale = GetConVar("ttt2_bomber_movement_scale"):GetFloat()
	
    -- Give Mad Bomber Weapons
    ply:GiveEquipmentWeapon("weapon_ttt_mad_suicide_bomb")
	ply:GiveEquipmentWeapon("weapon_ttt_bomb_transmutation")

    -- Set HP
    ply:SetHealth(GetConVar("ttt2_bomber_health"):GetInt())
    ply:SetMaxHealth(GetConVar("ttt2_bomber_health"):GetInt())
	ply:GiveEquipmentItem("item_ttt_radar")
	ply:GiveEquipmentItem("item_ttt_noexplosiondmg")
	ply:GiveEquipmentItem("item_ttt_climb")
	ply:SetWalkSpeed(ply:GetWalkSpeed()*speedscale)
		ply:SetRunSpeed(ply:GetRunSpeed()*speedscale)

  end

  -- Remove Loadout on death and rolechange
  function ROLE:RemoveRoleLoadout(ply, isRoleChange)
    

    -- Remove Suicide Grunt Weps
    ply:StripWeapon("weapon_ttt_mad_suicide_bomb")
	ply:StripWeapon("weapon_ttt_bomb_transmutation")
	ply:RemoveEquipmentItem("item_ttt_radar")
	ply:RemoveEquipmentItem("item_ttt_noexplosiondmg")
	ply:RemoveEquipmentItem("item_ttt_climb")

    --Reset Health
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
	ply:SetWalkSpeed(GetGlobalInt("BomberWalk"))
  	ply:SetRunSpeed(GetGlobalInt("BomberRun"))

  end
end

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

    form:MakeSlider({
      serverConvar = "ttt2_bomber_health",
      label = "ttt2_bomber_health",
      min = 1,
      max = 150,
      decimal = 0
    })

    form:MakeCheckBox({
      serverConvar = "ttt2_bomber_worldspawn",
      label = "ttt2_bomber_worldspawn"
    })

    form:MakeCheckBox({
      serverConvar = "ttt2_bomber_need_corpse",
      label = "ttt2_bomber_need_corpse"
    })

    form:MakeSlider({
      serverConvar = "ttt2_bomber_respawn_delay",
      label = "ttt2_bomber_respawn_delay",
      min = 0,
      max = 10,
      decimal = 1
    })

    form:MakeCheckBox({
      serverConvar = "ttt2_bomber_block_round",
      label = "ttt2_bomber_block_round"
    })
	
	form:MakeSlider({
      serverConvar = "ttt2_bomber_movement_scale",
      label = "ttt2_bomber_movement_scale",
      min = 0,
      max = 100,
      decimal = 1
    })

  end
end