local var_0_0 = {
	canbuy = 1,
	lock = 2,
	sellout = 3
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("TotemDrawExchangeView", var_0_1)

var_0_2.RESOURCE_FILENAME = "totem_exchange.json"
var_0_2.RESOURCE_BINDING = {
	["bottomPanel.item"] = "bottomItem",
	["centerPanel.slider"] = "slider",
	["centerPanel.item"] = "centerItem",
	["leftPanel.item"] = "leftItem",
	bg = "bg",
	["centerPanel.subList"] = "subList",
	leftPanel = "leftPanel",
	["centerPanel.item.btnBuy"] = "btnBuy",
	centerPanel = "centerPanel",
	bottomPanel = "bottomPanel",
	["bottomPanel.item.normal.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["bottomPanel.item.selected.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftTab"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1.get(arg_1_1, "normal")
					local var_1_1 = arg_1_1.get(arg_1_1, "selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0.hide(var_1_0)

						var_1_2 = var_1_1.show(var_1_1)
					else
						var_1_1.hide(var_1_1)

						var_1_2 = var_1_0.show(var_1_0)
					end

					var_1_2:get("txt"):text(arg_1_3.name):getVirtualRenderer():setLineSpacing(-10)

					local var_1_3 = var_1_2:size().height - 40

					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	["centerPanel.list"] = {
		varname = "centerList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 12,
				data = bindHelper.self("shopDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("centerItem"),
				sliderBg = bindHelper.self("slider"),
				columnSize = bindHelper.self("rightColumnSize"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("name", "maskPanel", "icon", "btnBuy", "limitText", "limitNum", "num")
					local var_2_1, var_2_2 = csvNext(arg_2_3.cfg.itemMap)
					local var_2_3 = dataEasy.getCfgByKey(var_2_1)

					var_2_0.name:text(var_2_3.name)
					uiEasy.setIconName(var_2_1, nil, {
						node = var_2_0.name
					})

					if matchLanguage({
						"en",
						"kr"
					}) then
						adapt.setTextAdaptWithSize(var_2_0.name, {
							margin = -5,
							vertical = "center",
							maxLine = 2,
							horizontal = "center",
							size = cc.size(arg_2_1.width(arg_2_1) - 150, 120)
						})
					else
						adapt.setTextScaleWithWidth(var_2_0.name, nil, arg_2_1.width(arg_2_1) - 190)
					end

					text.addEffect(var_2_0.name, {
						color = ui.COLORS.QUALITY[var_2_3.quality]
					})
					var_2_0.num:text("x" .. var_2_2)
					bind.extend(arg_2_0, var_2_0.icon, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = var_2_1
							},
							simpleShow = arg_2_3.simpleShow,
							onNode = function(arg_3_0)
								arg_3_0:setTouchEnabled(false)
							end
						}
					})
					arg_2_0:setScrollBarEnabled(true)

					local var_2_4 = arg_2_3.cfg.limitType ~= 0
					local var_2_5 = arg_2_3.cfg.limitTimes
					local var_2_6, var_2_7 = csvNext(arg_2_3.cfg.costMap)
					local var_2_8 = var_2_0.btnBuy:multiget("txt", "icon")

					var_2_8.icon:texture(dataEasy.getCfgByKey(var_2_6).icon)
					var_2_8.txt:text(var_2_7)
					arg_2_1:removeChildByName("emm")

					if var_2_4 then
						local var_2_9
						local var_2_10

						if arg_2_3.cfg.limitType == 1 then
							var_2_10 = var_2_5

							if tonumber(arg_2_3.shopLimit[2]) == tonumber(time.getTodayStr()) then
								var_2_10 = math.max(var_2_5 - (arg_2_3.shopLimit[1] or 0), 0)
							end

							var_2_9 = string.format(gLanguageCsv.currDayBuyLimit, var_2_10, var_2_5)
						elseif arg_2_3.cfg.limitType == 2 then
							var_2_10 = var_2_5

							if tonumber(arg_2_3.shopLimit[2]) == tonumber(time.getWeekStrInClock()) then
								var_2_10 = math.max(var_2_5 - (arg_2_3.shopLimit[1] or 0), 0)
							end

							var_2_9 = string.format(gLanguageCsv.currWeekBuyLimit, var_2_10, var_2_5)
						elseif arg_2_3.cfg.limitType == 3 then
							var_2_10 = var_2_5

							if tonumber(arg_2_3.shopLimit[2]) == tonumber(time.getMonthStrInClock()) then
								var_2_10 = math.max(var_2_5 - (arg_2_3.shopLimit[1] or 0), 0)
							end

							var_2_9 = string.format(gLanguageCsv.currMonthBuyLimit, var_2_10, var_2_5)
						else
							var_2_10 = math.max(arg_2_3.shopLimit[1] and var_2_5 - arg_2_3.shopLimit[1] or var_2_5, 0)
							var_2_9 = string.format(gLanguageCsv.foreverBuyLimit, var_2_10, var_2_5)
						end

						var_2_0.maskPanel:visible(var_2_10 == 0)
						var_2_0.maskPanel:get("lockText"):text(gLanguageCsv.sellout)

						local var_2_11 = rich.createByStr(var_2_9, 40)

						var_2_11:formatText()
						var_2_11:addTo(arg_2_1, 100, "emm"):xy(var_2_0.btnBuy:x(), var_2_0.btnBuy:y() + 100)
						arg_2_1:setTouchEnabled(false)
						var_2_0.btnBuy:setTouchEnabled(var_2_10 ~= 0)
						cache.setShader(var_2_0.btnBuy, false, var_2_10 == 0 and "hsl_gray" or "normal")
						cache.setShader(var_2_8.icon, false, var_2_10 == 0 and "hsl_gray" or "normal")
					else
						var_2_0.maskPanel:visible(arg_2_3.buyTimes == true)
						cache.setShader(var_2_0.btnBuy, false, arg_2_3.buyTimes and "hsl_gray" or "normal")
						cache.setShader(var_2_8.icon, false, arg_2_3.buyTimes and "hsl_gray" or "normal")

						if arg_2_3.buyTimes then
							text.addEffect(var_2_8.txt, {
								color = ui.COLORS.DISABLED.WHITE
							})
						else
							text.addEffect(var_2_8.txt, {
								color = ui.COLORS.NORMAL.WHITE
							})
						end

						arg_2_1:setTouchEnabled(arg_2_3.buyTimes ~= true)
					end

					bind.touch(arg_2_0, var_2_0.btnBuy, {
						methods = {
							clicksafe = true,
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
					adapt.oneLineCenterPos(cc.p(var_2_0.btnBuy:size().width / 2, var_2_0.btnBuy:size().height / 2), {
						var_2_8.icon,
						var_2_8.txt
					}, cc.p(50, 0))
				end,
				onBeforeBuild = function(arg_4_0)
					if arg_4_0.sliderBg:visible() then
						local var_4_0, var_4_1 = arg_4_0:xy()
						local var_4_2 = arg_4_0:size()
						local var_4_3, var_4_4 = arg_4_0.sliderBg:xy()
						local var_4_5 = arg_4_0.sliderBg:size()

						arg_4_0:setScrollBarEnabled(true)
						arg_4_0:setScrollBarColor(cc.c3b(241, 59, 84))
						arg_4_0:setScrollBarOpacity(255)
						arg_4_0:setScrollBarAutoHideEnabled(false)
						arg_4_0:setScrollBarPositionFromCorner(cc.p(var_4_0 + var_4_2.width - var_4_3, var_4_2.height - var_4_5.height - 20))
						arg_4_0:setScrollBarWidth(var_4_5.width)
						arg_4_0:refreshView()
					else
						arg_4_0.setScrollBarEnabled(arg_4_0, false)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	},
	["bottomPanel.list"] = {
		varname = "bottomList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("bottomTab"),
				item = bindHelper.self("bottomItem"),
				dataOrderCmp = function(arg_5_0, arg_5_1)
					return arg_5_1.sortWeight < arg_5_0.sortWeight
				end,
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1.get(arg_6_1, "normal")
					local var_6_1 = arg_6_1.get(arg_6_1, "selected")
					local var_6_2

					if arg_6_3.select then
						var_6_0.hide(var_6_0)

						local var_6_3 = var_6_1.show(var_6_1)
					else
						var_6_1.hide(var_6_1)

						local var_6_4 = var_6_0.show(var_6_0)
					end

					var_6_0:get("txt"):text(gLanguageCsv[arg_6_3.name])
					var_6_1:get("txt"):text(gLanguageCsv[arg_6_3.name])
					adapt.setTextScaleWithWidth(var_6_0:get("txt"), nil, 160)
					adapt.setTextScaleWithWidth(var_6_1:get("txt"), nil, 160)
					bind.touch(arg_6_0, var_6_0, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBottomItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_7_0)
	gGameUI.topuiManager:createView("totem_draw", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "EXCHANGE",
		title = "common/txt/txt_bt_ewdh.png"
	})
	arg_7_0:initModel()
	arg_7_0:initDatas()

	local var_7_0 = arg_7_0.centerItem:width()
	local var_7_1, var_7_2 = adapt.centerWithScreen("left", "right", {
		itemWidthExtra = 130,
		itemWidth = var_7_0
	}, {
		{
			{
				arg_7_0.leftPanel,
				arg_7_0.centerList
			},
			"pos",
			"left"
		},
		{
			{
				arg_7_0.bottomPanel,
				arg_7_0.slider
			},
			"pos",
			"right"
		},
		{
			{
				arg_7_0.centerList,
				arg_7_0.subList
			},
			"width"
		}
	})

	arg_7_0.rightColumnSize = 4 + var_7_2
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.showLeftTab = idler.new(1)
	arg_8_0.showBottomTab = idler.new(0)
	arg_8_0.shopDatas = idlers.new()
	arg_8_0.shopLimit = gGameModel.role:getIdler("shop_limit")
end

function var_0_2.initDatas(arg_9_0)
	local var_9_0 = {
		{
			name = gLanguageCsv.exchangeTotem
		},
		{
			name = gLanguageCsv.exchangeGift
		}
	}

	arg_9_0.leftTab = idlers.newWithMap(var_9_0)

	local var_9_1 = {
		[0] = {
			name = "all",
			select = true,
			sortWeight = 0
		},
		[3] = {
			select = false,
			sortWeight = 3,
			name = ui.QUALITY_COLOR_TEXT[3]
		},
		[4] = {
			select = false,
			sortWeight = 4,
			name = ui.QUALITY_COLOR_TEXT[4]
		},
		[5] = {
			select = false,
			sortWeight = 5,
			name = ui.QUALITY_COLOR_TEXT[5]
		},
		[6] = {
			select = false,
			sortWeight = 6,
			name = ui.QUALITY_COLOR_TEXT[6]
		}
	}

	arg_9_0.bottomTab = idlers.newWithMap(var_9_1)

	arg_9_0.showLeftTab:addListener(function(arg_10_0, arg_10_1, arg_10_2)
		arg_9_0.leftTab:atproxy(arg_10_1).select = false
		arg_9_0.leftTab:atproxy(arg_10_0).select = true

		arg_9_0.bottomPanel:visible(arg_10_0 == 1)
		arg_9_0.showBottomTab:set(0, true)
	end)
	arg_9_0.showBottomTab:addListener(function(arg_11_0, arg_11_1, arg_11_2)
		if arg_9_0.bottomTab:atproxy(arg_11_1) then
			arg_9_0.bottomTab:atproxy(arg_11_1).select = false
		end

		arg_9_0.bottomTab:atproxy(arg_11_0).select = true

		arg_9_0.centerList:jumpToTop()
		arg_9_0:updateCenterPanel()
	end)
	idlereasy.when(arg_9_0.shopLimit, function(arg_12_0, arg_12_1)
		arg_9_0:updateCenterPanel()
	end)
end

function var_0_2.updateCenterPanel(arg_13_0)
	local var_13_0 = arg_13_0.shopLimit:read().totem_exchange_shop or {}
	local var_13_1 = csv.totem.exchange_shop
	local var_13_2 = {}

	for iter_13_0, iter_13_1 in orderCsvPairs(csv.totem.exchange_shop) do
		local var_13_3, var_13_4 = csvNext(iter_13_1.itemMap)
		local var_13_5 = dataEasy.getCfgByKey(var_13_3)

		if arg_13_0.showLeftTab:read() == 1 and iter_13_1.group == 1 then
			if arg_13_0.showBottomTab:read() == 0 then
				table.insert(var_13_2, {
					simpleShow = true,
					csvId = iter_13_0,
					cfg = iter_13_1,
					shopLimit = var_13_0[iter_13_0] or {},
					quality = var_13_5.quality
				})
			elseif var_13_5.quality == arg_13_0.showBottomTab:read() then
				table.insert(var_13_2, {
					simpleShow = true,
					csvId = iter_13_0,
					cfg = iter_13_1,
					shopLimit = var_13_0[iter_13_0] or {},
					quality = var_13_5.quality
				})
			end
		elseif arg_13_0.showLeftTab:read() == 2 and iter_13_1.group == arg_13_0.showLeftTab:read() then
			table.insert(var_13_2, {
				simpleShow = false,
				csvId = iter_13_0,
				cfg = iter_13_1,
				shopLimit = var_13_0[iter_13_0] or {},
				quality = var_13_5.quality
			})
		end
	end

	table.sort(var_13_2, function(arg_14_0, arg_14_1)
		if arg_14_0.quality ~= arg_14_1.quality then
			return arg_14_1.quality < arg_14_0.quality
		end

		return arg_14_0.csvId < arg_14_1.csvId
	end)
	arg_13_0.slider:setVisible(itertools.size(var_13_2) > 8)
	dataEasy.tryCallFunc(arg_13_0.centerList, "updatePreloadCenterIndex")
	arg_13_0.shopDatas:update(var_13_2)
end

function var_0_2.onTabItemClick(arg_15_0, arg_15_1, arg_15_2)
	print("33333")
	arg_15_0.showLeftTab:set(arg_15_2)
end

function var_0_2.onBottomItemClick(arg_16_0, arg_16_1, arg_16_2)
	print("22222")
	arg_16_0.showBottomTab:set(arg_16_2)
end

function var_0_2.onBuyClick(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	print("111111")

	if arg_17_3.state == var_0_0.sellout then
		return
	end

	local var_17_0, var_17_1 = csvNext(arg_17_3.cfg.itemMap)

	arg_17_0.buyData = {
		csvId = arg_17_3.csvId,
		num = var_17_1,
		key = var_17_0
	}

	local var_17_2 = 1
	local var_17_3 = {
		function()
			return tonumber(arg_17_3.shopLimit[2]) == tonumber(time.getTodayStr())
		end,
		function()
			return tonumber(arg_17_3.shopLimit[2]) == tonumber(time.getWeekStrInClock())
		end,
		function()
			return tonumber(arg_17_3.shopLimit[2]) == tonumber(time.getMonthStrInClock())
		end,
		function()
			return true
		end
	}

	if arg_17_3.cfg.limitType and arg_17_3.cfg.limitType > 0 then
		var_17_2 = arg_17_3.cfg.limitTimes

		if (var_17_3[arg_17_3.cfg.limitType] or var_17_3[4])() then
			var_17_2 = var_17_2 - (arg_17_3.shopLimit[1] or 0)
		end
	end

	gGameUI:stackUI("common.buy_info", nil, nil, arg_17_3.cfg.costMap, {
		id = var_17_0,
		num = var_17_1
	}, {
		style = 1,
		contentType = "num",
		num = arg_17_0:createHandler("num"),
		maxNum = var_17_2
	}, arg_17_0:createHandler("onUseCb"))
end

function var_0_2.onUseCb(arg_22_0, arg_22_1)
	local var_22_0 = {}

	table.insert(var_22_0, {
		arg_22_0.buyData.key,
		arg_22_0.buyData.num * arg_22_1
	})
	gGameApp:requestServer("/game/totem/exchange/shop/buy", function(arg_23_0)
		gGameUI:showGainDisplay(var_22_0, {
			raw = false
		})
	end, arg_22_0.buyData.csvId, arg_22_1)
end

return var_0_2
