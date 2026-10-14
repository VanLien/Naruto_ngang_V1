local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("ZawakeChoosCardView", Dialog)

local function var_0_2(arg_1_0)
	local var_1_0 = gGameModel.role:read("card_deployment")

	for iter_1_0, iter_1_1 in pairs(var_1_0.union_training.cards or {}) do
		if iter_1_1 == arg_1_0 then
			return true
		end
	end

	return false
end

var_0_1.RESOURCE_FILENAME = "zawake_choose_card.json"
var_0_1.RESOURCE_BINDING = {
	chooseItem = "item",
	["title.textNote2"] = "textNote2",
	innerList = "innerList",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	tipPanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("showTip")
		}
	},
	list = {
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
				dataOrderCmp = function(arg_2_0, arg_2_1)
					if arg_2_0.battle ~= arg_2_1.battle then
						return arg_2_0.battle == 2
					end

					if arg_2_0.rarity ~= arg_2_1.rarity then
						return arg_2_0.rarity < arg_2_1.rarity
					end

					if arg_2_0.id ~= arg_2_1.id then
						return arg_2_0.id < arg_2_1.id
					end

					return arg_2_0.fight < arg_2_1.fight
				end,
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1:get("head"), {
						class = "card_icon",
						props = {
							unitId = arg_3_3.unitId,
							advance = arg_3_3.advance,
							star = arg_3_3.star,
							rarity = arg_3_3.rarity,
							levelProps = {
								data = arg_3_3.level
							}
						}
					})

					local var_3_0 = gLanguageCsv.inTheTeam

					if arg_3_3.battle == 1 and ui.CARD_USING_TXTS[arg_3_3.battleType] then
						var_3_0 = gLanguageCsv[ui.CARD_USING_TXTS[arg_3_3.battleType]]
					end

					local var_3_1 = arg_3_1:get("battle.textNote")

					var_3_1:text(var_3_0)
					uiEasy.addTextEffect1(var_3_1)
					arg_3_1:get("textName"):text(csv.cards[arg_3_3.id].name)
					arg_3_1:get("textFightPoint"):text(arg_3_3.fight)
					arg_3_1:get("imgLock"):visible(arg_3_3.lock)
					arg_3_1:get("imgTick"):visible(arg_3_3.isSel)
					arg_3_1:get("imgMask"):visible(arg_3_3.battle == 1 or arg_3_3.isSel)
					arg_3_1:get("battle"):visible(arg_3_3.battle == 1)
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2, arg_3_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSelectClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.selectCardDbId = arg_4_1.selectCardDbId

	local var_4_0 = arg_4_1.fragID

	arg_4_0.cardDatas = idlers.new({})
	arg_4_0.cb = arg_4_2
	arg_4_0.showTip = idler.new(false)
	arg_4_0.exchangeCfg = csv.zawake.exchange[var_4_0]

	local var_4_1 = gLanguageCsv.card
	local var_4_2 = arg_4_0:getSelectCard(arg_4_0.selectCardDbId:read())

	arg_4_0.cardDatas:update(var_4_2)
	arg_4_0.showTip:set(itertools.size(var_4_2) == 0)
	arg_4_0.textNote2:text(var_4_1)
	Dialog.onCreate(arg_4_0)
end

