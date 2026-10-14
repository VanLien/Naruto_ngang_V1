local var_0_0 = require("app.views.city.union.cross_unionfight.view")
local var_0_1 = require("app.views.city.union.cross_unionfight.tools")
local var_0_2 = require("app.views.city.union.cross_unionfight.model")
local var_0_3 = class("FightPlaybackView", cc.load("mvc").ViewBase)

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
	bg = "bg",
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
	}
}

function var_0_3.pushItemInitialize(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.item:clone():show()

	arg_2_0.fightList:pushBackCustomItem(var_2_0)
	var_0_1.onInitItem(arg_2_0.fightList, var_2_0, arg_2_1, arg_2_0, arg_2_2, true)
end

function var_0_3.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.topuiView = gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "Building war",
		title = gLanguageCsv.ministryHouseBattle
	})

	arg_3_0:initModel(arg_3_1)

	for iter_3_0, iter_3_1 in ipairs(arg_3_3) do
		table.sort(arg_3_3[iter_3_0], function(arg_4_0, arg_4_1)
			return arg_4_0.round > arg_4_1.round
		end)
	end

	arg_3_0.battleData = arg_3_3

	arg_3_0.bg:show()
	arg_3_0.integral:hide()
	arg_3_0:enableSchedule()

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

	arg_3_0.betType:addListener(function(arg_5_0, arg_5_1)
		arg_3_0.tabDatas:atproxy(arg_5_1).select = false
		arg_3_0.tabDatas:atproxy(arg_5_0).select = true
	end)

	arg_3_0.unionChoose = idler.new(false)
	arg_3_0.roleChoose = idler.new(false)

	local var_3_1 = arg_3_0.status:read()
	local var_3_2 = arg_3_2 ~= var_0_2.MatchStage.Preliminary and gLanguageCsv.finalMatch or gLanguageCsv.preliminary

	arg_3_0.competition:text(var_3_2)

	local var_3_3 = 0

	idlereasy.any({
		arg_3_0.unionChoose,
		arg_3_0.roleChoose,
		arg_3_0.betType
	}, function()
		var_3_3 = var_3_3 + 1

		performWithDelay(arg_3_0, function()
			local var_7_0 = arg_3_0.unionChoose:read()
			local var_7_1 = arg_3_0.roleChoose:read()
			local var_7_2 = arg_3_0.betType:read()

			if var_3_3 > 0 then
				var_3_3 = 0

				arg_3_0.fightList:removeAllChildren()
				arg_3_0.duckPanel:hide()

				local var_7_3 = arg_3_0.status:read()
				local var_7_4 = false
				local var_7_5 = 0
				local var_7_6 = 0

				arg_3_0.fightList:jumpToPercentVertical(0)

				local function var_7_7()
					for iter_8_0, iter_8_1 in ipairs(arg_3_0.battleData[var_7_2] or {}) do
						var_7_4 = var_0_1.comparison({
							var_7_0,
							var_7_1
						}, iter_8_1, arg_3_0.unionId, arg_3_0.roleId)

						if var_7_4 then
							var_7_6 = var_7_6 + 1

							if var_7_5 ~= iter_8_1.round then
								var_7_5 = iter_8_1.round

								arg_3_0:pushItemInitialize({
									roundTime = true,
									numRoundBattle = true,
									round = iter_8_1.round
								}, var_7_3)
							end

							arg_3_0:pushItemInitialize(iter_8_1, var_7_3)
							coroutine.yield()
						end
					end
				end

				arg_3_0:enableAsyncload():asyncFor(var_7_7, function()
					if var_7_6 == 0 then
						arg_3_0.duckPanel:show()
						arg_3_0.duckPanel:get("txt"):text(gLanguageCsv.battleReportNotData)
						arg_3_0.fightList:setScrollBarEnabled(false)
						arg_3_0.slider:hide()
					else
						arg_3_0.duckPanel:hide()
					end
				end, 4)
			end
		end, 0)
	end)
end

function var_0_3.initModel(arg_10_0, arg_10_1)
	arg_10_0.model = arg_10_1
	arg_10_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_10_0.unionId = gGameModel.role:read("union_db_id")
	arg_10_0.roles = gGameModel.cross_union_fight:getIdler("roles")
	arg_10_0.roleId = gGameModel.role:read("id")
	arg_10_0.roleLv = gGameModel.role:getIdler("level")
	arg_10_0.unionPoint = 0
	arg_10_0.unionAll = arg_10_0.model.unionAll
	arg_10_0.unionAlive = arg_10_0.unionAll
end

function var_0_3.onTabItemClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0.betType:set(arg_11_2)
end

function var_0_3.unionBattlefieldReport(arg_12_0)
	arg_12_0.unionChoose:set(not arg_12_0.unionChoose:read())
	arg_12_0.roleChoose:set(false)
end

function var_0_3.roleBattlefieldReport(arg_13_0)
	arg_13_0.unionChoose:set(false)
	arg_13_0.roleChoose:set(not arg_13_0.roleChoose:read())
end

function var_0_3.battleReport(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = "/game/cross/union/fight/playrecord/get"

	gGameModel:playRecordBattle(arg_14_3.play_id, arg_14_3.cross_key, var_14_0, 0, nil)
end

return var_0_3
