local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CloneBattleChooseView", Dialog)

var_0_1.RESOURCE_FILENAME = "clone_battle_sprite.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	title1 = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	list = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 12,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCardList", true),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("cardItem", "name", "txtValueTitle", "txtValue", "mask")

					uiEasy.setIconName("card", arg_1_3.id, {
						space = true,
						node = var_1_0.name,
						name = arg_1_3.name,
						advance = arg_1_3.advance
					})
					var_1_0.txtValue:text(arg_1_3.fightPoint)
					adapt.oneLinePos(var_1_0.txtValueTitle, var_1_0.txtValue, cc.p(15, 0), "left")
					bind.extend(arg_1_0, var_1_0.cardItem, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							levelProps = {
								data = arg_1_3.level
							},
							params = {
								starScale = 0.37,
								starInterval = 12.5
							}
						}
					})

					if arg_1_3.inMeteor or arg_1_3.isCur then
						var_1_0.mask:show()

						local var_1_1 = var_1_0.mask:get("textNote")

						uiEasy.addTextEffect1(var_1_0.mask:get("textNote"))

						if arg_1_3.inMeteor then
							var_1_1.text(var_1_1, gLanguageCsv.inMeteorites)
							var_1_1.show(var_1_1)
						end
					else
						var_1_0.mask:hide()
						bind.touch(arg_1_0, arg_1_1, {
							methods = {
								ended = functools.partial(arg_1_0.itemClick, arg_1_1, arg_1_2, arg_1_3)
							}
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemChoose")
			}
		}
	},
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.curSprId = arg_2_1

	arg_2_0:initModel()

	arg_2_0.cardDatas = idlers.new()

	local var_2_0 = dataEasy.getInMeteorCardsHash()

	idlereasy.any({
		arg_2_0.cards
	}, function(arg_3_0, arg_3_1)
		local var_3_0 = {}
		local var_3_1 = 0

		for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
			local var_3_2 = gGameModel.cards:find(iter_3_1):read("card_id", "skin_id", "level", "star", "advance", "name", "fighting_point")
			local var_3_3 = csv.cards[var_3_2.card_id]
			local var_3_4 = csv.unit[var_3_3.unitID]
			local var_3_5 = dataEasy.getUnitId(var_3_2.card_id, var_3_2.skin_id)

			var_3_0[iter_3_1] = {
				id = var_3_2.card_id,
				unitId = var_3_5,
				name = var_3_3.name,
				rarity = var_3_4.rarity,
				level = var_3_2.level,
				star = var_3_2.star,
				dbid = iter_3_1,
				advance = var_3_2.advance,
				fightPoint = var_3_2.fighting_point,
				isCur = arg_2_0.curSprId == iter_3_1,
				inMeteor = var_2_0[iter_3_1]
			}
			var_3_1 = var_3_1 + 1
		end

		arg_2_0.cardDatas:update(var_3_0)
	end)
	Dialog.onCreate(arg_2_0, {
		clickClose = true
	})
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.cards = gGameModel.role:getIdler("cards")
end

function var_0_1.onItemChoose(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	gGameApp:requestServer("/game/clone/battle/deploy", function(arg_6_0)
		arg_5_0:onClose()
	end, arg_5_4.dbid)
end

function var_0_1.onSortCardList(arg_7_0, arg_7_1)
	return function(arg_8_0, arg_8_1)
		if arg_8_0.isCur then
			return true
		end

		if arg_8_1.isCur then
			return false
		end

		return arg_8_0.fightPoint > arg_8_1.fightPoint
	end
end

return var_0_1
