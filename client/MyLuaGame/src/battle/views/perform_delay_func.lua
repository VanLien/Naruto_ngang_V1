require("battle.views.manage_cd")

local var_0_0 = class("PerformDelayFunc")

globals.PerformDelayFunc = var_0_0

function var_0_0.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.startCd = CManageCd.new(arg_1_1)
	arg_1_0.func = arg_1_2
	arg_1_0.args = arg_1_3
	arg_1_0.processOver = false
end

function var_0_0.isOver(arg_2_0)
	if arg_2_0.processOver then
		return true
	end

	return false
end

function var_0_0.update(arg_3_0, arg_3_1)
	arg_3_0.startCd:update(arg_3_1)

	if arg_3_0.startCd:isCdOk() then
		arg_3_0.processOver = true

		if arg_3_0.args then
			arg_3_0.func(unpack(arg_3_0.args))
		else
			arg_3_0.func()
		end
	end
end
