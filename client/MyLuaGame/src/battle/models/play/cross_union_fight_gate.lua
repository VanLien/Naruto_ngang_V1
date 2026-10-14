local var_0_0 = class("CrossUnionFightGate", battlePlay.Gate)

battlePlay.CrossUnionFightGate = var_0_0
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
	battle.EndSpecialCheck.ForceNum,
	battle.EndSpecialCheck.FightPoint
}

function var_0_0.init(arg_1_0, arg_1_1)
	arg_1_0.battleType = arg_1_1.battleType
	arg_1_0.battleTimes = arg_1_1.battleTimes
	arg_1_0.defenceBattleTimes = arg_1_1.defenceBattleTimes

	local var_1_0 = csv.cross.union_fight.base[1]

	arg_1_0.waveCount = var_1_0.sceneCount[arg_1_0.battleType]
	arg_1_0.roundLimit = var_1_0.roundLimit[arg_1_0.battleType]
	arg_1_0.attrCorrectMapSceneID = var_1_0.attrCorrectMap[arg_1_0.battleType]
	arg_1_0.dbIDtb = {}
	arg_1_0.UIOpition.craftMods = arg_1_0.battleType == 3
	arg_1_0.isFinal = arg_1_0.UIOpition.craftMods

	battlePlay.Gate.init(arg_1_0, arg_1_1)

	arg_1_0.endAnimation = {
		aniName = "",
		res = "xianshipvp/jinjichang.skel"
	}
	arg_1_0.posByForce = {
		2,
		8
	}
	arg_1_0.forceToObjId = {
		-1,
		-1
	}
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

	arg_1_0:playStartAni()
end

function var_0_0.playStartAni(arg_2_0)
	if arg_2_0.UIOpition.craftMods then
		gRootViewProxy:notify("showVsPvpView", 3)
	else
		gRootViewProxy:notify("showVsPvpView", 1)
	end
end

function var_0_0.newWaveAddObjsStrategy(arg_3_0)
	arg_3_0:addCardRoles(1, nil, nil, nil, true)
	arg_3_0:addCardRoles(2, nil, nil, nil, true)
	arg_3_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_3_0)
end

