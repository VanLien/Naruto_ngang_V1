local var_0_0 = 6
local var_0_1 = {
	2,
	4,
	6,
	1,
	3,
	5
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = require("app.views.city.card.embattle.base")
local var_0_4 = class("SummerChallengleEmbattle", var_0_3)

var_0_4.RESOURCE_FILENAME = "summer_challenge_embattle.json"
var_0_4.RESOURCE_BINDING = {
	["rightDown.textNum"] = "textNum",
	["rightDown.textNote"] = "textNote",
	bottomPanel = "bottomPanel",
	rightDown = "rightDown",
	battlePanel1 = "leftPanel",
	battlePanel2 = "rightPanel",
	spritePanel = "spriteItem",
	["rightDown.btnChallenge"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("fightBtn")
			}
		}
	},
	["rightDown.btnOneKeySet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["battlePanel1.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["battlePanel1.back.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["battlePanel2.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["battlePanel2.back.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["battlePanel1.fightNote.btnGHimg"] = {
		varname = "btnGHimg1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_1_0)
					arg_1_0:onTeamBuffClick(1)
				end)
			}
		}
	},
	["battlePanel2.fightNote.btnGHimg"] = {
		varname = "btnGHimg2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_2_0)
					arg_2_0:onTeamBuffClick(2)
				end)
			}
		}
	}
}

function var_0_4.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose", true)
	}):init({
		subTitle = "SUMMERCHALLENGE",
		title = gLanguageCsv.summerChallenge
	})
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_3_0.rightDown,
			"pos",
			"right"
		}
	})
	arg_3_0:initModel()

	arg_3_0.fightCb = arg_3_1.fightCb
	arg_3_0.gateCfg = arg_3_1.gateCfg
	arg_3_0.gateID = arg_3_1.gateID
	arg_3_0.emenyDatas = {}
	arg_3_0.heroSprite = {}
	arg_3_0.enemySprite = {}
	arg_3_0.teamSelfBuff = {}
	arg_3_0.teamEnemyBuff = {}
	arg_3_0.panel = {
		{
			parent = arg_3_0.leftPanel,
			list = arg_3_0.heroSprite
		},
		{
			parent = arg_3_0.rightPanel,
			list = arg_3_0.enemySprite
		}
	}

	arg_3_0:updateData()
	arg_3_0:initSpriteItem()
	arg_3_0:initEnemyUI()
	arg_3_0:initBottomList()
	arg_3_0:refreshTeamBuff(arg_3_0.emenyDatas, 2)
	idlereasy.when(arg_3_0.clientBattleCards, function(arg_4_0, arg_4_1)
		arg_3_0:refreshTeamBuff(arg_4_1, 1)
		arg_3_0:showBattleNum(arg_4_1)

		for iter_4_0 = 1, var_0_0 do
			arg_3_0:initHeroSprite(iter_4_0)
		end
	end)
end

function var_0_4.initModel(arg_5_0)
	arg_5_0.clientBattleCards = idlertable.new({})
	arg_5_0.battleCardsData = idlertable.new({})
	arg_5_0.allCardDatas = idlers.newWithMap({})
	arg_5_0.selectIndex = idler.new(0)
	arg_5_0.draggingIndex = idler.new(0)
end

function var_0_4.checkBattleCards(arg_6_0, arg_6_1)
	local var_6_0 = {
		0,
		0,
		0,
		0,
		0,
		0
	}

	if itertools.size(arg_6_1) ~= var_0_0 then
		return var_6_0
	end

	local var_6_1 = arg_6_0.gateCfg.deployLock
	local var_6_2 = arg_6_0.gateCfg.autoCards
	local var_6_3 = arraytools.hash(arg_6_0.gateCfg.cards)

	for iter_6_0, iter_6_1 in csvMapPairs(var_6_2) do
		if iter_6_1 > 0 and arg_6_1[iter_6_1] ~= 0 and arg_6_1[iter_6_1] ~= iter_6_0 then
			arg_6_1[iter_6_1] = 0
		end
	end

	for iter_6_2 = 1, var_0_0 do
		if arg_6_1[iter_6_2] ~= 0 and (var_6_1[iter_6_2] == 1 or not var_6_3[arg_6_1[iter_6_2]]) then
			arg_6_1[iter_6_2] = 0
		end
	end

	return arg_6_1
