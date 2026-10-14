local var_0_0 = {
	isExclusive = function(arg_1_0)
		local var_1_0 = false
		local var_1_1 = false
		local var_1_2 = type(arg_1_0.dbId) == "table" and arg_1_0.dbId[1] or arg_1_0.dbId

		if var_1_2 then
			local var_1_3 = gGameModel.held_items:find(var_1_2)

			if var_1_3 and var_1_3:read("card_db_id") then
				var_1_0 = true
			end
		end

		local var_1_4 = csv.held_item.items[arg_1_0.csvId]

		if var_1_4 and itertools.size(var_1_4.exclusiveCards) > 0 then
			var_1_1 = true
		end

		return var_1_0, var_1_1
	end,
	insertColor = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		arg_2_5 = arg_2_5 or "#C0x57472E#"
		arg_2_3 = arg_2_3 or 1

		local var_2_0 = true
		local var_2_1 = ""
		local var_2_2 = string.split(arg_2_0, "%s")
		local var_2_3 = #var_2_2

		for iter_2_0, iter_2_1 in ipairs(var_2_2) do
			if (arg_2_4 and var_2_0 or not arg_2_4) and arg_2_3 <= iter_2_0 and iter_2_0 < var_2_3 then
				var_2_1 = var_2_1 .. iter_2_1 .. arg_2_1 .. "%s" .. arg_2_5

				if arg_2_4 then
					var_2_0 = false
				end
			else
				var_2_1 = var_2_1 .. iter_2_1 .. "%s"
			end
		end

		return (string.sub(var_2_1, 1, string.len(var_2_1) - 2))
	end,
	getRellyAdvance = function(arg_3_0, arg_3_1)
		local var_3_0 = csv.held_item.items[arg_3_0]

		if not var_3_0 or not arg_3_1 then
			return arg_3_1
		end

		local var_3_1 = {}

		for iter_3_0 = 1, math.huge do
			if not var_3_0["effect" .. iter_3_0] or var_3_0["effect" .. iter_3_0] == 0 then
				break
			end

			local var_3_2 = var_3_0[string.format("effect%dLevelAdvSeq", iter_3_0)]

			for iter_3_1, iter_3_2 in ipairs(var_3_2) do
				table.insert(var_3_1, iter_3_2)
			end
		end

		if itertools.include(var_3_1, arg_3_1) then
			return arg_3_1
		end

		table.sort(var_3_1)

		local var_3_3 = arg_3_1

		for iter_3_3, iter_3_4 in ipairs(var_3_1) do
			if arg_3_1 < iter_3_4 then
				var_3_3 = var_3_1[iter_3_3 - 1]

				break
			end
		end

		return var_3_3
	end,
	insertSkillDescColor = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = string.split(arg_4_0, "$")
		local var_4_1 = ""

		for iter_4_0, iter_4_1 in pairs(var_4_0) do
			local var_4_2 = clone(iter_4_1)

			if string.find(var_4_2, "skillLevel") then
				local var_4_3 = ""

				if var_4_0[iter_4_0 + 1] and string.find(var_4_0[iter_4_0 + 1], "^%%") then
					var_4_3 = "%"
					var_4_0[iter_4_0 + 1] = string.gsub(var_4_0[iter_4_0 + 1], "^%%", "")
				end

				var_4_2 = string.format("%s$%s$%s%s", arg_4_1, var_4_2, var_4_3, arg_4_2)
			end

			var_4_1 = var_4_1 .. var_4_2
		end

		return var_4_1
	end
}

function var_0_0.getStrinigByData(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1.cfg
	local var_5_1 = var_0_0.getRellyAdvance(arg_5_1.csvId, arg_5_1.advance)
	local var_5_2 = var_5_0["effect" .. arg_5_0]
	local var_5_3 = var_5_0[string.format("effect%dLevelAdvSeq", arg_5_0)]
	local var_5_4 = 0
	local var_5_5 = var_5_1 + 1
	local var_5_6 = csvSize(var_5_3)

	for iter_5_0, iter_5_1 in ipairs(var_5_3) do
		if var_5_1 < iter_5_1 then
			var_5_4 = iter_5_0 - 1

			break
		elseif var_5_1 == iter_5_1 or iter_5_0 == var_5_6 then
			var_5_4 = iter_5_0

			break
		end
	end

	local var_5_7 = csv.held_item.effect[var_5_2]
	local var_5_8 = var_5_7.desc
	local var_5_9 = {}
	local var_5_10 = 1

	if var_5_7.exclusiveCards[1] then
		local var_5_11 = var_5_7.exclusiveCards[1]
		local var_5_12 = csv.cards[var_5_11]
		local var_5_13 = csv.unit[var_5_12.unitID]

		table.insert(var_5_9, var_5_12.name)

		local var_5_14 = var_5_13.natureType
		local var_5_15 = ui.ATTRCOLOR[game.NATURE_TABLE[var_5_14]]

		var_5_8 = var_0_0.insertColor(var_5_8, var_5_15, true, var_5_10, true, arg_5_2)
		var_5_10 = var_5_10 + 1
	end

	local var_5_16 = "#C0x60c456#"

	if var_5_7.type == 1 then
		for iter_5_2 = 1, 100 do
			if not var_5_7["attrNum" .. iter_5_2] then
				break
			end

			local var_5_17 = var_5_7["attrNum" .. iter_5_2][var_5_4]
			local var_5_18 = var_5_7["attrType" .. iter_5_2]

			table.insert(var_5_9, dataEasy.getAttrValueString(var_5_18, var_5_17))
		end
	elseif var_5_7.type == 2 then
		local var_5_19 = csv.skill[var_5_7.skillID].describe
		local var_5_20 = var_0_0.insertSkillDescColor(var_5_19, "#C0x60c456#", arg_5_2)

		table.insert(var_5_9, eval.doMixedFormula(var_5_20, {
			skillLevel = var_5_5,
			math = math
		}))
	end

	local var_5_21 = var_0_0.insertColor(var_5_8, var_5_16, false, var_5_10, false, arg_5_2)
	local var_5_22 = string.find(var_5_21, "%%s")

	if #var_5_9 <= 0 and var_5_22 then
		return
	end

	return string.format(var_5_21, unpack(var_5_9))
end

function var_0_0.getCardNameColor(arg_6_0)
	local var_6_0 = gGameModel.cards:find(arg_6_0):read("advance")
	local var_6_1, var_6_2 = dataEasy.getQuality(var_6_0)
	local var_6_3 = ui.COLORS.QUALITY_OUTLINE[var_6_1]

	return ui.QUALITYCOLOR[var_6_1], var_6_2
end

return var_0_0
