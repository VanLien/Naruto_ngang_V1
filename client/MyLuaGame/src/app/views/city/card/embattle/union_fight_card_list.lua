local var_0_0 = 13
local var_0_1 = require("app.views.city.card.embattle.embattle_card_list")
local var_0_2 = class("EmbattleCardList", var_0_1)

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

					if arg_1_3.battle >= 1 then
						arg_1_1:get("textNote"):show()
					else
						arg_1_1:get("textNote"):hide()
					end

					if arg_1_3.inMeteor then
						arg_1_1:get("textNote"):text(gLanguageCsv.inMeteorites)
						arg_1_1:get("textNote"):show()
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
					arg_5_0:xy(-720, -495):z(18)
				end
			}
		}
	}
}

function var_0_2.initAllCards(arg_6_0)
	idlereasy.any({
		arg_6_0.battleCardsData,
		arg_6_0.cards
	}, function(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = {
			{},
			{},
			{}
		}
		local var_7_1 = {}

		for iter_7_0, iter_7_1 in pairs(arg_7_1) do
			for iter_7_2, iter_7_3 in pairs(iter_7_1) do
				local var_7_2 = gGameModel.cards:find(iter_7_3.dbid)

				if var_7_2 then
					local var_7_3 = var_7_2:read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

					if arg_6_0.limtFunc(iter_7_3.dbid, var_7_3.card_id, var_7_3.skin_id, var_7_3.fighting_point, var_7_3.level, var_7_3.star, var_7_3.advance, var_7_3.created_time, var_7_3.nature_choose, arg_6_0:getBattle(iter_7_2)) then
						var_7_0[iter_7_0] = var_7_0[iter_7_0] or {}
						var_7_0[iter_7_0][iter_7_2] = iter_7_3
						var_7_1[iter_7_3.dbid] = 1
					end
				else
					var_7_0[iter_7_0] = var_7_0[iter_7_0] or {}
					var_7_0[iter_7_0][iter_7_2] = iter_7_3
					var_7_1[iter_7_3.dbid] = 1
				end
			end
		end

		local var_7_4 = {}
		local var_7_5

		for iter_7_4, iter_7_5 in ipairs(arg_7_2) do
			local var_7_6 = iter_7_4 == #arg_7_2
			local var_7_7 = gGameModel.cards:find(iter_7_5):read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

			var_7_4[iter_7_5] = arg_6_0.limtFunc(iter_7_5, var_7_7.card_id, var_7_7.skin_id, var_7_7.fighting_point, var_7_7.level, var_7_7.star, var_7_7.advance, var_7_7.created_time, var_7_7.nature_choose, arg_6_0:getBattle(var_7_1[iter_7_5]))

			dataEasy.tryCallFunc(arg_6_0.cardList, "updatePreloadCenterIndex")

			if var_7_6 then
				arg_6_0.allCardDatas:update(var_7_4)
				arg_6_0.clientBattleCards:set(var_7_0, true)
			end
		end
	end)
end

return var_0_2
