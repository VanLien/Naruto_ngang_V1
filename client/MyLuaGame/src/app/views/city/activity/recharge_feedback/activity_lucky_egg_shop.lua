local var_0_0 = {
	head = 4,
	vip = 1,
	handbook = 3,
	skin = 5,
	level = 2
}
local var_0_1 = {
	gLanguageCsv.luckyEggShopVipNotEnough,
	gLanguageCsv.luckyEggShopLevelNotEnough,
	gLanguageCsv.luckyEggShopNoCard,
	gLanguageCsv.luckyEggShopVipNotEnough,
	gLanguageCsv.luckyEggShopNoCard
}
local var_0_2 = class("LuckyEggShopView", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "activity_lucky_egg_shop.json"
var_0_2.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	["scorePanel.text"] = "scoreText",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["item.baseNode.costPanel.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				xMargin = 67,
				asyncPreload = 9,
				leftPadding = 1,
				data = bindHelper.self("datas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("baseNode"):multiget("text", "icon", "text2", "text3", "costPanel", "emptyPanel", "num")

					bind.extend(arg_1_0, var_1_0.icon, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.item.key,
								num = arg_1_3.item.key == "card" and arg_1_3.item.num or nil
							}
						}
					})
					var_1_0.icon:get("_icon_"):setTouchEnabled(false)
					var_1_0.text:text(arg_1_3.name)

					local var_1_1 = arg_1_3.item.key == "card" and 1 or arg_1_3.item.num

					var_1_0.num:text("x" .. mathEasy.getShortNumber(var_1_1, 2))
					var_1_0.text3:text(string.format("%s/%s", arg_1_3.maxTime - arg_1_3.step, arg_1_3.maxTime))
					var_1_0.costPanel:get("img"):texture(dataEasy.getIconResByKey(arg_1_3.cost.key))
					var_1_0.costPanel:get("text"):text(arg_1_3.cost.num)
					adapt.oneLineCenterPos(cc.p(136, 40), {
						var_1_0.costPanel:get("img"),
						var_1_0.costPanel:get("text")
					}, cc.p(15, 0))

					if arg_1_3.color then
						text.addEffect(var_1_0.costPanel:get("text"), {
							color = arg_1_3.color
						})
					end

					if arg_1_3.maxTime - arg_1_3.step <= 0 then
						var_1_0.emptyPanel:get("tip"):hide()
						var_1_0.emptyPanel:show()
					elseif arg_1_3.canBuy then
						var_1_0.emptyPanel:hide()
						bind.touch(arg_1_0, arg_1_1:get("baseNode"), {
							methods = {
								ended = functools.partial(arg_1_0.clickCell, t, arg_1_3)
							}
						})
						bind.touch(arg_1_0, var_1_0.icon, {
							methods = {
								ended = functools.partial(arg_1_0.clickCell, t, arg_1_3)
							}
						})
					elseif arg_1_3.isHas then
						var_1_0.emptyPanel:show()
						var_1_0.emptyPanel:get("text"):text(gLanguageCsv.alreadyHas)
						var_1_0.emptyPanel:get("tip"):hide()
					else
						var_1_0.emptyPanel:show()
						var_1_0.emptyPanel:get("text"):text(gLanguageCsv.notUnlock)

						if arg_1_3.limitKey == var_0_0[1] or arg_1_3.limitKey == var_0_0[2] then
							var_1_0.emptyPanel:get("tip"):text(string.format(var_0_1[arg_1_3.limitKey], arg_1_3.limitID)):show()
						else
							var_1_0.emptyPanel:get("tip"):text(var_0_1[arg_1_3.limitKey]):show()
						end

						var_1_0.costPanel:hide()
						var_1_0.text3:hide()
						var_1_0.text2:hide()
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.activityId = arg_2_1
	arg_2_0.huodongId = arg_2_2
	arg_2_0.items = gGameModel.role:getIdler("items")
	arg_2_0.scoreNum = 0

	idlereasy.when(arg_2_0.items, function(arg_3_0, arg_3_1)
		arg_2_0.scoreNum = arg_3_1[game.ITEM_TICKET.luckyEggScore] or 0

		arg_2_0.scoreText:text(arg_2_0.scoreNum)
	end)

	arg_2_0.datas = idlers.new({})

	idlereasy.when(gGameModel.role:getIdler("yyhuodongs"), function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_2_1] or {}).stamps or {}
		local var_4_1 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.itemexchange) do
			if iter_4_1.huodongID == arg_2_2 then
				local var_4_2, var_4_3 = csvNext(iter_4_1.items)
				local var_4_4, var_4_5 = csvNext(iter_4_1.costMap)
				local var_4_6 = var_4_5 <= arg_2_0.scoreNum
				local var_4_7, var_4_8 = csvNext(iter_4_1.limit)
				local var_4_9 = true
				local var_4_10 = false

				if var_4_7 == var_0_0.vip then
					var_4_9 = var_4_8 < gGameModel.role:read("vip_level")
				elseif var_4_7 == var_0_0.level then
					var_4_9 = var_4_8 < gGameModel.role:read("level")
				elseif var_4_7 == var_0_0.handbook and not gGameModel.role:read("pokedex")[var_4_8] then
					var_4_9 = false
					var_4_10 = false
				elseif var_4_7 == var_0_0.head and gGameModel.role:read("logos")[var_4_8] then
					var_4_9 = false
					var_4_10 = true
				elseif var_4_7 == var_0_0.skin then
					local var_4_11 = csv.card_skin[var_4_8].markID

					if gGameModel.role:read("skins")[var_4_8] and gGameModel.role:read("skins")[var_4_8] == 0 then
						var_4_9 = false
						var_4_10 = true
					end
				end

				local var_4_12 = iter_4_1.desc

				if var_4_2 == "card" then
					var_4_12 = csv.cards[var_4_3.id].name
				else
					var_4_12 = dataEasy.getCfgByKey(var_4_2).name
				end

				table.insert(var_4_1, {
					csvId = iter_4_0,
					name = var_4_12,
					item = {
						key = var_4_2,
						num = var_4_3
					},
					cost = {
						key = var_4_4,
						num = var_4_5
					},
					maxTime = iter_4_1.exchangeTimes,
					limitKey = var_4_7,
					limitID = var_4_8,
					canBuy = var_4_9,
					isHas = var_4_10,
					step = var_4_0[iter_4_0] or 0,
					color = var_4_6 and ui.COLORS.NORMAL.YELLOW or ui.COLORS.NORMAL.RED
				})
			end
		end

		dataEasy.tryCallFunc(arg_2_0.list, "updatePreloadCenterIndexAdaptFirst")
		arg_2_0.datas:update(var_4_1)
	end)
end

function var_0_2.onItemClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	gGameUI:stackUI("common.buy_info", nil, nil, {
		[arg_5_3.cost.key] = arg_5_3.cost.num
	}, {
		id = arg_5_3.item.key,
		num = arg_5_3.item.num
	}, {
		flag = "exchange",
		contentType = "num",
		maxNum = arg_5_3.maxTime - arg_5_3.step
	}, arg_5_0:createHandler("itemBuy", arg_5_3.csvId, arg_5_3.cost.num))
end

function var_0_2.itemBuy(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2 > arg_6_0.scoreNum then
		gGameUI:showTip(gLanguageCsv.luckyEggTip)

		return
	end

	gGameApp:requestServer("/game/yy/award/get", function(arg_7_0)
		gGameUI:showGainDisplay(arg_7_0)
	end, arg_6_0.activityId, arg_6_1, arg_6_3)
end

return var_0_2
