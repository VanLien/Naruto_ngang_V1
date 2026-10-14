local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiGridWalkView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_grid_walk.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.title,
	var_0_0.gold,
	var_0_0.diamond,
	var_0_0.gridWalk
})

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0.iconNum = arg_1_1.iconNum

	var_0_1.onCreate(arg_1_0, {
		"title"
	}, arg_1_1)

	arg_1_0.items = gGameModel.role:getIdler("items")

	idlereasy.any({
		arg_1_0.iconNum
	}, function(arg_2_0, arg_2_1)
		local var_2_0 = math.max(arg_2_1, 0)

		arg_1_0.num1:text(mathEasy.getShortNumber(var_2_0, 2))
	end)
end

return var_0_2
