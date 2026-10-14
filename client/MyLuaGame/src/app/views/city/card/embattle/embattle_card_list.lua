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
local var_0_2 = class("EmbattleCardList", cc.load("mvc").ViewBase)

var_0_2.RESOURCE_FILENAME = "common_battle_card_list.json"
var_0_2.RESOURCE_BINDING = {
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
					local var_1_0 = arg_1_3.battle > 0 and 1 or 0

					if arg_1_3.inMeteor then
						var_1_0 = 1
					end

					arg_1_1:setName("item" .. arg_1_0:getIdx(arg_1_2))
					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unit_id,
							advance = arg_1_3.advance,
							rarity = arg_1_3.rarity,
							star = arg_1_3.star,
							grayState = var_1_0,
							levelProps = {
								data = arg_1_3.level
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(-4, -4)
							end
						}
					})

					local var_1_1 = arg_1_1:get("textNote")

					var_1_1:visible(arg_1_3.battle == 1)

					if arg_1_3.inMeteor then
						var_1_1.text(var_1_1, gLanguageCsv.inMeteorites)
						var_1_1.show(var_1_1)
					end

					uiEasy.addTextEffect1(var_1_1)
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
	},
	btnPanel = {
		varname = "btnPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				expandUp = true,
				data = bindHelper.self("sortDatas"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_5_0)
					arg_5_0:xy(-700, -493):z(18)
				end
			}
		}
	}
}

