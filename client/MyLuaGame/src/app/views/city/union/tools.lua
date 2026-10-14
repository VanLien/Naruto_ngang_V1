return {
	canEnterBuilding = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = true
		local var_1_1 = gGameModel.union:read("level")

		if not arg_1_0 or not gUnionFeatureCsv[arg_1_0] or var_1_1 < gUnionFeatureCsv[arg_1_0] then
			var_1_0 = false

			if not arg_1_2 then
				local var_1_2 = string.format(gLanguageCsv.unionUnlockLevel, gUnionFeatureCsv[arg_1_0])

				gGameUI:showTip(var_1_2)
			end

			return var_1_0
		end

		if not arg_1_1 and dataEasy.notUseUnionBuild() then
			var_1_0 = false

			if not arg_1_2 then
				gGameUI:showTip(gLanguageCsv.cannotUseBuilding)
			end

			return var_1_0
		end

		return var_1_0
	end,
	currentOpenFuben = function()
		local var_2_0 = time.getTimeTable()

		if var_2_0.wday == 1 then
			return "weekError"
		end

		local var_2_1 = var_2_0.hour * 100 + var_2_0.min

		if var_2_1 < 930 or var_2_1 > 2330 then
			return "timeError"
		end

		return "open"
	end
}
