local var_0_0 = require("app.views.city.card.embattle.embattle_card_list")
local var_0_1 = class("EmbattleCardList", var_0_0)

var_0_1.RESOURCE_FILENAME = "common_battle_card_list.json"
var_0_1.RESOURCE_BINDING = {
	btnPanel = "btnPanel",
	textNotRole = "emptyTxt",
	item = "item",
	list = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 12,
				data = bindHelper.self("allCardDatas"),
				item = bindHelper.self("item"),
				emptyTxt = bindHelper.self("emptyTxt"),
				dataFilterGen = bindHelper.self("onFilterCards", true),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_0.initItem(arg_1_1, arg_1_2, arg_1_3)
				end,
				onBeforeBuild = function(arg_2_0)
					arg_2_0.emptyTxt:hide()
				end,
				onAfterBuild = function(arg_3_0)
					if #itertools.values(arg_3_0.data) == 0 then
						arg_3_0.emptyTxt:show()
					else
						arg_3_0.emptyTxt:hide()
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCardItemTouch"),
				initItem = bindHelper.self("initItem")
			}
		}
	}
}

function var_0_1.initItem(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2:size()

	bind.extend(arg_4_1, arg_4_2, {
		class = "card_icon",
		props = {
			unitId = arg_4_4.unit_id,
			advance = arg_4_4.advance,
			rarity = arg_4_4.rarity,
			star = arg_4_4.star,
			isNew = arg_4_4.isNew,
			grayState = arg_4_4.battle == 1 and 1 or 0,
			levelProps = {
				data = arg_4_4.level
			},
			onNode = function(arg_5_0)
				arg_5_0:xy(-4, -4)
			end
		}
	})

	local var_4_1 = arg_4_2:get("textNote")

	var_4_1:visible(arg_4_4.battle == 1)
	uiEasy.addTextEffect1(var_4_1)

	local var_4_2 = arg_4_2:get("hpBar"):show()
	local var_4_3 = arg_4_2:get("mpBar"):show()

	var_4_2:get("bar"):setPercent(arg_4_4.states[1] * 100)
	var_4_3:get("bar"):setPercent(arg_4_4.states[2] * 100)

	if arg_4_4.states[1] > 0 then
		arg_4_2:onTouch(functools.partial(arg_4_1.clickCell, arg_4_4))
	else
		arg_4_2:get("deadMask"):show()
	end
end

function var_0_1.onSortCards(arg_6_0, arg_6_1)
	arg_6_0.seletSortKey:set(3)

	local var_6_0 = var_0_0.onSortCards(arg_6_0, arg_6_1)

	return function(arg_7_0, arg_7_1)
		local var_7_0 = arg_7_0.states
		local var_7_1 = arg_7_1.states

		if var_7_0[1] <= 0 then
			return false
		end

		if var_7_1[1] <= 0 then
			return true
		end

		return var_6_0(arg_7_0, arg_7_1)
	end
end

function var_0_1.initFilterBtn(arg_8_0)
	arg_8_0.filterCondition = idlertable.new()
	arg_8_0.tabOrder = idler.new(true)
	arg_8_0.seletSortKey = idler.new(1)

	idlereasy.any({
		arg_8_0.filterCondition,
		arg_8_0.seletSortKey,
		arg_8_0.tabOrder
	}, function()
		dataEasy.tryCallFunc(arg_8_0.cardList, "filterSortItems", false)
	end)
end

function var_0_1.initAllCards(arg_10_0)
	return
end

function var_0_1.onCardItemTouch(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_3.name == "began" then
		arg_11_0.moved = false
		arg_11_0.touchBeganPos = arg_11_3

		arg_11_0.deleteMovingItem()
	elseif arg_11_3.name == "moved" then
		local var_11_0 = math.abs(arg_11_3.x - arg_11_0.touchBeganPos.x)
		local var_11_1 = math.abs(arg_11_3.y - arg_11_0.touchBeganPos.y)

		if not arg_11_0.moved and not arg_11_0.isMovePanelExist() and (var_11_0 >= ui.TOUCH_MOVED_THRESHOLD or var_11_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			if var_11_1 > var_11_0 * 0.7 then
				local var_11_2 = arg_11_0.allCardDatas:atproxy(arg_11_2.csvID)

				arg_11_0.createMovePanel(var_11_2)
			end

			arg_11_0.moved = true
		end

		arg_11_0.cardList:setTouchEnabled(not arg_11_0.isMovePanelExist())
		arg_11_0.moveMovePanel(arg_11_3)
	elseif arg_11_3.name == "ended" or arg_11_3.name == "cancelled" then
		if arg_11_0.isMovePanelExist() == false and arg_11_0.moved == false then
			arg_11_0.onCardClick(arg_11_2, true)

			return
		end

		arg_11_0.moveEndMovePanel(arg_11_2)
	end
end

return var_0_1
