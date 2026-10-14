local var_0_0 = require("app.views.city.card.property_swap.view")
local var_0_1 = class("PropertySwapChooseView", Dialog)
local var_0_2 = var_0_0.SWAP_TYPE

var_0_1.RESOURCE_FILENAME = "card_property_swap_choose_item.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	empty = "empty",
	list = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 24,
				columnSize = 6,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCardList", true),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name")

					bind.extend(arg_1_0, var_1_0.icon, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								arg_2_0:setTouchEnabled(false)
							end
						}
					})
					var_1_0.name:text(arg_1_3.name)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_1, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemChoose")
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
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.cb = arg_3_3
	arg_3_0.itemDatas = idlers.new()
	arg_3_0.showTab = arg_3_1

	local var_3_0 = {}
	local var_3_1

	var_3_1 = arg_3_1 == var_0_2.NATURE

	local var_3_2

	var_3_2 = arg_3_1 == var_0_2.NVALUE

	local var_3_3

	var_3_3 = arg_3_1 == var_0_2.EFFORTVALUE

	for iter_3_0, iter_3_1 in csvPairs(csv.items) do
		if iter_3_1.specialArgsMap.character then
			local var_3_4 = dataEasy.getNumByKey(iter_3_0)

			if var_3_4 > 0 then
				table.insert(var_3_0, {
					key = iter_3_0,
					num = var_3_4,
					name = iter_3_1.name
				})
			end
		end
	end

	arg_3_0.empty:setVisible(#var_3_0 <= 0)
	arg_3_0.itemDatas:update(var_3_0)
	Dialog.onCreate(arg_3_0)
end

function var_0_1.onItemChoose(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0.cb(nil, arg_4_4.key)
	arg_4_0:onClose()
end

function var_0_1.onSortCardList(arg_5_0, arg_5_1)
	return function(arg_6_0, arg_6_1)
		return tonumber(arg_6_0.key) < tonumber(arg_6_1.key)
	end
end

return var_0_1
