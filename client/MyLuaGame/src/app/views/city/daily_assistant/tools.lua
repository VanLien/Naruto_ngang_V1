local var_0_0 = require("app.views.city.activity.month_card")
local var_0_1 = {}
local var_0_2 = {
	hadSignUp = 2,
	canSignUp = 1,
	cantSignUp = 3
}

var_0_1.UNION_BUILDINGS = {
	unionFuben = "fuben",
	unionRedpacket = "redpacket",
	unionTrainingSpeedup = "training",
	unionFight = "unionFight",
	unionContrib = "contribute",
	unionFragDonate = "fragdonate",
	unionDailyGift = "dailygift"
}

function var_0_1.getGainGoldTimes(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = (var_0_0.getPrivilegeAddition("lianjinFreeTimes") or 0) + dataEasy.getPrivilegeVal(game.PRIVILEGE_TYPE.LianjinFreeTimes)
	local var_1_1 = 1

	for iter_1_0, iter_1_1 in pairs(gCostCsv.lianjin_cost) do
		if iter_1_1 == 0 then
			var_1_1 = iter_1_0
		end
	end

	local var_1_2 = var_1_1 + var_1_0
	local var_1_3 = math.max(var_1_2 - arg_1_0, 0)

	if var_1_3 == 0 and arg_1_1 < var_1_0 then
		var_1_3 = var_1_0 - arg_1_1
	end

	if arg_1_2 then
		return var_1_3
	end

	local var_1_4 = string.format("%s/%s", var_1_3, var_1_2)

	if var_1_3 == 0 then
		var_1_4 = "#C0xFB6023#" .. var_1_4
	end

	return string.format(gLanguageCsv.dailyAssistantFreeGainGold, var_1_4), var_1_3
end

function var_0_1.getCardFragmentsName(arg_2_0)
	if arg_2_0 then
		for iter_2_0, iter_2_1 in gGameModel.cards:pairs() do
			local var_2_0 = iter_2_1:read("card_id")

			if arg_2_0 == var_2_0 then
				return csv.cards[var_2_0].name .. gLanguageCsv.fragment
			end
		end
	end

	return nil
end

function var_0_1.getHuodongTypeFlag(arg_3_0)
	local var_3_0 = false
	local var_3_1 = ({
		"goldActivity",
		"expActivity",
		"giftActivity",
		"fragActivity"
	})[arg_3_0]

	if not var_3_1 then
		return false
	end

	local var_3_2, var_3_3, var_3_4 = dataEasy.isDoubleHuodong(var_3_1)

	return var_3_2, 2, var_3_3, var_3_4
end

function var_0_1.getIsDoubleAward(arg_4_0)
	local var_4_0, var_4_1, var_4_2 = dataEasy.isDoubleHuodong("gateDrop")

	if not var_4_0 then
		return false
	end

	local var_4_3 = csv.scene_conf

	for iter_4_0, iter_4_1 in pairs(var_4_1) do
		local var_4_4 = var_4_3[tonumber(iter_4_1.start)].gateType

		if var_4_4 == game.GATE_TYPE.dailyGold and arg_4_0 == 1 or var_4_4 == game.GATE_TYPE.dailyExp and arg_4_0 == 2 or var_4_4 == game.GATE_TYPE.gift and arg_4_0 == 3 or var_4_4 == game.GATE_TYPE.fragment and arg_4_0 == 4 then
			return true, arg_4_0
		end
	end

	return false
end

function var_0_1.getActivityGateInfo()
	local var_5_0 = gGameModel.role:read("huodongs")
	local var_5_1 = gGameModel.role:read("level")
	local var_5_2 = 0
	local var_5_3 = 0
	local var_5_4 = {
		game.PRIVILEGE_TYPE.HuodongTypeGoldTimes,
		game.PRIVILEGE_TYPE.HuodongTypeExpTimes,
		game.PRIVILEGE_TYPE.HuodongTypeGiftTimes,
		game.PRIVILEGE_TYPE.HuodongTypeFragTimes
	}
	local var_5_5 = {
		"goldActivity",
		"expActivity",
		"giftActivity",
		"fragActivity"
	}
	local var_5_6 = {}
	local var_5_7 = {}
	local var_5_8 = false

	for iter_5_0, iter_5_1 in orderCsvPairs(csv.huodong) do
		local var_5_9 = var_5_4[iter_5_1.huodongType]

		if iter_5_1.openType ~= 0 and var_5_9 and var_5_1 > iter_5_1.openLevel then
			local var_5_10 = dataEasy.getPrivilegeVal(var_5_9)
			local var_5_11, var_5_12, var_5_13, var_5_14 = var_0_1.getHuodongTypeFlag(iter_5_1.huodongType)
			local var_5_15 = var_0_1.getIsDoubleAward(iter_5_1.huodongType)

			if var_5_12 == 2 and var_5_11 then
				var_5_10 = var_5_10 + var_5_13[1].count or 0

				table.insert(var_5_7, iter_5_1.huodongType)

				local var_5_16, var_5_17 = var_0_1.getActiveText(var_5_5[iter_5_1.huodongType])

				if var_5_16 then
					table.insert(var_5_6, var_5_16)
				end

				if var_5_17 then
					var_5_8 = var_5_17
				end
			end

			if var_5_15 then
				table.insert(var_5_7, iter_5_1.huodongType)
				table.insert(var_5_6, csv.huodong[iter_5_1.huodongType].name .. gLanguageCsv.doubleReward)
			end

			local var_5_18 = iter_5_1.times + var_5_10
			local var_5_19 = tonumber(time.getTodayStrInClock())

			if var_5_0[var_5_19] and var_5_0[var_5_19][iter_5_0] then
				var_5_18 = var_5_18 - var_5_0[var_5_19][iter_5_0].times
			end

			local var_5_20 = math.max(var_5_18, 0)

			var_5_2 = var_5_2 + iter_5_1.times + var_5_10
			var_5_3 = var_5_3 + var_5_20
		end
	end

	return var_5_3, var_5_2, var_5_6, #var_5_7 > 0, var_5_8
end

function var_0_1.getActiveText(arg_6_0)
	local var_6_0 = arg_6_0

	if type(arg_6_0) == "string" then
		var_6_0 = game.DOUBLE_HUODONG[arg_6_0]
	end

	if not var_6_0 then
		return false
	end

	for iter_6_0, iter_6_1 in ipairs(gGameModel.role:read("yy_open")) do
		local var_6_1 = csv.yunying.yyhuodong[iter_6_1]

		if game.YYHUODONG_TYPE_ENUM_TABLE.doubleDrop == var_6_1.type then
			local var_6_2 = var_6_1.paramMap

			if var_6_2.type and var_6_2.type == var_6_0 then
				local var_6_3 = var_6_1.desc
				local var_6_4, var_6_5, var_6_6 = dataEasy.isReunionDoubleHuodong(var_6_0)

				return var_6_3, var_6_4
			end
		end
	end

	return false
end

function var_0_1.getUnionFubenIsOpen()
	local var_7_0 = gGameModel.role:read("union_db_id")
	local var_7_1 = var_0_1.getUnionLockAndText("unionFuben")

	if var_7_0 and not var_7_1 then
		return true
	end

	return false
end

function var_0_1.getUnionLockAndText(arg_8_0)
	local var_8_0 = gGameModel.role:read("union_level")
	local var_8_1 = gUnionFeatureCsv[var_0_1.UNION_BUILDINGS[arg_8_0]] or 0
	local var_8_2 = var_8_1 == 0 or var_8_0 < var_8_1

	if var_8_2 then
		return var_8_2, string.format(gLanguageCsv.unionUnlockLevel, var_8_1)
	end

	local var_8_3 = dataEasy.notUseUnionBuild()

	if var_8_3 then
		return var_8_3, gLanguageCsv.cantUseFeaturesByChangeUnion
	end

	if arg_8_0 == "unionRedpacket" then
		var_8_3 = not dataEasy.canSystemRedPacket()

		if var_8_3 then
			return var_8_3, gLanguageCsv.unionRedPacketSysTimeL
		end
	elseif arg_8_0 == "unionFight" then
		local var_8_4, var_8_5 = dataEasy.judgeServerOpen(arg_8_0)

		if not var_8_4 and var_8_5 then
			return true, string.format(gLanguageCsv.unlockServerOpen, var_8_5)
		end
	end

	return var_8_3
end

function var_0_1.getCraftState()
	local var_9_0 = var_0_2.cantSignUp
	local var_9_1 = gGameModel.role:read("craft_round")

	if gGameModel.daily_record:read("craft_sign_up") and var_9_1 == "signup" then
		var_9_0 = var_0_2.hadSignUp
	elseif var_9_1 == "signup" then
		var_9_0 = var_0_2.canSignUp
	end

	return var_9_0
end

function var_0_1.getUnionFightState()
	local var_10_0 = var_0_2.cantSignUp
	local var_10_1 = gGameModel.role:read("union_fight_round")
	local var_10_2 = gGameModel.role:read("in_union_fight_top8")
	local var_10_3 = gGameModel.daily_record:read("union_fight_sign_up") and var_10_1 == "signup"
	local var_10_4 = time.getNowDate().wday

	var_10_4 = var_10_4 == 1 and 7 or var_10_4 - 1

	if var_10_3 then
		var_10_0 = var_0_2.hadSignUp
	elseif var_10_4 == 6 and var_10_1 == "signup" and var_10_2 or var_10_4 > 1 and var_10_4 < 6 and var_10_1 == "signup" then
		var_10_0 = var_0_2.canSignUp
	end

	return var_10_0
end

function var_0_1.getCrossCraftState()
	local var_11_0 = var_0_2.cantSignUp
	local var_11_1 = gGameModel.role:read("cross_craft_sign_up_date") ~= 0
	local var_11_2 = gGameModel.role:read("cross_craft_round")

	if var_11_1 and var_11_2 == "signup" then
		var_11_0 = var_0_2.hadSignUp
	elseif var_11_2 == "signup" then
		var_11_0 = var_0_2.canSignUp
	end

	return var_11_0
end

function var_0_1.getEndlessLeftTimes(arg_12_0)
	local var_12_0 = gGameModel.role:read("vip_level")
	local var_12_1 = gGameModel.daily_record:read("endless_tower_reset_times")
	local var_12_2 = gVipCsv[var_12_0].endlessTowerResetTimes
	local var_12_3 = math.max(var_12_2 - var_12_1, 0)

	if arg_12_0 then
		return var_12_3
	end

	return string.format("%s %s/%s", gLanguageCsv.reset, var_12_3, var_12_2), var_12_3, var_12_2
end

function var_0_1.getFishingText(arg_13_0)
	local var_13_0 = gGameModel.daily_record:read("fishing_counter")
	local var_13_1 = gCommonConfigCsv.fishingDailyTimes - var_13_0

	if arg_13_0 then
		return var_13_1
	end

	local var_13_2 = gGameModel.fishing:read("select_scene")
	local var_13_3 = var_13_2 == 0 and 1 or var_13_2
	local var_13_4 = gGameModel.role:read("items")
	local var_13_5 = gGameModel.fishing:read("select_bait")
	local var_13_6 = gGameModel.fishing:read("select_rod")
	local var_13_7 = csv.fishing.scene[var_13_3].name
	local var_13_8

	for iter_13_0, iter_13_1 in csvPairs(csv.fishing.bait) do
		if itertools.map(csv.fishing.bait[iter_13_0].scene, function(arg_14_0, arg_14_1)
			return arg_14_1, true
		end)[var_13_3] and var_13_5 == iter_13_0 then
			var_13_8 = var_13_4[iter_13_1.itemId]

			break
		end
	end

	local var_13_9 = var_13_8 or 0
	local var_13_10 = math.min(var_13_1, var_13_9)
	local var_13_11 = var_13_10

	if var_13_10 == 0 then
		var_13_11 = "#C0xFB6023#" .. var_13_10
	end

	local var_13_12 = var_13_1

	if var_13_1 == 0 then
		var_13_12 = "#C0xFB6023#" .. var_13_1
	end

	local var_13_13 = string.format(gLanguageCsv.dailyAssistantFishingText, var_13_7, var_13_11, var_13_12)

	if var_13_6 == 0 then
		var_13_13 = string.format(gLanguageCsv.dailyAssistantFishingText1, var_13_7)
	end

	return var_13_13, var_13_1, var_13_10
end

function var_0_1.getUnionContribText(arg_15_0)
	local var_15_0 = gGameModel.role:read("union_level")
	local var_15_1 = csv.union.union_level[var_15_0].ContribMax - gGameModel.daily_record:read("union_contrib_times")

	if arg_15_0 then
		return var_15_1
	end

	local var_15_2 = gGameModel.role:read("daily_assistant").union_contrib or 1
	local var_15_3 = gLanguageCsv[csv.union.contrib[var_15_2].title]
	local var_15_4 = var_15_1

	if var_15_1 == 0 then
		var_15_4 = "#C0xFB6023#" .. var_15_4
	end

	return string.format(gLanguageCsv.dailyAssistantUnionContribText, var_15_4, var_15_3), var_15_1
end

function var_0_1.getUnionFragDonateText(arg_16_0)
	local var_16_0 = gGameModel.daily_record:read("union_frag_donate_start_times")
	local var_16_1 = math.max(1 - var_16_0, 0)

	if arg_16_0 then
		return var_16_1
	end

	local var_16_2 = var_16_1

	if var_16_1 == 0 then
		var_16_2 = "#C0xFB6023#" .. var_16_2
	end

	local var_16_3 = string.format(gLanguageCsv.dailyAssistantUnionFragDonateText1, var_16_2)
	local var_16_4 = gGameModel.role:read("daily_assistant").union_frag_donate_card_id
	local var_16_5 = var_0_1.getCardFragmentsName(var_16_4)

	if var_16_5 then
		var_16_3 = string.format(gLanguageCsv.dailyAssistantUnionFragDonateText, var_16_2, var_16_5)
	end

	return var_16_3, var_16_1
end

function var_0_1.getUnionFubenTimes(arg_17_0)
	local var_17_0 = gGameModel.daily_record:read("union_fb_times")
	local var_17_1 = math.max(3 - var_17_0, 0)

	if arg_17_0 then
		return var_17_1
	end

	return string.format("%s/3", var_17_1), var_17_1
end

function var_0_1.isUnlock(arg_18_0)
	if dataEasy.isShow(arg_18_0) and dataEasy.isUnlock(arg_18_0) then
		return true
	end

	return false
end

function var_0_1.getEndlessTowerRedHintState()
	if not var_0_1.isUnlock("endlessTower") then
		return false
	end

	local var_19_0 = gGameModel.role:read("daily_assistant").endless_buy_reset
	local var_19_1 = gGameModel.role:read("endless_tower_current")
	local var_19_2 = gGameModel.role:read("endless_tower_max_gate")
	local var_19_3 = var_0_1.getEndlessLeftTimes(true)

	if var_19_0 == 0 and var_19_1 < var_19_2 or var_19_0 == 1 and (var_19_3 > 0 or var_19_1 < var_19_2) then
		return true
	end

	return false
end

function var_0_1.getFishingRedHintState()
	if not var_0_1.isUnlock("fishing") or not var_0_1.isUnlock("catch") then
		return false
	end

	local var_20_0 = gGameModel.role:read("daily_assistant").fishing_skip
	local var_20_1 = var_0_1.getFishingText(true)

	if var_20_0 == 1 and var_20_1 > 0 then
		return true
	end

	return false
end

return var_0_1
