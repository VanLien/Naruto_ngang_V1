local var_0_0 = {
	play = 3,
	start = 2,
	closed = 1
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BeachIceTipsView", Dialog)

var_0_2.RESOURCE_FILENAME = "beach_ice_tip.json"
var_0_2.RESOURCE_BINDING = {
	title = "titleLabel",
	content = "contentLabel",
	text = "text",
	textNum = "timeText",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOK = {
		varname = "btnOK",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOK")
			}
		}
	},
	btnCancel = {
		varname = "btnCancel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOkCenter = {
		varname = "btnOkCenter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOK")
			}
		}
	},
	["btnOkCenter.title"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0:enableSchedule()

	arg_1_1 = arg_1_1 or {}
	arg_1_0.params = arg_1_1
	arg_1_0._okcb = arg_1_1.cb

	local var_1_0 = arg_1_1.time
	local var_1_1, var_1_2 = arg_1_0.btnOK:getPosition()

	if arg_1_1.title then
		arg_1_0.titleLabel:text(arg_1_1.title)
	end

	local var_1_3 = arg_1_0.contentLabel:size()

	arg_1_0.btnOK:show()
	arg_1_0.btnCancel:show()

	local var_1_4 = "center"
	local var_1_5, var_1_6 = beauty.textScroll({
		isRich = true,
		margin = 20,
		size = var_1_3,
		fontSize = arg_1_1.fontSize or 50,
		effect = {
			color = ui.COLORS.NORMAL.DEFAULT
		},
		strs = arg_1_1.content or arg_1_1.strs,
		verticalSpace = arg_1_1.verticalSpace or 10,
		align = arg_1_1.align or var_1_4
	})
	local var_1_7 = 0

	if var_1_6 < var_1_3.height then
		var_1_7 = -(var_1_3.height - var_1_6) / 2
	end

	var_1_5:addTo(arg_1_0.contentLabel, 10):y(var_1_7)

	local var_1_8 = arg_1_1.dialogParams or {}

	var_1_8.clearFast = var_1_8.clearFast or arg_1_1.clearFast

	arg_1_0:enableSchedule():schedule(function()
		arg_1_0.timeText:text(var_1_0)

		if var_1_0 <= 0 then
			arg_1_0:unSchedule("countdownLess")
			arg_1_0:onClickOK()
		end

		var_1_0 = var_1_0 - 1
	end, 1, 0, "countdownLess")

	if arg_1_1.state == var_0_0.start then
		arg_1_0:unSchedule("countdownLess")
		arg_1_0.timeText:hide()
		arg_1_0.text:hide()
	end

	Dialog.onCreate(arg_1_0, var_1_8)
end

function var_0_2.onClickOK(arg_3_0)
	arg_3_0:addCallbackOnExit(arg_3_0._okcb)
	Dialog.onClose(arg_3_0)

	return arg_3_0
end

function var_0_2.onClose(arg_4_0)
	Dialog.onClose(arg_4_0)
end

return var_0_2
