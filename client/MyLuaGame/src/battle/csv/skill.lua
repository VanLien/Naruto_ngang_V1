local var_0_0 = {
	interruptBuffId = 0
}
local var_0_1 = battleCsv.newCsvCls("CsvSkill")

var_0_1.ignoreModelCheck = {
	owner = true
}
battleCsv.CsvSkill = var_0_1

function var_0_1.level(arg_1_0)
	return arg_1_0.model:getLevel()
end

function var_0_1.getId(arg_2_0)
	return arg_2_0.model.id
end

function var_0_1.getKilledTargets(arg_3_0)
	return arg_3_0.model.killedTargetsTb or {}
end

function var_0_1.getDamageStateByTarget(arg_4_0, arg_4_1, arg_4_2)
	return table.get(arg_4_0.model.targetsFinalResult, arg_4_1.model.id, "args", arg_4_2)
end

function var_0_1.getProcessTargetsCount(arg_5_0, arg_5_1)
	return table.length(arg_5_0.model.allProcessesTargets[arg_5_1])
end

function var_0_1.checkProcessTargetsState(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}

	if arg_6_2 == "nodead" then
		function var_6_0(arg_7_0)
			for iter_7_0, iter_7_1 in ipairs(arg_7_0) do
				if iter_7_1:isAlreadyDead() then
					return false
				end
			end

			return true
		end
	end

	return var_6_0(arg_6_0.model.allProcessesTargets[arg_6_1])
end

function var_0_1.getDamageState(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_0.model.targetsFinalResult) do
		local var_8_0 = table.get(iter_8_1, "args", arg_8_1)

		if var_8_0 then
			return var_8_0
		end
	end
end

function var_0_1.getTotalDamage(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.model.cfg then
		return 0
	end

	arg_9_1 = arg_9_1 or battle.ValueType.normal

	local var_9_0 = (arg_9_2 or 0) == 0 and battle.SkillSegType.damage or battle.SkillSegType.resumeHp
	local var_9_1 = 0

	for iter_9_0, iter_9_1 in arg_9_0.model:pairsTargetsFinalResult(var_9_0) do
		var_9_1 = var_9_1 + iter_9_1.real:get(arg_9_1)
	end

	return var_9_1
end

function var_0_1.getTargetTotalDamage(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_0.model:chcekTargetInFinalResult(arg_10_1.model.id) then
		return 0
	end

	if not arg_10_0.model.cfg then
		return 0
	end

	arg_10_2 = arg_10_2 or battle.ValueType.normal
	arg_10_3 = arg_10_3 or 0

	local var_10_0 = 0
	local var_10_1

	if arg_10_3 == 0 and arg_10_0.model:isSameType(battle.SkillFormulaType.damage) then
		var_10_0 = var_10_0 + arg_10_0.model.targetsFinalResult[arg_10_1.model.id].damage.real:get(arg_10_2)
	end

	if arg_10_3 == 1 and arg_10_0.model:isSameType(battle.SkillFormulaType.resumeHp) then
		var_10_0 = var_10_0 + arg_10_0.model.targetsFinalResult[arg_10_1.model.id].resumeHp.real:get(arg_10_2)
	end

	return var_10_0
end

function var_0_1.getSkillDamageType(arg_11_0)
	return arg_11_0.model.cfg.skillDamageType
end

function var_0_1.getNatureType(arg_12_0)
	return arg_12_0.model:getSkillNatureType()
end

function var_0_1.getSkillType(arg_13_0)
	return arg_13_0.model.cfg.skillType or 0
end

function var_0_1.getSkillType2(arg_14_0)
	return arg_14_0.model.cfg.skillType2 or 0
end

function var_0_1.owner(arg_15_0)
	if arg_15_0.model and arg_15_0.model.owner then
		local var_15_0 = arg_15_0.model.owner

		if var_15_0:getCsvObject() == nil then
			battleCsv.CsvObject.new(var_15_0)
			assert(var_15_0:getCsvObject(), "object csv object was nil")
		end

		return var_15_0:getCsvObject()
	end

	return battleCsv.NilObject
end

function var_0_1.preCalSkillDamageCsvTarget(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.model
	local var_16_1 = arg_16_0.model
	local var_16_2 = arg_16_2.model
	local var_16_3 = false

	if var_16_0 and var_16_1 and var_16_2 then
		var_16_1.allProcessesTargets = {}

		for iter_16_0 = 1, table.length(var_16_1.processes) do
			local var_16_4 = var_16_1.processes[iter_16_0]
			local var_16_5 = var_16_1:onProcess(var_16_4, var_16_2)

			var_16_1.allProcessesTargets[var_16_4.id] = var_16_5.targets
			var_16_3 = var_16_3 or itertools.include(var_16_5.targets, function(arg_17_0)
				return arg_17_0.id == var_16_0.id
			end)

			if var_16_3 then
				break
			end
		end
	end

	return var_16_3
end

function var_0_1.targetType(arg_18_0)
	return arg_18_0.model.cfg.targetChooseType or "other"
end

function var_0_1.getCdRound(arg_19_0)
	return arg_19_0.model.cfg.cdRound
end

function var_0_1.isSpellTo(arg_20_0)
	return arg_20_0.model.isSpellTo
end

battleCsv.exportToCsvCls(var_0_1, var_0_0)
