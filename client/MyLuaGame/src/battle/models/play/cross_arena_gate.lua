local var_0_0 = class("CrossArenaGate", battlePlay.ArenaGate)

battlePlay.CrossArenaGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.AllHpRatioCheck,
	battle.EndSpecialCheck.FightPoint,
	battle.EndSpecialCheck.CumulativeSpeedSum
}

function var_0_0.init(arg_1_0, arg_1_1)
	battlePlay.Gate.init(arg_1_0, arg_1_1)

	arg_1_0.waveResultList = {}
	arg_1_0.endAnimation = {
		aniName = "",
		res = "xianshipvp/jinjichang.skel"
	}
	arg_1_0.craftBuffAddTimes = {}

	arg_1_0:playStartAni()
end

function var_0_0.playStartAni(arg_2_0)
	return
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	if arg_3_0.curWave == 1 then
		arg_3_0:addCardRoles(1, nil, arg_3_0.data.roleOut[1][1], arg_3_0.data.roleOut2[1][1], true)
		arg_3_0:addCardRoles(2, nil, arg_3_0.data.roleOut[2][1], arg_3_0.data.roleOut2[2][1], true)
		arg_3_0:doObjsAttrsCorrect(true, true)
	elseif arg_3_0.waveResultList[arg_3_0.curWave - 1] == 3 then
		arg_3_0:addCardRoles(1, nil, arg_3_0.data.roleOut[1][2], arg_3_0.data.roleOut2[1][2], false)
		arg_3_0:addCardRoles(2, nil, arg_3_0.data.roleOut[2][2], arg_3_0.data.roleOut2[2][2], false)
		arg_3_0:doObjsAttrsCorrect(true, true)
	else
		local var_3_0 = arg_3_0.waveResultList[arg_3_0.curWave - 1]

		arg_3_0:addCardRoles(var_3_0, nil, arg_3_0.data.roleOut[var_3_0][2], arg_3_0.data.roleOut2[var_3_0][2], false)

		if var_3_0 == 1 then
			arg_3_0:doObjsAttrsCorrect(true, false)
		else
			arg_3_0:doObjsAttrsCorrect(false, true)
		end
	end

	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)

	arg_3_0.mayBeMeWin = arg_3_0.myFightPointSum > arg_3_0.enemyFightPointSum and "win" or "fail"

	if arg_3_0.myFightPointSum == arg_3_0.enemyFightPointSum then
		arg_3_0.mayBeMeWin = arg_3_0.mySpeedSum > arg_3_0.enemySpeedSum and "win" or "fail"
	end
end

