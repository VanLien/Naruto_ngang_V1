local var_0_0 = class("GymCrossGate", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "gym_cross_gate.json"
var_0_0.RESOURCE_BINDING = {
	panel2 = "panel2",
	panel6 = "panel6",
	panel3 = "panel3",
	attrItem = "attrItem",
	panel4 = "panel4",
	panel1 = "panel1",
	imgFileter = "imgFileter",
	panel7 = "panel7",
	panel8 = "panel8",
	panel5 = "panel5",
	btnRule = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRuleClick")
			}
		}
	},
	["leftTop.arrList"] = {
		varname = "arrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrData"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_1_3])
				end
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.id = arg_2_1
	arg_2_0.crossUnlock = arg_2_2

	gGameUI.topuiManager:createView("default", arg_2_0, {
		onClose = arg_2_0:createHandler("onClose")
	}):init({
		subTitle = "The Pavilion Challenge",
		title = "common/txt/txt_bt_kuafudaochang.png"
	})
	arg_2_0:initModel()
	arg_2_0:initUI()
end

function var_0_0.initUI(arg_3_0)
	local var_3_0 = "city/adventure/gym_challenge/gate/"

	arg_3_0.imgFileter:texture(var_3_0 .. "bg_" .. csv.gym.gym[arg_3_0.id].texture):size(display.sizeInView)
	arg_3_0.panel1:get("imgBgCircle"):texture(var_3_0 .. "icon_" .. csv.gym.gym[arg_3_0.id].texture)
	arg_3_0.panel1:get("imgBgCircle"):runAction(cc.RepeatForever:create(cc.RotateBy:create(90, 360)))
	arg_3_0.panel1:get("imgOwner"):texture("city/adventure/gym_challenge/map/" .. csv.gym.gym[arg_3_0.id].namePng)
	arg_3_0:initMember()
end

function var_0_0.initModel(arg_4_0)
	arg_4_0.inCd = idler.new(false)
	arg_4_0.gates = idlers.newWithMap({})
	arg_4_0.gymDatas = gGameModel.role:getIdler("gym_datas")
	arg_4_0.gatesDatas = gGameModel.gym:getIdler("GymCrossGates")
	arg_4_0.crossAlGatesDatas = gGameModel.gym:getIdler("crossGymRoles")
	arg_4_0.attrData = idlers.newWithMap(csv.gym.gym[arg_4_0.id].limitAttribute)
	arg_4_0.round = gGameModel.gym:getIdler("round")

	idlereasy.when(arg_4_0.gymDatas, function(arg_5_0, arg_5_1)
		arg_4_0:initCountDown()
	end)
end

