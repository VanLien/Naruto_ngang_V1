require("battle.app_views.battle.module.include")

local var_0_0 = class("DailyActivityGate", battlePlay.Gate)

battlePlay.DailyActivityGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}

function var_0_0.ctor(arg_1_0, arg_1_1)
	battlePlay.Gate.ctor(arg_1_0, arg_1_1)

	arg_1_0.curKillMonsterCount = 0
	arg_1_0.lastKillMonsterCount = 0
	arg_1_0.gateStar = 3
	arg_1_0.totalDeadMonsterHp = 0
	arg_1_0.endMoreDelayTime = 1500
end

function var_0_0.init(arg_2_0, arg_2_1)
	battlePlay.Gate.init(arg_2_0, arg_2_1)
	gRootViewProxy:proxy():addSpecModule(battleModule.dailyActivityMods)

	if arg_2_0.scene.gateType == game.GATE_TYPE.dailyExp then
		arg_2_0.monsterLib = {}

		local var_2_0 = arg_2_0.scene.sceneConf.monsterRange or {}

		for iter_2_0, iter_2_1 in csvPairs(var_2_0) do
			for iter_2_2 = 1, iter_2_1 do
				table.insert(arg_2_0.monsterLib, iter_2_0)
			end
		end

		table.sort(arg_2_0.monsterLib)

		arg_2_0.totalCount = arg_2_0.scene.sceneConf.finishPoint.killNumber or 0

		if arg_2_0.totalCount == 0 then
			arg_2_0.totalCount = table.length(arg_2_0.monsterLib)
		end

		gRootViewProxy:notify("killCount", {
			curCount = 0,
			totalCount = arg_2_0.totalCount
		})
	elseif arg_2_0.scene.gateType == game.GATE_TYPE.dailyGold then
		local var_2_1 = csvClone(gMonsterCsv[arg_2_0.scene.sceneID][1])

		arg_2_0.bossLifeTotalCount = var_2_1.bossLifeCount or 1
		arg_2_0.bossLastLifeBarsPer = arg_2_0.bossLifeTotalCount * 100

		local var_2_2

		for iter_2_3, iter_2_4 in ipairs(var_2_1.monsters) do
			if iter_2_4 > 0 and var_2_1.bossMark and var_2_1.bossMark[iter_2_3] == 1 then
				var_2_2 = iter_2_4
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
end

function var_0_0.setBoss(arg_3_0, arg_3_1)
	arg_3_0.curBoss = arg_3_1
	arg_3_0.hpPerRatio = arg_3_1:hpMax() / arg_3_0.bossLastLifeBarsPer
end

