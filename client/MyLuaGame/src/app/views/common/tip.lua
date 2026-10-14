local var_0_0 = class("TipView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_tip.json"
var_0_0.RESOURCE_BINDING = {
	["panel.text"] = "text",
	panel = "panel",
	["panel.bg"] = "bg"
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.content = arg_1_1

	arg_1_0.text:text("")

	local var_1_0 = rich.createByStr("#C0xFFFFFF#" .. arg_1_1, 40):anchorPoint(0.5, 0.5):xy(arg_1_0.text:x(), arg_1_0.text:y()):addTo(arg_1_0.panel, 2000)

	var_1_0:formatText()

	local var_1_1 = var_1_0:size()

	arg_1_0.bg:size(math.max(var_1_1.width + 100, 1024), arg_1_0.bg:size().height)
	arg_1_0.panel:anchorPoint(0.5, 0):scale(3, 0)
	transition.executeSequence(arg_1_0.panel):scaleTo(0.2, 1, 1):delay(2.5):scaleTo(0.2, 0, 1):func(functools.partial(arg_1_0.onClose, arg_1_0)):done()
end

function var_0_0.onClose(arg_2_0)
	arg_2_0.panel:stopAllActions()
	arg_2_0:removeSelf()
end

function var_0_0.onMoveUp(arg_3_0)
	local var_3_0, var_3_1 = arg_3_0.panel:xy()

	transition.executeSequence(arg_3_0.panel):moveTo(0.1, var_3_0, var_3_1 + arg_3_0.panel:size().height):done()
end

return var_0_0
