local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.embattle.base")
local var_0_2 = class("CrossAreanEmbattleView", var_0_1)

var_0_2.RESOURCE_FILENAME = "cross_arena_embattle.json"
var_0_2.RESOURCE_BINDING = {
	battlePanel1 = "battlePanel1",
	rightDown = "rightDown",
	bottomPanel = "bottomPanel",
	battlePanel2 = "battlePanel2",
	spritePanel = "spriteItem",
	["battlePanel1.fightNote.btnGHimg"] = {
		varname = "btnGHimg1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick1")
			}
		}
	},
	["battlePanel2.fightNote.btnGHimg"] = {
		varname = "btnGHimg2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick2")
			}
		}
	},
	["rightDown.btnOneKeySet"] = {
		varname = "btnOneKeySet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEmbattleBtn")
			}
		}
	},
	["rightDown.btnOneKeySet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["rightDown.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("fightBtn")
			}
		}
	},
	["rightDown.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.back.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel2.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel2.back.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.imgDuiwu.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel2.imgDuiwu.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["rightDown.btnOneKeySet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightDown.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnChange = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeBattle")
			}
		}
	},
	["battlePanel1.fightNote.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightSumNum1")
		}
	},
	["battlePanel2.fightNote.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightSumNum2")
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0:initDefine()
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_1_0.rightDown,
			"pos",
			"right"
		}
	})
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose", true)
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_kuafujingjichang.png"
	})
	arg_1_0:initModel(arg_1_1)
	arg_1_0:initBattlePanel()
	arg_1_0:initBottomList()
	arg_1_0:initRoundUIPanel()
	idlereasy.when(arg_1_0.clientBattleCards, function(arg_2_0, arg_2_1)
		arg_1_0.fightSumNum1:set(arg_1_0:getFightSumNum(1))
		arg_1_0.fightSumNum2:set(arg_1_0:getFightSumNum(2))
		arg_1_0:refreshTeamBuff(1)
		arg_1_0:refreshTeamBuff(2)
		arg_1_0.rightDown:get("textNum"):text(arg_1_0.clientBattleCards:size() .. "/" .. arg_1_0.embattleMax)
		adapt.oneLineCenterPos(cc.p(163, 152), {
			arg_1_0.rightDown:get("textNote"),
			arg_1_0.rightDown:get("textNum")
		}, cc.p(5, 0))

		for iter_2_0 = 1, arg_1_0.panelNum do
			arg_1_0:refreshBattleSprite(iter_2_0)
		end
	end)
end

function var_0_2.initDefine(arg_3_0)
	arg_3_0.embattleMax = 12
	arg_3_0.panelNum = 12
end

function var_0_2.initAllCards(arg_4_0)
	local var_4_0 = gGameModel.role:read("cards")
	local var_4_1 = itertools.map(arg_4_0.clientBattleCards:read(), function(arg_5_0, arg_5_1)
		return arg_5_1, arg_5_0
	end)
	local var_4_2 = {}
	local var_4_3 = {}

	for iter_4_0, iter_4_1 in ipairs(var_4_0) do
		local var_4_4 = gGameModel.cards:find(iter_4_1)
		local var_4_5 = arg_4_0:getBattle(var_4_1[iter_4_1])
		local var_4_6 = var_4_4:read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

		var_4_2[iter_4_1] = arg_4_0.limtFunc(arg_4_0, iter_4_1, var_4_6.card_id, var_4_6.skin_id, var_4_6.fighting_point, var_4_6.level, var_4_6.star, var_4_6.advance, var_4_6.created_time, var_4_6.nature_choose, var_4_5)

		if var_4_2[iter_4_1] then
			table.insert(var_4_3, var_4_2[iter_4_1])
		end
	end

	arg_4_0.allCardDatas:update(var_4_2)
	table.sort(var_4_3, function(arg_6_0, arg_6_1)
		if arg_6_0.fighting_point ~= arg_6_1.fighting_point then
			return arg_6_0.fighting_point > arg_6_1.fighting_point
		end

		return arg_6_0.rarity > arg_6_1.rarity
	end)

	arg_4_0.oneKeyCards = {}

	local var_4_7 = {}
	local var_4_8 = 0

	for iter_4_2, iter_4_3 in ipairs(var_4_3) do
		if not var_4_7[iter_4_3.markId] and not iter_4_3.inMeteor then
			var_4_7[iter_4_3.markId] = true

			table.insert(arg_4_0.oneKeyCards, iter_4_3.dbid)

			var_4_8 = var_4_8 + 1

			if var_4_8 == arg_4_0.embattleMax then
				break
			end
		end
	end

	local var_4_9 = itertools.size(arg_4_0.oneKeyCards)

	if var_4_9 <= 6 then
		arg_4_0.oneKeyCards[7] = clone(arg_4_0.oneKeyCards[var_4_9])
		arg_4_0.oneKeyCards[var_4_9] = nil
	end
