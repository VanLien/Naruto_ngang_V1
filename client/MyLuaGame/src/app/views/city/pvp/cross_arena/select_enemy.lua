local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("SelectEnemyView", var_0_0)
local var_0_2 = {
	cc.p(810, 550),
	cc.p(1310, 380),
	cc.p(1810, 550),
	(cc.p(2310, 380))
}

var_0_1.RESOURCE_FILENAME = "cross_arena_enemy.json"
var_0_1.RESOURCE_BINDING = {
	["rightDownPanel.imgGold"] = "imgGold",
	centerPanel = "centerPanel",
	enemyPanel = "enemyPanel",
	["centerPanel.selfPanel"] = "selfPanel",
	textNoteTime = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	textTime = {
		varname = "textTime",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["enemyPanel.textNoteRank"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["enemyPanel.textRank"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["enemyPanel.textName"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["enemyPanel.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["enemyPanel.btnChallenge5.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightDownPanel.btnChange.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["rightDownPanel.textNote1"] = {
		varname = "textNoteTimes",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDownPanel.textTimes"] = {
		varname = "textTimes",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDownPanel.textNote2"] = {
		varname = "textNoteChange",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDownPanel.textGold"] = {
		varname = "textGold",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightDownPanel.btnAddTimes"] = {
		varname = "btnAdd",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickAddTimes")
			}
		}
	},
	["rightDownPanel.btnChange"] = {
		varname = "btnChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClickChange")
			}
		}
	},
	noteBg = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("sevenInfo")
			}
		}
	}
}

function var_0_1.onCreate(arg_1_0)
	arg_1_0:initModel()
	arg_1_0:initCountDown()
	idlereasy.any({
		arg_1_0.vipLevel,
		arg_1_0.pwTimes,
		arg_1_0.buyPwTimes,
		arg_1_0.refreshTimes
	}, function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = gVipCsv[arg_2_1].crossArenaFreePWTimes

		arg_1_0.buyPWMaxTimes = gVipCsv[arg_2_1].crossArenaBuyPWMaxTimes

		local var_2_1 = math.max(0, var_2_0 + arg_2_3 - arg_2_2)

		arg_1_0.textTimes:text(var_2_1 .. "/" .. var_2_0)

		if var_2_1 < 1 then
			text.addEffect(arg_1_0.textTimes, {
				color = ui.COLORS.NORMAL.ALERT_ORANGE
			})
		else
			text.addEffect(arg_1_0.textTimes, {
				color = ui.COLORS.NORMAL.GREEN1
			})
		end

		local var_2_2 = gCostCsv.cross_arena_fresh_cost
		local var_2_3 = math.min(arg_2_4 + 1, table.length(var_2_2))

		arg_1_0.refreshCost = var_2_2[var_2_3]

		local var_2_4 = gCostCsv.cross_arena_pw_buy_cost
		local var_2_5 = math.min(arg_2_3 + 1, table.length(var_2_4))

		arg_1_0.challengeCost = var_2_4[var_2_5]
		arg_1_0.challenge5Cost = gCommonConfigCsv.crossArenaPassCostRmb

		if var_2_1 < 5 then
			for iter_2_0 = 1, 5 - var_2_1 do
				local var_2_6 = math.min(arg_2_3 + iter_2_0, table.length(var_2_4))

				arg_1_0.challenge5Cost = arg_1_0.challenge5Cost + var_2_4[var_2_6]
			end
		else
			arg_1_0.challenge5Cost = gCommonConfigCsv.crossArenaPassCostRmb
		end

		arg_1_0:refreshChallenge5Cost()

		local var_2_7 = {}
		local var_2_8 = {}

		if arg_1_0.refreshCost > 0 then
			arg_1_0.textGold:text(mathEasy.getShortNumber(arg_1_0.refreshCost))
			idlereasy.when(gGameModel.role:getIdler("gold"), function(arg_3_0, arg_3_1)
				arg_1_0.textGold:setTextColor(arg_1_0.refreshCost > 0 and arg_3_1 < arg_1_0.refreshCost and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.WHITE)
			end):anonyOnly(arg_1_0, "gold")
			table.insert(var_2_7, arg_1_0.imgGold:show())
			table.insert(var_2_7, arg_1_0.textGold:show())
			table.insert(var_2_7, arg_1_0.textNoteChange:show())

			var_2_8 = {
				cc.p(10, 0),
				cc.p(5, 0),
				cc.p(5, 0)
			}
		else
			arg_1_0.imgGold:hide()
			arg_1_0.textGold:hide()
			arg_1_0.textNoteChange:hide()
		end

		if var_2_1 > 0 then
			arg_1_0.btnAdd:hide()
			table.insert(var_2_7, arg_1_0.textTimes)
			table.insert(var_2_7, arg_1_0.textNoteTimes)
			table.insert(var_2_8, cc.p(40, 0))
			table.insert(var_2_8, cc.p(5, 0))
		else
			table.insert(var_2_7, arg_1_0.btnAdd:show())
			table.insert(var_2_7, arg_1_0.textTimes)
			table.insert(var_2_7, arg_1_0.textNoteTimes)
			table.insert(var_2_8, cc.p(40, 0))
			table.insert(var_2_8, cc.p(5, 0))
			table.insert(var_2_8, cc.p(5, 0))
		end

		adapt.oneLinePos(arg_1_0.btnChange, var_2_7, var_2_8, "right")

		arg_1_0.canChallengeCount = var_2_1
	end)
	idlereasy.any({
		arg_1_0.role
	}, function(arg_4_0, arg_4_1)
		arg_1_0:initSelfPanel(arg_4_1)
	end)
	idlereasy.any({
		arg_1_0.enemys
	}, function(arg_5_0, arg_5_1)
		arg_1_0:initEnemyPanel(arg_5_1)
	end)
	cc.ParticleSystemQuad:create("crossarena/caidai_1.plist"):addTo(arg_1_0:getResourceNode(), 10):xy(arg_1_0:getResourceNode():width() / 2, arg_1_0:getResourceNode():height()):scale(2)
