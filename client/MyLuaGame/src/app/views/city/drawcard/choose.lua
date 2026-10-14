local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardChoose1In2", var_0_0)

var_0_1.RESOURCE_FILENAME = "drawcard_2choose1.json"
var_0_1.RESOURCE_BINDING = {
	["left.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickLeft")
			}
		}
	},
	["left.card"] = {
		varname = "card1",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickLeft")
			}
		}
	},
	["left.btn.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					color = ui.NEWCOLORS.OUTLINE.BROWN2,
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["right.btn.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					color = ui.NEWCOLORS.OUTLINE.BROWN2,
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["right.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickRight")
			}
		}
	},
	["right.card"] = {
		varname = "card2",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickRight")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.id = arg_1_1
	arg_1_0.cb = arg_1_2

	local var_1_0 = dataEasy.getCfgByKey(arg_1_1)

	arg_1_0.cardId = {}

	for iter_1_0 = 1, 2 do
		local var_1_1 = "choose" .. iter_1_0
		local var_1_2 = var_1_0.specialArgsMap[var_1_1]

		assertInWindows(var_1_2, "道具2选1必须要有choose1和choose2, error id(%s)", arg_1_1)

		local var_1_3 = csv.cards[var_1_2.card.id]
		local var_1_4 = csv.unit[var_1_3.unitID]

		arg_1_0.cardId[iter_1_0] = var_1_2.card.id

		widget.addAnimationByKey(arg_1_0["card" .. iter_1_0], var_1_4.unitRes, "hero", "standby_loop", 1000):scale(var_1_4.scale):setSkin(var_1_4.skin)
	end
end

function var_0_1.clickLeft(arg_2_0)
	local var_2_0 = string.format(gLanguageCsv.confirmSelectSprite, csv.cards[arg_2_0.cardId[1]].name)

	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		title = gLanguageCsv.spaceTips,
		content = var_2_0,
		cb = function()
			gGameApp:requestServer("/game/role/gift/choose", function(arg_4_0)
				arg_2_0.choosed_dbid = arg_4_0.view.carddbIDs[1][1]

				arg_2_0:onClose()
			end, arg_2_0.id, 1, "choose1", true)
		end
	})
end

function var_0_1.clickRight(arg_5_0)
	local var_5_0 = string.format(gLanguageCsv.confirmSelectSprite, csv.cards[arg_5_0.cardId[2]].name)

	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		title = gLanguageCsv.spaceTips,
		content = var_5_0,
		cb = function()
			gGameApp:requestServer("/game/role/gift/choose", function(arg_7_0)
				arg_5_0.choosed_dbid = arg_7_0.view.carddbIDs[1][1]

				arg_5_0:onClose()
			end, arg_5_0.id, 1, "choose2", true)
		end
	})
end

function var_0_1.onClose(arg_8_0)
	if arg_8_0.cb then
		arg_8_0:addCallbackOnExit(functools.partial(arg_8_0.cb, arg_8_0.choosed_dbid))
	end

	var_0_0.onClose(arg_8_0)
end

return var_0_1
