local var_0_0 = class("ActivityAnniversaryLoginGiftView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "activity_anniversary_login_gift.json"
var_0_0.RESOURCE_BINDING = {
	list = "list",
	["btn.lable"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	btn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	print_r(arg_1_1)
	uiEasy.createItemsToList(arg_1_0, arg_1_0.list, arg_1_1.data, {
		margin = 20,
		onAfterBuild = function()
			arg_1_0.list:setItemAlignCenter()
		end
	})

	arg_1_0.cb = arg_1_1.cb
end

function var_0_0.onBtnClick(arg_3_0)
	arg_3_0:addCallbackOnExit(arg_3_0.cb)
	arg_3_0:onClose()
end

return var_0_0
