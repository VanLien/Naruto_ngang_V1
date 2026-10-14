local var_0_0 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_1 = require("app.views.city.activity.view")
local var_0_2 = {
	BOUGHT = 1,
	CAN_BUY = 0,
	CAN_NOT_BOUGHT = 2
}
local var_0_3 = class("ActivityExclusiveLimitDialog", Dialog)

var_0_3.RESOURCE_FILENAME = "activity_exclusive_limit.json"
var_0_3.RESOURCE_BINDING = {
	iconItem = "iconItem",
	timeLabel = "timeLabel",
	item = "item",
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	rule = {
		varname = "rule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRules")
			}
		}
	},
	title = {
		varname = "title"
	},
	["item.price.diaPrice"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["item.price.rmb"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
				margin = 20,
				asyncPreload = 4,
				paddings = 10,
				data = bindHelper.self("itemsData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.boughtStatus ~= arg_1_1.boughtStatus then
						return arg_1_0.boughtStatus < arg_1_1.boughtStatus
					end

					if arg_1_0.isRMB ~= arg_1_1.isRMB then
						return arg_1_1.isRMB
					end

					return arg_1_0.price < arg_1_1.price
				end,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("title", "levelTitle", "boxImage", "listUp", "listDown", "price", "mask", "despLabel")
					local var_2_1 = dataEasy.getItemData(arg_2_3.cfg.item)
					local var_2_2 = itertools.size(arg_2_3.cfg.item)

					if var_2_2 == 1 or var_2_2 == 2 then
						uiEasy.createItemsToList(arg_2_0, var_2_0.listUp, var_2_1, {
							scale = 0.6,
							onAfterBuild = function()
								var_2_0.listUp:setItemAlignCenter()
							end
						})
						var_2_0.listDown:visible(false)
						var_2_0.listUp:y(var_2_0.listUp:y() - var_2_0.listUp:height() / 2)
					else
						local var_2_3 = {}
						local var_2_4 = 0

						for iter_2_0 = var_2_2, 1, -1 do
							table.insert(var_2_3, var_2_1[iter_2_0])
							table.remove(var_2_1, iter_2_0)

							var_2_4 = var_2_4 + 1

							if (var_2_2 == 3 or var_2_2 == 4) and var_2_4 == 2 then
								break
							elseif (var_2_2 == 5 or var_2_2 == 6) and var_2_4 == 3 then
								break
							end
						end

						uiEasy.createItemsToList(arg_2_0, var_2_0.listUp, var_2_1, {
							scale = 0.6,
							onAfterBuild = function()
								var_2_0.listUp:setItemAlignCenter()
							end
						})
						uiEasy.createItemsToList(arg_2_0, var_2_0.listDown, var_2_3, {
							scale = 0.6,
							onAfterBuild = function()
								var_2_0.listDown:setItemAlignCenter()
							end
						})
					end

					var_2_0.listUp:width(400)
					var_2_0.listDown:width(400)
					var_2_0.title:get("txt"):text(arg_2_3.cfg.titleName)
					var_2_0.levelTitle:get("txt"):text(arg_2_3.cfg.name)

					local var_2_5 = string.format(gLanguageCsv.exclusiveRestrictionBuyTime, arg_2_3.cfg.limit)

					var_2_0.despLabel:text(var_2_5)
					var_2_0.boxImage:texture(arg_2_3.cfg.icon)

					local var_2_6 = var_2_0.price

					if arg_2_3.isRMB then
						var_2_0.price:get("dia"):hide()
						var_2_0.price:get("diaPrice"):hide()
						var_2_0.price:get("rmb"):show():text(string.format(gLanguageCsv.symbolMoney, csv.recharges[arg_2_3.cfg.rechargeID].rmbDisplay))
					else
						var_2_0.price:get("rmb"):hide()
						var_2_0.price:get("dia"):show()
						var_2_0.price:get("diaPrice"):show():text(arg_2_3.cfg.rmbCost)
					end

					if arg_2_3.cfg.limit > arg_2_3.hasBoughtNum then
						var_2_6:setTouchEnabled(true)
						bind.touch(arg_2_0, var_2_6, {
							clicksafe = false,
							methods = {
								ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
							}
						})
						var_2_0.mask:hide()
					else
						var_2_0.mask:get("title"):text(gLanguageCsv.sellout)
						var_2_6:setTouchEnabled(false)
						var_2_0.mask:setTouchEnabled(true)
						var_2_0.mask:show()
					end
				end,
				itemAction = {
					isAction = false
				},
				onAfterBuild = function(arg_6_0)
					arg_6_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("clickCell")
			}
		}
	}
}

function var_0_3.onCreate(arg_7_0, arg_7_1)
	gGameModel.forever_dispatch:getIdlerOrigin("exclusiveLimitDatas"):set(true)

	arg_7_0.activityId = arg_7_1

	arg_7_0:initModel()
	arg_7_0:initData()
	arg_7_0:initUI()
	Dialog.onCreate(arg_7_0, {
		blackType = 1
	})
