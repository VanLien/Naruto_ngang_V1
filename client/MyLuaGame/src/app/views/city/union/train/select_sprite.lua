local var_0_0 = {
	replace = "/game/union/training/replace",
	start = "/game/union/training/start"
}
local var_0_1 = class("UnionSelectSpriteView", Dialog)

var_0_1.RESOURCE_FILENAME = "union_select_sprite.json"
var_0_1.RESOURCE_BINDING = {
	subList = "subList",
	item = "item",
	maskPanel = "maskPanel",
	textNum = "textNum",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
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
	title2 = {
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
				asyncPreload = 38,
				columnSize = 7,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1, {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							rarity = arg_1_3.rarity,
							star = arg_1_3.star,
							grayState = arg_1_3.selectState and 1 or 0,
							levelProps = {
								data = arg_1_3.level
							}
						}
					})
					arg_1_1:get("mask"):visible(arg_1_3.selectState):texture("img/kongbai.png")
					arg_1_1:get("mask.icon"):xy(40, 40)
					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.itemClick, arg_1_0:getIdx(arg_1_2), arg_1_3)
						}
					})
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.afterBuild()
				end
			},
			handlers = {
				itemClick = bindHelper.self("onFrameItemClick"),
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickSure")
			}
		}
	},
	["btnSure.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	arg_3_0.subList:setScrollBarEnabled(false)

	arg_3_0.idx = arg_3_1.idx
	arg_3_0.requestTyp = arg_3_1.requestTyp
	arg_3_0.selectMax = arg_3_1.selectMax or 1

	arg_3_0:initModel()

	arg_3_0.cardDatas = idlers.new()

	arg_3_0.textNum:text("0/" .. arg_3_0.selectMax)

	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_0.slots:read()) do
		var_3_0[iter_3_1.id] = true
	end

	local var_3_1 = {}

	for iter_3_2, iter_3_3 in pairs(arg_3_0.cards:read()) do
		if not var_3_0[iter_3_3] then
			local var_3_2 = gGameModel.cards:find(iter_3_3):read("card_id", "skin_id", "name", "level", "star", "advance", "fighting_point")
			local var_3_3 = csv.cards[var_3_2.card_id]
			local var_3_4 = csv.unit[var_3_3.unitID]
			local var_3_5 = dataEasy.getUnitId(var_3_2.card_id, var_3_2.skin_id)

			table.insert(var_3_1, {
				selectState = false,
				id = var_3_2.card_id,
				unitId = var_3_5,
				rarity = var_3_4.rarity,
				level = var_3_2.level,
				star = var_3_2.star,
				advance = var_3_2.advance,
				dbid = iter_3_3,
				fight = var_3_2.fighting_point
			})
		end
	end

	table.sort(var_3_1, function(arg_4_0, arg_4_1)
		return arg_4_0.fight > arg_4_1.fight
	end)
	arg_3_0.cardDatas:update(var_3_1)

	arg_3_0.selectNum = 0
	arg_3_0.selectIdx = idler.new(0)

	if arg_3_0.selectMax > 1 then
		idlereasy.when(arg_3_0.selectIdx, function(arg_5_0, arg_5_1)
			if arg_3_0.cardDatas:atproxy(arg_5_1) then
				local var_5_0 = arg_3_0.cardDatas:atproxy(arg_5_1)

				if arg_3_0.selectNum >= arg_3_0.selectMax and var_5_0.selectState == false then
					return
				end

				arg_3_0.selectNum = arg_3_0.selectNum + (var_5_0.selectState == false and 1 or -1)

				arg_3_0.textNum:text(arg_3_0.selectNum .. "/" .. arg_3_0.selectMax)

				var_5_0.selectState = not var_5_0.selectState
			end
		end)
	else
		arg_3_0.selectIdx:addListener(function(arg_6_0, arg_6_1)
			local var_6_0 = arg_3_0.cardDatas:atproxy(arg_6_0)
			local var_6_1 = arg_3_0.cardDatas:atproxy(arg_6_1)

			if var_6_1 then
				var_6_1.selectState = false
			end

			if var_6_0 then
				arg_3_0.selectNum = 1

				arg_3_0.textNum:text(arg_3_0.selectNum .. "/" .. arg_3_0.selectMax)

				var_6_0.selectState = true
			end
		end)
	end

	Dialog.onCreate(arg_3_0)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.slots = gGameModel.union_training:getIdler("slots")
	arg_7_0.cards = gGameModel.role:getIdler("cards")
end

function var_0_1.onFrameItemClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.selectIdx:set(arg_8_2.k)
end

function var_0_1.onClickSure(arg_9_0)
	local var_9_0 = arg_9_0.selectIdx:read()

	if arg_9_0.selectNum == 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectSprite)

		return
	end

	local var_9_1 = arg_9_0.cardDatas:atproxy(var_9_0).dbid

	gGameApp:requestServer(var_0_0[arg_9_0.requestTyp], function(arg_10_0)
		arg_9_0:onClose()
	end, arg_9_0.idx, var_9_1)
end

function var_0_1.onAfterBuild(arg_11_0)
	uiEasy.setBottomMask(arg_11_0.list, arg_11_0.maskPanel)
end

return var_0_1
