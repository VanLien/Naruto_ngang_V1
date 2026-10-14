local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionFightFinalOverView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "union_fight_final_over.json"
var_0_1.RESOURCE_BINDING = {
	bg1 = "bg1",
	title = "title",
	childPanel = "childPanel"
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	local var_1_0, var_1_1 = arg_1_0.childPanel:xy()
	local var_1_2 = arg_1_0.childPanel:size()
	local var_1_3 = var_1_2.width
	local var_1_4 = var_1_2.height

	arg_1_0.view = gGameUI:createView("city.union.union_fight.top8_info_view"):init(true, true, arg_1_1):addTo(arg_1_0.childPanel, 999):xy(-420, -210):scale(0.95)

	local var_1_5, var_1_6 = arg_1_0.bg1:xy()
	local var_1_7 = arg_1_0:getResourceNode()
	local var_1_8 = arg_1_0.bg1:size()
end

return var_0_1
