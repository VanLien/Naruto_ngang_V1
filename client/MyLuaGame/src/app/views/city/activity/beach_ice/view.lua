local var_0_0 = 1.5
local var_0_1 = {
	quit = 4,
	start = 2,
	closed = 1,
	play = 3
}
local var_0_2 = {
	good = 2,
	bad2 = 4,
	perfect = 1,
	bad1 = 3,
	bad3 = 5
}
local var_0_3 = {
	[1] = "standby_loop",
	[2] = "run_loop"
}
local var_0_4 = {
	left = -1,
	right = 1
}
local var_0_5 = {
	"activity/beach_ice/img_bq_wm.png",
	"activity/beach_ice/img_bq_lh.png",
	"activity/beach_ice/img_bq_xc.png",
	"activity/beach_ice/img_bq_xc.png",
	"activity/beach_ice/img_bq_xc1.png"
}
local var_0_6 = cc.load("mvc").ViewBase
local var_0_7 = class("BeachIceView", var_0_6)
local var_0_8 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = cc.c4b(255, 252, 237, 255)
		}
	}
}
local var_0_9 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = cc.c4b(91, 84, 91, 255)
		}
	}
}

local function var_0_10(arg_1_0, arg_1_1)
	local var_1_0, var_1_1 = time.getHourAndMin(arg_1_1)

	return time.getNumTimestamp(arg_1_0, var_1_0, var_1_1)
end

local function var_0_11(arg_2_0)
	return ({
		"Jan",
		"Feb",
		"Mar",
		"Apr",
		"May",
		"Jun",
		"Jul",
		"Aug",
		"Sept",
		"Oct",
		"Nov",
		"Dec"
	})[tonumber(arg_2_0)]
end

var_0_7.RESOURCE_FILENAME = "beach_ice_view.json"
var_0_7.RESOURCE_BINDING = {
	["centerPanel.textTipTime"] = "textTipTime",
	["centerPanel.tipTime"] = "tipTime",
	demandPanel = "demandPanel",
	huodongTimePanel = "huodongTimePanel",
	timeBg = "timeBg",
	leftDownPanel = "leftDownPanel",
	["demandPanel.countDownBg"] = "countDownBg",
	foodPanel = "foodPanel",
	centerPanel = "centerPanel",
	mask = "mask",
	["demandPanel.bg"] = "demandPanelBg",
	bg = "bg",
	["demandPanel.item"] = "demandItem",
	gaizi = "gaizi",
	["huodongTimePanel.timeText"] = {
		varname = "timeText",
		binds = var_0_9
	},
	["huodongTimePanel.time"] = {
		varname = "showTime",
		binds = var_0_9
	},
	addTime = {
		varname = "addTimeText"
	},
	gameTime = {
		varname = "gameTimeText",
		binds = {
			event = "text",
			idler = bindHelper.self("gameTime")
		}
	},
	btnMaking = {
		varname = "btnMaking",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onMakingClick")
			}
		}
	},
	["centerPanel.btnGame"] = {
		varname = "btnGame",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayGameClick")
			}
		}
	},
	["centerPanel.addPanel"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	["centerPanel.btnGame.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["btnMaking.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["leftDownPanel.rankPanel.txt"] = {
		binds = var_0_8
	},
	["leftDownPanel.rulePanel.txt"] = {
		binds = var_0_8
	},
	["leftDownPanel.rankPanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["leftDownPanel.rulePanel"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["demandPanel.countDownBg.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				data = bindHelper.self("curPagePro")
			}
		}
	},
	["demandPanel.demandList"] = {
		varname = "demandList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("demandDatas"),
				item = bindHelper.self("demandItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					if arg_3_3.visible then
						arg_3_1:get("img"):texture(arg_3_3.icon)
						arg_3_1:get("mask"):hide()
						arg_3_1:get("bg"):hide()
					elseif arg_3_3.sel > 0 then
						arg_3_1:get("img"):texture(arg_3_3.choose)
						arg_3_1:get("mask"):hide()
						arg_3_1:get("bg"):hide()
					else
						arg_3_1:get("img"):hide()
						arg_3_1:get("mask"):show()
						arg_3_1:get("bg"):show()
					end
				end
			}
		}
	}
}

