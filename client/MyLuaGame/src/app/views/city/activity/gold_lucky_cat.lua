local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = class("ActivityGoldLuckyCat", Dialog)
local var_0_2 = 8
local var_0_3 = 5

var_0_1.RESOURCE_FILENAME = "activity_gold_lucky_cat.json"
var_0_1.RESOURCE_BINDING = {
	have = "have",
	numItem = "numItem",
	txt3 = "txt3",
	cost = "cost",
	dialogPanel = "dialogPanel",
	txt2 = "txt2",
	icon3 = "icon3",
	leftList = "leftList",
	skelPanel = "skelPanel",
	item = "item",
	mask = "mask",
	iconVipTips = "iconVipTips",
	["dialogPanel.vip5"] = "vipIcon",
	txtVipTips = "txtVipTips",
	icon2 = "icon2",
	icon1 = "icon1",
	["dialogPanel.list"] = "vipList",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					arg_1_0:onSure(1)
				end)
			}
		}
	},
	txt4 = {
		varname = "txt4",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 114, 37, 255)
				}
			}
		}
	},
	txt = {
		varname = "txt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 114, 37, 255)
				}
			}
		}
	},
	max = {
		varname = "max",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 114, 37, 255)
				}
			}
		}
	},
	times = {
		varname = "times",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 114, 37, 255)
				}
			}
		}
	},
	timeLabel = {
		varname = "timeLabel",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 114, 37, 255)
				}
			}
		}
	},
	time = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(241, 114, 37, 255)
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_2.view.luckycat_message_gold

	gGameModel.currday_dispatch:getIdlerOrigin("goldLuckyCat"):set(true)

	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()
	arg_2_0:initSkel()

	arg_2_0.originData = {}

	local var_2_1 = {}

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.yunying.luckycat) do
		if csv.yunying.yyhuodong[arg_2_0.activityId].huodongID == iter_2_1.huodongID then
			table.insert(arg_2_0.originData, iter_2_1)
			table.insert(var_2_1, iter_2_1.vip)
		end
	end

	arg_2_0.data1 = arraytools.first(var_2_0, var_0_3)

	for iter_2_2, iter_2_3 in ipairs(var_2_1) do
		if iter_2_3 ~= 0 then
			local var_2_2 = arg_2_0.vipIcon:clone()

			var_2_2:texture("common/icon/vip/icon_vip" .. iter_2_3 .. ".png")
			arg_2_0.vipList:addChild(var_2_2)
			var_2_2:show()
		end
	end

	arg_2_0.vipList:setItemAlignCenter()
	arg_2_0.vipList:setScrollBarEnabled(false)

	arg_2_0.showItemIdx = 1
	arg_2_0.maxIdx = 0

	arg_2_0.leftList:setTouchEnabled(false)
	arg_2_0.leftList:setScrollBarEnabled(false)

	arg_2_0.leftDatas = idlertable.new(#var_2_0 > 0 and var_2_0 or {})

	idlereasy.when(arg_2_0.leftDatas, function(arg_3_0, arg_3_1)
		arg_2_0.leftList:removeAllItems()

		local function var_3_0(arg_4_0)
			local var_4_0 = arg_2_0.item:clone()

			var_4_0:show()

			local var_4_1 = var_4_0:get("label")
			local var_4_2 = rich.createWithWidth(string.format(gLanguageCsv.congratulationGetGold, arg_4_0[1], mathEasy.getShortNumber(arg_4_0[2], 2)), var_4_1:getFontSize(), nil, var_4_0:size().width - 10):anchorPoint(0, 1):addTo(var_4_1)

			if var_4_2:size().height > var_4_0:size().height then
				var_4_0:size(cc.size(var_4_0:size().width, var_4_2:size().height + 10))
			end

			var_4_1:y(var_4_0:size().height - 5)
			arg_2_0.leftList:pushBackCustomItem(var_4_0)
		end

		local var_3_1 = 0

		for iter_3_0, iter_3_1 in pairs(arg_3_1) do
			var_3_0(iter_3_1)
			arg_2_0.leftList:refreshView()

			local var_3_2 = arg_2_0.leftList:getInnerContainer():size().height

			if var_3_1 == 0 and var_3_2 > arg_2_0.leftList:size().height then
				var_3_1 = iter_3_0
			end
		end

		arg_2_0.maxIdx = #arg_3_1

		if var_3_1 > 0 then
			for iter_3_2 = 1, var_3_1 do
				var_3_0(arg_3_1[iter_3_2])
			end
		end
	end)

	arg_2_0.node = arg_2_0:getResourceNode()

	for iter_2_4 = 1, var_0_2 do
		arg_2_0.node:get("list" .. iter_2_4):setScrollBarEnabled(false)
	end

	arg_2_0.currId = idler.new(arg_2_0.originData[1].drawID)

	idlereasy.when(arg_2_0.yyhuodongs, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[arg_2_0.activityId] or {}

		arg_2_0.currId:set(var_5_0.info.count)
	end)

	arg_2_0.curState = idler.new(false)

	idlereasy.any({
		arg_2_0.curState,
		arg_2_0.gold,
		arg_2_0.vip
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if arg_6_1 == true then
			arg_2_0:rollCb()
		end
	end)
	var_0_0.setCountdown(arg_2_0, arg_2_0.activityId, arg_2_0.timeLabel, arg_2_0.time, {
		labelChangeCb = function()
			adapt.oneLinePos(arg_2_0.timeLabel, arg_2_0.time, cc.p(15, 0))
		end
	})
	arg_2_0:rollCb()
	arg_2_0:originRoll()

	local var_2_3 = 0
	local var_2_4 = 0

	arg_2_0:enableSchedule()
	arg_2_0:schedule(function()
		if arg_2_0.maxIdx > 0 then
			arg_2_0.leftList:scrollToItem(arg_2_0.showItemIdx, cc.p(1, 1), cc.p(1, 1))

			if arg_2_0.showItemIdx >= arg_2_0.maxIdx then
				arg_2_0.showItemIdx = 0

				performWithDelay(arg_2_0, function()
					arg_2_0.leftList:jumpToItem(0, cc.p(1, 1), cc.p(1, 1))
				end, 0.9)
			end

			arg_2_0.showItemIdx = arg_2_0.showItemIdx + 1
		end
	end, 1, 1, 4)
	Dialog.onCreate(arg_2_0, {
		blackType = 1
	})
end

function var_0_1.initModel(arg_10_0)
	arg_10_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_10_0.gold = gGameModel.role:getIdler("gold")
	arg_10_0.vip = gGameModel.role:getIdler("vip_level")
end

function var_0_1.initSkel(arg_11_0)
	arg_11_0.wheelSkel = widget.addAnimationByKey(arg_11_0.skelPanel, "xingyuntuibi/xingyuntuibi.skel", "tuiBi", "effect_loop", 2)

	arg_11_0.wheelSkel:anchorPoint(cc.p(0.5, 0.5)):xy(arg_11_0.skelPanel:size().width / 2 - 265, arg_11_0.skelPanel:size().height / 2 - 9):scale(2):play("effect_loop")
end

function var_0_1.rollCb(arg_12_0)
	arg_12_0.have:text(mathEasy.getShortNumber(arg_12_0.gold:read(), 2))

	local var_12_0 = arg_12_0.vip:read()

	adapt.oneLinePos(arg_12_0.txt3, {
		arg_12_0.have,
		arg_12_0.icon3
	}, {
		cc.p(0, 0),
		cc.p(0, 0)
	}, "left")

	arg_12_0.totalTimes = 0

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.originData) do
		if var_12_0 >= iter_12_1.vip then
			arg_12_0.totalTimes = arg_12_0.totalTimes + 1
		end
	end

	local var_12_1 = arg_12_0.currId:read()
	local var_12_2 = arg_12_0.originData[math.min(var_12_1 + 1, #arg_12_0.originData)]

	arg_12_0.max:text(mathEasy.getShortNumber(var_12_2.rmbRndMax, 2))
	adapt.oneLinePos(arg_12_0.max, arg_12_0.icon1, cc.p(10, 0), "left")

	arg_12_0.needCost = var_12_2.goldCost

	arg_12_0.cost:text(mathEasy.getShortNumber(var_12_2.goldCost, 2))
	adapt.oneLinePos(arg_12_0.txt2, {
		arg_12_0.cost,
		arg_12_0.icon2
	}, {
		cc.p(0, 0),
		cc.p(0, 0)
	}, "left")

	arg_12_0.remainTime = arg_12_0.totalTimes - var_12_1

	arg_12_0.times:text(gLanguageCsv.residueTims .. arg_12_0.totalTimes - var_12_1 .. "/" .. arg_12_0.totalTimes)
	arg_12_0.txtVipTips:visible(var_12_2.vip > 0)
	arg_12_0.iconVipTips:visible(var_12_2.vip > 0)
	arg_12_0.iconVipTips:texture(ui.VIP_ICON[var_12_2.vip])
	adapt.oneLinePos(arg_12_0.txtVipTips, arg_12_0.iconVipTips, cc.p(0, 0), "right")

	if var_12_1 >= #arg_12_0.originData then
		arg_12_0.txt:visible(false)
		arg_12_0.txt2:visible(false)
		arg_12_0.txt3:visible(false)
		arg_12_0.max:visible(false)
		arg_12_0.txt4:visible(true)
		arg_12_0.cost:visible(false)
		arg_12_0.have:visible(false)
		arg_12_0.icon2:visible(false)
		arg_12_0.icon3:visible(false)
		arg_12_0.icon1:visible(false)
		arg_12_0.txtVipTips:visible(false)
		arg_12_0.iconVipTips:visible(false)
	end
end

function var_0_1.originRoll(arg_13_0)
	local var_13_0 = arg_13_0:getNumbers(0)

	for iter_13_0 = 1, var_0_2 do
		arg_13_0:setNumber(false, true, iter_13_0, var_13_0)
	end

	arg_13_0:numberRoll(var_0_2, 0, 0.1)
end

function var_0_1.getNumbers(arg_14_0, arg_14_1)
	local var_14_0 = {}

	for iter_14_0 = var_0_2, 1, -1 do
		table.insert(var_14_0, math.floor(arg_14_1 / 10^(iter_14_0 - 1)))

		if iter_14_0 - 1 > 1 then
			arg_14_1 = arg_14_1 % 10^(iter_14_0 - 1)
		else
			table.insert(var_14_0, arg_14_1 % 10)

			break
		end
	end

	return var_14_0
end

function var_0_1.setNumber(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if arg_15_2 then
		arg_15_0.node:get("list" .. arg_15_3):removeAllChildren()
	end

	if arg_15_1 then
		local var_15_0 = math.random(0, 9)
		local var_15_1 = 12

		for iter_15_0 = 1, var_15_1 do
			arg_15_0:addList(arg_15_0.node:get("list" .. arg_15_3), (var_15_0 + iter_15_0) % 10, iter_15_0)
		end

		arg_15_0:addList(arg_15_0.node:get("list" .. arg_15_3), arg_15_4[arg_15_3], var_15_1 + 1)
		arg_15_0.node:get("list" .. arg_15_3):scrollToPercentVertical(100, arg_15_5, false)
	else
		arg_15_0:addList(arg_15_0.node:get("list" .. arg_15_3), arg_15_4[arg_15_3], 0)
	end
end

function var_0_1.addList(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0.numItem:clone()

	var_16_0:setVisible(true)
	arg_16_1:insertCustomItem(var_16_0, arg_16_3)
	var_16_0:get("num"):text(arg_16_2)
end

function var_0_1.numberRoll(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = arg_17_0:getNumbers(arg_17_2)

	if arg_17_3 == 0.1 then
		performWithDelay(arg_17_0, function()
			for iter_18_0 = 1, var_0_2 do
				arg_17_0:setNumber(true, false, iter_18_0, var_17_0, 1)
			end

			arg_17_0.mask:hide()
		end, 0.016666666666666666)
	else
		arg_17_0.mask:show()

		for iter_17_0 = 1, var_0_2 do
			arg_17_0:setNumber(true, false, iter_17_0, var_17_0, arg_17_3)
		end

		performWithDelay(arg_17_0, function()
			if arg_17_4 then
				arg_17_0.leftDatas:set(arg_17_4.view.luckycat_message_gold, true)
				arg_17_0:originRoll()
				arg_17_0:rollCb()
				gGameUI:showGainDisplay(arg_17_4)
			end
		end, arg_17_3 + 0.6)
	end
end

function var_0_1.onSure(arg_20_0, arg_20_1)
	if arg_20_0.gold:read() < arg_20_0.needCost and arg_20_0.remainTime > 0 then
		arg_20_0.curState:set(true)
		uiEasy.showDialog("gold")

		return
	end

	if arg_20_0.totalTimes < #arg_20_0.originData and arg_20_0.remainTime == 0 then
		arg_20_0.curState:set(true)

		local var_20_0 = {
			gLanguageCsv.luckGoldMax,
			string.format(gLanguageCsv.commonVipIncrease, gLanguageCsv.luckGoldTip)
		}

		uiEasy.showDialog("vip", {
			titleName = gLanguageCsv.luckGoldTip,
			content = var_20_0
		})

		return
	end

	if arg_20_0.currId:read() >= #arg_20_0.originData then
		gGameUI:showTip(gLanguageCsv.luckGoldMax)

		return
	end

	arg_20_0.curState:set(false)
	gGameApp:requestServer("/game/yy/award/get", function(arg_21_0)
		local var_21_0, var_21_1 = next(arg_21_0.view.result)

		arg_20_0:numberRoll(var_0_2, var_21_1, arg_20_1, arg_21_0)
		arg_20_0.wheelSkel:play("effect")

		local var_21_2 = cc.DelayTime:create(2)

		arg_20_0:runAction(cc.Sequence:create(var_21_2, cc.CallFunc:create(function()
			arg_20_0.wheelSkel:play("effect_loop")
		end)))
	end, arg_20_0.activityId)
end

return var_0_1
