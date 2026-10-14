local var_0_0 = {}
local var_0_1 = require("app.views.city.zawake.tools")

local function var_0_2(arg_1_0)
	local var_1_0 = gGameModel.role:read("card_deployment")

	for iter_1_0, iter_1_1 in pairs(var_1_0.union_training.cards or {}) do
		if iter_1_1 == arg_1_0 then
			return true
		end
	end

	return false
end

function var_0_0.getActiveConditionStr(arg_2_0)
	if arg_2_0 == 1 then
		return ""
	end

	local var_2_0 = gGameModel.role:read("level")
	local var_2_1 = gGameModel.role:read("meteorites")
	local var_2_2 = csv.meteorite.base[arg_2_0]
	local var_2_3 = 0

	if var_2_1 and var_2_1[arg_2_0 - 1] then
		var_2_3 = var_2_1[arg_2_0 - 1].level
	end

	local var_2_4 = string.format(gLanguageCsv.meteorCanUnlockCondition1, csv.meteorite.base[var_2_2.preID].name, var_2_2.preLevel)
	local var_2_5 = string.format(gLanguageCsv.meteorCanUnlockCondition2, var_2_2.unlockLevel)
	local var_2_6 = true
	local var_2_7 = true

	if var_2_3 < var_2_2.preLevel then
		var_2_6 = false
	end

	if var_2_0 < var_2_2.unlockLevel then
		var_2_7 = false
	end

	local var_2_8 = {}

	for iter_2_0 = 1, 2 do
		local var_2_9 = iter_2_0 ~= 2 and var_2_4 or var_2_5
		local var_2_10

		if iter_2_0 == 1 then
			var_2_10 = var_2_6
		else
			var_2_10 = var_2_7
		end

		var_2_8[iter_2_0] = {
			str = var_2_9,
			isArrive = var_2_10
		}
	end

	return var_2_8
end

function var_0_0.getSelectCard(arg_3_0, arg_3_1)
	arg_3_0 = arg_3_0 or {}

	local var_3_0 = {}
	local var_3_1 = csv.cards
	local var_3_2 = csv.unit
	local var_3_3 = dataEasy.cannotInMeteorCards(arg_3_1)
	local var_3_4 = gGameModel.role:read("cards")

	for iter_3_0, iter_3_1 in ipairs(var_3_4) do
		local var_3_5 = gGameModel.cards:find(iter_3_1)
		local var_3_6 = var_3_5:read("card_id")
		local var_3_7 = var_3_5:read("skin_id")
		local var_3_8 = var_3_1[var_3_6]
		local var_3_9 = var_3_2[var_3_8.unitID]
		local var_3_10 = dataEasy.getUnitId(var_3_6, var_3_7)
		local var_3_11 = var_3_3[iter_3_1] and 1 or 2
		local var_3_12 = var_3_3[iter_3_1]
		local var_3_13 = {
			id = var_3_6,
			unitId = var_3_10,
			rarity = var_3_9.rarity,
			fight = var_3_5:read("fighting_point"),
			level = var_3_5:read("level"),
			star = var_3_5:read("star"),
			advance = var_3_5:read("advance"),
			dbid = iter_3_1,
			lock = var_3_5:read("locked"),
			battle = var_3_11,
			battleType = var_3_12,
			isUnion = var_0_2(iter_3_1),
			isSel = itertools.include(arg_3_0, iter_3_1),
			markId = var_3_8.cardMarkID,
			cardType = var_3_8.cardType
		}

		table.insert(var_3_0, var_3_13)
	end

	return var_3_0
end

function var_0_0.getMeteorExtraAddNum(arg_4_0)
	return (var_0_0.getMeteorSpriteExtraAddNum(arg_4_0) + var_0_0.getMeteorHeldsExtraAddNum(arg_4_0)) * 100 .. "%"
end

function var_0_0.getZawakeStage(arg_5_0, arg_5_1)
	local var_5_0 = gGameModel.role:read("meteorites")[arg_5_1] or {}
	local var_5_1 = gGameModel.role:read("cards")
	local var_5_2 = csv.cards[arg_5_0].zawakeID
	local var_5_3 = 0
	local var_5_4

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		local var_5_5 = gGameModel.cards:find(iter_5_1)
		local var_5_6 = var_5_5:read("card_id")
		local var_5_7 = var_5_5:read("fighting_point")

		if var_5_5 and var_5_2 == csv.cards[var_5_6].zawakeID and var_5_3 < var_5_7 then
			var_5_3 = var_5_7
			var_5_4 = iter_5_1
		end
	end

	local var_5_8 = 1
	local var_5_9 = 0
	local var_5_10 = false
	local var_5_11 = csv.cards[arg_5_0].zawakeID
	local var_5_12, var_5_13 = var_0_1.getMaxStageLevel(var_5_11)

	if var_5_12 and var_5_0.card == var_5_4 then
		var_5_10 = true
		var_5_8 = var_5_12

		local var_5_14 = var_5_12
	end

	return var_5_8, var_5_10
