local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = class("ActivityClientShowView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_client_show.json"
var_0_1.RESOURCE_BINDING = {
	img = "img",
	timeLabel = "timeLabel",
	list = "list",
	time = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	timeLimit = {
		varname = "timeLimit",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = csv.yunying.yyhuodong[arg_1_1]

	if var_1_0.clientParam.panelImg then
		arg_1_0.img:texture(var_1_0.clientParam.panelImg)

		local var_1_1 = var_1_0.clientParam.panelImgPos

		if var_1_1 then
			local var_1_2, var_1_3 = arg_1_0.img:xy()

			arg_1_0.img:xy(var_1_2 + var_1_1.x, var_1_3 + var_1_1.y)
		end
	end

	if var_1_0.clientParam.isHideDate then
		arg_1_0.timeLimit:hide()
	else
		arg_1_0.timeLimit:show():text(time.getActivityOpenDate(arg_1_1))
	end

	beauty.textScroll({
		isRich = true,
		fontSize = 46,
		list = arg_1_0.list,
		strs = {
			verticalSpace = 21,
			str = "#C0x8A5B0C#" .. var_1_0.rDesc
		}
	})
	var_0_0.setCountdown(arg_1_0, arg_1_1, arg_1_0.timeLabel, arg_1_0.time, {
		labelChangeCb = function()
			return
		end
	})
end

return var_0_1
