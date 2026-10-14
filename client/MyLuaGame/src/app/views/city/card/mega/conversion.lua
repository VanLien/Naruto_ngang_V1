local var_0_0 = ui.RARITY_TEXT
local var_0_1 = class("MegaConversionView", Dialog)

local function var_0_2(arg_1_0)
	for iter_1_0, iter_1_1 in orderCsvPairs(csv.card_mega) do
		for iter_1_2, iter_1_3 in csvMapPairs(iter_1_1.costItems) do
			if iter_1_2 == arg_1_0 then
				for iter_1_4, iter_1_5 in ipairs(gGameModel.role:read("cards")) do
					if gGameModel.cards:find(iter_1_5):read("card_id") == gCardsMega[iter_1_0].key then
						return iter_1_0
					end
				end

				return
			end
		end
	end
end

var_0_1.RESOURCE_FILENAME = "card_mega_debris.json"
var_0_1.RESOURCE_BINDING = {
	debrisItem = "debrisItem",
	costPanel = "costPanel",
	title1 = "title1",
	timesPanel = "timesPanel",
	item = "item",
	imgIcon = "imgIcon",
	title2 = "title2",
	sliderPanel = "sliderPanel",
	["sliderPanel.slider"] = "slider",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	spriteBtn = {
		varname = "spriteBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("spriteBtnFunc")
			}
		}
	},
	debrisBtn = {
		varname = "debrisBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("debrisBtnFunc")
			}
		}
	},
	rule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("ruleFunc")
			}
		}
	},
	clickBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("conversionFunc")
			}
		}
	},
	["timesPanel.add"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("addNumFunc")
			}
		}
	},
	["sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, -1)
			end)
		}
	},
	["sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, 1)
			end)
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("costDatas"),
				item = bindHelper.self("item"),
				imgIcon = bindHelper.self("imgIcon"),
				debrisItem = bindHelper.self("debrisItem"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("name", "name2", "icon", "item", "add")

					if itertools.size(arg_4_3) == 0 then
						var_4_0.add:show()
						itertools.invoke({
							var_4_0.name,
							var_4_0.icon,
							var_4_0.item
						}, "hide")
						var_4_0.name2:hide()
						arg_4_1:width(80)
						var_4_0.add:x(40)
					else
						var_4_0.add:hide()
						itertools.invoke({
							var_4_0.name,
							var_4_0.icon,
							var_4_0.item
						}, "show")
						var_4_0.item:get("add"):hide()
						arg_4_1:width(200)

						if arg_4_3.type == "card" then
							if not arg_4_3.selectId then
								var_4_0.item:hide()

								local var_4_1 = arg_4_3.cfg
								local var_4_2 = gLanguageCsv.selectCardFragments .. string.format(gLanguageCsv.selectRarityCardFragments, var_0_0[var_4_1.needCards1[1]])

								for iter_4_0 = 1, math.huge do
									local var_4_3 = var_4_1["needCards" .. iter_4_0]

									if itertools.isempty(var_4_3) then
										break
									end

									if var_4_3[2] ~= -1 then
										local var_4_4 = game.NATURE_TABLE[var_4_3[2]]

										var_4_2 = var_4_2 .. ui.ATTRCOLOR[var_4_4] .. string.format(gLanguageCsv.selectTypeCardFragments, gLanguageCsv[var_4_4]) .. "#C0x5B545B#"
									end
								end

								var_4_0.name:hide()
								var_4_0.name2:hide()

								local var_4_5 = "#C0x5B545B#" .. var_4_2 .. gLanguageCsv.card

								arg_4_1:removeChildByName("descList")
								beauty.textScroll({
									isRich = true,
									size = {
										width = 250,
										height = 180
									},
									strs = var_4_5
								}):xy(var_4_0.name2:x() - var_4_0.name2:width() / 2, var_4_0.name2:y() - var_4_0.name2:height() / 2):addTo(arg_4_1, 5, "descList")
							else
								var_4_0.icon:hide()

								local var_4_6 = gGameModel.cards:find(arg_4_3.selectId):read("card_id", "name", "level", "star", "advance")
								local var_4_7 = csv.cards[var_4_6.card_id]
								local var_4_8 = csv.unit[var_4_7.unitID]

								bind.extend(arg_4_0, var_4_0.item, {
									class = "card_icon",
									props = {
										cardId = var_4_6.card_id,
										advance = var_4_6.advance,
										star = var_4_6.star,
										rarity = var_4_8.rarity,
										levelProps = {
											data = var_4_6.level
										},
										onNode = function(arg_5_0)
											arg_5_0:setTouchEnabled(false)
										end
									}
								})
								uiEasy.setIconName("card", var_4_6.card_id, {
									node = var_4_0.name
								})
								var_4_0.name2:hide()
							end
						elseif arg_4_3.type == "frag" then
							local var_4_9
							local var_4_10

							if not arg_4_3.selectId then
								var_4_0.item:hide()

								local var_4_11 = arg_4_3.cfg
								local var_4_12 = gLanguageCsv.selectCardFragments .. string.format(gLanguageCsv.selectRarityCardFragments, var_0_0[var_4_11.needFrags1[1] - 2])

								for iter_4_1 = 1, math.huge do
									local var_4_13 = var_4_11["needFrags" .. iter_4_1]

									if itertools.isempty(var_4_13) then
										break
									end

									if var_4_13[2] ~= -1 then
										local var_4_14 = game.NATURE_TABLE[var_4_13[2]]

										var_4_12 = var_4_12 .. ui.ATTRCOLOR[var_4_14] .. string.format(gLanguageCsv.selectTypeCardFragments, gLanguageCsv[var_4_14]) .. "#C0x5B545B#"
									end
								end

								var_4_0.name:hide()
								var_4_0.name2:hide()

								local var_4_15 = "#C0x5B545B#" .. var_4_12 .. gLanguageCsv.fragment

								arg_4_1:removeChildByName("descList")
								beauty.textScroll({
									isRich = true,
									size = {
										width = 250,
										height = 180
									},
									strs = var_4_15
								}):xy(var_4_0.name2:x() - var_4_0.name2:width() / 2, var_4_0.name2:y() - var_4_0.name2:height() / 2):addTo(arg_4_1, 5, "descList")
								var_4_0.item:get("add"):show()

								local var_4_16 = arg_4_3.num
							else
								var_4_0.icon:hide()
								var_4_0.name2:hide()
								uiEasy.setIconName(arg_4_3.selectId, arg_4_3.num, {
									node = var_4_0.name,
									width = arg_4_1:width()
								})

								local var_4_17 = dataEasy.getNumByKey(arg_4_3.selectId)
								local var_4_18 = arg_4_3.num * arg_4_3.targetNum

								var_4_0.item:get("add"):visible(var_4_17 < var_4_18)
								bind.extend(arg_4_0, var_4_0.item, {
									class = "icon_key",
									props = {
										grayState = var_4_17 < var_4_18 and 1 or 0,
										data = {
											key = arg_4_3.selectId,
											num = var_4_17,
											targetNum = var_4_18
										},
										onNode = function(arg_6_0)
											arg_6_0:setTouchEnabled(false)
										end
									}
								})
							end
						else
							var_4_0.icon:hide()

							local var_4_19 = dataEasy.getNumByKey(arg_4_3.key)

							if var_4_19 < arg_4_3.num then
								var_4_0.item:get("add"):show()
							end

							bind.extend(arg_4_0, var_4_0.item, {
								class = "icon_key",
								props = {
									grayState = var_4_19 < arg_4_3.num and 1 or 0,
									data = {
										key = arg_4_3.key,
										num = var_4_19,
										targetNum = arg_4_3.num * (arg_4_3.targetNum or 1)
									},
									onNode = function(arg_7_0)
										arg_7_0:setTouchEnabled(false)
									end
								}
							})
							var_4_0.name2:hide()
							uiEasy.setIconName(arg_4_3.key, arg_4_3.num, {
								node = var_4_0.name
							})
						end

						bind.touch(arg_4_0, var_4_0.icon, {
							methods = {
								ended = function()
									arg_4_0.chooseCard(arg_4_2, arg_4_3)
								end
							}
						})
						bind.touch(arg_4_0, var_4_0.item, {
							methods = {
								ended = function()
									arg_4_0.chooseCard(arg_4_2, arg_4_3)
								end
							}
						})
					end
				end,
				onAfterBuild = function(arg_10_0)
					local var_10_0 = arg_10_0:getInnerItemSize().width
					local var_10_1 = 80
					local var_10_2 = 200
					local var_10_3 = 100
					local var_10_4 = var_10_0 + var_10_1 + var_10_2 + var_10_3 * 2

					arg_10_0:x(display.sizeInView.width / 2 - var_10_4 / 2)
					arg_10_0.imgIcon:x(arg_10_0:x() + var_10_0 + var_10_3 + var_10_1 / 2)
					arg_10_0.debrisItem:x(arg_10_0:x() + var_10_0 + var_10_1 + var_10_3 * 2 + var_10_2 / 2)
				end
			},
			handlers = {
				chooseCard = bindHelper.self("chooseCard")
			}
		}
	}
}

