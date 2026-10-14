local var_0_0 = {
	"activity/midautumn_draw/txt_yyqf_fs.png",
	"activity/midautumn_draw/txt_yyqf_zj.png",
	"activity/midautumn_draw/txt_yyqf_gc.png",
	"activity/midautumn_draw/txt_yyqf_rd.png",
	"activity/midautumn_draw/txt_yyqf_sy.png"
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("MidAutumnDrawMask", var_0_1)

var_0_2.RESOURCE_FILENAME = "activity_midautumn_maks.json"
var_0_2.RESOURCE_BINDING = {
	["mask.txtPlane"] = "txtPlane",
	["mask.spine.img"] = "img",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.cb = arg_1_2.cb

	rich.createByStr(string.format(gLanguageCsv.midAutumnGetTicket, gLanguageCsv["midAutumnTicket" .. arg_1_2.times - 1]), 40):xy(405, 124):anchorPoint(0.5, 0.5):addTo(arg_1_0.txtPlane, 5)
	rich.createByStr(string.format(gLanguageCsv.midAutumnGetTicketInfo, arg_1_2.num), 40):xy(405, 45):anchorPoint(0.5, 0.5):addTo(arg_1_0.txtPlane, 5)

	local var_1_0 = ccui.ImageView:create(var_0_0[arg_1_2.times - 1]):anchorPoint(0.5, 0.5):xy(210, 420):addTo(arg_1_0.img)

	arg_1_0.img:texture("activity/midautumn_draw/icon_yyqf_whd2.png")
end

function var_0_2.onClose(arg_2_0)
	arg_2_0:addCallbackOnExit(arg_2_0.cb)
	var_0_1.onClose(arg_2_0)
end

return var_0_2