function var_0_0.createObjectModel(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 == 1 then
		return ObjectModel.new(arg_4_0.scene, arg_4_2)
	elseif arg_4_0.scene.gateType == game.GATE_TYPE.dailyGold then
		return BossModel.new(arg_4_0.scene, arg_4_2)
	else
		return MonsterModel.new(arg_4_0.scene, arg_4_2)
	end

	return obj
end

function var_0_0.newWaveAddObjsStrategy(arg_5_0)
	if arg_5_0.scene.gateType == game.GATE_TYPE.dailyExp then
		arg_5_0:addCardRoles(1)

		local var_5_0 = {}

		for iter_5_0 = 7, 12 do
			var_5_0[iter_5_0] = arg_5_0:getMonsterFromLib()
		end

		arg_5_0:addCardRoles(2, nil, var_5_0)
		arg_5_0:doObjsAttrsCorrect(true, true)
	else
		arg_5_0:addCardRoles(1)
		arg_5_0:addCardRoles(2, 1, arg_5_0:getEnemyRoleOutT(1))
		arg_5_0:doObjsAttrsCorrect(true, true)
	end

	if arg_5_0.scene.gateType == game.GATE_TYPE.dailyGold then
		arg_5_0.hpPerRatio = arg_5_0.curBoss:hpMax() / arg_5_0.bossLastLifeBarsPer
	end

	battlePlay.Gate.newWaveAddObjsStrategy(arg_5_0)
end

function var_0_0.getMonsterFromLib(arg_6_0)
	if not next(arg_6_0.monsterLib) then
		return
	end

	local var_6_0 = ymrand.random(1, table.length(arg_6_0.monsterLib))
	local var_6_1 = arg_6_0.monsterLib[var_6_0]

	table.remove(arg_6_0.monsterLib, var_6_0)

	return {
		advance = 0,
		roleForce = 2,
		isMonster = true,
		roleId = var_6_1,
		level = arg_6_0.scene.sceneLevel,
		skillLevel = arg_6_0.scene.skillLevel,
		showLevel = arg_6_0.scene.showLevel
	}
end

function var_0_0.addMonstersOnBattleTurnEnd(arg_7_0)
	local var_7_0 = {}

	for iter_7_0 = 7, 12 do
		if not arg_7_0.scene:getObjectBySeatExcludeDead(iter_7_0) then
			var_7_0[iter_7_0] = arg_7_0:getMonsterFromLib()
		end
	end

	arg_7_0:addCardRoles(2, nil, var_7_0, nil, true)
end

function var_0_0.calcBossLifeBarsLostHp(arg_8_0)
	local var_8_0 = arg_8_0.curBoss
	local var_8_1 = math.ceil(var_8_0:hp() / arg_8_0.hpPerRatio)
	local var_8_2 = math.max(0, arg_8_0.bossLastLifeBarsPer - var_8_1)

	arg_8_0.bossLastLifeBarsPer = var_8_1
	arg_8_0.bossLostLifePer = math.ceil(100 - var_8_0:hp() / var_8_0:hpMax() * 100)

	return var_8_2
end

function var_0_0.calcBossDrop(arg_9_0)
	if arg_9_0.scene.gateType == game.GATE_TYPE.dailyGold then
		local var_9_0 = arg_9_0.curBoss

		if not var_9_0 then
			return
		end

		local var_9_1 = arg_9_0.curBossLifePer or 1
		local var_9_2 = cc.clampf(var_9_0:hp() / var_9_0:hpMax(), 0, 1)

		arg_9_0.curBossLifePer = var_9_2

		local var_9_3 = cc.clampf(math.floor((var_9_1 - var_9_2) * 100), 0, 100)
		local var_9_4 = cc.clampf(math.floor((1 - var_9_2) * 100), 0, 100)

		return {
			nPer = var_9_3,
			nNode = var_9_4,
			tostrModel = tostring(var_9_0)
		}
	end
end

function var_0_0.calcDeathDrop(arg_10_0, arg_10_1)
	if arg_10_0.scene.gateType == game.GATE_TYPE.dailyExp then
		if arg_10_1 <= 6 then
			return
		end

		local var_10_0 = arg_10_0.curKillMonsterCount - arg_10_0.lastKillMonsterCount

		arg_10_0.lastKillMonsterCount = arg_10_0.curKillMonsterCount

		local var_10_1 = arg_10_0.scene:getObjectBySeat(arg_10_1)
		local var_10_2 = {
			nPer = var_10_0,
			nNode = arg_10_0.curKillMonsterCount,
			tostrModel = tostring(var_10_1)
		}
		local var_10_3 = arg_10_0.scene.extraRecord:getEvent(battle.ExRecordEvent.totalHp) or {}

		arg_10_0.totalDeadMonsterHp = arg_10_0.totalDeadMonsterHp + (var_10_3[arg_10_1] or 0)

		return var_10_2
	end
end

function var_0_0.gateDoOnObjectBeAttacked(arg_11_0, arg_11_1)
	if arg_11_0.scene.gateType == game.GATE_TYPE.dailyGold then
		local var_11_0 = arg_11_0.curBoss

		if not var_11_0 or var_11_0.id ~= arg_11_1 then
			return
		end

		local var_11_1 = arg_11_0:calcBossLifeBarsLostHp()

		battleEasy.deferNotifyCantJump(nil, "bossLostHp", {
			lostHpPer = var_11_1
		})
	end
end

function var_0_0.gateDoOnSkillEnd(arg_12_0)
	if arg_12_0.scene.gateType == game.GATE_TYPE.dailyGold then
		return arg_12_0:calcBossDrop()
	end
end

function var_0_0.gateDoOnObjectDead(arg_13_0, arg_13_1)
	if arg_13_0.scene.gateType == game.GATE_TYPE.dailyExp and arg_13_1 > 6 then
		arg_13_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.killNumber, 1, "Val")

		arg_13_0.curKillMonsterCount = arg_13_0.scene.extraRecord:getEventByKey(battle.ExRecordEvent.killNumber, "Val") or 0

		local var_13_0 = arg_13_0:calcDeathDrop(arg_13_1)

		if var_13_0 then
			battleEasy.deferNotify(nil, "dropShow", var_13_0)
		end
	end
