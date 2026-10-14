local function var_0_0(arg_1_0)
	return time.getCutDown(math.max(time.getTime() - arg_1_0, 0), nil, true).short_date_str .. gLanguageCsv.before
end

local var_0_1 = class("HorseRaceRecordView", Dialog)

var_0_1.RESOURCE_FILENAME = "horse_race_record.json"
var_0_1.RESOURCE_BINDING = {
	["rankPanel.recordItem"] = "recordItem",
	emptyPanel = "emptyPanel",
	rankPanel = "rankPanel",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["rankPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("raceDatas"),
				item = bindHelper.self("recordItem"),
				dataOrderCmpGen = bindHelper.self("onSortRace", true),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("txtDay", "txtTurn", "horseList", "horseItem", "btnGet", "txtNoReward", "btnReplay")

					var_2_0.txtDay:text(string.format(gLanguageCsv.horseRaceRecordDay, arg_2_3.day))
					var_2_0.txtTurn:text(string.format(gLanguageCsv.horseRaceRecordTurn, arg_2_3.turn))
					var_2_0.txtNoReward:visible(arg_2_3.rewardFlag < 0)

					local var_2_1 = var_2_0.btnGet
					local var_2_2 = var_2_1:get("iconBox")

					var_2_1:visible(arg_2_3.rewardFlag >= 0)
					var_2_2:texture("other/gain_gold/icon_box" .. (arg_2_3.rewardFlag < 1 and "_open5.png" or "5.png"))
					bind.touch(arg_2_0, var_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.btnGet, arg_2_2, arg_2_3, arg_2_1)
						}
					})

					if arg_2_3.rewardFlag == 1 then
						local var_2_3 = widget.addAnimation(var_2_1, "effect/jiedianjiangli.skel", "effect_loop", var_2_2:z() - 1)

						var_2_3:scale(0.35):x(var_2_2:x()):y(var_2_2:y() - 30)

						var_2_1.effectBox = var_2_3
					elseif var_2_1.effectBox then
						var_2_1.effectBox:hide()
						var_2_1.effectBox:removeFromParent()

						var_2_1.effectBox = nil
					end

					uiEasy.addVibrateToNode(arg_2_0, var_2_2, arg_2_3.rewardFlag == 1, arg_2_1:getName() .. arg_2_2 .. "vibrate")
					bind.touch(arg_2_0, var_2_0.btnReplay, {
						methods = {
							ended = functools.partial(arg_2_0.playbackBtn, arg_2_2, arg_2_3)
						}
					})

					local var_2_4 = arg_2_3.betIdx
					local var_2_5 = arg_2_3.players

					bind.extend(arg_2_0, var_2_0.horseList, {
						class = "listview",
						props = {
							data = var_2_5,
							item = var_2_0.horseItem,
							onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
								local var_3_0 = arg_3_1:multiget("betMark", "txtHorseRank")
								local var_3_1 = csv.cross.horse_race.horse_race_card[arg_3_3.csv_id]

								ccui.ImageView:create(csv.unit[var_3_1.unitID].cardIcon):addTo(arg_3_1, 1, "img"):alignCenter(arg_3_1:size()):scale(2)
								ccui.ImageView:create("common/icon/panel_icon.png"):addTo(arg_3_1, 0, "imgBg"):alignCenter(arg_3_1:size())
								var_3_0.betMark:visible(arg_3_3.idx == var_2_4)
								var_3_0.txtHorseRank:text(string.format(gLanguageCsv.horseRaceRecordRank, arg_3_3.result))
							end
						}
					})
				end,
				onAfterBuild = function(arg_4_0)
					arg_4_0.afterBuild()
				end
			},
			handlers = {
				afterBuild = bindHelper.self("onAfterBuild"),
				playbackBtn = bindHelper.self("onPlaybackClick"),
				btnGet = bindHelper.self("onGetClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:initModel()

	arg_5_0.activityId = arg_5_1

	arg_5_0.emptyPanel:hide()

	local var_5_0 = arg_5_2()
	local var_5_1 = csv.yunying.yyhuodong[arg_5_0.activityId].beginDate

	idlereasy.any({
		arg_5_0.yyhuodongs,
		var_5_0
	}, function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_1[arg_5_0.activityId]
		local var_6_1 = {}

		if var_6_0 and var_6_0.horse_race and var_6_0.horse_race.bet_award then
			var_6_1 = var_6_0.horse_race.bet_award
		end

		local var_6_2 = {}

		for iter_6_0, iter_6_1 in pairs(arg_6_2.view.history) do
			for iter_6_2, iter_6_3 in pairs(iter_6_1) do
				local var_6_3 = {}

				if var_6_1[iter_6_0] and var_6_1[iter_6_0][iter_6_2] then
					var_6_3 = var_6_1[iter_6_0][iter_6_2]
				end

				local var_6_4 = {}

				for iter_6_4, iter_6_5 in ipairs(iter_6_3) do
					local var_6_5 = {
						idx = iter_6_4,
						csv_id = iter_6_5.csv_id,
						result = iter_6_5.result,
						idx = iter_6_4
					}

					table.insert(var_6_4, var_6_5)
				end

				table.sort(var_6_4, function(arg_7_0, arg_7_1)
					return arg_7_0.result < arg_7_1.result
				end)

				local var_6_6 = {
					date = iter_6_0,
					turn = iter_6_2,
					day = math.floor((time.getNumTimestamp(iter_6_0) - time.getNumTimestamp(var_5_1)) / 86400) + 1,
					players = var_6_4,
					betIdx = var_6_3[1] and var_6_3[1] + 1,
					rank = var_6_3[2],
					rewardFlag = var_6_3[3] or -2
				}

				table.insert(var_6_2, var_6_6)
			end
		end

		arg_5_0.raceDatas:update(var_6_2)
	end)
	Dialog.onCreate(arg_5_0)
end

function var_0_1.initModel(arg_8_0)
	arg_8_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_8_0.raceDatas = idlers.new()
end

function var_0_1.onPlaybackClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	gGameApp:requestServer("/game/yy/horse/race/playback", function(arg_10_0)
		gGameUI:stackUI("city.activity.horse_race.match", nil, nil, arg_9_0.activityId, {
			arg_10_0.view,
			arg_9_3.betIdx
		})
	end, arg_9_0.activityId, arg_9_3.date, arg_9_3.turn)
end

function var_0_1.onGetClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if arg_11_3.rewardFlag == 1 then
		local var_11_0 = arg_11_4:get("btnGet"):get("iconBox")
		local var_11_1 = {
			false
		}

		gGameApp:requestServerCustom("/game/yy/horse/race/bet/award"):params(arg_11_0.activityId, arg_11_3.date, arg_11_3.turn):onResponse(function(arg_12_0)
			arg_11_0.raceDatas:atproxy(arg_11_2).rewardFlag = 0

			uiEasy.addVibrateToNode(arg_11_1, var_11_0, arg_11_3.rewardFlag == 1, arg_11_4:getName() .. arg_11_2 .. "vibrate")
			var_11_0:texture("other/gain_gold/icon_box_open5.png")
			uiEasy.setBoxEffect(var_11_0, 0.5, function()
				var_11_1[1] = true
			end, -15, 10)
		end):wait(var_11_1):doit(function(arg_14_0)
			gGameUI:showGainDisplay(arg_14_0)
		end)
	else
		local var_11_2 = csv.yunying.horse_race_bet_award[1]
		local var_11_3 = csv.yunying.yyhuodong[arg_11_0.activityId].huodongID

		for iter_11_0, iter_11_1 in csvPairs(csv.yunying.horse_race_bet_award) do
			if iter_11_1.huodongID == var_11_3 and iter_11_1.rank == arg_11_3.rank then
				var_11_2 = iter_11_1

				break
			end
		end

		gGameUI:showBoxDetail({
			content = "",
			state = 0,
			data = var_11_2.award
		})
	end
end

function var_0_1.onAfterBuild(arg_15_0)
	local var_15_0 = arg_15_0.list:getChildrenCount() == 0

	arg_15_0.emptyPanel:visible(var_15_0)
	arg_15_0.rankPanel:visible(not var_15_0)
end

function var_0_1.onSortRace(arg_16_0, arg_16_1)
	return function(arg_17_0, arg_17_1)
		if arg_17_0.date == arg_17_1.date then
			return arg_17_0.turn > arg_17_1.turn
		else
			return arg_17_0.date > arg_17_1.date
		end
	end
end

return var_0_1