function var_0_7.onCreate(arg_4_0, arg_4_1)
	arg_4_0:enableSchedule()

	arg_4_0.activityID = arg_4_1

	gGameUI.topuiManager:createView("title", arg_4_0, {
		onClose = arg_4_0:createHandler("onClose")
	}):init({
		subTitle = "BEACH ICE",
		title = gLanguageCsv.beachIceShop
	})

	arg_4_0.gameTime = idler.new(60)
	arg_4_0.addTime = 0
	arg_4_0.curPagePro = idler.new(0)
	arg_4_0.demandDatas = idlers.newWithMap({})
	arg_4_0.clickData = idlertable.new()
	arg_4_0.canclick = idler.new(false)
	arg_4_0.round = idler.new(0)
	arg_4_0.oneTurnCostTime = 0

	arg_4_0:initModel()
	arg_4_0:initGameCount()
	arg_4_0:initGameTime()

	arg_4_0.gameState = idler.new(var_0_1.closed)

	local var_4_0 = widget.addAnimationByKey(arg_4_0.gaizi, "effect/shatanbaobing.skel", "gaizi", "gaizi_loop", 10):xy(arg_4_0.gaizi:width() / 2, arg_4_0.gaizi:height() / 2 + 152):anchorPoint(0.5, 0.5)
	local var_4_1 = widget.addAnimationByKey(arg_4_0.bg, "effect/shatanbaobing.skel", "door", "che_guanbi_loop", 5):xy(arg_4_0.bg:width() / 2, -20):anchorPoint(0.5, 0.5):scale(0.5)

	idlereasy.when(arg_4_0.gameState, function(arg_5_0, arg_5_1)
		if arg_5_1 == var_0_1.closed then
			arg_4_0.foodPanel:hide()
			arg_4_0.gaizi:hide()
			arg_4_0.timeBg:hide()
			arg_4_0.gaizi:get("gaizi"):play("gaizi_loop")
			arg_4_0.round:set(-1)
			arg_4_0.mask:show()

			if arg_4_0.cardSpinePanel then
				arg_4_0.cardSpinePanel:removeSelf()

				arg_4_0.cardSpinePanel = nil
			end

			itertools.invoke({
				arg_4_0.btnMaking,
				arg_4_0.demandPanel,
				arg_4_0.gameTimeText,
				arg_4_0.addTimeText
			}, "hide")
			itertools.invoke({
				arg_4_0.leftDownPanel,
				arg_4_0.huodongTimePanel,
				arg_4_0.centerPanel
			}, "show")
			arg_4_0:resetClickData()
		elseif arg_5_1 == var_0_1.start then
			itertools.invoke({
				arg_4_0.leftDownPanel,
				arg_4_0.huodongTimePanel,
				arg_4_0.centerPanel
			}, "hide")
			arg_4_0.btnMaking:show()
			arg_4_0.btnMaking:setTouchEnabled(false)
			arg_4_0:resetClickData()
		elseif arg_5_1 == var_0_1.play then
			arg_4_0.btnMaking:hide()
		end
	end)
	idlereasy.when(arg_4_0.canclick, function(arg_6_0, arg_6_1)
		arg_4_0.mask:visible(not arg_6_1)
	end)
	idlereasy.when(arg_4_0.clickData, function(arg_7_0, arg_7_1)
		for iter_7_0 = 1, itertools.size(arg_7_1) do
			arg_4_0.foodPanel:get("sel" .. iter_7_0):visible(arg_7_1[iter_7_0] ~= 0)
		end

		if not arg_4_0:isClosedOrQuit() then
			local var_7_0 = 0
			local var_7_1 = csv.yunying.shaved_ice_demand[arg_4_0.demandData[arg_4_0.round:read()].csvID].itemNum

			for iter_7_1 = 1, arg_4_0.demandDatas:size() do
				if arg_4_0.demandDatas:atproxy(iter_7_1).sel ~= 0 then
					var_7_0 = var_7_0 + 1
				end
			end

			if var_7_0 == var_7_1 and arg_4_0.cancheck then
				arg_4_0:checkResult()

				arg_4_0.cancheck = false

				arg_4_0.canclick:set(false)
			end
		end
	end)
	idlereasy.when(arg_4_0.round, function(arg_8_0, arg_8_1)
		if arg_8_1 > 0 and not arg_4_0:isClosedOrQuit() then
			arg_4_0:resetClickData()

			if arg_4_0.gameState:read() == var_0_1.start then
				performWithDelay(arg_4_0, function()
					if arg_4_0.gameState:read() == var_0_1.start then
						arg_4_0.timeBg:show()
						arg_4_0.bg:get("door"):play("che_loop")
						arg_4_0.foodPanel:show()
						arg_4_0.gaizi:show()
						arg_4_0:createCardSpine()
					end
				end, var_0_0)
			else
				performWithDelay(arg_4_0, function()
					arg_4_0:createCardSpine()
				end, 1)
			end

			arg_4_0.cancheck = true
		end
	end)
