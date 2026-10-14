local var_0_0 = class("BattleEndPvpWinView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "battle_end_pvp_win.json"
var_0_0.RESOURCE_BINDING = {
	imgBestCard = "bestCard",
	["imgRankBg.bg"] = "imgRankBg",
	sharePanel = "sharePanel",
	playBackPanel = "playBackPanel",
	imgRankBg = "imgRankPanel",
	imgNewRecord = "newRecord",
	["imgRankBg.imgUp"] = "imgUp",
	["imgBestBg.bestName"] = {
		varname = "bestName",
		binds = {
			event = "effect",
			data = {
				italic = true,
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["playBackPanel.playBackBg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onPlayBackBtnClick")
			}
		}
	},
	["playBackPanel.txt"] = {},
	["sharePanel.txt"] = {},
	["sharePanel.shareBg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShareBtnClick")
			}
		}
	},
	imgBg = {
		binds = {
			event = "click",
			method = bindHelper.self("onCloseClick")
		}
	},
	["imgRankBg.rank"] = {
		varname = "rank"
	},
	["imgRankBg.rankUp"] = {
		varname = "rankUp"
	}
}

function var_0_0.playEffect(arg_1_0)
	local var_1_0 = arg_1_0:getResourceNode()
	local var_1_1, var_1_2 = var_1_0:get("title"):xy()

	widget.addAnimationByKey(var_1_0, "effect/gongxihuode.skel", "selEffect", "zhandoujiangli_new", 100):anchorPoint(cc.p(0.5, 0.5)):xy(var_1_1 - 350, var_1_2 - 230):addPlay("zhandoujiangli_new_loop"):scale(2)
end

function var_0_0.playBestEffect(arg_2_0)
	local var_2_0 = arg_2_0:getResourceNode()
	local var_2_1 = csv.unit[arg_2_0.bestCardId].unitRes
	local var_2_2 = string.gsub(var_2_1, ".skel", "_ui.skel")
	local var_2_3 = CSprite.new(var_2_2)

	var_2_3:addTo(var_2_0, 100)
	var_2_3:setAnchorPoint(cc.p(0.5, 1))
	var_2_3:setPosition(display.cx / 3, -188)
	var_2_3:visible(true)
	var_2_3:play("standby_loop")
	var_2_3:retain()
	var_2_3:scale(2)

	local var_2_4 = CSprite.new("effect/benchangzuijia.skel")

	var_2_4:addTo(var_2_0, 101)
	var_2_4:setAnchorPoint(cc.p(0.5, 1))
	var_2_4:setPosition(display.cx + 215, display.cy)
	var_2_4:visible(true)
	var_2_4:setName("zuijia")
	var_2_4:play("benchangzuijia_loop")
	var_2_4:retain()
	var_2_4:scale(2)
end

