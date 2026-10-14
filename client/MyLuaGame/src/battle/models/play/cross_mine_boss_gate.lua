local var_0_0 = class("CrossMineBossGate", battlePlay.Gate)

battlePlay.CrossMineBossGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}
var_0_0.CommonArgs = {
	AntiMode = battle.GateAntiMode.Operate
}

function var_0_0.init(arg_1_0, arg_1_1)
	battlePlay.Gate.init(arg_1_0, arg_1_1)

	arg_1_0.bossHp = arg_1_1.bossHp or {}
	arg_1_0.bossHpMax = arg_1_1.bossHpMax or {}
	arg_1_0.bossList = {}
	arg_1_0.unitMaxHp = {}
	arg_1_0.unitRemainHp = {}
	arg_1_0.dmgCount = {}

	local var_1_0 = 0
	local var_1_1 = 0

	for iter_1_0, iter_1_1 in pairs(arg_1_0.bossHpMax) do
		arg_1_0.unitMaxHp[iter_1_0] = iter_1_1
		var_1_0 = var_1_0 + iter_1_1

		if arg_1_0.bossHp[iter_1_0] then
			arg_1_0.unitRemainHp[iter_1_0] = arg_1_0.bossHp[iter_1_0]
			var_1_1 = var_1_1 + arg_1_0.bossHp[iter_1_0]
		end
	end

	arg_1_0.maxHp = var_1_0
	arg_1_0.remainHp = var_1_1

	arg_1_0:initBossLife()
end

function var_0_0.initBossLife(arg_2_0)
	if arg_2_0.maxHp == 0 then
		return
	end

	arg_2_0.bossHpRatio = arg_2_0.remainHp / arg_2_0.maxHp

	local var_2_0 = gMonsterCsv[arg_2_0.scene.sceneID][1]

	arg_2_0.originBossLifeCount = var_2_0.bossLifeCount or 1

	local var_2_1 = arg_2_0.originBossLifeCount * arg_2_0.bossHpRatio

	arg_2_0.bossLifeTotalCount = math.ceil(var_2_1)
	arg_2_0.bossLastLifeBarsPer = var_2_1 * 100
	arg_2_0.hpPerRatio = arg_2_0.maxHp / arg_2_0.originBossLifeCount / 100

	local var_2_2

	for iter_2_0, iter_2_1 in ipairs(arg_2_0.bossList) do
		if iter_2_1:hp() > 0 then
			var_2_2 = iter_2_1.orginUnitId
		end
	end

	if not var_2_2 then
		for iter_2_2, iter_2_3 in ipairs(var_2_0.monsters) do
			if iter_2_3 > 0 then
				var_2_2 = iter_2_3
			end
		end
	end

	if var_2_2 then
		local var_2_3 = csv.unit[var_2_2]

		gRootViewProxy:notify("initBossLife", {
			name = var_2_3.name,
			headIconRes = var_2_3.icon,
			leftBars = arg_2_0.bossLifeTotalCount,
			barsLife = arg_2_0.bossLastLifeBarsPer
		})
	end
end

function var_0_0.setBoss(arg_3_0, arg_3_1)
	return
end

