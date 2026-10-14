local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardEmbattleReady", Dialog)

var_0_1.RESOURCE_FILENAME = "card_embattle_ready.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	btnClose = {
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
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("battleDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("list", "node", "name", "btnGHimg", "power", "powerText", "btnChangeName", "btnSure", "btnFormation", "btnClear")

					var_1_0.name:text(arg_1_3.name)

					if arg_1_3.teamBuffs then
						var_1_0.btnGHimg:texture(arg_1_3.teamBuffs.buf.imgPath)
					end

					var_1_0.powerText:text(arg_1_3.getFightSumNum)

					if arg_1_3.getFightSumNum > 99999 then
						local var_1_1 = var_1_0.powerText:size()

						var_1_0.powerText:scale(240 / var_1_1.width)
					end

					var_1_0.btnClear:setTouchEnabled(arg_1_3.state)
					var_1_0.btnSure:setTouchEnabled(arg_1_3.state)
					text.deleteAllEffect(var_1_0.btnSure:get("textNote"))

					if arg_1_3.state then
						cache.setShader(var_1_0.btnClear, false, "normal")
						cache.setShader(var_1_0.btnSure, false, "normal")
						text.addEffect(var_1_0.btnSure:get("textNote"), {
							color = ui.COLORS.NORMAL.WHITE,
							glow = {
								color = ui.COLORS.GLOW.WHITE
							}
						})
					else
						cache.setShader(var_1_0.btnClear, false, "hsl_gray")
						cache.setShader(var_1_0.btnSure, false, "hsl_gray")
						text.addEffect(var_1_0.btnSure:get("textNote"), {
							color = ui.COLORS.DISABLED.WHITE
						})
					end

					var_1_0.list:removeAllItems()
					var_1_0.list:setScrollBarEnabled(false)

					for iter_1_0 = 1, 6 do
						local var_1_2 = var_1_0.node:clone()

						var_1_2:visible(true)
						var_1_2:setTouchEnabled(true)
						bind.touch(arg_1_0, var_1_2, {
							methods = {
								ended = functools.partial(arg_1_0.formationClickCell, arg_1_2, arg_1_3)
							}
						})

						if arg_1_3.cardsData[iter_1_0] then
							local var_1_3 = dataEasy.getUnitId(arg_1_3.cardsData[iter_1_0]:read("card_id"), arg_1_3.cardsData[iter_1_0]:read("skin_id"))

							bind.extend(arg_1_0, var_1_2, {
								class = "card_icon",
								props = {
									unitId = var_1_3,
									advance = arg_1_3.cardsData[iter_1_0]:read("advance"),
									rarity = arg_1_3.cardsData[iter_1_0]:read("rarity"),
									star = arg_1_3.cardsData[iter_1_0]:read("star"),
									levelProps = {
										data = arg_1_3.cardsData[iter_1_0]:read("level")
									}
								}
							})
							var_1_2:get("bg"):visible(false)
						end

						var_1_0.list:pushBackCustomItem(var_1_2)
					end

					bind.touch(arg_1_0, var_1_0.btnClear, {
						methods = {
							ended = functools.partial(arg_1_0.clearClickCell, arg_1_2, arg_1_3)
						}
					})
					bind.touch(arg_1_0, var_1_0.btnFormation, {
						methods = {
							ended = functools.partial(arg_1_0.formationClickCell, arg_1_2, arg_1_3)
						}
					})
					bind.touch(arg_1_0, var_1_0.btnSure, {
						methods = {
							ended = functools.partial(arg_1_0.sureClickCell, arg_1_2, arg_1_3)
						}
					})
					bind.touch(arg_1_0, var_1_0.btnGHimg, {
						methods = {
							ended = functools.partial(arg_1_0.teamBuffClickCell, arg_1_2, arg_1_3)
						}
					})
					bind.touch(arg_1_0, var_1_0.btnChangeName, {
						methods = {
							ended = functools.partial(arg_1_0.changeNameClickCell, arg_1_2, arg_1_3)
						}
					})
				end
			},
			handlers = {
				sureClickCell = bindHelper.self("onSureClick"),
				clearClickCell = bindHelper.self("onClearClick"),
				formationClickCell = bindHelper.self("onFormationClick"),
				teamBuffClickCell = bindHelper.self("onTeamBuffClick"),
				changeNameClickCell = bindHelper.self("onChangeNameClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.params = arg_2_1

	arg_2_0:initModel()

	arg_2_0.battleDatas = idlers.newWithMap({})

	idlereasy.when(arg_2_0.ready_cards, function(arg_3_0, arg_3_1)
		local var_3_0 = {}

		for iter_3_0 = 1, gCommonConfigCsv.embattleReadyMax do
			local var_3_1 = {}
			local var_3_2 = true
			local var_3_3 = gLanguageCsv["team" .. iter_3_0]
			local var_3_4
			local var_3_5 = 0
			local var_3_6 = arg_3_1[iter_3_0] and arg_3_1[iter_3_0].cards or {}
			local var_3_7 = dataEasy.fixInMeteorCards(var_3_6)

			if arg_3_1[iter_3_0] then
				for iter_3_1, iter_3_2 in pairs(var_3_7) do
					var_3_2 = false
					var_3_1[iter_3_1] = arg_2_0:getCardAttr(iter_3_2)
				end

				var_3_4 = arg_2_0:refreshTeamBuff(var_3_7)
				var_3_5 = arg_2_0:getFightSumNum(var_3_7)

				if arg_3_1[iter_3_0].name and arg_3_1[iter_3_0].name ~= "" then
					var_3_3 = arg_3_1[iter_3_0].name
				end
			end

			table.insert(var_3_0, {
				cards = var_3_7,
				cardsData = var_3_1,
				name = var_3_3,
				state = not var_3_2,
				getFightSumNum = var_3_5,
				teamBuffs = var_3_4
			})
		end

		dataEasy.tryCallFunc(arg_2_0.list, "updatePreloadCenterIndex")
		arg_2_0.battleDatas:update(var_3_0)
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_1.initModel(arg_4_0)
	arg_4_0.ready_cards = gGameModel.role:getIdler("ready_cards")
end

function var_0_1.getCardAttr(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_2 then
		return gGameModel.cards:find(arg_5_1):read(arg_5_2)
	else
		return gGameModel.cards:find(arg_5_1)
	end
end

function var_0_1.getFightSumNum(arg_6_0, arg_6_1)
	local var_6_0 = 0

	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		var_6_0 = var_6_0 + arg_6_0:getCardAttr(iter_6_1, "fighting_point")
	end

	return var_6_0
end

function var_0_1.refreshTeamBuff(arg_7_0, arg_7_1)
	local var_7_0 = {}

	for iter_7_0 = 1, 6 do
		local var_7_1 = arg_7_1[iter_7_0]

		if var_7_1 then
			local var_7_2 = arg_7_0:getCardAttr(var_7_1, "card_id")
			local var_7_3 = csv.cards[var_7_2]
			local var_7_4 = csv.unit[var_7_3.unitID]

			var_7_0[iter_7_0] = {
				var_7_4.natureType,
				var_7_4.natureType2
			}
		end
	end

	return dataEasy.getTeamBuffBest(var_7_0)
end

function var_0_1.onSureClick(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local function var_8_0()
		gGameUI:showTip(gLanguageCsv.teamSaveSuccess)
		var_0_0.onClose(arg_8_0)
	end

	arg_8_0.params.cb(table.deepcopy(arg_8_3.cards, true), var_8_0)
end

function var_0_1.onClearClick(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	gGameUI:showDialog({
		btnType = 2,
		content = gLanguageCsv.teamClear,
		cb = function()
			gGameApp:requestServer("/game/ready/card/deploy", function(arg_12_0)
				gGameUI:showTip(gLanguageCsv.positionSave)
			end, arg_10_2, {})
		end
	})
end

function var_0_1.onFormationClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	gGameUI:stackUI("city.card.embattle.base", nil, {
		full = true
	}, {
		sceneType = arg_13_0.params.sceneType,
		from = game.EMBATTLE_FROM_TABLE.ready,
		inputCards = idlertable.new(arg_13_3.cards),
		readyIdx = arg_13_2
	})
end

function var_0_1.onTeamBuffClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_3.teamBuffs and arg_14_3.teamBuffs.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_14_0)
end

function var_0_1.onChangeNameClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	gGameUI:stackUI("city.card.changename", nil, nil, {
		cost = 0,
		typ = "ready",
		maxFontCount = 7,
		name = arg_15_3.name,
		titleTxt = gLanguageCsv.changeReadyName,
		requestParams = {
			arg_15_2
		},
		cb = function(arg_16_0)
			arg_15_0.battleDatas:atproxy(arg_15_2).name = arg_16_0
		end
	})
end

return var_0_1
