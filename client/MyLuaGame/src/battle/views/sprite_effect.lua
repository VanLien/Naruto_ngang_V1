local var_0_0 = 9527

local function var_0_1(arg_1_0, arg_1_1)
	if arg_1_1 == nil then
		return {}
	end

	local var_1_0 = arg_1_1.delay
	local var_1_1 = {}

	for iter_1_0, iter_1_1 in pairs(battle.EffectEventArgFields) do
		if arg_1_1[iter_1_1[1]] then
			local var_1_2 = {
				delay = var_1_0,
				processID = arg_1_0
			}

			for iter_1_2, iter_1_3 in ipairs(iter_1_1) do
				var_1_2[iter_1_3] = csvClone(arg_1_1[iter_1_3])
			end

			var_1_1[iter_1_0] = var_1_2
		end
	end

	return var_1_1
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_1 then
		return true
	end

	if not arg_2_1[arg_2_0] then
		return true
	end

	if not arg_2_1[arg_2_0][arg_2_2] then
		return true
	end

	return false
end

local function var_0_3(arg_3_0)
	if ANTI_AGENT then
		return
	end

	checkSpecificCsvCheat("effect_event", itertools.ivalues({
		arg_3_0
	}))
end

local function var_0_4(arg_4_0, arg_4_1)
	if arg_4_1 and type(arg_4_1) == "string" and arg_4_1 ~= "" then
		local var_4_0 = {
			sound = {}
		}

		var_4_0.sound.res = "hero_sound/" .. arg_4_1 .. ".mp3"
		var_4_0.sound.loop = 0

		table.insert(arg_4_0.battleView.effectJumpCache, arg_4_0.battleView:onEventEffect(arg_4_0, "sound", var_4_0))
	end
end

