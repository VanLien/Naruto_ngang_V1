local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SkyScraperView", var_0_0)
local var_0_2 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = cc.c4b(255, 252, 237, 255)
		}
	}
}

local function var_0_3(arg_1_0, arg_1_1)
	arg_1_0:setTouchEnabled(arg_1_1)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("textNote"), {
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("textNote"))
		text.addEffect(arg_1_0:get("textNote"), {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

var_0_1.RESOURCE_FILENAME = "sky_scraper_view.json"
var_0_1.RESOURCE_BINDING = {
	centerPanel = "centerPanel",
	bg = "bg",
	["centerPanel.tipTime"] = "tipTime",
	["centerPanel.textTipTime"] = "textTipTime",
	icon = "icon",
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
	["centerPanel.timeText"] = {
		varname = "timeText",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["centerPanel.time"] = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["leftDownPanel.taskPanel.txt"] = {
		binds = var_0_2
	},
	["leftDownPanel.rankPanel.txt"] = {
		binds = var_0_2
	},
	["leftDownPanel.rulePanel.txt"] = {
		binds = var_0_2
	},
	["leftDownPanel.taskPanel"] = {
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
					specialTag = "skyScraperTask",
					listenData = {
						activityId = bindHelper.self("activityId")
					}
				}
			}
		}
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
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.activityId = arg_2_1

	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "SKY SCRAPER",
		title = gLanguageCsv.skyScraper
	})
	arg_2_0:initModel()
	arg_2_0:updateTime()
end

function var_0_1.initModel(arg_3_0)
	arg_3_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_3_0.cost = 0

	local var_3_0 = csv.yunying.yyhuodong[arg_3_0.activityId]
	local var_3_1 = var_3_0.paramMap or {}

	arg_3_0.huodongId = var_3_0.huodongID
	arg_3_0.maxTimes = var_3_1.times or 0
	arg_3_0.buyCost = var_3_1.buyCost or {}
	arg_3_0.canBuy = false
	arg_3_0.buyTimes = var_3_1.buyTimes or 0

	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_3_0.activityId] or {}).info or {}
		local var_4_1 = var_4_0.task_points or 0
		local var_4_2 = csv.yunying.skyscraper_medals
		local var_4_3 = 0
		local var_4_4 = 0
		local var_4_5 = false
		local var_4_6 = 1

		for iter_4_0, iter_4_1 in orderCsvPairs(var_4_2) do
			var_4_6 = iter_4_1.huodongID == arg_3_0.huodongId and iter_4_1.medalLevel > var_4_2[var_4_6].medalLevel and iter_4_0 or var_4_6
		end

		for iter_4_2, iter_4_3 in orderCsvPairs(var_4_2) do
			if iter_4_3.huodongID == arg_3_0.huodongId then
				var_4_5 = true
				var_4_4 = var_4_4 + iter_4_3.points

				if var_4_1 < var_4_4 then
					var_4_3 = iter_4_2

					break
				end
			end
		end

		if not var_4_5 then
			var_4_3 = 1
		elseif var_4_3 == 0 then
			var_4_3 = var_4_6
		end

		arg_3_0.icon:texture(var_4_2[var_4_3].resource)
		arg_3_0.icon:get("imgRank"):texture(var_4_2[var_4_3].resourceNum)
		arg_3_0.icon:get("textRank"):text(gLanguageCsv[var_4_2[var_4_3].medalsName])
		arg_3_0.icon:get("textRank"):setTextColor(cc.c3b(unpack(var_4_2[var_4_3].color)))

		arg_3_0.times = arg_3_0.maxTimes + var_4_0.buy_times - var_4_0.times or 0

		arg_3_0.tipTime:text(arg_3_0.times .. "/" .. arg_3_0.maxTimes)

		arg_3_0.cost = var_4_0.buy_times + 1 <= itertools.size(arg_3_0.buyCost) and arg_3_0.buyCost[var_4_0.buy_times + 1] or arg_3_0.buyCost[itertools.size(arg_3_0.buyCost)]
		arg_3_0.canBuy = var_4_0.buy_times < arg_3_0.buyTimes

		arg_3_0.btnAdd:visible(var_4_0.buy_times ~= arg_3_0.buyTimes)
		adapt.oneLineCenterPos(cc.p(arg_3_0.centerPanel:size().width / 2, arg_3_0.textTipTime:y()), {
			arg_3_0.textTipTime,
			arg_3_0.tipTime
		}, cc.p(0, 0))
	end)
end

function var_0_1.onTaskClick(arg_5_0)
	gGameUI:stackUI("city.activity.sky_scraper.reward", nil, nil, arg_5_0.activityId)
end

function var_0_1.onPlayGameClick(arg_6_0)
	if arg_6_0.times == 0 then
		gGameUI:showTip(gLanguageCsv.gameTimesLimit)

		return
	end

	local var_6_0 = gGameModel.role:read("yy_endtime")[arg_6_0.activityId]
	local var_6_1 = 0

	if var_6_0 == nil or math.floor(var_6_0 - time.getTime()) <= 0 then
		gGameUI:showTip(gLanguageCsv.flipCardFinishedClickTip)

		return
	end

	gGameApp:requestServer("/game/yy/skyscraper/start", function(arg_7_0)
		gGameUI:stackUI("city.activity.sky_scraper.game", nil, {
			full = true
		}, arg_6_0.activityId)
	end, arg_6_0.activityId)
end

function var_0_1.onRankClick(arg_8_0)
	gGameApp:requestServer("/game/yy/skyscraper/ranking", function(arg_9_0)
		gGameUI:stackUI("city.activity.sky_scraper.rank", nil, nil, arg_8_0.activityId, arg_9_0.view)
	end, arg_8_0.activityId)
end

function var_0_1.onRuleClick(arg_10_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_10_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_11_0, arg_11_1)
	local var_11_0 = adaptContext

	return {
		var_11_0.clone(arg_11_1.title, function(arg_12_0)
			arg_12_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_11_0.noteText(161),
		var_11_0.noteText(116001, 116020)
	}
end

function var_0_1.onAddClick(arg_13_0)
	local var_13_0 = gGameModel.role:read("yy_endtime")[arg_13_0.activityId]
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
				gGameApp:requestServer("/game/yy/skyscraper/buy", function(arg_15_0)
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

function var_0_1.updateTime(arg_16_0)
	local var_16_0 = gGameModel.role:read("yy_endtime")[arg_16_0.activityId]

	bind.extend(arg_16_0, arg_16_0.time, {
		class = "cutdown_label",
		props = {
			endTime = var_16_0,
			callFunc = function()
				adapt.oneLineCenterPos(cc.p(arg_16_0.centerPanel:size().width / 2, arg_16_0.timeText:y()), {
					arg_16_0.timeText,
					arg_16_0.time
				}, cc.p(0, 0))
			end,
			endFunc = function()
				arg_16_0.time:text(gLanguageCsv.activityOver)
				arg_16_0.time:x(arg_16_0.time:x() - 180)
				arg_16_0.timeText:visible(false)
			end
		}
	})
end

return var_0_1
