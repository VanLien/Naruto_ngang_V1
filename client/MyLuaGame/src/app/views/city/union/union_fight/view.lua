local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.union.tools")
local var_0_2 = class("UnionFightView", var_0_0)

local function var_0_3(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(arg_1_0:getChildren()) do
		iter_1_1:hide()
	end
end

local var_0_4 = {
	signup = "signup",
	battle = "battle",
	over = "over",
	closed = "closed",
	prepare = "prepare"
}
local var_0_5 = {
	function(arg_2_0)
		arg_2_0.btnBM:hide()
		arg_2_0.vipShow:hide()
		arg_2_0.leftUnionPanel:hide()
		arg_2_0:addChildView("city.union.union_fight.closed_view", arg_2_0:createHandler("onRefesh"))
	end,
	function(arg_3_0)
		local var_3_0 = arg_3_0.unionFight.round:read()
		local var_3_1 = arg_3_0.dailyRecord.signUp:read()

		arg_3_0.btnBM:hide()
		arg_3_0.vipShow:hide()
		arg_3_0.leftUnionPanel:show()
		arg_3_0.dialogPanel:hide()
		arg_3_0.childPanel:hide()

		if var_3_0 == var_0_4.signup then
			arg_3_0.imgYxs:show()
			arg_3_0.btnBM:visible(not var_3_1)
			arg_3_0.vipShow:visible(not var_3_1)
			arg_3_0.readyYxs:visible(var_3_1)
			arg_3_0:clearCenterPanel()
		elseif var_3_0 == var_0_4.battle or var_3_0 == var_0_4.prepare then
			arg_3_0.imgYxs:hide()
			arg_3_0.btnBM:hide()
			arg_3_0.vipShow:hide()
			arg_3_0.rightPanel:hide()
			arg_3_0:addChildView("city.union.union_fight.fighting_list.yxs", arg_3_0:createHandler("onRefesh"), arg_3_0._roundResults)

			arg_3_0._roundResults = nil
		elseif var_3_0 == var_0_4.over then
			arg_3_0.imgYxs:hide()
			arg_3_0.leftUnionPanel:hide()
			arg_3_0.rightPanel:hide()
			arg_3_0.battleInfoPanel:hide()
			arg_3_0:addChildView("city.union.union_fight.daily_over")
		elseif var_3_0 == var_0_4.closed then
			arg_3_0.btnBM:hide()
			arg_3_0.vipShow:hide()
			arg_3_0.leftUnionPanel:hide()
			arg_3_0:addChildView("city.union.union_fight.closed_view", arg_3_0:createHandler("onRefesh"))
		end
	end,
	[6] = function(arg_4_0)
		local var_4_0 = arg_4_0.unionFight.round:read()
		local var_4_1 = arg_4_0.dailyRecord.signUp:read()
		local var_4_2 = gGameModel.union_fight:read("top8_vs_info") or {}

		arg_4_0.leftUnionPanel:show()
		arg_4_0.imgYxs:hide()
		arg_4_0.btnBM:visible(not var_4_1 and var_4_0 == var_0_4.signup)
		arg_4_0.vipShow:visible(not var_4_1 and var_4_0 == var_0_4.signup)
		arg_4_0.dialogPanel:hide()
		arg_4_0.childPanel:hide()

		local var_4_3 = itertools.include(var_4_2, function(arg_5_0)
			return arg_5_0[1] == arg_4_0.unionId
		end)

		if var_4_0 == var_0_4.closed then
			arg_4_0.btnBM:hide()
			arg_4_0.leftUnionPanel:hide()
			arg_4_0:addChildView("city.union.union_fight.closed_view", arg_4_0:createHandler("onRefesh"))
		elseif var_4_0 == var_0_4.over then
			arg_4_0.battleInfoPanel:hide()
			arg_4_0.leftUnionPanel:hide()

			local var_4_4 = time.getNowDate()
			local var_4_5 = true
			local var_4_6, var_4_7 = dataEasy.getTimeStrByKey("unionFight", "signUpStart", true)

			if var_4_6 < var_4_4.hour or var_4_4.hour == var_4_6 and var_4_7 <= var_4_4.min then
				var_4_5 = false
			end

			if var_4_5 then
				arg_4_0.imgYxs:hide()
				arg_4_0.rightPanel:hide()
				arg_4_0:addChildView("city.union.union_fight.daily_over")
			else
				arg_4_0:addChildView("city.union.union_fight.final_over", arg_4_0:createHandler("addDialogView"))
			end
		elseif var_4_3 or var_4_0 == var_0_4.signup then
			arg_4_0:addChildView("city.union.union_fight.finals_view", arg_4_0:createHandler("addDialogView"), var_4_3, arg_4_0:createHandler("onRefesh"))

			if not var_4_3 then
				arg_4_0.btnBM:hide()
				arg_4_0.vipShow:hide()
			end
		else
			arg_4_0:addChildView("city.union.union_fight.top8_info_view", true, true, arg_4_0:createHandler("addDialogView")):x(600)
		end
	end,
	[7] = function(arg_6_0)
		local var_6_0 = arg_6_0.unionFight.round:read()

		arg_6_0.btnBM:hide()
		arg_6_0.imgYxs:hide()
		arg_6_0.leftUnionPanel:hide()
		arg_6_0.battleInfoPanel:hide()

		if var_6_0 == var_0_4.closed then
			arg_6_0:addChildView("city.union.union_fight.closed_view", arg_6_0:createHandler("onRefesh"))
		else
			arg_6_0:addChildView("city.union.union_fight.final_over", arg_6_0:createHandler("addDialogView"))
		end
	end
}
local var_0_6 = {
	{
		min = 30,
		hour = matchLanguage({
			"en"
		}) and 11 or 9
	},
	{
		min = 30,
		hour = matchLanguage({
			"en"
		}) and 22 or 20
	},
	{
		min = 50,
		hour = matchLanguage({
			"en"
		}) and 22 or 20
	},
	{
		min = 0,
		hour = matchLanguage({
			"en"
		}) and 23 or 21
	},
	{
		min = 45,
		hour = matchLanguage({
			"en"
		}) and 23 or 21
	},
	{
		min = 0,
		hour = matchLanguage({
			"en"
		}) and 24 or 22
	}
}

var_0_5[5] = var_0_5[2]
var_0_5[4] = var_0_5[2]
var_0_5[3] = var_0_5[2]
var_0_2.RESOURCE_FILENAME = "union_fight_main.json"
var_0_2.RESOURCE_BINDING = {
	dialogPanel = "dialogPanel",
	childPanel = "childPanel",
	battleInfoPanel = "battleInfoPanel",
	imgYxs = "imgYxs",
	leftUnionPanel = "leftUnionPanel",
	["leftUnionPanel.item"] = "unionPanelItem",
	["imgYxs.ready"] = "readyYxs",
	["rightPanel.item"] = "natureLimitItem",
	bottomPanel = "bottomPanel",
	rightPanel = "rightPanel",
	["bottomPanel.btnStar.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.btnRule.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.btnRank.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.btnReplay.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.btnBet.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.btnShop.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.text1"] = {
		varname = "text001",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["imgYxs.text"] = {
		varname = "leftTimeText",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["imgYxs.vipShow"] = {
		varname = "vipShow",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["bottomPanel.btnTeam"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnTeamClick")
			}
		}
	},
	["bottomPanel.btnStar"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnStarClick")
			}
		}
	},
	["bottomPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRuleClick")
			}
		}
	},
	["bottomPanel.btnRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRankClick")
			}
		}
	},
	["bottomPanel.btnReplay"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnReplayClick")
			}
		}
	},
	["bottomPanel.btnBet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBetClick")
			}
		}
	},
	["bottomPanel.btnShop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShopClick")
			}
		}
	},
	["battleInfoPanel.before.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("applyClick")
			}
		}
	},
	btnBM = {
		varname = "btnBM",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBMClick")
			}
		}
	},
	["rightPanel.list"] = {
		varname = "natureLimitList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("natureLimitData"),
				item = bindHelper.self("natureLimitItem"),
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:texture(ui.ATTR_ICON[arg_7_3])
				end
			}
		}
	},
	["leftUnionPanel.list"] = {
		varname = "unionPanelList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("unionPanelData"),
				item = bindHelper.self("unionPanelItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("name", "text1", "text2")

					var_8_0.name:text(arg_8_3.name)
					var_8_0.text1:text(arg_8_3.num)
					var_8_0.text2:text("/" .. arg_8_3.max)
				end
			}
		}
	}
}
var_0_2.RESOURCE_STYLES = {
	full = true
}