local function var_0_5(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0:popEffectInfo(arg_5_1)

	if arg_5_1 == 1 and var_5_0 == nil then
		return
	end

	local var_5_1
	local var_5_2

	if var_5_0 then
		var_5_1, var_5_2 = var_5_0.effectID, var_5_0.processID
	else
		var_5_1 = gEffectByEventCsv[arg_5_1]
	end

	if arg_5_0:popIgnoreEffect(var_5_2, arg_5_1) then
		return
	end

	local var_5_3 = csv.effect_event[var_5_1]
	local var_5_4 = arg_5_0:getProcessArgs(var_5_2)

	logf.battle.sprite.event("effect_event: eventID= %s, effectID= %s, processID= %s", arg_5_1, var_5_1, var_5_2)

	if var_5_3 then
		var_0_3(var_5_1)
		log.battle.sprite.event(arg_5_0.unitID, var_5_4)

		if not arg_5_0.battleView:getEffectEventEnable() then
			arg_5_0:dealJumpSkillEffect(var_5_4)

			return
		end

		if var_5_4 then
			local var_5_5 = arg_5_0.battleView
			local var_5_6 = var_0_1(var_5_2, var_5_3)

			for iter_5_0, iter_5_1 in pairs(var_5_6) do
				for iter_5_2, iter_5_3 in ipairs(var_5_4.viewTargets) do
					local var_5_7 = clone(iter_5_1)

					var_5_7.effectID = var_5_1
					var_5_7.processArgs = var_5_4

					if not var_5_7.targets then
						var_5_7.targets = {}
					end

					table.insert(var_5_7.targets, var_5_5:onViewProxyCall("getSceneObj", tostring(iter_5_3)))

					if iter_5_0 == "follow" then
						var_5_7.index = iter_5_2
						var_5_7.faceTo = iter_5_3.faceTo
					else
						var_5_7.faceTo = arg_5_0.faceTo
					end

					var_5_7.fromSprite = arg_5_0

					if iter_5_0 == "music" then
						iter_5_0 = "sound"
					end

					if var_5_3.effectType == 2 then
						var_5_7.exhit = var_5_3.effectRes
					end

					if var_0_2(iter_5_3.id, var_5_4.ignoreEvenet, iter_5_0) then
						table.insert(var_5_5.effectJumpCache, var_5_5:onEventEffect(iter_5_3, iter_5_0, var_5_7))
					else
						arg_5_0:dealCantPlayEffect(var_5_4, iter_5_3)
					end
				end
			end

			if var_5_4.otherTargets and var_5_3.onlyTargetShow then
				for iter_5_4, iter_5_5 in pairs(var_5_4.otherTargets) do
					table.insert(var_5_5.effectJumpCache, var_5_5:onEventEffect(iter_5_5, "show", {
						show = {
							{
								hide = true
							}
						}
					}))
				end
			end

			if var_5_4.deferList and var_5_4.deferList[var_5_4.process.id] then
				table.insert(var_5_5.effectJumpCache, var_5_5:onEventEffect(obj, "callback", {
					delay = 0,
					func = function()
						var_5_5:runDefer(var_5_4.deferList[var_5_4.process.id])
					end
				}))
			end
		else
			arg_5_0:onAddEffectsByCsv(var_5_2, var_5_1, var_5_3)
		end

		if var_5_3.otherEventIDs then
			for iter_5_6, iter_5_7 in ipairs(var_5_3.otherEventIDs) do
				var_0_5(arg_5_0, iter_5_7)
			end
		end
	elseif arg_5_1 ~= 1 then
		printWarn("no effect_event eventID= %s, effectID= %s, processID= %s", arg_5_1, var_5_1, var_5_2)
	end
end

local function var_0_6(arg_7_0, arg_7_1)
	if arg_7_0.spineActionScales[arg_7_1] and arg_7_0.spinePrevAction == arg_7_1 then
		arg_7_0:setScaleX(arg_7_0._scaleX, true)
		arg_7_0:setScaleY(arg_7_0._scaleY, true)

		arg_7_0.spinePrevAction = nil
	end
end

function BattleSprite.getProcessArgs(arg_8_0, arg_8_1)
	return arg_8_0.effectProcessArgs[arg_8_1]
end

function BattleSprite.dealJumpSkillEffect(arg_9_0, arg_9_1)
	if arg_9_1 then
		for iter_9_0, iter_9_1 in ipairs(arg_9_1.viewTargets) do
			if arg_9_1.values then
				local var_9_0 = arg_9_1.values[iter_9_1.id]

				if var_9_0 then
					for iter_9_2, iter_9_3 in ipairs(var_9_0) do
						arg_9_0.battleView:filter(battle.FilterDeferListTag.cantJump):runDefer(iter_9_3 and iter_9_3.deferList)
					end
				end
			end
		end

		if arg_9_1.deferList and arg_9_1.deferList[arg_9_1.process.id] then
			table.insert(arg_9_0.battleView.effectJumpCache, arg_9_0.battleView:onEventEffect(tostring(obj), "callback", {
				delay = 0,
				func = function()
					arg_9_0.battleView:filter(battle.FilterDeferListTag.cantJump):runDefer(arg_9_1.deferList[arg_9_1.process.id])
				end
			}))
		end
	end
end

function BattleSprite.dealCantPlayEffect(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 and arg_11_1.values then
		local var_11_0 = arg_11_1.values[arg_11_2.id]

		if not var_11_0 then
			return
		end

		for iter_11_0, iter_11_1 in ipairs(var_11_0) do
			table.insert(arg_11_0.battleView.effectJumpCache, arg_11_0.battleView:onEventEffect(tostring(arg_11_2), "callback", {
				delay = 0,
				func = function()
					arg_11_0.battleView:filter(battle.FilterDeferListTag.cantJump):runDefer(iter_11_1.deferList)
				end
			}))
		end
	end
end

local var_0_7 = {
	[sp.EventType.ANIMATION_EVENT] = function(arg_13_0, arg_13_1)
		local var_13_0 = arg_13_1.eventData.intValue

		log.battle.sprite.event(" ---- 触发 动画配置的事件参数 eventType= eventID=", arg_13_0.id, event, var_13_0)

		if var_13_0 == var_0_0 then
			var_0_4(arg_13_0, arg_13_1.eventData.name)
		else
			var_0_5(arg_13_0, var_13_0)
		end
	end,
	[sp.EventType.ANIMATION_START] = function(arg_14_0, arg_14_1)
		local var_14_0 = arg_14_1.animation
		local var_14_1 = arg_14_0.spineActionScales[var_14_0]

		if var_14_1 then
			arg_14_0.sprite:setScaleX(var_14_1)
			arg_14_0.sprite:setScaleY(var_14_1)

			arg_14_0.spinePrevAction = var_14_0
		end

		performWithDelay(arg_14_0, function()
			var_0_5(arg_14_0, 1)
		end, 0)
	end,
	[sp.EventType.ANIMATION_INTERRUPT] = function(arg_16_0, arg_16_1)
		return var_0_6(arg_16_0, arg_16_1.animation)
	end,
	[sp.EventType.ANIMATION_END] = function(arg_17_0, arg_17_1)
		return var_0_6(arg_17_0, arg_17_1.animation)
	end,
	[sp.EventType.ANIMATION_COMPLETE] = function(arg_18_0, arg_18_1)
		if battle.LoopActionMap[arg_18_1.animation] then
			return
		end

		if arg_18_0.actionCompleteCallback then
			arg_18_0.actionCompleteCallback(arg_18_1.animation, arg_18_1.loopCount)

			arg_18_0.actionCompleteCallback = nil
		end
	end
}

function BattleSprite.onSpriteEvent(arg_19_0, arg_19_1, arg_19_2)
	var_0_7[arg_19_1](arg_19_0, arg_19_2)
end

function BattleSprite.popEffectInfo(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:getRealUseView()
	local var_20_1 = arg_20_0.spineEventMap[var_20_0 and var_20_0.actionState or arg_20_0.actionState]

	if var_20_1 and #var_20_1 > 0 then
		for iter_20_0, iter_20_1 in ipairs(var_20_1) do
			if iter_20_1.eventID == arg_20_1 then
				return table.remove(var_20_1, iter_20_0)
			end
		end
	end
end

function BattleSprite.saveEffectInfo(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = csv.effect_event[arg_21_3]

	if not var_21_0 or not var_21_0.eventID then
		return
	end

	arg_21_0.spineEventMap[arg_21_1] = arg_21_0.spineEventMap[arg_21_1] or {}

	table.insert(arg_21_0.spineEventMap[arg_21_1], {
		processID = arg_21_2,
		effectID = arg_21_3,
		eventID = var_21_0.eventID
	})
end

function BattleSprite.saveIgnoreEffect(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = csv.effect_event[arg_22_2]

	if not var_22_0 or not var_22_0.eventID then
		return
	end

	arg_22_0.ignoreEffectMap = arg_22_0.ignoreEffectMap or {}

	table.insert(arg_22_0.ignoreEffectMap, {
		processID = arg_22_1,
		effectID = arg_22_2,
		eventID = var_22_0.eventID
	})
end

function BattleSprite.popIgnoreEffect(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.ignoreEffectMap then
		return false
	end

	for iter_23_0, iter_23_1 in ipairs(arg_23_0.ignoreEffectMap) do
		if iter_23_1.eventID == arg_23_2 and (iter_23_1.processID == arg_23_1 or not arg_23_1) then
			table.remove(arg_23_0.ignoreEffectMap, iter_23_0)

			return true
		end
	end

	return false
end

function BattleSprite.onProcessArgs(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_2.viewTargets then
		arg_24_2.viewTargets = arg_24_2.targets
	end

	for iter_24_0, iter_24_1 in ipairs(arg_24_2.targets) do
		local var_24_0 = iter_24_1:getEventByKey(battle.ExRecordEvent.protectTarget)

		if var_24_0 and var_24_0.showProcess then
			local var_24_1 = var_24_0.obj

			if not itertools.include(arg_24_2.viewTargets, var_24_1) then
				table.insert(arg_24_2.viewTargets, var_24_1)

				if arg_24_2.values and not arg_24_2.values[var_24_1.id] and arg_24_2.values[iter_24_1.id] then
					arg_24_2.values[var_24_1.id] = clone(arg_24_2.values[iter_24_1.id])

					for iter_24_2, iter_24_3 in pairs(arg_24_2.values[var_24_1.id]) do
						iter_24_3.value = battleEasy.valueTypeTable()
					end
				end
			end
		end
	end

	arg_24_0.effectProcessArgs[arg_24_1] = arg_24_2
end

function BattleSprite.onProcessDel(arg_25_0, arg_25_1)
	arg_25_0.effectProcessArgs[arg_25_1] = nil
end

function BattleSprite.setSkillJumpSwitch(arg_26_0, arg_26_1)
	arg_26_0.skillJumpSwitchOnce = arg_26_1
end

function BattleSprite.onEventEffect(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_2.target or arg_27_0
	local var_27_1 = newEventEffect(arg_27_1, arg_27_0, arg_27_2, var_27_0)

	return arg_27_0.effectManager:addAndPlay(nil, var_27_1)
end

function BattleSprite.onEventEffectQueue(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0
	local var_28_1 = newEventEffect(arg_28_1, arg_28_0, arg_28_2, var_28_0)

	return arg_28_0.effectManager:queueAppend(var_28_1)
end

function BattleSprite.onEventEffectCancel(arg_29_0, arg_29_1)
	if arg_29_1.key then
		arg_29_0.effectManager:delAndStop(arg_29_1.key)
	elseif arg_29_1.queID then
		arg_29_0.effectManager:queueErase(arg_29_1.queID)
	end
end

function BattleSprite.onCleanEffectCache(arg_30_0)
	local var_30_0 = arg_30_0.actionState

	for iter_30_0, iter_30_1 in pairs(arg_30_0.spineEventMap) do
		arg_30_0.actionState = iter_30_0

		while next(iter_30_1) do
			local var_30_1, var_30_2 = next(iter_30_1)

			var_0_5(arg_30_0, var_30_2.eventID)
		end
	end

	arg_30_0.actionState = var_30_0

	for iter_30_2, iter_30_3 in ipairs(arg_30_0.battleView.effectJumpCache) do
		arg_30_0.battleView:onEventEffectCancel(iter_30_3)
	end

	arg_30_0.battleView.effectJumpCache = {}

	local var_30_3 = arg_30_0.battleView:onViewProxyCall("getSceneObjs")

	for iter_30_4, iter_30_5 in pairs(var_30_3) do
		iter_30_5.spineEventMap = {}

		for iter_30_6, iter_30_7 in ipairs(iter_30_5.effectJumpCache) do
			iter_30_5:onEventEffectCancel(iter_30_7)
		end
	end

	arg_30_0.effectJumpCache = {}

	arg_30_0:onUltJumpEnd()
end

function BattleSprite.globalEventEffectQueue(arg_31_0, arg_31_1, arg_31_2)
	return arg_31_0.battleView:onEventEffectQueueFor(arg_31_0, arg_31_1, arg_31_2)
end

function BattleSprite.onAddEventEffect(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if not arg_32_3 then
		return arg_32_0:globalEventEffectQueue(arg_32_1, arg_32_2)
	else
		return arg_32_0:onEventEffect(arg_32_1, arg_32_2)
	end
end

function BattleSprite.onAddEffectsByCsv(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0 = arg_33_0
	local var_33_1 = var_0_1(arg_33_1, arg_33_3)

	for iter_33_0, iter_33_1 in pairs(var_33_1) do
		if arg_33_4 == nil or arg_33_4[iter_33_0] then
			iter_33_1.effectID = arg_33_2
			iter_33_1.faceTo = arg_33_0.faceTo

			function iter_33_1.onComplete()
				return
			end

			local var_33_2 = newEventEffect(iter_33_0, arg_33_0, iter_33_1, var_33_0)

			table.insert(arg_33_0.effectJumpCache, arg_33_0.effectManager:addAndPlay(nil, var_33_2))
		end
	end
end

local var_0_8 = {
	[0] = function(arg_35_0, arg_35_1)
		local var_35_0 = arg_35_0.startYinyingPos
		local var_35_1 = cc.p(var_35_0.x * arg_35_0:getScaleX(), var_35_0.y)

		return cc.pAdd(var_35_1, arg_35_1)
	end,
	function(arg_36_0, arg_36_1)
		local var_36_0 = arg_36_0.unitCfg.everyPos.headPos

		return cc.pAdd(var_36_0, arg_36_1)
	end,
	function(arg_37_0, arg_37_1)
		local var_37_0 = arg_37_0.unitCfg.everyPos.hitPos

		return cc.pAdd(var_37_0, arg_37_1)
	end,
	function(arg_38_0, arg_38_1)
		local var_38_0 = (battle.StandingPos[2].x + battle.StandingPos[5].x) / 2

		var_38_0 = arg_38_0.model.force == 1 and var_38_0 or display.width - var_38_0

		return cc.pAdd(cc.p(var_38_0, battle.StandingPos[2].y), arg_38_1)
	end,
	function(arg_39_0, arg_39_1)
		local var_39_0 = (battle.StandingPos[2].x + battle.StandingPos[5].x) / 2

		var_39_0 = arg_39_0.model.force == 1 and display.width - var_39_0 or var_39_0

		return cc.pAdd(cc.p(var_39_0, battle.StandingPos[2].y), arg_39_1)
	end,
	function(arg_40_0, arg_40_1)
		return cc.pAdd(cc.p(battle.StandingPos[13].x, battle.StandingPos[2].y), arg_40_1)
	end,
	function(arg_41_0, arg_41_1)
		local var_41_0 = {}

		var_41_0.x, var_41_0.y = arg_41_0:xy()

		return cc.pAdd(var_41_0, arg_41_1)
	end
}

function BattleSprite.addBuffEffect(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9, arg_42_10)
	if not arg_42_1 or arg_42_1 == "" then
		return
	end

	local var_42_0 = 2
	local var_42_1, var_42_2 = arg_42_0:getViewTb(arg_42_2)
	local var_42_3 = arg_42_0:getBuffEffectKey(arg_42_1, arg_42_5, arg_42_8)
	local var_42_4 = var_42_1[var_42_3]

	if var_42_4 and (arg_42_9 == battle.BuffOverlayType.Coexist or arg_42_9 == battle.BuffOverlayType.Overlay or arg_42_9 == battle.BuffOverlayType.OverlayDrop) then
		return var_42_4:play(arg_42_5)
	end

	var_42_2[var_42_3] = var_42_2[var_42_3] or 0
	var_42_2[var_42_3] = var_42_2[var_42_3] + 1

	if var_42_2[var_42_3] <= 0 then
		return
	end

	if not var_42_4 then
		var_42_4 = newCSpriteWithOption(arg_42_1)

		var_42_4:scale(var_42_0)

		var_42_1[var_42_3] = var_42_4

		if arg_42_2 >= 3 and arg_42_2 <= 6 then
			table.insert(arg_42_0.battleView.buffEffectsToHide, var_42_4)
		else
			table.insert(arg_42_0.buffEffectsFollowObjToScale, var_42_4)
			arg_42_0:updateBuffeffectsScale()
		end
	end

	var_42_4.buffUseSameResCount = var_42_4.buffUseSameResCount or 0
	var_42_4.buffUseSameResCount = var_42_4.buffUseSameResCount + 1
	var_42_4.showEffect = arg_42_6

	if var_42_4:play(arg_42_5) == false then
		var_42_4:play("effect")
	end

	local var_42_5 = 0
	local var_42_6 = 0

	if var_42_4.buffUseSameResCount <= 1 then
		local var_42_7 = arg_42_0.battleView:getAssignLayer(arg_42_10)

		if var_42_7 then
			local var_42_8 = arg_42_3

			if arg_42_10 == battle.AssignLayer.gameLayer then
				local var_42_9 = 10000
				local var_42_10 = math.floor(arg_42_3 / var_42_9)
				local var_42_11 = 1

				if var_42_10 == 0 then
					var_42_8 = arg_42_3 / var_42_9 * (display.height - battle.StandingPos[1].y)
				elseif var_42_10 == 3 then
					var_42_8 = arg_42_3 - var_42_9 * var_42_10 + (display.height - battle.StandingPos[3].y)
				else
					var_42_8 = (arg_42_3 / var_42_9 - var_42_10) * (battle.StandingPos[var_42_10].y - battle.StandingPos[var_42_10 + 1].y) + (display.height - battle.StandingPos[var_42_10].y)
				end
			end

			var_42_7:add(var_42_4)
			var_42_4:setLocalZOrder(var_42_8)

			if arg_42_2 < 3 then
				var_42_5, var_42_6 = arg_42_0:getCurPos()
			end
		else
			arg_42_0:add(var_42_4, arg_42_3)
		end
	end

	local var_42_12 = cc.p(arg_42_4.x - var_42_5, arg_42_4.y - var_42_6)

	if arg_42_0.model.force == 2 then
		var_42_12 = cc.p(-var_42_12.x, var_42_12.y)
	end

	local var_42_13 = var_0_8[arg_42_2](arg_42_0, var_42_12)
	local var_42_14 = battleEasy.ifElse(arg_42_0.lockEffectSwitch, true, arg_42_6)

	if arg_42_4.flip then
		var_42_4:setScaleX(var_42_0)
	else
		var_42_4:setScaleX(arg_42_0.faceTo * var_42_0)
	end

	var_42_4:setVisible(var_42_14)
	var_42_4:setPosition(var_42_13)
end

function BattleSprite.deleteBuffEffect(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	local var_43_0, var_43_1 = arg_43_0:getViewTb(arg_43_3)
	local var_43_2 = arg_43_0:getBuffEffectKey(arg_43_1, arg_43_2, arg_43_4)

	var_43_1[var_43_2] = var_43_1[var_43_2] or 0
	var_43_1[var_43_2] = var_43_1[var_43_2] - 1

	local var_43_3 = var_43_0[var_43_2]

	if var_43_3 then
		var_43_3.buffUseSameResCount = var_43_3.buffUseSameResCount - 1

		if var_43_3.buffUseSameResCount == 0 then
			var_43_0[var_43_2] = nil

			if arg_43_3 >= 3 and arg_43_3 <= 6 then
				for iter_43_0, iter_43_1 in ipairs(arg_43_0.battleView.buffEffectsToHide) do
					if iter_43_1.spriteID == var_43_3.spriteID then
						table.remove(arg_43_0.battleView.buffEffectsToHide, iter_43_0)

						break
					end
				end
			else
				for iter_43_2, iter_43_3 in ipairs(arg_43_0.buffEffectsFollowObjToScale) do
					if iter_43_3.spriteID == var_43_3.spriteID then
						table.remove(arg_43_0.buffEffectsFollowObjToScale, iter_43_2)

						break
					end
				end

				if not next(arg_43_0.buffEffectsFollowObjToScale) then
					arg_43_0:unscheduleUpdate()
				end
			end

			removeCSprite(var_43_3)
		end
	end
end

local var_0_9
local var_0_10 = {
	pause = {
		onBuff = function(arg_44_0, arg_44_1)
			if not arg_44_1 then
				arg_44_0:pauseSprite()
			else
				arg_44_0:resumeSprite()
			end
		end
	},
	hideOthers = {
		onBuff = function(arg_45_0, arg_45_1, arg_45_2)
			arg_45_0:alterLockEffectRecord(arg_45_1)
		end
	},
	hide = {
		onBuff = function(arg_46_0, arg_46_1, arg_46_2)
			arg_46_0:onSetSpriteVisible(arg_46_1)

			if arg_46_1 then
				arg_46_0.lifebar:setVisibleEnable(arg_46_1)
				arg_46_0.lifebar:setVisible(arg_46_1)
			else
				arg_46_0.lifebar:setVisible(arg_46_1)
				arg_46_0.lifebar:setVisibleEnable(arg_46_1)
			end
		end
	},
	hideAdvanced = {
		onBuff = function(arg_47_0, arg_47_1, arg_47_2)
			local var_47_0 = arg_47_1

			if arg_47_2 ~= nil then
				var_47_0 = battleEasy.ifElse(not arg_47_1, arg_47_2, not arg_47_2)
			end

			arg_47_0:onSetSpriteVisible(var_47_0)

			if var_47_0 then
				arg_47_0.lifebar:setVisibleEnable(var_47_0)
				arg_47_0.lifebar:setVisible(var_47_0)
			else
				arg_47_0.lifebar:setVisible(var_47_0)
				arg_47_0.lifebar:setVisibleEnable(var_47_0)
			end

			arg_47_0:alterLockEffectRecord(var_47_0)
		end
	},
	hideSprite = {
		onBuff = function(arg_48_0, arg_48_1, arg_48_2)
			arg_48_0:onSetSpriteVisible(arg_48_1)
		end
	},
	move = {
		onBuff = function(arg_49_0, arg_49_1, arg_49_2)
			local var_49_0, var_49_1 = arg_49_0:getCurPos()
			local var_49_2 = battleEasy.ifElse(arg_49_1, -1, 1)
			local var_49_3 = battleEasy.ifElse(arg_49_0.force == 1, -1, 1)
			local var_49_4 = {
				x = battleEasy.ifElse(arg_49_2.x, arg_49_2.x * var_49_2 * var_49_3 + var_49_0, var_49_0),
				y = battleEasy.ifElse(arg_49_2.y, arg_49_2.y * var_49_2 + var_49_1, var_49_1)
			}

			if arg_49_1 then
				arg_49_0:onAddEventEffect("moveTo", {
					a = 1000,
					knockUpBack = true,
					speed = arg_49_2.speed,
					x = var_49_4.x,
					y = var_49_4.y
				})
			else
				arg_49_0:onAddEventEffect("moveTo", {
					a = 1000,
					knockUp = true,
					speed = arg_49_2.speed,
					x = var_49_4.x,
					y = var_49_4.y
				})
			end
		end
	},
	opacity = {
		onBuff = function(arg_50_0, arg_50_1, arg_50_2)
			local var_50_0 = math.min(math.floor((arg_50_2 or 1) * 255), 255)

			if arg_50_1 then
				arg_50_0:setSpriteOpacity(255)
			else
				arg_50_0:setSpriteOpacity(var_50_0)
			end
		end
	},
	onceEffect = {
		onBuff = function(arg_51_0, arg_51_1, arg_51_2)
			local var_51_0 = arg_51_2.timePos or 0
			local var_51_1 = arg_51_1 and var_51_0 == 1

			var_51_1 = var_51_1 or not arg_51_1 and var_51_0 == 0

			if var_51_1 then
				arg_51_0.battleView:onViewProxyCall("onFrameOnceEffect", {
					tostrModel = arg_51_0.key,
					resPath = arg_51_2.onceEffectResPath,
					aniName = arg_51_2.onceEffectAniName or "effect",
					pos = arg_51_2.onceEffectPos or 0,
					offsetPos = arg_51_2.onceEffectOffsetPos or {
						x = 0,
						y = 0
					},
					assignLayer = arg_51_2.onceEffectAssignLayer or 4,
					wait = arg_51_2.onceEffectWait or false,
					delay = arg_51_2.onceEffectDelay or 0
				})
			end
		end
	},
	wait = {
		onBuff = function(arg_52_0, arg_52_1, arg_52_2)
			local var_52_0 = arg_52_2.timePos or 0
			local var_52_1 = arg_52_1 and var_52_0 == 1

			var_52_1 = var_52_1 or not arg_52_1 and var_52_0 == 0

			if var_52_1 then
				arg_52_0.battleView:onEventEffectQueueFront("wait", {
					lifetime = arg_52_2.lifetime
				})
			end
		end
	},
	changeImage = {
		onBuff = function(arg_53_0, arg_53_1, arg_53_2)
			if arg_53_1 then
				arg_53_0:onSetSpriteVisible(true)
				removeCSprite(arg_53_0.changeImageSprite)

				arg_53_0.changeImageSprite = nil
			else
				arg_53_0:onSetSpriteVisible(false)

				local var_53_0 = cc.p(arg_53_0.sprite:getPositionX(), arg_53_0.sprite:getPositionY())

				if arg_53_0.changeImageSprite then
					arg_53_0.changeImageSprite:removeAnimation()
				end

				local var_53_1 = csv.unit[arg_53_2]
				local var_53_2 = var_53_1.unitRes

				arg_53_0.changeImageSprite = newCSprite(var_53_2)

				arg_53_0:add(arg_53_0.changeImageSprite, battle.SpriteLayerZOrder.selfSpr)
				arg_53_0.changeImageSprite:setPosition(var_53_0)
				arg_53_0.changeImageSprite:play(battle.SpriteActionTable.standby)
				arg_53_0.changeImageSprite:setScaleX(arg_53_0.faceTo * var_53_1.scaleX * var_53_1.scale * var_53_1.scaleC)
				arg_53_0.changeImageSprite:setScaleY(var_53_1.scale * var_53_1.scaleC)
			end
		end
	},
	shader = {
		onBuff = function(arg_54_0, arg_54_1, arg_54_2)
			if arg_54_1 then
				arg_54_0.sprite:setGLProgram("normal")
			elseif arg_54_2.switch == 4 then
				local var_54_0 = (arg_54_2.extraArgs[1] or {})[arg_54_0.cardID] or 0.8

				arg_54_0.sprite:setShihuaShader(var_54_0)
			else
				arg_54_0.sprite:setHSLShader(arg_54_2.extraArgs[1], arg_54_2.extraArgs[2], arg_54_2.extraArgs[3], arg_54_2.extraArgs[4], arg_54_2.extraArgs[5], arg_54_2.switch)
			end
		end
	},
	playAni = {
		onBuff = function(arg_55_0, arg_55_1, arg_55_2)
			local var_55_0, var_55_1 = arg_55_0:getViewTb(arg_55_2.pos)
			local var_55_2 = var_55_0[arg_55_0:getBuffEffectKey(arg_55_2.effectRes, arg_55_2.aniName, arg_55_2.effectAniType)]

			if not var_55_2 then
				return
			end

			local function var_55_3()
				var_55_2.holderActionVisible = nil

				var_55_2:setVisible(true)
			end

			if arg_55_1 then
				if arg_55_2.hide then
					var_55_3()
				end

				var_55_2:play(arg_55_2.aniName)
			else
				arg_55_0.battleView:onEventEffect(nil, "callback", {
					func = function()
						if arg_55_2.hide then
							var_55_2.holderActionVisible = false

							var_55_2:setVisible(false)
						else
							var_55_3()
						end

						var_55_2:play(arg_55_2.newAniName)
					end,
					delay = arg_55_2.delay or 0
				})
			end
		end
	}
}
local var_0_11 = {
	iconEffect = function(arg_58_0, arg_58_1)
		local var_58_0 = arg_58_1.csvCfg

		if var_58_0.iconResPath and var_58_0.iconResPath ~= "" then
			arg_58_0:onShowBuffIcon(var_58_0.iconResPath, arg_58_1.cfgId, arg_58_1.overlayCount)
		end
	end,
	onceEffect = function(arg_59_0, arg_59_1)
		local var_59_0 = arg_59_1.csvCfg

		if not arg_59_1.isOnceEffectPlayed and var_59_0.onceEffectResPath and var_59_0.onceEffectResPath ~= "" then
			arg_59_0.battleView:onViewProxyCall("onFrameOnceEffect", {
				tostrModel = arg_59_1.tostrModel,
				resPath = var_59_0.onceEffectResPath,
				aniName = var_59_0.onceEffectAniName,
				pos = var_59_0.onceEffectPos,
				offsetPos = var_59_0.onceEffectOffsetPos,
				assignLayer = var_59_0.onceEffectAssignLayer,
				wait = var_59_0.onceEffectWait,
				delay = var_59_0.onceEffectDelay or 0
			})
		end
	end,
	textEffect = function(arg_60_0, arg_60_1)
		local var_60_0 = arg_60_1.csvCfg

		if not arg_60_1.args.cantShowText and var_60_0.textResPath and var_60_0.textResPath ~= "" then
			arg_60_0.battleView:onEventEffect(nil, "callback", {
				func = function()
					arg_60_0:onShowBuffText(var_60_0.textResPath)
				end,
				delay = var_60_0.onceEffectDelay or 0
			})
		end
	end,
	mainEffect = function(arg_62_0, arg_62_1)
		local var_62_0 = arg_62_1.csvCfg

		if var_62_0.effectResPath and var_62_0.effectResPath ~= "" then
			local var_62_1 = battleEasy.ifElse(var_62_0.holderActionType.typ and var_62_0.holderActionType.typ == "hideOthers", true, false)
			local var_62_2 = var_62_0.effectAniName[arg_62_1.aniSelectId]
			local var_62_3 = var_62_1 or var_62_0.effectShowOnAttack or false

			arg_62_0.battleView:onEventEffect(nil, "callback", {
				func = function()
					arg_62_0:addBuffEffect(var_62_0.effectResPath, var_62_0.effectPos, var_62_0.deepCorrect, var_62_0.effectOffsetPos, var_62_2, var_62_3, arg_62_1.isSelfTurn, var_62_0.effectAniChoose.type, var_62_0.overlayType, var_62_0.effectAssignLayer)
				end,
				delay = var_62_0.effectResDelay or 0
			})
		end
	end,
	dispelEffect = function(arg_64_0, arg_64_1)
		local var_64_0 = arg_64_1.csvCfg

		if arg_64_1.dispel then
			arg_64_0.battleView:onViewProxyCall("onFrameOnceEffect", {
				pos = 2,
				resPath = "buff/qusan/qusan.skel",
				aniName = "effect",
				tostrModel = arg_64_1.tostrModel,
				offsetPos = var_64_0.onceEffectOffsetPos,
				assignLayer = var_64_0.onceEffectAssignLayer,
				wait = var_64_0.onceEffectWait,
				delay = var_64_0.onceEffectDelay or 0
			})
		end
	end,
	skinEffect = function(arg_65_0, arg_65_1)
		local var_65_0 = arg_65_1.csvCfg

		if var_65_0.skin then
			local var_65_1 = {
				isRestore = false,
				buffId = arg_65_1.id,
				skinName = var_65_0.skin
			}

			arg_65_0:setSkin(var_65_1)
		end
	end,
	holderActionEffect = function(arg_66_0, arg_66_1)
		local var_66_0 = arg_66_1.csvCfg

		if var_66_0.holderActionType then
			if var_66_0.holderActionType.typ then
				arg_66_0:addBuffHolderAction(arg_66_1.id, var_66_0.holderActionType.typ, var_66_0.holderActionType.args, var_66_0.holderActionType.playTime)
			elseif var_66_0.holderActionType.list then
				local var_66_1 = arg_66_0.battleView:pushDeferList(arg_66_1.id, "holderActionType")

				for iter_66_0, iter_66_1 in ipairs(var_66_0.holderActionType.list) do
					arg_66_0:addBuffHolderAction(arg_66_1.id .. "_" .. iter_66_0, iter_66_1.typ, iter_66_1.args, iter_66_1.playType)
				end

				arg_66_0.battleView:runDeferToQueueFront(arg_66_0.battleView:popDeferList(var_66_1))
			end
		end
	end,
	LinkEffect = function(arg_67_0, arg_67_1)
		local var_67_0 = arg_67_1.csvCfg

		if var_67_0.linkEffect then
			gRootViewProxy:notify("addLinkEffect", arg_67_1.tostrModel, arg_67_1.tostrCaster, var_67_0.linkEffect, arg_67_1.id)
		end
	end
}

function BattleSprite.onPlayBuffAniEffect(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_1.csvCfg then
		return
	end

	if not arg_68_2 then
		for iter_68_0, iter_68_1 in pairs(var_0_11) do
			iter_68_1(arg_68_0, arg_68_1)
		end
	else
		for iter_68_2, iter_68_3 in pairs(arg_68_2) do
			var_0_11[iter_68_3](arg_68_0, arg_68_1)
		end
	end
end

function BattleSprite.addBuffHolderAction(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	if not arg_69_2 then
		return
	end

	if not arg_69_0.buffEffectHolderMap[arg_69_2] then
		arg_69_0.buffEffectHolderMap[arg_69_2] = {
			datas = CList.new()
		}
	end

	if arg_69_4 == 1 then
		battleEasy.deferCallback(function()
			arg_69_0:onPlayBuffHolderAction(arg_69_2, {
				id = arg_69_1,
				args = arg_69_3
			}, false)
		end)

		return
	end

	local var_69_0 = arg_69_0.buffEffectHolderMap[arg_69_2]
	local var_69_1

	for iter_69_0, iter_69_1 in var_69_0.datas:pairs() do
		if iter_69_1.id == arg_69_1 then
			var_69_1 = iter_69_1

			break
		end
	end

	if not var_69_1 then
		var_69_1 = {
			ref = 0,
			id = arg_69_1,
			args = arg_69_3,
			idx = var_69_0.datas.counter + 1
		}

		var_69_0.datas:push_back(var_69_1)
	end

	var_69_1.args = arg_69_3
	var_69_1.ref = var_69_1.ref + 1

	if var_69_1.ref > 1 then
		arg_69_0:onPlayBuffHolderAction(arg_69_2, var_69_1, false)
	elseif var_69_1.ref == 0 then
		var_69_0.datas:erase(var_69_1.idx)
	end
end

function BattleSprite.delBuffHolderAction(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	if not arg_71_2 then
		return
	end

	if not arg_71_0.buffEffectHolderMap[arg_71_2] then
		arg_71_0.buffEffectHolderMap[arg_71_2] = {
			datas = CList.new()
		}
	end

	if arg_71_3 == 1 then
		return
	end

	local var_71_0 = arg_71_0.buffEffectHolderMap[arg_71_2]
	local var_71_1
	local var_71_2
	local var_71_3

	for iter_71_0, iter_71_1 in var_71_0.datas:pairs() do
		if iter_71_1.id == arg_71_1 then
			var_71_1 = iter_71_1
			var_71_2 = var_71_0.isPlayId == arg_71_1
		elseif iter_71_1.ref > 0 then
			var_71_3 = iter_71_1.idx
		end
	end

	if not var_71_1 then
		var_71_1 = {
			ref = 0,
			id = arg_71_1,
			idx = var_71_0.datas.counter + 1
		}

		var_71_0.datas:push_back(var_71_1)
	end

	var_71_1.ref = var_71_1.ref - 1

	if var_71_1.ref ~= 0 then
		return
	end

	local var_71_4 = var_71_0.datas:erase(var_71_1.idx)

	if var_71_2 and not arg_71_3 then
		if not var_71_3 then
			arg_71_0:onPlayBuffHolderAction(arg_71_2, var_71_4, true)

			var_71_0.isPlayId = nil
		else
			arg_71_0:onPlayBuffHolderAction(arg_71_2, var_71_0.datas:index(var_71_3), false)
		end
	end
end

function BattleSprite.onPlayBuffHolderAction(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
	if not arg_72_1 then
		local var_72_0

		for iter_72_0, iter_72_1 in pairs(arg_72_0.buffEffectHolderMap) do
			local var_72_1 = iter_72_1.datas:back()

			if var_0_10[iter_72_0] and iter_72_1.datas:size() > 0 and (iter_72_1.isPlayId == nil or iter_72_1.isPlayId ~= var_72_1.id) and var_72_1.ref > 0 then
				iter_72_1.isPlayId = var_0_10[iter_72_0].onBuff(arg_72_0, false, var_72_1.args) or var_72_1.id
			end
		end

		return
	end

	if var_0_10[arg_72_1] then
		arg_72_0.buffEffectHolderMap[arg_72_1].isPlayId = var_0_10[arg_72_1].onBuff(arg_72_0, arg_72_3, arg_72_2.args) or arg_72_2.id
	end
end

function BattleSprite.onDeleteBuffEffect(arg_73_0, arg_73_1)
	local var_73_0 = arg_73_0.battleView
	local var_73_1 = arg_73_1.cfg

	if var_73_1.holderActionType then
		if var_73_1.holderActionType.typ then
			arg_73_0:delBuffHolderAction(arg_73_1.id, var_73_1.holderActionType.typ)
		elseif var_73_1.holderActionType.list then
			for iter_73_0, iter_73_1 in csvPairs(var_73_1.holderActionType.list) do
				arg_73_0:delBuffHolderAction(arg_73_1.id .. "_" .. iter_73_0, iter_73_1.typ, iter_73_1.playType)
			end
		end
	end

	arg_73_0:deleteBuffEffect(var_73_1.effectResPath, var_73_1.effectAniName[arg_73_1.aniSelectId], var_73_1.effectPos, var_73_1.effectAniChoose.type)

	if var_73_1.effectOnEnd and var_73_1.effectOnEnd.res then
		var_73_0:onViewProxyCall("onFrameOnceEffect", {
			tostrModel = arg_73_1.tostrModel,
			resPath = var_73_1.effectOnEnd.res,
			aniName = var_73_1.effectOnEnd.aniName,
			pos = var_73_1.effectOnEnd.pos or 2,
			offsetPos = var_73_1.onceEffectOffsetPos,
			assignLayer = var_73_1.onceEffectAssignLayer,
			wait = var_73_1.onceEffectWait,
			delay = var_73_1.onceEffectDelay or 0
		})
	end

	if var_73_1.skin then
		local var_73_2 = {
			isRestore = true,
			buffId = arg_73_1.id,
			skinName = var_73_1.skin
		}

		arg_73_0:setSkin(var_73_2)
	end

	arg_73_0:onDelBuffIcon(arg_73_1.cfgId)
	arg_73_0:onDelBuffShader(arg_73_1)
	gRootViewProxy:notify("delLinkEffect", arg_73_1.id)
end

function BattleSprite.onPlayBuffShader(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_1.buffshader
	local var_74_1, var_74_2 = csvNext(var_74_0)
	local var_74_3 = {
		buffId = arg_74_1.buffId,
		switch = var_74_1,
		extraArgs = var_74_2
	}

	arg_74_0:addBuffHolderAction(arg_74_1.buffId, "shader", var_74_3)
end

function BattleSprite.onDelBuffShader(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_1.cfg

	if var_75_0.buffshader and csvSize(var_75_0.buffshader) ~= 0 then
		arg_75_0:delBuffHolderAction(arg_75_1.cfgId, "shader")
	end
end

function BattleSprite.getBuffEffectKey(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	local var_76_0 = arg_76_2 or "effect_loop"
	local var_76_1 = arg_76_1

	if arg_76_3 == 0 then
		var_76_1 = var_76_1 .. "|" .. var_76_0
	end

	return var_76_1
end

function BattleSprite.getViewTb(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0.buffEffectsMap
	local var_77_1 = arg_77_0.buffEffectsRef
	local var_77_2 = arg_77_0.model.force

	if arg_77_1 == 4 then
		var_77_2 = 3 - var_77_2
	end

	if arg_77_1 == 3 or arg_77_1 == 4 then
		if var_77_2 == 1 then
			var_77_0 = arg_77_0.battleView.buffEffectsSelfMap
			var_77_1 = arg_77_0.battleView.buffEffectsSelfRef
		elseif var_77_2 == 2 then
			var_77_0 = arg_77_0.battleView.buffEffectsEnemyMap
			var_77_1 = arg_77_0.battleView.buffEffectsEnemyRef
		end
	elseif arg_77_1 == 5 then
		var_77_0 = arg_77_0.battleView.buffEffectsMap
		var_77_1 = arg_77_0.battleView.buffEffectsRef
	end

	return var_77_0, var_77_1
end

function BattleSprite.onAddBuffHolderAction(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	arg_78_0:addBuffHolderAction(arg_78_1, arg_78_2, arg_78_3, arg_78_4)
end

function BattleSprite.onDelBuffHolderAction(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
	arg_79_0:delBuffHolderAction(arg_79_1, arg_79_2, arg_79_3)
end

function BattleSprite.updateBuffeffectsScale(arg_80_0)
	arg_80_0:scheduleUpdate(function()
		local var_81_0 = 2 * math.abs(arg_80_0:getScaleX())
		local var_81_1 = 2 * arg_80_0:getScaleY()

		for iter_81_0, iter_81_1 in ipairs(arg_80_0.buffEffectsFollowObjToScale) do
			local var_81_2 = iter_81_1:getScaleX()
			local var_81_3 = battleEasy.ifElse(1 / var_81_2 > 0, 1, -1)
			local var_81_4 = iter_81_1:getScaleY()

			if var_81_0 ~= var_81_3 * var_81_2 then
				iter_81_1:setScaleX(var_81_3 * var_81_0)
			end

			if var_81_1 ~= var_81_4 then
				iter_81_1:setScaleY(var_81_1)
			end
		end
	end)
end
