require("battle.models.scene")
require("app.views.city.test.test_ch_protocol")

local var_0_0 = __TestDefine.historyBattleInfo
local var_0_1 = true
local var_0_2 = {
	["battlePlay.Gate"] = {
		newWaveGoon = var_0_1,
		onBattleEndSupply = var_0_1,
		onWaveEndSupply = var_0_1,
		addCardRole = var_0_1,
		onNewRound = var_0_1,
		getObjectBaseSpeedRankSortKey = var_0_1
	},
	ObjectModel = {
		beAttack = var_0_1,
		processRealDeath = var_0_1,
		toAttack = var_0_1,
		setDead = var_0_1
	},
	BuffModel = {
		init = var_0_1,
		over = var_0_1,
		doEffect = var_0_1
	},
	["battleSkill.SkillModel"] = {
		spellTo = var_0_1
	},
	_Globals = {
		addBuffToHero = var_0_1
	},
	ymrand = {
		random = var_0_1,
		randomseed = var_0_1
	}
}

globals.__TestProtocol = {}
__TestProtocol["battlePlay.Gate/newWaveGoon"] = function(arg_1_0, arg_1_1, arg_1_2, ...)
	local var_1_0 = {
		...
	}

	if arg_1_1 == __TestDefine.CallState.enter then
		if arg_1_2.curWave == 1 then
			__TestDefine.historyBattleInfo = {}
			var_0_0 = __TestDefine.historyBattleInfo
		end

		var_0_0[arg_1_2.curWave] = {}

		for iter_1_0 = 1, 12 do
			local var_1_1 = arg_1_2.scene:getObjectBySeatExcludeDead(iter_1_0)

			if var_1_1 then
				var_0_0[arg_1_2.curWave][iter_1_0] = __TestEasy.toObject(var_1_1)
				var_0_0[arg_1_2.curWave][iter_1_0].totalDamage = var_1_1.totalDamage
				var_0_0[arg_1_2.curWave][iter_1_0].totalResumeHp = var_1_1.totalResumeHp
				var_0_0[arg_1_2.curWave][iter_1_0].totalTakeDamage = var_1_1.totalTakeDamage
			end
		end
	elseif arg_1_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["battlePlay.Gate/onNewRound"] = function(arg_2_0, arg_2_1, arg_2_2, ...)
	local var_2_0 = {
		...
	}

	if arg_2_1 == __TestDefine.CallState.enter then
		__TestEasy.log("[GATE ROUND] round=%s totalRound=%s", arg_2_2.curRound, arg_2_2.totalRound)
	elseif arg_2_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["battlePlay.Gate/onBattleEndSupply"] = function(arg_3_0, arg_3_1, arg_3_2, ...)
	local var_3_0 = {
		...
	}

	if arg_3_1 == __TestDefine.CallState.enter then
		local var_3_1 = {}
		local var_3_2
		local var_3_3

		for iter_3_0 = 1, 12 do
			if var_0_0[arg_3_2.curWave][iter_3_0] then
				local var_3_4 = clone(var_0_0[arg_3_2.curWave][iter_3_0])
				local var_3_5 = battleEasy.valueTypeTable()

				for iter_3_1, iter_3_2 in pairs(battle.DamageFrom) do
					var_3_5:add(var_0_0[arg_3_2.curWave][iter_3_0].totalDamage[iter_3_2])
				end

				var_3_4._totalDamage = clone(var_3_5)

				local var_3_6 = battleEasy.valueTypeTable()

				for iter_3_3, iter_3_4 in pairs(battle.ResumeHpFrom) do
					var_3_6:add(var_0_0[arg_3_2.curWave][iter_3_0].totalResumeHp[iter_3_4])
				end

				var_3_6:add(var_3_4.resumeSpecialHp or 0)

				var_3_4._totalResumeHp = clone(var_3_6)
				var_3_4.totalRound = arg_3_2.curRound
				var_0_0[arg_3_2.curWave][iter_3_0] = var_3_4
			end
		end
	elseif arg_3_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["battlePlay.Gate/onWaveEndSupply"] = function(arg_4_0, arg_4_1, arg_4_2, ...)
	local var_4_0 = {
		...
	}

	if arg_4_1 == __TestDefine.CallState.enter then
		-- block empty
	elseif arg_4_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["battlePlay.Gate/getObjectBaseSpeedRankSortKey"] = function(arg_5_0, arg_5_1, arg_5_2, ...)
	local var_5_0 = {
		...
	}

	if arg_5_1 == __TestDefine.CallState.enter then
		-- block empty
	elseif arg_5_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["battlePlay.Gate/addCardRole"] = function(arg_6_0, arg_6_1, arg_6_2, ...)
	local var_6_0 = {
		...
	}

	if arg_6_1 == __TestDefine.CallState.enter then
		-- block empty
	elseif arg_6_1 == __TestDefine.CallState.exit then
		local var_6_1 = var_6_0[1]

		if var_6_1 and var_6_1.type == battle.ObjectType.Normal then
			local var_6_2 = var_6_1.seat

			var_0_0[arg_6_2.curWave][var_6_2] = __TestEasy.toObject(var_6_1)
			var_0_0[arg_6_2.curWave][var_6_2].totalDamage = var_6_1.totalDamage
			var_0_0[arg_6_2.curWave][var_6_2].totalResumeHp = var_6_1.totalResumeHp
			var_0_0[arg_6_2.curWave][var_6_2].totalTakeDamage = var_6_1.totalTakeDamage
		end
	end
