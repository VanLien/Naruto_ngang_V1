local var_0_0 = require("app.views.city.card.rebirth.tools")
local var_0_1 = 5
local var_0_2 = 1
local var_0_3 = class("ChooseRoleView", Dialog)

var_0_3.RESOURCE_FILENAME = "rebirth_select_role.json"
var_0_3.RESOURCE_BINDING = {
	["down.textNum"] = "textNum",
	item = "item",
	["down.textNote"] = "textNote",
	innerList = "innerList",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
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
				asyncPreload = 12,
				data = bindHelper.self("cardDatas"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("head"), {
						class = "card_icon",
						props = {
							unitId = arg_1_3.unitId,
							advance = arg_1_3.advance,
							star = arg_1_3.star,
							rarity = arg_1_3.rarity,
							levelProps = {
								data = arg_1_3.level
							}
						}
					})

					local var_1_0 = gLanguageCsv.inTheTeam

					if arg_1_3.battle == 1 and ui.CARD_USING_TXTS[arg_1_3.battleType] then
						var_1_0 = gLanguageCsv[ui.CARD_USING_TXTS[arg_1_3.battleType]]
					end

					local var_1_1 = arg_1_1:get("battle.textNote")

					var_1_1:text(var_1_0)
					uiEasy.addTextEffect1(var_1_1)
					arg_1_1:get("textName"):text(csv.cards[arg_1_3.id].name)
					arg_1_1:get("textFightPoint"):text(arg_1_3.fight)
					arg_1_1:get("imgLock"):visible(arg_1_3.lock)
					arg_1_1:get("imgTick"):visible(arg_1_3.isSel)
					arg_1_1:get("imgMask"):visible(arg_1_0.from() == 2 and arg_1_3.battle == 1 or arg_1_3.isSel)
					arg_1_1:get("battle"):visible(arg_1_0.from() == 2 and arg_1_3.battle == 1)

					local var_1_2 = arg_1_0:getIdx(arg_1_2)

					bind.touch(arg_1_0, arg_1_1, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, var_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCellClick"),
				from = bindHelper.self("from")
			}
		}
	},
	down = {
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowDown")
		}
	},
	["down.btnOk"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSure")
			}
		}
	},
	["down.btnOk.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["title.textNote1"] = {
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
	["title.textNote2"] = {
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
	tipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	}
}

function var_0_3.onCreate(arg_2_0, arg_2_1)
	arg_2_0.from = arg_2_1.from
	arg_2_0.curSel = arg_2_1.curSel
	arg_2_0.handlers = arg_2_1.handlers
	arg_2_0.isShowDown = idler.new(false)
	arg_2_0.showTip = idler.new(false)
	arg_2_0.cardDatas = idlers.newWithMap({})

	local var_2_0 = var_0_0.getSelectCard(arg_2_0.from, arg_2_0.curSel)

	table.sort(var_2_0, function(arg_3_0, arg_3_1)
		if arg_2_0.from == 1 then
			return arg_3_0.fight > arg_3_1.fight
		elseif arg_2_0.from == 2 then
			if arg_3_0.battle ~= arg_3_1.battle then
				return arg_3_0.battle == 2 and true or false
			end

			if arg_3_0.rarity ~= arg_3_1.rarity then
				return arg_3_0.rarity < arg_3_1.rarity
			end

			return arg_3_0.fight < arg_3_1.fight
		end
	end)
	arg_2_0.cardDatas:update(var_2_0)

	arg_2_0.selected = {}

	if arg_2_0.from == 2 then
		arg_2_0.isShowDown:set(true)

		for iter_2_0, iter_2_1 in ipairs(var_2_0) do
			if itertools.include(arg_2_0.curSel, iter_2_1.dbid) then
				arg_2_0.selected[iter_2_0] = iter_2_1
			end
		end
	end

	arg_2_0.showTip:set(arg_2_0.cardDatas:size() == 0)
	arg_2_0.textNum:text(string.format("%s/%s", itertools.size(arg_2_0.selected), var_0_1))
	Dialog.onCreate(arg_2_0)
end

