return {
	initPageItemFunc = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
		arg_1_0:addEffectInRect("effect/yuanbaochouka.skel", "yuanbaochouka")
		arg_1_0.isLimitDraw:set(false)

		local var_1_0 = arg_1_3 < 1

		arg_1_0.isFree:set(var_1_0)
		arg_1_0.freeTxt:text(gLanguageCsv.freeCount)
		arg_1_0.txtFree:text(gLanguageCsv.free)
		text.addEffect(arg_1_0.txtFree, {
			color = cc.c4b(60, 237, 60, 255)
		})
		arg_1_0.freeTimes:set("1/1")
		arg_1_0.isCutDown:set(false)

		local var_1_1 = "common/icon/icon_diamond.png"
		local var_1_2 = "common/icon/icon_diamond.png"
		local var_1_3 = gCommonConfigCsv.drawCardCostPrice
		local var_1_4 = gCommonConfigCsv.draw10CardCostPrice
		local var_1_5 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawCardHalf)

		if arg_1_5 == 0 and not var_1_0 and var_1_5 ~= 0 then
			arg_1_0.isHalf = true

			arg_1_0.isCost:set(false)
			arg_1_0.privilegePanel:show()

			local var_1_6 = arg_1_0.privilegePanel:multiget("line", "textNote", "imgIcon", "textCost", "textDiscount")

			var_1_6.textCost:text(var_1_3)
			var_1_6.textDiscount:text(var_1_3 * 0.5)
			var_1_6.line:size(var_1_6.textCost:size().width + 10, 7)
			adapt.oneLinePos(var_1_6.textNote, {
				var_1_6.textCost,
				var_1_6.textDiscount,
				var_1_6.imgIcon
			}, {
				cc.p(0, 0),
				cc.p(5, 0),
				cc.p(0, 0)
			})
			var_1_6.line:x(var_1_6.textCost:x() - 3)
		else
			arg_1_0.privilegePanel:hide()
			arg_1_0.isCost:set(not var_1_0)
		end

		local var_1_7 = dataEasy.getNumByKey(game.ITEM_TICKET.rmbCard)

		if not var_1_0 and var_1_7 > 0 then
			var_1_1 = dataEasy.getIconResByKey(game.ITEM_TICKET.rmbCard)
			var_1_3 = string.format("%s/%s", var_1_7, 1)
		end

		if var_1_7 >= 10 then
			var_1_2 = dataEasy.getIconResByKey(game.ITEM_TICKET.rmbCard)
			var_1_4 = string.format("%s/%s", var_1_7, 10)
		end

		arg_1_0.oneIconPath:set(var_1_1)
		arg_1_0.tenIconPath:set(var_1_2)
		arg_1_0.drawOnceCost:set(var_1_3)
		arg_1_0.drawTenCost:set(var_1_4)
	end,
	isEnoughToDrawFunc = function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_0.rmb:read()
		local var_2_1 = var_2_0
		local var_2_2 = gCommonConfigCsv.drawCardCostPrice
		local var_2_3 = gCommonConfigCsv.draw10CardCostPrice
		local var_2_4 = arg_2_0.isHalf

		if var_2_4 then
			var_2_2 = var_2_2 / 2
		end

		local var_2_5 = dataEasy.getNumByKey(game.ITEM_TICKET.rmbCard)

		if var_2_5 > 0 then
			if not var_2_4 then
				var_2_2 = 1
				var_2_0 = var_2_5
			end

			if var_2_5 >= 10 then
				var_2_3 = 10
				var_2_1 = var_2_5
			end
		end

		if arg_2_1 then
			return var_2_3 <= var_2_1
		else
			return var_2_2 <= var_2_0
		end
	end,
	drawOneClickFunc = function(arg_3_0)
		local var_3_0 = arg_3_0.isFree:read()
		local var_3_1 = dataEasy.getNumByKey(game.ITEM_TICKET.rmbCard)

		local function var_3_2()
			gGameApp:requestServer("/game/lottery/card/draw", function(arg_5_0)
				audio.pauseMusic()
				audio.playEffectWithWeekBGM("drawcard_one.mp3")

				local var_5_0, var_5_1, var_5_2 = dataEasy.getRawTable(arg_5_0)
				local var_5_3 = dataEasy.getItems(var_5_0, var_5_1)
				local var_5_4
				local var_5_5 = {
					drawType = "diamond",
					times = 1,
					items = var_5_3,
					isFree = var_3_0,
					cb = function()
						arg_3_0:initAward()
					end
				}

				gGameUI:stackUI("city.drawcard.result", nil, nil, var_5_5)
				arg_3_0:initAward()
			end, var_3_0 and "free1" or "rmb1")
		end

		if var_3_0 or var_3_1 > 0 or arg_3_0.isHalf then
			var_3_2()
		else
			dataEasy.sureUsingDiamonds(var_3_2, gCommonConfigCsv.drawCardCostPrice)
		end
	end,
	drawTenClickFunc = function(arg_7_0)
		local var_7_0 = false

		if dataEasy.getNumByKey(game.ITEM_TICKET.rmbCard) < 10 then
			var_7_0 = true
		end

		local function var_7_1()
			gGameApp:requestServer("/game/lottery/card/draw", function(arg_9_0)
				audio.pauseMusic()
				audio.playEffectWithWeekBGM("drawcard_ten.mp3")

				local var_9_0, var_9_1, var_9_2 = dataEasy.getRawTable(arg_9_0)
				local var_9_3 = dataEasy.getItems(var_9_0, var_9_1)
				local var_9_4
				local var_9_5 = {
					isFree = false,
					drawType = "diamond",
					times = 10,
					items = var_9_3,
					cb = function()
						arg_7_0:initAward()
					end
				}

				gGameUI:stackUI("city.drawcard.result", nil, nil, var_9_5)

				if var_7_0 then
					userDefault.setCurrDayKey("diamondDrawTips", 0)
				end

				arg_7_0:initAward()
			end, "rmb10")
		end

		if var_7_0 and (matchLanguage({
			"kr"
		}) or userDefault.getCurrDayKey("diamondDrawTips", 1) == 1 and dataEasy.isUnlock("diamondDrawTips")) then
			local var_7_2 = gCommonConfigCsv.draw10CardCostPrice

			gGameUI:showDialog({
				isRich = true,
				clearFast = true,
				btnType = 2,
				content = string.format(gLanguageCsv.draw10CardTips, var_7_2),
				cb = function()
					var_7_1()
				end
			})
		else
			var_7_1()
		end
	end
}
