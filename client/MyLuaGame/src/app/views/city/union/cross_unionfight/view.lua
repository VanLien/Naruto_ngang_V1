local var_0_0 = require("app.views.city.union.cross_unionfight.tools")
local var_0_1 = require("app.views.city.union.cross_unionfight.model")
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("CrossUnionView", var_0_2)

var_0_3.RESOURCE_FILENAME = "cross_union.json"
var_0_3.RESOURCE_BINDING = {
	["areaClothing.bg"] = "bg",
	["prepare.item"] = "item",
	["areaClothing.subList"] = "subList",
	gameOver = "gameOver",
	titlePanel = "titlePanel",
	["prepare.itemIcon"] = "itemIcon",
	rightBtn = "rightBtn",
	combat = "combat",
	mask = "mask",
	battle = "battle",
	["areaClothing.item"] = "arenaItem",
	prepare = "prepare",
	areaClothing = "areaClothing",
	["panel.name"] = "name",
	["areaClothing.title1"] = "title1",
	["areaClothing.title2"] = "title2",
	integralRank = {
		varname = "integralRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("unionIntegral")
			}
		}
	},
	embattle = {
		varname = "embattle",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("battlefieldZRView")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "crossUnionFight",
					onNode = function(arg_1_0)
						arg_1_0:xy(340, 140)
					end
				}
			}
		}
	},
	["rightBtn.rule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("rule")
			}
		}
	},
	["rightBtn.rule.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.COLORS.NORMAL.WHITE
					}
				}
			}
		}
	},
	["rightBtn.rankReward"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("rankReward")
			}
		}
	},
	["rightBtn.rankReward.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.COLORS.NORMAL.WHITE
					}
				}
			}
		}
	},
	["rightBtn.record"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("combatRecord")
			}
		}
	},
	["rightBtn.record.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.COLORS.NORMAL.WHITE
					}
				}
			}
		}
	},
	["rightBtn.guessing"] = {
		varname = "guessing",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("guessingView")
			}
		}
	},
	["rightBtn.guessing.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.COLORS.NORMAL.WHITE
					}
				}
			}
		}
	},
	["rightBtn.combat"] = {
		varname = "battlegroundNode",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("combatDistribution")
			}
		}
	},
	["rightBtn.combat.name"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 3,
						color = ui.COLORS.NORMAL.WHITE
					}
				}
			}
		}
	},
	["combat.battlefield"] = {
		varname = "mainBattlefield",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("battlefield")
			}
		}
	},
	["combat.battlefieldZR"] = {
		varname = "battlefieldZR",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("battlefieldZRView")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "crossUnionFight",
					onNode = function(arg_2_0)
						arg_2_0:xy(340, 140)
					end
				}
			}
		}
	},
	["prepare.list"] = {
		varname = "prepareList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("quickDatas"),
				dataName = bindHelper.self("leftListName"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("name", "list", "itemIcon")

					var_3_0.name:text(arg_3_0.dataName[arg_3_2])
					var_3_0.list:removeAllChildren()
					var_3_0.itemIcon:hide()
					var_3_0.list:setScrollBarEnabled(false)

					for iter_3_0 = 1, 4 do
						local var_3_1 = var_3_0.itemIcon:clone():show()

						var_3_0.list:pushBackCustomItem(var_3_1)

						if arg_3_3[iter_3_0] then
							var_3_1:get("name"):text(arg_3_3[iter_3_0].union_name)
							adapt.setTextScaleWithWidth(var_3_1:get("name"), nil, 300)
							var_3_1:get("icon"):texture(csv.union.union_logo[arg_3_3[iter_3_0].union_logo].icon)
							var_3_1:get("title"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_3_3[iter_3_0].server_key, nil)))
							var_3_1:get("num"):text(arg_3_3[iter_3_0].signs_count)
							adapt.oneLinePos(var_3_1:get("number"), var_3_1:get("num"))
						else
							var_3_1:get("icon"):hide()
							var_3_1:get("name"):hide()
							var_3_1:get("title"):hide()
							var_3_1:get("number"):hide()
							var_3_1:get("num"):hide()
							var_3_1:get("noBg"):show()
							var_3_1:get("no"):show()
						end
					end
				end
			}
		}
	},
	["areaClothing.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("servers"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("arenaItem"),
				bg = bindHelper.self("bg"),
				title1 = bindHelper.self("title1"),
				title2 = bindHelper.self("title2"),
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("server"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_4_3, nil)))
				end,
				onAfterBuild = function(arg_5_0)
					local var_5_0 = arg_5_0:getChildrenCount()

					if var_5_0 == 1 then
						for iter_5_0, iter_5_1 in pairs(arg_5_0:getChildren()) do
							iter_5_1:setItemAlignCenter()
						end

						arg_5_0:setItemAlignCenter()
					else
						local var_5_1 = arg_5_0.item:height()

						arg_5_0:height(var_5_1 * var_5_0)

						local var_5_2 = var_5_1 / 2 * (var_5_0 - 1)

						arg_5_0:y(127 - var_5_2)
						arg_5_0.bg:height(122 + var_5_2 * 2)
						arg_5_0.title1:y(290 + var_5_2)
						arg_5_0.title2:y(55 - var_5_2)
					end
				end
			}
		}
	},
	["battle.final"] = {
		varname = "final",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("finalView")
			}
		}
	},
	["battle.preliminary"] = {
		varname = "preliminary",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("preliminaryView")
			}
		}
	},
	bg = {
		varname = "viewBg",
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("closeUnionInfo")
			}
		}
	}
}

