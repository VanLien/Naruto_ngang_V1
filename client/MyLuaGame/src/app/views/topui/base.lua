local var_0_0 = {}

var_0_0.RESOURCE_FILENAME = "topui_stamina_recover.json"
var_0_0.RESOURCE_BINDING = {
	allRecover = "allRecover",
	buyTimes1 = "buyTimes1",
	buyTimes2 = "buyTimes2",
	nextRecover = "nextRecover"
}

local var_0_1 = class("TopuiBase", cc.load("mvc").ViewBase)

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0:getResourceNode()

	if var_1_0:get("leftTopPanel") then
		adapt.dockWithScreen(var_1_0:get("leftTopPanel"), "left", "up", false)
	end

	if var_1_0:get("rightTopPanel") then
		adapt.dockWithScreen(var_1_0:get("rightTopPanel"), "right", "up", false)
	end

	if var_1_0:get("rightTopClosePanel") then
		adapt.dockWithScreen(var_1_0:get("rightTopClosePanel"), "right", "up", false)
	end

	arg_1_2 = arg_1_2 or {}

	if matchLanguage({
		"en"
	}) then
		arg_1_2.subTitle = ""
	end

	for iter_1_0, iter_1_1 in ipairs(arg_1_1) do
		if iter_1_1 == "stamina" then
			arg_1_0:staminaInit()
		elseif iter_1_1 == "title" then
			arg_1_0:updateTitle(arg_1_2.title, arg_1_2.subTitle)
		end
	end
end