function var_0_1.onCreate(arg_11_0, arg_11_1)
	arg_11_0.debrisItem:y(arg_11_0.debrisItem:y() + 18)

	arg_11_0.cardConvertFlag = true
	arg_11_0.data = arg_11_1

	arg_11_0:initModel()
	arg_11_0:enableSchedule()

	arg_11_0.cardConvertCfg = csv.card_mega_convert[arg_11_1.id]

	local var_11_0 = gLanguageCsv.yaoStone
	local var_11_1 = gVipCsv[arg_11_0.vipLevel]

	if arg_11_0.cardConvertCfg.type == 2 then
		arg_11_0.ruleContent = {
			97001,
			97010
		}
		var_11_0 = gLanguageCsv.superStone
		arg_11_0.ruleTitle = gLanguageCsv.superStoneRule
		arg_11_0.hadMega = var_0_2(arg_11_1.id)
	else
		arg_11_0.ruleContent = {
			96001,
			96010
		}
		arg_11_0.ruleTitle = gLanguageCsv.yaoStoneRule
	end

	arg_11_0.title1:text(var_11_0)
	arg_11_0.title2:x(arg_11_0.title1:x() + arg_11_0.title1:width())

	local var_11_2 = arg_11_0.cardConvertCfg.type ~= 1 and gCommonConfigCsv.megaConvertTimes or gCommonConfigCsv.megaCommonConvertTimes

	arg_11_0.timesPanel:get("tip"):text(string.format(gLanguageCsv.megaConvertTimesTip, var_11_2))
	idlereasy.any({
		arg_11_0.megaConvertTimes,
		arg_11_0.megaConvertBuyTimes
	}, function(arg_12_0, arg_12_1, arg_12_2)
		arg_11_0.conversionNum = arg_12_1 and arg_12_1[arg_11_1.id] or 0

		arg_11_0.timesPanel:get("num1"):text(arg_11_0.conversionNum)

		arg_11_0.conversionNumMax = arg_11_0.cardConvertCfg.type ~= 1 and gVipCsv[arg_11_0.vipLevel].megaItemMaxTimes or gVipCsv[arg_11_0.vipLevel].megaCommonItemMaxTimes

		arg_11_0.timesPanel:get("num2"):text("/" .. arg_11_0.conversionNumMax)
		adapt.oneLinePos(arg_11_0.timesPanel:get("num2"), {
			arg_11_0.timesPanel:get("num1"),
			arg_11_0.timesPanel:get("txt1")
		}, cc.p(0, 0), "right")
	end)

	arg_11_0.selectedData = {
		key = "card",
		csvId = arg_11_1.id
	}
	arg_11_0.costDatas = idlers.newWithMap({})
	arg_11_0.maxNum = 0

	arg_11_0.debrisBtn:get("txt2"):hide()
	arg_11_0.spriteBtn:get("txt2"):hide()

	local var_11_3 = arg_11_0.debrisBtn:x()
	local var_11_4 = arg_11_0.spriteBtn:x()

	arg_11_0.debrisBtn:x(var_11_4)
	arg_11_0.spriteBtn:x(var_11_3)

	arg_11_0.sliderNum = idler.new(0)

	idlereasy.when(arg_11_0.sliderNum, function(arg_13_0, arg_13_1)
		arg_11_0.sliderPanel:get("txt1"):text(arg_13_1)
		arg_11_0:stateUpdate()

		if not arg_11_0.slider:isHighlighted() then
			local var_13_0 = arg_11_0.maxNum == 0 and 0 or arg_13_1 / arg_11_0.maxNum

			arg_11_0.slider:setPercent(var_13_0 * 100)
		end
	end)
	arg_11_0.slider:addEventListener(function(arg_14_0, arg_14_1)
		arg_11_0:unScheduleAll()

		local var_14_0 = arg_14_0:getPercent()
		local var_14_1 = cc.clampf(math.ceil(arg_11_0.maxNum * var_14_0 * 0.01), 0, arg_11_0.maxNum)

		arg_11_0.sliderNum:set(var_14_1)
	end)
	idlereasy.when(arg_11_0.gold, functools.partial(arg_11_0.costGoldUpdate, arg_11_0))
	idlereasy.any({
		arg_11_0.cards,
		arg_11_0.frags,
		arg_11_0.items
	}, functools.partial(arg_11_0.stateChange, arg_11_0))
	arg_11_0:debrisBtnFunc()
	Dialog.onCreate(arg_11_0, {
		blackType = 2
	})
