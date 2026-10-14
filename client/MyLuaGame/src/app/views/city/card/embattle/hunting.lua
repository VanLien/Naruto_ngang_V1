local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("CardEmbattleHuntingView", var_0_0)

var_0_1.RESOURCE_FILENAME = "card_embattle.json"
var_0_1.RESOURCE_BINDING = {
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

function var_0_1.getCardStates(arg_1_0)
	return gGameModel.hunting:read("hunting_route")[arg_1_0.route].card_states or {}
end

function var_0_1.initBottomList(arg_2_0)
	arg_2_0.cardListView = gGameUI:createView("city.card.embattle.hunting_card_list", arg_2_0.bottomPanel):init({
		base = arg_2_0,
		clientBattleCards = arg_2_0.clientBattleCards,
		battleCardsData = arg_2_0.battleCardsData,
		selectIndex = arg_2_0.selectIndex,
		deleteMovingItem = arg_2_0.deleteMovingItem,
		createMovePanel = arg_2_0.createMovePanel,
		moveMovePanel = arg_2_0.moveMovePanel,
		isMovePanelExist = arg_2_0.isMovePanelExist,
		onCardClick = arg_2_0.onCardClick,
		allCardDatas = arg_2_0.allCardDatas,
		moveEndMovePanel = arg_2_0.moveEndMovePanel,
		limtFunc = arg_2_0.limtFunc
	}, true)
end

function var_0_1.initParams(arg_3_0, arg_3_1)
	var_0_0.initParams(arg_3_0, arg_3_1)
end

function var_0_1.limtFunc(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
	if arg_4_5 < 10 then
		return nil
	end

	local var_4_0 = var_0_0.limtFunc(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)

	var_4_0.states = arg_4_0:getCardStates()[arg_4_1] or {
		1,
		0
	}

	return var_4_0
end

function var_0_1.embattleBtnFunc(arg_5_0, arg_5_1, arg_5_2)
	if not var_0_0.embattleBtnFunc(arg_5_0, arg_5_1, arg_5_2) then
		return false
	end

	return (arg_5_0:getCardStates()[arg_5_2.dbid] or {
		1,
		1
	})[1] > 0
end

return var_0_1
