L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[HEADTAKER.name] = "Headtaker"
L[HEADTAKER.defaultTeam] = "Team Headtaker"
L["hilite_win_" .. HEADTAKER.defaultTeam] = "TEAM HEADTAKER WON"
L["win_" .. HEADTAKER.defaultTeam] = "The Headtaker has won!"
L["info_popup_" .. HEADTAKER.name] = [[You are the Headtaker! Try to kill everyone else! You can only use your axe to damage others.]]
L["body_found_" .. HEADTAKER.abbr] = "They were a Headtaker!"
L["search_role_" .. HEADTAKER.abbr] = "This person was a Headtaker!"
L["ev_win_" .. HEADTAKER.defaultTeam] = "The evil Headtaker won the round!"
L["target_" .. HEADTAKER.name] = "Headtaker"
L["ttt2_desc_" .. HEADTAKER.name] = [[The Headtaker needs to win by killing everyone else with their axe!]]
L["credit_" .. HEADTAKER.abbr .. "_all"] = "Headtakers, you have been awarded {num} equipment credit(s) for your performance."

-- teleport stuff

L["ttt2_headtaker_close"] = "You are too close to an object to teleport!"
L["ttt2_headtaker_crouch"] = "Cannot teleport while crouching!"
L["ttt2_headtaker_deny"] = "Cannot teleport to that location!"
L["ttt2_headtaker_player"] = "You cannot teleport to another player!"
L["ttt2_headtaker_require_player"] = "You must be looking at a player!"
L["ttt2_headtaker_crouch_switch"] = "Cannot switch positions with a crouching player!"
L["ttt2_headtaker_crouch_air"] = "Cannot switch positions with a crouching player!"


