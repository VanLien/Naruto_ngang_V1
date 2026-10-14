local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiCityView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_city.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.gold,
	var_0_0.diamond,
	var_0_0.stamina,
	var_0_0.daijinquan,
	var_0_0.djqlimit
})

function var_0_2.onCreate(arg_1_0)
	var_0_1.onCreate(arg_1_0, {
		"stamina"
	})
end

return var_0_2