function var_0_0.addCardRoles(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	battlePlay.Gate.addCardRoles(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)

	if arg_4_1 == 1 then
		arg_4_0.myHpSum, arg_4_0.myHpMaxSum, arg_4_0.myFightPointSum, arg_4_0.mySpeedSum = arg_4_0:getSumInfo(arg_4_1)
		arg_4_0.myDeadHpMaxSum = 0
	else
		arg_4_0.enemyHpSum, arg_4_0.enemyHpMaxSum, arg_4_0.enemyFightPointSum, arg_4_0.enemySpeedSum = arg_4_0:getSumInfo(arg_4_1)
		arg_4_0.enemyDeadHpMaxSum = 0
	end
end

function var_0_0.checkBattleEnd(arg_5_0)
	if arg_5_0.curWave == 2 then
		if arg_5_0:checkBothAllRealDead() then
			local var_5_0

			if arg_5_0.waveResultList[1] == 3 then
				var_5_0 = arg_5_0.mayBeMeWin
			elseif arg_5_0.waveResultList[1] == 1 then
				var_5_0 = "fail"
			elseif arg_5_0.waveResultList[1] == 2 then
				var_5_0 = "win"
			end

			return true, var_5_0
		end

		if arg_5_0.waveResultList[1] ~= 2 and arg_5_0:checkForceAllRealDead(1) then
			return true, "fail"
		end

		if arg_5_0.waveResultList[1] ~= 1 and arg_5_0:checkForceAllRealDead(2) then
			return true, "win"
		end

		if arg_5_0.curRound >= arg_5_0.roundLimit and arg_5_0:checkRoundEnd() and not arg_5_0:needExtraRound() then
			local var_5_1, var_5_2 = battlePlay.Gate.checkBattleEnd(arg_5_0)

			if var_5_2 == "win" and arg_5_0.waveResultList[1] ~= 1 then
				return true, "win"
			elseif var_5_2 == "fail" and arg_5_0.waveResultList[1] ~= 2 then
				return true, "fail"
			end
		end
	end

	if arg_5_0.curWave == 3 then
		if arg_5_0:checkBothAllRealDead() then
			return true, arg_5_0.mayBeMeWin
		end

		if arg_5_0:checkForceAllRealDead(1) then
			return true, "fail"
		end

		if arg_5_0:checkForceAllRealDead(2) then
			return true, "win"
		end

		if arg_5_0.curRound >= arg_5_0.roundLimit and arg_5_0:checkRoundEnd() and not arg_5_0:needExtraRound() then
			return battlePlay.Gate.checkBattleEnd(arg_5_0)
		end
	end

	return false
end

function var_0_0.getSumInfo(arg_6_0, arg_6_1)
	local var_6_0 = 0
	local var_6_1 = 0
	local var_6_2 = 0
	local var_6_3 = 0

	for iter_6_0 = (arg_6_1 - 1) * 6 + 1, 6 * arg_6_1 do
		local var_6_4 = arg_6_0.scene:getObjectBySeat(iter_6_0)

		if var_6_4 and arg_6_0:checkObjCanToServer(var_6_4) then
			var_6_0 = var_6_0 + var_6_4:hp()
			var_6_1 = var_6_1 + var_6_4:hpMax()
			var_6_2 = var_6_2 + var_6_4.fightPoint
			var_6_3 = var_6_3 + var_6_4:speed()
		end
	end

	return var_6_0, var_6_1, var_6_2, var_6_3
end

function var_0_0.checkWaveEnd(arg_7_0)
	local var_7_0 = arg_7_0:checkForceAllRealDead(1)
	local var_7_1 = arg_7_0:checkForceAllRealDead(2)

	if var_7_0 and var_7_1 then
		return true, 3
	elseif var_7_0 then
		return true, 1
	elseif var_7_1 then
		return true, 2
	end

	if arg_7_0.curRound >= arg_7_0.roundLimit and arg_7_0:checkRoundEnd() and not arg_7_0:needExtraRound() then
		local var_7_2, var_7_3 = arg_7_0:specialEndCheck()

		return true, var_7_3
	end

	return false
end

function var_0_0.onWaveEndSupply(arg_8_0)
	if arg_8_0.waveResultList == nil then
		arg_8_0.waveResultList = {}
		arg_8_0.endAnimation = {
			aniName = "",
			res = "xianshipvp/jinjichang.skel"
		}
	end

	local var_8_0, var_8_1 = arg_8_0:checkWaveEnd()
	local var_8_2

	if var_8_1 == "win" then
		var_8_1 = 2
		var_8_2 = arg_8_0.scene:getHerosMap(2)
	elseif var_8_1 == "fail" then
		var_8_1 = 1
		var_8_2 = arg_8_0.scene:getHerosMap(1)
	end

	if var_8_2 then
		for iter_8_0, iter_8_1 in var_8_2:order_pairs() do
			iter_8_1:setDead(nil, nil, {
				force = true,
				noTrigger = true
			})
		end
	end

	table.insert(arg_8_0.waveResultList, var_8_1)
end

function var_0_0.onBattleEndSupply(arg_9_0)
	local var_9_0, var_9_1 = arg_9_0:checkBattleEnd()

	if var_9_1 == "win" then
		arg_9_0.endAnimation.aniName = "effect_l"
	elseif var_9_1 == "fail" then
		arg_9_0.endAnimation.aniName = "effect_r"
	end
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

function var_0_0.recordDamageStats(arg_11_0)
	for iter_11_0, iter_11_1 in arg_11_0.scene:ipairsHeros() do
		if arg_11_0:checkObjCanCalcDamage(iter_11_1) then
			local var_11_0 = 0

			for iter_11_2, iter_11_3 in pairs(iter_11_1.totalDamage) do
				var_11_0 = var_11_0 + iter_11_3:get(battle.ValueType.normal)
			end

			local var_11_1 = iter_11_1.force
			local var_11_2 = iter_11_1.id
			local var_11_3 = 1

			if arg_11_0.curWave == 1 then
				var_11_3 = 1
			elseif arg_11_0.curWave == 2 then
				if var_11_1 == 1 and arg_11_0.waveResultList[1] ~= 2 then
					var_11_3 = 2
				elseif var_11_1 == 2 and arg_11_0.waveResultList[1] ~= 1 then
					var_11_3 = 2
				else
					var_11_3 = 1
				end
			elseif arg_11_0.curWave == 3 then
				var_11_3 = 2
			end

			local var_11_4 = {
				posId = iter_11_1.seat,
				damageVal = var_11_0
			}

			arg_11_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.unitsDamage, var_11_4, var_11_1, var_11_3, var_11_2)
		end
	end
