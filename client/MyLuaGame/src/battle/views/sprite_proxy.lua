local var_0_0 = string.caption

function BattleSprite.onViewProxyNotify(arg_1_0, arg_1_1, ...)
	log.battle.sprite.notify(arg_1_0.model.id, arg_1_1)

	local var_1_0 = "on" .. var_0_0(arg_1_1)
	local var_1_1 = arg_1_0[var_1_0]

	if var_1_1 then
		var_1_1(arg_1_0, ...)
	else
		printWarn("BattleSprite no handler for msg, %s", var_1_0)
	end
end

function BattleSprite.onViewProxyCall(arg_2_0, arg_2_1, ...)
	log.battle.sprite.call(arg_2_0.model.id, arg_2_1)

	local var_2_0 = arg_2_1
	local var_2_1 = arg_2_0[var_2_0]

	if var_2_1 then
		return var_2_1(arg_2_0, ...)
	else
		printWarn("BattleSprite no handler for msg %s", var_2_0)
	end
end

function BattleSprite.modelOnly(arg_3_0)
	if arg_3_0.sprite then
		arg_3_0.sprite:modelOnly()
	end

	arg_3_0:stopAllActions()
	arg_3_0:unscheduleUpdate()
end
