local var_0_0 = 3
local var_0_1 = 6
local var_0_2 = {
	ban = 2,
	deploy = 4,
	pick = 3,
	empty = 1
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_0 == 1 then
		arg_1_2:scale(-1, 1)
	end

	local var_1_0 = arg_1_4.dbid

	arg_1_2:get("flag"):hide()
	arg_1_2:removeChildByName("effect")

	if var_1_0 == -1 then
		bind.extend(arg_1_1, arg_1_2, {
			class = "card_icon",
			props = {
				cardId = -1,
				onNode = function(arg_2_0)
					arg_2_0:scale(0.6)

					local var_2_0 = arg_2_0:box()

					arg_2_0:alignCenter(var_2_0)
					arg_1_2:size(var_2_0)

					if arg_1_0 == 2 then
						arg_2_0:get("icon"):scale(-1, 1)
					end
				end
			}
		})
	else
		local var_1_1 = arg_1_4.banpickCards
		local var_1_2 = var_1_1.card_id
		local var_1_3 = csv.cards[var_1_2]
		local var_1_4 = csv.unit[var_1_3.unitID]
		local var_1_5 = dataEasy.getUnitId(var_1_2, var_1_1.skin_id)

		bind.extend(arg_1_1, arg_1_2, {
			class = "card_icon",
			props = {
				unitId = var_1_5,
				rarity = var_1_4.rarity,
				star = var_1_1.star,
				advance = var_1_1.advance,
				levelProps = {
					data = var_1_1.level
				},
				onNode = function(arg_3_0)
					arg_3_0:scale(0.6)

					local var_3_0 = arg_3_0:box()

					arg_3_0:alignCenter(var_3_0)
					arg_1_2:size(var_3_0)

					if arg_1_4.new then
						arg_3_0:hide()
						performWithDelay(arg_1_2, function()
							arg_3_0:show()
						end, 0.26666666666666666)
						widget.addAnimationByKey(arg_1_2, "battlearena/ban1.skel", "effect", "tx_ban_effect", 10):alignCenter(arg_1_2:size()):scale(2)
					else
						arg_3_0:show()
						arg_1_2:get("flag"):show()
					end
				end
			}
		})
	end
end

local function var_0_4(arg_5_0)
	arg_5_0:refreshView()

	local var_5_0 = 0

	for iter_5_0, iter_5_1 in pairs(arg_5_0.data) do
		if iter_5_1:read().dbid ~= -1 then
			var_5_0 = var_5_0 + 1
		end
	end

	local var_5_1 = cc.clampf(var_5_0 - 1, 0, itertools.size(arg_5_0.data) - 1)

	arg_5_0:jumpToItem(var_5_1, cc.p(0.5, 0.5), cc.p(0.5, 0.5))
end

local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("OnlineFightBanEmbattleView", var_0_5)

var_0_6.RESOURCE_FILENAME = "online_fight_ban_embattle.json"
var_0_6.RESOURCE_BINDING = {
	["bottomPanel.subList"] = "bottomSubList",
	stepOK = "stepOK",
	leftRolePanel = "leftRolePanel",
	["titlePanel.item"] = "titleItem",
	battlePanel1 = "battlePanel1",
	["rightDown.btnFilter"] = "btnFilter",
	bottomPanel = "bottomPanel",
	banPanel = "banPanel",
	["bottomPanel.textNotRole"] = "bottomEmptyTxt",
	["bottomPanel.item"] = "bottomItem",
	recordMask = "recordMask",
	titlePanel = "titlePanel",
	rightDown = "rightDown",
	battlePanel2 = "battlePanel2",
	stepChange = "stepChange",
	rightRolePanel = "rightRolePanel",
	spritePanel = "spriteItem",
	btnClose = {
		varname = "btnClose",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBackClick")
			}
		}
	},
	["titlePanel.leftList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftBanData"),
				item = bindHelper.self("titleItem"),
				onItem = functools.partial(var_0_3, 1),
				onAfterBuild = var_0_4
			}
		}
	},
	["titlePanel.rightList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightBanData"),
				item = bindHelper.self("titleItem"),
				onItem = functools.partial(var_0_3, 2),
				onAfterBuild = var_0_4
			}
		}
	},
	["rightDown.btnOK"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnOKClick")
			}
		}
	},
	["battlePanel1.btnGHimg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick1")
			}
		}
	},
	["battlePanel2.btnGHimg"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick2")
			}
		}
	},
	["bottomPanel.list"] = {
		varname = "cardList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 24,
				columnSize = 2,
				data = bindHelper.self("allCardDatas"),
				item = bindHelper.self("bottomSubList"),
				cell = bindHelper.self("bottomItem"),
				emptyTxt = bindHelper.self("bottomEmptyTxt"),
				dataFilterGen = bindHelper.self("onFilterCards", true),
				dataOrderCmp = function(arg_6_0, arg_6_1)
					if arg_6_0.isBan ~= arg_6_1.isBan then
						return arg_6_0.isBan == true
					end

					if arg_6_0.isPick ~= arg_6_1.isPick then
						return arg_6_0.isPick == true
					end

					if arg_6_0.battle ~= arg_6_1.battle then
						return arg_6_0.battle > arg_6_1.battle
					end

					if arg_6_0.rarity ~= arg_6_1.rarity then
						return arg_6_0.rarity > arg_6_1.rarity
					end

					return arg_6_0.card_id < arg_6_1.card_id
				end,
				onCell = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = arg_7_1:get("textNote"):hide()
					local var_7_1 = 0

					if arg_7_3.isBan then
						var_7_1 = 1

						var_7_0:show():text(gLanguageCsv.onlineFightBanIsBan)
						text.addEffect(var_7_0, {
							color = cc.c4b(255, 81, 103, 255),
							outline = {
								color = cc.c4b(119, 2, 35, 255)
							}
						})
					elseif arg_7_3.isPick then
						var_7_1 = 1

						var_7_0:show():text(gLanguageCsv.onlineFightBanIsPick)
						text.addEffect(var_7_0, {
							color = cc.c4b(254, 235, 156, 255),
							outline = {
								color = cc.c4b(236, 75, 0, 255)
							}
						})
					elseif arg_7_3.battle > 0 then
						var_7_1 = 1

						var_7_0:show():text(gLanguageCsv.onlineFightBanIsBattle)
						text.addEffect(var_7_0, {
							color = cc.c4b(155, 242, 62, 255),
							outline = {
								color = cc.c4b(5, 115, 39, 255)
							}
						})
					end

					bind.extend(arg_7_0, arg_7_1, {
						class = "card_icon",
						props = {
							unitId = arg_7_3.unitId,
							advance = arg_7_3.advance,
							rarity = arg_7_3.rarity,
							star = arg_7_3.star,
							grayState = var_7_1,
							levelProps = {
								data = arg_7_3.level
							},
							onNode = function(arg_8_0)
								arg_8_0:xy(-4, -4)
							end
						}
					})
					arg_7_1:onTouch(functools.partial(arg_7_0.clickCell, arg_7_3))
				end,
				onBeforeBuild = function(arg_9_0)
					arg_9_0.emptyTxt:hide()
				end,
				onAfterBuild = function(arg_10_0)
					if #itertools.values(arg_10_0.data) == 0 then
						arg_10_0.emptyTxt:show()
					else
						arg_10_0.emptyTxt:hide()
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onCardItemTouch", true)
			}
		}
	}
}

