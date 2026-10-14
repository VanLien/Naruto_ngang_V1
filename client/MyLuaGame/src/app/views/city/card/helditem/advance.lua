local var_0_0 = 350
local var_0_1 = require("app.views.city.card.helditem.tools")

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0:get("cost")

	var_1_0:text(arg_1_2)

	local var_1_1 = arg_1_2 <= arg_1_1 and ui.NEWCOLORS.WHITE or ui.COLORS.NORMAL.RED

	text.addEffect(var_1_0, {
		color = var_1_1
	})
	adapt.oneLinePos(var_1_0, arg_1_0:get("note"), cc.p(8, 0), "right")
	adapt.oneLinePos(var_1_0, arg_1_0:get("icon"), cc.p(18, 0))
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0:get(arg_2_1)

	if not var_2_0 then
		var_2_0 = widget.addAnimationByKey(arg_2_0, "koudai_gonghuixunlian/gonghuixunlian.skel", arg_2_1, "fangguang2", 10):xy(40, 20):scale(0.25)

		var_2_0:setSpriteEventHandler(function(arg_3_0, arg_3_1)
			var_2_0:hide()

			if arg_2_2 then
				arg_2_2()
			end
		end, sp.EventType.ANIMATION_COMPLETE)
	else
		var_2_0:show():play("fangguang2")
	end
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0:removeAllChildren()

	local var_4_0 = {}
	local var_4_1 = csv.held_item.items[arg_4_1]
	local var_4_2 = {
		cfg = var_4_1,
		csvId = arg_4_1,
		advance = arg_4_2
	}
	local var_4_3 = "#C0xEDEDBF#"

	for iter_4_0 = 1, 100 do
		local var_4_4 = var_4_1[string.format("effect%dLevelAdvSeq", iter_4_0)]

		if not var_4_1["effect" .. iter_4_0] or var_4_1["effect" .. iter_4_0] == 0 or not var_4_4 or arg_4_2 < var_4_4[1] then
			break
		end

		local var_4_5 = var_0_1.getStrinigByData(iter_4_0, var_4_2, var_4_3)

		table.insert(var_4_0, var_4_5)
	end

	local var_4_6 = table.concat(var_4_0, "\n")

	if var_4_1.effect2LevelAdvSeq[1] == arg_4_2 and arg_4_3 then
		var_4_6 = var_4_6 .. "#Icommon/icon/txt_new.png-132-54#"
	end

	beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_4_0,
		strs = var_4_3 .. var_4_6
	})
end

