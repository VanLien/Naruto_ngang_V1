local var_0_0 = require("app.views.city.card.rebirth.tools")
local var_0_1 = require("app.views.city.card.helditem.tools")
local var_0_2 = {
	{
		58001,
		58005
	},
	{
		59001,
		59006
	},
	{
		60001,
		60004
	},
	{
		83001,
		83005
	},
	{
		124501,
		124505
	}
}
local var_0_3 = {
	gLanguageCsv.cardRebirthNote,
	gLanguageCsv.cardDecomposeNote,
	gLanguageCsv.heldItemRebirthNote,
	gLanguageCsv.gemRebirthRule,
	gLanguageCsv.chipRebirthRule
}
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("CardRebirthView", var_0_4)

var_0_5.RESOURCE_FILENAME = "rebirth_main.json"
var_0_5.RESOURCE_BINDING = {
	["right.selectTipPanel"] = "selectTipPanel",
	["left.panelDecompose"] = "decomposePanel",
	["left.panelDecompose.selectTipPanel"] = "decSelectTipPanel",
	btnItem = "btnItem",
	["left.panelChip.item"] = "chipItem",
	["right.cost"] = "panelCost",
	["left.panelCard.roleInfo"] = "roleInfoPanel",
	item = "item",
	["left.panelChip.subList"] = "chipSubList",
	["left.panelGem.item"] = "gemItem",
	["left.panelGem"] = "panelGem",
	right = "rightPanel",
	["left.panelCard"] = "panelCard",
	["left.panelGem.subList"] = "gemSubList",
	["right.cost.textCost"] = "costNum",
	["left.panelHeld"] = "heldItemPanel",
	["right.cost.textCostNote"] = "textCostNote",
	left = "leftPanel",
	starItem = "starItem",
	["left.panelCard.down"] = "downPanel",
	["left.panelCard.addbg"] = "roleAddBtnBG",
	innerList = "innerList",
	attrItem = "attrItem",
	["left.panel404"] = "panel404",
	["left.panel404.tile.txt"] = "txt404Tip",
	["right.cost.imgIcon"] = "costIcon",
	["left.panelCard.role"] = "roleNode",
	["right.textChipTip"] = "textChipTip",
	["right.tipPanel"] = "tipPanel",
	["left.panelCard.imgBg"] = "imgBg",
	["left.panelChip"] = "panelChip",
	["page.list"] = {
		varname = "pagelist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("btnsData"),
				item = bindHelper.self("btnItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = 36
					local var_1_1 = 38

					if arg_1_2 == 3 then
						local var_1_2 = 36
						local var_1_3 = 38
					end

					local var_1_4 = arg_1_1:get("btnClick")

					var_1_4:loadTextureNormal(arg_1_3.icon1)

					local var_1_5 = arg_1_1:get("btnNormal")

					var_1_5:loadTextureNormal(arg_1_3.icon2)
					var_1_4:visible(arg_1_3.isSel)
					var_1_5:visible(not arg_1_3.isSel)
					bind.touch(arg_1_0, var_1_5, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onChangePage")
			}
		}
	},
	["left.panelHeld.imgBg"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("heldItemId"),
			method = function(arg_2_0)
				local var_2_0 = "city/card/helditem/strengthen/img_helddt%d.png"
				local var_2_1 = 1

				if arg_2_0 then
					local var_2_2 = gGameModel.held_items:find(arg_2_0):read("held_item_id")

					var_2_1 = csv.held_item.items[var_2_2].quality
				end

				return string.format(var_2_0, var_2_1)
			end
		}
	},
	["left.panelGem.list"] = {
		varname = "gemList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				data = bindHelper.self("gems"),
				item = bindHelper.self("gemSubList"),
				cell = bindHelper.self("gemItem"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_3_3.id,
								dbId = arg_3_3.dbId
							},
							grayState = arg_3_3.selected and 1 or 0,
							specialKey = {
								leftTopLv = arg_3_3.level,
								unitId = arg_3_3.unitId
							},
							onNode = function(arg_4_0)
								arg_4_0:onClick(functools.partial(arg_3_0.itemClick, arg_3_0, arg_3_1, arg_3_2, arg_3_3))
								arg_4_0:scale(1.15)
							end
						}
					})
					arg_3_1:get("mask"):visible(false)
					arg_3_1:get("tick"):visible(arg_3_3.selected and true or false)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onGemClick")
			}
		}
	},
	["left.panelChip.list"] = {
		varname = "chipList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 5,
				data = bindHelper.self("chips"),
				item = bindHelper.self("chipSubList"),
				cell = bindHelper.self("chipItem"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					bind.extend(arg_5_0, arg_5_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_5_3.id,
								dbId = arg_5_3.dbid
							},
							grayState = arg_5_3.selected and 1 or 0,
							specialKey = {
								leftTopLv = arg_5_3.level,
								locked = arg_5_3.locked,
								unitId = arg_5_3.unitId
							},
							onNode = function(arg_6_0)
								arg_6_0:scale(1.15)
								arg_6_0:setTouchEnabled(false)
							end
						}
					})
					bind.touch(arg_5_0, arg_5_1, {
						method = function(arg_7_0, arg_7_1, arg_7_2, ...)
							arg_5_0.itemClick(arg_5_1, arg_5_0:getIdx(arg_5_2), arg_5_3, arg_7_2)
						end
					})
					arg_5_1:get("mask"):visible(false)
					arg_5_1:get("tick"):visible(arg_5_3.selected and true or false)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChipClick")
			}
		}
	},
	["left.panelCard.btnRoleAdd"] = {
		varname = "roleAddBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddRole")
			}
		}
	},
	["left.panelCard.btnChange"] = {
		varname = "changeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChange")
			}
		}
	},
	["left.panelCard.btnChange.textNote"] = {
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
	["left.panelCard.roleInfo.starList"] = {
		varname = "starlist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("starData"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_1:get("imgStar"):texture(arg_8_3.icon):scale(arg_8_3.starScale)
				end
			}
		}
	},
	["left.panelCard.roleInfo.attrList"] = {
		varname = "attrlist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrData"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					arg_9_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_9_3])
				end
			}
		}
	},
	["left.panelCard.down.list"] = {
		varname = "equiplist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("equipData1"),
				item = bindHelper.self("item"),
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					bind.extend(arg_10_0, arg_10_1, {
						event = "extend",
						class = "equip_icon",
						props = {
							data = arg_10_3,
							onNode = function(arg_11_0)
								arg_11_0:scale(1)
								arg_11_0:setTouchEnabled(false)
								arg_11_0:get("imgArrow"):visible(arg_10_3.state == true)
							end
						}
					})
				end
			}
		}
	},
	["left.panelCard.down.list_1"] = {
		varname = "equiplist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("equipData2"),
				item = bindHelper.self("item"),
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					bind.extend(arg_12_0, arg_12_1, {
						event = "extend",
						class = "equip_icon",
						props = {
							data = arg_12_3,
							onNode = function(arg_13_0)
								arg_13_0:scale(1)
								arg_13_0:setTouchEnabled(false)
								arg_13_0:get("imgArrow"):visible(arg_12_3.state == true)
							end
						}
					})
				end
			}
		}
	},
	["left.panelDecompose.jumpShop.textNote1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BROWN
				}
			}
		}
	},
	["left.panelDecompose.jumpShop.textNote2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BROWN
				}
			}
		}
	},
	["left.panelDecompose.jumpShop.Button_20"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onJumpToShop")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("isDecomposeView")
			}
		}
	},
	["left.panelDecompose.item1"] = {
		varname = "item1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddCard")
			}
		}
	},
	["left.panelDecompose.item2"] = {
		varname = "item2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddCard")
			}
		}
	},
	["left.panelDecompose.item3"] = {
		varname = "item3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddCard")
			}
		}
	},
	["left.panelDecompose.item4"] = {
		varname = "item4",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddCard")
			}
		}
	},
	["left.panelDecompose.item5"] = {
		varname = "item5",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddCard")
			}
		}
	},
	["left.panelDecompose.item1.btnCancel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_14_0)
					arg_14_0:onCancel(1)
				end)
			}
		}
	},
	["left.panelDecompose.item2.btnCancel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_15_0)
					arg_15_0:onCancel(2)
				end)
			}
		}
	},
	["left.panelDecompose.item3.btnCancel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_16_0)
					arg_16_0:onCancel(3)
				end)
			}
		}
	},
	["left.panelDecompose.item4.btnCancel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_17_0)
					arg_17_0:onCancel(4)
				end)
			}
		}
	},
	["left.panelDecompose.item5.btnCancel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_18_0)
					arg_18_0:onCancel(5)
				end)
			}
		}
	},
	["left.panelDecompose.btnAuto"] = {
		varname = "btnAuto",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAutoSelected")
			}
		}
	},
	["left.panelDecompose.btnAuto.textNote"] = {
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
	["left.panelDecompose.selectTipPanel.btn"] = {
		varname = "decSelectTipBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onDecSelectTipBtn")
		}
	},
	["right.tipPanel.textNote"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("tipText")
		}
	},
	["right.textNote"] = {
		varname = "rightTextNote",
		binds = {
			event = "text",
			idler = bindHelper.self("textRightNote")
		}
	},
	["right.selectTipPanel.btn"] = {
		varname = "selectTipBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onSelectTipBtn")
		}
	},
	["right.btnSure"] = {
		varname = "btnSure",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	},
	["right.btnSure.textNote"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("btnText")
		}
	},
	["right.list"] = {
		varname = "itemlist",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = bindHelper.self("midColumnSize"),
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
					local var_19_0 = {
						class = "icon_key",
						props = {
							data = {
								noColor = true,
								key = arg_19_3.key,
								num = arg_19_3.val
							}
						}
					}

					bind.extend(arg_19_0, arg_19_1, var_19_0)
				end
			}
		}
	},
	["left.panelHeld.imgIcon"] = {
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("showHeldItemIcon")
			},
			{
				event = "texture",
				idler = bindHelper.self("heldItemIcon")
			}
		}
	},
	["left.panelHeld.textName"] = {
		varname = "heldItemNameText",
		binds = {
			event = "text",
			idler = bindHelper.self("heldItemName")
		}
	},
	["left.panelHeld.btnAdd"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShowHeldItem")
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("showHeldItemAddBtn")
			}
		}
	},
	["left.panelHeld.btnChange"] = {
		varname = "heldChangeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChange")
			}
		}
	},
	["left.panelHeld.btnChange.textNote"] = {
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
	["left.panelHeld.textLv"] = {
		varname = "heldItemTextLv",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("showHeldItemIcon")
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.NORMAL.DEFAULT
					}
				}
			}
		}
	},
	["left.panelHeld.imgExc"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isHeldItemExc")
		}
	},
	["left.panelHeld.textLvNum"] = {
		varname = "textLvNum",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("showHeldItemIcon")
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.NORMAL.DEFAULT
					}
				}
			}
		}
	},
	["right.btnHelp"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleShow")
			}
		}
	}
}
var_0_5.RESOURCE_STYLES = {
	full = true
}

