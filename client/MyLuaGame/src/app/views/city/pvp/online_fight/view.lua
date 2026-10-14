local var_0_0 = {
	matching = 2,
	enemy = 3,
	normal = 1
}
local var_0_1 = 10

local function var_0_2(arg_1_0)
	local var_1_0
	local var_1_1
	local var_1_2
	local var_1_3 = {}
	local var_1_4 = 0

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		local var_1_5 = getServerId(iter_1_1, true)

		if not var_1_1 then
			var_1_0 = var_1_5
			var_1_1 = getServerArea(iter_1_1, nil, true)
			var_1_4 = var_1_4 + 1
		else
			if var_1_5 ~= var_1_0 + 1 or var_1_4 >= var_0_1 then
				if not var_1_2 then
					table.insert(var_1_3, string.format(gLanguageCsv.brackets, var_1_1))
				else
					table.insert(var_1_3, string.format(gLanguageCsv.brackets, string.format("%s ~ %s", var_1_1, var_1_2)))
				end

				var_1_2 = nil
				var_1_1 = getServerArea(iter_1_1, nil, true)
				var_1_4 = 0
			else
				var_1_2 = getServerArea(iter_1_1, nil, true)
			end

			var_1_0 = var_1_5
			var_1_4 = var_1_4 + 1
		end
	end

	if var_1_0 then
		if not var_1_2 then
			table.insert(var_1_3, string.format(gLanguageCsv.brackets, var_1_1))
		else
			table.insert(var_1_3, string.format(gLanguageCsv.brackets, string.format("%s ~ %s", var_1_1, var_1_2)))
		end
	end

	return var_1_3
end

local var_0_3 = class("OnlineFightView", cc.load("mvc").ViewBase)

var_0_3.RESOURCE_FILENAME = "online_fight.json"
var_0_3.RESOURCE_BINDING = {
	leftBtn = "leftBtn",
	["firstPanel.subList"] = "serverSubList",
	rightBtn = "rightBtn",
	enemyPanel = "enemyPanel",
	["mainPanel.rightPanel.descPanel.list"] = "modelDescList",
	firstPanel = "firstPanel",
	matchingPanel = "matchingPanel",
	["mainPanel.rightPanel.unlimitedPanel.item"] = "unlimtItem",
	["firstPanel.item"] = "serverItem",
	displayPanel = "displayPanel",
	mainPanel = "mainPanel",
	["firstPanel.tipTime"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["firstPanel.list"] = {
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("servers"),
				item = bindHelper.self("serverSubList"),
				cell = bindHelper.self("serverItem"),
				onCell = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1:get("name"):text(arg_2_3)
				end
			}
		}
	},
	["mainPanel.startBtn"] = {
		binds = {
			event = "click",
			method = bindHelper.self("onStartBtnClick")
		}
	},
	["mainPanel.startBtn.longtimePanel"] = {
		varname = "longtimePanel",
		binds = {
			event = "click",
			method = bindHelper.self("onLongtimeModelClick")
		}
	},
	["mainPanel.startBtn.longtimePanel.tip"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["mainPanel.rankBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	["mainPanel.rankRewardBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankRewardClick")
			}
		}
	},
	["mainPanel.awardPanel.awardBtn"] = {
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onTargetAwardClick")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = "onlineFightAward"
				}
			}
		}
	},
	["mainPanel.awardPanel.awardBtn.barTxt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["mainPanel.awardPanel.time"] = {
		varname = "awardPanelTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["mainPanel.rightPanel.switchBtn"] = {
		binds = {
			event = "touch",
			scaletype = 0,
			methods = {
				ended = bindHelper.self("onSwitchModelClick")
			}
		}
	},
	["mainPanel.rightPanel.descPanel.tip"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onModelTipClick")
			}
		}
	},
	["mainPanel.rightPanel.descPanel.title"] = {
		varname = "modelDescTitle",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			}
		}
	},
	["mainPanel.timePanel.time"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			}
		}
	},
	["mainPanel.rightPanel.unlimitedPanel.tip"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onModelUnlimitedTipClick")
			}
		}
	},
	["mainPanel.rightPanel.unlimitedPanel.title"] = {
		varname = "modelUnlimitTitle",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			}
		}
	},
	["mainPanel.rightPanel.unlimitedPanel.list"] = {
		varname = "unlimitedBanList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("unlimitedBanCards"),
				item = bindHelper.self("unlimtItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = csv.unit[arg_3_3.unitID]

					bind.extend(arg_3_0, arg_3_1, {
						class = "card_icon",
						props = {
							unitId = arg_3_3.unitID,
							rarity = var_3_0.rarity,
							onNode = function(arg_4_0)
								arg_4_0:scale(0.7)
							end
						}
					})
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0:setItemAlignCenter()
				end
			}
		}
	},
	["mainPanel.timePanel.time"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			}
		}
	},
	["mainPanel.startBtn.tip"] = {
		varname = "startTip",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["matchingPanel.time"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftBtn.rule.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftBtn.shop.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftBtn.record.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftBtn.embattle.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftBtn.rank.name"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftBtn.rule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRuleClick")
			}
		}
	},
	["leftBtn.shop"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShopClick")
			}
		}
	},
	["leftBtn.record"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRecordClick")
			}
		}
	},
	["leftBtn.embattle"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onEmbattleClick")
			}
		}
	},
	["leftBtn.rank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRankClick")
			}
		}
	},
	banTipPanel = {
		varname = "banTipPanel",
		binds = {
			event = "click",
			method = bindHelper.self("onBanTipPanelClick")
		}
	},
	banUnlimitedTipPanel = {
		varname = "banUnlimitedTipPanel",
		binds = {
			event = "click",
			method = bindHelper.self("onBanUnlimitedTipPanelClick")
		}
	},
	["displayPanel.tip"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(41, 20, 9, 255)
				}
			}
		}
	},
	["rightBtn.limitedRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onLimitedRankClick")
			}
		}
	},
	["rightBtn.unlimitedRank"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUnlimitedRankClick")
			}
		}
	}
}

