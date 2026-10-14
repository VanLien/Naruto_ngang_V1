local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.embattle.fake_embattle")
local var_0_2 = require("app.views.city.adventure.mimicry.tools")
local var_0_3 = class("MimicryEmbattle", var_0_1)
local var_0_4 = {
	hide = 1,
	limit = 2,
	unlock = 3
}
local var_0_5 = {
	var_0_4.hide,
	var_0_4.hide,
	var_0_4.limit,
	var_0_4.hide,
	var_0_4.unlock,
	var_0_4.unlock,
	var_0_4.unlock,
	var_0_4.unlock,
	var_0_4.unlock
}
local var_0_6 = {
	2,
	4,
	6,
	1,
	3,
	5
}
local var_0_7 = {
	{
		pos = cc.p(0, 50),
		size = cc.size(450, 250)
	},
	{
		pos = cc.p(0, 20),
		size = cc.size(500, 250)
	},
	{
		pos = cc.p(0, 20),
		size = cc.size(500, 250)
	},
	{
		pos = cc.p(0, 50),
		size = cc.size(450, 250)
	},
	{
		pos = cc.p(0, 20),
		size = cc.size(500, 250)
	},
	{
		pos = cc.p(0, 20),
		size = cc.size(500, 250)
	}
}

var_0_3.RESOURCE_FILENAME = "mimicry_embattle.json"
var_0_3.RESOURCE_BINDING = {
	btnReady = "btnReady",
	bottomPanel = "bottomPanel",
	rightDown = "rightDown",
	["limitPanel.subItem"] = "limitSubItem",
	["limitCardPanel.subItem"] = "limitCardSubItem",
	limitPanel = "limitPanel",
	textLimit = "textLimit",
	battlePanel = "battlePanel",
	textNotRole = "emptyTxt",
	bossPanel = "bossPanel",
	bottomMask = "bottomMask",
	["limitPanel.rareItem"] = "rareItem",
	fightNote = "fightNote",
	limitCardPanel = "limitCardPanel",
	["limitCardPanel.cell"] = "limitCell",
	limitSkillPanel = "limitSkillPanel",
	spritePanel = "spriteItem",
	textTip = {
		varname = "textTip",
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(255, 255, 255, 255),
				outline = {
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
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
			event = "touch",
			clicksafe = true,
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					local var_1_0 = csv.mimicry.base[1].battleTimesLimit
					local var_1_1 = cc.clampf(gGameModel.daily_record:read("mimicry_battle_times"), 0, var_1_0)
					local var_1_2 = cc.clampf(var_1_1, 0, 3)

					arg_1_0:fightBtn(var_1_2)
				end)
			}
		}
	},
	btnQuickChallenge = {
		varname = "btnQuickChallenge",
		binds = {
			event = "touch",
			clicksafe = true,
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0.fightBtn(arg_2_0, 1)
				end)
			}
		}
	},
	["fightNote.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightSumNum")
		}
	},
	["ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["back.txt"] = {
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
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		},
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
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
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["btnReady.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
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
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["limitPanel.limitList"] = {
		varname = "limitList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				data = bindHelper.self("limitData"),
				item = bindHelper.self("limitSubItem"),
				cell = bindHelper.self("rareItem"),
				columnSize = bindHelper.self("limitColumnSize"),
				xMargin = bindHelper.self("xMargins"),
				yMargin = bindHelper.self("yMargins"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = ""
					local var_3_1 = arg_3_0.specialLimitType()

					if var_3_1 == 1 or var_3_1 == 3 then
						var_3_0 = ui.RARITY_ICON[arg_3_3]
					elseif var_3_1 == 2 then
						var_3_0 = ui.ATTR_ICON[arg_3_3]
					end

					arg_3_1:get("icon"):texture(var_3_0)
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.setClippingEnabled(arg_4_0, false)
				end
			},
			handlers = {
				specialLimitType = bindHelper.self("specialLimitType")
			}
		}
	},
	["limitCardPanel.limitCardList"] = {
		varname = "limitCardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				data = bindHelper.self("limitCardData"),
				item = bindHelper.self("limitCardSubItem"),
				cell = bindHelper.self("limitCell"),
				xMargin = bindHelper.self("xMargins"),
				yMargin = bindHelper.self("yMargins"),
				columnSize = bindHelper.self("limitColumnSize"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = csv.cards[arg_5_3].unitID

					arg_5_1:get("icon"):texture(csv.unit[var_5_0].icon)
				end,
				onAfterBuild = function(arg_6_0)
					arg_6_0.setClippingEnabled(arg_6_0, false)
				end
			}
		}
	}
}