end
__TestProtocol["ObjectModel/processRealDeath"] = function(arg_7_0, arg_7_1, arg_7_2, ...)
	local var_7_0 = {
		...
	}

	if arg_7_1 == __TestDefine.CallState.enter then
		local var_7_1 = var_0_0[arg_7_2.scene.play.curWave]
		local var_7_2 = var_7_1[arg_7_2.id]

		__TestEasy.log("[OBJECT DEAD] self.id=%s attacker.id=%s", arg_7_2.seat, arg_7_2.attackMeDeadObj and arg_7_2.attackMeDeadObj.seat)

		if arg_7_2.attackMeDeadObj then
			local var_7_3 = var_7_1[arg_7_2.attackMeDeadObj.seat]

			var_7_3.kill = var_7_3.kill or 0
			var_7_3.kill = var_7_3.kill + 1
		end
	elseif arg_7_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["ObjectModel/beAttack"] = function(arg_8_0, arg_8_1, arg_8_2, ...)
	local var_8_0 = {
		...
	}

	if arg_8_1 == __TestDefine.CallState.enter then
		local var_8_1 = var_8_0[1]
		local var_8_2 = var_8_0[4]

		arg_8_0.objState = arg_8_2:isDeath()

		if var_8_1 and var_8_2.from == battle.DamageFrom.skill then
			local var_8_3 = var_0_0[arg_8_2.scene.play.curWave][arg_8_2.seat]

			var_8_3.beAttack = var_8_3.beAttack or 0
			var_8_3.beAttackStrike = var_8_3.beAttackStrike or 0
			var_8_3.beAttackBlock = var_8_3.beAttackBlock or 0
			var_8_3.beAttack = var_8_3.beAttack + 1

			if var_8_2.strike then
				var_8_3.beAttackStrike = var_8_3.beAttackStrike + 1
			elseif var_8_2.block then
				var_8_3.beAttackBlock = var_8_3.beAttackBlock + 1
			end
		end
	elseif arg_8_1 == __TestDefine.CallState.exit then
		local var_8_4 = arg_8_2.curAttackMeObj

		if var_8_4 then
			local var_8_5 = var_0_0[arg_8_2.scene.play.curWave]
			local var_8_6 = var_8_5[var_8_4.seat]
			local var_8_7 = var_8_0[1]:get(battle.ValueType.normal)

			if var_8_4.type ~= battle.ObjectType.Normal then
				var_8_5[var_8_4.seat].extraHerosDamage = var_8_5[var_8_4.seat].extraHerosDamage or 0
				var_8_5[var_8_4.seat].extraHerosDamage = var_8_5[var_8_4.seat].extraHerosDamage + var_8_7

				return
			end

			if var_8_6 then
				var_8_6.onceMaxDamage = var_8_6.onceMaxDamage or 0
				var_8_6.onceMaxDamage = math.max(var_8_7, var_8_6.onceMaxDamage)
				var_8_6.totalDamage[battle.DamageFromExtra.allocate] = var_8_6.totalDamage[battle.DamageFromExtra.allocate] or battleEasy.valueTypeTable()
				var_8_6.totalDamage[battle.DamageFromExtra.link] = var_8_6.totalDamage[battle.DamageFromExtra.link] or battleEasy.valueTypeTable()

				var_8_6.totalDamage[battle.DamageFromExtra.allocate]:add(var_8_0[2].fromExtra and var_8_0[2].fromExtra[battle.DamageFromExtra.allocate] and var_8_0[1]:get(battle.ValueType.normal) or 0)
				var_8_6.totalDamage[battle.DamageFromExtra.link]:add(var_8_0[2].fromExtra and var_8_0[2].fromExtra[battle.DamageFromExtra.link] and var_8_0[1]:get(battle.ValueType.normal) or 0)
			end
		end

		if arg_8_2:isDeath() ~= arg_8_0.objState and not arg_8_2.killDamageFrom then
			arg_8_2.killDamageFrom = var_8_0[2].from
		end
	end
