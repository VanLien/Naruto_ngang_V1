local var_0_0 = class("CharacterGainSpriteView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "character_gain_sprite.json"
var_0_0.RESOURCE_BINDING = {
	effect = "effect",
	txt = "txt",
	pos = "pos",
	["btnBegin.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	btnBegin = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBegin")
			}
		}
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.cb = arg_1_2

	audio.playEffectWithWeekBGM("card_gain.mp3")

	local var_1_0 = widget.addAnimationByKey(arg_1_0.effect, "effect/gongxihuode.skel", "titleEft", "effect")

	var_1_0:xy(0, 0)
	var_1_0:setSpriteEventHandler(function(arg_2_0, arg_2_1)
		var_1_0:play("effect_loop")
	end, sp.EventType.ANIMATION_COMPLETE)

	local var_1_1 = csv.unit[csv.cards[arg_1_1].unitID]
	local var_1_2 = string.gsub(var_1_1.unitRes, ".skel", "_ui.skel")
	local var_1_3 = widget.addAnimationByKey(arg_1_0.pos, var_1_2, "effect", "standby_loop")

	var_1_3:xy(arg_1_0.pos:size().width / 2 + 40, 0):scale(var_1_1.scaleU * 0.7)
	var_1_3:setSkin(var_1_1.skin)
	arg_1_0.txt:text(string.format(gLanguageCsv.congratulationGetCard, csv.cards[arg_1_1].name))
end

function var_0_0.onBegin(arg_3_0)
	arg_3_0.cb()
end

return var_0_0
