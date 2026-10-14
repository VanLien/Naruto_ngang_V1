function battleEasy.effect(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = type(arg_1_1)

	if var_1_0 == "function" then
		gRootViewProxy:proxy():onEventEffect(arg_1_0, "callback", {
			func = arg_1_1,
			delay = arg_1_2 and arg_1_2.delay,
			lifetime = arg_1_2 and arg_1_2.lifetime
		})
	elseif var_1_0 == "string" then
		gRootViewProxy:proxy():onEventEffect(arg_1_0, arg_1_1, arg_1_2)
	else
		error("only function or string be allowed")
	end
end

function battleEasy.queueEffect(arg_2_0, arg_2_1)
	local var_2_0 = type(arg_2_0)

	if var_2_0 == "function" then
		gRootViewProxy:proxy():onEventEffectQueue("callback", {
			func = arg_2_0,
			delay = arg_2_1 and arg_2_1.delay,
			lifetime = arg_2_1 and arg_2_1.lifetime,
			zOrder = arg_2_1 and arg_2_1.zOrder
		})
	elseif var_2_0 == "string" then
		gRootViewProxy:proxy():onEventEffectQueue(arg_2_0, arg_2_1)
	else
		error("only function or string be allowed")
	end
end

function battleEasy.queueNotify(arg_3_0, ...)
	assert(type(arg_3_0) == "string", "msg not string type")

	local var_3_0 = {
		...
	}

	gRootViewProxy:proxy():onEventEffectQueue("callback", {
		func = function()
			gRootViewProxy:notify(arg_3_0, unpack(var_3_0))
		end
	})
end

function battleEasy.queueZOrderNotify(arg_5_0, arg_5_1, ...)
	assert(type(arg_5_0) == "string", "msg not string type")

	local var_5_0 = {
		...
	}

	gRootViewProxy:proxy():onEventEffectQueue("callback", {
		func = function()
			gRootViewProxy:notify(arg_5_0, unpack(var_5_0))
		end,
		zOrder = arg_5_1
	})
end

function battleEasy.queueNotifyFor(arg_7_0, arg_7_1, ...)
	assert(arg_7_0, "view is nil, plz use queueNotify")
	assert(type(arg_7_1) == "string", "msg not string type")

	local var_7_0 = {
		...
	}

	gRootViewProxy:proxy():onEventEffectQueue("callback", {
		func = function()
			arg_7_0:notify(arg_7_1, unpack(var_7_0))
		end
	})
end

function battleEasy.deferEffect(...)
	error("temporary")

	return gRootViewProxy:proxy():addCallbackToCurDeferList(...)
end

function battleEasy.deferCallback(arg_10_0)
	return gRootViewProxy:proxy():addCallbackToCurDeferList(arg_10_0)
end

function battleEasy.deferNotify(arg_11_0, arg_11_1, ...)
	local var_11_0 = functools.handler(arg_11_0 or gRootViewProxy, "notify", arg_11_1, ...)

	return gRootViewProxy:proxy():addCallbackToCurDeferList(var_11_0)
end

function battleEasy.deferCallbackCantJump(arg_12_0)
	return gRootViewProxy:proxy():addCallbackToCurDeferList(arg_12_0, battle.FilterDeferListTag.cantJump)
end

function battleEasy.deferNotifyCantJump(arg_13_0, arg_13_1, ...)
	local var_13_0 = functools.handler(arg_13_0 or gRootViewProxy, "notify", arg_13_1, ...)

	return gRootViewProxy:proxy():addCallbackToCurDeferList(var_13_0, battle.FilterDeferListTag.cantJump)
end

function battleEasy.deferNotifyCantClean(arg_14_0, arg_14_1, ...)
	local var_14_0 = functools.handler(arg_14_0 or gRootViewProxy, "notify", arg_14_1, ...)

	return gRootViewProxy:proxy():addCallbackToCurDeferList(var_14_0, battle.FilterDeferListTag.cantClean)
end
