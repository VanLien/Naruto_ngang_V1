local var_0_0 = require("app.views.city.card.embattle.embattle_card_list")
local var_0_1 = class("EmbattleCardList", var_0_0)

var_0_1.RESOURCE_FILENAME = "common_battle_card_list.json"
var_0_1.RESOURCE_BINDING = {
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
				onNode = function(arg_4_0)
					arg_4_0:xy(-770, -491):z(18)
				end
			}
		}
	}
}

function var_0_1.initItem(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2:size()
	local var_5_1 = arg_5_4.battle > 0 and 1 or 0

	if arg_5_4.inMeteor then
		var_5_1 = 1
	end

	bind.extend(arg_5_1, arg_5_2, {
		class = "card_icon",
		props = {
			unitId = arg_5_4.unit_id,
			advance = arg_5_4.advance,
			rarity = arg_5_4.rarity,
			star = arg_5_4.star,
			grayState = var_5_1,
			levelProps = {
				data = arg_5_4.level
			},
			onNode = function(arg_6_0)
				arg_6_0:xy(-4, -4)
			end
		}
	})

	local var_5_2 = arg_5_2:get("textNote")

	var_5_2:visible(arg_5_4.battle == 1)

	if arg_5_4.inMeteor then
		var_5_2.text(var_5_2, gLanguageCsv.inMeteorites)
		var_5_2.show(var_5_2)
	end

	uiEasy.addTextEffect1(var_5_2)

	local var_5_3 = arg_5_2:get("hpBar"):show()
	local var_5_4 = arg_5_2:get("mpBar"):show()

	var_5_3:get("bar"):setPercent(arg_5_4.states[1] * 100)
	var_5_4:get("bar"):setPercent(arg_5_4.states[2] * 100)

	if arg_5_4.states[1] > 0 then
		arg_5_2:onTouch(functools.partial(arg_5_1.clickCell, arg_5_4))
	else
		arg_5_2:get("deadMask"):show()
	end
end

function var_0_1.onSortCards(arg_7_0, arg_7_1)
	local var_7_0 = var_0_0.onSortCards(arg_7_0, arg_7_1)

	return function(arg_8_0, arg_8_1)
		local var_8_0 = arg_8_0.states
		local var_8_1 = arg_8_1.states

		if var_8_0[1] <= 0 then
			return false
		end

		if var_8_1[1] <= 0 then
			return true
		end

		return var_7_0(arg_8_0, arg_8_1)
	end
end

return var_0_1
