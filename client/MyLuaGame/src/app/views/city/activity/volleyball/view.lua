local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("VolleyballView", var_0_0)

local function var_0_2(arg_1_0)
	return ({
		"Jan",
		"Feb",
		"Mar",
		"Apr",
		"May",
		"Jun",
		"Jul",
		"Aug",
		"Sept",
		"Oct",
		"Nov",
		"Dec"
	})[tonumber(arg_1_0)]
end

var_0_1.RESOURCE_FILENAME = "volleyball_main.json"
var_0_1.RESOURCE_BINDING = {
	ruleItem = "ruleItem",
	prepareBg = "prepareBg",
	["rightPanel.btnStart"] = {
		varname = "btnStart",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayGameClick")
			}
		}
	},
	textTipTime = {
		varname = "textTipTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(82, 76, 85, 255)
				}
			}
		}
	},
	["leftPanel.btnAward"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRewardClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					state = bindHelper.self("awardRedHint"),
					onNode = function(arg_2_0)
						arg_2_0:xy(150, 150)
					end
				}
			}
		}
	},
	["leftPanel.btnRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["leftPanel.btnRule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["leftPanel.btnAward.award"] = {
		varname = "award",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.WHITE
				},
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	},
	["leftPanel.btnRank.rank"] = {
		varname = "rank",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.WHITE
				},
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	},
	["leftPanel.btnRule.rule"] = {
		varname = "rule",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.COLORS.NORMAL.WHITE
				},
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1, arg_3_2)
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose")
	}):init({
		subTitle = "VOLLEYBALL GAME",
		title = gLanguageCsv.volleyballGame
	})
	arg_3_0.prepareBg:hide()
	arg_3_0:initModel()

	arg_3_0.activityId = arg_3_1
	arg_3_0.yyCfg = csv.yunying.yyhuodong[arg_3_0.activityId]

	local var_3_0 = string.format("%s.%s.%s", time.getYearMonthDay(arg_3_0.yyCfg.beginDate))
	local var_3_1 = string.format("%s.%s.%s", time.getYearMonthDay(arg_3_0.yyCfg.endDate))

	if matchLanguage({
		"en"
	}) then
		local var_3_2, var_3_3, var_3_4 = time.getYearMonthDay(arg_3_0.yyCfg.beginDate)
		local var_3_5, var_3_6, var_3_7 = time.getYearMonthDay(arg_3_0.yyCfg.endDate)
		local var_3_8 = var_0_2(var_3_3)
		local var_3_9 = var_0_2(var_3_6)

		var_3_0 = string.format("%s.%s.%s", var_3_2, var_3_8, var_3_4)
		var_3_1 = string.format("%s.%s.%s", var_3_5, var_3_9, var_3_7)
	end

	arg_3_0.textTipTime:text(string.format("%s %s-%s", gLanguageCsv.volleyballOpenTime, var_3_0, var_3_1))
	idlereasy.when(arg_3_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_1[arg_3_0.activityId] or {}

		arg_3_0.roleData = var_4_0.valsums and var_4_0.valsums[201] or 0

		for iter_4_0, iter_4_1 in pairs(var_4_0.stamps or {}) do
			if iter_4_1 == 1 then
				arg_3_0.awardRedHint:set(true)

				return
			end
		end

		arg_3_0.awardRedHint:set(false)
	end)
end

function var_0_1.initModel(arg_5_0)
	arg_5_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_5_0.awardRedHint = idler.new(false)
end

function var_0_1.onPlayGameClick(arg_6_0)
	gGameUI:stackUI("city.activity.volleyball.game", nil, nil, arg_6_0.activityId, arg_6_0.roleData)
end

function var_0_1.onRewardClick(arg_7_0)
	gGameUI:stackUI("city.activity.volleyball.reward", nil, {
		blackLayer = true
	}, arg_7_0.activityId)
end

function var_0_1.onRankClick(arg_8_0)
	gGameApp:requestServer("/game/yy/volleyball/rank", function(arg_9_0)
		gGameUI:stackUI("city.activity.volleyball.rank", nil, nil, arg_9_0.view, arg_8_0.roleData)
	end, arg_8_0.activityId)
end

function var_0_1.onRuleClick(arg_10_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_10_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_1.getRuleContext(arg_11_0, arg_11_1)
	local var_11_0 = adaptContext
	local var_11_1 = {
		var_11_0.clone(arg_11_1.title, function(arg_12_0)
			arg_12_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_11_0.noteText(124901, 124907)
	}
	local var_11_2 = {
		"btn_t.png",
		"btn_xl.png",
		"btn_jn.png",
		"btn_jn_3.png",
		"btn_jn_m.png"
	}

	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		table.insert(var_11_1, var_11_0.clone(arg_11_0.ruleItem, function(arg_13_0)
			arg_13_0:multiget("skill", "textDesc").skill:texture("activity/volleyball/" .. iter_11_1)
			rich.createWithWidth(gLanguageCsv["volleyballSkill" .. iter_11_0], 40, nil, 1000, 0):anchorPoint(0, 0.5):addTo(arg_13_0):y(arg_13_0:height() / 2):x(350)
		end))
	end

	table.insert(var_11_1, var_11_0.noteText(124908, 125000))

	return var_11_1
end

return var_0_1