end

function var_0_7.initModel(arg_11_0)
	arg_11_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_7.initGameTime(arg_12_0)
	local var_12_0 = csv.yunying.yyhuodong[arg_12_0.activityID]

	arg_12_0.beginTime = var_0_10(var_12_0.beginDate, var_12_0.beginTime)
	arg_12_0.endTime = var_0_10(var_12_0.endDate, var_12_0.endTime)

	if time.getTime() < arg_12_0.beginTime or time.getTime() > arg_12_0.endTime then
		arg_12_0.centerPanel:hide()
	else
		arg_12_0.centerPanel:show()
	end

	local var_12_1, var_12_2, var_12_3 = time.getYearMonthDay(var_12_0.beginDate)
	local var_12_4, var_12_5, var_12_6 = time.getYearMonthDay(var_12_0.endDate)

	if matchLanguage({
		"en"
	}) then
		var_12_2 = var_0_11(var_12_2)
		var_12_5 = var_0_11(var_12_5)
	end

	arg_12_0.showTime:text(var_12_1 .. "." .. var_12_2 .. "." .. var_12_3 .. "-" .. var_12_4 .. "." .. var_12_5 .. "." .. var_12_6)
	adapt.oneLinePos(arg_12_0.showTime, arg_12_0.timeText, cc.p(5, 0), "right")
end

function var_0_7.initGameCount(arg_13_0)
	local var_13_0 = csv.yunying.yyhuodong[arg_13_0.activityID]
	local var_13_1 = var_13_0.paramMap or {}
	local var_13_2 = var_13_1.buyTimes or 0
	local var_13_3 = var_13_1.times or 0

	arg_13_0.huodongID = var_13_0.huodongID
	arg_13_0.cost = 0
	arg_13_0.buyCost = var_13_1.buyCost or {}

	idlereasy.any({
		arg_13_0.yyhuodongs
	}, function(arg_14_0, arg_14_1)
		local var_14_0 = (arg_14_1[arg_13_0.activityID] or {}).info or {}
		local var_14_1 = var_14_0.times or 0
		local var_14_2 = var_14_0.buy_times or 0

		arg_13_0.canBuy = var_14_2 < var_13_2

		if not (var_14_2 + 1 <= itertools.size(arg_13_0.buyCost)) or not (var_14_2 + 1) then
			local var_14_3 = itertools.size(arg_13_0.buyCost)
		end

		arg_13_0.cost = arg_13_0.buyCost[var_14_2 + 1]

		arg_13_0.btnAdd:visible(var_13_2 ~= 0)

		arg_13_0.remainTimes = var_13_3 + var_14_2 - var_14_1

		arg_13_0.tipTime:text(arg_13_0.remainTimes .. "/" .. var_13_3)
	end)
end

function var_0_7.onMakingClick(arg_15_0)
	arg_15_0:updateGameTime()
	arg_15_0.gameState:set(var_0_1.play)
	arg_15_0.canclick:set(true)
	gGameApp:requestServer("/game/yy/shaved_ice/start", function(arg_16_0)
		arg_15_0.startTime = socket.gettime()
		arg_15_0.oneTurnCostTime = 0

		arg_15_0:createGameTime()
		arg_15_0:checkCheat()
	end, arg_15_0.activityID, arg_15_0.round:read())
