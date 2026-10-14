local var_0_0 = class("FramePre", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.singleCallCache = {}
	arg_1_0.keysCache = {}
end

function var_0_0.onNewBattleRound(arg_2_0, arg_2_1)
	return
end

function var_0_0.onClose(arg_3_0)
	return
end

function var_0_0.onUpdateOver(arg_4_0)
	arg_4_0.singleCallCache = {}
end

function var_0_0.onSingleCallInFrame(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_0.singleCallCache[arg_5_1] then
		arg_5_0.singleCallCache[arg_5_1] = {}
	end

	if table.length(arg_5_0.singleCallCache[arg_5_1]) > 0 then
		local var_5_0

		for iter_5_0, iter_5_1 in ipairs(arg_5_0.singleCallCache[arg_5_1]) do
			local var_5_1 = true

			for iter_5_2, iter_5_3 in ipairs(arg_5_2) do
				var_5_1 = var_5_1 and arg_5_3(arg_5_4[iter_5_3], iter_5_1[iter_5_3], iter_5_3)

				if not var_5_1 then
					break
				end
			end

			if var_5_1 then
				return false
			end
		end
	end

	table.insert(arg_5_0.singleCallCache[arg_5_1], arg_5_4)

	return true
end

function var_0_0.onFrameOnceEffect(arg_6_0, arg_6_1)
	if not arg_6_0.keysCache.onceEffect then
		arg_6_0.keysCache.onceEffect = itertools.keys(arg_6_1)
	end

	if arg_6_0:onSingleCallInFrame("onceEffect", arg_6_0.keysCache.onceEffect, function(arg_7_0, arg_7_1, arg_7_2)
		if arg_7_2 == "offsetPos" then
			return arg_7_0.x == arg_7_1.x and arg_7_0.y == arg_7_1.y
		elseif (arg_7_2 == "delay" or arg_7_2 == "lifetime") and arg_7_1 == nil and arg_7_0 == 0 then
			return true
		end

		return arg_7_0 == arg_7_1
	end, arg_6_1) then
		arg_6_0.parent:onEventEffect(nil, "onceEffect", arg_6_1)
	end
end

return var_0_0
