local var_0_0 = require("app.views.city.pvp.cross_craft.view")
local var_0_1 = {}

for iter_0_0 = 3, 10 do
	var_0_1[iter_0_0] = gLanguageCsv["symbolNumber" .. iter_0_0]
end

for iter_0_1 = 11, 19 do
	var_0_1[iter_0_1] = gLanguageCsv.symbolNumber10 .. gLanguageCsv["symbolNumber" .. iter_0_1 - 10]
end

local var_0_2 = {
	fail = gLanguageCsv.budi,
	win = {
		gLanguageCsv.wansheng,
		gLanguageCsv.xiansheng,
		gLanguageCsv.zhansheng
	}
}
local var_0_3 = {
	pre12 = {
		turn = 1,
		index = 1
	},
	pre13 = {
		turn = 1,
		index = 2
	},
	pre14 = {
		turn = 1,
		index = 3
	},
	pre21 = {
		turn = 1,
		index = 4
	},
	pre22 = {
		turn = 2,
		index = 1
	},
	pre23 = {
		turn = 2,
		index = 2
	},
	pre24 = {
		turn = 2,
		index = 3
	},
	pre31 = {
		turn = 2,
		index = 4
	},
	pre32 = {
		turn = 3,
		index = 1
	},
	pre33 = {
		turn = 3,
		index = 2
	},
	pre34 = {
		turn = 3,
		index = 3
	},
	top64 = {
		turn = 3,
		index = 4
	}
}

local function var_0_4(arg_1_0)
	local var_1_0

	for iter_1_0, iter_1_1 in ipairs(game.CROSS_CRAFT_ROUNDS) do
		if iter_1_1 == arg_1_0 then
			var_1_0 = var_1_0 or arg_1_0
		end

		if var_1_0 and var_0_3[iter_1_1] then
			var_1_0 = iter_1_1

			break
		end
	end

	return var_0_0.getNextStateTime(arg_1_0 == "halftime" and "prepare2" or var_1_0), var_0_3[var_1_0].turn, var_0_3[var_1_0].index
end

local var_0_5 = class("BattleMessageView", cc.load("mvc").ViewBase)

var_0_5.RESOURCE_FILENAME = "cross_craft_battle_messages.json"
var_0_5.RESOURCE_BINDING = {
	item = "item",
	sessionPanel = "sessionPanel",
	list = {
		varname = "speList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("showMsg"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:removeChildByName("rich")

					local var_2_0 = arg_2_3[2][2]
					local var_2_1 = arg_2_3[2][1][1]
					local var_2_2 = "#C0x0BFA87##F48##L10#" .. var_2_0 .. string.format(gLanguageCsv.brackets, getServerArea(var_2_1, true))

					if arg_2_3[1] ~= "streak" then
						local var_2_3 = var_0_2[arg_2_3[4]]
						local var_2_4 = ""

						if type(var_2_3) == "table" then
							var_2_2 = var_2_2 .. "#C0xFFFFFF##F48#" .. var_2_3[math.random(1, #var_2_3)]
							var_2_4 = gLanguageCsv.chenggongjinji
						else
							var_2_2 = var_2_2 .. "#C0xFFFFFF##F48#" .. var_2_3
							var_2_4 = gLanguageCsv.yihanluobai
						end

						local var_2_5 = arg_2_3[3][2]
						local var_2_6 = arg_2_3[3][1][1]

						var_2_2 = var_2_2 .. "#C0x0BFA87##F48##L10#" .. var_2_5 .. string.format(gLanguageCsv.brackets, getServerArea(var_2_6, true)) .. "#C0xFFFFFF##F48#," .. var_2_4 .. string.format(gLanguageCsv.craftMessageGotScroe, arg_2_3[5][1])
					else
						local var_2_7 = math.min(arg_2_3[3], 8)
						local var_2_8 = ui.QUALITYCOLOR[var_2_7 - 1] .. "#F48#"

						var_2_2 = var_2_2 .. "#C0xFFFFFF##F48#" .. string.format(gLanguageCsv.isStreakWin, var_2_8, var_0_1[arg_2_3[3]]) .. ","
						var_2_2 = var_2_2 .. gLanguageCsv["streakwin" .. var_2_7]
					end

					rich.createWithWidth(var_2_2, 40, nil, 2013):anchorPoint(0, 0.5):xy(115, arg_2_1:height() / 2):addTo(arg_2_1, 2, "rich")
				end
			}
		}
	},
	textState = {
		varname = "textState"
	},
	textTime = {
		varname = "textTime",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("showTime"),
				method = function(arg_3_0)
					if not arg_3_0 then
						return
					end

					return time.getCutDown(arg_3_0).min_sec_clock
				end
			},
			{
				event = "visible",
				idler = bindHelper.self("round"),
				method = function(arg_4_0)
					return arg_4_0 ~= "halftime"
				end
			}
		}
	},
	["sessionPanel.textSession"] = {
		varname = "textSession",
		binds = {
			{
				event = "text",
				idler = bindHelper.self("textTitle")
			}
		}
	},
	timePanel = {
		binds = {
			event = "visible",
			idler = bindHelper.self("round"),
			method = function(arg_5_0)
				return arg_5_0 == "halftime"
			end
		}
	},
	["timePanel.textTimeNote"] = {},
	["timePanel.textTime"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("showTime"),
				method = function(arg_6_0)
					if not arg_6_0 then
						return
					end

					return time.getCutDown(arg_6_0).str
				end
			}
		}
	}
}

