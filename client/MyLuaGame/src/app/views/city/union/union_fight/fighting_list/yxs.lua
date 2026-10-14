local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("UnionFightListYXSView", var_0_1)

var_0_2.RESOURCE_FILENAME = "union_fight_fighting_list.json"
var_0_2.RESOURCE_BINDING = {
	itemBattle = "itemBattle",
	itemRound = "itemRound",
	itemTip = "itemTip",
	list = "list",
	["itemRound.baseNode.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemTip.baseNode.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.team"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.hpText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(238, 210, 171, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.team"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.hpText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(238, 210, 171, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.leftPanel.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightPanel.self.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(130, 45, 19, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.rightEmpty.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	["itemBattle.baseNode.leftEmpty.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(126, 60, 6, 255)
				}
			}
		}
	},
	btnShowSelf = {
		varname = "btnShowSelf",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowSelf")
			}
		}
	},
	["btnShowSelf.textNote"] = {
		varname = "btnShowSelf",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("showSelf"),
				method = function(arg_1_0)
					return arg_1_0 and gLanguageCsv.UFShowAll or gLanguageCsv.UFShowSelf
				end
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.role_id = gGameModel.role:read("id")

	local var_2_0 = userDefault.getForeverLocalKey("jsShowSelf", false)

	arg_2_0.showSelf = idler.new(var_2_0)

	local var_2_1 = userDefault.setForeverLocalKey("jsShowSelf", false)
	local var_2_2 = gGameModel.union_fight

	arg_2_0.unionFight = {
		round = var_2_2:getIdler("round"),
		signs = var_2_2:getIdler("signs"),
		info = var_2_2:getIdler("info"),
		roundResults = var_2_2:getIdler("round_results"),
		unionInfo = var_2_2:getIdler("union_info"),
		lastRoleName = var_2_2:getIdler("last_role_name"),
		nextRoundResultTime = var_2_2:getIdler("next_round_result_time")
	}
	arg_2_0.curRound = 0
	arg_2_0.refreshHandle = arg_2_1
	arg_2_0.roundResults = arg_2_2 or {}
	arg_2_0.roundResultsIsShow = {}
	arg_2_0.insertItemsTb = {}
	arg_2_0.curRoundType = ""

	local var_2_3 = 0

	idlereasy.any({
		arg_2_0.unionFight.round,
		arg_2_0.unionFight.unionInfo,
		arg_2_0.unionFight.roundResults,
		arg_2_0.unionFight.lastRoleName
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		var_2_3 = var_2_3 + 1

		local var_3_0 = var_2_3

		performWithDelay(arg_2_0, function()
			if var_3_0 ~= var_2_3 or tolua.isnull(arg_2_0) then
				return
			end

			arg_2_0.isPrepare = arg_3_1 == "prepare"

			for iter_4_0, iter_4_1 in pairs(arg_3_3) do
				if iter_4_0 and not arg_2_0.roundResults[iter_4_0] then
					arg_2_0.roundResults[iter_4_0] = iter_4_1
				end
			end

			for iter_4_2, iter_4_3 in pairs(arg_2_0.roundResults) do
				arg_2_0.curRound = math.max(arg_2_0.curRound, iter_4_2)
			end

			if not arg_2_0.maxRound or not arg_2_0.minRound then
				arg_2_0.maxRound, arg_2_0.minRound = 0, math.huge

				for iter_4_4, iter_4_5 in pairs(arg_2_0.roundResults) do
					arg_2_0.maxRound = math.max(arg_2_0.maxRound, iter_4_4)
					arg_2_0.minRound = math.min(arg_2_0.minRound, iter_4_4)
				end

				arg_2_0.minRound = math.max(arg_2_0.minRound, arg_2_0.maxRound - 1)
			end

			arg_2_0:refreshRoundResult()

			if arg_2_0.isEnd then
				return
			end

			if arg_3_2.is_out then
				arg_2_0:setAllBattleEnd(false)

				return
			elseif arg_3_4 ~= "" then
				arg_2_0:setAllBattleEnd(true, arg_3_4)

				return
			end
		end, 0)
	end)

	local var_2_4 = arg_2_0.list:getInnerContainer()

	arg_2_0.list:onScroll(function(arg_5_0)
		if arg_2_0.inReq then
			return
		end

		if (arg_5_0.name == "AUTOSCROLL_ENDED" or var_2_4:getPositionY() == 0) and arg_2_0.minRound > 1 and (not arg_2_0.curSendRound or arg_2_0.curSendRound <= arg_2_0.minRound - 1) then
			arg_2_0.curSendRound = arg_2_0.minRound - 1
			arg_2_0.inReq = true

			gGameApp:requestServer("/game/union/fight/battle/main", function(arg_6_0)
				arg_2_0.inReq = nil
				arg_2_0.curSendRound = nil
			end, arg_2_0.curSendRound)
		end
	end)
	arg_2_0:startRefreshTime()
end

function var_0_2.setAllBattleEnd(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.isEnd = true

	if not arg_7_0.lastTipItem then
		return
	end

	local var_7_0 = arg_7_0.lastTipItem:get("baseNode.text")

	if arg_7_1 then
		local var_7_1 = string.format(gLanguageCsv.unionFightBattleWinner, arg_7_2)

		var_7_0:text("")

		local var_7_2 = rich.createByStr(var_7_1, 52, nil, nil):addTo(var_7_0, 10, "privilege"):anchorPoint(cc.p(0.5, 0.5)):xy(0, 0)
	else
		var_7_0:text(gLanguageCsv.unionFightBattleLoseTip)
		text.addEffect(var_7_0, {
			color = cc.c4b(219, 212, 189, 255)
		})
	end
end

function var_0_2.refreshRoundResult(arg_8_0)
	local function var_8_0(arg_9_0, arg_9_1)
		if not arg_9_1 then
			return
		end

		if not arg_8_0.roundResultsIsShow[arg_9_0] then
			arg_8_0.roundResultsIsShow[arg_9_0] = true

			local var_9_0

			if arg_9_0 >= arg_8_0.maxRound then
				var_9_0 = arg_8_0.showNewBattleResult
			elseif arg_9_0 <= arg_8_0.minRound then
				var_9_0 = arg_8_0.showOldBattleResult
			else
				var_9_0 = arg_8_0.showOldBattleResult
			end

			if var_9_0 then
				arg_8_0.maxRound = math.max(arg_8_0.maxRound, arg_9_0)
				arg_8_0.minRound = math.min(arg_8_0.minRound, arg_9_0)

				var_9_0(arg_8_0, arg_9_0, arg_9_1)
			end
		end
	end

	local var_8_1 = clone(arg_8_0.roundResults)

	while next(var_8_1) do
		local var_8_2 = 0
		local var_8_3
		local var_8_4 = math.huge
		local var_8_5

		for iter_8_0, iter_8_1 in pairs(var_8_1) do
			if arg_8_0.roundResultsIsShow[iter_8_0] then
				var_8_1[iter_8_0] = nil
			else
				if iter_8_0 <= arg_8_0.minRound and var_8_2 <= iter_8_0 then
					var_8_2 = iter_8_0
					var_8_3 = iter_8_1
				end

				if iter_8_0 >= arg_8_0.maxRound and iter_8_0 <= var_8_4 then
					var_8_4 = iter_8_0
					var_8_5 = iter_8_1
				end
			end
		end

		var_8_0(var_8_4, var_8_5)

		var_8_1[var_8_4] = nil

		var_8_0(var_8_2, var_8_3)

		var_8_1[var_8_2] = nil
	end
end

function var_0_2.showOldBattleResult(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:setRoundNum(arg_10_1, true)
	arg_10_0:roundEnd(true, arg_10_1, true)

	for iter_10_0, iter_10_1 in ipairs(arg_10_2) do
		if arg_10_0.showSelf:read() == true then
			if iter_10_1.left.role_id == arg_10_0.role_id or iter_10_1.right.role_id == arg_10_0.role_id then
				arg_10_0:insertBattleInfo(iter_10_1, true)
			end
		else
			arg_10_0:insertBattleInfo(iter_10_1, true)
		end
	end
end

local var_0_3 = -1
local var_0_4 = -1

function var_0_2.checkPlayAni(arg_11_0, arg_11_1)
	local var_11_0 = time.getNowDate().wday

	var_11_0 = var_11_0 == 1 and 7 or var_11_0 - 1

	local var_11_1 = false

	if var_0_4 ~= var_11_0 then
		var_0_4 = var_11_0
		var_0_3 = -1
	end

	if arg_11_1 > var_0_3 then
		var_0_3 = arg_11_1

		return true
	end

	return false
end

function var_0_2.showNewBattleResult(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0:checkPlayAni(arg_12_1)

	local function var_12_1(arg_13_0, arg_13_1, arg_13_2)
		if not var_12_0 then
			return
		end

		table.insert(arg_12_0.insertItemsTb, {
			item = arg_13_0:retain(),
			delay = arg_13_1,
			index = arg_13_2
		})
	end

	var_12_1(arg_12_0:setRoundNum(arg_12_1, nil, var_12_0), 0.3, 0)

	for iter_12_0, iter_12_1 in ipairs(arg_12_2) do
		if arg_12_0.showSelf:read() == true then
			if iter_12_1.left.role_id == arg_12_0.role_id or iter_12_1.right.role_id == arg_12_0.role_id then
				var_12_1(arg_12_0:insertBattleInfo(iter_12_1, nil, var_12_0), 0.4, 1)
			end
		else
			var_12_1(arg_12_0:insertBattleInfo(iter_12_1, nil, var_12_0), 0.4, 1)
		end
	end

	var_12_1(arg_12_0:roundEnd(true, arg_12_1, nil, var_12_0), 0.3, 1)
end

function var_0_2.startTimeLabel(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = 3031507

	if arg_14_0.roundItem then
		arg_14_0.roundItem:removeFromParent()

		arg_14_0.roundItem = nil
	end

	if arg_14_1 <= 0 then
		arg_14_0.isSkip = nil

		arg_14_0:enableSchedule():unSchedule(var_14_0)

		return
	end

	if not arg_14_0.roundItem then
		arg_14_0.roundItem = arg_14_0:setRoundNum(arg_14_0.curRound + 1)

		arg_14_0.roundItem:retain()
	end

	arg_14_0.isSkip = true

	arg_14_0:enableSchedule():unSchedule(var_14_0)
	arg_14_0:enableSchedule():schedule(function(arg_15_0)
		if arg_14_1 <= 0 then
			arg_14_0:removeTimeLabel()

			arg_14_0.isSkip = nil

			if arg_14_2 then
				arg_14_2()
			end

			return false
		end

		local var_15_0 = time.getCutDown(arg_14_1)

		arg_14_1 = arg_14_1 - 1

		arg_14_0:showTimeLabel(var_15_0.str)
	end, 1, 0, var_14_0)
end

function var_0_2.roundEnd(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_1 = arg_16_1 or true

	local var_16_0 = string.format(gLanguageCsv.unionFightBattleWinTip, arg_16_2)

	if not arg_16_1 then
		var_16_0 = gLanguageCsv.unionFightBattleLoseTip
	end

	local var_16_1 = arg_16_0:insertTip(var_16_0, arg_16_3, arg_16_4)

	if not arg_16_0.maxRound or arg_16_2 >= arg_16_0.maxRound then
		arg_16_0.lastTipItem = var_16_1
	end

	return var_16_1
end

function var_0_2.setRoundNum(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.itemRound:clone()

	var_17_0:get("baseNode"):multiget("text").text:text(string.format(gLanguageCsv.unionFightRound, arg_17_1))

	if arg_17_3 then
		return var_17_0
	end

	if arg_17_2 then
		arg_17_0.list:pushBackCustomItem(var_17_0)
	else
		local var_17_1 = 0

		if arg_17_0.timeItem then
			var_17_1 = var_17_1 + 2
		end

		arg_17_0.list:insertCustomItem(var_17_0, var_17_1)
	end

	return var_17_0
end

function var_0_2.insertBattleInfo(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0.itemBattle:clone()
	local var_18_1 = false
	local var_18_2 = var_18_0:get("baseNode"):multiget("btnReplay", "leftPanel", "rightPanel", "leftEmpty", "rightEmpty")

	local function var_18_3(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		if not arg_19_1.role_id then
			var_18_1 = true

			arg_19_0:hide()
			arg_19_3:show()

			return
		end

		local var_19_0 = arg_19_0:multiget("roleIcon", "level", "name", "unionName", "team", "hpText", "hpBar", "win", "self")

		bind.extend(arg_18_0, var_19_0.roleIcon, {
			event = "extend",
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = arg_19_1.role_logo,
				frameId = arg_19_1.role_frame
			}
		})
		var_19_0.level:text(arg_19_1.role_level)
		var_19_0.name:text(arg_19_1.role_name)
		var_19_0.unionName:text(arg_19_1.union_name)
		var_19_0.team:text(string.format(gLanguageCsv.unionFightTeam, arg_19_1.troops))

		local var_19_1 = arg_19_1.hp > 0 and string.format(gLanguageCsv.unionFightHpText, arg_19_1.hp .. "%") or gLanguageCsv.unionFightDead

		var_19_0.hpText:text(var_19_1)
		var_19_0.self:visible(arg_19_1.role_id == gGameModel.role:read("id"))
		bind.extend(arg_18_0, var_19_0.hpBar, {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "city/union/union_fight/jdt_1.png",
				data = arg_19_1.hp
			}
		})
		var_19_0.hpBar:setPercent(arg_19_1.hp)
		var_19_0.win:visible(arg_19_2)
	end

	local var_18_4 = gGameModel.role:read("union_db_id")
	local var_18_5 = arg_18_1.left
	local var_18_6 = arg_18_1.right
	local var_18_7 = arg_18_1.result == "win"
	local var_18_8 = false

	if var_18_5.union_id and var_18_5.union_id ~= var_18_4 and var_18_6.union_id and var_18_6.union_id == var_18_4 then
		var_18_5 = arg_18_1.right
		var_18_6 = arg_18_1.left
		var_18_7 = not var_18_7
		var_18_8 = true
	end

	var_18_3(var_18_2.leftPanel:show(), var_18_5, var_18_7, var_18_2.leftEmpty:hide())
	var_18_3(var_18_2.rightPanel:show(), var_18_6, not var_18_7, var_18_2.rightEmpty:hide())

	if var_18_1 then
		var_18_2.btnReplay:setTouchEnabled(false)
	else
		bind.touch(arg_18_0.list, var_18_2.btnReplay, {
			methods = {
				ended = arg_18_0:createHandler("onReplayClick", arg_18_1.play_id, var_18_8)
			}
		})
	end

	if arg_18_3 then
		return var_18_0
	end

	if arg_18_2 then
		arg_18_0.list:pushBackCustomItem(var_18_0)
	else
		local var_18_9 = 1

		if arg_18_0.timeItem then
			var_18_9 = var_18_9 + 2
		end

		arg_18_0.list:insertCustomItem(var_18_0, var_18_9)
	end

	return var_18_0
end

function var_0_2.insertTip(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0.itemTip:clone()

	var_20_0:get("baseNode"):multiget("text").text:text(arg_20_1)

	if arg_20_3 then
		return var_20_0
	end

	if arg_20_2 then
		arg_20_0.list:pushBackCustomItem(var_20_0)
	else
		local var_20_1 = 1

		if arg_20_0.timeItem then
			var_20_1 = var_20_1 + 2
		end

		arg_20_0.list:insertCustomItem(var_20_0, var_20_1)
	end

	return var_20_0
end

function var_0_2.showTimeLabel(arg_21_0, arg_21_1)
	arg_21_1 = arg_21_1 or "00:25"

	local var_21_0 = string.format(gLanguageCsv.unionFightTimeText, arg_21_1)

	if not arg_21_0.timeItem then
		local var_21_1 = arg_21_0.itemTip:clone()
		local var_21_2 = var_21_1:get("baseNode.text"):text(var_21_0)

		arg_21_0.list:insertCustomItem(var_21_1, 1)

		arg_21_0.timeItem = var_21_1

		arg_21_0.timeItem:retain()
	else
		arg_21_0.timeItem:get("baseNode.text"):text(var_21_0)

		if arg_21_0.roundItem and arg_21_0.list:getIndex(arg_21_0.roundItem) ~= 0 then
			arg_21_0.list:removeItem(arg_21_0.list:getIndex(arg_21_0.roundItem))
			arg_21_0.list:insertCustomItem(arg_21_0.roundItem, 0)
		end

		if arg_21_0.timeItem and arg_21_0.list:getIndex(arg_21_0.timeItem) ~= 1 then
			arg_21_0.list:removeItem(arg_21_0.list:getIndex(arg_21_0.timeItem))
			arg_21_0.list:insertCustomItem(arg_21_0.timeItem, 1)
		end
	end
end

function var_0_2.removeTimeLabel(arg_22_0)
	if arg_22_0.timeItem then
		arg_22_0.timeItem:removeFromParent()

		arg_22_0.timeItem = nil
	end

	if arg_22_0.roundItem then
		arg_22_0.roundItem:removeFromParent()

		arg_22_0.roundItem = nil
	end
end

function var_0_2.onReplayClick(arg_23_0, arg_23_1, arg_23_2)
	userDefault.setForeverLocalKey("jsShowSelf", arg_23_0.showSelf:read())

	arg_23_2 = arg_23_2 and 1 or 0

	local var_23_0 = "/game/union/fight/playrecord/get"

	gGameModel:playRecordBattle(arg_23_1, nil, var_23_0, arg_23_2, nil)
end

function var_0_2.startRefreshTime(arg_24_0)
	local function var_24_0()
		local var_25_0 = time.getTimestamp(time.getNowDate())
		local var_25_1 = gGameModel.union_fight:read("prepare_end_time")
		local var_25_2 = gGameModel.union_fight:read("next_round_result_time")

		return math.max(var_25_1, var_25_2) - var_25_0
	end

	local var_24_1 = 3031825
	local var_24_2 = 0.5

	arg_24_0:enableSchedule():unSchedule(var_24_1)
	arg_24_0:enableSchedule():schedule(function(arg_26_0)
		if not arg_24_0:addNewBattleInfo() then
			return
		end

		if arg_24_0.inAni then
			return
		end

		if arg_24_0.isSkip then
			return
		end

		if arg_24_0.isEnd then
			return false
		end

		local var_26_0 = var_24_0()

		if var_26_0 <= 0 then
			arg_24_0.refreshHandle()

			return
		end

		arg_24_0:startTimeLabel(var_26_0, function()
			arg_24_0.refreshHandle(function()
				return
			end)
		end)
	end, var_24_2, 0, var_24_1)
end

function var_0_2.addNewBattleInfo(arg_29_0)
	if arg_29_0.inAni then
		return false
	end

	if not arg_29_0.insertItemsTb or not next(arg_29_0.insertItemsTb) then
		arg_29_0.inAni = false

		return true
	end

	local var_29_0 = arg_29_0.insertItemsTb[1]

	table.remove(arg_29_0.insertItemsTb, 1)

	local function var_29_1(arg_30_0, arg_30_1, arg_30_2)
		arg_30_2 = math.min(arg_30_2, 0.3)

		local var_30_0 = arg_30_0:size().height
		local var_30_1 = false

		if arg_30_1 >= arg_29_0.list:getChildrenCount() then
			arg_29_0.list:insertCustomItem(arg_30_0, arg_30_1)

			arg_29_0.inAni = false

			return
		end

		for iter_30_0, iter_30_1 in pairs(arg_29_0.list:getChildren()) do
			if arg_30_1 < iter_30_0 then
				local var_30_2 = iter_30_1:get("baseNode")
				local var_30_3, var_30_4 = var_30_2:xy()

				var_30_2:setTouchEnabled(false)
				transition.executeSequence(var_30_2, true):moveTo(arg_30_2, var_30_3, var_30_4 - var_30_0):func(function()
					var_30_2:xy(var_30_3, var_30_4)
					var_30_2:setTouchEnabled(true)

					if not var_30_1 then
						arg_29_0.list:insertCustomItem(arg_30_0, arg_30_1)

						arg_29_0.inAni = false
						var_30_1 = true
					end
				end):done()
			end
		end
	end

	arg_29_0.inAni = true

	var_29_1(var_29_0.item, var_29_0.index, var_29_0.delay)

	return false
end

function var_0_2.onShowSelf(arg_32_0)
	if not gGameModel.daily_record:read("union_fight_sign_up") then
		gGameUI:showTip(gLanguageCsv.UFRecordNoSelfData)

		return
	end

	arg_32_0.showSelf:modify(function(arg_33_0)
		return true, not arg_33_0
	end)
	arg_32_0:removeTimeLabel()
	arg_32_0.list:removeAllChildren()

	arg_32_0.maxRound, arg_32_0.minRound = 0, math.huge

	for iter_32_0, iter_32_1 in pairs(arg_32_0.roundResults) do
		arg_32_0.maxRound = math.max(arg_32_0.maxRound, iter_32_0)
		arg_32_0.minRound = math.min(arg_32_0.minRound, iter_32_0)
	end

	arg_32_0.minRound = math.max(arg_32_0.minRound, arg_32_0.maxRound - 1)
	arg_32_0.roundResultsIsShow = {}
	arg_32_0.insertItemsTb = {}
	arg_32_0.isSkip = nil

	arg_32_0:enableSchedule():unScheduleAll()
	arg_32_0:startRefreshTime()
	arg_32_0:refreshRoundResult()

	if arg_32_0.unionFight.unionInfo:read().is_out then
		arg_32_0:setAllBattleEnd(false)

		return
	elseif arg_32_0.unionFight.lastRoleName:read() ~= "" then
		arg_32_0:setAllBattleEnd(true, arg_32_0.unionFight.lastRoleName:read())

		return
	end

	arg_32_0.list:jumpToTop()
end

return var_0_2
