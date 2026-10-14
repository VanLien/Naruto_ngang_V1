local var_0_0 = class("PropertySwapView", Dialog)
local var_0_1 = {
	NVALUE = 2,
	NATURE = 1,
	EFFORTVALUE = 3,
	FEEL = 4
}

var_0_0.SWAP_TYPE = var_0_1

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1:multiget("name", "icon", "num", "bar", "arrow")
	local var_1_1, var_1_2 = dataEasy.getEffortValueAttrData(game.ATTRDEF_ENUM_TABLE[arg_1_3.attr])

	var_1_0.name:text(var_1_1)
	var_1_0.icon:texture(var_1_2)

	if arg_1_3.currVal then
		var_1_0.num:text(arg_1_3.currVal .. "/" .. arg_1_3.maxVal)

		local var_1_3 = math.min(arg_1_3.currVal / arg_1_3.maxVal * 100, 100)

		var_1_0.bar:percent(var_1_3)

		if arg_1_3.rightVal then
			var_1_0.arrow:texture(arg_1_3.rightVal > arg_1_3.currVal and "common/icon/logo_arrow_green.png" or "common/icon/logo_arrow_red.png")
			var_1_0.arrow:visible(arg_1_3.rightVal ~= arg_1_3.currVal)
		else
			var_1_0.arrow:hide()
		end

		adapt.oneLinePos(var_1_0.num, var_1_0.arrow, cc.p(10, 0))

		if matchLanguage({
			"kr"
		}) then
			adapt.oneLinePos(var_1_0.bar, var_1_0.num, cc.p(5, 0))
			adapt.setTextScaleWithWidth(var_1_0.name, nil, 100)
			adapt.oneLinePos(var_1_0.num, var_1_0.arrow, cc.p(5, 0))
		end
	end
end

var_0_0.RESOURCE_FILENAME = "card_property_swap_view.json"
var_0_0.RESOURCE_BINDING = {
	["centerEffortValue.rightPanel.txt"] = "rightEffortValueTxt",
	["centerEffortValue.leftPanel.num"] = "leftEffortValueNum",
	["centerNvalue.rightPanel.num"] = "rightNValueNum",
	centerFeelValue = "centerFeelValue",
	["btnAddDouble.text"] = "btnAddText",
	["centerEffortValue.rightPanel.num"] = "rightEffortValueNum",
	centerCharacter = "centerCharacter",
	["centerCharacter.rightPanel"] = "rightCharacter",
	["centerEffortValue.itemAttr"] = "itemAttr",
	["centerFeelValue.leftPanel.lvTxt"] = "leftFeelLv",
	["centerEffortValue.rightPanel.txt1"] = "rightEffortValueTxt1",
	centerEffortValue = "centerEffortValue",
	leftItem = "leftItem",
	["rightPanel.txt2"] = "rightPanelTxt",
	["centerEffortValue.rightPanel.num1"] = "rightEffortValueNum1",
	btnAddDouble = "btnAddDouble",
	["centerCharacter.leftPanel"] = "leftCharacter",
	["centerFeelValue.leftPanel.bar"] = "leftFeelBar",
	["centerFeelValue.leftPanel.txt3"] = "leftFeelCurTxt",
	leftPos = "leftPos",
	["centerFeelValue.rightPanel.lvTxt"] = "rightFeelLv",
	centerNvalue = "centerNvalue",
	["centerFeelValue.rightPanel.txt3"] = "rightFeelCurTxt",
	["centerFeelValue.rightPanel.bar"] = "rightFeelBar",
	["centerNvalue.leftPanel.pos"] = "leftNValuePos",
	["costPanel.cost"] = "cost",
	["centerFeelValue.rightPanel.txt2"] = "rightFeelMaxTxt",
	["leftPos.name"] = "leftName",
	costPanel = "costPanel",
	["costPanel.txt"] = "costTxt",
	["centerNvalue.leftPanel"] = "leftNValue",
	["centerNvalue.rightPanel.pos"] = "rightNValuePos",
	["centerEffortValue.leftPanel.num1"] = "leftEffortValueNum1",
	["centerNvalue.leftPanel.num"] = "leftNValueNum",
	txt = "txt",
	["centerEffortValue.leftPanel.arrow"] = "effortAdvanceArrow",
	["costPanel.icon"] = "costIcon",
	["centerFeelValue.leftPanel.txt2"] = "leftFeelMaxTxt",
	rightPanel = "rightPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	leftList = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 5,
				data = bindHelper.self("leftData"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()

						var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()

						var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-10)
					end

					local var_2_3 = var_2_2:getSize().height

					adapt.setAutoText(var_2_2:get("txt"), arg_2_3.name, var_2_3)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftButtonClick")
			}
		}
	},
	btnAddSingle = {
		varname = "btnAddSingle",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSelect")
			}
		}
	},
	["btnAddDouble.btnAddSprite"] = {
		varname = "btnAddSprite",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSelect")
			}
		}
	},
	["btnAddDouble.btnAddItem"] = {
		varname = "btnAddItem",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSelectItem")
			}
		}
	},
	btnExchange = {
		varname = "btnExchange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onExchange")
			}
		}
	},
	["btnExchange.txt"] = {
		varname = "btnExchangeText",
		binds = {
			{
				event = "effect",
				data = {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					}
				}
			}
		}
	},
	["centerEffortValue.rightPanel.list"] = {
		varname = "rightEffortValueList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 6,
				data = bindHelper.self("rightEffortValue"),
				item = bindHelper.self("itemAttr"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					var_0_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				end
			}
		}
	},
	["centerEffortValue.leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 6,
				data = bindHelper.self("leftEffortValue"),
				item = bindHelper.self("itemAttr"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					var_0_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				end
			}
		}
	},
	["centerFeelValue.handbookPanel"] = {
		varname = "handbookPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onItemClick")
			}
		}
	},
	["centerFeelValue.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnInfo")
			}
		}
	}
}

