local var_0_0 = class("ChooseDetailView", Dialog)

var_0_0.RESOURCE_FILENAME = "common_choose_detail.json"
var_0_0.RESOURCE_BINDING = {
	textNum = "textNum",
	subList = "subList",
	bg = "bg",
	awardItem = "awardItem",
	text = "text",
	textName = "textName",
	textTip = "textTip",
	icon = {
		varname = "icon",
		binds = {
			event = "extend",
			class = "icon_key",
			props = {
				noListener = true,
				data = bindHelper.self("data"),
				onNode = function(arg_1_0)
					local var_1_0 = arg_1_0:size()

					arg_1_0:alignCenter(var_1_0)
				end
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("awardItem"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								bind.click(arg_2_0, arg_3_0, {
									method = functools.partial(arg_2_0.itemClick, arg_3_0, arg_2_2, arg_2_3)
								})
							end
						}
					})
				end,
				onAfterBuild = function(arg_4_0)
					return
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1)
	Dialog.onCreate(arg_5_0)
	arg_5_0.subList:setScrollBarEnabled(false)

	arg_5_0.itemDatas = idlers.newWithMap({})
	arg_5_0.data = {
		key = arg_5_1.key,
		num = arg_5_1.num
	}

	local var_5_0 = {}
	local var_5_1 = 0
	local var_5_2 = dataEasy.getCfgByKey(arg_5_1.key)
	local var_5_3 = dataEasy.getNumByKey(arg_5_1.key)

	for iter_5_0, iter_5_1 in csvMapPairs(var_5_2.specialArgsMap) do
		var_5_1 = var_5_1 + 1

		if not iter_5_1.card then
			for iter_5_2, iter_5_3 in csvMapPairs(iter_5_1) do
				table.insert(var_5_0, {
					isSel = false,
					key = iter_5_2,
					num = iter_5_3
				})
			end
		end

		if iter_5_1.card then
			for iter_5_4, iter_5_5 in csvMapPairs(iter_5_1.card) do
				table.insert(var_5_0, {
					key = "card",
					isSel = false,
					num = iter_5_5
				})
			end
		end
	end

	table.sort(var_5_0, dataEasy.sortItemCmp)
	arg_5_0.itemDatas:update(var_5_0)
	arg_5_0.textName:text(var_5_2.name)
	arg_5_0.textNum:text(gLanguageCsv.have .. ":" .. var_5_3)

	local var_5_4 = math.floor(var_5_1 / 5)

	var_5_4 = var_5_4 > 3 and 3 or var_5_4

	local var_5_5 = math.floor(arg_5_0.list:height() / 4)
	local var_5_6 = (4 - var_5_4 - 1) * var_5_5

	arg_5_0.bg:height(arg_5_0.bg:height() - var_5_6)
	arg_5_0.list:height(arg_5_0.list:height() - var_5_6)
	arg_5_0.list:y(arg_5_0.list:y() + var_5_6 / 2)
	arg_5_0.text:y(arg_5_0.text:y() - var_5_6 / 2)
	arg_5_0.textTip:y(arg_5_0.textTip:y() - var_5_6 / 2)
	arg_5_0.icon:y(arg_5_0.icon:y() - var_5_6 / 2)
	arg_5_0.textNum:y(arg_5_0.textNum:y() - var_5_6 / 2)
	arg_5_0.textName:y(arg_5_0.textName:y() - var_5_6 / 2)
end

function var_0_0.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	gGameUI:showItemDetail(arg_6_2, {
		key = arg_6_4.key,
		num = arg_6_4.num
	})
end

return var_0_0
