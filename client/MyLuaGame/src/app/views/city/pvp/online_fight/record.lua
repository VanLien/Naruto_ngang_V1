local function var_0_0(arg_1_0)
	return time.getCutDown(math.max(time.getTime() - arg_1_0, 0), nil, true).head_date_str .. gLanguageCsv.before
end

local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("OnlineFightRecordView", Dialog)

var_0_2.RESOURCE_FILENAME = "online_fight_record.json"
var_0_2.RESOURCE_BINDING = {
	noRankPanel = "noRankPanel",
	item2 = "item2",
	tabItem = "tabItem",
	["leftPanel.tabItem"] = "stateItem",
	item1 = "item1",
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
				data = bindHelper.self("stateDatas"),
				item = bindHelper.self("stateItem"),
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

					var_2_2:get("txt"):getVirtualRenderer():setLineSpacing(-5)
					adapt.setAutoMultiLine(var_2_2:get("txt"), arg_2_3.name)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onStateClick")
			}
		}
	},
	tabList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("name"):text(arg_3_3.name)
					text.deleteAllEffect(arg_3_1:get("name"))

					if arg_3_3.select then
						arg_3_1:get("icon"):texture("common/btn/btn_nomal_2.png")
						text.addEffect(arg_3_1:get("name"), {
							glow = {
								color = ui.COLORS.GLOW.WHITE
							}
						})
					else
						arg_3_1:get("icon"):texture("common/btn/btn_nomal_3.png")
						text.addEffect(arg_3_1:get("name"), {
							color = ui.COLORS.NORMAL.WHITE
						})
					end

					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_2)
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
				item = bindHelper.self("item1"),
				dataOrderCmp = function(arg_4_0, arg_4_1)
					return arg_4_0.time > arg_4_1.time
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("imgBG", "imgFlag", "head", "textName", "textLvNote", "textLv", "server", "textTime", "btnReplay", "btnShare", "scoreNoChange", "scoreChange")

					var_5_0.textLv:text(arg_5_3.enemy.level)
					var_5_0.textName:text(arg_5_3.enemy.name)
					var_5_0.textTime:text(var_0_0(arg_5_3.time))
					var_5_0.server:text(string.format(gLanguageCsv.brackets, getServerArea(arg_5_3.enemy.game_key, true)))
					adapt.oneLinePos(var_5_0.textName, {
						var_5_0.textLvNote,
						var_5_0.textLv
					}, {
						cc.p(5, 0),
						cc.p(0, 0)
					})
					adapt.setTextScaleWithWidth(var_5_0.textName, nil, 280)
					adapt.setTextScaleWithWidth(var_5_0.textTime, nil, 500)

					if arg_5_3.result == "win" then
						var_5_0.imgBG:texture("city/pvp/cross_arena/panel_win.png")
						var_5_0.imgFlag:texture("city/pvp/craft/icon_win.png")
					else
						var_5_0.imgBG:texture("city/pvp/cross_arena/panel_lose.png")
						var_5_0.imgFlag:texture("city/pvp/craft/icon_lose.png")
					end

					var_5_0.scoreNoChange:visible(arg_5_3.delta == 0)
					var_5_0.scoreChange:visible(arg_5_3.delta ~= 0)

					if arg_5_3.delta ~= 0 then
						var_5_0.scoreChange:get("score"):text(gLanguageCsv.score .. ": " .. arg_5_3.score)
						var_5_0.scoreChange:get("arrow"):texture(arg_5_3.delta > 0 and "common/icon/logo_arrow_green.png" or "common/icon/logo_arrow_red.png")
						var_5_0.scoreChange:get("change"):text(math.abs(arg_5_3.delta))
						text.addEffect(var_5_0.scoreChange:get("change"), {
							color = arg_5_3.delta > 0 and cc.c4b(73, 185, 115, 255) or cc.c4b(221, 95, 113, 255)
						})
					end

					adapt.oneLinePos(var_5_0.scoreChange:get("score"), {
						var_5_0.scoreChange:get("arrow"),
						var_5_0.scoreChange:get("change")
					}, {
						cc.p(5, 0),
						cc.p(5, 0)
					})
					bind.extend(arg_5_0, var_5_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_5_3.enemy.logo,
							frameId = arg_5_3.enemy.frame
						}
					})
					text.addEffect(var_5_0.btnReplay:get("textNote"), {
						outline = {
							color = ui.COLORS.OUTLINE.WHITE
						}
					})
					bind.touch(arg_5_0, var_5_0.btnReplay, {
						methods = {
							ended = functools.partial(arg_5_0.playbackBtn, arg_5_2, arg_5_3)
						}
					})
					text.addEffect(var_5_0.btnShare:get("textNote"), {
						outline = {
							color = ui.COLORS.OUTLINE.WHITE
						}
					})
					bind.touch(arg_5_0, var_5_0.btnShare, {
						methods = {
							ended = functools.partial(arg_5_0.shareBtn, arg_5_2, arg_5_3)
						}
					})
				end
			},
			handlers = {
				playbackBtn = bindHelper.self("onPlaybackClick"),
				shareBtn = bindHelper.self("onShareClick")
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
				item = bindHelper.self("item2"),
				dataOrderCmp = function(arg_6_0, arg_6_1)
					return arg_6_0.time > arg_6_1.time
				end,
				itemAction = {
					isAction = true
				},
				onItem = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = {
						{
							result = arg_7_3.result == "win",
							name = arg_7_3.name,
							game_key = arg_7_3.role_key[1],
							level = arg_7_3.level,
							rank = arg_7_3.rank,
							score = arg_7_3.score,
							logo = arg_7_3.logo,
							frame = arg_7_3.frame
						},
						{
							result = arg_7_3.result ~= "win",
							name = arg_7_3.defence_name,
							game_key = arg_7_3.defence_role_key[1],
							level = arg_7_3.defence_level,
							rank = arg_7_3.defence_rank,
							score = arg_7_3.defence_score,
							logo = arg_7_3.defence_logo,
							frame = arg_7_3.defence_frame
						}
					}

					for iter_7_0 = 1, 2 do
						local var_7_1 = var_7_0[iter_7_0]
						local var_7_2 = arg_7_1:get(iter_7_0 == 1 and "leftPanel" or "rightPanel"):multiget("imgFlag", "head", "rank", "score", "name", "server", "txtLv", "level")

						var_7_2.imgFlag:texture(var_7_1.result and "city/pvp/craft/icon_win.png" or "city/pvp/craft/icon_lose.png")
						var_7_2.name:text(var_7_1.name)
						var_7_2.server:text(string.format(gLanguageCsv.brackets, getServerArea(var_7_1.game_key, true)))
						adapt.oneLinePos(var_7_2.name, var_7_2.server, cc.p(5, 0))
						var_7_2.level:text(var_7_1.level)
						var_7_2.rank:text(gLanguageCsv.ranking .. ":" .. var_7_1.rank)
						var_7_2.score:text(gLanguageCsv.score .. ":" .. var_7_1.score)
						bind.extend(arg_7_0, var_7_2.head, {
							event = "extend",
							class = "role_logo",
							props = {
								vip = false,
								level = false,
								logoId = var_7_1.logo,
								frameId = var_7_1.frame
							}
						})
						text.addEffect(var_7_2.txtLv, {
							outline = {
								color = ui.COLORS.OUTLINE.DEFAULT
							}
						})
						text.addEffect(var_7_2.level, {
							outline = {
								color = ui.COLORS.OUTLINE.DEFAULT
							}
						})
					end

					arg_7_1:get("imgBG"):texture(var_7_0[1].result and "city/pvp/cross_arena/list_bg_1.png" or "city/pvp/cross_arena/list_bg_2.png")
					text.addEffect(arg_7_1:get("btnReplay.textNote"), {
						outline = {
							color = ui.COLORS.OUTLINE.WHITE
						}
					})
					bind.touch(arg_7_0, arg_7_1:get("btnReplay"), {
						methods = {
							ended = functools.partial(arg_7_0.playbackBtn, arg_7_2, arg_7_3)
						}
					})
					bind.touch(arg_7_0, arg_7_1, {
						methods = {
							ended = functools.partial(arg_7_0.itemClick, arg_7_2, arg_7_3)
						}
					})
				end
			},
			handlers = {
				playbackBtn = bindHelper.self("onPlaybackClick"),
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}

