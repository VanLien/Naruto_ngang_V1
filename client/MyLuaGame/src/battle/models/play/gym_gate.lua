local var_0_0 = class("GymGate", battlePlay.Gate)

battlePlay.GymGate = var_0_0
var_0_0.CommonArgs = {
	AntiMode = battle.GateAntiMode.Operate
}

local function var_0_1(arg_1_0)
	local var_1_0 = not arg_1_0.backUp[1][arg_1_0.forceWaveNum[1] + 1] or not next(arg_1_0.backUp[1][arg_1_0.forceWaveNum[1] + 1])
	local var_1_1 = not arg_1_0.backUp[2][arg_1_0.forceWaveNum[2] + 1] or not next(arg_1_0.backUp[2][arg_1_0.forceWaveNum[2] + 1])

	if arg_1_0:checkBothAllRealDead() then
		if var_1_0 and var_1_1 and table.length(arg_1_0.scene.realDeathRecordTb) > 0 then
			return arg_1_0:bothRealDeadSpecCheck()
		elseif var_1_0 then
			return true, "fail"
		elseif var_1_1 then
			return true, "win"
		end
	end

	if arg_1_0:checkForceAllRealDead(1) and var_1_0 then
		return true, "fail"
	end

	if arg_1_0:checkForceAllRealDead(2) and var_1_1 then
		return true, "win"
	end

	if arg_1_0.curRound >= arg_1_0.roundLimit and arg_1_0:checkRoundEnd() and not arg_1_0:needExtraRound() then
		if arg_1_0.hpChecker then
			arg_1_0:hpChecker()
		end

		local var_1_2, var_1_3 = battlePlay.Gate.checkBattleEnd(arg_1_0)

		if var_1_3 == "win" and var_1_1 or var_1_3 == "fail" and var_1_0 then
			return var_1_2, var_1_3
		end
	end

	return false
end

local function var_0_2(arg_2_0)
	local var_2_0 = arg_2_0.result

	if var_2_0 == "win" then
		arg_2_0.endAnimation.aniName = "effect_l"
	elseif var_2_0 == "fail" then
		arg_2_0.endAnimation.aniName = "effect_r"
	end
end

local function var_0_3(arg_3_0)
	local var_3_0 = 0

	for iter_3_0, iter_3_1 in pairs(battle.DamageFrom) do
		var_3_0 = var_3_0 + (arg_3_0.totalDamage[iter_3_1] and arg_3_0.totalDamage[iter_3_1]:get(1) or 0)
	end

	return var_3_0
end

