local var_0_0 = class("UnionFightCloseView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "union_fight_closed_view.json"
var_0_0.RESOURCE_BINDING = {
	note = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = cc.c4b(82, 48, 28, 255)
				}
			}
		}
	},
	text = {
		varname = "text",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 6,
					color = cc.c4b(82, 48, 28, 255)
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.refreshHandle = arg_1_1

	arg_1_0:initSpine()
	arg_1_0:startTimeLabel()
end

function var_0_0.initSpine(arg_2_0)
	return
end

function var_0_0.startTimeLabel(arg_3_0)
	local var_3_0 = time.getNowDate()
	local var_3_1 = time.getTimestamp(var_3_0)
	local var_3_2 = time.getWeekStrInClock()
	local var_3_3, var_3_4 = dataEasy.getTimeStrByKey("unionFight", "signUpStart", true)
	local var_3_5 = time.getNumTimestamp(var_3_2, var_3_3, var_3_4) + 86400

	if var_3_5 < var_3_1 then
		var_3_5 = var_3_5 + 604800
	end

	local var_3_6 = var_3_5 - var_3_1

	if var_3_6 < 0 then
		var_3_6 = var_3_6 + 86400
	end

	local var_3_7 = 3031825
	local var_3_8 = 1

	arg_3_0:enableSchedule():unSchedule(var_3_7)
	arg_3_0:enableSchedule():schedule(function(arg_4_0)
		local var_4_0 = time.getCutDown(var_3_6)

		arg_3_0.text:text(var_4_0.str)

		if var_3_6 <= 0 then
			arg_3_0.refreshHandle()

			var_3_6 = 2
		end

		var_3_6 = var_3_6 - 1
	end, var_3_8, 0, var_3_7)
end

return var_0_0
