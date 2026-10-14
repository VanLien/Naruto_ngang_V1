function ObjectModel.isBeInSneer(arg_1_0)
	return arg_1_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.sneer)
end

function ObjectModel.isBeInDuel(arg_2_0)
	if not arg_2_0:isBeInSneer() then
		return
	end

	return arg_2_0:getOverlaySpecBuffByIdx(battle.OverlaySpecBuff.sneer).mode == battle.SneerType.Duel
end

function ObjectModel.getSneerObj(arg_3_0)
	if arg_3_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.sneer) then
		local var_3_0 = arg_3_0:getOverlaySpecBuffByIdx(battle.OverlaySpecBuff.sneer).obj

		if var_3_0:checkOverlaySpecBuffExit("stealth") then
			for iter_3_0, iter_3_1 in var_3_0:ipairsOverlaySpecBuffTo("stealth", arg_3_0) do
				return nil
			end

			return var_3_0
		end

		return var_3_0
	end

	return nil
end

function ObjectModel.getSneerExtraArgs(arg_4_0, arg_4_1)
	if not arg_4_0:isBeInSneer() then
		return nil
	end

	local var_4_0 = arg_4_0:getOverlaySpecBuffByIdx(battle.OverlaySpecBuff.sneer)

	return arg_4_1 and var_4_0.extraArg.spreadArg2 or var_4_0.extraArg.spreadArg1
end

function ObjectModel.setProtectObj(arg_5_0, arg_5_1)
	if arg_5_0.force ~= arg_5_1.force then
		return nil
	end

	if arg_5_1:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.protection) then
		return nil
	end

	return arg_5_1
end

function ObjectModel.selectTextImmuneInfo(arg_6_0, arg_6_1)
	local var_6_0 = csv.skill[arg_6_1].skillDamageType

	if arg_6_0:hasTypeBuff("immuneAllDamage") then
		return "allimmune"
	end

	if var_6_0 == battle.SkillDamageType.Physical then
		if arg_6_0:hasTypeBuff("immunePhysicalDamage") then
			return "physical"
		end
	elseif var_6_0 == battle.SkillDamageType.Special and arg_6_0:hasTypeBuff("immuneSpecialDamage") then
		return "special"
	end

	local var_6_1

	for iter_6_0, iter_6_1 in arg_6_0:ipairsOverlaySpecBuffTo(battle.OverlaySpecBuff.immuneDamage) do
		var_6_1 = iter_6_1:getImmuneInfo(var_6_1, var_6_0)

		if var_6_1 == "allimmune" then
			break
		end
	end

	return var_6_1
end

function ObjectModel.processBeHitWakeUp(arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in arg_7_0:ipairsOverlaySpecBuffTo(battle.OverlaySpecBuff.sleepy, arg_7_1) do
		iter_7_1.time = iter_7_1.time - 1

		if iter_7_1.time == 0 then
			arg_7_0:delBuff(iter_7_1.id, true)
		end
	end
end

function ObjectModel.canReborn(arg_8_0)
	return arg_8_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.reborn)
end

function ObjectModel.processReborn(arg_9_0)
	if arg_9_0:canReborn() and arg_9_0:isFakeDeath() and not arg_9_0:isRebornState() then
		arg_9_0.state = battle.ObjectState.reborn

		local var_9_0 = true
		local var_9_1 = gRootViewProxy:proxy():pushDeferList(arg_9_0.id)

		for iter_9_0, iter_9_1 in arg_9_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.reborn) do
			if iter_9_1.isFastReborn then
				arg_9_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
					buffId = iter_9_1.buff.id
				})
				arg_9_0:delBuff(iter_9_1.buff.id)

				var_9_0 = false

				break
			end
		end

		if var_9_0 then
			logf.battle.object.reborn(" seat:%d 复活", arg_9_0.seat)

			local var_9_2 = arg_9_0:getOverlaySpecBuffByIdx(battle.OverlaySpecBuff.reborn)

			var_9_2.buff.lifeRound = var_9_2.lifeRound

			arg_9_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
				buffId = var_9_2.buff.id
			})
		end

		arg_9_0.scene:addListViewToBattleTurn(arg_9_0, gRootViewProxy:proxy():popDeferList(var_9_1))
	end
end

