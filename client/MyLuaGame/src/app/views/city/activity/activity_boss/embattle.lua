local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.embattle.base")
local var_0_2 = class("CardEmbattleActivityBossView", var_0_1)

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
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
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
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
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
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
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
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
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
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_2.onClose(arg_1_0, arg_1_1)
	if arg_1_1 == true then
		if arg_1_0.from == game.EMBATTLE_FROM_TABLE.huodongBoss then
			local var_1_0 = arg_1_0.clientBattleCards:read()
			local var_1_1 = {}

			for iter_1_0, iter_1_1 in pairs(var_1_0) do
				var_1_1[iter_1_0] = stringz.bintohex(iter_1_1)
			end

			userDefault.setForeverLocalKey("huodongboss_emabttle", var_1_1, {
				new = true
			})
			var_0_0.onClose(arg_1_0)
		else
			var_0_0.onClose(arg_1_0)
		end
	elseif arg_1_0.from == game.EMBATTLE_FROM_TABLE.huodongBoss then
		local var_1_2 = arg_1_0.clientBattleCards:read()
		local var_1_3 = {}

		for iter_1_2, iter_1_3 in pairs(var_1_2) do
			var_1_3[iter_1_2] = stringz.bintohex(iter_1_3)
		end

		userDefault.setForeverLocalKey("huodongboss_emabttle", var_1_3, {
			new = true
		})
		var_0_0.onClose(arg_1_0)
	else
		var_0_0.onClose(arg_1_0)
	end
end

return var_0_2