function var_0_2.onCreate(arg_9_0, arg_9_1)
	adapt.setAutoMultiLine(arg_9_0.text001, nil, 650, -15)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_9_0.bottomPanel,
			"pos",
			"left"
		},
		{
			arg_9_0.btnBM,
			"pos",
			"right"
		},
		{
			arg_9_0.rightPanel,
			"pos",
			"right"
		},
		{
			arg_9_0.imgYxs:get("ready"),
			"pos",
			"right"
		}
	})
	gGameUI.topuiManager:createView("union", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_zuzhi.png"
	})

	arg_9_0.unionPanelData = idlertable.new({})
	arg_9_0.weekNatureTb = {}

	for iter_9_0, iter_9_1 in csvPairs(csv.union_fight.nature_limit or {}) do
		arg_9_0.weekNatureTb[iter_9_1.weekDay] = iter_9_1.natureLimit
	end

	arg_9_0.jsAttrData = idlertable.new({})

	arg_9_0:initModel()
	arg_9_0:startRefreshTime()
	arg_9_0:onReCleanup()
end

function var_0_2.getWDay(arg_10_0)
	local var_10_0 = time.getNowDate().wday

	var_10_0 = var_10_0 == 1 and 7 or var_10_0 - 1

	return var_10_0
end

function var_0_2.startRefreshTime(arg_11_0)
	local function var_11_0()
		local var_12_0 = time.getNowDate()
		local var_12_1 = time.getTimestamp(var_12_0)

		for iter_12_0, iter_12_1 in ipairs(var_0_6) do
			var_12_0.hour = iter_12_1.hour
			var_12_0.min = iter_12_1.min
			var_12_0.sec = 0

			local var_12_2 = time.getTimestamp(var_12_0)

			if math.abs(var_12_2 - var_12_1) <= 1 then
				return true
			end
		end

		return false
	end

	local function var_11_1()
		local var_13_0 = gGameModel.daily_record:read("union_fight_sign_up")
		local var_13_1 = time.getNowDate()
		local var_13_2 = time.getTimestamp(var_13_1)
		local var_13_3 = gLanguageCsv.startTime
		local var_13_4, var_13_5 = dataEasy.getTimeStrByKey("unionFight", "signUpEnd", true)

		if not var_13_0 and var_13_4 > var_13_1.hour or var_13_1.hour == var_13_4 and var_13_5 > var_13_1.min then
			var_13_3 = gLanguageCsv.endSignUpTime
		end

		var_13_1.hour = var_13_4
		var_13_1.min = var_13_5
		var_13_1.sec = 0

		local var_13_6 = time.getTimestamp(var_13_1) - var_13_2

		if var_13_6 < 1 then
			return true
		end

		arg_11_0.leftTimeText:text(string.format("%s  %s ", var_13_3, time.getCutDown(var_13_6).str))

		return false
	end

	local var_11_2 = 3031825
	local var_11_3 = 120
	local var_11_4 = 0

	arg_11_0:enableSchedule():unSchedule(var_11_2)
	arg_11_0:enableSchedule():schedule(function(arg_14_0)
		var_11_4 = var_11_4 + 1

		if var_11_0() or var_11_4 >= var_11_3 then
			var_11_4 = 0

			arg_11_0:onRefesh(function()
				arg_11_0:refreshCenterPanel()
			end)
		end
	end, 1, 0, var_11_2)

	if matchLanguage({
		"en"
	}) and arg_11_0.unionFight.round:read() == var_0_4.signup then
		local var_11_5 = 20210519

		arg_11_0:enableSchedule():unSchedule(var_11_5)
		arg_11_0:enableSchedule():schedule(function(arg_16_0)
			var_11_1()
		end, 1, 0, var_11_5)
	end
