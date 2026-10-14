local var_0_0 = {}
local var_0_1 = {
	designated = 2,
	itself = 1,
	allTeam = 3
}

var_0_0.STAGE_OPEN_STATE = {
	preview = 2,
	open = 1,
	close = 3
}
var_0_0.MAXLEVEL = 8
var_0_0.MAXSTAGE = 8

function var_0_0.getLevelCfg(arg_1_0, arg_1_1, arg_1_2)
	if gZawakeLevelsCsv[arg_1_0] and gZawakeLevelsCsv[arg_1_0][arg_1_1] then
		return gZawakeLevelsCsv[arg_1_0][arg_1_1][arg_1_2]
	end
end

function var_0_0.getResetCostItems(arg_2_0, arg_2_1)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		for iter_2_2 = 1, iter_2_1 do
			local var_2_1 = var_0_0.getLevelCfg(arg_2_0, iter_2_0, iter_2_2)

			if not var_2_1 then
				break
			end

			for iter_2_3, iter_2_4 in csvMapPairs(var_2_1.costItemMap) do
				var_2_0[iter_2_3] = (var_2_0[iter_2_3] or 0) + iter_2_4
			end
		end
	end

	for iter_2_5, iter_2_6 in pairs(var_2_0) do
		var_2_0[iter_2_5] = math.ceil(iter_2_6 * gCommonConfigCsv.zawakeResetOneKeyRatio)
	end

	return var_2_0
end

function var_0_0.getCardByZawakeID(arg_3_0)
	local var_3_0 = gGameModel.role:read("pokedex")
	local var_3_1 = gGameModel.role:read("cards")
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in ipairs(var_3_1) do
		local var_3_3 = gGameModel.cards:find(iter_3_1)
		local var_3_4 = var_3_3:read("card_id")
		local var_3_5 = var_3_3:read("fighting_point")
		local var_3_6 = csv.cards[var_3_4].zawakeID

		if var_3_6 > 0 then
			var_3_2[var_3_6] = var_3_2[var_3_6] or {}

			if not var_3_2[var_3_6].fightPoint or var_3_5 > var_3_2[var_3_6].fightPoint then
				var_3_2[var_3_6].fightPoint = var_3_5
				var_3_2[var_3_6].dbId = iter_3_1
				var_3_2[var_3_6].cardId = var_3_4
			end
		end
	end

	if var_3_2[arg_3_0] then
		local var_3_7 = var_3_2[arg_3_0].cardId

		return {
			cardId = var_3_7,
			cfg = gCardsZawake[arg_3_0][var_3_7],
			zawakeID = arg_3_0,
			dbId = var_3_2[arg_3_0].dbId
		}
	end

	local var_3_8

	for iter_3_2, iter_3_3 in pairs(gCardsZawake[arg_3_0]) do
		if var_3_0[iter_3_2] then
			var_3_8 = math.max(var_3_8 or 0, iter_3_2)
		end
	end

	return {
		cardId = var_3_8,
		cfg = gCardsZawake[arg_3_0][var_3_8],
		zawakeID = arg_3_0
	}
end

function var_0_0.getFightPointMaxCard()
	local var_4_0 = gGameModel.role:read("cards")
	local var_4_1 = {}
	local var_4_2
	local var_4_3

	for iter_4_0, iter_4_1 in ipairs(var_4_0) do
		local var_4_4 = gGameModel.cards:find(iter_4_1)
		local var_4_5 = var_4_4:read("card_id")
		local var_4_6 = var_4_4:read("fighting_point")
		local var_4_7 = csv.cards[var_4_5].zawakeID

		if var_0_0.isOpenByStage(var_4_7) and (not var_4_2 or var_4_2 < var_4_6) then
			var_4_2 = var_4_6
			var_4_3 = var_4_7
		end
	end

	return var_4_3
end

