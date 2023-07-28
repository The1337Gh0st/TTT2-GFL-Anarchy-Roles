if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_passive",
	name = "Multi-Damage Type Immunity",
	desc = "Makes you immune to various types of damage."
}
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

ITEM.hud = Material("vgui/ttt/perks/hud_immunity.png")
ITEM.material = "vgui/ttt/icon_immunity"

if SERVER then

	hook.Add("EntityTakeDamage", "ImmunityNoDrownDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_DROWN) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)
	
	hook.Add("EntityTakeDamage", "ImmunityNoEnergyDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer()
			or not (dmginfo:IsDamageType(DMG_SHOCK) or dmginfo:IsDamageType(DMG_SONIC) or dmginfo:IsDamageType(DMG_ENERGYBEAM) or dmginfo:IsDamageType(DMG_PHYSGUN) or dmginfo:IsDamageType(DMG_PLASMA))
		then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)
	
	hook.Add("EntityTakeDamage", "ImmunityNoExplosionDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsExplosionDamage() then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)
	
	hook.Add("EntityTakeDamage", "ImmunityNoFallDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsFallDamage() then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)

	hook.Add("OnPlayerHitGround", "ImmunityNoFallDmg", function(ply)
		if ply:Alive() and ply:IsTerror() and ply:HasEquipmentItem("item_ttt_immunity") then
			return false
		end
	end)
	
	hook.Add("EntityTakeDamage", "ImmunityNoFireDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_BURN) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)
	
	hook.Add("EntityTakeDamage", "ImmunityNoHazardDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer()
			or not (dmginfo:IsDamageType(DMG_POISON) or dmginfo:IsDamageType(DMG_NERVEGAS) or dmginfo:IsDamageType(DMG_RADIATION) or dmginfo:IsDamageType(DMG_ACID) or dmginfo:IsDamageType(DMG_DISSOLVE))
		then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)
	
	hook.Add("EntityTakeDamage", "ImmunityNoPropDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_CRUSH) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_immunity") then
			dmginfo:ScaleDamage(0)
		end
	end)
	
end