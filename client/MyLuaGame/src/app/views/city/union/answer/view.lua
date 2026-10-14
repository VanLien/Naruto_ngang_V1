local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("UnionAnswerView", var_0_0)

local function var_0_2(arg_1_0, arg_1_1)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("text"), {
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("text"))
		text.addEffect(arg_1_0:get("text"), {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

var_0_1.RESOURCE_FILENAME = "union_answer.json"
var_0_1.RESOURCE_BINDING = {
	topPanel = "topPanel",
	battomPanel = "battomPanel",
	empty = "empty",
	["battomPanel.text1"] = "text1",
	["battomPanel.text2"] = "text2",
	["battomPanel.textNum"] = "textNum",
	timePanel = "timePanel",
	["timePanel.timeNum"] = "timeNum",
	["topPanel.item"] = "item",
	["topPanel.battom"] = "topBattom",
	["timePanel.timeTxt"] = "timeTxt",
	["timePanel.title"] = "titleIcon",
	["topPanel.title"] = "topTitle",
	rank = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	rule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["battomPanel.startBtn"] = {
		varname = "startBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["battomPanel.startBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["battomPanel.addIcon"] = {
		varname = "addIcon",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	["rank.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rule.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["topPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("rank", "name", "num")

					var_2_0.rank:text(arg_2_2)
					var_2_0.name:text(arg_2_3.name)
					var_2_0.num:text(arg_2_3.num)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["topPanel.unionBtn"] = {
		varname = "unionBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onunionClick")
			}
		}
	},
	["topPanel.personBtn"] = {
		varname = "personBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onpersonClick")
			}
		}
	},
	["topPanel.unionBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["topPanel.personBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("default", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "POKEMONANSWER",
		title = gLanguageCsv.pokemonAnswer
	})
	arg_3_0:enableSchedule()
	arg_3_0:initModel()

	arg_3_0.data = arg_3_1.view

	local var_3_0 = arg_3_0.data.round

	arg_3_0.round = idler.new(var_3_0)
	arg_3_0.roleData = idlers.new({})
	arg_3_0.unionData = idlers.new({})
	arg_3_0.myRoleData = idlers.new({})
	arg_3_0.myUnionData = idlers.new({})

	arg_3_0.roleData:update(arg_3_0.data.role_ranks or {})
	arg_3_0.unionData:update(arg_3_0.data.union_ranks or {})
	arg_3_0.myRoleData:update(arg_3_0.data.my_rank or {})
	arg_3_0.myUnionData:update(arg_3_0.data.my_union_rank or {})

	arg_3_0.servers = arg_3_0.data.servers
	arg_3_0.rankType = idler.new(1)
	arg_3_0.tabDatas = idlers.new({})

	arg_3_0.list:setScrollBarEnabled(true)

	arg_3_0.qaAnswerTimes = gCommonConfigCsv.unionQATimes

	local var_3_1 = gCommonConfigCsv.unionQABuyTimes
	local var_3_2 = arg_3_0.timeNum:x()

	idlereasy.any({
		arg_3_0.rankType,
		arg_3_0.roleData,
		arg_3_0.round,
		arg_3_0.unionData
	}, function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		arg_3_0.data.role_ranks = arg_4_2
		arg_3_0.data.union_ranks = arg_4_4

		arg_3_0.unionBtn:setBright(arg_4_1 == 1)
		arg_3_0.personBtn:setBright(arg_4_1 == 1)
		text.addEffect(arg_3_0.unionBtn:get("text"), {
			color = arg_4_1 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED
		})
		text.addEffect(arg_3_0.personBtn:get("text"), {
			color = arg_4_1 == 1 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE
		})

		local var_4_0 = {}

		if arg_4_1 == 1 then
			for iter_4_0, iter_4_1 in ipairs(arg_4_4) do
				table.insert(var_4_0, {
					name = iter_4_1:read().name,
					num = iter_4_1:read().score
				})
			end

			if arg_4_3 == "start" then
				arg_3_0.topTitle:text(gLanguageCsv.unionRank)
			else
				arg_3_0.topTitle:text(gLanguageCsv.preUnionRank)
			end
		else
			for iter_4_2, iter_4_3 in ipairs(arg_4_2) do
				table.insert(var_4_0, {
					name = iter_4_3:read().name,
					num = iter_4_3:read().score
				})
			end

			if arg_4_3 == "start" then
				arg_3_0.topTitle:text(gLanguageCsv.personalRank)
			else
				arg_3_0.topTitle:text(gLanguageCsv.prePersonalRank)
			end
		end

		arg_3_0.tabDatas:update(var_4_0)

		if not itertools.isempty(arg_4_4) then
			arg_3_0.empty:hide()
			arg_3_0.unionBtn:show()
			arg_3_0.personBtn:show()
		else
			arg_3_0.empty:show()
			arg_3_0.unionBtn:hide()
			arg_3_0.personBtn:hide()
		end
	end)
	idlereasy.any({
		arg_3_0.rankType,
		arg_3_0.myUnionData,
		arg_3_0.myRoleData
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		arg_3_0.data.my_rank = arg_5_3
		arg_3_0.data.my_union_rank = arg_5_2

		if arg_5_1 == 1 then
			if arg_5_2.rank and arg_5_2.rank:read() ~= 0 then
				arg_3_0.topBattom:show()

				local var_5_0 = arg_3_0.topBattom:multiget("num", "rank", "name")

				if arg_5_2.score then
					var_5_0.num:text(arg_5_2.score:read())
				end

				if arg_5_2.rank then
					var_5_0.rank:text(arg_5_2.rank:read())
				end

				if arg_5_2.name then
					var_5_0.name:text(arg_5_2.name:read())
				end
			else
				arg_3_0.topBattom:hide()
			end
		elseif arg_5_3.rank and arg_5_3.rank:read() ~= 0 then
			arg_3_0.topBattom:show()

			local var_5_1 = arg_3_0.topBattom:multiget("num", "rank", "name")

			if arg_5_3.score then
				var_5_1.num:text(arg_5_3.score:read())
			end

			if arg_5_3.rank then
				var_5_1.rank:text(arg_5_3.rank:read())
			end

			if arg_5_3.name then
				var_5_1.name:text(arg_3_0.roleId)
			end
		else
			arg_3_0.topBattom:hide()
		end
	end)
	arg_3_0.text2:text(string.format(gLanguageCsv.unionAnswerShowTimes, gCommonConfigCsv.unionQATimes + gCommonConfigCsv.unionQABuyTimes))
	idlereasy.any({
		arg_3_0.qaTimes,
		arg_3_0.qaBuyTimes
	}, function(arg_6_0, arg_6_1, arg_6_2)
		arg_3_0.qaAnswerTimes = gCommonConfigCsv.unionQATimes + arg_6_2 - arg_6_1

		arg_3_0.textNum:text(arg_3_0.qaAnswerTimes)

		if arg_6_1 - gCommonConfigCsv.unionQATimes - gCommonConfigCsv.unionQABuyTimes >= 0 then
			var_0_2(arg_3_0.startBtn, false)
		else
			var_0_2(arg_3_0.startBtn, true)
		end

		if arg_6_2 >= gCommonConfigCsv.unionQABuyTimes then
			arg_3_0.addIcon:hide()
		else
			arg_3_0.addIcon:show()
		end

		adapt.oneLineCenterPos(cc.p(1205, 155), {
			arg_3_0.text1,
			arg_3_0.textNum,
			arg_3_0.addIcon
		}, cc.p(15, 0))
	end)
	idlereasy.when(arg_3_0.round, function(arg_7_0, arg_7_1)
		if arg_7_1 == "start" then
			arg_3_0.battomPanel:show()
			arg_3_0:initCountDown()
			arg_3_0.timeTxt:show()
			arg_3_0.startBtn:show()
			arg_3_0.titleIcon:texture("city/union/answer/txt_jlwdjxz.png")
		else
			arg_3_0.battomPanel:hide()
			arg_3_0.timeTxt:hide()
			arg_3_0:timeToOpen()
			arg_3_0.startBtn:hide()
			arg_3_0.titleIcon:texture("city/union/answer/txt_jlwdcbz.png")
		end
	end)
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.qaTimes = gGameModel.daily_record:getIdler("union_qa_times")
	arg_8_0.qaBuyTimes = gGameModel.daily_record:getIdler("union_qa_buy_times")
	arg_8_0.rmb = gGameModel.role:getIdler("rmb")
	arg_8_0.roleId = gGameModel.role:read("name")
end

function var_0_1.onunionClick(arg_9_0)
	arg_9_0.rankType:set(1)
end

function var_0_1.onpersonClick(arg_10_0)
	arg_10_0.rankType:set(2)
end

function var_0_1.initCountDown(arg_11_0)
	local var_11_0 = arg_11_0.timeNum
	local var_11_1 = time.getTodayStrInClock(0)
	local var_11_2 = time.getNowDate()
	local var_11_3 = 0

	if var_11_2.wday == 1 then
		var_11_3 = time.getNumTimestamp(var_11_1, 5) + 68400
	elseif var_11_2.wday == 7 then
		var_11_3 = time.getNumTimestamp(var_11_1, 5) + 86400 + 68400
	end

	local function var_11_4()
		local var_12_0 = time.getCutDown(var_11_3 - time.getTime())

		var_11_0:text(var_12_0.str)

		if var_11_3 - time.getTime() <= 0 then
			return false
		end

		adapt.oneLineCenterPos(cc.p(350, 94), {
			arg_11_0.timeTxt,
			arg_11_0.timeNum
		}, cc.p(15, 0))

		return true
	end

	arg_11_0:enableSchedule():schedule(function(arg_13_0)
		if not var_11_4() then
			arg_11_0:unSchedule("CountDown1")

			return false
		end
	end, 1, 0, "CountDown1")
end

function var_0_1.timeToOpen(arg_14_0)
	local var_14_0 = csv.cross.union_qa.base[1].servOpenDays

	if dataEasy.serverOpenDaysLess(var_14_0) then
		local var_14_1 = string.format(gLanguageCsv.unlockServerOpen, var_14_0)

		gGameUI:showTip(var_14_1)

		return
	end

	local var_14_2 = dataEasy.getCrossServiceData("crossunionqa", csv.cross.union_qa.base[1].servOpenDays)

	if var_14_2 then
		local var_14_3, var_14_4, var_14_5 = time.getYearMonthDay(csv.cross.service[var_14_2].date)
		local var_14_6, var_14_7, var_14_8 = time.getYearMonthDay(csv.cross.service[var_14_2].endDate)

		arg_14_0.timeNum:text(string.format(gLanguageCsv.unionAnswerOpenTimeShow, var_14_4, var_14_5, var_14_7, var_14_8))
	else
		arg_14_0.timeNum:text(gLanguageCsv.comingSoon)
	end

	adapt.oneLineCenterPos(cc.p(350, 94), {
		arg_14_0.timeTxt,
		arg_14_0.timeNum
	}, cc.p(15, 0))
end

function var_0_1.onSureClick(arg_15_0)
	if arg_15_0.qaAnswerTimes > 0 then
		gGameApp:requestServer("/game/union/qa/prepare", function(arg_16_0)
			arg_15_0.tbData = arg_16_0.view

			gGameUI:stackUI("city.union.answer.problem", nil, {
				full = true
			}, arg_15_0:createHandler("sendParams"))
		end)
	elseif gCommonConfigCsv.unionQABuyTimes - arg_15_0.qaBuyTimes:read() > 0 then
		local var_15_0 = gCommonConfigCsv.unionQABuyCost
		local var_15_1 = "#C0x5b545b#" .. string.format(gLanguageCsv.pokemonAnswerBuyTimes, var_15_0)

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_15_1,
			cb = function()
				if arg_15_0.rmb:read() >= var_15_0 then
					gGameApp:requestServer("/game/union/qa/buy", function(arg_18_0)
						gGameApp:requestServer("/game/union/qa/prepare", function(arg_19_0)
							arg_15_0.tbData = arg_19_0.view

							gGameUI:stackUI("city.union.answer.problem", nil, {
								full = true
							}, arg_15_0:createHandler("sendParams"))
						end)
					end)
				else
					uiEasy.showDialog("rmb", nil, {
						dialog = true
					})
				end
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		gGameUI:showTip(gLanguageCsv.unionAnswerTipsText2)
	end
end

function var_0_1.onRuleClick(arg_20_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_20_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.onRankClick(arg_21_0)
	if arg_21_0.round:read() ~= "" then
		gGameApp:requestServer("/game/union/qa/rank", function(arg_22_0)
			gGameUI:stackUI("city.union.answer.rank", nil, nil, arg_22_0)
		end)
	else
		gGameUI:showTip(gLanguageCsv.unionAnswerRankTipsText)
	end
end

function var_0_1.onAddClick(arg_23_0)
	local var_23_0 = gCommonConfigCsv.unionQABuyTimes
	local var_23_1 = gCommonConfigCsv.unionQABuyCost

	if var_23_0 - arg_23_0.qaBuyTimes:read() > 0 then
		local var_23_2 = "#C0x5b545b#" .. string.format(gLanguageCsv.pokemonAnswerBuyTimes, var_23_1)

		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = var_23_2,
			cb = function()
				if arg_23_0.rmb:read() >= var_23_1 then
					gGameApp:requestServer("/game/union/qa/buy", function(arg_25_0)
						gGameUI:showTip(gLanguageCsv.unionAnswerTipsText)
					end)
				else
					uiEasy.showDialog("rmb", nil, {
						dialog = true
					})
				end
			end,
			dialogParams = {
				clickClose = false
			}
		})
	else
		gGameUI:showTip(gLanguageCsv.unionAnswerTipsText1)
	end
