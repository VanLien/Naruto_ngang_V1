local var_0_0 = class("CBase")

battleModule.CBase = var_0_0

function var_0_0.ctor(arg_1_0, arg_1_1)
	arg_1_0.parent = arg_1_1
	arg_1_0.subModuleNotify = arg_1_1.subModuleNotify
end

function var_0_0.notify(arg_2_0, arg_2_1, ...)
	return arg_2_0.subModuleNotify:notify(arg_2_1, ...)
end

function var_0_0.call(arg_3_0, arg_3_1, ...)
	return arg_3_0.subModuleNotify:call(arg_3_1, ...)
end

function var_0_0.onClose(arg_4_0)
	return
end

return var_0_0