function var_0_1.getSelectCard(arg_5_0, arg_5_1)
	local var_5_0 = {}
	local var_5_1 = csv.cards
	local var_5_2 = csv.unit
	local var_5_3 = dataEasy.inUsingCardsHash()
	local var_5_4 = gGameModel.role:read("cards")

	for iter_5_0, iter_5_1 in ipairs(var_5_4) do
		local var_5_5 = gGameModel.cards:find(iter_5_1)
		local var_5_6 = var_5_5:read("card_id")
		local var_5_7 = var_5_5:read("skin_id")
		local var_5_8 = var_5_1[var_5_6]
		local var_5_9 = var_5_2[var_5_8.unitID]
		local var_5_10 = dataEasy.getUnitId(var_5_6, var_5_7)

		if var_5_5:read("star") == var_5_8.star then
			for iter_5_2, iter_5_3 in csvMapPairs(arg_5_0.exchangeCfg.needCards) do
				if iter_5_3[1] == var_5_9.rarity and (iter_5_3[2] == -1 or iter_5_3[2] == var_5_9.natureType or iter_5_3[2] == var_5_9.natureType2) then
					var_5_0[iter_5_1] = {
						id = var_5_6,
						unitId = var_5_10,
						rarity = var_5_9.rarity,
						fight = var_5_5:read("fighting_point"),
						level = var_5_5:read("level"),
						star = var_5_5:read("star"),
						advance = var_5_5:read("advance"),
						dbid = iter_5_1,
						lock = var_5_5:read("locked"),
						battle = var_5_3[iter_5_1] and 1 or 2,
						battleType = var_5_3[iter_5_1],
						isUnion = var_0_2(iter_5_1),
						isSel = arg_5_1 == iter_5_1,
						cardType = var_5_8.cardType
					}
				end
			end

			for iter_5_4, iter_5_5 in csvMapPairs(arg_5_0.exchangeCfg.needSpecialCards) do
				if iter_5_5 == var_5_8.cardMarkID then
					var_5_0[iter_5_1] = {
						id = var_5_6,
						unitId = var_5_10,
						rarity = var_5_9.rarity,
						fight = var_5_5:read("fighting_point"),
						level = var_5_5:read("level"),
						star = var_5_5:read("star"),
						advance = var_5_5:read("advance"),
						dbid = iter_5_1,
						lock = var_5_5:read("locked"),
						battle = var_5_3[iter_5_1] and 1 or 2,
						battleType = var_5_3[iter_5_1],
						isUnion = var_0_2(iter_5_1),
						isSel = curSle == iter_5_1,
						cardType = var_5_8.cardType
					}
				end
			end
		end
	end

	return var_5_0
end

function var_0_1.onSelectClick(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_3.isSel then
		return
	end

	local function var_6_0()
		if arg_6_3.lock then
			local var_7_0 = gLanguageCsv.starSkillExchange
			local var_7_1 = {
				btnType = 2,
				clearFast = true,
				cb = function()
					gGameUI:stackUI("city.card.strengthen", nil, {
						full = true
					}, 1, arg_6_3.dbid, arg_6_0:createHandler("onChangeData", arg_6_2, arg_6_3))
				end,
				content = string.format(gLanguageCsv.gotoUnLock, var_7_0)
			}

			gGameUI:showDialog(var_7_1)

			return true
		end
	end

	if (function()
		if arg_6_3.battle == 1 then
			local var_9_0 = {
				crossCraft = "inCrossCraftCantExchange",
				battle = "inCityTeamCantExchange",
				crossGymLeader = "inCrossGymCantExchange",
				crossMine = "inCrossMineCantExchange",
				unionTraining = "isInUnionCantExchange",
				gymBadgeGuard = "inGymBadgeGuardCantExchange",
				unionFight = "inUnionFightCantExchange",
				craft = "inCraftCantExchange",
				arena = "inArenaCantExchange",
				crossArena = "inCrossArenaCantExchange",
				gymLeader = "inGymCantExchange",
				cloneBattle = "inCloneBattleCantExchange"
			}
			local var_9_1 = gLanguageCsv[var_9_0[arg_6_3.battleType]]

			gGameUI:showTip(var_9_1)

			return true
		end
	end)() then
		return
	end

	if var_6_0() then
		return
	end

	local var_6_1 = csv.cards[arg_6_3.id]
	local var_6_2

	if arg_6_3.level > 1 or arg_6_3.advance > 1 or arg_6_3.star > var_6_1.star then
		var_6_2 = gLanguageCsv.selectCardMaterialsMega
	end

	local function var_6_3()
		arg_6_0.selectCardDbId:set(arg_6_3.dbid)
		var_0_0.onClose(arg_6_0)
	end

	if var_6_2 then
		gGameUI:showDialog({
			fontSize = 50,
			btnType = 2,
			isRich = true,
			title = gLanguageCsv.spaceTips,
			content = var_6_2,
			cb = var_6_3
		})

		return
	end

	var_6_3()
end

function var_0_1.onChangeData(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = gGameModel.cards:find(arg_11_2.dbid)

	arg_11_0.cardDatas:atproxy(arg_11_2.dbid).lock = var_11_0:read("locked")
end

return var_0_1
