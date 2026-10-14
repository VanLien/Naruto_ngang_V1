local var_0_0 = require("app.views.city.develop.strange_meteor.tools")
local var_0_1 = class("RoleDayAwardOpenView", cc.load("mvc").ViewBase)
local var_0_2 = 380
local var_0_3 = 900

var_0_1.RESOURCE_FILENAME = "strange_meteor_unlock_tips.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["panel.bg"] = "bg",
	panel = "panel",
	["panel.title"] = "title",
	closePanel = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 30,
				data = bindHelper.self("strData"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("imgTick", "textCannot")

					var_1_0.imgTick:visible(arg_1_3.isArrive):xy(var_1_0.imgTick:x() - 75, var_1_0.imgTick:y() - 25)
					var_1_0.textCannot:visible(not arg_1_3.isArrive):xy(var_1_0.textCannot:x() - 75, var_1_0.textCannot:y() - 25)

					local var_1_1 = rich.createWithWidth(arg_1_3.str, 42, nil, 800):anchorPoint(0, 0.5):x(0):addTo(arg_1_1)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.strData = var_0_0.getActiveConditionStr(arg_3_1)

	local var_3_0 = arg_3_0.panel:width()
	local var_3_1 = display.sizeInView.width - var_3_0
	local var_3_2 = math.min(display.sizeInView.width / 2, var_3_1)

	if arg_3_1 == 2 then
		var_3_2 = 650
	elseif arg_3_1 == 5 then
		var_3_2 = 850
	end

	arg_3_0.panel:x(var_3_2)
end

function var_0_1.onAfterBuild(arg_4_0)
	local var_4_0 = cc.clampf(arg_4_0.list:height() + arg_4_0.item:height(), var_0_2, var_0_3)

	arg_4_0.list:height(var_4_0 - 210)
	arg_4_0.list:width(820)
	arg_4_0.bg:height(var_4_0 - 40)
	arg_4_0.bg:width(920)
	arg_4_0.bg:x(arg_4_0.bg:width() / 2)
	arg_4_0.title:y(var_4_0 - 120)
	arg_4_0.panel:y((1260 - var_4_0) / 2)
	arg_4_0.panel:width(920)
end

return var_0_1
