local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("PromptBoxView", Dialog)

var_0_1.RESOURCE_FILENAME = "common_prompt_box.json"
var_0_1.RESOURCE_BINDING = {
	selectPanel = "selectPanel",
	content = "contentLabel",
	title = {
		varname = "titleLabel",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOK = {
		varname = "btnOK",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOK")
			}
		}
	},
	btnCancel = {
		varname = "btnCancel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCancel")
			}
		}
	},
	btnOkCenter = {
		varname = "btnOkCenter",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickOK")
			}
		}
	},
	["btnOkCenter.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["selectPanel.btn"] = {
		varname = "selectTipBtn",
		binds = {
			event = "click",
			method = bindHelper.self("onSelectTipBtn")
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.params = arg_1_1

	local var_1_0 = arg_1_1.btnType or 1

	arg_1_0._okcb = arg_1_1.cb
	arg_1_0._closecb = arg_1_1.closeCb
	arg_1_0._cancelcb = arg_1_1.cancelCb
	arg_1_0.selectKey = arg_1_1.selectKey

	local var_1_1, var_1_2 = arg_1_0.btnOK:getPosition()

	if arg_1_1.title then
		arg_1_0.titleLabel:text(arg_1_1.title)
	end

	if arg_1_1.delayTime then
		arg_1_0.btnOK:setTouchEnabled(false)
		cache.setShader(arg_1_0.btnOK, false, "hsl_gray")

		local var_1_3 = arg_1_1.delayTime
		local var_1_4 = ccui.Text:create(var_1_3, "font/youmi.ttf", 65):alignCenter(arg_1_0.btnOK:size()):addTo(arg_1_0.btnOK, 10, "delayTime")

		arg_1_0:enableSchedule():schedule(function(arg_2_0)
			var_1_4:text(var_1_3)

			var_1_3 = var_1_3 - 1

			if var_1_3 < 0 then
				var_1_4:setVisible(false)
				cache.setShader(arg_1_0.btnOK, false, "normal")
				arg_1_0.btnOK:setTouchEnabled(true)
			end
		end, 1, 0, "delayTime")
	end

	if arg_1_1.closeTime then
		arg_1_0:enableSchedule():schedule(function(arg_3_0)
			if time.getTime() >= arg_1_1.closeTime then
				arg_1_0:enableSchedule():unScheduleAll()
				performWithDelay(arg_1_0, function()
					arg_1_0:onClose()
				end, 0.016666666666666666)

				return false
			end
		end, 1, 0, "closeTime")
	end

	local var_1_5 = arg_1_1.size or arg_1_0.contentLabel:size()

	if var_1_0 == 1 then
		arg_1_0.btnOK:hide()
		arg_1_0.btnCancel:hide()
		arg_1_0.btnOkCenter:show()

		var_1_5.height = var_1_5.height - 80

		arg_1_0.contentLabel:size(var_1_5)

		if arg_1_1.btnStr then
			arg_1_0.btnOkCenter:get("title"):text(arg_1_1.btnStr)
		end
	else
		arg_1_0.btnOK:show()
		arg_1_0.btnCancel:show()
		arg_1_0.btnOkCenter:hide()
	end

	if arg_1_0.selectKey then
		arg_1_0.selectPanel:show()

		local var_1_6 = arg_1_0:getSelectKey()

		if var_1_6 == "first" or var_1_6 == "false" then
			arg_1_0.selectTipBtn:get("checkBox"):setSelectedState(true)
			arg_1_0:setSelectKey("false")
		else
			arg_1_0.selectTipBtn:get("checkBox"):setSelectedState(false)
		end

		if arg_1_1.selectTip then
			arg_1_0.selectPanel:get("textTip"):text(arg_1_1.selectTip)
		end

		local var_1_7 = arg_1_0.selectPanel:get("btn.checkBox"):width()
		local var_1_8 = arg_1_0.selectPanel:get("textTip"):width()
		local var_1_9 = var_1_7 + var_1_8 + 20
		local var_1_10 = (arg_1_0.selectPanel:width() - var_1_9) / 2

		arg_1_0.selectPanel:get("btn"):x(var_1_10 + arg_1_0.selectPanel:get("btn"):width() / 2 - var_1_7 / 2)
		arg_1_0.selectPanel:get("textTip"):x(var_1_10 + var_1_7 + 20 + var_1_8 / 2)
	else
		arg_1_0.selectPanel:hide()
	end

	local var_1_11 = "center"
	local var_1_12, var_1_13 = beauty.textScroll({
		margin = 20,
		size = var_1_5,
		fontSize = arg_1_1.fontSize or 50,
		effect = {
			color = ui.NEWCOLORS.BROWN1
		},
		strs = arg_1_1.content or arg_1_1.strs,
		verticalSpace = arg_1_1.verticalSpace or 10,
		isRich = arg_1_1.isRich,
		align = arg_1_1.align or var_1_11
	})
	local var_1_14 = 0

	if var_1_13 < var_1_5.height then
		var_1_14 = -(var_1_5.height - var_1_13) / 2
	end

	var_1_12:addTo(arg_1_0.contentLabel, 10):y(var_1_14)

	local var_1_15 = arg_1_1.dialogParams or {}

	var_1_15.clearFast = var_1_15.clearFast or arg_1_1.clearFast

	Dialog.onCreate(arg_1_0, var_1_15)
end

function var_0_1.onClickOK(arg_5_0)
	arg_5_0:addCallbackOnExit(arg_5_0._okcb)
	Dialog.onClose(arg_5_0)

	return arg_5_0
end

function var_0_1.onCancel(arg_6_0)
	arg_6_0:addCallbackOnExit(arg_6_0._cancelcb)
	arg_6_0:onClose()
end

function var_0_1.onClose(arg_7_0)
	arg_7_0:addCallbackOnExit(arg_7_0._closecb, true)
	Dialog.onClose(arg_7_0)

	return arg_7_0
end

function var_0_1.getSelectKey(arg_8_0)
	if arg_8_0.params.selectType == 2 then
		return userDefault.getCurrDayKey(arg_8_0.selectKey, "first")
	else
		return userDefault.getForeverLocalKey(arg_8_0.selectKey, "first")
	end
end

function var_0_1.setSelectKey(arg_9_0, arg_9_1)
	if arg_9_0.params.selectType == 2 then
		userDefault.setCurrDayKey(arg_9_0.selectKey, arg_9_1)
	else
		userDefault.setForeverLocalKey(arg_9_0.selectKey, arg_9_1)
	end
end

function var_0_1.onSelectTipBtn(arg_10_0)
	local var_10_0 = arg_10_0:getSelectKey()

	if var_10_0 == "first" or var_10_0 == "true" then
		arg_10_0.selectTipBtn:get("checkBox"):setSelectedState(true)
		arg_10_0:setSelectKey("false")
	else
		arg_10_0.selectTipBtn:get("checkBox"):setSelectedState(false)
		arg_10_0:setSelectKey("true")
	end
end

return var_0_1
