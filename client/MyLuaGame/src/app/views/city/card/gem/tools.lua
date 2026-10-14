local var_0_0 = {}

function var_0_0.equipGem(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if var_0_0.isSlotLocked(arg_1_0, arg_1_1) then
		gGameUI:showTip(gLanguageCsv.notUnlock)

		return
	end

	local var_1_0 = gGameModel.gems:find(arg_1_2):read("gem_id")
	local var_1_1 = dataEasy.getCfgByKey(var_1_0)
	local var_1_2 = var_0_0.suitTypeMap(arg_1_0)

	if not gGameModel.gems:find(arg_1_2):read("card_db_id") and var_1_2[var_1_1.suitID] and var_1_2[var_1_1.suitID][var_1_1.suitNo] or var_1_2[var_1_0] then
		gGameUI:showTip(gLanguageCsv.sameGemID)

		return
	end

	gGameApp:requestServer("/game/gem/equip", function(arg_2_0)
		if arg_1_3 then
			arg_1_3()
		end

		gGameUI:showTip(gLanguageCsv.inlaySuccess)
	end, arg_1_0, arg_1_2, arg_1_1)
end

function var_0_0.swapGem(arg_3_0, arg_3_1, arg_3_2)
	if var_0_0.isSlotLocked(arg_3_0, arg_3_1) then
		gGameUI:showTip(gLanguageCsv.notUnlock)

		return
	end

	local var_3_0 = gGameModel.cards:find(arg_3_0):read("gems")[arg_3_1]
	local var_3_1 = gGameModel.gems:find(arg_3_2):read("gem_id")
	local var_3_2 = dataEasy.getCfgByKey(var_3_1)
	local var_3_3 = gGameModel.gems:find(var_3_0):read("card_db_id")
	local var_3_4 = var_0_0.suitTypeMap(var_3_3)

	if not gGameModel.gems:find(arg_3_2):read("card_db_id") and var_3_4[var_3_2.suitID] and var_3_4[var_3_2.suitID][var_3_2.suitNo] and var_3_4[var_3_2.suitID][var_3_2.suitNo] ~= arg_3_1 or var_3_4[var_3_1] then
		gGameUI:showTip(gLanguageCsv.sameGemID)

		return
	end

	gGameApp:requestServer("/game/gem/swap", function()
		gGameUI:showTip(gLanguageCsv.exchange2Success)
	end, var_3_0, arg_3_2)
end

function var_0_0.unEquipGem(arg_5_0, arg_5_1)
	local var_5_0 = gGameModel.cards:find(arg_5_0):read("gems")

	gGameApp:requestServer("/game/gem/unload", function()
		gGameUI:showTip(gLanguageCsv.dischargeSuccess)
	end, {
		var_5_0[arg_5_1]
	})
end

function var_0_0.suitTypeMap(arg_7_0)
	local var_7_0 = gGameModel.cards:find(arg_7_0):read("gems")
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		local var_7_2 = gGameModel.gems:find(iter_7_1):read("gem_id")
		local var_7_3 = dataEasy.getCfgByKey(var_7_2)

		if var_7_3.suitID and var_7_3.suitNo then
			if not var_7_1[var_7_3.suitID] then
				var_7_1[var_7_3.suitID] = {}
			end

			var_7_1[var_7_3.suitID][var_7_3.suitNo] = iter_7_0
		else
			var_7_1[var_7_2] = iter_7_0
		end
	end

	return var_7_1
end

function var_0_0.isSlotLocked(arg_8_0, arg_8_1)
	local var_8_0 = csv.cards[gGameModel.cards:find(arg_8_0):read("card_id")]
	local var_8_1 = gGemPosCsv[var_8_0.gemPosSeqID][arg_8_1].openCondition

	if var_8_1[1] == 1 then
		if gGameModel.role:read("level") < var_8_1[2] then
			return true, string.format(gLanguageCsv.openLv, var_8_1[2])
		end
	elseif var_8_1[1] == 2 then
		local var_8_2, var_8_3 = dataEasy.getQuality(var_8_1[2])

		return true, string.format(gLanguageCsv.openAdvance, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_8_2]] .. var_8_3)
	end

	return false
end

function var_0_0.moveGem(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if var_0_0.isSlotLocked(arg_9_0, arg_9_1) then
		gGameUI:showTip(gLanguageCsv.notUnlock)

		if arg_9_3 then
			arg_9_3()
		end

		return
	end

	gGameApp:requestServer("/game/gem/pos/change", function()
		gGameUI:showTip(gLanguageCsv.exchange2Success)
	end, arg_9_2, arg_9_1)
end

return var_0_0
