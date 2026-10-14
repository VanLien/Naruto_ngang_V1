require("battle.models.include")

local function var_0_0(arg_1_0, ...)
	if arg_1_0 == nil then
		return
	end

	return arg_1_0(...)
end

local function var_0_1(...)
	return
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2)
	if (not arg_3_0._modes or not arg_3_0._modes.fromRecordFile) and not arg_3_0._isTestScene and not arg_3_0._preCheck then
		local var_3_0 = not arg_3_0._results or arg_3_0._results.result == arg_3_2.result or arg_3_0._results == arg_3_2.result

		if not var_3_0 then
			print("==== results in now", dumps(arg_3_2))
			print("==== t._results in early", dumps(arg_3_0._results))
		end

		assert(var_3_0, "战斗结果不一致")
	end

	arg_3_0._results = arg_3_2

	return var_0_0(arg_3_0._onResult, arg_3_0._data, arg_3_0._results)
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3, ...)
	checkGGCheat()

	if gGameModel.battle then
		gGameModel.battle:checkCheat()
	end

	if type(arg_4_3) == "function" then
		arg_4_3 = {
			cb = arg_4_3
		}
	end

	local var_4_0 = arg_4_3.cb

	arg_4_3.cb = nil

	local function var_4_1(...)
		var_4_0(...)
		var_0_0(arg_4_0._onPostResp)

		gRootViewProxy = arg_4_0._oldViewProxy
	end

	local var_4_2 = arg_4_3.onErrClose

	function arg_4_3.onErrClose(...)
		if var_4_2 then
			var_4_2(...)
		else
			gGameUI:switchUI("city.view")
		end

		gRootViewProxy = arg_4_0._oldViewProxy
	end

	local var_4_3 = gGameApp:requestServerCustom(arg_4_2):params(...)

	for iter_4_0, iter_4_1 in pairs(arg_4_3) do
		var_4_3[iter_4_0](var_4_3, iter_4_1)
	end

	return var_4_3:doit(var_4_1)
end

local var_0_4

local function var_0_5(arg_7_0, arg_7_1, arg_7_2)
	assert(type(arg_7_0) == "table", "_switchUI need battleEntrance " .. type(arg_7_0))

	local var_7_0 = arg_7_0._data
	local var_7_1 = arg_7_0._modes

	if arg_7_1 or arg_7_2 then
		if var_0_4 then
			var_0_4:remove()

			var_0_4 = nil
		end

		local var_7_2

		var_7_2 = gGameUI:registerMessageListener("switchUI", function(arg_8_0)
			if arg_8_0 == "battle.loading" then
				var_0_0(arg_7_2)

				var_0_4 = var_7_2
			elseif arg_8_0 == "battle.view" then
				var_0_0(arg_7_1)
				var_7_2:remove()
			end
		end)
	end

	if gGameUI.rootViewName == "city.view" then
		gGameUI:switchUIAndStash("battle.loading", var_7_0, var_7_0.sceneID, var_7_1, arg_7_0)
	else
		gGameUI:switchUI("battle.loading", var_7_0, var_7_0.sceneID, var_7_1, arg_7_0)
	end
end

local var_0_6 = {
	postEndResultToServer = function(arg_9_0)
		local var_9_0 = arg_9_0._results

		assert(var_9_0, "battle results was nil")

		local var_9_1 = gRootViewProxy:raw().postEndResultToServer

		gRootViewProxy:raw().postEndResultToServer = function(arg_10_0, arg_10_1, arg_10_2)
			printDebug("postEndResultToServer %s be hacked in local", arg_10_1)

			gRootViewProxy:raw().postEndResultToServer = var_9_1

			checkGGCheat()

			if gGameModel.battle then
				gGameModel.battle:checkCheat()
			end

			return (type(arg_10_2) == "function" and arg_10_2 or arg_10_2.cb)(var_9_0.serverData)
		end
	end,
	showEndView = function(arg_11_0)
		local var_11_0 = gRootViewProxy:raw().showEndView

		gRootViewProxy:raw().showEndView = function(arg_12_0, arg_12_1)
			assert(arg_12_1, "battle results was nil")
			printDebug("showEndView be hacked in local")

			gRootViewProxy:raw().showEndView = var_11_0
			arg_11_0._results = arg_12_1

			var_11_0(arg_12_0, arg_12_1)
			var_0_0(arg_11_0._onResult, arg_11_0._data, arg_11_0._results)
		end
	end,
	onRunBattleModel = function(arg_13_0)
		local var_13_0 = arg_13_0._runBattleInLoading

		assert(var_13_0, "runBattleInLoading was nil")
		assert(gGameUI.rootViewName == "battle.loading", "root view was not battle.loading")

		local var_13_1 = gRootViewProxy:raw().onRunBattleModel

		gRootViewProxy:raw().onRunBattleModel = function(arg_14_0)
			printDebug("onRunBattleModel be hacked in local")

			gRootViewProxy:raw().onRunBattleModel = var_13_1

			if arg_13_0._post then
				function arg_13_0._onPostResp()
					var_13_1(arg_14_0)

					arg_13_0._postRespOver = true
				end
			end

			var_13_0()

			if not arg_13_0._post then
				var_13_1(arg_14_0)
			end
		end
	end
}

