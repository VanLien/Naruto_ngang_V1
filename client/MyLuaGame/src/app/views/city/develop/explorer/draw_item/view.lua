local var_0_0 = class("ExplorerDrawItemView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "explore_draw_item_view.json"
var_0_0.RESOURCE_BINDING = {
	["onePanel.specialTimes.time"] = "specialTimes",
	["topRightPanel.txt2"] = "txt2",
	["fivePanel.costPanel"] = "fiveCostPanel",
	["topRightPanel.txt1"] = "txt1",
	["onePanel.btn.icon"] = "oneCostIcon",
	["topRightPanel.num"] = "num",
	["onePanel.specialTimes"] = "specialTimesPanel",
	["onePanel.btn.free"] = "oneFreePanel",
	["onePanel.costPanel"] = "oneCostPanel",
	["fivePanel.btn.num"] = "fiveCostNum",
	["onePanel.btn.line"] = "originalNumLine",
	["onePanel.btn.num"] = "oneCostNum",
	["onePanel.costPanel.time1"] = "oneTime1",
	["fivePanel.btn.textNote"] = "textNoteFive",
	["onePanel.costPanel.time"] = "oneTime",
	["topRightPanel.bg"] = "topRightBg",
	bg = "bg",
	["topRightPanel.txt"] = "txt",
	["fivePanel.btn.icon"] = "fiveCostIcon",
	["onePanel.btn.originalNum"] = "originalNum",
	["topRightPanel.txt3"] = "txt3",
	["onePanel.btn.textNote"] = "textNote",
	["onePanel.btn"] = {
		varname = "oneBtn",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBtnOneClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "explorerFind",
					onNode = function(arg_1_0)
						arg_1_0:xy(arg_1_0:x() - 35, arg_1_0:y())
					end
				}
			}
		}
	},
	["fivePanel.btn"] = {
		varname = "fiveBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnFiveClick")
			}
		}
	},
	["fivePanel.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["onePanel.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	btnPreview = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnPreviewClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0)
	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_tonglingxunbao.png"
	})
	arg_2_0:initModel()
	adapt.setTextAdaptWithSize(arg_2_0.txt1, {
		margin = -5,
		vertical = "center",
		horizontal = "center",
		maxLine = 2,
		str = gLanguageCsv.updateDrawTimes,
		size = cc.size(560, 100)
	})
	adapt.oneLinePos(arg_2_0.txt1, {
		arg_2_0.txt2,
		arg_2_0.txt3
	})

	arg_2_0.isCutDown = idler.new(false)
	arg_2_0.isStandby = idler.new(true)

	arg_2_0.fiveCostIcon:texture(dataEasy.getIconResByKey("rmb"))
	arg_2_0.fiveCostNum:text(gCommonConfigCsv.draw5ItemCostPrice)
	idlereasy.any({
		arg_2_0.items,
		arg_2_0.itemFreeCounter,
		arg_2_0.rmb,
		arg_2_0.itemDiamondHalfCount
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.DrawItemFreeTimes)
		local var_3_1 = arg_3_1[game.ITEM_TICKET.card4] or 0
		local var_3_2 = arg_3_2 == 0
		local var_3_3 = arg_3_2 < var_3_0 + 1
		local var_3_4 = arg_3_4 == 0 and dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawItemHalf) ~= 0

		arg_2_0:initUI(var_3_1, var_3_2, var_3_3, var_3_4)

		if var_3_3 and not var_3_2 then
			local var_3_5 = var_3_0 - arg_3_2 + 1

			arg_2_0.specialTimes:text(string.format("%d/%d", var_3_5, var_3_0))
		elseif not var_3_2 and not var_3_3 then
			if var_3_4 then
				arg_2_0.oneCostNum:text(gCommonConfigCsv.drawItemCostPrice / 2)
				arg_2_0.oneCostIcon:texture(dataEasy.getIconResByKey("rmb"))
				arg_2_0.originalNum:text(gCommonConfigCsv.drawItemCostPrice)
				arg_2_0.originalNumLine:width(arg_2_0.originalNum:getContentSize().width + 10)
				adapt.oneLineCenterPos(cc.p(arg_2_0.oneBtn:width() / 2, arg_2_0.oneCostNum:y()), {
					arg_2_0.originalNumLine,
					arg_2_0.oneCostNum,
					arg_2_0.oneCostIcon
				}, cc.p(10, 0))
				arg_2_0.originalNum:x(arg_2_0.originalNumLine:x())
			else
				local var_3_6 = {
					arg_2_0.oneCostNum,
					arg_2_0.oneCostIcon
				}

				if var_3_1 > 0 then
					arg_2_0.oneCostNum:text(string.format("%s/%s", var_3_1, 1))
					arg_2_0.oneCostIcon:texture(dataEasy.getIconResByKey(game.ITEM_TICKET.card4))
					table.insert(var_3_6, 1, arg_2_0.textNote)
				else
					arg_2_0.oneCostNum:text(gCommonConfigCsv.drawItemCostPrice)
					arg_2_0.oneCostIcon:texture(dataEasy.getIconResByKey("rmb"))
				end

				adapt.oneLineCenterPos(cc.p(arg_2_0.oneBtn:width() / 2, arg_2_0.oneCostNum:y()), var_3_6, cc.p(10, 0))
			end

			arg_2_0.isCutDown:set(true)
		end

		if var_3_1 >= 5 then
			arg_2_0.textNoteFive:show()
			arg_2_0.fiveCostNum:text(var_3_1 .. "/5")
			arg_2_0.fiveCostIcon:texture(dataEasy.getIconResByKey(game.ITEM_TICKET.card4))
			adapt.oneLineCenterPos(cc.p(arg_2_0.fiveBtn:width() / 2, arg_2_0.fiveCostNum:y()), {
				arg_2_0.textNoteFive,
				arg_2_0.fiveCostNum,
				arg_2_0.fiveCostIcon
			}, cc.p(10, 0))
		else
			arg_2_0.fiveCostIcon:texture(dataEasy.getIconResByKey("rmb"))
			arg_2_0.fiveCostNum:text(gCommonConfigCsv.draw5ItemCostPrice)
			adapt.oneLineCenterPos(cc.p(arg_2_0.fiveBtn:width() / 2, arg_2_0.fiveCostNum:y()), {
				arg_2_0.fiveCostNum,
				arg_2_0.fiveCostIcon
			})
		end

		local var_3_7 = arg_3_3 < gCommonConfigCsv.drawItemCostPrice and var_3_1 <= 0 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

		if var_3_4 then
			var_3_7 = arg_3_3 < gCommonConfigCsv.drawItemCostPrice / 2 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.ALERT_GREEN
		end

		local var_3_8 = arg_3_3 < gCommonConfigCsv.draw5ItemCostPrice and var_3_1 < 5 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

		text.addEffect(arg_2_0.oneCostNum, {
			color = var_3_7
		})
		text.addEffect(arg_2_0.fiveCostNum, {
			color = var_3_8
		})
	end)
	idlereasy.when(arg_2_0.isCutDown, function(arg_4_0, arg_4_1)
		if arg_4_1 then
			local var_4_0 = time.getTodayStrInClock()

			if time.getTodayStrInClock() == time.getTodayStr() then
				local var_4_1 = time.getTimeTable()
				local var_4_2 = var_4_1.hour - 5
				local var_4_3 = var_4_1.min
				local var_4_4 = var_4_1.sec
				local var_4_5 = 86400 - var_4_2 * 3600 - var_4_3 * 60 - var_4_4

				arg_2_0.lastTime = var_4_5
			else
				local var_4_6 = time.getTimeTable()
				local var_4_7 = var_4_6.hour
				local var_4_8 = var_4_6.min
				local var_4_9 = var_4_6.sec
				local var_4_10 = 18000 - var_4_7 * 3600 - var_4_8 * 60 - var_4_9

				arg_2_0.lastTime = var_4_10
			end
		end
	end)
	arg_2_0:enableSchedule():schedule(function(arg_5_0)
		if arg_2_0.isCutDown:read() then
			arg_2_0.lastTime = arg_2_0.lastTime - 1

			arg_2_0.oneTime:text(time.getCutDown(arg_2_0.lastTime).str)
			adapt.oneLinePos(arg_2_0.oneTime1, arg_2_0.oneTime)

			if arg_2_0.lastTime == 0 then
				arg_2_0.isCutDown:set(false)

				return false
			end
		end
	end, 1, 0, "drawCardSchedule")
	idlereasy.any({
		arg_2_0.totalTime,
		arg_2_0.vip
	}, function(arg_6_0, arg_6_1, arg_6_2)
		arg_2_0.num:text(arg_6_1 .. "/" .. gVipCsv[arg_6_2].drawItemCountLimit)
		adapt.oneLinePos(arg_2_0.txt, arg_2_0.num)
		arg_2_0.topRightBg:size(arg_2_0.txt:size().width + arg_2_0.num:size().width - 50, 150)
		text.addEffect(arg_2_0.num, {
			color = arg_6_1 < gVipCsv[arg_6_2].drawItemCountLimit and ui.NEWCOLORS.GREEN2 or ui.NEWCOLORS.RED1
		})
	end)

	local var_2_0 = arg_2_0.bg:size()

	arg_2_0.spineChoujiang = widget.addAnimationByKey(arg_2_0.bg, "effect/shipinchouka.skel", "choujianghou", "effect_loop", 0):alignCenter(var_2_0):xy(var_2_0.width / 2, 0):scale(1)

	idlereasy.when(arg_2_0.isStandby, function(arg_7_0, arg_7_1)
		if type(arg_7_1) == "boolean" then
			if arg_7_1 then
				arg_2_0.spineChoujiang:play("effect_loop")
			else
				arg_2_0.spineChoujiang:play("effect_loop")
			end
		elseif arg_7_1 == 1 then
			arg_2_0:onBtnOneClick(false)
		elseif arg_7_1 == 5 then
			arg_2_0:onBtnFiveClick(false)
		else
			printWarn("val must be 1 or 5, current val is %", arg_7_1)
		end
	end)