end

function var_0_1.initCountDown(arg_6_0)
	local var_6_0 = time.getNumTimestamp(arg_6_0.date:read()) + 1123200 + 79200

	local function var_6_1()
		local var_7_0 = time.getCutDown(var_6_0 - time.getTime())

		arg_6_0.textTime:text(var_7_0.str)

		if var_7_0.hour < 1 and var_7_0.day < 1 then
			text.addEffect(arg_6_0.textTime, {
				color = ui.COLORS.NORMAL.ALERT_ORANGE
			})
		else
			text.addEffect(arg_6_0.textTime, {
				color = ui.COLORS.NORMAL.GREEN1
			})
		end

		if var_6_0 - time.getTime() <= 0 then
			return false
		end

		return true
	end

	var_6_1()
	arg_6_0:enableSchedule()
	arg_6_0:schedule(function(arg_8_0)
		if not var_6_1() then
			return false
		end
	end, 1, 0)
end

function var_0_1.initSelfPanel(arg_9_0, arg_9_1)
	arg_9_0.selfPanel:get("imgZlBg.textZl"):text(arg_9_1.fighting_point)
	arg_9_0.selfPanel:get("textRank"):text(dataEasy.getCrossArenaStageByRank(arg_9_1.rank).rank)
	arg_9_0.selfPanel:get("textName"):text(string.format(gLanguageCsv.brackets, getServerArea(arg_9_1.game_key, true)) .. arg_9_1.name)
	bind.extend(arg_9_0, arg_9_0.selfPanel:get("stagePanel"), {
		class = "stage_icon",
		props = {
			showStage = true,
			showStageBg = true,
			rank = arg_9_1.rank,
			onNode = function(arg_10_0)
				arg_10_0:scale(0.9):xy(60, 50)
			end
		}
	})

	local var_9_0 = dataEasy.getUnitIdForJJC(arg_9_1.display)
	local var_9_1 = csv.unit[var_9_0]

	widget.addAnimationByKey(arg_9_0.selfPanel, var_9_1.unitRes, "spineNode", "standby_loop", 1):scale(var_9_1.scale):xy(250, 250):setSkin(var_9_1.skin)
	bind.touch(arg_9_0, arg_9_0.selfPanel, {
		methods = {
			ended = function()
				arg_9_0:onShowHeadIcon()
			end
		}
	})
	widget.addAnimationByKey(arg_9_0.selfPanel, "crossarena/kfjjc_dizuo.skel", "kfjjc_bj", "effect_loop_lan", 0):scale(2):xy(250, 250)
end

