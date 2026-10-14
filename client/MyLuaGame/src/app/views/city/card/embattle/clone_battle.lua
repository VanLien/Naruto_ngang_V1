local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("CardEmbattleCloneView", var_0_0)

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

function var_0_1.onCreate(arg_1_0, arg_1_1)
	var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.fightNote:hide()
	arg_1_0.cardListView:hide()
	arg_1_0.rightDown:hide()
	arg_1_0.bottomMask:show()
end

function var_0_1.initRoundUIPanel(arg_2_0)
	arg_2_0.btnChallenge:visible(true)
	arg_2_0.rightDown:visible(false)
	arg_2_0.btnJump:visible(false)
end

function var_0_1.initParams(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	arg_3_0.sceneType = game.SCENE_TYPE.clone
	arg_3_0.fightCb = arg_3_1.fightCb
	arg_3_0.from = game.EMBATTLE_FROM_TABLE.input
	arg_3_0.inputCardAttrs = arg_3_1.inputCardAttrs
	arg_3_0.inputCards = arg_3_1.inputCards
	arg_3_0.checkBattleArr = arg_3_1.checkBattleArr or function()
		return true
	end
end

function var_0_1.showItemFightPoint(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_1:show()

	local var_5_0 = arg_5_0:getCardAttr(arg_5_3, "fighting_point")

	arg_5_1:get("text"):text(var_5_0)

	local var_5_1 = arg_5_1:get("text"):size()
	local var_5_2 = arg_5_2.everyPos.headPos.y

	arg_5_1:y(var_5_2 + 100)
end

function var_0_1.getCardAttr(arg_6_0, arg_6_1, arg_6_2)
	return arg_6_0.inputCardAttrs:read()[arg_6_1][arg_6_2]
end

function var_0_1.getCardAttrIdler(arg_7_0, arg_7_1, arg_7_2)
	return arg_7_0.inputCardAttrs:read()[arg_7_1][arg_7_2]
end

function var_0_1.onCardClick(arg_8_0, arg_8_1, arg_8_2)
	return
end

function var_0_1.resetBattleCardsCallBack(arg_9_0)
	return
end

function var_0_1.getCardAttrs(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.inputCardAttrs:read()[arg_10_1]

	if var_10_0 then
		local var_10_1 = dataEasy.getUnitId(var_10_0.card_id, var_10_0.skin_id)

		return {
			battle = 1,
			card_id = var_10_0.card_id,
			dbid = var_10_0.id,
			unit_id = var_10_1
		}
	end
end

return var_0_1