end

function var_0_2.initBattlePanel(arg_7_0)
	arg_7_0.battleCardsRect = {}
	arg_7_0.battleCards = {}

	for iter_7_0 = 1, 2 do
		for iter_7_1 = 1, 6 do
			local var_7_0 = arg_7_0["battlePanel" .. iter_7_0]:get("item" .. iter_7_1)
			local var_7_1 = var_7_0:box()
			local var_7_2 = var_7_0:getParent():convertToWorldSpace(cc.p(var_7_1.x, var_7_1.y))

			var_7_1.x, var_7_1.y = var_7_2.x, var_7_2.y

			local var_7_3 = (iter_7_0 - 1) * 6 + iter_7_1

			arg_7_0.battleCardsRect[var_7_3] = var_7_1
			arg_7_0.battleCards[var_7_3] = var_7_0

			var_7_0:onTouch(functools.partial(arg_7_0.onBattleCardTouch, arg_7_0, var_7_3))
		end
	end

	for iter_7_2 = 1, arg_7_0.panelNum do
		local var_7_4 = arg_7_0.battleCards[iter_7_2]:get("imgBg")
		local var_7_5 = var_7_4:get("imgSel")
		local var_7_6 = var_7_4:size()
		local var_7_7

		var_7_7 = var_7_5 or widget.addAnimationByKey(var_7_4, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_7_6.width / 2, var_7_6.height / 2 + 15)
	end

	idlereasy.when(arg_7_0.selectIndex, function(arg_8_0, arg_8_1)
		for iter_8_0 = 1, arg_7_0.panelNum do
			arg_7_0.battleCards[iter_8_0]:get("imgBg.imgSel"):visible(arg_8_1 == iter_8_0)
		end
	end)

	arg_7_0.draggingIndex = idler.new(0)

	idlereasy.when(arg_7_0.draggingIndex, function(arg_9_0, arg_9_1)
		for iter_9_0 = 1, arg_7_0.panelNum do
			local var_9_0 = arg_7_0.battleCards[iter_9_0]:get("sprite")

			if var_9_0 then
				var_9_0:setCascadeOpacityEnabled(true)

				if arg_9_1 == 0 then
					var_9_0:opacity(255)
				elseif arg_9_1 == -1 then
					var_9_0:opacity(155)
				elseif arg_9_1 == iter_9_0 then
					var_9_0:opacity(255)
				else
					var_9_0:opacity(155)
				end
			end
		end
	end)
end

function var_0_2.initBottomList(arg_10_0)
	arg_10_0.cardListView = gGameUI:createView("city.card.embattle.cross_arena_card_list", arg_10_0.bottomPanel):init({
		base = arg_10_0,
		clientBattleCards = arg_10_0.clientBattleCards,
		battleCardsData = arg_10_0.battleCardsData,
		selectIndex = arg_10_0.selectIndex,
		deleteMovingItem = arg_10_0.deleteMovingItem,
		createMovePanel = arg_10_0.createMovePanel,
		moveMovePanel = arg_10_0.moveMovePanel,
		isMovePanelExist = arg_10_0.isMovePanelExist,
		onCardClick = arg_10_0.onCardClick,
		allCardDatas = arg_10_0.allCardDatas,
		moveEndMovePanel = arg_10_0.moveEndMovePanel,
		limtFunc = arg_10_0.limtFunc
	}, true)

	arg_10_0:resetBtnPos()
end

function var_0_2.getCardAttrIdler(arg_11_0, arg_11_1, arg_11_2)
	return gGameModel.cards:find(arg_11_1):getIdler(arg_11_2)
end

function var_0_2.getFightSumNum(arg_12_0, arg_12_1)
	local var_12_0 = 0
	local var_12_1 = arg_12_1 == 1 and 1 or 7

	for iter_12_0 = var_12_1, var_12_1 + 5 do
		if arg_12_0.clientBattleCards:read()[iter_12_0] then
			var_12_0 = var_12_0 + arg_12_0:getCardAttrs(arg_12_0.clientBattleCards:read()[iter_12_0]).fighting_point
		end
	end

	return var_12_0
