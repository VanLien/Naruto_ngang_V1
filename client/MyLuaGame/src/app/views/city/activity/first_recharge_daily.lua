local var_0_0 = {
	received = 2,
	noReach = 0,
	canReceive = 1
}
local var_0_1 = class("ActivityFirstRechargeDaily", Dialog)

var_0_1.RESOURCE_FILENAME = "activity_first_recharge_daily.json"
var_0_1.RESOURCE_BINDING = {
	list = "list",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	buyBtn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBuyClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	gGameModel.currday_dispatch:getIdlerOrigin("firstRechargeDaily"):modify(function(arg_2_0)
		arg_2_0[arg_1_1] = true
	end, true)

	arg_1_0.activityId = arg_1_1
	arg_1_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")

	local var_1_0 = csv.yunying.yyhuodong[arg_1_1].huodongID

	for iter_1_0, iter_1_1 in csvPairs(csv.yunying.generaltask) do
		if iter_1_1.huodongID == var_1_0 then
			arg_1_0.csvId = iter_1_0

			uiEasy.createItemsToList(arg_1_0, arg_1_0.list, iter_1_1.award, {
				onAfterBuild = function()
					arg_1_0.list:setItemAlignCenter()
				end
			})

			break
		end
	end

	arg_1_0.state = var_0_0.noReach

	idlereasy.when(arg_1_0.yyhuodongs, function(arg_4_0, arg_4_1)
		local var_4_0 = (arg_4_1[arg_1_1] or {}).stamps or {}
		local var_4_1 = {}

		for iter_4_0, iter_4_1 in csvPairs(csv.yunying.generaltask) do
			if iter_4_1.huodongID == var_1_0 then
				local var_4_2 = arg_1_0.btn
				local var_4_3 = var_4_2:get("label")

				if var_4_0[iter_4_0] == 1 then
					arg_1_0.state = var_0_0.canReceive

					var_4_3:text(gLanguageCsv.spaceReceive)
					cache.setShader(var_4_2, false, "normal")
					text.addEffect(var_4_3, {
						color = ui.NEWCOLORS.OUTLINE.BLACK1,
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					var_4_2:setTouchEnabled(true)
				elseif var_4_0[iter_4_0] == 0 then
					arg_1_0.state = var_0_0.received

					var_4_3:text(gLanguageCsv.received)
					text.deleteAllEffect(var_4_3)
					cache.setShader(var_4_2, false, "hsl_gray")
					var_4_2:setTouchEnabled(false)
				else
					arg_1_0.state = var_0_0.noReach

					var_4_3:text(gLanguageCsv.goToRecharge)
					cache.setShader(var_4_2, false, "normal")
					text.addEffect(var_4_3, {
						color = ui.NEWCOLORS.OUTLINE.BLACK1,
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
					var_4_2:setTouchEnabled(true)
				end
			end
		end
	end)
	Dialog.onCreate(arg_1_0, {
		blackType = 1
	})
end

function var_0_1.onBuyClick(arg_5_0)
	if arg_5_0.state == var_0_0.noReach then
		gGameUI:stackUI("city.recharge", nil, {
			full = true
		})
	elseif arg_5_0.state == var_0_0.canReceive then
		gGameApp:requestServer("/game/yy/award/get", function(arg_6_0)
			gGameUI:showGainDisplay(arg_6_0)
		end, arg_5_0.activityId, arg_5_0.csvId)
	end
end

return var_0_1
