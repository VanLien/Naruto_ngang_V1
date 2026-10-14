local var_0_0 = {
	isSelfInCharging = 0,
	isSelfChargeOK = 0,
	getBuffOverlayCount = 0,
	getSameBuffCount = 0
}
local var_0_1 = battleCsv.newCsvCls("CsvObject")

var_0_1.ignoreModelCheck = {
	curSkill = true,
	getBuff = true,
	attackerSkill = true,
	selectCsvTarget = true
}
battleCsv.CsvObject = var_0_1

function var_0_1.skillLv(arg_1_0, ...)
	for iter_1_0, iter_1_1 in ipairs({
		...
	}) do
		local var_1_0 = arg_1_0.model.skills[iter_1_1] or arg_1_0.model.passiveSkills[iter_1_1]

		if var_1_0 then
			return var_1_0:getLevel()
		end
	end

	return 1
end

function var_0_1.selectCsvTarget(arg_2_0)
	local var_2_0 = arg_2_0.model and arg_2_0.model:getCurTarget()

	if var_2_0 then
		if var_2_0:getCsvObject() == nil then
			battleCsv.CsvObject.new(var_2_0)
			assert(var_2_0:getCsvObject(), "object csv object was nil")
		end

		return var_2_0:getCsvObject()
	end

	return battleCsv.NilObject
end

function var_0_1.getPossessTarget(arg_3_0)
	local var_3_0 = arg_3_0.model and arg_3_0.model:getEventByKey(battle.ExRecordEvent.possessTarget)

	if var_3_0 then
		return battleCsv.CsvObject.new(var_3_0)
	end

	return battleCsv.CsvObject.new()
end

function var_0_1.isBeControlled(arg_4_0)
	return arg_4_0.model:isSelfControled() or arg_4_0.model:isSelfForceConfusionAndNoTarget()
end

function var_0_1.skillCanUse(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 and {
		[arg_5_1] = true
	} or {
		[battle.MainSkillType.SmallSkill] = true,
		[battle.MainSkillType.BigSkill] = true,
		[battle.MainSkillType.NormalSkill] = true
	}
	local var_5_1 = true

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if iter_5_1 then
			var_5_1 = var_5_1 and not arg_5_0.model:isLogicStateExit(battle.ObjectLogicState.cantUseSkill, {
				skillType2 = iter_5_0
			})
		end
	end

	return var_5_1
end

function var_0_1.nature(arg_6_0, arg_6_1)
	return arg_6_0.model:getNatureType(arg_6_1 or 1)
end

function var_0_1.id(arg_7_0)
	return arg_7_0.model.seat
end

function var_0_1.cardID(arg_8_0)
	return arg_8_0.model.cardID
end

function var_0_1.unitID(arg_9_0)
	return arg_9_0.model.unitID
end

function var_0_1.markID(arg_10_0)
	return arg_10_0.model.markID
end

function var_0_1.star(arg_11_0)
	return arg_11_0.model:getStar()
end

function var_0_1.rarity(arg_12_0)
	return arg_12_0.model.rarity
end

function var_0_1.flag(arg_13_0, arg_13_1)
	return arg_13_0.model.battleFlag[arg_13_1] or false
end

function var_0_1.level(arg_14_0)
	return arg_14_0.model.level
end

function var_0_1.force(arg_15_0)
	return arg_15_0.model.force
end

function var_0_1.isRealDeath(arg_16_0)
	return arg_16_0.model:isRealDeath()
end

function var_0_1.isAlreadyDead(arg_17_0)
	return arg_17_0.model:isAlreadyDead()
end

function var_0_1.hp(arg_18_0)
	return arg_18_0.model:hp()
end

function var_0_1.lostHp(arg_19_0)
	return math.max(0, arg_19_0.model:hpMax() - arg_19_0.model:hp())
end

function var_0_1.mp1(arg_20_0)
	return arg_20_0.model:mp1()
end

function var_0_1.mp1PointOrValue(arg_21_0)
	local var_21_0 = arg_21_0.model:getOverlaySpecBuffByIdx("mp1OverFlow")

	if var_21_0 then
		local var_21_1 = arg_21_0.model:mpOverflow()

		if var_21_0.mode == 1 then
			return math.floor(var_21_1 / var_21_0.rate)
		else
			return var_21_1
		end
	end

	return 0
end

function var_0_1.curSkill(arg_22_0)
	if arg_22_0.model and arg_22_0.model.curSkill then
		local var_22_0 = arg_22_0.model.curSkill

		if var_22_0:getCsvObject() == nil then
			battleCsv.CsvSkill.new(var_22_0)
			assert(var_22_0:getCsvObject(), "skill csv object was nil")
		end

		return var_22_0:getCsvObject()
	end

	return battleCsv.NilSkill
end

function var_0_1.attackerSkill(arg_23_0)
	if arg_23_0.model and arg_23_0.model.attackerCurSkill then
		local var_23_0 = table.length(arg_23_0.model.attackerCurSkill)
		local var_23_1 = arg_23_0.model.attackerCurSkill[var_23_0]

		if var_23_1 then
			if var_23_1:getCsvObject() == nil then
				battleCsv.CsvSkill.new(var_23_1)
				assert(var_23_1:getCsvObject(), "skill csv object was nil")
			end

			return var_23_1:getCsvObject()
		end
	end

	return battleCsv.NilSkill
end

function var_0_1.getDamageStateByTarget(arg_24_0, arg_24_1, arg_24_2)
	return arg_24_0:curSkill():getDamageStateByTarget(arg_24_1, arg_24_2)
end

function var_0_1.getDamageState(arg_25_0, arg_25_1)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.model.curSkill.targetsFinalResult) do
		local var_25_0 = table.get(iter_25_1, "args", arg_25_1)

		if var_25_0 then
			return var_25_0
		end
	end
