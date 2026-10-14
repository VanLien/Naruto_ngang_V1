return {
	bossType = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = "#I"
		local var_1_1 = "-70-66#"
		local var_1_2 = arg_1_0.specialLimitType
		local var_1_3 = arg_1_0.specialLimitParameter
		local var_1_4 = {
			function()
				local var_2_0 = var_1_3.rarities or {}
				local var_2_1 = ""

				for iter_2_0, iter_2_1 in csvMapPairs(var_2_0) do
					var_2_1 = var_2_1 .. var_1_0 .. ui.RARITY_ICON[iter_2_1] .. var_1_1 .. " "
				end

				local var_2_2 = string.format(arg_1_0.desc, var_2_1)

				arg_1_2(var_2_2)
			end,
			function()
				local var_3_0 = var_1_3.natureTypes or {}
				local var_3_1 = ""

				for iter_3_0, iter_3_1 in csvMapPairs(var_3_0) do
					var_3_1 = var_3_1 .. var_1_0 .. ui.ATTR_ICON[iter_3_1] .. var_1_1
				end

				local var_3_2 = string.format(arg_1_0.desc, var_3_1)

				arg_1_2(var_3_2)
			end,
			function()
				local var_4_0 = var_1_3.rarities or {}
				local var_4_1 = var_1_3.count or 0
				local var_4_2 = ""

				for iter_4_0, iter_4_1 in csvMapPairs(var_4_0) do
					var_4_2 = var_4_2 .. var_1_0 .. ui.RARITY_ICON[iter_4_1] .. var_1_1 .. " "
				end

				local var_4_3 = string.format(arg_1_0.desc, var_4_2, var_4_1)

				arg_1_2(var_4_3)
			end,
			function()
				local var_5_0 = var_1_3.cardIDs or {}
				local var_5_1 = ""
				local var_5_2 = csv.cards

				for iter_5_0, iter_5_1 in csvMapPairs(var_5_0) do
					var_5_1 = var_5_1 .. csv.cards[iter_5_1].name .. ","
				end

				local var_5_3 = string.format(arg_1_0.desc, var_5_1)

				arg_1_2(var_5_3)
			end,
			function()
				local var_6_0 = ""

				for iter_6_0, iter_6_1 in csvMapPairs(var_1_3.cardIDs) do
					local var_6_1 = csv.cards[iter_6_1].name

					var_6_0 = var_6_0 .. var_6_1

					if iter_6_0 ~= #var_1_3.cardIDs then
						var_6_0 = var_6_0 .. gLanguageCsv.pauseMark
					end
				end

				local var_6_2 = arg_1_1.gateName
				local var_6_3 = var_1_3.skillIDs[1]
				local var_6_4 = csv.skill[var_6_3].skillName
				local var_6_5 = string.format(arg_1_0.desc, var_6_0, var_6_2, var_6_4)

				arg_1_2(var_6_5, var_6_3)
			end,
			function()
				local var_7_0 = ""

				for iter_7_0, iter_7_1 in csvMapPairs(var_1_3.cardIDs) do
					local var_7_1 = csv.cards[iter_7_1].name

					var_7_0 = var_7_0 .. var_7_1

					if iter_7_0 ~= #var_1_3.cardIDs then
						var_7_0 = var_7_0 .. gLanguageCsv.pauseMark
					end
				end

				local var_7_2 = arg_1_1.gateName
				local var_7_3 = var_1_3.skillIDs[1]
				local var_7_4 = csv.skill[var_7_3]
				local var_7_5 = string.format(arg_1_0.desc, var_7_0, var_7_2, var_7_4.skillName)

				arg_1_2(var_7_5, var_7_3)
			end,
			function()
				local var_8_0 = ""

				for iter_8_0, iter_8_1 in csvMapPairs(var_1_3.rarities) do
					var_8_0 = string.format("%s#I%s-64-60# ", var_8_0, ui.RARITY_ICON[iter_8_1])
				end

				local var_8_1 = arg_1_1.gateName
				local var_8_2 = var_1_3.skillIDs[1]
				local var_8_3 = csv.skill[var_8_2].skillName
				local var_8_4 = string.format(arg_1_0.desc, var_8_0, var_1_3.count, var_8_1, var_8_3)

				arg_1_2(var_8_4, var_8_2)
			end,
			function()
				local var_9_0 = ""

				for iter_9_0, iter_9_1 in csvMapPairs(var_1_3.natureTypes) do
					var_9_0 = string.format("%s#I%s-64-60# ", var_9_0, ui.ATTR_ICON[iter_9_1])
				end

				local var_9_1 = arg_1_1.gateName
				local var_9_2 = var_1_3.skillIDs[1]
				local var_9_3 = csv.skill[var_9_2].skillName
				local var_9_4 = string.format(arg_1_0.desc, var_9_0, var_1_3.count, var_9_1, var_9_3)

				arg_1_2(var_9_4, var_9_2)
			end,
			function()
				local var_10_0 = ""

				for iter_10_0, iter_10_1 in csvMapPairs(var_1_3.natureTypes) do
					var_10_0 = string.format("%s#I%s-64-60# ", var_10_0, ui.ATTR_ICON[iter_10_1])
				end

				local var_10_1 = arg_1_1.gateName
				local var_10_2 = var_1_3.skillIDs[1]
				local var_10_3 = csv.skill[var_10_2].skillName
				local var_10_4 = string.format(arg_1_0.desc, var_10_0, var_10_1, var_10_3)

				arg_1_2(var_10_4, var_10_2)
			end
		}

		if var_1_4[var_1_2] then
			var_1_4[var_1_2]()
		end
	end
}
