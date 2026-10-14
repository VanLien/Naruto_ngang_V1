local var_0_0 = maptools.extend({
	battleTarget.input,
	battleTarget.input.decorator,
	battleTarget.process
})

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	if type(iter_0_1) == "function" then
		setfenv(iter_0_1, var_0_0)
	end
end

var_0_0.battle = battle

local var_0_1 = protectedEnv(var_0_0)

local function var_0_2(arg_1_0, arg_1_1)
	if arg_1_0:sub(1, 1) == "|" then
		arg_1_0 = arg_1_0:sub(2)
	end

	local var_1_0 = string.split(arg_1_0, "|")
	local var_1_1 = arg_1_1 or ""

	for iter_1_0, iter_1_1 in ipairs(var_1_0) do
		local var_1_2, var_1_3 = string.find(iter_1_1, "%(.+%)")
		local var_1_4, var_1_5 = string.find(iter_1_1, "%(.*%)")
		local var_1_6 = ""
		local var_1_7 = -2

		if not var_1_4 then
			iter_1_1 = iter_1_1 .. "()"
		end

		if var_1_1 == "" then
			var_1_1 = iter_1_1
		else
			iter_1_1 = iter_1_1:sub(1, var_1_7) .. (var_1_2 and ",%s)" or "%s)")
			var_1_1 = string.format(iter_1_1, var_1_1)
		end
	end

	return var_1_1
end

function battleTarget.targetFinder(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.input

	if arg_2_2.process and arg_2_2.process ~= "" then
		var_2_0 = string.format("%s|%s", arg_2_2.input, arg_2_2.process)
	end

	local var_2_1 = var_0_2(var_2_0)

	log.targetFinder.funcStr("目标查找函数", var_2_1)

	local var_2_2 = battleCsv.makeFindEnv(arg_2_0, arg_2_1, arg_2_3)
	local var_2_3 = battleCsv.doFormula(var_2_1, var_0_1:fillEnv(var_2_2))

	var_0_1:resetEnv()
	log.targetFinder.find("查找到目标", lazydumps(var_2_3, function()
		local var_3_0 = 0

		for iter_3_0, iter_3_1 in pairs(var_2_3) do
			print(string.format("%s:\t%s %d", iter_3_0, tostring(iter_3_1), iter_3_1.seat))

			var_3_0 = var_3_0 + 1
		end

		return string.format("%s 个", var_3_0)
	end))

	return var_2_3
end
