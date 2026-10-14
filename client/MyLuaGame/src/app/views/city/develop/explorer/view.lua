local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ExploreView", var_0_0)
local var_0_2 = require("app.views.city.develop.explorer.tools")
local var_0_3 = require("app.easy.bind.helper.red_hint")
local var_0_4 = 20

var_0_1.RESOURCE_FILENAME = "explore_view.json"
var_0_1.RESOURCE_BINDING = {
	["upRightPanel.name"] = "nodeName",
	["componentPanel.upgradePanel.item"] = "upgradeItem",
	["upRightPanel.maxPanel"] = "maxPanel",
	["upLeftPanel.componentPanel"] = "componentPanel",
	["upLeftPanel.icon"] = "icon",
	["bottomPanel.item"] = "bottomItem",
	["upLeftPanel.btn"] = "btnLeft",
	["bottomPanel.bg"] = "bottomBg",
	["componentPanel.upgradePanel.item1"] = "item1",
	bottomPanel = "bottomPanel",
	componentPanel = "componentDetailPanel",
	upLeftPanel = "upLeftPanel",
	["upRightPanel.upList"] = "upList",
	["componentPanel.otherPanel.item"] = "otherItem",
	["upRightPanel.activeTip"] = "activeTip",
	["upRightPanel.downList"] = "downList",
	["upLeftPanel.name"] = "iconName",
	["upLeftPanel.linePanel"] = "linePanel",
	["componentPanel.otherPanel"] = "otherPanel",
	["componentPanel.upgradePanel"] = "upgradePanel",
	["bottomPanel.list"] = {
		varname = "listview",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("bottomData"),
				item = bindHelper.self("bottomItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("panel")
					local var_1_1 = var_1_0:multiget("icon", "lock", "selected", "selected2", "bg")

					var_1_1.icon:texture(arg_1_3.cfg.simpleIcon)
					var_1_1.bg:texture("city/develop/explore/panel_icon_tx" .. arg_1_3.cfg.quality .. ".png")

					if arg_1_3.advance == 0 then
						if arg_1_3.selected then
							var_1_1.lock:texture("common/btn/btn_lock_big.png")
							var_1_1.lock:scale(1)
						else
							var_1_1.lock:texture("city/develop/talent/btn_lock.png")
							var_1_1.lock:scale(0.75)
						end
					end

					arg_1_0.state = arg_1_3.selected ~= true

					local var_1_2 = {
						class = "red_hint",
						props = {
							specialTag = "explorerShow",
							state = bindHelper.self("state"),
							listenData = {
								id = arg_1_3.id
							},
							onNode = function(arg_2_0)
								return
							end
						}
					}

					bind.extend(arg_1_0, arg_1_1, var_1_2)
					var_1_1.lock:visible(arg_1_3.advance == 0)
					cache.setShader(var_1_1.icon, false, arg_1_3.advance == 0 and "gray" or "normal")
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
					var_1_1.selected:visible(arg_1_3.selected == true)
					var_1_1.selected2:visible(arg_1_3.selected == true)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["upLeftPanel.btnDecompose"] = {
		varname = "btnDecompose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDecomposeClick")
			}
		}
	},
	["upLeftPanel.btnShop"] = {
		varname = "btnShop",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShopClick")
			}
		}
	},
	["upLeftPanel.btnDecompose.txt"] = {
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
	["upLeftPanel.btnFind"] = {
		varname = "btnFind",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onFindClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "explorerFind",
					onNode = function(arg_3_0)
						arg_3_0:scale(0.66)
					end
				}
			}
		}
	},
	["upLeftPanel.btnFind.txt"] = {
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
	["upLeftPanel.btnShop.txt"] = {
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
	["upLeftPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["upLeftPanel.btnRule.txt"] = {
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
	["upRightPanel.btn.txt"] = {
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
	mask = {
		varname = "mask",
		binds = {
			event = "click",
			method = bindHelper.self("onMaskClick")
		}
	},
	["componentPanel.otherPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("componentData"),
				dataOrderCmp = function(arg_4_0, arg_4_1)
					return arg_4_0.attrType < arg_4_1.attrType
				end,
				item = bindHelper.self("otherItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("name", "left", "max")
					local var_5_1 = arg_5_3.attrNum[arg_5_3.level == 0 and 1 or arg_5_3.level]

					var_5_0.name:text(getLanguageAttr(arg_5_3.attrType))
					var_5_0.left:text("+" .. dataEasy.getAttrValueString(arg_5_3.attrType, var_5_1))
					var_5_0.max:visible(arg_5_3.isMax == true)
					adapt.oneLinePos(var_5_0.left, var_5_0.max, cc.p(30, 0))

					if string.utf8len(getLanguageAttr(arg_5_3.attrType)) > 4 then
						adapt.oneLinePos(var_5_0.name, {
							var_5_0.left,
							var_5_0.max
						}, {
							cc.p(5, 0),
							cc.p(30, 0)
						})
					else
						adapt.oneLinePos(var_5_0.name, {
							var_5_0.left,
							var_5_0.max
						}, {
							cc.p(100, 0),
							cc.p(30, 0)
						})
					end
				end
			}
		}
	},
	["componentPanel.upgradePanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("componentData"),
				dataOrderCmp = function(arg_6_0, arg_6_1)
					return arg_6_0.attrType < arg_6_1.attrType
				end,
				item = bindHelper.self("upgradeItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:multiget("name", "left", "right")
					local var_7_1 = arg_7_3.attrNum[arg_7_3.level == 0 and 1 or arg_7_3.level]
					local var_7_2 = arg_7_3.attrNum[arg_7_3.level + 1]

					var_7_0.name:text(getLanguageAttr(arg_7_3.attrType))

					local var_7_3 = string.utf8len(getLanguageAttr(arg_7_3.attrType)) > 5 and 40 - 5 * (string.utf8len(getLanguageAttr(arg_7_3.attrType)) - 5) or 40

					var_7_0.name:setFontSize(var_7_3)
					var_7_0.left:text(dataEasy.getAttrValueString(arg_7_3.attrType, var_7_1))

					if var_7_2 then
						var_7_0.right:text(dataEasy.getAttrValueString(arg_7_3.attrType, var_7_2))
					else
						var_7_0.right:text("")
					end
				end
			}
		}
	},
	["componentPanel.upgradePanel.list1"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("upgradeData"),
				margin = var_0_4,
				item = bindHelper.self("item1"),
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("add", "mask")

					bind.extend(arg_8_0, arg_8_1, {
						class = "icon_key",
						props = {
							data = {
								key = arg_8_3.id,
								num = arg_8_3.num,
								targetNum = arg_8_3.targetNum
							},
							grayState = arg_8_3.targetNum > arg_8_3.num and 3 or 0,
							onNode = function(arg_9_0)
								if arg_8_3.targetNum > arg_8_3.num then
									bind.click(arg_8_0, arg_9_0, {
										method = functools.partial(arg_8_0.clickCell, arg_8_2, arg_8_3)
									})
								end
							end
						}
					})
					var_8_0.mask:hide()
					var_8_0.add:hide()
					var_8_0.add:visible(arg_8_3.targetNum > arg_8_3.num)
					var_8_0.mask:texture(dataEasy.getIconResByKey(arg_8_3.id)):scale(2)
				end,
				onAfterBuild = function(arg_10_0)
					arg_10_0.afterBuild()
					arg_10_0:setClippingEnabled(false)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemMaskClick"),
				afterBuild = bindHelper.self("onList1AfterBuild")
			}
		}
	},
	["upRightPanel.btn"] = {
		varname = "btnRight",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRightClick")
			}
		}
	},
	["upLeftPanel.btnEffect"] = {
		varname = "btnEffect",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRightClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_11_0, arg_11_1)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_11_0.listview,
			"width"
		},
		{
			arg_11_0.listview,
			"pos",
			"left"
		},
		{
			arg_11_0.bottomBg,
			"width"
		},
		{
			arg_11_0.bottomBg,
			"pos",
			"left"
		}
	})
	arg_11_0.bottomBg:x(arg_11_0.listview:x() + arg_11_0.listview:size().width / 2)
	gGameUI.topuiManager:createView("default", arg_11_0, {
		onClose = arg_11_0:createHandler("onClose")
	}):init({
		subTitle = "EXPLORER",
		title = "common/txt/txt_bt_tonglingshou.png"
	})
	arg_11_0:initModel()

	arg_11_0.kejihuoEffect = widget.addAnimationByKey(arg_11_0.btnEffect, "jinjie/kejinjiekejiesuo.skel", "kejihuoEffect", "kejihuo_loop", 99):xy(arg_11_0.btnEffect:width() / 2, arg_11_0.btnEffect:height() / 2):scale(2.3)

	local var_11_0 = {}

	for iter_11_0, iter_11_1 in orderCsvPairs(csv.explorer.explorer) do
		local var_11_1 = {
			advance = 0,
			id = iter_11_0,
			cfg = iter_11_1
		}

		for iter_11_2, iter_11_3 in ipairs(iter_11_1.componentIDs) do
			local var_11_2 = csv.explorer.component[iter_11_3]

			var_11_1.components = var_11_1.components or {}

			local var_11_3 = 0

			var_11_1.components[var_11_2.componentPosID] = {
				count = 0,
				id = iter_11_3,
				level = var_11_3
			}
		end

		table.insert(var_11_0, var_11_1)
	end

	arg_11_0.bottomData = idlers.newWithMap(var_11_0)
	arg_11_0.components = idlertable.new({})
	arg_11_0.showTab = idler.new(arg_11_0._showTab or 1)

	idlereasy.any({
		arg_11_0.explores,
		arg_11_0.items
	}, function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = {}

		for iter_12_0, iter_12_1 in arg_11_0.bottomData:ipairs() do
			for iter_12_2, iter_12_3 in ipairs(iter_12_1:proxy().components) do
				local var_12_1 = csv.explorer.component[iter_12_3.id]
				local var_12_2 = iter_12_3.level

				if arg_12_1[iter_12_0] and arg_12_1[iter_12_0].components[iter_12_3.id] then
					local var_12_3 = arg_12_1[iter_12_0].components[iter_12_3.id]

					iter_12_1:proxy().components[iter_12_2].level = var_12_3
				end

				iter_12_1:proxy().components[iter_12_2].count = arg_12_2[var_12_1.itemID] or 0

				table.insert(var_12_0, {
					id = iter_12_3.id,
					count = arg_12_2[var_12_1.itemID] or 0
				})
			end

			if arg_12_1[iter_12_1:proxy().id] and arg_12_1[iter_12_1:proxy().id].advance then
				iter_12_1:proxy().advance = arg_12_1[iter_12_1:proxy().id].advance or 0
			end
		end

		arg_11_0.components:set(var_12_0)
		arg_11_0.showTab:set(arg_11_0.showTab:read(), true)
	end)
	arg_11_0.showTab:addListener(function(arg_13_0, arg_13_1)
		arg_11_0.bottomData:atproxy(arg_13_1).selected = false
		arg_11_0.bottomData:atproxy(arg_13_0).selected = true

		local var_13_0 = arg_11_0.bottomData:atproxy(arg_13_0)

		if arg_11_0.upLeftPanel:get("explorer") then
			arg_11_0.upLeftPanel:removeChildByName("explorer")
		end

		arg_11_0:getResourceNode():removeChildByName("bgEffect")

		local var_13_1 = var_13_0.advance == 0

		if string.find(var_13_0.cfg.res, "skel") then
			arg_11_0.icon:hide()
			arg_11_0.iconName:hide()

			local var_13_2 = widget.addAnimationByKey(arg_11_0.upLeftPanel, var_13_0.cfg.res, "explorer", "effect_loop", 2)

			if var_13_0.cfg.coordinate then
				var_13_2:xy(var_13_0.cfg.coordinate.x or 700, var_13_0.cfg.coordinate.y or 500):scale(var_13_0.cfg.coordinate.scale or 2.5)
			else
				var_13_2:xy(700, 500):scale(2.5)
			end

			var_13_2:setTimeScale(var_13_1 and 0 or 1)
			cache.setShader(var_13_2, false, var_13_1 and "gray" or "normal")
		else
			arg_11_0.icon:show()
			arg_11_0.iconName:show()

			if var_13_0.advance == 0 then
				arg_11_0.iconName:text(var_13_0.cfg.name)
			else
				arg_11_0.iconName:text(var_13_0.cfg.name .. string.format(" +%d", var_13_0.advance))
			end

			text.addEffect(arg_11_0.iconName, {
				outline = {
					size = 1,
					color = ui.COLORS.QUALITY[var_13_0.cfg.quality]
				},
				color = ui.COLORS.OUTLINE.WHITE
			})
			arg_11_0.icon:texture(var_13_0.cfg.res)
		end

		local var_13_3 = var_0_2.getMinComponentLevel(var_13_0.components)

		if var_13_1 then
			arg_11_0.nodeName:text(var_13_0.cfg.name)
			arg_11_0.btnLeft:get("mask"):visible(var_13_3 == 0)
			arg_11_0.btnRight:get("txt"):text(gLanguageCsv.spaceActive)

			if var_13_3 == 0 then
				arg_11_0.btnLeft:get("txt"):text(gLanguageCsv.notActivatedTip)
				text.deleteAllEffect(arg_11_0.btnLeft:get("txt"))
				text.addEffect(arg_11_0.btnLeft:get("txt"), {
					color = ui.COLORS.NORMAL.WHITE
				})
			else
				arg_11_0.btnLeft:get("txt"):text(gLanguageCsv.canActive)
				text.addEffect(arg_11_0.btnLeft:get("txt"), {
					glow = {
						color = ui.COLORS.GLOW.WHITE
					}
				})
				text.addEffect(arg_11_0.btnLeft:get("txt"), {
					color = ui.COLORS.NORMAL.WHITE
				})
			end

			adapt.setTextScaleWithWidth(arg_11_0.btnLeft:get("txt"), nil, 180)
		else
			arg_11_0.btnLeft:get("mask"):hide()
			arg_11_0.btnRight:get("txt"):text(gLanguageCsv.spaceAdvance)
			arg_11_0.nodeName:text(var_13_0.cfg.name .. string.format(" +%d", var_13_0.advance))
			text.addEffect(arg_11_0.btnLeft:get("txt"), {
				color = ui.COLORS.NORMAL.WHITE
			})
		end

		text.addEffect(arg_11_0.nodeName, {
			color = ui.COLORS.QUALITY[var_13_0.cfg.quality]
		})
		adapt.setTextAdaptWithSize(arg_11_0.activeTip, {
			vertical = "bottom",
			horizontal = "center",
			size = cc.size(650, 80)
		})

		local var_13_4 = false

		if var_13_1 and var_13_3 == 0 then
			arg_11_0.activeTip:text(gLanguageCsv.collectAllComponentsCanActive)

			var_13_4 = true
		elseif var_13_3 <= var_13_0.advance then
			arg_11_0.activeTip:text(string.format(gLanguageCsv.allComponentsNeedLevelCondition, var_13_0.advance + 1))

			var_13_4 = true
		end

		adapt.setTextAdaptWithSize(arg_11_0.activeTip, {
			vertical = "bottom",
			horizontal = "center",
			size = cc.size(650, 80)
		})
		arg_11_0.activeTip:setAnchorPoint(0.5, 0.5)

		local var_13_5 = var_13_0.advance == var_13_0.cfg.levelMax
		local var_13_6 = true

		if not var_13_5 then
			for iter_13_0, iter_13_1 in csvMapPairs(csv.explorer.explorer_advance[var_13_0.advance + 1]["costItemMap" .. var_13_0.cfg.advanceCostSeq]) do
				var_13_6 = var_13_6 and iter_13_1 <= dataEasy.getNumByKey(iter_13_0)
			end
		end

		arg_11_0.activeTip:visible(var_13_4 and not var_13_5)
		arg_11_0.maxPanel:visible(var_13_5)
		arg_11_0.btnRight:visible(not var_13_5)
		arg_11_0.btnLeft:visible(var_13_1 and var_13_3 == 0)
		arg_11_0.btnEffect:visible(var_13_1 and var_13_3 > 0 and var_13_6)
		arg_11_0.kejihuoEffect:play("kejihuo_loop")
		arg_11_0:setComponentPanel(var_13_0.advance)
		var_0_2.effectShow(arg_11_0.upList, arg_11_0.downList, var_13_0)

		if not var_13_1 and not var_13_4 and not var_13_5 and var_13_6 then
			arg_11_0.btnEffect:visible(true)
			arg_11_0.kejihuoEffect:play("kejinjie_loop")
		end
	end)

	arg_11_0.componentData = idlertable.new({})
	arg_11_0.upgradeData = idlertable.new({})