function var_0_3.initParams(arg_7_0, arg_7_1)
	arg_7_0.route = arg_7_1.route
	arg_7_0.inputCards = arg_7_1.inputCards
	arg_7_0.sceneType = arg_7_1.sceneType or -1
	arg_7_0.from = arg_7_1.from or game.EMBATTLE_FROM_TABLE.default
	arg_7_0.fightCb = arg_7_1.fightCb
	arg_7_0.fromId = arg_7_1.fromId
	arg_7_0.startCb = arg_7_1.startCb
	arg_7_0.xMargins = 0
	arg_7_0.yMargins = 0
	arg_7_0.limitColumnSize = 4
	arg_7_0.bossID = arg_7_1.bossID
	arg_7_0.isQuick = arg_7_1.isQuick
	arg_7_0.bossCfg = csv.mimicry.boss[arg_7_0.bossID]
	arg_7_0.bossLimitCfg = csv.mimicry.boss_limit[arg_7_1.limitID]
	arg_7_0.specialLimitType = arg_7_0.bossLimitCfg.specialLimitType
	arg_7_0.checkBattleArr = arg_7_1.checkBattleArr or function()
		return true
	end
end

function var_0_3.initBottomList(arg_9_0)
	arg_9_0.cardListView = gGameUI:createView("city.adventure.mimicry.mimicry_card_list", arg_9_0.bottomPanel):init({
		base = arg_9_0,
		clientBattleCards = arg_9_0.clientBattleCards,
		battleCardsData = arg_9_0.battleCardsData,
		deleteMovingItem = arg_9_0.deleteMovingItem,
		createMovePanel = arg_9_0.createMovePanel,
		moveMovePanel = arg_9_0.moveMovePanel,
		isMovePanelExist = arg_9_0.isMovePanelExist,
		onCardClick = arg_9_0.onCardClick,
		allCardDatas = arg_9_0.allCardDatas,
		moveEndMovePanel = arg_9_0.moveEndMovePanel,
		limtFunc = arg_9_0.limtFunc,
		isQuick = arg_9_0.isQuick,
		bossID = arg_9_0.bossID
	}, true)
end

