SKIRMISHER_DATA = {}


if SERVER then

local cv_ref = GetConVar("ttt_skirm_regain")
local cv_ref2 = GetConVar("ttt_skirm_friendly_fire")

hook.Add("TTT2PostPlayerDeath","SkirmisherLifeSteal", function(ply, _, attacker)
            if not IsValid(ply) then return end
            if not attacker or not IsValid(attacker) or not attacker:IsPlayer() or not attacker:Alive() then return end
            if (attacker.IsGhost and attacker:IsGhost()) or (ply.IsGhost and ply:IsGhost()) then return end
            if attacker:GetSubRole() ~= ROLE_SKIRMISHER then return end
            if not cv_ref2:GetBool() and attacker:GetTeam() == ply:GetTeam() then return end
            attacker:SetHealth(math.Clamp(attacker:Health() + cv_ref:GetInt(), 0, attacker:GetMaxHealth()))
            end)
end