local var_0_0 = table.insert
local var_0_1 = 5
local var_0_2 = 10
local var_0_3 = {
	consumable = 1,
	fragment = 3,
	material = 2,
	all = 0
}
local var_0_4 = {
	open = 3,
	comb = 5,
	gainWay = 1,
	sell = 4,
	itemComb = 6,
	use = 2,
	none = 0
}
local var_0_5 = {
	willUnuse = 2,
	willDestroy = 3,
	unuse = 4,
	forever = 1,
	destroy = 5
}
local var_0_6 = {
	[6363] = "effect_mizao",
	[6358] = "effect_baoyu",
	[6362] = "effect_mizao",
	[6361] = "effect_rou",
	[6360] = "effect_rou",
	[6359] = "effect_shuangpin"
}

local function var_0_7(arg_1_0)
	if not arg_1_0.dateType or arg_1_0.dateType == 0 then
		return var_0_5.forever
	end

	local var_1_0 = time.getTime()

	if arg_1_0.dateType == 2 then
		local var_1_1, var_1_2 = time.getHourAndMin(arg_1_0.expireTime, true)

		if var_1_0 < time.getNumTimestamp(arg_1_0.expireDate, var_1_1, var_1_2) then
			local var_1_3, var_1_4, var_1_5 = time.getYearMonthDay(arg_1_0.expireDate)
			local var_1_6 = string.formatex(gLanguageCsv.timeMonthDay, {
				month = var_1_4,
				day = var_1_5
			}) .. string.format("%02d:%02d", var_1_1, var_1_2)

			if arg_1_0.timeOut == 3 then
				return var_0_5.willUnuse, string.format(gLanguageCsv.itemExpireWillUnuse, var_1_6), "#C0x60C456#"
			end

			return var_0_5.willDestroy, string.format(gLanguageCsv.itemExpireWillDestory, var_1_6), "#C0x60C456#"
		end

		if arg_1_0.timeOut == 3 then
			return var_0_5.unuse, gLanguageCsv.itemExpireUnuse, "#C0xF76B45#"
		end

		return var_0_5.destroy
	end

	return var_0_5.forever
end

local function var_0_8(arg_2_0, arg_2_1)
	if APP_CHANNEL ~= "none" and APP_CHANNEL ~= "luo" and arg_2_0.isShow == false then
		return false
	end

	if arg_2_0.pageTag[1] == 0 then
		return false
	end

	if arg_2_1 == 1 then
		return true
	end

	for iter_2_0, iter_2_1 in ipairs(arg_2_0.pageTag) do
		if iter_2_1 == arg_2_1 - 1 then
			return true
		end
	end

	return false
end

local var_0_9 = cc.load("mvc").ViewBase
local var_0_10 = class("BagView", var_0_9)

