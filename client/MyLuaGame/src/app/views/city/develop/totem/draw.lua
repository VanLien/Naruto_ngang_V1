local var_0_0 = class("TotemDrawView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "totem_draw.json"
var_0_0.RESOURCE_BINDING = {
	["onePanel.costPanel.bg"] = "cutDownBg",
	["onePanel.btn.icon"] = "oneCostIcon",
	["onePanel.costPanel"] = "oneCostPanel",
	["onePanel.specialTimes.time"] = "specialTimes",
	["onePanel.btn.line"] = "originalNumLine",
	bg = "bg",
	["fivePanel.btn.icon"] = "fiveCostIcon",
	["onePanel.btn.originalNum"] = "originalNum",
	["onePanel.btn.num"] = {
		varname = "oneCostNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["fivePanel.btn.num"] = {
		varname = "fiveCostNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["onePanel.btn.free"] = {
		varname = "oneFreePanel",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["fivePanel.btn.textNote"] = {
		varname = "textNoteFive",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["onePanel.btn.textNote"] = {
		varname = "textNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
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
					specialTag = "totemFree",
					onNode = function(arg_1_0)
						arg_1_0.xy(arg_1_0, arg_1_0.x(arg_1_0) - 35, arg_1_0.y(arg_1_0) - 20)
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
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["onePanel.btn.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["onePanel.costPanel.time1"] = {
		varname = "oneTime1",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["onePanel.costPanel.time"] = {
		varname = "oneTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["topRightPanel.txt"] = {
		varname = "txt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["topRightPanel.num"] = {
		varname = "num",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["topRightPanel.txt1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["btnPreview.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["btnPreview.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
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
	},
	btnExchange = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnExchangeClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0)
	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "DRAW",
		title = "common/txt/txt_bt_xunmi.png"
	})
	arg_2_0:initModel()

	arg_2_0.isCutDown = idler.new(false)
	arg_2_0.isStandby = idler.new(true)

	arg_2_0.fiveCostIcon:texture(dataEasy.getIconResByKey("rmb"))
	arg_2_0.fiveCostNum:text(gCommonConfigCsv.draw6TotemCostPrice)
	idlereasy.any({
		arg_2_0.items,
		arg_2_0.itemFreeCounter,
		arg_2_0.rmb
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		local var_3_0 = arg_3_1[game.ITEM_TICKET.totemCard] or 0
		local var_3_1 = arg_3_2 == 0
		local var_3_2 = false

		arg_2_0:initUI(var_3_0, var_3_1, var_3_2)

		if not var_3_1 then
			if var_3_2 then
				arg_2_0.oneCostNum:text(gCommonConfigCsv.drawTotemCostPrice / 2)
				arg_2_0.oneCostIcon:texture(dataEasy.getIconResByKey("rmb"))
				arg_2_0.originalNum:text(gCommonConfigCsv.drawTotemCostPrice)
				arg_2_0.originalNumLine:width(arg_2_0.originalNum:getContentSize().width + 10)
				adapt.oneLineCenterPos(cc.p(arg_2_0.oneBtn:width() / 2, arg_2_0.oneCostNum:y()), {
					arg_2_0.originalNumLine,
					arg_2_0.oneCostNum,
					arg_2_0.oneCostIcon
				}, cc.p(10, 0))
				arg_2_0.originalNum:x(arg_2_0.originalNumLine:x())
			else
				local var_3_3 = {
					arg_2_0.textNote,
					arg_2_0.oneCostNum,
					arg_2_0.oneCostIcon
				}

				if var_3_0 > 0 then
					arg_2_0.oneCostNum:text(string.format("%s/%s", var_3_0, 1))
					arg_2_0.oneCostIcon:texture(dataEasy.getIconResByKey(game.ITEM_TICKET.totemCard))
				else
					arg_2_0.oneCostNum:text(gCommonConfigCsv.drawTotemCostPrice)
					arg_2_0.oneCostIcon:texture(dataEasy.getIconResByKey("rmb"))
				end

				adapt.oneLineCenterPos(cc.p(arg_2_0.oneBtn:width() / 2, arg_2_0.oneCostNum:y()), var_3_3, cc.p(10, 0))
			end

			arg_2_0.isCutDown:set(true)
		end

		if var_3_0 >= 6 then
			arg_2_0.textNoteFive:show()
			arg_2_0.fiveCostNum:text(var_3_0 .. "/6")
			arg_2_0.fiveCostIcon:texture(dataEasy.getIconResByKey(game.ITEM_TICKET.totemCard))
			adapt.oneLineCenterPos(cc.p(arg_2_0.fiveBtn:width() / 2, arg_2_0.fiveCostNum:y()), {
				arg_2_0.textNoteFive,
				arg_2_0.fiveCostNum,
				arg_2_0.fiveCostIcon
			}, {
				cc.p(10, 0),
				cc.p(10, 0)
			})
		else
			arg_2_0.fiveCostIcon:texture(dataEasy.getIconResByKey("rmb"))
			arg_2_0.fiveCostNum:text(gCommonConfigCsv.draw6TotemCostPrice)
			adapt.oneLineCenterPos(cc.p(arg_2_0.fiveBtn:width() / 2, arg_2_0.fiveCostNum:y()), {
				arg_2_0.textNoteFive,
				arg_2_0.fiveCostNum,
				arg_2_0.fiveCostIcon
			}, {
				cc.p(10, 0),
				cc.p(10, 0)
			})
		end

		local var_3_4 = arg_3_3 < gCommonConfigCsv.drawTotemCostPrice and var_3_0 <= 0 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

		if var_3_2 then
			var_3_4 = arg_3_3 < gCommonConfigCsv.drawTotemCostPrice / 2 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.ALERT_GREEN
		end

		local var_3_5 = arg_3_3 < gCommonConfigCsv.draw6TotemCostPrice and var_3_0 < 5 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE

		text.addEffect(arg_2_0.oneCostNum, {
			color = var_3_4
		})
		text.addEffect(arg_2_0.fiveCostNum, {
			color = var_3_5
		})
	end)
	idlereasy.when(arg_2_0.isCutDown, function(arg_4_0, arg_4_1)
		if arg_4_1 then
			local var_4_0 = time.getTodayStrInClock()

			arg_2_0.lastTime = time.getNumTimestamp(var_4_0, time.getRefreshHour()) - time.getTime()
		end
	end)
	adapt.oneLinePos(arg_2_0.oneTime1, arg_2_0.oneTime, cc.p(0, 0))
	arg_2_0:enableSchedule():schedule(function(arg_5_0)
		if arg_2_0.isCutDown:read() and arg_2_0.lastTime then
			arg_2_0.lastTime = arg_2_0.lastTime - 1

			arg_2_0.oneTime:text(time.getCutDown(arg_2_0.lastTime).str)
			adapt.oneLinePos(arg_2_0.oneTime1, arg_2_0.oneTime, cc.p(0, 0))
			arg_2_0.cutDownBg:width(arg_2_0.oneTime1:width() + arg_2_0.oneTime:width() + 180)

			if arg_2_0.lastTime == 0 then
				arg_2_0.isCutDown:set(false)
				arg_2_0.itemFreeCounter:notify()
			end
		end
	end, 1, 0, "drawCardSchedule")
	idlereasy.any({
		arg_2_0.totalTime,
		arg_2_0.vip
	}, function(arg_6_0, arg_6_1, arg_6_2)
		arg_2_0.num:text(arg_6_1 .. "/" .. gVipCsv[arg_6_2].drawTotemCountLimit)
		adapt.oneLinePos(arg_2_0.num, arg_2_0.txt, cc.p(0, 0), "right")
		text.addEffect(arg_2_0.num, {
			color = arg_6_1 < gVipCsv[arg_6_2].drawTotemCountLimit and ui.COLORS.NORMAL.LIGHT_GREEN or ui.COLORS.NORMAL.ALERT_YELLOW
		})
	end)

	local var_2_0 = cc.Sprite:create("city/develop/totem/bg.png")

	var_2_0:setScale(2):xy(1560, 720)
	arg_2_0:getResourceNode():addChild(var_2_0)

	local var_2_1 = widget.addAnimationByKey(arg_2_0:getResourceNode(), "totem/xmck.skel", "choujianghou", "effect_loop", 0)

	var_2_1:anchorPoint(cc.p(0.5, 0.5))
	var_2_1:xy(arg_2_0:getResourceNode():width() / 2, arg_2_0:getResourceNode():height() / 2)

	arg_2_0.spineChoujiang = var_2_1:scale(2)

	idlereasy.when(arg_2_0.isStandby, function(arg_7_0, arg_7_1)
		if type(arg_7_1) == "boolean" then
			arg_2_0.spineChoujiang:play("effect_loop")
		elseif arg_7_1 == 1 then
			arg_2_0:onBtnOneClick(false)
		elseif arg_7_1 == 6 then
			arg_2_0:onBtnFiveClick(false)
		else
			printWarn("val must be 1 or 6, current val is %", arg_7_1)
		end
	end)
end

function var_0_0.initUI(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = ""

	if arg_8_2 then
		var_8_0 = gLanguageCsv.freeOnce
	end

	arg_8_0.oneFreePanel:text(var_8_0)
	arg_8_0.oneFreePanel:visible(arg_8_2)
	arg_8_0.oneCostPanel:visible(not arg_8_2)
	arg_8_0.oneCostIcon:visible(not arg_8_2)
	arg_8_0.oneCostNum:visible(not arg_8_2)
	arg_8_0.originalNum:visible(arg_8_3 and not arg_8_2)
	arg_8_0.originalNumLine:visible(arg_8_3 and not arg_8_2)
	arg_8_0.textNote:visible(not arg_8_3 and not arg_8_2)
end

function var_0_0.initModel(arg_9_0)
	arg_9_0.rmb = gGameModel.role:getIdler("rmb")
	arg_9_0.vip = gGameModel.role:getIdler("vip_level")
	arg_9_0.items = gGameModel.role:getIdler("items")
	arg_9_0.totalTime = gGameModel.daily_record:getIdler("draw_totem")
	arg_9_0.itemFreeCounter = gGameModel.daily_record:getIdler("totem_rmb_dc1_free_count")
end

function var_0_0.onBtnOneClick(arg_10_0, arg_10_1)
	local var_10_0
	local var_10_1 = arg_10_0.itemFreeCounter:read() < 1 and "free1" or "rmb1"
	local var_10_2 = dataEasy.getNumByKey(game.ITEM_TICKET.totemCard) or 0
	local var_10_3 = false

	if gVipCsv[arg_10_0.vip:read()].drawTotemCountLimit == arg_10_0.totalTime:read() and var_10_1 ~= "free1" then
		gGameUI:showTip(gLanguageCsv.todayDrawTotemLimit)

		return
	end

	if var_10_3 and var_10_1 ~= "free1" and arg_10_0.rmb:read() < gCommonConfigCsv.drawTotemCostPrice / 2 then
		uiEasy.showDialog("rmb")

		return
	end

	if not var_10_3 and var_10_2 == 0 and arg_10_0.rmb:read() < gCommonConfigCsv.drawTotemCostPrice and var_10_1 ~= "free1" then
		uiEasy.showDialog("rmb")

		return
	end

	if type(arg_10_1) ~= "boolean" and (var_10_3 and var_10_1 ~= "free1" or not var_10_3 and var_10_2 == 0 and var_10_1 ~= "free1") then
		dataEasy.sureUsingDiamonds(function()
			arg_10_0:drawItem(var_10_1, arg_10_1)
		end, var_10_3 and gCommonConfigCsv.drawTotemCostPrice / 2 or gCommonConfigCsv.drawTotemCostPrice)
	else
		arg_10_0.drawItem(arg_10_0, var_10_1, arg_10_1)
	end
end

function var_0_0.onBtnFiveClick(arg_12_0, arg_12_1)
	if gVipCsv[arg_12_0.vip:read()].drawTotemCountLimit == arg_12_0.totalTime:read() then
		gGameUI:showTip(gLanguageCsv.todayDrawTotemLimit)

		return
	elseif gVipCsv[arg_12_0.vip:read()].drawTotemCountLimit - arg_12_0.totalTime:read() < 6 then
		gGameUI:showTip(gLanguageCsv.todayDrawItemTimesLessSix)

		return
	end

	local var_12_0 = arg_12_0.items:read()[game.ITEM_TICKET.totemCard] or 0

	if var_12_0 < 6 and arg_12_0.rmb:read() < gCommonConfigCsv.draw6TotemCostPrice then
		uiEasy.showDialog("rmb")

		return
	end

	if type(arg_12_1) ~= "boolean" and var_12_0 < 6 then
		dataEasy.sureUsingDiamonds(function()
			arg_12_0:drawItem("rmb6", arg_12_1)
		end, gCommonConfigCsv.draw6TotemCostPrice)
	else
		arg_12_0.drawItem(arg_12_0, "rmb6", arg_12_1)
	end
end

function var_0_0.drawItem(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/lottery/totem/draw"):params(arg_14_1):onResponse(function()
		local var_15_0 = 0

		if arg_14_2 then
			arg_14_0.spineChoujiang:play("effect")

			var_15_0 = 5.166666666666666
		end

		performWithDelay(arg_14_0, function()
			var_14_0[1] = true
		end, var_15_0)
	end):wait(var_14_0):doit(function(arg_17_0)
		arg_14_0.isStandby:set(false)
		gGameUI:stackUI("city.develop.totem.success", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_17_0.view, arg_14_0:createHandler("sendParams"))
	end)
end

function var_0_0.onBtnPreviewClick(arg_18_0)
	gGameUI:stackUI("city.develop.totem.preview", nil, {
		blackLayer = true,
		clickClose = true
	})
end

function var_0_0.onBtnExchangeClick(arg_19_0)
	gGameUI:stackUI("city.develop.totem.exchange", nil, {
		blackLayer = true
	})
end

function var_0_0.sendParams(arg_20_0)
	return arg_20_0.isStandby
end

return var_0_0