function var_0_3.onCreate(arg_6_0, arg_6_1)
	arg_6_0.cb = arg_6_1
	arg_6_0.isFirst = true
	arg_6_0.mainBattle = {}
	arg_6_0.subView = {}
	arg_6_0.topuiView = gGameUI.topuiManager:createView("title", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "Building war",
		title = gLanguageCsv.ministryHouseBattle
	})
	arg_6_0.rankData = nil

	arg_6_0:initModel()
	arg_6_0:enableSchedule()

	local var_6_0 = time.getNowDate().wday - 1

	arg_6_0:unSchedule(10)
	arg_6_0:unSchedule(20)
	arg_6_0.combat:hide()
	idlereasy.when(arg_6_0.status, function(arg_7_0, arg_7_1)
		arg_6_0:onUpdateStatus(arg_7_1)
	end)

	local var_6_1 = 0

	idlereasy.when(arg_6_0.automatic, function(arg_8_0, arg_8_1)
		if arg_8_1 == 2 and time.getTime() - var_6_1 > 10 then
			var_6_1 = time.getTime()

			gGameApp:requestServer("/game/cross/union/fight/main")
		end
	end)

	arg_6_0.isFirst = false

	arg_6_0:schedule(function()
		local var_9_0 = arg_6_0.status:read()

		if var_9_0 == "closed" then
			return
		end

		if var_0_0.getNextStateTime(var_9_0, arg_6_0.time) <= 0 and time.getTime() - var_6_1 > 10 then
			var_6_1 = time.getTime()

			gGameApp:requestServer("/game/cross/union/fight/main")
		end
	end, 1, 1, 100)
end

function var_0_3.onUpdateStatus(arg_10_0, arg_10_1)
	arg_10_0.saveStat = arg_10_1

	if arg_10_1 ~= "closed" then
		arg_10_0:unionClassifyDataView(arg_10_1)
	end

	if arg_10_1 == "prePrepare" then
		arg_10_0.model.finish = true

		arg_10_0.prepare:hide()
		arg_10_0:preparation()
		arg_10_0:addAnimationView(true)
	elseif arg_10_1 == "preStart" then
		arg_10_0.model.finish = true

		arg_10_0:hideUselessUiView()
		arg_10_0:countDownView(arg_10_1)

		local var_10_0 = "competition"

		if arg_10_0.roles[arg_10_0.roleId] then
			arg_10_0.combat:show()

			var_10_0 = "fight_messages"
		end

		arg_10_0.roleView = var_10_0

		arg_10_0:combatStage(var_10_0)
	elseif arg_10_1 == "preBattle" then
		if arg_10_0.roles[arg_10_0.roleId] then
			arg_10_0.model.distribute = var_0_0.getDistribute(arg_10_0.roles, arg_10_0.roleId, 1)
			arg_10_0.roleView = "fight_messages"

			arg_10_0.combat:show()
			arg_10_0:timeFlow()
		else
			arg_10_0.combat:hide()

			arg_10_0.simulation = true

			arg_10_0:timeFlow()

			arg_10_0.roleView = "competition"

			arg_10_0:combatStage("competition", true)
		end
	elseif arg_10_1 == "preOver" then
		if arg_10_0:preOverView(arg_10_1) then
			return
		end

		if arg_10_0.examineBattle ~= arg_10_1 and arg_10_0.schdulelabel then
			return
		end

		if arg_10_0.roles[arg_10_0.roleId] then
			arg_10_0.model.distribute = var_0_0.getDistribute(arg_10_0.roles, arg_10_0.roleId, 1)

			arg_10_0.combat:show()

			arg_10_0.roleView = "fight_messages"
		else
			arg_10_0.combat:hide()

			arg_10_0.simulation = true
			arg_10_0.roleView = "competition"
		end

		arg_10_0:timeFlow()
	elseif arg_10_1 == "preAward" then
		arg_10_0:removeBattleView()

		arg_10_0.model.finish = true

		arg_10_0.combat:visible(arg_10_0.roles[arg_10_0.roleId] and true or false)

		arg_10_0.roleView = "competition"

		arg_10_0:combatStage("competition", not arg_10_0.roles[arg_10_0.roleId])
	elseif arg_10_1 == "topPrepare" then
		arg_10_0.model.finish = true
		arg_10_0.roleView = "competition"

		local var_10_1 = arg_10_0:whetherQualified()

		if var_10_1 then
			arg_10_0.combat:show()
		end

		arg_10_0:combatStage("competition", not var_10_1)
	elseif arg_10_1 == "topStart" then
		arg_10_0.model.finish = true

		arg_10_0:countDownView(arg_10_1)

		arg_10_0.roleView = "competition"

		local var_10_2 = false

		if arg_10_0:whetherQualified() then
			arg_10_0.roleView = "fight_messages"

			arg_10_0.combat:show()
		else
			var_10_2 = true

			arg_10_0.combat:hide()
		end

		arg_10_0:combatStage(arg_10_0.roleView, var_10_2)
	elseif arg_10_1 == "topBattle" then
		if arg_10_0:whetherQualified() then
			arg_10_0.model.distribute = var_0_0.getDistribute(arg_10_0.roles, arg_10_0.roleId, 2)
			arg_10_0.roleView = "fight_messages"

			arg_10_0.combat:show()
		else
			arg_10_0.simulation = true
			arg_10_0.roleView = "competition"
		end

		arg_10_0:timeFlow()
	elseif arg_10_1 == "topOver" then
		if arg_10_0.model.finish then
			arg_10_0:gameoverView()

			return
		end

		if arg_10_0.examineBattle ~= arg_10_1 and arg_10_0.schdulelabel then
			return
		end

		if arg_10_0:whetherQualified() then
			arg_10_0.model.distribute = var_0_0.getDistribute(arg_10_0.roles, arg_10_0.roleId, 2)

			arg_10_0.combat:show()

			arg_10_0.roleView = "fight_messages"
		else
			arg_10_0.simulation = true
			arg_10_0.topOverSign = true
			arg_10_0.roleView = "competition"
		end

		arg_10_0:timeFlow()
	elseif arg_10_1 == "closed" or arg_10_1 == "start" then
		arg_10_0.battlegroundNode:hide()

		if var_0_0.whetherCloseShowUI(arg_10_0.csv_id) then
			arg_10_0:gameoverView()
		else
			local var_10_3 = dataEasy.getCrossServiceData("crossunionfight")

			if var_10_3 then
				local var_10_4 = csv.cross.service[var_10_3]
				local var_10_5 = time.getNumTimestamp(var_10_4.date, time.getRefreshHour())

				if tonumber(var_10_4.date) == tonumber(time.getTodayStrInClock()) then
					arg_10_0:serviceArea(var_10_3)
				else
					arg_10_0:notOpenView(var_10_4)
				end
			else
				arg_10_0:notOpenView()
			end

			arg_10_0:addAnimationView()
		end
	end
