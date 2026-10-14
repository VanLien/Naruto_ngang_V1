require("battle.app_views.battle.module.include")

local var_0_0 = class("UnionRaidGate", battlePlay.Gate)

battlePlay.UnionRaidGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = true
}

function var_0_0.init(arg_1_0, arg_1_1)
	battlePlay.Gate.init(arg_1_0, arg_1_1)
	gRootViewProxy:proxy():addSpecModule(battleModule.dailyActivityMods)

	if arg_1_1.hpMax == 0 then
		arg_1_0.maxHp = 0
		arg_1_0.remainHp = 0
	else
		arg_1_0.maxHp = arg_1_1.hpMax
		arg_1_0.remainHp = arg_1_1.hpMax - arg_1_1.damage
	end

	arg_1_0.dmgCount = 0
	arg_1_0.dmgAdjust = 0

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

	for iter_2_0, iter_2_1 in ipairs(var_2_0.monsters) do
		if iter_2_1 > 0 and var_2_0.bossMark and var_2_0.bossMark[iter_2_0] == 1 then
			var_2_2 = iter_2_1
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
	arg_3_0.curBoss = arg_3_1

	if arg_3_0.maxHp == 0 then
		arg_3_0.maxHp = arg_3_0.curBoss:hpMax()
	end
end

function var_0_0.createObjectModel(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 == 1 then
		return ObjectModel.new(arg_4_0.scene, arg_4_2)
	else
		return BossModel.new(arg_4_0.scene, arg_4_2)
	end
end

function var_0_0.onNewWave(arg_5_0)
	battlePlay.Gate.onNewWave(arg_5_0)

	local var_5_0 = arg_5_0.curBoss

	if arg_5_0.maxHp and arg_5_0.maxHp ~= 0 then
		local var_5_1 = false

		if var_5_0:hpMax() - arg_5_0.maxHp > 1 then
			printWarn("union boss hpMax client %.2f > server %.2f", var_5_0:hpMax(), arg_5_0.maxHp)

			arg_5_0.maxHp = var_5_0:hpMax()
			arg_5_0.remainHp = var_5_0:hpMax()
			var_5_1 = true
		end

		if arg_5_0.remainHp - var_5_0:hpMax() > 1 or arg_5_0.remainHp == 0 then
			if arg_5_0.remainHp - var_5_0:hpMax() > 1 then
				arg_5_0.dmgAdjust = arg_5_0.remainHp - var_5_0:hpMax()

				printWarn("adjust union boss damage %.2f", arg_5_0.dmgAdjust)
			end

			arg_5_0.remainHp = var_5_0:hpMax()
			var_5_1 = true
		end

		if var_5_1 then
			arg_5_0:initBossLife()
		end

		var_5_0:setHP(arg_5_0.remainHp, arg_5_0.remainHp)
	end
end

function var_0_0.calcBossLifeBarsLostHp(arg_6_0)
	local var_6_0 = arg_6_0.curBoss
	local var_6_1 = var_6_0:hp() / arg_6_0.hpPerRatio
	local var_6_2 = math.max(0, arg_6_0.bossLastLifeBarsPer - var_6_1)

	arg_6_0.dmgCount = math.max(0, arg_6_0.remainHp - var_6_0:hp()) + arg_6_0.dmgAdjust
	arg_6_0.bossLastLifeBarsPer = var_6_1

	return var_6_2
end

function var_0_0.gateDoOnObjectBeAttacked(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.curBoss

	if not var_7_0 or var_7_0.id ~= arg_7_1 then
		return
	end

	local var_7_1 = arg_7_0:calcBossLifeBarsLostHp()

	battleEasy.deferNotifyCantJump(nil, "bossLostHp", {
		lostHpPer = var_7_1
	})
end

function var_0_0.makeEndViewInfos(arg_8_0)
	arg_8_0.result = "win"

	return {
		result = arg_8_0.result,
		damage = arg_8_0.dmgCount,
		hpMax = arg_8_0.maxHp
	}
end

function var_0_0.postEndResultToServer(arg_9_0, arg_9_1)
	gRootViewProxy:raw():postEndResultToServer("/game/union/fuben/end", function(arg_10_0)
		arg_9_1(arg_9_0:makeEndViewInfos(), arg_10_0)
	end, arg_9_0.scene.battleID, arg_9_0.scene.sceneID, arg_9_0.result, arg_9_0.dmgCount, arg_9_0.maxHp)
end

function var_0_0.onBattleEndSupply(arg_11_0)
	local var_11_0 = arg_11_0.curBoss

	if var_11_0 and not var_11_0:isAlreadyDead() then
		arg_11_0.dmgCount = arg_11_0.remainHp - var_11_0:hp()
	else
		arg_11_0.dmgCount = arg_11_0.remainHp
	end

	arg_11_0.dmgCount = math.max(arg_11_0.dmgCount + arg_11_0.dmgAdjust, 0)
end

function var_0_0.newWaveAddObjsStrategy(arg_12_0)
	arg_12_0:addCardRoles(1)
	arg_12_0:addCardRoles(2, 1, arg_12_0:getEnemyRoleOutT(1))
	arg_12_0:doObjsAttrsCorrect(false, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_12_0)
end