end

function var_0_0.recordCampDamageStats(arg_12_0)
	return
end

function var_0_0.getHpRation(arg_13_0)
	local var_13_0 = 0
	local var_13_1, var_13_2 = arg_13_0:getSumInfo(1)
	local var_13_3 = var_13_1 / (var_13_2 + arg_13_0.myDeadHpMaxSum)
	local var_13_4 = 0
	local var_13_5, var_13_6 = arg_13_0:getSumInfo(2)
	local var_13_7 = var_13_5 / (var_13_6 + arg_13_0.enemyDeadHpMaxSum)

	return var_13_3, var_13_7
end

function var_0_0.getGroup(arg_14_0)
	return 2
end

function var_0_0.makeEndViewInfos(arg_15_0)
	local var_15_0, var_15_1 = arg_15_0:getHpRation()
	local var_15_2 = arg_15_0:getTotalRounds()
	local var_15_3 = false

	if var_15_2 > 4 and (arg_15_0.result == "win" and var_15_0 < 0.5 or arg_15_0.result == "fail" and var_15_1 < 0.5) then
		var_15_3 = true
	end

	local var_15_4, var_15_5 = arg_15_0:whoHighestDamageFromStats(1, 2)

	return {
		result = arg_15_0.result,
		mvpCardIn = var_15_4,
		mvpPosId = var_15_5,
		isTopBattle = var_15_3
	}
end

function var_0_0.postEndResultToServer(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:makeEndViewInfos()
	local var_16_1 = arg_16_0.scene.data

	gRootViewProxy:raw():postEndResultToServer("/game/cross/arena/battle/end", function(arg_17_0)
		arg_16_1(var_16_0, arg_17_0)
	end, var_16_1.preData.rightRank, var_16_0.result, var_16_0.isTopBattle)
end

function var_0_0.onNewWavePlayAni(arg_18_0)
	arg_18_0.curWave = arg_18_0.curWave + 1
	arg_18_0.curRound = 0
	arg_18_0.totalRoundBattleTurn = 0

	local var_18_0
	local var_18_1 = arg_18_0.curWave == 1 and 0 or arg_18_0.waveResultList[arg_18_0.curWave - 1]

	gRootViewProxy:notify("setTeamNumber", arg_18_0.curWave, var_18_1)
	battleEasy.queueEffect("delay", {
		lifetime = 300
	})
	arg_18_0.scene:waitNewWaveAniDone()
end

function var_0_0.doObjsAttrsCorrect(arg_19_0, arg_19_1, arg_19_2)
	battlePlay.Gate.doObjsAttrsCorrect(arg_19_0, arg_19_1, arg_19_2)

	local var_19_0 = {}
	local var_19_1 = csv.cross.arena.cross_arena_battle_fix

	for iter_19_0, iter_19_1 in ipairs(var_19_1) do
		var_19_0[iter_19_1.attrType .. "C"] = iter_19_1.attrFix
	end

	if arg_19_1 then
		for iter_19_2 = 1, 6 do
			local var_19_2 = arg_19_0.scene:getObjectBySeat(iter_19_2)

			if var_19_2 then
				var_19_2:objAttrsCorrect(var_19_0)
			end
		end
	end

	if arg_19_2 then
		for iter_19_3 = 7, 12 do
			local var_19_3 = arg_19_0.scene:getObjectBySeat(iter_19_3)

			if var_19_3 then
				var_19_3:objAttrsCorrect(var_19_0)
			end
		end
	end
end

local var_0_1 = class("CrossArenaGateRecord", var_0_0)

battlePlay.CrossArenaGateRecord = var_0_1
var_0_1.OperatorArgs = {
	canSkipInstant = true,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canHandle = false,
	canPause = true,
	canSkip = true
}

function var_0_1.init(arg_20_0, arg_20_1)
	arg_20_0.craftBuffAddTimes = {}

	battlePlay.Gate.init(arg_20_0, arg_20_1)
end
