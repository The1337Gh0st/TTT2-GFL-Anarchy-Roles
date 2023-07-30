-- replicated convars have to be created on both client and server
CreateConVar("ttt_rnd_armor_value", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_rnd_credits_traitorkill", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_rnd_credits_traitordead", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_rnd_convars", function(tbl)
	tbl[ROLE_RANDYRANDO] = tbl[ROLE_RANDYRANDO] or {}

table.insert(tbl[ROLE_RANDYRANDO], {cvar = "ttt_rnd_armor_value", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_rnd_armor_value (def. 30)"})
table.insert(tbl[ROLE_RANDYRANDO], {cvar = "ttt_rnd_credits_traitorkill", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_rnd_credits_traitorkill (def. 1)"})
table.insert(tbl[ROLE_RANDYRANDO], {cvar = "ttt_rnd_credits_traitordead", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_rnd_credits_traitordead (def. 1)"})	
end)

