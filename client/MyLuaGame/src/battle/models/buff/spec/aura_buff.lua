local var_0_0 = class("AuraBuffModel", BuffModel)

globals.AuraBuffModel = var_0_0

function var_0_0.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	BuffModel.ctor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	arg_1_0.auraRef = 1
	arg_1_0.isAuraType = true
	arg_1_0.casters = {
		[arg_1_3.id] = true
	}
end

function var_0_0.refreshAuraRef(arg_2_0, arg_2_1)
	arg_2_0.auraRef = arg_2_0.auraRef + (arg_2_1 and arg_2_1 or 1)

	if arg_2_0.auraRef <= 0 then
		arg_2_0:alterAuraBuffValue(0)
	end
end

function var_0_0.addCaster(arg_3_0, arg_3_1)
	arg_3_0.casters[arg_3_1.id] = true
end

function var_0_0.over(arg_4_0, arg_4_1)
	if arg_4_0.auraRef > 1 then
		arg_4_0:refreshAuraRef(-1)

		return
	end

	BuffModel.over(arg_4_0, arg_4_1)

	for iter_4_0, iter_4_1 in pairs(arg_4_0.casters) do
		local var_4_0 = arg_4_0.scene:getObject(iter_4_0)

		if var_4_0 then
			var_4_0.auraBuffs:erase(arg_4_0.id)
		end
	end
end

function var_0_0.alterAuraBuffValue(arg_5_0, arg_5_1)
	if not arg_5_0.isNumberType then
		return
	end

	if type(arg_5_1) == "string" then
		arg_5_1 = arg_5_0:cfg2Value(arg_5_1)
	end

	arg_5_0:setValue(arg_5_1)
	arg_5_0:refreshLerpValue(false)
end

local function var_0_1(arg_6_0)
	if type(arg_6_0[1]) ~= "table" then
		return {
			arg_6_0
		}
	end

	return arg_6_0
end

function var_0_0.getBuffEffectFunc(arg_7_0, arg_7_1)
	if arg_7_1 == "addAttr" and not arg_7_0.args.isFixValue then
		return function(arg_8_0, arg_8_1, arg_8_2)
			local var_8_0 = {}

			for iter_8_0, iter_8_1 in ipairs(var_0_1(arg_8_1)) do
				local var_8_1 = iter_8_1.attr
				local var_8_2 = iter_8_1.val

				if var_8_1 == "speed" then
					if not arg_8_2 then
						arg_8_0.holder.attrs:addAuraAttr(var_8_1, var_8_2)

						arg_8_0.triggerAddAttrTb[var_8_1] = arg_8_0.triggerAddAttrTb[var_8_1] and arg_8_0.triggerAddAttrTb[var_8_1] + var_8_2 or var_8_2
					else
						arg_8_0.holder.attrs:addAuraAttr(var_8_1, -(arg_8_0.triggerAddAttrTb[var_8_1] or 0))

						arg_8_0.triggerAddAttrTb[var_8_1] = nil
					end
				else
					table.insert(var_8_0, {
						attr = var_8_1,
						val = var_8_2
					})
				end
			end

			if table.length(var_8_0) > 0 then
				BuffModel.getBuffEffectFunc(arg_7_0, "addAttr")(arg_8_0, var_8_0, arg_8_2)
			end

			return true
		end
	end

	return BuffModel.getBuffEffectFunc(arg_7_0, arg_7_1)
end

function var_0_0.toHumanString(arg_9_0)
	return string.format("AuraBuffModel: %s(%s)", arg_9_0.id, arg_9_0.cfgId)
end
