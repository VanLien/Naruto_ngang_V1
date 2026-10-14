local var_0_0 = class("OnlineFightRewardView", Dialog)

var_0_0.RESOURCE_FILENAME = "online_fight_reward.json"
var_0_0.RESOURCE_BINDING = {
	["topPanel.txtRank"] = "txtRank",
	item = "item",
	["leftPanel.tabItem"] = "tabItem",
	desc = "desc",
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()

						var_1_2:get("txt"):setFontSize(60)
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()

						var_1_2:get("txt"):setFontSize(50)
					end

					var_1_2:get("txt"):getVirtualRenderer():setLineSpacing(-5)
					adapt.setAutoMultiLine(var_1_2:get("txt"), arg_1_3.name)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	list1 = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("data1"),
				item = bindHelper.self("item"),
				preloadCenter = bindHelper.self("preloadCenter1"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("imgBg", "imgRank", "txtRank", "list")

					var_2_0.imgRank:hide()
					var_2_0.txtRank:show():text(arg_2_3.cfg.score[1] .. "-" .. arg_2_3.cfg.score[2] - 1)
					var_2_0.imgBg:texture(arg_2_3.isSelect and "city/pvp/online_fight/other/bg_list0.png" or "activity/world_boss/bg_list.png")
					uiEasy.createItemsToList(arg_2_0, var_2_0.list, arg_2_3.cfg.award, {
						scale = 0.85,
						margin = 40
					})
				end
			}
		}
	},
	list2 = {
		varname = "list2",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("data2"),
				item = bindHelper.self("item"),
				preloadCenter = bindHelper.self("preloadCenter2"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("imgBg", "imgRank", "txtRank", "list")

					if arg_3_3.cfg.rankMax <= 3 then
						var_3_0.imgRank:show():texture(ui.RANK_ICON[arg_3_2])
						var_3_0.txtRank:hide()
					else
						var_3_0.imgRank:hide()
						var_3_0.txtRank:show()

						if arg_3_3.cfg.rankMax > arg_3_3.lastRankMax + 1 then
							var_3_0.txtRank:text(arg_3_3.lastRankMax + 1 .. "-" .. arg_3_3.cfg.rankMax)
						else
							var_3_0.txtRank:text(arg_3_3.cfg.rankMax)
						end
					end

					var_3_0.imgBg:texture(arg_3_3.isSelect and "city/pvp/online_fight/other/bg_list0.png" or "activity/world_boss/bg_list.png")
					uiEasy.createItemsToList(arg_3_0, var_3_0.list, arg_3_3.cfg.award, {
						scale = 0.85,
						margin = 40
					})
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_4_0)
	arg_4_0.tabDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.onlineFightTab1
		},
		{
			name = gLanguageCsv.onlineFightTab2
		}
	})
	arg_4_0.datas = {
		{
			txtRank = gLanguageCsv.score,
			desc = gLanguageCsv.onlineFightRewardDesc1,
			specialDesc = gLanguageCsv.onlineFightRewardSpecialDesc1
		},
		{
			txtRank = gLanguageCsv.ranking,
			desc = gLanguageCsv.onlineFightRewardDesc2
		}
	}

	for iter_4_0 = 1, 2 do
		arg_4_0["data" .. iter_4_0] = idlers.new()

		arg_4_0["list" .. iter_4_0]:hide()

		arg_4_0["preloadCenter" .. iter_4_0] = idler.new(0)

		local var_4_0 = gGameModel.cross_online_fight:read("version")
		local var_4_1 = {}
		local var_4_2 = 0
		local var_4_3 = arg_4_0:isVaildAward(iter_4_0)

		if iter_4_0 == 1 then
			local var_4_4 = gGameModel.cross_online_fight:read("unlimited_score")
			local var_4_5 = gGameModel.cross_online_fight:read("limited_score")
			local var_4_6 = math.max(var_4_4, var_4_5)

			for iter_4_1, iter_4_2 in orderCsvPairs(csv.cross.online_fight.weekly_award) do
				if iter_4_2.version == var_4_0 then
					local var_4_7 = false

					if var_4_3 and var_4_6 >= iter_4_2.score[1] and var_4_6 < iter_4_2.score[2] then
						var_4_2 = #var_4_1 + 1
						var_4_7 = true
					end

					table.insert(var_4_1, {
						cfg = iter_4_2,
						isSelect = var_4_7
					})
				end
			end
		else
			local var_4_8 = gGameModel.cross_online_fight:read("unlimited_rank")
			local var_4_9 = gGameModel.cross_online_fight:read("limited_rank")
			local var_4_10

			if var_4_8 == 0 then
				var_4_10 = var_4_9
			elseif var_4_9 == 0 then
				var_4_10 = var_4_8
			else
				var_4_10 = math.min(var_4_8, var_4_9)
			end

			local var_4_11

			for iter_4_3, iter_4_4 in orderCsvPairs(csv.cross.online_fight.final_award) do
				if iter_4_4.version == var_4_0 then
					local var_4_12 = false

					if var_4_3 and (iter_4_4.rankMax == var_4_10 or var_4_11 and var_4_10 >= var_4_11 + 1 and var_4_10 < iter_4_4.rankMax) then
						var_4_2 = #var_4_1 + 1
						var_4_12 = true
					end

					table.insert(var_4_1, {
						cfg = iter_4_4,
						lastRankMax = var_4_11,
						isSelect = var_4_12
					})

					var_4_11 = iter_4_4.rankMax
				end
			end
		end

		arg_4_0["preloadCenter" .. iter_4_0]:set(var_4_2)
		arg_4_0["data" .. iter_4_0]:update(var_4_1)
	end

	arg_4_0.showTab = idler.new(1)

	arg_4_0.showTab:addListener(function(arg_5_0, arg_5_1)
		arg_4_0.tabDatas:atproxy(arg_5_1).select = false
		arg_4_0.tabDatas:atproxy(arg_5_0).select = true

		arg_4_0["list" .. arg_5_1]:hide()
		arg_4_0["list" .. arg_5_0]:show()
		arg_4_0.txtRank:text(arg_4_0.datas[arg_5_0].txtRank)
		arg_4_0.desc:text(arg_4_0.datas[arg_5_0].desc)
		text.addEffect(arg_4_0.desc, {
			color = ui.COLORS.NORMAL.DEFAULT
		})

		if not arg_4_0:isVaildAward(arg_5_0) and arg_5_0 == 1 then
			arg_4_0.desc:text(arg_4_0.datas[arg_5_0].specialDesc)
			text.addEffect(arg_4_0.desc, {
				color = ui.COLORS.NORMAL.RED
			})
		end
	end)
	Dialog.onCreate(arg_4_0)
end

function var_0_0.isVaildAward(arg_6_0, arg_6_1)
	local var_6_0 = csv.cross.online_fight.base[1]

	if arg_6_1 == 1 then
		if (gGameModel.role:read("cross_online_fight_info").weekly_battle_times or 0) < var_6_0.weeklyAwardLeastTimes then
			return false
		end
	else
		local var_6_1 = gGameModel.cross_online_fight:read("unlimited_rank")
		local var_6_2 = gGameModel.cross_online_fight:read("limited_rank")

		if var_6_1 == 0 and var_6_2 == 0 then
			return false
		end
	end

	return true
end

function var_0_0.onTabClick(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.showTab:set(arg_7_2)
end

return var_0_0
