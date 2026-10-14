function battleEasy.randomGetByArray(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {}
	local var_1_1 = table.length(arg_1_0)

	arg_1_3 = arg_1_3 or function(arg_2_0)
		return arg_2_0
	end
	arg_1_2 = arg_1_2 or function()
		return ymrand.random() > 0.5
	end

	for iter_1_0 = 1, table.length(arg_1_0) do
		if var_1_1 <= arg_1_1 or arg_1_2(arg_1_0[iter_1_0]) then
			arg_1_1 = arg_1_1 - 1

			table.insert(var_1_0, arg_1_3(arg_1_0[iter_1_0], table.length(var_1_0) + 1))
		end
	end

	return var_1_0
end

function battleEasy.groupReltaionInclude(arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in ipairs(arg_4_0) do
		if iter_4_1[arg_4_1] then
			return true
		end
	end

	return false
end

function battleEasy.numEqual(arg_5_0, arg_5_1)
	return math.abs(arg_5_0 - arg_5_1) < 1e-05
end

function battleEasy.ifElse(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0 then
		return arg_6_1
	end

	return arg_6_2
end

function battleEasy.getSkillTab(arg_7_0)
	local var_7_0 = csv.unit[arg_7_0]
	local var_7_1 = csv.cards[arg_7_0]
	local var_7_2 = {}

	if not var_7_0 and not var_7_1 then
		errorInWindows("getSkillTab %d unitCfg or cardCfg exit nil", arg_7_0)
	end

	if var_7_0 then
		for iter_7_0, iter_7_1 in ipairs(var_7_0.skillList) do
			var_7_2[iter_7_1] = 1
		end

		for iter_7_2, iter_7_3 in ipairs(var_7_0.passiveSkillList) do
			var_7_2[iter_7_3] = 1
		end
	end

	if var_7_1 then
		for iter_7_4, iter_7_5 in ipairs(var_7_1.skillList) do
			var_7_2[iter_7_5] = 1
		end
	end

	return var_7_2
end

function battleEasy.getItemInPowerMap(arg_8_0, arg_8_1)
	local var_8_0 = 0

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if iter_8_1 and arg_8_0[iter_8_0] then
			var_8_0 = var_8_0 + iter_8_1
		end
	end

	local var_8_1 = ymrand.random()
	local var_8_2 = 0

	for iter_8_2 = 1, table.length(arg_8_1) do
		if arg_8_0[iter_8_2] then
			local var_8_3 = arg_8_1[iter_8_2] / var_8_0

			if var_8_1 <= var_8_3 then
				return arg_8_0[iter_8_2]
			else
				var_8_1 = var_8_1 - var_8_3
			end
		end
	end
end

function battleEasy.isSameSkillType(arg_9_0, arg_9_1)
	if arg_9_0 == battle.SkillFormulaType.fix then
		return true
	end

	if arg_9_1 == battle.SkillFormulaType.fix then
		return true
	end

	return arg_9_0 == arg_9_1
end

function battleEasy.isCompleteLeave(arg_10_0)
	if arg_10_0:checkOverlaySpecBuffExit("leave") then
		return true
	end

	if arg_10_0:checkOverlaySpecBuffExit("depart") then
		for iter_10_0, iter_10_1 in arg_10_0:ipairsOverlaySpecBuffTo("depart") do
			if iter_10_1.leaveSwitch then
				return true
			end
		end
	end

	return false
end

function battleEasy.getUnifyBuffArgs(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = {
		buffValueFormulaEnv = arg_11_3
	}

	if arg_11_0 == "skill_process" then
		var_11_0.buffValueFormula = arg_11_1.buffValue1[arg_11_2.index]
	elseif arg_11_0 == "buff" then
		var_11_0.value = arg_11_1.value
		var_11_0.buffValueFormula = arg_11_1.buffValueFormula
		var_11_0.skillCfg = arg_11_1.skillCfg
	end

	for iter_11_0, iter_11_1 in pairs(arg_11_2) do
		var_11_0[iter_11_0] = iter_11_1
	end

	return var_11_0
end

function battleEasy.alterDmgRecordVals(arg_12_0, arg_12_1)
	local var_12_0 = {}

	local function var_12_1(arg_13_0, arg_13_1, arg_13_2)
		var_12_0[arg_13_0] = var_12_0[arg_13_0] or {}

		for iter_13_0, iter_13_1 in pairs(arg_13_1) do
			var_12_0[arg_13_0][iter_13_0] = var_12_0[arg_13_0][iter_13_0] or {}

			table.insert(var_12_0[arg_13_0][iter_13_0], {
				data = iter_13_1,
				priority = arg_13_2
			})
		end
	end

	for iter_12_0, iter_12_1 in arg_12_0:ipairsOverlaySpecBuff("alterDmgRecordVal") do
		if iter_12_1.assignObject == 1 or iter_12_1.assignObject == 3 then
			var_12_1(iter_12_1.typ, iter_12_1.alterDmgRecordData, iter_12_1.priority)
		end
	end

	for iter_12_2, iter_12_3 in arg_12_1:ipairsOverlaySpecBuff("alterDmgRecordVal") do
		if iter_12_3.assignObject == 2 or iter_12_3.assignObject == 3 then
			var_12_1(iter_12_3.typ, iter_12_3.alterDmgRecordData, iter_12_3.priority)
		end
	end

	for iter_12_4, iter_12_5 in pairs(var_12_0) do
		for iter_12_6, iter_12_7 in pairs(iter_12_5) do
			table.sort(iter_12_7, function(arg_14_0, arg_14_1)
				return arg_14_0.priority < arg_14_1.priority
			end)
		end
	end

	return var_12_0[1] or {}, var_12_0[2] or {}, var_12_0[3] or {}
end

function battleEasy.getRoundTriggerId(arg_15_0)
	for iter_15_0, iter_15_1 in pairs(gExtraRoundTrigger) do
		if iter_15_1.cfgIds[arg_15_0] then
			return iter_15_0
		end
	end
end

function battleEasy.resetGateAttackRecord(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.scene.play

	table.insert(var_16_0.roundLeftHeros, arg_16_1)

	for iter_16_0, iter_16_1 in ipairs(var_16_0.roundHasAttackedHeros) do
		if iter_16_1.id == arg_16_0.id then
			table.remove(var_16_0.roundHasAttackedHeros, iter_16_0)
			table.remove(var_16_0.hasAttackedSign, iter_16_0)

			break
		end
	end
end
