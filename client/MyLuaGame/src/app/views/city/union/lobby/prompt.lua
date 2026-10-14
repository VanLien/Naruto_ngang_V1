local var_0_0 = {
	destroy = "/game/union/destroy",
	demote = "/game/union/chairman/demote",
	quit = "/game/union/quit",
	kick = "/game/union/kick",
	promote = "/game/union/chairman/promote",
	joinup = "/game/union/joinup",
	swap = "/game/union/chairman/swap"
}
local var_0_1 = class("UnionPromptView", Dialog)

var_0_1.RESOURCE_FILENAME = "union_prompt.json"
var_0_1.RESOURCE_BINDING = {
	txt = "txt",
	mask = "mask",
	pos = "pos",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
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
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.mask:hide()

	arg_1_0.params = arg_1_1

	if arg_1_1.numTip then
		arg_1_0.txt:text(arg_1_1.numTip)
	end

	if arg_1_1.needConsider then
		arg_1_0:considerTime()
	end

	local var_1_0 = cc.size(800, 460)
	local var_1_1, var_1_2 = beauty.textScroll({
		fontSize = 50,
		verticalSpace = 10,
		isRich = true,
		margin = 20,
		align = "center",
		size = var_1_0,
		effect = {
			color = ui.COLORS.NORMAL.DEFAULT
		},
		strs = arg_1_1.content
	})
	local var_1_3 = 0

	if var_1_2 < var_1_0.height then
		var_1_3 = -(var_1_0.height - var_1_2) / 2
	end

	var_1_1:addTo(arg_1_0.pos, 3):xy(-var_1_0.width / 2, -var_1_0.height / 2 + var_1_3)
	Dialog.onCreate(arg_1_0)
end

function var_0_1.onClickOK(arg_2_0)
	gGameApp:requestServer(var_0_0[arg_2_0.params.typ], function(arg_3_0)
		local var_3_0 = arg_2_0.params.cb

		arg_2_0:onCloseFast()

		if var_3_0 then
			var_3_0()
		end
	end, unpack(arg_2_0.params.requestParams or {}))
end

function var_0_1.considerTime(arg_4_0)
	arg_4_0.btnOK:setEnabled(false)
	arg_4_0.mask:show()

	local var_4_0 = 5

	arg_4_0:enableSchedule():schedule(function(arg_5_0)
		arg_4_0.mask:get("time"):text(var_4_0)

		var_4_0 = var_4_0 - 1

		if var_4_0 < 0 then
			arg_4_0.mask:hide()
			arg_4_0.btnOK:setEnabled(true)
			arg_4_0:unSchedule("attrLvUp")
		end
	end, 1, 0, "attrLvUp")
end

function var_0_1.onClose(arg_6_0, arg_6_1)
	Dialog.onClose(arg_6_0, arg_6_1)
end

return var_0_1
