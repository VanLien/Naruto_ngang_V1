local var_0_0 = 6
local var_0_1 = {
	isDress = function(arg_1_0)
		if arg_1_0 then
			local var_1_0 = gGameModel.chips:find(arg_1_0)

			if var_1_0 and var_1_0:read("card_db_id") then
				return true
			end
		end

		return false
	end,
	isChipPlan = function(arg_2_0)
		if type(arg_2_0) ~= "table" then
			arg_2_0 = {
				arg_2_0
			}
		end

		local var_2_0 = {}
		local var_2_1 = gGameModel.role:read("chip_plans")

		for iter_2_0, iter_2_1 in pairs(var_2_1) do
			for iter_2_2, iter_2_3 in pairs(iter_2_1.chips or {}) do
				var_2_0[iter_2_3] = true
			end
		end

		for iter_2_4, iter_2_5 in pairs(arg_2_0) do
			if var_2_0[iter_2_5] then
				return true
			end
		end

		return false
	end,
	getSuitRes = function(arg_3_0, arg_3_1)
		local var_3_0 = gChipSuitCsv[arg_3_0][2][2].suitIcon

		if arg_3_1 and arg_3_1[1][3] and not arg_3_1[2][3] then
			var_3_0 = string.gsub(var_3_0, "0.png", "1.png")
		end

		return var_3_0
	end,
	setAttrCollect = function(arg_4_0, arg_4_1)
		for iter_4_0 = 1, table.maxn(arg_4_1) do
			if arg_4_1[iter_4_0] then
				arg_4_0[iter_4_0] = arg_4_0[iter_4_0] or {}

				for iter_4_1, iter_4_2 in pairs(arg_4_1[iter_4_0]) do
					arg_4_0[iter_4_0][iter_4_1] = dataEasy.attrAddition(arg_4_0[iter_4_0][iter_4_1], iter_4_2)
				end
			end
		end

		return arg_4_0
	end
}

