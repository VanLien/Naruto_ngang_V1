local var_0_0 = {}
local var_0_1 = {
	buffCardHp = 1,
	buffCardMp = 2,
	buffCardDead = 3
}

function var_0_0.setEffect(arg_1_0)
	local var_1_0 = arg_1_0.parent
	local var_1_1 = arg_1_0.spinePath
	local var_1_2 = arg_1_0.offsetX or 0
	local var_1_3 = arg_1_0.offsetY or 0
	local var_1_4 = arg_1_0.zOrder or 10
	local var_1_5 = arg_1_0.scale or 1
	local var_1_6 = arg_1_0.effectName or "effect"
	local var_1_7 = var_1_0:size()
	local var_1_8 = var_1_0:get("effect")

	if not var_1_8 then
		var_1_8 = widget.addAnimationByKey(var_1_0, var_1_1, "effect", var_1_6, var_1_4):xy(var_1_7.width / 2 + var_1_2, var_1_7.height / 2 + var_1_3):scale(var_1_5)
	else
		var_1_8:show():play(var_1_6)
	end
end

function var_0_0.getConditionStr(arg_2_0, arg_2_1)
	local var_2_0 = {}
	local var_2_1 = gGameModel.cards:find(arg_2_0)

	if not var_2_1 then
		return {}
	end

	local var_2_2 = var_2_1:read("abilities")
	local var_2_3 = var_2_1:read("level")
	local var_2_4 = var_2_1:read("advance")
	local var_2_5 = csv.card_ability[arg_2_1]
	local var_2_6 = var_2_5.strengthCod1

	if var_2_6[1] == 1 and var_2_3 < var_2_6[2] then
		table.insert(var_2_0, string.format(gLanguageCsv.needSpriteLevelAchieve, var_2_6[2]))
	end

	if var_2_6[1] == 2 and var_2_4 < var_2_6[2] then
		local var_2_7, var_2_8 = dataEasy.getQuality(var_2_6[2])

		table.insert(var_2_0, string.format(gLanguageCsv.needSpriteAdvanceAchieve, gLanguageCsv[ui.QUALITY_COLOR_TEXT[var_2_7]] .. var_2_8))
	end

	local var_2_9 = var_2_5.strengthCod2

	for iter_2_0, iter_2_1 in orderCsvPairs(var_2_5.preAbilityID) do
		if var_2_9 <= (var_2_2[iter_2_1] or 0) then
			break
		end

		if iter_2_0 == csvSize(var_2_5.preAbilityID) then
			table.insert(var_2_0, string.format(gLanguageCsv.needPreSkillLevelAchieve, var_2_9))
		end
	end

	return var_2_0
end

return var_0_0
