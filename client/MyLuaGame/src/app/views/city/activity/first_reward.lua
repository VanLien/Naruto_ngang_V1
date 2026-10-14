local var_0_0 = game.YYHUODONG_TYPE_ENUM_TABLE
local var_0_1 = class("ActivityFirstReward", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_cjfl.json"
var_0_1.RESOURCE_BINDING = {
	list = "list",
	buyBtn = {
		varname = "buyBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuy")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0)
	local var_1_0 = csv.newbie_init[1]
	local var_1_1 = arg_1_0.list
	local var_1_2 = csvSize(var_1_0.newAward)
	local var_1_3 = arg_1_0.buyBtn
	local var_1_4 = var_1_3:get("label")
	local var_1_5 = 0

	if var_1_2 < 8 then
		var_1_5 = (8 - var_1_2) * 240 / 2
	end

	uiEasy.createItemsToList(arg_1_0, var_1_1, var_1_0.newAward, {
		margin = 20,
		padding = var_1_5
	})
	adapt.setTextScaleWithWidth(var_1_4, nil, var_1_3:width() - 80)
	Dialog.onCreate(arg_1_0, {
		blackType = 1,
		clickClose = false
	})
end

function var_0_1.onBuy(arg_2_0)
	gGameApp:requestServer("/game/role/create/award", function(arg_3_0)
		gGameUI:showGainDisplay(arg_3_0, {
			cb = function()
				arg_2_0:onClose()
			end
		})
	end)
end

return var_0_1
