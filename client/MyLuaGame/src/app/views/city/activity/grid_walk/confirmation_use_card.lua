local var_0_0 = require("app.views.city.activity.grid_walk.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ConfirmationUseCard", var_0_1)

var_0_2.RESOURCE_FILENAME = "grid_walk_use_card.json"
var_0_2.RESOURCE_BINDING = {
	cardPos = "cardPos",
	btnYes = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onYesClick")
			}
		}
	},
	btnNo = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	txt = {
		varname = "txt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = cc.c3b(209, 52, 55)
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0.callBack = arg_1_1.callBack

	local var_1_0 = arg_1_1.card
	local var_1_1 = arg_1_1.itemID
	local var_1_2 = csv.items[var_1_1].desc

	if var_1_1 == var_0_0.ITEMS.steeringCard then
		var_1_2 = string.format(gLanguageCsv.gridWalkSteerTips, arg_1_1.steps)
	end

	arg_1_0.txt:text(var_1_2)
	var_1_0:clone():anchorPoint(0.5, 0.5):xy(0, 0):scale(1.5):addTo(arg_1_0.cardPos):get("txt"):hide()
end

function var_0_2.onYesClick(arg_2_0)
	arg_2_0:addCallbackOnExit(arg_2_0.callBack)
	arg_2_0:onClose()
end

return var_0_2
