local var_0_0 = math.max
local var_0_1 = math.min
local var_0_2 = table.insert
local var_0_3 = battle.PassiveSkillTypes
local var_0_4 = class("Skill")

battleSkill.SkillModel = var_0_4

function var_0_4.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0.scene = arg_1_1
	arg_1_0.owner = arg_1_2
	arg_1_0.id = arg_1_3.id
	arg_1_0.level = arg_1_4 or 1
	arg_1_0.cfg = arg_1_3
	arg_1_0.chargeArgs = arg_1_3.chargeArgs
	arg_1_0.source = arg_1_5
	arg_1_0.checkRoundAttackTime = -1
	arg_1_0.chargeRound = nil
	arg_1_0.spellRound = -99
	arg_1_0.isSpellable = false
	arg_1_0.targetsFormulaResult = {}
	arg_1_0.allTargets = {}
	arg_1_0.allDamageTargets = {}
	arg_1_0.protecterObjs = {}
	arg_1_0.allProcessesTargets = {}
	arg_1_0.stateInfoTb = {}
	arg_1_0.targetsFinalResult = {}
	arg_1_0.targetsProcessResult = {}
	arg_1_0.skillType = arg_1_3.skillType
	arg_1_0.skillType2 = arg_1_3.skillType2
	arg_1_0.skillFormulaType = nil
	arg_1_0.killedTargetsTb = {}
	arg_1_0.canjumpBigSkill = false
	arg_1_0.type = arg_1_3.passiveTriggerType
	arg_1_0.disposeDatasOnSkillStart = {}
	arg_1_0.disposeDatasOnSkillEnd = {}
	arg_1_0.disposeDatasAfterComeBack = {}
	arg_1_0.skillCalDamageProcessId = arg_1_0.cfg.skillCalDamageProcessId
	arg_1_0.processes = {}
	arg_1_0.realProcess = {}
	arg_1_0.processEventCsv = {}
	arg_1_0.actionSegArgs = {}
	arg_1_0.isSpellTo = false
	arg_1_0.counterAttackForView = false

	local var_1_0 = false

	local function var_1_1(arg_2_0)
		local var_2_0 = arg_2_0.otherEventIDs

		if var_2_0 then
			for iter_2_0, iter_2_1 in ipairs(var_2_0) do
				if csv.effect_event[gEffectByEventCsv[iter_2_1]].jumpFlag then
					return true
				end
			end
		end

		return false
	end

	local var_1_2
	local var_1_3

	for iter_1_0, iter_1_1 in ipairs(arg_1_3.skillProcess) do
		local var_1_4 = csvClone(csv.skill_process[iter_1_1])

		if var_1_4 == nil then
			printDebug("技能id: %d 过程段id: %d 缺失!!!!!!", arg_1_0.id, iter_1_1)
		end

		var_0_2(arg_1_0.processes, var_1_4)

		local var_1_5 = gProcessEventCsv and gProcessEventCsv[iter_1_1] or nil

		if var_1_5 and (var_1_5.jumpFlag or var_1_1(var_1_5)) then
			var_1_0 = true
		end

		var_1_4.isSegProcess = var_1_5 and var_1_5.segInterval and true or false
		var_1_4.segType = battle.SkillSegType.buff

		if var_1_4.isSegProcess then
			var_1_4.segType = var_1_5.damageSeg and battle.SkillSegType.damage or battle.SkillSegType.resumeHp
		end

		arg_1_0.processEventCsv[iter_1_1] = var_1_5
	end

	arg_1_0.canJump = var_1_0

	for iter_1_2, iter_1_3 in ipairs(battle.SkillAttrsInCsv) do
		arg_1_0[iter_1_3] = arg_1_0.cfg[iter_1_3] or 0
	end

	arg_1_0.costMp1 = arg_1_0.cfg.costMp1 / 1000

	arg_1_0:initSkillType()

	arg_1_0.protectedEnv = battleCsv.makeProtectedEnv(arg_1_0.owner, arg_1_0)

	arg_1_0:initSkillAttrValue()
end

function var_0_4.updateStateInfoTb(arg_3_0)
	local var_3_0 = arg_3_0.owner:mp1() / arg_3_0.owner:mp1Max() * arg_3_0.costMp1
	local var_3_1 = math.max(arg_3_0.startRound - arg_3_0.owner:getBattleRound(2), 0)

	arg_3_0.stateInfoTb = {
		canSpell = arg_3_0:canSpell(),
		leftCd = arg_3_0:getLeftCDRound(),
		leftStartRound = var_3_1,
		precent = arg_3_0.costMp1 == 0 and 1 or math.min(var_3_0, 1),
		level = arg_3_0:getLevel()
	}
end

function var_0_4.initSkillAttrValue(arg_4_0)
	for iter_4_0, iter_4_1 in ipairs(battle.SkillAttrsInCsv) do
		arg_4_0[iter_4_1 .. "Attr"] = function(arg_5_0)
			error(string.format("%s Attr in SkillModel was deprecated", iter_4_1))

			return arg_5_0.cfg[iter_4_1]
		end
	end
end

function var_0_4.getLevel(arg_6_0)
	return var_0_0(arg_6_0.owner:dealOpenValueByKey("skillLevel" .. arg_6_0.skillType2, arg_6_0.level), 1)
end

function var_0_4.resetOnNewRound(arg_7_0)
	arg_7_0.counterAttackForView = false
	arg_7_0.checkRoundAttackTime = -1
	arg_7_0.isSpellable = false
end

function var_0_4.resetOnNewWave(arg_8_0)
	if arg_8_0.chargeRound then
		battleEasy.queueNotifyFor(arg_8_0.owner.view, "playCharge", {}, true)
	end

	arg_8_0.checkRoundAttackTime = -1
	arg_8_0.chargeRound = nil
	arg_8_0.spellRound = -99
	arg_8_0.isSpellable = false
end

function var_0_4._canSpell(arg_9_0)
	logf.battle.skill.canSpellSkillId(" canSpell skillId = %d, ownerId = %d", arg_9_0.id, arg_9_0.owner.seat)

	local var_9_0 = arg_9_0.owner:getBattleRound(2)
	local var_9_1 = arg_9_0.owner.exAttackMode == battle.ExtraAttackMode.combo and arg_9_0.owner.exAttackSkillID == arg_9_0.id

	var_9_1 = var_9_1 or arg_9_0.owner.exAttackArgs and arg_9_0.owner.exAttackArgs.costType == 1

	if arg_9_0.owner:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
		skillType2 = arg_9_0.skillType2,
		skillId = arg_9_0.id
	}) then
		return false, 1
	end

	if var_9_0 < arg_9_0.startRound and (not arg_9_0.scene:beInExtraAttack() or not arg_9_0:isNormalSkillType()) then
		return false, 3
	end

	if arg_9_0:isNormalSkillType() then
		local var_9_2 = arg_9_0:getTargetsHint()
		local var_9_3 = arg_9_0.owner:getSneerObj()

		if var_9_3 and var_9_3:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
			fromObj = arg_9_0.owner
		}) then
			if arg_9_0.owner:isBeInDuel() then
				return false, 4
			else
				var_9_2 = arg_9_0.owner:getCanAttackObjs(var_9_3.force)
			end
		end

		if table.length(var_9_2) == 0 and arg_9_0.cfg.damageFormula and arg_9_0.owner:isBeInConfusion() and (not arg_9_0.owner.exAttackArgs or not arg_9_0.owner.exAttackArgs.isFixedForce) then
			local var_9_4, var_9_5, var_9_6 = arg_9_0.owner:getConfusionCheckInfos()

			if var_9_6 then
				var_9_2 = var_9_4
			else
				var_9_2 = table.length(var_9_4) > 0 and var_9_4 or var_9_5
			end
		end

		if table.length(var_9_2) == 0 then
			return false, 4
		end
	end

	if arg_9_0:isChargeSkill() and arg_9_0:isChargeOK() then
		return true, 5
	end

	if arg_9_0.skillType2 == battle.MainSkillType.BigSkill then
		if var_9_1 then
			return true, 6
		end

		logf.battle.skill.costMp1(" mp1Max=%s, curMp1=%s", arg_9_0.owner:mp1Max(), arg_9_0.owner:mp1())

		local var_9_7 = arg_9_0.owner:mp1() / arg_9_0.owner:mp1Max() >= arg_9_0.costMp1

		if arg_9_0.cdRound == 0 then
			return var_9_7, 7
		elseif not var_9_7 then
			return false, 8
		end
	end

	return var_9_1 or arg_9_0:getLeftCDRound() < 1, 9
end

function var_0_4.canSpell(arg_10_0)
	if arg_10_0.owner.exAttackArgs and arg_10_0.owner.exAttackArgs.skillPowerMap and arg_10_0.owner.exAttackArgs.skillPowerMap[arg_10_0.skillType2 + 1] == 0 then
		return false
	end

	local var_10_0 = arg_10_0.owner:getEventByKey(battle.ExRecordEvent.roundAttackTime)

	if var_10_0 == arg_10_0.checkRoundAttackTime and arg_10_0.skillType2 == battle.MainSkillType.BigSkill then
		return arg_10_0.isSpellable
	end

	arg_10_0.checkRoundAttackTime = var_10_0

	local var_10_1 = 0
	local var_10_2

	arg_10_0.isSpellable, var_10_2 = arg_10_0:_canSpell()

	logf.battle.skill.skillCD(" skillCD: 当前round= %d, 使用时spellRound= %d, cd= %d spellType= %d", var_10_0, arg_10_0.spellRound, arg_10_0.cdRound, var_10_2)

	return arg_10_0.isSpellable
end

function var_0_4.isChargeSkill(arg_11_0)
	return arg_11_0.chargeArgs and arg_11_0.chargeArgs.round > 0
end

function var_0_4.isCharging(arg_12_0)
	local var_12_0 = arg_12_0.owner:getOverlaySpecBuffByIdx("breakCharging")

	if arg_12_0.chargeRound and not var_12_0 then
		return arg_12_0.owner:getBattleRound(2) - arg_12_0.chargeRound < arg_12_0.chargeArgs.round
	end

	return false
end

function var_0_4.isChargeOK(arg_13_0)
	local var_13_0 = arg_13_0.owner:getOverlaySpecBuffByIdx("breakCharging")

	if arg_13_0.chargeRound then
		if var_13_0 then
			return var_13_0.mode == 2
		else
			return arg_13_0.owner:getBattleRound(2) - arg_13_0.chargeRound >= arg_13_0.chargeArgs.round
		end
	end

	return false
end

function var_0_4.cleanData(arg_14_0)
	arg_14_0.targetsFormulaResult = {}
	arg_14_0.targetsFinalResult = {}
	arg_14_0.targetsProcessResult = {}
	arg_14_0.allTargets = {}
	arg_14_0.allDamageTargets = {}
	arg_14_0.protecterObjs = {}
	arg_14_0.allProcessesTargets = {}
	arg_14_0.disposeDatasOnSkillStart = {}
	arg_14_0.disposeDatasOnSkillEnd = {}
	arg_14_0.disposeDatasAfterComeBack = {}
	arg_14_0.killedTargetsTb = {}
	arg_14_0.actionSegArgs = {}
	arg_14_0.realProcess = {}
end

function var_0_4.startCharge(arg_15_0)
	arg_15_0.chargeRound = arg_15_0.owner:getBattleRound(2)
	arg_15_0.lastSpellRound = arg_15_0.spellRound
	arg_15_0.spellRound = arg_15_0.owner:getBattleRound(2)

	arg_15_0:startDeductMp()

	arg_15_0.hadDeductedMp = true

	battleEasy.queueNotifyFor(arg_15_0.owner.view, "playCharge", arg_15_0.chargeArgs.action, false)
