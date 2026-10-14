local var_0_0 = {}

battleTarget.input = var_0_0

function var_0_0.myself()
	env.force = self.force
	env.selectObj = self

	return {
		self
	}
end

function var_0_0.selected()
	env.force = selectObj and selectObj.force or env.force

	return {
		selectObj
	}
end

function var_0_0.object(arg_3_0, arg_3_1)
	arg_3_0 = self.scene.play.operateForce == 2 and mirrorSeat(arg_3_0) or arg_3_0

	local var_3_0 = self.scene:getObjectBySeatExcludeDead(arg_3_0, arg_3_1)

	env.force = var_3_0 and var_3_0.force or env.force
	env.selectObj = var_3_0

	return {
		var_3_0
	}
end

function var_0_0.objectEx(arg_4_0, arg_4_1)
	local var_4_0 = self.force == 1 and 2 or 1
	local var_4_1 = arg_4_0 == 0 and self.force or var_4_0
	local var_4_2 = self.scene:getGroupObj(var_4_1, arg_4_1)

	env.force = var_4_2 and var_4_2.force or env.force
	env.selectObj = var_4_2

	return {
		var_4_2
	}
end

function var_0_0.all()
	env.force = selectObj and selectObj.force or env.force

	local var_5_0 = itertools.iter(self.scene:getHerosMap(1):pairs())
	local var_5_1 = itertools.iter(self.scene:getHerosMap(2):pairs())
	local var_5_2 = itertools.values(itertools.chain({
		var_5_0,
		var_5_1
	}))

	table.sort(var_5_2, function(arg_6_0, arg_6_1)
		return arg_6_0.id < arg_6_1.id
	end)

	return var_5_2
end

function var_0_0.selfForce()
	env.force = self.force

	local var_7_0 = self.scene:getHerosMap(self.force)

	return itertools.values(var_7_0:order_pairs())
end

function var_0_0.enemyForce(arg_8_0)
	env.force = 3 - self.force

	local var_8_0 = 3 - self.force
	local var_8_1 = self.curSkill and self.curSkill.isSpellTo
	local var_8_2 = not arg_8_0 and self:needAlterForce() and var_8_1

	if var_8_2 then
		var_8_0 = self.force
	end

	env.force = var_8_0

	local var_8_3 = self.scene:getHerosMap(var_8_0)
	local var_8_4 = itertools.values(var_8_3:order_pairs())

	if var_8_2 then
		return arraytools.filter(var_8_4, function(arg_9_0, arg_9_1)
			return arg_9_1.id ~= self.id
		end)
	else
		return var_8_4
	end
end

function var_0_0.extraHerosAll()
	env.force = selectObj and selectObj.force or env.force

	return itertools.values(self.scene.extraHeros:order_pairs())
end

function var_0_0.enemyRow(arg_11_0, arg_11_1)
	local var_11_0 = self.force == 1 and 2 or 1
	local var_11_1, var_11_2 = self.scene:getRowRemain(var_11_0, arg_11_0)

	if var_11_1 == 0 and arg_11_1 then
		arg_11_0 = arg_11_0 == 1 and 2 or 1

		local var_11_3

		var_11_3, var_11_2 = self.scene:getRowRemain(var_11_0, arg_11_0)
	end

	return var_11_2
end

function var_0_0.And(arg_12_0, arg_12_1)
	local var_12_0 = {}
	local var_12_1 = {}

	for iter_12_0, iter_12_1 in ipairs(arg_12_0) do
		table.insert(var_12_0, iter_12_1)

		var_12_1[iter_12_1.id] = true
	end

	for iter_12_2, iter_12_3 in ipairs(arg_12_1) do
		if not var_12_1[iter_12_3.id] then
			table.insert(var_12_0, iter_12_3)

			var_12_1[iter_12_3.id] = true
		end
	end

	table.sort(var_12_0, function(arg_13_0, arg_13_1)
		return arg_13_0.id < arg_13_1.id
	end)

	return var_12_0
end

function var_0_0.whokill()
	return {
		self.attackMeDeadObj
	}
end

function var_0_0.whoattack()
	return {
		self.curAttackMeObj
	}
end

function var_0_0.whohatred()
	return {
		self.attackMeDeadObjHatred
	}
end