function var_0_6.onCreate(arg_11_0, arg_11_1)
	local var_11_0 = true

	arg_11_0.startFighting = arg_11_1.startFighting
	arg_11_0.isRecord = arg_11_1.recordData ~= nil
	arg_11_0.recordData = arg_11_1.recordData

	arg_11_0.btnClose:hide()
	arg_11_0.stepOK:hide()
	arg_11_0.titlePanel:get("countdown"):hide()
	arg_11_0.recordMask:visible(arg_11_0.isRecord)
	gGameUI.topuiManager:createView("title", arg_11_0, {
		onClose = arg_11_0:createHandler("onBackClick")
	}):init()

	if arg_11_0.isRecord then
		arg_11_0:disableUpdate()
	end

	arg_11_0.clientStep = 0

	arg_11_0:initModel()

	arg_11_0.banCount = arg_11_0:getBanCount()
	arg_11_0.leftBanData = idlers.newWithMap({})
	arg_11_0.rightBanData = idlers.newWithMap({})
	arg_11_0.allCardDatas = idlers.newWithMap({})
	arg_11_0.state = idler.new(var_0_2.empty)
	arg_11_0.step = idler.new(arg_11_0.clientStep)
	arg_11_0.clientBanCards = idlertable.new({})
	arg_11_0.clientBattleCards = idlertable.new({})
	arg_11_0.remoteDone = idlertable.new({})
	arg_11_0.remoteOffline = idlertable.new({})
	arg_11_0.countdown = idler.new(0)
	arg_11_0.btnOKStep = 0
	arg_11_0.titleDesc = idler.new("")

	arg_11_0:initRolePanel(1)
	arg_11_0:initRolePanel(2)
	arg_11_0:initBattlePanel()
	arg_11_0:initFilterBtn()
	widget.addAnimationByKey(arg_11_0.stepChange, "battlearena/ban1.skel", "effect", "quantou_effect", 1):alignCenter(arg_11_0.stepChange:size()):scale(2):hide()

	arg_11_0.goBattle = false
	arg_11_0.waitForBattle = idler.new(false)

	idlereasy.when(arg_11_0.waitForBattle, function()
		if arg_11_0.isRecord or arg_11_0.goBattle then
			performWithDelay(arg_11_0, function()
				local var_13_0 = arg_11_0.startFighting

				arg_11_0:onClose()
				var_13_0()
			end, 3)

			return
		end

		performWithDelay(arg_11_0, function()
			local function var_14_0()
				if not gGameUI:goBackInStackUI("city.adventure.pvp") then
					gGameUI:goBackInStackUI("city.view")
				end

				if gGameModel.role:read("in_cross_online_fight_battle") then
					dataEasy.onlineFightLoginServer()
				end
			end

			gGameUI:showDialog({
				clearFast = true,
				btnType = 1,
				content = gLanguageCsv.onlineFightWaitForBattle,
				cb = var_14_0,
				closeCb = var_14_0,
				dialogParams = {
					clickClose = false
				}
			})
		end, 20)
	end, true)
	idlereasy.when(arg_11_0.step, function(arg_16_0, arg_16_1)
		arg_11_0:initModel()

		arg_11_0.btnOKStep = arg_16_1

		arg_11_0:deleteMovingItem()
		arg_11_0.titlePanel:get("countdown"):hide()

		local var_16_0 = arg_11_0.banpick_input_steps
		local var_16_1 = 0.3

		if var_16_0[arg_16_1] and var_16_0[arg_16_1][1] then
			local var_16_2 = var_16_0[arg_16_1][1].action

			if var_16_2 == 1 then
				arg_11_0.state:set(var_0_2.ban, true)
				arg_11_0.stepOK:show()

				var_16_1 = 3
			elseif var_16_2 == 2 then
				arg_11_0.state:set(var_0_2.pick, true)
				arg_11_0.stepOK:show()

				var_16_1 = 3
			elseif var_16_2 == 3 then
				arg_11_0.clientStep = arg_16_1

				arg_11_0.state:set(var_0_2.deploy, true)
				arg_11_0.stepOK:show()
				arg_11_0.stepOK:get("img"):hide()

				local var_16_3 = arg_11_0.stepOK:getChildByName("effect")

				if var_16_3 then
					var_16_3:hide()
				end

				var_16_1 = 3

				if itertools.isempty(var_16_0[arg_16_1][1].cards) then
					arg_11_0:onSendData(arg_16_1 + 1, true)

					if arg_11_0.isRecord then
						performWithDelay(arg_11_0, function()
							arg_11_0.step:set(arg_16_1 + 1)
						end, var_0_0)
					end

					return
				end

				arg_11_0.waitForBattle:set(true)
			else
				arg_11_0.state:set(var_0_2.empty, true)
			end
		elseif arg_16_1 > 0 then
			var_16_1 = 3

			arg_11_0.waitForBattle:set(true)
		end

		local var_16_4 = arg_11_0.stepOK:getChildByName("effect")

		if not var_16_4 then
			arg_11_0.stepOK:get("img"):hide()

			var_16_4 = widget.addAnimationByKey(arg_11_0.stepOK, "battlearena/ban1.skel", "effect", "queren_effect", 1):xy(arg_11_0.stepOK:get("img"):xy()):scale(2)
		end

		var_16_4:show()
		var_16_4:play("queren_effect")

		if var_11_0 then
			var_16_1 = 0.3
		end

		performWithDelay(arg_11_0, function()
			if arg_11_0.waitForBattle:read() then
				return
			else
				local var_18_0 = arg_11_0.banpicks[arg_16_1 + 1]
				local var_18_1
				local var_18_2

				if var_18_0 then
					if var_18_0.ban then
						var_18_2 = {
							"txt_jinxuan.png",
							"txt_jingling.png"
						}
						var_18_1 = var_0_2.ban
					elseif var_18_0.pick then
						var_18_2 = {
							"txt_xuanze.png",
							"txt_jingling.png"
						}
						var_18_1 = var_0_2.pick
					end
				else
					var_18_2 = {
						"txt_tiaozheng.png",
						"txt_zhenrong.png"
					}
					var_18_1 = var_0_2.deploy
				end

				if var_18_1 then
					arg_11_0.clientStep = arg_16_1 + 1

					arg_11_0.stepOK:hide()
					arg_11_0.stepChange:show()
					arg_11_0.stepChange:setBackGroundColorType(0)
					arg_11_0.stepChange:getChildByName("effect"):show():play("quantou_effect")

					local var_18_3 = arg_11_0.stepChange:get("img1"):opacity(0):texture("city/pvp/online_fight/ban/" .. var_18_2[1])
					local var_18_4 = arg_11_0.stepChange:get("img2"):opacity(0):texture("city/pvp/online_fight/ban/" .. var_18_2[2])

					performWithDelay(arg_11_0.stepChange, function()
						transition.executeSequence(var_18_3, true):fadeIn(0.2):delay(0.4):fadeOut(0.2):done()
						transition.executeSequence(var_18_4, true):fadeIn(0.2):delay(0.4):fadeOut(0.2):done()
					end, 0.5)
					performWithDelay(arg_11_0.stepChange, function()
						arg_11_0.stepChange:hide()
						arg_11_0.clientBanCards:set({})
						arg_11_0.state:set(var_18_1, true)

						if arg_11_0.isRecord then
							performWithDelay(arg_11_0, function()
								arg_11_0.step:set(arg_16_1 + 1)
							end, var_0_0)
						end
					end, 1)
				end
			end
		end, var_16_1)
	end)
	idlereasy.when(arg_11_0.clientBanCards, function()
		arg_11_0.selectIndex:set(0)
		arg_11_0.draggingIndex:set(0)
		arg_11_0:refreshDownData()

		for iter_22_0 = 1, var_0_1 do
			arg_11_0:refreshBattleSprite(iter_22_0)
		end

		dataEasy.tryCallFunc(arg_11_0.cardList, "filterSortItems", true)
		arg_11_0:onSendData(arg_11_0.clientStep, false, true)
	end, true)
	idlereasy.when(arg_11_0.clientBattleCards, function()
		arg_11_0.selectIndex:set(0)
		arg_11_0.draggingIndex:set(0)
		arg_11_0:refreshTeamBuff(1)
		arg_11_0:refreshTeamBuff(2)
		arg_11_0:refreshDownData()

		for iter_23_0 = 1, 12 do
			arg_11_0:refreshBattleSprite(iter_23_0)
		end

		dataEasy.tryCallFunc(arg_11_0.cardList, "filterSortItems", true)
		arg_11_0:onSendData(arg_11_0.clientStep, false, true)
	end, true)
	idlereasy.when(arg_11_0.state, functools.partial(arg_11_0.refreshPanel, arg_11_0))

	local var_11_1 = arg_11_0.titlePanel:get("countdown")

	idlereasy.when(arg_11_0.countdown, function(arg_24_0, arg_24_1)
		var_11_1:text(arg_24_1)
	end)
	idlereasy.when(arg_11_0.remoteDone, function(arg_25_0, arg_25_1)
		if arg_25_1 and arg_25_1[arg_11_0.swapFlag and 1 or 2] == true then
			arg_11_0.titleDesc:set(gLanguageCsv.onlineFightBanEnemySure)
		end
	end)
	idlereasy.when(arg_11_0.remoteOffline, function(arg_26_0, arg_26_1)
		arg_11_0:initRolePanel(2)
	end)

	local var_11_2 = arg_11_0.titlePanel:get("desc"):text("")
	local var_11_3 = arg_11_0.titlePanel:get("descBg")

	text.addEffect(var_11_2, {
		outline = {
			color = cc.c4b(239, 69, 96, 255)
		}
	})
	idlereasy.when(arg_11_0.titleDesc, function(arg_27_0, arg_27_1)
		var_11_2:stopAllActions()

		if arg_27_1 == "" then
			var_11_2:hide()
			var_11_3:hide()
		else
			transition.executeSequence(var_11_2, true):easeBegin("IN"):scaleXTo(0.2, 1.5):easeEnd():func(function()
				var_11_2:show():text(arg_27_1)
				var_11_3:show()
			end):easeBegin("IN"):scaleXTo(0.2, 1):easeEnd():done()
		end
	end)
	arg_11_0:onListenResult()

	var_11_0 = false
end

