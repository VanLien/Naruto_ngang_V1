local var_0_0 = {
	[battle.BuffTriggerPoint.onHolderDeath] = true,
	[battle.BuffTriggerPoint.onHolderRealDeath] = true
}
local var_0_1 = class("BuffNodeManager")

globals.BuffNodeManager = var_0_1

function var_0_1.ctor(arg_1_0, arg_1_1)
	arg_1_0.buff = arg_1_1
	arg_1_0.globalMgr = arg_1_1.scene.buffGlobalManager
	arg_1_0.nodes = {}
	arg_1_0.nodeIds = {}
	arg_1_0.points = {}
	arg_1_0.times = {}
	arg_1_0.active = {}
	arg_1_0.lifeRounds = {}
	arg_1_0.extraAttack = {}
	arg_1_0.hasDeathTriggerNode = false
end

function var_0_1.init(arg_2_0, arg_2_1)
	arg_2_1 = csvClone(arg_2_1) or {
		{
			nodeId = 0,
			triggerPoint = battle.BuffTriggerPoint.onBuffCreate
		}
	}

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		local var_2_0 = iter_2_1.nodeId

		if var_2_0 and type(var_2_0) == "number" then
			arg_2_0.nodes[var_2_0] = iter_2_1

			table.insert(arg_2_0.nodeIds, var_2_0)

			local var_2_1 = iter_2_1.triggerPoint

			arg_2_0.points[var_2_1] = arg_2_0.points[var_2_1] or {}

			table.insert(arg_2_0.points[var_2_1], var_2_0)
			arg_2_0:preProcessWithNode(var_2_0, iter_2_1)
		end
	end
end

