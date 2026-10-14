local var_0_0 = string.format
local var_0_1 = class("BattleMimicryView", require("battle.app_views.battle.module.spec.world_boss"))

function var_0_1.onInitBossLife(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1.name
	local var_1_1 = arg_1_1.headIconRes
	local var_1_2 = arg_1_1.hpMax

	if var_1_0 then
		arg_1_0.bossLifePanel:get("name"):text(var_1_0)
	end

	if var_1_1 then
		arg_1_0.bossLifePanel:get("headIcon"):texture(var_1_1)
	end

	text.addEffect(arg_1_0.bossLifePanel:get("hp"), {
		outline = {
			color = cc.c4b(254, 253, 236, 255)
		}
	})
	text.addEffect(arg_1_0.bossLifePanel:get("hpMax"), {
		outline = {
			color = cc.c4b(209, 128, 0, 255)
		}
	})
	arg_1_0.award:hide()
	arg_1_0.bossLifePanel:get("bar1"):show()
	arg_1_0.bossLifePanel:get("bar2"):show()
	arg_1_0:onRefreshBossHp(var_1_2, var_1_2)
end

function var_0_1.onRefreshBossHp(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.bossLifePanel:get("bar1")
	local var_2_1 = arg_2_0.bossLifePanel:get("bar2")

	var_2_0:stopAllActions()
	arg_2_0.bossLifePanel:get("hp"):setString(math.floor(arg_2_1))
	arg_2_0.bossLifePanel:get("hpMax"):setString("/" .. arg_2_2)
	transition.executeSequence(var_2_0):progressTo(0.8, math.floor(arg_2_1) / arg_2_2 * 100):done()
end

return var_0_1