end

function var_0_4.updateData(arg_7_0)
	local var_7_0 = table.deepcopy(arg_7_0.gateCfg.cards)
	local var_7_1 = arg_7_0.gateCfg.deployLock
	local var_7_2 = 0

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if iter_7_1 == 0 then
			var_7_2 = var_7_2 + 1
		end
	end

	arg_7_0.battleNum = var_7_2

	local var_7_3 = arg_7_0.gateCfg.autoCards
	local var_7_4 = {}
	local var_7_5 = {}
	local var_7_6 = string.format("summerChallengeEmbattle%d", arg_7_0.gateID)
	local var_7_7 = userDefault.getForeverLocalKey(var_7_6, {
		0,
		0,
		0,
		0,
		0,
		0
	})
	local var_7_8 = arg_7_0:checkBattleCards(var_7_7)
	local var_7_9 = var_7_8
	local var_7_10 = var_7_8

	for iter_7_2, iter_7_3 in ipairs(var_7_8) do
		var_7_4[iter_7_3] = true
	end

	local var_7_11 = {}

	for iter_7_4, iter_7_5 in csvPairs(var_7_3) do
		if not var_7_4[iter_7_4] then
			if iter_7_5 == 0 then
				table.insert(var_7_11, iter_7_4)
			elseif var_7_1[iter_7_5] == 1 then
				printError("pos(%s) was lock, gateID(%s)", iter_7_5, arg_7_0.gateID)
			else
				var_7_9[iter_7_5] = iter_7_4
				var_7_10[iter_7_5] = iter_7_4
			end

			var_7_4[iter_7_4] = true
		end

		table.insert(var_7_0, iter_7_4)
	end

	for iter_7_6 = 1, var_0_0 do
		if var_7_9[iter_7_6] == 0 and var_7_1[iter_7_6] == 0 and var_7_11[1] then
			local var_7_12 = var_7_11[1]

			var_7_9[iter_7_6] = var_7_12
			var_7_10[iter_7_6] = var_7_12

			table.remove(var_7_11, 1)
		end
	end

	arg_7_0.clientBattleCards:set(var_7_10)
	arg_7_0.battleCardsData:set(var_7_9)

	local var_7_13 = {}
	local var_7_14 = csv.summer_challenge.cards

	for iter_7_7, iter_7_8 in pairs(var_7_0) do
		local var_7_15 = var_7_14[iter_7_8]
		local var_7_16 = csv.cards[var_7_15.cardID]
		local var_7_17 = csv.unit[var_7_16.unitID]

		var_7_13[iter_7_8] = {
			isNew = false,
			csvID = iter_7_8,
			card_id = var_7_15.cardID,
			unit_id = var_7_16.unitID,
			level = var_7_15.level,
			star = var_7_15.star,
			advance = var_7_15.advance,
			rarity = var_7_17.rarity,
			attr1 = var_7_17.natureType,
			attr2 = var_7_17.natureType2,
			markId = var_7_16.cardMarkID,
			battle = var_7_4[iter_7_8] and 1 or 0,
			lock = var_7_3[iter_7_8] or -1
		}
	end

	arg_7_0.allCardDatas:update(var_7_13)
end

function var_0_4.showBattleNum(arg_8_0, arg_8_1)
	local var_8_0 = 0

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if iter_8_1 ~= 0 then
			var_8_0 = var_8_0 + 1
		end
	end

	arg_8_0.textNum:text(string.format("%d/%d", var_8_0, arg_8_0.battleNum))
	adapt.oneLineCenterPos(cc.p(163, 152), {
		arg_8_0.textNote,
		arg_8_0.textNum
	}, cc.p(5, 0))
