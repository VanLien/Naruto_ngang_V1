function battleCsv.getFixedOrPercent(arg_1_0)
	local var_1_0 = 0
	local var_1_1 = 0

	if arg_1_0 then
		arg_1_0 = tostring(arg_1_0)   -- FIX nil crash

		local var_1_2 = string.find(arg_1_0, "%%")

		if var_1_2 then
			var_1_1 = tonumber(string.sub(arg_1_0, 1, var_1_2 - 1)) / 100
		else
			var_1_0 = tonumber(arg_1_0) or 0
		end
	end

	return var_1_0, var_1_1
end

function battleCsv.hasBuffGroup(arg_2_0, arg_2_1)
	if arg_2_0 then
		for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
			if iter_2_1[arg_2_1] then
				return true, iter_2_0
			end
		end
	end

	return false, nil
end
