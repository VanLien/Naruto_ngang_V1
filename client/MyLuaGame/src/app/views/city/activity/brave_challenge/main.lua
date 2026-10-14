local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = 0.5
local var_0_2 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = cc.c4b(82, 76, 85, 255)
		}
	}
}
local var_0_3 = cc.load("mvc").ViewBase
local var_0_4 = class("BraveChallengeMainView", var_0_3)

var_0_4.RESOURCE_FILENAME = "activity_brave_challenge_main.json"
var_0_4.RESOURCE_BINDING = {
	centerPanel = "centerPanel",
	["centerPanel.tipBg"] = "tipBg",
	["centerPanel.btnGame.img"] = "imgBtnGame",
	["centerPanel.panelTime"] = "panelTime",
	rightDownPanel = "rightDownPanel",
	leftDownPanel = "leftDownPanel",
	doorPanel = {
		varname = "doorPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayGameClick")
			}
		}
	},
	["centerPanel.txtTimes"] = {
		varname = "txtCTimes",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			},
			{
				event = "text",
				idler = bindHelper.self("txtTimes")
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
	["centerPanel.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	["leftDownPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["leftDownPanel.btnRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["leftDownPanel.btnAchievement"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onAchievementClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "braveChallengeAch",
					listenData = {
						activityId = bindHelper.self("activityId"),
						sign = bindHelper.self("sign")
					},
					onNode = function(arg_1_0)
						arg_1_0:scale(0.5)
						arg_1_0:xy(100, 100)
					end
				}
			}
		}
	},
	["rightDownPanel.timesNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("passTimes")
		}
	},
	["rightDownPanel.roundNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("clearanceRoundNum")
		}
	},
	["centerPanel.panelTime.txtTime"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	}
}

function var_0_4.onCreate(arg_2_0, arg_2_1)
	arg_2_0:initModel()

	arg_2_0.parent = arg_2_1.parent
	arg_2_0.activityId = arg_2_0.id:read()
	arg_2_0.sign = var_0_0.typ
	arg_2_0.cost = 0
	arg_2_0.clearanceTimesNum = idler.new()
	arg_2_0.clearanceRoundNum = idler.new()
	arg_2_0.txtTimes = idler.new()

	arg_2_0:initReflushIdler()
	idlereasy.when(arg_2_0.rank, function(arg_3_0, arg_3_1)
		arg_2_0.clearanceRoundNum:set(arg_3_1.round)
	end)
	idlereasy.when(arg_2_0.passTimes, function(arg_4_0, arg_4_1)
		arg_2_0.rightDownPanel:visible(arg_4_1 > 0)
	end)
	idlereasy.when(arg_2_0.status, function(arg_5_0, arg_5_1)
		arg_2_0.imgBtnGame:texture(arg_5_1 == "start" and "activity/brave_challenge/txt_yztz_7.png" or "activity/brave_challenge/txt_yztz_3.png")
	end)
end

function var_0_4.initModel(arg_6_0)
	arg_6_0.passTimes = gGameModel.brave_challenge:getIdler("pass_times")
	arg_6_0.rank = gGameModel.brave_challenge:getIdler("rank")
	arg_6_0.status = gGameModel.brave_challenge:getIdler("status")
	arg_6_0.id = gGameModel.brave_challenge:getIdler("yyID")
	arg_6_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_6_0.commonBCData = gGameModel.role:getIdler("normal_brave_challenge")
end

function var_0_4.onPlayGameClick(arg_7_0)
	if arg_7_0.parent.comingSoon then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	local var_7_0 = arg_7_0.parent:getEndTime()

	if var_7_0 == nil or math.floor(var_7_0 - time.getTime()) <= 0 then
		gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)

		return
	end

	if arg_7_0.status:read() == "start" then
		arg_7_0.parent:openOtherView("city.activity.brave_challenge.challenge_gate", 3)
	else
		if arg_7_0.remainTimes == 0 then
			gGameUI:showTip(gLanguageCsv.gameTimesLimit)

			return
		end

		gGameApp:requestServer(var_0_0.url("preStart"), function(arg_8_0)
			arg_7_0.parent:openOtherView("city.activity.brave_challenge.select_card", 2, false, arg_8_0.view)
		end, arg_7_0.activityId)
	end
