local var_0_0 = require("app.views.city.activity.grid_walk.tools")
local var_0_1 = {
	run = "run",
	stand = "stand"
}
local var_0_2 = {
	[0] = "effect_huang1",
	nil,
	nil,
	"effect_lv1",
	"effect_zi1"
}
local var_0_3 = {
	[0] = "effect_huang2",
	nil,
	nil,
	"effect_lv2",
	"effect_zi2"
}
local var_0_4 = {
	[var_0_0.DICE_ID[1]] = "effect_2_",
	[var_0_0.DICE_ID[2]] = "effect_1_",
	[var_0_0.DICE_ID[3]] = "effect_3_"
}
local var_0_5 = {
	var_0_0.ITEMS.normanlDice,
	var_0_0.ITEMS.strangeDice,
	var_0_0.ITEMS.medalDice,
	var_0_0.ITEMS.randomCard,
	var_0_0.ITEMS.voucher,
	var_0_0.ITEMS.sprintCard,
	var_0_0.ITEMS.steeringCard
}
local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("GridWalkView", var_0_6)

var_0_7.RESOURCE_FILENAME = "grid_walk.json"
var_0_7.RESOURCE_BINDING = {
	item1 = "item1",
	downPanel = "downPanel",
	["mapPanel.npcPanel"] = "npcPanel",
	["mapPanel.npcPanel.leftStepsToBox"] = "leftStepsToBox",
	["mapPanel.mapTouchClose"] = "mapTouchClose",
	["leftPanel.oneLine.list"] = "historyOneList",
	treasuresPanel = "treasuresPanel",
	item = "item",
	itemPanel = "itemPanel",
	["mapPanel.spinePanel"] = "spinePanel",
	["mapPanel.npcPanel.leftSteps"] = "leftSteps",
	tipPanel = "tipPanel",
	["leftPanel.allLine"] = "allLine",
	["rightPanel.diceInfo.touchClose"] = "touchClose",
	showDicePanel = "showDicePanel",
	["mapPanel.eventInfo"] = "eventInfo",
	["leftPanel.oneLine"] = "oneLine",
	leftPanel = "leftPanel",
	["leftPanel.allLine.list"] = "historyList",
	["rightPanel.diceInfo"] = "diceInfo",
	["mapPanel.geziPanel"] = "geziPanel",
	touchPanel = "touchPanel",
	mapPanel = "mapPanel",
	rightPanel = "rightPanel",
	["leftPanel.time"] = {
		varname = "showTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["tipPanel.txt"] = {
		varname = "tipPanelTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = ui.COLORS.NORMAL.BLACK
				}
			}
		}
	},
	["item.jump.add"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(212, 102, 12)
				}
			}
		}
	},
	["item.jump.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(212, 102, 12)
				}
			}
		}
	},
	["LeftDownPanel.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["LeftDownPanel.btnTask.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["LeftDownPanel.btnBag.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.DEFAULT
				}
			}
		}
	},
	["mapPanel.npcPanel.leftSteps.txt1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["mapPanel.npcPanel.leftSteps.txt2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["mapPanel.npcPanel.leftSteps.step"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["mapPanel.npcPanel.leftStepsToBox.txt1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["mapPanel.npcPanel.leftStepsToBox.txt2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["mapPanel.npcPanel.leftStepsToBox.txt3"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["mapPanel.npcPanel.leftStepsToBox.step"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["LeftDownPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["LeftDownPanel.btnTask"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onTaskClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "gridWalkMain",
					onNode = function(arg_1_0)
						arg_1_0:xy(150, 210)
					end
				}
			}
		}
	},
	["LeftDownPanel.btnBag"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBagClick")
			}
		}
	},
	["leftPanel.oneLine.img"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_2_0)
				return arg_2_0:onHistoryClick(1)
			end)
		}
	},
	["leftPanel.allLine.selectPanel"] = {
		binds = {
			event = "click",
			method = bindHelper.defer(function(arg_3_0)
				return arg_3_0:onHistoryClick(2)
			end)
		}
	},
	["rightPanel.btnDice.icon"] = {
		varname = "btnDiceIcon",
		binds = {
			event = "texture",
			idler = bindHelper.self("diceIcon")
		}
	},
	["rightPanel.btnDice"] = {
		varname = "btnDice",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDiceClick")
			}
		}
	},
	["rightPanel.btnDice1"] = {
		varname = "btnDice1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					return arg_4_0:onDiceClick(1)
				end)
			}
		}
	},
	["rightPanel.btnDice2"] = {
		varname = "btnDice2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					return arg_5_0:onDiceClick(2)
				end)
			}
		}
	},
	["rightPanel.btnDice3"] = {
		varname = "btnDice3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					return arg_6_0:onDiceClick(3)
				end)
			}
		}
	},
	["downPanel.card1"] = {
		varname = "card1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0:onCardClick(1)
				end)
			}
		}
	},
	["downPanel.card2"] = {
		varname = "card2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_8_0)
					return arg_8_0:onCardClick(2)
				end)
			}
		}
	},
	["downPanel.card3"] = {
		varname = "card3",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_9_0)
					return arg_9_0:onCardClick(3)
				end)
			}
		}
	},
	["showDicePanel.step"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	}
}