function var_0_0.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_2 = arg_5_2 or gGameModel.role:read("cards")[1]
	arg_5_0.cardFeels = gGameModel.role:getIdler("card_feels")
	arg_5_0.rmb = gGameModel.role:getIdler("rmb")
	arg_5_0.selectDbId = arg_5_2
	arg_5_0.leftCard = gGameModel.cards:find(arg_5_2)
	arg_5_0.rightEffortAdvance = idler.new(0)

	local var_5_0 = arg_5_0.leftCard:read("card_id", "skin_id", "level", "star", "advance", "locked", "name")

	arg_5_0.sprOrItemIds = idlertable.new({
		{
			0,
			0
		},
		{
			0,
			0
		},
		{
			0,
			0
		},
		{
			0,
			0
		}
	})

	local var_5_1 = csv.cards[var_5_0.card_id]
	local var_5_2 = csv.unit[var_5_1.unitID]

	arg_5_0.cardMarkID = var_5_1.cardMarkID
	arg_5_0.selectCardAdvance = idler.new()
	arg_5_0.selectCardStar = idler.new()
	arg_5_0.selectCardRarity = idler.new()
	arg_5_0.selectCardLevel = idler.new()
	arg_5_0.selectUnitId = idler.new()

	arg_5_0:initCfg()
	bind.extend(arg_5_0, arg_5_0.leftPos, {
		class = "card_icon",
		props = {
			unitId = arg_5_0.selectUnitId,
			advance = arg_5_0.selectCardAdvance,
			star = arg_5_0.selectCardStar,
			rarity = arg_5_0.selectCardRarity,
			levelProps = {
				data = arg_5_0.selectCardLevel
			},
			params = {
				starScale = 0.85,
				starInterval = 12.5
			}
		}
	})

	local var_5_3 = {
		{
			name = gLanguageCsv.natureSwap,
			desc = gLanguageCsv.nature,
			view = arg_5_0.centerCharacter,
			cost = gCommonConfigCsv.characterSwapCostRmb
		},
		{
			name = gLanguageCsv.nvalueSwap,
			desc = gLanguageCsv.nvalue,
			view = arg_5_0.centerNvalue,
			cost = gCommonConfigCsv.nvalueSwapCostRmb
		},
		{
			name = gLanguageCsv.effortvalueSwap,
			desc = gLanguageCsv.effortvalue,
			view = arg_5_0.centerEffortValue,
			cost = gCommonConfigCsv.effortSwapCostRmb
		},
		{
			name = gLanguageCsv.feelValueSwap,
			desc = gLanguageCsv.feelValue,
			view = arg_5_0.centerFeelValue,
			cost = gCommonConfigCsv.feelSwapCostRmb
		}
	}

	arg_5_0.leftData = idlers.newWithMap(var_5_3)
	arg_5_1 = string.upper(arg_5_1 or "NATURE")
	arg_5_0.showTab = idler.new(var_0_1[arg_5_1])

	arg_5_0.showTab:addListener(function(arg_6_0, arg_6_1)
		local var_6_0 = arg_5_0.leftData:atproxy(arg_6_1)
		local var_6_1 = arg_5_0.leftData:atproxy(arg_6_0)

		var_6_0.select = false

		var_6_0.view:hide()
		var_6_1.view:show()

		var_6_1.select = true

		local var_6_2 = arg_6_0 == var_0_1.NATURE

		arg_5_0.btnAddSingle:visible(not var_6_2)
		arg_5_0.btnAddDouble:visible(var_6_2)

		if var_6_2 then
			local var_6_3 = arg_5_0:checkCharacterItem()
			local var_6_4 = arg_5_0.centerCharacter:get("nameItem")
			local var_6_5 = arg_5_0.centerCharacter:get("name")
			local var_6_6 = arg_5_0.centerCharacter:get("rightPos")

			arg_5_0.btnAddItem:visible(var_6_3)
			arg_5_0.btnAddText:visible(var_6_3)
			var_6_4:visible(var_6_3)

			if not arg_5_0.itemPos then
				local var_6_7 = arg_5_0.btnAddSprite:x()
				local var_6_8 = arg_5_0.btnAddItem:x()
				local var_6_9 = var_6_5:x()
				local var_6_10 = var_6_4:x()
				local var_6_11 = {
					btnPos = {
						var_6_7,
						math.floor((var_6_7 + var_6_8) / 2 + 1.5)
					},
					textPos = {
						var_6_9,
						math.floor((var_6_9 + var_6_10) / 2 + 0.5)
					}
				}

				arg_5_0.itemPos = var_6_11
			end

			local var_6_12 = arg_5_0.itemPos.btnPos
			local var_6_13 = arg_5_0.itemPos.textPos
			local var_6_14 = var_6_3 and 1 or 2

			arg_5_0.btnAddSprite:x(var_6_12[var_6_14])
			var_6_5:x(var_6_13[var_6_14])
			var_6_6:x(var_6_13[var_6_14])
			arg_5_0.rightPanelTxt:text(var_6_3 and gLanguageCsv.chooseSprOrItem or gLanguageCsv.chooseSpr)
		else
			arg_5_0.rightPanelTxt:text(gLanguageCsv.chooseSpr)
		end

		arg_5_0.cost:text(var_6_1.cost)
		idlereasy.when(arg_5_0.rmb, function(arg_7_0, arg_7_1)
			arg_5_0.cost:setTextColor(arg_7_1 >= var_6_1.cost and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.NORMAL.RED)
		end):anonyOnly(arg_5_0, "rmb")
		adapt.oneLineCenterPos(cc.p(arg_5_0.costPanel:width() / 2, arg_5_0.costPanel:height() / 2), {
			arg_5_0.costTxt,
			arg_5_0.cost,
			arg_5_0.costIcon
		}, cc.p(10, 0))

		if arg_6_0 ~= var_0_1.FEEL then
			arg_5_0.txt:text(string.format(gLanguageCsv.swapCard, var_6_1.desc))
		else
			arg_5_0.txt:text(gLanguageCsv.swapFeel)
		end

		local var_6_15 = arg_6_0 == var_0_1.FEEL
		local var_6_16
		local var_6_17

		if var_6_15 then
			arg_5_0.selectCardAdvance:set(nil)
			arg_5_0.selectCardStar:set(nil)
			arg_5_0.selectCardRarity:set(var_5_2.rarity)
			arg_5_0.selectCardLevel:set(nil)
			arg_5_0.selectUnitId:set(var_5_1.unitID)
		else
			arg_5_0.selectCardAdvance:set(var_5_0.advance)
			arg_5_0.selectCardStar:set(var_5_0.star)
			arg_5_0.selectCardRarity:set(var_5_2.rarity)
			arg_5_0.selectCardLevel:set(var_5_0.level)

			local var_6_18 = dataEasy.getUnitId(var_5_0.card_id, var_5_0.skin_id)

			arg_5_0.selectUnitId:set(var_6_18)

			var_6_17 = var_5_0.name
			var_6_16 = var_5_0.advance
		end

		uiEasy.setIconName("card", var_5_0.card_id, {
			space = true,
			node = arg_5_0.leftName,
			name = var_6_17,
			advance = var_6_16
		})
	end)
	idlereasy.any({
		arg_5_0.leftCard:getIdler("effort_values"),
		arg_5_0.leftCard:getIdler("star"),
		arg_5_0.leftCard:getIdler("level"),
		arg_5_0.rightEffortAdvance
	}, function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		local var_8_0 = {}
		local var_8_1 = 0
		local var_8_2 = arg_5_0.leftCard:read("effort_advance") or 1

		for iter_8_0, iter_8_1 in orderCsvPairs(arg_5_0.effortCfg) do
			local var_8_3 = game.ATTRDEF_TABLE[iter_8_1.attrType]
			local var_8_4, var_8_5 = dataEasy.getCardEffortMax(iter_8_0, var_5_0.card_id, var_8_3, var_8_2)
			local var_8_6 = arg_8_1[var_8_3] or 0

			table.insert(var_8_0, {
				attr = var_8_3,
				maxVal = var_8_4,
				currVal = var_8_6 - var_8_5
			})

			var_8_1 = var_8_1 + var_8_6
		end

		arg_5_0.leftEffortValueNum:text(var_8_1)
		arg_5_0.leftEffortValueNum1:text(dataEasy.getRomanNumeral(var_8_2))
		arg_5_0.effortAdvanceArrow:texture(var_8_2 < arg_8_4 and "common/icon/logo_arrow_green.png" or "common/icon/logo_arrow_red.png")
		arg_5_0.effortAdvanceArrow:visible(var_8_2 ~= arg_8_4 and arg_8_4 ~= 0)
		adapt.oneLinePos(arg_5_0.leftEffortValueNum1, arg_5_0.effortAdvanceArrow, cc.p(15, 0))

		if not arg_5_0.leftEffortValue then
			arg_5_0.leftEffortValue = idlers.newWithMap(var_8_0)
		else
			arg_5_0.leftEffortValue:update(var_8_0)
		end
	end)

	arg_5_0.rightEffortValue = idlertable.new({})

	local function var_5_4(arg_9_0)
		local var_9_0 = csv.character[arg_9_0]
		local var_9_1 = arg_5_0.rightCharacter:multiget("name", "none", "special")

		var_9_1.name:text(var_9_0.name)

		local var_9_2 = csvSize(var_9_0.attrMap) > 0

		var_9_1.none:visible(not var_9_2)
		var_9_1.special:visible(var_9_2)

		if var_9_2 then
			for iter_9_0, iter_9_1 in csvPairs(var_9_0.attrMap) do
				local var_9_3 = tonumber(string.match(iter_9_1, "%d+"))

				if var_9_3 > 100 then
					var_9_1.special:get("name1"):text(getLanguageAttr(iter_9_0))

					local var_9_4 = var_9_3 - 100

					var_9_1.special:get("num1"):text("+" .. var_9_4 .. "%")

					if matchLanguage({
						"kr"
					}) then
						adapt.oneLinePos(var_9_1.special:get("name1"), {
							var_9_1.special:get("num1"),
							var_9_1.special:get("green")
						}, cc.p(15, 0))
					end
				else
					local var_9_5 = 100 - var_9_3

					var_9_1.special:get("num2"):text("-" .. var_9_5 .. "%")
					var_9_1.special:get("name2"):text(getLanguageAttr(iter_9_0))

					if matchLanguage({
						"kr"
					}) then
						adapt.oneLinePos(var_9_1.special:get("name2"), {
							var_9_1.special:get("num2"),
							var_9_1.special:get("red")
						}, cc.p(15, 0))
					end
				end
			end
		end
	end

	local function var_5_5(arg_10_0)
		local var_10_0 = 0

		for iter_10_0, iter_10_1 in pairs(arg_10_0) do
			var_10_0 = var_10_0 + iter_10_1
		end

		arg_5_0.rightNValueNum:text(var_10_0)
		arg_5_0.rightNValuePos:removeAllChildren()
		bind.extend(arg_5_0, arg_5_0.rightNValuePos, {
			class = "draw_attr",
			props = {
				perfectShow = false,
				type = "big",
				textFontSize = 36,
				numFontSize = 40,
				nvalue = arg_10_0,
				offsetPos = {
					{
						x = -225,
						y = -365
					},
					{
						x = -200,
						y = -350
					},
					{
						x = -200,
						y = -370
					},
					{
						x = -225,
						y = -365
					},
					{
						y = -370,
						x = matchLanguage({
							"kr",
							"en"
						}) and -265 or -210
					},
					{
						y = -350,
						x = matchLanguage({
							"kr",
							"en"
						}) and -265 or -210
					}
				},
				offset = {
					x = 110,
					y = 100
				},
				onNode = function(arg_11_0)
					arg_11_0:get("img"):scale(0.58)
				end
			}
		})
	end

	local function var_5_6(arg_12_0, arg_12_1)
		local var_12_0 = {}
		local var_12_1 = 0
		local var_12_2 = 0

		for iter_12_0, iter_12_1 in orderCsvPairs(arg_5_0.effortCfg) do
			var_12_2 = var_12_2 + 1

			local var_12_3 = game.ATTRDEF_TABLE[iter_12_1.attrType]
			local var_12_4 = arg_12_1[var_12_3] or 0
			local var_12_5, var_12_6 = dataEasy.getCardEffortMax(var_12_2, var_5_0.card_id, var_12_3, arg_12_0)

			table.insert(var_12_0, {
				attr = var_12_3,
				maxVal = var_12_5,
				currVal = var_12_4 - var_12_6
			})

			arg_5_0.leftEffortValue:atproxy(var_12_2).rightVal = var_12_4 - var_12_6
			var_12_1 = var_12_1 + var_12_4
		end

		arg_5_0.rightEffortValue:set(var_12_0)
		arg_5_0.rightEffortValueNum:text(var_12_1)
		arg_5_0.rightEffortValueNum1:text(dataEasy.getRomanNumeral(arg_12_0))
		adapt.oneLinePos(arg_5_0.rightEffortValueNum, arg_5_0.rightEffortValueTxt, cc.p(15, 0), "right")
		adapt.oneLinePos(arg_5_0.rightEffortValueNum1, arg_5_0.rightEffortValueTxt1, cc.p(15, 0), "right")
	end

	local function var_5_7(arg_13_0, arg_13_1)
		local var_13_0 = csv.cards[arg_13_1]
		local var_13_1 = arg_5_0.cardFeels:read()[var_13_0.cardMarkID] or {}

		arg_5_0.rightFeelLv:text(arg_13_0)

		local var_13_2 = table.length(gGoodFeelCsv[var_13_0.feelType])
		local var_13_3 = gGoodFeelCsv[var_13_0.feelType]
		local var_13_4 = var_13_3[math.min(arg_13_0 + 1, var_13_2)].needExp
		local var_13_5 = var_13_1.level_exp or 0
		local var_13_6 = var_13_5 / var_13_4 * 100

		arg_5_0.rightFeelBar:percent(var_13_6)
		arg_5_0.rightFeelCurTxt:text(var_13_5)
		arg_5_0.rightFeelMaxTxt:text("/" .. var_13_4)

		if arg_13_0 == var_13_2 then
			arg_5_0.rightFeelBar:percent(100)

			local var_13_7 = var_13_3[arg_13_0].needExp

			arg_5_0.rightFeelCurTxt:text(var_13_7)
			arg_5_0.rightFeelMaxTxt:text("/" .. var_13_7)
		end

		adapt.oneLinePos(arg_5_0.rightFeelMaxTxt, arg_5_0.rightFeelCurTxt, nil, "right")
	end

	idlereasy.any({
		arg_5_0.showTab,
		arg_5_0.sprOrItemIds
	}, function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = arg_14_2[arg_14_1][1]
		local var_14_1 = var_14_0 ~= 0
		local var_14_2 = arg_5_0.leftData:atproxy(arg_14_1).view:get("rightPos")
		local var_14_3 = arg_5_0.leftData:atproxy(arg_14_1).view:get("name")

		var_14_2:visible(var_14_1)
		arg_5_0.handbookPanel:visible(var_14_1)

		if var_14_1 then
			local var_14_4
			local var_14_5 = {}
			local var_14_6 = 0

			if arg_5_0.showTab:read() ~= var_0_1.FEEL then
				var_14_5 = gGameModel.cards:find(var_14_0):read("card_id", "skin_id", "level", "star", "advance", "locked", "name", "nvalue", "character", "effort_values", "effort_advance")
				var_14_6 = dataEasy.getUnitId(var_14_5.card_id, var_14_5.skin_id)
			else
				var_14_5.card_id = var_14_0
				var_14_5.advance = nil
				var_14_5.star = nil
				var_14_5.level = nil
			end

			uiEasy.setIconName("card", var_14_5.card_id, {
				space = true,
				node = var_14_3,
				name = var_14_5.name,
				advance = var_14_5.advance
			})

			local var_14_7 = csv.cards[var_14_5.card_id]
			local var_14_8 = csv.unit[var_14_7.unitID]

			if var_14_6 == 0 then
				var_14_6 = var_14_7.unitID
			end

			bind.extend(arg_5_0, var_14_2, {
				class = "card_icon",
				props = {
					unitId = var_14_6,
					advance = var_14_5.advance,
					star = var_14_5.star,
					rarity = var_14_8.rarity,
					levelProps = {
						data = var_14_5.level
					},
					params = {
						starScale = 0.85,
						starInterval = 12.5
					}
				}
			})

			local var_14_9 = csv.cards[var_14_5.card_id]
			local var_14_10 = (arg_5_0.cardFeels:read()[var_14_9.cardMarkID] or {}).level or 0

			if arg_14_1 == var_0_1.NATURE then
				var_5_4(var_14_5.character)
			elseif arg_14_1 == var_0_1.NVALUE then
				var_5_5(var_14_5.nvalue)
			elseif arg_14_1 == var_0_1.EFFORTVALUE then
				arg_5_0.rightEffortAdvance:set(var_14_5.effort_advance)
				var_5_6(var_14_5.effort_advance, var_14_5.effort_values)
			else
				var_5_7(var_14_10, var_14_5.card_id)
			end
		else
			var_14_3:text(gLanguageCsv.chooseSpr)

			for iter_14_0 = 1, arg_5_0.leftEffortValue:size() do
				arg_5_0.leftEffortValue:atproxy(iter_14_0).rightVal = false
			end
		end

		local var_14_11 = arg_14_2[arg_14_1][2]
		local var_14_12 = var_14_11 ~= 0
		local var_14_13 = arg_5_0.leftData:atproxy(arg_14_1).view:get("rightPosItem")
		local var_14_14 = arg_5_0.leftData:atproxy(arg_14_1).view:get("nameItem")

		if var_14_13 then
			var_14_13:visible(var_14_12)

			if var_14_12 then
				local var_14_15 = dataEasy.getCfgByKey(var_14_11)
				local var_14_16 = dataEasy.getNumByKey(var_14_11)

				var_14_14:text(var_14_15.name)
				bind.extend(arg_5_0, var_14_13, {
					class = "icon_key",
					props = {
						noListener = true,
						data = {
							num = 1,
							key = var_14_11
						},
						onNode = function(arg_15_0)
							arg_15_0:setTouchEnabled(false)
						end
					}
				})

				if arg_14_1 == var_0_1.NATURE then
					var_5_4(var_14_15.specialArgsMap.character)
				end
			else
				var_14_14:text(gLanguageCsv.chooseItem)
			end
		end

		if var_14_13 and var_14_12 then
			arg_5_0.btnExchangeText:text(gLanguageCsv.use)
		else
			arg_5_0.btnExchangeText:text(gLanguageCsv.exchange)
		end

		arg_5_0.rightPanel:visible(not var_14_1 and not var_14_12)
		arg_5_0.leftData:atproxy(arg_14_1).view:get("rightPanel"):visible(var_14_1 or var_14_12)
	end)
	idlereasy.when(arg_5_0.leftCard:getIdler("character"), function(arg_16_0, arg_16_1)
		local var_16_0 = csv.character[arg_16_1]
		local var_16_1 = arg_5_0.leftCharacter:multiget("name", "none", "special")

		var_16_1.name:text(var_16_0.name)

		local var_16_2 = csvSize(var_16_0.attrMap) > 0

		var_16_1.none:visible(not var_16_2)
		var_16_1.special:visible(var_16_2)

		if var_16_2 then
			for iter_16_0, iter_16_1 in csvPairs(var_16_0.attrMap) do
				local var_16_3 = tonumber(string.match(iter_16_1, "%d+"))
				local var_16_4 = game.ATTRDEF_TABLE[iter_16_0]
				local var_16_5 = "attr" .. string.caption(var_16_4)

				if var_16_3 > 100 then
					var_16_1.special:get("name1"):text(gLanguageCsv[var_16_5])

					local var_16_6 = var_16_3 - 100

					var_16_1.special:get("num1"):text("+" .. var_16_6 .. "%")

					if matchLanguage({
						"kr"
					}) then
						adapt.oneLinePos(var_16_1.special:get("name1"), {
							var_16_1.special:get("num1"),
							var_16_1.special:get("green")
						}, cc.p(15, 0))
					end
				else
					local var_16_7 = 100 - var_16_3

					var_16_1.special:get("num2"):text("-" .. var_16_7 .. "%")
					var_16_1.special:get("name2"):text(gLanguageCsv[var_16_5])

					if matchLanguage({
						"kr"
					}) then
						adapt.oneLinePos(var_16_1.special:get("name2"), {
							var_16_1.special:get("num2"),
							var_16_1.special:get("red")
						}, cc.p(15, 0))
					end
				end
			end
		end
	end)
	idlereasy.when(arg_5_0.leftCard:getIdler("nvalue"), function(arg_17_0, arg_17_1)
		local var_17_0 = 0

		for iter_17_0, iter_17_1 in pairs(arg_17_1) do
			var_17_0 = var_17_0 + iter_17_1
		end

		arg_5_0.leftNValueNum:text(var_17_0)
		arg_5_0.leftNValuePos:removeAllChildren()
		bind.extend(arg_5_0, arg_5_0.leftNValuePos, {
			class = "draw_attr",
			props = {
				perfectShow = false,
				type = "big",
				textFontSize = 36,
				numFontSize = 40,
				nvalue = arg_17_1,
				offsetPos = {
					{
						x = -225,
						y = -365
					},
					{
						x = -200,
						y = -350
					},
					{
						x = -200,
						y = -370
					},
					{
						x = -225,
						y = -365
					},
					{
						y = -370,
						x = matchLanguage({
							"kr",
							"en"
						}) and -265 or -210
					},
					{
						y = -350,
						x = matchLanguage({
							"kr",
							"en"
						}) and -265 or -210
					}
				},
				offset = {
					x = 110,
					y = 100
				},
				onNode = function(arg_18_0)
					arg_18_0:get("img"):scale(0.58)
				end
			}
		})
	end)

	arg_5_0.maxLimitLv = table.length(gGoodFeelCsv[var_5_1.feelType])

	idlereasy.when(arg_5_0.cardFeels, function(arg_19_0, arg_19_1)
		local var_19_0 = arg_19_1[var_5_1.cardMarkID] or {}
		local var_19_1 = var_19_0.level or 0
		local var_19_2 = var_19_0.level_exp or 0
		local var_19_3 = gGoodFeelCsv[var_5_1.feelType]

		arg_5_0.clientNextLvExp = var_19_3[math.min(var_19_1 + 1, arg_5_0.maxLimitLv)].needExp

		arg_5_0.leftFeelLv:text(var_19_1)

		local var_19_4 = var_19_2 / arg_5_0.clientNextLvExp * 100

		arg_5_0.leftFeelBar:percent(var_19_4)
		arg_5_0.leftFeelCurTxt:text(var_19_2)
		arg_5_0.leftFeelMaxTxt:text("/" .. arg_5_0.clientNextLvExp)

		if var_19_1 == arg_5_0.maxLimitLv then
			arg_5_0.leftFeelBar:percent(100)

			local var_19_5 = var_19_3[var_19_1].needExp

			arg_5_0.leftFeelCurTxt:text(var_19_5)
			arg_5_0.leftFeelMaxTxt:text("/" .. var_19_5)
		end

		adapt.oneLinePos(arg_5_0.leftFeelMaxTxt, arg_5_0.leftFeelCurTxt, nil, "right")
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_0.checkCharacterItem(arg_20_0)
	for iter_20_0, iter_20_1 in pairs(gGameModel.role:read("items")) do
		if csv.items[iter_20_0].type == game.ITEM_TYPE_ENUM_TABLE.characterType then
			return true
		end
	end

	return false
end

function var_0_0.onLeftButtonClick(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0.showTab:set(arg_21_2)
end

function var_0_0.setParams(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.sprOrItemIds:modify(function(arg_23_0)
		arg_23_0[arg_22_0.showTab:read()] = {
			arg_22_1 or 0,
			arg_22_2 or 0
		}
	end, true)
end

function var_0_0.onSelect(arg_24_0)
	gGameUI:stackUI("city.card.property_swap.choose", nil, nil, arg_24_0.showTab:read(), arg_24_0.selectDbId, arg_24_0:createHandler("setParams"))
end

function var_0_0.initCfg(arg_25_0)
	local var_25_0 = {}

	for iter_25_0, iter_25_1 in orderCsvPairs(csv.card_effort) do
		if iter_25_1.attrType ~= game.ATTRDEF_ENUM_TABLE.specialDamage and iter_25_1.advance == 1 then
			var_25_0[iter_25_0] = iter_25_1
		end
	end

	arg_25_0.effortCfg = var_25_0
end

function var_0_0.onSelectItem(arg_26_0)
	gGameUI:stackUI("city.card.property_swap.choose_item", nil, nil, arg_26_0.showTab:read(), arg_26_0.selectDbId, arg_26_0:createHandler("setParams"))
end

function var_0_0.onExchange(arg_27_0)
	local var_27_0 = arg_27_0.showTab:read()
	local var_27_1 = arg_27_0.sprOrItemIds:read()[var_27_0]
	local var_27_2 = var_27_1[1]
	local var_27_3 = var_27_1[2]

	if var_27_2 == 0 and var_27_3 == 0 then
		gGameUI:showTip(gLanguageCsv.propertyChoiceFirst)

		return
	end

	if arg_27_0.rmb:read() < arg_27_0.leftData:atproxy(arg_27_0.showTab:read()).cost then
		uiEasy.showDialog("rmb")

		return
	end

	local var_27_4 = gLanguageCsv.swapSuccess
	local var_27_5

	if var_27_0 ~= var_0_1.FEEL then
		var_27_5 = string.format(gLanguageCsv.swapCardContinue, arg_27_0.leftData:atproxy(var_27_0).desc)

		if var_27_0 == var_0_1.EFFORTVALUE and arg_27_0:effortsValue() then
			var_27_5 = string.format(gLanguageCsv.spriteUpperLimit, arg_27_0.leftData:atproxy(var_27_0).desc, arg_27_0.leftData:atproxy(var_27_0).desc)
		end
	else
		var_27_5 = gLanguageCsv.swapFeelContinue
	end

	local var_27_6 = {
		btnType = 2,
		strs = var_27_5,
		cb = function()
			local var_28_0 = {
				false
			}
			local var_28_1

			if var_27_2 ~= 0 then
				if var_27_0 ~= var_0_1.FEEL then
					var_28_1 = gGameApp:requestServerCustom("/game/card/property/swap"):params(arg_27_0.selectDbId, var_27_2, var_27_0)
				else
					local var_28_2 = arg_27_0.leftCard:read("card_id", "level", "star", "advance", "locked", "name")

					var_28_1 = gGameApp:requestServerCustom("/game/card/feel/swap"):params(var_28_2.card_id, var_27_2)
				end
			elseif var_27_3 ~= 0 then
				var_28_1 = gGameApp:requestServerCustom("/game/card/character/use_items"):params(arg_27_0.selectDbId, var_27_3)
			else
				return
			end

			var_28_1:onResponse(function()
				local var_29_0 = arg_27_0:getResourceNode()

				widget.addAnimationByKey(var_29_0, "effect/peiyanghuhuan.skel", "peiyanghuhuan", "effect", 99):anchorPoint(cc.p(0.5, 0.5)):xy(var_29_0:width() / 2, var_29_0:height() / 2):play("effect")
				performWithDelay(arg_27_0, function()
					gGameUI:showTip(var_27_4)
					arg_27_0.sprOrItemIds:modify(function(arg_31_0)
						arg_31_0[arg_27_0.showTab:read()] = {
							0,
							0
						}
					end, true)

					var_28_0[1] = true
				end, 1.8333333333333333)
			end):wait(var_28_0):doit()
		end
	}

	if var_27_3 ~= 0 then
		var_27_6.strs = gLanguageCsv.useCharacterItemTip
		var_27_6.isRich = true
		var_27_4 = gLanguageCsv.characterChangeSuccess

		local var_27_7 = dataEasy.getCfgByKey(var_27_3)

		if arg_27_0.leftCard:read("character") == var_27_7.specialArgsMap.character then
			gGameUI:showTip(gLanguageCsv.characterSame)

			return
		end
	end

	local var_27_8 = var_27_6.cb

	function var_27_6.cb()
		dataEasy.sureUsingDiamonds(var_27_8, arg_27_0.leftData:atproxy(arg_27_0.showTab:read()).cost)
	end

	gGameUI:showDialog(var_27_6)
end

function var_0_0.effortsValue(arg_33_0)
	local var_33_0 = 0
	local var_33_1 = 0
	local var_33_2 = arg_33_0.showTab:read()
	local var_33_3 = arg_33_0.sprOrItemIds:read()[var_33_2]
	local var_33_4 = arg_33_0.leftCard:read("card_id")
	local var_33_5 = gGameModel.cards:find(var_33_3[1]):read("card_id")
	local var_33_6 = csv.cards[var_33_4].effortSeqID
	local var_33_7 = csv.cards[var_33_5].effortSeqID

	for iter_33_0, iter_33_1 in csvPairs(csv.card_effort_advance) do
		if iter_33_1.effortSeqID == var_33_6 and iter_33_1.advance <= iter_33_1.advanceLimit then
			var_33_0 = var_33_0 + iter_33_1.hp + iter_33_1.speed + iter_33_1.damage + iter_33_1.defence + iter_33_1.specialDamage + iter_33_1.specialDefence
		end

		if iter_33_1.effortSeqID == var_33_7 and iter_33_1.advance <= iter_33_1.advanceLimit then
			var_33_1 = var_33_1 + iter_33_1.hp + iter_33_1.speed + iter_33_1.damage + iter_33_1.defence + iter_33_1.specialDamage + iter_33_1.specialDefence
		end
	end

	if var_33_1 < tonumber(arg_33_0.leftEffortValueNum:getString()) or var_33_0 < tonumber(arg_33_0.rightEffortValueNum:getString()) then
		return true
	end

	return false
end

function var_0_0.onBtnInfo(arg_34_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_34_0:createHandler("getRuleContext"), {
		width = 1415
	})
end

function var_0_0.getRuleContext(arg_35_0, arg_35_1)
	local var_35_0 = adaptContext

	return {
		var_35_0.clone(arg_35_1.title, function(arg_36_0)
			arg_36_0:get("text"):text(gLanguageCsv.feelSwapStatement)
		end),
		var_35_0.noteText(89001, 89010)
	}
end

function var_0_0.onItemClick(arg_37_0)
	local var_37_0 = arg_37_0.showTab:read()
	local var_37_1 = arg_37_0.sprOrItemIds:read()[var_37_0][1]
	local var_37_2 = csv.cards[var_37_1]

	gGameUI:stackUI("city.handbook.view", nil, {
		full = true
	}, {
		cardId = var_37_2.id
	})
end

return var_0_0
