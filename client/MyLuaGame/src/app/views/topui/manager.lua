local var_0_0 = class("TopuiManager")

function var_0_0.ctor(arg_1_0)
	arg_1_0.map = {}
	arg_1_0.mapIDCounter = 0
	arg_1_0.topView = 0
end

function var_0_0.createView(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_1 = arg_2_1 or "default"

	local var_2_0 = string.format("topui.views.%s", arg_2_1)
	local var_2_1 = gGameUI:createView(var_2_0, arg_2_2, arg_2_3)

	arg_2_0.mapIDCounter = arg_2_0.mapIDCounter + 1
	arg_2_0.topView = var_2_1
	arg_2_0.map[var_2_1] = {
		parent = arg_2_2,
		name = arg_2_1,
		view = var_2_1,
		id = arg_2_0.mapIDCounter
	}

	var_2_1:onNodeEvent("exit", functools.partial(arg_2_0.removeView, arg_2_0, var_2_1))

	return var_2_1
end

function var_0_0.removeView(arg_3_0, arg_3_1)
	if arg_3_0.map[arg_3_1] then
		if arg_3_1 == arg_3_0.topView then
			arg_3_0.topView = nil
		end

		arg_3_0.map[arg_3_1] = nil

		arg_3_1:removeSelf()

		return true
	end
end

function var_0_0.updateTitle(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0.topView == nil then
		local var_4_0 = 0

		for iter_4_0, iter_4_1 in pairs(arg_4_0.map) do
			if var_4_0 < iter_4_1.id then
				var_4_0 = iter_4_1.id
				arg_4_0.topView = iter_4_1.view
			end
		end
	end

	local var_4_1 = arg_4_0.map[arg_4_0.topView]

	if var_4_1 then
		var_4_1.view:updateTitle(arg_4_1, arg_4_2)
	end
end

return var_0_0