function var_0_0.addCardRoles(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_0.battleType ~= 3 then
		battlePlay.Gate.addCardRoles(arg_4_0, arg_4_1)

		return
	end

	local var_4_0 = arg_4_0.scene:getHerosMap(arg_4_1)

	for iter_4_0, iter_4_1 in var_4_0:order_pairs() do
		if not arg_4_5 or iter_4_1:isRealDeath() then
			arg_4_0.scene:onObjDel(iter_4_1)
		end
	end

	if not arg_4_5 then
		var_4_0:clear()
	end

	arg_4_0.scene.herosOrder = nil

	if arg_4_0.curWave == 1 then
		local var_4_1 = arg_4_3 or arg_4_0.data.roleOut
		local var_4_2 = arg_4_2 and var_4_1[arg_4_2] or var_4_1
		local var_4_3 = arg_4_4 or arg_4_0.data.roleOut2
		local var_4_4 = arg_4_2 and var_4_3[arg_4_2] or var_4_3
		local var_4_5 = arg_4_1 == 1 and 0 or arg_4_0.ForceNumber
		local var_4_6 = 0

		for iter_4_2 = 1 + var_4_5, arg_4_0.ForceNumber + var_4_5 do
			local var_4_7 = var_4_2[iter_4_2]
			local var_4_8 = arg_4_0.posByForce[arg_4_1]

			if var_4_7 and not arg_4_0.scene:getObjectBySeat(var_4_8) then
				var_4_6 = var_4_6 + 1

				local var_4_9 = arg_4_0:createObjectModel(arg_4_1, var_4_8)

				if var_4_4 and next(var_4_4) then
					var_4_7.role2Data = var_4_4[iter_4_2]
				end

				var_4_9:init(var_4_7)
				var_4_0:insert(var_4_9.id, var_4_9)

				arg_4_0.forceToObjId[arg_4_1] = var_4_9.id
				arg_4_0.firstRoleout[arg_4_1] = var_4_7
			elseif var_4_7 and arg_4_0.scene:getObjectBySeat(var_4_8) then
				if var_4_4 and next(var_4_4) then
					var_4_7.role2Data = var_4_4[iter_4_2]
				end

				table.insert(arg_4_0.backUp[arg_4_1], var_4_7)
			end
		end

		if arg_4_1 == 1 and (not arg_4_2 or arg_4_2 == 1) then
			arg_4_0.scene.forceRecordTb[1].herosStartCount = var_4_6
		end

		table.insert(arg_4_0.forceAdd, arg_4_1)
	elseif arg_4_1 ~= arg_4_0.waveResultList[arg_4_0.curWave - 1] then
		local var_4_10 = arg_4_0.backUp[arg_4_1][1]

		if not next(var_4_10) then
			return
		end

		local var_4_11 = arg_4_0.posByForce[arg_4_1]
		local var_4_12 = arg_4_0:createObjectModel(arg_4_1, var_4_11)

		var_4_12:init(var_4_10)
		var_4_0:insert(var_4_12.id, var_4_12)

		arg_4_0.forceToObjId[arg_4_1] = var_4_12.id

		if arg_4_0.backUp[arg_4_1][2] then
			table.insert(arg_4_0.loserRoleOut[arg_4_1], arg_4_0.firstRoleout[arg_4_1])

			arg_4_0.firstRoleout[arg_4_1] = arg_4_0.backUp[arg_4_1][1]
			arg_4_0.backUp[arg_4_1][1] = arg_4_0.backUp[arg_4_1][2]
			arg_4_0.backUp[arg_4_1][2] = {}
		else
			table.insert(arg_4_0.loserRoleOut[arg_4_1], arg_4_0.firstRoleout[arg_4_1])

			arg_4_0.firstRoleout[arg_4_1] = arg_4_0.backUp[arg_4_1][1]
			arg_4_0.backUp[arg_4_1][1] = {}
		end

		table.insert(arg_4_0.forceAdd, arg_4_1)
		battleEasy.deferNotify(nil, "changeWave", arg_4_0.waveResultList[arg_4_0.curWave - 1])
	end

	arg_4_0.scene:createGroupObj(arg_4_1, battle.SpecialObjectId.teamShiled)
end

function var_0_0.doObjsAttrsCorrect(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.scene.sceneID

	if arg_5_1 then
		arg_5_0.scene.forceRecordTb[1].totalFightPoint = arg_5_0.scene:getTotalForceFightPoint(1)
	end

	if arg_5_2 then
		local var_5_1 = arg_5_0:getMonsterCsv(var_5_0, arg_5_0.curWave)

		if var_5_1 then
			for iter_5_0, iter_5_1 in arg_5_0.scene.enemyHeros:order_pairs() do
				iter_5_1:objAttrsCorrectMonster(var_5_1)
			end
		end

		arg_5_0.scene.forceRecordTb[2].totalFightPoint = arg_5_0.scene:getTotalForceFightPoint(2)
	end

	local var_5_2 = gSceneAttrCorrect[arg_5_0.attrCorrectMapSceneID]
	local var_5_3 = gSceneAttrCorrect[-arg_5_0.attrCorrectMapSceneID]
	local var_5_4 = arg_5_0.scene.forceRecordTb[1].totalFightPoint or 0
	local var_5_5 = arg_5_0.scene.forceRecordTb[2].totalFightPoint or 0
	local var_5_6, var_5_7 = arg_5_0:getBattleFixCfg()

	for iter_5_2, iter_5_3 in arg_5_0.scene:ipairsHeros() do
		if arg_5_1 and iter_5_3:serverForce() == 1 then
			if var_5_2 then
				iter_5_3:objAttrsCorrectScene(var_5_2)
			end

			if var_5_6 then
				iter_5_3:objAttrsCorrect(var_5_6)
			end

			if var_5_4 < var_5_5 then
				iter_5_3:objAttrsCorrectCP(var_5_4, var_5_5)
			end
		elseif arg_5_2 and iter_5_3:serverForce() == 2 then
			if var_5_3 then
				iter_5_3:objAttrsCorrectScene(var_5_3)
			end

			if var_5_7 then
				iter_5_3:objAttrsCorrect(var_5_7)
			end

			if var_5_5 < var_5_4 then
				iter_5_3:objAttrsCorrectCP(var_5_4, var_5_5)
			end
		end

		if not iter_5_3:isAlreadyDead() then
			local var_5_8 = iter_5_3.seat

			arg_5_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.totalHp, iter_5_3:hpMax(), var_5_8)
		end
	end

	for iter_5_4 = 1, arg_5_0.ObjectNumber do
		local var_5_9 = arg_5_0.scene:getObjectBySeatExcludeDead(iter_5_4)

		if var_5_9 then
			var_5_9:setHP(var_5_9:hpMax() * var_5_9.hpScale, var_5_9:hpMax() * var_5_9.hpScale)
			var_5_9:setMP1(var_5_9:mp1Max() * var_5_9.mp1Scale + var_5_9:initMp1(), var_5_9:mp1Max() * var_5_9.mp1Scale + var_5_9:initMp1())
		end
	end

	arg_5_0.states = {}

	arg_5_0:setdbidTb()
end

function var_0_0.getBattleFixCfg(arg_6_0)
	local function var_6_0(arg_7_0)
		local var_7_0 = {}

		for iter_7_0, iter_7_1 in pairs(arg_7_0) do
			if ObjectAttrs.AttrsTable[iter_7_0] then
				var_7_0[iter_7_0 .. "C"] = iter_7_1
			end
		end

		return var_7_0
	end

	local var_6_1
	local var_6_2 = {}
	local var_6_3 = {}
	local var_6_4 = csv.cross.union_fight.battle_fix

	for iter_6_0, iter_6_1 in orderCsvPairs(var_6_4) do
		if iter_6_1.type == arg_6_0.battleType then
			if iter_6_1.battleTimes == arg_6_0.battleTimes then
				var_6_2 = var_6_0(iter_6_1)
			end

			if iter_6_1.battleTimes == arg_6_0.defenceBattleTimes then
				var_6_3 = var_6_0(iter_6_1)
			end

			var_6_1 = iter_6_1
		end
	end

	if not next(var_6_2) then
		var_6_2 = var_6_0(var_6_1)
	end

	if not next(var_6_3) then
		var_6_3 = var_6_0(var_6_1)
	end

	return var_6_2, var_6_3
end

function var_0_0.checkBattleEnd(arg_8_0)
	if arg_8_0.battleType == 3 then
		local var_8_0 = not arg_8_0.backUp[1][1] or not next(arg_8_0.backUp[1][1])
		local var_8_1 = not arg_8_0.backUp[2][1] or not next(arg_8_0.backUp[2][1])

		if arg_8_0:checkBothAllRealDead() then
			if var_8_0 and var_8_1 and table.length(arg_8_0.scene.realDeathRecordTb) > 0 then
				return arg_8_0:bothRealDeadSpecCheck()
			elseif var_8_0 then
				return true, "fail"
			elseif var_8_1 then
				return true, "win"
			end
		end

		if arg_8_0:checkForceAllRealDead(1) and var_8_0 then
			return true, "fail"
		end

		if arg_8_0:checkForceAllRealDead(2) and var_8_1 then
			return true, "win"
		end

		if arg_8_0.curRound >= arg_8_0.roundLimit and arg_8_0:checkRoundEnd() and not arg_8_0:checkHaveFakeDead() then
			local var_8_2, var_8_3 = battlePlay.Gate.checkBattleEnd(arg_8_0)

			if var_8_3 == "win" and var_8_1 or var_8_3 == "fail" and var_8_0 then
				return var_8_2, var_8_3
			end
		end

		return
	end

	return battlePlay.Gate.checkBattleEnd(arg_8_0)
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

	if arg_9_0.curRound >= arg_9_0.roundLimit and arg_9_0:checkRoundEnd() and not arg_9_0:checkHaveFakeDead() then
		local var_9_2, var_9_3 = arg_9_0:specialEndCheck()

		return true, var_9_3
	end

	return false
end

function var_0_0.onBattleEndSupply(arg_10_0)
	local var_10_0, var_10_1 = arg_10_0:checkBattleEnd()

	if var_10_1 == "win" then
		arg_10_0.endAnimation.aniName = "effect_l"
	elseif var_10_1 == "fail" then
		arg_10_0.endAnimation.aniName = "effect_r"
	end
end

function var_0_0.checkHaveFakeDead(arg_11_0)
	for iter_11_0 = 1, arg_11_0.ObjectNumber do
		local var_11_0 = arg_11_0.scene:getObjectBySeat(iter_11_0)

		if var_11_0 and var_11_0:isFakeDeath() then
			return true
		end
	end

	return false
end

function var_0_0.setdbidTb(arg_12_0)
	for iter_12_0 = 1, arg_12_0.ObjectNumber do
		local var_12_0 = arg_12_0.scene:getObjectBySeat(iter_12_0)

		if var_12_0 and arg_12_0:checkObjCanToServer(var_12_0) then
			arg_12_0.dbIDtb[iter_12_0] = var_12_0.dbID
		end
	end
end

function var_0_0.setCardStates(arg_13_0)
	local var_13_0 = 2

	if arg_13_0.result == "win" then
		local var_13_1 = 1
	end

	for iter_13_0 = 1, arg_13_0.ObjectNumber do
		local var_13_2 = arg_13_0.scene:getObjectBySeat(iter_13_0)

		if var_13_2 and arg_13_0:checkObjCanToServer(var_13_2) then
			if not arg_13_0.states[var_13_2.dbID] then
				arg_13_0.states[var_13_2.dbID] = {}
			end

			local var_13_3 = var_13_2:hp() / var_13_2:hpMax()
			local var_13_4 = var_13_2:mp1() / var_13_2:mp1Max()

			if arg_13_0.battleType ~= 1 then
				var_13_4 = 0
			end

			arg_13_0.states[var_13_2.dbID][1] = var_13_3
			arg_13_0.states[var_13_2.dbID][2] = var_13_4
		elseif arg_13_0.dbIDtb[iter_13_0] then
			if not arg_13_0.states[arg_13_0.dbIDtb[iter_13_0]] then
				arg_13_0.states[arg_13_0.dbIDtb[iter_13_0]] = {}
			end

			arg_13_0.states[arg_13_0.dbIDtb[iter_13_0]][1] = 0
			arg_13_0.states[arg_13_0.dbIDtb[iter_13_0]][2] = 0
		end
	end
end

function var_0_0.makeEndViewInfos(arg_14_0)
	arg_14_0:setCardStates()

	return {
		result = arg_14_0.result,
		states = arg_14_0.states
	}
end

function var_0_0.onWaveEndSupply(arg_15_0)
	if arg_15_0.battleType ~= 3 then
		battlePlay.Gate.onWaveEndSupply(arg_15_0)

		return
	end

	local var_15_0, var_15_1 = arg_15_0:checkWaveEnd()

	if var_15_1 == "win" then
		var_15_1 = 1
	elseif var_15_1 == "fail" then
		var_15_1 = 2
	end

	local var_15_2 = arg_15_0.scene:getObject(arg_15_0.forceToObjId[1])
	local var_15_3 = arg_15_0.scene:getObject(arg_15_0.forceToObjId[2])
	local var_15_4

	if var_15_1 == 1 then
		var_15_4 = arg_15_0.scene:getHerosMap(2)
	elseif var_15_1 == 2 then
		var_15_4 = arg_15_0.scene:getHerosMap(1)
	end

	if var_15_4 then
		for iter_15_0, iter_15_1 in var_15_4:order_pairs() do
			iter_15_1:setDead(nil, nil, {
				force = true,
				noTrigger = true
			})
		end
	end

	table.insert(arg_15_0.waveResultList, var_15_1)
end
