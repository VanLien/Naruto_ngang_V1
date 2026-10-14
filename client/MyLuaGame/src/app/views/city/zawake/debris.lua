local var_0_0 = {
	exclusive = 2,
	currency = 1
}
local var_0_1 = require("app.views.city.zawake.tools")
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("ZawakeDebrisView", Dialog)

var_0_3.RESOURCE_FILENAME = "zawake_debris.json"
var_0_3.RESOURCE_BINDING = {
	needNum = "needNumText",
	["barPanel.myFrags"] = "myFrags",
	cardPanel2 = "cardPanel2",
	barPanel = "barPanel",
	cardPanel1 = "cardPanel1",
	["barPanel.needFrags"] = "needFrags",
	titleTxt = "title",
	priceItem = "priceItem",
	item = "item",
	["barPanel.bar"] = "slider",
	combTipPos = "combTipPos",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnList = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("btn")
					local var_1_1 = arg_1_1:get("title")

					var_1_1:text(arg_1_3.name)
					var_1_0:setBright(not arg_1_3.isSelected)
					arg_1_1:onClick(functools.partial(arg_1_0.itemClick, arg_1_2))

					if arg_1_3.isSelected then
						text.addEffect(var_1_1, {
							glow = {
								color = ui.COLORS.GLOW.WHITE
							},
							color = ui.COLORS.NORMAL.WHITE
						})
					else
						text.addEffect(var_1_1, {
							color = ui.COLORS.NORMAL.RED
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChangePage")
			}
		}
	},
	["cardPanel1.card1"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:onChooseClick()
				end)
			}
		}
	},
	["cardPanel2.card1"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					arg_3_0:onChooseClick()
				end)
			}
		}
	},
	["barPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, -1)
			end)
		}
	},
	["barPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, 1)
			end)
		}
	},
	changeBtn = {
		varname = "changeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["changeBtn.title"] = {
		varname = "btnTxt",
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	priceList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("priceDatas"),
				item = bindHelper.self("priceItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:size()
					local var_6_1 = arg_6_1:multiget("price", "icon", "txt1")

					var_6_1.price:text(mathEasy.getShortNumber(arg_6_3.num))
					text.addEffect(var_6_1.price, {
						color = dataEasy.getNumByKey(arg_6_3.key) >= arg_6_3.num and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.NORMAL.ALERT_ORANGE
					})
					var_6_1.icon:texture(ui.COMMON_ICON[arg_6_3.key])
					adapt.oneLineCenterPos(cc.p(var_6_0.width / 2, var_6_0.height / 2), {
						var_6_1.txt1,
						var_6_1.price,
						var_6_1.icon
					}, cc.p(10, 0))
				end,
				onAfterBuild = function(arg_7_0)
					arg_7_0:setItemAlignCenter()
				end
			}
		}
	}
}

