local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.embattle.base")
local var_0_2 = class("FakeCardEmbattleView", var_0_1)
local var_0_3 = {
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
local var_0_4 = {
	2,
	4,
	6,
	1,
	3,
	5
}
local var_0_5 = {
	[game.EMBATTLE_FROM_TABLE.default] = {
		initModelFunc = function(arg_1_0)
			return idlertable.new({})
		end,
		getSendRequest = function(arg_2_0)
			if arg_2_0.clientBattleCards:size() == 0 then
				return
			end
		end
	},
	[game.EMBATTLE_FROM_TABLE.mimicry] = {
		initModelFunc = function(arg_3_0)
			local var_3_0 = gGameModel.mimicry:read("battle_cards")[arg_3_0.bossID]

			return idlertable.new(var_3_0 or {})
		end
	}
}

local function var_0_6(arg_4_0, arg_4_1, ...)
	local var_4_0 = var_0_5[arg_4_0.from]
	local var_4_1 = var_0_5[game.EMBATTLE_FROM_TABLE.default]

	return (var_4_0[arg_4_1] or var_4_1[arg_4_1])(arg_4_0, ...)
end

var_0_2.RESOURCE_FILENAME = "card_embattle.json"
var_0_2.RESOURCE_BINDING = {
	fightNote = "fightNote",
	bottomMask = "bottomMask",
	btnJump = "btnJump",
	dailyGateTipsPos = "dailyGateTipsPos",
	rightDown = "rightDown",
	bottomPanel = "bottomPanel",
	textLimit = "textLimit",
	battlePanel = "battlePanel",
	textNotRole = "emptyTxt",
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
	btnChallenge = {
		varname = "btnChallenge",
		binds = {
			event = "touch",
			clicksafe = true,
			methods = {
				ended = bindHelper.self("fightBtn")
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
	["btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
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
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
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
	}
}

function var_0_2.onCreate(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}

	arg_5_0.spriteItem:get("attrBg"):hide()
	arg_5_0:initDefine()
	arg_5_0.btnJump:z(5)
	gGameUI.topuiManager:createView("title", arg_5_0, {
		onClose = arg_5_0:createHandler("onClose", true)
	}):init({
		subTitle = "FORMATION",
		title = arg_5_1.readyIdx and "common/txt/img_bz_duiwuyushe.png" or "common/txt/txt_bt_buzhen.png"
	})
	arg_5_0:initParams(arg_5_1)
	arg_5_0:initModel(arg_5_1)
	arg_5_0:checkTeamBuffOpen()
	arg_5_0:initHeroSprite()
	arg_5_0:initBottomList()
	arg_5_0:initRoundUIPanel()

	if arg_5_0.startCb then
		local var_5_0 = arg_5_0.startCb(arg_5_0)

		if var_5_0 then
			arg_5_0.clientBattleCards:set(var_5_0)
		end
	end
end

function var_0_2.initBottomList(arg_6_0)
	arg_6_0.cardListView = gGameUI:createView("city.adventure.mimicry.fake_card_list", arg_6_0.bottomPanel):init({
		base = arg_6_0,
		clientBattleCards = arg_6_0.clientBattleCards,
		battleCardsData = arg_6_0.battleCardsData,
		deleteMovingItem = arg_6_0.deleteMovingItem,
		createMovePanel = arg_6_0.createMovePanel,
		moveMovePanel = arg_6_0.moveMovePanel,
		isMovePanelExist = arg_6_0.isMovePanelExist,
		onCardClick = arg_6_0.onCardClick,
		allCardDatas = arg_6_0.allCardDatas,
		moveEndMovePanel = arg_6_0.moveEndMovePanel,
		limtFunc = arg_6_0.limtFunc
	}, true)
end

function var_0_2.getCardAttr(arg_7_0, arg_7_1, arg_7_2)
	return arg_7_0.allCardDatas:atproxy(arg_7_1)[arg_7_2]
end

function var_0_2.initModel(arg_8_0)
	arg_8_0.cards = gGameModel.role:getIdler("cards")
	arg_8_0.allCardDatas = idlers.new({})
	arg_8_0.battleCardsData = var_0_6(arg_8_0, "initModelFunc")
	arg_8_0.clientBattleCards = idlertable.new({})
	arg_8_0.fightSumNum = idler.new(0)
	arg_8_0.battleNum = idler.new("")
	arg_8_0.selectIndex = idler.new()
	arg_8_0.draggingIndex = idler.new(0)
end

function var_0_2.initRoundUIPanel(arg_9_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_9_0.fightNote,
			"pos",
			"right"
		},
		{
			arg_9_0.btnChallenge,
			"pos",
			"right"
		},
		{
			arg_9_0.rightDown,
			"pos",
			"right"
		}
	})

	local var_9_0 = arg_9_0.fightCb and true or false

	arg_9_0.fightNote:hide()
	arg_9_0.btnJump:hide()
	arg_9_0.rightDown:visible(not var_9_0)
	arg_9_0.btnChallenge:visible(var_9_0)
end

function var_0_2.getKey(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return nil
	end

	return arg_10_1.unit_id
end

function var_0_2.getCardAttrs(arg_11_0, arg_11_1)
	return arg_11_0.allCardDatas:atproxy(arg_11_1)
end

function var_0_2.fightBtn(arg_12_0)
	local var_12_0 = arg_12_0.clientBattleCards:read()

	if not next(var_12_0) then
		gGameUI:showTip(gLanguageCsv.noSpriteAvailable)

		return
	end

	local var_12_1 = {}

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		var_12_1[iter_12_0] = arg_12_0.getCardAttrs(arg_12_0, iter_12_1)
	end

	arg_12_0.fightCb(arg_12_0, var_12_1)
end

function var_0_2.onClose(arg_13_0)
	var_0_0.onClose(arg_13_0)
end

function var_0_2.limtFunc(arg_14_0, arg_14_1)
	local var_14_0 = csv.cards[arg_14_1.card_id]
	local var_14_1 = csv.unit[arg_14_1.unit_id]

	return {
		getTime = 0,
		fighting_point = 0,
		card_id = arg_14_1.card_id,
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

return var_0_2