local var_0_4 = {
	2,
	8
}
local var_0_5 = {
	[game.DEPLOY_TYPE.GeneralType] = {},
	[game.DEPLOY_TYPE.OneByOneType] = {
		checkBattleEnd = var_0_1,
		onBattleEndSupply = var_0_2,
		SpecEndRuleCheck1 = {
			battle.EndSpecialCheck.SoloSpecialRule,
			battle.EndSpecialCheck.LastWaveTotalDamage
		},
		SpecEndRuleCheck2 = {
			battle.EndSpecialCheck.SoloSpecialRule,
			battle.EndSpecialCheck.HpRatioCheck,
			battle.EndSpecialCheck.FightPoint,
			battle.EndSpecialCheck.CumulativeSpeedSum
		},
		hpChecker = function(arg_4_0)
			local var_4_0 = arg_4_0.scene:getObject(arg_4_0.forceToObjId[1])
			local var_4_1 = 0

			if var_4_0 then
				var_4_1 = var_4_0:hp() / var_4_0:hpMax()
			end

			local var_4_2 = arg_4_0.scene:getObject(arg_4_0.forceToObjId[2])
			local var_4_3 = 0

			if var_4_2 then
				var_4_3 = var_4_2:hp() / var_4_2:hpMax()
			end

			local var_4_4 = gCommonConfigCsv.craftHpRatioBorder or 1

			if var_4_1 - var_4_4 > 1e-06 and var_4_3 - var_4_4 > 1e-06 then
				arg_4_0.SpecEndRuleCheck = arg_4_0.SpecEndRuleCheck1

				return
			end

			arg_4_0.SpecEndRuleCheck = arg_4_0.SpecEndRuleCheck2
		end,
		needExtraRound = function(arg_5_0)
			if arg_5_0.curRound > arg_5_0.roundLimit then
				return false
			end

			local var_5_0 = arg_5_0.scene:getObject(arg_5_0.forceToObjId[1])
			local var_5_1 = arg_5_0.scene:getObject(arg_5_0.forceToObjId[2])

			if var_5_0 and var_5_0:isFakeDeath() or var_5_1 and var_5_1:isFakeDeath() then
				return true
			end

			return false
		end,
		refreshUIHp = function(arg_6_0)
			local var_6_0 = -1
			local var_6_1 = -1
			local var_6_2 = arg_6_0.scene:getObject(arg_6_0.forceToObjId[1])
			local var_6_3 = arg_6_0.scene:getObject(arg_6_0.forceToObjId[2])

			if var_6_2 then
				var_6_0 = var_6_2:hp() / var_6_2:hpMax()
			end

			if var_6_3 then
				var_6_1 = var_6_3:hp() / var_6_3:hpMax()
			end

			battleEasy.deferNotify(nil, "changeHpMp", {
				selfHpRatio = var_6_0,
				enemyHpRatio = var_6_1
			})
		end,
		refreshUIMp = function(arg_7_0)
			local var_7_0 = -1
			local var_7_1 = -1
			local var_7_2 = arg_7_0.scene:getObject(arg_7_0.forceToObjId[1])
			local var_7_3 = arg_7_0.scene:getObject(arg_7_0.forceToObjId[2])

			if var_7_2 then
				var_7_0 = var_7_2:mp1() / var_7_2:mp1Max()
			end

			if var_7_3 then
				var_7_1 = var_7_3:mp1() / var_7_3:mp1Max()
			end

			battleEasy.deferNotify(nil, "changeHpMp", {
				selfMpRatio = var_7_0,
				enemyMpRatio = var_7_1
			})
		end,
		getFirstRoleOut = function(arg_8_0, arg_8_1)
			return arg_8_0.backUp[arg_8_1][arg_8_0.forceWaveNum[arg_8_1]][var_0_4[arg_8_1]]
		end
	},
	[game.DEPLOY_TYPE.WheelType] = {
		checkBattleEnd = var_0_1,
		needExtraRound = function(arg_9_0)
			if arg_9_0.curRound > arg_9_0.roundLimit then
				return false
			end

			for iter_9_0, iter_9_1 in arg_9_0.scene:ipairsHeros() do
				if iter_9_1:isFakeDeath() then
					return true
				end
			end

			return false
		end,
		onNewWavePlayAni = function(arg_10_0)
			arg_10_0.curWave = arg_10_0.curWave + 1
			arg_10_0.curRound = 0
			arg_10_0.totalRoundBattleTurn = 0

			local var_10_0 = 0
			local var_10_1 = 0

			if arg_10_0.curWave > 1 then
				local var_10_2 = arg_10_0.waveResultList[arg_10_0.curWave - 1]

				if var_10_2 == 1 then
					var_10_1 = 1
				elseif var_10_2 == 2 then
					var_10_0 = 1
				elseif var_10_2 == 3 then
					var_10_1, var_10_0 = 1, 1
				end
			end

			gRootViewProxy:notify("setWaveNumber", arg_10_0.curWave, arg_10_0.waveCount)
			gRootViewProxy:notify("SetGymNumber", arg_10_0.forceWaveNum[1] + var_10_0, arg_10_0.forceWaveNum[2] + var_10_1)
			battleEasy.queueEffect("delay", {
				lifetime = 300
			})
			arg_10_0.scene:waitNewWaveAniDone()
		end
	}
}

