local var_0_0 = unpack
local var_0_1 = require("3rd.msgpack").pack

globals.__TestEasy = {}

local var_0_2 = {
	specialDefence = 3000,
	level = 1,
	mp1Recover = 1,
	natureRestraint = 1,
	mp2 = 1,
	damageDeepen = 1,
	damage = 10000,
	hit = 10000,
	classify = 0,
	specialDefenceIgnore = 1,
	strikeResistance = 1,
	mp2Recover = 1,
	star = 5,
	rebound = 0,
	defence = 3000,
	controlPer = 0,
	hpRecover = 1,
	block = 1,
	strike = 1,
	speed = 14,
	hp = 100000,
	immuneGate = 1,
	fightPoint = 0,
	suckBlood = 0,
	breakBlock = 1,
	damageReduce = 1,
	defenceIgnore = 1,
	ultimateAdd = 0,
	ultimateSub = 0,
	dodge = 1,
	specialDamage = 10000,
	damageSub = 1,
	mp1 = 1000,
	damageAdd = 1,
	gatePer = 1,
	blockPower = 1,
	strikeDamage = 15000,
	cure = 1,
	skills = {},
	passive_skills = {}
}

function __TestEasy.addFuncListener(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1[arg_1_0] and __TestProtocol[arg_1_2] then
		local var_1_0 = __TestDefine.MonitorFunc[arg_1_2] or arg_1_1[arg_1_0]

		arg_1_1[arg_1_0] = function(...)
			if not __TestDefine.Monitor then
				return var_1_0(...)
			end

			local var_2_0 = {
				__func = var_1_0
			}

			__TestProtocol[arg_1_2](var_2_0, __TestDefine.CallState.enter, ...)

			local var_2_1 = {
				var_1_0(...)
			}

			__TestProtocol[arg_1_2](var_2_0, __TestDefine.CallState.exit, ({
				...
			})[1], var_0_0(var_2_1))
			__TestEasy.excuteCHProtocol(arg_1_2, var_2_0, var_2_1, ...)

			return var_0_0(var_2_1)
		end
		__TestDefine.MonitorFunc[arg_1_2] = var_1_0
	end
end

function __TestEasy.log(...)
	return
end

function __TestEasy.toObject(arg_4_0)
	return {
		hp = arg_4_0:hp(),
		hpMax = arg_4_0:hpMax(),
		mp = arg_4_0:mp1(),
		mpMax = arg_4_0:mp1Max(),
		name = arg_4_0.unitCfg.name,
		id = arg_4_0.id,
		seat = arg_4_0.seat,
		unitId = arg_4_0.unitID,
		skillTime = {}
	}
end

function __TestEasy.toBuff(arg_5_0)
	return {
		from = "",
		state = -1,
		cfgId = arg_5_0.cfgId,
		casterId = arg_5_0.caster and arg_5_0.caster.id or 999,
		holderId = arg_5_0.holder.id,
		lifeRound = arg_5_0.lifeRound,
		easyEffectFunc = arg_5_0.csvCfg.easyEffectFunc,
		value = arg_5_0.isNumberType and arg_5_0.buffValue or tostring(arg_5_0.buffValue)
	}
end

function __TestEasy.toValueType(arg_6_0)
	local var_6_0

	for iter_6_0, iter_6_1 in pairs(battle.ValueType) do
		local var_6_1 = tonumber(arg_6_0:get(iter_6_1))

		if var_6_0 then
			var_6_0 = var_6_0 .. "|" .. var_6_1
		else
			var_6_0 = var_6_1
		end
	end

	return var_6_0
end

function __TestEasy.pushCHProtocol(arg_7_0, arg_7_1)
	__TestDefine.chProtocol[arg_7_0].protocol = __TestDefine.chProtocol[arg_7_0].protocol or {}

	table.insert(__TestDefine.chProtocol[arg_7_0].protocol, arg_7_1)
end

function __TestEasy.clearCHProtocol(arg_8_0, arg_8_1)
	__TestDefine.chProtocol[arg_8_0].protocol = {}
end

local var_0_3 = {
	counter = function(arg_9_0)
		if not arg_9_0 then
			return 0
		end

		return arg_9_0 + 1
	end,
	sum = function(arg_10_0, arg_10_1)
		if not arg_10_0 then
			return 0
		end

		if type(arg_10_1) == "table" then
			return "val_sum_with_table"
		end

		return arg_10_0 + arg_10_1
	end,
	array = function(arg_11_0, arg_11_1)
		if not arg_11_0 then
			return {}
		end

		if type(arg_11_1) == "table" then
			table.insert(arg_11_0, dumps(arg_11_1))
		else
			table.insert(arg_11_0, arg_11_1)
		end

		return arg_11_0
	end
}

function __TestEasy.excuteCHProtocol(arg_12_0, ...)
	local var_12_0 = __TestDefine.chProtocol[arg_12_0]

	if var_12_0 and var_12_0.changeArgs then
		var_12_0.changeArgs(...)
	end

	if var_12_0 and var_12_0.protocol and table.length(var_12_0.protocol) > 0 then
		local var_12_1 = var_12_0.makeEnv(...)
		local var_12_2 = __TestDefine.historyBattleInfo.extraData or {}
		local var_12_3

		for iter_12_0, iter_12_1 in ipairs(var_12_0.protocol) do
			local var_12_4 = var_0_3[iter_12_1.type]
			local var_12_5 = var_12_2[iter_12_1.output[1]]

			if var_12_5 == nil then
				var_12_5 = var_12_4()
			end

			if eval.doFormula(iter_12_1.condition, var_12_1) then
				if iter_12_1.output[2] then
					var_12_5 = var_12_4(var_12_5, eval.doFormula(iter_12_1.output[2], var_12_1))
				else
					var_12_5 = var_12_4(var_12_5)
				end
			end

			var_12_2[iter_12_1.output[1]] = var_12_5
		end

		__TestDefine.historyBattleInfo.extraData = var_12_2
	end
end

function __TestEasy.gainBattleRecord(arg_13_0)
	local var_13_0
	local var_13_1 = game.GATE_TYPE.test

	if arg_13_0.sceneID >= 1000 then
		var_13_0 = require("app.views.city.test.gate.pve_gate")
		var_13_1 = csv.scene_conf[arg_13_0.sceneID].gateType
	elseif arg_13_0.sceneID == game.GATE_TYPE.crossArena then
		var_13_0 = require("app.views.city.test.gate.cross_arena_gate")
	else
		var_13_0 = require("app.views.city.test.gate.normal_gate")
	end

	local var_13_2 = {
		roleLevel = 1,
		gateFirst = true,
		moduleType = 1,
		sceneID = arg_13_0.sceneID,
		randSeed = math.random(1, 1000000),
		talents = {
			{},
			{}
		},
		fightgoVal = {
			0,
			0
		},
		gateType = var_13_1
	}

	arg_13_0.DefaultAttr = var_0_2

	local var_13_3, var_13_4 = var_13_0:getFightRoleData(arg_13_0)

	if #var_13_3 == 0 then
		return
	end

	var_13_2.gateType = var_13_4 or var_13_2.gateType
	var_13_2.roleOut = var_13_3[1]
	var_13_2.roleOut2 = var_13_3[1]

	return var_0_1(var_13_2)
end

return __TestEasy
