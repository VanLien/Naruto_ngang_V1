local var_0_0 = class("TestGate", battlePlay.Gate)

battlePlay.TestGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.AllHpRatioCheck
}

function var_0_0.ctor(arg_1_0, arg_1_1)
	battlePlay.Gate.ctor(arg_1_0, arg_1_1)
end

function var_0_0.init(arg_2_0, arg_2_1)
	arg_2_0:initStarConditions()

	arg_2_0.myDeadHpMaxSum = 0
	arg_2_0.enemyDeadHpMaxSum = 0

	battlePlay.Gate.init(arg_2_0, arg_2_1)
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:addCardRoles(1)
	arg_3_0:addCardRoles(2)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end
