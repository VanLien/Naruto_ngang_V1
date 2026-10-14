__TestDefine.chProtocol = {
	["battlePlay.Gate/newWaveGoon"] = {
		makeEnv = function(arg_1_0, arg_1_1, arg_1_2, ...)
			return {
				play = arg_1_2,
				curWave = arg_1_2.curWave,
				scene = arg_1_2.scene
			}
		end
	},
	["BuffModel/init"] = {
		makeEnv = function(arg_2_0, arg_2_1, arg_2_2, ...)
			return {
				buffID = arg_2_2.cfgId,
				buffType = arg_2_2.csvCfg.easyEffectFunc,
				lifeRound = arg_2_2.lifeRound,
				casterSeat = arg_2_2.caster and arg_2_2.caster.seat or -1,
				holderSeat = arg_2_2.holder.seat,
				buff = arg_2_2
			}
		end,
		record = {
			["buff.doEffectValue"] = "buff生效的value值"
		},
		protocol = {}
	},
	["ObjectModel/beAttack"] = {
		makeEnv = function(arg_3_0, arg_3_1, arg_3_2, ...)
			local var_3_0 = {
				...
			}

			return {
				deader = arg_3_2.seat,
				killDamageFrom = arg_3_2.killDamageFrom or 0
			}
		end
	},
	["battlePlay.Gate/getObjectBaseSpeedRankSortKey"] = {
		changeArgs = function(arg_4_0, arg_4_1, arg_4_2, ...)
			arg_4_1[1] = math.random(999)
		end
	}
}