end

function var_0_1.onCleanup(arg_14_0)
	arg_14_0._showTab = arg_14_0.showTab:read()

	var_0_0.onCleanup(arg_14_0)
end

function var_0_1.setComponentPanel(arg_15_0, arg_15_1)
	for iter_15_0 = 1, 6 do
		if arg_15_0.componentPanel:get(iter_15_0) then
			arg_15_0.componentPanel:get(iter_15_0):hide()
		end
	end

	arg_15_0.linePanel:removeAllChildren()

	local var_15_0 = arg_15_0.bottomData:atproxy(arg_15_0.showTab:read())

	for iter_15_1, iter_15_2 in ipairs(var_15_0.components) do
		local var_15_1 = csv.explorer.component[iter_15_2.id]
		local var_15_2 = arg_15_0:initComponent(iter_15_1, iter_15_2, var_15_0.cfg.levelMax, arg_15_1):xy(var_15_1.coordinate.x, var_15_1.coordinate.y):show():anchorPoint(0.5, 0.5):setTouchEnabled(true)

		bind.touch(arg_15_0, var_15_2, {
			methods = {
				ended = function()
					if iter_15_2.count > 0 and iter_15_2.level == 0 then
						gGameApp:requestServer("/game/explorer/component/strength", function(arg_17_0)
							gGameUI:stackUI("city.develop.explorer.component_success", nil, {
								clickClose = true,
								blackLayer = true
							}, iter_15_2)
						end, iter_15_2.id)
					else
						arg_15_0:componentDetailShow(iter_15_1, iter_15_2, var_15_0.cfg, arg_15_1)
						arg_15_0.mask:show()
					end
				end
			}
		})
	end
