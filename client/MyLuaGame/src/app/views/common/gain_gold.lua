local var_0_0 = {
	0.45599999999999996,
	0.48,
	0.6,
	0.648,
	0.696,
	0.72
}
local var_0_1 = require("app.views.city.activity.month_card")
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("GainGoldView", Dialog)

var_0_3.RESOURCE_FILENAME = "common_gain_gold.json"
var_0_3.RESOURCE_BINDING = {
	refresh2 = "refresh2",
	["goldPanel.info"] = "goldPanelInfo",
	refreshIcon = "refreshIcon",
	["numPanel.info"] = "numPanelInfo",
	["boxPanel.bar"] = "boxBar",
	goldPanel = "goldPanel",
	boxPanel = "boxPanel",
	["numPanel.bg"] = "numPanelBg",
	tenPanel = "tenPanel",
	refresh3 = "refresh3",
	["numPanel.doublePanel"] = "doublePanel",
	refresh1 = "refresh1",
	["goldPanel.bg"] = "goldPanelBg",
	["goldPanel.num"] = "gainNum",
	onePanel = "onePanel",
	["numPanel.num1"] = "gainTimes1",
	refreshBg = "refreshBg",
	["goldPanel.icon"] = "gainIcon",
	["numPanel.num2"] = "gainTimes2",
	["onePanel.icon"] = "icon",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["onePanel.free"] = {
		varname = "free",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["onePanel.priceNote"] = {
		varname = "priceNote",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["onePanel.price"] = {
		varname = "price",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["tenPanel.priceNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["tenPanel.price"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["onePanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					return arg_1_0:onGainClick(1)
				end)
			}
		}
	},
	["tenPanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					return arg_2_0:onGainClick(10)
				end)
			}
		}
	},
	["onePanel.btn.text"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["tenPanel.btn.text"] = {
		varname = "tenBtnText",
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
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
	}
}

