local var_0_0 = battle.ValueType
local var_0_1 = {
	fillEnv = 1,
	calcProb = 2,
	result = 3
}

battleEasy.IDCounter = 0

local function var_0_2(arg_1_0)
	return (table.deepcopy(arg_1_0, true))
end

function battleEasy.runDamageProcess(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	battleEasy.IDCounter = battleEasy.IDCounter + 1

	local var_2_0 = csv.damage_process[arg_2_3]
	local var_2_1

	if arg_2_4 and arg_2_4.exProcessId then
		var_2_1 = csv.damage_process[arg_2_4.exProcessId]
	end

	local var_2_2 = var_2_0.preBehaviour or {}

	if not arg_2_1 or not arg_2_2 then
		errorInWindows("attacker(%d) or target(%d) is nil", arg_2_1 and arg_2_1.seat or -1, arg_2_2 and arg_2_2.seat or -1)

		return 0, {}
	elseif not var_2_0 then
		errorInWindows("%d to %d damage Process %d is nil", arg_2_1.seat, arg_2_2.seat, arg_2_3)

		return 0, {}
	end

	local var_2_3, var_2_4, var_2_5 = battleEasy.alterDmgRecordVals(arg_2_1, arg_2_2)
	local var_2_6 = battleEasy.makeDamageEnv(arg_2_0, arg_2_3, arg_2_4)

	var_2_6.args.damageId = battleEasy.IDCounter
	var_2_6.preBehaviour = var_2_2.init

	battleEasy.fillDamageEnv(arg_2_1, arg_2_2, var_2_6, {
		damageType = var_2_6.args.damageType
	}, true)

	local var_2_7 = true
	local var_2_8

	for iter_2_0, iter_2_1 in ipairs(battle.DamageProcess) do
		local var_2_9 = var_2_4[iter_2_1] and var_2_4[iter_2_1][1].data or var_2_0[iter_2_1]

		if var_2_9 and var_2_9 ~= "jump" and (not var_2_1 or var_2_1[iter_2_1] == var_2_9) then
			if var_2_9 == "out" or not var_2_7 then
				break
			end

			var_2_6.preBehaviour = nil

			if var_2_2 and var_2_2[iter_2_1] then
				var_2_6.preBehaviour = var_2_2[iter_2_1]
			end

			var_2_6.buffBehaviourTb = var_2_3[iter_2_1] or {}
			var_2_6.buffExtraArgs = var_2_5[iter_2_1] and var_2_5[iter_2_1][1] or {}

			if battleEasy[iter_2_1 .. "Funcs"] then
				local var_2_10 = battleEasy[iter_2_1 .. "Funcs"]

				var_2_10[var_0_1.fillEnv](var_2_6, arg_2_1, arg_2_2, var_2_9)

				if not var_2_6.args.hasCalcDamageProb then
					var_2_10[var_0_1.calcProb](var_2_6, arg_2_1, arg_2_2, var_2_9)
				end

				var_2_7 = var_2_10[var_0_1.result](var_2_6, arg_2_1, arg_2_2, var_2_9)
			else
				var_2_7 = battleEasy[iter_2_1 .. "Process"](var_2_6, arg_2_1, arg_2_2, var_2_9, true)
			end

			logf.battle.damage.process("attacker:%d, target:%d, skillId:%d, buffCfgId:%d process name:%s,damage:%s", arg_2_1.seat, arg_2_2.seat, arg_2_4.skillId or -1, arg_2_4.buffCfgId or -1, iter_2_1, var_2_6.valueF)

			if type(var_2_6.valueF) == "number" and var_2_6.valueF < 0 then
				var_2_6.valueF = 0
			end
		end
	end

	battleEasy.calcInternalDamageFinishProcess(var_2_6)

	return var_2_6.valueF, var_2_6.args
end

function battleEasy.makeDamageEnv(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {
		args = arg_3_2 or {},
		valueF = arg_3_0,
		valueBase = arg_3_0,
		id = arg_3_1,
		showTargetHeadNumber = function(arg_4_0, arg_4_1, arg_4_2)
			local var_4_0 = {
				miss = arg_4_0.args.skillMiss or arg_4_0.args.miss,
				segId = arg_4_0.args.segId
			}
			local var_4_1 = {
				strike = arg_4_0.args.strike,
				miss = var_4_0.miss,
				block = arg_4_0.args.block,
				natureFlag = arg_4_0.args.natureFlag,
				nature = arg_4_0.args.nature or 1,
				from = arg_4_0.args.from,
				segId = arg_4_0.args.segId,
				isLastSeg = arg_4_0.args.isLastDamageSeg
			}

			arg_4_2 = arg_4_2 or arg_4_0.valueF + (arg_4_0.args.extraValueF or 0)

			battleEasy.deferNotifyCantJump(arg_4_1.view, "showHeadText", {
				args = var_4_0
			})

			if not arg_4_0.args.hideHeadNumber then
				battleEasy.deferNotify(arg_4_1.view, "showHeadNumber", {
					typ = 0,
					num = arg_4_2,
					args = var_4_1
				})
			end
		end,
		damageFromExtraExit = function(arg_5_0, arg_5_1)
			arg_5_0.args.fromExtra = arg_5_0.args.fromExtra or {}

			if not arg_5_1 then
				return next(arg_5_0.args.fromExtra)
			end

			if arg_5_0.args.fromExtra[arg_5_1] == nil then
				arg_5_0.args.fromExtra[arg_5_1] = false
			end

			return arg_5_0.args.fromExtra[arg_5_1]
		end,
		fillEnv = function(arg_6_0, arg_6_1)
			arg_6_0.__index = arg_6_1

			return arg_6_0
		end,
		resetEnv = function(arg_7_0)
			arg_7_0.__index = nil

			return arg_7_0
		end
	}

	return setmetatable(var_3_0, var_3_0)
end

function battleEasy.fillDamageEnv(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_2:resetEnv()

	local var_8_0 = {}

	if arg_8_3 then
		var_8_0 = battleCsv.makeDamageProcessEnv(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	end

	if arg_8_2.preBehaviour then
		battleCsv.doFormula(arg_8_2.preBehaviour, var_8_0)
	end

	if arg_8_2.buffBehaviourTb and next(arg_8_2.buffBehaviourTb) then
		for iter_8_0, iter_8_1 in ipairs(arg_8_2.buffBehaviourTb) do
			battleCsv.doFormula(iter_8_1.data, var_8_0)
		end
	end

	if arg_8_4 and arg_8_3 then
		for iter_8_2, iter_8_3 in pairs(arg_8_3) do
			arg_8_2[iter_8_2] = var_8_0[iter_8_2] or iter_8_3
		end
	end

	return arg_8_2:fillEnv(var_8_0)
end

local function var_0_3(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if string.match(arg_9_2, arg_9_0) then
		return string.gsub(arg_9_2, arg_9_0, string.format("%s,%s", arg_9_3, arg_9_0))
	end

	return string.format(arg_9_2, string.gsub(arg_9_1, arg_9_4 .. "%d+%(%w+", function(arg_10_0)
		return string.format("%s,%s,%s", string.gsub(arg_10_0, arg_9_0, arg_9_4), arg_9_3, arg_9_0)
	end))
end

local var_0_4 = {
	multiply = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		arg_11_3 = arg_11_3 ~= "nil" and arg_11_3 or 1

		return string.format("%s*%s", arg_11_2, arg_11_3)
	end,
	["mutex%d+"] = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		return var_0_3(arg_12_0, arg_12_1, arg_12_2, arg_12_3, "mutex")
	end,
	["sum%d+"] = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		return var_0_3(arg_13_0, arg_13_1, arg_13_2, arg_13_3, "sum")
	end
}

function battleEasy.updDamageFormula(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = string.split(arg_14_0, "|")

	arg_14_2 = arg_14_2 or "nil"

	if table.length(var_14_0) > 1 then
		for iter_14_0, iter_14_1 in ipairs(var_14_0) do
			local var_14_1 = table.length(var_14_0) == iter_14_0

			battleEasy.updDamageFormula(iter_14_1, arg_14_1, var_14_1 and arg_14_2 or "%s")
		end

		return
	end

	if tonumber(arg_14_0) then
		arg_14_1.valueF = string.format(arg_14_1.valueF, arg_14_0)

		return
	end

	local var_14_2

	for iter_14_2, iter_14_3 in pairs(var_0_4) do
		local var_14_3 = string.match(arg_14_0, iter_14_2)

		if var_14_3 then
			arg_14_1.valueF = iter_14_3(var_14_3, arg_14_0, arg_14_1.valueF, arg_14_2)

			break
		end
	end
end

battleEasy.damageHitFuncs = {
	[var_0_1.fillEnv] = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		battleEasy.fillDamageEnv(arg_15_1, arg_15_2, arg_15_0, {
			damageHit = arg_15_1:damageHit(),
			damageDodge = arg_15_2:damageDodge()
		})
	end,
	[var_0_1.calcProb] = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		if arg_16_0:damageHit() - arg_16_0:damageDodge() < ymrand.random() then
			arg_16_0.args.miss = true
		end
	end,
	[var_0_1.result] = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		if arg_17_0.args.miss then
			arg_17_0.valueF = 0

			return false
		else
			return true
		end
	end
}
battleEasy.natureFuncs = {
	[var_0_1.fillEnv] = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		battleEasy.fillDamageEnv(arg_18_1, arg_18_2, arg_18_0, {
			natureRestraint = arg_18_1:natureRestraint(),
			natureResistance = arg_18_2:natureResistance()
		})
	end,
	[var_0_1.calcProb] = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		local var_19_0 = 1
		local var_19_1

		if arg_19_0.args.skillId then
			local var_19_2 = arg_19_1.skills[arg_19_0.args.skillId] or arg_19_1.passiveSkills[arg_19_0.args.skillId]
			local var_19_3 = var_19_2 and var_19_2:getSkillNatureType()

			var_19_1, var_19_0 = skillHelper.natureRestraintType(var_19_3, arg_19_2, arg_19_0:natureRestraint(), arg_19_0:natureResistance())
		elseif arg_19_0.args.natureType then
			local var_19_4 = 1

			for iter_19_0 = 1, 2 do
				if arg_19_2:getNatureType(iter_19_0) then
					local var_19_5 = game.NATURE_TABLE[arg_19_2:getNatureType(iter_19_0)]

					var_19_4 = skillHelper.getNatureMatrix(arg_19_0.args.natureType, var_19_5, arg_19_0:natureRestraint(), arg_19_0:natureResistance()) * var_19_4
				end
			end

			local var_19_6 = game.NATURE_TABLE[arg_19_0.args.natureType]

			var_19_1, var_19_0 = skillHelper.getNatureFlag(var_19_4)
		end

		arg_19_0.args.nature = var_19_0
		arg_19_0.args.natureFlag = var_19_1
	end,
	[var_0_1.result] = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		battleEasy.updDamageFormula(arg_20_3, arg_20_0, arg_20_0.args.nature)

		return true
	end
}

function battleEasy.damageAddProcess(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if arg_21_4 then
		battleEasy.fillDamageEnv(arg_21_1, arg_21_2, arg_21_0, {
			damageAdd = arg_21_1:damageAdd(),
			damageSub = arg_21_2:damageSub(),
			ignoreDamageSub = arg_21_1:ignoreDamageSub()
		})

		return battleEasy.damageAddProcess(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	end

	local var_21_0 = arg_21_0:damageAdd() - math.max(arg_21_0:damageSub() - arg_21_0:ignoreDamageSub(), 0)

	battleEasy.updDamageFormula(arg_21_3, arg_21_0, var_21_0)

	return true
end

function battleEasy.damageDeepenProcess(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if arg_22_4 then
		battleEasy.fillDamageEnv(arg_22_1, arg_22_2, arg_22_0, {
			damageDeepen = arg_22_2:damageDeepen(),
			damageReduce = arg_22_1:damageReduce()
		})

		return battleEasy.damageDeepenProcess(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	end

	local var_22_0 = arg_22_0:damageDeepen() - arg_22_0:damageReduce()

	battleEasy.updDamageFormula(arg_22_3, arg_22_0, var_22_0)

	return true
end

function battleEasy.dmgDeltaProcess(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	if arg_23_4 then
		battleEasy.fillDamageEnv(arg_23_1, arg_23_2, arg_23_0, {
			physicalDamageAdd = arg_23_1:physicalDamageAdd(),
			specialDamageAdd = arg_23_1:specialDamageAdd(),
			trueDamageAdd = arg_23_1:trueDamageAdd(),
			physicalDamageSub = arg_23_2:physicalDamageSub(),
			specialDamageSub = arg_23_2:specialDamageSub(),
			trueDamageSub = arg_23_2:trueDamageSub()
		})

		return battleEasy.dmgDeltaProcess(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	end

	if not arg_23_0.damageType then
		return true
	end

	local var_23_0

	if arg_23_0.damageType == battle.SkillDamageType.Physical then
		var_23_0 = arg_23_0:physicalDamageAdd() - arg_23_0:physicalDamageSub()
	elseif arg_23_0.damageType == battle.SkillDamageType.True then
		var_23_0 = arg_23_0:trueDamageAdd() - arg_23_0:trueDamageSub()
	else
		var_23_0 = arg_23_0:specialDamageAdd() - arg_23_0:specialDamageSub()
	end

	battleEasy.updDamageFormula(arg_23_3, arg_23_0, var_23_0)

	return true
end

function battleEasy.natureDeltaProcess(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	if not arg_24_0.args.natureType then
		return true
	end

	local var_24_0 = game.NATURE_TABLE[arg_24_0.args.natureType]
	local var_24_1 = var_24_0 .. "DamageAdd"
	local var_24_2 = var_24_0 .. "DamageSub"

	if arg_24_4 then
		battleEasy.fillDamageEnv(arg_24_1, arg_24_2, arg_24_0, {
			natureDeltaAdd = arg_24_1[var_24_1](arg_24_1),
			natureDeltaSub = arg_24_2[var_24_2](arg_24_2)
		})

		return battleEasy.natureDeltaProcess(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	end

	local var_24_3 = arg_24_0.natureDeltaAdd - arg_24_0.natureDeltaSub

	battleEasy.updDamageFormula(arg_24_3, arg_24_0, var_24_3)

	return true
end

function battleEasy.gateDeltaProcess(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	if arg_25_4 then
		battleEasy.fillDamageEnv(arg_25_1, arg_25_2, arg_25_0, {
			pvpDamageAdd = arg_25_1:pvpDamageAdd(),
			pvpDamageSub = arg_25_2:pvpDamageSub()
		})

		return battleEasy.gateDeltaProcess(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	end

	local var_25_0 = arg_25_0:pvpDamageAdd() - arg_25_0:pvpDamageSub()

	battleEasy.updDamageFormula(arg_25_3, arg_25_0, var_25_0)

	return true
end

function battleEasy.reduceProcess(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	if arg_26_0.damageType == battle.SkillDamageType.True then
		return true
	end

	if arg_26_4 then
		battleEasy.fillDamageEnv(arg_26_1, arg_26_2, arg_26_0, {
			defence = arg_26_2:defence(),
			specialDefence = arg_26_2:specialDefence(),
			defenceIgnore = arg_26_1:defenceIgnore(),
			specialDefenceIgnore = arg_26_1:specialDefenceIgnore(),
			damage = arg_26_1:damage(),
			specialDamage = arg_26_1:specialDamage()
		})

		return battleEasy.reduceProcess(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	end

	local var_26_0

	if arg_26_0.damageType == battle.SkillDamageType.Physical then
		var_26_0 = arg_26_0:defence()
	else
		var_26_0 = arg_26_0:specialDefence()
	end

	if arg_26_2.calDmgKeepDefenceBuff then
		var_26_0 = arg_26_2.calDmgKeepDefenceBuff(arg_26_0:defence(), arg_26_0:specialDefence())
	end

	local var_26_1

	if arg_26_0.damageType == battle.SkillDamageType.Physical then
		var_26_1 = var_26_0 * math.max(1 - arg_26_0:defenceIgnore(), ConstSaltNumbers.dot05)
	else
		var_26_1 = var_26_0 * math.max(1 - arg_26_0:specialDefenceIgnore(), ConstSaltNumbers.dot05)
	end

	local var_26_2 = math.max(var_26_1, 0)
	local var_26_3

	if arg_26_0.damageType == battle.SkillDamageType.Physical then
		var_26_3 = arg_26_0:damage()
	else
		var_26_3 = arg_26_0:specialDamage()
	end

	local var_26_4 = 1 - var_26_2 / math.max(var_26_3, 0.0001)
	local var_26_5 = math.max(var_26_4, ConstSaltNumbers.dot1)

	battleEasy.updDamageFormula(arg_26_3, arg_26_0, var_26_5)

	return true
end

battleEasy.strikeBlockFuncs = {
	[var_0_1.fillEnv] = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		battleEasy.fillDamageEnv(arg_27_1, arg_27_2, arg_27_0, {
			strikeResistance = arg_27_2:strikeResistance(),
			ignoreStrikeResistance = arg_27_1:ignoreStrikeResistance(),
			strike = arg_27_1:strike(),
			strikeDamage = arg_27_1:strikeDamage(),
			strikeDamageSub = arg_27_2:strikeDamageSub(),
			strikePowerRate = ConstSaltNumbers.one15,
			block = arg_27_2:block(),
			breakBlock = arg_27_1:breakBlock(),
			blockPower = arg_27_2:blockPower(),
			blockPowerRate = ConstSaltNumbers.one,
			rate = ConstSaltNumbers.dot96
		})
	end,
	[var_0_1.calcProb] = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		local var_28_0 = math.max(arg_28_0:strike() - math.max(arg_28_0:strikeResistance() - arg_28_0:ignoreStrikeResistance(), 0), 0)
		local var_28_1 = math.max(arg_28_0:block() - arg_28_0:breakBlock(), 0)
		local var_28_2 = var_28_1
		local var_28_3 = var_28_0

		if var_28_2 + var_28_3 > arg_28_0.rate then
			var_28_2 = var_28_1 / (var_28_0 + var_28_1) * arg_28_0.rate
			var_28_3 = var_28_0 / (var_28_0 + var_28_1) * arg_28_0.rate
		end

		local var_28_4 = var_28_2 * arg_28_0.blockPowerRate
		local var_28_5 = var_28_3 * arg_28_0.strikePowerRate
		local var_28_6 = ymrand.random() * math.max(1, var_28_5 + var_28_4)

		if var_28_6 < var_28_5 then
			arg_28_0.args.strike = true
		elseif var_28_6 < var_28_5 + var_28_4 then
			arg_28_0.args.block = true
		end
	end,
	[var_0_1.result] = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		local var_29_0 = ConstSaltNumbers.one

		if arg_29_0.args.strike then
			var_29_0 = math.max(arg_29_0:strikeDamage() - arg_29_0:strikeDamageSub(), ConstSaltNumbers.dot01)
		elseif arg_29_0.args.block then
			var_29_0 = math.max(ConstSaltNumbers.one - arg_29_0:blockPower(), ConstSaltNumbers.dot01)
		end

		battleEasy.updDamageFormula(arg_29_3, arg_29_0, var_29_0)

		return true
	end
}

function battleEasy.extraAddProcess(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = 0

	battleEasy.updDamageFormula(arg_30_3, arg_30_0, var_30_0)

	return true
end

function battleEasy.fatalProcess(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if arg_31_1.fatalBuff and arg_31_2:hp() / arg_31_2:hpMax() > arg_31_1.fatalBuff.limit then
		battleEasy.updDamageFormula(arg_31_3, arg_31_0, arg_31_1.fatalBuff.val)
	end

	return true
end

function battleEasy.beheadProcess(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_1.beheadBuff and arg_32_2:hp() / arg_32_2:hpMax() < arg_32_1.beheadBuff.limit then
		battleEasy.updDamageFormula(arg_32_3, arg_32_0, arg_32_1.beheadBuff.val)
	end

	return true
end

function battleEasy.damageByHpRateProcess(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	if arg_33_1.damageByHpRateBuff then
		battleEasy.updDamageFormula(arg_33_3, arg_33_0, arg_33_1.damageByHpRateBuff:rateFunc(arg_33_1, 1) + arg_33_1.damageByHpRateBuff:rateFunc(arg_33_2, 2))
	end

	return true
end

function battleEasy.finalSkillAddProcess(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	battleEasy.updDamageFormula(arg_34_3, arg_34_0, arg_34_1:finalSkillAddRate())

	return true
end

function battleEasy.ultimateAddProcess(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if not arg_35_0.args.skillType2 then
		return true
	end

	if arg_35_0.args.skillType2 == battle.MainSkillType.BigSkill or arg_35_0.args.skillType == battle.SkillType.PassiveCombine then
		local var_35_0 = 1 + arg_35_1:ultimateAdd() - arg_35_2:ultimateSub()
		local var_35_1 = math.max(var_35_0, ConstSaltNumbers.dot05)

		battleEasy.updDamageFormula(arg_35_3, arg_35_0, var_35_1)
	end

	return true
end

function battleEasy.skillPowerProcess(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	if arg_36_0.args.skillPower then
		local var_36_0 = arg_36_0.args.skillPower / ConstSaltNumbers.wan
		local var_36_1 = math.max(var_36_0, ConstSaltNumbers.dot05)

		battleEasy.updDamageFormula(arg_36_3, arg_36_0, var_36_1)
	end

	return true
end

function battleEasy.buffAddProcess(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	if arg_37_4 then
		battleEasy.fillDamageEnv(arg_37_1, arg_37_2, arg_37_0, {
			damageRateAdd = arg_37_1:damageRateAdd()
		})

		return battleEasy.buffAddProcess(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	end

	battleEasy.updDamageFormula(arg_37_3, arg_37_0, 1 + arg_37_0:damageRateAdd())

	return true
end

function battleEasy.randFixProcess(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_2.scene.closeRandFix and 1 or ymrand.random(9000, ConstSaltNumbers.wan) / ConstSaltNumbers.wan

	battleEasy.updDamageFormula(arg_38_3, arg_38_0, var_38_0)

	return true
end

function battleEasy.limitProcess(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = battleEasy.runDamageProcess(arg_39_0.valueBase, arg_39_1, arg_39_2, arg_39_3, arg_39_0.args)

	arg_39_0.valueF = string.format("max(%s,%s)", arg_39_0.valueF, var_39_0)

	return true
end

function battleEasy.calcInternalDamageFinishProcess(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = tonumber(arg_40_0.valueF) or battleCsv.doFormula(arg_40_0.valueF, {
		min = math.min,
		max = math.max,
		sum = function(arg_41_0, ...)
			local var_41_0 = {
				...
			}
			local var_41_1 = arg_41_0

			for iter_41_0, iter_41_1 in ipairs(var_41_0) do
				var_41_1 = var_41_1 + (iter_41_1 and type(iter_41_1) == "number" and iter_41_1 or 0)
			end

			return var_41_1
		end,
		mutex = function(arg_42_0, ...)
			local var_42_0 = {
				...
			}

			for iter_42_0, iter_42_1 in ipairs(var_42_0) do
				if iter_42_1 and type(iter_42_1) == "number" then
					return iter_42_1
				end
			end

			return arg_42_0
		end
	})

	arg_40_0.valueF = math.floor(var_40_0)

	if arg_40_4 then
		battleEasy.fillDamageEnv(arg_40_1, arg_40_2, arg_40_0, {
			calFinalDamage = var_40_0
		})

		arg_40_0.valueF = arg_40_0.calFinalDamage

		return true
	end

	return true
end

function battleEasy.ignoreRoundDamageProcess(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if arg_43_2.ignoreDamageInBattleRound then
		arg_43_0.valueF = 0

		arg_43_0:showTargetHeadNumber(arg_43_2)

		return false
	end

	return true
end

function battleEasy.leaveProcess(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if arg_44_2:checkOverlaySpecBuffExit("leave") then
		arg_44_0:showTargetHeadNumber(arg_44_2)

		if arg_44_0.args.from ~= battle.DamageFrom.buff then
			arg_44_0.valueF = 0
		end

		return false
	end

	return true
end

function battleEasy.immuneDamageProcess(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	for iter_45_0, iter_45_1 in arg_45_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.immuneDamage) do
		for iter_45_2, iter_45_3 in iter_45_1:powerTimeOrderPairs() do
			local var_45_0, var_45_1 = iter_45_1.funcMap[iter_45_2](iter_45_1, arg_45_0, arg_45_1)

			if var_45_0 then
				arg_45_0.valueF = 0

				local var_45_2 = arg_45_2:getBuff(iter_45_1.cfgId)

				arg_45_2:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
					buffId = var_45_2.id,
					easyEffectFunc = var_45_2.csvCfg.easyEffectFunc,
					triggerTime = iter_45_1.damageMap.count
				})

				if iter_45_1.allTime == 0 then
					var_45_2:over()
				end

				arg_45_0.args.immune = var_45_0

				if var_45_1 then
					arg_45_0:showTargetHeadNumber(arg_45_2)
				end

				return false
			end
		end
	end

	return true
end

function battleEasy.immuneAllDamageProcess(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	if arg_46_2.beInImmuneAllDamageState and arg_46_2.beInImmuneAllDamageState > 0 then
		arg_46_0.valueF = 0
		arg_46_0.args.immune = "all"

		arg_46_0:showTargetHeadNumber(arg_46_2)

		return false
	end

	return true
end

function battleEasy.immunePhysicalDamageProcess(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	if arg_47_0.damageType == battle.SkillDamageType.Physical and arg_47_2.beInImmunePhysicalDamageState and arg_47_2.beInImmunePhysicalDamageState > 0 then
		arg_47_0.valueF = 0
		arg_47_0.args.immune = "physical"

		arg_47_0:showTargetHeadNumber(arg_47_2)

		return false
	end

	return true
end

function battleEasy.immuneSpecialDamageProcess(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if arg_48_0.damageType == battle.SkillDamageType.Special and arg_48_2.beInImmuneSpecialDamageState and arg_48_2.beInImmuneSpecialDamageState > 0 then
		arg_48_0.valueF = 0
		arg_48_0.args.immune = "special"

		arg_48_0:showTargetHeadNumber(arg_48_2)

		return false
	end

	return true
end

function battleEasy.keepHpUnChangedProcess(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	if arg_49_2:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.keepHp) then
		local var_49_0 = arg_49_2.scene:excuteGroupObjFunc(arg_49_2.force, battle.SpecialObjectId.teamShiled, "getShieldHp") or 0
		local var_49_1 = arg_49_2:shieldHp()
		local var_49_2 = arg_49_2:hp() + var_49_1 + var_49_0
		local var_49_3 = arg_49_0.valueF

		var_49_3 = arg_49_0.args.from == battle.DamageFrom.skill and arg_49_1.curSkill and not arg_49_0:damageFromExtraExit() and arg_49_0.args.leftDamage or var_49_3

		if var_49_2 < var_49_3 then
			local var_49_4

			for iter_49_0, iter_49_1 in arg_49_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.keepHp) do
				if ymrand.random() <= iter_49_1.prob then
					var_49_4 = iter_49_0

					break
				end
			end

			if var_49_4 then
				local var_49_5 = arg_49_2:getOverlaySpecBuffByIdx(battle.OverlaySpecBuff.keepHp, var_49_4)

				arg_49_0.valueF = 0
				var_49_5.triggerTime = var_49_5.triggerTime - 1
				arg_49_2.ignoreDamageInBattleRound = true

				local var_49_6 = arg_49_2:getBuff(var_49_5.cfgId)

				arg_49_0:showTargetHeadNumber(arg_49_2)
				var_49_6:playTriggerPointEffect()

				local var_49_7 = var_49_6:getEventByKey(battle.ExRecordEvent.keepHpUnChangedTriggerState)

				arg_49_2:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
					checkEffectFunc = "lockHpAndKeepHpUnChanged",
					buffId = var_49_6.id,
					buffCfgId = var_49_6.cfgId,
					easyEffectFunc = var_49_6.csvCfg.easyEffectFunc,
					isFirstTrigger = not var_49_7
				})
				var_49_6:addExRecord(battle.ExRecordEvent.keepHpUnChangedTriggerState, true)

				if var_49_5.triggerTime <= 0 then
					var_49_6:over()
				end

				return false
			end
		end
	end

	return true
end

function battleEasy.damageAllocateProcess(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = arg_50_0:damageFromExtraExit(battle.DamageFromExtra.allocate)

	for iter_50_0, iter_50_1 in arg_50_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.allocate, function(arg_51_0)
		return var_50_0 and (not arg_50_0.args.allocatePriority or arg_51_0.priority >= arg_50_0.args.allocatePriority)
	end) do
		local var_50_1 = iter_50_1.rate
		local var_50_2 = iter_50_1.cfgId
		local var_50_3 = arg_50_2:getBuff(var_50_2).csvCfg
		local var_50_4 = iter_50_1.targetIds

		if var_50_3.specialVal and var_50_3.specialVal[3] == 1 then
			local var_50_5 = arg_50_0.args.skillDamageId or arg_50_0.args.damageId

			if not iter_50_1.targetIdsList[var_50_5] then
				iter_50_1.targetIdsList[var_50_5] = iter_50_1.getNewTargetIds()
			end

			var_50_4 = iter_50_1.targetIdsList[var_50_5]

			if arg_50_0.args.isLastDamageSeg then
				iter_50_1.targetIdsList[var_50_5] = nil
			end
		end

		local var_50_6 = {}

		for iter_50_2, iter_50_3 in ipairs(var_50_4) do
			if iter_50_3 ~= arg_50_2.id then
				local var_50_7 = arg_50_2.scene:getObject(iter_50_3)

				if var_50_7 and not var_50_7:isDeath() and not battleEasy.isCompleteLeave(var_50_7) then
					table.insert(var_50_6, var_50_7)
				end
			end
		end

		local var_50_8 = iter_50_1.damageMode

		if table.length(var_50_6) > 0 then
			local function var_50_9(arg_52_0)
				arg_52_0.fromExtra[battle.DamageFromExtra.allocate] = true
				arg_52_0.allocatePriority = iter_50_1.priority
			end

			if var_50_1 == -1 then
				arg_50_0.valueF = math.floor(arg_50_0.valueF / (table.length(var_50_6) + 1))

				local var_50_10 = arg_50_0.valueF

				if var_50_10 > arg_50_2:hp() and var_50_3.specialVal and var_50_3.specialVal[1] > 0 then
					var_50_10 = arg_50_2:hp()
				end

				for iter_50_4, iter_50_5 in ipairs(var_50_6) do
					local var_50_11 = var_0_2(arg_50_0.args)

					var_50_9(var_50_11)
					arg_50_2.scene:deferBeAttack(arg_50_2.id, arg_50_1, iter_50_5, var_50_10, var_50_8, var_50_11, var_50_3.specialVal and var_50_3.specialVal[2])
				end
			else
				local var_50_12 = arg_50_0.valueF * var_50_1

				arg_50_0.valueF = math.floor(arg_50_0.valueF * (1 - var_50_1))

				if arg_50_0.valueF > arg_50_2:hp() and var_50_3.specialVal and var_50_3.specialVal[1] > 0 then
					var_50_12 = var_50_12 * (arg_50_2:hp() / arg_50_0.valueF)
				end

				local var_50_13 = math.floor(var_50_12 / table.length(var_50_6))

				for iter_50_6, iter_50_7 in ipairs(var_50_6) do
					local var_50_14 = var_0_2(arg_50_0.args)

					var_50_9(var_50_14)
					arg_50_2.scene:deferBeAttack(arg_50_2.id, arg_50_1, iter_50_7, var_50_13, var_50_8, var_50_14, var_50_3.specialVal and var_50_3.specialVal[2])
				end
			end
		end
	end

	return true
end

function battleEasy.damageLinkProcess(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	if arg_53_2.damageLinkBuff and not arg_53_0:damageFromExtraExit(battle.DamageFromExtra.link) then
		local var_53_0 = arg_53_2.scene.buffGlobalManager

		for iter_53_0, iter_53_1 in ipairs(arg_53_2.damageLinkBuff) do
			local var_53_1 = var_53_0:getDamageLinkObjs(arg_53_2.id, iter_53_1)

			for iter_53_2, iter_53_3 in ipairs(var_53_1) do
				local var_53_2 = arg_53_2.scene:getObject(iter_53_3)

				if var_53_2 and not var_53_2:isDeath() and not var_53_2:isLogicStateExit(battle.ObjectLogicState.cantBeAttack, {
					fromObj = arg_53_1
				}) then
					local var_53_3 = var_53_0:getDamageLinkValue(iter_53_3, iter_53_1)
					local var_53_4 = arg_53_2:getBuff(iter_53_1)
					local var_53_5 = var_53_4.csvCfg
					local var_53_6 = arg_53_0.valueF

					if var_53_6 > arg_53_2:hp() and var_53_5.specialVal and var_53_5.specialVal[1] > 0 then
						var_53_6 = math.max(arg_53_2:hp(), 0)
					end

					local var_53_7 = math.floor(var_53_6 * var_53_3)
					local var_53_8 = var_0_2(arg_53_0.args)

					var_53_8.fromExtra[battle.DamageFromExtra.link] = true

					local var_53_9 = arg_53_1

					if var_53_5.specialVal and var_53_5.specialVal[2] == 1 then
						var_53_9 = (var_53_4.caster and not var_53_4.caster:isDeath() or nil) and var_53_4.caster
					end

					if var_53_9 then
						arg_53_2.scene:deferBeAttack(arg_53_2.id, var_53_9, var_53_2, var_53_7, arg_53_0.id, var_53_8, var_53_5.specialVal and var_53_5.specialVal[2])
					end
				end
			end
		end
	end

	return true
end

function battleEasy.protectionProcess(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0 = arg_54_0.args.from == battle.DamageFrom.skill
	local var_54_1 = arg_54_0.args.isBeginDamageSeg

	local function var_54_2(arg_55_0)
		if not arg_55_0 or not arg_55_0.protectObj then
			return true
		end

		local var_55_0 = arg_55_0.protectObj

		if arg_54_0:damageFromExtraExit(battle.DamageFromExtra.protect) then
			return true
		end

		if arg_55_0.type == 1 then
			if arg_54_0.args.from == battle.DamageFrom.rebound then
				return true
			end

			local var_55_1 = var_55_0:getEventByKey(battle.ExRecordEvent.protectTarget)

			if var_55_1 and var_55_1.protectingObj then
				return var_55_1.protectingObj.id ~= arg_54_2.id
			end
		end

		if var_55_0:isAlreadyDead() then
			return true
		end

		if var_55_0:isNotReSelect(true) then
			return true
		end

		if var_55_0:isSelfControled() then
			return true
		end

		return not arg_55_0:checkCondition()
	end

	local var_54_3
	local var_54_4

	for iter_54_0, iter_54_1 in arg_54_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.protection, var_54_2) do
		local var_54_5 = iter_54_1.protectObj
		local var_54_6 = true

		if var_54_1 and var_54_0 then
			if iter_54_1.type == 1 then
				var_54_4 = arg_54_0.args.leftDamage or arg_54_0.valueF

				if var_54_4 < arg_54_2:hp() * iter_54_1.extraArgs[1] then
					var_54_6 = false
				end
			end

			iter_54_1.triggerProtected = var_54_6

			if var_54_6 then
				arg_54_2:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
					buffId = iter_54_1.id,
					easyEffectFunc = iter_54_1.buff.csvCfg.easyEffectFunc,
					obj = var_54_5
				})
				var_54_5:addExRecord(battle.ExRecordEvent.protectTarget, {
					protectingObj = arg_54_2
				})
				arg_54_2:addExRecord(battle.ExRecordEvent.protectTarget, {
					obj = var_54_5,
					showProcess = iter_54_1.type ~= 1
				})
			end
		end

		if var_54_0 then
			var_54_6 = iter_54_1.triggerProtected
		end

		if var_54_6 then
			local var_54_7 = math.floor(arg_54_0.valueF * iter_54_1.ratio)
			local var_54_8 = var_0_2(arg_54_0.args)

			var_54_8.fromExtra[battle.DamageFromExtra.protect] = true

			if var_54_0 and iter_54_1.type == 1 then
				arg_54_1.curSkill:onProtectTarget(var_54_5, var_54_7, var_54_4, var_54_8, iter_54_1.extraArgs[2])
			else
				var_54_5:beAttack(arg_54_1, var_54_7, iter_54_1.extraArgs and iter_54_1.extraArgs[2] or arg_54_0.id, var_54_8)
			end

			arg_54_0.valueF = math.floor(arg_54_0.valueF * (1 - iter_54_1.ratio))
			arg_54_0.args.extraShowValueF = var_54_7
			arg_54_0.args.hideHeadNumber = iter_54_1.type == 1

			break
		end
	end

	return true
end

function battleEasy.groupShieldProcess(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = arg_56_2.scene:excuteGroupObjFunc(arg_56_2.force, battle.SpecialObjectId.teamShiled, "beAttack", arg_56_1, arg_56_2, arg_56_0)

	if not var_56_0 then
		return true
	end

	arg_56_0.valueF = arg_56_0.valueF - var_56_0

	if arg_56_0.valueF == 0 then
		return false
	end

	return true
end

function battleEasy.delayDamageProcess(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	if arg_57_0.id == 201 then
		-- block empty
	elseif arg_57_2:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.delayDamage) then
		local var_57_0 = arg_57_0.valueF

		for iter_57_0, iter_57_1 in arg_57_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.delayDamage) do
			local var_57_1 = math.min(arg_57_0.valueF * iter_57_1.delayPer, var_57_0)
			local var_57_2 = math.floor(var_57_1 / iter_57_1.time)
			local var_57_3 = {}

			for iter_57_2 = 1, iter_57_1.time do
				table.insert(var_57_3, var_57_2)
			end

			table.insert(iter_57_1.damageTb, var_57_3)

			var_57_0 = var_57_0 - var_57_2 * iter_57_1.time

			if var_57_0 <= 0 then
				break
			end
		end

		arg_57_0.valueF = math.max(var_57_0, 0)
	end

	return true
end

function battleEasy.shieldProcess(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	local var_58_0 = arg_58_0.buffExtraArgs.data and arg_58_0.buffExtraArgs.data.calcList

	if arg_58_4 then
		battleEasy.fillDamageEnv(arg_58_1, arg_58_2, arg_58_0, {
			shieldHp = arg_58_2:shieldHp(var_58_0),
			totalShieldHp = arg_58_2:shieldHp()
		})

		return battleEasy.shieldProcess(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	end

	if arg_58_0.shieldHp and arg_58_0.shieldHp > 0 then
		local var_58_1 = arg_58_0.shieldHp - arg_58_0.valueF

		arg_58_2:addShieldHp(-arg_58_0.valueF, var_58_0)

		local var_58_2 = var_58_1 <= 0 and arg_58_0.totalShieldHp > arg_58_0.shieldHp

		if var_58_1 > 0 or var_58_2 then
			arg_58_0:showTargetHeadNumber(arg_58_2)
			arg_58_2:refreshShield()

			local var_58_3 = var_58_2 and arg_58_0.shieldHp or arg_58_0.valueF

			arg_58_2.scene.play:recordScoreStats(arg_58_1, math.floor(var_58_3 / 2))

			arg_58_0.args.extraValueF = var_58_3

			if var_58_2 then
				arg_58_0.valueF = -var_58_1

				return true
			end

			arg_58_0.valueF = 0

			return false
		else
			arg_58_2.scene.play:recordScoreStats(arg_58_1, math.floor(arg_58_0.shieldHp / 2))

			arg_58_0.args.extraValueF = arg_58_0.shieldHp
			arg_58_0.valueF = -var_58_1

			arg_58_2:clearBuff(nil, arg_58_2:getBuffQuery():group("easyEffectFunc", "shield"))
			arg_58_2:refreshShield()
			arg_58_2:triggerBuffOnPoint(battle.BuffTriggerPoint.onHolderShieldBreak, arg_58_2)
		end
	end

	return true
end

function battleEasy.lockHpProcess(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	if arg_59_2:checkOverlaySpecBuffExit(battle.OverlaySpecBuff.lockHp) then
		local var_59_0
		local var_59_1 = arg_59_0.args.skillDamageId or arg_59_0.args.damageId
		local var_59_2 = {}

		arg_59_0.lockHpOriginValue = arg_59_0.valueF

		local function var_59_3(arg_60_0, arg_60_1, arg_60_2)
			if arg_60_2 < arg_59_0.valueF and not arg_60_0.damageMap[var_59_1] then
				arg_60_0.damageMap[var_59_1] = arg_60_1
			end

			if arg_60_0.damageMap[var_59_1] then
				if var_59_0 then
					arg_59_0.valueF = math.min(arg_60_0.damageMap[var_59_1], arg_60_1)
					arg_60_0.damageMap[var_59_1] = nil

					return true
				else
					arg_59_0.valueF = 0
				end
			end

			return false
		end

		local function var_59_4(arg_61_0)
			return not arg_61_0:checkCondition(arg_59_1)
		end

		for iter_59_0, iter_59_1 in arg_59_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.lockHp, var_59_4) do
			var_59_0 = arg_59_0.args.isLastDamageSeg

			local var_59_5 = iter_59_1.buff

			var_59_5:addExRecord(battle.ExRecordEvent.lockHpDamage, arg_59_0.valueF)

			if iter_59_1.mode == 0 then
				local var_59_6 = type(iter_59_1.extraArg) == "table" and arg_59_2:getBaseAttr("hpMax") * iter_59_1.extraArg[1] + arg_59_2:hpMax() * iter_59_1.extraArg[2] or 1

				if var_59_6 > arg_59_2:hp() then
					arg_59_0.valueF = 0
				else
					var_59_0 = var_59_3(iter_59_1, math.max(arg_59_2:hp() - var_59_6, 0), arg_59_2:hp() - var_59_6) and var_59_0
				end
			elseif iter_59_1.mode == 1 then
				arg_59_0.valueF = 0
			elseif iter_59_1.mode == 2 then
				if arg_59_0.args.isBeginDamageSeg or not iter_59_1.recordDamage then
					iter_59_1.recordDamage = arg_59_2:hpMax() * iter_59_1.extraArg
				end

				var_59_0 = var_59_3(iter_59_1, iter_59_1.recordDamage, iter_59_1.recordDamage) and var_59_0
				iter_59_1.recordDamage = math.max(iter_59_1.recordDamage - arg_59_0.valueF, 0)
			end

			if (iter_59_1.mode == 0 or iter_59_1.mode == 2) and iter_59_1.isAlreadyTrigger == true or iter_59_1.mode == 1 then
				arg_59_2.scene:deleteBeAttackDefer(arg_59_2.id, battle.DamageFromExtra.allocate, arg_59_0.args.damageId)
			end

			if var_59_0 then
				iter_59_1.isAlreadyTrigger = true
				iter_59_1.triggerTime = iter_59_1.triggerTime - 1

				var_59_5:playTriggerPointEffect()

				if iter_59_1.isPreDelete then
					if iter_59_1.mode == 0 or iter_59_1.mode == 1 then
						arg_59_0.valueF = 0

						break
					end
				else
					if iter_59_1.triggerTime <= 0 then
						if iter_59_1.triggerEndRound ~= 0 then
							iter_59_1.triggerTime = 99
							var_59_5.lifeRound = iter_59_1.triggerEndRound
							var_59_5.nowRound = arg_59_2:getBattleRoundAllWave(var_59_5.csvCfg.skillTimePos)
						else
							iter_59_1.isPreDelete = true
						end
					end

					var_59_5:addExRecord(battle.ExRecordEvent.lockHpTriggerTime, iter_59_1.triggerTime)
					table.insert(var_59_2, {
						buff = var_59_5,
						isDelete = iter_59_1.isPreDelete
					})
				end
			end

			if iter_59_1.mode == 0 or iter_59_1.mode == 1 or iter_59_1.mode == 2 and arg_59_0.valueF < arg_59_2:hp() then
				break
			end
		end

		for iter_59_2, iter_59_3 in ipairs(var_59_2) do
			local var_59_7 = iter_59_3.buff:getEventByKey(battle.ExRecordEvent.lockHpTriggerState)

			iter_59_3.buff:addExRecord(battle.ExRecordEvent.lockHpTriggerState, true)
			arg_59_2:triggerBuffOnPoint(battle.BuffTriggerPoint.onBuffTrigger, {
				checkEffectFunc = "lockHpAndKeepHpUnChanged",
				buffId = iter_59_3.buff.id,
				buffCfgId = iter_59_3.buff.cfgId,
				easyEffectFunc = iter_59_3.buff.csvCfg.easyEffectFunc,
				isFirstTrigger = not var_59_7
			})

			if iter_59_3.isDelete then
				iter_59_3.buff:over()
			end
		end
	end

	return true
end

function battleEasy.freezeProcess(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	if arg_62_2.freezeHp and arg_62_2.freezeHp > 0 and arg_62_0.valueF >= 1 then
		local var_62_0 = arg_62_2.freezeHp - arg_62_0.valueF
		local var_62_1 = arg_62_0.valueF
		local var_62_2 = {}

		for iter_62_0, iter_62_1 in arg_62_2:ipairsOverlaySpecBuff(battle.OverlaySpecBuff.freeze) do
			if var_62_1 <= 0 then
				break
			end

			if var_62_1 > iter_62_1.freezeHp then
				iter_62_1.freezeHp = 0
				var_62_1 = var_62_1 - iter_62_1.freezeHp
				var_62_2[iter_62_1.id] = true
			else
				iter_62_1.freezeHp = iter_62_1.freezeHp - var_62_1
				var_62_1 = 0
			end
		end

		arg_62_2:delBuff(var_62_2, true)

		if var_62_0 > 0 then
			arg_62_2.freezeHp = var_62_0

			arg_62_2:refreshShield()
		end
	end

	return true
end

function battleEasy.suckbloodProcess(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	if arg_63_1 and arg_63_0.args.from == battle.DamageFrom.skill and arg_63_0.args.skillType ~= battle.SkillType.PassiveCombine then
		local var_63_0 = arg_63_1:suckBlood()

		if var_63_0 > 0 then
			local var_63_1 = math.floor(var_63_0 * arg_63_0.valueF)

			log.battle.object.suckHp(" 吸血计算: attacker suckBloodVal=", var_63_0, "吸收血量: suckHp=", var_63_1)
			arg_63_1:resumeHp(arg_63_1, var_63_1, {
				ignoreBeHealAddRate = true,
				ignoreLockResume = true,
				from = battle.ResumeHpFrom.suckblood
			})
		end
	end

	return true
end

function battleEasy.reboundProcess(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	if arg_64_1 and arg_64_1.force ~= arg_64_2.force and arg_64_0.args.from == battle.DamageFrom.skill and arg_64_0.args.skillType ~= battle.SkillType.PassiveCombine then
		local var_64_0 = arg_64_2:rebound()

		if var_64_0 > 0 then
			local var_64_1 = math.max(arg_64_1:hp(), 1)
			local var_64_2 = arg_64_0.valueF

			if arg_64_0.lockHpOriginValue then
				var_64_2 = var_64_2 + (arg_64_0.lockHpOriginValue - var_64_2) * gCommonConfigCsv.reboundFix
			end

			local var_64_3 = math.min(math.floor(var_64_0 * var_64_2), var_64_1 - 1)

			arg_64_2.scene:deferBeAttack(arg_64_2.id, arg_64_2, arg_64_1, var_64_3, 2, {
				isLastDamageSeg = true,
				isBeginDamageSeg = true,
				from = battle.DamageFrom.rebound,
				fromExtra = arg_64_0.args.fromExtra or {},
				beAttackZOrder = arg_64_0.args.beAttackZOrder
			})
		end
	end

	return true
end

function battleEasy.finalRateProcess(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	if arg_65_4 then
		battleEasy.fillDamageEnv(arg_65_1, arg_65_2, arg_65_0, {
			finalDamageAdd = arg_65_1:finalDamageAdd(),
			finalDamageReduce = arg_65_1:finalDamageReduce(),
			finalDamageSub = arg_65_2:finalDamageSub(),
			finalDamageDeepen = arg_65_2:finalDamageDeepen()
		})

		return battleEasy.finalRateProcess(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	end

	local var_65_0 = math.max(arg_65_0:finalDamageAdd() - arg_65_0:finalDamageReduce() - arg_65_0:finalDamageSub() + arg_65_0:finalDamageDeepen() + ConstSaltNumbers.one, ConstSaltNumbers.dot05)

	arg_65_0.valueF = arg_65_0.valueF * var_65_0

	return true
end

function battleEasy.resultProcess(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
	if arg_66_4 then
		battleEasy.fillDamageEnv(arg_66_1, arg_66_2, arg_66_0, {
			ignoreFakeDeath = arg_66_0.args.ignoreFakeDeath or 0
		})

		return battleEasy.resultProcess(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	end

	if not arg_66_0:damageFromExtraExit() then
		arg_66_0.args.ignoreFakeDeath = battleEasy.ifElse(arg_66_0.ignoreFakeDeath == 0, false, true)
	end

	arg_66_0:showTargetHeadNumber(arg_66_2)

	return false
end

function battleEasy.valueTypeTable()
	local var_67_0 = {}

	var_67_0 = {
		__valueTypeTable = true,
		value = table.salttable({}),
		__tostring = function()
			if device.platform == "windows" then
				return string.format("%s/%s/%s", var_67_0:get(var_0_0.normal), var_67_0:get(var_0_0.overFlow), var_67_0:get(var_0_0.valid))
			end
		end
	}

	function var_67_0.get(arg_69_0, arg_69_1)
		arg_69_1 = arg_69_1 or var_0_0.normal

		return arg_69_0.value[arg_69_1]
	end

	function var_67_0.set(arg_70_0, arg_70_1, arg_70_2)
		arg_70_1 = arg_70_1 or var_0_0.normal
		arg_70_0.value[arg_70_1] = math.floor(arg_70_2)
	end

	function var_67_0.add(arg_71_0, arg_71_1, arg_71_2)
		if type(arg_71_1) == "table" then
			for iter_71_0, iter_71_1 in pairs(var_0_0) do
				arg_71_0:set(iter_71_1, arg_71_0:get(iter_71_1) + (arg_71_1.__valueTypeTable and arg_71_1:get(iter_71_1) or arg_71_1[iter_71_1]))
			end
		else
			arg_71_2 = arg_71_2 or var_0_0.normal

			arg_71_0:set(arg_71_2, arg_71_0:get(arg_71_2) + arg_71_1)
		end
	end

	function var_67_0.addTable(arg_72_0, arg_72_1, ...)
		if type(arg_72_1) ~= "table" or not arg_72_1.__valueTypeTable then
			errorInWindows("valueTypeTable addTable type error, data is %s, need __valueTypeTable", arg_72_1)
		end

		local var_72_0 = {
			...
		}

		var_72_0 = table.length(var_72_0) > 0 and var_72_0 or var_0_0

		for iter_72_0, iter_72_1 in pairs(var_72_0) do
			arg_72_0:set(iter_72_1, arg_72_0:get(iter_72_1) + arg_72_1:get(iter_72_1))
		end
	end

	for iter_67_0, iter_67_1 in pairs(var_0_0) do
		var_67_0.value[iter_67_1] = 0
	end

	return var_67_0
end
