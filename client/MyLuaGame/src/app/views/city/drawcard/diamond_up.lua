return {
	initPageItemFunc = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
		arg_1_0:addEffectInRect("effect/yuanbaochouka.skel", "yuanbaochouka")
		arg_1_0.isLimitDraw:set(true)
		arg_1_0.isCutDown:set(false)
		arg_1_0.isFree:set(false)
		arg_1_0.isCost:set(true)

		local var_1_0 = "common/icon/icon_diamond.png"
		local var_1_1 = "common/icon/icon_diamond.png"
		local var_1_2 = csv.yunying.yyhuodong[arg_1_0.diamondDataId].paramMap
		local var_1_3 = var_1_2.RMB1
		local var_1_4 = var_1_2.RMB10
		local var_1_5 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

		if var_1_5 > 0 then
			var_1_0 = dataEasy.getIconResByKey(game.ITEM_TICKET.diamondUpCard)
			var_1_3 = string.format("%s/%s", var_1_5, 1)
		end

		if var_1_5 >= 10 then
			var_1_1 = dataEasy.getIconResByKey(game.ITEM_TICKET.diamondUpCard)
			var_1_4 = string.format("%s/%s", var_1_5, 10)
		end

		arg_1_0.oneIconPath:set(var_1_0)
		arg_1_0.tenIconPath:set(var_1_1)
		arg_1_0.drawOnceCost:set(var_1_3)
		arg_1_0.drawTenCost:set(var_1_4)
		arg_1_0:initCards()
		arg_1_0:initCountDown()
	end,
	initCards = function(arg_2_0)
		local var_2_0 = csv.yunying.yyhuodong[arg_2_0.diamondDataId].clientParam.up
		local var_2_1 = csvSize(var_2_0)
		local var_2_2 = 20 + var_2_1 / 4 * 25

		arg_2_0.diamondUpCardPanel:removeAllChildren()

		local var_2_3 = {}

		for iter_2_0, iter_2_1 in csvPairs(var_2_0) do
			local var_2_4 = csv.cards[iter_2_1]
			local var_2_5 = csv.unit[var_2_4.unitID].rarity

			table.insert(var_2_3, {
				id = iter_2_1,
				rarity = var_2_5
			})
		end

		table.sort(var_2_3, function(arg_3_0, arg_3_1)
			return arg_3_0.rarity < arg_3_1.rarity
		end)

		for iter_2_2, iter_2_3 in csvPairs(var_2_3) do
			local var_2_6 = arg_2_0:createCard(iter_2_3.id):addTo(arg_2_0.diamondUpCardPanel)

			var_2_6:setAnchorPoint(cc.p(0.5, -2))
			var_2_6:xy(arg_2_0.diamondUpCardPanel:size().width / 2 - (iter_2_2 - (var_2_1 + 1) / 2) * 20, -920 + var_2_1 * 5 + math.abs(iter_2_2 - (var_2_1 + 1) / 2) * 10)
			var_2_6:setRotation((iter_2_2 - (var_2_1 + 1) / 2) * (var_2_2 / var_2_1))
			var_2_6:z(5)
		end
	end,
	createCard = function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_0.cardItem:clone():show()

		var_4_0:show()

		local var_4_1 = csv.cards[arg_4_1]
		local var_4_2 = csv.unit[var_4_1.unitID]
		local var_4_3 = var_4_2.rarity
		local var_4_4 = var_4_2.cardShow
		local var_4_5 = var_4_2.cardShowScale
		local var_4_6 = var_4_2.cardShowPosC
		local var_4_7 = var_4_2.name
		local var_4_8 = var_4_2.natureType
		local var_4_9 = var_4_2.natureType2

		uiEasy.setIconName("card", arg_4_1, {
			advance = 1,
			space = true,
			node = var_4_0:get("name"),
			name = var_4_7
		})
		text.addEffect(var_4_0:get("name"), {
			color = ui.COLORS.NORMAL.WHITE
		})

		local var_4_10 = {
			nil,
			"z",
			"h",
			"c",
			"r"
		}

		var_4_0:get("bg"):texture(string.format("city/drawcard/draw/panel_card_%s.png", var_4_10[var_4_3]))
		var_4_0:get("rarity"):texture(ui.RARITY_ICON[var_4_3])

		if var_4_9 == nil then
			var_4_0:get("attr1"):texture(ui.ATTR_ICON[var_4_8])
			var_4_0:get("attr2"):hide()
		else
			var_4_0:get("attr1"):texture(ui.ATTR_ICON[var_4_8])
			var_4_0:get("attr2"):texture(ui.ATTR_ICON[var_4_9]):show()
		end

		local var_4_11 = var_4_0:get("bg"):size()
		local var_4_12 = ccui.Scale9Sprite:create()

		var_4_12:initWithFile(cc.rect(82, 82, 1, 1), "common/icon/mask_card.png")
		var_4_12:size(var_4_11.width - 39, var_4_11.height - 39):alignCenter(var_4_11)

		local var_4_13 = cc.Sprite:create(var_4_4)
		local var_4_14 = var_4_13:size()
		local var_4_15 = cc.p(var_4_6.x / var_4_5, -var_4_6.y / var_4_5)
		local var_4_16 = cc.size(var_4_11.width / var_4_5, var_4_11.height / var_4_5)
		local var_4_17 = cc.rect((var_4_14.width - var_4_16.width) / 2 - var_4_15.x, (var_4_14.height - var_4_16.height) / 2 - var_4_15.y, var_4_16.width, var_4_16.height)

		var_4_13:alignCenter(var_4_11):scale(var_4_5 + 0.2):setTextureRect(var_4_17)
		var_4_0:removeChildByName("clipping")
		cc.ClippingNode:create(var_4_12):setAlphaThreshold(0.1):size(var_4_11):alignCenter(var_4_0:size()):add(var_4_13):addTo(var_4_0, 5, "clipping")

		return var_4_0
	end,
	initCountDown = function(arg_5_0)
		local var_5_0 = arg_5_0.diamondUpCutDownPanel:get("textTime")
		local var_5_1 = csv.yunying.yyhuodong[arg_5_0.diamondDataId]
		local var_5_2 = gGameModel.role:read("yy_endtime")
		local var_5_3 = 0

		if var_5_2[arg_5_0.diamondDataId] then
			var_5_3 = var_5_2[arg_5_0.diamondDataId]
		else
			return
		end

		local var_5_4 = arg_5_0.diamondUpCutDownPanel

		bind.extend(arg_5_0, var_5_0, {
			class = "cutdown_label",
			props = {
				tag = 2,
				endTime = var_5_3,
				endFunc = function()
					arg_5_0.limitId:set(nil)
				end,
				onNode = function(arg_7_0)
					return
				end
			}
		})
	end,
	isEnoughToDrawFunc = function(arg_8_0, arg_8_1)
		local var_8_0 = arg_8_0.rmb:read()
		local var_8_1 = var_8_0
		local var_8_2 = csv.yunying.yyhuodong[arg_8_0.diamondDataId].paramMap
		local var_8_3 = var_8_2.RMB1
		local var_8_4 = var_8_2.RMB10
		local var_8_5 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

		if var_8_5 > 0 then
			var_8_3 = 1
			var_8_0 = var_8_5

			if var_8_5 >= 10 then
				var_8_4 = 10
				var_8_1 = var_8_5
			end
		end

		if arg_8_1 then
			return var_8_4 <= var_8_1
		else
			return var_8_3 <= var_8_0
		end
	end,
	drawOneClickFunc = function(arg_9_0)
		local var_9_0 = dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard)

		local function var_9_1()
			gGameApp:requestServer("/game/yy/award/draw", function(arg_11_0)
				audio.pauseMusic()
				audio.playEffectWithWeekBGM("drawcard_one.mp3")

				local var_11_0, var_11_1, var_11_2 = dataEasy.getRawTable(arg_11_0)
				local var_11_3 = dataEasy.getItems(var_11_0, var_11_1)
				local var_11_4
				local var_11_5 = {
					isFree = false,
					drawType = "diamond_up",
					times = 1,
					items = var_11_3,
					yyId = arg_9_0.diamondDataId,
					cb = function()
						arg_9_0:initAward()
					end
				}

				gGameUI:stackUI("city.drawcard.result", nil, nil, var_11_5)
				arg_9_0:initAward()
			end, arg_9_0.diamondDataId, "limit_up_rmb1")
		end

		local var_9_2 = csv.yunying.yyhuodong[arg_9_0.diamondDataId].paramMap

		if var_9_0 > 0 then
			var_9_1()
		else
			dataEasy.sureUsingDiamonds(var_9_1, var_9_2.RMB1)
		end
	end,
	drawTenClickFunc = function(arg_13_0)
		local var_13_0 = false

		if dataEasy.getNumByKey(game.ITEM_TICKET.diamondUpCard) < 10 then
			var_13_0 = true
		end

		local function var_13_1()
			gGameApp:requestServer("/game/yy/award/draw", function(arg_15_0)
				audio.pauseMusic()
				audio.playEffectWithWeekBGM("drawcard_ten.mp3")

				local var_15_0, var_15_1, var_15_2 = dataEasy.getRawTable(arg_15_0)
				local var_15_3 = dataEasy.getItems(var_15_0, var_15_1)
				local var_15_4
				local var_15_5 = {
					isFree = false,
					drawType = "diamond_up",
					times = 10,
					items = var_15_3,
					yyId = arg_13_0.diamondDataId,
					cb = function()
						arg_13_0:initAward()
					end
				}

				gGameUI:stackUI("city.drawcard.result", nil, nil, var_15_5)
				arg_13_0:initAward()

				if var_13_0 then
					userDefault.setCurrDayKey("diamondUpDrawTips", 0)
				end
			end, arg_13_0.diamondDataId, "limit_up_rmb10")
		end

		if var_13_0 and (matchLanguage({
			"kr"
		}) or userDefault.getCurrDayKey("diamondUpDrawTips", 1) == 1 and dataEasy.isUnlock("diamondUpDrawTips")) then
			local var_13_2 = csv.yunying.yyhuodong[arg_13_0.diamondDataId].paramMap.RMB10

			gGameUI:showDialog({
				isRich = true,
				clearFast = true,
				btnType = 2,
				content = string.format(gLanguageCsv.draw10CardTips, var_13_2),
				cb = function()
					var_13_1()
				end
			})
		else
			var_13_1()
		end
	end,
	onPerviewClick = function(arg_18_0)
		gGameUI:stackUI("city.drawcard.preview", nil, {
			clickClose = true,
			blackLayer = true
		}, arg_18_0.curType:read(), arg_18_0.diamondDataId)
	end
}