end

function var_0_2.initModel(arg_17_0)
	local var_17_0 = gGameModel.union_fight

	arg_17_0.unionFight = {
		round = var_17_0:getIdler("round"),
		signs = var_17_0:getIdler("signs"),
		info = var_17_0:getIdler("info")
	}

	local var_17_1 = gGameModel.daily_record

	arg_17_0.dailyRecord = {
		signUp = var_17_1:getIdler("union_fight_sign_up")
	}

	local var_17_2

	arg_17_0.unionId = gGameModel.role:read("union_db_id")

	idlereasy.any({
		arg_17_0.unionFight.round,
		arg_17_0.unionFight.signs,
		arg_17_0.unionFight.info,
		arg_17_0.dailyRecord.signUp
	}, function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		if arg_17_0.refreshCenterPanel then
			if var_17_2 ~= arg_18_1 then
				arg_17_0:clearCenterPanel()
			end

			var_17_2 = arg_18_1

			arg_17_0:refreshCenterPanel()
		end
	end):anonyOnly(arg_17_0, "unionFightMainLoop")
	idlereasy.when(gGameModel.union_fight:getIdler("union_info"), function(arg_19_0, arg_19_1)
		if arg_17_0.refreshBattleInfo then
			arg_17_0:refreshBattleInfo(arg_19_1)
		end
	end):anonyOnly(arg_17_0, "unionFightInfoLoop")
