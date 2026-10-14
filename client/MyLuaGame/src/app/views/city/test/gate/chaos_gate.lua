local var_0_0 = require("app.views.city.test.gate.gate")
local var_0_1 = class("ChaosGate", var_0_0)

function var_0_1.getFightRoleData(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = 4023
	local var_1_2 = #arg_1_0.scene
	local var_1_3 = 12
	local var_1_4
	local var_1_5 = arg_1_0.parent.resources

	while var_1_3 ~= 0 do
		local var_1_6 = var_1_1 + var_1_2 * 1000
		local var_1_7 = math.random(var_1_6)

		if var_1_3 <= var_1_2 or var_1_1 < var_1_7 and var_1_2 > 0 then
			var_1_0[var_1_3] = arg_1_0.scene[var_1_2]:getRoleData()
			var_1_2 = var_1_2 - 1
		elseif csv.unit[var_1_7] then
			local var_1_8 = false

			if not var_1_5[var_1_7] then
				arg_1_0.parent:addRes(var_1_7)

				var_1_8 = true
			end

			local var_1_9 = var_1_5[var_1_7]

			var_1_0[var_1_3] = var_1_9:getRoleData()

			if var_1_8 then
				arg_1_0.parent:delRes(var_1_9)
			end
		else
			var_1_3 = var_1_3 + 1
		end

		var_1_3 = var_1_3 - 1
	end

	return {
		var_1_0
	}
end

return var_0_1