function var_0_0.createObjectModel(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 == 1 then
		return ObjectModel.new(arg_4_0.scene, arg_4_2)
	else
		local var_4_0 = BossModel.new(arg_4_0.scene, arg_4_2)

		table.insert(arg_4_0.bossList, var_4_0)

		return var_4_0
	end
end

function var_0_0.onNewWave(arg_5_0)
	battlePlay.Gate.onNewWave(arg_5_0)

	local var_5_0 = 0
	local var_5_1 = 0

	for iter_5_0, iter_5_1 in arg_5_0.scene:getHerosMap(2):order_pairs() do
		local var_5_2 = iter_5_1.orginUnitId

		arg_5_0.unitMaxHp[var_5_2] = arg_5_0.unitMaxHp[var_5_2] or iter_5_1:hpMax()
		arg_5_0.unitRemainHp[var_5_2] = arg_5_0.unitRemainHp[var_5_2] or iter_5_1:hp()
		var_5_1 = var_5_1 + arg_5_0.unitRemainHp[var_5_2]

		if iter_5_1:hp() <= 0 then
			iter_5_1:setDead(nil, nil, {
				force = true,
				noTrigger = true
			})
		end
	end

	for iter_5_2, iter_5_3 in pairs(arg_5_0.unitMaxHp) do
		var_5_0 = var_5_0 + iter_5_3
	end

	arg_5_0.maxHp = var_5_0
	arg_5_0.remainHp = var_5_1

	arg_5_0:initBossLife()
end

function var_0_0.getEnemyRoleOutT(arg_6_0, arg_6_1)
	local var_6_0 = battlePlay.Gate.getEnemyRoleOutT(arg_6_0, arg_6_1)

	for iter_6_0, iter_6_1 in pairs(var_6_0[1]) do
		local var_6_1 = iter_6_1.roleId

		if var_6_1 and arg_6_0.unitRemainHp[var_6_1] and arg_6_0.unitRemainHp[var_6_1] <= 0 then
			var_6_0[1][iter_6_0] = nil
		end
	end

	return var_6_0
end

function var_0_0.newWaveAddObjsStrategy(arg_7_0)
	arg_7_0:addCardRoles(1)
	arg_7_0:addCardRoles(2, 1, arg_7_0:getEnemyRoleOutT(1))
	arg_7_0:doObjsAttrsCorrect(false, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_7_0)
end

function var_0_0.doObjsAttrsCorrect(arg_8_0, arg_8_1, arg_8_2)
	battlePlay.Gate.doObjsAttrsCorrect(arg_8_0, arg_8_1, arg_8_2)

	if arg_8_2 then
		for iter_8_0, iter_8_1 in ipairs(arg_8_0.bossList) do
			local var_8_0 = iter_8_1.orginUnitId

			if arg_8_0.bossHpMax[var_8_0] then
				iter_8_1.attrs:setBaseAttr("hpMax", arg_8_0.bossHpMax[var_8_0])
				iter_8_1.attrs:setBase2Attr("hpMax", arg_8_0.bossHpMax[var_8_0])
			end

			if arg_8_0.bossHp[var_8_0] then
				iter_8_1:setHP(arg_8_0.bossHp[var_8_0], arg_8_0.bossHp[var_8_0])
			end
		end
	end
end

function var_0_0.calcBossLifeBarsLostHp(arg_9_0)
	local var_9_0 = 0

	for iter_9_0, iter_9_1 in ipairs(arg_9_0.bossList) do
		if not iter_9_1:isAlreadyDead() then
			local var_9_1 = iter_9_1.orginUnitId

			var_9_0 = var_9_0 + iter_9_1:hp()

			local var_9_2 = math.max(0, arg_9_0.unitRemainHp[var_9_1] - iter_9_1:hp())

			arg_9_0.dmgCount[var_9_1] = var_9_2
		end
	end

	local var_9_3 = var_9_0 / arg_9_0.hpPerRatio
	local var_9_4 = math.max(0, arg_9_0.bossLastLifeBarsPer - var_9_3)

	arg_9_0.bossLastLifeBarsPer = var_9_3

	return var_9_4
end

function var_0_0.gateDoOnObjectBeAttacked(arg_10_0, arg_10_1)
	if not itertools.include(arg_10_0.bossList, function(arg_11_0)
		return arg_11_0.id == arg_10_1
	end) then
		return
	end

	local var_10_0 = arg_10_0:calcBossLifeBarsLostHp()

	battleEasy.deferNotifyCantJump(nil, "bossLostHp", {
		lostHpPer = var_10_0
	})
end

function var_0_0.makeEndViewInfos(arg_12_0)
	arg_12_0.result = "win"

	local var_12_0 = 0

	for iter_12_0, iter_12_1 in pairs(arg_12_0.dmgCount) do
		var_12_0 = var_12_0 + iter_12_1
	end

	return {
		result = arg_12_0.result,
		damage = var_12_0,
		hpMax = arg_12_0.maxHp
	}
end

function var_0_0.sendParams(arg_13_0)
	return arg_13_0.scene.battleID, arg_13_0.dmgCount, battlePlay.Gate.sendActionParams(arg_13_0)
end

function var_0_0.postEndResultToServer(arg_14_0, arg_14_1)
	gRootViewProxy:raw():postEndResultToServer("/game/cross/mine/boss/battle/end", {
		cb = function(arg_15_0)
			arg_14_1(arg_14_0:makeEndViewInfos(), arg_15_0)
		end
	}, arg_14_0:sendParams())
end

function var_0_0.onBattleEndSupply(arg_16_0)
	for iter_16_0, iter_16_1 in ipairs(arg_16_0.bossList) do
		if arg_16_0:checkObjCanToServer(iter_16_1) then
			local var_16_0 = iter_16_1.orginUnitId

			if not iter_16_1:isAlreadyDead() then
				arg_16_0.dmgCount[var_16_0] = arg_16_0.unitRemainHp[var_16_0] - iter_16_1:hp()
			else
				arg_16_0.dmgCount[var_16_0] = arg_16_0.unitRemainHp[var_16_0]
			end

			arg_16_0.dmgCount[var_16_0] = math.max(arg_16_0.dmgCount[var_16_0], 0)
		end
	end
end

local var_0_1 = class("CrossMineBossGateRecord", var_0_0)

battlePlay.CrossMineBossGateRecord = var_0_1

function var_0_1.init(arg_17_0, arg_17_1)
	if not arg_17_1.actions then
		arg_17_0.OperatorArgs = var_0_0.OperatorArgs
	end

	battlePlay.CrossMineBossGate.init(arg_17_0, arg_17_1)

	arg_17_0.actionRecv = arg_17_1.actions
end

function var_0_1.getActionRecv(arg_18_0)
	local var_18_0 = table.get(arg_18_0.actionRecv, arg_18_0.curRound, arg_18_0.curBattleRound)

	if var_18_0 == nil then
		return
	end

	if var_18_0[1] == 0 then
		return
	end

	return unpack(var_18_0)
end

function var_0_1.sendParams(arg_19_0)
	return arg_19_0.scene.battleID, arg_19_0.dmgCount
end

function var_0_1.checkBattleEnd(arg_20_0)
	if arg_20_0.scene.isBattleAllEnd then
		return true, arg_20_0.result
	end

	return battlePlay.Gate.checkBattleEnd(arg_20_0)
end

function var_0_1.onceBattle(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0, var_21_1, var_21_2 = arg_21_0:getActionRecv()

	if (var_21_0 or 0) ~= 0 and var_21_0 ~= arg_21_0.curHero.seat then
		printWarn("CrossMineBossGateRecord战斗和战报不一致")

		arg_21_0.result = "fail"
		arg_21_0.scene.isBattleAllEnd = true

		arg_21_0:onOver()

		return
	end

	if (var_21_2 or 0) ~= 0 then
		arg_21_0.scene.autoFight = false

		battlePlay.Gate.onceBattle(arg_21_0, var_21_1, var_21_2)

		arg_21_0.scene.autoFight = true

		if arg_21_0.waitInput then
			error("why input be wait in record")
		end

		return
	end

	battlePlay.Gate.onceBattle(arg_21_0, arg_21_1, arg_21_2)
end
