local var_0_0 = {
	specialDefence = 0,
	strikeDamageSub = 0,
	mp1Recover = 0,
	flyDamageAdd = 0,
	immuneControl = 0,
	superDamageSub = 0,
	electricityDamageSub = 0,
	iceDamageAdd = 0,
	rockDamageSub = 0,
	specialDefenceIgnore = 0,
	physicalDamageAdd = 0,
	damageRateAdd = 0,
	specialDamageAdd = 0,
	damageReduce = 0,
	fireCure = 0,
	rebound = 0,
	defence = 0,
	controlPer = 0,
	waterDamageSub = 0,
	strike = 0,
	block = 0,
	damage = 0,
	ghostDamageSub = 0,
	steelDamageAdd = 0,
	dragonDamageSub = 0,
	evilDamageSub = 0,
	grassDamageAdd = 0,
	fairyDamageSub = 0,
	fairyCure = 0,
	mp1Max = 0,
	superCure = 0,
	steelDamageSub = 0,
	electricityCure = 0,
	iceCure = 0,
	ignoreDamageSub = 0,
	grassCure = 0,
	rockCure = 0,
	wormDamageAdd = 0,
	wormCure = 0,
	dragonCure = 0,
	evilCure = 0,
	normalCure = 0,
	damageSub = 0,
	fairyDamageAdd = 0,
	pvpDamageAdd = 0,
	pvpDamageSub = 0,
	initMp1 = 0,
	hit = 0,
	dragonDamageAdd = 0,
	combatDamageAdd = 0,
	healAdd = 0,
	fireDamageAdd = 0,
	beHealAdd = 0,
	poisonCure = 0,
	groundCure = 0,
	waterCure = 0,
	trueDamageSub = 0,
	superDamageAdd = 0,
	damageHit = 0,
	combatCure = 0,
	grassDamageSub = 0,
	strikeDamage = 0,
	finalSkillAddRate = 0,
	cure = 0,
	finalDamageDeepen = 0,
	finalDamageReduce = 0,
	mpBeAttackRecover = 0,
	natureRestraint = 0,
	trueDamageAdd = 0,
	damageDeepen = 0,
	defenceIgnore = 0,
	natureResistance = 0,
	flyDamageSub = 0,
	flyCure = 0,
	poisonDamageAdd = 0,
	physicalDamageSub = 0,
	strikeResistance = 0,
	finalDamageSub = 0,
	ignoreStrikeResistance = 0,
	hpRecover = 0,
	combatDamageSub = 0,
	evilDamageAdd = 0,
	steelCure = 0,
	speed = 0,
	groundDamageSub = 0,
	poisonDamageSub = 0,
	suckBlood = 0,
	breakBlock = 0,
	normalDamageSub = 0,
	normalDamageAdd = 0,
	hpMax = 0,
	ultimateAdd = 0,
	ultimateSub = 0,
	dodge = 0,
	fireDamageSub = 0,
	specialDamage = 0,
	rockDamageAdd = 0,
	iceDamageSub = 0,
	damageDodge = 0,
	waterDamageAdd = 0,
	groundDamageAdd = 0,
	damageAdd = 0,
	wormDamageSub = 0,
	electricityDamageAdd = 0,
	blockPower = 0,
	finalDamageAdd = 0,
	ghostCure = 0,
	ghostDamageAdd = 0,
	specialDamageSub = 0
}
local var_0_1 = table.salttable(var_0_0)

local function var_0_2(arg_1_0, arg_1_1)
	return function(arg_2_0, arg_2_1)
		if type(arg_1_1) == "string" then
			arg_1_1 = ConstSaltNumbers[arg_1_1]
		end

		if arg_2_1 then
			local var_2_0 = arg_2_0.base2[arg_1_0] + arg_2_0.buff[arg_1_0]

			return math.max(var_2_0, arg_1_1)
		else
			local var_2_1 = arg_2_0.base[arg_1_0] + arg_2_0.buff[arg_1_0]

			arg_2_0.final[arg_1_0] = math.max(var_2_1, arg_1_1)
		end
	end
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	return function(arg_4_0, arg_4_1)
		if type(arg_3_2) == "string" then
			arg_3_2 = ConstSaltNumbers[arg_3_2]
		end

		if type(arg_3_1) == "string" then
			arg_3_1 = ConstSaltNumbers[arg_3_1]
		end

		if arg_4_1 then
			local var_4_0 = (arg_3_2 or 0) + arg_4_0.base2[arg_3_0] + arg_4_0.buff[arg_3_0]

			return math.max(var_4_0 / ConstSaltNumbers.wan, arg_3_1)
		else
			local var_4_1 = (arg_3_2 or 0) + arg_4_0.base[arg_3_0] + arg_4_0.buff[arg_3_0]

			arg_4_0.final[arg_3_0] = math.max(var_4_1 / ConstSaltNumbers.wan, arg_3_1)
		end
	end
