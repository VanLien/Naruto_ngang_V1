local var_0_0 = class("BuffModel")

globals.BuffModel = var_0_0
var_0_0.IDCounter = 0

local var_0_1 = {
	copyCasterBuffsToHolder = true,
	transferBuffToOther = true,
	copyForceBuffsToOther = true,
	reborn = true
}
local var_0_2 = {
	lockHp = true,
	keepHpUnChanged = true
}
local var_0_3 = {
	[battle.BuffTriggerPoint.onHolderBattleTurnStart] = true,
	[battle.BuffTriggerPoint.onHolderBattleTurnEnd] = true,
	[battle.BuffTriggerPoint.onHolderAttackBefore] = true,
	[battle.BuffTriggerPoint.onHolderAttackEnd] = true,
	[battle.BuffTriggerPoint.onHolderFinallyBeHit] = true,
	[battle.BuffTriggerPoint.onHolderBeforeBeHit] = true,
	[battle.BuffTriggerPoint.onHolderKillHandleChooseTarget] = true,
	[battle.BuffTriggerPoint.onHolderBeForeSkillSpellTo] = true,
	[battle.BuffTriggerPoint.onHolderToAttack] = true,
	[battle.BuffTriggerPoint.onHolderBeForeSkillSpellTo] = true,
	[battle.BuffTriggerPoint.onHolderCalcDamageProb] = true
}
local var_0_4 = {
	[battle.BuffTriggerPoint.onHolderBattleTurnStart] = true,
	[battle.BuffTriggerPoint.onHolderBattleTurnEnd] = true,
	[battle.BuffTriggerPoint.onRoundStart] = true,
	[battle.BuffTriggerPoint.onRoundEnd] = true,
	[battle.BuffTriggerPoint.onBuffTrigger] = true
}

table.merge(var_0_4, var_0_3)

var_0_0.IterAllPointsMap = var_0_4

function var_0_0.BuffCmp(arg_1_0, arg_1_1)
	if arg_1_0.triggerPriority ~= arg_1_1.triggerPriority then
		return arg_1_0.triggerPriority < arg_1_1.triggerPriority
	end

	return arg_1_0.id < arg_1_1.id
end

