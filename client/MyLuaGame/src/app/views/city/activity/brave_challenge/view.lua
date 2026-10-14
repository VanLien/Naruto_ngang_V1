local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = 0.5
local var_0_2 = 1
local var_0_3 = {
	{
		scale = 1.2,
		posY = 432
	},
	{
		scale = 1,
		posY = 864
	},
	{
		scale = 1,
		posY = 576
	}
}
local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("BraveChallengeView", var_0_4)

var_0_5.RESOURCE_FILENAME = "activity_brave_challenge_view.json"
var_0_5.RESOURCE_BINDING = {
	["panelOpt.doorPanel"] = "doorPanel",
	["panelOpt.viewPanel"] = "viewPanel",
	["panelOpt.panelCard"] = "panelCard",
	panelOpt = "panelOpt",
	["panelOpt.img01"] = "img01",
	["panelOpt.txtTime"] = {
		varname = "txtTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.topuiBiew = gGameUI.topuiManager:createView("title", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "BRAVE CHALLENGE",
		title = gLanguageCsv.braveChallenge
	})

	var_0_0.set(arg_1_2 or game.BRAVE_CHALLENGE_TYPE.anniversary)
	arg_1_0:initModel()
	arg_1_0:initBg()

	arg_1_0.subViews = arg_1_0.subViews or {}
	arg_1_0.curStatus = idler.new(arg_1_0.curStatus or 1)
	arg_1_0.panelPos = arg_1_0.panelPos or {}

	if #arg_1_0.subViews == 0 then
		arg_1_0:addView("city.activity.brave_challenge.main", 1)
		arg_1_0.curStatus:set(1)
	else
		arg_1_0:resetView()
	end

	arg_1_0.curStatus:addListener(function(arg_2_0, arg_2_1)
		if arg_2_0 == arg_2_1 then
			arg_1_0:setBGStatus(arg_2_0)
		else
			arg_1_0:playActionByType(arg_2_1, arg_2_0)
		end

		arg_1_0:updateTitle(arg_2_0)
	end)
	arg_1_0:initPanelPos()
	arg_1_0:updateTime()
end

function var_0_5.initModel(arg_3_0)
	arg_3_0.id = gGameModel.brave_challenge:getIdler("yyID")
	arg_3_0.gameInfo = gGameModel.brave_challenge:getIdler("game")
	arg_3_0.baseID = gGameModel.brave_challenge:getIdler("baseCfgID")
	arg_3_0.clearanceTimesNum = idler.new(arg_3_0.passTimes)
end

function var_0_5.initBg(arg_4_0)
	local var_4_0 = arg_4_0:getBaseInfo()

	arg_4_0.img01:texture(var_4_0.background)
end

function var_0_5.getBaseInfo(arg_5_0)
	local var_5_0 = 1

	if var_0_0.typ == game.BRAVE_CHALLENGE_TYPE.common then
		var_5_0 = 101
	end

	return csv.brave_challenge.base[arg_5_0.baseID:read()] or csv.brave_challenge.base[var_5_0]
end

function var_0_5.resetView(arg_6_0)
	for iter_6_0, iter_6_1 in ipairs(arg_6_0.subViews) do
		iter_6_1.view = gGameUI:createView(iter_6_1.name, arg_6_0):init({
			parent = arg_6_0
		})

		if iter_6_0 < #arg_6_0.subViews then
			iter_6_1.view:hide()
		end
	end
end

function var_0_5.setBGStatus(arg_7_0, arg_7_1)
	arg_7_0.panelOpt:scale(var_0_3[arg_7_1].scale)
	arg_7_0.panelOpt:y(var_0_3[arg_7_1].posY)
end