end

function var_0_4.endCharge(arg_16_0)
	arg_16_0.chargeRound = nil

	battleEasy.queueNotifyFor(arg_16_0.owner.view, "playCharge", arg_16_0.chargeArgs.action, true)
end

function var_0_4.updateSkillDamageProcessId(arg_17_0)
	local var_17_0 = arg_17_0.cfg.diffSkillCalDmgProcessId

	if var_17_0.exAttackMode then
		arg_17_0.skillCalDamageProcessId = var_17_0.exAttackMode[arg_17_0.owner.exAttackMode] or arg_17_0.cfg.skillCalDamageProcessId
	end
end

function var_0_4.startSpell(arg_18_0)
	arg_18_0.isSpellable = false
	arg_18_0.isSpellTo = true

	if arg_18_0.chargeRound then
		arg_18_0:endCharge()
	elseif arg_18_0.owner.exAttackArgs and arg_18_0.owner.exAttackArgs.costType == 1 then
		if arg_18_0.spellRound < 1 then
			arg_18_0.spellRound = -arg_18_0.cfg.cdRound
		end
	elseif arg_18_0.owner.exAttackSkillID ~= arg_18_0.id then
		arg_18_0.spellRound = arg_18_0.owner:getBattleRound(2)
	end

	arg_18_0:updateSkillDamageProcessId()
end

function var_0_4.isJumpBigSkill(arg_19_0)
	return arg_19_0.skillType2 == battle.MainSkillType.BigSkill and arg_19_0.canJump and userDefault.getForeverLocalKey("mainSkillPass", false)
end

function var_0_4.startDeductMp(arg_20_0, arg_20_1)
	if arg_20_0.hadDeductedMp then
		arg_20_0.hadDeductedMp = false

		return
	end

	if arg_20_0.owner.exAttackArgs and arg_20_0.owner.exAttackArgs.costType == 1 then
		return
	end

	if arg_20_0.skillType2 == battle.MainSkillType.BigSkill then
		local var_20_0 = 1
		local var_20_1 = 1

		if arg_20_0.cfg.costMp1Args then
			arg_20_0.protectedEnv:resetEnv()

			local var_20_2 = battleCsv.fillFuncEnv(arg_20_0.protectedEnv, {})
			local var_20_3 = battleCsv.doFormula(arg_20_0.cfg.costMp1Args, var_20_2)

			var_20_0, var_20_1 = var_20_3[1] or var_20_0, var_20_3[2] or var_20_1
		end

		local var_20_4 = ymrand.random()
		local var_20_5 = arg_20_0.owner:mp1Max() * arg_20_0.costMp1

		if var_20_4 < var_20_0 then
			var_20_5 = var_20_5 * var_20_1
		end

		local var_20_6 = arg_20_0.owner:mp1() - var_20_5

		arg_20_0.owner:setMP1(var_20_6, var_20_6)

		return
	end
end

function var_0_4.ipairsProcess(arg_21_0)
	local var_21_0 = 1

	return function()
		local var_22_0 = arg_21_0.realProcess[var_21_0]
		local var_22_1

		if var_22_0 then
			local var_22_2 = var_21_0

			var_21_0 = var_21_0 + 1

			return var_22_2, arg_21_0.processes[var_22_0]
		end

		return nil
	end
end

function var_0_4.isLastProcess(arg_23_0, arg_23_1)
	return table.length(arg_23_0.realProcess) == arg_23_1
end

function var_0_4.sortRealProcess(arg_24_0)
	local var_24_0 = ymrand.random
	local var_24_1
	local var_24_2
	local var_24_3
	local var_24_4

	arg_24_0.protectedEnv:resetEnv()

	local var_24_5 = battleCsv.fillFuncEnv(arg_24_0.protectedEnv, {
		target = arg_24_0.owner:getCurTarget()
	})

	for iter_24_0, iter_24_1 in ipairs(arg_24_0.processes) do
		local var_24_6 = arg_24_0.processes[iter_24_0]
		local var_24_7 = arg_24_0.processEventCsv[iter_24_1.id]
		local var_24_8 = iter_24_1.extraArgs

		if (var_24_8 and battleCsv.doFormula(var_24_8.prob, var_24_5) or 1) > var_24_0() then
			if var_24_8 then
				arg_24_0.owner:addExRecord(battle.ExRecordEvent.comboProcessTotalNum, 1)
			end

			if var_24_7 and var_24_7.damageSeg then
				if var_24_2 then
					arg_24_0.processes[var_24_2].isLastDmgProcess = false
				end

				iter_24_1.isLastDmgProcess = true
				var_24_2 = iter_24_0
			end

			table.insert(arg_24_0.realProcess, iter_24_0)

			iter_24_1.isLastProcess = table.length(arg_24_0.processes) == iter_24_0
		else
			arg_24_0.owner.view:proxy():saveIgnoreEffect(var_24_6.id, var_24_6.effectEventID)
		end
	end
end

function var_0_4.getProcessArg(arg_25_0, arg_25_1)
	if arg_25_0.realProcess[arg_25_1] then
		return arg_25_0.processes[arg_25_0.realProcess[arg_25_1]]
	end
end

function var_0_4.initSkillType(arg_26_0)
	if arg_26_0.cfg.damageFormula and arg_26_0.cfg.hpFormula then
		arg_26_0.skillFormulaType = battle.SkillFormulaType.fix

		return
	end

	if arg_26_0.cfg.damageFormula then
		arg_26_0.skillFormulaType = battle.SkillFormulaType.damage
	elseif arg_26_0.cfg.hpFormula then
		arg_26_0.skillFormulaType = battle.SkillFormulaType.resumeHp
	end
end

local var_0_5 = {
	[battle.SkillSegType.damage] = battle.SkillFormulaType.damage,
	[battle.SkillSegType.resumeHp] = battle.SkillFormulaType.resumeHp,
	[battle.SkillSegType.buff] = battle.SkillFormulaType.fix
}

local function var_0_6(arg_27_0)
	local var_27_0 = {}

	for iter_27_0, iter_27_1 in ipairs(arg_27_0) do
		if iter_27_1:hp() > 0 then
			var_27_0[iter_27_1.id] = true
		end
	end

	return var_27_0
end

function var_0_4.processBefore(arg_28_0, arg_28_1)
	local var_28_0 = gRootViewProxy:proxy():pushDeferList(arg_28_0.id, "play01")

	arg_28_0:startDeductMp()
	arg_28_0:sortRealProcess()

	local var_28_1 = arg_28_1.skillCfg.skillDamageType
	local var_28_2 = true
	local var_28_3

	arg_28_1.processArgs = {}

	for iter_28_0, iter_28_1 in arg_28_0:ipairsProcess() do
		local var_28_4 = arg_28_0:onProcess(iter_28_1, arg_28_1.target)

		var_28_4.skillId = arg_28_0.id
		var_28_4.values = {}
		var_28_4.index = iter_28_0
		arg_28_1.processArgs[iter_28_0] = var_28_4
		arg_28_0.allProcessesTargets[iter_28_1.id] = var_28_4.targets

		local var_28_5
		local var_28_6 = arg_28_0:getProcessArg(iter_28_0 - 1)

		if iter_28_0 > 1 and var_28_6 and arg_28_0.allProcessesTargets[var_28_6.id] then
			var_28_5 = arg_28_0.allProcessesTargets[var_28_6.id]
		end

		local var_28_7 = {}

		if iter_28_1.effectEventID then
			var_28_7.lifeTime = arg_28_0.cfg.actionTime
			var_28_7.processId = iter_28_1.id

			local var_28_8 = arg_28_0.processEventCsv[iter_28_1.id]
			local var_28_9 = false

			if var_28_8 then
				if var_28_8.effectType == 0 and var_28_8.effectRes then
					arg_28_0.owner.view:proxy():saveEffectInfo(var_28_8.effectRes, iter_28_1.id, iter_28_1.effectEventID)

					var_28_7.spine = var_28_8.effectRes
					var_28_9 = true
				else
					if var_28_2 then
						var_28_7.spine = arg_28_0.cfg.spineAction
						var_28_2 = false
						var_28_9 = true
					end

					arg_28_0.owner.view:proxy():saveEffectInfo(arg_28_0.cfg.spineAction, iter_28_1.id, iter_28_1.effectEventID)
				end
			end

			if var_28_9 then
				table.insert(arg_28_0.actionSegArgs, var_28_7)
			end
		end

		arg_28_0:processAddBuff(iter_28_1, var_28_4.targets, var_28_5, battle.SkillAddBuffType.Before)
	end

	arg_28_1.noMissTargetsArray = arg_28_0:saveAllTargets()

	arg_28_0:saveAllDamageTargets()

	arg_28_1.allDamagedOrder = arg_28_0:targetsMap2Array(arg_28_0.allDamageTargets)

	if next(arg_28_1.allDamagedOrder) then
		for iter_28_2, iter_28_3 in arg_28_0.owner:iterBuffs() do
			iter_28_3:refreshExtraTargets(battle.BuffExtraTargetType.skillAllDamageTargets, arg_28_1.allDamagedOrder)
		end
	end

	arg_28_0.disposeDatasOnSkillStart.skillStartAddBuffsPlayFuncs = gRootViewProxy:proxy():popDeferList(var_28_0)
end

function var_0_4.updateRecord(arg_29_0)
	if arg_29_0.skillType2 == battle.MainSkillType.NormalSkill or arg_29_0.skillType2 == battle.MainSkillType.SmallSkill then
		arg_29_0.owner:addExRecord(battle.ExRecordEvent.spellSkillTotal, 1)
	end

	if arg_29_0:isNormalSkillType() and arg_29_0.owner:beInExtraAttack() and arg_29_0.owner.exAttackMode == battle.ExtraAttackMode.syncAttack then
		arg_29_0.owner:addExRecord(battle.ExRecordEvent.roundSyncAttackTime, 1)
	end

	arg_29_0.owner:addExRecord(arg_29_0.skillType2, 1)
end

function var_0_4.processPlay(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_1.processArgs
	local var_30_1 = arg_30_1.noMissTargetsArray
	local var_30_2 = arg_30_1.allDamagedOrder

	for iter_30_0, iter_30_1 in arg_30_0:ipairsProcess() do
		local var_30_3 = arg_30_0.allProcessesTargets[iter_30_1.id]
		local var_30_4
		local var_30_5 = arg_30_0:getProcessArg(iter_30_0 - 1)

		if iter_30_0 > 1 and var_30_5 and arg_30_0.allProcessesTargets[var_30_5.id] then
			var_30_4 = arg_30_0.allProcessesTargets[var_30_5.id]
		end

		var_30_0[iter_30_0].buffTb = arg_30_0:processAddBuff(iter_30_1, var_30_3, var_30_4, battle.SkillAddBuffType.InPlay)
	end

	local var_30_6 = gRootViewProxy:proxy():pushDeferList(arg_30_0.id, "play02")

	if arg_30_0.scene:beInExtraAttack() and arg_30_0.owner.exAttackMode == battle.ExtraAttackMode.counter and arg_30_0.skillType2 ~= battle.MainSkillType.PassiveSkill then
		arg_30_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderCounterAttack, arg_30_0)
	end

	if arg_30_0:isNormalSkillType() then
		arg_30_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderAttackBefore, arg_30_0)
	end

	for iter_30_2, iter_30_3 in ipairs(var_30_1) do
		if iter_30_3:hp() <= 0 then
			arg_30_0:addObjectToKillTab(iter_30_3)
		end
	end

	arg_30_1.noDeadObjectTb = var_0_6(var_30_1)

	if arg_30_0:isSameType(battle.SkillFormulaType.damage) then
		for iter_30_4, iter_30_5 in ipairs(var_30_2) do
			if arg_30_0:isNormalSkillType() then
				iter_30_5:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderBeforeBeHit, arg_30_0)
			end
		end
	end

	arg_30_0.disposeDatasOnSkillStart.skillStartTriggerBuffsPlayFuncs = gRootViewProxy:proxy():popDeferList(var_30_6)
