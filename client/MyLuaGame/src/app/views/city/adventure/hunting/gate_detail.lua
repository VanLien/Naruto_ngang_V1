local var_0_0 = {
	elite = 2,
	normal = 1
}
local var_0_1 = {
	"city/adventure/hunting/title_pt.png",
	"city/adventure/hunting/title_jy.png",
	"city/adventure/hunting/title_boss.png"
}
local var_0_2 = {
	event = "effect",
	data = {
		outline = {
			size = 4,
			color = cc.c4b(91, 84, 91, 255)
		}
	}
}
local var_0_3 = class("HuntingGateDetailView", Dialog)

var_0_3.RESOURCE_FILENAME = "hunting_gate_detail.json"
var_0_3.RESOURCE_BINDING = {
	["enemyPanel.item"] = "item",
	enemyPanel = "enemyPanel",
	awardPanel = "awardPanel",
	["awardPanel.awardList"] = "awardList",
	["skipBtn.skipNote"] = "skipNote",
	infoPanel = "infoPanel",
	["titleBg.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["battleBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = cc.c4b(255, 255, 255, 255)
				}
			}
		}
	},
	battleBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBattleClick")
			}
		}
	},
	["passBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = cc.c4b(255, 255, 255, 255)
				}
			}
		}
	},
	passBtn = {
		varname = "passBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPassClick")
			}
		}
	},
	["battleBtn.title"] = {
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
	["passBtn.title"] = {
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
	["enemyPanel.enemyList"] = {
		varname = "enemyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				padding = 10,
				data = bindHelper.self("enemyDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							showAttribute = false,
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							levelProps = {
								data = arg_1_3.level
							},
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							onNode = function(arg_2_0)
								return
							end
						}
					})
				end
			}
		}
	},
	skipBtn = {
		varname = "selectSkip",
		binds = {
			event = "click",
			method = bindHelper.self("onSkipClick")
		}
	}
}

function var_0_3.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0.data = arg_3_1.defence_role_info or {}
	arg_3_0.route = arg_3_3
	arg_3_0.enemyId = arg_3_2
	arg_3_0.node = arg_3_4
	arg_3_0.enemyDatas = {}
	arg_3_0.cb = arg_3_5

	arg_3_0:initInfoPanel()
	arg_3_0:initEnemyPanel()
	arg_3_0:initAwardPanel()
	arg_3_0:initSkipBtn()
	arg_3_0:initPassBtn()
	Dialog.onCreate(arg_3_0)
end

function var_0_3.initInfoPanel(arg_4_0)
	local var_4_0 = csv.cross.hunting.gate

	bind.extend(arg_4_0, arg_4_0.infoPanel:get("icon"), {
		event = "extend",
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = arg_4_0.data.logo,
			frameId = arg_4_0.data.frame
		}
	})
	arg_4_0.infoPanel:get("name"):text(arg_4_0.data.name)
	arg_4_0.infoPanel:get("area"):text(getServerArea(arg_4_0.data.game_key))
	arg_4_0.infoPanel:get("type"):texture(var_0_1[var_4_0[arg_4_0.enemyId].type])
	arg_4_0.infoPanel:get("level"):text(arg_4_0.data.level)
	adapt.oneLineCenterPos(cc.p(arg_4_0.infoPanel:get("icon"):size().width / 2, arg_4_0.infoPanel:get("level"):y()), {
		arg_4_0.infoPanel:get("lvText"),
		arg_4_0.infoPanel:get("level")
	}, cc.p(0, 0), "left")
end

function var_0_3.initEnemyPanel(arg_5_0)
	local var_5_0 = 0

	for iter_5_0, iter_5_1 in pairs(arg_5_0.data.defence_card_attrs) do
		local var_5_1 = csv.cards[iter_5_1.card_id].unitID
		local var_5_2 = csv.unit[var_5_1]

		table.insert(arg_5_0.enemyDatas, {
			unitId = var_5_1,
			level = iter_5_1.level,
			advance = iter_5_1.advance,
			rarity = var_5_2.rarity,
			star = iter_5_1.star
		})

		var_5_0 = var_5_0 + iter_5_1.fighting_point
	end

	table.sort(arg_5_0.enemyDatas, function(arg_6_0, arg_6_1)
		return arg_6_0.advance > arg_6_1.advance
	end)
	arg_5_0.infoPanel:get("fightPoint"):text(var_5_0)
end

function var_0_3.initAwardPanel(arg_7_0)
	local var_7_0 = csv.cross.hunting.gate

	uiEasy.createItemsToList(arg_7_0, arg_7_0.awardList, var_7_0[arg_7_0.enemyId].dropsView, {
		onNode = function(arg_8_0, arg_8_1)
			if arg_8_1.key ~= "gold" then
				ccui.ImageView:create("city/adventure/endless_tower/icon_gl.png"):anchorPoint(1, 0.5):xy(arg_8_0:width() - 5, arg_8_0:height() - 25):addTo(arg_8_0, 15)
			end
		end
	})
	arg_7_0.awardList:setTouchEnabled(true)
end

