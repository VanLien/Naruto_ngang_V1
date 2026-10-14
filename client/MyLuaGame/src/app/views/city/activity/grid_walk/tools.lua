local var_0_0 = {}
local var_0_1 = 322
local var_0_2 = 380

var_0_0.MOVE_TIME = 0.6
var_0_0.HISTORY_MAX = 6
var_0_0.BADGE_ID = 8102
var_0_0.MAP = {
	{
		1,
		9
	},
	{
		2,
		9
	},
	{
		3,
		9
	},
	{
		4,
		9
	},
	{
		4,
		10
	},
	{
		4,
		11
	},
	{
		5,
		11
	},
	{
		6,
		11
	},
	{
		7,
		11
	},
	{
		8,
		11
	},
	{
		9,
		11
	},
	{
		10,
		11
	},
	{
		11,
		11
	},
	{
		12,
		11
	},
	{
		12,
		10
	},
	{
		12,
		9
	},
	{
		12,
		8
	},
	{
		11,
		8
	},
	{
		10,
		8
	},
	{
		9,
		8
	},
	{
		9,
		7
	},
	{
		9,
		6
	},
	{
		9,
		5
	},
	{
		10,
		5
	},
	{
		11,
		5
	},
	{
		12,
		5
	},
	{
		12,
		4
	},
	{
		12,
		3
	},
	{
		12,
		2
	},
	{
		11,
		2
	},
	{
		10,
		2
	},
	{
		9,
		2
	},
	{
		9,
		1
	},
	{
		8,
		1
	},
	{
		7,
		1
	},
	{
		6,
		1
	},
	{
		5,
		1
	},
	{
		4,
		1
	},
	{
		3,
		1
	},
	{
		2,
		1
	},
	{
		1,
		1
	},
	{
		1,
		2
	},
	{
		1,
		3
	},
	{
		2,
		3
	},
	{
		3,
		3
	},
	{
		4,
		3
	},
	{
		4,
		4
	},
	{
		4,
		5
	},
	{
		3,
		5
	},
	{
		2,
		5
	},
	{
		1,
		5
	},
	{
		1,
		6
	},
	{
		1,
		7
	},
	{
		1,
		8
	}
}
var_0_0.EVENTS = {
	reduce = 4,
	shop = 6,
	jump = 5,
	increase = 3,
	goodLuck = 1,
	treasures = 99,
	badLuck = 2
}
var_0_0.ITEMS = {
	medalDice = 8114,
	randomCard = 8116,
	normanlDice = 8112,
	strangeDice = 8113,
	steeringCard = 8117,
	voucher = 8111,
	sprintCard = 8115
}
var_0_0.DICE_ID = {
	var_0_0.ITEMS.normanlDice,
	var_0_0.ITEMS.strangeDice,
	var_0_0.ITEMS.medalDice
}
var_0_0.CARD_ID = {
	var_0_0.ITEMS.sprintCard,
	var_0_0.ITEMS.randomCard,
	var_0_0.ITEMS.steeringCard
}
var_0_0.CARDSBAG_ID = {
	var_0_0.ITEMS.sprintCard,
	var_0_0.ITEMS.randomCard,
	var_0_0.ITEMS.steeringCard,
	var_0_0.ITEMS.voucher
}