end

function var_0_4.runStartAction(arg_9_0)
	local var_9_0 = arg_9_0:getResourceNode()
	local var_9_1

	local function var_9_2(arg_10_0)
		for iter_10_0, iter_10_1 in pairs(arg_10_0:getChildren()) do
			if iter_10_1:getChildrenCount() == 0 then
				iter_10_1:runAction(cc.EaseOut:create(cc.FadeIn:create(var_0_1), var_0_1))
			else
				var_9_2(iter_10_1)
			end
		end
	end

	var_9_2(var_9_0)
end

function var_0_4.runEndAction(arg_11_0)
	local var_11_0 = arg_11_0:getResourceNode()
	local var_11_1

	local function var_11_2(arg_12_0)
		for iter_12_0, iter_12_1 in pairs(arg_12_0:getChildren()) do
			if iter_12_1:getChildrenCount() == 0 then
				iter_12_1:runAction(cc.EaseOut:create(cc.FadeOut:create(var_0_1), var_0_1))
			else
				var_11_2(iter_12_1)
			end
		end
	end

	var_11_2(var_11_0)
end

function var_0_4.onAddClick(arg_13_0)
	if arg_13_0.parent.comingSoon then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	local var_13_0 = arg_13_0.parent:getEndTime()
	local var_13_1 = 0

	if var_13_0 == nil or math.floor(var_13_0 - time.getTime()) <= 0 then
		gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)

		return
	end

	if arg_13_0.canBuy == false then
		gGameUI:showTip(gLanguageCsv.buyTimesLimit)

		return
	end

	local var_13_2 = gLanguageCsv.buyGameTimes

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		cb = function()
			if arg_13_0.cost > gGameModel.role:read("rmb") then
				uiEasy.showDialog("rmb")
			else
				gGameApp:requestServer(var_0_0.url("buy"), function(arg_15_0)
					gGameUI:showTip(gLanguageCsv.buySuccess)
				end, arg_13_0.activityId)
			end
		end,
		title = gLanguageCsv.spaceTips,
		content = string.format(var_13_2, arg_13_0.cost),
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_4.onAchievementClick(arg_16_0)
	if arg_16_0.parent.comingSoon then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	local var_16_0 = arg_16_0.parent:getBaseInfo()

	gGameUI:stackUI("city.activity.brave_challenge.achievement", nil, nil, arg_16_0.activityId, var_16_0)
end

function var_0_4.onRankClick(arg_17_0)
	if arg_17_0.parent.comingSoon then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	gGameApp:requestServer(var_0_0.url("rank"), function(arg_18_0)
		gGameUI:stackUI("city.activity.brave_challenge.rank", nil, nil, arg_18_0.view)
	end, arg_17_0.activityId)
end

function var_0_4.onRuleClick(arg_19_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_19_0:createHandler("getRuleContext"))
end