end

function var_0_3.hideUselessUiView(arg_11_0)
	arg_11_0.integralRank:hide()
	arg_11_0.embattle:hide()
	arg_11_0.prepareList:show()
	arg_11_0.viewBg:show()
	arg_11_0.mask:hide()

	if arg_11_0:getResourceNode():get("bgNode") then
		arg_11_0:getResourceNode():get("bgNode"):removeSelf()
	end
end

function var_0_3.preOverView(arg_12_0, arg_12_1)
	if arg_12_0.model.finish and arg_12_1 == "preOver" then
		arg_12_0.roleView = "competition"

		arg_12_0:combatStage("competition", not arg_12_0.roles[arg_12_0.roleId])

		return true
	end

	return false
end

function var_0_3.countDownView(arg_13_0, arg_13_1)
	local var_13_0 = 33

	arg_13_0:schedule(function()
		if arg_13_0:countDown(arg_13_1) <= 0 then
			arg_13_0:unSchedule(var_13_0)
			arg_13_0.automatic:set(2, true)

			return
		end
	end, 1, 0, var_13_0)
end

function var_0_3.addAnimationView(arg_15_0, arg_15_1)
	arg_15_0.viewBg:hide()
	arg_15_0.rightBtn:hide()

	local var_15_0 = widget.addAnimation(arg_15_0:getResourceNode(), "cross_union/cbqd.skel", "effect_loop", 1):scale(2):xy(display.sizeInView.width / 2, display.sizeInView.height / 2)

	if arg_15_1 then
		local var_15_1 = display.sizeInView
		local var_15_2 = 0.5

		var_15_0:pause()

		local var_15_3 = cc.utils:captureNodeSprite(arg_15_0:getResourceNode(), cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565, var_15_2, 0, 0):scale(2):setAnchorPoint(0.5, 0.5)

		cache.setShader(var_15_3, false, "gaussian_blur"):setUniformVec3("iResolution", cc.Vertex3F(var_15_1.width, var_15_1.height, 0))
		var_15_3:xy(display.sizeInView.width / 2, display.sizeInView.height / 2):addTo(arg_15_0:getResourceNode(), 1, "bgNode")
		arg_15_0.mask:show()
		var_15_0:removeSelf()
	end

	arg_15_0.rightBtn:show()
end

function var_0_3.unionClassifyDataView(arg_16_0, arg_16_1)
	local var_16_0
	local var_16_1 = 0

	if var_0_0.getNowMatch(arg_16_1) == 2 then
		for iter_16_0, iter_16_1 in ipairs(arg_16_0.top_battle_groups or {}) do
			if iter_16_1.union_db_id == arg_16_0.unionId then
				var_16_1 = iter_16_1.signs_count

				break
			end
		end
	else
		for iter_16_2, iter_16_3 in ipairs(arg_16_0.unionClassifyData or {}) do
			for iter_16_4, iter_16_5 in ipairs(iter_16_3) do
				if iter_16_5.union_db_id == arg_16_0.unionId then
					var_16_1 = iter_16_5.signs_count
					var_16_0 = iter_16_2

					break
				end
			end
		end
	end

	arg_16_0.groupingData = {
		site = var_16_0,
		unionAll = var_16_1
	}
	arg_16_0.model.unionAll = var_16_1
end

function var_0_3.whetherQualified(arg_17_0)
	local var_17_0 = false

	if arg_17_0.roles[arg_17_0.roleId] then
		for iter_17_0, iter_17_1 in ipairs(arg_17_0.top_battle_groups) do
			if iter_17_1.union_db_id == arg_17_0.unionId then
				var_17_0 = true

				break
			end
		end
	end

	return var_17_0
end

function var_0_3.initModel(arg_18_0)
	if not arg_18_0.model then
		arg_18_0.model = var_0_1.new()
	end

	arg_18_0.unionClassifyData = gGameModel.cross_union_fight:read("pre_battle_groups")
	arg_18_0.top_battle_groups = gGameModel.cross_union_fight:read("top_battle_groups")
	arg_18_0.model.unionClassifyData = arg_18_0.unionClassifyData
	arg_18_0.model.top_battle_groups = arg_18_0.top_battle_groups

	arg_18_0.model:differentUnion()

	arg_18_0.roles = gGameModel.cross_union_fight:read("roles")
	arg_18_0.csv_id = gGameModel.cross_union_fight:read("csv_id")
	arg_18_0.time = gGameModel.cross_union_fight:read("date")
	arg_18_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_18_0.examineBattle = arg_18_0.status:read()
	arg_18_0.model.status = arg_18_0.examineBattle
	arg_18_0.unions = gGameModel.cross_union_fight:read("unions")
	arg_18_0.unionId = gGameModel.union:read("id")
	arg_18_0.roleId = gGameModel.role:read("id")
	arg_18_0.model.unionId = arg_18_0.unionId
	arg_18_0.model.roleId = arg_18_0.roleId
	arg_18_0.quickDatas = idlertable.new({})
	arg_18_0.localUnionData = idlertable.new({})
	arg_18_0.servers = idlers.newWithMap({})
	arg_18_0.battleId = 1
	arg_18_0.leftListName = {}
	arg_18_0.groupingData = {}
	arg_18_0.saveUnionData = {}
	arg_18_0.automatic = idler.new(1)
	arg_18_0.battleRound = 0
	arg_18_0.gameModel = {}
	arg_18_0.localModel = {}

	for iter_18_0 = 1, 3 do
		arg_18_0.localModel[iter_18_0] = {
			status = "",
			currentFrameId = 0,
			endFrameId = 0
		}
		arg_18_0.gameModel[iter_18_0] = {}
	end

	arg_18_0.viewSchdule = false
	arg_18_0.model.battleRound = 1
end

