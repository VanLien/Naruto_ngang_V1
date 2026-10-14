local var_0_0 = {
	"lv",
	"lan",
	"zi",
	"cheng"
}
local var_0_1 = {
	"#C0x91FFB1#",
	"#C0x70A1E3#",
	"#C0xB187FE#",
	"#C0xECB72A#"
}
local var_0_2 = csv.mimicry.boss
local var_0_3 = class("MimicryBuffShowView", Dialog)

var_0_3.RESOURCE_FILENAME = "mimicry_buff_show.json"
var_0_3.RESOURCE_BINDING = {
	item = "item",
	anima = "anima",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 60,
				asyncPreload = 5,
				data = bindHelper.self("showBuffData"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = string.format("#F44#%s%s#C0xFFFCED#   %s%s", var_0_1[arg_1_3.quality], arg_1_3.name, gLanguageCsv.buffEffect, arg_1_3.desc)

					beauty.textScroll({
						isRich = true,
						list = arg_1_1:get("list"),
						strs = var_1_0
					})
					arg_1_1:get("icon"):texture(arg_1_3.icon1)
					arg_1_1:get("iconBg"):texture(string.format("city/adventure/mimicry/icon_ntdz_%s.png", var_0_0[arg_1_3.quality]))
				end,
				onAfterBuild = function(arg_2_0)
					local var_2_0 = arg_2_0.getInnerContainerSize(arg_2_0)
					local var_2_1 = arg_2_0.getContentSize(arg_2_0)

					if var_2_0.height <= var_2_1.height then
						arg_2_0.setTouchEnabled(arg_2_0, false)
					end
				end
			}
		}
	},
	["topPanel.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(215, 18, 65, 255)
				}
			}
		}
	}
}

function var_0_3.onCreate(arg_3_0, arg_3_1)
	arg_3_0.showBuffData = arg_3_1.showBuffData or {}
	arg_3_0.cb = arg_3_1.cb

	widget.addAnimation(arg_3_0.anima, "mimicry/qiangdilaixi.skel", "gaonengyujing_loop", 10):xy(arg_3_0.anima:size().width / 2, arg_3_0.anima:size().height / 2):scale(1.75)
	Dialog.onCreate(arg_3_0)
end

function var_0_3.onClose(arg_4_0)
	if arg_4_0.cb then
		arg_4_0.addCallbackOnExit(arg_4_0, arg_4_0.cb)
	end

	Dialog.onClose(arg_4_0)
end

return var_0_3