function var_0_3.initHeroSprite(arg_10_0)
	local var_10_0 = arg_10_0:convertToWorldSpace(cc.p(arg_10_0.battlePanel:x(), arg_10_0.battlePanel:y()))

	arg_10_0.offsetX = arg_10_0.battlePanel:x() - var_10_0.x
	arg_10_0.offsetY = arg_10_0.battlePanel:y() - var_10_0.y
	arg_10_0.heroSprite = {}

	arg_10_0.spriteItem:get("held"):hide()

	for iter_10_0 = 1, arg_10_0.panelNum do
		local var_10_1 = arg_10_0.spriteItem:clone():addTo(arg_10_0.battlePanel, 10 + var_0_6[iter_10_0], "panel" .. iter_10_0)

		var_10_1:show()
		var_10_1:get("imgBg"):hide()

		local var_10_2, var_10_3 = arg_10_0.battlePanel:get("item" .. iter_10_0):xy()
		local var_10_4 = arg_10_0.battlePanel:get("item" .. iter_10_0):box()

		var_10_4.x = var_10_4.x - arg_10_0.offsetX
		var_10_4.y = var_10_4.y - arg_10_0.offsetY
		arg_10_0.heroSprite[iter_10_0] = {
			sprite = var_10_1,
			posx = var_10_2,
			posy = var_10_3,
			box = var_10_4,
			idx = iter_10_0
		}
	end

	for iter_10_1 = 1, arg_10_0.panelNum do
		local var_10_5 = arg_10_0.battlePanel:get("item" .. iter_10_1, "pos")

		if var_0_7[iter_10_1] then
			local var_10_6 = var_0_7[iter_10_1].size
			local var_10_7 = var_0_7[iter_10_1].pos
			local var_10_8 = display.sizeInView.width / display.size.width
			local var_10_9 = display.sizeInView.height / display.size.height
			local var_10_10 = cc.size(var_10_8 * var_10_6.width, var_10_9 * var_10_6.height)
			local var_10_11 = cc.p(var_10_8 * var_10_7.x, var_10_9 * var_10_7.y)
			local var_10_12 = arg_10_0.battlePanel:get("item" .. iter_10_1)

			var_10_5:size(var_10_10):xy(var_10_12:size().width / 2 + var_10_11.x, var_10_12:size().height / 2 + var_10_11.y)
		end

		var_10_5.onTouch(var_10_5, functools.partial(arg_10_0.onBattleCardTouch, arg_10_0, iter_10_1))
	end

	local var_10_13 = {}

	idlereasy.when(arg_10_0.clientBattleCards, function(arg_11_0, arg_11_1)
		arg_10_0:refreshTeamBuff(arg_11_1)

		local var_11_0 = 0
		local var_11_1 = true

		for iter_11_0 = 1, arg_10_0.panelNum do
			local var_11_2 = arg_10_0.heroSprite[iter_11_0]
			local var_11_3 = var_11_2.idx

			var_11_2.sprite:xy(var_11_2.posx, var_11_2.posy):z(10 + var_0_6[iter_11_0])

			local var_11_4 = var_11_2.sprite:get("fightPoint")

			var_11_2.sprite:get("attrBg"):hide()

			if arg_11_1[iter_11_0] then
				var_11_0 = var_11_0 + 1

				local var_11_5 = arg_11_1[iter_11_0]

				if var_11_5 and arg_10_0:getCardAttrs(var_11_5) then
					arg_10_0:getCardAttrs(var_11_5).battle = arg_10_0:getBattle(iter_11_0)
				end

				local var_11_6 = arg_10_0:getCardAttr(var_11_5, "card_id")
				local var_11_7 = arg_10_0:getCardAttr(var_11_5, "skin_id")
				local var_11_8 = dataEasy.getUnitCsv(var_11_6, var_11_7)
				local var_11_9 = {
					card_id = var_11_6,
					skin_id = var_11_7
				}

				if not var_11_2.dbdata or not itertools.equal(var_11_2.dbdata, var_11_9) then
					var_11_2.sprite:get("icon"):removeAllChildren()
					widget.addAnimation(var_11_2.sprite:get("icon"), var_11_8.unitRes, "standby_loop", 11):scale(var_11_8.scale * 0.7):xy(50, 50):setSkin(var_11_8.skin)

					var_11_2.dbdata = var_11_9
				end

				if arg_10_0.buffOpen then
					local var_11_10 = arg_10_0.teamBuffs and arg_10_0.teamBuffs.flags or {
						1,
						1,
						1,
						1,
						1,
						1
					}

					uiEasy.setTeamBuffItem(var_11_2.sprite, var_11_6, var_11_10[iter_11_0])
				end
			elseif var_11_2.dbdata then
				var_11_2.sprite:get("icon"):removeAllChildren()

				var_11_2.dbdata = nil

				var_11_4:hide()
			end

			if not var_10_13[arg_11_1[iter_11_0]] and arg_11_1[iter_11_0] then
				var_11_1 = false
			end
		end

		if not var_11_1 or itertools.size(var_10_13) ~= var_11_0 then
			var_10_13 = itertools.map(arg_11_1, function(arg_12_0, arg_12_1)
				return arg_12_1, arg_12_0
			end)
		end

		arg_10_0.battleNum:set(var_11_0 .. "/" .. arg_10_0.embattleMax)

		if var_0_5[arg_10_0.specialLimitType] == var_0_4.unlock then
			local var_11_11 = arg_10_0:skillUnlockJudge()

			arg_10_0.limitSkillPanel:get("iconLock"):setVisible(not var_11_11)
			arg_10_0.limitSkillPanel:get("skillIcon"):setColor(var_11_11 and cc.c4b(255, 255, 255, 255) or cc.c4b(91, 84, 91, 153))
		end

		if arg_10_0.specialLimitType == 3 then
			local var_11_12 = arg_10_0.bossLimitCfg.specialLimitParameter
			local var_11_13 = var_11_12.count
			local var_11_14 = 0

			for iter_11_1, iter_11_2 in pairs(arg_11_1) do
				local var_11_15 = csv.unit[iter_11_2].rarity

				if itertools.include(var_11_12.rarities, var_11_15) then
					var_11_14 = var_11_14 + 1
				end
			end

			arg_10_0.limitPanel:get("txt"):text(string.format(gLanguageCsv.mimicryNumLimit, var_11_14, var_11_13))
		end
	end)
	idlereasy.when(arg_10_0.draggingIndex, function(arg_13_0, arg_13_1)
		for iter_13_0 = 1, arg_10_0.panelNum do
			local var_13_0 = arg_10_0.heroSprite[iter_13_0].sprite:get("icon"):getChildren()

			if var_13_0[1] then
				var_13_0[1]:setCascadeOpacityEnabled(true)

				if arg_13_1 == 0 then
					var_13_0[1]:opacity(255)
				elseif arg_13_1 == -1 then
					var_13_0[1]:opacity(155)
				elseif arg_13_1 == iter_13_0 then
					var_13_0[1]:opacity(255)
				else
					var_13_0[1]:opacity(155)
				end
			end
		end
	end)
	arg_10_0.initSelectHalo(arg_10_0)
