local var_0_0 = display.director:getScheduler()
local var_0_1 = var_0_0.setTimeScale
local var_0_2 = var_0_0.getTimeScale
local var_0_3 = 1
local var_0_4 = 1
local var_0_5 = 1
local var_0_6 = 1
local var_0_7 = false
local var_0_8 = 0

local function var_0_9()
	var_0_6 = var_0_3

	if var_0_8 <= 0 and var_0_7 then
		var_0_6 = ((var_0_4 - 1) * var_0_5 + 1) * var_0_3
	end

	printInfo("updateSpeedUp timeScale = %s speedUp = %s", var_0_3, var_0_6)
	var_0_1(var_0_0, var_0_6)
end

local function var_0_10(arg_2_0)
	return var_0_3
end

local function var_0_11(arg_3_0, arg_3_1)
	var_0_3 = arg_3_1

	var_0_9()
end

function var_0_0.getSpeedUp(arg_4_0)
	return var_0_6
end

local var_0_12 = class("TimeSpeederManager")

function var_0_12.ctor(arg_5_0)
	var_0_0.getTimeScale = var_0_10
	var_0_0.setTimeScale = var_0_11
end

function var_0_12.onClose(arg_6_0)
	arg_6_0.clearSpeeder()

	var_0_0.setTimeScale = var_0_1
	var_0_0.getTimeScale = var_0_2
end

function var_0_12.setTimeRate(arg_7_0)
	var_0_5 = arg_7_0

	var_0_9()
end

function var_0_12.setTimeSpeed(arg_8_0)
	var_0_4 = arg_8_0

	var_0_9()
end

function var_0_12.getTimeSpeedEnabled()
	return var_0_7
end

function var_0_12.setTimeSpeedEnabled(arg_10_0)
	var_0_7 = arg_10_0

	var_0_9()
end

function var_0_12.yieldSpeeder()
	var_0_8 = var_0_8 + 1

	var_0_9()
end

function var_0_12.resumeSpeeder()
	var_0_8 = math.max(0, var_0_8 - 1)

	var_0_9()
end

function var_0_12.isYield()
	return var_0_8 > 0
end

function var_0_12.clearSpeeder()
	var_0_7 = false
	var_0_4 = 1
	var_0_5 = 1
	var_0_8 = 0

	var_0_9()
end

function var_0_12.get3rdSpeedScale(arg_15_0, arg_15_1)
	local var_15_0 = socket.gettime()
	local var_15_1 = 0
	local var_15_2 = arg_15_0 * 60
	local var_15_3

	var_15_3 = var_0_0:scheduleScriptFunc(function(arg_16_0)
		var_15_1 = var_15_1 + arg_16_0
		var_15_2 = var_15_2 - 1

		if var_15_2 == 0 then
			var_0_0:unscheduleScriptEntry(var_15_3)

			local var_16_0 = mathEasy.getPreciseDecimal(var_15_1 / (socket.gettime() - var_15_0) / var_0_0:getTimeScale(), 0, true)

			printInfo("第三方加速器倍速:" .. var_16_0)

			if arg_15_1 then
				arg_15_1(var_16_0)
			end
		end
	end, 0, false)
end

return var_0_12
