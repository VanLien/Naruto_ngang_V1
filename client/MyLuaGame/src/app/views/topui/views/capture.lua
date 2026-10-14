local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiCaptureView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_capture.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.title,
	var_0_0.capture
})

function var_0_2.onCreate(arg_1_0, arg_1_1)
	var_0_1.onCreate(arg_1_0, {
		"title"
	}, arg_1_1)

	arg_1_0.items = gGameModel.role:getIdler("items")

	idlereasy.when(arg_1_0.items, function(arg_2_0, arg_2_1)
		arg_1_0.num1:text(mathEasy.getShortNumber(arg_2_1[game.SPRITE_BALL_ID.normal] or 0, 2))
		arg_1_0.num2:text(mathEasy.getShortNumber(arg_2_1[game.SPRITE_BALL_ID.hero] or 0, 2))
		arg_1_0.num3:text(mathEasy.getShortNumber(arg_2_1[game.SPRITE_BALL_ID.nightmare] or 0, 2))
	end)
end

return var_0_2