end

function var_0_7.onPlayGameClick(arg_17_0)
	if arg_17_0.remainTimes == 0 then
		gGameUI:showTip(gLanguageCsv.gameTimesLimit)

		return
	end

	local var_17_0 = gGameModel.role:read("yy_endtime")[arg_17_0.activityID]
	local var_17_1 = 0

	if var_17_0 == nil or math.floor(var_17_0 - time.getTime()) <= 0 then
		gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)

		return
	end

	local var_17_2 = csv.yunying.yyhuodong[arg_17_0.activityID].paramMap or {}

	arg_17_0.perfectNum = 0
	arg_17_0.goodNum = 0
	arg_17_0.badNum = 0

	arg_17_0.gameTime:set(var_17_2.playTime)
	gGameApp:requestServer("/game/yy/shaved_ice/prepare", function(arg_18_0)
		arg_17_0.choices = arg_18_0.view and arg_18_0.view.choices or {}
		arg_17_0.demandData = arg_18_0.view and arg_18_0.view.demands or {}

		arg_17_0.gameState:set(var_0_1.start)
		arg_17_0.bg:get("door"):play("che_effect")
		arg_17_0.gaizi:get("gaizi"):play("gaizi_dakai")
		arg_17_0.round:set(1, true)
		arg_17_0:createFood()
	end, arg_17_0.activityID)
end

function var_0_7.createCardSpine(arg_19_0)
	if arg_19_0.cardSpinePanel then
		arg_19_0.cardSpinePanel:scaleX(-1)
		arg_19_0.cardSpinePanel:xy(-100, 200)
	else
		arg_19_0.cardSpinePanel = ccui.Layout:create():size(500, 500):addTo(arg_19_0.bg, 3, "spine"):anchorPoint(0.5, 0.5):xy(-100, 200)
	end

	arg_19_0.cardSpinePanel:removeChildByName("card")
	arg_19_0.cardSpinePanel:removeChildByName("iconBg")

	local var_19_0 = arg_19_0.demandData[arg_19_0.round:read()].guest

	widget.addAnimationByKey(arg_19_0.cardSpinePanel, csv.unit[var_19_0].unitRes, "card", var_0_3[2], 10):xy(300, 20):anchorPoint(0.5, 0.5):scale(2):setSkin(csv.unit[var_19_0].skin)
	arg_19_0:moveCardSpine(var_0_4.right)
end

function var_0_7.resetClickData(arg_20_0)
	local var_20_0 = {}

	for iter_20_0 = 1, 9 do
		var_20_0[iter_20_0] = 0
	end

	arg_20_0.clickData:set(var_20_0)
end

function var_0_7.createFood(arg_21_0)
	local var_21_0 = csv.yunying.shaved_ice_items

	for iter_21_0, iter_21_1 in pairs(arg_21_0.choices) do
		arg_21_0.foodPanel:get("food" .. iter_21_0):get("img"):texture(var_21_0[iter_21_1].icon2)
		bind.touch(arg_21_0, arg_21_0.foodPanel:get("food" .. iter_21_0), {
			methods = {
				ended = function()
					arg_21_0:clickFood(iter_21_0, iter_21_1)
				end
			}
		})
	end
end

