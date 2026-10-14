local var_0_0 = class("ChipAdvanceView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.chip.tools")

local function var_0_2(arg_1_0, arg_1_1)
	if arg_1_0.type == "item" or arg_1_1.type == "item" then
		if arg_1_0.type ~= arg_1_1.type then
			return arg_1_0.type == "item"
		end

		return arg_1_0.idx < arg_1_1.idx
	end

	if arg_1_0.cfg.quality ~= arg_1_1.cfg.quality then
		return arg_1_0.cfg.quality < arg_1_1.cfg.quality
	end

	if arg_1_0.level ~= arg_1_1.level then
		return arg_1_0.level < arg_1_1.level
	end

	if arg_1_0.cfg.suitID ~= arg_1_1.cfg.suitID then
		return arg_1_0.cfg.suitID < arg_1_1.cfg.suitID
	end

	if arg_1_0.cfg.pos ~= arg_1_1.cfg.pos then
		return arg_1_0.cfg.pos < arg_1_1.cfg.pos
	end

	return arg_1_0.idx < arg_1_1.idx
end

var_0_0.RESOURCE_FILENAME = "chip_advance.json"
var_0_0.RESOURCE_BINDING = {
	leftPanel = "leftPanel",
	["advancePanel.costPanel"] = "costPanel",
	tabItem = "tabItem",
	["strengthenPanel.quickSelectPanel"] = "quickSelectPanel",
	panelRule = "panelRule",
	["strengthenPanel.quickSelectPanel.item"] = "quickSelectItem",
	strengthenPanel = "strengthenPanel",
	["advancePanel.advanceTip"] = "advanceTip",
	subAttrDetailPanel = "subAttrDetailPanel",
	advancePanel = "advancePanel",
	["strengthenPanel.item"] = "strengthenItem",
	line = "line",
	["strengthenPanel.subList"] = "strengthenSubList",
	["advancePanel.resetCostPanel"] = "resetCostPanel",
	["strengthenPanel.empty"] = "empty",
	["strengthenPanel.costPanel"] = "strengthenCostPanel",
	["leftPanel.btnRebirth"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRebirth")
			}
		}
	},
	["leftPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["leftPanel.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["leftPanel.btnRebirth.txtInfo01"] = {
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
	["leftPanel.btnRebirth.txtInfo02"] = {
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
	["tabItem.select.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	tabList = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabData"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("select")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					local var_2_3 = var_2_2:getSize().height - 40

					adapt.setAutoText(var_2_2:get("txt"), arg_2_3.name, var_2_3)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_1, arg_2_2, arg_2_3)
						}
					})

					if arg_2_3.redHint then
						arg_2_3.redHint.state = arg_2_3.select ~= true

						bind.extend(arg_2_0, arg_2_1, arg_2_3.redHint)
					end

					uiEasy.updateUnlockRes(arg_2_3.unlockKey, var_2_0, {
						justRemove = not arg_2_3.unlockKey,
						pos = cc.p(100, 220)
					}):anonyOnly(arg_2_0, arg_2_0:getIdx(arg_2_2))
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	["strengthenPanel.list"] = {
		varname = "strengthenList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				topPadding = 10,
				asyncPreload = bindHelper.self("asyncPreload"),
				columnSize = bindHelper.self("midColumnSize"),
				data = bindHelper.self("strengthenData"),
				item = bindHelper.self("strengthenSubList"),
				cell = bindHelper.self("strengthenItem"),
				dataOrderCmp = var_0_2,
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("select"):hide():scale(1.1)

					local var_3_0 = 0
					local var_3_1 = false

					if arg_3_3.type == "item" then
						if (arg_3_3.selectedNum or 0) > 0 then
							var_3_0 = 1
							var_3_1 = true
						end
					elseif arg_3_3.selected then
						var_3_0 = 1
						var_3_1 = true
					end

					arg_3_1:get("tick"):visible(var_3_1)
					bind.extend(arg_3_0, arg_3_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								noColor = true,
								key = arg_3_3.key,
								num = arg_3_3.num and (arg_3_3.selectedNum or 0) or nil,
								targetNum = arg_3_3.num
							},
							specialKey = {
								leftTopLv = arg_3_3.level,
								locked = arg_3_3.locked
							},
							grayState = var_3_0,
							onNode = function(arg_4_0)
								arg_4_0:scale(1.1)
								arg_4_0:setTouchEnabled(false)
							end
						}
					})

					local var_3_2 = arg_3_0.selectItem()

					idlereasy.when(var_3_2, function(arg_5_0, arg_5_1)
						if arg_3_3.type == "item" then
							arg_3_1:get("select"):visible(arg_5_1.key == arg_3_3.key)
						else
							arg_3_1:get("select"):visible(arg_5_1.dbId == arg_3_3.dbId)
						end
					end):anonyOnly(arg_3_0, arg_3_3.dbId or arg_3_3.key)
					bind.touch(arg_3_0, arg_3_1, {
						method = function(arg_6_0, arg_6_1, arg_6_2, ...)
							arg_3_0.itemTouch(arg_3_1, arg_3_0:getIdx(arg_3_2), arg_3_3, arg_6_2)
						end
					})
				end
			},
			handlers = {
				itemTouch = bindHelper.self("onItemTouch"),
				selectItem = bindHelper.self("selectItem")
			}
		}
	},
	["strengthenPanel.btnStrengthen"] = {
		varname = "btnStrengthen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthenClick")
			}
		}
	},
	["strengthenPanel.btnStrengthen.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["strengthenPanel.quickSelectPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("quickSelectData"),
				item = bindHelper.self("quickSelectItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("bg", "name", "selected")

					var_7_0.bg:texture(arg_7_3.icon)
					var_7_0.name:text(arg_7_3.name)
					var_7_0.selected:visible(arg_7_3.selected == true)
					text.addEffect(var_7_0.name, {
						color = ui.COLORS.QUALITY[arg_7_3.quality]
					})
					bind.touch(arg_7_0, arg_7_1, {
						methods = {
							ended = functools.partial(arg_7_0.clickCell, arg_7_2, arg_7_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onQuickSelectClick")
			}
		}
	},
	["advancePanel.btnReset"] = {
		varname = "btnReset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetClick")
			}
		}
	},
	["advancePanel.btnAdvance"] = {
		varname = "btnAdvance",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAdvanceClick")
			}
		}
	},
	["advancePanel.btnAdvance.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_8_0, arg_8_1)
	arg_8_0.dbId = arg_8_1
	arg_8_0.isFirst = true

	gGameUI.topuiManager:createView("chip", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "CHIP ADVANCE",
		title = "common/txt/txt_bt_mijiqianghua.png"
	})
	arg_8_0:initModel()
	adapt.dockWithScreen(arg_8_0.leftPanel, "left")
	adapt.dockWithScreen(arg_8_0.advancePanel:get("ruleList"), "left")

	local var_8_0, var_8_1 = adapt.centerWithScreen("left", "right", {
		itemWidthExtra = 80,
		itemWidth = arg_8_0.strengthenItem:width()
	}, {
		{
			{
				arg_8_0.strengthenList,
				arg_8_0.strengthenSubList
			},
			"width"
		},
		{
			{
				arg_8_0.strengthenList,
				arg_8_0.quickSelectPanel
			},
			"pos",
			"left"
		},
		{
			{
				arg_8_0.btnStrengthen,
				arg_8_0.strengthenCostPanel,
				arg_8_0.line,
				arg_8_0.tabList,
				arg_8_0.subAttrDetailPanel:get("panel")
			},
			"pos",
			"right"
		}
	})

	arg_8_0.midColumnSize = 4 + (var_8_1 or 0)
	arg_8_0.asyncPreload = arg_8_0.midColumnSize * 5

	arg_8_0:initSubAttrDetailPanel()

	arg_8_0.tabData = idlers.newWithMap({})

	arg_8_0:initTabData()

	arg_8_0.showTab = idler.new(1)

	arg_8_0.showTab:addListener(function(arg_9_0, arg_9_1, arg_9_2)
		arg_8_0.tabData:atproxy(arg_9_1).select = false
		arg_8_0.tabData:atproxy(arg_9_0).select = true

		arg_8_0.advancePanel:visible(arg_9_0 == 2)
		arg_8_0.strengthenPanel:visible(arg_9_0 == 1)
		arg_8_0.leftPanel:get("attrPanel"):visible(arg_9_0 == 1)
	end)

	arg_8_0.sign = false
	arg_8_0.advanceLv = arg_8_0.chipCfg.acquiredLevels[csvSize(arg_8_0.chipCfg.acquiredLevels)]
	arg_8_0.isRefreshBagPanel = idler.new(true)
	arg_8_0.strengthenData = idlers.newWithMap({})
	arg_8_0.advanceData = idlers.newWithMap({})
	arg_8_0.selectItem = idlereasy.new({})
	arg_8_0.costChips = {}
	arg_8_0.costCsvIDs = {}

	arg_8_0:initLeftPanel()
	idlereasy.when(arg_8_0.isRefreshBagPanel, function()
		arg_8_0:setStrengthData()
	end)
	arg_8_0:setAdvanceData()
	arg_8_0:setAttrSelectIdx()
	arg_8_0:initAdvanceRuleList()

	arg_8_0.isFirst = false