function var_0_0.initMember(arg_6_0)
	local var_6_0 = "city/adventure/gym_challenge/gate/"

	idlereasy.any({
		arg_6_0.crossAlGatesDatas,
		arg_6_0.inCd,
		arg_6_0.round
	}, function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		local var_7_0

		if arg_7_3 == "start" then
			var_7_0 = arg_7_1 or {}
		else
			var_7_0 = gGameModel.gym:read("lastCrossGymRoles") or {}
		end

		for iter_7_0 = 1, 8 do
			local var_7_1 = arg_6_0["panel" .. iter_7_0]
			local var_7_2 = var_7_1:get("infoPanel")
			local var_7_3 = var_7_1:get("emptyPanel")
			local var_7_4 = var_7_1:get("btnChallenge")
			local var_7_5 = var_7_4:get("textNote")
			local var_7_6 = var_7_0[arg_6_0.id] and var_7_0[arg_6_0.id][iter_7_0]

			if iter_7_0 == 1 then
				text.addEffect(var_7_1:get("textTime"), {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				})
			end

			if var_7_6 then
				var_7_2:show()
				var_7_3:hide()

				local var_7_7 = var_7_2:multiget("textFight", "textName", "textLv", "textSever", "txt", "figurePanel", "figurePanel")

				text.addEffect(var_7_7.textFight, {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				})
				text.addEffect(var_7_7.textLv, {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				})
				text.addEffect(var_7_7.textName, {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				})
				text.addEffect(var_7_7.textSever, {
					outline = {
						size = 2,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				})

				if iter_7_0 ~= 1 then
					text.addEffect(var_7_7.txt, {
						outline = {
							size = 2,
							color = ui.NEWCOLORS.OUTLINE.BLACK
						}
					})
				end

				var_7_7.textName:text(var_7_6.name)
				var_7_7.textLv:text("Lv." .. var_7_6.level)
				var_7_7.textFight:text(var_7_6.fighting_point)
				var_7_7.textSever:text(string.format(gLanguageCsv.brackets, getServerArea(var_7_6.game_key, true)))

				if iter_7_0 == 1 then
					adapt.oneLineCenterPos(cc.p(150, var_7_7.textLv:y()), {
						var_7_7.textLv,
						var_7_7.textName
					}, cc.p(6, 8))
					adapt.oneLineCenterPos(cc.p(150, var_7_7.textSever:y()), {
						var_7_7.txt,
						var_7_7.textFight,
						var_7_7.textSever
					}, {
						cc.p(10, -5),
						cc.p(0, 0)
					})
				else
					adapt.oneLineCenterPos(cc.p(150, var_7_7.textLv:y()), {
						var_7_7.textLv,
						var_7_7.textName
					}, cc.p(5, 6))
					adapt.oneLineCenterPos(cc.p(150, var_7_7.textSever:y()), {
						var_7_7.txt,
						var_7_7.textFight,
						var_7_7.textSever
					}, {
						cc.p(10, 0),
						cc.p(0, 0)
					})
				end

				if var_7_6.figure ~= "" then
					local var_7_8 = var_7_2:size()
					local var_7_9 = gRoleFigureCsv[var_7_6.figure]

					widget.addAnimationByKey(var_7_7.figurePanel, var_7_9.resSpine, "figure", "standby_loop", 1):xy(var_7_8.width / 2, 0):scale(iter_7_0 == 1 and 0.8 or 0.6)
					bind.touch(arg_6_0, var_7_7.figurePanel, {
						methods = {
							ended = function()
								gGameApp:requestServer("/game/gym/role/info", function(arg_9_0)
									gGameUI:createView("city.adventure.gym_challenge.master_info", arg_6_0):init(arg_9_0.view, arg_6_0.id, true, true, iter_7_0)
								end, var_7_6.record_id, var_7_6.game_key)
							end
						}
					})
				end

				var_7_1:get("btnChallenge.textNote"):text(gLanguageCsv.spaceChallenge)

				if iter_7_0 == 1 then
					var_7_4:y(0)
					var_7_1:get("textTime"):y(-60)
				end

				if gGameModel.role:read("gym_record_db_id") == var_7_6.record_id then
					var_7_4:hide()
				else
					if arg_7_2 then
						uiEasy.setBtnShader(var_7_4, var_7_5, 3)
						text.deleteAllEffect(var_7_5)
					else
						uiEasy.setBtnShader(var_7_4, var_7_5, 1)
						text.addEffect(var_7_5, {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							}
						})
					end

					var_7_4:show()
				end
			else
				var_7_2:hide()
				var_7_3:show()

				if iter_7_0 == 1 then
					var_7_1:get("btnChallenge.textNote"):text(gLanguageCsv.gymTobeOwner)
				else
					var_7_1:get("btnChallenge.textNote"):text(gLanguageCsv.gymTobeMember)
				end

				if arg_7_2 then
					uiEasy.setBtnShader(var_7_4, var_7_5, 3)
					text.deleteAllEffect(var_7_5)
				else
					uiEasy.setBtnShader(var_7_4, var_7_5, 1)
					text.addEffect(var_7_5, {
						outline = {
							size = 4,
							color = ui.NEWCOLORS.OUTLINE.YELLOW
						}
					})
				end
			end

			bind.touch(arg_6_0, var_7_4, {
				methods = {
					ended = function()
						if var_7_6 then
							arg_6_0:onBtnChallenge(iter_7_0, var_7_6)
						else
							arg_6_0:onBtnOccupy(iter_7_0)
						end
					end
				}
			})

			if arg_6_0:getChallengeState() == false or not arg_6_0.crossUnlock then
				uiEasy.setBtnShader(var_7_4, var_7_5, 3)
			end
		end
	end)
end

function var_0_0.onBtnChallenge(arg_11_0, arg_11_1, arg_11_2)
	if gGameModel.gym:read("crossKey") == "" then
		gGameUI:showTip(gLanguageCsv.crossGymNotOpen)

		return
	end

	if arg_11_0:getChallengeState() == false then
		gGameUI:showTip(gLanguageCsv.gymTimeOut)

		return
	end

	if not arg_11_0.crossUnlock then
		gGameUI:showTip(gLanguageCsv.gymCrossTips1)

		return
	end

	if arg_11_0.inCd:read() then
		gGameUI:showTip(gLanguageCsv.gymInCd)

		return
	end

	local var_11_0 = csv.gym.gym[arg_11_0.id].limitAttribute

	if #dataEasy.getNatureSprite(var_11_0) == 0 then
		gGameUI:showTip(gLanguageCsv.gymNoSptire1)

		return
	end

	local function var_11_1(arg_12_0, arg_12_1)
		if arg_11_0:getChallengeState() == false then
			gGameUI:showTip(gLanguageCsv.gymTimeOut)

			return
		end

		local var_12_0 = arg_12_1:read()

		battleEntrance.battleRequest("/game/cross/gym/battle/start", var_12_0, arg_11_0.id, arg_11_1, arg_11_2.game_key, arg_11_2.record_id):onStartOK(function(arg_13_0)
			arg_12_0:onClose(false)
		end):run():show()
	end

	gGameUI:stackUI("city.adventure.gym_challenge.embattle1", nil, {
		full = true
	}, {
		fightCb = var_11_1,
		limitInfo = csv.gym.gym[arg_11_0.id].limitAttribute,
		from = game.EMBATTLE_FROM_TABLE.onekey
	})
end

