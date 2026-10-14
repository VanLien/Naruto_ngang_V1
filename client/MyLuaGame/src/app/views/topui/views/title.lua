local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiTitleView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_default.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.title,
	var_0_0.rightTopPanel
})

function var_0_2.onCreate(arg_1_0, arg_1_1)
	var_0_1.onCreate(arg_1_0, {
		"title"
	}, arg_1_1)
	arg_1_0.rightTopPanel:hide()
end

return var_0_2