end

function var_0_1.getDamageStateToMe(arg_26_0, arg_26_1)
	local var_26_0 = table.length(arg_26_0.model.attackerCurSkill)

	return table.get(arg_26_0.model.attackerCurSkill, var_26_0, "targetsFinalResult", arg_26_0.model.id, "args", arg_26_1)
end

function var_0_1.getDispelSuccessCount(arg_27_0)
	return arg_27_0.model:getEventByKey(battle.ExRecordEvent.dispelSuccessCount) or 0
end

function var_0_1.hasSkill(arg_28_0, ...)
	for iter_28_0, iter_28_1 in ipairs({
		...
	}) do
		if arg_28_0.model.skills[iter_28_1] or arg_28_0.model.passiveSkills[iter_28_1] then
			return true
		end
	end

	return false
end

function var_0_1.hasBuff(arg_29_0, ...)
	for iter_29_0, iter_29_1 in ipairs({
		...
	}) do
		if arg_29_0.model:hasBuff(iter_29_1) then
			return true
		end
	end

	return false
end

function var_0_1.countBuff(arg_30_0, ...)
	local var_30_0 = 0

	for iter_30_0, iter_30_1 in ipairs({
		...
	}) do
		if arg_30_0.model:hasBuff(iter_30_1) then
			var_30_0 = var_30_0 + 1
		end
	end

	return var_30_0
end

function var_0_1.hasBuffGroup(arg_31_0, ...)
	for iter_31_0, iter_31_1 in ipairs({
		...
	}) do
		if arg_31_0.model:hasBuffGroup(iter_31_1) then
			return true
		end
	end

	return false
end

function var_0_1.getBuff(arg_32_0, arg_32_1)
	if arg_32_0.model then
		local var_32_0 = arg_32_0.model:getBuff(arg_32_1)

		if var_32_0 == nil then
			return battleCsv.NilBuff
		end

		if var_32_0:getCsvObject() == nil then
			battleCsv.CsvBuff.new(var_32_0)
			assert(var_32_0:getCsvObject(), "buff csv object was nil")
		end

		return var_32_0:getCsvObject()
	end

	return battleCsv.NilBuff
