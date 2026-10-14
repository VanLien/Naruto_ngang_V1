local var_0_0 = class("SettingRedeemCodeView", Dialog)

var_0_0.RESOURCE_FILENAME = "setting_redeem_code.json"
var_0_0.RESOURCE_BINDING = {
	textField = "textField",
	title = {
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
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnCancel = {
		varname = "btnCancel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCancelBtn")
			}
		}
	},
	btnComfirm = {
		varname = "btnComfirm",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onConfirmBtn")
			}
		}
	}
}

local function var_0_1(arg_1_0)
	return arg_1_0 >= 48 and arg_1_0 <= 57
end

local function var_0_2(arg_2_0)
	return arg_2_0 >= 65 and arg_2_0 <= 90
end

local function var_0_3(arg_3_0)
	return arg_3_0 >= 97 and arg_3_0 <= 122
end

local function var_0_4(arg_4_0)
	local var_4_0 = false
	local var_4_1 = 1

	while var_4_1 <= #arg_4_0 do
		local var_4_2 = string.byte(arg_4_0, var_4_1)
		local var_4_3 = string.utf8charlen(var_4_2)
		local var_4_4 = ""

		for iter_4_0 = 1, var_4_3 do
			var_4_4 = var_4_4 .. string.format("%x", string.byte(arg_4_0, var_4_1 + iter_4_0 - 1, var_4_1 + iter_4_0 - 1))
		end

		local var_4_5 = tonumber(var_4_4, 16)

		if not (var_0_1(var_4_5) or var_0_2(var_4_5) or var_0_3(var_4_5)) then
			return true, {
				var_4_1
			}
		end

		var_4_1 = var_4_1 + var_4_3
	end

	return false
end

local function var_0_5(arg_5_0)
	local var_5_0 = ""
	local var_5_1, var_5_2 = var_0_4(arg_5_0)

	if var_5_1 then
		table.sort(var_5_2, function(arg_6_0, arg_6_1)
			return arg_6_1 < arg_6_0
		end)

		for iter_5_0, iter_5_1 in ipairs(var_5_2) do
			local var_5_3 = string.utf8charlen(string.byte(arg_5_0, iter_5_1))

			arg_5_0 = string.sub(arg_5_0, 1, iter_5_1 - 1) .. var_5_0 .. string.sub(arg_5_0, iter_5_1 + var_5_3)
		end
	end

	return arg_5_0
end

function var_0_0.onCreate(arg_7_0)
	local var_7_0 = arg_7_0.textField

	var_7_0:addEventListener(function(arg_8_0, arg_8_1)
		if arg_8_1 == ccui.TextFiledEventType.insert_text then
			var_7_0:setText(var_0_5(var_7_0:text()))
		end
	end)
	arg_7_0.textField:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_7_0.textField:setTextColor(ui.NEWCOLORS.BROWN1)
	arg_7_0.textField:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	Dialog.onCreate(arg_7_0, {
		clickClose = false
	})
end

function var_0_0.onConfirmBtn(arg_9_0)
	local var_9_0 = arg_9_0.textField:getStringValue()

	gGameApp:requestServer("/game/gift", function(arg_10_0)
		gGameUI:showGainDisplay(arg_10_0.view.award)
	end, var_9_0)
end

function var_0_0.onCancelBtn(arg_11_0)
	arg_11_0:onClose()
end

return var_0_0
