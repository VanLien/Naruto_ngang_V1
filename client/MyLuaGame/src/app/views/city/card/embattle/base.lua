local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardEmbattleView", var_0_0)
local var_0_2 = {
	{
		pos = cc.p(0, 0),
		size = cc.size(450, 250)
	},
	{
		pos = cc.p(0, 0),
		size = cc.size(500, 250)
	},
	{
		pos = cc.p(0, 0),
		size = cc.size(500, 250)
	},
	{
		pos = cc.p(0, 0),
		size = cc.size(450, 250)
	},
	{
		pos = cc.p(0, 0),
		size = cc.size(500, 250)
	},
	{
		pos = cc.p(0, 0),
		size = cc.size(500, 250)
	}
}
local var_0_3 = {
	2,
	4,
	6,
	1,
	3,
	5
}
local var_0_4 = {
	[game.EMBATTLE_FROM_TABLE.default] = {
		initModelFunc = function(arg_1_0)
			return gGameModel.role:getIdler("battle_cards")
		end,
		getSendRequest = function(arg_2_0)
			if arg_2_0.clientBattleCards:size() == 0 then
				return
			end

			return gGameApp:requestServerCustom("/game/battle/card"):params(arg_2_0.clientBattleCards)
		end
	},
	[game.EMBATTLE_FROM_TABLE.arena] = {
		initModelFunc = function(arg_3_0)
			local var_3_0 = idlertable.new({})

			idlereasy.when(gGameModel.arena:getIdler("record"), function(arg_4_0, arg_4_1)
				local var_4_0 = {}
				local var_4_1 = arg_3_0.fightCb and arg_4_1.cards or arg_4_1.defence_cards

				var_3_0:set(var_4_1)
			end)

			return var_3_0
		end,
		getSendRequest = function(arg_5_0)
			if arg_5_0.fightCb then
				return gGameApp:requestServerCustom("/game/pw/battle/deploy"):params(arg_5_0.clientBattleCards)
			else
				return gGameApp:requestServerCustom("/game/pw/battle/deploy"):params(nil, arg_5_0.clientBattleCards)
			end
		end
	},
	[game.EMBATTLE_FROM_TABLE.huodong] = {
		initModelFunc = function(arg_6_0)
			local var_6_0 = idlertable.new({})

			idlereasy.when(gGameModel.role:getIdler("huodong_cards"), function(arg_7_0, arg_7_1)
				if not arg_7_1[arg_6_0.fromId] then
					local var_7_0 = gGameModel.role:read("battle_cards")
					local var_7_1 = {}

					for iter_7_0, iter_7_1 in pairs(var_7_0) do
						local var_7_2 = gGameModel.cards:find(iter_7_1)

						if var_7_2 then
							local var_7_3 = var_7_2:read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time")

							if arg_6_0:limtFunc(iter_7_1, var_7_3.card_id, var_7_3.skin_id, var_7_3.fighting_point, var_7_3.level, var_7_3.star, var_7_3.advance, var_7_3.created_time, 1) then
								var_7_1[iter_7_0] = iter_7_1
							end
						end
					end

					var_6_0:set(var_7_1)
				else
					var_6_0:set(arg_7_1[arg_6_0.fromId])
				end
			end)

			return var_6_0
		end,
		getSendRequest = function(arg_8_0)
			return gGameApp:requestServerCustom("/game/huodong/card"):params(arg_8_0.fromId, arg_8_0.clientBattleCards)
		end
	},
	[game.EMBATTLE_FROM_TABLE.input] = {
		initModelFunc = function(arg_9_0)
			return arg_9_0.inputCards
		end,
		getSendRequest = function(arg_10_0)
			return
		end
	},
	[game.EMBATTLE_FROM_TABLE.gymChallenge] = {
		initModelFunc = function(arg_11_0)
			local var_11_0 = userDefault.getForeverLocalKey("gym_emabttle" .. arg_11_0.gymId, {})
			local var_11_1 = dataEasy.fixInMeteorCards(var_11_0)

			local function var_11_2()
				local var_12_0 = {}

				for iter_12_0, iter_12_1 in pairs(var_11_1) do
					if var_12_0[iter_12_1] then
						return true
					end

					var_12_0[iter_12_1] = true
				end

				return false
			end

			if itertools.size(var_11_1) == 0 or var_11_2() then
				local var_11_3 = gGameModel.role:read("battle_cards")

				return idlertable.new(table.shallowcopy(var_11_3))
			else
				local var_11_4 = gGameModel.role:read("cards")
				local var_11_5 = {}
				local var_11_6 = itertools.map(var_11_4, function(arg_13_0, arg_13_1)
					return arg_13_1, arg_13_0
				end)

				for iter_11_0, iter_11_1 in pairs(var_11_1) do
					local var_11_7 = stringz.hextobin(iter_11_1)

					if var_11_6[var_11_7] then
						var_11_5[iter_11_0] = var_11_7
					end
				end

				return idlertable.new(var_11_5)
			end

			return battleCards
		end,
		getSendRequest = function(arg_14_0)
			return
		end
	},
	[game.EMBATTLE_FROM_TABLE.onekey] = {
		initModelFunc = function(arg_15_0)
			return idlertable.new({})
		end,
		getSendRequest = function(arg_16_0)
			return
		end
	},
	[game.EMBATTLE_FROM_TABLE.onlineFight] = {
		initModelFunc = function(arg_17_0)
			return gGameModel.cross_online_fight:getIdler("cards")
		end,
		getSendRequest = function(arg_18_0)
			return gGameApp:requestServerCustom("/game/cross/online/deploy"):params(arg_18_0.clientBattleCards, 1)
		end
	},
	[game.EMBATTLE_FROM_TABLE.huodongBoss] = {
		initModelFunc = function(arg_19_0)
			local var_19_0 = userDefault.getForeverLocalKey("huodongboss_emabttle", {})
			local var_19_1 = dataEasy.fixInMeteorCards(var_19_0)

			if var_19_1 == nil or itertools.size(var_19_1) == 0 then
				local var_19_2 = gGameModel.role:read("battle_cards")

				return idlertable.new(table.shallowcopy(var_19_2))
			else
				local var_19_3 = gGameModel.role:read("cards")
				local var_19_4 = {}
				local var_19_5 = itertools.map(var_19_3, function(arg_20_0, arg_20_1)
					return arg_20_1, arg_20_0
				end)

				for iter_19_0, iter_19_1 in pairs(var_19_1) do
					local var_19_6 = stringz.hextobin(iter_19_1)

					if var_19_5[var_19_6] then
						var_19_4[iter_19_0] = var_19_6
					end
				end

				return idlertable.new(var_19_4)
			end
		end,
		getSendRequest = function(arg_21_0)
			return
		end
	},
	[game.EMBATTLE_FROM_TABLE.ready] = {
		initModelFunc = function(arg_22_0)
			return arg_22_0.inputCards
		end,
		getSendRequest = function(arg_23_0)
			return
		end
	},
	[game.EMBATTLE_FROM_TABLE.hunting] = {
		initModelFunc = function(arg_24_0)
			local var_24_0 = gGameModel.hunting:read("hunting_route")[arg_24_0.route].cards or {}
			local var_24_1 = gGameModel.hunting:read("hunting_route")[arg_24_0.route].card_states or {}

			if itertools.size(var_24_1) == 0 then
				local var_24_2 = table.deepcopy(gGameModel.role:read("battle_cards"), true)

				for iter_24_0, iter_24_1 in pairs(var_24_2) do
					local var_24_3 = gGameModel.cards:find(iter_24_1)

					if var_24_3 and var_24_3:read("level") < 10 then
						var_24_2[iter_24_0] = nil
					end
				end

				return idlertable.new(table.shallowcopy(var_24_2))
			else
				local var_24_4 = gGameModel.role:read("cards")
				local var_24_5 = {}
				local var_24_6 = itertools.map(var_24_4, function(arg_25_0, arg_25_1)
					return arg_25_1, arg_25_0
				end)

				for iter_24_2, iter_24_3 in pairs(var_24_0) do
					if var_24_6[iter_24_3] then
						var_24_5[iter_24_2] = iter_24_3
					end
				end

				return idlertable.new(var_24_5)
			end
		end,
		getSendRequest = function(arg_26_0)
			local var_26_0 = gGameModel.hunting:read("hunting_route")[arg_26_0.route].node or 1

			return gGameApp:requestServerCustom("/game/hunting/battle/deploy"):params(arg_26_0.route, var_26_0, arg_26_0.clientBattleCards)
		end
	}
}

