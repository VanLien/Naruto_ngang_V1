local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SummerChallengeGateDetail", var_0_0)

var_0_1.RESOURCE_FILENAME = "summer_challenge_gate_detail.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	title1 = "title1",
	rewardList = "rewardList",
	title2 = "title2",
	title3 = "title3",
	["reviewPanel.list"] = "reviewList",
	gateTextList = "gateTextList",
	reviewPanel = "reviewPanel",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
				data = bindHelper.self("combatDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							cardId = arg_1_3.cardId,
							advance = arg_1_3.advance,
							levelProps = {
								data = arg_1_3.level
							},
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							onNode = function(arg_2_0)
								arg_2_0:y(arg_1_1:height() / 2)
								arg_2_0:anchorPoint(0, 0.5)
								arg_2_0:scale(0.9)
							end
						}
					})
				end
			}
		}
	},
	battleBtn = {
		varname = "battleBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBattleClick")
			}
		}
	},
	["battleBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	}
}
var_0_1.RESOURCE_STYLES = {
	clickClose = true,
	blackLayer = true
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.handler = arg_3_1.handler

	local var_3_0 = arg_3_1.data
	local var_3_1 = var_3_0.floor
	local var_3_2 = var_3_0.gateCfg

	arg_3_0.gateCfg = var_3_2
	arg_3_0.gateID = var_3_0.gateID

	local var_3_3 = gGameModel.role:read("yyhuodongs")

	arg_3_0.title2:text(var_3_1)
	arg_3_0.title3:text(var_3_2.name)
	adapt.oneLinePos(arg_3_0.title1, arg_3_0.title2, cc.p(3, 0))
	adapt.oneLinePos(arg_3_0.title2, arg_3_0.title3, cc.p(15, 0))
	beauty.textScroll({
		fontSize = 36,
		isRich = true,
		list = arg_3_0.gateTextList,
		strs = "#C0x5B545B#" .. var_3_2.desc
	})
	uiEasy.createItemsToList(arg_3_0, arg_3_0.rewardList, var_3_2.award, {
		scale = 0.8
	})

	local var_3_4 = var_3_2.monsterIDs[itertools.size(var_3_2.monsterIDs)]
	local var_3_5 = csv.summer_challenge.monsters[var_3_4].cards

	arg_3_0.combatDatas = idlers.newWithMap(arg_3_0:getMonsters(var_3_5))

	local var_3_6 = ((var_3_3[arg_3_1.yyID] or {}).stamps or {})[arg_3_0.gateID] == 1

	arg_3_0.battleBtn:visible(not var_3_6)
	arg_3_0.reviewPanel:visible(var_3_6)

	if var_3_6 then
		beauty.textScroll({
			fontSize = 40,
			isRich = true,
			list = arg_3_0.reviewList,
			strs = "#C0x5B545B#" .. var_3_2.reviewPlot
		})
	end
end

function var_0_1.getMonsters(arg_4_0, arg_4_1)
	local var_4_0 = {}
	local var_4_1 = csv.summer_challenge.cards

	for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
		if iter_4_1 > 0 then
			local var_4_2 = var_4_1[iter_4_1]

			table.insert(var_4_0, {
				cardId = var_4_2.cardID,
				unitId = var_4_2.unitID,
				advance = var_4_2.advance,
				level = var_4_2.level,
				rarity = var_4_2.rarity,
				star = var_4_2.star
			})
		end
	end

	return var_4_0
end

function var_0_1.onBattleClick(arg_5_0)
	gGameUI:stackUI("city.activity.summer_challenge.embattle", nil, {
		full = true
	}, {
		fightCb = arg_5_0:createHandler("startFighting"),
		gateCfg = arg_5_0.gateCfg,
		gateID = arg_5_0.gateID
	})
end

function var_0_1.startFighting(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.handler(arg_6_1, arg_6_0, arg_6_2)
end

return var_0_1
