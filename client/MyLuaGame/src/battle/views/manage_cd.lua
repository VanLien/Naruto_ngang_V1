local var_0_0 = class("CManageCd")

globals.CManageCd = var_0_0

function var_0_0.ctor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.tick = 0
	arg_1_0.cdTime = arg_1_1
	arg_1_0.cdCountLimit = arg_1_2 or 9999999
	arg_1_0.cdCount = 0
end

function var_0_0.CdOk(arg_2_0)
	arg_2_0.tick = arg_2_0.cdTime
end

function var_0_0.isCdOk(arg_3_0)
	if arg_3_0.cdCount < arg_3_0.cdCountLimit and arg_3_0.tick >= arg_3_0.cdTime then
		return true
	end

	return false
end

function var_0_0.reset(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.tick = 0
	arg_4_0.cdTime = arg_4_1
	arg_4_0.cdCountLimit = arg_4_2 or 9999999
	arg_4_0.cdCount = 0
end

function var_0_0.start(arg_5_0, arg_5_1)
	arg_5_0.cdTime = arg_5_1 or arg_5_0.cdTime
	arg_5_0.tick = 0
	arg_5_0.cdCount = arg_5_0.cdCount + 1
end

function var_0_0.update(arg_6_0, arg_6_1)
	arg_6_0.tick = arg_6_0.tick + arg_6_1
end

function var_0_0.nextDelta(arg_7_0)
	if arg_7_0:isCdOk() then
		return 0
	end

	return arg_7_0.cdTime - arg_7_0.tick
end