end

function var_0_0.onTurnStartSupply(arg_14_0)
	if arg_14_0.scene.gateType == game.GATE_TYPE.dailyExp then
		battleEasy.deferNotify(nil, "killCount", {
			curCount = arg_14_0.curKillMonsterCount,
			totalCount = arg_14_0.totalCount
		})
		arg_14_0:addMonstersOnBattleTurnEnd()
		arg_14_0:doObjsAttrsCorrect(false, true)
	end
end

function var_0_0.onRoundEndSupply(arg_15_0)
	battleEasy.deferNotify(nil, "roundEndDropCollection")
end

function var_0_0.onBattleEndSupply(arg_16_0)
	if arg_16_0.scene.gateType == game.GATE_TYPE.dailyExp then
		battleEasy.deferNotify(nil, "killCount", {
			curCount = arg_16_0.curKillMonsterCount,
			totalCount = arg_16_0.totalCount
		})
	end

	battleEasy.deferNotify(nil, "roundEndDropCollection")
end

function var_0_0.makeEndViewInfos(arg_17_0)
	local var_17_0 = 0
	local var_17_1 = 0
	local var_17_2 = 1

	local function var_17_3(arg_18_0, arg_18_1)
		arg_18_0 = arg_18_0 or 1

		local var_18_0 = (csv.huodong[arg_18_0] or {}).rankShow or {}
		local var_18_1 = 1

		for iter_18_0, iter_18_1 in ipairs(var_18_0) do
			if arg_18_1 < iter_18_1 then
				break
			else
				var_18_1 = iter_18_0
			end
		end

		return var_18_1
	end

	if arg_17_0.scene.gateType == game.GATE_TYPE.dailyGold then
		var_17_0 = arg_17_0.bossLostLifePer or 0
		var_17_1 = (arg_17_0.scene.extraRecord:getEvent(battle.ExRecordEvent.campDamage) or {})[1] or 0
		var_17_2 = var_17_3(1, var_17_0)
	elseif arg_17_0.scene.gateType == game.GATE_TYPE.dailyExp then
		var_17_0 = arg_17_0.curKillMonsterCount or 0
		var_17_1 = arg_17_0.totalDeadMonsterHp or 0
		var_17_2 = var_17_3(2, var_17_0)
	end

	return {
		result = arg_17_0.result,
		socre = var_17_1,
		percent = var_17_0,
		rankNode = var_17_2
	}
end

function var_0_0.postEndResultToServer(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:makeEndViewInfos()

	gRootViewProxy:raw():postEndResultToServer("/game/huodong/end", function(arg_20_0)
		arg_19_1(var_19_0, arg_20_0)
	end, arg_19_0.scene.battleID, arg_19_0.scene.sceneID, arg_19_0.result, arg_19_0.gateStar, var_19_0.percent, var_19_0.socre)
end

function var_0_0.endBattleTurn(arg_21_0, arg_21_1)
	if arg_21_0.scene.gateType == game.GATE_TYPE.dailyGold then
		-- block empty
	end

	local var_21_0 = 500

	if arg_21_0.battleTurnInfoTb.hasDeadObj then
		var_21_0 = 1500
	end

	battleEasy.queueEffect(function()
		battleEasy.queueEffect("delay", {
			lifetime = var_21_0
		})
	end)
	battlePlay.Gate.endBattleTurn(arg_21_0, arg_21_1)
end