function var_0_6.onBackClick(arg_29_0)
	if arg_29_0.isRecord then
		arg_29_0:onClose()

		return
	end

	local var_29_0 = userDefault.getForeverLocalKey("onlineFightFleeTime", {})

	if #var_29_0 >= 3 and time.getTime() - var_29_0[1] < 3600 then
		gGameUI:showTip(gLanguageCsv.onlineFightNoFlee)
	else
		gGameUI:showDialog({
			isRich = true,
			clearFast = true,
			btnType = 2,
			content = gLanguageCsv.onlineFightBanGiveUp,
			cb = function()
				arg_29_0:disableUpdate()
				gGameModel.battle:flee()
			end
		})
	end
end

function var_0_6.onListenResult(arg_31_0)
	if arg_31_0.isRecord then
		return
	end

	local var_31_0 = false

	idlereasy.when(arg_31_0.battleError, function(arg_32_0, arg_32_1)
		if arg_32_1 and arg_32_1 ~= "" then
			arg_31_0:onClose()
			gGameUI:showTip(gLanguageCsv.onlineFightBanError)
		end
	end)
	idlereasy.when(arg_31_0.battleState, function(arg_33_0, arg_33_1)
		if not var_31_0 then
			performWithDelay(arg_31_0, function()
				if arg_33_1 == game.SYNC_SCENE_STATE.waitloading or arg_33_1 == game.SYNC_SCENE_STATE.attack then
					var_31_0 = true

					arg_31_0:disableUpdate()

					arg_31_0.goBattle = true

					arg_31_0.waitForBattle:notify()
				elseif arg_33_1 == game.SYNC_SCENE_STATE.battleover then
					var_31_0 = true

					arg_31_0:disableUpdate()
					gGameApp.net:doRealtimeEnd()
					gGameApp:requestServer("/game/cross/online/battle/end", function(arg_35_0)
						if arg_35_0.view.pattern == 1 then
							arg_35_0.view.score = arg_35_0.view.unlimited_score
							arg_35_0.view.topRank = arg_35_0.view.unlimited_top_score
						elseif arg_35_0.view.pattern == 2 then
							arg_35_0.view.score = arg_35_0.view.limited_score
							arg_35_0.view.topRank = arg_35_0.view.limited_top_score
						end

						arg_35_0.view.rank_move = arg_35_0.view.delta
						arg_35_0.view.rank = arg_35_0.view.score
						arg_35_0.view.top_move = arg_35_0.view.top_move and 1 or 0

						local var_35_0 = {
							from = "ban_embattle",
							awardRemainTime = 3,
							recordType = "jf",
							result = arg_35_0.view.result,
							showReward = arg_35_0.view.award ~= nil,
							serverData = arg_35_0
						}

						arg_31_0:showResultView(var_35_0)
					end)
				end
			end, 0.016666666666666666)
		end
	end)
end

function var_0_6.showResultView(arg_36_0, arg_36_1)
	if arg_36_1.showReward then
		gGameUI:stackUI("battle.battle_end.reward", nil, nil, arg_36_0:createHandler("showResultView", arg_36_1), arg_36_1)

		return
	end

	gGameUI:stackUI("battle.battle_end.jf", nil, nil, nil, nil, arg_36_1, arg_36_0:createHandler("onClose"))
end

function var_0_6.onUpdate(arg_37_0, arg_37_1)
	local var_37_0 = gGameModel.cross_online_fight_banpick.remote
	local var_37_1 = math.ceil(math.max(var_37_0.countdown - (time.getTime() - var_37_0.countdown_timestamp), 0))

	arg_37_0.countdown:set(var_37_1)
	arg_37_0.remoteDone:set(var_37_0.done)
	arg_37_0.remoteOffline:set(var_37_0.offline)
	arg_37_0.step:set(var_37_0.step)
end

function var_0_6.isStepSure(arg_38_0)
	return arg_38_0.btnOKStep >= arg_38_0.clientStep
end

function var_0_6.getCardsAndNatureChoose(arg_39_0)
	local var_39_0 = arg_39_0.clientBattleCards:read()
	local var_39_1 = {}
	local var_39_2 = {}
	local var_39_3 = arg_39_0.teamBuffs1 and arg_39_0.teamBuffs1.flags or {
		1,
		1,
		1,
		1,
		1,
		1
	}

	for iter_39_0 = 1, 6 do
		if var_39_0[iter_39_0] then
			table.insert(var_39_1, var_39_0[iter_39_0])

			var_39_2[var_39_0[iter_39_0]] = var_39_3[iter_39_0]
		end
	end

	return var_39_1, var_39_2
end