local function var_0_7(arg_16_0)
	local var_16_0 = arg_16_0._data
	local var_16_1 = string.format("\n\n\t\tbattle %s model run - seed=%s, scene=%s\n\n", arg_16_0._record and "record" or "", var_16_0.randSeed, var_16_0.sceneID)

	printInfo(var_16_1)
	log.battle(var_16_1)
	collectgarbage()

	local var_16_2 = collectgarbage("count")
	local var_16_3 = os.clock()

	cow.battleModelInit()
	battleEntrance.preloadConfig()

	local var_16_4 = cow.proxyObject("scene", SceneModel.new())

	ymrand.randomseed(var_16_0.randSeed)

	ymrand.randCount = 0
	arg_16_0._oldViewProxy = gRootViewProxy
	gRootViewProxy = ViewProxy.new({
		postEndResultToServer = arg_16_0._post and functools.partial(var_0_3, arg_16_0) or var_0_1,
		showEndView = functools.partial(var_0_2, arg_16_0)
	})

	gRootViewProxy:modelOnly()
	var_16_4:init(var_16_0.sceneID, var_16_0, arg_16_0._record)
	var_16_4:setAutoFight(true)

	while not var_16_4.isBattleAllEnd do
		var_16_4:update(game.FRAME_TICK)

		if arg_16_0._timeLimit and os.clock() - var_16_3 > arg_16_0._timeLimit then
			break
		end
	end

	cow.battleModelDestroy()
	battleComponents.clearAll()

	if not arg_16_0._preCheck then
		battleEntrance.unloadConfig()
	end

	collectgarbage()

	local var_16_5 = collectgarbage("count")

	printInfo("_runBattleModel over mem %.2fKB cost %.2fKB %.3fs", var_16_5, var_16_5 - var_16_2, os.clock() - var_16_3)

	if not arg_16_0._post then
		gRootViewProxy = arg_16_0._oldViewProxy
	end

	local var_16_6 = var_16_4.play:makeEndViewInfos()

	arg_16_0._results = var_16_6

	if arg_16_0._check or arg_16_0._preCheck then
		return var_16_4.play:compareRecrodResult(arg_16_0._checkResult)
	end

	return var_16_6
end

local var_0_8 = {
	__cname = "localRunnerFuncs"
}

var_0_8.__index = var_0_8

function var_0_8.post(arg_17_0)
	assert(not arg_17_0._record, "record could not post to server")

	arg_17_0._post = true

	return arg_17_0
end

function var_0_8.timeLimit(arg_18_0, arg_18_1)
	arg_18_0._timeLimit = arg_18_1

	return arg_18_0
end

function var_0_8.preCheck(arg_19_0, arg_19_1, arg_19_2)
	if dev.CLOSE_PVP_PRECHECK then
		return arg_19_0
	end

	assert(not arg_19_0._post, "check record could not post to server")
	assert(arg_19_0._record, "only record could be check")

	arg_19_0._preCheck = true
	arg_19_0._onPreCheckFailed = arg_19_2
	arg_19_0._checkResult = arg_19_1 or arg_19_0._results

	return arg_19_0
end

function var_0_8.run(arg_20_0)
	return var_0_7(arg_20_0)
end

function var_0_8.check(arg_21_0, arg_21_1)
	assert(not arg_21_0._post, "check record could not post to server")
	assert(arg_21_0._record, "only record could be check")

	arg_21_0._check = true
	arg_21_0._checkResult = arg_21_1

	return var_0_7(arg_21_0)
end

function var_0_8.show(arg_22_0)
	if arg_22_0._preCheck and not var_0_7(arg_22_0) then
		return var_0_0(arg_22_0._onPreCheckFailed)
	end

	var_0_5(arg_22_0, function()
		var_0_6.postEndResultToServer(arg_22_0)
	end)
end

function var_0_8.enter(arg_24_0)
	var_0_5(arg_24_0)
end

battleEntrance._switchUI = var_0_5
battleEntrance._runBattleModel = var_0_7
battleEntrance._localHack = var_0_6

function battleEntrance.battle(arg_25_0, arg_25_1)
	assert(arg_25_0.sceneID, "no sceneID")

	return setmetatable({
		_data = arg_25_0,
		_modes = arg_25_1
	}, var_0_8)
end

function battleEntrance.battleRecord(arg_26_0, arg_26_1, arg_26_2)
	assert(arg_26_0.sceneID, "no sceneID")

	arg_26_2 = arg_26_2 or {}
	arg_26_2.isRecord = true

	return setmetatable({
		_record = true,
		_post = false,
		_data = arg_26_0,
		_results = arg_26_1,
		_modes = arg_26_2
	}, var_0_8)
end
