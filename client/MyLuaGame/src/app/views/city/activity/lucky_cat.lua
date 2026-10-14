local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = class("ActivityLuckyCat", Dialog)
local var_0_2 = 6
local var_0_3 = 5

var_0_1.RESOURCE_FILENAME = "activity_lucky_cat.json"
var_0_1.RESOURCE_BINDING = {
	numItem = "numItem",
	icon2 = "icon2",
	cost = "cost",
	iconVipTips = "iconVipTips",
	dialogPanel = "dialogPanel",
	txt2 = "txt2",
	txt4 = "txt4",
	icon3 = "icon3",
	txt3 = "txt3",
	["dialogPanel.vip5"] = "vipIcon",
	leftList = "leftList",
	max = "max",
	item = "item",
	mask = "mask",
	txt = "txt",
	times = "times",
	timesLabel = "timesLabel",
	txtVipTips = "txtVipTips",
	have = "have",
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
	timeLabel = {
		varname = "timeLabel",
		binds = {
			event = "effect",
			data = {
				shadow = {
					size = 3,
					color = cc.c4b(0, 0, 0, 100),
					offset = cc.size(3, -3)
				}
			}
		}
	},
	time = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				shadow = {
					size = 3,
					color = cc.c4b(0, 0, 0, 100),
					offset = cc.size(3, -3)
				}
			}
		}
	},
	title = {
		varname = "title"
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_2.view.luckycat_message_rmb

	gGameModel.currday_dispatch:getIdlerOrigin("luckyCat"):set(true)

	arg_2_0.activityId = arg_2_1

	arg_2_0:initModel()

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
			local var_4_2 = rich.createWithWidth(string.format(gLanguageCsv.congratulationGetDianomd, arg_4_0[1], arg_4_0[2]), var_4_1:getFontSize(), nil, var_4_0:size().width - 10):anchorPoint(0, 1):addTo(var_4_1)

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
		arg_2_0.rmb,
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
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.vip = gGameModel.role:getIdler("vip_level")
end

function var_0_1.rollCb(arg_11_0)
	arg_11_0.have:text(arg_11_0.rmb:read())

	local var_11_0 = arg_11_0.vip:read()

	adapt.oneLinePos(arg_11_0.txt3, {
		arg_11_0.have,
		arg_11_0.icon3
	}, {
		cc.p(0, 0),
		cc.p(0, 0)
	}, "left")

	arg_11_0.totalTimes = 0

	for iter_11_0, iter_11_1 in ipairs(arg_11_0.originData) do
		if var_11_0 >= iter_11_1.vip then
			arg_11_0.totalTimes = arg_11_0.totalTimes + 1
		end
	end

	local var_11_1 = arg_11_0.currId:read()
	local var_11_2 = arg_11_0.originData[math.min(var_11_1 + 1, #arg_11_0.originData)]

	arg_11_0.max:text(var_11_2.rmbRndMax)
	adapt.oneLinePos(arg_11_0.max, arg_11_0.icon1, cc.p(10, 0), "left")

	arg_11_0.needCost = var_11_2.rmbCost

	arg_11_0.cost:text(var_11_2.rmbCost)
	adapt.oneLinePos(arg_11_0.txt2, {
		arg_11_0.cost,
		arg_11_0.icon2
	}, {
		cc.p(0, 0),
		cc.p(0, 0)
	}, "left")

	arg_11_0.remainTime = arg_11_0.totalTimes - var_11_1

	arg_11_0.times:text(arg_11_0.totalTimes - var_11_1 .. "/" .. arg_11_0.totalTimes)
	adapt.oneLinePos(arg_11_0.timesLabel, arg_11_0.times, cc.p(0, 0), "left")
	arg_11_0.txtVipTips:visible(var_11_2.vip > 0)
	arg_11_0.iconVipTips:visible(var_11_2.vip > 0)
	arg_11_0.iconVipTips:texture(ui.VIP_ICON[var_11_2.vip])
	adapt.oneLinePos(arg_11_0.txtVipTips, arg_11_0.iconVipTips, cc.p(0, 0), "right")

	if var_11_1 >= #arg_11_0.originData then
		arg_11_0.txt:visible(false)
		arg_11_0.txt2:visible(false)
		arg_11_0.txt3:visible(false)
		arg_11_0.max:visible(false)
		arg_11_0.txt4:visible(true)
		arg_11_0.cost:visible(false)
		arg_11_0.have:visible(false)
		arg_11_0.icon2:visible(false)
		arg_11_0.icon3:visible(false)
		arg_11_0.icon1:visible(false)
		arg_11_0.txtVipTips:visible(false)
		arg_11_0.iconVipTips:visible(false)
	end
end

function var_0_1.originRoll(arg_12_0)
	local var_12_0 = arg_12_0:getNumbers(0)

	for iter_12_0 = 1, var_0_2 do
		arg_12_0:setNumber(false, true, iter_12_0, var_12_0)
	end

	arg_12_0:numberRoll(var_0_2, 0, 0.1)
end

function var_0_1.getNumbers(arg_13_0, arg_13_1)
	local var_13_0 = {}

	for iter_13_0 = var_0_2, 1, -1 do
		table.insert(var_13_0, math.floor(arg_13_1 / 10^(iter_13_0 - 1)))

		if iter_13_0 - 1 > 1 then
			arg_13_1 = arg_13_1 % 10^(iter_13_0 - 1)
		else
			table.insert(var_13_0, arg_13_1 % 10)

			break
		end
	end

	return var_13_0
end

function var_0_1.setNumber(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if arg_14_2 then
		arg_14_0.node:get("list" .. arg_14_3):removeAllChildren()
	end

	if arg_14_1 then
		local var_14_0 = math.random(0, 9)
		local var_14_1 = 12

		for iter_14_0 = 1, var_14_1 do
			arg_14_0:addList(arg_14_0.node:get("list" .. arg_14_3), (var_14_0 + iter_14_0) % 10, iter_14_0)
		end

		arg_14_0:addList(arg_14_0.node:get("list" .. arg_14_3), arg_14_4[arg_14_3], var_14_1 + 1)
		arg_14_0.node:get("list" .. arg_14_3):scrollToPercentVertical(100, arg_14_5, false)
	else
		arg_14_0:addList(arg_14_0.node:get("list" .. arg_14_3), arg_14_4[arg_14_3], 0)
	end
end

function var_0_1.addList(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.numItem:clone()

	var_15_0:setVisible(true)
	arg_15_1:insertCustomItem(var_15_0, arg_15_3)
	var_15_0:get("num"):text(arg_15_2)
end

function var_0_1.numberRoll(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_0:getNumbers(arg_16_2)

	if arg_16_3 == 0.1 then
		performWithDelay(arg_16_0, function()
			for iter_17_0 = 1, var_0_2 do
				arg_16_0:setNumber(true, false, iter_17_0, var_16_0, 1)
			end

			arg_16_0.mask:hide()
		end, 0.016666666666666666)
	else
		arg_16_0.mask:show()

		for iter_16_0 = 1, var_0_2 do
			arg_16_0:setNumber(true, false, iter_16_0, var_16_0, arg_16_3)
		end

		performWithDelay(arg_16_0, function()
			if arg_16_4 then
				arg_16_0.leftDatas:set(arg_16_4.view.luckycat_message_rmb, true)
				arg_16_0:originRoll()
				arg_16_0:rollCb()
				gGameUI:showGainDisplay(arg_16_4)
			end
		end, arg_16_3 + 0.6)
	end
end

function var_0_1.onSure(arg_19_0, arg_19_1)
	if arg_19_0.rmb:read() < arg_19_0.needCost and arg_19_0.remainTime > 0 then
		arg_19_0.curState:set(true)
		uiEasy.showDialog("rmb", {
			titleName = gLanguageCsv.luckyCat
		})

		return
	end

	if arg_19_0.totalTimes < #arg_19_0.originData and arg_19_0.remainTime == 0 then
		arg_19_0.curState:set(true)

		local var_19_0 = {
			gLanguageCsv.luckyMax,
			string.format(gLanguageCsv.commonVipIncrease, gLanguageCsv.luckyCat)
		}

		uiEasy.showDialog("vip", {
			titleName = gLanguageCsv.luckyCat,
			content = var_19_0
		})

		return
	end

	if arg_19_0.currId:read() >= #arg_19_0.originData then
		gGameUI:showTip(gLanguageCsv.luckyMax)

		return
	end

	arg_19_0.curState:set(false)
	gGameApp:requestServer("/game/yy/award/get", function(arg_20_0)
		local var_20_0, var_20_1 = next(arg_20_0.view.result)

		arg_19_0:numberRoll(var_0_2, var_20_1, arg_19_1, arg_20_0)
	end, arg_19_0.activityId)
end

return var_0_1
