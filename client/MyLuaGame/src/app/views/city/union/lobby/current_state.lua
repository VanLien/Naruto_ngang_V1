local var_0_0 = class("UnionCurrentStateView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_current_state.json"
var_0_0.RESOURCE_BINDING = {
	["needRequest.checkBox"] = "needRequestCheckBox",
	["limitLevelPanel.btnSub"] = "btnSub",
	["refuse.checkBox"] = "refuseCheckBox",
	["inputPanel.textInput"] = "textInput",
	["limitLevelPanel.txt"] = "limitTxt",
	["free.checkBox"] = "freeCheckBox",
	["limitLevelPanel.btnAdd"] = "btnAdd",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	textTitle = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
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
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	free = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFree")
			}
		}
	},
	needRequest = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onNeedRequest")
			}
		}
	},
	refuse = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefuse")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0:initModel()
	arg_1_0:enableSchedule()

	arg_1_0.selectJoinType = idler.new(arg_1_0.joinType:read())

	arg_1_0.textInput:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_1_0.textInput:setTextColor(ui.NEWCOLORS.BROWN2)

	local var_1_0 = string.len(arg_1_0.joinDesc:read()) > 0 and arg_1_0.joinDesc:read() or gLanguageCsv.unionJoinupDesc

	arg_1_0.textInput:text(var_1_0)
	blacklist:addListener(arg_1_0.textInput)

	arg_1_0.limitNum = idler.new(arg_1_0.joinLevel:read())
	arg_1_0.maxLimitNum = table.length(gRoleLevelCsv)

	idlereasy.any({
		arg_1_0.limitNum,
		arg_1_0.selectJoinType
	}, function(arg_2_0, arg_2_1, arg_2_2)
		arg_1_0.freeCheckBox:setSelectedState(arg_2_2 == 1)
		arg_1_0.needRequestCheckBox:setSelectedState(arg_2_2 == 0)
		arg_1_0.refuseCheckBox:setSelectedState(arg_2_2 == 2)
		arg_1_0.limitTxt:text(arg_2_1 == 0 and gLanguageCsv.noLimitNoBrackets or arg_2_1)

		local var_2_0 = arg_2_1 == 0 and ui.NEWCOLORS.WHITE2 or ui.NEWCOLORS.WHITE2

		text.addEffect(arg_1_0.limitTxt, {
			color = var_2_0
		})

		local var_2_1 = arg_2_1 > 0 and arg_2_2 ~= 2
		local var_2_2 = arg_2_1 < arg_1_0.maxLimitNum and arg_2_2 ~= 2

		cache.setShader(arg_1_0.btnSub, false, var_2_1 and "normal" or "hsl_gray")
		arg_1_0.btnSub:setTouchEnabled(var_2_1)
		cache.setShader(arg_1_0.btnAdd, false, var_2_2 and "normal" or "hsl_gray")
		arg_1_0.btnAdd:setTouchEnabled(var_2_2)
	end)
	bind.touch(arg_1_0, arg_1_0.btnSub, {
		longtouch = true,
		method = function(arg_3_0, arg_3_1, arg_3_2)
			return arg_1_0:onLevelChangeTouch(arg_3_2, -1)
		end
	})
	bind.touch(arg_1_0, arg_1_0.btnAdd, {
		longtouch = true,
		method = function(arg_4_0, arg_4_1, arg_4_2)
			return arg_1_0:onLevelChangeTouch(arg_4_2, 1)
		end
	})
	Dialog.onCreate(arg_1_0)
end

function var_0_0.initModel(arg_5_0)
	local var_5_0 = gGameModel.union

	arg_5_0.joinDesc = var_5_0:getIdler("join_desc")
	arg_5_0.joinLevel = var_5_0:getIdler("join_level")
	arg_5_0.joinType = var_5_0:getIdler("join_type")
end

function var_0_0.onClickOK(arg_6_0)
	local var_6_0 = arg_6_0.textInput:text()

	if uiEasy.checkText(var_6_0) then
		gGameApp:requestServer("/game/union/join/modify", function(arg_7_0)
			gGameUI:showTip(gLanguageCsv.modifySuccessful)
			arg_6_0:onClose()
		end, arg_6_0.selectJoinType, arg_6_0.limitNum, var_6_0)
	end
end

function var_0_0.onFree(arg_8_0)
	arg_8_0.selectJoinType:set(1)
end

function var_0_0.onNeedRequest(arg_9_0)
	arg_9_0.selectJoinType:set(0)
end

function var_0_0.onRefuse(arg_10_0)
	arg_10_0.selectJoinType:set(2)
end

function var_0_0.onLevelChange(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.limitNum:read()

	arg_11_0.limitNum:set(cc.clampf(var_11_0 + arg_11_1, 0, arg_11_0.maxLimitNum))
end

function var_0_0.onLevelChangeTouch(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1.name == "click" then
		arg_12_0:unScheduleAll()
		arg_12_0:onLevelChange(arg_12_2)
	elseif arg_12_1.name == "began" then
		arg_12_0:schedule(function(arg_13_0)
			arg_12_0:onLevelChange(arg_12_2)
		end, 0.05, 0, 1)
	elseif arg_12_1.name == "ended" or arg_12_1.name == "cancelled" then
		arg_12_0:unScheduleAll()
	end
end

return var_0_0