function var_0_3.notOpenView(arg_19_0, arg_19_1)
	arg_19_0.gameOver:hide()
	arg_19_0.titlePanel:show()
	arg_19_0.integralRank:show()
	arg_19_0.titlePanel:get("title"):text(gLanguageCsv.unionfightComing)
	arg_19_0.titlePanel:get("starTime"):text(gLanguageCsv.openingTime)
	arg_19_0.titlePanel:get("time"):hide()
	arg_19_0.titlePanel:get("starTime"):hide()

	if arg_19_1 and arg_19_1.date then
		local var_19_0 = time.getNumTimestamp(tonumber(arg_19_1.date), time.getRefreshHour())
		local var_19_1 = time.getDate(var_19_0)

		arg_19_0.titlePanel:get("time"):text(string.format("%s.%s.%s", var_19_1.year, var_19_1.month, var_19_1.day))
		arg_19_0.titlePanel:get("time"):show()
		arg_19_0.titlePanel:get("starTime"):show()
	end

	local var_19_2 = cc.c4b(95, 73, 55, 255)

	text.addEffect(arg_19_0.titlePanel:get("starTime"), {
		outline = {
			size = 6,
			color = var_19_2
		}
	})
	text.addEffect(arg_19_0.titlePanel:get("time"), {
		outline = {
			size = 6,
			color = var_19_2
		}
	})
	text.addEffect(arg_19_0.titlePanel:get("title"), {
		outline = {
			size = 6,
			color = var_19_2
		}
	})

	local var_19_3 = arg_19_0.titlePanel:get("title"):x()
	local var_19_4 = arg_19_0.titlePanel:get("starTime"):y()

	arg_19_0.battlegroundNode:hide()
	adapt.oneLineCenterPos(cc.p(var_19_3, var_19_4), {
		arg_19_0.titlePanel:get("starTime"),
		arg_19_0.titlePanel:get("time")
	}, cc.p(20, 0))
	arg_19_0:removeBattleView()
end

function var_0_3.removeBattleView(arg_20_0)
	if arg_20_0.mainBattle.view then
		arg_20_0.mainBattle.view:removeSelf()

		arg_20_0.mainBattle = {}
	end

	if arg_20_0.subView.view then
		arg_20_0.subView.view:removeSelf()

		arg_20_0.subView = {}
	end
end

function var_0_3.unionIntegral(arg_21_0)
	if arg_21_0.unionPoint then
		gGameUI:stackUI("city.union.cross_unionfight.score", nil, nil, arg_21_0.unionPoint)
	else
		gGameApp:requestServer("/game/cross/union/fight/point/rank", function(arg_22_0)
			arg_21_0.unionPoint = arg_22_0.view

			gGameUI:stackUI("city.union.cross_unionfight.score", nil, nil, arg_22_0.view)
		end, 1, 50)
	end
end

function var_0_3.rule(arg_23_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_23_0:createHandler("getRuleContext"), {
		width = 1326
	})
end

function var_0_3.getRuleContext(arg_24_0, arg_24_1)
	local var_24_0 = adaptContext
	local var_24_1 = {
		var_24_0.clone(arg_24_1.title, function(arg_25_0)
			arg_25_0:get("text"):text(gLanguageCsv.rule)
		end),
		var_24_0.noteText(125501, 125599)
	}
	local var_24_2 = 0
	local var_24_3 = 0

	for iter_24_0, iter_24_1 in orderCsvPairs(csv.cross.union_fight.rank_award) do
		if iter_24_1.type == 1 and var_24_2 == 0 then
			var_24_2 = 1

			table.insert(var_24_1, "#L10##C0xF76B45#" .. gLanguageCsv.preliminary)
		elseif iter_24_1.type == 2 and var_24_3 == 0 then
			var_24_3 = 2

			table.insert(var_24_1, "#L10##C0xF76B45#" .. gLanguageCsv.finalMatch)
		end

		table.insert(var_24_1, var_24_0.clone(arg_24_1.awardItem, function(arg_26_0)
			local var_26_0 = arg_26_0:multiget("text", "list")

			var_26_0.text:text(string.format(gLanguageCsv.rankSingle, iter_24_1.rank))
			uiEasy.createItemsToList(arg_24_1, var_26_0.list, iter_24_1.award)
		end))
	end

	return var_24_1
end

function var_0_3.rankReward(arg_27_0)
	arg_27_0:requestRankData(function(arg_28_0)
		gGameUI:stackUI("city.union.cross_unionfight.rank", nil, nil, arg_28_0, arg_27_0.model)
	end)
end

function var_0_3.combatRecord(arg_29_0)
	if arg_29_0.saveStat == "closed" or arg_29_0.model.finish and arg_29_0.saveStat == "topOver" then
		if arg_29_0.battleData then
			if itertools.isempty(arg_29_0.battleData) then
				gGameUI:showTip(gLanguageCsv.crossUnionUnionNoBattle)

				return
			else
				arg_29_0.combat:hide()
				arg_29_0:requestRankData(function(arg_30_0)
					gGameUI:stackUI("city.union.cross_unionfight.competition", nil, nil, arg_29_0.model, arg_29_0.battleData, arg_30_0)
				end)

				return
			end
		end

		gGameApp:requestServer("/game/cross/union/fight/last/battle", function(arg_31_0)
			arg_29_0.battleData = arg_31_0.view

			if itertools.isempty(arg_31_0.view) then
				gGameUI:showTip(gLanguageCsv.crossUnionUnionNoBattle)

				return
			else
				arg_29_0.combat:hide()
				arg_29_0:requestRankData(function(arg_32_0)
					gGameUI:stackUI("city.union.cross_unionfight.competition", nil, nil, arg_29_0.model, arg_29_0.battleData, arg_32_0)
				end)
			end
		end)
	else
		gGameUI:showTip(gLanguageCsv.crossUnionUnionNoCheck)
	end
end

function var_0_3.guessingView(arg_33_0)
	local var_33_0 = var_0_0.getNowMatch(arg_33_0.saveStat)

	if arg_33_0.saveStat == "closed" and not var_0_0.whetherCloseShowUI(arg_33_0.csv_id) or arg_33_0.saveStat == "start" then
		gGameUI:showTip(gLanguageCsv.unionCrossCraftNotBet)
	elseif arg_33_0.betData then
		arg_33_0:requestRankData(function(arg_34_0)
			gGameUI:stackUI("city.union.cross_unionfight.bet", nil, {
				full = true
			}, arg_33_0.betData, arg_34_0)
		end)
	else
		gGameApp:requestServer("/game/cross/union/fight/bet/info", function(arg_35_0)
			arg_33_0.betData = arg_35_0.view

			arg_33_0:requestRankData(function(arg_36_0)
				gGameUI:stackUI("city.union.cross_unionfight.bet", nil, {
					full = true
				}, arg_35_0.view, arg_36_0)
			end)
		end, var_33_0)
	end