end

local function var_0_4(arg_5_0, arg_5_1)
	return function(arg_6_0)
		if arg_6_0.sceneTag[arg_5_1] then
			arg_5_0(arg_6_0)
		end
	end
end

local var_0_5 = {
	PVP = "pvpAttrTakeEffect"
}
local var_0_6 = {
	hpRecover = var_0_2("hpRecover", "zero"),
	damage = var_0_2("damage", "zero"),
	specialDamage = var_0_2("specialDamage", "zero"),
	defence = var_0_2("defence", "zero"),
	specialDefence = var_0_2("specialDefence", "zero"),
	defenceIgnore = var_0_3("defenceIgnore", "zero"),
	specialDefenceIgnore = var_0_3("specialDefenceIgnore", "zero"),
	hpMax = var_0_2("hpMax", "one"),
	mp1Max = var_0_2("mp1Max", "one"),
	speed = var_0_2("speed", "zero"),
	initMp1 = var_0_2("initMp1", "zero"),
	mp1Recover = var_0_3("mp1Recover", "neg1"),
	strike = var_0_3("strike", "zero"),
	strikeDamage = var_0_3("strikeDamage", "zero"),
	strikeResistance = var_0_3("strikeResistance", "zero"),
	block = var_0_3("block", "zero"),
	breakBlock = var_0_3("breakBlock", "zero"),
	blockPower = var_0_3("blockPower", "zero"),
	dodge = var_0_3("dodge", "zero"),
	hit = var_0_3("hit", "zero"),
	damageAdd = var_0_3("damageAdd", "zero"),
	damageSub = var_0_3("damageSub", "zero"),
	suckBlood = var_0_3("suckBlood", "zero"),
	rebound = var_0_3("rebound", "zero"),
	ultimateAdd = var_0_3("ultimateAdd", "zero"),
	ultimateSub = var_0_3("ultimateSub", "zero"),
	controlPer = var_0_3("controlPer", "zero"),
	immuneControl = var_0_3("immuneControl", "zero"),
	natureRestraint = var_0_3("natureRestraint", "zero"),
	cure = var_0_3("cure", "dot05", "zero"),
	damageDeepen = var_0_3("damageDeepen", "zero"),
	damageReduce = var_0_3("damageReduce", "zero"),
	physicalDamageAdd = var_0_3("physicalDamageAdd", "zero"),
	physicalDamageSub = var_0_3("physicalDamageSub", "zero"),
	specialDamageAdd = var_0_3("specialDamageAdd", "zero"),
	specialDamageSub = var_0_3("specialDamageSub", "zero"),
	normalDamageAdd = var_0_3("normalDamageAdd", "zero"),
	fireDamageAdd = var_0_3("fireDamageAdd", "zero"),
	waterDamageAdd = var_0_3("waterDamageAdd", "zero"),
	grassDamageAdd = var_0_3("grassDamageAdd", "zero"),
	electricityDamageAdd = var_0_3("electricityDamageAdd", "zero"),
	iceDamageAdd = var_0_3("iceDamageAdd", "zero"),
	combatDamageAdd = var_0_3("combatDamageAdd", "zero"),
	poisonDamageAdd = var_0_3("poisonDamageAdd", "zero"),
	groundDamageAdd = var_0_3("groundDamageAdd", "zero"),
	flyDamageAdd = var_0_3("flyDamageAdd", "zero"),
	superDamageAdd = var_0_3("superDamageAdd", "zero"),
	wormDamageAdd = var_0_3("wormDamageAdd", "zero"),
	rockDamageAdd = var_0_3("rockDamageAdd", "zero"),
	ghostDamageAdd = var_0_3("ghostDamageAdd", "zero"),
	dragonDamageAdd = var_0_3("dragonDamageAdd", "zero"),
	evilDamageAdd = var_0_3("evilDamageAdd", "zero"),
	steelDamageAdd = var_0_3("steelDamageAdd", "zero"),
	fairyDamageAdd = var_0_3("fairyDamageAdd", "zero"),
	normalDamageSub = var_0_3("normalDamageSub", "zero"),
	fireDamageSub = var_0_3("fireDamageSub", "zero"),
	waterDamageSub = var_0_3("waterDamageSub", "zero"),
	grassDamageSub = var_0_3("grassDamageSub", "zero"),
	electricityDamageSub = var_0_3("electricityDamageSub", "zero"),
	iceDamageSub = var_0_3("iceDamageSub", "zero"),
	combatDamageSub = var_0_3("combatDamageSub", "zero"),
	poisonDamageSub = var_0_3("poisonDamageSub", "zero"),
	groundDamageSub = var_0_3("groundDamageSub", "zero"),
	flyDamageSub = var_0_3("flyDamageSub", "zero"),
	superDamageSub = var_0_3("superDamageSub", "zero"),
	wormDamageSub = var_0_3("wormDamageSub", "zero"),
	rockDamageSub = var_0_3("rockDamageSub", "zero"),
	ghostDamageSub = var_0_3("ghostDamageSub", "zero"),
	dragonDamageSub = var_0_3("dragonDamageSub", "zero"),
	evilDamageSub = var_0_3("evilDamageSub", "zero"),
	steelDamageSub = var_0_3("steelDamageSub", "zero"),
	fairyDamageSub = var_0_3("fairyDamageSub", "zero"),
	normalCure = var_0_3("normalCure", "zero"),
	fireCure = var_0_3("fireCure", "zero"),
	waterCure = var_0_3("waterCure", "zero"),
	grassCure = var_0_3("grassCure", "zero"),
	electricityCure = var_0_3("electricityCure", "zero"),
	iceCure = var_0_3("iceCure", "zero"),
	combatCure = var_0_3("combatCure", "zero"),
	poisonCure = var_0_3("poisonCure", "zero"),
	groundCure = var_0_3("groundCure", "zero"),
	flyCure = var_0_3("flyCure", "zero"),
	superCure = var_0_3("superCure", "zero"),
	wormCure = var_0_3("wormCure", "zero"),
	rockCure = var_0_3("rockCure", "zero"),
	ghostCure = var_0_3("ghostCure", "zero"),
	dragonCure = var_0_3("dragonCure", "zero"),
	evilCure = var_0_3("evilCure", "zero"),
	steelCure = var_0_3("steelCure", "zero"),
	fairyCure = var_0_3("fairyCure", "zero"),
	pvpDamageAdd = var_0_4(var_0_3("pvpDamageAdd", "zero"), var_0_5.PVP),
	pvpDamageSub = var_0_4(var_0_3("pvpDamageSub", "zero"), var_0_5.PVP),
	strikeDamageSub = var_0_3("strikeDamageSub", "zero"),
	healAdd = var_0_3("healAdd", "neg1"),
	beHealAdd = var_0_3("beHealAdd", "neg1"),
	damageRateAdd = var_0_2("damageRateAdd", "zero"),
	damageDodge = var_0_3("damageDodge", "zero"),
	damageHit = var_0_3("damageHit", "zero"),
	ignoreDamageSub = var_0_3("ignoreDamageSub", "zero"),
	ignoreStrikeResistance = var_0_3("ignoreStrikeResistance", "zero"),
	finalSkillAddRate = var_0_3("finalSkillAddRate", "zero"),
	finalDamageAdd = var_0_3("finalDamageAdd", "zero"),
	finalDamageSub = var_0_3("finalDamageSub", "zero"),
	finalDamageDeepen = var_0_3("finalDamageDeepen", "zero"),
	finalDamageReduce = var_0_3("finalDamageReduce", "zero"),
	mpBeAttackRecover = var_0_3("mpBeAttackRecover", "zero"),
	trueDamageAdd = var_0_3("trueDamageAdd", "zero"),
	trueDamageSub = var_0_3("trueDamageSub", "zero"),
	natureResistance = var_0_3("natureResistance", "zero")
}
local var_0_7 = {
	defence = true,
	mp1Max = true,
	damage = true,
	hpMax = true,
	specialDamage = true,
	specialDefence = true
}

