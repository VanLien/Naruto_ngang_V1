local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("BattlePauseView", var_0_0)

local function var_0_2(arg_1_0, arg_1_1)
	arg_1_1:scale(0.95)
end

local function var_0_3(arg_2_0, arg_2_1)
	arg_2_1:scale(1)
end

var_0_1.RESOURCE_FILENAME = "battle_pause.json"
var_0_1.RESOURCE_BINDING = {
	text2 = "text2",
	setBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSetBtnClick")
			}
		}
	},
	backBtn = {
		binds = {
			event = "touch",
			methods = {
				began = var_0_2,
				ended = bindHelper.self("onBackBtnClick"),
				cancelled = var_0_3
			}
		}
	},
	restartBtn = {
		binds = {
			event = "touch",
			methods = {
				began = var_0_2,
				ended = bindHelper.self("onRestartBtnClick"),
				cancelled = var_0_3
			}
		}
	},
	continueBtn = {
		binds = {
			event = "touch",
			methods = {
				began = var_0_2,
				ended = bindHelper.self("onClose"),
				cancelled = var_0_3
			}
		}
	},
	["setBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["backBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["restartBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["continueBtn.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	}
}

local var_0_4 = {
	setBtn = "battleSet",
	backBtn = "battleBack",
	restartBtn = "battleRestart",
	continueBtn = "battleContinue"
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	display.director:pause()
	arg_3_0.text2:ignoreContentAdaptWithSize(false)
	arg_3_0.text2:setContentSize(cc.size(410, 200))
	arg_3_0.text2:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	arg_3_0.text2:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	arg_3_0.text2:getVirtualRenderer():setLineSpacing(-8)

	arg_3_0.battleView = arg_3_1

	local var_3_0 = arg_3_0:getResourceNode()

	for iter_3_0, iter_3_1 in pairs(var_0_4) do
		local var_3_1 = var_3_0:get(iter_3_0 .. ".text")

		var_3_1:setString(gLanguageCsv[iter_3_1])
		text.addEffect(var_3_1, {
			outline = {
				size = 4,
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		})
	end

	var_3_0:get("setBtn"):setVisible(false)

	if not battle.PauseNoShowStarConditionsGateType[arg_3_1.gateType] then
		local var_3_2 = arg_3_0.battleView:getPlayModel():getStarConditions()

		if not var_3_2 then
			return
		end

		arg_3_0.conditionTb = var_3_2

		for iter_3_2 = 1, 3 do
			local var_3_3 = var_3_2[iter_3_2][1]
			local var_3_4 = var_3_2[iter_3_2][2]
			local var_3_5 = var_3_0:get("text" .. iter_3_2)

			var_3_5:setString(string.format(gLanguageCsv["starCondition" .. var_3_3], var_3_4))
			text.addEffect(var_3_5, {
				color = ui.COLORS.NORMAL.LIGHT_GREEN
			})

			local var_3_6 = var_3_0:get("count" .. iter_3_2)

			var_3_6:setString(string.format("(%s/%s)", 0, var_3_4))
			text.addEffect(var_3_6, {
				color = ui.COLORS.NORMAL.LIGHT_GREEN
			})
		end
	else
		for iter_3_3 = 1, 3 do
			var_3_0:get("text" .. iter_3_3):hide()
			var_3_0:get("count" .. iter_3_3):hide()
			var_3_0:get("star" .. iter_3_3):hide()
		end
	end

	arg_3_0:showPanel()
end

function var_0_1.showPanel(arg_4_0)
	if not arg_4_0.conditionTb then
		return
	end

	local var_4_0 = arg_4_0:getResourceNode()
	local var_4_1, var_4_2 = arg_4_0.battleView:getPlayModel():getGateStar()

	for iter_4_0 = 1, 3 do
		local var_4_3 = var_4_2[iter_4_0][1]
		local var_4_4 = var_4_2[iter_4_0][2] or 0
		local var_4_5 = arg_4_0.conditionTb[iter_4_0][2]
		local var_4_6 = var_4_0:get("count" .. iter_4_0)

		var_4_6:setString(string.format("(%s/%s)", var_4_4, var_4_5))

		if not var_4_3 then
			local var_4_7 = var_4_0:get("text" .. iter_4_0)

			text.addEffect(var_4_7, {
				color = cc.c4b(236, 183, 42, 255)
			})
			text.addEffect(var_4_6, {
				color = cc.c4b(236, 183, 42, 255)
			})
		end

		var_4_0:get("star" .. iter_4_0 .. ".achieve"):setVisible(var_4_3)
	end
end

function var_0_1.onSetBtnClick(arg_5_0)
	return
end

function var_0_1.onClose(arg_6_0)
	display.director:resume()
	audio.resumeAllSounds()
	var_0_0.onClose(arg_6_0)
end

function var_0_1.onBackBtnClick(arg_7_0)
	audio.stopAllSounds()
	display.director:resume()
	gGameUI:switchUI("city.view")
end

local var_0_5 = {
	[game.GATE_TYPE.normal] = true,
	[game.GATE_TYPE.endlessTower] = false,
	[game.GATE_TYPE.randomTower] = true,
	[game.GATE_TYPE.dailyGold] = true,
	[game.GATE_TYPE.dailyExp] = true,
	[game.GATE_TYPE.fragment] = true,
	[game.GATE_TYPE.simpleActivity] = true,
	[game.GATE_TYPE.gift] = true,
	[game.GATE_TYPE.unionFuben] = true,
	[game.GATE_TYPE.gym] = true,
	[game.GATE_TYPE.huoDongBoss] = true,
	[game.GATE_TYPE.braveChallenge] = false,
	[game.GATE_TYPE.summerChallenge] = false,
	[game.GATE_TYPE.hunting] = true
}

function var_0_1.onRestartBtnClick(arg_8_0)
	display.director:resume()
	display.director:getScheduler():setTimeScale(1)

	local var_8_0 = arg_8_0.battleView.data
	local var_8_1 = arg_8_0.battleView.entrance

	assert(var_8_0 and var_8_1, "data and entrance was nil !")

	if var_8_0.play_record_id and var_8_0.cross_key and var_8_0.record_url then
		gGameModel:playRecordBattle(var_8_0.play_record_id, var_8_0.cross_key, var_8_0.record_url, 0)

		return
	end

	if arg_8_0.battleView.modes.isRecord then
		battleEntrance.battleRecord(var_8_0, {}):show()
	elseif var_8_0.randSeed then
		if var_0_5[var_8_0.gateType] then
			var_8_0.randSeed = math.random(1, 99999999)

			local var_8_2 = string.format("\n\n\t\tbattle reseed - gate=%s, new_seed=%s, scene=%s\n\n", var_8_0.gateType, var_8_0.randSeed, var_8_0.sceneID)

			printInfo(var_8_2)
			log.battle(var_8_2)
			gGameUI:switchUI("battle.loading", var_8_0, var_8_0.sceneID, nil, var_8_1)
		else
			var_8_1:restart()
		end
	end
end

return var_0_1
