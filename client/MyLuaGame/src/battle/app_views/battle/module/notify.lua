local var_0_0 = string.caption
local var_0_1 = class("CNotify")

battleModule.CNotify = var_0_1

function var_0_1.ctor(arg_1_0, arg_1_1)
	arg_1_0.view = arg_1_1
	arg_1_0.mods = {}
	arg_1_0.msgMap = {}
end

function var_0_1.init(arg_2_0)
	for iter_2_0, iter_2_1 in ipairs(battleModule.mods) do
		table.insert(arg_2_0.mods, iter_2_1.new(arg_2_0.view))
	end
end

function var_0_1.addSpec(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
		table.insert(arg_3_0.mods, iter_3_1.new(arg_3_0.view))
	end
end

function var_0_1.notify(arg_4_0, arg_4_1, ...)
	log.battle.notify(arg_4_1, lazydumps({
		...
	}))

	for iter_4_0, iter_4_1 in ipairs(arg_4_0:getMsgMap(arg_4_1)) do
		iter_4_1.func(arg_4_0.mods[iter_4_1.index], ...)
	end
end

function var_0_1.call(arg_5_0, arg_5_1, ...)
	for iter_5_0, iter_5_1 in ipairs(arg_5_0:getMsgMap(arg_5_1, true)) do
		return iter_5_1.func(arg_5_0.mods[iter_5_1.index], ...)
	end
end

function var_0_1.getMsgMap(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2 and arg_6_1 or "on" .. var_0_0(arg_6_1)
	local var_6_1 = arg_6_0.msgMap[var_6_0]

	if var_6_1 == nil then
		var_6_1 = {}

		for iter_6_0, iter_6_1 in ipairs(arg_6_0.mods) do
			local var_6_2 = iter_6_1[var_6_0]

			if var_6_2 then
				table.insert(var_6_1, {
					func = var_6_2,
					index = iter_6_0
				})
			end
		end

		if table.length(var_6_1) == 0 then
			printWarn("no module handler for msg %s", arg_6_1)
		end

		arg_6_0.msgMap[var_6_0] = var_6_1
	end

	return var_6_1
end

function var_0_1.close(arg_7_0)
	for iter_7_0, iter_7_1 in ipairs(arg_7_0.mods) do
		iter_7_1:onClose()
	end

	arg_7_0.mods = {}
	arg_7_0.msgMap = {}
end

return var_0_1