function var_0_5.onCreate(arg_7_0)
	arg_7_0.showMsg = idlers.newWithMap({})

	arg_7_0:enableSchedule()
	arg_7_0:initModel()
	idlereasy.when(arg_7_0.battleMessages, function(arg_8_0, arg_8_1)
		if itertools.size(arg_8_1) > 0 then
			local var_8_0 = {}

			for iter_8_0 = #arg_8_1, 1, -1 do
				local var_8_1 = arg_8_1[iter_8_0]

				if var_8_1[6] > 2 then
					local var_8_2 = {}

					var_8_2[1] = "streak"
					var_8_2[2] = var_8_1[4] == "win" and var_8_1[2] or var_8_1[3]
					var_8_2[3] = var_8_1[6]

					table.insert(var_8_0, var_8_2)
				end

				table.insert(var_8_0, var_8_1)
				arg_7_0.showMsg:update(var_8_0)
			end
		end
	end)
	idlereasy.when(arg_7_0.round, function(arg_9_0, arg_9_1)
		local var_9_0 = string.find(arg_9_1, "top") or string.find(arg_9_1, "final") or arg_9_1 == "closed"

		if var_9_0 then
			arg_7_0:unSchedule(1)

			return
		end

		local var_9_1, var_9_2, var_9_3 = var_0_4(arg_9_1)

		if arg_9_1 ~= "halftime" then
			arg_7_0.speList:size(cc.size(2280, 800))
			arg_7_0.sessionPanel:y(1050)

			local var_9_4 = gLanguageCsv.current .. ": " .. string.format(gLanguageCsv.perNumTitle, var_9_3) .. "  " .. gLanguageCsv.battleShowing

			arg_7_0.textState:text(var_9_4)
			adapt.oneLinePos(arg_7_0.textState, arg_7_0.textTime, cc.p(10, 0), "left")
		else
			arg_7_0.speList:size(cc.size(2280, 550))
			arg_7_0.sessionPanel:y(885)
			arg_7_0.textState:text(gLanguageCsv.current .. ": " .. gLanguageCsv.todayBattleOver)
		end

		local var_9_5 = gLanguageCsv.crossCraftTurnAndIndex

		arg_7_0.textTitle:set(string.format(var_9_5, var_9_2, var_9_3))
		arg_7_0:unSchedule(1)
		arg_7_0:schedule(function()
			if var_9_0 or var_9_1 <= 0 then
				return false
			end

			var_9_1 = var_9_1 - 1

			arg_7_0.showTime:set(var_9_1)
		end, 1, 0, 1)
	end)
end

function var_0_5.initModel(arg_11_0)
	local var_11_0 = gGameModel.cross_craft

	arg_11_0.round = var_11_0:getIdler("round")
	arg_11_0.battleMessages = var_11_0:getIdler("battle_messages")
	arg_11_0.showTime = idler.new(0)
	arg_11_0.textTitle = idler.new("")
	arg_11_0.textTitle1 = idler.new("")
end

return var_0_5