function var_0_6.onSendData(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if arg_40_0.isRecord then
		return
	end

	local var_40_0 = arg_40_0.banpicks[arg_40_1]

	if arg_40_1 <= arg_40_0.step:read() then
		return
	end

	if arg_40_3 and arg_40_0:isStepSure() then
		return
	end

	if not var_40_0 then
		local var_40_1, var_40_2 = arg_40_0:getCardsAndNatureChoose()

		if itertools.size(var_40_1) > 0 then
			gGameModel.cross_online_fight_banpick:deploy(arg_40_1, var_40_1, arg_40_2, var_40_2)
		end
	elseif var_40_0.ban then
		local var_40_3 = arg_40_0.clientBanCards:read()
		local var_40_4 = {}

		for iter_40_0 = 1, var_0_1 do
			local var_40_5 = var_40_3[iter_40_0]

			table.insert(var_40_4, var_40_5)
		end

		gGameModel.cross_online_fight_banpick:ban(arg_40_1, var_40_4, arg_40_2)
	elseif var_40_0.pick then
		local var_40_6 = arg_40_0.clientBattleCards:read()
		local var_40_7 = {}

		for iter_40_1 = 1, 6 do
			local var_40_8 = var_40_6[iter_40_1]

			if not arg_40_0.hashPickCards[var_40_8] then
				table.insert(var_40_7, var_40_8)
			end
		end

		gGameModel.cross_online_fight_banpick:pick(arg_40_1, var_40_7, arg_40_2)
	end
end

function var_0_6.onBtnOKClick(arg_41_0)
	if arg_41_0.isRecord then
		return
	end

	if arg_41_0:isStepSure() then
		gGameUI:showTip(gLanguageCsv.onlineFightBanBtnAlreadySure)
	elseif arg_41_0.btnNum == arg_41_0.btnTargetNum then
		if arg_41_0.state:read() ~= var_0_2.ban then
			gGameUI:showTip(gLanguageCsv.onlineFightBanBtnSure)
		end

		arg_41_0.btnOKStep = arg_41_0.clientStep

		local var_41_0 = arg_41_0.banpicks[arg_41_0.clientStep]

		if not var_41_0 then
			arg_41_0.clientBattleCards:notify()
			arg_41_0:onSendData(arg_41_0.clientStep, true)
		elseif var_41_0.ban then
			arg_41_0.clientBanCards:notify()
			arg_41_0:onSendData(arg_41_0.clientStep, true)
		elseif var_41_0.pick then
			arg_41_0.clientBattleCards:notify()
			arg_41_0:onSendData(arg_41_0.clientStep, true)
		end
	else
		gGameUI:showTip(string.format(gLanguageCsv.onlineFightBanNeed, arg_41_0.btnTargetNum))
	end
end

function var_0_6.initModel(arg_42_0)
	if not arg_42_0.isRecord then
		arg_42_0.swapFlag = gGameModel.cross_online_fight_banpick.role2.role_db_id == gGameModel.role:read("id")
		arg_42_0.clientStep = gGameModel.cross_online_fight_banpick.remote.step
		arg_42_0.banpicks = gGameModel.cross_online_fight_banpick.banpicks
		arg_42_0.banpick_cards = gGameModel.cross_online_fight_banpick.cards
		arg_42_0.banpick_card_deck1 = gGameModel.cross_online_fight_banpick.card_deck1
		arg_42_0.banpick_card_deck2 = gGameModel.cross_online_fight_banpick.card_deck2
		arg_42_0.banpick_input_steps = gGameModel.cross_online_fight_banpick.remote.inputsteps
		arg_42_0.rarityLimit = gGameModel.cross_online_fight_banpick.rarityLimit or {}
		arg_42_0.battleState = idlereasy.assign(gGameModel.battle and gGameModel.battle.state, arg_42_0.battleState)
		arg_42_0.battleError = idlereasy.assign(gGameModel.battle and gGameModel.battle.error, arg_42_0.battleError)
	else
		arg_42_0.swapFlag = arg_42_0.recordData.operateForce == 2
		arg_42_0.banpick_cards = arg_42_0.recordData.limited_card_deck.cards
		arg_42_0.banpick_card_deck1 = arg_42_0.recordData.limited_card_deck.card_deck1
		arg_42_0.banpick_card_deck2 = arg_42_0.recordData.limited_card_deck.card_deck2
		arg_42_0.banpick_input_steps = arg_42_0.recordData.banpick_input_steps
		arg_42_0.banpicks = {}

		for iter_42_0, iter_42_1 in ipairs(arg_42_0.banpick_input_steps) do
			if iter_42_1[1] then
				if iter_42_1[1].action == 1 then
					table.insert(arg_42_0.banpicks, {
						ban = itertools.size(iter_42_1[1].cards)
					})
				elseif iter_42_1[1].action == 2 then
					table.insert(arg_42_0.banpicks, {
						pick = itertools.size(iter_42_1[1].cards)
					})
				end
			end
		end

		arg_42_0.rarityLimit = {}
	end
end

function var_0_6.initRolePanel(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_1 == 1 and arg_43_0.leftRolePanel or arg_43_0.rightRolePanel
	local var_43_1 = arg_43_0.swapFlag and 3 - arg_43_1 or arg_43_1
	local var_43_2

	if not arg_43_0.isRecord then
		var_43_2 = var_43_1 == 1 and gGameModel.cross_online_fight_banpick.role1 or gGameModel.cross_online_fight_banpick.role2
	else
		var_43_2 = {
			logo = arg_43_0.recordData.logos[arg_43_1],
			frame = arg_43_0.recordData.role_frames[arg_43_1],
			level = arg_43_0.recordData.levels[arg_43_1],
			name = arg_43_0.recordData.names[arg_43_1],
			game_key = arg_43_0.recordData.game_keys[arg_43_1]
		}
	end

	local var_43_3 = false
	local var_43_4 = arg_43_0.remoteOffline:read()

	if var_43_4 and var_43_4[var_43_1] == true then
		var_43_3 = true
	end

	local var_43_5 = var_43_0:multiget("head", "name", "server")

	var_43_5.head:removeChildByName("offlineText")
	bind.extend(arg_43_0, var_43_5.head, {
		class = "role_logo",
		props = {
			vip = false,
			level = false,
			logoId = var_43_2.logo,
			frameId = var_43_2.frame,
			isGray = var_43_3 == true,
			onNode = function(arg_44_0)
				arg_44_0:scale(0.7)

				if var_43_3 == true then
					label.create(gLanguageCsv.onlineFightOffline, {
						fontSize = 50,
						fontPath = "font/youmi.ttf",
						effect = {
							color = ui.COLORS.NORMAL.WHITE,
							outline = {
								color = ui.COLORS.NORMAL.DEFAULT
							}
						}
					}):xy(arg_44_0:xy()):addTo(var_43_5.head, 10, "offlineText"):scale(0.7)
				end
			end
		}
	})
	var_43_5.name:text(var_43_2.name)
	var_43_5.server:text(string.format(gLanguageCsv.brackets, getServerArea(var_43_2.game_key, true)))
end

function var_0_6.refreshTitleData(arg_45_0)
	local var_45_0 = arg_45_0.titlePanel:getChildByName("effect")

	if not var_45_0 then
		var_45_0 = widget.addAnimationByKey(arg_45_0.titlePanel, "battlearena/ban1.skel", "effect", "top_ban_effect", 1):xy(arg_45_0.titlePanel:width() / 2, arg_45_0.titlePanel:height() - 720 + 4):scale(2)

		var_45_0:setTimeScale(0)
	end

	if arg_45_0.clientStep > arg_45_0.step:read() then
		performWithDelay(arg_45_0, function()
			var_45_0:setTimeScale(1)
			var_45_0:play("top_ban_effect")
		end, 0.1)

		if not arg_45_0.isRecord then
			arg_45_0.titlePanel:get("countdown"):show()
		end
	end

	local var_45_1 = arg_45_0.banpicks[arg_45_0.clientStep]
	local var_45_2
	local var_45_3

	if var_45_1 then
		if var_45_1.ban then
			var_45_2 = gLanguageCsv.onlineFightBanTitleBan
			var_45_3 = gLanguageCsv.onlineFightBanDescBan
		elseif var_45_1.pick then
			var_45_2 = gLanguageCsv.onlineFightBanTitlePick
			var_45_3 = gLanguageCsv.onlineFightBanDescPick
		end
	else
		var_45_2 = gLanguageCsv.onlineFightBanTitleDeploy
		var_45_3 = gLanguageCsv.onlineFightBanDescDeploy
	end

	if arg_45_0.remoteDone:read()[arg_45_0.swapFlag and 2 or 1] then
		var_45_3 = gLanguageCsv.onlineFightBanEnemySure
	end

	if arg_45_0.clientStep <= arg_45_0.step:read() then
		var_45_3 = gLanguageCsv.onlineFightBanEnemySure
	end

	arg_45_0.titleDesc:set(var_45_3)

	local var_45_4 = arg_45_0.titlePanel:multiget("title", "descBg", "desc", "countdown")

	if var_45_2 then
		var_45_4.title:show():text(var_45_2)
	else
		var_45_4.title:hide()
	end
end

function var_0_6.refreshPanel(arg_47_0)
	arg_47_0:refreshTitleData()
	arg_47_0:deleteMovingItem()
	itertools.invoke({
		arg_47_0.battlePanel1,
		arg_47_0.battlePanel2,
		arg_47_0.banPanel,
		arg_47_0.stepChange
	}, "hide")

	local var_47_0 = arg_47_0.state:read()

	if var_47_0 == var_0_2.ban then
		itertools.invoke({
			arg_47_0.banPanel
		}, "show")

		local var_47_1 = arg_47_0.banpicks[arg_47_0.clientStep]
		local var_47_2 = var_47_1 and var_47_1.ban or 0
		local var_47_3 = math.min(375, 1250 / var_47_2)
		local var_47_4 = 1000 - var_47_3 * (var_47_2 - 1)

		for iter_47_0 = 1, var_0_1 do
			arg_47_0.banCards[iter_47_0]:visible(iter_47_0 <= var_47_2):x(var_47_4 + 2 * var_47_3 * (iter_47_0 - 1))
		end
	elseif var_47_0 == var_0_2.pick or var_47_0 == var_0_2.deploy then
		itertools.invoke({
			arg_47_0.battlePanel1,
			arg_47_0.battlePanel2
		}, "show")
	end

	arg_47_0.leftBanData:update(arg_47_0:getBanData(arg_47_0.swapFlag and 1 or 2))
	arg_47_0.rightBanData:update(arg_47_0:getBanData(arg_47_0.swapFlag and 2 or 1))
	arg_47_0.allCardDatas:update(arg_47_0:getAllCardDatas(arg_47_0.swapFlag and 2 or 1))
end

function var_0_6.getOrderData(arg_48_0, arg_48_1)
	local var_48_0 = {}

	for iter_48_0, iter_48_1 in ipairs(arg_48_1) do
		local var_48_1 = arg_48_0.banpick_cards[iter_48_1]
		local var_48_2 = csv.cards[var_48_1.card_id]
		local var_48_3 = csv.unit[var_48_2.unitID]

		table.insert(var_48_0, {
			dbid = iter_48_1,
			cardId = var_48_1.card_id,
			rarity = var_48_3.rarity
		})
	end

	table.sort(var_48_0, function(arg_49_0, arg_49_1)
		if arg_49_0.rarity ~= arg_49_1.rarity then
			return arg_49_0.rarity > arg_49_1.rarity
		end

		return arg_49_0.cardId < arg_49_1.cardId
	end)

	return var_48_0
end

function var_0_6.getCards(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = {}

	for iter_50_0 = 1, arg_50_1 do
		local var_50_1 = arg_50_0.banpick_input_steps[iter_50_0]

		if var_50_1 and var_50_1[arg_50_3] and var_50_1[arg_50_3].action == arg_50_2 then
			arraytools.merge_inplace(var_50_0, {
				var_50_1[arg_50_3].cards
			})
		end
	end

	return var_50_0
end

function var_0_6.getBanCount(arg_51_0)
	local var_51_0 = 0

	for iter_51_0, iter_51_1 in ipairs(arg_51_0.banpicks) do
		var_51_0 = var_51_0 + (iter_51_1.ban or 0)
	end

	return var_51_0
end

function var_0_6.getAllCardDatas(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.clientStep
	local var_52_1 = arg_52_0.state:read()

	if var_52_1 == var_0_2.empty or var_52_1 == var_0_2.ban then
		arg_52_1 = 3 - arg_52_1
	end

	local var_52_2 = arg_52_0:getCards(var_52_0, 1, 3 - arg_52_1)
	local var_52_3 = arraytools.hash(var_52_2)
	local var_52_4 = arg_52_0:getCards(var_52_0, 2, arg_52_1)
	local var_52_5 = arraytools.hash(var_52_4)
	local var_52_6 = {}

	arg_52_0.hashBanCards = var_52_3
	arg_52_0.hashPickCards = var_52_5

	if var_52_1 == var_0_2.ban then
		local var_52_7 = table.deepcopy(arg_52_0.clientBanCards:read(), true)

		if arg_52_0.isRecord or var_52_0 <= arg_52_0.step:read() then
			local var_52_8 = arg_52_0.banpick_input_steps

			if var_52_8 and var_52_8[var_52_0][1].action == 1 then
				var_52_7 = var_52_8[var_52_0][3 - arg_52_1].cards
			end
		end

		arg_52_0.clientBanCards:set(var_52_7, true)

		var_52_6 = arraytools.hash(var_52_7)
	elseif var_52_1 == var_0_2.pick or var_52_1 == var_0_2.deploy then
		local var_52_9 = table.deepcopy(arg_52_0.clientBattleCards:read(), true)

		local function var_52_10()
			local var_53_0 = arg_52_0.banpick_input_steps

			if var_53_0 and var_53_0[var_52_0][1] and var_53_0[var_52_0][2] and var_53_0[var_52_0][1].action == 3 and not itertools.isempty(var_53_0[var_52_0][1].cards) and not itertools.isempty(var_53_0[var_52_0][2].cards) then
				return arraytools.merge({
					var_53_0[var_52_0][arg_52_1].cards,
					var_53_0[var_52_0][3 - arg_52_1].cards
				})
			end
		end

		if var_52_1 == var_0_2.deploy and var_52_0 <= arg_52_0.step:read() then
			var_52_9 = var_52_10()
		else
			local var_52_11 = 0

			for iter_52_0 = 1, 6 do
				if var_52_5[var_52_9[iter_52_0]] then
					var_52_11 = var_52_11 + 1
				end
			end

			for iter_52_1 = 7, 12 do
				if var_52_9[iter_52_1] then
					var_52_11 = var_52_11 + 1
				end
			end

			local var_52_12 = arg_52_0:getCards(var_52_0, 2, 3 - arg_52_1)

			if var_52_11 < #var_52_4 + #var_52_12 then
				local var_52_13 = {}
				local var_52_14 = arg_52_0:getOrderData(var_52_4)
				local var_52_15 = table.deepcopy(var_52_5)

				for iter_52_2 = 1, 6 do
					local var_52_16 = var_52_9[iter_52_2]

					if var_52_15[var_52_16] then
						var_52_13[iter_52_2] = var_52_16
						var_52_15[var_52_16] = nil
					end
				end

				for iter_52_3, iter_52_4 in ipairs(var_52_14) do
					local var_52_17 = iter_52_4.dbid

					if var_52_15[var_52_17] then
						for iter_52_5 = 1, 6 do
							if not var_52_13[iter_52_5] then
								var_52_13[iter_52_5] = var_52_17

								break
							end
						end

						var_52_15[var_52_17] = nil
					end
				end

				local var_52_18 = arg_52_0:getOrderData(var_52_12)

				for iter_52_6, iter_52_7 in ipairs(var_52_18) do
					var_52_13[iter_52_6 + 6] = iter_52_7.dbid
				end

				var_52_9 = var_52_13
			end
		end

		arg_52_0.clientBattleCards:set(var_52_9, true)

		var_52_6 = arraytools.hash(var_52_9)
	else
		return {}
	end

	local var_52_19 = arg_52_0["banpick_card_deck" .. arg_52_1]
	local var_52_20 = {}

	for iter_52_8, iter_52_9 in pairs(var_52_19) do
		local var_52_21 = arg_52_0.banpick_cards[iter_52_9]
		local var_52_22 = var_52_21.card_id
		local var_52_23 = var_52_21.skin_id
		local var_52_24 = csv.cards[var_52_22]
		local var_52_25 = csv.unit[var_52_24.unitID]
		local var_52_26 = dataEasy.getUnitId(var_52_22, var_52_23)

		var_52_20[iter_52_9] = {
			dbid = iter_52_9,
			card_id = var_52_22,
			unitId = var_52_26,
			rarity = var_52_25.rarity,
			attr1 = var_52_25.natureType,
			attr2 = var_52_25.natureType2,
			atkType = var_52_24.atkType,
			level = var_52_21.level,
			star = var_52_21.star,
			advance = var_52_21.advance,
			battle = var_52_6[iter_52_9] and 1 or 0,
			isBan = var_52_3[iter_52_9],
			isPick = var_52_5[iter_52_9],
			markId = var_52_24.cardMarkID
		}
	end

	return var_52_20
end

function var_0_6.getBanData(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.clientStep
	local var_54_1 = arg_54_0:getCards(var_54_0, 1, arg_54_1)
	local var_54_2 = arg_54_0.banpicks[var_54_0]
	local var_54_3 = #var_54_1
	local var_54_4 = var_54_2 and var_54_2.ban or 0
	local var_54_5 = {}

	for iter_54_0 = 1, arg_54_0.banCount do
		local var_54_6 = var_54_1[iter_54_0] or -1

		table.insert(var_54_5, {
			dbid = var_54_6,
			banpickCards = arg_54_0.banpick_cards[var_54_6],
			new = iter_54_0 > var_54_3 - var_54_4 and iter_54_0 <= var_54_3
		})
	end

	return var_54_5
end

function var_0_6.initBattlePanel(arg_55_0)
	arg_55_0.battleCardsRect = {}
	arg_55_0.battleCards = {}

	for iter_55_0 = 1, 6 do
		local var_55_0 = arg_55_0.battlePanel1:get("item" .. iter_55_0)
		local var_55_1 = var_55_0:box()
		local var_55_2 = var_55_0:getParent():convertToWorldSpace(cc.p(var_55_1.x, var_55_1.y))

		var_55_1.x, var_55_1.y = var_55_2.x, var_55_2.y
		arg_55_0.battleCardsRect[iter_55_0] = var_55_1
		arg_55_0.battleCards[iter_55_0] = var_55_0

		var_55_0:onTouch(functools.partial(arg_55_0.onBattleCardTouch, arg_55_0, iter_55_0))

		local var_55_3 = arg_55_0.battleCards[iter_55_0]:get("imgBg")

		if not var_55_3:get("imgSel") then
			local var_55_4 = var_55_3:size()

			widget.addAnimationByKey(var_55_3, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_55_4.width / 2, var_55_4.height / 2 + 15):hide()
		end
	end

	for iter_55_1 = 1, 6 do
		local var_55_5 = arg_55_0.battlePanel2:get("item" .. iter_55_1)

		arg_55_0.battleCards[6 + iter_55_1] = var_55_5
	end

	arg_55_0.banCards = {}

	for iter_55_2 = 1, var_0_1 do
		if iter_55_2 > 3 then
			local var_55_6 = arg_55_0.banPanel:get("item1")

			var_55_6:clone():addTo(arg_55_0.banPanel, var_55_6:z(), "item" .. iter_55_2)
		end

		local var_55_7 = arg_55_0.banPanel:get("item" .. iter_55_2)

		arg_55_0.banCards[iter_55_2] = var_55_7

		var_55_7:onTouch(functools.partial(arg_55_0.onBanCardTouch, arg_55_0, iter_55_2))

		local var_55_8 = arg_55_0.banCards[iter_55_2]:get("imgBg")

		if not var_55_8:get("imgSel") then
			local var_55_9 = var_55_8:size()

			widget.addAnimationByKey(var_55_8, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_55_9.width / 2, var_55_9.height / 2 + 15):hide()
		end
	end

	arg_55_0.selectIndex = idler.new(0)

	idlereasy.when(arg_55_0.selectIndex, function(arg_56_0, arg_56_1)
		local var_56_0 = arg_55_0.state:read()

		if var_56_0 == var_0_2.pick or var_56_0 == var_0_2.deploy then
			for iter_56_0 = 1, 6 do
				arg_55_0.battleCards[iter_56_0]:get("imgBg.imgSel"):visible(arg_56_1 == iter_56_0)
			end
		elseif var_56_0 == var_0_2.ban then
			for iter_56_1 = 1, var_0_1 do
				arg_55_0.banCards[iter_56_1]:get("imgBg.imgSel"):visible(arg_56_1 == iter_56_1)
			end
		end
	end, true)

	arg_55_0.draggingIndex = idler.new(0)

	idlereasy.when(arg_55_0.draggingIndex, function(arg_57_0, arg_57_1)
		local var_57_0 = arg_55_0.state:read()
		local var_57_1 = var_57_0 == var_0_2.ban and var_0_1 or 6
		local var_57_2 = var_57_0 == var_0_2.ban and arg_55_0.banCards or arg_55_0.battleCards

		for iter_57_0 = 1, var_57_1 do
			local var_57_3 = var_57_2[iter_57_0]:get("sprite")

			if var_57_3 then
				var_57_3:setCascadeOpacityEnabled(true)

				if arg_57_1 == 0 then
					var_57_3:opacity(255)
				elseif arg_57_1 == -1 then
					var_57_3:opacity(155)
				elseif arg_57_1 == iter_57_0 then
					var_57_3:opacity(255)
				else
					var_57_3:opacity(155)
				end
			end
		end
	end, true)
end

function var_0_6.refreshTeamBuff(arg_58_0, arg_58_1)
	local var_58_0 = {}
	local var_58_1 = arg_58_1 == 1 and 1 or 7

	for iter_58_0 = var_58_1, var_58_1 + 5 do
		local var_58_2 = arg_58_0.clientBattleCards:read()[iter_58_0]
		local var_58_3 = arg_58_0.banpick_cards[var_58_2]

		if var_58_3 then
			local var_58_4 = csv.cards[var_58_3.card_id]
			local var_58_5 = csv.unit[var_58_4.unitID]

			var_58_0[iter_58_0 - var_58_1 + 1] = {
				var_58_5.natureType,
				var_58_5.natureType2
			}
		end
	end

	local var_58_6 = dataEasy.getTeamBuffBest(var_58_0)

	arg_58_0["battlePanel" .. arg_58_1]:get("btnGHimg"):texture(var_58_6.buf.imgPath)

	arg_58_0["teamBuffs" .. arg_58_1] = var_58_6
end

function var_0_6.refreshDownData(arg_59_0)
	local var_59_0 = arg_59_0.banpicks[arg_59_0.clientStep]

	arg_59_0.rightDown:removeChildByName("textNum")

	local var_59_1
	local var_59_2 = 0
	local var_59_3 = 0
	local var_59_4 = 40

	if not var_59_0 then
		var_59_1 = gLanguageCsv.onlineFightBanBtnDeploy
		var_59_4 = 35
	elseif var_59_0.ban then
		var_59_2 = arg_59_0.clientBanCards:size()
		var_59_3 = var_59_0.ban

		if arg_59_0:isStepSure() then
			var_59_2 = var_59_3
		end

		var_59_1 = string.format(gLanguageCsv.onlineFightBanBtnBan, var_59_3 <= var_59_2 and "#C0x5B545B#" or "#C0xF13B54#", var_59_2, var_59_3)
	elseif var_59_0.pick then
		local var_59_5 = arg_59_0.clientBattleCards:read()
		local var_59_6 = 0

		for iter_59_0 = 1, 6 do
			if var_59_5[iter_59_0] then
				var_59_6 = var_59_6 + 1
			end
		end

		var_59_2 = var_59_6 - itertools.size(arg_59_0.hashPickCards)
		var_59_3 = var_59_0.pick

		if arg_59_0:isStepSure() then
			var_59_2 = var_59_3
		end

		var_59_1 = string.format(gLanguageCsv.onlineFightBanBtnPick, var_59_3 <= var_59_2 and "#C0x5B545B#" or "#C0xF13B54#", var_59_2, var_59_3)
	end

	if var_59_1 then
		rich.createByStr("#C0x5B545B#" .. var_59_1, var_59_4, nil, nil, cc.p(0, 0.5)):addTo(arg_59_0.rightDown, 10, "textNum"):anchorPoint(cc.p(0, 0.5)):xy(20, 165):formatText()
	end

	local var_59_7 = var_59_2 < var_59_3 and 3 or 1

	arg_59_0.rightDown:get("btnOK.textNote"):text(arg_59_0:isStepSure() and gLanguageCsv.commonAlreadyOk or gLanguageCsv.commonTextOk)
	uiEasy.setBtnShader(arg_59_0.rightDown:get("btnOK"), arg_59_0.rightDown:get("btnOK.textNote"), var_59_7)

	arg_59_0.btnNum = var_59_2
	arg_59_0.btnTargetNum = var_59_3
end

function var_0_6.initFilterBtn(arg_60_0)
	arg_60_0.filterCondition = idlertable.new()

	idlereasy.any({
		arg_60_0.filterCondition
	}, function()
		dataEasy.tryCallFunc(arg_60_0.cardList, "filterSortItems", false)
	end)

	local var_60_0 = arg_60_0.btnFilter:parent():convertToWorldSpace(arg_60_0.btnFilter:box())
	local var_60_1 = arg_60_0:convertToNodeSpace(var_60_0)
	local var_60_2 = gGameUI:getConvertPos(arg_60_0.btnFilter, arg_60_0:getResourceNode())

	gGameUI:createView("city.card.bag_filter", arg_60_0.btnFilter):init({
		cb = arg_60_0:createHandler("onBattleFilter"),
		others = {
			height = 122,
			panelOrder = false,
			width = 190,
			x = var_60_2.x,
			y = var_60_2.y
		}
	}):z(19):xy(-var_60_1.x, -var_60_1.y)
end

function var_0_6.onBattleFilter(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	arg_62_0.filterCondition:set({
		attr1 = arg_62_1,
		attr2 = arg_62_2,
		rarity = arg_62_3,
		atkType = arg_62_4
	}, true)
end

function var_0_6.onFilterCards(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0.filterCondition:read()
	local var_63_1 = {}

	if not itertools.isempty(var_63_0) then
		var_63_1 = {
			{
				"rarity",
				var_63_0.rarity < ui.RARITY_LAST_VAL and var_63_0.rarity or nil
			},
			{
				"attr2",
				var_63_0.attr2 < ui.ATTR_MAX and var_63_0.attr2 or nil
			},
			{
				"attr1",
				var_63_0.attr1 < ui.ATTR_MAX and var_63_0.attr1 or nil
			},
			{
				"atkType",
				var_63_0.atkType
			}
		}
	end

	local function var_63_2(arg_64_0, arg_64_1, arg_64_2)
		if arg_64_0[arg_64_1] == nil and (arg_64_1 ~= "attr2" or arg_64_0.attr1 == arg_64_2) then
			return true
		end

		if arg_64_1 == "atkType" then
			for iter_64_0, iter_64_1 in ipairs(arg_64_0.atkType) do
				if arg_64_2[iter_64_1] then
					return true
				end
			end

			return false
		end

		if arg_64_0[arg_64_1] == arg_64_2 then
			return true
		end

		return false
	end

	return function(arg_65_0, arg_65_1)
		for iter_65_0 = 1, #var_63_1 do
			local var_65_0 = var_63_1[iter_65_0]

			if var_65_0[2] and not var_63_2(arg_65_1, var_65_0[1], var_65_0[2]) then
				return false
			end
		end

		return true, arg_65_0
	end
end

function var_0_6.onCardItemTouch(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	if arg_66_3.name == "began" then
		arg_66_0.moved = false
		arg_66_0.touchBeganPos = arg_66_3

		arg_66_0:deleteMovingItem()
	elseif arg_66_3.name == "moved" then
		local var_66_0 = math.abs(arg_66_3.x - arg_66_0.touchBeganPos.x)
		local var_66_1 = math.abs(arg_66_3.y - arg_66_0.touchBeganPos.y)

		if not arg_66_0.moved and not arg_66_0:isMovePanelExist() and (var_66_0 >= ui.TOUCH_MOVED_THRESHOLD or var_66_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			if var_66_1 > var_66_0 * 0.7 then
				local var_66_2 = arg_66_0.allCardDatas:atproxy(arg_66_2.dbid)

				arg_66_0:createMovePanel(var_66_2)
			end

			arg_66_0.moved = true
		end

		arg_66_0.cardList:setTouchEnabled(not arg_66_0:isMovePanelExist())
		arg_66_0:moveMovePanel(arg_66_3)
	elseif arg_66_3.name == "ended" or arg_66_3.name == "cancelled" then
		if arg_66_0:isMovePanelExist() == false and arg_66_0.moved == false then
			arg_66_0:onCardClick(arg_66_2, true)

			return
		end

		arg_66_0:moveEndMovePanel(arg_66_2)
	end
end

function var_0_6.canMoveState(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_0.state:read()

	if var_67_0 == var_0_2.ban then
		if arg_67_0:isStepSure() then
			if arg_67_2 then
				gGameUI:showTip("当前已确定，无法操作")
			end

			return false
		end

		if arg_67_1.isBan then
			if arg_67_2 then
				gGameUI:showTip(gLanguageCsv.onlineFightBanTipBan)
			end

			return false
		end

		if arg_67_1.isPick then
			if arg_67_2 then
				gGameUI:showTip(gLanguageCsv.onlineFightBanTipPick)
			end

			return false
		end
	else
		if arg_67_0:isStepSure() then
			if var_67_0 == var_0_2.deploy then
				if arg_67_2 then
					gGameUI:showTip(gLanguageCsv.onlineFightBanTipDeploy)
				end

				return false
			end

			if arg_67_1.isPick or arg_67_1.battle > 0 then
				return true
			end
		end

		if arg_67_1.isBan then
			if arg_67_2 then
				gGameUI:showTip(gLanguageCsv.onlineFightBanTipBan)
			end

			return false
		end
	end

	return true
end

function var_0_6.createMovePanel(arg_68_0, arg_68_1)
	if arg_68_0.movePanel then
		arg_68_0.movePanel:removeSelf()
	end

	if not arg_68_0:canMoveState(arg_68_1) then
		return
	end

	local var_68_0 = dataEasy.getUnitCsv(arg_68_1.card_id, arg_68_1.skin_id)
	local var_68_1 = arg_68_0.spriteItem:clone():addTo(arg_68_0:getResourceNode(), 1000)

	var_68_1:show()

	local var_68_2 = var_68_1:get("icon"):size()

	widget.addAnimationByKey(var_68_1:get("icon"), var_68_0.unitRes, "hero", "run_loop", 1000):scale(var_68_0.scale):alignCenter(var_68_2):setSkin(var_68_0.skin)
	widget.addAnimationByKey(var_68_1:get("icon"), "effect/buzhen.skel", "effect", "effect_loop", 1002):scale(1):alignCenter(var_68_2)

	arg_68_0.movePanel = var_68_1

	arg_68_0.draggingIndex:set(-1)

	return var_68_1
end

function var_0_6.deleteMovingItem(arg_69_0)
	arg_69_0.selectIndex:set(0)

	if arg_69_0.movePanel then
		arg_69_0.movePanel:removeSelf()

		arg_69_0.movePanel = nil
	end

	arg_69_0.draggingIndex:set(0)
end

function var_0_6.moveMovePanel(arg_70_0, arg_70_1)
	if arg_70_0.movePanel then
		arg_70_0.movePanel:xy(arg_70_1)
		arg_70_0.selectIndex:set(arg_70_0:whichEmbattleTargetPos(arg_70_1))
	end
end

function var_0_6.moveEndMovePanel(arg_71_0, arg_71_1)
	if not arg_71_0.movePanel then
		return
	end

	local var_71_0 = arg_71_0.selectIndex:read()

	arg_71_0:onCardMove(arg_71_1, var_71_0, true)
	arg_71_0:deleteMovingItem()
end

function var_0_6.isMovePanelExist(arg_72_0)
	return arg_72_0.movePanel ~= nil
end

function var_0_6.onCardClick(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0
	local var_73_1 = arg_73_1.dbid
	local var_73_2 = arg_73_0:getIdxByDbId(var_73_1)

	if not arg_73_0:canMoveState(arg_73_1, true) then
		-- block empty
	elseif arg_73_1.isPick or arg_73_0:isStepSure() then
		var_73_0 = gLanguageCsv.onlineFightBanTipPickNoDown
	elseif arg_73_1.battle > 0 then
		arg_73_0:downBattle(var_73_1)
	else
		local var_73_3 = arg_73_0:getIdxByDbId()

		if not arg_73_0:canBattleUp() then
			if arg_73_0.state:read() == var_0_2.deploy then
				var_73_0 = gLanguageCsv.onlineFightBanTipDeployFull
			else
				var_73_0 = string.format(gLanguageCsv.onlineFightBanTipFull, arg_73_0.btnTargetNum)
			end
		elseif arg_73_0:hasSameMarkIDCard(arg_73_1) then
			var_73_0 = gLanguageCsv.alreadyHaveSameSprite
		elseif arg_73_0:isRarityLimit(arg_73_1, nil, true) then
			-- block empty
		else
			arg_73_0:upBattle(var_73_1, var_73_3)
		end
	end

	if arg_73_2 and var_73_0 then
		gGameUI:showTip(var_73_0)
	end
end

function var_0_6.isRarityLimit(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	if arg_74_0.state:read() == var_0_2.pick and (not arg_74_2 or arg_74_2.rarity ~= arg_74_1.rarity) and arg_74_0.rarityLimit[arg_74_1.rarity] then
		local var_74_0 = 1
		local var_74_1 = arg_74_0.clientBattleCards:read()

		for iter_74_0 = 1, 6 do
			local var_74_2 = var_74_1[iter_74_0]
			local var_74_3 = arg_74_0:getCardAttrs(var_74_2)

			if var_74_3 and var_74_3.rarity == arg_74_1.rarity then
				var_74_0 = var_74_0 + 1
			end
		end

		if var_74_0 > arg_74_0.rarityLimit[arg_74_1.rarity] then
			if arg_74_3 then
				local var_74_4 = gGameModel.cross_online_fight:read("theme_id")
				local var_74_5 = csv.cross.online_fight.theme[var_74_4]

				if var_74_5 then
					gGameUI:showTip(var_74_5.desc)
				end
			end

			return true
		end
	end
end

function var_0_6.canBattleUp(arg_75_0)
	return arg_75_0.btnNum < arg_75_0.btnTargetNum
end

function var_0_6.onTeamBuffClick1(arg_76_0)
	local var_76_0 = arg_76_0.teamBuffs1 and arg_76_0.teamBuffs1.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_76_0)
end

function var_0_6.onTeamBuffClick2(arg_77_0)
	local var_77_0 = arg_77_0.teamBuffs2 and arg_77_0.teamBuffs2.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_77_0)
end

function var_0_6.refreshBattleSprite(arg_78_0, arg_78_1, arg_78_2)
	arg_78_2 = arg_78_2 or arg_78_0.state:read()

	if arg_78_2 == var_0_2.ban then
		local var_78_0 = arg_78_0.banCards[arg_78_1]

		var_78_0:removeChildByName("sprite")

		local var_78_1 = arg_78_0.clientBanCards:read()[arg_78_1]
		local var_78_2 = arg_78_0.banpick_cards[var_78_1]

		if not var_78_2 then
			var_78_0:removeChildByName("banEffect")

			return
		end

		local var_78_3 = dataEasy.getUnitCsv(var_78_2.card_id, var_78_2.skin_id)
		local var_78_4 = var_78_0:get("imgBg")

		widget.addAnimationByKey(var_78_0, var_78_3.unitRes, "sprite", "standby_loop", 4):scale(var_78_3.scale * 1.5):xy(var_78_4:x(), var_78_4:y() + 15):setSkin(var_78_3.skin)

		if arg_78_0:isStepSure() then
			if not var_78_0:getChildByName("banEffect") then
				widget.addAnimationByKey(var_78_0, "battlearena/ban1.skel", "banEffect", "ban_effect", 100):xy(var_78_4:x(), var_78_4:y()):scale(2)
			end
		else
			var_78_0:removeChildByName("banEffect")
		end
	else
		local var_78_5 = arg_78_0.battleCards[arg_78_1]
		local var_78_6 = arg_78_0.clientBattleCards:read()[arg_78_1]
		local var_78_7 = arg_78_0.banpick_cards[var_78_6]

		if not var_78_7 then
			if var_78_5:getChildByName("sprite") then
				var_78_5:getChildByName("sprite"):hide()
			end

			var_78_5:get("attrBg"):hide()

			return
		end

		local var_78_8 = var_78_7.card_id
		local var_78_9 = dataEasy.getUnitCsv(var_78_8, var_78_7.skin_id)

		if var_78_5.spriteId == var_78_8 and var_78_5:getChildByName("sprite") then
			var_78_5:getChildByName("sprite"):show()
		else
			var_78_5:removeChildByName("sprite")

			local var_78_10 = var_78_5:get("imgBg")
			local var_78_11 = widget.addAnimationByKey(var_78_5, var_78_9.unitRes, "sprite", "standby_loop", 4):scale(var_78_9.scale * 0.8):xy(var_78_10:x(), var_78_10:y() + 15)

			if arg_78_1 > 6 then
				var_78_11:scale(-var_78_9.scale * 0.8, var_78_9.scale * 0.8)
			end

			var_78_11:setSkin(var_78_9.skin)

			var_78_5.spriteId = var_78_8
		end

		local var_78_12 = arg_78_1 > 6 and 2 or 1
		local var_78_13 = arg_78_0["teamBuffs" .. var_78_12] and arg_78_0["teamBuffs" .. var_78_12].flags or {
			1,
			1,
			1,
			1,
			1,
			1
		}
		local var_78_14 = var_78_13[arg_78_1] or var_78_13[arg_78_1 - 6]

		uiEasy.setTeamBuffItem(var_78_5, var_78_8, var_78_14)
	end
end

function var_0_6.onBattleCardTouch(arg_79_0, arg_79_1, arg_79_2)
	if not arg_79_0.clientBattleCards:read()[arg_79_1] then
		return
	end

	local var_79_0 = arg_79_0:getCardAttrs(arg_79_0.clientBattleCards:read()[arg_79_1])

	if not arg_79_0:canMoveState(var_79_0, true) then
		return
	end

	if arg_79_2.name == "began" then
		arg_79_0:deleteMovingItem()
		arg_79_0:createMovePanel(var_79_0)

		local var_79_1 = arg_79_0.battleCards[arg_79_1]

		var_79_1:get("sprite"):hide()
		var_79_1:get("attrBg"):hide()
		arg_79_0:moveMovePanel(arg_79_2)
	elseif arg_79_2.name == "moved" then
		arg_79_0:moveMovePanel(arg_79_2)
	elseif arg_79_2.name == "ended" or arg_79_2.name == "cancelled" then
		local var_79_2 = arg_79_0.battleCards[arg_79_1]

		var_79_2:get("sprite"):show()
		var_79_2:get("attrBg"):show()
		arg_79_0:deleteMovingItem()

		if arg_79_2.y < 450 then
			arg_79_0:onCardClick(var_79_0, true)
		else
			local var_79_3 = arg_79_0:whichEmbattleTargetPos(arg_79_2)

			if var_79_3 then
				if var_79_3 ~= arg_79_1 then
					arg_79_0:onCardMove(var_79_0, var_79_3, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_79_0:onCardMove(var_79_0, var_79_3, false)
				end
			else
				arg_79_0:onCardMove(var_79_0, arg_79_1, false)
			end
		end
	end
end

function var_0_6.onBanCardTouch(arg_80_0, arg_80_1, arg_80_2)
	if not arg_80_0.clientBanCards:read()[arg_80_1] then
		return
	end

	local var_80_0 = arg_80_0:getCardAttrs(arg_80_0.clientBanCards:read()[arg_80_1])

	if not arg_80_0:canMoveState(var_80_0, true) then
		return
	end

	if arg_80_2.name == "began" then
		arg_80_0:deleteMovingItem()
		arg_80_0:createMovePanel(var_80_0)
		arg_80_0.banCards[arg_80_1]:get("sprite"):hide()
		arg_80_0:moveMovePanel(arg_80_2)
	elseif arg_80_2.name == "moved" then
		arg_80_0:moveMovePanel(arg_80_2)
	elseif arg_80_2.name == "ended" or arg_80_2.name == "cancelled" then
		arg_80_0.banCards[arg_80_1]:get("sprite"):show()
		arg_80_0:deleteMovingItem()

		if arg_80_2.y < 450 then
			arg_80_0:onCardClick(var_80_0, true)
		else
			local var_80_1 = arg_80_0:whichEmbattleTargetPos(arg_80_2)

			if var_80_1 then
				if var_80_1 ~= arg_80_1 then
					arg_80_0:onCardMove(var_80_0, var_80_1, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_80_0:onCardMove(var_80_0, var_80_1, false)
				end
			else
				arg_80_0:onCardMove(var_80_0, arg_80_1, false)
			end
		end
	end
end

function var_0_6.onCardMove(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	local var_81_0 = arg_81_0:getClientCards()
	local var_81_1
	local var_81_2 = arg_81_1.dbid
	local var_81_3 = arg_81_0:getIdxByDbId(var_81_2)
	local var_81_4 = var_81_0:read()[arg_81_2]
	local var_81_5 = arg_81_0:getCardAttrs(var_81_4)

	if arg_81_2 then
		if arg_81_1.battle > 0 then
			if not var_81_5 or arg_81_0:canMoveState(var_81_5, true) then
				if arg_81_0:getCardAttrs(var_81_4) then
					arg_81_0:getCardAttrs(var_81_4).battle = arg_81_0:getBattle(var_81_3)
				end

				if arg_81_0:getCardAttrs(var_81_2) then
					arg_81_0:getCardAttrs(var_81_2).battle = arg_81_0:getBattle(arg_81_2)
				end

				var_81_0:modify(function(arg_82_0)
					arg_82_0[var_81_3], arg_82_0[arg_81_2] = arg_82_0[arg_81_2], arg_82_0[var_81_3]

					return true, arg_82_0
				end, true)
			else
				arg_81_0:refreshBattleSprite(var_81_3)
			end
		else
			local var_81_6 = arg_81_0:hasSameMarkIDCard(arg_81_1)

			if not var_81_5 and not arg_81_0:canBattleUp() then
				if arg_81_0.state:read() == var_0_2.deploy then
					var_81_1 = gLanguageCsv.onlineFightBanTipDeployFull
				else
					var_81_1 = string.format(gLanguageCsv.onlineFightBanTipFull, arg_81_0.btnTargetNum)
				end
			elseif var_81_5 and (var_81_5.isPick or var_81_5.battle > 0 and arg_81_0:isStepSure()) then
				var_81_1 = gLanguageCsv.onlineFightBanTipPickNoDown
			elseif var_81_6 and var_81_6 ~= arg_81_2 then
				var_81_1 = gLanguageCsv.alreadyHaveSameSprite
			elseif arg_81_0:isRarityLimit(arg_81_1, var_81_5, true) then
				-- block empty
			else
				if arg_81_0:getCardAttrs(var_81_4) then
					arg_81_0:getCardAttrs(var_81_4).battle = 0
				end

				if arg_81_0:getCardAttrs(var_81_2) then
					arg_81_0:getCardAttrs(var_81_2).battle = arg_81_0:getBattle(arg_81_2)
				end

				var_81_0:modify(function(arg_83_0)
					arg_83_0[arg_81_2] = var_81_2

					return true, arg_83_0
				end, true)
			end
		end
	end

	if arg_81_3 and var_81_1 then
		gGameUI:showTip(var_81_1)
	end
end

function var_0_6.getCardAttrs(arg_84_0, arg_84_1)
	return arg_84_0.allCardDatas:atproxy(arg_84_1)
end

function var_0_6.getClientCards(arg_85_0)
	return arg_85_0.state:read() == var_0_2.ban and arg_85_0.clientBanCards or arg_85_0.clientBattleCards
end

function var_0_6.getIdxByDbId(arg_86_0, arg_86_1)
	if arg_86_0.state:read() == var_0_2.ban then
		local var_86_0 = arg_86_0.clientBanCards:read()

		for iter_86_0 = 1, arg_86_0.btnTargetNum do
			if var_86_0[iter_86_0] == arg_86_1 then
				return iter_86_0
			end
		end
	else
		local var_86_1 = arg_86_0.clientBattleCards:read()

		for iter_86_1 = 1, 6 do
			if var_86_1[iter_86_1] == arg_86_1 then
				return iter_86_1
			end
		end
	end
end

function var_0_6.downBattle(arg_87_0, arg_87_1)
	local var_87_0 = arg_87_0:getCardAttrs(arg_87_1)

	if var_87_0 then
		if var_87_0.isPick or arg_87_0:isStepSure() then
			gGameUI:showTip(gLanguageCsv.onlineFightBanTipPickNoDown)

			return
		end

		arg_87_0.allCardDatas:atproxy(arg_87_1).battle = 0

		local var_87_1 = arg_87_0:getIdxByDbId(arg_87_1)

		if var_87_1 then
			arg_87_0:getClientCards():modify(function(arg_88_0)
				arg_88_0[var_87_1] = nil

				return true, arg_88_0
			end, true)
		end
	end
end

function var_0_6.upBattle(arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = arg_89_0:getClientCards()

	arg_89_0:getCardAttrs(arg_89_1).battle = arg_89_0:getBattle(arg_89_2)

	var_89_0:modify(function(arg_90_0)
		arg_90_0[arg_89_2] = arg_89_1

		return true, arg_90_0
	end, true)
end

function var_0_6.getBattle(arg_91_0, arg_91_1)
	if arg_91_1 and arg_91_1 ~= 0 then
		return 1
	else
		return 0
	end
end

function var_0_6.whichEmbattleTargetPos(arg_92_0, arg_92_1)
	if arg_92_0.state:read() == var_0_2.ban then
		local var_92_0 = arg_92_0.banpicks[arg_92_0.clientStep]

		if var_92_0 and var_92_0.ban then
			for iter_92_0 = 1, var_92_0.ban do
				local var_92_1 = arg_92_0.banCards[iter_92_0]
				local var_92_2 = var_92_1:box()
				local var_92_3 = var_92_1:getParent():convertToWorldSpace(cc.p(var_92_2.x, var_92_2.y))

				var_92_2.x, var_92_2.y = var_92_3.x, var_92_3.y

				if cc.rectContainsPoint(var_92_2, arg_92_1) then
					return iter_92_0
				end
			end
		end
	else
		for iter_92_1 = 6, 1, -1 do
			local var_92_4 = arg_92_0.battleCardsRect[iter_92_1]

			if cc.rectContainsPoint(var_92_4, arg_92_1) then
				return iter_92_1
			end
		end
	end
end

function var_0_6.hasSameMarkIDCard(arg_93_0, arg_93_1)
	if arg_93_0.state:read() == var_0_2.ban then
		return false
	end

	for iter_93_0 = 1, 6 do
		local var_93_0 = arg_93_0.clientBattleCards:read()[iter_93_0]

		if var_93_0 and arg_93_0:getCardAttrs(var_93_0).markId == arg_93_1.markId then
			return iter_93_0
		end
	end

	return false
end

return var_0_6
