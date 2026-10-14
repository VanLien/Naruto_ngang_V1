local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("HorseRaceView", var_0_0)

var_0_1.RESOURCE_FILENAME = "horse_race_main.json"
var_0_1.RESOURCE_BINDING = {
	["bg1.textTip1"] = "textTip1",
	["rightPanel.btnBet.bet"] = "bet",
	bg2 = "bg2",
	["bg2.time"] = "time",
	podium = "podium",
	["bg2.textTip2"] = "textTip2",
	["leftPanel.btnHistory.history"] = "history",
	["replay.text"] = "replayText",
	["leftPanel.btnRank.rank"] = "rank",
	["rightPanel.textTips"] = "textTips",
	ruleRankItem = "ruleRankItem",
	["leftPanel.btnRule.rule"] = "rule",
	player = "player",
	["bg2.minute"] = "minute",
	bg1 = "bg1",
	ruleRankTitle = "ruleRankTitle",
	["rightPanel.btnPoint.point"] = "point",
	["leftPanel.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRank")
			}
		}
	},
	["leftPanel.btnHistory"] = {
		varname = "btnRank",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onShowRaceRecord")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "horseRaceBetAward",
					listenData = {
						activityId = bindHelper.self("activityId")
					},
					onNode = function(arg_1_0)
						arg_1_0:xy(120, 120)
					end
				}
			}
		}
	},
	["leftPanel.btnRule"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["rightPanel.btnBet"] = {
		varname = "btnRank",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onBetClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "horseRaceCanBet",
					listenData = {
						activityId = bindHelper.self("activityId")
					},
					onNode = function(arg_2_0)
						arg_2_0:xy(120, 120)
					end
				}
			}
		}
	},
	["rightPanel.btnPoint"] = {
		varname = "btnRank",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onPointReward")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "horseRaceAward",
					listenData = {
						activityId = bindHelper.self("activityId")
					},
					onNode = function(arg_3_0)
						arg_3_0:xy(120, 120)
					end
				}
			}
		}
	},
	listPlayer = {
		varname = "btnRank",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("itemData"),
				item = bindHelper.self("player"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = csv.cross.horse_race.horse_race_card[arg_4_3.val.csv_id]
					local var_4_1 = arg_4_1:get("bg")
					local var_4_2 = arg_4_1:get("bet"):visible(arg_4_3.idx)
					local var_4_3 = var_4_1:get("textName")
					local var_4_4 = var_4_1:get("number")
					local var_4_5 = {
						75,
						100,
						50,
						50
					}
					local var_4_6 = {
						0,
						0,
						50,
						50
					}
					local var_4_7 = arg_4_1:get("per")

					if arg_4_3.status == 1 or arg_4_3.status == 4 then
						var_4_7:xy(var_4_7:x() - var_4_6[arg_4_2], var_4_7:y() + var_4_5[arg_4_2])
						var_4_1:setVisible(false)
					else
						var_4_1:setVisible(true)
					end

					text.addEffect(var_4_3, {
						outline = {
							size = 5,
							color = ui.COLORS.OUTLINE.DEFAULT
						}
					})
					var_4_3:text(var_4_0.name)

					local var_4_8 = rich.createByStr(string.format(gLanguageCsv.horseRacePerson, arg_4_3.val.bet_count), 40):anchorPoint(cc.p(0.5, 0.5)):xy(cc.p(var_4_1:size().width / 2, 35)):addTo(var_4_1, 2)

					widget.addAnimation(arg_4_1:get("per"), csv.unit[var_4_0.unitID].unitRes, "standby_loop", 5):alignCenter(cc.size(arg_4_1:get("per"):size().width, arg_4_1:get("per"):size().height - 300)):anchorPoint(cc.p(0.5, 0.5)):setScale(2):setSkin(csv.unit[var_4_0.unitID].skin)
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.onBetClick, arg_4_2, arg_4_1)
						}
					})
				end
			},
			handlers = {
				onBetClick = bindHelper.self("onBetClick")
			}
		}
	},
	replay = {
		varname = "replay",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReplay")
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.activityId = arg_5_1
	arg_5_0.data = idlertable.new(arg_5_2)

	gGameUI.topuiManager:createView("default", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose")
	}):init({
		subTitle = "HORSE RACE",
		title = gLanguageCsv.horseRace
	})
	arg_5_0:initModel()
	arg_5_0:setInfo()
	arg_5_0:enableSchedule()

	local var_5_0 = {}

	arg_5_0.request = 0
	arg_5_0.itemData = idlertable.new(var_5_0)
	arg_5_0.play = idler.new(1)
	arg_5_0.status = idler.new(1)
	arg_5_0.index = 0

	arg_5_0:gameStatus()
	idlereasy.any({
		arg_5_0.play,
		arg_5_0.yyhuodongs,
		arg_5_0.status,
		arg_5_0.data
	}, function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = arg_6_2[arg_5_1]
		local var_6_1 = {}
		local var_6_2 = arg_6_4.view.play
		local var_6_3 = {
			2,
			1,
			3,
			4
		}

		if not arg_6_4.view or not arg_6_4.view.race_cards or itertools.size(arg_6_4.view.race_cards) <= 0 then
			arg_5_0.textTip2:text(gLanguageCsv.horseRaceNoMatch)
			arg_5_0.podium:visible(false)
			arg_5_0.time:visible(false)
			arg_5_0.minute:visible(false)
			adapt.oneLineCenterPos(cc.p((lens + 450) / 2, 78), {
				arg_5_0.textTip2,
				arg_5_0.time,
				arg_5_0.minute
			}, cc.p(10, 0))
		else
			for iter_6_0, iter_6_1 in pairs(arg_6_4.view.race_cards) do
				local var_6_4 = tonumber(time.getTodayStr())
				local var_6_5 = {}

				if var_6_0 and var_6_0.horse_race and var_6_0.horse_race.bet_award then
					var_6_5 = var_6_0.horse_race.bet_award
				end

				local var_6_6 = iter_6_0

				if arg_6_3 == 4 or arg_6_3 == 1 then
					var_6_6 = var_6_3[iter_6_1.result ~= 0 and iter_6_1.result or iter_6_0]
				end

				if var_6_5[var_6_4] and var_6_5[var_6_4][var_6_2] then
					arg_5_0.index = var_6_5[var_6_4][var_6_2][1] + 1
					var_6_1[var_6_6] = {
						val = iter_6_1,
						idx = var_6_5[var_6_4][var_6_2][1] + 1 == iter_6_0,
						status = arg_6_3
					}
				else
					var_6_1[var_6_6] = {
						idx = false,
						val = iter_6_1,
						status = arg_6_3
					}
				end
			end

			if arg_6_3 == 1 or arg_6_3 == 4 then
				arg_5_0.podium:setVisible(true)
			else
				arg_5_0.podium:setVisible(false)
			end

			arg_6_1 = var_6_2

			arg_5_0:timeCutdown(var_6_2, arg_5_0.timeData[arg_6_3], arg_6_3)
			arg_5_0.itemData:set(var_6_1)

			local var_6_7 = arg_5_0.textTip2:size().width + arg_5_0.time:size().width + arg_5_0.minute:size().width

			if arg_6_3 == 4 or arg_6_3 == 1 then
				arg_5_0.replay:setVisible(true)
			else
				arg_5_0.replay:setVisible(false)
			end

			arg_5_0.bg2:size(var_6_7 + 450, arg_5_0.bg2:size().height)
			arg_5_0.textTip2:x(var_6_7 / 2 + 100)
			adapt.oneLineCenterPos(cc.p((var_6_7 + 450) / 2, 78), {
				arg_5_0.textTip2,
				arg_5_0.time,
				arg_5_0.minute
			}, cc.p(10, 0))

			if arg_6_4.view.round == "closed" then
				arg_5_0:inMatch(arg_6_4)
			end
		end
	end)
	arg_5_0:timeClock()
	arg_5_0.bg1:scaleY(0.1)
	transition.executeSequence(arg_5_0.bg1):easeBegin("ELASTICOUT"):scaleTo(2, 1, 1):easeEnd():done()
