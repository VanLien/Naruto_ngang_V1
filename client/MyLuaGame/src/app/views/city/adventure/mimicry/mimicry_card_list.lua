local var_0_0 = {
	{
		attr = "fighting_point",
		name = gLanguageCsv.fighting
	},
	{
		attr = "level",
		name = gLanguageCsv.level
	},
	{
		attr = "rarity",
		name = gLanguageCsv.rarity
	},
	{
		attr = "star",
		name = gLanguageCsv.star
	},
	{
		attr = "getTime",
		name = gLanguageCsv.getTime
	}
}
local var_0_1 = 13
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = require("app.views.city.card.embattle.fake_card_list")
local var_0_4 = class("MimicryEmbattleCardList", var_0_3)

var_0_4.RESOURCE_FILENAME = "common_battle_card_list.json"
var_0_4.RESOURCE_BINDING = {
	btnPanel = "btnPanel",
	textNotRole = "emptyTxt",
	item = "item",
	list = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				padding = 4,
				data = bindHelper.self("allCardDatas"),
				item = bindHelper.self("item"),
				emptyTxt = bindHelper.self("emptyTxt"),
				dataFilterGen = bindHelper.self("onFilterCards", true),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:setName("item" .. arg_1_0:getIdx(arg_1_2))
					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unit_id,
							advance = arg_1_3.advance,
							rarity = arg_1_3.rarity,
							star = arg_1_3.star,
							grayState = arg_1_3.battle > 0 and 1 or 0,
							levelProps = {
								data = arg_1_3.level
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(-4, -4)
							end
						}
					})

					local var_1_0 = arg_1_1:get("textNote")

					var_1_0:visible(arg_1_3.battle == 1)
					uiEasy.addTextEffect1(var_1_0)
					arg_1_1:onTouch(functools.partial(arg_1_0.clickCell, arg_1_3))
				end,
				onBeforeBuild = function(arg_3_0)
					arg_3_0.emptyTxt:hide()
				end,
				onAfterBuild = function(arg_4_0)
					if #itertools.values(arg_4_0.data) == 0 then
						arg_4_0.emptyTxt:show()
					else
						arg_4_0.emptyTxt:hide()
					end
				end,
				asyncPreload = var_0_1
			},
			handlers = {
				clickCell = bindHelper.self("onCardItemTouch", true),
				initItem = bindHelper.self("initItem", true)
			}
		}
	}
}

function var_0_4.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.base = arg_5_1.base
	arg_5_0.battleCardsData = arg_5_1.battleCardsData
	arg_5_0.allCardDatas = arg_5_1.allCardDatas
	arg_5_0.clientBattleCards = arg_5_1.clientBattleCards
	arg_5_0.isQuick = arg_5_1.isQuick
	arg_5_0.bossID = arg_5_1.bossID
	arg_5_0.limtFunc = handler(arg_5_0.base, arg_5_1.limtFunc)
	arg_5_0.isMovePanelExist = handler(arg_5_0.base, arg_5_1.isMovePanelExist)
	arg_5_0.createMovePanel = handler(arg_5_0.base, arg_5_1.createMovePanel)
	arg_5_0.deleteMovingItem = handler(arg_5_0.base, arg_5_1.deleteMovingItem)
	arg_5_0.moveMovePanel = handler(arg_5_0.base, arg_5_1.moveMovePanel)
	arg_5_0.onCardClick = handler(arg_5_0.base, arg_5_1.onCardClick)
	arg_5_0.moveEndMovePanel = handler(arg_5_0.base, arg_5_1.moveEndMovePanel)

	arg_5_0.initModel(arg_5_0)
	arg_5_0.initAllCards(arg_5_0)
	arg_5_0.adaptNode(arg_5_0, arg_5_2)
	arg_5_0.initFilterBtn(arg_5_0)
	idlereasy.when(arg_5_0.clientBattleCards, function(arg_6_0, arg_6_1)
		performWithDelay(arg_5_0, function()
			dataEasy.tryCallFunc(arg_5_0.cardList, "filterSortItems", true)
		end, 0)
	end)

	return arg_5_0
end

