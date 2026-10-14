local var_0_0 = {}

globals.BuffArgs = var_0_0

local var_0_1 = {
	"value",
	"buffValueFormula"
}
local var_0_2 = arraytools.merge({
	var_0_1,
	{
		"cfgId",
		"overlayCount",
		"id",
		"holderID",
		"casterID"
	}
})
local var_0_3 = arraytools.merge({
	var_0_1,
	{
		"prob",
		"lifeRound",
		"overlayCount"
	}
})
local var_0_4 = arraytools.merge({
	var_0_1,
	{
		"value",
		"overlayCount",
		"cfgId",
		"oldBuff",
		"oldHolder",
		"targetType"
	}
})
local var_0_5 = arraytools.merge({
	var_0_1,
	{
		"prob",
		"lifeRound",
		"overlayCount"
	}
})
local var_0_6 = {
	"buffValueFormula",
	"value",
	"fromSkillId",
	"skillLevel",
	"lifeRound",
	"prob",
	"currentAttackTarget",
	"index",
	"skillCfg"
}
local var_0_7 = {
	cfgId = "from buff cfgId = ",
	processId = "from skill processId = "
}

local function var_0_8(arg_1_0, arg_1_1, arg_1_2)
	if device.platform ~= "windows" then
		return arg_1_0
	end

	local var_1_0

	for iter_1_0, iter_1_1 in pairs(var_0_7) do
		if arg_1_2[iter_1_0] then
			var_1_0 = iter_1_1 .. arg_1_2[iter_1_0]

			break
		end
	end

	for iter_1_2, iter_1_3 in ipairs(arg_1_1) do
		assert(arg_1_0[iter_1_3] ~= nil, iter_1_3 .. " is nil, " .. var_1_0)
	end

	return arg_1_0
end

local function var_0_9(arg_2_0, arg_2_1)
	assertInWindows(type(arg_2_1) == "table", "env is not table")

	arg_2_0.buffValueFormulaEnv = arg_2_1

	return arg_2_0
end

function var_0_0.fromCopyOrTransfer1(arg_3_0)
	local var_3_0 = {
		value = arg_3_0.args.value,
		buffValueFormula = arg_3_0.args.buffValueFormula,
		skillCfg = arg_3_0.args.skillCfg,
		cfgId = arg_3_0.cfgId,
		overlayCount = arg_3_0:getOverLayCount(),
		id = arg_3_0.id,
		holderID = arg_3_0.holder.id,
		casterID = arg_3_0.caster.id
	}
	local var_3_1 = var_0_9(var_3_0, arg_3_0.args.buffValueFormulaEnv)

	return var_0_8(var_3_1, var_0_2, {
		cfgId = arg_3_0.cfgId
	})
end

function var_0_0.fromCopyOrTransfer2(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {
		prob = 1,
		value = arg_4_0.value,
		buffValueFormula = arg_4_0.buffValueFormula,
		skillCfg = arg_4_0.skillCfg,
		lifeRound = arg_4_1,
		overlayCount = arg_4_0.overlayCount,
		curSkill = arg_4_2
	}
	local var_4_1 = var_0_9(var_4_0, arg_4_0.buffValueFormulaEnv)

	return var_0_8(var_4_1, var_0_3, {
		cfgId = arg_4_0.cfgId
	})
end

function var_0_0.fromAtOnceTransform1(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = {
		value = arg_5_2,
		buffValueFormula = arg_5_0.args.buffValueFormula,
		skillCfg = arg_5_0.args.skillCfg,
		overlayCount = arg_5_0:getOverLayCount(),
		cfgId = arg_5_1,
		oldBuff = arg_5_0,
		oldHolder = arg_5_0.holder,
		targetType = arg_5_3
	}
	local var_5_1 = var_0_9(var_5_0, arg_5_0.args.buffValueFormulaEnv)

	return var_0_8(var_5_1, var_0_4, {
		cfgId = arg_5_1
	})
end

function var_0_0.fromAtOnceTransform2(arg_6_0, arg_6_1)
	local var_6_0 = {
		prob = 1,
		value = arg_6_0.value,
		buffValueFormula = arg_6_0.buffValueFormula,
		skillCfg = arg_6_0.skillCfg,
		lifeRound = arg_6_1,
		overlayCount = arg_6_0.overlayCount
	}
	local var_6_1 = var_0_9(var_6_0, arg_6_0.buffValueFormulaEnv)

	return var_0_8(var_6_1, var_0_5, {
		cfgId = arg_6_0.cfgId
	})
end

function var_0_0.fromSkill(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0

	if arg_7_1 then
		var_7_0 = arg_7_1[1]
	end

	arg_7_0.protectedEnv:resetEnv()

	local var_7_1 = battleCsv.fillFuncEnv(arg_7_0.protectedEnv, {
		lastMp1 = "lastMp1",
		target = arg_7_2,
		_extraTarget = var_7_0 or arg_7_0.owner:getCurTarget()
	})
	local var_7_2 = battleCsv.doFormula(arg_7_3.buffLifeRound[arg_7_5], var_7_1)
	local var_7_3 = battleCsv.doFormula(arg_7_3.buffProb[arg_7_5], var_7_1)
	local var_7_4 = battleCsv.doFormula(arg_7_3.buffValue1[arg_7_5], var_7_1)
	local var_7_5 = arg_7_4.easyEffectFunc == "changeImage" or arg_7_4.easyEffectFunc == "changeUnit"

	if type(var_7_4) == "table" and var_7_5 then
		var_7_4 = var_7_4[ymrand.random(1, table.length(var_7_4))]
	end

	local var_7_6 = {
		buffValueFormula = arg_7_3.buffValue1[arg_7_5],
		value = var_7_4,
		fromSkillId = arg_7_0.id,
		skillLevel = arg_7_0:getLevel(),
		lifeRound = var_7_2,
		prob = var_7_3,
		lastProcessTargets = arg_7_1,
		currentAttackTarget = arg_7_0.allDamageTargets,
		index = arg_7_5,
		skillCfg = arg_7_0.cfg
	}
	local var_7_7 = var_0_9(var_7_6, var_7_1)

	return var_0_8(var_7_7, var_0_6, {
		processId = arg_7_3.id
	})
end