function var_0_4.getRuleContext(arg_20_0, arg_20_1)
	local var_20_0 = adaptContext

	return {
		var_20_0.clone(arg_20_1.title, function(arg_21_0)
			arg_21_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_20_0.noteText(122001, 122030)
	}
end

function var_0_4.initCountDown(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.panelTime:visible(not arg_22_1)

	if arg_22_1 then
		return
	end

	local var_22_0 = arg_22_0.parent:getBaseInfo().addTimes or 0

	arg_22_2 = var_22_0 < arg_22_2 and var_22_0 or arg_22_2
	arg_22_0.downTime = time.getNumTimestamp(time.getNextdayStrInClock(), time.getRefreshHour())

	local function var_22_1()
		local var_23_0 = arg_22_0.panelTime:get("txtTime")
		local var_23_1 = string.format(gLanguageCsv.braveChallengeRecoverTimeTip, time.getCutDown(arg_22_0.downTime - time.getTime(), true).str, arg_22_2)

		var_23_0:text(var_23_1)

		return true
	end

	var_22_1()
	arg_22_0:enableSchedule()
	arg_22_0:schedule(function(arg_24_0)
		return var_22_1()
	end, 1, 0, 1)
	arg_22_0:requestMain(0)
end

function var_0_4.requestMain(arg_25_0, arg_25_1)
	arg_25_0.downTime = time.getNumTimestamp(time.getNextdayStrInClock(), time.getRefreshHour())

	local var_25_0 = math.max(arg_25_0.downTime - time.getTime() + 1, arg_25_1)

	performWithDelay(arg_25_0, function()
		gGameApp:requestServer(var_0_0.url("main"), function()
			arg_25_0:requestMain(10)
		end)
	end, var_25_0)
end

function var_0_4.setCenterPanelVisible(arg_28_0, arg_28_1)
	arg_28_0.centerPanel:visible(arg_28_1)
end

function var_0_4.initReflushIdler(arg_29_0)
	local var_29_0 = arg_29_0.parent:getBaseInfo()

	if not var_29_0.buyTimes then
		local var_29_1 = 0
	end

	local var_29_2 = var_29_0.timesLimit or 0

	if not var_29_0.addTimes then
		local var_29_3 = 0
	end

	local var_29_4 = var_29_0.buyCost or {}

	if var_0_0.typ == game.BRAVE_CHALLENGE_TYPE.anniversary then
		idlereasy.when(arg_29_0.yyhuodongs, function(arg_30_0, arg_30_1)
			local var_30_0 = arg_30_1[arg_29_0.activityId]
			local var_30_1 = var_30_0.info.buyTimes
			local var_30_2 = var_30_0.info.times

			arg_29_0.canBuy = var_30_1 < var_30_1

			if not (var_30_1 + 1 <= itertools.size(var_29_4)) or not (var_30_1 + 1) then
				local var_30_3 = itertools.size(var_29_4)
			end

			arg_29_0.cost = var_29_4[var_30_1 + 1]

			arg_29_0.btnAdd:visible(var_30_1 ~= 0)

			if var_30_1 == 0 then
				arg_29_0.txtCTimes:x(200)
			end

			arg_29_0.remainTimes = var_29_2 + var_30_1 - var_30_2

			arg_29_0.txtTimes:set(gLanguageCsv.braveChallengeGameTimes .. arg_29_0.remainTimes)
			arg_29_0:initCountDown(true)
		end)
	else
		idlereasy.when(arg_29_0.commonBCData, function(arg_31_0, arg_31_1)
			if not arg_31_1.info then
				return
			end

			local var_31_0 = arg_31_1.info.buyTimes
			local var_31_1 = arg_31_1.info.times

			arg_29_0.canBuy = var_31_0 < var_31_0

			if not (var_31_0 + 1 <= itertools.size(var_29_4)) or not (var_31_0 + 1) then
				local var_31_2 = itertools.size(var_29_4)
			end

			arg_29_0.cost = var_29_4[var_31_0 + 1]

			arg_29_0.btnAdd:visible(var_31_0 ~= 0)

			arg_29_0.remainTimes = var_29_2 + var_31_0 - var_31_1

			local var_31_3 = arg_29_0.remainTimes >= var_29_2 and "#C0xFFFFFF#" or "#C0x88C855#"
			local var_31_4 = string.format(gLanguageCsv.braveChallengeRecoverTimeTip02, var_31_3, arg_29_0.remainTimes, var_29_2)
			local var_31_5 = arg_29_0.txtCTimes:parent():get("richTimes")

			if var_31_5 then
				var_31_5:removeFromParent()
			end

			local var_31_6 = rich.createWithWidth(var_31_4, 40, nil, 250, nil, cc.p(0, 0.5)):anchorPoint(cc.p(0, 0.5)):xy(220, 90):addTo(arg_29_0.txtCTimes:parent()):name("richTimes")

			arg_29_0.txtCTimes:visible(false)
			arg_29_0:initCountDown(arg_29_0.remainTimes >= var_29_2, var_29_2 - arg_29_0.remainTimes)
		end)
	end
end

return var_0_4
