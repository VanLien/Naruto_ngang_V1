local var_0_0 = class("HuntingBuffDetailView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "hunting_buff_detail.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.title"] = "title",
	baseNode = "baseNode"
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.title:text(arg_1_1.name)

	local var_1_0 = rich.createWithWidth("#C0xFFFFFF#" .. arg_1_1.desc, 40, nil, 600):anchorPoint(0.5, 1):addTo(arg_1_0.baseNode, 10, "textNum")

	arg_1_0.baseNode:height(var_1_0:height() + 150)
	arg_1_0.title:y(var_1_0:height() + 90)
	var_1_0:xy(arg_1_0.baseNode:width() / 2, var_1_0:height() + 50)
end

return var_0_0
