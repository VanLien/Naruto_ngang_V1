local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.adventure.random_tower.tools")
local var_0_2 = class("RandomTowerJumpView", Dialog)
local var_0_3 = {
	ALL = "ALL",
	ONCE = "ONCE"
}

var_0_2.RESOURCE_FILENAME = "random_tower_jump.json"
var_0_2.RESOURCE_BINDING = {
	panel2 = "panel2",
	panel3 = "panel3",
	["panel2.item"] = "item2",
	["panel4.item"] = "item4",
	["panel1.item"] = "awardItem",
	panel4 = "panel4",
	["panel3.item"] = "item3",
	panel1 = "panel1",
	["panel1.subList"] = "awardList",
	progressPanel = "progressPanel",
	["title.textTitle1"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["title.textTitle2"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	["panel2.sortPanel"] = {
		varname = "sortPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				btnType = 4,
				expandUp = true,
				data = bindHelper.self("sortDatas"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_1_0)
					arg_1_0:xy(-1125, -477):z(18)
					arg_1_0.btn4:setColor(cc.c3b(255, 255, 255))
				end
			}
		}
	},
	["panel2.btnOpenAll"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOpenAll")
			}
		}
	},
	["panel2.textTitle"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("boxesCount"),
			method = function(arg_2_0)
				return string.format(gLanguageCsv.randomTowerJumpBoxesCount, arg_2_0)
			end
		}
	},
	["panel2.subList"] = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 24,
				asyncPreload = 4,
				data = bindHelper.self("boxData"),
				item = bindHelper.self("item2"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_3_0, arg_3_1)
					local var_3_0 = csv.random_tower.board[arg_3_0.boardID]
					local var_3_1 = csv.random_tower.tower[var_3_0.room]
					local var_3_2 = csv.random_tower.board[arg_3_1.boardID]
					local var_3_3 = csv.random_tower.tower[var_3_2.room]
					local var_3_4 = gCommonConfigCsv.randomTowerBoxLimit2

					if arg_3_0.times == arg_3_1.times then
						if var_3_1.floor == var_3_3.floor then
							return var_3_1.roomIdx < var_3_3.roomIdx
						else
							return var_3_1.floor < var_3_3.floor
						end

						return false
					elseif arg_3_0.times == var_3_4 then
						return false
					elseif arg_3_1.times == var_3_4 then
						return true
					else
						if var_3_1.floor == var_3_3.floor then
							return var_3_1.roomIdx < var_3_3.roomIdx
						else
							return var_3_1.floor < var_3_3.floor
						end

						return false
					end
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = gCommonConfigCsv.randomTowerBoxLimit2

					arg_4_1:get("imgGotten"):setVisible(arg_4_3.times == var_4_0)

					if arg_4_3.times == var_4_0 then
						nodetools.invoke(arg_4_1, {
							"imgGotten",
							"textBox"
						}, "show")
						nodetools.invoke(arg_4_1, {
							"btn1",
							"btn2",
							"imgDiamond1",
							"imgDiamond2",
							"textDiamond1",
							"textDiamond2"
						}, "hide")
					else
						nodetools.invoke(arg_4_1, {
							"imgGotten",
							"textBox"
						}, "hide")
						nodetools.invoke(arg_4_1, {
							"btn1",
							"btn2",
							"imgDiamond1",
							"imgDiamond2",
							"textDiamond1",
							"textDiamond2"
						}, "show")

						local var_4_1 = gCostCsv.random_tower_box_cost2
						local var_4_2 = var_4_1[math.min(arg_4_3.times + 2, table.length(var_4_1))]
						local var_4_3 = 0

						for iter_4_0 = arg_4_3.times + 2, var_4_0 + 1 do
							if var_4_1[iter_4_0] then
								var_4_3 = var_4_3 + var_4_1[iter_4_0]
							else
								var_4_3 = var_4_3 + var_4_1[table.length(var_4_1)]
							end
						end

						arg_4_1:get("textDiamond1"):text(var_4_2)
						arg_4_1:get("textDiamond2"):text(var_4_3)

						local var_4_4 = arg_4_1:get("btn1")

						bind.touch(arg_4_0, var_4_4, {
							methods = {
								ended = function()
									if gGameModel.role:read("rmb") < var_4_2 then
										uiEasy.showDialog("rmb")
									else
										gGameApp:requestServer("/game/random_tower/jump/box_open", function(arg_6_0)
											gGameUI:showGainDisplay(arg_6_0)
										end, arg_4_3.boardID, "open1")
									end
								end
							}
						})

						local var_4_5 = arg_4_1:get("btn2")

						var_4_5:get("textNote"):text(string.format(gLanguageCsv.openBoxesTimes, var_4_0 - arg_4_3.times))
						bind.touch(arg_4_0, var_4_5, {
							methods = {
								ended = function()
									if gGameModel.role:read("rmb") < var_4_3 then
										uiEasy.showDialog("rmb")
									else
										gGameApp:requestServer("/game/random_tower/jump/box_open", function(arg_8_0)
											gGameUI:showGainDisplay(arg_8_0)
										end, arg_4_3.boardID, "open5")
									end
								end
							}
						})
					end

					local var_4_6 = csv.random_tower.board[arg_4_3.boardID]

					arg_4_1:get("imgBox"):texture(var_4_6.icon)

					local var_4_7 = csv.random_tower.tower[var_4_6.room]

					arg_4_1:get("textRoom"):text(string.format(gLanguageCsv.randomTowerFloorAndRoom, var_4_7.floor, var_4_7.roomIdx))
				end,
				onAfterBuild = function(arg_9_0)
					arg_9_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickBtn1 = bindHelper.self("onBoxClick1"),
				clickBtn2 = bindHelper.self("onBoxClick2")
			}
		}
	},
	["panel2.item.btn1.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.WHITE
					}
				}
			}
		}
	},
	["panel2.item.btn2.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				}
			}
		}
	},
	["panel2.textDiamond"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("openAllBoxesCost")
		}
	},
	["panel3.btnRandom"] = {
		binds = {
			event = "touch",
			methods = {
				ended = function()
					gGameApp:requestServer("/game/random_tower/jump/buff", function(arg_11_0)
						return
					end, 0)
				end
			}
		}
	},
	["panel3.subList"] = {
		varname = "list3",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 24,
				asyncPreload = 4,
				data = bindHelper.self("bufData"),
				item = bindHelper.self("item3"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
					local var_12_0 = csv.random_tower.buffs[arg_12_3]
					local var_12_1 = var_12_0.desc
					local var_12_2 = var_12_0.icon
					local var_12_3 = var_12_0.iconBg

					arg_12_1:get("iconBg"):texture(var_12_3)
					arg_12_1:get("icon"):texture(var_12_2)
					beauty.textScroll({
						fontSize = 34,
						align = "center",
						effect = {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.WHITE1
							}
						},
						list = arg_12_1:get("desc"),
						strs = var_12_1
					})
					bind.touch(arg_12_0, arg_12_1, {
						methods = {
							ended = function()
								gGameApp:requestServer("/game/random_tower/jump/buff", function(arg_14_0)
									return
								end, arg_12_2)
							end
						}
					})

					local var_12_4 = {
						gLanguageCsv.randomTowerJumpBUff1,
						gLanguageCsv.randomTowerJumpBUff2,
						gLanguageCsv.randomTowerJumpBUff3,
						gLanguageCsv.randomTowerJumpBUff4
					}

					arg_12_1:get("name"):text(var_12_4[var_12_0.buffType])
				end,
				onAfterBuild = function(arg_15_0)
					arg_15_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickBtn1 = bindHelper.self("onClickBuff")
			}
		}
	},
	["panel4.subList"] = {
		varname = "list4",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 24,
				asyncPreload = 4,
				data = bindHelper.self("eventData"),
				item = bindHelper.self("item4"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_16_0, arg_16_1)
					local var_16_0 = csv.random_tower.board[arg_16_0.boardID]
					local var_16_1 = csv.random_tower.tower[var_16_0.room]
					local var_16_2 = csv.random_tower.board[arg_16_1.boardID]
					local var_16_3 = csv.random_tower.tower[var_16_2.room]
					local var_16_4 = arg_16_0.data[2]
					local var_16_5 = arg_16_1.data[2]

					if var_16_4 == var_16_5 then
						if var_16_1.floor == var_16_3.floor then
							return var_16_1.roomIdx < var_16_3.roomIdx
						else
							return var_16_1.floor < var_16_3.floor
						end

						return false
					elseif var_16_4 == 1 then
						return false
					elseif var_16_5 == 1 then
						return true
					else
						if var_16_1.floor == var_16_3.floor then
							return var_16_1.roomIdx < var_16_3.roomIdx
						else
							return var_16_1.floor < var_16_3.floor
						end

						return false
					end
				end,
				onItem = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
					local var_17_0 = arg_17_3.data[1]
					local var_17_1 = arg_17_3.data[2]
					local var_17_2 = csv.random_tower.event[var_17_0]
					local var_17_3 = var_17_2.desc
					local var_17_4 = var_17_2.icon
					local var_17_5 = csv.random_tower.board[arg_17_3.boardID]
					local var_17_6 = csv.random_tower.tower[var_17_5.room]
					local var_17_7 = var_17_6.floor
					local var_17_8 = var_17_6.roomIdx

					arg_17_1:get("name"):text(string.format(gLanguageCsv.randomTowerFloorAndRoom, var_17_7, var_17_8))
					arg_17_1:get("imgCheck"):setVisible(var_17_1 ~= 0)
					beauty.textScroll({
						fontSize = 34,
						align = "center",
						effect = {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.WHITE1
							}
						},
						list = arg_17_1:get("desc"),
						strs = var_17_3
					})

					if var_17_1 == 0 then
						bind.touch(arg_17_0, arg_17_1, {
							methods = {
								ended = function()
									if var_17_2.choice1 == "" then
										gGameUI:stackUI("city.adventure.random_tower.event_reward", nil, {
											clickClose = true
										}, {
											boardID = arg_17_3.boardID,
											eventId = var_17_0
										})
									else
										gGameUI:stackUI("city.adventure.random_tower.select_event", nil, {
											clickClose = true
										}, arg_17_3.boardID, nil, var_17_0)
									end
								end
							}
						})
					else
						arg_17_1:setEnabled(false)
					end
				end,
				onAfterBuild = function(arg_19_0)
					arg_19_0:setItemAlignCenter()
				end
			}
		}
	},
	btnNext = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("requestNext")
			}
		}
	},
	["btnNext.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["panel2.btnOpenAll.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["panel3.btnRandom.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0:initModel()

	arg_20_0.cb = arg_20_2
	arg_20_0.jumpData = arg_20_1

	idlereasy.any({
		arg_20_0.jumpStep,
		arg_20_0.jumpInfo
	}, function(arg_21_0, arg_21_1, arg_21_2)
		if arg_21_1 == game.RANDOM_TOWER_JUMP_STATE.POINT then
			arg_20_0.panel1:show()
		elseif arg_21_1 == game.RANDOM_TOWER_JUMP_STATE.BOX then
			arg_20_0.panel1:hide()
			arg_20_0.panel2:show()
		elseif arg_21_1 == game.RANDOM_TOWER_JUMP_STATE.BUFF then
			arg_20_0.panel2:hide()
			arg_20_0.panel3:show()
		elseif arg_21_1 == game.RANDOM_TOWER_JUMP_STATE.EVENT then
			arg_20_0.panel3:hide()
			arg_20_0.panel4:show()
		end

		if arg_21_1 <= game.RANDOM_TOWER_JUMP_STATE.EVENT then
			arg_20_0["refreshPanel" .. arg_21_1 .. "Data"](arg_20_0, arg_21_2)
			arg_20_0:refreshProgressPanel(arg_21_1)
		end
	end)
	idlereasy.when(arg_20_0.jumpStep, function(arg_22_0, arg_22_1)
		if arg_22_1 == game.RANDOM_TOWER_JUMP_STATE.OVER then
			arg_20_0:addCallbackOnExit(arg_20_0.cb)
			var_0_0.onClose(arg_20_0)
		end
	end)
	Dialog.onCreate(arg_20_0)
end

function var_0_2.onClose(arg_23_0)
	return
end

function var_0_2.initModel(arg_24_0)
	arg_24_0.jumpStep = gGameModel.random_tower:getIdler("jump_step")
	arg_24_0.jumpInfo = gGameModel.random_tower:getIdler("jump_info")
	arg_24_0.boxData = idlers.newWithMap({})
	arg_24_0.openAllBoxesCost = idler.new(0)
	arg_24_0.boxesCount = idler.new(0)
	arg_24_0.bufData = idlertable.new({})
	arg_24_0.bufRoomIndex = idler.new(0)
	arg_24_0.eventData = idlers.newWithMap({})

	local var_24_0 = {
		gLanguageCsv.randomTowerOpenAll,
		gLanguageCsv.randomTowerOpenOnce
	}

	arg_24_0.sortDatas = idlertable.new(var_24_0)
	arg_24_0.openTimes = idler.new(var_0_3.ALL)
end

function var_0_2.refreshOpenAllBoxesCost(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = gCommonConfigCsv.randomTowerBoxLimit2
	local var_25_1 = gCostCsv.random_tower_box_cost2
	local var_25_2 = 0

	if arg_25_2 == var_0_3.ONCE then
		for iter_25_0, iter_25_1 in pairs(arg_25_1) do
			if var_25_1[iter_25_1 + 2] and iter_25_1 <= var_25_0 - 1 then
				var_25_2 = var_25_2 + var_25_1[iter_25_1 + 2]
			end
		end
	else
		for iter_25_2, iter_25_3 in pairs(arg_25_1) do
			for iter_25_4 = iter_25_3 + 2, var_25_0 + 1 do
				if var_25_1[iter_25_4] then
					var_25_2 = var_25_2 + var_25_1[iter_25_4]
				else
					var_25_2 = var_25_2 + var_25_1[table.length(var_25_1)]
				end
			end
		end
	end

	arg_25_0.openAllBoxesCost:set(var_25_2)
end

function var_0_2.refreshPanel1Data(arg_26_0)
	arg_26_0.panel1:show()
	arg_26_0:initRichPanel()
	arg_26_0:initAward()
end

function var_0_2.refreshPanel2Data(arg_27_0, arg_27_1)
	arg_27_0.panel1:hide()
	arg_27_0.panel2:show()

	local var_27_0 = {}
	local var_27_1 = arg_27_1.boxes or {}

	for iter_27_0, iter_27_1 in pairs(var_27_1) do
		table.insert(var_27_0, {
			boardID = iter_27_0,
			times = iter_27_1
		})
	end

	arg_27_0.boxData:update(var_27_0)
	arg_27_0.boxesCount:set(itertools.size(var_27_1))
	idlereasy.when(arg_27_0.openTimes, function(arg_28_0, arg_28_1)
		arg_27_0:refreshOpenAllBoxesCost(var_27_1, arg_28_1)
	end)
end

function var_0_2.refreshPanel3Data(arg_29_0, arg_29_1)
	arg_29_0.panel2:hide()
	arg_29_0.panel3:show()

	local var_29_0 = arg_29_1.buffs

	if arg_29_1.buff_index and var_29_0 and var_29_0[arg_29_1.buff_index] then
		local var_29_1 = var_29_0[arg_29_1.buff_index]

		arg_29_0.bufData:set(var_29_1)
		arg_29_0.bufRoomIndex:set(arg_29_1.buff_index)
		arg_29_0:refreshBuffIndex()
	else
		arg_29_0.bufData:set({})
	end
end

function var_0_2.refreshPanel4Data(arg_30_0, arg_30_1)
	arg_30_0.panel3:hide()
	arg_30_0.panel4:show()

	local var_30_0 = {}
	local var_30_1 = arg_30_1.events or {}

	for iter_30_0, iter_30_1 in pairs(var_30_1) do
		table.insert(var_30_0, {
			boardID = iter_30_0,
			data = iter_30_1
		})
	end

	arg_30_0.eventData:update(var_30_0)
end

function var_0_2.getPanel1Str(arg_31_0)
	local var_31_0 = {
		"",
		"",
		"",
		""
	}
	local var_31_1 = var_0_1.getCanJumpMaxRoom()

	if var_31_1 <= 1 then
		var_31_0[1] = ""
	else
		local var_31_2 = csv.random_tower.tower[var_31_1]
		local var_31_3 = gLanguageCsv.randomTowerJumpTips1

		var_31_0[1] = string.format(var_31_3, var_31_2.floor, var_31_2.roomIdx)
	end

	local var_31_4 = arg_31_0.jumpInfo:read()
	local var_31_5 = gLanguageCsv.randomTowerJumpTips2

	var_31_0[2] = string.format(var_31_5, arg_31_0.jumpData.battle, arg_31_0.jumpData.points)

	local var_31_6 = var_31_4.buffs or {}
	local var_31_7 = itertools.size(var_31_6)
	local var_31_8 = var_31_4.events or {}
	local var_31_9 = itertools.size(var_31_8)
	local var_31_10 = gLanguageCsv.randomTowerJumpTips3

	var_31_0[3] = string.format(var_31_10, var_31_7, var_31_9)

	local var_31_11 = var_31_4.boxes or {}
	local var_31_12 = itertools.size(var_31_11)
	local var_31_13 = gLanguageCsv.randomTowerJumpTips4

	var_31_0[4] = string.format(var_31_13, arg_31_0.jumpData.generalBoxes, var_31_12)

	return var_31_0
end

function var_0_2.initRichPanel(arg_32_0)
	local var_32_0 = arg_32_0:getPanel1Str()

	for iter_32_0, iter_32_1 in ipairs(var_32_0) do
		local var_32_1 = rich.createByStr(iter_32_1, 50):addTo(arg_32_0.panel1, 10):setAnchorPoint(cc.p(0, 0.5)):xy(cc.p(80, 1082 - 90 * iter_32_0)):formatText()
	end
end

function var_0_2.initAward(arg_33_0)
	local var_33_0 = arg_33_0.jumpData.award

	bind.extend(arg_33_0, arg_33_0.awardList, {
		class = "listview",
		props = {
			data = dataEasy.getItemData(var_33_0),
			item = arg_33_0.awardItem,
			dataOrderCmp = dataEasy.sortItemCmp,
			itemAction = {
				isAction = true
			},
			onAfterBuild = function()
				arg_33_0.awardList:setItemAlignCenter()
				arg_33_0.awardList:adaptTouchEnabled()
			end,
			onItem = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				bind.extend(arg_35_0, arg_35_1, {
					class = "icon_key",
					props = {
						data = arg_35_3,
						grayState = arg_35_3.grayState
					}
				})
			end
		}
	})
end

function var_0_2.requestNext(arg_36_0)
	local var_36_0 = arg_36_0.jumpStep:read()
	local var_36_1 = arg_36_0.jumpInfo:read()
	local var_36_2 = ""

	if var_36_0 == game.RANDOM_TOWER_JUMP_STATE.BOX then
		if arg_36_0.openAllBoxesCost:read() ~= 0 then
			var_36_2 = gLanguageCsv.randomTowerJumpNextTips1
		end
	elseif var_36_0 == game.RANDOM_TOWER_JUMP_STATE.BUFF then
		local var_36_3 = var_36_1.buff_index or 0
		local var_36_4 = var_36_1.buffs or {}

		if var_36_3 < itertools.size(var_36_4) then
			var_36_2 = gLanguageCsv.randomTowerJumpNextTips2
		end
	elseif var_36_0 == game.RANDOM_TOWER_JUMP_STATE.EVENT then
		local var_36_5 = var_36_1.events or {}

		for iter_36_0, iter_36_1 in pairs(var_36_5) do
			if iter_36_1[2] == 0 then
				var_36_2 = gLanguageCsv.randomTowerJumpNextTips3

				break
			end
		end
	end

	if var_36_2 ~= "" then
		gGameUI:showDialog({
			btnType = 2,
			title = gLanguageCsv.spaceTips,
			content = var_36_2,
			cb = function()
				gGameApp:requestServer("/game/random_tower/jump/next")
			end
		})
	else
		gGameApp:requestServer("/game/random_tower/jump/next")
	end
end

function var_0_2.refreshProgressPanel(arg_38_0, arg_38_1)
	local var_38_0 = {}
	local var_38_1 = {}
	local var_38_2 = {}

	for iter_38_0 = 2, 4 do
		if iter_38_0 <= arg_38_1 then
			table.insert(var_38_0, "img" .. iter_38_0)
			table.insert(var_38_1, "imgBar" .. iter_38_0)
			table.insert(var_38_2, "text" .. iter_38_0)
		end
	end

	local var_38_3 = arg_38_0.progressPanel

	nodetools.invoke(var_38_3, var_38_0, "texture", "city/adventure/random_tower/bar_d.png")
	nodetools.invoke(var_38_3, var_38_1, "texture", "city/adventure/random_tower/bar_dt.png")
	nodetools.invoke(var_38_3, var_38_2, "setTextColor", ui.NEWCOLORS.ORANGE)
end

function var_0_2.refreshBuffIndex(arg_39_0)
	local var_39_0 = gLanguageCsv.randomTowerJumpBuffTips
	local var_39_1 = arg_39_0.bufRoomIndex:read() or 0
	local var_39_2 = arg_39_0.jumpInfo:read().buffs or {}
	local var_39_3 = itertools.size(var_39_2)
	local var_39_4 = 0
	local var_39_5 = 0

	for iter_39_0, iter_39_1 in pairs(var_39_2[var_39_1]) do
		local var_39_6 = csv.random_tower.board[iter_39_0]
		local var_39_7 = csv.random_tower.tower[var_39_6.room]

		var_39_4 = var_39_7.floor
		var_39_5 = var_39_7.roomIdx

		break
	end

	local var_39_8 = string.format(var_39_0, var_39_4, var_39_5, var_39_1, var_39_3)
	local var_39_9 = arg_39_0.panel3:get("textTips"):hide()

	arg_39_0.panel3:removeChildByName("richTips")
	rich.createByStr(var_39_8, 50):addTo(arg_39_0.panel3, 10):setAnchorPoint(cc.p(0.5, 0.5)):xy(var_39_9:xy()):formatText():setName("richTips")
end

function var_0_2.onClickOpenAll(arg_40_0)
	if arg_40_0.openAllBoxesCost:read() == 0 then
		return
	end

	if gGameModel.role:read("rmb") < arg_40_0.openAllBoxesCost:read() then
		uiEasy.showDialog("rmb")
	else
		local var_40_0 = {
			false
		}

		if arg_40_0.openTimes:read() == var_0_3.ONCE then
			gGameApp:requestServerCustom("/game/random_tower/jump/box_open"):params(0, "open1"):onResponse(function(arg_41_0)
				var_40_0[1] = true
			end):wait(var_40_0):doit(function(arg_42_0)
				gGameUI:showGainDisplay(arg_42_0)
			end)
		else
			gGameApp:requestServerCustom("/game/random_tower/jump/box_open"):params(0, "open5"):onResponse(function(arg_43_0)
				var_40_0[1] = true
			end):wait(var_40_0):doit(function(arg_44_0)
				gGameUI:showGainDisplay(arg_44_0)
			end)
		end
	end
end

function var_0_2.onClickBufRandom(arg_45_0)
	local var_45_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/random_tower/jump/buff"):params(0):onResponse(function(arg_46_0)
		var_45_0[1] = true
	end):wait(var_45_0):doit(function(arg_47_0)
		return
	end)
end

function var_0_2.onClickbuff(arg_48_0, arg_48_1)
	local var_48_0 = {
		false
	}

	gGameApp:requestServerCustom("/game/random_tower/jump/buff"):params(arg_48_1):onResponse(function(arg_49_0)
		var_48_0[1] = true
	end):wait(var_48_0):doit(function(arg_50_0)
		gGameUI:showTip("buf2")
	end)
end

function var_0_2.onSortMenusBtnClick(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	if arg_51_3 == 1 then
		arg_51_0.openTimes:set(var_0_3.ALL)
	else
		arg_51_0.openTimes:set(var_0_3.ONCE)
	end
end

return var_0_2
