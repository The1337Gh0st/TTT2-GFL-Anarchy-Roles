L = LANG.GetLanguageTableReference("en")

L[BOMBER.name] = "Mad Bomber"
L[BOMBER.defaultTeam] = "Team Mad Bomber"
L["hilite_win_" .. BOMBER.defaultTeam] = "THE MAD BOMBER WON"
L["win_" .. BOMBER.defaultTeam] = "The Mad Bomber has won!"
L["info_popup_" .. BOMBER.name] = [[You are the Mad Bomber! You must kill all, and use yourself to do it!]]
L["body_found_" .. BOMBER.abbr] = "They were a Mad Bomber!"
L["search_role_" .. BOMBER.abbr] = "This person was a Mad Bomber!"
L["target_" .. BOMBER.name] = "Mad Bomber"
L["ttt2_desc_" .. BOMBER.name] = [[Mad Bomber blow themselves and their enemies up. If successful they'll come back to do it again!]]

L["bomber_reviving"] = "You have revived!"
L["bomber_reviving_worldspawn"] = "You will respawn at a map spawnpoint"

--EVENT STRINGS
L["title_bomber_revive"] = "A Mad Bomber respawned."
L["desc_bomber_revive"] = "Mad Bomber {bomber} is respawning after {death} deaths."
L["desc_bomber_revive_worldspawn"] = "Mad Bomber {bomber} is respawning after {death} deaths at worldspawn."

--SETTING STRINGS
L["ttt2_bomber_health"] = "Set Health for the Mad Bomber"
L["ttt2_bomber_worldspawn"] = "Set Mad Bomber to respawn at world spawn"
L["ttt2_bomber_need_corpse"] = "Require their body to respawn"
L["ttt2_bomber_respawn_delay"] = "Respawn delay"
L["ttt2_bomber_block_round"] = "Block round end while respawning"