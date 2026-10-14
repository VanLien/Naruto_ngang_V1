local var_0_0 = class("BattleExRecord")

globals.BattleExRecord = var_0_0

local var_0_1 = {
	[battle.MainSkillType.NormalSkill] = battle.ExRecordEvent.spellNormalSkill,
	[battle.MainSkillType.SmallSkill] = battle.ExRecordEvent.spellSmallSkill,
	[battle.MainSkillType.BigSkill] = battle.ExRecordEvent.spellBigSkill,
	[battle.MainSkillType.PassiveSkill] = 0
}

local function var_0_2(arg_1_0, ...)
	local var_1_0 = table.getWithKeys(self.exRecordTbl[arg_1_0], {
		...
	})

	if not var_1_0 then
		return true
	end

	return var_1_0.val < var_1_0.limit
end

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0 = true

	if not arg_2_0 or arg_2_0 < 0 or not arg_2_1 then
		return false
	end

	return var_2_0
end

local function var_0_4(arg_3_0, ...)
	local var_3_0 = {
		...
	}

	return table.getWithKeys(arg_3_0, var_3_0) or {}
end

local function var_0_5(arg_4_0, ...)
	local var_4_0 = {
		...
	}

	return table.getWithKeys(arg_4_0, var_4_0) or 0
end

local function var_0_6()
	return true
end

local function var_0_7()
	return false
end

local var_0_8 = {
	default = {
		init = var_0_5,
		check = var_0_6,
		process = function(arg_7_0, arg_7_1)
			if type(arg_7_1) == "number" then
				return arg_7_0 + arg_7_1
			end

			return arg_7_1
		end
	},
	limit = {
		init = var_0_4,
		check = function(arg_8_0)
			if arg_8_0.val then
				return arg_8_0.val < arg_8_0.limit
			end

			return true
		end,
		process = function(arg_9_0, arg_9_1)
			arg_9_0.val = math.min(arg_9_0.val + arg_9_1, arg_9_0.limit)

			return arg_9_0
		end
	},
	set = {
		init = var_0_4,
		check = var_0_6,
		process = function(arg_10_0, arg_10_1)
			return arg_10_1
		end
	},
	insert = {
		init = var_0_4,
		check = var_0_6,
		process = function(arg_11_0, arg_11_1)
			table.insert(arg_11_0, arg_11_1)

			return arg_11_0
		end
	},
	addNumber = {
		init = var_0_5,
		check = var_0_6,
		process = function(arg_12_0, arg_12_1)
			return arg_12_0 + arg_12_1
		end
	},
	skillType = {
		init = var_0_5,
		check = function(arg_13_0, arg_13_1, arg_13_2)
			local var_13_0 = true

			if not arg_13_1 or arg_13_1 < 0 or not arg_13_2 then
				return false
			end

			return var_13_0
		end,
		process = function(arg_14_0, arg_14_1)
			return arg_14_0 + arg_14_1
		end
	},
	momentBuffDamage = {
		init = var_0_4,
		check = var_0_6,
		process = function(arg_15_0, arg_15_1)
			arg_15_0[1] = arg_15_1
			arg_15_0[2] = arg_15_0[2] and arg_15_0[2] + arg_15_1 or arg_15_1

			return arg_15_0
		end
	}
}
local var_0_9 = {
	[battle.ExRecordEvent.lockHpDamage] = var_0_8.set,
	[battle.ExRecordEvent.lockHpTriggerTime] = var_0_8.set,
	[battle.ExRecordEvent.transferState] = var_0_8.set,
	[battle.ExRecordEvent.copyState] = var_0_8.set,
	[battle.ExRecordEvent.dispelSuccess] = var_0_8.set,
	[battle.ExRecordEvent.totalHp] = var_0_8.set,
	[battle.ExRecordEvent.lockHpTriggerState] = var_0_8.set,
	[battle.ExRecordEvent.keepHpUnChangedTriggerState] = var_0_8.set,
	[battle.ExRecordEvent.copyOrTransferBuff] = var_0_8.insert,
	[battle.ExRecordEvent.skillEffectLimit] = var_0_8.insert,
	[battle.ExRecordEvent.spellNormalSkill] = var_0_8.skillType,
	[battle.ExRecordEvent.spellSmallSkill] = var_0_8.skillType,
	[battle.ExRecordEvent.spellBigSkill] = var_0_8.skillType,
	[battle.ExRecordEvent.spellSkillTotal] = var_0_8.skillType,
	[battle.ExRecordEvent.momentBuffDamage] = var_0_8.momentBuffDamage
}
local var_0_10 = {
	[battle.TimeIntervalType.wave] = {
		battle.ExRecordEvent.skillEffectLimit
	}
}

local function var_0_11(arg_16_0)
	return var_0_1[arg_16_0] or arg_16_0
end

function var_0_0.ctor(arg_17_0)
	arg_17_0.exRecordTbl = {}
	arg_17_0.eventName2Key = {}
end

function var_0_0._getRecord(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return {}
	end

	if not arg_18_0.exRecordTbl[arg_18_1] then
		arg_18_0.exRecordTbl[arg_18_1] = {}
	end

	return arg_18_0.exRecordTbl[arg_18_1]
end

function var_0_0.getKeyByEventName(arg_19_0, arg_19_1)
	arg_19_1 = var_0_11(arg_19_1)
	arg_19_0.eventName2Key[arg_19_1] = arg_19_0.eventName2Key[arg_19_1] or 0
	arg_19_0.eventName2Key[arg_19_1] = arg_19_0.eventName2Key[arg_19_1] + 1

	return arg_19_0.eventName2Key[arg_19_1]
end

function var_0_0.addExRecord(arg_20_0, arg_20_1, arg_20_2, ...)
	local var_20_0 = ...

	if not arg_20_1 or not var_20_0 then
		return
	end

	arg_20_1 = var_0_11(arg_20_1)

	local var_20_1 = var_0_9[arg_20_1] or var_0_8.default
	local var_20_2 = var_20_1.init(arg_20_0:_getRecord(arg_20_1), ...)

	if not var_20_1.check(var_20_2, arg_20_2, var_20_0) then
		return
	end

	local var_20_3 = var_20_1.process(var_20_2, arg_20_2)
	local var_20_4 = {
		...
	}

	table.setWithKeys(arg_20_0:_getRecord(arg_20_1), var_20_4, var_20_3)
end

function var_0_0.getEvent(arg_21_0, arg_21_1)
	arg_21_1 = var_0_11(arg_21_1)

	return arg_21_0:_getRecord(arg_21_1)
end

function var_0_0.getEventByKey(arg_22_0, arg_22_1, ...)
	if not arg_22_1 then
		return
	end

	arg_22_1 = var_0_11(arg_22_1)

	if arg_22_0.exRecordTbl[arg_22_1] then
		return table.get(arg_22_0.exRecordTbl[arg_22_1], ...)
	end
end

function var_0_0.cleanEventByKey(arg_23_0, arg_23_1, arg_23_2)
	arg_23_1 = var_0_11(arg_23_1)

	if not arg_23_1 or not arg_23_0.exRecordTbl[arg_23_1] then
		return
	end

	if arg_23_2 then
		arg_23_0:_getRecord(arg_23_1)[arg_23_2] = nil
	else
		arg_23_0.exRecordTbl[arg_23_1] = nil
	end
end

function var_0_0.refreshEventRecord(arg_24_0, arg_24_1)
	if not var_0_10[arg_24_1] then
		return
	end

	for iter_24_0, iter_24_1 in ipairs(var_0_10[arg_24_1]) do
		arg_24_0:cleanEventByKey(iter_24_1)
	end
end