end

function var_0_2.clearCenterPanel(arg_20_0)
	if arg_20_0.view then
		arg_20_0.view:onClose()

		arg_20_0.view = nil
	end

	if arg_20_0.dialogView then
		arg_20_0.dialogView:onClose()

		arg_20_0.dialogView = nil
	end

	arg_20_0.dialogPanel:hide()
	arg_20_0.childPanel:hide()
end

function var_0_2.refreshCenterPanel(arg_21_0)
	if arg_21_0.dialogView then
		return
	end

	local var_21_0 = arg_21_0:getWDay()

	if var_21_0 ~= arg_21_0.wday then
		arg_21_0:clearCenterPanel()
	end

	arg_21_0.wday = var_21_0
	arg_21_0.natureLimitData = arg_21_0.weekNatureTb[var_21_0] or {}

	arg_21_0.rightPanel:visible(itertools.size(arg_21_0.natureLimitData) > 0)

	local var_21_1 = arg_21_0.unionFight.signs:read()
	local var_21_2 = {}
	local var_21_3 = 0

	for iter_21_0, iter_21_1 in pairs(var_21_1 or {}) do
		var_21_3 = var_21_3 + 1

		table.insert(var_21_2, {
			idx = var_21_3,
			num = iter_21_1[1],
			max = iter_21_1[2],
			name = iter_21_1[3]
		})
	end

	table.sort(var_21_2, function(arg_22_0, arg_22_1)
		if arg_22_0.num ~= arg_22_1.num then
			return arg_22_0.num > arg_22_1.num
		end

		if arg_22_0.max ~= arg_22_1.max then
			return arg_22_0.max > arg_22_1.max
		end

		return arg_22_0.idx < arg_22_1.idx
	end)
	arg_21_0.unionPanelData:set(var_21_2)
	arg_21_0.vipShow:text(string.format(gLanguageCsv.vipSignupShow, csv.union_fight.base[1].autoSignVIP))
	var_0_5[var_21_0](arg_21_0)
end

function var_0_2.onReCleanup(arg_23_0)
	if arg_23_0._curViewName then
		arg_23_0:addChildView(arg_23_0._curViewName, unpack(arg_23_0._curViewArgs))

		arg_23_0._curViewName = nil
	end

	if arg_23_0._curDialogName then
		arg_23_0:addDialogView(arg_23_0._curDialogName, unpack(arg_23_0._curDialogArgs))

		arg_23_0._curDialogName = nil
	end
