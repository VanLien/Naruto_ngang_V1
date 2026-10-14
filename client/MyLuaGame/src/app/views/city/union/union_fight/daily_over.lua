local var_0_0 = require("app.views.city.union.tools")
local var_0_1 = class("UnionFightDailyOverView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "union_fight_daily_over.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	title = "title",
	bg1 = "bg1",
	["listTitle.text1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["listTitle.text2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["listTitle.text3"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["listTitle.text4"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["item.lv"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(107, 82, 49, 255)
				}
			}
		}
	},
	["item.level"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(107, 82, 49, 255)
				}
			}
		}
	},
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("unionData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = {
						[0] = 0.3,
						0.6
					}
					local var_1_1 = arg_1_1:multiget("icon", "bg", "name", "num", "win", "score", "level")

					var_1_1.bg:setOpacity(255 * var_1_0[arg_1_2 % 2])
					var_1_1.icon:texture(gUnionLogoCsv[arg_1_3.union_logo])
					var_1_1.name:text(arg_1_3.union_name)
					var_1_1.score:text(arg_1_3.point)
					var_1_1.win:text(arg_1_3.kill_num)
					var_1_1.num:text(arg_1_3.sign_num)
					var_1_1.level:text(arg_1_3.union_level)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0)
	local var_2_0 = time.getNowDate()

	print_r(var_2_0)

	local var_2_1 = var_2_0.wday

	var_2_1 = var_2_1 == 1 and 7 or var_2_1 - 1

	local var_2_2, var_2_3 = dataEasy.getTimeStrByKey("unionFight", "signUpStart", true)

	if var_2_2 < var_2_0.hour or var_2_0.hour == var_2_2 and var_2_3 <= var_2_0.min then
		var_2_1 = var_2_1 + 1
	end

	arg_2_0.unionData = gGameModel.union_fight:read("final_result") or {}

	local var_2_4 = string.format(gLanguageCsv.unionFightDaliyOver, gGameModel.union_fight:read("last_union_name"), gGameModel.union_fight:read("last_role_name"), gLanguageCsv["weekday" .. var_2_1])

	if matchLanguage({
		"en"
	}) then
		var_2_4 = string.format(gLanguageCsv.unionFightDaliyOver1, gGameModel.union_fight:read("last_union_name"), gGameModel.union_fight:read("last_role_name"))
	end

	local var_2_5 = rich.createByStr(var_2_4, 44, nil, nil, cc.p(0, 0.5)):addTo(arg_2_0.title, 10, "privilege"):anchorPoint(cc.p(0.5, 0.5)):xy(1280, 60)
	local var_2_6, var_2_7 = arg_2_0.bg1:xy()
	local var_2_8 = arg_2_0:getResourceNode()
	local var_2_9 = arg_2_0.bg1:size()

	if matchLanguage({
		"en"
	}) then
		var_2_5:x(1180)
		var_2_5:formatText()

		arg_2_0.leftTimeText = cc.Label:createWithTTF("", ui.FONT_PATH, 44):color(cc.c4b(108, 233, 255, 255)):xy(var_2_5:x() + 20 + var_2_5:width() / 2, var_2_5:y()):anchorPoint(cc.p(0, 1)):addTo(arg_2_0.title, 11, "time")

		arg_2_0:startRefreshTime(var_2_1)
	end
end

function var_0_1.startRefreshTime(arg_3_0, arg_3_1)
	local function var_3_0()
		local var_4_0 = time.getNowDate()
		local var_4_1 = time.getTimestamp(var_4_0)
		local var_4_2, var_4_3 = dataEasy.getTimeStrByKey("unionFight", "signUpStart", true)
		local var_4_4 = arg_3_1 == 7 and 1 or arg_3_1 + 1

		var_4_0.day = var_4_0.day + (var_4_4 > var_4_0.wday and var_4_4 - var_4_0.wday or var_4_4 + 7 - var_4_0.wday)
		var_4_0.wday = var_4_4
		var_4_0.hour = var_4_2
		var_4_0.min = var_4_3
		var_4_0.sec = 0

		local var_4_5 = time.getTimestamp(var_4_0) - var_4_1

		if var_4_5 < 1 then
			return true
		end

		arg_3_0.leftTimeText:text(time.getCutDown(var_4_5).str)

		return false
	end

	local var_3_1 = 20210519

	arg_3_0:enableSchedule():unSchedule(var_3_1)
	arg_3_0:enableSchedule():schedule(function(arg_5_0)
		var_3_0()
	end, 1, 0, var_3_1)
end

return var_0_1