end

function var_0_2.getCardNum(arg_13_0, arg_13_1)
	local var_13_0 = 0
	local var_13_1 = arg_13_1 == 1 and 1 or 7

	for iter_13_0 = var_13_1, var_13_1 + 5 do
		if arg_13_0.clientBattleCards:read()[iter_13_0] then
			var_13_0 = var_13_0 + 1
		end
	end

	return var_13_0
end

function var_0_2.refreshTeamBuff(arg_14_0, arg_14_1)
	local var_14_0 = {}
	local var_14_1 = arg_14_1 == 1 and 1 or 7

	for iter_14_0 = var_14_1, var_14_1 + 5 do
		local var_14_2 = arg_14_0:getCardAttrs(arg_14_0.clientBattleCards:read()[iter_14_0])

		if var_14_2 then
			local var_14_3 = csv.cards[var_14_2.card_id]
			local var_14_4 = csv.unit[var_14_3.unitID]

			var_14_0[iter_14_0 - var_14_1 + 1] = {
				var_14_4.natureType,
				var_14_4.natureType2
			}
		end
	end

	local var_14_5 = dataEasy.getTeamBuffBest(var_14_0)

	arg_14_0["btnGHimg" .. arg_14_1]:texture(var_14_5.buf.imgPath)

	arg_14_0["teamBuffs" .. arg_14_1] = var_14_5
end

function var_0_2.initModel(arg_15_0, arg_15_1)
	arg_15_0.type = arg_15_1.type
	arg_15_0.fightCb = arg_15_1.fightCb
	arg_15_0.allCardDatas = idlers.newWithMap({})
	arg_15_0.selectIndex = idler.new(0)

	local var_15_0 = {}

	if arg_15_0.type == "defence" then
		var_15_0 = gGameModel.cross_arena:read("record").defence_cards
	else
		var_15_0 = gGameModel.cross_arena:read("record").cards
	end

	local var_15_1 = {}

	for iter_15_0 = 1, 2 do
		for iter_15_1 = 1, 6 do
			var_15_1[(iter_15_0 - 1) * 6 + iter_15_1] = var_15_0[iter_15_0][iter_15_1]
		end
	end

	arg_15_0.battleCardsData = idlertable.new(var_15_1)
	arg_15_0.clientBattleCards = idlertable.new(var_15_1)
	arg_15_0.cards = gGameModel.role:getIdler("cards")
	arg_15_0.fightSumNum1 = idler.new(0)
	arg_15_0.fightSumNum2 = idler.new(0)

	arg_15_0:initAllCards()
end

function var_0_2.initRoundUIPanel(arg_16_0)
	arg_16_0.btnOneKeySet:visible(arg_16_0.type == "defence")
	arg_16_0.btnChallenge:visible(arg_16_0.type ~= "defence")
end

function var_0_2.oneKeyEmbattleBtn(arg_17_0)
	if not arg_17_0.clientBattleCards:read() then
		return
	end

	if itertools.equal(arg_17_0.oneKeyCards, arg_17_0.clientBattleCards:read()) then
		gGameUI:showTip(gLanguageCsv.embattleNotChange)

		return
	end

	for iter_17_0 = 1, arg_17_0.panelNum do
		if arg_17_0.clientBattleCards:read()[iter_17_0] then
			arg_17_0:getCardAttrs(arg_17_0.clientBattleCards:read()[iter_17_0]).battle = 0
		end
	end

	arg_17_0.clientBattleCards:set(clone(arg_17_0.oneKeyCards), true)

	for iter_17_1 = 1, arg_17_0.panelNum do
		local var_17_0 = arg_17_0.clientBattleCards:read()[iter_17_1]

		if var_17_0 then
			arg_17_0:getCardAttrs(var_17_0).battle = arg_17_0:getBattle(iter_17_1)
		end
	end

	gGameUI:showTip(gLanguageCsv.oneKeySuccess)
end

function var_0_2.onChangeBattle(arg_18_0)
	arg_18_0.clientBattleCards:modify(function(arg_19_0)
		for iter_19_0 = 1, 6 do
			arg_19_0[iter_19_0], arg_19_0[iter_19_0 + 6] = arg_19_0[iter_19_0 + 6], arg_19_0[iter_19_0]
		end

		for iter_19_1 = 1, arg_18_0.panelNum do
			local var_19_0 = arg_18_0.clientBattleCards:read()[iter_19_1]

			if arg_18_0:getCardAttrs(var_19_0) then
				arg_18_0:getCardAttrs(var_19_0).battle = arg_18_0:getBattle(iter_19_1)
			end
		end
	end, true)
