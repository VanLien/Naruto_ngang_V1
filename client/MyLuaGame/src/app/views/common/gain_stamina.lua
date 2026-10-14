local var_0_0 = require("app.views.city.activity.month_card")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("GainStaminaView", Dialog)

var_0_2.RESOURCE_FILENAME = "common_gain_stamina.json"
var_0_2.RESOURCE_BINDING = {
	["pricePanel.price"] = "priceText",
	["pricePanel.priceNote"] = "priceNote",
	content = "content",
	downPanel = "downPanel",
	["content.doublePanel"] = "doublePanel",
	["content.leftTimes2"] = "leftTimes2",
	["content.leftTimes1"] = "leftTimes1",
	["pricePanel.icon"] = "priceIcon",
	["downPanel.item"] = "item",
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["content.num"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("staminaBuyRecover")
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
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["downPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("staminaItem"),
				dataOrderCmp = function(arg_1_0, arg_1_1)
					if arg_1_0.quality ~= arg_1_1.quality then
						return arg_1_0.quality < arg_1_1.quality
					else
						return arg_1_0.staminanum < arg_1_1.staminanum
					end
				end,
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1:get("icon"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								bind.click(arg_2_0, arg_3_0, {
									method = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
								})
							end
						}
					})
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_5_0)
	arg_5_0:initModel()

	arg_5_0.price = idler.new(0)
	arg_5_0.staminaBuyRecover = idler.new(gCommonConfigCsv.staminaBuyRecover)
	arg_5_0.staminaItem = idlers.newWithMap({})

	arg_5_0.content:get("multiple"):hide()
	adapt.oneLineCenterPos(cc.p(775, 400), {
		arg_5_0.content:get("icon"),
		arg_5_0.content:get("num")
	})

	arg_5_0.leftTimes = idlereasy.any({
		arg_5_0.vipLevel,
		arg_5_0.buyStaminaTimes,
		arg_5_0.trainerLevel
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		local var_6_0 = gVipCsv[arg_6_1].buyStaminaTimes + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.StaminaBuyTimes)
		local var_6_1 = arg_5_0:refreshNumPanel(arg_6_2, var_6_0)

		if var_6_1 == 0 and arg_6_1 >= game.VIP_LIMIT then
			var_6_1 = -1
		end

		local var_6_2 = clone(gCostCsv.stamina_buy_cost)
		local var_6_3 = var_0_0.getPrivilegeAddition("staminaBuyFreeTimes")

		if var_6_3 then
			for iter_6_0 = 1, var_6_3 do
				table.insert(var_6_2, 1, 0)
			end
		end

		local var_6_4 = math.min(arg_6_2 + 1, table.length(var_6_2))

		arg_5_0.price:set(var_6_2[var_6_4])

		return true, var_6_1
	end)

	idlereasy.any({
		arg_5_0.price,
		arg_5_0.rmb
	}, function(arg_7_0, arg_7_1, arg_7_2)
		arg_5_0.priceText:text(arg_7_1)

		local var_7_0 = arg_7_2 < arg_7_1 and ui.COLORS.NORMAL.RED or ui.NEWCOLORS.BROWN1

		text.addEffect(arg_5_0.priceText, {
			color = var_7_0
		})
		adapt.oneLinePos(arg_5_0.priceText, arg_5_0.priceNote, cc.p(10, 0), "right")
		adapt.oneLinePos(arg_5_0.priceText, arg_5_0.priceIcon, cc.p(10, 0))
	end)

	local var_5_0 = csv.items
	local var_5_1 = 0

	idlereasy.any({
		arg_5_0.items
	}, function(arg_8_0, arg_8_1)
		local var_8_0 = {}

		for iter_8_0, iter_8_1 in pairs(arg_8_1) do
			var_5_1 = var_5_1 + 1

			if var_5_0[iter_8_0].specialArgsMap.stamina then
				table.insert(var_8_0, {
					key = iter_8_0,
					num = iter_8_1,
					quality = var_5_0[iter_8_0].quality,
					staminanum = var_5_0[iter_8_0].specialArgsMap.stamina
				})
			end
		end

		arg_5_0.staminaItem:update(var_8_0)

		if itertools.isempty(var_8_0) then
			arg_5_0.downPanel:hide()
		end
	end)
	Dialog.onCreate(arg_5_0, {
		clickClose = false
	})
end