end

function var_0_3.combatDistribution(arg_37_0)
	if arg_37_0.saveStat == "closed" and not var_0_0.whetherCloseShowUI(arg_37_0.csv_id) then
		gGameUI:showTip(gLanguageCsv.crossUnionOver)

		return
	end

	gGameApp:requestServer("/game/cross/union/fight/deploy/roles", function(arg_38_0)
		arg_37_0.distributeData = arg_38_0.view

		if not arg_37_0.groupingData.site then
			local var_38_0 = 5
		end

		local var_38_1 = gGameModel.cross_union_fight:read("roles")

		local function var_38_2(arg_39_0)
			local var_39_0 = {}

			for iter_39_0, iter_39_1 in pairs(arg_39_0) do
				var_39_0[iter_39_1.role_db_id] = var_39_0[iter_39_1.role_db_id] and var_39_0[iter_39_1.role_db_id] or {}
				var_39_0[iter_39_1.role_db_id].troop_card_state = {}

				for iter_39_2, iter_39_3 in pairs(iter_39_1.card_state or {}) do
					for iter_39_4, iter_39_5 in pairs(iter_39_3 or {}) do
						var_39_0[iter_39_1.role_db_id].troop_card_state[iter_39_4] = iter_39_5
					end
				end

				var_39_0[iter_39_1.role_db_id].troop = iter_39_1.cur_troop
			end

			return var_39_0
		end

		if arg_37_0.saveStat == "preAward" or arg_37_0.saveStat == "closed" or arg_37_0.model.finish and arg_37_0.saveStat == "preOver" or arg_37_0.model.finish and arg_37_0.saveStat == "topOver" then
			if var_38_1 then
				local var_38_3 = var_38_2(table.deepcopy(var_38_1))

				arg_37_0.localUnionData:set(var_38_3, true)

				local var_38_4, var_38_5, var_38_6 = arg_37_0:getDistributionInfo(arg_38_0)

				if not var_38_6 then
					gGameUI:showTip(gLanguageCsv.crossUnionFightNoDistributed)
				else
					gGameUI:stackUI("city.union.cross_unionfight.distributed", nil, {
						full = true
					}, arg_37_0:createHandler("getDistributionInfo"))
				end
			end
		else
			local var_38_7, var_38_8, var_38_9 = arg_37_0:getDistributionInfo(arg_38_0)

			if not var_38_9 then
				gGameUI:showTip(gLanguageCsv.crossUnionFightNoDistributed)
			else
				gGameUI:stackUI("city.union.cross_unionfight.distributed", nil, {
					full = true
				}, arg_37_0:createHandler("getDistributionInfo"))
			end
		end
	end, var_0_0.getNowMatch(arg_37_0.saveStat), arg_37_0.unionId)
end

function var_0_3.getDistributionInfo(arg_40_0)
	local var_40_0 = var_0_0.getNowMatch(arg_40_0.saveStat)
	local var_40_1 = {
		"pre_deploy_roles",
		"top_deploy_roles"
	}
	local var_40_2 = gGameModel.cross_union_fight:read("unions")

	if arg_40_0.distributeData then
		local var_40_3 = arg_40_0.distributeData[var_40_1[var_40_0]]
	end

	return arg_40_0.localUnionData, arg_40_0.unionId, arg_40_0.distributeData.deploy_roles, var_40_0
end

function var_0_3.battlefield(arg_41_0)
	local var_41_0 = arg_41_0.roleView == "fight_messages" and "competition" or "fight_messages"
	local var_41_1 = arg_41_0.roleView == "fight_messages" and gLanguageCsv.roleBattlefield or gLanguageCsv.mainBattlefield
	local var_41_2 = true

	if var_41_0 == "fight_messages" then
		local var_41_3, var_41_4 = arg_41_0.model:battleground(arg_41_0.unionClassifyData, arg_41_0.unionId, arg_41_0.saveStat)

		if var_41_3 and var_41_4 then
			gGameApp:requestServer("/game/cross/union/fight/last/battle", function(arg_42_0)
				arg_41_0.model:setLastBattle(arg_42_0.view)
				gGameUI:stackUI("city.union.cross_unionfight.fight_playback", nil, nil, arg_41_0.model, var_0_1.MatchStage.Preliminary, arg_41_0.model:getLastBattle(var_41_3) or {})
			end)

			var_41_2 = false
		else
			arg_41_0:showSubView(var_41_0)
		end
	else
		arg_41_0:showMainBattleView(var_41_0)
	end

	if var_41_2 then
		arg_41_0.roleView = var_41_0

		arg_41_0.mainBattlefield:get("name"):text(var_41_1)
	end
end

function var_0_3.finalView(arg_43_0)
	arg_43_0.final:get("btn"):texture("common/btn/btn_normal.png")
	arg_43_0.preliminary:get("btn"):texture("common/btn/btn_recharge.png")
end

function var_0_3.preliminaryView(arg_44_0)
	arg_44_0.preliminary:get("btn"):texture("common/btn/btn_normal.png")
	arg_44_0.final:get("btn"):texture("common/btn/btn_recharge.png")
end

function var_0_3.battlefieldZRView(arg_45_0)
	local var_45_0 = var_0_0.getNowMatch(arg_45_0.saveStat)

	gGameModel.forever_dispatch:getIdlerOrigin("crossUnionFightTime"):set(tonumber(time.getTodayStr()))

	local var_45_1 = {}
	local var_45_2 = 1

	for iter_45_0, iter_45_1 in pairs(arg_45_0.roles) do
		if iter_45_0 == arg_45_0.roleId then
			var_45_1 = iter_45_1

			break
		end
	end

	if not itertools.isempty(var_45_1) then
		local var_45_3 = var_45_1.projects[var_45_0]

		userDefault.getForeverLocalKey("crossUnionFightEmbattle", false)
		gGameUI:stackUI("city.union.cross_unionfight.embattle", nil, {
			full = true
		}, {
			type = var_45_0,
			sign = var_45_3
		})
	else
		gGameUI:showTip(gLanguageCsv.unionFightNotInFinal)
	end