function var_0_3.onCreate(arg_6_0)
	arg_6_0.topuiView = gGameUI.topuiManager:createView("default", arg_6_0, {
		onClose = arg_6_0:createHandler("onClose")
	}):init({
		subTitle = "BATTLE ARENA",
		title = "common/txt/txt_bt_duizhanjingjichang.png"
	})

	arg_6_0:initModel()
	arg_6_0:enableSchedule()
	arg_6_0.startTip:text(gLanguageCsv.onlineFightGameTime)

	arg_6_0.switchEffect = widget.addAnimationByKey(arg_6_0.mainPanel, "battlearena/shishipipei.skel", "switchEffect", "kaimen_effect", 0):alignCenter(arg_6_0.mainPanel:size()):scale(2)
	arg_6_0.rightIconEffect = widget.addAnimationByKey(arg_6_0.mainPanel, "battlearena/shishipipei.skel", "rightIconEffect", "fanpai_1_effect", 1):alignCenter(arg_6_0.mainPanel:size()):scale(2)
	arg_6_0.startBtnEffect = widget.addAnimationByKey(arg_6_0.mainPanel, "battlearena/shishipipei.skel", "startBtnEffect", "shanzi_loop", 11):alignCenter(arg_6_0.mainPanel:size()):scale(2)
	arg_6_0.sceneEffect = widget.addAnimationByKey(arg_6_0:getResourceNode(), "battlearena/shishipipei.skel", "sceneEffect", "kspp_wxzs_effect", 100):xy(display.sizeInView.width / 2, display.sizeInView.height / 2):scale(2):z(100):hide()

	arg_6_0.longtimePanel:get("tip"):text(gLanguageCsv.onlineFightLongtimeText)
	adapt.oneLineCenterPos(cc.p(140, 40), {
		arg_6_0.longtimePanel:get("btn"),
		arg_6_0.longtimePanel:get("tip")
	}, cc.p(20, 0))
	arg_6_0.longtimePanel:get("bg"):width(arg_6_0.longtimePanel:get("btn"):width() + arg_6_0.longtimePanel:get("tip"):width() + 50)
	arg_6_0.mainPanel:get("rightPanel.name"):setOpacity(0)
	arg_6_0:setRolePanel()

	arg_6_0.servers = idlers.newWithMap({})

	local var_6_0 = csv.cross.online_fight.base[1]
	local var_6_1 = true

	arg_6_0.hasBanCard = true
	arg_6_0.banCardInBattle = false
	arg_6_0.switchModel = idler.new(userDefault.getForeverLocalKey("onlineFightSwitchModel", "limited"))
	arg_6_0.switchDisplayRank = idler.new(userDefault.getForeverLocalKey("onlineFightSwitchDisplayRank", "limited"))
	arg_6_0.matchState = idler.new(var_0_0.normal)
	arg_6_0.longtimeoutModel = idler.new(userDefault.getForeverLocalKey("onlineFightLongtimeout", false))
	arg_6_0.unlimitedBanCards = idlers.newWithMap({})

	arg_6_0:refreshUnlimitedCards()

	local var_6_2 = false
	local var_6_3 = userDefault.getForeverLocalKey("serverKey", nil, {
		rawKey = true
	})
	local var_6_4 = getServerTag(var_6_3)

	for iter_6_0, iter_6_1 in csvPairs(csv.cross.online_fight.expand_servers) do
		if var_6_4 == iter_6_1.cross then
			for iter_6_2, iter_6_3 in csvMapPairs(iter_6_1.servers) do
				if var_6_3 == iter_6_3 then
					var_6_2 = true

					break
				end
			end
		end

		if var_6_2 then
			break
		end
	end

	idlereasy.when(arg_6_0.longtimeoutModel, function(arg_7_0, arg_7_1)
		arg_6_0.longtimePanel:get("btn"):texture(arg_7_1 and "common/icon/radio_selected.png" or "common/icon/radio_normal.png")
	end)
	idlereasy.when(arg_6_0.matchResult, function(arg_8_0, arg_8_1)
		arg_6_0.matchingPanel:stopAllActions()
		arg_6_0:unSchedule("matching")

		if type(arg_8_1) == "table" then
			if not itertools.isempty(arg_8_1.enemy) then
				arg_6_0:showEnemy()

				return
			end

			if arg_8_1.matching and arg_8_1.matching > 0 then
				local var_8_0 = userDefault.getForeverLocalKey("onlineFightLongtimeout", false)
				local var_8_1 = math.floor(time.getTime() - arg_8_1.matching)
				local var_8_2 = var_8_0 and var_6_0.longMatchTimeout or var_6_0.normalMatchTimeout
				local var_8_3 = cc.clampf(var_8_2 - var_8_1, 0, var_8_2)
				local var_8_4 = time.getTime() + var_8_3 + 10
				local var_8_5 = false
				local var_8_6 = gLanguageCsv.onlineFightInMatching

				if var_6_2 then
					if arg_6_0.switchModel:read() == "limited" then
						if var_6_0.expandLimitedOpen and arg_6_0.limitedScore:read() >= var_6_0.expandLimitedOpenScore then
							var_8_6 = gLanguageCsv.onlineFightExpandServers
						end
					elseif var_6_0.expandUnlimitedOpen and arg_6_0.unlimitedScore:read() >= var_6_0.expandUnlimitedOpenScore then
						var_8_6 = gLanguageCsv.onlineFightExpandServers
					end
				end

				local function var_8_7(arg_9_0)
					arg_9_0 = math.max(arg_9_0, 0)

					arg_6_0.matchingPanel:get("time"):text(string.format("%s %s s", var_8_6, arg_9_0))

					if not var_8_5 then
						var_8_5 = true

						adapt.oneLineCenterPos(cc.p(1540, 530), {
							arg_6_0.matchingPanel:get("icon"),
							arg_6_0.matchingPanel:get("time")
						}, cc.p(20, 0))
					end
				end

				var_8_7(var_8_1)

				local var_8_8

				arg_6_0:schedule(function(arg_10_0)
					local var_10_0 = math.floor(time.getTime() - arg_8_1.matching)

					var_8_7(var_10_0)

					if not var_8_8 and time.getTime() > var_8_4 then
						var_8_8 = true

						gGameApp:requestServer("/game/cross/online/cancel")
					end
				end, 1, 1, "matching")
				arg_6_0.matchState:set(var_0_0.matching)

				return
			end
		end

		arg_6_0.matchState:set(var_0_0.normal)
	end)
	arg_6_0.leftBtn:show()
	idlereasy.any({
		arg_6_0.round,
		arg_6_0.matchState
	}, function(arg_11_0, arg_11_1, arg_11_2)
		itertools.invoke({
			arg_6_0.firstPanel,
			arg_6_0.mainPanel,
			arg_6_0.matchingPanel,
			arg_6_0.displayPanel,
			arg_6_0.enemyPanel,
			arg_6_0.banTipPanel,
			arg_6_0.banUnlimitedTipPanel,
			arg_6_0.rightBtn
		}, "hide")
		arg_6_0.firstPanel:stopAllActions()
		arg_6_0.leftBtn:get("embattle"):show()
		arg_6_0.leftBtn:get("rank"):hide()

		if arg_11_1 == "closed" then
			local var_11_0, var_11_1 = arg_6_0:getCloseState()

			if var_11_0 == "display" then
				arg_6_0.switchDisplayRank:notify()
				arg_6_0.displayPanel:show()
				arg_6_0.rightBtn:show()
				arg_6_0.leftBtn:show()
				arg_6_0.leftBtn:get("embattle"):hide()
				arg_6_0.leftBtn:get("rank"):show()
			else
				itertools.invoke({
					arg_6_0.firstPanel,
					arg_6_0.leftBtn
				}, "show")

				local var_11_2 = arg_6_0.firstPanel:get("tipTime")
				local var_11_3 = arg_6_0.firstPanel:get("emptyPanel")

				var_11_2:hide()
				var_11_3:hide()

				if var_11_0 == "notice" then
					local var_11_4 = var_0_2(getMergeServers(var_11_1.servers))

					arg_6_0.servers:update(var_11_4)

					local var_11_5, var_11_6, var_11_7 = time.getYearMonthDay(var_11_1.date, true)
					local var_11_8 = string.formatex(gLanguageCsv.timeMonthDay, {
						month = var_11_6,
						day = var_11_7
					})
					local var_11_9, var_11_10, var_11_11 = time.getYearMonthDay(var_11_1.endDate, true)
					local var_11_12 = string.formatex(gLanguageCsv.timeMonthDay, {
						month = var_11_10,
						day = var_11_11
					})

					var_11_2:show():text(string.format(gLanguageCsv.onlineFightNoticeTime, var_11_8, var_11_12))
				else
					var_11_3:show()
				end
			end
		else
			local var_11_13 = csv.cross.online_fight.base[1].awardTime
			local var_11_14 = time.getNumTimestamp(gGameModel.cross_online_fight:read("end_date"), time.getHourAndMin(var_11_13, true))

			bind.extend(arg_6_0, arg_6_0.mainPanel:get("timePanel.time"), {
				class = "cutdown_label",
				props = {
					delay = 1,
					endTime = var_11_14,
					strFunc = function(arg_12_0)
						return gLanguageCsv.onlineFightSceneLeft .. " " .. arg_12_0.str
					end
				}
			})
			arg_6_0:setRoundTimer(var_11_14, "closed")
			arg_6_0.mainPanel:show()
			arg_6_0.topuiView:hide()

			local function var_11_15()
				nodetools.invoke(arg_6_0.mainPanel, {
					"rankDesk",
					"rankBtn",
					"rankRewardBtn",
					"timePanel",
					"awardPanel"
				}, "visible", arg_11_2 == var_0_0.normal)
				nodetools.invoke(arg_6_0.mainPanel:get("rightPanel"), {
					"switchBtn"
				}, "visible", arg_11_2 == var_0_0.normal)
				arg_6_0.leftBtn:visible(arg_11_2 == var_0_0.normal)
				arg_6_0.matchingPanel:visible(arg_11_2 == var_0_0.matching)
				arg_6_0.enemyPanel:visible(arg_11_2 == var_0_0.enemy)
				arg_6_0.topuiView:visible(arg_11_2 == var_0_0.normal)
				arg_6_0.mainPanel:get("rightPanel.descPanel"):visible(arg_11_2 == var_0_0.normal and arg_6_0.switchModel:read() == "limited")
				arg_6_0.mainPanel:get("rightPanel.unlimitedPanel"):visible(arg_6_0.hasBanCard and arg_11_2 == var_0_0.normal and arg_6_0.switchModel:read() ~= "limited")
				arg_6_0:resetRankPointSprite()
			end

			if var_6_1 then
				var_11_15()
			else
				performWithDelay(arg_6_0, var_11_15, 1.1666666666666667)
			end

			local var_11_16 = gGameModel.cross_online_fight:read("theme_id")

			if userDefault.getForeverLocalKey("onlineFightLastThemeId") ~= var_11_16 then
				userDefault.setForeverLocalKey("onlineFightLastThemeId", var_11_16)

				if var_11_16 ~= 0 then
					gGameUI:stackUI("city.pvp.online_fight.theme", nil, {
						blackLayer = true,
						full = false,
						clickClose = true
					})
				end

				userDefault.setForeverLocalKey("onlineFightSwitchModel", "limited")
				arg_6_0.switchModel:set("limited")
			end

			arg_6_0:refreshRightPanel()
		end
	end)
	idlereasy.when(arg_6_0.matchState, function(arg_14_0, arg_14_1)
		arg_6_0.rightIconEffect:play(arg_6_0:getRightIconEffectName())

		if not var_6_1 then
			if arg_14_1 == var_0_0.normal or arg_14_1 == var_0_0.matching then
				arg_6_0.startBtnEffect:play("shanzi_effect")

				local var_14_0 = "kspp_wxzs_effect"

				if arg_6_0.switchModel:read() == "limited" then
					var_14_0 = "kspp_gps2_effect"

					if arg_6_0.limitedScore:read() >= var_6_0.limitedBanScore then
						var_14_0 = "kspp_gps1_effect"
					end
				end

				arg_6_0.sceneEffect:show():play(var_14_0)
				gGameUI:disableTouchDispatch(2.3333333333333335)
				transition.executeSequence(arg_6_0.mainPanel:get("startBtn.name"), true):spawnBegin():fadeOut(0.2):scaleTo(0.2, 0.5, 1):spawnEnd():func(function()
					arg_6_0.mainPanel:get("startBtn.name"):texture(arg_14_1 == var_0_0.normal and "city/pvp/online_fight/txt_kspp.png" or "city/pvp/online_fight/txt_qx.png")
				end):delay(2):spawnBegin():fadeIn(0.2):scaleTo(0.2, 1, 1):spawnEnd():done()
			end
		else
			arg_6_0.mainPanel:get("startBtn.name"):texture(arg_14_1 == var_0_0.normal and "city/pvp/online_fight/txt_kspp.png" or "city/pvp/online_fight/txt_qx.png")
		end
	end)
	idlereasy.when(arg_6_0.switchModel, function(arg_16_0, arg_16_1)
		transition.executeSequence(arg_6_0.mainPanel:get("rightPanel.name"), true):fadeOut(0.2):func(function()
			arg_6_0.mainPanel:get("rightPanel.name"):texture(arg_16_1 == "limited" and "city/pvp/online_fight/txt_gps.png" or "city/pvp/online_fight/txt_wxzs.png")
		end):delay(0.6):fadeIn(0.2):done()
		arg_6_0.mainPanel:get("rightPanel.descPanel"):visible(arg_16_1 == "limited")
		arg_6_0.mainPanel:get("rightPanel.unlimitedPanel"):visible(arg_16_1 == "unlimited" and arg_6_0.hasBanCard)

		if arg_16_1 == "limited" then
			arg_6_0.switchEffect:play("kaimen_effect")
		else
			arg_6_0.switchEffect:play("guanmen_effect")
		end

		arg_6_0.rightIconEffect:play(arg_6_0:getRightIconEffectName())
	end)

	local var_6_5 = {
		"common/btn/btn_normal.png",
		"common/btn/btn_recharge.png"
	}
	local var_6_6 = {
		ui.COLORS.NORMAL.WHITE,
		ui.COLORS.NORMAL.RED
	}

	idlereasy.when(arg_6_0.switchDisplayRank, function(arg_18_0, arg_18_1)
		if arg_6_0.round:read() == "closed" then
			userDefault.setForeverLocalKey("onlineFightSwitchDisplayRank", arg_18_1)

			local var_18_0 = arg_18_1 == "limited" and 1 or 2

			arg_6_0.rightBtn:get("limitedRank.icon"):texture(var_6_5[var_18_0])
			text.addEffect(arg_6_0.rightBtn:get("limitedRank.name"), {
				color = var_6_6[var_18_0]
			})
			arg_6_0.rightBtn:get("unlimitedRank.icon"):texture(var_6_5[3 - var_18_0])
			text.addEffect(arg_6_0.rightBtn:get("unlimitedRank.name"), {
				color = var_6_6[3 - var_18_0]
			})
			arg_6_0:resetDisplayTop()
		end
	end)

	local var_6_7 = {}

	for iter_6_4, iter_6_5 in orderCsvPairs(csv.cross.online_fight.weekly_target) do
		if iter_6_5.type == var_6_0.weeklyTarget then
			table.insert(var_6_7, {
				csvId = iter_6_4,
				cfg = iter_6_5
			})
		end
	end

	table.sort(var_6_7, function(arg_19_0, arg_19_1)
		return arg_19_0.cfg.count < arg_19_1.cfg.count
	end)

	local var_6_8 = arg_6_0.mainPanel:get("awardPanel")

	idlereasy.any({
		arg_6_0.onlineFightInfo
	}, function(arg_20_0, arg_20_1)
		local var_20_0 = arg_20_1.weekly_target or {}
		local var_20_1 = arg_20_1.weekly_win_times or 0
		local var_20_2 = arg_20_1.weekly_battle_times or 0
		local var_20_3 = #var_6_7

		for iter_20_0, iter_20_1 in ipairs(var_6_7) do
			if not var_20_0[iter_20_1.csvId] or var_20_0[iter_20_1.csvId] == 1 then
				var_20_3 = iter_20_0

				break
			end
		end

		local var_20_4 = var_6_7[var_20_3]
		local var_20_5 = var_6_0.weeklyTarget == 1 and var_20_1 or var_20_2 or 0

		var_6_8:get("awardBtn.barTxt"):text(var_20_5 .. "/" .. var_20_4.cfg.count)
		var_6_8:get("awardBtn.bar"):setPercent(math.min(var_20_5 / var_20_4.cfg.count * 100, 100))
		var_6_8:removeChildByName("effect")

		if var_20_0[var_20_4.csvId] == 1 then
			widget.addAnimationByKey(var_6_8, "effect/jiedianjiangli.skel", "effect", "effect_loop", 1):scale(0.8):xy(150, 100)
		end

		uiEasy.addVibrateToNode(arg_6_0, var_6_8:get("awardBtn"), var_20_0[var_20_4.csvId] == 1, "weeklyTarget")

		arg_6_0.weeklyTargetState = {
			flag = var_20_0[var_20_4.csvId],
			cfg = var_20_4.cfg,
			csvId = var_20_4.csvId
		}
	end)
	arg_6_0:setWeeklyTargetTimer()

	local var_6_9, var_6_10 = beauty.textScroll({
		isRich = true,
		margin = 20,
		list = arg_6_0.banTipPanel:get("list"),
		strs = {
			{
				str = "#C0x5B545B#" .. string.format(gLanguageCsv.onlineFightBanTip1, var_6_0.limitedBanScore)
			},
			{
				str = "#C0x5B545B#" .. gLanguageCsv.onlineFightBanTip2
			}
		}
	})

	var_6_9:height(var_6_10)
	arg_6_0.banTipPanel:get("bg"):height(var_6_10 + 90)

	local var_6_11, var_6_12 = beauty.textScroll({
		isRich = true,
		margin = 20,
		list = arg_6_0.banUnlimitedTipPanel:get("list"),
		strs = {
			{
				str = "#C0x5B545B#" .. gLanguageCsv.onlineFightBanTip3
			},
			{
				str = "#C0x5B545B#" .. gLanguageCsv.onlineFightBanTip4
			}
		}
	})

	var_6_11:height(var_6_12)
	arg_6_0.banUnlimitedTipPanel:get("bg"):height(var_6_12 + 90)

	var_6_1 = false