function var_0_4.initAllCards(arg_8_0)
	idlereasy.any({
		arg_8_0.battleCardsData,
		arg_8_0.cards
	}, function(arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = arg_8_0:getAllData(arg_9_1, arg_9_2)

		dataEasy.tryCallFunc(arg_8_0.cardList, "updatePreloadCenterIndex")

		local var_9_1 = {}
		local var_9_2 = arg_9_1.cards or {}
		local var_9_3 = arg_9_1.skins or {}

		if not arg_8_0.isQuick then
			local var_9_4 = userDefault.getForeverLocalKey("mimicryBattleCard", {})[arg_8_0.bossID] or {}

			if not itertools.isempty(var_9_4) then
				var_9_2 = var_9_4.cards or {}
				var_9_3 = var_9_4.skins or {}
			end
		end

		for iter_9_0, iter_9_1 in pairs(var_9_2) do
			local var_9_5 = csv.mimicry.cards[iter_9_1]
			local var_9_6 = var_9_5 and csv.cards[var_9_5.cardID].unitID

			if var_9_5 and var_9_6 and var_9_0[var_9_6] then
				if var_9_3[var_9_5.cardID] then
					local var_9_7 = var_9_3[var_9_5.cardID]
					local var_9_8 = csv.card_skin[var_9_7]

					if var_9_8 and var_9_8.unitIDs then
						var_9_1[iter_9_0] = var_9_8.unitIDs[var_9_5.cardID]
					end
				else
					var_9_1[iter_9_0] = csv.cards[var_9_5.cardID].unitID
				end
			end
		end

		arg_8_0.allCardDatas:update(var_9_0)
		arg_8_0.clientBattleCards:set(var_9_1, true)
	end)
end

function var_0_4.getAllData(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = itertools.map(arg_10_1, function(arg_11_0, arg_11_1)
		return arg_11_1, arg_11_0
	end)
	local var_10_1 = {}
	local var_10_2 = {}

	for iter_10_0, iter_10_1 in ipairs(arg_10_2) do
		local var_10_3 = gGameModel.cards:find(iter_10_1):read("card_id", "unit_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time")
		local var_10_4 = var_10_3.card_id
		local var_10_5 = csv.cards[var_10_4].cardMarkID
		local var_10_6 = csv.cards[var_10_4].megaIndex

		if not var_10_2[var_10_5] then
			var_10_2[var_10_5] = {
				star = var_10_3.star
			}

			if var_10_6 ~= 0 then
				var_10_2[var_10_5].megaStar = var_10_3.star
			end
		end

		if not var_10_2[var_10_5][var_10_6] then
			var_10_2[var_10_5][var_10_6] = {
				card_id = var_10_3.card_id,
				fighting_point = var_10_3.fighting_point
			}
		else
			local var_10_7 = var_10_2[var_10_5][var_10_6]
			local var_10_8 = var_10_7.fighting_point

			if var_10_3.fighting_point > (var_10_7.fighting_point or 0) then
				var_10_8 = var_10_3.fighting_point
			end

			var_10_2[var_10_5][var_10_6] = {
				card_id = var_10_3.card_id,
				fighting_point = var_10_8
			}
		end

		var_10_2[var_10_5].star = math.max(var_10_3.star, var_10_2[var_10_5].star or 0)

		if var_10_6 ~= 0 then
			var_10_2[var_10_5].megaStar = math.max(var_10_3.star, var_10_2[var_10_5].megaStar or 0)
		end
	end

	local var_10_9 = gGameModel.role:getIdler("pokedex"):read()

	for iter_10_2, iter_10_3 in orderCsvPairs(csv.mimicry.cards) do
		local var_10_10 = csv.cards[iter_10_3.cardID]
		local var_10_11 = var_10_10.cardMarkID
		local var_10_12 = var_10_10.megaIndex
		local var_10_13 = false

		for iter_10_4, iter_10_5 in csvMapPairs(gCardsMarkCsv[var_10_11].data) do
			if csv.cards[iter_10_5].megaIndex == var_10_12 and var_10_9[iter_10_5] then
				var_10_13 = true

				break
			end
		end

		if var_10_13 then
			local var_10_14 = 0

			if var_10_2[var_10_11] and var_10_2[var_10_11].star then
				if var_10_12 ~= 0 then
					var_10_14 = var_10_2[var_10_11].megaStar or 0
				else
					var_10_14 = var_10_2[var_10_11].star
				end
			end

			var_10_1[var_10_10.unitID] = arg_10_0.limtFunc({
				skin_id = 0,
				card_id = iter_10_3.cardID,
				level = iter_10_3.level,
				star = math.max(var_10_14, iter_10_3.star),
				advance = iter_10_3.advance,
				csvID = iter_10_2,
				unit_id = var_10_10.unitID,
				markID = var_10_11,
				inBattle = arg_10_0.getBattle(arg_10_0, var_10_0[iter_10_3.cardID])
			})
		end
	end

	for iter_10_6, iter_10_7 in pairs(gGameModel.role:read("skins")) do
		for iter_10_8, iter_10_9 in csvMapPairs(csv.card_skin[iter_10_6].unitIDs) do
			local var_10_15 = csv.cards[iter_10_8].unitID

			if var_10_1[var_10_15] then
				local var_10_16 = clone(var_10_1[var_10_15])

				var_10_16.unit_id = iter_10_9
				var_10_16.inBattle = arg_10_0.getBattle(arg_10_0, var_10_0[iter_10_9])
				var_10_16.skin_id = iter_10_6
				var_10_1[iter_10_9] = arg_10_0.limtFunc(var_10_16)
			end
		end
	end

	return var_10_1
end

function var_0_4.onSortCards(arg_12_0, arg_12_1)
	return function(arg_13_0, arg_13_1)
		if arg_13_0.battle ~= arg_13_1.battle then
			return arg_13_1.battle < arg_13_0.battle
		end

		if arg_13_0.rarity ~= arg_13_1.rarity then
			return arg_13_1.rarity < arg_13_0.rarity
		end

		if arg_13_0.star ~= arg_13_1.star then
			return arg_13_1.star < arg_13_0.star
		end

		if arg_13_0.card_id ~= arg_13_1.card_id then
			return arg_13_0.card_id < arg_13_1.card_id
		end

		if arg_13_0.skin_id ~= arg_13_1.skin_id then
			return arg_13_0.skin_id < arg_13_1.skin_id
		end

		return arg_13_0.csvID < arg_13_1.csvID
	end
end

return var_0_4
