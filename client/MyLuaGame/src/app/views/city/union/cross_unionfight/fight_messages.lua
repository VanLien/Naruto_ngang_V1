local var_0_0 = require("app.views.city.union.cross_unionfight.view")
local var_0_1 = require("app.views.city.union.cross_unionfight.tools")
local var_0_2 = 50
local var_0_3 = class("FightMessageView", cc.load("mvc").ViewBase)

var_0_3.RESOURCE_FILENAME = "cross_union_fight.json"
var_0_3.RESOURCE_BINDING = {
	["centerPanel.competition"] = "competition",
	["centerPanel.item"] = "item",
	["centerPanel.slider"] = "slider",
	["centerPanel.duckPanel"] = "duckPanel",
	leftPanel = "leftPanel",
	["centerPanel.list"] = "fightList",
	["leftPanel.tabItem"] = "tabItem",
	centerPanel = "centerPanel",
	integral = "integral",
	["centerPanel.upItem"] = "upItem",
	["centerPanel.404Panel"] = "404Panel",
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				betType = bindHelper.self("betType"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()

						var_1_2:get("txt2"):text(arg_1_3.subName)
					end

					adapt.setTextScaleWithWidth(var_1_2:get("txt"), arg_1_3.name, 300)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	["centerPanel.item.panel.left.team"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(139, 119, 84, 255)
				}
			}
		}
	},
	["centerPanel.item.panel.right.team"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(139, 119, 84, 255)
				}
			}
		}
	},
	["centerPanel.item.panel.left.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["centerPanel.item.panel.right.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["centerPanel.item.panel.left.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["centerPanel.item.panel.right.level"] = {
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
	["centerPanel.unionZB"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("unionBattlefieldReport")
			}
		}
	},
	["centerPanel.roleZB"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("roleBattlefieldReport")
			}
		}
	},
	["centerPanel.unionZB.choose"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("unionChoose")
		}
	},
	["centerPanel.roleZB.choose"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("roleChoose")
		}
	},
	["integral.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("unionInfoView")
			}
		}
	},
	unionInfo = {
		varname = "unionInfo",
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("closeUnionInfoView")
			}
		}
	},
	bg = {
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("closeUnionInfoView")
			}
		}
	}
}