function var_0_2.refreshNumPanel(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2 - arg_9_1

	arg_9_0.leftTimes1:text(var_9_0)

	local var_9_1 = var_9_0 > 0 and ui.NEWCOLORS.GREENLIGHT or ui.NEWCOLORS.RED1

	text.addEffect(arg_9_0.leftTimes1, {
		color = var_9_1
	})
	arg_9_0.leftTimes2:text("/" .. arg_9_2)
	adapt.oneLinePos(arg_9_0.leftTimes1, arg_9_0.leftTimes2)

	local var_9_2, var_9_3 = dataEasy.isDoubleHuodong("buyStamina")

	arg_9_0.doublePanel:visible(var_9_2)

	if var_9_2 then
		local var_9_4 = arg_9_0.doublePanel:get("text1")
		local var_9_5 = arg_9_0.doublePanel:get("text2")
		local var_9_6 = arg_9_0.doublePanel:get("text3")
		local var_9_7 = var_9_3[1].count or 0
		local var_9_8 = math.max(var_9_7 - arg_9_1, 0)
		local var_9_9 = var_9_8 == 0 and ui.COLORS.NORMAL.ALERT_ORANGE or cc.c4b(116, 190, 109, 255)

		text.addEffect(var_9_5, {
			color = var_9_9
		})
		var_9_5:text(var_9_8)
		var_9_6:text(string.format("/%s)", var_9_7))
		adapt.oneLinePos(var_9_4, {
			var_9_5,
			var_9_6
		}, cc.p(0, 0))
	end

	return var_9_0
end

function var_0_2.initModel(arg_10_0)
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.roleLevel = gGameModel.role:getIdler("level")
	arg_10_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_10_0.buyStaminaTimes = gGameModel.daily_record:getIdler("buy_stamina_times")
	arg_10_0.stamina = gGameModel.role:getIdler("stamina")
	arg_10_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
	arg_10_0.items = gGameModel.role:getIdler("items")
end

function var_0_2.onBuyItem(arg_11_0)
	idlereasy.do_(function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local function var_12_0()
			dataEasy.sureUsingDiamonds(function()
				gGameApp:requestServer("/game/role/stamina/buy", function(arg_15_0)
					gGameUI:showTip(gLanguageCsv.staminaBuySuccess)
				end)
			end, arg_12_3)
		end

		if arg_12_0 >= game.STAMINA_LIMIT then
			gGameUI:showTip(gLanguageCsv.staminaLimitToUse)
		elseif arg_12_1 == -1 then
			gGameUI:showTip(gLanguageCsv.commonVipMax, gLanguageCsv.staminaBuy)
		elseif arg_12_1 == 0 then
			uiEasy.showDialog("vip", {
				titleName = gLanguageCsv.staminaBuy
			}, {
				dialog = true
			})
		elseif arg_12_2 < arg_12_3 then
			uiEasy.showDialog("rmb", nil, {
				dialog = true
			})
		elseif gCommonConfigCsv.staminaBuyRecover + gGameModel.role:read("stamina") > game.STAMINA_LIMIT then
			local var_12_1 = {
				isRich = true,
				btnType = 2,
				cb = var_12_0,
				content = gLanguageCsv.buyEnergyOverflowTips
			}

			gGameUI:showDialog(var_12_1)
		else
			var_12_0()
		end
	end, arg_11_0.stamina, arg_11_0.leftTimes, arg_11_0.rmb, arg_11_0.price)
end

function var_0_2.onItemClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_0.stamina:read() >= game.STAMINA_LIMIT then
		gGameUI:showTip(gLanguageCsv.staminaFull)

		return
	end

	if arg_16_3.num <= 1 then
		arg_16_0:onUseCb(arg_16_3.key, arg_16_3.num)

		return
	end

	gGameUI:stackUI("common.buy_info", nil, nil, nil, {
		id = arg_16_3.key
	}, {
		contentType = "num",
		style = 2,
		flag = "use",
		num = arg_16_0:createHandler("num"),
		maxNum = arg_16_3.num
	}, arg_16_0:createHandler("onUseCb", arg_16_3.key))
end

function var_0_2.onUseCb(arg_17_0, arg_17_1, arg_17_2)
	gGameApp:requestServer("/game/role/stamina/use_item", function(arg_18_0)
		gGameUI:showTip(gLanguageCsv.useSuccess)
	end, arg_17_1, arg_17_2)
end

return var_0_2
