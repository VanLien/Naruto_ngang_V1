local var_0_0 = require("app.views.city.activity.view")
local var_0_1 = class("ActivityWorldBossView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "activity_world_boss.json"
var_0_1.RESOURCE_BINDING = {
	["centerPanel.nameBg.name"] = "bossName",
	["centerPanel.title.txt2"] = "bossAllDamage",
	["centerPanel.num"] = "num",
	["centerPanel.num1"] = "num1",
	["rightPanel.timesPanel.timesLabel"] = "timesLabel",
	leftPanel = "leftPanel",
	["rightPanel.timesPanel.times"] = "times",
	["centerPanel.barBg"] = "barBg",
	centerPanel = "centerPanel",
	["centerPanel.countdownBg"] = "countdownBg",
	bgPanel = "bgPanel",
	["centerPanel.skillItem"] = "skillItem",
	["centerPanel.title.txt1"] = "bosslevel",
	["leftPanel.rule"] = {
		varname = "ruleBtn",
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["leftPanel.rank"] = {
		varname = "rankBtn",
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["leftPanel.award"] = {
		varname = "awardBtn",
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("onAwardClick")
			}
		}
	},
	["centerPanel.countdownBg.label"] = {
		varname = "countdownLabel",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(66, 59, 66, 255)
				}
			}
		}
	},
	["centerPanel.countdownBg.time"] = {
		varname = "countdown",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(66, 59, 66, 255)
				}
			}
		}
	},
	["centerPanel.skillList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("skillDatas"),
				item = bindHelper.self("skillItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					if arg_1_3.skillId == 0 then
						arg_1_1:get("icon"):hide()
						arg_1_1:get("frame"):hide()
					else
						arg_1_1:get("icon"):show():texture(arg_1_3.icon)
						arg_1_1:get("frame"):show()
						bind.touch(arg_1_0, arg_1_1, {
							methods = {
								ended = functools.partial(arg_1_0.clickCell, arg_1_1, arg_1_3)
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onSkillClick")
			}
		}
	},
	["centerPanel.bar"] = {
		varname = "bar",
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "activity/world_boss/main/jdt_1.png",
				data = bindHelper.self("barPoint")
			}
		}
	},
	["centerPanel.title.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c4b(254, 253, 236, 255)
				}
			}
		}
	},
	["centerPanel.gift"] = {
		varname = "gift",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBoxClick")
			}
		}
	},
	["rightPanel.startBtn"] = {
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("onStartClick")
			}
		}
	},
	["rightPanel.timesBuyBtn"] = {
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("onTimesBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1, arg_2_2)
	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "WORLD BOSS",
		title = "common/txt/txt_bt_shijieboss.png"
	})
	arg_2_0:initModel()
	widget.addAnimationByKey(arg_2_0.bgPanel, "worldboss/shijiebossbeijing.skel", "effect", "effect_loop", 1):xy(1560, 720):scale(2)
	arg_2_0.ruleBtn:xy(125, 398)
	arg_2_0.rankBtn:xy(125, 254)
	arg_2_0.awardBtn:xy(125, 104)
	adapt.dockWithScreen(arg_2_0.leftPanel, "left")

	arg_2_0.activityID = arg_2_1

	local var_2_0 = csv.yunying.yyhuodong[arg_2_1]
	local var_2_1

	for iter_2_0, iter_2_1 in orderCsvPairs(csv.world_boss.base) do
		if iter_2_1.huodongID == var_2_0.huodongID then
			var_2_1 = iter_2_1

			break
		end
	end

	arg_2_0.baseCfg = var_2_1
	arg_2_0.level = arg_2_2.view.bossLevel

	arg_2_0.bosslevel:text(arg_2_0.level)
	arg_2_0.bossAllDamage:text(gLanguageCsv.worldBossServerDamageTip)

	arg_2_0.barPoint = idler.new(0)

	local var_2_2 = csv.world_boss.hp_fix[arg_2_0.level].hpFix / 100

	arg_2_0.bossHp = math.floor(var_2_1.baseHP * var_2_2)

	text.addEffect(arg_2_0.num, {
		outline = {
			size = 2,
			color = cc.c4b(254, 253, 236, 255)
		}
	})
	text.addEffect(arg_2_0.num1, {
		outline = {
			size = 2,
			color = cc.c4b(209, 128, 0, 255)
		}
	})
	text.addEffect(arg_2_0.bosslevel, {
		outline = {
			size = 3,
			color = cc.c4b(254, 253, 236, 255)
		}
	})

	local var_2_3 = csv.unit[var_2_1.bossID]

	arg_2_0.bossName:text(var_2_3.name)
	widget.addAnimation(arg_2_0.centerPanel, var_2_3.unitRes, "standby_loop", 0):scale(var_2_3.scale * 2 * var_2_1.bossScale):xy(960 + (var_2_1.bossPos.x or 0), 500 + (var_2_1.bossPos.y or 0)):setSkin(var_2_3.skin)

	arg_2_0.skillDatas = {}

	for iter_2_2, iter_2_3 in ipairs(var_2_3.skillList) do
		arg_2_0.skillDatas[iter_2_2] = {
			skillId = iter_2_3,
			icon = var_2_1.skillIcon[iter_2_2]
		}
	end

	for iter_2_4 = #arg_2_0.skillDatas + 1, 4 do
		arg_2_0.skillDatas[iter_2_4] = {
			skillId = 0
		}
	end

	arg_2_0.leftTimes = idlereasy.any({
		arg_2_0.bossGatePlay,
		arg_2_0.bossGateBuy
	}, function(arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = var_2_0.paramMap.freeCount
		local var_3_1 = var_3_0 + arg_3_2 - arg_3_1

		arg_2_0.times:text(string.format("%d/%d", var_3_1, var_3_0))

		return true, var_3_1
	end)

	var_0_0.setCountdown(arg_2_0, arg_2_1, arg_2_0.countdownLabel, arg_2_0.countdown, {
		labelChangeCb = function()
			adapt.oneLineCenterPos(cc.p(210, 50), {
				arg_2_0.countdownLabel,
				arg_2_0.countdown
			}, cc.p(15, 0))
		end
	})
	arg_2_0.gift:texture(var_2_1.serverTargetRes)

	local var_2_4 = arg_2_0.damageSum and 0 or 10

	arg_2_0.damageSum = arg_2_0.damageSum or arg_2_2.view.damageSum

	arg_2_0:refreshDamage()
	arg_2_0:enableSchedule():schedule(function()
		gGameApp:requestServer("/game/yy/world/boss/main", function(arg_6_0)
			arg_2_0.damageSum = arg_6_0.view.damageSum

			arg_2_0:refreshDamage()
		end, arg_2_1)
	end, 10, var_2_4)
end

function var_0_1.refreshDamage(arg_7_0)
	local var_7_0 = arg_7_0.damageSum or 0

	arg_7_0.num:text(mathEasy.getShortNumber(var_7_0, 2))
	arg_7_0.num1:text("/" .. mathEasy.getShortNumber(arg_7_0.bossHp, 2))
	adapt.oneLineCenterPos(cc.p(903, 410), {
		arg_7_0.num,
		arg_7_0.num1
	}, cc.p(10, 0))

	if var_7_0 >= arg_7_0.bossHp then
		var_7_0 = arg_7_0.bossHp

		widget.addAnimationByKey(arg_7_0.gift, "effect/jiedianjiangli.skel", "rewardEffect", "effect_loop", -1):xy(40, 10):scale(0.45)
	end

	arg_7_0.barPoint:set(var_7_0 / arg_7_0.bossHp * 100)
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.bossGatePlay = gGameModel.daily_record:getIdler("boss_gate")
	arg_8_0.bossGateBuy = gGameModel.daily_record:getIdler("boss_gate_buy")
	arg_8_0.vip = gGameModel.role:getIdler("vip_level")
end

function var_0_1.onRuleClick(arg_9_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_9_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.onAwardClick(arg_10_0)
	gGameUI:stackUI("city.activity.world_boss.reward", nil, nil, arg_10_0.activityID)
end

function var_0_1.onRankClick(arg_11_0)
	gGameApp:requestServer("/game/yy/world/boss/rank", function(arg_12_0)
		gGameUI:stackUI("city.activity.world_boss.rank", nil, nil, arg_11_0.activityID, arg_12_0.view)
	end)
end

function var_0_1.onStartClick(arg_13_0)
	if arg_13_0.leftTimes:read() > 0 then
		gGameUI:stackUI("city.card.embattle.base", nil, {
			full = true
		}, {
			fightCb = arg_13_0:createHandler("startFighting"),
			from = game.EMBATTLE_FROM_TABLE.huodong,
			fromId = game.EMBATTLE_HOUDONG_ID.worldBoss
		})
	else
		arg_13_0:onTimesBuyClick(gLanguageCsv.yyWorldBossCountLimit)
	end
end

function var_0_1.getRuleContext(arg_14_0, arg_14_1)
	local var_14_0 = adaptContext

	return {
		var_14_0.clone(arg_14_1.title, function(arg_15_0)
			arg_15_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_14_0.noteText(143),
		var_14_0.noteText(85001, 85099)
	}
end

function var_0_1.onTimesBuyClick(arg_16_0, arg_16_1)
	local var_16_0 = gVipCsv[arg_16_0.vip:read()].bossTimeBuyLimit
	local var_16_1 = arg_16_0.bossGateBuy:read()

	if var_16_0 <= var_16_1 then
		if type(arg_16_1) ~= "string" then
			arg_16_1 = gLanguageCsv.yyWorldBossBuyMax
		end

		gGameUI:showTip(arg_16_1)

		return
	end

	local var_16_2 = gCostCsv.world_boss_buy_cost
	local var_16_3 = math.min(var_16_1 + 1, table.length(var_16_2))

	local function var_16_4()
		if gGameModel.role:read("rmb") < var_16_2[var_16_3] then
			uiEasy.showDialog("rmb")
		else
			gGameApp:requestServer("/game/yy/world/boss/buy")
		end
	end

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		cb = var_16_4,
		title = gLanguageCsv.spaceTips,
		content = string.format(gLanguageCsv.worldBossBuyTip, var_16_2[var_16_3]),
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.onSkillClick(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_3.skillId == 0 then
		return
	end

	local var_18_0 = gGameUI:stackUI("common.skill_detail", nil, {
		clickClose = true,
		dispatchNodes = arg_18_1
	}, {
		ignoreStar = true,
		hideSkillLevel = false,
		skillLevel = arg_18_0.level,
		skillId = arg_18_3.skillId,
		skillIcon = arg_18_3.icon
	})
	local var_18_1 = var_18_0:getResourceNode()
	local var_18_2, var_18_3 = var_18_1:xy()

	var_18_1:xy(var_18_2 + arg_18_2:x() + 65, var_18_0.panel:y() - 25)
end

function var_0_1.startFighting(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0:disableSchedule()
	battleEntrance.battleRequest("/game/yy/world/boss/start", arg_19_2, arg_19_0.activityID):onStartOK(function(arg_20_0)
		arg_20_0.activityID = arg_19_0.activityID

		if arg_19_1 then
			arg_19_1:onClose(false)

			arg_19_1 = nil
		end
	end):show()
end

function var_0_1.onBoxClick(arg_21_0, arg_21_1)
	gGameUI:showBoxDetail({
		state = 1,
		data = arg_21_0.baseCfg.serverTargetAward,
		content = gLanguageCsv.allDamageGet
	})
end

return var_0_1
