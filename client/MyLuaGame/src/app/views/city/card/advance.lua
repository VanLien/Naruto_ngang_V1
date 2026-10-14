local var_0_0 = class("CardAdvanceView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "card_advance.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	panel = "panel",
	["panel.costInfo"] = "costInfo",
	["panel.textEnd"] = "newAdvanceNote",
	["panel.btnInfo"] = "btnInfo",
	["panel.costInfo.imgIcon"] = "costIcon",
	["panel.costInfo.textCostNum"] = "needGoldTxt",
	["panel.textBefore"] = "oldAdvanceNote",
	["panel.head"] = {
		binds = {
			event = "extend",
			class = "card_icon",
			props = {
				unitId = bindHelper.self("unitId"),
				advance = bindHelper.self("advance"),
				onNode = function(arg_1_0)
					return
				end
			}
		}
	},
	["panel.textLv"] = {
		varname = "needLevelTxt",
		binds = {
			event = "text",
			idler = bindHelper.self("needLevel")
		}
	},
	["panel.btnUp"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAdvanceClick")
			}
		}
	},
	["panel.btnOneKeyUp"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyAdvanceClick")
			}
		}
	},
	["panel.textNote"] = {
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
	["panel.btnUp.textNote"] = {
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
	["panel.btnOneKeyUp.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

local var_0_1 = {
	{
		cc.p(476.5, 450)
	},
	{
		cc.p(315, 430),
		cc.p(625, 430)
	},
	{
		cc.p(160, 660),
		cc.p(476.5, 450),
		cc.p(785, 660)
	},
	{
		cc.p(160, 660),
		cc.p(315, 430),
		cc.p(625, 430),
		cc.p(785, 660)
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.selectDbId = arg_2_1()
	arg_2_0.playAction = arg_2_2

	arg_2_0:initModel()

	arg_2_0.needLevel = idler.new("")
	arg_2_0.needGold = idler.new("")
	arg_2_0.lackMaterial = idler.new(false)
	arg_2_0.itemId = {}

	arg_2_0.btnInfo:hide()

	arg_2_0.unitId = idler.new(0)

	widget.addAnimation(arg_2_0.panel, "effect/tupohuan.skel", "effect_loop", 1):xy(477, 770)
	idlereasy.any({
		arg_2_0.cardId,
		arg_2_0.skinId,
		arg_2_0.advance,
		arg_2_0.cardLv,
		arg_2_0.items
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
		local var_3_0 = csv.cards[arg_3_1]
		local var_3_1 = gCardAdvanceCsv[var_3_0.advanceTypeID][arg_3_3]

		uiEasy.setIconName("card", arg_3_1, {
			space = true,
			node = arg_2_0.oldAdvanceNote,
			name = ui.QUALITY_COLOR_TEXT,
			advance = arg_3_3
		})
		uiEasy.setIconName("card", arg_3_1, {
			space = true,
			node = arg_2_0.newAdvanceNote,
			name = ui.QUALITY_COLOR_TEXT,
			advance = arg_3_3 + 1
		})
		arg_2_0.needGold:set(var_3_1.gold)
		arg_2_0.needGoldTxt:text(var_3_1.gold)
		arg_2_0.costInfo:visible(var_3_1.gold and var_3_1.gold > 0)
		adapt.oneLinePos(arg_2_0.needGoldTxt, arg_2_0.costIcon, nil, "left")

		local var_3_2 = dataEasy.getNumByKey("gold") >= var_3_1.gold and ui.NEWCOLORS.WHITE or cc.c4b(249, 87, 114, 255)

		text.addEffect(arg_2_0.needGoldTxt, {
			color = var_3_2
		})

		local var_3_3 = var_3_0.advanceLevelReq[arg_3_3]

		arg_2_0.needLevel:set(var_3_3)

		local var_3_4 = var_3_3 <= arg_3_4 and ui.NEWCOLORS.GREENLIGHT or ui.NEWCOLORS.REDLIGHT

		text.addEffect(arg_2_0.needLevelTxt, {
			color = var_3_4,
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
		arg_2_0.unitId:set(dataEasy.getUnitId(arg_3_1, arg_3_2))
		arg_2_0:setUI(arg_3_1, arg_3_3, arg_3_5)
	end)
	idlereasy.when(arg_2_0.gold, function(arg_4_0, arg_4_1)
		local var_4_0 = csv.cards[arg_2_0.cardId:read()]
		local var_4_1 = arg_4_1 >= gCardAdvanceCsv[var_4_0.advanceTypeID][arg_2_0.advance:read()].gold and ui.NEWCOLORS.WHITE or cc.c4b(249, 87, 114, 255)

		text.addEffect(arg_2_0.needGoldTxt, {
			color = var_4_1
		})
	end)
end

function var_0_0.setUI(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0.lackMaterial:set(false)

	local var_5_0 = csv.cards[arg_5_1]
	local var_5_1 = gCardAdvanceCsv[var_5_0.advanceTypeID][arg_5_2]
	local var_5_2 = {}

	for iter_5_0, iter_5_1 in csvPairs(var_5_1.itemMap) do
		table.insert(var_5_2, {
			id = iter_5_0,
			num = iter_5_1
		})
	end

	table.sort(var_5_2, function(arg_6_0, arg_6_1)
		return arg_6_0.id < arg_6_1.id
	end)

	local var_5_3 = 1
	local var_5_4 = itertools.size(var_5_2)

	for iter_5_2 = 1, 999 do
		local var_5_5 = arg_5_0.panel:getChildByName("item" .. iter_5_2)

		if not var_5_5 then
			break
		end

		var_5_5:removeFromParent()
	end

	for iter_5_3, iter_5_4 in pairs(var_5_2) do
		local var_5_6 = arg_5_0.item:clone()
		local var_5_7 = arg_5_3[iter_5_4.id] or 0
		local var_5_8 = var_5_7 < iter_5_4.num

		var_5_6:get("btnAdd"):visible(var_5_8)

		local var_5_9 = {
			class = "icon_key",
			props = {
				data = {
					key = iter_5_4.id,
					num = var_5_7,
					targetNum = iter_5_4.num
				},
				grayState = var_5_8 and 1 or 0,
				onNode = function(arg_7_0)
					arg_7_0:setTouchEnabled(false)
				end
			}
		}

		bind.extend(arg_5_0, var_5_6, var_5_9)

		local var_5_10 = var_0_1[var_5_4][var_5_3]

		var_5_6:xy(var_5_10.x, var_5_10.y)
		var_5_6:show()
		arg_5_0.panel:add(var_5_6, 10, "item" .. iter_5_3)
		bind.touch(arg_5_0, var_5_6, {
			methods = {
				ended = function(arg_8_0, arg_8_1, arg_8_2)
					gGameUI:stackUI("common.gain_way", nil, nil, iter_5_4.id, nil, iter_5_4.num)
				end
			}
		})

		if var_5_7 < iter_5_4.num then
			arg_5_0.lackMaterial:set(true)
		end

		arg_5_0.itemId[var_5_3] = iter_5_4.id
		var_5_3 = var_5_3 + 1
	end
end

function var_0_0.initModel(arg_9_0)
	arg_9_0.gold = gGameModel.role:getIdler("gold")
	arg_9_0.items = gGameModel.role:getIdler("items")

	idlereasy.when(arg_9_0.selectDbId, function(arg_10_0, arg_10_1)
		if assertInWindows(arg_10_1, "val:%s", tostring(arg_10_1)) then
			return
		end

		local var_10_0 = gGameModel.cards:find(arg_10_1)

		arg_9_0.advance = idlereasy.assign(var_10_0:getIdler("advance"), arg_9_0.advance)
		arg_9_0.cardId = idlereasy.assign(var_10_0:getIdler("card_id"), arg_9_0.cardId)
		arg_9_0.skinId = idlereasy.assign(var_10_0:getIdler("skin_id"), arg_9_0.skinId)
		arg_9_0.star = idlereasy.assign(var_10_0:getIdler("star"), arg_9_0.star)

		local var_10_1 = csv.cards[arg_9_0.cardId:read()]

		arg_9_0.rarity = csv.unit[var_10_1.unitID].rarity
		arg_9_0.cardLv = idlereasy.assign(var_10_0:getIdler("level"), arg_9_0.cardLv)
		arg_9_0.fight = idlereasy.assign(var_10_0:getIdler("fighting_point"), arg_9_0.fight)
		arg_9_0.attrs = idlereasy.assign(var_10_0:getIdler("attrs"), arg_9_0.attrs)
	end)
end

function var_0_0.onAdvanceClick(arg_11_0)
	if not arg_11_0:advancedTips() then
		return
	end

	local var_11_0 = arg_11_0.fight:read()
	local var_11_1 = arg_11_0.advance:read()
	local var_11_2 = clone(arg_11_0.attrs:read())
	local var_11_3 = 0

	for iter_11_0 = 1, math.huge do
		if not arg_11_0.panel:getChildByName("item" .. iter_11_0) then
			var_11_3 = iter_11_0 - 1

			break
		end
	end

	local var_11_4 = 2 * var_11_3
	local var_11_5 = {
		false
	}

	gGameApp:requestServerCustom("/game/card/advance"):params(arg_11_0.selectDbId):onResponse(function(arg_12_0)
		arg_11_0.playAction()

		for iter_12_0 = 1, var_11_3 do
			local var_12_0 = arg_11_0.panel:getChildByName("item" .. iter_12_0)
			local var_12_1 = var_12_0:get("_icon_", "icon")

			var_12_1:hide()

			local var_12_2, var_12_3 = var_12_0:xy()
			local var_12_4 = var_12_1:clone():xy(var_12_2, var_12_3):show():addTo(arg_11_0.panel, 100)

			transition.executeSequence(var_12_4):moveTo(0.3, -500, 450):func(function()
				var_12_4:show()

				var_11_4 = var_11_4 - 1
				var_11_5[1] = var_11_4 <= 0
			end):done()
			transition.executeSequence(var_12_4):scaleTo(0.3, 0):func(function()
				var_12_4:removeFromParent()

				var_11_4 = var_11_4 - 1
				var_11_5[1] = var_11_4 <= 0
			end):done()
		end
	end):wait(var_11_5):doit(function(arg_15_0)
		gGameUI:stackUI("city.card.common_success", nil, {
			blackLayer = true
		}, arg_11_0.selectDbId:read(), var_11_0, {
			attrs = var_11_2,
			advanceOld = var_11_1
		})
	end)
end

function var_0_0.advancedTips(arg_16_0)
	if csv.cards[arg_16_0.cardId:read()].advanceMax <= arg_16_0.advance:read() then
		gGameUI:showTip(gLanguageCsv.advanceMaxErr)

		return
	end

	if arg_16_0.cardLv:read() < arg_16_0.needLevel:read() then
		gGameUI:showTip(gLanguageCsv.advanceLevelNotEnough)

		return
	end

	if dataEasy.getNumByKey("gold") < arg_16_0.needGold:read() then
		gGameUI:showTip(gLanguageCsv.advanceGoldNotEnough)

		return
	end

	if arg_16_0.lackMaterial:read() then
		gGameUI:showTip(gLanguageCsv.advanceItemsNotEnough)

		return
	end

	return true
end

function var_0_0.onOneKeyAdvanceClick(arg_17_0)
	if not arg_17_0:advancedTips() then
		return
	end

	arg_17_0.oldFight = arg_17_0.fight:read()
	arg_17_0.oldAttrs = clone(arg_17_0.attrs:read())
	arg_17_0.oldAdvance = arg_17_0.advance:read()

	gGameUI:stackUI("city.card.advance_onekey", nil, nil, arg_17_0.selectDbId:read(), arg_17_0:createHandler("onSuccess"))
end

function var_0_0.onSuccess(arg_18_0)
	gGameUI:stackUI("city.card.common_success", nil, {
		blackLayer = true
	}, arg_18_0.selectDbId:read(), arg_18_0.oldFight, {
		advanceOld = arg_18_0.oldAdvance,
		attrs = arg_18_0.oldAttrs
	})
end

return var_0_0
