local var_0_0 = {}
local var_0_1 = {
	16,
	15,
	14,
	13,
	12,
	11
}
local var_0_2 = {
	2103,
	2102,
	2101
}
local var_0_3 = 12
local var_0_4 = {}

for iter_0_0, iter_0_1 in orderCsvPairs(csv.rebirth_rmb_cost) do
	if not var_0_4[iter_0_1.type] then
		var_0_4[iter_0_1.type] = {}
	end

	table.insert(var_0_4[iter_0_1.type], {
		rmbPoint = iter_0_1.rmbPoint,
		rmbRate = iter_0_1.rmbRate
	})
end

local function var_0_5(arg_1_0)
	local var_1_0 = gGameModel.role:read("card_deployment")

	for iter_1_0, iter_1_1 in pairs(var_1_0.union_training.cards or {}) do
		if iter_1_1 == arg_1_0 then
			return true
		end
	end

	return false
end

local function var_0_6(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	for iter_2_0, iter_2_1 in orderCsvPairs(arg_2_0) do
		if iter_2_0 == arg_2_2 then
			break
		end

		if arg_2_1 then
			for iter_2_2, iter_2_3 in csvMapPairs(iter_2_1["costItemMap" .. arg_2_1]) do
				arg_2_3[iter_2_2] = (arg_2_3[iter_2_2] or 0) + iter_2_3
			end
		end

		if arg_2_4 then
			local var_2_0 = iter_2_1["costGold" .. arg_2_4]

			arg_2_3.gold = (arg_2_3.gold or 0) + var_2_0
		end
	end
end

local function var_0_7(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	for iter_3_0, iter_3_1 in ipairs(arg_3_0) do
		if iter_3_0 == arg_3_2 then
			break
		end

		if arg_3_1 then
			for iter_3_2, iter_3_3 in csvMapPairs(iter_3_1["costItemMap" .. arg_3_1]) do
				arg_3_3[iter_3_2] = (arg_3_3[iter_3_2] or 0) + iter_3_3
			end
		end

		if arg_3_4 then
			local var_3_0 = iter_3_1["costGold" .. arg_3_4]

			arg_3_3.gold = (arg_3_3.gold or 0) + var_3_0
		end
	end
end

function var_0_0.computeCost(arg_4_0, arg_4_1)
	local var_4_0 = 0

	for iter_4_0, iter_4_1 in ipairs(arg_4_0) do
		if iter_4_1.key == "gold" then
			var_4_0 = var_4_0 + math.ceil(iter_4_1.val / gCommonConfigCsv.rebirthRMBCostByGold)
		elseif type(iter_4_1.key) == "number" then
			local var_4_1 = dataEasy.getCfgByKey(iter_4_1.key)

			var_4_0 = var_4_0 + iter_4_1.val * var_4_1.rebirthRMB
		end
	end

	local var_4_2 = var_4_0
	local var_4_3 = var_0_4[arg_4_1]
	local var_4_4 = 0
	local var_4_5

	for iter_4_2, iter_4_3 in ipairs(var_4_3) do
		if var_4_2 <= iter_4_3.rmbPoint then
			var_4_4 = var_4_4 + var_4_0 * iter_4_3.rmbRate

			break
		end

		local var_4_6 = iter_4_3.rmbPoint

		if var_4_5 then
			var_4_6 = iter_4_3.rmbPoint - var_4_5
		end

		var_4_4 = var_4_4 + var_4_6 * iter_4_3.rmbRate
		var_4_0 = var_4_0 - var_4_6
		var_4_5 = iter_4_3.rmbPoint
	end

	local var_4_7 = gCommonConfigCsv.heldItemRebirthRMBCostLimit
	local var_4_8 = gCommonConfigCsv.heldItemRebirthRMBCostMin

	if arg_4_1 == 1 then
		var_4_7, var_4_8 = gCommonConfigCsv.rebirthRMBCostLimit, gCommonConfigCsv.cardRebirthRMBCostMin
	elseif arg_4_1 == 3 then
		var_4_7, var_4_8 = gCommonConfigCsv.gemRebirthRMBCostLimit, gCommonConfigCsv.gemRebirthRMBCostMin
	elseif arg_4_1 == 4 then
		var_4_7, var_4_8 = gCommonConfigCsv.chipRebirthRMBCostLimit, gCommonConfigCsv.chipRebirthRMBCostMin
	end

	return cc.clampf(math.ceil(var_4_4), var_4_8, var_4_7)
end

function var_0_0.computeCardReturnItem(arg_5_0)
	local var_5_0 = gGameModel.cards:find(arg_5_0)
	local var_5_1 = var_5_0:read("card_id")
	local var_5_2 = var_5_0:read("skin_id")
	local var_5_3 = var_5_0:read("level")
	local var_5_4 = var_5_0:read("star")
	local var_5_5 = var_5_0:read("advance")
	local var_5_6 = var_5_0:read("skills")
	local var_5_7 = var_5_0:read("sum_exp")
	local var_5_8 = var_5_0:read("abilities")
	local var_5_9 = csv.items
	local var_5_10 = csv.cards
	local var_5_11 = csv.skill
	local var_5_12 = csv.base_attribute.skill_level
	local var_5_13 = {}
	local var_5_14 = var_5_7

	for iter_5_0 = table.length(gCardExpItemCsv), 1, -1 do
		local var_5_15 = gCardExpItemCsv[iter_5_0].specialArgsMap.exp
		local var_5_16 = math.floor(var_5_14 / var_5_15)

		var_5_14 = var_5_14 - var_5_16 * var_5_15

		if var_5_16 > 0 then
			var_5_13[gCardExpItemCsv[iter_5_0].id] = var_5_16
		end
	end

	local var_5_17 = 0
	local var_5_18 = 0
	local var_5_19 = {}
	local var_5_20 = var_5_10[var_5_1]

	for iter_5_1, iter_5_2 in ipairs(gCardAdvanceCsv[var_5_20.advanceTypeID]) do
		if iter_5_1 == var_5_5 then
			break
		end

		for iter_5_3, iter_5_4 in csvMapPairs(iter_5_2.itemMap) do
			var_5_19[iter_5_3] = (var_5_19[iter_5_3] or 0) + iter_5_4
		end

		var_5_17 = var_5_17 + iter_5_2.gold
	end

	for iter_5_5, iter_5_6 in csvPairs(dataEasy.getCardSkillList(var_5_1, var_5_2)) do
		local var_5_21 = var_5_6[iter_5_6] or 1

		for iter_5_7, iter_5_8 in orderCsvPairs(var_5_12) do
			if iter_5_7 == var_5_21 then
				break
			end

			var_5_17 = var_5_17 + iter_5_8["gold" .. var_5_11[iter_5_6].costID]
		end

		var_5_18 = var_5_18 + var_5_21 - 1
	end

	local var_5_22 = math.ceil(var_5_18 * gCommonConfigCsv.rebirthRetrunProportion5)
	local var_5_23 = {}

	for iter_5_9, iter_5_10 in pairs(var_5_8) do
		local var_5_24 = gCardAbilityCsv[var_5_20.abilitySeqID][iter_5_9]
		local var_5_25 = {}
		local var_5_26 = 0

		for iter_5_11 = 1, iter_5_10 do
			local var_5_27 = csv.card_ability_cost[iter_5_11]["costItemMap" .. var_5_24.strengthSeqID]

			for iter_5_12, iter_5_13 in csvMapPairs(var_5_27) do
				if iter_5_12 == "gold" then
					var_5_17 = var_5_17 + iter_5_13
				else
					var_5_23[iter_5_12] = (var_5_23[iter_5_12] or 0) + iter_5_13
				end
			end
		end
	end

	local var_5_28 = math.ceil(var_5_17 * gCommonConfigCsv.rebirthRetrunProportion1)
	local var_5_29 = {}

	for iter_5_14, iter_5_15 in pairs(var_5_13) do
		var_5_29[iter_5_14] = var_5_29[iter_5_14] or 0 + iter_5_15
	end

	for iter_5_16, iter_5_17 in pairs(var_5_19) do
		var_5_29[iter_5_16] = var_5_29[iter_5_16] or 0 + iter_5_17
	end

	for iter_5_18, iter_5_19 in pairs(var_5_23) do
		var_5_29[iter_5_18] = var_5_29[iter_5_18] or 0 + iter_5_19
	end

	if var_5_28 > 0 then
		var_5_29.gold = (var_5_29.gols or 0) + var_5_28
	end

	if var_5_22 > 0 then
		var_5_29.skill_point = (var_5_29.skill_point or 0) + var_5_22
	end

	return var_5_29
end

function var_0_0.computeEquipReturnItem(arg_6_0)
	local var_6_0 = csv.equips
	local var_6_1 = csv.base_attribute.equip_strength
	local var_6_2 = gGameModel.cards:find(arg_6_0):read("equips")
	local var_6_3 = {}
	local var_6_4 = {}

	for iter_6_0, iter_6_1 in csvPairs(csv.base_attribute.equip_signet_advance) do
		var_6_4[iter_6_1.advanceIndex] = iter_6_1
	end

	for iter_6_2, iter_6_3 in ipairs(var_6_2) do
		local var_6_5 = var_6_0[iter_6_3.equip_id]

		var_0_6(var_6_1, nil, iter_6_3.level, var_6_3, var_6_5.strengthSeqID)
		var_0_7(gEquipAdvanceCsv[iter_6_3.equip_id], "", iter_6_3.advance, var_6_3, "")
		var_0_6(csv.base_attribute.equip_star, var_6_5.starSeqID, iter_6_3.star, var_6_3)
		var_0_6(csv.base_attribute.equip_ability, var_6_5.abilitySeqID, iter_6_3.ability, var_6_3)
		var_0_6(csv.base_attribute.equip_awake, var_6_5.awakeSeqID, iter_6_3.awake, var_6_3)
		var_0_6(csv.base_attribute.equip_awake_ability, var_6_5.awakeAbilitySeqID, iter_6_3.awake_ability, var_6_3)
		var_0_6(csv.base_attribute.equip_signet, var_6_5.signetStrengthSeqID, iter_6_3.signet, var_6_3)
		var_0_6(csv.base_attribute.equip_signet_advance_cost, var_6_4[var_6_5.advanceIndex].advanceSeqID, iter_6_3.signet_advance, var_6_3)
	end

	if var_6_3.gold and var_6_3.gold > 0 then
		var_6_3.gold = math.ceil(var_6_3.gold * gCommonConfigCsv.rebirthRetrunProportion1)
	end

	return var_6_3
end

function var_0_0.computeStarSkillPoints(arg_7_0)
	local var_7_0 = gGameModel.cards:find(arg_7_0)
	local var_7_1 = {}

	if not var_7_0 then
		return var_7_1
	end

	local var_7_2 = var_7_0:read("card_id")
	local var_7_3 = csv.cards[var_7_2].cardMarkID
	local var_7_4 = 0
	local var_7_5 = csv.cards[var_7_2].cardMarkID
	local var_7_6 = csv.cards[var_7_5].starSkillSeqID
	local var_7_7 = csv.card_star_skill[var_7_6].starSkillList
	local var_7_8 = var_7_0:read("skills")

	for iter_7_0, iter_7_1 in ipairs(var_7_7) do
		local var_7_9 = var_7_8[iter_7_1] or 0
		local var_7_10 = csv.skill[iter_7_1].costID

		for iter_7_2 = 1, var_7_9 do
			if csv.base_attribute.skill_level[iter_7_2 - 1] then
				var_7_4 = var_7_4 + csv.base_attribute.skill_level[iter_7_2 - 1]["itemNum" .. var_7_10]
			end
		end
	end

	local var_7_11 = math.ceil(var_7_4 * gCommonConfigCsv.rebirthRetrunProportion4)

	if var_7_11 > 0 then
		var_7_1["star_skill_points_" .. var_7_3] = (var_7_1["star_skill_points_" .. var_7_3] or 0) + var_7_11
	end

	return var_7_1
end

function var_0_0.getReturnItems(arg_8_0)
	local var_8_0 = var_0_0.computeCardReturnItem(arg_8_0)
	local var_8_1 = var_0_0.computeEquipReturnItem(arg_8_0)
	local var_8_2 = {}

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		var_8_2[iter_8_0] = (var_8_2[iter_8_0] or 0) + iter_8_1
	end

	for iter_8_2, iter_8_3 in pairs(var_8_1) do
		var_8_2[iter_8_2] = (var_8_2[iter_8_2] or 0) + iter_8_3
	end

	local var_8_3 = var_0_0.sortItems(var_8_2)

	return var_8_3, var_0_0.computeCost(var_8_3, 1)
end

function var_0_0.isExpItem(arg_9_0)
	if tonumber(arg_9_0) and arg_9_0 >= 11 and arg_9_0 <= 16 then
		return true
	end

	return false
end

function var_0_0.sortItems(arg_10_0)
	local var_10_0 = {}

	for iter_10_0, iter_10_1 in pairs(arg_10_0) do
		local var_10_1 = iter_10_1

		for iter_10_2 = 1, var_0_3 do
			if iter_10_0 ~= "coin" .. iter_10_2 then
				var_10_1 = math.ceil(iter_10_1 * gCommonConfigCsv.rebirthRetrunProportion1)
			end
		end

		if iter_10_0 ~= "gold" and iter_10_0 ~= "skill_point" and iter_10_0 ~= "star_skill_points+" then
			var_10_1 = math.ceil(iter_10_1 * gCommonConfigCsv.rebirthRetrunProportion1)
		end

		table.insert(var_10_0, {
			key = iter_10_0,
			val = var_10_1
		})
	end

	local var_10_2 = {
		gold = 1,
		skill_point = 3,
		star_skill_points = 4
	}

	table.sort(var_10_0, function(arg_11_0, arg_11_1)
		local var_11_0 = dataEasy.isFragmentCard(arg_11_0.key)

		if var_11_0 ~= dataEasy.isFragmentCard(arg_11_1.key) then
			return var_11_0
		elseif var_11_0 then
			local var_11_1 = dataEasy.getCfgByKey(arg_11_0.key)
			local var_11_2 = dataEasy.getCfgByKey(arg_11_0.key)
			local var_11_3 = csv.cards[var_11_1.combID].unitID
			local var_11_4 = csv.cards[var_11_2.combID].unitID

			return csv.unit[var_11_3].rarity > csv.unit[var_11_4].rarity
		end

		local var_11_5 = var_10_2[arg_11_0.key]
		local var_11_6 = var_10_2[arg_11_1.key]

		for iter_11_0 = 1, var_0_3 do
			if arg_11_0.key == "coin" .. iter_11_0 then
				var_11_5 = 2
			end

			if arg_11_1.key == "coin" .. iter_11_0 then
				var_11_6 = 2
			end
		end

		if var_11_5 == nil and string.find(arg_11_0.key, "star_skill_points_%d+") then
			var_11_5 = var_10_2.star_skill_points
		end

		if var_11_6 == nil and string.find(arg_11_1.key, "star_skill_points_%d+") then
			var_11_6 = var_10_2.star_skill_points
		end

		if var_11_5 and var_11_6 then
			return var_11_5 < var_11_6
		elseif var_11_5 then
			return true
		elseif var_11_6 then
			return false
		end

		local var_11_7 = var_0_0.isExpItem(arg_11_0.key)

		if var_11_7 ~= var_0_0.isExpItem(arg_11_1.key) then
			return var_11_7
		elseif var_11_7 then
			local var_11_8 = csv.items[arg_11_0.key]
			local var_11_9 = csv.items[arg_11_1.key]

			return var_11_8.quality > var_11_9.quality
		end

		return arg_11_0.key > arg_11_1.key
	end)

	return var_10_0
end

function var_0_0.computeDecomposeItems(arg_12_0)
	local var_12_0 = csv.cards
	local var_12_1 = {}
	local var_12_2 = {}
	local var_12_3 = 0
	local var_12_4 = 0

	for iter_12_0, iter_12_1 in pairs(arg_12_0 or {}) do
		local var_12_5 = iter_12_1.dbid

		if not var_0_0.isCardRebirthed(var_12_5) then
			local var_12_6, var_12_7 = var_0_0.getReturnItems(var_12_5)

			var_12_3 = var_12_3 + var_12_7

			for iter_12_2, iter_12_3 in ipairs(var_12_6) do
				var_12_1[iter_12_3.key] = (var_12_1[iter_12_3.key] or 0) + iter_12_3.val
			end
		end

		local var_12_8 = gGameModel.cards:find(var_12_5)
		local var_12_9 = var_12_8:read("getstar")
		local var_12_10 = var_12_8:read("card_id")
		local var_12_11 = var_12_8:read("cost_universal_cards")
		local var_12_12 = 0

		for iter_12_4, iter_12_5 in pairs(var_12_11 or {}) do
			var_12_12 = var_12_12 + iter_12_5
		end

		local var_12_13 = var_12_0[iter_12_1.id]
		local var_12_14 = 0

		for iter_12_6 = var_12_9, iter_12_1.star - 1 do
			local var_12_15 = gStarCsv[var_12_13.starTypeID][iter_12_6]

			var_12_4 = var_12_4 + var_12_15.gold

			for iter_12_7, iter_12_8 in csvMapPairs(var_12_15.costItems) do
				var_12_2[iter_12_7] = (var_12_2[iter_12_7] or 0) + iter_12_8
			end

			var_12_14 = var_12_14 + var_12_15.costCardNum
		end

		local var_12_16 = var_12_14 - var_12_12
		local var_12_17 = gStar2FragCsv[var_12_13.fragNumType]
		local var_12_18 = var_12_17[var_12_9].baseFragNum
		local var_12_19 = var_12_17[1].baseFragNum

		var_12_2[var_12_13.fragID] = (var_12_2[var_12_13.fragID] or 0) + (var_12_16 * var_12_19 + var_12_18) * gCommonConfigCsv.rebirthRetrunProportion2

		local var_12_20 = var_0_0.computeStarSkillPoints(var_12_5)

		for iter_12_9, iter_12_10 in pairs(var_12_20) do
			var_12_2[iter_12_9] = (var_12_2[iter_12_9] or 0) + iter_12_10
		end
	end

	if var_12_4 > 0 then
		var_12_2.gold = math.ceil(var_12_4 * gCommonConfigCsv.rebirthRetrunProportion2)
	end

	for iter_12_11, iter_12_12 in pairs(var_12_1) do
		var_12_2[iter_12_11] = (var_12_2[iter_12_11] or 0) + iter_12_12
	end

	local var_12_21 = {}

	for iter_12_13, iter_12_14 in pairs(var_12_2) do
		if csv.fragments[iter_12_13] then
			local var_12_22 = csv.fragments[iter_12_13].decomposeGain

			for iter_12_15, iter_12_16 in csvMapPairs(var_12_22) do
				var_12_21[iter_12_15] = (var_12_21[iter_12_15] or 0) + iter_12_16 * iter_12_14
			end
		else
			var_12_21[iter_12_13] = (var_12_21[iter_12_13] or 0) + iter_12_14
		end
	end

	return var_0_0.sortItems(var_12_21), var_12_3
end

function var_0_0.computeHeldItemReturn(arg_13_0)
	local var_13_0 = gGameModel.held_items:find(arg_13_0)
	local var_13_1 = var_13_0:read("advance")
	local var_13_2 = var_13_0:read("held_item_id")
	local var_13_3 = var_13_0:read("level")
	local var_13_4 = var_13_0:read("sum_exp")
	local var_13_5 = var_13_0:read("cost_universal_items")
	local var_13_6 = csv.held_item.level
	local var_13_7 = csv.held_item.items[var_13_2]
	local var_13_8 = csv.items
	local var_13_9 = {}
	local var_13_10 = 0

	if var_13_4 > 0 then
		var_13_10 = var_13_4 * gCommonConfigCsv.heldItemExpNeedGold

		for iter_13_0, iter_13_1 in ipairs(var_0_2) do
			local var_13_11 = var_13_8[iter_13_1].specialArgsMap.heldItemExp
			local var_13_12 = math.floor(var_13_4 / var_13_11)

			var_13_4 = var_13_4 - var_13_12 * var_13_11

			if var_13_12 > 0 then
				var_13_9[iter_13_1] = var_13_12
			end
		end
	end

	local var_13_13 = {}

	if var_13_1 > 0 then
		for iter_13_2, iter_13_3 in orderCsvPairs(csv.held_item.advance) do
			if iter_13_2 == var_13_1 then
				break
			end

			for iter_13_4, iter_13_5 in csvMapPairs(iter_13_3["costItemMap" .. var_13_7.advanceSeqID]) do
				var_13_13[iter_13_4] = (var_13_13[iter_13_4] or 0) + iter_13_5
			end
		end
	end

	local var_13_14 = {}

	for iter_13_6, iter_13_7 in pairs(var_13_9) do
		var_13_14[iter_13_6] = math.ceil(iter_13_7 * gCommonConfigCsv.rebirthRetrunProportion3)
	end

	local var_13_15 = 0

	for iter_13_8, iter_13_9 in pairs(var_13_5) do
		var_13_15 = var_13_15 + iter_13_9

		local var_13_16 = math.ceil(iter_13_9 * gCommonConfigCsv.rebirthRetrunProportion4)

		if var_13_16 > 0 then
			var_13_14[iter_13_8] = var_13_16
		end
	end

	for iter_13_10, iter_13_11 in pairs(var_13_13) do
		local var_13_17 = iter_13_11

		if iter_13_10 <= game.HELD_ITEM_CSVID_LIMIT and iter_13_10 > game.FRAGMENT_CSVID_LIMIT then
			var_13_17 = iter_13_11 - var_13_15
		end

		local var_13_18 = math.ceil(var_13_17 * gCommonConfigCsv.rebirthRetrunProportion3)

		if var_13_18 > 0 then
			var_13_14[iter_13_10] = var_13_18
		end
	end

	if var_13_10 > 0 then
		var_13_14.gold = math.ceil(var_13_10 * gCommonConfigCsv.rebirthRetrunProportion3)
	end

	local var_13_19 = var_0_0.sortItems(var_13_14)

	return var_13_19, var_0_0.computeCost(var_13_19, 2)
end

function var_0_0.isCardRebirthed(arg_14_0)
	if not arg_14_0 then
		return true
	end

	local var_14_0 = gGameModel.cards:find(arg_14_0)

	if not var_14_0 then
		return true
	end

	local var_14_1 = var_14_0:read("card_id")
	local var_14_2 = var_14_0:read("level")
	local var_14_3 = var_14_0:read("equips")
	local var_14_4 = var_14_0:read("advance")
	local var_14_5 = var_14_0:read("skills")
	local var_14_6 = var_14_0:read("abilities")
	local var_14_7 = true

	for iter_14_0, iter_14_1 in csvPairs(csv.cards[var_14_1].skillList) do
		if (var_14_5[iter_14_1] or 1) > 1 then
			var_14_7 = false

			break
		end
	end

	if not var_14_7 then
		return var_14_7
	end

	if var_14_2 > 1 or var_14_4 > 1 then
		return false
	end

	for iter_14_2, iter_14_3 in ipairs(var_14_3) do
		if iter_14_3.level > 1 or iter_14_3.advance > 1 or iter_14_3.star > 0 or iter_14_3.awake > 0 or iter_14_3.awake_ability > 0 or iter_14_3.signet > 0 or iter_14_3.signet_advance > 0 or iter_14_3.ability > 0 then
			var_14_7 = false

			break
		end
	end

	for iter_14_4, iter_14_5 in pairs(var_14_6) do
		if iter_14_5 >= 1 then
			return false
		end
	end

	return var_14_7
end

function var_0_0.isHeldItemRebirthed(arg_15_0)
	if not arg_15_0 then
		return true
	end

	local var_15_0 = gGameModel.held_items:find(arg_15_0)
	local var_15_1 = var_15_0:read("advance")

	if var_15_0:read("sum_exp") > 0 or var_15_1 > 0 then
		return false
	end

	return true
end

function var_0_0.getSelectCard(arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or {}

	local var_16_0 = {}
	local var_16_1 = csv.cards
	local var_16_2 = csv.unit
	local var_16_3 = dataEasy.inUsingCardsHash()
	local var_16_4 = gGameModel.role:read("cards")

	for iter_16_0, iter_16_1 in ipairs(var_16_4) do
		if arg_16_0 == 2 or arg_16_0 == 1 and not var_0_0.isCardRebirthed(iter_16_1) then
			local var_16_5 = gGameModel.cards:find(iter_16_1)
			local var_16_6 = var_16_5:read("card_id")
			local var_16_7 = var_16_5:read("skin_id")
			local var_16_8 = var_16_1[var_16_6]
			local var_16_9 = var_16_2[var_16_8.unitID]
			local var_16_10 = dataEasy.getUnitId(var_16_6, var_16_7)
			local var_16_11 = {
				id = var_16_6,
				unitId = var_16_10,
				rarity = var_16_9.rarity,
				fight = var_16_5:read("fighting_point"),
				level = var_16_5:read("level"),
				star = var_16_5:read("star"),
				advance = var_16_5:read("advance"),
				dbid = iter_16_1,
				lock = var_16_5:read("locked"),
				battle = var_16_3[iter_16_1] and 1 or 2,
				battleType = var_16_3[iter_16_1],
				isUnion = var_0_5(iter_16_1),
				isSel = itertools.include(arg_16_1, iter_16_1),
				markId = var_16_8.cardMarkID,
				cardType = var_16_8.cardType
			}

			table.insert(var_16_0, var_16_11)
		end
	end

	return var_16_0
end

function var_0_0.isSingleInEvoLine(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or {}

	local var_17_0 = csv.cards
	local var_17_1 = gGameModel.cards:find(arg_17_0):read("card_id")
	local var_17_2 = var_17_0[var_17_1].cardMarkID
	local var_17_3 = {}

	for iter_17_0, iter_17_1 in pairs(arg_17_1) do
		local var_17_4 = gGameModel.cards:find(iter_17_1):read("card_id")
		local var_17_5 = var_17_0[var_17_4].cardMarkID

		if not var_17_3[var_17_5] then
			var_17_3[var_17_5] = {}
		end

		var_17_3[var_17_5][var_17_4] = (var_17_3[var_17_5][var_17_4] or 0) + 1
	end

	local var_17_6 = {}
	local var_17_7 = gGameModel.role:read("cards")

	for iter_17_2, iter_17_3 in ipairs(var_17_7) do
		local var_17_8 = gGameModel.cards:find(iter_17_3):read("card_id")
		local var_17_9 = var_17_0[var_17_8].cardMarkID

		if var_17_9 == var_17_2 then
			if not var_17_6[var_17_9] then
				var_17_6[var_17_9] = {}
			end

			var_17_6[var_17_9][var_17_8] = (var_17_6[var_17_9][var_17_8] or 0) + 1
		end
	end

	for iter_17_4, iter_17_5 in pairs(var_17_3[var_17_2] or {}) do
		var_17_6[var_17_2][iter_17_4] = var_17_6[var_17_2][iter_17_4] - iter_17_5
	end

	var_17_6[var_17_2][var_17_1] = var_17_6[var_17_2][var_17_1] - 1

	local var_17_10 = true

	for iter_17_6, iter_17_7 in pairs(var_17_6[var_17_2]) do
		if iter_17_7 > 0 then
			var_17_10 = false

			break
		end
	end

	return var_17_10
end

function var_0_0.getReturnItemsGem(arg_18_0)
	local var_18_0 = {}
	local var_18_1 = {}
	local var_18_2 = 0
	local var_18_3 = {}
	local var_18_4 = {}

	for iter_18_0, iter_18_1 in pairs(arg_18_0) do
		local var_18_5 = gGameModel.gems:find(iter_18_1)
		local var_18_6 = var_18_5:read("gem_id")
		local var_18_7 = var_18_5:read("level")
		local var_18_8 = dataEasy.getCfgByKey(var_18_6)
		local var_18_9 = {}
		local var_18_10 = {}

		for iter_18_2 = 1, var_18_7 - 1 do
			for iter_18_3, iter_18_4 in csvMapPairs(csv.gem.cost[iter_18_2]["costItemMap" .. var_18_8.strengthCostSeq]) do
				if var_18_1[iter_18_3] then
					local var_18_11 = var_18_0[var_18_1[iter_18_3]]

					var_18_11.val = var_18_11.val + iter_18_4
				else
					table.insert(var_18_0, {
						key = iter_18_3,
						val = iter_18_4
					})

					var_18_1[iter_18_3] = #var_18_0
				end

				if var_18_10[iter_18_3] then
					local var_18_12 = var_18_9[var_18_10[iter_18_3]]

					var_18_12.val = var_18_12.val + iter_18_4
				else
					table.insert(var_18_9, {
						key = iter_18_3,
						val = iter_18_4
					})

					var_18_10[iter_18_3] = #var_18_9
				end
			end
		end

		var_18_2 = var_18_2 + var_0_0.computeCost(var_18_9, 3)
	end

	table.sort(var_18_0, function(arg_19_0, arg_19_1)
		if arg_19_0.key == "gold" then
			return true
		elseif arg_19_1.key == "gold" then
			return false
		else
			return dataEasy.getCfgByKey(arg_19_0.key).quality >= dataEasy.getCfgByKey(arg_19_1.key).quality
		end
	end)

	return var_18_0, var_18_2
end

function var_0_0.getReturnItemsChip(arg_20_0)
	local var_20_0 = 0
	local var_20_1 = {}
	local var_20_2 = 0
	local var_20_3 = {}
	local var_20_4 = {}
	local var_20_5 = {}

	for iter_20_0, iter_20_1 in pairs(gChipExpCsv) do
		table.insert(var_20_5, {
			id = iter_20_1.id,
			num = iter_20_1.specialArgsMap.chipExp
		})
	end

	table.sort(var_20_5, function(arg_21_0, arg_21_1)
		return arg_21_0.num > arg_21_1.num
	end)

	local function var_20_6(arg_22_0)
		local var_22_0 = {}

		for iter_22_0, iter_22_1 in ipairs(var_20_5) do
			local var_22_1 = math.floor(arg_22_0 / iter_22_1.num)

			arg_22_0 = arg_22_0 % iter_22_1.num

			table.insert(var_22_0, {
				key = iter_22_1.id,
				val = var_22_1
			})
		end

		return var_22_0
	end

	for iter_20_2, iter_20_3 in pairs(arg_20_0) do
		local var_20_7 = gGameModel.chips:find(iter_20_3):read("chip_id", "level", "sum_exp")
		local var_20_8 = math.floor(var_20_7.sum_exp * gCommonConfigCsv.chipRebirthRetrunProportion)
		local var_20_9 = var_20_6(var_20_8)

		table.insert(var_20_9, {
			key = "gold",
			val = var_20_8 * gCommonConfigCsv.chipExpNeedGold
		})

		for iter_20_4, iter_20_5 in pairs(var_20_9) do
			var_20_4[iter_20_5.key] = (var_20_4[iter_20_5.key] or 0) + iter_20_5.val
		end

		var_20_0 = var_20_0 + var_0_0.computeCost(var_20_9, 4)
	end

	for iter_20_6, iter_20_7 in pairs(var_20_4) do
		if iter_20_7 > 0 then
			table.insert(var_20_3, {
				key = iter_20_6,
				val = iter_20_7
			})
		end
	end

	table.sort(var_20_3, function(arg_23_0, arg_23_1)
		if arg_23_0.key == "gold" then
			return true
		elseif arg_23_1.key == "gold" then
			return false
		else
			return dataEasy.getCfgByKey(arg_23_0.key).quality >= dataEasy.getCfgByKey(arg_23_1.key).quality
		end
	end)

	return var_20_3, var_20_0
end

return var_0_0
