local var_0_0 = require("app.views.city.activity.anniversary")
local var_0_1 = class("ActivitySummerOfferingView", var_0_0)
local var_0_2 = game.YYHUODONG_TYPE_ENUM_TABLE

var_0_1.RESOURCE_FILENAME = "activity_summer_offering.json"
var_0_1.RESOURCE_BINDING = {
	beachIce = "shavedIce",
	shop = "shop",
	volleyball = "volleyball",
	bg = "bg",
	summerChallenge = "summerChallenge",
	countdown = {
		varname = "countdown",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = cc.c4b(91, 84, 91, 255)
					}
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0:createTitle()
	arg_1_0:enableSchedule()

	arg_1_0.isRunning = false

	arg_1_0:createTable()

	for iter_1_0, iter_1_1 in ipairs(arg_1_1) do
		local var_1_0 = csv.yunying.yyhuodong[iter_1_1.id]

		if arg_1_0.tb[var_1_0.type] then
			arg_1_0.tb[var_1_0.type].data = iter_1_1
		end
	end

	arg_1_0:refreshPanel()
end

function var_0_1.createTitle(arg_2_0)
	local var_2_0 = gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "SUMMER",
		title = gLanguageCsv.summerActivity
	})
end

function var_0_1.bindClick(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	bind.touch(arg_3_0, arg_3_1, {
		methods = {
			ended = function()
				if arg_3_2 then
					if arg_3_3 then
						gGameUI:showTip(gLanguageCsv.activityOver)
					else
						arg_3_0:onItemClick(arg_3_2)
					end
				else
					gGameUI:showTip(gLanguageCsv.huodongNoOpen)
				end
			end
		}
	})
end

function var_0_1.createTable(arg_5_0)
	local var_5_0 = matchLanguage({
		"kr"
	}) and cc.p(295, 95) or cc.p(280, 95)

	arg_5_0.tb = {
		[var_0_2.shavedIce] = {
			node = arg_5_0.shavedIce,
			redHintPos = cc.p(250, 95)
		},
		[var_0_2.summerChallenge] = {
			node = arg_5_0.summerChallenge,
			redHintPos = var_5_0
		},
		[var_0_2.volleyball] = {
			node = arg_5_0.volleyball,
			redHintPos = cc.p(255, 98)
		},
		[var_0_2.itemBuy2] = {
			node = arg_5_0.shop,
			redHintPos = cc.p(280, 100)
		}
	}
end

return var_0_1
