local var_0_0 = {}
local var_0_1 = {
	buffCardHp = 1,
	buffCardMp = 2,
	buffCardDead = 3
}

function var_0_0.reachCondition(arg_1_0, arg_1_1, arg_1_2)
	if gGameModel.cards:find(arg_1_2):read("level") < 10 then
		return false
	end

	if arg_1_0 == var_0_1.buffCardHp then
		return arg_1_1 and arg_1_1[1] > 0 and arg_1_1[1] < 1
	end

	if arg_1_0 == var_0_1.buffCardMp then
		return not arg_1_1 or arg_1_1 and arg_1_1[2] < 1 and arg_1_1[1] > 0
	end

	if arg_1_0 == var_0_1.buffCardDead then
		return arg_1_1 and arg_1_1[1] <= 0
	end

	return true
end

function var_0_0.getCards(arg_2_0)
	local var_2_0 = gGameModel.role:read("cards")

	if arg_2_0 == 2 then
		var_2_0 = table.deepcopy(gGameModel.role:read("huodong_cards")[game.EMBATTLE_HOUDONG_ID.randomTower], true) or {}
	end

	return var_2_0
end

function var_0_0.setEffect(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = not arg_3_2 and "random_tower/baoxiang.skel" or arg_3_2
	local var_3_1 = arg_3_3 or 0
	local var_3_2 = arg_3_0:get("effect")

	if not var_3_2 then
		widget.addAnimationByKey(arg_3_0, var_3_0, "effect", arg_3_1, 0):xy(arg_3_0:width() / 2, arg_3_0:height() / 2 - var_3_1):scale(2)
	else
		var_3_2:play(arg_3_1)
	end
end

function var_0_0.calcFightingPointFunc()
	local var_4_0 = {}

	for iter_4_0, iter_4_1 in ipairs(gGameModel.random_tower:read("buffs")) do
		local var_4_1 = csv.random_tower.buffs[iter_4_1]

		if var_4_1.buffType == 1 then
			for iter_4_2 = 1, 99 do
				local var_4_2 = var_4_1["attrType" .. iter_4_2]

				if var_4_2 == nil or var_4_2 == 0 then
					break
				end

				local var_4_3 = game.ATTRDEF_TABLE[var_4_2]
				local var_4_4, var_4_5 = dataEasy.parsePercentStr(var_4_1["attrNum" .. iter_4_2])

				if var_4_0[var_4_3] == nil then
					var_4_0[var_4_3] = {
						0,
						0
					}
				end

				if var_4_5 == game.NUM_TYPE.number then
					var_4_0[var_4_3][1] = var_4_0[var_4_3][1] + var_4_4
				else
					var_4_0[var_4_3][2] = var_4_0[var_4_3][2] + var_4_4
				end
			end
		end
	end

	return function(arg_5_0)
		local var_5_0 = gGameModel.cards:find(arg_5_0):read("card_id", "level", "skills", "attrs", "attrs2")
		local var_5_1 = csv.cards[var_5_0.card_id]
		local var_5_2 = maptools.extend({
			var_5_0.attrs,
			var_5_0.attrs2
		})

		for iter_5_0, iter_5_1 in pairs(var_4_0) do
			local var_5_3 = var_5_2[iter_5_0]
			local var_5_4 = iter_5_1[1]
			local var_5_5 = iter_5_1[2]

			if var_5_4 > 0 then
				var_5_3 = var_5_3 + var_5_4
			end

			if var_5_5 > 0 then
				var_5_3 = var_5_3 * (1 + var_5_5 / 100)
			end

			var_5_2[iter_5_0] = var_5_3
		end

		return (dataEasy.calcFightingPoint(var_5_0.card_id, var_5_0.level, var_5_2, var_5_0.skills))
	end
end

function var_0_0.getCanPassMaxRoom()
	local var_6_0 = gGameModel.role:read("level")
	local var_6_1 = gGameModel.role:read("vip_level")
	local var_6_2 = gGameModel.random_tower:read("room")
	local var_6_3 = gGameModel.random_tower:read("last_room")
	local var_6_4 = gGameModel.random_tower:read("history_room")
	local var_6_5 = var_6_3 > 0 and csv.random_tower.tower[var_6_3].canPass or 0
	local var_6_6 = var_6_4 > 0 and csv.random_tower.tower[var_6_4].canPass or 0
	local var_6_7 = 0

	for iter_6_0, iter_6_1 in orderCsvPairs(csv.random_tower.can_pass) do
		if var_6_0 >= iter_6_1.level and var_6_1 >= iter_6_1.vip then
			var_6_7 = math.max(var_6_7, iter_6_1.canPass)
		end
	end

	return (math.max(math.min(var_6_7, var_6_6), var_6_5))
end

function var_0_0.getCanJumpMaxRoom()
	local var_7_0 = gGameModel.role:read("level")
	local var_7_1 = gGameModel.role:read("vip_level")
	local var_7_2 = 0

	for iter_7_0, iter_7_1 in orderCsvPairs(csv.random_tower.can_jump) do
		if var_7_0 >= iter_7_1.level and var_7_1 >= iter_7_1.vip then
			var_7_2 = math.max(var_7_2, iter_7_1.canJump)
		end
	end

	return var_7_2
end

return var_0_0
