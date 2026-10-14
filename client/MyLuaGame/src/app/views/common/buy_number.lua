local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("BuyNumberView", Dialog)

var_0_1.RESOURCE_FILENAME = "card_buy_capacity.json"
var_0_1.RESOURCE_BINDING = {
	["pricePanel.price"] = "priceText",
	["pricePanel.priceNote"] = "priceNote",
	["content.num"] = "addNum",
	title = "title",
	content = "content",
	["content.leftTimesInfo"] = "leftTimesInfo",
	["content.text1"] = "contentText",
	["content.leftTimes2"] = "leftTimes2",
	["content.leftTimes1"] = "leftTimes1",
	["pricePanel.icon"] = "priceIcon",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("callBackView")
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	buyBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyItem")
			}
		}
	},
	["buyBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.params = arg_1_1
	arg_1_0.cb = arg_1_2

	local var_1_0 = gGameModel.role:read("vip_level")

	arg_1_0.conversionNumMax = arg_1_1.itemType ~= 1 and gVipCsv[var_1_0].megaItemMaxTimes or gVipCsv[var_1_0].megaCommonItemMaxTimes

	arg_1_0.title:text(gLanguageCsv.conversionNum)
	arg_1_0.leftTimesInfo:text(gLanguageCsv.surplusTitle)
	arg_1_0.contentText:text(gLanguageCsv.hintConversionNumber)

	arg_1_0.conversionChanceMax = arg_1_0.params.itemType ~= 1 and gCommonConfigCsv.megaBuyChanceLimit or gCommonConfigCsv.megaCommonBuyChanceLimit

	arg_1_0.leftTimes2:text("/" .. arg_1_0.conversionChanceMax)

	arg_1_0.conversionBuyAddTimes = arg_1_0.params.itemType ~= 1 and gCommonConfigCsv.megaBuyAddTimes or gCommonConfigCsv.megaCommonBuyAddTimes

	arg_1_0.addNum:text("+" .. arg_1_0.conversionBuyAddTimes)

	if arg_1_1.icon then
		arg_1_0.priceIcon:texture(arg_1_1.icon)
	end

	arg_1_0:conversionUpdata()
	Dialog.onCreate(arg_1_0, {
		blackType = 2,
		clickClose = false
	})
end

function var_0_1.dataJudge(arg_2_0)
	local var_2_0 = gGameModel.daily_record:read("mega_convert_buy_times")
	local var_2_1 = var_2_0 and var_2_0[arg_2_0.params.id] or 0
	local var_2_2 = arg_2_0.params.itemType ~= 1 and "mega_item_convert_cost" or "mega_commonitem_convert_cost"
	local var_2_3 = math.min(var_2_1 + 1, csvSize(gCostCsv[var_2_2]))

	return gCostCsv[var_2_2][var_2_3], var_2_1
end

function var_0_1.conversionUpdata(arg_3_0)
	local var_3_0, var_3_1 = arg_3_0:dataJudge()
	local var_3_2 = gGameModel.role:read("rmb")

	arg_3_0.priceText:text(var_3_0)
	text.addEffect(arg_3_0.priceText, {
		color = var_3_0 <= var_3_2 and ui.COLORS.QUALITY_OUTLINE[1] or ui.COLORS.NORMAL.ALERT_ORANGE
	})
	arg_3_0.leftTimes1:text(arg_3_0.conversionChanceMax - var_3_1)
	arg_3_0.leftTimes2:x(arg_3_0.leftTimes1:x() + arg_3_0.leftTimes1:width())
	text.addEffect(arg_3_0.leftTimes1, {
		color = var_3_1 <= arg_3_0.conversionChanceMax and ui.COLORS.QUALITY_OUTLINE[1] or ui.COLORS.NORMAL.ALERT_ORANGE
	})
	adapt.oneLineCenterPos(cc.p(200, 0), {
		arg_3_0.priceNote,
		arg_3_0.priceText,
		arg_3_0.priceIcon
	}, cc.p(8, 0))
	adapt.oneLineCenterPos(cc.p(800, 260), {
		arg_3_0.leftTimesInfo,
		arg_3_0.leftTimes1,
		arg_3_0.leftTimes2
	}, cc.p(8, 0))
end

function var_0_1.onBuyItem(arg_4_0)
	local var_4_0, var_4_1 = arg_4_0:dataJudge()

	if var_4_1 >= arg_4_0.conversionChanceMax then
		gGameUI:showTip(gLanguageCsv.purchaseLimit)

		return
	end

	if var_4_0 > gGameModel.role:read("rmb") then
		gGameUI:showTip(gLanguageCsv.rmbNotEnough)

		return
	end

	local var_4_2 = gGameModel.role:read("mega_convert_times")

	if (var_4_2 and var_4_2[arg_4_0.params.id] or 0) + arg_4_0.conversionBuyAddTimes > arg_4_0.conversionNumMax then
		gGameUI:showTip(gLanguageCsv.megaConvertTimesLimit)

		return
	end

	dataEasy.sureUsingDiamonds(function()
		gGameApp:requestServer("/game/develop/mega/convert/buy", function(arg_6_0)
			gGameUI:showTip(gLanguageCsv.hasBuy)
			arg_4_0:conversionUpdata()
		end, arg_4_0.params.id)
	end, var_4_0)
end

function var_0_1.callBackView(arg_7_0)
	arg_7_0:addCallbackOnExit(arg_7_0.cb)
	var_0_0.onClose(arg_7_0)
end

return var_0_1