end

function var_0_1.timeClock(arg_7_0)
	local var_7_0 = 0

	arg_7_0.errorTime = nil

	arg_7_0:unSchedule("clock")
	arg_7_0:schedule(function()
		if not arg_7_0.data:read().view or not arg_7_0.data:read().view.race_cards then
			return
		end

		local var_8_0 = arg_7_0.status:read()
		local var_8_1 = arg_7_0.data:read().view.play or 1
		local var_8_2 = arg_7_0.data:read().view.round

		if var_8_0 == 4 and var_8_2 ~= "closed" or var_8_0 == 1 and var_8_2 ~= "closed" or var_8_0 == 2 and var_8_2 ~= "prepare" or var_8_0 == 5 and var_8_2 ~= "prepare" then
			if arg_7_0.date[var_8_1 * 2] - time.getTime() < 0 and (var_8_0 == 3 or var_8_0 == 1) and time.getTime() - var_7_0 > 10 then
				arg_7_0.errorTime = 10
				var_7_0 = time.getTime()

				if arg_7_0.request ~= 1 and arg_7_0:isActivityOpen() then
					arg_7_0.request = 1

					gGameApp:requestServer("/game/yy/horse/race/main", function(arg_9_0)
						if arg_9_0.view.round == "closed" then
							arg_7_0.data:set(arg_9_0)
						end

						arg_7_0.request = 0
					end, arg_7_0.activityId)
				end
			end
		else
			arg_7_0.errorTime = nil

			return
		end
	end, 1, 0, "clock")
