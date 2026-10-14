local var_0_0 = battle.PassiveSkillTypes
local var_0_1 = class("CombineSkillModel", battleSkill.SkillModel)

battleSkill.CombineSkillModel = var_0_1

local var_0_2 = {
	[var_0_0.roundStartAttack] = battle.CombineSkillType.smallRoundStart,
	[var_0_0.roundEnd] = battle.CombineSkillType.smallRoundEnd,
	[var_0_0.roundStart] = battle.CombineSkillType.bigRoundStart
}

function var_0_1.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	battleSkill.SkillModel.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
end

function var_0_1.onTrigger(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if arg_2_0:isCanUseCombineSkill(var_0_2[arg_2_1]) then
		arg_2_0.scene.play.curHero = arg_2_0.owner
		arg_2_2 = arg_2_0.scene.play:autoChoose(arg_2_0.id)
		arg_2_0.owner.curSkill = arg_2_0
		arg_2_0.owner.curTargetId = arg_2_2.id

		if arg_2_0:canSpell() then
			arg_2_0.isPassiveRelease = true
			arg_2_0.combineType = var_0_2[arg_2_1]

			arg_2_0:spellTo(arg_2_2)
		end
	end
end

local function var_0_3(arg_3_0)
	return not arg_3_0:isDeath() and not arg_3_0:isSelfControled() and not arg_3_0:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
		skillType2 = battle.MainSkillType.BigSkill
	})
end

function var_0_1.isCanUseCombineSkill(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.cfg.conditionValue

	if not var_4_0 then
		return false
	end

	if var_4_0[1] ~= arg_4_1 then
		return false
	end

	local var_4_1 = false
	local var_4_2

	for iter_4_0, iter_4_1 in arg_4_0.scene:getHerosMap(arg_4_0.owner.force):order_pairs() do
		if iter_4_1 and iter_4_1.cardID and var_0_3(iter_4_1) and iter_4_1.markID == arg_4_0.owner.unitCfg.combinationObjCardId then
			var_4_1 = true

			local var_4_3 = iter_4_1.id

			arg_4_0.owner.combineObj = iter_4_1

			break
		end
	end

	if not var_4_1 then
		return false
	end

	if not arg_4_0.owner.useCombineSkillCount then
		arg_4_0.owner.useCombineSkillCount = 0
	end

	if not arg_4_0.owner.combineObj.useCombineSkillCount then
		arg_4_0.owner.combineObj.useCombineSkillCount = 0
	end

	local var_4_4 = csv.skill[arg_4_0.owner.combineObj.unitCfg.combinationSkillId]

	if math.min(var_4_0[3], var_4_4.conditionValue[3]) <= arg_4_0.owner.useCombineSkillCount + arg_4_0.owner.combineObj.useCombineSkillCount then
		return false
	end

	arg_4_0.protectedEnv:resetEnv()

	local var_4_5 = battleCsv.fillFuncEnv(arg_4_0.protectedEnv, {})

	if battleCsv.doFormula(var_4_0[2], var_4_5) < 1 then
		return false
	end

	return true
end

function var_0_1.canSpell(arg_5_0)
	if not var_0_3(arg_5_0.owner) then
		return false
	end

	local var_5_0 = arg_5_0:getTargetsHint()
	local var_5_1 = arg_5_0.owner:getSneerObj()

	if var_5_1 and var_5_1:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
		fromObj = arg_5_0.owner
	}) then
		if arg_5_0.owner:isBeInDuel() then
			return false
		else
			var_5_0 = arg_5_0.owner:getCanAttackObjs(var_5_1.force)
		end
	end

	if table.length(var_5_0) == 0 then
		return false
	end

	return arg_5_0:getLeftCDRound() < 1
end

function var_0_1.isJumpBigSkill(arg_6_0)
	return false
end

function var_0_1.updateRecord(arg_7_0)
	arg_7_0.owner:addExRecord(arg_7_0.skillType2, 1)
end

function var_0_1.spellToOver(arg_8_0, arg_8_1)
	arg_8_0:averageSelfDamageAttributesWithCombineObj(true)

	arg_8_0.isPassiveRelease = nil

	return battleSkill.SkillModel.spellToOver(arg_8_0, arg_8_1)
end

function var_0_1.onSpellView(arg_9_0, arg_9_1)
	local function var_9_0()
		battleEasy.deferNotify(nil, "hideAllObjsSkillTips")
		battleEasy.deferNotify(nil, "showHero", {
			typ = "showAll",
			hideLife = true
		})
		gRootViewProxy:proxy():flushCurDeferList()
		arg_9_0:_onSpellView(arg_9_1)
	end

	if arg_9_0.combineType and arg_9_0.combineType == battle.CombineSkillType.smallRoundEnd then
		battleEasy.queueEffect(function()
			var_9_0()
		end)
	else
		var_9_0()
	end
end