local function var_0_5(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.attrNumRates
	local var_5_1 = csv.held_item.advance_attrs[arg_5_2]
	local var_5_2 = var_5_1["attrNum" .. arg_5_0.advanceAttrSeq]
	local var_5_3 = var_5_1["attrRate" .. arg_5_0.advanceAttrSeq]
	local var_5_4 = csv.held_item.level_attrs[arg_5_1]["attrNum" .. arg_5_0.strengthAttrSeq]

	return var_5_0[arg_5_3] * var_5_3[arg_5_3] * (var_5_4[arg_5_3] + var_5_2[arg_5_3])
end

local function var_0_6(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_2 then
		local var_6_0 = gGameModel.cards:find(arg_6_2):read("card_id", "skin_id", "advance", "level", "star")
		local var_6_1 = csv.cards[var_6_0.card_id]
		local var_6_2 = csv.unit[var_6_1.unitID]
		local var_6_3 = dataEasy.getUnitId(var_6_0.card_id, var_6_0.skin_id)

		bind.extend(arg_6_0, arg_6_1, {
			class = "card_icon",
			props = {
				levelProps = {
					data = var_6_0.level
				},
				rarity = var_6_2.rarity,
				unitId = var_6_3,
				advance = var_6_0.advance,
				star = var_6_0.star,
				onNode = function(arg_7_0)
					arg_7_0:x(-7)
				end
			}
		})
	end
end

local function var_0_7(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	bind.extend(arg_8_0, arg_8_1, {
		class = "icon_key",
		props = {
			data = {
				key = arg_8_2.csvId,
				csvId = arg_8_2.csvId,
				num = arg_8_2.selectNum,
				targetNum = arg_8_2.targetNum,
				noColor = arg_8_3
			},
			specialKey = {
				lv = arg_8_2.lv
			},
			grayState = arg_8_4 and 1 or 0,
			onNode = function(arg_9_0)
				arg_9_0:setTouchEnabled(false)
			end
		}
	})
end

local function var_0_8(arg_10_0)
	if csv.held_item.items[arg_10_0] then
		return csv.held_item.items[arg_10_0]
	else
		return csv.items[arg_10_0]
	end
end

local function var_0_9(arg_11_0)
	for iter_11_0, iter_11_1 in ipairs(gHeldItemExpCsv) do
		if iter_11_1.id == arg_11_0 then
			return true
		end
	end

	return false
end

local var_0_10 = cc.load("mvc").ViewBase
local var_0_11 = class("HeldItemAdvanceView", var_0_10)

var_0_11.RESOURCE_FILENAME = "held_item_advance.json"
var_0_11.RESOURCE_BINDING = {
	advancePanel = "advancePanel",
	["strengthenPanel.itemSubList"] = "itemSubList",
	tabItem = "tabItem",
	leftPanel = "leftPanel",
	strengthenPanel = "strengthenPanel",
	["leftPanel.attrSubList"] = "attrSubList",
	item = "item",
	["advancePanel.clickTipPanel"] = "clickTipPanel",
	attrItem = "attrItem",
	tabList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = arg_12_1:get("normal")
					local var_12_1 = arg_12_1:get("select")
					local var_12_2

					if arg_12_3.select then
						var_12_0:hide()

						var_12_2 = var_12_1:show()
					else
						var_12_1:hide()

						var_12_2 = var_12_0:show()
					end

					local var_12_3 = var_12_2:getSize().height - 40

					adapt.setAutoMultiLine(var_12_2:get("txt"), arg_12_3.name, var_12_3, 0)
					var_12_1:setTouchEnabled(false)
					bind.touch(arg_12_0, var_12_0, {
						methods = {
							ended = functools.partial(arg_12_0.clickCell, arg_12_2)
						}
					})

					if arg_12_3.redHint then
						arg_12_0.state = arg_12_3.select ~= true

						bind.extend(arg_12_0, arg_12_1, arg_12_3.redHint)
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
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
	["leftPanel.attrList"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				asyncPreload = 6,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrSubList"),
				cell = bindHelper.self("attrItem"),
				onCell = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
					local var_13_0 = arg_13_1:multiget("txtName", "txtNum", "txtNote1", "txtAdd", "icon", "txtNote2", "maxIcon", "imgIcon")

					var_13_0.imgIcon:texture(ui.ATTR_LOGO[arg_13_3.attrIconName])
					var_13_0.txtName:text(arg_13_3.attrName)
					var_13_0.txtNum:text(math.floor(arg_13_3.val))
					var_13_0.txtAdd:text("+" .. math.floor(arg_13_3.valExtra))
					adapt.oneLinePos(var_13_0.txtName, var_13_0.txtNum, cc.p(20, 0))
					adapt.oneLinePos(var_13_0.txtNum, var_13_0.txtNote1, cc.p(20, 0))
					adapt.oneLinePos(var_13_0.txtNote1, {
						var_13_0.txtAdd,
						var_13_0.icon,
						var_13_0.txtNote2
					}, cc.p(5, 0))
					adapt.oneLinePos(var_13_0.txtNum, var_13_0.maxIcon, cc.p(20, 0))
					var_13_0.maxIcon:visible(arg_13_3.isMax)
					itertools.invoke({
						var_13_0.txtNote1,
						var_13_0.txtAdd,
						var_13_0.icon,
						var_13_0.txtNote2
					}, (arg_13_3.isMax or arg_13_3.valExtra <= 0) and "hide" or "show")
				end
			}
		}
	},
	["strengthenPanel.itemList"] = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 10,
				asyncPreload = 24,
				topPadding = 10,
				columnSize = 5,
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("itemSubList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
					local var_14_0 = arg_14_0:getIdx(arg_14_2)

					var_0_7(arg_14_0, arg_14_1, arg_14_3, true)
					arg_14_1:get("mask"):hide()
					arg_14_1:get("subIcon"):visible(arg_14_3.selectNum > 0)
					arg_14_1:get("select"):visible(arg_14_3.select == true)
					arg_14_1:onTouch(functools.partial(arg_14_0.itemClick, var_14_0, arg_14_1, arg_14_3))
					bind.touch(arg_14_0, arg_14_1:get("subIcon"), {
						methods = {
							ended = functools.partial(arg_14_0.subClick, var_14_0, arg_14_3)
						}
					})
				end,
				onAfterBuild = function(arg_15_0)
					arg_15_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				itemClick = bindHelper.self("onSelectItemClick"),
				subClick = bindHelper.self("onItemReduceClick")
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
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["strengthenPanel.btnSub"] = {
		varname = "btnSub",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReduceClick")
			}
		}
	},
	["strengthenPanel.btnSub10"] = {
		varname = "btnSub10",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReduce10Click")
			}
		}
	},
	["strengthenPanel.btnSubs"] = {
		varname = "btnSubs",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReducesClick")
			}
		}
	},
	["strengthenPanel.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	["strengthenPanel.btnAdd10"] = {
		varname = "btnAdd10",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAdd10Click")
			}
		}
	},
	["strengthenPanel.btnAddl"] = {
		varname = "btnAddl",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddlClick")
			}
		}
	},
	["advancePanel.itemList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("costItemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
					var_0_7(arg_16_0, arg_16_1, arg_16_3, false, arg_16_3.selectNum < arg_16_3.targetNum)
					arg_16_1:get("mask"):visible(arg_16_3.selectNum < arg_16_3.targetNum)
					arg_16_1:get("subIcon"):hide()
					arg_16_1:get("select"):hide()
					bind.touch(arg_16_0, arg_16_1, {
						methods = {
							ended = functools.partial(arg_16_0.clickCell, arg_16_2, arg_16_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onLeftItemClick")
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
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["advancePanel.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onInfoClick")
			}
		}
	},
	["advancePanel.clickTipPanel.txt1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["advancePanel.clickTipPanel.txt2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_11.onCreate(arg_17_0, arg_17_1)
	arg_17_0.strengthenPanel:get("empty"):hide()

	local var_17_0 = arg_17_0.strengthenPanel:get("empty"):get("textNote")

	adapt.setTextAdaptWithSize(var_17_0, {
		vertical = "center",
		horizontal = "center",
		size = cc.size(520, 200)
	})

	arg_17_0.dbId = arg_17_1[1] or arg_17_1

	arg_17_0:initModel()
	gGameUI.topuiManager:createView("default", arg_17_0, {
		onClose = arg_17_0:createHandler("onClose")
	}):init({
		subTitle = "CARRY PROP",
		title = "common/txt/txt_bt_zhuangbei.png"
	})

	arg_17_0.tabDatas = {
		{
			name = gLanguageCsv.equipStrengthen,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "heldItemLevelUp",
					state = bindHelper.self("state"),
					listenData = {
						checkDress = true,
						curDbId = arg_17_0.dbId
					}
				}
			}
		},
		{
			name = gLanguageCsv.advance,
			redHint = {
				class = "red_hint",
				props = {
					specialTag = "heldItemAdvanceUp",
					state = bindHelper.self("state"),
					listenData = {
						checkDress = true,
						curDbId = arg_17_0.dbId
					}
				}
			}
		}
	}
	arg_17_0.tabDatas = idlers.newWithMap(arg_17_0.tabDatas)
	arg_17_0.showTab = idler.new(1)
	arg_17_0.totalExp = idler.new(0)
	arg_17_0.attrDatas = idlers.new()

	arg_17_0.showTab:addListener(function(arg_18_0, arg_18_1, arg_18_2)
		arg_17_0.tabDatas:atproxy(arg_18_1).select = false
		arg_17_0.tabDatas:atproxy(arg_18_0).select = true

		arg_17_0.advancePanel:visible(arg_18_0 == 2)
		arg_17_0.strengthenPanel:visible(arg_18_0 == 1)
		arg_17_0.leftPanel:get("strengthenPanel"):visible(arg_18_0 == 1)
		arg_17_0.leftPanel:get("advancePanel"):visible(arg_18_0 == 2)
	end)

	arg_17_0.itemDatas = idlers.new()
	arg_17_0.canCostItems = idlertable.new({})
	arg_17_0.selectItemNum = idler.new(1)
	arg_17_0.selectItemIdx = idler.new(1)
	arg_17_0.costItemDatas = idlers.new()

	local var_17_1

	idlereasy.any({
		arg_17_0.heldItems,
		arg_17_0.items
	}, function(arg_19_0, arg_19_1, arg_19_2)
		local var_19_0 = dataEasy.getInMeteorHelditemsHash()
		local var_19_1 = {}
		local var_19_2 = {}

		for iter_19_0, iter_19_1 in pairs(arg_19_1) do
			local var_19_3 = gGameModel.held_items:find(iter_19_1)

			if var_19_3 then
				local var_19_4 = var_19_3:read("held_item_id", "advance", "sum_exp", "card_db_id", "exist_flag")

				if not var_19_0[iter_19_1] and not var_19_2[var_19_4.held_item_id] then
					var_19_2[var_19_4.held_item_id] = {
						itemType = 2,
						num = 0
					}
				end

				if var_19_4.advance == 0 and var_19_4.sum_exp == 0 and not var_19_4.card_db_id and var_19_4.exist_flag and iter_19_1 ~= arg_17_0.dbId and not var_19_0[iter_19_1] then
					var_19_2[var_19_4.held_item_id].num = var_19_2[var_19_4.held_item_id].num + 1
				end
			end
		end

		for iter_19_2, iter_19_3 in ipairs(gHeldItemExpCsv) do
			local var_19_5 = iter_19_3.id

			if arg_19_2[var_19_5] then
				if not var_19_2[var_19_5] then
					var_19_2[var_19_5] = {
						num = 0
					}
				end

				var_19_2[var_19_5].num = arg_19_2[var_19_5]
				var_19_2[var_19_5].itemType = 1
			end
		end

		arg_17_0.canCostItems:set(var_19_2)

		local var_19_6 = {}

		for iter_19_4, iter_19_5 in pairs(var_19_2) do
			local var_19_7 = var_0_8(iter_19_4)
			local var_19_8 = false

			if iter_19_5.itemType == 2 then
				var_19_8 = csvSize(var_19_7.exclusiveCards) > 0
			end

			local var_19_9 = dataEasy.itemStackMax(iter_19_4)

			if iter_19_5.num > 0 then
				local var_19_10 = {
					cfg = var_19_7,
					heldItemExp = iter_19_5.itemType == 2 and var_19_7.heldItemExp or var_19_7.specialArgsMap.heldItemExp,
					csvId = iter_19_4
				}

				var_19_10.selectNum = 0
				var_19_10.targetNum = math.min(var_19_9, iter_19_5.num)
				var_19_10.isExc = var_19_8
				var_19_10.itemType = iter_19_5.itemType

				table.insert(var_19_6, var_19_10)
			end
		end

		table.sort(var_19_6, function(arg_20_0, arg_20_1)
			if arg_20_0.itemType ~= arg_20_1.itemType then
				return arg_20_0.itemType < arg_20_1.itemType
			end

			if arg_20_0.cfg.quality ~= arg_20_1.cfg.quality then
				return arg_20_0.cfg.quality < arg_20_1.cfg.quality
			end

			if arg_20_0.targetNum ~= arg_20_1.targetNum then
				return arg_20_0.targetNum > arg_20_1.targetNum
			end

			return arg_20_0.csvId < arg_20_1.csvId
		end)
		arg_17_0.selectItemIdx:set(0, true)
		arg_17_0.itemDatas:update(var_19_6)
		arg_17_0.selectItemNum:set(0, true)
	end)

	arg_17_0.needStrengthenGold = idler.new(0)
	arg_17_0.clientLevel = 0

	idlereasy.any({
		arg_17_0.selectItemIdx,
		arg_17_0.selectItemNum,
		arg_17_0.level
	}, function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		local var_21_0 = arg_17_0.itemDatas:atproxy(arg_21_1)

		if var_21_0 then
			if var_17_1 ~= arg_21_1 then
				var_17_1 = arg_21_1

				arg_17_0.selectItemNum:set(var_21_0.selectNum, true)
			else
				local var_21_1 = arg_21_2

				var_21_0.selectNum = arg_21_3 < arg_17_0.maxLevel and var_21_1 or 0

				arg_17_0:setStrengthenPanel(var_21_0)

				local var_21_2 = var_21_1 >= var_21_0.targetNum or arg_21_3 >= arg_17_0.maxLevel or arg_17_0.clientLevel >= arg_17_0.maxLevel
				local var_21_3 = var_21_1 <= 0 or arg_21_3 >= arg_17_0.maxLevel

				cache.setShader(arg_17_0.btnAdd, false, var_21_2 and "hsl_gray" or "normal")
				cache.setShader(arg_17_0.btnSub, false, var_21_3 and "hsl_gray" or "normal")
				cache.setShader(arg_17_0.btnAdd10, false, var_21_2 and "hsl_gray" or "normal")
				cache.setShader(arg_17_0.btnSub10, false, var_21_3 and "hsl_gray" or "normal")
				cache.setShader(arg_17_0.btnAddl, false, var_21_2 and "hsl_gray" or "normal")
				cache.setShader(arg_17_0.btnSubs, false, var_21_3 and "hsl_gray" or "normal")
				arg_17_0.btnAdd:setTouchEnabled(not var_21_2)
				arg_17_0.btnSub:setTouchEnabled(not var_21_3)
				arg_17_0.btnAdd10:setTouchEnabled(not var_21_2)
				arg_17_0.btnSub10:setTouchEnabled(not var_21_3)
				arg_17_0.btnAddl:setTouchEnabled(not var_21_2)
				arg_17_0.btnSubs:setTouchEnabled(not var_21_3)
			end
		else
			arg_17_0:setStrengthenPanel()
			uiEasy.setBtnShader(arg_17_0.btnAdd, nil, 2)
			uiEasy.setBtnShader(arg_17_0.btnSub, nil, 2)
			uiEasy.setBtnShader(arg_17_0.btnAdd10, nil, 2)
			uiEasy.setBtnShader(arg_17_0.btnSub10, nil, 2)
			uiEasy.setBtnShader(arg_17_0.btnAddl, nil, 2)
			uiEasy.setBtnShader(arg_17_0.btnSubs, nil, 2)
		end
	end)
	arg_17_0.selectItemIdx:addListener(function(arg_22_0, arg_22_1)
		local var_22_0 = arg_17_0.itemDatas:atproxy(arg_22_0)
		local var_22_1 = arg_17_0.itemDatas:atproxy(arg_22_1)

		if var_22_1 then
			var_22_1.select = false
		end

		if var_22_0 then
			var_22_0.select = true
		end
	end)
	idlereasy.any({
		arg_17_0.gold,
		arg_17_0.needStrengthenGold
	}, function(arg_23_0, arg_23_1, arg_23_2)
		var_0_2(arg_17_0.strengthenPanel:get("costPanel"), arg_23_1, arg_23_2)
	end)
	idlereasy.any({
		arg_17_0.level,
		arg_17_0.advance,
		arg_17_0.sumExp,
		arg_17_0.totalExp,
		arg_17_0.showTab
	}, function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		arg_17_0:setLeftPanel(arg_24_1, arg_24_2, arg_24_3, arg_24_4)

		local var_24_0

		var_24_0 = arg_24_1 >= arg_17_0.maxLevel and arg_24_4 <= 0
	end)
	idlereasy.any({
		arg_17_0.advance,
		arg_17_0.showTab
	}, function(arg_25_0, arg_25_1, arg_25_2)
		if arg_25_2 == 2 then
			arg_17_0:setAdvancePanel(arg_25_1)
		end
	end)
	arg_17_0.leftPanel:get("cardNote"):visible(arg_17_0.cardDbId ~= nil)
	var_0_6(arg_17_0, arg_17_0.leftPanel:get("cardIcon"), arg_17_0.cardDbId)
end

function var_0_11.initModel(arg_26_0)
	arg_26_0.heldItems = gGameModel.role:getIdler("held_items")
	arg_26_0.items = gGameModel.role:getIdler("items")
	arg_26_0.gold = gGameModel.role:getIdler("gold")

	local var_26_0 = gGameModel.held_items:find(arg_26_0.dbId):multigetIdler("held_item_id", "sum_exp", "id", "card_db_id", "advance", "level", "exist_flag")

	arg_26_0.sumExp = idler.new(0)
	arg_26_0.advance = idler.new(0)
	arg_26_0.level = idler.new(1)
	arg_26_0.existFlag = idler.new(0)

	idlereasy.any(var_26_0, function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
		arg_26_0.maxLevel = csv.held_item.items[arg_27_1].strengthMax
		arg_26_0.heldItemId = arg_27_1

		arg_26_0.sumExp:set(arg_27_2)

		arg_26_0.id = arg_27_3
		arg_26_0.cardDbId = arg_27_4

		arg_26_0.advance:set(arg_27_5)
		arg_26_0.level:set(arg_27_6)
		arg_26_0.existFlag:set(arg_27_7)
	end)
end

function var_0_11.setAdvancePanel(arg_28_0, arg_28_1)
	local var_28_0 = csv.held_item.items[arg_28_0.heldItemId]
	local var_28_1 = csv.held_item.advance[arg_28_1]
	local var_28_2 = var_28_1 and var_28_1["costItemMap" .. var_28_0.advanceSeqID] or {}
	local var_28_3 = {}

	arg_28_0.costHeldItemIDs = {}
	arg_28_0.costItemIDs = {}
	arg_28_0.advanceCostNum = 0

	for iter_28_0, iter_28_1 in csvPairs(var_28_2) do
		local var_28_4 = var_0_8(iter_28_0)

		table.insert(var_28_3, {
			selectNum = 0,
			csvId = iter_28_0,
			targetNum = iter_28_1,
			isExc = var_28_4.exclusiveCards and csvSize(var_28_4.exclusiveCards) > 0,
			itemType = var_28_4.exclusiveCards and 2 or 1
		})
	end

	arg_28_0.costItemDatas:update(var_28_3)

	local var_28_5 = arg_28_0.advancePanel:multiget("attrNote", "nextNote", "attrList", "nextList", "costNote", "textTip", "itemList", "btnAdvance", "maxIcon")

	arg_28_0.advanceMax = arg_28_1 >= var_28_0.advanceMax
	arg_28_0.levelNotEnough = false

	var_28_5.textTip:hide()

	if not arg_28_0.advanceMax then
		local var_28_6 = var_28_0.advanceLvLimit[arg_28_1 + 1]

		arg_28_0.levelNotEnough = var_28_6 > arg_28_0.level:read()

		var_28_5.textTip:visible(arg_28_0.levelNotEnough):text(string.format(gLanguageCsv.breakthroughInStrengtheningLv, var_28_6))
		var_0_4(var_28_5.nextList, arg_28_0.heldItemId, arg_28_1 + 1, true)
	end

	var_0_4(var_28_5.attrList, arg_28_0.heldItemId, arg_28_1)
	itertools.invoke({
		var_28_5.nextNote,
		var_28_5.nextList,
		var_28_5.costNote,
		var_28_5.itemList,
		var_28_5.btnAdvance
	}, arg_28_0.advanceMax and "hide" or "show")
	var_28_5.maxIcon:visible(arg_28_0.advanceMax)
	arg_28_0.clickTipPanel:visible(not arg_28_0.advanceMax)
	arg_28_0:setLeftAdvancePanel(arg_28_1)
	arg_28_0:adaptAdvancePanelList(var_28_5)
end

function var_0_11.adaptAdvancePanelList(arg_29_0, arg_29_1)
	local function var_29_0(arg_30_0, arg_30_1)
		local var_30_0 = arg_30_0:getInnerContainerSize()
		local var_30_1 = arg_30_0:size()

		if var_30_0.height >= var_30_1.height then
			var_30_0.height = var_30_0.height > var_0_0 and var_0_0 or var_30_0.height

			arg_30_0:size(var_30_0)

			arg_30_1 = arg_30_1 + var_30_0.height - var_30_1.height

			arg_30_0:y(arg_30_0:y() - arg_30_1)
		end

		return arg_30_1
	end

	local var_29_1 = 0
	local var_29_2 = var_29_1 + var_29_0(arg_29_1.attrList, var_29_1)

	arg_29_1.nextNote:y(arg_29_1.nextNote:y() - var_29_2)
	var_29_0(arg_29_1.nextList, var_29_2)
end

function var_0_11.setLeftAdvancePanel(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.leftPanel:get("advancePanel"):multiget("iconMax", "level1", "level2", "iconArrow")

	var_31_0.iconMax:visible(arg_31_0.advanceMax)
	var_31_0.level1:text("+" .. arg_31_1)
	adapt.oneLinePos(var_31_0.level1, var_31_0.iconMax, cc.p(20, 0))
	var_31_0.level2:text("+" .. arg_31_1 + 1):visible(not arg_31_0.advanceMax)
end

function var_0_11.setLeftPanel(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	local var_32_0 = arg_32_0.leftPanel:multiget("itemName", "itemIcon", "itemIconBg", "strengthenPanel", "advancePanel")
	local var_32_1 = csv.held_item.items[arg_32_0.heldItemId]
	local var_32_2 = arg_32_2 > 0 and "+" .. arg_32_2 or ""

	var_32_0.itemName:text(var_32_1.name .. var_32_2)

	local var_32_3 = var_32_1.quality

	text.addEffect(var_32_0.itemName, {
		color = var_32_3 == 1 and ui.NEWCOLORS.WHITE or ui.COLORS.QUALITY[var_32_3]
	})
	var_32_0.itemIcon:texture(var_32_1.icon)
	var_32_0.itemIconBg:texture(string.format("city/card/helditem/strengthen/img_helddt%d.png", var_32_1.quality))

	local var_32_4 = arg_32_1
	local var_32_5 = arg_32_3 + arg_32_4
	local var_32_6
	local var_32_7 = arg_32_0.maxLevel

	for iter_32_0 = 1, var_32_7 do
		var_32_6 = csv.held_item.level[iter_32_0]["levelExp" .. var_32_1.strengthSeqID]

		if var_32_7 <= iter_32_0 or var_32_5 < var_32_6 then
			var_32_4 = iter_32_0

			break
		end

		var_32_5 = var_32_5 - var_32_6
	end

	local var_32_8 = var_32_0.strengthenPanel:multiget("iconMax", "level1", "level2", "iconArrow", "bar", "percent")

	var_32_8.iconMax:visible(var_32_7 <= arg_32_1 or var_32_7 <= var_32_4)
	var_32_8.level1:text("Lv" .. arg_32_1)
	var_32_8.level2:text(var_32_4):visible(arg_32_1 < var_32_4)

	if var_32_7 <= arg_32_1 then
		adapt.oneLinePos(var_32_8.level1, var_32_8.iconMax, cc.p(20, 0))
	else
		adapt.oneLinePos(var_32_8.level2, var_32_8.iconMax, cc.p(20, 0), "left")
	end

	var_32_8.iconArrow:visible(arg_32_1 < var_32_4)
	var_32_8.bar:setPercent(var_32_5 / var_32_6 * 100)
	var_32_8.percent:text(var_32_5 .. "/" .. var_32_6)

	if arg_32_0.tmpShowTab ~= arg_32_0.showTab:read() or arg_32_0.clientLevel ~= var_32_4 or arg_32_0.tmpAdvance ~= arg_32_2 or arg_32_4 == 0 then
		arg_32_0.tmpAdvance = arg_32_2
		arg_32_0.clientLevel = var_32_4
		arg_32_0.tmpShowTab = arg_32_0.showTab:read()

		arg_32_0:setAttrDatas(arg_32_1, arg_32_2, var_32_4)
	end
end

function var_0_11.getMaxTotalExp(arg_33_0)
	local var_33_0 = csv.held_item.items[arg_33_0.heldItemId]
	local var_33_1 = 0
	local var_33_2 = arg_33_0.maxLevel

	for iter_33_0 = 1, var_33_2 do
		local var_33_3 = csv.held_item.level[iter_33_0]["levelExp" .. var_33_0.strengthSeqID]

		if var_33_2 <= iter_33_0 then
			break
		end

		var_33_1 = var_33_1 + var_33_3
	end

	return var_33_1 - arg_33_0.sumExp:read()
end

function var_0_11.setAttrDatas(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = csv.held_item.items[arg_34_0.heldItemId]
	local var_34_1 = {}
	local var_34_2 = arg_34_0.showTab:read() == 1 and arg_34_3 or arg_34_1
	local var_34_3 = math.min(arg_34_0.showTab:read() == 2 and arg_34_2 + 1 or arg_34_2, var_34_0.advanceMax)
	local var_34_4 = arg_34_0.showTab:read() == 2 and arg_34_0.advanceMax or arg_34_0.showTab:read() == 1 and arg_34_1 >= arg_34_0.maxLevel

	for iter_34_0, iter_34_1 in ipairs(var_34_0.attrTypes) do
		local var_34_5 = {}
		local var_34_6 = game.ATTRDEF_TABLE[iter_34_1]

		var_34_5.attrName = gLanguageCsv["attr" .. string.caption(var_34_6)]
		var_34_5.val = var_0_5(var_34_0, arg_34_1, arg_34_2, iter_34_0)
		var_34_5.valExtra = var_0_5(var_34_0, var_34_2, var_34_3, iter_34_0) - var_34_5.val
		var_34_5.isMax = var_34_4
		var_34_5.attrIconName = var_34_6

		table.insert(var_34_1, var_34_5)
	end

	arg_34_0.attrDatas:update(var_34_1)
end

function var_0_11.setStrengthenPanel(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.strengthenPanel:multiget("itemName", "exp", "numNote1", "num", "num1", "numNote2", "btnSub", "btnAdd", "costPanel")

	if arg_35_1 then
		var_35_0.itemName:text(arg_35_1.cfg.name)
		text.addEffect(var_35_0.itemName, {
			color = arg_35_1.cfg.quality == 1 and ui.NEWCOLORS.WHITE or ui.COLORS.QUALITY[arg_35_1.cfg.quality]
		})
	end

	var_35_0.itemName:visible(arg_35_1 ~= nil)

	local var_35_1, var_35_2 = arg_35_0:getClientTotalExp()

	arg_35_0.totalExp:set(var_35_1)
	arg_35_0.needStrengthenGold:set(var_35_1 * gCommonConfigCsv.heldItemExpNeedGold)

	local var_35_3 = 0
	local var_35_4 = "0/0"
	local var_35_5 = 0
	local var_35_6 = arg_35_0.itemDatas:atproxy(arg_35_0.selectItemIdx:read())

	if var_35_6 then
		var_35_3 = var_35_6.selectNum * var_35_6.heldItemExp
		var_35_4 = var_35_6.selectNum .. "/" .. var_35_6.targetNum
		var_35_5 = var_35_6.selectNum
	end

	var_35_0.exp:text(var_35_3)
	var_35_0.num:text(var_35_4)
	var_35_0.num1:text(var_35_5)
	adapt.oneLinePos(var_35_0.numNote2, var_35_0.num, cc.p(10, 0), "right")

	if matchLanguage({
		"cn",
		"tw"
	}) then
		adapt.oneLinePos(var_35_0.num, var_35_0.numNote1, cc.p(-10, 0), "right")
	else
		adapt.oneLinePos(var_35_0.num, var_35_0.numNote1, cc.p(5, 0), "right")
	end
end

function var_0_11.getClientTotalExp(arg_36_0, arg_36_1)
	local var_36_0 = 0
	local var_36_1 = 0

	for iter_36_0, iter_36_1 in arg_36_0.itemDatas:pairs() do
		local var_36_2 = iter_36_1:proxy()

		if var_36_2.selectNum > 0 and (not arg_36_1 or arg_36_1 ~= iter_36_0) then
			var_36_0 = var_36_0 + var_36_2.heldItemExp * var_36_2.selectNum
			var_36_1 = var_36_1 + var_36_2.selectNum
		end
	end

	return var_36_0, var_36_1, heldItemExp
end

function var_0_11.onAddClick(arg_37_0)
	arg_37_0.selectItemNum:set(arg_37_0.selectItemNum:read() + 1)
end

function var_0_11.onAdd10Click(arg_38_0)
	local var_38_0 = arg_38_0.itemDatas:atproxy(arg_38_0.selectItemIdx:read())

	if var_38_0 then
		local var_38_1 = arg_38_0.selectItemNum:read() + 10
		local var_38_2 = var_38_0.targetNum

		arg_38_0.selectItemNum:set(math.min(var_38_1, var_38_2))
	end
end

function var_0_11.onAddlClick(arg_39_0)
	local var_39_0 = arg_39_0.itemDatas:atproxy(arg_39_0.selectItemIdx:read())

	if var_39_0 then
		local var_39_1 = arg_39_0.selectItemNum:read() + 100000
		local var_39_2 = var_39_0.targetNum

		arg_39_0.selectItemNum:set(math.min(var_39_1, var_39_2))
	end
end

function var_0_11.onReduceClick(arg_40_0)
	arg_40_0.selectItemNum:set(math.max(arg_40_0.selectItemNum:read() - 1, 0))
end

function var_0_11.onReduce10Click(arg_41_0)
	arg_41_0.selectItemNum:set(math.max(arg_41_0.selectItemNum:read() - 10, 0))
end

function var_0_11.onReducesClick(arg_42_0)
	arg_42_0.selectItemNum:set(math.max(arg_42_0.selectItemNum:read() - 100000, 0))
end

function var_0_11.onItemReduceClick(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0.selectItemIdx:set(arg_43_2.k, true)
	arg_43_0.selectItemNum:set(math.max(arg_43_3.selectNum - 1, 0))
end

function var_0_11.playAction(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_2:get("_icon_.icon"):clone()

	arg_44_1:add(var_44_0, 999)

	local var_44_1, var_44_2 = arg_44_2:xy()
	local var_44_3 = arg_44_2:getParent():convertToWorldSpace(cc.p(var_44_1, var_44_2))
	local var_44_4 = arg_44_1:convertToNodeSpace(var_44_3)

	var_44_0:xy(var_44_4.x, var_44_4.y)

	local var_44_5, var_44_6 = arg_44_0.leftPanel:get("strengthenPanel.bar"):xy()
	local var_44_7 = arg_44_0.leftPanel:get("strengthenPanel"):convertToWorldSpace(cc.p(var_44_5, var_44_6))
	local var_44_8 = arg_44_1:convertToNodeSpace(var_44_7)

	transition.executeSequence(var_44_0, true):moveTo(0.4, var_44_8.x, var_44_8.y):func(function()
		var_44_0:removeFromParent()
	end):done()
end

function var_0_11.onSelectItemClick(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
	if arg_46_0.clientLevel >= arg_46_0.maxLevel or arg_46_0.level:read() >= arg_46_0.maxLevel then
		return
	end

	local var_46_0
	local var_46_1 = false
	local var_46_2 = false
	local var_46_3 = 0
	local var_46_4 = arg_46_0.selectItemNum:read()

	if arg_46_5.name == "began" then
		arg_46_0.isLongTouch = false
		var_46_2 = false
		var_46_4 = arg_46_4.selectNum
		var_46_0 = arg_46_3:getTouchBeganPosition()

		arg_46_0:enableSchedule():schedule(function(arg_47_0)
			var_46_3 = var_46_3 + arg_47_0

			if var_46_3 > 0.5 then
				local var_47_0 = arg_46_0.itemDatas:atproxy(arg_46_2.k).targetNum

				if arg_46_0.clientLevel >= arg_46_0.maxLevel or arg_46_0.level:read() >= arg_46_0.maxLevel or var_47_0 <= var_46_4 then
					var_46_4 = 0

					return false
				end

				arg_46_0.isLongTouch = true

				local var_47_1 = arg_46_0.selectItemIdx:read()

				if var_47_1 ~= arg_46_2.k and arg_46_4.cfg.quality >= 4 and arg_46_4.selectNum == 0 and not var_46_2 then
					if not var_0_9(arg_46_4.csvId) then
						var_46_2 = true

						gGameUI:showDialog({
							btnType = 2,
							content = gLanguageCsv.advancedQualityCarryingProps,
							btnStr = gLanguageCsv.tips,
							cb = function()
								arg_46_0.selectItemIdx:set(arg_46_2.k, true)
							end
						})
					else
						arg_46_0.selectItemIdx:set(arg_46_2.k, true)
					end
				elseif var_47_1 ~= arg_46_2.k and (arg_46_4.cfg.quality < 4 or arg_46_4.selectNum > 0) then
					arg_46_0.selectItemIdx:set(arg_46_2.k, true)
				elseif var_47_1 == arg_46_2.k then
					var_46_4 = var_46_4 + 1

					arg_46_0.selectItemNum:set(var_46_4)
					arg_46_0:playAction(arg_46_0.strengthenPanel, arg_46_3)
				end
			end
		end, 0.1, 0, "efcschedule")
	elseif arg_46_5.name == "moved" then
		var_46_0 = var_46_0 or arg_46_3:getTouchBeganPosition()

		local var_46_5 = math.abs(arg_46_5.x - var_46_0.x)
		local var_46_6 = math.abs(arg_46_5.y - var_46_0.y)

		if var_46_5 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD or var_46_6 >= ui.TOUCH_MOVE_CANCAE_THRESHOLD then
			arg_46_0.isLongTouch = true

			arg_46_0:unSchedule("efcschedule")
		end
	elseif arg_46_5.name == "ended" or arg_46_5.name == "cancelled" then
		arg_46_0:unSchedule("efcschedule")

		if not arg_46_0.isLongTouch then
			local var_46_7 = arg_46_0.selectItemIdx:read()
			local var_46_8 = arg_46_0.itemDatas:atproxy(arg_46_2.k).targetNum
			local var_46_9 = arg_46_0.selectItemNum:read()

			if var_46_7 ~= arg_46_2.k then
				if arg_46_4.cfg.quality >= 4 and arg_46_4.selectNum == 0 and not var_0_9(arg_46_4.csvId) then
					gGameUI:showDialog({
						btnType = 2,
						content = gLanguageCsv.advancedQualityCarryingProps,
						btnStr = gLanguageCsv.tips,
						cb = function()
							arg_46_0.selectItemIdx:set(arg_46_2.k, true)
						end
					})
				else
					arg_46_0.selectItemIdx:set(arg_46_2.k, true)
				end
			elseif var_46_7 == arg_46_2.k and var_46_9 < var_46_8 then
				arg_46_0.selectItemNum:set(var_46_9 + 1)
				arg_46_0:playAction(arg_46_0.strengthenPanel, arg_46_3)
			end
		end
	end
end

function var_0_11.onStrengthenClick(arg_50_0)
	if dataEasy.getNumByKey("gold") < arg_50_0.needStrengthenGold:read() then
		gGameUI:showTip(gLanguageCsv.goldNotEnough)

		return
	end

	local var_50_0 = {}

	for iter_50_0, iter_50_1 in arg_50_0.itemDatas:pairs() do
		local var_50_1 = iter_50_1:proxy()

		if var_50_1.selectNum > 0 then
			if not var_50_0[var_50_1.csvId] then
				var_50_0[var_50_1.csvId] = 0
			end

			var_50_0[var_50_1.csvId] = var_50_0[var_50_1.csvId] + var_50_1.selectNum
		end
	end

	if next(var_50_0) == nil then
		gGameUI:showTip(gLanguageCsv.pleaseSelectMaterials)

		return
	end

	arg_50_0.oldLevel = arg_50_0.level:read()
	arg_50_0.oldFight = nil

	if arg_50_0.cardDbId ~= nil then
		arg_50_0.oldFight = gGameModel.cards:find(arg_50_0.cardDbId):read("fighting_point")
	end

	arg_50_0.showOver = {
		false
	}

	gGameApp:requestServerCustom("/game/helditem/strength"):params(var_50_0, arg_50_0.dbId):onResponse(function(arg_51_0)
		var_0_3(arg_50_0.leftPanel:get("itemIcon"), "strength", function()
			arg_50_0.showOver[1] = true
		end)
	end):wait(arg_50_0.showOver):doit(function(arg_53_0)
		if arg_50_0.oldLevel < arg_50_0.level:read() then
			gGameUI:stackUI("city.card.helditem.common_success", nil, {
				blackLayer = true
			}, {
				typ = "level",
				dbId = arg_50_0.dbId,
				level = arg_50_0.oldLevel,
				advance = arg_50_0.advance:read(),
				fight = arg_50_0.oldFight,
				cardDbId = arg_50_0.cardDbId
			})
		end
	end)
end

function var_0_11.onAdvanceClick(arg_54_0)
	if arg_54_0.levelNotEnough then
		gGameUI:showTip(gLanguageCsv.currentLevelNotAvailable)

		return
	end

	local var_54_0 = 0

	for iter_54_0, iter_54_1 in pairs(arg_54_0.costItemIDs) do
		var_54_0 = var_54_0 + iter_54_1
	end

	local var_54_1 = itertools.size(arg_54_0.costHeldItemIDs) + var_54_0

	if arg_54_0.advanceCostNum == 0 or var_54_1 < arg_54_0.advanceCostNum then
		gGameUI:showTip(gLanguageCsv.inadequateProps)

		return
	end

	arg_54_0.oldAdvance = arg_54_0.advance:read()
	arg_54_0.oldFight = nil

	if arg_54_0.cardDbId ~= nil then
		arg_54_0.oldFight = gGameModel.cards:find(arg_54_0.cardDbId):read("fighting_point")
	end

	local var_54_2
	local var_54_3

	if itertools.size(arg_54_0.costHeldItemIDs) > 0 then
		var_54_2 = arg_54_0.costHeldItemIDs
	end

	if itertools.size(arg_54_0.costItemIDs) > 0 then
		var_54_3 = arg_54_0.costItemIDs
	end

	arg_54_0.showOver = {
		false
	}

	gGameApp:requestServerCustom("/game/helditem/advance"):params(arg_54_0.dbId, var_54_2, var_54_3):onResponse(function(arg_55_0)
		var_0_3(arg_54_0.leftPanel:get("itemIcon"), "advance", function()
			arg_54_0.showOver[1] = true
		end)
	end):wait(arg_54_0.showOver):doit(function(arg_57_0)
		gGameUI:stackUI("city.card.helditem.common_success", nil, {
			blackLayer = true
		}, {
			typ = "advance",
			dbId = arg_54_0.dbId,
			level = arg_54_0.level:read(),
			advance = arg_54_0.oldAdvance,
			fight = arg_54_0.oldFight,
			cardDbId = arg_54_0.cardDbId
		})
	end)
end

function var_0_11.onTabItemClick(arg_58_0, arg_58_1, arg_58_2)
	arg_58_0.showTab:set(arg_58_2)
end

function var_0_11.onClose(arg_59_0)
	arg_59_0.refreshData(arg_59_0.dbId)
	var_0_10.onClose(arg_59_0)
end

function var_0_11.onInfoClick(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = {
		cfg = csv.held_item.items[arg_60_0.heldItemId],
		csvId = arg_60_0.heldItemId,
		advance = arg_60_0.advance:read()
	}
	local var_60_1, var_60_2 = arg_60_1:getPosition()
	local var_60_3 = arg_60_1:getParent():convertToWorldSpace(cc.p(var_60_1, var_60_2))
	local var_60_4 = {
		offy = 10,
		offx = 256,
		data = var_60_0,
		target = arg_60_1,
		x = var_60_3.x,
		y = var_60_3.y
	}

	gGameUI:stackUI("city.card.helditem.advance_detail", nil, nil, var_60_4)
end

function var_0_11.onAfterBuild(arg_61_0)
	arg_61_0.strengthenPanel:get("empty"):visible(arg_61_0.itemDatas:size() == 0)
end

function var_0_11.onLeftItemClick(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	if arg_62_3.csvId <= game.HELD_ITEM_CSVID_LIMIT and arg_62_3.csvId > game.FRAGMENT_CSVID_LIMIT then
		arg_62_0.advanceCostNum = arg_62_3.targetNum

		gGameUI:stackUI("city.card.helditem.advance_select", nil, nil, arg_62_0.dbId, arg_62_3.csvId, arg_62_3.targetNum, arg_62_0:createHandler("setCostItem"))
	end
end

function var_0_11.setCostItem(arg_63_0, arg_63_1, arg_63_2)
	arg_63_0.costHeldItemIDs = arg_63_1
	arg_63_0.costItemIDs = arg_63_2

	local var_63_0 = 0

	for iter_63_0, iter_63_1 in pairs(arg_63_2) do
		var_63_0 = var_63_0 + iter_63_1
	end

	local var_63_1 = itertools.size(arg_63_1) + var_63_0

	arg_63_0.costItemDatas:atproxy(1).selectNum = var_63_1
end

return var_0_11