function var_0_1.staminaInit(arg_2_0)
	arg_2_0.stamina = gGameModel.role:getIdler("stamina")
	arg_2_0.level = gGameModel.role:getIdler("level")
	arg_2_0.staminaLRT = gGameModel.role:getIdler("stamina_last_recover_time")
	arg_2_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_2_0.buyStaminaTimes = gGameModel.daily_record:getIdler("buy_stamina_times")
	arg_2_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_2_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
	arg_2_0.showStamina = idler.new(0)
	arg_2_0.showStaminaMax = idlereasy.any({
		arg_2_0.level,
		arg_2_0.yyhuodongs,
		arg_2_0.trainerLevel
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		return true, dataEasy.getStaminaMax(arg_3_1, arg_3_3)
	end)

	arg_2_0:enableSchedule()
	arg_2_0:schedule(function()
		arg_2_0.showStamina:set(dataEasy.getStamina())
	end, 1, 1)
	idlereasy.any({
		arg_2_0.stamina,
		arg_2_0.showStaminaMax,
		arg_2_0.staminaLRT
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		arg_2_0.showStamina:set(dataEasy.getStamina())
	end)
	idlereasy.any({
		arg_2_0.showStamina,
		arg_2_0.showStaminaMax,
		arg_2_0.staminaLRT
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		arg_2_0.staminaText:text(arg_6_1)
		arg_2_0.staminaMaxText:text("/" .. arg_6_2)
		arg_2_0:unSchedule(1)

		if arg_6_1 <= arg_6_2 then
			text.deleteEffect(arg_2_0.staminaText, {
				"outline"
			})
			text.addEffect(arg_2_0.staminaText, {
				color = ui.NEWCOLORS.WHITE
			})

			if arg_6_1 < arg_6_2 then
				local var_6_0 = time.getTime() - arg_6_3
				local var_6_1 = game.STAMINA_COLD_TIME - var_6_0 % game.STAMINA_COLD_TIME

				arg_2_0:schedule(function()
					arg_2_0:unSchedule(1)

					arg_6_1 = dataEasy.getStamina()

					arg_2_0.showStamina:set(arg_6_1)
				end, game.STAMINA_COLD_TIME, var_6_1, 1)
			end
		else
			text.addEffect(arg_2_0.staminaText, {
				color = ui.NEWCOLORS.GREEN2
			})
		end

		adapt.oneLineCenterPos(cc.p(192, 50), {
			arg_2_0.staminaText,
			arg_2_0.staminaMaxText
		})
	end)

	arg_2_0.staminaInfo = gGameUI:createSimpleView(var_0_0, arg_2_0):init():hide()

	local var_2_0 = gGameUI:getConvertPos(arg_2_0.staminaPanel)
	local var_2_1 = arg_2_0.staminaInfo:getResourceNode():size()
	local var_2_2 = arg_2_0.staminaPanel:size()

	arg_2_0.staminaInfo:xy(var_2_0.x - var_2_1.width + var_2_2.width / 2 - display.uiOrigin.x, var_2_0.y - var_2_1.height - var_2_2.height / 2)

	local var_2_3 = gGameUI:getConvertPos(arg_2_0.staminaInfo)
	local var_2_4 = ccui.Layout:create():anchorPoint(0, 0):size(display.sizeInView):xy(-var_2_3.x - display.uiOrigin.x * 2, -var_2_3.y):addTo(arg_2_0.staminaInfo, -1)

	var_2_4:setTouchEnabled(true)
	var_2_4:onClick(function()
		arg_2_0.staminaInfo:hide()
		gGameUI:unModal(arg_2_0.staminaInfo)
	end)

	local function var_2_5(arg_9_0)
		if arg_9_0 <= 0 then
			arg_2_0.staminaInfo.nextRecover:text(gLanguageCsv.staminaFull)
			arg_2_0.staminaInfo.allRecover:text(gLanguageCsv.staminaFull)
			text.addEffect(arg_2_0.staminaInfo.nextRecover, {
				color = ui.NEWCOLORS.GREEN2
			})
			text.addEffect(arg_2_0.staminaInfo.allRecover, {
				color = ui.NEWCOLORS.GREEN2
			})
		else
			arg_2_0.staminaInfo.nextRecover:text(time.getCutDown(arg_9_0 % game.STAMINA_COLD_TIME).str)
			arg_2_0.staminaInfo.allRecover:text(time.getCutDown(arg_9_0).str)
			text.addEffect(arg_2_0.staminaInfo.nextRecover, {
				color = ui.NEWCOLORS.WHITE
			})
			text.addEffect(arg_2_0.staminaInfo.allRecover, {
				color = ui.NEWCOLORS.WHITE
			})
		end
	end

	idlereasy.any({
		arg_2_0.showStamina,
		arg_2_0.showStaminaMax,
		arg_2_0.staminaLRT
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		arg_2_0:unSchedule(2)

		if arg_10_2 <= arg_10_1 then
			var_2_5(0)
		else
			local var_10_0 = time.getTime() - arg_10_3
			local var_10_1 = game.STAMINA_COLD_TIME - var_10_0 % game.STAMINA_COLD_TIME
			local var_10_2 = (arg_10_2 - arg_10_1 - 1) * game.STAMINA_COLD_TIME + var_10_1

			var_2_5(var_10_2)
			arg_2_0:schedule(function()
				var_10_2 = var_10_2 - 1

				var_2_5(var_10_2)

				if var_10_2 <= 0 then
					return false
				end
			end, 1, 1, 2)
		end
	end)
	idlereasy.any({
		arg_2_0.vipLevel,
		arg_2_0.buyStaminaTimes
	}, function(arg_12_0, arg_12_1, arg_12_2)
		arg_2_0.staminaInfo.buyTimes1:text(arg_12_2)
		arg_2_0.staminaInfo.buyTimes2:text("/" .. gVipCsv[arg_12_1].buyStaminaTimes)
		adapt.oneLinePos(arg_2_0.staminaInfo.buyTimes1, arg_2_0.staminaInfo.buyTimes2, nil, "left")

		if arg_12_2 > 0 then
			text.addEffect(arg_2_0.staminaInfo.buyTimes1, {
				color = ui.NEWCOLORS.GREEN2
			})
		else
			text.addEffect(arg_2_0.staminaInfo.buyTimes1, {
				color = ui.NEWCOLORS.WHITE
			})
		end
	end)
end

function var_0_1.updateTitle(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.title:texture(arg_13_1 or "")
	arg_13_0.subTitleText:text(arg_13_2 or "")
	adapt.oneLinePos(arg_13_0.title, arg_13_0.subTitleText, cc.p(15, 0))
end

function var_0_1.onGoldClick(arg_14_0)
	gGameUI:stackUI("common.gain_gold")
end

function var_0_1.onVouLimitClick(arg_15_0)
	if not dataEasy.isUnlock("trainer") then
		gGameUI:showTip(dataEasy.getUnlockTip("trainer"))

		return
	end

	if not gGameUI:goBackInStackUI("city.develop.trainer.view") then
		gGameUI:stackUI("city.develop.trainer.view", nil, {
			full = true
		})
	end
end

function var_0_1.onVoucherClick(arg_16_0)
	if not gGameUI:goBackInStackUI("city.vourcher") then
		gGameUI:stackUI("city.vourcher", nil, {
			full = true
		})
	end
end

function var_0_1.onDiamondClick(arg_17_0)
	if not gGameUI:goBackInStackUI("city.recharge") then
		gGameUI:stackUI("city.recharge", nil, {
			full = true
		})
	end
end

function var_0_1.sendRequestBuyItem(arg_18_0, arg_18_1, arg_18_2)
	gGameApp:requestServer("/game/buy_item", function(arg_19_0)
		gGameUI:showTip(gLanguageCsv.hasBuy)
	end, arg_18_1, arg_18_2)
end

function var_0_1.onRmbCardClick(arg_20_0)
	local var_20_0 = game.ITEM_TICKET.rmbCard
	local var_20_1 = csv.items[var_20_0]
	local var_20_2, var_20_3 = csvNext(var_20_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		rmb = var_20_3
	}, {
		id = var_20_0
	}, {
		contentType = "num"
	}, arg_20_0:createHandler("sendRequestBuyItem", var_20_0))
end

function var_0_1.onSkinCardClick(arg_21_0)
	gGameUI:showTip(gLanguageCsv.skinTip07)
end

function var_0_1.onGoldCardClick(arg_22_0)
	local var_22_0 = game.ITEM_TICKET.goldCard
	local var_22_1 = csv.items[var_22_0]
	local var_22_2, var_22_3 = csvNext(var_22_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		gold = var_22_3
	}, {
		id = var_22_0
	}, {
		contentType = "num"
	}, arg_22_0:createHandler("sendRequestBuyItem", var_22_0))
end

function var_0_1.onLimitCardClick(arg_23_0)
	local var_23_0 = game.ITEM_TICKET.limitCard
	local var_23_1 = csv.items[var_23_0]
	local var_23_2, var_23_3 = csvNext(var_23_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		rmb = var_23_3
	}, {
		id = var_23_0
	}, {
		contentType = "num"
	}, arg_23_0:createHandler("sendRequestBuyItem", var_23_0))
end

function var_0_1.onEquipCardClick(arg_24_0)
	local var_24_0 = game.ITEM_TICKET.equipCard
	local var_24_1 = csv.items[var_24_0]
	local var_24_2, var_24_3 = csvNext(var_24_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		rmb = var_24_3
	}, {
		id = var_24_0
	}, {
		contentType = "num"
	}, arg_24_0:createHandler("sendRequestBuyItem", var_24_0))
end

function var_0_1.onDiamondUpCardClick(arg_25_0)
	local var_25_0 = game.ITEM_TICKET.diamondUpCard
	local var_25_1 = csv.items[var_25_0]
	local var_25_2, var_25_3 = csvNext(var_25_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		rmb = var_25_3
	}, {
		id = var_25_0
	}, {
		contentType = "num"
	}, arg_25_0:createHandler("sendRequestBuyItem", var_25_0))
