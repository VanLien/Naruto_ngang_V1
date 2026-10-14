local function var_0_0(arg_1_0, arg_1_1)
	arg_1_0:setTouchEnabled(arg_1_1)
	cache.setShader(arg_1_0, false, arg_1_1 and "normal" or "hsl_gray")

	if arg_1_1 then
		text.addEffect(arg_1_0:get("txt"), {
			glow = {
				color = ui.COLORS.GLOW.WHITE
			}
		})
	else
		text.deleteAllEffect(arg_1_0:get("txt"))
		text.addEffect(arg_1_0:get("txt"), {
			color = ui.COLORS.DISABLED.WHITE
		})
	end
end

local var_0_1 = class("CrossArenaPointRewardView", Dialog)

var_0_1.RESOURCE_FILENAME = "cross_arena_stage_reward.json"
var_0_1.RESOURCE_BINDING = {
	["rewardPanel2.rankItem"] = "rankItem2",
	["rewardPanel2.txt"] = "txtPeriod",
	["rewardPanel1.rankItem"] = "rankItem1",
	rewardPanel = "rewardPanel",
	rewardPanel2 = "rewardPanel2",
	["rewardPanel3.rankItem"] = "rankItem3",
	["leftPanel.tabItem"] = "tabItem",
	rewardPanel1 = "rewardPanel1",
	["rewardPanel.rankItem"] = "rankItem",
	["rewardPanel3.txt"] = "txtStage",
	rewardPanel3 = "rewardPanel3",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				showTab = bindHelper.self("showTab"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					if arg_2_3.redHint then
						bind.extend(arg_2_0, arg_2_1, {
							class = "red_hint",
							props = {
								state = arg_2_0.showTab:read() ~= arg_2_2,
								specialTag = arg_2_3.redHint,
								onNode = function(arg_3_0)
									arg_3_0:xy(arg_2_1:width() - 10, arg_2_1:height() - 5)
								end
							}
						})
					end

					var_2_2:get("txt"):text(arg_2_3.name)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["rewardPanel.btnAllGet"] = {
		varname = "getBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					return arg_4_0:onNextGetBtn()
				end)
			}
		}
	},
	["rewardPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("pointDatas1"),
				item = bindHelper.self("rankItem"),
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("txtRank", "btnGet", "list")

					var_5_0.txtRank:text(arg_5_3.point)

					if next(arg_5_3.award) ~= nil then
						uiEasy.createItemsToList(arg_5_0, var_5_0.list, arg_5_3.award, {
							scale = 0.9,
							margin = 20
						})
					end

					bind.touch(arg_5_0, var_5_0.btnGet, {
						methods = {
							ended = functools.partial(arg_5_0.clickCell, arg_5_2, arg_5_3)
						}
					})
					var_5_0.btnGet:get("txt"):text(arg_5_3.pointAwardState == 0 and gLanguageCsv.received or gLanguageCsv.spaceReceive)
					var_0_0(var_5_0.btnGet, arg_5_3.pointAwardState == 1)

					if arg_5_3.pointAwardState == 1 then
						text.addEffect(var_5_0.btnGet:get("txt"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onitemClick")
			}
		}
	},
	["rewardPanel1.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("pointDatas2"),
				item = bindHelper.self("rankItem1"),
				itemAction = {
					isAction = true
				},
				dataOrderCmpGen = bindHelper.self("onSortCards", true),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_1:multiget("state", "btnGet", "list")

					bind.extend(arg_6_0, var_6_0.state, {
						event = "extend",
						class = "stage_icon",
						props = {
							showStage = true,
							showStageBg = false,
							rank = arg_6_3.point,
							onNode = function(arg_7_0)
								arg_7_0:xy(92, 100):z(6):scale(1)
							end
						}
					})

					if next(arg_6_3.award) ~= nil then
						uiEasy.createItemsToList(arg_6_0, var_6_0.list, arg_6_3.award, {
							scale = 0.9,
							margin = 20
						})
					end

					bind.touch(arg_6_0, var_6_0.btnGet, {
						methods = {
							ended = functools.partial(arg_6_0.clickCell, arg_6_2, arg_6_3)
						}
					})
					var_6_0.btnGet:get("txt"):text(arg_6_3.pointAwardState == 0 and gLanguageCsv.received or gLanguageCsv.spaceReceive)
					var_0_0(var_6_0.btnGet, arg_6_3.pointAwardState == 1)

					if arg_6_3.pointAwardState == 1 then
						text.addEffect(var_6_0.btnGet:get("txt"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onitemNextClick")
			}
		}
	},
	["rewardPanel2.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("rewardData"),
				item = bindHelper.self("rankItem2"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("list", "stageIcon", "imgBg", "imgBg1", "txtRank", "txt", "rankIcon")

					var_8_0.txtRank:hide()
					var_8_0.txt:hide()
					var_8_0.imgBg1:hide()
					var_8_0.rankIcon:show()
					var_8_0.imgBg:show()
					bind.extend(arg_8_0, var_8_0.stageIcon, {
						event = "extend",
						class = "stage_icon",
						props = {
							showStageBg = false,
							rank = arg_8_3.rank,
							showStage = arg_8_3.cfg.stageID ~= dataEasy.getCrossArenaStageByRank(1),
							onNode = function(arg_9_0)
								arg_9_0:xy(92, 100):z(6):scale(1)
							end
						}
					})

					local var_8_1 = dataEasy.getCrossArenaStageByRank(arg_8_3.rank)

					uiEasy.createItemsToList(arg_8_0, var_8_0.list, arg_8_3.cfg.periodAward, {
						scale = 0.9,
						margin = 20
					})

					if arg_8_3.cfg.stageID == dataEasy.getCrossArenaStageByRank(1).stageID then
						var_8_0.txtRank:show()
						var_8_0.txt:show()
						var_8_0.rankIcon:hide()

						if tonumber(arg_8_3.cfg.range[1]) == tonumber(arg_8_3.cfg.range[2] - 1) then
							var_8_0.txtRank:text(arg_8_3.cfg.range[1])
						else
							var_8_0.txtRank:text(arg_8_3.cfg.range[1] .. "-" .. arg_8_3.cfg.range[2] - 1)
						end

						var_8_0.list:xy(var_8_0.list:x() + 100, var_8_0.list:y())
						var_8_0.imgBg:hide()
						var_8_0.imgBg1:show()

						if arg_8_3.isCurRank then
							var_8_0.imgBg1:texture("city/pvp/cross_arena/box_wz_2.png")
						else
							var_8_0.imgBg1:texture("city/pvp/cross_arena/box_wz_1.png")
						end
					elseif arg_8_3.isCurRank then
						var_8_0.imgBg:texture("city/pvp/cross_arena/dwjl_bg_list_1.png")
					else
						var_8_0.imgBg:texture("city/pvp/cross_arena/dwjl_bg_list.png")
					end
				end,
				preloadCenter = bindHelper.self("lastIdx")
			}
		}
	},
	["rewardPanel3.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 5,
				data = bindHelper.self("rewardData1"),
				item = bindHelper.self("rankItem3"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					local var_10_0 = arg_10_1:multiget("list", "stageIcon", "imgBg", "imgBg1", "txtRank", "txt", "rankIcon")

					var_10_0.txtRank:hide()
					var_10_0.txt:hide()
					var_10_0.rankIcon:show()
					var_10_0.imgBg:show()
					var_10_0.imgBg1:hide()
					bind.extend(arg_10_0, var_10_0.stageIcon, {
						event = "extend",
						class = "stage_icon",
						props = {
							showStageBg = false,
							rank = arg_10_3.rank,
							showStage = arg_10_3.cfg.stageID ~= dataEasy.getCrossArenaStageByRank(1),
							onNode = function(arg_11_0)
								arg_11_0:xy(92, 100):z(6):scale(1)
							end
						}
					})
					uiEasy.createItemsToList(arg_10_0, var_10_0.list, arg_10_3.cfg.finishAward, {
						scale = 0.9,
						margin = 20
					})

					if arg_10_3.cfg.stageID == dataEasy.getCrossArenaStageByRank(1).stageID then
						var_10_0.txtRank:show()
						var_10_0.txt:show()
						var_10_0.rankIcon:hide()

						if tonumber(arg_10_3.cfg.range[1]) == tonumber(arg_10_3.cfg.range[2] - 1) then
							var_10_0.txtRank:text(arg_10_3.cfg.range[1])
						else
							var_10_0.txtRank:text(arg_10_3.cfg.range[1] .. "-" .. arg_10_3.cfg.range[2] - 1)
						end

						var_10_0.list:xy(var_10_0.list:x() + 100, var_10_0.list:y())
						var_10_0.imgBg:hide()
						var_10_0.imgBg1:show()

						if arg_10_3.isCurRank then
							var_10_0.imgBg1:texture("city/pvp/cross_arena/box_wz_2.png")
						else
							var_10_0.imgBg1:texture("city/pvp/cross_arena/box_wz_1.png")
						end
					elseif arg_10_3.isCurRank then
						var_10_0.imgBg:texture("city/pvp/cross_arena/dwjl_bg_list_1.png")
					else
						var_10_0.imgBg:texture("city/pvp/cross_arena/dwjl_bg_list.png")
					end
				end,
				preloadCenter = bindHelper.self("lastIdx1")
			}
		}
	}
}