local function var_0_5(arg_27_0, arg_27_1, ...)
	local var_27_0 = var_0_4[arg_27_0.from]
	local var_27_1 = var_0_4[game.EMBATTLE_FROM_TABLE.default]

	return (var_27_0[arg_27_1] or var_27_1[arg_27_1])(arg_27_0, ...)
end

var_0_1.RESOURCE_FILENAME = "card_embattle.json"
var_0_1.RESOURCE_BINDING = {
	fightNote = "fightNote",
	dailyGateTipsPos = "dailyGateTipsPos",
	textNotRole = "emptyTxt",
	bottomPanel = "bottomPanel",
	textLimit = "textLimit",
	battlePanel = "battlePanel",
	rightDown = "rightDown",
	bottomMask = "bottomMask",
	["fightNote.textFightPoint"] = "textFightPoint",
	spritePanel = "spriteItem",
	btnGHimg = {
		varname = "btnGHimg",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick")
			}
		}
	},
	btnJump = {
		varname = "btnJump",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("cardBagBtn")
			}
		}
	},
	btnChallenge = {
		varname = "btnChallenge",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("fightBtn")
			}
		}
	},
	["ahead.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["behind.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["btnJump.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightDown.btnOneKeySet"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEmbattleBtn")
			}
		}
	},
	["rightDown.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("battleNum")
		}
	},
	["rightDown.btnOneKeySet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	btnReady = {
		varname = "btnReady",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneReadyBtn")
			}
		}
	},
	["btnReady.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightDown.btnSaveReady"] = {
		varname = "btnSaveReady",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneSaveReadyBtn")
			}
		}
	},
	["rightDown.btnSaveReady.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_28_0, arg_28_1)
	arg_28_1 = arg_28_1 or {}

	arg_28_0.spriteItem:get("attrBg"):hide()
	arg_28_0:initDefine()
	arg_28_0.btnJump:z(5)
	gGameUI.topuiManager:createView("title", arg_28_0, {
		onClose = arg_28_0:createHandler("onClose", true)
	}):init({
		subTitle = "",
		title = arg_28_1.readyIdx and "common/txt/img_bz_duiwuyushe.png" or "common/txt/txt_bt_buzhen.png"
	})
	arg_28_0:initParams(arg_28_1)
	arg_28_0:initModel(arg_28_1)
	arg_28_0:initReadTeam(arg_28_1)
	arg_28_0:checkTeamBuffOpen()
	arg_28_0:initHeroSprite()
	arg_28_0:initBottomList()
	arg_28_0:initRoundUIPanel()

	if arg_28_0.startCb then
		local var_28_0 = arg_28_0.startCb(arg_28_0)

		if var_28_0 then
			arg_28_0.clientBattleCards:set(var_28_0)
		end
	end
end

function var_0_1.initDefine(arg_29_0)
	arg_29_0.embattleMax = 6
	arg_29_0.panelNum = 6
end

function var_0_1.initParams(arg_30_0, arg_30_1)
	arg_30_0.route = arg_30_1.route
	arg_30_0.inputCards = arg_30_1.inputCards
	arg_30_0.sceneType = arg_30_1.sceneType or -1
	arg_30_0.from = arg_30_1.from or game.EMBATTLE_FROM_TABLE.default
	arg_30_0.fightCb = arg_30_1.fightCb
	arg_30_0.fromId = arg_30_1.fromId
	arg_30_0.startCb = arg_30_1.startCb
	arg_30_0.checkBattleArr = arg_30_1.checkBattleArr or function()
		return true
	end
end

function var_0_1.resetBtnPos(arg_32_0)
	if not arg_32_0.cardListView.bagFilter or not arg_32_0.cardListView.btnPanel then
		return
	end

	local var_32_0, var_32_1 = arg_32_0.cardListView.bagFilter:xy()

	arg_32_0.cardListView.bagFilter:xy(var_32_0 - 65, var_32_1 + 15)
	arg_32_0.cardListView.btnPanel:xy(arg_32_0.cardListView.btnPanel:x() + 40, arg_32_0.cardListView.btnPanel:y() - 25)
end

function var_0_1.initBottomList(arg_33_0)
	arg_33_0.cardListView = gGameUI:createView("city.card.embattle.embattle_card_list", arg_33_0.bottomPanel):init({
		base = arg_33_0,
		clientBattleCards = arg_33_0.clientBattleCards,
		battleCardsData = arg_33_0.battleCardsData,
		deleteMovingItem = arg_33_0.deleteMovingItem,
		createMovePanel = arg_33_0.createMovePanel,
		moveMovePanel = arg_33_0.moveMovePanel,
		isMovePanelExist = arg_33_0.isMovePanelExist,
		onCardClick = arg_33_0.onCardClick,
		allCardDatas = arg_33_0.allCardDatas,
		moveEndMovePanel = arg_33_0.moveEndMovePanel,
		limtFunc = arg_33_0.limtFunc
	}, true)

	local var_33_0 = arg_33_0.cardListView:y()

	arg_33_0.cardListView:y(var_33_0 - 25)
	arg_33_0.cardListView.btnPanel:y(arg_33_0.cardListView.btnPanel:y() + 25)
end

function var_0_1.getCardAttr(arg_34_0, arg_34_1, arg_34_2)
	return gGameModel.cards:find(arg_34_1):read(arg_34_2)
end

function var_0_1.getCardAttrIdler(arg_35_0, arg_35_1, arg_35_2)
	return gGameModel.cards:find(arg_35_1):getIdler(arg_35_2)
end

function var_0_1.resetBattleCardsCallBack(arg_36_0)
	local var_36_0 = {}

	for iter_36_0, iter_36_1 in pairs(arg_36_0.clientBattleCards:read()) do
		table.insert(var_36_0, arg_36_0:getCardAttrIdler(iter_36_1, "nature_choose"))
	end

	idlereasy.any(var_36_0, function(...)
		arg_36_0.clientBattleCards:notify()
	end):anonyOnly(arg_36_0, "BattleCardsChangeCallback")
end

function var_0_1.initModel(arg_38_0)
	arg_38_0.cards = gGameModel.role:getIdler("cards")
	arg_38_0.allCardDatas = idlers.new({})
	arg_38_0.battleCardsData = var_0_5(arg_38_0, "initModelFunc")
	arg_38_0.clientBattleCards = idlertable.new({})
	arg_38_0.fightSumNum = idler.new(0)
	arg_38_0.battleNum = idler.new("")
	arg_38_0.selectIndex = idler.new()
	arg_38_0.draggingIndex = idler.new(0)

	local var_38_0 = {}
	local var_38_1 = 0

	idlereasy.when(arg_38_0.battleCardsData, function(arg_39_0, arg_39_1)
		var_38_0 = {}
		var_38_1 = itertools.size(arg_39_1)

		for iter_39_0, iter_39_1 in pairs(arg_39_1) do
			local var_39_0 = gGameModel.cards:find(iter_39_1)

			if var_39_0 then
				local var_39_1 = var_39_0:multigetIdler("card_id")

				idlereasy.when(var_39_1, function(arg_40_0, arg_40_1)
					var_38_0[iter_39_0] = true

					if itertools.size(var_38_0) == var_38_1 then
						arg_38_0.clientBattleCards:set(clone(arg_39_1), true)
						arg_38_0:resetBattleCardsCallBack()
					end
				end):anonyOnly(arg_38_0, stringz.bintohex(iter_39_1))
			end
		end
	end)
end

function var_0_1.getFightSumNum(arg_41_0, arg_41_1)
	local var_41_0 = 0

	for iter_41_0, iter_41_1 in pairs(arg_41_1) do
		var_41_0 = var_41_0 + arg_41_0:getCardAttr(iter_41_1, "fighting_point")
	end

	return var_41_0
end

function var_0_1.sendRequeat(arg_42_0, arg_42_1, arg_42_2)
	if not itertools.equal(arg_42_0.battleCardsData:read(), arg_42_0.clientBattleCards:read()) then
		if not arg_42_0.checkBattleArr(arg_42_0.clientBattleCards:read()) then
			if arg_42_2 then
				arg_42_1()
			else
				gGameUI:showTip(gLanguageCsv.lineupInconsistency)
			end

			return
		end

		local var_42_0 = var_0_5(arg_42_0, "getSendRequest")

		if not var_42_0 then
			return arg_42_1()
		end

		if arg_42_2 then
			var_42_0:onBeforeSync(arg_42_1):doit()
		else
			var_42_0:doit(arg_42_1)
		end
	else
		arg_42_1()
	end
end

function var_0_1.initRoundUIPanel(arg_43_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_43_0.fightNote,
			"pos",
			"right"
		},
		{
			arg_43_0.btnChallenge,
			"pos",
			"right"
		},
		{
			arg_43_0.btnJump,
			"pos",
			"right"
		},
		{
			arg_43_0.rightDown,
			"pos",
			"right"
		}
	})

	local var_43_0 = arg_43_0.fightCb and true or false

	arg_43_0.rightDown:visible(not var_43_0)
	arg_43_0.btnChallenge:visible(var_43_0)
	arg_43_0.btnJump:visible(arg_43_0.from == game.EMBATTLE_FROM_TABLE.default)
