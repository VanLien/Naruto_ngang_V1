globals.battleComponents = {}

local var_0_0 = {}
local var_0_1 = 1
local var_0_2
local var_0_3

function battleComponents.register(arg_1_0, arg_1_1)
	var_0_0[arg_1_0] = arg_1_1

	printInfo("battleComponents.register() - register module %s", arg_1_0)
end

local var_0_4

local function var_0_5(arg_2_0, ...)
	local var_2_0 = type(arg_2_0)

	assert(var_2_0 == "table" or var_2_0 == "userdata", string.format("battleComponents.bind() - invalid target, expected is object, actual is %s", var_2_0))

	local var_2_1 = {
		...
	}

	assert(#var_2_1 > 0, "battleComponents.bind() - package names expected")

	if not arg_2_0.components_ then
		arg_2_0.components_ = {}
	end

	for iter_2_0, iter_2_1 in ipairs(var_2_1) do
		assert(type(iter_2_1) == "string" and iter_2_1 ~= "", string.format("battleComponents.bind() - invalid package name \"%s\"", iter_2_1))

		if not arg_2_0.components_[iter_2_1] then
			local var_2_2 = var_0_0[iter_2_1]

			for iter_2_2, iter_2_3 in ipairs(var_2_2.DEPENDS or {}) do
				if not arg_2_0.components_[iter_2_3] then
					var_0_5(arg_2_0, iter_2_3)
				end
			end

			local var_2_3 = var_2_2:create()

			var_2_3.id_ = var_0_1
			var_0_1 = var_0_1 + 1
			arg_2_0.components_[iter_2_1] = var_2_3

			var_2_3:bind(arg_2_0)
		end
	end

	var_0_3[arg_2_0] = true

	return arg_2_0
end

battleComponents.bind = var_0_5

function battleComponents.unbindAll(arg_3_0)
	if not arg_3_0.components_ then
		return
	end

	var_0_3[arg_3_0] = nil

	for iter_3_0, iter_3_1 in pairs(arg_3_0.components_) do
		iter_3_1:unbind(arg_3_0)

		arg_3_0.components_[iter_3_0] = nil
	end

	return arg_3_0
end

function battleComponents.setmethods(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = tj.type(arg_4_1)

	for iter_4_0, iter_4_1 in ipairs(arg_4_2) do
		local var_4_1 = arg_4_1[iter_4_1]

		assert(arg_4_0[iter_4_1] == nil, "target already had the method " .. iter_4_1)

		arg_4_0[iter_4_1] = function(arg_5_0, ...)
			return var_4_1(arg_5_0.components_[var_4_0], ...)
		end
	end
end

function battleComponents.component(arg_6_0, arg_6_1)
	if arg_6_0.components_ then
		return arg_6_0.components_[arg_6_1]
	end
end

function battleComponents.unbind(arg_7_0, ...)
	if not arg_7_0.components_ then
		return
	end

	local var_7_0 = {
		...
	}

	assert(#var_7_0 > 0, "battleComponents.unbind() - invalid package names")

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		assert(type(iter_7_1) == "string" and iter_7_1 ~= "", string.format("battleComponents.unbind() - invalid package name \"%s\"", iter_7_1))

		local var_7_1 = arg_7_0.components_[iter_7_1]

		assert(var_7_1, string.format("battleComponents.unbind() - component \"%s\" not found", tostring(iter_7_1)))
		var_7_1:unbind(arg_7_0)

		arg_7_0.components_[iter_7_1] = nil
	end

	return arg_7_0
end

function battleComponents.unsetmethods(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in ipairs(arg_8_1) do
		arg_8_0[iter_8_1] = nil
	end
end

function battleComponents.components(arg_9_0)
	return arg_9_0.components_ or {}
end

function battleComponents.clearAll()
	for iter_10_0, iter_10_1 in pairs(var_0_3) do
		battleComponents.unbindAll(iter_10_0)

		var_0_3[iter_10_0] = nil
	end

	for iter_10_2, iter_10_3 in pairs(var_0_0) do
		if iter_10_3.onClearAll then
			iter_10_3.onClearAll()
		end
	end
end

function battleComponents.newGlobalData()
	local var_11_0 = {
		bind_targets = {}
	}

	for iter_11_0, iter_11_1 in pairs(var_0_0) do
		if iter_11_1.newGlobalData then
			var_11_0[iter_11_0] = iter_11_1.newGlobalData()
		end
	end

	return var_11_0
end

function battleComponents.switchGlobalData(arg_12_0)
	local var_12_0 = var_0_2

	var_0_2 = arg_12_0
	var_0_3 = arg_12_0.bind_targets

	for iter_12_0, iter_12_1 in pairs(var_0_0) do
		if iter_12_1.switchGlobalData then
			iter_12_1.switchGlobalData(arg_12_0[iter_12_0])
		end
	end

	return var_12_0
end

local var_0_6 = {
	require("battle.models.components.event.init")
}

for iter_0_0, iter_0_1 in ipairs(var_0_6) do
	battleComponents.register(tostring(iter_0_1), iter_0_1)
end

battleComponents.switchGlobalData(battleComponents.newGlobalData())