end

function var_0_1.onBetClick(arg_10_0)
	gGameUI:stackUI("city.activity.horse_race.bet", nil, nil, arg_10_0.activityId, arg_10_0:createHandler("returnDate"))
end

function var_0_1.returnDate(arg_11_0)
	local function var_11_0()
		if arg_11_0:isActivityOpen() then
			gGameApp:requestServer("/game/yy/horse/race/main", function(arg_13_0)
				arg_11_0.data:set(arg_13_0)
			end, arg_11_0.activityId)
		end
	end

	return arg_11_0.data, arg_11_0.status, var_11_0
end

function var_0_1.setInfo(arg_14_0)
	local var_14_0 = gGameModel.role:read("yy_endtime")[arg_14_0.activityId]
	local var_14_1 = csv.cross.horse_race.base[1].time
	local var_14_2 = csv.yunying.yyhuodong[arg_14_0.activityId]
	local var_14_3 = time.getDate(math.floor(var_14_0))

	var_14_3.hour = var_14_2.endTime / 100
	var_14_3.min = var_14_2.endTime % 100

	arg_14_0.textTip1:text(string.format(gLanguageCsv.horseRaceActive, var_14_1[2], var_14_1[4]))
	text.addEffect(arg_14_0.rank, {
		outline = {
			size = 3,
			color = cc.c4b(109, 105, 109, 255)
		}
	})
	text.addEffect(arg_14_0.bet, {
		outline = {
			size = 3,
			color = cc.c4b(109, 105, 109, 255)
		}
	})
	text.addEffect(arg_14_0.point, {
		outline = {
			size = 3,
			color = cc.c4b(109, 105, 109, 255)
		}
	})
	text.addEffect(arg_14_0.history, {
		outline = {
			size = 3,
			color = cc.c4b(109, 105, 109, 255)
		}
	})
	text.addEffect(arg_14_0.rule, {
		outline = {
			size = 3,
			color = cc.c4b(109, 105, 109, 255)
		}
	})
	text.addEffect(arg_14_0.replayText, {
		outline = {
			size = 3,
			color = cc.c4b(218, 112, 21, 255)
		}
	})
	text.addEffect(arg_14_0.textTips, {
		color = ui.COLORS.WHITE,
		outline = {
			size = 5,
			color = ui.COLORS.BLACK
		}
	})

	local var_14_4 = math.floor(var_14_0) - time.getTime()

	bind.extend(arg_14_0, arg_14_0.textTips, {
		class = "cutdown_label",
		props = {
			time = var_14_4,
			strFunc = function(arg_15_0)
				return string.format(gLanguageCsv.horseRaceEndTime, arg_15_0.str)
			end,
			endFunc = function()
				arg_14_0.textTips:text(gLanguageCsv.activityOver)
			end
		}
	})