function ObjectModel.resetRebornState(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.state = battle.ObjectState.normal

	arg_10_0:resetHp(arg_10_1)
	arg_10_0:setMP1(arg_10_2)
	arg_10_0.scene.extraRecord:cleanEventByKey(battle.ExRecordEvent.rebornRound, arg_10_0.id)
end

function ObjectModel.isBeInConfusion(arg_11_0)
	return arg_11_0:checkOverlaySpecBuffExit("confusion")
end

function ObjectModel.isNeedAutoFightByBuff(arg_12_0)
	return arg_12_0:isBeInSneer() or arg_12_0:isBeInConfusion() or arg_12_0.scene:beInExtraAttack() or arg_12_0.scene.play:getExtraBattleRoundData("targetId")
end

function ObjectModel.addBuffEnhance(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if not arg_13_0.buffGroupEnchance[arg_13_4][arg_13_1] then
		arg_13_0.buffGroupEnchance[arg_13_4][arg_13_1] = {}
	end

	arg_13_0.buffGroupEnchance[arg_13_4][arg_13_1][arg_13_2] = arg_13_3
end

function ObjectModel.delBuffEnhance(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_0.buffGroupEnchance[arg_14_3][arg_14_1] then
		return
	end

	arg_14_0.buffGroupEnchance[arg_14_3][arg_14_1][arg_14_2] = nil
end

function ObjectModel.getBuffEnhance(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = 0

	if arg_15_1 == 0 or not arg_15_0.buffGroupEnchance[arg_15_2][arg_15_1] then
		return var_15_0
	end

	for iter_15_0, iter_15_1 in pairs(arg_15_0.buffGroupEnchance[arg_15_2][arg_15_1]) do
		var_15_0 = var_15_0 + iter_15_1
	end

	return var_15_0
end

function ObjectModel.isNotReSelect(arg_16_0, arg_16_1)
	if arg_16_1 and arg_16_0:checkOverlaySpecBuffExit("depart") then
		for iter_16_0, iter_16_1 in arg_16_0:ipairsOverlaySpecBuffTo("depart", arg_16_0) do
			if not iter_16_1.canProtect then
				return true
			end
		end
	end

	return arg_16_0:isAlreadyDead() or arg_16_0:checkOverlaySpecBuffExit("leave")
end

function ObjectModel.addSkillType2Data(arg_17_0, arg_17_1, arg_17_2)
	for iter_17_0, iter_17_1 in ipairs(arg_17_0.closeSkillType2) do
		if iter_17_1.tag == arg_17_1 then
			iter_17_1.data = arg_17_2

			return
		end
	end

	table.insert(arg_17_0.closeSkillType2, {
		tag = arg_17_1,
		data = arg_17_2
	})
end

function ObjectModel.removeSkillType2Data(arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in ipairs(arg_18_0.closeSkillType2) do
		if iter_18_1.tag == arg_18_1 then
			table.remove(arg_18_0.closeSkillType2, iter_18_0)

			return
		end
	end
end

function ObjectModel.isSKillType2Close(arg_19_0, arg_19_1)
	local var_19_0 = false

	for iter_19_0 = table.length(arg_19_0.closeSkillType2), 1, -1 do
		if arg_19_0.closeSkillType2[iter_19_0].data[arg_19_1] then
			var_19_0 = var_19_0 or arg_19_0.closeSkillType2[iter_19_0].data[arg_19_1]
		end
	end

	return var_19_0
end

function ObjectModel.setExtraAttackMode(arg_20_0, arg_20_1)
	if not arg_20_0.exAttackMode then
		arg_20_0.exAttackMode = arg_20_1
	end
end

function ObjectModel.beInExtraAttack(arg_21_0)
	if arg_21_0.exAttackBattleTriggerRound == arg_21_0.scene.play.curBattleRound then
		return false
	end

	return arg_21_0.exAttackMode
end

function ObjectModel.nextExtraAttack(arg_22_0)
	if arg_22_0.extraRoundData:empty() then
		return false
	end

	return arg_22_0.extraRoundData:back().mode
end

local function var_0_0(arg_23_0)
	local var_23_0

	for iter_23_0, iter_23_1 in arg_23_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.extraSkillWeightValueFix) do
		if iter_23_1.fixType == 0 then
			var_23_0 = {
				fixWeightValue = iter_23_1.fixValue,
				fixCostType = iter_23_1.fixCostType
			}
		end
	end

	return var_23_0
end

local function var_0_1(arg_24_0, arg_24_1)
	local var_24_0 = {
		canResponseSelf = true,
		canResponseOthers = true,
		canTriggerOthers = true
	}

	for iter_24_0, iter_24_1 in arg_24_0:ipairsOverlaySpecBuff("banExtraAttack") do
		local var_24_1 = iter_24_1.banModeTb[arg_24_1]

		for iter_24_2, iter_24_3 in pairs(iter_24_1.banModeType[var_24_1]) do
			var_24_0[iter_24_2] = battleEasy.ifElse(not iter_24_3, iter_24_3, var_24_0[iter_24_2])
		end
	end

	return var_24_0
end

local function var_0_2(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = var_0_1(arg_25_0, arg_25_2)
	local var_25_1 = var_0_1(arg_25_1, arg_25_2)

	if arg_25_0.id == arg_25_1.id and not var_25_1.canResponseSelf then
		return false
	end

	if arg_25_0.id ~= arg_25_1.id then
		if not var_25_0.canTriggerOthers then
			return false
		end

		if not var_25_1.canResponseOthers then
			return false
		end
	end

	return true
end

function ObjectModel.onComboAttack(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not arg_26_1:isNormalSkillType() then
		return false
	end

	if arg_26_0.id ~= arg_26_3.id then
		return false
	end

	local var_26_0 = arg_26_2.id

	if arg_26_2:isAlreadyDead() then
		var_26_0 = nil
	end

	if arg_26_2:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
		fromObj = arg_26_1.owner
	}) then
		return false
	end

	if not arg_26_0.comboAttackInfo then
		return false
	end

	if arg_26_0:beInExtraAttack() then
		return false
	end

	if ymrand.random() > arg_26_0.comboAttackInfo.rate then
		return false
	end

	arg_26_0:addExtraBattleData(var_26_0, arg_26_1.id, battle.ExtraAttackMode.combo)

	return true
end

function ObjectModel.onCounterAttack(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if not arg_27_1:isNormalSkillType() then
		return false
	end

	if arg_27_0.id == arg_27_3.id or arg_27_3:isAlreadyDead() then
		return false
	end

	if arg_27_0.force == arg_27_3.force and not arg_27_0:isBeInConfusion() then
		return false
	end

	for iter_27_0, iter_27_1 in arg_27_0.extraRoundData:pairs() do
		if iter_27_1.mode == battle.ExtraAttackMode.counter then
			return false
		end
	end

	local var_27_0 = false
	local var_27_1 = var_0_0(arg_27_3)

	for iter_27_2, iter_27_3 in arg_27_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.counterAttack) do
		local var_27_2 = false

		if not iter_27_3.mustEnemy or arg_27_0.force ~= arg_27_3.force and not arg_27_0:isBeInConfusion() then
			local var_27_3 = iter_27_3.find() or {}

			for iter_27_4, iter_27_5 in ipairs(var_27_3) do
				if (arg_27_1.allDamageTargets[iter_27_5.id] or arg_27_1.protecterObjs[iter_27_5.id]) and var_0_2(iter_27_5, arg_27_0, battle.ExtraAttackMode.counter) then
					var_27_2 = true

					break
				end
			end
		end

		if ymrand.random() <= iter_27_3.rate and var_27_2 then
			var_27_0 = true

			if iter_27_3.triggerSkillType == "table" then
				arg_27_0:addExtraBattleData(arg_27_3.id, nil, battle.ExtraAttackMode.counter, {
					skillPowerMap = var_27_1 and var_27_1.fixWeightValue or iter_27_3.triggerSkillType2,
					costType = var_27_1 and var_27_1.fixCostType or iter_27_3.costType
				})
			else
				local var_27_4 = arg_27_0:getSkillByType2(iter_27_3.triggerSkillType2)

				arg_27_0:addExtraBattleData(arg_27_3.id, var_27_4.id, battle.ExtraAttackMode.counter)
			end
		end

		if var_27_0 then
			break
		end
	end

	return var_27_0
end

function ObjectModel.onSyncAttack(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if arg_28_2:isAlreadyDead() then
		-- block empty
	end

	local var_28_0 = arg_28_2.id

	local function var_28_1(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		if not arg_29_0 or arg_29_0 and arg_29_0:isAlreadyDead() then
			return
		end

		if arg_28_2.force == arg_29_0.force and not arg_29_0:isBeInConfusion() and not arg_29_1.isFixedForce then
			return
		end

		if var_28_0 == arg_29_0.id then
			return
		end

		if arg_28_2:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
			fromObj = arg_29_0
		}) then
			return
		end

		if arg_29_1.rate > ymrand.random() then
			if arg_29_1.triggerSkillType == "table" then
				arg_29_0:addExtraBattleData(var_28_0, nil, arg_29_2, {
					skillPowerMap = arg_29_3 and arg_29_3.fixWeightValue or arg_29_1.triggerSkillType2,
					costType = arg_29_3 and arg_29_3.fixCostType or arg_29_1.costType,
					isFixedForce = arg_29_1.isFixedForce,
					targetForce = arg_29_1.isFixedForce and var_28_0 and arg_28_2.force
				})
			else
				local var_29_0 = arg_29_0:getSkillByType2(arg_29_1.triggerSkillType2)

				arg_29_0:addExtraBattleData(var_28_0, var_29_0.id, arg_29_2)
			end

			arg_29_0.scene:addObjToExtraRound(arg_29_0)
		end
	end

	if arg_28_0.id == arg_28_3.id then
		local var_28_2 = var_0_0(arg_28_3)

		for iter_28_0, iter_28_1 in arg_28_3:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.inviteAttack) do
			if iter_28_1.isTrigger(arg_28_1.skillType2) then
				local var_28_3 = iter_28_1.find() or {}

				for iter_28_2, iter_28_3 in ipairs(var_28_3) do
					if var_0_2(arg_28_3, iter_28_3, battle.ExtraAttackMode.inviteAttack) then
						var_28_1(iter_28_3, iter_28_1, battle.ExtraAttackMode.inviteAttack, var_28_2)
					end
				end
			end
		end
	end

	if arg_28_0.force ~= arg_28_3.force then
		return
	end

	if arg_28_0.id == arg_28_3.id then
		return
	end

	if arg_28_0.id == arg_28_2.id then
		return
	end

	local var_28_4 = var_0_0(arg_28_3)

	for iter_28_4, iter_28_5 in arg_28_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.syncAttack) do
		if iter_28_5.isTrigger(arg_28_1.skillType2) and var_0_2(arg_28_3, arg_28_0, battle.ExtraAttackMode.syncAttack) then
			var_28_1(arg_28_0, iter_28_5, battle.ExtraAttackMode.syncAttack, var_28_4)
		end
	end
end

function ObjectModel.onAssistAttack(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0

	if arg_30_0:isAlreadyDead() then
		return
	end

	if arg_30_1 and (not arg_30_1:isAlreadyDead() or true) then
		var_30_0 = arg_30_1.id

		if arg_30_1.force == arg_30_0.force and not arg_30_0:isBeInConfusion() then
			return
		end

		if arg_30_1:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
			fromObj = arg_30_0
		}) then
			return
		end
	end

	if arg_30_2.rate > ymrand.random() then
		if arg_30_2.triggerSkillType == "table" then
			arg_30_0:addExtraBattleData(var_30_0, nil, battle.ExtraAttackMode.assistAttack, {
				skillPowerMap = arg_30_2.triggerSkillType2,
				costType = arg_30_2.costType
			})
		else
			local var_30_1 = arg_30_0:getSkillByType2(arg_30_2.triggerSkillType2)

			arg_30_0:addExtraBattleData(var_30_0, var_30_1.id, battle.ExtraAttackMode.assistAttack)
		end

		arg_30_0.scene:addObjToExtraRound(arg_30_0)
	end
end

function ObjectModel.onProphetAttack(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if not arg_31_1:isNormalSkillType() then
		return false
	end

	if arg_31_0.id == arg_31_2.id or arg_31_2:isAlreadyDead() then
		return false
	end

	if arg_31_0.force == arg_31_2.force and (arg_31_3.mustEnemy or not arg_31_0:isBeInConfusion()) then
		return false
	end

	local var_31_0 = var_0_0(arg_31_2)

	if arg_31_3.triggerSkillType == "table" then
		arg_31_0:addExtraBattleData(arg_31_2.id, nil, battle.ExtraAttackMode.counter, {
			skillPowerMap = var_31_0 and var_31_0.fixWeightValue or arg_31_3.triggerSkillType2,
			costType = var_31_0 and var_31_0.fixCostType or arg_31_3.costType
		})
	else
		local var_31_1 = arg_31_0:getSkillByType2(arg_31_3.triggerSkillType2)

		arg_31_0:addExtraBattleData(arg_31_2.id, var_31_1.id, battle.ExtraAttackMode.counter)
	end

	arg_31_0.scene:addObjToExtraRound(arg_31_0)
end

function ObjectModel.extraBattleRoundCantAttack(arg_32_0)
	local var_32_0 = arg_32_0.scene.play:getExtraBattleRoundData("cantHit")

	if var_32_0 and var_32_0[arg_32_0.id] then
		return true
	end

	return false
end

function ObjectModel.canShiftPos(arg_33_0)
	if arg_33_0:isRealDeath() then
		return false
	end

	if not arg_33_0.shiftPosMode then
		return false
	end

	local var_33_0 = arg_33_0.shiftPos
	local var_33_1 = arg_33_0.scene:getObjectBySeat(var_33_0)

	if var_33_1 and not var_33_1:isRealDeath() then
		return false
	end

	return true
end

function ObjectModel.doShiftPos(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.shiftPos
	local var_34_1 = arg_34_0.seat
	local var_34_2 = arg_34_0.scene:getObjectBySeat(var_34_0)

	if var_34_2 then
		var_34_2.seat, arg_34_0.seat = var_34_1, var_34_0
	else
		arg_34_0.seat = var_34_0
	end

	arg_34_0.shiftPos = nil
	arg_34_0.shiftPosMode = nil

	arg_34_0.view:notify("doShiftPos", var_34_0, arg_34_1)
	gRootViewProxy:notify("doShiftPos", tostring(arg_34_0))

	if var_34_2 then
		var_34_2.view:notify("doShiftPos", var_34_1)
		gRootViewProxy:notify("doShiftPos", tostring(var_34_2))
	end
end

function ObjectModel.checkBuffCanBeAdd(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0.scene:getObject(arg_35_1)

	if arg_35_2 ~= 1 then
		if var_35_0 and var_35_0:checkOverlaySpecBuffExit("leave") and var_35_0.id ~= arg_35_0.id then
			return false
		end

		if var_35_0 and var_35_0:checkOverlaySpecBuffExit("depart") and var_35_0.id ~= arg_35_0.id then
			for iter_35_0, iter_35_1 in var_35_0:ipairsOverlaySpecBuffTo("depart") do
				if iter_35_1.leaveSwitch then
					return false
				end
			end
		end
	end

	local var_35_1 = battleEasy.ifElse(arg_35_3, battleCsv.doFormula(arg_35_3, arg_35_0.protectedEnv), {})

	if var_35_1 ~= 1 and arg_35_0:isLogicStateExit(battle.ObjectLogicState.cantBeAddBuff, {
		fromObj = var_35_0,
		ignoreBuffGroup = battleEasy.ifElse(type(var_35_1) == "table", var_35_1, {})
	}) then
		return false
	end

	if var_35_0 and var_35_0:isBeInSneer() then
		local var_35_2 = var_35_0.force == arg_35_0.force

		if var_35_0:getSneerExtraArgs(var_35_2) == battle.SneerArgType.NoSpread or var_35_0:getSneerExtraArgs(var_35_2) == battle.SneerArgType.DamageSpread then
			local var_35_3 = var_35_2 and var_35_0 or var_35_0:getSneerObj()

			if var_35_3 and var_35_3 ~= arg_35_0 then
				return false
			end
		end
	end

	return true
end

local function var_0_3()
	return {
		order = CVector.new(),
		list = CVector.new(),
		__bindKeys = cow.proxyObject("__bindKeys", {}),
		__globals = cow.proxyObject("__globals", {}),
		__filters = {}
	}
end

function ObjectModel.addOverlaySpecBuff(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = arg_37_1.csvCfg.easyEffectFunc
	local var_37_1 = gBuffEffect[var_37_0]

	if not var_37_1 then
		return errorInWindows("please init %s in buff_effect.csv", var_37_0)
	end

	arg_37_0.recordBuffDataTb[var_37_0] = arg_37_0.recordBuffDataTb[var_37_0] or var_0_3()

	local var_37_2 = arg_37_0.recordBuffDataTb[var_37_0]

	if not arg_37_2 then
		errorInWindows("addOverlaySpecBuff must need refresh")
	end

	local var_37_3 = var_37_2.list:size() + 1

	for iter_37_0, iter_37_1 in var_37_2.list:ipairs() do
		if iter_37_1.id == arg_37_1.id then
			var_37_3 = iter_37_0

			break
		end
	end

	if var_37_1.overlayType == battle.BuffEffectOverlayType.Normal then
		if var_37_3 > var_37_1.overlayLimit then
			arg_37_1:overClean()

			return
		end
	elseif var_37_1.overlayType == battle.BuffEffectOverlayType.PopTop then
		if var_37_3 > var_37_1.overlayLimit then
			local var_37_4 = var_37_2.list:pop_front()
			local var_37_5 = arg_37_0.buffs:find(var_37_4.id)

			if var_37_5 then
				var_37_5:overClean()
			end

			var_37_3 = var_37_3 - 1
		end
	elseif var_37_1.overlayType == battle.BuffEffectOverlayType.SameMode then
		local var_37_6 = 0
		local var_37_7

		for iter_37_2, iter_37_3 in var_37_2.list:ipairs() do
			if iter_37_3.mode == arg_37_1.mode then
				var_37_6 = var_37_6 + 1
				var_37_7 = iter_37_3.id
			end
		end

		if var_37_6 + 1 > var_37_1.overlayLimit then
			local var_37_8 = arg_37_0.buffs:find(var_37_7)

			if var_37_8 then
				var_37_8:overClean()
			end

			var_37_3 = var_37_2.list:size() + 1
		end
	end

	if not var_37_2.list:at(var_37_3) then
		local var_37_9 = {
			__index = function(arg_38_0, arg_38_1)
				local var_38_0 = var_37_2.__bindKeys[arg_38_1]

				if var_38_0 then
					return arg_38_0.buffRef[var_38_0]
				end

				if var_37_2.__globals[arg_38_1] then
					return var_37_2.__globals[arg_38_1]
				end

				return arg_38_0.data[arg_38_1]
			end,
			__newindex = function(arg_39_0, arg_39_1, arg_39_2)
				local var_39_0 = var_37_2.__bindKeys[arg_39_1]

				if var_39_0 then
					arg_39_0.buffRef[var_39_0] = arg_39_2
				elseif var_37_2.__globals[arg_39_1] then
					var_37_2.__globals[arg_39_1] = arg_39_2
				else
					arg_39_0.data[arg_39_1] = arg_39_2
				end
			end
		}
		local var_37_10 = setmetatable({
			cfgId = arg_37_1.cfgId,
			id = arg_37_1.id,
			group = arg_37_1:group(),
			buffRef = cow.proxyObject("listData_buffRef", arg_37_1.isNumberType and arg_37_1 or arg_37_1:getValue()),
			data = cow.proxyObject("listData_data", {}),
			bind = function(arg_40_0, arg_40_1, arg_40_2)
				if not var_37_2.__bindKeys[arg_40_1] then
					var_37_2.__bindKeys[arg_40_1] = arg_40_2
				end
			end,
			setG = function(arg_41_0, arg_41_1, arg_41_2)
				if not var_37_2.__globals[arg_41_1] then
					var_37_2.__globals[arg_41_1] = arg_41_2
				end
			end
		}, var_37_9)

		var_37_2.list:push_back(var_37_10)
	end

	arg_37_2(var_37_2.list:at(var_37_3))

	if arg_37_3 and var_37_3 > 1 and var_37_2.list:size() == var_37_3 then
		var_37_2.list:sort(arg_37_3)
	end

	arg_37_0:refreshOverlaySpecBuffOrder(var_37_0)
end

function ObjectModel.getOverlaySpecBuffData(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.recordBuffDataTb[arg_42_1]

	return var_42_0 and var_42_0.__globals or {}
end

function ObjectModel.refreshOverlaySpecBuffOrder(arg_43_0, arg_43_1)
	local var_43_0 = type(arg_43_1) == "string" and {
		arg_43_1
	} or arg_43_1

	for iter_43_0, iter_43_1 in ipairs(var_43_0) do
		local var_43_1 = arg_43_0.recordBuffDataTb[iter_43_1]
		local var_43_2

		var_43_1.order:clear()

		for iter_43_2, iter_43_3 in var_43_1.list:ipairs() do
			local var_43_3 = true

			for iter_43_4, iter_43_5 in ipairs(var_43_1.__filters) do
				if iter_43_5(iter_43_3) then
					var_43_3 = false

					break
				end
			end

			if var_43_3 then
				var_43_1.order:push_back(iter_43_2)
			end
		end
	end
end

function ObjectModel.addOverlaySpecBuffFilter(arg_44_0, arg_44_1, arg_44_2)
	arg_44_0.recordBuffDataTb[arg_44_1] = arg_44_0.recordBuffDataTb[arg_44_1] or var_0_3()

	local var_44_0 = arg_44_0.recordBuffDataTb[arg_44_1]
	local var_44_1 = arg_44_2 or function()
		return true
	end

	table.insert(var_44_0.__filters, var_44_1)
	arg_44_0:refreshOverlaySpecBuffOrder(arg_44_1)

	return tostring(var_44_1)
end

function ObjectModel.deleteOverlaySpecBuffFilter(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0.recordBuffDataTb[arg_46_1]

	for iter_46_0, iter_46_1 in ipairs(var_46_0.__filters) do
		if tostring(iter_46_1) == arg_46_2 then
			table.remove(var_46_0.__filters, iter_46_0)

			break
		end
	end

	arg_46_0:refreshOverlaySpecBuffOrder(arg_46_1)
end

function ObjectModel.checkOverlaySpecBuffExit(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.recordBuffDataTb[arg_47_1]

	if not var_47_0 then
		return false
	end

	if var_47_0.order:size() == 0 then
		return false
	end

	return true
end

local function var_0_4()
	return nil
end

function ObjectModel.ipairsOverlaySpecBuff(arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_0:checkOverlaySpecBuffExit(arg_49_1) then
		return var_0_4
	end

	local var_49_0 = arg_49_0.recordBuffDataTb[arg_49_1]
	local var_49_1 = var_49_0.order
	local var_49_2 = var_49_0.list
	local var_49_3 = 0
	local var_49_4 = 1
	local var_49_5 = var_49_1:size()

	arg_49_2 = arg_49_2 or function()
		return false
	end

	return function()
		var_49_3 = var_49_3 + 1

		while var_49_4 <= var_49_5 do
			local var_51_0 = var_49_2:at(var_49_1:at(var_49_4))

			var_49_4 = var_49_4 + 1

			if var_51_0 and arg_49_2(var_51_0) == false then
				return var_49_3, var_51_0
			end
		end

		return nil
	end
end

function ObjectModel.ipairsOverlaySpecBuffTo(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0

	local function var_52_1(arg_53_0)
		if arg_52_2 then
			for iter_53_0, iter_53_1 in arg_52_2:ipairsOverlaySpecBuff("ignoreSpecBuff") do
				if iter_53_1.cfgIds[arg_53_0.cfgId] or iter_53_1.specBuffList[arg_52_1] then
					return true
				end
			end
		end

		if arg_52_3 and arg_52_3.ignoreBuffGroup and itertools.include(arg_52_3.ignoreBuffGroup, arg_53_0.group) then
			return true
		end

		return false
	end

	return arg_52_0:ipairsOverlaySpecBuff(arg_52_1, var_52_1)
end

function ObjectModel.deleteOverlaySpecBuff(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_1.csvCfg.easyEffectFunc
	local var_54_1 = arg_54_0.recordBuffDataTb[var_54_0]
	local var_54_2, var_54_3 = var_54_1.list:size()
	local var_54_4 = 1
	local var_54_5

	for iter_54_0 = 1, var_54_2 do
		local var_54_6 = var_54_1.order:at(var_54_4)

		if var_54_6 then
			if var_54_5 then
				if var_54_5 < var_54_6 then
					var_54_1.order:update(var_54_4, var_54_6 - 1)

					var_54_4 = var_54_4 + 1
				end
			elseif var_54_6 < iter_54_0 then
				var_54_4 = var_54_4 + 1
			end
		end

		local var_54_7 = var_54_1.list:at(iter_54_0)

		if not var_54_5 and var_54_7.id == arg_54_1.id then
			if arg_54_2 then
				arg_54_2(var_54_7)
			end

			var_54_1.list:erase(iter_54_0)

			if var_54_1.order:at(var_54_4) and var_54_1.order:at(var_54_4) == iter_54_0 then
				var_54_1.order:erase(var_54_4)
			end

			var_54_5 = iter_54_0
		end
	end
end

function ObjectModel.getOverlaySpecBuffByIdx(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_0:checkOverlaySpecBuffExit(arg_55_1) then
		return
	end

	local var_55_0 = arg_55_0.recordBuffDataTb[arg_55_1].order:at(arg_55_2 or 1)

	return arg_55_0.recordBuffDataTb[arg_55_1].list:at(var_55_0)
end

function ObjectModel.addOverlaySpecBuffFunc(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	if not arg_56_0:checkOverlaySpecBuffExit(arg_56_1) then
		return
	end

	arg_56_0.recordBuffDataTb[arg_56_1][arg_56_2] = arg_56_3
end

function ObjectModel.doOverlaySpecBuffFunc(arg_57_0, arg_57_1, arg_57_2, ...)
	if not arg_57_0:checkOverlaySpecBuffExit(arg_57_1) then
		return
	end

	if not arg_57_0.recordBuffDataTb[arg_57_1][arg_57_2] then
		return
	end

	return arg_57_0.recordBuffDataTb[arg_57_1][arg_57_2](...)
end

function ObjectModel.doFrontStage(arg_58_0)
	arg_58_0.seat = arg_58_0.frontStageTarget

	arg_58_0:setMP1(arg_58_0:mp1() + arg_58_0.transferMp)

	local var_58_0 = arg_58_0.scene.play

	if arg_58_0.stageRound ~= var_58_0.curRound or not arg_58_0.stageAttacked then
		table.insert(var_58_0.roundLeftHeros, {
			obj = arg_58_0
		})
	end

	arg_58_0.stageRound = nil
	arg_58_0.stageAttacked = nil
	arg_58_0.frontStageTarget = nil
	arg_58_0.transferMp = nil

	arg_58_0:onInitPassData()
	arg_58_0:initedTriggerPassiveSkill()
	arg_58_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBackStage, arg_58_0)
	arg_58_0:onFieldStateChange(true)
	gRootViewProxy:getProxy("onAddUnitsInSeat", tostring(arg_58_0))
	battleEasy.deferNotifyCantJump(arg_58_0.view, "stageChange", true)
end

function ObjectModel.clearFieldBuffs(arg_59_0)
	for iter_59_0, iter_59_1 in arg_59_0:iterBuffs() do
		if iter_59_1.isFieldSubBuff then
			iter_59_1:overClean()
		end
	end
end

function ObjectModel.onFieldStateChange(arg_60_0, arg_60_1)
	if arg_60_0.preFieldState then
		if arg_60_1 and arg_60_0.preFieldState == 1 then
			return
		elseif not arg_60_1 and arg_60_0.preFieldState == 2 then
			return
		end
	end

	local var_60_0 = arg_60_0:isLeaveField()

	if var_60_0 and not arg_60_1 then
		arg_60_0:clearFieldBuffs()

		arg_60_0.preFieldState = 2

		arg_60_0:influenceAuraBuff(var_60_0)
	elseif not var_60_0 and arg_60_1 then
		arg_60_0.scene:tirggerFieldBuffs(arg_60_0)

		arg_60_0.preFieldState = 1

		arg_60_0:influenceAuraBuff(var_60_0)
	end
end

function ObjectModel.influenceAuraBuff(arg_61_0, arg_61_1)
	for iter_61_0, iter_61_1 in arg_61_0.auraBuffs:order_pairs() do
		iter_61_1:refreshAuraRef(arg_61_1 and -1 or 1)
	end

	for iter_61_2, iter_61_3 in arg_61_0.buffs:order_pairs() do
		if iter_61_3.isAuraType then
			iter_61_3:alterAuraBuffValue(0)
		end
	end
end

function ObjectModel.isLeaveField(arg_62_0)
	local var_62_0 = false

	if arg_62_0:checkOverlaySpecBuffExit("leave") then
		var_62_0 = true
	end

	for iter_62_0, iter_62_1 in arg_62_0:ipairsOverlaySpecBuffTo("depart") do
		if iter_62_1.leaveSwitch then
			var_62_0 = true

			break
		end
	end

	if arg_62_0.seat < 0 then
		var_62_0 = true
	end

	return var_62_0
end

function ObjectModel.dealOpenValueByKey(arg_63_0, arg_63_1, arg_63_2)
	for iter_63_0, iter_63_1 in arg_63_0:ipairsOverlaySpecBuffTo(battle.OverlaySpecBuff.opGameData) do
		if iter_63_1 and iter_63_1.key == arg_63_1 then
			local var_63_0 = iter_63_1

			if var_63_0 ~= true then
				arg_63_0.protectedEnv:resetEnv()

				local var_63_1 = battleCsv.fillFuncEnv(arg_63_0.protectedEnv, {
					oldValue = arg_63_2
				})

				var_63_0 = battleCsv.doFormula(var_63_0, var_63_1)
			end

			if var_63_0 then
				return iter_63_1.op(arg_63_2, iter_63_1.value)
			end
		end
	end

	return arg_63_2
end

function ObjectModel.addReplaceSkillRecord(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	if not arg_64_0.skillIdToReplaceRecord[arg_64_1] then
		local var_64_0 = table.length(arg_64_0.skillReplaceReocrd) + 1

		arg_64_0.skillReplaceReocrd[var_64_0] = {}

		table.insert(arg_64_0.skillReplaceReocrd[var_64_0], {
			skillId = arg_64_1
		})

		arg_64_0.skillIdToReplaceRecord[arg_64_1] = var_64_0
	end

	arg_64_0.skillIdToReplaceRecord[arg_64_2] = arg_64_0.skillIdToReplaceRecord[arg_64_1]

	table.insert(arg_64_0.skillReplaceReocrd[arg_64_0.skillIdToReplaceRecord[arg_64_2]], {
		skillId = arg_64_2,
		buffId = arg_64_3
	})
end

function ObjectModel.delReplaceSkillRecord(arg_65_0, arg_65_1, arg_65_2)
	for iter_65_0, iter_65_1 in ipairs(arg_65_0.skillReplaceReocrd[arg_65_1]) do
		if iter_65_1.buffId == arg_65_2 then
			table.remove(arg_65_0.skillReplaceReocrd[arg_65_1], iter_65_0)

			break
		end
	end
end

function ObjectModel.getLastSkillRecord(arg_66_0, arg_66_1)
	local var_66_0 = table.length(arg_66_0.skillReplaceReocrd[arg_66_1])

	return arg_66_0.skillReplaceReocrd[arg_66_1][var_66_0].skillId
end

function ObjectModel.doReplaceSkill(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_0.skills[arg_67_1]
	local var_67_1 = var_67_0.spellRound
	local var_67_2 = var_67_0:getLevel()

	arg_67_0.skills[arg_67_1] = nil

	local var_67_3 = csv.skill[arg_67_2]
	local var_67_4 = newSkillModel(arg_67_0.scene, arg_67_0, arg_67_2, var_67_2)

	arg_67_0.skills[arg_67_2] = var_67_4
	var_67_4.spellRound = var_67_1
end

function ObjectModel.afterReplaceSkill(arg_68_0)
	arg_68_0:updateSkillsOrder()
	arg_68_0:checkSkillCheat()

	for iter_68_0, iter_68_1 in arg_68_0:iterSkills() do
		iter_68_1:updateStateInfoTb()
	end
end

function ObjectModel.replaceSkill(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	for iter_69_0, iter_69_1 in ipairs(arg_69_1) do
		local var_69_0 = arg_69_2[iter_69_0]

		if arg_69_0.skills[iter_69_1] then
			arg_69_0:addReplaceSkillRecord(iter_69_1, var_69_0, arg_69_3)
			arg_69_0:doReplaceSkill(iter_69_1, var_69_0)
		end
	end

	arg_69_0:afterReplaceSkill()
end

function ObjectModel.resumeSkill(arg_70_0, arg_70_1)
	for iter_70_0, iter_70_1 in ipairs(arg_70_0.skillReplaceReocrd) do
		local var_70_0 = arg_70_0:getLastSkillRecord(iter_70_0)

		arg_70_0:delReplaceSkillRecord(iter_70_0, arg_70_1)

		local var_70_1 = arg_70_0:getLastSkillRecord(iter_70_0)

		if var_70_1 and var_70_1 ~= var_70_0 then
			arg_70_0:doReplaceSkill(var_70_0, var_70_1)
		end
	end

	arg_70_0:afterReplaceSkill()
end

function ObjectModel.resetReplaceSkillRecord(arg_71_0)
	arg_71_0.skillIdToReplaceRecord = {}
	arg_71_0.skillReplaceReocrd = {}
end

function ObjectModel.isSelfForceConfusionAndNoTarget(arg_72_0)
	local var_72_0 = false

	for iter_72_0, iter_72_1 in arg_72_0:ipairsOverlaySpecBuff("confusion", function(arg_73_0)
		return not arg_73_0.needSelfForce
	end) do
		var_72_0 = true

		break
	end

	if not var_72_0 then
		return false
	end

	local var_72_1 = arg_72_0:getCanAttackObjs(arg_72_0.force)

	return table.length(var_72_1) == 0
end

function ObjectModel.newBuffImmune(arg_74_0)
	arg_74_0.buffImmuneCache = {
		immuneBuff = CMap.new(),
		immuneGroup = CMap.new(),
		powerGroup = CMap.new()
	}

	for iter_74_0, iter_74_1 in arg_74_0:iterBuffs() do
		if iter_74_1.isInited and not iter_74_1.isOver then
			arg_74_0:onBuffImmuneChange(iter_74_1)
		end
	end
end

function ObjectModel.onBuffImmuneChange(arg_75_0, arg_75_1, arg_75_2)
	if not arg_75_0.buffImmuneCache then
		return
	end

	local function var_75_0(arg_76_0, arg_76_1)
		local var_76_0 = arg_76_0:find(arg_76_1)

		if not var_76_0 then
			arg_76_0:insert(arg_76_1, {})

			var_76_0 = arg_76_0:find(arg_76_1)
		end

		var_76_0[arg_75_1.id] = battleEasy.ifElse(arg_75_2, nil, true)

		if not next(var_76_0) then
			arg_76_0:erase(arg_76_1)
		end
	end

	local var_75_1 = gBuffGroupRelationCsv[arg_75_1:group()]

	if var_75_1 then
		for iter_75_0, iter_75_1 in ipairs(var_75_1.immuneGroup) do
			for iter_75_2, iter_75_3 in pairs(iter_75_1) do
				var_75_0(arg_75_0.buffImmuneCache.immuneGroup, iter_75_2)
			end
		end

		for iter_75_4, iter_75_5 in ipairs(var_75_1.powerGroup) do
			for iter_75_6, iter_75_7 in pairs(iter_75_5) do
				var_75_0(arg_75_0.buffImmuneCache.powerGroup, iter_75_6)
			end
		end
	end

	local var_75_2 = arg_75_1.csvCfg.immuneBuff

	for iter_75_8, iter_75_9 in ipairs(var_75_2) do
		var_75_0(arg_75_0.buffImmuneCache.immuneBuff, iter_75_9)
	end
end

function ObjectModel.checkBuffCanAdd(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
	if not arg_77_0.buffImmuneCache then
		arg_77_0:newBuffImmune()
	end

	local var_77_0 = true
	local var_77_1 = {}
	local var_77_2 = arg_77_0.buffImmuneCache.immuneGroup:find(arg_77_2)
	local var_77_3 = arg_77_0.buffImmuneCache.immuneBuff:find(arg_77_1)

	if arg_77_0.buffImmuneCache.powerGroup:size() > 0 and not arg_77_0.buffImmuneCache.powerGroup:find(arg_77_2) then
		return false
	end

	if arg_77_3.beImmune == 1 and var_77_2 and next(var_77_2) then
		for iter_77_0, iter_77_1 in pairs(var_77_2) do
			table.insert(var_77_1, iter_77_0)
		end

		var_77_0 = false
	end

	if arg_77_3.beImmune == 1 and var_77_3 and next(var_77_3) then
		for iter_77_2, iter_77_3 in pairs(var_77_3) do
			table.insert(var_77_1, iter_77_2)
		end

		var_77_0 = false
	end

	if not var_77_0 then
		table.sort(var_77_1, function(arg_78_0, arg_78_1)
			local var_78_0 = arg_77_0.scene.allBuffs:find(arg_78_0)
			local var_78_1 = arg_77_0.scene.allBuffs:find(arg_78_1)

			if var_78_0.triggerPriority ~= var_78_1.triggerPriority then
				return var_78_0.triggerPriority < var_78_1.triggerPriority
			end

			return var_78_0.id < var_78_1.id
		end)

		local var_77_4 = arg_77_0.scene.allBuffs:find(var_77_1[1])

		battleEasy.deferNotifyCantJump(arg_77_0.view, "showBuffImmuneEffect", arg_77_2)
		var_77_4:triggerByMoment(battle.BuffTriggerPoint.onBuffTrigger, {
			buffId = var_77_4.id
		})
	end

	return var_77_0
end

function ObjectModel.clearBuffImmune(arg_79_0)
	arg_79_0.buffImmuneCache = nil
end

function ObjectModel.isPossessAttack(arg_80_0, arg_80_1)
	if arg_80_0:getEventByKey(battle.ExRecordEvent.possessTarget) and arg_80_0:beInExtraAttack() == battle.ExtraAttackMode.assistAttack then
		if arg_80_1 and arg_80_1 ~= battle.SkillType.NormalSkill and arg_80_1 ~= battle.SkillType.PassiveCombine then
			return false
		end

		return true
	end

	return false
end
