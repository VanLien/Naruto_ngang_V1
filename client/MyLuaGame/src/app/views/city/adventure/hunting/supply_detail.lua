local var_0_0 = {
	gLanguageCsv.recover,
	[3] = gLanguageCsv.revive
}
local var_0_1 = {
	all = 2,
	single = 1,
	resurrect = 3
}

local function var_0_2(arg_1_0)
	local var_1_0 = gGameModel.role:read("cards")

	if arg_1_0 == 2 then
		var_1_0 = table.deepcopy(gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.randomTower], true) or {}
	end

	return var_1_0
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	if gGameModel.cards:find(arg_2_2):read("level") < 10 then
		return false
	end

	if arg_2_0 == var_0_1.single then
		return arg_2_1 and arg_2_1[1] > 0 and arg_2_1[1] < 1
	end

	if arg_2_0 == var_0_1.resurrect then
		return arg_2_1 and arg_2_1[1] <= 0
	end

	return true
end

local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("HuntingSupplyDetailView", Dialog)

var_0_5.RESOURCE_FILENAME = "hunting_supply_detail.json"
var_0_5.RESOURCE_BINDING = {
	textNum = "textNum",
	subList = "subList",
	item = "item",
	textNote = "textNote",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("cardPanel", "mask", "hpBar", "mpBar", "imgDie", "extraCondition2", "gainChance", "btnReward", "btnComplete")

					var_3_0.imgDie:visible(arg_3_3.hp <= 0)
					var_3_0.hpBar:setPercent(arg_3_3.hp * 100)

					local var_3_1 = arg_3_3.mp * 100

					if arg_3_3.hp <= 0 then
						var_3_1 = 0
					end

					var_3_0.mpBar:setPercent(var_3_1)

					local var_3_2 = arg_3_1:size()

					bind.extend(arg_3_0, var_3_0.cardPanel, {
						class = "card_icon",
						props = {
							unitId = arg_3_3.unitId,
							advance = arg_3_3.advance,
							rarity = arg_3_3.rarity,
							star = arg_3_3.star,
							levelProps = {
								data = arg_3_3.level
							},
							onNode = function(arg_4_0)
								return
							end
						}
					})
					var_3_0.mask:visible(arg_3_3.selectState)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.itemClick, arg_3_0:getIdx(arg_3_2), arg_3_3)
						}
					})
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0.afterBuild()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onitemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["btnSure.textNote"] = {
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
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnSure")
			}
		}
	}
}

function var_0_5.onCreate(arg_6_0, arg_6_1)
	arg_6_0.params = arg_6_1

	arg_6_0:initModel()
	arg_6_0.textNote:text(string.format(gLanguageCsv.selectCardSupply, var_0_0[arg_6_1.type]))

	arg_6_0.cardDatas = idlers.new()

	local var_6_0 = {}
	local var_6_1 = arg_6_0.cardStates
	local var_6_2 = var_0_2(arg_6_1.type)

	for iter_6_0, iter_6_1 in pairs(var_6_2) do
		if var_0_3(arg_6_1.type, var_6_1[iter_6_1], iter_6_1) then
			table.insert(var_6_0, arg_6_0:getCardData(iter_6_1))
		end
	end

	table.sort(var_6_0, function(arg_7_0, arg_7_1)
		return arg_7_0.fight > arg_7_1.fight
	end)
	arg_6_0.cardDatas:update(var_6_0)

	arg_6_0.selectIdx = idler.new(0)

	arg_6_0.textNum:text("0/1")
	arg_6_0.selectIdx:addListener(function(arg_8_0, arg_8_1)
		local var_8_0 = arg_6_0.cardDatas:atproxy(arg_8_0)
		local var_8_1 = arg_6_0.cardDatas:atproxy(arg_8_1)

		if var_8_1 then
			var_8_1.selectState = false
		end

		if var_8_0 then
			arg_6_0.textNum:text("1/1")
			adapt.oneLinePos(arg_6_0.textNote, arg_6_0.textNum, cc.p(5, 0))

			var_8_0.selectState = true
		end
	end)
	Dialog.onCreate(arg_6_0)
end

function var_0_5.getCardData(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.cardStates[arg_9_1]
	local var_9_1 = 1
	local var_9_2 = 0

	if var_9_0 then
		var_9_1 = var_9_0[1]
		var_9_2 = var_9_0[2]
	end

	local var_9_3 = gGameModel.cards:find(arg_9_1):read("card_id", "skin_id", "name", "level", "star", "advance", "fighting_point")
	local var_9_4 = csv.cards[var_9_3.card_id]
	local var_9_5 = dataEasy.getUnitId(var_9_3.card_id, var_9_3.skin_id)
	local var_9_6 = csv.unit[var_9_5]

	return {
		selectState = false,
		id = var_9_3.card_id,
		unitId = var_9_5,
		rarity = var_9_6.rarity,
		level = var_9_3.level,
		star = var_9_3.star,
		advance = var_9_3.advance,
		dbid = arg_9_1,
		fight = var_9_3.fighting_point,
		hp = var_9_1,
		mp = var_9_2
	}
end

function var_0_5.initModel(arg_10_0)
	arg_10_0.routeInfo = gGameModel.hunting:read("hunting_route")
	arg_10_0.cardStates = arg_10_0.routeInfo[arg_10_0.params.route].card_states
end

function var_0_5.onitemClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_0.selectIdx:set(arg_11_2.k)
end

function var_0_5.onBtnSure(arg_12_0)
	local var_12_0 = arg_12_0.cardDatas:atproxy(arg_12_0.selectIdx:read())

	if not var_12_0 then
		return
	end

	local var_12_1 = {
		false
	}

	gGameApp:requestServerCustom("/game/hunting/supply"):params(arg_12_0.params.route, arg_12_0.params.node, arg_12_0.params.csvId, var_12_0.dbid):onResponse(function(arg_13_0)
		var_12_1[1] = true
	end):wait(var_12_1):doit(function(arg_14_0)
		arg_12_0:addCallbackOnExit(arg_12_0.params.cb)
		var_0_4.onClose(arg_12_0)
	end)
end

return var_0_5