function var_0_5.initData(arg_20_0)
	arg_20_0.rebirthData = {
		{
			key = "cardReborn",
			icon2 = "city/card/rebirth/icon_rzcs.png",
			icon1 = "city/card/rebirth/icon_rzcs_2.png",
			isFirst = true,
			name = gLanguageCsv.cardRebirth,
			resetData = function()
				arg_20_0.dbId:set(nil)
				arg_20_0.roleNode:removeAllChildren()
			end,
			getTipInfo = function()
				local var_22_0 = var_0_0.isCardRebirthed(arg_20_0.dbId:read()) and arg_20_0.dbId:read() ~= nil and gLanguageCsv.cantRebirth or gLanguageCsv.notSelRole

				return gLanguageCsv.cardRebirth, var_22_0
			end,
			getUrlParams = function()
				local var_23_0 = uiEasy.getCardName(arg_20_0.dbId:read())

				return {
					scale = 1,
					url = "/game/card/rebirth",
					isEffect = true,
					pos = cc.p(910, 520),
					parent = arg_20_0.leftPanel,
					params = arg_20_0.dbId:read(),
					str = string.format(gLanguageCsv.rebirthCardTip, var_23_0),
					afterRequest = function()
						arg_20_0.isRebirthEnded:set(true, true)
						arg_20_0.itemDatas:update({})
						arg_20_0:refreshUI()
					end
				}
			end
		},
		{
			key = "cardReborn",
			icon2 = "city/card/rebirth/icon_rzfj.png",
			icon1 = "city/card/rebirth/icon_rzfj_2.png",
			name = gLanguageCsv.cardDecompose,
			resetData = function()
				arg_20_0.decomposePosState = {}

				arg_20_0.decomposeIds:set({})
			end,
			getTipInfo = function()
				return gLanguageCsv.cardDecompose, gLanguageCsv.notSelRole
			end,
			getUrlParams = function()
				local var_27_0 = {}
				local var_27_1 = false

				for iter_27_0, iter_27_1 in arg_20_0.decomposeIds:pairs() do
					if iter_27_1.rarity > 2 then
						var_27_1 = true
					end

					table.insert(var_27_0, iter_27_1.dbid)
				end

				return {
					url = "/game/card/decompose",
					isEffect = true,
					scale = 2,
					pos = cc.p(1228, 765),
					parent = arg_20_0.decomposePanel,
					params = var_27_0,
					haveHighRarity = var_27_1,
					str = gLanguageCsv.decomposeCardTip,
					afterRequest = function()
						if arg_20_0.handlers and type(arg_20_0.handlers) == "function" then
							arg_20_0.handlers()
						end

						arg_20_0.decomposeIds:set({})
						arg_20_0.itemDatas:update({})
						arg_20_0:refreshUI()
					end
				}
			end
		},
		{
			key = "heldItem",
			icon2 = "city/card/rebirth/icon_zbcs.png",
			icon1 = "city/card/rebirth/icon_zbcs_2.png",
			name = gLanguageCsv.heldItemRebirth,
			resetData = function()
				arg_20_0.heldItemId:set(nil)
			end,
			getTipInfo = function()
				local var_30_0 = arg_20_0.heldItemId:read()
				local var_30_1 = var_0_0.isHeldItemRebirthed(var_30_0) and var_30_0 ~= nil and gLanguageCsv.heldItemCanotRebirth or gLanguageCsv.notSelHeldItem

				return gLanguageCsv.reborn, var_30_1
			end,
			getUrlParams = function()
				local var_31_0 = gGameModel.held_items:find(arg_20_0.heldItemId:read())
				local var_31_1 = var_31_0:read("held_item_id")
				local var_31_2 = var_31_0:read("advance")
				local var_31_3 = csv.held_item.items[var_31_1]
				local var_31_4 = var_31_3.quality
				local var_31_5 = var_31_4 == 1 and "#C0x5B545B#" or ui.QUALITYCOLOR[var_31_4]
				local var_31_6 = string.format("%s%s+%s", var_31_5, var_31_3.name, var_31_2)

				return {
					url = "/game/helditem/rebirth",
					isEffect = true,
					scale = 1,
					pos = cc.p(915, 750),
					parent = arg_20_0.leftPanel,
					params = arg_20_0.heldItemId,
					str = string.format(gLanguageCsv.rebirthHeldItemTip, var_31_6),
					afterRequest = function()
						arg_20_0.isRebirthEnded:set(true, true)
						arg_20_0.itemDatas:update({})
						arg_20_0:refreshUI()
					end
				}
			end
		},
		{
			key = "gem",
			icon2 = "city/card/rebirth/icon_yjcs.png",
			icon1 = "city/card/rebirth/icon_yjcs_2.png",
			name = gLanguageCsv.gemRebirth,
			resetData = function()
				arg_20_0.selectGems = {}

				arg_20_0:updateGems()
			end,
			getTipInfo = function()
				return gLanguageCsv.gemRebirth, gLanguageCsv.selectGem, gLanguageCsv.haveNoSelectGem
			end,
			getUrlParams = function()
				return {
					scale = 1,
					url = "/game/gem/rebirth",
					pos = cc.p(915, 750),
					parent = arg_20_0.leftPanel,
					params = arg_20_0.selectGems,
					str = gLanguageCsv.rebirthGemTip,
					afterRequest = function()
						arg_20_0.selectGems = {}

						arg_20_0:updateGemCost()
						arg_20_0:updateGems()
						arg_20_0.itemDatas:update({})
						arg_20_0:refreshUI()
					end
				}
			end
		},
		{
			key = "chip",
			icon2 = "city/card/rebirth/icon_mjcs.png",
			icon1 = "city/card/rebirth/icon_mjcs_2.png",
			name = gLanguageCsv.chipRebirth,
			resetData = function()
				arg_20_0.selectChips = {}

				arg_20_0:updateChips()
			end,
			getTipInfo = function()
				return gLanguageCsv.chipRebirth, gLanguageCsv.selectChip, gLanguageCsv.haveNoSelectChip
			end,
			getUrlParams = function()
				local var_39_0 = {}

				for iter_39_0, iter_39_1 in pairs(arg_20_0.selectChips) do
					if iter_39_1 then
						table.insert(var_39_0, iter_39_0)
					end
				end

				return {
					url = "/game/chip/rebirth",
					scale = 1,
					pos = cc.p(915, 750),
					parent = arg_20_0.leftPanel,
					params = var_39_0,
					str = gLanguageCsv.rebirthChipTip,
					afterRequest = function()
						arg_20_0.selectChips = {}

						arg_20_0:updateChipCost()
						arg_20_0:updateChips()
						arg_20_0.itemDatas:update({})
						arg_20_0:refreshUI()
					end
				}
			end
		}
	}
