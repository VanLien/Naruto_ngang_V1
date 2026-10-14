local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("CardEmbattleArenaView", var_0_0)

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
	useDefaultBattle = {
		varname = "useDefaultBattle",
		binds = {
			event = "click",
			method = bindHelper.self("onUseDefaultBattle")
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

function var_0_1.initRoundUIPanel(arg_1_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_1_0.fightNote,
			"pos",
			"right"
		},
		{
			arg_1_0.btnChallenge,
			"pos",
			"right"
		},
		{
			arg_1_0.btnJump,
			"pos",
			"right"
		},
		{
			arg_1_0.rightDown,
			"pos",
			"right"
		}
	})

	local var_1_0 = arg_1_0.fightCb and true or false

	arg_1_0.rightDown:visible(not var_1_0)
	arg_1_0.btnChallenge:visible(var_1_0)
	arg_1_0.btnJump:visible(false)
	arg_1_0.useDefaultBattle:visible(not var_1_0)
	arg_1_0:initDeployment()
end

function var_0_1.onUseDefaultBattle(arg_2_0)
	local var_2_0 = not arg_2_0.deploymentFlag:read()
	local var_2_1 = arg_2_0.fightCb and "arena_cards" or "arena_defence_cards"

	gGameApp:requestServer("/game/deployment/sync", function()
		if var_2_0 then
			arg_2_0.battleCardsData:notify()
		end

		arg_2_0:setDeploymentFlag()
	end, var_2_1, var_2_0)
end

function var_0_1.setDeploymentFlag(arg_4_0)
	local var_4_0 = arg_4_0.fightCb and "arena_cards" or "arena_defence_cards"
	local var_4_1 = gGameModel.role:read("deployments_sync")

	arg_4_0.deploymentFlag:set(var_4_1[var_4_0] or false)
end

function var_0_1.initDeployment(arg_5_0)
	arg_5_0.deploymentFlag = idler.new(false)

	idlereasy.when(arg_5_0.deploymentFlag, function(arg_6_0, arg_6_1)
		arg_5_0.useDefaultBattle:get("checkBox"):setSelectedState(arg_6_1)
	end)
	idlereasy.when(arg_5_0.clientBattleCards, function(arg_7_0, arg_7_1)
		arg_5_0.deploymentFlag:set(false)
	end, true)
	arg_5_0:setDeploymentFlag()
end

function var_0_1.oneKeyEmbattleBtn(arg_8_0)
	var_0_0.oneKeyEmbattleBtn(arg_8_0)
	arg_8_0.deploymentFlag:set(false)
end

return var_0_1
