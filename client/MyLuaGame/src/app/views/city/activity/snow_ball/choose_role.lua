local var_0_0 = class("SnowBallChooseRole", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "snow_ball_choose_role.json"
var_0_0.RESOURCE_BINDING = {
	panel2 = "panel2",
	panel1 = "panel1",
	panel3 = "panel3",
	btnChoose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChooseClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1)
	arg_1_0.activityId = arg_1_1
	arg_1_0.chooseCsvId = 0

	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "CHOOSE ELVES",
		title = gLanguageCsv.snowBallGameChooseSprite
	})

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in csvPairs(csv.yunying.snowball_element) do
		local var_1_1 = csv.yunying.yyhuodong[arg_1_1].huodongID

		if iter_1_1.belongs == 3 and iter_1_1.huodongID == var_1_1 then
			local var_1_2 = csvClone(iter_1_1)

			var_1_2.csvId = iter_1_0

			table.insert(var_1_0, var_1_2)
		end
	end

	for iter_1_2 = 1, 3 do
		local var_1_3 = arg_1_0["panel" .. iter_1_2]
		local var_1_4 = var_1_0[iter_1_2]

		bind.touch(arg_1_0, var_1_3, {
			methods = {
				ended = function()
					arg_1_0.chooseCsvId = var_1_4.csvId

					for iter_2_0 = 1, 3 do
						arg_1_0["panel" .. iter_2_0]:get("imgSel"):setVisible(iter_1_2 == iter_2_0)
					end
				end
			}
		})

		local var_1_5 = var_1_4.attr.cardName or var_1_4.attr.careName

		print(var_1_5)
		var_1_3:get("imageSprite"):texture(string.format("activity/snow_ball/%s.png", var_1_5))

		local var_1_6 = var_1_3:get("imgSm")
		local var_1_7 = {}

		for iter_1_3 = 1, var_1_4.attr.life - 1 do
			var_1_6:clone():addTo(var_1_6:getParent()):xy(var_1_6:x() + 49 * iter_1_3, var_1_6:y())
		end

		local var_1_8 = var_1_3:get("imgSd")

		for iter_1_4 = 1, var_1_4.attr.showSpeed - 1 do
			var_1_8:clone():addTo(var_1_8:getParent()):xy(var_1_8:x() + 49 * iter_1_4, var_1_8:y())
		end

		local var_1_9 = var_1_3:get("imgTx")

		for iter_1_5 = 1, var_1_4.attr.showWeight - 1 do
			var_1_9:clone():addTo(var_1_9:getParent()):xy(var_1_9:x() + 49 * iter_1_5, var_1_9:y())
		end
	end
end

function var_0_0.initModel(arg_3_0)
	return
end

function var_0_0.onChooseClick(arg_4_0)
	if arg_4_0.chooseCsvId == 0 then
		gGameUI:showTip(gLanguageCsv.chooseSpriteTips)

		return
	end

	local var_4_0 = arg_4_0.activityId
	local var_4_1 = arg_4_0.chooseCsvId

	arg_4_0:onClose()
	gGameUI:stackUI("city.activity.snow_ball.game", nil, nil, var_4_0, var_4_1)
end

return var_0_0
