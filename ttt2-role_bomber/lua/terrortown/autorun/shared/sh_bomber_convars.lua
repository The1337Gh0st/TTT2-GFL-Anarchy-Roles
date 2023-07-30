CreateConVar("ttt2_bomber_health", 100, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bomber_worldspawn", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bomber_need_corpse", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bomber_respawn_delay", 2, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bomber_block_round", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt2_bomber_movement_scale", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicBomberCVars", function(tbl)
	tbl[ROLE_BOMBER] = tbl[ROLE_BOMBER] or {}


    table.insert(tbl[ROLE_BOMBER], {
		cvar = "ttt2_bomber_health",
		slider = true,
		min = 1,
		max = 150,
		decimal = 0,
		desc = "ttt2_bomber_health [1..150] (Def: 100)"
	})

	table.insert(tbl[ROLE_BOMBER], {
    cvar = "ttt2_bomber_worldspawn",
    checkbox = true,
    desc = "ttt2_bomber_worldspawn (Def. 0)"
    })

    table.insert(tbl[ROLE_BOMBER], {
    cvar = "ttt2_bomber_need_corpse",
    checkbox = true,
    desc = "ttt2_bomber_need_corpse (Def. 1)"
    })

	table.insert(tbl[ROLE_BOMBER], {
		cvar = "ttt2_bomber_respawn_delay",
		slider = true,
		min = 0,
		max = 10,
		decimal = 1,
		desc = "ttt2_bomber_respawn_delay [0..10] (Def: 2)"
	})

	table.insert(tbl[ROLE_BOMBER], {
    cvar = "ttt2_bomber_block_round",
    checkbox = true,
    desc = "ttt2_bomber_block_round (Def. 1)"
    })
	
	table.insert(tbl[ROLE_BOMBER], {
		cvar = "ttt2_bomber_movement_scale",
		slider = true,
		min = 0,
		max = 100,
		decimal = 2,
		desc = "ttt2_bomber_movement_scale [0..100] (Def: 0.8)"
	})
end)