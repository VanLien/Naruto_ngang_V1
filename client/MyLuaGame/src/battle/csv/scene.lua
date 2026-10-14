local var_0_0 = {
	getForceNum = 0
}
local var_0_1 = battleCsv.newCsvCls("CsvScene")

battleCsv.CsvScene = var_0_1

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	for iter_1_0, iter_1_1 in arg_1_0:getHerosMap(arg_1_1):order_pairs() do
		if not iter_1_1:isAlreadyDead() then
			arg_1_2(iter_1_1)
		end
	end
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in arg_2_0:getHerosMap(arg_2_1):order_pairs() do
		if not iter_2_1:isRealDeath() then
			arg_2_2(iter_2_1)
		end
	end
end

function var_0_1.getObjInAttackerArrayId(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.model.play.attackerArray
	local var_3_1 = arg_3_0.model.play.roundHasAttackedHistory
	local var_3_2 = 0
	local var_3_3 = arg_3_0.model:getObjectBySeat(arg_3_1)

	arg_3_2 = arg_3_2 or var_3_3.force

	for iter_3_0, iter_3_1 in ipairs(var_3_1) do
		if iter_3_1.id == var_3_3.id then
			return iter_3_0
		elseif iter_3_1.force == arg_3_2 then
			var_3_2 = var_3_2 + 1
		end
	end

	for iter_3_2, iter_3_3 in ipairs(var_3_0) do
		if iter_3_3.id == var_3_3.id and iter_3_3.force == arg_3_2 then
			return var_3_2 + iter_3_2
		end
	end
end

function var_0_1.getGateType(arg_4_0)
	return arg_4_0.model.gateType
end

function var_0_1.extraBattleRoundMode(arg_5_0)
	return arg_5_0.model:getExtraBattleRoundMode()
end

function var_0_1.countNatureTypeCount(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = 0
	local var_6_1 = {}
	local var_6_2 = arg_6_2 and 1 or nil
	local var_6_3 = arg_6_3 and 2 or nil

	local function var_6_4(arg_7_0, arg_7_1)
		if arg_7_0 then
			local var_7_0 = arg_7_1:getNatureType(arg_7_0)

			if var_7_0 and not var_6_1[var_7_0] then
				var_6_1[var_7_0] = true
				var_6_0 = var_6_0 + 1
			end
		end
	end

	var_0_2(arg_6_0.model, arg_6_1, function(arg_8_0)
		var_6_4(var_6_2, arg_8_0)
		var_6_4(var_6_3, arg_8_0)
	end)

	return var_6_0
end

function var_0_1.countObjByBuff(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = {}
	local var_9_1 = {}

	if arg_9_2 then
		if type(arg_9_2) ~= "table" then
			var_9_0[arg_9_2] = true
		else
			var_9_0 = arraytools.hash(arg_9_2)
		end
	end

	if arg_9_3 then
		if type(arg_9_3) ~= "table" then
			var_9_1[arg_9_3] = true
		else
			var_9_1 = arraytools.hash(arg_9_3)
		end
	end

	local var_9_2 = 0

	var_0_2(arg_9_0.model, arg_9_1, function(arg_10_0)
		if itertools.include(arg_10_0:iterBuffs(), function(arg_11_0)
			return var_9_0[arg_11_0.cfgId] or var_9_1[arg_11_0:group()]
		end) then
			var_9_2 = var_9_2 + 1
		end
	end)

	return var_9_2
end

function var_0_1.countObjByNature(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = 0

	var_0_2(arg_12_0.model, arg_12_1, function(arg_13_0)
		if arg_13_0:getNatureType(arg_12_2 or 1) == arg_12_3 then
			var_12_0 = var_12_0 + 1
		end
	end)

	return var_12_0
end

function var_0_1.countObjByNatureExit(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = 0

	var_0_2(arg_14_0.model, arg_14_1, function(arg_15_0)
		if arg_15_0:getNatureType(1) == arg_14_2 or arg_15_0:getNatureType(2) == arg_14_2 then
			var_14_0 = var_14_0 + 1
		end
	end)

	return var_14_0
end

function var_0_1.countForceNum(arg_16_0, arg_16_1)
	return arg_16_0.model:getForceNum(arg_16_1)
end

function var_0_1.countForceFilterNum(arg_17_0, arg_17_1, arg_17_2, ...)
	local var_17_0 = arg_17_0.model:getFilterObjects(arg_17_1, arg_17_2 and {
		fromObj = arg_17_2.model
	}, ...)

	return table.length(var_17_0)
end

function var_0_1.getMaxNatureInForce(arg_18_0, arg_18_1)
	local var_18_0 = {
		nature = -1,
		count = 0
	}
	local var_18_1 = {}

	var_0_2(arg_18_0.model, arg_18_1, function(arg_19_0)
		local var_19_0 = arg_19_0:getNatureType(1)

		var_18_1[var_19_0] = var_18_1[var_19_0] or 0
		var_18_1[var_19_0] = var_18_1[var_19_0] + 1

		if var_18_1[var_19_0] > var_18_0.count or var_18_1[var_19_0] == var_18_0.count and var_19_0 > var_18_0.nature then
			var_18_0.count = var_18_1[var_19_0]
			var_18_0.nature = var_19_0
		end
	end)

	return var_18_0.nature
end

function var_0_1.countObjByFlag(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = 0

	var_0_2(arg_20_0.model, arg_20_1, function(arg_21_0)
		if arg_21_0.battleFlag[arg_20_2] then
			var_20_0 = var_20_0 + 1
		end
	end)

	return var_20_0
end

function var_0_1.sumBuffOverlayByGroupInForce(arg_22_0, arg_22_1, ...)
	local var_22_0 = 0
	local var_22_1 = {
		...
	}

	var_0_2(arg_22_0.model, arg_22_1, function(arg_23_0)
		for iter_23_0, iter_23_1 in ipairs(var_22_1) do
			var_22_0 = var_22_0 + arg_23_0:getBuffGroupArgSum("overlayCount", iter_23_1)
		end
	end)

	return var_22_0
end

function var_0_1.countHPSumByForce(arg_24_0, arg_24_1)
	local var_24_0 = 0

	var_0_2(arg_24_0.model, arg_24_1, function(arg_25_0)
		var_24_0 = var_24_0 + arg_25_0:hp()
	end)

	return var_24_0
end

function var_0_1.countHPMaxSumByForce(arg_26_0, arg_26_1)
	local var_26_0 = 0

	var_0_2(arg_26_0.model, arg_26_1, function(arg_27_0)
		var_26_0 = var_26_0 + arg_27_0:hpMax()
	end)

	return var_26_0
end

function var_0_1.getNowRound(arg_28_0)
	return arg_28_0.model.play.curRound
end

function var_0_1.getNowBattleRound(arg_29_0)
	return arg_29_0.model.play.curBattleRound
end

function var_0_1.specialObjExit(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_0.model.forceRecordObject[arg_30_1] then
		local var_30_0 = arg_30_0.model.forceRecordObject[arg_30_1][arg_30_2]

		if var_30_0 and not var_30_0:isDeath() then
			return true
		end
	end

	return false
end

local var_0_4 = {
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
local var_0_5 = {
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
local var_0_6 = {
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

function var_0_1.getObjNearCount(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1.model
	local var_31_1 = arg_31_0.model:getHerosMap(var_31_0.force)
	local var_31_2 = var_31_0.force == 1 and var_0_4.left or var_0_4.right
	local var_31_3 = var_31_0.force == 1 and var_0_5.left or var_0_5.right
	local var_31_4 = var_31_2[var_31_0.seat]
	local var_31_5 = {}

	for iter_31_0, iter_31_1 in ipairs(var_0_6) do
		local var_31_6 = iter_31_1[1] + var_31_4.x
		local var_31_7 = iter_31_1[2] + var_31_4.y

		if var_31_6 > 0 and var_31_6 <= 2 and var_31_7 > 0 and var_31_7 <= 3 then
			var_31_5[var_31_3[var_31_6][var_31_7]] = true
		end
	end

	local var_31_8 = 0

	var_0_2(arg_31_0.model, var_31_0.force, function(arg_32_0)
		if var_31_5[arg_32_0.seat] then
			var_31_8 = var_31_8 + 1
		end
	end)

	return var_31_8
end

function var_0_1.getNatureCount(arg_33_0, arg_33_1, ...)
	local var_33_0 = {
		...
	}
	local var_33_1 = {}
	local var_33_2 = 0

	var_0_3(arg_33_0.model, arg_33_1, function(arg_34_0)
		local var_34_0

		for iter_34_0, iter_34_1 in ipairs(var_33_0) do
			if iter_34_1 then
				local var_34_1 = arg_34_0:getNatureType(iter_34_0)

				if not var_33_1[var_34_1] then
					var_33_2 = var_33_2 + 1
					var_33_1[var_34_1] = true
				end
			end
		end
	end)

	return var_33_2
end

function var_0_1.getSpellCountBySeatAndType(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.model:getObjectBySeat(arg_35_1)
	local var_35_1 = var_35_0 and var_35_0.id

	return arg_35_0.model.extraRecord:getEventByKey(arg_35_2, var_35_1) or 0
end

function var_0_1.excutePlayCsv(arg_36_0, arg_36_1, ...)
	local var_36_0 = arg_36_0.model.play:excutePlayCsv(arg_36_1)

	if not var_36_0 then
		return
	end

	return var_36_0(...)
end

function var_0_1.getNowRoundInfo(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.model.play.curHeroRoundInfo

	return var_37_0 and var_37_0[arg_37_1]
end

function var_0_1.getEnemyForce(arg_38_0, arg_38_1)
	return arg_38_1:force() == 1 and 2 or 1
end

function var_0_1.getExtraRoundMode(arg_39_0)
	return arg_39_0.model.extraRoundMode or 0
end

function var_0_1.countObjBy(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = {
		front = function(arg_41_0)
			return arg_41_0.seat >= 1 and arg_41_0.seat <= 3 or arg_41_0.seat >= 7 and arg_41_0.seat <= 9
		end,
		back = function(arg_42_0)
			return arg_42_0.seat >= 4 and arg_42_0.seat <= 6 or arg_42_0.seat >= 10 and arg_42_0.seat <= 12
		end,
		excludeRealDead = function(arg_43_0)
			return not arg_43_0:isRealDeath()
		end,
		filterLevevl1 = function(arg_44_0)
			if arg_40_0.model:getFilterObject(arg_44_0.id, {
				fromObj = arg_40_2 and arg_40_2.model
			}, battle.FilterObjectType.excludeObjLevel1) then
				return true
			end

			return false
		end
	}
	local var_40_1 = {
		allWithBuff = function(arg_45_0, arg_45_1)
			return itertools.include(arg_45_0:iterBuffs(), function(arg_46_0)
				return arg_46_0.cfgId == arg_45_1[2]
			end) and 1 or "returnZero"
		end
	}
	local var_40_2 = 0

	for iter_40_0, iter_40_1 in arg_40_0.model:getHerosMap(arg_40_1):order_pairs() do
		local var_40_3 = true

		for iter_40_2, iter_40_3 in ipairs(arg_40_3) do
			var_40_3 = var_40_3 and var_40_0[iter_40_3](iter_40_1)
		end

		var_40_3 = (var_40_0.excludeRealDead or not iter_40_1:isAlreadyDead()) and var_40_3

		if var_40_3 then
			local var_40_4 = var_40_1[arg_40_4[1]] and var_40_1[arg_40_4[1]](iter_40_1, arg_40_4) or 1

			if var_40_4 == "returnZero" then
				return 0
			elseif var_40_4 == "return" then
				return var_40_2
			else
				var_40_2 = var_40_2 + var_40_4
			end
		end
	end

	return var_40_2
end

local var_0_7 = {
	function(arg_47_0, arg_47_1, arg_47_2)
		arg_47_1 = arg_47_1 or arg_47_2 - 1

		if arg_47_1 < arg_47_2 then
			return true
		end

		return false
	end,
	function(arg_48_0, arg_48_1, arg_48_2)
		arg_48_1 = arg_48_1 or arg_48_2 + 1

		if arg_48_2 < arg_48_1 then
			return true
		end

		return false
	end
}

local function var_0_8(arg_49_0, arg_49_1)
	return function(arg_50_0, arg_50_1, ...)
		local var_50_0
		local var_50_1 = {}

		for iter_50_0, iter_50_1 in ipairs({
			...
		}) do
			var_50_1[table.length(var_50_1) + 1] = var_0_7[iter_50_1]
		end

		for iter_50_2, iter_50_3 in arg_50_0.model:getHerosMap(arg_50_1):order_pairs() do
			local var_50_2 = iter_50_3.attrs[arg_49_1][arg_49_0]

			for iter_50_4, iter_50_5 in ipairs(var_50_1) do
				if not iter_50_5(iter_50_3, var_50_0, var_50_2) then
					break
				end

				if iter_50_4 == table.length(var_50_1) then
					var_50_0 = var_50_2
				end
			end
		end

		return var_50_0
	end
end

for iter_0_0, iter_0_1 in pairs(ObjectAttrs.AttrsTable) do
	var_0_1["getB" .. iter_0_0] = var_0_8(iter_0_0, "base")
	var_0_1["getA" .. iter_0_0] = var_0_8(iter_0_0, "buff")
	var_0_1["get" .. iter_0_0] = var_0_8(iter_0_0, "final")
end

battleCsv.exportToCsvCls(var_0_1, var_0_0)
