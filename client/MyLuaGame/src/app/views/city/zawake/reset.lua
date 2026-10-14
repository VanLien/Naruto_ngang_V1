local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("ZawakeResetView", Dialog)

var_0_2.RESOURCE_FILENAME = "zawake_reset.json"
var_0_2.RESOURCE_BINDING = {
	innerList = "innerList",
	["costPanel.cost"] = "cost",
	item = "item",
	costPanel = "costPanel",
	["costPanel.icon"] = "icon",
	["costPanel.txt1"] = "txt1",
	btnReset = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetClick")
			}
		}
	},
	titile = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c4b(251, 110, 70, 255)
				}
			}
		}
	},
	tip = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 8,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.val
							}
						}
					})
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1)
	Dialog.onCreate(arg_2_0)

	arg_2_0.zawakeID = arg_2_1

	local var_2_0 = gGameModel.role:read("zawake")[arg_2_1]
	local var_2_1 = var_0_0.getResetCostItems(arg_2_1, var_2_0)

	arg_2_0.costDatas = var_2_1

	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		table.insert(var_2_2, {
			key = iter_2_0,
			val = iter_2_1
		})
	end

	arg_2_0.attrDatas = idlers.newWithMap(var_2_2)

	arg_2_0.cost:text(gCommonConfigCsv.zawakeResetOneKeyCost)

	local var_2_3 = arg_2_0.costPanel:size()

	adapt.oneLineCenterPos(cc.p(var_2_3.width / 2, var_2_3.height / 2), {
		arg_2_0.txt1,
		arg_2_0.cost,
		arg_2_0.icon
	}, {
		cc.p(0, 0),
		cc.p(10, 0)
	})
end

function var_0_2.onResetClick(arg_3_0)
	if gGameModel.role:read("rmb") < gCommonConfigCsv.zawakeResetOneKeyCost then
		uiEasy.showDialog("rmb")

		return
	end

	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		content = string.format(gLanguageCsv.zawakeResetDialagTips, gCommonConfigCsv.zawakeResetOneKeyCost),
		cb = function()
			arg_3_0:sendReset()
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_2.sendReset(arg_5_0)
	gGameApp:requestServer("/game/card/zawake/reset", function(arg_6_0)
		gGameUI:showGainDisplay(arg_5_0.costDatas, {
			cb = function()
				arg_5_0:onClose()
			end
		})
	end, arg_5_0.zawakeID)
end

return var_0_2
