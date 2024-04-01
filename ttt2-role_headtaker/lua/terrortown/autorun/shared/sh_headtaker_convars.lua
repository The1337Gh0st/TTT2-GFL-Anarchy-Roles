-- replicated convars have to be created on both client and server
CreateConVar("ttt2_headtaker_armor_value", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_headtaker_health", 150, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_headtaker_regain", 25, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_headtaker_friendly_fire", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_headtaker_movement_scale", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
--CreateConVar("ttt2_headtaker_speed_mult", 1.5, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_headtaker_convars", function(tbl)
	tbl[ROLE_HEADTAKER] = tbl[ROLE_HEADTAKER] or {}

	table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt2_headtaker_armor_value", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_headtaker_armor_value (def. 30)"})
	table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt2_headtaker_health", slider = true, min = 0, max = 500, decimal = 0, desc = "ttt_headtaker_health (def. 150)"})
	table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt2_headtaker_regain", slider = true, min = 0, max = 500, decimal = 0, desc = "ttt2_headtaker_regain (def. 25)"})
	table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt2_headtaker_friendly_fire", slider = true, min = 0, max = 500, decimal = 0, desc = "ttt2_headtaker_friendly_fire (def. 0)"})
	table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt2_headtaker_movement_scale", slider = true, min = 0, max = 5, decimal = 2, desc = "ttt2_headtaker_movement_scale (def. 0.75)"})
--	table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt2_headtaker_speed_mult", slider = true, min = 0, max = 5, decimal = 1, desc = "ttt2_headtaker_friendly_fire (def. 1.5)"})
	
	--table.insert(tbl[ROLE_HEADTAKER], {cvar = "ttt_headtaker_spawn_siki_deagle", checkbox = true, desc = "ttt_headtaker_spawn_siki_deagle (def. 1)"})
end)