end

function var_0_0.getMeteorSpriteExtraAddNum(arg_6_0)
	local var_6_0 = gGameModel.role:read("meteorites")[arg_6_0] or {}
	local var_6_1 = 0

	if var_6_0.card then
		local var_6_2 = gGameModel.role:read("meteorites")[arg_6_0].card
		local var_6_3 = gGameModel.cards:find(var_6_2)
		local var_6_4 = var_6_3:read("advance")
		local var_6_5 = var_6_3:read("card_id")
		local var_6_6 = var_6_3:read("skin_id")
		local var_6_7 = var_6_3:read("star")
		local var_6_8 = var_6_3:read("level")
		local var_6_9, var_6_10 = var_0_0.getZawakeStage(var_6_5, arg_6_0)
		local var_6_11 = csv.cards[var_6_5]
		local var_6_12 = csv.unit[var_6_11.unitID]
		local var_6_13 = "0%"
		local var_6_14 = "0%"
		local var_6_15 = "0%"
		local var_6_16 = "0%"

		for iter_6_0, iter_6_1 in csvPairs(csv.meteorite.guard_effect) do
			if iter_6_0 == var_6_12.rarity then
				var_6_13 = iter_6_1.rarityAttr
				var_6_14 = iter_6_1.starAttrs[var_6_7]
				var_6_15 = iter_6_1.advanceAttrs[var_6_4]

				if var_6_10 then
					var_6_16 = iter_6_1.zawakeAttrs[var_6_9]
				else
					var_6_16 = "0%"
				end
			end
		end

		local var_6_17 = string.sub(var_6_13, 1, #var_6_13 - 1) / 100
		local var_6_18 = string.sub(var_6_14, 1, #var_6_14 - 1) / 100
		local var_6_19 = string.sub(var_6_15, 1, #var_6_15 - 1) / 100
		local var_6_20 = string.sub(var_6_16, 1, #var_6_16 - 1) / 100

		var_6_1 = var_6_17 + var_6_18 + var_6_19 + var_6_20
	end

	return var_6_1
end

function var_0_0.getMeteorHeldsExtraAddNum(arg_7_0)
	local var_7_0 = gGameModel.role:read("meteorites")[arg_7_0] or {}
	local var_7_1 = 0

	if itertools.isempty(var_7_0.helditems) then
		return 0
	end

	for iter_7_0 = 1, 2 do
		if var_7_0.helditems[iter_7_0] then
			local var_7_2 = gGameModel.role:read("meteorites")[arg_7_0].helditems[iter_7_0]
			local var_7_3 = gGameModel.held_items:find(var_7_2)
			local var_7_4
			local var_7_5 = ""
			local var_7_6 = 1
			local var_7_7 = 1
			local var_7_8 = 0
			local var_7_9

			if var_7_3 then
				local var_7_10 = var_7_3.read(var_7_3, "exist_flag", "card_db_id", "advance", "level", "sum_exp", "held_item_id")
				local var_7_11 = var_7_10.held_item_id
				local var_7_12 = csv.held_item.items[var_7_11]
				local var_7_13 = var_7_12.name

				var_7_6 = var_7_12.quality
				var_7_7 = var_7_10.level
				var_7_8 = var_7_10.advance
			end

			local var_7_14 = "0%"
			local var_7_15 = "0%"
			local var_7_16 = "0%"
			local var_7_17 = 1

			for iter_7_1, iter_7_2 in csvPairs(csv.meteorite.helditem_effect) do
				if iter_7_2.id == var_7_6 then
					for iter_7_3 = 1, #iter_7_2.levelAttrs do
						if var_7_7 >= iter_7_2.levelAttrs[iter_7_3][1] then
							local var_7_18 = iter_7_2.levelAttrs[iter_7_3][1]

							var_7_14 = iter_7_2.levelAttrs[iter_7_3][2]
						end
					end

					var_7_16 = iter_7_2.rarityAttr
					var_7_15 = iter_7_2.advanceAttrs[var_7_8] or "0%"
				end
			end

			local var_7_19 = string.sub(var_7_14, 1, #var_7_14 - 1) / 100
			local var_7_20 = string.sub(var_7_15, 1, #var_7_15 - 1) / 100
			local var_7_21 = string.sub(var_7_16, 1, #var_7_16 - 1) / 100

			var_7_1 = var_7_1 + var_7_19 + var_7_20 + var_7_21
		end
	end

	return var_7_1
end

function var_0_0.getPointToCenterOfCircleDistance(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	return (math.sqrt((arg_8_0 - arg_8_2)^2 + (arg_8_1 - arg_8_3)^2))
end

function var_0_0.isClickPositionInCircle(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_4 >= var_0_0.getPointToCenterOfCircleDistance(arg_9_0, arg_9_1, arg_9_2, arg_9_3) then
		return true
	else
		return false
	end
end

return var_0_0
