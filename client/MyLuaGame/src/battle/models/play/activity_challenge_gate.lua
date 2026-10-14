local var_0_0 = class("ActivityChallengeGate", battlePlay.Gate)

battlePlay.ActivityChallengeGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	lockAuto = false,
	canSkip = false
}
var_0_0.CommonArgs = {
	AntiMode = battle.GateAntiMode.Operate
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.BothDead,
	battle.EndSpecialCheck.DirectWin
}

local var_0_1 = setmetatable({}, {
	__index = function()
		return function()
			return
		end
	end
})

local function var_0_2()
	return
end

local function var_0_3()
	return var_0_1
end

local function var_0_4(arg_5_0)
	return arg_5_0
end

local var_0_5 = {
	guideChoice = false,
	specInit = var_0_2
}
local var_0_6 = {
	[game.GATE_TYPE.summerChallenge] = {
		guideChoice = true,
		specInit = function(arg_6_0, arg_6_1)
			arg_6_0.roundLimit = csv.summer_challenge.gates[arg_6_1.gateID].roundLimit
		end,
		endData = {
			url = "/game/yy/summer_challenge/battle/end"
		}
	}
}

function var_0_0.init(arg_7_0, arg_7_1)
	arg_7_0.config = var_0_6[arg_7_0.scene.gateType] or {}

	for iter_7_0, iter_7_1 in pairs(var_0_5) do
		local var_7_0 = arg_7_0.config[iter_7_0]
		local var_7_1 = var_0_3

		if var_7_0 ~= nil then
			if var_0_5[iter_7_0] == var_0_2 then
				var_7_1 = var_7_0
			else
				var_7_1 = var_0_4
			end
		end

		arg_7_0[iter_7_0] = var_7_1
	end

	if arg_7_0:guideChoice():configCheck() then
		arg_7_0.sendSkills = {}
		arg_7_0.choices = {}
		arg_7_0.guideIndex = nil

		gRootViewProxy:proxy():setGuideClickCall(functools.handler(arg_7_0, arg_7_0.onGuideClickCall))
	end

	arg_7_0:specInit(arg_7_1)
	battlePlay.Gate.init(arg_7_0, arg_7_1)
end

function var_0_0.sendParams(arg_8_0)
	local var_8_0 = {
		arg_8_0.scene.battleID,
		arg_8_0.data.gateID,
		arg_8_0.result
	}

	if arg_8_0.CommonArgs.AntiMode == battle.GateAntiMode.Operate then
		table.insert(var_8_0, battlePlay.Gate.sendActionParams(arg_8_0))

		if arg_8_0:guideChoice():configCheck() then
			table.insert(var_8_0, arg_8_0.sendSkills)
			table.insert(var_8_0, arg_8_0.choices)
		end
	end

	return unpack(var_8_0)
end

function var_0_0.configCheck(arg_9_0)
	return true
end

function var_0_0.needExtraRound(arg_10_0)
	if arg_10_0.curRound > arg_10_0.roundLimit then
		return false
	end

	for iter_10_0, iter_10_1 in arg_10_0.scene:ipairsHeros() do
		if iter_10_1:isFakeDeath() then
			return true
		end
	end

	return false
end

function var_0_0.checkBattleEnd(arg_11_0)
	if arg_11_0:needExtraRound() then
		return false
	end

	return battlePlay.Gate.checkBattleEnd(arg_11_0)
end