end

function var_0_2.onCleanup(arg_24_0)
	if arg_24_0.view then
		arg_24_0._roundResults = arg_24_0.view.roundResults
	end

	arg_24_0._curViewName = arg_24_0.curViewName
	arg_24_0.curViewName = nil
	arg_24_0._curViewArgs = arg_24_0.curViewArgs
	arg_24_0._curDialogName = arg_24_0.curDialogName
	arg_24_0.curDialogName = nil
	arg_24_0._curDialogArgs = arg_24_0.curDialogArgs

	arg_24_0:clearCenterPanel()
	var_0_0.onCleanup(arg_24_0)
end

function var_0_2.addChildView(arg_25_0, arg_25_1, ...)
	if arg_25_0.curViewName == arg_25_1 and arg_25_0.view then
		arg_25_0.childPanel:show()
		arg_25_0.view:show()

		return arg_25_0.view
	end

	if arg_25_0.view then
		arg_25_0.view:onClose()

		arg_25_0.view = nil
		arg_25_0.curViewName = nil
		arg_25_0.curViewArgs = nil
	end

	local var_25_0 = gGameUI:getConvertPos(arg_25_0, arg_25_0.childPanel)

	arg_25_0.view = gGameUI:createView(arg_25_1):init(...):addTo(arg_25_0.childPanel, 999):xy(var_25_0)

	arg_25_0.childPanel:show()

	arg_25_0.curViewName = arg_25_1
	arg_25_0.curViewArgs = {
		...
	}

	return arg_25_0.view
end

function var_0_2.addDialogView(arg_26_0, arg_26_1, ...)
	if arg_26_0.curDialogName == arg_26_1 and arg_26_0.dialogView then
		arg_26_0.childPanel:show()
		arg_26_0.dialogView:show()

		return arg_26_0.dialogView
	end

	if arg_26_0.dialogView then
		arg_26_0.dialogView:onClose()

		arg_26_0.dialogView = nil
		arg_26_0.curDialogName = nil
		arg_26_0.curDialogArgs = nil
	end

	arg_26_0.curDialogName = arg_26_1
	arg_26_0.curDialogArgs = {
		...
	}

	arg_26_0.childPanel:hide()
	arg_26_0.dialogPanel:show()

	local var_26_0 = gGameUI:getConvertPos(arg_26_0, arg_26_0.dialogPanel)
	local var_26_1 = gGameUI:createView(arg_26_1):init(...):addTo(arg_26_0.dialogPanel, 999):xy(var_26_0)

	arg_26_0.dialogView = var_26_1

	return var_26_1
end