function var_0_3.pushItemInitialize(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0.fightList:show()

	local var_2_0 = arg_2_0.item:clone():show()

	var_2_0.itemSign = arg_2_1.itemSign
	var_2_0.roundTime = arg_2_1.roundTime
	var_2_0.roundTimeSign = arg_2_1.roundTimeSign

	if arg_2_2 then
		arg_2_0.fightList:insertCustomItem(var_2_0, 0)
		var_0_1.onInitItem(arg_2_0.fightList, var_2_0, arg_2_1, arg_2_0, arg_2_3)
		arg_2_0.fightList:getInnerContainer():setPositionY(arg_2_0.listY)
	else
		arg_2_0.fightList:pushBackCustomItem(var_2_0)
		var_0_1.onInitItem(arg_2_0.fightList, var_2_0, arg_2_1, arg_2_0, arg_2_3)

		if (arg_2_0.await or arg_2_4) and var_2_0 and var_2_0.roundTime == "roundCountDown" and not var_2_0.roundTimeSign then
			var_2_0.roundTimeSign = true

			var_2_0:get("round.time"):hide()
			var_2_0:get("round.over"):hide()

			local var_2_1 = var_2_0:get("round.round"):getString()
			local var_2_2 = gLanguageCsv.stateFighting .. gLanguageCsv.ltaskRunning .. ".."

			var_2_0:get("round.round"):text(var_2_1 .. var_2_2)
		end
	end
end

function var_0_3.onCreate(arg_3_0, arg_3_1)
	arg_3_0:initModel(arg_3_1)
	arg_3_0:enableSchedule()
	arg_3_0:survivalNumber()
	arg_3_0.fightList:removeAllChildren()

	local var_3_0 = {
		{
			select = false,
			subName = "Preliminary",
			name = gLanguageCsv.sixMankindConstruction
		},
		{
			select = false,
			subName = "Consumable",
			name = gLanguageCsv.fourMankindConstruction
		},
		{
			select = false,
			subName = "Material",
			name = gLanguageCsv.oneMankindConstruction
		}
	}

	arg_3_0.tabDatas = idlers.newWithMap(var_3_0)
	arg_3_0.betType = idler.new(1)

	arg_3_0.betType:addListener(function(arg_4_0, arg_4_1)
		arg_3_0.tabDatas:atproxy(arg_4_1).select = false
		arg_3_0.tabDatas:atproxy(arg_4_0).select = true
	end)

	arg_3_0.unionChoose = idler.new(false)
	arg_3_0.roleChoose = idler.new(false)

	idlereasy.when(arg_3_0.status, function(arg_5_0, arg_5_1)
		if arg_5_1 == "preStart" or arg_5_1 == "topStart" then
			arg_3_0:updataBattleReport(1)
		elseif (arg_5_1 == "preBattle" or arg_5_1 == "topBattle") and not arg_3_0.listY then
			arg_3_0.fightList:removeAllChildren()
		end

		local var_5_0 = var_0_1.getNowMatch(arg_5_1) == 1 and gLanguageCsv.preliminary or gLanguageCsv.finalMatch

		arg_3_0.competition:text(var_5_0)
	end)
	idlereasy.any({
		arg_3_0.unionChoose,
		arg_3_0.roleChoose,
		arg_3_0.betType
	}, function()
		local var_6_0 = arg_3_0.unionChoose:read()
		local var_6_1 = arg_3_0.roleChoose:read()
		local var_6_2 = arg_3_0.betType:read()

		arg_3_0:closeUnionInfoView()

		if not arg_3_0.firstTime then
			return
		end

		if not arg_3_0.gameData or not arg_3_0.gameData[var_6_2] then
			return
		end

		local var_6_3 = arg_3_0.gameData[var_6_2]

		arg_3_0:operationbattleDataView(var_6_0, var_6_1, var_6_3, arg_3_0.finish)
	end)
end

function var_0_3.operationbattleDataView(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_0.fightList:setScrollBarEnabled(false)
	arg_7_0.duckPanel:hide()
	arg_7_0:unSchedule(var_0_2)
	arg_7_0:enableAsyncload()

	local var_7_0 = arg_7_0.status:read()
	local var_7_1 = arg_7_0.model.battleRound
	local var_7_2 = 0
	local var_7_3 = false
	local var_7_4 = arg_7_0.condition
	local var_7_5 = 0
	local var_7_6 = false
	local var_7_7 = {}
	local var_7_8 = 0

	arg_7_0.fightList:jumpToPercentVertical(0)

	if var_7_1 > 1 then
		for iter_7_0, iter_7_1 in ipairs(arg_7_3) do
			if var_7_1 > iter_7_1.round or arg_7_4 then
				if var_0_1.comparison({
					arg_7_1,
					arg_7_2
				}, iter_7_1, arg_7_0.unionId, arg_7_0.roleId) then
					var_7_6 = true

					if var_7_5 ~= iter_7_1.round then
						var_7_5 = iter_7_1.round
						var_7_2 = var_7_2 + 1

						table.insert(var_7_7, {
							roundTime = true,
							numRoundBattle = true,
							round = iter_7_1.round
						})
					end

					table.insert(var_7_7, iter_7_1)

					var_7_2 = var_7_2 + 1
				end
			elseif var_7_8 <= iter_7_1.round then
				var_7_8 = iter_7_1.round
			end
		end
	end

	local function var_7_9()
		for iter_8_0, iter_8_1 in ipairs(var_7_7) do
			arg_7_0:pushItemInitialize(iter_8_1, false, var_7_0)
			coroutine.yield()
		end
	end

	local function var_7_10()
		if var_7_1 > 1 then
			arg_7_0.insertIdx = var_7_1 - 1
		end

		local var_9_0 = false

		if var_7_2 == 0 or var_7_1 - 1 > var_7_8 and var_7_2 > 0 then
			var_9_0 = true
		end

		if var_7_6 or var_7_1 == 1 then
			if arg_7_4 then
				local var_9_1 = arg_7_0.unionAlive > 0 and gLanguageCsv.crossUnionUnionBattleSucceed or gLanguageCsv.crossUnionUnionBattleFailure

				arg_7_0:pushItemInitialize({
					time = true,
					itemUp = true,
					title = var_9_1
				}, false, var_7_0)
			elseif arg_7_0.unionAlive <= 0 then
				arg_7_0:pushItemInitialize({
					time = true,
					itemUp = true,
					itemSign = true,
					title = gLanguageCsv.crossUnionUnionBattleFailure
				}, false, var_7_0)
			elseif var_7_4 then
				arg_7_0:pushItemInitialize({
					time = true,
					itemUp = true,
					itemSign = true,
					title = gLanguageCsv.crossUnionBattleFailure
				}, false, var_7_0)
			else
				local var_9_2 = var_7_1 <= 1 and 1 or var_7_1

				arg_7_0:pushItemInitialize({
					itemSign = true,
					anima = true
				}, false, var_7_0)
				arg_7_0:pushItemInitialize({
					itemSign = true,
					roundTime = "roundCountDown",
					round = var_9_2
				}, false, var_7_0, var_9_0)
			end
		end

		if arg_7_0.fightList:getChildrenCount() == 0 then
			if not arg_7_4 then
				arg_7_0:pushItemInitialize({
					itemSign = true,
					anima = true
				}, false, var_7_0)
				arg_7_0:pushItemInitialize({
					round = 1,
					itemSign = true,
					roundTime = "roundCountDown"
				}, false, var_7_0, var_9_0)
			else
				arg_7_0.slider:hide()
				arg_7_0.fightList:setScrollBarEnabled(false)
				arg_7_0.duckPanel:show()
				arg_7_0.duckPanel:get("txt"):text(gLanguageCsv.battleReportNotData)
			end
		else
			arg_7_0.duckPanel:hide()
		end
	end

	arg_7_0.fightList:removeAllChildren()
	var_7_10()
	arg_7_0:enableAsyncload():asyncFor(var_7_9, nil, 4)
end

function var_0_3.battleDataView(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	arg_10_0.duckPanel:hide()
	arg_10_0:enableAsyncload()

	local var_10_0 = false

	if arg_10_0.await then
		for iter_10_0 = 1, 3 do
			local var_10_1 = arg_10_0.fightList:getItem(iter_10_0)

			if var_10_1 and var_10_1.roundTime == "roundCountDown" and not var_10_1.roundTimeSign then
				var_10_1.roundTimeSign = true

				var_10_1:get("round.time"):hide()
				var_10_1:get("round.over"):hide()

				local var_10_2 = var_10_1:get("round.round"):getString()
				local var_10_3 = gLanguageCsv.stateFighting .. gLanguageCsv.ltaskRunning .. ".."

				var_10_1:get("round.round"):text(var_10_2 .. var_10_3)

				var_10_0 = true
			end
		end
	end

	if var_10_0 then
		return
	end

	local var_10_4 = arg_10_0.status:read()
	local var_10_5 = arg_10_0.model.battleRound
	local var_10_6 = 0
	local var_10_7 = false
	local var_10_8 = arg_10_0.condition
	local var_10_9 = 0
	local var_10_10 = false

	if var_10_5 > 1 then
		for iter_10_1, iter_10_2 in ipairs(arg_10_3) do
			if var_10_5 > iter_10_2.round and iter_10_2.round > arg_10_0.insertIdx and var_0_1.comparison({
				arg_10_1,
				arg_10_2
			}, iter_10_2, arg_10_0.unionId, arg_10_0.roleId) then
				var_10_10 = true

				arg_10_0:pushItemInitialize(iter_10_2, arg_10_5, var_10_4)

				var_10_6 = var_10_6 + 1

				if var_10_9 < iter_10_2.round then
					var_10_9 = iter_10_2.round
				end
			end
		end

		arg_10_0.insertIdx = var_10_5 - 1
	end

	if var_10_6 > 0 then
		arg_10_0:pushItemInitialize({
			roundTime = true,
			numRoundBattle = true,
			round = var_10_9
		}, arg_10_5, var_10_4)

		var_10_6 = var_10_6 + 1
	end

	if var_10_10 or var_10_5 == 1 then
		arg_10_0:unSchedule(var_0_2)

		if arg_10_4 then
			local var_10_11 = arg_10_0.unionAlive > 0 and gLanguageCsv.crossUnionUnionBattleSucceed or gLanguageCsv.crossUnionUnionBattleFailure

			arg_10_0:pushItemInitialize({
				time = true,
				itemUp = true,
				title = var_10_11
			}, arg_10_5, var_10_4)

			var_10_6 = var_10_6 + 1
		elseif arg_10_0.unionAlive <= 0 then
			arg_10_0:pushItemInitialize({
				time = true,
				itemUp = true,
				itemSign = true,
				title = gLanguageCsv.crossUnionUnionBattleFailure
			}, arg_10_5, var_10_4)

			var_10_6 = var_10_6 + 1
		elseif var_10_8 then
			arg_10_0:pushItemInitialize({
				time = true,
				itemUp = true,
				itemSign = true,
				title = gLanguageCsv.crossUnionBattleFailure
			}, arg_10_5, var_10_4)

			var_10_6 = var_10_6 + 1
		else
			local var_10_12 = false

			if arg_10_5 and var_10_5 ~= 1 then
				local var_10_13 = true
			end

			arg_10_0:pushItemInitialize({
				itemSign = true,
				roundTime = "roundCountDown",
				round = var_10_5
			}, true, var_10_4)
			arg_10_0:pushItemInitialize({
				itemSign = true,
				anima = true
			}, true, var_10_4)

			var_10_6 = var_10_6 + 2
		end
	end

	if var_10_6 > 0 and var_10_5 > 1 and arg_10_5 and arg_10_0.fightList:getChildrenCount() > 0 then
		arg_10_0.fightList:scrollToPercentVertical(0, 2, true)
		performWithDelay(arg_10_0, function()
			local var_11_0 = 0

			for iter_11_0 = 1, 3 do
				if arg_10_0.fightList:getItem(var_10_6) and arg_10_0.fightList:getItem(var_10_6).itemSign then
					arg_10_0.fightList:removeItem(var_10_6)
				end
			end
		end, 1)
	end

	if arg_10_0.fightList:getChildrenCount() == 0 then
		if not arg_10_4 then
			arg_10_0:pushItemInitialize({
				itemSign = true,
				anima = true
			}, false, var_10_4)
			arg_10_0:pushItemInitialize({
				round = 1,
				itemSign = true,
				roundTime = "roundCountDown"
			}, false, var_10_4)
		else
			arg_10_0.slider:hide()
			arg_10_0.fightList:setScrollBarEnabled(false)
			arg_10_0.duckPanel:show()
			arg_10_0.duckPanel:get("txt"):text(gLanguageCsv.battleReportNotData)
		end
	else
		arg_10_0.duckPanel:hide()
	end
end

function var_0_3.initModel(arg_12_0, arg_12_1)
	arg_12_0.model = arg_12_1
	arg_12_0.unionClassifyData = gGameModel.cross_union_fight:read("pre_battle_groups")
	arg_12_0.top_battle_groups = gGameModel.cross_union_fight:read("top_battle_groups")
	arg_12_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_12_0.round = idler.new("time")
	arg_12_0.unionId = gGameModel.role:read("union_db_id")
	arg_12_0.roles = gGameModel.cross_union_fight:getIdler("roles")
	arg_12_0.roleId = gGameModel.role:read("id")
	arg_12_0.roleLv = gGameModel.role:getIdler("level")
	arg_12_0.unionPoint = 0
	arg_12_0.unionAll = arg_12_0.model.unionAll
	arg_12_0.unionAlive = arg_12_0.unionAll
	arg_12_0.deleteItem = {}
	arg_12_0.insertIdx = 0
	arg_12_0.delectBattleId = {}
	arg_12_0.firstTime = false
end

function var_0_3.onTabItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0.betType:set(arg_13_2)
end

function var_0_3.unionBattlefieldReport(arg_14_0)
	arg_14_0.unionChoose:set(not arg_14_0.unionChoose:read())
	arg_14_0.roleChoose:set(false)
end

function var_0_3.roleBattlefieldReport(arg_15_0)
	arg_15_0.unionChoose:set(false)
	arg_15_0.roleChoose:set(not arg_15_0.roleChoose:read())
end

function var_0_3.updataBattleReport(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	if arg_16_1 == 1 then
		local var_16_0 = arg_16_0.status:read()

		arg_16_0:pushItemInitialize({
			time = true,
			itemUp = false
		}, false, var_16_0)
		arg_16_0:pushItemInitialize({
			time = true,
			roundTime = "countDown",
			itemUp = true
		}, false, var_16_0)
		arg_16_0:survivalNumber()
	else
		arg_16_0.model = arg_16_5

		local var_16_1 = arg_16_0.fightList:getInnerContainer()

		arg_16_0.gameData = table.deepcopy(arg_16_3)
		arg_16_0.listY = var_16_1:getPositionY()

		for iter_16_0 = 1, 3 do
			table.sort(arg_16_0.gameData[iter_16_0], function(arg_17_0, arg_17_1)
				return arg_17_0.round > arg_17_1.round
			end)
		end

		arg_16_0.await = arg_16_4
		arg_16_0.model.await = arg_16_4
		arg_16_0.finish = arg_16_2

		local var_16_2 = arg_16_0.unionChoose:read()
		local var_16_3 = arg_16_0.roleChoose:read()
		local var_16_4 = arg_16_0.betType:read()

		if arg_16_0.model.battleRound > 3 and not arg_16_0.firstTime then
			local var_16_5 = arg_16_0.gameData[var_16_4]

			arg_16_0:operationbattleDataView(var_16_2, var_16_3, var_16_5, arg_16_0.finish)

			arg_16_0.firstTime = true

			return
		end

		arg_16_0.firstTime = true

		arg_16_0:survivalNumber(var_16_2, var_16_3)

		if arg_16_0.gameData and arg_16_0.gameData[var_16_4] then
			arg_16_0:battleDataView(var_16_2, var_16_3, arg_16_0.gameData[var_16_4], arg_16_2, true)
		end
	end
end

function var_0_3.survivalNumber(arg_18_0)
	arg_18_0.model:getUnionInfo(false, arg_18_0.model.squad)

	if not itertools.isempty(arg_18_0.model.unionState[arg_18_0.unionId]) then
		arg_18_0.unionAlive, arg_18_0.unionPoint = arg_18_0.model.unionState[arg_18_0.unionId][1], arg_18_0.model.unionState[arg_18_0.unionId][2]
	end

	arg_18_0.condition = arg_18_0.model.condition

	arg_18_0.integral:get("num"):text(arg_18_0.unionAlive .. "/")
	arg_18_0.integral:get("numAll"):text(arg_18_0.unionAll)
	adapt.oneLinePos(arg_18_0.integral:get("titile1"), {
		arg_18_0.integral:get("num"),
		arg_18_0.integral:get("numAll")
	})
	arg_18_0.integral:get("integral"):text(arg_18_0.unionPoint)
	adapt.oneLinePos(arg_18_0.integral:get("titile2"), arg_18_0.integral:get("integral"))
end

function var_0_3.closeUnionInfoView(arg_19_0)
	arg_19_0.unionInfo:hide()
end

function var_0_3.unionInfoView(arg_20_0)
	if not arg_20_0.model:notRequireBattle() or arg_20_0.unionInfo:isVisible() then
		return
	end

	arg_20_0.unionInfo:show()

	local var_20_0 = var_0_1.getNowMatch(arg_20_0.status:read())
	local var_20_1

	if var_20_0 == 1 then
		var_20_1 = arg_20_0.unionClassifyData[arg_20_0.model.squad]
	else
		var_20_1 = arg_20_0.top_battle_groups
	end

	for iter_20_0 = 1, 4 do
		if var_20_1 and var_20_1[iter_20_0] then
			local var_20_2 = var_20_1[iter_20_0].union_db_id
			local var_20_3 = 0
			local var_20_4 = var_20_1[iter_20_0].signs_count

			if not itertools.isempty(arg_20_0.model.unionState[var_20_2]) then
				arg_20_0.unionAlive, arg_20_0.unionPoint = arg_20_0.model.unionState[var_20_2][1], arg_20_0.model.unionState[var_20_2][2]

				if arg_20_0.model.unionState[var_20_2][1] then
					var_20_4 = arg_20_0.model.unionState[var_20_2][1]
				end

				if arg_20_0.model.unionState[var_20_2][2] then
					var_20_3 = arg_20_0.model.unionState[var_20_2][2]
				end
			end

			local var_20_5 = arg_20_0.unionInfo:get("union" .. iter_20_0):show()

			var_20_5:get("name"):text(var_20_1[iter_20_0].union_name)
			adapt.setTextScaleWithWidth(var_20_5:get("name"), nil, 300)
			var_20_5:get("alive"):text(var_20_4 .. "/")
			var_20_5:get("aliveAll"):text(var_20_1[iter_20_0].signs_count)
			adapt.oneLinePos(var_20_5:get("alive"), var_20_5:get("aliveAll"))
			var_20_5:get("point"):text(var_20_3)
		end
	end
end

function var_0_3.battleReport(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = "/game/cross/union/fight/playrecord/get"

	gGameModel:playRecordBattle(arg_21_3.play_id, arg_21_3.cross_key, var_21_0, 0, nil)
end

return var_0_3