function var_0_1.setAttrAddition(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0

	for iter_5_0 = 1, math.huge do
		local var_5_1 = arg_5_1[string.format("attrType%d", iter_5_0)]

		if var_5_1 and var_5_1 ~= 0 then
			local var_5_2 = arg_5_1[string.format("attrNum%d", iter_5_0)]

			if arg_5_2 then
				var_5_2 = var_5_2[arg_5_2 + 1]
			end

			local var_5_3 = dataEasy.getAttrValueString(var_5_1, var_5_2)
			local var_5_4 = string.find(var_5_3, "%%") and 2 or 1

			if arg_5_3 then
				if not var_0_1.ignoreAttr(var_5_1) then
					if var_5_0 then
						errorInWindows("配置异常，csv.chip.chips[%d] 副属性不能显示 %s(%s), %s(%s)", arg_5_4.chipId, game.ATTRDEF_TABLE[var_5_0], var_5_0, game.ATTRDEF_TABLE[var_5_1], var_5_1)
					else
						if arg_5_2 then
							var_5_0 = var_5_1
						end

						local var_5_5 = clone(arg_5_4 or {})

						var_5_5.key = var_5_1
						var_5_5.val = var_5_3

						table.insert(arg_5_0, var_5_5)
					end
				end
			else
				arg_5_0[var_5_4][var_5_1] = dataEasy.attrAddition(arg_5_0[var_5_4][var_5_1], var_5_3)
			end
		else
			break
		end
	end

	return arg_5_0
end

function var_0_1.getAttrByChipId(arg_6_0)
	local var_6_0 = csv.chip.chips[arg_6_0]
	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = var_6_0.mainAttr

	if var_6_3 and var_6_3 ~= 0 then
		var_0_1.setAttrAddition(var_6_1, gChipMainAttrCsv[var_6_3][1], nil, true)
	end

	local var_6_4 = var_6_0.startNum + var_6_0.acquiredLimit

	for iter_6_0 = 1, var_6_0.startNum do
		table.insert(var_6_2, {
			name = gLanguageCsv.randomAttributes,
			val = gLanguageCsv.chipDetailInfo01
		})
	end

	for iter_6_1 = 1, var_6_0.acquiredLimit do
		table.insert(var_6_2, {
			name = gLanguageCsv.randomAttributes,
			val = string.format(gLanguageCsv.nLvUnlock, var_6_0.acquiredLevels[iter_6_1])
		})
	end

	return var_6_1, var_6_2
end

function var_0_1.getAttr(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = gGameModel.chips:find(arg_7_0):read("chip_id", "level", "now")
	local var_7_1 = arg_7_1 or var_7_0.level
	local var_7_2 = csv.chip.chips[var_7_0.chip_id]
	local var_7_3 = arg_7_2 and {} or {
		{},
		{}
	}
	local var_7_4 = arg_7_2 and {} or {
		{},
		{}
	}
	local var_7_5 = var_7_2.mainAttr

	if var_7_5 and var_7_5 ~= 0 then
		var_0_1.setAttrAddition(var_7_3, gChipMainAttrCsv[var_7_5][var_7_1], nil, arg_7_2)
	end

	local var_7_6 = var_7_0.now or {}

	for iter_7_0, iter_7_1 in ipairs(var_7_6) do
		var_0_1.setAttrAddition(var_7_4, csv.chip.libs[iter_7_1[1]], iter_7_1[3], arg_7_2, {
			chipId = var_7_0.chip_id,
			now = iter_7_1
		})
	end

	if arg_7_2 and arg_7_3 then
		local var_7_7 = var_7_2.startNum + var_7_2.acquiredLimit - itertools.size(var_7_6)

		for iter_7_2 = 1, var_7_7 do
			table.insert(var_7_4, {
				name = gLanguageCsv.randomAttributes,
				val = string.format(gLanguageCsv.nLvUnlock, var_7_2.acquiredLevels[var_7_2.acquiredLimit - var_7_7 + iter_7_2])
			})
		end
	end

	return var_7_3, var_7_4
end

function var_0_1.getAttrs(arg_8_0)
	local var_8_0 = {
		{},
		{}
	}
	local var_8_1 = {
		{},
		{}
	}
	local var_8_2 = arg_8_0

	if type(arg_8_0) ~= "table" then
		var_8_2 = gGameModel.cards:find(arg_8_0):read("chip")
	end

	for iter_8_0, iter_8_1 in pairs(var_8_2) do
		local var_8_3, var_8_4 = var_0_1.getAttr(iter_8_1)

		var_0_1.setAttrCollect(var_8_0, var_8_3)
		var_0_1.setAttrCollect(var_8_1, var_8_4)
	end

	return var_8_0, var_8_1
end

function var_0_1.getComplateSuitAttrByCard(arg_9_0)
	local var_9_0 = {}
	local var_9_1 = var_0_1.getSuitAttrByCard(arg_9_0)

	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		table.insert(var_9_0, {
			suitId = iter_9_0,
			data = {
				iter_9_1[1],
				iter_9_1[2]
			}
		})

		if iter_9_1[3] then
			table.insert(var_9_0, {
				suitId = iter_9_0,
				data = {
					iter_9_1[3],
					{
						4,
						var_0_0,
						false
					}
				}
			})
		end
	end

	return var_9_0
end

function var_0_1.getSuitAttrByCard(arg_10_0)
	local var_10_0 = {}
	local var_10_1 = {}
	local var_10_2 = arg_10_0

	if type(arg_10_0) ~= "table" then
		var_10_2 = gGameModel.cards:find(arg_10_0):read("chip")
	end

	local var_10_3 = {}
	local var_10_4 = {}
	local var_10_5 = {}

	for iter_10_0, iter_10_1 in pairs(var_10_2) do
		local var_10_6 = gGameModel.chips:find(iter_10_1):read("chip_id")
		local var_10_7 = csv.chip.chips[var_10_6]
		local var_10_8 = var_10_7.suitID
		local var_10_9 = var_10_7.quality

		var_10_3[var_10_8] = var_10_3[var_10_8] or {}

		if var_10_0[var_10_8] == nil then
			var_10_0[var_10_8] = {
				{
					2,
					var_0_0,
					false
				},
				{
					4,
					var_0_0,
					false
				}
			}
		end

		var_10_3[var_10_8][var_10_9] = var_10_3[var_10_8][var_10_9] or 0
		var_10_3[var_10_8][var_10_9] = var_10_3[var_10_8][var_10_9] + 1
		var_10_5[var_10_7.pos] = {
			isSelect = false,
			quality = var_10_9,
			suitID = var_10_8
		}
	end

	local function var_10_10(arg_11_0, arg_11_1, arg_11_2)
		for iter_11_0 = 1, 2 do
			for iter_11_1, iter_11_2 in pairs(var_10_5) do
				if arg_11_0 <= iter_11_2.quality and not iter_11_2.isSelect and iter_11_2.suitID == arg_11_2 then
					var_10_4[iter_11_1] = arg_11_1
					iter_11_2.isSelect = true

					break
				end
			end
		end
	end

	local var_10_11 = var_0_0

	for iter_10_2, iter_10_3 in pairs(var_10_3) do
		local var_10_12 = 0

		for iter_10_4 = var_0_0, 1, -1 do
			var_10_12 = var_10_12 + (iter_10_3[iter_10_4] or 0)

			if var_10_12 >= 2 and var_10_0[iter_10_2][1][3] == false then
				var_10_0[iter_10_2][1] = {
					2,
					iter_10_4,
					true
				}

				var_10_10(iter_10_4, 1, iter_10_2)
			end

			if var_10_12 >= 4 and var_10_0[iter_10_2][2][3] == false then
				var_10_0[iter_10_2][2] = {
					4,
					iter_10_4,
					true
				}

				var_10_10(iter_10_4, 2, iter_10_2)
			end

			if var_10_12 == 6 then
				var_10_0[iter_10_2][3] = {
					2,
					iter_10_4,
					true
				}

				var_10_10(iter_10_4, 3, iter_10_2)

				break
			end
		end

		if var_10_12 < 2 then
			var_10_0[iter_10_2] = nil
		end
	end

	return var_10_0, var_10_4
end

function var_0_1.getSuitAttrByChip(arg_12_0)
	local var_12_0 = gGameModel.chips:find(arg_12_0)
	local var_12_1 = var_12_0:read("card_db_id")
	local var_12_2 = var_12_0:read("chip_id")
	local var_12_3 = csv.chip.chips[var_12_2]
	local var_12_4 = var_12_3.quality

	if not var_12_1 then
		return {
			{
				2,
				var_12_4,
				false
			},
			{
				4,
				var_12_4,
				false
			}
		}
	end

	local var_12_5 = var_12_3.suitID
	local var_12_6, var_12_7 = var_0_1.getSuitAttrByCard(var_12_1)
	local var_12_8 = var_12_6[var_12_5]
	local var_12_9 = {
		{
			2,
			var_12_4,
			false
		},
		{
			4,
			var_12_4,
			false
		}
	}

	if not var_12_8 or not var_12_7[var_12_3.pos] then
		return var_12_9
	end

	for iter_12_0, iter_12_1 in pairs(var_12_8) do
		if iter_12_1[3] == false then
			iter_12_1[2] = var_12_4
		end
	end

	local var_12_10 = math.floor((var_12_7[var_12_3.pos] - 1) / 2) * 2 + 1

	var_12_9[1] = var_12_8[var_12_10] or var_12_9[1]
	var_12_9[2] = var_12_8[var_12_10 + 1] or var_12_9[2]

	return var_12_9
end

function var_0_1.getSuitAttrStr(arg_13_0, arg_13_1)
	local var_13_0, var_13_1, var_13_2 = unpack(arg_13_1)
	local var_13_3 = gChipSuitCsv[arg_13_0][var_13_1][var_13_0]
	local var_13_4 = var_13_2 and "#C0xFFFFFFFF#" or "#C0xFF9A9795#"
	local var_13_5 = var_13_0 < 4 and gLanguageCsv.chipNSuitAttr or gLanguageCsv.chipNSuitAttrEffect
	local var_13_6 = string.format("#L10##F40#%s%s #L0#", var_13_4, string.format(var_13_5, var_13_0, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_13_1]]))

	if var_13_3.skillID ~= 0 then
		var_13_6 = var_13_6 .. " "

		local var_13_7 = csv.skill[var_13_3.skillID].describe

		if not var_13_2 then
			local var_13_8 = string.split(var_13_7, "#")

			for iter_13_0, iter_13_1 in ipairs(var_13_8) do
				if iter_13_0 % 2 == 1 then
					var_13_6 = var_13_6 .. iter_13_1
				end
			end
		else
			var_13_6 = var_13_6 .. var_13_7
		end
	else
		for iter_13_2 = 1, math.huge do
			local var_13_9 = var_13_3["attrType" .. iter_13_2]

			if var_13_9 and var_13_9 ~= 0 then
				local var_13_10 = dataEasy.getAttrValueString(var_13_9, var_13_3["attrNum" .. iter_13_2])

				if var_13_2 then
					var_13_6 = string.format("%s %s #C0xFF5C9970#+%s#C0xFFFFFFFF#", var_13_6, getLanguageAttr(var_13_9), var_13_10)
				else
					var_13_6 = string.format("%s %s +%s", var_13_6, getLanguageAttr(var_13_9), var_13_10)
				end
			else
				break
			end
		end
	end

	return var_13_6
