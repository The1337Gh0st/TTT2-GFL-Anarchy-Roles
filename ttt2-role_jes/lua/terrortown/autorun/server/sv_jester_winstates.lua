local function JesterTakeNoDamage(ply, attacker)
	if not IsValid(ply) or ply:GetSubRole() ~= ROLE_JESTER then return end

	if IsValid(attacker) and attacker ~= ply then return end

	return true -- true to block damage event
end

local function JesterDealNoDamage(ply, attacker)
	if not IsValid(ply) or not IsValid(attacker) or not attacker:IsPlayer() or attacker:GetSubRole() ~= ROLE_JESTER then return end
	if SpecDM and (ply.IsGhost and ply:IsGhost() or (attacker.IsGhost and attacker:IsGhost())) then return end

	return true -- true to block damage event
end

local function SpawnJesterConfetti(ply)
	if not IsValid(ply) or ply:GetSubRole() ~= ROLE_JESTER then return end

	if not IsValid(attacker) or attacker == ply then return end

	net.Start("NewConfetti")
	net.WriteEntity(ply)
	net.Broadcast()

	ply:EmitSound("ttt2/birthdayparty.mp3")
end

local function JesterRevive(ply, fn)
	ply:Revive(3, function(p)
		fn(p)
	end,
	function(p)
		return IsValid(p)
	end) -- revive after 3s
end

local winstates_death
winstates_death = {
	-- if the jester is killed, he has won
	[1] = function(ply, killer)
		local role = killer:GetRole()

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		JesterRevive(ply, function(p)
			p:SetRole(role)
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,

	-- Jester respawns after three seconds with a random opposite role of his killer
	[2] = function(ply, killer)
		local role = killer:GetRole()

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		JesterRevive(ply, function(p)
			p:SetRole(role)
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,

	-- Jester respawns after killer death with a random opposite role
	[3] = function(ply, killer)
		local role = killer:GetRole()

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		JesterRevive(ply, function(p)
			p:SetRole(role)
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,

	-- Jester respawns after killer death with the role of his killer
	[4] = function(ply, killer)
		local rd = killer:GetSubRoleData()
		local selectablePlys = roleselection.GetSelectablePlayers(player.GetAll())
		local reviveRoleCandidates = table.Copy(roleselection.GetAllSelectableRolesList(#selectablePlys))
		local reviveRoles = {}

		-- make sure innocent and traitor are revive candidate roles
		reviveRoleCandidates[ROLE_INNOCENT] = reviveRoleCandidates[ROLE_INNOCENT] or 1
		reviveRoleCandidates[ROLE_TRAITOR] = reviveRoleCandidates[ROLE_TRAITOR] or 1

		--remove jester from the revive candidate roles
		reviveRoleCandidates[ROLE_JESTER] = nil

		for k in pairs(reviveRoleCandidates) do
			local roleData = roles.GetByIndex(k)
			if roleData.defaultTeam ~= rd.defaultTeam then
				reviveRoles[#reviveRoles + 1] = k
			end
		end

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		-- set random available role
		JesterRevive(ply, function(p)
			p:SetRole(reviveRoles[math.random(1, #reviveRoles)])
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,

	-- Jester respawns after three seconds with the role of the killer and the killer dies
	[5] = function(ply, killer)
		local role = killer:GetRole()

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		JesterRevive(ply, function(p)
			p:SetRole(role)
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,

	-- Jester respawns within three seconds with a role in an opposing team of the killer and the killer dies
	[6] = function(ply, killer)
		local rd = killer:GetSubRoleData()
		local selectablePlys = roleselection.GetSelectablePlayers(player.GetAll())
		local reviveRoleCandidates = table.Copy(roleselection.GetAllSelectableRolesList(#selectablePlys))
		local reviveRoles = {}

		-- make sure innocent and traitor are revive candidate roles
		reviveRoleCandidates[ROLE_INNOCENT] = reviveRoleCandidates[ROLE_INNOCENT] or 1
		reviveRoleCandidates[ROLE_TRAITOR] = reviveRoleCandidates[ROLE_TRAITOR] or 1

		--remove jester from the revive candidate roles
		reviveRoleCandidates[ROLE_JESTER] = nil

		for k in pairs(reviveRoleCandidates) do
			local roleData = roles.GetByIndex(k)
			if roleData.defaultTeam ~= rd.defaultTeam then
				reviveRoles[#reviveRoles + 1] = k
			end
		end

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		-- set random available role
		JesterRevive(ply, function(p)
			p:SetRole(reviveRoles[math.random(1, #reviveRoles)])
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,

	-- Jester respawns after three seconds with the role of the killer and the killer dies,
	-- unless the killer is a traitor or serialkiller, then jester is killed normally
	[7] = function(ply, killer)
		local rd = killer:GetSubRoleData()
		local selectablePlys = roleselection.GetSelectablePlayers(player.GetAll())
		local reviveRoleCandidates = table.Copy(roleselection.GetAllSelectableRolesList(#selectablePlys))
		local reviveRoles = {}

		-- make sure innocent and traitor are revive candidate roles
		reviveRoleCandidates[ROLE_INNOCENT] = reviveRoleCandidates[ROLE_INNOCENT] or 1
		reviveRoleCandidates[ROLE_TRAITOR] = reviveRoleCandidates[ROLE_TRAITOR] or 1

		--remove jester from the revive candidate roles
		reviveRoleCandidates[ROLE_JESTER] = nil

		for k in pairs(reviveRoleCandidates) do
			local roleData = roles.GetByIndex(k)
			if roleData.defaultTeam ~= rd.defaultTeam then
				reviveRoles[#reviveRoles + 1] = k
			end
		end

		killer:Kill()
		LANG.Msg(killer, "ttt2_role_jester_killer_info", nil, MSG_MSTACK_ROLE)

		-- set random available role
		JesterRevive(ply, function(p)
			p:SetRole(reviveRoles[math.random(1, #reviveRoles)])
			p:SetDefaultCredits()
			p:ResetConfirmPlayer()
			SendFullStateUpdate()
		end)

		return true
	end,
}

-- Jester deals no damage to other players
hook.Add("PlayerTakeDamage", "JesterNoDamage", function(ply, inflictor, killer, amount, dmginfo)
	if JesterTakeNoDamage(ply, killer) or JesterDealNoDamage(ply, killer) then
		dmginfo:ScaleDamage(0)
		dmginfo:SetDamage(0)

		return
	end
end)

hook.Add("TTT2PostPlayerDeath", "JesterPostDeath", function(ply, inflictor, killer)
	if not IsValid(ply)
		or ply:GetSubRole() ~= ROLE_JESTER
		or not IsValid(killer)
		or not killer:IsPlayer()
		or killer == ply
		or GetRoundState() ~= ROUND_ACTIVE
		or hook.Run("TTT2PreventJesterWinstate", killer) and JESTER.winstate ~= 1
		or SpecDM and (ply.IsGhost and ply:IsGhost() or (killer.IsGhost and killer:IsGhost()))
	then return end

	if winstates_death[JESTER.winstate](ply, killer) then
		SpawnJesterConfetti(ply)
	end
end)

-- reset hooks at round end
hook.Add("TTTEndRound", "JesterEndRound", function()
	for _, v in ipairs(player.GetAll()) do
		hook.Remove("PostPlayerDeath", "JesterWaitForKillerDeath_" .. v:SteamID64())
	end

	JESTER.shouldWin = false
end)
