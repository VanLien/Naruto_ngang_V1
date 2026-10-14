function BattleView.onEventEffect(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0

	if arg_1_1 then
		arg_1_1 = tostring(arg_1_1)
		var_1_0 = arg_1_0:onViewProxyCall("getSceneObj", arg_1_1)
	end

	local var_1_1 = var_1_0 or arg_1_0
	local var_1_2 = var_1_0 or var_1_1
	local var_1_3 = newEventEffect(arg_1_2, var_1_1, arg_1_3, var_1_2)

	return arg_1_0.effectManager:addAndPlay(nil, var_1_3)
end

function BattleView.onEventEffectQueue(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0
	local var_2_1 = newEventEffect(arg_2_1, arg_2_0, arg_2_2, var_2_0)

	return arg_2_0.effectManager:queueAppend(var_2_1)
end

function BattleView.onEventEffectQueueFront(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0
	local var_3_1 = newEventEffect(arg_3_1, arg_3_0, arg_3_2, var_3_0)

	return arg_3_0.effectManager:queuePrepend(var_3_1)
end

function BattleView.onEventEffectQueueFor(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_1
	local var_4_1 = newEventEffect(arg_4_2, arg_4_1, arg_4_3, var_4_0)

	return arg_4_0.effectManager:queueAppend(var_4_1)
end

function BattleView.onEventEffectCancel(arg_5_0, arg_5_1)
	if arg_5_1.key then
		arg_5_0.effectManager:delAndStop(arg_5_1.key)
	elseif arg_5_1.queID then
		arg_5_0.effectManager:queueErase(arg_5_1.queID)
	end
end

local var_0_0 = 1
local var_0_1 = setmetatable({}, {
	__mode = "k"
})

local function var_0_2(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0

	if arg_6_0 or arg_6_1 or arg_6_2 then
		var_6_0 = ""

		if arg_6_0 then
			var_6_0 = var_6_0 .. string.format("skill_%s|", arg_6_0)
		end

		if arg_6_1 then
			var_6_0 = var_6_0 .. string.format("process_%s|", arg_6_1)
		end

		if arg_6_2 then
			var_6_0 = var_6_0 .. string.format("seg_%s|", arg_6_2)
		end

		var_6_0 = var_6_0 .. math.random()
	end

	return var_6_0 or var_0_0
end

local function var_0_3(arg_7_0)
	return tostring(dumps(itertools.keys(arg_7_0.deferListMap)))
end

function BattleView.pushDeferList(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = var_0_2(arg_8_1, arg_8_2, arg_8_3)
	local var_8_1 = CVector.new()

	if var_8_0 == var_0_0 then
		arg_8_0.deferListMap:push_front(var_8_1)
	else
		arg_8_0.deferListMap:push_back(var_8_1)
	end

	arg_8_0.curDeferList = var_8_1

	return var_8_0
end

function BattleView.popDeferList(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or var_0_0

	local var_9_0

	if arg_9_0.deferListMap:empty() then
		errorInWindows("deferListMap is empty key?!", arg_9_1)

		return
	end

	if arg_9_1 == var_0_0 then
		var_9_0 = arg_9_0.deferListMap:pop_front()

		arg_9_0:pushDeferList()
	else
		var_9_0 = arg_9_0.deferListMap:pop_back()
		arg_9_0.curDeferList = arg_9_0.deferListMap:back()
	end

	if device.platform == "windows" then
		var_0_1[var_9_0] = debug.traceback()
	end

	return var_9_0
end

function BattleView.addCallbackToCurDeferList(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.curDeferList == nil then
		assertInWindows(arg_10_0.curDeferList, "curDeferList is nil?! %s", var_0_3(arg_10_0))

		return
	end

	arg_10_0.curDeferList:push_back({
		func = arg_10_1,
		tag = arg_10_2 or battle.FilterDeferListTag.none
	})
end

function BattleView.flushCurDeferList(arg_11_0)
	if arg_11_0.curDeferList == nil then
		assertInWindows(arg_11_0.curDeferList, "curDeferList is nil?! %s", var_0_3(arg_11_0))

		return
	end

	local var_11_0
	local var_11_1 = arg_11_0.curDeferList

	arg_11_0.curDeferList = nil

	for iter_11_0, iter_11_1 in arg_11_0.deferListMap:ipairs() do
		if var_11_1 == iter_11_1 then
			arg_11_0.deferListMap:erase(iter_11_0)

			if iter_11_0 == var_0_0 then
				arg_11_0:pushDeferList()

				break
			end

			arg_11_0.curDeferList = arg_11_0.deferListMap:back()

			break
		end
	end

	arg_11_0:runDeferToQueue(var_11_1)
end

function BattleView.flushAllDeferList(arg_12_0)
	local var_12_0 = arg_12_0.deferListMap[var_0_0]

	while not arg_12_0.deferListMap:empty() do
		local var_12_1 = arg_12_0.deferListMap:pop_front()

		if not var_12_1:empty() then
			arg_12_0:runDeferToQueue(var_12_1)
		end
	end

	arg_12_0:pushDeferList()
end

function BattleView.runDeferToQueue(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return
	end

	for iter_13_0, iter_13_1 in arg_13_1:ipairs() do
		if arg_13_0:filterTagCheck(iter_13_1.tag) then
			arg_13_0:onEventEffectQueue("callback", {
				func = iter_13_1.func,
				cleanTag = iter_13_1.tag
			})
		end
	end

	var_0_1[arg_13_1] = nil
	arg_13_0.filterMap = {}
end

function BattleView.runDeferToQueueFront(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return
	end

	while arg_14_1:size() > 0 do
		local var_14_0 = arg_14_1:pop_back()

		if arg_14_0:filterTagCheck(var_14_0.tag) then
			arg_14_0:onEventEffectQueueFront("callback", {
				func = var_14_0.func,
				cleanTag = var_14_0.tag
			})
		end
	end

	var_0_1[arg_14_1] = nil
	arg_14_0.filterMap = {}
end

function BattleView.runDefer(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return
	end

	for iter_15_0, iter_15_1 in arg_15_1:ipairs() do
		if arg_15_0:filterTagCheck(iter_15_1.tag) then
			arg_15_0:onEventEffect(nil, "callback", {
				func = iter_15_1.func
			})
		end
	end

	var_0_1[arg_15_1] = nil
	arg_15_0.filterMap = {}
end

function BattleView.filterTagCheck(arg_16_0, arg_16_1)
	return table.length(arg_16_0.filterMap) == 0 or table.length(arg_16_0.filterMap) > 0 and arg_16_0.filterMap[arg_16_1]
end

function BattleView.filter(arg_17_0, arg_17_1)
	arg_17_0.filterMap[arg_17_1] = true

	return arg_17_0
end

function BattleView.setEffectDebugEnabled(arg_18_0, arg_18_1)
	return BattleSprite.setEffectDebugEnabled(arg_18_0, arg_18_1)
end

function BattleView.setEffectDebugBreakpoint(arg_19_0, arg_19_1)
	arg_19_0.effectManager:resume()

	if arg_19_1 == nil then
		arg_19_0.effectManager:setEffectPlayCallback(nil)

		return
	end

	arg_19_0.effectManager:setEffectPlayCallback(function(...)
		if arg_19_1(...) then
			arg_19_0.effectManager:resume()
		else
			arg_19_0.effectManager:pause()
		end
	end)
end
