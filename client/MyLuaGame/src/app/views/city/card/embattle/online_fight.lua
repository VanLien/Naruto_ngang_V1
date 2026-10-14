local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("CardEmbattleOnlineFightView", var_0_0)

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

function var_0_1.onCreate(arg_1_0, arg_1_1)
	var_0_0.onCreate(arg_1_0, arg_1_1)

	if arg_1_1.tip then
		gGameUI:showTip(gLanguageCsv.onlineFightTeamChange)
	end
end

function var_0_1.initRoundUIPanel(arg_2_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_2_0.fightNote,
			"pos",
			"right"
		},
		{
			arg_2_0.btnChallenge,
			"pos",
			"right"
		},
		{
			arg_2_0.btnJump,
			"pos",
			"right"
		},
		{
			arg_2_0.rightDown,
			"pos",
			"right"
		}
	})

	local var_2_0 = false

	arg_2_0.rightDown:visible(not var_2_0)
	arg_2_0.btnChallenge:visible(var_2_0)
	arg_2_0.btnJump:visible(false)
	arg_2_0.useDefaultBattle:visible(not var_2_0)
	arg_2_0:initDeployment()
end

function var_0_1.onUseDefaultBattle(arg_3_0)
	local var_3_0 = not arg_3_0.deploymentFlag:read()
	local var_3_1 = "cross_online_fight"

	gGameApp:requestServer("/game/deployment/sync", function()
		if var_3_0 then
			arg_3_0.battleCardsData:notify()
		end

		arg_3_0:setDeploymentFlag()
	end, var_3_1, var_3_0)
end

function var_0_1.setDeploymentFlag(arg_5_0)
	local var_5_0 = "cross_online_fight"
	local var_5_1 = gGameModel.role:read("deployments_sync")

	arg_5_0.deploymentFlag:set(var_5_1[var_5_0] or false)
end

function var_0_1.initDeployment(arg_6_0)
	arg_6_0.deploymentFlag = idler.new(false)

	idlereasy.when(arg_6_0.deploymentFlag, function(arg_7_0, arg_7_1)
		arg_6_0.useDefaultBattle:get("checkBox"):setSelectedState(arg_7_1)
	end)
	idlereasy.when(arg_6_0.clientBattleCards, function(arg_8_0, arg_8_1)
		local var_8_0 = false

		for iter_8_0, iter_8_1 in pairs(arg_8_1) do
			local var_8_1 = gGameModel.cards:find(iter_8_1)

			if arg_6_0:confirmBanCard(var_8_1:read("card_id")) then
				arg_8_1[iter_8_0] = nil
				var_8_0 = true
			end
		end

		if var_8_0 then
			gGameUI:showTip(gLanguageCsv.onlineFightUseMainTeam)
		end

		arg_6_0.deploymentFlag:set(false)
	end, true)
	arg_6_0:setDeploymentFlag()
end

function var_0_1.limtFunc(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10)
	if arg_9_0:confirmBanCard(arg_9_2) then
		return nil
	end

	return (var_0_0.limtFunc(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10))
end

function var_0_1.confirmBanCard(arg_10_0, arg_10_1)
	if gGameModel.cross_online_fight:read("round") == "closed" then
		return false
	end

	local var_10_0 = gGameModel.cross_online_fight:read("start_date")
	local var_10_1 = math.floor((time.getTime() - time.getNumTimestamp(var_10_0, 5, 0, 0)) / 60 / 60 / 24) + 1
	local var_10_2 = false
	local var_10_3 = {}

	for iter_10_0, iter_10_1 in csvPairs(csv.cross.online_fight.theme_open) do
		if iter_10_1.day == var_10_1 then
			var_10_3 = iter_10_1

			break
		end
	end

	if itertools.size(var_10_3.invalidMarkIDs or {}) == 0 and itertools.size(var_10_3.invalidMegaCardIDs or {}) == 0 then
		return false
	end

	for iter_10_2, iter_10_3 in ipairs(var_10_3.invalidMarkIDs) do
		if csv.cards[arg_10_1].cardMarkID == iter_10_3 then
			return true
		end
	end

	for iter_10_4, iter_10_5 in ipairs(var_10_3.invalidMegaCardIDs) do
		if arg_10_1 == iter_10_5 then
			return true
		end
	end

	return false
end

function var_0_1.oneKeyEmbattleBtn(arg_11_0)
	var_0_0.oneKeyEmbattleBtn(arg_11_0)
	arg_11_0.deploymentFlag:set(false)
end

return var_0_1