function var_0_0.onCreate(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	audio.playEffectWithWeekBGM("pvp_win.mp3")

	arg_3_0.data = arg_3_2
	arg_3_0.results = arg_3_3

	local var_3_0 = arg_3_2.roleOut
	local var_3_1 = arg_3_3.mvpPosId

	if arg_3_3.mvpCardIn then
		var_3_0 = arg_3_2.roleOut[1][arg_3_3.mvpCardIn]
	end

	if var_3_0[var_3_1] == nil and var_3_1 > 6 then
		var_3_1 = var_3_1 - 6
	end

	arg_3_0.bestCardId = var_3_0[var_3_1].roleId

	local var_3_2 = var_3_0[var_3_1].cardId
	local var_3_3 = gGameModel.cards:find(var_3_2)
	local var_3_4

	if var_3_3 then
		var_3_4 = var_3_3:read("name")
	end

	if not var_3_3 or not var_3_4 or var_3_4 == "" then
		local var_3_5 = csv.unit[arg_3_0.bestCardId].cardID

		var_3_4 = csv.cards[var_3_5].name
	end

	if arg_3_3.recordType and arg_3_3.recordType == "jf" then
		arg_3_0.imgRankBg:loadTexture("battle/end/win/img_jifen_bg.png")
	end

	arg_3_0:playEffect()
	arg_3_0:cardPosCorrect()
	arg_3_0.bestName:text(var_3_4)
	arg_3_0:playBestEffect()

	local var_3_6 = arg_3_3.serverData.view
	local var_3_7 = var_3_6.top_move or 0
	local var_3_8 = var_3_6.rank
	local var_3_9 = var_3_8 and var_3_8 + var_3_6.rank_move

	arg_3_0.newRecord:visible(var_3_7 > 0)

	if arg_3_3.flag == "crossArena" then
		local var_3_10 = dataEasy.getCrossArenaStageByRank(var_3_9)
		local var_3_11 = dataEasy.getCrossArenaStageByRank(var_3_8)
		local var_3_12 = var_3_10.stageName .. " " .. var_3_10.rank
		local var_3_13 = var_3_11.stageName .. " " .. var_3_11.rank

		arg_3_0.rank:text(var_3_12)
		arg_3_0.rankUp:text(var_3_13)
		adapt.oneLineCenterPos(cc.p(400, 80), {
			arg_3_0.rank,
			arg_3_0.imgUp,
			arg_3_0.rankUp
		}, cc.p(40, 0))
		arg_3_0.newRecord:y(900)

		local var_3_14 = arg_3_0.rank:x() - arg_3_0.rank:anchorPoint().x * arg_3_0.rank:width()
		local var_3_15 = arg_3_0.rankUp:x() + (1 - arg_3_0.rankUp:anchorPoint().x) * arg_3_0.rankUp:width() - var_3_14
		local var_3_16 = 240

		arg_3_0.imgRankBg:x(var_3_14 - var_3_16):width(var_3_15 + var_3_16)

		arg_3_0.crossData = table.deepcopy(gGameModel.cross_arena:read("record").history, true)

		table.sort(arg_3_0.crossData, function(arg_4_0, arg_4_1)
			return arg_4_0.time > arg_4_1.time
		end)
	elseif arg_3_3.flag == "onlineFight" then
		if arg_3_0.results.serverData.view.pattern == 1 then
			arg_3_0.crossData = table.deepcopy(gGameModel.cross_online_fight:read("unlimited_history"), true)
		else
			arg_3_0.crossData = table.deepcopy(gGameModel.cross_online_fight:read("limited_history"), true)
		end

		table.sort(arg_3_0.crossData, function(arg_5_0, arg_5_1)
			return arg_5_0.time > arg_5_1.time
		end)
		arg_3_0.rank:text(var_3_8)
		arg_3_0.rankUp:text(var_3_6.rank_move)
		adapt.oneLineCenterPos(cc.p(400, 80), {
			arg_3_0.rank,
			arg_3_0.imgUp,
			arg_3_0.rankUp
		}, cc.p(20, 0))
	elseif arg_3_3.flag == "gymLeader" then
		local var_3_17 = arg_3_0.imgRankPanel:x()
		local var_3_18 = arg_3_0.imgRankPanel:y()

		arg_3_0.newRecord:loadTexture("city/pvp/reward/panle_gx.png"):scale(1):visible(true):xy(var_3_17, var_3_18)

		local var_3_19 = arg_3_3.gymMember and gLanguageCsv.gymMemberBattleWin or string.format(gLanguageCsv.gymLeaderBattleWin, arg_3_3.gymName)
		local var_3_20 = matchLanguage({
			"kr",
			"en"
		}) and 65 or 80

		rich.createByStr(var_3_19, var_3_20):anchorPoint(0.5, 0.5):xy(var_3_17, var_3_18 + 22):addTo(arg_3_0.newRecord:parent()):z(10)
		arg_3_0.imgRankPanel:hide()
		arg_3_0.sharePanel:hide()
	elseif arg_3_3.flag == "crossMine" then
		local var_3_21 = arg_3_0.imgRankPanel:x()
		local var_3_22 = arg_3_0.imgRankPanel:y()

		arg_3_0.imgRankPanel:xy(var_3_21, var_3_22 + 150)

		if var_3_6.speed then
			local var_3_23 = string.format(gLanguageCsv.crossMinePVPSpeed, var_3_6.speed)

			rich.createByStr(var_3_23, 50):anchorPoint(0, 0.5):xy(var_3_21 - 290, var_3_22 + 50):addTo(arg_3_0.imgRankPanel:parent()):z(10)
		end

		if var_3_6.robNum then
			local var_3_24 = ccui.ImageView:create():anchorPoint(0.5, 0.5):xy(var_3_21 - 200, var_3_22 - 50):addTo(arg_3_0.imgRankPanel:parent()):texture("city/pvp/cross_mine/icon_kfzy.png"):show()
			local var_3_25 = string.format(gLanguageCsv.crossMinePVPRob, var_3_6.robNum)

			rich.createByStr(var_3_25, 60):anchorPoint(0, 0.5):xy(var_3_21 - 120, var_3_22 - 50):addTo(arg_3_0.imgRankPanel:parent()):z(10)
		end

		arg_3_0.rank:text(var_3_8)
		arg_3_0.rankUp:text(var_3_6.rank_move)

		arg_3_0.crossData = table.deepcopy(gGameModel.cross_mine:read("record").history, true)
	else
		arg_3_0.rank:text(var_3_8)
		arg_3_0.rankUp:text(var_3_6.rank_move)
		adapt.oneLineCenterPos(cc.p(400, 80), {
			arg_3_0.rank,
			arg_3_0.imgUp,
			arg_3_0.rankUp
		}, cc.p(20, 0))
	end
end

function var_0_0.onPlayBackBtnClick(arg_6_0)
	if arg_6_0.results.flag == "onlineFight" then
		local var_6_0 = arg_6_0.data

		if not arg_6_0.data.play_record_id or not arg_6_0.data.cross_key then
			local var_6_1

			if arg_6_0.results.serverData.view.pattern == 1 then
				var_6_1 = table.deepcopy(gGameModel.cross_online_fight:read("unlimited_history"), true)
			else
				var_6_1 = table.deepcopy(gGameModel.cross_online_fight:read("limited_history"), true)
			end

			table.sort(var_6_1, function(arg_7_0, arg_7_1)
				return arg_7_0.time > arg_7_1.time
			end)

			var_6_0 = var_6_1[1]
		end

		gGameModel:playRecordBattle(var_6_0.play_record_id, var_6_0.cross_key, "/game/cross/online/playrecord/get", 0)

		return
	end

	battleEntrance.battleRecord(arg_6_0.data, arg_6_0.results):show()
end

function var_0_0.onShareBtnClick(arg_8_0)
	local var_8_0 = ""
	local var_8_1 = ""
	local var_8_2 = arg_8_0.data

	if arg_8_0.results.flag == "crossArena" then
		var_8_0 = "cross_arena_battle_share_times"
		var_8_1 = "crossArena"
		var_8_2 = arg_8_0.crossData[1]
	elseif arg_8_0.results.flag == "onlineFight" then
		var_8_0 = "cross_online_fight_share_times"
		var_8_1 = "onlineFight"
		var_8_2 = arg_8_0.crossData[1]
		var_8_2.enemy_name = var_8_2.enemy.name
	elseif arg_8_0.results.flag == "crossMine" then
		var_8_0 = "cross_mine_share_times"
		var_8_1 = "crossMine"
		var_8_2 = arg_8_0.crossData[1]
	end

	if var_8_0 ~= "" and var_8_1 ~= "" then
		local var_8_3 = gGameModel.daily_record:getIdler(var_8_0):read()

		if var_8_3 >= gCommonConfigCsv.shareTimesLimit then
			gGameUI:showTip(gLanguageCsv.shareTimesNotEnough)

			return
		end

		local var_8_4 = gCommonConfigCsv.shareTimesLimit - var_8_3
		local var_8_5 = {
			isRich = false,
			btnType = 2,
			cb = function()
				gGameApp:requestServer("/game/battle/share", function(arg_10_0)
					gGameUI:showTip(gLanguageCsv.recordShareSuccess)
				end, var_8_2.play_record_id, var_8_2.enemy_name, var_8_1, var_8_2.cross_key)
			end,
			content = string.format(gLanguageCsv.shareBattleNote, var_8_4 .. "/" .. gCommonConfigCsv.shareTimesLimit)
		}

		gGameUI:showDialog(var_8_5)
	else
		local var_8_6 = arg_8_0.data

		uiEasy.shareBattleToChat(var_8_6.battleID, var_8_6.names[2])
	end
end

function var_0_0.onCloseClick(arg_11_0)
	if arg_11_0.results.backCity == true then
		gGameUI:switchUI("city.view")
	elseif arg_11_0.results.flag == "crossArena" then
		local var_11_0 = arg_11_0.showEndView

		arg_11_0:onClose()
		var_11_0()
	else
		gGameUI:switchUI("city.view")
	end
end

function var_0_0.cardPosCorrect(arg_12_0)
	local var_12_0, var_12_1 = arg_12_0.bestCard:getPosition()
	local var_12_2 = csv.unit[arg_12_0.bestCardId].cardShowPosC
	local var_12_3 = var_12_0 + var_12_2.x
	local var_12_4 = var_12_1 + var_12_2.y

	arg_12_0.bestCard:setPosition(var_12_3, var_12_4)
end

function var_0_0.bestCardScale(arg_13_0)
	local var_13_0 = csv.unit[arg_13_0.bestCardId].cardShow
	local var_13_1 = csv.unit[arg_13_0.bestCardId].cardShowScale * gCommonConfigCsv.pvpCardShowScale

	arg_13_0.bestCard:scale(var_13_1)
	arg_13_0.bestCard:texture(var_13_0)
end

return var_0_0
