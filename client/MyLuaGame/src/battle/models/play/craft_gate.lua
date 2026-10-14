local var_0_0 = class("CraftGateRecord", battlePlay.Gate)

battlePlay.CraftGateRecord = var_0_0
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}
var_0_0.SpecEndRuleCheck1 = {
	battle.EndSpecialCheck.SoloSpecialRule,
	battle.EndSpecialCheck.LastWaveTotalDamage
}
var_0_0.SpecEndRuleCheck2 = {
	battle.EndSpecialCheck.SoloSpecialRule,
	battle.EndSpecialCheck.HpRatioCheck,
	battle.EndSpecialCheck.FightPoint,
	battle.EndSpecialCheck.CumulativeSpeedSum
}

local function var_0_1(arg_1_0)
	local var_1_0 = 0

	for iter_1_0, iter_1_1 in pairs(battle.DamageFrom) do
		var_1_0 = var_1_0 + (arg_1_0.totalDamage[iter_1_1] and arg_1_0.totalDamage[iter_1_1]:get(1) or 0)
	end

	return var_1_0
end

var_0_0.UIOpition = {
	craftMods = true
}

function var_0_0.init(arg_2_0, arg_2_1)
	arg_2_0.isFinal = arg_2_1.isFinal

	battlePlay.Gate.init(arg_2_0, arg_2_1)

	arg_2_0.posByForce = {
		2,
		8
	}
	arg_2_0.score = 0
	arg_2_0.enemyScore = 0
	arg_2_0.firstRoleout = {
		{},
		{}
	}

	if arg_2_0.isFinal then
		arg_2_0.backUp = {
			{},
			{}
		}
		arg_2_0.waveResultList = {}
		arg_2_0.loserRoleOut = {
			{},
			{}
		}
	else
		arg_2_0.waveCount = 1
	end

	arg_2_0.endAnimation = {
		aniName = "",
		res = "xianshipvp/jinjichang.skel"
	}
	arg_2_0.craftBuffAddTimes = {}
	arg_2_0.forceToObjId = {
		-1,
		-1
	}

	arg_2_0:playStartAni()
end

function var_0_0.playStartAni(arg_3_0)
	if arg_3_0.isFinal then
		gRootViewProxy:notify("showVsPvpView", 3)
	else
		gRootViewProxy:notify("showVsPvpView", 2)
	end
end

function var_0_0.newWaveAddObjsStrategy(arg_4_0)
	arg_4_0:addCardRoles(1, nil, nil, nil, true)
	arg_4_0:addCardRoles(2, nil, nil, nil, true)
	arg_4_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_4_0)
end

