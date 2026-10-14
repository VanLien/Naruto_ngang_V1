local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("BraveChallengeGainAchievementView", var_0_0)

var_0_1.RESOURCE_FILENAME = "activity_brave_challenge_gain_achievement.json"
var_0_1.RESOURCE_STYLES = {
	clickClose = true,
	blackLayer = true
}
var_0_1.RESOURCE_BINDING = {
	icon = "icon",
	item = "item",
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
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

function var_0_1.onCreate(arg_1_0, arg_1_1)
	arg_1_0.sendQuit = arg_1_1.sendQuit
	arg_1_0.got = arg_1_1.got

	local var_1_0 = {}

	for iter_1_0, iter_1_1 in csvPairs(arg_1_1.itemData) do
		local var_1_1 = arg_1_0.item:clone():show()

		var_1_1:addTo(arg_1_0.item:parent(), 2)
		bind.extend(arg_1_0, var_1_1, {
			class = "icon_key",
			props = {
				data = {
					key = iter_1_0,
					num = iter_1_1
				}
			}
		})
		table.insert(var_1_0, var_1_1)
		var_1_1:get("got"):visible(not arg_1_1.got)
	end

	adapt.oneLineCenterPos(cc.p(arg_1_0.gain:x(), 280), var_1_0, cc.p(5, 0))
	arg_1_0.gain:visible(false)

	local var_1_2 = widget.addAnimationByKey(arg_1_0.icon, arg_1_1.lastAnimation, "bg", "effect_loop", 10):xy(100, 0):scale(2)
	local var_1_3 = widget.addAnimationByKey(arg_1_0.icon, "effect/hd.skel", "wutai", "effect", 0):xy(100, 0)
end

function var_0_1.onClose(arg_2_0)
	arg_2_0:addCallbackOnExit(functools.partial(arg_2_0.sendQuit, true))
	var_0_0.onClose(arg_2_0)
end

return var_0_1
