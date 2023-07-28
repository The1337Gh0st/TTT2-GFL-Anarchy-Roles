if SERVER then
	AddCSLuaFile()
	
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_kcl.vmt")

	local startCredits = CreateConVar("ttt2_clown_activation_credits", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
end

function ROLE:PreInitialize()
	self.color = Color(245, 48, 155, 255)

	self.abbr = "kcl" -- abbreviation
	self.radarColor = Color(245, 48, 155) -- color if someone is using the radar
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -4
	self.score.bodyFoundMuliplier = 0
	self.preventWin = false -- set true if role can't win (maybe because of own / special win conditions)
	self.defaultTeam = TEAM_CLOWN -- the team name: roles with same team name are working together
	self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
	self.notSelectable = true

	if not startCredits then
		startCredits = 0
		print("Failed to retrieve credit convar for clown, set to 0 credits on transform to prevent errors")
	end 
	
	self.conVarData = {
		pct = 0.00, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 99, -- minimum amount of players until this role is able to get selected
		random = 30,
		credits = startCredits, -- the starting credits of a specific role
		togglable = false, -- option to toggle a role for a client if possible (F1 menu)
		shopFallback = SHOP_TRAITOR,
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_CLOWN)
end

if SERVER then

function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:SetMaxHealth(GetConVar("ttt2_clown_kclown_maxhealth"):GetInt())
		ply:SetHealth(GetConVar("ttt2_clown_kclown_maxhealth"):GetInt())
		ply:GiveEquipmentItem("item_ttt_radar")
		ply:GiveArmor(GetConVar("ttt2_clown_kclown_armor_value"):GetInt())
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
ply:SetMaxHealth(100)
		ply:SetHealth(100)
	ply:RemoveEquipmentItem("item_ttt_radar")
	ply:RemoveArmor(GetConVar("ttt2_clown_kclown_armor_value"):GetInt())
	end


	hook.Add("ScalePlayerDamage", "KillerClownDamageScale", function(ply, hitgroup, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if attacker:GetSubRole() == ROLE_KILLERCLOWN then
            local bonus = GetConVar("ttt2_clown_damage_bonus"):GetFloat()
            dmginfo:ScaleDamage(1 + bonus)
        end
	end)

local kclown_health_regen = CreateConVar("ttt2_clown_kclown_health_regen", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
	
	hook.Add("Think", "KClownHealthRegen", function()
		for _, v in ipairs(player.GetAll()) do
			local time = CurTime()

			if v:IsActive() and v:IsTerror() and v:GetSubRole() == ROLE_KILLERCLOWN and (v.KClownLastDamageReceived or 0) + 1 <= time then
				v.KClownLastDamageReceived = time

				v:SetHealth(math.Clamp(v:Health() + GetConVar("ttt2_clown_kclown_health_regen"):GetInt(), 0, v:GetMaxHealth()))
			end
		end
	end)

hook.Add("TTT2SyncGlobals", "AddKClownGlobals", function()
		SetGlobalFloat(kclown_health_regen:GetName(), kclown_health_regen:GetFloat())
	end)


cvars.AddChangeCallback(kclown_health_regen:GetName(), function(name, old, new)
		SetGlobalFloat(name, new)
	end, "TTT2KClownHealthRegenChange")
	
end

