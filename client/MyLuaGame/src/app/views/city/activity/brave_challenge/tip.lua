local var_0_0 = class("BraveChallengeTipView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "activity_brave_challenge_tip.json"
var_0_0.RESOURCE_BINDING = {
	["baseNode.btn"] = "btn",
	baseNode = "baseNode",
	["baseNode.img"] = "imgBg",
	["baseNode.list"] = "list"
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_1_0.list,
		strs = arg_1_1.strs
	})
	local var_1_1 = arg_1_0.list:getInnerContainerSize()
	local var_1_2 = arg_1_0.list:size()
	local var_1_3 = var_1_1.height - var_1_2.height

	if var_1_3 > 0 then
		arg_1_0.list:size(var_1_1)

		local var_1_4 = arg_1_0.imgBg:size()

		arg_1_0.imgBg:size(cc.size(var_1_4.width, var_1_4.height + var_1_3))
	end

	arg_1_0.baseNode:xy(arg_1_1.pos)
end

return var_0_0
