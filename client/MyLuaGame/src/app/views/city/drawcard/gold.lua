return {
	initPageItemFunc = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
		arg_1_0:addEffectInRect("effect/tongqianchouka.skel", "tongqianchouka")
		arg_1_0.isLimitDraw:set(false)

		local var_1_0 = gCommonConfigCsv.drawGoldFreeRefreshDuration - (time.getTime() - arg_1_0.lastDrawTime:read()) > 0
		local var_1_1 = arg_1_2 < tonumber(gCommonConfigCsv.drawGoldFreeLimit) and not var_1_0
		local var_1_2
		local var_1_3 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FreeGoldDrawCardTimes)
		local var_1_4

		if arg_1_6 < var_1_3 then
			var_1_1 = true

			arg_1_0.freeTxt:text(gLanguageCsv.privilegeCount)
			arg_1_0.txtFree:text(gLanguageCsv.privilege)
			text.addEffect(arg_1_0.txtFree, {
				color = cc.c4b(255, 241, 1, 255)
			})

			var_1_2 = false
			var_1_4 = var_1_3 - arg_1_6 .. "/" .. var_1_3
		else
			arg_1_0.freeTxt:text(gLanguageCsv.freeCount)
			arg_1_0.txtFree:text(gLanguageCsv.free)
			text.addEffect(arg_1_0.txtFree, {
				color = cc.c4b(60, 237, 60, 255)
			})

			var_1_4 = gCommonConfigCsv.drawGoldFreeLimit - arg_1_2 .. "/" .. gCommonConfigCsv.drawGoldFreeLimit
			var_1_2 = arg_1_2 < tonumber(gCommonConfigCsv.drawGoldFreeLimit) and var_1_0
		end

		arg_1_0.isFree:set(var_1_1)
		arg_1_0.isCost:set(not var_1_1)
		arg_1_0.isCutDown:set(var_1_2, true)
		arg_1_0.freeTimes:set(var_1_4)

		local var_1_5 = "common/icon/icon_gold.png"
		local var_1_6 = "common/icon/icon_gold.png"
		local var_1_7 = gCommonConfigCsv.drawGoldCostPrice
		local var_1_8 = gCommonConfigCsv.draw10GoldCostPrice
		local var_1_9 = dataEasy.getNumByKey(game.ITEM_TICKET.goldCard)

		if not var_1_1 and var_1_9 > 0 then
			var_1_5 = dataEasy.getIconResByKey(game.ITEM_TICKET.goldCard)
			var_1_7 = string.format("%s/%s", var_1_9, 1)
		end

		if var_1_9 >= 10 then
			var_1_6 = dataEasy.getIconResByKey(game.ITEM_TICKET.goldCard)
			var_1_8 = string.format("%s/%s", var_1_9, 10)
		end

		arg_1_0.oneIconPath:set(var_1_5)
		arg_1_0.tenIconPath:set(var_1_6)
		arg_1_0.drawOnceCost:set(var_1_7)
		arg_1_0.drawTenCost:set(var_1_8)
	end,
	isEnoughToDrawFunc = function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_0.gold:read()
		local var_2_1 = var_2_0
		local var_2_2 = gCommonConfigCsv.drawGoldCostPrice
		local var_2_3 = gCommonConfigCsv.draw10GoldCostPrice
		local var_2_4 = dataEasy.getNumByKey(game.ITEM_TICKET.goldCard)

		if var_2_4 > 0 then
			var_2_2 = 1
			var_2_0 = var_2_4

			if var_2_4 >= 10 then
				var_2_3 = 10
				var_2_1 = var_2_4
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

		gGameApp:requestServer("/game/lottery/card/draw", function(arg_4_0)
			audio.pauseMusic()
			audio.playEffectWithWeekBGM("drawcard_one.mp3")

			local var_4_0, var_4_1, var_4_2 = dataEasy.getRawTable(arg_4_0)
			local var_4_3 = dataEasy.getItems(var_4_0, var_4_1)
			local var_4_4 = {
				drawType = "gold",
				times = 1,
				items = var_4_3,
				isFree = var_3_0
			}

			gGameUI:stackUI("city.drawcard.result", nil, nil, var_4_4)
		end, var_3_0 and "free_gold1" or "gold1")
	end,
	drawTenClickFunc = function(arg_5_0)
		gGameApp:requestServer("/game/lottery/card/draw", function(arg_6_0)
			audio.pauseMusic()
			audio.playEffectWithWeekBGM("drawcard_ten.mp3")

			local var_6_0, var_6_1, var_6_2 = dataEasy.getRawTable(arg_6_0)
			local var_6_3 = dataEasy.getItems(var_6_0, var_6_1)
			local var_6_4 = {
				isFree = false,
				drawType = "gold",
				times = 10,
				items = var_6_3
			}

			gGameUI:stackUI("city.drawcard.result", nil, nil, var_6_4)
		end, "gold10")
	end
}