function var_0_0.postEndResultToServer(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:makeEndViewInfos({
		gateStar = true
	})

	gRootViewProxy:raw():postEndResultToServer(arg_12_0.config.endData.url, function(arg_13_0)
		arg_12_1(var_12_0, arg_13_0)
	end, arg_12_0:sendParams())
end

function var_0_0.getEnemyRoleOutT(arg_14_0, arg_14_1)
	return arg_14_0.data.roleOut[2][arg_14_1]
end

function var_0_0.newWaveAddObjsStrategy(arg_15_0)
	if arg_15_0.curWave == 1 then
		arg_15_0:addCardRoles(1, nil, arg_15_0.data.roleOut[1][1])
		arg_15_0:addCardRoles(2, nil, arg_15_0:getEnemyRoleOutT(1))
		arg_15_0:doObjsAttrsCorrect(true, true)
	else
		arg_15_0:addCardRoles(2, nil, arg_15_0:getEnemyRoleOutT(arg_15_0.curWave))
		arg_15_0:doObjsAttrsCorrect(false, true)
	end

	battlePlay.Gate.newWaveAddObjsStrategy(arg_15_0)
end

function var_0_0.checkGuide(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0:guideChoice():configCheck() then
		arg_16_0.guideIndex = arg_16_2.round or arg_16_0.curRound
	end

	battlePlay.Gate.checkGuide(arg_16_0, arg_16_1, arg_16_2)
end

function var_0_0.getMonsterGuideCsv(arg_17_0, arg_17_1, arg_17_2)
	for iter_17_0, iter_17_1 in csvPairs(csv.summer_challenge.monsters) do
		if iter_17_1.gateID == arg_17_0.data.gateID and iter_17_1.sceneCount == arg_17_2 then
			return iter_17_1
		end
	end

	return battlePlay.Gate.getMonsterGuideCsv(arg_17_0, arg_17_1, arg_17_2)
end

function var_0_0.onGuideClickCall(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {}
	local var_18_1 = arg_18_0:guideChoice():configCheck()

	for iter_18_0, iter_18_1 in csvMapPairs(arg_18_2.skills) do
		var_18_0[iter_18_0] = 1

		if iter_18_1 > 1 and var_18_1 then
			arg_18_0.sendSkills[iter_18_0] = iter_18_1

			printDebug("add skill to sendSkills skillId: %s, num: %s", iter_18_0, iter_18_1)
		end
	end

	if var_18_1 and arg_18_0.CommonArgs.AntiMode == battle.GateAntiMode.Operate then
		printDebug("record choices index: %s, skills: %s", arg_18_0.guideIndex, dumps(var_18_0))

		if next(var_18_0) then
			table.set(arg_18_0.choices, arg_18_0.guideIndex, var_18_0)
		end
	end

	arg_18_0:guideChoice():applyChoices(var_18_0)
end

function var_0_0.applyChoices(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in arg_19_0.scene:ipairsHeros() do
		if not iter_19_1:isRealDeath() and iter_19_1.force == 1 then
			iter_19_1:onAddSkills(arg_19_1)
		end
	end
end

local var_0_7 = class("ActivityChallengeGateRecord", var_0_0)

battlePlay.ActivityChallengeGateRecord = var_0_7
var_0_7.CommonArgs = {
	AntiMode = battle.GateAntiMode.Normal
}
var_0_7.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = false
}

function var_0_7.init(arg_20_0, arg_20_1)
	battlePlay.ActivityChallengeGate.init(arg_20_0, arg_20_1)

	arg_20_0.actionRecv = arg_20_1.actions
	arg_20_0.choices = arg_20_1.choices or {}
end

function var_0_7.checkGuide(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0:guideChoice():configCheck() then
		local var_21_0 = table.get(arg_21_0.choices, arg_21_2.round or arg_21_0.curRound)

		if var_21_0 then
			arg_21_0:applyChoices(var_21_0)
		end
	end

	battlePlay.Gate.checkGuide(arg_21_0, arg_21_1, arg_21_2)
end

function var_0_7.getActionRecv(arg_22_0, ...)
	local var_22_0 = table.get(arg_22_0.actionRecv, ...)

	if var_22_0 == nil then
		return
	end

	if var_22_0[1] == 0 then
		return
	end

	return unpack(var_22_0)
end

function var_0_7.onceBattle(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0, var_23_1, var_23_2 = arg_23_0:getActionRecv(arg_23_0.curRound, arg_23_0.curBattleRound)

	if (var_23_2 or 0) ~= 0 then
		arg_23_0.scene.autoFight = false

		battlePlay.Gate.onceBattle(arg_23_0, var_23_1, var_23_2)

		arg_23_0.scene.autoFight = true

		if arg_23_0.waitInput then
			error("why input be wait in record")
		end

		return
	end

	battlePlay.Gate.onceBattle(arg_23_0, arg_23_1, arg_23_2)
end