function var_0_2.refreshBattleInfo(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.unionFight.round:read()

	arg_27_0.battleInfoPanel:visible(arg_27_0.wday ~= 6 and arg_27_0.wday ~= 7 and var_27_0 ~= var_0_4.over)

	local var_27_1 = arg_27_0.unionFight.round:read()
	local var_27_2 = arg_27_0.dailyRecord.signUp:read()
	local var_27_3 = var_27_1 == "signup"
	local var_27_4 = arg_27_0.battleInfoPanel:get("before"):hide()
	local var_27_5 = arg_27_0.battleInfoPanel:get("after"):hide()
	local var_27_6 = (var_27_3 and var_27_4:show() or var_27_5:show()):multiget("note1", "text1", "note2", "text2", "note3", "text3", "btn")
	local var_27_7 = gLanguageCsv.emptyInfo
	local var_27_8
	local var_27_9
	local var_27_10

	if var_27_3 then
		var_27_8 = arg_27_1.cur_point
		var_27_9 = arg_27_1.cur_rank
		var_27_10 = arg_27_1.sign_num .. "/" .. arg_27_1.member_num

		if var_27_9 == 0 then
			var_27_9 = var_27_7 or var_27_9
		end
	else
		var_27_8 = arg_27_1.live_num .. "/" .. arg_27_1.sign_num
		var_27_10 = arg_27_1.last_role_name
		var_27_9 = arg_27_1.sign_num .. "/" .. arg_27_1.member_num
		var_27_10 = var_27_10 == "" and var_27_7 or var_27_10
	end

	var_27_6.text1:text(var_27_8)
	var_27_6.text2:text(var_27_9)
	var_27_6.text3:text(var_27_10)
	var_27_6.note1:setAnchorPoint(cc.p(0, 0.5))
	adapt.oneLinePos(var_27_6.note1, {
		var_27_6.text1,
		var_27_6.note2,
		var_27_6.text2,
		var_27_6.note3,
		var_27_6.text3,
		var_27_6.btn
	}, {
		cc.p(10, 0),
		cc.p(30, 0),
		cc.p(10, 0),
		cc.p(30, 0),
		cc.p(10, 0),
		cc.p(30, 0)
	})
end

function var_0_2.onBtnTeamClick(arg_28_0)
	local var_28_0 = gGameModel.union_fight:read("round")
	local var_28_1 = gGameModel.daily_record:read("union_fight_sign_up")

	if var_28_0 == "over" then
		gGameUI:showTip(gLanguageCsv.unionNoTime)

		return
	end

	if not var_28_1 then
		gGameUI:showTip(gLanguageCsv.notSignUp)

		return
	elseif arg_28_0.wday == 1 then
		gGameUI:showTip(gLanguageCsv.unionUpcoming)

		return
	else
		gGameUI:stackUI("city.union.union_fight.embattle")
	end
end

function var_0_2.onBtnStarClick(arg_29_0)
	local var_29_0 = gGameModel.union_fight:read("round")

	if gGameModel.union_fight:read("union_info").battle_star_num <= 0 then
		gGameUI:showTip(gLanguageCsv.combatStar)

		return false
	end

	if arg_29_0.wday ~= 6 or var_29_0 ~= "signup" then
		gGameUI:showTip(gLanguageCsv.useCombetStar)

		return false
	end

	gGameUI:stackUI("city.union.union_fight.union_combat_star")
end

function var_0_2.onBtnRuleClick(arg_30_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_30_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_2.getRuleContext(arg_31_0, arg_31_1)
	local var_31_0 = adaptContext
	local var_31_1 = {
		var_31_0.clone(arg_31_1.title, function(arg_32_0)
			arg_32_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_31_0.noteText(112),
		var_31_0.noteText(20001, 20099),
		var_31_0.noteText(125),
		var_31_0.noteText(21001, 21099),
		var_31_0.noteText(128),
		var_31_0.noteText(22001, 22099),
		var_31_0.noteText(129),
		var_31_0.noteText(22101, 22199),
		var_31_0.noteText(130),
		var_31_0.noteText(22201, 22299),
		var_31_0.noteText(131),
		var_31_0.noteText(23001, 23099),
		var_31_0.noteText(141),
		var_31_0.noteText(22301, 22399),
		var_31_0.noteText(132)
	}

	for iter_31_0, iter_31_1 in orderCsvPairs(csv.union_fight.finalrank) do
		table.insert(var_31_1, var_31_0.clone(arg_31_1.awardItem, function(arg_33_0)
			local var_33_0 = arg_33_0:multiget("text", "list")

			if iter_31_1.range[2] - iter_31_1.range[1] == 1 then
				var_33_0.text:text(string.format(gLanguageCsv.rankSingle, iter_31_1.range[1]))
			else
				var_33_0.text:text(string.format(gLanguageCsv.rankMulti, iter_31_1.range[1], iter_31_1.range[2]))
			end

			uiEasy.createItemsToList(arg_31_1, var_33_0.list, iter_31_1.award)
		end))
	end

	table.insert(var_31_1, var_31_0.noteText(133))

	for iter_31_2, iter_31_3 in orderCsvPairs(csv.union_fight.prerank) do
		table.insert(var_31_1, var_31_0.clone(arg_31_1.awardItem, function(arg_34_0)
			local var_34_0 = arg_34_0:multiget("text", "list")

			if iter_31_3.range[2] - iter_31_3.range[1] == 1 then
				var_34_0.text:text(string.format(gLanguageCsv.rankSingle, iter_31_3.range[1]))
			else
				var_34_0.text:text(string.format(gLanguageCsv.rankMulti, iter_31_3.range[1], iter_31_3.range[2]))
			end

			uiEasy.createItemsToList(arg_31_1, var_34_0.list, iter_31_3.award)
		end))
	end

	return var_31_1
end

function var_0_2.onBtnRankClick(arg_35_0)
	gGameUI:stackUI("city.union.union_fight.union_rank")
end

function var_0_2.onBtnReplayClick(arg_36_0)
	local var_36_0 = arg_36_0.unionFight.round:read()

	if var_36_0 == var_0_4.prepare or var_36_0 == var_0_4.battle or var_36_0 == var_0_4.closed then
		gGameUI:showTip(gLanguageCsv.unionfightYesterdayLimit)

		return
	end

	if arg_36_0.wday == 1 or arg_36_0.wday == 7 then
		gGameUI:showTip(gLanguageCsv.unionfightYesterdayLimit)

		return
	end

	if arg_36_0.wday == 2 and var_36_0 ~= var_0_4.over then
		gGameUI:showTip(gLanguageCsv.unionfightYesterdayLimit)

		return
	end

	if arg_36_0.wday == 6 and var_36_0 == var_0_4.over then
		gGameUI:showTip(gLanguageCsv.unionfightYesterdayLimit)

		return
	end

	gGameApp:requestServer("/game/union/fight/yesterday/battle", function(arg_37_0)
		if not next(arg_37_0.view.round_results or {}) then
			gGameUI:showTip(gLanguageCsv.unionFightNoReplay)

			return
		end

		arg_36_0:addDialogView("city.union.union_fight.fighting_list.battle_review", arg_37_0.view.round_results, arg_37_0.view.union_info)
	end)
end

function var_0_2.onBtnBetClick(arg_38_0)
	local var_38_0 = gGameModel.union_fight:read("round")

	if arg_38_0.wday ~= 6 or var_38_0 ~= "signup" then
		gGameUI:showTip(gLanguageCsv.union_bet)

		return
	else
		gGameApp:requestServer("/game/union/fight/bet/info", function(arg_39_0)
			gGameUI:stackUI("city.union.union_fight.union_bet", nil, nil, arg_39_0.view)
		end)
	end
end

function var_0_2.onBtnShopClick(arg_40_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/union/shop/get", function(arg_41_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.UNION_FIGHT_SHOP)
		end)
	end
end

function var_0_2.onBtnBMClick(arg_42_0)
	gGameApp:requestServerCustom("/game/union/fight/signup"):onErrCall(function(arg_43_0)
		if gLanguageCsv[arg_43_0.err] then
			gGameUI:showTip(gLanguageCsv[arg_43_0.err])
		end
	end):params():doit(function(arg_44_0)
		return
	end)
end

function var_0_2.onRefesh(arg_45_0, arg_45_1)
	if arg_45_0.inRefresh then
		return
	end

	arg_45_0.inRefresh = true

	gGameApp:requestServer("/game/union/fight/battle/main", function(arg_46_0)
		if arg_45_1 then
			arg_45_1()
		end

		arg_45_0.inRefresh = nil
	end)
end

function var_0_2.onClose(arg_47_0)
	if arg_47_0.dialogView then
		arg_47_0.dialogView:onClose()

		arg_47_0.dialogView = nil

		arg_47_0.dialogPanel:hide()

		if arg_47_0.view then
			arg_47_0.childPanel:show()
		end

		arg_47_0.curDialogName = nil
		arg_47_0.curDialogArgs = nil
	else
		if arg_47_0.view then
			arg_47_0.view:onClose()

			arg_47_0.view = nil
		end

		var_0_0.onClose(arg_47_0)
	end
end

function var_0_2.applyClick(arg_48_0)
	gGameUI:stackUI("city.union.union_fight.union_apply")
end

return var_0_2
