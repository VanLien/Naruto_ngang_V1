local var_0_0 = 10
local var_0_1 = {
	{
		cc.p(0, 954),
		cc.p(106, 880),
		cc.p(322, 1096),
		cc.p(502, 1064),
		cc.p(687, 930),
		cc.p(1120, 1136),
		cc.p(1362, 978),
		cc.p(1210, 890),
		cc.p(1330, 765),
		cc.p(1269, 714),
		cc.p(1005, 669),
		cc.p(594, 472),
		cc.p(719, 405),
		cc.p(397, 176),
		cc.p(658, 0),
		cc.p(0, 0)
	},
	{
		cc.p(0, 1440),
		cc.p(0, 954),
		cc.p(106, 880),
		cc.p(322, 1096),
		cc.p(502, 1064),
		cc.p(687, 930),
		cc.p(1120, 1136),
		cc.p(1280, 1250),
		cc.p(981, 1440)
	},
	{
		cc.p(981, 1440),
		cc.p(1280, 1250),
		cc.p(1120, 1136),
		cc.p(1362, 978),
		cc.p(1472, 1109),
		cc.p(1597, 1293),
		cc.p(1773, 1122),
		cc.p(2138, 1296),
		cc.p(2168, 1274),
		cc.p(2464, 1440)
	},
	{
		cc.p(3120, 1440),
		cc.p(2464, 1440),
		cc.p(2168, 1274),
		cc.p(2138, 1296),
		cc.p(1773, 1122),
		cc.p(1973, 1013),
		cc.p(2029, 1064),
		cc.p(2146, 1069),
		cc.p(2176, 928),
		cc.p(2389, 786),
		cc.p(2842, 968),
		cc.p(3120, 792)
	},
	{
		cc.p(3120, 0),
		cc.p(3120, 792),
		cc.p(2842, 968),
		cc.p(2389, 786),
		cc.p(2088, 621),
		cc.p(2200, 658),
		cc.p(2349, 594),
		cc.p(2434, 319),
		cc.p(2501, 279),
		cc.p(2488, 122),
		cc.p(2706, 0)
	},
	{
		cc.p(2706, 0),
		cc.p(2488, 122),
		cc.p(2501, 279),
		cc.p(2434, 319),
		cc.p(2349, 594),
		cc.p(2200, 658),
		cc.p(2088, 621),
		cc.p(2101, 528),
		cc.p(1933, 450),
		cc.p(1885, 410),
		cc.p(1904, 261),
		cc.p(2042, 165),
		cc.p(2040, 96),
		cc.p(1896, 0)
	},
	{
		cc.p(1896, 0),
		cc.p(2040, 96),
		cc.p(2042, 165),
		cc.p(1904, 261),
		cc.p(1885, 410),
		cc.p(1933, 450),
		cc.p(1762, 541),
		cc.p(1621, 594),
		cc.p(1528, 632),
		cc.p(1330, 765),
		cc.p(1269, 714),
		cc.p(1005, 669),
		cc.p(1093, 490),
		cc.p(1213, 394),
		cc.p(1253, 272),
		cc.p(1168, 162),
		cc.p(1200, 77),
		cc.p(1354, 0)
	},
	{
		cc.p(1354, 0),
		cc.p(1200, 77),
		cc.p(1168, 162),
		cc.p(1253, 272),
		cc.p(1213, 394),
		cc.p(1093, 490),
		cc.p(1005, 669),
		cc.p(594, 472),
		cc.p(719, 405),
		cc.p(397, 176),
		cc.p(658, 0)
	},
	{
		cc.p(1973, 1013),
		cc.p(2029, 1064),
		cc.p(2146, 1069),
		cc.p(2176, 928),
		cc.p(2389, 786),
		cc.p(2088, 621),
		cc.p(2101, 528),
		cc.p(1933, 450),
		cc.p(1762, 541),
		cc.p(1621, 594),
		cc.p(1578, 762),
		cc.p(1957, 896)
	},
	{
		cc.p(1957, 896),
		cc.p(1578, 762),
		cc.p(1621, 594),
		cc.p(1528, 632),
		cc.p(1330, 765),
		cc.p(1210, 890),
		cc.p(1362, 978),
		cc.p(1472, 1109),
		cc.p(1597, 1293),
		cc.p(1773, 1122),
		cc.p(1973, 1013)
	}
}
local var_0_2 = {
	LOCK = 1,
	CAN_CHALLENGE = 3,
	CANT_CHALLENGE = 2,
	PASSED = 4
}