function var_0_0.ctor(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	var_0_0.IDCounter = var_0_0.IDCounter + 1
	arg_2_0.id = var_0_0.IDCounter
	arg_2_0.scene = arg_2_2.scene
	arg_2_0.cfgId = arg_2_1
	arg_2_0.csvCfg = csv.buff[arg_2_1]
	arg_2_0.csvPower = csv.buff_group_power[arg_2_0.csvCfg.groupPower]
	arg_2_0.caster = arg_2_3
	arg_2_0.holder = arg_2_2
	arg_2_0.extraTargets = {
		[battle.BuffExtraTargetType.lastProcessTargets] = arg_2_4.lastProcessTargets or {},
		[battle.BuffExtraTargetType.holderBeAttackFrom] = {},
		[battle.BuffExtraTargetType.skillAllDamageTargets] = arg_2_4.currentAttackTarget or {},
		[battle.BuffExtraTargetType.overLayBuffCaster] = {},
		[battle.BuffExtraTargetType.segProcessTargets] = {}
	}
	arg_2_0.startRound = 0
	arg_2_0.nowRound = 0

	arg_2_0:setRound()

	arg_2_0.nowWave = arg_2_0.scene.play.curWave
	arg_2_0.args = arg_2_4
	arg_2_0.lifeRound = arg_2_4.lifeRound
	arg_2_0.source = arg_2_4.source
	arg_2_0.fromSkillLevel = arg_2_4.skillLevel
	arg_2_0.isInited = false
	arg_2_0.isOver = false
	arg_2_0.isEffect = false
	arg_2_0.buffValue = nil
	arg_2_0.value = nil
	arg_2_0.doEffectValue = nil
	arg_2_0.isNumberType = true
	arg_2_0.triggerPriority = arg_2_0.csvCfg.triggerPriority or 10
	arg_2_0.isAuraType = arg_2_4.isAuraType
	arg_2_0.lifeRounds = {}
	arg_2_0.overlayType = arg_2_0.csvCfg.overlayType
	arg_2_0.overlayCount = arg_2_4.overlayCount or 1
	arg_2_0.objThatTriggeringMeNow = nil
	arg_2_0.triggerEnv = {}
	arg_2_0.bondChildBuffsTb = {}
	arg_2_0.bondToOtherBuffsTb = {}
	arg_2_0.triggerAddAttrTb = {}
	arg_2_0.nodeManager = BuffNodeManager.new(arg_2_0)
	arg_2_0.exRecordNameTb = {}
	arg_2_0.protectedEnv = battleCsv.makeProtectedEnv(arg_2_0.caster, nil, arg_2_0)
	arg_2_0.castBuffEnvAdded = false
	arg_2_0.castBuffGroup = CList.new()
	arg_2_0.buffInitEnhanceVal = nil
	arg_2_0.isShow = arg_2_0.csvCfg.isShow
	arg_2_0.isOnceEffectPlayed = not arg_2_0.isShow
	arg_2_0.isFieldBuff = arg_2_0.csvCfg.easyEffectFunc == "fieldBuff"
	arg_2_0.isFieldSubBuff = arg_2_4.fieldSub
	arg_2_0.gateLimit = arg_2_0:cfg2Value(arg_2_0.csvCfg.gateLimit)
end

function var_0_0.setRound(arg_3_0)
	if arg_3_0.csvCfg.lifeRoundType == battle.lifeRoundType.battleTurn then
		arg_3_0.startRound = arg_3_0.holder:getBattleRoundAllWave(arg_3_0.csvCfg.skillTimePos)
		arg_3_0.nowRound = arg_3_0.holder:getBattleRoundAllWave(arg_3_0.csvCfg.skillTimePos)
	elseif arg_3_0.csvCfg.lifeRoundType == battle.lifeRoundType.round then
		arg_3_0.startRound = arg_3_0.scene.play.totalRound
		arg_3_0.nowRound = arg_3_0.scene.play.totalRound
	elseif arg_3_0.csvCfg.lifeRoundType == battle.lifeRoundType.pureBattleTurn then
		arg_3_0.startRound = arg_3_0.holder:getBattleRoundAllWave(arg_3_0.csvCfg.skillTimePos, true)
		arg_3_0.nowRound = arg_3_0.holder:getBattleRoundAllWave(arg_3_0.csvCfg.skillTimePos, true)
	end
end

function var_0_0.checkCanDispelBuff(arg_4_0, arg_4_1)
	if arg_4_1.holder.cantDispelTb and next(arg_4_1.holder.cantDispelTb) then
		local var_4_0 = arg_4_1.holder.cantDispelTb.buffGroupTb
		local var_4_1 = arg_4_1.holder.cantDispelTb.buffRound

		if var_4_0[arg_4_1:group()] then
			local var_4_2 = arg_4_0.nowRound

			arg_4_1.cantDispelBuffRound = {
				var_4_2,
				var_4_1
			}
		end
	end

	if arg_4_1.cantDispelBuffRound and next(arg_4_1.cantDispelBuffRound) then
		local var_4_3 = arg_4_1.cantDispelBuffRound[1]
		local var_4_4 = arg_4_1.cantDispelBuffRound[2]

		if arg_4_0.nowRound < var_4_3 + var_4_4 then
			return false
		else
			arg_4_1.cantDispelBuffRound = nil
		end
	end

	return true
end

function var_0_0.getTobeDispeledBuffs(arg_5_0, arg_5_1, arg_5_2)
	if table.length(arg_5_2) > 0 then
		table.sort(arg_5_2, function(arg_6_0, arg_6_1)
			return arg_6_0.id < arg_6_1.id
		end)

		local var_5_0 = arg_5_0.csvCfg.dispelType[3] or 0

		for iter_5_0, iter_5_1 in ipairs(arg_5_2) do
			if arg_5_0:checkCanDispelBuff(iter_5_1) then
				arg_5_0:addExRecord(battle.ExRecordEvent.dispelBuffCount, 1)
				logf.battle.buff.dispel("buff %s dispel buff %s bufftype=%s", arg_5_0.cfgId, iter_5_1.cfgId, iter_5_1.csvCfg.easyEffectFunc)
				iter_5_1:BeDispel(var_5_0 == 0)
			end
		end

		arg_5_0:triggerByMoment(battle.BuffTriggerPoint.onBuffTrigger)

		arg_5_1 = true
		arg_5_2 = {}
	end

	return arg_5_1, arg_5_2
end

function var_0_0.setDispeledBuffs(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.csvCfg.dispelType
	local var_7_1 = var_7_0[1] or 0
	local var_7_2 = var_7_0[2] or 0
	local var_7_3 = var_7_0[3] or 0
	local var_7_4 = {}
	local var_7_5 = {}
	local var_7_6 = {}

	local function var_7_7(arg_8_0, arg_8_1)
		if not var_7_4[arg_8_1] then
			var_7_4[arg_8_1] = CMap.new(function(arg_9_0, arg_9_1)
				return arg_9_0.id < arg_9_1.id
			end)

			table.insert(var_7_5, arg_8_1)
		end

		var_7_6[arg_8_1] = var_7_6[arg_8_1] + 1

		var_7_4[arg_8_1]:insert(arg_8_0.id, arg_8_0)
	end

	local function var_7_8(arg_10_0)
		local var_10_0 = false

		if var_7_2 >= var_7_6[arg_10_0] then
			var_10_0 = true
		elseif var_7_2 > 0 and ymrand.random(0, 1) == 1 then
			var_10_0 = true
		end

		var_7_6[arg_10_0] = var_7_6[arg_10_0] - 1

		if var_10_0 then
			var_7_2 = var_7_2 - 1
		end

		return var_10_0
	end

	if var_7_1 ~= nil then
		if var_7_1 == 2 then
			function var_7_7(arg_11_0, arg_11_1)
				if not var_7_4[arg_11_1] then
					var_7_4[arg_11_1] = CMap.new()

					table.insert(var_7_5, arg_11_1)
				end

				local var_11_0 = arg_11_0:group()

				if not var_7_4[arg_11_1]:find(var_11_0) then
					var_7_4[arg_11_1]:insert(var_11_0, CMap.new())

					var_7_6[arg_11_1] = var_7_6[arg_11_1] + 1
				end

				var_7_4[arg_11_1]:find(var_11_0):insert(arg_11_0.id, arg_11_0)
			end
		elseif var_7_1 == 0 then
			function var_7_8(arg_12_0)
				return true
			end
		end
	end

	local var_7_9 = arg_7_0.csvCfg.specialTarget and arg_7_0.csvCfg.specialTarget[1] and arg_7_0:getObjectsByCfg(arg_7_0.csvCfg.specialTarget[1]) or {
		arg_7_0.holder
	}

	for iter_7_0, iter_7_1 in ipairs(var_7_9) do
		for iter_7_2, iter_7_3 in iter_7_1:iterBuffs() do
			local var_7_10, var_7_11 = battleCsv.hasBuffGroup(arg_7_2.dispelGroup, iter_7_3:group())

			if iter_7_3.csvPower.beDispel == 1 and iter_7_3.id ~= arg_7_0.id and var_7_10 then
				var_7_6[var_7_11] = var_7_6[var_7_11] or 0

				var_7_7(iter_7_3, var_7_11)
			end
		end
	end

	local var_7_12 = {}

	local function var_7_13(arg_13_0)
		if not var_7_12[arg_13_0.cfgId] then
			var_7_12[arg_13_0.cfgId] = 0
		end

		var_7_12[arg_13_0.cfgId] = var_7_12[arg_13_0.cfgId] + 1

		if var_7_3 == 0 or var_7_3 > 0 and var_7_12[arg_13_0.cfgId] <= var_7_3 then
			table.insert(arg_7_1, arg_13_0)
		end
	end

	for iter_7_4, iter_7_5 in ipairs(var_7_5) do
		local var_7_14 = var_7_4[iter_7_5]

		if var_7_14 then
			for iter_7_6, iter_7_7 in var_7_14:order_pairs() do
				if var_7_8(iter_7_5) then
					if var_7_1 and var_7_1 == 2 then
						for iter_7_8, iter_7_9 in iter_7_7:order_pairs() do
							var_7_13(iter_7_9)
						end
					else
						var_7_13(iter_7_7)
					end
				end
			end
		end
	end
end

function var_0_0.dispelGroupBuff(arg_14_0)
	if not arg_14_0.isInited then
		return
	end

	arg_14_0.dispelCount = 0

	local var_14_0 = arg_14_0.csvCfg.dispelBuff
	local var_14_1 = {}
	local var_14_2 = false
	local var_14_3 = gBuffGroupRelationCsv[arg_14_0:group()]

	if csvSize(var_14_0) > 0 then
		for iter_14_0, iter_14_1 in arg_14_0.holder:iterBuffs() do
			if iter_14_1.csvPower.beDispel == 1 and iter_14_1.id ~= arg_14_0.id and itertools.include(var_14_0, iter_14_1.cfgId) then
				table.insert(var_14_1, iter_14_1)
			end
		end
	end

	local var_14_4, var_14_5 = arg_14_0:getTobeDispeledBuffs(var_14_2, var_14_1)

	if arg_14_0:group() ~= 0 and var_14_3 and var_14_3.dispelGroup then
		arg_14_0:setDispeledBuffs(var_14_5, var_14_3)
	end

	local var_14_6, var_14_7 = arg_14_0:getTobeDispeledBuffs(var_14_4, var_14_5)

	if var_14_6 and arg_14_0.caster and not arg_14_0.caster:isDeath() then
		arg_14_0.caster:addExRecord(battle.ExRecordEvent.dispelSuccessCount, 1)
		arg_14_0:addExRecord(battle.ExRecordEvent.dispelSuccess, true)
	end

	return var_14_6
end

function var_0_0.initTriggerEvents(arg_15_0)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.nodeManager.points) do
		if not var_0_4[iter_15_0] then
			arg_15_0:subscribeEvent(arg_15_0.holder, iter_15_0, "onTriggerEvent")
		end
	end
end

function var_0_0.init(arg_16_0)
	if arg_16_0.isOver then
		return
	end

	if arg_16_0.isInited then
		return
	end

	if arg_16_0.holder:isRealDeath() then
		return
	end

	arg_16_0.isInited = true

	arg_16_0.scene:checkCowWithBuff(arg_16_0)
	logf.battle.buff.init(" buff init() id=%s cfgId=%s buffType=%s groupId=%s lifeRound=%s prob=%s caster=%s holder=%s", arg_16_0.id, arg_16_0.cfgId, arg_16_0.csvCfg.easyEffectFunc, arg_16_0.csvCfg.group, arg_16_0.lifeRound, arg_16_0.args.prob, arg_16_0.caster and arg_16_0.caster.seat, arg_16_0.holder.seat)

	arg_16_0.buffValue = clone(arg_16_0:cfg2Value(arg_16_0.args.value))
	arg_16_0.isNumberType = type(arg_16_0.buffValue) == "number"

	if arg_16_0.isNumberType then
		arg_16_0.buffInitEnhanceVal = arg_16_0.holder:getBuffEnhance(arg_16_0:group(), 1)
	end

	arg_16_0:setValue(arg_16_0.buffValue)
	battleComponents.bind(arg_16_0, "Event")
	arg_16_0.nodeManager:init(arg_16_0.csvCfg.triggerBehaviors)
	arg_16_0:initTriggerEvents()

	if arg_16_0.overlayType == battle.BuffOverlayType.Coexist or arg_16_0.overlayType == battle.BuffOverlayType.CoexistLifeRound then
		if not arg_16_0.holder.buffOverlayCount[arg_16_0.cfgId] then
			arg_16_0.holder.buffOverlayCount[arg_16_0.cfgId] = 0
		end

		arg_16_0.holder.buffOverlayCount[arg_16_0.cfgId] = arg_16_0.holder.buffOverlayCount[arg_16_0.cfgId] > 0 and arg_16_0.holder.buffOverlayCount[arg_16_0.cfgId] or 1
	end

	logf.battle.buff.overlay("overlay buff id=%s cfgId=%s type:%d,overlay count:%d", arg_16_0.id, arg_16_0.cfgId, arg_16_0.overlayType, arg_16_0.overlayCount)

	local var_16_0 = arg_16_0:dispelGroupBuff()

	if arg_16_0.scene:isCraftGateType() then
		if not arg_16_0.scene.play.craftBuffAddTimes[arg_16_0.cfgId] then
			arg_16_0.scene.play.craftBuffAddTimes[arg_16_0.cfgId] = {
				0,
				0
			}
		end

		arg_16_0.scene.play.craftBuffAddTimes[arg_16_0.cfgId][arg_16_0.holder.force] = arg_16_0.scene.play.craftBuffAddTimes[arg_16_0.cfgId][arg_16_0.holder.force] + 1
	end

	arg_16_0.holder:onBuffImmuneChange(arg_16_0)
	arg_16_0:triggerByMoment(battle.BuffTriggerPoint.onBuffCreate)

	if arg_16_0.isFieldBuff then
		arg_16_0.scene:tirggerFieldBuffs(nil, arg_16_0)
	end

	if arg_16_0.isShow then
		arg_16_0.holder.view:proxy():onDealBuffEffectsMap(arg_16_0.csvCfg.iconResPath, arg_16_0.cfgId, arg_16_0.csvCfg.isIconFrame)

		local var_16_1 = arg_16_0:getBuffEffectAniArgs()

		var_16_1.dispel = var_16_0
		arg_16_0.isOnceEffectPlayed = true

		battleEasy.deferNotifyCantJump(arg_16_0.holder.view, "playBuffAniEffect", var_16_1)

		if arg_16_0.csvCfg.buffshader and csvSize(arg_16_0.csvCfg.buffshader) > 0 then
			battleEasy.deferNotifyCantJump(arg_16_0.holder.view, "playBuffShader", {
				buffshader = arg_16_0.csvCfg.buffshader,
				buffId = arg_16_0.cfgId
			})
		end

		if arg_16_0.csvCfg.stageArgs then
			arg_16_0.scene:recordSceneAlterBuff(arg_16_0.id, arg_16_0.cfgId)

			local var_16_2 = arg_16_0.csvCfg.stageArgs
			local var_16_3 = getCsv(var_16_2[1].bkCsv)

			battleEasy.deferNotifyCantJump(arg_16_0.holder.view, "alterBattleScene", {
				restore = false,
				buffId = arg_16_0.id,
				aniName = var_16_3[1].aniName,
				resPath = var_16_3[1].res,
				x = var_16_3[1].x,
				y = var_16_3[1].y,
				delay = var_16_2[1].delay
			})
		end

		if arg_16_0.weatherCfgId then
			battleEasy.deferNotifyCantJump(arg_16_0.holder.view, "weatherRefresh", arg_16_0)
		end

		arg_16_0:playBuffProcessView()
	end
end

function var_0_0.cfg2ValueWithEnv(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0 then
		return
	end

	if type(arg_17_0) == "table" then
		local var_17_0 = {}

		for iter_17_0, iter_17_1 in csvMapPairs(arg_17_0) do
			if iter_17_0 == "input" or iter_17_0 == "process" then
				var_17_0[iter_17_0] = iter_17_1
			else
				var_17_0[iter_17_0] = var_0_0.cfg2ValueWithEnv(iter_17_1, arg_17_1)
			end
		end

		return var_17_0
	end

	if ObjectAttrs.AttrsTable[arg_17_0] then
		return arg_17_0
	end

	if arg_17_0 == "lastMp1" then
		return arg_17_0
	end

	if (string.find(arg_17_0, "target2") or string.find(arg_17_0, "self2")) and not arg_17_2 then
		return arg_17_0
	end

	return battleCsv.doFormula(arg_17_0, arg_17_1)
end

function var_0_0.cfg2ValueWithTrigger(arg_18_0, arg_18_1)
	arg_18_0.protectedEnv = battleCsv.fillFuncEnv(arg_18_0.protectedEnv, {
		trigger = arg_18_0.triggerEnv
	})

	local var_18_0 = arg_18_0:cfg2Value(arg_18_1)

	arg_18_0.protectedEnv:resetEnv()

	return var_18_0
end

function var_0_0.cfg2Value(arg_19_0, arg_19_1)
	return arg_19_0.cfg2ValueWithEnv(arg_19_1, arg_19_0.protectedEnv, arg_19_0.castBuffEnvAdded)
end

function var_0_0.overClean(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or {}
	arg_20_1.endType = battle.BuffOverType.clean

	arg_20_0:over(arg_20_1)
end

function var_0_0.overBuffsInTable(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if table.length(arg_21_1) <= 0 then
		return
	end

	if arg_21_3 then
		table.sort(arg_21_1, arg_21_3)
	end

	for iter_21_0, iter_21_1 in ipairs(arg_21_1) do
		if iter_21_1 then
			iter_21_1:over(arg_21_2)
		end
	end
end

function var_0_0.over(arg_22_0, arg_22_1)
	if arg_22_0.isOver then
		return
	end

	arg_22_0.isOver = true
	arg_22_1 = arg_22_1 or {}
	arg_22_1.endType = arg_22_1.endType or battle.BuffOverType.normal

	logf.battle.buff.over(" buff over!!! id=%s cfgId=%s holder=%s", arg_22_0.id, arg_22_0.cfgId, arg_22_0.holder.seat)

	if arg_22_0.csvCfg.easyEffectFunc and arg_22_0.isEffect then
		arg_22_0.overType = arg_22_1.endType

		arg_22_0:doEffect(arg_22_0.csvCfg.easyEffectFunc, arg_22_0.doEffectValue, true)
	end

	if arg_22_1.endType ~= battle.BuffOverType.clean then
		if arg_22_1.triggerCtrlEnd then
			arg_22_0:triggerByMoment(battle.BuffTriggerPoint.onBuffControlEnd)
		end

		local var_22_0 = {
			battle.BuffTriggerPoint.onBuffOverNormal,
			battle.BuffTriggerPoint.onBuffOverDispel,
			battle.BuffTriggerPoint.onBuffOverlay
		}

		arg_22_0:triggerByMoment(var_22_0[arg_22_1.endType])
		arg_22_0:triggerByMoment(battle.BuffTriggerPoint.onBuffOver)
	end

	arg_22_0.triggerAddAttrTb = {}

	arg_22_0:overBuffsInTable(arg_22_0.bondChildBuffsTb, arg_22_1, function(arg_23_0, arg_23_1)
		return arg_23_0.id < arg_23_1.id
	end)
	arg_22_0:overBuffsInTable(arg_22_0.bondToOtherBuffsTb, arg_22_1, function(arg_24_0, arg_24_1)
		return arg_24_0.id < arg_24_1.id
	end)

	if arg_22_1.endType ~= battle.BuffOverType.clean and arg_22_0.csvCfg.easyEffectFunc == "reborn" then
		arg_22_0:triggerByMoment(battle.BuffTriggerPoint.onHolderReborn)
	end

	if arg_22_0.isShow then
		local var_22_1 = arg_22_0.csvCfg

		battleEasy.deferNotifyCantJump(arg_22_0.holder.view, "deleteBuffEffect", {
			aniSelectId = arg_22_0:getEffectAniSelectId(),
			id = arg_22_0.id,
			cfgId = arg_22_0.cfgId,
			cfg = var_22_1,
			tostrModel = tostring(arg_22_0.holder)
		})

		if arg_22_0.csvCfg.stageArgs then
			arg_22_0.scene:recordSceneAlterBuff(arg_22_0.id, nil)
			battleEasy.deferNotifyCantJump(arg_22_0.holder.view, "alterBattleScene", {
				restore = true,
				buffId = arg_22_0.id
			})
		end

		arg_22_0:playBuffProcessView()

		if arg_22_0.weatherCfgId then
			arg_22_0.isShow = false

			for iter_22_0, iter_22_1 in arg_22_0.scene:ipairsHeros() do
				if iter_22_1 and iter_22_1:checkOverlaySpecBuffExit("weather") then
					arg_22_0.isShow = true

					break
				end
			end

			battleEasy.deferNotifyCantJump(arg_22_0.holder.view, "weatherRefresh", arg_22_0)
		end
	end

	if arg_22_0.overlayType == battle.BuffOverlayType.Coexist or arg_22_0.overlayType == battle.BuffOverlayType.CoexistLifeRound then
		arg_22_0.holder.buffOverlayCount[arg_22_0.cfgId] = arg_22_0.holder.buffOverlayCount[arg_22_0.cfgId] - 1

		if arg_22_0.holder.buffOverlayCount[arg_22_0.cfgId] > 0 and arg_22_0.isShow then
			local var_22_2 = arg_22_0:getBuffEffectAniArgs()

			if arg_22_0.overlayType == battle.BuffOverlayType.Coexist then
				battleEasy.deferNotifyCantJump(arg_22_0.holder.view, "playBuffAniEffect", var_22_2, {
					"iconEffect",
					"mainEffect"
				})
			end
		end
	end

	for iter_22_2, iter_22_3 in pairs(arg_22_0.exRecordNameTb) do
		arg_22_0.scene.extraRecord:cleanEventByKey(iter_22_2, arg_22_0.id)
	end

	arg_22_0.holder:onBuffImmuneChange(arg_22_0, true)
	battleComponents.unbindAll(arg_22_0)
	arg_22_0.holder.buffs:erase(arg_22_0.id)
	arg_22_0.scene:deleteBuff(arg_22_0.id)
	arg_22_0.scene:checkCowWithBuff(arg_22_0)
end

function var_0_0.judgeOver(arg_25_0)
	return arg_25_0:getLifeRound() <= 0
end

local function var_0_5(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_2 and arg_26_2 == 0
	local var_26_1 = not arg_26_2 or arg_26_2 == 1
	local var_26_2 = not arg_26_0 or arg_26_0 == battle.lifeRoundType.battleTurn or arg_26_0 == battle.lifeRoundType.pureBattleTurn
	local var_26_3 = arg_26_1 == battle.BuffTriggerPoint.onHolderBattleTurnStart and var_26_0
	local var_26_4 = arg_26_1 == battle.BuffTriggerPoint.onHolderBattleTurnEnd and var_26_1

	if var_26_2 and (var_26_3 or var_26_4) then
		return true
	end

	local var_26_5 = arg_26_0 and arg_26_0 == battle.lifeRoundType.round
	local var_26_6 = arg_26_1 == battle.BuffTriggerPoint.onRoundStart and var_26_0
	local var_26_7 = arg_26_1 == battle.BuffTriggerPoint.onRoundEnd and var_26_1

	if var_26_5 and (var_26_6 or var_26_7) then
		return true
	end

	return false
end

local var_0_6 = {
	function(arg_27_0, arg_27_1)
		local var_27_0 = battle.BuffTriggerPoint.onHolderBattleTurnEnd == arg_27_1 and 1 or 2

		return arg_27_0.holder:getBattleRoundAllWave(var_27_0)
	end,
	function(arg_28_0, arg_28_1)
		local var_28_0 = battle.BuffTriggerPoint.onRoundEnd == arg_28_1 and 1 or 0

		return arg_28_0.scene.play.totalRound + arg_28_0.csvCfg.lifeTimeEnd * var_28_0
	end,
	function(arg_29_0, arg_29_1)
		local var_29_0 = battle.BuffTriggerPoint.onHolderBattleTurnEnd == arg_29_1 and 1 or 2

		return arg_29_0.holder:getBattleRoundAllWave(var_29_0, true)
	end
}

function var_0_0.setLeftRound(arg_30_0, arg_30_1)
	local var_30_0 = 0
	local var_30_1 = arg_30_0.csvCfg.lifeRoundType or battle.lifeRoundType.battleTurn

	if var_30_1 == battle.lifeRoundType.pureBattleTurn and arg_30_0.scene:getExtraBattleRoundMode() ~= battle.ExtraBattleRoundMode.normal then
		return
	end

	local var_30_2 = var_0_6[var_30_1](arg_30_0, arg_30_1)

	if var_30_2 > arg_30_0.nowRound then
		local var_30_3 = var_30_2 - arg_30_0.nowRound

		arg_30_0.lifeRound = arg_30_0.lifeRound - var_30_3
		arg_30_0.nowRound = var_30_2

		if arg_30_0:getLifeRound() <= 0 then
			arg_30_0:over()

			return
		end

		if arg_30_0.overlayType == 5 then
			local var_30_4 = arg_30_0.overlayCount

			for iter_30_0, iter_30_1 in maptools.order_pairs(arg_30_0.lifeRounds) do
				if iter_30_1 > 0 then
					iter_30_1 = iter_30_1 - var_30_3

					if iter_30_1 <= 0 then
						arg_30_0.overlayCount = arg_30_0.overlayCount - 1
						arg_30_0.overlayCount = math.max(0, arg_30_0.overlayCount)

						table.remove(arg_30_0.lifeRounds, iter_30_0)
					end
				end
			end

			if var_30_4 - arg_30_0.overlayCount > 0 then
				arg_30_0:refreshLerpValue(true)

				if arg_30_0.isShow then
					local var_30_5 = arg_30_0:getBuffEffectAniArgs()

					battleEasy.deferNotifyCantJump(arg_30_0.holder.view, "playBuffAniEffect", var_30_5)
				end
			end
		end

		arg_30_0.nodeManager:update(var_30_3)
	end

	if arg_30_0.weatherCfgId then
		battleEasy.deferNotifyCantJump(arg_30_0.holder.view, "weatherRefresh", arg_30_0)
	end
end

function var_0_0.update(arg_31_0, arg_31_1)
	if arg_31_0.isOver then
		return
	end

	local var_31_0 = arg_31_0.scene.play.battleRoundTriggerId

	if var_31_0 and gExtraRoundTrigger[var_31_0] and gExtraRoundTrigger[var_31_0].forbiddenBuff[arg_31_1] then
		return
	end

	arg_31_0:triggerBuffValueByNode(arg_31_1)
	arg_31_0:fillTriggerEnv(arg_31_1)

	if not arg_31_0.holder then
		arg_31_0:overClean()

		return
	end

	if arg_31_0.holder:isDeath() and arg_31_0.nodeManager:isNoDeathTrigger() and not arg_31_0.csvCfg.noDelWhenFakeDeath then
		arg_31_0:over()

		return
	end

	if arg_31_0.isAuraType and arg_31_0.caster:isDeath() then
		arg_31_0:overClean()

		return
	end

	if var_0_5(arg_31_0.csvCfg.lifeRoundType, arg_31_1, arg_31_0.csvCfg.lifeTimeEnd) then
		arg_31_0:setLeftRound(arg_31_1)
	end

	if arg_31_0.nodeManager:isNode0TriggerPoint(arg_31_1) and not arg_31_0.scene.buffGlobalManager:checkBuffCanAdd(arg_31_0, arg_31_0.holder) then
		arg_31_0:overClean()

		return
	end

	if arg_31_0:isSpecBuff() and arg_31_1 == battle.BuffTriggerPoint.onBuffTrigger then
		if not arg_31_0.scene.buffGlobalManager:checkBuffCanAdd(arg_31_0, arg_31_0.holder) then
			arg_31_0:overClean()

			return
		end

		arg_31_0.scene.buffGlobalManager:refreshBuffLimit(arg_31_0.scene, arg_31_0)
	end

	arg_31_0:triggerByMoment(arg_31_1)
end

function var_0_0.isTrigger(arg_32_0, arg_32_1, arg_32_2)
	if var_0_3[arg_32_1] then
		local var_32_0 = arg_32_0.nodeManager:getExtraAttack(arg_32_1)
		local var_32_1 = true

		if arg_32_0.scene:beInExtraAttack() then
			var_32_1 = var_32_0[2] or var_32_0[3]
		else
			var_32_1 = not var_32_0[3]
		end

		if not var_32_1 then
			return false
		end
	end

	if arg_32_1 == battle.BuffTriggerPoint.onBuffTrigger then
		local var_32_2 = arg_32_0.id == arg_32_2.buffId

		if var_32_2 then
			arg_32_0.scene.buffGlobalManager:recordBuffTriggerType(arg_32_0.holder.id, arg_32_0.csvCfg.easyEffectFunc)
		end

		if not var_32_2 and var_0_2[arg_32_2.easyEffectFunc] and arg_32_0.nodeManager:isTriggerPointExist(arg_32_1) and arg_32_2.checkEffectFunc == arg_32_0.csvCfg.easyEffectFunc and arg_32_2.isFirstTrigger then
			return true
		end

		return var_32_2
	elseif arg_32_1 == battle.BuffTriggerPoint.onHolderBattleTurnStart or arg_32_1 == battle.BuffTriggerPoint.onHolderBattleTurnEnd or arg_32_1 == battle.BuffTriggerPoint.onRoundStart or arg_32_1 == battle.BuffTriggerPoint.onRoundEnd then
		return true
	end

	return arg_32_0.nodeManager:isTriggerPointExist(arg_32_1)
end

function var_0_0.isSpecBuff(arg_33_0)
	return var_0_1[arg_33_0.csvCfg.easyEffectFunc] or false
end

function var_0_0.refresh(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0.overlayType

	arg_34_2 = arg_34_1.overlayCount or arg_34_2 or 0

	if var_34_0 == nil then
		return
	end

	if (var_34_0 == battle.BuffOverlayType.Overlay or var_34_0 == battle.BuffOverlayType.CoexistLifeRound) and arg_34_0:getOverLayCount() == arg_34_0.csvCfg.overlayLimit and arg_34_2 >= 0 then
		arg_34_0.lifeRound = arg_34_1.lifeRound

		return
	end

	if arg_34_2 > 0 and (var_34_0 == battle.BuffOverlayType.Overlay or var_34_0 == battle.BuffOverlayType.OverlayDrop or var_34_0 == battle.BuffOverlayType.CoexistLifeRound) then
		arg_34_0.lifeRound = arg_34_1.lifeRound
	end

	if var_34_0 == battle.BuffOverlayType.Overlay or var_34_0 == battle.BuffOverlayType.OverlayDrop or var_34_0 == battle.BuffOverlayType.CoexistLifeRound or var_34_0 == battle.BuffOverlayType.IndeLifeRound then
		arg_34_0.overlayCount = cc.clampf(arg_34_0.overlayCount + arg_34_2, 1, arg_34_0.csvCfg.overlayLimit)

		if arg_34_0.isNumberType then
			if var_34_0 == battle.BuffOverlayType.IndeLifeRound then
				table.insert(arg_34_0.lifeRounds, arg_34_0.lifeRound)
			elseif var_34_0 == battle.BuffOverlayType.Overlay then
				arg_34_0.buffValue = clone(arg_34_0:cfg2Value(arg_34_1.value))
			end

			arg_34_0:refreshLerpValue()
		end

		if arg_34_0.isShow then
			local var_34_1 = arg_34_0:getBuffEffectAniArgs()

			arg_34_0.isOnceEffectPlayed = true

			if var_34_0 == battle.BuffOverlayType.Overlay or var_34_0 == battle.BuffOverlayType.OverlayDrop then
				battleEasy.deferNotifyCantJump(arg_34_0.holder.view, "playBuffAniEffect", var_34_1)
			end
		end
	end
end

function var_0_0.triggerPrecheck(arg_35_0)
	if table.get(arg_35_0, "objThatTriggeringMeNow", "source") == tostring(arg_35_0) then
		return false
	end

	return true
end

function var_0_0.triggerByNode(arg_36_0, arg_36_1)
	if arg_36_0:triggerPrecheck() and arg_36_0.nodeManager:check(arg_36_1) then
		arg_36_0:takeEffect(arg_36_1)
	end
end

function var_0_0.triggerBuffValueByNode(arg_37_0, arg_37_1)
	arg_37_0.nodeManager:visitNodeByPoint(arg_37_1, function(arg_38_0, arg_38_1)
		if arg_38_1.buffValueUpdatePoint and arg_38_1.buffValueUpdatePoint == arg_37_1 then
			if arg_37_0.args.buffValueFormulaEnv then
				arg_37_0.buffValue = clone(battleCsv.doFormula(arg_37_0.args.buffValueFormula, arg_37_0.args.buffValueFormulaEnv)) or arg_37_0.buffValue
			else
				arg_37_0.buffValue = clone(arg_37_0:cfg2Value(arg_37_0.args.buffValueFormula)) or arg_37_0.buffValue
			end
		end
	end)
end

function var_0_0.triggerByMoment(arg_39_0, arg_39_1)
	if not arg_39_0:triggerPrecheck() then
		return
	end

	arg_39_0.nodeManager:visitNodeByPoint(arg_39_1, function(arg_40_0, arg_40_1)
		arg_39_0:triggerByNode(arg_40_0)
	end)
end

local function var_0_7(arg_41_0)
	table.sort(arg_41_0, function(arg_42_0, arg_42_1)
		return arg_42_0.pro > arg_42_1.pro
	end)

	local var_41_0 = table.length(arg_41_0)

	for iter_41_0 = 1, var_41_0 do
		for iter_41_1 = iter_41_0 + 1, var_41_0 do
			if arg_41_0[iter_41_0].pro == arg_41_0[iter_41_1].pro then
				table.insert(arg_41_0[iter_41_0].buff.bondToOtherBuffsTb, arg_41_0[iter_41_1].buff)
				table.insert(arg_41_0[iter_41_1].buff.bondToOtherBuffsTb, arg_41_0[iter_41_0].buff)
			end

			if math.floor(arg_41_0[iter_41_0].pro) - math.floor(arg_41_0[iter_41_1].pro) == 1 then
				table.insert(arg_41_0[iter_41_0].buff.bondChildBuffsTb, arg_41_0[iter_41_1].buff)
			end
		end
	end
end

function var_0_0.takeEffect(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.nodeManager:trigger(arg_43_1)
	local var_43_1

	if arg_43_1 == battle.BuffTriggerPoint.onNodeCall then
		if arg_43_0.csvCfg.easyEffectFunc then
			arg_43_0.value = arg_43_0:getValue()
			arg_43_0.doEffectValue = clone(arg_43_0.value)
			var_43_1 = arg_43_0:doEffect(arg_43_0.csvCfg.easyEffectFunc, arg_43_0.value)
		end
	else
		arg_43_0.castBuffGroup:push_back({})

		for iter_43_0, iter_43_1 in ipairs(var_43_0.effectFuncs or {}) do
			local var_43_2 = arg_43_0:cfg2ValueWithTrigger(var_43_0.funcArgs[iter_43_0])
			local var_43_3 = iter_43_1 == "addAttr" and "addAttrNode" or iter_43_1

			var_43_2.originArgs = var_43_0.funcArgs[iter_43_0]
			var_43_1 = arg_43_0:doEffect(var_43_3, var_43_2)
		end

		for iter_43_2, iter_43_3 in pairs(arg_43_0.castBuffGroup:back()) do
			var_0_7(iter_43_3)
		end

		arg_43_0.castBuffGroup:pop_back()
	end

	logf.battle.buff.takeEffect("buff takeEffect !!! id=%s cfgId=%s groupid=%s holder=%s originValue=%s value=%s", arg_43_0.id, arg_43_0.cfgId, arg_43_0.csvCfg.group, arg_43_0.holder.seat, arg_43_0.buffValue, arg_43_0.value)
	logf.battle.buff.value("buff value !!! csv=%s buffValue=%s ", arg_43_0.args.value, arg_43_0.value)

	arg_43_0.isEffect = true

	arg_43_0.nodeManager:onTriggerEnd(arg_43_1, var_43_1)

	if arg_43_0.csvCfg.showExplorer then
		local var_43_4 = arg_43_0.csvCfg.explorerID
		local var_43_5 = csv.explorer.explorer[var_43_4].simpleIcon

		battleEasy.queueNotify("queueExplorer", arg_43_0.caster.faceTo, var_43_5)
	end

	if arg_43_0.csvCfg.showHeldItem then
		local var_43_6 = arg_43_0.csvCfg.heldItemID

		battleEasy.deferNotifyCantJump(arg_43_0.caster.view, "showHeldItemEffect", var_43_6)
	end
end

function var_0_0.onSkillType(arg_44_0, arg_44_1)
	local var_44_0 = (arg_44_1 > 0 and arg_44_0.holder or arg_44_0.caster).curSkill

	arg_44_1 = math.abs(arg_44_1)

	if not var_44_0 then
		errorInWindows("onSkillType in %s curSkill is nil", arg_44_0:toHumanString())

		return false
	end

	if var_44_0.skillType == battle.SkillType.NormalSkill then
		if arg_44_1 == 1 and var_44_0.skillType2 == battle.MainSkillType.BigSkill then
			return true
		elseif arg_44_1 == 2 and var_44_0.skillType2 == battle.MainSkillType.SmallSkill then
			return true
		elseif arg_44_1 == 3 and var_44_0.skillType2 == battle.MainSkillType.NormalSkill then
			return true
		elseif arg_44_1 == 4 then
			return true
		elseif arg_44_1 == 5 and var_44_0.skillType2 ~= battle.MainSkillType.BigSkill then
			return true
		end
	end

	return false
end

function var_0_0.onCurHP(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = false
	local var_45_1 = math.floor(arg_45_0.holder:hp())

	if arg_45_1 == 1 then
		local var_45_2 = math.floor(arg_45_0.holder:hpMax() * arg_45_2)

		if var_45_1 == var_45_2 then
			return true
		end

		if var_45_1 < var_45_2 then
			var_45_0 = true
		end
	elseif arg_45_1 == 2 then
		if var_45_1 == arg_45_2 then
			return true
		end

		if var_45_1 < arg_45_2 then
			var_45_0 = true
		end
	end

	if arg_45_3 == 1 then
		var_45_0 = not var_45_0
	end

	return var_45_0
end

function var_0_0.onSkillDamage(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = false
	local var_46_1
	local var_46_2 = arg_46_0.holder.curAttackMeObj

	if var_46_2 and var_46_2.curSkill then
		local var_46_3 = var_46_2.curSkill:getTargetsFinalResult(arg_46_0.holder.id)

		var_46_1 = var_46_3.damage.real:get(battle.ValueType.normal) - var_46_3.resumeHp.real:get(battle.ValueType.normal)
	end

	if not var_46_1 then
		return var_46_0
	end

	local var_46_4 = math.floor(math.abs(var_46_1))

	if arg_46_1 == 1 then
		local var_46_5 = math.floor(arg_46_0.holder:hpMax() * arg_46_2)

		if var_46_4 == var_46_5 then
			return true
		end

		if var_46_4 < var_46_5 then
			var_46_0 = true
		end
	elseif arg_46_1 == 2 then
		if var_46_4 == arg_46_2 then
			return true
		end

		if var_46_4 < arg_46_2 then
			var_46_0 = true
		end
	end

	if arg_46_3 == 1 then
		var_46_0 = not var_46_0
	end

	return var_46_0
end

function var_0_0.onSomeFlag(arg_47_0, arg_47_1)
	local var_47_0 = true

	for iter_47_0, iter_47_1 in ipairs(arg_47_1) do
		var_47_0 = var_47_0 and arg_47_0:cfg2ValueWithTrigger(iter_47_1)
	end

	return var_47_0
end

function var_0_0.getObjectsByCfg(arg_48_0, arg_48_1)
	local var_48_0 = {
		left = {
			{
				x = 2,
				y = 1
			},
			{
				x = 2,
				y = 2
			},
			{
				x = 2,
				y = 3
			},
			{
				x = 1,
				y = 1
			},
			{
				x = 1,
				y = 2
			},
			{
				x = 1,
				y = 3
			}
		},
		right = {
			[7] = {
				x = 1,
				y = 1
			},
			[8] = {
				x = 1,
				y = 2
			},
			[9] = {
				x = 1,
				y = 3
			},
			[10] = {
				x = 2,
				y = 1
			},
			[11] = {
				x = 2,
				y = 2
			},
			[12] = {
				x = 2,
				y = 3
			}
		}
	}
	local var_48_1 = {
		left = {
			{
				4,
				5,
				6
			},
			{
				1,
				2,
				3
			}
		},
		right = {
			{
				7,
				8,
				9
			},
			{
				10,
				11,
				12
			}
		}
	}
	local var_48_2 = {
		{
			0,
			1
		},
		{
			1,
			0
		},
		{
			0,
			-1
		},
		{
			-1,
			0
		}
	}

	local function var_48_3(arg_49_0)
		local var_49_0 = arg_48_0.scene:getHerosMap(arg_49_0.force)
		local var_49_1 = {}

		for iter_49_0, iter_49_1 in var_49_0:order_pairs() do
			if iter_49_1 and not iter_49_1:isDeath() then
				table.insert(var_49_1, iter_49_1)
			end
		end

		return var_49_1
	end

	local function var_48_4(arg_50_0)
		local var_50_0 = arg_48_0.scene:getHerosMap(3 - arg_50_0.force)
		local var_50_1 = {}

		for iter_50_0, iter_50_1 in var_50_0:order_pairs() do
			if iter_50_1 and not iter_50_1:isDeath() then
				table.insert(var_50_1, iter_50_1)
			end
		end

		return var_50_1
	end

	local function var_48_5(arg_51_0, arg_51_1)
		local var_51_0 = arg_51_0.force == 1 and var_48_0.left or var_48_0.right
		local var_51_1 = arg_51_0.force == 1 and var_48_1.left or var_48_1.right
		local var_51_2 = var_51_0[arg_51_0.seat]
		local var_51_3 = {}

		for iter_51_0, iter_51_1 in ipairs(var_48_2) do
			local var_51_4 = iter_51_1[1] + var_51_2.x
			local var_51_5 = iter_51_1[2] + var_51_2.y

			if var_51_4 > 0 and var_51_4 <= 2 and var_51_5 > 0 and var_51_5 <= 3 then
				var_51_3[var_51_1[var_51_4][var_51_5]] = true
			end
		end

		return arraytools.filter(arg_51_1, function(arg_52_0, arg_52_1)
			return var_51_3[arg_52_1.seat]
		end)
	end

	local function var_48_6(arg_53_0)
		if table.length(arg_53_0) > 0 then
			return ymrand.random(1, table.length(arg_53_0))
		end
	end

	local var_48_7 = type(arg_48_1)

	if var_48_7 == "number" then
		if arg_48_1 == battle.BuffExtraTargetType.holder then
			return {
				arg_48_0.holder
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.caster then
			return {
				arg_48_0.caster
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.holderForceNoDeathRandom then
			local var_48_8 = var_48_3(arg_48_0.holder)
			local var_48_9 = var_48_6(var_48_8)

			return {
				var_48_8[var_48_9]
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.surroundHolderNoDath then
			return var_48_5(arg_48_0.holder, var_48_3(arg_48_0.holder))
		elseif arg_48_1 == battle.BuffExtraTargetType.holderForce then
			return var_48_3(arg_48_0.holder)
		elseif arg_48_1 == battle.BuffExtraTargetType.casterForceNoDeathRandom then
			local var_48_10 = var_48_3(arg_48_0.caster)
			local var_48_11 = var_48_6(var_48_10)

			return {
				var_48_10[var_48_11]
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.surroundCasterNoDath then
			return var_48_5(arg_48_0.caster, var_48_3(arg_48_0.caster))
		elseif arg_48_1 == battle.BuffExtraTargetType.casterForce then
			return var_48_3(arg_48_0.caster)
		elseif arg_48_1 == battle.BuffExtraTargetType.holderEnemyForce then
			return var_48_4(arg_48_0.holder)
		elseif arg_48_1 == battle.BuffExtraTargetType.casterEnemyForce then
			return var_48_4(arg_48_0.caster)
		elseif arg_48_1 == battle.BuffExtraTargetType.skillOwner then
			return {
				arg_48_0.objThatTriggeringMeNow.owner
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.killHolder then
			return {
				arg_48_0.holder.attackMeDeadObj
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.casterEnemyForceRandom then
			local var_48_12 = var_48_4(arg_48_0.caster)
			local var_48_13 = var_48_6(var_48_12)

			return {
				var_48_12[var_48_13]
			}
		elseif arg_48_1 == battle.BuffExtraTargetType.surroundHolderKill then
			return var_48_5(arg_48_0.objThatTriggeringMeNow, var_48_3(arg_48_0.objThatTriggeringMeNow))
		elseif arg_48_1 == battle.BuffExtraTargetType.triggerObject then
			return {
				arg_48_0.objThatTriggeringMeNow.obj
			}
		else
			return arg_48_0.extraTargets[arg_48_1]
		end
	elseif var_48_7 == "table" then
		if arg_48_1.input and arg_48_1.process then
			return (newTargetFinder(arg_48_0.caster, arg_48_0.holder, nil, nil, arg_48_1))
		end
	else
		return arg_48_0:cfg2ValueWithTrigger(arg_48_1)
	end
end

function var_0_0.refreshExtraTargets(arg_54_0, arg_54_1, arg_54_2)
	arg_54_0.extraTargets[arg_54_1] = arg_54_2
end

local var_0_8 = {
	[battle.BuffTriggerPoint.onHolderAttackBefore] = true,
	[battle.BuffTriggerPoint.onHolderBeforeBeHit] = true,
	[battle.BuffTriggerPoint.onHolderAfterBeHit] = true,
	[battle.BuffTriggerPoint.onHolderFinallyBeHit] = true,
	[battle.BuffTriggerPoint.onHolderAttackEnd] = true,
	[battle.BuffTriggerPoint.onHolderKillHandleChooseTarget] = true,
	[battle.BuffTriggerPoint.onHolderKillTarget] = true,
	[battle.BuffTriggerPoint.onHolderMateKilledBySkill] = true
}

function var_0_0.fillTriggerEnv(arg_55_0, arg_55_1)
	arg_55_0.triggerEnv = {}

	if var_0_8[arg_55_1] then
		arg_55_0.triggerEnv.skill = battleCsv.CsvSkill.new(arg_55_0.objThatTriggeringMeNow)
	elseif arg_55_1 == battle.BuffTriggerPoint.onBuffBeAdd then
		arg_55_0.triggerEnv.beAddBuff = battleCsv.CsvBuff.new(arg_55_0.objThatTriggeringMeNow)
	else
		arg_55_0.triggerEnv = arg_55_0.objThatTriggeringMeNow or arg_55_0.triggerEnv
	end
end

function var_0_0.playTriggerPointEffect(arg_56_0)
	if arg_56_0.isOver then
		return
	end

	if arg_56_0.csvCfg and not arg_56_0.csvCfg.buffActionEffect then
		return
	end

	if arg_56_0.csvCfg.buffActionEffect and not arg_56_0.csvCfg.buffActionEffect.triggerEffect then
		return
	end

	local var_56_0 = csvClone(arg_56_0.csvCfg.buffActionEffect.triggerEffect)

	if var_56_0.onceEffectResPath then
		var_56_0.onceEffectPos = var_56_0.onceEffectPos or 0
		var_56_0.onceEffectOffsetPos = var_56_0.onceEffectOffsetPos or cc.p(0, 0)
	end

	local var_56_1 = arg_56_0:getBuffEffectAniArgs()

	var_56_1.csvCfg = var_56_0

	battleEasy.deferNotifyCantJump(arg_56_0.holder.view, "playBuffAniEffect", var_56_1)

	if var_56_0.showHeldItem then
		local var_56_2 = var_56_0.heldItemID

		battleEasy.deferNotifyCantJump(arg_56_0.holder.view, "showHeldItemEffect", var_56_2)
	end
end

function var_0_0.getLifeRound(arg_57_0)
	return arg_57_0.lifeRound
end

function var_0_0.getValue(arg_58_0)
	if not arg_58_0.buffValue then
		return
	end

	if arg_58_0.isNumberType then
		local var_58_0 = arg_58_0.buffInitEnhanceVal or 0
		local var_58_1 = arg_58_0.holder:getBuffEnhance(arg_58_0:group(), 2)
		local var_58_2 = arg_58_0.buffValue * math.max(var_58_0 + var_58_1 + 1, 0)

		if arg_58_0.overlayType == battle.BuffOverlayType.Overlay or arg_58_0.overlayType == battle.BuffOverlayType.OverlayDrop then
			var_58_2 = var_58_2 * arg_58_0:getOverLayCount()
		elseif arg_58_0.overlayType == battle.BuffOverlayType.IndeLifeRound then
			local var_58_3 = itertools.filter(arg_58_0.lifeRounds, function(arg_59_0, arg_59_1)
				return arg_59_1 > 0
			end)

			var_58_2 = var_58_2 * (1 + table.length(var_58_3))
		end

		return var_58_2
	end

	return arg_58_0.value or clone(arg_58_0.buffValue)
end

function var_0_0.setValue(arg_60_0, arg_60_1)
	arg_60_0.buffValue = arg_60_1
	arg_60_0.value = arg_60_0:getValue()
	arg_60_0.isNumberType = type(arg_60_0.buffValue) == "number"
end

function var_0_0.refreshLerpValue(arg_61_0, arg_61_1)
	if not arg_61_0.isNumberType then
		return
	end

	if arg_61_0.csvCfg.easyEffectFunc and arg_61_0.nodeManager:isNode0TriggerPoint(battle.BuffTriggerPoint.onBuffCreate) then
		local var_61_0 = arg_61_0.doEffectValue

		arg_61_0.value = arg_61_0:getValue()

		local var_61_1 = arg_61_0.value - var_61_0

		arg_61_0.doEffectValue = arg_61_0.value

		arg_61_0:doEffect(arg_61_0.csvCfg.easyEffectFunc, var_61_1, arg_61_1)
	end
end

function var_0_0.playBuffProcessView(arg_62_0)
	local var_62_0 = arg_62_0.isOver

	if arg_62_0.csvCfg.buffActionEffect then
		for iter_62_0, iter_62_1 in csvMapPairs(arg_62_0.csvCfg.buffActionEffect) do
			if var_62_0 then
				arg_62_0.holder.scene:addObjViewToBattleTurn(arg_62_0.holder, "PopAction", battle.SpriteActionTable[iter_62_0] or iter_62_0, arg_62_0.id)
			else
				arg_62_0.holder.scene:addObjViewToBattleTurn(arg_62_0.holder, "PushAction", battle.SpriteActionTable[iter_62_0] or iter_62_0, iter_62_1, arg_62_0.id)
			end
		end

		arg_62_0.holder.scene:addObjViewToBattleTurn(arg_62_0.holder, "PlayState", battle.SpriteActionTable.standby)
	end
end

function var_0_0.checkBuffCanAdd(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	if not arg_63_0.isInited then
		return true
	end

	local var_63_0 = true
	local var_63_1 = gBuffGroupRelationCsv[arg_63_0:group()]

	if var_63_1 then
		if battleCsv.hasBuffGroup(var_63_1.immuneGroup, arg_63_2) and arg_63_3.beImmune == 1 then
			var_63_0 = false
		end

		if csvSize(var_63_1.powerGroup) > 0 and not battleCsv.hasBuffGroup(var_63_1.powerGroup, arg_63_2) then
			return false
		end
	end

	local var_63_2 = arg_63_0.csvCfg.immuneBuff

	if var_63_2 and arg_63_3.beImmune == 1 then
		for iter_63_0, iter_63_1 in ipairs(var_63_2) do
			if arg_63_1 == iter_63_1 then
				var_63_0 = false

				break
			end
		end
	end

	if not var_63_0 then
		battleEasy.deferNotifyCantJump(arg_63_0.holder.view, "showBuffImmuneEffect", arg_63_2)
		arg_63_0:triggerByMoment(battle.BuffTriggerPoint.onBuffTrigger, {
			buffId = arg_63_0.id
		})
	end

	return var_63_0
end

function var_0_0.group(arg_64_0)
	local var_64_0 = arg_64_0.csvCfg.group
	local var_64_1 = arg_64_0.scene:getConvertGroupCache()

	if var_64_1 and var_64_1.assignGroup[var_64_0] then
		return var_64_1.convertGroup
	end

	return var_64_0
end

function var_0_0.addExRecord(arg_65_0, arg_65_1, arg_65_2)
	arg_65_0.scene.extraRecord:addExRecord(arg_65_1, arg_65_2, arg_65_0.id)

	arg_65_0.exRecordNameTb[arg_65_1] = true
end

function var_0_0.getEventByKey(arg_66_0, arg_66_1)
	return arg_66_0.scene.extraRecord:getEventByKey(arg_66_1, arg_66_0.id)
end

function var_0_0.getOverLayCount(arg_67_0)
	if arg_67_0.overlayType == battle.BuffOverlayType.Coexist or arg_67_0.overlayType == battle.BuffOverlayType.CoexistLifeRound then
		return arg_67_0.holder.buffOverlayCount[arg_67_0.cfgId]
	end

	return arg_67_0.overlayCount
end

function var_0_0.BeDispel(arg_68_0, arg_68_1)
	if arg_68_1 then
		return arg_68_0:over({
			endType = battle.BuffOverType.dispel
		})
	end

	if arg_68_0.overlayType == battle.BuffOverlayType.Overlay or arg_68_0.overlayType == battle.BuffOverlayType.OverlayDrop then
		if arg_68_0.overlayCount == 1 then
			return arg_68_0:over({
				endType = battle.BuffOverType.dispel
			})
		end

		arg_68_0:refresh(arg_68_0.args, -1)
	end
end

function var_0_0.getEffectAniSelectId(arg_69_0)
	local var_69_0 = arg_69_0.csvCfg

	if var_69_0.effectAniChoose.type == battle.BuffEffectAniType.OverlayCount then
		return var_69_0.effectAniChoose.mapping[arg_69_0:getOverLayCount()]
	end

	return 1
end

function var_0_0.getBuffEffectAniArgs(arg_70_0)
	local var_70_0 = false
	local var_70_1 = arg_70_0.holder.scene.play.curHero

	if var_70_1 then
		var_70_0 = var_70_1.id == arg_70_0.holder.id
	end

	return {
		aniSelectId = arg_70_0:getEffectAniSelectId(),
		id = arg_70_0.id,
		cfgId = arg_70_0.cfgId,
		overlayCount = arg_70_0:getOverLayCount(),
		csvCfg = arg_70_0.csvCfg,
		tostrModel = tostring(arg_70_0.holder),
		tostrCaster = tostring(arg_70_0.caster),
		isSelfTurn = var_70_0,
		isOnceEffectPlayed = arg_70_0.isOnceEffectPlayed,
		args = arg_70_0.args
	}
end

function var_0_0.updateWithTrigger(arg_71_0, arg_71_1, arg_71_2)
	arg_71_0.objThatTriggeringMeNow = arg_71_2

	arg_71_0:update(arg_71_1)
end

function var_0_0.onTriggerEvent(arg_72_0, arg_72_1)
	local var_72_0 = arg_72_1.name
	local var_72_1 = arg_72_1.args

	if arg_72_0:isTrigger(var_72_0, var_72_1) then
		arg_72_0:updateWithTrigger(var_72_0, var_72_1)
	end
end

function var_0_0.setCsvObject(arg_73_0, arg_73_1)
	arg_73_0.csvObject = arg_73_1
end

function var_0_0.getCsvObject(arg_74_0)
	return arg_74_0.csvObject
end

function var_0_0.toHumanString(arg_75_0)
	return string.format("BuffModel: %s(%s)", arg_75_0.id, arg_75_0.cfgId)
end
