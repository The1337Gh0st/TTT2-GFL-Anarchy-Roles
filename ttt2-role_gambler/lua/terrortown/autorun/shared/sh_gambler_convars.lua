CreateConVar("ttt2_gambler_armor_value", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_gambler_convars", function(tbl)
	tbl[ROLE_GAMBLER] = tbl[ROLE_GAMBLER] or {}
	
	table.insert(tbl[ROLE_GAMBLER], {cvar = "ttt2_gambler_armor_value", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt2_gambler_armor_value (def. 30)"})
	
end)