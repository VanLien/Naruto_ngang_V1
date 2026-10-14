local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiGemDrawView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_gem_draw.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.title,
	var_0_0.gold,
	var_0_0.diamond,
	var_0_0.goldGem,
	var_0_0.rmbGem
})

function var_0_2.onCreate(arg_1_0, arg_1_1)
	var_0_1.onCreate(arg_1_0, {
		"title"
	}, arg_1_1)
end

function var_0_2.onGoldGemClick(arg_2_0)
	arg_2_0:buyTickets("goldGem", "gold")
end

function var_0_2.onRmbGemClick(arg_3_0)
	arg_3_0:buyTickets("rmbGem", "rmb")
end

return var_0_2
