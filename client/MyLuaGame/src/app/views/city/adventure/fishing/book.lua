local var_0_0 = class("FishingBookView", Dialog)

var_0_0.RESOURCE_FILENAME = "fishing_book.json"
var_0_0.RESOURCE_BINDING = {
	["left.subList"] = "subList",
	["left.item"] = "item",
	right = "right",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["left.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 10,
				columnSize = 4,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "fish_icon",
						props = {
							data = {
								key = arg_1_3.key
							},
							onNode = function(arg_2_0)
								arg_2_0:align(cc.p(0.5, 0.5), 85, 85)

								if arg_1_3.selectEffect then
									arg_1_3.selectEffect:removeSelf()
									arg_1_3.selectEffect:align(cc.p(0.5, 0.5), 90, 90)
									arg_2_0:add(arg_1_3.selectEffect, -1)
								end
							end
						}
					})
					bind.click(arg_1_0, arg_1_1, {
						method = functools.partial(arg_1_0.itemClick, arg_1_3)
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0:initModel()

	arg_3_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_3_0.item:size()):retain()
	arg_3_0.itemDatas = idlers.new({})
	arg_3_0.selectItem = idler.new(1)

	idlereasy.when(arg_3_0.fish, function(arg_4_0, arg_4_1)
		local var_4_0 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.fishing.fish) do
			if iter_4_1.bookId ~= 0 then
				var_4_0[iter_4_0] = {
					key = iter_4_0,
					name = iter_4_1.name,
					point = iter_4_1.point,
					needLv = iter_4_1.needLv,
					desc = iter_4_1.desc,
					rare = iter_4_1.rare,
					bookId = iter_4_1.bookId,
					counter = arg_4_1[iter_4_0] and arg_4_1[iter_4_0].counter or 0,
					bigCounter = arg_4_1[iter_4_0] and arg_4_1[iter_4_0].big_counter or 0,
					lenghtMax = arg_4_1[iter_4_0] and arg_4_1[iter_4_0].length_max or 0
				}
			end
		end

		arg_3_0.itemDatas:update(var_4_0)
	end)
	arg_3_0.selectItem:addListener(function(arg_5_0, arg_5_1)
		local var_5_0 = arg_3_0.itemDatas:atproxy(arg_5_0)

		if var_5_0 then
			var_5_0.selectEffect = arg_3_0.selectEffect

			arg_3_0:resetShowPanel(var_5_0)
		end
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_0.resetShowPanel(arg_6_0, arg_6_1)
	bind.extend(arg_6_0, arg_6_0.right, {
		class = "fish_icon",
		props = {
			data = {
				key = arg_6_1.key
			},
			onNode = function(arg_7_0)
				arg_7_0:align(cc.p(0.5, 0.5), arg_6_0.right:get("icon"):x() - 20, arg_6_0.right:get("icon"):y() - 15):scale(1.4)
			end
		}
	})
	arg_6_0.right:get("name"):text(arg_6_1.name)

	local var_6_0 = {
		gLanguageCsv.lowFish,
		gLanguageCsv.middleFish,
		gLanguageCsv.highFish
	}

	arg_6_0.right:get("quality"):text(var_6_0[arg_6_1.rare])
	arg_6_0.right:get("point1"):text(arg_6_1.point)
	adapt.oneLinePos(arg_6_0.right:get("point"), arg_6_0.right:get("point1"), cc.p(15, 0), "left")
	arg_6_0.right:get("level1"):text("Lv." .. arg_6_1.needLv)
	adapt.oneLinePos(arg_6_0.right:get("level"), arg_6_0.right:get("level1"), cc.p(20, 0), "left")
	beauty.textScroll({
		isRich = true,
		list = arg_6_0.right:get("list"),
		strs = "#C0x5B545B#" .. arg_6_1.desc
	})
	arg_6_0.right:get("totalNum"):text(string.format(gLanguageCsv.fishCounter, arg_6_1.counter))
	arg_6_0.right:get("bigFishNum"):text(string.format(gLanguageCsv.bigFishCounter, arg_6_1.bigCounter))
	arg_6_0.right:get("maxNum"):text(string.format(gLanguageCsv.fishLenghtMax, arg_6_1.lenghtMax))
end

function var_0_0.onItemClick(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.selectItem:set(arg_8_2.key)
end

function var_0_0.initModel(arg_9_0)
	arg_9_0.fish = gGameModel.fishing:getIdler("fish")
end

return var_0_0