end

function var_0_1.buyTickets(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = game.ITEM_TICKET[arg_26_1]
	local var_26_1 = csv.items[var_26_0]
	local var_26_2, var_26_3 = csvNext(var_26_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		[arg_26_2] = var_26_3
	}, {
		id = var_26_0
	}, {
		contentType = "num"
	}, arg_26_0:createHandler("sendRequestBuyItem", var_26_0))
end

function var_0_1.onStaminaLongTouch(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_2.name == "click" then
		arg_27_0:onStaminaClick()
	elseif arg_27_2.name == "began" then
		arg_27_0.staminaInfo:show()
		gGameUI:doModal(arg_27_0.staminaInfo)
	elseif arg_27_2.name == "ended" or arg_27_2.name == "cancelled" then
		arg_27_0.staminaInfo:hide()
		gGameUI:unModal(arg_27_0.staminaInfo)
	end
end

function var_0_1.onStaminaClick(arg_28_0)
	gGameUI:stackUI("common.gain_stamina")
end

function var_0_1.onluckyEggCardClick(arg_29_0)
	local var_29_0 = game.ITEM_TICKET.luckyEggCard
	local var_29_1 = csv.items[var_29_0]
	local var_29_2, var_29_3 = csvNext(var_29_1.specialArgsMap)

	gGameUI:stackUI("common.buy_info", nil, nil, {
		rmb = var_29_3
	}, {
		id = var_29_0
	}, {
		contentType = "num"
	}, arg_29_0:createHandler("sendRequestBuyItem", var_29_0))
end

function var_0_1.onUnionCoinClick(arg_30_0)
	if dataEasy.notUseUnionBuild() then
		gGameUI:showTip(gLanguageCsv.cannotUseBuilding)

		return
	end

	gGameUI:stackUI("city.union.contrib.view")
end

function var_0_1.onDrawcardCoinClick(arg_31_0)
	if not gGameUI:goBackInStackUI("city.drawcard.view") then
		gGameUI:stackUI("city.drawcard.view", nil, {
			full = true
		}, "equip")
	end
end

function var_0_1.onFragmentCoinClick(arg_32_0)
	if not dataEasy.isUnlock(gUnlockCsv.cardReborn) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.cardReborn))

		return
	end

	if not gGameUI:goBackInStackUI("city.card.rebirth.view") then
		gGameUI:stackUI("city.card.rebirth.view", nil, {
			full = true
		}, 1, 2)
	end
