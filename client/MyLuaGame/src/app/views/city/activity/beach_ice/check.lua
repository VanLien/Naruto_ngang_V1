local var_0_0 = {
	"activity/beach_ice/logo_wm.png",
	"activity/beach_ice/logo_lh.png",
	"activity/beach_ice/logo_xc.png",
	"activity/beach_ice/logo_xc.png",
	"activity/beach_ice/logo_xc.png"
}
local var_0_1 = {
	gLanguageCsv.perfectService,
	gLanguageCsv.goodService,
	gLanguageCsv.defectiveService,
	gLanguageCsv.defectiveService,
	gLanguageCsv.defectiveService
}
local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("BeachIceCheckView", var_0_2)

var_0_3.RESOURCE_FILENAME = "beach_ice_check.json"
var_0_3.RESOURCE_BINDING = {
	score = "score",
	bg = "bg",
	item = "item",
	title = "title",
	cardIcon = "cardIcon",
	resImg = "resImg",
	demandList = {
		varname = "demandList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("demand"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = csv.yunying.shaved_ice_items

					arg_1_1:get("icon"):texture(var_1_0[arg_1_3].icon1)
				end,
				onAfterBuild = function(arg_2_0)
					arg_2_0:setItemAlignCenter()
				end
			}
		}
	},
	mineList = {
		varname = "mineList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("mineChoose"),
				item = bindHelper.self("item"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = csv.yunying.shaved_ice_items

					arg_3_1:get("icon"):texture(var_3_0[arg_3_3].icon1)
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0:setItemAlignCenter()
				end
			}
		}
	}
}

function var_0_3.onCreate(arg_5_0, arg_5_1)
	arg_5_0.cb = arg_5_1.cb

	arg_5_0.cardIcon:texture(csv.unit[arg_5_1.unitID].iconSimple)
	arg_5_0.cardIcon:scale(2)

	arg_5_0.mineChoose = idlers.newWithMap(arg_5_1.mineChoose)
	arg_5_0.demand = idlers.newWithMap(arg_5_1.demand)

	arg_5_0.resImg:texture(var_0_0[arg_5_1.type])
	arg_5_0.title:text(var_0_1[arg_5_1.type])
	arg_5_0.score:text(string.format(gLanguageCsv.bonusPoints, arg_5_1.score))
	adapt.oneLinePos(arg_5_0.cardIcon, arg_5_0.title, cc.p(10, 0))
	performWithDelay(arg_5_0, function()
		arg_5_0:onClose()
	end, 2)
end

function var_0_3.onClose(arg_7_0)
	if arg_7_0.cb then
		arg_7_0:addCallbackOnExit(arg_7_0.cb)
	end

	var_0_2.onClose(arg_7_0)

	arg_7_0 = nil
end

return var_0_3