end

function var_0_0.initUI(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = ""
	local var_8_1 = arg_8_2 or arg_8_3

	if arg_8_2 then
		var_8_0 = gLanguageCsv.freeOnce
	elseif arg_8_3 then
		var_8_0 = gLanguageCsv.privilege
	end

	arg_8_0.oneFreePanel:text(var_8_0)
	arg_8_0.oneFreePanel:visible(var_8_1)
	arg_8_0.oneCostPanel:visible(not var_8_1)
	arg_8_0.oneCostIcon:visible(not var_8_1)
	arg_8_0.oneCostNum:visible(not var_8_1)
	arg_8_0.originalNum:visible(arg_8_4 and not var_8_1)
	arg_8_0.originalNumLine:visible(arg_8_4 and not var_8_1)
	arg_8_0.textNote:visible(not arg_8_4 and not arg_8_3 and not arg_8_4 and arg_8_1 > 0)
	arg_8_0.specialTimesPanel:visible(arg_8_3 and not arg_8_2)
	arg_8_0.textNoteFive:hide()
end

function var_0_0.initModel(arg_9_0)
	arg_9_0.rmb = gGameModel.role:getIdler("rmb")
	arg_9_0.items = gGameModel.role:getIdler("items")
	arg_9_0.vip = gGameModel.role:getIdler("vip_level")
	arg_9_0.totalTime = gGameModel.daily_record:getIdler("draw_item")
	arg_9_0.itemFreeCounter = gGameModel.daily_record:getIdler("item_dc1_free_counter")
	arg_9_0.itemDiamondHalfCount = gGameModel.daily_record:getIdler("draw_item_rmb1_half")
end

function var_0_0.onBtnOneClick(arg_10_0, arg_10_1)
	local var_10_0
	local var_10_1 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.DrawItemFreeTimes)
	local var_10_2 = arg_10_0.itemFreeCounter:read() < var_10_1 + 1 and "free1" or "coin4_1"
	local var_10_3 = arg_10_0.items:read()[game.ITEM_TICKET.card4] or 0
	local var_10_4 = arg_10_0.itemDiamondHalfCount:read() == 0 and dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawItemHalf) ~= 0

	if gVipCsv[arg_10_0.vip:read()].drawItemCountLimit == arg_10_0.totalTime:read() and var_10_2 ~= "free1" then
		gGameUI:showTip(gLanguageCsv.todayDrawItemLimit)

		return
	end

	if var_10_4 and var_10_2 ~= "free1" and arg_10_0.rmb:read() < gCommonConfigCsv.drawItemCostPrice / 2 then
		uiEasy.showDialog("rmb")

		return
	end

	if not var_10_4 and var_10_3 == 0 and arg_10_0.rmb:read() < gCommonConfigCsv.drawItemCostPrice and var_10_2 ~= "free1" then
		uiEasy.showDialog("rmb")

		return
	end

	print(arg_10_0.itemDiamondHalfCount:read(), dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.FirstRMBDrawItemHalf), var_10_4, var_10_3)

	if type(arg_10_1) ~= "boolean" and (var_10_4 and var_10_2 ~= "free1" or not var_10_4 and var_10_3 == 0 and var_10_2 ~= "free1") then
		dataEasy.sureUsingDiamonds(function()
			arg_10_0:drawItem(var_10_2, arg_10_1)
		end, var_10_4 and gCommonConfigCsv.drawItemCostPrice / 2 or gCommonConfigCsv.drawItemCostPrice)
	else
		arg_10_0:drawItem(var_10_2, arg_10_1)
	end
