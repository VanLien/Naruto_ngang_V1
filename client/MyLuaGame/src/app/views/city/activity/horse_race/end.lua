local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("HorseRaceEnd", var_0_0)

var_0_1.RESOURCE_FILENAME = "horse_race_end.json"
var_0_1.RESOURCE_BINDING = {
	two = "two",
	four = "four",
	three = "three",
	["replay.text"] = "text",
	bg1 = "bg1",
	one = "one",
	replay = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReplay")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "HORSE RACE",
		title = gLanguageCsv.horseRace
	})

	arg_1_0.activityId = arg_1_1
	arg_1_0.index = arg_1_2[2]
	arg_1_0.cb = arg_1_3
	arg_1_0.data = arg_1_2[1]

	local var_1_0 = 1

	arg_1_0:initModel()

	local var_1_1 = {}
	local var_1_2 = {
		"one",
		"two",
		"three",
		"four"
	}

	for iter_1_0, iter_1_1 in pairs(var_1_2) do
		local var_1_3 = var_1_2[arg_1_0.data[iter_1_0].result] or var_1_2[iter_1_0]
		local var_1_4 = csv.cross.horse_race.horse_race_card[arg_1_0.data[iter_1_0].csv_id]

		text.addEffect(arg_1_0.text, {
			outline = {
				size = 3,
				color = cc.c4b(218, 112, 21, 255)
			}
		})
		widget.addAnimation(arg_1_0[var_1_3]:get("player"), csv.unit[var_1_4.unitID].unitRes, "standby_loop", 5):alignCenter(cc.size(arg_1_0[var_1_3]:get("player"):size().width, arg_1_0[var_1_3]:get("player"):size().height - 300)):anchorPoint(cc.p(0.5, 0.5)):setScale(2):setSkin(csv.unit[var_1_4.unitID].skin)

		if arg_1_0.index and arg_1_0.index > 0 then
			arg_1_0[iter_1_1]:get("bet"):setVisible(iter_1_0 == arg_1_0.data[arg_1_0.index].result)
		else
			arg_1_0[iter_1_1]:get("bet"):setVisible(false)
		end

		if arg_1_0.data[iter_1_0].result == 1 then
			var_1_0 = iter_1_0
		end
	end

	if arg_1_0.index and arg_1_0.index > 0 then
		local var_1_5 = csv.cross.horse_race.horse_race_card[arg_1_0.data[arg_1_0.index].csv_id]
		local var_1_6 = rich.createByStr(string.format(gLanguageCsv.horseRaceHasBet, csv.unit[var_1_5.unitID].name, arg_1_0.data[arg_1_0.index].result), 50):size(700, 300):xy(500, 800):addTo(arg_1_0.bg1, 10):ignoreContentAdaptWithSize(false)
	else
		local var_1_7 = csv.cross.horse_race.horse_race_card[arg_1_0.data[var_1_0].csv_id]
		local var_1_8 = rich.createByStr(string.format(gLanguageCsv.horseRaceNotBet, csv.unit[var_1_7.unitID].name), 50):size(700, 300):xy(500, 800):addTo(arg_1_0.bg1, 10):ignoreContentAdaptWithSize(false)
	end
end

function var_0_1.initModel(arg_2_0)
	arg_2_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
end

function var_0_1.onReplay(arg_3_0)
	local var_3_0 = arg_3_0.data
	local var_3_1 = arg_3_0.activityId
	local var_3_2 = arg_3_0.index

	var_0_0.onClose(arg_3_0)
	gGameUI:stackUI("city.activity.horse_race.match", nil, nil, var_3_1, {
		var_3_0,
		var_3_2
	})
end

function var_0_1.onClose(arg_4_0)
	var_0_0.onClose(arg_4_0)
	gGameUI:goBackInStackUI("city.activity.horse_race.view")
end

return var_0_1
