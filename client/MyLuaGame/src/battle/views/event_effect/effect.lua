local var_0_0 = class("EventEffect")

battleEffect.EventEffect = var_0_0

function var_0_0.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.key = nil
	arg_1_0.queID = nil
	arg_1_0.args = arg_1_2
	arg_1_0.playOver = false
	arg_1_0.delay = arg_1_2 and arg_1_2.delay or 0
	arg_1_0.tick = nil
	arg_1_0.lifetime = arg_1_2 and arg_1_2.lifetime
	arg_1_0.view = arg_1_1 or gRootViewProxy:raw()
	arg_1_0.target = arg_1_3 or arg_1_0.view
	arg_1_0.zOrder = arg_1_2 and arg_1_2.zOrder or battle.EffectZOrder.none

	if device.platform == "windows" then
		arg_1_0.traceback = debug.traceback()
	end

	if arg_1_2 then
		if arg_1_2.delay then
			arg_1_2.delay = nil
		end

		if arg_1_2.lifetime then
			arg_1_2.lifetime = nil
		end
	end
end

function var_0_0.play(arg_2_0)
	if arg_2_0.delay == 0 then
		arg_2_0.tick = 0

		return arg_2_0:onPlay()
	end
end

function var_0_0.onPlay(arg_3_0)
	return
end

function var_0_0.stop(arg_4_0)
	if not arg_4_0.playOver then
		arg_4_0.playOver = true

		return arg_4_0:onStop()
	end
end

function var_0_0.free(arg_5_0)
	arg_5_0.playOver = true

	arg_5_0:onFree()
end

function var_0_0.onFree(arg_6_0)
	return
end

function var_0_0.onStop(arg_7_0)
	return
end

function var_0_0.isStop(arg_8_0)
	return arg_8_0.playOver
end

function var_0_0.update(arg_9_0, arg_9_1)
	if arg_9_0.delay > 0 then
		arg_9_0.delay = arg_9_0.delay - arg_9_1

		if arg_9_0.delay > 0 then
			return
		end

		arg_9_1 = -arg_9_0.delay
	end

	if arg_9_0.tick == nil then
		arg_9_0.tick = 0

		arg_9_0:onPlay()

		if not arg_9_0.onUpdate then
			return
		end
	end

	arg_9_0.tick = arg_9_0.tick + arg_9_1

	if arg_9_0.lifetime and arg_9_0.lifetime <= arg_9_0.tick then
		arg_9_1 = arg_9_1 - (arg_9_0.tick - arg_9_0.lifetime)

		arg_9_0:onUpdate(arg_9_1)

		return arg_9_0:stop()
	end

	return arg_9_0:onUpdate(arg_9_1)
end

function var_0_0.canUpdate(arg_10_0)
	return not arg_10_0.playOver and (arg_10_0.onUpdate or arg_10_0.delay > 0)
end

function var_0_0.debugString(arg_11_0)
	return tostring(arg_11_0)
end

local var_0_1 = class("OnceEventEffect", var_0_0)

battleEffect.OnceEventEffect = var_0_1

function var_0_1.play(arg_12_0)
	if arg_12_0.delay == 0 then
		arg_12_0:onPlay()

		return arg_12_0:free()
	end
end

function var_0_1.update(arg_13_0, arg_13_1)
	arg_13_0.delay = arg_13_0.delay - arg_13_1

	if arg_13_0.delay > 0 then
		return
	end

	arg_13_0:onPlay()

	return arg_13_0:free()
end

local var_0_2 = class("Manager")

battleEffect.Manager = var_0_2

function var_0_2.ctor(arg_14_0, arg_14_1)
	arg_14_0.key = arg_14_1
	arg_14_0.effects = {}
	arg_14_0.updEffects = {}
	arg_14_0.queHeadID = 1
	arg_14_0.queTailID = 0
	arg_14_0.queEffects = {}
	arg_14_0.keyCounter = 1
	arg_14_0.running = true
end