var_0_10.RESOURCE_FILENAME = "bag.json"
var_0_10.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	["midPanel.subList"] = "subList",
	rightPanel = "rightPanel",
	midPanel = "midPanel",
	Image_14_0 = "leftBG",
	["rightPanel.numPanel.num"] = "rightNum",
	["midPanel.item"] = "item",
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftDatas"),
				item = bindHelper.self("leftItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:get("normal")
					local var_3_1 = arg_3_1:get("selected")
					local var_3_2

					if arg_3_3.select then
						var_3_0:hide()

						var_3_2 = var_3_1:show()
					else
						var_3_1:hide()

						var_3_2 = var_3_0:show()

						var_3_2:get("subTxt"):text(arg_3_3.subName)
					end

					var_3_2:get("txt"):text(arg_3_3.name)
					var_3_1:setTouchEnabled(false)
					bind.touch(arg_3_0, var_3_0, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftItemClick")
			}
		}
	},
	["midPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				data = bindHelper.self("showdata"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				leftPadding = var_0_2,
				topPadding = var_0_2,
				itemAction = {
					isAction = true
				},
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					bind.extend(arg_4_0, arg_4_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_4_3.id,
								num = arg_4_3.num
							},
							onNode = function(arg_5_0)
								arg_5_0:scale(1.25)

								if arg_4_3.selectEffect then
									arg_4_3.selectEffect:removeSelf()
									arg_4_3.selectEffect:alignCenter(arg_5_0:size())
									arg_5_0:add(arg_4_3.selectEffect, 10)
								end

								local var_5_0 = arg_4_0:getIdx(arg_4_2)

								bind.click(arg_4_0, arg_5_0, {
									method = functools.partial(arg_4_0.itemClick, var_5_0, arg_4_3)
								})
							end
						}
					})
				end,
				asyncPreload = bindHelper.self("midAsyncPreload")
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["midPanel.info"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("info")
		}
	},
	["rightPanel.numPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSubItem")
			}
		}
	},
	["rightPanel.numPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddItem")
			}
		}
	},
	["rightPanel.numPanel.maxBtn"] = {
		varname = "maxBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMaxItem")
			}
		}
	},
	["rightPanel.leftBtn"] = {
		varname = "leftBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftBtnClick")
			}
		}
	},
	["rightPanel.leftBtn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightPanel.rightBtn"] = {
		varname = "rightBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRightBtnClick")
			}
		}
	},
	["rightPanel.rightBtn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_10.onCreate(arg_6_0)
	arg_6_0.subList:width(arg_6_0.list:width() + var_0_2 * 2)
	arg_6_0.list:width(arg_6_0.list:width() + var_0_2 * 2)
	arg_6_0.list:x(arg_6_0.list:x() - var_0_2)

	local var_6_0, var_6_1 = adapt.centerWithScreen("left", "right", {
		itemWidthExtra = 60,
		itemWidth = arg_6_0.item:size().width
	}, {
		{
			arg_6_0.subList,
			"width"
		},
		{
			arg_6_0.list,
			"width"
		},
		{
			arg_6_0.midPanel,
			"width"
		},
		{
			arg_6_0.midPanel,
			"pos",
			"left"
		},
		{
			arg_6_0.leftBG,
			"pos",
			"left"
		}
	})

	arg_6_0.midColumnSize = var_0_1 + var_6_1
	arg_6_0.midAsyncPreload = arg_6_0.midColumnSize * 5

	arg_6_0:initModel()
	gGameUI.topuiManager:createView("default", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "BACKPACK",
		title = "common/txt/txt_bt_beibao.png"
	})

	arg_6_0.leftBtnPosX = arg_6_0.leftBtn:x()
	arg_6_0.rightBtnPosX = arg_6_0.rightBtn:x()
	arg_6_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_6_0.item:size()):retain()
	arg_6_0.leftDatas = idlers.newWithMap({
		{
			subName = "ALL",
			name = gLanguageCsv.spaceAll
		},
		{
			subName = "Consumable",
			name = gLanguageCsv.consumable
		},
		{
			subName = "Material",
			name = gLanguageCsv.spaceMaterial
		},
		{
			subName = "Spall",
			name = gLanguageCsv.spaceFragment
		}
	})
	arg_6_0.showTab = idler.new(1)
	arg_6_0.showdata = idlers.new()
	arg_6_0.selectItem = idlertable.new({})
	arg_6_0.num = idler.new(1)
	arg_6_0.maxNum = idler.new(1)
	arg_6_0.info = idler.new(false)
	arg_6_0.refreshDelayNums = 0

	idlereasy.any({
		arg_6_0.items,
		arg_6_0.frags,
		arg_6_0.zfrags
	}, function()
		if arg_6_0.refreshDelayNums > 0 then
			performWithDelay(arg_6_0, function()
				arg_6_0:refreshShowData()
			end, 0.016666666666666666 * arg_6_0.refreshDelayNums)

			return
		end

		arg_6_0:refreshShowData()
	end)
	arg_6_0.showTab:addListener(function(arg_9_0, arg_9_1)
		arg_6_0.list:jumpToTop()

		arg_6_0.leftDatas:atproxy(arg_9_1).select = false
		arg_6_0.leftDatas:atproxy(arg_9_0).select = true

		dataEasy.tryCallFunc(arg_6_0.list, "setItemAction", {
			isAction = true
		})
		arg_6_0:refreshShowData(arg_9_0)
	end)
	arg_6_0.selectItem:addListener(function(arg_10_0, arg_10_1)
		if next(arg_10_1) then
			local var_10_0 = arg_6_0.showdata:atproxy(arg_10_1.k)

			if var_10_0.selectEffect ~= nil then
				var_10_0.selectEffect = nil
			end
		end

		if next(arg_10_0) then
			local var_10_1 = arg_6_0.showdata:atproxy(arg_10_0.k)

			if var_10_1.selectEffect ~= arg_6_0.selectEffect then
				var_10_1.selectEffect = arg_6_0.selectEffect
			end

			arg_6_0:resetShowPanel(var_10_1)
			arg_6_0.rightPanel:show()
		else
			arg_6_0.rightPanel:hide()
		end
	end)
	idlereasy.any({
		arg_6_0.num,
		arg_6_0.maxNum
	}, function(arg_11_0, arg_11_1, arg_11_2)
		arg_6_0.rightNum:text(arg_11_1)
		arg_6_0.subBtn:setTouchEnabled(arg_11_1 > 1)
		arg_6_0.addBtn:setTouchEnabled(arg_11_1 < arg_11_2)
		arg_6_0.maxBtn:setTouchEnabled(arg_11_1 < arg_11_2)
		cache.setShader(arg_6_0.subBtn, false, arg_11_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_6_0.addBtn, false, arg_11_1 < arg_11_2 and "normal" or "hsl_gray")
	end)

	arg_6_0.sellItems = {}

	for iter_6_0, iter_6_1 in ipairs(gAutoSellItemsCsv) do
		local var_6_2 = arg_6_0.items:read()[iter_6_1.id] or 0

		if var_6_2 > 0 then
			table.insert(arg_6_0.sellItems, {
				num = var_6_2,
				id = iter_6_1.id
			})
		end
	end

	if #arg_6_0.sellItems > 0 then
		arg_6_0.isShowSellItem = true

		gGameUI:stackUI("city.shop_sell", nil, nil, arg_6_0.sellItems, arg_6_0:createHandler("onShowSellItem"))
	end
