local var_0_0
local var_0_1 = {
	function(arg_1_0)
		return arg_1_0:getTakeDamageRecord(battle.ValueType.normal)
	end
}
local var_0_2 = {
	function(arg_2_0, arg_2_1)
		return arg_2_1
	end,
	function(arg_3_0, arg_3_1)
		return arg_3_0 + arg_3_1
	end
}

local function var_0_3(arg_4_0, arg_4_1)
	if arg_4_0 < 0 then
		errorInWindows("buff(%s) args(%s) < 0", arg_4_1.cfgId, arg_4_0)

		return 0
	end

	return arg_4_0
end

local function var_0_4(arg_5_0)
	if type(arg_5_0[1]) ~= "table" then
		return {
			arg_5_0
		}
	end

	return arg_5_0
end

function BuffModel.getBuffEffectFunc(arg_6_0, arg_6_1)
	return var_0_0[arg_6_1]
end

function BuffModel.doEffect(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	logf.battle.buff.doEffect("doEffect %s args=%s isOver=%s", arg_7_1, arg_7_2 and lazydumps(arg_7_2), arg_7_3)

	if arg_7_3 == nil then
		arg_7_3 = false
	end

	local var_7_0 = arg_7_0:getBuffEffectFunc(arg_7_1)

	if not var_7_0 and ObjectAttrs.AttrsTable[arg_7_1] then
		arg_7_2 = {
			{
				attr = arg_7_1,
				val = arg_7_2
			}
		}
		var_7_0 = arg_7_0:getBuffEffectFunc("addAttr")
	end

	if var_7_0 then
		return var_7_0(arg_7_0, arg_7_2, arg_7_3)
	end
end

local function var_0_5(arg_8_0, arg_8_1)
	if arg_8_1 then
		arg_8_0 = {
			[battle.MainSkillType.SmallSkill] = true,
			[battle.MainSkillType.BigSkill] = true,
			[battle.MainSkillType.NormalSkill] = true
		}

		for iter_8_0, iter_8_1 in ipairs(arg_8_1) do
			arg_8_0[iter_8_1] = false
		end
	end

	return arg_8_0
end

local function var_0_6(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.holder.orginUnitId
	local var_9_1 = true
	local var_9_2 = arg_9_0.holder.changeUnitIDTb

	for iter_9_0, iter_9_1 in ipairs(var_9_2) do
		if iter_9_1[1] == arg_9_0.id then
			table.remove(var_9_2, iter_9_0)

			break
		end
	end

	local var_9_3 = table.length(var_9_2)

	var_9_0 = var_9_2[var_9_3] and var_9_2[var_9_3][2] or var_9_0

	local var_9_4 = var_9_0 ~= arg_9_0.holder.unitID
	local var_9_5 = arg_9_0.holder.orginUnitId
	local var_9_6 = true

	for iter_9_2 = var_9_3, 1, -1 do
		if var_9_2[iter_9_2][3] then
			if var_9_2[iter_9_2] then
				var_9_5 = var_9_2[iter_9_2][2] or var_9_5
			end

			break
		end
	end

	local var_9_7 = var_9_5 ~= arg_9_0.holder.unitID

	return var_9_4, var_9_0, var_9_7
end

local function var_0_7(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_0.holder.unitID = arg_10_1
	arg_10_0.holder.unitCfg = csvClone(csv.unit[arg_10_1])

	local var_10_0 = arg_10_0.holder.unitCfg

	arg_10_0.holder.natureType = var_10_0.natureType
	arg_10_0.holder.natureType2 = var_10_0.natureType2
	arg_10_0.holder.battleFlag = var_10_0.battleFlag
end

local function var_0_8(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = {}
	local var_11_1 = {}
	local var_11_2 = {}

	if next(arg_11_0.holder.skillInfo) then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.holder.skillInfo) do
			local var_11_3 = csv.skill[iter_11_0]

			if var_11_3 then
				if var_11_3.skillType2 ~= battle.MainSkillType.PassiveSkill or var_11_3.changeUnitTrigger then
					if var_11_3.skillType2 == battle.MainSkillType.TagSkill then
						var_11_2[iter_11_0] = iter_11_1
					else
						var_11_0[var_11_3.skillType2] = iter_11_1
					end
				end
			else
				errorInWindows("skillID = %d is not in csv", iter_11_0)
			end
		end
	end

	if not arg_11_2 then
		local var_11_4 = battleEasy.getSkillTab(arg_11_1)
		local var_11_5 = ""

		for iter_11_2, iter_11_3 in pairs(var_11_4) do
			local var_11_6 = csv.skill[iter_11_2]

			if var_11_6 then
				if var_11_6.changeUnitTrigger then
					var_11_2[iter_11_2] = var_11_0[var_11_6.skillType2] or 1
				end
			else
				errorInWindows("skillID = %d is not in csv", iter_11_2)
			end

			var_11_5 = var_11_5 .. iter_11_2 .. " "
		end

		logf.battle.object.replaceSkill("changeUnit replace skill:%s", var_11_5)

		if arg_11_0.csvCfg.specialVal and arg_11_0.csvCfg.specialVal[1] then
			for iter_11_4, iter_11_5 in pairs(arg_11_0.holder.passiveSkillInfo) do
				var_11_2[iter_11_4] = iter_11_5
			end
		end

		if arg_11_4 and arg_11_4[2] < ymrand.random() then
			local var_11_7 = var_0_5({
				[battle.MainSkillType.PassiveSkill] = true
			})

			arg_11_0.holder:addSkillType2Data(arg_11_0.cfgId, var_11_7)
		end

		if arg_11_3 then
			for iter_11_6, iter_11_7 in pairs(arg_11_3) do
				if not var_11_2[iter_11_6] then
					local var_11_8 = csv.skill[iter_11_6]

					if var_11_8 then
						if var_11_8.changeUnitTrigger then
							var_11_2[iter_11_6] = var_11_0[var_11_8.skillType2] or 1
						end
					else
						errorInWindows("skillID = %d is not in csv", iter_11_6)
					end
				end
			end
		end

		arg_11_0.holder:onInitSkills(var_11_2 or {}, {})
	else
		arg_11_0.holder:onInitSkills(arg_11_0.holder.skillInfo, arg_11_0.holder.passiveSkillInfo)
		arg_11_0.holder:removeSkillType2Data(arg_11_0.cfgId)
	end

	if arg_11_0.overType and arg_11_0.overType == battle.BuffOverType.clean then
		return
	end

	arg_11_0.holder:initedTriggerPassiveSkill()
end

local function var_0_9(arg_12_0)
	for iter_12_0, iter_12_1 in arg_12_0.holder:iterBuffs() do
		if iter_12_1.csvCfg.easyEffectFunc == "cantRecoverMp" then
			local var_12_0 = iter_12_1.csvCfg.specialVal

			if not var_12_0 then
				arg_12_0.holder.cantRecoverMp = true

				break
			end

			for iter_12_2, iter_12_3 in ipairs(var_12_0) do
				if iter_12_3 == arg_12_0.cfgId then
					arg_12_0.holder.cantRecoverMp = true

					break
				else
					arg_12_0.holder.cantRecoverMp = false
				end
			end
		end
	end
end

local function var_0_10(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.holder
	local var_13_1 = var_13_0.force
	local var_13_2 = arg_13_1[3]
	local var_13_3 = arg_13_1[4] or 0
	local var_13_4 = arg_13_1[5] or 1
	local var_13_5 = true
	local var_13_6 = {
		triggerRound = arg_13_0.lifeRound - var_13_3,
		buffTab = {},
		prob = var_13_4,
		isTransferBuff = arg_13_2
	}

	arg_13_0:addExRecord(battle.ExRecordEvent.copyOrTransferBuff, var_13_6)

	local var_13_7 = arraytools.hash(arg_13_1[1])

	local function var_13_8(arg_14_0)
		if arg_14_0:group() and var_13_7[arg_14_0:group()] then
			if arg_13_3 and arg_14_0.holder.force ~= var_13_1 then
				return false
			end

			if arg_13_2 and arg_14_0.csvPower.beTransfer == 0 then
				return false
			end

			if not arg_13_2 and arg_14_0.csvPower.beCopy == 0 then
				return false
			end

			return true
		end

		return false
	end

	;(function()
		for iter_15_0, iter_15_1 in (arg_13_3 and var_13_0.scene.allBuffs or var_13_0.buffs):order_pairs() do
			if var_13_8(iter_15_1) then
				local var_15_0 = BuffArgs.fromCopyOrTransfer1(iter_15_1)

				table.insert(var_13_6.buffTab, var_15_0)
			end
		end
	end)()

	local var_13_9 = arg_13_0:getEventByKey(battle.ExRecordEvent.copyOrTransferBuff) or {}

	for iter_13_0 = table.length(var_13_9), 1, -1 do
		local var_13_10 = var_13_9[iter_13_0]

		if var_13_10.triggerRound >= arg_13_0.lifeRound then
			local var_13_11 = var_13_10.buffTab

			if var_13_10.prob > ymrand.random() then
				local var_13_12 = {}
				local var_13_13 = arg_13_0.csvCfg.specialVal[1]

				if arg_13_1[2] == 7 and var_13_0.curAttackMeObj then
					table.insert(var_13_12, var_13_0.curAttackMeObj)
				elseif arg_13_1[2] == battle.copyOrTransferSpecType.eachCaster then
					var_13_12 = {
						battle.copyOrTransferSpecType.eachCaster
					}
				else
					var_13_12 = arg_13_0:getObjectsByCfg(arg_13_1[2])
				end

				table.sort(var_13_11, function(arg_16_0, arg_16_1)
					return arg_16_0.id < arg_16_1.id
				end)

				if next(var_13_11) then
					local var_13_14 = random.sample(var_13_11, var_13_2, ymrand.random)
					local var_13_15 = false

					for iter_13_1, iter_13_2 in ipairs(var_13_12) do
						for iter_13_3, iter_13_4 in ipairs(var_13_14) do
							if iter_13_2 == battle.copyOrTransferSpecType.eachCaster then
								iter_13_2 = arg_13_0.scene:getObject(iter_13_4.casterID)
							end

							local var_13_16
							local var_13_17

							if iter_13_2 then
								local var_13_18 = BuffArgs.fromCopyOrTransfer2(iter_13_4, var_13_13, var_13_0.curSkill)
								local var_13_19

								var_13_19, var_13_17 = addBuffToHero(iter_13_4.cfgId, iter_13_2, var_13_0, var_13_18)
							end

							if var_13_17 then
								if var_13_5 then
									arg_13_0:playTriggerPointEffect()

									var_13_5 = false
								end

								if var_13_10.isTransferBuff then
									arg_13_0.holder:addExRecord(battle.ExRecordEvent.transferSucessCount, 1)
									arg_13_0:addExRecord(battle.ExRecordEvent.transferState, true)
								else
									arg_13_0.holder:addExRecord(battle.ExRecordEvent.copySucessCount, 1)
									arg_13_0:addExRecord(battle.ExRecordEvent.copyState, true)
								end

								arg_13_0:addExRecord(battle.ExRecordEvent.sucessCount, 1)

								var_13_15 = true
							end
						end
					end

					var_13_10.buffTab = var_13_14

					if var_13_15 then
						arg_13_0:triggerByMoment(battle.BuffTriggerPoint.onBuffTrigger)
					end
				end
			end

			table.remove(var_13_9, iter_13_0)

			local function var_13_20()
				for iter_17_0, iter_17_1 in ipairs(var_13_10.buffTab) do
					local var_17_0 = var_13_0:getBuff(iter_17_1.cfgId)

					if var_17_0 then
						var_17_0:over()
					end
				end
			end

			local function var_13_21()
				for iter_18_0, iter_18_1 in ipairs(var_13_10.buffTab) do
					if iter_18_1.scene:getObject(iter_18_1.holderID) then
						local var_18_0 = var_13_0:getBuff(iter_18_1.cfgId)

						if var_18_0 then
							var_18_0:over()
						end
					end
				end
			end

			if var_13_10.isTransferBuff then
				if arg_13_3 then
					var_13_21()
				else
					var_13_20()
				end
			end
		end
	end
end

local function var_0_11(arg_19_0)
	for iter_19_0, iter_19_1 in arg_19_0.holder:iterBuffs() do
		if iter_19_1.id ~= arg_19_0.id and iter_19_1.csvCfg.easyEffectFunc == arg_19_0.csvCfg.easyEffectFunc then
			iter_19_1:over({
				endType = battle.BuffOverType.overlay
			})
		end
	end
end

local function var_0_12(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0.holder

	if not arg_20_2 then
		local var_20_1 = functools.partial(function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			if not arg_21_0 then
				return arg_21_2
			end

			local var_21_0

			for iter_21_0, iter_21_1 in ipairs(arg_21_0) do
				local var_21_1 = gBuffGroupRelationCsv[iter_21_1]

				if var_21_1 and battleCsv.hasBuffGroup(var_21_1.immuneGroup, arg_21_3) then
					return arg_21_2 + arg_21_1, var_21_1.immuneEffect and iter_21_1 or nil
				end
			end

			return arg_21_2
		end, arg_20_0.csvCfg.specialVal or {
			999999
		}, arg_20_1)

		var_20_0:addOverlaySpecBuff(arg_20_0, function(arg_22_0)
			arg_22_0.refreshProb = var_20_1
		end)
	else
		var_20_0:deleteOverlaySpecBuff(arg_20_0)
	end
end

local function var_0_13(arg_23_0, arg_23_1, arg_23_2)
	local function var_23_0(arg_24_0)
		if csv.buff[arg_24_0] then
			return csv.buff[arg_24_0].easyEffectFunc
		end

		errorInWindows("getTransformCfgId getEasyEffectFunc %d is not in csv", arg_24_0)

		return "buff1"
	end

	for iter_23_0, iter_23_1 in ipairs(arg_23_0) do
		local var_23_1 = itertools.first(iter_23_1[1], arg_23_2)

		if var_23_1 then
			local var_23_2
			local var_23_3
			local var_23_4 = iter_23_1[2]
			local var_23_5 = iter_23_1[3]

			if var_23_5[1] == 1 then
				var_23_3 = var_23_4[var_23_1] or arg_23_1
				var_23_2 = var_23_1
			elseif var_23_5[1] == 2 then
				var_23_2 = ymrand.random(1, table.length(var_23_4))
				var_23_3 = var_23_4[var_23_2]
			end

			local var_23_6
			local var_23_7 = type(var_23_5[2])

			if var_23_7 == "number" then
				var_23_6 = var_23_5[2] or 1

				local var_23_8 = var_23_0(arg_23_1)
				local var_23_9 = var_23_0(var_23_3)

				var_23_6 = string.format("((%s/%s)*%s)", getAttrTransformRate(var_23_9), getAttrTransformRate(var_23_8), var_23_6)
			else
				var_23_6 = var_23_5[2][var_23_2] or 1
			end

			local var_23_10 = {
				limit = iter_23_1[4],
				targetType = iter_23_1[5]
			}

			return var_23_3, var_23_6, var_23_7, var_23_10
		end
	end

	return arg_23_1
end

var_0_0 = {
	alwaysTrue = function()
		return true
	end,
	alwaysFalse = function()
		return false
	end,
	resetNode = function(arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = arg_27_1.nodeId

		if arg_27_1.key == "triggerTimes" then
			arg_27_0.nodeManager:resetNode(var_27_0)
		end
	end,
	addAttr = function(arg_28_0, arg_28_1, arg_28_2)
		for iter_28_0, iter_28_1 in ipairs(var_0_4(arg_28_1)) do
			local var_28_0 = iter_28_1.attr
			local var_28_1 = iter_28_1.val

			if not arg_28_2 then
				arg_28_0.holder:objAddBuffAttr(var_28_0, var_28_1)

				arg_28_0.triggerAddAttrTb[var_28_0] = arg_28_0.triggerAddAttrTb[var_28_0] and arg_28_0.triggerAddAttrTb[var_28_0] + var_28_1 or var_28_1

				logf.battle.buff.value("buff value !!! csv=%s buffValue=%s attr[%s]=%s", arg_28_0.args.value, arg_28_0.value, var_28_0, arg_28_0.holder.attrs.final[var_28_0])
			else
				arg_28_0.holder.attrs:addBuffAttr(var_28_0, -(arg_28_0.triggerAddAttrTb[var_28_0] or 0))

				arg_28_0.triggerAddAttrTb[var_28_0] = nil
			end
		end

		return true
	end,
	castSkill = function(arg_29_0, arg_29_1, arg_29_2)
		if arg_29_2 then
			return true
		end

		local var_29_0 = arg_29_1.skillId
		local var_29_1 = arg_29_0:getObjectsByCfg(arg_29_1.caster)

		for iter_29_0, iter_29_1 in ipairs(var_29_1) do
			if iter_29_1 then
				local var_29_2 = newSkillModel(iter_29_1.scene, iter_29_1, var_29_0, 1, tostring(arg_29_0))

				if var_29_2.onTrigger then
					var_29_2:onTrigger(var_29_2.type, iter_29_1, arg_29_1)
				end
			end
		end

		return true
	end,
	castBuff = function(arg_30_0, arg_30_1, arg_30_2)
		if arg_30_2 then
			return true
		end

		for iter_30_0, iter_30_1 in ipairs(arg_30_1) do
			local var_30_0 = iter_30_1.cfgId
			local var_30_1 = arg_30_0:getObjectsByCfg(iter_30_1.caster)
			local var_30_2 = arg_30_0:getObjectsByCfg(iter_30_1.holder)

			if itertools.isempty(var_30_1) or itertools.isempty(var_30_2) then
				return true
			end

			local var_30_3 = iter_30_1.bond
			local var_30_4 = iter_30_1.childBind
			local var_30_5 = arg_30_0.castBuffGroup:back()

			local function var_30_6(arg_31_0, arg_31_1)
				arg_30_0.protectedEnv = battleCsv.fillFuncEnv(arg_30_0.protectedEnv, {
					self2 = arg_31_0,
					target2 = arg_31_1,
					trigger = arg_30_0.triggerEnv
				})
				arg_30_0.castBuffEnvAdded = true

				local var_31_0 = arg_30_0:cfg2Value(iter_30_1.lifeRound)
				local var_31_1 = arg_30_0:cfg2Value(iter_30_1.value)
				local var_31_2 = arg_30_0:cfg2Value(iter_30_1.prob) or 1

				arg_30_0.protectedEnv:resetEnv()

				arg_30_0.castBuffEnvAdded = false

				local var_31_3

				var_31_3 = var_30_3 == 1 and arg_30_0

				local var_31_4

				var_31_4 = var_30_3 == 2

				local var_31_5 = {
					skillCfg = arg_30_0.args.skillCfg,
					skillLevel = arg_30_0.fromSkillLevel,
					lifeRound = var_31_0,
					fromSkillId = arg_30_0.args.fromSkillId,
					value = var_31_1,
					buffValueFormula = arg_30_1.originArgs[iter_30_0].value,
					buffValueFormulaEnv = arg_30_0.protectedEnv,
					prob = var_31_2,
					source = tostring(arg_30_0),
					fieldSub = arg_30_0.isFieldBuff or arg_30_0.isFieldSubBuff
				}
				local var_31_6 = addBuffToHero(var_30_0, arg_31_1, arg_31_0, var_31_5)

				if var_31_6 then
					if var_30_3 == 1 then
						table.insert(arg_30_0.bondChildBuffsTb, var_31_6)
					elseif var_30_3 == 2 then
						table.insert(arg_30_0.bondToOtherBuffsTb, var_31_6)
						table.insert(var_31_6.bondToOtherBuffsTb, arg_30_0)
					end

					if var_30_4 and var_30_4[1] and var_30_4[2] then
						var_30_5[var_30_4[2]] = var_30_5[var_30_4[2]] or {}

						table.insert(var_30_5[var_30_4[2]], {
							pro = var_30_4[1],
							buff = var_31_6
						})
					end
				end
			end

			for iter_30_2, iter_30_3 in ipairs(var_30_1) do
				for iter_30_4, iter_30_5 in ipairs(var_30_2) do
					var_30_6(iter_30_3, iter_30_5)
				end
			end
		end

		return true
	end,
	skillAttr = function(arg_32_0, arg_32_1, arg_32_2)
		itertools.each(var_0_4(arg_32_1), function(arg_33_0, arg_33_1)
			local var_33_0 = arg_33_1.attr
			local var_33_1 = arg_33_1.val

			arg_32_0.holder.curSkill:addAttr(var_33_0, var_33_1, arg_32_2)
		end)

		return true
	end,
	buffDamage = function(arg_34_0, arg_34_1, arg_34_2)
		if arg_34_2 then
			return true
		end

		local var_34_0 = arg_34_0.caster
		local var_34_1 = arg_34_0.csvCfg.specialVal and arg_34_0.csvCfg.specialVal[1] or {}
		local var_34_2 = var_34_1.processId or 2
		local var_34_3 = {
			arg_34_0.holder
		}
		local var_34_4
		local var_34_5
		local var_34_6 = {
			isLastDamageSeg = true,
			isBeginDamageSeg = true,
			from = battle.DamageFrom.buff,
			buffCfgId = arg_34_0.cfgId,
			damageType = var_34_1.damageType,
			natureType = var_34_1.natureType,
			noDamageRecord = var_34_1.noDamageRecord
		}

		var_0_9(arg_34_0)

		if arg_34_0.csvCfg.specialTarget then
			arg_34_0.scene:updateBeAttackZOrder()

			var_34_6.processId = arg_34_0.id
			var_34_6.beAttackZOrder = arg_34_0.scene.beAttackZOrder
			var_34_3 = arg_34_0:getObjectsByCfg(arg_34_0.csvCfg.specialTarget[1])
		end

		arg_34_1 = math.max(arg_34_1, 0)
		arg_34_1 = var_0_3(arg_34_1, arg_34_0)

		for iter_34_0, iter_34_1 in ipairs(var_34_3) do
			if var_34_6.processId then
				var_34_6.isProcessState = {
					isStart = iter_34_0 == 1,
					isEnd = iter_34_0 == table.length(var_34_3)
				}
			end

			local var_34_7, var_34_8 = iter_34_1:beAttack(var_34_0, arg_34_1, var_34_2, var_34_6)
			local var_34_9 = var_34_8
			local var_34_10 = var_34_7:get(battle.ValueType.normal)

			iter_34_1:addExRecord(battle.ExRecordEvent.momentBuffDamage, var_34_10, arg_34_0.cfgId)

			local var_34_11 = iter_34_1.scene.play.curHero

			if var_34_0.curSkill and (var_34_0.curSkill:isNormalSkillType() and var_34_0.curSkill.isSpellTo and var_34_0.curSkill.owner.id ~= arg_34_0.holder.id or var_34_1.showNumber and var_34_11.id == var_34_0.id) then
				battleEasy.deferNotifyCantJump(nil, "showNumber", {
					typ = "damage",
					delta = math.floor(var_34_10),
					skillId = var_34_0.curSkill.id
				})
			end
		end
	end,
	addHP = function(arg_35_0, arg_35_1, arg_35_2)
		if arg_35_2 then
			return true
		end

		local var_35_0 = arg_35_0.caster
		local var_35_1 = arg_35_1
		local var_35_2 = arg_35_0.csvCfg.specialVal and arg_35_0.csvCfg.specialVal[1]
		local var_35_3 = {
			ignoreBeHealAddRate = false,
			from = battle.ResumeHpFrom.buff,
			fromKey = arg_35_0.cfgId
		}

		if arg_35_0.caster and var_35_1 > 0 and (not var_35_2 or not var_35_2.ignoreHealAddRate) then
			var_35_1 = var_35_1 * (1 + arg_35_0.caster:cure() + arg_35_0.caster:healAdd())
		end

		if var_35_2 then
			var_35_3.ignoreLockResume = battleEasy.ifElse(var_35_2.ignoreLockResume, var_35_2.ignoreLockResume, var_35_3.ignoreLockResume)
			var_35_3.ignoreBeHealAddRate = battleEasy.ifElse(var_35_2.ignoreBeHealAddRate, var_35_2.ignoreBeHealAddRate, var_35_3.ignoreBeHealAddRate)
		end

		local var_35_4 = arg_35_0.holder

		if var_35_1 < 0 then
			errorInWindows("addHP(%s) is old,please use buffDamage", arg_35_0.cfgId)
		elseif (not var_35_2 or not var_35_2.ignoreToDamage) and var_35_4:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.healTodamage) then
			var_35_4:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.healTodamage, "doBuffDamage", var_35_0, var_35_4, var_35_1, arg_35_0.cfgId)
		else
			var_35_4:resumeHp(var_35_0, math.floor(var_35_1), var_35_3)
		end

		return true
	end,
	addHpMax = function(arg_36_0, arg_36_1, arg_36_2)
		local var_36_0 = arg_36_0.csvCfg.specialVal and arg_36_0.csvCfg.specialVal[1] or {}
		local var_36_1 = arg_36_0.holder
		local var_36_2 = battleEasy.ifElse(var_36_0.effectHp ~= nil, var_36_0.effectHp, true)
		local var_36_3 = true
		local var_36_4 = arg_36_0:getEventByKey(battle.ExRecordEvent.effectHpMax) or 0
		local var_36_5 = arg_36_0:getEventByKey(battle.ExRecordEvent.effectHp) or 0

		local function var_36_6(arg_37_0)
			local var_37_0 = var_36_1:hp()
			local var_37_1 = battleEasy.valueTypeTable()

			var_36_1:setHP(var_37_0 + arg_37_0)

			if var_36_1:hp() <= 0 then
				var_37_1:add(math.abs(arg_37_0))
				var_37_1:add(var_37_0, battle.ValueType.valid)
				var_37_1:add(math.abs(arg_37_0 + var_37_0), battle.ValueType.overFlow)
				var_36_1:setDead(arg_36_0.caster, var_37_1)
			end
		end

		local var_36_7 = arg_36_2 and -var_36_4 or arg_36_1
		local var_36_8 = arg_36_2 and -var_36_5 or arg_36_1

		if var_36_7 >= 0 then
			var_36_1.attrs:addBuffAttr("hpMax", var_36_7)

			if var_36_2 and not arg_36_2 or not var_36_3 and arg_36_2 then
				var_36_6(var_36_8)
			else
				var_36_8 = 0
			end
		else
			if var_36_7 + var_36_1:hpMax() <= 1 then
				var_36_7 = -var_36_1:hpMax() + 1

				arg_36_0:setValue(var_36_7)
			end

			if not arg_36_2 then
				var_36_8 = 0

				if var_36_2 then
					var_36_8 = var_36_7
				end
			elseif var_36_3 then
				var_36_8 = 0
			end

			if var_36_1:hp() + var_36_8 > var_36_7 + var_36_1:hpMax() then
				var_36_8 = var_36_7 + var_36_1:hpMax() - var_36_1:hp()
			end

			var_36_1.attrs:addBuffAttr("hpMax", var_36_7)

			if var_36_8 ~= 0 then
				if arg_36_2 then
					var_36_6(var_36_8)
				else
					local var_36_9 = {
						isBeginDamageSeg = true,
						isLastDamageSeg = true,
						from = battle.DamageFrom.buff
					}

					var_36_1:beAttack(arg_36_0.caster, math.abs(var_36_8), 13, var_36_9)
				end
			end
		end

		if not arg_36_2 then
			arg_36_0:addExRecord(battle.ExRecordEvent.effectHpMax, var_36_7)
			arg_36_0:addExRecord(battle.ExRecordEvent.effectHp, var_36_8)
		end

		var_36_1:refreshLifeBar()

		return true
	end,
	setHpPer = function(arg_38_0, arg_38_1, arg_38_2)
		if not arg_38_2 then
			local var_38_0 = arg_38_0.holder:hpMax()
			local var_38_1 = var_38_0 * arg_38_1 - arg_38_0.holder:hp()

			arg_38_0.holder:setHP(var_38_0 * arg_38_1)
			battleEasy.deferNotify(arg_38_0.holder.view, "showHeadNumber", {
				typ = var_38_1 >= 0 and 1 or 0,
				num = math.abs(var_38_1),
				args = {}
			})
		end
	end,
	addMp1 = function(arg_39_0, arg_39_1, arg_39_2)
		if arg_39_2 then
			return true
		end

		local var_39_0 = {
			ignoreMp1Recover = false,
			ignoreLockMp1Add = false,
			changeMpOverflow = false
		}
		local var_39_1 = arg_39_0.csvCfg.specialVal and arg_39_0.csvCfg.specialVal[1] or {}

		if var_39_1 then
			var_39_0.ignoreMp1Recover = battleEasy.ifElse(var_39_1.ignoreMp1Recover, var_39_1.ignoreMp1Recover, var_39_0.ignoreMp1Recover)
			var_39_0.ignoreLockMp1Add = battleEasy.ifElse(var_39_1.ignoreLockMp1Add, var_39_1.ignoreLockMp1Add, var_39_0.ignoreLockMp1Add)
			var_39_0.changeMpOverflow = battleEasy.ifElse(var_39_1.changeMpOverflow, var_39_1.changeMpOverflow, var_39_0.changeMpOverflow)
		end

		local var_39_2 = arg_39_1
		local var_39_3 = var_39_2

		if not var_39_0.ignoreMp1Recover then
			var_39_3 = var_39_2 * (1 + arg_39_0.holder:mp1Recover())
		end

		arg_39_0.holder:setMP1(arg_39_0.holder:mp1() + var_39_3, nil, var_39_0)

		return true
	end,
	addMp1Max = function(arg_40_0, arg_40_1, arg_40_2)
		local var_40_0 = arg_40_1

		if not arg_40_2 then
			if var_40_0 + arg_40_0.holder:mp1Max() <= 1 then
				var_40_0 = -arg_40_0.holder:mp1Max() + 1

				arg_40_0:setValue(var_40_0)
			end

			arg_40_0.holder.attrs:addBuffAttr("mp1Max", var_40_0)
		else
			arg_40_0.holder.attrs:addBuffAttr("mp1Max", -var_40_0)
		end

		if arg_40_0.holder:mp1() >= arg_40_0.holder:mp1Max() then
			arg_40_0.holder:setMP1(arg_40_0.holder:mp1Max())
		end

		return true
	end,
	lockMp1Add = function(arg_41_0, arg_41_1, arg_41_2)
		if not arg_41_2 then
			arg_41_0.holder.lockMp1Add = true
		else
			arg_41_0.holder.lockMp1Add = false
		end
	end,
	lockResumeHp = function(arg_42_0, arg_42_1, arg_42_2)
		local var_42_0 = arg_42_0.holder

		if not arg_42_2 then
			var_42_0:addOverlaySpecBuff(arg_42_0, function(arg_43_0)
				return
			end)
		else
			var_42_0:deleteOverlaySpecBuff(arg_42_0)
		end
	end,
	cantRecoverMp = function(arg_44_0, arg_44_1, arg_44_2)
		if not arg_44_2 then
			arg_44_0.holder.cantRecoverMp = true
		else
			arg_44_0.holder.cantRecoverMp = false
		end

		return true
	end,
	cantRecoverSkillMp = function(arg_45_0, arg_45_1, arg_45_2)
		if not arg_45_2 then
			arg_45_0.holder.cantRecoverSkillMp = true
		else
			arg_45_0.holder.cantRecoverSkillMp = false
		end

		return true
	end,
	suckMp = function(arg_46_0, arg_46_1, arg_46_2)
		if not arg_46_2 then
			local var_46_0 = arg_46_1[1]
			local var_46_1 = arg_46_1[2]
			local var_46_2 = var_46_0 < arg_46_0.holder:mp1() and var_46_0 or arg_46_0.holder:mp1()
			local var_46_3 = arg_46_0.holder:mp1() - var_46_2
			local var_46_4 = var_46_2 * var_46_1 * (1 + arg_46_0.caster:mp1Recover())

			arg_46_0.holder:setMP1(var_46_3)
			arg_46_0.caster:setMP1(arg_46_0.caster:mp1() + var_46_4)
		end

		return true
	end,
	shield = function(arg_47_0, arg_47_1, arg_47_2)
		local var_47_0 = arg_47_0.holder

		if not arg_47_2 then
			arg_47_0.value = math.floor(var_0_3(arg_47_0.value, arg_47_0))

			var_47_0:addOverlaySpecBuff(arg_47_0, function(arg_48_0)
				if not arg_48_0.shieldMaxTotal then
					arg_48_0:setG("shieldMaxTotal", 0)
				end

				if not arg_48_0.shieldTotal then
					arg_48_0:setG("shieldTotal", 0)
				end

				local var_48_0 = arg_48_0.shieldHpMax or 0
				local var_48_1 = arg_48_0.shieldHp or 0

				arg_48_0.shieldHpMax = arg_47_0.value
				arg_48_0.shieldHp = arg_47_0.value
				arg_48_0.shieldMaxTotal = arg_48_0.shieldMaxTotal + arg_48_0.shieldHpMax - var_48_0
				arg_48_0.shieldTotal = arg_48_0.shieldTotal + arg_48_0.shieldHp - var_48_1
				arg_48_0.priority = arg_47_0.csvCfg.specialVal and arg_47_0.csvCfg.specialVal[1] or 1000
				arg_48_0.showType = arg_47_0.csvCfg.specialVal and arg_47_0.csvCfg.specialVal[2] or 0
			end, function(arg_49_0, arg_49_1)
				return arg_49_0.priority > arg_49_1.priority
			end)
		else
			var_47_0:deleteOverlaySpecBuff(arg_47_0, function(arg_50_0)
				arg_50_0.shieldMaxTotal = arg_50_0.shieldMaxTotal - arg_50_0.shieldHpMax
				arg_50_0.shieldTotal = arg_50_0.shieldTotal - arg_50_0.shieldHp
			end)
		end

		arg_47_0.holder:refreshShield()

		return true
	end,
	freeze = function(arg_51_0, arg_51_1, arg_51_2)
		local var_51_0 = arg_51_1
		local var_51_1 = arg_51_0.holder

		if not arg_51_2 then
			var_51_0 = math.min(var_51_0, var_51_1:hp() - (var_51_1.freezeHp or 0))
			var_51_1.freezeHp = (var_51_1.freezeHp or 0) + var_51_0

			var_51_1:addOverlaySpecBuff(arg_51_0, function(arg_52_0)
				arg_52_0.cfgId = arg_51_0.cfgId
				arg_52_0.freezeHp = var_51_0
			end, nil)
		else
			local var_51_2 = 0

			for iter_51_0, iter_51_1 in var_51_1:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.freeze) do
				if iter_51_1.cfgId == arg_51_0.cfgId then
					var_51_2 = iter_51_1.freezeHp

					break
				end
			end

			var_51_1:deleteOverlaySpecBuff(arg_51_0)

			var_51_1.freezeHp = var_51_1.freezeHp - var_51_2

			if var_51_1.freezeHp <= 0 or not var_51_1:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.freeze) then
				var_51_1.freezeHp = 0
			end
		end

		return true
	end,
	stun = function(arg_53_0, arg_53_1, arg_53_2)
		local var_53_0 = arg_53_0.holder

		if not arg_53_2 then
			var_53_0:addOverlaySpecBuff(arg_53_0, function(arg_54_0)
				return
			end, nil)
		else
			var_53_0:deleteOverlaySpecBuff(arg_53_0)
		end

		return true
	end,
	sleepy = function(arg_55_0, arg_55_1, arg_55_2)
		local var_55_0 = arg_55_0.holder

		if not arg_55_2 then
			arg_55_0:setValue(arg_55_1 or 1)
			var_55_0:addOverlaySpecBuff(arg_55_0, function(arg_56_0)
				arg_56_0:bind("time", "value")
			end, nil)
		else
			var_55_0:deleteOverlaySpecBuff(arg_55_0)
		end

		return true
	end,
	immunePhysicalDamage = function(arg_57_0, arg_57_1, arg_57_2)
		if not arg_57_2 then
			arg_57_0.holder.beInImmunePhysicalDamageState = arg_57_0.holder.beInImmunePhysicalDamageState and arg_57_0.holder.beInImmunePhysicalDamageState + 1 or 1
		else
			arg_57_0.holder.beInImmunePhysicalDamageState = arg_57_0.holder.beInImmunePhysicalDamageState and arg_57_0.holder.beInImmunePhysicalDamageState - 1 or 0
			arg_57_0.holder.beInImmunePhysicalDamageState = math.max(arg_57_0.holder.beInImmunePhysicalDamageState, 0)
		end

		return true
	end,
	immuneDamage = function(arg_58_0, arg_58_1, arg_58_2)
		local var_58_0 = arg_58_0.holder

		if not arg_58_2 then
			local var_58_1 = {
				all = 1,
				special = 4,
				skill = 8,
				buff = 16,
				physical = 2
			}
			local var_58_2 = arg_58_0.csvCfg.easyEffectFunc

			var_58_0:addOverlaySpecBuff(arg_58_0, function(arg_59_0)
				if not arg_59_0.funcMap then
					arg_59_0:setG("funcMap", {
						[var_58_1.skill] = function(arg_60_0, arg_60_1, arg_60_2)
							if arg_60_1.args.skillDamageId then
								if not arg_60_0:dealSpecialFlag(arg_60_1, arg_60_2) then
									return
								end

								if not arg_60_0:dealTime(arg_60_1.args.skillDamageId, var_58_1.skill, arg_60_1.args.isLastDamageSeg) then
									return
								end

								return "skillImmune", false
							end
						end,
						[var_58_1.buff] = function(arg_61_0, arg_61_1, arg_61_2)
							if arg_61_1.args.from == battle.DamageFrom.buff then
								if not arg_61_0:dealSpecialFlag(arg_61_1, arg_61_2) then
									return
								end

								if not arg_61_0:dealTime(arg_61_1.args.damageId, var_58_1.buff, arg_61_1.args.isLastDamageSeg) then
									return
								end

								return "buffImmune", false
							end
						end,
						[var_58_1.physical] = function(arg_62_0, arg_62_1)
							if arg_62_1.args.damageType == battle.SkillDamageType.Physical then
								if not arg_62_0:dealTime(arg_62_1.args.skillDamageId or arg_62_1.args.damageId, var_58_1.physical, arg_62_1.args.isLastDamageSeg) then
									return
								end

								return "physical", true
							end
						end,
						[var_58_1.all] = function(arg_63_0, arg_63_1)
							if not arg_63_0:dealTime(arg_63_1.args.skillDamageId or arg_63_1.args.damageId, var_58_1.all, arg_63_1.args.isLastDamageSeg) then
								return
							end

							return "all", true
						end,
						[var_58_1.special] = function(arg_64_0, arg_64_1)
							if arg_64_1.args.damageType == battle.SkillDamageType.Special then
								if not arg_64_0:dealTime(arg_64_1.args.skillDamageId or arg_64_1.args.damageId, var_58_1.special, arg_64_1.args.isLastDamageSeg) then
									return
								end

								return "special", true
							end
						end
					})
					arg_59_0:setG("dealTime", function(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
						if arg_65_0.isForever then
							if arg_65_3 then
								arg_65_0.damageMap.count = arg_65_0.damageMap.count + 1
							end

							return true
						end

						if not arg_65_0.damageMap.data[arg_65_1] then
							if arg_65_0.powerTime[arg_65_2] == 0 then
								return false
							end

							arg_65_0.damageMap.data[arg_65_1] = true
							arg_65_0.powerTime[arg_65_2] = arg_65_0.powerTime[arg_65_2] - 1
						end

						if arg_65_3 then
							arg_65_0.allTime = arg_65_0.allTime - 1
							arg_65_0.damageMap.count = arg_65_0.damageMap.count + 1
						end

						return true
					end)
					arg_59_0:setG("dealSpecialFlag", function(arg_66_0, arg_66_1, arg_66_2)
						local var_66_0 = arg_66_0.buff
						local var_66_1 = false

						if not var_66_0.csvCfg.specialVal then
							var_66_1 = true
						else
							var_66_0.protectedEnv = battleCsv.fillFuncEnv(var_66_0.protectedEnv, {
								attacker = arg_66_2
							})
							var_66_1 = var_66_0:cfg2Value(var_66_0.csvCfg.specialVal[1])

							var_66_0.protectedEnv:resetEnv()
						end

						return var_66_1
					end)
					arg_59_0:setG("getImmuneInfo", function(arg_67_0, arg_67_1, arg_67_2)
						if arg_67_0.powerTime[var_58_1.all] and arg_67_0.powerTime[var_58_1.all] > 0 then
							return "allimmune"
						elseif arg_67_2 == battle.SkillDamageType.Physical and arg_67_0.powerTime[var_58_1.physical] and arg_67_0.powerTime[var_58_1.physical] > 0 then
							return battleEasy.ifElse(arg_67_1 == "special", "allimmune", "physical")
						elseif arg_67_2 == battle.SkillDamageType.Special and arg_67_0.powerTime[var_58_1.special] and arg_67_0.powerTime[var_58_1.special] > 0 then
							return battleEasy.ifElse(arg_67_1 == "physical", "allimmune", "special")
						end
					end)
					arg_59_0:setG("powerTimeOrderPairs", function(arg_68_0)
						local var_68_0 = 1
						local var_68_1 = 1

						return function()
							while var_68_1 <= var_58_1.buff do
								local var_69_0 = arg_68_0.powerTime[var_68_1]

								var_68_0 = var_68_1
								var_68_1 = var_68_1 * 2

								if var_69_0 then
									return var_68_0, var_69_0
								end
							end

							return nil
						end
					end)
				end

				arg_59_0.buff = arg_58_0
				arg_59_0.powerTime = {}
				arg_59_0.allTime = 0
				arg_59_0.damageMap = {
					count = 0,
					data = {}
				}

				local var_59_0 = var_58_1.buff
				local var_59_1 = arg_58_1[1]

				while var_59_1 ~= 0 do
					if var_59_1 - var_59_0 >= 0 then
						var_59_1 = var_59_1 - var_59_0
						arg_59_0.powerTime[var_59_0] = (arg_59_0.powerTime[var_59_0] or 0) + (arg_58_1[2] or 1)
						arg_59_0.allTime = arg_59_0.allTime + arg_59_0.powerTime[var_59_0]
					end

					var_59_0 = math.floor(var_59_0 / 2)
				end

				arg_59_0.isForever = arg_58_1[2] == nil
			end)
		else
			var_58_0:deleteOverlaySpecBuff(arg_58_0)
		end

		return true
	end,
	immuneSpecialDamage = function(arg_70_0, arg_70_1, arg_70_2)
		if not arg_70_2 then
			arg_70_0.holder.beInImmuneSpecialDamageState = arg_70_0.holder.beInImmuneSpecialDamageState and arg_70_0.holder.beInImmuneSpecialDamageState + 1 or 1
		else
			arg_70_0.holder.beInImmuneSpecialDamageState = arg_70_0.holder.beInImmuneSpecialDamageState and arg_70_0.holder.beInImmuneSpecialDamageState - 1 or 0
			arg_70_0.holder.beInImmuneSpecialDamageState = math.max(arg_70_0.holder.beInImmuneSpecialDamageState, 0)
		end

		return true
	end,
	immuneAllDamage = function(arg_71_0, arg_71_1, arg_71_2)
		if not arg_71_2 then
			arg_71_0.holder.beInImmuneAllDamageState = arg_71_0.holder.beInImmuneAllDamageState and arg_71_0.holder.beInImmuneAllDamageState + 1 or 1
		else
			arg_71_0.holder.beInImmuneAllDamageState = arg_71_0.holder.beInImmuneAllDamageState and arg_71_0.holder.beInImmuneAllDamageState - 1 or 0
			arg_71_0.holder.beInImmuneAllDamageState = math.max(arg_71_0.holder.beInImmuneAllDamageState, 0)
		end

		return true
	end,
	immuneAllAttrsDown = function(arg_72_0, arg_72_1, arg_72_2)
		if not arg_72_2 then
			arg_72_0.holder.beInImmuneAllAttrsDownState = arg_72_0.holder.beInImmuneAllAttrsDownState and arg_72_0.holder.beInImmuneAllAttrsDownState + 1 or 1
		else
			arg_72_0.holder.beInImmuneAllAttrsDownState = arg_72_0.holder.beInImmuneAllAttrsDownState and arg_72_0.holder.beInImmuneAllAttrsDownState - 1 or 0
			arg_72_0.holder.beInImmuneAllAttrsDownState = math.max(arg_72_0.holder.beInImmuneAllAttrsDownState, 0)
		end

		return true
	end,
	silence = function(arg_73_0, arg_73_1, arg_73_2)
		if not arg_73_2 then
			local var_73_0 = {}
			local var_73_1 = {}

			if arg_73_0.csvCfg.specialVal == nil then
				if arg_73_1 then
					local var_73_2 = type(arg_73_1)

					if var_73_2 == "table" then
						for iter_73_0, iter_73_1 in ipairs(arg_73_1 or {}) do
							var_73_1[iter_73_1] = true
						end
					elseif var_73_2 == "number" then
						var_73_1[arg_73_1] = true
					end
				end
			else
				var_73_0 = var_0_5({
					[battle.MainSkillType.SmallSkill] = true,
					[battle.MainSkillType.BigSkill] = true,
					[battle.MainSkillType.NormalSkill] = false
				}, arg_73_0.csvCfg.specialVal)
			end

			arg_73_0.holder:addOverlaySpecBuff(arg_73_0, function(arg_74_0)
				arg_74_0.closeSkill = var_73_1
				arg_74_0.closeSkillType2 = var_73_0
			end)
		else
			arg_73_0.holder:deleteOverlaySpecBuff(arg_73_0)
		end

		return true
	end,
	sneer = function(arg_75_0, arg_75_1, arg_75_2)
		local var_75_0 = arg_75_0.holder

		if not arg_75_2 then
			if arg_75_0.caster:isAlreadyDead() then
				arg_75_0:overClean()
			else
				if arg_75_1 and type(arg_75_1) ~= "table" then
					arg_75_1 = {
						0,
						3,
						3
					}
				end

				arg_75_0.mode = arg_75_1[1]

				var_75_0:addOverlaySpecBuff(arg_75_0, function(arg_76_0)
					arg_76_0.buffID = arg_75_0.id
					arg_76_0.mode = arg_75_1[1]
					arg_76_0.obj = arg_75_0.caster
					arg_76_0.extraArg = {
						spreadArg1 = arg_75_1[2],
						spreadArg2 = arg_75_1[3]
					}

					if arg_75_1[1] == battle.SneerType.Duel or arg_75_1[1] == battle.SneerType.Normal and not var_75_0:isBeInDuel() then
						local var_76_0 = var_0_5({
							[battle.MainSkillType.SmallSkill] = true,
							[battle.MainSkillType.BigSkill] = true,
							[battle.MainSkillType.NormalSkill] = false
						}, arg_75_0.csvCfg.specialVal)

						var_75_0:addSkillType2Data(arg_75_0.csvCfg.easyEffectFunc, var_76_0)
					end
				end, function(arg_77_0, arg_77_1)
					return arg_77_0.mode > arg_77_1.mode
				end)
			end
		else
			var_75_0:deleteOverlaySpecBuff(arg_75_0, function(arg_78_0)
				var_75_0:removeSkillType2Data(arg_75_0.csvCfg.easyEffectFunc)

				if arg_78_0.mode == battle.SneerType.Duel then
					local var_78_0

					for iter_78_0, iter_78_1 in var_75_0:ipairsOverlaySpecBuffTo("sneer") do
						if iter_78_1.mode == battle.SneerType.Normal then
							var_78_0 = iter_78_1.id

							break
						end
					end

					if var_78_0 then
						for iter_78_2, iter_78_3 in var_75_0:iterBuffs() do
							if iter_78_3.id == var_78_0 then
								local var_78_1 = var_0_5({
									[battle.MainSkillType.SmallSkill] = true,
									[battle.MainSkillType.BigSkill] = true,
									[battle.MainSkillType.NormalSkill] = false
								}, iter_78_3.csvCfg.specialVal)

								var_75_0:addSkillType2Data(iter_78_3.csvCfg.easyEffectFunc, var_78_1)

								break
							end
						end
					end
				end
			end)
		end

		return true
	end,
	confusion = function(arg_79_0, arg_79_1, arg_79_2)
		local var_79_0 = arg_79_0.holder
		local var_79_1
		local var_79_2

		if not arg_79_1 or type(arg_79_1) == "number" then
			var_79_1 = arg_79_1
		else
			var_79_1 = arg_79_1[1]
			var_79_2 = arg_79_1[2] == 1
		end

		local var_79_3 = math.min(math.max(0, var_79_1 or 0.5), 1)

		if not arg_79_2 then
			local var_79_4 = var_0_5({
				[battle.MainSkillType.SmallSkill] = true,
				[battle.MainSkillType.BigSkill] = true,
				[battle.MainSkillType.NormalSkill] = false
			}, arg_79_0.csvCfg.specialVal)

			var_79_0:addOverlaySpecBuff(arg_79_0, function(arg_80_0)
				arg_80_0.prob = var_79_3
				arg_80_0.closeSkillType2 = var_79_4
				arg_80_0.needSelfForce = var_79_2
			end)
		else
			var_79_0:deleteOverlaySpecBuff(arg_79_0)
		end

		return true
	end,
	reborn = function(arg_81_0, arg_81_1, arg_81_2)
		local var_81_0 = arg_81_1[1]
		local var_81_1 = var_81_0 == 0 and true or false
		local var_81_2 = arg_81_1[4] or 0

		if not arg_81_2 then
			arg_81_0.holder:addOverlaySpecBuff(arg_81_0, function(arg_82_0)
				arg_82_0.isFastReborn = var_81_1
				arg_82_0.lifeRound = var_81_0
				arg_82_0.buff = arg_81_0
				arg_82_0.priority = var_81_2
			end, function(arg_83_0, arg_83_1)
				if arg_83_0.isFastReborn == arg_83_1.isFastReborn then
					if arg_83_0.priority == arg_83_1.priority then
						return arg_83_0.buff.id < arg_83_1.buff.id
					else
						return arg_83_0.priority > arg_83_1.priority
					end
				else
					return arg_83_0.isFastReborn
				end
			end)
		else
			if arg_81_0.holder:isRebornState() then
				arg_81_0.holder:resetRebornState(arg_81_1[2] or 1, arg_81_1[3] or 0)
			end

			arg_81_0.holder:deleteOverlaySpecBuff(arg_81_0)
		end

		return true
	end,
	removeObj = function(arg_84_0, arg_84_1, arg_84_2)
		if not arg_84_2 then
			local var_84_0 = arg_84_0.caster

			arg_84_0.holder:setDead(var_84_0)
		end

		return true
	end,
	weather = function(arg_85_0, arg_85_1, arg_85_2)
		local var_85_0 = arg_85_0.holder

		if not arg_85_2 then
			arg_85_0.weatherCfgId = arg_85_1

			var_85_0:addOverlaySpecBuff(arg_85_0, function(arg_86_0)
				return
			end)
		else
			var_85_0:deleteOverlaySpecBuff(arg_85_0)
		end

		return true
	end,
	fatal = function(arg_87_0, arg_87_1, arg_87_2)
		if not arg_87_2 then
			arg_87_0.holder.fatalBuff = {
				limit = arg_87_1[1],
				val = arg_87_1[2]
			}
		else
			arg_87_0.holder.fatalBuff = nil
		end

		return true
	end,
	behead = function(arg_88_0, arg_88_1, arg_88_2)
		if not arg_88_2 then
			arg_88_0.holder.beheadBuff = {
				limit = arg_88_1[1],
				val = arg_88_1[2]
			}
		else
			arg_88_0.holder.beheadBuff = nil
		end

		return true
	end,
	damageByHpRate = function(arg_89_0, arg_89_1, arg_89_2)
		local var_89_0 = arg_89_0.holder

		if not arg_89_2 then
			local var_89_1 = {
				false,
				false,
				[arg_89_1[1] or 1] = true
			}

			var_89_0.damageByHpRateBuff = {
				rateMax = arg_89_1[3] or 1,
				rateAdd = arg_89_1[2] or 1,
				selectTargetTab = var_89_1,
				rateFunc = function(arg_90_0, arg_90_1, arg_90_2)
					if arg_90_0.selectTargetTab[arg_90_2] then
						local var_90_0 = (arg_90_1:hpMax() - arg_90_1:hp()) / arg_90_1:hpMax()

						return math.min(var_90_0, arg_90_0.rateMax) * arg_90_0.rateAdd * 100
					end

					return 0
				end
			}
		else
			var_89_0.damageByHpRateBuff = nil
		end

		return true
	end,
	immuneControlAdd = function(arg_91_0, arg_91_1, arg_91_2)
		var_0_12(arg_91_0, arg_91_1, arg_91_2)

		return true
	end,
	controlPerAdd = function(arg_92_0, arg_92_1, arg_92_2)
		var_0_12(arg_92_0, arg_92_1, arg_92_2)

		return true
	end,
	immuneControlVal = function(arg_93_0, arg_93_1, arg_93_2)
		if arg_93_1 and type(arg_93_1) == "number" then
			arg_93_1 = arg_93_1 / ConstSaltNumbers.wan
		end

		var_0_12(arg_93_0, arg_93_1, arg_93_2)

		return true
	end,
	controlPerVal = function(arg_94_0, arg_94_1, arg_94_2)
		if arg_94_1 and type(arg_94_1) == "number" then
			arg_94_1 = arg_94_1 / ConstSaltNumbers.wan
		end

		var_0_12(arg_94_0, arg_94_1, arg_94_2)

		return true
	end,
	damageCapped = function(arg_95_0, arg_95_1, arg_95_2)
		local var_95_0 = arg_95_0.holder
		local var_95_1 = arg_95_0.caster
		local var_95_2 = var_95_1.curSkill

		if arg_95_2 then
			local var_95_3 = var_95_1.damageCappedBuff

			if var_95_1.damageCappedBuff then
				if var_95_0:isDeath() == false then
					local var_95_4 = var_95_3.damage
					local var_95_5 = var_95_3.args[var_95_3.index]
					local var_95_6 = {
						isBeginDamageSeg = true,
						isLastDamageSeg = true,
						from = battle.DamageFrom.buff,
						skillDamageType = battle.SkillDamageType.Special
					}
					local var_95_7 = gRootViewProxy:proxy():pushDeferList(var_95_2.id, "switchToPlay05")

					arg_95_0.holder:beAttack(var_95_1, var_95_4 * var_95_5, 5, var_95_6)

					if var_95_1 and var_95_2 and var_95_2.isSpellTo and var_95_2.owner.id ~= var_95_0.id then
						battleEasy.deferNotify(nil, "showNumber", {
							typ = "damage",
							delta = math.floor(var_95_4),
							skillId = var_95_2.id
						})
					end

					local var_95_8 = gRootViewProxy:proxy():popDeferList(var_95_7)

					if var_95_2 then
						var_95_2:pushDefreListToSkillEnd("skillEndDeleteDeadObjs", var_95_8)

						if var_95_0:isDeath() then
							table.insert(var_95_1.curSkill.killedTargetsTb, arg_95_0.holder)
						end
					end

					var_95_1.damageCappedBuff.index = var_95_1.damageCappedBuff.index + 1
				end

				if var_95_1.damageCappedBuff.index > table.length(var_95_3.args) then
					var_95_1.damageCappedBuff = nil
				end
			end
		elseif var_95_0:isDeath() then
			var_95_1.damageCappedBuff = {
				index = 1,
				damage = math.abs(var_95_0.hpTable[3]),
				args = arg_95_1
			}
		end

		return true
	end,
	damageAllocate = function(arg_96_0, arg_96_1, arg_96_2)
		local var_96_0 = arg_96_0.holder
		local var_96_1 = arg_96_0.cfgId

		if not arg_96_2 then
			local var_96_2 = arg_96_0:getObjectsByCfg(arg_96_1[2])
			local var_96_3 = {}

			for iter_96_0, iter_96_1 in ipairs(var_96_2) do
				table.insert(var_96_3, iter_96_1.id)
			end

			var_96_0:addOverlaySpecBuff(arg_96_0, function(arg_97_0)
				arg_97_0.rate = arg_96_1[1]
				arg_97_0.targetIds = var_96_3
				arg_97_0.damageMode = arg_96_1[3] or 1
				arg_97_0.priority = arg_96_1[4] or 10

				function arg_97_0.getNewTargetIds()
					local var_98_0 = arg_96_0:getObjectsByCfg(arg_96_1[2])
					local var_98_1 = {}

					for iter_98_0, iter_98_1 in ipairs(var_98_0) do
						table.insert(var_98_1, iter_98_1.id)
					end

					return var_98_1
				end

				arg_97_0.targetIdsList = {}
			end, function(arg_99_0, arg_99_1)
				if arg_99_0.priority == arg_99_1.priority then
					return arg_99_0.id < arg_99_1.id
				else
					return arg_99_0.priority > arg_99_1.priority
				end
			end)
		else
			var_96_0:deleteOverlaySpecBuff(arg_96_0)
		end

		return true
	end,
	damageLink = function(arg_100_0, arg_100_1, arg_100_2)
		local var_100_0 = arg_100_0.holder
		local var_100_1 = var_100_0.id
		local var_100_2 = arg_100_0.cfgId

		if not arg_100_2 then
			local var_100_3 = arg_100_0:cfg2Value(arg_100_1[1])
			local var_100_4 = arg_100_1[2]
			local var_100_5 = arg_100_1[3] == 1 and arg_100_0.caster.id or nil

			arg_100_0.scene.buffGlobalManager:setDamageLinkRecord(var_100_1, var_100_2, var_100_3, var_100_4, var_100_5)

			if not var_100_0.damageLinkBuff then
				var_100_0.damageLinkBuff = {}
			end

			if not itertools.include(var_100_0.damageLinkBuff, var_100_2) then
				table.insert(var_100_0.damageLinkBuff, var_100_2)
			end
		else
			arg_100_0.scene.buffGlobalManager:cleanDamageLinkRecord(var_100_1, var_100_2)

			local var_100_6

			for iter_100_0, iter_100_1 in ipairs(var_100_0.damageLinkBuff) do
				if iter_100_1 == var_100_2 then
					var_100_6 = iter_100_0

					break
				end
			end

			table.remove(var_100_0.damageLinkBuff, var_100_6)
		end
	end,
	changeImage = function(arg_101_0, arg_101_1, arg_101_2)
		if not arg_101_2 then
			arg_101_0.holder.scene:addObjViewToBattleTurn(arg_101_0.holder, "addBuffHolderAction", arg_101_0.id, "changeImage", arg_101_1)
			arg_101_0.holder:addOverlaySpecBuff(arg_101_0, function(arg_102_0)
				return
			end)
		else
			arg_101_0.holder.scene:addObjViewToBattleTurn(arg_101_0.holder, "delBuffHolderAction", arg_101_0.id, "changeImage")
			arg_101_0.holder:deleteOverlaySpecBuff(arg_101_0)
		end

		return true
	end,
	changeUnit = function(arg_103_0, arg_103_1, arg_103_2)
		local var_103_0 = true
		local var_103_1 = true

		if not arg_103_2 then
			table.insert(arg_103_0.holder.changeUnitIDTb, {
				arg_103_0.id,
				arg_103_1,
				true
			})
			arg_103_0:setValue(arg_103_0.holder.unitID)
			var_0_7(arg_103_0, arg_103_1)
			var_0_8(arg_103_0, arg_103_1)
			arg_103_0.holder.scene:addObjViewToBattleTurn(arg_103_0.holder, "SortReloadUnit", {
				buffId = arg_103_0.id,
				isRestore = arg_103_2
			})
			logf.battle.object.changeImage(" seat:%d changeUnit 变身后unitid:%d", arg_103_0.holder.seat, arg_103_0.holder.unitID)
		else
			local var_103_2 = type(arg_103_0.value) == "table" and arg_103_0.value[1] or arg_103_0.value
			local var_103_3, var_103_4, var_103_5 = var_0_6(arg_103_0, var_103_2)
			local var_103_6 = var_103_5
			local var_103_7 = var_103_4

			if var_103_3 then
				var_0_7(arg_103_0, var_103_7, true)
			end

			if var_103_6 then
				if arg_103_0.holder.curSkill and not arg_103_0.holder.curSkill.isSpellTo then
					arg_103_0.holder.curSkill = nil
				end

				var_0_8(arg_103_0, var_103_7, true)
			end

			arg_103_0.holder.scene:addObjViewToBattleTurn(arg_103_0.holder, "SortReloadUnit", {
				buffId = arg_103_0.id,
				isRestore = arg_103_2
			})
		end

		return true
	end,
	changeToRandEnemyObj = function(arg_104_0, arg_104_1, arg_104_2)
		local var_104_0 = arg_104_0.holder

		if not arg_104_2 then
			local var_104_1 = arg_104_0:getObjectsByCfg(arg_104_1[1])
			local var_104_2

			if var_104_1 and next(var_104_1) then
				var_104_2 = var_104_1[ymrand.random(1, table.length(var_104_1))]
			else
				return true
			end

			table.insert(arg_104_0.holder.changeUnitIDTb, {
				arg_104_0.id,
				var_104_2.unitID,
				true
			})

			if var_104_2.unitID == arg_104_0.holder.unitID then
				return true
			end

			logf.battle.object.changeImage(" seat:%d changeToRandEnemyObj 变身后unitid:%d", arg_104_0.holder.seat, arg_104_0.holder.unitID)
			var_104_0:addOverlaySpecBuff(arg_104_0, function(arg_105_0)
				arg_105_0.changeUnitBuffs = {}
				arg_105_0.oldUnitCfg = arg_104_0.holder.unitCfg
			end)
			arg_104_0:setValue({
				arg_104_0.holder.unitID,
				arg_104_1[2]
			})
			var_0_7(arg_104_0, var_104_2.unitID, false, var_104_2.skillInfo, arg_104_1)
			var_0_8(arg_104_0, var_104_2.unitID, false, var_104_2.skillInfo, arg_104_1)
			arg_104_0.holder.scene:addObjViewToBattleTurn(arg_104_0.holder, "SortReloadUnit", {
				buffId = arg_104_0.id,
				isRestore = arg_104_2
			})
		elseif next(arg_104_0.holder.changeUnitIDTb) then
			arg_104_0:setValue({
				arg_104_0.holder.unitID,
				arg_104_1[2]
			})

			local var_104_3 = arg_104_0.holder.state == battle.ObjectState.dead and arg_104_0.holder:canReborn()

			var_0_0.changeUnit(arg_104_0, nil, true)

			local var_104_4 = var_104_0:getOverlaySpecBuffByIdx("changeToRandEnemyObj")

			for iter_104_0, iter_104_1 in arg_104_0.holder:iterBuffs() do
				if var_104_4 and itertools.include(var_104_4.changeUnitBuffs, iter_104_1.id) and (not var_104_3 or iter_104_1.csvCfg.easyEffectFunc ~= "reborn") then
					iter_104_1:overClean()
				end
			end

			var_104_0:deleteOverlaySpecBuff(arg_104_0)
		end

		return true
	end,
	changeShape = function(arg_106_0, arg_106_1, arg_106_2)
		local function var_106_0()
			for iter_107_0, iter_107_1 in arg_106_0.holder:iterSkills() do
				if iter_107_1.skillType2 == battle.MainSkillType.SmallSkill then
					return iter_107_1
				end
			end
		end

		if arg_106_0.holder.multiShapeTb then
			local var_106_1 = arg_106_0.holder.multiShapeTb[1]
			local var_106_2 = var_106_0()

			if var_106_2 and var_106_2:getLeftCDRound() > 0 then
				arg_106_0.holder.multiShapeTb[2][var_106_1] = var_106_2:getLeftCDRound() - 1
			end
		end

		var_0_0.changeUnit(arg_106_0, arg_106_1, arg_106_2)

		if arg_106_0.holder.multiShapeTb then
			arg_106_0.holder.multiShapeTb[1] = 3 - arg_106_0.holder.multiShapeTb[1]

			if not arg_106_2 and arg_106_0.csvCfg.specialVal and arg_106_0.csvCfg.specialVal[2] then
				for iter_106_0, iter_106_1 in ipairs(arg_106_0.csvCfg.specialVal[2]) do
					arg_106_0.holder.multiShapeTb[3][iter_106_1] = true
				end
			end

			local var_106_3 = var_106_0()

			if var_106_3 then
				local var_106_4 = arg_106_0.holder.multiShapeTb[1]

				if arg_106_0.holder.multiShapeTb[2][var_106_4] then
					var_106_3.spellRound = arg_106_0.holder:getBattleRound(2) - (var_106_3.cdRound - arg_106_0.holder.multiShapeTb[2][var_106_4])
				end
			end
		end
	end,
	selfDamageToHpRate = function(arg_108_0, arg_108_1, arg_108_2)
		if not arg_108_2 then
			local var_108_0 = arg_108_1
			local var_108_1 = arg_108_0.objThatTriggeringMeNow
			local var_108_2 = arg_108_0.holder
			local var_108_3 = 0
			local var_108_4 = arg_108_0.csvCfg.specialVal and arg_108_0.csvCfg.specialVal[1]
			local var_108_5 = {
				ignoreBeHealAddRate = true,
				from = battle.ResumeHpFrom.buff
			}

			var_108_2.lastRealTotalDamage = var_108_2.lastRealTotalDamage or 0

			if var_108_1:isNormalSkillType() then
				local var_108_6 = 0

				for iter_108_0, iter_108_1 in var_108_1:pairsTargetsFinalResult(battle.SkillSegType.damage) do
					var_108_6 = var_108_6 + iter_108_1.real:get(battle.ValueType.normal)
				end

				var_108_2.lastRealTotalDamage = var_108_6
			end

			if var_108_4 then
				var_108_5.ignoreLockResume = battleEasy.ifElse(var_108_4.ignoreLockResume, var_108_4.ignoreLockResume, var_108_5.ignoreLockResume)
				var_108_5.ignoreBeHealAddRate = battleEasy.ifElse(var_108_4.ignoreBeHealAddRate, var_108_4.ignoreBeHealAddRate, var_108_5.ignoreBeHealAddRate)
			end

			local var_108_7 = var_108_2.lastRealTotalDamage

			if var_108_0 then
				var_108_7 = var_108_7 * var_108_0
			end

			if var_108_7 ~= 0 then
				if (not var_108_4 or not var_108_4.ignoreToDamage) and var_108_2:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.healTodamage) then
					var_108_2:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.healTodamage, "doBuffDamage", attacker, var_108_2, var_108_7, arg_108_0.cfgId)
				else
					var_108_2:resumeHp(var_108_2, math.floor(var_108_7), var_108_5)
				end
			end
		end

		return true
	end,
	otherBuffEnhance = function(arg_109_0, arg_109_1, arg_109_2)
		local var_109_0 = arg_109_1[1]
		local var_109_1 = arg_109_1[2]
		local var_109_2 = arg_109_0.holder

		arg_109_1[3] = arg_109_1[3] or 1

		if not arg_109_2 then
			if arg_109_1[3] == 1 then
				for iter_109_0, iter_109_1 in ipairs(var_109_0) do
					var_109_2:addBuffEnhance(iter_109_1, arg_109_0.cfgId, var_109_1, arg_109_1[3])
				end
			elseif arg_109_1[3] == 2 then
				for iter_109_2, iter_109_3 in ipairs(var_109_0) do
					var_109_2:addBuffEnhance(iter_109_3, arg_109_0.cfgId, var_109_1, arg_109_1[3])

					for iter_109_4, iter_109_5 in var_109_2:iterBuffs() do
						if iter_109_5.isNumberType and iter_109_5:group() == iter_109_3 then
							iter_109_5:refreshLerpValue()
						end
					end
				end
			end
		elseif arg_109_1[3] == 1 or arg_109_1[3] == 2 then
			for iter_109_6, iter_109_7 in ipairs(var_109_0) do
				var_109_2:delBuffEnhance(iter_109_7, arg_109_0.cfgId, arg_109_1[3])

				if arg_109_1[3] == 2 then
					for iter_109_8, iter_109_9 in var_109_2:iterBuffs() do
						if iter_109_9.isNumberType and iter_109_9:group() == iter_109_7 then
							iter_109_9:refreshLerpValue()
						end
					end
				end
			end
		end
	end,
	keepHpUnChanged = function(arg_110_0, arg_110_1, arg_110_2)
		local var_110_0 = arg_110_0.holder

		if not arg_110_2 then
			var_110_0:addOverlaySpecBuff(arg_110_0, function(arg_111_0)
				arg_111_0.triggerTime = arg_110_1[1]
				arg_111_0.prob = arg_110_1[2]
			end)
		else
			var_110_0:deleteOverlaySpecBuff(arg_110_0)
		end

		return true
	end,
	updSkillSpellRoundOnce = function(arg_112_0, arg_112_1, arg_112_2)
		local var_112_0 = arg_112_0.holder

		if not arg_112_2 then
			for iter_112_0, iter_112_1 in var_112_0:iterSkills() do
				if iter_112_1.skillType2 == battle.MainSkillType.SmallSkill then
					local var_112_1 = false
					local var_112_2 = var_112_0.scene.play.curHero

					if var_112_2 then
						var_112_1 = var_112_2.id == var_112_0.id
					end

					local var_112_3 = var_112_1 and -1 or 0

					if iter_112_1.spellRound == -99 then
						iter_112_1.spellRound = var_112_0:getBattleRound(2) - iter_112_1.cdRound + var_112_3
					end

					iter_112_1.spellRound = iter_112_1.spellRound - arg_112_1
				end
			end
		end

		return true
	end,
	lockHp = function(arg_113_0, arg_113_1, arg_113_2)
		local var_113_0 = arg_113_0.holder

		if not arg_113_2 then
			arg_113_0.buffValue[1] = arg_113_0.buffValue[1] or 1

			arg_113_0:setValue(arg_113_0.buffValue)
			var_113_0:addOverlaySpecBuff(arg_113_0, function(arg_114_0)
				arg_114_0.buff = arg_113_0

				arg_114_0:bind("triggerTime", 1)

				arg_114_0.triggerEndRound = arg_113_1[2]
				arg_114_0.mode = arg_113_1[3]
				arg_114_0.extraArg = arg_113_1[4]
				arg_114_0.priority = arg_113_1[5] or 0
				arg_114_0.isPreDelete = false

				if arg_114_0.mode ~= 1 then
					arg_114_0.damageMap = {}
				end

				function arg_114_0.checkCondition(arg_115_0, arg_115_1)
					local var_115_0 = false

					if not arg_113_0.csvCfg.specialVal then
						var_115_0 = true
					else
						arg_113_0.protectedEnv = battleCsv.fillFuncEnv(arg_113_0.protectedEnv, {
							attacker = arg_115_1
						})
						var_115_0 = arg_113_0:cfg2Value(arg_113_0.csvCfg.specialVal[1])

						arg_113_0.protectedEnv:resetEnv()
					end

					return var_115_0
				end
			end, function(arg_116_0, arg_116_1)
				if arg_116_0.priority == arg_116_1.priority then
					if arg_116_0.mode == arg_116_1.mode then
						return arg_116_0.buff.id < arg_116_1.buff.id
					else
						return arg_116_0.mode > arg_116_1.mode
					end
				else
					return arg_116_0.priority > arg_116_1.priority
				end
			end)
		else
			var_113_0:deleteOverlaySpecBuff(arg_113_0)
		end

		return true
	end,
	copyCasterBuffsToHolder = function(arg_117_0, arg_117_1, arg_117_2)
		if not arg_117_2 then
			var_0_10(arg_117_0, arg_117_1, false, false)
		end

		return true
	end,
	transferBuffToOther = function(arg_118_0, arg_118_1, arg_118_2)
		if not arg_118_2 then
			var_0_10(arg_118_0, arg_118_1, true, false)
		end

		return true
	end,
	copyForceBuffsToOther = function(arg_119_0, arg_119_1, arg_119_2)
		if not arg_119_2 then
			var_0_10(arg_119_0, arg_119_1, false, true)
		end

		return true
	end,
	cantDispelBuffRound = function(arg_120_0, arg_120_1, arg_120_2)
		if not arg_120_2 then
			arg_120_0.holder.cantDispelTb = {
				buffGroupTb = arraytools.hash(arg_120_1),
				buffRound = arg_120_0.csvCfg.specialVal[1]
			}
		else
			arg_120_0.holder.cantDispelTb = nil
		end
	end,
	changeSpeedPriority = function(arg_121_0, arg_121_1, arg_121_2)
		local var_121_0 = arg_121_0.csvCfg.specialVal and arg_121_0.csvCfg.specialVal[1]
		local var_121_1 = arg_121_0.holder.scene.play

		if not arg_121_2 then
			if var_121_0 == 1 then
				local function var_121_2(arg_122_0)
					if not arg_121_1[2] then
						return true
					end

					return arg_122_0 == arg_121_1[2]
				end

				table.insert(var_121_1.speedSortRule, {
					id = arg_121_0.id,
					sort = function(arg_123_0)
						local var_123_0 = arg_121_0.scene.play:getObjectBaseSpeedRankSortKey(arg_121_0.holder)
						local var_123_1
						local var_123_2

						for iter_123_0, iter_123_1 in ipairs(arg_123_0) do
							if iter_123_1.objId == var_123_0 and var_121_2(iter_123_1.buffCfgId) then
								var_123_1 = var_123_1 or iter_123_0
							elseif iter_123_1.force == arg_121_0.holder.force then
								if arg_121_1[1] == 1 then
									var_123_2 = var_123_2 or math.max(1, var_123_1 and iter_123_0 - 1 or iter_123_0)
								else
									var_123_2 = math.min(table.length(arg_123_0), var_123_1 and iter_123_0 or iter_123_0 + 1)
								end
							end
						end

						if var_123_1 and var_123_2 then
							local var_123_3 = table.remove(arg_123_0, var_123_1)

							table.insert(arg_123_0, var_123_2, var_123_3)
						end
					end
				})
			else
				local function var_121_3(arg_124_0, arg_124_1, arg_124_2)
					if arg_121_0.csvCfg.specialVal and var_121_0 == 2 and arg_124_0 == arg_121_0.holder.force then
						return arg_124_2
					end

					local var_124_0 = arg_121_0.scene:getHerosMap(arg_124_0)
					local var_124_1 = arg_124_2

					for iter_124_0, iter_124_1 in var_124_0:order_pairs() do
						var_124_1 = var_124_1 or iter_124_1.speedPriority
						var_124_1 = arg_124_1 == 1 and math.max(var_124_1, iter_124_1.speedPriority) or math.min(var_124_1, iter_124_1.speedPriority)
					end

					return var_124_1
				end

				local var_121_4 = var_121_3(1, arg_121_1[1], nil)
				local var_121_5 = var_121_3(2, arg_121_1[1], var_121_4)

				arg_121_0.holder.speedPriority = var_121_5 + arg_121_1[1]
			end
		elseif var_121_0 == 1 then
			for iter_121_0, iter_121_1 in ipairs(var_121_1.speedSortRule) do
				if iter_121_1.id == arg_121_0.id then
					table.remove(var_121_1.speedSortRule, iter_121_0)

					return
				end
			end
		else
			arg_121_0.holder.speedPriority = 0
		end
	end,
	resetBattleRound = function(arg_125_0, arg_125_1, arg_125_2)
		if not arg_125_2 then
			local var_125_0 = arg_125_0.holder
			local var_125_1 = {
				obj = var_125_0,
				reset = arg_125_0.id,
				buffCfgId = arg_125_0.cfgId,
				mode = battle.ExtraBattleRoundMode.reset
			}

			battleEasy.resetGateAttackRecord(var_125_0, var_125_1)
		end
	end,
	atOnceBattleRound = function(arg_126_0, arg_126_1, arg_126_2)
		if not arg_126_2 then
			local var_126_0 = arg_126_0.holder
			local var_126_1 = {
				obj = var_126_0,
				atOnce = arg_126_0.id,
				buffCfgId = arg_126_0.cfgId,
				mode = battle.ExtraBattleRoundMode.atOnce
			}

			battleEasy.resetGateAttackRecord(var_126_0, var_126_1)
		end
	end,
	geminiBattleRound = function(arg_127_0, arg_127_1, arg_127_2)
		if not arg_127_2 then
			local var_127_0 = arg_127_0.holder
			local var_127_1 = {
				another = true,
				obj = var_127_0,
				buffCfgId = arg_127_0.cfgId,
				mode = battle.ExtraBattleRoundMode.gemini
			}

			battleEasy.resetGateAttackRecord(var_127_0, var_127_1)
		end
	end,
	stealth = function(arg_128_0, arg_128_1, arg_128_2)
		local var_128_0 = arg_128_0.holder

		if not arg_128_2 then
			var_128_0:addOverlaySpecBuff(arg_128_0, function(arg_129_0)
				arg_129_0.cantBeAttackSwitch = arg_128_1[1] == 0
				arg_129_0.cantBeAddBuffSwitch = arg_128_1[2] == 0
				arg_129_0.cantBeHealHintSwitch = arg_128_1[3] == 0
			end, nil)
		else
			var_128_0:deleteOverlaySpecBuff(arg_128_0)
		end
	end,
	ignoreSpecBuff = function(arg_130_0, arg_130_1, arg_130_2)
		local var_130_0 = arg_130_0.holder

		if not arg_130_2 then
			var_130_0:addOverlaySpecBuff(arg_130_0, function(arg_131_0)
				arg_131_0.cfgIds = itertools.map(arg_130_1 or {}, function(arg_132_0, arg_132_1)
					return arg_132_1, true
				end)
				arg_131_0.specBuffList = itertools.map(arg_130_0.csvCfg.specialVal or {}, function(arg_133_0, arg_133_1)
					return arg_133_1, true
				end)
			end, nil)
		else
			var_130_0:deleteOverlaySpecBuff(arg_130_0)
		end
	end,
	leave = function(arg_134_0, arg_134_1, arg_134_2)
		if type(arg_134_1) == "number" then
			arg_134_1 = {
				arg_134_1
			}
		end

		local var_134_0 = arg_134_0.holder

		if not arg_134_2 then
			var_134_0:addOverlaySpecBuff(arg_134_0, function(arg_135_0)
				arg_135_0.canAttack = arg_134_1 and arg_134_1[1] == 0
			end, nil)
		else
			var_134_0:deleteOverlaySpecBuff(arg_134_0)
		end

		var_134_0:onFieldStateChange(arg_134_2)
	end,
	depart = function(arg_136_0, arg_136_1, arg_136_2)
		local var_136_0 = arg_136_0.holder

		if not arg_136_2 then
			var_136_0:addOverlaySpecBuff(arg_136_0, function(arg_137_0)
				arg_137_0.cantBeAttackSwitch = arg_136_1[1] == 0
				arg_137_0.cantBeAddBuffSwitch = arg_136_1[2] == 0
				arg_137_0.cantBeHealHintSwitch = arg_136_1[3] == 0
				arg_137_0.leaveSwitch = arg_136_1[4] == 0
				arg_137_0.canAttack = arg_136_1[5] == 0
				arg_137_0.canProtect = arg_136_1[6] == 0
			end, nil)
		else
			var_136_0:deleteOverlaySpecBuff(arg_136_0)
		end

		if arg_136_1[4] == 0 then
			var_136_0:onFieldStateChange(arg_136_2)
		end
	end,
	bufflink = function(arg_138_0, arg_138_1, arg_138_2)
		local var_138_0 = arg_138_0.holder
		local var_138_1 = arg_138_1[1]
		local var_138_2 = arg_138_1[2]
		local var_138_3 = arg_138_0:getObjectsByCfg(arg_138_1[3])
		local var_138_4 = {}

		for iter_138_0, iter_138_1 in ipairs(var_138_3) do
			table.insert(var_138_4, iter_138_1.id)
		end

		if not arg_138_2 then
			for iter_138_2, iter_138_3 in ipairs(var_138_4) do
				arg_138_0.scene.buffGlobalManager:setBuffLinkValue(var_138_0.id, iter_138_3, var_138_1, var_138_2, arg_138_0.cfgId)
			end
		else
			arg_138_0.scene.buffGlobalManager:onBuffLinkOver(arg_138_0.cfgId)
		end

		return true
	end,
	refreshBuffLifeRound = function(arg_139_0, arg_139_1, arg_139_2)
		if not arg_139_2 then
			for iter_139_0, iter_139_1 in ipairs(arg_139_1) do
				local var_139_0 = iter_139_1[2]
				local var_139_1

				if iter_139_1[3] then
					local var_139_2 = iter_139_1[1]

					for iter_139_2, iter_139_3 in arg_139_0.holder:iterBuffs() do
						if iter_139_3:group() == var_139_2 then
							iter_139_3.lifeRound = type(var_139_0) == "table" and var_139_0[iter_139_3.cfgId] or var_139_0
						end
					end
				else
					for iter_139_4, iter_139_5 in arg_139_0.holder:iterBuffs() do
						if iter_139_5.cfgId == iter_139_1[1] then
							iter_139_5.lifeRound = var_139_0
						end
					end
				end
			end
		end

		return true
	end,
	changeBuffLifeRound = function(arg_140_0, arg_140_1, arg_140_2)
		local var_140_0 = arg_140_0.holder

		if not arg_140_2 then
			local var_140_1 = {}
			local var_140_2 = {}
			local var_140_3 = arg_140_0:cfg2Value(arg_140_1[2])
			local var_140_4 = var_140_2

			if arg_140_1[3] then
				var_140_4 = var_140_1
			end

			for iter_140_0, iter_140_1 in ipairs(arg_140_1[1]) do
				var_140_4[iter_140_1] = var_140_3
			end

			for iter_140_2, iter_140_3 in var_140_0:iterBuffs() do
				local var_140_5 = var_140_1[iter_140_3:group()] or var_140_2[iter_140_3.cfgId]

				if var_140_5 then
					iter_140_3.lifeRound = iter_140_3.lifeRound + var_140_5

					if iter_140_3.lifeRound <= 0 then
						iter_140_3:over()
					end
				end
			end

			var_140_0:addOverlaySpecBuff(arg_140_0, function(arg_141_0)
				arg_141_0.gourpTb = var_140_1
				arg_141_0.buffIdTb = var_140_2

				function arg_141_0.getExtraRound(arg_142_0, arg_142_1)
					return arg_141_0.gourpTb[arg_142_0] or arg_141_0.buffIdTb[arg_142_1] or 0
				end
			end, nil)
		else
			var_140_0:deleteOverlaySpecBuff(arg_140_0)
		end

		return true
	end,
	mp1OverFlow = function(arg_143_0, arg_143_1, arg_143_2)
		local var_143_0 = arg_143_0.holder

		if not arg_143_2 then
			local var_143_1 = math.max(arg_143_0.holder:mp1() - arg_143_0.holder:mp1Max(), 0)
			local var_143_2 = arg_143_1[1]
			local var_143_3 = arg_143_1[3]

			if var_143_2 == 1 then
				var_143_3 = arg_143_1[2] * var_143_3
			end

			var_143_0.mp1Table[3] = cc.clampf(var_143_1, 0, var_143_3)

			local var_143_4 = {
				changeMpOverflowInCharge = false,
				affectNormalMpFromBuff = false,
				affectNormalMpInCharge = false
			}
			local var_143_5 = arg_143_0.csvCfg.specialVal and arg_143_0.csvCfg.specialVal[1] or {}

			if var_143_5 then
				var_143_4.changeMpOverflowInCharge = battleEasy.ifElse(var_143_5.changeMpOverflowInCharge, var_143_5.changeMpOverflowInCharge, var_143_4.changeMpOverflowInCharge)
				var_143_4.affectNormalMpInCharge = battleEasy.ifElse(var_143_5.affectNormalMpInCharge, var_143_5.affectNormalMpInCharge, var_143_4.affectNormalMpInCharge)
				var_143_4.affectNormalMpFromBuff = battleEasy.ifElse(var_143_5.affectNormalMpFromBuff, var_143_5.affectNormalMpFromBuff, var_143_4.affectNormalMpFromBuff)
			end

			var_143_0:addOverlaySpecBuff(arg_143_0, function(arg_144_0)
				arg_144_0.mode = var_143_2
				arg_144_0.rate = arg_143_1[2]
				arg_144_0.limit = var_143_2 == 1 and arg_143_1[2] * arg_143_1[3] or arg_143_1[3]
				arg_144_0.cost = arg_143_1[4]
				arg_144_0.extraArgs = var_143_4
			end, nil)
		else
			var_143_0:deleteOverlaySpecBuff(arg_143_0)
		end

		return true
	end,
	calDmgKeepDefence = function(arg_145_0, arg_145_1, arg_145_2)
		if not arg_145_2 then
			if arg_145_1 == 1 then
				function arg_145_0.holder.calDmgKeepDefenceBuff(arg_146_0, arg_146_1)
					return math.min(arg_146_0, arg_146_1)
				end
			else
				function arg_145_0.holder.calDmgKeepDefenceBuff(arg_147_0, arg_147_1)
					return math.max(arg_147_0, arg_147_1)
				end
			end
		else
			arg_145_0.holder.calDmgKeepDefenceBuff = nil
		end
	end,
	kill = function(arg_148_0, arg_148_1, arg_148_2)
		if not arg_148_2 then
			local var_148_0 = arg_148_0.csvCfg.specialVal
			local var_148_1 = {
				isBeginDamageSeg = true,
				isLastDamageSeg = true,
				from = battle.DamageFrom.buff,
				hideHeadNumber = var_148_0 and var_148_0[1]
			}

			arg_148_0.holder:beAttack(arg_148_0.caster, math.ceil(arg_148_0.holder:hp()), battle.JumpAllDamageProcessId, var_148_1)
			arg_148_0:over()
		end
	end,
	counterAttack = function(arg_149_0, arg_149_1, arg_149_2)
		local var_149_0 = arg_149_0.holder

		if not arg_149_2 then
			var_149_0:addOverlaySpecBuff(arg_149_0, function(arg_150_0)
				arg_150_0.triggerSkillType2 = arg_149_1[1]
				arg_150_0.triggerSkillType = type(arg_149_1[1])
				arg_150_0.rate = arg_149_1[2]
				arg_150_0.find = functools.partial(arg_149_0.getObjectsByCfg, arg_149_0, arg_149_0.csvCfg.specialTarget and arg_149_0.csvCfg.specialTarget[1] or 1)
				arg_150_0.costType = arg_149_1[3] or 0
				arg_150_0.mustEnemy = arg_149_1[4] == 1
			end, nil)
		else
			var_149_0:deleteOverlaySpecBuff(arg_149_0)
		end
	end,
	comboAttack = function(arg_151_0, arg_151_1, arg_151_2)
		if not arg_151_2 then
			arg_151_0.holder.comboAttackInfo = {
				rate = arg_151_1[1]
			}
		else
			arg_151_0.holder.comboAttackInfo = nil
		end
	end,
	canelToAttack = function(arg_152_0, arg_152_1, arg_152_2)
		if not arg_152_2 then
			arg_152_0.holder.ignoreToAttack = true
		else
			arg_152_0.holder.ignoreToAttack = false
		end
	end,
	syncAttack = function(arg_153_0, arg_153_1, arg_153_2)
		local var_153_0 = arg_153_0.holder
		local var_153_1

		var_153_1 = arg_153_0.csvCfg.easyEffectFunc == "syncAttack"

		local function var_153_2(arg_154_0, arg_154_1)
			if arg_154_0 then
				for iter_154_0, iter_154_1 in ipairs(arg_154_0) do
					if iter_154_1 == arg_154_1 then
						return true
					end
				end
			end

			return not arg_154_0
		end

		if not arg_153_2 then
			var_153_0:addOverlaySpecBuff(arg_153_0, function(arg_155_0)
				arg_155_0.triggerSkillType2 = arg_153_1[1]
				arg_155_0.triggerSkillType = type(arg_153_1[1])
				arg_155_0.rate = arg_153_1[2]
				arg_155_0.isTrigger = functools.partial(var_153_2, arg_153_0.csvCfg.specialVal)
				arg_155_0.find = functools.partial(arg_153_0.getObjectsByCfg, arg_153_0, arg_153_0.csvCfg.specialTarget and arg_153_0.csvCfg.specialTarget[1])
				arg_155_0.costType = arg_153_1[3] or 0
				arg_155_0.isFixedForce = arg_153_1[4] == 1 or false
			end, nil)
		else
			var_153_0:deleteOverlaySpecBuff(arg_153_0)
		end
	end,
	assistAttack = function(arg_156_0, arg_156_1, arg_156_2)
		if not arg_156_2 then
			local var_156_0 = arg_156_0.holder
			local var_156_1 = arg_156_0.csvCfg.specialTarget and arg_156_0.csvCfg.specialTarget[1]
			local var_156_2 = var_156_1 and arg_156_0:getObjectsByCfg(var_156_1)
			local var_156_3 = {
				triggerSkillType2 = arg_156_1[1],
				triggerSkillType = type(arg_156_1[1]),
				rate = arg_156_1[2],
				costType = arg_156_1[3] or 0
			}

			var_156_0:onAssistAttack(var_156_2 and var_156_2[1], var_156_3)
		end
	end,
	inviteAttack = function(arg_157_0, arg_157_1, arg_157_2)
		return var_0_0.syncAttack(arg_157_0, arg_157_1, arg_157_2)
	end,
	protection = function(arg_158_0, arg_158_1, arg_158_2)
		local var_158_0 = type(arg_158_1) == "table" and arg_158_1[1] or arg_158_1
		local var_158_1 = arg_158_0.holder

		if arg_158_0.caster.id == arg_158_0.holder.id then
			return true
		end

		if not arg_158_2 then
			local var_158_2 = arg_158_0.caster

			if var_158_2:isAlreadyDead() then
				arg_158_0:overClean()
			else
				var_158_1:addOverlaySpecBuff(arg_158_0, function(arg_159_0)
					arg_159_0.buff = arg_158_0
					arg_159_0.ratio = var_158_0
					arg_159_0.type = arg_158_0.csvCfg.specialVal and arg_158_0.csvCfg.specialVal[1] or 0
					arg_159_0.priority = arg_158_0.csvCfg.specialVal and arg_158_0.csvCfg.specialVal[2] or 1000
					arg_159_0.extraArgs = arg_158_0.csvCfg.specialVal and arg_158_0.csvCfg.specialVal[3]
					arg_159_0.protectObj = arg_158_0.holder:setProtectObj(var_158_2, var_158_0)

					function arg_159_0.checkCondition(arg_160_0)
						local var_160_0 = false

						if not arg_158_0.csvCfg.specialVal then
							var_160_0 = true
						elseif arg_160_0.protectObj then
							arg_158_0.protectedEnv = battleCsv.fillFuncEnv(arg_158_0.protectedEnv, {
								protector = arg_160_0.protectObj
							})
							var_160_0 = arg_158_0:cfg2Value(arg_160_0.extraArgs[3])

							arg_158_0.protectedEnv:resetEnv()
						end

						return var_160_0
					end
				end, function(arg_161_0, arg_161_1)
					if arg_161_0.priority == arg_161_1.priority then
						return arg_161_0.buff.id < arg_161_1.buff.id
					else
						return arg_161_0.priority > arg_161_1.priority
					end
				end)
			end
		else
			var_158_1:deleteOverlaySpecBuff(arg_158_0)
		end

		return true
	end,
	shiftPos = function(arg_162_0, arg_162_1, arg_162_2)
		if not arg_162_2 then
			local var_162_0 = arg_162_0.csvCfg.specialVal or {}
			local var_162_1 = var_162_0[1]
			local var_162_2 = var_162_0[2]
			local var_162_3
			local var_162_4

			local function var_162_5()
				if var_162_1 and var_162_1 == 1 then
					arg_162_0:overClean()
				end
			end

			if type(arg_162_1) == "table" then
				var_162_3 = arg_162_1[1]
				var_162_4 = arg_162_1[2] and arg_162_0:cfg2Value(arg_162_1[2]) or nil
			else
				var_162_3 = arg_162_1
			end

			if var_162_3 and var_162_4 then
				local var_162_6 = arg_162_0.holder.scene.play.ForceNumber
				local var_162_7 = var_162_6 / 2
				local var_162_8 = 1
				local var_162_9 = var_162_6

				if arg_162_0.holder.force ~= 1 then
					var_162_8, var_162_9 = var_162_8 + var_162_6, var_162_9 + var_162_6
				end

				if var_162_3 == 1 then
					var_162_9 = var_162_9 - var_162_7
				elseif var_162_3 == 2 then
					var_162_8 = var_162_8 + var_162_7
				else
					var_162_9 = var_162_8 - 1
				end

				local var_162_10 = {}

				for iter_162_0, iter_162_1 in arg_162_0.holder.scene:getHerosMap(arg_162_0.holder.force):order_pairs() do
					if iter_162_1 and not iter_162_1:isAlreadyDead() then
						var_162_10[iter_162_1.seat] = 1
					end
				end

				for iter_162_2 = var_162_8, var_162_9 do
					if not var_162_10[iter_162_2] then
						var_162_4 = iter_162_2

						break
					end
				end
			end

			if var_162_4 and var_162_4 < 0 then
				var_162_5()

				return true
			end

			if var_162_3 == 1 and arg_162_0.holder:frontOrBack() == 2 then
				arg_162_0.holder.shiftPos = var_162_4 or arg_162_0.holder.seat - 3
				arg_162_0.holder.shiftPosMode = var_162_3
			elseif var_162_3 == 2 and arg_162_0.holder:frontOrBack() == 1 then
				arg_162_0.holder.shiftPos = var_162_4 or arg_162_0.holder.seat + 3
				arg_162_0.holder.shiftPosMode = var_162_3
			else
				var_162_5()

				return true
			end

			if arg_162_0.holder:canShiftPos() then
				local var_162_11 = csv.buff[var_162_2]

				arg_162_0.holder:doShiftPos(var_162_11)
				arg_162_0:over()
			else
				var_162_5()
			end
		end
	end,
	forbiddenSpecBuff = function(arg_164_0, arg_164_1, arg_164_2)
		local var_164_0 = arg_164_0.csvCfg.specialVal or {}
		local var_164_1 = arg_164_0.holder
		local var_164_2
		local var_164_3

		var_164_3 = type(var_164_0[1]) == "table" and var_164_0[1].easyEffectFunc or {}
		arg_164_0.__temp = arg_164_0.__temp or {}

		for iter_164_0, iter_164_1 in ipairs(var_164_3) do
			local var_164_4

			if not arg_164_2 then
				if arg_164_1 and type(arg_164_1) == "table" and table.length(arg_164_1[1]) > 0 then
					function var_164_4(arg_165_0)
						if itertools.include(arg_164_1[1], arg_165_0.cfgId) then
							return true
						end
					end
				end

				arg_164_0.__temp[iter_164_1] = var_164_1:addOverlaySpecBuffFilter(iter_164_1, var_164_4)
			else
				var_164_1:deleteOverlaySpecBuffFilter(iter_164_1, arg_164_0.__temp[iter_164_1])
			end
		end
	end,
	banExtraAttack = function(arg_166_0, arg_166_1, arg_166_2)
		local var_166_0 = arg_166_0.holder

		if not arg_166_2 then
			local var_166_1 = {}
			local var_166_2 = {}

			if arg_166_0.csvCfg.specialVal then
				for iter_166_0, iter_166_1 in ipairs(arg_166_0.csvCfg.specialVal) do
					var_166_1[iter_166_1] = iter_166_0
				end
			end

			if arg_166_1 then
				for iter_166_2, iter_166_3 in ipairs(arg_166_1) do
					var_166_2[iter_166_2] = {}
					var_166_2[iter_166_2].canResponseSelf = iter_166_3[1] == 1
					var_166_2[iter_166_2].canTriggerOthers = iter_166_3[2] == 1
					var_166_2[iter_166_2].canResponseOthers = iter_166_3[3] == 1
				end
			end

			var_166_0:addOverlaySpecBuff(arg_166_0, function(arg_167_0)
				arg_167_0.banModeTb = var_166_1
				arg_167_0.banModeType = var_166_2
			end)
		else
			var_166_0:deleteOverlaySpecBuff(arg_166_0)
		end
	end,
	transformAttrBuff = function(arg_168_0, arg_168_1, arg_168_2)
		local var_168_0 = arg_168_0.holder

		if not arg_168_2 then
			local var_168_1 = functools.partial(var_0_13, arg_168_1)

			var_168_0:addOverlaySpecBuff(arg_168_0, function(arg_169_0)
				arg_169_0.refreshCfgId = var_168_1
			end, nil)
		else
			var_168_0:deleteOverlaySpecBuff(arg_168_0)
		end
	end,
	delayDamage = function(arg_170_0, arg_170_1, arg_170_2)
		local var_170_0 = arg_170_0.holder

		if not arg_170_2 then
			var_170_0:addOverlaySpecBuff(arg_170_0, function(arg_171_0)
				arg_171_0.delayPer = arg_170_1[1]
				arg_171_0.time = arg_170_1[2]
				arg_171_0.damageTb = {}
			end)
			var_170_0:addOverlaySpecBuffFunc(battle.OverlaySpecBuff.delayDamage, "getRoundDamage", function()
				local var_172_0 = 0

				if var_170_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.delayDamage) then
					for iter_172_0, iter_172_1 in var_170_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.delayDamage) do
						for iter_172_2 = table.length(iter_172_1.damageTb), 1, -1 do
							var_172_0 = var_172_0 + iter_172_1.damageTb[iter_172_2][1]

							table.remove(iter_172_1.damageTb[iter_172_2], 1)

							if table.length(iter_172_1.damageTb[iter_172_2]) <= 0 then
								table.remove(iter_172_1.damageTb, iter_172_2)
							end
						end
					end
				end

				return var_172_0
			end)
		else
			var_170_0:deleteOverlaySpecBuff(arg_170_0)
		end
	end,
	reduceDelayDamage = function(arg_173_0, arg_173_1, arg_173_2)
		local var_173_0 = arg_173_0.holder

		if not arg_173_2 and var_173_0:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.delayDamage) then
			local var_173_1 = arg_173_1
			local var_173_2 = false
			local var_173_3 = 1

			while var_173_1 > 0 and not var_173_2 do
				var_173_2 = true

				for iter_173_0, iter_173_1 in var_173_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.delayDamage) do
					for iter_173_2, iter_173_3 in ipairs(iter_173_1.damageTb) do
						if iter_173_3[var_173_3] then
							var_173_2 = false

							if var_173_1 > iter_173_3[var_173_3] then
								var_173_1 = var_173_1 - iter_173_3[var_173_3]
								iter_173_3[var_173_3] = 0
							else
								iter_173_3[var_173_3] = iter_173_3[var_173_3] - var_173_1
								var_173_1 = 0
							end
						end
					end
				end

				var_173_3 = var_173_3 + 1
			end

			var_173_0:refreshLifeBar()
		end
	end,
	extraSkillWeightValueFix = function(arg_174_0, arg_174_1, arg_174_2)
		local var_174_0 = arg_174_0.holder

		if not arg_174_2 then
			var_174_0:addOverlaySpecBuff(arg_174_0, function(arg_175_0)
				arg_175_0.fixType = arg_174_1[1]
				arg_175_0.fixValue = arg_174_1[2]
				arg_175_0.fixCostType = arg_174_1[3]
			end)
		else
			var_174_0:deleteOverlaySpecBuff(arg_174_0)
		end
	end,
	damgeMustHit = function(arg_176_0, arg_176_1, arg_176_2)
		local var_176_0 = arg_176_0.holder

		if not arg_176_2 then
			var_176_0:addOverlaySpecBuff(arg_176_0, function(arg_177_0)
				return
			end, nil)
		else
			var_176_0:deleteOverlaySpecBuff(arg_176_0)
		end
	end,
	alterDmgRecordVal = function(arg_178_0, arg_178_1, arg_178_2)
		local var_178_0 = arg_178_0.holder

		if not arg_178_2 then
			var_178_0:addOverlaySpecBuff(arg_178_0, function(arg_179_0)
				arg_179_0.assignObject = arg_178_1[1]
				arg_179_0.priority = arg_178_1[2]
				arg_179_0.typ = arg_178_1[3] or 1
				arg_179_0.alterDmgRecordData = arg_178_0.csvCfg.specialVal[1]
			end)
		else
			var_178_0:deleteOverlaySpecBuff(arg_178_0)
		end
	end,
	backStage = function(arg_180_0, arg_180_1, arg_180_2)
		if arg_180_2 then
			return
		end

		local function var_180_0(arg_181_0, arg_181_1)
			for iter_181_0 = table.length(arg_181_0), 1, -1 do
				if (arg_181_0[iter_181_0].obj or arg_181_0[iter_181_0]).id == arg_181_1 then
					table.remove(arg_181_0, iter_181_0)
				end
			end
		end

		local var_180_1 = arg_180_0.holder

		arg_180_0.scene:getHerosMap(var_180_1.force):erase(var_180_1.id)
		arg_180_0.scene:addBackStageObj(var_180_1)

		var_180_1.seat = -1

		var_180_1:onFieldStateChange(false)
		var_180_0(arg_180_0.scene.play.roundLeftHeros, var_180_1.id)
		var_180_0(arg_180_0.scene.play.roundHasAttackedHeros, var_180_1.id)
		battleEasy.deferNotifyCantJump(var_180_1.view, "stageChange", false)
	end,
	frontStage = function(arg_182_0, arg_182_1, arg_182_2)
		if arg_182_2 then
			return
		end

		local var_182_0 = arg_182_0.holder
		local var_182_1 = arg_182_1[1]
		local var_182_2 = arg_182_1[2]
		local var_182_3 = (arg_182_1[3] or 0) * var_182_0:mp1()
		local var_182_4 = arg_182_1[4] == 1 and true or false

		if not var_182_1 or not var_182_2 then
			return
		end

		local var_182_5 = arg_182_0.scene.play

		for iter_182_0, iter_182_1 in arg_182_0.scene.backHeros:order_pairs() do
			if iter_182_1.summonGroup == var_182_0.summonGroup and var_182_2 == iter_182_1.orginUnitId then
				iter_182_1.frontStageTarget = var_182_1

				if var_182_4 then
					iter_182_1.stageRound = var_182_5.curRound
					iter_182_1.stageAttacked = not itertools.include(var_182_5.roundLeftHeros, function(arg_183_0)
						return arg_183_0.obj.id == arg_182_0.holder.id
					end)
				end

				iter_182_1.transferMp = var_182_3

				break
			end
		end
	end,
	escape = function(arg_184_0, arg_184_1, arg_184_2)
		if arg_184_2 then
			return
		end

		local var_184_0 = arg_184_0.holder

		battleEasy.deferNotifyCantJump(var_184_0.view, "escape", {
			delayMove = arg_184_1 and arg_184_1[1],
			costTime = arg_184_1 and arg_184_1[2]
		})
		var_184_0:setDead(var_184_0, nil, {
			force = true
		})
	end,
	atOnceTransformAttrBuff = function(arg_185_0, arg_185_1, arg_185_2)
		if not arg_185_2 then
			local var_185_0 = arg_185_0.holder
			local var_185_1 = {}
			local var_185_2 = arg_185_0.csvCfg.specialVal[1]
			local var_185_3 = 0

			for iter_185_0, iter_185_1 in var_185_0.buffs:order_pairs() do
				local var_185_4, var_185_5, var_185_6, var_185_7 = var_0_13(arg_185_1, iter_185_1.cfgId, iter_185_1:group())

				if iter_185_1.csvPower.beChange == 1 and var_185_4 ~= iter_185_1.cfgId and var_185_5 and var_185_7 and var_185_7.limit and var_185_7.targetType then
					local var_185_8

					if var_185_6 == "number" then
						var_185_8 = string.format("(%s)*%s", arg_185_1.value, var_185_5)
					else
						var_185_8 = string.format("%s", var_185_5)
					end

					local var_185_9 = BuffArgs.fromAtOnceTransform1(iter_185_1, var_185_4, var_185_8, var_185_7.targetType)

					table.insert(var_185_1, var_185_9)

					var_185_3 = var_185_7.limit
				end
			end

			local var_185_10 = random.sample(var_185_1, var_185_3, ymrand.random)

			for iter_185_2, iter_185_3 in ipairs(var_185_10) do
				iter_185_3.oldBuff:overClean()
			end

			local var_185_11 = false

			for iter_185_4, iter_185_5 in ipairs(var_185_10) do
				local var_185_12 = arg_185_0:getObjectsByCfg(iter_185_5.targetType)

				for iter_185_6, iter_185_7 in ipairs(var_185_12) do
					local var_185_13 = BuffArgs.fromAtOnceTransform2(iter_185_5, var_185_2)
					local var_185_14, var_185_15 = addBuffToHero(iter_185_5.cfgId, iter_185_7, iter_185_5.oldHolder, var_185_13)

					var_185_11 = var_185_11 or var_185_15
				end
			end

			if var_185_11 then
				arg_185_0:triggerByMoment(battle.BuffTriggerPoint.onBuffTrigger)
			end
		end
	end,
	specialRecord = function(arg_186_0, arg_186_1, arg_186_2)
		if arg_186_2 then
			return
		end

		local var_186_0 = arg_186_0.csvCfg.specialVal

		if not arg_186_0.specialRecordFunc then
			arg_186_0.specialRecordFunc = functools.partial(function(arg_187_0, arg_187_1, arg_187_2)
				local var_187_0 = 0

				for iter_187_0, iter_187_1 in ipairs(arg_187_0) do
					local var_187_1 = var_0_1[arg_187_1] and var_0_1[arg_187_1](iter_187_1)

					if type(var_187_1) == "number" then
						var_187_0 = var_187_0 + var_187_1
					end
				end

				if arg_187_2 == 1 then
					arg_186_0.specialRecordDiffVal = arg_186_0.specialRecordDiffVal or var_187_0
					var_187_0 = var_187_0 - arg_186_0.specialRecordDiffVal
				end

				return var_187_0
			end, arg_186_0:getObjectsByCfg(var_186_0[2]))
		end

		arg_186_0:setValue(arg_186_0.specialRecordFunc(var_186_0[1], var_186_0[3]))
	end,
	directWin = function(arg_188_0, arg_188_1, arg_188_2)
		local var_188_0 = arg_188_0.holder

		if not arg_188_2 then
			var_188_0:addOverlaySpecBuff(arg_188_0, function(arg_189_0)
				arg_189_0.mode = arg_188_1 or 1
			end, nil)
		else
			var_188_0:deleteOverlaySpecBuff(arg_188_0)
		end
	end,
	mp1Point = function(arg_190_0, arg_190_1, arg_190_2)
		local var_190_0 = arg_190_0.holder

		if not arg_190_2 then
			local var_190_1 = var_190_0:getOverlaySpecBuffByIdx("mp1OverFlow")

			if var_190_1 then
				var_190_1.mp1Point = cc.clampf(var_190_1.mp1Point + arg_190_1, 0, var_190_1.limit)
			end
		end
	end,
	opGameData = function(arg_191_0, arg_191_1, arg_191_2)
		local var_191_0 = arg_191_0.holder
		local var_191_1 = {
			"hintChoose",
			"skillLevel0",
			"skillLevel1",
			"skillLevel2",
			"skillLevel3"
		}

		if not arg_191_2 then
			var_191_0:addOverlaySpecBuff(arg_191_0, function(arg_192_0)
				arg_192_0.key = var_191_1[arg_191_1[1]]
				arg_192_0.op = var_0_2[arg_191_1[2]]
				arg_192_0.value = arg_191_1[3]
				arg_192_0.checkFormula = arg_191_0.csvCfg.specialVal and arg_191_0.csvCfg.specialVal[1] or true
			end, nil)
		else
			var_191_0:deleteOverlaySpecBuff(arg_191_0)
		end
	end,
	changeScaleAttrs = function(arg_193_0, arg_193_1, arg_193_2)
		local var_193_0 = arg_193_0.holder

		if not arg_193_2 then
			local var_193_1 = arg_193_0.csvCfg.specialVal
			local var_193_2 = var_193_1 and arg_193_0:cfg2Value(var_193_1[1]) or 1
			local var_193_3 = var_193_1 and arg_193_0:cfg2Value(var_193_1[2]) or 1
			local var_193_4 = var_193_1 and var_193_1[3] or {}
			local var_193_5 = {}

			for iter_193_0, iter_193_1 in pairs(ObjectAttrs.AttrsTable) do
				local var_193_6 = var_193_0:getBaseAttr(iter_193_0)

				if var_193_4[iter_193_0] then
					var_193_6 = var_193_6 * (1 - var_193_4[iter_193_0])
				elseif ObjectAttrs.SixDimensionAttrs[iter_193_0] then
					var_193_6 = var_193_6 * (1 - var_193_2)
				else
					var_193_6 = var_193_6 * (1 - var_193_3)
				end

				if var_193_6 ~= 0 then
					var_193_0.attrs:addBuffAttr(iter_193_0, -var_193_6)

					var_193_5[iter_193_0] = var_193_6
				end
			end

			var_193_0:addOverlaySpecBuff(arg_193_0, function(arg_194_0)
				arg_194_0.attrsRecordTb = var_193_5
			end, nil)
		else
			var_193_0:deleteOverlaySpecBuff(arg_193_0, function(arg_195_0)
				for iter_195_0, iter_195_1 in pairs(arg_195_0.attrsRecordTb) do
					var_193_0.attrs:addBuffAttr(iter_195_0, iter_195_1)
				end
			end)
		end
	end,
	lethalProtect = function(arg_196_0, arg_196_1, arg_196_2)
		local var_196_0 = arg_196_0.holder
		local var_196_1 = var_196_0.scene.play

		local function var_196_2()
			return string.format("%sw%sr", var_196_1.curWave, var_196_1.totalRoundBattleTurn)
		end

		if not arg_196_2 then
			var_196_0:addOverlaySpecBuff(arg_196_0, function(arg_198_0)
				arg_198_0.transferTo = arg_196_0:getObjectsByCfg(arg_196_1[1])[1]
				arg_198_0.aoeTwice = arg_196_1[2] == 1
				arg_198_0.ignoreControl = arg_196_1[3] == 1

				function arg_198_0.checkCondition(arg_199_0)
					local var_199_0 = false

					if not arg_196_0.csvCfg.specialVal then
						var_199_0 = true
					elseif arg_199_0.transferTo then
						arg_196_0.protectedEnv = battleCsv.fillFuncEnv(arg_196_0.protectedEnv, {
							lethalProtector = arg_199_0.transferTo
						})
						var_199_0 = arg_196_0:cfg2Value(arg_196_0.csvCfg.specialVal[1])

						arg_196_0.protectedEnv:resetEnv()
					end

					return var_199_0
				end

				function arg_198_0.checkToObj(arg_200_0)
					local var_200_0 = arg_200_0.transferTo

					if not var_200_0 then
						return false
					end

					if var_200_0:isAlreadyDead() then
						return false
					end

					if var_200_0:isNotReSelect(true) then
						return false
					end

					if var_200_0:isSelfControled() and not arg_200_0.ignoreControl then
						return false
					end

					return true
				end
			end, nil)
			var_196_0:addOverlaySpecBuffFunc(battle.OverlaySpecBuff.lethalProtect, "tryProtect", function()
				local var_201_0, var_201_1 = var_196_0:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.lethalProtect, "getProtectObj")

				if var_201_0 then
					return var_201_0, var_201_1
				end

				if var_196_1.lethalDatas[var_196_0.id] then
					for iter_201_0, iter_201_1 in var_196_0:ipairsOverlaySpecBuffTo(battle.OverlaySpecBuff.lethalProtect) do
						if iter_201_1:checkToObj() and iter_201_1:checkCondition() then
							local var_201_2 = iter_201_1.transferTo
							local var_201_3 = {
								takeEffectRound = var_196_2(),
								toObj = var_201_2,
								aoeTwice = iter_201_1.aoeTwice
							}

							if iter_201_1.takeEffectData then
								iter_201_1.takeEffectData = var_201_3
							else
								iter_201_1:setG("takeEffectData", var_201_3)
							end

							var_196_0:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
								buffId = iter_201_1.id,
								easyEffectFunc = arg_196_0.csvCfg.easyEffectFunc,
								obj = var_201_2
							})

							return var_201_2, iter_201_1.aoeTwice
						end
					end
				end

				return nil
			end)
			var_196_0:addOverlaySpecBuffFunc(battle.OverlaySpecBuff.lethalProtect, "getProtectObj", function()
				local var_202_0 = var_196_0:getOverlaySpecBuffData(battle.OverlaySpecBuff.lethalProtect)

				if var_202_0 and var_202_0.takeEffectData and var_202_0.takeEffectData.takeEffectRound == var_196_2() then
					return var_202_0.takeEffectData.toObj, var_202_0.takeEffectData.aoeTwice
				end

				return nil
			end)
		else
			var_196_0:deleteOverlaySpecBuff(arg_196_0)
		end
	end,
	healTodamage = function(arg_203_0, arg_203_1, arg_203_2)
		local var_203_0 = arg_203_0.holder

		if not arg_203_2 then
			var_203_0:addOverlaySpecBuff(arg_203_0, function(arg_204_0)
				arg_204_0.formula = arg_203_1[1]
				arg_204_0.processId = arg_203_1[2] or 15

				function arg_204_0.calcDamage(arg_205_0)
					arg_203_0.protectedEnv = battleCsv.fillFuncEnv(arg_203_0.protectedEnv, {
						healthNum = arg_205_0
					})

					local var_205_0 = arg_203_0:cfg2Value(arg_204_0.formula)

					arg_203_0.protectedEnv:resetEnv()

					return var_205_0
				end
			end, nil)
			var_203_0:addOverlaySpecBuffFunc(battle.OverlaySpecBuff.healTodamage, "getDamage", function(arg_206_0)
				local var_206_0 = {}
				local var_206_1 = {}

				for iter_206_0, iter_206_1 in var_203_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.healTodamage) do
					local var_206_2 = iter_206_1.processId

					if not var_206_0[var_206_2] then
						var_206_0[var_206_2] = 0

						table.insert(var_206_1, var_206_2)
					end

					var_206_0[var_206_2] = var_206_0[var_206_2] + iter_206_1.calcDamage(arg_206_0)
				end

				local var_206_3 = {}

				for iter_206_2, iter_206_3 in ipairs(var_206_1) do
					table.insert(var_206_3, {
						processId = iter_206_3,
						damage = var_206_0[iter_206_3]
					})
				end

				return var_206_3
			end)
			var_203_0:addOverlaySpecBuffFunc(battle.OverlaySpecBuff.healTodamage, "doBuffDamage", function(arg_207_0, arg_207_1, arg_207_2, arg_207_3)
				local var_207_0 = arg_207_1:doOverlaySpecBuffFunc(battle.OverlaySpecBuff.healTodamage, "getDamage", arg_207_2)

				for iter_207_0, iter_207_1 in ipairs(var_207_0) do
					local var_207_1 = math.floor(iter_207_1.damage)
					local var_207_2 = {
						isBeginDamageSeg = true,
						isLastDamageSeg = true,
						from = battle.DamageFrom.buff,
						buffCfgId = arg_207_3,
						beAttackZOrder = arg_203_0.scene.beAttackZOrder,
						isProcessState = {
							isStart = iter_207_0 == 1,
							isEnd = iter_207_0 == table.length(var_207_0)
						}
					}

					arg_203_0:updateWithTrigger(battle.BuffTriggerPoint.onBuffTrigger, {
						buffId = arg_203_0.id,
						easyEffectFunc = arg_203_0.csvCfg.easyEffectFunc
					})

					local var_207_3, var_207_4 = arg_207_1:beAttack(arg_207_0, var_207_1, iter_207_1.processId, var_207_2)
				end
			end)
		else
			var_203_0:deleteOverlaySpecBuff(arg_203_0)
		end

		return true
	end,
	replaceSkill = function(arg_208_0, arg_208_1, arg_208_2)
		local var_208_0 = arg_208_0.holder

		if not arg_208_2 then
			var_208_0:replaceSkill(arg_208_1[1], arg_208_1[2], arg_208_0.id)
		else
			var_208_0:resumeSkill(arg_208_0.id)
		end
	end,
	breakCharging = function(arg_209_0, arg_209_1, arg_209_2)
		local var_209_0 = arg_209_0.holder

		if not arg_209_2 then
			var_209_0:addOverlaySpecBuff(arg_209_0, function(arg_210_0)
				arg_210_0.mode = arg_209_1[1]
			end)
		else
			var_209_0:deleteOverlaySpecBuff(arg_209_0)
		end
	end,
	changeObjNature = function(arg_211_0, arg_211_1, arg_211_2)
		local var_211_0 = arg_211_0.holder

		if not arg_211_2 then
			var_211_0:addOverlaySpecBuff(arg_211_0, function(arg_212_0)
				if not arg_212_0.typeList then
					arg_212_0:setG("typeList", CVector.new())
				end

				arg_212_0:setG("getType", function(arg_213_0, arg_213_1)
					arg_213_1 = arg_213_1 or 1

					local var_213_0 = arg_213_0.typeList and arg_213_0.typeList:front()

					return var_213_0 and var_213_0[arg_213_1]
				end)
				arg_212_0.typeList:push_front(arg_211_1)
			end)
		else
			var_211_0:deleteOverlaySpecBuff(arg_211_0, function(arg_214_0)
				arg_214_0.typeList:pop_front(arg_211_1)
			end)
		end
	end,
	changeSkillNature = function(arg_215_0, arg_215_1, arg_215_2)
		local var_215_0 = arg_215_0.holder

		if not arg_215_2 then
			var_215_0:addOverlaySpecBuff(arg_215_0, function(arg_216_0)
				if not arg_216_0.skillNatures then
					arg_216_0:setG("skillNatures", {})
				end

				arg_216_0.mode = arg_215_1[1]
				arg_216_0.args = arg_215_1[2] or {}

				function arg_216_0.refreshSkills(arg_217_0)
					arg_216_0.skillNatures = {}

					if arg_216_0.mode == 0 then
						local var_217_0 = table.length(arg_217_0) > 3

						for iter_217_0, iter_217_1 in ipairs(arg_217_0) do
							local var_217_1 = iter_217_0

							if var_217_0 and iter_217_0 == 3 then
								var_217_1 = 4
							end

							if var_217_0 and iter_217_0 == 4 then
								var_217_1 = 3
							end

							local var_217_2 = arg_216_0.args[var_217_1]

							if var_217_2 and var_217_2 > 0 then
								arg_216_0.skillNatures[iter_217_1] = var_217_2
							end
						end
					elseif arg_216_0.mode == 1 then
						for iter_217_2, iter_217_3 in ipairs(arg_217_0) do
							local var_217_3 = csv.skill[iter_217_3]
							local var_217_4 = var_217_3 and var_217_3.skillNatureType
							local var_217_5 = game.NATURE_TABLE[var_217_4]
							local var_217_6 = arg_216_0.args[var_217_5]

							if var_217_6 and var_217_6 > 0 then
								arg_216_0.skillNatures[iter_217_3] = var_217_6
							end
						end
					end
				end

				arg_216_0:setG("refreshAll", function()
					for iter_218_0, iter_218_1 in var_215_0:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.changeSkillNature) do
						iter_218_1.refreshSkills(var_215_0.skillsOrder)

						break
					end
				end)
			end)
			var_215_0:getOverlaySpecBuffData(battle.OverlaySpecBuff.changeSkillNature).refreshAll()
		else
			var_215_0:deleteOverlaySpecBuff(arg_215_0, function(arg_219_0)
				arg_219_0.skillNatures = {}
			end)
		end
	end,
	possess = function(arg_220_0, arg_220_1, arg_220_2)
		local var_220_0 = arg_220_0.holder

		if not arg_220_2 then
			local var_220_1 = arg_220_0.csvCfg.specialTarget and arg_220_0.csvCfg.specialTarget[1]
			local var_220_2 = var_220_1 and arg_220_0:getObjectsByCfg(var_220_1)[1]
			local var_220_3 = arg_220_0.csvCfg.specialVal and arg_220_0.csvCfg.specialVal[1] or {}

			if not var_220_2 then
				return
			end

			local var_220_4 = {
				casterKey = tostring(var_220_0),
				targetKey = tostring(var_220_2),
				targetSeat = var_220_2.seat,
				offsetPos = cc.p(var_220_3.x, var_220_3.y),
				res = var_220_3.res,
				type = battle.SpriteType.Possess
			}

			var_220_0:addExRecord(battle.ExRecordEvent.possessTarget, var_220_2)
			var_220_0.scene:addObjViewToBattleTurn(nil, "SceneAddObj", "possess" .. tostring(var_220_0), readOnlyProxy(var_220_0), var_220_4)
		else
			var_220_0:cleanEventByKey(battle.ExRecordEvent.possessTarget)
			var_220_0.scene:addObjViewToBattleTurn(nil, "SceneDelObj", "possess" .. tostring(var_220_0))
		end
	end,
	prophet = function(arg_221_0, arg_221_1, arg_221_2)
		local var_221_0 = arg_221_0.holder

		if not arg_221_2 then
			var_221_0:addOverlaySpecBuff(arg_221_0, function(arg_222_0)
				function arg_222_0.getProb(arg_223_0, arg_223_1)
					arg_221_0.protectedEnv = battleCsv.fillFuncEnv(arg_221_0.protectedEnv, {
						attacker = arg_223_1
					})

					local var_223_0 = arg_221_0:cfg2Value(arg_221_0.args.buffValueFormula[1])

					arg_221_0.protectedEnv:resetEnv()

					return var_223_0
				end

				arg_222_0.triggerId = arg_221_1[2]
				arg_222_0.triggerSkillType2 = arg_221_1[3]
				arg_222_0.triggerSkillType = type(arg_221_1[3])
				arg_222_0.costType = arg_221_1[4] or 0
				arg_222_0.mustEnemy = arg_221_1[5] == 1
			end, nil)
		else
			var_221_0:deleteOverlaySpecBuff(arg_221_0)
		end

		return true
	end
}
