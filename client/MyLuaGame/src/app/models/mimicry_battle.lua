local GameBattleModel = require("app.models.battle")
local MimicryBattle = class("MimicryBattle", GameBattleModel)
MimicryBattle.DefaultGateID = game.GATE_TYPE.mimicry

MimicryBattle.getData = function(self)
	local ret = GameBattleModel.getData(self)
	ret.actions = self.actions
	ret.boss_hp_threshold = self.boss_hp_threshold
	ret.buff_ids = self.buff_ids
	ret.boss_id = self.boss_id
	ret.boss_limit_skills = self.boss_limit_skills

	return ret
end

MimicryBattle.getPreDataForEnd = function(self, roleOut)
	return {}
end

return MimicryBattle