function var_0_1.onCreate(arg_12_0)
	arg_12_0.rewardPanel:hide()
	arg_12_0.rewardPanel1:hide()
	arg_12_0.rewardPanel2:hide()
	arg_12_0.rewardPanel3:hide()
	arg_12_0:initModel()

	arg_12_0.pointDatas1 = idlers.new()
	arg_12_0.sevenTime = 0

	if arg_12_0.round == "start" then
		arg_12_0.sevenTime = time.getNumTimestamp(arg_12_0.date, 22) + 518400
	end

	idlereasy.when(arg_12_0.pointAward, function(arg_13_0, arg_13_1)
		arg_13_1 = arg_13_1 or {}

		local var_13_0 = {}
		local var_13_1 = false

		for iter_13_0, iter_13_1 in csvPairs(csv.cross.arena.daily_award) do
			if arg_13_1[iter_13_0] == 1 then
				var_13_1 = true
			end

			var_13_0[iter_13_0] = {
				id = iter_13_0,
				award = iter_13_1.award,
				point = iter_13_1.pwTime,
				pointAwardState = arg_13_1[iter_13_0]
			}
		end

		dataEasy.tryCallFunc(arg_12_0.list, "updatePreloadCenterIndex")
		arg_12_0.pointDatas1:update(var_13_0)
		var_0_0(arg_12_0.getBtn, var_13_1)

		if var_13_1 then
			text.addEffect(arg_12_0.getBtn:get("txt"), {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	end)

	arg_12_0.pointDatas2 = idlers.new()

	idlereasy.when(arg_12_0.datas, function(arg_14_0, arg_14_1)
		local var_14_0 = {}
		local var_14_1 = 0

		for iter_14_0, iter_14_1 in orderCsvPairs(csv.cross.arena.stage) do
			if iter_14_1.version == arg_12_0.version and iter_14_1.stageID ~= var_14_1 then
				var_14_0[iter_14_0] = {
					id = iter_14_0,
					award = iter_14_1.award,
					point = iter_14_1.range[1],
					pointAwardState = arg_14_1.stage_awards and arg_14_1.stage_awards[iter_14_0]
				}
				var_14_1 = iter_14_1.stageID
			end
		end

		dataEasy.tryCallFunc(arg_12_0.list, "updatePreloadCenterIndex")
		arg_12_0.pointDatas2:update(var_14_0)
	end)

	arg_12_0.lastIdx = idler.new(1)
	arg_12_0.lastIdx1 = idler.new(1)

	local var_12_0 = false

	if time.getTime() < arg_12_0.sevenTime then
		var_12_0 = true
	end

	local var_12_1 = {}

	for iter_12_0, iter_12_1 in orderCsvPairs(csv.cross.arena.stage) do
		if iter_12_1.version == arg_12_0.version then
			local var_12_2 = false

			if var_12_0 then
				if arg_12_0.role and arg_12_0.role.rank >= iter_12_1.range[1] and arg_12_0.role.rank < iter_12_1.range[2] then
					var_12_2 = true
				end
			else
				local var_12_3 = dataEasy.getCrossArenaStageByRank(iter_12_1.range[1])

				if arg_12_0.sevenAwardStage == iter_12_0 then
					var_12_2 = true
				end
			end

			table.insert(var_12_1, {
				cfg = iter_12_1,
				rank = iter_12_1.range[1],
				isCurRank = var_12_2
			})
		end
	end

	arg_12_0.rewardData = itertools.reverse(var_12_1)

	for iter_12_2, iter_12_3 in ipairs(arg_12_0.rewardData) do
		if iter_12_3.isCurRank == true then
			arg_12_0.lastIdx:set(iter_12_2)
		end
	end

	local var_12_4 = {}

	for iter_12_4, iter_12_5 in orderCsvPairs(csv.cross.arena.stage) do
		if iter_12_5.version == arg_12_0.version then
			local var_12_5 = false

			if arg_12_0.round ~= "closed" then
				if arg_12_0.role and arg_12_0.role.rank >= iter_12_5.range[1] and arg_12_0.role.rank < iter_12_5.range[2] then
					var_12_5 = true
				end
			else
				local var_12_6 = dataEasy.getCrossArenaStageByRank(iter_12_5.range[1])

				if arg_12_0.finishAwardStage == iter_12_4 then
					var_12_5 = true
				end
			end

			table.insert(var_12_4, {
				cfg = iter_12_5,
				rank = iter_12_5.range[1],
				isCurRank = var_12_5
			})
		end
	end

	arg_12_0.rewardData1 = itertools.reverse(var_12_4)

	for iter_12_6, iter_12_7 in ipairs(arg_12_0.rewardData1) do
		if iter_12_7.isCurRank == true then
			arg_12_0.lastIdx1:set(iter_12_6)
		end
	end

	arg_12_0.panel = {
		{
			node = arg_12_0.rewardPanel
		},
		{
			node = arg_12_0.rewardPanel1
		},
		{
			node = arg_12_0.rewardPanel2
		},
		{
			node = arg_12_0.rewardPanel3
		}
	}
	arg_12_0.tabDatas = idlers.newWithMap({
		{
			redHint = "crossArenaPointAward",
			name = gLanguageCsv.dailyReward
		},
		{
			redHint = "crossArenaRankAward",
			name = gLanguageCsv.stateAward
		},
		{
			name = gLanguageCsv.periodAward
		},
		{
			name = gLanguageCsv.finishAward
		}
	})
	arg_12_0.showTab = idler.new(1)

	arg_12_0.showTab:addListener(function(arg_15_0, arg_15_1)
		arg_12_0.tabDatas:atproxy(arg_15_1).select = false
		arg_12_0.tabDatas:atproxy(arg_15_0).select = true

		arg_12_0.panel[arg_15_1].node:hide()
		arg_12_0.panel[arg_15_0].node:show()
	end)

	if arg_12_0.sevenAwardStage ~= 0 or time.getTime() > arg_12_0.sevenTime then
		arg_12_0.txtPeriod:text(gLanguageCsv.stageAwardNote)
	else
		arg_12_0.txtPeriod:text(gLanguageCsv.showPeriodNote)
	end

	if arg_12_0.round == "closed" then
		arg_12_0.txtStage:text(gLanguageCsv.stageAwardNote)
	else
		arg_12_0.txtStage:text(gLanguageCsv.showStageNote)
	end

	Dialog.onCreate(arg_12_0)
end

function var_0_1.initModel(arg_16_0)
	arg_16_0.datas = gGameModel.role:getIdler("cross_arena_datas")
	arg_16_0.pointAward = gGameModel.daily_record:getIdler("cross_arena_point_award")

	local var_16_0 = csv.cross.service[game.crossArenaCsvId]

	arg_16_0.version = var_16_0 and var_16_0.version or nil
	arg_16_0.role = gGameModel.cross_arena:read("role")
	arg_16_0.date = gGameModel.cross_arena:read("date")
	arg_16_0.sevenAwardStage = arg_16_0.datas:read().seven_award_stage
	arg_16_0.finishAwardStage = arg_16_0.datas:read().finish_award_stage
	arg_16_0.round = gGameModel.cross_arena:read("round")
end

function var_0_1.onTabClick(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0.showTab:set(arg_17_2)
end

function var_0_1.onitemClick(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0:onNextGetBtn(arg_18_3.id)
end

function var_0_1.onitemNextClick(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0:onGetBtn(arg_19_3.id)
end

function var_0_1.onNextGetBtn(arg_20_0, arg_20_1)
	gGameApp:requestServer("/game/cross/arena/daily/award", function(arg_21_0)
		gGameUI:showGainDisplay(arg_21_0)
	end, arg_20_1)
end

function var_0_1.onGetBtn(arg_22_0, arg_22_1)
	gGameApp:requestServer("/game/cross/arena/stage/award", function(arg_23_0)
		gGameUI:showGainDisplay(arg_23_0)
	end, arg_22_1)
end

function var_0_1.onSortCards(arg_24_0, arg_24_1)
	return function(arg_25_0, arg_25_1)
		local var_25_0 = arg_25_0.pointAwardState or 0.5
		local var_25_1 = arg_25_1.pointAwardState or 0.5

		if var_25_0 ~= var_25_1 then
			return var_25_1 < var_25_0
		end

		return arg_25_0.id < arg_25_1.id
	end
end

return var_0_1