function var_0_0.addCardRoles(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.scene:getHerosMap(arg_5_1)

	for iter_5_0, iter_5_1 in var_5_0:order_pairs() do
		if not arg_5_5 or iter_5_1:isRealDeath() then
			arg_5_0.scene:onObjDel(iter_5_1)
		end
	end

	if not arg_5_5 then
		var_5_0:clear()
	end

	arg_5_0.scene.herosOrder = nil

	if arg_5_0.curWave == 1 then
		local var_5_1 = arg_5_3 or arg_5_0.data.roleOut
		local var_5_2 = arg_5_2 and var_5_1[arg_5_2] or var_5_1
		local var_5_3 = arg_5_4 or arg_5_0.data.roleOut2
		local var_5_4 = arg_5_2 and var_5_3[arg_5_2] or var_5_3
		local var_5_5 = arg_5_1 == 1 and 0 or arg_5_0.ForceNumber
		local var_5_6 = 0

		for iter_5_2 = 1 + var_5_5, arg_5_0.ForceNumber + var_5_5 do
			local var_5_7 = var_5_2[iter_5_2]
			local var_5_8 = arg_5_0.posByForce[arg_5_1]

			if var_5_7 and not arg_5_0.scene:getObjectBySeat(var_5_8) then
				var_5_6 = var_5_6 + 1

				local var_5_9 = arg_5_0:createObjectModel(arg_5_1, var_5_8)

				if var_5_4 and next(var_5_4) then
					var_5_7.role2Data = var_5_4[iter_5_2]
				end

				var_5_9:init(var_5_7)
				var_5_0:insert(var_5_9.id, var_5_9)

				arg_5_0.forceToObjId[arg_5_1] = var_5_9.id
				arg_5_0.firstRoleout[arg_5_1] = var_5_7
			elseif var_5_7 and arg_5_0.scene:getObjectBySeat(var_5_8) then
				if var_5_4 and next(var_5_4) then
					var_5_7.role2Data = var_5_4[iter_5_2]
				end

				table.insert(arg_5_0.backUp[arg_5_1], var_5_7)
			end
		end

		if arg_5_1 == 1 and (not arg_5_2 or arg_5_2 == 1) then
			arg_5_0.scene.forceRecordTb[1].herosStartCount = var_5_6
		end

		table.insert(arg_5_0.forceAdd, arg_5_1)
	elseif arg_5_1 ~= arg_5_0.waveResultList[arg_5_0.curWave - 1] then
		local var_5_10 = arg_5_0.backUp[arg_5_1][1]

		if not next(var_5_10) then
			return
		end

		local var_5_11 = arg_5_0.posByForce[arg_5_1]
		local var_5_12 = arg_5_0:createObjectModel(arg_5_1, var_5_11)

		var_5_12:init(var_5_10)
		var_5_0:insert(var_5_12.id, var_5_12)

		arg_5_0.forceToObjId[arg_5_1] = var_5_12.id

		if arg_5_0.backUp[arg_5_1][2] then
			table.insert(arg_5_0.loserRoleOut[arg_5_1], arg_5_0.firstRoleout[arg_5_1])

			arg_5_0.firstRoleout[arg_5_1] = arg_5_0.backUp[arg_5_1][1]
			arg_5_0.backUp[arg_5_1][1] = arg_5_0.backUp[arg_5_1][2]
			arg_5_0.backUp[arg_5_1][2] = {}
		else
			table.insert(arg_5_0.loserRoleOut[arg_5_1], arg_5_0.firstRoleout[arg_5_1])

			arg_5_0.firstRoleout[arg_5_1] = arg_5_0.backUp[arg_5_1][1]
			arg_5_0.backUp[arg_5_1][1] = {}
		end

		table.insert(arg_5_0.forceAdd, arg_5_1)
		battleEasy.deferNotify(nil, "changeWave", arg_5_0.waveResultList[arg_5_0.curWave - 1])
	end

	arg_5_0.scene:createGroupObj(arg_5_1, battle.SpecialObjectId.teamShiled)
end

function var_0_0.checkBattleEnd(arg_6_0)
	local var_6_0 = not arg_6_0.isFinal or not next(arg_6_0.backUp[1][1])
	local var_6_1 = not arg_6_0.isFinal or not next(arg_6_0.backUp[2][1])

	if arg_6_0:checkBothAllRealDead() then
		if var_6_0 and var_6_1 and table.length(arg_6_0.scene.realDeathRecordTb) > 0 then
			return arg_6_0:bothRealDeadSpecCheck()
		elseif var_6_0 then
			return true, "fail"
		elseif var_6_1 then
			return true, "win"
		end
	end

	if arg_6_0:checkForceAllRealDead(1) and var_6_0 then
		return true, "fail"
	end

	if arg_6_0:checkForceAllRealDead(2) and var_6_1 then
		return true, "win"
	end

	if arg_6_0.curRound >= arg_6_0.roundLimit and arg_6_0:checkRoundEnd() and not arg_6_0:needExtraRound() then
		arg_6_0:hpChecker()

		local var_6_2, var_6_3 = battlePlay.Gate.checkBattleEnd(arg_6_0)

		if var_6_3 == "win" and var_6_1 or var_6_3 == "fail" and var_6_0 then
			return var_6_2, var_6_3
		end
	end

	return false
end

function var_0_0.hpChecker(arg_7_0)
	local var_7_0 = arg_7_0.scene:getObject(arg_7_0.forceToObjId[1])
	local var_7_1 = 0

	if var_7_0 then
		var_7_1 = var_7_0:hp() / var_7_0:hpMax()
	end

	local var_7_2 = arg_7_0.scene:getObject(arg_7_0.forceToObjId[2])
	local var_7_3 = 0

	if var_7_2 then
		var_7_3 = var_7_2:hp() / var_7_2:hpMax()
	end

	local var_7_4 = gCommonConfigCsv.craftHpRatioBorder or 1

	if var_7_1 - var_7_4 > 1e-06 and var_7_3 - var_7_4 > 1e-06 then
		arg_7_0.SpecEndRuleCheck = arg_7_0.SpecEndRuleCheck1

		return
	end

	arg_7_0.SpecEndRuleCheck = arg_7_0.SpecEndRuleCheck2
end

function var_0_0.onBattleEndSupply(arg_8_0)
	local var_8_0 = arg_8_0.result

	if var_8_0 == "win" then
		arg_8_0.endAnimation.aniName = "effect_l"
	elseif var_8_0 == "fail" then
		arg_8_0.endAnimation.aniName = "effect_r"
	end
end

function var_0_0.checkWaveEnd(arg_9_0)
	local var_9_0 = arg_9_0:checkForceAllRealDead(1)
	local var_9_1 = arg_9_0:checkForceAllRealDead(2)

	if var_9_0 and var_9_1 then
		return true, 3
	elseif var_9_0 then
		return true, 2
	elseif var_9_1 then
		return true, 1
	end

	if arg_9_0.curRound >= arg_9_0.roundLimit and arg_9_0:checkRoundEnd() and not arg_9_0:needExtraRound() then
		arg_9_0:hpChecker()

		local var_9_2, var_9_3 = arg_9_0:specialEndCheck()

		return true, var_9_3
	end

	return false
end

function var_0_0.onWaveEndSupply(arg_10_0)
	local var_10_0, var_10_1 = arg_10_0:checkWaveEnd()

	if var_10_1 == "win" then
		var_10_1 = 1
	elseif var_10_1 == "fail" then
		var_10_1 = 2
	end

	local var_10_2 = arg_10_0.scene:getObject(arg_10_0.forceToObjId[1])
	local var_10_3 = arg_10_0.scene:getObject(arg_10_0.forceToObjId[2])
	local var_10_4

	if var_10_1 == 1 then
		var_10_4 = arg_10_0.scene:getHerosMap(2)
	elseif var_10_1 == 2 then
		var_10_4 = arg_10_0.scene:getHerosMap(1)
	end

	if var_10_4 then
		for iter_10_0, iter_10_1 in var_10_4:order_pairs() do
			iter_10_1:setDead(nil, nil, {
				force = true,
				noTrigger = true
			})
		end
	end

	if arg_10_0.isFinal then
		table.insert(arg_10_0.waveResultList, var_10_1)

		if var_10_2 then
			var_10_2.lastWaveTotalDamage = var_0_1(var_10_2)
		end

		if var_10_3 then
			var_10_3.lastWaveTotalDamage = var_0_1(var_10_3)
		end
	end
end

function var_0_0.needExtraRound(arg_11_0)
	local var_11_0 = arg_11_0.scene:getObject(arg_11_0.forceToObjId[1])
	local var_11_1 = arg_11_0.scene:getObject(arg_11_0.forceToObjId[2])

	if var_11_0 and var_11_0:isFakeDeath() or var_11_1 and var_11_1:isFakeDeath() then
		return true
	end

	return false
end

function var_0_0.recordScoreStats(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 and arg_12_0:checkObjCanCalcDamage(arg_12_1) then
		local var_12_0 = arg_12_1.force

		arg_12_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.score, arg_12_2, var_12_0)
	end
end

function var_0_0.recordDamageStats(arg_13_0)
	for iter_13_0, iter_13_1 in arg_13_0.scene:ipairsHeros() do
		if arg_13_0:checkObjCanCalcDamage(iter_13_1) then
			local var_13_0 = 0

			for iter_13_2, iter_13_3 in pairs(iter_13_1.totalDamage) do
				var_13_0 = var_13_0 + iter_13_3:get(battle.ValueType.normal)
			end

			local var_13_1 = iter_13_1.force
			local var_13_2 = iter_13_1.id
			local var_13_3 = {
				posId = iter_13_1.seat,
				damageVal = var_13_0
			}

			arg_13_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.unitsDamage, var_13_3, var_13_1, var_13_2)
		end
	end
end

function var_0_0.makeEndViewInfos(arg_14_0)
	local var_14_0 = csv.craft.base[1].damageScoreRatio
	local var_14_1 = 0
	local var_14_2 = 0
	local var_14_3 = arg_14_0.scene.extraRecord:getEvent(battle.ExRecordEvent.score)

	if var_14_3 then
		var_14_3[1] = var_14_3[1] or 0
		var_14_3[2] = var_14_3[2] or 0
		var_14_1 = math.floor(var_14_3[1] / var_14_0)
		var_14_2 = math.floor(var_14_3[2] / var_14_0)
	end

	arg_14_0.score = var_14_1
	arg_14_0.enemyScore = var_14_2

	return {
		result = arg_14_0.result,
		score = arg_14_0.score
	}
end
