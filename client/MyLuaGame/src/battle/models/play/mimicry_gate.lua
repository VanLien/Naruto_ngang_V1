require("battle.app_views.battle.module.include")

local var_0_0 = class("MimicryGate", battlePlay.Gate)

battlePlay.MimicryGate = var_0_0
var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = false,
	canSpeedAni = true,
	canPause = false,
	canSkip = true
}
var_0_0.CommonArgs = {
	AntiMode = battle.GateAntiMode.Operate
}
var_0_0.PlayCsvFunc = {
	bossBuff = function(arg_1_0, arg_1_1)
		for iter_1_0, iter_1_1 in pairs(arg_1_0.data.buff_ids) do
			if iter_1_1 == arg_1_1 then
				return true
			end
		end

		return false
	end
}

function var_0_0.ctor(arg_2_0, arg_2_1)
	battlePlay.Gate.ctor(arg_2_0, arg_2_1)

	arg_2_0.recoverHp = 1
	arg_2_0.curtotalTakeDamage = 0
end

function var_0_0.init(arg_3_0, arg_3_1)
	battlePlay.Gate.init(arg_3_0, arg_3_1)

	arg_3_0.data = arg_3_1

	gRootViewProxy:proxy():addSpecModule(battleModule.mimicryMods)

	local var_3_0 = csvClone(gMonsterCsv[arg_3_0.scene.sceneID][1])
	local var_3_1 = csv.mimicry.boss[arg_3_0.data.boss_id]
	local var_3_2 = var_3_1 and var_3_1.bossID

	if var_3_2 then
		local var_3_3 = csv.unit[var_3_2]

		gRootViewProxy:notify("initBossLife", {
			name = var_3_3.name,
			headIconRes = var_3_3.icon,
			hpMax = arg_3_0.data.boss_hp_threshold
		})
	end
end

function var_0_0.setBoss(arg_4_0, arg_4_1)
	arg_4_0.curBoss = arg_4_1

	arg_4_0:setRecoverHp(0)
	arg_4_1.view:proxy():updateLifeBarState(false)
end

function var_0_0.setRecoverHp(arg_5_0, arg_5_1)
	local var_5_0 = 1

	arg_5_0.recoverHp = arg_5_0.curBoss:hpMax() * var_5_0
end

function var_0_0.createObjectModel(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_1 == 1 then
		return ObjectModel.new(arg_6_0.scene, arg_6_2)
	else
		return BossModel.new(arg_6_0.scene, arg_6_2)
	end
end

function var_0_0.newWaveAddObjsStrategy(arg_7_0)
	local var_7_0 = arg_7_0.data.buff_ids
	local var_7_1 = {}
	local var_7_2 = arg_7_0:getEnemyRoleOutT(1)

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		local var_7_3 = csv.mimicry.buffs[iter_7_1]

		if var_7_3.skill then
			var_7_1[var_7_3.skill] = 1
		end
	end

	for iter_7_2 = 7, 12 do
		local var_7_4 = var_7_2[1][iter_7_2]

		if var_7_4 then
			var_7_4.passive_skills = var_7_4.passive_skills or {}

			for iter_7_3, iter_7_4 in pairs(var_7_1) do
				var_7_4.passive_skills[iter_7_3] = iter_7_4
			end

			if var_7_4.isBoss then
				for iter_7_5, iter_7_6 in pairs(arg_7_0.data.boss_limit_skills or {}) do
					var_7_4.passive_skills[iter_7_5] = iter_7_6
				end
			end
		end
	end

	arg_7_0:addCardRoles(1)
	arg_7_0:addCardRoles(2, 1, var_7_2)
	arg_7_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_7_0)
end

function var_0_0.doObjsAttrsCorrect(arg_8_0, arg_8_1, arg_8_2)
	battlePlay.Gate.doObjsAttrsCorrect(arg_8_0, arg_8_1, arg_8_2)

	local var_8_0 = arg_8_0.data.boss_hp_threshold

	arg_8_0.curBoss.attrs:setBaseAttr("hpMax", var_8_0)
	arg_8_0.curBoss.attrs:setBase2Attr("hpMax", var_8_0)
	arg_8_0.curBoss:setHP(var_8_0, var_8_0)
