local var_0_0 = {
	ONE = 2,
	ONE_AND_TEN = 1,
	SAVE_AND_CANCEL = 3,
	SAVE = 4
}
local var_0_1 = {
	TEN = 2,
	ONE = 1
}
local var_0_2 = class("CardCustomEffortvalueView", Dialog)

var_0_2.RESOURCE_FILENAME = "card_effortvalue_custom.json"
var_0_2.RESOURCE_BINDING = {
	costText = "costText",
	costNum = "costNum",
	num = "num",
	slider = "slider",
	icon = "icon",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	sliderNum = {
		varname = "sliderNumber",
		binds = {
			event = "text",
			idler = bindHelper.self("sliderNum")
		}
	},
	btnSub = {
		varname = "subBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_1_0, arg_1_1, arg_1_2)
				return arg_1_0:onChangeNum(arg_1_1, arg_1_2, -1)
			end)
		}
	},
	btnAdd = {
		varname = "addBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_2_0, arg_2_1, arg_2_2)
				return arg_2_0:onChangeNum(arg_2_1, arg_2_2, 1)
			end)
		}
	},
	["sureBtn.txt"] = {
		varname = "sureBtnTxt",
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
	title = {
		varname = "costTxt",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	sureBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0.dbid = arg_3_4
	arg_3_0.idx = arg_3_1
	arg_3_0.cb = arg_3_5
	arg_3_0.times = arg_3_3

	arg_3_0:initModel()
	arg_3_0:enableSchedule()
	arg_3_0.icon:texture(dataEasy.getCfgByKey(arg_3_2).icon)
	arg_3_0.costNum:text(3 * (3 - arg_3_1))
	arg_3_0.costTxt:text(string.format(gLanguageCsv.customEffortTimes, arg_3_0.selectNum:read()))
	arg_3_0.slider:setPercent(0)
	adapt.oneLinePos(arg_3_0.costText, {
		arg_3_0.costNum,
		arg_3_0.icon
	}, {
		cc.p(10, 0),
		cc.p(10, 0)
	})
	idlereasy.when(arg_3_0.selectNum, function(arg_4_0, arg_4_1)
		arg_4_1 = arg_4_1 < arg_3_3 and arg_4_1 or arg_3_3

		arg_3_0.sliderNum:set(arg_3_0.selectNum:read() .. "/" .. arg_3_0.times)

		if not arg_3_0.slider:isHighlighted() then
			local var_4_0 = math.ceil(arg_4_1 / arg_3_3 * 100)

			arg_3_0.slider:setPercent(var_4_0)
		end

		cache.setShader(arg_3_0.addBtn, false, arg_4_1 >= arg_3_3 and "hsl_gray" or "normal")
		cache.setShader(arg_3_0.subBtn, false, arg_4_1 <= 1 and "hsl_gray" or "normal")
		arg_3_0.addBtn:setTouchEnabled(arg_4_1 < arg_3_3)
		arg_3_0.subBtn:setTouchEnabled(arg_4_1 > 1)
		arg_3_0.sliderNum:set(arg_3_0.selectNum:read() .. "/" .. arg_3_0.times)
		arg_3_0.costNum:text(3 * (3 - arg_3_1) * arg_3_0.selectNum:read())
		arg_3_0.costTxt:text(string.format(gLanguageCsv.customEffortTimes, arg_3_0.selectNum:read()))
		arg_3_0.sureBtnTxt:text(string.format(gLanguageCsv.customEffortTimes, arg_3_0.selectNum:read()))
		adapt.oneLinePos(arg_3_0.costText, {
			arg_3_0.costNum,
			arg_3_0.icon
		}, {
			cc.p(10, 0),
			cc.p(10, 0)
		})

		if arg_4_1 == 1 then
			arg_3_0:unScheduleAll()
		end

		adapt.oneLinePos(arg_3_0.num, arg_3_0.sliderNumber, cc.p(-10, 0))
	end)
	arg_3_0.slider:addEventListener(function(arg_5_0, arg_5_1)
		arg_3_0:unScheduleAll()

		local var_5_0 = arg_5_0:getPercent()
		local var_5_1 = arg_3_3
		local var_5_2 = math.ceil(var_5_1 / 100 * var_5_0)
		local var_5_3 = math.max(math.min(var_5_1, var_5_2), 1)

		arg_3_0.selectNum:set(var_5_3)
	end)
	Dialog.onCreate(arg_3_0)
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.selectNum = idler.new(1)
	arg_6_0.sliderNum = idler.new(arg_6_0.selectNum:read() .. "/" .. arg_6_0.times)
end

function var_0_2.onClose(arg_7_0)
	Dialog.onClose(arg_7_0)
end

function var_0_2.onChangeNum(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_2.name == "click" then
		arg_8_0:unScheduleAll()
		arg_8_0:onIncreaseNum(arg_8_3)
	elseif arg_8_2.name == "began" then
		arg_8_0:schedule(function()
			arg_8_0:onIncreaseNum(arg_8_3)
		end, 0.05, 0, 100)
	elseif arg_8_2.name == "ended" or arg_8_2.name == "cancelled" then
		arg_8_0:unScheduleAll()
	end
end

function var_0_2.onIncreaseNum(arg_10_0, arg_10_1)
	arg_10_0.selectNum:modify(function(arg_11_0)
		return true, cc.clampf(arg_11_0 + arg_10_1, 0, arg_10_0.times)
	end)
end

function var_0_2.onSureClick(arg_12_0)
	if arg_12_0.selectNum:read() == 0 then
		gGameUI:showTip(gLanguageCsv.pleaseSelectMaterials)

		return
	end

	gGameApp:requestServer("/game/card/effort/train", function(arg_13_0)
		if arg_12_0.cb then
			arg_12_0.cb(arg_13_0)
		end

		arg_12_0:onClose()
	end, arg_12_0.dbid, arg_12_0.idx, arg_12_0.selectNum:read())
end

return var_0_2