function var_0_7.onCreate(arg_10_0)
	arg_10_0:initModel()
	gGameUI.topuiManager:createView("grid_walk", arg_10_0, {
		onClose = arg_10_0:createHandler("onClose")
	}):init({
		title = "common/txt/txt_bt_maoxian.png",
		subTitle = "CRAZY ADVENTURE",
		iconNum = arg_10_0.iconNum
	})
	arg_10_0:initMap()
	arg_10_0:initNpc()
	arg_10_0:initItems()
	arg_10_0:initHistory()
	arg_10_0:initTouchListener()
	arg_10_0.mapPanel:setScrollBarEnabled(false)
	arg_10_0.historyOneList:setScrollBarEnabled(false)
	arg_10_0.historyList:setScrollBarEnabled(false)
	idlereasy.when(arg_10_0.nowTowardsUp, function(arg_11_0, arg_11_1)
		arg_10_0:updateNpcTowardsUp()
		arg_10_0:updateJumpGezi(arg_11_1)
		arg_10_0:updateLeftStepsToBox()
	end)
	idlereasy.when(arg_10_0.showHistory, function(arg_12_0, arg_12_1)
		arg_10_0.oneLine:visible(not arg_12_1)
		arg_10_0.allLine:visible(arg_12_1)
	end)
	idlereasy.any({
		arg_10_0.selectedDice,
		arg_10_0.updateDice
	}, function(arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = {}

		for iter_13_0, iter_13_1 in ipairs(arg_10_0.diceTable) do
			iter_13_1:get("di.select"):hide()

			if tonumber(iter_13_1:get("txt"):text()) > 0 then
				table.insert(var_13_0, iter_13_0)
			end
		end

		if not itertools.isempty(var_13_0) then
			for iter_13_2, iter_13_3 in ipairs(var_13_0) do
				if arg_13_1 == iter_13_3 then
					arg_10_0.diceTable[iter_13_3]:get("di.select"):show()
					arg_10_0.selectedDiceID:set(iter_13_3)

					return
				end
			end

			arg_10_0.diceTable[var_13_0[1]]:get("di.select"):show()
			arg_10_0.selectedDiceID:set(var_13_0[1])
		else
			arg_10_0.selectedDiceID:set(0)
		end
	end)
	idlereasy.when(arg_10_0.selectedDiceID, function(arg_14_0, arg_14_1)
		local var_14_0 = arg_14_1 == 0 and 1 or arg_14_1

		arg_10_0.diceIcon:set(dataEasy.getIconResByKey(var_0_0.DICE_ID[var_14_0]))
	end)
end

function var_0_7.initModel(arg_15_0)
	arg_15_0.gridWalk = gGameModel.role:getIdler("grid_walk")
	arg_15_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_15_0.endTime = gGameModel.role:getIdler("yy_endtime")
	arg_15_0.updateDice = idler.new(false)
	arg_15_0.showHistory = idler.new(false)
	arg_15_0.nowIndex = idler.new(arg_15_0.gridWalk:read().pos)
	arg_15_0.nowTowardsUp = idler.new(arg_15_0.gridWalk:read().direction_up and 1 or -1)
	arg_15_0.selectedDice = idler.new(nil)
	arg_15_0.selectedDiceID = idler.new(1)
	arg_15_0.iconNum = idler.new(dataEasy.getNumByKey(var_0_0.BADGE_ID))
	arg_15_0.offset = idler.new(0)
	arg_15_0.diceIcon = idler.new("")
	arg_15_0.leftStepsNum = 0
	arg_15_0.yyId = arg_15_0.gridWalk:read().yy_id
	arg_15_0.huodongID = csv.yunying.yyhuodong[arg_15_0.yyId].huodongID
	arg_15_0.nowUsedCard = arg_15_0.gridWalk:read().action.die_used and arg_15_0.gridWalk:read().action.die_used ~= 0 and 0 or arg_15_0.gridWalk:read().action.item_used or 0
	arg_15_0.npcNowState = var_0_1.stand
end

function var_0_7.initHistory(arg_16_0)
	arg_16_0:updateHistory()

	if arg_16_0.nowUsedCard > 0 then
		local var_16_0 = {
			is_event = false,
			csv_id = arg_16_0.nowUsedCard
		}

		arg_16_0:updateHistory(var_16_0)
	end
end

function var_0_7.updateNpcState(arg_17_0, arg_17_1)
	if arg_17_1 == var_0_1.run then
		if arg_17_0.npcNowState == var_0_1.stand then
			arg_17_0.npcPanel:get("spine"):play("run_loop")

			arg_17_0.npcNowState = var_0_1.run
		end
	elseif arg_17_1 == var_0_1.stand and arg_17_0.npcNowState == var_0_1.run then
		arg_17_0.npcPanel:get("spine"):play("standby_loop")

		arg_17_0.npcNowState = var_0_1.stand
	end
end

function var_0_7.initItems(arg_18_0)
	arg_18_0.diceTable = {
		arg_18_0.btnDice1,
		arg_18_0.btnDice2,
		arg_18_0.btnDice3
	}
	arg_18_0.cardTable = {
		arg_18_0.card1,
		arg_18_0.card2,
		arg_18_0.card3
	}

	for iter_18_0, iter_18_1 in ipairs(arg_18_0.diceTable) do
		iter_18_1:get("di.icon"):texture(dataEasy.getIconResByKey(var_0_0.DICE_ID[iter_18_0]))
		text.addEffect(iter_18_1:get("txt"), {
			outline = {
				color = ui.COLORS.NORMAL.BLACK
			}
		})
		iter_18_1:get("di"):setCascadeOpacityEnabled(true)
		iter_18_1:get("di"):setCascadeColorEnabled(true)
	end

	for iter_18_2, iter_18_3 in ipairs(arg_18_0.cardTable) do
		local var_18_0 = var_0_0.CARD_ID[iter_18_2]
		local var_18_1 = dataEasy.getCfgByKey(var_18_0)

		iter_18_3:get("name"):text(var_18_1.name)
		text.addEffect(iter_18_3:get("name"), {
			outline = {
				color = cc.c4b(206, 94, 25, 255)
			}
		})
		text.addEffect(iter_18_3:get("txt"), {
			outline = {
				color = ui.COLORS.NORMAL.BLACK
			}
		})
	end

	arg_18_0:updateAllItems()

	local var_18_2 = 1.5
	local var_18_3 = 7
	local var_18_4 = arg_18_0.btnDice:size()
	local var_18_5 = cc.Sequence:create(cc.MoveTo:create(var_18_2, cc.p(var_18_4.width / 2, var_18_4.height / 2 + var_18_3)), cc.MoveTo:create(var_18_2, cc.p(var_18_4.width / 2, var_18_4.height / 2 - var_18_3)))

	arg_18_0.btnDiceIcon:runAction(cc.RepeatForever:create(var_18_5))
end

function var_0_7.initTouchListener(arg_19_0)
	arg_19_0.touchClose:setTouchEnabled(false)

	local var_19_0 = cc.EventListenerTouchOneByOne:create()
	local var_19_1 = arg_19_0.touchClose:getEventDispatcher()

	local function var_19_2(arg_20_0, arg_20_1)
		arg_19_0.diceInfo:hide()
		arg_19_0.eventInfo:hide()
		arg_19_0.mapTouchClose:hide()

		return false
	end

	var_19_0:registerScriptHandler(var_19_2, cc.Handler.EVENT_TOUCH_BEGAN)
	var_19_1:addEventListenerWithSceneGraphPriority(var_19_0, arg_19_0.touchClose)
	arg_19_0.mapTouchClose:setTouchEnabled(false)

	local var_19_3 = cc.EventListenerTouchOneByOne:create()
	local var_19_4 = arg_19_0.mapTouchClose:getEventDispatcher()

	var_19_3:registerScriptHandler(var_19_2, cc.Handler.EVENT_TOUCH_BEGAN)
	var_19_4:addEventListenerWithSceneGraphPriority(var_19_3, arg_19_0.mapTouchClose)
end

function var_0_7.initMap(arg_21_0)
	ccui.ImageView:create("activity/grid_walk/img_zgz1_bg.pvr.ccz"):scale(2):anchorPoint(0, 0):xy(0, 1440):addTo(arg_21_0.mapPanel, 0)
	ccui.ImageView:create("activity/grid_walk/img_zgz2_bg.pvr.ccz"):scale(2):anchorPoint(0, 0):xy(0, 0):addTo(arg_21_0.mapPanel, 0)

	arg_21_0.mapDates = {}

	local var_21_0 = var_0_0.getMapPos(arg_21_0.item:size())

	for iter_21_0, iter_21_1 in csvPairs(csv.yunying.grid_walk_map) do
		if iter_21_1.huodongID == arg_21_0.huodongID then
			arg_21_0:createGezi(iter_21_1, var_21_0)
		end
	end

	arg_21_0:updateTreasure()

	local var_21_1 = arg_21_0.endTime:read()[arg_21_0.yyId] - time.getTime()

	arg_21_0:setCountdown(var_21_1, arg_21_0.showTime)
end

function var_0_7.initNpc(arg_22_0)
	arg_22_0:createNpcSpine(arg_22_0.npcPanel, gGameModel.role:read("figure"))

	local var_22_0 = arg_22_0.mapDates[arg_22_0.nowIndex:read()].pos

	arg_22_0.npcPanel:xy(var_22_0[1], var_22_0[2])
	arg_22_0:onUpdateListPercentVertical(arg_22_0.nowIndex:read(), true)
	arg_22_0.leftStepsToBox:show()
	arg_22_0.leftSteps:hide()
	arg_22_0:updateLeftStepsToBox()
end

function var_0_7.createGezi(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.item
	local var_23_1 = arg_23_2[arg_23_1.index]

	if arg_23_1.event == var_0_0.EVENTS.increase or arg_23_1.event == var_0_0.EVENTS.reduce or arg_23_1.event == var_0_0.EVENTS.goodLuck or arg_23_1.event == var_0_0.EVENTS.badLuck or arg_23_1.event == var_0_0.EVENTS.shop then
		var_23_0 = arg_23_0.item1
	end

	local var_23_2 = var_23_0:clone():show()
	local var_23_3

	if arg_23_1.event > 0 then
		local var_23_4 = var_0_0.getCfgByEventFromEvents(arg_23_1.event, arg_23_0.huodongID)

		var_23_2:get("img"):texture(var_23_4.resources[1], ccui.TextureResType.plistType)

		if arg_23_1.event == var_0_0.EVENTS.shop then
			local var_23_5 = var_0_0.getOutPosByIndex(arg_23_1.index)
			local var_23_6 = var_23_2:size()
			local var_23_7 = var_23_5[1] * var_23_6.width
			local var_23_8 = var_23_5[2] * var_23_6.height

			var_23_2:get("panel"):removeAllChildren()

			local var_23_9 = var_23_2:get("panel"):clone():xy(var_23_1[1] + var_23_7, var_23_1[2] + var_23_8)

			var_23_9:addTo(arg_23_0.spinePanel, 1, "spine" .. arg_23_1.index)
			var_23_9:setTouchEnabled(true)
			bind.click(view, var_23_9, {
				method = functools.partial(arg_23_0.showEventsInfo, arg_23_0, arg_23_1.index)
			})

			var_23_3 = arg_23_0:createSpine(var_23_9, "effect_shop_loop")
		elseif arg_23_1.event == var_0_0.EVENTS.jump then
			var_23_2:get("jump"):hide()

			local var_23_10 = var_23_2:get("jump"):clone():show():xy(var_23_1[1], var_23_1[2])

			var_23_10:get("txt"):text(var_23_4.params.num)
			var_23_10:addTo(arg_23_0.spinePanel, 1, "spine" .. arg_23_1.index)

			var_23_3 = arg_23_0:createSpine(var_23_10, "effect_jiasuf_loop", nil, 1)
		elseif arg_23_1.event == var_0_0.EVENTS.increase or arg_23_1.event == var_0_0.EVENTS.reduce then
			var_23_2:get("panel.img1"):texture(var_23_4.resources[2], ccui.TextureResType.plistType)
		elseif arg_23_1.event == var_0_0.EVENTS.goodLuck or arg_23_1.event == var_0_0.EVENTS.badLuck then
			var_23_2:get("panel"):removeAllChildren()

			local var_23_11 = var_23_2:get("panel"):clone():xy(var_23_1[1], var_23_1[2])

			var_23_11:addTo(arg_23_0.spinePanel, 1, "spine" .. arg_23_1.index)

			local var_23_12 = arg_23_1.event == var_0_0.EVENTS.goodLuck and "effect_zhuanpan_loop" or "effect_eyun_loop"

			var_23_3 = arg_23_0:createSpine(var_23_11, var_23_12, nil, nil, "gridwalk/dongxiao.skel")
		end
	end

	var_23_2:addTo(arg_23_0.geziPanel, 1, "gezi" .. arg_23_1.index)
	var_23_2:xy(var_23_1[1], var_23_1[2])
	bind.click(view, var_23_2, {
		method = functools.partial(arg_23_0.showEventsInfo, arg_23_0, arg_23_1.index)
	})

	arg_23_0.mapDates[arg_23_1.index] = {
		action = var_23_3,
		item = var_23_2,
		index = arg_23_1.index,
		pos = var_23_1,
		event = arg_23_1.event
	}

	return var_23_2
end

function var_0_7.updateDiceFun(arg_24_0)
	arg_24_0.updateDice:notify()
end

function var_0_7.updateNpcTowardsUp(arg_25_0)
	local var_25_0 = 1.5 * var_0_0.getTowardsUp(arg_25_0.nowIndex:read(), arg_25_0.nowTowardsUp:read())

	arg_25_0.npcPanel:get("spine"):scaleX(var_25_0)
end

function var_0_7.updateJumpGezi(arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.mapDates) do
		if iter_26_1.event == var_0_0.EVENTS.jump then
			local var_26_0 = var_0_0.getNextTowardsUp(iter_26_1.index, arg_26_1)
			local var_26_1 = iter_26_1.item
			local var_26_2 = var_0_0.getCfgByEventFromEvents(iter_26_1.event, arg_26_0.huodongID)
			local var_26_3 = var_26_2.resources[1]
			local var_26_4 = 2
			local var_26_5 = "effect_jiasuf_loop"

			if var_26_0[1] < 0 and var_26_0[2] == 0 then
				var_26_4 = -2
			elseif var_26_0[1] == 0 and var_26_0[2] > 0 then
				var_26_3 = var_26_2.resources[2]
				var_26_5 = "effect_jiasuu_loop"
			elseif var_26_0[1] == 0 and var_26_0[2] < 0 then
				var_26_3 = var_26_2.resources[3]
				var_26_5 = "effect_jiasud_loop"
			end

			var_26_1:get("img"):scaleX(var_26_4)
			var_26_1:get("img"):texture(var_26_3, ccui.TextureResType.plistType)

			if iter_26_1.action then
				iter_26_1.action:scaleX(var_26_4 / 2)
				iter_26_1.action:play(var_26_5)
			end
		end
	end
end

function var_0_7.updateTreasure(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.gridWalk:read().treasure
	local var_27_1 = arg_27_0.mapDates[var_27_0]
	local var_27_2 = var_0_0.getMapPos(arg_27_0.item:size())

	if var_27_1.event ~= var_0_0.EVENTS.treasures then
		local function var_27_3()
			arg_27_0.geziPanel:removeChildByName("gezi" .. var_27_0)

			local var_28_0 = arg_27_0.item1:clone():show()

			var_28_0:addTo(arg_27_0.geziPanel, 1, "gezi" .. var_27_0)
			var_28_0:xy(var_27_2[var_27_0][1], var_27_2[var_27_0][2])

			local var_28_1 = var_0_0.getCfgByEventFromEvents(var_0_0.EVENTS.treasures, arg_27_0.huodongID)

			var_28_0:get("img"):texture(var_28_1.resources[1], ccui.TextureResType.plistType)

			local var_28_2 = var_0_0.getOutPosByIndex(var_27_0)
			local var_28_3 = var_28_0:size()

			var_28_0:get("panel"):removeAllChildren()

			local var_28_4 = var_28_0:get("panel"):clone()

			var_28_4:setTouchEnabled(true)
			var_28_4:addTo(arg_27_0.spinePanel, 1, "spine" .. var_27_0)
			bind.click(view, var_28_4, {
				method = functools.partial(arg_27_0.showEventsInfo, arg_27_0, var_27_0)
			})
			bind.click(view, var_28_0, {
				method = functools.partial(arg_27_0.showEventsInfo, arg_27_0, var_27_0)
			})

			local var_28_5 = arg_27_0:createSpine(var_28_4, "effect_bx_loop", "outBox")
			local var_28_6 = var_28_5:box()
			local var_28_7 = var_28_2[1] * var_28_3.width
			local var_28_8 = var_28_2[2] * (var_28_6.height + 10)

			var_28_4:xy(var_27_1.pos[1] + var_28_7, var_27_1.pos[2] + var_28_8)

			var_27_1.item = var_28_0
			var_27_1.action = var_28_5
			var_27_1.event = var_0_0.EVENTS.treasures

			return var_28_0
		end

		local var_27_4 = false

		for iter_27_0, iter_27_1 in pairs(arg_27_0.mapDates) do
			if iter_27_1.event == var_0_0.EVENTS.treasures then
				arg_27_0.geziPanel:removeChildByName("gezi" .. iter_27_1.index)
				arg_27_0.spinePanel:removeChildByName("spine" .. iter_27_1.index)

				iter_27_1.action = nil
				iter_27_1.event = var_0_0.getCfgByIndexFromMap(iter_27_1.index, arg_27_0.huodongID).event
				var_27_4 = true

				local var_27_5 = arg_27_0:createGezi(iter_27_1, var_27_2)

				var_27_5:hide()

				local function var_27_6()
					var_27_3()
					performWithDelay(arg_27_0, function()
						arg_27_0:onUpdateListPercentVertical(arg_27_0.nowIndex:read())
						performWithDelay(arg_27_0, arg_27_1, var_0_0.MOVE_TIME + 0.1)
					end, 0.5)
				end

				local function var_27_7()
					var_27_5:show()
					arg_27_0:onUpdateListPercentVertical(var_27_0)
					performWithDelay(arg_27_0, function()
						arg_27_0.mapDates[var_27_0].item:hide()
						arg_27_0:geziAndBoxFilp(var_27_0, var_27_6, true)
					end, var_0_0.MOVE_TIME)
				end

				arg_27_0:geziAndBoxFilp(iter_27_1.index, var_27_7)

				break
			end
		end

		if not var_27_4 then
			var_27_3()
		end
	end
end

function var_0_7.updateLeftSteps(arg_33_0)
	local var_33_0 = arg_33_0.leftSteps:get("txt1")
	local var_33_1 = arg_33_0.leftSteps:get("step")
	local var_33_2 = arg_33_0.leftSteps:get("txt2")

	var_33_1:text(arg_33_0.leftStepsNum + 1)

	local var_33_3 = arg_33_0.leftSteps:size()

	adapt.oneLineCenterPos(cc.p(var_33_3.width / 2, var_33_3.height / 2), {
		var_33_0,
		var_33_1,
		var_33_2
	}, cc.p(5, 0))
end

function var_0_7.updateLeftStepsToBox(arg_34_0)
	local var_34_0 = arg_34_0.leftStepsToBox:get("txt1")
	local var_34_1 = arg_34_0.leftStepsToBox:get("img")
	local var_34_2 = arg_34_0.leftStepsToBox:get("step")
	local var_34_3 = arg_34_0.leftStepsToBox:get("txt3")

	var_34_2:text(arg_34_0:getLeftBoxSteps())

	local var_34_4 = arg_34_0.leftStepsToBox:size()

	adapt.oneLineCenterPos(cc.p(var_34_4.width / 2, var_34_4.height / 2), {
		var_34_0,
		var_34_1,
		var_34_2,
		var_34_3
	}, cc.p(5, 0))
end

function var_0_7.updateAllItems(arg_35_0)
	arg_35_0:updateAllCards()
	arg_35_0:updateAllDices()
	arg_35_0:setBadgeOffset(0, true)
	arg_35_0:updateIconNum(true)
end

function var_0_7.updateAllCards(arg_36_0)
	for iter_36_0, iter_36_1 in ipairs(arg_36_0.cardTable) do
		local var_36_0 = dataEasy.getNumByKey(var_0_0.CARD_ID[iter_36_0])

		arg_36_0:updateCardNum(iter_36_0, var_36_0)
	end
end

function var_0_7.updateAllDices(arg_37_0)
	for iter_37_0, iter_37_1 in ipairs(arg_37_0.diceTable) do
		local var_37_0 = dataEasy.getNumByKey(var_0_0.DICE_ID[iter_37_0])

		arg_37_0:updateDiceNum(iter_37_0, var_37_0)
	end

	arg_37_0:updateDiceFun()
end

function var_0_7.updateCardNum(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_2

	if arg_38_3 then
		local var_38_1 = tonumber(arg_38_0.cardTable[arg_38_1]:get("txt"):text())

		var_38_0 = math.max(var_38_0 + var_38_1, 0)
	end

	arg_38_0.cardTable[arg_38_1]:get("txt"):text(var_38_0)

	if var_38_0 == 0 then
		text.addEffect(arg_38_0.cardTable[arg_38_1]:get("txt"), {
			color = cc.c4b(241, 59, 84, 255)
		})
	else
		text.addEffect(arg_38_0.cardTable[arg_38_1]:get("txt"), {
			color = cc.c4b(244, 215, 33, 255)
		})
	end

	return var_38_0
end

function var_0_7.updateDiceNum(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = arg_39_2

	if arg_39_3 then
		local var_39_1 = tonumber(arg_39_0.diceTable[arg_39_1]:get("txt"):text())

		var_39_0 = math.max(var_39_0 + var_39_1, 0)
	end

	arg_39_0.diceTable[arg_39_1]:get("txt"):text(var_39_0)

	local var_39_2 = cc.c3b(255, 255, 255)

	if var_39_0 == 0 then
		text.addEffect(arg_39_0.diceTable[arg_39_1]:get("txt"), {
			color = cc.c4b(241, 59, 84, 255)
		})

		var_39_2 = cc.c3b(128, 128, 128)
	else
		text.addEffect(arg_39_0.diceTable[arg_39_1]:get("txt"), {
			color = cc.c4b(244, 215, 33, 255)
		})
	end

	arg_39_0.diceTable[arg_39_1]:get("di"):color(var_39_2)

	return var_39_0
end

function var_0_7.updateHistory(arg_40_0, arg_40_1)
	local function var_40_0(arg_41_0)
		beauty.singleTextAutoScroll({
			fontSize = 40,
			align = "left",
			isRich = true,
			strs = arg_41_0,
			list = arg_40_0.historyOneList,
			anchor = cc.p(0, 0.5),
			vertical = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
		})
	end

	local function var_40_1(arg_42_0)
		if arg_40_0.historyList:getChildrenCount() >= var_0_0.HISTORY_MAX then
			arg_40_0.historyList:removeItem(0)
		end

		local var_42_0 = rich.createWithWidth(arg_42_0, 40, nil, arg_40_0.historyList:width())

		arg_40_0.historyList:pushBackCustomItem(var_42_0)
		arg_40_0.historyList:jumpToBottom()
	end

	if arg_40_1 then
		local var_40_2 = var_0_0.getLabelFromEvent(arg_40_1)

		var_40_0(var_40_2)
		var_40_1(var_40_2)
	else
		local var_40_3 = arg_40_0.gridWalk:read().history

		if not itertools.isempty(var_40_3) then
			local var_40_4

			for iter_40_0, iter_40_1 in ipairs(var_40_3) do
				local var_40_5 = var_0_0.getLabelFromEvent(iter_40_1, var_40_4)

				var_40_1(var_40_5)

				if iter_40_0 == itertools.size(var_40_3) then
					var_40_0(var_40_5)
				end

				var_40_4 = iter_40_1
			end
		end
	end
end

function var_0_7.triggerEvent(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_1.event
	local var_43_1 = var_43_0.csv_id
	local var_43_2 = true

	if var_43_1 ~= 0 then
		local var_43_3 = csv.yunying.grid_walk_events[var_43_1].type

		if var_43_3 == var_0_0.EVENTS.goodLuck then
			var_43_2 = false

			local function var_43_4(arg_44_0)
				arg_43_2()
				arg_43_0:updateHistory(var_43_0)
			end

			local var_43_5 = {
				callBack = var_43_4,
				event = var_43_0
			}

			gGameUI:stackUI("city.activity.grid_walk.wheel", nil, {
				blackLayer = true
			}, var_43_5)
		elseif var_43_3 == var_0_0.EVENTS.badLuck then
			var_43_2 = false

			local function var_43_6(arg_45_0)
				arg_43_2()
				arg_43_0:updateHistory(var_43_0)
			end

			local var_43_7 = {
				callBack = var_43_6,
				event = var_43_0,
				iconNum = arg_43_0.iconNum:read()
			}

			gGameUI:stackUI("city.activity.grid_walk.scratch", nil, nil, var_43_7)
		elseif var_43_3 == var_0_0.EVENTS.increase then
			local var_43_8 = var_0_0.getCfgByEventFromEvents(var_43_3, arg_43_0.huodongID).params.num

			arg_43_0:eventUpdateitems(var_43_8, true)
			arg_43_2()
		elseif var_43_3 == var_0_0.EVENTS.reduce then
			local var_43_9 = var_0_0.getCfgByEventFromEvents(var_43_3, arg_43_0.huodongID).params.num

			arg_43_0:eventUpdateitems(var_43_9, false)
			arg_43_2()
		elseif var_43_3 == var_0_0.EVENTS.jump then
			local var_43_10 = var_0_0.getCfgByEventFromEvents(var_43_3, arg_43_0.huodongID).params.num

			arg_43_0.leftStepsNum = arg_43_0.leftStepsNum + var_43_10

			local var_43_11 = arg_43_0.mapDates[arg_43_0.nowIndex:read()].item

			performWithDelay(arg_43_0, function()
				arg_43_2()
			end, 1)
		elseif var_43_3 == var_0_0.EVENTS.shop then
			var_43_2 = false

			local function var_43_12(arg_47_0)
				local var_47_0 = arg_47_0.hasBuy
				local var_47_1 = arg_47_0.awards
				local var_47_2 = arg_47_0.effTreasure
				local var_47_3 = arg_47_0.iconOffset

				if var_47_1 then
					for iter_47_0, iter_47_1 in pairs(var_47_1) do
						if iter_47_0 == var_0_0.ITEMS.normanlDice or iter_47_0 == var_0_0.ITEMS.strangeDice or iter_47_0 == var_0_0.ITEMS.medalDice then
							for iter_47_2, iter_47_3 in pairs(var_0_0.DICE_ID) do
								if iter_47_3 == iter_47_0 then
									arg_43_0:updateDiceNum(iter_47_2, iter_47_1, true)
									arg_43_0:updateDiceFun()

									break
								end
							end
						elseif iter_47_0 == var_0_0.ITEMS.sprintCard or iter_47_0 == var_0_0.ITEMS.randomCard or iter_47_0 == var_0_0.ITEMS.steeringCard then
							for iter_47_4, iter_47_5 in pairs(var_0_0.CARD_ID) do
								if iter_47_5 == iter_47_0 then
									arg_43_0:updateCardNum(iter_47_4, iter_47_1, true)

									break
								end
							end
						end
					end
				end

				arg_43_0:setBadgeOffset(0 - var_47_3)

				local var_47_4 = table.deepcopy(var_43_0, true)

				if var_47_0 then
					var_47_4.params.bought = 1
				end

				arg_43_0:updateHistory(var_47_4)

				if var_47_2 then
					for iter_47_6, iter_47_7 in pairs(arg_43_0.newEvents) do
						local var_47_5 = iter_47_7.event.csv_id

						if var_47_5 > 0 and csv.yunying.grid_walk_events[var_47_5].type == var_0_0.EVENTS.treasures then
							arg_43_0.newEvents[iter_47_6].effTreasure = var_47_2

							break
						end
					end
				end

				arg_43_2()
			end

			local var_43_13 = {
				callBack = var_43_12,
				event = var_43_0,
				index = arg_43_1.index,
				iconNum = arg_43_0.iconNum
			}

			gGameUI:stackUI("city.activity.grid_walk.shop", nil, {
				blackLayer = true
			}, var_43_13)
		elseif var_43_3 == var_0_0.EVENTS.treasures then
			local var_43_14 = var_43_0.params
			local var_43_15 = var_0_0.getCfgByEventFromEvents(var_43_3, arg_43_0.huodongID).params.awards
			local var_43_16 = arg_43_1.effTreasure or {}

			local function var_43_17()
				arg_43_0:updateTreasure(arg_43_2)
			end

			local var_43_18 = arg_43_0.mapDates[arg_43_0.nowIndex:read()].action

			var_43_18:play("effect_bx")
			var_43_18:setSpriteEventHandler(function(arg_49_0, arg_49_1)
				arg_43_0:onRewardCb(var_43_16, var_43_17)
			end, sp.EventType.ANIMATION_COMPLETE)
		end
	else
		arg_43_2()
	end

	if var_43_2 then
		arg_43_0:updateHistory(var_43_0)
	end
end

function var_0_7.setBadgeOffset(arg_50_0, arg_50_1, arg_50_2)
	if arg_50_2 then
		arg_50_0.offset:set(arg_50_1)
	else
		local var_50_0 = arg_50_0.offset:read()

		arg_50_0.offset:set(var_50_0 + arg_50_1)
	end

	arg_50_0:updateIconNum()
end

function var_0_7.updateIconNum(arg_51_0, arg_51_1)
	if arg_51_1 then
		arg_51_0.iconNum:set(dataEasy.getNumByKey(var_0_0.BADGE_ID))
	else
		local var_51_0 = arg_51_0.iconNum:read()
		local var_51_1 = math.max(var_51_0 + arg_51_0.offset:read(), 0)

		arg_51_0.iconNum:set(var_51_1)
	end
end

function var_0_7.eventUpdateitems(arg_52_0, arg_52_1, arg_52_2)
	arg_52_0.tipPanel:show()

	if arg_52_2 then
		arg_52_0.tipPanelTxt:text("+" .. arg_52_1)
		text.addEffect(arg_52_0.tipPanelTxt, {
			color = cc.c4b(155, 208, 71, 255)
		})
	else
		arg_52_0.tipPanelTxt:text("-" .. arg_52_1)
		text.addEffect(arg_52_0.tipPanelTxt, {
			color = cc.c4b(252, 83, 106, 255)
		})
	end

	local var_52_0 = arg_52_0.tipPanel:y()

	arg_52_0.tipPanel:y(var_52_0 - 50)
	arg_52_0.tipPanel:scale(0)
	arg_52_0.tipPanel:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2, 1.6), cc.ScaleTo:create(0.1, 1), cc.MoveTo:create(0.8, cc.p(arg_52_0.tipPanel:x(), var_52_0 + 50)), cc.DelayTime:create(0.1), cc.CallFunc:create(function()
		arg_52_0.tipPanel:hide()
		arg_52_0.tipPanel:y(var_52_0)
	end)))
end

function var_0_7.createNpcSpine(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_2

	if type(arg_54_2) == "number" then
		var_54_0 = gRoleFigureCsv[arg_54_2].crossMineResSpine
	end

	return (widget.addAnimationByKey(arg_54_1, var_54_0, "spine", "standby_loop", 1):xy(arg_54_1:width() / 2, 0):scale(1.5))
end

function var_0_7.npcMove(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0:updateNpcState(var_0_1.run)

	local var_55_0 = arg_55_0.mapDates[arg_55_1].pos
	local var_55_1 = var_0_0.getTowardsUp(arg_55_1, arg_55_0.nowTowardsUp:read())
	local var_55_2 = arg_55_0.npcPanel:x()
	local var_55_3 = arg_55_0.npcPanel:y()
	local var_55_4 = var_55_0[1] - var_55_2 > 0 and 1.5 or nil

	var_55_4 = var_55_0[1] - var_55_2 < 0 and -1.5 or var_55_4

	if var_55_4 then
		arg_55_0.npcPanel:get("spine"):scaleX(var_55_4)
	end

	arg_55_0.leftStepsToBox:hide()
	arg_55_0.leftSteps:show()
	arg_55_0:updateLeftStepsToBox()
	arg_55_0:updateLeftSteps()
	arg_55_0.npcPanel:runAction(cc.Sequence:create(cc.MoveTo:create(var_0_0.MOVE_TIME, cc.p(var_55_0[1], var_55_0[2])), cc.CallFunc:create(function()
		local var_56_0 = 1.5 * var_55_1

		if var_55_4 ~= var_56_0 then
			arg_55_0.npcPanel:get("spine"):scaleX(var_56_0)
		end

		arg_55_0.leftStepsToBox:show()
		arg_55_0.leftSteps:hide()

		if arg_55_2 then
			arg_55_2()
		end
	end)))
	arg_55_0:onUpdateListPercentVertical(arg_55_1)
end

function var_0_7.onUpdateListPercentVertical(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = arg_57_0.mapDates[arg_57_1].pos[2]
	local var_57_1 = 1440
	local var_57_2 = math.max(var_57_1 + 600 - var_57_0, 0) / var_57_1 * 100
	local var_57_3 = math.max(math.min(var_57_2, 100), 0)

	if arg_57_2 then
		arg_57_0.mapPanel:jumpToPercentVertical(var_57_3)
	else
		arg_57_0.mapPanel:scrollToPercentVertical(var_57_3, var_0_0.MOVE_TIME, false)
	end
end

function var_0_7.onCardClick(arg_58_0, arg_58_1)
	if arg_58_0.nowUsedCard > 0 then
		gGameUI:showTip(string.format(gLanguageCsv.hasUsedNow, dataEasy.getCfgByKey(arg_58_0.nowUsedCard).name))

		return
	end

	local var_58_0 = var_0_0.CARD_ID[arg_58_1]

	local function var_58_1()
		arg_58_0:sendItemuse(var_58_0)
	end

	if dataEasy.getNumByKey(var_58_0) > 0 then
		local var_58_2 = {
			callBack = var_58_1,
			itemID = var_58_0,
			card = arg_58_0.cardTable[arg_58_1],
			steps = arg_58_0:getLeftBoxSteps(arg_58_0.gridWalk:read().direction_up and -1 or 1)
		}

		gGameUI:stackUI("city.activity.grid_walk.confirmation_use_card", nil, {
			blackLayer = true
		}, var_58_2)
	else
		gGameUI:showTip(gLanguageCsv.inadequateProps)
	end
end

function var_0_7.onDiceClick(arg_60_0, arg_60_1)
	local function var_60_0(arg_61_0)
		local var_61_0 = dataEasy.getCfgByKey(var_0_0.DICE_ID[arg_61_0])
		local var_61_1 = arg_60_0.diceInfo:get("title")

		var_61_1:text(var_61_0.name)

		local var_61_2 = arg_60_0.diceInfo:get("txt")

		var_61_2:removeAllChildren()

		local var_61_3 = rich.createWithWidth("#C0x5b545b#" .. var_61_0.desc, 38, nil, 364):anchorPoint(0, 0):xy(0, 0):addTo(var_61_2):size()
		local var_61_4 = arg_60_0.diceInfo:get("bg")

		var_61_1:y(var_61_2:y() + var_61_3.height + 27)
		var_61_4:height(var_61_3.height + 110)
		arg_60_0.diceInfo:xy(arg_60_0.diceTable[arg_61_0]:x() - 10, arg_60_0.diceTable[arg_61_0]:y())
		arg_60_0.diceInfo:show()
	end

	if type(arg_60_1) == "number" then
		var_60_0(arg_60_1)

		if dataEasy.getNumByKey(var_0_0.DICE_ID[arg_60_1]) == 0 then
			return
		end

		arg_60_0:updateAllDices()
		arg_60_0.selectedDice:set(arg_60_1)
	elseif arg_60_0.selectedDiceID:read() > 0 then
		arg_60_0:sendItemuse(var_0_0.DICE_ID[arg_60_0.selectedDiceID:read()])
	else
		gGameUI:showTip(gLanguageCsv.gridWalkNoDice)
	end
end

function var_0_7.onHistoryClick(arg_62_0, arg_62_1)
	arg_62_0.showHistory:set(arg_62_1 == 1)
end

function var_0_7.onTaskClick(arg_63_0)
	gGameUI:stackUI("city.activity.grid_walk.task", nil, nil, {
		callBack = arg_63_0:createHandler("updateAllItems")
	})
end

function var_0_7.onBagClick(arg_64_0)
	gGameUI:stackUI("city.activity.grid_walk.bag")
end

function var_0_7.onRuleClick(arg_65_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_65_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_7.getRuleContext(arg_66_0, arg_66_1)
	local var_66_0 = adaptContext
	local var_66_1 = {
		var_66_0.clone(arg_66_1.title, function(arg_67_0)
			arg_67_0:get("text"):text(gLanguageCsv.gridWalk)
		end),
		var_66_0.clone(arg_66_0.treasuresPanel, function(arg_68_0)
			local var_68_0 = arg_68_0:size()
			local var_68_1 = string.format(gLanguageCsv.gridWalkRuleTips, arg_66_0:getPastTreasuresTimes())
			local var_68_2 = rich.createByStr(var_68_1)

			var_68_2:anchorPoint(0.5, 0.5)
			var_68_2:xy(var_68_0.width / 2, var_68_0.height / 2)
			arg_68_0:addChild(var_68_2)
		end),
		var_66_0.noteText(162),
		var_66_0.noteText(120001, 120030),
		var_66_0.noteText(163)
	}

	for iter_66_0, iter_66_1 in ipairs(var_0_5) do
		table.insert(var_66_1, var_66_0.clone(arg_66_0.itemPanel, function(arg_69_0)
			local var_69_0 = arg_69_0:multiget("icon", "txt")
			local var_69_1 = dataEasy.getCfgByKey(iter_66_1)

			var_69_0.txt:text(var_69_1.name .. ": " .. var_69_1.desc)

			local var_69_2 = {
				class = "icon_key",
				props = {
					data = {
						key = iter_66_1
					}
				}
			}

			bind.extend(arg_66_1, var_69_0.icon, var_69_2)
		end))
	end

	return var_66_1
end

function var_0_7.sendItemuse(arg_70_0, arg_70_1)
	if arg_70_0.timeEnd then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	gGameApp:requestServer("/game/yy/gridwalk/itemuse", function(arg_71_0)
		local var_71_0 = arg_71_0.view

		if var_71_0 then
			if var_71_0.itemID == var_0_0.ITEMS.normanlDice or var_71_0.itemID == var_0_0.ITEMS.strangeDice or var_71_0.itemID == var_0_0.ITEMS.medalDice then
				arg_70_0:setBadgeOffset(0, true)
				arg_70_0:updateSteps(var_71_0)

				arg_70_0.nowUsedCard = 0

				for iter_71_0, iter_71_1 in pairs(var_0_0.DICE_ID) do
					if iter_71_1 == var_71_0.itemID then
						arg_70_0:updateDiceNum(iter_71_0, -1, true)
						arg_70_0:updateDiceFun()

						break
					end
				end
			elseif var_71_0.itemID == var_0_0.ITEMS.sprintCard or var_71_0.itemID == var_0_0.ITEMS.randomCard or var_71_0.itemID == var_0_0.ITEMS.steeringCard then
				local var_71_1 = {
					is_event = false,
					csv_id = var_71_0.itemID
				}

				arg_70_0:updateHistory(var_71_1)
				gGameUI:showTip(dataEasy.getCfgByKey(var_71_0.itemID).name .. gLanguageCsv.useSuccess)
				arg_70_0:updateAllCards()

				arg_70_0.nowUsedCard = var_71_0.itemID

				if var_71_0.itemID == var_0_0.ITEMS.randomCard then
					arg_70_0:randomCardJumpTo()
				elseif var_71_0.itemID == var_0_0.ITEMS.steeringCard then
					arg_70_0.nowTowardsUp:set(arg_70_0.gridWalk:read().direction_up and 1 or -1)
				end
			end
		end
	end, arg_70_0.yyId, arg_70_1)
end

function var_0_7.updateSteps(arg_72_0, arg_72_1)
	arg_72_0.touchPanel:show()

	arg_72_0.newEvents = {}

	local var_72_0 = arg_72_0.gridWalk:read().action
	local var_72_1 = var_72_0.events

	for iter_72_0, iter_72_1 in pairs(var_72_1) do
		arg_72_0.newEvents[iter_72_1.index] = {
			event = iter_72_1,
			index = iter_72_0,
			effTreasure = arg_72_1.effTreasure
		}
	end

	local function var_72_2()
		if arg_72_0.leftStepsNum == 0 then
			arg_72_0:updateNpcState(var_0_1.stand)
			arg_72_0.touchPanel:hide()
			arg_72_0:updateAllItems()

			return
		end

		local var_73_0 = arg_72_0.nowIndex:read()

		if arg_72_0.nowTowardsUp:read() == 1 then
			var_73_0 = var_73_0 + 1

			if var_73_0 > 54 then
				var_73_0 = 1
			end
		else
			var_73_0 = var_73_0 - 1

			if var_73_0 < 1 then
				var_73_0 = 54
			end
		end

		arg_72_0.nowIndex:set(var_73_0)

		arg_72_0.leftStepsNum = arg_72_0.leftStepsNum - 1

		local function var_73_1()
			if arg_72_0.newEvents[var_73_0] then
				arg_72_0:updateNpcState(var_0_1.stand)
				arg_72_0:triggerEvent(arg_72_0.newEvents[var_73_0], var_72_2)
			else
				var_72_2()
			end
		end

		arg_72_0:npcMove(var_73_0, var_73_1)
	end

	arg_72_0.leftStepsNum = var_72_0.die_rolled

	if arg_72_0.nowUsedCard == var_0_0.ITEMS.sprintCard then
		local var_72_3 = dataEasy.getCfgByKey(var_0_0.ITEMS.sprintCard)

		arg_72_0.leftStepsNum = arg_72_0.leftStepsNum + var_72_3.specialArgsMap.steps
	end

	local function var_72_4()
		if arg_72_1.itemID == var_0_0.ITEMS.medalDice then
			arg_72_0:setBadgeOffset(var_72_0.die_rolled)
		end

		local var_75_0 = {
			is_event = false,
			csv_id = var_72_0.die_used,
			params = {
				outcome = arg_72_0.leftStepsNum
			}
		}

		arg_72_0:updateHistory(var_75_0)
		arg_72_0.showDicePanel:show()

		local var_75_1 = arg_72_0.showDicePanel:get("cardPanel"):hide()

		if var_72_0.item_used then
			var_75_1:show()

			local var_75_2 = var_75_1:get("cardPos")

			var_75_2:removeAllChildren()

			local var_75_3 = var_75_2:size()

			for iter_75_0, iter_75_1 in pairs(var_0_0.CARD_ID) do
				if var_72_0.item_used == iter_75_1 then
					arg_72_0.cardTable[iter_75_0]:clone():anchorPoint(0.5, 0.5):xy(var_75_3.width / 2, var_75_3.height / 2):addTo(var_75_2):get("txt"):hide()
				end
			end
		end

		local var_75_4 = arg_72_0.showDicePanel:get("step")

		arg_72_0.showDicePanel:get("icon"):texture(dataEasy.getIconResByKey(var_72_0.die_used))
		var_75_4:text(arg_72_0.leftStepsNum)
		adapt.oneLinePos(arg_72_0.showDicePanel:get("txt1"), {
			var_75_4,
			arg_72_0.showDicePanel:get("txt2")
		}, cc.p(10, 0))
		performWithDelay(arg_72_0, function()
			arg_72_0.showDicePanel:hide()
		end, 1)
		var_72_2()
	end

	arg_72_0:createDiceSpine(var_72_0.die_used, var_72_0.die_rolled, var_72_4)
end

function var_0_7.randomCardJumpTo(arg_77_0)
	arg_77_0.npcPanel:hide()

	local function var_77_0()
		arg_77_0.nowIndex:set(arg_77_0.gridWalk:read().pos)

		local var_78_0 = arg_77_0.mapDates[arg_77_0.gridWalk:read().pos].pos

		arg_77_0.npcPanel:xy(var_78_0[1], var_78_0[2])
		arg_77_0:onUpdateListPercentVertical(arg_77_0.gridWalk:read().pos, true)
		arg_77_0:updateNpcTowardsUp()
		arg_77_0:createRandomSpine(arg_77_0.mapDates[arg_77_0.nowIndex:read()].pos, "end", function()
			arg_77_0:updateLeftStepsToBox()
			arg_77_0.npcPanel:show()
			arg_77_0.touchPanel:hide()
		end)
	end

	arg_77_0:createRandomSpine(arg_77_0.mapDates[arg_77_0.nowIndex:read()].pos, "begin", var_77_0)
	arg_77_0.touchPanel:show()
end

function var_0_7.getLeftBoxSteps(arg_80_0, arg_80_1)
	local var_80_0 = 0
	local var_80_1 = arg_80_0.nowIndex:read()
	local var_80_2 = arg_80_0.gridWalk:read().treasure

	arg_80_1 = arg_80_1 or arg_80_0.nowTowardsUp:read()

	if arg_80_1 == 1 then
		if var_80_2 < var_80_1 then
			var_80_0 = var_80_2 - var_80_1 + 54
		else
			var_80_0 = var_80_2 - var_80_1
		end
	elseif var_80_2 < var_80_1 then
		var_80_0 = var_80_1 - var_80_2
	else
		var_80_0 = 54 - var_80_2 + var_80_1
	end

	return var_80_0
end

function var_0_7.onRewardCb(arg_81_0, arg_81_1, arg_81_2)
	local var_81_0

	if arg_81_2 then
		var_81_0 = {
			cb = arg_81_2
		}
	end

	gGameUI:showGainDisplay(arg_81_1, var_81_0)
end

function var_0_7.getPastTreasuresTimes(arg_82_0)
	local var_82_0 = csv.yunying.yyhuodong[arg_82_0.yyId].huodongID
	local var_82_1 = arg_82_0.yyhuodongs:read()[arg_82_0.yyId].valsums or {}

	for iter_82_0, iter_82_1 in csvPairs(csv.yunying.grid_walk_tasks) do
		if iter_82_1.huodongID == var_82_0 and iter_82_1.taskType == 0 and var_82_1[iter_82_0] then
			return var_82_1[iter_82_0]
		end
	end

	return 0
end

function var_0_7.showEventsInfo(arg_83_0, arg_83_1)
	local var_83_0 = arg_83_0.mapDates[arg_83_1]

	if var_83_0.event == 0 then
		return
	end

	local var_83_1 = var_0_0.getCfgByEventFromEvents(var_83_0.event, arg_83_0.huodongID)
	local var_83_2 = arg_83_0.eventInfo:get("title")

	var_83_2:text(var_83_1.name)

	local var_83_3 = arg_83_0.eventInfo:get("txt")

	var_83_3:removeAllChildren()

	local var_83_4 = rich.createWithWidth("#C0x5b545b#" .. var_83_1.desc, 38, nil, 364):anchorPoint(0, 0):xy(0, 0):addTo(var_83_3):size()
	local var_83_5 = arg_83_0.eventInfo:get("bg")

	var_83_2:y(var_83_3:y() + var_83_4.height + 27)
	var_83_5:height(var_83_4.height + 110)

	local var_83_6 = var_83_0.pos
	local var_83_7 = 0.5

	arg_83_0.eventInfo:anchorPoint(var_83_7, 0)
	arg_83_0.eventInfo:xy(var_83_6[1], var_83_6[2] + 100)
	arg_83_0.eventInfo:show()
	arg_83_0.mapTouchClose:show()
end

function var_0_7.geziAndBoxFilp(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
	local var_84_0 = arg_84_0.mapDates[arg_84_1]
	local var_84_1 = var_84_0.pos
	local var_84_2 = arg_84_3 and var_0_2[var_84_0.event] or var_0_3[var_84_0.event]

	if var_84_2 == nil then
		return
	end

	local var_84_3 = arg_84_0:createSpine(arg_84_0.spinePanel, var_84_2, "fangezi", 3)

	var_84_3:xy(var_84_1[1], var_84_1[2])
	var_84_3:show()
	var_84_3:setSpriteEventHandler(function(arg_85_0, arg_85_1)
		var_84_3:hide()
		arg_84_2()
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_7.createSpine(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5)
	local var_86_0 = arg_86_5 or "gridwalk/zougezi.skel"
	local var_86_1 = widget.addAnimationByKey(arg_86_1, var_86_0, arg_86_3 or arg_86_2, arg_86_2, arg_86_4 or 10)

	var_86_1:play(arg_86_2)
	var_86_1:show()
	var_86_1:xy(arg_86_1:width() / 2, arg_86_1:height() / 2)

	return var_86_1
end

function var_0_7.createDiceSpine(arg_87_0, arg_87_1, arg_87_2, arg_87_3)
	local var_87_0 = var_0_4[arg_87_1] .. arg_87_2
	local var_87_1 = widget.addAnimationByKey(arg_87_0, "gridwalk/touzi.skel", "dice", var_87_0, 99)

	var_87_1:scale(1.8)
	var_87_1:xy(arg_87_0.mapPanel:width() / 2 - 300, arg_87_0.mapPanel:height() / 2)
	var_87_1:setSpriteEventHandler(function(arg_88_0, arg_88_1)
		performWithDelay(arg_87_0, function()
			arg_87_3()
			var_87_1:removeSelf()
		end, 0)
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_7.createRandomSpine(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	local var_90_0 = arg_90_2 == "begin" and "effect_xiaoshi" or "effect_chuxian"
	local var_90_1 = widget.addAnimationByKey(arg_90_0.spinePanel, "gridwalk/chuansong.skel", "chuansong", var_90_0, 10)

	var_90_1:play(var_90_0)
	var_90_1:show()
	var_90_1:xy(arg_90_1[1], arg_90_1[2])
	var_90_1:setSpriteEventHandler(function(arg_91_0, arg_91_1)
		var_90_1:hide()
		arg_90_3()
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_7.setCountdown(arg_92_0, arg_92_1, arg_92_2)
	arg_92_0:enableSchedule():unSchedule(1)

	arg_92_1 = math.max(arg_92_1, 0)

	if arg_92_1 == 0 then
		arg_92_0.timeEnd = true

		arg_92_2:text(gLanguageCsv.activityOver)

		return
	end

	arg_92_0.timeEnd = false

	bind.extend(arg_92_0, arg_92_2, {
		class = "cutdown_label",
		props = {
			tag = 1,
			time = arg_92_1,
			strFunc = function(arg_93_0)
				return gLanguageCsv.activityTime .. arg_93_0.str
			end,
			endFunc = function()
				arg_92_1 = arg_92_0.endTime:read()[arg_92_0.yyId] - time.getTime()

				performWithDelay(arg_92_0, function()
					arg_92_0:setCountdown(arg_92_1, arg_92_2)
				end, 1)
			end
		}
	})
end

return var_0_7