end

function var_0_0.initModel(arg_11_0)
	arg_11_0.gold = gGameModel.role:getIdler("gold")
	arg_11_0.rmb = gGameModel.role:getIdler("rmb")

	local var_11_0 = gGameModel.chips:find(arg_11_0.dbId)

	arg_11_0.chipLevel = var_11_0:getIdler("level")
	arg_11_0.chipLevelExp = var_11_0:getIdler("level_exp")
	arg_11_0.chipNow = var_11_0:getIdler("now")
	arg_11_0.chipId = var_11_0:read("chip_id")
	arg_11_0.cardDBID = var_11_0:read("card_db_id")
	arg_11_0.chipCfg = csv.chip.chips[arg_11_0.chipId]
end

function var_0_0.setAttrSelectIdx(arg_12_0)
	local var_12_0, var_12_1 = var_0_1.getAttr(arg_12_0.dbId, nil, true)
	local var_12_2 = {}
	local var_12_3 = 0

	for iter_12_0, iter_12_1 in ipairs(var_12_1) do
		local var_12_4 = iter_12_1.key

		if not var_0_1.ignoreAttr(var_12_4) then
			var_12_3 = var_12_3 + 1

			if iter_12_1.now[2] > 0 then
				var_12_2[var_12_3] = true
			end
		end
	end

	arg_12_0.curSecondAttrSelect:set(var_12_2)
end

function var_0_0.initAdvanceRuleList(arg_13_0)
	local var_13_0 = {}

	for iter_13_0 = 124401, 124405 do
		if not csv.note[iter_13_0] then
			break
		end

		local var_13_1 = csv.note[iter_13_0].fmt or ""

		table.insert(var_13_0, "#C0xFFFFFF#" .. var_13_1)
		table.insert(var_13_0, "")
	end

	beauty.textScroll({
		isRich = true,
		list = arg_13_0.advancePanel:get("ruleList"),
		strs = var_13_0
	})
end

function var_0_0.initTabData(arg_14_0)
	local var_14_0 = {
		{
			name = gLanguageCsv.chipStrengthenSpace
		},
		{
			unlockKey = "chipAdvance",
			name = gLanguageCsv.chipAdvanceSpace
		}
	}
	local var_14_1 = {}

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if not iter_14_1.unlockKey or dataEasy.isShow(iter_14_1.unlockKey) then
			var_14_1[iter_14_0] = clone(iter_14_1)
		end
	end

	arg_14_0.tabData:update(var_14_1)
end

function var_0_0.onTabItemClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if arg_15_4.unlockKey and not dataEasy.isUnlock(arg_15_4.unlockKey) then
		gGameUI:showTip(dataEasy.getUnlockTip(arg_15_4.unlockKey))
	else
		arg_15_0.showTab:set(arg_15_3)
	end
end

