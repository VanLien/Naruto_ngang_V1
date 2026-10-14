local var_0_0 = class("VSInfo", battleModule.CBase)

function var_0_0.ctor(arg_1_0, arg_1_1)
	battleModule.CBase.ctor(arg_1_0, arg_1_1)

	arg_1_0.widgetLeft = arg_1_0.parent.UIWidgetLeft:get("Image_8")
	arg_1_0.widgetRight = arg_1_0.parent.UIWidgetRight:get("Image_11")
end

function var_0_0.onNewBattleRound(arg_2_0, arg_2_1)
	return
end

function var_0_0.onClose(arg_3_0)
	return
end

return var_0_0