function var_0_3.onChangeData(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = gGameModel.cards:find(arg_4_2.dbid)

	arg_4_0.cardDatas:atproxy(arg_4_1).lock = var_4_0:read("locked")
end

function var_0_3.onCellClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = itertools.size(arg_5_0.selected)
	local var_5_1 = arg_5_0.from == 2 and var_0_1 or var_0_2

	if not arg_5_3.isSel and var_5_1 <= var_5_0 then
		gGameUI:showTip(string.format(gLanguageCsv.selectedmax, var_5_1))

		return
	end

	local function var_5_2()
		arg_5_0.selected[arg_5_2.k] = arg_5_3

		if arg_5_0.handlers then
			arg_5_0.handlers(arg_5_0.selected)
		end

		arg_5_0:onClose()
	end

	local function var_5_3()
		if arg_5_3.lock then
			local var_7_0 = arg_5_0.from == 1 and gLanguageCsv.reborn or gLanguageCsv.decomposeText
			local var_7_1 = {
				btnType = 2,
				clearFast = true,
				cb = function()
					gGameUI:stackUI("city.card.strengthen", nil, {
						full = true
					}, 1, arg_5_3.dbid, arg_5_0:createHandler("onChangeData", arg_5_2.k, arg_5_3))
				end,
				content = string.format(gLanguageCsv.gotoUnLock, var_7_0)
			}

			gGameUI:showDialog(var_7_1)

			return true
		end
	end

	local function var_5_4()
		if arg_5_3.battle == 1 then
			if arg_5_0.from == 1 then
				local var_9_0 = {
					btnType = 2,
					cb = var_5_2,
					content = gLanguageCsv.sureRebirth
				}

				gGameUI:showDialog(var_9_0)
			else
				local var_9_1 = {
					crossCraft = "inCrossCraftCantDecompose",
					crossunionfight = "inCrossUnionBattleNotDecompose",
					crossGymLeader = "inCrossGymCantDecompose",
					battle = "inCityTeamCantDecompose",
					crossMine = "inCrossMineCantDecompose",
					unionTraining = "isInUnionCantDecompose",
					gymBadgeGuard = "inGymBadgeGuardCantDecompose",
					unionFight = "inUnionFightCantDecompose",
					craft = "inCraftCantDecompose",
					arena = "inArenaCantDecompose",
					crossArena = "inCrossArenaCantDecompose",
					gymLeader = "inGymCantDecompose",
					cloneBattle = "inCloneBattleCantDecompose"
				}
				local var_9_2 = gLanguageCsv[var_9_1[arg_5_3.battleType]]

				gGameUI:showTip(var_9_2)
			end

			return true
		end
	end

	if arg_5_0.from == 1 then
		if var_5_3() then
			return
		end

		if var_5_4() then
			return
		end

		var_5_2()
	else
		if var_5_4() then
			return
		end

		if var_5_3() then
			return
		end

		local var_5_5 = csv.cards[arg_5_3.id]

		if arg_5_3.isSel then
			arg_5_0.cardDatas:atproxy(arg_5_2.k).isSel = false
			arg_5_0.selected[arg_5_2.k] = nil

			local var_5_6 = itertools.size(arg_5_0.selected)

			arg_5_0.textNum:text(string.format("%s/%s", var_5_6, var_0_1))
			adapt.oneLinePos(arg_5_0.textNote, arg_5_0.textNum, nil, "left")
		else
			local var_5_7 = ""
			local var_5_8 = false

			if arg_5_3.cardType == 2 then
				var_5_8 = true
				var_5_7 = gLanguageCsv.materialWizardBeenSelected
			elseif arg_5_3.rarity >= 3 then
				var_5_8 = true
				var_5_7 = gLanguageCsv.sureDecomposeCard
			elseif arg_5_3.star > var_5_5.star then
				var_5_8 = true
				var_5_7 = gLanguageCsv.higherStarContinueDecomposition
			end

			local function var_5_9()
				arg_5_0.cardDatas:atproxy(arg_5_2.k).isSel = true
				arg_5_0.selected[arg_5_2.k] = arg_5_3

				local var_10_0 = itertools.size(arg_5_0.selected)

				arg_5_0.textNum:text(string.format("%s/%s", var_10_0, var_0_1))
				adapt.oneLinePos(arg_5_0.textNote, arg_5_0.textNum, nil, "left")
			end

			if var_5_8 then
				local var_5_10 = {
					btnType = 2,
					cb = var_5_9,
					content = var_5_7
				}

				gGameUI:showDialog(var_5_10)
			else
				var_5_9()
			end
		end
	end
end

function var_0_3.onSure(arg_11_0)
	if arg_11_0.handlers then
		arg_11_0.handlers(arg_11_0.selected)
	end

	arg_11_0:onClose()
end

return var_0_3
