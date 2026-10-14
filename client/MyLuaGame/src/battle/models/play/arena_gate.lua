local var_0_0 = class("ArenaGate", battlePlay.Gate)

battlePlay.ArenaGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}

function var_0_0.init(arg_1_0, arg_1_1)
	battlePlay.Gate.init(arg_1_0, arg_1_1)
	arg_1_0:playStartAni()
end

function var_0_0.playStartAni(arg_2_0)
	gRootViewProxy:notify("showVsPvpView", 1)
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:addCardRoles(1)
	arg_3_0:addCardRoles(2)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_0.makeEndViewInfos(arg_4_0)
	local var_4_0, var_4_1 = arg_4_0:whoHighestDamageFromStats(1)

	return {
		result = arg_4_0.result,
		mvpPosId = var_4_1
	}
end

function var_0_0.postEndResultToServer(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:makeEndViewInfos()
	local var_5_1 = arg_5_0.scene.data

	gRootViewProxy:raw():postEndResultToServer("/game/pw/battle/end", function(arg_6_0)
		arg_5_1(var_5_0, arg_6_0)
	end, var_5_1.preData.rightRank, var_5_0.result)
end

local var_0_1 = class("ArenaGateRecord", var_0_0)

battlePlay.ArenaGateRecord = var_0_1
var_0_1.OperatorArgs = {
	canSkipInstant = true,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canHandle = false,
	canPause = true,
	canSkip = true
}

function var_0_1.init(arg_7_0, arg_7_1)
	battlePlay.Gate.init(arg_7_0, arg_7_1)
end
