local var_0_0 = class("UnionFragDonateWishView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_frag_donate_wish.json"
var_0_0.RESOURCE_BINDING = {
	textNum = "textNum",
	subList = "subList",
	item = "item",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textNote1"] = {
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
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("subList"),
				dataOrderCmpGen = bindHelper.self("onSortDatas", true),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("icon", "name", "num", "bar", "mask")

					bind.extend(arg_1_0, var_1_0.icon, {
						class = "card_icon",
						props = {
							levelProps = {
								data = arg_1_3.level
							},
							rarity = arg_1_3.rarity,
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							star = arg_1_3.star,
							onNode = function(arg_2_0)
								arg_2_0:scale(1)
							end
						}
					})
					var_1_0.mask:visible(arg_1_3.selectState)
					uiEasy.setIconName("card", arg_1_3.cardId, {
						space = true,
						node = var_1_0.name,
						name = arg_1_3.name,
						advance = arg_1_3.advance
					})
					var_1_0.num:text(arg_1_3.num .. "/" .. arg_1_3.needNum)
					var_1_0.bar:percent(cc.clampf(arg_1_3.num / arg_1_3.needNum * 100, 0, 100))
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_0:getIdx(arg_1_2), arg_1_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onFrameItemClick")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["btnSure.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1 or {}

	arg_3_0.isDailySelected = var_3_0.isDailySelected or false
	arg_3_0.callBack = var_3_0.callBack

	arg_3_0:initModel()

	arg_3_0.cardDatas = idlers.new()

	local var_3_1 = {}

	for iter_3_0, iter_3_1 in ipairs(arg_3_0.cards:read()) do
		local var_3_2 = gGameModel.cards:find(iter_3_1):read("card_id", "skin_id", "name", "fighting_point", "level", "star", "advance")
		local var_3_3 = csv.cards[var_3_2.card_id]
		local var_3_4 = csv.unit[var_3_3.unitID]
		local var_3_5 = csv.fragments[var_3_3.fragID]
		local var_3_6 = dataEasy.getUnitId(var_3_2.card_id, var_3_2.skin_id)

		if var_3_5.donateType == 1 and (not var_3_1[var_3_3.cardMarkID] or var_3_1[var_3_3.cardMarkID].fight < var_3_2.fighting_point) then
			var_3_1[var_3_3.cardMarkID] = {
				selectState = false,
				cardId = var_3_2.card_id,
				unitId = var_3_6,
				name = var_3_2.name,
				rarity = var_3_4.rarity,
				fight = var_3_2.fighting_point,
				level = var_3_2.level,
				star = var_3_2.star,
				advance = var_3_2.advance,
				dbid = iter_3_1,
				cardMarkID = var_3_3.cardMarkID,
				needNum = var_3_5.combCount,
				num = arg_3_0.frags:read()[var_3_3.fragID] or 0
			}
		end
	end

	arg_3_0.cardDatas:update(var_3_1)

	arg_3_0.selectNum = 0
	arg_3_0.selectIdx = idler.new()

	arg_3_0.selectIdx:addListener(function(arg_4_0, arg_4_1)
		local var_4_0 = arg_3_0.cardDatas:atproxy(arg_4_1)

		if var_4_0 and arg_4_0 ~= arg_4_1 then
			var_4_0.selectState = false
		end

		local var_4_1 = arg_3_0.cardDatas:atproxy(arg_4_0)

		if var_4_1 then
			var_4_1.selectState = not var_4_1.selectState
			arg_3_0.selectNum = var_4_1.selectState and 1 or 0
		end

		arg_3_0.textNum:text(arg_3_0.selectNum .. "/1")
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_0.initModel(arg_5_0)
	arg_5_0.cards = gGameModel.role:getIdler("cards")
	arg_5_0.frags = gGameModel.role:getIdler("frags")
end

function var_0_0.onFrameItemClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.selectIdx:set(arg_6_3.cardMarkID, true)
end

function var_0_0.onSureClick(arg_7_0)
	if arg_7_0.selectNum <= 0 then
		gGameUI:showTip(gLanguageCsv.notSelRole)

		return
	end

	local var_7_0 = arg_7_0.cardDatas:atproxy(arg_7_0.selectIdx:read())

	if arg_7_0.isDailySelected then
		arg_7_0.callBack(var_7_0.cardId, function()
			arg_7_0:onClose()
		end)
	else
		gGameApp:requestServer("/game/union/frag/donate/start", function(arg_9_0)
			arg_7_0:onClose()
		end, var_7_0.dbid)
	end
end

function var_0_0.onSortDatas(arg_10_0, arg_10_1)
	return function(arg_11_0, arg_11_1)
		return arg_11_0.fight > arg_11_1.fight
	end
end

return var_0_0