end

function var_0_5.onCreate(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	gGameUI.topuiManager:createView("default", arg_41_0, {
		onClose = arg_41_0:createHandler("onClose")
	}):init({
		subTitle = "ELVES REBIRTH",
		title = "common/txt/txt_bt_renzhechongsheng.png"
	})

	arg_41_4 = arg_41_4 or {}

	local var_41_0, var_41_1 = adapt.centerWithScreen("left", nil, {
		itemWidthExtra = 0,
		itemWidth = arg_41_0.item:width()
	}, {
		{
			{
				arg_41_0.innerList,
				arg_41_0.itemlist
			},
			"width"
		}
	})

	arg_41_0.midColumnSize = 4 + (var_41_1 or 0)
	arg_41_0.asyncPreload = arg_41_0.midColumnSize * 5

	local var_41_2 = (arg_41_0.midColumnSize - 4) * arg_41_0.item:width()

	arg_41_0.itemlist:x(arg_41_0.itemlist:x() - var_41_2)
	arg_41_0.rightTextNote:x(arg_41_0.itemlist:x())
	arg_41_0.tipPanel:x(arg_41_0.tipPanel:x() - var_41_2 / 2)
	arg_41_0.selectTipPanel:x(arg_41_0.selectTipPanel:x() - var_41_2 / 2)
	arg_41_0.panelCost:x(arg_41_0.panelCost:x() - var_41_2)
	arg_41_0.textChipTip:x(arg_41_0.textChipTip:x() - var_41_2 / 2)

	arg_41_0.handlers = arg_41_2

	if arg_41_3 then
		arg_41_0.cardsChanged = arg_41_3()
	end

	arg_41_0:initModel()
	arg_41_0:initData()

	arg_41_0.pageIdx = idler.new(arg_41_1 or 1)
	arg_41_0.isDecomposeView = idler.new(arg_41_0.pageIdx:read() == 2)

	arg_41_0.heldItemId:set(arg_41_4.heldItemId)
	arg_41_0.panel404:visible(false)

	local var_41_3 = {}

	for iter_41_0, iter_41_1 in ipairs(arg_41_0.rebirthData) do
		if dataEasy.isUnlock(iter_41_1.key) then
			var_41_3[iter_41_0] = {
				isSel = false,
				txt = iter_41_1.name,
				icon1 = iter_41_1.icon1,
				icon2 = iter_41_1.icon2
			}
		end
	end

	arg_41_0.btnsData:update(var_41_3)
	idlereasy.any({
		arg_41_0.dbId,
		arg_41_0.isRebirthEnded
	}, function(arg_42_0, arg_42_1, arg_42_2)
		if not arg_42_1 or not gGameModel.cards:find(arg_42_1) then
			arg_41_0.dbId:set(nil)

			return
		end

		arg_41_0:initRebirthCardUI(arg_42_1)

		local var_42_0, var_42_1 = var_0_0.getReturnItems(arg_42_1)

		arg_41_0:initRightData(var_42_0, var_42_1)
		arg_41_0:refreshUI()
	end)
	arg_41_0.pageIdx:addListener(function(arg_43_0, arg_43_1)
		arg_41_0.btnsData:atproxy(arg_43_1).isSel = false
		arg_41_0.btnsData:atproxy(arg_43_0).isSel = true

		arg_41_0:initRightData({}, 0)
		arg_41_0.rebirthData[arg_43_0]:resetData()
		arg_41_0:refreshUI(arg_43_0)
	end)
	idlereasy.when(arg_41_0.decomposeIds, function(arg_44_0, arg_44_1)
		arg_41_0:initCardDecomposeUI(arg_44_1)

		local var_44_0, var_44_1 = var_0_0.computeDecomposeItems(arg_44_1)

		arg_41_0:initRightData(var_44_0, var_44_1)
		arg_41_0:refreshUI()
	end)
	idlereasy.any({
		arg_41_0.heldItemId,
		arg_41_0.isRebirthEnded
	}, function(arg_45_0, arg_45_1, arg_45_2)
		arg_41_0:initHeldItemUI(arg_45_1)

		if arg_45_1 then
			local var_45_0, var_45_1 = var_0_0.computeHeldItemReturn(arg_45_1)

			arg_41_0:initRightData(var_45_0, var_45_1)
			arg_41_0:refreshUI()
		end
	end)
	idlereasy.when(arg_41_0.rmb, function(arg_46_0, arg_46_1)
		arg_41_0:refreshTextColor()
	end)
	arg_41_0:initSelectTipPanel()
end

function var_0_5.initModel(arg_47_0)
	arg_47_0.rmb = gGameModel.role:getIdler("rmb")
	arg_47_0.cards = gGameModel.role:getIdler("cards")
	arg_47_0.items = gGameModel.role:getIdler("items")
	arg_47_0.dbId = idler.new()
	arg_47_0.heldItemId = idler.new()
	arg_47_0.selectGems = {}
	arg_47_0.gems = idlers.new({})
	arg_47_0.chips = idlers.new({})
	arg_47_0.cost = idler.new(0)
	arg_47_0.decomposePosState = {}
	arg_47_0.btnText = idler.new("")
	arg_47_0.showHeldItemIcon = idler.new(false)
	arg_47_0.isHeldItemExc = idler.new(false)
	arg_47_0.showHeldItemAddBtn = idler.new(false)
	arg_47_0.showGemItemAddBtn = idler.new(false)
	arg_47_0.heldItemName = idler.new("")
	arg_47_0.heldItemIcon = idler.new("")
	arg_47_0.decomposeIds = idlertable.new({})
	arg_47_0.isRebirthEnded = idler.new(false)
	arg_47_0.textRightNote = idler.new("")
	arg_47_0.tipText = idler.new("")
	arg_47_0.attrData = idlers.newWithMap({})
	arg_47_0.equipData1 = idlers.newWithMap({})
	arg_47_0.equipData2 = idlers.newWithMap({})
	arg_47_0.starData = idlers.newWithMap({})
	arg_47_0.btnsData = idlers.newWithMap({})
	arg_47_0.itemDatas = idlers.newWithMap({})
	arg_47_0.canRebirthGetItems = {}
	arg_47_0.canDecomposeIdsGetItems = {}
end

function var_0_5.initSelectTipPanel(arg_48_0)
	arg_48_0.decSelectTipPanel:visible(dataEasy.isUnlock(gUnlockCsv.decompositionMaxStar))

	local var_48_0 = userDefault.getForeverLocalKey("cardRebirthTip", false)

	arg_48_0.selectTipBtn:get("checkBox"):setSelectedState(var_48_0)

	local var_48_1 = userDefault.getForeverLocalKey("cardRebirthSelcetTip", false)

	arg_48_0.decSelectTipBtn:get("checkBox"):setSelectedState(var_48_1)

	local var_48_2 = arg_48_0.decSelectTipPanel:size()

	adapt.oneLineCenterPos(cc.p(var_48_2.width / 2, var_48_2.height / 2), {
		arg_48_0.decSelectTipBtn,
		arg_48_0.decSelectTipPanel:get("textTip")
	}, cc.p(0, 0))

	local var_48_3 = arg_48_0.selectTipPanel:get("textTip")

	adapt.setTextAdaptWithSize(var_48_3, {
		margin = -8,
		vertical = "center",
		horizontal = "left",
		str = gLanguageCsv.selectSpriteDecompositionTip,
		size = cc.size(800, 200)
	})
	var_48_3:anchorPoint(0.5, 0.5)

	local var_48_4 = arg_48_0.selectTipPanel:size()

	adapt.oneLineCenterPos(cc.p(var_48_4.width / 2, var_48_4.height / 2), {
		arg_48_0.selectTipBtn,
		var_48_3
	})

	if not matchLanguage({
		"cn",
		"tw"
	}) then
		var_48_3:y(var_48_3:y() - 10)
	end
end

function var_0_5.initRebirthCardUI(arg_49_0, arg_49_1)
	local var_49_0 = gGameModel.cards:find(arg_49_1):read("card_id", "skin_id", "level", "star", "advance", "equips", "skills")
	local var_49_1 = csv.cards[var_49_0.card_id]
	local var_49_2 = dataEasy.getUnitCsv(var_49_0.card_id, var_49_0.skin_id)
	local var_49_3 = arg_49_0.roleInfoPanel:multiget("imgIcon", "textLvNum", "textLv", "textName")

	var_49_3.imgIcon:texture(ui.RARITY_ICON[var_49_2.rarity])
	var_49_3.textLvNum:text(var_49_0.level)
	adapt.oneLineCenterPos(cc.p(var_49_3.imgIcon:x(), var_49_3.textLvNum:y()), {
		var_49_3.textLv,
		var_49_3.textLvNum
	})
	uiEasy.setIconName("card", var_49_0.card_id, {
		space = true,
		node = var_49_3.textName,
		name = var_49_1.name,
		advance = var_49_0.advance
	})
	text.addEffect(var_49_3.textName, {
		outline = {
			size = 4,
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	arg_49_0.roleNode:removeAllChildren()

	local var_49_4 = arg_49_0.roleNode:size()
	local var_49_5 = string.gsub(var_49_2.unitRes, ".skel", "_ui.skel")

	widget.addAnimation(arg_49_0.roleNode, var_49_5, "standby_loop", 1):xy(var_49_4.width / 2, -180):scale(var_49_2.scaleU * 0.7):setSkin(var_49_2.skin)

	local var_49_6 = {}

	table.insert(var_49_6, var_49_2.natureType)

	if var_49_2.natureType2 then
		table.insert(var_49_6, var_49_2.natureType2)
	end

	arg_49_0.attrData:update(var_49_6)

	local var_49_7 = {}
	local var_49_8 = var_49_0.star - 6

	for iter_49_0 = 1, 6 do
		local var_49_9 = "common/icon/icon_stardi.png"
		local var_49_10 = 0.66

		if iter_49_0 <= var_49_0.star then
			var_49_9 = dataEasy.getStarRes(var_49_0.star, iter_49_0)
			var_49_10 = 0.66
		end

		table.insert(var_49_7, {
			icon = var_49_9,
			starScale = var_49_10
		})
	end

	arg_49_0.starData:update(var_49_7)

	local var_49_11 = {}
	local var_49_12 = {}

	for iter_49_1 = 1, #var_49_0.equips do
		if iter_49_1 < 3 then
			var_49_11[iter_49_1] = var_49_0.equips[iter_49_1]
		elseif iter_49_1 < 5 then
			var_49_12[iter_49_1 - 2] = var_49_0.equips[iter_49_1]
		end
	end

	arg_49_0.equipData1:update(table.deepcopy(var_49_11, true))
	arg_49_0.equipData2:update(table.deepcopy(var_49_12, true))
end

function var_0_5.initCardDecomposeUI(arg_50_0, arg_50_1)
	if itertools.isempty(arg_50_0.decomposePosState) then
		local var_50_0 = itertools.keys(arg_50_1)

		table.sort(var_50_0)

		arg_50_0.decomposePosState = var_50_0
	end

	for iter_50_0 = 1, 5 do
		local var_50_1 = arg_50_1[arg_50_0.decomposePosState[iter_50_0]]

		if not var_50_1 then
			arg_50_0["item" .. iter_50_0]:get("btnCancel"):visible(false)
			arg_50_0["item" .. iter_50_0]:get("head"):visible(false)
			arg_50_0["item" .. iter_50_0]:get("btnAdd"):visible(true)
		else
			local var_50_2 = csv.unit[var_50_1.unitId].rarity

			bind.extend(arg_50_0, arg_50_0["item" .. iter_50_0]:get("head"), {
				class = "card_icon",
				props = {
					unitId = var_50_1.unitId,
					advance = var_50_1.advance,
					star = var_50_1.star,
					rarity = var_50_2,
					levelProps = {
						data = var_50_1.level
					}
				}
			})
			arg_50_0["item" .. iter_50_0]:get("btnCancel"):visible(true)
			arg_50_0["item" .. iter_50_0]:get("head"):visible(true)
			arg_50_0["item" .. iter_50_0]:get("btnAdd"):visible(false)
		end
	end
end

function var_0_5.initHeldItemUI(arg_51_0, arg_51_1)
	if not arg_51_1 then
		arg_51_0.showHeldItemIcon:set(false)
		arg_51_0.showHeldItemAddBtn:set(true)
		arg_51_0.heldItemName:set("")
		arg_51_0.isHeldItemExc:set(false)
		arg_51_0.heldItemTextLv:visible(false)
		arg_51_0.textLvNum:visible(false)

		return
	end

	arg_51_0.showHeldItemIcon:set(true)
	arg_51_0.showHeldItemAddBtn:set(false)

	local var_51_0 = gGameModel.held_items:find(arg_51_1)
	local var_51_1 = var_51_0:read("held_item_id")
	local var_51_2 = var_51_0:read("advance")
	local var_51_3 = var_51_0:read("level")
	local var_51_4, var_51_5 = var_0_1.isExclusive({
		csvId = var_51_1,
		dbId = arg_51_1
	})
	local var_51_6 = csv.held_item.items[var_51_1]

	arg_51_0.isHeldItemExc:set(var_51_5)
	arg_51_0.textLvNum:text(var_51_3)
	adapt.oneLinePos(arg_51_0.heldItemTextLv, arg_51_0.textLvNum, cc.p(5, 0), "left")

	local var_51_7 = var_51_6.name

	if var_51_2 ~= 0 then
		var_51_7 = var_51_6.name .. " +" .. var_51_2
	end

	arg_51_0.heldItemName:set(var_51_7)
	arg_51_0.heldItemIcon:set(var_51_6.icon)

	local var_51_8 = var_51_6.quality == 1 and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.QUALITY[var_51_6.quality]

	text.addEffect(arg_51_0.heldItemNameText, {
		color = var_51_8
	})
end

function var_0_5.initRightData(arg_52_0, arg_52_1, arg_52_2)
	arg_52_0.canRebirthGetItems = arg_52_1

	arg_52_0.itemDatas:update(arg_52_1)
	arg_52_0.costNum:text(arg_52_2)
	arg_52_0.cost:set(arg_52_2)
	arg_52_0:refreshTextColor()
	adapt.oneLinePos(arg_52_0.textCostNote, {
		arg_52_0.costNum,
		arg_52_0.costIcon
	}, cc.p(6, 0))
end

function var_0_5.updateGems(arg_53_0)
	local var_53_0 = gGameModel.role:read("gems")
	local var_53_1 = {}

	for iter_53_0, iter_53_1 in pairs(var_53_0) do
		local var_53_2 = gGameModel.gems:find(iter_53_1)
		local var_53_3 = var_53_2:read("gem_id")
		local var_53_4 = var_53_2:read("card_db_id")
		local var_53_5

		if var_53_4 then
			local var_53_6 = gGameModel.cards:find(var_53_4)

			var_53_5 = dataEasy.getUnitId(var_53_6:read("card_id"), var_53_6:read("skin_id"))
		end

		local var_53_7 = var_53_2:read("level")
		local var_53_8 = dataEasy.getCfgByKey(var_53_3)
		local var_53_9 = {
			num = 1,
			id = var_53_3,
			unitId = var_53_5,
			suitNo = var_53_8.suitNo,
			suitID = var_53_8.suitID,
			level = var_53_7,
			quality = var_53_8.quality,
			isEquipped = var_53_2:read("card_db_id") and true or false,
			dbid = iter_53_1,
			cardDbID = var_53_2:read("card_db_id")
		}

		if var_53_9.level > 1 then
			table.insert(var_53_1, var_53_9)
		end
	end

	table.sort(var_53_1, function(arg_54_0, arg_54_1)
		if arg_54_0.isEquipped ~= arg_54_1.isEquipped then
			return not arg_54_0.isEquipped
		end

		if arg_54_0.quality ~= arg_54_1.quality then
			return arg_54_0.quality < arg_54_1.quality
		end

		if arg_54_0.level ~= arg_54_1.level then
			return arg_54_0.level > arg_54_1.level
		end

		return arg_54_0.id < arg_54_1.id
	end)
	arg_53_0.gems:update(var_53_1)
	arg_53_0.panel404:visible(#var_53_1 == 0)
end

function var_0_5.updateChips(arg_55_0)
	local var_55_0 = gGameModel.role:read("chips")
	local var_55_1 = {}

	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		local var_55_2 = gGameModel.chips:find(iter_55_1):read("chip_id", "locked", "card_db_id", "level", "sum_exp")
		local var_55_3

		if var_55_2.card_db_id then
			local var_55_4 = gGameModel.cards:find(var_55_2.card_db_id)

			var_55_3 = dataEasy.getUnitId(var_55_4:read("card_id"), var_55_4:read("skin_id"))
		end

		if arg_55_0.selectChips[iter_55_1] and var_55_2.locked then
			arg_55_0.selectChips[iter_55_1] = false
		end

		local var_55_5 = dataEasy.getCfgByKey(var_55_2.chip_id)
		local var_55_6 = {
			id = var_55_2.chip_id,
			unitId = var_55_3,
			level = var_55_2.level,
			locked = var_55_2.locked,
			quality = var_55_5.quality,
			isEquipped = var_55_2.card_db_id and true or false,
			dbid = iter_55_1,
			cardDbID = var_55_2.card_db_id,
			selected = arg_55_0.selectChips[iter_55_1]
		}

		if var_55_2.sum_exp > 0 then
			table.insert(var_55_1, var_55_6)
		end
	end

	table.sort(var_55_1, function(arg_56_0, arg_56_1)
		if arg_56_0.isEquipped ~= arg_56_1.isEquipped then
			return not arg_56_0.isEquipped
		end

		if arg_56_0.quality ~= arg_56_1.quality then
			return arg_56_0.quality < arg_56_1.quality
		end

		if arg_56_0.level ~= arg_56_1.level then
			return arg_56_0.level > arg_56_1.level
		end

		return arg_56_0.id < arg_56_1.id
	end)
	arg_55_0.chips:update(var_55_1)
	arg_55_0.panel404:visible(#var_55_1 == 0)
end

function var_0_5.refreshTextColor(arg_57_0)
	local var_57_0 = ui.COLORS.NORMAL.WHITE

	if arg_57_0.cost:read() > arg_57_0.rmb:read() then
		var_57_0 = ui.COLORS.NORMAL.RED
	end

	text.addEffect(arg_57_0.costNum, {
		color = var_57_0
	})
end

function var_0_5.refreshUI(arg_58_0, arg_58_1)
	arg_58_1 = arg_58_1 or arg_58_0.pageIdx:read()

	arg_58_0.decomposePanel:visible(arg_58_1 == 2)
	arg_58_0.panelChip:visible(false)
	arg_58_0.heldItemPanel:visible(arg_58_1 == 3)
	arg_58_0.panelGem:visible(arg_58_1 == 4)
	arg_58_0.panelChip:visible(arg_58_1 == 5)
	arg_58_0.textChipTip:visible(arg_58_1 == 5)
	arg_58_0.panelCard:visible(arg_58_1 == 1)

	if arg_58_1 <= 3 then
		arg_58_0.panel404:visible(false)
	end

	arg_58_0.imgBg:visible(arg_58_1 == 1 and arg_58_0.dbId:read() == nil)
	arg_58_0.roleInfoPanel:visible(arg_58_1 == 1 and arg_58_0.dbId:read() ~= nil)
	arg_58_0.roleNode:visible(arg_58_1 == 1)
	arg_58_0.downPanel:visible(arg_58_1 == 1 and arg_58_0.dbId:read() ~= nil)
	arg_58_0.roleAddBtn:visible(arg_58_1 == 1 and not arg_58_0.dbId:read())
	arg_58_0.roleAddBtnBG:visible(arg_58_1 == 1 and not arg_58_0.dbId:read())
	arg_58_0.changeBtn:visible(arg_58_0.dbId:read() ~= nil)
	arg_58_0.heldChangeBtn:visible(arg_58_0.heldItemId:read() ~= nil)

	local var_58_0 = arg_58_0.itemDatas:size() > 0

	if arg_58_1 >= 4 and arg_58_0.panel404:isVisible() then
		arg_58_0.tipPanel:visible(false)
	else
		arg_58_0.tipPanel:visible(not var_58_0)
	end

	arg_58_0.itemlist:visible(var_58_0)
	cache.setShader(arg_58_0.btnSure, false, arg_58_0.itemDatas:size() > 0 and "normal" or "hsl_gray")
	arg_58_0.btnSure:setTouchEnabled(arg_58_0.itemDatas:size() > 0)

	if arg_58_0.itemDatas:size() > 0 then
		text.addEffect(arg_58_0.btnSure:get("textNote"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW1
			}
		})
	else
		text.deleteAllEffect(arg_58_0.btnSure:get("textNote"))
		text.addEffect(arg_58_0.btnSure:get("textNote"), {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.YELLOW1
			}
		})
	end

	local var_58_1, var_58_2, var_58_3 = arg_58_0.rebirthData[arg_58_1].getTipInfo()
	local var_58_4 = string.format(gLanguageCsv.rebirthNotes, var_58_1)

	arg_58_0.textRightNote:set(var_58_4)
	arg_58_0.tipText:set(var_58_2)
	arg_58_0.selectTipPanel:visible(arg_58_1 == 2)

	local var_58_5 = arg_58_1 == 2 and gLanguageCsv.decompose or gLanguageCsv.rebirthSpace

	arg_58_0.btnText:set(var_58_5)
	arg_58_0.isDecomposeView:set(arg_58_1 == 2)
	arg_58_0.txt404Tip:text(var_58_3 or "")
end

function var_0_5.onChangePage(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	arg_59_0.pageIdx:set(arg_59_2)
end

function var_0_5.onAddRole(arg_60_0)
	gGameUI:stackUI("city.card.rebirth.choose_role", nil, nil, {
		from = 1,
		handlers = arg_60_0:createHandler("onSetDbId")
	})
end

function var_0_5.onChange(arg_61_0)
	if arg_61_0.pageIdx:read() == 3 then
		gGameUI:stackUI("city.card.rebirth.choose_helditem", nil, nil, {
			curSel = arg_61_0.heldItemId:read(),
			handlers = arg_61_0:createHandler("onSetHeldItemDbId")
		})
	else
		gGameUI:stackUI("city.card.rebirth.choose_role", nil, nil, {
			from = 1,
			curSel = {
				arg_61_0.dbId:read()
			},
			handlers = arg_61_0:createHandler("onSetDbId")
		})
	end
end

function var_0_5.onSetDbId(arg_62_0, arg_62_1)
	local var_62_0, var_62_1 = next(arg_62_1)

	if var_62_1 then
		if gGameModel.cards:find(var_62_1.dbid) then
			arg_62_0.dbId:set(var_62_1.dbid)
		else
			arg_62_0.dbId:set(nil)
		end
	end
end

function var_0_5.onSetDecomposeDbId(arg_63_0, arg_63_1)
	for iter_63_0, iter_63_1 in pairs(arg_63_1) do
		if not gGameModel.cards:find(iter_63_1.dbid) then
			arg_63_1[iter_63_0] = nil
		end
	end

	arg_63_0.decomposePosState = {}

	arg_63_0.decomposeIds:set(arg_63_1)
end

function var_0_5.onAddCard(arg_64_0)
	local var_64_0 = {}

	for iter_64_0, iter_64_1 in arg_64_0.decomposeIds:pairs() do
		var_64_0[iter_64_0] = iter_64_1.dbid
	end

	gGameUI:stackUI("city.card.rebirth.choose_role", nil, nil, {
		from = 2,
		curSel = var_64_0,
		handlers = arg_64_0:createHandler("onSetDecomposeDbId")
	})
end

function var_0_5.onAutoSelected(arg_65_0)
	local var_65_0 = var_0_0.getSelectCard(2)

	local function var_65_1(arg_66_0)
		if arg_66_0.rarity >= 3 then
			return true
		end

		if arg_66_0.star > csv.cards[arg_66_0.id].star then
			return true
		end

		return false
	end

	table.sort(var_65_0, function(arg_67_0, arg_67_1)
		if arg_67_0.battle ~= arg_67_1.battle then
			return arg_67_0.battle == 2 and true or false
		end

		local var_67_0 = var_65_1(arg_67_0)
		local var_67_1 = var_65_1(arg_67_1)

		if var_67_0 ~= var_67_1 then
			return var_67_1
		end

		if arg_67_0.rarity ~= arg_67_1.rarity then
			return arg_67_0.rarity < arg_67_1.rarity
		end

		return arg_67_0.fight < arg_67_1.fight
	end)

	local var_65_2 = {}

	for iter_65_0, iter_65_1 in ipairs(gGameModel.role:read("cards")) do
		local var_65_3 = gGameModel.cards:find(iter_65_1)
		local var_65_4 = var_65_3:read("card_id")
		local var_65_5 = var_65_3:read("star")
		local var_65_6 = csv.cards[var_65_4].cardMarkID

		var_65_2[var_65_6] = var_65_2[var_65_6] and math.max(var_65_2[var_65_6], var_65_5) or var_65_5
	end

	local var_65_7 = {}
	local var_65_8 = 0
	local var_65_9 = {}
	local var_65_10 = {}
	local var_65_11 = 0
	local var_65_12 = false
	local var_65_13 = false
	local var_65_14 = gLanguageCsv.hasRarityCard
	local var_65_15 = userDefault.getForeverLocalKey("cardRebirthSelcetTip", false)

	for iter_65_2, iter_65_3 in ipairs(var_65_0) do
		if iter_65_3.battle ~= 1 and not iter_65_3.isUnion and not iter_65_3.lock and iter_65_3.cardType == 1 and (not var_65_15 or var_65_2[iter_65_3.markId] == 12 and iter_65_3.star ~= 12) then
			var_65_11 = var_65_11 + 1
			var_65_7[iter_65_2] = iter_65_3

			table.insert(var_65_10, iter_65_3.dbid)

			local var_65_16 = csv.cards[iter_65_3.id]

			if iter_65_3.rarity >= 3 or iter_65_3.star > var_65_16.star then
				table.insert(var_65_9, iter_65_2)
			end

			if iter_65_3.star > var_65_16.star then
				var_65_12 = true
				var_65_14 = gLanguageCsv.higherStarContinueDecomposition
			end

			if iter_65_3.rarity >= 3 then
				var_65_13 = true
			end
		end

		if var_65_11 == 5 then
			break
		end
	end

	if var_65_12 and var_65_13 then
		var_65_14 = gLanguageCsv.hasRarityAndStarCard
	end

	if itertools.size(var_65_7) == 0 then
		gGameUI:showTip(gLanguageCsv.noSpriteToDecompose)

		return
	end

	arg_65_0.decomposePosState = {}

	arg_65_0.decomposeIds:set(var_65_7, true)

	if #var_65_9 > 0 then
		local var_65_17 = {
			btnType = 2,
			closeCb = function()
				arg_65_0.decomposeIds:modify(function(arg_69_0)
					for iter_69_0, iter_69_1 in ipairs(var_65_9) do
						arg_69_0[iter_69_1] = nil
					end

					return true, arg_69_0
				end, true)
			end,
			content = var_65_14
		}

		gGameUI:showDialog(var_65_17)
	end
end

function var_0_5.onCancel(arg_70_0, arg_70_1)
	local var_70_0 = arg_70_0.decomposePosState[arg_70_1]

	if arg_70_0.decomposePosState[arg_70_1] then
		arg_70_0.decomposePosState[arg_70_1] = 0
	end

	arg_70_0.decomposeIds:modify(function(arg_71_0)
		if arg_71_0[var_70_0] then
			arg_71_0[var_70_0] = nil
		end

		return true, arg_71_0
	end, true)
end

function var_0_5.onSetHeldItemDbId(arg_72_0, arg_72_1)
	arg_72_0.heldItemId:set(arg_72_1.dbId)
end

function var_0_5.onShowHeldItem(arg_73_0)
	if arg_73_0.pageIdx:read() == 3 then
		gGameUI:stackUI("city.card.rebirth.choose_helditem", nil, nil, {
			handlers = arg_73_0:createHandler("onSetHeldItemDbId")
		})
	end
end

function var_0_5.onSure(arg_74_0)
	local var_74_0 = arg_74_0.pageIdx:read()
	local var_74_1 = arg_74_0.itemDatas:size()

	local function var_74_2()
		if var_74_1 == 0 then
			local var_75_0 = gLanguageCsv.cantRebirth

			if var_74_0 == 1 and not arg_74_0.dbId:read() or var_74_0 == 2 then
				var_75_0 = gLanguageCsv.notSelRole
			elseif var_74_0 == 3 then
				var_75_0 = gLanguageCsv.notSelHeldItem

				if arg_74_0.heldItemId:read() ~= nil then
					var_75_0 = gLanguageCsv.heldItemCanotRebirth
				end
			elseif var_74_0 == 4 then
				var_75_0 = gLanguageCsv.selectGem
			end

			gGameUI:showTip(var_75_0)

			return
		end

		if arg_74_0.cost:read() > 0 and arg_74_0.cost:read() > arg_74_0.rmb:read() then
			uiEasy.showDialog("rmb")

			return
		end

		local var_75_1 = arg_74_0.rebirthData[var_74_0].getUrlParams()

		local function var_75_2()
			local var_76_0 = {
				false
			}

			gGameApp:requestServerCustom(var_75_1.url):params(var_75_1.params):onResponse(function(arg_77_0)
				local var_77_0 = var_75_1.parent:getChildByName("effect")

				if var_75_1.isEffect then
					if var_77_0 then
						var_77_0:xy(var_75_1.pos)
						var_77_0:show()
						var_77_0:play("effect")
					else
						var_77_0 = widget.addAnimationByKey(var_75_1.parent, "effect/chongsheng.skel", "effect", "effect", 100):xy(var_75_1.pos):scale(var_75_1.scale)
					end

					performWithDelay(arg_74_0, function()
						var_77_0:hide()

						if var_75_1.afterRequest then
							var_75_1.afterRequest()
						end

						var_76_0[1] = true
					end, 0.8333333333333334)
				else
					if var_75_1.afterRequest then
						var_75_1.afterRequest()
					end

					var_76_0[1] = true
				end
			end):wait(var_76_0):doit(function(arg_79_0)
				gGameUI:showGainDisplay(arg_79_0)
			end)
		end

		local var_75_3 = userDefault.getForeverLocalKey("cardRebirthTip", false)

		if var_74_0 == 2 and var_75_3 and not var_75_1.haveHighRarity then
			var_75_2()
		else
			local var_75_4 = {
				isRich = true,
				btnType = 2,
				cb = var_75_2,
				content = var_75_1.str
			}

			if arg_74_0.cost:read() > 0 and arg_74_0.cost:read() < arg_74_0.rmb:read() then
				local var_75_5 = var_75_4.cb

				function var_75_4.cb()
					dataEasy.sureUsingDiamonds(var_75_5, arg_74_0.cost:read())
				end
			end

			gGameUI:showDialog(var_75_4)
		end
	end

	local var_74_3 = {}
	local var_74_4 = arg_74_0.items:read()
	local var_74_5 = csv.items
	local var_74_6 = var_74_0 ~= 2 and arg_74_0.canRebirthGetItems or var_74_0 == 2 and arg_74_0.canDecomposeIdsGetItems

	for iter_74_0, iter_74_1 in ipairs(var_74_6) do
		if type(iter_74_1.key) == "number" and var_74_5[iter_74_1.key] then
			local var_74_7 = var_74_4[iter_74_1.key] or 0

			if iter_74_1.val + var_74_7 > var_74_5[iter_74_1.key].stackMax then
				table.insert(var_74_3, {
					val = var_74_7 + iter_74_1.val - var_74_5[iter_74_1.key].stackMax,
					key = iter_74_1.key
				})
			end
		end
	end

	if #var_74_3 > 0 then
		table.sort(var_74_3, function(arg_81_0, arg_81_1)
			return arg_81_0.val > arg_81_1.val
		end)

		local var_74_8 = ""

		for iter_74_2, iter_74_3 in ipairs(var_74_3) do
			if iter_74_2 == 4 then
				var_74_8 = var_74_8 .. "..."

				break
			elseif iter_74_2 == 1 then
				var_74_8 = var_74_8 .. "#C0xE77422#" .. var_74_5[iter_74_3.key].name .. "#C0x5b545b#"
			else
				var_74_8 = var_74_8 .. "#C0xE77422#," .. var_74_5[iter_74_3.key].name .. "#C0x5b545b#"
			end
		end

		local var_74_9 = ""

		if var_74_0 ~= 2 then
			var_74_9 = string.format("#C0x5b545b#" .. gLanguageCsv.itemRebirthExceed, var_74_8)
		else
			var_74_9 = string.format("#C0x5b545b#" .. gLanguageCsv.itemDecomposeIdsExceed, var_74_8)
		end

		gGameUI:showDialog({
			delayTime = 5,
			isRich = true,
			btnType = 2,
			content = var_74_9,
			cb = function()
				var_74_2()
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		var_74_2()
	end
end

function var_0_5.onSelectTipBtn(arg_83_0)
	local var_83_0 = userDefault.getForeverLocalKey("cardRebirthTip", false)

	arg_83_0.selectTipBtn:get("checkBox"):setSelectedState(not var_83_0)
	userDefault.setForeverLocalKey("cardRebirthTip", not var_83_0)
end

function var_0_5.onDecSelectTipBtn(arg_84_0)
	local var_84_0 = userDefault.getForeverLocalKey("cardRebirthSelcetTip", false)

	arg_84_0.decSelectTipBtn:get("checkBox"):setSelectedState(not var_84_0)
	userDefault.setForeverLocalKey("cardRebirthSelcetTip", not var_84_0)
end

function var_0_5.onRuleShow(arg_85_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_85_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_5.getRuleContext(arg_86_0, arg_86_1)
	local var_86_0 = arg_86_0.pageIdx:read()
	local var_86_1 = var_0_2[var_86_0]
	local var_86_2 = adaptContext

	return {
		var_86_2.clone(arg_86_1.title, function(arg_87_0)
			arg_87_0:get("text"):text(var_0_3[var_86_0])
		end),
		var_86_2.noteText(unpack(var_86_1))
	}
end

function var_0_5.onJumpToShop(arg_88_0)
	if not dataEasy.isUnlock(gUnlockCsv.fragmentShop) then
		gGameUI:showTip(gLanguageCsv.shopNotOpen)

		return
	end

	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/frag/shop/get", function(arg_89_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.FRAG_SHOP)
		end)
	end
end

function var_0_5.onGemClick(arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4, arg_90_5, arg_90_6)
	local var_90_0 = not arg_90_5.selected

	local function var_90_1()
		if not var_90_0 then
			for iter_91_0 = #arg_90_0.selectGems, 1, -1 do
				if arg_90_0.selectGems[iter_91_0] == arg_90_5.dbid then
					table.remove(arg_90_0.selectGems, iter_91_0)
					arg_90_0:updateGemCost()

					break
				end
			end
		else
			table.insert(arg_90_0.selectGems, arg_90_5.dbid)
			arg_90_0:updateGemCost()
		end

		local var_91_0 = arg_90_1:getIdx(arg_90_4)

		arg_90_0.gems:atproxy(var_91_0.k).selected = var_90_0

		audio.playEffectWithWeekBGM("circle.mp3")
	end

	local var_90_2 = "rebirthGemTip"
	local var_90_3 = userDefault.getCurrDayKey(var_90_2, "first")

	if var_90_3 == "first" then
		var_90_3 = "true"

		userDefault.setCurrDayKey(var_90_2, var_90_3)
	end

	if (var_90_3 == "first" or var_90_3 == "true") and var_90_0 and arg_90_5.isEquipped then
		local var_90_4 = uiEasy.getCardName(arg_90_5.cardDbID)
		local var_90_5 = string.format(gLanguageCsv.inlayCard, var_90_4)

		gGameUI:showDialog({
			selectType = 2,
			isRich = true,
			btnType = 2,
			cb = var_90_1,
			content = var_90_5,
			selectKey = var_90_2,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_90_1()
	end
end

function var_0_5.updateGemCost(arg_92_0)
	local var_92_0, var_92_1 = var_0_0.getReturnItemsGem(arg_92_0.selectGems)

	arg_92_0:initRightData(var_92_0, var_92_1)
	arg_92_0:refreshUI()
end

function var_0_5.updateChipCost(arg_93_0)
	local var_93_0 = {}

	for iter_93_0, iter_93_1 in pairs(arg_93_0.selectChips) do
		if iter_93_1 then
			table.insert(var_93_0, iter_93_0)
		end
	end

	local var_93_1, var_93_2 = var_0_0.getReturnItemsChip(var_93_0)

	arg_93_0:initRightData(var_93_1, var_93_2)
	arg_93_0:refreshUI()
end

function var_0_5.onItemTouchShow(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local var_94_0 = arg_94_2:convertToWorldSpaceAR(cc.p(100, 0))

	gGameUI:stackUI("city.card.chip.details", nil, {
		clickClose = true,
		dispatchNodes = arg_94_0.strengthenPanel
	}, {
		align = "right",
		justShow = true,
		dbId = arg_94_4.dbid,
		pos = var_94_0,
		dataRefresh = function()
			arg_94_0:updateChips()
			arg_94_0:updateChipCost()
		end
	})
end

function var_0_5.onChipClick(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	if arg_96_5.name == "began" then
		arg_96_0.touchBeganPos = arg_96_5
		arg_96_0.isClicked = true
		arg_96_0.itemTouchShow = false

		if arg_96_0.sequence then
			arg_96_0:stopAction(arg_96_0.sequence)
		end

		arg_96_0.chipSubList:setTouchEnabled(true)

		arg_96_0.sequence = cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
			if arg_96_4.type ~= "item" then
				arg_96_0.itemTouchShow = true

				arg_96_0:onItemTouchShow(arg_96_1, arg_96_2, arg_96_3, arg_96_4)
				arg_96_0.chipSubList:setTouchEnabled(false)
			end

			arg_96_0.sequence = nil
		end))

		arg_96_0:runAction(arg_96_0.sequence)
	elseif arg_96_5.name == "moved" then
		if arg_96_0.isClicked then
			local var_96_0 = math.abs(arg_96_5.x - arg_96_0.touchBeganPos.x)
			local var_96_1 = math.abs(arg_96_5.y - arg_96_0.touchBeganPos.y)

			if var_96_0 >= ui.TOUCH_MOVED_THRESHOLD or var_96_1 >= ui.TOUCH_MOVED_THRESHOLD then
				arg_96_0.isClicked = false

				if arg_96_0.sequence then
					arg_96_0:stopAction(arg_96_0.sequence)

					arg_96_0.sequence = nil
				end
			end
		end
	elseif arg_96_5.name == "ended" or arg_96_5.name == "cancelled" then
		if arg_96_0.sequence then
			arg_96_0:stopAction(arg_96_0.sequence)

			arg_96_0.sequence = nil
		end

		if arg_96_0.isClicked and not arg_96_0.itemTouchShow then
			if arg_96_4.locked then
				gGameUI:showTip(gLanguageCsv.chipStrengthenLocked)
			else
				local var_96_2 = not arg_96_4.selected

				local function var_96_3()
					arg_96_0.selectChips[arg_96_4.dbid] = var_96_2

					arg_96_0:updateChipCost()

					arg_96_0.chips:atproxy(arg_96_3.k).selected = var_96_2

					audio.playEffectWithWeekBGM("circle.mp3")
				end

				local var_96_4 = "rebirthChipTip"
				local var_96_5 = userDefault.getCurrDayKey(var_96_4, "first")

				if var_96_5 == "first" then
					var_96_5 = "true"

					userDefault.setCurrDayKey(var_96_4, var_96_5)
				end

				if (var_96_5 == "first" or var_96_5 == "true") and var_96_2 and arg_96_4.isEquipped then
					local var_96_6 = uiEasy.getCardName(arg_96_4.cardDbID)
					local var_96_7 = string.format(gLanguageCsv.inlayCard, var_96_6)

					gGameUI:showDialog({
						selectType = 2,
						isRich = true,
						btnType = 2,
						cb = var_96_3,
						content = var_96_7,
						selectKey = var_96_4,
						selectTip = gLanguageCsv.todayNoTip
					})
				else
					var_96_3()
				end
			end
		end
	end
end

function var_0_5.onClose(arg_99_0)
	if arg_99_0.cardsChanged then
		arg_99_0.cardsChanged:notify()
	end

	var_0_4.onClose(arg_99_0)
end

return var_0_5
