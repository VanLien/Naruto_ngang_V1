local var_0_0 = {
	bad = 3,
	good = 2,
	perfect = 1
}
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BeachIceGameOverView", var_0_1)

var_0_2.RESOURCE_FILENAME = "beach_ice_game_over.json"
var_0_2.RESOURCE_BINDING = {
	perfectScore = "perfectScore",
	badScore = "badScore",
	["bg.box"] = "box",
	bg = "bg",
	goodScore = "goodScore",
	text = "text",
	goodText = "goodText",
	perfectText = "perfectText",
	badText = "badText",
	btnSure = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_1_0, arg_1_1)
	arg_1_0.cb = arg_1_1.cb
	arg_1_0.awards = arg_1_1.award

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in orderCsvPairs(csv.yunying.shaved_ice_base) do
		if iter_1_1.huodongID == arg_1_1.huodongID then
			var_1_0 = iter_1_1.score

			break
		end
	end

	arg_1_0.perfectText:text(string.format(gLanguageCsv.perfectNumber, arg_1_1.perfectNum))
	arg_1_0.goodText:text(string.format(gLanguageCsv.goodPeople, arg_1_1.goodNum))
	arg_1_0.badText:text(string.format(gLanguageCsv.numberOfDefects, arg_1_1.badNum))
	arg_1_0.perfectScore:text(string.format(gLanguageCsv.bonusPoints, var_1_0[var_0_0.perfect] * arg_1_1.perfectNum))
	arg_1_0.goodScore:text(string.format(gLanguageCsv.bonusPoints, var_1_0[var_0_0.good] * arg_1_1.goodNum))
	arg_1_0.badScore:text(string.format(gLanguageCsv.bonusPoints, var_1_0[var_0_0.bad] * arg_1_1.badNum))

	local var_1_1 = var_1_0[var_0_0.perfect] * arg_1_1.perfectNum + var_1_0[var_0_0.good] * arg_1_1.goodNum + var_1_0[var_0_0.bad] * arg_1_1.badNum

	arg_1_0.text:text(string.format(gLanguageCsv.settlementPoints, arg_1_1.perfectNum + arg_1_1.goodNum + arg_1_1.badNum, var_1_1))

	local var_1_2 = widget.addAnimationByKey(arg_1_0.bg, "effect/jiedianjiangli.skel", "boxBg", "effect_loop", 10):xy(arg_1_0.box:x(), arg_1_0.box:y() - 50):anchorPoint(0.5, 0.5)

	bind.touch(arg_1_0, arg_1_0.box, {
		methods = {
			ended = function()
				arg_1_0:onClick()
			end
		}
	})
	uiEasy.addVibrateToNode(arg_1_0, arg_1_0.box, true)
end

function var_0_2.onClick(arg_3_0)
	gGameUI:showGainDisplay(arg_3_0.awards, {
		cb = function()
			if arg_3_0.cb then
				arg_3_0.cb()
			end

			var_0_1.onClose(arg_3_0)
		end
	})
end

return var_0_2