end

function var_0_1.initModel(arg_15_0)
	arg_15_0.vipLevel = gGameModel.role:read("vip_level")
	arg_15_0.megaConvertTimes = gGameModel.role:getIdler("mega_convert_times")
	arg_15_0.megaConvertBuyTimes = gGameModel.daily_record:getIdler("mega_convert_buy_times")
	arg_15_0.cards = gGameModel.role:getIdler("cards")
	arg_15_0.items = gGameModel.role:getIdler("items")
	arg_15_0.frags = gGameModel.role:getIdler("frags")
	arg_15_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_1.getCostGold(arg_16_0)
	local var_16_0

	if arg_16_0.cardConvertFlag then
		var_16_0 = arg_16_0.cardConvertCfg.costItemCard.gold or 0
	else
		var_16_0 = (arg_16_0.cardConvertCfg.costItemFrag.gold or 0) * math.max(arg_16_0.sliderNum:read(), 1)
	end

	return var_16_0
end

function var_0_1.costGoldUpdate(arg_17_0)
	local var_17_0 = arg_17_0:getCostGold()

	if var_17_0 == 0 then
		arg_17_0.costPanel:hide()
	else
		arg_17_0.costPanel:show()
		arg_17_0.costPanel:get("num"):text(var_17_0)

		local var_17_1 = gGameModel.role:read("gold")

		text.addEffect(arg_17_0.costPanel:get("num"), {
			color = var_17_0 <= var_17_1 and ui.COLORS.QUALITY_OUTLINE[1] or ui.COLORS.NORMAL.ALERT_ORANGE
		})
		adapt.oneLineCenterPos(cc.p(260, 40), {
			arg_17_0.costPanel:get("txt1"),
			arg_17_0.costPanel:get("num"),
			arg_17_0.costPanel:get("icon")
		}, cc.p(8, 0))
	end
