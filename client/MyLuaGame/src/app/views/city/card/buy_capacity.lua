local var_0_0 = class("CardCapacityView", Dialog)

var_0_0.RESOURCE_FILENAME = "card_buy_capacity.json"
var_0_0.RESOURCE_BINDING = {
	["pricePanel.priceNote"] = "priceNote",
	["pricePanel.price"] = "priceText",
	content = "content",
	["content.leftTimesInfo"] = "leftTimesInfo",
	["content.leftTimes2"] = "leftTimes2",
	["content.leftTimes1"] = "leftTimes1",
	["pricePanel.icon"] = "priceIcon",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
						color = ui.NEWCOLORS.OUTLINE.WHITE
					}
				}
			}
		}
	},
	["content.num"] = {
		binds = {
			event = "text",
			data = "+" .. gCommonConfigCsv.cardBagCapacityIncrease
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
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0:initModel()

	arg_1_0.price = idler.new(0)

	adapt.oneLineCenterPos(cc.p(775, 400), {
		arg_1_0.Text1,
		arg_1_0.num
	}, cc.p(10, 0))

	arg_1_0.leftTimes = idlereasy.any({
		arg_1_0.vipLevel,
		arg_1_0.nowBuyNum
	}, function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = gVipCsv[arg_2_1].cardbgBuyNum
		local var_2_1 = arg_1_0:refreshNumPanel(arg_2_2, var_2_0)

		if var_2_1 == 0 and arg_2_1 >= game.VIP_LIMIT then
			var_2_1 = -1
		end

		local var_2_2 = gCostCsv.cardbag_buy_cost
		local var_2_3 = math.min(arg_2_2 + 1, table.length(var_2_2))

		arg_1_0.price:set(var_2_2[var_2_3])

		return true, var_2_1
	end)

	idlereasy.any({
		arg_1_0.price,
		arg_1_0.rmb
	}, function(arg_3_0, arg_3_1, arg_3_2)
		arg_1_0.priceText:text(arg_3_1)

		local var_3_0 = arg_3_2 < arg_3_1 and ui.COLORS.NORMAL.RED or ui.NEWCOLORS.BROWN1

		text.addEffect(arg_1_0.priceText, {
			color = var_3_0
		})
		adapt.oneLineCenterPos(cc.p(155, 15), {
			arg_1_0.priceNote,
			arg_1_0.priceIcon,
			arg_1_0.priceText
		}, cc.p(20, 0))
	end)
	Dialog.onCreate(arg_1_0, {
		clickClose = false
	})
end

function var_0_0.refreshNumPanel(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2 - arg_4_1

	arg_4_0.leftTimes1:text(var_4_0)

	local var_4_1 = var_4_0 > 0 and ui.NEWCOLORS.GREENLIGHT or ui.NEWCOLORS.RED1

	text.addEffect(arg_4_0.leftTimes1, {
		color = var_4_1
	})
	arg_4_0.leftTimes2:text("/" .. arg_4_2)
	adapt.oneLineCenterPos(cc.p(arg_4_0.content:width() / 2, arg_4_0.leftTimes2:y()), {
		arg_4_0.leftTimesInfo,
		arg_4_0.leftTimes1,
		arg_4_0.leftTimes2
	}, cc.p(0, 0))

	return var_4_0
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.rmb = gGameModel.role:getIdler("rmb")
	arg_5_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_5_0.nowBuyNum = gGameModel.role:getIdler("card_capacity_times")
	arg_5_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
end

function var_0_0.onBuyItem(arg_6_0)
	idlereasy.do_(function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		if arg_7_1 == -1 then
			gGameUI:showTip(gLanguageCsv.cardCapacityBuyLimit)
		elseif arg_7_1 == 0 then
			local var_7_0 = {
				gLanguageCsv.cardCapacityBuyMax,
				string.format(gLanguageCsv.commonVipIncrease, gLanguageCsv.buy)
			}

			uiEasy.showDialog("vip", {
				titleName = gLanguageCsv.cardCapacityBuy,
				content = var_7_0
			})
		elseif arg_7_2 < arg_7_3 then
			uiEasy.showDialog("rmb")
		else
			dataEasy.sureUsingDiamonds(function()
				gGameApp:requestServer("/game/role/card_capacity/buy", function(arg_9_0)
					gGameUI:showTip(gLanguageCsv.hasBuy)
				end)
			end, arg_7_3)
		end
	end, arg_6_0.cardCapacity, arg_6_0.leftTimes, arg_6_0.rmb, arg_6_0.price)
end

return var_0_0
