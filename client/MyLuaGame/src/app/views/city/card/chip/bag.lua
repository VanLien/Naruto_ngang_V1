local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ChipBagView", var_0_0)
local var_0_2 = require("app.views.city.card.chip.tools")
local var_0_3 = {
	"hp",
	"speed",
	"mp1Recover",
	"damage",
	"defence",
	"defenceIgnore",
	"strike",
	"strikeDamage",
	"strikeResistance",
	"cure",
	"rebound",
	"suckBlood",
	"block",
	"breakBlock",
	"blockPower",
	"controlPer",
	"immuneControl",
	"damageAdd",
	"damageSub",
	"ultimateAdd",
	"ultimateSub"
}

var_0_1.ATTR_FILTER_TYPE = var_0_3
var_0_1.RESOURCE_FILENAME = "chip_bag.json"
var_0_1.RESOURCE_BINDING = {
	["suitFilterPanel.panel.subList"] = "suitFilterSubList",
	["right.suitAttrPanel.tip"] = "suitAttrTip",
	["left.item"] = "bagItem",
	["right.baseAttrPanel.item"] = "baseAttrItem",
	["left.posItem"] = "posItem",
	["right.suitAttrPanel.item"] = "suitAttrItem",
	["right.baseAttrPanel.tip"] = "baseAttrTip",
	suitFilterPanel = "suitFilterPanel",
	["suitFilterPanel.panel.item"] = "suitFilterItem",
	["left.empty"] = "empty",
	attrFilterPanel = "attrFilterPanel",
	bg = "bg",
	["left.subList"] = "bagSubList",
	["attrFilterPanel.panel.subList"] = "attrFilterSubList",
	right = "right",
	suitAttrDetailPanel = "suitAttrDetailPanel",
	left = "left",
	["right.baseAttrPanel.subList"] = "baseAttrSubList",
	["attrFilterPanel.panel.item"] = "attrFilterItem",
	["left.btnSuitEffect"] = {
		varname = "btnSuitEffect",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSuitEffectClick")
			}
		}
	},
	["left.btnSuitEffect.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["left.btnSuitFilter.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["left.btnAttrFilter.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["left.btnSuitFilter"] = {
		varname = "btnSuitFilter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSuitFilterClick")
			}
		}
	},
	["left.btnAttrFilter"] = {
		varname = "btnAttrFilter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAttrFilterClick")
			}
		}
	},
	["left.posList"] = {
		varname = "posList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("posData"),
				item = bindHelper.self("posItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("bg"):texture(arg_1_3.select and "city/card/gem/btn_yq_h.png" or "city/card/gem/btn_yq_b.png")

					if not arg_1_3.pos then
						text.addEffect(arg_1_1:get("txt"), {
							color = arg_1_3.select and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED,
							outline = {
								size = 2,
								color = arg_1_3.select and ui.NEWCOLORS.OUTLINE.BLACK or ui.NEWCOLORS.OUTLINE.WHITE1
							}
						})
						arg_1_1:get("txt"):show()
						arg_1_1:get("icon"):hide()
					else
						arg_1_1:get("txt"):hide()
						arg_1_1:get("icon"):show():texture(arg_1_3.select and "city/card/chip/icon_fx_2.png" or "city/card/chip/icon_fx_1.png"):rotate(60 * (arg_1_3.pos - 1))
					end

					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onPosClick")
			}
		}
	},
	["left.list"] = {
		varname = "bagList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = bindHelper.self("asyncPreload"),
				columnSize = bindHelper.self("midColumnSize"),
				data = bindHelper.self("bagData"),
				item = bindHelper.self("bagSubList"),
				cell = bindHelper.self("bagItem"),
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.cfg.quality ~= arg_2_1.cfg.quality then
						return arg_2_0.cfg.quality > arg_2_1.cfg.quality
					end

					if arg_2_0.cfg.suitID ~= arg_2_1.cfg.suitID then
						return arg_2_0.cfg.suitID < arg_2_1.cfg.suitID
					end

					if arg_2_0.cfg.pos ~= arg_2_1.cfg.pos then
						return arg_2_0.cfg.pos < arg_2_1.cfg.pos
					end

					if arg_2_0.level ~= arg_2_1.level then
						return arg_2_0.level > arg_2_1.level
					end

					return arg_2_0.idx < arg_2_1.idx
				end,
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_3_3.chipId,
								dbId = arg_3_3.dbId
							},
							specialKey = {
								leftTopLv = arg_3_3.level,
								locked = arg_3_3.locked,
								unitId = arg_3_3.equipShow and arg_3_3.unitId or nil
							},
							grayState = arg_3_3.grayState or 0,
							onNode = function(arg_4_0)
								local var_4_0 = arg_3_0:getIdx(arg_3_2)
								local var_4_1 = arg_3_0.selectItem()
								local var_4_2 = arg_3_0.selectEffect()

								idlereasy.when(var_4_1, function(arg_5_0, arg_5_1)
									if arg_5_1.dbId == nil and var_4_2:parent() then
										var_4_2:removeSelf()
									end

									if arg_5_1.dbId == arg_3_3.dbId then
										var_4_2:removeSelf()
										var_4_2:alignCenter(arg_4_0:size())
										arg_4_0:add(var_4_2, -1)
									end
								end):anonyOnly(arg_3_0, arg_3_3.dbId)
								arg_4_0:scale(1.15)
								arg_4_0:onTouch(functools.partial(arg_3_0.itemTouch, arg_4_0, var_4_0, arg_3_3))
							end
						}
					})
				end
			},
			handlers = {
				itemTouch = bindHelper.self("onItemTouch"),
				selectEffect = bindHelper.self("selectEffect"),
				selectItem = bindHelper.self("selectItem")
			}
		}
	},
	["right.chipPanel"] = {
		varname = "chipPanel",
		binds = {
			event = "extend",
			class = "chips_panel",
			props = {
				showSuitEffect = true,
				data = bindHelper.self("selectCardDBID"),
				slotFlags = bindHelper.self("slotFlags"),
				selected = bindHelper.self("selectRightPos")
			}
		}
	},
	["right.chipPanel.card"] = {
		varname = "cardPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowSelectSpriteView")
			}
		}
	},
	["right.btnDraw"] = {
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
					onNode = function(arg_6_0)
						arg_6_0:xy(200, 200)
					end
				}
			}
		}
	},
	["right.btnDraw.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.btnOnekeyDown"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOnekeyDownClick")
			}
		}
	},
	["right.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["right.btnOnekeyDown.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.btnPlan"] = {
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
	["right.btnPlan.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.btnPlanCompare"] = {
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
	["right.btnPlanCompare.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["right.baseAttrPanel.btnDetail"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBaseAttrDetailClick")
			}
		}
	},
	["right.suitAttrPanel.btnDetail"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSuitAttrDetailClick")
			}
		}
	},
	["right.baseAttrPanel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("baseAttrData"),
				item = bindHelper.self("baseAttrSubList"),
				cell = bindHelper.self("baseAttrItem"),
				onCell = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:get("icon"):texture(ui.ATTR_LOGO[arg_7_3.attr])
					arg_7_1:get("text"):text(getLanguageAttr(arg_7_3.key) .. " +" .. arg_7_3.val)
				end
			}
		}
	},
	["right.suitAttrPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("suitAttrData"),
				item = bindHelper.self("suitAttrItem"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_1:get("icon"):texture(var_0_2.getSuitRes(arg_8_3.suitId, arg_8_3.data))
					bind.touch(arg_8_0, arg_8_1, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_1, arg_8_2, arg_8_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSuitAttrItemClick")
			}
		}
	},
	["suitFilterPanel.panel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("suitFilterData"),
				item = bindHelper.self("suitFilterSubList"),
				cell = bindHelper.self("suitFilterItem"),
				onCell = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					arg_9_1:get("selected"):visible(arg_9_3.selected == true)
					arg_9_1:get("icon"):texture(arg_9_3.cfg.suitIcon)
					arg_9_1:get("name"):text(arg_9_3.cfg.suitName)
					arg_9_1:get("count"):text(arg_9_3.count):setFontSize(36)
					text.addEffect(arg_9_1:get("count"), {
						color = ui.COLORS.NORMAL.WHITE,
						outline = {
							size = 3,
							color = ui.COLORS.OUTLINE.DEFAULT
						}
					})
					bind.touch(arg_9_0, arg_9_1, {
						methods = {
							ended = functools.partial(arg_9_0.itemClick, arg_9_1, arg_9_2, arg_9_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onSuitFilterItemClick")
			}
		}
	},
	["suitFilterPanel.panel.btnAll"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSuitFilterAllClick")
			}
		}
	},
	["suitFilterPanel.panel.btnAll.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["attrFilterPanel.panel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				data = bindHelper.self("attrFilterData"),
				item = bindHelper.self("attrFilterSubList"),
				cell = bindHelper.self("attrFilterItem"),
				onCell = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					adapt.setTextScaleWithWidth(arg_10_1:get("name"), arg_10_3.name, 240)

					if arg_10_3.selected then
						arg_10_1:get("icon"):texture("city/card/chip/btn_r.png")
						text.addEffect(arg_10_1:get("name"), {
							color = ui.NEWCOLORS.ORANGE
						})
					else
						arg_10_1:get("icon"):texture("city/card/chip/btn_w.png")
						text.addEffect(arg_10_1:get("name"), {
							color = ui.NEWCOLORS.BROWN2
						})
					end

					bind.touch(arg_10_0, arg_10_1, {
						methods = {
							ended = functools.partial(arg_10_0.itemClick, arg_10_1, arg_10_0:getIdx(arg_10_2), arg_10_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onAttrFilterItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_11_0, arg_11_1)
	arg_11_1 = arg_11_1 or {}
	arg_11_0.cb = arg_11_1.cb
	arg_11_0.topuiView = gGameUI.topuiManager:createView("default", arg_11_0, {
		onClose = arg_11_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_miji.png"
	})

	arg_11_0:initModel()

	arg_11_0.chipPlanListen = dataEasy.getListenUnlock(gUnlockCsv.chipPlan)
	arg_11_0.chipPlanCompareListen = dataEasy.getListenUnlock(gUnlockCsv.chipPlanCompare)

	adapt.dockWithScreen(arg_11_0.left, "left")
	adapt.dockWithScreen(arg_11_0.suitFilterPanel:get("panel"), "left")
	adapt.dockWithScreen(arg_11_0.attrFilterPanel:get("panel"), "left")
	adapt.dockWithScreen(arg_11_0.right, "right")

	local var_11_0, var_11_1 = adapt.centerWithScreen("left", "right", {
		itemWidth = arg_11_0.bagItem:width(),
		itemWidthExtra = arg_11_1.itemWidthExtra or 80
	}, {
		{
			{
				arg_11_0.bagSubList,
				arg_11_0.bagList
			},
			"width"
		},
		{
			{
				arg_11_0.btnSuitFilter,
				arg_11_0.suitFilterPanel:get("panel"),
				arg_11_0.btnAttrFilter,
				arg_11_0.attrFilterPanel:get("panel")
			},
			"pos",
			function(arg_12_0, arg_12_1)
				return arg_12_1 - arg_12_0
			end
		}
	})

	arg_11_0.midColumnSize = 4 + (var_11_1 or 0)
	arg_11_0.asyncPreload = arg_11_0.midColumnSize * 5

	local var_11_2 = cc.p(arg_11_0.left:xy())

	arg_11_0.left:x(var_11_2.x - arg_11_0.left:width() - 100)
	arg_11_0.left:runAction(cc.MoveTo:create(0.4, var_11_2))

	local var_11_3 = cc.p(arg_11_0.right:xy())

	arg_11_0.originRightPos = var_11_3

	arg_11_0.right:x(var_11_3.x + arg_11_0.right:width() + 100)
	arg_11_0.right:runAction(cc.MoveTo:create(0.4, var_11_3))
	arg_11_0.posList:setItemsMargin(35)

	arg_11_0.selectEffect = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(arg_11_0.bagItem:size()):retain()
	arg_11_0.selectCardDBID = idler.new(arg_11_1.curCardDBID)
	arg_11_0.selectLeftPos = idler.new()
	arg_11_0.selectRightPos = idler.new()
	arg_11_0.selectItem = idlereasy.new({})
	arg_11_0.bagData = idlers.newWithMap({})
	arg_11_0.posData = idlers.newWithMap({
		{
			select = true
		},
		{
			pos = 1
		},
		{
			pos = 2
		},
		{
			pos = 3
		},
		{
			pos = 4
		},
		{
			pos = 5
		},
		{
			pos = 6
		}
	})
	arg_11_0.suitFilterData = idlers.newWithMap({})
	arg_11_0.attrFilterData = idlers.newWithMap({})
	arg_11_0.baseAttrData = idlereasy.new({})
	arg_11_0.suitAttrData = idlereasy.new({})

	idlereasy.when(arg_11_0.cards, function(arg_13_0, arg_13_1)
		local var_13_0 = arg_11_0.selectCardDBID:read()

		if not gGameModel.cards:find(var_13_0) then
			local var_13_1 = gGameModel.role:read("battle_cards")
			local var_13_2 = {}

			for iter_13_0, iter_13_1 in pairs(var_13_1) do
				local var_13_3 = gGameModel.cards:find(iter_13_1)
				local var_13_4 = var_13_3:read("chip")
				local var_13_5 = 0

				for iter_13_2 = 1, 6 do
					if var_13_4[iter_13_2] then
						var_13_5 = var_13_5 + 1
					end
				end

				table.insert(var_13_2, {
					dbId = iter_13_1,
					fight = var_13_3:read("fighting_point"),
					chipNum = var_13_5
				})
				table.sort(var_13_2, function(arg_14_0, arg_14_1)
					if arg_14_0.chipNum ~= arg_14_1.chipNum then
						return arg_14_0.chipNum > arg_14_1.chipNum
					end

					return arg_14_0.fight > arg_14_1.fight
				end)

				var_13_0 = var_13_2[1].dbId
			end
		end

		arg_11_0:setCardDBID(var_13_0)
	end)
	idlereasy.when(arg_11_0.selectCardDBID, function(arg_15_0, arg_15_1)
		local var_15_0 = gGameModel.cards:find(arg_15_1)

		arg_11_0.cardChips = idlereasy.assign(var_15_0:getIdler("chip"), arg_11_0.cardChips)

		arg_11_0:showPanel()
	end)

	arg_11_0.cardChipsIdler_ = {}

	idlereasy.when(arg_11_0.cardChips, function(arg_16_0, arg_16_1)
		for iter_16_0, iter_16_1 in pairs(arg_11_0.cardChipsIdler_) do
			iter_16_1:destroy()
		end

		arg_11_0.cardChipsIdler_ = {}

		for iter_16_2 = 1, 6 do
			local var_16_0 = arg_16_1[iter_16_2]

			if var_16_0 then
				local var_16_1 = gGameModel.chips:find(var_16_0):multigetIdler("level", "now")

				arg_11_0.cardChipsIdler_[var_16_0] = idlereasy.any(var_16_1, function()
					arg_11_0:showPanel()
				end, true):anonyOnly(arg_11_0, stringz.bintohex(var_16_0))
			end
		end

		arg_11_0:showPanel()
	end)
	arg_11_0.selectLeftPos:addListener(function(arg_18_0, arg_18_1)
		arg_11_0.bagList:jumpToTop()
		arg_11_0.selectItem:set({})

		local var_18_0 = arg_18_1 and arg_18_1 + 1 or 1

		arg_11_0.posData:atproxy(var_18_0).select = false

		local var_18_1 = arg_18_0 and arg_18_0 + 1 or 1

		arg_11_0.posData:atproxy(var_18_1).select = true
	end)
	arg_11_0.suitAttrDetailPanel:hide()
	bind.click(arg_11_0, arg_11_0.suitAttrDetailPanel, {
		method = function()
			arg_11_0.suitAttrDetailPanel:hide()
		end
	})
	arg_11_0.suitFilterPanel:hide()
	bind.click(arg_11_0, arg_11_0.suitFilterPanel, {
		method = function()
			arg_11_0.suitFilterPanel:hide()
			arg_11_0.btnSuitFilter:get("arrow"):setFlippedY(false)
		end
	})

	arg_11_0.selectSuitId = idler.new()

	idlereasy.when(arg_11_0.selectSuitId, function(arg_21_0, arg_21_1)
		arg_11_0.bagList:jumpToTop()
		arg_11_0.suitFilterPanel:hide()
		arg_11_0.btnSuitFilter:get("arrow"):setFlippedY(false)
		arg_11_0.btnSuitFilter:get("txt"):text(arg_21_1 and gChipSuitCsv[arg_21_1][2][2].suitName or gLanguageCsv.chipBagSuitFilter)
	end)
	arg_11_0.attrFilterPanel:hide()

	arg_11_0.selectAttrIds = idlereasy.new({})

	bind.click(arg_11_0, arg_11_0.attrFilterPanel, {
		method = function()
			arg_11_0.attrFilterPanel:hide()
			arg_11_0.btnAttrFilter:get("arrow"):setFlippedY(false)

			local var_22_0 = {}

			for iter_22_0, iter_22_1 in arg_11_0.attrFilterData:ipairs() do
				if iter_22_0 ~= 1 and iter_22_1:proxy().selected then
					var_22_0[iter_22_1:proxy().id] = true
				end
			end

			arg_11_0.selectAttrIds:set(var_22_0)
		end
	})
	idlereasy.when(arg_11_0.selectAttrIds, function(arg_23_0, arg_23_1)
		arg_11_0.bagList:jumpToTop()
		arg_11_0.attrFilterPanel:hide()
		arg_11_0.btnAttrFilter:get("arrow"):setFlippedY(false)

		local var_23_0 = gLanguageCsv.chipBagAttrFilter

		if itertools.size(arg_23_1) == 1 then
			local var_23_1 = next(arg_23_1)

			var_23_0 = var_0_2.getAttrName(var_23_1)
		elseif itertools.size(arg_23_1) > 1 then
			var_23_0 = gLanguageCsv.chipBagAttrFilterMulti
		end

		adapt.setTextScaleWithWidth(arg_11_0.btnAttrFilter:get("txt"), var_23_0, 200)
	end)

	local var_11_4 = 0

	arg_11_0.isRefreshBagPanel = idler.new(true)

	idlereasy.any({
		arg_11_0.roleChips,
		arg_11_0.cardChips,
		arg_11_0.selectLeftPos,
		arg_11_0.selectSuitId,
		arg_11_0.selectAttrIds,
		arg_11_0.isRefreshBagPanel
	}, function()
		var_11_4 = var_11_4 + 1

		performWithDelay(arg_11_0, function()
			if var_11_4 > 0 then
				var_11_4 = 0

				arg_11_0:refreshLeftPanel()
			end
		end, 0)
	end)
end

function var_0_1.initModel(arg_26_0)
	arg_26_0.cards = gGameModel.role:getIdler("cards")
	arg_26_0.roleChips = gGameModel.role:getIdler("chips")
	arg_26_0.slotFlags = idlereasy.new({})
end

function var_0_1.onCleanup(arg_27_0)
	arg_27_0.selectEffect:release()
	var_0_0.onCleanup(arg_27_0)
end

function var_0_1.onClose(arg_28_0)
	if arg_28_0.cb then
		arg_28_0:addCallbackOnExit(functools.partial(arg_28_0.cb, arg_28_0.selectCardDBID:read()))
	end

	var_0_0.onClose(arg_28_0)
end

function var_0_1.setCardDBID(arg_29_0, arg_29_1)
	if not arg_29_1 then
		return
	end

	local var_29_0 = gGameModel.cards:find(arg_29_1):read("card_id", "skin_id", "level", "star", "advance")
	local var_29_1 = csv.cards[var_29_0.card_id]
	local var_29_2 = csv.unit[var_29_1.unitID]
	local var_29_3 = dataEasy.getUnitId(var_29_0.card_id, var_29_0.skin_id)

	bind.extend(arg_29_0, arg_29_0.cardPanel, {
		class = "card_icon",
		props = {
			unitId = var_29_3,
			advance = var_29_0.advance,
			rarity = var_29_2.rarity,
			star = var_29_0.star,
			levelProps = {
				data = var_29_0.level
			},
			onNode = function(arg_30_0)
				arg_30_0:alignCenter(arg_29_0.cardPanel:size()):scale(1.3)
			end
		}
	})
	arg_29_0.selectCardDBID:set(arg_29_1)
	performWithDelay(arg_29_0, function()
		idlereasy.when(arg_29_0.cardChips, function(arg_32_0, arg_32_1)
			for iter_32_0 = 1, 6 do
				local var_32_0 = arg_29_0.chipPanel:getItem(iter_32_0)

				var_32_0:setTouchEnabled(true)

				local var_32_1 = arg_32_1[iter_32_0]

				if var_32_1 then
					local var_32_2 = gGameModel.chips:find(var_32_1):read("chip_id", "card_db_id", "level")
					local var_32_3 = {
						dbId = var_32_1,
						chipId = var_32_2.chip_id,
						level = var_32_2.level,
						cfg = csv.chip.chips[var_32_2.chip_id]
					}

					var_32_0:onTouch(functools.partial(arg_29_0.onCardChipClick, arg_29_0, var_32_0, iter_32_0, var_32_3))
				else
					var_32_0:onTouch(function(arg_33_0)
						if arg_33_0.name == "ended" then
							arg_29_0.selectLeftPos:set(iter_32_0)
							arg_29_0.selectRightPos:set(iter_32_0)
						end
					end)
				end
			end
		end):anonyOnly(arg_29_0)
	end, 0)
end

function var_0_1.onSuitEffectClick(arg_34_0)
	gGameUI:stackUI("city.card.chip.suit_preview")
end

function var_0_1.onSuitFilterClick(arg_35_0, arg_35_1)
	arg_35_0.btnSuitFilter:get("arrow"):setFlippedY(true)

	local var_35_0 = {}
	local var_35_1 = {}
	local var_35_2 = arg_35_0.roleChips:read()

	for iter_35_0, iter_35_1 in ipairs(var_35_2) do
		local var_35_3 = gGameModel.chips:find(iter_35_1):read("chip_id", "card_db_id")

		if arg_35_1 == true or not var_35_3.card_db_id then
			local var_35_4 = csv.chip.chips[var_35_3.chip_id]

			var_35_1[var_35_4.suitID] = var_35_1[var_35_4.suitID] or 0
			var_35_1[var_35_4.suitID] = var_35_1[var_35_4.suitID] + 1
		end
	end

	for iter_35_2, iter_35_3 in pairs(gChipSuitCsv) do
		table.insert(var_35_0, {
			suitId = iter_35_2,
			count = var_35_1[iter_35_2] or 0,
			selected = arg_35_0.selectSuitId:read() == iter_35_2,
			cfg = gChipSuitCsv[iter_35_2][2][2]
		})
	end

	table.sort(var_35_0, function(arg_36_0, arg_36_1)
		return arg_36_0.suitId < arg_36_1.suitId
	end)
	arg_35_0.suitFilterData:update(var_35_0)
	arg_35_0.suitFilterPanel:show()
end

function var_0_1.onAttrFilterClick(arg_37_0)
	arg_37_0.btnAttrFilter:get("arrow"):setFlippedY(true)

	local var_37_0 = arg_37_0.selectAttrIds:read()
	local var_37_1 = {
		{
			name = gLanguageCsv.default,
			selected = itertools.size(var_37_0) == 0
		}
	}

	for iter_37_0, iter_37_1 in ipairs(var_0_3) do
		local var_37_2 = game.ATTRDEF_ENUM_TABLE[iter_37_1]

		table.insert(var_37_1, {
			id = var_37_2,
			name = var_0_2.getAttrName(var_37_2),
			selected = var_37_0[var_37_2] or false
		})
	end

	arg_37_0.attrFilterData:update(var_37_1)
	arg_37_0.attrFilterPanel:show()
end

function var_0_1.onShowSelectSpriteView(arg_38_0)
	gGameUI:stackUI("city.card.chip.select_sprite", nil, nil, arg_38_0.selectCardDBID:read(), arg_38_0:createHandler("setCardDBID"))
end

function var_0_1.showDetails(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	local var_39_0 = arg_39_2:convertToWorldSpaceAR(cc.p(0, 0))
	local var_39_1 = "right"

	if arg_39_3 and arg_39_3 >= 1 and arg_39_3 <= 3 then
		var_39_1 = "left"
	end

	gGameUI:stackUI("city.card.chip.details", nil, {
		clickClose = true,
		dispatchNodes = {
			arg_39_0.bagList,
			arg_39_0.chipPanel
		}
	}, {
		dbId = arg_39_4,
		cardDBID = arg_39_5,
		plan = arg_39_6,
		pos = var_39_0,
		align = var_39_1,
		dataRefresh = function()
			arg_39_0.isRefreshBagPanel:notify()
		end,
		cb = arg_39_0:createHandler("resetSelected")
	})
end

function var_0_1.resetSelected(arg_41_0)
	arg_41_0.selectItem:set({})

	if not arg_41_0.selectLeftPos:read() then
		arg_41_0.selectRightPos:set()
	end
end

function var_0_1.onPosClick(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	arg_42_0.selectLeftPos:set(arg_42_3.pos)
	arg_42_0.selectRightPos:set(arg_42_3.pos)
end

function var_0_1.refreshLeftPanel(arg_43_0)
	local var_43_0 = arg_43_0.roleChips:read()
	local var_43_1 = arg_43_0.selectLeftPos:read()
	local var_43_2 = arg_43_0.selectSuitId:read()
	local var_43_3 = arg_43_0.selectAttrIds:read()
	local var_43_4 = {}
	local var_43_5 = {}

	local function var_43_6(arg_44_0, arg_44_1)
		if var_43_1 and var_43_1 ~= arg_44_0.pos then
			return false
		end

		if var_43_2 and var_43_2 ~= arg_44_0.suitID then
			return false
		end

		if itertools.size(var_43_3) > 0 then
			local var_44_0, var_44_1 = var_0_2.getAttrs({
				arg_44_1
			})

			for iter_44_0, iter_44_1 in pairs(var_43_3) do
				if not var_44_1[1][iter_44_0] and not var_44_1[2][iter_44_0] then
					return false
				end
			end
		end

		return true
	end

	for iter_43_0, iter_43_1 in ipairs(var_43_0) do
		local var_43_7 = gGameModel.chips:find(iter_43_1):read("chip_id", "card_db_id", "level", "locked")

		if not var_43_7.card_db_id then
			local var_43_8 = csv.chip.chips[var_43_7.chip_id]

			if var_43_6(var_43_8, iter_43_1) then
				var_43_4[iter_43_1] = {
					idx = iter_43_0,
					dbId = iter_43_1,
					chipId = var_43_7.chip_id,
					level = var_43_7.level,
					locked = var_43_7.locked,
					cfg = var_43_8
				}

				if var_43_2 then
					var_43_5[var_43_8.pos] = true
				end
			end
		end
	end

	dataEasy.tryCallFunc(arg_43_0.bagList, "updatePreloadCenterIndexAdaptFirst")
	arg_43_0.bagData:update(var_43_4)
	arg_43_0.slotFlags:set(var_43_5)
	arg_43_0.empty:visible(itertools.size(var_43_4) == 0)
end

function var_0_1.createMovePanel(arg_45_0, arg_45_1)
	if arg_45_0.movePanel then
		arg_45_0.movePanel:removeSelf()
	end

	local var_45_0 = arg_45_0.bagItem:clone():addTo(arg_45_0:getResourceNode(), 1000):show()

	arg_45_0.movePanel = var_45_0

	bind.extend(arg_45_0, var_45_0, {
		class = "icon_key",
		props = {
			noListener = true,
			data = {
				key = arg_45_1.chipId,
				dbId = arg_45_1.dbId
			},
			specialKey = {
				leftTopLv = arg_45_1.level
			},
			onNode = function(arg_46_0)
				arg_46_0:scale(1.15)
			end
		}
	})

	return var_45_0
end

function var_0_1.deleteMovingItem(arg_47_0)
	if arg_47_0.movePanel then
		arg_47_0.movePanel:removeSelf()

		arg_47_0.movePanel = nil
	end
end

function var_0_1.moveMovePanel(arg_48_0, arg_48_1)
	if arg_48_0.movePanel then
		arg_48_0.movePanel:xy(arg_48_1)
	end
end

function var_0_1.isMovePanelExist(arg_49_0)
	return arg_49_0.movePanel ~= nil
end

function var_0_1.moveEndMovePanel(arg_50_0, arg_50_1)
	if not arg_50_0.movePanel then
		return
	end

	arg_50_0.selectIndex:read()
	arg_50_0:onCardMove(arg_50_1, index, true)
	arg_50_0:deleteMovingItem()
end

function var_0_1.onItemTouch(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	if arg_51_5.name == "began" then
		arg_51_0.moved = false
		arg_51_0.touchBeganPos = arg_51_5

		arg_51_0:deleteMovingItem()
		performWithDelay(arg_51_0, function()
			arg_51_3.dbId = arg_51_4.dbId

			arg_51_0.selectItem:set(arg_51_3)
			arg_51_0.selectRightPos:set(arg_51_4.cfg.pos)
		end, 0)
	elseif arg_51_5.name == "moved" then
		if not arg_51_0.moved and not arg_51_0:isMovePanelExist() then
			local var_51_0 = math.abs(arg_51_5.x - arg_51_0.touchBeganPos.x)
			local var_51_1 = math.abs(arg_51_5.y - arg_51_0.touchBeganPos.y)

			if var_51_0 >= ui.TOUCH_MOVED_THRESHOLD or var_51_1 >= ui.TOUCH_MOVED_THRESHOLD then
				if var_51_0 > var_51_1 * 0.7 then
					arg_51_0:createMovePanel(arg_51_4)
				end

				arg_51_0.moved = true
			end
		end

		arg_51_0.bagList:setTouchEnabled(not arg_51_0:isMovePanelExist())
		arg_51_0:moveMovePanel(arg_51_5)
	elseif arg_51_5.name == "ended" or arg_51_5.name == "cancelled" then
		if not arg_51_0.moved then
			arg_51_0:showDetails(arg_51_1, arg_51_2, nil, arg_51_4.dbId, arg_51_0.selectCardDBID:read())

			return
		end

		arg_51_0:resetSelected()

		if arg_51_0.movePanel then
			arg_51_0:deleteMovingItem()

			for iter_51_0 = 1, 6 do
				local var_51_2 = arg_51_0.chipPanel:getItem(iter_51_0)
				local var_51_3 = var_51_2:box()
				local var_51_4 = var_51_2:getParent():convertToWorldSpace(cc.p(var_51_3.x, var_51_3.y))

				var_51_3.x, var_51_3.y = var_51_4.x, var_51_4.y
				var_51_3.width, var_51_3.height = var_51_3.width * arg_51_0.chipPanel:scale(), var_51_3.height * arg_51_0.chipPanel:scale()

				if cc.rectContainsPoint(var_51_3, arg_51_5) then
					if iter_51_0 == arg_51_4.cfg.pos then
						local var_51_5 = arg_51_0.cardChips:read()[iter_51_0] ~= nil

						gGameApp:requestServer("/game/card/chip/change", function(arg_53_0)
							if var_51_5 then
								gGameUI:showTip(gLanguageCsv.exchange2Success)
							else
								gGameUI:showTip(gLanguageCsv.inlaySuccess)
							end
						end, arg_51_0.selectCardDBID:read(), {
							[iter_51_0] = arg_51_4.dbId
						})
					else
						gGameUI:showTip(gLanguageCsv.chipSlotError)
					end

					return
				end
			end
		end
	end
end

function var_0_1.onCardChipClick(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	if arg_54_4.name == "began" then
		arg_54_0.moved = false
		arg_54_0.touchBeganPos = arg_54_4

		arg_54_0:deleteMovingItem()
	elseif arg_54_4.name == "moved" then
		if not arg_54_0.moved and not arg_54_0:isMovePanelExist() then
			local var_54_0 = math.abs(arg_54_4.x - arg_54_0.touchBeganPos.x)
			local var_54_1 = math.abs(arg_54_4.y - arg_54_0.touchBeganPos.y)

			if var_54_0 >= ui.TOUCH_MOVED_THRESHOLD or var_54_1 >= ui.TOUCH_MOVED_THRESHOLD then
				arg_54_0:createMovePanel(arg_54_3)

				arg_54_0.moved = true
			end
		end

		arg_54_0:moveMovePanel(arg_54_4)
	elseif arg_54_4.name == "ended" or arg_54_4.name == "cancelled" then
		if not arg_54_0.moved then
			arg_54_0.selectLeftPos:set(arg_54_2)
			arg_54_0.selectRightPos:set(arg_54_2)
			arg_54_0:showDetails(list, arg_54_1, arg_54_2, arg_54_3.dbId, arg_54_0.selectCardDBID:read())

			return
		end

		arg_54_0:resetSelected()

		if arg_54_0.movePanel then
			arg_54_0:deleteMovingItem()

			local var_54_2 = arg_54_0.bagList:box()
			local var_54_3 = arg_54_0.bagList:getParent():convertToWorldSpace(cc.p(var_54_2.x, var_54_2.y))

			var_54_2.x, var_54_2.y = var_54_3.x, var_54_3.y

			if cc.rectContainsPoint(var_54_2, arg_54_4) then
				gGameApp:requestServer("/game/card/chip/change", function(arg_55_0)
					gGameUI:showTip(gLanguageCsv.dischargeSuccess)
				end, arg_54_0.selectCardDBID:read(), {
					[arg_54_3.cfg.pos] = -1
				})
			end
		end
	end
end

function var_0_1.showPanel(arg_56_0)
	local var_56_0 = arg_56_0.selectCardDBID:read()
	local var_56_1, var_56_2 = var_0_2.getAttrs(var_56_0)
	local var_56_3 = {}

	var_0_2.setAttrCollect(var_56_1, var_56_2)

	for iter_56_0, iter_56_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		local var_56_4 = game.ATTRDEF_ENUM_TABLE[iter_56_1]

		if var_56_1[1][var_56_4] then
			table.insert(var_56_3, {
				attr = iter_56_1,
				key = var_56_4,
				val = var_56_1[1][var_56_4]
			})
		end
	end

	arg_56_0.baseAttrData:set(var_56_3)
	arg_56_0.baseAttrTip:visible(#var_56_3 == 0)

	local var_56_5 = {}
	local var_56_6 = var_0_2.getComplateSuitAttrByCard(var_56_0)

	for iter_56_2, iter_56_3 in pairs(var_56_6) do
		local var_56_7 = 0

		for iter_56_4, iter_56_5 in ipairs(iter_56_3.data) do
			if iter_56_5[3] then
				var_56_7 = math.max(var_56_7, iter_56_5[1])
			end
		end

		if var_56_7 > 0 then
			table.insert(var_56_5, {
				suitId = iter_56_3.suitId,
				maxActiveNum = var_56_7,
				data = iter_56_3.data
			})
		end
	end

	arg_56_0.suitAttrData:set(var_56_5)
	arg_56_0.suitAttrTip:visible(#var_56_5 == 0)
end

function var_0_1.onDrawClick(arg_57_0)
	gGameUI:stackUI("city.card.chip.draw")
end

function var_0_1.onOnekeyDownClick(arg_58_0)
	local var_58_0 = arg_58_0.selectCardDBID:read()
	local var_58_1 = gGameModel.cards:find(var_58_0):read("chip")

	if itertools.size(var_58_1) == 0 then
		return
	end

	local function var_58_2()
		local var_59_0 = {
			-1,
			-1,
			-1,
			-1,
			-1,
			-1
		}

		gGameApp:requestServer("/game/card/chip/change", function(arg_60_0)
			gGameUI:showTip(gLanguageCsv.dischargeSuccess)
		end, var_58_0, var_59_0)
	end

	local var_58_3 = "chipOnekeyDownTip"
	local var_58_4 = userDefault.getCurrDayKey(var_58_3, "first")

	if var_58_4 == "first" then
		var_58_4 = "true"

		userDefault.setCurrDayKey(var_58_3, var_58_4)
	end

	if var_58_4 == "first" or var_58_4 == "true" then
		gGameUI:showDialog({
			isRich = true,
			selectType = 2,
			btnType = 2,
			content = "#C0x57472E#" .. gLanguageCsv.chipOnekeyDownTip,
			cb = var_58_2,
			selectKey = var_58_3,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_58_2()
	end
end

function var_0_1.onPlanClick(arg_61_0)
	dataEasy.tryCallFunc(arg_61_0.chipPanel, "pauseSuitEffect")
	gGameUI:stackUI("city.card.chip.plan", nil, nil, {
		curCardDBID = arg_61_0.selectCardDBID:read(),
		cb = arg_61_0:createHandler("planCb")
	})
end

function var_0_1.planCb(arg_62_0, arg_62_1)
	arg_62_0:setCardDBID(arg_62_1)
	dataEasy.tryCallFunc(arg_62_0.chipPanel, "resumeSuitEffect")
end

function var_0_1.onPlanCompareClick(arg_63_0)
	return
end

function var_0_1.onBaseAttrDetailClick(arg_64_0)
	gGameUI:stackUI("city.card.chip.total_detail", nil, nil, {
		typ = 1,
		cardPlan = arg_64_0.selectCardDBID:read()
	})
end

function var_0_1.onSuitAttrDetailClick(arg_65_0)
	gGameUI:stackUI("city.card.chip.suit_detail", nil, nil, arg_65_0.selectCardDBID:read())
end

function var_0_1.onSuitAttrItemClick(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
	local var_66_0 = arg_66_0.suitAttrDetailPanel:get("panel")
	local var_66_1 = var_66_0:multiget("icon", "name", "count", "list")
	local var_66_2 = gChipSuitCsv[arg_66_4.suitId][2][2]

	var_66_1.icon:texture(var_0_2.getSuitRes(arg_66_4.suitId, arg_66_4.data))
	var_66_1.name:text(var_66_2.suitName)

	local var_66_3 = 0
	local var_66_4 = gGameModel.role:read("chips")

	for iter_66_0, iter_66_1 in ipairs(var_66_4) do
		local var_66_5 = gGameModel.chips:find(iter_66_1):read("chip_id")
		local var_66_6 = csv.chip.chips[var_66_5]

		if arg_66_4.suitId == var_66_6.suitID then
			var_66_3 = var_66_3 + 1
		end
	end

	var_66_1.count:text(gLanguageCsv.currentOwn .. var_66_3):hide()

	local var_66_7 = {}

	for iter_66_2, iter_66_3 in ipairs(arg_66_4.data) do
		local var_66_8 = var_0_2.getSuitAttrStr(arg_66_4.suitId, iter_66_3)

		table.insert(var_66_7, {
			str = var_66_8
		})
	end

	beauty.textScroll({
		margin = 10,
		isRich = true,
		list = var_66_1.list,
		strs = var_66_7
	})

	local var_66_9 = arg_66_2:convertToWorldSpaceAR(cc.p(0, 0))
	local var_66_10 = arg_66_0.suitAttrDetailPanel:convertToNodeSpace(var_66_9)

	var_66_0:x(var_66_10.x - var_66_0:width() / 2)
	arg_66_0.suitAttrDetailPanel:show()
end

function var_0_1.onSuitFilterItemClick(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4)
	arg_67_0.selectSuitId:set(arg_67_4.suitId, true)
end

function var_0_1.onSuitFilterAllClick(arg_68_0)
	arg_68_0.selectSuitId:set(nil, true)
end

function var_0_1.onAttrFilterItemClick(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	local var_69_0 = 0

	for iter_69_0, iter_69_1 in arg_69_0.attrFilterData:ipairs() do
		if iter_69_0 ~= 1 and iter_69_1:proxy().selected then
			var_69_0 = var_69_0 + 1
		end
	end

	if arg_69_3.k ~= 1 and var_69_0 >= 4 and arg_69_4.selected == false then
		gGameUI:showTip(gLanguageCsv.chipAttrFilterCountMax)

		return
	end

	local var_69_1 = false

	for iter_69_2, iter_69_3 in arg_69_0.attrFilterData:ipairs() do
		if iter_69_2 ~= 1 then
			if arg_69_3.k == 1 then
				iter_69_3:proxy().selected = false
			elseif arg_69_3.k == iter_69_2 then
				iter_69_3:proxy().selected = not iter_69_3:proxy().selected
			end

			if iter_69_3:proxy().selected then
				var_69_1 = true
			end
		end
	end

	arg_69_0.attrFilterData:atproxy(1).selected = not var_69_1
end

function var_0_1.onShowRule(arg_70_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_70_0:createHandler("getRuleContext"), {
		width = 2200,
		height = 1113
	})
end

function var_0_1.getRuleContext(arg_71_0, arg_71_1)
	local var_71_0 = adaptContext
	local var_71_1 = {
		var_71_0.clone(arg_71_1.title, function(arg_72_0)
			arg_72_0:get("text"):text(gLanguageCsv.chipRule)
		end),
		var_71_0.noteText(124601, 124605)
	}
	local var_71_2 = {}

	table.insert(var_71_2, {
		sign = true,
		key = csv.note[124606].fmt,
		main = csv.note[124607].fmt,
		sec = csv.note[124608].fmt
	})

	local var_71_3 = 124609

	for iter_71_0 = 1, 6 do
		table.insert(var_71_2, {
			sign = false,
			key = iter_71_0,
			main = csv.note[var_71_3 + 2 * iter_71_0 - 2].fmt,
			sec = csv.note[var_71_3 + 2 * iter_71_0 - 1].fmt
		})
	end

	for iter_71_1 = 1, 7 do
		table.insert(var_71_1, var_71_0.clone(arg_71_1.panelChip, function(arg_73_0)
			local var_73_0 = arg_73_0:multiget("txtLocation", "imgLocation", "txtMain", "txtSec", "img01", "img02")
			local var_73_1 = var_71_2[iter_71_1]

			if var_73_1.sign then
				var_73_0.txtLocation:x(40)
				var_73_0.txtSec:x(1000)
				var_73_0.imgLocation:hide()
			else
				var_73_0.imgLocation:show()
				var_73_0.imgLocation:rotate(60 * (var_73_1.key - 1))
			end

			var_73_0.txtLocation:text(var_73_1.key)
			var_73_0.txtMain:text(var_73_1.main)
			var_73_0.txtSec:text(var_73_1.sec)
			var_73_0.img01:visible(var_73_1.sign)
			var_73_0.img02:visible(var_73_1.sign)
		end))
	end

	return var_71_1
end

return var_0_1