function var_0_2.onCreate(arg_8_0, arg_8_1)
	arg_8_0.stateDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.onlineFightRecordType1
		},
		{
			name = gLanguageCsv.onlineFightRecordType2
		}
	})
	arg_8_0.tabDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.onlineFightLimited
		},
		{
			name = gLanguageCsv.onlineFightUnlimited
		}
	})
	arg_8_0.datas = {
		{
			{
				data = table.deepcopy(gGameModel.cross_online_fight:read("limited_history"), true)
			},
			{
				data = table.deepcopy(gGameModel.cross_online_fight:read("unlimited_history"), true)
			}
		},
		{
			{
				data = table.deepcopy(gGameModel.cross_online_fight:read("limited_top_battle_history"), true)
			},
			{
				data = table.deepcopy(gGameModel.cross_online_fight:read("unlimited_top_battle_history"), true)
			}
		}
	}

	for iter_8_0 = 1, 2 do
		arg_8_0["data" .. iter_8_0] = idlers.new()

		arg_8_0["list" .. iter_8_0]:hide()
	end

	arg_8_0.showState = idler.new(arg_8_0._showState or 1)
	arg_8_0.showTab = idler.new(arg_8_0._showTab or arg_8_1)

	idlereasy.any({
		arg_8_0.showState,
		arg_8_0.showTab
	}, function(arg_9_0, arg_9_1, arg_9_2)
		for iter_9_0 = 1, 2 do
			if arg_9_1 ~= iter_9_0 then
				arg_8_0.stateDatas:atproxy(iter_9_0).select = false

				arg_8_0["list" .. iter_9_0]:hide()
			end
		end

		arg_8_0.stateDatas:atproxy(arg_9_1).select = true

		arg_8_0["list" .. arg_9_1]:show()

		for iter_9_1 = 1, 2 do
			if arg_9_2 ~= iter_9_1 then
				arg_8_0.tabDatas:atproxy(iter_9_1).select = false
			end
		end

		arg_8_0.tabDatas:atproxy(arg_9_2).select = true

		local var_9_0 = arg_8_0.datas[arg_9_1][arg_9_2].data

		arg_8_0["data" .. arg_9_1]:update(var_9_0)
		arg_8_0.noRankPanel:visible(itertools.size(var_9_0) == 0)
	end)
	Dialog.onCreate(arg_8_0)
