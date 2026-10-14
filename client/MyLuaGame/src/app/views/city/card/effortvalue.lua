local var_0_0 = {
	ONE = 2,
	ONE_AND_TEN = 1,
	SAVE_AND_CANCEL = 3,
	SAVE = 4
}
local var_0_1 = {
	TEN = 2,
	ONE = 1
}

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1:multiget("icon1", "txtAdvance", "icon2", "txtTip")

	text.addEffect(var_1_0.txtAdvance, {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.BLACK
		}
	})
	var_1_0.txtAdvance:text(dataEasy.getRomanNumeral(arg_1_0))
	adapt.oneLineCenterPos(cc.p(var_1_0.txtTip:x(), var_1_0.txtAdvance:y()), {
		var_1_0.icon1,
		var_1_0.txtAdvance,
		var_1_0.icon2
	}, cc.p(15, 0))
end

local var_0_3 = class("CardEffortValueView", cc.load("mvc").ViewBase)

var_0_3.RESOURCE_FILENAME = "card_effortvalue.json"
var_0_3.RESOURCE_BINDING = {
	itemTxt = "itemTxt",
	["panel.icon"] = "icon",
	["panel.leftPanel"] = "leftPanel",
	["panel.textAdvance"] = "textAdvance",
	["panel.rightPanel"] = "rightPanel",
	["panel.leftPanel.topPanel"] = "leftTopPanel",
	["panel.rightPanel.topPanel"] = "rightTopPanel",
	selectPanel = "selectPanel",
	["panel.advancePanel"] = "advancePanel",
	item = "item",
	["panel.num"] = "num",
	itemAttr = "itemAttr",
	panel = "panel",
	["panel.textAdvanceNote"] = "textAdvanceNote",
	["panel.advanceMaxPanel"] = "advanceMaxPanel",
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 30,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("name", "icon", "num", "changeNum", "bar", "imgMax", "barBg", "currentNum")
					local var_2_1, var_2_2 = dataEasy.getEffortValueAttrData(arg_2_3.cfg.attrType)

					var_2_0.name:text(var_2_1 .. ":")
					var_2_0.icon:texture(var_2_2)

					local var_2_3 = arg_2_3.maxVal
					local var_2_4 = cc.clampf(arg_2_3.currVal - arg_2_3.totalVal, 0, var_2_3)

					var_2_0.currentNum:text(arg_2_3.currVal)

					if var_2_4 then
						var_2_0.num:text(math.floor(var_2_4) .. "/" .. var_2_3)
						text.addEffect(var_2_0.num, {
							outline = {
								color = ui.NEWCOLORS.BLACK
							}
						})

						local var_2_5 = math.min(var_2_4 / var_2_3 * 100, 100)

						if not arg_2_3.myIdler then
							arg_2_3.myIdler = idler.new(var_2_5)

							bind.extend(arg_2_0, var_2_0.bar, {
								event = "extend",
								class = "loadingbar",
								props = {
									maskImg = "city/card/effort_value/bar_red.png",
									data = arg_2_3.myIdler
								}
							})
						else
							arg_2_3.myIdler:set(var_2_5)
						end
					end

					local var_2_6 = cc.clampf(arg_2_3.changeNum or 0, -var_2_4, arg_2_3.maxVal - var_2_4)

					if var_2_6 == -0 then
						var_2_6 = 0
					end

					var_2_0.imgMax:visible(var_2_6 + var_2_4 >= arg_2_3.maxVal and arg_2_3.changeNum ~= nil)

					if arg_2_3.changeNum then
						var_2_0.changeNum:show()
						var_2_0.changeNum:text((var_2_6 >= 0 and "+" or "") .. var_2_6)
						adapt.oneLinePos(var_2_0.currentNum, var_2_0.changeNum, cc.p(15, 0))

						if var_2_6 <= 0 then
							text.addEffect(var_2_0.changeNum, {
								color = ui.COLORS.NORMAL.ALERT_ORANGE
							})
						elseif var_2_6 > 0 then
							text.addEffect(var_2_0.changeNum, {
								color = ui.COLORS.NORMAL.FRIEND_GREEN
							})
						end

						widget.addAnimationByKey(var_2_0.bar, "effect/nuizhifankui.skel", "nuizhifankui", "effect", 10):anchorPoint(cc.p(0.5, 0.5)):xy(var_2_0.barBg:width() / 2 - 2, var_2_0.barBg:height() / 2 - 4):play("effect")
					else
						var_2_0.changeNum:hide()
					end
				end
			}
		}
	},
	["selectPanel.btnAttr"] = {
		varname = "btnAttr",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					return arg_3_0:onBtnAttr()
				end)
			}
		}
	},
	["selectPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 15,
				data = bindHelper.self("selectDatas"),
				item = bindHelper.self("itemAttr"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("list", "selected", "bg")
					local var_4_1 = {}

					for iter_4_0, iter_4_1 in pairs(arg_4_3) do
						if iter_4_0 ~= "selected" then
							table.insert(var_4_1, {
								key = iter_4_0,
								num = iter_4_1
							})
						end
					end

					bind.extend(arg_4_0, var_4_0.list, {
						event = "extend",
						class = "listview",
						props = {
							data = var_4_1,
							item = bindHelper.parent("itemTxt"),
							dataOrderCmp = function(arg_5_0, arg_5_1)
								return game.ATTRDEF_SIMPLE_ENUM_TABLE[arg_5_0.key] < game.ATTRDEF_SIMPLE_ENUM_TABLE[arg_5_1.key]
							end,
							onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
								local var_6_0 = arg_6_1:multiget("name", "num")
								local var_6_1, var_6_2 = dataEasy.getEffortValueAttrData(game.ATTRDEF_ENUM_TABLE[arg_6_3.key])

								var_6_0.name:text(var_6_1 .. ":")
								var_6_0.num:text(arg_6_3.num)
								text.addEffect(var_6_0.num, {
									color = arg_6_3.num < 0 and ui.COLORS.NORMAL.ALERT_ORANGE or ui.COLORS.NORMAL.FRIEND_GREEN
								})
							end
						}
					})
					var_4_0.selected:texture(arg_4_3.selected == true and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")
					bind.touch(arg_4_0, var_4_0.selected, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_2, arg_4_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["panel.normalPanel"] = {
		varname = "normalPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0:onTrainSelectClick(1)
				end)
			}
		}
	},
	["panel.highPanel"] = {
		varname = "highPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_8_0)
					return arg_8_0:onTrainSelectClick(2)
				end)
			}
		}
	},
	["panel.leftPanel.btn"] = {
		varname = "leftBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_9_0)
					return arg_9_0:onTrainClick(var_0_1.ONE)
				end)
			}
		}
	},
	["panel.leftPanel.btn.txt"] = {
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
	["panel.rightPanel.btn.txt"] = {
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
	["panel.rightPanel.btn"] = {
		varname = "rightBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_10_0)
					return arg_10_0:onTrainClick(var_0_1.TEN)
				end)
			}
		}
	},
	["panel.btnCustom"] = {
		varname = "btnCustom",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCustomClick")
			}
		}
	},
	["panel.btnCustom.txt"] = {
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
	["panel.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	["panel.advancePanel.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAdvanceClick")
			}
		}
	},
	["panel.advancePanel.btn.txt"] = {
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
	["panel.btnDetail"] = {
		varname = "btnDetail",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnDetailClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.selectDbId = arg_11_1()
	arg_11_0.validAreas = arg_11_2

	arg_11_0:initModel()
	arg_11_0:initCfg()

	arg_11_0.curState = idler.new()
	arg_11_0.tabDatas = idlers.new()
	arg_11_0.trainIndex = idler.new(1)
	arg_11_0.currCost = idlertable.new({})
	arg_11_0.trainType = idler.new(var_0_1.ONE)
	arg_11_0.times = idler.new(0)
	arg_11_0.listIndexs = idlertable.new({})
	arg_11_0.selectDatas = idlers.newWithMap({})

	arg_11_0.selectPanel:hide()
	arg_11_0:adaptUI()

	local var_11_0, var_11_1 = csvNext(csv.card_effort)

	arg_11_0.normal = var_11_1.cost1
	arg_11_0.special = var_11_1.cost2
	arg_11_0.datas = {
		{
			panel = arg_11_0.normalPanel,
			cost = arg_11_0.normal
		},
		{
			panel = arg_11_0.highPanel,
			cost = arg_11_0.special
		}
	}

	local var_11_2 = 0

	idlereasy.any({
		arg_11_0.cardId,
		arg_11_0.effortValue,
		arg_11_0.effortAdvance,
		arg_11_0.level
	}, function()
		local var_12_0 = arg_11_0.cardId:read()
		local var_12_1 = arg_11_0.effortValue:read()
		local var_12_2 = arg_11_0.effortAdvance:read()
		local var_12_3 = arg_11_0.level:read()
		local var_12_4 = csv.cards[var_12_0]
		local var_12_5 = gCardEffortAdvance[var_12_4.effortSeqID][var_12_2].advanceLimit
		local var_12_6 = {}

		arg_11_0.canAdvance = true
		arg_11_0.attrShowIndex = {}

		for iter_12_0, iter_12_1 in orderCsvPairs(arg_11_0.cfg) do
			local var_12_7 = game.ATTRDEF_TABLE[iter_12_1.attrType]
			local var_12_8, var_12_9 = dataEasy.getCardEffortMax(iter_12_0, var_12_0, var_12_7, var_12_2)
			local var_12_10 = var_12_1[var_12_7] or 0

			if var_12_8 > var_12_10 - var_12_9 then
				arg_11_0.canAdvance = false
			end

			table.insert(var_12_6, {
				id = iter_12_0,
				cfg = iter_12_1,
				maxVal = var_12_8,
				totalVal = var_12_9,
				currVal = var_12_10
			})

			arg_11_0.attrShowIndex[var_12_7] = #var_12_6
		end

		var_0_2(var_12_2, arg_11_0.advancePanel)
		var_0_2(var_12_2, arg_11_0.advanceMaxPanel)
		arg_11_0.textAdvance:text(dataEasy.getRomanNumeral(var_12_2))

		if arg_11_0.canAdvance then
			local var_12_11 = var_12_2 < var_12_5

			arg_11_0.advancePanel:visible(var_12_11)
			arg_11_0.advanceMaxPanel:visible(not var_12_11)

			if var_12_11 then
				local var_12_12 = gCardEffortAdvance[var_12_4.effortSeqID][var_12_2 + 1].needLevel

				arg_11_0.advancePanel:get("txtLvTip"):text(string.format(gLanguageCsv.needSpriteLevelArrival, var_12_12)):visible(var_12_3 < var_12_12)
			end
		else
			arg_11_0.advancePanel:visible(false)
			arg_11_0.advanceMaxPanel:visible(false)
		end

		itertools.invoke({
			arg_11_0.normalPanel,
			arg_11_0.highPanel,
			arg_11_0.leftPanel,
			arg_11_0.rightPanel,
			arg_11_0.btnCustom
		}, arg_11_0.canAdvance and "hide" or "show")
		adapt.oneLinePos(arg_11_0.textAdvanceNote, arg_11_0.textAdvance, cc.p(8, 0))
		adapt.oneLinePos(arg_11_0.textAdvance, arg_11_0.btnDetail, cc.p(15, 0))
		arg_11_0.curState:notify()
		arg_11_0.tabDatas:update(var_12_6)
	end)
	arg_11_0.trainIndex:addListener(function(arg_13_0, arg_13_1)
		arg_11_0.datas[arg_13_1].panel:get("selected"):texture("common/icon/radio_normal2.png")
		arg_11_0.datas[arg_13_0].panel:get("selected"):texture("common/icon/radio_selected2.png")

		local var_13_0 = {}

		for iter_13_0, iter_13_1 in csvMapPairs(arg_11_0.datas[arg_13_0].cost) do
			table.insert(var_13_0, {
				id = iter_13_0,
				num = iter_13_1
			})
		end

		arg_11_0.currCost:set(var_13_0)
	end)

	arg_11_0.originLeftX = arg_11_0.leftPanel:x()

	dataEasy.getListenUnlock(gUnlockCsv.effort10, function(arg_14_0)
		if not arg_14_0 then
			arg_11_0.originState = var_0_0.ONE
		else
			arg_11_0.originState = var_0_0.ONE_AND_TEN
		end

		arg_11_0.curState:set(arg_11_0.originState)
	end)
	idlereasy.when(arg_11_0.listIndexs, function(arg_15_0, arg_15_1)
		local var_15_0 = {}
		local var_15_1 = false

		for iter_15_0, iter_15_1 in pairs(arg_15_1) do
			if iter_15_1 then
				var_15_1 = true

				for iter_15_2, iter_15_3 in arg_11_0.tabDatas:ipairs() do
					local var_15_2 = game.ATTRDEF_TABLE[iter_15_3:proxy().cfg.attrType]

					if arg_11_0.selectDatas:atproxy(iter_15_0 + 1)[var_15_2] then
						var_15_0[iter_15_2] = var_15_0[iter_15_2] or 0
						var_15_0[iter_15_2] = var_15_0[iter_15_2] + arg_11_0.selectDatas:atproxy(iter_15_0 + 1)[var_15_2]
					end
				end
			end
		end

		cache.setShader(arg_11_0.rightBtn, false, var_15_1 and "normal" or "hsl_gray")

		if var_15_1 then
			text.addEffect(arg_11_0.rightBtn:get("txt"), {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_11_0.rightBtn:get("txt"))
		end

		for iter_15_4 = 1, arg_11_0.tabDatas:size() do
			arg_11_0.tabDatas:atproxy(iter_15_4).changeNum = var_15_0[iter_15_4]
		end
	end)
	idlereasy.any({
		arg_11_0.items,
		arg_11_0.currCost,
		arg_11_0.curState
	}, function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		local var_16_0, var_16_1 = next(arg_16_2)
		local var_16_2 = var_16_1.id
		local var_16_3 = var_16_1.num
		local var_16_4 = dataEasy.getNumByKey(var_16_2)
		local var_16_5 = dataEasy.getCfgByKey(var_16_2).icon
		local var_16_6 = math.floor(var_16_4 / var_16_1.num)

		var_16_6 = var_16_6 >= 10 and 10 or var_16_6

		arg_11_0:setHasCurrencyInfo(var_16_2, var_16_4, var_16_5)
		arg_11_0.times:set(var_16_6)

		var_16_6 = var_16_6 == 0 and 10 or var_16_6

		arg_11_0:setPanelShowOrHide(var_16_6)

		if not arg_11_0.canAdvance then
			arg_11_0:initButtonStatus()
		end

		local function var_16_7(arg_17_0, arg_17_1)
			local var_17_0 = arg_17_0:multiget("num", "icon", "cost", "costIcon", "txt")

			var_17_0.costIcon:hide()
			var_17_0.cost:hide()
			var_17_0.icon:scale(0.9)
			var_17_0.icon:texture(var_16_5)

			local var_17_1 = var_16_3 * arg_17_1

			var_17_0.num:text(var_17_1)
			text.addEffect(var_17_0.num, {
				color = var_17_1 <= var_16_4 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
			})
			adapt.oneLineCenterPos(cc.p(arg_17_0:width() / 2, arg_17_0:height() / 2), {
				var_17_0.txt,
				var_17_0.num,
				var_17_0.icon
			}, cc.p(10, 0))
		end

		var_16_7(arg_11_0.leftTopPanel, 1)
		var_16_7(arg_11_0.rightTopPanel, var_16_6)
		cache.setShader(arg_11_0.leftBtn, false, arg_16_3 ~= var_0_0.SAVE and "normal" or "hsl_gray")

		if arg_16_3 ~= var_0_0.SAVE then
			text.addEffect(arg_11_0.leftBtn:get("txt"), {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_11_0.leftBtn:get("txt"))
		end
	end)
end

function var_0_3.initModel(arg_18_0)
	arg_18_0.items = gGameModel.role:getIdler("items")
	arg_18_0.gold = gGameModel.role:getIdler("gold")
	arg_18_0.roleLv = gGameModel.role:getIdler("level")

	idlereasy.when(arg_18_0.selectDbId, function(arg_19_0, arg_19_1)
		local var_19_0 = gGameModel.cards:find(arg_19_1)

		arg_18_0.effortValue = idlereasy.assign(var_19_0:getIdler("effort_values"), arg_18_0.effortValue)
		arg_18_0.effortAdvance = idlereasy.assign(var_19_0:getIdler("effort_advance"), arg_18_0.effortAdvance)
		arg_18_0.level = idlereasy.assign(var_19_0:getIdler("level"), arg_18_0.level)
		arg_18_0.cardId = idlereasy.assign(var_19_0:getIdler("card_id"), arg_18_0.cardId)
	end)
end

function var_0_3.initCfg(arg_20_0)
	local var_20_0 = {}

	for iter_20_0, iter_20_1 in orderCsvPairs(csv.card_effort) do
		if iter_20_1.attrType ~= game.ATTRDEF_ENUM_TABLE.specialDamage and iter_20_1.advance == 1 then
			var_20_0[iter_20_0] = iter_20_1
		end
	end

	arg_20_0.cfg = var_20_0
end

function var_0_3.setPanelShowOrHide(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.curState:read()
	local var_21_1 = arg_21_0.trainType:read()
	local var_21_2 = var_21_0 >= var_0_0.SAVE_AND_CANCEL
	local var_21_3 = var_21_1 == var_0_1.TEN

	arg_21_0.selectPanel:visible(var_21_2 and var_21_3)
	arg_21_0.mask:visible(var_21_2)
	itertools.invoke({
		arg_21_0.btnAdd,
		arg_21_0.normalPanel,
		arg_21_0.highPanel
	}, "setTouchEnabled", not var_21_2)

	if not var_21_2 then
		arg_21_0.listIndexs:set({})
	end

	arg_21_0.leftPanel:get("btn", "txt"):text(not var_21_2 and string.format(gLanguageCsv.trainTimes, 1) or gLanguageCsv.spaceCancel)
	arg_21_0.rightPanel:get("btn", "txt"):text(not var_21_2 and string.format(gLanguageCsv.trainTimes, arg_21_1) or gLanguageCsv.spaceSave)

	if not arg_21_0.canAdvance then
		local var_21_4 = var_21_0 == var_0_0.ONE

		arg_21_0.rightPanel:visible(not var_21_4)
		arg_21_0.leftPanel:x(var_21_4 and arg_21_0.originLeftX / 2 + arg_21_0.rightPanel:x() / 2 or arg_21_0.originLeftX)

		if var_21_0 == var_0_0.SAVE then
			cache.setShader(arg_21_0.leftBtn, false, "hsl_gray")
			text.deleteAllEffect(arg_21_0.leftBtn:get("txt"))
		end

		cache.setShader(arg_21_0.rightBtn, false, var_21_0 == var_0_0.SAVE_AND_CANCEL and "hsl_gray" or "normal")

		if var_21_0 ~= var_0_0.SAVE then
			text.addEffect(arg_21_0.rightBtn:get("txt"), {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_21_0.rightBtn:get("txt"))
		end

		local var_21_5 = var_21_0 >= var_0_0.SAVE_AND_CANCEL

		arg_21_0.leftTopPanel:visible(not var_21_5)
		arg_21_0.rightTopPanel:visible(not var_21_5)
	end
end

function var_0_3.initButtonStatus(arg_22_0)
	local var_22_0 = dataEasy.isUnlock(gUnlockCsv.customEffort)
	local var_22_1 = arg_22_0.curState:read()

	if var_22_0 and var_22_1 == var_0_0.ONE_AND_TEN then
		arg_22_0.btnCustom:visible(true)
		arg_22_0.leftPanel:x(arg_22_0.leftPanel:x() - 20)
		adapt.oneLinePos(arg_22_0.leftPanel, {
			arg_22_0.rightPanel,
			arg_22_0.btnCustom
		}, {
			cc.p(-120, 0),
			cc.p(-60, 0)
		})
	else
		arg_22_0.btnCustom:visible(false)
		adapt.oneLinePos(arg_22_0.leftPanel, arg_22_0.rightPanel, cc.p(90, 0))
	end
end

function var_0_3.setHasCurrencyInfo(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0.panel:multiget("txtBg", "icon", "num", "btnAdd")

	var_23_0.num:text(arg_23_2)
	var_23_0.icon:texture(arg_23_3)

	local var_23_1 = arg_23_2 < 100000 and 290 or (90 + var_23_0.num:size().width) * 1.33

	var_23_0.icon:x(var_23_0.txtBg:x() - var_23_1 * 0.8 - 20)
	var_23_0.txtBg:size(var_23_1, 70)
	adapt.oneLinePos(var_23_0.btnAdd, var_23_0.num, cc.p(10, 0), "right")
end

function var_0_3.adaptUI(arg_24_0)
	if matchLanguage({
		"en"
	}) then
		local var_24_0 = arg_24_0.cardId:read()
		local var_24_1 = csv.cards[var_24_0]
		local var_24_2 = arg_24_0.advancePanel:multiget("icon1", "txtAdvance", "icon2", "txtTip", "txtLvTip")

		adapt.setTextAdaptWithSize(arg_24_0.advanceMaxPanel:get("txtTip"), {
			vertical = "center",
			horizontal = "center",
			size = cc.size(arg_24_0.advanceMaxPanel:width() - 150, 200)
		})
		adapt.setTextAdaptWithSize(var_24_2.txtTip, {
			vertical = "center",
			horizontal = "center",
			size = cc.size(arg_24_0.advancePanel:width() - 150, 200)
		})
		adapt.setTextAdaptWithSize(var_24_2.txtLvTip, {
			vertical = "center",
			horizontal = "center",
			size = cc.size(arg_24_0.advancePanel:width() - 150, 200)
		})

		if arg_24_0.level:read() < gCardEffortAdvance[var_24_1.effortSeqID][arg_24_0.effortAdvance:read() + 1].needLevel then
			local var_24_3 = 270

			var_24_2.txtAdvance:y(var_24_3)
			var_24_2.icon1:y(var_24_3)
			var_24_2.icon2:y(var_24_3)
			var_24_2.txtTip:y(arg_24_0.advancePanel:get("txtAdvance"):y() - 65)
			var_24_2.txtLvTip:y(arg_24_0.advancePanel:get("txtTip"):y() - 69)
		end
	end
end

function var_0_3.onTrainClick(arg_25_0, arg_25_1)
	if arg_25_0.curState:read() <= var_0_0.ONE then
		local var_25_0 = arg_25_1 == var_0_1.ONE and 1 or arg_25_0.times:read()

		if arg_25_0.times:read() == 0 then
			gGameUI:showTip(gLanguageCsv.effortMaterialNotEnough)

			return
		end

		gGameApp:requestServer("/game/card/effort/train", function(arg_26_0)
			arg_25_0:request(arg_26_0)
		end, arg_25_0.selectDbId, arg_25_0.trainIndex, var_25_0)
	elseif arg_25_1 == var_0_1.ONE then
		if arg_25_0.curState:read() ~= var_0_0.SAVE then
			arg_25_0.curState:set(arg_25_0.originState)
		else
			gGameUI:showTip(gLanguageCsv.effortNotCancel)
		end
	else
		arg_25_0:saveTrain()
	end
end

function var_0_3.onCustomClick(arg_27_0)
	if arg_27_0.times:read() == 0 then
		gGameUI:showTip(gLanguageCsv.effortMaterialNotEnough)

		return
	end

	local var_27_0
	local var_27_1

	for iter_27_0, iter_27_1 in ipairs(arg_27_0.currCost:read()) do
		if iter_27_1.id ~= "gold" then
			local var_27_2 = arg_27_0.trainIndex:read()
			local var_27_3 = dataEasy.getNumByKey(iter_27_1.id)
			local var_27_4 = math.min(math.floor(var_27_3 / iter_27_1.num), 100)
			local var_27_5 = arg_27_0.selectDbId:read()

			gGameUI:stackUI("city.card.effortvalue_custom", nil, nil, arg_27_0.trainIndex:read(), iter_27_1.id, var_27_4, var_27_5, arg_27_0:createHandler("request"))
		end
	end
end

function var_0_3.onTrainSelectClick(arg_28_0, arg_28_1)
	arg_28_0.trainIndex:set(arg_28_1)
end

function var_0_3.request(arg_29_0, arg_29_1)
	arg_29_0.selectDatas:update(arg_29_1.view.result)

	if #arg_29_1.view.result == 1 then
		local var_29_0 = true
		local var_29_1 = 0

		for iter_29_0, iter_29_1 in pairs(arg_29_1.view.result[1]) do
			local var_29_2 = iter_29_1

			if arg_29_0.attrShowIndex[iter_29_0] then
				local var_29_3 = arg_29_0.tabDatas:atproxy(arg_29_0.attrShowIndex[iter_29_0])

				var_29_2 = cc.clampf(var_29_2, var_29_3.totalVal - var_29_3.currVal, var_29_3.maxVal + var_29_3.totalVal - var_29_3.currVal)
			end

			var_29_1 = var_29_1 + var_29_2

			if var_29_2 < 0 then
				var_29_0 = false
			end
		end

		if var_29_1 <= 0 then
			var_29_0 = false
		end

		arg_29_0.trainType:set(var_0_1.ONE)
		arg_29_0.curState:set(var_29_0 and var_0_0.SAVE or var_0_0.SAVE_AND_CANCEL)
		arg_29_0.listIndexs:set({
			[0] = true
		}, true)

		if arg_29_0.selectPanel:isVisible() then
			local var_29_4 = userDefault.getForeverLocalKey("attrRecommondedState")

			arg_29_0:onBtnAttr(var_29_4)
		end
	else
		arg_29_0.trainType:set(var_0_1.TEN)

		arg_29_0.sign = true

		arg_29_0.curState:set(var_0_0.SAVE_AND_CANCEL)

		local var_29_5 = userDefault.getForeverLocalKey("attrRecommondedState")

		arg_29_0:onBtnAttr(var_29_5)
	end
end

function var_0_3.saveTrain(arg_30_0)
	idlereasy.do_(function(arg_31_0)
		local var_31_0 = {}

		for iter_31_0, iter_31_1 in pairs(arg_31_0) do
			if iter_31_1 then
				table.insert(var_31_0, iter_31_0)
			end
		end

		if #var_31_0 == 0 then
			gGameUI:showTip(gLanguageCsv.firstChooseNeedAttr)
		else
			gGameApp:requestServer("/game/card/effort/save", function(arg_32_0)
				arg_30_0.curState:set(arg_30_0.originState)
			end, arg_30_0.selectDbId, var_31_0)
		end
	end, arg_30_0.listIndexs)
end

function var_0_3.onMaskClick(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0.trainType:read() == var_0_1.ONE then
		gGameUI:showTip(gLanguageCsv.effortValueOneMask)
	else
		if arg_33_0.validAreas then
			local var_33_0 = false

			for iter_33_0, iter_33_1 in ipairs(arg_33_0.validAreas) do
				if cc.rectContainsPoint(iter_33_1, cc.p(arg_33_2.x, arg_33_2.y)) then
					var_33_0 = true

					break
				end
			end

			if not var_33_0 then
				return
			end
		end

		gGameUI:showDialog({
			btnType = 2,
			strs = gLanguageCsv.effortCancel,
			cb = function()
				arg_33_0.curState:set(arg_33_0.originState)
			end
		})
	end
end

function var_0_3.onItemClick(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_0.selectDatas:atproxy(arg_35_2).selected = not arg_35_0.selectDatas:atproxy(arg_35_2).selected

	arg_35_0.listIndexs:modify(function(arg_36_0)
		arg_36_0[arg_35_2 - 1] = arg_35_0.selectDatas:atproxy(arg_35_2).selected

		return true, arg_36_0
	end, true)
end

function var_0_3.onBtnAttr(arg_37_0, arg_37_1)
	arg_37_0.btnAttrSelected = not arg_37_0.btnAttrSelected

	if arg_37_1 ~= nil then
		arg_37_0.btnAttrSelected = arg_37_1
	end

	userDefault.setForeverLocalKey("attrRecommondedState", arg_37_0.btnAttrSelected)
	arg_37_0.btnAttr:texture(arg_37_0.btnAttrSelected == true and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")

	for iter_37_0 = 1, itertools.size(arg_37_0.selectDatas) do
		if arg_37_0.selectDatas:atproxy(iter_37_0) then
			local var_37_0 = arg_37_0.selectDatas:atproxy(iter_37_0)
			local var_37_1 = 0

			for iter_37_1, iter_37_2 in pairs(var_37_0) do
				if iter_37_1 ~= "selected" then
					var_37_1 = var_37_1 + iter_37_2 * gCommonConfigCsv["attr" .. string.caption(iter_37_1)]
				end
			end

			if var_37_1 > 0 then
				arg_37_0.selectDatas:atproxy(iter_37_0).selected = arg_37_0.btnAttrSelected

				arg_37_0.listIndexs:modify(function(arg_38_0)
					arg_38_0[iter_37_0 - 1] = arg_37_0.selectDatas:atproxy(iter_37_0).selected

					return true, arg_38_0
				end, true)
			end
		end
	end
end

function var_0_3.onAddClick(arg_39_0)
	local var_39_0, var_39_1 = next(arg_39_0.currCost:read())

	jumpEasy.jumpTo("gainWay", var_39_1.id)
end

function var_0_3.onAdvanceClick(arg_40_0)
	local var_40_0 = csv.cards[arg_40_0.cardId:read()]
	local var_40_1 = arg_40_0.selectDbId:read()
	local var_40_2 = gCardEffortAdvance[var_40_0.effortSeqID][arg_40_0.effortAdvance:read() + 1].needLevel

	if var_40_2 > arg_40_0.level:read() then
		gGameUI:showTip(string.format(gLanguageCsv.needSpriteLevelArrival, var_40_2))

		return
	end

	local var_40_3 = gGameModel.cards:find(var_40_1):read("fighting_point")
	local var_40_4 = {
		false
	}

	gGameApp:requestServerCustom("/game/card/effort/advance"):params(arg_40_0.selectDbId):onResponse(function(arg_41_0)
		var_40_4[1] = true
	end):wait(var_40_4):doit(function(arg_42_0)
		gGameUI:stackUI("city.card.common_success", nil, {
			blackLayer = true
		}, var_40_1, var_40_3, {
			effortAdvance = arg_40_0.effortAdvance:read()
		})
	end)
end

function var_0_3.onBtnDetailClick(arg_43_0)
	gGameUI:stackUI("city.card.effortvalue_detail", nil, nil, arg_43_0.effortAdvance:read(), arg_43_0.cardId:read())
end

return var_0_3
