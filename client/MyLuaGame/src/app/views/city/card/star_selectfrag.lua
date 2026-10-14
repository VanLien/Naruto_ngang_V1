local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CardStarSelectFragView", Dialog)

var_0_2.RESOURCE_FILENAME = "zawake_choose_frag.json"
var_0_2.RESOURCE_BINDING = {
	item = "item",
	["tipPanel.textTip"] = "textTip",
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
				data = bindHelper.self("showData"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					uiEasy.setIconName(arg_1_3.id, nil, {
						node = arg_1_1:get("name"),
						width = arg_1_1:width()
					})
					bind.extend(arg_1_0, arg_1_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.id,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								arg_2_0:setTouchEnabled(false)

								if arg_1_3.num == 0 then
									arg_2_0:get("num"):text(0)
								end
							end
						}
					})
					bind.touch(arg_1_0, arg_1_1:get("icon"), {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	tipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	arg_3_0.selectedFragId = arg_3_1.selectedFragId

	local var_3_0 = arg_3_1.cardId
	local var_3_1 = csv.cards[var_3_0]
	local var_3_2 = var_3_1.fragID

	arg_3_0.showData = idlers.new({})
	arg_3_0.showTip = idler.new(false)

	local var_3_3 = {}
	local var_3_4 = dataEasy.getNumByKey(var_3_2)

	if var_3_4 > 0 then
		var_3_3[var_3_2] = {
			itemNum = 1,
			id = var_3_2,
			num = var_3_4,
			cardType = var_3_1.cardType
		}
	end

	if dataEasy.isUnlock(gUnlockCsv.zawake) and var_3_1.zawakeFragID > 0 then
		local var_3_5 = dataEasy.getNumByKey(var_3_1.zawakeFragID)

		if var_3_5 > 0 then
			var_3_3[var_3_1.zawakeFragID] = {
				itemNum = 1,
				id = var_3_1.zawakeFragID,
				num = var_3_5,
				cardType = var_3_1.cardType
			}
		end
	end

	table.sort(var_3_3, function(arg_4_0, arg_4_1)
		if arg_4_0.cardType ~= arg_4_1.cardType then
			return arg_4_0.cardType > arg_4_1.cardType
		end

		if arg_4_0.num ~= arg_4_1.num then
			return arg_4_0.num > arg_4_1.num
		end

		return arg_4_0.id < arg_4_1.id
	end)
	arg_3_0.showData:update(var_3_3)

	local var_3_6 = csv.zawake.exchange[fragID]

	arg_3_0.textTip:text(gLanguageCsv.fragMentNotNum)
	arg_3_0.showTip:set(itertools.size(var_3_3) == 0)
	Dialog.onCreate(arg_3_0)
end

function var_0_2.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.selectedFragId:set(arg_5_3.id)
	var_0_1.onClose(arg_5_0)
end

return var_0_2
