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
				padding = 4,
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
			grayState = arg_4_4.battle == 1 and 1 or 0,
			levelProps = {
				data = arg_4_4.level
			},
			lock = arg_4_4.lock >= 0,
			onNode = function(arg_5_0)
				local var_5_0 = arg_5_0:size()

				arg_5_0:xy(-4, -4)

				local var_5_1 = arg_5_0:get("lock")

				var_5_1:scale(1)
				var_5_1:xy(var_5_0.width - 30, var_5_0.height - 30)
			end
		}
	})

	local var_4_1 = arg_4_2:get("textNote")

	var_4_1:visible(arg_4_4.battle == 1)
	uiEasy.addTextEffect1(var_4_1)
	arg_4_2:onTouch(functools.partial(arg_4_1.clickCell, arg_4_4))
end

function var_0_1.initFilterBtn(arg_6_0)
	arg_6_0.filterCondition = idlertable.new()
	arg_6_0.tabOrder = idler.new(true)
	arg_6_0.seletSortKey = idler.new(1)
end

function var_0_1.initAllCards(arg_7_0)
	return
end

function var_0_1.onCardItemTouch(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_3.name == "began" then
		arg_8_0.moved = false
		arg_8_0.touchBeganPos = arg_8_3

		arg_8_0.deleteMovingItem()
	elseif arg_8_3.name == "moved" then
		local var_8_0 = math.abs(arg_8_3.x - arg_8_0.touchBeganPos.x)
		local var_8_1 = math.abs(arg_8_3.y - arg_8_0.touchBeganPos.y)

		if not arg_8_0.moved and not arg_8_0.isMovePanelExist() and (var_8_0 >= ui.TOUCH_MOVED_THRESHOLD or var_8_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			if var_8_1 > var_8_0 * 0.7 then
				local var_8_2 = arg_8_0.allCardDatas:atproxy(arg_8_2.csvID)

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

return var_0_1
