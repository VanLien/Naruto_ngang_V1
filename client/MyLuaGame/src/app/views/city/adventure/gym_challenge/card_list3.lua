local var_0_0 = 13
local var_0_1 = require("app.views.city.card.embattle.embattle_card_list")
local var_0_2 = class("EmbattleCardList3", var_0_1)

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

					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unit_id,
							cardId = arg_1_3.card_id,
							advance = arg_1_3.advance,
							rarity = arg_1_3.rarity,
							star = arg_1_3.star,
							grayState = var_1_0,
							levelProps = {
								data = arg_1_3.level
							},
							onNode = function(arg_2_0)
								arg_2_0:xy(-2, -2)
							end
						}
					})

					if arg_1_3.battle == 0 then
						arg_1_1:get("textNote"):hide()
					else
						arg_1_1:get("textNote"):show()
						arg_1_1:get("textNote"):text(gLanguageCsv.team .. gLanguageCsv["symbolNumber" .. arg_1_3.battle])
					end

					if arg_1_3.inMeteor then
						arg_1_1:get("textNote"):show()
						arg_1_1:get("textNote"):text(gLanguageCsv.inMeteor)
					end

					uiEasy.addTextEffect1(arg_1_1:get("textNote"))
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
				asyncPreload = var_0_0
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
					arg_5_0:xy(-780, -493):z(18)
				end
			}
		}
	}
}

function var_0_2.onSortCards(arg_6_0, arg_6_1)
	local var_6_0 = var_0_1.onSortCards(arg_6_0, arg_6_1)

	return function(arg_7_0, arg_7_1)
		if arg_7_0.battle ~= arg_7_1.battle then
			if arg_7_0.battle ~= 0 and arg_7_1.battle ~= 0 then
				return arg_7_0.battle < arg_7_1.battle
			end

			return arg_7_0.battle >= arg_7_1.battle
		end

		return var_6_0(arg_7_0, arg_7_1)
	end
end

function var_0_2.getBattle(arg_8_0, arg_8_1)
	if arg_8_1 and arg_8_1 ~= 0 then
		return math.ceil(arg_8_1 / 6)
	else
		return 0
	end
end

return var_0_2
