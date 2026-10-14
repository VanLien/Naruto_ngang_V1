local var_0_0 = class("TextView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_text.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.bg"] = "bg",
	baseNode = "baseNode"
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	if not matchLanguage({
		"cn",
		"tw"
	}) then
		arg_1_1.width = (arg_1_1.width or 0) + 160
	else
		arg_1_1.width = (arg_1_1.width or 0) + 135
	end

	local var_1_0 = 30
	local var_1_1 = 30
	local var_1_2 = rich.createWithWidth(arg_1_1.content, arg_1_1.fontSize or 40, nil, arg_1_1.width or 580, 15):addTo(arg_1_0.baseNode, 99):setAnchorPoint(cc.p(0, 1))
	local var_1_3 = math.max(var_1_2:getContentSize().height, 240) + var_1_1 * 2

	var_1_2:xy(var_1_0, var_1_3 - 40)
	arg_1_0.bg:size(var_1_2:getContentSize().width + var_1_0 * 2, var_1_3)
end

return var_0_0
