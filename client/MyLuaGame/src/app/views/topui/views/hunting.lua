local var_0_0 = require("app.views.topui.config")
local var_0_1 = require("app.views.topui.base")
local var_0_2 = class("TopuiHuntingAreaView", var_0_1)

var_0_2.RESOURCE_FILENAME = "topui_hunting_area.json"
var_0_2.RESOURCE_BINDING = maptools.extend({
	var_0_0.title,
	var_0_0.gold,
	var_0_0.diamond,
	var_0_0.huntingArea
})

function var_0_2.onCreate(arg_1_0, arg_1_1)
	var_0_1.onCreate(arg_1_0, {
		"title"
	}, arg_1_1)
end

function var_0_2.onHuntingAreaClick(arg_2_0)
	if not dataEasy.isUnlock(gUnlockCsv.hunting) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.hunting))

		return
	end

	local var_2_0, var_2_1 = gGameUI:getTopStackUI()

	if var_2_1 ~= "city.adventure.hunting.view" and var_2_1 ~= "city.adventure.hunting.route" and not gGameUI:goBackInStackUI("city.adventure.hunting.view") then
		gGameApp:requestServer("/game/hunting/main", function(arg_3_0)
			gGameUI:stackUI("city.adventure.hunting.view", nil, {
				full = true
			})
		end)
	end
end

return var_0_2