end

function var_0_1.gameStatus(arg_17_0)
	local var_17_0 = csv.cross.horse_race.base[1].time
	local var_17_1 = tonumber(time.getTodayStr())

	arg_17_0.date = {
		time.getNumTimestamp(var_17_1, var_17_0[1]),
		time.getNumTimestamp(var_17_1, var_17_0[2]),
		time.getNumTimestamp(var_17_1, var_17_0[3]),
		time.getNumTimestamp(var_17_1, var_17_0[4])
	}

	local var_17_2 = 180
	local var_17_3 = {
		{
			arg_17_0.date[4],
			arg_17_0.date[1] + 86400
		},
		{
			arg_17_0.date[1],
			arg_17_0.date[2] - var_17_2
		},
		{
			arg_17_0.date[2] - var_17_2,
			arg_17_0.date[2]
		},
		{
			arg_17_0.date[2],
			arg_17_0.date[3]
		},
		{
			arg_17_0.date[3],
			arg_17_0.date[4] - var_17_2
		},
		{
			arg_17_0.date[4] - var_17_2,
			arg_17_0.date[4]
		}
	}

	for iter_17_0, iter_17_1 in pairs(var_17_3) do
		if iter_17_1[1] <= time.getTime() and iter_17_1[2] > time.getTime() then
			arg_17_0.status:set(iter_17_0)
		end
	end
end

