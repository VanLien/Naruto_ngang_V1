local var_0_0 = class("SettingView", Dialog)
local var_0_1 = {
	RADIO = 1,
	BTN = 2
}

var_0_0.BTN_DATA, var_0_0.BTN_TYPE = {
	[var_0_1.RADIO] = {
		resNormal = "common/icon/radio_normal.png",
		resSelected = "common/icon/radio_normal.png",
		resBtnImg = "common/icon/radio_selected.png"
	},
	[var_0_1.BTN] = {
		resNormal = "city/setting/btn_off.png",
		resSelected = "city/setting/btn_on.png",
		resBtnImg = "common/btn/btn_inner_close.png"
	}
}, var_0_1
var_0_0.RESOURCE_FILENAME = "setting.json"
var_0_0.RESOURCE_BINDING = {
	titleBg = "titleBg",
	bg = "bg",
	title = {
		varname = "title",
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
	normalBtn = {
		varname = "normalBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	},
	voiceBtn = {
		varname = "voiceBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0)
	arg_1_0.btns = {
		[arg_1_0.normalBtn] = {
			name = "city.setting.normal"
		},
		[arg_1_0.voiceBtn] = {
			name = "city.setting.voice"
		}
	}
	arg_1_0.curBtn = idler.new(arg_1_0.voiceBtn)

	arg_1_0.curBtn:addListener(function(arg_2_0, arg_2_1)
		for iter_2_0, iter_2_1 in pairs(arg_1_0.btns) do
			local var_2_0 = iter_2_0 == arg_2_0
			local var_2_1 = var_2_0 and ui.NEWCOLORS.ORANGE or ui.NEWCOLORS.WHITE
			local var_2_2 = var_2_0 and 0.5 or 0.5
			local var_2_3 = var_2_0 and 45 or 45

			iter_2_0:get("select"):visible(var_2_0)
			iter_2_0:get("text"):anchorPoint(var_2_2, 0.5):setFontSize(var_2_3)

			if var_2_0 then
				text.addEffect(iter_2_0:get("text"), {
					color = var_2_1,
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.WHITE
					}
				})
			else
				text.deleteAllEffect(iter_2_0:get("text"))
				text.addEffect(iter_2_0:get("text"), {
					color = var_2_1
				})
			end

			local var_2_4 = iter_2_0:size().height - 20

			adapt.setAutoMultiLine(iter_2_0:get("text"), nil, var_2_4)

			if not iter_2_1.view then
				iter_2_1.view = gGameUI:createView(iter_2_1.name, arg_1_0:getResourceNode()):init():x(display.uiOrigin.x)
			end

			iter_2_1.view:visible(var_2_0)
		end
	end)
	arg_1_0.curBtn:set(arg_1_0.normalBtn)
	Dialog.onCreate(arg_1_0)
end

function var_0_0.onBtnClick(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.curBtn:set(arg_3_2.target)
end

return var_0_0
