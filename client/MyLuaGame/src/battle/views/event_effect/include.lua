local var_0_0 = {}

globals.battleEffect = var_0_0

require("battle.views.event_effect.effect")
require("battle.views.event_effect.effect1")
require("battle.views.event_effect.effect2")
require("battle.views.event_effect.callback_debug")

local var_0_1 = {
	sound = var_0_0.Sound,
	damageSeg = var_0_0.SegShow,
	hpSeg = var_0_0.SegShow,
	shaker = var_0_0.Shaker,
	music = var_0_0.Music,
	move = var_0_0.Move,
	show = var_0_0.Show,
	effect = var_0_0.SpriteEffect,
	delay = var_0_0.Delay,
	zOrder = var_0_0.ZOrder,
	moveByDis = var_0_0.MoveByDis,
	moveByTime = var_0_0.MoveByTime,
	moveTo = var_0_0.MoveTo,
	comeBack = var_0_0.ComeBack,
	callback = var_0_0.Callback,
	follow = var_0_0.Follow,
	wait = var_0_0.Wait,
	jump = var_0_0.Jump,
	control = var_0_0.Control,
	onceEffect = var_0_0.OnceEffect
}

function globals.newEventEffect(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return var_0_1[arg_1_0].new(arg_1_1, arg_1_2, arg_1_3)
end

return var_0_0