end

function var_0_4.processTarget(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1.processArgs
	local var_31_1

	if arg_31_0:isNormalSkillType() then
		arg_31_0.scene:updateBeAttackZOrder()
	end

	for iter_31_0, iter_31_1 in arg_31_0:ipairsProcess() do
		local var_31_2 = var_31_0[iter_31_0]
		local var_31_3 = gRootViewProxy:proxy():pushDeferList(arg_31_0.id, iter_31_1.id)
		local var_31_4 = var_31_2.process and var_31_2.process.isLastDmgProcess

		log.battle.skill.spellTo("processCfg.id=", iter_31_1.id)

		local var_31_5 = arg_31_0.processEventCsv[iter_31_1.id]

		arg_31_0:updateTarget(iter_31_1, arg_31_1.target, var_31_2)

		if iter_31_1.isSegProcess then
			if arg_31_0.owner:isBeInSneer() then
				local var_31_6 = var_31_2.process.segType == battle.SkillSegType.damage
				local var_31_7 = arg_31_0.owner:getSneerExtraArgs(not var_31_6)

				if var_31_7 == battle.SneerArgType.NoSpread or var_31_7 == battle.SneerArgType.BuffSpread then
					local var_31_8 = var_31_6 and arg_31_0.owner:getSneerObj() or arg_31_0.owner

					if var_31_8 then
						for iter_31_2 = table.length(var_31_2.targets), 1, -1 do
							if var_31_8.id ~= var_31_2.targets[iter_31_2].id then
								table.remove(var_31_2.targets, iter_31_2)
							end
						end
					end
				end
			end

			if arg_31_0:isNormalSkillType() and not arg_31_0.scene:beInExtraAttack() then
				if arg_31_0:isSameType(battle.SkillFormulaType.damage) then
					for iter_31_3, iter_31_4 in arg_31_0.owner:iterBuffs() do
						iter_31_4:refreshExtraTargets(battle.BuffExtraTargetType.segProcessTargets, var_31_2.targets)
					end
				end

				arg_31_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderAfterRefreshTargets, {
					skill = arg_31_0,
					segType = var_0_5[var_31_2.process.segType]
				})
			end

			for iter_31_5, iter_31_6 in ipairs(var_31_2.targets) do
				arg_31_0:preCalcDamageProb(iter_31_6, var_31_2)
			end

			for iter_31_7, iter_31_8 in ipairs(var_31_5.segInterval) do
				local var_31_9 = var_31_4 and iter_31_7 == table.length(var_31_5.segInterval)

				for iter_31_9, iter_31_10 in ipairs(var_31_2.targets) do
					local var_31_10

					if var_31_2.oriTargets[iter_31_9] then
						var_31_10 = var_31_2.oriTargets[iter_31_9]
					end

					arg_31_0:onProcessLittleSeg(iter_31_10, var_31_2, iter_31_7, var_31_9, var_31_10)
				end
			end
		end

		local var_31_11 = table.shallowcopy(arg_31_0.allTargets)

		for iter_31_11, iter_31_12 in ipairs(var_31_2.targets) do
			var_31_11[iter_31_12.id] = nil
		end

		var_31_11[arg_31_0.owner.id] = nil
		var_31_2.otherTargets = var_31_11

		arg_31_0.scene:excuteGroupObjFunc(1, battle.SpecialObjectId.teamShiled, "syncView", arg_31_0, var_31_2, iter_31_1.isSegProcess)
		arg_31_0.scene:excuteGroupObjFunc(2, battle.SpecialObjectId.teamShiled, "syncView", arg_31_0, var_31_2, iter_31_1.isSegProcess)

		if iter_31_1.isSegProcess and arg_31_0:isNormalSkillType() and arg_31_0:isSameType(battle.SkillFormulaType.damage) then
			for iter_31_13, iter_31_14 in ipairs(var_31_2.targets) do
				iter_31_14:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderAfterBeHit, arg_31_0)
			end

			arg_31_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderAfterHit, arg_31_0)
		end

		var_31_2.deferList = var_31_2.deferList or {}
		var_31_2.deferList[iter_31_1.id] = var_31_2.deferList[iter_31_1.id] or {}
		var_31_2.deferList[iter_31_1.id] = gRootViewProxy:proxy():popDeferList(var_31_3)

		battleEasy.queueNotifyFor(arg_31_0.owner.view, "processArgs", iter_31_1.id, var_31_2)
	end

	arg_31_0.scene:excuteGroupObjFunc(1, battle.SpecialObjectId.teamShiled, "popRecordData", arg_31_0.owner.id, arg_31_0.id)
	arg_31_0.scene:excuteGroupObjFunc(2, battle.SpecialObjectId.teamShiled, "popRecordData", arg_31_0.owner.id, arg_31_0.id)
end

function var_0_4.processAfter(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1.processArgs

	arg_32_1.noMissTargetsArray = arg_32_0:saveAllTargets()

	local var_32_1 = gRootViewProxy:proxy():pushDeferList(arg_32_0.id, "play03")

	for iter_32_0, iter_32_1 in ipairs(arg_32_1.noMissTargetsArray) do
		if iter_32_1 and iter_32_1:hp() <= 0 then
			iter_32_1:setDead(arg_32_0.owner)
			arg_32_0:addObjectToKillTab(iter_32_1)
		end
	end

	local var_32_2 = arg_32_0:isMainNumShowType() == battle.SkillFormulaType.damage and battle.SkillSegType.damage or battle.SkillSegType.resumeHp

	for iter_32_2, iter_32_3 in arg_32_0:ipairsProcess() do
		local var_32_3 = arg_32_0.allProcessesTargets[iter_32_3.id]
		local var_32_4
		local var_32_5 = arg_32_0:getProcessArg(iter_32_2 - 1)

		if iter_32_2 > 1 and var_32_5 and arg_32_0.allProcessesTargets[var_32_5.id] then
			var_32_4 = arg_32_0.allProcessesTargets[var_32_5.id]
		end

		arg_32_0:processAddBuff(iter_32_3, var_32_3, var_32_4, battle.SkillAddBuffType.After)

		local var_32_6 = var_32_0[iter_32_2]

		if iter_32_3.isSegProcess then
			var_32_6.showType = var_32_2
		end

		local var_32_7 = ""

		for iter_32_4, iter_32_5 in ipairs(var_32_3) do
			var_32_7 = var_32_7 .. tonumber(iter_32_5.seat) .. " "
		end

		logf.battle.skill.processTargets("skill %d process %d targets:%s", arg_32_0.id, iter_32_3.id, var_32_7)
		battleEasy.deferNotifyCantJump(arg_32_0.owner.view, "processDel", iter_32_3.id)
	end

	arg_32_0:pushDefreListToSkillEnd("skillEndAddBuffsPlayFuncs", gRootViewProxy:proxy():popDeferList(var_32_1))

	arg_32_1.noDeadObjectTb = var_0_6(arg_32_1.noMissTargetsArray)
end

function var_0_4.processAfterObjTrigger(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.cfg
	local var_33_1 = arg_33_1.target
	local var_33_2 = arg_33_1.allDamagedOrder
	local var_33_3 = arg_33_1.noMissTargetsArray
	local var_33_4 = arg_33_1.noDeadObjectTb
	local var_33_5 = gRootViewProxy:proxy():pushDeferList(arg_33_0.id, "play04")

	if arg_33_0:isNormalSkillType() then
		if arg_33_0:isSameType(battle.SkillFormulaType.damage) then
			for iter_33_0, iter_33_1 in ipairs(var_33_2) do
				if not arg_33_0.protecterObjs[iter_33_1.id] then
					iter_33_1:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderFinallyBeHit, arg_33_0)
				end
			end

			for iter_33_2, iter_33_3 in pairs(arg_33_0.protecterObjs) do
				iter_33_3:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderFinallyBeHit, arg_33_0)
				iter_33_3:updAttackerCurSkillTab(arg_33_0, true)
			end
		end

		arg_33_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderAttackEnd, arg_33_0)
	end

	if var_33_1 and var_33_1:isRealDeath() then
		arg_33_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderKillHandleChooseTarget, arg_33_0)
	end

	if next(arg_33_0.killedTargetsTb) then
		arg_33_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderKillTarget, arg_33_0)

		arg_33_0.scene.play.battleTurnInfoTb.hasDeadObj = true
	end

	arg_33_0:pushDefreListToSkillEnd("skillEndTriggerBuffsPlayFuncs", gRootViewProxy:proxy():popDeferList(var_33_5))

	for iter_33_4, iter_33_5 in ipairs(var_33_3) do
		if var_33_4[iter_33_5.id] and iter_33_5:hp() <= 0 then
			arg_33_0:addObjectToKillTab(iter_33_5)
		end
	end

	for iter_33_6, iter_33_7 in ipairs(var_33_3) do
		if var_33_4[iter_33_7.id] and iter_33_7:hp() <= 0 and iter_33_7.force == var_33_1.force then
			var_33_1:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderMateKilledBySkill, arg_33_0)
		end
	end

	if arg_33_0:isNormalSkillType() and arg_33_0.scene.play.gateDoOnSkillEnd then
		arg_33_0:pushDefreListToSkillEnd("skillEndDrops", arg_33_0.scene.play:gateDoOnSkillEnd())
	end

	local var_33_6 = var_33_1 and {
		var_33_1
	} or arg_33_0.allProcessesTargets[arg_33_0:getProcessArg(1).id]

	for iter_33_8, iter_33_9 in maptools.order_pairs(arg_33_0.allTargets, "id") do
		if var_33_6[1] and var_33_6[1].id == iter_33_9.id or iter_33_9.id ~= arg_33_0.owner.id then
			arg_33_0.owner:onPassive(var_0_3.recoverHp, iter_33_9, {
				skillType = arg_33_0.skillType,
				hpFormula = var_33_0.hpFormula
			})
		end

		iter_33_9:updAttackerCurSkillTab(arg_33_0, true)
	end

	for iter_33_10, iter_33_11 in arg_33_0.scene.allBuffs:order_pairs() do
		if iter_33_11.args.fromSkillId == arg_33_0.id and iter_33_11.caster.id == arg_33_0.owner.id then
			local var_33_7 = iter_33_11.nodeManager.nodes
			local var_33_8 = iter_33_11.nodeManager.times

			for iter_33_12, iter_33_13 in iter_33_11.nodeManager:ipairsNodes() do
				if iter_33_13.delSelfWhenTriggered == 2 and (not var_33_8[iter_33_12] or not (var_33_8[iter_33_12] > 0)) then
					iter_33_11:over()
				end
			end
		end
	end
end

function var_0_4.processAfterDelObj(arg_34_0)
	local var_34_0 = gRootViewProxy:proxy():pushDeferList(arg_34_0.id, "play05")

	for iter_34_0, iter_34_1 in ipairs(arg_34_0.killedTargetsTb) do
		if iter_34_1 and iter_34_1:isRealDeath() then
			arg_34_0.scene:addObjToBeDeleted(iter_34_1)
		end
	end

	arg_34_0:pushDefreListToSkillEnd("skillEndDeleteDeadObjs", gRootViewProxy:proxy():popDeferList(var_34_0))