function var_0_1.preProcessWithNode(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_2.triggerPoint

	if arg_3_2.triggerTimes and arg_3_2.triggerTimes[1] <= 2 then
		arg_3_0.times[arg_3_1] = {
			triggerType = arg_3_2.triggerTimes[1],
			value = arg_3_2.triggerTimes[2]
		}
	end

	if arg_3_2.lastRoundsWhenTriggered then
		arg_3_0.lifeRounds[arg_3_1] = arg_3_2.lastRoundsWhenTriggered
	end

	if var_0_0[var_3_0] then
		arg_3_0.hasDeathTriggerNode = true
	end
end

function var_0_1.check(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.nodes[arg_4_1]

	if not var_4_0 then
		return false
	end

	if not (function(arg_5_0)
		if not arg_5_0 then
			return true
		end

		if arg_5_0.triggerType == 1 then
			return arg_5_0.value > 0
		elseif arg_5_0.triggerType == 2 then
			return arg_5_0.value > 0 and arg_4_0.active[arg_4_1] ~= arg_4_0.buff.lifeRound
		end
	end)(arg_4_0.times[arg_4_1]) then
		return false
	end

	local var_4_1 = {
		c2 = true,
		c5 = true,
		c3 = true,
		c1 = true,
		c4 = true
	}

	if var_4_0.onSkillType and not arg_4_0.buff:onSkillType(var_4_0.onSkillType) then
		var_4_1.c1 = false
	end

	if var_4_0.onCurHP then
		local var_4_2 = var_4_0.onCurHP

		if not arg_4_0.buff:onCurHP(var_4_2.valueType, var_4_2.value, var_4_2.comp) then
			var_4_1.c2 = false
		end
	end

	if var_4_0.onSkillDamage then
		local var_4_3 = var_4_0.onSkillDamage

		if not arg_4_0.buff:onSkillDamage(var_4_3.valueType, var_4_3.value, var_4_3.comp) then
			var_4_1.c3 = false
		end
	end

	if var_4_0.onSomeFlag then
		local var_4_4 = var_4_0.onSomeFlag

		if not arg_4_0.buff:onSomeFlag(var_4_4) then
			var_4_1.c4 = false
		end
	end

	if var_4_0.conditionExpr then
		return battleCsv.doFormula(var_4_0.conditionExpr, {
			conditionT = var_4_1
		})
	else
		return not itertools.include(var_4_1, function(arg_6_0)
			return arg_6_0 == false
		end)
	end
end

function var_0_1.visitNodeByPoint(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.points[arg_7_1]

	if var_7_0 == nil then
		return
	end

	local var_7_1 = arg_7_0.nodes

	for iter_7_0 = 1, table.length(var_7_0) do
		local var_7_2 = var_7_0[iter_7_0]

		arg_7_2(var_7_2, var_7_1[var_7_2])
	end
end

function var_0_1.filterNodeByPoint(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.points[arg_8_1]

	if var_8_0 == nil then
		return false
	end

	local var_8_1 = arg_8_0.nodes

	for iter_8_0 = 1, table.length(var_8_0) do
		local var_8_2 = var_8_0[iter_8_0]

		if arg_8_2(var_8_2, var_8_1[var_8_2]) then
			return true
		end
	end

	return false
end

function var_0_1.trigger(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.nodes[arg_9_1]

	if not arg_9_0.active[arg_9_1] then
		arg_9_0.active[arg_9_1] = arg_9_0.buff.lifeRound
	end

	if arg_9_0.times[arg_9_1] then
		arg_9_0.times[arg_9_1].value = arg_9_0.times[arg_9_1].value - 1
	end

	if arg_9_1 == 0 and arg_9_0.nodes[arg_9_1] and arg_9_0.nodes[arg_9_1].triggerPoint ~= battle.BuffTriggerPoint.onBuffTrigger and not arg_9_0.buff:isSpecBuff() then
		arg_9_0.buff.scene.buffGlobalManager:refreshBuffLimit(arg_9_0.buff.scene, arg_9_0.buff)
	end

	return var_9_0
end

function var_0_1.onTriggerEnd(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.nodes[arg_10_1]

	if arg_10_2 then
		if var_10_0.trueCall then
			for iter_10_0, iter_10_1 in ipairs(var_10_0.trueCall) do
				if iter_10_1 ~= arg_10_1 then
					arg_10_0.buff:triggerByNode(iter_10_1)
				end
			end
		end
	elseif var_10_0.falseCall then
		for iter_10_2, iter_10_3 in ipairs(var_10_0.falseCall) do
			if iter_10_3 ~= arg_10_1 then
				arg_10_0.buff:triggerByNode(iter_10_3)
			end
		end
	end

	if var_10_0.delSelfWhenTriggered == 1 and (not arg_10_0.times[arg_10_1] or not (arg_10_0.times[arg_10_1].value > 0)) then
		arg_10_0.buff:over()
	end
end

function var_0_1.resetNode(arg_11_0, arg_11_1)
	if arg_11_0.times[arg_11_1] == nil then
		return
	end

	arg_11_0.times[arg_11_1] = {
		triggerType = arg_11_0.nodes[arg_11_1].triggerTimes[1],
		value = arg_11_0.nodes[arg_11_1].triggerTimes[2]
	}
end

function var_0_1.update(arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in arg_12_0:ipairsNodes() do
		if arg_12_0.lifeRounds[iter_12_0] and arg_12_0.active[iter_12_0] then
			arg_12_0.lifeRounds[iter_12_0] = arg_12_0.lifeRounds[iter_12_0] - arg_12_1

			if arg_12_0.lifeRounds[iter_12_0] <= 0 then
				arg_12_0.buff:over()

				return
			end
		end
	end
end

function var_0_1.ipairsNodes(arg_13_0)
	local var_13_0 = 0

	return function()
		var_13_0 = var_13_0 + 1

		return arg_13_0.nodeIds[var_13_0], arg_13_0.nodes[arg_13_0.nodeIds[var_13_0]]
	end
end

function var_0_1.isNoDeathTrigger(arg_15_0)
	return not arg_15_0.hasDeathTriggerNode
end

function var_0_1.isNode0TriggerPoint(arg_16_0, arg_16_1)
	if not arg_16_0.nodes[0] then
		return false
	end

	return arg_16_0.nodes[0].triggerPoint == arg_16_1
end

function var_0_1.isTriggerPointExist(arg_17_0, arg_17_1)
	return arg_17_0.points[arg_17_1] ~= nil
end

local var_0_2 = setmetatable({}, {
	__newindex = function()
		error("EmptyTable readonly")
	end
})

function var_0_1.getExtraAttack(arg_19_0, arg_19_1)
	if arg_19_0.extraAttack[arg_19_1] == nil then
		local var_19_0 = {}

		arg_19_0.extraAttack[arg_19_1] = var_19_0

		arg_19_0:visitNodeByPoint(arg_19_1, function(arg_20_0, arg_20_1)
			local var_20_0 = arg_20_1.extraAttackTrigger

			if var_20_0 then
				var_19_0[var_20_0] = true
			end
		end)
	end

	return arg_19_0.extraAttack[arg_19_1] or var_0_2
end