function var_0_0.getAllCards()
	local var_5_0 = gGameModel.role:read("cards")
	local var_5_1 = gGameModel.role:read("pokedex")
	local var_5_2 = {}
	local var_5_3 = {}

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		local var_5_4 = gGameModel.cards:find(iter_5_1)
		local var_5_5 = var_5_4:read("card_id")
		local var_5_6 = var_5_4:read("fighting_point")
		local var_5_7 = csv.cards[var_5_5].zawakeID

		if var_5_7 > 0 and var_5_6 > (var_5_3[var_5_7] and var_5_3[var_5_7].fightPoint or 0) then
			var_5_3[var_5_7] = {
				cardId = var_5_5,
				fightPoint = var_5_6
			}
		end
	end

	for iter_5_2, iter_5_3 in pairs(gCardsZawake) do
		if var_0_0.isOpenByStage(iter_5_2) then
			if var_5_3[iter_5_2] then
				var_5_2[iter_5_2] = {
					cfg = gCardsZawake[iter_5_2][var_5_3[iter_5_2].cardId],
					maxFightPoint = var_5_3[iter_5_2].fightPoint
				}
			else
				local var_5_8

				for iter_5_4, iter_5_5 in pairs(iter_5_3) do
					if var_5_1[iter_5_4] then
						var_5_8 = math.max(var_5_8 or 0, iter_5_4)
					end
				end

				if var_5_8 then
					var_5_2[iter_5_2] = {
						maxFightPoint = 0,
						cfg = gCardsZawake[iter_5_2][var_5_8]
					}
				end
			end
		end
	end

	return var_5_2
end

function var_0_0.getAttrAddTypeStr(arg_6_0, arg_6_1)
	if arg_6_0 == var_0_1.designated then
		return string.format("[ %s ]", string.format(gLanguageCsv.zawakeFirstAttr, gLanguageCsv[game.NATURE_TABLE[arg_6_1]]))
	end

	if arg_6_0 == var_0_1.allTeam then
		return string.format("[ %s ]", gLanguageCsv.allSprite)
	end

	return gLanguageCsv.skinBuff1
end

function var_0_0.getAttrStr(arg_7_0, arg_7_1)
	local var_7_0 = ""
	local var_7_1 = ""

	if arg_7_0.attrAddType == var_0_1.designated then
		var_7_1 = gLanguageCsv[game.NATURE_TABLE[arg_7_0.natureType]] .. gLanguageCsv.xi
	else
		var_7_1 = gLanguageCsv.allElves
	end

	local var_7_2 = {}
	local var_7_3 = {}

	for iter_7_0, iter_7_1 in pairs(game.ONESELF_NATURE_ENUM_TABLE) do
		var_7_2[iter_7_1] = 0
	end

	for iter_7_2 = 1, math.huge do
		local var_7_4 = arg_7_0["attrType" .. iter_7_2]
		local var_7_5 = arg_7_0["attrNum" .. iter_7_2]

		if var_7_4 == nil or var_7_4 == 0 then
			break
		end

		var_7_3[var_7_4] = var_7_5
		var_7_2[var_7_4] = var_7_5
	end

	if (function()
		local var_8_0 = -1

		for iter_8_0, iter_8_1 in pairs(var_7_2) do
			if var_8_0 ~= -1 and var_8_0 ~= iter_8_1 then
				return false
			end

			var_8_0 = iter_8_1
		end

		return true
	end)() then
		if arg_7_1 then
			var_7_0 = string.format("#C0xB7B09E#%s %s+%s", var_7_1, gLanguageCsv.basicAttribute, arg_7_0.attrNum1)
		else
			var_7_0 = string.format("#C0x5B545B#%s %s#C0x60C456#+%s", var_7_1, gLanguageCsv.basicAttribute, arg_7_0.attrNum1)
		end
	else
		if arg_7_1 then
			var_7_0 = var_7_0 .. string.format("#C0xB7B09E#%s ", var_7_1)
		else
			var_7_0 = var_7_0 .. string.format("#C0x5B545B#%s ", var_7_1)
		end

		for iter_7_3, iter_7_4 in pairs(var_7_3) do
			if arg_7_1 then
				var_7_0 = var_7_0 .. string.format("#C0xB7B09E#%s+%s ", getLanguageAttr(iter_7_3), dataEasy.getAttrValueString(iter_7_3, iter_7_4))
			else
				var_7_0 = var_7_0 .. string.format("#C0x5B545B#%s#C0x60C456#+%s ", getLanguageAttr(iter_7_3), dataEasy.getAttrValueString(iter_7_3, iter_7_4))
			end
		end
	end

	return var_7_0
