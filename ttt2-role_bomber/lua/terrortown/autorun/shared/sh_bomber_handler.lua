local function BomberDamageAttempt(ply, attacker)
	if not IsValid(ply) or not IsValid(attacker) or not attacker:IsPlayer() or attacker:GetSubRole() ~= ROLE_BOMBER then return end
	if SpecDM and (ply.IsGhost and ply:IsGhost() or (attacker.IsGhost and attacker:IsGhost())) then return end

	return true -- true to block damage event
end

hook.Add('EntityTakeDamage', 'PreventBomberTeamDamage', function (ply, dmg)
	local at = dmg:GetAttacker()
    
    if at and IsValid(at) and at:IsPlayer() and ply and IsValid(ply) and ply:IsPlayer() and at:GetTeam() == TEAM_BOMBER and ply:GetTeam() == TEAM_BOMBER then
    	return true
    end
end)

hook.Add('EntityTakeDamage', 'PreventBomberJesterDamage', function (ply, dmg)
	local at = dmg:GetAttacker()
    
    if at and IsValid(at) and at:IsPlayer() and ply and IsValid(ply) and ply:IsPlayer() and at:GetSubRole() == ROLE_BOMBER and ply:GetSubRole() == ROLE_JESTER then
    	return true
    end
end)



hook.Add("PlayerTakeDamage", "BomberDamage", function(ply, inflictor, killer, amount, dmginfo)

    if not BomberDamageAttempt(ply, killer) then return end
    if  inflictor ~= killer and inflictor:GetClass() == "weapon_mad_suicide_bomb" or inflictor:GetClass() == "weapon_ttt_bomb_transmutation" or inflictor:GetClass() == "weapon_zm_improvised" or dmginfo:IsDamageType(DMG_DISSOLVE) then
        dmginfo:ScaleDamage(1)
	else
    
       dmginfo:ScaleDamage(0)
	    dmginfo:SetDamage(0)
    end

end)

hook.Add("PlayerTakeDamage", "BomberCrowbarDamage", function(ply, inflictor, killer, amount, dmginfo)

    if not BomberDamageAttempt(ply, killer) then return end
    if  inflictor ~= killer and inflictor:GetClass() == "weapon_zm_improvised" then
        dmginfo:SetDamage(50)
	--else
    
     --   dmginfo:ScaleDamage(0)
	  --  dmginfo:SetDamage(0)
    end

end)



if SERVER then
  hook.Add("TTT2PostPlayerDeath", "BomberKilled", function(ply, inflictor, attacker)
    

    if (IsValid(attacker) and attacker:IsPlayer() and attacker:GetSubRole() == ROLE_BOMBER and ply:GetSubRole() == ROLE_BOMBER) then --return end --CHECK ATTACKER: skip if attacker isnt bomber

      --if (inflictor ~= "weapon_grunt_bomb") then return end --CHECK INFLICTOR: skip if not the grunt bomb suicide
      
      ply:SetNWInt("bomber_death_count", ply:GetNWInt("bomber_death_count", 0) + 1)
      
      --if death_count > GetConVar("ttt2_rst_lives"):GetInt() then return end
      local death_count = ply:GetNWInt("bomber_death_count", 0)
      print(ply:Nick() .. "'s Death Count: " .. death_count)
      local spawn_delay = GetConVar("ttt2_bomber_respawn_delay"):GetFloat()
      local spawnpoint = spawn.MakeSpawnPointSafe(ply)
      local doWorldSpawn = GetConVar("ttt2_bomber_worldspawn"):GetBool()
      local bomber_health = GetConVar("ttt2_bomber_health"):GetInt()
      --local spawnpoint_cost = GetConVar("ttt2_rst_spawn_cost"):GetInt()

      ply:Revive(
        spawn_delay,
        function()
          events.Trigger(EVENT_BOMBER_REVIVE, ply, death_count, doWorldSpawn)
          if (doWorldSpawn and spawnpoint) then
            ply:SetPos(spawnpoint.pos)
          end
          ply:SetHealth(bomber_health)
          ply:SetMaxHealth(bomber_health)
          -- Rosalina revive damagelogs code
          hook.Run("PlayerRevived",
            ply,
            ply:GetSubRole(),
            ply:GetTeam()
          )
          --
        end,
        function()
          return ply:GetSubRole() == ROLE_BOMBER
        end,
        GetConVar("ttt2_bomber_need_corpse"):GetBool(),
        GetConVar("ttt2_bomber_block_round"):GetBool()
      )

      if not doWorldSpawn then
        ply:SendRevivalReason("bomber_reviving")
      else
        ply:SendRevivalReason("bomber_reviving_worldspawn")
      end
    else --bomber just dies


    end
  end)

  hook.Add("TTTBeginRound", "BomberDeathReset", function()
    for _, ply in ipairs(player.GetAll()) do
      ply:SetNWInt("bomber_death_count", nil)
    end
  end)

  hook.Add("TTTEndRound", "BomberDeathReset", function()
    for _, ply in ipairs(player.GetAll()) do
      ply:SetNWInt("bomber_death_count", nil)
    end
  end)

  hook.Add("TTTPrepRound", "BomberDeathReset", function()
    for _, ply in ipairs(player.GetAll()) do
      ply:SetNWInt("bomber_death_count", nil)
    end
  end)
end