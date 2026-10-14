local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = 6
local var_0_2 = 6
local var_0_3 = {
	2,
	4,
	6,
	1,
	3,
	5
}
local var_0_4 = {
	mine = 1,
	enemy = 2
}
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = require("app.views.city.card.embattle.base")
local var_0_7 = class("BraveChallengleEmbattle", var_0_6)

var_0_7.RESOURCE_FILENAME = "activity_brave_challenge_embattle.json"
var_0_7.RESOURCE_BINDING = {
	["rightDown.textNum"] = "textNum",
	bottomPanel = "bottomPanel",
	battlePanel1 = "leftPanel",
	battlePanel2 = "rightPanel",
	["rightDown.textNote"] = "textNote",
	rightDown = "rightDown",
	["panelTop.panelSelf"] = "panelSelfBadge",
	spritePanel = "spriteItem",
	["panelTop.panelOpp"] = "panelOppBadge",
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
	["panelTop.panelSelf.txt02"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(63, 178, 239, 255)
				}
			}
		}
	},
	["panelTop.panelOpp.txt02"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(246, 82, 102, 255)
				}
			}
		}
	}
}

function var_0_7.onCreate(arg_1_0, arg_1_1)
	gGameUI.topuiManager:createView("title", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose", true)
	}):init({
		subTitle = "FORMATION",
		title = gLanguageCsv.formation
	})
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_1_0.rightDown,
			"pos",
			"right"
		}
	})
	arg_1_0:initModel()

	arg_1_0.fightCb = arg_1_1.fightCb
	arg_1_0.newCards = arg_1_1.newCards
	arg_1_0.emenyDatas = {}
	arg_1_0.heroSprite = {}
	arg_1_0.emenySprite = {}
	arg_1_0.teamSelfBuff = {}
	arg_1_0.teamEnemyBuff = {}
	arg_1_0.panel = {
		{
			parent = arg_1_0.leftPanel,
			list = arg_1_0.heroSprite
		},
		{
			parent = arg_1_0.rightPanel,
			list = arg_1_0.emenySprite
		}
	}

	arg_1_0:updateData()
	arg_1_0:initSpriteItem()
	arg_1_0:initEnemyUI()
	arg_1_0:initSelfBadge(arg_1_0.panelSelfBadge, arg_1_0.badges:read())
	arg_1_0:initBottomList()
	arg_1_0:refreshTeamBuff(arg_1_0.emenyDatas, 2)
	idlereasy.when(arg_1_0.clientBattleCards, function(arg_2_0, arg_2_1)
		arg_1_0:refreshTeamBuff(arg_2_1, 1)
		arg_1_0:showBattleNum(arg_2_1)

		for iter_2_0 = 1, var_0_1 do
			arg_1_0:initHeroSprite(iter_2_0)
		end
	end)
end

function var_0_7.initModel(arg_3_0)
	arg_3_0.game = gGameModel.brave_challenge:getIdler("game")
	arg_3_0.id = gGameModel.brave_challenge:getIdler("yyID")
	arg_3_0.badges = gGameModel.brave_challenge:getIdler("badges")
	arg_3_0.clientBattleCards = idlertable.new({})
	arg_3_0.battleCardsData = idlertable.new({})
	arg_3_0.allCardDatas = idlers.newWithMap({})
	arg_3_0.selectIndex = idler.new(0)
	arg_3_0.draggingIndex = idler.new(0)
end

