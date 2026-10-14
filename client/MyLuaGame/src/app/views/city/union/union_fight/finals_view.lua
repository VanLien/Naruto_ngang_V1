local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionFightFinalsView", cc.load("mvc").ViewBase)
local var_0_2 = {
	fighting = 2,
	winner = 3,
	loser = 4,
	finalWin = 5,
	prepare = 1
}
local var_0_3 = {
	[36] = "group-b2",
	[-18452736] = "third",
	[27] = "group-b1",
	[45] = "group-a2",
	[18] = "group-a1",
	[2736] = "group-b3",
	[18452736] = "champion",
	[1845] = "group-a3"
}

var_0_1.RESOURCE_FILENAME = "union_fight_finals_view.json"
var_0_1.RESOURCE_BINDING = {
	attrPanel = "attrPanel",
	mainPanel = "mainPanel",
	battleInfoPanel = "battleInfoPanel",
	btnPos = "btnPos",
	["attrPanel.note"] = "attrNote",
	["signPanel.ready"] = "ready",
	signPanel = "signPanel",
	["attrPanel.item"] = "signItem",
	["signPanel.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 8,
					color = cc.c4b(166, 105, 38, 255)
				}
			}
		}
	},
	btnFightList = {
		varname = "btnFightList",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnFightListClick")
			}
		}
	},
	btnAssign = {
		varname = "btnAssign",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnAssignClick")
			}
		}
	},
	btnRange = {
		varname = "btnRange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRangeClick")
			}
		}
	},
	["btnAssign.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btnRange.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btnFightList.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["attrPanel.list"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("signAttrData"),
				item = bindHelper.self("signItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "text1", "text2")

					var_1_0.icon:texture(ui.ATTR_ICON[arg_1_3.natureId])

					local var_1_1 = "attr" .. string.caption(game.ATTRDEF_TABLE[arg_1_3.attrId])

					var_1_0.text1:text(gLanguageCsv[var_1_1])

					local var_1_2 = arg_1_3.value .. "%"

					if tonumber(arg_1_3.value) > 0 then
						var_1_2 = "+" .. var_1_2
					end

					var_1_0.text2:text(var_1_2)
					adapt.oneLinePos(var_1_0.text1, var_1_0.text2)
				end
			}
		}
	},
	["mainPanel.rightUnionPanel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	},
	["mainPanel.rightUnionPanel.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	},
	["mainPanel.leftUnionPanel.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	},
	["mainPanel.leftUnionPanel.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(72, 2, 1, 255)
				}
			}
		}
	}
}