function var_0_0.mainTarget()
	return {
		self:getCurTarget()
	}
end

function var_0_0.allDamageTargets()
	local var_18_0 = {}

	if self.curSkill then
		var_18_0 = self.curSkill:targetsMap2Array(self.curSkill.allDamageTargets)
	end

	return var_18_0
end

var_0_0.decorator = {}

function var_0_0.decorator.nodead(arg_19_0)
	return arraytools.filter_inplace(arg_19_0, function(arg_20_0, arg_20_1)
		return not arg_20_1:isAlreadyDead()
	end)
end

function var_0_0.decorator.nodeath(arg_21_0)
	return arraytools.filter_inplace(arg_21_0, function(arg_22_0, arg_22_1)
		return not arg_22_1:isDeath()
	end)
end

function var_0_0.decorator.leaveExtraDeal(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in ipairs(arg_23_1) do
		if iter_23_1.id == arg_23_0.casterId then
			return {
				iter_23_1
			}
		end
	end

	return {}
end

function var_0_0.decorator.nobeskillselectedhint(arg_24_0, arg_24_1)
	return arraytools.filter_inplace(arg_24_1, function(arg_25_0, arg_25_1)
		return not arg_25_1:isLogicStateExit(battle.ObjectLogicState.cantBeSelect, {
			fromObj = self,
			skillFormulaType = arg_24_0.skillFormulaType
		})
	end)
end

function var_0_0.decorator.nobeskillselected(arg_26_0)
	return arraytools.filter_inplace(arg_26_0, function(arg_27_0, arg_27_1)
		if arg_27_1.id == self.id then
			return true
		end

		return not arg_27_1:isLogicStateExit(battle.ObjectLogicState.cantBeAttack, {
			fromObj = self
		}) and not arg_27_1:extraBattleRoundCantAttack()
	end)
end

local var_0_1 = {}

battleTarget.process = var_0_1

function var_0_1.limit(arg_28_0, arg_28_1)
	return arraytools.slice(arg_28_1, 1, arg_28_0 or 1)
end

function var_0_1.single(arg_29_0)
	return {
		arg_29_0[1]
	}
end

var_0_1.first = var_0_1.single

function var_0_1.curSelected(arg_30_0)
	return {
		selectObj
	}
end

function var_0_1.shuffle(arg_31_0)
	for iter_31_0 = 1, table.length(arg_31_0) do
		local var_31_0 = ymrand.random(0, table.length(arg_31_0) - iter_31_0) + iter_31_0

		arg_31_0[iter_31_0], arg_31_0[var_31_0] = arg_31_0[var_31_0], arg_31_0[iter_31_0]
	end

	return arg_31_0
end

function var_0_1.random(arg_32_0, arg_32_1)
	arg_32_0 = arg_32_0 or 1

	if arg_32_0 < 1 then
		return {}
	end

	if arg_32_0 >= table.length(arg_32_1) then
		return arg_32_1
	end

	if arg_32_0 == 1 then
		return {
			arg_32_1[ymrand.random(1, table.length(arg_32_1))]
		}
	end

	for iter_32_0 = 0, table.length(arg_32_1) - arg_32_0 - 1 do
		local var_32_0 = table.length(arg_32_1)

		arg_32_1[ymrand.random(1, var_32_0)] = arg_32_1[var_32_0]

		arraytools.pop(arg_32_1)
	end

	return arg_32_1
end

function var_0_1.exclude(arg_33_0, arg_33_1)
	local var_33_0 = arraytools.hash(arg_33_0)

	return arraytools.filter(arg_33_1, function(arg_34_0, arg_34_1)
		return not var_33_0[arg_34_1.seat]
	end)
end

function var_0_1.include(arg_35_0, arg_35_1)
	local var_35_0 = arraytools.hash(arg_35_0)

	return arraytools.filter(arg_35_1, function(arg_36_0, arg_36_1)
		return var_35_0[arg_36_1.seat]
	end)
end

local function var_0_2(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = {}
	local var_37_1 = {}

	for iter_37_0, iter_37_1 in ipairs(arg_37_0) do
		local var_37_2 = {
			val = arg_37_1(iter_37_1),
			id = iter_37_0
		}

		table.insert(var_37_0, var_37_2)
	end

	table.sort(var_37_0, function(arg_38_0, arg_38_1)
		return arg_37_2(arg_38_0.val, arg_38_1.val)
	end)

	for iter_37_2 = 1, arg_37_3 do
		if var_37_0[iter_37_2] then
			table.insert(var_37_1, arg_37_0[var_37_0[iter_37_2].id])
		end
	end

	return var_37_1
end

local function var_0_3(arg_39_0, arg_39_1, arg_39_2)
	return (itertools.filter(arg_39_1, function(arg_40_0, arg_40_1)
		for iter_40_0, iter_40_1 in arg_40_1:ipairsOverlaySpecBuffTo("leave", arg_39_0, arg_39_2) do
			return false
		end

		local var_40_0 = arg_39_0.curSelectSkill and arg_39_0.curSelectSkill.skillFormulaType

		var_40_0 = arg_39_2.skillFixType or var_40_0

		for iter_40_2, iter_40_3 in arg_40_1:ipairsOverlaySpecBuffTo("stealth", arg_39_0, arg_39_2) do
			if not iter_40_3.cantBeHealHintSwitch and (battleEasy.isSameSkillType(arg_39_2.skillSegType, battle.SkillFormulaType.resumeHp) or battleEasy.isSameSkillType(var_40_0, battle.SkillFormulaType.resumeHp)) then
				return true
			end

			return false
		end

		for iter_40_4, iter_40_5 in arg_40_1:ipairsOverlaySpecBuffTo("depart", arg_39_0, arg_39_2) do
			if not iter_40_5.cantBeHealHintSwitch and (battleEasy.isSameSkillType(arg_39_2.skillSegType, battle.SkillFormulaType.resumeHp) or battleEasy.isSameSkillType(var_40_0, battle.SkillFormulaType.resumeHp)) then
				return true
			end

			return false
		end

		return true
	end))
end

local function var_0_4(arg_41_0, arg_41_1)
	return arg_41_1 < arg_41_0
end

local function var_0_5(arg_42_0, arg_42_1)
	if arg_42_0[1] > arg_42_1[1] then
		return true
	elseif arg_42_0[1] < arg_42_1[1] then
		return false
	elseif arg_42_0[2] > arg_42_1[2] then
		return true
	else
		return false
	end
end

function var_0_1.attr(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = arg_43_1 == "max" and 1 or -1
	local var_43_1 = arg_43_2 or 1

	if arg_43_0 == "selectAttr" then
		arg_43_0 = selectObj[arg_43_0]
		selectObj[arg_43_0] = nil
	end

	local var_43_2 = var_0_3(self, arg_43_3, env)

	return var_0_2(var_43_2, function(arg_44_0)
		local var_44_0 = arg_43_0

		if type(arg_43_0) == "table" then
			var_44_0 = var_0_2(arg_43_0, function(arg_45_0)
				return var_43_0 * arg_44_0[arg_45_0](arg_44_0)
			end, var_0_4, 1)[1]
		end

		return var_43_0 * arg_44_0[var_44_0](arg_44_0)
	end, var_0_4, var_43_1)
end

function var_0_1.attrRatio(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_1 == "max" and 1 or -1

	if arg_46_0 ~= "hp" and arg_46_0 ~= "mp" then
		error("process.attrRatio can only use hp and mp1 attr")
	end

	local var_46_1 = arg_46_0 .. "Max"
	local var_46_2 = var_0_3(self, arg_46_3, env)

	return var_0_2(var_46_2, function(arg_47_0)
		local var_47_0 = var_46_0 * arg_47_0[arg_46_0](arg_47_0)

		return {
			var_47_0 / arg_47_0[var_46_1](arg_47_0),
			var_47_0
		}
	end, var_0_5, arg_46_2)
end

function var_0_1.setSelectAttr(arg_48_0, arg_48_1, arg_48_2)
	selectObj.selectAttr = arg_48_0

	return arg_48_2
end

var_0_1.hpMax = functools.partial(var_0_1.attr, "hp", "max", 1)
var_0_1.hpMin = functools.partial(var_0_1.attr, "hp", "min", 1)
var_0_1.hpRatioMax = functools.partial(var_0_1.attrRatio, "hp", "max", 1)
var_0_1.hpRatioMin = functools.partial(var_0_1.attrRatio, "hp", "min", 1)
var_0_1.attackDamageMax = functools.partial(var_0_1.attr, "damage", "max", 1)
var_0_1.attackDamageMin = functools.partial(var_0_1.attr, "damage", "min", 1)
var_0_1.defenceMax = functools.partial(var_0_1.attr, "defence", "max", 1)
var_0_1.defenceMin = functools.partial(var_0_1.attr, "defence", "min", 1)
var_0_1.mp1Max = functools.partial(var_0_1.attr, "mp1", "max", 1)
var_0_1.mp1Min = functools.partial(var_0_1.attr, "mp1", "min", 1)
var_0_1.mp1RatioMax = functools.partial(var_0_1.attrRatio, "mp1", "max", 1)
var_0_1.mp1RatioMin = functools.partial(var_0_1.attrRatio, "mp1", "min", 1)
var_0_1.specialDamageMax = functools.partial(var_0_1.attr, "specialDamage", "max", 1)
var_0_1.specialDamageMin = functools.partial(var_0_1.attr, "specialDamage", "min", 1)
var_0_1.speedMax = functools.partial(var_0_1.attr, "speed", "max", 1)
var_0_1.speedMin = functools.partial(var_0_1.attr, "speed", "min", 1)
var_0_1.specialDefenceMax = functools.partial(var_0_1.attr, "specialDefence", "max", 1)
var_0_1.specialDefenceMin = functools.partial(var_0_1.attr, "specialDefence", "min", 1)

local function var_0_6(arg_49_0, arg_49_1, arg_49_2)
	if arg_49_2 then
		return arg_49_0[arg_49_1](arg_49_0) / arg_49_0[arg_49_1 .. "Max"](arg_49_0)
	end

	return arg_49_0[arg_49_1](arg_49_0)
end

function var_0_1.attrBiggerThanValue(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = {}

	for iter_50_0, iter_50_1 in ipairs(arg_50_4) do
		local var_50_1 = var_0_6(iter_50_1, arg_50_0, arg_50_1)

		if env[arg_50_2](var_50_1, arg_50_3) then
			table.insert(var_50_0, iter_50_1)
		end
	end

	return var_50_0
end

var_0_1.hpBiggerThan = functools.partial(var_0_1.attrBiggerThanValue, "hp", nil, "moreThan")
var_0_1.hpLessThan = functools.partial(var_0_1.attrBiggerThanValue, "hp", nil, "lessThan")
var_0_1.hpPerBiggerThan = functools.partial(var_0_1.attrBiggerThanValue, "hp", "per", "moreThan")
var_0_1.hpPerLessThan = functools.partial(var_0_1.attrBiggerThanValue, "hp", "per", "lessThan")

function var_0_1.getTargetsInSkillCdRange(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = {}
	local var_51_1 = {
		max = env.moreThan,
		min = env.lessThan,
		moreE = env.moreE,
		lessE = env.lessE,
		equal = function(arg_52_0, arg_52_1)
			return arg_52_0 == arg_52_1
		end
	}
	local var_51_2 = 0
	local var_51_3 = 0
	local var_51_4 = true

	local function var_51_5(arg_53_0)
		if var_51_1[arg_51_0](var_51_2, var_51_3) then
			var_51_0[1] = arg_53_0
			var_51_3 = var_51_2
		end
	end

	local function var_51_6(arg_54_0)
		if var_51_1[arg_51_0](var_51_2, var_51_3) then
			table.insert(var_51_0, arg_54_0)
		end
	end

	local var_51_7

	if arg_51_0 == "max" or arg_51_0 == "min" then
		var_51_4 = true
		var_51_7 = var_51_5
	else
		var_51_4 = false
		var_51_3 = arg_51_1
		var_51_7 = var_51_6
	end

	for iter_51_0, iter_51_1 in ipairs(arg_51_2) do
		for iter_51_2, iter_51_3 in iter_51_1:iterSkills() do
			if iter_51_3.skillType2 == 1 then
				var_51_2 = iter_51_3:getLeftCDRound()

				if var_51_4 then
					table.insert(var_51_0, iter_51_1)

					var_51_3 = var_51_2
					var_51_4 = false
				else
					var_51_7(iter_51_1)
				end
			end
		end
	end

	return var_51_0
end

local function var_0_7(arg_55_0, arg_55_1)
	return
end

local function var_0_8(arg_56_0, arg_56_1)
	local var_56_0 = arraytools.hash(arg_56_0)
	local var_56_1 = {}

	for iter_56_0, iter_56_1 in ipairs(arg_56_1) do
		if var_56_0[iter_56_1:getNatureType(1)] or var_56_0[iter_56_1:getNatureType(2)] then
			table.insert(var_56_1, iter_56_1)
		end
	end

	return var_56_1
end

local function var_0_9(arg_57_0, arg_57_1)
	local var_57_0 = arraytools.hash(arg_57_0)
	local var_57_1 = {}

	for iter_57_0, iter_57_1 in ipairs(arg_57_1) do
		local var_57_2 = iter_57_1.unitCfg.battleFlag

		if var_57_2 then
			for iter_57_2, iter_57_3 in ipairs(var_57_2) do
				if var_57_0[iter_57_3] then
					table.insert(var_57_1, iter_57_1)

					break
				end
			end
		end
	end

	return var_57_1
end

local function var_0_10(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = {}

	for iter_58_0, iter_58_1 in ipairs(arg_58_2) do
		for iter_58_2, iter_58_3 in ipairs(arg_58_0) do
			if iter_58_1[arg_58_1](iter_58_1, iter_58_3) then
				table.insert(var_58_0, iter_58_1)

				break
			end
		end
	end

	return var_58_0
end

local function var_0_11(arg_59_0, arg_59_1)
	local var_59_0 = {}

	for iter_59_0, iter_59_1 in ipairs(arg_59_1) do
		for iter_59_2, iter_59_3 in iter_59_1:iterBuffs() do
			if arg_59_0(iter_59_3) then
				table.insert(var_59_0, iter_59_1)

				break
			end
		end
	end

	return var_59_0
end

function var_0_1.attrDiffer(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = {}

	if arg_60_0 == "natureType" then
		var_60_0 = var_0_8(arg_60_1, arg_60_2)
	elseif arg_60_0 == "characterType" then
		-- block empty
	end

	return var_60_0
end

function var_0_1.battleFlagDiffer(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = {}

	if arg_61_0 == "battleFlag" then
		var_61_0 = var_0_9(arg_61_1, arg_61_2)
	end

	return var_61_0
end

function var_0_1.buffDiffer(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = {}

	if arg_62_0 == "id" then
		var_62_0 = var_0_10(arg_62_1, "hasBuff", arg_62_2)
	elseif arg_62_0 == "group" then
		var_62_0 = var_0_10(arg_62_1, "hasBuffGroup", arg_62_2)
	elseif arg_62_0 == "groupFilter" then
		local var_62_1 = arg_62_1[1]
		local var_62_2 = arg_62_1[2]

		var_62_0 = var_0_11(function(arg_63_0)
			if itertools.include(var_62_2, arg_63_0:group()) then
				for iter_63_0, iter_63_1 in pairs(var_62_1) do
					if arg_63_0.csvPower[iter_63_0] ~= iter_63_1 then
						return false
					end
				end

				return true
			end

			return false
		end, arg_62_2)
	elseif arg_62_0 == "type" then
		var_62_0 = var_0_10(arg_62_1, "hasTypeBuff", arg_62_2)
	end

	return var_62_0
end

function var_0_1.randomSpec(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	if arg_64_0 >= table.length(arg_64_3) then
		return arg_64_3
	end

	local var_64_0 = {}
	local var_64_1 = {}

	if arg_64_1 == "buffGrpProIn2Ary" then
		for iter_64_0, iter_64_1 in ipairs(arg_64_2) do
			table.insert(var_64_0, function(arg_65_0)
				return table.length(var_0_10(iter_64_1, "hasBuffGroup", {
					arg_65_0
				})) > 0
			end)
		end
	end

	while table.length(var_64_0) > 0 do
		for iter_64_2, iter_64_3 in ipairs(arg_64_3) do
			if var_64_0[1](iter_64_3) then
				table.insert(var_64_1, iter_64_3)
			end
		end

		if arg_64_0 <= table.length(var_64_1) then
			return var_0_1.random(arg_64_0, var_64_1)
		end

		table.remove(var_64_0, 1)
	end

	return var_64_1
end

function var_0_1.natureTypeExcept(arg_66_0, arg_66_1)
	return
end

local function var_0_12(arg_67_0)
	return arg_67_0.seat
end

function var_0_1.row(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	local var_68_0 = arg_68_2 and 3 - env.force or env.force
	local var_68_1 = 1
	local var_68_2 = forceNumber

	if var_68_0 ~= 1 then
		var_68_1, var_68_2 = var_68_1 + forceNumber, var_68_2 + forceNumber
	end

	if arg_68_0 then
		var_68_2 = var_68_2 - rowNumber
	else
		var_68_1 = var_68_1 + rowNumber
	end

	local var_68_3 = arraytools.filter(arg_68_3, function(arg_69_0, arg_69_1)
		return var_68_1 <= var_0_12(arg_69_1) and var_0_12(arg_69_1) <= var_68_2
	end)

	if table.length(var_0_3(self, var_68_3, env)) == 0 and arg_68_1 then
		var_68_3 = var_0_1.row(not arg_68_0, false, arg_68_2, arg_68_3)
	end

	return var_68_3
end

var_0_1.rowback = functools.partial(var_0_1.row, false, true, false)
var_0_1.rowfront = functools.partial(var_0_1.row, true, true, false)
var_0_1.rowbackor = functools.partial(var_0_1.row, false, false, false)
var_0_1.rowfrontor = functools.partial(var_0_1.row, true, false, false)

function var_0_1.column(arg_70_0)
	local var_70_0 = env.force
	local var_70_1 = 1

	if var_70_0 ~= 1 then
		var_70_1 = var_70_1 + forceNumber
	end

	local var_70_2 = selectObj.seat - 1

	if var_70_2 >= forceNumber then
		var_70_2 = var_70_2 - forceNumber
	end

	if var_70_2 >= rowNumber then
		var_70_2 = var_70_2 - rowNumber
	end

	local var_70_3 = var_70_1 + var_70_2

	return arraytools.filter(arg_70_0, function(arg_71_0, arg_71_1)
		return var_0_12(arg_71_1) == var_70_3 or var_0_12(arg_71_1) == var_70_3 + rowNumber
	end)
end

local var_0_13 = {
	{
		0,
		1
	},
	{
		1,
		0
	},
	{
		0,
		-1
	},
	{
		-1,
		0
	}
}

local function var_0_14(arg_72_0, arg_72_1, arg_72_2)
	arg_72_0 = (arg_72_0 - 1) % arg_72_2

	return math.floor(arg_72_0 / arg_72_1), arg_72_0 % arg_72_1
end

local function var_0_15(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	if arg_73_0 < 0 or arg_73_3 <= arg_73_0 then
		return nil
	end

	if arg_73_1 < 0 or arg_73_2 <= arg_73_1 then
		return nil
	end

	return arg_73_0 * arg_73_2 + arg_73_1 + 1
end

local var_0_16 = {
	left = {
		{
			4,
			5,
			6
		},
		{
			1,
			2,
			3
		}
	},
	right = {
		{
			7,
			8,
			9
		},
		{
			10,
			11,
			12
		}
	}
}
local var_0_17 = {
	left = {
		{
			x = 2,
			y = 1
		},
		{
			x = 2,
			y = 2
		},
		{
			x = 2,
			y = 3
		},
		{
			x = 1,
			y = 1
		},
		{
			x = 1,
			y = 2
		},
		{
			x = 1,
			y = 3
		}
	},
	right = {
		[7] = {
			x = 1,
			y = 1
		},
		[8] = {
			x = 1,
			y = 2
		},
		[9] = {
			x = 1,
			y = 3
		},
		[10] = {
			x = 2,
			y = 1
		},
		[11] = {
			x = 2,
			y = 2
		},
		[12] = {
			x = 2,
			y = 3
		}
	}
}

function var_0_1.near(arg_74_0)
	local var_74_0 = selectObj.force == 1 and var_0_17.left or var_0_17.right
	local var_74_1 = selectObj.force == 1 and var_0_16.left or var_0_16.right
	local var_74_2 = var_74_0[var_0_12(selectObj)]
	local var_74_3 = {
		[var_74_1[var_74_2.x][var_74_2.y]] = true
	}

	for iter_74_0, iter_74_1 in ipairs(var_0_13) do
		local var_74_4 = iter_74_1[1] + var_74_2.x
		local var_74_5 = iter_74_1[2] + var_74_2.y

		if var_74_4 > 0 and var_74_4 <= 2 and var_74_5 > 0 and var_74_5 <= 3 then
			var_74_3[var_74_1[var_74_4][var_74_5]] = true
		end
	end

	return arraytools.filter(arg_74_0, function(arg_75_0, arg_75_1)
		return var_74_3[var_0_12(arg_75_1)]
	end)
end

function var_0_1.sputtering(arg_76_0, arg_76_1)
	for iter_76_0, iter_76_1 in ipairs(arg_76_1) do
		iter_76_1:addExRecord(battle.ExRecordEvent.sputtering, {
			rate = arg_76_0
		})
	end

	return arg_76_1
end

function var_0_1.penetrate(arg_77_0, arg_77_1)
	for iter_77_0, iter_77_1 in ipairs(arg_77_1) do
		iter_77_1:addExRecord(battle.ExRecordEvent.penetrate, {
			rate = arg_77_0
		})
	end

	return arg_77_1
end

local function var_0_18(arg_78_0, arg_78_1, arg_78_2, arg_78_3)
	local var_78_0 = {}
	local var_78_1 = {}
	local var_78_2 = {}
	local var_78_3 = {}

	for iter_78_0, iter_78_1 in ipairs(arg_78_0) do
		local var_78_4 = iter_78_1.scene

		var_78_1[var_0_12(iter_78_1)] = var_78_4.placeIdInfoTb[var_0_12(iter_78_1)]
	end

	if arg_78_1 and (arg_78_1 == 1 or arg_78_1 == 2) then
		itertools.each(var_78_1, function(arg_79_0, arg_79_1)
			if var_78_1[arg_79_0]["row" .. arg_78_1] then
				var_78_2[arg_79_0] = true
			end
		end)
	end

	if arg_78_2 and (arg_78_2 == 1 or arg_78_2 == 2 or arg_78_2 == 3) then
		itertools.each(var_78_1, function(arg_80_0, arg_80_1)
			if var_78_1[arg_80_0]["column" .. arg_78_2] then
				var_78_3[arg_80_0] = true
			end
		end)
	end

	local var_78_5 = next(var_78_2)
	local var_78_6 = next(var_78_3)

	if var_78_5 or var_78_6 then
		for iter_78_2, iter_78_3 in ipairs(arg_78_0) do
			local var_78_7 = var_0_12(iter_78_3)

			if var_78_2[var_78_7] and var_78_3[var_78_7] or var_78_2[var_78_7] and not var_78_6 or not var_78_5 and var_78_3[var_78_7] then
				table.insert(var_78_0, iter_78_3)
			end
		end
	end

	return var_78_0
end

function var_0_1.targetRow(arg_81_0)
	local var_81_0, var_81_1 = getRowAndColumn(selectObj)
	local var_81_2 = math.max(1, math.min(var_81_0, 2))

	return var_0_18(arg_81_0, var_81_2, column)
end

function var_0_1.targetFront(arg_82_0)
	local var_82_0, var_82_1 = getRowAndColumn(selectObj)
	local var_82_2 = math.max(1, math.min(-1 + var_82_0, 2))

	return var_0_18(arg_82_0, var_82_2, var_82_1)
end

function var_0_1.targetBack(arg_83_0)
	local var_83_0, var_83_1 = getRowAndColumn(selectObj)
	local var_83_2 = math.max(1, math.min(1 + var_83_0, 2))

	return var_0_18(arg_83_0, var_83_2, var_83_1)
end

function var_0_1.targetColumn(arg_84_0)
	local var_84_0, var_84_1 = getRowAndColumn(selectObj)

	return var_0_18(arg_84_0, row, var_84_1)
end

function var_0_1.selfRow(arg_85_0)
	local var_85_0, var_85_1 = getRowAndColumn(self)
	local var_85_2 = math.max(1, math.min(var_85_0, 2))

	return var_0_18(arg_85_0, var_85_2, column)
end

function var_0_1.selfFront(arg_86_0)
	local var_86_0, var_86_1 = getRowAndColumn(self)
	local var_86_2 = math.max(1, math.min(-1 + var_86_0, 2))

	return var_0_18(arg_86_0, var_86_2, var_86_1)
end

function var_0_1.selfBack(arg_87_0)
	local var_87_0, var_87_1 = getRowAndColumn(self)
	local var_87_2 = math.max(1, math.min(1 + var_87_0, 2))

	return var_0_18(arg_87_0, var_87_2, var_87_1)
end

function var_0_1.selfColumn(arg_88_0)
	local var_88_0, var_88_1 = getRowAndColumn(self)

	return var_0_18(arg_88_0, row, var_88_1)
end

function var_0_1.frontRowRandom(arg_89_0, arg_89_1)
	local var_89_0 = var_0_1.row(true, true, false, arg_89_1)

	return var_0_1.random(arg_89_0, var_89_0)
end

function var_0_1.backRowRandom(arg_90_0, arg_90_1)
	local var_90_0 = var_0_1.row(false, true, false, arg_90_1)

	return var_0_1.random(arg_90_0, var_90_0)
end

local function var_0_19(arg_91_0, arg_91_1, arg_91_2)
	if table.length(arg_91_1) == 0 then
		return arg_91_1
	end

	local var_91_0 = {}
	local var_91_1 = {}
	local var_91_2 = arg_91_2(arg_91_0)

	for iter_91_0, iter_91_1 in ipairs(arg_91_1) do
		local var_91_3 = arg_91_2(iter_91_1)

		if not var_91_0[var_91_3] then
			var_91_0[var_91_3] = {}

			if var_91_3 ~= var_91_2 then
				table.insert(var_91_1, var_91_3)
			end
		end

		table.insert(var_91_0[var_91_3], iter_91_1)
	end

	if var_91_0[var_91_2] then
		return var_91_0[var_91_2]
	else
		return var_91_0[var_91_1[ymrand.random(1, table.length(var_91_1))]]
	end
end

function var_0_1.selfColumnPrior(arg_92_0)
	local function var_92_0(arg_93_0)
		local var_93_0, var_93_1 = getRowAndColumn(arg_93_0)

		return var_93_1
	end

	return var_0_19(self, arg_92_0, var_92_0)
end

function var_0_1.targetAnd(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local var_94_0 = {}
	local var_94_1 = {}

	arg_94_1[#arg_94_1 + 1] = arg_94_4

	for iter_94_0, iter_94_1 in ipairs(var_0_1[arg_94_0](table.unpack(arg_94_1))) do
		table.insert(var_94_0, iter_94_1)

		var_94_1[iter_94_1.id] = true
	end

	arg_94_3[#arg_94_3 + 1] = arg_94_4

	for iter_94_2, iter_94_3 in ipairs(var_0_1[arg_94_2](table.unpack(arg_94_3))) do
		if not var_94_1[iter_94_3.id] then
			table.insert(var_94_0, iter_94_3)

			var_94_1[iter_94_3.id] = true
		end
	end

	table.sort(var_94_0, function(arg_95_0, arg_95_1)
		return arg_95_0.id < arg_95_1.id
	end)

	return var_94_0
end

function var_0_1.paintFlagNum(arg_96_0)
	local var_96_0 = 10000

	for iter_96_0, iter_96_1 in ipairs(arg_96_0) do
		var_96_0 = var_96_0 + 1
		iter_96_1.paintFlagNum = var_96_0
	end

	return arg_96_0
end

function var_0_1.ignoreBuffGroup(arg_97_0, arg_97_1)
	env.ignoreBuffGroup = arg_97_0

	return arg_97_1
end

local var_0_20 = {}

battleTarget.newChooseProcess = var_0_20

function battleTarget.getForceVal(arg_98_0, arg_98_1)
	return
end

local var_0_21 = {
	"buffDiffer",
	"row"
}

for iter_0_0, iter_0_1 in ipairs(var_0_21) do
	var_0_1[iter_0_1 .. "Exclude"] = function(...)
		local var_99_0 = select("#", ...)
		local var_99_1 = select(var_99_0, ...)
		local var_99_2 = var_0_1[iter_0_1](...)

		return arraytools.filter(var_99_1, function(arg_100_0, arg_100_1)
			for iter_100_0, iter_100_1 in ipairs(var_99_2) do
				if iter_100_1.id == arg_100_1.id then
					return false
				end
			end

			return true
		end)
	end
end
