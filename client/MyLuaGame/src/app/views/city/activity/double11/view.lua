local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("Double11View", var_0_0)
local var_0_2 = {
	OPENED = 2,
	GOTTEN_AWARD = -1,
	CAN_OPEN = 1
}

var_0_1.RESOURCE_FILENAME = "double_11.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.item"] = "leftItem",
	topPanel = "topPanel",
	["rightPanel.openPanel"] = "rightPanelOpen",
	["rightPanel.overPanel"] = "rightPanelOver",
	leftPanel = "leftPanel",
	["leftPanel.textState"] = {
		varname = "textState",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = cc.c3b(249, 115, 54)
					}
				}
			},
			{
				event = "visible",
				idler = bindHelper.self("status"),
				method = function(arg_1_0)
					return arg_1_0 == var_0_2.GOTTEN_AWARD
				end
			}
		}
	},
	["topPanel.time"] = {
		varname = "textCountDown",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(249, 115, 54)
				}
			}
		}
	},
	["topPanel.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(249, 115, 54)
				}
			}
		}
	},
	["leftPanel.textRecord"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c3b(249, 115, 54)
				}
			}
		}
	},
	["rightPanel.openPanel.textPlayed"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c3b(238, 78, 50)
				}
			}
		}
	},
	["leftPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["leftPanel.btnTicket"] = {
		varname = "btnTicket",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onTicketClick")
				}
			}
		}
	},
	["leftPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 10,
				data = bindHelper.self("record"),
				item = bindHelper.self("leftItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = ""

					if arg_2_3.id then
						local var_2_1 = dataEasy.getCfgByKey(arg_2_3.id).name

						var_2_0 = string.format(gLanguageCsv.double11AwardText, arg_2_3.index, var_2_1, arg_2_3.num)
					else
						var_2_0 = string.format(gLanguageCsv.double11NotGame, arg_2_3.index)
					end

					local var_2_2 = rich.createByStr(var_2_0, 40):addTo(arg_2_1, 10):xy(2, arg_2_1:height() / 2):anchorPoint(cc.p(0, 0.5)):formatText()
				end,
				dataOrderCmp = function(arg_3_0, arg_3_1)
					return arg_3_0.index > arg_3_1.index
				end
			}
		}
	},
	["rightPanel.openPanel.btnGame"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayGameClick")
			}
		}
	}
}

local function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = {
		{
			rotation = 7,
			t1 = 0.1,
			t2 = 0.1
		},
		{
			rotation = -7,
			t1 = 0.1,
			t2 = 0.1
		},
		{
			rotation = 7,
			t1 = 0.1,
			t2 = 0.1
		},
		{
			rotation = -7,
			t1 = 0.1,
			t2 = 0.1
		}
	}

	arg_4_3 = arg_4_3 or arg_4_1:getName() .. "toRotationScheduleTag"

	if arg_4_2 then
		arg_4_0:enableSchedule():schedule(function(arg_5_0)
			if tolua.isnull(arg_4_1) then
				arg_4_0:enableSchedule():unSchedule(arg_4_3)

				return
			end

			local var_5_0 = transition.executeSequence(arg_4_1)

			for iter_5_0, iter_5_1 in pairs(var_4_0) do
				var_5_0:rotateTo(iter_5_1.t1, iter_5_1.rotation)
			end

			var_5_0:rotateTo(0.1, 0):done()
		end, 1, nil, arg_4_3)
	else
		arg_4_0:enableSchedule():unSchedule(arg_4_3)
	end
end

function var_0_1.onCreate(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.activityId = arg_6_1

	gGameUI.topuiManager:createView("title", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		title = gLanguageCsv.double11,
		subTitle = gLanguageCsv.double11Subtitle
	})
	arg_6_0:initGameCfg()
	arg_6_0:initModel()
	arg_6_0:initGameStatus()
	arg_6_0:initData()
	arg_6_0:initCountDown()

	arg_6_0.lotteryInfo = arg_6_2.view.lotteryInfo
end

function var_0_1.initGameCfg(arg_7_0)
	arg_7_0.gameCfg = {}

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.yunying.double11_game) do
		if iter_7_1.huodongID == csv.yunying.yyhuodong[arg_7_0.activityId].huodongID then
			arg_7_0.gameCfg[iter_7_1.game] = {
				itemId = iter_7_1.itemID,
				csvId = iter_7_0
			}
		end
	end
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_8_0.played = idler.new(false)
	arg_8_0.status = idler.new()
	arg_8_0.nowGameIndex = idler.new(0)
	arg_8_0.showIndex = idler.new(1)
	arg_8_0.gameOver = idler.new(false)
	arg_8_0.record = idlers.new()
