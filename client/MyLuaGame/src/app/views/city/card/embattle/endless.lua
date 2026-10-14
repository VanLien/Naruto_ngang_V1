local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("CardEmbattleEndLessView", var_0_0)

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
					size = 1,
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
					size = 1,
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
					size = 1,
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
					size = 1,
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
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_1.initParams(arg_1_0, arg_1_1)
	var_0_0.initParams(arg_1_0, arg_1_1)

	arg_1_0.limitInfo = arg_1_1.limitInfo or {}
end

function var_0_1.limtFunc(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9, arg_2_10)
	local var_2_0, var_2_1 = csvNext(arg_2_0.limitInfo)
	local var_2_2 = itertools.map(var_2_1 or {}, function(arg_3_0, arg_3_1)
		return arg_3_1, 1
	end)
	local var_2_3 = csv.cards[arg_2_2]
	local var_2_4 = csv.unit[var_2_3.unitID]

	if not var_2_0 or var_2_0 > 2 and var_2_0 < 7 or var_2_0 == 1 and (var_2_2[var_2_4.natureType] or var_2_2[var_2_4.natureType2]) or var_2_0 == 2 and not var_2_2[var_2_4.natureType] and not var_2_2[var_2_4.natureType2] then
		return var_0_0.limtFunc(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9, arg_2_10)
	else
		return nil
	end
end

return var_0_1
