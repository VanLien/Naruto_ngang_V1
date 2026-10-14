local var_0_0 = class("SyncFightGate", battlePlay.Gate)

battlePlay.SyncFightGate = var_0_0

local var_0_1 = game.SYNC_SCENE_STATE
local var_0_2 = {
	attack = 5,
	record = 7,
	wait = 6,
	waitloading = 4
}

var_0_0.OperatorArgs = {
	canHandle = true,
	isAuto = false,
	isFullManual = true,
	canSpeedAni = false,
	canPause = true,
	canSkip = false
}
var_0_0.SpecEndRuleCheck = {
	battle.EndSpecialCheck.HpRatioCheck,
	battle.EndSpecialCheck.ForceNum
}

local var_0_3 = {
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	1,
	2,
	3,
	4,
	5,
	6
}

function var_0_0.ctor(arg_1_0, arg_1_1)
	battlePlay.Gate.ctor(arg_1_0, arg_1_1)

	arg_1_0.locals = {
		frame_id = 0,
		skill = 0,
		who = 0,
		target = 0,
		state = var_0_2.waitloading,
		scene_state = var_0_1.waitloading
	}
	arg_1_0.remote = {}
	arg_1_0.nexts = {}
	arg_1_0.waitRecv = true
	arg_1_0.isBattleTurnEnd = false
	arg_1_0.sortOrderTb = {
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

function var_0_0.init(arg_2_0, arg_2_1)
	battlePlay.Gate.init(arg_2_0, arg_2_1)
	arg_2_0:initSyncFightData()

	arg_2_0.locals.scene_state = gGameModel.battle.state:read()

	printDebug("operateForce %d", arg_2_0.operateForce)
	gGameModel.battle:register({
		[var_0_1.attack] = function()
			if arg_2_0.locals.scene_state == var_0_1.waitloading then
				arg_2_0.locals.scene_state = var_0_1.attack

				arg_2_0:initLocalState()
				battleEasy.queueNotify("playOnlineFightState")
			end
		end
	})
	idlereasy.when(gGameModel.battle.error, function(arg_4_0, arg_4_1)
		if arg_4_1 and arg_4_1 ~= "" then
			gGameUI:switchUI("city.view")
			gGameUI:showTip(gLanguageCsv.onlineFightBanError)
		end
	end)

	if arg_2_0.locals.scene_state == var_0_1.waitloading then
		gGameModel.battle:ready()
	end

	gRootViewProxy:notify("showVsPvpView", 1)
end

function var_0_0.initSyncFightData(arg_5_0)
	arg_5_0.locals.frame_id = 1

	gRootViewProxy:proxy():addSpecModule(battleModule.onlineFightMods)

	local var_5_0, var_5_1 = table.length(arg_5_0.sortOrderTb)

	for iter_5_0 = 1, table.length(arg_5_0.sortOrderTb) do
		local var_5_2 = ymrand.random(1, var_5_0 - iter_5_0 + 1)

		table.swapvalue(arg_5_0.sortOrderTb, var_5_0 - iter_5_0 + 1, var_5_2)
	end
end

function var_0_0.getObjectBaseSpeedRankSortKey(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.operateForce == 2 and battleEasy.mirrorSeat(arg_6_1.seat) or arg_6_1.seat

	return arg_6_0.sortOrderTb[var_6_0]
end

function var_0_0.newWaveAddObjsStrategy(arg_7_0)
	arg_7_0:addCardRoles(1)
	arg_7_0:addCardRoles(2)
	arg_7_0:doObjsAttrsCorrect(true, true)
	battlePlay.Gate.newWaveAddObjsStrategy(arg_7_0)
end

function var_0_0.playEnterAnimation(arg_8_0, arg_8_1)
	battlePlay.Gate.playEnterAnimation(arg_8_0, arg_8_1)
	battleEasy.queueEffect("delay", {
		lifetime = 1000
	})
	battleEasy.queueNotify("playOnlineFightState")
end

function var_0_0.runOneFrame(arg_9_0)
	if arg_9_0:isRemoteNotStart() then
		return true
	end

	local var_9_0 = arg_9_0:getFrameInRemote(arg_9_0.locals.frame_id)

	if var_9_0 then
		printDebug(string.format("SyncFightGate onceBattle %d use skill(%d) attack %d", var_9_0.who, var_9_0.skill, var_9_0.target))
		arg_9_0:mirrorData(var_9_0)

		if arg_9_0:getCurHeroSeat() ~= var_9_0.who then
			errorInWindows("SyncFightGate curHeroSeat(%d),remote who(%d) is not same", arg_9_0:getCurHeroSeat(), var_9_0.who)

			if arg_9_0.locals.state == var_0_2.record then
				gGameUI:showTip(gLanguageCsv.crossCraftPlayNotExisted)

				return arg_9_0:runGameEnd()
			else
				arg_9_0.scene.isBattleAllEnd = true

				gGameUI:showDialog({
					btnType = 1,
					clearFast = true,
					content = gLanguageCsv.battleErrorReloadGame,
					cb = function()
						gGameUI:switchUI("city.view")
					end
				})

				return
			end
		end

		arg_9_0.curHero = arg_9_0.scene:getObjectBySeat(var_9_0.who)
		arg_9_0.remote = var_9_0

		battleEasy.queueNotify("hideStateTips")
		arg_9_0:onceBattle(var_9_0.target, var_9_0.skill)

		arg_9_0.locals.frame_id = arg_9_0.locals.frame_id + 1

		if not arg_9_0:isRemoteOver() then
			arg_9_0:sendRandomCount()
		end

		return true
	end

	if arg_9_0:isRemoteOver() then
		arg_9_0:runGameEnd()

		return true
	end

	return false
end

function var_0_0.setAttack(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.waitRecv and arg_11_0.locals.state == var_0_2.attack then
		battlePlay.Gate.setAttack(arg_11_0, arg_11_1, arg_11_2)

		arg_11_0.locals.who = arg_11_0.curHero.seat
		arg_11_0.locals.target = arg_11_0.handleInput[1]
		arg_11_0.locals.skill = arg_11_0.handleInput[2]
		arg_11_0.handleInput = nil
		arg_11_0.waitRecv = true

		arg_11_0:syncAction()
	end
end

function var_0_0.isNowTurnAutoFight(arg_12_0)
	if arg_12_0.scene.autoFight then
		return true
	end

	if not arg_12_0:isMyTurn() then
		return true
	end

	if arg_12_0.curHero and (arg_12_0.curHero:isSelfChargeOK() or arg_12_0.curHero:isNeedAutoFightByBuff()) then
		return true
	end

	if arg_12_0:getFrameInRemote(arg_12_0.locals.frame_id + 1) then
		return true
	end
end

function var_0_0.isAutoFight(arg_13_0)
	if arg_13_0.scene.autoFight then
		return true
	end

	if arg_13_0.curHero and (arg_13_0.curHero:isNeedAutoFightByBuff() or arg_13_0.curHero:isSelfChargeOK()) then
		return true
	end

	return false
end

function var_0_0.onceBattle(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.scene.autoFight

	arg_14_0.scene.autoFight = false

	battlePlay.Gate.onceBattle(arg_14_0, arg_14_1, arg_14_2)

	if arg_14_0.locals.state ~= var_0_2.record then
		if arg_14_0.locals.scene_state == var_0_1.attack then
			arg_14_0:initLocalState()
		elseif arg_14_0.locals.scene_state == var_0_1.waitloading then
			battleEasy.queueEffect(function()
				gRootViewProxy:call("showSKillUIWidgets", false)
			end)
		end
	end

	if arg_14_0.waitInput then
		battleEasy.queueNotify("playOnlineFightState")
	end

	arg_14_0.scene.autoFight = var_14_0
end

function var_0_0.initLocalState(arg_16_0)
	arg_16_0.locals.state = arg_16_0:isMyTurn() and var_0_2.attack or var_0_2.wait
	arg_16_0.waitRecv = arg_16_0.locals.state ~= var_0_2.attack
end

function var_0_0.onNewBattleTurn(arg_17_0)
	battlePlay.Gate.onNewBattleTurn(arg_17_0)

	if arg_17_0.remote.hero_status and next(arg_17_0.remote.hero_status) then
		for iter_17_0 = 1, 12 do
			local var_17_0 = arg_17_0.scene:getObject(iter_17_0)
			local var_17_1 = arg_17_0:parseHeroStatus(arg_17_0.remote.hero_status[iter_17_0])

			arg_17_0:syncObjViewFromServer(var_17_0, var_17_1)
		end
	end
end

local function var_0_4(arg_18_0, arg_18_1)
	return function(arg_19_0, ...)
		if arg_18_1 then
			return arg_19_0[arg_18_0](arg_19_0)
		else
			return arg_19_0[arg_18_0](arg_19_0, ...)
		end
	end
end

local function var_0_5(arg_20_0, arg_20_1)
	return function(arg_21_0, arg_21_1)
		if arg_20_1 then
			return arg_21_0[arg_20_0]
		else
			arg_21_0[arg_20_0] = arg_21_1
		end
	end
end

local var_0_6 = {
	hp = {
		sync = 1,
		get = var_0_4("hp", true),
		set = var_0_4("setHP", false)
	},
	mp1 = {
		sync = 2,
		get = var_0_4("mp1", true),
		set = var_0_4("setMP1", false)
	},
	state = {
		sync = 3,
		get = var_0_5("state", true),
		set = var_0_5("state", false)
	}
}

function var_0_0.syncObjViewFromServer(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_1 and arg_22_2 then
		local var_22_0 = false
		local var_22_1 = arg_22_1:isDeath()

		for iter_22_0, iter_22_1 in pairs(var_0_6) do
			if not battleEasy.numEqual(iter_22_1.get(arg_22_1), arg_22_2[iter_22_0]) then
				var_22_0 = true

				iter_22_1.set(arg_22_1, arg_22_2[iter_22_0])
			end
		end

		if var_22_0 then
			battleEasy.queueEffect(function()
				arg_22_1.view:proxy():onUpdateLifebar({
					mpPer = arg_22_1:mp1() / arg_22_1:mp1Max() * 100,
					hpPer = arg_22_1:hp() / arg_22_1:hpMax() * 100
				})
			end, {
				zOrder = battle.EffectZOrder.sync
			})

			if var_22_1 ~= arg_22_1:isDeath() then
				arg_22_1:setDead()
			end
		end
	end
end

function var_0_0.parseHeroStatus(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return
	end

	local var_24_0 = {}

	for iter_24_0, iter_24_1 in pairs(var_0_6) do
		var_24_0[iter_24_0] = arg_24_1[iter_24_1.sync]
	end

	return var_24_0
end

function var_0_0.syncAction(arg_25_0)
	printDebug(string.format("!!!!!!!!! onceBattle send frame:%d, who:%d, target:%d, skill:%d", arg_25_0.locals.frame_id, arg_25_0.locals.who, arg_25_0.locals.target, arg_25_0.locals.skill))
	arg_25_0:mirrorData(arg_25_0.locals)
	gGameModel.battle:attack(arg_25_0.locals.frame_id, arg_25_0.locals.who, arg_25_0.locals.target, arg_25_0.locals.skill)
end

function var_0_0.sendExitGameMsg(arg_26_0)
	if arg_26_0.curRound > gCommonConfigCsv.onlineFightFleeRoundLimit then
		gGameModel.battle:giveup()
	else
		gGameModel.battle:flee()
	end
end

function var_0_0.makeEndViewInfos(arg_27_0)
	local var_27_0 = gGameModel.daily_record
	local var_27_1, var_27_2 = arg_27_0:whoHighestDamageFromStats(1)

	return {
		flag = "onlineFight",
		recordType = "jf",
		result = arg_27_0.result,
		awardRemainTime = math.max(csv.cross.online_fight.base[1].matchTime - var_27_0:read("cross_online_fight_times"), 0),
		mvpPosId = arg_27_0.operateForce == 2 and battleEasy.mirrorSeat(var_27_2) or var_27_2
	}
end

function var_0_0.postEndResultToServer(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0:makeEndViewInfos()

	if not ANTI_AGENT and arg_28_0.locals.state ~= var_0_2.record then
		gGameApp.net:doRealtimeEnd()
	end

	gRootViewProxy:raw():postEndResultToServer("/game/cross/online/battle/end", function(arg_29_0)
		if arg_29_0 and arg_29_0.view then
			if arg_29_0.view.pattern == 1 then
				arg_29_0.view.score = arg_29_0.view.unlimited_score
				arg_29_0.view.topRank = arg_29_0.view.unlimited_top_score
			elseif arg_29_0.view.pattern == 2 then
				arg_29_0.view.score = arg_29_0.view.limited_score
				arg_29_0.view.topRank = arg_29_0.view.limited_top_score
			end

			arg_29_0.view.rank_move = arg_29_0.view.delta
			arg_29_0.view.rank = arg_29_0.view.score
			arg_29_0.view.top_move = battleEasy.ifElse(arg_29_0.view.top_move, 1, 0)
			arg_28_0.result = arg_29_0.view.result
			var_28_0.result = arg_29_0.view.result
			var_28_0.showReward = arg_29_0.view.award ~= nil
			var_28_0.showMvpView = (arg_29_0.view.enemy_result == "fail" or arg_29_0.view.enemy_result == "giveup") and var_28_0.mvpPosId
		else
			var_28_0.fromRecord = true
			var_28_0.showMvpView = false
			var_28_0.showReward = false
		end

		arg_28_1(var_28_0, arg_29_0)
	end)
end

function var_0_0.mirrorData(arg_30_0, arg_30_1)
	if arg_30_0.operateForce == 1 then
		return
	end

	if arg_30_1.who ~= 0 then
		arg_30_1.who = battleEasy.mirrorSeat(arg_30_1.who)
	end

	if arg_30_1.target ~= 0 then
		arg_30_1.target = battleEasy.mirrorSeat(arg_30_1.target)
	end
end

function var_0_0.getCurHeroSeat(arg_31_0)
	if arg_31_0.curHero then
		return arg_31_0.curHero.seat
	end

	return 0
end

function var_0_0.isRemoteOver(arg_32_0)
	return gGameModel.battle.remote.state == var_0_1.battleover
end

function var_0_0.isRemoteNotStart(arg_33_0)
	return gGameModel.battle.remote.state == var_0_1.unknown or gGameModel.battle.remote.state == var_0_1.waitloading or arg_33_0.totalRoundBattleTurn < 1
end

function var_0_0.getFrameInRemote(arg_34_0, arg_34_1)
	return gGameModel.battle:getFrameInRemote(arg_34_1)
end

function var_0_0.getoffLineTb(arg_35_0)
	return gGameModel.battle.remote.offline
end

function var_0_0.getCountDown(arg_36_0)
	local var_36_0 = math.ceil(math.max(gGameModel.battle.remote.countdown - (time.getTime() - gGameModel.battle.remote.countdown_timestamp), 0))

	return time.getCutDown(var_36_0)
end

function var_0_0.onBattleEndSupply(arg_37_0)
	battleEasy.queueNotify("hideStateTips")
end

function var_0_0.sendRandomCount(arg_38_0)
	return gGameModel.battle:sendRandomCount()
end

function var_0_0.isLocalSlow(arg_39_0)
	if arg_39_0.locals.state == var_0_2.record then
		return
	end

	return gGameModel.battle:isLocalSlow(arg_39_0.locals.frame_id)
end

function var_0_0.isWonderfulRecord(arg_40_0)
	local var_40_0 = arg_40_0.result == "win" and 1 or 2
	local var_40_1 = arg_40_0.scene:getHerosMap(var_40_0)
	local var_40_2 = {
		0,
		0
	}

	for iter_40_0, iter_40_1 in var_40_1:order_pairs() do
		var_40_2[1] = var_40_2[1] + iter_40_1:hp()
		var_40_2[2] = var_40_2[2] + iter_40_1:hpMax()
	end

	return arg_40_0:getTotalRounds() > gCommonConfigCsv.onlineFightWdfRecordRound and var_40_2[2] > 0 and var_40_2[1] / var_40_2[2] > gCommonConfigCsv.onlineFightWdfRecordLimit
end

local var_0_7 = class("SyncFightGateRecord", var_0_0)

battlePlay.SyncFightGateRecord = var_0_7
var_0_7.OperatorArgs = {
	canHandle = true,
	isAuto = true,
	isFullManual = true,
	canSpeedAni = false,
	canPause = true,
	canSkip = true
}
var_0_7.SpecEndRuleCheck = {}

function var_0_7.init(arg_41_0, arg_41_1)
	battlePlay.Gate.init(arg_41_0, arg_41_1)

	arg_41_0.frames = arg_41_1.frames or {}
	arg_41_0.locals.state = var_0_2.record

	arg_41_0:initSyncFightData()
end

function var_0_7.syncAction(arg_42_0)
	return
end

function var_0_7.sendExitGameMsg(arg_43_0)
	gGameUI:switchUI("city.view")
end

function var_0_7.isRemoteOver(arg_44_0)
	return table.length(arg_44_0.frames) < arg_44_0.locals.frame_id or table.length(arg_44_0.frames) == 0
end

function var_0_7.runGameEnd(arg_45_0, arg_45_1)
	battlePlay.Gate.runGameEnd(arg_45_0, arg_45_0.data.result)
end

function var_0_7.isRemoteNotStart(arg_46_0)
	return arg_46_0.totalRoundBattleTurn < 1
end

function var_0_7.getFrameInRemote(arg_47_0, arg_47_1)
	if arg_47_0.frames[arg_47_1] then
		local var_47_0 = arg_47_0.frames[arg_47_1].input

		return {
			frame_id = var_47_0[1],
			who = var_47_0[2],
			target = var_47_0[3],
			skill = var_47_0[4]
		}
	end
end

function var_0_7.getoffLineTb(arg_48_0)
	return {
		false,
		false
	}
end

function var_0_7.getCountDown(arg_49_0)
	return {
		sec = 15,
		secstr = 15,
		clock_str = 15
	}
end

function var_0_7.isNowTurnAutoFight(arg_50_0)
	return true
end

function var_0_7.sendRandomCount(arg_51_0)
	return false
end