end

function var_0_0.onBtnFiveClick(arg_12_0, arg_12_1)
	if gVipCsv[arg_12_0.vip:read()].drawItemCountLimit == arg_12_0.totalTime:read() then
		gGameUI:showTip(gLanguageCsv.todayDrawItemLimit)

		return
	elseif gVipCsv[arg_12_0.vip:read()].drawItemCountLimit - arg_12_0.totalTime:read() < 5 then
		gGameUI:showTip(gLanguageCsv.todayDrawItemTimesLessFive)

		return
	end

	local var_12_0 = arg_12_0.items:read()[game.ITEM_TICKET.card4] or 0

	if var_12_0 < 5 and arg_12_0.rmb:read() < gCommonConfigCsv.draw5ItemCostPrice then
		uiEasy.showDialog("rmb")

		return
	end

	if type(arg_12_1) ~= "boolean" and var_12_0 < 5 then
		dataEasy.sureUsingDiamonds(function()
			arg_12_0:drawItem("coin4_5", arg_12_1)
		end, gCommonConfigCsv.draw5ItemCostPrice)
	else
		arg_12_0:drawItem("coin4_5", arg_12_1)
	end
end

function var_0_0.drawItem(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/lottery/item/draw"):params(arg_14_1):onResponse(function()
		local var_15_0 = 0

		if arg_14_2 then
			arg_14_0.spineChoujiang:play("effect")

			var_15_0 = 2
		end

		performWithDelay(arg_14_0, function()
			var_14_0[1] = true
		end, var_15_0)
	end):wait(var_14_0):doit(function(arg_17_0)
		arg_14_0.isStandby:set(false)
		gGameUI:stackUI("city.develop.explorer.draw_item.success", nil, {
			clickClose = true,
			blackLayer = true
		}, arg_17_0.view, arg_14_0:createHandler("sendParams"))
	end)
end

function var_0_0.onBtnPreviewClick(arg_18_0)
	gGameUI:stackUI("city.drawcard.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, "component")
end

function var_0_0.sendParams(arg_19_0)
	return arg_19_0.isStandby
end

return var_0_0