function var_0_3.initSkipBtn(arg_9_0)
	local var_9_0 = userDefault.getForeverLocalKey("huntingSkipBattle", false)

	arg_9_0.selectSkip:get("skipBtn"):setSelectedState(var_9_0)
end

function var_0_3.initPassBtn(arg_10_0)
	local var_10_0 = arg_10_0.route == 1 and "huntingPass" or "specialHuntingPass"
	local var_10_1 = gGameModel.hunting:read("hunting_route")[arg_10_0.route].last_max_node
	local var_10_2 = gGameModel.hunting:read("hunting_route")[arg_10_0.route].history_max_node
	local var_10_3 = 0
	local var_10_4 = 0

	if csv.cross.hunting.route[var_10_1] then
		var_10_3 = csv.cross.hunting.route[var_10_1].lastCanPass
	end

	if csv.cross.hunting.route[var_10_2] then
		var_10_4 = csv.cross.hunting.route[var_10_2].historyCanPass
	end

	local var_10_5 = math.max(var_10_3, var_10_4)

	dataEasy.getListenUnlock(var_10_0, function(arg_11_0)
		arg_10_0.passBtn:visible(arg_11_0 and arg_10_0.node % 100 <= var_10_5)
	end)
end

function var_0_3.onBattleClick(arg_12_0)
	local var_12_0 = gGameModel.hunting:read("hunting_route")[arg_12_0.route].cards or {}

	if userDefault.getForeverLocalKey("huntingSkipBattle", false) then
		if not itertools.isempty(var_12_0) and arg_12_0:checkEmbattle() then
			arg_12_0:skipEmbattleToFight()
		else
			arg_12_0:goEmbattle()
		end
	else
		if not arg_12_0:checkEmbattle() then
			gGameUI:showTip(gLanguageCsv.randomTowerCheckEmbattleLevel)
		end

		arg_12_0:goEmbattle()
	end
end

function var_0_3.onPassClick(arg_13_0)
	local var_13_0 = arg_13_0.cb

	gGameApp:requestServer("/game/hunting/battle/pass", function(arg_14_0)
		arg_13_0:addCallbackOnExit(function()
			gGameUI:showGainDisplay(arg_14_0.view.drop, {
				cb = var_13_0
			})
		end)
		Dialog.onClose(arg_13_0)
	end, arg_13_0.route, arg_13_0.node, arg_13_0.enemyId)
end

function var_0_3.skipEmbattleToFight(arg_16_0)
	local var_16_0 = gGameModel.hunting:read("hunting_route")[arg_16_0.route].cards or {}
	local var_16_1 = gGameModel.hunting:read("hunting_route")[arg_16_0.route].card_states or {}
	local var_16_2 = {}

	if itertools.isempty(var_16_0) then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	if itertools.size(var_16_1) == 0 then
		local var_16_3 = gGameModel.role:read("battle_cards")

		var_16_2 = table.shallowcopy(var_16_3)
	else
		local var_16_4 = gGameModel.role:read("cards")
		local var_16_5 = {}
		local var_16_6 = itertools.map(var_16_4, function(arg_17_0, arg_17_1)
			return arg_17_1, arg_17_0
		end)

		for iter_16_0, iter_16_1 in pairs(var_16_0) do
			if var_16_6[iter_16_1] then
				var_16_5[iter_16_0] = iter_16_1
			end
		end

		var_16_2 = var_16_5
	end

	battleEntrance.battleRequest("/game/hunting/battle/start", arg_16_0.route, arg_16_0.node, arg_16_0.enemyId, var_16_2):onStartOK(function(arg_18_0)
		gGameUI:goBackInStackUI("city.adventure.hunting.route")
	end):show()
end

function var_0_3.goEmbattle(arg_19_0)
	if userDefault.getForeverLocalKey("huntingSkipBattle", false) then
		arg_19_0:skipEmbattleToFight()
	else
		gGameUI:stackUI("city.card.embattle.hunting", nil, {
			full = true
		}, {
			fightCb = function(arg_20_0, arg_20_1)
				battleEntrance.battleRequest("/game/hunting/battle/start", arg_19_0.route, arg_19_0.node, arg_19_0.enemyId, arg_20_1):onStartOK(function(arg_21_0)
					gGameUI:goBackInStackUI("city.adventure.hunting.route")
				end):show()
			end,
			route = arg_19_0.route,
			from = game.EMBATTLE_FROM_TABLE.hunting
		})
	end
end

function var_0_3.checkEmbattle(arg_22_0)
	local var_22_0 = gGameModel.hunting:read("hunting_route")[arg_22_0.route].cards or gGameModel.role:read("battle_cards")

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		local var_22_1 = gGameModel.cards:find(iter_22_1)

		if var_22_1 and var_22_1:read("level") < 10 then
			return false
		end
	end

	return true
end

function var_0_3.onSkipClick(arg_23_0)
	local var_23_0 = userDefault.getForeverLocalKey("huntingSkipBattle", false)

	arg_23_0.selectSkip:get("skipBtn"):setSelectedState(not var_23_0)
	userDefault.setForeverLocalKey("huntingSkipBattle", not var_23_0)
end

return var_0_3
