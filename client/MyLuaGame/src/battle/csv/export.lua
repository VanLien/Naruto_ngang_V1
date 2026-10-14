local var_0_0

battleCsv.Model2CsvCls = {
	ObjectModel = battleCsv.CsvObject,
	MonsterModel = battleCsv.CsvObject,
	BossModel = battleCsv.CsvObject,
	ObjectExtraModel = battleCsv.CsvObject,
	SceneModel = battleCsv.CsvScene,
	SkillModel = battleCsv.CsvSkill,
	BuffSkillModel = battleCsv.CsvSkill,
	PassiveSkillModel = battleCsv.CsvSkill,
	BuffModel = battleCsv.CsvBuff
}

local var_0_1 = {
	__index = true,
	getDamageState = true,
	level = true,
	sumBuffOverlayByGroup = true,
	force = true,
	new = true,
	getDamageStateByTarget = true,
	__newindex = true
}

local function var_0_2(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		if not var_0_1[iter_1_0] and type(iter_1_1) == "function" then
			assert(var_0_0[iter_1_0] == nil, string.format("%s `%s` already in protected env", type(arg_1_1), iter_1_0))

			var_0_0[iter_1_0] = function(...)
				local var_2_0 = var_0_0._exEnv

				return iter_1_1(var_2_0[arg_1_0], ...)
			end
		end
	end
end

local function var_0_3(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		if arg_3_0 == iter_3_1 then
			return true
		end
	end

	return false
end

local function var_0_4(arg_4_0, arg_4_1)
	return arg_4_1 < arg_4_0
end

local function var_0_5(arg_5_0, arg_5_1)
	return arg_5_0 < arg_5_1
end

local function var_0_6(arg_6_0, arg_6_1)
	return arg_6_1 <= arg_6_0
end

local function var_0_7(arg_7_0, arg_7_1)
	return arg_7_0 <= arg_7_1
end

local function var_0_8(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_1 < arg_8_0 then
		return arg_8_2
	end

	return arg_8_3
end

local function var_0_9(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_0 < arg_9_1 then
		return arg_9_2
	end

	return arg_9_3
end

local function var_0_10(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_1 <= arg_10_0 then
		return arg_10_2
	end

	return arg_10_3
end

local function var_0_11(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_0 <= arg_11_1 then
		return arg_11_2
	end

	return arg_11_3
end

local function var_0_12(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 == 0 then
		return arg_12_2
	end

	return arg_12_0 / arg_12_1
end

local function var_0_13(arg_13_0)
	if arg_13_0 == nil or arg_13_0 == false or arg_13_0 == 0 then
		return 0
	end

	return 1
end

local function var_0_14(arg_14_0)
	if arg_14_0 == nil or arg_14_0 == false or arg_14_0 == 0 then
		return false
	end

	return true
end

local function var_0_15(arg_15_0, arg_15_1)
	return itertools.include(arg_15_0, battle.CsvStrToMap[arg_15_1 .. "Iter"])
end

local function var_0_16(...)
	return {
		...
	}
end

local function var_0_17(arg_17_0, arg_17_1)
	if arg_17_0 and arg_17_0.__valueTypeTable then
		return arg_17_0:get(arg_17_1)
	end

	return 0
end

local function var_0_18(arg_18_0)
	if var_0_0 then
		rawset(var_0_0, "_exEnv", arg_18_0)

		return var_0_0
	end

	assert(gFormulaConst, "gFormulaConst is nil")

	var_0_0 = {
		c = gFormulaConst,
		random = function(...)
			return ymrand.random(...)
		end,
		select = select,
		min = math.min,
		max = math.max,
		div = var_0_12,
		clamp = cc.clampf,
		to10 = var_0_13,
		ifElse = battleEasy.ifElse,
		ifMore = var_0_8,
		ifLess = var_0_9,
		ifMoreE = var_0_10,
		ifLessE = var_0_11,
		more = var_0_4,
		less = var_0_5,
		moreE = var_0_6,
		lessE = var_0_7,
		exitInTab = var_0_3,
		getValueTab = var_0_17,
		moreThan = var_0_4,
		lessThan = var_0_5,
		moreEqualThan = var_0_6,
		lessEqualThan = var_0_7,
		list = var_0_16,
		exitInArray = var_0_15,
		battle = battle,
		_exEnv = arg_18_0
	}

	local var_18_0 = var_0_0

	for iter_18_0, iter_18_1 in pairs(battle.ResumeHpFrom) do
		var_18_0[iter_18_0 .. "RHpIdx"] = iter_18_1
	end

	for iter_18_2, iter_18_3 in pairs(battle.ValueType) do
		var_18_0[iter_18_2 .. "ValIdx"] = iter_18_3
	end

	for iter_18_4, iter_18_5 in pairs(battle.DamageFrom) do
		var_18_0[iter_18_4 .. "DmgIdx"] = iter_18_5
	end

	var_0_2("self", battleCsv.CsvObject)
	var_0_2("scene", battleCsv.CsvScene)
	var_0_2("skill", battleCsv.CsvSkill)
	var_0_2("buff", battleCsv.CsvBuff)

	var_18_0.__index = var_18_0

	setmetatable(var_18_0, {
		__newindex = function(arg_20_0, arg_20_1, arg_20_2)
			error("you could not write in GlobalBaseEnv with " .. arg_20_1)
		end
	})

	return var_18_0
end

function battleCsv.doFormula(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_1.fillEnv then
		arg_21_1:fillEnv(var_0_18(arg_21_1))
	else
		setmetatable(arg_21_1, var_0_18(arg_21_1))
	end

	return eval.doFormula(arg_21_0, arg_21_1, arg_21_2)
end

function battleCsv.makeFindEnv(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = battlePlay.Gate.ForceNumber
	local var_22_1 = {
		self = arg_22_0,
		selectObj = arg_22_1,
		skillSegType = arg_22_2 and arg_22_2.skillSegType,
		skillFixType = arg_22_2 and arg_22_2.skillFixType,
		force = arg_22_1 and arg_22_1.force or arg_22_0.force,
		forceNumber = var_22_0,
		rowNumber = var_22_0 / 2,
		getRowAndColumn = battleEasy.getRowAndColumn,
		csvSelf = battleCsv.CsvObject.new(arg_22_0),
		csvSelectObj = battleCsv.CsvObject.new(arg_22_1)
	}

	var_22_1.env = var_22_1

	return var_22_1
end

function battleCsv.makeProtectedEnv(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0 and arg_23_0.scene or scene and scene.scene or arg_23_2 and arg_23_2.scene

	assert(var_23_0, "no scene be contained in params")

	local var_23_1 = {
		scene = battleCsv.CsvScene.new(var_23_0)
	}

	var_23_1.env = var_23_1

	if arg_23_0 then
		var_23_1.self = battleCsv.CsvObject.new(arg_23_0)
	end

	if arg_23_1 then
		var_23_1.skill = battleCsv.CsvSkill.new(arg_23_1)
		var_23_1.owner = var_23_1.self
	end

	if arg_23_2 then
		var_23_1.buff = battleCsv.CsvBuff.new(arg_23_2)
		var_23_1.caster = arg_23_2.caster and arg_23_2.caster == arg_23_0 and var_23_1.self or battleCsv.CsvObject.new(arg_23_2.caster)
		var_23_1.holder = battleCsv.CsvObject.new(arg_23_2.holder)
		var_23_1.target = var_23_1.holder
		var_23_1.fromSkillLevel = arg_23_2.fromSkillLevel
	end

	local var_23_2 = protectedEnv(var_23_1)

	var_23_2:fillEnv(var_0_18(var_23_2), true)

	return var_23_2
end

function battleCsv.makeDamageProcessEnv(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_0 and arg_24_0.scene or arg_24_1 and arg_24_1.scene

	assert(var_24_0, "no scene be contained in params")

	local var_24_1 = {
		arg = arg_24_2.args,
		scene = battleCsv.CsvScene.new(var_24_0)
	}

	var_24_1.env = var_24_1
	var_24_1.setBaseAttr = ObjectAttrs.setBaseAttr
	var_24_1.addBaseAttr = ObjectAttrs.addBaseAttr
	var_24_1.updateMaxBaseAttr = ObjectAttrs.updateMaxBaseAttr
	var_24_1.isAttr = functools.partial(function(arg_25_0, arg_25_1)
		return arg_25_0[arg_25_1] and true or false
	end, ObjectAttrs.AttrsTable)

	local var_24_2 = {}
	local var_24_3

	for iter_24_0, iter_24_1 in pairs(arg_24_3) do
		var_24_2[iter_24_0] = 0

		if not ObjectAttrs.AttrsTable[iter_24_0] then
			var_24_1[iter_24_0] = iter_24_1
		else
			var_24_1[iter_24_0] = function(arg_26_0)
				return arg_26_0.final[iter_24_0]
			end
		end
	end

	var_24_1.base = table.salttable(var_24_2)
	var_24_1.base2 = table.salttable(var_24_2)
	var_24_1.buff = table.salttable(var_24_2)
	var_24_1.final = table.salttable(arg_24_3)
	var_24_1.setValue = functools.partial(function(arg_27_0, arg_27_1, arg_27_2)
		for iter_27_0, iter_27_1 in ipairs(arg_27_1) do
			if arg_27_0.isAttr(iter_27_1) then
				arg_27_0:setBaseAttr(iter_27_1, arg_27_2[iter_27_0])
			else
				arg_27_0[iter_27_1] = arg_27_2[iter_27_0]
			end
		end

		return arg_27_0
	end, var_24_1)
	var_24_1.updateMaxValue = functools.partial(function(arg_28_0, arg_28_1, arg_28_2)
		for iter_28_0, iter_28_1 in ipairs(arg_28_1) do
			if arg_28_0.isAttr(iter_28_1) then
				arg_28_0:updateMaxBaseAttr(iter_28_1, arg_28_2[iter_28_0])
			else
				arg_28_0["G_" .. iter_28_1] = math.max(arg_28_0["G_" .. iter_28_1] or 0, arg_28_2[iter_28_0])
			end
		end

		return arg_28_0
	end, var_24_1)

	if arg_24_0 then
		var_24_1.attacker = battleCsv.CsvObject.new(arg_24_0)
	end

	if arg_24_1 then
		var_24_1.target = battleCsv.CsvObject.new(arg_24_1)
	end

	return var_24_1
end

local function var_0_19(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = rawget(arg_29_0, arg_29_2)
	local var_29_1 = arg_29_1[arg_29_2]

	if var_29_1 then
		if var_29_0 then
			assert(var_29_0.model == var_29_1, string.format("%s not same in protected, %s, %s", arg_29_2, tostring(var_29_0.model), tostring(var_29_1)))

			return nil, var_29_1
		else
			local var_29_2 = battleCsv.Model2CsvCls[tj.type(var_29_1)]

			if var_29_2 then
				return var_29_2.new(var_29_1), var_29_1
			end

			return var_29_1, var_29_1
		end
	else
		return nil, var_29_0 and var_29_0.model
	end
end

function battleCsv.fillFuncEnv(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or {}

	local var_30_0 = {}
	local var_30_1, var_30_2 = var_0_19(arg_30_0, arg_30_1, "self")

	arg_30_1.self = nil

	if var_30_1 then
		var_30_0.self = var_30_1
	end

	if var_30_2 and var_30_2.curAttackMeObj then
		var_30_0.attackMeObj = battleCsv.CsvObject.new(var_30_2.curAttackMeObj)
	end

	local var_30_3, var_30_4 = var_0_19(arg_30_0, arg_30_1, "skill")

	arg_30_1.skill = nil

	if var_30_3 then
		var_30_0.skill = var_30_3
		var_30_0.owner = arg_30_0.obj
	end

	var_30_0.skillLevel = var_30_4 and var_30_4:getLevel() or 1

	local var_30_5, var_30_6 = var_0_19(arg_30_0, arg_30_1, "target")

	var_30_0.target = var_30_5
	arg_30_1.target = nil

	local var_30_7, var_30_8 = var_0_19(arg_30_0, arg_30_1, "buff")

	arg_30_1.buff = nil

	if var_30_7 then
		var_30_0.buff = var_30_7
		var_30_0.caster = battleCsv.CsvObject.new(var_30_8.caster)
		var_30_0.holder = battleCsv.CsvObject.new(var_30_8.holder)
		var_30_0.target = var_30_0.target or var_30_0.holder
		var_30_0.fromSkillLevel = var_30_8.fromSkillLevel
	end

	for iter_30_0, iter_30_1 in pairs(arg_30_1) do
		arg_30_1[iter_30_0] = var_0_19(arg_30_0, arg_30_1, iter_30_0)
	end

	for iter_30_2, iter_30_3 in pairs(var_30_0) do
		assert(arg_30_1[iter_30_2] == nil, string.format("`%s` already in args", iter_30_2))

		arg_30_1[iter_30_2] = iter_30_3
	end

	return arg_30_0:fillEnvInFront(arg_30_1)
end

function battleCsv.makeEnv(arg_31_0)
	local var_31_0 = battleCsv.makeProtectedEnv(arg_31_0.self, arg_31_0.skill, arg_31_0.buff)

	arg_31_0.self = nil
	arg_31_0.skill = nil
	arg_31_0.buff = nil

	return battleCsv.fillFuncEnv(var_31_0, arg_31_0)
end
