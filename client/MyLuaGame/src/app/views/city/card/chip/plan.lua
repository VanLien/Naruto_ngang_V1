local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.chip.bag")
local var_0_2 = class("ChipPlanView", var_0_1)
local var_0_3 = require("app.views.city.card.chip.tools")
local var_0_4 = var_0_1.ATTR_FILTER_TYPE

var_0_2.RESOURCE_FILENAME = "chip_plan.json"
var_0_2.RESOURCE_BINDING = clone(var_0_1.RESOURCE_BINDING)

local var_0_5 = {
	["right.btnEditPanel"] = "planBtnEditPanel",
	["leftPlan.subList"] = "planSubList",
	["planOrderPanel.panel.subList"] = "planOrderSubList",
	["leftPlan.item"] = "planItem",
	["right.btnSavePanel"] = "planBtnSavePanel",
	planSuitFilterPanel = "planSuitFilterPanel",
	["planSuitFilterPanel.panel.item"] = "planSuitFilterItem",
	planOrderPanel = "planOrderPanel",
	["planOrderPanel.panel.item"] = "planOrderItem",
	leftPlan = "leftPlan",
	["leftPlan.empty"] = "planEmpty",
	["right.btnEquipPanel"] = "planBtnEquipPanel",
	["right.btnNewPanel"] = "planBtnNewPanel",
	["planSuitFilterPanel.panel.subList"] = "planSuitFilterSubList",
	["left.btnEquip"] = {
		varname = "btnEquipShow",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEquipShowClick")
			}
		}
	},
	["leftPlan.btnNewPlan"] = {
		varname = "btnLeftPlanNew",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLeftPlanNewClick")
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
					onNode = function(arg_1_0)
						arg_1_0:xy(95, 95):scale(0.66)
					end
				}
			}
		}
	},
	["leftPlan.btnNewPlan.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["leftPlan.btnSuitFilter"] = {
		varname = "btnPlanSuitFilter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanSuitFilterClick")
			}
		}
	},
	["leftPlan.btnOrder"] = {
		varname = "btnPlanOrder",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanOrderClick")
			}
		}
	},
	["leftPlan.btnSuitFilter.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["leftPlan.btnOrder.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	},
	["leftPlan.list"] = {
		varname = "planList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				asyncPreload = 12,
				data = bindHelper.self("planData"),
				item = bindHelper.self("planSubList"),
				cell = bindHelper.self("planItem"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("bg", "icon", "name", "curName", "newName", "inEquip", "chipPanel", "equipPanel", "inEquipPanel")

					itertools.invoke(var_2_0, "hide")

					local var_2_1 = arg_2_3.data or {}

					if arg_2_3.suitId then
						var_2_0.icon:show():texture(var_0_3.getSuitRes(arg_2_3.suitId)):scale(0.9)
					else
						var_2_0.chipPanel:show()
						var_2_0.chipPanel:get("add"):visible(arg_2_3.addNew and not arg_2_3.id or false)

						for iter_2_0 = 1, 6 do
							local var_2_2 = var_2_0.chipPanel:get("chip" .. iter_2_0)

							if var_2_1.chips and var_2_1.chips[iter_2_0] then
								local var_2_3 = gGameModel.chips:find(var_2_1.chips[iter_2_0])
								local var_2_4 = csv.chip.chips[var_2_3:read("chip_id")]

								var_2_2:show():texture(string.format("city/card/chip/img_dw_%d.png", var_2_4.quality))
							else
								var_2_2:hide()
							end
						end
					end

					if var_2_1.name then
						var_2_0.name:show():text(var_2_1.name)
					elseif arg_2_3.addNew then
						var_2_0.newName:show()
					else
						var_2_0.curName:show()
					end

					var_2_0.inEquip:hide()
					arg_2_1:removeChildByName("inEquipRich")

					if arg_2_3.cardDBID ~= nil then
						local var_2_5 = uiEasy.getCardName(arg_2_3.cardDBID)

						rich.createWithWidth("#C0x5B545B#" .. gLanguageCsv.chipInEquip .. var_2_5, 26, nil, 300):addTo(arg_2_1, 5, "inEquipRich"):anchorPoint(0, 0.5):xy(var_2_0.inEquip:xy())
					end

					local var_2_6 = arg_2_0.selectPlanId()

					idlereasy.when(var_2_6, function(arg_3_0, arg_3_1)
						if not tolua.isnull(var_2_0.bg) then
							var_2_0.bg:show()

							if not arg_2_3.addNew and arg_3_1 == arg_2_3.id then
								var_2_0.bg:texture("city/card/chip/panel_sl.png")
							else
								var_2_0.bg:texture("city/card/chip/panel_up.png")
							end
						end
					end):anonyOnly(arg_2_0, arg_2_3.id)

					if arg_2_3.addNew then
						bind.touch(arg_2_0, arg_2_1, {
							methods = {
								ended = functools.partial(arg_2_0.itemNewClick, arg_2_1, arg_2_2, arg_2_3)
							}
						})
					else
						if arg_2_3.curCard then
							var_2_0.inEquipPanel:show()
						else
							var_2_0.equipPanel:show()
						end

						bind.touch(arg_2_0, arg_2_1, {
							methods = {
								ended = functools.partial(arg_2_0.itemClick, arg_2_1, arg_2_2, arg_2_3)
							}
						})
						bind.touch(arg_2_0, var_2_0.equipPanel, {
							methods = {
								ended = functools.partial(arg_2_0.equipClick, arg_2_1, arg_2_2, arg_2_3)
							}
						})
					end
				end
			},
			handlers = {
				itemNewClick = bindHelper.self("onPlanItemNewClick"),
				itemClick = bindHelper.self("onPlanItemClick"),
				equipClick = bindHelper.self("onPlanItemEquipClick"),
				selectPlanId = bindHelper.self("selectPlanId")
			}
		}
	},
	["right.namePanel"] = {
		varname = "planNamePanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanNameClick")
			}
		}
	},
	["right.btnNewPanel.btnNew"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRightPlanNewClick")
			}
		}
	},
	["right.btnNewPanel.btnNew.txt"] = {
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
	["right.btnSavePanel.btnSave"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanSaveClick")
			}
		}
	},
	["right.btnSavePanel.btnSave.txt"] = {
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
	["right.btnEditPanel.btnDelete"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanDeleteClick")
			}
		}
	},
	["right.btnEditPanel.btnTop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanTopClick")
			}
		}
	},
	["right.btnEditPanel.btnEdit"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanEditClick")
			}
		}
	},
	["right.btnEditPanel.btnEdit.txt"] = {
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
	["right.btnEditPanel.btnDelete.txt"] = {
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
	["right.btnEditPanel.btnTop.txt"] = {
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
	["right.btnEquipPanel.btnDelete"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanDeleteClick")
			}
		}
	},
	["right.btnEquipPanel.btnTop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanTopClick")
			}
		}
	},
	["right.btnEquipPanel.btnDelete.txt"] = {
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
	["right.btnEquipPanel.btnTop.txt"] = {
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
	["right.btnEquipPanel.btnEdit"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanEditClick")
			}
		}
	},
	["right.btnEquipPanel.btnEdit.txt"] = {
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
	["right.btnEquipPanel.btnEquip"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlanEquipClick")
			}
		}
	},
	["right.btnEquipPanel.btnEquip.txt"] = {
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
	["suitFilterPanel.panel.btnAll.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["planSuitFilterPanel.panel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("planSuitFilterData"),
				item = bindHelper.self("planSuitFilterSubList"),
				cell = bindHelper.self("planSuitFilterItem"),
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("bg"):visible(arg_4_3.selected ~= true)
					arg_4_1:get("bgSelected"):visible(arg_4_3.selected == true)

					local var_4_0
					local var_4_1
					local var_4_2 = 1

					if arg_4_3.suitId == -1 then
						var_4_0 = "city/card/chip/icon_qb.png"
						var_4_1 = gLanguageCsv.all
					elseif arg_4_3.suitId == 0 then
						var_4_0 = "city/card/chip/icon_wtz.png"
						var_4_1 = gLanguageCsv.noSuit
					else
						var_4_0 = arg_4_3.cfg.suitIcon
						var_4_1 = arg_4_3.cfg.suitName
						var_4_2 = 0.9
					end

					arg_4_1:get("icon"):texture(var_4_0):scale(var_4_2)
					arg_4_1:get("name"):text(var_4_1)
					arg_4_1:get("count"):text(gLanguageCsv.have .. ": " .. arg_4_3.count)
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.itemClick, arg_4_1, arg_4_2, arg_4_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onPlanSuitFilterItemClick")
			}
		}
	},
	["planOrderPanel.panel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				data = bindHelper.self("planOrderData"),
				item = bindHelper.self("planOrderSubList"),
				cell = bindHelper.self("planOrderItem"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					adapt.setTextScaleWithWidth(arg_5_1:get("name"), arg_5_3.name, 240)

					if arg_5_3.selected then
						arg_5_1:get("icon"):texture("city/card/chip/btn_r.png")
						text.addEffect(arg_5_1:get("name"), {
							color = ui.NEWCOLORS.ORANGE
						})
					else
						arg_5_1:get("icon"):texture("city/card/chip/btn_w.png")
						text.addEffect(arg_5_1:get("name"), {
							color = ui.NEWCOLORS.BROWN2
						})
					end

					bind.touch(arg_5_0, arg_5_1, {
						methods = {
							ended = functools.partial(arg_5_0.itemClick, arg_5_1, arg_5_0:getIdx(arg_5_2), arg_5_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onPlanOrderItemClick")
			}
		}
	},
	["right.chipPanel"] = {
		varname = "chipPanel",
		binds = {
			event = "extend",
			class = "chips_panel",
			props = {
				panelIdx = 2,
				showSuitEffect = true,
				data = bindHelper.self("curChipPlan"),
				slotFlags = bindHelper.self("slotFlags"),
				selected = bindHelper.self("selectRightPos"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					if arg_6_3 then
						arg_6_1:get("defaultLv"):y(0)
					end
				end
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
					local var_7_0 = arg_7_1:multiget("icon", "text", "val", "up1", "upVal", "upIcon", "up2")

					var_7_0.icon:texture(ui.ATTR_LOGO[arg_7_3.attr])
					var_7_0.text:text(getLanguageAttr(arg_7_3.key))

					if type(arg_7_3.val) == "table" then
						itertools.invoke({
							var_7_0.up1,
							var_7_0.upVal,
							var_7_0.upIcon,
							var_7_0.up2
						}, "show")
						var_7_0.val:text(arg_7_3.val[1])
						var_7_0.upVal:text(arg_7_3.val[4])

						if arg_7_3.val[3] == 0 then
							var_7_0.upIcon:hide()
							text.addEffect(var_7_0.upVal, {
								color = cc.c4b(183, 176, 158, 255)
							})
						elseif arg_7_3.val[3] > 0 then
							var_7_0.upIcon:texture("common/icon/logo_arrow_green.png")
							text.addEffect(var_7_0.upVal, {
								color = ui.COLORS.NORMAL.FRIEND_GREEN
							})
						else
							var_7_0.upIcon:texture("common/icon/logo_arrow_red.png")
							text.addEffect(var_7_0.upVal, {
								color = ui.COLORS.NORMAL.ALERT_ORANGE
							})
						end

						adapt.oneLinePos(var_7_0.up1, {
							var_7_0.upVal,
							var_7_0.upIcon,
							var_7_0.up2
						})
					else
						itertools.invoke({
							var_7_0.up1,
							var_7_0.upVal,
							var_7_0.upIcon,
							var_7_0.up2
						}, "hide")
						var_7_0.val:text("+" .. arg_7_3.val)
					end
				end
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
	}
}

table.merge(var_0_2.RESOURCE_BINDING, var_0_5)

var_0_2.RESOURCE_STYLES = {
	full = true
}

function var_0_2.onCreate(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or {}
	arg_8_1.itemWidthExtra = 40
	arg_8_0.page = arg_8_1.page or 1
	arg_8_0.selectPlanId = idler.new()
	arg_8_0.curChipPlan = idlereasy.new({})
	arg_8_0.planData = idlers.newWithMap({})
	arg_8_0.planSuitFilterData = idlers.newWithMap({})
	arg_8_0.planOrderData = idlers.newWithMap({})
	arg_8_0.showCard = idler.new(false)

	var_0_1.onCreate(arg_8_0, arg_8_1)

	local var_8_0 = "common/txt/txt_bt_mijifangan.png"
	local var_8_1 = "CHIP PLAN"

	if arg_8_0.page == 2 then
		var_8_0 = "common/txt/txt_bt_mijifangan.png"
		var_8_1 = "CHIP PLAN BAG"
	end

	arg_8_0.topuiView:updateTitle(var_8_0, var_8_1)
	arg_8_0.right:stopAllActions()
	arg_8_0.right:x(arg_8_0.originRightPos.x)

	arg_8_0.midColumnSize = arg_8_0.midColumnSize + 1
	arg_8_0.asyncPreload = arg_8_0.midColumnSize * 5

	local var_8_2 = cc.p(arg_8_0.leftPlan:xy())

	arg_8_0.leftPlan:x(var_8_2.x - arg_8_0.leftPlan:width() - 100)
	arg_8_0.leftPlan:runAction(cc.MoveTo:create(0.4, var_8_2))
	arg_8_0.left:visible(arg_8_0.page == 2)
	arg_8_0.leftPlan:visible(arg_8_0.page == 1)
	adapt.dockWithScreen(arg_8_0.leftPlan, "left")
	adapt.dockWithScreen(arg_8_0.planSuitFilterPanel:get("panel"), "left")
	adapt.dockWithScreen(arg_8_0.planOrderPanel:get("panel"), "left")

	arg_8_0.chipPlans = gGameModel.role:getIdler("chip_plans")

	arg_8_0.selectPlanId:set(arg_8_1.planId)

	if arg_8_0.page == 2 then
		local var_8_3 = arg_8_0.chipPlans:read()
		local var_8_4 = arg_8_0.selectPlanId:read()

		arg_8_0.curChipPlan:set(table.deepcopy(var_8_3[var_8_4] and var_8_3[var_8_4].chips or {}, true))
	end

	idlereasy.any({
		arg_8_0.selectPlanId,
		arg_8_0.cardChips,
		arg_8_0.chipPlans,
		arg_8_0.isRefreshBagPanel
	}, function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		arg_8_0:setPlanName()
		itertools.invoke({
			arg_8_0.planBtnNewPanel,
			arg_8_0.planBtnSavePanel,
			arg_8_0.planBtnEditPanel,
			arg_8_0.planBtnEquipPanel
		}, "hide")

		local var_9_0 = false

		if arg_8_0.page == 2 then
			arg_8_0.planBtnSavePanel:show()
		elseif not arg_9_1 then
			var_9_0 = true

			arg_8_0.curChipPlan:set(table.deepcopy(arg_9_2, true))
			arg_8_0.planBtnNewPanel:show()
		else
			arg_8_0.curChipPlan:set(table.deepcopy(arg_9_3[arg_9_1] and arg_9_3[arg_9_1].chips or {}, true))

			if arg_8_0.cardChipsPlanId == arg_9_1 then
				var_9_0 = true

				arg_8_0.planBtnEditPanel:show()
			else
				arg_8_0.planBtnEquipPanel:show()
			end
		end

		arg_8_0.showCard:set(var_9_0, true)
	end)

	arg_8_0.curChipPlanIdler_ = {}

	idlereasy.when(arg_8_0.showCard, function()
		for iter_10_0, iter_10_1 in pairs(arg_8_0.curChipPlanIdler_) do
			iter_10_1:destroy()
		end

		arg_8_0.curChipPlanIdler_ = {}

		local var_10_0 = arg_8_0.curChipPlan:read()

		for iter_10_2 = 1, 6 do
			local var_10_1 = var_10_0[iter_10_2]

			if var_10_1 then
				local var_10_2 = gGameModel.chips:find(var_10_1):multigetIdler("level", "now")

				arg_8_0.curChipPlanIdler_[var_10_1] = idlereasy.any(var_10_2, function()
					arg_8_0:showPanel()
				end, true):anonyOnly(arg_8_0, stringz.bintohex(var_10_1))
			end
		end

		arg_8_0:showPanel()
	end)
	arg_8_0.planSuitFilterPanel:hide()
	bind.click(arg_8_0, arg_8_0.planSuitFilterPanel, {
		method = function()
			arg_8_0.planSuitFilterPanel:hide()
			arg_8_0.btnPlanSuitFilter:get("arrow"):setFlippedY(false)
		end
	})

	arg_8_0.selectPlanSuitId = idler.new(-1)

	idlereasy.when(arg_8_0.selectPlanSuitId, function(arg_13_0, arg_13_1)
		arg_8_0.planList:jumpToTop()
		arg_8_0.planSuitFilterPanel:hide()
		arg_8_0.btnPlanSuitFilter:get("arrow"):setFlippedY(false)

		local var_13_0 = gLanguageCsv.chipPlanSuitFilter

		if arg_13_1 == 0 then
			var_13_0 = gLanguageCsv.noSuit
		elseif arg_13_1 > 0 then
			var_13_0 = gChipSuitCsv[arg_13_1][2][2].suitName
		end

		arg_8_0.btnPlanSuitFilter:get("txt"):text(var_13_0)
	end)
	arg_8_0.planOrderPanel:hide()
	bind.click(arg_8_0, arg_8_0.planOrderPanel, {
		method = function()
			arg_8_0.planOrderPanel:hide()
			arg_8_0.btnPlanOrder:get("arrow"):setFlippedY(false)
		end
	})

	arg_8_0.selectPlanOrder = idler.new()

	idlereasy.when(arg_8_0.selectPlanOrder, function(arg_15_0, arg_15_1)
		arg_8_0.planList:jumpToTop()
		arg_8_0.planOrderPanel:hide()
		arg_8_0.btnPlanOrder:get("arrow"):setFlippedY(false)

		local var_15_0 = arg_15_1 and var_0_3.getAttrName(arg_15_1) or gLanguageCsv.chipPlanOrderDefault

		adapt.setTextScaleWithWidth(arg_8_0.btnPlanOrder:get("txt"), var_15_0, 200)
	end)

	arg_8_0.isRefreshPlanPanel = idler.new(true)

	if arg_8_0.page == 1 then
		local var_8_5 = 0

		idlereasy.any({
			arg_8_0.isRefreshPlanPanel,
			arg_8_0.selectPlanSuitId,
			arg_8_0.selectPlanOrder,
			arg_8_0.chipPlans,
			arg_8_0.cardChips
		}, function()
			var_8_5 = var_8_5 + 1

			if var_8_5 > 0 then
				var_8_5 = 0

				arg_8_0:refreshLeftPlanPanel()
			end
		end)
	end

	arg_8_0.equipShow = idler.new(true)

	idlereasy.when(arg_8_0.equipShow, function(arg_17_0, arg_17_1)
		if arg_17_1 then
			arg_8_0.btnEquipShow:get("img"):texture("common/btn/btn_nomal_4white.png")
			arg_8_0.btnEquipShow:get("icon"):texture("city/card/chip/icon_xs.png")
			arg_8_0.btnEquipShow:get("txt"):text(gLanguageCsv.chipPlanEquipShow)
			text.addEffect(arg_8_0.btnEquipShow:get("txt"), {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			})
		else
			arg_8_0.btnEquipShow:get("img"):texture("common/btn/btn_nomal_4red.png")
			arg_8_0.btnEquipShow:get("icon"):texture("city/card/chip/icon_yc.png")
			arg_8_0.btnEquipShow:get("txt"):text(gLanguageCsv.chipPlanEquipHide)
			text.addEffect(arg_8_0.btnEquipShow:get("txt"), {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end

		arg_8_0.isRefreshBagPanel:notify()
	end)
end

function var_0_2.refreshLeftPlanPanel(arg_18_0)
	local var_18_0 = arg_18_0.selectPlanId:read()
	local var_18_1 = arg_18_0.chipPlans:read()

	if arg_18_0.isPlanAddNew or not var_18_1[var_18_0] then
		var_18_0 = nil
	end

	local var_18_2 = {}
	local var_18_3
	local var_18_4 = arg_18_0.selectCardDBID:read()
	local var_18_5 = arg_18_0.cardChips:read()

	if var_18_0 and itertools.size(var_18_5) > 0 and itertools.equal(var_18_5, var_18_1[var_18_0].chips) then
		var_18_3 = var_18_0
	end

	for iter_18_0, iter_18_1 in pairs(var_18_1) do
		local var_18_6
		local var_18_7 = var_0_3.getSuitAttrByCard(iter_18_1.chips)

		for iter_18_2, iter_18_3 in pairs(var_18_7) do
			if iter_18_3[2] and iter_18_3[2][3] == true then
				var_18_6 = iter_18_2
			end
		end

		local var_18_8 = var_0_3.getCardDBID(iter_18_1.chips)

		if not var_18_3 and var_18_8 == var_18_4 then
			var_18_3 = iter_18_0
		end

		table.insert(var_18_2, {
			id = iter_18_0,
			data = iter_18_1,
			suitId = var_18_6,
			addNew = arg_18_0.isPlanAddNew,
			cardDBID = var_18_8,
			curCard = var_18_3 == iter_18_0,
			attrsValue = var_0_3.getAttrsValue(iter_18_1.chips)
		})
	end

	arg_18_0.cardChipsPlanId = var_18_3

	if arg_18_0.isPlanAddNew then
		table.insert(var_18_2, {
			addNew = arg_18_0.isPlanAddNew,
			attrsValue = var_0_3.getAttrsValue()
		})
	else
		if not var_18_3 then
			local var_18_9
			local var_18_10 = var_0_3.getSuitAttrByCard(var_18_5)

			for iter_18_4, iter_18_5 in pairs(var_18_10) do
				if iter_18_5[2] and iter_18_5[2][3] == true then
					var_18_9 = iter_18_4
				end
			end

			table.insert(var_18_2, {
				curCard = true,
				data = {
					chips = var_18_5
				},
				suitId = var_18_9,
				addNew = arg_18_0.isPlanAddNew,
				attrsValue = var_0_3.getAttrsValue(var_18_5)
			})
		end

		var_18_0 = var_18_0 or var_18_3
	end

	arg_18_0.planDataAll = var_18_2

	local var_18_11 = arg_18_0.selectPlanSuitId:read()

	if var_18_11 >= 0 then
		local function var_18_12(arg_19_0)
			if arg_19_0.id then
				if var_18_11 == 0 then
					if arg_19_0.suitId then
						return false
					end
				elseif var_18_11 > 0 and var_18_11 ~= arg_19_0.suitId then
					return false
				end
			end

			return true, id
		end

		local var_18_13 = {}
		local var_18_14 = {}

		for iter_18_6, iter_18_7 in ipairs(var_18_2) do
			if var_18_12(iter_18_7) then
				table.insert(var_18_13, iter_18_7)

				if iter_18_7.id then
					var_18_14[iter_18_7.id] = true
				end
			end
		end

		var_18_2 = var_18_13

		if not var_18_14[var_18_0] then
			var_18_0 = nil
		end
	end

	local var_18_15 = arg_18_0.selectPlanOrder:read()

	local function var_18_16(arg_20_0, arg_20_1)
		if not arg_20_0.id or not arg_20_1.id then
			return not arg_20_0.id
		end

		if var_18_15 then
			local var_20_0 = arg_20_0.attrsValue[1][var_18_15]
			local var_20_1 = arg_20_1.attrsValue[1][var_18_15]

			if var_20_0 and var_20_1 then
				if var_20_0 ~= var_20_1 then
					var_20_0 = tonumber(var_20_0)
					var_20_1 = tonumber(var_20_1)

					return var_20_1 < var_20_0
				end
			elseif var_20_0 or var_20_1 then
				return var_20_0
			end

			local var_20_2 = arg_20_0.attrsValue[2][var_18_15]
			local var_20_3 = arg_20_1.attrsValue[2][var_18_15]

			if var_20_2 and var_20_3 then
				if var_20_2 ~= var_20_3 then
					var_20_2 = tonumber(string.sub(var_20_2, 1, #var_20_2 - 1))
					var_20_3 = tonumber(string.sub(var_20_3, 1, #var_20_3 - 1))

					return var_20_3 < var_20_2
				end
			elseif var_20_2 or var_20_3 then
				return var_20_2
			end
		end

		return arg_20_0.data.created_time > arg_20_1.data.created_time
	end

	table.sort(var_18_2, var_18_16)

	var_18_0 = var_18_0 or var_18_2[1].id

	arg_18_0.selectPlanId:set(var_18_0, true)
	dataEasy.tryCallFunc(arg_18_0.planList, "updatePreloadCenterIndexAdaptFirst")
	arg_18_0.planData:update(var_18_2)
end

function var_0_2.onLeftPlanNewClick(arg_21_0)
	local var_21_0 = arg_21_0.chipPlans:read()
	local var_21_1 = 0

	for iter_21_0 = 1, table.maxn(var_21_0) + 1 do
		if not var_21_0[iter_21_0] then
			var_21_1 = iter_21_0

			break
		end
	end

	local var_21_2 = gLanguageCsv.planNew

	gGameApp:requestServer("/game/chip/plan/new", function()
		arg_21_0.planList:jumpToTop()
		arg_21_0.selectPlanId:set(var_21_1)
		arg_21_0.isRefreshPlanPanel:notify()
	end, {}, var_21_2)
end

function var_0_2.onSuitFilterClick(arg_23_0)
	var_0_1.onSuitFilterClick(arg_23_0, true)
end

function var_0_2.onPlanSuitFilterClick(arg_24_0)
	arg_24_0.btnPlanSuitFilter:get("arrow"):setFlippedY(true)

	local var_24_0 = {
		[-1] = 0
	}

	for iter_24_0, iter_24_1 in pairs(arg_24_0.planDataAll) do
		var_24_0[-1] = var_24_0[-1] + 1

		if iter_24_1.id then
			local var_24_1 = iter_24_1.suitId or 0

			var_24_0[var_24_1] = var_24_0[var_24_1] or 0
			var_24_0[var_24_1] = var_24_0[var_24_1] + 1
		end
	end

	local var_24_2 = arg_24_0.selectPlanSuitId:read()
	local var_24_3 = {}

	for iter_24_2, iter_24_3 in pairs(var_24_0) do
		table.insert(var_24_3, {
			suitId = iter_24_2,
			count = iter_24_3,
			selected = var_24_2 == iter_24_2,
			cfg = iter_24_2 > 0 and gChipSuitCsv[iter_24_2][2][2]
		})
	end

	table.sort(var_24_3, function(arg_25_0, arg_25_1)
		return arg_25_0.suitId < arg_25_1.suitId
	end)
	arg_24_0.planSuitFilterData:update(var_24_3)
	arg_24_0.planSuitFilterPanel:show()
end

function var_0_2.onPlanOrderClick(arg_26_0)
	arg_26_0.btnPlanOrder:get("arrow"):setFlippedY(true)

	local var_26_0 = arg_26_0.selectPlanOrder:read()
	local var_26_1 = {
		{
			name = gLanguageCsv.default,
			selected = var_26_0 == nil
		}
	}

	for iter_26_0, iter_26_1 in ipairs(var_0_4) do
		local var_26_2 = game.ATTRDEF_ENUM_TABLE[iter_26_1]

		table.insert(var_26_1, {
			id = var_26_2,
			name = var_0_3.getAttrName(var_26_2),
			selected = var_26_0 == var_26_2
		})
	end

	arg_26_0.planOrderData:update(var_26_1)
	arg_26_0.planOrderPanel:show()
end

function var_0_2.onPlanItemNewClick(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = arg_27_0.curChipPlan:read()

	if arg_27_4.id then
		local function var_27_1()
			gGameApp:requestServer("/game/chip/plan/edit", function()
				arg_27_0.selectPlanId:set(arg_27_4.id)
				arg_27_0:onPlanMaskClose()
			end, arg_27_4.id, var_27_0)
		end

		local var_27_2 = "chipPlanItemNewTip"
		local var_27_3 = userDefault.getCurrDayKey(var_27_2, "first")

		if var_27_3 == "first" then
			var_27_3 = "true"

			userDefault.setCurrDayKey(var_27_2, var_27_3)
		end

		if (var_27_3 == "first" or var_27_3 == "true") and not itertools.isempty(arg_27_4.data.chips) then
			local var_27_4 = arg_27_4.data.name

			gGameUI:showDialog({
				isRich = true,
				selectType = 2,
				btnType = 2,
				content = {
					"#C0x5B545B#" .. gLanguageCsv.chipPlanItemNewTip,
					"#C0xF76B45#(" .. var_27_4 .. ")"
				},
				cb = var_27_1,
				selectKey = var_27_2,
				selectTip = gLanguageCsv.todayNoTip
			})
		else
			var_27_1()
		end
	else
		local var_27_5 = arg_27_0.chipPlans:read()
		local var_27_6 = 0

		for iter_27_0 = 1, table.maxn(var_27_5) + 1 do
			if not var_27_5[iter_27_0] then
				local var_27_7 = iter_27_0

				break
			end
		end

		local var_27_8 = gLanguageCsv.planNew

		gGameApp:requestServer("/game/chip/plan/new", function()
			arg_27_0:onPlanMaskClose()
		end, var_27_0, var_27_8)
	end
end

function var_0_2.onPlanItemClick(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	arg_31_0.selectPlanId:set(arg_31_4.id)
end

function var_0_2.onPlanItemEquipClick(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	arg_32_0:onPlanEquipClick(arg_32_4.data)
end

function var_0_2.setPlanName(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.selectPlanId:read()
	local var_33_1 = arg_33_0.chipPlans:read()

	if var_33_0 and var_33_1[var_33_0] then
		arg_33_0.planNamePanel:show()
		arg_33_0.planNamePanel:get("name"):text(var_33_1[var_33_0].name)
		adapt.oneLineCenterPos(cc.p(arg_33_0.planNamePanel:width() / 2, arg_33_0.planNamePanel:height() / 2), {
			arg_33_0.planNamePanel:get("name"),
			arg_33_0.planNamePanel:get("icon")
		}, cc.p(10, 0))
	else
		arg_33_0.planNamePanel:hide()
	end
end

function var_0_2.onPlanNameClick(arg_34_0)
	local var_34_0
	local var_34_1 = arg_34_0.selectPlanId:read()
	local var_34_2 = arg_34_0.chipPlans:read()

	if var_34_1 and var_34_2[var_34_1] then
		var_34_0 = var_34_2[var_34_1].name
	end

	gGameUI:stackUI("city.card.changename", nil, nil, {
		typ = "plan",
		noBlackList = true,
		requestParamsCount = 2,
		name = var_34_0,
		titleTxt = gLanguageCsv.changPlanName,
		requestParams = {
			(arg_34_0.selectPlanId:read())
		},
		customCheck = function(arg_35_0)
			for iter_35_0, iter_35_1 in pairs(var_34_2) do
				if arg_35_0 == iter_35_1.name then
					gGameUI:showTip(gLanguageCsv.planNameSame)

					return false
				end
			end

			return true
		end
	})
end

function var_0_2.onRightPlanNewClick(arg_36_0)
	arg_36_0.isPlanAddNew = true

	arg_36_0.isRefreshPlanPanel:notify()

	arg_36_0.planMaskView = gGameUI:createView("city.card.chip.plan_mask", arg_36_0):init({
		onClose = arg_36_0:createHandler("onPlanMaskClose")
	})
end

function var_0_2.onPlanMaskClose(arg_37_0)
	if arg_37_0.planMaskView then
		arg_37_0.planMaskView:onClose()

		arg_37_0.planMaskView = nil
	end

	arg_37_0.isPlanAddNew = false

	arg_37_0.isRefreshPlanPanel:notify()
end

function var_0_2.onPlanSaveClick(arg_38_0)
	gGameApp:requestServer("/game/chip/plan/edit", function()
		gGameUI:showTip(gLanguageCsv.planSaved)

		if arg_38_0.page == 2 then
			arg_38_0:onClose()
		else
			arg_38_0.isRefreshPlanPanel:notify()
		end
	end, arg_38_0.selectPlanId:read(), arg_38_0.curChipPlan:read())
end

function var_0_2.onPlanDeleteClick(arg_40_0)
	local var_40_0 = arg_40_0.selectPlanId:read()

	local function var_40_1()
		gGameApp:requestServer("/game/chip/plan/delete", function()
			arg_40_0.selectPlanId:set(nil)
			arg_40_0.isRefreshPlanPanel:notify()
		end, var_40_0)
	end

	local var_40_2 = arg_40_0.chipPlans:read()
	local var_40_3 = "chipPlanDeleteTip"
	local var_40_4 = userDefault.getCurrDayKey(var_40_3, "first")

	if var_40_4 == "first" then
		var_40_4 = "true"

		userDefault.setCurrDayKey(var_40_3, var_40_4)
	end

	if (var_40_4 == "first" or var_40_4 == "true") and var_40_2[var_40_0] and not itertools.isempty(var_40_2[var_40_0].chips) then
		local var_40_5 = var_40_2[var_40_0].name

		gGameUI:showDialog({
			isRich = true,
			selectType = 2,
			btnType = 2,
			content = {
				"#C0x5B545B#" .. gLanguageCsv.chipPlanDeleteTip,
				"#C0xF76B45#(" .. var_40_5 .. ")"
			},
			cb = var_40_1,
			selectKey = var_40_3,
			selectTip = gLanguageCsv.todayNoTip
		})
	else
		var_40_1()
	end
end

function var_0_2.onPlanTopClick(arg_43_0)
	gGameApp:requestServer("/game/chip/plan/edit", function()
		arg_43_0.isRefreshPlanPanel:notify()
	end, arg_43_0.selectPlanId:read(), nil, nil, true)
end

function var_0_2.onPlanEditClick(arg_45_0)
	gGameUI:stackUI("city.card.chip.plan", nil, nil, {
		page = 2,
		planId = arg_45_0.selectPlanId:read(),
		cb = arg_45_0:createHandler("planEditCb")
	})
end

function var_0_2.planEditCb(arg_46_0)
	arg_46_0.isRefreshPlanPanel:notify()
end

function var_0_2.onPlanEquipClick(arg_47_0, arg_47_1)
	local function var_47_0()
		local var_48_0 = arg_47_0.selectCardDBID:read()
		local var_48_1

		if type(arg_47_1) ~= "table" then
			var_48_1 = arg_47_0.curChipPlan:read()
		else
			var_48_1 = arg_47_1.chips
		end

		local var_48_2 = table.deepcopy(var_48_1, true)

		local function var_48_3()
			for iter_49_0 = 1, 6 do
				if not var_48_2[iter_49_0] then
					var_48_2[iter_49_0] = -1
				end
			end

			gGameApp:requestServer("/game/card/chip/change", function(arg_50_0)
				gGameUI:showTip(gLanguageCsv.exchange2Success)
				arg_47_0.selectPlanId:set(nil)
				arg_47_0.isRefreshPlanPanel:notify()
			end, var_48_0, var_48_2)
		end

		for iter_48_0, iter_48_1 in pairs(var_48_2) do
			local var_48_4 = gGameModel.chips:find(iter_48_1):read("card_db_id")

			if var_48_4 and var_48_4 ~= var_48_0 then
				gGameUI:stackUI("city.card.chip.plan_equip_tip", nil, nil, {
					chips = var_48_2,
					cb = var_48_3
				})

				return
			end
		end

		var_48_3()
	end

	if not arg_47_0.cardChipsPlanId and not itertools.isempty(arg_47_0.cardChips:read()) then
		gGameUI:showDialog({
			btnType = 1,
			clearFast = true,
			content = gLanguageCsv.chipPlanEquipTip,
			cb = var_47_0
		})
	else
		var_47_0()
	end
end

function var_0_2.onPlanSuitFilterItemClick(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	arg_51_0.selectPlanSuitId:set(arg_51_4.suitId, true)
end

function var_0_2.onPlanOrderItemClick(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	arg_52_0.selectPlanOrder:set(arg_52_4.id, true)
end

function var_0_2.onEquipShowClick(arg_53_0)
	arg_53_0.equipShow:modify(function(arg_54_0)
		return true, not arg_54_0
	end)
end

function var_0_2.onClose(arg_55_0)
	if arg_55_0.page == 2 then
		local var_55_0 = arg_55_0.selectPlanId:read()
		local var_55_1 = arg_55_0.chipPlans:read()

		if not itertools.equal(var_55_1[var_55_0].chips, arg_55_0.curChipPlan:read()) then
			gGameUI:showDialog({
				btnType = 1,
				clearFast = true,
				content = gLanguageCsv.chipPlanBagCloseTip,
				cb = function()
					var_0_1.onClose(arg_55_0)
				end
			})

			return
		end
	end

	var_0_1.onClose(arg_55_0)
end

function var_0_2.showPanel(arg_57_0)
	local var_57_0 = arg_57_0.curChipPlan:read()
	local var_57_1

	if arg_57_0.page == 1 and not arg_57_0.showCard:read() then
		var_57_1 = var_0_3.getAttrsValueCmp(var_57_0, arg_57_0.cardChips:read())
	else
		var_57_1 = var_0_3.getAttrsValue(var_57_0)
	end

	local var_57_2 = {}

	for iter_57_0, iter_57_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		local var_57_3 = game.ATTRDEF_ENUM_TABLE[iter_57_1]

		if var_57_1[1][var_57_3] then
			table.insert(var_57_2, {
				attr = iter_57_1,
				key = var_57_3,
				val = var_57_1[1][var_57_3]
			})
		end
	end

	arg_57_0.baseAttrData:set(var_57_2)
	arg_57_0.baseAttrTip:visible(#var_57_2 == 0)

	local var_57_4 = {}
	local var_57_5 = var_0_3.getComplateSuitAttrByCard(var_57_0)

	for iter_57_2, iter_57_3 in pairs(var_57_5) do
		local var_57_6 = 0

		for iter_57_4, iter_57_5 in ipairs(iter_57_3.data) do
			if iter_57_5[3] then
				var_57_6 = math.max(var_57_6, iter_57_5[1])
			end
		end

		if var_57_6 > 0 then
			table.insert(var_57_4, {
				suitId = iter_57_3.suitId,
				maxActiveNum = var_57_6,
				data = iter_57_3.data
			})
		end
	end

	arg_57_0.suitAttrData:set(var_57_4)
	arg_57_0.suitAttrTip:visible(#var_57_4 == 0)
end

function var_0_2.setCardDBID(arg_58_0, arg_58_1)
	if not arg_58_1 then
		return
	end

	local var_58_0 = gGameModel.cards:find(arg_58_1):read("card_id", "skin_id", "level", "star", "advance")
	local var_58_1 = csv.cards[var_58_0.card_id]
	local var_58_2 = csv.unit[var_58_1.unitID]
	local var_58_3 = dataEasy.getUnitId(var_58_0.card_id, var_58_0.skin_id)

	bind.extend(arg_58_0, arg_58_0.cardPanel, {
		class = "card_icon",
		props = {
			unitId = var_58_3,
			advance = var_58_0.advance,
			rarity = var_58_2.rarity,
			star = var_58_0.star,
			levelProps = {
				data = var_58_0.level
			},
			onNode = function(arg_59_0)
				arg_59_0:alignCenter(arg_58_0.cardPanel:size()):scale(0.9)
			end
		}
	})
	arg_58_0.selectPlanId:set(nil)
	arg_58_0.selectCardDBID:set(arg_58_1)
	performWithDelay(arg_58_0, function()
		idlereasy.when(arg_58_0.showCard, function(arg_61_0, arg_61_1)
			arg_58_0.cardPanel:visible(arg_61_1)

			for iter_61_0 = 1, 6 do
				arg_58_0.chipPanel:getItem(iter_61_0):get("effect_line"):visible(not arg_61_1):scale(1.2)
			end
		end):anonyOnly(arg_58_0)
		idlereasy.when(arg_58_0.curChipPlan, function(arg_62_0, arg_62_1)
			for iter_62_0 = 1, 6 do
				local var_62_0 = arg_58_0.chipPanel:getItem(iter_62_0)

				var_62_0:setTouchEnabled(false)

				local var_62_1 = arg_62_1[iter_62_0]

				if var_62_1 then
					local var_62_2 = gGameModel.chips:find(var_62_1):read("chip_id", "card_db_id", "level")
					local var_62_3 = {
						dbId = var_62_1,
						chipId = var_62_2.chip_id,
						level = var_62_2.level,
						cfg = csv.chip.chips[var_62_2.chip_id]
					}

					var_62_0:setTouchEnabled(true)
					var_62_0:onTouch(functools.partial(arg_58_0.onCardChipClick, arg_58_0, var_62_0, iter_62_0, var_62_3))
				elseif arg_58_0.page == 2 then
					var_62_0:setTouchEnabled(true)
					var_62_0:onTouch(function(arg_63_0)
						if arg_63_0.name == "ended" then
							arg_58_0.selectLeftPos:set(iter_62_0)
							arg_58_0.selectRightPos:set(iter_62_0)
						end
					end)
				end
			end
		end):anonyOnly(arg_58_0)
	end, 0)
end

function var_0_2.refreshLeftPanel(arg_64_0)
	if arg_64_0.page == 1 then
		return
	end

	local var_64_0 = arg_64_0.roleChips:read()
	local var_64_1 = arg_64_0.selectLeftPos:read()
	local var_64_2 = arg_64_0.selectSuitId:read()
	local var_64_3 = arg_64_0.selectAttrIds:read()
	local var_64_4 = arg_64_0.equipShow:read()
	local var_64_5 = {}
	local var_64_6 = {}

	local function var_64_7(arg_65_0, arg_65_1)
		if var_64_1 and var_64_1 ~= arg_65_0.pos then
			return false
		end

		if var_64_2 and var_64_2 ~= arg_65_0.suitID then
			return false
		end

		if itertools.size(var_64_3) > 0 then
			local var_65_0, var_65_1 = var_0_3.getAttrs({
				arg_65_1
			})

			for iter_65_0, iter_65_1 in pairs(var_64_3) do
				if not var_65_1[1][iter_65_0] and not var_65_1[2][iter_65_0] then
					return false
				end
			end
		end

		return true
	end

	local var_64_8 = itertools.map(arg_64_0.curChipPlan:read(), function(arg_66_0, arg_66_1)
		return arg_66_1, true
	end)

	for iter_64_0, iter_64_1 in ipairs(var_64_0) do
		local var_64_9 = gGameModel.chips:find(iter_64_1):read("chip_id", "card_db_id", "level", "locked")
		local var_64_10 = csv.chip.chips[var_64_9.chip_id]
		local var_64_11

		if var_64_9.card_db_id then
			local var_64_12 = gGameModel.cards:find(var_64_9.card_db_id)

			var_64_11 = dataEasy.getUnitId(var_64_12:read("card_id"), var_64_12:read("skin_id"))
		end

		if var_64_7(var_64_10, iter_64_1) then
			var_64_5[iter_64_1] = {
				idx = iter_64_0,
				dbId = iter_64_1,
				unitId = var_64_11,
				chipId = var_64_9.chip_id,
				level = var_64_9.level,
				locked = var_64_9.locked,
				equipShow = var_64_4,
				cfg = var_64_10,
				grayState = var_64_8[iter_64_1] and 1 or 0
			}

			if var_64_2 then
				var_64_6[var_64_10.pos] = true
			end
		end
	end

	dataEasy.tryCallFunc(arg_64_0.bagList, "updatePreloadCenterIndexAdaptFirst")
	arg_64_0.bagData:update(var_64_5)
	arg_64_0.slotFlags:set(var_64_6)
	arg_64_0.empty:visible(itertools.size(var_64_5) == 0)
end

function var_0_2.onItemTouch(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	if arg_67_5.name == "ended" or arg_67_5.name == "cancelled" then
		if not arg_67_0.moved then
			arg_67_0:showDetails(arg_67_1, arg_67_2, nil, arg_67_4.dbId, nil, arg_67_0.curChipPlan)

			return
		end

		arg_67_0:resetSelected()

		if arg_67_0.movePanel then
			arg_67_0:deleteMovingItem()

			for iter_67_0 = 1, 6 do
				local var_67_0 = arg_67_0.chipPanel:getItem(iter_67_0)
				local var_67_1 = var_67_0:box()
				local var_67_2 = var_67_0:getParent():convertToWorldSpace(cc.p(var_67_1.x, var_67_1.y))

				var_67_1.x, var_67_1.y = var_67_2.x, var_67_2.y
				var_67_1.width, var_67_1.height = var_67_1.width * arg_67_0.chipPanel:scale(), var_67_1.height * arg_67_0.chipPanel:scale()

				if cc.rectContainsPoint(var_67_1, arg_67_5) then
					if iter_67_0 == arg_67_4.cfg.pos then
						arg_67_0.curChipPlan:modify(function(arg_68_0)
							arg_68_0[iter_67_0] = arg_67_4.dbId

							return true, arg_68_0
						end)
						arg_67_0.isRefreshBagPanel:notify()
					else
						gGameUI:showTip(gLanguageCsv.chipSlotError)
					end

					return
				end
			end
		end
	else
		var_0_1.onItemTouch(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	end
end

function var_0_2.onCardChipClick(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	if arg_69_0.page == 1 then
		if arg_69_4.name == "ended" then
			arg_69_0.selectRightPos:set(arg_69_2)
			arg_69_0:showDetails(list, arg_69_1, arg_69_2, arg_69_3.dbId)
		end

		return
	end

	if arg_69_4.name == "ended" or arg_69_4.name == "cancelled" then
		if not arg_69_0.moved then
			arg_69_0.selectLeftPos:set(arg_69_2)
			arg_69_0.selectRightPos:set(arg_69_2)
			arg_69_0:showDetails(list, arg_69_1, arg_69_2, arg_69_3.dbId, nil, arg_69_0.curChipPlan)

			return
		end

		arg_69_0:resetSelected()

		if arg_69_0.movePanel then
			arg_69_0:deleteMovingItem()

			local var_69_0 = arg_69_0.bagList:box()
			local var_69_1 = arg_69_0.bagList:getParent():convertToWorldSpace(cc.p(var_69_0.x, var_69_0.y))

			var_69_0.x, var_69_0.y = var_69_1.x, var_69_1.y

			if cc.rectContainsPoint(var_69_0, arg_69_4) then
				arg_69_0.curChipPlan:modify(function(arg_70_0)
					arg_70_0[arg_69_2] = nil

					return true, arg_70_0
				end)
				arg_69_0.isRefreshBagPanel:notify()
			end
		end
	else
		var_0_1.onCardChipClick(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	end
end

function var_0_2.onBaseAttrDetailClick(arg_71_0)
	local var_71_0 = arg_71_0.curChipPlan:read()

	if arg_71_0.page == 1 and not arg_71_0.showCard:read() then
		gGameUI:stackUI("city.card.chip.total_detail", nil, nil, {
			typ = 2,
			curPlan = var_71_0,
			cardPlan = arg_71_0.cardChips:read()
		})
	else
		gGameUI:stackUI("city.card.chip.total_detail", nil, nil, {
			typ = 1,
			cardPlan = var_71_0
		})
	end
end

function var_0_2.onSuitAttrDetailClick(arg_72_0)
	gGameUI:stackUI("city.card.chip.suit_detail", nil, nil, arg_72_0.curChipPlan:read())
end

return var_0_2