end
__TestProtocol["ObjectModel/toAttack"] = function(arg_9_0, arg_9_1, arg_9_2, ...)
	local var_9_0 = {
		...
	}

	if arg_9_1 == __TestDefine.CallState.enter then
		-- block empty
	elseif arg_9_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["BuffModel/over"] = function(arg_10_0, arg_10_1, arg_10_2, ...)
	local var_10_0 = {
		...
	}

	if arg_10_1 == __TestDefine.CallState.enter then
		local var_10_1 = debug.getinfo(3)
		local var_10_2 = string.format("%s [Line:%s]", var_10_1.source, var_10_1.currentline)
		local var_10_3 = debug.getinfo(4)
		local var_10_4 = string.format("%s [Line:%s]", var_10_3.source, var_10_3.currentline)

		__TestEasy.log("[BUFF OVER] id=%s cfgId=%s holder=%s \n\toverFrom1=%s\n\toverFrom2=%s", arg_10_2.id, arg_10_2.cfgId, arg_10_2.holder.seat, var_10_2, var_10_4)
	elseif arg_10_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["BuffModel/init"] = function(arg_11_0, arg_11_1, arg_11_2, ...)
	local var_11_0 = {
		...
	}

	if arg_11_1 == __TestDefine.CallState.enter then
		__TestEasy.log("[BUFF INIT] id=%s cfgId=%s buffType=%s lifeRound=%s caster=%s holder=%s", arg_11_2.id, arg_11_2.cfgId, arg_11_2.csvCfg.easyEffectFunc, arg_11_2.lifeRound, arg_11_2.caster and arg_11_2.caster.seat, arg_11_2.holder.seat)
	elseif arg_11_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["BuffModel/doEffect"] = function(arg_12_0, arg_12_1, arg_12_2, ...)
	local var_12_0 = {
		...
	}

	if arg_12_1 == __TestDefine.CallState.enter then
		__TestEasy.log("[BUFF DOEFFECT] id=%s cfgId=%s buffType=%s isOver=%s", arg_12_2.id, arg_12_2.cfgId, var_12_0[1] or "nil", var_12_0[3] or "nil")

		if itertools.include(__TestDefine.buffId, tostring(arg_12_2.cfgId)) then
			local var_12_1 = var_0_0[arg_12_2.scene.play.curWave][arg_12_2.holder.seat]

			var_12_1.buffTakeEffect = var_12_1.buffTakeEffect or {}
			var_12_1.buffTakeEffect[arg_12_2.cfgId] = var_12_1.buffTakeEffect[arg_12_2.cfgId] or 0
			var_12_1.buffTakeEffect[arg_12_2.cfgId] = var_12_1.buffTakeEffect[arg_12_2.cfgId] + 1
		end

		if var_12_0[1] == "setHpPer" then
			local var_12_2 = var_0_0[arg_12_2.scene.play.curWave][arg_12_2.caster.seat]
			local var_12_3 = arg_12_2.holder:hpMax() * var_12_0[2] - arg_12_2.holder:hp()

			var_12_2.resumeSpecialHp = var_12_2.resumeSpecialHp or 0
			var_12_2.resumeSpecialHp = math.ceil(var_12_2.resumeSpecialHp + var_12_3)
		end
	elseif arg_12_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["battleSkill.SkillModel/spellTo"] = function(arg_13_0, arg_13_1, arg_13_2, ...)
	local var_13_0 = {
		...
	}

	if arg_13_1 == __TestDefine.CallState.enter then
		local var_13_1 = arg_13_2.owner
		local var_13_2 = var_13_1.scene.play
		local var_13_3 = var_0_0[var_13_2.curWave][var_13_1.seat]

		if arg_13_2.cfg.skillType2 == battle.MainSkillType.BigSkill and not var_13_3.firstBigSkillRound then
			var_13_3.firstBigSkillRound = var_13_2.totalRound
		end

		local var_13_4 = arg_13_2.cfg.skillType2

		if not var_13_3.skillTime[var_13_4] then
			var_13_3.skillTime[var_13_4] = 0
		end

		var_13_3.skillTime[var_13_4] = var_13_3.skillTime[var_13_4] + 1
	elseif arg_13_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["ObjectModel/setDead"] = function(arg_14_0, arg_14_1, arg_14_2, ...)
	local var_14_0 = {
		...
	}

	if arg_14_1 == __TestDefine.CallState.enter then
		local var_14_1 = arg_14_2.scene.play
		local var_14_2 = var_14_0[1].seat
		local var_14_3 = var_0_0[var_14_1.curWave][var_14_2]

		if not var_14_3.firstKill then
			var_14_3.firstKill = var_14_1.totalRound
		end
	elseif arg_14_1 == __TestDefine.CallState.exit and arg_14_2.state == battle.ObjectState.realDead then
		local var_14_4 = arg_14_2.scene.play

		var_0_0[var_14_4.curWave][arg_14_2.seat].deadBigRound = var_14_4.totalRound
	end