globals.ObjectAttrs = class("ObjectAttrs")
ObjectAttrs.AttrsTable = var_0_0
ObjectAttrs.SixDimensionAttrs = var_0_7

local function var_0_8()
	for iter_7_0, iter_7_1 in pairs(var_0_0) do
		if math.abs(var_0_1[iter_7_0] - iter_7_1) > 1e-05 then
			exitApp("close your cheating software")
		end
	end
end

function globals.getAttrTransformRate(arg_8_0)
	if not var_0_6[arg_8_0] then
		errorInWindows("getAttrTransformRate %s is not attrName", arg_8_0)

		return 1
	end

	local var_8_0 = {
		base = {
			[arg_8_0] = 1
		},
		buff = {
			[arg_8_0] = 0
		},
		final = {
			[arg_8_0] = 0
		}
	}

	var_0_6[arg_8_0](var_8_0)

	return 1 / var_8_0.final[arg_8_0]
end

function ObjectAttrs.ctor(arg_9_0)
	var_0_8()

	arg_9_0.base = table.salttable(var_0_0)
	arg_9_0.base2 = table.salttable(var_0_0)
	arg_9_0.buff = table.salttable(var_0_0)
	arg_9_0.aura = table.salttable(var_0_0)
	arg_9_0.final = table.salttable(var_0_0)
	arg_9_0.sceneTag = {}

	arg_9_0:calcFinal()