end

function var_0_1.onPvpCoinClick(arg_33_0)
	if not dataEasy.isUnlock(gUnlockCsv.arena) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.arena))

		return
	end

	if not gGameUI:goBackInStackUI("city.pvp.arena.view") then
		gGameApp:requestServer("/game/pw/battle/get", function(arg_34_0)
			gGameUI:stackUI("city.pvp.arena.view")
		end)
	end
end

function var_0_1.onUnionCombetClick(arg_35_0)
	local var_35_0 = gGameModel.role:read("level")
	local var_35_1 = gGameModel.union:read("level")

	for iter_35_0, iter_35_1 in orderCsvPairs(csv.sysopen) do
		if iter_35_1.goTo == "unionFight" then
			if not dataEasy.isUnlock(iter_35_1.feature) then
				gGameUI:showTip(dataEasy.getUnlockTip(iter_35_1.feature))

				return
			end

			if var_35_1 < iter_35_1.unionlevel then
				gGameUI:showTip(gLanguageCsv.unionLevelLessNoOpened)

				return
			end

			jumpEasy.jumpTo("unionFight")

			return
		end
	end
end

function var_0_1.onExplorerCoinClick(arg_36_0)
	if not dataEasy.isUnlock(gUnlockCsv.explorer) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.explorer))

		return
	end

	if not gGameUI:goBackInStackUI("city.develop.explorer.view") then
		gGameUI:stackUI("city.develop.explorer.view", nil, {
			full = true
		})
	end
end

function var_0_1.onRandomTowerCoinClick(arg_37_0)
	if not dataEasy.isUnlock(gUnlockCsv.randomTower) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.randomTower))

		return
	end

	if not gGameUI:goBackInStackUI("city.adventure.random_tower.view") then
		gGameApp:requestServer("/game/random_tower/prepare", function(arg_38_0)
			gGameUI:stackUI("city.adventure.random_tower.view", nil, {
				full = true
			})
		end)
	end
end

function var_0_1.onCraftCoinClick(arg_39_0)
	jumpEasy.jumpTo("craft")
end

function var_0_1.onCoinClick(arg_40_0)
	return
end

function var_0_1.onVipCoinClick(arg_41_0)
	return
end

function var_0_1.onBallClick(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1:getName()

	if var_42_0 == "ballPanel1" then
		local var_42_1 = csv.items[game.SPRITE_BALL_ID.normal].specialArgsMap.buy_gold
		local var_42_2 = gGameModel.role:read("gold")

		gGameUI:stackUI("common.buy_info", nil, nil, {
			gold = var_42_1
		}, {
			id = game.SPRITE_BALL_ID.normal
		}, {
			contentType = "num"
		}, arg_42_0:createHandler("showBuyInfo"))
	elseif var_42_0 == "ballPanel2" then
		if not gGameUI:goBackInStackUI("city.shop") then
			gGameApp:requestServer("/game/fixshop/get", function(arg_43_0)
				gGameUI:stackUI("city.shop", nil, {
					full = true
				}, game.SHOP_INIT.FIX_SHOP)
			end)
		end
	else
		gGameUI:showTip(string.format(gLanguageCsv.getInActOrMysteryShop))
	end
end

function var_0_1.onCrossCraftCoinClick(arg_44_0)
	jumpEasy.jumpTo("crossCraft")
end

function var_0_1.onCrossArenaCoinClick(arg_45_0)
	jumpEasy.jumpTo("crossArena")
end

function var_0_1.onCrossMineCoinClick(arg_46_0)
	if not arg_46_0.sign then
		jumpEasy.jumpTo("crossMine")
	end
end

function var_0_1.showBuyInfo(arg_47_0, arg_47_1)
	if csv.items[game.SPRITE_BALL_ID.normal].specialArgsMap.buy_level > gGameModel.role:read("level") then
		gGameUI:showTip(gLanguageCsv.buyItemLevelLimit)

		return
	else
		gGameApp:requestServer("/game/ball/buy_item", function(arg_48_0)
			gGameUI:showTip(gLanguageCsv.hasBuy)
		end, game.SPRITE_BALL_ID.normal, arg_47_1)
	end
end

function var_0_1.onOnlineFightCoinClick(arg_49_0)
	jumpEasy.jumpTo("onlineFight")
end

function var_0_1.onTotemCoinClick(arg_50_0)
	jumpEasy.jumpTo("totemDecompose")
end

return var_0_1
