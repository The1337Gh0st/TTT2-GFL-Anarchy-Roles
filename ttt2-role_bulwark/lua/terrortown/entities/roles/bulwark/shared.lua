AddCSLuaFile()

if SERVER then
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_bulwark.vmt")
	resource.AddFile("models/npcsolaire/player_solaire.mdl")
end

roles.InitCustomTeam(ROLE.name, {
	icon = "vgui/ttt/dynamic/roles/icon_bulwark",
	color = Color(253, 248, 32, 255)
})

function ROLE:PreInitialize()
	self.color = Color(253, 248, 32, 255)

	self.abbr = "bulwark"
	self.score.surviveBonusMultiplier = 0
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 1
	self.score.teamKillsMultiplier = -1
	self.score.bodyFoundMuliplier = 0
	
	self.isOmniscientRole = true
	self.isPublicRole = true

	self.defaultTeam = TEAM_BULWARK
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.conVarData = {
		pct = 0.14,
		maximum = 1,
		minPlayers = 7,
		random = 50,

		creditsAwardDeadEnable = 0,
		creditsAwardKillEnable = 0,

		togglable = true,
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

local bs = {}
	bs.oldModel = ""
	bs.model = util.IsValidModel("models/player_solaire.mdl") and Model("models/player_solaire.mdl") or Model("models/player/kleiner.mdl")
	
function ROLE:GiveRoleLoadout(ply, isRoleChange)

SetGlobalInt("BulwarkWalk",ply:GetWalkSpeed())
SetGlobalInt("BulwarkRun",ply:GetRunSpeed())

local speedscale = GetConVar("ttt2_bulwark_movement_scale"):GetFloat()
		
		ply:GiveEquipmentWeapon("weapon_ttt_medkit")
		ply:GiveEquipmentWeapon("weapon_ttt_minigun")
		ply:GiveEquipmentItem("item_ttt_radar")
		ply:GiveEquipmentItem("item_ttt_immunity")
		ply:GiveArmor(GetConVar("ttt2_bulwark_armor_value"):GetInt())
		ply:SetMaxHealth(GetConVar("ttt2_bulwark_health"):GetInt())
		ply:SetHealth(GetConVar("ttt2_bulwark_health"):GetInt())
		ply:SetWalkSpeed(ply:GetWalkSpeed()*speedscale)
		ply:SetRunSpeed(ply:GetRunSpeed()*speedscale)
		end
		
		function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		
		ply:StripWeapon("weapon_ttt_medkit")
		ply:StripWeapon("weapon_ttt_minigun")
		ply:RemoveEquipmentItem("item_ttt_radar")
		ply:RemoveEquipmentItem("item_ttt_immunity")
		ply:RemoveArmor(GetConVar("ttt2_bulwark_armor_value"):GetInt())
		
		-- Reset Values
    ply:SetMaxHealth(100)
	ply:SetHealth(100)
  	ply:SetWalkSpeed(GetGlobalInt("BulwarkWalk"))
  	ply:SetRunSpeed(GetGlobalInt("BulwarkRun"))
	
	end
	
	hook.Add("TTT2UpdateSubrole", "UpdateBulwarkRoleSelect", function(ply, oldSubrole, newSubrole)
		if GetConVar("ttt2_bulwark_force_model"):GetBool() then
			if newSubrole == ROLE_BULWARK then
				ply:SetSubRoleModel(bs.model)
			elseif oldSubrole == ROLE_BULWARK then
				ply:SetSubRoleModel(nil)
			end
		end
	end)
	
end

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")


    form:MakeSlider({
      serverConvar = "ttt2_bulwark_health",
      label = "ttt2_bulwark_health",
      min = 1,
      max = 1000,
      decimal = 0
    })

    form:MakeSlider({
      serverConvar = "ttt2_bulwark_movement_scale",
      label = "ttt2_bulwark_movement_scale",
      min = 0,
      max = 5,
      decimal = 2
    })

form:MakeSlider({
      serverConvar = "ttt2_bulwark_armor_value",
      label = "ttt2_bulwark_armor_value",
      min = 1,
      max = 1000,
      decimal = 0
    })
	
	form:MakeCheckBox({
      serverConvar = "ttt2_bulwark_force_model",
      label = "ttt2_bulwark_force_model"
    })
	
  end
end
