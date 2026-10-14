local var_0_0 = require("app.views.city.activity.month_card")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BuyInfoView", Dialog)
local var_0_3 = {
	open = 4,
	buy = 1,
	exchange = 5,
	sell = 2,
	use = 3
}
local var_0_4 = {
	gLanguageCsv.buyItem,
	gLanguageCsv.sellItem,
	gLanguageCsv.useItem,
	gLanguageCsv.openItem,
	gLanguageCsv.exchangeItem
}
local var_0_5 = {
	gLanguageCsv.spaceBuy,
	gLanguageCsv.spaceSell,
	gLanguageCsv.spaceUse,
	gLanguageCsv.spaceOpen,
	gLanguageCsv.spaceExchange
}
local var_0_6 = {
	gLanguageCsv.cost,
	gLanguageCsv.sellingPrice,
	gLanguageCsv.cost,
	gLanguageCsv.cost,
	gLanguageCsv.cost
}
local var_0_7 = {
	reach = 2,
	noReach = 1,
	over = 3
}
local var_0_8 = 26

var_0_2.RESOURCE_FILENAME = "common_buy_info.json"
var_0_2.RESOURCE_BINDING = {
	["content.maxNum"] = "maxNumLabel",
	["content.sliderPanel"] = "sliderPanel",
	content = "content",
	["content.sliderPanel.slider"] = "slider",
	["pricePanel.text"] = "priceDesc",
	priceItem = "priceItem",
	["content.label"] = "ownLabel",
	["content.maxTip"] = "maxTip",
	["selectPanel.txt"] = "selectDesc",
	selectPanel = "selectPanel",
	["content.num"] = "numLabel",
	["content.numPanel"] = "numPanel",
	pricePanel = "pricePanel",
	selectItem = "selectItem",
	title = {
		varname = "title",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["content.sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_1_0, arg_1_1, arg_1_2)
				return arg_1_0:onChangeNum(arg_1_1, arg_1_2, -1)
			end)
		}
	},
	["content.sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	},
	["content.numPanel.subBtn"] = {
		varname = "numSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, -1)
			end)
		}
	},
	["content.numPanel.addBtn"] = {
		varname = "numAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, 1)
			end)
		}
	},
	["content.numPanel.subTenBtn"] = {
		varname = "numSubTenBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, -10)
			end)
		}
	},
	["content.numPanel.addTenBtn"] = {
		varname = "numAddTenBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_6_0, arg_6_1, arg_6_2)
				return arg_6_0:onChangeNum(arg_6_1, arg_6_2, 10)
			end)
		}
	},
	["content.numPanel.Button_41"] = {
		varname = "numSubS",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_7_0, arg_7_1, arg_7_2)
				return arg_7_0:onChangeNum(arg_7_1, arg_7_2, -10000)
			end)
		}
	},
	["content.numPanel.addL"] = {
		varname = "numAddL",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_8_0, arg_8_1, arg_8_2)
				return arg_8_0:onChangeNum(arg_8_1, arg_8_2, 10000)
			end)
		}
	},
	buyBtn = {
		varname = "buyBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyItem")
			}
		}
	},
	["buyBtn.text"] = {
		varname = "buyBtnText",
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
	["pricePanel.priceList"] = {
		varname = "priceList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("priceData"),
				item = bindHelper.self("priceItem"),
				priceListWidth = bindHelper.self("priceListWidth"),
				discount = bindHelper.self("discount"),
				flag = bindHelper.self("flag"),
				margin = var_0_8,
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:multiget("price", "icon", "original", "line")
					local var_9_1 = arg_9_0.discount > 0 and arg_9_0.discount < 1
					local var_9_2 = mathEasy.getPreciseDecimal(arg_9_3.cost * arg_9_0.discount, 0, true)

					var_9_0.original:visible(var_9_1)
					var_9_0.line:visible(var_9_1)
					var_9_0.price:text(var_9_2)
					var_9_0.icon:texture(dataEasy.getIconResByKey(arg_9_3.key))
					var_9_0.original:text(arg_9_3.cost)
					var_9_0.line:width((var_9_0.original:width() * var_9_0.original:scale() + 18) / var_9_0.line:scale())

					if arg_9_0.flag ~= var_0_3.sell then
						text.addEffect(var_9_0.price, {
							color = var_9_2 <= dataEasy.getNumByKey(arg_9_3.key) and ui.NEWCOLORS.BROWN1 or ui.COLORS.NORMAL.ALERT_ORANGE
						})
					end

					local var_9_3 = 10
					local var_9_4 = var_9_0.price:width() * var_9_0.price:scale()
					local var_9_5 = var_9_0.icon:width() * var_9_0.icon:scale()
					local var_9_6 = var_9_1 and var_9_0.line:width() * var_9_0.line:scale() or 0
					local var_9_7 = var_9_1 and var_9_3 * 2 or var_9_3
					local var_9_8 = var_9_6 + var_9_4 + var_9_5 + var_9_7

					arg_9_1:width(var_9_8)
					arg_9_0.priceListWidth:set(arg_9_0.priceListWidth:read() + var_9_8)

					if var_9_1 then
						adapt.oneLinePos(var_9_0.line, {
							var_9_0.price,
							var_9_0.icon
						}, cc.p(var_9_3, 0), "left")
					else
						adapt.oneLinePos(var_9_0.price, var_9_0.icon, cc.p(var_9_3, 0), "left")
					end
				end,
				onAfterBuild = function(arg_10_0)
					arg_10_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuildPriceList")
			}
		}
	},
	["selectPanel.list"] = {
		varname = "selectList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("selectData"),
				item = bindHelper.self("selectItem"),
				selectListWidth = bindHelper.self("selectListWidth"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					local var_11_0 = arg_11_1:multiget("price", "icon", "selectPanel")

					var_11_0.icon:texture(dataEasy.getIconResByKey(arg_11_3.key))
					var_11_0.price:text(arg_11_3.val)
					var_11_0.selectPanel:get("select"):visible(arg_11_3.selected)

					local var_11_1 = 10
					local var_11_2 = var_11_0.price:x()
					local var_11_3 = var_11_0.price:width()
					local var_11_4 = var_11_0.icon:width()
					local var_11_5 = var_11_1 * 2
					local var_11_6 = var_11_2 + var_11_3 + var_11_4 + var_11_5

					arg_11_1:width(var_11_6)
					arg_11_0.selectListWidth:set(arg_11_0.selectListWidth:read() + var_11_6)
					adapt.oneLinePos(var_11_0.price, var_11_0.icon, cc.p(var_11_1, 0), "left")
					bind.click(arg_11_0, arg_11_1, {
						method = functools.partial(arg_11_0.clickCell, arg_11_2, arg_11_3)
					})
				end,
				onAfterBuild = function(arg_12_0)
					arg_12_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuildSelectList"),
				clickCell = bindHelper.self("onSelectedClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_3 = arg_13_3 or {}

	arg_13_0:enableSchedule()

	arg_13_0.cb = arg_13_4

	local var_13_0 = arg_13_2.id

	arg_13_0.id = var_13_0

	local var_13_1 = arg_13_2.num
	local var_13_2 = arg_13_2.num or 1
	local var_13_3 = arg_13_3.style or 1
	local var_13_4 = arg_13_3.contentType

	arg_13_0.flag = var_0_3[arg_13_3.flag or "buy"]
	arg_13_0.num = arg_13_3.num and arg_13_3.num() or idler.new(1)
	arg_13_0.maxNum = arg_13_3.maxNum or math.huge
	arg_13_0.discount = arg_13_3.discount or 1
	arg_13_0.stackState = var_0_7.noReach

	arg_13_0.title:text(var_0_4[arg_13_0.flag])
	arg_13_0.buyBtnText:text(var_0_5[arg_13_0.flag])

	local var_13_5 = arg_13_3.selectMap

	arg_13_0.pricePanel:visible(arg_13_1 ~= nil and var_13_5 == nil)

	if arg_13_1 then
		arg_13_0.priceDesc:text(var_0_6[arg_13_0.flag] .. ": ")
	end

	arg_13_0.priceData = idlers.newWithMap({})
	arg_13_0.priceListWidth = idler.new(0)

	arg_13_0.selectPanel:visible(var_13_5 ~= nil)

	if var_13_5 then
		arg_13_0.selectDesc:text(var_0_6[arg_13_0.flag] .. ": ")
	end

	arg_13_0.selectListWidth = idler.new(0)

	local var_13_6 = {}

	if var_13_0 ~= "card" then
		var_13_6 = dataEasy.getCfgByKey(var_13_0)
	end

	if var_13_6.type == game.ITEM_TYPE_ENUM_TABLE.staminaRecover then
		arg_13_0.itemAddStamina = var_13_6.specialArgsMap.stamina

		local var_13_7
		local var_13_8

		arg_13_0.canUseMaxNum, var_13_8 = math.modf((game.STAMINA_LIMIT - gGameModel.role:read("stamina")) / arg_13_0.itemAddStamina)
		arg_13_0.canUseMaxNum = var_13_8 == 0 and arg_13_0.canUseMaxNum or arg_13_0.canUseMaxNum + 1
	end

	arg_13_0.maxTip:hide()

	local var_13_9 = {
		class = "icon_key",
		props = {
			data = {
				key = var_13_0,
				num = var_13_1
			},
			onNode = function(arg_14_0)
				arg_14_0:xy(210, 410):z(3)
			end
		}
	}

	bind.extend(arg_13_0, arg_13_0.content, var_13_9)

	local var_13_10, var_13_11 = uiEasy.setIconName(var_13_0, var_13_1)

	beauty.singleTextAutoScroll({
		align = "left",
		size = cc.size(500, 50),
		strs = {
			fontPath = "font/youmi.ttf",
			str = var_13_10
		},
		effect = {
			color = ui.NEWCOLORS.BROWN1
		}
	}):xy(322, 425):addTo(arg_13_0.content, 4)
	itertools.invoke({
		arg_13_0.sliderPanel,
		arg_13_0.numPanel
	}, "hide")

	local var_13_12 = {
		arg_13_0.num
	}

	if arg_13_0.flag == var_0_3.buy then
		for iter_13_0, iter_13_1 in csvMapPairs(arg_13_1) do
			local var_13_13 = gGameModel.role:getIdler(tostring(iter_13_0))

			table.insert(var_13_12, var_13_13)
		end
	end

	idlereasy.any(var_13_12, function(arg_15_0, arg_15_1)
		if (arg_13_0.flag == var_0_3.buy or arg_13_0.flag == var_0_3.exchange) and var_13_0 ~= "card" then
			local var_15_0 = math.floor((dataEasy.itemStackMax(var_13_0) - dataEasy.getNumByKey(var_13_0)) / var_13_2)
			local var_15_1
			local var_15_2

			for iter_15_0, iter_15_1 in csvMapPairs(arg_13_1) do
				local var_15_3 = dataEasy.getNumByKey(iter_15_0)

				var_15_1 = var_15_1 and itertools.min({
					math.floor(var_15_3 / (iter_15_1 * arg_13_0.discount)),
					var_15_1
				}) or math.floor(var_15_3 / (iter_15_1 * arg_13_0.discount))
			end

			arg_13_0.maxNum = itertools.min({
				arg_13_3.maxNum,
				var_15_0,
				var_15_1
			})

			if dataEasy.getNumByKey(var_13_0) >= dataEasy.itemStackMax(var_13_0) then
				arg_13_0.stackState = var_0_7.reach
			elseif arg_15_1 * var_13_2 + dataEasy.getNumByKey(var_13_0) > dataEasy.itemStackMax(var_13_0) then
				arg_13_0.stackState = var_0_7.over
			end
		end

		arg_13_0.numLabel:text(arg_15_1)
		arg_13_0:initProductCount(var_13_3, var_13_0, var_13_4, arg_15_1)
		arg_13_0:setProductData(arg_15_1, arg_13_1)
	end)
	arg_13_0.slider:addEventListener(function(arg_16_0, arg_16_1)
		if arg_16_1 == ccui.SliderEventType.percentChanged then
			arg_13_0:unScheduleAll()

			local var_16_0 = arg_16_0:getPercent()

			if var_16_0 == 0 and arg_13_0.lastPercent ~= 0 then
				arg_13_0.lastPercent = var_16_0

				return
			end

			arg_13_0.lastPercent = var_16_0

			local var_16_1 = cc.clampf(math.ceil(arg_13_0.maxNum * var_16_0 * 0.01), 1, math.max(arg_13_0.maxNum, 1))

			if arg_13_0.canUseMaxNum then
				local var_16_2 = math.min(var_16_1, arg_13_0.canUseMaxNum) / arg_13_0.maxNum * 100

				var_16_1 = cc.clampf(math.ceil(arg_13_0.maxNum * var_16_2 * 0.01), 1, math.max(arg_13_0.canUseMaxNum, 1))
			end

			arg_13_0.num:set(var_16_1, true)
		end
	end)

	arg_13_0.selectData = idlers.new()

	if arg_13_0.selectPanel:visible() then
		arg_13_0.selectID = idler.new()

		local var_13_14 = {}

		for iter_13_2, iter_13_3 in csvMapPairs(var_13_5) do
			table.insert(var_13_14, {
				selected = false,
				key = iter_13_2,
				val = iter_13_3
			})
		end

		var_13_14[1].selected = true

		arg_13_0.selectData:update(var_13_14)
		arg_13_0.selectID:addListener(function(arg_17_0, arg_17_1)
			if arg_17_0 and arg_17_1 then
				arg_13_0.selectData:atproxy(arg_17_1).selected = false
				arg_13_0.selectData:atproxy(arg_17_0).selected = true
			end
		end)
		arg_13_0.selectID:set(1)
	end

	Dialog.onCreate(arg_13_0)
end

function var_0_2.initProductCount(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	if arg_18_1 == 1 then
		if arg_18_2 == "card" then
			arg_18_0.ownLabel:hide()
			arg_18_0.maxNumLabel:hide()
		else
			arg_18_0.ownLabel:show()
			arg_18_0.maxNumLabel:text(dataEasy.getNumByKey(arg_18_2))
			adapt.oneLinePos(arg_18_0.ownLabel, arg_18_0.maxNumLabel, cc.p(20, 0))
		end

		arg_18_0.numLabel:hide()
	else
		arg_18_0.ownLabel:hide()
		arg_18_0.numLabel:show()
		arg_18_0.maxNumLabel:text("/" .. math.max(arg_18_0.maxNum, 1))
		adapt.oneLinePos(arg_18_0.numLabel, arg_18_0.maxNumLabel)
	end

	local var_18_0 = arg_18_4 > 1
	local var_18_1 = arg_18_4 < arg_18_0.maxNum

	if arg_18_0.canUseMaxNum and arg_18_0.flag == var_0_3.use then
		var_18_1 = arg_18_4 < math.min(arg_18_0.canUseMaxNum, arg_18_0.maxNum)

		arg_18_0.maxTip:hide()

		if arg_18_4 >= arg_18_0.canUseMaxNum then
			arg_18_0.maxTip:show()
			arg_18_0.unScheduleAll()

			if arg_18_0.itemAddStamina * arg_18_4 + gGameModel.role:read("stamina") == game.STAMINA_LIMIT then
				arg_18_0.maxTip:text(gLanguageCsv.energyFull)
				text.addEffect(arg_18_0.maxTip, {
					color = ui.NEWCOLORS.BROWN2
				})
			else
				arg_18_0.maxTip:text(gLanguageCsv.energyOverflow)
				text.addEffect(arg_18_0.maxTip, {
					color = ui.COLORS.NORMAL.ALERT_ORANGE
				})
			end
		end

		adapt.oneLinePos(arg_18_0.numLabel, {
			arg_18_0.maxNumLabel,
			arg_18_0.maxTip
		}, {
			cc.p(0, 0),
			cc.p(10, 0)
		})
	end

	local var_18_2 = var_18_0 and "normal" or "hsl_gray"
	local var_18_3 = var_18_1 and "normal" or "hsl_gray"

	if arg_18_3 == "slider" then
		arg_18_0.sliderSubBtn:setTouchEnabled(var_18_0)
		arg_18_0.sliderAddBtn:setTouchEnabled(var_18_1)
		cache.setShader(arg_18_0.sliderSubBtn, false, var_18_2)
		cache.setShader(arg_18_0.sliderAddBtn, false, var_18_3)
		arg_18_0.sliderPanel:show()
		arg_18_0.numPanel:hide()
	elseif arg_18_3 == "num" then
		arg_18_0.numSubBtn:setTouchEnabled(var_18_0)
		arg_18_0.numAddBtn:setTouchEnabled(var_18_1)
		cache.setShader(arg_18_0.numSubBtn, false, var_18_2)
		cache.setShader(arg_18_0.numAddBtn, false, var_18_3)
		arg_18_0.numSubTenBtn:setTouchEnabled(var_18_0)
		arg_18_0.numAddTenBtn:setTouchEnabled(var_18_1)
		cache.setShader(arg_18_0.numSubTenBtn, false, var_18_2)
		cache.setShader(arg_18_0.numAddTenBtn, false, var_18_3)
		arg_18_0.numSubS:setTouchEnabled(var_18_0)
		arg_18_0.numAddL:setTouchEnabled(var_18_1)
		cache.setShader(arg_18_0.numSubS, false, var_18_2)
		cache.setShader(arg_18_0.numAddL, false, var_18_3)
		arg_18_0.numPanel:get("num"):text(arg_18_4)
		arg_18_0.sliderPanel:hide()
		arg_18_0.numPanel:show()
	else
		arg_18_0.sliderPanel:hide()
		arg_18_0.numPanel:hide()
	end
end

function var_0_2.setProductData(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = math.floor(arg_19_1 / arg_19_0.maxNum * 100)

	arg_19_0.slider:setPercent(var_19_0)

	if arg_19_0.pricePanel:visible() then
		local var_19_1 = {}

		for iter_19_0, iter_19_1 in csvMapPairs(arg_19_2) do
			table.insert(var_19_1, {
				key = iter_19_0,
				cost = iter_19_1 * arg_19_1
			})
		end

		arg_19_0.priceListWidth:set(0)
		arg_19_0.priceData:update(var_19_1)
	end
end

function var_0_2.onIncreaseNum(arg_20_0, arg_20_1)
	arg_20_0.num:modify(function(arg_21_0)
		if arg_21_0 == 1 and arg_20_1 == 10 then
			return true, cc.clampf(10, 1, math.max(arg_20_0.maxNum, 1))
		end

		return true, cc.clampf(arg_21_0 + arg_20_1, 1, math.max(arg_20_0.maxNum, 1))
	end)
end

function var_0_2.onChangeNum(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_2.name == "click" then
		arg_22_0:unScheduleAll()
		arg_22_0:onIncreaseNum(arg_22_3)
	elseif arg_22_2.name == "began" then
		arg_22_0:schedule(function()
			arg_22_0:onIncreaseNum(arg_22_3)
		end, 0.05, 0, 1)
	elseif arg_22_2.name == "ended" or arg_22_2.name == "cancelled" then
		arg_22_0:unScheduleAll()
	end
end

function var_0_2.onBuyItem(arg_24_0)
	local var_24_0 = false
	local var_24_1 = 0

	if arg_24_0.flag == var_0_3.buy then
		for iter_24_0, iter_24_1 in arg_24_0.priceData:pairs() do
			local var_24_2 = iter_24_1:read().key

			if mathEasy.getPreciseDecimal(iter_24_1:read().cost * arg_24_0.discount, 0, true) > dataEasy.getNumByKey(var_24_2) then
				uiEasy.showDialog(var_24_2, nil, {
					dialog = true
				})

				return
			end
		end
	end

	for iter_24_2, iter_24_3 in arg_24_0.priceData:pairs() do
		if iter_24_3:read().key == "rmb" then
			var_24_0 = true
			var_24_1 = mathEasy.getPreciseDecimal(iter_24_3:read().cost * arg_24_0.discount, 0, true)

			break
		end
	end

	if arg_24_0.stackState == var_0_7.reach then
		local var_24_3 = string.gsub(var_0_5[arg_24_0.flag], "%s+", "")

		gGameUI:showTip(gLanguageCsv.itemStackReachMax, var_24_3)

		return
	end

	local function var_24_4(arg_25_0, arg_25_1)
		if (arg_24_0.flag == var_0_3.buy or arg_24_0.flag == var_0_3.exchange) and var_24_0 then
			dataEasy.sureUsingDiamonds(function()
				if arg_25_1 then
					arg_24_0:addCallbackOnExit(functools.partial(arg_24_0.cb, arg_25_0, arg_25_1))
				else
					arg_24_0:addCallbackOnExit(functools.partial(arg_24_0.cb, arg_25_0))
				end

				var_0_1.onClose(arg_24_0)
			end, var_24_1)
		else
			if arg_25_1 then
				arg_24_0:addCallbackOnExit(functools.partial(arg_24_0.cb, arg_25_0, arg_25_1))
			else
				arg_24_0:addCallbackOnExit(functools.partial(arg_24_0.cb, arg_25_0))
			end

			var_0_1.onClose(arg_24_0)
		end
	end

	local var_24_5 = arg_24_0.num:read()

	if arg_24_0.stackState == var_0_7.over then
		local var_24_6 = string.gsub(var_0_5[arg_24_0.flag], "%s+", "")

		gGameUI:showDialog({
			clearFast = true,
			btnType = 2,
			align = "left",
			content = string.format(gLanguageCsv.itemStackOverMax, var_24_6),
			cb = function()
				var_24_4(var_24_5)
			end
		})
	elseif arg_24_0.selectID then
		local var_24_7 = arg_24_0.selectData:atproxy(arg_24_0.selectID:read())
		local var_24_8 = dataEasy.getNumByKey(var_24_7.key)

		if var_24_8 < var_24_7.val then
			uiEasy.showDialog(var_24_7.key, nil, {
				dialog = true
			})
		else
			var_24_4(var_24_8, arg_24_0.selectID:read())
		end
	else
		var_24_4(var_24_5)
	end
end

function var_0_2.onAfterBuildPriceList(arg_28_0)
	local var_28_0 = itertools.size(arg_28_0.priceData)

	arg_28_0.priceList:width(var_0_8 * (var_28_0 - 1) + arg_28_0.priceListWidth:read())
	adapt.oneLineCenterPos(cc.p(arg_28_0.pricePanel:width() / 2, arg_28_0.priceDesc:y()), {
		arg_28_0.priceDesc,
		arg_28_0.priceList
	}, cc.p(0, -arg_28_0.priceList:height() / 2))
end

function var_0_2.onAfterBuildSelectList(arg_29_0)
	local var_29_0 = itertools.size(arg_29_0.selectData)

	arg_29_0.selectList:width(arg_29_0.selectListWidth:read())
	adapt.oneLineCenterPos(cc.p(arg_29_0.selectPanel:width() / 2, arg_29_0.selectDesc:y()), {
		arg_29_0.selectDesc,
		arg_29_0.selectList
	}, cc.p(0, -arg_29_0.selectList:height() / 2))
end

function var_0_2.onSelectedClick(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_0.selectID:set(arg_30_2)
end

return var_0_2
