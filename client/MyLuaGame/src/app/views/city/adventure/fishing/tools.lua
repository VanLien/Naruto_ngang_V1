return {
	getExp = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = csv.fishing.level[arg_1_0]
		local var_1_1 = 0
		local var_1_2 = 0
		local var_1_3 = 0
		local var_1_4 = 0
		local var_1_5 = 0
		local var_1_6 = 0

		if arg_1_1 ~= nil then
			if arg_1_1[1] ~= nil then
				var_1_1 = arg_1_1[1] < var_1_0.lowNum and arg_1_1[1] or var_1_0.lowNum
				var_1_4 = arg_1_1[1]
			end

			if arg_1_1[2] ~= nil then
				var_1_2 = arg_1_1[2] < var_1_0.middleNum and arg_1_1[2] or var_1_0.middleNum
				var_1_5 = arg_1_1[2]
			end

			if arg_1_1[3] ~= nil then
				var_1_3 = arg_1_1[3] < var_1_0.highNum and arg_1_1[3] or var_1_0.highNum
				var_1_6 = arg_1_1[3]
			end
		end

		local var_1_7 = var_1_4 + var_1_5 + var_1_6

		if var_1_7 > var_1_0.totalNum then
			var_1_7 = var_1_0.totalNum
		end

		local var_1_8 = var_1_0.totalNum == 0 and 0 or var_1_7
		local var_1_9 = var_1_0.lowNum + var_1_0.middleNum + var_1_0.highNum + var_1_0.totalNum + (var_1_0.targetNum[1] or 0)
		local var_1_10 = var_1_1 + var_1_2 + var_1_3 + arg_1_2 + var_1_8
		local var_1_11 = var_1_10

		for iter_1_0 = 1, arg_1_0 do
			local var_1_12 = csv.fishing.level[iter_1_0]

			var_1_11 = var_1_11 + var_1_12.lowNum + var_1_12.middleNum + var_1_12.highNum + var_1_12.totalNum + (var_1_12.targetNum[1] or 0)
		end

		return var_1_10, var_1_9, var_1_11
	end
}
