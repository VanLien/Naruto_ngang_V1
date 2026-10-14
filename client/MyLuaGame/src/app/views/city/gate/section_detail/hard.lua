local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GateSectionHard", Dialog)
local var_0_2 = {
	1,
	3
}

var_0_1.RESOURCE_FILENAME = "gate_section_detail_hard.json"
var_0_1.RESOURCE_BINDING = {
	["rightDown.textLeftTime"] = "timesNum",
	iconItem = "iconItem",
	["rightDown.textLeftTimeNote"] = "timesNote1",
	["rightDown.textKh"] = "textKh",
	["rightDown.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightDown.btnSweep.textNote"] = {
		varname = "sweepBtnTitle",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightDown.textCostNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("powerNum")
		}
	},
	["rightDown.btnAdd"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTimesBtnClick")
			}
		}
	},
	["leftDown.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("dropDatas"),
				item = bindHelper.self("iconItem"),
				dataOrderCmp = dataEasy.sortItemCmp,
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:size()
					local var_1_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							}
						}
					}

					bind.extend(arg_1_0, arg_1_1, var_1_1)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["rightDown.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChallengeClick")
			}
		}
	},
	["rightDown.selectSkip"] = {
		varname = "selectSkip",
		binds = {
			event = "click",
			method = bindHelper.self("onSelectSkip")
		}
	},
	["rightDown.btnSweep"] = {
		varname = "sweepBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onSweepBtn")
		}
	},
	["rightDown.sortPanel"] = {
		varname = "sortPanel",
		binds = {
			event = "extend",
			class = "sort_menus",
			props = {
				expandUp = true,
				data = bindHelper.self("sortDatas"),
				locked = bindHelper.self("locked"),
				showSelected = bindHelper.self("sweepSelected"),
				btnClick = bindHelper.self("onSortMenusBtnClick", true),
				onNode = function(arg_3_0)
					arg_3_0:xy(-1120, -487):z(18)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0:initModel()

	arg_4_0.gateId = arg_4_1
	arg_4_0.pageId = arg_4_2
	arg_4_0.fightCb = arg_4_3

	arg_4_0:initLeftDown()
	arg_4_0:initRightDown()
end

function var_0_1.initLeftDown(arg_5_0)
	local var_5_0 = csv.scene_conf[arg_5_0.gateId]
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in csvMapPairs(var_5_0.dropIds) do
		table.insert(var_5_1, {
			key = iter_5_0,
			num = iter_5_1
		})
	end

	arg_5_0.dropDatas = var_5_1
end

function var_0_1.initRightDown(arg_6_0)
	local var_6_0 = csv.scene_conf[arg_6_0.gateId]
	local var_6_1 = var_0_2
	local var_6_2 = {}

	for iter_6_0 = 1, #var_6_1 do
		table.insert(var_6_2, string.format(gLanguageCsv.sweepManyTimes, var_6_1[iter_6_0]))
	end

	arg_6_0.sortDatas = idlertable.new(var_6_2)

	idlereasy.when(arg_6_0.gate_star, function(arg_7_0, arg_7_1)
		local var_7_0 = (arg_7_1[arg_6_0.gateId] and arg_6_0.gate_star:read()[arg_6_0.gateId].star or 0) >= 3

		arg_6_0.sweepBtn:setTouchEnabled(var_7_0)
		arg_6_0.sweepBtn:visible(var_7_0)
		arg_6_0.sortPanel:visible(var_7_0)
	end)

	arg_6_0.locked = idler.new(0)
	arg_6_0.sweepSelected = userDefault.getForeverLocalKey("sweepSelectedHard", 1)
	arg_6_0.mopUpNum = var_0_2[arg_6_0.sweepSelected]
	arg_6_0.powerNum = idler.new(var_6_0.staminaCost)

	local var_6_3 = userDefault.getForeverLocalKey("skipBattle", false)

	arg_6_0.selectSkip:get("selectSkip"):setSelectedState(var_6_3)
	idlereasy.when(arg_6_0.gateTimes, function(arg_8_0, arg_8_1)
		local var_8_0 = var_6_0.dayChallengeMax - (arg_8_1[arg_6_0.gateId] or 0)
		local var_8_1 = var_6_0.dayChallengeMax
		local var_8_2 = arg_6_0.buyHerogateTimes:read()[arg_6_0.gateId] or 0
		local var_8_3, var_8_4, var_8_5 = dataEasy.isDoubleHuodong("heroGateTimes")

		if var_8_3 then
			for iter_8_0, iter_8_1 in pairs(var_8_4) do
				local var_8_6 = iter_8_1.count

				if var_8_6 and var_8_6 > 0 then
					if var_8_2 == 0 then
						var_8_0 = var_8_0 + var_8_6
					end

					var_8_1 = var_8_1 + var_8_6
				end
			end
		end

		arg_6_0.surplusTimes = var_8_0

		arg_6_0.timesNum:text(math.max(var_8_0, 0) .. "/" .. var_8_1)
		adapt.oneLinePos(arg_6_0.timesNum, arg_6_0.textKh, nil, "left")
	end)
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.gate_star = gGameModel.role:getIdler("gate_star")
	arg_9_0.roleLv = gGameModel.role:getIdler("level")
	arg_9_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_9_0.stamina = gGameModel.role:getIdler("stamina")
	arg_9_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_9_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
end

function var_0_1.onTimesBtnClick(arg_10_0)
	local var_10_0 = gVipCsv[gGameModel.role:read("vip_level")].buyHeroGateTimes
	local var_10_1 = arg_10_0.buyHerogateTimes:read()

	if var_10_0 <= (var_10_1[arg_10_0.gateId] or 0) then
		gGameUI:showTip(gLanguageCsv.herogateBuyMax)

		return
	end

	if arg_10_0.surplusTimes > 0 then
		gGameUI:showTip(gLanguageCsv.haveChallengeTimesUnused)

		return
	end

	if gCostCsv.herogate_buy_cost[(var_10_1[arg_10_0.gateId] or 0) + 1] > gGameModel.role:read("rmb") then
		uiEasy.showDialog("rmb")

		return
	end

	local var_10_2 = {
		"#C0x5b545b#" .. string.format(gLanguageCsv.resetNumberEliteLevels1, gCostCsv.herogate_buy_cost[(var_10_1[arg_10_0.gateId] or 0) + 1]),
		"#C0x8A5B0C#" .. string.format(gLanguageCsv.resetNumberEliteLevels2, var_10_1[arg_10_0.gateId] or 0, var_10_0)
	}

	gGameUI:showDialog({
		btnType = 2,
		isRich = true,
		content = var_10_2,
		cb = function()
			gGameApp:requestServer("/game/role/hero_gate/buy", function()
				gGameUI:showTip(gLanguageCsv.resetSuccess)
			end, arg_10_0.gateId)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.checkSweep(arg_13_0)
	local var_13_0 = csv.scene_conf[arg_13_0.gateId].staminaCost
	local var_13_1 = dataEasy.getStamina()

	if var_13_1 < var_13_0 then
		gGameUI:stackUI("common.gain_stamina")

		return false
	end

	arg_13_0.curMopUpNum = math.min(arg_13_0.mopUpNum, math.floor(var_13_1 / var_13_0))

	if arg_13_0.surplusTimes <= 0 then
		arg_13_0:onTimesBtnClick()

		return false
	end

	return true
end

function var_0_1.onSweepBtn(arg_14_0)
	if not arg_14_0:checkSweep() then
		return
	end

	local var_14_0 = gGameModel.capture:read("limit_sprites")
	local var_14_1 = arg_14_0.roleLv:read()

	gGameApp:requestServer("/game/saodang", function(arg_15_0)
		local var_15_0 = arg_15_0.view.result

		table.insert(var_15_0, {
			exp = 0,
			isExtra = true,
			items = arg_15_0.view.extra
		})
		gGameUI:stackUI("city.gate.sweep", nil, nil, {
			from = "gate",
			hasExtra = true,
			sweepData = var_15_0,
			oldRoleLv = var_14_1,
			cb = arg_14_0:createHandler("onSweepBtn"),
			checkCb = arg_14_0:createHandler("checkSweep"),
			oldCapture = var_14_0,
			isDouble = dataEasy.isGateIdDoubleDrop(arg_14_0.gateId),
			gateId = arg_14_0.gateId,
			catchup = arg_15_0.view.catchup
		})
	end, arg_14_0.gateId, arg_14_0.curMopUpNum)
end

function var_0_1.onSelectSkip(arg_16_0)
	local var_16_0 = userDefault.getForeverLocalKey("skipBattle", false)

	arg_16_0.selectSkip:get("selectSkip"):setSelectedState(not var_16_0)
	userDefault.setForeverLocalKey("skipBattle", not var_16_0)
end

function var_0_1.onChallengeClick(arg_17_0)
	if csv.scene_conf[arg_17_0.gateId].staminaCost > dataEasy.getStamina() then
		gGameUI:stackUI("common.gain_stamina")

		return
	end

	if arg_17_0.surplusTimes <= 0 then
		gGameUI:showTip(gLanguageCsv.timesLimitEatGreenBlock)

		return
	end

	if userDefault.getForeverLocalKey("skipBattle", false) then
		arg_17_0.fightCb()
	else
		gGameUI:stackUI("city.card.embattle.base", nil, {
			full = true
		}, {
			fightCb = arg_17_0.fightCb
		})
	end
end

function var_0_1.onSortMenusBtnClick(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	arg_18_0.mopUpNum = var_0_2[arg_18_3]

	userDefault.setForeverLocalKey("sweepSelectedHard", arg_18_3)
end

function var_0_1.onAfterBuild(arg_19_0)
	return
end

function var_0_1.setBtnFalse(arg_20_0)
	cache.setShader(arg_20_0.btnChallenge, false, "hsl_gray")
	arg_20_0.btnChallenge:setTouchEnabled(false)
end

return var_0_1