function var_0_7.initBadge(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = csv.brave_challenge.badge
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(arg_4_2) do
		local var_4_2 = var_4_0[iter_4_1]

		if var_4_2 then
			if var_4_1[var_4_2.rarity] == nil then
				var_4_1[var_4_2.rarity] = 1
			else
				var_4_1[var_4_2.rarity] = var_4_1[var_4_2.rarity] + 1
			end
		end
	end

	local var_4_3 = arg_4_1:multiget("txtRate", "txtCommon", "btnSelfBadges")

	var_4_3.txtCommon:text(var_4_1[1] or 0)
	var_4_3.txtRate:text(var_4_1[2] or 0)
	arg_4_1:onClick(functools.partial(arg_4_0.onClickBadges, arg_4_0, arg_4_2, arg_4_3))
end

function var_0_7.initSelfBadge(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in pairs(arg_5_2) do
		for iter_5_2, iter_5_3 in pairs(iter_5_1) do
			table.insert(var_5_0, iter_5_3)
		end
	end

	arg_5_0:initBadge(arg_5_1, var_5_0, var_0_4.mine)
end

function var_0_7.updateData(arg_6_0)
	local var_6_0 = arg_6_0.game:read()
	local var_6_1 = var_6_0.cards
	local var_6_2 = var_6_0.deployments
	local var_6_3 = {}
	local var_6_4 = {}
	local var_6_5 = {}

	for iter_6_0, iter_6_1 in ipairs(var_6_2) do
		if iter_6_1 > 0 then
			var_6_3[iter_6_1] = true
		end

		var_6_4[iter_6_0] = iter_6_1
		var_6_5[iter_6_0] = iter_6_1
	end

	arg_6_0.clientBattleCards:set(var_6_5)
	arg_6_0.battleCardsData:set(var_6_4)

	local var_6_6 = {}
	local var_6_7 = csv.brave_challenge.cards

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		local var_6_8 = var_6_7[iter_6_2]
		local var_6_9 = csv.cards[var_6_8.cardID]
		local var_6_10 = csv.unit[var_6_9.unitID]

		var_6_6[iter_6_2] = {
			csvID = iter_6_2,
			card_id = var_6_8.cardID,
			unit_id = var_6_9.unitID,
			level = var_6_8.level,
			star = var_6_8.star,
			advance = var_6_8.advance,
			rarity = var_6_10.rarity,
			attr1 = var_6_10.natureType,
			attr2 = var_6_10.natureType2,
			markId = var_6_9.cardMarkID,
			states = iter_6_3,
			battle = var_6_3[iter_6_2] and 1 or 0,
			isNew = arg_6_0.newCards[iter_6_2] or false
		}
	end

	arg_6_0.allCardDatas:update(var_6_6)
end

function var_0_7.showBattleNum(arg_7_0, arg_7_1)
	local var_7_0 = 0

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		if iter_7_1 ~= 0 then
			var_7_0 = var_7_0 + 1
		end
	end

	arg_7_0.textNum:text(string.format("%d/%d", var_7_0, var_0_1))
	adapt.oneLineCenterPos(cc.p(163, 152), {
		arg_7_0.textNote,
		arg_7_0.textNum
	}, cc.p(5, 0))
end

function var_0_7.initSpriteItem(arg_8_0)
	for iter_8_0 = 1, 2 do
		local var_8_0 = arg_8_0.panel[iter_8_0].parent
		local var_8_1 = arg_8_0.panel[iter_8_0].list

		for iter_8_1 = 1, var_0_1 do
			local var_8_2 = var_8_0:get("item" .. iter_8_1)
			local var_8_3 = var_8_2:box()
			local var_8_4 = var_8_2:getParent():convertToWorldSpace(cc.p(var_8_3.x, var_8_3.y))

			var_8_3.x, var_8_3.y = var_8_4.x, var_8_4.y
			var_8_1[iter_8_1] = {
				item = var_8_2,
				rect = var_8_3,
				idx = iter_8_1
			}

			if iter_8_0 == 1 then
				var_8_2:onTouch(functools.partial(arg_8_0.onBattleCardTouch, arg_8_0, iter_8_1))
			end
		end
	end

	for iter_8_2 = 1, var_0_1 do
		local var_8_5 = arg_8_0.heroSprite[iter_8_2].item:get("imgBg")
		local var_8_6 = var_8_5:get("imgSel")
		local var_8_7 = var_8_5:size()
		local var_8_8

		var_8_8 = var_8_6 or widget.addAnimationByKey(var_8_5, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_8_7.width / 2, var_8_7.height / 2 + 15)
	end

	idlereasy.when(arg_8_0.selectIndex, function(arg_9_0, arg_9_1)
		for iter_9_0 = 1, var_0_1 do
			arg_8_0.heroSprite[iter_9_0].item:get("imgBg.imgSel"):visible(arg_9_1 == iter_9_0)
		end
	end)
	idlereasy.when(arg_8_0.draggingIndex, function(arg_10_0, arg_10_1)
		for iter_10_0 = 1, var_0_1 do
			local var_10_0 = arg_8_0.heroSprite[iter_10_0].item:get("sprite")

			if var_10_0 then
				var_10_0:setCascadeOpacityEnabled(true)

				if arg_10_1 == 0 then
					var_10_0:opacity(255)
				elseif arg_10_1 == -1 then
					var_10_0:opacity(155)
				elseif arg_10_1 == iter_10_0 then
					var_10_0:opacity(255)
				else
					var_10_0:opacity(155)
				end
			end
		end
	end)
end

function var_0_7.initEnemyUI(arg_11_0)
	local var_11_0 = arg_11_0.game:read()
	local var_11_1 = var_11_0.monsters
	local var_11_2 = var_11_0.monsterID
	local var_11_3 = csv.brave_challenge.monster[var_11_2]
	local var_11_4 = csv.brave_challenge.cards

	arg_11_0:initBadge(arg_11_0.panelOppBadge, var_11_3.badges, var_0_4.enemy)

	arg_11_0.emenyDatas = {}

	for iter_11_0, iter_11_1 in csvPairs(var_11_3.cards) do
		if var_11_1[iter_11_0] and var_11_1[iter_11_0][1] ~= 0 then
			arg_11_0.emenyDatas[iter_11_0] = iter_11_1
		end
	end

	for iter_11_2 = 1, var_0_1 do
		local var_11_5 = arg_11_0.emenyDatas[iter_11_2]
		local var_11_6 = arg_11_0.emenySprite[iter_11_2]
		local var_11_7 = var_11_4[var_11_5]

		if var_11_7 then
			local var_11_8 = csv.cards[var_11_7.cardID].unitID
			local var_11_9 = csv.unit[var_11_8]
			local var_11_10 = var_11_6.item:get("imgBg")

			widget.addAnimationByKey(var_11_6.item, var_11_9.unitRes, "sprite", "standby_loop", 4):scale(-var_11_9.scale * 0.8, var_11_9.scale * 0.8):xy(var_11_10:x(), var_11_10:y() + 15):setSkin(var_11_9.skin)

			local var_11_11 = (arg_11_0.teamEnemyBuff and arg_11_0.teamEnemyBuff.flags or {
				1,
				1,
				1,
				1,
				1,
				1
			})[iter_11_2]

			uiEasy.setTeamBuffItem(var_11_6.item, var_11_7.cardID, var_11_11)
		else
			var_11_6.item:get("attrBg"):hide()
		end
	end
end

function var_0_7.initHeroSprite(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.heroSprite[arg_12_1].item
	local var_12_1 = arg_12_0:getCardAttrs(arg_12_0.clientBattleCards:read()[arg_12_1])

	if not var_12_1 then
		if var_12_0:getChildByName("sprite") then
			var_12_0:getChildByName("sprite"):hide()
		end

		var_12_0:get("attrBg"):hide()

		return
	end

	local var_12_2 = csv.unit[var_12_1.unit_id]
	local var_12_3 = var_12_0:get("imgBg")

	if var_12_0.csvID == var_12_1.csvID and var_12_0:getChildByName("sprite") then
		var_12_0:getChildByName("sprite"):show()
	else
		var_12_0:removeChildByName("sprite")
		widget.addAnimationByKey(var_12_0, var_12_2.unitRes, "sprite", "standby_loop", 4):scale(var_12_2.scale * (0.8 + (arg_12_1 - 1) % 3 * 0.1)):xy(var_12_3:x(), var_12_3:y() + 15):setSkin(var_12_2.skin)

		var_12_0.csvID = var_12_1.csvID
	end

	local var_12_4 = var_12_1.card_id
	local var_12_5 = (arg_12_0.teamSelfBuff and arg_12_0.teamSelfBuff.flags or {
		1,
		1,
		1,
		1,
		1,
		1
	})[arg_12_1]

	uiEasy.setTeamBuffItem(var_12_0, var_12_1.card_id, var_12_5)
end

function var_0_7.onBattleCardTouch(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0.clientBattleCards:read()[arg_13_1] == 0 then
		return
	end

	local var_13_0 = arg_13_0:getCardAttrs(arg_13_0.clientBattleCards:read()[arg_13_1])

	if arg_13_2.name == "began" then
		arg_13_0:deleteMovingItem()
		arg_13_0:createMovePanel(var_13_0)

		local var_13_1 = arg_13_0.heroSprite[arg_13_1].item

		var_13_1:get("sprite"):hide()
		var_13_1:get("attrBg"):hide()
		arg_13_0:moveMovePanel(arg_13_2)
	elseif arg_13_2.name == "moved" then
		arg_13_0:moveMovePanel(arg_13_2)
	elseif arg_13_2.name == "ended" or arg_13_2.name == "cancelled" then
		local var_13_2 = arg_13_0.heroSprite[arg_13_1].item

		var_13_2:get("sprite"):show()
		var_13_2:get("attrBg"):show()
		arg_13_0:deleteMovingItem()

		if arg_13_2.y < 340 then
			arg_13_0:onCardClick(var_13_0, true)
		else
			local var_13_3 = arg_13_0:whichEmbattleTargetPos(arg_13_2)

			if var_13_3 then
				if var_13_3 ~= arg_13_1 then
					arg_13_0:onCardMove(var_13_0, var_13_3, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_13_0:onCardMove(var_13_0, var_13_3, false)
				end
			else
				arg_13_0:onCardMove(var_13_0, arg_13_1, false)
			end
		end
	end
end

function var_0_7.initBottomList(arg_14_0)
	arg_14_0.cardListView = gGameUI:createView("city.card.embattle.brave_challenge_card_list", arg_14_0.bottomPanel):init({
		base = arg_14_0,
		clientBattleCards = arg_14_0.clientBattleCards,
		battleCardsData = arg_14_0.battleCardsData,
		selectIndex = arg_14_0.selectIndex,
		deleteMovingItem = arg_14_0.deleteMovingItem,
		createMovePanel = arg_14_0.createMovePanel,
		moveMovePanel = arg_14_0.moveMovePanel,
		isMovePanelExist = arg_14_0.isMovePanelExist,
		onCardClick = arg_14_0.onCardClick,
		allCardDatas = arg_14_0.allCardDatas,
		moveEndMovePanel = arg_14_0.moveEndMovePanel,
		limtFunc = arg_14_0.limtFunc
	}, true)
end

function var_0_7.canBattleDown(arg_15_0)
	return arg_15_0.clientBattleCards:size() > 1
end

function var_0_7.canBattleUp(arg_16_0)
	local var_16_0 = 0

	for iter_16_0, iter_16_1 in arg_16_0.clientBattleCards:pairs() do
		if iter_16_1 > 0 then
			var_16_0 = var_16_0 + 1
		end
	end

	return var_16_0 < var_0_1
end

function var_0_7.whichEmbattleTargetPos(arg_17_0, arg_17_1)
	for iter_17_0 = var_0_1, 1, -1 do
		local var_17_0 = arg_17_0.heroSprite[iter_17_0].rect

		if cc.rectContainsPoint(var_17_0, arg_17_1) then
			return iter_17_0
		end
	end
end

function var_0_7.deleteMovingItem(arg_18_0)
	arg_18_0.selectIndex:set(0)

	if arg_18_0.movePanel then
		arg_18_0.movePanel:removeSelf()

		arg_18_0.movePanel = nil
	end

	arg_18_0.draggingIndex:set(0)
end

function var_0_7.moveMovePanel(arg_19_0, arg_19_1)
	if arg_19_0.movePanel then
		arg_19_0.movePanel:xy(arg_19_1)
		arg_19_0.selectIndex:set(arg_19_0:whichEmbattleTargetPos(arg_19_1))
	end
end

function var_0_7.moveEndMovePanel(arg_20_0, arg_20_1)
	if not arg_20_0.movePanel then
		return
	end

	local var_20_0 = arg_20_0.selectIndex:read()

	arg_20_0:onCardMove(arg_20_1, var_20_0, true)
	arg_20_0:deleteMovingItem()
end

function var_0_7.isMovePanelExist(arg_21_0)
	return arg_21_0.movePanel ~= nil
end

function var_0_7.getIdxByDbId(arg_22_0, arg_22_1)
	for iter_22_0 = 1, var_0_1 do
		if (arg_22_0.clientBattleCards:read()[iter_22_0] or 0) == arg_22_1 then
			return iter_22_0
		end
	end
end

function var_0_7.onCardMove(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0
	local var_23_1 = arg_23_1.csvID
	local var_23_2 = arg_23_0:getIdxByDbId(var_23_1)
	local var_23_3 = arg_23_0.clientBattleCards:read()[arg_23_2]
	local var_23_4 = arg_23_0:getCardAttrs(var_23_3)
	local var_23_5

	var_23_5 = var_23_2 == nil and 0 or 1

	if arg_23_2 then
		if arg_23_1.battle > 0 then
			arg_23_0.clientBattleCards:modify(function(arg_24_0)
				arg_24_0[var_23_2], arg_24_0[arg_23_2] = arg_24_0[arg_23_2], arg_24_0[var_23_2]

				return true, arg_24_0
			end, true)
		else
			local var_23_6 = arg_23_0:hasSameMarkIDCard(arg_23_1)

			if var_23_6 and var_23_6 ~= arg_23_2 then
				var_23_0 = gLanguageCsv.alreadyHaveSameSprite
			elseif not var_23_3 and not arg_23_0:canBattleUp() then
				var_23_0 = gLanguageCsv.battleCardCountEnough
			else
				arg_23_0:upBattle(var_23_1, arg_23_2)

				var_23_0 = gLanguageCsv.addToEmbattle
			end
		end
	end

	if arg_23_3 and var_23_0 then
		gGameUI:showTip(var_23_0)
	end
end

function var_0_7.onCardClick(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0
	local var_25_1 = arg_25_1.csvID
	local var_25_2 = arg_25_0:getIdxByDbId(var_25_1)

	if arg_25_1.battle > 0 then
		if arg_25_0:canBattleDown() then
			arg_25_0:downBattle(var_25_1, true)
		else
			var_25_0 = gLanguageCsv.battleCannotEmpty
		end
	else
		local var_25_3 = arg_25_0:getIdxByDbId(0)

		if not arg_25_0:canBattleUp() then
			var_25_0 = gLanguageCsv.battleCardCountEnough
		elseif arg_25_0:hasSameMarkIDCard(arg_25_1) then
			var_25_0 = gLanguageCsv.alreadyHaveSameSprite
		else
			arg_25_0:upBattle(var_25_1, var_25_3)
		end
	end

	if arg_25_2 and var_25_0 then
		gGameUI:showTip(var_25_0)
	end
end

function var_0_7.downBattle(arg_26_0, arg_26_1)
	arg_26_0:getCardAttrs(arg_26_1).battle = 0

	local var_26_0 = arg_26_0:getIdxByDbId(arg_26_1)

	arg_26_0.clientBattleCards:modify(function(arg_27_0)
		arg_27_0[var_26_0] = 0

		return true, arg_27_0
	end, true)
end

function var_0_7.upBattle(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.clientBattleCards:read()[arg_28_2]

	if var_28_0 ~= 0 then
		arg_28_0:getCardAttrs(var_28_0).battle = 0
	end

	arg_28_0.clientBattleCards:modify(function(arg_29_0)
		arg_29_0[arg_28_2] = arg_28_1
		arg_28_0:getCardAttrs(arg_28_1).battle = 1
		arg_28_0:getCardAttrs(arg_28_1).isNew = false

		return true, arg_29_0
	end, true)
end

function var_0_7.hasSameMarkIDCard(arg_30_0, arg_30_1)
	for iter_30_0 = 1, var_0_1 do
		local var_30_0 = arg_30_0.clientBattleCards:read()[iter_30_0]

		if var_30_0 ~= 0 and arg_30_0:getCardAttrs(var_30_0).markId == arg_30_1.markId then
			return iter_30_0
		end
	end

	return false
end

function var_0_7.createMovePanel(arg_31_0, arg_31_1)
	if arg_31_0.movePanel then
		arg_31_0.movePanel:removeSelf()
	end

	local var_31_0 = csv.unit[arg_31_1.unit_id]
	local var_31_1 = arg_31_0.spriteItem:clone():addTo(arg_31_0:getResourceNode(), 1000)

	var_31_1:show()

	local var_31_2 = var_31_1:get("icon"):size()

	widget.addAnimationByKey(var_31_1:get("icon"), var_31_0.unitRes, "hero", "run_loop", 1000):scale(var_31_0.scale):alignCenter(var_31_2):setSkin(var_31_0.skin)
	widget.addAnimationByKey(var_31_1:get("icon"), "effect/buzhen.skel", "effect", "effect_loop", 1002):scale(1):alignCenter(var_31_2)

	arg_31_0.movePanel = var_31_1

	arg_31_0.draggingIndex:set(-1)

	return var_31_1
end

function var_0_7.refreshTeamBuff(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = {}
	local var_32_1 = csv.brave_challenge.cards

	for iter_32_0 = 1, var_0_1 do
		local var_32_2 = arg_32_1[iter_32_0]

		if var_32_2 and var_32_2 ~= 0 then
			local var_32_3 = var_32_1[var_32_2]
			local var_32_4 = csv.cards[var_32_3.cardID]
			local var_32_5 = csv.unit[var_32_4.unitID]

			var_32_0[iter_32_0] = {
				var_32_5.natureType,
				var_32_5.natureType2
			}
		end
	end

	local var_32_6 = dataEasy.getTeamBuffBest(var_32_0)

	arg_32_0["btnGHimg" .. arg_32_2]:texture(var_32_6.buf.imgPath)

	if arg_32_2 == 1 then
		arg_32_0.teamSelfBuff = var_32_6
	else
		arg_32_0.teamEnemyBuff = var_32_6
	end
end

function var_0_7.onClickBadges(arg_33_0, arg_33_1, arg_33_2)
	gGameUI:stackUI("city.activity.brave_challenge.badge", nil, nil, arg_33_1, arg_33_2)
end

function var_0_7.onTeamBuffClick1(arg_34_0)
	local var_34_0 = arg_34_0.teamSelfBuff and arg_34_0.teamSelfBuff.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_34_0)
end

function var_0_7.onTeamBuffClick2(arg_35_0)
	local var_35_0 = arg_35_0.teamEnemyBuff and arg_35_0.teamEnemyBuff.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_35_0)
end

function var_0_7.sendRequeat(arg_36_0, arg_36_1, arg_36_2)
	if not itertools.equal(arg_36_0.battleCardsData:read(), arg_36_0.clientBattleCards:read()) then
		local var_36_0

		gGameApp:requestServerCustom(var_0_0.url("deploy")):params(arg_36_0.clientBattleCards:read(), arg_36_0.id:read()):onBeforeSync(arg_36_1):doit()
	else
		arg_36_1()
	end
end

function var_0_7.fightBtn(arg_37_0)
	local var_37_0 = false

	for iter_37_0, iter_37_1 in pairs(arg_37_0.clientBattleCards:read()) do
		if iter_37_1 ~= 0 then
			var_37_0 = true

			break
		end
	end

	if not var_37_0 then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	arg_37_0:sendRequeat(function()
		arg_37_0.fightCb(arg_37_0, arg_37_0.clientBattleCards)
	end)
end

function var_0_7.getCardAttrs(arg_39_0, arg_39_1)
	return arg_39_0.allCardDatas:atproxy(arg_39_1)
end

return var_0_7