end

function var_0_1.stateChange(arg_18_0)
	arg_18_0:stateUpdate()
	arg_18_0.sliderNum:modify(function(arg_19_0)
		return true, math.min(arg_19_0, arg_18_0.maxNum)
	end, true)
end

function var_0_1.stateUpdate(arg_20_0)
	arg_20_0.debrisBtn:texture(arg_20_0.cardConvertFlag and "common/btn/btn_nomal_3.png" or "common/btn/btn_nomal_2.png")
	arg_20_0.spriteBtn:texture(arg_20_0.cardConvertFlag and "common/btn/btn_nomal_2.png" or "common/btn/btn_nomal_3.png")
	arg_20_0.debrisBtn:get("txt1"):visible(arg_20_0.cardConvertFlag)
	arg_20_0.debrisBtn:get("txt2"):visible(not arg_20_0.cardConvertFlag)
	arg_20_0.spriteBtn:get("txt1"):visible(arg_20_0.cardConvertFlag)
	arg_20_0.spriteBtn:get("txt2"):visible(not arg_20_0.cardConvertFlag)
	arg_20_0:costGoldUpdate()

	local var_20_0 = arg_20_0.sliderNum:read()
	local var_20_1 = 1
	local var_20_2 = arg_20_0.conversionNum
	local var_20_3 = {}

	if arg_20_0.cardConvertFlag then
		arg_20_0.sliderPanel:hide()

		var_20_1 = arg_20_0.cardConvertCfg.cardConvertNum
		var_20_2 = math.min(math.floor(var_20_2 / var_20_1), 1)

		for iter_20_0, iter_20_1 in csvMapPairs(arg_20_0.cardConvertCfg.costItemCard) do
			if iter_20_0 ~= "gold" then
				local var_20_4 = dataEasy.getNumByKey(iter_20_0)

				var_20_2 = math.min(var_20_2, math.floor(var_20_4 / iter_20_1))

				table.insert(var_20_3, {
					key = iter_20_0,
					num = iter_20_1
				})
			end
		end

		if arg_20_0.cardConvertCfg.needCards1[1] then
			var_20_2 = not arg_20_0.selectedData.selectId and 0 or math.min(var_20_2, 1)

			table.insert(var_20_3, 1, {
				type = "card",
				cfg = arg_20_0.cardConvertCfg,
				selectId = arg_20_0.selectedData.selectId
			})
		end
	else
		arg_20_0.sliderPanel:show()

		var_20_1 = math.max(var_20_0, 1)

		for iter_20_2, iter_20_3 in csvMapPairs(arg_20_0.cardConvertCfg.costItemFrag) do
			if iter_20_2 ~= "gold" then
				local var_20_5 = dataEasy.getNumByKey(iter_20_2)

				var_20_2 = math.min(var_20_2, math.floor(var_20_5 / iter_20_3))

				table.insert(var_20_3, {
					key = iter_20_2,
					num = iter_20_3,
					targetNum = var_20_1
				})
			end
		end

		if arg_20_0.cardConvertCfg.needFrags1[1] then
			local var_20_6 = arg_20_0.cardConvertCfg.needFrags1[3]

			if not arg_20_0.selectedData.selectId then
				var_20_2 = 0
			else
				local var_20_7 = dataEasy.getNumByKey(arg_20_0.selectedData.selectId)

				var_20_2 = math.min(var_20_2, math.floor(var_20_7 / var_20_6))
			end

			arg_20_0.fragExchangeRate = var_20_6

			table.insert(var_20_3, 1, {
				type = "frag",
				cfg = arg_20_0.cardConvertCfg,
				num = var_20_6,
				selectId = arg_20_0.selectedData.selectId,
				targetNum = var_20_1
			})
		end
	end

	arg_20_0.maxNum = var_20_2

	arg_20_0.sliderPanel:get("txt2"):text("/" .. var_20_2)
	uiEasy.setBtnShader(arg_20_0.sliderSubBtn, false, var_20_0 >= 1 and 1 or 2)
	uiEasy.setBtnShader(arg_20_0.sliderAddBtn, false, var_20_0 < arg_20_0.maxNum and 1 or 2)

	if var_20_0 < 1 or var_20_0 >= arg_20_0.maxNum then
		arg_20_0:unScheduleAll()
	end

	for iter_20_4 = #var_20_3, 2, -1 do
		table.insert(var_20_3, iter_20_4, {})
	end

	arg_20_0.costDatas:update(var_20_3)

	local var_20_8 = dataEasy.getNumByKey(arg_20_0.data.id)

	uiEasy.setIconName(arg_20_0.data.id, nil, {
		node = arg_20_0.debrisItem:get("name")
	})
	arg_20_0.debrisItem:get("title.num"):text(var_20_8)
	arg_20_0.debrisItem:get("title.txt2"):text("/" .. arg_20_0.data.num)
	text.addEffect(arg_20_0.debrisItem:get("title.num"), {
		color = var_20_8 >= arg_20_0.data.num and ui.COLORS.QUALITY_OUTLINE[1] or ui.COLORS.NORMAL.ALERT_ORANGE
	})
	adapt.oneLineCenterPos(cc.p(200, 30), {
		arg_20_0.debrisItem:get("title.txt1"),
		arg_20_0.debrisItem:get("title.num"),
		arg_20_0.debrisItem:get("title.txt2")
	}, cc.p(5, 0))
	bind.extend(arg_20_0, arg_20_0.debrisItem:get("item"), {
		class = "icon_key",
		props = {
			data = {
				key = arg_20_0.data.id,
				num = var_20_1
			}
		}
	})