end

function var_0_4.isAttackSkill(arg_35_0)
	return true
end

function var_0_4.processAfterRefresh(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1.skillCfg
	local var_36_1 = arg_36_0.owner:getOverlaySpecBuffByIdx("mp1OverFlow")

	if var_36_1 and var_36_1.mode == 1 and arg_36_0.skillType2 == battle.MainSkillType.BigSkill then
		local var_36_2 = arg_36_0.owner:mpOverflow()
		local var_36_3 = cc.clampf(math.floor(var_36_2 / var_36_1.rate), 0, var_36_1.cost or math.floor(var_36_1.limit / var_36_1.rate)) * var_36_1.rate

		arg_36_0.owner.mp1Table[3] = cc.clampf(var_36_2 - var_36_3, 0, var_36_1.limit)
	end

	local var_36_4 = gRootViewProxy:proxy():pushDeferList(arg_36_0.id, "play06")
	local var_36_5 = arg_36_0.owner:getEventByKey(battle.ExRecordEvent.spellSkillTotal) or 0

	if arg_36_0:isAttackSkill() and var_36_5 <= arg_36_0.scene.play.recoverMp2RoundLimit and not arg_36_0.scene:beInExtraAttack() then
		local var_36_6 = arg_36_0.scene:getSceneAttrCorrect(arg_36_0.owner:serverForce())

		if var_36_6 and var_36_6.activeSkillMp1 then
			arg_36_0.owner:setMP1(arg_36_0.owner:mp1() + var_36_6.activeSkillMp1)
		end
	end

	if not arg_36_0.owner.cantRecoverSkillMp and not arg_36_0.scene:beInExtraAttack() and var_36_0.recoverMp1 and var_36_0.recoverMp1 > 0 then
		logf.battle.skill.skillEndRecoerMp1(" 释放回复mp: cur mp1= %f, skillId= %d, cfg.recoverMp1= %f", arg_36_0.owner:mp1(), arg_36_0.id, var_36_0.recoverMp1)

		local var_36_7 = var_36_0.recoverMp1 * (1 + arg_36_0.owner:mp1Recover())

		arg_36_0.owner:setMP1(arg_36_0.owner:mp1() + var_36_7)
	end

	arg_36_0:pushDefreListAfterComeBack("afterComeBackRecoverMp", gRootViewProxy:proxy():popDeferList(var_36_4))
end

function var_0_4.processAfterRefreshExtra(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1.target

	local function var_37_1(arg_38_0)
		if not arg_38_0 then
			return
		end

		if not arg_38_0:isAlreadyDead() and arg_37_0:isSameType(battle.SkillFormulaType.damage) then
			if arg_38_0:onCounterAttack(arg_37_0, var_37_0, arg_37_0.owner) then
				arg_37_0.scene:addObjToExtraRound(arg_38_0)
			end

			arg_38_0:onSyncAttack(arg_37_0, var_37_0, arg_37_0.owner)
		end
	end

	if not arg_37_0.scene:beInExtraAttack() and arg_37_0:isNormalSkillType() then
		for iter_37_0, iter_37_1 in arg_37_0.scene:ipairsHeros() do
			local var_37_2 = arg_37_0.scene:getObjectBySeatExcludeDead(iter_37_1.seat, battle.ObjectType.SummonFollow)

			var_37_1(iter_37_1)
			var_37_1(var_37_2)
		end

		if not arg_37_0.owner:isAlreadyDead() and arg_37_0.owner:onComboAttack(arg_37_0, var_37_0, arg_37_0.owner) then
			arg_37_0.scene:addObjToExtraRound(arg_37_0.owner, 1)
		end
	end

	if arg_37_0.scene:beInExtraAttack() and arg_37_0:isNormalSkillType() and arg_37_0.owner.exAttackMode == battle.ExtraAttackMode.counter then
		arg_37_0.counterAttackForView = true
	end
end

function var_0_4.spellTo(arg_39_0, arg_39_1, arg_39_2)
	arg_39_0:_spellTo(arg_39_1, arg_39_2)
end

function var_0_4._spellTo(arg_40_0, arg_40_1)
	log.battle.skill.spellTo("curSkillId=", arg_40_0.id, "owner.id=", arg_40_0.owner.seat, "target.id=", arg_40_1 and arg_40_1.seat, "skillType2=", arg_40_0.skillType2)
	arg_40_0:cleanData()
	arg_40_0:startSpell()

	arg_40_0.canjumpBigSkill = arg_40_0:isJumpBigSkill()

	arg_40_0:updateRecord()

	local var_40_0 = {
		skillCfg = arg_40_0.cfg,
		target = arg_40_1
	}

	arg_40_0:processBefore(var_40_0)
	arg_40_0:processPlay(var_40_0)
	arg_40_0:processTarget(var_40_0)
	arg_40_0:processAfter(var_40_0)
	arg_40_0:processAfterObjTrigger(var_40_0)
	arg_40_0:processAfterDelObj()
	arg_40_0:processAfterRefresh(var_40_0)
	arg_40_0:processAfterRefreshExtra(var_40_0)
	arg_40_0:spellToOver(var_40_0)
	arg_40_0:onSpellView(var_40_0)
end

function var_0_4.spellToOver(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1.target
	local var_41_1 = arg_41_1.processArgs
	local var_41_2 = {}
	local var_41_3

	for iter_41_0, iter_41_1 in ipairs(arg_41_0.actionSegArgs) do
		local var_41_4 = arg_41_0.allProcessesTargets[iter_41_1.processId]
		local var_41_5 = var_41_1[iter_41_0]
		local var_41_6 = {}

		for iter_41_2, iter_41_3 in ipairs(var_41_4) do
			if var_41_5.oriTargets[iter_41_2] then
				table.insert(var_41_6, var_41_5.oriTargets[iter_41_2])
			else
				table.insert(var_41_6, iter_41_3)
			end
		end

		iter_41_1.posIdx = arg_41_0.owner.view:proxy():getMoveToTargetPos(arg_41_0.cfg, var_41_6)
		iter_41_1.target = var_41_6[1] or arg_41_0.owner:getCurTarget()
		var_41_3 = iter_41_1.posIdx
	end

	if not var_41_3 then
		local var_41_7 = {}
		local var_41_8 = {}

		table.insert(var_41_7, var_41_0)

		var_41_8[var_41_0.id] = true

		for iter_41_4, iter_41_5 in maptools.order_pairs(arg_41_0.allProcessesTargets) do
			for iter_41_6, iter_41_7 in ipairs(iter_41_5) do
				if iter_41_7.id ~= arg_41_0.owner.id and not var_41_8[iter_41_7.id] then
					table.insert(var_41_7, iter_41_7)

					var_41_8[iter_41_7.id] = true

					iter_41_7:updAttackerCurSkillTab(arg_41_0, true)
				end
			end
		end

		var_41_3 = arg_41_0.owner.view:proxy():getMoveToTargetPos(arg_41_0.cfg, var_41_7)
	end

	arg_41_0.isSpellTo = false
	arg_41_0.interruptBuffId = nil

	arg_41_0:sortViewProcess()
	battleEasy.logHerosInfo(arg_41_0.scene)

	arg_41_1.lastPosIdx = var_41_3
end

function var_0_4.sortViewProcess(arg_42_0)
	local var_42_0 = ymrand.random

	arg_42_0.protectedEnv:resetEnv()

	local var_42_1 = battleCsv.fillFuncEnv(arg_42_0.protectedEnv, {
		target = arg_42_0.owner:getCurTarget()
	})

	for iter_42_0, iter_42_1 in arg_42_0:ipairsProcess() do
		if iter_42_1.extraArgs and iter_42_1.extraArgs.effectProb and battleCsv.doFormula(iter_42_1.extraArgs.effectProb, var_42_1) < var_42_0() then
			arg_42_0.owner.view:proxy():saveIgnoreEffect(iter_42_1.id, iter_42_1.effectEventID)
		end
	end
end

function var_0_4.onSpellView(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_1.target
	local var_43_1 = arg_43_1.lastPosIdx
	local var_43_2 = arg_43_0.scene
	local var_43_3 = arg_43_0.owner.view
	local var_43_4 = arg_43_0.cfg
	local var_43_5 = arg_43_0:targetsMap2Array(arg_43_0.allTargets)
	local var_43_6

	log.battle.skill.onSpellView("skill onSpellView target.id=", var_43_0 and var_43_0.seat, "move pos=", var_43_1)

	arg_43_0.owner.flashBack = var_43_4.flashBack

	var_43_3:proxy():setSkillJumpSwitch(arg_43_0.canjumpBigSkill)

	for iter_43_0, iter_43_1 in arg_43_0:ipairsProcess() do
		if iter_43_1.effectEventID then
			local var_43_7 = arg_43_0.processEventCsv[iter_43_1.id]

			if var_43_7 and var_43_7.control then
				battleEasy.queueEffect("control", var_43_7.control)
			end
		end
	end

	if arg_43_0.skillType2 == battle.MainSkillType.BigSkill then
		local var_43_8 = {}

		for iter_43_2 = 1, arg_43_0.scene.play.ObjectNumber do
			local var_43_9 = arg_43_0.scene:getObjectBySeat(iter_43_2)
			local var_43_10 = arg_43_0.scene:getObjectBySeat(iter_43_2, battle.ObjectType.SummonFollow)

			if var_43_9 and not arg_43_0.allTargets[var_43_9.id] and var_43_9.id ~= arg_43_0.owner.id then
				var_43_8[iter_43_2] = tostring(var_43_9)
			end

			if var_43_10 and not arg_43_0.allTargets[var_43_10.id] and var_43_10.id ~= arg_43_0.owner.id then
				var_43_8[iter_43_2 + arg_43_0.scene.play.ObjectNumber] = tostring(var_43_10)
			end
		end

		if not var_43_4.notShowProcedure.beforeMainSkill then
			battleEasy.queueEffect("sound", {
				delay = 0,
				sound = {
					loop = 0,
					res = "skill2_effect.mp3"
				}
			})
			battleEasy.queueEffect(function()
				gRootViewProxy:notify("ultSkillPreAni1")
				gRootViewProxy:notify("ultSkillPreAni2", tostring(arg_43_0.owner), var_43_4, var_43_8)
				gRootViewProxy:notify("objMainSkill")
			end)
			battleEasy.queueEffect("delay", {
				lifetime = 1334
			})
		end
	elseif arg_43_0.type == 1 then
		local var_43_11 = {}

		for iter_43_3 = 1, arg_43_0.scene.play.ObjectNumber do
			local var_43_12 = arg_43_0.scene:getObjectBySeat(iter_43_3)
			local var_43_13 = arg_43_0.scene:getObjectBySeat(iter_43_3, battle.ObjectType.SummonFollow)

			if var_43_12 and not arg_43_0.allTargets[var_43_12.id] and var_43_12.id ~= arg_43_0.owner.id then
				var_43_11[iter_43_3] = tostring(var_43_12)
			end

			if var_43_13 and not arg_43_0.allTargets[var_43_13.id] and var_43_13.id ~= arg_43_0.owner.id then
				var_43_11[iter_43_3 + arg_43_0.scene.play.ObjectNumber] = tostring(var_43_13)
			end
		end

		battleEasy.queueEffect(function()
			gRootViewProxy:notify("skillPreAni", var_43_11)
		end)
	end

	battleEasy.queueEffect(function()
		local var_46_0 = var_43_0.view:proxy():getMovePosZ()
		local var_46_1 = arg_43_0.owner.view:proxy():getMovePosZ()
		local var_46_2 = math.min(var_46_0, var_46_1)

		var_43_3:proxy():setLocalZOrder(var_46_2 + 1)
	end)
	battleEasy.queueEffect(function()
		local var_47_0 = var_43_0.view:proxy():getMovePosZ()

		for iter_47_0, iter_47_1 in ipairs(var_43_5) do
			var_47_0 = math.max(var_47_0, iter_47_1.view:proxy():getMovePosZ())
		end

		battleEasy.queueEffect(function()
			var_43_3:proxy():setLocalZOrder(var_47_0 + 1)
		end)
	end)

	if arg_43_0.counterAttackForView then
		battleEasy.queueNotifyFor(var_43_3, "showCounterAttackText", tostring(arg_43_0.owner))

		arg_43_0.counterAttackForView = false
	end

	battleEasy.queueNotifyFor(var_43_3, "skillBefore", arg_43_0.disposeDatasOnSkillStart, arg_43_0.skillType, false, arg_43_0:getSkillSceneTag())
	battleEasy.queueNotifyFor(var_43_3, "attacting", true)

	if var_43_4.sound and not arg_43_0.canjumpBigSkill then
		battleEasy.queueEffect("sound", {
			delay = var_43_4.sound.delay,
			sound = {
				res = var_43_4.sound.res,
				loop = var_43_4.sound.loop
			}
		})
	end

	local var_43_14 = {}

	for iter_43_4, iter_43_5 in ipairs(arg_43_0.actionSegArgs) do
		if iter_43_5.target and not var_43_6 or var_43_6 and var_43_6.id ~= iter_43_5.target.id then
			battleEasy.queueNotifyFor(var_43_3, "moveToTarget", iter_43_5.posIdx, {
				delayBeforeMove = var_43_4.moveTime[1],
				moveCostTime = var_43_4.moveTime[2],
				timeScale = arg_43_0.scene:beInExtraAttack() and 0.51,
				cameraNear = var_43_4.cameraNear,
				cameraNear_posC = var_43_4.cameraNear_posC,
				posC = var_43_4.posC,
				attackFriend = arg_43_0.owner:needAlterForce()
			}, false, tostring(iter_43_5.target), arg_43_0:filterProtectorView(iter_43_5.target, var_43_14))
		end

		var_43_6 = iter_43_5.target

		battleEasy.queueNotifyFor(var_43_3, "playAction", iter_43_5.spine, iter_43_5.lifeTime or false, false)
	end

	if arg_43_0.canjumpBigSkill then
		local var_43_15, var_43_16 = arg_43_0:getTargetsFinalValue()
		local var_43_17 = var_43_15
		local var_43_18 = battle.SkillSegType.damage

		if var_43_15 == 0 and arg_43_0:isSameType(battle.SkillFormulaType.resumeHp) then
			var_43_17, var_43_18 = var_43_16, battle.SkillSegType.resumeHp
		end

		local var_43_19 = {
			delta = var_43_17,
			skillId = var_43_4.id,
			typ = var_43_18
		}

		battleEasy.queueNotifyFor(var_43_3, "ultJumpShowNum", var_43_19)
	end

	battleEasy.queueNotifyFor(var_43_3, "objSkillEnd", arg_43_0.disposeDatasOnSkillEnd, arg_43_0.skillType)
	battleEasy.queueNotifyFor(var_43_3, "comeBack", var_43_1, false, {
		delayBeforeBack = var_43_4.moveTime[3],
		backCostTime = var_43_4.moveTime[4],
		timeScale = arg_43_0.scene:beInExtraAttack() and 0.51,
		flashBack = var_43_4.flashBack,
		attackFriend = arg_43_0.owner:needAlterForce()
	}, false, var_43_14)
	battleEasy.queueNotifyFor(var_43_3, "afterComeBack", arg_43_0.disposeDatasAfterComeBack)
	battleEasy.queueNotifyFor(var_43_3, "attacting", false)
	battleEasy.queueNotifyFor(var_43_3, "resetPos")
	battleEasy.queueNotifyFor(var_43_3, "objSkillOver")
end

function var_0_4.getTargetsFinalValue(arg_49_0)
	local var_49_0 = 0
	local var_49_1 = 0

	for iter_49_0, iter_49_1 in pairs(arg_49_0.targetsFinalResult) do
		var_49_0 = var_49_0 + iter_49_1.damage.real:get(battle.ValueType.normal)
		var_49_1 = var_49_1 + iter_49_1.resumeHp.real:get(battle.ValueType.normal)
	end

	return var_49_0, var_49_1
end

function var_0_4.getTargets(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4, arg_50_5)
	local var_50_0 = {
		friendOrEnemy = arg_50_1,
		specialChoose = arg_50_4.specialChoose,
		targetLimit = arg_50_4.targetLimit,
		allProcessesTargets = arg_50_4.excludeTarget,
		inputExtraStr = arg_50_4.inputExtraStr,
		skillType = arg_50_0.skillType,
		skillSegType = arg_50_4.segType,
		skillFixType = arg_50_4.fixType
	}

	return (newTargetFinder(arg_50_0.owner, arg_50_3, arg_50_2, var_50_0, arg_50_5))
end

function var_0_4.getSpurtTargets(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	local function var_51_0(arg_52_0)
		for iter_52_0, iter_52_1 in ipairs(arg_51_2) do
			if arg_52_0 == iter_52_1.seat then
				return true
			end
		end

		for iter_52_2, iter_52_3 in ipairs(arg_51_4) do
			if iter_52_3 and iter_52_3.seat == arg_52_0 then
				return true
			end
		end

		return false
	end

	local var_51_1 = {}
	local var_51_2 = {
		{
			2,
			4
		},
		{
			1,
			3,
			5
		},
		{
			2,
			6
		},
		{
			1,
			5
		},
		{
			2,
			4,
			6
		},
		{
			3,
			5
		}
	}
	local var_51_3 = arg_51_1.seat > 6 and arg_51_1.seat - 6 or arg_51_1.seat

	for iter_51_0, iter_51_1 in ipairs(var_51_2[var_51_3]) do
		if arg_51_1.force == 2 then
			iter_51_1 = iter_51_1 + 6
		end

		local var_51_4 = arg_51_0.scene:getObjectBySeatExcludeDead(iter_51_1)
		local var_51_5 = false

		if var_51_4 and var_51_4:isLogicStateExit(battle.ObjectLogicState.cantBeAttack, {
			fromObj = arg_51_0.owner
		}) then
			var_51_5 = true
		end

		if var_51_4 and var_51_4:isAlreadyDead() == false and not var_51_5 then
			table.insert(var_51_1, var_51_4)
		end
	end

	local var_51_6 = arg_51_0:replaceLethalTargets(var_51_1)
	local var_51_7 = {}

	for iter_51_2, iter_51_3 in ipairs(var_51_6) do
		if not var_51_0(iter_51_3.seat) then
			table.insert(var_51_7, iter_51_3)
		end
	end

	local var_51_8 = var_51_7

	table.sort(var_51_8, function(arg_53_0, arg_53_1)
		return arg_53_0.id < arg_53_1.id
	end)

	return var_51_8
end

function var_0_4.getPenetrateTarget(arg_54_0, arg_54_1)
	local var_54_0

	if (math.floor((arg_54_1.seat + 2) / 3) - 1) % 2 + 1 == 1 then
		local var_54_1 = arg_54_0.scene:getObjectBySeatExcludeDead(arg_54_1.seat + 3)

		if var_54_1 and var_54_1:isAlreadyDead() == false and not var_54_1:isLogicStateExit(battle.ObjectLogicState.cantBeAttack, {
			fromObj = arg_54_0.owner
		}) then
			var_54_0 = var_54_1
		end
	end

	return arg_54_0:replaceLethalTargets({
		var_54_0
	})[1]
end

function var_0_4.getTargetsHint(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0.cfg
	local var_55_1 = arg_55_0.owner:getSneerObj()
	local var_55_2 = {
		hintChoose = arg_55_0:getSkillCfgByKey("hintChoose"),
		hintTargetType = var_55_0.hintTargetType
	}

	arg_55_1 = arg_55_1 or var_55_0.hitFormula

	local var_55_3 = {}

	if arg_55_1 and csvSize(arg_55_1) > 0 then
		arg_55_0.protectedEnv:resetEnv()

		local var_55_4 = battleCsv.fillFuncEnv(arg_55_0.protectedEnv, {})
		local var_55_5

		for iter_55_0, iter_55_1 in csvMapPairs(arg_55_1) do
			local var_55_6 = battleCsv.doFormula(iter_55_1.key, var_55_4) and 1 or 2

			var_55_3[iter_55_0] = iter_55_1.value[var_55_6] or var_55_3[iter_55_0]
		end
	end

	if var_55_2.hintTargetType == 1 and var_55_1 and not var_55_1:isAlreadyDead() then
		var_55_2.hintChoose = 1
	end

	local var_55_7 = {
		specialChoose = var_55_0.specialHintChoose,
		inputExtraStr = string.format("nobeskillselectedhint({skillFormulaType=%s})", arg_55_0.skillFormulaType)
	}

	if arg_55_0:isSameType(battle.SkillFormulaType.fix) and var_55_2.hintChoose > 100 then
		local var_55_8 = var_55_2.hintChoose

		var_55_7.fixType = battle.SkillFormulaType.resumeHp

		local var_55_9 = math.floor(var_55_8 / 100)
		local var_55_10 = arg_55_0:getTargets(var_55_2.hintTargetType == 1 and 0 or 1, var_55_9, var_55_1, var_55_7, var_55_3)
		local var_55_11 = var_55_2.hintChoose - var_55_9 * 100

		var_55_7.fixType = battle.SkillFormulaType.damage

		local var_55_12 = arg_55_0:getTargets(var_55_2.hintTargetType, var_55_11, var_55_1, var_55_7, var_55_3)

		return arraytools.merge({
			var_55_10,
			var_55_12
		})
	end

	return arg_55_0:getTargets(var_55_2.hintTargetType, var_55_2.hintChoose, var_55_1, var_55_7, var_55_3)
end

function var_0_4.autoChoose(arg_56_0)
	return arg_56_0:getTargetsHint(arg_56_0.cfg.autoHintChoose)
end

function var_0_4.getSkillCfgByKey(arg_57_0, arg_57_1)
	return arg_57_0.owner:dealOpenValueByKey(arg_57_1, arg_57_0.cfg[arg_57_1])
end

function var_0_4.onProcessGetTargets(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = arg_58_0.allProcessesTargets

	if arg_58_1.targetFormula and csvSize(arg_58_1.targetFormula) > 0 then
		arg_58_0.protectedEnv:resetEnv()

		local var_58_1 = battleCsv.fillFuncEnv(arg_58_0.protectedEnv, {
			target = arg_58_2
		})
		local var_58_2

		for iter_58_0, iter_58_1 in csvMapPairs(arg_58_1.targetFormula) do
			local var_58_3 = battleCsv.doFormula(iter_58_1.key, var_58_1) and 1 or 2

			arg_58_1[iter_58_0] = iter_58_1.value[var_58_3] or arg_58_1[iter_58_0]
		end
	end

	local var_58_4 = arg_58_1.input and {
		input = arg_58_1.input,
		process = arg_58_1.process
	}
	local var_58_5 = "nobeskillselected"
	local var_58_6 = arg_58_0:getTargets(arg_58_1.targetType, arg_58_1.skillTarget, arg_58_2, {
		specialChoose = arg_58_1.specialChoose,
		targetLimit = arg_58_1.targetLimit,
		excludeTarget = var_58_0,
		inputExtraStr = var_58_5,
		segType = var_0_5[arg_58_1.segType]
	}, var_58_4)

	if (not arg_58_1.extraArgs or not arg_58_1.extraArgs.targetCanBeEmpty) and table.length(var_58_6) == 0 and arg_58_1.isSegProcess then
		var_58_6 = {
			arg_58_0.owner:getCurTarget()
		}
	end

	local var_58_7 = arg_58_0.owner:getSneerObj()
	local var_58_8

	if var_58_7 and not var_58_7:isNotReSelect() and not var_58_7:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
		fromObj = arg_58_0.owner
	}) then
		var_58_8 = var_58_7.id

		local var_58_9 = false

		for iter_58_2, iter_58_3 in ipairs(var_58_6) do
			if iter_58_3.force ~= arg_58_0.owner.force then
				var_58_9 = true
			end

			if iter_58_3.id == var_58_7.id then
				var_58_7 = nil

				break
			end
		end

		if var_58_9 then
			var_58_6[1] = var_58_7 or var_58_6[1]
		end
	end

	local var_58_10 = arg_58_0.owner.scene.play:getExtraBattleRoundData("mustHit")
	local var_58_11 = arg_58_0.owner.scene.play:getExtraBattleRoundData("processCfgId")

	if arg_58_1.id == var_58_11 and var_58_10 and table.length(var_58_10) > 0 then
		local var_58_12 = arraytools.hash(var_58_10)
		local var_58_13 = {}

		for iter_58_4, iter_58_5 in ipairs(var_58_6) do
			if var_58_12[iter_58_5.id] then
				var_58_12[iter_58_5.id] = nil
			elseif iter_58_5.id ~= var_58_8 then
				table.insert(var_58_13, iter_58_4)
			end
		end

		local var_58_14 = 1

		for iter_58_6, iter_58_7 in ipairs(var_58_10) do
			if not var_58_13[var_58_14] then
				break
			end

			local var_58_15 = arg_58_0.owner.scene:getObject(iter_58_7)

			if var_58_12[iter_58_7] and var_58_15 and not var_58_15:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
				fromObj = arg_58_0.owner
			}) then
				var_58_6[var_58_13[var_58_14]] = var_58_15
				var_58_14 = var_58_14 + 1
			end
		end
	end

	return var_58_6
end

function var_0_4.onProcess(arg_59_0, arg_59_1, arg_59_2)
	log.battle.skill.process("onProcess", arg_59_0.owner.id, lazydumps(arg_59_1))

	local var_59_0 = arg_59_0:onProcessGetTargets(arg_59_1, arg_59_2)
	local var_59_1, var_59_2 = arg_59_0:replaceLethalTargets(var_59_0, true)

	for iter_59_0, iter_59_1 in ipairs(var_59_1) do
		if arg_59_0:isSameType(battle.SkillFormulaType.damage) then
			local var_59_3 = arg_59_0:getTargetsFinalResult(iter_59_1.id)

			if not var_59_3.value and not arg_59_0.owner:isHit(iter_59_1, arg_59_0.cfg) then
				var_59_3.value = 0
				var_59_3.args.skillMiss = true
			end
		end

		iter_59_1:updAttackerCurSkillTab(arg_59_0, false)
	end

	return {
		process = arg_59_1,
		targets = var_59_1,
		oriTargets = var_59_2
	}
end

function var_0_4.updateTarget(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	if arg_60_1.extraArgs and arg_60_1.extraArgs.needUpdateTarget then
		local var_60_0 = arg_60_0:onProcess(arg_60_1, arg_60_2)

		arg_60_3.targets = var_60_0.targets
		arg_60_3.oriTargets = var_60_0.oriTargets
		arg_60_0.allProcessesTargets[arg_60_3.process.id] = arg_60_3.targets
	end
end

function var_0_4.onProcessLittleSeg(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5)
	arg_61_0:calcFormulaFinal(arg_61_1, arg_61_2)
	arg_61_0:onTarget(arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5)
end

local var_0_7 = {
	"miss",
	"block",
	"strike",
	"natureFlag",
	"nature",
	"hasCalcDamageProb"
}

function var_0_4.calcFormulaFinal(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0.cfg
	local var_62_1 = arg_62_0:getTargetsFinalResult(arg_62_1.id, arg_62_2.process.segType)

	if arg_62_2.process.segType == battle.SkillSegType.resumeHp and not var_62_1.value then
		local var_62_2 = arg_62_0:calcFormula("hp", var_62_0.hpFormula, arg_62_1)

		log.battle.skill.formula(" 技能表公式配置:hpFormula owner.id=%s, cfg.hpFormula=%s, hpFormula=%s, target.id=%s", arg_62_0.owner.seat, var_62_0.hpFormula, var_62_2, arg_62_1 and arg_62_1.id)

		local var_62_3 = arg_62_0:getSkillNatureType() or 1
		local var_62_4 = game.NATURE_TABLE[var_62_3]

		var_62_1.value = var_62_2 * (1 + arg_62_0.owner:cure() + arg_62_0.owner[var_62_4 .. "Cure"](arg_62_0.owner) + arg_62_0.owner:healAdd())
		var_62_1.args = {
			casterId = arg_62_0.owner.id
		}
	end

	if arg_62_2.process.segType == battle.SkillSegType.damage and not var_62_1.value then
		local var_62_5 = arg_62_0:calcFormula("damage", var_62_0.damageFormula, arg_62_1) * (arg_62_0.scene.closeRandFix and 1 or ymrand.random(9000, ConstSaltNumbers.wan) / ConstSaltNumbers.wan)

		logf.battle.skill.damageFormula(" 技能表公式配置:damageFormula  ownerId= %s, formula damge= %s, cfg.damageFormula= %s", arg_62_0.owner.seat, var_62_5, var_62_0.damageFormula)

		local var_62_6 = {
			skillId = var_62_0.id,
			natureType = arg_62_0:getSkillNatureType() or 1,
			damageType = var_62_0.skillDamageType or battle.SkillDamageType.Physical,
			skillType2 = var_62_0.skillType2,
			skillPower = var_62_0.skillPower
		}

		if var_62_1.args then
			for iter_62_0, iter_62_1 in ipairs(var_0_7) do
				var_62_6[iter_62_1] = var_62_1.args[iter_62_1]
			end
		end

		local var_62_7, var_62_8 = arg_62_1:calcInternalDamage(arg_62_0.owner, var_62_5, arg_62_0.skillCalDamageProcessId, var_62_6)

		var_62_1.value = var_62_7
		var_62_1.args = var_62_8
	end
end

function var_0_4.preCalcDamageProb(arg_63_0, arg_63_1, arg_63_2)
	if arg_63_2.process.segType ~= battle.SkillSegType.damage then
		return
	end

	local var_63_0 = arg_63_0:getTargetsFinalResult(arg_63_1.id, arg_63_2.process.segType)

	if var_63_0.args and var_63_0.args.hasCalcDamageProb then
		return
	end

	local var_63_1, var_63_2 = battleEasy.runDamageProcess(0, arg_63_0.owner, arg_63_1, arg_63_0.skillCalDamageProcessId, {
		exProcessId = battle.DamageProbProcessId,
		skillId = arg_63_0.cfg.id,
		natureType = arg_63_0:getSkillNatureType() or 1
	})

	var_63_0.args = var_63_2
	var_63_0.args.hasCalcDamageProb = true

	arg_63_1:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderCalcDamageProb, arg_63_0)
end

function var_0_4.onSputterTarget(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5)
	local var_64_0 = arg_64_1:getEventByKey(battle.ExRecordEvent.sputtering)

	if var_64_0 then
		local var_64_1 = var_64_0.rate

		if arg_64_4.segId == 1 then
			if not arg_64_2.sputObjs then
				arg_64_2.sputObjs = {}
			end

			arg_64_2.sputObjs[arg_64_1.id] = arg_64_0:getSpurtTargets(arg_64_1, arg_64_2.targets, table.length(arg_64_2.targets) > 1, arg_64_2.oriTargets)

			for iter_64_0, iter_64_1 in ipairs(arg_64_2.sputObjs[arg_64_1.id]) do
				local var_64_2 = arg_64_0:getTargetsFinalResult(iter_64_1.id, battle.SkillSegType.damage)

				var_64_2.value = var_64_2.value or arg_64_3.value * var_64_1
			end
		end

		for iter_64_2, iter_64_3 in ipairs(arg_64_2.sputObjs[arg_64_1.id]) do
			local var_64_3 = arg_64_5.damage * var_64_1

			arg_64_4.beHitNotWakeUp = true

			local var_64_4, var_64_5 = iter_64_3:beAttack(arg_64_0.owner, var_64_3, arg_64_5.damageProcessAfterCal, arg_64_4)
			local var_64_6 = arg_64_0:getTargetsFinalResult(iter_64_3.id, battle.SkillSegType.damage)

			var_64_6.real:add(var_64_4)

			var_64_6.args = var_64_5

			if var_64_5.beAttackToDeath then
				arg_64_0:addObjectToKillTab(iter_64_3)
			end

			if not arg_64_0.canjumpBigSkill then
				battleEasy.deferNotifyCantJump(nil, "showNumber", {
					delta = math.floor(var_64_4:get(battle.ValueType.normal)),
					skillId = arg_64_0.id,
					typ = battle.SkillSegType.damage
				})
			end
		end

		if arg_64_5.isLastSeg then
			for iter_64_4, iter_64_5 in ipairs(arg_64_2.sputObjs[arg_64_1.id]) do
				if iter_64_5 and iter_64_5:hp() <= 0 then
					iter_64_5:setDead(arg_64_0.owner)
				end
			end

			arg_64_1:cleanEventByKey(battle.ExRecordEvent.sputtering)

			arg_64_2.sputObjs[arg_64_1.id] = nil
		end
	end
end

function var_0_4.onPenetrateTarget(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5)
	local var_65_0 = arg_65_1:getEventByKey(battle.ExRecordEvent.penetrate)

	if var_65_0 then
		local var_65_1 = var_65_0.rate

		if arg_65_4.segId == 1 then
			arg_65_2.penetrateObj = arg_65_0:getPenetrateTarget(arg_65_1)

			if arg_65_2.penetrateObj then
				local var_65_2 = arg_65_0:getTargetsFinalResult(arg_65_2.penetrateObj.id, battle.SkillSegType.damage)

				var_65_2.value = var_65_2.value or arg_65_3.value * var_65_1
			end
		end

		if arg_65_2.penetrateObj then
			local var_65_3 = arg_65_5.damage * var_65_1

			arg_65_4.beHitNotWakeUp = true

			local var_65_4, var_65_5 = arg_65_2.penetrateObj:beAttack(arg_65_0.owner, var_65_3, arg_65_5.damageProcessAfterCal, arg_65_4)
			local var_65_6 = arg_65_0:getTargetsFinalResult(arg_65_2.penetrateObj.id, battle.SkillSegType.damage)

			var_65_6.real:add(var_65_4)

			var_65_6.args = var_65_5

			if var_65_5.beAttackToDeath then
				arg_65_0:addObjectToKillTab(arg_65_2.penetrateObj)
			end

			if not arg_65_0.canjumpBigSkill then
				battleEasy.deferNotifyCantJump(nil, "showNumber", {
					delta = math.floor(var_65_4:get(battle.ValueType.normal)),
					skillId = arg_65_0.id,
					typ = battle.SkillSegType.damage
				})
			end
		end

		if arg_65_5.isLastSeg then
			if arg_65_2.penetrateObj and arg_65_2.penetrateObj:hp() <= 0 then
				arg_65_2.penetrateObj:setDead(arg_65_0.owner)
			end

			arg_65_1:cleanEventByKey(battle.ExRecordEvent.penetrate)

			arg_65_2.penetrateObj = nil
		end
	end
end

function var_0_4.onHealToDamageTarget(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5)
	if arg_66_1:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.healTodamage) then
		local var_66_0 = arg_66_0:getTargetsFinalResult(arg_66_1.id, battle.SkillSegType.damage)

		if arg_66_5 == 1 then
			local var_66_1 = arg_66_1:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.healTodamage, "getDamage", arg_66_3.value)
			local var_66_2 = 0

			for iter_66_0, iter_66_1 in ipairs(var_66_1) do
				var_66_2 = var_66_2 + iter_66_1.damage
			end

			var_66_0.value = var_66_2
			battleEasy.IDCounter = battleEasy.IDCounter + 1
			var_66_0.args = {
				skillId = arg_66_0.cfg.id,
				damageId = battleEasy.IDCounter
			}
			var_66_0.healToDamageData = var_66_1
		end

		local var_66_3 = arg_66_4.hpSeg[arg_66_5]

		if not var_66_0.attackedDamage or arg_66_5 == 1 then
			var_66_0.attackedDamage = 0
		end

		for iter_66_2, iter_66_3 in ipairs(var_66_0.healToDamageData) do
			local var_66_4 = math.floor(iter_66_3.damage * var_66_3)
			local var_66_5 = table.deepcopy(var_66_0.args)
			local var_66_6 = var_66_0.value - var_66_0.attackedDamage

			var_66_0.attackedDamage = var_66_0.attackedDamage + var_66_4
			var_66_5.processId = arg_66_2.id
			var_66_5.from = battle.DamageFrom.skill
			var_66_5.segId = arg_66_5
			var_66_5.skillDamageId = var_66_0.args.damageId
			var_66_5.isLastDamageSeg = table.length(arg_66_4.hpSeg) == arg_66_5 and table.length(var_66_0.healToDamageData) == iter_66_2
			var_66_5.isBeginDamageSeg = arg_66_5 == 1 and iter_66_2 == 1
			var_66_5.leftDamage = var_66_6

			local var_66_7, var_66_8 = arg_66_1:beAttack(arg_66_0.owner, var_66_4, iter_66_3.processId, var_66_5)

			var_66_0.real:add(var_66_7)
		end

		return false
	end

	return true
end

function var_0_4.onProtectTarget(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	local var_67_0 = arg_67_0:getTargetsFinalResult(arg_67_1.id, battle.SkillSegType.damage)
	local var_67_1 = arg_67_4.segId

	if var_67_1 == 1 then
		local var_67_2 = {
			process = {
				segType = battle.SkillSegType.damage
			}
		}

		var_67_0.args = {}

		arg_67_0:preCalcDamageProb(arg_67_1, var_67_2)

		var_67_0.value = arg_67_3
		arg_67_0.protecterObjs[arg_67_1.id] = arg_67_1

		arg_67_1:updAttackerCurSkillTab(arg_67_0, false)
	end

	if not var_67_0.attackedDamage or var_67_1 == 1 then
		var_67_0.attackedDamage = 0
	end

	local var_67_3 = table.deepcopy(var_67_0.args)

	var_67_0.attackedDamage = var_67_0.attackedDamage + arg_67_2
	var_67_3.processId = arg_67_4.processId
	var_67_3.from = battle.DamageFrom.skill
	var_67_3.segId = var_67_1
	var_67_3.skillDamageId = var_67_0.args.damageId
	var_67_3.isLastDamageSeg = arg_67_4.isLastDamageSeg
	var_67_3.isBeginDamageSeg = arg_67_4.isBeginDamageSeg
	var_67_3.leftDamage = var_67_0.value - var_67_0.attackedDamage
	var_67_3.fromExtra = arg_67_4.fromExtra

	local var_67_4, var_67_5 = arg_67_1:beAttack(arg_67_0.owner, arg_67_2, arg_67_5, var_67_3)

	var_67_0.real:add(var_67_4)
end

function var_0_4.onTarget(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
	local var_68_0 = arg_68_2.process
	local var_68_1 = arg_68_0.processEventCsv[var_68_0.id]
	local var_68_2 = arg_68_0:getTargetsFinalResult(arg_68_1.id, arg_68_2.process.segType)
	local var_68_3

	arg_68_2.values[arg_68_1.id] = arg_68_2.values[arg_68_1.id] or {}

	local var_68_4 = gRootViewProxy:proxy():pushDeferList(arg_68_0.id, var_68_0.id)

	if arg_68_2.process.segType == battle.SkillSegType.damage then
		local var_68_5 = arg_68_0.skillCalDamageProcessId == 1 and 9999 or arg_68_0.skillCalDamageProcessId + 1
		local var_68_6 = var_68_1.damageSeg[arg_68_3]
		local var_68_7 = math.floor(var_68_2.value * var_68_6)
		local var_68_8 = table.deepcopy(var_68_2.args, true)

		if not var_68_2.attackedDamage or arg_68_3 == 1 then
			var_68_2.attackedDamage = 0
		end

		local var_68_9 = var_68_2.value - var_68_2.attackedDamage

		var_68_2.attackedDamage = var_68_2.attackedDamage + var_68_7
		var_68_8.processId = var_68_0.id
		var_68_8.from = battle.DamageFrom.skill
		var_68_8.segId = arg_68_3
		var_68_8.skillDamageId = var_68_2.args.damageId
		var_68_8.isLastDamageSeg = table.length(var_68_1.damageSeg) == arg_68_3
		var_68_8.isBeginDamageSeg = arg_68_3 == 1
		var_68_8.leftDamage = var_68_9
		var_68_7 = arg_68_0.protecterObjs[arg_68_1.id] and 0 or var_68_7

		local var_68_10
		local var_68_11

		var_68_3, var_68_11 = arg_68_1:beAttack(arg_68_0.owner, var_68_7, var_68_5, var_68_8)

		var_68_2.real:add(var_68_3)

		arg_68_5 = arg_68_5 or arg_68_1

		local var_68_12 = {
			isLastSeg = arg_68_4,
			damage = var_68_7,
			damageProcessAfterCal = var_68_5
		}

		arg_68_0:onSputterTarget(arg_68_5, arg_68_2, var_68_2, var_68_8, var_68_12)
		arg_68_0:onPenetrateTarget(arg_68_5, arg_68_2, var_68_2, var_68_8, var_68_12)

		if var_68_11.extraShowValueF then
			var_68_3:add(var_68_11.extraShowValueF)
		end

		if var_68_11.beAttackToDeath then
			arg_68_0:addObjectToKillTab(arg_68_1)
		end

		if arg_68_4 then
			arg_68_0.scene.play:checkBulletTimeShow()
		end
	end

	if arg_68_2.process.segType == battle.SkillSegType.resumeHp and arg_68_0:onHealToDamageTarget(arg_68_1, var_68_0, var_68_2, var_68_1, arg_68_3) then
		local var_68_13 = table.deepcopy(var_68_2.args)

		var_68_13.from = battle.ResumeHpFrom.skill
		var_68_13.ignoreBeHealAddRate = false

		local var_68_14 = var_68_1.hpSeg[arg_68_3]

		var_68_3 = arg_68_1:resumeHp(arg_68_0.owner, math.floor(var_68_2.value * var_68_14), var_68_13)

		var_68_2.real:add(var_68_3)
	end

	arg_68_2.values[arg_68_1.id][arg_68_3] = arg_68_2.values[arg_68_1.id][arg_68_3] or {}
	arg_68_2.values[arg_68_1.id][arg_68_3].value = var_68_3

	if not arg_68_2.values[arg_68_1.id][arg_68_3].deferList then
		arg_68_2.values[arg_68_1.id][arg_68_3].deferList = gRootViewProxy:proxy():popDeferList(var_68_4)
	else
		local var_68_15 = gRootViewProxy:proxy():popDeferList(var_68_4)

		for iter_68_0, iter_68_1 in ipairs(var_68_15) do
			arg_68_2.values[arg_68_1.id][arg_68_3].deferList:push_back(iter_68_1)
		end
	end
end

function var_0_4.addObjectToKillTab(arg_69_0, arg_69_1)
	if not itertools.include(arg_69_0.killedTargetsTb, arg_69_1) then
		table.insert(arg_69_0.killedTargetsTb, arg_69_1)
	end
end

function var_0_4.getTargetsFinalResult(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = arg_70_0.targetsFinalResult[arg_70_1]

	if not var_70_0 then
		var_70_0 = {
			[battle.SkillSegType.damage] = {
				real = battleEasy.valueTypeTable()
			},
			[battle.SkillSegType.resumeHp] = {
				real = battleEasy.valueTypeTable()
			}
		}

		local var_70_1

		var_70_1 = {
			skillMiss = false,
			__index = function(arg_71_0, arg_71_1)
				if var_70_0.damage.args then
					return var_70_0.damage.args[arg_71_1]
				elseif var_70_0.resumeHp.args then
					return var_70_0.resumeHp.args[arg_71_1]
				end

				return var_70_1[arg_71_1]
			end
		}
		var_70_0.args = setmetatable({}, var_70_1)
		arg_70_0.targetsFinalResult[arg_70_1] = var_70_0
	end

	if arg_70_2 then
		return var_70_0[arg_70_2]
	end

	return var_70_0
end

function var_0_4.pairsTargetsFinalResult(arg_72_0, arg_72_1)
	return function(arg_73_0, arg_73_1)
		local var_73_0
		local var_73_1

		arg_73_1, var_73_1 = next(arg_72_0.targetsFinalResult, arg_73_1)

		return arg_73_1, var_73_1 and var_73_1[arg_72_1]
	end, arg_72_0.targetsFinalResult, nil
end

function var_0_4.getTargetDamage(arg_74_0, arg_74_1)
	if arg_74_1.ignoreDamageInBattleRound then
		return 0
	end

	return table.get(arg_74_0.targetsFinalResult, arg_74_1.id, battle.SkillSegType.damage, "value") or 0
end

function var_0_4.chcekTargetInFinalResult(arg_75_0, arg_75_1)
	return battleEasy.ifElse(arg_75_0.targetsFinalResult[arg_75_1], true, false)
end

function var_0_4.calcFormula(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	local var_76_0 = table.get(arg_76_0.targetsFormulaResult, arg_76_3.id, arg_76_1)

	if var_76_0 then
		return var_76_0
	end

	arg_76_0.protectedEnv:resetEnv()

	local var_76_1 = battleCsv.fillFuncEnv(arg_76_0.protectedEnv, {
		target = arg_76_3
	})
	local var_76_2 = battleCsv.doFormula(arg_76_2, var_76_1)

	table.set(arg_76_0.targetsFormulaResult, arg_76_3.id, arg_76_1, var_76_2)

	return var_76_2
end

function var_0_4.processAddBuff(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
	log.battle.skill("processAddBuff", arg_77_0.owner.seat, arg_77_2 and table.length(arg_77_2), arg_77_4)

	if itertools.isempty(arg_77_1.buffList) then
		return
	end

	local var_77_0 = {}
	local var_77_1 = {}

	for iter_77_0, iter_77_1 in ipairs(arg_77_2) do
		if iter_77_1 and not table.get(arg_77_0.targetsFinalResult, iter_77_1.id, "args", "skillMiss") then
			table.insert(var_77_1, iter_77_1)
		end
	end

	for iter_77_2, iter_77_3 in ipairs(arg_77_1.buffList) do
		local var_77_2 = csv.buff[iter_77_3]

		if not var_77_2 then
			printError(string.format("id(%s) not in csv.buff", iter_77_3))
		end

		if var_77_2.skillTimePos == arg_77_4 then
			for iter_77_4, iter_77_5 in ipairs(var_77_1) do
				local var_77_3

				if arg_77_4 == battle.SkillAddBuffType.InPlay then
					var_77_3 = gRootViewProxy:proxy():pushDeferList(arg_77_0.id, arg_77_1.id, "buffDelay")
				end

				arg_77_0:addProcessBuffBefore(iter_77_3, iter_77_5, arg_77_0.owner, var_77_2)

				local var_77_4 = BuffArgs.fromSkill(arg_77_0, arg_77_3, iter_77_5, arg_77_1, var_77_2, iter_77_2)
				local var_77_5 = arg_77_0:addProcessBuff(iter_77_3, iter_77_5, arg_77_0.owner, var_77_2, var_77_4)

				if var_77_5 then
					iter_77_5:onPassive(var_0_3.additional, iter_77_5, {
						buffCfgId = var_77_5.cfgId
					})
				end

				if arg_77_4 == battle.SkillAddBuffType.InPlay then
					var_77_0[iter_77_5.id] = gRootViewProxy:proxy():popDeferList(var_77_3)
				end
			end
		end
	end

	if itertools.isempty(var_77_0) then
		return
	end

	return var_77_0
end

function var_0_4.addProcessBuffBefore(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	return
end

function var_0_4.addProcessBuff(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5)
	return (arg_79_0.scene:getGroupBuffId(arg_79_4.easyEffectFunc) and addBuffToScene or addBuffToHero)(arg_79_1, arg_79_2, arg_79_3, arg_79_5)
end

function var_0_4.getLeftCDRound(arg_80_0)
	if arg_80_0.cdRound == 0 then
		return 0
	end

	local var_80_0 = arg_80_0.owner:getBattleRound(2)

	return arg_80_0.cdRound - (var_80_0 - arg_80_0.spellRound - 1)
end

function var_0_4.getCurChargingRound(arg_81_0)
	return var_0_1(arg_81_0.owner:getBattleRound(2) - arg_81_0.chargeRound, 3)
end

function var_0_4.saveAllTargets(arg_82_0)
	local var_82_0 = {}

	for iter_82_0, iter_82_1 in maptools.order_pairs(arg_82_0.allProcessesTargets) do
		for iter_82_2, iter_82_3 in ipairs(iter_82_1) do
			if iter_82_3 then
				arg_82_0.allTargets[iter_82_3.id] = iter_82_3

				if not table.get(arg_82_0.targetsFinalResult, iter_82_3.id, "args", "skillMiss") then
					var_82_0[iter_82_3.id] = iter_82_3
				end
			end
		end
	end

	return arg_82_0:targetsMap2Array(var_82_0)
end

function var_0_4.saveAllDamageTargets(arg_83_0)
	local var_83_0 = {}

	for iter_83_0, iter_83_1 in pairs(arg_83_0.allProcessesTargets) do
		local var_83_1 = csv.skill_process[iter_83_0].effectEventID
		local var_83_2 = csv.effect_event[var_83_1]

		if var_83_2 and var_83_2.damageSeg then
			var_83_0[iter_83_0] = iter_83_1
		end
	end

	for iter_83_2, iter_83_3 in maptools.order_pairs(var_83_0) do
		for iter_83_4, iter_83_5 in ipairs(iter_83_3) do
			if iter_83_5 then
				arg_83_0.allDamageTargets[iter_83_5.id] = iter_83_5
			end
		end
	end

	if arg_83_0.owner:isBeInSneer() then
		local var_83_3 = arg_83_0.owner:getSneerExtraArgs(false)

		if var_83_3 == battle.SneerArgType.NoSpread or var_83_3 == battle.SneerArgType.BuffSpread then
			local var_83_4 = arg_83_0.owner:getSneerObj()

			for iter_83_6, iter_83_7 in pairs(arg_83_0.allDamageTargets) do
				if var_83_4 and var_83_4 ~= iter_83_7 then
					arg_83_0.allDamageTargets[iter_83_6] = nil
				end
			end
		end
	end
end

function var_0_4.targetsMap2Array(arg_84_0, arg_84_1)
	local var_84_0 = {}

	for iter_84_0, iter_84_1 in maptools.order_pairs(arg_84_1, "id") do
		table.insert(var_84_0, iter_84_1)
	end

	return var_84_0
end

function var_0_4.interrupt(arg_85_0, arg_85_1, arg_85_2)
	if arg_85_1 == battle.SkillInterruptType.charge then
		arg_85_0:chargingBeInterrupted()
	end

	arg_85_0.interruptBuffId = arg_85_2
end

function var_0_4.interruptBuffId(arg_86_0)
	return arg_86_0.interruptBuffId
end

function var_0_4.chargingBeInterrupted(arg_87_0)
	if arg_87_0.chargeRound then
		battleEasy.deferNotifyCantJump(arg_87_0.owner.view, "playCharge", arg_87_0.chargeArgs.action, true)
	end

	arg_87_0.chargeRound = nil
	arg_87_0.spellRound = arg_87_0.lastSpellRound

	arg_87_0:startDeductMp(true)
	arg_87_0.owner:triggerBuffOnPoint(battle.BuffTriggerPoint.onChargeBeInterrupted)
end

function var_0_4.addAttr(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
	if arg_88_1 == "skillNatureType" then
		arg_88_0[arg_88_1] = arg_88_3 and arg_88_0.cfg[arg_88_1] or arg_88_2
	else
		arg_88_0[arg_88_1] = arg_88_0[arg_88_1] + (arg_88_3 and -arg_88_2 or arg_88_2)
	end
end

function var_0_4.pushDefreListToSkillEnd(arg_89_0, arg_89_1, arg_89_2)
	if arg_89_0.disposeDatasOnSkillEnd[arg_89_1] and arg_89_2 then
		battleEasy.effect(nil, function()
			for iter_90_0, iter_90_1 in arg_89_2:ipairs() do
				arg_89_0.disposeDatasOnSkillEnd[arg_89_1]:push_back(iter_90_1)
			end
		end)
	else
		arg_89_0.disposeDatasOnSkillEnd[arg_89_1] = arg_89_2
	end
end

function var_0_4.pushDefreListAfterComeBack(arg_91_0, arg_91_1, arg_91_2)
	if arg_91_0.disposeDatasAfterComeBack[arg_91_1] and arg_91_2 then
		battleEasy.effect(nil, function()
			for iter_92_0, iter_92_1 in arg_91_2:ipairs() do
				arg_91_0.disposeDatasAfterComeBack[arg_91_1]:push_back(iter_92_1)
			end
		end)
	else
		arg_91_0.disposeDatasAfterComeBack[arg_91_1] = arg_91_2
	end
end

function var_0_4.isSameType(arg_93_0, arg_93_1)
	return battleEasy.isSameSkillType(arg_93_0.skillFormulaType, arg_93_1)
end

function var_0_4.isMainNumShowType(arg_94_0)
	if arg_94_0.skillFormulaType == battle.SkillFormulaType.fix then
		return arg_94_0:getTargetsFinalValue() ~= 0 and battle.SkillFormulaType.damage or battle.SkillFormulaType.resumeHp
	end

	return arg_94_0.skillFormulaType
end

function var_0_4.isNormalSkillType(arg_95_0)
	return arg_95_0.skillType == battle.SkillType.NormalSkill
end

function var_0_4.replaceLethalTargets(arg_96_0, arg_96_1, arg_96_2)
	if not arg_96_0:isSameType(battle.SkillFormulaType.damage) then
		return arg_96_1, arg_96_1
	end

	local var_96_0 = {}
	local var_96_1 = {}
	local var_96_2 = {}

	for iter_96_0, iter_96_1 in ipairs(arg_96_1) do
		local var_96_3
		local var_96_4

		if iter_96_1.force ~= arg_96_0.owner.force then
			var_96_3, var_96_4 = iter_96_1:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.lethalProtect, "tryProtect")
		end

		if var_96_3 then
			table.insert(var_96_1, var_96_3)
			table.insert(var_96_2, iter_96_1)

			if not var_96_4 then
				var_96_0[var_96_3.id] = true
			end
		elseif not arg_96_0.protecterObjs[iter_96_1.id] then
			table.insert(var_96_1, iter_96_1)
			table.insert(var_96_2, false)
		end
	end

	for iter_96_2 = table.length(var_96_1), 1, -1 do
		if var_96_1[iter_96_2] and not var_96_2[iter_96_2] and var_96_0[var_96_1[iter_96_2].id] then
			table.remove(var_96_1, iter_96_2)
			table.remove(var_96_2, iter_96_2)
		end
	end

	if arg_96_2 then
		local var_96_5 = {}

		for iter_96_3 = table.length(var_96_1), 1, -1 do
			if var_96_1[iter_96_3] and var_96_1[iter_96_3].markID == 4171 then
				table.insert(var_96_5, var_96_1[iter_96_3])
				table.remove(var_96_1, iter_96_3)
			end
		end

		for iter_96_4, iter_96_5 in ipairs(var_96_5) do
			table.insert(var_96_1, iter_96_5)
		end
	end

	return var_96_1, var_96_2
end

function var_0_4.filterProtectorView(arg_97_0, arg_97_1, arg_97_2)
	if arg_97_0:isSameType(battle.SkillFormulaType.damage) then
		local var_97_0 = arg_97_1:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.lethalProtect, "getProtectObj")
		local var_97_1 = arg_97_1:getEventByKey(battle.ExRecordEvent.protectTarget)

		var_97_0 = var_97_0 or var_97_1 and var_97_1.obj

		if not var_97_0 then
			return
		end

		if not itertools.include(arg_97_2, var_97_0.view) then
			table.insert(arg_97_2, var_97_0.view)
		end

		return {
			view = var_97_0.view,
			targetID = arg_97_1.seat
		}
	end
end

function var_0_4.getSkillNatureType(arg_98_0)
	local var_98_0 = arg_98_0.owner:getOverlaySpecBuffData(battle.OverlaySpecBuff.changeSkillNature)
	local var_98_1 = var_98_0.skillNatures and var_98_0.skillNatures[arg_98_0.id]

	if var_98_1 then
		return var_98_1
	end

	local var_98_2 = arg_98_0.cfg

	return var_98_2 and var_98_2.skillNatureType
end

function var_0_4.getSkillSceneTag(arg_99_0)
	local var_99_0 = arg_99_0.scene.play.curHero

	return {
		isPossessAttack = arg_99_0.owner:isPossessAttack(arg_99_0.skillType),
		isPlaySkill = var_99_0 and var_99_0.curSkill == arg_99_0,
		isBigSkill = arg_99_0.skillType2 == battle.MainSkillType.BigSkill
	}
end

function var_0_4.setCsvObject(arg_100_0, arg_100_1)
	arg_100_0.csvObject = arg_100_1
end

function var_0_4.getCsvObject(arg_101_0)
	return arg_101_0.csvObject
end

function var_0_4.toHumanString(arg_102_0)
	return string.format("SkillModel: %s", arg_102_0.id)
end