end

function var_0_3.initModel(arg_8_0)
	arg_8_0.itemsData = idlers.new()
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_8_0.product = arg_8_0.yyhuodongs:read()[arg_8_0.activityId].stamps
	arg_8_0.clientBuyTimes = idler.new(true)

	idlereasy.any({
		arg_8_0.clientBuyTimes,
		arg_8_0.yyhuodongs
	}, function(arg_9_0, arg_9_1, arg_9_2)
		arg_8_0.product = arg_9_2[arg_8_0.activityId].stamps

		arg_8_0:initData()
	end, true)
end

function var_0_3.initData(arg_10_0)
	local var_10_0 = {}
	local var_10_1 = csv.yunying.yyhuodong[arg_10_0.activityId].huodongID

	for iter_10_0, iter_10_1 in pairs(arg_10_0.product) do
		iter_10_1 = dataEasy.getPayClientBuyTimes("directBuyData", arg_10_0.activityId, iter_10_0, iter_10_1)

		local var_10_2 = csv.yunying.luxurydirectbuygift[iter_10_0]
		local var_10_3 = var_10_2.limit - iter_10_1
		local var_10_4 = true
		local var_10_5 = 0

		if var_10_2.limit - iter_10_1 > 0 then
			var_10_3 = var_0_2.CAN_BUY
		else
			var_10_3 = var_0_2.BOUGHT
		end

		if var_10_2.rechargeID ~= -1 then
			var_10_4 = true
			var_10_5 = csv.recharges[var_10_2.rechargeID].rmb
		else
			var_10_4 = false
			var_10_5 = var_10_2.rmbCost
		end

		table.insert(var_10_0, {
			csvId = iter_10_0,
			cfg = var_10_2,
			boughtStatus = var_10_3,
			isRMB = var_10_4,
			price = var_10_5,
			hasBoughtNum = iter_10_1
		})
	end

	arg_10_0.itemsData:update(var_10_0)
end

function var_0_3.initUI(arg_11_0)
	arg_11_0.title:text(gLanguageCsv.exclusiveRestrictionTip)
	arg_11_0.rule:hide()
	arg_11_0:setTimeLabel()
end

function var_0_3.setTimeLabel(arg_12_0)
	arg_12_0.endTime = gGameModel.role:read("yy_endtime")[arg_12_0.activityId]

	local var_12_0 = arg_12_0.endTime - time.getTime()

	if var_12_0 < 0 then
		arg_12_0.timeLabel:text(gLanguageCsv.activityOver)
	end

	arg_12_0:enableSchedule():schedule(function()
		var_12_0 = arg_12_0.endTime - time.getTime()

		local var_13_0 = time.getCutDown(var_12_0)

		if var_12_0 <= 0 then
			arg_12_0.timeLabel:text(gLanguageCsv.activityOver)

			return false
		else
			local var_13_1 = ""

			if var_13_0.day >= 1 then
				var_13_1 = var_13_0.str
			else
				var_13_1 = var_13_0.clock_str
			end

			arg_12_0.timeLabel:text(gLanguageCsv.exclusiveRestrictionClose .. var_13_1)

			return true
		end
	end, 1, 0)
end

function var_0_3.clickCell(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_3.isRMB then
		gGameApp:payDirect(arg_14_0, {
			rechargeId = arg_14_3.cfg.rechargeID,
			yyID = arg_14_0.activityId,
			csvID = arg_14_3.csvId,
			name = arg_14_3.cfg.titleName,
			buyTimes = arg_14_3.hasBoughtNum
		}, arg_14_0.clientBuyTimes):serverCb(function()
			local var_15_0 = csv.yunying.luxurydirectbuygift[arg_14_3.csvId]

			gGameUI:showGainDisplay(var_15_0.item, {
				raw = false
			})
		end):doit()
	else
		if gGameModel.role:read("rmb") < arg_14_3.cfg.rmbCost then
			uiEasy.showDialog("rmb")

			return
		end

		gGameApp:requestServer("/game/yy/award/get", function(arg_16_0)
			arg_14_0.clientBuyTimes:notify()
			gGameUI:showGainDisplay(arg_14_3.cfg.item, {
				raw = false
			})
		end, arg_14_0.activityId, arg_14_3.csvId)
	end
end

function var_0_3.onRules(arg_17_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_17_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_3.getRuleContext(arg_18_0, arg_18_1)
	local var_18_0 = adaptContext

	return {
		var_18_0.clone(arg_18_1.title, function(arg_19_0)
			arg_19_0:get("text"):text(gLanguageCsv.giftRluer)
		end),
		var_18_0.noteText(123002, 123006)
	}
end

return var_0_3