end

function var_0_1.getResonanceAttr(arg_14_0)
	local var_14_0 = 1
	local var_14_1 = 2
	local var_14_2 = {}
	local var_14_3 = arg_14_0

	if type(arg_14_0) ~= "table" then
		var_14_3 = gGameModel.cards:find(arg_14_0):read("chip")
	end

	local var_14_4 = {
		{
			getVal = function(arg_15_0)
				local var_15_0 = gGameModel.chips:find(arg_15_0):read("chip_id")

				return csv.chip.chips[var_15_0].quality
			end,
			func = function(arg_16_0, arg_16_1, arg_16_2)
				local var_16_0 = 0

				for iter_16_0, iter_16_1 in pairs(arg_16_0) do
					if arg_16_2 <= iter_16_0 then
						var_16_0 = var_16_0 + iter_16_1
					end
				end

				return arg_16_1 <= var_16_0
			end
		},
		{
			getVal = function(arg_17_0)
				return gGameModel.chips:find(arg_17_0):read("level")
			end,
			func = function(arg_18_0, arg_18_1, arg_18_2)
				local var_18_0 = 0

				for iter_18_0, iter_18_1 in pairs(arg_18_0) do
					if arg_18_2 <= iter_18_0 then
						var_18_0 = var_18_0 + iter_18_1
					end
				end

				return arg_18_1 <= var_18_0
			end
		}
	}

	for iter_14_0, iter_14_1 in pairs(gChipResonanceCsv) do
		if var_14_4[iter_14_0] then
			local var_14_5 = {}

			for iter_14_2, iter_14_3 in pairs(var_14_3) do
				local var_14_6 = var_14_4[iter_14_0].getVal(iter_14_3)

				var_14_5[var_14_6] = (var_14_5[var_14_6] or 0) + 1
			end

			for iter_14_4, iter_14_5 in pairs(iter_14_1) do
				for iter_14_6, iter_14_7 in ipairs(iter_14_5) do
					if var_14_4[iter_14_0].func(var_14_5, iter_14_7.param[1], iter_14_7.param[2]) then
						table.insert(var_14_2, {
							iter_14_7.id,
							iter_14_7.groupID
						})

						break
					end
				end
			end
		end
	end

	return var_14_2
