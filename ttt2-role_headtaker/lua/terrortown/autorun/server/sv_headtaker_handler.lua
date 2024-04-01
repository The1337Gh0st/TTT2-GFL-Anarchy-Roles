local function HeadtakerDamageAttempt(ply, attacker)
	if not IsValid(ply) or not IsValid(attacker) or not attacker:IsPlayer() or attacker:GetSubRole() ~= ROLE_HEADTAKER then return end
	if SpecDM and (ply.IsGhost and ply:IsGhost() or (attacker.IsGhost and attacker:IsGhost())) then return end

	return true -- true to block damage event
end

hook.Add('EntityTakeDamage', 'PreventHeadtakerTeamDamage', function (ply, dmg)
	local at = dmg:GetAttacker()
    
    if at and IsValid(at) and at:IsPlayer() and ply and IsValid(ply) and ply:IsPlayer() and at:GetTeam() == TEAM_HEADTAKER and ply:GetTeam() == TEAM_HEADTAKER then
    	return true
    end
end)

hook.Add("PlayerTakeDamage", "HeadtakerDamage", function(ply, inflictor, killer, amount, dmginfo)

    if not HeadtakerDamageAttempt(ply, killer) then return end
    if  inflictor ~= killer and inflictor:GetClass() == "weapon_ttt_headtaker" then
        dmginfo:ScaleDamage(1)
	else
    
        dmginfo:ScaleDamage(0)
	    dmginfo:SetDamage(0)
    end

end)

HEADTAKER_DATA = {}


if SERVER then

local cv_ref = GetConVar("ttt2_headtaker_regain")
local cv_ref2 = GetConVar("ttt2_headtaker_friendly_fire")

hook.Add("TTT2PostPlayerDeath","HeadtakerLifeSteal", function(ply, _, attacker)
            if not IsValid(ply) then return end
            if not attacker or not IsValid(attacker) or not attacker:IsPlayer() or not attacker:Alive() then return end
            if (attacker.IsGhost and attacker:IsGhost()) or (ply.IsGhost and ply:IsGhost()) then return end
            if attacker:GetSubRole() ~= ROLE_HEADTAKER then return end
            if not cv_ref2:GetBool() and attacker:GetTeam() == ply:GetTeam() then return end
            attacker:SetHealth(math.Clamp(attacker:Health() + cv_ref:GetInt(), 0, attacker:GetMaxHealth()))
            end)
end

--hook.Add("TTTPlayerSpeedModifier", "HeadtakerSpeed", HeadtakerSpeed)

--local function HeadtakerSpeed(ply, _, _, speedMultiplierModifier)
--  if not IsValid(ply) then return end
 -- if not ply:Alive() or ply:IsSpec() then return end
 -- if (ply:GetSubRole() ~= ROLE_HEADTAKER) then return end
 -- if not ply:GetNWBool("Headtaker_Speed", false) then return end


--  speedMultiplierModifier[1] = speedMultiplierModifier[1] * (GetConVar("ttt2_headtaker_speed_mult"):GetFloat())
--end

hook.Add("TTTPlayerSpeedModifier", "TTT2HeadtakerSpeed", function(ply, _, _, speedMultiplierModifier)
  if not IsValid(ply) then return end
 if not ply:Alive() or ply:IsSpec() then return end
  if (ply:GetSubRole() ~= ROLE_HEADTAKER) then return end
  if not ply:GetNWBool("Headtaker_Speed", false) then return end


  speedMultiplierModifier[1] = speedMultiplierModifier[1] * 1.5
end)




