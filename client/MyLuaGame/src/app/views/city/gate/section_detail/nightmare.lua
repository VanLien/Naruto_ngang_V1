local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GateSectionNightmare", var_0_0)
local var_0_2 = {
	1,
	10,
	50
}

local function var_0_3(arg_1_0, arg_1_1)
	if not arg_1_1 then
		return
	end

	local var_1_0 = arg_1_0:size()
	local var_1_1 = cc.Sprite:create("city/gate/logo_yhd.png"):addTo(arg_1_0, 999):xy(var_1_0.width / 2, var_1_0.height / 2)
end

var_0_1.RESOURCE_FILENAME = "gate_section_detail_nightmare.json"
var_0_1.RESOURCE_BINDING = {
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
	["leftDown.firstDrop.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("firstDropDatas"),
				item = bindHelper.self("iconItem"),
				dataOrderCmp = dataEasy.sortItemCmp,
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:size()
					local var_2_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num
							},
							onNode = function(arg_3_0)
								var_0_3(arg_3_0, arg_2_3.isGet)
							end
						}
					}

					bind.extend(arg_2_0, arg_2_1, var_2_1)
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	},
	["leftDown.starDrop.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("starDropDatas"),
				item = bindHelper.self("iconItem"),
				dataOrderCmp = dataEasy.sortItemCmp,
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:size()
					local var_5_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_5_3.key,
								num = arg_5_3.num
							},
							onNode = function(arg_6_0)
								var_0_3(arg_6_0, arg_5_3.isGet)
							end
						}
					}

					bind.extend(arg_5_0, arg_5_1, var_5_1)
				end,
				onAfterBuild = function(arg_7_0)
					arg_7_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild")
			}
		}
	}
}

function var_0_1.onCreate(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:initModel()

	arg_8_0.gateId = arg_8_1
	arg_8_0.pageId = arg_8_2
	arg_8_0.fightCb = arg_8_3

	arg_8_0:initLeftDown()
	arg_8_0:initRightDown()
end

function var_0_1.initModel(arg_9_0)
	arg_9_0.gate_star = gGameModel.role:getIdler("gate_star")
	arg_9_0.roleLv = gGameModel.role:getIdler("level")
	arg_9_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_9_0.stamina = gGameModel.role:getIdler("stamina")
	arg_9_0.buyHerogateTimes = gGameModel.daily_record:getIdler("buy_herogate_times")
	arg_9_0.gateTimes = gGameModel.daily_record:getIdler("gate_times")
end

function var_0_1.initLeftDown(arg_10_0)
	local var_10_0 = csv.scene_conf[arg_10_0.gateId]
	local var_10_1 = 0

	idlereasy.when(arg_10_0.gate_star, function(arg_11_0, arg_11_1)
		local var_11_0 = arg_11_1[arg_10_0.gateId] or {}
		local var_11_1 = {}

		for iter_11_0, iter_11_1 in csvMapPairs(var_10_0.winAward) do
			table.insert(var_11_1, {
				key = iter_11_0,
				num = iter_11_1,
				isGet = var_11_0.win_award == var_10_1
			})
		end

		arg_10_0.firstDropDatas = var_11_1

		local var_11_2 = {}

		for iter_11_2, iter_11_3 in csvMapPairs(var_10_0.star3Award) do
			table.insert(var_11_2, {
				key = iter_11_2,
				num = iter_11_3,
				isGet = var_11_0.star3_award == var_10_1
			})
		end

		arg_10_0.starDropDatas = var_11_2
	end)
end

function var_0_1.initRightDown(arg_12_0)
	local var_12_0 = csv.scene_conf[arg_12_0.gateId]

	arg_12_0.powerNum = idler.new(var_12_0.staminaCost)

	local var_12_1 = userDefault.getForeverLocalKey("skipBattle", false)

	arg_12_0.selectSkip:get("selectSkip"):setSelectedState(var_12_1)
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
			team = true,
			fightCb = arg_14_0.fightCb,
			from = game.EMBATTLE_FROM_TABLE.huodong,
			fromId = game.EMBATTLE_HOUDONG_ID.nightmare
		})
	end
end

function var_0_1.onAfterBuild(arg_15_0)
	return
end

function var_0_1.setBtnFalse(arg_16_0)
	cache.setShader(arg_16_0.btnChallenge, false, "hsl_gray")
	arg_16_0.btnChallenge:setTouchEnabled(false)
end

return var_0_1