end

function var_0_1.sumBuffOverlayByGroup(arg_33_0, ...)
	local var_33_0 = 0

	for iter_33_0, iter_33_1 in ipairs({
		...
	}) do
		var_33_0 = var_33_0 + arg_33_0.model:getBuffGroupArgSum("overlayCount", iter_33_1)
	end

	return var_33_0
end

function var_0_1.sumBuffLifeRoundByGroup(arg_34_0, ...)
	local var_34_0 = 0

	for iter_34_0, iter_34_1 in ipairs({
		...
	}) do
		var_34_0 = var_34_0 + arg_34_0.model:getBuffGroupFuncSum("getLifeRound", iter_34_1)
	end

	return var_34_0
end

function var_0_1.frontOrBack(arg_35_0)
	return arg_35_0.model:frontOrBack()
end

function var_0_1.shieldHp(arg_36_0, ...)
	if ... then
		local var_36_0 = {}
		local var_36_1 = 0

		for iter_36_0, iter_36_1 in ipairs({
			...
		}) do
			var_36_0[iter_36_1] = true
		end

		for iter_36_2, iter_36_3 in arg_36_0.model:ipairsOverlaySpecBuff("shield") do
			if var_36_0[iter_36_3.cfgId] then
				var_36_1 = var_36_1 + math.max(iter_36_3.shieldHp, 0)
			end
		end

		return var_36_1
	else
		return arg_36_0.model:shieldHp()
	end
end

function var_0_1.getCopyBuffCount(arg_37_0)
	return arg_37_0.model:getEventByKey(battle.ExRecordEvent.copySucessCount) or 0
end

function var_0_1.getTransferBuffCount(arg_38_0)
	return arg_38_0.model:getEventByKey(battle.ExRecordEvent.transferSucessCount) or 0
end

function var_0_1.chargeStateBeforeWave(arg_39_0)
	return arg_39_0.model:getEventByKey(battle.ExRecordEvent.chargeStateBeforeWave)
end

function var_0_1.getKillMeDamage(arg_40_0, arg_40_1)
	if arg_40_0.model.killMeDamageValues then
		return arg_40_0.model.killMeDamageValues:get(arg_40_1)
	end

	return 0
end

