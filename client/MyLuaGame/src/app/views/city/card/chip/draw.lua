local var_0_0 = {
	item = {
		gCommonConfigCsv.drawChipItemCostPrice,
		[10] = gCommonConfigCsv.draw10ChipItemCostPrice
	},
	rmb = {
		gCommonConfigCsv.drawChipCostPrice,
		[10] = gCommonConfigCsv.draw10ChipCostPrice
	}
}
local var_0_1 = gCommonConfigCsv.chipUpLimit
local var_0_2 = {
	item = 538,
	rmb = 537
}
local var_0_3 = {
	"city/drawcard/draw/icon_jfbx_dk.png",
	"city/drawcard/draw/icon_jfbx.png",
	"city/drawcard/draw/icon_jfbx1.png",
	"city/drawcard/draw/icon_jfbx2.png",
	"city/drawcard/draw/icon_jfbx3.png",
	"city/drawcard/draw/icon_jfbx3_dk.png"
}
local var_0_4 = {
	"city/drawcard/draw/box_wdd.png",
	"city/drawcard/draw/box_ydd.png"
}
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("ChipDrawView", var_0_5)

var_0_6.RESOURCE_FILENAME = "chip_draw.json"
var_0_6.RESOURCE_BINDING = {
	["panelDownRight.drawOnePanel2.textFree"] = "diamond1FreeTxt",
	["panelDownRight.drawTenPanel2.costInfo"] = "diamond10CostInfo",
	["panelUpRight.drawCountPanel.goldRecord"] = "itemRecord",
	["panelDownLeft.drawOnePanel.textFree"] = "item1FreeTxt",
	selectSuitItem = "selectSuitItem",
	["panelDownLeft.drawTenPanel.costInfo.textCost"] = "item10Cost",
	["panelUpRight.drawCountPanel.diamondRecord"] = "diamondRecord",
	["panelDownLeft.drawOnePanel.costInfo"] = "item1CostInfo",
	["panelUpRight.txtTip"] = "txtTip",
	["panelMidRight.downPanel"] = "downPanel",
	bg = "bg",
	["panelDownLeft.drawOnePanel.costInfo.textCost"] = "item1Cost",
	["panelDownLeft.drawTenPanel.costInfo"] = "item10CostInfo",
	["panelDownRight.drawOnePanel2.costInfo.textCost"] = "diamond1Cost",
	["panelDownRight.drawOnePanel2.costInfo"] = "diamond1CostInfo",
	["panelUpRight.drawCountPanel"] = "drawCountPanel",
	["panelDownRight.drawTenPanel2.costInfo.textCost"] = "diamond10Cost",
	["panelDownLeft.drawOnePanel"] = {
		varname = "item1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					return arg_1_0:draw("item", 1)
				end)
			}
		}
	},
	["panelDownLeft.drawOnePanel.cutDownPanel.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("time"),
			method = function(arg_2_0)
				if arg_2_0 == 0 then
					return ""
				end

				return time.getCutDown(arg_2_0).clock_str
			end
		}
	},
	["panelDownLeft.drawTenPanel"] = {
		varname = "item10",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					return arg_3_0:draw("item", 10)
				end)
			}
		}
	},
	["panelDownLeft.drawTenPanel.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["panelDownLeft.drawOnePanel.btnDraw"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				state = bindHelper.self("itemSign"),
				onNode = function(arg_4_0)
					arg_4_0:xy(285, 110):scale(0.85)
				end
			}
		}
	},
	["panelDownLeft.drawOnePanel.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["panelDownLeft.typePanel.imgAdd"] = {
		varname = "preview1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showPreview1")
			}
		}
	},
	["panelDownRight.drawOnePanel2"] = {
		varname = "rmb1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					return arg_5_0:draw("rmb", 1)
				end)
			}
		}
	},
	["panelDownRight.drawOnePanel2.cutDownPanel.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("time"),
			method = function(arg_6_0)
				if arg_6_0 == 0 then
					return ""
				end

				return time.getCutDown(arg_6_0).clock_str
			end
		}
	},
	["panelDownRight.drawTenPanel2"] = {
		varname = "rmb10",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0:draw("rmb", 10)
				end)
			}
		}
	},
	["panelDownRight.drawOnePanel2.btnDraw"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				state = bindHelper.self("rmbSign"),
				onNode = function(arg_8_0)
					arg_8_0:xy(285, 110):scale(0.85)
				end
			}
		}
	},
	["panelDownRight.drawOnePanel2.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["panelDownRight.drawTenPanel2.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["panelDownRight.typePanel2.imgAdd"] = {
		varname = "preview2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showPreview2")
			}
		}
	},
	["panelMidRight.btnRate"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickBtnRate")
			}
		}
	},
	["panelMidRight.btnRate.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelUpRight.panelSelectSuit"] = {
		varname = "panelSelectSuit",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSelectSuit")
			}
		}
	},
	["panelMidRight.downPanel.item1.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("livenessPoint1")
			}
		}
	},
	["panelMidRight.downPanel.item2.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("livenessPoint2")
			}
		}
	},
	["panelMidRight.downPanel.item3.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("livenessPoint3")
			}
		}
	},
	["panelMidRight.downPanel.item1.number"] = {
		varname = "numberAll",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelMidRight.downPanel.item2.number"] = {
		varname = "number2",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelMidRight.downPanel.item3.number"] = {
		varname = "number3",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelMidRight.downPanel.item4.number"] = {
		varname = "number4",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panelMidRight.downPanel.item2"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_9_0)
				return arg_9_0:onAwardClick(1)
			end)
		}
	},
	["panelMidRight.downPanel.item3"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_10_0)
				return arg_10_0:onAwardClick(2)
			end)
		}
	},
	["panelMidRight.downPanel.item4"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_11_0)
				return arg_11_0:onAwardClick(3)
			end)
		}
	}
}
var_0_6.RESOURCE_STYLES = {
	full = true
}

