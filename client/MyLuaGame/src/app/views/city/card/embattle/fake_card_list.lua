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
local var_0_3 = require("app.views.city.card.embattle.embattle_card_list")
local var_0_4 = class("FakeCardListView", var_0_3)

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

function var_0_4.onCardItemTouch(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_3.name == "began" then
		arg_8_0.moved = false
		arg_8_0.touchBeganPos = arg_8_3

		arg_8_0.deleteMovingItem()
	elseif arg_8_3.name == "moved" then
		local var_8_0 = math.abs(arg_8_3.x - arg_8_0.touchBeganPos.x)
		local var_8_1 = math.abs(arg_8_3.y - arg_8_0.touchBeganPos.y)

		if not arg_8_0.moved and not arg_8_0.isMovePanelExist() and (var_8_0 >= ui.TOUCH_MOVED_THRESHOLD or var_8_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			if var_8_1 > var_8_0 * 0.7 then
				local var_8_2 = arg_8_0.allCardDatas:atproxy(arg_8_2.unit_id)

				arg_8_0.createMovePanel(var_8_2)
			end

			arg_8_0.moved = true
		end

		arg_8_0.cardList:setTouchEnabled(not arg_8_0.isMovePanelExist())
		arg_8_0.moveMovePanel(arg_8_3)
	elseif arg_8_3.name == "ended" or arg_8_3.name == "cancelled" then
		if arg_8_0.isMovePanelExist() == false and arg_8_0.moved == false then
			arg_8_0.onCardClick(arg_8_2, true)

			return
		end

		arg_8_0.moveEndMovePanel(arg_8_2)
	end
end

function var_0_4.initAllCards(arg_9_0)
	idlereasy.any({
		arg_9_0.battleCardsData,
		arg_9_0.cards
	}, function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = itertools.map(arg_10_1, function(arg_11_0, arg_11_1)
			return arg_11_1, arg_11_0
		end)
		local var_10_1 = {}

		for iter_10_0, iter_10_1 in orderCsvPairs(csv.mimicry.cards) do
			local var_10_2 = csv.cards[iter_10_1.cardID]
			local var_10_3 = var_10_2.cardMarkID

			var_10_1[var_10_2.unitID] = arg_9_0.limtFunc({
				skin_id = 0,
				card_id = iter_10_1.cardID,
				level = iter_10_1.level,
				star = iter_10_1.star,
				advance = iter_10_1.advance,
				csvID = iter_10_0,
				unit_id = var_10_2.unitID,
				markID = var_10_3,
				inBattle = arg_9_0:getBattle(var_10_0[iter_10_1.cardID])
			})
		end

		dataEasy.tryCallFunc(arg_9_0.cardList, "updatePreloadCenterIndex")
		arg_9_0.allCardDatas:update(var_10_1)
		arg_9_0.clientBattleCards:set({}, true)
	end)
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

		if arg_13_0.skin_id ~= arg_13_1.skin_id then
			return arg_13_1.skin_id < arg_13_0.skin_id
		end

		if arg_13_0.level ~= arg_13_1.level then
			return arg_13_1.level < arg_13_0.level
		end

		if arg_13_0.advance ~= arg_13_1.advance then
			return arg_13_1.advance < arg_13_0.advance
		end

		return arg_13_0.card_id < arg_13_1.card_id
	end
end

return var_0_4
