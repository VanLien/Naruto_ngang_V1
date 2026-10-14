local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = ccui.Scale9Sprite:create()

	var_1_0:initWithFile(cc.rect(60, 60, 1, 1), "common/box/mask_panel_exercise.png")
	var_1_0:size(arg_1_1.width - 20, arg_1_1.height - 20):alignCenter(arg_1_0:size())

	return var_1_0
end

local var_0_1 = class("GemSelectSpriteView", Dialog)
local var_0_2 = require("app.views.city.card.gem.tools")

var_0_1.RESOURCE_FILENAME = "gem_select_sprite.json"
var_0_1.RESOURCE_BINDING = {
	num = "num",
	item = "item",
	title = "title",
	panel404 = "panel404",
	lineList = "lineList",
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
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	titleTxt2 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
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
				asyncPreload = 9,
				columnSize = 3,
				topPadding = 10,
				leftPadding = 10,
				data = bindHelper.self("data"),
				item = bindHelper.self("lineList"),
				cell = bindHelper.self("item"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1:get("item"), {
						class = "card_icon",
						props = {
							unitId = arg_2_3.unitId,
							advance = arg_2_3.advance,
							rarity = arg_2_3.rarity,
							star = arg_2_3.star,
							levelProps = {
								data = arg_2_3.level
							},
							onNode = function(arg_3_0)
								return
							end
						}
					})
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_1, arg_2_2, arg_2_3)
						}
					})

					local var_2_0 = gGameModel.cards:find(arg_2_3.dbid)
					local var_2_1 = csv.unit[arg_2_3.unitId]
					local var_2_2 = arg_2_1:get("bg"):getContentSize()
					local var_2_3 = var_0_0(arg_2_1, var_2_2)
					local var_2_4 = cc.Sprite:create(var_2_1.cardShow):setOpacity(36)
					local var_2_5 = var_2_4:size()
					local var_2_6 = cc.p(-80, 0)
					local var_2_7 = var_2_2
					local var_2_8 = cc.rect((var_2_5.width - var_2_7.width) / 2 - var_2_6.x, (var_2_5.height - var_2_7.height) / 2 - var_2_6.y, var_2_7.width, var_2_7.height)

					var_2_4:alignCenter(var_2_2):setTextureRect(var_2_8)

					local var_2_9 = arg_2_1:size().width - 20
					local var_2_10 = arg_2_1:size().height - 14

					cc.ClippingNode:create(var_2_3):setAlphaThreshold(0.1):size(var_2_2):alignCenter({
						width = var_2_9,
						height = var_2_10
					}):add(var_2_4):addTo(arg_2_1, 2)

					if arg_2_3.isCur then
						arg_2_1:add(var_0_0(arg_2_1, var_2_2), 90)
					end

					arg_2_1:get("isCur"):visible(arg_2_3.isCur)

					local var_2_11 = var_2_0:read("gems")

					for iter_2_0 = 1, 9 do
						local var_2_12, var_2_13 = var_0_2.isSlotLocked(arg_2_3.dbid, iter_2_0)

						if var_2_12 then
							arg_2_1:get("icon" .. iter_2_0):texture("city/card/gem/btn_lock2.png"):scale(0.6)
						elseif var_2_11[iter_2_0] then
							local var_2_14 = gGameModel.gems:find(var_2_11[iter_2_0]):read("gem_id")
							local var_2_15 = dataEasy.getCfgByKey(var_2_14)

							arg_2_1:get("icon" .. iter_2_0):texture(var_2_15.icon)
						else
							arg_2_1:get("icon" .. iter_2_0):visible(false)
						end
					end

					arg_2_1:get("num"):setString(arg_2_3.qualityNum)
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.cb = arg_4_2

	arg_4_0.item:visible(false)

	local var_4_0 = {}
	local var_4_1 = true
	local var_4_2 = gGameModel.role:read("cards")

	for iter_4_0, iter_4_1 in ipairs(var_4_2) do
		local var_4_3 = gGameModel.cards:find(iter_4_1)
		local var_4_4 = var_4_3:read("card_id", "skin_id", "fighting_point", "level", "star", "advance")
		local var_4_5 = gGameModel.cards:find(iter_4_1):read("card_id")

		var_4_1 = false

		local var_4_6 = csv.cards[var_4_4.card_id]
		local var_4_7 = csv.unit[var_4_6.unitID]
		local var_4_8 = var_4_3:read("gems")
		local var_4_9 = 0

		for iter_4_2 = 1, 9 do
			if var_4_8[iter_4_2] then
				local var_4_10 = gGameModel.gems:find(var_4_8[iter_4_2])
				local var_4_11 = var_4_10:read("gem_id")
				local var_4_12 = var_4_10:read("level")
				local var_4_13 = csv.gem.gem[var_4_11].quality
				local var_4_14 = "qualityNum" .. var_4_13

				var_4_9 = csv.gem.quality[var_4_12][var_4_14] + var_4_9
			end
		end

		var_4_0[iter_4_1] = {
			id = var_4_4.card_id,
			unitId = dataEasy.getUnitId(var_4_4.card_id, var_4_4.skin_id),
			rarity = var_4_7.rarity,
			attr1 = var_4_7.natureType,
			attr2 = var_4_7.natureType2,
			fight = var_4_4.fighting_point,
			level = var_4_4.level,
			star = var_4_4.star,
			dbid = iter_4_1,
			advance = var_4_4.advance,
			isCur = arg_4_1 == iter_4_1,
			qualityNum = var_4_9
		}
	end

	arg_4_0.cardid = arg_4_1
	arg_4_0.data = idlers.newWithMap(var_4_0)

	arg_4_0.panel404:visible(var_4_1)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.onSortCards(arg_5_0, arg_5_1)
	return function(arg_6_0, arg_6_1)
		if arg_6_0.qualityNum ~= arg_6_1.qualityNum then
			return arg_6_0.qualityNum > arg_6_1.qualityNum
		end

		return arg_6_0.fight > arg_6_1.fight
	end
end

function var_0_1.onItemClick(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_0.cardid == arg_7_4.dbid then
		return
	end

	arg_7_0.cardid = arg_7_4.dbid

	arg_7_0:onClose()
end

function var_0_1.onClose(arg_8_0)
	if arg_8_0.cb then
		arg_8_0.cb(arg_8_0.cardid)
	end

	Dialog.onClose(arg_8_0)
end

return var_0_1