end

function var_0_3.limtFunc(arg_14_0, arg_14_1)
	if var_0_5[arg_14_0.specialLimitType] == var_0_4.hide and not arg_14_0.battleUpJudge(arg_14_0, arg_14_1) then
		return nil
	end

	local var_14_0 = csv.cards[arg_14_1.card_id]
	local var_14_1 = csv.unit[arg_14_1.unit_id]

	return {
		getTime = 0,
		fighting_point = 0,
		card_id = arg_14_1.card_id,
		csvID = arg_14_1.csvID,
		unit_id = arg_14_1.unit_id,
		rarity = var_14_1.rarity,
		attr1 = var_14_1.natureType,
		attr2 = var_14_1.natureType2,
		level = arg_14_1.level,
		star = arg_14_1.star,
		advance = arg_14_1.advance,
		battle = arg_14_1.inBattle,
		atkType = var_14_0.atkType,
		markId = var_14_0.cardMarkID,
		held_item = arg_14_1.held_item,
		skin_id = arg_14_1.skin_id
	}
end

function var_0_3.createMovePanel(arg_15_0, arg_15_1)
	if arg_15_0.movePanel then
		arg_15_0.movePanel:removeSelf()
	end

	local var_15_0 = csv.unit[arg_15_1.unit_id]
	local var_15_1 = arg_15_0.spriteItem:clone():addTo(arg_15_0:getResourceNode(), 1000)

	var_15_1:show()

	local var_15_2 = arg_15_1.held_item

	if var_15_2 then
		local var_15_3 = gGameModel.held_items:find(var_15_2):read("held_item_id")
		local var_15_4 = csv.held_item.items[var_15_3]

		var_15_1:get("held"):get("heldIcon"):texture(var_15_4.icon)
		var_15_1:get("held"):show()
	end

	local var_15_5 = var_15_1:get("icon"):size()

	widget.addAnimationByKey(var_15_1:get("icon"), var_15_0.unitRes, "hero", "run_loop", 1000):scale(var_15_0.scale * 0.7):alignCenter(var_15_5):setSkin(var_15_0.skin)
	widget.addAnimationByKey(var_15_1:get("icon"), "effect/buzhen.skel", "effect", "effect_loop", 1002):scale(1):alignCenter(var_15_5)

	arg_15_0.movePanel = var_15_1

	arg_15_0.draggingIndex:set(-1)

	return var_15_1
end

