local var_0_0 = class("UnionSendRedPackView", Dialog)

var_0_0.RESOURCE_FILENAME = "union_send_redpack.json"
var_0_0.RESOURCE_BINDING = {
	imgBg = "imgBg",
	["info1.imgBG"] = "info1Bg",
	["info2.imgBG"] = "info2Bg",
	textTitle = {
		binds = {
			event = "text",
			idler = bindHelper.self("title")
		}
	},
	["btnSend.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["info1.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("allNum")
		}
	},
	["info2.textNum"] = {
		varname = "showNum",
		binds = {
			event = "text",
			idler = bindHelper.self("hasNum")
		}
	},
	["info2.imgIcon"] = {
		varname = "imgIcon",
		binds = {
			event = "texture",
			idler = bindHelper.self("redPackType"),
			method = function(arg_1_0)
				return dataEasy.getIconResByKey(arg_1_0)
			end
		}
	},
	btnSend = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.idx = arg_2_1
	arg_2_0.info = arg_2_2
	arg_2_0.callBack = arg_2_3

	if (arg_2_2.showType or 1) == 2 then
		arg_2_0.imgBg:texture("city/union/redpack/img_hb2_h@.png")
		arg_2_0.info1Bg:texture("city/union/redpack/box_d_h.png")
		arg_2_0.info2Bg:texture("city/union/redpack/box_d_h.png")
	end

	arg_2_0.title = idler.new(arg_2_2.text)
	arg_2_0.allNum = idler.new(arg_2_2.total_count)
	arg_2_0.hasNum = idler.new(arg_2_2.total_val)
	arg_2_0.redPackType = idler.new(arg_2_2.key)

	performWithDelay(arg_2_0, function()
		adapt.oneLinePos(arg_2_0.showNum, arg_2_0.imgIcon, cc.p(5, 0), "left")
	end, 0.016666666666666666)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.onBtnClick(arg_4_0)
	gGameApp:requestServer("/game/union/redpacket/send", function(arg_5_0)
		arg_4_0.callBack(arg_5_0.view)
		arg_4_0:onClose()
	end, arg_4_0.info.serIdx - 1, arg_4_0.info.csv_id)
end

return var_0_0