end

function var_0_1.initReadTeam(arg_44_0, arg_44_1)
	arg_44_0.readyIdx = arg_44_1.readyIdx

	if arg_44_0.readyIdx then
		arg_44_0.btnSaveReady:visible(true)
	end

	local var_44_0 = arg_44_1.team and true or false
	local var_44_1 = dataEasy.isShow(gUnlockCsv.readyTeam)

	arg_44_0.btnReady:visible(var_44_1)

	if var_44_1 then
		arg_44_0.btnReady:visible(arg_44_0.from == game.EMBATTLE_FROM_TABLE.default or arg_44_0.from == game.EMBATTLE_FROM_TABLE.onlineFight or var_44_0)
	end

	uiEasy.updateUnlockRes(gUnlockCsv.readyTeam, arg_44_0.btnReady, {
		pos = cc.p(193, 62)
	})
end

function var_0_1.embattleBtnFunc(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0:getCardAttr(arg_45_2.dbid, "card_id")

	return not arg_45_1[csv.cards[var_45_0].cardMarkID] and not arg_45_2.inMeteor
end

function var_0_1.getOneKeyCardDatas(arg_46_0)
	local var_46_0 = itertools.values(arg_46_0.allCardDatas)

	table.sort(var_46_0, function(arg_47_0, arg_47_1)
		arg_47_0, arg_47_1 = arg_47_0:read(), arg_47_1:read()

		if arg_47_0.fighting_point == arg_47_1.fighting_point then
			return arg_47_0.rarity > arg_47_1.rarity
		else
			return arg_47_0.fighting_point > arg_47_1.fighting_point
		end
	end)

	local var_46_1 = {}
	local var_46_2 = {}
	local var_46_3 = 0

	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		iter_46_1 = iter_46_1:read()

		local var_46_4 = arg_46_0:getCardAttr(iter_46_1.dbid, "card_id")
		local var_46_5 = csv.cards[var_46_4]

		if arg_46_0:embattleBtnFunc(var_46_1, iter_46_1) then
			var_46_3 = var_46_3 + 1
			var_46_2[var_46_3] = iter_46_1.dbid
			var_46_1[var_46_5.cardMarkID] = {
				dbid = iter_46_1.dbid,
				fighting_point = iter_46_1.fighting_point,
				rarity = iter_46_1.rarity
			}

			if var_46_3 == arg_46_0.embattleMax then
				break
			end
		end
	end

	return var_46_2
end

function var_0_1.oneKeyEmbattleBtn(arg_48_0)
	local var_48_0 = arg_48_0:getOneKeyCardDatas()

	for iter_48_0, iter_48_1 in arg_48_0.clientBattleCards:pairs() do
		arg_48_0:getCardAttrs(iter_48_1).battle = 0
	end

	for iter_48_2, iter_48_3 in pairs(var_48_0) do
		arg_48_0:getCardAttrs(iter_48_3).battle = arg_48_0:getBattle(iter_48_2)
	end

	arg_48_0.clientBattleCards:set(var_48_0)
end

function var_0_1.initHeroSprite(arg_49_0)
	local var_49_0 = arg_49_0:convertToWorldSpace(cc.p(arg_49_0.battlePanel:x(), arg_49_0.battlePanel:y()))

	arg_49_0.offsetX = arg_49_0.battlePanel:x() - var_49_0.x
	arg_49_0.offsetY = arg_49_0.battlePanel:y() - var_49_0.y
	arg_49_0.heroSprite = {}

	for iter_49_0 = 1, arg_49_0.panelNum do
		local var_49_1 = arg_49_0.spriteItem:clone():addTo(arg_49_0.battlePanel, 10 + var_0_3[iter_49_0], "panel" .. iter_49_0)

		var_49_1:show()
		var_49_1:get("imgBg"):hide()

		local var_49_2, var_49_3 = arg_49_0.battlePanel:get("item" .. iter_49_0):xy()
		local var_49_4 = arg_49_0.battlePanel:get("item" .. iter_49_0):box()

		var_49_4.x = var_49_4.x - arg_49_0.offsetX
		var_49_4.y = var_49_4.y - arg_49_0.offsetY - 100
		arg_49_0.heroSprite[iter_49_0] = {
			sprite = var_49_1,
			posx = var_49_2,
			posy = var_49_3,
			box = var_49_4,
			idx = iter_49_0
		}
	end

	for iter_49_1 = 1, arg_49_0.panelNum do
		local var_49_5 = arg_49_0.battlePanel:get("item" .. iter_49_1, "pos")

		if var_0_2[iter_49_1] then
			local var_49_6 = var_0_2[iter_49_1].size
			local var_49_7 = var_0_2[iter_49_1].pos
			local var_49_8 = display.sizeInView.width / display.size.width
			local var_49_9 = display.sizeInView.height / display.size.height
			local var_49_10 = cc.size(var_49_8 * var_49_6.width, var_49_9 * var_49_6.height)
			local var_49_11 = cc.p(var_49_8 * var_49_7.x, var_49_9 * var_49_7.y)
			local var_49_12 = arg_49_0.battlePanel:get("item" .. iter_49_1)

			var_49_5:size(var_49_10):xy(var_49_12:size().width / 2 + var_49_11.x, var_49_12:size().height / 2 + var_49_11.y)
		end

		var_49_5:onTouch(functools.partial(arg_49_0.onBattleCardTouch, arg_49_0, iter_49_1))
	end

	local var_49_13 = {}

	idlereasy.when(arg_49_0.clientBattleCards, function(arg_50_0, arg_50_1)
		arg_49_0:refreshTeamBuff(arg_50_1)

		local var_50_0 = 0
		local var_50_1 = true

		for iter_50_0 = 1, arg_49_0.panelNum do
			local var_50_2 = arg_49_0.heroSprite[iter_50_0]
			local var_50_3 = var_50_2.idx

			var_50_2.sprite:xy(var_50_2.posx, var_50_2.posy):z(10 + var_0_3[iter_50_0])

			local var_50_4 = var_50_2.sprite:get("fightPoint")

			var_50_2.sprite:get("attrBg"):hide()

			if arg_50_1[iter_50_0] then
				var_50_0 = var_50_0 + 1

				local var_50_5 = arg_50_1[iter_50_0]

				if var_50_5 and arg_49_0:getCardAttrs(var_50_5) then
					arg_49_0:getCardAttrs(var_50_5).battle = arg_49_0:getBattle(iter_50_0)
				end

				local var_50_6 = arg_49_0:getCardAttr(var_50_5, "card_id")
				local var_50_7 = arg_49_0:getCardAttr(var_50_5, "skin_id")
				local var_50_8 = dataEasy.getUnitCsv(var_50_6, var_50_7)
				local var_50_9 = {
					dbid = var_50_5,
					card_id = var_50_6,
					skin_id = var_50_7
				}

				if not var_50_2.dbdata or not itertools.equal(var_50_2.dbdata, var_50_9) then
					var_50_2.sprite:get("icon"):removeAllChildren()
					widget.addAnimation(var_50_2.sprite:get("icon"), var_50_8.unitRes, "standby_loop", 11):scale(var_50_8.scale * 0.8):xy(50, 50):setSkin(var_50_8.skin)

					var_50_2.dbdata = var_50_9

					if arg_49_0.showItemFightPoint then
						arg_49_0:showItemFightPoint(var_50_4, var_50_8, var_50_5)
					end
				end

				if arg_49_0.buffOpen then
					local var_50_10 = arg_49_0.teamBuffs and arg_49_0.teamBuffs.flags or {
						1,
						1,
						1,
						1,
						1,
						1
					}

					uiEasy.setTeamBuffItem(var_50_2.sprite, var_50_6, var_50_10[iter_50_0])
				end
			elseif var_50_2.dbdata then
				var_50_2.sprite:get("icon"):removeAllChildren()

				var_50_2.dbdata = nil

				var_50_4:hide()
			end

			if not var_49_13[arg_50_1[iter_50_0]] and arg_50_1[iter_50_0] then
				var_50_1 = false
			end
		end

		if not var_50_1 or itertools.size(var_49_13) ~= var_50_0 then
			var_49_13 = itertools.map(arg_50_1, function(arg_51_0, arg_51_1)
				return arg_51_1, arg_51_0
			end)
		end

		arg_49_0.battleNum:set(var_50_0 .. "/" .. arg_49_0.embattleMax)
		arg_49_0.fightSumNum:set(arg_49_0:getFightSumNum(arg_50_1))
		arg_49_0.textFightPoint:setString(arg_49_0:getFightSumNum(arg_50_1))
	end)
	idlereasy.when(arg_49_0.draggingIndex, function(arg_52_0, arg_52_1)
		for iter_52_0 = 1, arg_49_0.panelNum do
			local var_52_0 = arg_49_0.heroSprite[iter_52_0].sprite:get("icon"):getChildren()

			if var_52_0[1] then
				var_52_0[1]:setCascadeOpacityEnabled(true)

				if arg_52_1 == 0 then
					var_52_0[1]:opacity(255)
				elseif arg_52_1 == -1 then
					var_52_0[1]:opacity(155)
				elseif arg_52_1 == iter_52_0 then
					var_52_0[1]:opacity(255)
				else
					var_52_0[1]:opacity(155)
				end
			end
		end
	end)
	arg_49_0:initSelectHalo()
end

function var_0_1.initSelectHalo(arg_53_0)
	for iter_53_0 = 1, arg_53_0.panelNum do
		local var_53_0 = arg_53_0.battlePanel:get("item" .. iter_53_0)
		local var_53_1 = var_53_0:size()
		local var_53_2 = ((iter_53_0 > 3 and iter_53_0 - 3 or iter_53_0) + 7) / 10
		local var_53_3 = var_53_0:anchorPoint()
		local var_53_4 = widget.addAnimationByKey(var_53_0, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_53_0:width() * var_53_3.x, var_53_0:height() * var_53_3.y):scale(var_53_2):hide()
	end

	idlereasy.when(arg_53_0.selectIndex, function(arg_54_0, arg_54_1)
		for iter_54_0 = 1, arg_53_0.panelNum do
			local var_54_0 = arg_53_0.battlePanel:get("item" .. iter_54_0)

			var_54_0:get("imgSel"):visible(arg_54_1 == iter_54_0)
			var_54_0:get("imgBg"):visible(arg_54_1 ~= iter_54_0)
		end
	end)
end

function var_0_1.createMovePanel(arg_55_0, arg_55_1)
	if arg_55_0.movePanel then
		arg_55_0.movePanel:removeSelf()
	end

	local var_55_0 = csv.unit[arg_55_1.unit_id]
	local var_55_1 = arg_55_0.spriteItem:clone():addTo(arg_55_0:getResourceNode(), 1000)

	var_55_1:show()

	local var_55_2 = var_55_1:get("icon"):size()

	widget.addAnimationByKey(var_55_1:get("icon"), var_55_0.unitRes, "hero", "run_loop", 1000):scale(var_55_0.scale * 0.8):alignCenter(var_55_2):setSkin(var_55_0.skin)
	widget.addAnimationByKey(var_55_1:get("icon"), "effect/buzhen.skel", "effect", "effect_loop", 1002):scale(1):alignCenter(var_55_2)

	arg_55_0.movePanel = var_55_1

	arg_55_0.draggingIndex:set(-1)

	return var_55_1
end

function var_0_1.deleteMovingItem(arg_56_0)
	arg_56_0.selectIndex:set(0)

	if arg_56_0.movePanel then
		arg_56_0.movePanel:removeSelf()

		arg_56_0.movePanel = nil
	end

	arg_56_0.draggingIndex:set(0)
end

function var_0_1.moveMovePanel(arg_57_0, arg_57_1)
	if arg_57_0.movePanel then
		arg_57_0.movePanel:xy(arg_57_1)
		arg_57_0.selectIndex:set(arg_57_0:whichEmbattleTargetPos(arg_57_1))
	end
end

function var_0_1.moveEndMovePanel(arg_58_0, arg_58_1)
	if not arg_58_0.movePanel then
		return
	end

	local var_58_0 = arg_58_0.selectIndex:read()

	arg_58_0:onCardMove(arg_58_1, var_58_0, true)
	arg_58_0:deleteMovingItem()
end

function var_0_1.isMovePanelExist(arg_59_0)
	return arg_59_0.movePanel ~= nil
end

function var_0_1.onCardClick(arg_60_0, arg_60_1, arg_60_2)
	if arg_60_1.inMeteor then
		gGameUI:showTip(gLanguageCsv.cardInMeteorites)

		return
	end

	local var_60_0
	local var_60_1 = arg_60_1.dbid
	local var_60_2 = arg_60_0:getIdxByDbId(var_60_1)

	if arg_60_1.battle > 0 then
		if arg_60_0:canBattleDown(arg_60_1.battle) then
			arg_60_0:downBattle(var_60_1)

			var_60_0 = gLanguageCsv.downToEmbattle
		else
			var_60_0 = gLanguageCsv.battleCannotEmpty
		end
	else
		local var_60_3 = arg_60_0:getIdxByDbId()

		if not arg_60_0:canBattleUp() then
			var_60_0 = gLanguageCsv.battleCardCountEnough
		elseif arg_60_0:hasSameMarkIDCard(arg_60_1) then
			var_60_0 = gLanguageCsv.alreadyHaveSameSprite
		else
			arg_60_0:upBattle(var_60_1, var_60_3)

			var_60_0 = gLanguageCsv.addToEmbattle
		end
	end

	if arg_60_2 and var_60_0 then
		gGameUI:showTip(var_60_0)
	end
end

function var_0_1.canBattleDown(arg_61_0)
	return (arg_61_0.readyIdx and 0 or 1) < arg_61_0.clientBattleCards:size()
end

function var_0_1.canBattleUp(arg_62_0)
	return arg_62_0.clientBattleCards:size() < arg_62_0.embattleMax
end

function var_0_1.onCardMove(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0
	local var_63_1 = arg_63_1.dbid
	local var_63_2 = arg_63_0:getIdxByDbId(var_63_1)
	local var_63_3 = arg_63_0.clientBattleCards:read()[arg_63_2]
	local var_63_4 = arg_63_0:getCardAttrs(var_63_3)
	local var_63_5

	var_63_5 = var_63_2 == nil and 0 or 1

	if arg_63_2 then
		if arg_63_1.battle > 0 then
			arg_63_0.clientBattleCards:modify(function(arg_64_0)
				arg_64_0[var_63_2], arg_64_0[arg_63_2] = arg_64_0[arg_63_2], arg_64_0[var_63_2]

				return true, arg_64_0
			end, true)
		else
			local var_63_6 = arg_63_0:hasSameMarkIDCard(arg_63_1)

			if var_63_6 and var_63_6 ~= arg_63_2 then
				var_63_0 = gLanguageCsv.alreadyHaveSameSprite
			elseif not var_63_3 and not arg_63_0:canBattleUp() then
				var_63_0 = gLanguageCsv.battleCardCountEnough
			else
				arg_63_0:upBattle(var_63_1, arg_63_2)

				var_63_0 = gLanguageCsv.addToEmbattle
			end
		end
	end

	if arg_63_3 and var_63_0 then
		gGameUI:showTip(var_63_0)
	end
end

function var_0_1.onBattleCardTouch(arg_65_0, arg_65_1, arg_65_2)
	local var_65_0 = arg_65_0.clientBattleCards:read()[arg_65_1]

	if not var_65_0 then
		return
	end

	local var_65_1 = arg_65_0:getCardAttrs(var_65_0)

	if arg_65_2.name == "began" then
		arg_65_0:createMovePanel(var_65_1)
		arg_65_0.selectIndex:set(arg_65_1)
		arg_65_0.heroSprite[arg_65_1].sprite:hide()
		arg_65_0.movePanel:xy(arg_65_2.x, arg_65_2.y)
	elseif arg_65_2.name == "moved" then
		arg_65_0:moveMovePanel(arg_65_2)
	elseif arg_65_2.name == "ended" or arg_65_2.name == "cancelled" then
		arg_65_0.heroSprite[arg_65_1].sprite:show()
		arg_65_0:deleteMovingItem()

		if arg_65_2.y < 300 then
			arg_65_0:onCardClick(var_65_1, true)
		else
			local var_65_2 = arg_65_0:whichEmbattleTargetPos(arg_65_2)

			if var_65_2 then
				if var_65_2 ~= arg_65_1 then
					arg_65_0:onCardMove(var_65_1, var_65_2, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_65_0:onCardMove(var_65_1, var_65_2, false)
				end
			else
				arg_65_0:onCardMove(var_65_1, arg_65_1, false)
			end
		end
	end
end

function var_0_1.getIdxByDbId(arg_66_0, arg_66_1)
	for iter_66_0 = 1, arg_66_0.panelNum do
		if arg_66_0.clientBattleCards:read()[iter_66_0] == arg_66_1 then
			return iter_66_0
		end
	end
end

function var_0_1.getCardAttrs(arg_67_0, arg_67_1)
	return arg_67_0.allCardDatas:atproxy(arg_67_1)
end

function var_0_1.downBattle(arg_68_0, arg_68_1)
	arg_68_0:getCardAttrs(arg_68_1).battle = 0

	local var_68_0 = arg_68_0:getIdxByDbId(arg_68_1)

	arg_68_0.clientBattleCards:modify(function(arg_69_0)
		arg_69_0[var_68_0] = nil

		return true, arg_69_0
	end, true)
end

function var_0_1.upBattle(arg_70_0, arg_70_1, arg_70_2)
	if arg_70_0.clientBattleCards:read()[arg_70_2] then
		arg_70_0:getCardAttrs(arg_70_0.clientBattleCards:read()[arg_70_2]).battle = 0
	end

	arg_70_0.clientBattleCards:modify(function(arg_71_0)
		arg_71_0[arg_70_2] = arg_70_1
		arg_70_0:getCardAttrs(arg_70_1).battle = arg_70_0:getBattle(arg_70_2)

		return true, arg_71_0
	end, true)
end

function var_0_1.hasSameMarkIDCard(arg_72_0, arg_72_1)
	for iter_72_0 = 1, arg_72_0.panelNum do
		local var_72_0 = arg_72_0.clientBattleCards:read()[iter_72_0]

		if var_72_0 and arg_72_0:getCardAttrs(var_72_0).markId == arg_72_1.markId then
			return iter_72_0
		end
	end

	return false
end

function var_0_1.whichEmbattleTargetPos(arg_73_0, arg_73_1)
	for iter_73_0 = arg_73_0.panelNum, 1, -1 do
		local var_73_0 = arg_73_0.heroSprite[iter_73_0].box

		if cc.rectContainsPoint(var_73_0, arg_73_1) then
			return iter_73_0
		end
	end
end

function var_0_1.checkTeamBuffOpen(arg_74_0)
	arg_74_0.buffOpen = true

	for iter_74_0, iter_74_1 in csvPairs(csv.battle_card_halo) do
		for iter_74_2, iter_74_3 in csvPairs(iter_74_1.invalidScenes) do
			if iter_74_3 == arg_74_0.sceneType then
				arg_74_0.buffOpen = false

				break
			end
		end

		break
	end

	arg_74_0.btnGHimg:visible(arg_74_0.buffOpen)
end

function var_0_1.refreshTeamBuff(arg_75_0, arg_75_1)
	if not arg_75_0.buffOpen then
		return
	end

	local var_75_0 = {}

	for iter_75_0 = 1, 6 do
		local var_75_1 = arg_75_0.clientBattleCards:read()[iter_75_0]
		local var_75_2 = arg_75_0:getCardAttrs(var_75_1)

		if var_75_2 then
			local var_75_3 = csv.cards[var_75_2.card_id]
			local var_75_4 = csv.unit[var_75_3.unitID]

			var_75_0[iter_75_0] = {
				var_75_4.natureType,
				var_75_4.natureType2
			}
		end
	end

	local var_75_5 = dataEasy.getTeamBuffBest(var_75_0)

	arg_75_0.btnGHimg:texture(var_75_5.buf.imgPath)

	arg_75_0.teamBuffs = var_75_5
end

function var_0_1.fightBtn(arg_76_0)
	local var_76_0 = arg_76_0.clientBattleCards:read()

	if not next(var_76_0) then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	arg_76_0:sendRequeat(function()
		arg_76_0.fightCb(arg_76_0, arg_76_0.clientBattleCards)
	end)
end

function var_0_1.onClose(arg_78_0, arg_78_1, arg_78_2)
	local function var_78_0()
		if arg_78_1 == true then
			arg_78_0:sendRequeat(functools.partial(var_0_0.onClose, arg_78_0), true)
		else
			var_0_0.onClose(arg_78_0)
		end
	end

	if arg_78_0.readyIdx and arg_78_2 ~= true and arg_78_0:isChangeBattleCards() then
		arg_78_0:teamNotSave(var_78_0)
	else
		var_78_0()
	end
end

function var_0_1.isChangeBattleCards(arg_80_0)
	local var_80_0 = false

	if arg_80_0.inputCards then
		if arg_80_0.inputCards:size() == arg_80_0.clientBattleCards:size() then
			local var_80_1 = arg_80_0.inputCards:read()

			for iter_80_0, iter_80_1 in pairs(arg_80_0.clientBattleCards:read()) do
				if var_80_1[iter_80_0] ~= iter_80_1 then
					var_80_0 = true
				end
			end
		else
			var_80_0 = true
		end
	end

	return var_80_0
end

function var_0_1.cardBagBtn(arg_81_0)
	arg_81_0:sendRequeat(function()
		gGameUI:stackUI("city.card.bag", nil, {
			full = true
		})
	end)
end

function var_0_1.onTeamBuffClick(arg_83_0)
	if not arg_83_0.buffOpen then
		return
	end

	local var_83_0 = arg_83_0.teamBuffs and arg_83_0.teamBuffs.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_83_0)
end

function var_0_1.limtFunc(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5, arg_84_6, arg_84_7, arg_84_8, arg_84_9, arg_84_10)
	local var_84_0 = dataEasy.getInMeteorCardsHash()
	local var_84_1 = csv.cards[arg_84_2]
	local var_84_2 = csv.unit[var_84_1.unitID]
	local var_84_3 = dataEasy.getUnitId(arg_84_2, arg_84_3)

	return {
		card_id = arg_84_2,
		unit_id = var_84_3,
		rarity = var_84_2.rarity,
		attr1 = var_84_2.natureType,
		attr2 = var_84_2.natureType2,
		fighting_point = arg_84_4,
		level = arg_84_5,
		star = arg_84_6,
		getTime = arg_84_8,
		dbid = arg_84_1,
		advance = arg_84_7,
		battle = arg_84_10,
		atkType = var_84_1.atkType,
		markId = var_84_1.cardMarkID,
		nature_choose = arg_84_9,
		inMeteor = var_84_0[arg_84_1]
	}
end

function var_0_1.getBattle(arg_85_0, arg_85_1)
	if arg_85_1 and arg_85_1 ~= 0 then
		return math.ceil(arg_85_1 / 6)
	else
		return 0
	end
end

function var_0_1.oneReadyBtn(arg_86_0)
	if not dataEasy.isUnlock(gUnlockCsv.readyTeam) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.readyTeam))

		return
	end

	local function var_86_0(arg_87_0, arg_87_1)
		for iter_87_0, iter_87_1 in arg_86_0.clientBattleCards:pairs() do
			arg_86_0:getCardAttrs(iter_87_1).battle = 0
		end

		for iter_87_2 = 1, 6 do
			if arg_87_0[iter_87_2] then
				arg_86_0:getCardAttrs(arg_87_0[iter_87_2]).battle = 1
			end
		end

		arg_86_0.clientBattleCards:set(arg_87_0)

		if arg_87_1 then
			arg_87_1()
		end
	end

	gGameUI:stackUI("city.card.embattle.ready", nil, nil, {
		sceneType = arg_86_0.sceneType,
		cb = var_86_0
	})
end

function var_0_1.oneSaveReadyBtn(arg_88_0)
	gGameApp:requestServer("/game/ready/card/deploy", function(arg_89_0)
		arg_88_0:onClose(nil, true)
		gGameUI:showTip(gLanguageCsv.positionSave)
	end, arg_88_0.readyIdx, arg_88_0.clientBattleCards:read())
end

function var_0_1.teamNotSave(arg_90_0, arg_90_1)
	gGameUI:showDialog({
		btnType = 2,
		content = gLanguageCsv.teamNotSave,
		cb = function()
			arg_90_0:oneSaveReadyBtn()
		end,
		cancelCb = arg_90_1
	})
end

return var_0_1
