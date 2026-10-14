local var_0_0 = class("ActivityBossGate", battlePlay.Gate)

battlePlay.ActivityBossGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = false
}

function var_0_0.createObjectModel(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 == 1 then
		return ObjectModel.new(arg_1_0.scene, arg_1_2)
	else
		if arg_1_2 == 11 then
			return BossModel.new(arg_1_0.scene, arg_1_2)
		end

		return MonsterModel.new(arg_1_0.scene, arg_1_2)
	end
end

function var_0_0.newWaveAddObjsStrategy(arg_2_0)
	arg_2_0:addCardRoles(1)
	arg_2_0:addCardRoles(2, 1, arg_2_0:getEnemyRoleOutT(1))
	arg_2_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_2_0)
end

function var_0_0.makeEndViewInfos(arg_3_0)
	local var_3_0 = (arg_3_0.scene.extraRecord:getEvent(battle.ExRecordEvent.campDamage) or {})[1] or 0

	return {
		result = arg_3_0.result,
		damage = var_3_0
	}
end

function var_0_0.postEndResultToServer(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0:makeEndViewInfos()

	gRootViewProxy:raw():postEndResultToServer("/game/yy/huodongboss/battle/end", {
		cb = function(arg_5_0)
			var_4_0.drop = arg_5_0.view.drop

			arg_4_1(var_4_0, arg_5_0)
		end
	}, arg_4_0.scene.battleID, var_4_0.result, arg_4_0.scene.data.activityID, arg_4_0.scene.data.idx, var_4_0.damage)
end