function var_0_1.getRecordDamage(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = 0

	for iter_41_0, iter_41_1 in pairs(arg_41_0.model.totalDamage) do
		if arg_41_2 then
			if arg_41_2 == iter_41_1 then
				var_41_0 = var_41_0 + iter_41_1:get(arg_41_1)
			end
		else
			var_41_0 = var_41_0 + iter_41_1:get(arg_41_1)
		end
	end

	return var_41_0
end

function var_0_1.getRecordResumeHp(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = 0

	for iter_42_0, iter_42_1 in pairs(arg_42_0.model.totalResumeHp) do
		if arg_42_2 then
			if arg_42_2 == iter_42_1 then
				var_42_0 = var_42_0 + iter_42_1:get(arg_42_1)
			end
		else
			var_42_0 = var_42_0 + iter_42_1:get(arg_42_1)
		end
	end

	return var_42_0
end

function var_0_1.getRecordTakeDamage(arg_43_0, arg_43_1, arg_43_2)
	return arg_43_0.model:getTakeDamageRecord(arg_43_1, arg_43_2)
end

function var_0_1.getMomentBuffDamage(arg_44_0, arg_44_1, arg_44_2)
	arg_44_2 = arg_44_2 or 1

	local var_44_0 = arg_44_0.model:getEventByKey(battle.ExRecordEvent.momentBuffDamage, arg_44_1)

	return var_44_0 and var_44_0[arg_44_2] or 0
end

function var_0_1.getRecordData(arg_45_0, arg_45_1)
	return arg_45_0.model:getEventByKey(battle.ExRecordEvent[arg_45_1]) or 0
end

function var_0_1.getRealPos(arg_46_0)
	return arg_46_0.model:getRealPos()
end

function var_0_1.getPlaySmallSkillCount(arg_47_0)
	return arg_47_0.model:getEventByKey(battle.MainSkillType.SmallSkill) or 0
end

function var_0_1.getSkillSpellCountByType(arg_48_0, arg_48_1)
	return arg_48_0.model:getEventByKey(arg_48_1) or 0
end

function var_0_1.getSpecBuffSubkeySize(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = 0

	for iter_49_0, iter_49_1 in arg_49_0.model:ipairsOverlaySpecBuff(arg_49_1) do
		if iter_49_1[arg_49_2] and type(iter_49_1[arg_49_2]) == "table" then
			var_49_0 = var_49_0 + table.length(iter_49_1[arg_49_2])
		end
	end

	return var_49_0
end

function var_0_1.getSpecBuffFuncVal(arg_50_0, arg_50_1, arg_50_2, ...)
	return arg_50_0.model:doOverlaySpecBuffFunc(arg_50_1, arg_50_2, ...) or 0
end

function var_0_1.getExAttackMode(arg_51_0)
	return arg_51_0.model.exAttackMode or 0
end

function var_0_1.getRowNums(arg_52_0)
	local var_52_0 = arg_52_0.model:frontOrBack()

	return (arg_52_0.model.scene:getRowRemain(arg_52_0.model.force, var_52_0))
end

function var_0_1.getColumnNums(arg_53_0)
	local var_53_0 = arg_53_0.model.seat % 3

	var_53_0 = var_53_0 == 0 and 3 or var_53_0

	return (arg_53_0.model.scene:getColumnRemain(arg_53_0.model.force, var_53_0))
end

function var_0_1.getImmuneVal(arg_54_0, arg_54_1)
	local var_54_0 = 0

	for iter_54_0, iter_54_1 in arg_54_0.model:ipairsOverlaySpecBuff("immuneControlVal") do
		var_54_0 = iter_54_1.refreshProb(var_54_0, arg_54_1)
	end

	return var_54_0
end

function var_0_1.getFightPoint(arg_55_0)
	return arg_55_0.model.fightPoint
end

local var_0_2 = {
	Z = {
		79001,
		79002,
		79003,
		79004
	}
}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	for iter_0_2, iter_0_3 in ipairs(iter_0_1) do
		var_0_1["flag" .. iter_0_0 .. iter_0_2] = functools.partial(function(arg_56_0, arg_56_1)
			return arg_56_1.model.tagSkills[arg_56_0]
		end, iter_0_3)
	end
end

function var_0_1.getControlPerVal(arg_57_0, arg_57_1)
	local var_57_0 = 0

	for iter_57_0, iter_57_1 in arg_57_0.model:ipairsOverlaySpecBuff("controlPerVal") do
		var_57_0 = iter_57_1.refreshProb(var_57_0, arg_57_1)
	end

	return var_57_0
end

for iter_0_4, iter_0_5 in pairs(ObjectAttrs.AttrsTable) do
	var_0_1["B" .. iter_0_4] = function(arg_58_0)
		return arg_58_0.model:getBaseAttr(iter_0_4)
	end
	var_0_1["A" .. iter_0_4] = function(arg_59_0)
		return arg_59_0.model.attrs.buff[iter_0_4]
	end
	var_0_1["BA" .. iter_0_4] = function(arg_60_0)
		return arg_60_0.model:getRealFinalAttr(iter_0_4)
	end
	var_0_1[iter_0_4] = function(arg_61_0)
		return arg_61_0.model[iter_0_4](arg_61_0.model)
	end
end

battleCsv.exportToCsvCls(var_0_1, var_0_0)
