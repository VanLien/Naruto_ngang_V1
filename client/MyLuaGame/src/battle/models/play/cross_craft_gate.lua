local var_0_0 = class("CrossCraftGateRecord", battlePlay.CraftGateRecord)

battlePlay.CrossCraftGateRecord = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}

function var_0_0.init(arg_1_0, arg_1_1)
	arg_1_0.isFinal = true

	battlePlay.Gate.init(arg_1_0, arg_1_1)

	arg_1_0.posByForce = {
		2,
		8
	}
	arg_1_0.score = 0
	arg_1_0.enemyScore = 0
	arg_1_0.firstRoleout = {
		{},
		{}
	}
	arg_1_0.backUp = {
		{},
		{}
	}
	arg_1_0.waveResultList = {}
	arg_1_0.loserRoleOut = {
		{},
		{}
	}
	arg_1_0.endAnimation = {
		aniName = "",
		res = "xianshipvp/jinjichang.skel"
	}
	arg_1_0.craftBuffAddTimes = {}
	arg_1_0.forceToObjId = {
		-1,
		-1
	}

	arg_1_0:playStartAni()
end

function var_0_0.makeEndViewInfos(arg_2_0)
	local var_2_0 = csv.cross.craft.base[1].damageScoreRatio
	local var_2_1 = 0
	local var_2_2 = 0
	local var_2_3 = arg_2_0.scene.extraRecord:getEvent(battle.ExRecordEvent.score)

	if var_2_3 then
		var_2_3[1] = var_2_3[1] or 0
		var_2_3[2] = var_2_3[2] or 0
		var_2_1 = math.floor(var_2_3[1] / var_2_0)
		var_2_2 = math.floor(var_2_3[2] / var_2_0)
	end

	arg_2_0.score = var_2_1
	arg_2_0.enemyScore = var_2_2

	return {
		result = arg_2_0.result,
		score = arg_2_0.score
	}
end
