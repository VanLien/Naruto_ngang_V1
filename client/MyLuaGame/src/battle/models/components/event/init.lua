local var_0_0 = class("Event")
local var_0_1 = {
	"setListenerComparer",
	"subscribeEvent",
	"subscribeGlobalEvent",
	"dispatchEvent",
	"dispatchEventToGlobal",
	"dumpAllEventListeners"
}
local var_0_2
local var_0_3 = {
	components_ = {},
	__tostring = function()
		return "GlobalObject"
	end
}
local var_0_4 = {}

local function var_0_5()
	error("event not writeble")
end

local var_0_6 = {}

var_0_6.__index = var_0_6
var_0_6.__newindex = var_0_5

function var_0_6.new()
	return setmetatable({
		free_ = true,
		name = ""
	}, var_0_6)
end

function var_0_6.fill(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	var_0_6.__newindex = nil
	arg_4_0.from = arg_4_1
	arg_4_0.name = arg_4_2
	arg_4_0.args = arg_4_3
	arg_4_0.free_ = false
	var_0_6.__newindex = var_0_5

	return arg_4_0
end

function var_0_6.free(arg_5_0)
	arg_5_0.free_ = true
end

function var_0_0.init_(arg_6_0, arg_6_1)
	var_0_4[arg_6_0.id_] = arg_6_0

	if arg_6_0.inited_ then
		return
	end

	arg_6_0.inited_ = true
	arg_6_0.target_ = arg_6_1
	arg_6_0.listeners_ = {}
	arg_6_0.subscribers_ = {}
	arg_6_0.publishers_ = {}
	arg_6_0.comparer_ = nil
	arg_6_0.g_ = var_0_3
	arg_6_0.gm_ = var_0_4

	local var_6_0 = var_0_6.new()

	function arg_6_0.newEvent_(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = var_6_0

		if not var_6_0.free_ then
			var_7_0 = var_0_6.new()
		end

		return var_7_0:fill(arg_7_0.target_, arg_7_1, arg_7_2)
	end
end

function var_0_0.destroy_(arg_8_0)
	var_0_4[arg_8_0.id_] = nil
	arg_8_0.listeners_ = nil
	arg_8_0.subscribers_ = nil
	arg_8_0.publishers_ = nil
end

function var_0_0.bind(arg_9_0, arg_9_1)
	battleComponents.setmethods(arg_9_1, arg_9_0, var_0_1)
	arg_9_0:init_(arg_9_1)
end

function var_0_0.unbind(arg_10_0, arg_10_1)
	battleComponents.unsetmethods(arg_10_1, var_0_1)

	local var_10_0 = arg_10_0.gm_
	local var_10_1 = arg_10_0.id_

	for iter_10_0, iter_10_1 in pairs(arg_10_0.publishers_) do
		if var_10_0[iter_10_0] then
			var_10_0[iter_10_0]:removeSubscriber_(var_10_1)
		end
	end

	arg_10_0:destroy_()
end

function var_0_0.setListenerComparer(arg_11_0, arg_11_1)
	arg_11_0.comparer_ = arg_11_1
end

function var_0_0.addEventListener_(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_2.id_
	local var_12_1 = arg_12_0.listeners_[arg_12_1]

	if var_12_1 == nil then
		if arg_12_0.comparer_ then
			var_12_1 = {
				size = 0,
				map = {}
			}
		else
			var_12_1 = {
				size = 0,
				array = {}
			}
		end

		arg_12_0.listeners_[arg_12_1] = var_12_1
	end

	local var_12_2 = arg_12_0.subscribers_[var_12_0]

	if var_12_2 == nil then
		var_12_2 = {}
		arg_12_0.subscribers_[var_12_0] = var_12_2
	elseif var_12_2[arg_12_1] then
		return
	end

	var_12_1.size = var_12_1.size + 1

	if arg_12_0.comparer_ then
		var_12_1.array = nil
		var_12_1.map[arg_12_3] = arg_12_2.target_
	else
		table.insert(var_12_1.array, arg_12_3)
	end

	var_12_2[arg_12_1] = arg_12_3
end

function var_0_0.removeSubscriber_(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.subscribers_[arg_13_1]

	if var_13_0 == nil then
		return
	end

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		var_13_0[iter_13_0] = nil

		local var_13_1 = arg_13_0.listeners_[iter_13_0]

		if arg_13_0.comparer_ then
			var_13_1.array = nil
			var_13_1.map[iter_13_1] = nil
			var_13_1.size = var_13_1.size - 1
		else
			table.removebyvalue(var_13_1.array, iter_13_1, false)

			var_13_1.size = table.length(var_13_1.array)
		end
	end
end

function var_0_0.subscribeEvent(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.target_[arg_14_3]

	assert(var_14_0, "no such method")

	local var_14_1 = battleComponents.component(arg_14_1, "Event")

	assert(var_14_1, "publisher no such component")

	arg_14_0.publishers_[var_14_1.id_] = true

	local var_14_2 = cow.proxyObject("target_", arg_14_0.target_)

	var_14_1:addEventListener_(arg_14_2, arg_14_0, function(...)
		return var_14_0(var_14_2, ...)
	end)
end

function var_0_0.subscribeGlobalEvent(arg_16_0, arg_16_1, arg_16_2)
	return arg_16_0:subscribeEvent(arg_16_0.g_, arg_16_1, arg_16_2)
end

function var_0_0.dispatchEvent(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.listeners_[arg_17_1]

	if var_17_0 == nil or var_17_0.size == 0 then
		return
	end

	if arg_17_0.comparer_ and var_17_0.array == nil then
		var_17_0.array = table.keys(var_17_0.map)

		local var_17_1 = var_17_0.map

		table.sort(var_17_0.array, function(arg_18_0, arg_18_1)
			return arg_17_0.comparer_(var_17_1[arg_18_0], var_17_1[arg_18_1])
		end)
	end

	local var_17_2 = arg_17_0:newEvent_(arg_17_1, arg_17_2)

	for iter_17_0, iter_17_1 in ipairs(var_17_0.array) do
		iter_17_1(var_17_2)
	end

	var_17_2:free()

	return arg_17_0.target_
end

function var_0_0.dispatchEventToGlobal(arg_19_0, arg_19_1, arg_19_2)
	return arg_19_0.g_:dispatchEvent(arg_19_1, arg_19_2)
end

function var_0_0.printDebug(arg_20_0, arg_20_1, ...)
	local var_20_0 = string.format("[Event] %s %s " .. arg_20_1, tj.type(arg_20_0.target_), arg_20_0.target_.id, ...)

	release_print(var_20_0)
end

function var_0_0.dumpAllEventListeners(arg_21_0)
	print("---- Event:dumpAllEventListeners() ----")

	for iter_21_0, iter_21_1 in pairs(arg_21_0.listeners_) do
		printf("-- event: %s, handler: %s", iter_21_0, handler)
	end

	return arg_21_0.target_
end

function var_0_0.initGlobal_(arg_22_0)
	if var_0_2 then
		var_0_2:unbind(var_0_3)
	end

	var_0_2 = var_0_0:create()
	var_0_2.id_ = 0
	var_0_3.components_.Event = var_0_2

	var_0_2:bind(var_0_3)
end

function var_0_0.onClearAll()
	var_0_0:initGlobal_()
end

function var_0_0.newGlobalData()
	local var_24_0 = var_0_0:create()

	var_24_0.id_ = 0

	return {
		Global = var_24_0,
		EventComponentsMap = {}
	}
end

function var_0_0.switchGlobalData(arg_25_0)
	battleComponents.unsetmethods(var_0_3, var_0_1)

	var_0_2 = arg_25_0.Global
	var_0_4 = arg_25_0.EventComponentsMap
	var_0_3.components_.Event = var_0_2

	var_0_2:bind(var_0_3)
end

var_0_0:initGlobal_()

return var_0_0
