require("battle.app_views.battle.module.include")

local var_0_0 = class("ActivityWorldBossGate", battlePlay.Gate)

battlePlay.ActivityWorldBossGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}
var_0_0.PlayCsvFunc = {
	damage = function(arg_1_0, arg_1_1)
		return arg_1_0.damageAward[arg_1_1].damage
	end
}

function var_0_0.ctor(arg_2_0, arg_2_1)
	battlePlay.Gate.ctor(arg_2_0, arg_2_1)

	arg_2_0.curKillMonsterCount = 0
	arg_2_0.lastKillMonsterCount = 0
	arg_2_0.gateStar = 3
	arg_2_0.totalDeadMonsterHp = 0
	arg_2_0.recoverHp = 1
	arg_2_0.endMoreDelayTime = 1500
	arg_2_0.yyCsvVersion = csv.yunying.yyhuodong[arg_2_1.data.activityID].huodongID
	arg_2_0.boss_damage_max = arg_2_1.data.boss_damage_max

	arg_2_0:initVersionInfo(ver)
end

function var_0_0.initVersionInfo(arg_3_0, arg_3_1)
	arg_3_0.damageAward = {}
	arg_3_0.damageAwardInfo = {}
	arg_3_0.curtotalTakeDamage = 0

	for iter_3_0, iter_3_1 in orderCsvPairs(csv.world_boss.damage_award) do
		if iter_3_1.huodongID == arg_3_0.yyCsvVersion then
			table.insert(arg_3_0.damageAward, csvClone(iter_3_1))
		end
	end

	arg_3_0:refreshAwardInfoByDamage(0)
end

function var_0_0.refreshAwardInfoByDamage(arg_4_0, arg_4_1)
	local var_4_0 = 1

	if arg_4_0.damageAwardInfo.next and arg_4_1 < arg_4_0.damageAwardInfo.next.damage then
		return
	end

	if arg_4_0.damageAwardInfo.cur then
		if not arg_4_0.damageAwardInfo.next then
			return
		end

		var_4_0 = arg_4_0.damageAwardInfo.cur.level + 1
	end

	arg_4_0.damageAwardInfo = {}

	for iter_4_0 = var_4_0, table.length(arg_4_0.damageAward) do
		local var_4_1 = arg_4_0.damageAward[iter_4_0]

		if arg_4_1 < var_4_1.damage then
			arg_4_0.damageAwardInfo.next = var_4_1

			break
		end

		arg_4_0.damageAwardInfo.cur = var_4_1
	end
end

function var_0_0.init(arg_5_0, arg_5_1)
	battlePlay.Gate.init(arg_5_0, arg_5_1)
	gRootViewProxy:proxy():addSpecModule(battleModule.bossMods)

	local var_5_0 = csvClone(gMonsterCsv[arg_5_0.scene.sceneID][1])

	arg_5_0.bossLifeTotalCount = var_5_0.bossLifeCount or 1
	arg_5_0.bossLastLifeBarsPer = arg_5_0.bossLifeTotalCount * 100

	local var_5_1

	for iter_5_0, iter_5_1 in ipairs(var_5_0.monsters) do
		if iter_5_1 > 0 and var_5_0.bossMark and var_5_0.bossMark[iter_5_0] == 1 then
			var_5_1 = iter_5_1
		end
	end

	if var_5_1 then
		local var_5_2 = csv.unit[var_5_1]

		gRootViewProxy:notify("initBossLife", {
			name = var_5_2.name,
			headIconRes = var_5_2.icon,
			damageAward = arg_5_0.damageAward
		})
	end
end

function var_0_0.setBoss(arg_6_0, arg_6_1)
	arg_6_0.curBoss = arg_6_1

	arg_6_0:setRecoverHp(0)
	arg_6_1.view:proxy():updateLifeBarState(false)
end

function var_0_0.setRecoverHp(arg_7_0, arg_7_1)
	local var_7_0 = 1

	arg_7_0.recoverHp = arg_7_0.curBoss:hpMax() * var_7_0
end

function var_0_0.createObjectModel(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == 1 then
		return ObjectModel.new(arg_8_0.scene, arg_8_2)
	else
		if arg_8_2 == 11 then
			return BossModel.new(arg_8_0.scene, arg_8_2)
		end

		return MonsterModel.new(arg_8_0.scene, arg_8_2)
	end
end

function var_0_0.newWaveAddObjsStrategy(arg_9_0)
	arg_9_0:addCardRoles(1)
	arg_9_0:addCardRoles(2, 1, arg_9_0:getEnemyRoleOutT(1))
	arg_9_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_9_0)
end

function var_0_0.refreshUIHp(arg_10_0, arg_10_1)
	if arg_10_0.curBoss ~= arg_10_1 then
		return
	end

	local var_10_0 = arg_10_1:getTakeDamageRecord(battle.ValueType.normal)

	arg_10_0:refreshAwardInfoByDamage(var_10_0)
	arg_10_0:setRecoverHp(var_10_0)

	local var_10_1 = 1
	local var_10_2 = arg_10_0.damageAwardInfo.cur and arg_10_0.damageAwardInfo.cur.level or 0
	local var_10_3 = arg_10_0.damageAwardInfo.next and arg_10_0.damageAwardInfo.next.damage or arg_10_0.damageAwardInfo.cur.damage

	if arg_10_0.damageAwardInfo.cur and arg_10_0.damageAwardInfo.next then
		var_10_1 = (var_10_0 - arg_10_0.damageAwardInfo.cur.damage) / (arg_10_0.damageAwardInfo.next.damage - arg_10_0.damageAwardInfo.cur.damage)
	elseif not arg_10_0.damageAwardInfo.cur then
		var_10_1 = var_10_0 / arg_10_0.damageAwardInfo.next.damage
	end

	if var_10_0 > arg_10_0.curtotalTakeDamage then
		arg_10_0.curtotalTakeDamage = var_10_0

		battleEasy.deferNotifyCantJump(nil, "refreshBossHp", var_10_1, var_10_0, var_10_3, var_10_2)
	end
end

function var_0_0.makeEndViewInfos(arg_11_0)
	if not arg_11_0.damageAwardInfo.cur or not arg_11_0.damageAwardInfo.cur.award then
		local var_11_0 = {}
	end

	local var_11_1 = arg_11_0.curBoss:getTakeDamageRecord(battle.ValueType.normal)

	return {
		result = arg_11_0.result,
		damage = var_11_1
	}
end

function var_0_0.postEndResultToServer(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:makeEndViewInfos()

	gRootViewProxy:raw():postEndResultToServer("/game/yy/world/boss/end", {
		cb = function(arg_13_0)
			var_12_0.award = arg_13_0.view.award
			var_12_0.isNewRecordDamage = arg_12_0.boss_damage_max < var_12_0.damage

			arg_12_1(var_12_0, arg_13_0)
		end
	}, arg_12_0.scene.battleID, arg_12_0.scene.data.activityID, var_12_0.damage)
end

function var_0_0.endBattleTurn(arg_14_0, arg_14_1)
	local var_14_0 = 500

	if arg_14_0.battleTurnInfoTb.hasDeadObj then
		var_14_0 = 1500
	end

	battleEasy.queueEffect(function()
		battleEasy.queueEffect("delay", {
			lifetime = var_14_0
		})
	end)
	battlePlay.Gate.endBattleTurn(arg_14_0, arg_14_1)
end