end

function var_0_2.fightBtn(arg_20_0)
	local var_20_0 = arg_20_0.clientBattleCards:read()

	if not next(var_20_0) then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	arg_20_0:sendRequeat(function()
		arg_20_0.fightCb(arg_20_0, arg_20_0.clientBattleCards)
	end)
end

function var_0_2.onTeamBuffClick1(arg_22_0)
	local var_22_0 = arg_22_0.teamBuffs1 and arg_22_0.teamBuffs1.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_22_0)
end

function var_0_2.onTeamBuffClick2(arg_23_0)
	local var_23_0 = arg_23_0.teamBuffs2 and arg_23_0.teamBuffs2.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_23_0)
end

function var_0_2.refreshBattleSprite(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.battleCards[arg_24_1]
	local var_24_1 = arg_24_0:getCardAttrs(arg_24_0.clientBattleCards:read()[arg_24_1])

	if not var_24_1 then
		if var_24_0:getChildByName("sprite") then
			var_24_0:getChildByName("sprite"):hide()
		end

		var_24_0:get("attrBg"):hide()

		return
	end

	local var_24_2 = var_24_1.card_id
	local var_24_3 = csv.unit[var_24_1.unit_id]
	local var_24_4 = arg_24_0.battleCards[arg_24_1]:get("imgBg")

	if var_24_0.spriteId == var_24_2 and var_24_0:getChildByName("sprite") then
		var_24_0:getChildByName("sprite"):show()
	else
		var_24_0:removeChildByName("sprite")
		widget.addAnimationByKey(var_24_0, var_24_3.unitRes, "sprite", "standby_loop", 4):scale(var_24_3.scale * 0.8):xy(var_24_4:x(), var_24_4:y() + 15):setSkin(var_24_3.skin)

		var_24_0.spriteId = var_24_2
	end

	local var_24_5 = arg_24_1 > 6 and 2 or 1
	local var_24_6 = arg_24_0["teamBuffs" .. var_24_5] and arg_24_0["teamBuffs" .. var_24_5].flags or {
		1,
		1,
		1,
		1,
		1,
		1
	}
	local var_24_7 = var_24_6[arg_24_1] or var_24_6[arg_24_1 - 6]

	uiEasy.setTeamBuffItem(var_24_0, var_24_2, var_24_7)
end

function var_0_2.onBattleCardTouch(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.clientBattleCards:read()[arg_25_1] then
		return
	end

	local var_25_0 = arg_25_0:getCardAttrs(arg_25_0.clientBattleCards:read()[arg_25_1])

	if arg_25_2.name == "began" then
		arg_25_0:deleteMovingItem()
		arg_25_0:createMovePanel(var_25_0)

		local var_25_1 = arg_25_0.battleCards[arg_25_1]

		var_25_1:get("sprite"):hide()
		var_25_1:get("attrBg"):hide()
		arg_25_0:moveMovePanel(arg_25_2)
	elseif arg_25_2.name == "moved" then
		arg_25_0:moveMovePanel(arg_25_2)
	elseif arg_25_2.name == "ended" or arg_25_2.name == "cancelled" then
		local var_25_2 = arg_25_0.battleCards[arg_25_1]

		var_25_2:get("sprite"):show()
		var_25_2:get("attrBg"):show()
		arg_25_0:deleteMovingItem()

		if arg_25_2.y < 340 then
			arg_25_0:onCardClick(var_25_0, true)
		else
			local var_25_3 = arg_25_0:whichEmbattleTargetPos(arg_25_2)

			if var_25_3 then
				if var_25_3 ~= arg_25_1 then
					arg_25_0:onCardMove(var_25_0, var_25_3, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_25_0:onCardMove(var_25_0, var_25_3, false)
				end
			else
				arg_25_0:onCardMove(var_25_0, arg_25_1, false)
			end
		end
	end
end

function var_0_2.onCardMove(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0
	local var_26_1 = arg_26_1.dbid
	local var_26_2 = arg_26_0:getIdxByDbId(var_26_1)
	local var_26_3 = arg_26_0.clientBattleCards:read()[arg_26_2]
	local var_26_4 = arg_26_0:getCardAttrs(var_26_3)
	local var_26_5 = arg_26_0:getBattle(var_26_2)

	if not arg_26_2 then
		-- block empty
	else
		local var_26_6 = arg_26_0:getBattle(arg_26_2)

		if arg_26_1.battle > 0 then
			if var_26_6 ~= arg_26_1.battle and arg_26_0:getCardNum(arg_26_1.battle) == 1 and var_26_3 == nil then
				var_26_0 = gLanguageCsv.battleNumberNo

				arg_26_0:refreshBattleSprite(var_26_2)
			else
				if arg_26_0:getCardAttrs(var_26_3) then
					arg_26_0:getCardAttrs(var_26_3).battle = arg_26_0:getBattle(var_26_2)
				end

				if arg_26_0:getCardAttrs(var_26_1) then
					arg_26_0:getCardAttrs(var_26_1).battle = arg_26_0:getBattle(arg_26_2)
				end

				arg_26_0.clientBattleCards:modify(function(arg_27_0)
					arg_27_0[var_26_2], arg_27_0[arg_26_2] = arg_27_0[arg_26_2], arg_27_0[var_26_2]

					return true, arg_27_0
				end, true)
			end
		else
			local var_26_7 = arg_26_0:hasSameMarkIDCard(arg_26_1)

			if var_26_7 and var_26_7 ~= arg_26_2 then
				var_26_0 = gLanguageCsv.alreadyHaveSameSprite
			else
				if var_26_3 then
					arg_26_0:getCardAttrs(var_26_3).battle = 0
				end

				arg_26_0:getCardAttrs(var_26_1).battle = arg_26_0:getBattle(arg_26_2)

				arg_26_0.clientBattleCards:modify(function(arg_28_0)
					arg_28_0[arg_26_2] = var_26_1

					return true, arg_28_0
				end, true)

				var_26_0 = gLanguageCsv.addToEmbattle
			end
		end
	end

	if arg_26_3 and var_26_0 then
		gGameUI:showTip(var_26_0)
	end
end

function var_0_2.canBattleDown(arg_29_0, arg_29_1)
	return arg_29_0:getCardNum(arg_29_1) > 1
end

function var_0_2.downBattle(arg_30_0, arg_30_1)
	arg_30_0.allCardDatas:atproxy(arg_30_1).battle = 0

	local var_30_0 = arg_30_0:getIdxByDbId(arg_30_1)

	arg_30_0.clientBattleCards:modify(function(arg_31_0)
		arg_31_0[var_30_0] = nil

		return true, arg_31_0
	end, true)
end

function var_0_2.upBattle(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0:getCardAttrs(arg_32_1).battle = arg_32_0:getBattle(arg_32_2)

	arg_32_0.clientBattleCards:modify(function(arg_33_0)
		arg_33_0[arg_32_2] = arg_32_1

		return true, arg_33_0
	end, true)
end

function var_0_2.whichEmbattleTargetPos(arg_34_0, arg_34_1)
	for iter_34_0 = arg_34_0.panelNum, 1, -1 do
		local var_34_0 = arg_34_0.battleCardsRect[iter_34_0]

		if cc.rectContainsPoint(var_34_0, arg_34_1) then
			return iter_34_0
		end
	end
end

function var_0_2.hasSameMarkIDCard(arg_35_0, arg_35_1)
	for iter_35_0 = 1, arg_35_0.panelNum do
		local var_35_0 = arg_35_0.clientBattleCards:read()[iter_35_0]

		if var_35_0 and arg_35_0:getCardAttrs(var_35_0).markId == arg_35_1.markId then
			return iter_35_0
		end
	end

	return false
end

function var_0_2.sendRequeat(arg_36_0, arg_36_1, arg_36_2)
	if not itertools.equal(arg_36_0.battleCardsData:read(), arg_36_0.clientBattleCards:read()) then
		local var_36_0

		if arg_36_0.type == "defence" then
			var_36_0 = gGameApp:requestServerCustom("/game/cross/arena/battle/deploy"):params(nil, arg_36_0.clientBattleCards:read())
		else
			var_36_0 = gGameApp:requestServerCustom("/game/cross/arena/battle/deploy"):params(arg_36_0.clientBattleCards:read(), nil)
		end

		if arg_36_2 then
			var_36_0:onBeforeSync(arg_36_1):doit()
		else
			var_36_0:doit(arg_36_1)
		end
	else
		arg_36_1()
	end
end

function var_0_2.getBattle(arg_37_0, arg_37_1)
	if arg_37_1 and arg_37_1 ~= 0 then
		return arg_37_1 <= 6 and 1 or 2
	else
		return 0
	end
end

return var_0_2
