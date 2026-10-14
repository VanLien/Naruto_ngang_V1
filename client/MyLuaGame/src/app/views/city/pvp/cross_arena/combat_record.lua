local function var_0_0(arg_1_0)
	return time.getCutDown(math.max(time.getTime() - arg_1_0, 0), nil, true).head_date_str .. gLanguageCsv.before
end

local var_0_1 = class("CrossArenaCombatRecordView", Dialog)

var_0_1.RESOURCE_FILENAME = "cross_arena_combat_record.json"
var_0_1.RESOURCE_BINDING = {
	myPanel = "myPanel",
	["emptyPanel.emptyTxt"] = "emptyTxt",
	emptyPanel = "emptyPanel",
	["myPanel.item"] = "item",
	["goodPanel.item"] = "item1",
	leftPanel = "leftPanel",
	["leftPanel.tabItem"] = "tabItem",
	goodPanel = "goodPanel",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["leftPanel.tabList"] = {
		varname = "tabList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("tabItem"),
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

					var_2_2:get("txt"):setFontSize(arg_2_3.fontSize)
					adapt.setAutoMultiLine(var_2_2:get("txt"), arg_2_3.name, 240, -10)
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
	["myPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("combatDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				dataOrderCmp = function(arg_3_0, arg_3_1)
					return arg_3_0.time > arg_3_1.time
				end,
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("imgBG", "head", "textName", "btnReplay", "btnShare", "imgFlag", "textTime", "imgDownOrUp", "textLv", "textLvNote", "iconVip", "stage1", "stage2", "sever", "bgDefend", "bgAttack", "textNoChange")

					var_4_0.textLv:text(arg_4_3.enemy_level)
					var_4_0.textName:text(arg_4_3.enemy_name)
					var_4_0.textTime:text(var_0_0(arg_4_3.time))
					var_4_0.iconVip:hide()
					var_4_0.sever:text(string.format(gLanguageCsv.brackets, getServerArea(arg_4_3.key, true)))
					adapt.oneLinePos(var_4_0.textLvNote, {
						var_4_0.textLv,
						var_4_0.sever
					}, {
						cc.p(0, 0),
						cc.p(5, 5)
					})
					adapt.setTextScaleWithWidth(var_4_0.textName, nil, 280)
					adapt.setTextScaleWithWidth(var_4_0.textTime, nil, 500)

					if matchLanguage({
						"en"
					}) then
						var_4_0.textTime:x(var_4_0.textTime:x() + 80)
					end

					if arg_4_3.result == "win" then
						var_4_0.imgDownOrUp:texture("common/icon/logo_arrow_green.png")
						var_4_0.imgDownOrUp:scaleY(1.3)
						var_4_0.imgFlag:texture("city/pvp/craft/icon_win.png")
						var_4_0.imgBG:texture("city/pvp/cross_arena/panel_win.png")
					else
						var_4_0.imgDownOrUp:texture("common/icon/logo_arrow_red.png")
						var_4_0.imgDownOrUp:scaleY(-1.3)
						var_4_0.imgFlag:texture("city/pvp/craft/icon_lose.png")
						var_4_0.imgBG:texture("city/pvp/cross_arena/panel_lose.png")
					end

					bind.extend(arg_4_0, var_4_0.head, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_4_3.enemy_logo,
							frameId = arg_4_3.enemy_frame
						}
					})

					if arg_4_3.move == 0 then
						var_4_0.textNoChange:show()
						var_4_0.stage1:hide()
						var_4_0.stage2:hide()
						var_4_0.imgDownOrUp:hide()
					else
						var_4_0.textNoChange:hide()
						var_4_0.stage1:show()
						var_4_0.stage2:show()
						bind.extend(arg_4_0, var_4_0.stage1, {
							event = "extend",
							class = "stage_icon",
							props = {
								showRank = true,
								showStageBg = true,
								showStage = true,
								rank = arg_4_3.enemy_rank + arg_4_3.move,
								onNode = function(arg_5_0)
									arg_5_0:xy(60, 35):z(6):scale(0.9)
								end
							}
						})
						bind.extend(arg_4_0, var_4_0.stage2, {
							event = "extend",
							class = "stage_icon",
							props = {
								showRank = true,
								showStageBg = true,
								showStage = true,
								rank = arg_4_3.enemy_rank,
								onNode = function(arg_6_0)
									arg_6_0:xy(60, 35):z(6):scale(0.9)
								end
							}
						})
					end

					if arg_4_3.battle_mode == 1 then
						var_4_0.bgAttack:show()
						var_4_0.bgDefend:hide()
					else
						var_4_0.bgAttack:hide()
						var_4_0.bgDefend:show()
					end

					bind.touch(arg_4_0, var_4_0.btnReplay, {
						methods = {
							ended = functools.partial(arg_4_0.playbackBtn, arg_4_2, arg_4_3)
						}
					})
					bind.touch(arg_4_0, var_4_0.btnShare, {
						methods = {
							ended = functools.partial(arg_4_0.shareBtn, arg_4_2, arg_4_3)
						}
					})
					bind.touch(arg_4_0, arg_4_1, {
						methods = {
							ended = functools.partial(arg_4_0.clickCell, arg_4_3)
						}
					})
				end,
				onAfterBuild = function(arg_7_0)
					return
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				playbackBtn = bindHelper.self("onPlaybackClick"),
				shareBtn = bindHelper.self("onShareClick"),
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["goodPanel.list"] = {
		varname = "list1",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("bestData"),
				item = bindHelper.self("item1"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("head1", "textName", "textName1", "stage1", "stage2", "btnReplay", "head2", "txtTop", "txtTop1", "textTop", "textTop1", "textServe", "textServe1", "txtLvNode", "txtLvNode1", "txtLv", "txtLv1", "imgFlag", "imgFlag1", "imgBG")

					var_8_0.textName:text(arg_8_3.name)
					var_8_0.textName1:text(arg_8_3.defence_name)
					bind.extend(arg_8_0, var_8_0.head1, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_8_3.logo,
							frameId = arg_8_3.frame
						}
					})
					bind.extend(arg_8_0, var_8_0.head2, {
						event = "extend",
						class = "role_logo",
						props = {
							vip = false,
							level = false,
							logoId = arg_8_3.defence_logo,
							frameId = arg_8_3.defence_frame
						}
					})
					bind.extend(arg_8_0, var_8_0.stage1, {
						event = "extend",
						class = "stage_icon",
						props = {
							showRank = false,
							showStageBg = false,
							showStage = false,
							rank = arg_8_3.rank,
							onNode = function(arg_9_0)
								arg_9_0:xy(60, 35):z(6):scale(0.9)
							end
						}
					})
					bind.extend(arg_8_0, var_8_0.stage2, {
						event = "extend",
						class = "stage_icon",
						props = {
							showRank = false,
							showStageBg = false,
							showStage = false,
							rank = arg_8_3.defence_rank,
							onNode = function(arg_10_0)
								arg_10_0:xy(60, 35):z(6):scale(0.9)
							end
						}
					})

					if arg_8_3.result == "win" then
						var_8_0.imgBG:texture("city/pvp/cross_arena/list_bg_1.png")
						var_8_0.imgFlag:texture("city/pvp/craft/icon_win.png")
						var_8_0.imgFlag1:texture("city/pvp/craft/icon_lose.png")
					else
						var_8_0.imgBG:texture("city/pvp/cross_arena/list_bg_2.png")
						var_8_0.imgFlag1:texture("city/pvp/craft/icon_win.png")
						var_8_0.imgFlag:texture("city/pvp/craft/icon_lose.png")
					end

					local var_8_1 = dataEasy.getCrossArenaStageByRank(arg_8_3.rank)
					local var_8_2 = dataEasy.getCrossArenaStageByRank(arg_8_3.defence_rank)

					var_8_0.txtTop:text(var_8_1.stageName .. " " .. var_8_1.rank)
					var_8_0.txtTop1:text(var_8_2.stageName .. " " .. var_8_2.rank)
					var_8_0.textServe:text(string.format(gLanguageCsv.brackets, getServerArea(arg_8_3.role_key[1])))
					var_8_0.textServe1:text(string.format(gLanguageCsv.brackets, getServerArea(arg_8_3.defence_role_key[1])))
					var_8_0.txtLv:text(arg_8_3.level)
					var_8_0.txtLv1:text(arg_8_3.defence_level)
					adapt.oneLineCenterPos(cc.p(550, 60), {
						var_8_0.textName,
						var_8_0.textServe
					}, cc.p(0, 0))
					adapt.oneLineCenterPos(cc.p(1500, 60), {
						var_8_0.textName1,
						var_8_0.textServe1
					}, cc.p(0, 0))
					bind.touch(arg_8_0, arg_8_1, {
						methods = {
							ended = functools.partial(arg_8_0.clickCell, arg_8_2, arg_8_3)
						}
					})
					bind.touch(arg_8_0, var_8_0.btnReplay, {
						methods = {
							ended = functools.partial(arg_8_0.playbackBtn, arg_8_2, arg_8_3)
						}
					})
				end,
				onAfterBuild = function(arg_11_0)
					return
				end
			},
			handlers = {
				clickCell = bindHelper.self("oninfoClick"),
				playbackBtn = bindHelper.self("onPlaybackClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_12_0)
	arg_12_0:initModel()
	arg_12_0.emptyPanel:hide()
	arg_12_0.myPanel:hide()
	arg_12_0.goodPanel:hide()

	arg_12_0.combatDatas = arg_12_0.record:read().history
	arg_12_0.bestData = arg_12_0.bestRecord:read()
	arg_12_0.showTab = idler.new(1)
	arg_12_0.panel = {
		{
			node = arg_12_0.myPanel,
			data = arg_12_0.combatDatas,
			txtNode = gLanguageCsv.noBattleRecord
		},
		{
			node = arg_12_0.goodPanel,
			data = arg_12_0.bestData,
			txtNode = gLanguageCsv.noBestRecord
		}
	}
	arg_12_0.tabDatas = idlers.newWithMap({
		{
			fontSize = 50,
			name = gLanguageCsv.myBattle
		},
		{
			fontSize = 50,
			name = gLanguageCsv.bestBattle
		}
	})

	if arg_12_0.tmp == 2 then
		arg_12_0.showTab:set(2)
	end

	arg_12_0.showTab:addListener(function(arg_13_0, arg_13_1)
		arg_12_0.tabDatas:atproxy(arg_13_1).select = false
		arg_12_0.tabDatas:atproxy(arg_13_0).select = true

		arg_12_0.panel[arg_13_1].node:hide()
		arg_12_0.panel[arg_13_0].node:show()

		local var_13_0 = itertools.isempty(arg_12_0.panel[arg_13_0].data)

		arg_12_0.emptyPanel:visible(var_13_0)
		arg_12_0.emptyTxt:text(arg_12_0.panel[arg_13_0].txtNode)
	end)
	Dialog.onCreate(arg_12_0)
end

function var_0_1.initModel(arg_14_0)
	arg_14_0.record = gGameModel.cross_arena:getIdler("record")
	arg_14_0.bestRecord = gGameModel.cross_arena:getIdler("topBattleHistory")

	if not arg_14_0.tmp then
		arg_14_0.tmp = 0
	end
end

function var_0_1.onPlaybackClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = "/game/cross/arena/playrecord/get"

	gGameModel:playRecordBattle(arg_15_3.play_record_id, arg_15_3.cross_key, var_15_0, 0, nil)
end

function var_0_1.oninfoClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = "/game/cross/arena/playrecord/get"
	local var_16_1 = gGameModel:playRecordDeployInfo(arg_16_3.play_record_id, arg_16_3.cross_key, var_16_0, function(arg_17_0)
		gGameUI:stackUI("city.pvp.cross_arena.record_info", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_17_0)
	end)
end

function var_0_1.onItemClick(arg_18_0, arg_18_1, arg_18_2)
	gGameApp:requestServer("/game/cross/arena/role/info", function(arg_19_0)
		gGameUI:stackUI("city.pvp.cross_arena.personal_info", nil, {
			blackLayer = true,
			clickClose = true
		}, arg_19_0.view)
	end, arg_18_2.enemy_record_id, arg_18_2.key, arg_18_2.enemy_rank)
end

function var_0_1.onTabClick(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.showTab:set(arg_20_2)

	arg_20_0.tmp = arg_20_2
end

function var_0_1.onShareClick(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = gGameModel.daily_record:read("cross_arena_battle_share_times")

	if var_21_0 >= gCommonConfigCsv.shareTimesLimit then
		gGameUI:showTip(gLanguageCsv.shareTimesNotEnough)

		return
	end

	local var_21_1 = gCommonConfigCsv.shareTimesLimit - var_21_0
	local var_21_2 = {
		isRich = false,
		btnType = 2,
		cb = function()
			gGameApp:requestServer("/game/battle/share", function(arg_23_0)
				gGameUI:showTip(gLanguageCsv.recordShareSuccess)
			end, arg_21_3.play_record_id, arg_21_3.enemy_name, "crossArena", arg_21_3.cross_key)
		end,
		content = string.format(gLanguageCsv.shareBattleNote, var_21_1 .. "/" .. gCommonConfigCsv.shareTimesLimit)
	}

	gGameUI:showDialog(var_21_2)
end

return var_0_1