end

function var_0_1.initData(arg_9_0)
	idlereasy.any({
		arg_9_0.yyhuodongs,
		arg_9_0.nowGameIndex
	}, function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = (arg_10_1[arg_9_0.activityId] or {}).double11 or {}
		local var_10_1 = {}

		for iter_10_0 = 1, #arg_9_0.gameCfg do
			local var_10_2 = arg_9_0.gameCfg[iter_10_0].csvId

			if iter_10_0 <= arg_10_2 then
				if var_10_0[var_10_2] then
					var_10_1[iter_10_0] = {
						index = iter_10_0,
						id = arg_9_0.gameCfg[iter_10_0].itemId,
						num = var_10_0[var_10_2].red_packet_num
					}
				else
					var_10_1[iter_10_0] = {
						index = iter_10_0
					}
				end
			end
		end

		arg_9_0.record:update(var_10_1)

		local var_10_3 = arg_10_2

		if arg_10_2 > #arg_9_0.gameCfg then
			var_10_3 = #arg_9_0.gameCfg
		end

		local var_10_4 = arg_9_0.gameCfg[var_10_3].csvId

		if var_10_0[var_10_4] then
			arg_9_0.played:set(true)
			arg_9_0.status:set(arg_9_0.gameCfg[var_10_3].card_status)
		else
			arg_9_0.played:set(false)
		end

		var_0_3(arg_9_0, arg_9_0.btnTicket, var_10_0[var_10_4] and var_10_0[var_10_4].card_status == var_0_2.CAN_OPEN, "double11CardStatus")
	end)

	local var_9_0 = csv.yunying.yyhuodong[arg_9_0.activityId].paramMap.gameTime

	idlereasy.any({
		arg_9_0.nowGameIndex,
		arg_9_0.gameOver,
		arg_9_0.showIndex,
		arg_9_0.played
	}, function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		if arg_11_2 or arg_11_1 > #arg_9_0.gameCfg then
			arg_9_0.rightPanelOpen:hide()
			arg_9_0.rightPanelOver:show()

			return false
		else
			arg_9_0.rightPanelOpen:show()
			arg_9_0.rightPanelOver:hide()

			local var_11_0 = arg_9_0.oneDayCount
			local var_11_1 = math.ceil(arg_11_3 / var_11_0)
			local var_11_2 = arg_11_3 % var_11_0 == 0 and var_11_0 or arg_11_3 % var_11_0
			local var_11_3, var_11_4 = time.getHourAndMin(var_9_0[var_11_2][1])
			local var_11_5, var_11_6 = time.getHourAndMin(var_9_0[var_11_2][2])
			local var_11_7 = string.format("%02d:%02d--%02d:%02d", var_11_3, var_11_4, var_11_5, var_11_6)

			arg_9_0.rightPanelOpen:get("textTipTime"):text(string.format(gLanguageCsv.double11Time, arg_11_3) .. var_11_7)
			arg_9_0.rightPanelOpen:get("imgAward"):texture(dataEasy.getCfgByKey(arg_9_0.gameCfg[arg_11_3].itemId).icon)
			bind.click(arg_9_0, arg_9_0.rightPanelOpen:get("imgAward"), {
				method = function()
					local var_12_0 = {
						key = arg_9_0.gameCfg[arg_11_3].itemId
					}

					gGameUI:showItemDetail(arg_9_0.rightPanelOpen:get("imgAward"), var_12_0)
				end
			})

			if arg_11_4 == true and arg_11_3 == arg_11_1 then
				arg_9_0.rightPanelOpen:get("btnGame"):hide()
				arg_9_0.rightPanelOpen:get("textPlayed"):show()
			else
				arg_9_0.rightPanelOpen:get("btnGame"):show()
				arg_9_0.rightPanelOpen:get("textPlayed"):hide()
			end
		end
	end)
end

