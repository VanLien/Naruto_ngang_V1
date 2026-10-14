local var_0_0 = class("CrossMineGate", battlePlay.Gate)

battlePlay.CrossMineGate = var_0_0
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

	arg_1_0.waveResultList = {}
	arg_1_0.myDeadHpMaxSum = 0
	arg_1_0.enemyDeadHpMaxSum = 0
	arg_1_0.endAnimation = {
		aniName = "",
		res = "xianshipvp/jinjichang.skel"
	}

	gRootViewProxy:proxy():addSpecModule(battleModule.crossMineMods)
end

function var_0_0.newWaveAddObjsStrategy(arg_2_0)
	arg_2_0:addCardRoles(1, nil, arg_2_0.data.roleOut[1][arg_2_0.curWave], arg_2_0.data.roleOut2[1][arg_2_0.curWave], false)
	arg_2_0:addCardRoles(2, nil, arg_2_0.data.roleOut[2][arg_2_0.curWave], arg_2_0.data.roleOut2[2][arg_2_0.curWave], false)

	arg_2_0.myDeadHpMaxSum = 0
	arg_2_0.enemyDeadHpMaxSum = 0

	arg_2_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_2_0)

	if arg_2_0.curWave == 1 then
		battleEasy.deferNotifyCantClean(nil, "initPvp")
	end
end

function var_0_0.onNewWavePlayAni(arg_3_0)
	arg_3_0.isWaveEnd = false
	arg_3_0.curWaveResult = nil
	arg_3_0.curWave = arg_3_0.curWave + 1
	arg_3_0.curRound = 0
	arg_3_0.totalRoundBattleTurn = 0

	gRootViewProxy:notify("setTeamNumber", arg_3_0.curWave, 3)
	battleEasy.queueEffect("delay", {
		lifetime = 300
	})

	local var_3_0 = 0

	for iter_3_0, iter_3_1 in ipairs(arg_3_0.waveResultList) do
		var_3_0 = battleEasy.ifElse(iter_3_1 == 1, var_3_0 + 1, var_3_0)
	end

	local var_3_1 = #arg_3_0.waveResultList

	battleEasy.deferNotifyCantClean(nil, "changeWave", var_3_0, var_3_1, arg_3_0.waveResultList[var_3_1])
	gRootViewProxy:proxy():forceClearBuffEffects()
	arg_3_0.scene:waitNewWaveAniDone()
end

function var_0_0.checkWaveEnd(arg_4_0)
	if arg_4_0.curWaveResult then
		return true, arg_4_0.curWaveResult
	end

	local var_4_0 = arg_4_0:checkForceAllRealDead(1)

	if arg_4_0:checkForceAllRealDead(2) then
		return true, 1
	elseif var_4_0 then
		return true, 2
	end

	if arg_4_0.curRound >= arg_4_0.roundLimit and arg_4_0:checkRoundEnd() and not arg_4_0:needExtraRound() then
		return true, 2
	end

	return false
end

function var_0_0.onWaveEndSupply(arg_5_0)
	local var_5_0, var_5_1 = arg_5_0:checkWaveEnd()

	table.insert(arg_5_0.waveResultList, var_5_1)

	for iter_5_0, iter_5_1 in arg_5_0.scene:ipairsHeros() do
		iter_5_1:setDead(nil, nil, {
			force = true,
			noTrigger = true
		})
	end

	arg_5_0.isWaveEnd = true
end

function var_0_0.onBattleEndSupply(arg_6_0)
	local var_6_0 = arg_6_0.result

	if var_6_0 == "win" then
		arg_6_0.endAnimation.aniName = "effect_l"
	elseif var_6_0 == "fail" then
		arg_6_0.endAnimation.aniName = "effect_r"
	end
end

function var_0_0.needExtraRound(arg_7_0)
	if arg_7_0.curRound > arg_7_0.roundLimit then
		return false
	end

	for iter_7_0, iter_7_1 in arg_7_0.scene:ipairsHeros() do
		if iter_7_1:isFakeDeath() then
			return true
		end
	end

	return false
end

function var_0_0.checkBattleEnd(arg_8_0)
	local var_8_0, var_8_1 = arg_8_0:checkWaveEnd()

	if not var_8_0 then
		return false
	end

	local var_8_2 = 1

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.waveResultList) do
		var_8_2 = battleEasy.ifElse(iter_8_1 == var_8_1, var_8_2 + 1, var_8_2)
	end

	if var_8_2 > arg_8_0.waveCount - var_8_2 then
		local var_8_3 = battleEasy.ifElse(var_8_1 == 1, "win", "fail")

		return true, var_8_3
	end

	return false
