local var_0_0 = require("app.views.city.adventure.random_tower.tools")
local var_0_1 = require("app.views.city.card.embattle.base")
local var_0_2 = class("CardEmbattleRandomView", var_0_1)

var_0_2.RESOURCE_FILENAME = "card_embattle.json"
var_0_2.RESOURCE_BINDING = {
	fightNote = "fightNote",
	dailyGateTipsPos = "dailyGateTipsPos",
	textNotRole = "emptyTxt",
	bottomMask = "bottomMask",
	bottomPanel = "bottomPanel",
	textLimit = "textLimit",
	battlePanel = "battlePanel",
	rightDown = "rightDown",
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
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_2.getFightSumNum(arg_1_0, arg_1_1)
	local var_1_0 = 0
	local var_1_1 = var_0_0.calcFightingPointFunc()

	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		local var_1_2 = arg_1_0:getCardAttr(iter_1_1, "fighting_point")

		var_1_0 = var_1_0 + var_1_1(iter_1_1)
	end

	return var_1_0
end

function var_0_2.getCardStates(arg_2_0)
	return gGameModel.random_tower:read("card_states") or {}
end

function var_0_2.initBottomList(arg_3_0)
	arg_3_0.cardListView = gGameUI:createView("city.card.embattle.random_card_list", arg_3_0.bottomPanel):init({
		base = arg_3_0,
		clientBattleCards = arg_3_0.clientBattleCards,
		battleCardsData = arg_3_0.battleCardsData,
		selectIndex = arg_3_0.selectIndex,
		deleteMovingItem = arg_3_0.deleteMovingItem,
		createMovePanel = arg_3_0.createMovePanel,
		moveMovePanel = arg_3_0.moveMovePanel,
		isMovePanelExist = arg_3_0.isMovePanelExist,
		onCardClick = arg_3_0.onCardClick,
		allCardDatas = arg_3_0.allCardDatas,
		moveEndMovePanel = arg_3_0.moveEndMovePanel,
		limtFunc = arg_3_0.limtFunc
	}, true)

	arg_3_0:resetBtnPos()
end

function var_0_2.initParams(arg_4_0, arg_4_1)
	var_0_1.initParams(arg_4_0, arg_4_1)
end

function var_0_2.limtFunc(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	if arg_5_5 < 10 then
		return nil
	end

	local var_5_0 = var_0_1.limtFunc(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)

	var_5_0.states = arg_5_0:getCardStates()[arg_5_1] or {
		1,
		0
	}

	return var_5_0
end

function var_0_2.embattleBtnFunc(arg_6_0, arg_6_1, arg_6_2)
	if not var_0_1.embattleBtnFunc(arg_6_0, arg_6_1, arg_6_2) then
		return false
	end

	return (arg_6_0:getCardStates()[arg_6_2.dbid] or {
		1,
		1
	})[1] > 0
end

return var_0_2