local function var_0_3(arg_1_0)
	arg_1_0:hide()
	arg_1_0:stopAllActions()
end

local function var_0_4(arg_2_0)
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

local var_0_5 = {
	[var_0_2.LOCK] = function(arg_3_0, arg_3_1)
		var_0_3(arg_3_0)
		var_0_3(arg_3_1)
	end,
	[var_0_2.CANT_CHALLENGE] = function(arg_4_0, arg_4_1)
		var_0_3(arg_4_0)
		var_0_3(arg_4_1)
	end,
	[var_0_2.CAN_CHALLENGE] = function(arg_5_0, arg_5_1)
		arg_5_0:show()
		arg_5_0:opacity(255)
		arg_5_0:texture("activity/summer_challenge/txt_xrtz_tzz.png")
		arg_5_1:show()

		local var_5_0 = transition.sequence({
			cc.FadeTo:create(0.6, 70),
			cc.FadeTo:create(0.6, 255),
			cc.DelayTime:create(1.2)
		})
		local var_5_1 = transition.sequence({
			cc.FadeTo:create(0.6, 100),
			cc.FadeTo:create(0.6, 255),
			cc.DelayTime:create(1.2)
		})

		arg_5_1:stopAllActions()
		arg_5_0:stopAllActions()
		arg_5_1:runAction(cc.RepeatForever:create(var_5_0))
		arg_5_0:runAction(cc.RepeatForever:create(var_5_1))
	end,
	[var_0_2.PASSED] = function(arg_6_0, arg_6_1)
		arg_6_0:show()
		arg_6_0:texture("activity/summer_challenge/txt_xrtz_tzcg.png")
		arg_6_0:opacity(255)
		arg_6_0:stopAllActions()
		var_0_3(arg_6_1)
	end
}
local var_0_6 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = cc.c4b(91, 84, 91, 255)
		}
	}
}
local var_0_7 = cc.load("mvc").ViewBase
local var_0_8 = class("SummerChallengleView", var_0_7)

var_0_8.RESOURCE_FILENAME = "summer_challenge.json"
var_0_8.RESOURCE_BINDING = {
	["lightPanel.light1"] = "light1",
	leftPanel = "leftPanel",
	rightTimePanel = "rightTimePanel",
	["lightPanel.light2"] = "light2",
	mapPanel = "mapPanel",
	["lightPanel.light3"] = "light3",
	["leftPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["leftPanel.btnRule.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightTimePanel.time"] = {
		varname = "time",
		binds = var_0_6
	},
	["rightTimePanel.timeText"] = {
		varname = "timeText",
		binds = var_0_6
	}
}

function var_0_8.onCreate(arg_7_0, arg_7_1)
	arg_7_0.yyID = arg_7_1

	gGameUI.topuiManager:createView("title", arg_7_0, {
		onClose = arg_7_0:createHandler("onClose")
	}):init({
		subTitle = "SUMMER ADVENTURE",
		title = gLanguageCsv.summerChallenge
	})

	local var_7_0 = csv.yunying.yyhuodong[arg_7_1]
	local var_7_1 = time.getNumTimestamp(var_7_0.beginDate, time.getHourAndMin(var_7_0.beginTime, true))

	arg_7_0.endTime = time.getNumTimestamp(var_7_0.endDate, time.getHourAndMin(var_7_0.endTime, true))

	arg_7_0:initModel()
	arg_7_0:initGameTime(var_7_0)
	arg_7_0:initMap(var_7_0)
	arg_7_0:initLightAction()

	if arg_7_0.selectIndex then
		performWithDelay(arg_7_0, function()
			arg_7_0:onGateDetail(arg_7_0.selectIndex)
		end, 0)
	end

	idlereasy.when(arg_7_0.yyhuodongs, function(arg_9_0, arg_9_1)
		local var_9_0 = arg_9_1[arg_7_1] or {}
		local var_9_1 = var_9_0.stamps or {}
		local var_9_2 = time.getTime()
		local var_9_3 = math.ceil((var_9_2 - var_7_1) / 86400)
		local var_9_4 = (var_9_0.info or {}).all_pass

		arg_7_0:updateMapItems(var_9_1, var_9_3)
		performWithDelay(arg_7_0, function()
			arg_7_0:triggerGuide()
			arg_7_0:showAchievement(var_9_4)
		end, 0)
	end)