function var_0_6.clickBtnRate(arg_12_0)
	gGameUI:stackUI("city.card.chip.rate_preview")
end

function var_0_6.onCreate(arg_13_0)
	arg_13_0.preview1:visible(false)
	arg_13_0.preview2:visible(false)
	gGameUI.topuiManager:createView("default", arg_13_0, {
		onClose = arg_13_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_mijichouqu.png"
	})

	local var_13_0 = arg_13_0.bg:size()

	widget.addAnimationByKey(arg_13_0.bg, "effect/shipinchouka.skel", "effectBg", "effect_loop", 0):alignCenter(var_13_0):xy(var_13_0.width / 2, 0)
	arg_13_0.bg:scale(2)
	arg_13_0:initModel()

	local var_13_1 = idler.new(0)
	local var_13_2 = idler.new(0)

	arg_13_0.itemSign = idler.new(true)
	arg_13_0.rmbSign = idler.new(true)
	arg_13_0.selectUpSuitID = {}

	arg_13_0:initSelectSuitUI()
	idlereasy.when(arg_13_0.items, function(arg_14_0, arg_14_1)
		var_13_1:set(arg_14_1[var_0_2.item])
		var_13_2:set(arg_14_1[var_0_2.rmb])
	end)

	local function var_13_3(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		local var_15_0 = arg_15_0:multiget("textNote", "textCost", "imgIcon")
		local var_15_1 = arg_15_3 <= arg_15_2
		local var_15_2 = arg_15_4 >= var_0_0[arg_15_1][arg_15_3]

		var_15_0.textCost:text(var_15_1 and arg_15_2 .. "/" .. arg_15_3 or var_0_0[arg_15_1][arg_15_3])
		var_15_0.imgIcon:texture(dataEasy.getIconResByKey(var_15_1 and var_0_2[arg_15_1] or arg_15_1))
		adapt.oneLineCenterPos(cc.p(175, 35), {
			var_15_0.textNote,
			var_15_0.textCost,
			var_15_0.imgIcon
		})
		var_15_0.textCost:color((var_15_1 or var_15_2) and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED)
	end

	local function var_13_4(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		local var_16_0 = arg_16_0:multiget("textNote", "textCost", "imgIcon")
		local var_16_1 = arg_16_2 >= var_0_0[arg_16_1][arg_16_3]

		var_16_0.textCost:text(arg_16_2 .. "/" .. var_0_0[arg_16_1][arg_16_3])
		var_16_0.imgIcon:texture(dataEasy.getIconResByKey(var_0_2[arg_16_1]))
		adapt.oneLineCenterPos(cc.p(175, 35), {
			var_16_0.textNote,
			var_16_0.textCost,
			var_16_0.imgIcon
		})
		var_16_0.textCost:color(var_16_1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED)
	end

	idlereasy.any({
		var_13_1
	}, function(arg_17_0, arg_17_1, arg_17_2)
		arg_17_1 = arg_17_1 or 0

		var_13_4(arg_13_0.item1CostInfo, "item", arg_17_1, 1, arg_17_2)
		var_13_4(arg_13_0.item10CostInfo, "item", arg_17_1, 10, arg_17_2)
	end)
	idlereasy.any({
		var_13_2,
		arg_13_0.rmb
	}, function(arg_18_0, arg_18_1, arg_18_2)
		arg_18_1 = arg_18_1 or 0

		var_13_3(arg_13_0.diamond1CostInfo, "rmb", arg_18_1, 1, arg_18_2)
		var_13_3(arg_13_0.diamond10CostInfo, "rmb", arg_18_1, 10, arg_18_2)
	end)
	idlereasy.any({
		arg_13_0.itemDrawCount,
		arg_13_0.vip_level
	}, function(arg_19_0, arg_19_1, arg_19_2)
		local var_19_0 = gVipCsv[arg_19_2].itemDrawChipCountLimit

		arg_13_0.itemRecord:text(arg_19_1 .. "/" .. var_19_0)
		text.addEffect(arg_13_0.itemRecord, {
			color = arg_19_1 < var_19_0 and ui.NEWCOLORS.GREEN2 or ui.NEWCOLORS.REDLIGHT
		})
	end)
	idlereasy.any({
		arg_13_0.rmbDrawCount,
		arg_13_0.vip_level
	}, function(arg_20_0, arg_20_1, arg_20_2)
		local var_20_0 = gVipCsv[arg_20_2].rmbDrawChipCountLimit

		arg_13_0.diamondRecord:text(arg_20_1 .. "/" .. var_20_0)
		text.addEffect(arg_13_0.diamondRecord, {
			color = arg_20_1 < var_20_0 and ui.NEWCOLORS.GREEN2 or ui.NEWCOLORS.REDLIGHT
		})
	end)
	idlereasy.when(arg_13_0.itemFreeCount, function(arg_21_0, arg_21_1)
		local var_21_0 = arg_21_1 == 0

		arg_13_0.item1CostInfo:visible(not var_21_0)
		arg_13_0.item1FreeTxt:visible(var_21_0)
		arg_13_0.item1:get("cutDownPanel"):visible(not var_21_0)
		arg_13_0.itemSign:set(var_21_0)
	end)
	idlereasy.when(arg_13_0.rmbFreeCount, function(arg_22_0, arg_22_1)
		local var_22_0 = arg_22_1 == 0

		arg_13_0.diamond1CostInfo:visible(not var_22_0)
		arg_13_0.diamond1FreeTxt:visible(var_22_0)
		arg_13_0.rmb1:get("cutDownPanel"):visible(not var_22_0)
		arg_13_0.rmbSign:set(var_22_0)
	end)

	local function var_13_5()
		local var_23_0 = time.getTime()
		local var_23_1 = time.getNumTimestamp(tonumber(time.getTodayStr()), time.getRefreshHour())

		if var_23_1 < var_23_0 then
			var_23_1 = var_23_1 + 86400
		end

		return var_23_1 - var_23_0
	end

	local var_13_6 = var_13_5()

	arg_13_0.time = idler.new(var_13_6)

	arg_13_0:enableSchedule():schedule(function(arg_24_0)
		arg_13_0.time:modify(function(arg_25_0)
			local var_25_0 = arg_25_0 - 1

			if var_25_0 < 0 then
				var_25_0 = var_13_5()
			end

			return true, var_25_0
		end)
	end, 1, 0)

	arg_13_0.siteStateTab, arg_13_0.ChipAwardTab = {}, {}
	arg_13_0.awardIdTabel = {}

	for iter_13_0, iter_13_1 in orderCsvPairs(csv.draw_count) do
		if iter_13_1.drawType == 6 then
			arg_13_0.ChipAwardTab[iter_13_0] = iter_13_1
		end
	end

	for iter_13_2 = 1, 3 do
		arg_13_0["livenessPoint" .. iter_13_2] = idler.new(0)
		arg_13_0.siteStateTab[iter_13_2] = 2
	end

	arg_13_0:initAward()
	arg_13_0.txtTip:text(gLanguageCsv.chipDrawSuitUp01)
end

function var_0_6.initAward(arg_26_0)
	local var_26_0

	arg_26_0.awardIdTabel = {}
	arg_26_0.siteStateTab = {
		2,
		2,
		2
	}

	local var_26_1
	local var_26_2
	local var_26_3
	local var_26_4

	arg_26_0.awardTab = {}

	local var_26_5 = {}
	local var_26_6 = 0
	local var_26_7 = 0
	local var_26_8
	local var_26_9
	local var_26_10
	local var_26_11 = 0

	arg_26_0.awardTab = arg_26_0.ChipAwardTab

	local var_26_12 = arg_26_0.getDiamondAwardState:read()[6] or {}
	local var_26_13 = arg_26_0.chipAllCountTen:read() * 10
	local var_26_14 = arg_26_0.chipAllCount:read() + var_26_13

	var_26_12 = var_26_12 or {}

	local function var_26_15(arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = csv.draw_count[arg_27_1] and csv.draw_count[arg_27_1].count

		if not var_27_0 then
			return
		end

		arg_26_0.awardIdTabel[arg_27_0] = arg_27_1

		local var_27_1 = arg_26_0.downPanel:get("item" .. arg_27_0 + 1)

		var_27_1:get("number"):text(var_27_0 - arg_27_2)
		var_27_1:get("result"):visible(false)
		arg_26_0["livenessPoint" .. arg_27_0]:set(100)
		var_27_1:get("bg"):texture(var_0_4[2])
		var_27_1:get("number"):setTextColor(ui.COLORS.GLOW.YELLOW)

		if var_27_1:get("effect") then
			var_27_1:get("effect"):hide()
		end

		if var_26_12[arg_27_1] == 0 then
			var_27_1:get("state"):texture(arg_27_0 == 3 and var_0_3[6] or var_0_3[1])

			arg_26_0.siteStateTab[arg_27_0] = 0
		elseif var_26_12[arg_27_1] == 1 or var_27_0 <= var_26_14 then
			var_27_1:get("state"):texture(arg_27_0 == 3 and var_0_3[5] or var_0_3[2])

			arg_26_0.siteStateTab[arg_27_0] = 1

			if not var_27_1:get("effect") then
				widget.addAnimationByKey(var_27_1, "effect/jiedianjiangli.skel", "effect", "effect_loop", 0):xy(100, 30):scale(0.7)
			end

			var_27_1:get("effect"):show()
		else
			local var_27_2 = csv.draw_count[arg_27_1 - 1] and csv.draw_count[arg_27_1 - 1].count or 0
			local var_27_3 = csv.draw_count[arg_27_1].count - var_27_2

			arg_26_0["livenessPoint" .. arg_27_0]:set(not var_26_14 and 0 or (var_26_14 - var_27_2) / var_27_3 * 100)
			var_27_1:get("number"):setTextColor(ui.COLORS.NORMAL.WHITE)
			var_27_1:get("bg"):texture(var_0_4[1])
			var_27_1:get("state"):texture(arg_27_0 == 3 and var_0_3[4] or var_0_3[3])
		end
	end

	if table.nums(arg_26_0.awardTab) >= 3 then
		local var_26_16 = 0
		local var_26_17
		local var_26_18

		for iter_26_0, iter_26_1 in orderCsvPairs(arg_26_0.awardTab) do
			var_26_16 = var_26_16 + 1
			var_26_17 = iter_26_0

			if var_26_12[iter_26_0] ~= 0 then
				local var_26_19 = iter_26_0 - (var_26_16 - 1) % 3

				if arg_26_0.awardTab[var_26_19 + 2] then
					var_26_18 = var_26_19
				end

				break
			end
		end

		var_26_18 = var_26_18 or var_26_17 - var_26_16 % 3 - 2

		local var_26_20 = 0

		if arg_26_0.awardTab[var_26_18 - 1] then
			var_26_20 = arg_26_0.awardTab[var_26_18 - 1].count
		end

		arg_26_0.preCount = var_26_20

		var_26_15(1, var_26_18, var_26_20)
		var_26_15(2, var_26_18 + 1, var_26_20)
		var_26_15(3, var_26_18 + 2, var_26_20)
		arg_26_0.downPanel:get("item1"):get("number"):text(var_26_14 - var_26_20)
		arg_26_0.downPanel:visible(true)
	end
end

function var_0_6.onAwardClick(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.awardIdTabel[arg_28_1]

	if arg_28_0.siteStateTab[arg_28_1] == 1 then
		gGameApp:requestServer("/game/draw/sum/box/get", function(arg_29_0)
			gGameUI:showGainDisplay(csv.draw_count[var_28_0].award, {
				raw = false,
				cb = function()
					arg_28_0.downPanel:get("item" .. arg_28_1 + 1):get("result"):visible(false)
					arg_28_0:initAward()
				end
			})
		end, var_28_0)

		return
	end

	gGameUI:showBoxDetail({
		data = csv.draw_count[var_28_0].award,
		content = string.format(gLanguageCsv.accumulatedAward, csv.draw_count[var_28_0].count - (arg_28_0.preCount or 0)),
		state = arg_28_0.siteStateTab[arg_28_1] == 2 and 1 or 0
	})
end

function var_0_6.drawRequest(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = gGameModel.role:read("vip_level")
	local var_31_1 = {
		item = arg_31_0.itemDrawCount:read() or 0,
		rmb = arg_31_0.rmbDrawCount:read() or 0
	}
	local var_31_2 = {
		item = gVipCsv[var_31_0].itemDrawChipCountLimit,
		rmb = gVipCsv[var_31_0].rmbDrawChipCountLimit
	}
	local var_31_3 = false
	local var_31_4 = arg_31_1 .. arg_31_2

	if arg_31_2 == 1 and ({
		item = arg_31_0.itemFreeCount:read() or 0,
		rmb = arg_31_0.rmbFreeCount:read() or 0
	})[arg_31_1] <= 0 then
		var_31_4 = arg_31_1 == "item" and "free_item1" or "free1"
		var_31_3 = true
	end

	if arg_31_2 > var_31_2[arg_31_1] - var_31_1[arg_31_1] and not var_31_3 then
		gGameUI:showTip(gLanguageCsv.chipDrawLimit)

		return
	end

	if arg_31_1 == "item" and dataEasy.getNumByKey(var_0_2[arg_31_1]) < var_0_0[arg_31_1][arg_31_2] and not var_31_3 then
		gGameUI:showTip(gLanguageCsv.inadequateProps)

		return
	end

	if dataEasy.getNumByKey(arg_31_1) < var_0_0[arg_31_1][arg_31_2] and not var_31_3 and arg_31_2 > dataEasy.getNumByKey(var_0_2[arg_31_1]) then
		uiEasy.showDialog(arg_31_1)

		return
	end

	local var_31_5 = arg_31_0.items:read()[var_0_2.rmb] or 0

	local function var_31_6()
		gGameApp:requestServer("/game/lottery/chip/draw", function(arg_33_0)
			local var_33_0 = dataEasy.mergeRawDate(arg_33_0)

			arg_31_0:initAward()
			arg_31_3(random.shuffle(var_33_0))

			if var_31_4 == "rmb10" and var_31_5 < 10 then
				userDefault.setCurrDayKey("diamondChipDrawTips", 0)
			end
		end, var_31_4, arg_31_0.selectUpSuitID)
	end

	if var_31_4 == "rmb10" and var_31_5 < 10 and userDefault.getCurrDayKey("diamondChipDrawTips", 1) == 1 and dataEasy.isUnlock("ChipDrawTips") then
		local var_31_7 = var_0_0[arg_31_1][arg_31_2]

		gGameUI:showDialog({
			isRich = true,
			clearFast = true,
			btnType = 2,
			content = string.format(gLanguageCsv.draw10CardTips, var_31_7),
			cb = var_31_6
		})
	elseif var_31_4 == "rmb1" and var_31_5 == 0 or var_31_4 == "rmb10" and var_31_5 < 10 then
		dataEasy.sureUsingDiamonds(var_31_6, var_0_0[arg_31_1][arg_31_2])
	else
		var_31_6()
	end
end

function var_0_6.draw(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0:drawRequest(arg_34_1, arg_34_2, function(arg_35_0)
		local var_35_0 = arg_34_0.bg:getChildByName("effectBg")

		if var_35_0 then
			var_35_0:play("effect")
			performWithDelay(var_35_0, function()
				var_35_0:play("effect_loop")
				gGameUI:stackUI("city.card.chip.result", nil, nil, arg_35_0, arg_34_1, arg_34_2, var_0_0[arg_34_1][arg_34_2], var_0_2[arg_34_1], arg_34_0:createHandler("drawRequest"))
			end, 1.5)
		end
	end)
end

function var_0_6.initSelectSuitUI(arg_37_0)
	arg_37_0.selectUpSuitID = {}

	local var_37_0 = userDefault.getForeverLocalKey("selectUpSuitID", {})

	for iter_37_0 = 1, var_0_1 do
		if var_37_0[iter_37_0] ~= 0 then
			table.insert(arg_37_0.selectUpSuitID, var_37_0[iter_37_0])
		end
	end

	for iter_37_1 = var_0_1, 1, -1 do
		local var_37_1 = (arg_37_0.panelSelectSuit:get("item0" .. iter_37_1) or arg_37_0.selectSuitItem:clone():xy(600 - 140 * (var_0_1 + 1 - iter_37_1), 0):addTo(arg_37_0.panelSelectSuit, 1, "item0" .. iter_37_1)):multiget("imgIcon", "imgAdd")
		local var_37_2 = arg_37_0.selectUpSuitID[iter_37_1] == nil

		var_37_1.imgAdd:visible(var_37_2)
		var_37_1.imgIcon:visible(not var_37_2)

		if not var_37_2 then
			local var_37_3, var_37_4 = next(gChipSuitCsv[arg_37_0.selectUpSuitID[iter_37_1]][6])
			local var_37_5 = string.gsub(var_37_4.suitIcon, "0.png", "2.png")

			var_37_1.imgIcon:texture(var_37_5)
		end
	end

	arg_37_0.panelSelectSuit:get("img01"):x(520 - var_0_1 * 140)
end

function var_0_6.onBtnSelectSuit(arg_38_0)
	gGameUI:stackUI("city.card.chip.select_suit", nil, nil, {
		callBack = arg_38_0:createHandler("initSelectSuitUI")
	})
end

function var_0_6.initModel(arg_39_0)
	arg_39_0.rmb = gGameModel.role:getIdler("rmb")
	arg_39_0.vip_level = gGameModel.role:getIdler("vip_level")

	local var_39_0 = gGameModel.daily_record

	arg_39_0.itemDrawCount = var_39_0:getIdler("draw_chip_item")
	arg_39_0.rmbDrawCount = var_39_0:getIdler("draw_chip_rmb")
	arg_39_0.itemFreeCount = var_39_0:getIdler("chip_item_dc1_free_count")
	arg_39_0.rmbFreeCount = var_39_0:getIdler("chip_rmb_dc1_free_count")
	arg_39_0.items = gGameModel.role:getIdler("items")
	arg_39_0.chipAllCount = gGameModel.lottery_record:getIdler("chip_rmb_dc1_counter")
	arg_39_0.chipAllCountTen = gGameModel.lottery_record:getIdler("chip_rmb_dc10_counter")
	arg_39_0.getDiamondAwardState = gGameModel.role:getIdler("draw_sum_box")
end

return var_0_6