end

function var_0_1.chooseCard(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_3.type == "card" then
		gGameUI:stackUI("city.card.mega.choose_card", nil, {
			dialog = true
		}, arg_21_0.selectedData, arg_21_0:createHandler("stateChange"))
	elseif arg_21_3.type == "frag" then
		gGameUI:stackUI("city.card.mega.fragment_select", nil, {
			dialog = true
		}, arg_21_0.selectedData, arg_21_0:createHandler("stateChange"))
	else
		gGameUI:stackUI("common.gain_way", nil, {
			dialog = true
		}, arg_21_3.key, nil, arg_21_3.num)
	end
end

function var_0_1.onIncreaseNum(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1 > 0 and 1 or 0
	local var_22_1 = cc.clampf(arg_22_0.sliderNum:read() + arg_22_1, var_22_0, math.max(arg_22_0.maxNum, 1))

	arg_22_0.sliderNum:set(var_22_1, true)
end

function var_0_1.onChangeNum(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_0.cardConvertFlag then
		return
	end

	if arg_23_2.name == "click" then
		arg_23_0:unScheduleAll()
		arg_23_0:onIncreaseNum(arg_23_3)
	elseif arg_23_2.name == "began" then
		arg_23_0:schedule(function()
			arg_23_0:onIncreaseNum(arg_23_3)
		end, 0.05, 0, 1)
	elseif arg_23_2.name == "ended" or arg_23_2.name == "cancelled" then
		arg_23_0:unScheduleAll()
	end
end

function var_0_1.spriteBtnFunc(arg_25_0)
	if not arg_25_0.cardConvertFlag then
		arg_25_0.selectedData.selectId = nil
		arg_25_0.cardConvertFlag = true

		arg_25_0.sliderNum:set(0, true)
	end
end

function var_0_1.debrisBtnFunc(arg_26_0)
	if arg_26_0.cardConvertFlag then
		arg_26_0.selectedData.selectId = nil
		arg_26_0.cardConvertFlag = false

		arg_26_0.sliderNum:set(0, true)
	end
end

function var_0_1.addNumFunc(arg_27_0)
	if arg_27_0.conversionNum >= arg_27_0.conversionNumMax then
		gGameUI:showTip(gLanguageCsv.megaConvertTimesLimit)

		return
	end

	gGameUI:stackUI("common.buy_number", nil, nil, {
		id = arg_27_0.data.id,
		itemType = arg_27_0.cardConvertCfg.type
	}, arg_27_0:createHandler("stateChange"))
end

function var_0_1.conversionFunc(arg_28_0)
	local var_28_0 = arg_28_0.selectedData.selectId

	if not var_28_0 then
		gGameUI:showTip(gLanguageCsv.materialsNotEnoughMega)

		return
	end

	local var_28_1 = arg_28_0.sliderNum:read()

	if arg_28_0.cardConvertFlag then
		var_28_1 = arg_28_0.cardConvertCfg.cardConvertNum
	end

	if arg_28_0.conversionNum - var_28_1 < 0 then
		gGameUI:showTip(gLanguageCsv.conversionInsufficient)

		return
	end

	if arg_28_0.cardConvertFlag and arg_28_0.maxNum <= 0 then
		gGameUI:showTip(gLanguageCsv.materialsNotEnoughMega)

		return
	end

	if not arg_28_0.cardConvertFlag and var_28_1 <= 0 then
		gGameUI:showTip(gLanguageCsv.selectConversionNumber)

		return
	end

	if arg_28_0:getCostGold() > gGameModel.role:read("gold") then
		gGameUI:showTip(gLanguageCsv.conversionNotGold)

		return
	end

	local var_28_2
	local var_28_3
	local var_28_4 = {}
	local var_28_8

	if arg_28_0.cardConvertFlag then
		local var_28_5 = gGameModel.cards:find(var_28_0):read("card_id")
		local var_28_6 = csv.cards[var_28_5].name
		local var_28_7 = csv.items[arg_28_0.data.id].name

		var_28_2 = string.format(gLanguageCsv.consumeConversionSprite, var_28_6, var_28_1, var_28_7)
		var_28_4 = {
			arg_28_0.data.id,
			var_28_0
		}
		var_28_8 = "/game/develop/mega/convert/card"
	else
		local var_28_9 = ""

		if dataEasy.isFragment(var_28_0) then
			var_28_9 = csv.fragments[var_28_0].name
		elseif dataEasy.isZawakeFragment(var_28_0) then
			var_28_9 = csv.zawake.zawake_fragments[var_28_0].name
		end

		local var_28_10 = csv.items[arg_28_0.data.id].name
		local var_28_11 = (arg_28_0.fragExchangeRate or 0) * var_28_1

		var_28_2 = string.format(gLanguageCsv.consumeConversionFigment, var_28_11, var_28_9, var_28_1, var_28_10)
		var_28_4 = {
			arg_28_0.data.id,
			var_28_1,
			var_28_0
		}
		var_28_8 = "/game/develop/mega/convert/frag"
	end

	local function var_28_12()
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = var_28_2,
			cb = function()
				arg_28_0.selectedData.selectId = nil

				gGameApp:requestServer(var_28_8, function(arg_31_0)
					gGameUI:showGainDisplay({
						[arg_28_0.data.id] = var_28_1
					})
					arg_28_0:stateChange()
				end, unpack(var_28_4))
			end
		})
	end

	local var_28_13 = userDefault.getForeverLocalKey("hadMegaTip", {})
	local var_28_14 = dataEasy.getNumByKey(arg_28_0.data.id)

	if arg_28_0.hadMega and not var_28_13[arg_28_0.hadMega] then
		userDefault.setForeverLocalKey("hadMegaTip", {
			[arg_28_0.hadMega] = true
		})
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = gLanguageCsv.megaConvertHadMega,
			cb = var_28_12
		})
	elseif arg_28_0.cardConvertCfg.type == 2 and var_28_14 <= arg_28_0.data.num and var_28_14 + var_28_1 > arg_28_0.data.num then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = gLanguageCsv.megaConvertExceedLimit,
			cb = var_28_12
		})
	else
		var_28_12()
	end
end

function var_0_1.ruleFunc(arg_32_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_32_0:createHandler("getRuleContext"), {
		width = 1300
	})
end

function var_0_1.getRuleContext(arg_33_0, arg_33_1)
	local var_33_0 = adaptContext

	return {
		var_33_0.clone(arg_33_1.title, function(arg_34_0)
			arg_34_0:get("text"):text(arg_33_0.ruleTitle)
		end),
		var_33_0.noteText(unpack(arg_33_0.ruleContent))
	}
end

return var_0_1