function var_0_2.addAndPlay(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 == nil then
		arg_15_1 = arg_15_0.keyCounter
		arg_15_0.keyCounter = arg_15_0.keyCounter + 1
	end

	arg_15_2:play()

	if not arg_15_2:isStop() then
		arg_15_0.effects[arg_15_1] = arg_15_2
		arg_15_2.key = arg_15_1

		if arg_15_2:canUpdate() then
			arg_15_0.updEffects[arg_15_1] = arg_15_2
		end
	end

	gRootViewProxy:notify("effectUpdated")

	return arg_15_2
end

function var_0_2.delAndStop(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.effects[arg_16_1]

	if var_16_0 then
		var_16_0:stop()

		arg_16_0.effects[arg_16_1] = nil
		arg_16_0.updEffects[arg_16_1] = nil
	end

	gRootViewProxy:notify("effectUpdated")
end

function var_0_2.queueAppend(arg_17_0, arg_17_1)
	arg_17_0.queTailID = arg_17_0.queTailID + 1
	arg_17_0.queEffects[arg_17_0.queTailID] = arg_17_1
	arg_17_1.queID = arg_17_0.queTailID

	gRootViewProxy:notify("effectUpdated")

	return arg_17_1
end

function var_0_2.queuePrepend(arg_18_0, arg_18_1)
	if not arg_18_1:isStop() then
		return arg_18_0:queueInsert(1, arg_18_1)
	end

	return arg_18_0:queueInsert(0, arg_18_1)
end

function var_0_2.queueInsert(arg_19_0, arg_19_1, arg_19_2)
	for iter_19_0 = arg_19_0.queTailID, arg_19_0.queHeadID + arg_19_1, -1 do
		arg_19_0.queEffects[iter_19_0].queID = iter_19_0 + 1
		arg_19_0.queEffects[iter_19_0 + 1] = arg_19_0.queEffects[iter_19_0]
	end

	arg_19_0.queTailID = arg_19_0.queTailID + 1
	arg_19_0.queEffects[arg_19_0.queHeadID + arg_19_1] = arg_19_2
	arg_19_2.queID = arg_19_0.queHeadID + arg_19_1

	gRootViewProxy:notify("effectUpdated")

	return arg_19_2
end

function var_0_2.queueClear(arg_20_0)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.queEffects) do
		iter_20_1:stop()
	end

	arg_20_0.queHeadID = 1
	arg_20_0.queTailID = 0
	arg_20_0.queEffects = {}

	gRootViewProxy:notify("effectUpdated")
end

function var_0_2.queueErase(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.queEffects[arg_21_1]

	if var_21_0 then
		if arg_21_1 == arg_21_0.queHeadID then
			var_21_0:stop()
		else
			var_21_0:free()
		end
	end

	gRootViewProxy:notify("effectUpdated")
end

function var_0_2.queueSize(arg_22_0)
	return arg_22_0.queTailID - arg_22_0.queHeadID + 1
end

function var_0_2.queueInfo(arg_23_0)
	local var_23_0 = arg_23_0.queHeadID
	local var_23_1 = {}

	while var_23_0 <= arg_23_0.queTailID do
		local var_23_2 = arg_23_0.queEffects[var_23_0]

		table.insert(var_23_1, string.format("%d. %s", var_23_0, var_23_2:debugString()))

		var_23_0 = var_23_0 + 1
	end

	return var_23_1
end

function var_0_2.update(arg_24_0, arg_24_1)
	if not arg_24_0.running then
		return false
	end

	local var_24_0 = false

	for iter_24_0, iter_24_1 in pairs(arg_24_0.updEffects) do
		var_24_0 = true

		iter_24_1:update(arg_24_1)

		if not iter_24_1:canUpdate() then
			arg_24_0.updEffects[iter_24_0] = nil

			if iter_24_1:isStop() then
				arg_24_0.effects[iter_24_0] = nil
			end
		end
	end

	local var_24_1 = false

	while arg_24_0.running and arg_24_0.queHeadID <= arg_24_0.queTailID do
		var_24_0 = true

		local var_24_2 = arg_24_0.queEffects[arg_24_0.queHeadID]

		if var_24_2:isStop() then
			log.effect.stop(arg_24_0.key, tostring(var_24_2), arg_24_0.queHeadID, "/", arg_24_0.queTailID)

			arg_24_0.queEffects[arg_24_0.queHeadID] = nil
			arg_24_0.queHeadID = arg_24_0.queHeadID + 1

			if arg_24_0.queHeadID <= arg_24_0.queTailID then
				var_24_2 = arg_24_0:getHeadEffect()

				if not var_24_2:isStop() then
					var_24_2:play()

					if arg_24_0.playCallback then
						arg_24_0.playCallback(arg_24_0, arg_24_0.queHeadID, var_24_2)
					end
				end
			end
		else
			if var_24_1 then
				break
			end

			var_24_2:update(arg_24_1)

			var_24_1 = true
		end
	end

	return var_24_0
end

function var_0_2.getHeadEffect(arg_25_0)
	if arg_25_0.queTailID - arg_25_0.queHeadID >= 1 and arg_25_0.queEffects[arg_25_0.queHeadID].zOrder > arg_25_0.queEffects[arg_25_0.queHeadID + 1].zOrder or arg_25_0.queEffects[arg_25_0.queHeadID].zOrder == battle.EffectZOrder.dead then
		for iter_25_0 = arg_25_0.queTailID, arg_25_0.queHeadID + 1, -1 do
			if arg_25_0.queEffects[iter_25_0 - 1].zOrder > arg_25_0.queEffects[iter_25_0].zOrder then
				arg_25_0:exchangeEffect(iter_25_0 - 1, iter_25_0)
			end
		end
	end

	return arg_25_0.queEffects[arg_25_0.queHeadID]
end

function var_0_2.exchangeEffect(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0.queEffects[arg_26_1].queID, arg_26_0.queEffects[arg_26_2].queID = arg_26_0.queEffects[arg_26_2].queID, arg_26_0.queEffects[arg_26_1].queID
	arg_26_0.queEffects[arg_26_1], arg_26_0.queEffects[arg_26_2] = arg_26_0.queEffects[arg_26_2], arg_26_0.queEffects[arg_26_1]
end

function var_0_2.clear(arg_27_0)
	arg_27_0:queueClear()

	for iter_27_0, iter_27_1 in pairs(arg_27_0.effects) do
		iter_27_1:stop()
	end

	arg_27_0.effects = {}
	arg_27_0.updEffects = {}
end

function var_0_2.resume(arg_28_0)
	arg_28_0.running = true
end

function var_0_2.pause(arg_29_0)
	arg_29_0.running = false
end

function var_0_2.setEffectPlayCallback(arg_30_0, arg_30_1)
	arg_30_0.playCallback = arg_30_1
end

function var_0_2.passOneWaveClear(arg_31_0)
	for iter_31_0, iter_31_1 in pairs(arg_31_0.queEffects) do
		if not iter_31_1.args or not iter_31_1.args.cleanTag or iter_31_1.args.cleanTag ~= battle.FilterDeferListTag.cantClean then
			arg_31_0:queueErase(iter_31_0)
		end
	end

	for iter_31_2, iter_31_3 in pairs(arg_31_0.effects) do
		if not iter_31_3.args or not iter_31_3.args.cleanTag or iter_31_3.args.cleanTag ~= battle.FilterDeferListTag.cantClean then
			arg_31_0:delAndStop(iter_31_2)
		end
	end
end
