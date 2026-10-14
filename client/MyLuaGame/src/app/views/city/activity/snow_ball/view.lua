local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SnowBallView", var_0_0)

var_0_1.RESOURCE_FILENAME = "snow_ball_view.json"
var_0_1.RESOURCE_BINDING = {
	["centerPanel.btnGame"] = {
		varname = "btnGame",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onPlayGameClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("gameRedHint"),
					onNode = function(arg_1_0)
						arg_1_0:xy(450, 200)
					end
				}
			}
		}
	},
	["centerPanel.textTipTime"] = {
		varname = "textTipTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(82, 76, 85, 255)
				}
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
	["rightDownPanel.btnAward"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRewardClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("awardRedHint"),
					onNode = function(arg_2_0)
						arg_2_0:xy(200, 200)
					end
				}
			}
		}
	},
	["rightDownPanel.btnRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["rightDownPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.activityId = arg_3_1

	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "SNOW GAME",
		title = gLanguageCsv.snowBallGame
	})
	arg_3_0:initModel()
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_4_0.awardRedHint = idler.new(false)
	arg_4_0.gameRedHint = idler.new(false)
	arg_4_0.cost = 0
	arg_4_0.times = 0
	arg_4_0.canBuy = false
	arg_4_0.canPlay = false

	local var_4_0 = csv.yunying.yyhuodong[arg_4_0.activityId].paramMap

	idlereasy.when(arg_4_0.yyhuodongs, function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[arg_4_0.activityId] or {}
		local var_5_1 = var_5_0.info or {
			top_role = 0,
			sign = 0,
			top_time = 0,
			days = 0,
			total_point = 0,
			times = 0,
			rank = 0,
			top_point = 0,
			buy_times = 0,
			isGuide = 0
		}

		arg_4_0.roleData = var_5_1
		arg_4_0.snowData = var_5_0.snowball
		arg_4_0.times = var_4_0.times + var_5_1.buy_times - var_5_1.times
		arg_4_0.canBuy = var_5_1.buy_times < var_4_0.buyTimes
		arg_4_0.canPlay = arg_4_0.times > 0

		local var_5_2 = var_4_0.buyCost

		arg_4_0.gameRedHint:set(arg_4_0.times > 0)
		arg_4_0.awardRedHint:set(false)

		for iter_5_0, iter_5_1 in pairs(var_5_0.stamps or {}) do
			if iter_5_1 == 1 then
				arg_4_0.awardRedHint:set(true)

				break
			end
		end

		arg_4_0.cost = var_5_1.buy_times + 1 <= itertools.size(var_5_2) and var_5_2[var_5_1.buy_times + 1] or var_5_2[itertools.size(var_5_2)]

		arg_4_0.textTipTime:text(gLanguageCsv.todayNumber .. arg_4_0.times)
		adapt.oneLineCenterPos(cc.p(310, 280), {
			arg_4_0.textTipTime,
			arg_4_0.btnAdd
		}, {
			cc.p(5, 0)
		})

		if var_5_1.isGuide == 0 then
			arg_4_0.btnGame:get("Image_36"):texture("activity/snow_ball/txt_xqdbs_ksjx.png")
		else
			arg_4_0.btnGame:get("Image_36"):texture("activity/snow_ball/txt_xqdbs_ksyx.png")
		end
	end)
end

function var_0_1.onPlayGameClick(arg_6_0)
	if arg_6_0.canPlay then
		gGameUI:stackUI("city.activity.snow_ball.choose_role", nil, {
			blackLayer = true
		}, arg_6_0.activityId)
	else
		gGameUI:showTip(gLanguageCsv.gameTimesLimit)
	end
end

function var_0_1.onRewardClick(arg_7_0)
	gGameUI:stackUI("city.activity.snow_ball.reward", nil, {
		blackLayer = true
	}, arg_7_0.activityId)
end

function var_0_1.onRankClick(arg_8_0)
	gGameApp:requestServer("/game/rank", function(arg_9_0)
		gGameUI:stackUI("city.activity.snow_ball.rank", nil, nil, arg_9_0.view, arg_8_0.roleData)
	end, "snowball", 0, 50)
end

function var_0_1.onAddClick(arg_10_0)
	if arg_10_0.canBuy == false then
		gGameUI:showTip(gLanguageCsv.buyTimesLimit)

		return
	end

	local var_10_0 = gLanguageCsv.buyGameTimes

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		cb = function()
			if arg_10_0.cost > gGameModel.role:read("rmb") then
				uiEasy.showDialog("rmb")
			else
				gGameApp:requestServer("/game/yy/snowball/buy", function(arg_12_0)
					gGameUI:showTip(gLanguageCsv.buySuccess)
				end, arg_10_0.activityId)
			end
		end,
		title = gLanguageCsv.spaceTips,
		content = string.format(var_10_0, arg_10_0.cost),
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.onRuleClick(arg_13_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_13_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_14_0, arg_14_1)
	local var_14_0 = adaptContext

	return {
		var_14_0.clone(arg_14_1.title, function(arg_15_0)
			arg_15_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_14_0.noteText(110001, 110100)
	}
end

return var_0_1
