local var_0_0 = require("app.views.city.pvp.craft.battle_messages"):getInstance()
local var_0_1 = 10
local var_0_2 = {
	preReady = 180,
	pre = 240,
	fight = 60,
	prepare = 600
}
local var_0_3 = {}

for iter_0_0 = 3, 10 do
	var_0_3[iter_0_0] = gLanguageCsv["symbolNumber" .. iter_0_0]
end

local function var_0_4(arg_1_0)
	local var_1_0 = 0

	if string.find(arg_1_0, "prepare") then
		var_1_0 = var_0_2.prepare
	elseif string.find(arg_1_0, "_lock") then
		if string.find(arg_1_0, "pre10") then
			var_1_0 = var_0_2.pre
		else
			var_1_0 = var_0_2.pre + var_0_2.preReady
		end
	elseif arg_1_0 == "pre1" then
		var_1_0 = var_0_2.pre + var_0_2.preReady
	else
		var_1_0 = var_0_2.preReady
	end

	return var_1_0 + 1
end

local var_0_5 = {
	fail = gLanguageCsv.budi,
	win = {
		gLanguageCsv.wansheng,
		gLanguageCsv.xiansheng,
		gLanguageCsv.zhansheng
	}
}
local var_0_6 = class("CraftMainScheduleView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "main_schedule.json"
var_0_6.RESOURCE_BINDING = {
	item = "item",
	["open.textNote2"] = "openTxt2",
	["open.textNote1"] = "openTxt1",
	["open.textNote3"] = "openTxt3",
	notOpen = {
		binds = {
			event = "visible",
			idler = bindHelper.self("notOpen")
		}
	},
	["notOpen.textTime"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("showTime"),
				method = function(arg_2_0)
					if not arg_2_0 then
						return
					end

					return time.getCutDown(arg_2_0).str
				end
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.WHITE
					}
				}
			}
		}
	},
	["notOpen.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	open = {
		binds = {
			event = "visible",
			idler = bindHelper.self("notOpen"),
			method = function(arg_3_0)
				return not arg_3_0
			end
		}
	},
	["open.textTitle"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("textTitle")
		}
	},
	["open.textTime"] = {
		varname = "textTime",
		binds = {
			event = "text",
			idler = bindHelper.self("showTime"),
			method = function(arg_4_0)
				if not arg_4_0 then
					return
				end

				return time.getCutDown(arg_4_0).str
			end
		}
	},
	["open.list"] = {
		varname = "speList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 17,
				data = bindHelper.self("showMsg"),
				item = bindHelper.self("item"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:removeChildByName("rich")

					local var_5_0 = "#C0x5C9970##F48#" .. arg_5_3[2][2]

					if arg_5_3[1] ~= "streak" then
						local var_5_1 = var_0_5[arg_5_3[4]]
						local var_5_2 = ""

						if type(var_5_1) == "table" then
							var_5_0 = var_5_0 .. "#C0x5B545B##F48#" .. var_5_1[math.random(1, #var_5_1)]
							var_5_2 = gLanguageCsv.chenggongjinji
						else
							var_5_0 = var_5_0 .. "#C0x5B545B##F48#" .. var_5_1
							var_5_2 = gLanguageCsv.yihanluobai
						end

						var_5_0 = var_5_0 .. "#C0x5C9970##F48#" .. arg_5_3[3][2] .. ",#C0x5B545B##F48#" .. var_5_2 .. string.format(gLanguageCsv.craftMessageGotScroe, arg_5_3[5][1])
					else
						local var_5_3 = math.min(arg_5_3[3], 8)
						local var_5_4 = ui.QUALITYCOLOR[var_5_3 - 1] .. "#F48#"

						var_5_0 = var_5_0 .. "#C0x5B545B##F48#" .. string.format(gLanguageCsv.isStreakWin, var_5_4, var_0_3[arg_5_3[3]]) .. ","
						var_5_0 = var_5_0 .. gLanguageCsv["streakwin" .. var_5_3]
					end

					rich.createWithWidth(var_5_0, 40, nil, 2013):anchorPoint(0, 0.5):xy(115, arg_5_1:height() / 2):addTo(arg_5_1, 2, "rich")
				end
			}
		}
	}
}