end
__TestProtocol["ymrand/random"] = function(arg_15_0, arg_15_1, arg_15_2, ...)
	local var_15_0 = {
		...
	}

	if arg_15_1 == __TestDefine.CallState.enter then
		-- block empty
	elseif arg_15_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end
__TestProtocol["ymrand/randomseed"] = function(arg_16_0, arg_16_1, arg_16_2, ...)
	if arg_16_1 == __TestDefine.CallState.exit then
		local var_16_0 = arg_16_2

		arg_16_0.__func(var_16_0)
		__TestEasy.log("\n\n\t\t__battle_protocol start - seed=%s\n\n", var_16_0)
	end
end
__TestProtocol["_Globals/addBuffToHero"] = function(arg_17_0, arg_17_1, arg_17_2, ...)
	local var_17_0 = {
		...
	}

	if arg_17_1 == __TestDefine.CallState.enter then
		__TestEasy.log("[BUFF ADDCHECK] cfgId=%s holderId=%s casterId=%s", arg_17_2 or "nil", var_17_0[1] and var_17_0[1].seat or "nil", var_17_0[2] and var_17_0[2].seat or "nil")
	elseif arg_17_1 == __TestDefine.CallState.exit then
		-- block empty
	end
end

local function var_0_3(arg_18_0)
	if arg_18_0 == "_Globals" then
		return _G
	end

	local var_18_0 = string.split(arg_18_0, ".")
	local var_18_1 = _G

	for iter_18_0 = 1, #var_18_0 do
		if iter_18_0 == #var_18_0 then
			return var_18_1[var_18_0[iter_18_0]]
		end

		var_18_1 = var_18_1[var_18_0[iter_18_0]]
	end
end

;(function()
	for iter_19_0, iter_19_1 in pairs(var_0_2) do
		local var_19_0 = var_0_3(iter_19_0)

		if var_19_0 then
			for iter_19_2, iter_19_3 in pairs(iter_19_1) do
				if iter_19_3 then
					__TestEasy.addFuncListener(iter_19_2, var_19_0, iter_19_0 .. "/" .. iter_19_2)
				end
			end
		end
	end
end)()

return __TestProtocol
