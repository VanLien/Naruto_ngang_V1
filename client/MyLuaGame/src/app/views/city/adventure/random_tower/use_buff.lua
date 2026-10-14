local var_0_0 = {
	gLanguageCsv.recover,
	gLanguageCsv.recover,
	gLanguageCsv.revive
}
local var_0_1 = require("app.views.city.adventure.random_tower.tools")
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("RandomTowerUseBuffView", Dialog)

var_0_3.RESOURCE_FILENAME = "random_tower_use_buff.json"
var_0_3.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	textNote = "textNote",
	textNum = "textNum",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle1"] = {
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
	["title.textTitle2"] = {
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
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 38,
				columnSize = 7,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("cardPanel", "mask", "hpBar", "mpBar", "imgDie", "extraCondition2", "gainChance", "btnReward", "btnComplete")

					var_1_0.imgDie:visible(arg_1_3.hp <= 0)
					var_1_0.hpBar:setPercent(arg_1_3.hp * 100)

					local var_1_1 = arg_1_3.mp * 100

					if arg_1_3.hp <= 0 then
						var_1_1 = 0
					end

					var_1_0.mpBar:setPercent(var_1_1)

					local var_1_2 = arg_1_1:size()

					bind.extend(arg_1_0, var_1_0.cardPanel, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							rarity = arg_1_3.rarity,
							star = arg_1_3.star,
							levelProps = {
								data = arg_1_3.level
							},
							onNode = function(arg_2_0)
								return
							end
						}
					})
					var_1_0.mask:visible(arg_1_3.selectState)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_0:getIdx(arg_1_2), arg_1_3)
						}
					})
				end,
				onAfterBuild = function(arg_3_0)
					arg_3_0.afterBuild()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onitemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSure")
			}
		}
	},
	["btnSure.textNote"] = {
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

function var_0_3.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:initModel()

	arg_4_0.cb = arg_4_2

	local var_4_0 = arg_4_0.roomInfo:read().buff[arg_4_1]
	local var_4_1 = csv.random_tower.buffs[var_4_0]

	arg_4_0.boardID = arg_4_1
	arg_4_0.buffId = var_4_0

	arg_4_0.textNote:text(string.format(gLanguageCsv.selectCardSupply, var_0_0[var_4_1.supplyType]))

	arg_4_0.cardDatas = idlers.new()

	local var_4_2 = {}
	local var_4_3 = arg_4_0.cardStates:read()
	local var_4_4 = var_0_1.getCards(var_4_1.supplyTarget)

	for iter_4_0, iter_4_1 in pairs(var_4_4) do
		if var_0_1.reachCondition(var_4_1.condition, var_4_3[iter_4_1], iter_4_1) then
			table.insert(var_4_2, arg_4_0:getCardData(iter_4_1))
		end
	end

	table.sort(var_4_2, function(arg_5_0, arg_5_1)
		return arg_5_0.fight > arg_5_1.fight
	end)
	arg_4_0.cardDatas:update(var_4_2)

	arg_4_0.selectIdx = idler.new(0)

	arg_4_0.textNum:text("0/1")
	adapt.oneLinePos(arg_4_0.textNote, arg_4_0.textNum, cc.p(5, 0))
	arg_4_0.selectIdx:addListener(function(arg_6_0, arg_6_1)
		local var_6_0 = arg_4_0.cardDatas:atproxy(arg_6_0)
		local var_6_1 = arg_4_0.cardDatas:atproxy(arg_6_1)

		if var_6_1 then
			var_6_1.selectState = false
		end

		if var_6_0 then
			arg_4_0.textNum:text("1/1")
			adapt.oneLinePos(arg_4_0.textNote, arg_4_0.textNum, cc.p(5, 0))

			var_6_0.selectState = true
		end
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_3.getCardData(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.cardStates:read()[arg_7_1]
	local var_7_1 = 1
	local var_7_2 = 0

	if var_7_0 then
		var_7_1 = var_7_0[1]
		var_7_2 = var_7_0[2]
	end

	local var_7_3 = gGameModel.cards:find(arg_7_1):read("card_id", "skin_id", "name", "level", "star", "advance", "fighting_point")
	local var_7_4 = csv.cards[var_7_3.card_id]
	local var_7_5 = dataEasy.getUnitCsv(var_7_3.card_id, var_7_3.skin_id)

	return {
		selectState = false,
		id = var_7_3.card_id,
		unitId = var_7_5.id,
		rarity = var_7_5.rarity,
		level = var_7_3.level,
		star = var_7_3.star,
		advance = var_7_3.advance,
		dbid = arg_7_1,
		fight = var_7_3.fighting_point,
		hp = var_7_1,
		mp = var_7_2
	}
end

function var_0_3.initModel(arg_8_0)
	arg_8_0.cardStates = gGameModel.random_tower:getIdler("card_states")
	arg_8_0.roomInfo = gGameModel.random_tower:getIdler("room_info")
	arg_8_0.cards = gGameModel.role:getIdler("cards")
end

function var_0_3.onitemClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.selectIdx:set(arg_9_2.k)
end

function var_0_3.onBtnSure(arg_10_0)
	local var_10_0 = arg_10_0.cardDatas:atproxy(arg_10_0.selectIdx:read())

	if not var_10_0 then
		return
	end

	local var_10_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/random_tower/buff/used"):params(var_10_0.dbid):onResponse(function(arg_11_0)
		var_10_1[1] = true
	end):wait(var_10_1):doit(function(arg_12_0)
		arg_10_0:addCallbackOnExit(arg_10_0.cb)
		var_0_2.onClose(arg_10_0)
	end)
end

return var_0_3
