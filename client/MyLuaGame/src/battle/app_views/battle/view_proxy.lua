function BattleView.onViewProxyNotify(arg_1_0, arg_1_1, ...)
	return arg_1_0.subModuleNotify:notify(arg_1_1, ...)
end

function BattleView.onViewProxyCall(arg_2_0, arg_2_1, ...)
	return arg_2_0.subModuleNotify:call(arg_2_1, ...)
end

function BattleView.onViewBeProxy(arg_3_0, arg_3_1, arg_3_2)
	return arg_3_0.subModuleNotify:notify("ViewBeProxy", arg_3_1, arg_3_2)
end

function BattleView.addSpecModule(arg_4_0, arg_4_1)
	arg_4_0.subModuleNotify:addSpec(arg_4_1)
end
