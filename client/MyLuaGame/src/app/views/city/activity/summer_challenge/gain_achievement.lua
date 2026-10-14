local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SummerChallengeGainAchievementView", var_0_0)

var_0_1.RESOURCE_FILENAME = "summer_challenge_gain_achievement.json"
var_0_1.RESOURCE_BINDING = {
	["icon.imgLight"] = "imgLight",
	["icon.imgLight1"] = "imgLight1",
	item = "item",
	gain = {
		varname = "gain",
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
var_0_1.RESOURCE_STYLES = {
	clickClose = true,
	blackLayer = true
}

function var_0_1.onCreate(arg_1_0, arg_1_1)
	bind.extend(arg_1_0, arg_1_0.item, {
		class = "icon_key",
		props = {
			data = {
				key = arg_1_1.itemId
			}
		}
	})

	local var_1_0 = cc.RotateBy:create(15, 360)
	local var_1_1 = cc.RotateBy:create(6, -360)

	arg_1_0.imgLight:runAction(cc.RepeatForever:create(var_1_0))
	arg_1_0.imgLight1:runAction(cc.RepeatForever:create(var_1_1))
end

return var_0_1
