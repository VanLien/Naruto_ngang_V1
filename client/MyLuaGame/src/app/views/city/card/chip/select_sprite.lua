local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = ccui.Scale9Sprite:create()

	var_1_0:initWithFile(cc.rect(60, 60, 1, 1), "common/box/mask_panel_exercise.png")
	var_1_0:size(arg_1_1.width - 20, arg_1_1.height - 20):alignCenter(arg_1_0:size())

	return var_1_0
end

local var_0_1 = class("ChipSelectSpriteView", Dialog)

var_0_1.RESOURCE_FILENAME = "chip_select_sprite.json"
var_0_1.RESOURCE_BINDING = {
	num = "num",
	subList = "subList",
	item = "item",
	title = "title",
	panel404 = "panel404",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt1 = {
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
	titleTxt2 = {
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
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 3,
				asyncPreload = 9,
				data = bindHelper.self("data"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.chipNum ~= arg_2_1.chipNum then
						return arg_2_0.chipNum > arg_2_1.chipNum
					end

					return arg_2_0.fight > arg_2_1.fight
				end,
				itemAction = {
					isAction = true
				},
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1:get("item"), {
						class = "card_icon",
						props = {
							unitId = arg_3_3.unitId,
							advance = arg_3_3.advance,
							rarity = arg_3_3.rarity,
							star = arg_3_3.star,
							levelProps = {
								data = arg_3_3.level
							},
							onNode = function(arg_4_0)
								arg_4_0:scale(1.2):alignCenter(arg_4_0:size())
							end
						}
					})
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_1, arg_3_2, arg_3_3)
						}
					})
					arg_3_1:get("isCur"):visible(arg_3_3.isCur)

					if arg_3_3.isCur then
						local var_3_0 = arg_3_1:get("bg"):getContentSize()

						arg_3_1:add(var_0_0(arg_3_1, var_3_0), 90)
					end

					bind.extend(arg_3_0, arg_3_1:get("chipPanel"), {
						class = "chips_panel",
						props = {
							noIdlerListener = true,
							panelIdx = 1,
							data = arg_3_3.dbId,
							onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
								if arg_5_3 then
									arg_5_1:get("defaultLv"):y(0)
								end

								arg_5_1:get("effect_line"):hide()
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.cb = arg_6_2

	arg_6_0.item:visible(false)

	local var_6_0 = {}
	local var_6_1 = gGameModel.role:read("cards")

	for iter_6_0, iter_6_1 in ipairs(var_6_1) do
		local var_6_2 = gGameModel.cards:find(iter_6_1)
		local var_6_3 = var_6_2:read("card_id", "skin_id", "fighting_point", "level", "star", "advance")
		local var_6_4 = csv.cards[var_6_3.card_id]
		local var_6_5 = csv.unit[var_6_4.unitID]
		local var_6_6 = var_6_2:read("chip")
		local var_6_7 = 0

		for iter_6_2 = 1, 6 do
			if var_6_6[iter_6_2] then
				var_6_7 = var_6_7 + 1
			end
		end

		var_6_0[iter_6_1] = {
			dbId = iter_6_1,
			cardId = var_6_3.card_id,
			unitId = dataEasy.getUnitId(var_6_3.card_id, var_6_3.skin_id),
			rarity = var_6_5.rarity,
			attr1 = var_6_5.natureType,
			attr2 = var_6_5.natureType2,
			fight = var_6_3.fighting_point,
			level = var_6_3.level,
			star = var_6_3.star,
			advance = var_6_3.advance,
			isCur = arg_6_1 == iter_6_1,
			chipNum = var_6_7
		}
	end

	arg_6_0.cardDBID = arg_6_1
	arg_6_0.data = var_6_0

	arg_6_0.panel404:visible(itertools.size(var_6_0) == 0)
	Dialog.onCreate(arg_6_0)
end

function var_0_1.onItemClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_0.cardDBID == arg_7_4.dbId then
		return
	end

	if arg_7_0.cb then
		arg_7_0.cb(arg_7_4.dbId)
	end

	arg_7_0:onClose()
end

return var_0_1