end

function var_0_8.initModel(arg_11_0)
	arg_11_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_8.initGameTime(arg_12_0, arg_12_1)
	local var_12_0, var_12_1, var_12_2 = time.getYearMonthDay(arg_12_1.beginDate)
	local var_12_3, var_12_4, var_12_5 = time.getYearMonthDay(arg_12_1.endDate)

	if matchLanguage({
		"en"
	}) then
		var_12_1 = var_0_4(var_12_1)
		var_12_4 = var_0_4(var_12_4)
	end

	arg_12_0.time:text(var_12_0 .. "." .. var_12_1 .. "." .. var_12_2 .. "-" .. var_12_3 .. "." .. var_12_4 .. "." .. var_12_5)
	adapt.oneLinePos(arg_12_0.time, arg_12_0.timeText, cc.p(5, 0), "right")
end

function var_0_8.initMap(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.paramMap.base

	arg_13_0.baseCsv = csv.summer_challenge.base[var_13_0]

	local var_13_1 = arg_13_0.baseCsv.gateSeqID
	local var_13_2 = {}

	for iter_13_0, iter_13_1 in orderCsvPairs(csv.summer_challenge.gates) do
		if iter_13_1.gateSeq == var_13_1 then
			var_13_2[iter_13_1.floor] = {
				gateCfg = iter_13_1,
				id = iter_13_0
			}
		end
	end

	arg_13_0.mapItems = {}

	for iter_13_2 = 1, var_0_0 do
		local var_13_3 = arg_13_0.mapPanel:get("item" .. iter_13_2)
		local var_13_4 = var_13_3:get("infoPanel")
		local var_13_5 = var_13_4:multiget("title")
		local var_13_6 = var_13_2[iter_13_2].gateCfg
		local var_13_7 = var_13_2[iter_13_2].id

		if matchLanguage({
			"en"
		}) then
			var_13_4:get("state"):y(250)
		end

		text.addEffect(var_13_5.title, {
			outline = {
				color = ui.COLORS.NORMAL.DEFAULT
			}
		})

		arg_13_0.mapItems[iter_13_2] = {
			gateID = var_13_7,
			floor = iter_13_2,
			item = var_13_3,
			gateCfg = var_13_6
		}
	end

	arg_13_0.mapPanel:onTouch(functools.partial(arg_13_0.onClickItem, arg_13_0))
end

function var_0_8.initLightAction(arg_14_0)
	arg_14_0.light1:setBlendFunc({
		src = GL_SRC_ALPHA,
		dst = GL_ONE
	})
	arg_14_0.light2:setBlendFunc({
		src = GL_SRC_ALPHA,
		dst = GL_ONE
	})
	arg_14_0.light3:setBlendFunc({
		src = GL_SRC_ALPHA,
		dst = GL_ONE
	})
	arg_14_0.light1:opacity(255)
	arg_14_0.light2:opacity(255)
	arg_14_0.light3:setRotation(10)

	local var_14_0 = transition.sequence({
		cc.FadeTo:create(1, 50),
		cc.FadeTo:create(1, 255)
	})
	local var_14_1 = transition.sequence({
		cc.FadeTo:create(0.5, 50),
		cc.FadeTo:create(0.5, 255)
	})
	local var_14_2 = transition.sequence({
		cc.RotateTo:create(3, -10),
		cc.RotateTo:create(3, 10)
	})

	arg_14_0.light1:runAction(cc.RepeatForever:create(var_14_0))
	arg_14_0.light2:runAction(cc.RepeatForever:create(var_14_1))
	arg_14_0.light3:runAction(cc.RepeatForever:create(var_14_2))
end

function var_0_8.onClickItem(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.target:convertToNodeSpace(arg_15_1)

	if arg_15_1.name == "began" then
		arg_15_0.touchIndex = dataEasy.checkInRect(var_0_1, var_15_0)
	elseif arg_15_1.name == "ended" or arg_15_1.name == "cancelled" then
		if arg_15_0.touchIndex == nil then
			return
		end

		if arg_15_0.touchIndex == dataEasy.checkInRect(var_0_1, var_15_0) then
			local var_15_1 = arg_15_0.mapItems[arg_15_0.touchIndex].state

			if var_15_1 == var_0_2.LOCK then
				gGameUI:showTip(gLanguageCsv.gateLock)
			elseif var_15_1 == var_0_2.CANT_CHALLENGE then
				gGameUI:showTip(gLanguageCsv.gateClosed)
			else
				arg_15_0:onGateDetail(arg_15_0.touchIndex)
			end
		end
	end
end

function var_0_8.onGateDetail(arg_16_0, arg_16_1)
	arg_16_0.selectIndex = arg_16_1
	arg_16_0.gateDetailView = gGameUI:stackUI("city.activity.summer_challenge.gate_detail", nil, nil, {
		yyID = arg_16_0.yyID,
		data = arg_16_0.mapItems[arg_16_1],
		handler = arg_16_0:createHandler("startFighting")
	})
end

function var_0_8.updateMapItems(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0.maxPassedFloor = arg_17_0:getMaxPassedFloor(arg_17_1)

	for iter_17_0, iter_17_1 in ipairs(arg_17_0.mapItems) do
		local var_17_0 = iter_17_1.gateID
		local var_17_1 = iter_17_1.floor
		local var_17_2 = iter_17_1.item
		local var_17_3 = iter_17_1.gateCfg
		local var_17_4 = arg_17_2 >= var_17_3.openDay
		local var_17_5 = arg_17_1[var_17_0] == 1

		if var_17_5 then
			local var_17_6 = string.format("summerChallengeEmbattle%d", var_17_0)

			userDefault.setForeverLocalKey(var_17_6, nil)
		end

		local var_17_7 = arg_17_0.maxPassedFloor + 1 == var_17_1
		local var_17_8 = var_17_2:get("infoPanel.state")
		local var_17_9 = var_17_2:get("infoPanel.title")
		local var_17_10 = var_17_2:get("light")

		var_17_2:get("mask"):visible(not var_17_4)
		var_17_2:get("bg"):visible(var_17_4)

		if var_17_4 then
			var_17_9:text(string.format("%s%s %s", gLanguageCsv.gate, var_17_1, var_17_3.name))
		else
			local var_17_11 = var_17_3.openDay - arg_17_2

			if var_17_11 == 1 then
				var_17_9:text(gLanguageCsv.openTomorrow)
			else
				var_17_9:text(string.format(gLanguageCsv.openDays, var_17_11))
			end
		end

		if matchLanguage({
			"kr"
		}) then
			adapt.setTextAdaptWithSize(var_17_9, {
				margin = -5,
				vertical = "center",
				horizontal = "center",
				maxLine = 2,
				size = cc.size(320, 58)
			})
		end

		local var_17_12 = arg_17_0:getGateState(var_17_4, var_17_5, var_17_7)

		iter_17_1.state = var_17_12

		var_0_5[var_17_12](var_17_8, var_17_10)
	end
end

function var_0_8.triggerGuide(arg_18_0)
	local var_18_0 = arg_18_0.maxPassedFloor + 1

	if var_18_0 <= var_0_0 and arg_18_0.mapItems[var_18_0].gateCfg.beforePlot then
		local var_18_1 = arg_18_0.mapItems[var_18_0].gateCfg.beforePlot
		local var_18_2 = gGameUI.guideManagerLocal.guideCsv[var_18_1]
		local var_18_3 = var_18_2.specialName

		if not var_18_3 then
			return false
		end

		local var_18_4 = var_18_2.stage

		if arg_18_0.mapItems[var_18_0].gateCfg.beforePlotRepeat then
			gGameUI.guideManagerLocal:onDeleteStage(var_18_4)
		end

		if not gGameUI.guideManagerLocal:checkFinished(var_18_4) then
			if arg_18_0.gateDetailView and gGameUI:findStackUI("city.activity.summer_challenge.gate_detail") then
				arg_18_0.gateDetailView:onClose()

				arg_18_0.gateDetailView = nil
			end

			gGameUI.guideManagerLocal:setChoicesFunc(functools.partial(arg_18_0.onChoose, arg_18_0))
			gGameUI.guideManagerLocal:checkGuide({
				specialName = var_18_3
			})

			return true
		end
	end

	return false
end

function var_0_8.showAchievement(arg_19_0, arg_19_1)
	if arg_19_1 == 1 then
		if not userDefault.getForeverLocalKey("SummerChallenglePass", false) then
			userDefault.setForeverLocalKey("SummerChallenglePass", true)
			gGameUI:stackUI("city.activity.summer_challenge.gain_achievement", nil, nil, {
				itemId = arg_19_0.baseCsv.achievementID
			})
		end
	else
		userDefault.setForeverLocalKey("SummerChallenglePass", false)
	end
end

function var_0_8.getGateState(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = var_0_2.LOCK

	if arg_20_1 then
		if arg_20_2 then
			var_20_0 = var_0_2.PASSED
		elseif not arg_20_3 then
			var_20_0 = var_0_2.CANT_CHALLENGE
		else
			var_20_0 = var_0_2.CAN_CHALLENGE
		end
	end

	return var_20_0
end

function var_0_8.getMaxPassedFloor(arg_21_0, arg_21_1)
	local var_21_0 = 0

	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		var_21_0 = math.max(csv.summer_challenge.gates[iter_21_0].floor, var_21_0)
	end

	return var_21_0
end

function var_0_8.onShowRule(arg_22_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_22_0:createHandler("getRuleContext"))
end

function var_0_8.getRuleContext(arg_23_0, arg_23_1)
	local var_23_0 = adaptContext

	return {
		var_23_0.clone(arg_23_1.title, function(arg_24_0)
			arg_24_0:get("text"):text(gLanguageCsv.summerChallenge)
		end),
		var_23_0.noteText(125001, 125020)
	}
end

function var_0_8.startFighting(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if time.getTime() > arg_25_0.endTime then
		gGameUI:showTip(gLanguageCsv.activityOver)

		return
	end

	arg_25_0:disableSchedule()
	gGameUI.guideManagerLocal:setChoicesFunc()
	battleEntrance.battleRequest("/game/yy/summer_challenge/battle/start", arg_25_0.yyID, arg_25_0.mapItems[arg_25_0.selectIndex].gateID, arg_25_3):onStartOK(function(arg_26_0)
		if arg_25_1 then
			arg_25_1:onClose(false)

			arg_25_1 = nil
		end

		if arg_25_2 then
			arg_25_2:onClose(false)

			arg_25_2 = nil
		end

		arg_25_0.gateDetailView = nil
	end):onResult(function(arg_27_0, arg_27_1)
		if arg_27_1.result == "win" then
			arg_25_0.selectIndex = nil
		end
	end):show()
end

function var_0_8.onChoose(arg_28_0, arg_28_1, arg_28_2)
	gGameApp:requestServer("/game/yy/summer_challenge/choose", nil, arg_28_0.yyID, arg_28_2.id)
end

function var_0_8.onClose(arg_29_0)
	gGameUI.guideManagerLocal:setChoicesFunc()
	var_0_7.onClose(arg_29_0)
end

function var_0_8.onTestDraw(arg_30_0, arg_30_1)
	if not arg_30_0.drawNode then
		arg_30_0.drawNode = cc.DrawNode:create()

		arg_30_0.drawNode:xy(0, 0):addTo(arg_30_0.mapPanel, 13)
	end

	arg_30_0.drawNode:clear()
	arg_30_0.drawNode:drawPolygon(var_0_1[arg_30_1], table.length(var_0_1[arg_30_1]), cc.c4f(0.9450980392156862, 0.3607843137254902, 0.3843137254901961, 0.6), 0.5, cc.c4f(0.9450980392156862, 0.3607843137254902, 0.3843137254901961, 0.6))
end

return var_0_8