end

function var_0_1.ignoreAttr(arg_19_0)
	return itertools.include({
		game.ATTRDEF_ENUM_TABLE.specialDamage,
		game.ATTRDEF_ENUM_TABLE.specialDefence,
		game.ATTRDEF_ENUM_TABLE.specialDefenceIgnore
	}, arg_19_0)
end

function var_0_1.getAttrName(arg_20_0)
	if arg_20_0 == game.ATTRDEF_ENUM_TABLE.damage then
		return gLanguageCsv.attrDoubleAttack
	end

	if arg_20_0 == game.ATTRDEF_ENUM_TABLE.defence then
		return gLanguageCsv.attrDoubleDefence
	end

	if arg_20_0 == game.ATTRDEF_ENUM_TABLE.defenceIgnore then
		return gLanguageCsv.attrDoubleDefenceIgnore
	end

	if arg_20_0 == 0 then
		return gLanguageCsv.basicAttribute
	end

	return getLanguageAttr(arg_20_0)
end

function var_0_1.getBaseAttr(arg_21_0)
	local var_21_0 = {}
	local var_21_1 = {}

	for iter_21_0, iter_21_1 in pairs(game.ONESELF_NATURE_ENUM_TABLE) do
		var_21_0[iter_21_1] = 0
	end

	for iter_21_2, iter_21_3 in ipairs(arg_21_0) do
		if var_21_0[iter_21_3.key] == 0 then
			var_21_0[iter_21_3.key] = iter_21_3.val
		else
			table.insert(var_21_1, iter_21_3)
		end
	end

	local var_21_2 = -1
	local var_21_3 = true

	for iter_21_4, iter_21_5 in pairs(var_21_0) do
		if var_21_2 == -1 then
			var_21_2 = iter_21_5
		elseif var_21_2 ~= iter_21_5 or var_21_2 == 0 then
			var_21_3 = false

			break
		end
	end

	if var_21_3 then
		table.insert(var_21_1, {
			key = 0,
			base = true,
			val = var_21_2
		})

		return var_21_1
	end

	return arg_21_0
