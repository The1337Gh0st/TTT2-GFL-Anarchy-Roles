-- Put Convars in here

CreateConVar("ttt2_mercenary_armor_value", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_mercenary_convars", function(tbl)
	tbl[ROLE_MERCENARY] = tbl[ROLE_MERCENARY] or {}
	
	table.insert(tbl[ROLE_MERCENARY], {cvar = "ttt2_mercenary_armor_value", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt2_mercenary_armor_value (def. 30)"})
	
end)
