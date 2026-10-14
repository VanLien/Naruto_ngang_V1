globals.battleCsv = {}

function battleCsv.exportToCsvCls(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		if iter_1_1 == 0 then
			assert(arg_1_0[iter_1_0] == nil, "exportToCsvCls function " .. iter_1_0 .. " is in csv")

			arg_1_0[iter_1_0] = function(arg_2_0, ...)
				return arg_2_0.model[iter_1_0](arg_2_0.model, ...)
			end
		else
			arg_1_0[iter_1_0] = function(arg_3_0, ...)
				local var_3_0 = arg_3_0.model[iter_1_0](arg_3_0.model, ...)
				local var_3_1 = battleCsv.Model2CsvCls[type(var_3_0)]

				if var_3_1 then
					return var_3_1.new(var_3_0)
				end

				return var_3_0
			end
		end
	end
end

function battleCsv.newCsvCls(arg_4_0)
	local var_4_0 = setmetatable({}, {
		__newindex = function(arg_5_0, arg_5_1, arg_5_2)
			if type(arg_5_2) == "function" then
				arg_5_2 = functools.wrap(arg_5_2, function(arg_6_0, arg_6_1, ...)
					if arg_6_1.model or arg_5_0.ignoreModelCheck[arg_5_1] then
						return arg_6_0(arg_6_1, ...)
					end

					return 0
				end)
			end

			rawset(arg_5_0, arg_5_1, arg_5_2)
		end
	})

	var_4_0.__cname = arg_4_0
	var_4_0.__index = var_4_0
	var_4_0.ignoreModelCheck = {}

	rawset(var_4_0, "new", function(arg_7_0)
		local var_7_0 = {
			model = arg_7_0
		}

		if arg_7_0 then
			arg_7_0:setCsvObject(var_7_0)
		end

		return setmetatable(var_7_0, var_4_0)
	end)

	return var_4_0
end

require("battle.csv.data")
require("battle.csv.buff")
require("battle.csv.scene")
require("battle.csv.skill")
require("battle.csv.object")
require("battle.csv.export")

battleCsv.NilBuff = battleCsv.CsvBuff.new()
battleCsv.NilSkill = battleCsv.CsvSkill.new()
battleCsv.NilObject = battleCsv.CsvObject.new()
