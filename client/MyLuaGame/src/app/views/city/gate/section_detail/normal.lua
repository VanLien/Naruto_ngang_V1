local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GateSectionNormal", var_0_0)
local var_0_2 = {
	1,
	10,
	50
}

var_0_1.RESOURCE_FILENAME = "gate_section_detail_normal.json"
var_0_1.RESOURCE_BINDING = {
	rightDown = "rightDown",
	leftDown = "leftDown",
	iconItem = "iconItem",
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

function var_0_1.initModel(arg_5_0)
	arg_5_0.gate_star = gGameModel.role:getIdler("gate_star")
	arg_5_0.roleLv = gGameModel.role:getIdler("level")
	arg_5_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_5_0.stamina = gGameModel.role:getIdler("stamina")
	arg_5_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_5_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
end

function var_0_1.initLeftDown(arg_6_0)
	local var_6_0 = csv.scene_conf[arg_6_0.gateId]
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in csvMapPairs(var_6_0.dropIds) do
		table.insert(var_6_1, {
			key = iter_6_0,
			num = iter_6_1
		})
	end

	arg_6_0.dropDatas = var_6_1
end

function var_0_1.initRightDown(arg_7_0)
	local var_7_0 = csv.scene_conf[arg_7_0.gateId]
	local var_7_1 = var_0_2
	local var_7_2 = {}

	for iter_7_0 = 1, #var_7_1 do
		table.insert(var_7_2, string.format(gLanguageCsv.sweepManyTimes, var_7_1[iter_7_0]))
	end

	arg_7_0.sortDatas = idlertable.new(var_7_2)

	idlereasy.when(arg_7_0.gate_star, function(arg_8_0, arg_8_1)
		local var_8_0 = (arg_8_1[arg_7_0.gateId] and arg_7_0.gate_star:read()[arg_7_0.gateId].star or 0) >= 3

		arg_7_0.sweepBtn:setTouchEnabled(var_8_0)
		arg_7_0.sweepBtn:visible(var_8_0)
		arg_7_0.sortPanel:visible(var_8_0)
	end)

	arg_7_0.locked = idler.new(0)

	idlereasy.any({
		arg_7_0.vipLevel
	}, function(arg_9_0, arg_9_1)
		local var_9_0 = gVipCsv[arg_9_1].saodangCountOpen
		local var_9_1 = dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.GateSaoDangTimes)
		local var_9_2 = 0

		if var_9_1 < var_0_2[2] and var_9_0 < var_0_2[2] then
			var_9_2 = 2
		elseif var_9_1 < var_0_2[3] and var_9_0 < var_0_2[3] then
			var_9_2 = 3
		end

		arg_7_0.locked:set(var_9_2)
	end)
	dataEasy.fixSaoDangLocalKey("sweepSelected", var_0_2)

	arg_7_0.sweepSelected = userDefault.getForeverLocalKey("sweepSelected", 1)
	arg_7_0.mopUpNum = var_0_2[arg_7_0.sweepSelected]
	arg_7_0.powerNum = idler.new(var_7_0.staminaCost)

	local var_7_3 = userDefault.getForeverLocalKey("skipBattle", false)

	arg_7_0.selectSkip:get("selectSkip"):setSelectedState(var_7_3)
end

function var_0_1.checkSweep(arg_10_0)
	local var_10_0 = csv.scene_conf[arg_10_0.gateId].staminaCost
	local var_10_1 = dataEasy.getStamina()

	if var_10_1 < var_10_0 then
		gGameUI:stackUI("common.gain_stamina")

		return false
	end

	arg_10_0.curMopUpNum = math.min(arg_10_0.mopUpNum, math.floor(var_10_1 / var_10_0))

	return true
end

function var_0_1.onSweepBtn(arg_11_0)
	if not arg_11_0:checkSweep() then
		return
	end

	local var_11_0 = gGameModel.capture:read("limit_sprites")
	local var_11_1 = arg_11_0.roleLv:read()

	gGameApp:requestServer("/game/saodang", function(arg_12_0)
		local var_12_0 = arg_12_0.view.result

		table.insert(var_12_0, {
			exp = 0,
			isExtra = true,
			items = arg_12_0.view.extra
		})
		gGameUI:stackUI("city.gate.sweep", nil, nil, {
			from = "gate",
			hasExtra = true,
			sweepData = var_12_0,
			oldRoleLv = var_11_1,
			cb = arg_11_0:createHandler("onSweepBtn"),
			checkCb = arg_11_0:createHandler("checkSweep"),
			oldCapture = var_11_0,
			isDouble = dataEasy.isGateIdDoubleDrop(arg_11_0.gateId),
			gateId = arg_11_0.gateId,
			catchup = arg_12_0.view.catchup
		})
	end, arg_11_0.gateId, arg_11_0.curMopUpNum)
end

function var_0_1.onSelectSkip(arg_13_0)
	local var_13_0 = userDefault.getForeverLocalKey("skipBattle", false)

	arg_13_0.selectSkip:get("selectSkip"):setSelectedState(not var_13_0)
	userDefault.setForeverLocalKey("skipBattle", not var_13_0)
end

function var_0_1.onChallengeClick(arg_14_0)
	if csv.scene_conf[arg_14_0.gateId].staminaCost > dataEasy.getStamina() then
		gGameUI:stackUI("common.gain_stamina")

		return
	end

	if userDefault.getForeverLocalKey("skipBattle", false) then
		arg_14_0.fightCb()
	else
		gGameUI:stackUI("city.card.embattle.base", nil, {
			full = true
		}, {
			fightCb = arg_14_0.fightCb
		})
	end
end

function var_0_1.onSortMenusBtnClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = dataEasy.getSaoDangState(var_0_2[arg_15_3])

	if not var_15_0.canSaoDang then
		gGameUI:showTip(var_15_0.tip)

		return
	end

	arg_15_0.mopUpNum = var_0_2[arg_15_3]

	userDefault.setForeverLocalKey("sweepSelected", arg_15_3)
end

function var_0_1.onAfterBuild(arg_16_0)
	return
end

function var_0_1.setBtnFalse(arg_17_0)
	cache.setShader(arg_17_0.btnChallenge, false, "hsl_gray")
	arg_17_0.btnChallenge:setTouchEnabled(false)
end

return var_0_1
