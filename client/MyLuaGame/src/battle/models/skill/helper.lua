local var_0_0 = {}

globals.skillHelper = var_0_0

function var_0_0.natureRestraint(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if not arg_1_0 then
		return
	end

	local var_1_0 = game.NATURE_TABLE[arg_1_1:getNature(arg_1_2)]

	return var_0_0.getNatureMatrix(arg_1_0, var_1_0, arg_1_3, arg_1_4)
end

local function var_0_1(arg_2_0)
	if ANTI_AGENT then
		return
	end

	checkSpecificCsvCheat({
		"base_attribute",
		"nature_matrix"
	}, itertools.ivalues({
		arg_2_0
	}))
end

function var_0_0.getNatureMatrix(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0 and arg_3_1 and csv.base_attribute.nature_matrix[arg_3_0] then
		var_0_1(arg_3_0)

		local var_3_0 = csv.base_attribute.nature_matrix[arg_3_0][arg_3_1]
		local var_3_1 = 0

		if var_3_0 > 1 then
			var_3_1 = math.max(-arg_3_3, 1 - var_3_0)
		end

		if var_3_0 > 1 or arg_3_0 == 1 and var_3_0 >= 1 then
			var_3_1 = var_3_1 + arg_3_2
		end

		return var_3_0 + var_3_1
	end

	return 1
end

function var_0_0.getNatureFlag(arg_4_0)
	if math.abs(arg_4_0 - 1) < 0.01 then
		return "normal", 1
	elseif arg_4_0 > 1 then
		return "strong", string.format("%.2f", arg_4_0)
	elseif arg_4_0 > 0 then
		return "weak", string.format("%.2f", arg_4_0)
	else
		return "fullweak", 0
	end
end

function var_0_0.natureRestraintType(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0

	arg_5_2 = arg_5_2 or 0
	arg_5_3 = arg_5_3 or 0

	local var_5_1 = var_0_0.natureRestraint(arg_5_0, arg_5_1, 1, arg_5_2, arg_5_3) or 1
	local var_5_2 = var_0_0.natureRestraint(arg_5_0, arg_5_1, 2, arg_5_2, arg_5_3) or 1
	local var_5_3 = 1 + (var_5_1 - 1) + (var_5_2 - 1)

	return var_0_0.getNatureFlag(var_5_3)
end

return var_0_0
