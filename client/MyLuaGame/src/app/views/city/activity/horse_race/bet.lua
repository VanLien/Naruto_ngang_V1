local var_0_0 = class("HorseRaceBet", Dialog)

var_0_0.RESOURCE_FILENAME = "horse_race_bet.json"
var_0_0.RESOURCE_BINDING = {
	player = "player",
	["topPanel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["betPanel.list"] = {
		varname = "bet",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				backupCached = false,
				data = bindHelper.self("itemData"),
				item = bindHelper.self("player"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("btnBet")
					local var_1_1 = arg_1_1:get("cost")
					local var_1_2 = arg_1_1:get("get")

					var_1_1:get("num"):text(gCommonConfigCsv.horseRaceBetCost)

					if arg_1_3.idx ~= 0 or arg_1_3.status ~= 2 and arg_1_3.status ~= 5 or arg_1_3.round ~= "prepare" then
						var_1_1:setVisible(false)
						var_1_0:get("bet"):text(gLanguageCsv.horseRaceNoBet)
						text.addEffect(var_1_0:get("bet"), {
							color = ui.COLORS.DISABLED.WHITE
						})
						cache.setShader(var_1_0, false, "hsl_gray")
					end

					if arg_1_3.idx == arg_1_2 then
						var_1_1:setVisible(false)
						var_1_0:setVisible(false)
						var_1_2:setVisible(true)
					end

					local var_1_3 = csv.cross.horse_race.horse_race_card[arg_1_3.val.csv_id]
					local var_1_4 = arg_1_1:get("name")
					local var_1_5 = arg_1_1:get("speed")
					local var_1_6 = arg_1_1:get("stamina")
					local var_1_7 = arg_1_1:get("sprintTime")
					local var_1_8 = arg_1_1:get("sprint")

					var_1_4:text(string.format(gLanguageCsv.horseRaceID, arg_1_2, var_1_3.name))
					var_1_5:text(string.format(gLanguageCsv.horseRaceSpeed, var_1_3.speed))
					var_1_6:text(string.format(gLanguageCsv.horseRaceStamina, var_1_3.stamina))
					var_1_7:text(string.format(gLanguageCsv.horseRaceSprintTime, var_1_3.sprintTime / 10))
					var_1_8:text(string.format(gLanguageCsv.horseRaceSprint, var_1_3.sprintRandom))
					ccui.ImageView:create(csv.unit[var_1_3.unitID].cardShow):addTo(arg_1_1:get("img"), 1, "img"):alignCenter(arg_1_1:get("img"):size())
					bind.touch(arg_1_0, arg_1_1:get("btnBet"), {
						methods = {
							ended = functools.partial(arg_1_0.onBetClick, arg_1_3.val.csv_id, arg_1_1)
						}
					})
				end
			},
			handlers = {
				onBetClick = bindHelper.self("onBetClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.activityId = arg_2_1
	arg_2_0.data, arg_2_0.status, arg_2_0.cb = arg_2_2()
	arg_2_0.play = arg_2_0.data:read().view.play
	arg_2_0.bet = false

	arg_2_0:initModel()

	local var_2_0 = {}

	arg_2_0.itemData = idlertable.new(var_2_0)

	idlereasy.any({
		arg_2_0.yyhuodongs,
		arg_2_0.status,
		arg_2_0.data
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		local var_3_0 = arg_3_1[arg_2_1] or {}
		local var_3_1 = {}

		for iter_3_0, iter_3_1 in pairs(arg_3_3.view.race_cards) do
			local var_3_2 = tonumber(time.getTodayStr())

			if var_3_0 and var_3_0.horse_race.bet_award and var_3_0.horse_race.bet_award[var_3_2] and var_3_0.horse_race.bet_award[var_3_2][arg_2_0.play] then
				if var_3_0.horse_race.bet_award[var_3_2][arg_2_0.play][1] or 0 > 0 then
					arg_2_0.bet = true
				end

				table.insert(var_3_1, {
					val = iter_3_1,
					idx = var_3_0.horse_race.bet_award[var_3_2][arg_2_0.play][1] + 1,
					status = arg_3_2,
					round = arg_3_3.view.round
				})
			else
				table.insert(var_3_1, {
					idx = 0,
					val = iter_3_1,
					status = arg_3_2,
					round = arg_3_3.view.round
				})
			end
		end

		arg_2_0.itemData:set(var_3_1)
	end)
	Dialog.onCreate(arg_2_0)
end

function var_0_0.initModel(arg_4_0)
	arg_4_0.yyhuodongs = gGameModel.role:getIdler("yyhuodongs")
	arg_4_0.rmb = gGameModel.role:getIdler("rmb")
end

function var_0_0.onBetClick(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.status:read()

	if arg_5_0.bet then
		gGameUI:showTip(gLanguageCsv.horseRaceAlreadyBet)
	elseif var_5_0 == 3 or var_5_0 == 6 or var_5_0 == 1 or var_5_0 == 4 or arg_5_0.data:read().view.round ~= "prepare" then
		gGameUI:showTip(gLanguageCsv.horseRaceDoNotBet)
	elseif arg_5_0.rmb:read() < gCommonConfigCsv.horseRaceBetCost then
		uiEasy.showDialog("rmb")
	else
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = string.format(gLanguageCsv.horseRaceBetTips, gCommonConfigCsv.horseRaceBetCost),
			cb = function()
				gGameApp:requestServer("/game/yy/horse/race/bet", function(arg_7_0)
					arg_5_0.localData = arg_7_0
				end, arg_5_0.activityId, arg_5_0.data:read().view.date, arg_5_0.play, arg_5_2)
			end
		})
	end
end

function var_0_0.onClose(arg_8_0)
	if arg_8_0.localData then
		arg_8_0.data:set(arg_8_0.localData)
	elseif arg_8_0.cb then
		arg_8_0:addCallbackOnExit(arg_8_0.cb)
	end

	Dialog.onClose(arg_8_0)
end

return var_0_0
