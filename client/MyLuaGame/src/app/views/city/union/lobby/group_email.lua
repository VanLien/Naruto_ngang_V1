local var_0_0 = class("UnionGroupEmailView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_group_email.json"
var_0_0.RESOURCE_BINDING = {
	textNum = "textNum",
	textTimes = "textTimes",
	textInput = "textInput",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
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
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0:initModel()
	arg_1_0.textNum:text("0/50")
	arg_1_0.textTimes:text(math.max(2 - arg_1_1, 0) .. "/2")
	arg_1_0.textInput:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_1_0.textInput:setTextColor(ui.NEWCOLORS.BROWN1)
	blacklist:addListener(arg_1_0.textInput, "*", function(arg_2_0)
		local var_2_0, var_2_1 = string.utf8limit(arg_2_0, 50, true)

		arg_1_0.textNum:text(var_2_1 .. "/50")
		arg_1_0.textInput:text(var_2_0)
	end)
	Dialog.onCreate(arg_1_0)
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.dailyRecord = gGameModel.daily_record:getIdler("union_mail_send_count")
end

function var_0_0.onClickOK(arg_4_0)
	local var_4_0 = arg_4_0.textInput:text()

	if uiEasy.checkText(var_4_0) then
		gGameApp:requestServer("/game/union/send/mail", function(arg_5_0)
			gGameUI:showTip(gLanguageCsv.sendSuccessful)
			arg_4_0:onClose()
		end, var_4_0)
	end
end

return var_0_0
