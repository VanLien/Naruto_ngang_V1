local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ZawakeChoosFragmentView", Dialog)

var_0_1.RESOURCE_FILENAME = "zawake_choose_frag.json"
var_0_1.RESOURCE_BINDING = {
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
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.cardType ~= arg_1_1.cardType then
						return arg_1_0.cardType > arg_1_1.cardType
					end

					if arg_1_0.num ~= arg_1_1.num then
						return arg_1_0.num > arg_1_1.num
					end

					return arg_1_0.id < arg_1_1.id
				end,
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					uiEasy.setIconName(arg_2_3.id, nil, {
						node = arg_2_1:get("name")
					})
					adapt.setTextScaleWithWidth(arg_2_1:get("name"), nil, 260)
					bind.extend(arg_2_0, arg_2_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.id,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								arg_3_0:setTouchEnabled(false)
							end
						}
					})
					bind.touch(arg_2_0, arg_2_1:get("icon"), {
						methods = {
							ended = functools.partial(arg_2_0.itemClick, arg_2_2, arg_2_3)
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

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.selectedFragId = arg_4_1.selectedFragId

	local var_4_0 = arg_4_1.fragID

	arg_4_0.showData = idlers.new({})
	arg_4_0.showTip = idler.new(false)

	local var_4_1 = csv.zawake.exchange[var_4_0]

	idlereasy.any({
		gGameModel.role:getIdler("frags"),
		gGameModel.role:getIdler("items")
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = {}

		for iter_5_0, iter_5_1 in pairs(arg_5_1) do
			if dataEasy.isFragmentCard(iter_5_0) then
				local var_5_1 = csv.fragments[iter_5_0]

				if var_5_1.type == 1 then
					local var_5_2 = csv.cards[var_5_1.combID]
					local var_5_3 = csv.unit[var_5_2.unitID]
					local var_5_4 = dataEasy.getCfgByKey(iter_5_0).quality

					for iter_5_2, iter_5_3 in csvMapPairs(var_4_1.needFrags) do
						if iter_5_3[1] == var_5_4 and (iter_5_3[2] == -1 or var_5_3.natureType == iter_5_3[2] or var_5_3.natureType2 and var_5_3.natureType2 == iter_5_3[2]) then
							var_5_0[iter_5_0] = {
								id = iter_5_0,
								num = iter_5_1,
								itemNum = iter_5_3[3],
								cardType = var_5_2.cardType
							}
						end
					end

					for iter_5_4, iter_5_5 in csvMapPairs(var_4_1.needSpecialFrags) do
						if iter_5_0 == iter_5_5[1] then
							var_5_0[iter_5_0] = {
								id = iter_5_0,
								num = iter_5_1,
								itemNum = iter_5_5[2],
								cardType = var_5_2.cardType
							}
						end
					end
				end
			end
		end

		for iter_5_6, iter_5_7 in csvMapPairs(var_4_1.needSpecialFrags) do
			if not dataEasy.isFragmentCard(iter_5_7[1]) then
				local var_5_5 = dataEasy.getNumByKey(iter_5_7[1])

				if var_5_5 > 0 then
					var_5_0[iter_5_7[1]] = {
						cardType = 5,
						id = iter_5_7[1],
						num = var_5_5,
						itemNum = iter_5_7[2]
					}
				end
			end
		end

		arg_4_0.showData:update(var_5_0)
		arg_4_0.textTip:text(gLanguageCsv.fragMentNotNum)
		arg_4_0.showTip:set(itertools.size(var_5_0) == 0)
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.onItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.selectedFragId:set(arg_6_3.id)
	var_0_0.onClose(arg_6_0)
end

return var_0_1