function var_0_0.onBtnOccupy(arg_14_0, arg_14_1)
	if gGameModel.gym:read("crossKey") == "" then
		gGameUI:showTip(gLanguageCsv.crossGymNotOpen)

		return
	end

	if arg_14_0:getChallengeState() == false then
		gGameUI:showTip(gLanguageCsv.gymTimeOut)

		return
	end

	if not arg_14_0.crossUnlock then
		gGameUI:showTip(gLanguageCsv.gymCrossTips1)

		return
	end

	if arg_14_0.inCd:read() then
		gGameUI:showTip(gLanguageCsv.gymInCd)

		return
	end

	local var_14_0 = csv.gym.gym[arg_14_0.id].limitAttribute

	if #dataEasy.getNatureSprite(var_14_0) == 0 then
		gGameUI:showTip(gLanguageCsv.gymNoSptire2)

		return
	end

	local function var_14_1(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		local var_15_0 = arg_15_1:read()

		gGameApp:requestServer("/game/cross/gym/battle/occupy", function(arg_16_0)
			arg_15_2:set(var_15_0)

			arg_15_0.haveSaved = true

			if arg_15_3 then
				arg_15_0:onClose(false)
			else
				gGameUI:showTip(gLanguageCsv.positionSave)
			end
		end, var_15_0, arg_14_0.id, arg_14_1)
	end

	gGameUI:stackUI("city.adventure.gym_challenge.embattle1", nil, {
		full = true
	}, {
		saveCb = var_14_1,
		limitInfo = csv.gym.gym[arg_14_0.id].limitAttribute,
		from = game.EMBATTLE_FROM_TABLE.onekey
	})
end

function var_0_0.getChallengeState(arg_17_0)
	if arg_17_0.round:read() == "closed" then
		return false
	end

	return time.getNumTimestamp(gGameModel.gym:read("date"), 21, 45) + 518400 > time.getTime()
end

function var_0_0.initCountDown(arg_18_0)
	local var_18_0 = arg_18_0.panel1:get("textTime"):show()

	if not arg_18_0:getChallengeState() then
		var_18_0:hide()

		return
	end

	local function var_18_1()
		local var_19_0 = gGameModel.role:read("gym_datas").cross_gym_pw_last_time + gCommonConfigCsv.gymPwCD
		local var_19_1 = time.getCutDown(var_19_0 - time.getTime())

		var_18_0:text(var_19_1.short_date_str .. gLanguageCsv.gymTimeLimit)
		adapt.oneLinePos(var_18_0, arg_18_0.textNote1, cc.p(5, 0), "right")

		if var_19_0 - time.getTime() <= 0 then
			var_18_0:hide()
			arg_18_0:unSchedule(1)
			arg_18_0.inCd:set(false)

			return false
		else
			arg_18_0.inCd:set(true)

			return true
		end
	end

	arg_18_0:enableSchedule()
	var_18_1()
	arg_18_0:unScheduleAll()
	arg_18_0:schedule(function(arg_20_0)
		if not var_18_1() then
			return false
		end
	end, 1, 0, 1)
end

function var_0_0.onBtnRuleClick(arg_21_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_21_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_0.getRuleContext(arg_22_0, arg_22_1)
	local var_22_0 = adaptContext
	local var_22_1 = {
		var_22_0.clone(arg_22_1.title, function(arg_23_0)
			arg_23_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_22_0.noteText(103001, 103100)
	}

	if arg_22_0.round:read() == "start" then
		local var_22_2 = gGameModel.gym:read("servers")

		if var_22_2 then
			local var_22_3 = arraytools.map(getMergeServers(var_22_2), function(arg_24_0, arg_24_1)
				return string.format(gLanguageCsv.brackets, getServerArea(arg_24_1, nil, true))
			end)

			table.insert(var_22_1, 2, "#C0x5B545B#" .. gLanguageCsv.currentServers .. table.concat(var_22_3, ","))
		end
	end

	for iter_22_0, iter_22_1 in orderCsvPairs(csv.gym.gym) do
		table.insert(var_22_1, var_22_0.clone(arg_22_1.awardItem, function(arg_25_0)
			local var_25_0 = arg_25_0:multiget("text", "list")

			var_25_0.text:text("")
			rich.createByStr("#C0x5b545b#" .. iter_22_1.crossLeaderAwardDesc, 40):anchorPoint(1, 0.5):xy(260, 100):addTo(var_25_0.text, 6)
			uiEasy.createItemsToList(arg_22_1, var_25_0.list, iter_22_1.crossLeaderAward)
		end))
		table.insert(var_22_1, var_22_0.clone(arg_22_1.awardItem, function(arg_26_0)
			local var_26_0 = arg_26_0:multiget("text", "list")

			var_26_0.text:text("")
			rich.createByStr("#C0x5b545b#" .. iter_22_1.crossSubAwardDesc, 40):anchorPoint(1, 0.5):xy(260, 100):addTo(var_26_0.text, 6)
			uiEasy.createItemsToList(arg_22_1, var_26_0.list, iter_22_1.crossSubAward)
		end))
	end

	return var_22_1
end

return var_0_0
