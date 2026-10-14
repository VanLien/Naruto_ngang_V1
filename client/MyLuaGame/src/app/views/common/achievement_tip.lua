local var_0_0 = class("AchievementTipView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "common_achievement_tip.json"
var_0_0.RESOURCE_BINDING = {
	["panel.bg"] = "bg",
	["panel.icon"] = "icon",
	panel = "panel",
	["panel.text1"] = {
		varname = "text1",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(137, 40, 34, 255)
				}
			}
		}
	},
	["panel.text2"] = {
		varname = "text2",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(137, 40, 34, 255)
				}
			}
		}
	},
	["panel.text3"] = {
		varname = "text3",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(137, 40, 34, 255)
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.csvId = arg_1_1

	local var_1_0 = csv.achievement.achievement[arg_1_2.type].icon

	arg_1_0.icon:texture(icon)
	arg_1_0.text2:text(arg_1_2.title)
	arg_1_0.text3:text(arg_1_2.point)

	local var_1_1 = 3
	local var_1_2 = 2
	local var_1_3, var_1_4 = arg_1_0:xy()

	transition.executeSequence(arg_1_0.panel):delay(var_1_1):moveBy(var_1_2, 0, 100):func(functools.partial(arg_1_0.onClose, arg_1_0)):done()
	transition.executeSequence(arg_1_0.icon):delay(var_1_1):fadeOut(var_1_2):done()
	transition.executeSequence(arg_1_0.bg):delay(var_1_1):fadeOut(var_1_2):done()
	transition.executeSequence(arg_1_0.text1):delay(var_1_1):fadeOut(var_1_2):done()
	transition.executeSequence(arg_1_0.text2):delay(var_1_1):fadeOut(var_1_2):done()
	transition.executeSequence(arg_1_0.text3):delay(var_1_1):fadeOut(var_1_2):done()

	if arg_1_0.text2:width() > arg_1_0.text1:width() then
		adapt.oneLinePos(arg_1_0.text2, arg_1_0.icon, cc.p(20, 15), "right")
		adapt.oneLinePos(arg_1_0.text2, arg_1_0.text3, cc.p(60, 0), "left")
	else
		adapt.oneLinePos(arg_1_0.text1, arg_1_0.icon, cc.p(20, 15), "right")
		adapt.oneLinePos(arg_1_0.text1, arg_1_0.text3, cc.p(60, 0), "left")
	end

	arg_1_0.bg:x(arg_1_0.text3:x() - 265)
	arg_1_0.text3:y(arg_1_0.bg:y())
end

function var_0_0.onClose(arg_2_0)
	arg_2_0.panel:stopAllActions()
	arg_2_0:removeSelf()
end

function var_0_0.onMoveUp(arg_3_0)
	local var_3_0 = arg_3_0.panel:size().height + 20
	local var_3_1, var_3_2 = arg_3_0:xy()

	transition.executeSequence(arg_3_0):moveTo(0.3, var_3_1, var_3_2 + var_3_0):done()
end

return var_0_0
