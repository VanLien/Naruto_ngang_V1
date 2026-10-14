local var_0_0 = class("GainGoldDisplayView", Dialog)

var_0_0.RESOURCE_FILENAME = "common_gain_gold_display.json"
var_0_0.RESOURCE_BINDING = {
	panel10 = "panel10",
	bg = "bg",
	panel1 = "panel1"
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0
	local var_1_1 = 0
	local var_1_2 = 0

	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		var_1_0 = var_1_0 + iter_1_1.multiple - 1
		var_1_1 = var_1_1 + iter_1_1.gold
		var_1_2 = var_1_2 + 1
	end

	if arg_1_2 == 1 then
		arg_1_0.panel1:show()

		if var_1_0 > 0 then
			arg_1_0.panel1:get("title"):text(string.format(gLanguageCsv.gainGoldMultiple, var_1_0 + 1))
		end

		arg_1_0.panel1:get("gold"):text("+" .. var_1_1)
	else
		arg_1_0.panel10:show()
		arg_1_0.panel10:get("times"):text(var_1_2)
		arg_1_0.panel10:get("critTimes"):text(var_1_0)
		arg_1_0.panel10:get("gold"):text("+" .. var_1_1)
		adapt.oneLineCenterPos(cc.p(450, 270), {
			arg_1_0.panel10:get("info1"),
			arg_1_0.panel10:get("times"),
			arg_1_0.panel10:get("info2"),
			arg_1_0.panel10:get("critTimes"),
			arg_1_0.panel10:get("info3")
		}, cc.p(5, 0))
	end

	arg_1_0:playEffect()
	Dialog.onCreate(arg_1_0)
end

function var_0_0.playEffect(arg_2_0)
	audio.playEffectWithWeekBGM("golden.mp3")

	local var_2_0 = arg_2_0.bg:size()

	arg_2_0.goldEffect = widget.addAnimation(arg_2_0:getResourceNode(), "effect/jubao.skel", "effect", arg_2_0.bg:z() - 1):xy(display.center):scale(2)
end

function var_0_0.onClose(arg_3_0)
	if arg_3_0.goldEffect then
		arg_3_0.goldEffect:removeFromParent()
	end

	Dialog.onClose(arg_3_0)
end

return var_0_0
