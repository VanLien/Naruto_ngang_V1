local var_0_0 = battle.PassiveSkillTypes
local var_0_1
local var_0_2 = class("PassiveSkillModel", battleSkill.SkillModel)

battleSkill.PassiveSkillModel = var_0_2

local var_0_3 = {
	[var_0_0.beDeathAttack] = true,
	[var_0_0.realDead] = true,
	[var_0_0.create] = true
}

function var_0_2.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	battleSkill.SkillModel.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	arg_1_0.type = arg_1_3.passiveTriggerType
	arg_1_0.startRound = arg_1_3.passiveStartRound
	arg_1_0.skillMuteTimeCheck = nil
end

function var_0_2.canSpell(arg_2_0)
	if arg_2_0.owner:isDeath() and not var_0_3[arg_2_0.type] then
		return false
	end

	if arg_2_0.costMp1 and arg_2_0.costMp1 > 0 then
		return arg_2_0.owner:mp1() >= arg_2_0.costMp1
	end

	if not arg_2_0.cfg.alwaysEffective and arg_2_0.owner:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
		skillType2 = arg_2_0.skillType2
	}) then
		return false
	end

	arg_2_0:updateSkillMuteTimeCheck()

	if arg_2_0.skillMuteTimeCheck == false then
		return false
	end

	return arg_2_0:getLeftCDRound() < 1
end

function var_0_2.updateSkillMuteTimeCheck(arg_3_0)
	if arg_3_0.skillMuteTimeCheck ~= nil then
		return
	end

	if arg_3_0.cfg.allEffectTime and table.length(arg_3_0.cfg.allEffectTime) > 0 then
		local var_3_0 = arg_3_0.scene:getEventByKey(battle.ExRecordEvent.skillEffectLimit, arg_3_0.id, arg_3_0.owner.force)
		local var_3_1 = arg_3_0.cfg.allEffectTime[1]
		local var_3_2

		for iter_3_0 = 2, table.length(arg_3_0.cfg.allEffectTime) do
			local var_3_3 = arg_3_0.cfg.allEffectTime[iter_3_0]

			if arg_3_0.scene.gateType == var_3_3[1] then
				var_3_1 = var_3_3[2]

				break
			end
		end

		if not var_3_0 or var_3_1 > table.length(var_3_0) then
			if not itertools.include(var_3_0, arg_3_0.owner.id) then
				arg_3_0.scene:addExRecord(battle.ExRecordEvent.skillEffectLimit, arg_3_0.owner.id, arg_3_0.id, arg_3_0.owner.force)
			end
		else
			arg_3_0.skillMuteTimeCheck = false

			return
		end
	end

	arg_3_0.skillMuteTimeCheck = true
end

function var_0_2.isAttackSkill(arg_4_0)
	return false
end

function var_0_2._spellTo(arg_5_0, arg_5_1, arg_5_2)
	log.battle.skill.passiveSkill("trigger", arg_5_0.owner.seat, arg_5_0.id, "target", arg_5_1 and arg_5_1.seat, "args", dumps(arg_5_2))

	if arg_5_0:trigger(arg_5_1, arg_5_2) then
		log.battle.skill.passiveSkill("spellTo", arg_5_0.owner.seat, arg_5_0.id, "target", arg_5_1 and arg_5_1.seat)
		battleSkill.SkillModel._spellTo(arg_5_0, arg_5_1)
	end
end

