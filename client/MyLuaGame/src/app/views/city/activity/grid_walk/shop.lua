local var_0_0 = require("app.views.city.activity.grid_walk.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("GridWalkShop", Dialog)

var_0_2.RESOURCE_FILENAME = "grid_walk_shop.json"
var_0_2.RESOURCE_BINDING = {
	item = "item",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTouchClose")
			}
		}
	},
	txt = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(107, 131, 60)
				}
			}
		}
	},
	txt1 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = cc.c3b(242, 81, 97)
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
				data = bindHelper.self("shopDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("title", "num", "icon", "price", "costIcon")
					local var_1_1, var_1_2 = csvNext(arg_1_3.items)
					local var_1_3 = dataEasy.getCfgByKey(var_1_1)

					var_1_0.icon:texture(var_1_3.icon)
					var_1_0.title:text(var_1_3.name)
					var_1_0.num:text("x" .. var_1_2)

					local var_1_4, var_1_5 = csvNext(arg_1_3.prices)

					var_1_0.costIcon:texture(dataEasy.getIconResByKey(var_1_4))
					var_1_0.price:text(var_1_5)
					text.addEffect(var_1_0.price, {
						glow = {
							color = ui.COLORS.GLOW.WHITE
						}
					})
					adapt.oneLineCenterPos(cc.p(arg_1_1:width() / 2, var_1_0.costIcon:y()), {
						var_1_0.costIcon,
						var_1_0.price
					}, cc.p(20, 0))
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickBuy, arg_1_2, arg_1_3)
						}
					})
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickBuy = bindHelper.self("onBuyClick")
			}
		}
	},
	["panel1.txt"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("iconNum")
		}
	},
	["panel2.txt"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("djqNum")
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.event

	arg_3_0.iconNum = arg_3_1.iconNum
	arg_3_0.djqNum = idler.new(dataEasy.getNumByKey(var_0_0.ITEMS.voucher))
	arg_3_0.callBack = arg_3_1.callBack
	arg_3_0.index = arg_3_1.index

	arg_3_0:initModel()

	arg_3_0.shopDatas = idlers.new()

	local var_3_1 = {}

	for iter_3_0 = 0, 3 do
		local var_3_2 = var_3_0.params["outcome" .. iter_3_0]

		if var_3_2 > 0 then
			local var_3_3 = csv.yunying.grid_walk_shop[var_3_2]

			table.insert(var_3_1, {
				csvID = var_3_2,
				cfg = var_3_3,
				items = var_3_3.items,
				prices = var_3_3.prices
			})
		end
	end

	arg_3_0.shopDatas:update(var_3_1)
end

function var_0_2.initModel(arg_4_0)
	arg_4_0.gridWalk = gGameModel.role:read("grid_walk")
	arg_4_0.shopDatas = idlers.new()
	arg_4_0.num = idler.new(1)
end

function var_0_2.onBuyClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = dataEasy.getNumByKey(var_0_0.ITEMS.voucher)
	local var_5_1, var_5_2 = csvNext(arg_5_3.items)

	arg_5_0.num:set(arg_5_3.csvID)

	if var_5_0 > 0 and arg_5_3.cfg.type == 1 then
		local var_5_3, var_5_4 = csvNext(arg_5_3.prices)
		local var_5_5 = {
			[var_0_0.ITEMS.voucher] = 1,
			[var_5_3] = var_5_4
		}

		gGameUI:stackUI("common.buy_info", nil, nil, arg_5_3.prices, {
			id = var_5_1,
			num = var_5_2
		}, {
			selectMap = var_5_5
		}, arg_5_0:createHandler("selectCallBack"))
	else
		gGameUI:stackUI("common.buy_info", nil, nil, arg_5_3.prices, {
			id = var_5_1,
			num = var_5_2
		}, nil, arg_5_0:createHandler("onlySendBuy"))
	end
end

function var_0_2.onlySendBuy(arg_6_0, arg_6_1)
	arg_6_0:sendBuy()
end

function var_0_2.selectCallBack(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:sendBuy(arg_7_2 == 1, false)
end

function var_0_2.sendBuy(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == nil then
		arg_8_1 = false
	end

	local var_8_0 = arg_8_2 and 0 or arg_8_0.num:read()

	gGameApp:requestServer("/game/yy/gridwalk/shop", function(arg_9_0)
		gGameUI:showGainDisplay(arg_9_0.view.awards, {
			cb = function()
				local var_10_0 = 0

				if not arg_8_1 and not arg_8_2 then
					local var_10_1 = csv.yunying.grid_walk_shop[var_8_0].prices
					local var_10_2, var_10_3 = csvNext(var_10_1)

					if var_10_2 == var_0_0.BADGE_ID then
						var_10_0 = var_10_3
					end
				end

				arg_8_0:onClose(arg_8_2 and 0 or 1, arg_9_0.view.effTreasure, arg_9_0.view.awards, var_10_0)
			end
		})
	end, arg_8_0.gridWalk.yy_id, var_8_0, arg_8_1, arg_8_0.index - 1)
end

function var_0_2.onTouchClose(arg_11_0)
	gGameUI:showDialog({
		btnType = 2,
		content = gLanguageCsv.gridWalkShopTips,
		cb = function()
			arg_11_0:sendBuy(nil, true)
		end
	})
end

function var_0_2.onClose(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = {
		hasBuy = arg_13_1 == 1,
		awards = arg_13_3,
		effTreasure = arg_13_2,
		iconOffset = arg_13_4
	}

	arg_13_0:addCallbackOnExit(functools.partial(arg_13_0.callBack, var_13_0))
	var_0_1.onClose(arg_13_0)
end

return var_0_2