local var_0_4 = ""

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_2_0.signPanel:get("ready"),
			"pos",
			"right"
		},
		{
			arg_2_0.btnPos,
			"pos",
			"right"
		}
	})

	arg_2_0.dialogHandler = arg_2_1
	arg_2_0.refreshHandler = arg_2_3
	arg_2_0.isInclude = arg_2_2

	local var_2_0 = gGameModel.union_fight

	arg_2_0.unionFight = {
		round = var_2_0:getIdler("round"),
		signs = var_2_0:getIdler("signs"),
		info = var_2_0:getIdler("info"),
		stars = var_2_0:getIdler("battle_stars"),
		starNum = var_2_0:getIdler("battle_star_num")
	}
	arg_2_0.curState = idler.new(var_0_2.prepare)
	arg_2_0.isInBattle = false

	arg_2_0:initModel()

	arg_2_0.signAttrData = idlertable.new({})

	local var_2_1 = arg_2_0.mainPanel:get("leftUnionPanel")

	var_2_1:get("text"):text(gGameModel.union:read("name"))
	var_2_1:get("icon"):texture(gUnionLogoCsv[gGameModel.union:read("logo")])
	var_2_1:get("level"):text(gGameModel.union:read("level"))

	local var_2_2 = 0

	idlereasy.any({
		arg_2_0.unionFight.round,
		arg_2_0.unionFight.signs,
		gGameModel.daily_record:getIdler("union_fight_sign_up")
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		var_2_2 = var_2_2 + 1

		local var_3_0 = var_2_2

		performWithDelay(arg_2_0, function()
			if var_3_0 ~= var_2_2 then
				return
			end

			local var_4_0 = arg_3_1 ~= "battle"

			arg_2_0.signPanel:get("ready"):visible(arg_3_3)
			arg_2_0.signPanel:visible(var_4_0)
			arg_2_0.mainPanel:visible(not var_4_0)

			if var_4_0 then
				arg_2_0.btnFightList:hide()
				arg_2_0.btnRange:visible(arg_2_2 and arg_3_3 or true)
				arg_2_0.btnAssign:visible(arg_2_2 and arg_3_3)
			else
				arg_2_0.btnFightList:show()
				arg_2_0.btnRange:show()
				arg_2_0.btnAssign:show()
				arg_2_0:getPrepareStateAndTime()
				arg_2_0:startBattleLoop()
			end

			adapt.oneLinePos(arg_2_0.btnPos, {
				arg_2_0.btnAssign,
				arg_2_0.btnRange,
				arg_2_0.btnFightList
			}, cc.p(58, 0), "right")
		end, 0)
	end)
	idlereasy.any({
		arg_2_0.unionFight.stars,
		arg_2_0.unionFight.starNum
	}, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = {}

		for iter_5_0, iter_5_1 in pairs(arg_5_1 or {}) do
			for iter_5_2, iter_5_3 in pairs(iter_5_1) do
				if tonumber(iter_5_3) ~= 0 then
					table.insert(var_5_0, {
						natureId = iter_5_0,
						attrId = iter_5_2,
						value = iter_5_3
					})
				end
			end
		end

		local var_5_1 = itertools.size(var_5_0)

		arg_2_0.signAttrData:set(var_5_0)
		arg_2_0.attrPanel:visible(var_5_1 > 0)

		local var_5_2 = 395
		local var_5_3 = arg_2_0.signItem:size().width

		arg_2_0.attrList:x(var_5_2 + (4 - var_5_1) * var_5_3 / 2)
		adapt.oneLinePos(arg_2_0.attrList, arg_2_0.attrNote, cc.p(5, 0), "right")
	end)

	local var_2_3 = arg_2_0.mainPanel:get("textNote1")
	local var_2_4 = arg_2_0.mainPanel:get("textNote2")
	local var_2_5 = arg_2_0.mainPanel:get("leftUnionPanel.win")
	local var_2_6 = arg_2_0.mainPanel:get("rightUnionPanel.win")

	idlereasy.when(arg_2_0.curState, function(arg_6_0, arg_6_1)
		if not arg_6_1 then
			return
		end

		if arg_6_1 == var_0_2.prepare then
			arg_2_0:playAni(false)
			var_2_3:show()
			var_2_4:show()
			var_2_5:hide()
			var_2_6:hide()

			local var_6_0 = arg_2_0.mainPanel:get("rightUnionPanel")

			var_6_0:get("text"):text(arg_2_0.enemyUnion.name)
			var_6_0:get("icon"):texture(gUnionLogoCsv[arg_2_0.enemyUnion.logo])
			var_6_0:get("level"):text(arg_2_0.enemyUnion.level)
		elseif arg_6_1 == var_0_2.fighting then
			arg_2_0:playAni(true)
			var_2_5:hide()
			var_2_6:hide()
			var_2_3:show()
			var_2_4:hide()
		elseif arg_6_1 == var_0_2.winner then
			arg_2_0:playAni(false)
			var_2_5:show()
			var_2_6:hide()
			var_2_3:hide()
			var_2_4:show()
		elseif arg_6_1 == var_0_2.loser then
			arg_2_0:playAni(false)
			var_2_5:hide()
			var_2_6:show()
			var_2_3:hide()
			var_2_4:show()
		elseif arg_6_1 == var_0_2.finalWin then
			arg_2_0:playAni(false)
			var_2_5:show()
			var_2_6:hide()
			var_2_3:hide()
			var_2_4:show()
		end
	end)
end

local function var_0_5(arg_7_0)
	local var_7_0 = true

	for iter_7_0, iter_7_1 in pairs(arg_7_0) do
		for iter_7_2, iter_7_3 in ipairs(iter_7_1.troops) do
			for iter_7_4, iter_7_5 in pairs(iter_7_3.cards) do
				if iter_7_5[3] > 0 then
					return false
				end
			end
		end
	end

	return true
end

local var_0_6 = "VS_ANIMATION1"
local var_0_7 = "VS_ANIMATION2"

function var_0_1.playAni(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.mainPanel:get(var_0_6)

	if not var_8_0 then
		local var_8_1 = arg_8_0.mainPanel:get("vs"):hide()
		local var_8_2 = arg_8_0.mainPanel:size()
		local var_8_3 = var_8_1:size()
		local var_8_4 = "union_fight/skeleton.skel"

		var_8_0 = widget.addAnimationByKey(arg_8_0.mainPanel, var_8_4, var_0_6, "effect", 5):xy(var_8_2.width / 2 - var_8_3.width / 2 + 20, var_8_2.height / 2 + var_8_3.height / 2)
	end

	var_8_0:play("effect")
	var_8_0:addPlay("effect_loop")

	local var_8_5 = 2300
	local var_8_6 = 0.6666666666666666

	local function var_8_7(arg_9_0, arg_9_1)
		local var_9_0, var_9_1 = arg_9_0:xy()

		arg_9_0:x(var_9_0 + arg_9_1)
		transition.executeSequence(arg_9_0):easeBegin("EXPONENTIALOUT"):moveTo(var_8_6, var_9_0, var_9_1):easeEnd():done()
	end

	var_8_7(arg_8_0.mainPanel:get("leftUnionPanel"), -var_8_5)
	var_8_7(arg_8_0.mainPanel:get("rightUnionPanel"), var_8_5)

	local var_8_8 = arg_8_0.mainPanel:get(var_0_7)

	if not var_8_8 then
		local var_8_9 = arg_8_0.mainPanel:get("textNote2"):hide()
		local var_8_10 = arg_8_0.mainPanel:size()
		local var_8_11 = var_8_9:size()
		local var_8_12 = "union_fight/dz.skel"

		var_8_8 = widget.addAnimationByKey(arg_8_0.mainPanel, var_8_12, var_0_7, "effect_loop", 5):xy(var_8_10.width / 2 - var_8_11.width / 2 + 210, var_8_10.height / 2 + var_8_11.height / 2 - 150)
	end

	var_8_8:addPlay("effect_loop")
	var_8_8:visible(arg_8_1)
end

function var_0_1.initModel(arg_10_0)
	local var_10_0 = gGameModel.union_fight:getIdler("union_info")

	idlereasy.when(var_10_0, function(arg_11_0, arg_11_1)
		arg_10_0.roles = arg_11_1.top8_deploy.roles
		arg_10_0.rolesInfo = arg_11_1.top8_deploy.role_info
		arg_10_0.enemyUnion = arg_11_1.top8_enemy_union
		arg_10_0.unionInfo = arg_11_1

		local var_11_0 = arg_10_0.battleInfoPanel:multiget("note1", "text1", "note2", "text2")
		local var_11_1 = gLanguageCsv.emptyInfo
		local var_11_2 = arg_11_1.cur_point
		local var_11_3 = arg_11_1.cur_rank

		if not arg_10_0.isInclude then
			var_11_3 = gLanguageCsv.unionFightNotInFinal
		else
			var_11_3 = var_11_3 == 0 and var_11_1 or var_11_3
		end

		var_11_0.text1:text(var_11_2)
		var_11_0.text2:text(var_11_3)
		adapt.oneLinePos(var_11_0.note1, {
			var_11_0.text1,
			var_11_0.note2,
			var_11_0.text2
		}, {
			cc.p(10, 0),
			cc.p(30, 0),
			cc.p(10, 0)
		})
	end)

	local var_10_1 = gGameModel.role:read("id")
	local var_10_2 = gGameModel.union:read("chairman_db_id")
	local var_10_3 = gGameModel.union:read("vice_chairmans")

	if not (var_10_1 == var_10_2 or var_10_3[var_10_1]) then
		arg_10_0.btnAssign:get("text"):text(gLanguageCsv.unionFightCheckBattleAssign)
	end
end

function var_0_1.getPrepareStateAndTime(arg_12_0)
	local var_12_0 = gGameModel.union_fight:read("next_round_battle_time") or 0
	local var_12_1 = gGameModel.union_fight:read("next_round_prepare_time") or 0
	local var_12_2 = time.getTimestamp(time.getNowDate())
	local var_12_3

	if var_12_2 <= var_12_0 then
		if arg_12_0.isInBattle then
			arg_12_0.curState:set(var_0_2.prepare)
		end

		arg_12_0.isInBattle = false
		var_12_3 = var_12_0
	elseif var_12_2 <= var_12_1 then
		if not arg_12_0.isInBattle then
			arg_12_0.curState:set(var_0_2.fighting)
		end

		arg_12_0.isInBattle = true
		var_12_3 = var_12_1
	else
		arg_12_0.isInBattle = false
		var_12_3 = var_12_2
	end

	local var_12_4 = arg_12_0.isInBattle and gLanguageCsv.inBattle or gLanguageCsv.inPrepare

	arg_12_0:setTestNote(1, var_12_4)

	return var_12_3 - var_12_2
end

function var_0_1.startTimeLoop(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if arg_13_0.inTimeLoop == arg_13_4 then
		return
	end

	local var_13_0 = 3181536

	if arg_13_0.isEnd then
		arg_13_0:enableSchedule():unSchedule(var_13_0)

		return
	end

	arg_13_0.inTimeLoop = arg_13_4

	arg_13_0:enableSchedule():unSchedule(var_13_0)

	if arg_13_3 then
		arg_13_3(arg_13_1)
	end

	arg_13_0:enableSchedule():schedule(function(arg_14_0)
		if arg_13_0.isEnd then
			arg_13_0:enableSchedule():unSchedule(var_13_0)

			return
		end

		if gGameModel.union_fight:read("round") ~= "battle" then
			return
		end

		if arg_13_3 then
			arg_13_3(arg_13_1)
		end

		arg_13_1 = arg_13_1 - 1

		if arg_13_1 < 0 then
			if arg_13_2 then
				arg_13_2()
			end

			arg_13_0.inTimeLoop = nil

			arg_13_0:enableSchedule():unSchedule(var_13_0)
		end
	end, 1, 0, var_13_0)
end

function var_0_1.checkCurBattleOver(arg_15_0)
	local var_15_0 = arg_15_0.unionInfo
	local var_15_1 = var_15_0.top8_enemy_union.top8_round_key
	local var_15_2 = var_15_0.top8_round_key
	local var_15_3 = var_15_2 .. var_15_1

	if tonumber(var_15_1) < tonumber(var_15_2) then
		var_15_3 = var_15_1 .. var_15_2
	end

	local var_15_4 = tonumber(var_15_3)
	local var_15_5 = gGameModel.union_fight:read("top8_vs_info") or {}

	if var_15_5[var_15_4] then
		arg_15_0.curBattleOver = true

		local var_15_6 = var_15_5[var_15_4][1]
		local var_15_7 = gGameModel.role:read("union_db_id")
		local var_15_8 = var_15_4 >= 18000000

		if var_15_6 == var_15_7 then
			if var_15_8 then
				arg_15_0:setBattleOver(true)
				arg_15_0.curState:set(var_0_2.finalWin)
			else
				arg_15_0.curState:set(var_0_2.winner)
			end
		else
			arg_15_0:setBattleOver(false)
			arg_15_0.curState:set(var_0_2.loser)
		end

		local var_15_9 = arg_15_0.unionInfo.top8_enemy_union.name

		if var_0_4 ~= var_15_9 then
			var_0_4 = var_15_9

			arg_15_0:onBtnFightListClick(nil, nil, nil, true)
		end
	else
		arg_15_0.curBattleOver = false
	end
end

function var_0_1.startBattleLoop(arg_16_0)
	if arg_16_0.inLoop then
		return
	end

	arg_16_0.inLoop = true

	local var_16_0 = 3181533
	local var_16_1 = 1
	local var_16_2 = 0

	arg_16_0:checkCurBattleOver()
	arg_16_0:enableSchedule():unSchedule(var_16_0)
	arg_16_0:enableSchedule():schedule(function(arg_17_0)
		if arg_16_0.isEnd then
			arg_16_0:enableSchedule():unSchedule(var_16_0)

			return
		end

		if gGameModel.union_fight:read("round") ~= "battle" then
			return
		end

		if arg_16_0.isInBattle then
			arg_16_0:startTimeLoop(arg_16_0:getPrepareStateAndTime(), function()
				arg_16_0.refreshHandler()
			end, function(arg_19_0)
				var_16_2 = var_16_2 + 1

				if not arg_16_0.curBattleOver and var_16_2 >= 5 then
					var_16_2 = 0

					arg_16_0.refreshHandler(function()
						arg_16_0:checkCurBattleOver()
					end)
				elseif arg_16_0.curBattleOver then
					local var_19_0 = time.getCutDown(arg_19_0)

					arg_16_0:setTestNote(2, string.format(gLanguageCsv.unionFightFinalBattleWinTip, var_19_0.str))
				end
			end, "inBattleLoop")
		else
			arg_16_0.curBattleOver = false

			arg_16_0:startTimeLoop(arg_16_0:getPrepareStateAndTime() + 1, function()
				arg_16_0.refreshHandler()
			end, function(arg_22_0)
				local var_22_0 = time.getCutDown(arg_22_0)

				arg_16_0:setTestNote(2, string.format(gLanguageCsv.prepareTime, var_22_0.str))
			end, "inPrepareLoop")
		end
	end, var_16_1, 0, var_16_0)
end

function var_0_1.onBtnRangeClick(arg_23_0)
	gGameApp:requestServer("/game/union/fight/battle/main", function(arg_24_0)
		gGameUI:stackUI("city.union.union_fight.top8_info_view", nil, {
			clickClose = false
		})
	end)
end

function var_0_1.setTestNote(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0.isEnd then
		return
	end

	arg_25_0.mainPanel:get("textNote" .. arg_25_1):text(arg_25_2)
end

function var_0_1.onBtnFightListClick(arg_26_0)
	local var_26_0 = arg_26_0.unionInfo
	local var_26_1 = var_26_0.top8_enemy_union
	local var_26_2 = var_26_1.top8_round_key
	local var_26_3 = var_26_0.top8_round_key
	local var_26_4 = var_26_3 .. var_26_2

	if tonumber(var_26_2) < tonumber(var_26_3) then
		var_26_4 = var_26_2 .. var_26_3
	end

	local var_26_5 = tonumber(var_26_4)

	gGameApp:requestServer("/game/union/fight/top8/round/results", function(arg_27_0)
		local var_27_0 = gGameModel.union_fight:read("top8_vs_info") or {}
		local var_27_1 = gGameModel.union_fight:read("round_results")
		local var_27_2 = gGameModel.role:read("union_db_id")
		local var_27_3, var_27_4 = next(var_27_1)
		local var_27_5 = var_27_0[var_26_5]

		if not var_27_3 or not var_27_5 then
			gGameUI:showTip(gLanguageCsv.notStartBattle)

			return
		end

		local var_27_6 = var_27_5[1]
		local var_27_7 = {
			left = {
				id = var_27_2,
				name = gGameModel.union:read("name"),
				icon = gGameModel.union:read("logo"),
				level = gGameModel.union:read("level"),
				isWin = var_27_6 == var_27_2
			},
			right = {
				id = var_26_1.id,
				name = var_26_1.name,
				icon = var_26_1.logo,
				level = var_26_1.level,
				isWin = var_27_6 == var_26_1.union_id
			}
		}

		arg_26_0.dialogHandler("city.union.union_fight.fighting_list.js", var_27_4, var_27_7)
	end, var_0_3[tonumber(var_26_5)])
end

function var_0_1.isAllCardDie(arg_28_0, arg_28_1)
	for iter_28_0, iter_28_1 in ipairs(arg_28_1) do
		for iter_28_2, iter_28_3 in pairs(iter_28_1.cards) do
			if iter_28_3[3] > 0 then
				return false
			end
		end
	end

	return true
end

function var_0_1.onBtnAssignClick(arg_29_0)
	local var_29_0 = 0

	for iter_29_0, iter_29_1 in ipairs(arg_29_0.roles) do
		if not arg_29_0:isAllCardDie(arg_29_0.rolesInfo[iter_29_1].troops) then
			var_29_0 = var_29_0 + 1
		end
	end

	if arg_29_0.isInBattle then
		gGameUI:showTip(gLanguageCsv.isFighttingNotShow)

		return
	end

	if var_29_0 == 0 then
		gGameUI:showTip(gLanguageCsv.myTeamAllDie)

		return
	end

	gGameUI:stackUI("city.union.union_fight.assign", nil, nil, {
		roles = arg_29_0.roles,
		rolesInfo = arg_29_0.rolesInfo
	})
end

function var_0_1.setBattleOver(arg_30_0, arg_30_1)
	if arg_30_1 then
		arg_30_0:setTestNote(2, gLanguageCsv.unionFightBattleFinalWinner)
	else
		arg_30_0:setTestNote(2, gLanguageCsv.unionFightFinalBattleLoseTip)
	end

	arg_30_0.isEnd = true
end

return var_0_1
