function battleEasy.getRowAndColumn(arg_1_0)
	local var_1_0 = arg_1_0

	if type(arg_1_0) ~= "number" then
		var_1_0 = arg_1_0.seat
	end

	local var_1_1 = 2 - math.floor((var_1_0 + 2) / 3) % 2
	local var_1_2 = (var_1_0 - 1) % 3 + 1

	return var_1_1, var_1_2
end

local var_0_0 = {
	7,
	8,
	9,
	10,
	11,
	12,
	1,
	2,
	3,
	4,
	5,
	6,
	14,
	13
}

function battleEasy.mirrorSeat(arg_2_0)
	return var_0_0[arg_2_0]
end

local var_0_1 = {
	1,
	2,
	3,
	4,
	5,
	6,
	13
}

function battleEasy.getForce(arg_3_0)
	return (arg_3_0 == 13 or arg_3_0 <= 6) and 1 or 2
end