end

function var_0_3.initModel(arg_21_0)
	arg_21_0.matchResult = gGameModel.cross_online_fight:getIdler("match_result")
	arg_21_0.round = gGameModel.cross_online_fight:getIdler("round")
	arg_21_0.unlimitedRank = gGameModel.cross_online_fight:getIdler("unlimited_rank")
	arg_21_0.unlimitedScore = gGameModel.cross_online_fight:getIdler("unlimited_score")
	arg_21_0.limitedRank = gGameModel.cross_online_fight:getIdler("limited_rank")
	arg_21_0.limitedScore = gGameModel.cross_online_fight:getIdler("limited_score")
	arg_21_0.onlineFightInfo = gGameModel.role:getIdler("cross_online_fight_info")
	arg_21_0.startDate = gGameModel.cross_online_fight:getIdler("start_date")
end

function var_0_3.getCloseState(arg_22_0)
	local var_22_0 = dataEasy.getCrossServiceData("onlinefight")

	if var_22_0 then
		local var_22_1 = csv.cross.service[var_22_0]
		local var_22_2 = time.getNumTimestamp(var_22_1.date, 5)
		local var_22_3 = time.getTime()

		if var_22_3 >= var_22_2 - 172800 then
			arg_22_0:setRoundTimer(var_22_2 - var_22_3 + 1, "over")

			return "notice", var_22_1
		end
	end

	local var_22_4 = gGameModel.cross_online_fight:read("limited_history_top") or gGameModel.cross_online_fight:read("unlimited_history_top")

	if not itertools.isempty(var_22_4) then
		return "display"
	end