end

function var_0_1.detailSendParams(arg_18_0)
	return (arg_18_0.bottomData:atproxy(arg_18_0.showTab:read()))
end

function var_0_1.componentDetailShow(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	arg_19_0.componentDetailPanel:show()

	local var_19_0 = arg_19_0.componentDetailPanel:get("itemPos")
	local var_19_1 = csv.explorer.component[arg_19_2.id]
	local var_19_2 = csv.items[var_19_1.itemID]
	local var_19_3 = string.format("city/card/helditem/panel_icon_%d.png", var_19_2.quality)
	local var_19_4 = var_19_0:size()

	;(var_19_0:get("bg") or ccui.ImageView:create():alignCenter(var_19_4):addTo(var_19_0, 1, "bg")):texture(var_19_3)
	;(var_19_0:get("icon") or ccui.ImageView:create():alignCenter(var_19_4):scale(2):addTo(var_19_0, 2, "icon")):texture(var_19_2.icon)
	var_19_0:scale(1.2)

	local var_19_5 = gLanguageCsv.attributeAdd
	local var_19_6

	if var_19_1.attrTarget and csvSize(var_19_1.attrTarget) > 0 then
		local var_19_7 = {}

		for iter_19_0, iter_19_1 in ipairs(var_19_1.attrTarget) do
			table.insert(var_19_7, "#I" .. ui.ATTR_ICON[iter_19_1] .. "-60-60#")
		end

		local var_19_8 = table.concat(var_19_7)

		var_19_6 = string.format(var_19_5, var_19_8)
	else
		var_19_6 = string.format(var_19_5, gLanguageCsv.allTeamActive)
	end

	local var_19_9 = {}

	for iter_19_2 = 1, 10 do
		if var_19_1["attrNumType" .. iter_19_2] and var_19_1["attrNumType" .. iter_19_2] ~= 0 then
			table.insert(var_19_9, {
				attrType = var_19_1["attrNumType" .. iter_19_2],
				attrNum = var_19_1["attrNum" .. iter_19_2],
				level = arg_19_2.level or 0
			})
		else
			break
		end
	end

	arg_19_0.componentData:set(var_19_9)

	if arg_19_2.level == 0 then
		arg_19_0.otherPanel:show()

		local var_19_10 = arg_19_0.otherPanel:multiget("name", "nameMax", "txtPos", "maxPanel", "noCom", "btnPath")

		itertools.invoke({
			arg_19_0.upgradePanel,
			var_19_10.nameMax,
			var_19_10.maxPanel
		}, "hide")

		local var_19_11 = uiEasy.setIconName(var_19_1.itemID, nil, {
			node = var_19_10.name
		})

		var_19_10.txtPos:removeAllChildren()
		var_19_10.noCom:visible(arg_19_2.count == 0)

		if arg_19_2.count == 0 then
			local var_19_12 = rich.createByStr(var_19_6, 40, nil, nil, cc.p(0, 0.5))

			var_19_12:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			var_19_12:addTo(var_19_10.txtPos):alignCenter(var_19_10.txtPos:size())
			bind.touch(arg_19_0, var_19_10.btnPath, {
				methods = {
					ended = function()
						gGameUI:stackUI("common.gain_way", nil, nil, var_19_1.itemID)
					end
				}
			})
			var_19_10.btnPath:show()
			text.addEffect(var_19_10.btnPath:get("txt"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	elseif arg_19_2.level == arg_19_3.levelMax then
		arg_19_0.otherPanel:show()

		local var_19_13 = arg_19_0.otherPanel:multiget("name", "nameMax", "txtPos", "noCom", "btnPath")

		var_19_13.txtPos:removeAllChildren()
		arg_19_0.upgradePanel:hide()
		var_19_13.name:hide()

		local var_19_14 = uiEasy.setIconName(var_19_1.itemID, nil, {
			node = var_19_13.nameMax:get("name")
		})

		var_19_13.nameMax:get("level"):text("Lv" .. arg_19_2.level)
		adapt.oneLineCenterPos(cc.p(270, 40), {
			var_19_13.nameMax:get("name"),
			var_19_13.nameMax:get("level")
		}, cc.p(15, 0))
		var_19_13.noCom:hide()
		var_19_13.btnPath:hide()

		local var_19_15 = rich.createByStr(var_19_6, 40, nil, nil, cc.p(0, 0.5))

		var_19_15:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		var_19_15:addTo(var_19_13.txtPos):alignCenter(var_19_13.txtPos:size())
	else
		arg_19_0.otherPanel:hide()
		arg_19_0.upgradePanel:show()

		local var_19_16 = arg_19_0.upgradePanel:multiget("name", "txtPos", "btnPath", "level")

		var_19_16.txtPos:removeAllChildren()

		local var_19_17 = uiEasy.setIconName(var_19_1.itemID, nil, {
			node = var_19_16.name
		})

		var_19_16.level:text("Lv" .. arg_19_2.level)
		adapt.setTextScaleWithWidth(var_19_16.name, nil, 555)
		adapt.oneLineCenterPos(cc.p(arg_19_0.upgradePanel:width() / 2, var_19_16.name:y()), {
			var_19_16.name,
			var_19_16.level
		}, cc.p(20, 0))

		local var_19_18 = rich.createByStr(var_19_6, 40, nil, nil, cc.p(0, 0.5))

		var_19_18:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		var_19_18:addTo(var_19_16.txtPos):alignCenter(var_19_16.txtPos:size())

		local var_19_19 = {}
		local var_19_20 = true

		for iter_19_3, iter_19_4 in csvMapPairs(csv.explorer.component_level[arg_19_2.level + 1]["costItemMap" .. var_19_1.strengthCostSeq]) do
			table.insert(var_19_19, {
				key = iter_19_3,
				id = iter_19_3,
				targetNum = iter_19_4,
				num = dataEasy.getNumByKey(iter_19_3)
			})

			var_19_20 = var_19_20 and iter_19_4 <= dataEasy.getNumByKey(iter_19_3)
		end

		text.deleteAllEffect(var_19_16.btnPath:get("txt"))
		text.addEffect(var_19_16.btnPath:get("txt"), {
			color = var_19_20 and ui.COLORS.NORMAL.YELLOW or ui.COLORS.NORMAL.YELLOW
		})
		text.addEffect(var_19_16.btnPath:get("txt"), {
			outline = {
				size = 1,
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
		arg_19_0.upgradeData:set(var_19_19)
		bind.touch(arg_19_0, var_19_16.btnPath, {
			methods = {
				ended = function()
					if var_19_20 then
						gGameApp:requestServer("/game/explorer/component/strength", function(arg_22_0)
							local var_22_0 = arg_19_0.bottomData:atproxy(arg_19_0.showTab:read())

							arg_19_0:componentDetailShow(arg_19_1, var_22_0.components[arg_19_1], var_22_0.cfg, arg_19_4)
							gGameUI:stackUI("city.develop.explorer.component_success", nil, {
								clickClose = true,
								blackLayer = true
							}, var_22_0.components[arg_19_1])
						end, arg_19_2.id)
					else
						gGameUI:showTip(gLanguageCsv.inadequateProps)
					end
				end
			}
		})
	end
end

local function var_0_5(arg_23_0, arg_23_1)
	return cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.MoveTo:create(0.3, cc.p(arg_23_0, arg_23_1 + 10)), cc.DelayTime:create(0.1), cc.MoveTo:create(0.3, cc.p(arg_23_0, arg_23_1))))
end

function var_0_1.initComponent(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0
	local var_24_1
	local var_24_2
	local var_24_3
	local var_24_4
	local var_24_5

	if not arg_24_0.componentPanel:get(arg_24_1) then
		local var_24_6 = cc.size(198, 198)

		var_24_0 = ccui.Layout:create():size(198, 198):addTo(arg_24_0.componentPanel, 1, arg_24_1)
		var_24_1 = ccui.ImageView:create(ui.QUALITY_BOX[1]):alignCenter(var_24_6):addTo(var_24_0, 1, "bg")

		local var_24_7 = ccui.ImageView:create("common/box/box_selected.png"):alignCenter(var_24_6):visible(false):addTo(var_24_0, -1, "imgSel")

		var_24_3 = ccui.ImageView:create("common/icon/icon_up.png"):alignCenter(var_24_6):xy(170, 40):scale(0.8):visible(true):addTo(var_24_0, 5, "imgArrow")

		local var_24_8 = ccui.ImageView:create():xy(30, 99):addTo(var_24_0, 3, "frame")

		var_24_5 = ccui.ImageView:create():alignCenter(var_24_6):scale(2):addTo(var_24_0, 2, "icon")
	else
		var_24_0 = arg_24_0.componentPanel:get(arg_24_1)
		var_24_1 = var_24_0:get("bg")

		local var_24_9 = var_24_0:get("imgSel")

		var_24_3 = var_24_0:get("imgArrow")
		var_24_5 = var_24_0:get("icon")

		local var_24_10 = var_24_0:get("frame")
	end

	var_24_0:show()

	local var_24_11 = var_24_0:size()
	local var_24_12 = var_24_0:get("txtLv")

	if not var_24_12 then
		var_24_12 = cc.Label:createWithTTF("Lv", ui.FONT_PATH, 30):align(cc.p(1, 0), 150, 10):addTo(var_24_0, 2, "txtLv")

		text.addEffect(var_24_12, {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
	end

	local var_24_13 = var_24_0:get("txtLvNum")

	if not var_24_13 then
		var_24_13 = cc.Label:createWithTTF("", ui.FONT_PATH, 30):align(cc.p(1, 0), 160, 10):addTo(var_24_0, 2, "txtLvNum")

		text.addEffect(var_24_13, {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
	end

	local var_24_14 = csv.explorer.component[arg_24_2.id]
	local var_24_15 = csv.items[var_24_14.itemID]
	local var_24_16 = string.format("city/card/helditem/panel_icon_%d.png", var_24_15.quality)

	var_24_1:texture(var_24_16)
	var_24_5:texture(var_24_15.icon)

	local var_24_17 = var_24_0:get("txtNoGain")

	if not var_24_17 then
		var_24_17 = cc.Label:createWithTTF(gLanguageCsv.noGet, ui.FONT_PATH, 40):align(cc.p(0.5, 0), 98, 10):addTo(var_24_0, 7, "txtNoGain")

		text.addEffect(var_24_17, {
			outline = {
				color = ui.COLORS.NORMAL.YELLOW
			}
		})
	end

	local var_24_18 = var_24_0:get("imgCanActive") or ccui.ImageView:create("city/develop/explore/txt_kjh.png"):alignCenter(var_24_11):xy(100, 40):addTo(var_24_0, 7, "imgCanActive")

	var_24_17:hide()
	var_24_18:hide()
	var_24_0:get("txtLvNum"):text(arg_24_2.level)

	if arg_24_2.level == 0 then
		itertools.invoke({
			var_24_12,
			var_24_13,
			var_24_3
		}, "hide")

		if arg_24_2.count > 0 then
			var_24_18:show()
		else
			var_24_17:show()
		end

		cache.setShader(var_24_5, false, "gray")
	else
		itertools.invoke({
			var_24_12,
			var_24_13
		}, "show")

		local var_24_19 = true

		if arg_24_3 == arg_24_2.level then
			var_24_19 = false

			var_24_0:get("txtLvNum"):text(arg_24_2.level .. " Max")
		else
			for iter_24_0, iter_24_1 in csvMapPairs(csv.explorer.component_level[arg_24_2.level + 1]["costItemMap" .. var_24_14.strengthCostSeq]) do
				if iter_24_1 > dataEasy.getNumByKey(iter_24_0) then
					var_24_19 = false

					break
				end
			end
		end

		var_24_3:visible(var_24_19)

		var_24_0.action = var_24_0.action or var_0_5(170, 40)

		var_24_3:stopAction(var_24_0.action)

		if var_24_19 then
			var_24_0.action = var_0_5(170, 40)

			var_24_3:runAction(var_24_0.action)
		end

		cache.setShader(var_24_5, false, "normal")
	end

	if arg_24_2.level == arg_24_3 then
		adapt.oneLineCenterPos(cc.p(100, 0), {
			var_24_12,
			var_24_13
		}, cc.p(0, 0))
	else
		adapt.oneLinePos(var_24_3, {
			var_24_13,
			var_24_12
		}, nil, "right")
	end

	return var_24_0
end

function var_0_1.onDecomposeClick(arg_25_0)
	gGameUI:stackUI("city.develop.explorer.decompose", nil, nil, arg_25_0:createHandler("sendParams"))
end

function var_0_1.initModel(arg_26_0)
	arg_26_0.explores = gGameModel.role:getIdler("explorers")
	arg_26_0.items = gGameModel.role:getIdler("items")
end

function var_0_1.sendParams(arg_27_0)
	return arg_27_0.components
end

function var_0_1.onItemClick(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	arg_28_0.showTab:set(arg_28_2)
end

function var_0_1.onMaskClick(arg_29_0)
	arg_29_0.mask:hide()
	arg_29_0.componentDetailPanel:hide()
end

function var_0_1.onItemMaskClick(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_30_3.id, nil, arg_30_3.targetNum)
end

function var_0_1.onBtnRightClick(arg_31_0)
	gGameUI:stackUI("city.develop.explorer.detail", nil, nil, arg_31_0:createHandler("detailSendParams"))
end

function var_0_1.onFindClick(arg_32_0)
	gGameUI:stackUI("city.develop.explorer.draw_item.view", nil, nil)
end

function var_0_1.onRuleClick(arg_33_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_33_0:createHandler("getRuleContext"), {
		width = 1150
	})
end

function var_0_1.getRuleContext(arg_34_0, arg_34_1)
	local var_34_0 = adaptContext

	return {
		var_34_0.clone(arg_34_1.title, function(arg_35_0)
			arg_35_0:get("text"):text(gLanguageCsv.explorer)
		end),
		var_34_0.noteText(67001, 67007)
	}
end

function var_0_1.onShopClick(arg_36_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/explorer/shop/get", function()
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.EXPLORER_SHOP)
		end)
	end
end

function var_0_1.onList1AfterBuild(arg_38_0)
	local var_38_0 = var_0_4
	local var_38_1 = arg_38_0.item1:width()
	local var_38_2 = arg_38_0.upgradeData:size()

	arg_38_0.list1:width(var_38_1 * var_38_2 + var_38_0 * (var_38_2 - 1))
	arg_38_0.list1:x(arg_38_0.upgradePanel:width() / 2 - arg_38_0.list1:width() / 2)
end

return var_0_1
