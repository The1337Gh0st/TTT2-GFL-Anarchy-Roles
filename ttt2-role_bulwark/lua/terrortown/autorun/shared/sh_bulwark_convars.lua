-- replicated convars have to be created on both client and server
CreateConVar("ttt2_bulwark_armor_value", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_bulwark_health", 100, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bulwark_movement_scale", 0.7, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bulwark_force_model", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_bulwark_convars", function(tbl)
	tbl[ROLE_BULWARK] = tbl[ROLE_BULWARK] or {}

	table.insert(tbl[ROLE_BULWARK], {cvar = "ttt2_bulwark_armor_value", slider = true, min = 0, max = 1000, decimal = 0, desc = "ttt_bulwark_armor_value (def. 30)"})
	
	table.insert(tbl[ROLE_BULWARK], {
      cvar = "ttt2_bulwark_health",
      slider = true,
      min = 1,
      max = 1000,
      desc = "ttt2_bulwark_health (def. 100)"
  })
  
  
  table.insert(tbl[ROLE_BULWARK], {
      cvar = "ttt2_bulwark_movement_scale",
      slider = true,
      min = 0,
      max = 5,
      decimal = 2,
      desc = "ttt2_bulwark_movement_scale (def. 0.7)"
  })
  
  table.insert(tbl[ROLE_BULWARK], {
    cvar = "ttt2_bulwark_force_model",
    checkbox = true,
    desc = "ttt2_bulwark_force_model (Def. 1)"
  })
  
end)