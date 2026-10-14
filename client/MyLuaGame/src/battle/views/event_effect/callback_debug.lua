local var_0_0 = battleEffect.Callback

local function var_0_1(arg_1_0)
	local var_1_0 = {}

	for iter_1_0 = 1, arg_1_0.nups do
		local var_1_1, var_1_2 = debug.getupvalue(arg_1_0.func, iter_1_0)

		var_1_0[var_1_1] = var_1_2
	end

	return var_1_0
end

local function var_0_2(arg_2_0)
	local var_2_0 = itertools.map(arg_2_0, function(arg_3_0, arg_3_1)
		return string.format("%s=%s", toDebugString(arg_3_0), toDebugString(arg_3_1))
	end)

	return table.concat(var_2_0, ", ")
end

local var_0_3 = {
	["src/battle/easy/effect.lua"] = function(arg_4_0)
		local var_4_0 = var_0_1(arg_4_0)
		local var_4_1 = var_4_0.view and toDebugString(var_4_0.view) or "BattleView"

		return string.format("easy/effect:%d [%s]:%s", arg_4_0.linedefined, var_4_1, var_4_0.msg)
	end,
	["src/util/functools.lua"] = function(arg_5_0)
		local var_5_0 = var_0_1(arg_5_0)

		if var_5_0.upv1 then
			local var_5_1 = debug.getinfo(var_5_0.f)
			local var_5_2 = string.format("%s:%d", var_5_1.source, var_5_1.linedefined)
			local var_5_3 = toDebugString(var_5_0.upv1)

			return string.format("[%s]:%s(%s)", var_5_3, var_5_2, var_5_0.upv2)
		end
	end,
	["src/battle/views/sprite_normal.lua"] = function(arg_6_0)
		local var_6_0 = var_0_1(arg_6_0)

		if var_6_0.isAttacting ~= nil then
			return string.format("sprite_normal:%d, [%s]:objToHideEff(%s)", arg_6_0.linedefined, toDebugString(var_6_0.self), var_6_0.flag)
		end

		if var_6_0.self then
			local var_6_1 = toDebugString(var_6_0.self)

			var_6_0.self = nil

			return string.format("sprite_normal:%d, [%s] {%s}", arg_6_0.linedefined, var_6_1, var_0_2(var_6_0))
		end
	end,
	["src/battle/views/event_effect/effect1.lua"] = function(arg_7_0)
		local var_7_0 = var_0_1(arg_7_0)

		if var_7_0.self then
			local var_7_1 = toDebugString(var_7_0.self)

			var_7_0.self = nil

			return string.format("%s:%d, [%s] {%s}", arg_7_0.source, arg_7_0.linedefined, var_7_1, var_0_2(var_7_0))
		end
	end
}

function var_0_0.debugString(arg_8_0)
	local var_8_0 = debug.getinfo(arg_8_0.args.func)
	local var_8_1

	if var_0_3[var_8_0.source] then
		var_8_1 = var_0_3[var_8_0.source](var_8_0)
	end

	if var_8_1 == nil then
		var_8_1 = string.format("%s:%d", var_8_0.source, var_8_0.linedefined)
	end

	return string.format("Callback: %s", var_8_1)
end
