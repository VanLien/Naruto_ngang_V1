require("battle.app_views.battle.battle_entrance.local")

local function var_0_0(arg_1_0, ...)
	if arg_1_0 == nil then
		return
	end

	return arg_1_0(...)
end

local var_0_1 = battleEntrance._switchUI
local var_0_2 = battleEntrance._runBattleModel
local var_0_3 = battleEntrance._localHack
local var_0_4 = {
	__cname = "remoteRunnerFuncs"
}

var_0_4.__index = var_0_4

function var_0_4.onStartOK(arg_2_0, arg_2_1)
	arg_2_0._onStartOK = arg_2_1

	return arg_2_0
end

function var_0_4.onRequestCustom(arg_3_0, arg_3_1)
	arg_3_0._onRequestCustom = arg_3_1

	return arg_3_0
end

function var_0_4.onResult(arg_4_0, arg_4_1)
	arg_4_0._onResult = arg_4_1

	return arg_4_0
end

function var_0_4.run(arg_5_0)
	arg_5_0._isRun = true
	arg_5_0._runStarted = true

	function arg_5_0._runBattle()
		var_0_2(arg_5_0)

		arg_5_0._runOver = true
	end

	local var_5_0 = gGameApp:requestServerCustom(arg_5_0._startUrl):params(unpack(arg_5_0._startArgs, 1, arg_5_0._startArgsN))

	var_0_0(arg_5_0._onRequestCustom, var_5_0)
	var_5_0:doit(function(arg_7_0)
		local var_7_0 = gGameModel.battle:getData()

		var_0_0(arg_5_0._onStartOK, var_7_0)

		arg_5_0._data = var_7_0

		var_0_0(arg_5_0._runBattle)
	end)

	return arg_5_0
end

function var_0_4.show(arg_8_0)
	arg_8_0._isShow = true

	local function var_8_0()
		assert(arg_8_0._data, "battle data was nil")
		var_0_1(arg_8_0, function()
			if arg_8_0._runOver then
				assert(arg_8_0._postRespOver, "request must be done before battle.view")
				var_0_3.postEndResultToServer(arg_8_0)
			end
		end, function()
			if arg_8_0._runBattleInLoading then
				var_0_3.onRunBattleModel(arg_8_0)
			end
		end)
	end

	if arg_8_0._runStarted or arg_8_0._runOver then
		if arg_8_0._runOver then
			return var_8_0()
		end

		arg_8_0._runBattleInLoading = arg_8_0._runBattle
		arg_8_0._runBattle = var_8_0

		if arg_8_0._onResult then
			local var_8_1 = arg_8_0._onResult

			function arg_8_0._onResult()
				var_8_1(arg_8_0._data, arg_8_0._results)
			end
		end

		return
	end

	local var_8_2 = gGameApp:requestServerCustom(arg_8_0._startUrl):params(unpack(arg_8_0._startArgs, 1, arg_8_0._startArgsN))

	var_0_0(arg_8_0._onRequestCustom, var_8_2)
	var_8_2:doit(function(arg_13_0)
		local var_13_0 = gGameModel.battle
		local var_13_1 = var_13_0:getData()

		var_0_0(arg_8_0._onStartOK, var_13_1)
		assert(var_13_1, "battle data was nil")

		arg_8_0._data = var_13_1

		var_0_1(arg_8_0, function()
			var_13_0:checkCheat()
			var_0_3.showEndView(arg_8_0)
		end)
	end)
end

function var_0_4.restart(arg_15_0)
	local var_15_0 = arg_15_0._runStarted
	local var_15_1 = arg_15_0._runOver

	assert(arg_15_0._isRun or arg_15_0._isShow, "remote entrance no run and show")

	arg_15_0._runStarted = false
	arg_15_0._runOver = false
	arg_15_0._runBattle = nil
	arg_15_0._runBattleInLoading = nil
	arg_15_0._data = nil
	arg_15_0._results = nil

	if arg_15_0._isRun then
		arg_15_0:run()
	end

	if arg_15_0._isShow then
		arg_15_0:show()
	end
end

function battleEntrance.battleRequest(arg_16_0, ...)
	local var_16_0 = select("#", ...)
	local var_16_1 = {
		...
	}
	local var_16_2 = table.flatArray(var_16_1, var_16_0)

	return setmetatable({
		_post = true,
		_startUrl = arg_16_0,
		_startArgsN = var_16_0,
		_startArgs = var_16_2
	}, var_0_4)
end
