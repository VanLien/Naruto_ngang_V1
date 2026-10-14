local var_0_0 = class("Gate")

battlePlay.Gate = var_0_0
var_0_0.ForceNumber = 6
var_0_0.ObjectNumber = 12
var_0_0.OperatorArgs = {
	canHandle = false,
	isAuto = true,
	isFullManual = false,
	canSpeedAni = false,
	canPause = false,
	canSkip = false
}

local var_0_1 = {
	0,
	0,
	0
}
local var_0_2 = {
	craftMods = {
		refreshUIHp = function(arg_1_0)
			local var_1_0 = -1
			local var_1_1 = -1
			local var_1_2 = arg_1_0.scene:getObject(arg_1_0.forceToObjId[1])
			local var_1_3 = arg_1_0.scene:getObject(arg_1_0.forceToObjId[2])

			if var_1_2 then
				var_1_0 = var_1_2:hp() / var_1_2:hpMax()
			end

			if var_1_3 then
				var_1_1 = var_1_3:hp() / var_1_3:hpMax()
			end

			battleEasy.deferNotify(nil, "changeHpMp", {
				selfHpRatio = var_1_0,
				enemyHpRatio = var_1_1
			})
		end,
		refreshUIMp = function(arg_2_0)
			local var_2_0 = -1
			local var_2_1 = -1
			local var_2_2 = arg_2_0.scene:getObject(arg_2_0.forceToObjId[1])
			local var_2_3 = arg_2_0.scene:getObject(arg_2_0.forceToObjId[2])

			if var_2_2 then
				var_2_0 = var_2_2:mp1() / var_2_2:mp1Max()
			end

			if var_2_3 then
				var_2_1 = var_2_3:mp1() / var_2_3:mp1Max()
			end

			battleEasy.deferNotify(nil, "changeHpMp", {
				selfMpRatio = var_2_0,
				enemyMpRatio = var_2_1
			})
		end,
		newWaveAddObjsStrategy = function(arg_3_0)
			if arg_3_0.curWave == 1 then
				battleEasy.deferNotify(nil, "initPvp")
			end

			arg_3_0:refreshUIHp()
			arg_3_0:refreshUIMp()
		end
	}
}

var_0_0.CommonArgs = {
	AntiMode = battle.GateAntiMode.Normal
}
var_0_0.UIOpition = {
	craftMods = false
}
var_0_0.PlayCsvFunc = {}
var_0_0.SpecEndRuleCheck = {}
var_0_0.SpecEndRuleCheckArgs = {}

function var_0_0.ctor(arg_4_0, arg_4_1)
	arg_4_0.scene = arg_4_1
	arg_4_0.waveCount = arg_4_1.sceneConf.sceneCount
	arg_4_0.roundLimit = arg_4_1.sceneConf.roundLimit
	arg_4_0.curWave = 0
	arg_4_0.curRound = 0
	arg_4_0.curBattleRound = 0
	arg_4_0.totalRound = 0
	arg_4_0.totalRoundBattleTurn = 0
	arg_4_0.curHero = nil
	arg_4_0.nextHeros = {}
	arg_4_0.roundHasAttackedHeros = {}
	arg_4_0.roundLeftHeros = {}
	arg_4_0.roundHasAttackedHistory = {}
	arg_4_0.attackerArray = {}
	arg_4_0.result = nil
	arg_4_0.nowChooseID = nil
	arg_4_0.curBattleRoundAttack = false
	arg_4_0.seeBoss = false
	arg_4_0.showBossInfo = false
	arg_4_0.battleTurnInfoTb = {}
	arg_4_0.speedSortRule = {}
	arg_4_0.statsRecordTb = {}
	arg_4_0.forceAdd = {}
	arg_4_0.recoverMp2RoundLimit = 3
	arg_4_0.operateForce = arg_4_1.data.operateForce or 1
	arg_4_0.handleInput = {}
	arg_4_0.ruleRecordData = {}
	arg_4_0.curHeroRoundInfo = {}
	arg_4_0.attackSign = {}
	arg_4_0.hasAttackedSign = {}
	arg_4_0.lethalDatas = {}
	arg_4_0.actionSend = {}
	arg_4_0.specModuleFunc = nil
	arg_4_0.battleRoundTriggerId = nil
end

