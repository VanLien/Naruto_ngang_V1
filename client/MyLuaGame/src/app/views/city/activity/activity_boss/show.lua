local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ActivityBossShowView", var_0_0)

var_0_1.RESOURCE_FILENAME = "activity_boss_show.json"
var_0_1.RESOURCE_BINDING = {
	closePanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	gGameUI:disableTouchDispatch(0.5)
end

function var_0_1.onClose(arg_2_0)
	var_0_0.onClose(arg_2_0)
end

return var_0_1
