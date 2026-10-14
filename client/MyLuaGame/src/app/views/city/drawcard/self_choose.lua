local var_0_0 = {}
local var_0_1 = {
	ONCE = gCommonConfigCsv.drawCardUp1CostPrice,
	TEN = gCommonConfigCsv.drawCardUp10CostPrice
}

function var_0_0.initPageItemFunc(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0:addEffectInRect("effect/zixuanchouka.skel", "zixuanchouka")
	arg_1_0.isLimitDraw:set(true)
	arg_1_0.isCutDown:set(false)
	arg_1_0.isFree:set(false)
	arg_1_0.isCost:set(true)

	local var_1_0 = "common/icon/icon_diamond.png"
	local var_1_1 = "common/icon/icon_diamond.png"
	local var_1_2 = var_0_1.ONCE
	local var_1_3 = var_0_1.TEN
	local var_1_4 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

	if var_1_4 > 0 then
		var_1_0 = dataEasy.getIconResByKey(game.ITEM_TICKET.diamondUpCard)
		var_1_2 = string.format("%s/%s", var_1_4, 1)
	end

	if var_1_4 >= 10 then
		var_1_1 = dataEasy.getIconResByKey(game.ITEM_TICKET.diamondUpCard)
		var_1_3 = string.format("%s/%s", var_1_4, 10)
	end

	arg_1_0.oneIconPath:set(var_1_0)
	arg_1_0.tenIconPath:set(var_1_1)
	arg_1_0.drawOnceCost:set(var_1_2)
	arg_1_0.drawTenCost:set(var_1_3)
	arg_1_0:initCards()
end

function var_0_0.initCards(arg_2_0)
	arg_2_0.diamondUpCardPanel:removeAllChildren()

	local var_2_0 = {}

	for iter_2_0, iter_2_1 in csvMapPairs(csv.draw_card_up_group) do
		if iter_2_0 == arg_2_0:makeSelectPositive(arg_2_0.selfChooseNum:read()) then
			var_2_0 = iter_2_1.cards

			break
		end
	end

	local var_2_1 = {}

	for iter_2_2, iter_2_3 in pairs(var_2_0) do
		local var_2_2 = csv.cards[iter_2_3]
		local var_2_3 = csv.unit[var_2_2.unitID].rarity

		table.insert(var_2_1, {
			id = iter_2_3,
			rarity = var_2_3
		})
	end

	local var_2_4 = table.getn(var_2_1)

	table.sort(var_2_1, function(arg_3_0, arg_3_1)
		return arg_3_0.rarity < arg_3_1.rarity
	end)

	local var_2_5 = arg_2_0.diamondUpCardPanel:size().width - 200
	local var_2_6 = var_2_4 % 2 == 0 and 60 or 80
	local var_2_7 = 35
	local var_2_8 = 400
	local var_2_9 = 1

	if var_2_4 >= 10 then
		var_2_9 = 0.7
	elseif var_2_4 >= 6 then
		var_2_9 = 0.7 + (10 - var_2_4) * 0.05
	end

	local var_2_10 = var_2_6 / var_2_9

	for iter_2_4, iter_2_5 in csvPairs(var_2_1) do
		local var_2_11 = (var_2_4 + 1) / 2
		local var_2_12 = arg_2_0:createCard(iter_2_5.id):addTo(arg_2_0.diamondUpCardPanel)

		var_2_12:setAnchorPoint(cc.p(0.5, 0))
		var_2_12:x(var_2_5 / 2 + (iter_2_4 - var_2_11) * var_2_5 / (var_2_4 + 1))
		var_2_12:y(var_2_10 + math.abs(iter_2_4 - var_2_11) * var_2_8 / (var_2_4 + 1))
		var_2_12:setRotation((iter_2_4 - var_2_11) * (var_2_7 / (var_2_4 + 1)))
		var_2_12:z(100 - math.abs(iter_2_4 - (math.floor(var_2_4 / 2) + 1)))
		var_2_12:scale(var_2_9)
	end
end

function var_0_0.makeSelectPositive(arg_4_0, arg_4_1)
	if not arg_4_1 or arg_4_1 == 0 then
		return 1
	end

	return arg_4_1
end

function var_0_0.createCard(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.cardItem:clone():show()

	var_5_0:show()

	local var_5_1 = csv.cards[arg_5_1]
	local var_5_2 = csv.unit[var_5_1.unitID]
	local var_5_3 = var_5_2.rarity
	local var_5_4 = var_5_2.cardShow
	local var_5_5 = var_5_2.cardShowScale
	local var_5_6 = var_5_2.cardShowPosC
	local var_5_7 = var_5_2.name
	local var_5_8 = var_5_2.natureType
	local var_5_9 = var_5_2.natureType2

	uiEasy.setIconName("card", arg_5_1, {
		advance = 1,
		space = true,
		node = var_5_0:get("name"),
		name = var_5_7
	})
	text.addEffect(var_5_0:get("name"), {
		color = ui.COLORS.NORMAL.WHITE
	})

	local var_5_10 = {
		nil,
		"z",
		"h",
		"c",
		"r",
		"z"
	}

	var_5_0:get("bg"):texture(string.format("city/drawcard/draw/panel_card_%s.png", var_5_10[var_5_3]))
	var_5_0:get("rarity"):texture(ui.RARITY_ICON[var_5_3])

	if var_5_9 == nil then
		var_5_0:get("attr1"):texture(ui.ATTR_ICON[var_5_8])
		var_5_0:get("attr2"):hide()
	else
		var_5_0:get("attr1"):texture(ui.ATTR_ICON[var_5_8])
		var_5_0:get("attr2"):texture(ui.ATTR_ICON[var_5_9]):show()
	end

	local var_5_11 = var_5_0:get("bg"):size()
	local var_5_12 = ccui.Scale9Sprite:create()

	var_5_12:initWithFile(cc.rect(82, 82, 1, 1), "common/icon/mask_card.png")
	var_5_12:size(var_5_11.width - 39, var_5_11.height - 39):alignCenter(var_5_11)

	local var_5_13 = cc.Sprite:create(var_5_4)
	local var_5_14 = var_5_13:size()
	local var_5_15 = cc.p(var_5_6.x / var_5_5, -var_5_6.y / var_5_5)
	local var_5_16 = cc.size(var_5_11.width / var_5_5, var_5_11.height / var_5_5)
	local var_5_17 = cc.rect((var_5_14.width - var_5_16.width) / 2 - var_5_15.x, (var_5_14.height - var_5_16.height) / 2 - var_5_15.y, var_5_16.width, var_5_16.height)

	var_5_13:alignCenter(var_5_11):scale(var_5_5 + 0.2):setTextureRect(var_5_17)
	var_5_0:removeChildByName("clipping")
	cc.ClippingNode:create(var_5_12):setAlphaThreshold(0.1):size(var_5_11):alignCenter(var_5_0:size()):add(var_5_13):addTo(var_5_0, 5, "clipping")

	return var_5_0
end

function var_0_0.isEnoughToDrawFunc(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.rmb:read()
	local var_6_1 = var_6_0
	local var_6_2 = var_0_1.ONCE
	local var_6_3 = var_0_1.TEN
	local var_6_4 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

	if var_6_4 > 0 then
		var_6_2 = 1
		var_6_0 = var_6_4

		if var_6_4 >= 10 then
			var_6_3 = 10
			var_6_1 = var_6_4
		end
	end

	if arg_6_1 then
		return var_6_3 <= var_6_1
	else
		return var_6_2 <= var_6_0
	end
end

function var_0_0.drawOneClickFunc(arg_7_0)
	local var_7_0 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

	local function var_7_1()
		gGameApp:requestServer("/game/lottery/card/up/draw", function(arg_9_0)
			audio.pauseMusic()
			audio.playEffectWithWeekBGM("drawcard_one.mp3")

			local var_9_0, var_9_1, var_9_2 = dataEasy.getRawTable(arg_9_0)
			local var_9_3 = dataEasy.getItems(var_9_0, var_9_1)
			local var_9_4
			local var_9_5 = {
				drawType = "self_choose",
				isFree = false,
				times = 1,
				items = var_9_3,
				selfChooseType = arg_7_0:makeSelectPositive(arg_7_0.selfChooseNum:read()),
				cb = function()
					arg_7_0:initAward()
				end
			}

			gGameUI:stackUI("city.drawcard.result", nil, nil, var_9_5)
			arg_7_0:initAward()
		end, "group_up_rmb1", arg_7_0:makeSelectPositive(arg_7_0.selfChooseNum:read()))
	end

	if var_7_0 > 0 then
		var_7_1()
	else
		dataEasy.sureUsingDiamonds(var_7_1, var_0_1.ONCE)
	end
end

function var_0_0.drawTenClickFunc(arg_11_0)
	local var_11_0 = false

	if dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard) < 10 then
		var_11_0 = true
	end

	local function var_11_1()
		gGameApp:requestServer("/game/lottery/card/up/draw", function(arg_13_0)
			audio.pauseMusic()
			audio.playEffectWithWeekBGM("drawcard_ten.mp3")

			local var_13_0, var_13_1, var_13_2 = dataEasy.getRawTable(arg_13_0)
			local var_13_3 = dataEasy.getItems(var_13_0, var_13_1)
			local var_13_4
			local var_13_5 = {
				drawType = "self_choose",
				isFree = false,
				times = 10,
				items = var_13_3,
				selfChooseType = arg_11_0:makeSelectPositive(arg_11_0.selfChooseNum:read()),
				cb = function()
					arg_11_0:initAward()
				end
			}

			gGameUI:stackUI("city.drawcard.result", nil, nil, var_13_5)
			arg_11_0:initAward()

			if var_11_0 then
				userDefault.setCurrDayKey("diamondUpDrawTips", 0)
			end
		end, "group_up_rmb10", arg_11_0:makeSelectPositive(arg_11_0.selfChooseNum:read()))
	end

	if var_11_0 and (matchLanguage({
		"kr"
	}) or userDefault.getCurrDayKey("diamondUpDrawTips", 1) == 1 and dataEasy.isUnlock("diamondUpDrawTips")) then
		local var_11_2 = var_0_1.TEN

		gGameUI:showDialog({
			isRich = true,
			clearFast = true,
			btnType = 2,
			content = string.format(gLanguageCsv.draw10CardTips, var_11_2),
			cb = function()
				var_11_1()
			end
		})
	else
		var_11_1()
	end
end

function var_0_0.onPerviewClick(arg_16_0)
	gGameUI:stackUI("city.drawcard.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, arg_16_0.curType:read(), nil, arg_16_0:makeSelectPositive(arg_16_0.selfChooseNum:read()))
end

return var_0_0