function var_0_0.getCfgByIndexFromMap(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in csvPairs(csv.yunying.grid_walk_map) do
		if arg_1_0 == iter_1_1.index and arg_1_1 == iter_1_1.huodongID then
			return iter_1_1, iter_1_0
		end
	end
end

function var_0_0.getCfgByEventFromEvents(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in csvPairs(csv.yunying.grid_walk_events) do
		if arg_2_0 == iter_2_1.type and arg_2_1 == iter_2_1.huodongID then
			return iter_2_1, iter_2_0
		end
	end
end

function var_0_0.getMapPos(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in ipairs(var_0_0.MAP) do
		local var_3_1 = var_0_2 + iter_3_1[1] * arg_3_0.width - arg_3_0.width / 2
		local var_3_2 = var_0_1 + iter_3_1[2] * arg_3_0.height - arg_3_0.height / 2

		table.insert(var_3_0, {
			var_3_1,
			var_3_2
		})
	end

	return var_3_0
end

function var_0_0.getNextTowardsUp(arg_4_0, arg_4_1)
	local var_4_0 = var_0_0.MAP[arg_4_0]
	local var_4_1 = arg_4_0 + 1 > 54 and arg_4_0 + 1 - 54 or arg_4_0 + 1

	if arg_4_1 == -1 then
		var_4_1 = arg_4_0 - 1 < 1 and arg_4_0 - 1 + 54 or arg_4_0 - 1
	end

	local var_4_2 = var_0_0.MAP[var_4_1]

	return {
		var_4_2[1] - var_4_0[1],
		var_4_2[2] - var_4_0[2]
	}
end

function var_0_0.getTowardsUp(arg_5_0, arg_5_1)
	local var_5_0 = var_0_0.MAP[arg_5_0]

	if arg_5_1 == 1 then
		for iter_5_0 = arg_5_0 + 1, math.huge do
			local var_5_1 = iter_5_0 > 54 and iter_5_0 - 54 or iter_5_0
			local var_5_2 = var_0_0.MAP[var_5_1]

			if var_5_0[1] ~= var_5_2[1] then
				return var_5_2[1] > var_5_0[1] and 1 or -1
			end
		end
	else
		for iter_5_1 = arg_5_0 - 1, -54, -1 do
			local var_5_3 = iter_5_1 < 1 and iter_5_1 + 54 or iter_5_1
			local var_5_4 = var_0_0.MAP[var_5_3]

			if var_5_0[1] ~= var_5_4[1] then
				return var_5_4[1] > var_5_0[1] and 1 or -1
			end
		end
	end
end

function var_0_0.getOutPosByIndex(arg_6_0)
	local var_6_0 = var_0_0.MAP[arg_6_0]
	local var_6_1 = arg_6_0 - 1 < 1 and 54 or arg_6_0 - 1
	local var_6_2 = var_0_0.MAP[var_6_1]
	local var_6_3 = arg_6_0 + 1 > 54 and 1 or arg_6_0 + 1
	local var_6_4 = var_0_0.MAP[var_6_3]

	if var_6_0[1] == var_6_2[1] and var_6_0[1] == var_6_4[1] then
		if var_6_0[1] > 6 then
			return {
				-1,
				0
			}
		else
			return {
				1,
				0
			}
		end
	elseif var_6_0[2] == var_6_2[2] and var_6_0[2] == var_6_4[2] then
		return {
			0,
			1
		}
	elseif var_6_2[2] > var_6_0[2] or var_6_4[2] > var_6_0[2] then
		return {
			0,
			-1
		}
	elseif var_6_2[2] < var_6_0[2] or var_6_4[2] < var_6_0[2] then
		return {
			0,
			1
		}
	elseif var_6_2[1] > var_6_0[1] or var_6_4[1] > var_6_0[1] then
		return {
			-1,
			0
		}
	elseif var_6_2[1] < var_6_0[1] or var_6_4[1] < var_6_0[1] then
		return {
			1,
			0
		}
	end
end

function var_0_0.getLabelFromEvent(arg_7_0, arg_7_1)
	local var_7_0 = ""
	local var_7_1 = arg_7_0.csv_id

	if var_7_1 == 0 then
		return gLanguageCsv.gridWalkHistory0
	elseif arg_7_0.is_event then
		local var_7_2 = csv.yunying.grid_walk_events[var_7_1]
		local var_7_3 = var_7_2.params

		if var_7_2.type == var_0_0.EVENTS.goodLuck then
			local var_7_4 = var_7_3.items[arg_7_0.params.outcome + 1]
			local var_7_5 = dataEasy.getCfgByKey(var_7_4[1])

			return string.format(gLanguageCsv.gridWalkHistory1, var_7_5.name, var_7_4[2])
		elseif var_7_2.type == var_0_0.EVENTS.badLuck then
			local var_7_6 = var_7_3.items[arg_7_0.params.outcome + 1]
			local var_7_7 = dataEasy.getCfgByKey(var_7_6[1])

			return string.format(gLanguageCsv.gridWalkHistory2, var_7_6[2], var_7_7.name)
		elseif var_7_2.type == var_0_0.EVENTS.increase then
			return string.format(gLanguageCsv.gridWalkHistory3, var_7_3.num, var_7_3.num)
		elseif var_7_2.type == var_0_0.EVENTS.reduce then
			return string.format(gLanguageCsv.gridWalkHistory4, var_7_3.num, var_7_3.num)
		elseif var_7_2.type == var_0_0.EVENTS.jump then
			return string.format(gLanguageCsv.gridWalkHistory5, var_7_3.num)
		elseif var_7_2.type == var_0_0.EVENTS.shop then
			if arg_7_0.params.bought and arg_7_0.params.bought > 0 then
				return gLanguageCsv.gridWalkHistory61
			else
				return gLanguageCsv.gridWalkHistory62
			end
		elseif var_7_2.type == var_0_0.EVENTS.treasures then
			return gLanguageCsv.gridWalkHistory99
		end
	elseif var_7_1 == var_0_0.ITEMS.normanlDice or var_7_1 == var_0_0.ITEMS.strangeDice or var_7_1 == var_0_0.ITEMS.medalDice then
		local var_7_8 = arg_7_0.params.outcome

		if arg_7_1 and arg_7_1.csv_id == var_0_0.ITEMS.sprintCard then
			var_7_8 = var_7_8 + dataEasy.getCfgByKey(var_0_0.ITEMS.sprintCard).specialArgsMap.steps
		end

		return string.format(gLanguageCsv.gridWalkHistory8, dataEasy.getCfgByKey(var_7_1).name, var_7_8)
	else
		return string.format(gLanguageCsv.gridWalkHistory7, dataEasy.getCfgByKey(var_7_1).name)
	end

	return var_7_0
end

return var_0_0
