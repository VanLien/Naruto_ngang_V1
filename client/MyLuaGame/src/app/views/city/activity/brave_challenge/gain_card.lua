local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("BraveChallengeGainCardView", var_0_0)

var_0_1.RESOURCE_FILENAME = "activity_brave_challenge_gain_card.json"
var_0_1.RESOURCE_BINDING = {
	rarityIcon = "rarityIcon",
	spine = "spine",
	condition = {
		varname = "condition",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			}
		}
	},
	conditionTxt = {
		varname = "conditionTxt",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			}
		}
	},
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	cardName = {
		varname = "cardName",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.cb = arg_1_2

	local var_1_0 = csv.brave_challenge.cards[arg_1_1]
	local var_1_1 = csv.cards[var_1_0.cardID].unitID
	local var_1_2 = csv.unit[var_1_1]

	widget.addAnimationByKey(arg_1_0.spine, "effect/hd.skel", "bg", "effect", 10):xy(300, 300)

	local var_1_3 = widget.addAnimationByKey(arg_1_0.spine, var_1_2.unitRes, "spine", "standby_loop", 11):scale(var_1_2.scale * 1.5):xy(300, 50)

	arg_1_0.rarityIcon:texture("common/icon/icon_rarity" .. var_1_0.rarity + 1 .. ".png")
	arg_1_0.cardName:text(var_1_0.desc)
	arg_1_0.conditionTxt:text(var_1_0.unlockdesc2)
	adapt.oneLineCenterPos(cc.p(1280, arg_1_0.condition:y()), {
		arg_1_0.condition,
		arg_1_0.conditionTxt
	}, cc.p(0, 0))
end

function var_0_1.onClose(arg_2_0)
	arg_2_0:addCallbackOnExit(arg_2_0.cb)
	var_0_0.onClose(arg_2_0)
end

return var_0_1