end

function var_0_4.initSpriteItem(arg_9_0)
	local var_9_0 = arg_9_0.gateCfg.deployLock

	for iter_9_0 = 1, 2 do
		local var_9_1 = arg_9_0.panel[iter_9_0].parent
		local var_9_2 = arg_9_0.panel[iter_9_0].list

		for iter_9_1 = 1, var_0_0 do
			local var_9_3 = var_9_1:get("item" .. iter_9_1)
			local var_9_4 = var_9_3:box()
			local var_9_5 = var_9_3:getParent():convertToWorldSpace(cc.p(var_9_4.x, var_9_4.y))

			var_9_4.x, var_9_4.y = var_9_5.x, var_9_5.y
			var_9_2[iter_9_1] = {
				item = var_9_3,
				rect = var_9_4,
				idx = iter_9_1
			}

			if iter_9_0 == 1 then
				var_9_3:get("posLockPanel"):visible(var_9_0[iter_9_1] == 1)

				var_9_2[iter_9_1].lock = var_9_0[iter_9_1] == 1

				var_9_3:onTouch(functools.partial(arg_9_0.onBattleCardTouch, arg_9_0, iter_9_1))
			end
		end
	end

	for iter_9_2 = 1, var_0_0 do
		local var_9_6 = arg_9_0.heroSprite[iter_9_2].item:get("imgBg")
		local var_9_7 = var_9_6:get("imgSel")
		local var_9_8 = var_9_6:size()
		local var_9_9

		var_9_9 = var_9_7 or widget.addAnimationByKey(var_9_6, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_9_8.width / 2, var_9_8.height / 2 + 15)
	end

	idlereasy.when(arg_9_0.selectIndex, function(arg_10_0, arg_10_1)
		for iter_10_0 = 1, var_0_0 do
			arg_9_0.heroSprite[iter_10_0].item:get("imgBg.imgSel"):visible(arg_10_1 == iter_10_0)
		end
	end)
	idlereasy.when(arg_9_0.draggingIndex, function(arg_11_0, arg_11_1)
		for iter_11_0 = 1, var_0_0 do
			local var_11_0 = arg_9_0.heroSprite[iter_11_0].item:get("sprite")

			if var_11_0 then
				var_11_0:setCascadeOpacityEnabled(true)

				if arg_11_1 == 0 then
					var_11_0:opacity(255)
				elseif arg_11_1 == -1 then
					var_11_0:opacity(155)
				elseif arg_11_1 == iter_11_0 then
					var_11_0:opacity(255)
				else
					var_11_0:opacity(155)
				end
			end
		end
	end)
end

function var_0_4.initEnemyUI(arg_12_0)
	local var_12_0 = arg_12_0.gateCfg.monsterIDs
	local var_12_1 = var_12_0[table.length(var_12_0)]
	local var_12_2 = csv.summer_challenge.monsters[var_12_1]
	local var_12_3 = csv.summer_challenge.cards

	arg_12_0.emenyDatas = {}

	for iter_12_0, iter_12_1 in csvPairs(var_12_2.cards) do
		arg_12_0.emenyDatas[iter_12_0] = iter_12_1
	end

	for iter_12_2 = 1, var_0_0 do
		local var_12_4 = arg_12_0.emenyDatas[iter_12_2]
		local var_12_5 = arg_12_0.enemySprite[iter_12_2]
		local var_12_6 = var_12_3[var_12_4]

		if var_12_6 then
			local var_12_7 = csv.cards[var_12_6.cardID].unitID
			local var_12_8 = csv.unit[var_12_7]
			local var_12_9 = var_12_5.item:get("imgBg")

			widget.addAnimationByKey(var_12_5.item, var_12_8.unitRes, "sprite", "standby_loop", 4):scale(-var_12_8.scale * 0.8, var_12_8.scale * 0.8):xy(var_12_9:x(), var_12_9:y() + 15):setSkin(var_12_8.skin)

			local var_12_10 = (arg_12_0.teamEnemyBuff and arg_12_0.teamEnemyBuff.flags or {
				1,
				1,
				1,
				1,
				1,
				1
			})[iter_12_2]

			uiEasy.setTeamBuffItem(var_12_5.item, var_12_6.cardID, var_12_10)
		else
			var_12_5.item:get("attrBg"):hide()
		end
	end