var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

function var_0_0.init(arg_11_0, arg_11_1)
	battlePlay.Gate.init(arg_11_0, arg_11_1)

	local var_11_0 = arg_11_1.sceneID

	arg_11_0.deployType = csv.gym.gate[var_11_0].deployType
	arg_11_0.forceWaveNum = {
		1,
		1
	}
	arg_11_0.backUp = {
		{},
		{}
	}
	arg_11_0.backUp2 = {
		{},
		{}
	}
	arg_11_0.forceWaveCount = {
		0,
		0
	}
	arg_11_0.forceToObjId = {
		-1,
		-1
	}
	arg_11_0.waveResultList = {}
	arg_11_0.mayBeMeWin = false

	if arg_11_0.deployType == game.DEPLOY_TYPE.OneByOneType then
		gRootViewProxy:proxy():addSpecModule(battleModule.gymMods)

		arg_11_0.endAnimation = {
			aniName = "",
			res = "xianshipvp/jinjichang.skel"
		}
	end

	arg_11_0:setAllFuncs(arg_11_1)
	arg_11_0:syncBackup()
end

function var_0_0.setAllFuncs(arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in pairs(var_0_5[arg_12_0.deployType]) do
		arg_12_0[iter_12_0] = iter_12_1
	end
end

function var_0_0.syncBackup(arg_13_0)
	if arg_13_0.deployType == game.DEPLOY_TYPE.GeneralType then
		arg_13_0.forceWaveCount = {
			1,
			arg_13_0.waveCount
		}
		arg_13_0.backUp[1][1] = arg_13_0.data.roleOut
		arg_13_0.backUp2[1][1] = arg_13_0.data.roleOut2

		for iter_13_0 = 1, arg_13_0.forceWaveCount[2] do
			local var_13_0 = arg_13_0:getEnemyRoleOutT(iter_13_0)

			table.insert(arg_13_0.backUp[2], var_13_0 and var_13_0[iter_13_0] or {})
			table.insert(arg_13_0.backUp2[2], {})
		end
	elseif arg_13_0.deployType == game.DEPLOY_TYPE.OneByOneType then
		local var_13_1 = csv.gym.gate[arg_13_0.data.sceneID].deployCardNumLimit

		arg_13_0.forceWaveCount[1] = 0
		arg_13_0.forceWaveCount[2] = math.max(0, arg_13_0.waveCount + 1 - var_13_1)

		local var_13_2 = arg_13_0.data.roleOut
		local var_13_3 = arg_13_0.data.roleOut2

		for iter_13_1 = 1, var_13_1 do
			if var_13_2[iter_13_1] then
				arg_13_0.forceWaveCount[1] = arg_13_0.forceWaveCount[1] + 1

				table.insert(arg_13_0.backUp[1], {
					[var_0_4[1]] = var_13_2[iter_13_1]
				})
				table.insert(arg_13_0.backUp2[1], {
					[var_0_4[1]] = var_13_3[iter_13_1]
				})
			end
		end

		local var_13_4 = csv.scene_conf[arg_13_0.scene.sceneID]
		local var_13_5 = {}

		for iter_13_2, iter_13_3 in ipairs(var_13_4.monsters or {}) do
			table.insert(var_13_5, iter_13_3.advance)
		end

		for iter_13_4, iter_13_5 in ipairs(var_13_4.boss or {}) do
			table.insert(var_13_5, iter_13_5.advance)
		end

		for iter_13_6 = 1, arg_13_0.forceWaveCount[2] do
			local var_13_6 = arg_13_0:getEnemyRoleOutT(iter_13_6)
			local var_13_7 = var_13_6 and var_13_6[iter_13_6][1 + arg_13_0.ForceNumber]

			if var_13_7 then
				var_13_7.advance = var_13_5[iter_13_6]
			end

			table.insert(arg_13_0.backUp[2], {
				[var_0_4[2]] = var_13_7
			})
			table.insert(arg_13_0.backUp2[2], {})
		end
	elseif arg_13_0.deployType == game.DEPLOY_TYPE.WheelType then
		arg_13_0.forceWaveCount[1] = arg_13_0.data.roleOut[1] and table.length(arg_13_0.data.roleOut[1]) or 0
		arg_13_0.forceWaveCount[2] = math.max(0, arg_13_0.waveCount + 1 - arg_13_0.forceWaveCount[1])
		arg_13_0.backUp[1] = arg_13_0.data.roleOut[1]
		arg_13_0.backUp2[1] = arg_13_0.data.roleOut2[1]

		for iter_13_7 = 1, arg_13_0.forceWaveCount[2] do
			local var_13_8 = arg_13_0:getEnemyRoleOutT(iter_13_7)

			table.insert(arg_13_0.backUp[2], var_13_8 and var_13_8[iter_13_7] or {})
			table.insert(arg_13_0.backUp2[2], {})
		end
	else
		arg_13_0.backUp = arg_13_0.data.roleOut
		arg_13_0.backUp2 = arg_13_0.data.roleOut2
	end

	arg_13_0.seeBoss = false
end

function var_0_0.newWaveAddObjsStrategy(arg_14_0)
	if arg_14_0.curWave == 1 then
		arg_14_0:addCardRoles(1, nil, arg_14_0.backUp[1][1], arg_14_0.backUp2[1][1], true)
		arg_14_0:addCardRoles(2, nil, arg_14_0.backUp[2][1], arg_14_0.backUp2[2][1], true)
		arg_14_0:doObjsAttrsCorrect(true, true)

		if arg_14_0.deployType == game.DEPLOY_TYPE.OneByOneType then
			battleEasy.deferNotify(nil, "initPvp")
		end
	elseif arg_14_0.waveResultList[arg_14_0.curWave - 1] == 3 then
		arg_14_0.forceWaveNum[1] = arg_14_0.forceWaveNum[1] + 1
		arg_14_0.forceWaveNum[2] = arg_14_0.forceWaveNum[2] + 1

		arg_14_0:addCardRoles(1, nil, arg_14_0.backUp[1][arg_14_0.forceWaveNum[1]], false)
		arg_14_0:addCardRoles(2, nil, arg_14_0.backUp[2][arg_14_0.forceWaveNum[2]], false)
		arg_14_0:doObjsAttrsCorrect(true, true)
	else
		local var_14_0 = 3 - arg_14_0.waveResultList[arg_14_0.curWave - 1]

		arg_14_0.forceWaveNum[var_14_0] = arg_14_0.forceWaveNum[var_14_0] + 1

		arg_14_0:addCardRoles(var_14_0, nil, arg_14_0.backUp[var_14_0][arg_14_0.forceWaveNum[var_14_0]], arg_14_0.backUp2[var_14_0][arg_14_0.forceWaveNum[var_14_0]], false)
		arg_14_0:doObjsAttrsCorrect(var_14_0 == 1, var_14_0 ~= 1)
	end

	battlePlay.Gate.newWaveAddObjsStrategy(arg_14_0)
end

function var_0_0.addCardRoles(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	battlePlay.Gate.addCardRoles(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)

	if arg_15_0.deployType == game.DEPLOY_TYPE.OneByOneType then
		if arg_15_0.curWave ~= 1 then
			battleEasy.deferNotify(nil, "changeWave", arg_15_0.waveResultList[arg_15_0.curWave - 1])
		end

		for iter_15_0, iter_15_1 in arg_15_0.scene:getHerosMap(arg_15_1):order_pairs() do
			arg_15_0.forceToObjId[arg_15_1] = iter_15_1.id

			break
		end
	end
end

function var_0_0.createObjectModel(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0

	if arg_16_1 == 1 then
		var_16_0 = ObjectModel.new(arg_16_0.scene, arg_16_2)
	else
		var_16_0 = MonsterModel.new(arg_16_0.scene, arg_16_2)
	end

	return var_16_0
end

function var_0_0.doObjsAttrsCorrect(arg_17_0, arg_17_1, arg_17_2)
	battlePlay.Gate.doObjsAttrsCorrect(arg_17_0, arg_17_1, arg_17_2)

	local var_17_0 = csv.gym.gate[arg_17_0.data.sceneID] or {}

	local function var_17_1(arg_18_0)
		for iter_18_0, iter_18_1 in ipairs(var_17_0.specialEff or {}) do
			local function var_18_0(arg_19_0)
				local var_19_0 = iter_18_1[4]

				if string.find(var_19_0, "%%") then
					var_19_0 = string.gsub(var_19_0, "%%", "")
					var_19_0 = tonumber(var_19_0) / 100 * arg_19_0
				end

				if iter_18_1[3] > 0 then
					var_19_0 = -var_19_0
				end

				return var_19_0
			end

			if itertools.include(iter_18_1[1], function(arg_20_0)
				return arg_20_0 == arg_18_0:getNatureType(1) or arg_20_0 == arg_18_0:getNatureType(2)
			end) then
				local var_18_1 = game.ATTRDEF_TABLE[iter_18_1[2]]

				var_18_1 = var_18_1 == "hp" and "hpMax" or var_18_1
				var_18_1 = var_18_1 == "mp1" and "mp1Max" or var_18_1

				local var_18_2 = var_18_0(arg_18_0.attrs.base[var_18_1])
				local var_18_3 = var_18_0(arg_18_0.attrs.base2[var_18_1])

				arg_18_0.attrs:addBaseAttr(var_18_1, var_18_2)
				arg_18_0.attrs:addBase2Attr(var_18_1, var_18_3)
				arg_18_0:setHP(arg_18_0:hpMax(), arg_18_0:hpMax())
			end
		end
	end

	for iter_17_0, iter_17_1 in arg_17_0.scene:ipairsHeros() do
		if arg_17_1 and iter_17_1.force == 1 or arg_17_2 and iter_17_1.force == 2 then
			var_17_1(iter_17_1)
		end
	end
end

function var_0_0.checkWaveEnd(arg_21_0)
	local var_21_0 = arg_21_0:checkForceAllRealDead(1)
	local var_21_1 = arg_21_0:checkForceAllRealDead(2)

	if var_21_0 and var_21_1 then
		return true, 3
	elseif var_21_0 then
		return true, 2
	elseif var_21_1 then
		return true, 1
	end

	if arg_21_0.curRound >= arg_21_0.roundLimit and arg_21_0:checkRoundEnd() and not arg_21_0:needExtraRound() then
		if arg_21_0.hpChecker then
			arg_21_0:hpChecker()
		end

		local var_21_2, var_21_3 = arg_21_0:specialEndCheck()

		return true, var_21_3 or 2
	end

	return false
end

function var_0_0.onWaveEndSupply(arg_22_0)
	local var_22_0, var_22_1 = arg_22_0:checkWaveEnd()

	if var_22_1 and var_22_1 == "win" then
		var_22_1 = 1
	elseif var_22_1 == "fail" then
		var_22_1 = 2
	end

	table.insert(arg_22_0.waveResultList, var_22_1)

	if arg_22_0.deployType == game.DEPLOY_TYPE.OneByOneType then
		local var_22_2 = arg_22_0.scene:getObject(arg_22_0.forceToObjId[1])
		local var_22_3 = arg_22_0.scene:getObject(arg_22_0.forceToObjId[2])
		local var_22_4

		if var_22_1 == 1 then
			var_22_4 = arg_22_0.scene:getHerosMap(2)
		elseif var_22_1 == 2 then
			var_22_4 = arg_22_0.scene:getHerosMap(1)
		end

		if var_22_4 then
			for iter_22_0, iter_22_1 in var_22_4:order_pairs() do
				iter_22_1:setDead(nil, nil, {
					force = true,
					noTrigger = true
				})
			end
		end

		if var_22_2 then
			var_22_2.lastWaveTotalDamage = var_0_3(var_22_2)
		end

		if var_22_3 then
			var_22_3.lastWaveTotalDamage = var_0_3(var_22_3)
		end
	end
end

function var_0_0.makeEndViewInfos(arg_23_0)
	local var_23_0, var_23_1 = arg_23_0:whoHighestDamageFromStats(1)

	return {
		result = arg_23_0.result,
		mvpPosId = var_23_1,
		actions = arg_23_0:sendActionParams()
	}
end

function var_0_0.postEndResultToServer(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.scene.extraRecord:getEvent(battle.ExRecordEvent.campDamage)
	local var_24_1 = var_24_0 and var_24_0[1]

	var_24_1 = var_24_1 or 0

	gRootViewProxy:raw():postEndResultToServer("/game/gym/gate/end", {
		cb = function(arg_25_0)
			arg_24_1(arg_24_0:makeEndViewInfos(), arg_25_0)
		end
	}, arg_24_0.scene.battleID, arg_24_0.scene.sceneID, arg_24_0.result, var_24_1)
end

local var_0_6 = class("GymGateRecord", var_0_0)

battlePlay.GymGateRecord = var_0_6
var_0_6.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

function var_0_6.init(arg_26_0, arg_26_1)
	battlePlay.GymGate.init(arg_26_0, arg_26_1)

	arg_26_0.actionRecv = arg_26_1.actions
end

function var_0_6.getActionRecv(arg_27_0)
	local var_27_0 = table.get(arg_27_0.actionRecv, arg_27_0.curRound, arg_27_0.curBattleRound)

	if var_27_0 == nil then
		return
	end

	if var_27_0[1] == 0 then
		return
	end

	return unpack(var_27_0)
end

function var_0_6.onceBattle(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0, var_28_1, var_28_2 = arg_28_0:getActionRecv()

	if (var_28_2 or 0) ~= 0 then
		arg_28_0.scene.autoFight = false

		battlePlay.Gate.onceBattle(arg_28_0, var_28_1, var_28_2)

		arg_28_0.scene.autoFight = true

		if arg_28_0.waitInput then
			error("why input be wait in record")
		end

		return
	end

	battlePlay.Gate.onceBattle(arg_28_0, arg_28_1, arg_28_2)
end

local var_0_7 = class("GymLeaderGate", battlePlay.ArenaGate)

battlePlay.GymLeaderGate = var_0_7

function var_0_7.init(arg_29_0, arg_29_1)
	battlePlay.Gate.init(arg_29_0, arg_29_1)
end

function var_0_7.postEndResultToServer(arg_30_0, arg_30_1)
	gRootViewProxy:raw():postEndResultToServer("/game/gym/leader/battle/end", function(arg_31_0)
		arg_30_1(arg_30_0:makeEndViewInfos(), arg_31_0)
	end, arg_30_0.result, gGameModel.battle.gym_id)
end

local var_0_8 = class("CrossGymGate", battlePlay.GymLeaderGate)

battlePlay.CrossGymGate = var_0_8

function var_0_8.postEndResultToServer(arg_32_0, arg_32_1)
	gRootViewProxy:raw():postEndResultToServer("/game/cross/gym/battle/end", function(arg_33_0)
		arg_32_1(arg_32_0:makeEndViewInfos(), arg_33_0)
	end, arg_32_0.result, gGameModel.battle.gym_id, gGameModel.battle.pos)
end

local var_0_9 = class("GymLeaderGateRecord", battlePlay.ArenaGateRecord)

battlePlay.GymLeaderGateRecord = var_0_9