function var_0_2.trigger(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = var_0_1[arg_6_0.type]

	arg_6_2 = arg_6_2 or {}
	arg_6_2.passiveTriggerArg = arg_6_0.cfg.passiveTriggerArg

	return var_6_0(arg_6_0, arg_6_1, arg_6_2)
end

function var_0_2.onTrigger(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_0.type > 0 and arg_7_1 ~= arg_7_0.type then
		return
	end

	if not arg_7_0.owner:effectPowerControl(battle.EffectPowerType.passiveSkill, arg_7_1) then
		return
	end

	if arg_7_0:canSpell() then
		arg_7_0:spellTo(arg_7_2, arg_7_3)
	end
end

function var_0_2.processBefore(arg_8_0, arg_8_1)
	arg_8_1.isDeath = arg_8_0.owner:isDeath()

	battleSkill.SkillModel.processBefore(arg_8_0, arg_8_1)
end

function var_0_2.onSpellView(arg_9_0, arg_9_1)
	if arg_9_1.isDeath then
		return
	end

	local var_9_0 = arg_9_1.target
	local var_9_1 = arg_9_1.lastPosIdx
	local var_9_2 = arg_9_0.disposeDatasOnSkillStart
	local var_9_3 = arg_9_0.disposeDatasOnSkillEnd
	local var_9_4 = arg_9_0.disposeDatasAfterComeBack
	local var_9_5 = arg_9_0.scene:beInExtraAttack()

	battleEasy.deferCallback(function()
		log.battle.skill.onSpellView(" PassiveSkill onSpellView target.id=", var_9_0 and var_9_0.seat, "move pos=", var_9_1)

		local var_10_0 = arg_9_0.owner.view
		local var_10_1 = arg_9_0.cfg
		local var_10_2 = 0
		local var_10_3 = var_10_1.actionTime or 0
		local var_10_4 = true

		gRootViewProxy:proxy():onEventEffect(arg_9_0.owner, "callback", {
			func = function()
				var_10_0:proxy():onMoveToTarget(var_9_1, {
					moveTime = var_10_1.moveTime,
					timeScale = var_9_5 and 0.51,
					cameraNear = var_10_1.cameraNear,
					cameraNear_posC = var_10_1.cameraNear_posC,
					posC = var_10_1.posC
				}, var_10_4)
				var_10_0:proxy():onSkillBefore(var_9_2, arg_9_0.skillType, var_10_4, arg_9_0:getSkillSceneTag())
				var_10_0:proxy():onPlayAction(var_10_1.spineAction, var_10_3, var_10_4)
			end,
			delay = var_10_2
		})
		gRootViewProxy:proxy():onEventEffect(arg_9_0.owner, "callback", {
			func = function()
				for iter_12_0, iter_12_1 in arg_9_0:ipairsProcess() do
					var_10_0:proxy():onProcessDel(iter_12_1.id)
				end

				var_10_0:proxy():onObjSkillEnd(var_9_3, arg_9_0.skillType, var_10_4)
				var_10_0:proxy():onComeBack(var_9_1, false, {
					moveTime = var_10_1.moveTime,
					timeScale = var_9_5 and 0.51,
					flashBack = var_10_1.flashBack
				})
				var_10_0:proxy():onAfterComeBack(var_9_4, var_10_4)
				var_10_0:proxy():onObjSkillOver(var_10_4)
			end,
			delay = var_10_2 + var_10_3
		})
	end)
end

local function var_0_4(arg_13_0, arg_13_1, arg_13_2)
	return true
end

local function var_0_5(arg_14_0, arg_14_1, arg_14_2)
	return
end

var_0_1 = {
	[var_0_0.create] = var_0_4,
	[var_0_0.round] = function(arg_15_0, arg_15_1, arg_15_2)
		return arg_15_0.scene.play.curRound == arg_15_2.passiveTriggerArg
	end,
	[var_0_0.cycleRound] = function(arg_16_0, arg_16_1, arg_16_2)
		local var_16_0 = arg_16_0.scene.play.curRound

		return var_16_0 > 0 and (var_16_0 - 1) % (arg_16_2.passiveTriggerArg + 1) == 0
	end,
	[var_0_0.realDead] = var_0_4,
	[var_0_0.fakeDead] = var_0_4,
	[var_0_0.beDeathAttack] = var_0_4,
	[var_0_0.beAttack] = function(arg_17_0, arg_17_1, arg_17_2)
		return not arg_17_2.miss
	end,
	[var_0_0.enter] = var_0_4,
	[var_0_0.attack] = var_0_4,
	[var_0_0.roundEnd] = function(arg_18_0, arg_18_1, arg_18_2)
		if not arg_18_2.passiveTriggerArg then
			return
		end

		return arg_18_2.roundFlag == arg_18_2.passiveTriggerArg
	end,
	[var_0_0.kill] = var_0_4,
	[var_0_0.beSpecialNatureDamage] = function(arg_19_0, arg_19_1, arg_19_2)
		return arg_19_2.natureType == arg_19_2.passiveTriggerArg
	end,
	[var_0_0.beStrike] = function(arg_20_0, arg_20_1, arg_20_2)
		return arg_20_2.strike
	end,
	[var_0_0.beNatureDamage] = function(arg_21_0, arg_21_1, arg_21_2)
		return arg_21_2.natureFlag == "strong"
	end,
	[var_0_0.beNonNatureDamage] = function(arg_22_0, arg_22_1, arg_22_2)
		return arg_22_2.natureFlag ~= "strong"
	end,
	[var_0_0.beDamageIfFullHp] = function(arg_23_0, arg_23_1, arg_23_2)
		return arg_23_2.isFullHp
	end,
	[var_0_0.beDamage] = function(arg_24_0, arg_24_1, arg_24_2)
		return arg_24_2.type == 0
	end,
	[var_0_0.beSpecialDamage] = function(arg_25_0, arg_25_1, arg_25_2)
		return arg_25_2.type ~= 0
	end,
	[var_0_0.hpLess] = function(arg_26_0, arg_26_1, arg_26_2)
		return arg_26_0.owner:hp() / arg_26_0.owner:hpMax() < arg_26_2.passiveTriggerArg / ConstSaltNumbers.wan
	end,
	[var_0_0.beSpeciaSelfForce] = var_0_5,
	[var_0_0.beWeather] = var_0_5,
	[var_0_0.beSpeciaBuff] = var_0_5,
	[var_0_0.beToolsComsumed] = var_0_5,
	[var_0_0.roundStartAttack] = var_0_4,
	[var_0_0.teamHpLess] = function(arg_27_0, arg_27_1, arg_27_2)
		for iter_27_0, iter_27_1 in arg_27_2.objs:order_pairs() do
			if iter_27_1:hp() / iter_27_1:hpMax() < arg_27_2.passiveTriggerArg / ConstSaltNumbers.wan then
				return true
			end
		end

		return false
	end,
	[var_0_0.recoverHp] = function(arg_28_0, arg_28_1, arg_28_2)
		return arg_28_2.hpFormula and arg_28_2.skillType == battle.SkillType.NormalSkill
	end,
	[var_0_0.additional] = function(arg_29_0, arg_29_1, arg_29_2)
		return arg_29_2.passiveTriggerArg == arg_29_2.buffCfgId
	end,
	[var_0_0.roundStart] = var_0_4
}
var_0_1[var_0_0.dynamicHpLess] = var_0_1[var_0_0.hpLess]
var_0_1[var_0_0.dynamicTeamHpLess] = var_0_1[var_0_0.teamHpLess]