end

function var_0_1.getRuleContext(arg_26_0, arg_26_1)
	local var_26_0
	local var_26_1 = adaptContext
	local var_26_2 = {
		var_26_1.clone(arg_26_1.title, function(arg_27_0)
			arg_27_0:get("text"):text(gLanguageCsv.unionAnswerRule)
		end),
		var_26_1.noteText(112001, 112100)
	}
	local var_26_3 = arg_26_0.servers

	if var_26_3 then
		local var_26_4 = arraytools.map(getMergeServers(var_26_3), function(arg_28_0, arg_28_1)
			return string.format(gLanguageCsv.brackets, getServerArea(arg_28_1, nil, true))
		end)

		if arg_26_0.round:read() == "start" then
			table.insert(var_26_2, 2, "#C0x5B545B#" .. gLanguageCsv.currentServers .. table.concat(var_26_4, ","))
		else
			table.insert(var_26_2, 2, "#C0x5B545B#" .. gLanguageCsv.preServers .. table.concat(var_26_4, ","))
		end
	end

	local var_26_5 = csv.cross.union_qa.union_rank
	local var_26_6 = csv.cross.union_qa.role_rank

	for iter_26_0, iter_26_1 in orderCsvPairs(var_26_5) do
		table.insert(var_26_2, var_26_1.clone(arg_26_1.awardItem, function(arg_29_0)
			local var_29_0 = var_26_5[iter_26_0 - 1] and var_26_5[iter_26_0 - 1].rankMax or 0
			local var_29_1 = arg_29_0:multiget("text", "list")

			if iter_26_1.rankMax - var_29_0 == 1 then
				var_29_1.text:text(string.format(gLanguageCsv.rankSingle, iter_26_1.rankMax))
			else
				var_29_1.text:text(string.format(gLanguageCsv.rankMulti, var_29_0 + 1, iter_26_1.rankMax))
			end

			uiEasy.createItemsToList(arg_26_1, var_29_1.list, iter_26_1.award)
		end))
	end

	table.insert(var_26_2, var_26_1.noteText(112101))

	for iter_26_2, iter_26_3 in orderCsvPairs(var_26_6) do
		table.insert(var_26_2, var_26_1.clone(arg_26_1.awardItem, function(arg_30_0)
			local var_30_0 = var_26_6[iter_26_2 - 1] and var_26_6[iter_26_2 - 1].rankMax or 0
			local var_30_1 = arg_30_0:multiget("text", "list")

			if iter_26_3.rankMax - var_30_0 == 1 then
				var_30_1.text:text(string.format(gLanguageCsv.rankSingle, iter_26_3.rankMax))
			else
				var_30_1.text:text(string.format(gLanguageCsv.rankMulti, var_30_0 + 1, iter_26_3.rankMax))
			end

			uiEasy.createItemsToList(arg_26_1, var_30_1.list, iter_26_3.award)
		end))
	end

	return var_26_2
end

function var_0_1.sendParams(arg_31_0, arg_31_1)
	return arg_31_0.tbData, arg_31_0.roleData, arg_31_0.unionData, arg_31_0.myRoleData, arg_31_0.myUnionData
end

return var_0_1