function var_0_5.playActionByType(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = var_0_3[arg_8_1]
	local var_8_1 = var_0_3[arg_8_2]
	local var_8_2 = arg_8_0.panelOpt:x()

	arg_8_0.panelOpt:runAction(cc.EaseOut:create(cc.ScaleTo:create(var_0_1, var_8_1.scale), var_0_1))
	arg_8_0.panelOpt:runAction(cc.EaseOut:create(cc.MoveTo:create(var_0_1, cc.p(var_8_2, var_8_1.posY)), var_0_1))
end

function var_0_5.addView(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = {
		name = arg_9_1,
		typ = arg_9_2,
		datas = arg_9_3
	}

	var_9_0.view = gGameUI:createView(arg_9_1, arg_9_0):init({
		parent = arg_9_0,
		data = var_9_0
	})

	table.insert(arg_9_0.subViews, var_9_0)
end

function var_0_5.setType(arg_10_0, arg_10_1)
	local var_10_0 = #arg_10_0.subViews - 1
	local var_10_1 = arg_10_0.subViews[var_10_0]

	var_10_1.view:runEndAction()
	arg_10_0.curStatus:set(arg_10_1)
	arg_10_0:runAction(cc.Sequence:create(cc.DelayTime:create(var_0_1), cc.CallFunc:create(function()
		if var_10_1.sign then
			arg_10_0:removeView(var_10_0)
		else
			var_10_1.view:hide()
		end
	end), nil))
	arg_10_0:runDoorEndAction()
end

function var_0_5.removeView(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or #arg_12_0.subViews

	arg_12_0.subViews[arg_12_1].view:onClose()
	table.remove(arg_12_0.subViews, arg_12_1)
end

function var_0_5.openOtherView(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if arg_13_1 then
		local var_13_0 = arg_13_0.subViews[#arg_13_0.subViews]

		if var_13_0.typ == arg_13_2 then
			return
		end

		var_13_0.sign = arg_13_3

		arg_13_0:addView(arg_13_1, arg_13_2, arg_13_4)
	end
end

function var_0_5.onClose(arg_14_0)
	if #arg_14_0.subViews == 1 then
		var_0_4.onClose(arg_14_0)
	else
		local var_14_0 = arg_14_0.subViews[#arg_14_0.subViews]
		local var_14_1 = arg_14_0.subViews[#arg_14_0.subViews - 1]

		var_14_0.view:runEndAction()
		arg_14_0.curStatus:set(var_14_1.typ)
		gGameUI:disableTouchDispatch(nil, false)
		arg_14_0:runAction(cc.Sequence:create(cc.DelayTime:create(var_0_1), cc.CallFunc:create(function()
			arg_14_0:removeView()
			var_14_1.view:show()
			var_14_1.view:runStartAction()
			gGameUI:disableTouchDispatch(nil, true)

			if #arg_14_0.subViews == 1 then
				arg_14_0:showCardPanel(false)
				arg_14_0:runDoorStartAction()
			end
		end), nil))
	end
end

function var_0_5.saveData(arg_16_0)
	for iter_16_0, iter_16_1 in pairs(arg_16_0.subViews) do
		iter_16_1.view:onClose()
	end

	arg_16_0.curStatus = arg_16_0.curStatus:read()
end

function var_0_5.startFighting(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0.comingSoon then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	arg_17_0:disableSchedule()
	battleEntrance.battleRequest(var_0_0.url("battleStart"), arg_17_0.gameInfo:read().floorID, arg_17_0.gameInfo:read().monsterID, arg_17_2, arg_17_0.id:read()):onStartOK(function(arg_18_0)
		if arg_17_1 then
			arg_17_1:onClose(false)

			arg_17_1 = nil

			arg_17_0:saveData()
		end
	end):show()
end

function var_0_5.updateTime(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1 or arg_19_0:getEndTime()

	bind.extend(arg_19_0, arg_19_0.txtTime, {
		class = "cutdown_label",
		props = {
			endTime = var_19_0,
			strFunc = function(arg_20_0)
				if arg_19_1 then
					return string.format(gLanguageCsv.bcActivityNextTime, arg_20_0.str)
				end

				return string.format(gLanguageCsv.bcActivityTime, arg_20_0.str)
			end,
			endFunc = function()
				if arg_19_1 then
					performWithDelay(arg_19_0, function()
						gGameApp:requestServer(var_0_0.url("main"), function()
							arg_19_0.subViews[1].view:setCenterPanelVisible(true)
							arg_19_0:updateTime()
						end)
					end, 1)
				else
					arg_19_0.comingSoon = true

					arg_19_0.subViews[1].view:setCenterPanelVisible(false)

					local var_21_0

					var_21_0 = arg_19_0.updateTimeEnd and 1 or 0
					arg_19_0.updateTimeEnd = true

					arg_19_0.txtTime:text("")
					performWithDelay(arg_19_0, function()
						gGameApp:requestServer(var_0_0.url("main"), function()
							if ((gGameModel.global_record:read("normal_brave_challenge") or {}).endTime or 0) == 0 and csv.brave_challenge.open[1] then
								local var_25_0 = time.getNumTimestamp(csv.brave_challenge.open[1].startTime, time.getRefreshHour())

								arg_19_0:updateTime(var_25_0)

								return
							end

							local var_25_1 = arg_19_0:getEndTime()

							arg_19_0.comingSoon = true

							if var_25_1 + 604800 < time.getTime() then
								arg_19_0.txtTime:text(gLanguageCsv.comingSoon)
							else
								arg_19_0:updateTime(var_25_1 + 604800)
							end
						end)
					end, 0)
				end
			end
		}
	})
end

function var_0_5.updateTitle(arg_26_0, arg_26_1)
	if arg_26_1 == 2 then
		arg_26_0.topuiBiew:updateTitle(gLanguageCsv.bcTitle, "BRAVE CHALLENGE")
	else
		local var_26_0 = arg_26_0:getBaseInfo()

		arg_26_0.topuiBiew:updateTitle(var_26_0.title or gLanguageCsv.braveChallenge, "BRAVE CHALLENGE")
	end
end

function var_0_5.runDoorStartAction(arg_27_0)
	local var_27_0

	local function var_27_1(arg_28_0)
		for iter_28_0, iter_28_1 in pairs(arg_28_0:getChildren()) do
			if iter_28_1:getChildrenCount() == 0 then
				iter_28_1:runAction(cc.EaseOut:create(cc.FadeIn:create(var_0_1), var_0_1))
			else
				var_27_1(iter_28_1)
			end
		end
	end

	var_27_1(arg_27_0.doorPanel)
end

function var_0_5.runDoorEndAction(arg_29_0)
	local var_29_0

	local function var_29_1(arg_30_0)
		for iter_30_0, iter_30_1 in pairs(arg_30_0:getChildren()) do
			if iter_30_1:getChildrenCount() == 0 then
				iter_30_1:runAction(cc.EaseOut:create(cc.FadeOut:create(var_0_1), var_0_1))
			else
				var_29_1(iter_30_1)
			end
		end
	end

	var_29_1(arg_29_0.doorPanel)
end

function var_0_5.initPanelPos(arg_31_0)
	for iter_31_0 = 1, 6 do
		local var_31_0 = arg_31_0.panelCard:get(string.format("item%d", iter_31_0))

		arg_31_0.panelPos[iter_31_0] = cc.p(var_31_0:xy())
	end
end

function var_0_5.showCardsDeployments(arg_32_0, arg_32_1)
	for iter_32_0 = 1, 6 do
		local var_32_0 = arg_32_1[iter_32_0]
		local var_32_1 = arg_32_0.panelCard:get(string.format("item%d", iter_32_0))

		var_32_1:xy(arg_32_0.panelPos[iter_32_0].x, arg_32_0.panelPos[iter_32_0].y)

		if not var_32_0 then
			if var_32_1:getChildByName("sprite") then
				var_32_1:getChildByName("sprite"):hide()
			end
		else
			local var_32_2 = csv.unit[var_32_0.unit_id]

			if var_32_1.csvID == var_32_0.csvID and var_32_1:getChildByName("sprite") then
				var_32_1:getChildByName("sprite"):show()
			else
				var_32_1:removeChildByName("sprite")
				widget.addAnimationByKey(var_32_1, var_32_2.unitRes, "sprite", "standby_loop", 4):scale(var_32_2.scale * (0.8 + (iter_32_0 - 1) % 3 * 0.1)):xy(175, 75):setSkin(var_32_2.skin)

				var_32_1.csvID = var_32_0.csvID
			end
		end
	end
end

function var_0_5.runCardAction(arg_33_0)
	for iter_33_0 = 1, 6 do
		local var_33_0 = arg_33_0.panelCard:get(string.format("item%d", iter_33_0))
		local var_33_1 = var_33_0:getChildByName("sprite")

		if var_33_1 then
			var_33_1:play("run_loop")
		end

		local var_33_2, var_33_3 = var_33_0:xy()

		var_33_0:runAction(cc.MoveTo:create(var_0_2, cc.p(var_33_2 + 1000, var_33_3)))
	end
end

function var_0_5.showCardPanel(arg_34_0, arg_34_1)
	arg_34_0.panelCard:visible(arg_34_1)
end

function var_0_5.resetPanelPos(arg_35_0)
	for iter_35_0 = 1, 6 do
		local var_35_0 = arg_35_0.panelCard:get(string.format("item%d", iter_35_0))

		var_35_0:xy(arg_35_0.panelPos[iter_35_0].x, arg_35_0.panelPos[iter_35_0].y)

		local var_35_1 = var_35_0:getChildByName("sprite")

		if var_35_1 then
			var_35_1:play("standby_loop")
		end
	end
end

function var_0_5.getEndTime(arg_36_0)
	if var_0_0.typ == game.BRAVE_CHALLENGE_TYPE.anniversary then
		return gGameModel.role:read("yy_endtime")[arg_36_0.id:read()]
	else
		arg_36_0.comingSoon = false

		local var_36_0 = gGameModel.global_record:read("normal_brave_challenge") or {}
		local var_36_1 = var_36_0.endTime or 0

		gGameModel.forever_dispatch:getIdlerOrigin("braveChallengeEachClick"):set(var_36_1)

		if var_36_1 == 0 then
			return time.getNumTimestamp(20210101, time.getRefreshHour())
		end

		return time.getNumTimestamp(var_36_0.endTime, time.getRefreshHour())
	end
end

return var_0_5
