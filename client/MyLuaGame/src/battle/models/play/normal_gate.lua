local var_0_0 = class("NormalGate", battlePlay.Gate)

battlePlay.NormalGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = false
}

function var_0_0.init(arg_1_0, arg_1_1)
	arg_1_0:initStarConditions()
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

function var_0_0.postEndResultToServer(arg_4_0, arg_4_1)
	local var_4_0 = gGameModel.capture:read("limit_sprites")
	local var_4_1 = arg_4_0:makeEndViewInfos({
		gateStar = true
	})

	gRootViewProxy:raw():postEndResultToServer("/game/end_gate", function(arg_5_0)
		arg_4_1(var_4_1, arg_5_0, var_4_0)
	end, arg_4_0.scene.battleID, arg_4_0.scene.sceneID, var_4_1.result, var_4_1.gateStar)
end
