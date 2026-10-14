local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ShopAutoSellView", Dialog)

var_0_1.RESOURCE_FILENAME = "shop_sell.json"
var_0_1.RESOURCE_BINDING = {
	["cost.imgIcon"] = "imgIcon",
	item = "item",
	maskPanel = "maskPanel",
	["cost.textCost"] = "textCost",
	["cost.textNote"] = "textNote",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	btnSell = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCell")
			}
		}
	},
	["btnSell.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("panel"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num
							}
						}
					})

					local var_1_0 = dataEasy.getCfgByKey(arg_1_3.id)
					local var_1_1 = beauty.singleTextLimitWord(var_1_0.name, {
						fontSize = 40
					}, {
						width = 240
					}):xy(125, 26):addTo(arg_1_1, 2)

					text.addEffect(var_1_1, {
						color = ui.NEWCOLORS.BROWN1
					})
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.itemDatas = arg_2_1
	arg_2_0.cb = arg_2_2
	arg_2_0.reward = {}

	local var_2_0 = 0

	for iter_2_0, iter_2_1 in ipairs(arg_2_0.itemDatas) do
		var_2_0 = var_2_0 + dataEasy.getCfgByKey(iter_2_1.id).sellPrice * iter_2_1.num
	end

	arg_2_0.textCost:text(mathEasy.getShortNumber(var_2_0, 2))
	table.insert(arg_2_0.reward, {
		"gold",
		var_2_0
	})
	adapt.oneLineCenterPos(cc.p(200, 30), {
		arg_2_0.textNote,
		arg_2_0.textCost,
		arg_2_0.imgIcon
	}, cc.p(6, 0))

	local var_2_1 = #arg_2_0.itemDatas

	if var_2_1 < 5 then
		local var_2_2, var_2_3 = arg_2_0.list:xy()
		local var_2_4 = arg_2_0.list:size()
		local var_2_5 = var_2_3 + var_2_4.height / 2
		local var_2_6 = arg_2_0.list:getItemsMargin()
		local var_2_7 = arg_2_0.item:size().width * var_2_1 + (var_2_1 - 1) * var_2_6

		arg_2_0.list:size(var_2_7, var_2_4.height)
		arg_2_0.list:anchorPoint(0.5, 0.5)
		arg_2_0.list:xy(display.sizeInView.width / 2, var_2_5)
	else
		uiEasy.setBottomMask(arg_2_0.list, arg_2_0.maskPanel, "x")
	end

	Dialog.onCreate(arg_2_0)
end

function var_0_1.onCell(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in ipairs(arg_3_0.itemDatas) do
		var_3_0[iter_3_1.id] = iter_3_1.num
	end

	local var_3_1 = arg_3_0.reward

	var_0_0.onClose(arg_3_0)
	gGameApp:requestServer("/game/role/item/sell", function()
		gGameUI:showGainDisplay(var_3_1, {
			raw = false
		})
	end, var_3_0)
end

function var_0_1.onClose(arg_5_0)
	arg_5_0:addCallbackOnExit(arg_5_0.cb)
	var_0_0.onClose(arg_5_0)
end

return var_0_1
