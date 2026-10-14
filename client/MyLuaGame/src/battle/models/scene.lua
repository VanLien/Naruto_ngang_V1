globals.SceneModel = class("SceneModel")

function SceneModel.ctor(arg_1_0)
	arg_1_0.framesInScene = 0
	arg_1_0.heros = CMap.new()
	arg_1_0.enemyHeros = CMap.new()
	arg_1_0.backHeros = CMap.new()
	arg_1_0.extraHeros = CMap.new()
	arg_1_0.herosOrder = nil
	arg_1_0.autoFight = false
	arg_1_0.sceneID = nil
	arg_1_0.play = nil
	arg_1_0.inputs = {}
	arg_1_0.guide = nil
	arg_1_0.updateResumeStack = {}
	arg_1_0.isFirstLoad = true
	arg_1_0.placeIdInfoTb = {}
	arg_1_0.deadObjsToBeDeleted = {}
	arg_1_0.deferListInBattleTurn = {}
	arg_1_0.allBuffs = arg_1_0:createBuffCollection()
	arg_1_0.fieldBuffs = arg_1_0:createBuffCollection()
	arg_1_0.needToDelBuffIDs = {}
	arg_1_0.totalDamage = {}
	arg_1_0.forceRecordTb = {
		{},
		{}
	}
	arg_1_0.buffGlobalManager = BuffGlobalModel.new()
	arg_1_0.forceRecordObject = {}
	arg_1_0.deferBeAttackList = {}
	arg_1_0.beAttackZOrder = 0
	arg_1_0.realDeathRecordTb = {}
	arg_1_0.extraRecord = BattleExRecord.new()
	arg_1_0.extraRoundMode = nil
	arg_1_0.replaceGroupBuffIdMap = nil
	arg_1_0.maxReplaceGroupBuffId = -1
	arg_1_0.cowEnableCount = 0
	arg_1_0.hasSendRecord = false
end

function SceneModel.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.isRecord = arg_2_3
	arg_2_0.data = arg_2_2 or {}
	arg_2_0.battleID = arg_2_2.battleID
	arg_2_0.sceneID = arg_2_1
	arg_2_0.gateType = arg_2_2.gateType or csv.scene_conf[arg_2_1].gateType
	arg_2_0.sceneConf = csv.scene_conf[arg_2_1] or csv.endless_tower_scene[arg_2_1]
	arg_2_0.sceneTag = arg_2_0.sceneConf.tag or {}
	arg_2_0.sceneLevel = arg_2_0.sceneConf.sceneLevel
	arg_2_0.showLevel = arg_2_0.sceneConf.showLevel
	arg_2_0.skillLevel = arg_2_0.sceneConf.skillLevel
	arg_2_0.closeRandFix = arg_2_2.closeRandFix

	if arg_2_0.sceneConf.sceneLevelCorrect then
		local var_2_0 = csv.scene_level_correct[arg_2_2.levels[1]]

		if var_2_0[arg_2_0.sceneConf.sceneLevelCorrect] then
			arg_2_0.sceneLevel = var_2_0[arg_2_0.sceneConf.sceneLevelCorrect]
		end
	end

	if arg_2_3 then
		arg_2_0.play = newRecordPlayModel(arg_2_0, arg_2_0.gateType)
	else
		arg_2_0.play = newPlayModel(arg_2_0, arg_2_0.gateType)
	end

	arg_2_0.play:init(arg_2_0.data)

	arg_2_0.guide = BattleGuideModel.new(arg_2_0)

	arg_2_0.guide:init(arg_2_0.play)
	gRootViewProxy:proxy():showMainUI(false)
	arg_2_0:waitInitAniDone()
end

function SceneModel.modelWait(arg_3_0, arg_3_1, arg_3_2)
	log.battle.scene.wait(arg_3_1)
	table.insert(arg_3_0.updateResumeStack, {
		type = arg_3_1,
		resume = arg_3_2
	})
	gRootViewProxy:proxy():onModelWait(arg_3_1)
end

function SceneModel.modelResume(arg_4_0)
	local var_4_0 = table.length(arg_4_0.updateResumeStack)

	if var_4_0 > 0 then
		local var_4_1 = arg_4_0.updateResumeStack[var_4_0]
		local var_4_2 = var_4_1.resume

		table.remove(arg_4_0.updateResumeStack)
		log.battle.scene.resume(var_4_1.type, var_4_0 - 1)

		if var_4_0 > 1 then
			local var_4_3 = arg_4_0.updateResumeStack[var_4_0 - 1]
		end

		var_4_2(arg_4_0, true)

		return true
	end

	return false
end