end

function ObjectAttrs.setSceneTag(arg_10_0, arg_10_1)
	arg_10_0.sceneTag = arg_10_1 or {}
end

function ObjectAttrs.setBase(arg_11_0, arg_11_1)
	arg_11_1.hpMax = arg_11_1.hp
	arg_11_1.mp1Max = arg_11_1.mp1
	arg_11_1.damageHit = arg_11_1.damageHit or 10000

	local var_11_0 = clone(var_0_0)
	local var_11_1 = clone(var_0_0)

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if arg_11_1[iter_11_0] ~= nil then
			var_11_0[iter_11_0] = arg_11_1[iter_11_0]
			var_11_1[iter_11_0] = arg_11_1.role2Data and arg_11_1.role2Data[iter_11_0] or arg_11_1[iter_11_0]
		end

		arg_11_0.aura[iter_11_0] = 1
	end

	arg_11_0.base = table.salttable(var_11_0)
	arg_11_0.base2 = table.salttable(var_11_1)

	arg_11_0:calcFinal()
end

function ObjectAttrs.correct(arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in pairs(var_0_0) do
		local var_12_0 = arg_12_1[iter_12_0 .. "C"]

		if var_12_0 ~= nil then
			arg_12_0.base[iter_12_0] = arg_12_0.base[iter_12_0] * var_12_0
			arg_12_0.base2[iter_12_0] = arg_12_0.base2[iter_12_0] * var_12_0
		end
	end

	arg_12_0:calcFinal()
end

function ObjectAttrs.calcFinal(arg_13_0)
	for iter_13_0, iter_13_1 in pairs(var_0_6) do
		iter_13_1(arg_13_0)
	end
end

function ObjectAttrs.updateMaxBaseAttr(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.base[arg_14_1] = math.max(arg_14_0.base[arg_14_1], arg_14_2)

	var_0_6[arg_14_1](arg_14_0)
end

function ObjectAttrs.setBaseAttr(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.base[arg_15_1] = arg_15_2

	var_0_6[arg_15_1](arg_15_0)
end

function ObjectAttrs.setBase2Attr(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.base2[arg_16_1] = arg_16_2
end

function ObjectAttrs.setBuffAttr(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0.buff[arg_17_1] = arg_17_2

	var_0_6[arg_17_1](arg_17_0)
end

function ObjectAttrs.addBaseAttr(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0.base[arg_18_1] = arg_18_2 + arg_18_0.base[arg_18_1]

	var_0_6[arg_18_1](arg_18_0)
end

function ObjectAttrs.addBase2Attr(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.base2[arg_19_1] = arg_19_2 + arg_19_0.base2[arg_19_1]
end

function ObjectAttrs.addBuffAttr(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.buff[arg_20_1] = arg_20_2 + arg_20_0.buff[arg_20_1]

	var_0_6[arg_20_1](arg_20_0)
end

function ObjectAttrs.addAuraAttr(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0.aura[arg_21_1] = arg_21_0.aura[arg_21_1] + arg_21_2
end

function ObjectAttrs.getFinalAttr(arg_22_0, arg_22_1)
	return arg_22_0.final[arg_22_1] * math.max(arg_22_0.aura[arg_22_1], 0)
end

function ObjectAttrs.getBase2FinalAttr(arg_23_0, arg_23_1)
	return var_0_6[arg_23_1](arg_23_0, true) * math.max(arg_23_0.aura[arg_23_1], 0)
end

function ObjectAttrs.getBase2RealFinalAttr(arg_24_0, arg_24_1)
	return var_0_6[arg_24_1](arg_24_0, true)
end

function ObjectAttrs.cloneFinalAttr(arg_25_0)
	local var_25_0 = {}

	for iter_25_0, iter_25_1 in pairs(var_0_0) do
		var_25_0[iter_25_0] = arg_25_0.buff[iter_25_0] + arg_25_0.base[iter_25_0]
	end

	return var_25_0
end
