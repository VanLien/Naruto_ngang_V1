local var_0_0 = {}
local var_0_1

function var_0_0.getInstance(arg_1_0)
	if not var_0_1 then
		var_0_1 = arg_1_0:ctor()
	end

	return var_0_1
end

function var_0_0.ctor(arg_2_0)
	arg_2_0:initModel()
	idlereasy.when(arg_2_0.battleMessages, function(arg_3_0, arg_3_1)
		if itertools.size(arg_3_1) > 0 then
			local var_3_0 = {}

			for iter_3_0 = #arg_3_1, 1, -1 do
				local var_3_1 = arg_3_1[iter_3_0]

				if var_3_1[6] > 2 then
					local var_3_2 = {}

					var_3_2[1] = "streak"
					var_3_2[2] = var_3_1[4] == "win" and var_3_1[2] or var_3_1[3]
					var_3_2[3] = var_3_1[6]

					table.insert(var_3_0, var_3_2)
				end

				table.insert(var_3_0, var_3_1)

				arg_2_0.data = var_3_0
			end
		end
	end)
	idlereasy.when(arg_2_0.round, function(arg_4_0, arg_4_1)
		if arg_4_1 == "prepare" then
			arg_2_0.data = {}
		end
	end)

	return arg_2_0
end

function var_0_0.initModel(arg_5_0)
	local var_5_0 = gGameModel.craft

	arg_5_0.battleMessages = var_5_0:getIdler("battle_messages")
	arg_5_0.round = var_5_0:getIdler("round")
end

function var_0_0.set(arg_6_0)
	var_0_0.data = arg_6_0 or {}
end

function var_0_0.get()
	return var_0_0.data or {}
end

return var_0_0
