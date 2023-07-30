ROLE.Base = "ttt_role_base"

ROLE.index = ROLE_TRAITOR

---
-- @ignore
function ROLE:PreInitialize()
	self.color = Color(209, 43, 39, 255)

	self.abbr = "traitor"

	self.builtin = true

	self.defaultTeam = TEAM_TRAITOR
	self.defaultEquipment = TRAITOR_EQUIPMENT
	self.score.surviveBonus = 0.25
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 5
	self.score.teamKillsMultiplier = -10
	self.score.bodyFoundMuliplier = 0
	self.fallbackTable = {}

	-- conVarData
	self.conVarData = {
		pct = 0.4,
		maximum = 32,
		minPlayers = 1,
		traitorButton = 1
	}
end