function var_0_3.onCardClick(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	local var_16_1 = arg_16_0.getKey(arg_16_0, arg_16_1)
	local var_16_2 = arg_16_0.getIdxByDbId(arg_16_0, var_16_1)

	if arg_16_1.battle > 0 then
		if arg_16_0.canBattleDown(arg_16_0, arg_16_1.battle) then
			arg_16_0.downBattle(arg_16_0, var_16_1)
			arg_16_0.playHeldAction(arg_16_0, arg_16_1, var_16_2, nil, true)

			var_16_0 = gLanguageCsv.downToEmbattle
		else
			var_16_0 = gLanguageCsv.battleCannotEmpty
		end
	else
		local var_16_3 = arg_16_0.getIdxByDbId(arg_16_0)
		local var_16_4, var_16_5, var_16_6 = arg_16_0.canBattleUp(arg_16_0, arg_16_1, var_16_3)

		if not var_16_4 then
			var_16_0 = gLanguageCsv.battleCardCountEnough
		elseif arg_16_0.hasSameMarkIDCard(arg_16_0, arg_16_1) then
			var_16_0 = gLanguageCsv.alreadyHaveSameSprite
		elseif not var_16_5 then
			var_16_0 = var_16_6
		else
			arg_16_0.upBattle(arg_16_0, var_16_1, var_16_3)
			arg_16_0.playHeldAction(arg_16_0, arg_16_1, nil, var_16_3)

			var_16_0 = gLanguageCsv.addToEmbattle
		end
	end

	if arg_16_2 and var_16_0 then
		gGameUI:showTip(var_16_0)
	end
end

function var_0_3.onCardMove(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0
	local var_17_1 = arg_17_0:getKey(arg_17_1)
	local var_17_2 = arg_17_0:getIdxByDbId(var_17_1)
	local var_17_3 = arg_17_0.clientBattleCards:read()[arg_17_2]
	local var_17_4

	var_17_4 = var_17_2 == nil and 0 or 1

	if arg_17_2 then
		if arg_17_1.battle > 0 then
			arg_17_0.clientBattleCards:modify(function(arg_18_0)
				arg_18_0[var_17_2], arg_18_0[arg_17_2] = arg_18_0[arg_17_2], arg_18_0[var_17_2]

				return true, arg_18_0
			end, true)
			arg_17_0:playHeldAction(arg_17_1, nil, arg_17_2)
		else
			local var_17_5 = arg_17_0.hasSameMarkIDCard(arg_17_0, arg_17_1)

			if var_17_5 and var_17_5 ~= arg_17_2 then
				var_17_0 = gLanguageCsv.alreadyHaveSameSprite
			else
				local var_17_6, var_17_7, var_17_8 = arg_17_0.canBattleUp(arg_17_0, arg_17_1, arg_17_2)

				if not var_17_3 and not var_17_6 then
					var_17_0 = gLanguageCsv.battleCardCountEnough
				elseif not var_17_7 then
					var_17_0 = var_17_8
				else
					arg_17_0.upBattle(arg_17_0, var_17_1, arg_17_2)
					arg_17_0.playHeldAction(arg_17_0, arg_17_1, nil, arg_17_2)

					var_17_0 = gLanguageCsv.addToEmbattle
				end
			end
		end
	end

	if arg_17_3 and var_17_0 then
		gGameUI:showTip(var_17_0)
	end
end

function var_0_3.onBattleCardTouch(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.clientBattleCards:read()[arg_19_1]

	if not var_19_0 then
		return
	end

	local var_19_1 = arg_19_0.getCardAttrs(arg_19_0, var_19_0)

	if arg_19_2.name == "began" then
		arg_19_0:createMovePanel(var_19_1)
		arg_19_0.selectIndex:set(arg_19_1)
		arg_19_0.heroSprite[arg_19_1].sprite:hide()
		arg_19_0.movePanel:xy(arg_19_2.x, arg_19_2.y)
	elseif arg_19_2.name == "moved" then
		arg_19_0.moveMovePanel(arg_19_0, arg_19_2)
	elseif arg_19_2.name == "ended" or arg_19_2.name == "cancelled" then
		arg_19_0.heroSprite[arg_19_1].sprite:show()
		arg_19_0:deleteMovingItem()

		if arg_19_2.y < 340 then
			arg_19_0.onCardClick(arg_19_0, var_19_1, true)
		else
			local var_19_2 = arg_19_0.whichEmbattleTargetPos(arg_19_0, arg_19_2)

			if var_19_2 then
				if var_19_2 ~= arg_19_1 then
					arg_19_0.onCardMove(arg_19_0, var_19_1, var_19_2, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_19_0.onCardMove(arg_19_0, var_19_1, var_19_2, false)
				end
			else
				arg_19_0.onCardMove(arg_19_0, var_19_1, arg_19_1, false)
			end

			arg_19_0.playHeldAction(arg_19_0, var_19_1, arg_19_1, var_19_2)
		end
	end
end

function var_0_3.playHeldAction(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_4 and arg_20_2 then
		arg_20_0.heroSprite[arg_20_2].sprite:get("held"):stopAllActions()
		arg_20_0.heroSprite[arg_20_2].sprite:get("held"):hide()

		return
	end

	if not arg_20_2 and not arg_20_3 then
		return
	end

	local var_20_0 = arg_20_1.held_item

	if not var_20_0 then
		if arg_20_3 then
			arg_20_0.heroSprite[arg_20_3].sprite:get("held"):stopAllActions()
			arg_20_0.heroSprite[arg_20_3].sprite:get("held"):hide()
		end

		return
	end

	local var_20_1 = arg_20_0.heroSprite[arg_20_3 or arg_20_2].sprite
	local var_20_2 = gGameModel.held_items:find(var_20_0):read("held_item_id")
	local var_20_3 = csv.held_item.items[var_20_2]

	if arg_20_2 then
		arg_20_0.heroSprite[arg_20_2].sprite:get("held"):stopAllActions()
		arg_20_0.heroSprite[arg_20_2].sprite:get("held"):hide()
	end

	var_20_1:get("held"):get("heldIcon"):texture(var_20_3.icon)
	var_20_1:get("held"):show()
	var_20_1:get("held"):get("heldIcon"):setOpacity(255)
	var_20_1:get("held"):get("heldBg"):setOpacity(255)
	transition.executeSequence(var_20_1:get("held"):get("heldIcon"), true):delay(2):fadeOut(0.5):done()
	transition.executeSequence(var_20_1:get("held"):get("heldBg"), true):delay(2):fadeOut(0.5):done()
end

function var_0_3.initRoundUIPanel(arg_21_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_21_0.fightNote,
			"pos",
			"right"
		},
		{
			arg_21_0.btnChallenge,
			"pos",
			"right"
		},
		{
			arg_21_0.btnJump,
			"pos",
			"right"
		},
		{
			arg_21_0.rightDown,
			"pos",
			"right"
		},
		{
			arg_21_0.btnQuickChallenge,
			"pos",
			"right"
		}
	})
	arg_21_0:initLimitPanel()

	local var_21_0 = true

	arg_21_0.rightDown:hide()
	arg_21_0.btnChallenge:show()
	arg_21_0.btnQuickChallenge:hide()
	arg_21_0.btnJump:hide()
	arg_21_0.btnReady:hide()

	if arg_21_0.isQuick then
		local var_21_1 = csv.mimicry.base[1].battleTimesLimit
		local var_21_2 = cc.clampf(gGameModel.daily_record:read("mimicry_battle_times"), 0, var_21_1)
		local var_21_3 = math.min(3, var_21_2)

		if var_21_3 > 1 then
			arg_21_0.btnQuickChallenge:show()
			arg_21_0.btnChallenge:y(arg_21_0.btnChallenge:getPositionY() - 100)
		end

		arg_21_0.btnChallenge:get("textNote"):text(string.format(gLanguageCsv.mimicryQuickChallenge, math.max(1, var_21_3)))
	end

	arg_21_0.textTip:text(gLanguageCsv.mimicryLineup)
end

function var_0_3.limitPanelShow(arg_22_0, arg_22_1)
	local var_22_0 = {
		arg_22_0.limitPanel,
		arg_22_0.limitCardPanel,
		arg_22_0.limitSkillPanel
	}

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		iter_22_1:setVisible(iter_22_1 == arg_22_1)
	end
end

function var_0_3.adaptLimitPanel(arg_23_0, arg_23_1)
	local var_23_0 = {}
	local var_23_1
	local var_23_2
	local var_23_3
	local var_23_4

	if arg_23_1 == "card" then
		var_23_0 = {
			limitSize = itertools.size(arg_23_0.limitCardData),
			limitList = arg_23_0.limitCardList,
			bg = arg_23_0.limitCardPanel:get("bg"),
			cell = arg_23_0.limitCell
		}
		arg_23_0.xMargins = 5
		arg_23_0.yMargins = -20
	else
		var_23_0 = {
			limitSize = itertools.size(arg_23_0.limitData),
			limitList = arg_23_0.limitList,
			bg = arg_23_0.limitPanel:get("bg"),
			cell = arg_23_0.rareItem
		}
		arg_23_0.yMargins = -40
	end

	local var_23_5 = 6
	local var_23_6 = math.ceil(var_23_0.limitSize / var_23_5)
	local var_23_7 = math.min(math.ceil(var_23_0.limitSize / var_23_6), var_23_5)

	var_23_0.bg:width(math.max(0, var_23_6 * var_23_0.bg:width()))
	var_23_0.bg:height(math.max(0, var_23_7 * var_23_0.cell:height() + (var_23_7 - 1) * arg_23_0.xMargins + 50))
	var_23_0.limitList:x(var_23_0.limitList:x() - (var_23_6 * var_23_0.limitList:width() + (var_23_6 - 1) * arg_23_0.yMargins) / 2 + var_23_0.limitList:width() / 2)

	arg_23_0.limitColumnSize = var_23_5 >= var_23_0.limitSize and var_23_5 or var_23_7
end

function var_0_3.initLimitPanel(arg_24_0)
	local var_24_0 = arg_24_0.bossLimitCfg.specialLimitParameter

	arg_24_0.limitData = {}
	arg_24_0.limitCardData = {}

	local function var_24_1(arg_25_0, arg_25_1)
		arg_24_0:limitPanelShow(arg_24_0.limitSkillPanel)

		local var_25_0 = csv.skill[arg_25_1]

		arg_24_0.limitSkillPanel:get("skillIcon"):setTouchEnabled(true)
		arg_24_0.limitSkillPanel:get("skillIcon"):texture(var_25_0.iconRes)
		bind.touch(arg_24_0, arg_24_0.limitSkillPanel:get("skillIcon"), {
			methods = {
				ended = function()
					local var_26_0 = gGameUI:stackUI("common.skill_detail", nil, {
						clickClose = true
					}, {
						ignoreStar = false,
						hideSkillLevel = false,
						skillLevel = 1,
						skillId = arg_25_1,
						skillIcon = var_25_0.iconRes
					})
					local var_26_1 = var_26_0:getResourceNode()
					local var_26_2, var_26_3 = var_26_1:xy()

					var_26_1:xy(arg_24_0.limitSkillPanel:x() / 2 + 950, var_26_0.panel:y() + 200)
				end
			}
		})
		print(">>>>>>", arg_25_0)

		local var_25_1 = arg_24_0.limitSkillPanel:get("skillDesc")
		local var_25_2 = rich.createWithWidth(arg_25_0, 44, nil, 380, nil, cc.p(0, 0))

		var_25_2:anchorPoint(0, 1):xy(0, var_25_1:height()):addTo(var_25_1, 2):name("richText")
		arg_24_0.limitSkillPanel:get("bg"):height(var_25_2:height() + 300)
	end

	local var_24_2 = {
		function()
			arg_24_0.limitData = var_24_0.rarities or {}

			arg_24_0:adaptLimitPanel()
			arg_24_0:limitPanelShow(arg_24_0.limitPanel)
		end,
		function()
			arg_24_0.limitData = var_24_0.natureTypes or {}
			arg_24_0.xMargins = -20

			arg_24_0:adaptLimitPanel()
			arg_24_0:limitPanelShow(arg_24_0.limitPanel)
		end,
		function()
			arg_24_0.limitData = var_24_0.rarities or {}

			arg_24_0:adaptLimitPanel()
			arg_24_0:limitPanelShow(arg_24_0.limitPanel)
		end,
		function()
			arg_24_0.limitCardData = var_24_0.cardIDs or {}

			arg_24_0:adaptLimitPanel("card")
			arg_24_0:limitPanelShow(arg_24_0.limitCardPanel)
		end
	}

	if not var_0_5[arg_24_0.specialLimitType] then
		arg_24_0.limitPanel:hide()
	elseif var_24_2[arg_24_0.specialLimitType] then
		var_24_2[arg_24_0.specialLimitType]()
	else
		var_0_2.bossType(arg_24_0.bossLimitCfg, arg_24_0.bossCfg, var_24_1)
	end

	arg_24_0.bossPanel:get("bossIcon"):texture(csv.mimicry.boss[arg_24_0.bossID].cardIcon)
end

function var_0_3.canBattleUp(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0.clientBattleCards:size() < arg_31_0.embattleMax
	local var_31_1 = true
	local var_31_2

	if var_0_5[arg_31_0.specialLimitType] ~= var_0_4.unlock then
		var_31_1 = arg_31_0.battleUpJudge(arg_31_0, arg_31_1, arg_31_2)

		if arg_31_0.specialLimitType == 3 and not var_31_1 then
			var_31_2 = gLanguageCsv.mimicryLimit
		end
	end

	return var_31_0, var_31_1, var_31_2
end

function var_0_3.skillUnlockJudge(arg_32_0)
	local var_32_0 = arg_32_0.bossLimitCfg.specialLimitParameter
	local var_32_1 = {}

	for iter_32_0, iter_32_1 in pairs(arg_32_0.clientBattleCards:read()) do
		var_32_1[iter_32_0] = arg_32_0.getCardAttrs(arg_32_0, iter_32_1)
	end

	return ({
		[5] = function()
			for iter_33_0, iter_33_1 in csvMapPairs(var_32_0.cardIDs) do
				local var_33_0 = false

				for iter_33_2, iter_33_3 in pairs(var_32_1) do
					if iter_33_3.card_id == iter_33_1 then
						var_33_0 = true

						break
					end
				end

				if not var_33_0 then
					return false
				end
			end

			return true
		end,
		[6] = function()
			for iter_34_0, iter_34_1 in csvMapPairs(var_32_0.cardIDs) do
				for iter_34_2, iter_34_3 in pairs(var_32_1) do
					if iter_34_1 == iter_34_3.card_id then
						return true
					end
				end
			end

			return false
		end,
		[7] = function()
			local var_35_0 = false
			local var_35_1 = var_32_0.count
			local var_35_2 = 0

			for iter_35_0, iter_35_1 in pairs(var_32_1) do
				local var_35_3 = iter_35_1.unit_id
				local var_35_4 = csv.unit[var_35_3].rarity

				if itertools.include(var_32_0.rarities, var_35_4) then
					var_35_2 = var_35_2 + 1
				end

				if var_35_1 <= var_35_2 then
					var_35_0 = true

					break
				end
			end

			return var_35_0
		end,
		[8] = function()
			local var_36_0 = false
			local var_36_1 = var_32_0.count
			local var_36_2 = 0

			for iter_36_0, iter_36_1 in pairs(var_32_1) do
				local var_36_3 = iter_36_1.unit_id
				local var_36_4 = csv.unit[var_36_3].natureType
				local var_36_5 = csv.unit[var_36_3].natureType2

				if itertools.include(var_32_0.natureTypes, var_36_4) or itertools.include(var_32_0.natureTypes, var_36_5) then
					var_36_2 = var_36_2 + 1
				end

				if var_36_1 <= var_36_2 then
					var_36_0 = true

					break
				end
			end

			return var_36_0
		end,
		[9] = function()
			local var_37_0 = false

			for iter_37_0, iter_37_1 in pairs(var_32_1) do
				local var_37_1 = iter_37_1.unit_id
				local var_37_2 = csv.unit[var_37_1].natureType
				local var_37_3 = csv.unit[var_37_1].natureType2

				if itertools.include(var_32_0.natureTypes, var_37_2) or itertools.include(var_32_0.natureTypes, var_37_3) then
					var_37_0 = true

					break
				end
			end

			return var_37_0
		end
	})[arg_32_0.specialLimitType]()
end

function var_0_3.battleUpJudge(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = dataEasy.getUnitId(arg_38_1.card_id, arg_38_1.skin_id)
	local var_38_1 = csv.unit[var_38_0]
	local var_38_2 = var_38_1.rarity
	local var_38_3 = var_38_1.natureType
	local var_38_4 = var_38_1.natureType2
	local var_38_5 = arg_38_0.bossLimitCfg.specialLimitParameter

	if not var_38_5 then
		return true
	end

	local var_38_6 = {
		function()
			local var_39_0 = false

			if var_38_5.rarities then
				var_39_0 = itertools.include(var_38_5.rarities, var_38_2)
			end

			return var_39_0
		end,
		function()
			local var_40_0 = false

			if var_38_5.natureTypes then
				var_40_0 = itertools.include(var_38_5.natureTypes, var_38_3) or itertools.include(var_38_5.natureTypes, var_38_4)
			end

			return var_40_0
		end,
		function()
			if not itertools.include(var_38_5.rarities, var_38_2) then
				return true
			else
				local var_41_0 = {}

				for iter_41_0, iter_41_1 in pairs(arg_38_0.clientBattleCards:read()) do
					var_41_0[iter_41_0] = arg_38_0:getCardAttrs(iter_41_1)
				end

				local var_41_1 = var_38_5.count
				local var_41_2 = 0

				for iter_41_2 = 1, arg_38_0.embattleMax do
					local var_41_3 = arg_38_2 == iter_41_2 and arg_38_1 or var_41_0[iter_41_2]

					if var_41_3 then
						local var_41_4 = var_41_3.unit_id
						local var_41_5 = csv.unit[var_41_4].rarity

						if itertools.include(var_38_5.rarities, var_41_5) then
							var_41_2 = var_41_2 + 1
						end

						if var_41_1 < var_41_2 then
							return false
						end
					end
				end

				return true
			end
		end,
		function()
			return not itertools.include(var_38_5.cardIDs, arg_38_1.card_id)
		end
	}

	if var_38_6[arg_38_0.specialLimitType] then
		return var_38_6[arg_38_0.specialLimitType]()
	end

	return true
end

function var_0_3.fightBtn(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.clientBattleCards:read()

	if not next(var_43_0) then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	if gGameModel.daily_record:read("mimicry_battle_times") <= 0 then
		gGameUI:showTip(gLanguageCsv.todayChanllengeToMuch)

		return
	end

	local var_43_1 = {}

	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		var_43_1[iter_43_0] = arg_43_0.getCardAttrs(arg_43_0, iter_43_1)
	end

	if arg_43_0.isQuick then
		arg_43_0.fightCb(arg_43_0, var_43_1, arg_43_1, function()
			arg_43_0:onClose()
		end)
	else
		arg_43_0.fightCb(arg_43_0, var_43_1)
	end
end

function var_0_3.onClose(arg_45_0)
	if not arg_45_0.isQuick then
		local var_45_0 = {}
		local var_45_1 = {}

		for iter_45_0, iter_45_1 in pairs(arg_45_0.clientBattleCards:read()) do
			local var_45_2 = arg_45_0.getCardAttrs(arg_45_0, iter_45_1)

			if var_45_2 then
				var_45_0[iter_45_0] = var_45_2.csvID

				if var_45_2.skin_id and var_45_2.skin_id ~= 0 then
					var_45_1[var_45_2.card_id] = var_45_2.skin_id
				end
			end
		end

		local var_45_3 = userDefault.getForeverLocalKey("mimicryBattleCard", {})

		var_45_3[arg_45_0.bossID] = {
			cards = var_45_0,
			skins = var_45_1
		}

		userDefault.setForeverLocalKey("mimicryBattleCard", var_45_3, {
			new = true
		})
	end

	var_0_0.onClose(arg_45_0)
end

return var_0_3
