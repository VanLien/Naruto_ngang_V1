local var_0_0 = {
	gold = {
		gCommonConfigCsv.drawGemGoldCostPrice,
		[10] = gCommonConfigCsv.draw10GemGoldCostPrice
	},
	rmb = {
		gCommonConfigCsv.drawGemCostPrice,
		[10] = gCommonConfigCsv.draw10GemCostPrice
	}
}
local var_0_1 = {
	gold = 530,
	rmb = 531
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("GemDrawView", var_0_2)

var_0_3.RESOURCE_FILENAME = "gem_draw.json"
var_0_3.RESOURCE_BINDING = {
	["drawOnePanel2.costInfo"] = "diamond1CostInfo",
	["drawCountPanel.diamondRecord"] = "diamondRecord",
	["drawTenPanel2.costInfo"] = "diamond10CostInfo",
	["drawTenPanel.costInfo.textCost"] = "gold10Cost",
	["drawOnePanel.textFree"] = "gold1FreeTxt",
	["drawTenPanel2.costInfo.textCost"] = "diamond10Cost",
	["drawTenPanel.costInfo"] = "gold10CostInfo",
	["drawOnePanel.costInfo.textCost"] = "gold1Cost",
	drawCountPanel = "drawCountPanel",
	bg = "bg",
	["drawCountPanel.goldRecord"] = "goldRecord",
	["drawOnePanel2.costInfo.textCost"] = "diamond1Cost",
	["drawOnePanel.costInfo"] = "gold1CostInfo",
	["drawOnePanel2.textFree"] = "diamond1FreeTxt",
	drawOnePanel = {
		varname = "gold1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("goldDrawOne")
			}
		}
	},
	["drawOnePanel.cutDownPanel.textTime"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("time"),
			method = function(arg_1_0)
				if arg_1_0 == 0 then
					return ""
				end

				return time.getCutDown(arg_1_0).clock_str
			end
		}
	},
	drawTenPanel = {
		varname = "gold10",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("goldDrawTen")
			}
		}
	},
	drawOnePanel2 = {
		varname = "rmb1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("diamondDrawOne")
			}
		}
	},
	["drawOnePanel2.cutDownPanel.textTime"] = {
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
	drawTenPanel2 = {
		varname = "rmb10",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("diamondDrawTen")
			}
		}
	},
	autoDecompose = {
		varname = "autoDecompose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickAutoDecompose")
			}
		}
	},
	["drawOnePanel.btnDraw"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				state = bindHelper.self("goldSign"),
				onNode = function(arg_3_0)
					arg_3_0:xy(280, 100)
				end
			}
		}
	},
	["drawOnePanel.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["drawOnePanel2.btnDraw"] = {
		binds = {
			event = "extend",
			class = "red_hint",
			props = {
				state = bindHelper.self("rmbSign"),
				onNode = function(arg_4_0)
					arg_4_0:xy(280, 100)
				end
			}
		}
	},
	["drawOnePanel2.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["drawTenPanel.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["drawTenPanel2.btnDraw.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["typePanel.imgAdd"] = {
		varname = "preview1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showPreview1")
			}
		}
	},
	["typePanel2.imgAdd"] = {
		varname = "preview2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("showPreview2")
			}
		}
	},
	txtAutoDecompose = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			},
			{
				event = "touch",
				scaletype = 0,
				methods = {
					ended = bindHelper.self("clickAutoDecompose")
				}
			}
		}
	},
	btnRate = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickBtnRate")
			}
		}
	},
	["btnRate.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}
var_0_3.RESOURCE_STYLES = {
	full = true
}

function var_0_3.showPreview1(arg_5_0)
	gGameUI:stackUI("city.card.gem.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, "gold")
end

function var_0_3.showPreview2(arg_6_0)
	gGameUI:stackUI("city.card.gem.preview", nil, {
		clickClose = true,
		blackLayer = true
	}, "diamond")
end

function var_0_3.clickBtnRate(arg_7_0)
	gGameUI:stackUI("city.card.gem.rate_preview", nil, {
		clickClose = true
	})
end

function var_0_3.onCreate(arg_8_0)
	arg_8_0.preview1:visible(false)
	arg_8_0.preview2:visible(false)
	gGameUI.topuiManager:createView("default", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "DRAW GEM",
		title = "common/txt/txt_bt_yinji.png"
	})
	widget.addAnimationByKey(arg_8_0.bg, "effect/shipinchouka.skel", "effectBg", "effect_loop", 10):alignCenter(arg_8_0.bg:size()):xy(arg_8_0.bg:size().width / 2, 0)
	arg_8_0.bg:scale(2)

	local var_8_0 = userDefault.getForeverLocalKey("gemDrawAutoDecompose", false)

	arg_8_0.autoDecompose:setSelectedState(var_8_0)

	arg_8_0.useAutoDecompose = var_8_0 and 1 or 0

	arg_8_0:initModel()

	local var_8_1 = idler.new(0)
	local var_8_2 = idler.new(0)

	arg_8_0.goldSign = idler.new(true)
	arg_8_0.rmbSign = idler.new(true)

	idlereasy.when(arg_8_0.items, function(arg_9_0, arg_9_1)
		var_8_1:set(arg_9_1[var_0_1.gold])
		var_8_2:set(arg_9_1[var_0_1.rmb])
	end)

	local var_8_3 = {
		"textNote",
		"textCost",
		"imgIcon"
	}

	local function var_8_4(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		local var_10_0 = arg_10_0:multiget(unpack(var_8_3))
		local var_10_1 = arg_10_3 <= arg_10_2
		local var_10_2 = arg_10_4 >= var_0_0[arg_10_1][arg_10_3]

		var_10_0.textCost:text(var_10_1 and arg_10_2 .. "/" .. arg_10_3 or var_0_0[arg_10_1][arg_10_3])
		var_10_0.imgIcon:texture(dataEasy.getIconResByKey(var_10_1 and var_0_1[arg_10_1] or arg_10_1))
		adapt.oneLineCenterPos(cc.p(175, 35), {
			var_10_0.textNote,
			var_10_0.textCost,
			var_10_0.imgIcon
		})
		var_10_0.textCost:color((var_10_1 or var_10_2) and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED)
	end

	idlereasy.any({
		var_8_1,
		arg_8_0.gold
	}, function(arg_11_0, arg_11_1, arg_11_2)
		arg_11_1 = arg_11_1 or 0

		var_8_4(arg_8_0.gold1CostInfo, "gold", arg_11_1, 1, arg_11_2)
		var_8_4(arg_8_0.gold10CostInfo, "gold", arg_11_1, 10, arg_11_2)
	end)
	idlereasy.any({
		var_8_2,
		arg_8_0.rmb
	}, function(arg_12_0, arg_12_1, arg_12_2)
		arg_12_1 = arg_12_1 or 0

		var_8_4(arg_8_0.diamond1CostInfo, "rmb", arg_12_1, 1, arg_12_2)
		var_8_4(arg_8_0.diamond10CostInfo, "rmb", arg_12_1, 10, arg_12_2)
	end)
	idlereasy.any({
		arg_8_0.goldDrawCount,
		arg_8_0.vip_level
	}, function(arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = csv.vip[arg_13_2 + 1].goldDrawGemCountLimit

		arg_8_0.goldRecord:text(arg_13_1 .. "/" .. var_13_0)
		text.addEffect(arg_8_0.goldRecord, {
			color = arg_13_1 < var_13_0 and ui.NEWCOLORS.GREEN2 or ui.NEWCOLORS.REDLIGHT
		})
	end)
	idlereasy.any({
		arg_8_0.rmbDrawCount,
		arg_8_0.vip_level
	}, function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = csv.vip[arg_14_2 + 1].rmbDrawGemCountLimit

		arg_8_0.diamondRecord:text(arg_14_1 .. "/" .. var_14_0)
		text.addEffect(arg_8_0.diamondRecord, {
			color = arg_14_1 < var_14_0 and ui.NEWCOLORS.GREEN2 or ui.NEWCOLORS.REDLIGHT
		})
	end)
	idlereasy.when(arg_8_0.goldFreeCount, function(arg_15_0, arg_15_1)
		local var_15_0 = arg_15_1 == 0

		arg_8_0.gold1CostInfo:visible(not var_15_0)
		arg_8_0.gold1FreeTxt:visible(var_15_0)
		arg_8_0.gold1:get("cutDownPanel"):visible(not var_15_0)
		arg_8_0.goldSign:set(var_15_0)
	end)
	idlereasy.when(arg_8_0.rmbFreeCount, function(arg_16_0, arg_16_1)
		local var_16_0 = arg_16_1 == 0

		arg_8_0.diamond1CostInfo:visible(not var_16_0)
		arg_8_0.diamond1FreeTxt:visible(var_16_0)
		arg_8_0.rmb1:get("cutDownPanel"):visible(not var_16_0)
		arg_8_0.rmbSign:set(var_16_0)
	end)

	local function var_8_5()
		local var_17_0 = time.getTime()
		local var_17_1 = time.getNumTimestamp(tonumber(time.getTodayStr()), time.getRefreshHour())

		if var_17_1 < var_17_0 then
			var_17_1 = var_17_1 + 86400
		end

		return var_17_1 - var_17_0
	end

	local var_8_6 = var_8_5()

	arg_8_0.time = idler.new(var_8_6)

	arg_8_0:enableSchedule():schedule(function(arg_18_0)
		arg_8_0.time:modify(function(arg_19_0)
			local var_19_0 = arg_19_0 - 1

			if var_19_0 < 0 then
				var_19_0 = var_8_5()
			end

			return true, var_19_0
		end)
	end, 1, 0)
end

function var_0_3.drawRequest(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = gGameModel.role:read("vip_level")
	local var_20_1 = {
		gold = arg_20_0.goldDrawCount:read() or 0,
		rmb = arg_20_0.rmbDrawCount:read() or 0
	}
	local var_20_2 = {
		gold = csv.vip[var_20_0 + 1].goldDrawGemCountLimit,
		rmb = csv.vip[var_20_0 + 1].rmbDrawGemCountLimit
	}
	local var_20_3 = false
	local var_20_4 = arg_20_1 .. arg_20_2

	if arg_20_2 == 1 and ({
		gold = arg_20_0.goldFreeCount:read() or 0,
		rmb = arg_20_0.rmbFreeCount:read() or 0
	})[arg_20_1] <= 0 then
		var_20_4 = arg_20_1 == "gold" and "free_gold1" or "free1"
		var_20_3 = true
	end

	if var_20_2[arg_20_1] - var_20_1[arg_20_1] <= 0 and not var_20_3 then
		gGameUI:showTip(gLanguageCsv.gemDrawLimit)

		return
	end

	if dataEasy.getNumByKey(arg_20_1) < var_0_0[arg_20_1][arg_20_2] and not var_20_3 and arg_20_2 > dataEasy.getNumByKey(var_0_1[arg_20_1]) then
		uiEasy.showDialog(arg_20_1)

		return
	end

	local var_20_5 = arg_20_0.items:read()[var_0_1.rmb] or 0

	local function var_20_6()
		gGameApp:requestServer("/game/lottery/gem/draw", function(arg_22_0)
			local var_22_0 = {}
			local var_22_1 = arg_22_0.view.result or arg_22_0.view

			for iter_22_0, iter_22_1 in pairs(var_22_1.items) do
				local var_22_2 = {
					key = iter_22_1[1],
					num = iter_22_1[2]
				}

				if iter_22_1[3] then
					var_22_2 = {
						num = 1,
						key = iter_22_1[3],
						decomposed = {
							key = iter_22_1[1],
							num = iter_22_1[2]
						}
					}
				end

				table.insert(var_22_0, var_22_2)
			end

			arg_20_3(random.shuffle(var_22_0))

			if var_20_4 == "rmb10" and var_20_5 < 10 then
				userDefault.setCurrDayKey("diamondGemDrawTips", 0)
			end
		end, var_20_4, arg_20_0.useAutoDecompose)
	end

	if var_20_4 == "rmb10" and var_20_5 < 10 and userDefault.getCurrDayKey("diamondGemDrawTips", 1) == 1 and dataEasy.isUnlock("gemDrawTips") then
		local var_20_7 = var_0_0[arg_20_1][arg_20_2]

		gGameUI:showDialog({
			isRich = true,
			clearFast = true,
			btnType = 2,
			content = string.format(gLanguageCsv.draw10CardTips, var_20_7),
			cb = var_20_6
		})
	elseif var_20_4 == "rmb1" and var_20_5 == 0 or var_20_4 == "rmb10" and var_20_5 < 10 then
		dataEasy.sureUsingDiamonds(var_20_6, var_0_0[arg_20_1][arg_20_2])
	else
		var_20_6()
	end
end

function var_0_3.draw(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0:drawRequest(arg_23_1, arg_23_2, function(arg_24_0)
		gGameUI:stackUI("city.card.gem.result", nil, nil, arg_24_0, arg_23_1, arg_23_2, var_0_0[arg_23_1][arg_23_2], var_0_1[arg_23_1], arg_23_0:createHandler("drawRequest"))
	end)
end

function var_0_3.goldDrawOne(arg_25_0)
	arg_25_0:draw("gold", 1)
end

function var_0_3.diamondDrawOne(arg_26_0)
	arg_26_0:draw("rmb", 1)
end

function var_0_3.goldDrawTen(arg_27_0)
	arg_27_0:draw("gold", 10)
end

function var_0_3.diamondDrawTen(arg_28_0)
	arg_28_0:draw("rmb", 10)
end

function var_0_3.clickAutoDecompose(arg_29_0)
	local var_29_0 = userDefault.getForeverLocalKey("gemDrawAutoDecompose", false)

	userDefault.setForeverLocalKey("gemDrawAutoDecompose", not var_29_0)
	performWithDelay(arg_29_0.autoDecompose, function()
		arg_29_0.autoDecompose:setSelectedState(not var_29_0)
	end, 0)

	arg_29_0.useAutoDecompose = not var_29_0 and 1 or 0
end

function var_0_3.initModel(arg_31_0)
	arg_31_0.gold = gGameModel.role:getIdler("gold")
	arg_31_0.rmb = gGameModel.role:getIdler("rmb")
	arg_31_0.vip_level = gGameModel.role:getIdler("vip_level")

	local var_31_0 = gGameModel.daily_record

	arg_31_0.goldDrawCount = var_31_0:getIdler("draw_gem_gold")
	arg_31_0.rmbDrawCount = var_31_0:getIdler("draw_gem_rmb")
	arg_31_0.goldFreeCount = var_31_0:getIdler("gem_gold_dc1_free_count")
	arg_31_0.rmbFreeCount = var_31_0:getIdler("gem_rmb_dc1_free_count")
	arg_31_0.items = gGameModel.role:getIdler("items")
end

return var_0_3
