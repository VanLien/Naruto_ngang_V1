local var_0_0 = 0
local var_0_1 = class("prefab")

function var_0_1.ctor(arg_1_0, arg_1_1)
	var_0_0 = var_0_0 + 1
	arg_1_0.id = var_0_0
	arg_1_0.node = arg_1_1
	arg_1_0.unit = {}
	arg_1_0.roleData = {}
	arg_1_0.selectShowChild = {
		"select",
		"add",
		"del"
	}
	arg_1_0.roleId = 0
end

function var_0_1.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.unit = csv.unit[arg_2_1]
	arg_2_0.card = csv.cards[arg_2_0.unit.cardID]
	arg_2_0.roleId = arg_2_1
	arg_2_0.roleData.roleId = arg_2_1

	if arg_2_0.node then
		arg_2_0.node:setName("prefab_" .. var_0_0)

		if arg_2_0.unit.icon then
			arg_2_0.node:get("icon"):texture(arg_2_0.unit.iconSimple)
		end
	end

	if arg_2_2 then
		for iter_2_0, iter_2_1 in pairs(arg_2_2) do
			arg_2_0.roleData[iter_2_0] = iter_2_1
		end
	end

	if arg_2_0.roleData then
		if arg_2_0.roleData.skills and next(arg_2_0.roleData.skills) then
			for iter_2_2, iter_2_3 in pairs(arg_2_0.roleData.skills) do
				arg_2_0.roleData.skills[iter_2_2] = arg_2_0.roleData.skills[iter_2_2] or arg_2_0.roleData.level
			end
		end

		local var_2_0 = 0

		if not arg_2_0.roleData.skills then
			arg_2_0.roleData.skills = {}
		end

		for iter_2_4, iter_2_5 in pairs(arg_2_0.unit.skillList) do
			arg_2_0.roleData.skills[iter_2_5] = arg_2_0.roleData.skills[iter_2_5] or arg_2_0.roleData.level
			var_2_0 = math.floor(iter_2_5 / 10)
		end

		for iter_2_6, iter_2_7 in pairs(arg_2_0.unit.passiveSkillList) do
			arg_2_0.roleData.skills[iter_2_7] = arg_2_0.roleData.skills[iter_2_7] or arg_2_0.roleData.level
		end

		local var_2_1 = 10 * var_2_0 + 6

		arg_2_0.roleData.skills[var_2_1] = arg_2_0.roleData.skills[var_2_1] or arg_2_0.roleData.level
	end

	if arg_2_0.unit.twinFlag then
		local var_2_2

		for iter_2_8, iter_2_9 in orderCsvPairs(csv.cards) do
			if iter_2_9.cardMarkID == arg_2_0.card.cardMarkID and iter_2_8 ~= arg_2_0.unit.cardID then
				var_2_2 = iter_2_8
			end
		end

		if var_2_2 and not arg_2_0.roleData.role2Data then
			local var_2_3 = clone(arg_2_2)

			var_2_3.roleId = csv.cards[var_2_2].unitID
			var_2_3.skills = {}

			local var_2_4 = csv.cards[var_2_2].skillList

			for iter_2_10 = 1, 4 do
				local var_2_5 = var_2_4[iter_2_10]

				var_2_3.skills[var_2_5] = var_2_3.skills[var_2_5] or var_2_3.level
			end

			arg_2_0.roleData.role2Data = var_2_3
		end
	end
end

function var_0_1.clean(arg_3_0)
	arg_3_0.node:removeFromParent()
end

function var_0_1.getRoleData(arg_4_0)
	return csvClone(arg_4_0.roleData)
end

return var_0_1
