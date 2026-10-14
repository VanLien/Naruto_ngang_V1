local var_0_0 = class("TimeSpeederView", Dialog)

var_0_0.RESOURCE_FILENAME = "common_time_speeder.json"
var_0_0.RESOURCE_BINDING = {
	barPanel = "barPanel",
	slider = "barPanel.bar",
	combTipPos = "combTipPos",
	note = "needNumNote",
	textTip = "textTip",
	["barPanel.current"] = {
		varname = "currentText",
		binds = {
			event = "text",
			idler = bindHelper.self("current"),
			method = function(arg_1_0)
				return "x" .. arg_1_0
			end
		}
	},
	btnRule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	sureBtn = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEnableClick")
			}
		}
	},
	["barPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	},
	["barPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, -1)
			end)
		}
	},
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0, arg_4_1)
	arg_4_0:enableSchedule()

	arg_4_0.max = arg_4_0:getmax()
	arg_4_0.current = idler.new(cc.clampf(userDefault.getForeverLocalKey("timeSpeederViewSpeed", 1), 1, arg_4_0.max))
	arg_4_0.enabled = idler.new(gGameUI.timeSpeederManager.getTimeSpeedEnabled())

	arg_4_0.textTip:text(string.format(gLanguageCsv.speedText, arg_4_0.max))
	idlereasy.when(arg_4_0.current, function(arg_5_0, arg_5_1)
		cache.setShader(arg_4_0.subBtn, false, cc.clampf(arg_5_1, 1, arg_4_0.max) > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_4_0.addBtn, false, arg_5_1 < arg_4_0.max and "normal" or "hsl_gray")
		gGameUI.timeSpeederManager.setTimeSpeed(arg_5_1)
	end)
	idlereasy.when(arg_4_0.enabled, function(arg_6_0, arg_6_1)
		userDefault.setForeverLocalKey("timeSpeederViewEnabled", arg_6_1)
		gGameUI.timeSpeederManager.setTimeSpeedEnabled(arg_6_1)
		arg_4_0.sureBtn:loadTextureNormal(arg_6_1 and "city/setting/btn_bf.png" or "city/setting/btn_zt.png")
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.getmax(arg_7_0)
	local var_7_0 = gGameModel.role:read("vip_level")
	local var_7_1 = gGameModel.role:read("level")
	local var_7_2 = 0
	local var_7_3 = 0

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.time_speeder) do
		if iter_7_1.type == 1 and var_7_1 >= iter_7_1.arg then
			var_7_2 = math.max(var_7_2, iter_7_1.speedAdd)
		elseif iter_7_1.type == 2 and var_7_0 >= iter_7_1.arg then
			var_7_3 = math.max(var_7_3, iter_7_1.speedAdd)
		end
	end

	return var_7_2 + var_7_3 + 1
end

function var_0_0.onEnableClick(arg_8_0)
	arg_8_0.enabled:set(not arg_8_0.enabled:read())
end

function var_0_0.onChangeNum(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_2.name == "click" then
		arg_9_0:unscheduleUpdate()
		arg_9_0:onIncreaseNum(arg_9_3)
	else
		if arg_9_2.name == "began" then
			local var_9_0 = socket.gettime()

			arg_9_0:onIncreaseNum(arg_9_3)
			arg_9_0:scheduleUpdate(function()
				if socket.gettime() - var_9_0 > 0.1 then
					arg_9_0:onIncreaseNum(arg_9_3)

					var_9_0 = socket.gettime()
				end
			end)

			return
		end

		if arg_9_2.name == "ended" or arg_9_2.name == "cancelled" then
			arg_9_0:unscheduleUpdate()
		end
	end
end

function var_0_0.onIncreaseNum(arg_11_0, arg_11_1)
	arg_11_0.current:modify(function(arg_12_0)
		return true, cc.clampf(arg_12_0 + arg_11_1, 1, arg_11_0.max)
	end)
end

function var_0_0.onClose(arg_13_0)
	userDefault.setForeverLocalKey("timeSpeederViewSpeed", arg_13_0.current:read())
	Dialog.onClose(arg_13_0)
end

function var_0_0.onRule(arg_14_0)
	gGameUI:createView("common.rule", gGameUI.timeSpeederLayer):init(arg_14_0:createHandler("getRuleContext"))
end

function var_0_0.getRuleContext(arg_15_0)
	local var_15_0 = {
		adaptContext.noteText(166),
		adaptContext.noteText(135401, 135450)
	}

	for iter_15_0, iter_15_1 in orderCsvPairs(csv.time_speeder) do
		table.insert(var_15_0, string.format(gLanguageCsv["speederRule" .. iter_15_1.type], iter_15_1.arg, iter_15_1.speedAdd))
	end

	return var_15_0
end

return var_0_0