function var_0_1.initEnemyPanel(arg_12_0, arg_12_1)
	table.sort(arg_12_1, function(arg_13_0, arg_13_1)
		return arg_13_0.rank < arg_13_1.rank
	end)

	for iter_12_0 = 1, 4 do
		arg_12_0.centerPanel:removeChildByName("enemy_" .. iter_12_0)
	end

	for iter_12_1 = 1, 4 do
		local var_12_0 = arg_12_1[iter_12_1]

		if var_12_0 == nil then
			break
		end

		local var_12_1 = arg_12_0.enemyPanel:clone():addTo(arg_12_0.centerPanel):xy(var_0_2[iter_12_1]):name("enemy_" .. iter_12_1)

		var_12_1:get("imgZlBg.textZl"):text(var_12_0.fighting_point)
		var_12_1:get("textRank"):text(dataEasy.getCrossArenaStageByRank(var_12_0.rank).rank)
		var_12_1:get("textName"):text(string.format(gLanguageCsv.brackets, getServerArea(var_12_0.game_key, true)) .. var_12_0.name)
		adapt.oneLineCenterPos(cc.p(250, 711), {
			var_12_1:get("stagePanel"),
			var_12_1:get("textNoteRank"),
			var_12_1:get("textRank")
		}, cc.p(10, 0))
		bind.extend(arg_12_0, var_12_1:get("stagePanel"), {
			class = "stage_icon",
			props = {
				showStage = false,
				showStageBg = false,
				rank = var_12_0.rank,
				onNode = function(arg_14_0)
					arg_14_0:scale(0.9):xy(60, 0)
				end
			}
		})
		adapt.oneLinePos(var_12_1:get("stagePanel"), var_12_1:get("imgRankBg"), cc.p(-20, 0))

		local var_12_2 = dataEasy.getUnitIdForJJC(var_12_0.display)
		local var_12_3 = csv.unit[var_12_2]

		widget.addAnimationByKey(var_12_1, var_12_3.unitRes, "spineNode", "standby_loop", 1):scaleX(var_12_3.scale * -1):scaleY(var_12_3.scale):xy(250, 250):setSkin(var_12_3.skin)

		local var_12_4 = arg_12_0.role:read().rank
		local var_12_5 = var_12_0.rank
		local var_12_6 = var_12_0.role_db_id
		local var_12_7 = var_12_0.record_db_id

		bind.touch(arg_12_0, var_12_1:get("btnChallenge"), {
			methods = {
				ended = function()
					if table.length(arg_12_0.cards:read()) < 2 then
						gGameUI:showTip(gLanguageCsv.crossArenaTwoSpritesTips)
					elseif arg_12_0.canChallengeCount == 0 then
						if arg_12_0.buyPwTimes:read() >= arg_12_0.buyPWMaxTimes then
							gGameUI:showTip(gLanguageCsv.crossArenaBuyTimesMaxTips)

							return
						end

						gGameUI:showDialog({
							btnType = 2,
							clearFast = true,
							isRich = true,
							cb = function()
								if gGameModel.role:read("rmb") < arg_12_0.challengeCost then
									gGameUI:showTip(gLanguageCsv.buyRMBNotEnough)

									return
								end

								gGameApp:requestServer("/game/cross/arena/battle/buy", function(arg_17_0)
									gGameUI:stackUI("city.pvp.cross_arena.embattle", nil, {
										full = true
									}, {
										type = "attack",
										fightCb = arg_12_0:createHandler("startFighting", var_12_0)
									})
								end)
							end,
							title = gLanguageCsv.spaceTips,
							content = string.format(gLanguageCsv.crossArenaBuyTimesTips, arg_12_0.challengeCost),
							dialogParams = {
								clickClose = false
							}
						})
					else
						gGameUI:stackUI("city.pvp.cross_arena.embattle", nil, {
							full = true
						}, {
							type = "attack",
							fightCb = arg_12_0:createHandler("startFighting", var_12_0)
						})
					end
				end
			}
		})

		if var_12_0.rank < arg_12_0.role:read().rank or not dataEasy.isUnlock(gUnlockCsv.crossArenaPass) then
			var_12_1:get("btnChallenge5"):hide()
			var_12_1:get("btnChallenge"):x(235)
		else
			var_12_1:get("btnChallenge"):x(125)
			var_12_1:get("btnChallenge5"):show()
			var_12_1:get("btnChallenge5"):x(345)
			var_12_1:get("btnChallenge5.textCost"):text(arg_12_0.challenge5Cost)
			adapt.oneLineCenterPos(cc.p(100, 87), {
				var_12_1:get("btnChallenge5.imgDiamond"),
				var_12_1:get("btnChallenge5.textCost")
			}, cc.p(10, 0))
			bind.touch(arg_12_0, var_12_1:get("btnChallenge5"), {
				methods = {
					ended = function()
						if table.length(arg_12_0.cards:read()) < 2 then
							gGameUI:showTip(gLanguageCsv.crossArenaTwoSpritesTips)
						else
							if gGameModel.role:read("rmb") < arg_12_0.challenge5Cost then
								gGameUI:showTip(gLanguageCsv.buyRMBNotEnough)

								return
							end

							if arg_12_0.challenge5Cost > 0 then
								gGameUI:showDialog({
									btnType = 2,
									clearFast = true,
									isRich = true,
									cb = function()
										gGameApp:requestServer("/game/cross/arena/battle/pass", function(arg_20_0)
											gGameUI:stackUI("city.pvp.cross_arena.pass", nil, {
												clickClose = true
											}, arg_12_0.role:read(), var_12_0)
										end, var_12_0.rank)
									end,
									content = string.format(gLanguageCsv.arenaPassTip, arg_12_0.challenge5Cost),
									dialogParams = {
										clickClose = false
									}
								})
							end
						end
					end
				}
			})
		end

		bind.touch(arg_12_0, var_12_1, {
			methods = {
				ended = function()
					gGameApp:requestServer("/game/cross/arena/role/info", function(arg_22_0)
						local var_22_0 = gGameUI:stackUI("city.pvp.cross_arena.personal_info", nil, {
							clickClose = true,
							dispatchNodes = arg_12_0.centerPanel
						}, arg_22_0.view)

						tip.adaptView(var_22_0, arg_12_0, {
							canvasDir = "horizontal",
							relativeNode = var_12_1,
							childsName = {
								"baseNode"
							}
						})
					end, var_12_0.record_db_id, var_12_0.game_key, var_12_0.rank)
				end
			}
		})
		widget.addAnimationByKey(var_12_1, "crossarena/kfjjc_dizuo.skel", "kfjjc_bj", "effect_loop_huang", 0):scale(2):xy(250, 250)
	end