end

function var_0_10.onShowSellItem(arg_12_0)
	arg_12_0.isShowSellItem = false
end

function var_0_10.onCleanup(arg_13_0)
	arg_13_0.selectEffect:release()
	var_0_9.onCleanup(arg_13_0)
end

function var_0_10.initModel(arg_14_0)
	arg_14_0.items = gGameModel.role:getIdler("items")
	arg_14_0.frags = gGameModel.role:getIdler("frags")
	arg_14_0.zfrags = gGameModel.role:getIdler("zfrags")
	arg_14_0.stamina = gGameModel.role:getIdler("stamina")
end

function var_0_10.onLeftItemClick(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.showTab:set(arg_15_2)
end

function var_0_10.onItemClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_2.data = arg_16_3

	arg_16_0.selectItem:set(arg_16_2)
end

function var_0_10.onSubItem(arg_17_0)
	arg_17_0.num:modify(function(arg_18_0)
		return true, arg_18_0 - 1
	end)
end

function var_0_10.onAddItem(arg_19_0)
	arg_19_0.num:modify(function(arg_20_0)
		return true, arg_20_0 + 1
	end)
end

function var_0_10.onMaxItem(arg_21_0)
	arg_21_0.num:set(arg_21_0.maxNum)
end

function var_0_10.onLeftBtnClick(arg_22_0)
	arg_22_0:onBtnClick(arg_22_0.leftBtn, arg_22_0.leftBtnState)
end

function var_0_10.onRightBtnClick(arg_23_0)
	arg_23_0:onBtnClick(arg_23_0.rightBtn, arg_23_0.rightBtnState)
end

function var_0_10.onBtnClick(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.showdata:atproxy(arg_24_0.selectItem:read().k)
	local var_24_1 = var_24_0.id
	local var_24_2 = var_24_0.cfg
	local var_24_3 = arg_24_0.maxNum:read()

	if arg_24_2 == var_0_4.use or arg_24_2 == var_0_4.open then
		if var_24_2.type == game.ITEM_TYPE_ENUM_TABLE.staminaRecover and arg_24_0.stamina:read() >= game.STAMINA_LIMIT then
			gGameUI:showTip(gLanguageCsv.staminaFull)

			return
		end

		if var_24_2.type == game.ITEM_TYPE_ENUM_TABLE.gift or var_24_2.type == game.ITEM_TYPE_ENUM_TABLE.randomGift then
			arg_24_0.num:set(var_24_3)
		end
	end

	local function var_24_4(arg_25_0)
		if var_24_2.type == game.ITEM_TYPE_ENUM_TABLE.chooseGift then
			gGameUI:stackUI("city.gift_choose", nil, nil, var_24_1, {
				num = arg_24_0:createHandler("num"),
				maxNum = var_24_3,
				flag = arg_25_0
			}, arg_24_0:createHandler("onUseCb", var_24_1, var_24_2))

			return
		end

		if var_24_3 <= 1 then
			arg_24_0:onUseCb(var_24_1, var_24_2, var_24_3)

			return
		end

		gGameUI:stackUI("common.buy_info", nil, nil, nil, {
			id = var_24_1
		}, {
			contentType = "num",
			style = 2,
			num = arg_24_0:createHandler("num"),
			maxNum = var_24_3,
			flag = arg_25_0
		}, arg_24_0:createHandler("onUseCb", var_24_1, var_24_2))
	end

	if arg_24_2 == var_0_4.gainWay then
		jumpEasy.jumpTo("gainWay", var_24_1)
	elseif arg_24_2 == var_0_4.itemComb then
		gGameUI:stackUI("city.card.star_combfrags", nil, nil, var_24_1)
	elseif arg_24_2 == var_0_4.comb then
		gGameUI:stackUI("city.card.star_changefrags")
	elseif var_24_2.use and var_24_2.use ~= "" then
		jumpEasy.jumpTo(var_24_2.use)
	elseif arg_24_2 == var_0_4.use then
		var_24_4("use")
	elseif arg_24_2 == var_0_4.open then
		var_24_4("open")
	elseif arg_24_2 == var_0_4.sell then
		if var_24_3 <= 1 then
			arg_24_0:onSellCb(var_24_1, var_24_3)
		else
			gGameUI:stackUI("common.buy_info", nil, nil, {
				gold = var_24_2.sellPrice or 0
			}, {
				id = var_24_1
			}, {
				contentType = "num",
				style = 2,
				flag = "sell",
				num = arg_24_0:createHandler("num"),
				maxNum = var_24_3
			}, arg_24_0:createHandler("onSellCb", var_24_1))
		end
	end
end

function var_0_10.onUseCb(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	if arg_26_2.type == game.ITEM_TYPE_ENUM_TABLE.staminaRecover then
		gGameApp:requestServer("/game/role/stamina/use_item", function(arg_27_0)
			gGameUI:showTip(gLanguageCsv.useSuccess)
		end, arg_26_1, arg_26_3)
	elseif arg_26_2.type == game.ITEM_TYPE_ENUM_TABLE.chooseGift then
		gGameApp:requestServer("/game/role/gift/choose", function(arg_28_0)
			gGameUI:showGainDisplay(arg_28_0)
		end, arg_26_1, arg_26_3, arg_26_4)
	else
		local var_26_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/role/item/use"):params({
			[arg_26_1] = arg_26_3
		}):onResponse(function(arg_29_0)
			local var_29_0 = 0

			if var_0_6[arg_26_1] then
				if arg_26_0.animaZongzi then
					arg_26_0.animaZongzi:play(var_0_6[arg_26_1])
				else
					arg_26_0.animaZongzi = widget.addAnimation(arg_26_0, "duanwuzongzi/chizongzi.skel", var_0_6[arg_26_1], 10):xy(cc.p(1280, 720)):scale(3)
				end

				var_29_0 = 3
			end

			performWithDelay(arg_26_0, function()
				var_26_0[1] = true

				gGameUI:showGainDisplay(arg_29_0)
			end, var_29_0)
		end):wait(var_26_0):doit(function(arg_31_0)
			return
		end)
	end
end

function var_0_10.onSellCb(arg_32_0, arg_32_1, arg_32_2)
	if dataEasy.isFragment(arg_32_1) then
		gGameApp:requestServer("/game/role/frag/sell_many", function(arg_33_0)
			gGameUI:showTip(gLanguageCsv.sellSuccess)
		end, {
			[arg_32_1] = arg_32_2
		})
	else
		gGameApp:requestServer("/game/role/item/sell", function(arg_34_0)
			gGameUI:showTip(gLanguageCsv.sellSuccess)
		end, {
			[arg_32_1] = arg_32_2
		})
	end
end

function var_0_10.refreshShowData(arg_35_0, arg_35_1)
	if not arg_35_1 then
		arg_35_0.refreshDelayNums = arg_35_0.refreshDelayNums + 1

		performWithDelay(arg_35_0, function()
			arg_35_0.refreshDelayNums = math.max(arg_35_0.refreshDelayNums - 1, 0)
		end, 0.016666666666666666)
	end

	local var_35_0 = {}
	local var_35_1 = arg_35_1 or arg_35_0.showTab:read()

	idlereasy.do_(function(arg_37_0, arg_37_1, arg_37_2)
		for iter_37_0, iter_37_1 in itertools.chain({
			arg_37_0,
			arg_37_1,
			arg_37_2
		}) do
			local var_37_0 = dataEasy.getCfgByKey(iter_37_0)

			if var_0_8(var_37_0, var_35_1) then
				local var_37_1, var_37_2, var_37_3 = var_0_7(var_37_0)

				if var_37_1 ~= var_0_5.destroy then
					var_0_0(var_35_0, {
						id = iter_37_0,
						num = iter_37_1,
						cfg = var_37_0,
						expireState = var_37_1,
						expireInfo = var_37_2,
						expireInfoEffect = var_37_3
					})
				end
			end
		end
	end, arg_35_0.items, arg_35_0.frags, arg_35_0.zfrags)

	local var_35_2 = {
		[var_0_3.consumable] = 1,
		[var_0_3.material] = 2,
		[var_0_3.fragment] = 3
	}

	local function var_35_3(arg_38_0)
		local var_38_0 = 3

		if arg_38_0.expireState == var_0_5.willUnuse or arg_38_0.expireState == var_0_5.willDestroy then
			var_38_0 = 1
		elseif arg_38_0.expireState == var_0_5.forever then
			var_38_0 = 2
		end

		return var_38_0 * 100 + (var_35_2[arg_38_0.cfg.pageTag[1]] or 9) * 10
	end

	table.sort(var_35_0, function(arg_39_0, arg_39_1)
		local var_39_0 = var_35_3(arg_39_0)
		local var_39_1 = var_35_3(arg_39_1)

		if var_39_0 ~= var_39_1 then
			return var_39_0 < var_39_1
		end

		if arg_39_0.cfg.sortType ~= arg_39_1.cfg.sortType then
			return arg_39_0.cfg.sortType > arg_39_1.cfg.sortType
		end

		if arg_39_0.cfg.sortValue ~= arg_39_1.cfg.sortValue then
			return arg_39_0.cfg.sortValue > arg_39_1.cfg.sortValue
		end

		if arg_39_0.cfg.quality ~= arg_39_1.cfg.quality then
			return arg_39_0.cfg.quality > arg_39_1.cfg.quality
		end

		return arg_39_0.id < arg_39_1.id
	end)

	local var_35_4 = arg_35_0.selectItem:read()
	local var_35_5

	if #var_35_0 == 0 then
		-- block empty
	elseif arg_35_1 or not var_35_4.data then
		var_35_5 = 1
	else
		for iter_35_0, iter_35_1 in ipairs(var_35_0) do
			if iter_35_1.id == var_35_4.data.id then
				var_35_5 = iter_35_0

				break
			end
		end

		var_35_5 = var_35_5 or math.min(var_35_4.k or 1, #var_35_0)
	end

	arg_35_0.selectItem:set({})

	if var_35_5 then
		if not arg_35_1 and not arg_35_0.isShowSellItem then
			dataEasy.tryCallFunc(arg_35_0.list, "updatePreloadCenterIndexAdaptFirst")
		end

		var_35_0[var_35_5].selectEffect = arg_35_0.selectEffect

		arg_35_0.showdata:update(var_35_0)
		arg_35_0.selectItem:set({
			k = var_35_5,
			data = var_35_0[var_35_5]
		})
		arg_35_0.info:set(false)
	else
		arg_35_0.showdata:update({})
		arg_35_0.info:set(true)
	end
end

function var_0_10.resetShowPanel(arg_40_0, arg_40_1)
	arg_40_0.num:set(1)
	arg_40_0.maxNum:set(arg_40_1.num)
	bind.extend(arg_40_0, arg_40_0.rightPanel, {
		class = "icon_key",
		props = {
			noListener = true,
			simpleShow = true,
			data = {
				key = arg_40_1.id
			},
			onNode = function(arg_41_0)
				local var_41_0, var_41_1 = arg_40_0.rightPanel:get("icon"):xy()

				arg_41_0:xy(var_41_0, var_41_1):scale(1.5):z(3)
			end
		}
	})

	local var_40_0 = arg_40_1.cfg.effBtn
	local var_40_1 = itertools.size(var_40_0)

	arg_40_0.leftBtnState = var_0_4.none
	arg_40_0.rightBtnState = var_0_4.none

	if var_40_1 == 0 then
		nodetools.invoke(arg_40_0.rightPanel, {
			"leftBtn",
			"rightBtn"
		}, "hide")
	elseif var_40_1 == 1 then
		arg_40_0.leftBtn:x((arg_40_0.leftBtnPosX + arg_40_0.rightBtnPosX) / 2)

		arg_40_0.leftBtnState = var_40_0[1]
	else
		arg_40_0.leftBtn:x(arg_40_0.leftBtnPosX)
		arg_40_0.rightBtn:x(arg_40_0.rightBtnPosX)

		arg_40_0.leftBtnState = var_40_0[1]
		arg_40_0.rightBtnState = var_40_0[2]
	end

	local function var_40_2(arg_42_0, arg_42_1)
		if arg_42_1 == var_0_4.use then
			arg_42_0:get("txt"):text(gLanguageCsv.spaceUse)
		elseif arg_42_1 == var_0_4.open then
			arg_42_0:get("txt"):text(gLanguageCsv.spaceOpen)
		elseif arg_42_1 == var_0_4.sell then
			arg_42_0:get("txt"):text(gLanguageCsv.spaceSell)
		elseif arg_42_1 == var_0_4.gainWay then
			arg_42_0:get("txt"):text(gLanguageCsv.gainWay)
		elseif arg_42_1 == var_0_4.comb then
			arg_42_0:get("txt"):text(gLanguageCsv.spaceComb)
		elseif arg_42_1 == var_0_4.itemComb then
			arg_42_0:get("txt"):text(gLanguageCsv.spaceComb)
		else
			arg_42_0:hide()

			return
		end

		arg_42_0:show()

		return true
	end

	var_40_2(arg_40_0.leftBtn, arg_40_0.leftBtnState)
	var_40_2(arg_40_0.rightBtn, arg_40_0.rightBtnState)
	arg_40_0.rightPanel:get("numPanel"):visible(false)

	local var_40_3 = 694
	local var_40_4 = 564
	local var_40_5 = 10
	local var_40_6 = arg_40_0.rightPanel:get("nameList")
	local var_40_7 = beauty.singleTextAutoScroll({
		fontSize = 60,
		align = "center",
		list = var_40_6,
		size = cc.size(var_40_3, 80),
		strs = {
			str = uiEasy.setIconName(arg_40_1.id),
			effect = {
				color = ui.NEWCOLORS.RED2,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	})

	if not var_40_6 then
		var_40_7:xy(0, var_40_4 + 435):addTo(arg_40_0.rightPanel, 10, "nameList")
	end

	local var_40_8 = {
		{
			str = "#C0x4a4337#" .. uiEasy.getIconDesc(arg_40_1.id, arg_40_1.num)
		}
	}

	if arg_40_1.cfg.desc1 and arg_40_1.cfg.desc1 ~= "" then
		table.insert(var_40_8, {
			fontSize = 10
		})
		table.insert(var_40_8, {
			str = "#C0x000000#" .. arg_40_1.cfg.desc1
		})
	end

	if arg_40_1.expireInfo then
		table.insert(var_40_8, {
			fontSize = 10
		})
		table.insert(var_40_8, {
			str = arg_40_1.expireInfoEffect .. arg_40_1.expireInfo
		})
	end

	arg_40_0.rightPanel:removeChildByName("descList")
	beauty.textScroll({
		isRich = true,
		size = cc.size(var_40_3, var_40_4 - 320),
		strs = var_40_8
	}):xy(var_40_5, 220):addTo(arg_40_0.rightPanel, 3, "descList")
end

return var_0_10
