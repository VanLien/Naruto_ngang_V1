return {
	effectShow = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = math.max(1, arg_1_2.advance)
		local var_1_1 = {}

		for iter_1_0, iter_1_1 in pairs(arg_1_2.cfg.effect) do
			local var_1_2 = csv.explorer.explorer_effect[iter_1_1]
			local var_1_3

			if var_1_2.skillID then
				local var_1_4 = csv.skill[var_1_2.skillID]
				local var_1_5 = string.format(var_1_2.effectDesc, eval.doMixedFormula(var_1_4.describe, {
					skillLevel = var_1_0,
					math = math
				}, nil))

				var_1_3 = "#C0x57472e#" .. var_1_5
			elseif var_1_2.attrType1 and var_1_2.attrType2 and var_1_2.attrType3 and var_1_2.attrType4 and var_1_2.attrType5 and var_1_2.attrType6 then
				local var_1_6 = dataEasy.getAttrValueString(var_1_2.attrType1, var_1_2.attrNum1[var_1_0])

				var_1_3 = string.format(var_1_2.effectDesc, var_1_6)
			else
				local var_1_7 = {}

				for iter_1_2 = 1, 6 do
					if var_1_2["attrType" .. iter_1_2] and var_1_2["attrNum" .. iter_1_2] then
						local var_1_8 = getLanguageAttr(var_1_2["attrType" .. iter_1_2])
						local var_1_9 = dataEasy.getAttrValueString(var_1_2["attrType" .. iter_1_2], var_1_2["attrNum" .. iter_1_2][var_1_0])

						table.insert(var_1_7, var_1_8)
						table.insert(var_1_7, var_1_9)
					end
				end

				var_1_3 = string.format(var_1_2.effectDesc, unpack(var_1_7))
			end

			table.insert(var_1_1, {
				str = var_1_3
			})
		end

		beauty.textScroll({
			margin = 20,
			align = "left",
			isRich = true,
			list = arg_1_0,
			effect = {
				color = ui.COLORS.NORMAL.DEFAULT
			},
			strs = var_1_1
		})

		local var_1_10 = {}

		for iter_1_3, iter_1_4 in ipairs(arg_1_2.cfg.extraEff) do
			local var_1_11 = csv.explorer.explorer_effect[iter_1_4]

			if var_1_11.skillID then
				local var_1_12 = csv.skill[var_1_11.skillID]
				local var_1_13 = string.format(str, eval.doMixedFormula(var_1_12.describe, {
					skillLevel = var_1_0,
					math = math
				}, nil))

				table.insert(var_1_10, {
					str = "#C0x5B545B#" .. var_1_13
				})
			else
				local var_1_14 = {}

				for iter_1_5 = 1, 6 do
					if var_1_11["attrType" .. iter_1_5] and var_1_11["attrNum" .. iter_1_5] then
						local var_1_15 = getLanguageAttr(var_1_11["attrType" .. iter_1_5])
						local var_1_16 = dataEasy.getAttrValueString(var_1_11["attrType" .. iter_1_5], var_1_11["attrNum" .. iter_1_5][var_1_0])

						table.insert(var_1_14, var_1_15)
						table.insert(var_1_14, var_1_16)
					end
				end

				local var_1_17 = string.format(var_1_11.effectDesc, unpack(var_1_14))

				table.insert(var_1_10, {
					str = var_1_17
				})
			end
		end

		beauty.textScroll({
			margin = 20,
			align = "left",
			isRich = true,
			list = arg_1_1,
			effect = {
				color = ui.COLORS.NORMAL.DEFAULT
			},
			strs = var_1_10
		})

		for iter_1_6, iter_1_7 in ipairs(var_1_10) do
			local var_1_18 = arg_1_1:get(iter_1_6, "label")

			var_1_18:setCascadeOpacityEnabled(true)

			if var_1_0 >= arg_1_2.cfg.extraEffCod[iter_1_6] then
				var_1_18:setOpacity(255)
			else
				var_1_18:setOpacity(130)
			end
		end
	end,
	getMinComponentLevel = function(arg_2_0)
		local var_2_0 = 100

		for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
			var_2_0 = math.min(var_2_0, iter_2_1.level)
		end

		return var_2_0
	end
}
