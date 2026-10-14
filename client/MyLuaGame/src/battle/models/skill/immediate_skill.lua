local var_0_0 = class("BuffSkillModel", battleSkill.SkillModel)

battleSkill.BuffSkillModel = var_0_0

function var_0_0.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	battleSkill.SkillModel.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	local var_1_0 = arg_1_0.cfg.skillArgs or {}

	arg_1_0.cantShowText = false
	arg_1_0.buffValues = {}
	arg_1_0.effectOnce = battleEasy.ifElse(var_1_0[1] ~= nil, var_1_0[1], false)
	arg_1_0.isFixValue = battleEasy.ifElse(var_1_0[2] ~= nil, var_1_0[2], true)
end

function var_0_0.canSpell(arg_2_0)
	return not arg_2_0.owner:isDeath()
end

function var_0_0.onTrigger(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0.skillType ~= battle.SkillType.PassiveAura or arg_3_1 ~= "Aura" then
		return
	end

	if arg_3_0.owner:isLeaveField() then
		return
	end

	if arg_3_0:canSpell() then
		arg_3_0:spellTo(arg_3_2, arg_3_3)

		arg_3_0.cantShowText = true
	end
end

function var_0_0.isAttackSkill(arg_4_0)
	return false
end

function var_0_0._spellTo(arg_5_0, arg_5_1, arg_5_2)
	log.battle.passiveSkill.spellTo("spellTo", arg_5_0.owner.id, arg_5_0.id, "target", (arg_5_1 or {}).id)
	battleSkill.SkillModel._spellTo(arg_5_0, arg_5_1)
end

function var_0_0.addProcessBuffBefore(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2:getBuff(arg_6_1)

	if var_6_0 then
		var_6_0:alterAuraBuffValue(0)
	end
end

function var_0_0.addProcessBuff(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if arg_7_0.effectOnce then
		arg_7_5.value = arg_7_0.buffValues[arg_7_2.id] or arg_7_5.value
	end

	arg_7_5.isAuraType = true
	arg_7_5.cantShowText = arg_7_0.cantShowText
	arg_7_5.isFixValue = arg_7_0.isFixValue

	local var_7_0, var_7_1 = addBuffToHero(arg_7_1, arg_7_2, arg_7_3, arg_7_5)
	local var_7_2 = var_7_0 or arg_7_2:getBuff(arg_7_1)

	if var_7_1 then
		if arg_7_0.effectOnce and not arg_7_0.buffValues[arg_7_2.id] then
			arg_7_0.buffValues[arg_7_2.id] = arg_7_5.value
		end

		if var_7_2 then
			var_7_2:addCaster(arg_7_0.owner)
			arg_7_0.owner.auraBuffs:insert(var_7_2.id, var_7_2)
		end
	end

	if var_7_2 and not assertInWindows(var_7_2.alterAuraBuffValue, "not aura buff skill:%d, buff:%d", arg_7_0.id, var_7_2.cfgId) then
		var_7_2:alterAuraBuffValue(arg_7_5.value)
	end

	return var_7_0
end

function var_0_0.onSpellView(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.owner.view

	battleEasy.queueNotifyFor(var_8_0, "skillBefore", arg_8_0.disposeDatasOnSkillStart, arg_8_0.skillType)
	battleEasy.queueNotifyFor(var_8_0, "objSkillEnd", arg_8_0.disposeDatasOnSkillEnd, arg_8_0.skillType)
	battleEasy.queueNotifyFor(var_8_0, "afterComeBack", arg_8_0.disposeDatasAfterComeBack)
	battleEasy.queueNotifyFor(var_8_0, "objSkillOver")
end

function var_0_0.toHumanString(arg_9_0)
	return string.format("BuffSkillModel: %s", arg_9_0.id)
end
