local var_0_0 = require("app.views.city.card.chip.tools")
local var_0_1 = class("CardChipView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "card_chip.json"
var_0_1.RESOURCE_BINDING = {
	["panel.suitAttrPanel.item"] = "suitAttrItem",
	["panel.baseAttrPanel.subList"] = "baseAttrSubList",
	suitAttrDetailPanel = "suitAttrDetailPanel",
	["panel.baseAttrPanel.item"] = "baseAttrItem",
	["panel.suitAttrPanel.tip"] = "suitAttrTip",
	["panel.baseAttrPanel.tip"] = "baseAttrTip",
	["panel.btnDraw"] = {
		varname = "btnDraw",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onDrawClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "cityChipFreeExtract",
					onNode = function(arg_1_0)
						arg_1_0:xy(200, 200)
					end
				}
			}
		}
	},
	["panel.btnDraw.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panel.btnOnekeyDown"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOnekeyDownClick")
			}
		}
	},
	["panel.btnOnekeyDown.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panel.btnPlan"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onPlanClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("chipPlanListen")
			}
		}
	},
	["panel.btnPlan.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["panel.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["panel.btnPlanCompare"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onPlanCompareClick")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("chipPlanCompareListen")
			}
		}
	},
	["panel.btnPlanCompare.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["panel.chipPanel"] = {
		varname = "chipPanel",
		binds = {
			event = "extend",
			class = "chips_panel",
			props = {
				data = bindHelper.self("selectCardDBID"),
				showDetails = bindHelper.self("showDetails", true),
				selected = bindHelper.self("selectPos"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.click(arg_2_0, arg_2_1, {
						method = function()
							if arg_2_3 then
								arg_2_0.showDetails(arg_2_1, arg_2_2, arg_2_3)
							else
								arg_2_0.chipsBagClick(arg_2_2)
							end
						end
					})
				end,
				onNode = function(arg_4_0, arg_4_1)
					arg_4_1:scale(0.9)
				end
			},
			handlers = {
				chipsBagClick = bindHelper.self("onChipsBagClick")
			}
		}
	},
	["panel.chipPanel.btnChips"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChipsBagClick")
			}
		}
	},
	["panel.baseAttrPanel.btnDetail"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBaseAttrDetailClick")
			}
		}
	},
	["panel.suitAttrPanel.btnDetail"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSuitAttrDetailClick")
			}
		}
	},
	["panel.baseAttrPanel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("baseAttrData"),
				item = bindHelper.self("baseAttrSubList"),
				cell = bindHelper.self("baseAttrItem"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:get("icon"):texture(ui.ATTR_LOGO[arg_5_3.attr])
					arg_5_1:get("text"):text(getLanguageAttr(arg_5_3.key) .. " +" .. arg_5_3.val)
				end
			}
		}
	},
	["panel.suitAttrPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("suitAttrData"),
				item = bindHelper.self("suitAttrItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:get("icon"):texture(var_0_0.getSuitRes(arg_6_3.suitId, arg_6_3.data))
					bind.touch(arg_6_0, arg_6_1, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_1, arg_6_2, arg_6_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSuitAttrItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_7_0, arg_7_1)
	arg_7_0.selectCardDBID = arg_7_1()
	arg_7_0.chipPlanListen = dataEasy.getListenUnlock(gUnlockCsv.chipPlan)
	arg_7_0.chipPlanCompareListen = dataEasy.getListenUnlock(gUnlockCsv.chipPlanCompare)

	arg_7_0.suitAttrDetailPanel:hide()
	bind.click(arg_7_0, arg_7_0.suitAttrDetailPanel, {
		method = function()
			arg_7_0.suitAttrDetailPanel:hide()
		end
	})

	arg_7_0.baseAttrData = idlereasy.new({})
	arg_7_0.suitAttrData = idlereasy.new({})
	arg_7_0.selectPos = idler.new()

	idlereasy.when(arg_7_0.selectCardDBID, function(arg_9_0, arg_9_1)
		local var_9_0 = gGameModel.cards:find(arg_9_1)

		arg_7_0.cardChips = idlereasy.assign(var_9_0:getIdler("chip"), arg_7_0.cardChips)

		arg_7_0:showPanel()
	end)

	arg_7_0.cardChipsIdler_ = {}

	idlereasy.when(arg_7_0.cardChips, function(arg_10_0, arg_10_1)
		for iter_10_0, iter_10_1 in pairs(arg_7_0.cardChipsIdler_) do
			iter_10_1:destroy()
		end

		arg_7_0.cardChipsIdler_ = {}

		for iter_10_2 = 1, 6 do
			local var_10_0 = arg_10_1[iter_10_2]

			if var_10_0 then
				local var_10_1 = gGameModel.chips:find(var_10_0):multigetIdler("level", "now")

				arg_7_0.cardChipsIdler_[var_10_0] = idlereasy.any(var_10_1, function()
					arg_7_0:showPanel()
				end, true):anonyOnly(arg_7_0, stringz.bintohex(var_10_0))
			end
		end

		arg_7_0:showPanel()
	end)
end

function var_0_1.showPanel(arg_12_0)
	local var_12_0 = arg_12_0.selectCardDBID:read()
	local var_12_1, var_12_2 = var_0_0.getAttrs(var_12_0)

	var_0_0.setAttrCollect(var_12_1, var_12_2)

	local var_12_3 = {}

	for iter_12_0, iter_12_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		local var_12_4 = game.ATTRDEF_ENUM_TABLE[iter_12_1]

		if var_12_1[1][var_12_4] then
			table.insert(var_12_3, {
				attr = iter_12_1,
				key = var_12_4,
				val = var_12_1[1][var_12_4]
			})
		end
	end

	arg_12_0.baseAttrData:set(var_12_3)
	arg_12_0.baseAttrTip:visible(#var_12_3 == 0)

	local var_12_5 = {}
	local var_12_6 = var_0_0.getComplateSuitAttrByCard(var_12_0)

	for iter_12_2, iter_12_3 in pairs(var_12_6) do
		local var_12_7 = 0

		for iter_12_4, iter_12_5 in ipairs(iter_12_3.data) do
			if iter_12_5[3] then
				var_12_7 = math.max(var_12_7, iter_12_5[1])
			end
		end

		if var_12_7 > 0 then
			table.insert(var_12_5, {
				suitId = iter_12_3.suitId,
				maxActiveNum = var_12_7,
				data = iter_12_3.data
			})
		end
	end

	arg_12_0.suitAttrData:set(var_12_5)
	arg_12_0.suitAttrTip:visible(#var_12_5 == 0)
end

function var_0_1.onDrawClick(arg_13_0)
	gGameUI:stackUI("city.card.chip.draw")
end

function var_0_1.onOnekeyDownClick(arg_14_0)
	local var_14_0 = arg_14_0.selectCardDBID:read()
	local var_14_1 = gGameModel.cards:find(var_14_0):read("chip")

	if itertools.size(var_14_1) == 0 then
		return
	end

	local function var_14_2()
		local var_15_0 = {
			-1,
			-1,
			-1,
			-1,
			-1,
			-1
		}

		gGameApp:requestServer("/game/card/chip/change", function(arg_16_0)
			gGameUI:showTip(gLanguageCsv.dischargeSuccess)
		end, var_14_0, var_15_0)
	end

	local var_14_3 = "chipOnekeyDownTip"
	local var_14_4 = userDefault.getCurrDayKey(var_14_3, "first")

	if var_14_4 == "first" then
		var_14_4 = "true"

		userDefault.setCurrDayKey(var_14_3, var_14_4)
	end

	if var_14_4 == "first" or var_14_4 == "true" then
		gGameUI:showDialog({
			isRich = true,
			selectType = 2,
			btnType = 2,
			content = "#C0x57472E#" .. gLanguageCsv.chipOnekeyDownTip,
			cb = var_14_2,
			selectKey = var_14_3,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_14_2()
	end
end

function var_0_1.onPlanClick(arg_17_0)
	gGameUI:stackUI("city.card.chip.plan", nil, nil, {
		curCardDBID = arg_17_0.selectCardDBID:read()
	})
end

function var_0_1.onPlanCompareClick(arg_18_0)
	return
end

function var_0_1.onChipsBagClick(arg_19_0, arg_19_1, arg_19_2)
	local function var_19_0()
		gGameUI:stackUI("city.card.chip.bag", nil, {
			full = true
		}, {
			curCardDBID = arg_19_0.selectCardDBID:read()
		})
	end

	if arg_19_2 then
		arg_19_0.selectPos:set(arg_19_2)
		performWithDelay(arg_19_0, function()
			var_19_0()
			arg_19_0.selectPos:set(nil)
		end, 0.01)
	else
		var_19_0()
	end
end

function var_0_1.showDetails(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_2:convertToWorldSpaceAR(cc.p(0, 0))
	local var_22_1 = "right"

	if arg_22_3 >= 1 and arg_22_3 <= 3 then
		var_22_1 = "left"
	end

	arg_22_0.selectPos:set(arg_22_3)
	gGameUI:stackUI("city.card.chip.details", nil, {
		clickClose = true,
		dispatchNodes = arg_22_0.chipPanel
	}, {
		dbId = arg_22_4,
		cardDBID = arg_22_0.selectCardDBID:read(),
		pos = var_22_0,
		align = var_22_1,
		cb = arg_22_0:createHandler("resetSelected")
	})
end

function var_0_1.resetSelected(arg_23_0)
	arg_23_0.selectPos:set()
end

function var_0_1.onBaseAttrDetailClick(arg_24_0)
	gGameUI:stackUI("city.card.chip.total_detail", nil, nil, {
		typ = 1,
		cardPlan = arg_24_0.selectCardDBID:read()
	})
end

function var_0_1.onSuitAttrDetailClick(arg_25_0)
	gGameUI:stackUI("city.card.chip.suit_detail", nil, nil, arg_25_0.selectCardDBID:read())
end

function var_0_1.onSuitAttrItemClick(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = arg_26_0.suitAttrDetailPanel:get("panel")
	local var_26_1 = var_26_0:multiget("icon", "name", "count", "list")
	local var_26_2 = gChipSuitCsv[arg_26_4.suitId][2][2]

	var_26_1.icon:texture(var_0_0.getSuitRes(arg_26_4.suitId, arg_26_4.data))
	var_26_1.name:text(var_26_2.suitName)

	local var_26_3 = 0
	local var_26_4 = gGameModel.role:read("chips")

	for iter_26_0, iter_26_1 in ipairs(var_26_4) do
		local var_26_5 = gGameModel.chips:find(iter_26_1):read("chip_id")
		local var_26_6 = csv.chip.chips[var_26_5]

		if arg_26_4.suitId == var_26_6.suitID then
			var_26_3 = var_26_3 + 1
		end
	end

	var_26_1.count:text(gLanguageCsv.currentOwn .. var_26_3):hide()

	local var_26_7 = {}

	for iter_26_2, iter_26_3 in ipairs(arg_26_4.data) do
		local var_26_8 = var_0_0.getSuitAttrStr(arg_26_4.suitId, iter_26_3)

		table.insert(var_26_7, {
			str = var_26_8
		})
	end

	beauty.textScroll({
		margin = 10,
		isRich = true,
		list = var_26_1.list,
		strs = var_26_7
	})

	local var_26_9 = arg_26_2:convertToWorldSpaceAR(cc.p(0, 0))
	local var_26_10 = arg_26_0.suitAttrDetailPanel:convertToNodeSpace(var_26_9)

	var_26_0:x(var_26_10.x - var_26_0:width() / 2)
	arg_26_0.suitAttrDetailPanel:show()
end

function var_0_1.onShowRule(arg_27_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_27_0:createHandler("getRuleContext"), {
		width = 2200,
		height = 1113
	})
end

function var_0_1.getRuleContext(arg_28_0, arg_28_1)
	local var_28_0 = adaptContext
	local var_28_1 = {
		var_28_0.clone(arg_28_1.title, function(arg_29_0)
			arg_29_0:get("text"):text(gLanguageCsv.chipRule)
		end),
		var_28_0.noteText(124601, 124605)
	}
	local var_28_2 = {}

	table.insert(var_28_2, {
		sign = true,
		key = csv.note[124606].fmt,
		main = csv.note[124607].fmt,
		sec = csv.note[124608].fmt
	})

	local var_28_3 = 124609

	for iter_28_0 = 1, 6 do
		table.insert(var_28_2, {
			sign = false,
			key = iter_28_0,
			main = csv.note[var_28_3 + 2 * iter_28_0 - 2].fmt,
			sec = csv.note[var_28_3 + 2 * iter_28_0 - 1].fmt
		})
	end

	for iter_28_1 = 1, 7 do
		table.insert(var_28_1, var_28_0.clone(arg_28_1.panelChip, function(arg_30_0)
			local var_30_0 = arg_30_0:multiget("txtLocation", "imgLocation", "txtMain", "txtSec", "img01", "img02")
			local var_30_1 = var_28_2[iter_28_1]

			if var_30_1.sign then
				var_30_0.txtLocation:x(40)
				var_30_0.txtSec:x(1000)
				var_30_0.imgLocation:hide()
			else
				var_30_0.imgLocation:show()
				var_30_0.imgLocation:rotate(60 * (var_30_1.key - 1))
			end

			var_30_0.txtLocation:text(var_30_1.key)
			var_30_0.txtMain:text(var_30_1.main)
			var_30_0.txtSec:text(var_30_1.sec)
			var_30_0.img01:visible(var_30_1.sign)
			var_30_0.img02:visible(var_30_1.sign)
		end))
	end

	return var_28_1
end

return var_0_1