function var_0_0.initLeftPanel(arg_16_0)
	local var_16_0 = arg_16_0.leftPanel:multiget("itemName", "itemIconBg", "itemIcon", "cardIcon", "cardNote")
	local var_16_1 = arg_16_0.chipCfg.quality

	var_16_0.itemName:text(arg_16_0.chipCfg.name)
	text.addEffect(var_16_0.itemName, {
		color = ui.COLORS.QUALITY[var_16_1]
	})
	var_16_0.itemIconBg:texture(string.format("city/card/helditem/strengthen/img_dt%d.png", var_16_1))
	bind.extend(arg_16_0, var_16_0.itemIcon, {
		class = "icon_key",
		props = {
			noListener = true,
			simpleShow = true,
			data = {
				key = arg_16_0.chipId
			},
			onNode = function(arg_17_0)
				arg_17_0:scale(2)
				arg_17_0:get("fragBg"):show()
			end
		}
	})
	var_16_0.cardNote:hide()

	if arg_16_0.cardDBID then
		var_16_0.cardNote:show()

		local var_16_2 = gGameModel.cards:find(arg_16_0.cardDBID):read("card_id", "skin_id", "advance", "level", "star")
		local var_16_3 = csv.cards[var_16_2.card_id]
		local var_16_4 = csv.unit[var_16_3.unitID]
		local var_16_5 = dataEasy.getUnitId(var_16_2.card_id, var_16_2.skin_id)

		bind.extend(arg_16_0, var_16_0.cardIcon, {
			class = "card_icon",
			props = {
				levelProps = {
					data = var_16_2.level
				},
				rarity = var_16_4.rarity,
				unitId = var_16_5,
				advance = var_16_2.advance,
				star = var_16_2.star,
				onNode = function(arg_18_0)
					arg_18_0:scale(1.1)
					arg_18_0:alignCenter(var_16_0.cardIcon:size())
				end
			}
		})
	end

	local var_16_6 = arg_16_0.leftPanel:get("levelPanel")

	arg_16_0.clientChipLevel = idler.new()
	arg_16_0.clientChipLevelExp = idler.new()
	arg_16_0.clientChipAddExp = idler.new()
	arg_16_0.clientChipLeftAddExp = 0

	idlereasy.when(arg_16_0.chipLevel, function(arg_19_0, arg_19_1)
		var_16_6:get("level1"):text("Lv" .. arg_19_1)
		arg_16_0.clientChipLevel:set(arg_19_1, true)

		arg_16_0.sign = arg_19_1 >= arg_16_0.advanceLv

		arg_16_0.costPanel:visible(arg_16_0.sign)
		arg_16_0.advanceTip:visible(not arg_16_0.sign)
		arg_16_0.btnAdvance:setTouchEnabled(arg_16_0.sign)
		uiEasy.setBtnShader(arg_16_0.btnAdvance, arg_16_0.btnAdvance:get("title"), not arg_16_0.sign and 2 or 1)

		if not arg_16_0.sign then
			text.deleteAllEffect(arg_16_0.btnAdvance:get("title"))
		else
			text.addEffect(arg_16_0.btnAdvance:get("title"), {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	end)
	idlereasy.any({
		arg_16_0.chipLevelExp,
		arg_16_0.chipLevel
	}, function(arg_20_0, arg_20_1)
		arg_16_0.clientChipAddExp:set(0, true)

		arg_16_0.costChips = {}
		arg_16_0.costCsvIDs = {}

		arg_16_0:setStrengthData()
	end)
	idlereasy.when(arg_16_0.clientChipLevel, function(arg_21_0, arg_21_1)
		local var_21_0 = var_16_6:multiget("level1", "iconArrow", "level2", "iconMax")
		local var_21_1 = arg_21_1 == arg_16_0.chipLevel:read()

		var_21_0.iconArrow:visible(not var_21_1)
		var_21_0.level2:visible(not var_21_1)

		if not var_21_1 then
			var_21_0.level2:text("Lv" .. arg_21_1)
		end

		var_21_0.iconMax:visible(arg_21_1 >= arg_16_0.chipCfg.maxLevel)
		adapt.oneLinePos(var_21_0.level1, {
			var_21_0.iconArrow,
			var_21_0.level2,
			var_21_0.iconMax
		}, cc.p(0, 0))
	end)
	idlereasy.any({
		arg_16_0.clientChipAddExp,
		arg_16_0.gold
	}, function(arg_22_0, arg_22_1, arg_22_2)
		local var_22_0 = arg_16_0.chipLevel:read()
		local var_22_1 = arg_16_0.chipLevelExp:read() + arg_22_1
		local var_22_2 = 0
		local var_22_3 = arg_16_0.chipCfg.strengthSeq

		for iter_22_0 = var_22_0, arg_16_0.chipCfg.maxLevel - 1 do
			local var_22_4 = csv.chip.strength_cost[iter_22_0]["levelExp" .. var_22_3]

			if var_22_4 <= var_22_1 then
				var_22_0 = var_22_0 + 1
				var_22_1 = var_22_1 - var_22_4
			else
				var_22_2 = var_22_2 + var_22_4
			end
		end

		local var_22_5 = var_22_2 - var_22_1

		arg_16_0.clientChipLeftAddExp = var_22_5

		arg_16_0.clientChipLevelExp:set(var_22_1)
		arg_16_0.clientChipLevel:set(var_22_0)

		local var_22_6 = csv.chip.strength_cost[var_22_0]["levelExp" .. var_22_3]

		if var_22_0 == arg_16_0.chipCfg.maxLevel then
			var_22_6 = csv.chip.strength_cost[var_22_0 - 1]["levelExp" .. var_22_3]
			var_22_1 = var_22_6
		end

		var_16_6:get("bar"):percent(100 * var_22_1 / var_22_6)
		var_16_6:get("percent"):text(var_22_1 .. "/" .. var_22_6)
		uiEasy.setBtnShader(arg_16_0.btnStrengthen, arg_16_0.btnStrengthen:get("title"), arg_22_1 == 0 and 2 or 1)

		if arg_22_1 == 0 then
			text.deleteAllEffect(arg_16_0.btnStrengthen:get("title"))
		else
			text.addEffect(arg_16_0.btnStrengthen:get("title"), {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end

		arg_16_0.strengthenCostGold = arg_22_1 * gCommonConfigCsv.chipExpNeedGold

		arg_16_0.strengthenCostPanel:show()

		local var_22_7 = arg_16_0.strengthenCostPanel:multiget("cost", "icon", "note")

		var_22_7.cost:text(arg_16_0.strengthenCostGold)

		local var_22_8 = arg_22_2 >= arg_16_0.strengthenCostGold

		text.addEffect(var_22_7.cost, {
			color = var_22_8 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED
		})
		adapt.oneLinePos(var_22_7.icon, {
			var_22_7.cost,
			var_22_7.note
		}, cc.p(10, 0), "right")
	end)

	local var_16_7 = arg_16_0.leftPanel:get("attrPanel")
	local var_16_8 = var_16_7:get("attrList")

	var_16_8:setScrollBarEnabled(false)
	var_16_7:get("attrTip"):text(gLanguageCsv.strengthenSecondTip)

	arg_16_0.leftFirstAttrsData = {}
	arg_16_0.leftSecondAttrsData = {}

	idlereasy.any({
		arg_16_0.clientChipLevel,
		arg_16_0.chipLevel,
		arg_16_0.chipNow
	}, function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		local var_23_0 = 0
		local var_23_1, var_23_2 = var_0_1.getAttr(arg_16_0.dbId, nil, true, true)
		local var_23_3, var_23_4 = var_0_1.getAttr(arg_16_0.dbId, arg_23_1, true)
		local var_23_5 = arg_23_1 >= arg_16_0.chipCfg.maxLevel

		for iter_23_0, iter_23_1 in ipairs(var_23_1) do
			local var_23_6 = iter_23_1.key

			if not var_0_1.ignoreAttr(var_23_6) then
				var_23_0 = var_23_0 + 1

				local var_23_7 = iter_23_1.val
				local var_23_8

				if arg_23_1 ~= arg_23_2 then
					var_23_8 = dataEasy.attrSubtraction(var_23_3[iter_23_0].val, var_23_7)
				end

				arg_16_0:setLeftAttrItem(1, var_23_0, {
					key = var_23_6,
					val = var_23_7,
					upVal = var_23_8,
					isMax = var_23_5
				})
			end
		end

		if arg_16_0.isFirst then
			local var_23_9 = var_16_7:get("lineItem"):clone():show()

			var_16_8:pushBackCustomItem(var_23_9)
		end

		local var_23_10 = 0

		for iter_23_2, iter_23_3 in ipairs(var_23_2) do
			local var_23_11 = iter_23_3.key

			if not var_0_1.ignoreAttr(var_23_11) then
				var_23_10 = var_23_10 + 1

				local var_23_12 = iter_23_3.val

				arg_16_0:setLeftAttrItem(2, var_23_10, {
					key = var_23_11,
					val = var_23_12,
					name = iter_23_3.name
				})
			end
		end

		local var_23_13 = false

		for iter_23_4, iter_23_5 in csvPairs(arg_16_0.chipCfg.acquiredLevels) do
			if arg_23_2 < iter_23_5 and iter_23_5 <= arg_23_1 then
				var_23_13 = true

				break
			end
		end

		if not var_23_13 then
			for iter_23_6, iter_23_7 in ipairs(arg_23_3) do
				if iter_23_7[3] < csvSize(csv.chip.libs[iter_23_7[1]].attrNum1) - 1 then
					for iter_23_8, iter_23_9 in csvPairs(arg_16_0.chipCfg.strengthLevels) do
						if arg_23_2 < iter_23_9 and iter_23_9 <= arg_23_1 then
							var_23_13 = true

							break
						end
					end

					break
				end
			end
		end

		var_16_7:get("attrTip"):visible(var_23_13)
	end)

	arg_16_0.quickSelectData = idlers.newWithMap({
		{
			icon = "city/develop/explore/tag_2.png",
			quality = 2,
			name = gLanguageCsv.greenText
		},
		{
			icon = "city/develop/explore/tag_3.png",
			quality = 3,
			name = gLanguageCsv.blueText
		},
		{
			icon = "city/develop/explore/tag_4.png",
			quality = 4,
			name = gLanguageCsv.purpleText
		},
		{
			icon = "city/develop/explore/tag_5.png",
			quality = 5,
			name = gLanguageCsv.orangeText
		}
	})
end

function var_0_0.setLeftAttrItem(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_0.leftPanel:get("attrPanel")
	local var_24_1 = var_24_0:get("attrList")
	local var_24_2 = arg_24_1 == 1 and arg_24_0.leftFirstAttrsData or arg_24_0.leftSecondAttrsData
	local var_24_3 = arg_24_3.key and var_0_1.getAttrName(arg_24_3.key) or arg_24_3.name
	local var_24_4 = arg_24_3.key and "+" .. arg_24_3.val or arg_24_3.val
	local var_24_5

	if var_24_2[arg_24_2] then
		var_24_5 = var_24_2[arg_24_2].item
		arg_24_3.isNew = false

		if arg_24_0.isStrengthenClick then
			arg_24_3.isNew = var_24_2[arg_24_2].isNew
		end

		if var_24_5:get("name"):text() ~= var_24_3 or var_24_5:get("val"):text() ~= var_24_4 then
			performWithDelay(arg_24_0, function()
				if not tolua.isnull(var_24_5) then
					(var_24_5:get("effect") or widget.addAnimationByKey(var_24_5, "effect/shuzisaoguang.skel", "effect", "effect", 100):xy(100, 40):scale(2, 0.5)):play("effect")
				end
			end, 0.1)
		end
	else
		var_24_5 = var_24_0:get("attrItem"):clone():show()

		var_24_1:pushBackCustomItem(var_24_5)

		arg_24_3.isNew = not arg_24_0.isFirst
	end

	arg_24_3.item = var_24_5
	var_24_2[arg_24_2] = arg_24_3

	var_24_5:get("name"):text(var_24_3)
	var_24_5:get("val"):text(var_24_4)

	local var_24_6 = arg_24_3.key and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.GRAY

	text.addEffect(var_24_5:get("name"), {
		color = var_24_6
	})
	text.addEffect(var_24_5:get("val"), {
		color = var_24_6
	})

	local var_24_7 = var_24_5:multiget("up1", "upVal", "upIcon", "up2")

	itertools.invoke(var_24_7, "visible", arg_24_3.upVal ~= nil)

	if arg_24_3.upVal then
		var_24_5:get("upVal"):text("+" .. arg_24_3.upVal)
		adapt.oneLinePos(var_24_7.up1, {
			var_24_7.upVal,
			var_24_7.upIcon,
			var_24_7.up2
		})
	end

	var_24_5:get("iconMax"):visible(not arg_24_3.upVal and arg_24_3.isMax or false)
	var_24_5:get("iconNew"):visible(not arg_24_3.upVal and arg_24_3.isNew or false)
end

function var_0_0.getStrengthData(arg_26_0)
	local var_26_0 = gGameModel.role:read("chips")
	local var_26_1 = gGameModel.role:read("items")
	local var_26_2 = {}
	local var_26_3 = 0
	local var_26_4 = 0

	for iter_26_0, iter_26_1 in ipairs(gChipExpCsv) do
		local var_26_5 = dataEasy.getNumByKey(iter_26_1.id)

		if var_26_5 > 0 then
			var_26_3 = var_26_3 + 1

			local var_26_6 = csv.items[iter_26_1.id].specialArgsMap.chipExp

			table.insert(var_26_2, {
				type = "item",
				key = iter_26_1.id,
				num = var_26_5,
				idx = var_26_3,
				exp = var_26_6,
				selectedNum = arg_26_0.costCsvIDs[iter_26_1.id]
			})
		end
	end

	for iter_26_2, iter_26_3 in ipairs(var_26_0) do
		local var_26_7 = gGameModel.chips:find(iter_26_3):read("chip_id", "card_db_id", "level", "level_exp", "sum_exp", "locked")

		if iter_26_3 ~= arg_26_0.dbId and not var_26_7.card_db_id then
			var_26_3 = var_26_3 + 1

			local var_26_8 = var_26_7.chip_id
			local var_26_9 = csv.chip.chips[var_26_8]
			local var_26_10 = var_26_9.exp + var_26_7.sum_exp

			if var_26_7.locked and arg_26_0.costChips[iter_26_3] then
				arg_26_0.costChips[iter_26_3] = nil
				var_26_4 = var_26_4 - var_26_10
			end

			table.insert(var_26_2, {
				dbId = iter_26_3,
				key = var_26_8,
				level = var_26_7.level,
				locked = var_26_7.locked,
				cfg = var_26_9,
				idx = var_26_3,
				exp = var_26_10,
				selected = arg_26_0.costChips[iter_26_3]
			})
		end
	end

	arg_26_0.clientChipAddExp:modify(function(arg_27_0)
		return true, arg_27_0 + var_26_4
	end, true)

	return var_26_2
end

function var_0_0.setStrengthData(arg_28_0)
	local var_28_0 = arg_28_0:getStrengthData()

	dataEasy.tryCallFunc(arg_28_0.strengthenList, "updatePreloadCenterIndexAdaptFirst")
	arg_28_0.strengthenData:update(var_28_0)
	arg_28_0.empty:visible(itertools.size(var_28_0) == 0)
end

function var_0_0.onItemChange(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	arg_29_0.costCsvIDs[arg_29_3.key] = arg_29_4

	bind.extend(arg_29_1, arg_29_2, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				noColor = true,
				key = arg_29_3.key,
				num = arg_29_4,
				targetNum = arg_29_3.num
			},
			grayState = arg_29_4 > 0 and 1 or 0
		}
	})
	arg_29_2:get("tick"):visible(arg_29_4 > 0)
	arg_29_0.clientChipAddExp:modify(function(arg_30_0)
		return true, arg_29_0.originClientChipAddExp + arg_29_3.exp * arg_29_4
	end)
end

function var_0_0.onItemTouchShow(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = arg_31_2:convertToWorldSpaceAR(cc.p(0, 0))
	local var_31_1 = "right"

	if arg_31_3.col > 2 then
		var_31_1 = "left"
	end

	if arg_31_4.type == "item" then
		local var_31_2 = arg_31_0.costCsvIDs[arg_31_4.key] or 0

		arg_31_0.originClientChipAddExp = arg_31_0.clientChipAddExp:read() - arg_31_4.exp * var_31_2

		local var_31_3 = csv.items[arg_31_4.key].specialArgsMap.chipExp
		local var_31_4 = math.min(var_31_2 + math.ceil(arg_31_0.clientChipLeftAddExp / var_31_3), arg_31_4.num)

		gGameUI:stackUI("city.card.chip.item_details", nil, {
			clickClose = true,
			dispatchNodes = arg_31_0.strengthenPanel
		}, {
			id = arg_31_4.key,
			num = var_31_2,
			maxNum = var_31_4,
			pos = var_31_0,
			align = var_31_1,
			chipId = arg_31_0.chipId,
			clientChipLevel = arg_31_0.clientChipLevel,
			clientChipLevelExp = arg_31_0.clientChipLevelExp,
			changeCb = arg_31_0:createHandler("onItemChange", arg_31_1, arg_31_2, arg_31_4),
			cb = arg_31_0:createHandler("resetSelected")
		})

		arg_31_3.key = arg_31_4.key

		arg_31_0.selectItem:set(arg_31_3)
	else
		local var_31_5 = 0

		if arg_31_0.itemTouchShow then
			gGameUI:stackUI("city.card.chip.details", nil, {
				clickClose = true,
				dispatchNodes = arg_31_0.strengthenPanel
			}, {
				dbId = arg_31_4.dbId,
				pos = var_31_0,
				align = var_31_1,
				showExp = arg_31_4.exp,
				dataRefresh = function()
					arg_31_0.isRefreshBagPanel:notify()
				end,
				cb = arg_31_0:createHandler("resetSelected")
			})

			arg_31_3.dbId = arg_31_4.dbId

			arg_31_0.selectItem:set(arg_31_3)
		elseif arg_31_0.costChips[arg_31_4.dbId] then
			arg_31_0.costChips[arg_31_4.dbId] = nil

			arg_31_0.clientChipAddExp:modify(function(arg_33_0)
				return true, arg_33_0 - arg_31_4.exp
			end)

			local var_31_6 = arg_31_0.quickSelectData:atproxy(arg_31_4.cfg.quality - 1)

			if var_31_6 and var_31_6.selected then
				local var_31_7 = false

				for iter_31_0, iter_31_1 in arg_31_0.strengthenData:ipairs() do
					local var_31_8 = iter_31_1:proxy()

					if var_31_8.type ~= "item" and arg_31_0.costChips[var_31_8.dbId] and var_31_8.cfg.quality == arg_31_4.cfg.quality then
						var_31_7 = true

						break
					end
				end

				if not var_31_7 then
					var_31_6.selected = false
				end
			end
		elseif arg_31_0.clientChipLeftAddExp <= 0 then
			gGameUI:showTip(gLanguageCsv.chipExpMax)
		else
			arg_31_0:showPlanTip(arg_31_4.dbId)

			arg_31_0.costChips[arg_31_4.dbId] = true

			arg_31_0.clientChipAddExp:modify(function(arg_34_0)
				return true, arg_34_0 + arg_31_4.exp
			end)
		end

		arg_31_2:get("tick"):visible(arg_31_0.costChips[arg_31_4.dbId] ~= nil)
		bind.extend(arg_31_1, arg_31_2, {
			class = "icon_key",
			props = {
				noListener = true,
				data = {
					key = arg_31_4.key,
					num = arg_31_4.num,
					targetNum = arg_31_4.num and 0 or nil
				},
				grayState = arg_31_0.costChips[arg_31_4.dbId] ~= nil and 1 or 0,
				specialKey = {
					leftTopLv = arg_31_4.level,
					locked = arg_31_4.locked
				}
			}
		})
	end
end

function var_0_0.onItemTouch(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5)
	if arg_35_5.name == "began" then
		arg_35_0.touchBeganPos = arg_35_5
		arg_35_0.isClicked = true
		arg_35_0.itemTouchShow = false

		if arg_35_0.sequence then
			arg_35_0:stopAction(arg_35_0.sequence)
		end

		arg_35_0.strengthenList:setTouchEnabled(true)

		arg_35_0.sequence = cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
			if arg_35_4.type ~= "item" then
				arg_35_0.itemTouchShow = true

				arg_35_0:onItemTouchShow(arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				arg_35_0.strengthenList:setTouchEnabled(false)
			end

			arg_35_0.sequence = nil
		end))

		arg_35_0:runAction(arg_35_0.sequence)
	elseif arg_35_5.name == "moved" then
		if arg_35_0.isClicked then
			local var_35_0 = math.abs(arg_35_5.x - arg_35_0.touchBeganPos.x)
			local var_35_1 = math.abs(arg_35_5.y - arg_35_0.touchBeganPos.y)

			if var_35_0 >= ui.TOUCH_MOVED_THRESHOLD or var_35_1 >= ui.TOUCH_MOVED_THRESHOLD then
				arg_35_0.isClicked = false

				if arg_35_0.sequence then
					arg_35_0:stopAction(arg_35_0.sequence)

					arg_35_0.sequence = nil
				end
			end
		end
	elseif arg_35_5.name == "ended" or arg_35_5.name == "cancelled" then
		if arg_35_0.sequence then
			arg_35_0:stopAction(arg_35_0.sequence)

			arg_35_0.sequence = nil
		end

		if arg_35_0.isClicked and not arg_35_0.itemTouchShow then
			if arg_35_4.locked then
				gGameUI:showTip(gLanguageCsv.chipStrengthenLocked)
			else
				arg_35_0:onItemTouchShow(arg_35_1, arg_35_2, arg_35_3, arg_35_4)
			end
		end
	end
end

function var_0_0.resetSelected(arg_37_0)
	arg_37_0.selectItem:set({})
end

function var_0_0.onStrengthenClick(arg_38_0)
	if arg_38_0.strengthenCostGold > arg_38_0.gold:read() then
		gGameUI:showTip(gLanguageCsv.goldNotEnough)

		return
	end

	local var_38_0 = {}

	for iter_38_0, iter_38_1 in pairs(arg_38_0.costCsvIDs) do
		if iter_38_1 > 0 then
			var_38_0[iter_38_0] = iter_38_1
		end
	end

	local var_38_1 = false
	local var_38_2 = {}
	local var_38_3 = 0

	for iter_38_2, iter_38_3 in pairs(arg_38_0.costChips) do
		table.insert(var_38_2, iter_38_2)

		local var_38_4 = gGameModel.chips:find(iter_38_2):read("chip_id", "sum_exp")

		var_38_3 = var_38_3 + var_38_4.sum_exp

		if not var_38_1 and (csv.chip.chips[var_38_4.chip_id].quality >= 4 or var_38_4.sum_exp > 0) then
			var_38_1 = true
		end
	end

	local var_38_5 = gLanguageCsv.strengthenSuccess

	if var_38_3 > 0 then
		var_38_5 = var_38_5 .. string.format(gLanguageCsv.chipStrengthComeBack, var_38_3 * gCommonConfigCsv.chipExpNeedGold)
	end

	local function var_38_6()
		arg_38_0.isStrengthenClick = true

		gGameApp:requestServer("/game/card/chip/strength", function()
			arg_38_0:setEffect()
			gGameUI:showTip(var_38_5)

			arg_38_0.isStrengthenClick = false

			for iter_40_0, iter_40_1 in arg_38_0.quickSelectData:ipairs() do
				iter_40_1:proxy().selected = false
			end
		end, arg_38_0.dbId, var_38_2, var_38_0)
	end

	if var_38_1 then
		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = gLanguageCsv.chipStrengthenTip,
			cb = var_38_6
		})
	else
		var_38_6()
	end
end

function var_0_0.setAdvanceData(arg_41_0)
	local var_41_0 = arg_41_0.advancePanel:get("attrList")

	var_41_0:setScrollBarEnabled(false)

	local var_41_1 = arg_41_0.btnAdvance:x()

	arg_41_0.advanceFirstAttrsData = {}
	arg_41_0.advanceSecondAttrsData = {}
	arg_41_0.curSecondAttrSelect = idlertable.new({})

	local var_41_2 = 0

	arg_41_0.isFirstAdvance = true

	idlereasy.any({
		arg_41_0.chipLevel,
		arg_41_0.chipNow,
		arg_41_0.gold
	}, function()
		var_41_2 = var_41_2 + 1

		performWithDelay(arg_41_0, function()
			if var_41_2 > 0 then
				var_41_2 = 0
				arg_41_0.advanceCount = 0

				local var_43_0 = 0
				local var_43_1 = arg_41_0.chipNow:read()

				for iter_43_0, iter_43_1 in pairs(var_43_1) do
					if iter_43_1[2] > 0 then
						arg_41_0.advanceCount = arg_41_0.advanceCount + 1
					end

					var_43_0 = math.max(var_43_0, iter_43_1[2])
				end

				local var_43_2, var_43_3 = var_0_1.getAttr(arg_41_0.dbId, nil, true)
				local var_43_4 = 0

				for iter_43_2, iter_43_3 in ipairs(var_43_2) do
					local var_43_5 = iter_43_3.key

					if not var_0_1.ignoreAttr(var_43_5) then
						var_43_4 = var_43_4 + 1

						arg_41_0:setAdvanceAttrItem(1, var_43_4, iter_43_3)
					end
				end

				if arg_41_0.isFirstAdvance then
					arg_41_0.isFirstAdvance = false

					local var_43_6 = arg_41_0.advancePanel:get("lineItem"):clone():show()

					var_41_0:pushBackCustomItem(var_43_6)
					bind.touch(arg_41_0, var_43_6:get("detail"), {
						methods = {
							ended = function()
								arg_41_0.subAttrDetailPanel:show()
							end
						}
					})
				end

				for iter_43_4 = 1, 4 do
					local var_43_7 = var_43_3[iter_43_4]

					if not var_43_7 then
						arg_41_0:setAdvanceAttrItem(2, iter_43_4, nil)
					else
						local var_43_8 = var_43_7.key

						if not var_0_1.ignoreAttr(var_43_8) then
							arg_41_0:setAdvanceAttrItem(2, iter_43_4, var_43_7)
						end
					end
				end

				local var_43_9 = arg_41_0.costPanel:multiget("note", "cost1", "icon1", "cost2", "icon2")
				local var_43_10 = csv.chip.recast_cost[math.min(var_43_0 + 1, csvSize(csv.chip.recast_cost))]["costItemMap" .. arg_41_0.chipCfg.recastCostSeq]

				arg_41_0.advanceCost = var_43_10

				local var_43_11 = 0
				local var_43_12 = {}
				local var_43_13 = true

				for iter_43_5, iter_43_6 in csvMapPairs(var_43_10) do
					var_43_11 = var_43_11 + 1

					if var_43_11 <= 2 then
						var_43_9["cost" .. var_43_11]:text(iter_43_6):show()
						var_43_9["icon" .. var_43_11]:texture(dataEasy.getIconResByKey(iter_43_5)):show()

						local var_43_14 = iter_43_6 <= dataEasy.getNumByKey(iter_43_5)

						var_43_13 = var_43_13 and var_43_14

						text.addEffect(var_43_9["cost" .. var_43_11], {
							color = var_43_14 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED
						})
						table.insert(var_43_12, cc.p(15, 0))
						table.insert(var_43_12, cc.p(0, 0))
					end
				end

				for iter_43_7 = var_43_11 + 1, 2 do
					var_43_9["cost" .. iter_43_7]:hide()
					var_43_9["icon" .. iter_43_7]:hide()
				end

				adapt.oneLineCenterPos(cc.p(arg_41_0.costPanel:width() / 2, arg_41_0.costPanel:height() / 2), {
					var_43_9.note,
					var_43_9.cost1,
					var_43_9.icon1,
					var_43_9.cost2,
					var_43_9.icon2
				}, var_43_12)

				if var_43_0 == 0 or not dataEasy.isUnlock("chipAdvanceReset") or not arg_41_0.sign then
					local var_43_15 = (arg_41_0.btnReset:x() + var_41_1) / 2

					arg_41_0.costPanel:x(var_43_15)
					arg_41_0.btnAdvance:x(var_43_15)
					arg_41_0.advanceTip:x(var_43_15)
					arg_41_0.resetCostPanel:hide()
					arg_41_0.btnReset:hide()
				else
					arg_41_0.costPanel:x(var_41_1)
					arg_41_0.btnAdvance:x(var_41_1)
					arg_41_0.resetCostPanel:show()
					arg_41_0.btnReset:show()

					local var_43_16 = arg_41_0.resetCostPanel:multiget("note", "cost1", "icon1")

					var_43_16.cost1:text(gCommonConfigCsv.chipResetCost)
					var_43_16.icon1:texture(dataEasy.getIconResByKey("rmb"))
					adapt.oneLineCenterPos(cc.p(arg_41_0.resetCostPanel:width() / 2, arg_41_0.resetCostPanel:height() / 2), {
						var_43_16.note,
						var_43_16.cost1,
						var_43_16.icon1
					}, {
						cc.p(15, 0),
						cc.p(0, 0)
					})
				end

				arg_41_0.isAdvanceClick = false
			end
		end, 0)
	end)
end

function var_0_0.setAdvanceAttrItem(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = arg_45_0.advancePanel:get("attrList")
	local var_45_1 = arg_45_1 == 1 and arg_45_0.advanceFirstAttrsData or arg_45_0.advanceSecondAttrsData
	local var_45_2

	if arg_45_3 == nil then
		if var_45_1[arg_45_2] then
			var_45_1[arg_45_2].item:hide()
		end

		return
	end

	if var_45_1[arg_45_2] then
		var_45_2 = var_45_1[arg_45_2].item

		var_45_2:show()

		arg_45_3.isNew = false

		local var_45_3 = arg_45_0.curSecondAttrSelect:read()

		if arg_45_1 == 2 and arg_45_0.isAdvanceClick and var_45_3[arg_45_2] then
			arg_45_3.isNew = true

			;(var_45_2:get("effect") or widget.addAnimationByKey(var_45_2, "effect/shuzisaoguang.skel", "effect", "effect", 100):xy(100, 40):scale(2, 0.5)):play("effect")
		end
	else
		var_45_2 = arg_45_0.advancePanel:get("attrItem"):clone():show()

		var_45_0:pushBackCustomItem(var_45_2)
	end

	local var_45_4 = "+" .. arg_45_3.val

	arg_45_3.item = var_45_2
	var_45_1[arg_45_2] = arg_45_3

	local var_45_5 = arg_45_3.key
	local var_45_6 = var_0_1.getAttrName(var_45_5)

	var_45_2:get("name"):text(var_45_6)
	var_45_2:get("val"):text(var_45_4)
	var_45_2:get("iconNew"):visible(arg_45_3.isNew or false)
	adapt.oneLinePos(var_45_2:get("val"), var_45_2:get("iconNew"), cc.p(10, 0))
	var_45_2:get("checkBox"):hide()
	var_45_2:get("selected"):hide()

	if arg_45_3.now then
		var_45_2:get("selected"):visible(arg_45_3.now[2] > 0)
		bind.click(arg_45_0, var_45_2:get("checkBox"), {
			method = function()
				local var_46_0 = arg_45_0.curSecondAttrSelect:read()
				local var_46_1 = 0

				for iter_46_0, iter_46_1 in pairs(var_46_0) do
					if iter_46_1 then
						var_46_1 = var_46_1 + 1
					end
				end

				if not var_46_0[arg_45_2] and var_46_1 >= 2 then
					gGameUI:showTip(gLanguageCsv.chipAdvanceSelectedMax)
				else
					arg_45_0.curSecondAttrSelect:modify(function(arg_47_0)
						arg_47_0[arg_45_2] = not arg_47_0[arg_45_2]

						return true, arg_47_0
					end)
				end
			end
		})
		idlereasy.when(arg_45_0.curSecondAttrSelect, function(arg_48_0, arg_48_1)
			if arg_45_0.advanceCount >= 2 then
				if arg_45_3.now[2] > 0 then
					var_45_2:get("checkBox"):show()
					var_45_2:get("checkBox.icon"):setSelectedState(arg_48_1[arg_45_2] or false)
				end
			else
				var_45_2:get("checkBox"):show()
				var_45_2:get("checkBox.icon"):setSelectedState(arg_48_1[arg_45_2] or false)
			end

			if not arg_45_0.sign then
				var_45_2:get("checkBox"):hide()
			end
		end):anonyOnly(arg_45_0, arg_45_2)
	end
end

function var_0_0.onResetClick(arg_49_0)
	if gCommonConfigCsv.chipResetCost > arg_49_0.rmb:read() then
		gGameUI:showTip(gLanguageCsv.rmbNotEnough)

		return
	end

	gGameUI:stackUI("city.card.chip.advance_reset", nil, nil, {
		dbId = arg_49_0.dbId,
		cb = function()
			gGameApp:requestServer("/game/card/chip/recast/reset", function()
				arg_49_0.curSecondAttrSelect:set({})
				gGameUI:showTip(gLanguageCsv.resetSuccess)
			end, arg_49_0.dbId)
		end
	})
end

function var_0_0.initSubAttrDetailPanel(arg_52_0)
	arg_52_0.subAttrDetailPanel:hide()
	bind.click(arg_52_0, arg_52_0.subAttrDetailPanel, {
		method = function()
			arg_52_0.subAttrDetailPanel:hide()
		end
	})

	local var_52_0 = arg_52_0.subAttrDetailPanel:get("panel"):multiget("list", "bg")

	var_52_0.list:setScrollBarEnabled(false)

	local var_52_1 = 1
	local var_52_2 = {
		{
			str = "#C0x5b545b##L10#" .. gLanguageCsv.chipSubAttrRandom
		}
	}

	table.insert(var_52_2, {
		str = "#C0xF13B54##L10#" .. gLanguageCsv.chipAdvanceTip
	})

	for iter_52_0, iter_52_1 in orderCsvPairs(csv.chip.libs) do
		if iter_52_1.randomLibID == arg_52_0.chipCfg.acquiredLib then
			var_52_1 = var_52_1 + 1

			local var_52_3 = iter_52_1.attrType1
			local var_52_4 = dataEasy.getAttrValueString(iter_52_1.attrType1, iter_52_1.attrNum1[1])
			local var_52_5 = dataEasy.getAttrValueString(iter_52_1.attrType1, iter_52_1.attrNum1[table.nums(iter_52_1.attrNum1)])

			table.insert(var_52_2, {
				str = "#C0x5b545b#" .. iter_52_1.attrsDesc .. "(" .. "#C0x5C9970#" .. var_52_4 .. "~" .. var_52_5 .. "#C0x5b545b#)"
			})
		end
	end

	local var_52_6 = var_52_1 * 65
	local var_52_7 = var_52_0.list:size()

	var_52_0.list:size(cc.size(var_52_7.width, var_52_6 + 100))
	var_52_0.list:y(var_52_0.list:y() + var_52_7.height - (var_52_6 + 90))
	beauty.textScroll({
		margin = 20,
		isRich = true,
		list = var_52_0.list,
		strs = var_52_2
	})
	var_52_0.bg:size(cc.size(var_52_0.bg:size().width, var_52_6 + 140))
end

function var_0_0.onAdvanceClick(arg_54_0)
	local var_54_0
	local var_54_1

	for iter_54_0, iter_54_1 in pairs(arg_54_0.curSecondAttrSelect:read()) do
		if iter_54_1 == true then
			if not var_54_0 then
				var_54_0 = iter_54_0
			else
				var_54_1 = var_54_1 or iter_54_0
			end
		end
	end

	if not var_54_0 then
		gGameUI:showTip(gLanguageCsv.chipAdvanceSelectFirst)

		return
	end

	for iter_54_2, iter_54_3 in csvMapPairs(arg_54_0.advanceCost) do
		if iter_54_3 > dataEasy.getNumByKey(iter_54_2) then
			local var_54_2 = dataEasy.getCfgByKey(iter_54_2)

			gGameUI:showTip(string.format(gLanguageCsv.chipCoinNotEnough, var_54_2.name))

			return
		end
	end

	arg_54_0.isAdvanceClick = true

	gGameApp:requestServer("/game/card/chip/recast", function()
		arg_54_0:setEffect()
	end, arg_54_0.dbId, var_54_0, var_54_1)
end

function var_0_0.setEffect(arg_56_0)
	local var_56_0 = arg_56_0.leftPanel:get("itemIcon")
	local var_56_1 = var_56_0:get("effect")

	if not var_56_1 then
		var_56_1 = widget.addAnimation(var_56_0, "koudai_gonghuixunlian/gonghuixunlian.skel", "fangguang2", 10):name("effect"):alignCenter(var_56_0:size()):y(100)

		var_56_1:setSpriteEventHandler(function(arg_57_0, arg_57_1)
			var_56_1:hide()
		end, sp.EventType.ANIMATION_COMPLETE)
	else
		var_56_1:show():play("fangguang2")
	end
end

function var_0_0.showPlanTip(arg_58_0, arg_58_1)
	if var_0_1.isChipPlan(arg_58_1) then
		gGameUI:showTip(gLanguageCsv.planHasExist)
	end
end

function var_0_0.onQuickSelectClick(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	local var_59_0 = arg_59_3.quality
	local var_59_1 = not arg_59_0.quickSelectData:atproxy(arg_59_2).selected

	arg_59_0.quickSelectData:atproxy(arg_59_2).selected = var_59_1

	local var_59_2 = 0
	local var_59_3 = false
	local var_59_4 = false
	local var_59_5 = arg_59_0:getStrengthData()
	local var_59_6 = {}

	table.sort(var_59_5, var_0_2)

	for iter_59_0, iter_59_1 in ipairs(var_59_5) do
		if iter_59_1.type ~= "item" then
			local var_59_7 = iter_59_1.dbId
			local var_59_8 = iter_59_1.cfg
			local var_59_9 = iter_59_1.exp

			if var_59_8.quality == var_59_0 then
				if var_59_1 then
					if not iter_59_1.locked then
						var_59_4 = true
					end

					if not var_59_3 and not arg_59_0.costChips[var_59_7] and not iter_59_1.locked then
						if var_59_2 >= arg_59_0.clientChipLeftAddExp then
							var_59_3 = true
						else
							arg_59_0.costChips[var_59_7] = true

							table.insert(var_59_6, var_59_7)

							var_59_2 = var_59_2 + var_59_9
						end
					end
				elseif arg_59_0.costChips[var_59_7] then
					arg_59_0.costChips[var_59_7] = nil
					var_59_2 = var_59_2 - var_59_9
				end
			end

			iter_59_1.selected = arg_59_0.costChips[var_59_7]
		end
	end

	arg_59_0.clientChipAddExp:modify(function(arg_60_0)
		return true, arg_60_0 + var_59_2
	end, true)

	if var_59_1 and not var_59_4 then
		arg_59_0.quickSelectData:atproxy(arg_59_2).selected = false

		gGameUI:showTip(gLanguageCsv.chipQuickSelectTip)
	elseif var_59_3 then
		gGameUI:showTip(gLanguageCsv.chipExpMax)
	end

	arg_59_0:showPlanTip(var_59_6)
	dataEasy.tryCallFunc(arg_59_0.strengthenList, "updatePreloadCenterIndexAdaptFirst")
	arg_59_0.strengthenData:update(var_59_5)
end

function var_0_0.onBtnRebirth(arg_61_0)
	gGameUI:stackUI("city.card.rebirth.view", nil, {
		full = true
	}, 5)
end

function var_0_0.onShowRule(arg_62_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_62_0:createHandler("getRuleContext"), {
		width = 1181,
		height = 1038
	})
end

local function var_0_3(arg_63_0)
	local var_63_0 = ""

	for iter_63_0, iter_63_1 in ipairs(arg_63_0) do
		var_63_0 = var_63_0 .. iter_63_1

		if arg_63_0[iter_63_0 + 1] then
			var_63_0 = var_63_0 .. ","
		end
	end

	return var_63_0
end

function var_0_0.getRuleContext(arg_64_0, arg_64_1)
	local var_64_0 = adaptContext
	local var_64_1 = {
		var_64_0.clone(arg_64_1.title, function(arg_65_0)
			arg_65_0:get("text"):text(gLanguageCsv.chipAdvanceRule)
		end),
		var_64_0.noteText(124701, 124705)
	}
	local var_64_2 = {}

	table.insert(var_64_2, {
		sign = true,
		key = csv.note[124706].fmt,
		main = csv.note[124707].fmt,
		sec = csv.note[124708].fmt
	})

	local var_64_3 = {}

	for iter_64_0, iter_64_1 in csvPairs(csv.chip.chips) do
		var_64_3[iter_64_1.quality] = iter_64_1
	end

	for iter_64_2, iter_64_3 in pairs(var_64_3) do
		local var_64_4 = ui.QUALITYCOLOR[iter_64_2] .. gLanguageCsv[ui.QUALITY_COLOR_SINGLE_TEXT[iter_64_2]]
		local var_64_5 = var_0_3(iter_64_3.acquiredLevels)
		local var_64_6 = var_0_3(iter_64_3.strengthLevels)

		table.insert(var_64_2, {
			sign = false,
			key = var_64_4,
			main = var_64_5,
			sec = var_64_6
		})
	end

	for iter_64_4 = 1, 6 do
		table.insert(var_64_1, var_64_0.clone(arg_64_0.panelRule, function(arg_66_0)
			local var_66_0 = arg_66_0:multiget("txtKey", "txtMain", "txtSec", "img")
			local var_66_1 = var_64_2[iter_64_4]

			var_66_0.txtKey:hide()

			local var_66_2 = rich.createWithWidth(var_66_1.key, 40, nil, 1000, nil, cc.p(0.5, 0)):anchorPoint(0, 0.5):xy(var_66_0.txtKey:xy()):addTo(arg_66_0)

			var_66_0.txtMain:text(var_66_1.main)
			var_66_0.txtSec:text(var_66_1.sec)
			var_66_0.img:visible(var_66_1.sign)
		end))
	end

	return var_64_1
end

return var_0_0
