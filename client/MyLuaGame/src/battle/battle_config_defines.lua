local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	if device.platform == "windows" then
		globals[arg_1_0] = csvReadOnlyInWindows(arg_1_1, arg_1_0)

		printDebug("battle_config_defines - proxy index %s", arg_1_0)
	end
end

local function var_0_2(arg_2_0, arg_2_1)
	table.insert(var_0_0, {
		name = arg_2_0,
		init = function()
			if arg_2_1 == nil then
				if globals[arg_2_0] then
					local var_3_0 = itertools.size(globals[arg_2_0])
				end

				return
			end

			if globals[arg_2_0] == nil then
				local var_3_1 = {}

				globals[arg_2_0] = var_3_1

				arg_2_1(var_3_1)

				if arg_2_0 ~= "gFormulaConst" then
					var_0_1(arg_2_0, var_3_1)
				end
			end
		end
	})
end

var_0_2("gMonsterCsv")
var_0_2("gSceneDemonCorrectCsv", function(arg_4_0)
	for iter_4_0, iter_4_1 in csvPairs(csv.scene_demon_correct) do
		if arg_4_0[iter_4_1.index] == nil then
			arg_4_0[iter_4_1.index] = {}
		end

		arg_4_0[iter_4_1.index][iter_4_1.wave] = iter_4_1
	end
end)
var_0_2("gGameEndSpeRuleCsv", function(arg_5_0)
	for iter_5_0, iter_5_1 in csvPairs(csv.game_end_special_rule) do
		if arg_5_0[iter_5_1.markID] == nil then
			arg_5_0[iter_5_1.markID] = {}
		end

		arg_5_0[iter_5_1.markID] = iter_5_1
	end
end)
var_0_2("gProcessEventCsv", function(arg_6_0)
	for iter_6_0, iter_6_1 in csvPairs(csv.skill_process) do
		if iter_6_1.effectEventID then
			arg_6_0[iter_6_0] = csv.effect_event[iter_6_1.effectEventID]
		end
	end
end)
var_0_2("gEffectByEventCsv")
var_0_2("gEffectOptionCsv", function(arg_7_0)
	for iter_7_0, iter_7_1 in csvPairs(csv.effect_option) do
		arg_7_0[iter_7_1.resPath] = iter_7_1
	end
end)
var_0_2("gFormulaConst", function(arg_8_0)
	local var_8_0 = {}

	for iter_8_0, iter_8_1 in csvPairs(csv.base_attribute.formula_const) do
		if #iter_8_1.key > 0 then
			var_8_0[iter_8_1.key] = iter_8_1.value
		end
	end

	local function var_8_1(arg_9_0)
		local var_9_0 = var_8_0[arg_9_0]

		assert(var_9_0, "no formula const " .. arg_9_0)

		return cache.createFormula(var_9_0)()
	end

	setmetatable(arg_8_0, {
		__index = function(arg_10_0, arg_10_1)
			if arg_10_1 == "__proxy" or arg_10_1 == "__immutable" then
				return
			end

			local var_10_0 = string.split(arg_10_1, "_")

			if #var_10_0 == 1 then
				local var_10_1 = var_8_1(var_10_0[1])

				if type(var_10_1) ~= "table" then
					return function()
						return var_10_1
					end
				end
			end

			local var_10_2 = var_10_0[#var_10_0] == "oc"
			local var_10_3 = {}

			for iter_10_0, iter_10_1 in ipairs(var_10_0) do
				if iter_10_1 == "oc" then
					break
				end

				arraytools.merge_two_inplace(var_10_3, var_8_1(iter_10_1))
			end

			local function var_10_4()
				if var_10_2 then
					return unpack(var_10_3)
				else
					return var_10_3
				end
			end

			rawset(arg_8_0, arg_10_1, var_10_4)

			return var_10_4
		end,
		__newindex = function(arg_13_0, arg_13_1, arg_13_2)
			error("could not write in here " .. arg_13_1)
		end
	})
end)

local var_0_3

local function var_0_4(arg_14_0)
	if not var_0_3 then
		assert(gFormulaConst, "gFormulaConst is nil")

		var_0_3 = {
			c = gFormulaConst,
			list = function(...)
				return {
					...
				}
			end
		}
		var_0_3.__index = var_0_3

		setmetatable(var_0_3, {
			__newindex = function(arg_16_0, arg_16_1, arg_16_2)
				error("you could not write in buffGroupEnv with " .. arg_16_1)
			end
		})
	end

	local var_14_0

	if type(arg_14_0) == "table" then
		var_14_0 = {}

		for iter_14_0, iter_14_1 in ipairs(arg_14_0) do
			local var_14_1 = eval.doFormula(iter_14_1, var_0_3)

			if type(var_14_1) == "table" then
				var_14_0 = arraytools.merge_two_inplace(var_14_0, var_14_1)
			else
				table.insert(var_14_0, var_14_1)
			end
		end
	else
		var_14_0 = eval.doFormula(arg_14_0, var_0_3)
	end

	return var_14_0
end

var_0_2("gBuffGroupRelationCsv", function(arg_17_0)
	for iter_17_0, iter_17_1 in csvPairs(csv.buff_group_relation) do
		local var_17_0 = {}

		for iter_17_2, iter_17_3 in ipairs(iter_17_1.immuneGroup) do
			var_17_0[#var_17_0 + 1] = arraytools.hash(var_0_4(iter_17_3))
		end

		local var_17_1 = {}

		for iter_17_4, iter_17_5 in ipairs(iter_17_1.dispelGroup) do
			var_17_1[#var_17_1 + 1] = arraytools.hash(var_0_4(iter_17_5))
		end

		local var_17_2 = {}

		for iter_17_6, iter_17_7 in ipairs(iter_17_1.powerGroup) do
			var_17_2[#var_17_2 + 1] = arraytools.hash(var_0_4(iter_17_7))
		end

		arg_17_0[iter_17_0] = {
			immuneGroup = var_17_0,
			dispelGroup = var_17_1,
			powerGroup = var_17_2,
			immuneEffect = iter_17_1.immuneEffect
		}
	end
end)
var_0_2("gBuffEffect", function(arg_18_0)
	for iter_18_0, iter_18_1 in csvPairs(csv.buff_effect) do
		arg_18_0[iter_18_1.easyEffectFunc] = iter_18_1
	end
end)
var_0_2("gSceneAttrCorrect", function(arg_19_0)
	for iter_19_0, iter_19_1 in csvPairs(csv.base_attribute.scene_attr_correct) do
		arg_19_0[iter_19_1.sceneID] = iter_19_1
		iter_19_1.hpMaxC = iter_19_1.hpC
		iter_19_1.mp1MaxC = iter_19_1.mp1C
	end

	return arg_19_0
end)
var_0_2("gCPCorrectionGroups", function(arg_20_0)
	for iter_20_0, iter_20_1 in csvPairs(csv.combat_power_correction) do
		arg_20_0[iter_20_0] = arraytools.hash(var_0_4(iter_20_1.groupKey))
	end
end)
var_0_2("gExtraRoundTrigger", function(arg_21_0)
	for iter_21_0, iter_21_1 in csvPairs(csv.extra_round_trigger) do
		arg_21_0[iter_21_0] = {
			limitBuff = arraytools.hash(iter_21_1.limitBuff),
			forbiddenBuff = arraytools.hash(iter_21_1.forbiddenBuff),
			forbiddenPassiveSkill = arraytools.hash(iter_21_1.forbiddenPassiveSkill),
			cfgIds = arraytools.hash(iter_21_1.cfgIds),
			disableBattleState = iter_21_1.disableBattleState
		}
	end
end)

return var_0_0
