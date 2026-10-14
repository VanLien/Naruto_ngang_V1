function BattleSprite.moveToPosIdx(arg_1_0, arg_1_1)
	local var_1_0
	local var_1_1

	if arg_1_1 < 0 then
		var_1_0, var_1_1 = battle.StandingPos[99].x, battle.StandingPos[99].y
	elseif arg_1_1 <= 6 or arg_1_1 > 12 then
		var_1_0, var_1_1 = battle.StandingPos[arg_1_1].x, battle.StandingPos[arg_1_1].y
	else
		var_1_0, var_1_1 = display.width - battle.StandingPos[arg_1_1 - 6].x, battle.StandingPos[arg_1_1 - 6].y
	end

	local var_1_2, var_1_3 = var_1_0 + arg_1_0.posAdjust.x, var_1_1 + arg_1_0.posAdjust.y

	if var_1_2 and var_1_3 then
		arg_1_0:setPosition(cc.p(var_1_2, var_1_3))
		arg_1_0:setCurPos(cc.p(var_1_2, var_1_3))
	end
end

function BattleSprite.onDoShiftPos(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0
	local var_2_1

	if arg_2_1 <= 6 or arg_2_1 > 12 then
		var_2_0, var_2_1 = battle.StandingPos[arg_2_1].x, battle.StandingPos[arg_2_1].y
	else
		var_2_0, var_2_1 = display.width - battle.StandingPos[arg_2_1 - 6].x, battle.StandingPos[arg_2_1 - 6].y
	end

	local var_2_2, var_2_3 = var_2_0 + arg_2_0.posAdjust.x, var_2_1 + arg_2_0.posAdjust.y

	arg_2_0:onAddEventEffect("moveTo", {
		speed = 1500,
		a = 1000,
		changeFaceTo = false,
		x = var_2_2,
		y = var_2_3
	}, true)

	arg_2_0.seat = arg_2_0.model.seat

	arg_2_0:setCurPos(cc.p(var_2_2, var_2_3))
	arg_2_0:updHitPanel()
	arg_2_0:onAddToScene()

	for iter_2_0 = 1, 1 do
		if not arg_2_2 then
			break
		end

		local var_2_4 = arg_2_2.onceEffectResPath

		if not var_2_4 or var_2_4 == "" then
			break
		end

		local var_2_5 = newCSprite(var_2_4)
		local var_2_6 = arg_2_2.onceEffectOffsetPos
		local var_2_7 = arg_2_2.onceEffectAniName or "effect"

		arg_2_0:add(var_2_5, 12)
		var_2_5:play(var_2_7)
		var_2_5:setSpriteEventHandler(function(arg_3_0, arg_3_1)
			if arg_3_0 == sp.EventType.ANIMATION_COMPLETE then
				removeCSprite(var_2_5)
			end
		end)

		local var_2_8 = cc.p(0, 0)

		if var_2_6 then
			var_2_8 = cc.pAdd(cc.p(0, 0), var_2_6)
		end

		var_2_5:setPosition(var_2_8):scale(2)
	end
end

function BattleSprite.getMoveToTargetPosition(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0, var_4_1 = arg_4_0:getAttackPos(arg_4_1, arg_4_2.posC, arg_4_2.attackFriend)

	if arg_4_1 ~= arg_4_0:getSeat() and (arg_4_2.cameraNear == 1 or arg_4_2.cameraNear == 2) then
		arg_4_0.skillNeedCameraFix = true

		local var_4_2 = arg_4_2.cameraNear_posC and arg_4_2.cameraNear_posC.x or 0
		local var_4_3 = arg_4_2.cameraNear_posC and arg_4_2.cameraNear_posC.y or 0

		var_4_0, var_4_1 = arg_4_0:getAttackPos(arg_4_1, cc.p(var_4_2, var_4_3), arg_4_2.attackFriend)
	end

	return var_4_0, var_4_1
end

function BattleSprite.getMoveToTargetFrontPosition(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0, var_5_1 = arg_5_0:getProtectPos(arg_5_1, cc.p(0, 0))

	if arg_5_1 ~= arg_5_0:getSeat() and (arg_5_2.cameraNear == 1 or arg_5_2.cameraNear == 2) then
		arg_5_0.skillNeedCameraFix = true

		local var_5_2 = arg_5_2.cameraNear_posC and arg_5_2.cameraNear_posC.x or 0
		local var_5_3 = arg_5_2.cameraNear_posC and arg_5_2.cameraNear_posC.y or 0

		var_5_0, var_5_1 = arg_5_0:getProtectPos(arg_5_1, cc.p(var_5_2, var_5_3))
	end

	return var_5_0, var_5_1
end

function BattleSprite.getMoveTime(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0, var_6_1 = arg_6_0:getMoveToTargetPosition(arg_6_1, arg_6_2)
	local var_6_2 = arg_6_3 or 1000
	local var_6_3 = arg_6_4
	local var_6_4, var_6_5 = arg_6_0:getCurPos()
	local var_6_6 = cc.pGetLength(cc.p(var_6_0 - var_6_4, var_6_1 - var_6_5))
	local var_6_7 = 0

	if var_6_3 then
		local var_6_8 = var_6_2 * var_6_2 + 2 * var_6_3 * var_6_6
		local var_6_9 = math.max(var_6_8, 0)

		var_6_7 = (math.sqrt(var_6_9) - var_6_2) / var_6_3
	else
		var_6_7 = var_6_6 / var_6_2
	end

	return var_6_7
end

function BattleSprite.onAddToScene(arg_7_0)
	arg_7_0:setVisible(false)
	arg_7_0:resetPosZ()
	arg_7_0:setLocalZOrder(arg_7_0.posZ)
	arg_7_0:setName("object" .. arg_7_0.seat)
end

function BattleSprite.resetPosZ(arg_8_0, arg_8_1)
	local var_8_0, var_8_1 = arg_8_0:getSelfPos()
	local var_8_2 = display.height - (arg_8_1 or var_8_1)
	local var_8_3 = var_8_2 - 1

	arg_8_0.posZ = 2 - math.floor((arg_8_0:getSeat() + 2) / 3) % 2 == 1 and var_8_2 or var_8_3
	arg_8_0.battleMovePosZ = var_8_2
end

function BattleSprite.onMoveToTarget(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = true

	if arg_9_1 == battle.AttackPosIndex.selfPos and not arg_9_2.attackFriend then
		var_9_0 = false
	end

	local var_9_1 = arg_9_0.battleView:onViewProxyCall("getSceneObj", arg_9_4)
	local var_9_2 = arg_9_0:getRealUseView()
	local var_9_3, var_9_4 = var_9_2:getMoveToTargetPosition(arg_9_1, arg_9_2)

	if arg_9_1 ~= battle.AttackPosIndex.selfPos and arg_9_1 ~= battle.AttackPosIndex.center and var_9_1 then
		local var_9_5 = var_9_1.posAdjust

		var_9_3 = var_9_3 + var_9_5.x
		var_9_4 = var_9_4 + var_9_5.y
	end

	local var_9_6 = arg_9_2.attackFriend and -1 * arg_9_0.faceTo

	var_9_2:onAddEventEffect("callback", {
		func = function()
			if arg_9_0.skillNeedCameraFix then
				arg_9_0.battleView:onViewProxyNotify("skillStartStageMove", arg_9_2.cameraNear)
			end
		end
	}, arg_9_3)

	if var_9_0 then
		var_9_2:onAddEventEffect("moveTo", {
			a = 1000,
			speed = 1500,
			timeScale = arg_9_2.timeScale,
			delayMove = arg_9_2.delayBeforeMove,
			costTime = arg_9_2.moveCostTime,
			x = var_9_3,
			y = var_9_4,
			changeFaceTo = var_9_6
		}, arg_9_3)
	end

	if arg_9_5 then
		local var_9_7 = math.max(var_9_1:getLocalZOrder(), arg_9_0:getLocalZOrder()) + 1

		arg_9_5.view:proxy():onMoveToTargetFront(arg_9_5.targetID, arg_9_2, var_9_1.posAdjust, arg_9_3)
		arg_9_5.view:proxy():setLocalZOrder(var_9_7)
	end
end

function BattleSprite.onMoveToTargetFront(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0, var_11_1 = arg_11_0:getMoveToTargetFrontPosition(arg_11_1, arg_11_2)
	local var_11_2 = var_11_0 + arg_11_3.x
	local var_11_3 = var_11_1 + arg_11_3.y
	local var_11_4

	if arg_11_1 <= 6 and arg_11_0:getSeat() > 6 or arg_11_0:getSeat() <= 6 and arg_11_1 > 6 then
		var_11_4 = -1 * arg_11_0.faceTo
	end

	arg_11_0:onAddEventEffect("moveTo", {
		speed = 1500,
		a = 1000,
		x = var_11_2,
		y = var_11_3,
		changeFaceTo = var_11_4
	}, arg_11_4)
end

function BattleSprite.onSortReloadUnit(arg_12_0, arg_12_1)
	if arg_12_0.unitID == arg_12_0.model.unitID then
		return
	end

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.specBindEffectCache) do
		removeCSprite(iter_12_1.effect)
	end

	arg_12_0:stopAllHolderAction()

	arg_12_0.specBindEffectCache = {}

	arg_12_0:resetActionTab()
	arg_12_0:reloadUnit(arg_12_1)

	local var_12_0 = arg_12_0.model.unitCfg

	arg_12_0.lifebar:setPosition(var_12_0.everyPos.lifePos)
	arg_12_0.lifebar:setScale(var_12_0.lifeScale)

	arg_12_0.refreshBuffIconOnce = true

	arg_12_0:onPlayUnitSpecBind()
end

function BattleSprite.onSkillBefore(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0:onAddEventEffect("callback", {
		func = function()
			if arg_13_1 then
				arg_13_0.battleView:runDefer(arg_13_1.skillStartAddBuffsPlayFuncs)
			end
		end
	}, arg_13_3)
	arg_13_0:onAddEventEffect("callback", {
		func = function()
			if arg_13_1 then
				arg_13_0.battleView:runDefer(arg_13_1.skillStartTriggerBuffsPlayFuncs)
			end
		end
	}, arg_13_3)
	arg_13_0:pushApplySkillSceneTag(arg_13_4)

	if arg_13_4 and arg_13_4.isBigSkill and arg_13_0 ~= arg_13_0:getRealUseView() then
		arg_13_0:setVisible(false)
	end
end

function BattleSprite.onPlayAction(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if not arg_16_1 then
		return
	end

	if arg_16_0.isPausing then
		return
	end

	local var_16_0 = arg_16_0:getRealUseView()

	if battle.LoopActionMap[arg_16_1] then
		table.insert(arg_16_0.battleView.effectJumpCache, var_16_0:onAddEventEffect("effect", {
			action = arg_16_1,
			lifetime = arg_16_2
		}, arg_16_3))

		return
	end

	table.insert(arg_16_0.battleView.effectJumpCache, var_16_0:onAddEventEffect("effect", {
		action = arg_16_1,
		lifetime = arg_16_2,
		onComplete = function()
			return
		end
	}, arg_16_3))
end

function BattleSprite.onUltJumpShowNum(arg_18_0, arg_18_1)
	arg_18_0:onAddEventEffect("callback", {
		func = function()
			arg_18_0.battleView:onViewProxyNotify("showNumber", arg_18_1)
		end
	}, false)
end

local function var_0_0(arg_20_0, arg_20_1)
	return arg_20_0.id < arg_20_1.id
end

function BattleSprite.onUltJumpEnd(arg_21_0)
	arg_21_0:onResetSkillEnd()
	arg_21_0:onAddEventEffect("callback", {
		func = function()
			arg_21_0:setActionState(battle.SpriteActionTable.standby)
			performWithDelay(arg_21_0.battleView, function()
				arg_21_0.battleView:resetEffectEventEnable()
			end, 0)
		end
	}, false)
end

function BattleSprite.onResetSkillEnd(arg_24_0, arg_24_1)
	arg_24_0:onAddEventEffect("callback", {
		func = function()
			if arg_24_0.skillNeedCameraFix then
				arg_24_0.skillNeedCameraFix = false

				arg_24_0.battleView:onViewProxyNotify("skillEndStageMoveBack")
			end

			if arg_24_0.battleView.bgmChanged then
				audio.resumeMusic()

				arg_24_0.battleView.bgmChanged = false
			end
		end
	}, false)

	if arg_24_1 == battle.SkillType.NormalSkill or arg_24_1 == battle.SkillType.PassiveCombine then
		arg_24_0:onAddEventEffect("callback", {
			func = function()
				local var_26_0 = arg_24_0.battleView:onViewProxyCall("getSceneAllObjs")

				for iter_26_0, iter_26_1 in maptools.order_pairs(var_26_0, var_0_0) do
					if not iter_26_1:isComeBacking() and iter_26_1.id ~= arg_24_0.id then
						iter_26_1:resetPos()
					end
				end
			end
		}, false)
	end
end

function BattleSprite.onObjSkillEnd(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0:onAddEventEffect("callback", {
		func = function()
			if arg_27_1 then
				arg_27_0.battleView:runDefer(arg_27_1.skillEndAddBuffsPlayFuncs)
			end

			if arg_27_1 then
				arg_27_0.battleView:runDefer(arg_27_1.skillEndTriggerBuffsPlayFuncs)
			end

			if arg_27_1 and arg_27_1.skillEndDrops then
				arg_27_0.battleView:onViewProxyNotify("dropShow", arg_27_1.skillEndDrops)
			end
		end
	}, arg_27_3)

	if arg_27_0.battleView:getEffectEventEnable() then
		arg_27_0:onResetSkillEnd(arg_27_2, arg_27_3)
	end

	arg_27_0:onAddEventEffect("callback", {
		func = function()
			if arg_27_1 then
				arg_27_0.battleView:runDefer(arg_27_1.skillEndDeleteDeadObjs)
			end

			if (arg_27_2 == battle.SkillType.NormalSkill or arg_27_2 == battle.SkillType.PassiveCombine) and arg_27_0.model.force == 1 and not arg_27_0.battleView:getSceneModel().autoFight then
				arg_27_0.battleView:onViewProxyNotify("showMain", true)
			end
		end
	}, arg_27_3)
end

function BattleSprite.onComeBack(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	local function var_30_0(arg_31_0)
		if arg_30_3.flashBack then
			arg_31_0:onResetPos()
		else
			local var_31_0 = {
				delayMove = arg_30_3.delayBeforeBack,
				costTime = arg_30_3.backCostTime,
				timeScale = arg_30_3.timeScale
			}

			arg_31_0:onAddEventEffect("comeBack", var_31_0, arg_30_2)
		end
	end

	if arg_30_5 then
		for iter_30_0, iter_30_1 in ipairs(arg_30_5) do
			var_30_0(iter_30_1:proxy())
		end
	end

	if arg_30_1 == battle.AttackPosIndex.selfPos and not arg_30_3.attackFriend then
		return
	end

	local var_30_1 = arg_30_0:getRealUseView()

	var_30_0(var_30_1)
end

function BattleSprite.onAfterComeBack(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0:onAddEventEffect("callback", {
		func = function()
			if arg_32_1 then
				arg_32_0.battleView:runDefer(arg_32_1.afterComeBackRecoverMp)
			end
		end
	}, arg_32_2)
end

function BattleSprite.onResetPos(arg_34_0)
	arg_34_0:onAddEventEffect("callback", {
		func = function()
			arg_34_0:resetPos()
		end
	})
end

function BattleSprite.onObjSkillOver(arg_36_0, arg_36_1)
	arg_36_0:onAddEventEffect("callback", {
		func = function()
			arg_36_0:popApplySkillSceneTag()
		end
	}, arg_36_1)
end

function BattleSprite.onNewBattleTurn(arg_38_0)
	local var_38_0 = not arg_38_0.lockEffectSwitch

	arg_38_0:objToHideEff(var_38_0)
	arg_38_0:onPlayBuffHolderAction()
	arg_38_0:onPlayUnitSpecBind()
end

function BattleSprite.onPlayUnitSpecBind(arg_39_0)
	local var_39_0
	local var_39_1

	for iter_39_0, iter_39_1 in ipairs(arg_39_0.unitSpecBind) do
		if not arg_39_0.specBindEffectCache[iter_39_0] then
			local var_39_2 = nodetools.get(arg_39_0, unpack(iter_39_1.node))
			local var_39_3 = newCSprite(iter_39_1.effect)

			var_39_2:addChild(var_39_3, iter_39_1.pos[3])
			var_39_3:setPosition(cc.p(iter_39_1.pos[1], iter_39_1.pos[2]))
			var_39_3:setScale(iter_39_1.scale or 1)
			var_39_3:setScaleX(arg_39_0.faceTo * (iter_39_1.scale or 1))

			arg_39_0.specBindEffectCache[iter_39_0] = {
				lastIndex = 0,
				effect = var_39_3
			}
		end

		local var_39_4 = arg_39_0.specBindEffectCache[iter_39_0]
		local var_39_5 = battleCsv.doFormula(iter_39_1.bind, {
			self = arg_39_0.model
		}) + 1

		if var_39_4.lastIndex ~= var_39_5 then
			local var_39_6 = iter_39_1.action[var_39_5]

			if var_39_6 then
				var_39_4.effect:play(var_39_6)

				var_39_4.lastIndex = var_39_5
			else
				errorInWindows("specBind(%s) action not has index(%s) ", arg_39_0.unitID, var_39_5)
			end
		end
	end
end

function BattleSprite.onAttacting(arg_40_0, arg_40_1, arg_40_2)
	arg_40_0:onAddEventEffect("callback", {
		func = function()
			if not arg_40_1 then
				arg_40_0.battleView:onViewProxyNotify("showLinkEffect", true)
			end

			arg_40_0.battleView:onViewProxyNotify("updateLinkEffect", arg_40_1, arg_40_0.key)

			local var_41_0 = gRootViewProxy:call("getSceneAllObjs")

			arg_40_0:getRealUseView():objToHideEff(arg_40_1, arg_40_0)

			if arg_40_1 then
				arg_40_0.sprite._opacity = arg_40_0.sprite:opacity()

				arg_40_0.sprite:opacity(255)
			else
				arg_40_0.sprite:opacity(arg_40_0.sprite._opacity)
			end
		end
	}, arg_40_2)
end

function BattleSprite.onDead(arg_42_0, arg_42_1, arg_42_2)
	arg_42_0:setDebugEnabled(false)
	arg_42_0:setEffectDebugEnabled(false)

	if not arg_42_0.actionTable[battle.SpriteActionTable.death]:empty() then
		arg_42_0:onAddEventEffect("effect", {
			action = battle.SpriteActionTable.death,
			onComplete = arg_42_2
		})

		return
	end

	arg_42_1 = arg_42_1 or "effect/death.skel"

	local function var_42_0()
		if arg_42_0.battleView.deathCache ~= nil then
			for iter_43_0, iter_43_1 in ipairs(arg_42_0.battleView.deathCache) do
				iter_43_1:removeSelf()
			end

			arg_42_0.battleView.deathCache = {}
		end
	end

	local var_42_1 = arg_42_0.unitCfg.everyPos.hitPos

	arg_42_0.lifebar:setVisible(false)
	arg_42_0.sprite:setVisible(false)
	transition.executeSequence(arg_42_0.sprite):fadeOut(0.4):done()
	transition.executeSequence(arg_42_0.sprite):delay(0.1):moveBy(1.2, var_42_1.x, var_42_1.y):done()
	transition.executeSequence(arg_42_0.sprite):delay(0.1):scaleTo(1, 0.01):func(var_42_0):func(arg_42_2 or function()
		return
	end):done()

	local var_42_2 = newCSprite(arg_42_1)

	arg_42_0:add(var_42_2)
	arraytools.push(arg_42_0.battleView.deathCache, var_42_2)
	var_42_2:setLocalZOrder(999999)
	var_42_2:anchorPoint(0.5, 0.5):scale(2)
	var_42_2:play("effect")
	var_42_2:setTimeScale(1.15)
end

function BattleSprite.onBeAttackPlayAni(arg_45_0)
	arg_45_0:play("beAttack")
	arg_45_0:setSpriteEventHandler(function(arg_46_0, arg_46_1)
		if arg_46_0 == sp.EventType.ANIMATION_COMPLETE then
			arg_45_0:play("standby_loop")
		end
	end)
end

function BattleSprite.onDealBuffEffectsMap(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	return gRootViewProxy:notify("dealBuffEffectsMap", arg_47_0, arg_47_1, arg_47_2, arg_47_3)
end

function BattleSprite.onShowBuffIcon(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	return gRootViewProxy:notify("showBuffIcon", arg_48_0, arg_48_1, arg_48_2, arg_48_3)
end

function BattleSprite.onShowBuffText(arg_49_0, arg_49_1)
	return gRootViewProxy:notify("showBuffText", arg_49_0, arg_49_1)
end

function BattleSprite.onShowBuffImmuneEffect(arg_50_0, arg_50_1)
	local var_50_0 = gBuffGroupRelationCsv[arg_50_1]

	if var_50_0 and var_50_0.immuneEffect then
		gRootViewProxy:notify("showBuffText", arg_50_0, string.format(battle.ShowHeadNumberRes.txtTypeImmune, var_50_0.immuneEffect))
	end
end

function BattleSprite.onAlterBattleScene(arg_51_0, arg_51_1)
	arg_51_0.battleView:onEventEffect(nil, "callback", {
		func = function()
			gRootViewProxy:notify("alterBattleScene", arg_51_1)
		end,
		delay = arg_51_1.delay or 0
	})
end

function BattleSprite.onWeatherRefresh(arg_53_0, arg_53_1)
	return gRootViewProxy:notify("weatherRefresh", arg_53_0, arg_53_1)
end

function BattleSprite.onDelBuffIcon(arg_54_0, arg_54_1)
	return gRootViewProxy:notify("delBuffIcon", arg_54_0, arg_54_1)
end

function BattleSprite.onShowHeadNumber(arg_55_0, arg_55_1)
	return gRootViewProxy:notify("showHeadNumber", arg_55_0, arg_55_1)
end

function BattleSprite.onShowHeadText(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_1.args
	local var_56_1 = var_56_0.delay or 0

	if var_56_0.miss then
		local var_56_2 = 0.15
		local var_56_3 = -40 * arg_56_0.faceTo
		local var_56_4 = 0
		local var_56_5 = 0.1

		transition.executeSequence(arg_56_0):delay(var_56_1):moveBy(var_56_2, var_56_3, var_56_4):delay(var_56_5):moveBy(var_56_2, -var_56_3, -var_56_4):done()
	end

	return gRootViewProxy:notify("showHeadText", arg_56_0, arg_56_1)
end

function BattleSprite.onShowBuffContent(arg_57_0, arg_57_1)
	if not arg_57_1 or arg_57_1 == "" then
		return
	end

	if not arg_57_0 then
		return
	end

	local var_57_0 = newCSprite(arg_57_1)

	if not var_57_0 then
		return
	end

	arg_57_0:add(var_57_0, 9999)

	local var_57_1 = arg_57_0.unitCfg.everyPos.hitPos

	var_57_0:setPosition(var_57_1)

	local function var_57_2()
		removeCSprite(var_57_0)
	end

	transition.executeSequence(var_57_0):delay(1):fadeOut(0.25):func(var_57_2):done()
end

function BattleSprite.onUpdateLifebar(arg_59_0, arg_59_1)
	if arg_59_1.skillType == battle.SkillType.NormalSkill and arg_59_1.mainSkillType ~= battle.MainSkillType.BigSkill then
		arg_59_0.lifebar:setVisible(true)
	end

	arg_59_0.lifebar:update(arg_59_1)
end

function BattleSprite.showSkillSelectTextState(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	local var_60_0

	if arg_60_1 == 0 then
		-- block empty
	elseif arg_60_3 then
		var_60_0 = battle.RestraintTypeIcon[arg_60_3]
	else
		var_60_0 = battle.RestraintTypeIcon[arg_60_2]
	end

	arg_60_0.natureQuan:show()
	arg_60_0.natureQuan.textDi:hide()

	if var_60_0 then
		arg_60_0.natureQuan.textDi:show()
		arg_60_0.natureQuan.textDi:loadTexture(var_60_0)
	end
end

function BattleSprite.beHit(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	if arg_61_2 then
		arg_61_0.beHitTime = arg_61_2

		if arg_61_0.beHitTime > 0 then
			if arg_61_3 then
				arg_61_0:setActionState(arg_61_3)
			else
				arg_61_0:setActionState(battle.SpriteActionTable.hit)
			end
		end
	else
		arg_61_0.beHitTime = arg_61_0.beHitTime - arg_61_1

		if arg_61_0.beHitTime <= 0 then
			arg_61_0:setActionState(battle.SpriteActionTable.standby)
		end
	end
end

function BattleSprite.getLeftBeHitTime(arg_62_0)
	return arg_62_0.beHitTime or 0
end

function BattleSprite.onReloadUnit(arg_63_0, arg_63_1)
	arg_63_0:reloadUnit()

	if arg_63_1 then
		arg_63_0:addToLayer(arg_63_1)
	end
end

function BattleSprite.onShowHeldItemEffect(arg_64_0, arg_64_1)
	local var_64_0 = csv.held_item.items[arg_64_1]
	local var_64_1 = var_64_0.icon
	local var_64_2 = var_64_0.quality
	local var_64_3 = arg_64_0.unitCfg.everyPos.hitPos
	local var_64_4 = var_64_3.x
	local var_64_5 = var_64_3.y + 150
	local var_64_6 = ccui.Layout:create():size(300, 300):anchorPoint(0.5, 0):xy(arg_64_0:getPositionX() + var_64_4, arg_64_0:getPositionY() + var_64_5):z(battle.SpriteLayerZOrder.qipao + 10):addTo(arg_64_0.battleView.gameLayer)
	local var_64_7 = "daojuchufa/daojuchufa.skel"
	local var_64_8 = newCSprite(var_64_7)

	if not var_64_8 then
		return
	end

	local var_64_9 = "effect"

	var_64_8:play(var_64_9)
	var_64_8:setSpriteEventHandler(function(arg_65_0, arg_65_1)
		if arg_65_0 == sp.EventType.ANIMATION_COMPLETE then
			removeCSprite(var_64_8)
		end
	end)
	var_64_8:setPosition(cc.p(150, 150))
	var_64_6:addChild(var_64_8, 1)

	local var_64_10 = ui.QUALITY_BOX[var_64_2]
	local var_64_11 = string.format("common/icon/panel_icon_k%d.png", var_64_2)
	local var_64_12 = ccui.ImageView:create(var_64_10):xy(150, 100):z(2):hide():addTo(var_64_6)
	local var_64_13 = ccui.ImageView:create(var_64_1):xy(150, 100):z(3):scale(2):hide():addTo(var_64_6)
	local var_64_14 = ccui.ImageView:create(var_64_11):xy(150, 100):z(4):hide():addTo(var_64_6)

	transition.executeSequence(var_64_6):delay(0.3):func(function()
		var_64_12:show()
		var_64_13:show()
		var_64_14:show()
	end):moveBy(0.4, 0, 70):delay(1.3):func(function()
		var_64_6:removeFromParent()
	end):done()
end

function BattleSprite.onShowCounterAttackText(arg_68_0, arg_68_1)
	arg_68_0.battleView:onEventEffect(nil, "callback", {
		delay = 0,
		func = function()
			arg_68_0:onShowBuffText(battle.ShowHeadNumberRes.txtFj)
		end
	})
end

function BattleSprite.onPlayCharge(arg_70_0, arg_70_1, arg_70_2)
	if not arg_70_1 then
		return
	end

	if arg_70_2 then
		arg_70_0:onPopAction(battle.SpriteActionTable.standby, "charge")

		if arg_70_1.endCharing then
			table.insert(arg_70_0.battleView.effectJumpCache, arg_70_0:onAddEventEffect("effect", {
				action = arg_70_1.endCharing.action,
				lifetime = arg_70_1.endCharing.lifeTime,
				onComplete = function()
					arg_70_0:onPlayState(battle.SpriteActionTable.standby)
				end
			}))
		else
			arg_70_0:onPlayState(battle.SpriteActionTable.standby)
		end
	else
		arg_70_0:onPushAction(battle.SpriteActionTable.standby, arg_70_1.charing.action, "charge")

		if arg_70_1.startCharing then
			table.insert(arg_70_0.battleView.effectJumpCache, arg_70_0:onAddEventEffect("effect", {
				action = arg_70_1.startCharing.action,
				lifetime = arg_70_1.startCharing.lifeTime,
				onComplete = function()
					if arg_70_1.charing then
						arg_70_0:onPlayState(battle.SpriteActionTable.standby)
					end
				end
			}))
		else
			arg_70_0:onPlayState(battle.SpriteActionTable.standby)
		end
	end
end

function BattleSprite.getMoveToTargetPos(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = arg_73_1.posChoose

	if var_73_0 == 0 then
		return battle.AttackPosIndex.center
	end

	if var_73_0 == 5 then
		return battle.AttackPosIndex.selfPos
	end

	local var_73_1 = battle.AttackPosIndex.selfPos

	if table.length(arg_73_2) > 0 then
		local var_73_2 = {}
		local var_73_3

		for iter_73_0, iter_73_1 in ipairs(arg_73_2) do
			local var_73_4 = arg_73_0.battleView:onViewProxyCall("getSceneObjById", iter_73_1.id) or iter_73_1

			table.insert(var_73_2, {
				seat = var_73_4.seat,
				force = var_73_4.force
			})
		end

		if var_73_0 == 1 or var_73_0 == 4 then
			var_73_1 = var_73_2[1].seat
		elseif var_73_0 == 6 then
			local var_73_5 = var_73_2[1].seat
			local var_73_6 = (var_73_5 - 1) % 3 + 1

			var_73_1 = var_73_5 > 6 and var_73_6 + 6 or var_73_6
		elseif var_73_0 == 7 then
			var_73_1 = var_73_2[table.length(var_73_2)].seat
		elseif var_73_0 == 8 then
			local var_73_7 = var_73_2[1].seat
			local var_73_8 = 2 + ((math.floor((var_73_7 + 2) / 3) - 1) % 2 + 1 - 1) * 3

			var_73_1 = var_73_7 > 6 and var_73_8 + 6 or var_73_8
		elseif var_73_0 == 9 then
			local var_73_9 = #var_73_2

			if var_73_9 == 4 then
				var_73_1 = var_73_2[2].seat
			elseif var_73_9 == 3 then
				if var_73_2[1].seat % 3 == 1 then
					var_73_1 = var_73_2[1].seat
				else
					var_73_1 = var_73_2[2].seat
				end
			else
				var_73_1 = var_73_2[1].seat
			end
		else
			local var_73_10 = 0
			local var_73_11 = 0

			for iter_73_2, iter_73_3 in ipairs(var_73_2) do
				local var_73_12 = arg_73_1.hintTargetType == 1
				local var_73_13

				if var_73_12 then
					var_73_13 = iter_73_3.force ~= arg_73_0.force
				else
					var_73_13 = iter_73_3.force == arg_73_0.force
				end

				if var_73_13 then
					if (iter_73_3.seat - 1) % 3 + 1 == 2 then
						return iter_73_3.seat
					end

					var_73_10 = var_73_10 + iter_73_3.seat
					var_73_11 = var_73_11 + 1
				end
			end

			if var_73_11 > 0 then
				var_73_1 = math.floor(var_73_10 / var_73_11)
			else
				printWarn("no targets be choose in targets %d when posChoose %d", table.length(arg_73_2), var_73_0)
			end
		end
	end

	logf.battle.skill("移动到目标位置: posIdx= %s", var_73_1)

	return var_73_1
end

function BattleSprite.onStageChange(arg_74_0, arg_74_1)
	arg_74_0.seat = arg_74_0.model.seat

	arg_74_0:resetPos()
	arg_74_0:updHitPanel()
	arg_74_0:onAddToScene()
end

function BattleSprite.onRecordOrderData(arg_75_0, arg_75_1, arg_75_2)
	if not arg_75_0.recordOrderDataTb[arg_75_1] then
		arg_75_0.recordOrderDataTb[arg_75_1] = CVector.new()
	end

	arg_75_0.recordOrderDataTb[arg_75_1]:push_back(arg_75_2)
end

function BattleSprite.onEscape(arg_76_0, arg_76_1)
	local var_76_0 = 0
	local var_76_1 = 0

	if arg_76_0.seat <= 6 then
		var_76_0 = -display.width / 2
		var_76_1 = battle.StandingPos[arg_76_0.seat].y
	else
		var_76_0 = display.width * 1.5
		var_76_1 = battle.StandingPos[arg_76_0.seat - 6].y
	end

	arg_76_0:onAddEventEffect("moveTo", {
		a = 100,
		speed = 150,
		delayMove = arg_76_1.delayMove or 0,
		costTime = arg_76_1.costTime or 1000,
		x = var_76_0,
		y = var_76_1,
		changeFaceTo = -1 * arg_76_0.faceTo
	}, false)
end

function BattleSprite.onPassOneWaveClean(arg_77_0)
	arg_77_0:setActionState(battle.SpriteActionTable.standby)

	for iter_77_0, iter_77_1 in ipairs(arg_77_0.effectJumpCache) do
		arg_77_0:onEventEffectCancel(iter_77_1)
	end

	arg_77_0.effectJumpCache = {}

	arg_77_0.effectManager:passOneWaveClear()

	for iter_77_2, iter_77_3 in pairs(arg_77_0.buffEffectsMap) do
		removeCSprite(iter_77_3)
	end

	arg_77_0.buffEffectsMap = {}
	arg_77_0.buffEffectsRef = {}
end