end

function var_0_0.getStagesCfg(arg_9_0, arg_9_1)
	local var_9_0 = var_0_0.getCardByZawakeID(arg_9_0)
	local var_9_1 = var_9_0.cfg.zawakeID

	if gZawakeStagesCsv[var_9_1] and gZawakeStagesCsv[var_9_1][arg_9_1] then
		return gZawakeStagesCsv[var_9_1][arg_9_1], var_9_0
	end

	error(string.format("!!!csv.zawake.stages not exist zawakeID(%s), awakeSeqID(%s)", var_9_1, arg_9_1))
end

function var_0_0.isOpenByStage(arg_10_0, arg_10_1)
	if arg_10_0 == 0 then
		return false
	end

	arg_10_1 = arg_10_1 or 1

	local var_10_0 = gZawakeStagesCsv[arg_10_0] and gZawakeStagesCsv[arg_10_0][arg_10_1]

	if var_10_0 and var_10_0.isOpen == var_0_0.STAGE_OPEN_STATE.open then
		return true
	end

	return false
end

function var_0_0.isUnlockByKey(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_3 = arg_11_3 or -1

	local var_11_0 = arg_11_3

	if var_11_0 == -1 then
		local var_11_1, var_11_2 = next(gCardsZawake[arg_11_2])

		var_11_0 = var_11_2.cardMarkID
	end

	local var_11_3 = {}

	for iter_11_0, iter_11_1 in ipairs(gGameModel.role:read("cards")) do
		local var_11_4 = gGameModel.cards:find(iter_11_1)
		local var_11_5 = var_11_4:read("card_id")
		local var_11_6 = csv.cards[var_11_5]

		if arg_11_3 ~= -1 and var_11_6.cardMarkID == arg_11_3 or arg_11_3 == -1 and var_11_6.zawakeID == arg_11_2 then
			table.insert(var_11_3, var_11_4)
		end
	end

	local function var_11_7(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		for iter_12_0, iter_12_1 in ipairs(var_11_3) do
			local var_12_0 = iter_12_1:read(arg_12_0)

			if arg_12_2 then
				local var_12_1 = 0

				for iter_12_2, iter_12_3 in pairs(var_12_0) do
					var_12_1 = var_12_1 + (arg_12_3 and iter_12_3[arg_12_3] or iter_12_3)

					if arg_12_4 then
						var_12_1 = var_12_1 + iter_12_3[arg_12_4] or 0
					end
				end

				if arg_12_1 <= var_12_1 then
					return true
				end
			elseif arg_12_1 <= var_12_0 then
				return true
			end
		end

		return false
	end

	if arg_11_0 == "goodFeel" then
		if arg_11_1 <= ((gGameModel.role:read("card_feels")[var_11_0] or {}).level or 0) then
			return true
		end
	elseif arg_11_0 == "equipStarSum" then
		return var_11_7("equips", arg_11_1, true, "star", "ability")
	elseif arg_11_0 == "equipAwakeSum" then
		return var_11_7("equips", arg_11_1, true, "awake", "awake_ability")
	elseif arg_11_0 == "equipSignetAdvanceSum" then
		return var_11_7("equips", arg_11_1, true, "signet_advance")
	elseif arg_11_0 == "zawakeStage" then
		local var_11_8 = gGameModel.role:read("zawake") or {}
		local var_11_9 = math.floor(arg_11_1 / 100)
		local var_11_10 = arg_11_1 % 100

		for iter_11_2, iter_11_3 in ipairs(var_11_3) do
			local var_11_11 = iter_11_3:read("card_id")

			if var_11_10 <= ((var_11_8[csv.cards[var_11_11].zawakeID] or {})[var_11_9] or 0) then
				return true
			end
		end
	elseif arg_11_0 == "star" then
		return var_11_7("star", arg_11_1)
	elseif arg_11_0 == "nvalueSum" then
		return var_11_7("nvalue", arg_11_1, true)
	elseif arg_11_0 == "advance" then
		return var_11_7("advance", arg_11_1)
	elseif arg_11_0 == "effort" then
		return var_11_7("effort_advance", arg_11_1)
	elseif arg_11_0 == "gemQuality" then
		for iter_11_4, iter_11_5 in ipairs(var_11_3) do
			if arg_11_1 <= dataEasy.getGemQualityIndex(iter_11_5) then
				return true
			end
		end
	end

	return false
end

function var_0_0.getLabelByLimit(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = "#C0xF76B45#" .. gLanguageCsv.notFinished

	if arg_13_2 then
		var_13_0 = " #Icity/card/evolution/logo_tick1.png-0.8#"
	end

	local var_13_1 = arg_13_1

	if arg_13_0 == "advance" then
		local var_13_2, var_13_3 = dataEasy.getQuality(arg_13_1, true)

		var_13_1 = ui.QUALITY_OUTLINE_COLOR[var_13_2] .. gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_13_2]] .. var_13_3
	else
		if arg_13_0 == "zawakeStage" then
			var_13_1 = gLanguageCsv.effortAdvance .. gLanguageCsv["symbolRome" .. math.floor(arg_13_1 / 100)]

			if arg_13_1 % 100 > 0 then
				var_13_1 = var_13_1 .. "- " .. arg_13_1 % 100
			end
		elseif arg_13_0 == "effort" then
			var_13_1 = gLanguageCsv.effortAdvance .. dataEasy.getRomanNumeral(arg_13_1)
		elseif arg_13_0 == "star" then
			var_13_1 = "x" .. var_13_1
		end

		var_13_1 = arg_13_2 and "#C0x60C456#" .. var_13_1 or "#C0xF76B45#" .. var_13_1
	end

	return string.format(gLanguageCsv["zawakeAttr" .. string.caption(arg_13_0)], var_13_1) .. var_13_0
end

function var_0_0.getActiveCondition(arg_14_0, arg_14_1, arg_14_2)
	if csvSize(arg_14_2.extraAttrs) == 0 and arg_14_2.skillID == 0 then
		return
	end

	local var_14_0 = {}
	local var_14_1 = {}
	local var_14_2 = true

	for iter_14_0, iter_14_1 in csvMapPairs(arg_14_2.activeReq) do
		local var_14_3 = var_0_0.isUnlockByKey(iter_14_0, iter_14_1, arg_14_0)
		local var_14_4 = "#C0x5B545B#·" .. var_0_0.getLabelByLimit(iter_14_0, iter_14_1, var_14_3)

		table.insert(var_14_1, var_14_4)

		if var_14_3 == false then
			var_14_2 = false
		end
	end

	return var_14_2, var_14_1
end

function var_0_0.isUnlockByStage(arg_15_0, arg_15_1)
	local var_15_0 = {}
	local var_15_1 = {}
	local var_15_2 = false

	for iter_15_0 = 1, 2 do
		local var_15_3 = {}
		local var_15_4 = gLanguageCsv.zawakeSelf
		local var_15_5 = true
		local var_15_6 = arg_15_0["unlockType" .. iter_15_0]

		if var_15_6 ~= -1 then
			local var_15_7 = var_0_0.getMinCardCfgByMarkID(var_15_6)

			var_15_4 = string.format(gLanguageCsv.series, var_15_7.name)
			var_15_5 = false
		end

		for iter_15_1, iter_15_2 in csvMapPairs(arg_15_0["unlockLimit" .. iter_15_0]) do
			local var_15_8 = var_0_0.isUnlockByKey(iter_15_1, iter_15_2, arg_15_1, var_15_6)

			table.insert(var_15_3, {
				key = iter_15_1,
				val = iter_15_2,
				state = var_15_8
			})
		end

		if itertools.size(var_15_3) > 0 then
			var_15_1[var_15_6] = {
				firstText = var_15_4,
				data = var_15_3,
				isSelf = var_15_5
			}
		end
	end

	local var_15_9 = true

	for iter_15_3, iter_15_4 in pairs(var_15_1) do
		for iter_15_5, iter_15_6 in pairs(iter_15_4.data) do
			local var_15_10 = "#C0x5B545B#·" .. iter_15_4.firstText .. var_0_0.getLabelByLimit(iter_15_6.key, iter_15_6.val, iter_15_6.state)

			table.insert(var_15_0, var_15_10)

			if iter_15_6.state == false then
				var_15_9 = false
			end
		end
	end

	return var_15_9, var_15_0
end

function var_0_0.getStageIsUnlock(arg_16_0, arg_16_1)
	local var_16_0, var_16_1 = var_0_0.getStagesCfg(arg_16_0, arg_16_1)
	local var_16_2, var_16_3 = var_0_0.isUnlockByStage(var_16_0, arg_16_0)

	return var_16_2
end

function var_0_0.canAwake(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0 == 0 then
		return false
	end

	if not var_0_0.isOpenByStage(arg_17_0, arg_17_1) then
		return false
	end

	local var_17_0 = var_0_0.getLevelCfg(arg_17_0, arg_17_1, arg_17_2)
	local var_17_1 = (gGameModel.role:read("zawake") or {})[arg_17_0] or {}

	if arg_17_2 <= (var_17_1[arg_17_1] or 0) then
		return false
	end

	if var_0_0.getStageIsUnlock(arg_17_0, arg_17_1) and var_17_0 then
		if arg_17_1 ~= 1 or arg_17_2 ~= 1 then
			local var_17_2 = arg_17_1
			local var_17_3 = arg_17_2 - 1

			if var_17_3 == 0 then
				var_17_2 = var_17_2 - 1
				var_17_3 = var_0_0.MAXLEVEL
			end

			if var_17_3 > (var_17_1[var_17_2] or 0) then
				return false
			end
		end

		for iter_17_0, iter_17_1 in csvMapPairs(var_17_0.costItemMap) do
			if iter_17_1 > dataEasy.getNumByKey(iter_17_0) then
				return false
			end
		end
	else
		return false
	end

	return true
end

function var_0_0.getSkillCfg(arg_18_0, arg_18_1)
	if not arg_18_1 or arg_18_1 == 0 or arg_18_0 == 0 then
		return
	end

	local var_18_0 = var_0_0.getCardByZawakeID(arg_18_0)
	local var_18_1 = var_18_0.cfg.skillList
	local var_18_2 = {}

	for iter_18_0, iter_18_1 in csvMapPairs(var_18_1) do
		local var_18_3 = csv.skill[iter_18_1].zawakeEffect[1]

		if var_18_3 and var_18_3 == arg_18_1 then
			table.insert(var_18_2, {
				cfg = csv.skill[iter_18_1],
				id = iter_18_1,
				cardId = var_18_0.cardId
			})
		end
	end

	if #var_18_2 > 0 then
		return var_18_2
	end

	printInfo("zawakeSkillID(%s) was not in cards zawakeID(%s)", arg_18_1, arg_18_0)
end

function var_0_0.getMinCardCfgByMarkID(arg_19_0)
	for iter_19_0, iter_19_1 in pairs(gCardsCsv[arg_19_0][1]) do
		return iter_19_1
	end
end

function var_0_0.getMaxStageLevel(arg_20_0)
	local var_20_0 = gGameModel.role:read("zawake") or {}
	local var_20_1
	local var_20_2

	for iter_20_0, iter_20_1 in pairs(var_20_0[arg_20_0] or {}) do
		if (not var_20_1 or var_20_1 < iter_20_0) and iter_20_1 > 0 then
			var_20_1 = iter_20_0
			var_20_2 = iter_20_1
		end
	end

	return var_20_1, var_20_2
end

return var_0_0
