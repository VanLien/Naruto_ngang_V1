local var_0_0 = require("app.views.city.adventure.random_tower.tools")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("RandomTowerGateDetail", Dialog)

var_0_2.RESOURCE_FILENAME = "random_tower_gate_detail.json"
var_0_2.RESOURCE_BINDING = {
	myFightLabel = "myFightLabel",
	myFightPoint = "myFightPoint",
	enemyFightPoint = "enemyFightPoint",
	enemyFightLabel = "enemyFightLabel",
	pointLabel = "pointLabel",
	item = "item",
	enemyFightIcon = "enemyFightIcon",
	passInfo = "passInfo",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title1 = {
		varname = "title1",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title2 = {
		varname = "title2",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	enemyList = {
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
							showAttribute = true,
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							levelProps = {
								data = arg_1_3.level
							},
							isBoss = arg_1_3.isBoss,
							rarity = arg_1_3.rarity,
							onNode = function(arg_2_0)
								local var_2_0, var_2_1 = arg_2_0:xy()

								arg_1_1:scale(arg_1_3.isBoss and 1.1 or 0.99)
							end
						}
					})
				end
			}
		}
	},
	skipBtn = {
		varname = "skipBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onSkipClick")
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
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["battleBtn.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.fightCb = arg_3_2
	arg_3_0.passCb = arg_3_3

	local var_3_0 = gGameModel.random_tower:read("room_info")
	local var_3_1 = csv.random_tower.board[arg_3_1]
	local var_3_2 = string.utf8limit(var_3_1.name, 2, true)
	local var_3_3 = string.sub(var_3_1.name, #var_3_2 + 1)

	arg_3_0.title1:text(var_3_2)
	arg_3_0.title2:text(var_3_3)
	adapt.oneLinePos(arg_3_0.title1, arg_3_0.title2)

	local var_3_4 = var_3_0.enemy[arg_3_1] or {}
	local var_3_5 = csv.random_tower.monsters[var_3_4.id]
	local var_3_6 = arraytools.hash(var_3_5.boss)

	arg_3_0.enemyDatas = {}

	for iter_3_0, iter_3_1 in ipairs(var_3_4.monsters) do
		if iter_3_1.unit_id then
			local var_3_7 = csv.unit[iter_3_1.unit_id]

			table.insert(arg_3_0.enemyDatas, {
				unitId = iter_3_1.unit_id,
				level = iter_3_1.level,
				advance = iter_3_1.advance,
				star = iter_3_1.star,
				rarity = var_3_7.rarity,
				isBoss = var_3_6[iter_3_1.unit_id] or false
			})
		end
	end

	table.sort(arg_3_0.enemyDatas, function(arg_4_0, arg_4_1)
		if arg_4_0.isBoss ~= arg_4_1.isBoss then
			return arg_4_0.isBoss
		end

		return arg_4_0.advance > arg_4_1.advance
	end)
	arg_3_0.enemyFightPoint:text(tostring(var_3_4.fighting_point))
	adapt.oneLinePos(arg_3_0.enemyFightLabel, arg_3_0.enemyFightPoint, cc.p(15, 0))
	adapt.oneLinePos(arg_3_0.myFightLabel, arg_3_0.myFightPoint, cc.p(15, 0))

	local var_3_8 = var_0_0.calcFightingPointFunc()

	idlereasy.when(gGameModel.role:getIdler("huodong_cards"), function(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_1[game.EMBATTLE_HOUDONG_ID.randomTower] or gGameModel.role:read("battle_cards")
		local var_5_1 = 0

		for iter_5_0, iter_5_1 in pairs(var_5_0) do
			var_5_1 = var_5_1 + var_3_8(iter_5_1)
		end

		arg_3_0.myFightPoint:text(var_5_1)
	end)

	local var_3_9 = gGameModel.role:read("level")
	local var_3_10 = csv.random_tower.point[var_3_9].initPoint

	arg_3_0.pointLabel:text(""):removeAllChildren()

	local var_3_11 = csv.random_tower.tower[var_3_1.room].pointC[var_3_1.monsterType]
	local var_3_12 = string.format(gLanguageCsv.randomTowerGateDetailPoint, var_3_10 * var_3_1.pointC * var_3_11)
	local var_3_13 = gGameModel.role:read("vip_level")
	local var_3_14 = ""

	if gVipCsv[var_3_13].randomTowerPointRate > 1 then
		local var_3_15 = (gVipCsv[var_3_13].randomTowerPointRate - 1) * 100

		var_3_14 = string.format(gLanguageCsv.randomTowerVipPointAddTip, var_3_15)
	end

	rich.createByStr(var_3_12 .. var_3_14, 50):anchorPoint(0, 0.5):addTo(arg_3_0.pointLabel, 6)

	if not arg_3_0:isCanPass() then
		arg_3_0.passBtn:hide()
	end

	local var_3_16 = userDefault.getForeverLocalKey("randomTowerSkipBattle", false)

	arg_3_0.skipBtn:get("skipBtn"):setSelectedState(var_3_16)
	Dialog.onCreate(arg_3_0)
end

function var_0_2.isCanPass(arg_6_0)
	return var_0_0.getCanPassMaxRoom() >= gGameModel.random_tower:read("room")
end

function var_0_2.onSkipClick(arg_7_0)
	local var_7_0 = userDefault.getForeverLocalKey("randomTowerSkipBattle", false)

	arg_7_0.skipBtn:get("skipBtn"):setSelectedState(not var_7_0)
	userDefault.setForeverLocalKey("randomTowerSkipBattle", not var_7_0)
end

function var_0_2.onPassClick(arg_8_0)
	arg_8_0.passCb(arg_8_0)
end

function var_0_2.showTip(arg_9_0, arg_9_1)
	local var_9_0 = userDefault.getForeverLocalKey("randomTowerSkipBattle", false)
	local var_9_1 = gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.randomTower]

	if var_9_0 and itertools.isempty(var_9_1) then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)
	end
end

function var_0_2.onBattleClick(arg_10_0)
	local var_10_0 = gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.randomTower]

	if itertools.isempty(var_10_0) then
		arg_10_0:goEmbattle()

		return
	end

	if arg_10_0:chechEmbattle() then
		return
	end

	if userDefault.getForeverLocalKey("randomTowerSkipBattle", false) then
		arg_10_0.fightCb(arg_10_0)

		return
	end

	arg_10_0:goEmbattle()
end

function var_0_2.goEmbattle(arg_11_0)
	gGameUI:stackUI("city.card.embattle.random", nil, {
		full = true
	}, {
		from = "huodong",
		fightCb = function(...)
			arg_11_0.fightCb(arg_11_0, ...)
		end,
		fromId = game.EMBATTLE_HOUDONG_ID.randomTower,
		startCb = arg_11_0:createHandler("showTip")
	})
end

function var_0_2.chechEmbattle(arg_13_0)
	local var_13_0 = gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.randomTower] or gGameModel.role:read("battle_cards")

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_1 = gGameModel.cards:find(iter_13_1)

		if var_13_1 and var_13_1:read("level") < 10 then
			arg_13_0:goEmbattle()
			gGameUI:showTip(gLanguageCsv.randomTowerCheckEmbattleLevel)

			return true
		end
	end
end

return var_0_2