function var_0_0.initFightOperatorMode(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = arg_5_0.scene.sceneTag or {}

	for iter_5_0, iter_5_1 in pairs(arg_5_0.OperatorArgs) do
		var_5_0[iter_5_0] = iter_5_1
	end

	var_5_0.canHandle = battleEasy.ifElse(var_5_1.canHandle ~= nil, var_5_1.canHandle, var_5_0.canHandle)
	var_5_0.isAuto = battleEasy.ifElse(var_5_1.isAuto ~= nil, var_5_1.isAuto, var_5_0.isAuto)

	arg_5_0.scene:setAutoFight(var_5_0.isAuto)
	arg_5_0.scene:setFullManual(var_5_0.canHandle and var_5_0.isFullManual)
	gRootViewProxy:notify("setOperators", var_5_0)
end

function var_0_0.init(arg_6_0, arg_6_1)
	arg_6_0.data = arg_6_1

	arg_6_0:initFightOperatorMode()
	arg_6_0:initSpecModule()
	gRootViewProxy:notify("setWaveNumber", arg_6_0.curWave, arg_6_0.waveCount)
	gRootViewProxy:notify("fightStart")
	gRootViewProxy:proxy():showMainUI(true)
end

function var_0_0.initSpecModule(arg_7_0)
	if arg_7_0.UIOpition.craftMods then
		gRootViewProxy:proxy():addSpecModule(battleModule.craftMods)

		arg_7_0.specModuleFunc = var_0_2.craftMods
	end

	arg_7_0:notifyToSpecModule("init")
end

function var_0_0.notifyToSpecModule(arg_8_0, arg_8_1, ...)
	if not arg_8_0.specModuleFunc then
		return
	end

	local var_8_0 = arg_8_0.specModuleFunc[arg_8_1]

	if var_8_0 then
		var_8_0(arg_8_0, ...)
	end
end

function var_0_0.checkSpecModule(arg_9_0, arg_9_1)
	return arg_9_0.UIOpition[arg_9_1] or false
end

function var_0_0.getEnemyRoleOutT(arg_10_0, arg_10_1)
	local var_10_0 = {}
	local var_10_1 = arg_10_0:getMonsterCsv(arg_10_0.scene.sceneID, arg_10_1)

	if not var_10_1 then
		return {}
	end

	arg_10_0.showBossInfo = var_10_1.showInfo

	local var_10_2 = arg_10_0.scene.sceneConf.boss

	for iter_10_0, iter_10_1 in ipairs(var_10_1.monsters) do
		if iter_10_1 > 0 then
			local var_10_3 = false

			if var_10_1.bossMark and var_10_1.bossMark[iter_10_0] == 1 then
				arg_10_0.seeBoss = true
				var_10_3 = true
			end

			local var_10_4 = {
				advance = 0,
				isMonster = true,
				roleForce = 2,
				roleId = iter_10_1,
				level = arg_10_0.scene.sceneLevel,
				skillLevel = arg_10_0.scene.skillLevel,
				showLevel = arg_10_0.scene.showLevel,
				isBoss = var_10_3
			}

			var_10_0[iter_10_0 + arg_10_0.ForceNumber] = var_10_4
		end
	end

	return {
		[arg_10_1] = var_10_0
	}
end

function var_0_0.addCardRoles(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0.scene:getHerosMap(arg_11_1 == arg_11_0.operateForce and 1 or 2)

	for iter_11_0, iter_11_1 in var_11_0:order_pairs() do
		if not arg_11_5 or iter_11_1:isDeath() then
			arg_11_0.scene:onObjDel(iter_11_1)
		end
	end

	if not arg_11_5 then
		var_11_0:clear()
	end

	arg_11_0.scene.herosOrder = nil

	local var_11_1 = arg_11_3 or arg_11_0.data.roleOut
	local var_11_2 = arg_11_2 and var_11_1[arg_11_2] or var_11_1
	local var_11_3 = arg_11_4 or arg_11_0.data.roleOut2
	local var_11_4 = arg_11_2 and var_11_3[arg_11_2] or var_11_3
	local var_11_5 = arg_11_1 == 1 and 0 or arg_11_0.ForceNumber
	local var_11_6 = 0

	for iter_11_2 = 1 + var_11_5, arg_11_0.ForceNumber + var_11_5 do
		local var_11_7 = var_11_2[iter_11_2]
		local var_11_8 = arg_11_0.operateForce == 2 and battleEasy.mirrorSeat(iter_11_2) or iter_11_2

		if var_11_7 then
			var_11_6 = var_11_6 + 1

			local var_11_9 = arg_11_0:createObjectModel(arg_11_1, var_11_8)

			if var_11_4 and next(var_11_4) then
				var_11_7.role2Data = var_11_4[iter_11_2]
			end

			var_11_9:init(var_11_7)
			var_11_0:insert(var_11_9.id, var_11_9)

			if var_11_9.isBoss then
				arg_11_0:setBoss(var_11_9)
			end
		end
	end

	if arg_11_1 == arg_11_0.operateForce and (not arg_11_2 or arg_11_2 == 1) then
		arg_11_0.scene.forceRecordTb[1].herosStartCount = var_11_6
	end

	arg_11_0.scene:createGroupObj(arg_11_1, battle.SpecialObjectId.teamShiled)
	table.insert(arg_11_0.forceAdd, arg_11_1)
end

function var_0_0.addCardRole(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0.scene:getObjectBySeatExcludeDead(arg_12_1)
	local var_12_1 = arg_12_0.scene:getObjectBySeatExcludeDead(arg_12_1, battle.ObjectType.SummonFollow)
	local var_12_2 = arg_12_2.isFollowMode

	if var_12_2 and var_12_1 then
		return
	end

	local var_12_3 = arg_12_1 > 6 and 2 or 1

	if var_12_2 then
		var_12_3 = arg_12_4
	else
		if var_12_0 then
			if arg_12_3 then
				arg_12_0.scene:onObjDel(var_12_0)
			else
				return
			end
		end

		if arg_12_4 then
			var_12_3 = arg_12_4
			arg_12_1 = -1
		end
	end

	if arg_12_2 then
		local var_12_4

		if var_12_2 then
			var_12_4 = arg_12_0:createExtraObjectModel(var_12_3, arg_12_1)

			var_12_4:init(arg_12_2)
			arg_12_0.scene:addExtraObj(var_12_3, var_12_4)
		else
			var_12_4 = arg_12_0:createObjectModel(var_12_3, arg_12_1)

			var_12_4:init(arg_12_2)

			if arg_12_4 then
				var_12_4.force = var_12_3

				var_12_4.view:proxy():updateFaceTo(var_12_4.force)
				arg_12_0.scene:addBackStageObj(var_12_4)
			else
				arg_12_0.scene:addObj(var_12_3, var_12_4)
			end
		end

		if var_12_4.isBoss then
			arg_12_0:setBoss(var_12_4)
		end

		return var_12_4
	end
end

function var_0_0.setBoss(arg_13_0, arg_13_1)
	arg_13_0.curBoss = arg_13_1
end

function var_0_0.createObjectModel(arg_14_0, arg_14_1, arg_14_2)
	return ObjectModel.new(arg_14_0.scene, arg_14_2)
end

function var_0_0.createExtraObjectModel(arg_15_0, arg_15_1, arg_15_2)
	return ObjectExtraModel.new(arg_15_0.scene, arg_15_2)
end

function var_0_0.doObjsAttrsCorrect(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.scene.sceneID

	if arg_16_1 then
		arg_16_0.scene.forceRecordTb[1].totalFightPoint = arg_16_0.scene:getTotalForceFightPoint(1)
	end

	if arg_16_2 then
		local var_16_1 = arg_16_0:getMonsterCsv(var_16_0, arg_16_0.curWave)

		if var_16_1 then
			for iter_16_0, iter_16_1 in arg_16_0.scene:ipairsHeros() do
				if iter_16_1:serverForce() == 2 then
					iter_16_1:objAttrsCorrectMonster(var_16_1)
				end
			end
		end

		arg_16_0.scene.forceRecordTb[2].totalFightPoint = arg_16_0.scene:getTotalForceFightPoint(2)
	end

	local var_16_2 = gSceneAttrCorrect[var_16_0]
	local var_16_3 = gSceneAttrCorrect[-var_16_0]

	for iter_16_2, iter_16_3 in arg_16_0.scene:ipairsHeros() do
		if arg_16_1 and iter_16_3:serverForce() == 1 or arg_16_2 and iter_16_3:serverForce() == 2 then
			local var_16_4 = iter_16_3:serverForce() == 1 and var_16_2 or var_16_3

			if var_16_4 then
				iter_16_3:objAttrsCorrectScene(var_16_4)
			end

			local var_16_5 = arg_16_0.scene.forceRecordTb[iter_16_3.force].totalFightPoint or 0
			local var_16_6 = arg_16_0.scene.forceRecordTb[3 - iter_16_3.force].totalFightPoint or 0

			if var_16_5 < var_16_6 then
				iter_16_3:objAttrsCorrectCP(var_16_5, var_16_6)
			end
		end

		if not iter_16_3:isAlreadyDead() then
			local var_16_7 = iter_16_3.seat

			arg_16_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.totalHp, iter_16_3:hpMax(), var_16_7)
		end
	end
end

function var_0_0.triggerAllPassiveSkills(arg_17_0)
	arg_17_0.scene:onAllPassive(battle.PassiveSkillTypes.enter)

	for iter_17_0, iter_17_1 in arg_17_0.scene:ipairsHeros() do
		if not iter_17_1:isAlreadyDead() then
			iter_17_1:initedTriggerPassiveSkill(true)
		end
	end

	arg_17_0.scene:updateBuffEveryRound(battle.BuffTriggerPoint.onHolderAfterEnter)
end

function var_0_0.getSortOrderTb(arg_18_0)
	if arg_18_0.sortOrderTb then
		return arg_18_0.sortOrderTb
	end

	return {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12
	}
end

function var_0_0.ipairsByGateOrder(arg_19_0)
	local var_19_0 = arg_19_0:getSortOrderTb()
	local var_19_1 = 0

	return function()
		var_19_1 = var_19_1 + 1

		local var_20_0 = var_19_0[var_19_1]

		return var_20_0 and var_19_1, var_20_0
	end
end

function var_0_0.newWaveAddObjsStrategy(arg_21_0)
	lazylog.battle.gate.newWave(" ---- 每一波开始时, 打印双方角色未触发被动之前的原始数据(已计算场景修正)：", function()
		for iter_22_0, iter_22_1 in arg_21_0.scene.heros:order_pairs() do
			printDebug(" -- 己方: id=%s, hp=%s, haMax=%s, atk=%s, def=%s, speed=%s", iter_22_1.id, iter_22_1:hp(), iter_22_1:hpMax(), iter_22_1:damage(), iter_22_1:defence(), iter_22_1:speed())
		end

		for iter_22_2, iter_22_3 in arg_21_0.scene.enemyHeros:order_pairs() do
			printDebug(" -- 敌方: id=%s, hp=%s, haMax=%s, atk=%s, def=%s, speed=%s", iter_22_3.id, iter_22_3:hp(), iter_22_3:hpMax(), iter_22_3:damage(), iter_22_3:defence(), iter_22_3:speed())
		end
	end)
	arg_21_0:notifyToSpecModule("newWaveAddObjsStrategy")
end

function var_0_0.onNewWavePlayAni(arg_23_0)
	arg_23_0.curWave = arg_23_0.curWave + 1
	arg_23_0.curRound = 0
	arg_23_0.totalRoundBattleTurn = 0

	battleEasy.queueEffect("delay", {
		lifetime = 800
	})
	gRootViewProxy:notify("setWaveNumber", arg_23_0.curWave, arg_23_0.waveCount)
	gRootViewProxy:notify("playWaveAni", arg_23_0.curWave, arg_23_0.waveCount)
	battleEasy.queueEffect("delay", {
		lifetime = 300
	})
	arg_23_0.scene:waitNewWaveAniDone()
end

function var_0_0.playEnterAnimation(arg_24_0, arg_24_1)
	local var_24_0 = false
	local var_24_1 = false

	for iter_24_0, iter_24_1 in pairs(arg_24_0.forceAdd) do
		if iter_24_1 == 1 then
			var_24_0 = true
		elseif iter_24_1 == 2 then
			var_24_1 = true
		end
	end

	arg_24_0.forceAdd = {}

	battleEasy.queueNotify("enterAnimation", var_24_0 and arg_24_0.scene:getForceIDs(1) or nil, var_24_1 and arg_24_0.scene:getForceIDs(2) or nil, true)
	arg_24_0.scene:insertPlayCustomWait("enter_animation", arg_24_1)
end

function var_0_0.onNewWave(arg_25_0)
	battleEasy.queueEffect("delay", {
		lifetime = 1000
	})

	if arg_25_0.seeBoss then
		local var_25_0 = display.director:getScheduler():getTimeScale()

		display.director:getScheduler():setTimeScale(battle.SpeedTimeScale.single)
		battleEasy.queueNotify("showBossComeView", arg_25_0.showBossInfo)
		arg_25_0.scene:insertPlayCustomWait("new_wave_see_boss", function()
			display.director:getScheduler():setTimeScale(var_25_0)
			arg_25_0:newWaveAddObjsStrategy()
			arg_25_0:playEnterAnimation(function()
				arg_25_0:newWaveGoon()
			end)
		end)
	else
		arg_25_0:newWaveAddObjsStrategy()
		arg_25_0:playEnterAnimation(function()
			arg_25_0:newWaveGoon()
		end)
	end
end

function var_0_0.newWaveGoon(arg_29_0)
	arg_29_0:checkGuide(function()
		arg_29_0.scene:cleanInWaveGoon()

		for iter_30_0, iter_30_1 in arg_29_0.scene:ipairsHeros() do
			iter_30_1:onNewWave()
		end

		arg_29_0:newWaveGoonAfter()
	end, {
		round = battle.GuideTriggerPoint.Wave + arg_29_0.curWave
	})
end

function var_0_0.newWaveGoonAfter(arg_31_0)
	arg_31_0.scene:resetPlaceIdInfo(1)
	arg_31_0.scene:resetPlaceIdInfo(2)

	arg_31_0.scene.realDeadCounter = 1
	arg_31_0.nextHeros = {}

	gRootViewProxy:proxy():flushCurDeferList()

	return arg_31_0.scene:newRound()
end

function var_0_0.onNewRound(arg_32_0)
	arg_32_0.curRound = arg_32_0.curRound + 1
	arg_32_0.totalRound = arg_32_0.totalRound + 1
	arg_32_0.curBattleRound = 0
	arg_32_0.curHero = nil

	if arg_32_0.curRound == 1 then
		arg_32_0:triggerAllPassiveSkills()
	end

	arg_32_0.hasAttackedSign = {}
	arg_32_0.roundHasAttackedHeros = {}
	arg_32_0.roundLeftHeros = {}
	arg_32_0.roundHasAttackedHistory = {}

	for iter_32_0, iter_32_1 in arg_32_0.scene:ipairsHeros() do
		if iter_32_1 and not iter_32_1:isRealDeath() then
			table.insert(arg_32_0.roundLeftHeros, {
				obj = iter_32_1
			})
		end
	end

	arg_32_0.scene:resetPlaceIdInfo(1)
	arg_32_0.scene:resetPlaceIdInfo(2)

	for iter_32_2, iter_32_3 in arg_32_0.scene:ipairsHeros() do
		iter_32_3:onNewRound()
	end

	arg_32_0.scene:updateBuffEveryRound(battle.BuffTriggerPoint.onRoundStart)
	arg_32_0.scene:checkObjsDeadState()
	gRootViewProxy:proxy():flushCurDeferList()
	arg_32_0.scene:newRoundBattleTurn()
end

function var_0_0.getObjectBaseSpeedRankSortKey(arg_33_0, arg_33_1)
	return arg_33_1.id
end

function var_0_0.speedRankSort(arg_34_0)
	local var_34_0 = {}
	local var_34_1 = itertools.filter(arg_34_0.roundLeftHeros, function(arg_35_0, arg_35_1)
		local var_35_0 = arg_35_1.obj

		if not var_35_0 or var_35_0:isRealDeath() then
			table.insert(var_34_0, arg_35_0)

			return nil
		end

		return arg_35_1
	end)

	for iter_34_0 = table.length(var_34_0), 1, -1 do
		table.remove(arg_34_0.roundLeftHeros, var_34_0[iter_34_0])
	end

	if not next(var_34_1) then
		return false
	end

	local var_34_2 = {}

	for iter_34_1, iter_34_2 in ipairs(var_34_1) do
		local var_34_3 = iter_34_2.obj
		local var_34_4 = iter_34_2.another and var_34_3.unitID % 2 == 0

		table.insert(var_34_2, {
			key = iter_34_1,
			speedPriority = var_34_3.speedPriority,
			speed = battleEasy.ifElse(var_34_4, var_34_3:speed(0), var_34_3:speed()),
			objId = arg_34_0:getObjectBaseSpeedRankSortKey(var_34_3),
			reset = iter_34_2.reset,
			atOnce = iter_34_2.atOnce,
			buffCfgId = iter_34_2.buffCfgId,
			force = var_34_3.force,
			geminiSpecialDeal = var_34_4 and 1 or 2
		})
	end

	local function var_34_5(arg_36_0, arg_36_1)
		return arg_36_1 < arg_36_0
	end

	local function var_34_6(arg_37_0, arg_37_1)
		return arg_37_0 < arg_37_1
	end

	local var_34_7 = {
		{
			name = "reset",
			checkFunc = var_34_5
		},
		{
			name = "atOnce",
			checkFunc = var_34_5
		},
		{
			name = "speedPriority",
			checkFunc = var_34_5
		},
		{
			name = "speed",
			checkFunc = var_34_5
		},
		{
			name = "objId",
			checkFunc = var_34_6
		},
		{
			name = "geminiSpecialDeal",
			checkFunc = var_34_5
		}
	}

	table.sort(var_34_2, function(arg_38_0, arg_38_1)
		for iter_38_0, iter_38_1 in ipairs(var_34_7) do
			local var_38_0 = arg_38_0[iter_38_1.name]
			local var_38_1 = arg_38_1[iter_38_1.name]

			if iter_38_0 == #var_34_7 then
				return iter_38_1.checkFunc(var_38_0, var_38_1)
			end

			if var_38_0 and var_38_1 then
				if var_38_0 ~= var_38_1 then
					return iter_38_1.checkFunc(var_38_0, var_38_1)
				end
			elseif var_38_0 then
				return true
			elseif var_38_1 then
				return false
			end
		end
	end)

	for iter_34_3, iter_34_4 in ipairs(arg_34_0.speedSortRule) do
		iter_34_4.sort(var_34_2)
	end

	local var_34_8 = {}
	local var_34_9 = {}

	arg_34_0.attackSign = {}

	for iter_34_5, iter_34_6 in ipairs(var_34_2) do
		local var_34_10 = var_34_1[iter_34_6.key].obj

		table.insert(var_34_9, var_34_10)

		local var_34_11 = 0
		local var_34_12 = 0

		if var_34_10.multiShapeTb then
			var_34_11 = battleEasy.ifElse(var_34_10.orginUnitId % 2 ~= 0, var_34_10.orginUnitId, var_34_10.data.role2Data.roleId)

			if not var_34_1[iter_34_6.key].another and var_34_10.multiShapeTb[1] % 2 == var_34_10.orginUnitId % 2 then
				var_34_12 = var_34_11
			end
		end

		if not var_34_1[iter_34_6.key].another then
			var_34_11 = 0
		else
			var_34_12 = var_34_11
		end

		local var_34_13 = tostring(var_34_10.id) .. tostring(var_34_12)

		if not var_34_8[var_34_13] then
			table.insert(arg_34_0.attackSign, var_34_11)

			var_34_8[var_34_13] = true
		end
	end

	local var_34_14 = var_34_2[1] and var_34_1[var_34_2[1].key]

	if not next(arg_34_0.nextHeros) then
		arg_34_0.extraBattleRoundData = var_34_14
		arg_34_0.extraBattleRoundData.mode = var_34_14.mode or battle.ExtraBattleRoundMode.normal
		arg_34_0.battleRoundTriggerId = battleEasy.getRoundTriggerId(var_34_14.buffCfgId)
	else
		arg_34_0.extraBattleRoundData = nil
	end

	arg_34_0:setLeftHerosIndex(var_34_14)

	arg_34_0.attackerArray = var_34_9

	return true
end

function var_0_0.getExtraBattleRoundData(arg_39_0, arg_39_1)
	if arg_39_0.extraBattleRoundData then
		return arg_39_0.extraBattleRoundData[arg_39_1]
	end
end

function var_0_0.setLeftHerosIndex(arg_40_0, arg_40_1)
	arg_40_0.leftHerosFirstIndex = nil

	for iter_40_0, iter_40_1 in ipairs(arg_40_0.roundLeftHeros) do
		if arg_40_1 == iter_40_1 then
			arg_40_0.leftHerosFirstIndex = iter_40_0

			break
		end
	end
end

function var_0_0.getTopCardsAttrAvg(arg_41_0, arg_41_1)
	if not arg_41_0.topCardsAttrAvg then
		arg_41_0.topCardsAttrAvg = {}

		local var_41_0 = {
			"speed",
			"damage",
			"specialDamage",
			"hp",
			"defence",
			"specialDefence"
		}
		local var_41_1 = arg_41_0.data.top_cards_data and arg_41_0.data.top_cards_data.top_cards or {}
		local var_41_2
		local var_41_3

		for iter_41_0, iter_41_1 in ipairs(var_41_1) do
			if arg_41_1 < iter_41_0 then
				break
			end

			local var_41_4 = arg_41_0.data.top_cards_data.card_attrs[iter_41_1]

			for iter_41_2, iter_41_3 in ipairs(var_41_0) do
				arg_41_0.topCardsAttrAvg[iter_41_3] = (arg_41_0.topCardsAttrAvg[iter_41_3] or 0) + var_41_4[iter_41_3]

				if iter_41_0 == arg_41_1 then
					arg_41_0.topCardsAttrAvg[iter_41_3] = arg_41_0.topCardsAttrAvg[iter_41_3] / arg_41_1
				end
			end
		end
	end

	return arg_41_0.topCardsAttrAvg
end

function var_0_0.getSpeedRankArray(arg_42_0)
	local var_42_0 = {}
	local var_42_1 = {}

	for iter_42_0, iter_42_1 in ipairs(arg_42_0.attackerArray) do
		if not var_42_0[iter_42_1.id] or arg_42_0.attackSign[iter_42_0] ~= 0 then
			table.insert(var_42_1, iter_42_1)

			var_42_0[iter_42_1.id] = true
		end
	end

	local var_42_2 = arraytools.merge({
		arg_42_0.attackSign,
		{
			0
		},
		arg_42_0.hasAttackedSign
	})

	return arraytools.merge({
		var_42_1,
		{
			{
				seat = 99999
			}
		},
		arg_42_0.roundHasAttackedHeros
	}), var_42_2
end

function var_0_0.getSpeedRankArrayDeduplication(arg_43_0)
	local var_43_0 = {}
	local var_43_1 = {}
	local var_43_2
	local var_43_3 = arg_43_0:getSpeedRankArray()

	for iter_43_0, iter_43_1 in ipairs(var_43_3) do
		if not var_43_0[iter_43_1.seat] and iter_43_1.seat <= arg_43_0.ObjectNumber then
			table.insert(var_43_1, iter_43_1)

			local var_43_4 = arg_43_0.scene:getObjectBySeatExcludeDead(iter_43_1.seat, battle.ObjectType.SummonFollow)

			if var_43_4 then
				table.insert(var_43_1, var_43_4)
			end

			var_43_0[iter_43_1.seat] = true
		end
	end

	return var_43_1
end

function var_0_0.getObjsNotInSpeedRank(arg_44_0)
	local var_44_0 = {}

	for iter_44_0, iter_44_1 in ipairs(arg_44_0:getSpeedRankArray()) do
		if iter_44_1 and iter_44_1.seat <= arg_44_0.ObjectNumber then
			var_44_0[iter_44_1.seat] = true
		end
	end

	local var_44_1 = {}

	for iter_44_2, iter_44_3 in arg_44_0.scene:ipairsHeros() do
		if not iter_44_3:isAlreadyDead() and not var_44_0[iter_44_3.seat] then
			table.insert(var_44_1, iter_44_3)
		end
	end

	return var_44_1
end

function var_0_0.onNewBattleTurn(arg_45_0)
	arg_45_0.battleRoundTriggerId = nil
	arg_45_0.curBattleRound = arg_45_0.curBattleRound + 1
	arg_45_0.totalRoundBattleTurn = arg_45_0.totalRoundBattleTurn + 1
	arg_45_0.handleInput = nil

	log.battle.gate.onNewBattleTurn("---------- gate onNewBattleTurn() ---------- =", arg_45_0.curBattleRound, arg_45_0.totalRoundBattleTurn)

	arg_45_0.battleTurnInfoTb = {}

	arg_45_0:onTurnStartSupply()

	if not itertools.include(arg_45_0.roundLeftHeros, function(arg_46_0)
		return arg_45_0.curHero and arg_46_0.obj.id == arg_45_0.curHero.id
	end) and not itertools.include(arg_45_0.roundHasAttackedHeros, arg_45_0.curHero) and not itertools.include(arg_45_0.scene.backHeros, arg_45_0.curHero) and not itertools.include(arg_45_0.scene.extraHeros, arg_45_0.curHero) then
		table.insert(arg_45_0.roundHasAttackedHeros, arg_45_0.curHero)
		table.insert(arg_45_0.hasAttackedSign, arg_45_0.curHero and 0)
	end

	if arg_45_0.curHero and not arg_45_0.scene:beInExtraAttack() then
		table.insert(arg_45_0.roundHasAttackedHistory, {
			id = arg_45_0.curHero.id,
			force = arg_45_0.curHero.force
		})
	end

	if arg_45_0.curHero then
		local var_45_0 = not itertools.include(arg_45_0.roundLeftHeros, function(arg_47_0)
			return arg_47_0.obj.id == arg_45_0.curHero.id
		end)
		local var_45_1 = not itertools.include(arg_45_0.roundHasAttackedHeros, arg_45_0.curHero)

		if arg_45_0.curHero.multiShapeTb and (var_45_0 or var_45_1) then
			local var_45_2 = battleEasy.ifElse(arg_45_0.curHero.orginUnitId % 2 ~= 0, arg_45_0.curHero.data.role2Data.roleId, arg_45_0.curHero.orginUnitId)

			if not var_45_1 then
				var_45_2 = battleEasy.ifElse(arg_45_0.curHero.orginUnitId % 2 == 0, arg_45_0.curHero.data.role2Data.roleId, arg_45_0.curHero.orginUnitId)
			end

			if arg_45_0.curHero.multiShapeTb[1] % 2 == arg_45_0.curHero.orginUnitId % 2 and var_45_1 or var_45_0 then
				table.insert(arg_45_0.roundHasAttackedHeros, arg_45_0.curHero)
				table.insert(arg_45_0.hasAttackedSign, var_45_2)
			end
		end
	end

	local var_45_3 = arg_45_0:speedRankSort()

	arg_45_0.scene:updateBuffEveryTurn(battle.BuffTriggerPoint.onBattleTurnStart)
	arg_45_0.scene:resetPlaceIdInfo(1)
	arg_45_0.scene:resetPlaceIdInfo(2)

	if not var_45_3 and not next(arg_45_0.nextHeros) then
		arg_45_0:checkBattleState()

		return
	end

	arg_45_0:setCurHero()
	gRootViewProxy:proxy():flushCurDeferList()
	logf.battle.gate.curHero(" 当前行动者: curHero: %d:", arg_45_0.curHero.seat)

	arg_45_0.curHero.isInBattleTurn = true

	for iter_45_0, iter_45_1 in ipairs(arg_45_0:getSpeedRankArrayDeduplication()) do
		iter_45_1:onNewBattleTurn()
	end

	arg_45_0.scene:checkObjsDeadState()
	arg_45_0.curHero:updateSkillState(true)

	arg_45_0.curBattleRoundAttack = arg_45_0.curHero:canAttack()

	arg_45_0.scene:onSubModulesNewBattleTurn()
	gRootViewProxy:proxy():flushCurDeferList()
	arg_45_0.scene:onSubModulesNewBattleTurn2()
	arg_45_0:autoChoose()
	arg_45_0.scene:waitNewBattleRoundAniDone()
end

function var_0_0.newBattleTurnGoon(arg_48_0)
	arg_48_0:checkGuide(function()
		if arg_48_0.curHero and not arg_48_0.curHero:isAlreadyDead() then
			arg_48_0:onceBattle()
		else
			arg_48_0:checkBattleState()
		end
	end, {
		heroId = arg_48_0.curHero.seat
	})
end

function var_0_0.setCurHero(arg_50_0)
	arg_50_0.curHero = nil
	arg_50_0.curHeroRoundInfo = {}

	while not arg_50_0.curHero and next(arg_50_0.nextHeros) do
		arg_50_0.curHero = arg_50_0.scene:getObjectExcludeDead(arg_50_0.nextHeros[1])

		table.remove(arg_50_0.nextHeros, 1)
	end

	if not arg_50_0.curHero then
		arg_50_0.curHero = arg_50_0.attackerArray[1]

		if arg_50_0.leftHerosFirstIndex then
			arg_50_0.curHeroRoundInfo = arg_50_0.roundLeftHeros[arg_50_0.leftHerosFirstIndex]

			table.remove(arg_50_0.roundLeftHeros, arg_50_0.leftHerosFirstIndex)

			arg_50_0.leftHerosFirstIndex = nil
		end
	end
end

function var_0_0.isPlaying(arg_51_0)
	return arg_51_0.result == nil
end

function var_0_0.isMyTurn(arg_52_0)
	return arg_52_0.curHero and arg_52_0.curHero.force == 1
end

function var_0_0.isNowTurnAutoFight(arg_53_0)
	if arg_53_0.scene.autoFight then
		return true
	end

	if not arg_53_0:isMyTurn() and not arg_53_0.scene.fullManual then
		return true
	end

	if arg_53_0.curHero and (arg_53_0.curHero:isSelfChargeOK() or arg_53_0.curHero:isNeedAutoFightByBuff()) then
		return true
	end
end

function var_0_0.beginBattleTurn(arg_54_0)
	return arg_54_0.curHero:canAttack()
end

function var_0_0.runBattleTurn(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0.curHero:toAttack(arg_55_1, arg_55_2)
end

function var_0_0.endBattleTurn(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.curHero

	gRootViewProxy:proxy():pushDeferList("playInEndBattleTurn")

	for iter_56_0, iter_56_1 in ipairs(arg_56_0:getSpeedRankArrayDeduplication()) do
		iter_56_1:onBattleTurnEnd()
	end

	arg_56_0.scene:updateBuffEveryTurn(battle.BuffTriggerPoint.onBattleTurnEnd)

	local var_56_1 = gRootViewProxy:proxy():popDeferList("playInEndBattleTurn")

	battleEasy.queueEffect(function()
		battleEasy.queueEffect(function()
			gRootViewProxy:proxy():runDefer(var_56_1)
		end)
	end)
	arg_56_0.scene:endBattleTurn()

	if not arg_56_0.curBattleRoundAttack then
		battleEasy.queueEffect("delay", {
			lifetime = 300
		})
	end

	arg_56_0.curHero.curTargetId = nil
	arg_56_0.curHero.isInBattleTurn = false

	arg_56_0:onTurnEndSupply()
	arg_56_0:checkBattleState()
end

function var_0_0.onceBattle(arg_59_0, arg_59_1, arg_59_2)
	if arg_59_2 and arg_59_0.CommonArgs.AntiMode == battle.GateAntiMode.Operate then
		table.set(arg_59_0.actionSend, arg_59_0.curRound, arg_59_0.curBattleRound, {
			arg_59_0.curHero.seat,
			arg_59_1,
			arg_59_2
		})
	end

	return arg_59_0:_onceBattle(arg_59_1, arg_59_2)
end

function var_0_0._onceBattle(arg_60_0, arg_60_1, arg_60_2)
	arg_60_0.curHero.handleChooseTarget = nil

	local var_60_0
	local var_60_1

	if arg_60_0.waitInput or arg_60_0:beginBattleTurn() then
		if arg_60_0.curHero and arg_60_0.curHero:isNeedAutoFightByBuff() then
			var_60_0, var_60_1 = arg_60_0:autoAttack()
		elseif arg_60_0.curHero and arg_60_0.curHero:isSelfChargeOK() then
			local var_60_2 = arg_60_0.curHero.curSkill.id

			var_60_1 = arg_60_0.scene:getObjectExcludeDead(arg_60_0.curHero.chargeSkillTargetId)

			if not var_60_1 or var_60_1 and var_60_1:isAlreadyDead() or var_60_1:isLogicStateExit(battle.ObjectLogicState.cantBeAttack, {
				fromObj = arg_60_0.curHero
			}) then
				var_60_1 = arg_60_0:autoChoose(var_60_2)
			end

			var_60_0 = {
				skill = var_60_2
			}
		elseif (arg_60_0:isMyTurn() or arg_60_0.scene.fullManual) and not arg_60_0.scene.autoFight then
			arg_60_0.waitInput = true

			if not arg_60_1 or not arg_60_2 then
				return
			end

			if arg_60_1 == 0 and arg_60_2 == 0 then
				var_60_0, var_60_1 = arg_60_0:autoAttack()
			else
				var_60_0 = {
					skill = arg_60_2
				}
				var_60_1 = arg_60_0.scene:getObjectBySeatExcludeDead(arg_60_1)
				arg_60_0.curHero.handleChooseTarget = var_60_1
				arg_60_0.nowChooseID = arg_60_1
			end
		else
			var_60_0, var_60_1 = arg_60_0:autoAttack()
		end

		arg_60_0.waitInput = nil

		if arg_60_0.scene.cowEnableCount > 0 then
			cow.proxyWatchBegin()

			arg_60_0.preCalcLethalDatas = {
				{},
				{}
			}

			arg_60_0.scene.play:runBattleTurn(var_60_0, var_60_1)

			local var_60_3 = clone(arg_60_0.preCalcLethalDatas)

			arg_60_0.preCalcLethalDatas = nil

			local var_60_4 = next(var_60_3[1]) or table.length(var_60_3[2]) > 0

			cow.proxyWatchEnd(var_60_4)

			if var_60_4 then
				for iter_60_0, iter_60_1 in ipairs(var_60_3[2]) do
					local var_60_5 = arg_60_0.scene:getObjectExcludeDead(iter_60_1)

					if var_60_5 then
						var_60_5:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderLethal)
					end
				end

				arg_60_0.lethalDatas = var_60_3[1]

				arg_60_0.scene.play:runBattleTurn(var_60_0, var_60_1)

				arg_60_0.lethalDatas = {}
			end
		else
			arg_60_0.scene.play:runBattleTurn(var_60_0, var_60_1)
		end
	end

	arg_60_0:endBattleTurn(var_60_1)
end

function var_0_0.autoAttack(arg_61_0)
	gRootViewProxy:notify("selectedHero")

	local var_61_0

	var_61_0 = arg_61_0:isMyTurn() and 2 or 1

	local var_61_1
	local var_61_2 = {}

	for iter_61_0, iter_61_1 in arg_61_0.curHero:iterSkills() do
		if iter_61_1.skillType2 ~= battle.MainSkillType.PassiveSkill and iter_61_1:canSpell() then
			var_61_2[iter_61_1.skillType2 + 1] = iter_61_0
		end
	end

	if not next(var_61_2) then
		return
	end

	if var_61_2[battle.MainSkillType.BigSkill + 1] then
		var_61_1 = var_61_2[battle.MainSkillType.BigSkill + 1]
	elseif var_61_2[battle.MainSkillType.SmallSkill + 1] then
		var_61_1 = var_61_2[battle.MainSkillType.SmallSkill + 1]
	else
		var_61_1 = var_61_2[battle.MainSkillType.NormalSkill + 1]
	end

	if arg_61_0.curHero.exAttackSkillID then
		var_61_1 = arg_61_0.curHero.exAttackSkillID
	elseif arg_61_0.curHero.exAttackArgs then
		if arg_61_0.curHero.exAttackArgs.skillPowerMap then
			var_61_1 = battleEasy.getItemInPowerMap(var_61_2, arg_61_0.curHero.exAttackArgs.skillPowerMap)
		end
	else
		local var_61_3 = arg_61_0:getExtraBattleRoundData("newSkillId")

		if var_61_3 then
			if arg_61_0.curHero.skillsMap[var_61_3] then
				var_61_1 = var_61_3
			else
				local var_61_4 = csv.skill[var_61_3]
				local var_61_5 = var_61_4 and var_61_4.skillType2

				if var_61_5 and var_61_2[var_61_5 + 1] then
					var_61_1 = var_61_2[var_61_5 + 1]
				end
			end
		end
	end

	var_61_1 = arg_61_0.curHero.skillsMap[var_61_1] or var_61_1

	if not var_61_1 then
		return
	end

	local var_61_6 = arg_61_0:autoChoose(var_61_1)

	logf.battle.gate.autoAttack(" autoAttack, choose skillId= %d, attackId= %d", var_61_1 or 999999, var_61_6 and var_61_6.id or 999999)

	return {
		skill = var_61_1
	}, var_61_6
end

local var_0_3 = {
	function(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		local var_62_0 = csv.skill[arg_62_1]

		if arg_62_1 and var_62_0 then
			if var_62_0.hintTargetType == 1 then
				local var_62_1
				local var_62_2 = arg_62_0.curHero

				if var_62_2 then
					var_62_1 = var_62_2:getSneerObj()

					if var_62_1 and var_62_1:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
						fromObj = var_62_2
					}) then
						var_62_1 = var_62_2:getCanAttackObjs(var_62_1.force)

						local var_62_3 = table.length(var_62_1)

						var_62_1 = var_62_3 > 0 and var_62_1[ymrand.random(1, var_62_3)]
					end
				end

				if var_62_1 and not var_62_1:isAlreadyDead() then
					return true, var_62_1
				end
			else
				arg_62_2 = 3 - arg_62_2
			end
		end

		return false, arg_62_2
	end,
	function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		local var_63_0 = arg_63_0.curHero

		if var_63_0 and var_63_0.exAttackTargetID then
			local var_63_1 = arg_63_0.scene:getFilterObject(var_63_0.exAttackTargetID, {
				fromObj = var_63_0
			}, battle.FilterObjectType.noAlreadyDead, battle.FilterObjectType.excludeObjLevel1)

			if var_63_1 then
				return true, var_63_1
			end

			arg_63_2 = var_63_0.exAttackArgs and var_63_0.exAttackArgs.isFixedForce and var_63_0.exAttackArgs.targetForce or arg_63_2
		end

		return false, arg_63_2
	end,
	function(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		local var_64_0 = arg_64_0.curHero

		if var_64_0 then
			local var_64_1 = arg_64_0:getExtraBattleRoundData("targetId")
			local var_64_2 = arg_64_0.scene:getFilterObject(var_64_1, {
				fromObj = var_64_0
			}, battle.FilterObjectType.noAlreadyDead, battle.FilterObjectType.excludeObjLevel1)

			if var_64_2 then
				return true, var_64_2
			end
		end

		return false, arg_64_2
	end,
	function(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		if arg_65_1 then
			local var_65_0 = arg_65_0.curHero.skills[arg_65_1] or arg_65_0.curHero.passiveSkills[arg_65_1] or arg_65_0.curHero.curSkill

			if var_65_0 then
				if var_65_0.skillFormulaType == battle.SkillFormulaType.fix then
					arg_65_2 = 3
				end

				local var_65_1 = var_65_0:getTargetsHint(var_65_0.cfg.autoHintChoose)

				return false, arg_65_2, var_65_1
			end
		end

		return false, arg_65_2
	end,
	function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
		local var_66_0

		if arg_66_1 then
			var_66_0 = arg_66_0.curHero.skills[arg_66_1] or arg_66_0.curHero.passiveSkills[arg_66_1] or arg_66_0.curHero.curSkill
		end

		local var_66_1 = arg_66_0.scene:getFilterObjects(arg_66_2, {
			fromObj = arg_66_0.curHero,
			skillFormulaType = var_66_0 and var_66_0.skillFormulaType
		}, battle.FilterObjectType.excludeEnvObj, battle.FilterObjectType.noAlreadyDead, battle.FilterObjectType.excludeObjLevel1)

		if arg_66_3 then
			local var_66_2 = itertools.map(arg_66_3, function(arg_67_0, arg_67_1)
				return arg_67_1.id, true
			end)

			arg_66_3 = {}

			for iter_66_0, iter_66_1 in ipairs(var_66_1) do
				if var_66_2[iter_66_1.id] then
					table.insert(arg_66_3, iter_66_1)
				end
			end

			if not itertools.isempty(arg_66_3) then
				var_66_1 = arg_66_3
			end
		end

		return false, arg_66_2, var_66_1
	end
}

function var_0_0.autoChoose(arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_2 or arg_68_0:isMyTurn() and 2 or 1
	local var_68_1
	local var_68_2
	local var_68_3

	for iter_68_0, iter_68_1 in ipairs(var_0_3) do
		local var_68_4, var_68_5, var_68_6 = iter_68_1(arg_68_0, arg_68_1, var_68_0, var_68_3)

		var_68_3 = var_68_6

		local var_68_7 = var_68_5

		if var_68_4 == true then
			return var_68_7
		end

		var_68_0 = var_68_7
	end

	if itertools.isempty(var_68_3) then
		printWarn("%s autoChoose no any target", tostring(arg_68_1))

		arg_68_0.nowChooseID = 0

		return
	end

	local var_68_8 = var_68_3[ymrand.random(1, table.length(var_68_3))]

	arg_68_0.nowChooseID = var_68_8.seat

	return var_68_8
end

function var_0_0.checkBothAllRealDead(arg_69_0)
	return arg_69_0:checkForceAllRealDead(1) and arg_69_0:checkForceAllRealDead(2)
end

function var_0_0.checkForceAllRealDead(arg_70_0, arg_70_1)
	local var_70_0 = arg_70_0.scene:getHerosMap(arg_70_1)

	return not itertools.include(var_70_0, function(arg_71_0)
		return arg_71_0 and not arg_71_0:isRealDeath()
	end)
end

function var_0_0.getRoundLeftHerosCount(arg_72_0)
	local var_72_0 = 0

	for iter_72_0, iter_72_1 in ipairs(arg_72_0.nextHeros) do
		if iter_72_1 and arg_72_0.scene:getObjectExcludeDead(iter_72_1) then
			var_72_0 = var_72_0 + 1
		end
	end

	for iter_72_2, iter_72_3 in ipairs(arg_72_0.roundLeftHeros) do
		if iter_72_3 and iter_72_3.obj and not iter_72_3.obj:isRealDeath() then
			var_72_0 = var_72_0 + 1
		end
	end

	return var_72_0
end

function var_0_0.checkRoundEnd(arg_73_0)
	if arg_73_0:getRoundLeftHerosCount() <= 0 then
		return true
	end

	return false
end

function var_0_0.checkWaveEnd(arg_74_0)
	if arg_74_0.curWave < arg_74_0.waveCount and arg_74_0:checkForceAllRealDead(2) then
		return true
	end

	return false
end

function var_0_0.condition(arg_75_0)
	local var_75_0 = arg_75_0:checkForceAllRealDead(1) or arg_75_0:checkForceAllRealDead(2)

	if arg_75_0.curRound >= arg_75_0.roundLimit and arg_75_0:checkRoundEnd() and not var_75_0 then
		return true
	end

	return false
end

local var_0_4 = {
	[battle.EndSpecialCheck.ForceNum] = function(arg_76_0)
		if arg_76_0:condition() then
			local var_76_0 = {
				0,
				0
			}

			for iter_76_0, iter_76_1 in arg_76_0.scene:ipairsHeros() do
				if iter_76_1 and not iter_76_1:isAlreadyDead() and arg_76_0:checkObjCanToServer(iter_76_1) then
					var_76_0[iter_76_1.force] = var_76_0[iter_76_1.force] + 1
				end
			end

			if battleEasy.numEqual(var_76_0[1], var_76_0[2]) then
				return false, "fail"
			end

			local var_76_1 = battleEasy.ifElse(var_76_0[1] > var_76_0[2], "win", "fail")

			return true, var_76_1
		end

		return false
	end,
	[battle.EndSpecialCheck.HpRatioCheck] = function(arg_77_0)
		if arg_77_0:condition() then
			arg_77_0.scene:overAssignTypeBuffs("markId")

			local var_77_0 = {
				0,
				0
			}

			for iter_77_0, iter_77_1 in arg_77_0.scene:ipairsHeros() do
				if arg_77_0:checkObjCanToServer(iter_77_1) then
					var_77_0[iter_77_1.force] = var_77_0[iter_77_1.force] + iter_77_1:hp() / iter_77_1:hpMax()
				end
			end

			if battleEasy.numEqual(var_77_0[1], var_77_0[2]) then
				return false, "fail"
			end

			local var_77_1 = battleEasy.ifElse(var_77_0[1] > var_77_0[2], "win", "fail")

			return true, var_77_1
		end

		return false
	end,
	[battle.EndSpecialCheck.TotalHpCheck] = function(arg_78_0)
		if arg_78_0:condition() then
			local var_78_0 = {
				0,
				0
			}

			for iter_78_0, iter_78_1 in arg_78_0.scene:ipairsHeros() do
				if iter_78_1 and not iter_78_1:isAlreadyDead() and arg_78_0:checkObjCanToServer(iter_78_1) then
					var_78_0[iter_78_1.force] = var_78_0[iter_78_1.force] + iter_78_1:hp()
				end
			end

			if battleEasy.numEqual(var_78_0[1], var_78_0[2]) then
				return false, "fail"
			end

			local var_78_1 = battleEasy.ifElse(var_78_0[1] > var_78_0[2], "win", "fail")

			return true, var_78_1
		end

		return false
	end,
	[battle.EndSpecialCheck.AllHpRatioCheck] = function(arg_79_0)
		if arg_79_0:condition() then
			arg_79_0.scene:overAssignTypeBuffs("markId")

			arg_79_0.enemyDeadHpMaxSum = arg_79_0.enemyDeadHpMaxSum or 0
			arg_79_0.myDeadHpMaxSum = arg_79_0.myDeadHpMaxSum or 0

			local var_79_0 = {
				arg_79_0.myDeadHpMaxSum,
				arg_79_0.enemyDeadHpMaxSum
			}
			local var_79_1 = {
				0,
				0
			}

			for iter_79_0, iter_79_1 in arg_79_0.scene:ipairsHeros() do
				if arg_79_0:checkObjCanToServer(iter_79_1) then
					var_79_0[iter_79_1.force] = var_79_0[iter_79_1.force] + iter_79_1:hpMax()
					var_79_1[iter_79_1.force] = var_79_1[iter_79_1.force] + iter_79_1:hp()
				end
			end

			local var_79_2

			if var_79_0[1] == 0 or var_79_0[2] == 0 then
				local var_79_3 = battleEasy.ifElse(var_79_0[2] == 0, "win", "fail")

				return true, var_79_3
			end

			if battleEasy.numEqual(var_79_1[1] / var_79_0[1], var_79_1[2] / var_79_0[2]) then
				return false, "fail"
			end

			local var_79_4 = battleEasy.ifElse(var_79_1[1] / var_79_0[1] > var_79_1[2] / var_79_0[2], "win", "fail")

			return true, var_79_4
		end

		return false
	end,
	[battle.EndSpecialCheck.FightPoint] = function(arg_80_0)
		if arg_80_0:condition() then
			local var_80_0 = {
				0,
				0
			}

			for iter_80_0, iter_80_1 in arg_80_0.scene:ipairsHeros() do
				if arg_80_0:checkObjCanToServer(iter_80_1) then
					var_80_0[iter_80_1.force] = var_80_0[iter_80_1.force] + iter_80_1.fightPoint
				end
			end

			if battleEasy.numEqual(var_80_0[1], var_80_0[2]) then
				return false, "fail"
			end

			local var_80_1 = battleEasy.ifElse(var_80_0[1] > var_80_0[2], "win", "fail")

			return true, var_80_1
		end

		return false
	end,
	[battle.EndSpecialCheck.CumulativeSpeedSum] = function(arg_81_0)
		local var_81_0 = {
			0,
			0
		}

		for iter_81_0, iter_81_1 in arg_81_0.scene:ipairsHeros() do
			if arg_81_0:checkObjCanToServer(iter_81_1) then
				var_81_0[iter_81_1.force] = var_81_0[iter_81_1.force] + iter_81_1:speed()
			end
		end

		if battleEasy.numEqual(var_81_0[1], var_81_0[2]) then
			return false, "fail"
		end

		local var_81_1 = battleEasy.ifElse(var_81_0[1] > var_81_0[2], "win", "fail")

		return true, var_81_1
	end,
	[battle.EndSpecialCheck.SoloSpecialRule] = function(arg_82_0)
		if not arg_82_0.forceToObjId then
			return false
		end

		local var_82_0 = arg_82_0.scene:getObject(arg_82_0.forceToObjId[1])
		local var_82_1 = arg_82_0.scene:getObject(arg_82_0.forceToObjId[2])

		if not var_82_0 or not var_82_1 then
			return false
		end

		if var_82_0.markID ~= var_82_1.markID then
			return false
		end

		if not gCraftSpecialRules[var_82_0.markID] then
			return false
		end

		local var_82_2 = gCraftSpecialRules[var_82_0.markID]
		local var_82_3 = arg_82_0.scene.buffGlobalManager
		local var_82_4 = var_82_3:getBuffTriggerTime(var_82_0.id, var_82_2)
		local var_82_5 = var_82_3:getBuffTriggerTime(var_82_1.id, var_82_2)

		if var_82_4 == var_82_5 then
			return false
		end

		if var_82_4 > 1e-06 and var_82_5 > 1e-06 then
			return false
		end

		local var_82_6 = battleEasy.ifElse(var_82_4 < var_82_5, "win", "fail")

		return true, var_82_6
	end,
	[battle.EndSpecialCheck.LastWaveTotalDamage] = function(arg_83_0)
		local var_83_0 = {
			0,
			0
		}

		for iter_83_0, iter_83_1 in arg_83_0.scene:ipairsHeros() do
			if arg_83_0:checkObjCanCalcDamage(iter_83_1) then
				local var_83_1 = 0

				for iter_83_2, iter_83_3 in pairs(battle.DamageFrom) do
					var_83_1 = var_83_1 + (iter_83_1.totalDamage[iter_83_3] and iter_83_1.totalDamage[iter_83_3]:get(1) or 0)
				end

				var_83_0[iter_83_1.force] = var_83_0[iter_83_1.force] + var_83_1 - (iter_83_1.lastWaveTotalDamage or 0)
			end
		end

		if battleEasy.numEqual(var_83_0[1], var_83_0[2]) then
			return false, "fail"
		end

		local var_83_2 = battleEasy.ifElse(var_83_0[1] > var_83_0[2], "win", "fail")

		return true, var_83_2
	end,
	[battle.EndSpecialCheck.DirectWin] = function(arg_84_0)
		local var_84_0 = {
			{
				0,
				0
			},
			{
				0,
				0
			}
		}

		for iter_84_0, iter_84_1 in arg_84_0.scene:ipairsHeros() do
			for iter_84_2, iter_84_3 in iter_84_1:ipairsOverlaySpecBuff("directWin") do
				var_84_0[iter_84_1.force][iter_84_3.mode] = var_84_0[iter_84_1.force][iter_84_3.mode] + 1
			end
		end

		local var_84_1

		if var_84_0[1][1] ~= var_84_0[2][1] then
			local var_84_2 = battleEasy.ifElse(var_84_0[1][1] > var_84_0[2][1], "win", "fail")

			return true, var_84_2
		end

		if var_84_0[1][2] ~= var_84_0[2][2] then
			local var_84_3 = battleEasy.ifElse(var_84_0[1][2] > var_84_0[2][2], "fail", "win")

			return true, var_84_3
		end

		return false
	end,
	[battle.EndSpecialCheck.EnemyOnlySummonOrAllDead] = function(arg_85_0)
		local function var_85_0()
			for iter_86_0, iter_86_1 in arg_85_0.scene:getHerosMap(2):order_pairs() do
				if iter_86_1 and not iter_86_1:isAlreadyDead() and arg_85_0:checkObjCanToServer(iter_86_1) then
					return false
				end
			end

			return true
		end

		if (arg_85_0.curRound >= arg_85_0.roundLimit and arg_85_0:checkRoundEnd() or arg_85_0:checkForceAllRealDead(1)) and var_85_0() then
			return true, "win"
		end

		return false
	end,
	[battle.EndSpecialCheck.BothDead] = function(arg_87_0, arg_87_1)
		if arg_87_0:checkBothAllRealDead() then
			return true, arg_87_1 or "win"
		end

		return false
	end
}

function var_0_0.specialEndCheck(arg_88_0)
	local var_88_0
	local var_88_1

	for iter_88_0, iter_88_1 in ipairs(arg_88_0.SpecEndRuleCheck) do
		local var_88_2 = var_0_4[iter_88_1]

		if var_88_2 then
			local var_88_3 = arg_88_0.SpecEndRuleCheckArgs[iter_88_1] or function()
				return
			end
			local var_88_4, var_88_5 = var_88_2(arg_88_0, var_88_3())

			if var_88_4 or iter_88_0 == table.length(arg_88_0.SpecEndRuleCheck) and var_88_5 then
				return true, var_88_5
			end
		end
	end
end

function var_0_0.bothRealDeadSpecCheck(arg_90_0)
	local var_90_0

	for iter_90_0, iter_90_1 in ipairs(arg_90_0.scene.realDeathRecordTb) do
		if not var_90_0 or var_90_0 and var_90_0.order < iter_90_1.order then
			var_90_0 = {
				order = iter_90_1.order,
				force = iter_90_1.force,
				id = iter_90_1.id
			}
		end
	end

	return true, var_90_0.force ~= 1 and "fail" or "win"
end

function var_0_0.checkBattleEnd(arg_91_0)
	local var_91_0, var_91_1 = arg_91_0:specialEndCheck()

	if var_91_0 then
		return var_91_0, var_91_1
	end

	local var_91_2 = arg_91_0:checkForceAllRealDead(1)
	local var_91_3 = arg_91_0:checkForceAllRealDead(2)

	if var_91_2 and var_91_3 and table.length(arg_91_0.scene.realDeathRecordTb) > 0 then
		return arg_91_0:bothRealDeadSpecCheck()
	end

	if var_91_2 then
		return true, "fail"
	end

	if arg_91_0.curRound >= arg_91_0.roundLimit and arg_91_0:checkRoundEnd() and not var_91_3 then
		return true, "fail"
	end

	if arg_91_0.curWave > arg_91_0.waveCount then
		return true, "fail"
	end

	local var_91_4 = arg_91_0.curWave == arg_91_0.waveCount and var_91_3
	local var_91_5, var_91_6 = arg_91_0:checkExEndConditions()
	local var_91_7 = not var_91_5 and var_91_4 or var_91_5 and var_91_6
	local var_91_8 = var_91_7 and (not var_91_5 or var_91_6)

	if var_91_7 then
		return true, var_91_8 and "win" or "fail"
	end

	return false
end

function var_0_0.checkBattleState(arg_92_0)
	local function var_92_0()
		for iter_93_0, iter_93_1 in arg_92_0.scene:ipairsHeros() do
			if not iter_93_1:isAlreadyDead() then
				iter_93_1:onEndRound()
			end
		end

		local var_93_0 = 0

		for iter_93_2, iter_93_3 in pairs(arg_92_0.scene.deadObjsToBeDeleted) do
			arg_92_0.scene:onObjDeath(iter_93_3)

			var_93_0 = var_93_0 + 1
		end

		if var_93_0 > 0 then
			arg_92_0.scene.deadObjsToBeDeleted = {}
		end
	end

	local function var_92_1()
		local var_94_0, var_94_1 = arg_92_0:checkBattleEnd()

		if var_94_0 then
			arg_92_0:runGameEnd(var_94_1)
		end

		return var_94_0
	end

	if var_92_1() then
		return
	elseif arg_92_0:checkWaveEnd() then
		var_92_0()

		if not var_92_1() then
			arg_92_0:onWaveEndSupply()
			arg_92_0.scene:newWave()
		end
	elseif arg_92_0:checkRoundEnd() then
		var_92_0()

		if not var_92_1() then
			arg_92_0:onRoundEndSupply()
			arg_92_0.scene:newRound()
		end
	else
		arg_92_0.scene:newBattleTurn()
	end
end

function var_0_0.runGameEnd(arg_95_0, arg_95_1)
	arg_95_0:recordDamageStats()
	arg_95_0:recordCampDamageStats()

	arg_95_0.result = arg_95_1

	arg_95_0:onBattleEndSupply()
	arg_95_0.scene:overAssignTypeBuffs("markId")
	arg_95_0:checkGuide(function()
		gRootViewProxy:notify("sceneOver", arg_95_0.result)
		arg_95_0.scene:over()
	end, {
		round = arg_95_0.result == "win" and battle.GuideTriggerPoint.Win or battle.GuideTriggerPoint.Fail
	})
end

function var_0_0.onOver(arg_97_0)
	arg_97_0:makeEndViewInfos()
	battleEasy.queueEffect(function()
		display.director:getScheduler():setTimeScale(1)
		battleEasy.queueEffect(function()
			arg_97_0.scene:setAutoFight(false)
			gRootViewProxy:notify("sceneEndPlayAni", arg_97_0.result)

			if arg_97_0.endAnimation then
				local var_99_0 = {
					aniloop = false,
					delay = 0,
					offsetX = 0,
					zorder = 0,
					addTolayer = 1,
					offsetY = 0,
					screenPos = 0,
					scale = 0.5,
					aniName = arg_97_0.endAnimation.aniName
				}

				battleEasy.queueEffect("effect", {
					faceTo = 1,
					effectType = 1,
					effectRes = arg_97_0.endAnimation.res,
					effectArgs = var_99_0
				})
			end

			battleEasy.queueEffect("delay", {
				lifetime = 100 + (arg_97_0.endMoreDelayTime or 0)
			})
		end)
	end)
	arg_97_0.scene:playEnd()
end

local var_0_5 = {
	function(arg_100_0, arg_100_1)
		local var_100_0 = arg_100_0.result == "win"

		return var_100_0, var_100_0 and 1 or 0
	end,
	function(arg_101_0, arg_101_1)
		local var_101_0 = arg_101_0.scene.forceRecordTb[1].herosStartCount
		local var_101_1 = 0

		for iter_101_0, iter_101_1 in arg_101_0.scene.heros:order_pairs() do
			if iter_101_1 and not iter_101_1:isRealDeath() then
				var_101_1 = var_101_1 + 1
			end
		end

		return arg_101_1 >= var_101_0 - var_101_1, var_101_0 - var_101_1
	end,
	function(arg_102_0, arg_102_1)
		return not arg_102_0.seeBoss or arg_102_1 >= arg_102_0.curRound, arg_102_0.seeBoss and arg_102_0.curRound or 0
	end,
	function(arg_103_0, arg_103_1)
		local var_103_0 = arg_103_0.scene.forceRecordTb[1].herosStartCount

		return var_103_0 <= arg_103_1, var_103_0
	end,
	function(arg_104_0, arg_104_1)
		local var_104_0 = arg_104_0.scene.forceRecordTb[1].herosStartCount

		return arg_104_1 <= var_104_0, var_104_0
	end
}

function var_0_0.initStarConditions(arg_105_0)
	if not arg_105_0.starConditionTb then
		local var_105_0 = arg_105_0.scene.sceneConf.stars or {}
		local var_105_1 = {}

		for iter_105_0, iter_105_1 in csvPairs(var_105_0) do
			table.insert(var_105_1, {
				iter_105_1.key,
				iter_105_1.value
			})

			if table.length(var_105_1) >= 3 then
				arg_105_0.starConditionTb = var_105_1

				break
			end
		end
	end
end

function var_0_0.getStarConditions(arg_106_0)
	return arg_106_0.starConditionTb
end

function var_0_0.compareRecrodResult(arg_107_0, arg_107_1)
	return arg_107_0:makeEndViewInfos().result == arg_107_1
end

function var_0_0.getGateStar(arg_108_0)
	if not arg_108_0.starConditionTb then
		return
	end

	local var_108_0 = arg_108_0.starConditionTb
	local var_108_1 = 0
	local var_108_2 = {
		{
			false,
			0
		},
		{
			false,
			0
		},
		{
			false,
			0
		}
	}

	for iter_108_0 = 1, 3 do
		local var_108_3 = var_108_0[iter_108_0]
		local var_108_4 = var_0_5[var_108_3[1]]

		if var_108_4 then
			var_108_2[iter_108_0][1], var_108_2[iter_108_0][2] = var_108_4(arg_108_0, var_108_3[2])
		end

		if var_108_2[iter_108_0][1] then
			var_108_1 = var_108_1 + 1
		end
	end

	return var_108_1, var_108_2
end

function var_0_0.postEndResultToServer(arg_109_0, arg_109_1)
	arg_109_1(arg_109_0:makeEndViewInfos(), nil)
end

function var_0_0.checkBulletTimeShow(arg_110_0)
	if not arg_110_0.showedBulletTime then
		battleEasy.deferCallback(function()
			if arg_110_0.result then
				gRootViewProxy:proxy():bulletTimeShow()
			end
		end)
		battleEasy.queueEffect(function()
			if arg_110_0.result then
				arg_110_0.showedBulletTime = true

				gRootViewProxy:proxy():onEventEffectQueueFront("delay", {
					lifetime = 900
				})
			end
		end)
	end
end

function var_0_0.getGroup(arg_113_0)
	return nil
end

function var_0_0.whoHighestDamageFromStats(arg_114_0, arg_114_1, arg_114_2)
	local var_114_0 = 0
	local var_114_1 = 1
	local var_114_2 = 1
	local var_114_3 = arg_114_0.scene.extraRecord:getEvent(battle.ExRecordEvent.unitsDamage)

	for iter_114_0 = 1, arg_114_2 or 1 do
		local var_114_4 = {}

		if arg_114_2 then
			var_114_4 = var_114_3[arg_114_1][iter_114_0]
		else
			var_114_4 = var_114_3[arg_114_1]
		end

		if var_114_4 then
			itertools.each(var_114_4, function(arg_115_0, arg_115_1)
				if arg_115_1.damageVal and arg_115_1.damageVal >= var_114_0 then
					var_114_0 = arg_115_1.damageVal
					var_114_2 = arg_115_1.posId
					var_114_1 = iter_114_0
				end
			end)
		end
	end

	return var_114_1, var_114_2
end

function var_0_0.checkExEndConditions(arg_116_0)
	local var_116_0 = arg_116_0.scene.sceneConf.finishPoint

	if var_116_0 then
		for iter_116_0, iter_116_1 in pairs(var_116_0) do
			if iter_116_0 == "killNumber" and iter_116_1 <= (arg_116_0.scene.extraRecord:getEventByKey(battle.ExRecordEvent.killNumber, "Val") or 0) then
				return true, true
			end
		end

		return true, false
	end

	return false, false
end

function var_0_0.checkObjCanToServer(arg_117_0, arg_117_1)
	return arg_117_1.type ~= battle.ObjectType.Summon and arg_117_1.type ~= battle.ObjectType.SummonFollow
end

function var_0_0.checkObjCanCalcDamage(arg_118_0, arg_118_1)
	if (arg_118_1.type == battle.ObjectType.Summon or arg_118_1.type == battle.ObjectType.SummonFollow) and not arg_118_1.summonCalDamage then
		return false
	end

	return true
end

function var_0_0.recordDamageStats(arg_119_0)
	for iter_119_0, iter_119_1 in arg_119_0.scene:ipairsHeros() do
		if arg_119_0:checkObjCanCalcDamage(iter_119_1) then
			local var_119_0 = 0

			for iter_119_2, iter_119_3 in pairs(iter_119_1.totalDamage) do
				var_119_0 = var_119_0 + iter_119_3:get(battle.ValueType.normal)
			end

			local var_119_1 = iter_119_1.force
			local var_119_2 = iter_119_1.id
			local var_119_3 = {
				posId = iter_119_1.realSeal,
				damageVal = var_119_0
			}

			arg_119_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.unitsDamage, var_119_3, var_119_1, var_119_2)
		end
	end
end

function var_0_0.recordCampDamageStats(arg_120_0)
	local var_120_0 = 0
	local var_120_1 = 0
	local var_120_2 = arg_120_0.scene.extraRecord:getEventByKey(battle.ExRecordEvent.unitsDamage, 1)
	local var_120_3 = arg_120_0.scene.extraRecord:getEventByKey(battle.ExRecordEvent.unitsDamage, 2)

	if var_120_2 and var_120_3 then
		for iter_120_0, iter_120_1 in pairs(var_120_2) do
			var_120_0 = iter_120_1.damageVal + var_120_0
		end

		for iter_120_2, iter_120_3 in pairs(var_120_3) do
			var_120_1 = iter_120_3.damageVal + var_120_1
		end
	end

	arg_120_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.campDamage, var_120_0, 1)
	arg_120_0.scene.extraRecord:addExRecord(battle.ExRecordEvent.campDamage, var_120_1, 2)
end

function var_0_0.recordScoreStats(arg_121_0, arg_121_1, arg_121_2)
	return
end

function var_0_0.onTurnStartSupply(arg_122_0)
	return
end

function var_0_0.onTurnEndSupply(arg_123_0)
	return
end

function var_0_0.onRoundEndSupply(arg_124_0)
	return
end

function var_0_0.onWaveEndSupply(arg_125_0)
	return
end

function var_0_0.onBattleEndSupply(arg_126_0)
	return
end

function var_0_0.refreshUIHp(arg_127_0)
	arg_127_0:notifyToSpecModule("refreshUIHp")
end

function var_0_0.refreshUIMp(arg_128_0)
	arg_128_0:notifyToSpecModule("refreshUIMp")
end

function var_0_0.getMonsterCsv(arg_129_0, arg_129_1, arg_129_2)
	arg_129_1 = arg_129_1 or arg_129_0.scene.sceneID

	return csvClone(gMonsterCsv[arg_129_1][arg_129_2])
end

function var_0_0.getMonsterGuideCsv(arg_130_0, arg_130_1, arg_130_2)
	return gMonsterCsv[arg_130_1] and arg_130_0:getMonsterCsv(arg_130_1, arg_130_2)
end

function var_0_0.getTotalBattleTurnCurWave(arg_131_0)
	return arg_131_0.totalRoundBattleTurn
end

function var_0_0.getTotalRounds(arg_132_0)
	return arg_132_0.totalRound
end

function var_0_0.excutePlayCsv(arg_133_0, arg_133_1)
	if arg_133_0.PlayCsvFunc[arg_133_1] then
		return functools.partial(arg_133_0.PlayCsvFunc[arg_133_1], arg_133_0)
	end
end

function var_0_0.runOneFrame(arg_134_0)
	return
end

function var_0_0.setAttack(arg_135_0, arg_135_1, arg_135_2)
	arg_135_0.handleInput = {
		arg_135_1,
		arg_135_2
	}

	if arg_135_1 ~= 0 then
		arg_135_0.nowChooseID = arg_135_1
	end

	logf.battle.scene.setAttack(" 操作输入 player inputs: targetSeat= %d, skillId= %d", arg_135_1, arg_135_2)
end

function var_0_0.sendActionParams(arg_136_0)
	local var_136_0 = arg_136_0.actionSend
	local var_136_1 = table.maxn(var_136_0)

	for iter_136_0 = 1, var_136_1 do
		local var_136_2 = var_136_0[iter_136_0]

		if var_136_2 == nil then
			var_136_0[iter_136_0] = {}
		else
			local var_136_3 = table.maxn(var_136_2)

			for iter_136_1 = 1, var_136_3 do
				if var_136_2[iter_136_1] == nil then
					var_136_2[iter_136_1] = var_0_1
				end
			end
		end
	end

	return var_136_0
end

function var_0_0.checkGuide(arg_137_0, arg_137_1, arg_137_2)
	arg_137_0.scene.guide:checkGuide(arg_137_1, arg_137_2)
end

function var_0_0.makeEndViewInfos(arg_138_0, arg_138_1)
	local var_138_0 = {
		result = arg_138_0.result
	}

	if arg_138_1 and arg_138_1.gateStar then
		var_138_0.gateStar = 0

		if arg_138_0.result == "win" then
			var_138_0.gateStar, var_138_0.gateStarTb = arg_138_0:getGateStar()
		end

		var_138_0.conditionTb = arg_138_0.starConditionTb
	end

	return var_138_0
end
