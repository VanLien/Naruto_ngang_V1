local var_0_0 = class("SimpleActivityGate", battlePlay.Gate)

battlePlay.SimpleActivityGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.DirectWin
}

function var_0_0.init(arg_1_0, arg_1_1)
	arg_1_0.gateStar = 3

	if arg_1_0.scene.gateType == game.GATE_TYPE.simpleActivity then
		arg_1_0.OperatorArgs = clone(var_0_0.OperatorArgs)
		arg_1_0.OperatorArgs.canSkip = false
	end

	battlePlay.Gate.init(arg_1_0, arg_1_1)
end

function var_0_0.createObjectModel(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0

	if arg_2_1 == 1 then
		var_2_0 = ObjectModel.new(arg_2_0.scene, arg_2_2)
	else
		var_2_0 = MonsterModel.new(arg_2_0.scene, arg_2_2)
	end

	return var_2_0
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	if arg_3_0.curWave == 1 then
		arg_3_0:addCardRoles(1)
		arg_3_0:addCardRoles(2, 1, arg_3_0:getEnemyRoleOutT(1))
		arg_3_0:doObjsAttrsCorrect(true, true)
	else
		arg_3_0:addCardRoles(2, arg_3_0.curWave, arg_3_0:getEnemyRoleOutT(arg_3_0.curWave))
		arg_3_0:doObjsAttrsCorrect(false, true)
	end

	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_0.doObjsAttrsCorrect(arg_4_0, arg_4_1, arg_4_2)
	battlePlay.Gate.doObjsAttrsCorrect(arg_4_0, arg_4_1, arg_4_2)

	if arg_4_0.scene.gateType == game.GATE_TYPE.fragment then
		local var_4_0 = {}

		for iter_4_0, iter_4_1 in arg_4_0.scene.enemyHeros:order_pairs() do
			var_4_0[iter_4_1.markID] = true
		end

		for iter_4_2, iter_4_3 in arg_4_0.scene.heros:order_pairs() do
			if var_4_0[iter_4_3.markID] then
				iter_4_3:setMP1(iter_4_3:mp1Max(), iter_4_3:mp1Max())
			end
		end
	end
end

function var_0_0.postEndResultToServer(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:makeEndViewInfos()

	gRootViewProxy:raw():postEndResultToServer("/game/huodong/end", function(arg_6_0)
		arg_5_1(var_5_0, arg_6_0)
	end, arg_5_0.scene.battleID, arg_5_0.scene.sceneID, arg_5_0.result, arg_5_0.gateStar, 0, 0)
end