end

function var_0_3.setRoundTimer(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0.round:read() == arg_23_2 then
		return
	end

	if arg_23_1 < 0 then
		arg_23_1 = 10
	end

	performWithDelay(arg_23_0.firstPanel, function()
		gGameApp:requestServer("/game/cross/online/main", functools.handler(arg_23_0, "setRoundTimer", 10, arg_23_2))
	end, arg_23_1)
end

function var_0_3.setRolePanel(arg_25_0)
	local var_25_0 = arg_25_0.mainPanel:get("rolePanel")

	var_25_0:removeAllChildren()

	local var_25_1 = var_25_0:size()
	local var_25_2 = gGameModel.role:read("figure")
	local var_25_3 = gRoleFigureCsv[var_25_2]

	if var_25_3.resSpine ~= "" then
		widget.addAnimationByKey(var_25_0, var_25_3.resSpine, "figure", "standby_loop", 4):xy(var_25_1.width / 2, 30):scale(1.6)
	end

	local var_25_4 = gGameModel.role:read("title_id")

	if var_25_4 > 0 then
		bind.extend(arg_25_0, var_25_0, {
			event = "extend",
			class = "role_title",
			props = {
				data = var_25_4,
				onNode = function(arg_26_0)
					arg_26_0:xy(var_25_1.width / 2, var_25_1.height - 100):scale(1.3):z(5)
				end
			}
		})
	end
end

function var_0_3.setWeeklyTargetTimer(arg_27_0)
	local var_27_0 = time.getTime()
	local var_27_1 = time.getNumTimestamp(time.getWeekStrInClock(0))

	if var_27_1 <= var_27_0 then
		var_27_1 = var_27_1 + 604800
	end

	if var_27_1 < var_27_0 then
		arg_27_0.mainPanel:get("awardPanel.time"):text("")
		performWithDelay(arg_27_0, function()
			arg_27_0:setWeeklyTargetTimer()
		end, 10)

		return
	end

	bind.extend(arg_27_0, arg_27_0.mainPanel:get("awardPanel.time"), {
		class = "cutdown_label",
		props = {
			delay = 1,
			endTime = var_27_1,
			strFunc = function(arg_29_0)
				return arg_29_0.str .. " " .. gLanguageCsv.onlineFightWeeklyTargetReset
			end,
			endFunc = function()
				gGameApp:requestServer("/game/cross/online/main", functools.partial(arg_27_0.setWeeklyTargetTimer, arg_27_0))
			end
		}
	})
end

function var_0_3.refreshRightPanel(arg_31_0)
	local var_31_0 = csv.cross.online_fight.base[1]
	local var_31_1 = gGameModel.cross_online_fight:read("theme_id")
	local var_31_2 = csv.cross.online_fight.theme[var_31_1]

	if not var_31_2 or not var_31_2.desc or var_31_2.desc == "" then
		arg_31_0.modelDescList:hide()
	else
		arg_31_0.modelDescList:show()
		beauty.textScroll({
			list = arg_31_0.modelDescList,
			strs = " " .. gLanguageCsv.onlineFightTheme .. var_31_2.desc,
			effect = {
				color = ui.COLORS.NORMAL.WHITE,
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			}
		})
	end

	idlereasy.any({
		arg_31_0.unlimitedRank,
		arg_31_0.unlimitedScore,
		arg_31_0.limitedRank,
		arg_31_0.limitedScore,
		arg_31_0.switchModel
	}, function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
		local var_32_0 = arg_31_0.mainPanel:get("rankPointPanel")

		if arg_32_5 == "limited" then
			var_32_0:get("txt1"):text(gLanguageCsv.onlineFightMyRank .. (arg_32_3 == 0 and gLanguageCsv.onlineFightNoMatch or arg_32_3))
			var_32_0:get("txt2"):text(gLanguageCsv.onlineFightMyPoint .. arg_32_4)
		else
			var_32_0:get("txt1"):text(gLanguageCsv.onlineFightMyRank .. (arg_32_1 == 0 and gLanguageCsv.onlineFightNoMatch or arg_32_1))
			var_32_0:get("txt2"):text(gLanguageCsv.onlineFightMyPoint .. arg_32_2)
		end

		if arg_32_4 >= var_31_0.limitedBanScore then
			arg_31_0.modelDescTitle:text(gLanguageCsv.onlineFightModelLimited2)
		else
			arg_31_0.modelDescTitle:text(gLanguageCsv.onlineFightModelLimited1)
		end

		arg_31_0.modelUnlimitTitle:text(gLanguageCsv.onlineFightUnlimitedBanCard)
	end):anonyOnly(arg_31_0)
end

function var_0_3.onRuleClick(arg_33_0)
	local var_33_0 = arg_33_0.leftBtn:get("rule")

	if not var_33_0:get("ruleItem") then
		ccui.Layout:create():hide():addTo(var_33_0, 1, "ruleItem")
	end

	gGameUI:stackUI("common.rule", nil, nil, arg_33_0:createHandler("getRuleContext"), {
		width = 1500
	})
end

function var_0_3.getRuleContext(arg_34_0, arg_34_1)
	local var_34_0 = adaptContext
	local var_34_1 = {
		var_34_0.clone(arg_34_1.title, function(arg_35_0)
			arg_35_0:get("text"):text(gLanguageCsv.rules)
		end),
		var_34_0.noteText(144),
		var_34_0.noteText(98001, 98010),
		var_34_0.noteText(145),
		var_34_0.noteText(99001, 99010),
		var_34_0.noteText(146),
		var_34_0.noteText(100001, 100010)
	}

	if arg_34_0.round:read() ~= "closed" then
		local var_34_2 = gGameModel.cross_online_fight:read("servers")

		if var_34_2 then
			local var_34_3 = var_0_2(var_34_2)

			table.insert(var_34_1, 2, "#C0x5B545B#" .. gLanguageCsv.currentServers .. table.concat(var_34_3, ","))
		end

		local var_34_4 = gGameModel.cross_online_fight:read("limited_top_score")
		local var_34_5 = gGameModel.cross_online_fight:read("unlimited_top_score")
		local var_34_6 = arg_34_0.leftBtn:get("rule.ruleItem")
		local var_34_7 = arg_34_1.list:width()

		table.insert(var_34_1, 2, var_34_0.clone(var_34_6, function(arg_36_0)
			local var_36_0, var_36_1 = beauty.textScroll({
				isRich = true,
				align = "center",
				size = cc.size(var_34_7, 0),
				strs = string.format(gLanguageCsv.onlineFightRuleTitle, var_34_4, var_34_5)
			})

			var_36_0:height(var_36_1)
			arg_36_0:size(var_34_7, var_36_1):add(var_36_0)
		end))
	end

	return var_34_1
end

function var_0_3.onShopClick(arg_37_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameUI:stackUI("city.shop", nil, {
			full = true
		}, game.SHOP_INIT.ONLINE_FIGHT_SHOP)
	end
end

function var_0_3.onRecordClick(arg_38_0)
	local var_38_0 = arg_38_0.switchModel:read() == "limited" and 1 or 2

	if arg_38_0.round:read() == "closed" then
		var_38_0 = arg_38_0.switchDisplayRank:read() == "limited" and 1 or 2
	end

	gGameUI:stackUI("city.pvp.online_fight.record", nil, nil, var_38_0)
end

function var_0_3.onEmbattleClick(arg_39_0, arg_39_1)
	if arg_39_0.round:read() == "closed" then
		gGameUI:showTip(gLanguageCsv.notStartFighting)

		return
	end

	if arg_39_0.switchModel:read() == "limited" then
		gGameUI:stackUI("city.pvp.online_fight.limited_embattle")
	else
		gGameUI:stackUI("city.card.embattle.online_fight", nil, {
			full = true
		}, {
			from = "onlineFight",
			tip = arg_39_1 == true
		})
	end
end

function var_0_3.onRankClick(arg_40_0)
	local var_40_0 = arg_40_0.switchModel:read() == "limited" and 2 or 1

	if arg_40_0.round:read() == "closed" then
		var_40_0 = arg_40_0.switchDisplayRank:read() == "limited" and 2 or 1
	end

	gGameApp:requestServer("/game/cross/online/rank", function(arg_41_0)
		gGameUI:stackUI("city.pvp.online_fight.rank", nil, nil, var_40_0, arg_41_0.view.rank)
	end, var_40_0, 0, 10)
end

function var_0_3.onRankRewardClick(arg_42_0)
	gGameUI:stackUI("city.pvp.online_fight.reward", nil, {
		clickClose = true
	})
end

function var_0_3.onTargetAwardClick(arg_43_0)
	if arg_43_0.weeklyTargetState.flag == 0 then
		gGameUI:showTip(gLanguageCsv.onlineFightAwardAll)
	elseif arg_43_0.weeklyTargetState.flag == 1 then
		gGameApp:requestServer("/game/cross/online/weekly/target", function(arg_44_0)
			gGameUI:showGainDisplay(arg_44_0)
		end, arg_43_0.weeklyTargetState.csvId)
	else
		gGameUI:showBoxDetail({
			data = arg_43_0.weeklyTargetState.cfg.award,
			content = string.format(gLanguageCsv.onlineFightWeeklyTargetTip, gLanguageCsv["onlineFightWeeklyTarget" .. arg_43_0.weeklyTargetState.cfg.type], arg_43_0.weeklyTargetState.cfg.count),
			state = arg_43_0.weeklyTargetState.flag
		})
	end
end

function var_0_3.onSwitchModelClick(arg_45_0)
	arg_45_0.switchModel:modify(function(arg_46_0)
		local var_46_0 = arg_46_0 == "limited" and "unlimited" or "limited"

		userDefault.setForeverLocalKey("onlineFightSwitchModel", var_46_0)

		return true, var_46_0
	end)
end

function var_0_3.onModelTipClick(arg_47_0)
	arg_47_0.banTipPanel:show()
end

function var_0_3.onModelUnlimitedTipClick(arg_48_0)
	arg_48_0.banUnlimitedTipPanel:show()
end

function var_0_3.onBanTipPanelClick(arg_49_0)
	arg_49_0.banTipPanel:hide()
end

function var_0_3.onBanUnlimitedTipPanelClick(arg_50_0)
	arg_50_0.banUnlimitedTipPanel:hide()
end

function var_0_3.onLimitedRankClick(arg_51_0)
	arg_51_0.switchDisplayRank:set("limited")
end

function var_0_3.onUnlimitedRankClick(arg_52_0)
	arg_52_0.switchDisplayRank:set("unlimited")
end

function var_0_3.onLongtimeModelClick(arg_53_0)
	if arg_53_0.matchState:read() == var_0_0.normal then
		local var_53_0 = not userDefault.getForeverLocalKey("onlineFightLongtimeout", false)

		userDefault.setForeverLocalKey("onlineFightLongtimeout", var_53_0)
		arg_53_0.longtimeoutModel:set(var_53_0)

		if var_53_0 then
			gGameUI:showTip(gLanguageCsv.onlineFightLongtimeTip)
		end
	end
end

function var_0_3.onStartBtnClick(arg_54_0)
	if arg_54_0.round:read() ~= "start" then
		gGameUI:showTip(gLanguageCsv.onlineFightNotOpen)

		return
	end

	if arg_54_0.switchModel:read() == "limited" then
		local var_54_0 = csv.cross.online_fight.base[1]
		local var_54_1 = gGameModel.role:read("cross_online_fight_limited_cards")

		if itertools.size(var_54_1) < var_54_0.leastCardNum then
			gGameUI:showTip(gLanguageCsv.onlineFightEmbattleNotReady)

			return
		end

		local var_54_2 = {}

		for iter_54_0, iter_54_1 in orderCsvPairs(csv.cross.online_fight.cards) do
			var_54_2[iter_54_1.cardId] = true
		end

		local var_54_3 = gGameModel.role:read("cross_online_fight_limited_cards")

		for iter_54_2, iter_54_3 in ipairs(var_54_3) do
			if not var_54_2[iter_54_3] then
				gGameUI:showTip(gLanguageCsv.onlineFightEmbattleNotReady)

				return
			end
		end
	else
		local var_54_4 = gGameModel.cross_online_fight:read("cards")

		if itertools.size(var_54_4) == 0 then
			gGameUI:showTip(gLanguageCsv.onlineFightEmbattleNotReady)

			return
		end

		arg_54_0:refreshUnlimitedCards()

		if arg_54_0.banCardInBattle then
			arg_54_0:onEmbattleClick(true)

			return
		end
	end

	if arg_54_0.matchState:read() == var_0_0.normal then
		local var_54_5 = arg_54_0.switchModel:read() == "limited" and 2 or 1
		local var_54_6 = userDefault.getForeverLocalKey("onlineFightLongtimeout", false)

		gGameApp:requestServer("/game/cross/online/matching", nil, var_54_5, tonumber(CONFIG_GAME_BUILD), var_54_6)
	elseif arg_54_0.matchState:read() == var_0_0.matching then
		gGameApp:requestServer("/game/cross/online/cancel")
	end
end

function var_0_3.getRightIconEffectName(arg_55_0)
	if arg_55_0.round:read() == "closed" then
		return "wuxianzhisai_loop"
	end

	local var_55_0 = arg_55_0.switchModel:read()
	local var_55_1 = arg_55_0.limitedScore:read()
	local var_55_2 = arg_55_0.matchState:read()
	local var_55_3 = csv.cross.online_fight.base[1]

	if var_55_2 == var_0_0.normal then
		if var_55_1 >= var_55_3.limitedBanScore then
			return var_55_0 == "limited" and "fanpai_1_effect" or "fanpai_2_effect"
		end

		return var_55_0 == "limited" and "fanpai_3_effect" or "fanpai_4_effect"
	end

	if var_55_0 == "limited" then
		if var_55_1 >= var_55_3.limitedBanScore then
			return "gongpingsai1_loop"
		end

		return "gongpingsai2_loop"
	end

	return "wuxianzhisai_loop"
end

function var_0_3.resetDisplayTop(arg_56_0)
	local var_56_0

	if arg_56_0.switchDisplayRank:read() == "limited" then
		var_56_0 = gGameModel.cross_online_fight:read("limited_history_top")
	else
		var_56_0 = gGameModel.cross_online_fight:read("unlimited_history_top")
	end

	var_56_0 = var_56_0 or {}

	local var_56_1 = arg_56_0.displayPanel:get("board")

	var_56_1:removeAllChildren()

	local var_56_2 = {
		cc.p(0, 0),
		cc.p(-640, 0),
		cc.p(640, 0)
	}

	for iter_56_0 = 1, 3 do
		if var_56_0[iter_56_0] then
			local var_56_3 = arg_56_0.displayPanel:get("item1"):clone():addTo(var_56_1):xy(var_56_2[iter_56_0]):z(2)
			local var_56_4 = var_56_3:get("down"):multiget("bg", "rank", "name", "point", "server")

			var_56_4.bg:texture("city/pvp/online_fight/display/img_dzjjc_" .. iter_56_0 .. ".png")
			var_56_4.rank:texture("city/pvp/online_fight/display/icon_dzjjc_" .. iter_56_0 .. ".png")
			var_56_4.name:text(var_56_0[iter_56_0].name)
			var_56_4.point:text(gLanguageCsv.score .. ": " .. var_56_0[iter_56_0].score)
			var_56_4.server:text(string.format(gLanguageCsv.brackets, getServerArea(var_56_0[iter_56_0].game_key)))
			text.addEffect(var_56_4.name, {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			})
			text.addEffect(var_56_4.point, {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			})
			text.addEffect(var_56_4.server, {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			})

			local var_56_5 = var_56_3:size()
			local var_56_6 = gRoleFigureCsv[var_56_0[iter_56_0].figure]

			if var_56_6.resSpine ~= "" then
				widget.addAnimationByKey(var_56_3, var_56_6.resSpine, "figure", "standby_loop", 0):xy(var_56_5.width / 2, 50):scale(iter_56_0 == 1 and 1.4 or 1.3)
			end

			local var_56_7 = var_56_0[iter_56_0].title

			if var_56_7 > 0 then
				bind.extend(arg_56_0, var_56_3, {
					event = "extend",
					class = "role_title",
					props = {
						data = var_56_7,
						onNode = function(arg_57_0)
							arg_57_0:xy(var_56_5.width / 2, var_56_5.height - (iter_56_0 == 1 and 100 or 160)):scale(1.3):z(5)
						end
					}
				})
			end
		end
	end

	for iter_56_1 = 4, 7 do
		if var_56_0[iter_56_1] then
			local var_56_8 = arg_56_0.displayPanel:get("item2"):clone():addTo(var_56_1):xy(640 * (iter_56_1 - 5.5), 400):z(1)
			local var_56_9 = var_56_8:get("down"):multiget("bg", "rank", "name", "point", "server")

			var_56_9.rank:texture("city/pvp/online_fight/display/icon_dzjjc_" .. iter_56_1 .. ".png")
			var_56_9.name:text(var_56_0[iter_56_1].name)
			var_56_9.point:text(gLanguageCsv.score .. ": " .. var_56_0[iter_56_1].score)
			var_56_9.server:text(string.format(gLanguageCsv.brackets, getServerArea(var_56_0[iter_56_1].game_key)))
			text.addEffect(var_56_9.name, {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			})
			text.addEffect(var_56_9.point, {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			})
			text.addEffect(var_56_9.server, {
				outline = {
					color = cc.c4b(83, 54, 6, 255)
				}
			})

			local var_56_10 = var_56_8:size()
			local var_56_11 = gRoleFigureCsv[var_56_0[iter_56_1].figure]

			if var_56_11.resSpine ~= "" then
				widget.addAnimationByKey(var_56_8, var_56_11.resSpine, "figure", "standby_loop", 0):xy(var_56_10.width / 2, 50):scale(1)
			end
		end
	end
end

function var_0_3.refreshUnlimitedCards(arg_58_0)
	if arg_58_0.round:read() == "closed" then
		return
	end

	local var_58_0 = math.floor((time.getTime() - time.getNumTimestamp(arg_58_0.startDate:read(), 5, 0, 0)) / 60 / 60 / 24) + 1
	local var_58_1 = {}
	local var_58_2 = {}

	for iter_58_0, iter_58_1 in csvPairs(csv.cross.online_fight.theme_open) do
		if iter_58_1.day == var_58_0 then
			var_58_1 = iter_58_1

			break
		end
	end

	if itertools.size(var_58_1.invalidMarkIDs or {}) == 0 and itertools.size(var_58_1.invalidMegaCardIDs or {}) == 0 then
		arg_58_0.hasBanCard = false

		arg_58_0.unlimitedBanCards:update(var_58_2)

		return
	end

	for iter_58_2, iter_58_3 in ipairs(var_58_1.invalidMarkIDs) do
		local var_58_3 = 1
		local var_58_4
		local var_58_5

		for iter_58_4, iter_58_5 in orderCsvPairs(csv.cards) do
			if iter_58_5.cardMarkID == iter_58_3 and iter_58_5.megaIndex == 0 then
				var_58_4 = var_58_3 <= iter_58_5.develop and iter_58_5.unitID or var_58_4
				var_58_3 = var_58_3 <= iter_58_5.develop and iter_58_5.develop or var_58_3
			end
		end

		var_58_2[iter_58_2] = {
			unitID = var_58_4
		}
	end

	for iter_58_6, iter_58_7 in ipairs(var_58_1.invalidMegaCardIDs) do
		for iter_58_8, iter_58_9 in orderCsvPairs(csv.cards) do
			if iter_58_8 == iter_58_7 then
				var_58_2[#var_58_2 + 1] = {
					unitID = iter_58_9.unitID
				}
			end
		end
	end

	arg_58_0.unlimitedBanCards:update(var_58_2)

	arg_58_0.banCardInBattle = false

	local var_58_6 = gGameModel.cross_online_fight:read("cards")

	for iter_58_10, iter_58_11 in ipairs(var_58_6) do
		local var_58_7 = gGameModel.cards:find(iter_58_11):read("card_id")

		for iter_58_12, iter_58_13 in ipairs(var_58_1.invalidMarkIDs) do
			if csv.cards[var_58_7].cardMarkID == iter_58_13 then
				arg_58_0.banCardInBattle = true

				return
			end
		end

		for iter_58_14, iter_58_15 in ipairs(var_58_1.invalidMegaCardIDs) do
			if var_58_7 == iter_58_15 then
				arg_58_0.banCardInBattle = true

				return
			end
		end
	end
end

function var_0_3.resetRankPointSprite(arg_59_0, arg_59_1)
	arg_59_0.mainPanel:get("rankPointPanel.sprite"):removeAllChildren()
end

function var_0_3.showEnemy(arg_60_0)
	if arg_60_0.matchState:read() == var_0_0.enemy then
		return
	end

	arg_60_0.matchState:set(var_0_0.enemy)

	local var_60_0 = arg_60_0.enemyPanel:multiget("head", "name", "server", "point", "bg", "icon", "title", "pointTxt")

	itertools.invoke(var_60_0, "hide")
	dataEasy.onlineFightLoginServer(arg_60_0, function()
		gGameModel.cross_online_fight:getRawIdler_("match_result"):set(nil)
	end, function(arg_62_0)
		itertools.invoke(var_60_0, "show")

		local var_62_0 = arg_60_0.matchResult:read().enemy

		bind.extend(arg_60_0, var_60_0.head, {
			class = "role_logo",
			props = {
				vip = false,
				level = false,
				logoId = var_62_0.logo,
				frameId = var_62_0.frame
			}
		})
		var_60_0.name:text(var_62_0.name)
		var_60_0.server:text(string.format(gLanguageCsv.brackets, getServerArea(var_62_0.game_key, true)))
		var_60_0.point:text(var_62_0.score or 0)
		adapt.oneLinePos(var_60_0.pointTxt, var_60_0.point, cc.p(5, 0))
		performWithDelay(arg_60_0, function()
			gGameModel.cross_online_fight:getRawIdler_("match_result"):set(nil)
			arg_62_0()
		end, 3)
	end)
end

return var_0_3