end

function var_0_1.getAttrsValue(arg_22_0)
	if type(arg_22_0) ~= "table" then
		arg_22_0 = {
			arg_22_0
		}
	end

	local var_22_0, var_22_1 = var_0_1.getAttrs(arg_22_0)

	var_0_1.setAttrCollect(var_22_0, var_22_1)

	return var_22_0
end

local function var_0_2(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0 and not arg_23_1 then
		return
	end

	local var_23_0 = arg_23_0
	local var_23_1 = arg_23_1

	if not arg_23_0 then
		arg_23_0 = "- - - -"
		var_23_0 = arg_23_2 and "0%" or "0"
	end

	if not arg_23_1 then
		arg_23_1 = "- - - -"
		var_23_1 = arg_23_2 and "0%" or "0"
	end

	local var_23_2 = tonumber(arg_23_2 and string.sub(var_23_0, 1, #var_23_0 - 1) or var_23_0)
	local var_23_3 = tonumber(arg_23_2 and string.sub(var_23_1, 1, #var_23_1 - 1) or var_23_1)

	if var_23_2 > 0 then
		arg_23_0 = "+" .. arg_23_0
	end

	if var_23_3 > 0 then
		arg_23_1 = "+" .. arg_23_1
	end

	local var_23_4 = var_23_2 - var_23_3
	local var_23_5 = "- - - -"

	if var_23_4 > 0 then
		var_23_5 = "+" .. var_23_4
	elseif var_23_4 < 0 then
		var_23_5 = var_23_4
	end

	if arg_23_2 then
		var_23_5 = var_23_5 .. "%"
	end

	return {
		arg_23_0,
		arg_23_1,
		var_23_4,
		var_23_5
	}
end

function var_0_1.getAttrsValueCmp(arg_24_0, arg_24_1)
	local var_24_0 = var_0_1.getAttrsValue(arg_24_0)
	local var_24_1 = var_0_1.getAttrsValue(arg_24_1)
	local var_24_2 = {
		{},
		{}
	}

	for iter_24_0 = 1, 2 do
		if var_24_0[iter_24_0] then
			for iter_24_1, iter_24_2 in pairs(var_24_0[iter_24_0]) do
				local var_24_3 = var_24_1[iter_24_0] and var_24_1[iter_24_0][iter_24_1]

				var_24_2[iter_24_0][iter_24_1] = var_0_2(iter_24_2, var_24_3, iter_24_0 == 2)
			end
		end

		if var_24_1[iter_24_0] then
			for iter_24_3, iter_24_4 in pairs(var_24_1[iter_24_0]) do
				local var_24_4 = var_24_0[iter_24_0] and var_24_0[iter_24_0][iter_24_3]

				if not var_24_4 then
					var_24_2[iter_24_0][iter_24_3] = var_0_2(var_24_4, iter_24_4, iter_24_0 == 2)
				end
			end
		end
	end

	return var_24_2
end

function var_0_1.getCardDBID(arg_25_0)
	if itertools.size(arg_25_0) == 0 then
		return
	end

	local var_25_0 = gGameModel.role:read("cards")

	for iter_25_0, iter_25_1 in ipairs(var_25_0) do
		local var_25_1 = gGameModel.cards:find(iter_25_1):read("chip")

		if itertools.size(var_25_1) > 0 and itertools.equal(var_25_1, arg_25_0) then
			return iter_25_1
		end
	end
end

return var_0_1