function var_0_2.onCreate(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.base = arg_6_1.base
	arg_6_0.battleCardsData = arg_6_1.battleCardsData
	arg_6_0.allCardDatas = arg_6_1.allCardDatas
	arg_6_0.clientBattleCards = arg_6_1.clientBattleCards
	arg_6_0.limtFunc = handler(arg_6_0.base, arg_6_1.limtFunc)
	arg_6_0.isMovePanelExist = handler(arg_6_0.base, arg_6_1.isMovePanelExist)
	arg_6_0.createMovePanel = handler(arg_6_0.base, arg_6_1.createMovePanel)
	arg_6_0.deleteMovingItem = handler(arg_6_0.base, arg_6_1.deleteMovingItem)
	arg_6_0.moveMovePanel = handler(arg_6_0.base, arg_6_1.moveMovePanel)
	arg_6_0.onCardClick = handler(arg_6_0.base, arg_6_1.onCardClick)
	arg_6_0.moveEndMovePanel = handler(arg_6_0.base, arg_6_1.moveEndMovePanel)

	arg_6_0:initModel()
	arg_6_0:initAllCards()
	arg_6_0:adaptNode(arg_6_2)
	arg_6_0:initFilterBtn()
	idlereasy.when(arg_6_0.clientBattleCards, function(arg_7_0, arg_7_1)
		dataEasy.tryCallFunc(arg_6_0.cardList, "filterSortItems", true)
	end)

	return arg_6_0
end

function var_0_2.initAllCards(arg_8_0)
	idlereasy.any({
		arg_8_0.battleCardsData,
		arg_8_0.cards
	}, function(arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = {}

		for iter_9_0, iter_9_1 in pairs(arg_9_1) do
			local var_9_1 = gGameModel.cards:find(iter_9_1)

			if var_9_1 then
				local var_9_2 = var_9_1:read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

				if arg_8_0.limtFunc(iter_9_1, var_9_2.card_id, var_9_2.skin_id, var_9_2.fighting_point, var_9_2.level, var_9_2.star, var_9_2.advance, var_9_2.created_time, var_9_2.nature_choose, arg_8_0:getBattle(iter_9_0)) then
					var_9_0[iter_9_0] = iter_9_1
				end
			else
				var_9_0[iter_9_0] = iter_9_1
			end
		end

		local var_9_3 = itertools.map(var_9_0, function(arg_10_0, arg_10_1)
			return arg_10_1, arg_10_0
		end)
		local var_9_4 = {}
		local var_9_5

		for iter_9_2, iter_9_3 in ipairs(arg_9_2) do
			var_9_5 = iter_9_2 == #arg_9_2

			local var_9_6 = gGameModel.cards:find(iter_9_3):multigetIdler("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

			idlereasy.any(var_9_6, function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
				var_9_4[iter_9_3] = arg_8_0.limtFunc(iter_9_3, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_8_0:getBattle(var_9_3[iter_9_3]))

				if var_9_5 then
					dataEasy.tryCallFunc(arg_8_0.cardList, "updatePreloadCenterIndex")
					arg_8_0.allCardDatas:update(var_9_4)
					arg_8_0.clientBattleCards:set(var_9_0, true)
				end
			end):anonyOnly(arg_8_0, iter_9_2)
		end
	end)
end

function var_0_2.getBattle(arg_12_0, arg_12_1)
	if arg_12_1 and arg_12_1 ~= 0 then
		return 1
	else
		return 0
	end
end

function var_0_2.adaptNode(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return
	end

	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_13_0.cardList,
			"width"
		},
		{
			arg_13_0.cardList,
			"pos",
			"left"
		},
		{
			arg_13_0.btnPanel,
			"pos",
			"left"
		}
	})
end

function var_0_2.initFilterBtn(arg_14_0)
	arg_14_0.filterCondition = idlertable.new()
	arg_14_0.tabOrder = idler.new(true)
	arg_14_0.seletSortKey = idler.new(1)

	idlereasy.any({
		arg_14_0.filterCondition,
		arg_14_0.seletSortKey,
		arg_14_0.tabOrder
	}, function()
		dataEasy.tryCallFunc(arg_14_0.cardList, "filterSortItems", false)
	end)

	local var_14_0 = arg_14_0.btnPanel:parent():convertToWorldSpace(arg_14_0.btnPanel:box())
	local var_14_1 = arg_14_0:convertToNodeSpace(var_14_0)
	local var_14_2 = gGameUI:getConvertPos(arg_14_0.btnPanel, arg_14_0:getResourceNode())

	arg_14_0.bagFilter = gGameUI:createView("city.card.bag_filter", arg_14_0.btnPanel):init({
		cb = arg_14_0:createHandler("onBattleFilter"),
		others = {
			height = 122,
			panelOrder = true,
			width = 190,
			x = var_14_2.x + 190,
			y = var_14_2.y + 61
		}
	}):z(19):xy(-var_14_1.x, -var_14_1.y)

	arg_14_0.btnPanel:z(5)
end

function var_0_2.initModel(arg_16_0)
	arg_16_0.cards = gGameModel.role:getIdler("cards")
	arg_16_0.sortDatas = idlertable.new(arraytools.map(var_0_0, function(arg_17_0, arg_17_1)
		return arg_17_1.name
	end))
end

function var_0_2.onFilterCards(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.filterCondition:read()
	local var_18_1 = {}

	if not itertools.isempty(var_18_0) then
		var_18_1 = {
			{
				"rarity",
				var_18_0.rarity < ui.RARITY_LAST_VAL and var_18_0.rarity or nil
			},
			{
				"attr2",
				var_18_0.attr2 < ui.ATTR_MAX and var_18_0.attr2 or nil
			},
			{
				"attr1",
				var_18_0.attr1 < ui.ATTR_MAX and var_18_0.attr1 or nil
			},
			{
				"atkType",
				var_18_0.atkType
			}
		}
	end

	local function var_18_2(arg_19_0, arg_19_1, arg_19_2)
		if arg_19_0[arg_19_1] == nil and (arg_19_1 ~= "attr2" or arg_19_0.attr1 == arg_19_2) then
			return true
		end

		if arg_19_1 == "atkType" then
			for iter_19_0, iter_19_1 in ipairs(arg_19_0.atkType) do
				if arg_19_2[iter_19_1] then
					return true
				end
			end

			return false
		end

		if arg_19_0[arg_19_1] == arg_19_2 then
			return true
		end

		return false
	end

	return function(arg_20_0, arg_20_1)
		for iter_20_0 = 1, #var_18_1 do
			local var_20_0 = var_18_1[iter_20_0]

			if var_20_0[2] and not var_18_2(arg_20_1, var_20_0[1], var_20_0[2]) then
				return false
			end
		end

		return true, arg_20_0
	end
end

function var_0_2.onSortCards(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.seletSortKey:read()
	local var_21_1 = var_0_0[var_21_0].attr
	local var_21_2 = arg_21_0.tabOrder:read()

	return function(arg_22_0, arg_22_1)
		if arg_22_0.battle ~= arg_22_1.battle then
			return arg_22_0.battle > arg_22_1.battle
		end

		local var_22_0 = arg_22_0[var_21_1]
		local var_22_1 = arg_22_1[var_21_1]

		if var_22_0 ~= var_22_1 then
			if var_21_2 then
				return var_22_1 < var_22_0
			else
				return var_22_0 < var_22_1
			end
		end

		return arg_22_0.card_id < arg_22_1.card_id
	end
end

function var_0_2.onCardItemTouch(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_2.inMeteor then
		gGameUI:showTip(gLanguageCsv.cardInMeteorites)

		return
	end

	if arg_23_3.name == "began" then
		arg_23_0.moved = false
		arg_23_0.touchBeganPos = arg_23_3

		arg_23_0.deleteMovingItem()
	elseif arg_23_3.name == "moved" then
		local var_23_0 = math.abs(arg_23_3.x - arg_23_0.touchBeganPos.x)
		local var_23_1 = math.abs(arg_23_3.y - arg_23_0.touchBeganPos.y)

		if not arg_23_0.moved and not arg_23_0.isMovePanelExist() and (var_23_0 >= ui.TOUCH_MOVED_THRESHOLD or var_23_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			if var_23_1 > var_23_0 * 0.7 then
				local var_23_2 = arg_23_0.allCardDatas:atproxy(arg_23_2.dbid)

				arg_23_0.createMovePanel(var_23_2)
			end

			arg_23_0.moved = true
		end

		arg_23_0.cardList:setTouchEnabled(not arg_23_0.isMovePanelExist())
		arg_23_0.moveMovePanel(arg_23_3)
	elseif arg_23_3.name == "ended" or arg_23_3.name == "cancelled" then
		if arg_23_0.isMovePanelExist() == false and arg_23_0.moved == false then
			arg_23_0.onCardClick(arg_23_2, true)

			return
		end

		arg_23_0.moveEndMovePanel(arg_23_2)
	end
end

function var_0_2.onSortMenusBtnClick(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	if arg_24_5 == arg_24_3 then
		arg_24_0.tabOrder:modify(function(arg_25_0)
			return true, not arg_25_0
		end)
	else
		arg_24_0.tabOrder:set(true)
	end

	arg_24_0.seletSortKey:set(arg_24_3)
end

function var_0_2.onBattleFilter(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	arg_26_0.filterCondition:set({
		attr1 = arg_26_1,
		attr2 = arg_26_2,
		rarity = arg_26_3,
		atkType = arg_26_4
	}, true)
end

return var_0_2