function var_0_3.onCreate(arg_3_0)
	arg_3_0:initModel()
	arg_3_0.refresh2:text(time.getRefreshHour())
	adapt.oneLinePos(arg_3_0.refresh3, {
		arg_3_0.refresh2,
		arg_3_0.refresh1,
		arg_3_0.refreshIcon
	}, {
		cc.p(10, 0),
		cc.p(10, 0),
		cc.p(10, 0)
	}, "right")
	arg_3_0.refreshBg:width(arg_3_0.refresh3:width() + arg_3_0.refresh2:width() + arg_3_0.refresh1:width() + arg_3_0.refreshIcon:width() + 100)

	local var_3_0 = {
		17,
		33,
		53,
		76
	}

	arg_3_0.leftTimes = idlereasy.any({
		arg_3_0.vipLevel,
		arg_3_0.lianjinTimes,
		arg_3_0.trainerLevel,
		arg_3_0.trainerSkills
	}, function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = gVipCsv[arg_4_1].lianJinTimes + (var_0_1.getPrivilegeAddition("lianjinFreeTimes") or 0) + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.LianjinBuyTimes) + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.LianjinFreeTimes)

		arg_3_0:refreshNumPanel(arg_4_2, var_4_0)

		local var_4_1 = var_4_0 - arg_4_2

		if var_4_1 == 0 and arg_4_1 >= game.VIP_LIMIT then
			var_4_1 = -1
		end

		local var_4_2 = {}

		for iter_4_0, iter_4_1 in orderCsvPairs(gVipCsv[arg_4_1].lianJinGift) do
			table.insert(var_4_2, iter_4_0)
		end

		local var_4_3 = mathEasy.showProgress(var_3_0, var_4_2, arg_4_2)

		if not arg_3_0.percent then
			arg_3_0.percent = clone(var_4_3)

			arg_3_0.boxBar:setPercent(arg_3_0.percent)
		else
			local var_4_4 = 0.01

			arg_3_0:enableSchedule():schedule(function()
				if var_4_4 > 0.0005 then
					var_4_4 = var_4_4 - 0.0005
				end

				arg_3_0.percent = arg_3_0.percent + 1

				arg_3_0.boxBar:setPercent(math.min(var_4_3, arg_3_0.percent))

				if arg_3_0.percent >= var_4_3 then
					arg_3_0:unSchedule("GainGoldViewPercent")
				end
			end, var_4_4, 0, "GainGoldViewPercent")
		end

		if arg_3_0.goldPanel:get("privilege") then
			arg_3_0.goldPanel:get("privilege"):removeSelf()
		end

		uiEasy.setPrivilegeRichText(game.PRIVILEGE_TYPE.LianjinDropRate, arg_3_0.goldPanel, gLanguageCsv.gold, cc.p(20, 155), true, "#C0x57472e#")

		return true, var_4_1
	end)

	idlereasy.any({
		arg_3_0.lianjinTimes,
		arg_3_0.lianjinFreeTimes,
		arg_3_0.leftTimes
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		arg_6_1 = math.max(arg_6_1 - arg_6_2, 0)

		local var_6_0 = (var_0_1.getPrivilegeAddition("lianjinFreeTimes") or 0) + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.LianjinFreeTimes)
		local var_6_1 = gCostCsv.lianjin_cost
		local var_6_2 = math.min(arg_6_1 + 1, table.length(var_6_1))

		arg_3_0.cost = var_6_1[var_6_2]

		if arg_6_2 < var_6_0 then
			arg_3_0.cost = 0
		end

		local var_6_3 = 0
		local var_6_4 = cc.clampf(arg_6_3, 1, 10)
		local var_6_5 = var_6_4 - math.max(var_6_0 - arg_6_2, 0)

		for iter_6_0 = 1, var_6_5 do
			var_6_3 = var_6_3 + var_6_1[math.min(arg_6_1 + iter_6_0, table.length(var_6_1))]
		end

		arg_3_0.tenCost = var_6_3

		arg_3_0.free:visible(arg_3_0.cost <= 0)
		arg_3_0.icon:visible(arg_3_0.cost > 0)
		arg_3_0.price:visible(arg_3_0.cost > 0):text(arg_3_0.cost)
		arg_3_0.priceNote:visible(arg_3_0.cost > 0)
		arg_3_0.tenPanel:get("price"):text(var_6_3)
		arg_3_0.tenBtnText:text(string.format(gLanguageCsv.gainGoldMoreTimes, var_6_4))
		adapt.oneLineCenterPos(cc.p(arg_3_0.onePanel:size().width / 2, arg_3_0.price:y()), {
			arg_3_0.priceNote,
			arg_3_0.price,
			arg_3_0.icon
		}, cc.p(15, 0))

		local var_6_6 = arg_3_0.tenPanel:multiget("priceNote", "price", "icon")

		adapt.oneLineCenterPos(cc.p(arg_3_0.tenPanel:size().width / 2, var_6_6.price:y()), {
			var_6_6.priceNote,
			var_6_6.price,
			var_6_6.icon
		}, cc.p(15, 0))
	end)
	idlereasy.any({
		arg_3_0.lianjinTimes,
		arg_3_0.lianjinFreeTimes,
		arg_3_0.roleLevel
	}, function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		arg_7_1 = math.max(arg_7_1 - arg_7_2, 0)

		local var_7_0 = (var_0_1.getPrivilegeAddition("lianjinFreeTimes") or 0) + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.LianjinFreeTimes)
		local var_7_1 = gCostCsv.lianjin_gold_rate
		local var_7_2 = math.min(arg_7_1 + 1, table.length(var_7_1))

		if arg_7_2 < var_7_0 then
			var_7_2 = 1
		end

		local var_7_3 = gRoleLevelCsv[arg_7_3].lianJinGold * var_7_1[var_7_2]
		local var_7_4 = var_0_1.getPrivilegeAddition("lianjinRate")
		local var_7_5 = 1

		if var_7_4 then
			var_7_5 = var_7_5 + var_7_4
		end

		local var_7_6 = math.floor(var_7_3 * var_7_5)

		arg_3_0.gainNum:text("+" .. var_7_6)
		adapt.oneLinePos(arg_3_0.goldPanelInfo, {
			arg_3_0.gainNum,
			arg_3_0.gainIcon
		}, {
			cc.p(10, 0),
			cc.p(10, 0)
		})
		arg_3_0.goldPanelBg:width(arg_3_0.goldPanelInfo:width() + arg_3_0.gainNum:width() + arg_3_0.gainIcon:width() + 85)
	end)
	idlereasy.any({
		arg_3_0.vipLevel,
		arg_3_0.lianjinGifts
	}, function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = 0

		for iter_8_0, iter_8_1 in orderCsvPairs(gVipCsv[arg_8_1].lianJinGift) do
			var_8_0 = var_8_0 + 1

			arg_3_0.boxPanel:get("num" .. var_8_0):text(iter_8_0)
			text.addEffect(arg_3_0.boxPanel:get("num" .. var_8_0), {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			})

			local var_8_1 = arg_8_2[iter_8_0]
			local var_8_2 = arg_3_0.boxPanel:get("box" .. var_8_0):texture(string.format("other/gain_gold/icon_box%s%d.png", var_8_1 == 0 and "_open" or "", var_8_0))

			if var_8_1 == 1 then
				local var_8_3 = widget.addAnimationByKey(arg_3_0.boxPanel, "effect/jiedianjiangli.skel", "gain_gold_box_effect" .. var_8_0, "effect_loop", var_8_2:z() - 1)
				local var_8_4 = var_8_2:size()

				var_8_3:scale(var_0_0[var_8_0]):x(var_8_2:x()):y(var_8_2:y() - var_8_4.height / 2)

				var_8_2.effectBox = var_8_3
			elseif var_8_2.effectBox then
				var_8_2.effectBox:hide()
				var_8_2.effectBox:removeFromParent()

				var_8_2.effectBox = nil
			end

			uiEasy.addVibrateToNode(arg_3_0, var_8_2, var_8_1 == 1)
			bind.touch(arg_3_0, var_8_2, {
				methods = {
					ended = functools.partial(arg_3_0.onBoxClick, arg_3_0, var_8_1, iter_8_0, var_8_2)
				}
			})
		end
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_3.refreshNumPanel(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.gainTimes1:text(arg_9_1)

	local var_9_0 = arg_9_1 < arg_9_2 and ui.COLORS.NORMAL.FRIEND_GREEN or ui.COLORS.NORMAL.DEFAULT

	text.addEffect(arg_9_0.gainTimes1, {
		color = var_9_0
	})
	arg_9_0.gainTimes2:text("/" .. arg_9_2)
	adapt.oneLinePos(arg_9_0.numPanelInfo, {
		arg_9_0.gainTimes1,
		arg_9_0.gainTimes2
	}, cc.p(5, 0))

	local var_9_1, var_9_2 = dataEasy.isDoubleHuodong("buyGold")

	arg_9_0.doublePanel:visible(var_9_1)
	arg_9_0.numPanelBg:height(var_9_1 and 168 or 114)

	if matchLanguage({
		"en"
	}) then
		arg_9_0.numPanelBg:width(var_9_1 and 375 or 360)
	elseif matchLanguage({
		"tw"
	}) then
		arg_9_0.numPanelBg:width(var_9_1 and 390 or 310)
	elseif matchLanguage({
		"kr"
	}) then
		arg_9_0.numPanelBg:width(var_9_1 and 460 or 400)
	end

	if var_9_1 then
		local var_9_3 = arg_9_0.doublePanel:get("text1")
		local var_9_4 = arg_9_0.doublePanel:get("text2")
		local var_9_5 = arg_9_0.doublePanel:get("text3")
		local var_9_6 = var_9_2[1].count or 1
		local var_9_7 = math.max(var_9_6 - arg_9_1, 0)
		local var_9_8 = var_9_7 == 0 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.COLORS.NORMAL.FRIEND_GREEN

		text.addEffect(var_9_4, {
			color = var_9_8
		})
		var_9_4:text(var_9_7)
		var_9_5:text(string.format("/%s)", var_9_6))
		adapt.oneLinePos(var_9_3, {
			var_9_4,
			var_9_5
		}, cc.p(0, 0))
	end
end

function var_0_3.initModel(arg_10_0)
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.roleLevel = gGameModel.role:getIdler("level")
	arg_10_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_10_0.lianjinTimes = gGameModel.daily_record:getIdler("lianjin_times")
	arg_10_0.lianjinFreeTimes = gGameModel.daily_record:getIdler("lianjin_free_times")
	arg_10_0.lianjinGifts = gGameModel.daily_record:getIdler("lianjin_gifts")
	arg_10_0.trainerLevel = gGameModel.role:getIdler("trainer_level")
	arg_10_0.trainerSkills = gGameModel.role:getIdler("trainer_skills")
end

function var_0_3.onGainClick(arg_11_0, arg_11_1)
	idlereasy.do_(function(arg_12_0, arg_12_1)
		if arg_12_0 == -1 then
			gGameUI:showTip(gLanguageCsv.commonVipMax, gLanguageCsv.gainGold)
		elseif arg_12_0 == 0 then
			uiEasy.showDialog("vip", {
				titleName = gLanguageCsv.gainGold
			})
		elseif arg_11_0.cost > 0 and arg_12_1 < arg_11_0.cost then
			uiEasy.showDialog("rmb")
		else
			local function var_12_0()
				gGameApp:requestServer("/game/role/lianjin", function(arg_14_0)
					gGameUI:stackUI("common.gain_gold_display", nil, nil, arg_14_0.view, arg_11_1)
				end, arg_11_1)
			end

			if arg_11_1 == 1 and arg_11_0.cost > 0 or arg_11_1 == 10 then
				local var_12_1 = arg_11_1 == 1 and arg_11_0.cost or arg_11_0.tenCost

				dataEasy.sureUsingDiamonds(var_12_0, var_12_1)
			else
				var_12_0()
			end
		end
	end, arg_11_0.leftTimes, arg_11_0.rmb)
end

function var_0_3.onBoxClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_1 == 1 then
		local var_15_0 = {
			false
		}

		gGameApp:requestServerCustom("/game/role/lianjin/total_award"):params(arg_15_2):onResponse(function(arg_16_0)
			uiEasy.setBoxEffect(arg_15_3, 1, function()
				var_15_0[1] = true
			end, 0, 0)
		end):wait(var_15_0):doit(function(arg_18_0)
			gGameUI:showGainDisplay(arg_18_0)
		end)
	elseif arg_15_1 == 0 then
		gGameUI:showBoxDetail({
			content = "",
			state = 0,
			data = gVipCsv[arg_15_0.vipLevel:read()].lianJinGift[arg_15_2]
		})
	else
		gGameUI:showBoxDetail({
			state = 1,
			data = gVipCsv[arg_15_0.vipLevel:read()].lianJinGift[arg_15_2],
			content = string.format(gLanguageCsv.canGetArriveAtJubaoNumber, arg_15_2)
		})
	end
end

return var_0_3