function var_0_1.initGameStatus(arg_13_0)
	local var_13_0 = csv.yunying.yyhuodong[arg_13_0.activityId]
	local var_13_1 = var_13_0.paramMap.gameTime

	arg_13_0.canPlay = idler.new(false)

	local var_13_2 = time.getNumTimestamp(var_13_0.beginDate, 0, 0)
	local var_13_3 = {}
	local var_13_4 = 0

	for iter_13_0, iter_13_1 in orderCsvPairs(var_13_1) do
		local var_13_5, var_13_6 = time.getHourAndMin(iter_13_1[1], true)
		local var_13_7, var_13_8 = time.getHourAndMin(iter_13_1[2], true)

		var_13_3[iter_13_0] = {
			var_13_5 * 3600 + var_13_6 * 60,
			var_13_7 * 3600 + var_13_8 * 60
		}
		var_13_4 = var_13_4 + 1
	end

	arg_13_0.oneDayCount = var_13_4

	local var_13_9 = {}

	for iter_13_2 = 1, #arg_13_0.gameCfg do
		local var_13_10 = math.ceil(iter_13_2 / var_13_4)
		local var_13_11 = iter_13_2 % var_13_4 == 0 and var_13_4 or iter_13_2 % var_13_4
		local var_13_12 = var_13_3[var_13_11][1]

		var_13_9[iter_13_2] = {
			beginStamps = var_13_2 + (var_13_10 - 1) * 24 * 3600 + var_13_3[var_13_11][1],
			endStamps = var_13_2 + (var_13_10 - 1) * 24 * 3600 + var_13_3[var_13_11][2]
		}
	end

	local function var_13_13()
		local var_14_0 = var_13_9[#arg_13_0.gameCfg].endStamps
		local var_14_1 = time.getTime()

		if var_14_0 < var_14_1 then
			arg_13_0.nowGameIndex:set(#arg_13_0.gameCfg + 1)
			arg_13_0.gameOver:set(true)
		else
			local var_14_2 = 1
			local var_14_3 = 1

			for iter_14_0, iter_14_1 in ipairs(var_13_9) do
				if var_14_1 >= iter_14_1.beginStamps then
					var_14_2 = iter_14_0
				end

				if var_14_1 >= iter_14_1.endStamps then
					var_14_3 = iter_14_0 + 1
				end
			end

			if var_14_1 >= var_13_9[var_14_2].beginStamps and var_14_1 < var_13_9[var_14_2].endStamps then
				arg_13_0.canPlay:set(true)
			else
				arg_13_0.canPlay:set(false)
			end

			arg_13_0.nowGameIndex:set(var_14_2)
			arg_13_0.showIndex:set(var_14_3)
		end
	end

	var_13_13()
	arg_13_0:enableSchedule():schedule(var_13_13, 1, 0)
end

function var_0_1.onRule(arg_15_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_15_0:createHandler("getRuleContext"), {
		width = 1000
	})
end

function var_0_1.getRuleContext(arg_16_0, arg_16_1)
	local var_16_0 = adaptContext

	return {
		var_16_0.clone(arg_16_1.title, function(arg_17_0)
			arg_17_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_16_0.noteText(152),
		var_16_0.noteText(108001, 108100)
	}
end

function var_0_1.onTicketClick(arg_18_0)
	local var_18_0 = csv.yunying.yyhuodong[arg_18_0.activityId].huodongID

	if arg_18_0.nowGameIndex:read() == 0 then
		gGameUI:showTip(gLanguageCsv.double11GameTips)

		return
	end

	local var_18_1 = arg_18_0.nowGameIndex:read()
	local var_18_2 = var_18_1

	if var_18_1 > #arg_18_0.gameCfg then
		var_18_2 = #arg_18_0.gameCfg
	end

	local var_18_3 = arg_18_0.gameCfg[var_18_2].csvId
	local var_18_4 = arg_18_0.lotteryInfo[var_18_3]

	gGameUI:stackUI("city.activity.double11.lottery", nil, nil, var_18_0, arg_18_0.nowGameIndex:read(), arg_18_0.activityId, var_18_4, var_18_3)
end

function var_0_1.onPlayGameClick(arg_19_0)
	if arg_19_0.canPlay:read() == false then
		gGameUI:showTip(gLanguageCsv.double11GameTips)

		return false
	end

	gGameUI:stackUI("city.activity.double11.game", nil, nil, arg_19_0.activityId, arg_19_0.nowGameIndex:read())
end

function var_0_1.initCountDown(arg_20_0)
	local var_20_0 = arg_20_0.textCountDown
	local var_20_1 = csv.yunying.yyhuodong[arg_20_0.activityId]
	local var_20_2, var_20_3 = time.getHourAndMin(var_20_1.endTime)
	local var_20_4 = time.getNumTimestamp(var_20_1.endDate, var_20_2, var_20_3)

	bind.extend(arg_20_0, var_20_0, {
		class = "cutdown_label",
		props = {
			endTime = var_20_4,
			strFunc = function(arg_21_0)
				return arg_21_0.str
			end,
			endFunc = function()
				var_20_0:text(gLanguageCsv.activityOver)
			end
		}
	})
end

return var_0_1