end

function var_0_1.refreshChallenge5Cost(arg_23_0)
	for iter_23_0 = 1, 4 do
		local var_23_0 = arg_23_0.centerPanel:get("enemy_" .. iter_23_0)

		if var_23_0 then
			var_23_0:get("btnChallenge5.textCost"):text(arg_23_0.challenge5Cost)
			adapt.oneLineCenterPos(cc.p(100, 100), {
				var_23_0:get("btnChallenge5.imgDiamond"),
				var_23_0:get("btnChallenge5.textCost")
			}, cc.p(10, 0))
		end
	end
end

function var_0_1.initModel(arg_24_0)
	arg_24_0.date = gGameModel.cross_arena:getIdler("date")
	arg_24_0.round = gGameModel.cross_arena:getIdler("round")
	arg_24_0.servers = gGameModel.cross_arena:getIdler("servers")
	arg_24_0.role = gGameModel.cross_arena:getIdler("role")
	arg_24_0.enemys = gGameModel.cross_arena:getIdler("enemys")
	arg_24_0.pwTimes = gGameModel.daily_record:getIdler("cross_arena_pw_times")
	arg_24_0.buyPwTimes = gGameModel.daily_record:getIdler("cross_arena_buy_times")
	arg_24_0.refreshTimes = gGameModel.daily_record:getIdler("cross_arena_refresh_times")
	arg_24_0.vipLevel = gGameModel.role:getIdler("vip_level")
	arg_24_0.cards = gGameModel.role:getIdler("cards")
end

function var_0_1.onClickAddTimes(arg_25_0)
	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		cb = function()
			if gGameModel.role:read("rmb") < arg_25_0.challengeCost then
				gGameUI:showTip(gLanguageCsv.buyRMBNotEnough)

				return
			end

			gGameApp:requestServer("/game/cross/arena/battle/buy", function(arg_27_0)
				gGameUI:showTip(gLanguageCsv.buySuccess)
			end)
		end,
		title = gLanguageCsv.spaceTips,
		content = string.format(gLanguageCsv.crossArenaBuyTimesTips, arg_25_0.challengeCost),
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.onClickChange(arg_28_0)
	gGameApp:requestServer("/game/cross/arena/battle/main", function(arg_29_0)
		return
	end, 1)
end

function var_0_1.onShowHeadIcon(arg_30_0, arg_30_1, arg_30_2)
	gGameUI:stackUI("city.pvp.cross_arena.head_icon", nil, nil, arg_30_0:createHandler("onChangeSpine"))
end

function var_0_1.onChangeSpine(arg_31_0, arg_31_1)
	arg_31_0.selfPanel:removeChildByName("spineNode")

	local var_31_0 = dataEasy.getUnitIdForJJC(arg_31_1)
	local var_31_1 = csv.unit[var_31_0]

	widget.addAnimationByKey(arg_31_0.selfPanel, var_31_1.unitRes, "spineNode", "standby_loop", 1):scale(var_31_1.scale):xy(250, 250):setSkin(var_31_1.skin)
end

function var_0_1.startFighting(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_0.role:read().rank
	local var_32_1 = arg_32_1.rank

	arg_32_0:disableSchedule()
	battleEntrance.battleRequest("/game/cross/arena/battle/start", var_32_0, var_32_1, arg_32_1.role_db_id, arg_32_1.record_db_id):onStartOK(function(arg_33_0)
		arg_33_0.preData.rightRank = var_32_1

		if arg_32_2 then
			arg_32_2:onClose(false)

			arg_32_2 = nil
		end
	end):run():show()
end

function var_0_1.sevenInfo(arg_34_0)
	gGameUI:stackUI("city.pvp.cross_arena.seven_info", nil, {
		blackLayer = false,
		clickClose = true
	}, nil)
end

return var_0_1