end

function var_0_2.onCleanup(arg_10_0)
	arg_10_0._showState = arg_10_0.showState:read()
	arg_10_0._showTab = arg_10_0.showTab:read()

	var_0_1.onCleanup(arg_10_0)
end

function var_0_2.onStateClick(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.showState:set(arg_11_2)
end

function var_0_2.onTabClick(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.showTab:set(arg_12_2)
end

function var_0_2.onPlaybackClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_3.frames and arg_13_3.frames[2] <= 0 then
		gGameUI:showTip(gLanguageCsv.noPlayBack)

		return
	end

	gGameModel:playRecordBattle(arg_13_3.play_record_id, arg_13_3.cross_key, "/game/cross/online/playrecord/get", 2)
end

function var_0_2.onShareClick(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_3.frames and arg_14_3.frames[2] <= 0 then
		gGameUI:showTip(gLanguageCsv.noPlayBack)

		return
	end

	local var_14_0 = gGameModel.daily_record:read("cross_online_fight_share_times")

	if var_14_0 >= gCommonConfigCsv.shareTimesLimit then
		gGameUI:showTip(gLanguageCsv.shareTimesNotEnough)

		return
	end

	local var_14_1 = gCommonConfigCsv.shareTimesLimit - var_14_0

	gGameUI:showDialog({
		isRich = false,
		btnType = 2,
		cb = function()
			gGameApp:requestServer("/game/battle/share", function(arg_16_0)
				gGameUI:showTip(gLanguageCsv.recordShareSuccess)
			end, arg_14_3.play_record_id, arg_14_3.enemy.name, "onlineFight", arg_14_3.cross_key)
		end,
		content = string.format(gLanguageCsv.shareBattleNote, var_14_1 .. "/" .. gCommonConfigCsv.shareTimesLimit)
	})
end

function var_0_2.onItemClick(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0.showTab:read()
	local var_17_1 = "/game/cross/online/playrecord/get"

	gGameModel:playRecordDeployInfo(arg_17_3.play_record_id, arg_17_3.cross_key, var_17_1, function(arg_18_0)
		gGameUI:stackUI("city.pvp.online_fight.record_info", nil, nil, arg_18_0, var_17_0)
	end)
end

return var_0_2