function var_0_3.onCreate(arg_8_0, arg_8_1)
	arg_8_0:enableSchedule()

	local var_8_0 = arg_8_1.fragID
	local var_8_1 = arg_8_1.needNum

	arg_8_0.cb = arg_8_1.cb
	arg_8_0.fragID = var_8_0
	arg_8_0.needNum = var_8_1
	arg_8_0.selectCardDbId = idler.new()
	arg_8_0.costNum = idler.new(0)
	arg_8_0.selectedFragId = idler.new(0)
	arg_8_0.selectEpNum = idler.new(0)

	arg_8_0:initModel()

	local var_8_2 = {
		{
			isSelected = false,
			name = gLanguageCsv.fragChange
		},
		{
			isSelected = false,
			name = gLanguageCsv.cardChange
		}
	}

	arg_8_0.tabIdx = idler.new(1)

	local var_8_3 = csv.zawake.exchange[var_8_0]

	arg_8_0.fragExchangeRate = var_8_3.type == var_0_0.currency and var_8_3.needFrags[1][3] or var_8_3.needSpecialFrags[1][2]
	arg_8_0.cardExchangeRate = var_8_3.cardConvertNum
	arg_8_0.exchangeCsv = var_8_3
	arg_8_0.priceDatas = idlers.newWithMap({})
	arg_8_0.tabDatas = idlers.newWithMap(var_8_2)

	arg_8_0.tabIdx:addListener(function(arg_9_0, arg_9_1, arg_9_2)
		if arg_8_0.tabDatas:atproxy(arg_9_1) then
			arg_8_0.tabDatas:atproxy(arg_9_1).isSelected = false
		end

		if arg_8_0.tabDatas:atproxy(arg_9_0) then
			arg_8_0.tabDatas:atproxy(arg_9_0).isSelected = true
		end
	end)
	idlereasy.any({
		arg_8_0.tabIdx,
		arg_8_0.gold,
		arg_8_0.selectEpNum
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		arg_8_0:updatePrice(arg_10_1 == 2 and 1 or arg_10_3)
	end)
	idlereasy.any({
		arg_8_0.selectCardDbId,
		arg_8_0.tabIdx
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_8_0.cardPanel1:hide()

		if arg_11_2 == 2 then
			var_11_0:show()

			if arg_11_1 then
				local var_11_1 = gGameModel.cards:find(arg_11_1)
				local var_11_2 = var_11_1:read("card_id")
				local var_11_3 = csv.cards[var_11_2]
				local var_11_4 = csv.unit[var_11_3.unitID]
				local var_11_5 = dataEasy.getCfgByKey(var_11_3.fragID).quality
				local var_11_6 = var_11_1:read("skin_id")
				local var_11_7 = dataEasy.getUnitId(var_11_2, var_11_6)

				uiEasy.setIconName("card", var_11_2, {
					space = true,
					node = var_11_0:get("textName1"),
					name = var_11_3.name,
					advance = var_11_3.advance
				})
				bind.extend(arg_8_0, var_11_0:get("card1.icon"), {
					class = "card_icon",
					props = {
						unitId = var_11_7,
						rarity = var_11_4.rarity,
						advance = var_11_1:read("advance"),
						star = var_11_1:read("star"),
						levelProps = {
							data = var_11_1:read("level")
						},
						onNode = function(arg_12_0)
							arg_12_0:setTouchEnabled(false)
						end
					}
				})
			else
				var_11_0:get("textName1"):text(gLanguageCsv.chooseSpriteTips)
			end

			var_11_0:get("card1.icon"):visible(arg_11_1 ~= nil)
			var_11_0:get("card1.imgAdd"):visible(arg_11_1 == nil)

			local var_11_8 = var_8_0
			local var_11_9 = arg_8_0.cardExchangeRate

			bind.extend(arg_8_0, var_11_0:get("card2"), {
				class = "icon_key",
				props = {
					data = {
						key = var_11_8,
						num = var_11_9
					}
				}
			})
			uiEasy.setIconName(var_11_8, var_11_9, {
				node = var_11_0:get("textName2")
			})

			local var_11_10 = csv.zawake.zawake_fragments[var_8_0].quality
			local var_11_11 = ui.COLORS.QUALITY[var_11_10]

			text.addEffect(var_11_0:get("textName2"), {
				color = var_11_11
			})
			arg_8_0.barPanel:hide()
		end

		arg_8_0.needNumText:text(string.format("%s/%s", dataEasy.getNumByKey(arg_8_0.fragID), arg_8_0.needNum))
	end)
	idlereasy.any({
		arg_8_0.selectedFragId,
		arg_8_0.selectEpNum,
		arg_8_0.tabIdx,
		arg_8_0.frags
	}, function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		local var_13_0 = arg_8_0.cardPanel2:hide()

		if arg_13_3 == 1 then
			var_13_0:show()

			local var_13_1 = 0

			if arg_13_1 > 0 and dataEasy.getNumByKey(arg_13_1) > 0 then
				var_13_1 = dataEasy.getNumByKey(arg_13_1)

				local var_13_2 = dataEasy.getCfgByKey(arg_13_1).quality
				local var_13_3 = ui.COLORS.QUALITY[var_13_2]
				local var_13_4 = {
					class = "icon_key",
					props = {
						data = {
							key = arg_13_1,
							num = var_13_1,
							targetNum = arg_8_0.fragExchangeRate * (arg_13_2 == 0 and 1 or arg_13_2)
						},
						onNode = function(arg_14_0)
							arg_14_0:setTouchEnabled(false)
						end
					}
				}

				var_13_0:get("card1.imgAdd"):hide()
				var_13_0:get("textName1"):text(uiEasy.setIconName(arg_13_1))
				bind.extend(arg_8_0, var_13_0:get("card1.icon"), var_13_4)
				text.addEffect(var_13_0:get("textName1"), {
					color = var_13_3
				})
			else
				var_13_0:get("card1.imgAdd"):show()
				var_13_0:get("textName1"):text(gLanguageCsv.selectFragment)
				text.addEffect(var_13_0:get("textName1"), {
					color = ui.COLORS.NORMAL.DEFAULT
				})
			end

			var_13_0:get("card1.icon"):visible(arg_13_1 > 0)

			local var_13_5 = var_8_0
			local var_13_6 = math.max(arg_13_2, 1)

			bind.extend(arg_8_0, var_13_0:get("card2"), {
				class = "icon_key",
				props = {
					data = {
						key = var_13_5,
						num = var_13_6
					}
				}
			})
			uiEasy.setIconName(var_13_5, var_13_6, {
				node = var_13_0:get("textName2")
			})

			local var_13_7 = csv.zawake.zawake_fragments[var_8_0].quality
			local var_13_8 = ui.COLORS.QUALITY[var_13_7]

			text.addEffect(var_13_0:get("textName2"), {
				color = var_13_8
			})

			arg_8_0.maxNum = math.floor(var_13_1 / arg_8_0.fragExchangeRate)

			if not arg_8_0.slider:isHighlighted() then
				local var_13_9 = math.ceil(arg_13_2 / math.floor(var_13_1 / arg_8_0.fragExchangeRate) * 100)

				arg_8_0.slider:setPercent(var_13_9)

				if var_13_1 == 0 then
					arg_8_0.slider:setTouchEnabled(false)
				else
					arg_8_0.slider:setTouchEnabled(true)
				end
			end

			arg_8_0.barPanel:show()
			arg_8_0.needFrags:text("/" .. arg_8_0.maxNum)
			arg_8_0.myFrags:text(arg_13_2)
			adapt.oneLineCenterPos(cc.p(arg_8_0.barPanel:size().width / 2, arg_8_0.myFrags:y()), {
				arg_8_0.myFrags,
				arg_8_0.needFrags
			})
			uiEasy.setBtnShader(arg_8_0.addBtn, nil, var_13_1 >= (arg_13_2 + 1) * arg_8_0.fragExchangeRate and 1 or 2)
			uiEasy.setBtnShader(arg_8_0.subBtn, nil, arg_13_2 > 0 and 1 or 2)
		end

		arg_8_0.needNumText:text(string.format("%s/%s", dataEasy.getNumByKey(arg_8_0.fragID), arg_8_0.needNum))
	end)
	arg_8_0.slider:setPercent(0)
	arg_8_0.slider:addEventListener(function(arg_15_0, arg_15_1)
		if arg_15_1 == ccui.SliderEventType.percentChanged then
			arg_8_0:unScheduleAll()

			local var_15_0 = arg_15_0:getPercent()
			local var_15_1 = math.floor(arg_8_0.maxNum * var_15_0 * 0.01)

			arg_8_0.selectEpNum:set(var_15_1)
		end
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_3.initModel(arg_16_0)
	arg_16_0.cards = gGameModel.role:getIdler("cards")
	arg_16_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_16_0.frags = gGameModel.role:getIdler("frags")
	arg_16_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_3.updatePrice(arg_17_0, arg_17_1)
	arg_17_1 = math.max(arg_17_1, 1)

	local var_17_0 = arg_17_0.tabIdx:read() == 2 and arg_17_0.exchangeCsv.costItemCard or arg_17_0.exchangeCsv.costItemFrag
	local var_17_1 = {}

	arg_17_0.costArr = {}

	for iter_17_0, iter_17_1 in csvMapPairs(var_17_0) do
		arg_17_0.costArr[iter_17_0] = arg_17_1 * iter_17_1

		table.insert(var_17_1, {
			key = iter_17_0,
			num = arg_17_1 * iter_17_1
		})
	end

	arg_17_0.priceDatas:update(var_17_1)
end

function var_0_3.onIncreaseNum(arg_18_0, arg_18_1)
	arg_18_0.selectEpNum:modify(function(arg_19_0)
		return true, cc.clampf(arg_19_0 + arg_18_1, 0, math.max(arg_18_0.maxNum, 0))
	end)
end

function var_0_3.onChangeNum(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_2.name == "click" then
		arg_20_0:unScheduleAll()
		arg_20_0:onIncreaseNum(arg_20_3)
	elseif arg_20_2.name == "began" then
		arg_20_0:schedule(function()
			arg_20_0:onIncreaseNum(arg_20_3)
		end, 0.05, 0, 1)
	elseif arg_20_2.name == "ended" or arg_20_2.name == "cancelled" then
		arg_20_0:unScheduleAll()
	end
end

function var_0_3.onChangePage(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.tabIdx:set(arg_22_2)
end

function var_0_3.onChangeClick(arg_23_0)
	local function var_23_0()
		return
	end

	local var_23_1 = dataEasy.getCfgByKey(arg_23_0.fragID).name
	local var_23_2 = ""
	local var_23_3 = {}

	if arg_23_0.tabIdx:read() == 2 then
		if arg_23_0.selectCardDbId:read() == nil then
			gGameUI:showTip(string.format(gLanguageCsv.chooseSpriteTips))

			return
		end

		function var_23_0()
			arg_23_0.costNum:set(0)
			arg_23_0.selectCardDbId:set(nil)
		end

		var_23_3 = {
			cardID = arg_23_0.selectCardDbId:read()
		}

		local var_23_4 = gGameModel.cards:find(arg_23_0.selectCardDbId:read()):read("card_id")
		local var_23_5 = csv.cards[var_23_4].name

		var_23_2 = string.format(gLanguageCsv.consumeConversionSprite, var_23_5, arg_23_0.cardExchangeRate, var_23_1)
	else
		local var_23_6 = arg_23_0.selectEpNum:read()

		if arg_23_0.selectedFragId:read() == 0 then
			gGameUI:showTip(string.format(gLanguageCsv.selectFragment))

			return
		end

		if var_23_6 == 0 then
			gGameUI:showTip(string.format(gLanguageCsv.pleaseSelectNumber, gLanguageCsv.starSkillExchange))

			return
		end

		function var_23_0()
			arg_23_0.selectEpNum:set(0)
			arg_23_0.slider:setPercent(0)
			arg_23_0.selectedFragId:set(0)
		end

		var_23_3 = {
			fragID = arg_23_0.selectedFragId:read(),
			num = var_23_6
		}

		local var_23_7 = dataEasy.getCfgByKey(arg_23_0.selectedFragId:read()).name
		local var_23_8 = arg_23_0.fragExchangeRate * var_23_6

		var_23_2 = string.format(gLanguageCsv.consumeConversionFigment, var_23_8, var_23_7, var_23_6, var_23_1)
	end

	for iter_23_0, iter_23_1 in pairs(arg_23_0.costArr) do
		if iter_23_1 > dataEasy.getNumByKey(iter_23_0) then
			if iter_23_0 == "gold" then
				uiEasy.showDialog("gold")
			else
				gGameUI:showTip(gLanguageCsv.exchangeItemNotEnough)
			end

			return
		end
	end

	;(function(arg_27_0)
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = var_23_2,
			cb = function()
				arg_23_0:sendExchange(var_23_3, arg_27_0)
			end
		})
	end)(var_23_0)
end

function var_0_3.sendExchange(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_1.cardID
	local var_29_1 = arg_29_1.fragID
	local var_29_2 = arg_29_1.num

	gGameApp:requestServer("/game/card/zawake/exchange", function(arg_30_0)
		gGameUI:showGainDisplay(arg_30_0)
		arg_29_2()
	end, arg_29_0.fragID, var_29_0, var_29_1, var_29_2)
end

function var_0_3.onChooseClick(arg_31_0)
	local var_31_0 = arg_31_0.tabIdx:read()
	local var_31_1 = {
		selectedFragId = arg_31_0.selectedFragId,
		fragID = arg_31_0.fragID
	}
	local var_31_2 = "city.zawake.choose_fragment"

	if var_31_0 == 2 then
		var_31_1 = {
			selectCardDbId = arg_31_0.selectCardDbId,
			fragID = arg_31_0.fragID
		}
		var_31_2 = "city.zawake.choose_card"
	end

	gGameUI:stackUI(var_31_2, nil, nil, var_31_1)
end

function var_0_3.onClose(arg_32_0)
	arg_32_0:addCallbackOnExit(arg_32_0.cb)
	var_0_2.onClose(arg_32_0)
end

return var_0_3