function SceneModel.insertPlayCustomWait(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:modelWait(arg_5_1, function(arg_6_0, arg_6_1)
		if arg_6_1 then
			return arg_5_2()
		end
	end)
end

function SceneModel.waitInitAniDone(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return arg_7_0:modelWait("scene_init", arg_7_0.waitInitAniDone)
	end

	arg_7_0:start()
end

function SceneModel.getHerosMap(arg_8_0, arg_8_1)
	return arg_8_1 == 1 and arg_8_0.heros or arg_8_0.enemyHeros
end

function SceneModel.getHerosMapBySeat(arg_9_0, arg_9_1)
	return arg_9_1 > 6 and arg_9_0.enemyHeros or arg_9_0.heros
end

function SceneModel.getObject(arg_10_0, arg_10_1)
	return arg_10_0.heros:find(arg_10_1) or arg_10_0.enemyHeros:find(arg_10_1) or arg_10_0.extraHeros:find(arg_10_1)
end

function SceneModel.getObjectExcludeDead(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getObject(arg_11_1)

	if var_11_0 and not var_11_0:isAlreadyDead() then
		return var_11_0
	end
end

function SceneModel.getObjectBySeat(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0

	arg_12_2 = arg_12_2 or battle.ObjectType.Normal

	if arg_12_2 == battle.ObjectType.SummonFollow then
		var_12_0 = arg_12_0.extraHeros
	else
		var_12_0 = arg_12_0:getHerosMapBySeat(arg_12_1)
	end

	for iter_12_0, iter_12_1 in var_12_0:order_pairs() do
		if iter_12_1.seat == arg_12_1 then
			return iter_12_1
		end
	end
end

function SceneModel.getObjectBySeatExcludeDead(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0:getObjectBySeat(arg_13_1, arg_13_2)

	if var_13_0 and not var_13_0:isAlreadyDead() then
		return var_13_0
	end
end

function SceneModel.getForceNum(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:getHerosMap(arg_14_1)
	local var_14_1 = 0

	for iter_14_0, iter_14_1 in var_14_0:order_pairs() do
		if iter_14_1 and not iter_14_1:isAlreadyDead() then
			var_14_1 = var_14_1 + 1
		end
	end

	return var_14_1
end

function SceneModel.getForceNumIncludeDead(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:getHerosMap(arg_15_1)
	local var_15_1 = 0

	for iter_15_0, iter_15_1 in var_15_0:order_pairs() do
		if iter_15_1 then
			var_15_1 = var_15_1 + 1
		end
	end

	return var_15_1
end

function SceneModel.getForceIDs(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:getHerosMap(arg_16_1)

	return itertools.keys(var_16_0)
end

function SceneModel.getForceNumWithSpecNatureType(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0:getHerosMap(arg_17_1)
	local var_17_1 = 0

	local function var_17_2(arg_18_0, arg_18_1)
		return arg_18_0:getNatureType(1) == arg_18_1 or arg_18_0:getNatureType(2) == arg_18_1
	end

	for iter_17_0, iter_17_1 in var_17_0:order_pairs() do
		if iter_17_1 and not iter_17_1:isAlreadyDead() and var_17_2(iter_17_1, arg_17_2) then
			var_17_1 = var_17_1 + 1
		end
	end

	return var_17_1
end

function SceneModel.beInExtraAttack(arg_19_0)
	return arg_19_0.extraRoundMode
end

function SceneModel.getRowRemain(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0:getHerosMap(arg_20_1)
	local var_20_1 = {}
	local var_20_2 = {
		{
			{
				max = 3,
				min = 1
			},
			{
				max = 6,
				min = 4
			}
		},
		{
			{
				max = 9,
				min = 7
			},
			{
				max = 12,
				min = 10
			}
		}
	}

	for iter_20_0, iter_20_1 in var_20_0:order_pairs() do
		local var_20_3 = var_20_2[arg_20_1][arg_20_2]

		if iter_20_1 and not iter_20_1:isAlreadyDead() and iter_20_1.seat <= var_20_3.max and iter_20_1.seat >= var_20_3.min then
			table.insert(var_20_1, iter_20_1)
		end
	end

	return table.length(var_20_1), var_20_1
end

function SceneModel.getColumnRemain(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0:getHerosMap(arg_21_1)
	local var_21_1 = {}

	for iter_21_0, iter_21_1 in var_21_0:order_pairs() do
		if iter_21_1 and not iter_21_1:isAlreadyDead() and (iter_21_1.seat + 2) % 3 == arg_21_2 - 1 then
			table.insert(var_21_1, iter_21_1)
		end
	end

	return table.length(var_21_1), var_21_1
end

function SceneModel.getTotalForceFightPoint(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0:getHerosMap(arg_22_1)
	local var_22_1 = 0

	for iter_22_0, iter_22_1 in var_22_0:order_pairs() do
		var_22_1 = var_22_1 + iter_22_1.fightPoint
	end

	return var_22_1
end

function SceneModel.addInput(arg_23_0, arg_23_1)
	if arg_23_0.play:isMyTurn() or arg_23_0.fullManual then
		table.insert(arg_23_0.inputs, arg_23_1)
	end
end

function SceneModel.start(arg_24_0)
	arg_24_0:newWave()
end

function SceneModel.over(arg_25_0, arg_25_1)
	if not arg_25_1 then
		return arg_25_0:modelWait("battle_over", arg_25_0.over)
	end

	arg_25_0.guide:checkGuide(function()
		arg_25_0.play:onOver()
	end, {
		round = battle.GuideTriggerPoint.End
	})
end

function SceneModel.newWave(arg_27_0, arg_27_1)
	log.battle.scene(" ______________________________________ scene newWave =", arg_27_0.play.curWave, arg_27_1, arg_27_0.play:isPlaying())

	if not arg_27_1 and arg_27_0.play:isPlaying() then
		return arg_27_0:modelWait("new_wave", arg_27_0.newWave)
	end

	gRootViewProxy:proxy():clearDeleteObjLayer()
	gRootViewProxy:proxy():showMainUI(false)
	arg_27_0.play:onNewWavePlayAni()
end

function SceneModel.waitNewWaveAniDone(arg_28_0, arg_28_1)
	if not arg_28_1 and arg_28_0.play:isPlaying() then
		return arg_28_0:modelWait("new_wave_play_ani", arg_28_0.waitNewWaveAniDone)
	end

	gRootViewProxy:proxy():showMainUI(true)
	gRootViewProxy:notify("showMain", false)
	gRootViewProxy:proxy():showSpeedRank(false)
	arg_28_0.guide:checkGuide(function()
		arg_28_0.play:onNewWave()
	end, {
		round = battle.GuideTriggerPoint.Start
	})
end

function SceneModel.newRound(arg_30_0, arg_30_1)
	log.battle.scene(" ______________________________________ scene newRound =", arg_30_0.play.curRound, arg_30_1, arg_30_0.play:isPlaying())
	gRootViewProxy:proxy():flushAllDeferList()

	if not arg_30_1 and arg_30_0.play:isPlaying() then
		return arg_30_0:modelWait("new_round", arg_30_0.newRound)
	end

	arg_30_0.deadObjsToBeDeleted = {}

	lazylog.battle.scene("newRound objs", function()
		for iter_31_0, iter_31_1 in arg_30_0.heros:order_pairs() do
			printDebug(" --- 己方: id=%s, hp=%s, atk=%s, def=%s", iter_31_1.id, iter_31_1:hp(), iter_31_1:damage(), iter_31_1:defence())
		end

		for iter_31_2, iter_31_3 in arg_30_0.enemyHeros:order_pairs() do
			printDebug(" --- 敌方: id=%s, hp=%s, atk=%s, def=%s", iter_31_3.id, iter_31_3:hp(), iter_31_3:damage(), iter_31_3:defence())
		end
	end)

	if arg_30_0.play.curRound > 0 then
		arg_30_0:updateBuffEveryRound(battle.BuffTriggerPoint.onRoundEnd)
	end

	arg_30_0:checkObjsDeadState()
	gRootViewProxy:proxy():flushAllDeferList()
	arg_30_0.play:onNewRound()
end

function SceneModel.newRoundBattleTurn(arg_32_0, arg_32_1)
	if not arg_32_1 and arg_32_0.play:isPlaying() then
		return arg_32_0:modelWait("new_round_battle_turn", arg_32_0.newRoundBattleTurn)
	end

	arg_32_0.guide:checkGuide(function()
		arg_32_0:newBattleTurn()
	end)
end

function SceneModel.newBattleTurn(arg_34_0, arg_34_1)
	log.battle.scene(" ______________________________________ scene newBattleTurn =", arg_34_0.play.curBattleRound, arg_34_1, arg_34_0.play:isPlaying())
	gRootViewProxy:proxy():flushAllDeferList()

	if not arg_34_1 and arg_34_0.play:isPlaying() then
		return arg_34_0:modelWait("new_battle_turn", arg_34_0.newBattleTurn)
	end

	arg_34_0.deadObjsToBeDeleted = {}
	arg_34_0.realDeathRecordTb = {}
	arg_34_0.inputs = {}

	lazylog.battle.scene("newBattleTurn objs", function()
		for iter_35_0, iter_35_1 in arg_34_0.heros:order_pairs() do
			print(" --- 己方:", iter_35_1.id, iter_35_1:hp())
		end

		for iter_35_2, iter_35_3 in arg_34_0.enemyHeros:order_pairs() do
			print(" --- 敌方:", iter_35_3.id, iter_35_3:hp())
		end
	end)
	arg_34_0.play:onNewBattleTurn()
	gRootViewProxy:proxy():flushAllDeferList()
end

function SceneModel.waitNewBattleRoundAniDone(arg_36_0, arg_36_1)
	if not arg_36_1 and arg_36_0.play:isPlaying() then
		return arg_36_0:modelWait("new_battle_turn_play_ani", arg_36_0.waitNewBattleRoundAniDone)
	end

	arg_36_0.play:newBattleTurnGoon()
end

function SceneModel.onSubModulesNewBattleTurn2(arg_37_0)
	gRootViewProxy:notify("playExplorer")
end

function SceneModel.onSubModulesNewBattleTurn(arg_38_0)
	local var_38_0 = arg_38_0.play.curHero
	local var_38_1 = {
		totalWave = arg_38_0.play.waveCount,
		wave = arg_38_0.play.curWave,
		roundLimit = arg_38_0.play.roundLimit,
		curRound = arg_38_0.play.curRound,
		curTurn = arg_38_0.play.curTurn,
		battleRound = arg_38_0.play.curBattleRound,
		round = arg_38_0.play.curRound,
		obj = var_38_0,
		skillsOrder = var_38_0.skillsOrder,
		immuneInfos = arg_38_0:immuneInfosToCurHeroSkills(),
		skillsStateInfoTb = var_38_0.skills,
		isTurnAutoFight = arg_38_0.play:isNowTurnAutoFight()
	}

	for iter_38_0, iter_38_1 in ipairs(arg_38_0.deferListInBattleTurn) do
		battleEasy.effect(nil, iter_38_1.func)
	end

	arg_38_0.deferListInBattleTurn = {}

	battleEasy.queueNotify("newBattleRound", var_38_1)
	battleEasy.queueNotify("showSpec", true)
end

function SceneModel.immuneInfosToCurHeroSkills(arg_39_0)
	local var_39_0 = {}
	local var_39_1 = arg_39_0.play.curHero

	for iter_39_0, iter_39_1 in ipairs(var_39_1.skillsOrder) do
		iter_39_1 = var_39_1.skillsMap[iter_39_1] or iter_39_1
		var_39_0[iter_39_1] = {}

		for iter_39_2, iter_39_3 in arg_39_0:ipairsHeros() do
			var_39_0[iter_39_1][iter_39_3.id] = iter_39_3:selectTextImmuneInfo(iter_39_1)
		end
	end

	return var_39_0
end

function SceneModel.addObjToBeDeleted(arg_40_0, arg_40_1)
	arg_40_0.deadObjsToBeDeleted[arg_40_1.id] = arg_40_1
end

function SceneModel.addObjViewToBattleTurn(arg_41_0, arg_41_1, arg_41_2, ...)
	local var_41_0 = functools.handler(arg_41_1 and arg_41_1.view or gRootViewProxy, "notify", arg_41_2, ...)

	table.insert(arg_41_0.deferListInBattleTurn, {
		func = var_41_0,
		source = arg_41_1 and arg_41_1.id or "global"
	})
end

function SceneModel.addCallBackToBattleTurn(arg_42_0, arg_42_1)
	table.insert(arg_42_0.deferListInBattleTurn, {
		source = "global",
		func = arg_42_1
	})
end

function SceneModel.addListViewToBattleTurn(arg_43_0, arg_43_1, arg_43_2)
	battleEasy.effect(nil, function()
		if not arg_43_2 then
			return
		end

		for iter_44_0, iter_44_1 in arg_43_2:ipairs() do
			table.insert(arg_43_0.deferListInBattleTurn, {
				func = iter_44_1.func,
				source = arg_43_1 and arg_43_1.id or "global"
			})
		end
	end)
end

function SceneModel.setDeathRecord(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = tostring(arg_45_1)

	for iter_45_0, iter_45_1 in ipairs(arg_45_0.realDeathRecordTb) do
		if iter_45_1.tag == var_45_0 and arg_45_2 < iter_45_1.order then
			iter_45_1.order = arg_45_2

			return
		end
	end

	table.insert(arg_45_0.realDeathRecordTb, {
		order = arg_45_2,
		tag = var_45_0,
		id = arg_45_1.id,
		force = arg_45_1.force
	})
end

function SceneModel.endBattleTurn(arg_46_0)
	battleEasy.queueEffect(function()
		for iter_47_0, iter_47_1 in ipairs(arg_46_0.deferListInBattleTurn) do
			battleEasy.deferCallback(iter_47_1.func)
		end

		arg_46_0.deferListInBattleTurn = {}

		gRootViewProxy:proxy():flushAllDeferList()
	end)

	local var_46_0 = 0

	for iter_46_0, iter_46_1 in pairs(arg_46_0.deadObjsToBeDeleted) do
		arg_46_0:onObjDeath(iter_46_1)

		var_46_0 = var_46_0 + 1
	end

	arg_46_0:checkBackStageObjs()

	for iter_46_2, iter_46_3 in arg_46_0:ipairsHeros() do
		iter_46_3:onPassive("Aura")
	end

	if var_46_0 > 0 then
		arg_46_0.deadObjsToBeDeleted = {}
	end

	battleEasy.queueNotify("battleTurnEnd")
	battleEasy.logHerosInfo(arg_46_0)
end

function SceneModel.onObjDeath(arg_48_0, arg_48_1)
	if arg_48_0:getHerosMap(arg_48_1.force):erase(arg_48_1.id) or arg_48_1.seat > 12 then
		arg_48_0.herosOrder = nil

		battleEasy.queueEffect(function()
			if arg_48_1.seat > 12 then
				arg_48_0:onGroupObjDead(arg_48_1)
			else
				battleEasy.queueZOrderNotify("sceneDeadObj", battle.EffectZOrder.dead, tostring(arg_48_1), arg_48_1)
			end
		end)
	end

	if arg_48_0.extraHeros:erase(arg_48_1.id) then
		battleEasy.queueEffect(function()
			battleEasy.queueZOrderNotify("sceneDeadObj", battle.EffectZOrder.dead, tostring(arg_48_1), arg_48_1)
		end)
	end
end

function SceneModel.onGroupObjDead(arg_51_0, arg_51_1)
	battleEasy.queueEffect(function()
		arg_51_1:playStateView()
	end, {
		zOrder = battle.EffectZOrder.dead
	})
end

function SceneModel.onObjDel(arg_53_0, arg_53_1)
	if arg_53_0:getHerosMap(arg_53_1.force):erase(arg_53_1.id) then
		arg_53_0.herosOrder = nil

		arg_53_1:processRealDeathClean()
		battleComponents.unbindAll(arg_53_1)
		gRootViewProxy:notify("sceneDelObj", tostring(arg_53_1))
	end
end

function SceneModel.addObj(arg_54_0, arg_54_1, arg_54_2)
	arg_54_0.herosOrder = nil

	arg_54_0:getHerosMap(arg_54_1):insert(arg_54_2.id, arg_54_2)
end

function SceneModel.addExtraObj(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0.extraHeros:insert(arg_55_2.id, arg_55_2)
end

function SceneModel.addBackStageObj(arg_56_0, arg_56_1)
	arg_56_0.herosOrder = nil

	arg_56_0.backHeros:insert(arg_56_1.id, arg_56_1)
end

function SceneModel.playEnd(arg_57_0, arg_57_1)
	if not arg_57_1 then
		return arg_57_0:modelWait("play_end", arg_57_0.playEnd)
	end

	printInfo("\n\n\t\tbattle %s over - id=%s, scene=%s, frame=%s, rndcnt=%s, result=%s, star=%s\n\n", arg_57_0.isRecord and "record" or "", stringz.bintohex(arg_57_0.battleID or ""), arg_57_0.sceneID, arg_57_0.framesInScene, ymrand.randCount, arg_57_0.play.result, arg_57_0.play.gateStar)

	ymrand.randCount = 0
	arg_57_0.isBattleAllEnd = true

	gGameUI.guideManager:battleStageSave(function()
		arg_57_0.play:postEndResultToServer(functools.partial(arg_57_0.showBattleEndView, arg_57_0))
	end)
end

function SceneModel.showBattleEndView(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	local var_59_0, var_59_1 = arg_59_0.play:whoHighestDamageFromStats(1, arg_59_0.play:getGroup())
	local var_59_2 = arg_59_1 or {}

	var_59_2.serverData = arg_59_2
	var_59_2.oldCapture = arg_59_3
	var_59_2.mvpPosId = var_59_1

	gRootViewProxy:raw():showEndView(var_59_2)
end

function SceneModel.update(arg_60_0, arg_60_1)
	arg_60_0.framesInScene = arg_60_0.framesInScene + 1

	arg_60_0:preDelBuff()

	if arg_60_0:modelResume() then
		return
	end

	if not arg_60_0.play:isPlaying() then
		return
	end

	if arg_60_0.play:runOneFrame() then
		return
	end

	if arg_60_0.play:isMyTurn() or arg_60_0.fullManual then
		if arg_60_0.autoFight then
			arg_60_0.play:setAttack(0, 0)
		end

		if arg_60_0.play.handleInput then
			arg_60_0.play:onceBattle(arg_60_0.play.handleInput[1], arg_60_0.play.handleInput[2])

			arg_60_0.play.handleInput = nil
		end
	end
end

function SceneModel.setAutoFight(arg_61_0, arg_61_1)
	arg_61_0.autoFight = arg_61_1
end

function SceneModel.setFullManual(arg_62_0, arg_62_1)
	arg_62_0.fullManual = arg_62_1
end

function SceneModel.resetPlaceIdInfo(arg_63_0, arg_63_1)
	local var_63_0 = {}
	local var_63_1 = {}

	for iter_63_0, iter_63_1 in arg_63_0:getHerosMap(arg_63_1):order_pairs() do
		if iter_63_1 and not iter_63_1:isAlreadyDead() then
			var_63_1[iter_63_1.seat] = iter_63_1
		end
	end

	local var_63_2 = {
		false,
		false
	}
	local var_63_3 = {
		false,
		false,
		false
	}

	itertools.each(var_63_1, function(arg_64_0, arg_64_1)
		local var_64_0 = (math.floor((arg_64_0 + 2) / 3) - 1) % 2 + 1
		local var_64_1 = (arg_64_0 - 1) % 3 + 1

		var_63_0[arg_64_0] = {}
		var_63_0[arg_64_0].row1 = var_64_0 == 1 and 1 or nil
		var_63_0[arg_64_0].row2 = var_64_0 == 2 and 2 or nil
		var_63_0[arg_64_0].column1 = var_64_1 == 1 and 1 or nil
		var_63_0[arg_64_0].column2 = var_64_1 == 2 and 2 or nil
		var_63_0[arg_64_0].column3 = var_64_1 == 3 and 3 or nil
		var_63_2[1] = var_63_0[arg_64_0].row1 and true or var_63_2[1]
		var_63_2[2] = var_63_0[arg_64_0].row2 and true or var_63_2[2]
		var_63_3[1] = var_63_0[arg_64_0].column1 and true or var_63_3[1]
		var_63_3[2] = var_63_0[arg_64_0].column2 and true or var_63_3[2]
		var_63_3[3] = var_63_0[arg_64_0].column3 and true or var_63_3[3]
	end)

	if not var_63_2[1] or not var_63_2[2] then
		itertools.each(var_63_1, function(arg_65_0, arg_65_1)
			var_63_0[arg_65_0].row1 = 1
			var_63_0[arg_65_0].row2 = 2
		end)
	end

	if var_63_3[1] and not var_63_3[2] and not var_63_3[3] or not var_63_3[1] and var_63_3[2] and not var_63_3[3] or not var_63_3[1] and not var_63_3[2] and var_63_3[3] then
		itertools.each(var_63_1, function(arg_66_0, arg_66_1)
			var_63_0[arg_66_0].column1 = 1
			var_63_0[arg_66_0].column2 = 2
			var_63_0[arg_66_0].column3 = 3
		end)
	end

	local var_63_4 = arg_63_1 == 1 and 0 or arg_63_0.play.ForceNumber

	for iter_63_2 = 1 + var_63_4, arg_63_0.play.ForceNumber + var_63_4 do
		arg_63_0.placeIdInfoTb[iter_63_2] = var_63_0[iter_63_2] or {}
	end

	return var_63_0, var_63_1
end

function SceneModel.deleteBuff(arg_67_0, arg_67_1)
	table.insert(arg_67_0.needToDelBuffIDs, arg_67_1)
end

function SceneModel.preDelBuff(arg_68_0)
	for iter_68_0, iter_68_1 in ipairs(arg_68_0.needToDelBuffIDs) do
		local var_68_0 = arg_68_0.allBuffs:erase(iter_68_1)

		arg_68_0.fieldBuffs:erase(iter_68_1)

		if var_68_0 then
			var_68_0:overClean()
		end
	end

	arg_68_0.needToDelBuffIDs = {}
end

function SceneModel.updateBuffByNode(arg_69_0, arg_69_1)
	for iter_69_0, iter_69_1 in arg_69_0.allBuffs:order_pairs() do
		iter_69_1:update(arg_69_1)
	end
end

function SceneModel.updateBuffEveryRound(arg_70_0, arg_70_1, arg_70_2)
	arg_70_0:updateBuffByNode(arg_70_1)
end

function SceneModel.updateBuffEveryTurn(arg_71_0, arg_71_1)
	arg_71_0:updateBuffByNode(arg_71_1)
end

function SceneModel.onAllPassive(arg_72_0, arg_72_1)
	local var_72_0 = {}
	local var_72_1 = {}

	for iter_72_0, iter_72_1 in arg_72_0:ipairsHeros() do
		if not iter_72_1:isAlreadyDead() then
			for iter_72_2, iter_72_3 in pairs(iter_72_1.passiveSkills) do
				table.insert(var_72_0, iter_72_3)
			end

			table.insert(var_72_1, iter_72_1)
			iter_72_1.triggerEnv[battle.TriggerEnvType.PassiveSkill]:push_back(arg_72_1)
		end
	end

	arg_72_0:sortPassiveSkills(var_72_0)

	for iter_72_4, iter_72_5 in ipairs(var_72_0) do
		iter_72_5.owner:onOnePassiveTrigger(iter_72_5, arg_72_1)
	end

	for iter_72_6, iter_72_7 in ipairs(var_72_1) do
		iter_72_7.triggerEnv[battle.TriggerEnvType.PassiveSkill]:pop_back()
	end
end

function SceneModel.sortPassiveSkills(arg_73_0, arg_73_1)
	local function var_73_0(arg_74_0, arg_74_1)
		return arg_74_1 < arg_74_0
	end

	local function var_73_1(arg_75_0, arg_75_1)
		return arg_75_0 < arg_75_1
	end

	local var_73_2 = {
		{
			getVal = function(arg_76_0)
				return arg_76_0.skillType
			end,
			checkFunc = var_73_1
		},
		{
			getVal = function(arg_77_0)
				return arg_77_0.cfg.passivePriority
			end,
			checkFunc = var_73_1
		},
		{
			getVal = function(arg_78_0)
				return arg_78_0.owner.id
			end,
			checkFunc = var_73_1
		},
		{
			getVal = function(arg_79_0)
				return arg_79_0.id
			end,
			checkFunc = var_73_1
		}
	}

	table.sort(arg_73_1, function(arg_80_0, arg_80_1)
		for iter_80_0, iter_80_1 in ipairs(var_73_2) do
			local var_80_0 = iter_80_1.getVal(arg_80_0)
			local var_80_1 = iter_80_1.getVal(arg_80_1)

			if iter_80_0 == #var_73_2 then
				return iter_80_1.checkFunc(var_80_0, var_80_1)
			end

			if var_80_0 and var_80_1 then
				if var_80_0 ~= var_80_1 then
					return iter_80_1.checkFunc(var_80_0, var_80_1)
				end
			elseif var_80_0 then
				return true
			elseif var_80_1 then
				return false
			end
		end
	end)
end

function SceneModel.checkObjsDeadState(arg_81_0)
	local var_81_0 = false

	for iter_81_0, iter_81_1 in arg_81_0:ipairsHeros() do
		if iter_81_1 then
			var_81_0 = true

			if iter_81_1:isRealDeath() then
				arg_81_0:onObjDeath(iter_81_1)
			end

			local var_81_1 = arg_81_0:getObjectBySeat(iter_81_1.seat, battle.ObjectType.SummonFollow)

			if var_81_1 and var_81_1:isRealDeath() then
				arg_81_0:onObjDeath(var_81_1)
			end
		end
	end

	arg_81_0:ipairGroupObject(function(arg_82_0)
		if arg_81_0.deadObjsToBeDeleted[arg_82_0.id] then
			arg_81_0:onObjDeath(arg_82_0)

			arg_81_0.deadObjsToBeDeleted[arg_82_0.id] = nil
		end
	end)
	arg_81_0:checkBackStageObjs()

	if var_81_0 then
		arg_81_0.play:checkBattleEnd()
	end
end

function SceneModel.getSceneAttrCorrect(arg_83_0, arg_83_1)
	return gSceneAttrCorrect[arg_83_0.force == 1 and arg_83_0.sceneID or -arg_83_0.sceneID] or {}
end

function SceneModel.isCraftGateType(arg_84_0)
	return arg_84_0.gateType == game.GATE_TYPE.craft or arg_84_0.gateType == game.GATE_TYPE.crossCraft or arg_84_0.gateType == game.GATE_TYPE.crossArena
end

function SceneModel.createGroupObj(arg_85_0, arg_85_1, arg_85_2)
	arg_85_0.forceRecordObject[arg_85_1] = arg_85_0.forceRecordObject[arg_85_1] or {}

	if arg_85_0.forceRecordObject[arg_85_1][arg_85_2] then
		return arg_85_0.forceRecordObject[arg_85_1][arg_85_2]
	end

	arg_85_0.forceRecordObject[arg_85_1][arg_85_2] = GroupObjectModel.new(arg_85_0, arg_85_1)

	arg_85_0.forceRecordObject[arg_85_1][arg_85_2]:init()
	arg_85_0.forceRecordObject[arg_85_1][arg_85_2]:initView()

	return arg_85_0.forceRecordObject[arg_85_1][arg_85_2]
end

function SceneModel.ipairGroupObject(arg_86_0, arg_86_1)
	for iter_86_0 = battle.SpecialObjectId.teamShiled, battle.SpecialObjectId.teamShiled do
		for iter_86_1 = 1, 2 do
			local var_86_0 = arg_86_0:getGroupObj(iter_86_1, iter_86_0)

			if var_86_0 then
				arg_86_1(var_86_0)
			end
		end
	end
end

function SceneModel.getGroupObj(arg_87_0, arg_87_1, arg_87_2)
	if arg_87_0.forceRecordObject[arg_87_1] then
		return arg_87_0.forceRecordObject[arg_87_1][arg_87_2]
	end
end

function SceneModel.excuteGroupObjFunc(arg_88_0, arg_88_1, arg_88_2, arg_88_3, ...)
	local var_88_0 = arg_88_0:getGroupObj(arg_88_1, arg_88_2)

	if var_88_0 and var_88_0[arg_88_3] and type(var_88_0[arg_88_3]) == "function" then
		return var_88_0[arg_88_3](var_88_0, ...)
	end

	return nil
end

function SceneModel.getGroupBuffId(arg_89_0, arg_89_1)
	return ({
		teamShield = 13
	})[arg_89_1]
end

function SceneModel.initGroupObj(arg_90_0, arg_90_1)
	local var_90_0 = arg_90_1.caster.force
	local var_90_1 = arg_90_0:getGroupBuffId(arg_90_1.csvCfg.easyEffectFunc)
	local var_90_2 = arg_90_0:getGroupObj(var_90_0, var_90_1)
	local var_90_3 = arg_90_0.play.curHero

	if var_90_3 then
		arg_90_1.isSelfTurn = var_90_3.id == arg_90_1.holder.id
	end

	var_90_2:reloadUnit(arg_90_1)
end

function SceneModel.hasTypeBuff(arg_91_0, arg_91_1)
	return not arg_91_0.allBuffs:getQuery():group("easyEffectFunc", arg_91_1):empty()
end

function SceneModel.addObjToExtraRound(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = math.max(table.length(arg_92_0.play.nextHeros) + 1, 1)

	table.insert(arg_92_0.play.nextHeros, arg_92_2 or var_92_0, arg_92_1.id)
end

function SceneModel.cleanObjInExtraRound(arg_93_0, arg_93_1)
	for iter_93_0 = table.length(arg_93_0.play.nextHeros), 1, -1 do
		if arg_93_0.play.nextHeros[iter_93_0] == arg_93_1.id then
			table.remove(arg_93_0.play.nextHeros, iter_93_0)
		end
	end
end

function SceneModel.mergeDeferBeAttack(arg_94_0, arg_94_1)
	local var_94_0 = {}

	local function var_94_1(arg_95_0)
		local var_95_0 = arg_95_0.attacker and arg_95_0.attacker.id
		local var_95_1 = arg_95_0.target and arg_95_0.target.id

		return var_95_0 .. var_95_1 .. arg_95_0.damageArgs.skillDamageId
	end

	for iter_94_0 = table.length(arg_94_1), 1, -1 do
		local var_94_2 = arg_94_1[iter_94_0]

		if var_94_2.canMerge and var_94_2.damageArgs.skillDamageId then
			local var_94_3 = var_94_1(var_94_2)

			if not var_94_0[var_94_3] then
				var_94_0[var_94_3] = var_94_2
			else
				if var_94_2.damageArgs.isBeginDamageSeg then
					var_94_0[var_94_3].damageArgs.isBeginDamageSeg = true
				end

				var_94_0[var_94_3].damage = var_94_0[var_94_3].damage + var_94_2.damage
				var_94_0[var_94_3].damageArgs.leftDamage = var_94_0[var_94_3].damage

				table.remove(arg_94_1, iter_94_0)
			end
		end
	end
end

function SceneModel.deferBeAttack(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, arg_96_7)
	local var_96_0 = {
		attacker = arg_96_2,
		target = arg_96_3,
		damage = arg_96_4,
		processID = arg_96_5,
		damageArgs = arg_96_6,
		canMerge = arg_96_7
	}

	if not arg_96_0.deferBeAttackList[arg_96_1] then
		arg_96_0.deferBeAttackList[arg_96_1] = {}
	end

	arg_96_6.beAttackZOrder = arg_96_6.beAttackZOrder + 0.5

	table.insert(arg_96_0.deferBeAttackList[arg_96_1], var_96_0)
end

function SceneModel.runBeAttackDefer(arg_97_0, arg_97_1)
	arg_97_0:checkDeferAttackOnDeath(arg_97_1)

	if arg_97_0.deferBeAttackList[arg_97_1] then
		local var_97_0 = arg_97_0.deferBeAttackList[arg_97_1]

		arg_97_0.deferBeAttackList[arg_97_1] = {}

		local var_97_1 = {}
		local var_97_2 = {}

		for iter_97_0, iter_97_1 in ipairs(var_97_0) do
			if iter_97_1.damageArgs.from == battle.DamageFrom.rebound then
				table.insert(var_97_1, iter_97_1)
			else
				table.insert(var_97_2, iter_97_1)
			end
		end

		arg_97_0:mergeDeferBeAttack(var_97_2)

		local var_97_3 = arraytools.merge({
			var_97_1,
			var_97_2
		})

		for iter_97_2, iter_97_3 in ipairs(var_97_3) do
			local var_97_4 = iter_97_3.target
			local var_97_5 = iter_97_3.attacker
			local var_97_6 = iter_97_3.damage
			local var_97_7 = iter_97_3.processID
			local var_97_8 = iter_97_3.damageArgs

			var_97_8.isDefer = true

			if var_97_8.from == battle.DamageFrom.rebound then
				var_97_6 = math.min(var_97_6, var_97_4:hp() - 1)
				var_97_6 = math.max(var_97_6, 0)
			end

			var_97_4:beAttack(var_97_5, var_97_6, var_97_7, var_97_8)
		end
	end
end

function SceneModel.deleteBeAttackDefer(arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	if arg_98_0.deferBeAttackList[arg_98_1] then
		local var_98_0 = arg_98_0.deferBeAttackList[arg_98_1]

		for iter_98_0 = table.length(var_98_0), 1, -1 do
			local var_98_1 = var_98_0[iter_98_0]

			if var_98_1.damageArgs.fromExtra[arg_98_2] and arg_98_3 == var_98_1.damageArgs.damageId then
				table.remove(var_98_0, iter_98_0)
			end
		end
	end
end

function SceneModel.checkDeferAttackOnDeath(arg_99_0, arg_99_1)
	if arg_99_0.deferBeAttackList[arg_99_1] then
		local var_99_0 = arg_99_0.deferBeAttackList[arg_99_1]
		local var_99_1 = {}

		for iter_99_0 = table.length(var_99_0), 1, -1 do
			local var_99_2 = var_99_0[iter_99_0]

			if var_99_2.damageArgs.from ~= battle.DamageFrom.rebound then
				local var_99_3 = var_99_2.target

				if not var_99_1[var_99_3.id] then
					var_99_2.damageArgs.isLastDamageSeg = true
					var_99_1[var_99_3.id] = true
				end
			end
		end
	end
end

function SceneModel.cleanInWaveGoon(arg_100_0)
	if arg_100_0.play.curWave == 1 then
		return
	end

	for iter_100_0, iter_100_1 in arg_100_0.allBuffs:order_pairs() do
		if not iter_100_1.isAuraType and not iter_100_1.csvCfg.waveInherit then
			iter_100_1:overClean()
		end
	end

	arg_100_0:ipairGroupObject(function(arg_101_0)
		if not arg_101_0:isDeath() then
			arg_101_0.viewAniList:push_back(battle.ObjectState.realDead)
			arg_100_0:onGroupObjDead(arg_101_0)
		end

		arg_101_0:init()
	end)
	arg_100_0.extraRecord:refreshEventRecord(battle.TimeIntervalType.wave)

	arg_100_0.deferBeAttackList = {}

	gRootViewProxy:proxy():flushCurDeferList()
end

function SceneModel.recordSceneAlterBuff(arg_102_0, arg_102_1, arg_102_2)
	if arg_102_0.replaceGroupBuffIdMap == nil then
		arg_102_0.replaceGroupBuffIdMap = {
			map = {},
			cache = {}
		}
	end

	arg_102_0.replaceGroupBuffIdMap.map[arg_102_1] = arg_102_2

	if arg_102_2 == nil then
		arg_102_0.maxReplaceGroupBuffId = -1
	else
		if not arg_102_0.replaceGroupBuffIdMap.cache[arg_102_2] then
			local var_102_0 = csv.buff[arg_102_2].stageArgs
			local var_102_1 = {}

			if var_102_0[1].buffGroupId then
				for iter_102_0, iter_102_1 in ipairs(var_102_0[1].buffGroupId[1]) do
					var_102_1[iter_102_1] = true
				end

				arg_102_0.replaceGroupBuffIdMap.cache[arg_102_2] = {
					assignGroup = var_102_1,
					convertGroup = var_102_0[1].buffGroupId[2]
				}
			end
		end

		if arg_102_1 > arg_102_0.maxReplaceGroupBuffId then
			arg_102_0.maxReplaceGroupBuffId = arg_102_1
		end
	end

	for iter_102_2, iter_102_3 in arg_102_0.backHeros:order_pairs() do
		iter_102_3:clearBuffImmune()
	end

	for iter_102_4, iter_102_5 in arg_102_0:ipairsHeros() do
		iter_102_5:clearBuffImmune()
	end
end

function SceneModel.getExistLastSceneAlterBuff(arg_103_0)
	if arg_103_0.replaceGroupBuffIdMap == nil then
		return -1
	end

	if arg_103_0.maxReplaceGroupBuffId ~= -1 then
		local var_103_0 = arg_103_0.replaceGroupBuffIdMap.map[arg_103_0.maxReplaceGroupBuffId]

		return var_103_0, arg_103_0.replaceGroupBuffIdMap.cache[var_103_0]
	end

	local var_103_1 = -1
	local var_103_2 = -1

	for iter_103_0, iter_103_1 in pairs(arg_103_0.replaceGroupBuffIdMap.map) do
		if var_103_1 < iter_103_0 then
			var_103_1 = iter_103_0
			var_103_2 = iter_103_1
		end
	end

	arg_103_0.maxReplaceGroupBuffId = var_103_1

	return var_103_2, arg_103_0.replaceGroupBuffIdMap.cache[var_103_2]
end

function SceneModel.updateBeAttackZOrder(arg_104_0)
	arg_104_0.beAttackZOrder = arg_104_0.beAttackZOrder + 1
end

local var_0_0 = {
	[battle.FilterObjectType.noAlreadyDead] = function(arg_105_0)
		return arg_105_0 and arg_105_0:isAlreadyDead()
	end,
	[battle.FilterObjectType.noRealDeath] = function(arg_106_0)
		return arg_106_0 and arg_106_0:isRealDeath()
	end,
	[battle.FilterObjectType.excludeEnvObj] = function(arg_107_0, arg_107_1)
		if arg_107_0 and arg_107_1.fromObj and (not arg_107_1.skillFormulaType or arg_107_1.skillFormulaType == battle.SkillFormulaType.damage) then
			return arg_107_0.id == arg_107_1.fromObj.id
		end
	end,
	[battle.FilterObjectType.excludeObjLevel1] = function(arg_108_0, arg_108_1)
		return arg_108_0 and arg_108_0:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, arg_108_1)
	end
}

function SceneModel.getFilterObjects(arg_109_0, arg_109_1, arg_109_2, ...)
	local var_109_0 = {}

	if arg_109_1 == 3 then
		arg_109_1 = 1
		var_109_0 = arg_109_0:getFilterObjects(3 - arg_109_1, arg_109_2, ...)
	end

	for iter_109_0, iter_109_1 in arg_109_0:getHerosMap(arg_109_1):order_pairs() do
		local var_109_1 = arg_109_0:getFilterObject(iter_109_1.id, arg_109_2, ...)

		if var_109_1 then
			table.insert(var_109_0, var_109_1)
		end
	end

	table.sort(var_109_0, function(arg_110_0, arg_110_1)
		return arg_110_0.id < arg_110_1.id
	end)

	return var_109_0
end

function SceneModel.getFilterObject(arg_111_0, arg_111_1, arg_111_2, ...)
	local var_111_0 = arg_111_0:getObject(arg_111_1)
	local var_111_1 = {
		...
	}

	if table.length(var_111_1) == 1 and type(var_111_1[1]) == "table" then
		var_111_1 = var_111_1[1]
	end

	for iter_111_0, iter_111_1 in ipairs(var_111_1) do
		if var_0_0[iter_111_1](var_111_0, arg_111_2 or {}) then
			return
		end
	end

	return var_111_0
end

function SceneModel.ipairsHeros(arg_112_0)
	if arg_112_0.herosOrder == nil then
		local var_112_0 = itertools.iter(arg_112_0:getHerosMap(1):pairs())
		local var_112_1 = itertools.iter(arg_112_0:getHerosMap(2):pairs())

		arg_112_0.herosOrder = itertools.values(itertools.chain({
			var_112_0,
			var_112_1
		}))

		table.sort(arg_112_0.herosOrder, function(arg_113_0, arg_113_1)
			return arg_113_0.id < arg_113_1.id
		end)
	end

	return ipairs(arg_112_0.herosOrder)
end

function SceneModel.createBuffCollection(arg_114_0)
	local var_114_0 = CCollection.new()

	var_114_0:add_index(CCollection.index.new("buff"):order(BuffModel.BuffCmp):default())
	var_114_0:add_index(CCollection.index.new("easyEffectFunc"):hash({
		"csvCfg",
		"easyEffectFunc"
	}))
	var_114_0:add_index(CCollection.index.new("groupID"):hash({
		"csvCfg",
		"group"
	}))
	var_114_0:add_index(CCollection.index.new("cfgId"):hash("cfgId"))

	return var_114_0
end

function SceneModel.createBuffMap(arg_115_0)
	return CMap.new(BuffModel.BuffCmp)
end

function SceneModel.checkBackStageObjs(arg_116_0)
	for iter_116_0, iter_116_1 in arg_116_0.backHeros:order_pairs() do
		if iter_116_1.frontStageTarget and not arg_116_0:getObjectBySeatExcludeDead(iter_116_1.frontStageTarget) then
			arg_116_0:addObj(iter_116_1.force, iter_116_1)
			arg_116_0.backHeros:erase(iter_116_1.id)
			iter_116_1:doFrontStage()
		end
	end
end

function SceneModel.overAssignTypeBuffs(arg_117_0, arg_117_1)
	local var_117_0

	if arg_117_1 == "markId" then
		for iter_117_0, iter_117_1 in arg_117_0:ipairsHeros() do
			local var_117_1 = gGameEndSpeRuleCsv[iter_117_1.markID]

			if var_117_1 then
				for iter_117_2, iter_117_3 in ipairs(var_117_1.buffID) do
					local var_117_2 = iter_117_1:getBuff(iter_117_3)

					if var_117_2 and not var_117_2.csvCfg.waveInherit then
						var_117_2:overClean()
					end
				end
			end
		end
	end
end

function SceneModel.waitJumpOneWave(arg_118_0, arg_118_1)
	if not arg_118_1 then
		return arg_118_0:modelWait("jump_wave", arg_118_0.waitJumpOneWave)
	end

	arg_118_0.play:onWaveEffectClean()
end

function SceneModel.tirggerFieldBuffs(arg_119_0, arg_119_1, arg_119_2)
	local var_119_0 = battle.BuffTriggerPoint.onBuffTrigger

	local function var_119_1(arg_120_0, arg_120_1)
		local var_120_0 = {
			buffId = arg_120_0.id,
			obj = arg_120_1
		}

		if arg_120_0:isTrigger(var_119_0, var_120_0) then
			arg_120_0:updateWithTrigger(var_119_0, var_120_0)
		end
	end

	if arg_119_1 then
		for iter_119_0, iter_119_1 in arg_119_0.fieldBuffs:order_pairs() do
			var_119_1(iter_119_1, arg_119_1)
		end
	end

	if arg_119_2 then
		for iter_119_2, iter_119_3 in arg_119_0:ipairsHeros() do
			if not iter_119_3:isAlreadyDead() and not iter_119_3:isLeaveField() then
				var_119_1(arg_119_2, iter_119_3)
			end
		end
	end
end

function SceneModel.getExtraBattleRoundMode(arg_121_0)
	if arg_121_0.play.extraBattleRoundData then
		return arg_121_0.play.extraBattleRoundData.mode
	end

	return nil
end

function SceneModel.getConvertGroupCache(arg_122_0)
	local var_122_0, var_122_1 = arg_122_0:getExistLastSceneAlterBuff()

	if var_122_0 ~= -1 and var_122_1 then
		return var_122_1
	end

	return nil
end

function SceneModel.checkCowWithBuff(arg_123_0, arg_123_1)
	local var_123_0 = false

	if arg_123_1 then
		if not itertools.include(gFormulaConst.Lethalcheck(), arg_123_1:group()) then
			return
		end

		var_123_0 = arg_123_1.isOver
	end

	arg_123_0.cowEnableCount = arg_123_0.cowEnableCount + battleEasy.ifElse(var_123_0, -1, 1)
end

function SceneModel.setCsvObject(arg_124_0, arg_124_1)
	arg_124_0.csvObject = arg_124_1
end

function SceneModel.getCsvObject(arg_125_0)
	return arg_125_0.csvObject
end

local var_0_1 = setmetatable({}, {
	__mode = "k"
})

function SceneModel.battleReport(arg_126_0, arg_126_1, arg_126_2)
	if ANTI_AGENT then
		return
	end

	if device.platform == "windows" then
		return
	end

	if var_0_1[arg_126_0] or arg_126_0.isRecord then
		return
	end

	var_0_1[arg_126_0] = true

	local var_126_0 = table.shallowcopy(arg_126_0.data)

	var_126_0.sceneID = arg_126_0.sceneID or 0
	var_126_0.gateType = arg_126_0.gateType or 0

	battleReport({
		play_record = var_126_0,
		traceback = arg_126_2 or "",
		desc = arg_126_1 or ""
	})
end