function var_0_6.onCreate(arg_6_0)
	gGameUI.topuiManager:createView("default", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "",
		title = "common/txt/txt_bt_renzhedasai.png"
	})
	arg_6_0:initModel()

	arg_6_0.showMsg = idlers.newWithMap(var_0_0.get())
	arg_6_0.notOpen = idler.new(false)
	arg_6_0.textTitle = idler.new("")

	arg_6_0.openTxt2:text("")

	arg_6_0.showTime = idler.new(0)

	idlereasy.when(arg_6_0.battleMessages, function(arg_7_0, arg_7_1)
		if itertools.size(arg_7_1) > 0 then
			local var_7_0 = {}

			for iter_7_0 = #arg_7_1, 1, -1 do
				local var_7_1 = arg_7_1[iter_7_0]

				if var_7_1[6] > 2 then
					local var_7_2 = {}

					var_7_2[1] = "streak"
					var_7_2[2] = var_7_1[4] == "win" and var_7_1[2] or var_7_1[3]
					var_7_2[3] = var_7_1[6]

					table.insert(var_7_0, var_7_2)
				end

				table.insert(var_7_0, var_7_1)
				arg_6_0.showMsg:update(var_7_0)
			end
		else
			arg_6_0.showMsg:update(var_0_0.get())
		end
	end)
	arg_6_0:enableSchedule()
	idlereasy.any({
		arg_6_0.round,
		arg_6_0.stateTime
	}, function(arg_8_0, arg_8_1, arg_8_2)
		if string.find(arg_8_1, "final") then
			arg_6_0:onClose()
			gGameUI:stackUI("city.pvp.craft.mainschedule_eight", nil, {
				full = true
			})

			return
		end

		local var_8_0 = var_0_4(arg_8_1)

		arg_6_0.delta = arg_8_2 + var_8_0 - time.getTime()

		local var_8_1 = arg_8_1 == "prepare"

		arg_6_0.notOpen:set(var_8_1)
		arg_6_0.speList:visible(not var_8_1)

		local var_8_2, var_8_3 = string.find(arg_8_1, "%d+")

		if var_8_2 then
			local var_8_4 = string.sub(arg_8_1, var_8_2, var_8_3)

			if not string.find(arg_8_1, "_lock") then
				var_8_4 = math.max(var_8_4 - 1, 1)
			end

			arg_6_0.textTitle:set(string.format(gLanguageCsv.perNum, var_8_4))
			arg_6_0.openTxt2:text(string.format(gLanguageCsv.perNumTitle, var_8_4))
			adapt.oneLinePos(arg_6_0.openTxt1, {
				arg_6_0.openTxt2,
				arg_6_0.openTxt3,
				arg_6_0.textTime
			}, {
				cc.p(10, 0),
				cc.p(10, 0),
				cc.p(10, 0)
			}, "left")
		end
	end)
	arg_6_0:schedule(function()
		if string.find(arg_6_0.round:read(), "final") then
			return false
		end

		arg_6_0.delta = arg_6_0.delta - 1

		if arg_6_0.delta < 0 then
			arg_6_0.delta = 1

			gGameApp:requestServer("/game/craft/battle/main")
		else
			arg_6_0.showTime:set(arg_6_0.delta)
		end
	end, 1, 0)
end

function var_0_6.initModel(arg_10_0)
	local var_10_0 = gGameModel.craft

	arg_10_0.round = var_10_0:getIdler("round")
	arg_10_0.perRound = arg_10_0.round:read()
	arg_10_0.stateTime = var_10_0:getIdler("time")
	arg_10_0.battleMessages = var_10_0:getIdler("battle_messages")
end

return var_0_6