function var_0_1._onSpellView(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.target
	local var_12_1 = arg_12_1.lastPosIdx
	local var_12_2 = arg_12_0.scene
	local var_12_3 = arg_12_0.owner.view
	local var_12_4 = arg_12_0.owner.combineObj.view
	local var_12_5 = arg_12_0.cfg
	local var_12_6 = arg_12_0:targetsMap2Array(arg_12_0.allTargets)
	local var_12_7

	log.battle.skill("onSpellView target.id=", var_12_0 and var_12_0.seat, "move pos=", var_12_1)

	arg_12_0.owner.flashBack = var_12_5.flashBack

	var_12_3:proxy():setSkillJumpSwitch(arg_12_0.canjumpBigSkill)

	for iter_12_0, iter_12_1 in arg_12_0:ipairsProcess() do
		if iter_12_1.effectEventID then
			local var_12_8 = arg_12_0.processEventCsv[iter_12_1.id]

			if var_12_8 and var_12_8.control then
				battleEasy.queueEffect("control", var_12_8.control)
			end
		end
	end

	local var_12_9 = {}

	for iter_12_2 = 1, arg_12_0.scene.play.ObjectNumber do
		local var_12_10 = arg_12_0.scene:getObjectBySeat(iter_12_2)
		local var_12_11 = arg_12_0.scene:getObjectBySeat(iter_12_2, battle.ObjectType.SummonFollow)

		if var_12_10 and not arg_12_0.allTargets[var_12_10.id] and var_12_10.id ~= arg_12_0.owner.id and var_12_10.id ~= arg_12_0.owner.combineObj.id then
			var_12_9[iter_12_2] = tostring(var_12_10)
		end

		if var_12_11 and not arg_12_0.allTargets[var_12_11.id] and var_12_11.id ~= arg_12_0.owner.id and var_12_11.id ~= arg_12_0.owner.combineObj.id then
			var_12_9[iter_12_2 + arg_12_0.scene.play.ObjectNumber] = tostring(var_12_11)
		end
	end

	battleEasy.queueEffect("sound", {
		delay = 0,
		sound = {
			loop = 0,
			res = "skill2_effect.mp3"
		}
	})
	battleEasy.queueEffect(function()
		gRootViewProxy:notify("ultSkillPreAni1")
		gRootViewProxy:notify("ultSkillPreAni2", tostring(arg_12_0.owner), var_12_5, var_12_9)
		gRootViewProxy:notify("objMainSkill")
	end)
	battleEasy.queueEffect("delay", {
		lifetime = 2000
	})
	battleEasy.queueEffect(function()
		local var_14_0 = var_12_0.view:proxy():getMovePosZ()

		for iter_14_0, iter_14_1 in ipairs(var_12_6) do
			var_14_0 = math.max(var_14_0, iter_14_1.view:proxy():getMovePosZ())
		end

		var_12_3:proxy():setLocalZOrder(var_14_0 + 1)
	end)

	if arg_12_0.counterAttackForView then
		var_12_3:proxy():onShowCounterAttackText(tostring(arg_12_0.owner))

		arg_12_0.counterAttackForView = false
	end

	var_12_3:proxy():onSkillBefore(arg_12_0.disposeDatasOnSkillStart, arg_12_0.skillType, false, arg_12_0:getSkillSceneTag())
	var_12_3:proxy():onAttacting(true)

	if var_12_5.sound and not arg_12_0.canjumpBigSkill then
		battleEasy.queueEffect("sound", {
			delay = var_12_5.sound.delay,
			sound = {
				res = var_12_5.sound.res,
				loop = var_12_5.sound.loop
			}
		})
	end

	local var_12_12 = {}

	for iter_12_3, iter_12_4 in ipairs(arg_12_0.actionSegArgs) do
		if not var_12_7 or var_12_7 and var_12_7.id ~= iter_12_4.target.id then
			var_12_3:proxy():onMoveToTarget(iter_12_4.posIdx, {
				delayBeforeMove = var_12_5.moveTime[1],
				moveCostTime = var_12_5.moveTime[2],
				timeScale = arg_12_0.scene:beInExtraAttack() and 0.51,
				cameraNear = var_12_5.cameraNear,
				cameraNear_posC = var_12_5.cameraNear_posC,
				posC = var_12_5.posC,
				attackFriend = arg_12_0.owner:needAlterForce()
			}, false, tostring(iter_12_4.target), arg_12_0:filterProtectorView(iter_12_4.target, var_12_12))
		end

		var_12_7 = iter_12_4.target

		var_12_3:proxy():onPlayAction(iter_12_4.spine, iter_12_4.lifeTime)
	end

	if arg_12_0.canjumpBigSkill then
		local var_12_13, var_12_14 = arg_12_0:getTargetsFinalValue()
		local var_12_15 = var_12_13
		local var_12_16 = battle.SkillSegType.damage

		if var_12_13 == 0 and arg_12_0:isSameType(battle.SkillFormulaType.resumeHp) then
			var_12_15, var_12_16 = var_12_14, battle.SkillSegType.resumeHp
		end

		local var_12_17 = {
			delta = var_12_15,
			skillId = var_12_5.id,
			typ = var_12_16
		}

		var_12_3:proxy():onUltJumpShowNum(var_12_17)
	end

	var_12_3:proxy():onObjSkillEnd(arg_12_0.disposeDatasOnSkillEnd, arg_12_0.skillType)
	var_12_3:proxy():onComeBack(var_12_1, false, {
		delayBeforeBack = var_12_5.moveTime[3],
		backCostTime = var_12_5.moveTime[4],
		timeScale = arg_12_0.scene:beInExtraAttack() and 0.51,
		flashBack = var_12_5.flashBack,
		attackFriend = arg_12_0.owner:needAlterForce()
	}, false, var_12_12)
	var_12_3:proxy():onAfterComeBack(arg_12_0.disposeDatasAfterComeBack)
	var_12_3:proxy():onAttacting(false)
	var_12_3:proxy():onResetPos()
	var_12_3:proxy():onObjSkillOver()
end

function var_0_1.startDeductMp(arg_15_0, arg_15_1)
	if arg_15_0.hadDeductedMp then
		arg_15_0.hadDeductedMp = false

		return
	end

	if arg_15_0.owner.exAttackArgs and arg_15_0.owner.exAttackArgs.costType == 1 then
		return
	end

	if arg_15_0:isNormalSkillType() then
		arg_15_0.owner:setMP1(0, 0)

		if arg_15_0.cfg.conditionValue[5] and arg_15_0.cfg.conditionValue[5] > 0 then
			arg_15_0.owner.combineObj:setMP1(0, 0)
		end

		return
	end
end

function var_0_1.startSpell(arg_16_0)
	arg_16_0.owner.useCombineSkillCount = arg_16_0.owner.useCombineSkillCount + 1

	arg_16_0:averageSelfDamageAttributesWithCombineObj()
	battleSkill.SkillModel.startSpell(arg_16_0)
end

local var_0_4 = {
	{
		"damage",
		false
	},
	{
		"specialDamage",
		false
	},
	{
		"strike",
		true
	},
	{
		"strikeDamage",
		true
	},
	{
		"defenceIgnore",
		true
	},
	{
		"specialDefenceIgnore",
		true
	},
	{
		"breakBlock",
		true
	},
	{
		"ultimateAdd",
		true
	},
	{
		"damageAdd",
		true
	},
	{
		"damageReduce",
		true
	},
	{
		"physicalDamageAdd",
		true
	},
	{
		"specialDamageAdd",
		true
	},
	{
		"pvpDamageAdd",
		true
	},
	{
		"normalDamageAdd",
		true
	},
	{
		"fireDamageAdd",
		true
	},
	{
		"waterDamageAdd",
		true
	},
	{
		"grassDamageAdd",
		true
	},
	{
		"electricityDamageAdd",
		true
	},
	{
		"iceDamageAdd",
		true
	},
	{
		"combatDamageAdd",
		true
	},
	{
		"poisonDamageAdd",
		true
	},
	{
		"groundDamageAdd",
		true
	},
	{
		"flyDamageAdd",
		true
	},
	{
		"superDamageAdd",
		true
	},
	{
		"wormDamageAdd",
		true
	},
	{
		"rockDamageAdd",
		true
	},
	{
		"ghostDamageAdd",
		true
	},
	{
		"dragonDamageAdd",
		true
	},
	{
		"evilDamageAdd",
		true
	},
	{
		"steelDamageAdd",
		true
	},
	{
		"fairyDamageAdd"
	}
}

function var_0_1.averageSelfDamageAttributesWithCombineObj(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.cfg.conditionValue and arg_17_0.cfg.conditionValue[4] or 0.5

	if not arg_17_1 then
		local var_17_1 = {}

		for iter_17_0, iter_17_1 in ipairs(var_0_4) do
			local var_17_2 = arg_17_0.owner[iter_17_1[1]](arg_17_0.owner)
			local var_17_3 = arg_17_0.owner.combineObj[iter_17_1[1]](arg_17_0.owner.combineObj)

			var_17_1[iter_17_1[1]] = (iter_17_1[2] and 10000 or 1) * ((var_17_2 + var_17_3) * var_17_0 - var_17_2)
		end

		var_17_1.hit = 10000 - arg_17_0.owner:hit() * 10000
		var_17_1.damageHit = 10000 - arg_17_0.owner:damageHit() * 10000
		arg_17_0.combineDamageAttrsAddFixTb = var_17_1
	end

	if not arg_17_0.combineDamageAttrsAddFixTb then
		return
	end

	local var_17_4 = arg_17_1 and -1 or 1

	itertools.each(arg_17_0.combineDamageAttrsAddFixTb, function(arg_18_0, arg_18_1)
		arg_17_0.owner:objAddBuffAttr(arg_18_0, var_17_4 * arg_18_1)
	end)
end

function var_0_1.isNormalSkillType(arg_19_0)
	return not arg_19_0.isPassiveRelease
end