end

function var_0_4.initHeroSprite(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.heroSprite[arg_13_1].item
	local var_13_1 = arg_13_0:getCardAttrs(arg_13_0.clientBattleCards:read()[arg_13_1])

	if not var_13_1 then
		if var_13_0:getChildByName("sprite") then
			var_13_0:getChildByName("sprite"):hide()
		end

		var_13_0:get("attrBg"):hide()

		return
	end

	local var_13_2 = csv.unit[var_13_1.unit_id]
	local var_13_3 = var_13_0:get("imgBg")

	if var_13_0.csvID == var_13_1.csvID and var_13_0:getChildByName("sprite") then
		var_13_0:getChildByName("sprite"):show()
	else
		var_13_0:removeChildByName("sprite")
		var_13_0:removeChildByName("lock")
		var_13_0:removeChildByName("lock1")
		widget.addAnimationByKey(var_13_0, var_13_2.unitRes, "sprite", "standby_loop", 4):scale(var_13_2.scale * (0.8 + (arg_13_1 - 1) % 3 * 0.1)):xy(var_13_3:x(), var_13_3:y() + 15):setSkin(var_13_2.skin)

		var_13_0.csvID = var_13_1.csvID

		if var_13_1.lock > 0 then
			arg_13_0:createLockEffect(var_13_0, arg_13_1)
		end
	end

	local var_13_4 = var_13_1.card_id
	local var_13_5 = (arg_13_0.teamSelfBuff and arg_13_0.teamSelfBuff.flags or {
		1,
		1,
		1,
		1,
		1,
		1
	})[arg_13_1]

	uiEasy.setTeamBuffItem(var_13_0, var_13_1.card_id, var_13_5)
end

function var_0_4.createLockEffect(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {
		-40,
		0,
		5,
		-40,
		0,
		5
	}
	local var_14_1 = {
		1.8,
		2,
		2.5,
		1.8,
		2,
		2.5
	}
	local var_14_2 = "effect_hou_loop"
	local var_14_3 = widget.addAnimationByKey(arg_14_1, "summer_challenge/jld.skel", "lock", var_14_2, 2)

	var_14_3:scale(var_14_1[arg_14_2])
	var_14_3:play(var_14_2)
	var_14_3:xy(arg_14_1:width() / 2, arg_14_1:height() / 2 + var_14_0[arg_14_2])

	local var_14_4 = "effect_qian_loop"
	local var_14_5 = widget.addAnimationByKey(arg_14_1, "summer_challenge/jld.skel", "lock1", var_14_4, 50)

	var_14_5:scale(var_14_1[arg_14_2])
	var_14_5:play(var_14_4)
	var_14_5:xy(arg_14_1:width() / 2, arg_14_1:height() / 2 + var_14_0[arg_14_2])
end

function var_0_4.onBattleCardTouch(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0.clientBattleCards:read()[arg_15_1] == 0 then
		return
	end

	local var_15_0 = arg_15_0:getCardAttrs(arg_15_0.clientBattleCards:read()[arg_15_1])

	if var_15_0.lock > 0 then
		gGameUI:showTip(gLanguageCsv.cardCantMove)

		return
	end

	if arg_15_2.name == "began" then
		arg_15_0:deleteMovingItem()
		arg_15_0:createMovePanel(var_15_0)

		local var_15_1 = arg_15_0.heroSprite[arg_15_1].item

		var_15_1:get("sprite"):hide()
		var_15_1:get("attrBg"):hide()
		arg_15_0:moveMovePanel(arg_15_2)
	elseif arg_15_2.name == "moved" then
		arg_15_0:moveMovePanel(arg_15_2)
	elseif arg_15_2.name == "ended" or arg_15_2.name == "cancelled" then
		local var_15_2 = arg_15_0.heroSprite[arg_15_1].item

		var_15_2:get("sprite"):show()
		var_15_2:get("attrBg"):show()
		arg_15_0:deleteMovingItem()

		if arg_15_2.y < 340 then
			arg_15_0:onCardClick(var_15_0, true)
		else
			local var_15_3 = arg_15_0:whichEmbattleTargetPos(arg_15_2)

			if var_15_3 then
				if var_15_3 ~= arg_15_1 then
					arg_15_0:onCardMove(var_15_0, var_15_3, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_15_0:onCardMove(var_15_0, var_15_3, false)
				end
			else
				arg_15_0:onCardMove(var_15_0, arg_15_1, false)
			end
		end
	end
end

function var_0_4.initBottomList(arg_16_0)
	arg_16_0.cardListView = gGameUI:createView("city.card.embattle.summer_challenge_card_list", arg_16_0.bottomPanel):init({
		base = arg_16_0,
		clientBattleCards = arg_16_0.clientBattleCards,
		battleCardsData = arg_16_0.battleCardsData,
		deleteMovingItem = arg_16_0.deleteMovingItem,
		createMovePanel = arg_16_0.createMovePanel,
		moveMovePanel = arg_16_0.moveMovePanel,
		isMovePanelExist = arg_16_0.isMovePanelExist,
		onCardClick = arg_16_0.onCardClick,
		allCardDatas = arg_16_0.allCardDatas,
		moveEndMovePanel = arg_16_0.moveEndMovePanel,
		limtFunc = arg_16_0.limtFunc
	}, true)
end

function var_0_4.canBattleDown(arg_17_0)
	return arg_17_0.clientBattleCards:size() > 1
end

function var_0_4.canBattleUp(arg_18_0)
	local var_18_0 = 0

	for iter_18_0, iter_18_1 in arg_18_0.clientBattleCards:pairs() do
		if iter_18_1 > 0 then
			var_18_0 = var_18_0 + 1
		end
	end

	return var_18_0 < arg_18_0.battleNum
end

function var_0_4.whichEmbattleTargetPos(arg_19_0, arg_19_1)
	for iter_19_0 = var_0_0, 1, -1 do
		local var_19_0 = arg_19_0.heroSprite[iter_19_0].rect

		if cc.rectContainsPoint(var_19_0, arg_19_1) then
			return iter_19_0
		end
	end
end

function var_0_4.deleteMovingItem(arg_20_0)
	arg_20_0.selectIndex:set(0)

	if arg_20_0.movePanel then
		arg_20_0.movePanel:removeSelf()

		arg_20_0.movePanel = nil
	end

	arg_20_0.draggingIndex:set(0)
end

function var_0_4.moveMovePanel(arg_21_0, arg_21_1)
	if arg_21_0.movePanel then
		arg_21_0.movePanel:xy(arg_21_1)
		arg_21_0.selectIndex:set(arg_21_0:whichEmbattleTargetPos(arg_21_1))
	end
end

function var_0_4.moveEndMovePanel(arg_22_0, arg_22_1)
	if not arg_22_0.movePanel then
		return
	end

	local var_22_0 = arg_22_0.selectIndex:read()

	arg_22_0:onCardMove(arg_22_1, var_22_0, true)
	arg_22_0:deleteMovingItem()
end

function var_0_4.isMovePanelExist(arg_23_0)
	return arg_23_0.movePanel ~= nil
end

function var_0_4.getIdxByDbId(arg_24_0, arg_24_1)
	for iter_24_0 = 1, var_0_0 do
		if (arg_24_0.clientBattleCards:read()[iter_24_0] or 0) == arg_24_1 then
			return iter_24_0
		end
	end
end

function var_0_4.onCardMove(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0
	local var_25_1 = arg_25_1.csvID
	local var_25_2 = arg_25_0:getIdxByDbId(var_25_1)
	local var_25_3 = arg_25_0.clientBattleCards:read()[arg_25_2]
	local var_25_4 = arg_25_0:getCardAttrs(var_25_3)
	local var_25_5

	var_25_5 = var_25_2 == nil and 0 or 1

	if arg_25_2 then
		if arg_25_0.gateCfg.deployLock[arg_25_2] == 1 then
			gGameUI:showTip(gLanguageCsv.posLock)

			return
		end

		if arg_25_1.battle > 0 then
			if var_25_4 and var_25_4.lock > 0 then
				gGameUI:showTip(gLanguageCsv.cardCantMove)

				return
			end

			arg_25_0.clientBattleCards:modify(function(arg_26_0)
				arg_26_0[var_25_2], arg_26_0[arg_25_2] = arg_26_0[arg_25_2], arg_26_0[var_25_2]

				return true, arg_26_0
			end, true)
		else
			if var_25_4 and var_25_4.lock >= 0 then
				gGameUI:showTip(gLanguageCsv.cardCantDown)

				return
			end

			local var_25_6 = arg_25_0:hasSameMarkIDCard(arg_25_1)

			if var_25_6 and var_25_6 ~= arg_25_2 then
				var_25_0 = gLanguageCsv.alreadyHaveSameSprite
			elseif not var_25_3 and not arg_25_0:canBattleUp() then
				var_25_0 = gLanguageCsv.battleCardCountEnough
			else
				arg_25_0:upBattle(var_25_1, arg_25_2)

				var_25_0 = gLanguageCsv.addToEmbattle
			end
		end
	end

	if arg_25_3 and var_25_0 then
		gGameUI:showTip(var_25_0)
	end
end

function var_0_4.onCardClick(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0
	local var_27_1 = arg_27_1.csvID
	local var_27_2 = arg_27_0:getIdxByDbId(var_27_1)

	if arg_27_1.battle > 0 then
		if arg_27_1.lock >= 0 then
			gGameUI:showTip(gLanguageCsv.cardCantDown)

			return
		end

		if arg_27_0:canBattleDown() then
			arg_27_0:downBattle(var_27_1, true)
		else
			var_27_0 = gLanguageCsv.battleCannotEmpty
		end
	else
		local var_27_3 = arg_27_0:getBattleIdx()

		if not arg_27_0:canBattleUp() then
			var_27_0 = gLanguageCsv.battleCardCountEnough
		elseif arg_27_0:hasSameMarkIDCard(arg_27_1) then
			var_27_0 = gLanguageCsv.alreadyHaveSameSprite
		else
			arg_27_0:upBattle(var_27_1, var_27_3)
		end
	end

	if arg_27_2 and var_27_0 then
		gGameUI:showTip(var_27_0)
	end
end

function var_0_4.getBattleIdx(arg_28_0)
	for iter_28_0 = 1, var_0_0 do
		if (arg_28_0.clientBattleCards:read()[iter_28_0] or 0) == 0 and arg_28_0.gateCfg.deployLock[iter_28_0] == 0 then
			return iter_28_0
		end
	end
end

function var_0_4.downBattle(arg_29_0, arg_29_1)
	arg_29_0:getCardAttrs(arg_29_1).battle = 0

	local var_29_0 = arg_29_0:getIdxByDbId(arg_29_1)

	arg_29_0.clientBattleCards:modify(function(arg_30_0)
		arg_30_0[var_29_0] = 0

		return true, arg_30_0
	end, true)
end

function var_0_4.upBattle(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0.clientBattleCards:read()[arg_31_2]

	if var_31_0 ~= 0 then
		arg_31_0:getCardAttrs(var_31_0).battle = 0
	end

	arg_31_0.clientBattleCards:modify(function(arg_32_0)
		arg_32_0[arg_31_2] = arg_31_1
		arg_31_0:getCardAttrs(arg_31_1).battle = 1
		arg_31_0:getCardAttrs(arg_31_1).isNew = false

		return true, arg_32_0
	end, true)
end

function var_0_4.hasSameMarkIDCard(arg_33_0, arg_33_1)
	for iter_33_0 = 1, var_0_0 do
		local var_33_0 = arg_33_0.clientBattleCards:read()[iter_33_0]

		if var_33_0 ~= 0 and arg_33_0:getCardAttrs(var_33_0).markId == arg_33_1.markId then
			return iter_33_0
		end
	end

	return false
end

function var_0_4.createMovePanel(arg_34_0, arg_34_1)
	if arg_34_0.movePanel then
		arg_34_0.movePanel:removeSelf()
	end

	local var_34_0 = csv.unit[arg_34_1.unit_id]
	local var_34_1 = arg_34_0.spriteItem:clone():addTo(arg_34_0:getResourceNode(), 1000)

	var_34_1:show()

	local var_34_2 = var_34_1:get("icon"):size()

	widget.addAnimationByKey(var_34_1:get("icon"), var_34_0.unitRes, "hero", "run_loop", 1000):scale(var_34_0.scale):alignCenter(var_34_2):setSkin(var_34_0.skin)
	widget.addAnimationByKey(var_34_1:get("icon"), "effect/buzhen.skel", "effect", "effect_loop", 1002):scale(1):alignCenter(var_34_2)

	arg_34_0.movePanel = var_34_1

	arg_34_0.draggingIndex:set(-1)

	return var_34_1
end

function var_0_4.refreshTeamBuff(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = {}
	local var_35_1 = csv.summer_challenge.cards

	for iter_35_0 = 1, var_0_0 do
		local var_35_2 = arg_35_1[iter_35_0]

		if var_35_2 and var_35_2 ~= 0 then
			local var_35_3 = var_35_1[var_35_2]
			local var_35_4 = csv.cards[var_35_3.cardID]
			local var_35_5 = csv.unit[var_35_4.unitID]

			var_35_0[iter_35_0] = {
				var_35_5.natureType,
				var_35_5.natureType2
			}
		end
	end

	local var_35_6 = dataEasy.getTeamBuffBest(var_35_0)

	arg_35_0["btnGHimg" .. arg_35_2]:texture(var_35_6.buf.imgPath)

	if arg_35_2 == 1 then
		arg_35_0.teamSelfBuff = var_35_6
	else
		arg_35_0.teamEnemyBuff = var_35_6
	end
end

function var_0_4.onTeamBuffClick(arg_36_0, arg_36_1)
	local var_36_0 = {
		arg_36_0.teamSelfBuff and arg_36_0.teamSelfBuff.buf.teamBuffs or {},
		arg_36_0.teamEnemyBuff and arg_36_0.teamEnemyBuff.buf.teamBuffs or {}
	}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_36_0[arg_36_1])
end

function var_0_4.sendRequeat(arg_37_0, arg_37_1)
	local var_37_0 = string.format("summerChallengeEmbattle%d", arg_37_0.gateID)

	userDefault.setForeverLocalKey(var_37_0, arg_37_0.clientBattleCards:read(), {
		new = true
	})
	arg_37_1()
end

function var_0_4.fightBtn(arg_38_0)
	local var_38_0 = false

	for iter_38_0, iter_38_1 in pairs(arg_38_0.clientBattleCards:read()) do
		if iter_38_1 ~= 0 then
			var_38_0 = true

			break
		end
	end

	if not var_38_0 then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	arg_38_0:sendRequeat(function()
		arg_38_0.fightCb(arg_38_0, arg_38_0.clientBattleCards)
	end)
end

function var_0_4.getCardAttrs(arg_40_0, arg_40_1)
	return arg_40_0.allCardDatas:atproxy(arg_40_1)
end

function var_0_4.onClose(arg_41_0)
	arg_41_0:sendRequeat(function()
		var_0_2.onClose(arg_41_0)
	end)
end

return var_0_4
