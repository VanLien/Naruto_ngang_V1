return {
	initPageItemFunc = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
		arg_1_0:addEffectInRect("effect/shipinchouka.skel", "shipinchouka")
		arg_1_0.isLimitDraw:set(false)

		local var_1_0 = arg_1_7 < 1

		arg_1_0.isFree:set(var_1_0)
		arg_1_0.isCost:set(not var_1_0)
		arg_1_0.freeTxt:text(gLanguageCsv.freeCount)
		arg_1_0.txtFree:text(gLanguageCsv.free)
		text.addEffect(arg_1_0.txtFree, {
			color = cc.c4b(60, 237, 60, 255)
		})
		arg_1_0.freeTimes:set("1/1")
		arg_1_0.isCutDown:set(false)

		local var_1_1 = "common/icon/icon_diamond.png"
		local var_1_2 = "common/icon/icon_diamond.png"
		local var_1_3 = gCommonConfigCsv.drawEquipCostPrice
		local var_1_4 = gCommonConfigCsv.draw10EquipCostPrice
		local var_1_5 = dataEasy.getNumByKey(game.ITEM_TICKET.equipCard)

		if not var_1_0 and var_1_5 > 0 then
			var_1_1 = dataEasy.getIconResByKey(game.ITEM_TICKET.equipCard)
			var_1_3 = string.format("%s/%s", var_1_5, 1)
		end

		if var_1_5 >= 10 then
			var_1_2 = dataEasy.getIconResByKey(game.ITEM_TICKET.equipCard)
			var_1_4 = string.format("%s/%s", var_1_5, 10)
		end

		arg_1_0.oneIconPath:set(var_1_1)
		arg_1_0.tenIconPath:set(var_1_2)
		arg_1_0.drawOnceCost:set(var_1_3)
		arg_1_0.drawTenCost:set(var_1_4)
	end,
	isEnoughToDrawFunc = function(arg_2_0, arg_2_1)
		local var_2_0 = arg_2_0.rmb:read()
		local var_2_1 = var_2_0
		local var_2_2 = gCommonConfigCsv.drawEquipCostPrice
		local var_2_3 = gCommonConfigCsv.draw10EquipCostPrice
		local var_2_4 = dataEasy.getNumByKey(game.ITEM_TICKET.equipCard)

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
		arg_3_0.canClick:set(false)

		local var_3_0 = arg_3_0.isFree:read()
		local var_3_1 = dataEasy.getNumByKey(game.ITEM_TICKET.equipCard)

		local function var_3_2()
			gGameApp:requestServer("/game/lottery/equip/draw", function(arg_5_0)
				local var_5_0 = arg_3_0.imgBG:getChildByName("shipinchouka")

				if var_5_0 then
					var_5_0:play("effect")
					performWithDelay(var_5_0, function()
						arg_3_0.canClick:set(true)
						var_5_0:play("effect_loop")

						local var_6_0, var_6_1, var_6_2 = dataEasy.getRawTable(arg_5_0)
						local var_6_3 = dataEasy.getItems(var_6_0, var_6_1)

						var_6_3[1].equip_awake_frag = 1

						local var_6_4 = {
							isFree = false,
							drawType = "equip",
							times = 1,
							items = var_6_3
						}

						gGameUI:stackUI("city.drawcard.result", nil, {
							full = false
						}, var_6_4)
					end, 2)
				end
			end, var_3_0 and "free1" or "rmb1")
		end

		if var_3_0 or var_3_1 > 0 then
			var_3_2()
		else
			dataEasy.sureUsingDiamonds(var_3_2, gCommonConfigCsv.drawEquipCostPrice)
		end
	end,
	drawTenClickFunc = function(arg_7_0)
		local var_7_0 = false

		if dataEasy.getNumByKey(game.ITEM_TICKET.equipCard) < 10 then
			var_7_0 = true
		end

		local function var_7_1()
			arg_7_0.canClick:set(false)
			gGameApp:requestServer("/game/lottery/equip/draw", function(arg_9_0)
				local var_9_0 = arg_7_0.imgBG:getChildByName("shipinchouka")

				if var_9_0 then
					var_9_0:play("effect")
					performWithDelay(var_9_0, function()
						arg_7_0.canClick:set(true)
						var_9_0:play("effect_loop")

						local var_10_0, var_10_1, var_10_2 = dataEasy.getRawTable(arg_9_0)
						local var_10_3 = dataEasy.getItems(var_10_0, var_10_1)

						var_10_3[1].equip_awake_frag = 10

						local var_10_4 = {
							isFree = false,
							drawType = "equip",
							times = 10,
							items = var_10_3
						}

						gGameUI:stackUI("city.drawcard.result", nil, {
							full = false
						}, var_10_4)
					end, 2)
				end

				if var_7_0 then
					userDefault.setCurrDayKey("equipDrawTips", 0)
				end
			end, "rmb10")
		end

		if var_7_0 and matchLanguage({
			"kr"
		}) or userDefault.getCurrDayKey("equipDrawTips", 1) == 1 and dataEasy.isUnlock("equipDrawTips") then
			local var_7_2 = gCommonConfigCsv.draw10EquipCostPrice

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
