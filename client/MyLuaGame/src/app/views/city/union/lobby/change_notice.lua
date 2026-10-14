local var_0_0 = class("UnionChangeNoticeView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_change_notice.json"
var_0_0.RESOURCE_BINDING = {
	textNum = "textNum",
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

function var_0_0.onCreate(arg_1_0)
	arg_1_0:initModel()
	arg_1_0:initTxt(arg_1_0.intro:read())
	arg_1_0.textInput:setPlaceHolderColor(ui.NEWCOLORS.GRAY3)
	arg_1_0.textInput:setTextColor(ui.NEWCOLORS.BROWN1)
	blacklist:addListener(arg_1_0.textInput, "*", function(arg_2_0)
		arg_1_0:initTxt(arg_2_0)
	end)
	Dialog.onCreate(arg_1_0)
end

function var_0_0.initModel(arg_3_0)
	arg_3_0.intro = gGameModel.union:getIdler("intro")
end

function var_0_0.initTxt(arg_4_0, arg_4_1)
	local var_4_0, var_4_1 = string.utf8limit(arg_4_1, 50, true)

	arg_4_0.textNum:text(var_4_1 .. "/50")
	arg_4_0.textInput:text(var_4_0)
end

function var_0_0.onClickOK(arg_5_0)
	local var_5_0 = arg_5_0.textInput:text()

	if var_5_0 == arg_5_0.intro:read() then
		gGameUI:showTip(gLanguageCsv.noChangeIntro)

		return
	end

	local var_5_1 = LOCAL_LANGUAGE == "en"

	if uiEasy.checkText(var_5_0, nil, var_5_1) then
		gGameApp:requestServer("/game/union/intro/modify", function(arg_6_0)
			gGameUI:showTip(gLanguageCsv.modifySuccessful)
			arg_5_0:onClose()
		end, var_5_0)
	end
end

return var_0_0
