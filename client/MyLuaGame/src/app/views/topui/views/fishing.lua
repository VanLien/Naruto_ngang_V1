local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiFishingView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_fishing.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.title,
	var_0_0.diamond,
	var_0_0.fishingGold
})

function var_0_2.onCreate(arg_1_0, arg_1_1)
	var_0_1.onCreate(arg_1_0, {
		"title"
	}, arg_1_1)
end

function var_0_2.onBtnClick(arg_2_0)
	gGameUI:stackUI("city.adventure.fishing.sence_select", nil, nil)
end

return var_0_2
