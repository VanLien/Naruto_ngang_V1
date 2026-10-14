local var_0_0 = {
	sellout = 3,
	refresh = 2,
	canbuy = 1
}
local var_0_1 = class("ActivityDouble11Shop", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "double11_shop.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.item"] = "tabItem",
	bg2 = "shopBg",
	time = "time",
	["bagPanel.subList"] = "bagSublist",
	["bagPanel.item"] = "bagItem",
	singlePanel = "singlePanel",
	bagPanel = "bagPanel",
	leftPanel = "leftPanel",
	["singlePanel.item"] = "singleItem",
	["singlePanel.subList"] = "singleSublist",
	bg = "bg",
	["bagPanel.item.item"] = "iconItem",
	tip = {
		varname = "tip",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(255, 255, 235, 255)
				}
			}
		}
	},
	["leftPanel.item.normal.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(216, 148, 115, 255)
				}
			}
		}
	},
	["leftPanel.item.select.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(129, 61, 45, 255)
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabData"),
				item = bindHelper.self("tabItem"),
				itemAction = {
					isAction = true
				},
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("select")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()

						text.addEffect(var_1_1:get("name"), {
							color = ui.COLORS.NORMAL.WHITE,
							glow = {
								color = ui.COLORS.GLOW.WHITE
							}
						})
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					var_1_2:get("name"):text(arg_1_3.desc)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCellItem, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCellItem = bindHelper.self("onLeftItemClick")
			}
		}
	},
	["singlePanel.centerList"] = {
		varname = "singleList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 0,
				asyncPreload = 12,
				columnSize = 4,
				data = bindHelper.self("singleDatas"),
				item = bindHelper.self("singleSublist"),
				cell = bindHelper.self("singleItem"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.state ~= arg_2_1.state then
						return arg_2_0.state < arg_2_1.state
					end

					if arg_2_0.sort ~= arg_2_1.sort then
						return arg_2_0.sort < arg_2_1.sort
					end

					return arg_2_0.csvId < arg_2_1.csvId
				end,
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_3.cfg
					local var_3_1 = arg_3_1:multiget("title", "tip", "mask", "price", "item", "icon", "hot", "btnBuy")

					var_3_1.title:text(var_3_0.name)

					if var_3_0.hot == "" then
						var_3_1.hot:visible(false)
					else
						var_3_1.hot:visible(true)
						var_3_1.hot:texture(var_3_0.hot)
					end

					if var_3_0.refresh then
						var_3_1.tip:text(string.format(gLanguageCsv.directBuyGiftDailyBuy, arg_3_3.leftTimes, var_3_0.limit))
					else
						var_3_1.tip:text(string.format(gLanguageCsv.directBuyGiftOnetimeBuy, arg_3_3.leftTimes, var_3_0.limit))
					end

					for iter_3_0, iter_3_1 in ipairs(dataEasy.getItemData(var_3_0.item)) do
						local var_3_2 = iter_3_1.key
						local var_3_3 = iter_3_1.num

						bind.extend(arg_3_0, var_3_1.icon, {
							class = "icon_key",
							props = {
								data = {
									key = var_3_2,
									num = var_3_3
								},
								onNode = function(arg_4_0)
									return
								end
							}
						})
					end

					var_3_1.price:get("num"):text(var_3_0.oldPrice)

					local var_3_4 = var_3_1.btnBuy
					local var_3_5 = var_3_1.btnBuy:get("text")
					local var_3_6 = var_3_1.btnBuy:get("rmb")

					var_3_4:setTouchEnabled(false)
					var_3_6:visible(false)
					cache.setShader(var_3_4, false, "normal")

					if arg_3_3.rmb then
						local var_3_7 = 40

						var_3_5:text(arg_3_3.rmb)

						if type(arg_3_3.rmb) ~= "string" then
							var_3_6:visible(true)

							local var_3_8 = 70
						end
					elseif arg_3_3.price then
						var_3_5:text(string.format(gLanguageCsv.symbolMoney, arg_3_3.price))
					end

					if arg_3_3.state == var_0_0.canbuy then
						var_3_1.mask:hide()
						var_3_4:setTouchEnabled(true)
						bind.touch(arg_3_0, var_3_4, {
							clicksafe = true,
							methods = {
								ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
							}
						})
						text.addEffect(var_3_5, {
							color = ui.COLORS.NORMAL.YELLOW,
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					else
						var_3_1.mask:show()
						var_3_1.hot:visible(false)
						cache.setShader(var_3_4, false, "hsl_gray")
						text.deleteAllEffect(var_3_5)
						text.addEffect(var_3_5, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_3_3.state == var_0_0.sellout then
							var_3_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_3_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end

					arg_3_0:setRenderHint(0)
					arg_3_1:get("imgBoard"):setVisible(arg_3_2 == 1)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	},
	["bagPanel.centerList"] = {
		varname = "bagList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 40,
				asyncPreload = 9,
				columnSize = 3,
				data = bindHelper.self("bagDatas"),
				item = bindHelper.self("bagSublist"),
				cell = bindHelper.self("bagItem"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_5_0, arg_5_1)
					if arg_5_0.state ~= arg_5_1.state then
						return arg_5_0.state < arg_5_1.state
					end

					if arg_5_0.sort ~= arg_5_1.sort then
						return arg_5_0.sort < arg_5_1.sort
					end

					return arg_5_0.csvId < arg_5_1.csvId
				end,
				onCell = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_3.cfg
					local var_6_1 = arg_6_1:multiget("name", "boxImg", "mask", "btnBuy", "item", "list", "tip", "hot")

					var_6_1.name:text(var_6_0.name)
					var_6_1.boxImg:texture(var_6_0.icon)

					if var_6_0.hot == "" or var_6_0.hot == nil then
						var_6_1.hot:visible(false)
					else
						var_6_1.hot:visible(true)
						var_6_1.hot:texture(var_6_0.hot)
					end

					var_6_1.boxImg:texture(var_6_0.icon)

					if var_6_0.refresh then
						var_6_1.tip:text(string.format(gLanguageCsv.directBuyGiftDailyBuy, arg_6_3.leftTimes, var_6_0.limit))
					else
						var_6_1.tip:text(string.format(gLanguageCsv.directBuyGiftOnetimeBuy, arg_6_3.leftTimes, var_6_0.limit))
					end

					var_6_1.list:removeAllChildren()
					var_6_1.list:setScrollBarEnabled(false)
					var_6_1.list:setGravity(ccui.ListViewGravity.bottom)

					local var_6_2 = csvSize(var_6_0.item) == 1 and var_6_1.item:size().width / 2 or 0

					for iter_6_0, iter_6_1 in ipairs(dataEasy.getItemData(var_6_0.item)) do
						local var_6_3 = iter_6_1.key
						local var_6_4 = iter_6_1.num
						local var_6_5 = var_6_1.item:clone():show()
						local var_6_6 = var_6_5:size()

						bind.extend(arg_6_0, var_6_5, {
							class = "icon_key",
							props = {
								data = {
									key = var_6_3,
									num = var_6_4
								},
								onNode = function(arg_7_0)
									arg_7_0:xy(var_6_6.width / 2 + var_6_2, var_6_6.height / 2)
									arg_7_0:scale(0.7)
								end
							}
						})
						var_6_1.list:pushBackCustomItem(var_6_5)
					end

					var_6_1.list:adaptTouchEnabled():setItemAlignCenter()

					local var_6_7 = var_6_1.btnBuy
					local var_6_8 = var_6_1.btnBuy:get("text")

					var_6_7:setTouchEnabled(false)
					cache.setShader(var_6_7, false, "normal")

					if arg_6_3.rmb then
						local var_6_9 = 40

						var_6_8:text(arg_6_3.rmb)

						if type(arg_6_3.rmb) ~= "string" then
							local var_6_10 = 70
						end
					elseif arg_6_3.price then
						var_6_8:text(string.format(gLanguageCsv.symbolMoney, arg_6_3.price))
					end

					if arg_6_3.state == var_0_0.canbuy then
						var_6_1.mask:hide()
						var_6_7:setTouchEnabled(true)
						bind.touch(arg_6_0, var_6_7, {
							clicksafe = true,
							methods = {
								ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
							}
						})
						text.addEffect(var_6_8, {
							color = ui.COLORS.NORMAL.WHITE,
							glow = {
								color = ui.COLORS.GLOW.WHITE
							}
						})
					else
						var_6_1.mask:show()
						var_6_1.hot:visible(false)
						cache.setShader(var_6_7, false, "hsl_gray")
						text.deleteAllEffect(var_6_8)
						text.addEffect(var_6_8, {
							color = ui.COLORS.DISABLED.WHITE
						})

						if arg_6_3.state == var_0_0.sellout then
							var_6_1.mask:get("label"):text(gLanguageCsv.sellout)
						else
							var_6_1.mask:get("label"):text(gLanguageCsv.nextDayRefresh5)
						end
					end

					arg_6_0:setRenderHint(0)
					arg_6_1:get("imgBoard"):setVisible(arg_6_2 == 1)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_8_0)
	gGameUI.topuiManager:createView("default", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "ACTIVITY",
		title = "common/txt/txt_bt_haigouxiaopu.png"
	})
	arg_8_0:initModel()

	local var_8_0 = {}

	arg_8_0.tip:text(gLanguageCsv.double11ShopTip)

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.yyOpen:read()) do
		local var_8_1 = csv.yunying.yyhuodong[iter_8_1]

		if var_8_1.type == game.YYHUODONG_TYPE_ENUM_TABLE.directBuyGift and var_8_1.clientParam.double11 then
			table.insert(var_8_0, {
				desc = var_8_1.desc,
				id = iter_8_1,
				sortWeight = var_8_1.sortWeight,
				type = var_8_1.clientParam.type
			})
		end
	end

	arg_8_0.datas = var_8_0
	arg_8_0.timeId = var_8_0[1].id

	table.sort(var_8_0, function(arg_9_0, arg_9_1)
		if arg_9_0.sortWeight ~= arg_9_1.sortWeight then
			return arg_9_0.sortWeight < arg_9_1.sortWeight
		end

		return arg_9_0.id < arg_9_1.id
	end)

	local var_8_2 = var_8_0[1].id

	arg_8_0:initCountDown()

	if var_8_2 then
		if var_8_0[1].type == "item" then
			arg_8_0.singlePanel:visible(true)
			arg_8_0.bagPanel:visible(false)
		elseif var_8_0[1].type == "gift" then
			arg_8_0.singlePanel:visible(false)
			arg_8_0.bagPanel:visible(true)
		end

		arg_8_0.tabData:update(var_8_0)
		arg_8_0.activityId:set(var_8_2)
		arg_8_0.showTab:addListener(function(arg_10_0, arg_10_1, arg_10_2)
			arg_8_0.tabData:atproxy(arg_10_1).select = false
			arg_8_0.tabData:atproxy(arg_10_0).select = true
		end)

		arg_8_0.clientBuyTimes = idler.new(true)

		idlereasy.any({
			arg_8_0.yyhuodongs,
			arg_8_0.clientBuyTimes,
			arg_8_0.activityId
		}, function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			local var_11_0 = csv.yunying.yyhuodong[arg_11_3].huodongID
			local var_11_1 = (arg_11_1[arg_11_3] or {}).stamps or {}
			local var_11_2 = {}

			for iter_11_0, iter_11_1 in csvPairs(csv.yunying.directbuygift) do
				if iter_11_1.huodongID == var_11_0 and arg_8_0.level >= iter_11_1.levelLimit then
					local var_11_3 = var_0_0.canbuy
					local var_11_4 = var_11_1[iter_11_0] or 0
					local var_11_5 = dataEasy.getPayClientBuyTimes("directBuyData", arg_11_3, iter_11_0, var_11_4)
					local var_11_6 = math.max(0, iter_11_1.limit - var_11_5)
					local var_11_7 = iter_11_1.status

					if var_11_6 == 0 then
						if iter_11_1.refresh then
							var_11_3 = var_0_0.refresh
						else
							var_11_3 = var_0_0.sellout
						end
					end

					local var_11_8
					local var_11_9

					if iter_11_1.rmbCost == 0 then
						var_11_8 = gLanguageCsv.freeToReceive
					elseif iter_11_1.rmbCost >= 1 then
						var_11_8 = iter_11_1.rmbCost
					else
						var_11_9 = csv.recharges[iter_11_1.rechargeID].rmbDisplay
					end

					table.insert(var_11_2, {
						csvId = iter_11_0,
						cfg = iter_11_1,
						state = var_11_3,
						buyTimes = var_11_5,
						leftTimes = var_11_6,
						price = var_11_9,
						rmb = var_11_8,
						status = var_11_7,
						sort = iter_11_1.sort
					})
				end
			end

			userDefault.setForeverLocalKey("double11ShopData", double11ShopData, {
				new = true
			})

			for iter_11_2, iter_11_3 in ipairs(arg_8_0.datas) do
				if arg_8_0.activityId:read() == iter_11_3.id then
					if iter_11_3.type == "item" then
						dataEasy.tryCallFunc(arg_8_0.singleList, "updatePreloadCenterIndex")
						arg_8_0.singleDatas:update(var_11_2)
					elseif iter_11_3.type == "gift" then
						dataEasy.tryCallFunc(arg_8_0.bagList, "updatePreloadCenterIndex")
						arg_8_0.bagDatas:update(var_11_2)
					end
				end
			end
		end)
	end
end

function var_0_1.initModel(arg_12_0)
	arg_12_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_12_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_12_0.rmb = gGameModel.role:getIdler("rmb")
	arg_12_0.level = gGameModel.role:read("level")
	arg_12_0.activityId = idler.new()
	arg_12_0.tabData = idlers.new()
	arg_12_0.singleDatas = idlers.new()
	arg_12_0.bagDatas = idlers.new()
	arg_12_0.showTab = idler.new(1)
end

function var_0_1.onLeftItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0.activityId:read() ~= arg_13_3.id then
		arg_13_0.activityId:set(arg_13_3.id)
		arg_13_0.showTab:set(arg_13_2)

		for iter_13_0, iter_13_1 in ipairs(arg_13_0.datas) do
			if arg_13_3.id == iter_13_1.id then
				if iter_13_1.type == "item" then
					dataEasy.tryCallFunc(arg_13_0.singleList, "setItemAction", {
						isAction = true
					})
					arg_13_0.singlePanel:visible(true)
					arg_13_0.bagPanel:visible(false)
				elseif iter_13_1.type == "gift" then
					dataEasy.tryCallFunc(arg_13_0.bagList, "setItemAction", {
						isAction = true
					})
					arg_13_0.singlePanel:visible(false)
					arg_13_0.bagPanel:visible(true)
				end
			end
		end
	end
end

function var_0_1.onBuyClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.activityId:read()

	if not arg_14_3.rmb then
		gGameApp:payDirect(arg_14_0, {
			rechargeId = arg_14_3.cfg.rechargeID,
			yyID = var_14_0,
			csvID = arg_14_3.csvId,
			name = arg_14_3.cfg.name,
			buyTimes = arg_14_3.buyTimes
		}, arg_14_0.clientBuyTimes):serverCb(function()
			local var_15_0 = csv.yunying.directbuygift[arg_14_3.csvId]

			gGameUI:showGainDisplay(var_15_0.item, {
				raw = false
			})
		end):doit()
	else
		if arg_14_0.rmb:read() < arg_14_3.rmb then
			uiEasy.showDialog("rmb", nil, {
				dialog = false
			})

			return
		end

		dataEasy.sureUsingDiamonds(function()
			gGameApp:requestServer("/game/yy/award/get", function(arg_17_0)
				arg_14_0.clientBuyTimes:notify()

				local var_17_0 = csv.yunying.directbuygift[arg_14_3.csvId]

				gGameUI:showGainDisplay(var_17_0.item, {
					raw = false
				})
			end, var_14_0, arg_14_3.csvId)
		end, arg_14_3.rmb)
	end
end

function var_0_1.initCountDown(arg_18_0)
	local var_18_0 = arg_18_0.time
	local var_18_1 = csv.yunying.yyhuodong[arg_18_0.timeId]
	local var_18_2, var_18_3 = time.getHourAndMin(var_18_1.endTime)
	local var_18_4 = time.getNumTimestamp(var_18_1.endDate, var_18_2, var_18_3)

	bind.extend(arg_18_0, var_18_0, {
		class = "cutdown_label",
		props = {
			endTime = var_18_4,
			endFunc = function()
				arg_18_0.time:text(gLanguageCsv.activityOver)
			end
		}
	})
end

return var_0_1
