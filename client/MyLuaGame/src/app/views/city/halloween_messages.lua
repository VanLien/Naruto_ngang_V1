local var_0_0 = {}
local var_0_1

function var_0_0.getInstance(arg_1_0)
	if not var_0_1 then
		var_0_1 = arg_1_0:ctor()
	end

	return var_0_1
end

function var_0_0.ctor(arg_2_0)
	arg_2_0.data = {}

	return arg_2_0
end

function var_0_0.clear(arg_3_0)
	arg_3_0.data = {}
end

function var_0_0.set(arg_4_0)
	var_0_0.data = arg_4_0 or {}
end

function var_0_0.get()
	return var_0_0.data or {}
end

function var_0_0.getSpritesPos(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = csv.yunying.halloween_sprites[arg_6_2]
	local var_6_1 = var_6_0.range
	local var_6_2 = var_6_0.randDistance[1]
	local var_6_3 = var_6_0.randDistance[2]
	local var_6_4 = math.random(var_6_2)
	local var_6_5 = math.random(var_6_3)
	local var_6_6 = math.random(4)

	if var_6_6 == 1 then
		if arg_6_0 + var_6_4 >= var_6_1[2][1] or arg_6_1 + var_6_5 >= var_6_1[2][2] or arg_6_0 + var_6_4 <= var_6_1[1][1] or arg_6_1 + var_6_5 <= var_6_1[1][2] then
			return var_0_0.getSpritesPos(arg_6_0, arg_6_1, arg_6_2)
		else
			return arg_6_0 + var_6_4, arg_6_1 + var_6_5, var_6_6
		end
	elseif var_6_6 == 2 then
		if arg_6_0 + var_6_4 >= var_6_1[2][1] or arg_6_1 - var_6_5 >= var_6_1[2][2] or arg_6_0 + var_6_4 <= var_6_1[1][1] or arg_6_1 - var_6_5 <= var_6_1[1][2] then
			return var_0_0.getSpritesPos(arg_6_0, arg_6_1, arg_6_2)
		else
			return arg_6_0 + var_6_4, arg_6_1 - var_6_5, var_6_6
		end
	elseif var_6_6 == 3 then
		if arg_6_0 - var_6_4 >= var_6_1[2][1] or arg_6_1 - var_6_5 >= var_6_1[2][2] or arg_6_0 - var_6_4 <= var_6_1[1][1] or arg_6_1 - var_6_5 <= var_6_1[1][2] then
			return var_0_0.getSpritesPos(arg_6_0, arg_6_1, arg_6_2)
		else
			return arg_6_0 - var_6_4, arg_6_1 - var_6_5, var_6_6
		end
	elseif var_6_6 == 4 then
		if arg_6_0 - var_6_4 >= var_6_1[2][1] or arg_6_1 + var_6_5 >= var_6_1[2][2] or arg_6_0 - var_6_4 <= var_6_1[1][1] or arg_6_1 + var_6_5 <= var_6_1[1][2] then
			return var_0_0.getSpritesPos(arg_6_0, arg_6_1, arg_6_2)
		else
			return arg_6_0 - var_6_4, arg_6_1 + var_6_5, var_6_6
		end
	end
end

function var_0_0.getHalloweenMessages(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_0[arg_7_3] then
		arg_7_0[arg_7_3].num = arg_7_0[arg_7_3].num + 1
		arg_7_0[arg_7_3].x = arg_7_1
		arg_7_0[arg_7_3].y = arg_7_2
	else
		arg_7_0[arg_7_3] = {}
		arg_7_0[arg_7_3].num = 1
		arg_7_0[arg_7_3].x = arg_7_1
		arg_7_0[arg_7_3].y = arg_7_2
		arg_7_0[arg_7_3].clickNum = arg_7_4
	end

	return arg_7_0
end

return var_0_0