end

function var_0_3.serviceArea(arg_46_0, arg_46_1)
	arg_46_0.battlegroundNode:hide()
	arg_46_0.areaClothing:show()
	arg_46_0.integralRank:show()
	text.addEffect(arg_46_0.title1, {
		outline = {
			size = 6,
			color = cc.c4b(95, 73, 55, 255)
		}
	})
	text.addEffect(arg_46_0.title2, {
		outline = {
			size = 6,
			color = cc.c4b(95, 73, 55, 255)
		}
	})

	local var_46_0 = csv.cross.service[arg_46_1]

	arg_46_0.servers:update(getMergeServers(var_46_0.servers))
end

function var_0_3.preparation(arg_47_0)
	arg_47_0.prepare:show()
	arg_47_0.prepareList:show()
	arg_47_0.integralRank:hide()
	arg_47_0.areaClothing:hide()
	arg_47_0.titlePanel:hide()
	arg_47_0.combat:hide()
	arg_47_0.prepare:get("title"):show()
	arg_47_0.prepare:get("title"):text(gLanguageCsv.crossUnionFightPrepare)
	text.addEffect(arg_47_0.prepare:get("title"), {
		outline = {
			size = 4,
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})

	for iter_47_0 = 1, 4 do
		arg_47_0.leftListName[iter_47_0] = gLanguageCsv["buildOrganization" .. iter_47_0] .. gLanguageCsv.organization
	end

	arg_47_0.quickDatas:set(arg_47_0.unionClassifyData)

	if not arg_47_0.roles[arg_47_0.roleId] then
		arg_47_0.battlegroundNode:hide()
		arg_47_0.embattle:hide()
	else
		arg_47_0.battlegroundNode:show()
		arg_47_0.embattle:show()
	end
end

function var_0_3.combatStage(arg_48_0, arg_48_1, arg_48_2)
	arg_48_0.integralRank:hide()
	arg_48_0.titlePanel:hide()
	arg_48_0.prepare:hide()

	if arg_48_2 then
		arg_48_0.battlegroundNode:hide()
		arg_48_0.combat:hide()
	end

	if arg_48_1 == "fight_messages" and not arg_48_0.subView.view then
		arg_48_0:showSubView(arg_48_1)
		arg_48_0.mainBattlefield:get("name"):text(gLanguageCsv.mainBattlefield)
	elseif arg_48_1 == "competition" and not arg_48_0.mainBattle.view then
		arg_48_0.mainBattlefield:get("name"):text(gLanguageCsv.roleBattlefield)
		arg_48_0:showMainBattleView(arg_48_1)
	end
end

function var_0_3.showSubView(arg_49_0, arg_49_1, ...)
	if arg_49_1 then
		if arg_49_0.mainBattle.view then
			arg_49_0.mainBattle.view:removeSelf()

			arg_49_0.mainBattle = {}
		end

		if arg_49_0.subView.view then
			arg_49_0.subView.view:show()
		else
			arg_49_0.subView = {
				name = "fight_messages",
				view = gGameUI:createView("city.union.cross_unionfight.fight_messages", arg_49_0:getResourceNode()):init(arg_49_0.model):x(display.uiOrigin.x)
			}
		end
	end
end

function var_0_3.showMainBattleView(arg_50_0, arg_50_1, ...)
	if arg_50_1 then
		local var_50_0 = arg_50_0.saveStat
		local var_50_1 = false

		if not arg_50_0.model.finish and (var_50_0 == "preOver" or var_50_0 == "topOver") then
			var_50_1 = true
		end

		if var_50_1 or itertools.include({
			"preBattle",
			"preStart",
			"topBattle",
			"topStart"
		}, var_50_0) then
			if arg_50_0.subView.view then
				arg_50_0.subView.view:closeUnionInfoView()
				arg_50_0.subView.view:hide()
			end
		elseif arg_50_0.subView.view then
			arg_50_0.subView.view:removeSelf()

			arg_50_0.subView = {}
		end

		if not arg_50_0.mainBattle.view then
			arg_50_0.mainBattle = {
				name = arg_50_1,
				view = gGameUI:createView("city.union.cross_unionfight.competition", arg_50_0:getResourceNode()):init(arg_50_0.model):x(display.uiOrigin.x)
			}
		end
	end
end

function var_0_3.closeUnionInfo(arg_51_0)
	if arg_51_0.subView.view then
		arg_51_0.subView.view:closeUnionInfoView()
	end
end

function var_0_3.countDown(arg_52_0, arg_52_1)
	if arg_52_1 == "preStart" or arg_52_1 == "topStart" then
		local var_52_0 = time.getTimeTable()

		var_52_0.hour, var_52_0.min, var_52_0.sec = 21, 0, 0

		local var_52_1 = 0
		local var_52_2 = time.getNowDate()
		local var_52_3 = time.getTimestamp(var_52_0) - time.getTimestamp(var_52_2)

		if var_52_3 <= 0 then
			var_52_3 = 0
		end

		return var_52_3
	end
end

function var_0_3.requestBattle(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0.groupingData.site or 5

	if (arg_53_0.saveStat == "preOver" or arg_53_0.saveStat == "preBattle") and not arg_53_0.roles[arg_53_0.roleId] then
		var_53_0 = 1
	end

	local var_53_1 = var_53_0 == 5 and 1 or var_53_0

	arg_53_0.model.squad = var_53_1

	local var_53_2 = {}

	for iter_53_0 = 1, 3 do
		var_53_2[iter_53_0] = arg_53_0.localModel[iter_53_0].endFrameId + 1
	end

	local var_53_3 = 0

	performWithDelay(arg_53_0, function()
		gGameApp:requestServer("/game/cross/union/fight/battle/result", function(arg_55_0)
			if arg_55_0.view.status and arg_53_0.saveStat ~= arg_55_0.view.status then
				arg_53_0.automatic:set(2, true)
			end

			for iter_55_0 = 1, 3 do
				local var_55_0 = arg_55_0.view.results[iter_55_0]

				if var_55_0 and #var_55_0 > 0 then
					if var_55_0[#var_55_0].round > arg_53_0.battleRound then
						arg_53_0.battleRound = var_55_0[#var_55_0].round
						var_53_3 = iter_55_0
					end

					arg_53_0.localModel[iter_55_0].endFrameId = #var_55_0 + arg_53_0.localModel[iter_55_0].endFrameId

					if arg_53_0.saveStat == "topOver" or arg_53_0.saveStat == "preOver" then
						arg_53_0.localModel[iter_55_0].currentFrameId = arg_53_0.localModel[iter_55_0].endFrameId
					end

					for iter_55_1, iter_55_2 in ipairs(var_55_0) do
						table.insert(arg_53_0.gameModel[iter_55_0], iter_55_2)
						table.insert(arg_53_0.model.saveBattleData[var_53_1], iter_55_2)
					end
				end
			end

			if var_53_3 > 0 then
				arg_53_0.battleId = var_53_3
			end

			if arg_53_1 then
				arg_53_0:interfaceShow()
			end

			arg_53_0.schdulelabel = true
		end, var_53_0, var_53_2)
	end, 0)
end

function var_0_3.timeFlow(arg_56_0)
	if not arg_56_0.simulation then
		arg_56_0.mainBattlefield:get("name"):text(gLanguageCsv.mainBattlefield)
	end

	local var_56_0 = 10

	arg_56_0:unSchedule(var_56_0)

	arg_56_0.finish = false
	arg_56_0.schdulelabel = false

	arg_56_0:requestBattle(true)

	local var_56_1 = 33

	arg_56_0:schedule(function(arg_57_0)
		if arg_56_0.schdulelabel then
			if arg_56_0.localModel[arg_56_0.battleId].currentFrameId >= arg_56_0.localModel[arg_56_0.battleId].endFrameId and var_0_0.battleStateView(true, arg_56_0.saveStat) then
				arg_56_0:unSchedule(var_56_0)

				arg_56_0.finish = true

				return
			end

			if arg_56_0.localModel[arg_56_0.battleId].currentFrameId >= arg_56_0.localModel[arg_56_0.battleId].endFrameId and var_0_0.battleStateView(nil, arg_56_0.saveStat) then
				var_56_1 = var_56_1 - 1

				if var_56_1 <= 0 then
					var_56_1 = 33

					arg_56_0:requestBattle()
				end
			else
				arg_56_0.localModel[arg_56_0.battleId].currentFrameId = arg_56_0.localModel[arg_56_0.battleId].currentFrameId + 1
			end

			if arg_56_0.localModel[arg_56_0.battleId].currentFrameId == arg_56_0.localModel[arg_56_0.battleId].endFrameId - 6 then
				arg_56_0:requestBattle()
			end
		end
	end, 0.33, 1, var_56_0)
end

function var_0_3.voluntarilyView(arg_58_0)
	local var_58_0 = gCommonConfigCsv.crossUnionBattleReportTime
	local var_58_1 = time.getTimeTable()

	var_58_1.hour, var_58_1.min, var_58_1.sec = 21, 0, 0

	local var_58_2 = time.getNowDate()
	local var_58_3 = time.getTimestamp(var_58_2) - time.getTimestamp(var_58_1)
	local var_58_4 = math.floor(var_58_3 / var_58_0)

	var_58_4 = var_58_4 <= 0 and 1 or var_58_4

	return var_58_4
end

function var_0_3.interfaceShow(arg_59_0)
	local var_59_0 = 20
	local var_59_1 = gCommonConfigCsv.crossUnionBattleReportTime
	local var_59_2 = var_59_1

	local function var_59_3(arg_60_0)
		if not arg_59_0.simulation then
			if arg_59_0.subView.view then
				arg_59_0.subView.view:updataBattleReport(2, arg_59_0.viewSchdule, arg_59_0.gameModel, arg_60_0, arg_59_0.model)
			else
				arg_59_0.subView = {
					name = "fight_messages",
					view = gGameUI:createView("city.union.cross_unionfight.fight_messages", arg_59_0:getResourceNode()):init(arg_59_0.model):x(display.uiOrigin.x)
				}

				arg_59_0.subView.view:updataBattleReport(2, arg_59_0.viewSchdule, arg_59_0.gameModel, arg_60_0, arg_59_0.model)
			end
		end

		arg_59_0:cardState()
	end

	local var_59_4 = arg_59_0:voluntarilyView()

	local function var_59_5(arg_61_0)
		local var_61_0 = arg_59_0.saveStat

		if arg_61_0 then
			return var_61_0 == "preAward"
		end

		if var_61_0 == "preOver" or var_61_0 == "preAward" or var_61_0 == "topOver" then
			return true
		end

		return false
	end

	arg_59_0:unSchedule(var_59_0)

	if var_59_5(true) then
		arg_59_0.model.battleRound = arg_59_0.battleRound
		arg_59_0.model.finish = true
		arg_59_0.viewSchdule = true

		arg_59_0:combatStage(arg_59_0.roleView, arg_59_0.topOverSign)
		var_59_3()
	elseif var_59_5() and var_59_4 >= arg_59_0.battleRound then
		arg_59_0.model.battleRound = arg_59_0.battleRound
		arg_59_0.model.finish = true
		arg_59_0.viewSchdule = true

		if arg_59_0:preOverView(arg_59_0.saveStat) then
			return
		end

		if arg_59_0.saveStat == "topOver" then
			arg_59_0:gameoverView()

			return
		end

		arg_59_0:combatStage(arg_59_0.roleView, arg_59_0.topOverSign)
		var_59_3()
	else
		local var_59_6 = arg_59_0.battleRound <= 1 and 1 or arg_59_0.battleRound

		if not arg_59_0.finish then
			var_59_6 = arg_59_0.battleRound <= 1 and 1 or arg_59_0.battleRound - 1
		end

		arg_59_0.model.battleRound = var_59_6 <= var_59_4 and var_59_6 or var_59_4

		arg_59_0:combatStage(arg_59_0.roleView, arg_59_0.topOverSign)
		var_59_3(arg_59_0.battleRound == 0)
		arg_59_0:schedule(function(arg_62_0)
			var_59_2 = var_59_2 - 1

			if arg_59_0.finish then
				var_59_6 = arg_59_0.battleRound <= 1 and 1 or arg_59_0.battleRound
			else
				var_59_6 = arg_59_0.battleRound <= 1 and 1 or arg_59_0.battleRound - 1
			end

			arg_59_0.model.countDown = var_59_2

			if var_59_2 <= 0 then
				var_59_2 = var_59_1

				if var_59_6 >= arg_59_0.model.battleRound then
					if arg_59_0.finish and var_59_6 == arg_59_0.model.battleRound and var_59_5() then
						arg_59_0.model.battleRound = arg_59_0.model.battleRound + 1
						arg_59_0.viewSchdule = true
						arg_59_0.model.finish = true

						var_59_3()
					else
						arg_59_0.model.battleRound = arg_59_0.model.battleRound + 1

						var_59_3()
					end
				elseif arg_59_0.finish then
					arg_59_0:unSchedule(var_59_0)
					arg_59_0:overView()

					return
				else
					var_59_3(true)
				end
			end
		end, 1, 1, var_59_0)
	end
end

function var_0_3.overView(arg_63_0)
	if arg_63_0.saveStat == "topOver" then
		arg_63_0:gameoverView()
	elseif arg_63_0.saveStat == "preOver" then
		arg_63_0:combatStage("competition", not arg_63_0.roles[arg_63_0.roleId])
	end
end

function var_0_3.cardState(arg_64_0)
	local var_64_0 = arg_64_0.model.battleRound - 1

	arg_64_0.saveUnionData = var_0_0.unionMembersState(arg_64_0.gameModel, arg_64_0.unionId, arg_64_0.saveUnionData, var_64_0)

	arg_64_0.localUnionData:set(arg_64_0.saveUnionData, true)
end

function var_0_3.gameoverView(arg_65_0)
	display.director:setProjection(cc.DIRECTOR_PROJECTION_3D)
	arg_65_0:requestRankData(function(arg_66_0)
		arg_65_0:removeBattleView()
		arg_65_0.viewBg:show()
		arg_65_0.viewBg:texture("city/union/cross_unionfight/img_bwdzz_js.png")
		arg_65_0.battlegroundNode:show()
		arg_65_0.gameOver:show()
		arg_65_0.rightBtn:show()
		arg_65_0.integralRank:show()
		arg_65_0.combat:hide()

		local var_66_0 = {
			20,
			-12,
			18,
			13
		}
		local var_66_1 = {
			1.2,
			1.05,
			0.9,
			0.8
		}
		local var_66_2 = {
			883,
			684,
			550,
			410
		}

		for iter_66_0, iter_66_1 in ipairs(arg_66_0.last_ranks[5]) do
			arg_65_0.gameOver:get("panel" .. iter_66_0):get("name"):text(iter_66_1.union_name)
			adapt.setTextScaleWithWidth(arg_65_0.gameOver:get("panel" .. iter_66_0):get("name"), nil, 300)
			arg_65_0.gameOver:get("panel" .. iter_66_0):get("server"):text(string.format(gLanguageCsv.brackets, getServerArea(iter_66_1.server_key, nil)))
			arg_65_0.gameOver:get("panel" .. iter_66_0):get("icon"):texture(csv.union.union_logo[iter_66_1.union_logo].icon)
			arg_65_0.gameOver:get("panel" .. iter_66_0):setRotation3D({
				y = var_66_0[iter_66_0] or 0
			})
			arg_65_0.gameOver:get("panel" .. iter_66_0):scale(var_66_1[iter_66_0] or 1)

			if var_66_2[iter_66_0] then
				arg_65_0.gameOver:get("panel" .. iter_66_0):y(var_66_2[iter_66_0])
			end
		end

		local var_66_3 = dataEasy.getCrossServiceData("crossunionfight")

		if var_66_3 then
			local var_66_4 = csv.cross.service[var_66_3]
			local var_66_5 = time.getNumTimestamp(var_66_4.date, time.getRefreshHour())
			local var_66_6 = time.getDate(var_66_5)

			arg_65_0.gameOver:get("time"):text(string.format("%s.%s.%s", var_66_6.year, var_66_6.month, var_66_6.day))
			arg_65_0.gameOver:get("timeTitle"):text(gLanguageCsv.crossUnionNextIssue)
			arg_65_0.gameOver:get("time"):show()
			arg_65_0.gameOver:get("timeTitle"):show()

			local var_66_7 = arg_65_0.gameOver:get("title"):x()
			local var_66_8 = arg_65_0.gameOver:get("time"):y()

			adapt.oneLineCenterPos(cc.p(var_66_7, var_66_8), {
				arg_65_0.gameOver:get("timeTitle"),
				arg_65_0.gameOver:get("time")
			}, cc.p(5, 0))
		else
			arg_65_0.gameOver:get("time"):hide()
			arg_65_0.gameOver:get("timeTitle"):hide()
		end

		arg_65_0.gameOver:get("title"):text(gLanguageCsv.gameOverTitle)
	end)
end

function var_0_3.requestRankData(arg_67_0, arg_67_1)
	if arg_67_0.rankData then
		return arg_67_1(arg_67_0.rankData)
	end

	if arg_67_0.isFirst then
		arg_67_0:hide()
	end

	gGameUI:disableTouchDispatch(0.01)
	performWithDelay(arg_67_0, function()
		gGameApp:requestServer("/game/cross/union/fight/rank", function(arg_69_0)
			arg_67_0:show()

			arg_67_0.rankData = arg_69_0.view

			arg_67_1(arg_67_0.rankData)
		end)
	end, 0)
end

function var_0_3.onCleanup(arg_70_0)
	display.director:setProjection(cc.DIRECTOR_PROJECTION_2D)
	arg_70_0:removeBattleView()
	var_0_2.onCleanup(arg_70_0)
end

function var_0_3.onClose(arg_71_0)
	arg_71_0:addCallbackOnExit(arg_71_0.cb)
	var_0_2.onClose(arg_71_0)
end

return var_0_3
