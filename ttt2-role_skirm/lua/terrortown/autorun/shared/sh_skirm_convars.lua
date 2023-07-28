CreateConVar("ttt_skirm_regain", 35, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_skirm_friendly_fire", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})




hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_skirmisher_convars", function(tbl)
	tbl[ROLE_SKIRMISHER] = tbl[ROLE_SKIRMISHER] or {}
table.insert(tbl[ROLE_SKIRMISHER], {
		cvar = "ttt_skirm_regain",
		slider = true,
		min = 0,
		max = 100,
		decimal = 0,
		desc = "ttt_skirm_regain (def. 100)"
	})
	end)