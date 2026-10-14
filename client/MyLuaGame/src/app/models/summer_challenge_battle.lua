--
-- Copyright (c) 2014 YouMi Information Technology Inc.
-- Copyright (c) 2019 TianJi Information Technology Inc.
--
-- SummerChallengeBattle 夏日挑战战斗 九  零一起玩 www.9 0175.com
--

local GameBattleModel = require("app.models.battle")
local SummerChallengeBattle = class("SummerChallengeBattle", GameBattleModel)

SummerChallengeBattle.DefaultGateID = game.GATE_TYPE.summerChallenge
SummerChallengeBattle.MultipGroup = true

function SummerChallengeBattle:getData()
	local ret = GameBattleModel.getData(self)
	ret.gateID = self.gateID
	ret.monsterIDs = self.monsterIDs
	ret.actions = self.actions
	ret.choices = self.choices
	return ret
end

function SummerChallengeBattle:getPreDataForEnd(roleOut)
	return {}
end

return SummerChallengeBattle