end

function var_0_0.refreshUIHp(arg_9_0, arg_9_1)
	if arg_9_0.curBoss ~= arg_9_1 then
		return
	end

	local var_9_0 = arg_9_1:getTakeDamageRecord(battle.ValueType.normal)
	local var_9_1 = arg_9_0.data.boss_hp_threshold

	arg_9_0:setRecoverHp(var_9_0)

	arg_9_0.curtotalTakeDamage = var_9_0

	if var_9_1 < var_9_0 then
		arg_9_0.curtotalTakeDamage = var_9_1
	end

	battleEasy.deferNotifyCantJump(nil, "refreshBossHp", var_9_1 - arg_9_0.curtotalTakeDamage, var_9_1)
end

function var_0_0.makeEndViewInfos(arg_10_0)
	local var_10_0 = arg_10_0.curBoss:getTakeDamageRecord(battle.ValueType.normal)

	arg_10_0.bossTotalTakeDamage = var_10_0

	return {
		result = arg_10_0.result,
		damage = var_10_0,
		finalDamage = math.floor(arg_10_0.data.boss_hp_threshold - arg_10_0.curBoss:hp())
	}
end

function var_0_0.sendParams(arg_11_0)
	return arg_11_0.scene.battleID, math.floor(arg_11_0.data.boss_hp_threshold - arg_11_0.curBoss:hp()), battlePlay.Gate.sendActionParams(arg_11_0)
end

function var_0_0.postEndResultToServer(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:makeEndViewInfos()

	gRootViewProxy:raw():postEndResultToServer("/game/mimicry/battle/end", {
		cb = function(arg_13_0)
			arg_12_1(var_12_0, arg_13_0)
		end
	}, arg_12_0:sendParams())
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

local var_0_1 = class("MimicryGateRecord", var_0_0)

battlePlay.MimicryGateRecord = var_0_1
var_0_1.CommonArgs = {
	AntiMode = battle.GateAntiMode.Normal
}
var_0_1.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = true,
	canPause = true,
	canSkip = false
}

function var_0_1.init(arg_16_0, arg_16_1)
	if not arg_16_1.actions then
		arg_16_0.OperatorArgs = var_0_0.OperatorArgs
	end

	battlePlay.MimicryGate.init(arg_16_0, arg_16_1)

	arg_16_0.actionRecv = arg_16_1.actions
end

function var_0_1.getActionRecv(arg_17_0)
	local var_17_0 = table.get(arg_17_0.actionRecv, arg_17_0.curRound, arg_17_0.curBattleRound)

	if var_17_0 == nil then
		return
	end

	if var_17_0[1] == 0 then
		return
	end

	return unpack(var_17_0)
end

function var_0_1.sendParams(arg_18_0)
	local var_18_0 = arg_18_0:makeEndViewInfos()

	return arg_18_0.scene.battleID, math.floor(arg_18_0.data.boss_hp_threshold - arg_18_0.curBoss:hp())
end

function var_0_1.checkBattleEnd(arg_19_0)
	if arg_19_0.scene.isBattleAllEnd then
		return true, arg_19_0.result
	end

	return battlePlay.Gate.checkBattleEnd(arg_19_0)
end

function var_0_1.onceBattle(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0, var_20_1, var_20_2 = arg_20_0:getActionRecv()

	if (var_20_0 or 0) ~= 0 and var_20_0 ~= arg_20_0.curHero.seat then
		arg_20_0.result = "fail"
		arg_20_0.scene.isBattleAllEnd = true

		arg_20_0:onOver()

		return
	end

	if (var_20_2 or 0) ~= 0 then
		arg_20_0.scene.autoFight = false

		battlePlay.Gate.onceBattle(arg_20_0, var_20_1, var_20_2)

		arg_20_0.scene.autoFight = true

		if arg_20_0.waitInput then
			error("why input be wait in record")
		end

		return
	end

	battlePlay.Gate.onceBattle(arg_20_0, arg_20_1, arg_20_2)
end