function var_0_7.moveCardSpine(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.canclick:set(false)
	arg_23_0.cardSpinePanel:scaleX(arg_23_1)
	arg_23_0.cardSpinePanel:runAction(cc.MoveBy:create(var_0_0, cc.p(580 * arg_23_1, 0)))

	if arg_23_1 == var_0_4.right then
		performWithDelay(arg_23_0, function()
			if arg_23_0.gameState:read() == var_0_1.start then
				arg_23_0:updateGameTime()
				arg_23_0.gameTimeText:show()
			elseif arg_23_0.gameState:read() == var_0_1.play then
				gGameApp:requestServer("/game/yy/shaved_ice/start", function(arg_25_0)
					arg_23_0.startTime = socket.gettime()
					arg_23_0.oneTurnCostTime = 0
				end, arg_23_0.activityID, arg_23_0.round:read())
			end

			arg_23_0.cardSpinePanel:get("card"):play(var_0_3[1])
			arg_23_0:modelDemanPanel()
			arg_23_0:updateTime()
			arg_23_0.canclick:set(false)
		end, var_0_0)
	else
		arg_23_0:showEmoji(arg_23_2)
		arg_23_0.cardSpinePanel:get("card"):play(var_0_3[2])
		arg_23_0.demandPanel:hide()
		performWithDelay(arg_23_0, function()
			arg_23_0.round:set(arg_23_0.round:read() + 1)
		end, var_0_0)
	end
end

function var_0_7.showEmoji(arg_27_0, arg_27_1)
	local var_27_0 = cc.Sprite:create("activity/beach_ice/box_qp.png"):anchorPoint(0.5, 0.5):addTo(arg_27_0.cardSpinePanel, 10, "iconBg"):xy(150, 230):scale(0.5):scaleX(-0.5):size(202, 200)
	local var_27_1 = cc.Sprite:create(var_0_5[arg_27_1]):anchorPoint(0.5, 0.5):addTo(var_27_0, 10, "icon"):xy(var_27_0:width() / 2, var_27_0:height() / 2)
end

function var_0_7.modelDemanPanel(arg_28_0)
	local var_28_0 = itertools.size(arg_28_0.demandData[arg_28_0.round:read()].demand or {})
	local var_28_1 = csv.yunying.shaved_ice_items

	arg_28_0.demandPanel:get("bg"):width(78 + 190 * var_28_0)
	arg_28_0.demandList:width(var_28_0 * 190)
	arg_28_0.demandPanel:get("countDownBg"):x(var_28_0 * 90 + 100)

	local var_28_2 = {}

	for iter_28_0, iter_28_1 in ipairs(arg_28_0.demandData[arg_28_0.round:read()].demand) do
		var_28_2[iter_28_0] = {
			visible = true,
			sel = 0,
			choose = " ",
			key = iter_28_1,
			icon = var_28_1[iter_28_1].icon1
		}
	end

	arg_28_0.demandDatas:update(var_28_2)
	arg_28_0.demandPanel:show()
end

function var_0_7.updateTime(arg_29_0)
	local var_29_0 = csv.yunying.shaved_ice_demand[arg_29_0.demandData[arg_29_0.round:read()].csvID].time
	local var_29_1 = socket.gettime() + var_29_0

	arg_29_0:unSchedule(100)
	arg_29_0:schedule(function(arg_30_0)
		if socket.gettime() >= var_29_1 then
			for iter_30_0 = 1, arg_29_0.demandDatas:size() do
				arg_29_0.demandDatas:atproxy(iter_30_0).visible = false
			end

			arg_29_0.canclick:set(true)

			if arg_29_0.gameState:read() == var_0_1.start then
				arg_29_0:unSchedule(66)
				arg_29_0.btnMaking:setTouchEnabled(true)
				arg_29_0.canclick:set(false)
			end

			return false
		end

		arg_29_0.curPagePro:set(math.min((var_29_1 - socket.gettime()) / var_29_0 * 100, 100))
	end, 0.016666666666666666, 0, 100)
end

function var_0_7.updateGameTime(arg_31_0)
	local var_31_0 = arg_31_0.gameTime:read()

	if arg_31_0.addTime ~= 0 then
		var_31_0 = var_31_0 + arg_31_0.addTime

		arg_31_0.addTimeText:text("+" .. arg_31_0.addTime)
		arg_31_0.addTimeText:show()
		performWithDelay(arg_31_0, function()
			arg_31_0.addTimeText:hide()
		end, var_0_0)
	end

	arg_31_0.addTime = 0

	local var_31_1 = time.getTime() + var_31_0

	arg_31_0:unSchedule(66)
	arg_31_0:schedule(function(arg_33_0)
		if time.getTime() >= var_31_1 then
			arg_31_0:gameover(1)

			return false
		end

		arg_31_0.gameTime:set(var_31_1 - time.getTime())
	end, 1, 0, 66)
end

function var_0_7.clickFood(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0:isClosedOrQuit() then
		return
	end

	local var_34_0 = csv.yunying.shaved_ice_items
	local var_34_1 = table.shallowcopy(arg_34_0.clickData:read())

	if var_34_1[arg_34_1] ~= 0 then
		arg_34_0.demandDatas:atproxy(var_34_1[arg_34_1]).sel = 0
		var_34_1[arg_34_1] = 0
	else
		for iter_34_0 = 1, arg_34_0.demandDatas:size() do
			if arg_34_0.demandDatas:atproxy(iter_34_0).sel == 0 then
				arg_34_0.demandDatas:atproxy(iter_34_0).sel = arg_34_1
				arg_34_0.demandDatas:atproxy(iter_34_0).choose = var_34_0[arg_34_2].icon1
				var_34_1[arg_34_1] = iter_34_0

				break
			end
		end
	end

	arg_34_0.clickData:set(var_34_1)
end

function var_0_7.isClosedOrQuit(arg_35_0)
	local var_35_0 = arg_35_0.gameState:read()

	return var_35_0 == var_0_1.closed or var_35_0 == var_0_1.quit
end

function var_0_7.checkResult(arg_36_0)
	if arg_36_0.gameState:read() ~= var_0_1.play then
		return
	end

	local var_36_0 = {}
	local var_36_1 = {}

	for iter_36_0 = 1, arg_36_0.demandDatas:size() do
		var_36_0[iter_36_0] = arg_36_0.choices[arg_36_0.demandDatas:atproxy(iter_36_0).sel]
		var_36_1[iter_36_0] = arg_36_0.demandDatas:atproxy(iter_36_0).key
	end

	gGameApp:requestServer("/game/yy/shaved_ice/end", function(arg_37_0)
		local var_37_0 = arg_37_0.view.result and arg_37_0.view.result.type or var_0_2.bad3
		local var_37_1 = arg_37_0.view.result and arg_37_0.view.result.score or 0

		arg_36_0.addTime = arg_37_0.view.result.time

		if var_37_0 == var_0_2.perfect then
			arg_36_0.perfectNum = arg_36_0.perfectNum + 1
		elseif var_37_0 == var_0_2.good then
			arg_36_0.goodNum = arg_36_0.goodNum + 1
		else
			arg_36_0.badNum = arg_36_0.badNum + 1
		end

		arg_36_0:updateGameTime()

		arg_36_0.checkUi = gGameUI:stackUI("city.activity.beach_ice.check", nil, {
			blackLayer = true,
			clickClose = true
		}, {
			unitID = arg_36_0.demandData[arg_36_0.round:read()].guest,
			type = var_37_0,
			mineChoose = var_36_0,
			demand = var_36_1,
			score = var_37_1,
			cb = arg_36_0:createHandler("setCheckUi")
		})

		arg_36_0:moveCardSpine(var_0_4.left, var_37_0)
	end, arg_36_0.activityID, arg_36_0.round:read(), var_36_0, arg_36_0.oneTurnCostTime)
end

function var_0_7.setCheckUi(arg_38_0)
	arg_38_0.checkUi = nil
end

function var_0_7.onRankClick(arg_39_0)
	if time.getTime() < arg_39_0.beginTime or time.getTime() > arg_39_0.endTime then
		gGameUI:showTip(gLanguageCsv.notRank)

		return
	end

	gGameApp:requestServer("/game/yy/shaved_ice/rank", function(arg_40_0)
		gGameUI:stackUI("city.activity.beach_ice.rank", nil, nil, arg_40_0.view, arg_39_0.activityID)
	end, arg_39_0.activityID)
end

function var_0_7.onRuleClick(arg_41_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_41_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_7.getRuleContext(arg_42_0, arg_42_1)
	local var_42_0 = adaptContext

	return {
		var_42_0.clone(arg_42_1.title, function(arg_43_0)
			arg_43_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_42_0.noteText(124801, 124820)
	}
end

function var_0_7.onAddClick(arg_44_0)
	local var_44_0 = gGameModel.role:read("yy_endtime")[arg_44_0.activityID]
	local var_44_1 = 0

	if var_44_0 == nil or math.floor(var_44_0 - time.getTime()) <= 0 then
		gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)

		return
	end

	if arg_44_0.canBuy == false then
		gGameUI:showTip(gLanguageCsv.buyTimesLimit)

		return
	end

	local var_44_2 = gLanguageCsv.purchaseTimesTip

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		cb = function()
			if arg_44_0.cost > gGameModel.role:read("rmb") then
				uiEasy.showDialog("rmb")
			else
				gGameApp:requestServer("/game/yy/shaved_ice/buy", function(arg_46_0)
					gGameUI:showTip(gLanguageCsv.buySuccess)
				end, arg_44_0.activityID)
			end
		end,
		title = gLanguageCsv.spaceTips,
		content = string.format(var_44_2, arg_44_0.cost),
		size = {
			width = 850,
			height = 450
		},
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_7.gameover(arg_47_0, arg_47_1)
	arg_47_0:unScheduleAll()
	arg_47_0:stopAllActions()
	arg_47_0.canclick:set(false)
	arg_47_0.gaizi:get("gaizi"):play("gaizi_guanbi")

	if not arg_47_0:isClosedOrQuit() then
		arg_47_0.gameState:set(var_0_1.quit)
		gGameApp:requestServer("/game/yy/shaved_ice/quit", function(arg_48_0)
			arg_47_0:changeGameState(false)

			if arg_47_1 == 2 and arg_47_0.perfectNum + arg_47_0.goodNum + arg_47_0.badNum == 0 then
				arg_47_0.bg:get("door"):play("che_guanbi_loop")
			else
				gGameUI:stackUI("city.activity.beach_ice.game_over", nil, {
					blackLayer = true
				}, {
					perfectNum = arg_47_0.perfectNum,
					goodNum = arg_47_0.goodNum,
					badNum = arg_47_0.badNum,
					huodongID = arg_47_0.huodongID,
					award = arg_48_0.view.result or {},
					cb = arg_47_0:createHandler("changeGameState", true)
				})
			end
		end, arg_47_0.activityID)
	end
end

function var_0_7.changeGameState(arg_49_0, arg_49_1)
	if arg_49_1 then
		arg_49_0.bg:get("door"):play("che_guanbi_loop")
	end

	arg_49_0.gameState:set(var_0_1.closed)

	if arg_49_0.checkUi then
		arg_49_0.checkUi:onClose()

		arg_49_0.checkUi = nil
	end
end

function var_0_7.onClose(arg_50_0)
	if arg_50_0.gameState:read() == var_0_1.closed then
		var_0_6.onClose(arg_50_0)

		return
	end

	local var_50_0 = "#C0x5b545b#" .. gLanguageCsv.exitDuringProductionTip

	if arg_50_0.gameState:read() == var_0_1.start then
		var_50_0 = "#C0x5b545b#" .. gLanguageCsv.firstExit
	end

	gGameUI:stackUI("city.activity.beach_ice.tips", nil, nil, {
		clearFast = true,
		content = var_50_0,
		state = arg_50_0.gameState:read(),
		cb = function()
			arg_50_0:gameover(2)
		end,
		time = arg_50_0.gameTime:read() - 1
	})
end

function var_0_7.checkCheat(arg_52_0)
	local var_52_0 = 5
	local var_52_1 = var_52_0
	local var_52_2 = socket.gettime()

	arg_52_0:unSchedule(718)
	arg_52_0:schedule(function(arg_53_0)
		if var_52_1 <= 0 then
			if math.abs(socket.gettime() - var_52_2 - var_52_0) > 3 then
				arg_52_0:gameover(2)
				gGameUI:showDialog({
					btnType = 1,
					clearFast = true,
					content = gLanguageCsv.skyScraperTimeError,
					dialogParams = {
						clickClose = false
					}
				})

				return false
			else
				arg_52_0:checkCheat()
			end
		end

		var_52_1 = var_52_1 - arg_53_0
	end, 1, 0, 718)
end

function var_0_7.createGameTime(arg_54_0)
	arg_54_0:schedule(function(arg_55_0)
		arg_54_0.oneTurnCostTime = arg_54_0.oneTurnCostTime + 0.1
	end, 0.1, 0, 111111)
end

return var_0_7
