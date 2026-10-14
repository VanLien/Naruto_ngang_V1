local var_0_0 = class("ActivityQualityExchangeFragmentSelectView", Dialog)

var_0_0.RESOURCE_FILENAME = "activity_quality_exchange_helditem_select.json"
var_0_0.RESOURCE_BINDING = {
	tipPanel = "tipPanel",
	item = "item",
	title = "title",
	innerList = "innerList",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 6,
				data = bindHelper.self("datas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.num ~= arg_1_1.num then
						return arg_1_0.num > arg_1_1.num
					end

					return arg_1_0.key < arg_1_1.key
				end,
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0, var_2_1 = uiEasy.setIconName(arg_2_3.key, arg_2_3.num)

					arg_2_1:get("name"):hide()
					arg_2_1:removeChildByName("richName")

					local var_2_2 = beauty.singleTextLimitWord(var_2_0, {
						fontSize = 40
					}, {
						width = 240
					}):xy(arg_2_1:get("name"):xy()):addTo(arg_2_1, 10, "richName")

					text.addEffect(var_2_2, var_2_1)
					bind.extend(arg_2_0, arg_2_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								if arg_2_0.hasItemCb() then
									arg_3_0:setTouchEnabled(false)
								end
							end
						}
					})

					if arg_2_0.hasItemCb() then
						bind.touch(arg_2_0, arg_2_1:get("icon"), {
							methods = {
								ended = functools.partial(arg_2_0.itemClick, arg_2_2, arg_2_3)
							}
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick"),
				hasItemCb = bindHelper.self("hasItemCb")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0.params = arg_4_1

	if arg_4_0.params.title then
		arg_4_0.title:get("textNote1"):text(arg_4_0.params.title[1])
		arg_4_0.title:get("textNote2"):text(arg_4_0.params.title[2])
		adapt.oneLinePos(arg_4_0.title:get("textNote1"), arg_4_0.title:get("textNote2"))
	end

	arg_4_0.datas = {}

	for iter_4_0, iter_4_1 in ipairs(arg_4_0.params.data) do
		if dataEasy.isFragmentCard(iter_4_1.key) then
			table.insert(arg_4_0.datas, iter_4_1)
		end
	end

	arg_4_0.hasItemCb = arg_4_0.params.cb ~= nil

	arg_4_0.tipPanel:visible(itertools.size(arg_4_0.datas) == 0)

	if arg_4_1.tip then
		arg_4_0.tipPanel:get("textTip"):text(arg_4_1.tip)
	end

	Dialog.onCreate(arg_4_0)
end

function var_0_0.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.params.cb then
		arg_5_0.params.cb(arg_5_3.key)
	end

	arg_5_0:onClose()
end

return var_0_0