function var_0_1.onShowRule(arg_18_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_18_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.onReplay(arg_19_0)
	gGameUI:stackUI("city.activity.horse_race.match", nil, nil, arg_19_0.activityId, {
		arg_19_0.data:read().view.race_cards,
		arg_19_0.index
	})
end

function var_0_1.getRuleContext(arg_20_0, arg_20_1)
	local var_20_0 = adaptContext
	local var_20_1 = {
		var_20_0.clone(arg_20_1.title, function(arg_21_0)
			arg_21_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_20_0.noteText(121001, 121101),
		var_20_0.clone(arg_20_0.ruleRankTitle)
	}
	local var_20_2 = csv.yunying.yyhuodong[arg_20_0.activityId].huodongID

	for iter_20_0, iter_20_1 in orderCsvPairs(csv.yunying.horse_race_bet_award) do
		if iter_20_1.huodongID == var_20_2 then
			table.insert(var_20_1, var_20_0.clone(arg_20_0.ruleRankItem, function(arg_22_0)
				local var_22_0 = arg_22_0:multiget("textRuleRank", "textRuleScore", "list", "rank")
				local var_22_1 = var_22_0.rank:get("rank" .. iter_20_1.rank)

				if var_22_1 then
					var_22_1:visible(true)
					var_22_0.textRuleRank:visible(false)
				else
					var_22_0.textRuleRank:text(iter_20_1.rank)
				end

				var_22_0.textRuleScore:text(iter_20_1.point)
				uiEasy.createItemsToList(arg_20_1, var_22_0.list, iter_20_1.award)
			end))
		end
	end

	return var_20_1
end

function var_0_1.onShowRaceRecord(arg_23_0)
	gGameUI:stackUI("city.activity.horse_race.race_record", nil, nil, arg_23_0.activityId, arg_23_0:createHandler("returnData"))
end

function var_0_1.initModel(arg_24_0)
	arg_24_0.yyOpen = gGameModel.role:getIdler("yy_open")
	arg_24_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_24_0.yyEndtime = gGameModel.role:read("yy_endtime")[arg_24_0.activityId]

	local var_24_0 = tonumber(time.getTodayStr())
	local var_24_1 = csv.cross.horse_race.base[1].time
	local var_24_2 = 180

	local function var_24_3(arg_25_0)
		if arg_24_0.request ~= 1 and arg_24_0:isActivityOpen() then
			arg_24_0.request = 1

			performWithDelay(arg_24_0, function()
				gGameApp:requestServer("/game/yy/horse/race/main", function(arg_27_0)
					arg_24_0.data:set(arg_27_0)

					if arg_25_0 then
						arg_25_0()
					end

					arg_24_0.request = 0
				end, arg_24_0.activityId)
			end, 1)
		end
	end

	arg_24_0.timeData = {
		{
			time = time.getNumTimestamp(var_24_0, var_24_1[1]) + 86400,
			string = gLanguageCsv.horseRaceNextOpenTip,
			cb = var_24_3
		},
		{
			time = time.getNumTimestamp(var_24_0, var_24_1[2]) - var_24_2,
			string = gLanguageCsv.horseRaceTip
		},
		{
			time = time.getNumTimestamp(var_24_0, var_24_1[2]),
			string = gLanguageCsv.horseRaceStartTip,
			str = gLanguageCsv.horseRaceBetClose,
			cb = var_24_3
		},
		{
			time = time.getNumTimestamp(var_24_0, var_24_1[3]),
			string = gLanguageCsv.horseRaceOpenTip,
			cb = var_24_3
		},
		{
			time = time.getNumTimestamp(var_24_0, var_24_1[4]) - var_24_2,
			string = gLanguageCsv.horseRaceTip
		},
		{
			time = time.getNumTimestamp(var_24_0, var_24_1[4]),
			string = gLanguageCsv.horseRaceStartTip,
			str = gLanguageCsv.horseRaceBetClose,
			cb = var_24_3
		}
	}
end

function var_0_1.timeCutdown(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = csv.cross.horse_race.base[1].time
	local var_28_1 = math.floor(arg_28_2.time - time.getTime())

	if arg_28_3 == 1 then
		local var_28_2 = time.getDate(math.floor(arg_28_0.yyEndtime - 86400))
		local var_28_3 = {
			min = 0,
			sec = 0,
			year = var_28_2.year,
			month = var_28_2.month,
			day = var_28_2.day,
			hour = var_28_0[4] or 0
		}
		local var_28_4 = time.getTimestamp(var_28_3)

		if arg_28_2.time - time.getTime() >= 33000 then
			var_28_1 = math.floor(arg_28_2.time - 86400 - time.getTime())
		end

		if var_28_4 < time.getTime() then
			arg_28_0.textTip2:text(gLanguageCsv.horseRaceOver)
		else
			arg_28_0.textTip2:text(string.format(arg_28_2.string, var_28_0[1]))
		end

		arg_28_0.time:text("")
		arg_28_0.time:setVisible(false)
		arg_28_0.minute:text("")
		arg_28_0.minute:setVisible(false)
	elseif arg_28_3 == 4 then
		arg_28_0.textTip2:text(string.format(arg_28_2.string, var_28_0[3]))
		arg_28_0.time:text("")
		arg_28_0.time:setVisible(false)
		arg_28_0.minute:text("")
		arg_28_0.minute:setVisible(false)
	else
		if arg_28_2.str then
			arg_28_0.minute:text(string.format(arg_28_2.str, arg_28_1))
			arg_28_0.minute:setVisible(true)
		else
			arg_28_0.minute:text("")
			arg_28_0.minute:setVisible(true)
		end

		arg_28_0.textTip2:text(string.format(arg_28_2.string, arg_28_1))
		arg_28_0.time:text("")
		arg_28_0.time:setVisible(true)
	end

	if arg_28_0.errorTime then
		var_28_1 = arg_28_0.errorTime
	end

	arg_28_0:unSchedule("cutdown")
	arg_28_0.time:text(time.getCutDown(var_28_1).str)
	arg_28_0:schedule(function()
		var_28_1 = var_28_1 - 1

		if var_28_1 < 0 then
			if not arg_28_0.errorTime then
				if arg_28_2.cb then
					local function var_29_0()
						local var_30_0 = arg_28_0.status:read() % 6

						arg_28_0.status:set(var_30_0 + 1)

						if var_30_0 + 1 == 5 or var_30_0 + 1 == 2 then
							arg_28_0.play:set(arg_28_0.data:read().view.play)
						end
					end

					arg_28_2.cb(var_29_0)
				else
					local var_29_1 = arg_28_0.status:read() % 6

					arg_28_0.status:set(var_29_1 + 1)

					if var_29_1 + 1 == 5 or var_29_1 + 1 == 2 then
						arg_28_0.play:set(arg_28_0.data:read().view.play)
					end
				end
			end

			var_28_1 = math.max(var_28_1, 0)
		end

		arg_28_0.time:text(time.getCutDown(var_28_1).str)
	end, 1, 0, "cutdown")
end

function var_0_1.onRank(arg_31_0)
	gGameApp:requestServer("/game/yy/horse/race/rank", function(arg_32_0)
		gGameUI:stackUI("city.activity.horse_race.rank", nil, nil, arg_31_0.activityId, arg_32_0.view)
	end, arg_31_0.activityId)
end

function var_0_1.inMatch(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1.view.date
	local var_33_1 = arg_33_1.view.play
	local var_33_2 = userDefault.getForeverLocalKey("horseRaceData", {})
	local var_33_3 = tonumber(time.getTodayStr())
	local var_33_4 = csv.cross.horse_race.base[1].time
	local var_33_5 = {
		{
			time.getNumTimestamp(var_33_3, var_33_4[2]),
			time.getNumTimestamp(var_33_3, var_33_4[2]) + 1800
		},
		{
			time.getNumTimestamp(var_33_3, var_33_4[4]),
			time.getNumTimestamp(var_33_3, var_33_4[4]) + 1800
		}
	}

	for iter_33_0, iter_33_1 in pairs(var_33_5) do
		if iter_33_1[1] <= time.getTime() and iter_33_1[2] > time.getTime() and (arg_33_0.status:read() == 4 or arg_33_0.status:read() == 1) and (not var_33_2[var_33_0] or not var_33_2[var_33_0][var_33_1]) then
			if not var_33_2[var_33_0] then
				var_33_2[var_33_0] = {}
				var_33_2[var_33_0][var_33_1] = 1

				userDefault.setForeverLocalKey("horseRaceData", var_33_2)
			else
				var_33_2[var_33_0][var_33_1] = 1

				userDefault.setForeverLocalKey("horseRaceData", var_33_2)
			end

			gGameUI:goBackInStackUI("city.activity.horse_race.view")
			gGameUI:stackUI("city.activity.horse_race.match", nil, nil, arg_33_0.activityId, {
				arg_33_0.data:read().view.race_cards,
				arg_33_0.index,
				true
			})
		end
	end
end

function var_0_1.onPointReward(arg_34_0)
	gGameUI:stackUI("city.activity.horse_race.point_reward", nil, nil, arg_34_0.activityId)
end

function var_0_1.returnData(arg_35_0)
	return arg_35_0.data, arg_35_0.status
end

function var_0_1.isActivityOpen(arg_36_0)
	for iter_36_0, iter_36_1 in pairs(arg_36_0.yyOpen:read()) do
		if iter_36_1 == arg_36_0.activityId then
			return true
		end
	end

	return false
end

return var_0_1