end

function var_0_0.getGroup(arg_9_0)
	return 3
end

function var_0_0.makeEndViewInfos(arg_10_0)
	local var_10_0, var_10_1 = arg_10_0:whoHighestDamageFromStats(1, 3)

	var_10_1 = var_10_1 or next(arg_10_0.data.roleOut[1][1])

	if not arg_10_0.data.roleOut[1][var_10_0][var_10_1] then
		var_10_0 = 1
		var_10_1 = next(arg_10_0.data.roleOut[1][1])
	end

	return {
		result = arg_10_0.result,
		mvpCardIn = var_10_0,
		mvpPosId = var_10_1,
		waveResult = arg_10_0.waveResultList
	}
end

function var_0_0.getHpRatio(arg_11_0, arg_11_1)
	local var_11_0 = 0
	local var_11_1 = arg_11_1 == 1 and arg_11_0.myDeadHpMaxSum or arg_11_0.enemyDeadHpMaxSum

	for iter_11_0 = (arg_11_1 - 1) * 6 + 1, 6 * arg_11_1 do
		local var_11_2 = arg_11_0.scene:getObjectBySeat(iter_11_0)

		if var_11_2 and arg_11_0:checkObjCanToServer(var_11_2) then
			var_11_0 = var_11_0 + var_11_2:hp()
			var_11_1 = var_11_1 + var_11_2:hpMax()
		end
	end

	return var_11_0 / var_11_1
end

function var_0_0.postEndResultToServer(arg_12_0, arg_12_1)
	if arg_12_0.hasPost then
		return
	end

	arg_12_0.hasPost = true

	local var_12_0 = arg_12_0:makeEndViewInfos()
	local var_12_1 = {}

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.waveResultList) do
		table.insert(var_12_1, iter_12_1 == 1 and "win" or "fail")
	end

	table.insert(var_12_1, var_12_0.result)

	local var_12_2 = csv.cross.mine.base[1]
	local var_12_3 = false
	local var_12_4 = var_12_0.result == "win" and arg_12_0:getHpRatio(1) or arg_12_0:getHpRatio(2)

	if var_12_2 and var_12_2.topBattleRound <= arg_12_0.curRound and var_12_4 <= var_12_2.topBattleLastHP then
		var_12_3 = true
	end

	gRootViewProxy:raw():postEndResultToServer("/game/cross/mine/battle/end", function(arg_13_0)
		arg_12_1(var_12_0, arg_13_0)
	end, var_12_0.result, var_12_1, var_12_3)
end

function var_0_0.recordDamageStats(arg_14_0)
	for iter_14_0, iter_14_1 in arg_14_0.scene:ipairsHeros() do
		if arg_14_0:checkObjCanCalcDamage(iter_14_1) then
			local var_14_0 = 0

			for iter_14_2, iter_14_3 in pairs(iter_14_1.totalDamage) do
				var_14_0 = var_14_0 + iter_14_3:get(battle.ValueType.normal)
			end

			local var_14_1 = iter_14_1.force
			local var_14_2 = iter_14_1.id
			local var_14_3 = {
				posId = iter_14_1.seat,
				damageVal = var_14_0
			}

			arg_14_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.unitsDamage, var_14_3, var_14_1, arg_14_0.curWave, var_14_2)
		end
	end
end

function var_0_0.recordCampDamageStats(arg_15_0)
	return
end

function var_0_0.onPassOneWave(arg_16_0, arg_16_1)
	if arg_16_0.passOneWaveCallBack then
		return
	end

	for iter_16_0, iter_16_1 in arg_16_0.scene:ipairsHeros() do
		if not iter_16_1:isAlreadyDead() then
			iter_16_1.view:proxy():onPassOneWaveClean()
		end
	end

	gRootViewProxy:proxy():onPassOneWaveClean()
	gRootViewProxy:notify("updateLinkEffect", false)

	arg_16_0.passOneWaveCallBack = arg_16_1

	arg_16_0.scene:waitJumpOneWave()
end

function var_0_0.onWaveEffectClean(arg_17_0)
	if arg_17_0.passOneWaveCallBack then
		arg_17_0.passOneWaveCallBack()

		arg_17_0.passOneWaveCallBack = nil
	end

	arg_17_0.scene.forceRecordObject = {}

	gRootViewProxy:notify("sceneClearAll")
end

local var_0_1 = class("CrossMineGateRecord", battlePlay.CrossMineGate)

battlePlay.CrossMineGateRecord = var_0_1
var_0_1.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}
