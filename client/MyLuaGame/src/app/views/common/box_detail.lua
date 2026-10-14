local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("BoxDetailView", Dialog)

var_0_1.RESOURCE_FILENAME = "common_box_detail.json"
var_0_1.RESOURCE_BINDING = {
	content = "contentLabel",
	list = "list",
	title = {
		varname = "titleLabel",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOk = {
		varname = "btnOk",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOk")
			}
		}
	},
	["btnOk.title"] = {
		varname = "btnText",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("btnText")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1.cb
	arg_1_0.data = arg_1_1.data
	arg_1_0.state = arg_1_1.state or 1
	arg_1_0.clearFast = arg_1_1.clearFast

	local var_1_0 = arg_1_0.state == 1 and "normal" or "hsl_gray"

	cache.setShader(arg_1_0.btnOk, false, var_1_0)

	arg_1_0.btnText = idler.new(arg_1_1.btnText or gLanguageCsv.commonTextOk)

	if arg_1_0.state ~= 1 then
		arg_1_0.btnText:set(arg_1_1.btnText or gLanguageCsv.received)
	end

	arg_1_0.btnOk:setTouchEnabled(arg_1_0.state == 1)

	if arg_1_1.title then
		arg_1_0.titleLabel:text(arg_1_1.title)
	end

	if arg_1_1.content then
		adapt.setTextAdaptWithSize(arg_1_0.contentLabel, {
			horizontal = "center",
			vertical = "center",
			str = arg_1_1.content,
			size = cc.size(1000, 168)
		})
	end

	uiEasy.createItemsToList(arg_1_0, arg_1_0.list, arg_1_0.data, {
		onAfterBuild = function(arg_2_0)
			arg_2_0:adaptTouchEnabled():setItemAlignCenter()
		end
	})
	Dialog.onCreate(arg_1_0)
end

function var_0_1.onClickOk(arg_3_0)
	if arg_3_0.state ~= 1 then
		return
	end

	arg_3_0:addCallbackOnExit(arg_3_0.cb)

	if arg_3_0.clearFast then
		var_0_0.onClose(arg_3_0)
	else
		Dialog.onClose(arg_3_0)
	end

	return arg_3_0
end

return var_0_1
