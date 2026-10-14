local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("FishingView", var_0_0)
local var_0_2 = {
	OUTSIDE = 2,
	INSIDE = 1
}
local var_0_3 = {
	CLOSE = 2,
	SHOWTIP = 1
}
local var_0_4 = {
	END = 2,
	BEGAN = 1
}

var_0_1.RESOURCE_FILENAME = "fishing.json"
var_0_1.RESOURCE_BINDING = {
	waitPanel = "waitPanel",
	["partner.partnerPos"] = "partnerPos",
	timer = "timer",
	["centerPanel.barPanel.bar"] = "scoreBar",
	["auto.time"] = "txtRefreshTime",
	activityTip = "activityTip",
	["rightPanel.timesPanel"] = "timesPanel",
	["rightPanel.btnThrow"] = "btnThrow",
	["rightPanel.btnTake"] = "btnTake",
	["auto.fish.item"] = "fishItem",
	auto = "auto",
	centerPanel = "centerPanel",
	["rightPanel.imgTip"] = "imgTip",
	partner = "partner",
	["txtRank.item"] = "rankItem",
	["centerPanel.fishingPanel"] = "fishingPanel",
	["auto.fish"] = "autoFish",
	["centerPanel.fishingPanel.bg"] = "fishBg",
	["centerPanel.fishingPanel.line"] = "line",
	leftPanel = "leftPanel",
	["centerPanel.fishingPanel.fish"] = "fish",
	["recordPanel.item"] = "item",
	recordPanel = "recordPanel",
	["centerPanel.fishingPanel.fishhook"] = "fishhook",
	txtRank = "txtRank",
	["auto.award.item"] = "awardItem",
	["timer.txt2"] = {
		varname = "gameEndTimerTxt",
		binds = {
			event = "text",
			idler = bindHelper.self("gameTimer"),
			method = function(arg_1_0)
				return time.getCutDown(arg_1_0).short_clock_str
			end
		}
	},
	["auto.time1"] = {
		varname = "refreshTime",
		binds = {
			event = "text",
			idler = bindHelper.self("deltaTime"),
			method = function(arg_2_0)
				return time.getCutDown(arg_2_0).min_sec_clock
			end
		}
	},
	["auto.fish.list"] = {
		varname = "fishList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("autoFishCfg"),
				item = bindHelper.self("fishItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					bind.extend(arg_3_0, arg_3_1, {
						event = "extend",
						class = "fish_icon",
						props = {
							onNodeClick = true,
							data = {
								key = arg_3_2,
								num = arg_3_3
							},
							onNode = function(arg_4_0)
								arg_4_0:xy(10, 10)
							end
						}
					})
				end
			}
		}
	},
	["auto.award.list"] = {
		varname = "awardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("autoAwardCfg"),
				item = bindHelper.self("awardItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					if arg_5_3.key == "id" then
						local var_5_0 = csv.cards[arg_5_3.val].unitID
						local var_5_1 = csv.cards[arg_5_3.val].star
						local var_5_2 = csv.unit[var_5_0].rarity

						bind.extend(arg_5_0, arg_5_1, {
							class = "card_icon",
							props = {
								unitId = var_5_0,
								rarity = var_5_2,
								star = var_5_1
							}
						})
						bind.touch(arg_5_0, arg_5_1, {
							methods = {
								ended = functools.partial(arg_5_0.itemClick, arg_5_1, arg_5_2, arg_5_3)
							}
						})
					else
						bind.extend(arg_5_0, arg_5_1, {
							class = "icon_key",
							props = {
								data = {
									key = arg_5_3.key,
									num = arg_5_3.val
								}
							}
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onitemClick")
			}
		}
	},
	["recordPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("fishingRecord"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					bind.extend(arg_6_0, arg_6_1, {
						event = "extend",
						class = "fish_icon",
						props = {
							onNodeClick = true,
							data = {
								key = arg_6_2,
								num = arg_6_3
							},
							onNode = function(arg_7_0)
								arg_7_0:scale(0.8)
							end
						}
					})
				end
			}
		}
	},
	["txtRank.list"] = {
		varname = "rankList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				padding = 10,
				data = bindHelper.self("ranksData"),
				item = bindHelper.self("rankItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_1:multiget("rank", "name", "score")

					var_8_0.rank:text(arg_8_2)
					var_8_0.name:text(arg_8_3.name)
					var_8_0.score:text(arg_8_3.point)
				end
			}
		}
	},
	["leftPanel.btnTools"] = {
		varname = "btnTools",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnTools")
			}
		}
	},
	["leftPanel.btnLv"] = {
		varname = "btnLv",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnLv")
			}
		}
	},
	["leftPanel.btnHandbook"] = {
		varname = "btnHandbook",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnHandbook")
			}
		}
	},
	["leftPanel.btnShop"] = {
		varname = "btnShop",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnShop")
			}
		}
	},
	["leftPanel.btnRank"] = {
		varname = "btnRank",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRank")
			}
		}
	},
	["leftPanel.itemBait"] = {
		varname = "itemBait",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBait")
			}
		}
	},
	["leftPanel.itemRod"] = {
		varname = "itemRod",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnRod")
			}
		}
	},
	btnRules = {
		varname = "btnRules",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["rightPanel.btnThrow.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 5,
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["rightPanel.btnTake.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 5,
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["leftPanel.btnLv.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["leftPanel.btnHandbook.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["leftPanel.btnShop.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["leftPanel.btnRank.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["leftPanel.btnTools.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["recordPanel.txtRecord"] = {
		varname = "txtRecord",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["rightPanel.timesPanel.surplus"] = {
		varname = "surplus",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["rightPanel.timesPanel.time"] = {
		varname = "time",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["rightPanel.timesPanel.times"] = {
		varname = "times",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["centerPanel.tipPanel.txtKeep"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["centerPanel.tipPanel.txtAnd"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["centerPanel.tipPanel.txtEnd"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["timer.txt1"] = {
		varname = "gameEndTimer",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.WHITE
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.cb = arg_9_3

	local var_9_0 = csv.fishing.scene[arg_9_1]

	arg_9_0.titleBack = gGameUI.topuiManager:createView("title", arg_9_0, {
		onClose = arg_9_0:createHandler("onClose")
	}):init({
		title = var_9_0.name,
		subTitle = var_9_0.titleEn
	})
	arg_9_0.skelState = var_0_2.INSIDE
	arg_9_0.autoType = var_0_4.END

	arg_9_0:initSkel(arg_9_1)
	arg_9_0:initModel()

	arg_9_0.autoFishCfg = idlertable.new({})
	arg_9_0.autoAwardCfg = idlers.newWithMap({})
	arg_9_0.exitType = idler.new("normal")
	arg_9_0.onThrowBtn = idler.new(0)
	arg_9_0.onAutoBtn = idler.new(0)
	arg_9_0.ranksData = idlers.newWithMap({})
	arg_9_0.deltaTime = idler.new(0)
	arg_9_0.gameTimer = idler.new(0)

	if matchLanguage({
		"en"
	}) then
		adapt.setAutoText(arg_9_0.txtRecord, nil, 120)
	else
		arg_9_0.txtRecord:getVirtualRenderer():setLineSpacing(-7)
	end

	arg_9_0.btnRank:visible(arg_9_1 == game.FISHING_GAME)
	arg_9_0.txtRank:visible(arg_9_1 == game.FISHING_GAME)
	arg_9_0.rankList:setTouchEnabled(false)
	arg_9_0.fishingGameSkel:visible(arg_9_1 == game.FISHING_GAME)
	arg_9_0.dasaixiaoren1:visible(arg_9_1 == game.FISHING_GAME)
	arg_9_0.dasaixiaoren2:visible(arg_9_1 == game.FISHING_GAME)
	text.addEffect(arg_9_0.gameEndTimerTxt, {
		outline = {
			color = ui.COLORS.OUTLINE.WHITE
		}
	})

	local var_9_1 = {}

	if arg_9_2 then
		for iter_9_0, iter_9_1 in ipairs(arg_9_2.ranks) do
			if iter_9_0 <= 3 and iter_9_1 then
				table.insert(var_9_1, iter_9_1)
			end
		end
	end

	arg_9_0.ranksData:update(var_9_1)

	if arg_9_1 == game.FISHING_GAME then
		arg_9_0:fishingGameTimer()
	end

	local var_9_2 = arg_9_0.fishLevel:read()

	idlereasy.any({
		arg_9_0.fishLevel,
		arg_9_0.fishingRecord,
		arg_9_0.fishingCounter,
		arg_9_0.selectRod,
		arg_9_0.selectBait,
		arg_9_0.selectPartner,
		arg_9_0.items,
		arg_9_0.crossFishingRound
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8)
		arg_9_0.timer:visible(arg_9_1 == game.FISHING_GAME and arg_10_8 == "start")
		adapt.oneLineCenterPos(cc.p(260, arg_9_0.gameEndTimer:y()), {
			arg_9_0.gameEndTimer,
			arg_9_0.gameEndTimerTxt
		})

		if arg_9_1 ~= game.FISHING_GAME then
			arg_9_0:initActivityTip(arg_10_8)
		end

		arg_9_0.idx = arg_9_1
		arg_9_0.nowTimes = gCommonConfigCsv.fishingDailyTimes - arg_10_3

		arg_9_0.times:text(arg_9_0.nowTimes)
		adapt.oneLineCenterPos(cc.p(140, arg_9_0.times:y()), {
			arg_9_0.surplus,
			arg_9_0.times,
			arg_9_0.time
		}, cc.p(10, 0))

		local var_10_0 = csv.fishing.level[arg_10_1]
		local var_10_1 = csv.fishing.bait[arg_10_5]

		if arg_10_5 and var_10_1 then
			arg_9_0.baitCount = arg_10_7[var_10_1.itemId]
			arg_9_0.map = itertools.map(var_10_1.scene, function(arg_11_0, arg_11_1)
				return arg_11_1, true
			end)

			if arg_9_0.map[arg_9_0.idx] then
				bind.extend(arg_9_0, arg_9_0.itemBait, {
					class = "fishtools_icon",
					props = {
						num = true,
						data = {
							typ = 2,
							key = var_10_1.itemId,
							lock = arg_10_7[var_10_1.itemId]
						},
						onNode = function(arg_12_0)
							arg_12_0:xy(-4, -4):scale(0.8):z(3)
						end
					}
				})
			end
		end

		local var_10_2 = csv.fishing.rod[arg_10_4]

		if arg_10_4 and var_10_2 then
			bind.extend(arg_9_0, arg_9_0.itemRod, {
				class = "fishtools_icon",
				props = {
					data = {
						typ = 1,
						key = var_10_2.itemId
					},
					onNode = function(arg_13_0)
						arg_13_0:xy(-4, -4):scale(0.8):z(3)
					end
				}
			})
			arg_9_0.diaoyuActionSkel:setSkin(var_10_2.res)
		end

		arg_9_0.partnerPos:get("partner"):visible(arg_10_6 ~= 0)

		if arg_10_6 ~= 0 then
			local var_10_3 = csv.fishing.partner[arg_10_6]
			local var_10_4 = csv.unit[var_10_3.unitId]

			arg_9_0.partnerPos:removeAllChildren()

			local var_10_5 = widget.addAnimationByKey(arg_9_0.partnerPos, var_10_4.unitRes, "partner", "standby_loop", 1):scale(-var_10_3.scale, var_10_3.scale)

			arg_9_0.partner:xy(arg_9_0.diaoyuActionSkel:x() + 230, arg_9_0.diaoyuActionSkel:y() + 100)
			bind.touch(arg_9_0, arg_9_0.partner, {
				methods = {
					ended = function()
						if arg_9_0.nowTimes <= 0 then
							gGameUI:showTip(gLanguageCsv.fishNoTimes)
						elseif arg_10_5 == nil or var_10_1 == nil or arg_9_0.map[arg_9_0.idx] ~= true then
							gGameUI:showTip(gLanguageCsv.noBait)
						elseif arg_10_4 == nil or var_10_2 == nil then
							gGameUI:showTip(gLanguageCsv.noRod)
						elseif arg_10_5 and var_10_1 then
							if arg_10_7[var_10_1.itemId] == nil then
								gGameUI:showTip(gLanguageCsv.noBaitCount)
							else
								arg_9_0:onPartnerClick(arg_10_8)
							end
						else
							arg_9_0:onPartnerClick(arg_10_8)
						end
					end
				}
			})
		end

		local function var_10_6()
			local var_15_0 = 0

			arg_9_0:enableSchedule()
			arg_9_0:schedule(function()
				if var_15_0 == 0 then
					arg_9_0.partner:get("bg"):hide()

					var_15_0 = 1
				elseif var_15_0 == 1 then
					arg_9_0.partner:get("bg"):show()

					var_15_0 = 0
				end
			end, 5, 0, 7)
		end

		if arg_9_0.idx == game.FISHING_GAME then
			if arg_9_0.isAuto and arg_9_0.isAuto:read() == true then
				arg_9_0.partner:setTouchEnabled(false)
				var_10_6()
			else
				local var_10_7 = dataEasy.isUnlock(gUnlockCsv.gameAutoFish)

				arg_9_0.partner:get("bg"):visible(var_10_7)
				arg_9_0.partner:setTouchEnabled(var_10_7)

				if var_10_7 == true then
					var_10_6()
				end
			end
		elseif arg_9_0.isAuto and arg_9_0.isAuto:read() == true then
			arg_9_0.partner:setTouchEnabled(false)
			var_10_6()
		else
			local var_10_8 = dataEasy.isUnlock(gUnlockCsv.autoFish)

			arg_9_0.partner:get("bg"):visible(var_10_8)
			arg_9_0.partner:setTouchEnabled(var_10_8)

			if var_10_8 == true then
				var_10_6()
			end
		end

		local function var_10_9()
			if arg_10_8 == "start" and arg_9_0.onThrowBtn:read() == 0 and arg_9_0.idx ~= game.FISHING_GAME then
				gGameUI:showDialog({
					fontSize = 40,
					clearFast = true,
					btnType = 2,
					strs = {
						gLanguageCsv.fishGameStartIsFishing
					},
					cb = function()
						arg_9_0.onThrowBtn:set(1)
						arg_9_0:onThrow(var_10_2.extraSpeed, var_10_2.lowerSpeed, var_10_2.extraZone, var_10_2.lowerWait, var_10_1.lowerRandom, var_10_1.lowerWait, var_10_0.timeDown, var_10_0.fasterSpeed)
					end
				})
			elseif arg_10_8 == "closed" and arg_9_0.idx == game.FISHING_GAME then
				gGameUI:showTip(gLanguageCsv.theContestIsOverCantFishing)
			else
				arg_9_0:onThrow(var_10_2.extraSpeed, var_10_2.lowerSpeed, var_10_2.extraZone, var_10_2.lowerWait, var_10_1.lowerRandom, var_10_1.lowerWait, var_10_0.timeDown, var_10_0.fasterSpeed)
			end
		end

		bind.touch(arg_9_0, arg_9_0.btnThrow, {
			methods = {
				ended = function()
					if arg_9_0.nowTimes <= 0 then
						gGameUI:showTip(gLanguageCsv.fishNoTimes)
					elseif arg_10_5 == nil or var_10_1 == nil or arg_9_0.map[arg_9_0.idx] ~= true then
						gGameUI:showTip(gLanguageCsv.noBait)
					elseif arg_10_4 == nil or var_10_2 == nil then
						gGameUI:showTip(gLanguageCsv.noRod)
					elseif arg_10_5 and var_10_1 then
						if arg_10_7[var_10_1.itemId] == nil then
							gGameUI:showTip(gLanguageCsv.noBaitCount)
						else
							var_10_9()
						end
					else
						var_10_9()
					end
				end
			}
		})

		local function var_10_10()
			arg_9_0:enableSchedule():unSchedule(6000)
			arg_9_0:enableSchedule():unSchedule(7000)
			arg_9_0.auto:hide()
			arg_9_0.btnThrow:show()
			arg_9_0.autoFishCfg:set({})

			arg_9_0.autoType = var_0_4.END

			local var_20_0 = dataEasy.isUnlock(gUnlockCsv.autoFish)

			arg_9_0.partner:setTouchEnabled(var_20_0)

			if arg_9_0.fishLevel:read() > var_9_2 then
				gGameUI:stackUI("city.adventure.fishing.upgrade")
			end

			gGameUI:showDialog({
				fontSize = 40,
				clearFast = true,
				btnType = 1,
				strs = {
					gLanguageCsv.fishingGameIsOverAutoIsStop
				}
			})
		end

		if arg_10_8 == "closed" and arg_9_0.autoType == var_0_4.BEGAN and arg_9_0.idx == game.FISHING_GAME then
			var_10_10()
		end
	end)

	if arg_9_0.isAuto and arg_9_0.isAuto:read() == true then
		arg_9_0:autoFishing()
	end

	local var_9_3 = {}

	for iter_9_2, iter_9_3 in csvPairs(csv.fishing.fish) do
		var_9_3[iter_9_2] = {
			csvId = iter_9_2,
			speed = iter_9_3.speed,
			escape = iter_9_3.escape,
			randMove = iter_9_3.randMove,
			competitionSpeed = iter_9_3.competitionSpeed,
			competitionEscape = iter_9_3.competitionEscape,
			competitionRandMove = iter_9_3.competitionRandMove,
			time = iter_9_3.time,
			deadTime = iter_9_3.deadTime
		}
	end

	arg_9_0.fishTabs = idlers.new(var_9_3)

	arg_9_0.fishTabs:update(var_9_3)
	arg_9_0.btnTake:addTouchEventListener(function(arg_21_0, arg_21_1)
		if arg_21_1 == ccui.TouchEventType.began then
			arg_9_0:onTake()
		elseif arg_21_1 == ccui.TouchEventType.ended or arg_21_1 == ccui.TouchEventType.canceled then
			arg_9_0:loosen()
		end
	end)
end

function var_0_1.initModel(arg_22_0)
	arg_22_0.fishLevel = gGameModel.fishing:getIdler("level")
	arg_22_0.fishingRecord = gGameModel.daily_record:getIdler("fishing_record")
	arg_22_0.fishingCounter = gGameModel.daily_record:getIdler("fishing_counter")
	arg_22_0.selectRod = gGameModel.fishing:getIdler("select_rod")
	arg_22_0.selectBait = gGameModel.fishing:getIdler("select_bait")
	arg_22_0.selectPartner = gGameModel.fishing:getIdler("select_partner")
	arg_22_0.items = gGameModel.role:getIdler("items")
	arg_22_0.fishModel = gGameModel.fishing:getIdler("fish")
	arg_22_0.isAuto = gGameModel.fishing:getIdler("is_auto")
	arg_22_0.autoStopped = gGameModel.fishing:getIdler("auto_stopped")
	arg_22_0.autoAward = gGameModel.fishing:getIdler("auto_award")
	arg_22_0.autoWinCounter = gGameModel.fishing:getIdler("auto_win_counter")
	arg_22_0.autoFailCounter = gGameModel.fishing:getIdler("auto_fail_counter")
	arg_22_0.crossFishingRound = gGameModel.role:getIdler("cross_fishing_round")
	arg_22_0.autoStartTime = gGameModel.fishing:getIdler("auto_start_time")
end

function var_0_1.initSkel(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:getResourceNode()
	local var_23_1 = csv.fishing.scene[arg_23_1]

	widget.addAnimationByKey(var_23_0, var_23_1.res, "diaoyuBg", "effect_loop", 2):xy(display.sizeInView.width / 2, display.sizeInView.height / 2 - 20):scale(2)

	arg_23_0.diaoyuActionSkel = widget.addAnimationByKey(var_23_0, "diaoyu/diaoyu.skel", "diaoyu", "daiji_loop", 3)

	arg_23_0.diaoyuActionSkel:anchorPoint(cc.p(0.5, 0.5)):xy(display.sizeInView.width / 2 + var_23_1.characterPos[1], display.sizeInView.height / 2 + var_23_1.characterPos[2]):scale(2)
	arg_23_0.diaoyuActionSkel:setSkin("rod_0")
	arg_23_0.waitPanel:xy(arg_23_0.diaoyuActionSkel:x() + 20, arg_23_0.diaoyuActionSkel:y() + 365)
	widget.addAnimationByKey(arg_23_0.partnerPos, "koudai_miaowazhongzi/hero_miaowazhongzi.skel", "partner", "standby_loop", 1):scaleX(-1)

	arg_23_0.fishingGameSkel = widget.addAnimationByKey(var_23_0, "fishing/diaoyudasai.skel", "diaoyudasai", "effect_loop", 3)

	arg_23_0.fishingGameSkel:anchorPoint(cc.p(0.5, 0.5)):xy(display.sizeInView.width / 2 - 720, display.sizeInView.height / 2 + 220):scale(2)

	arg_23_0.dasaixiaoren1 = widget.addAnimationByKey(var_23_0, "fishing/dasaixiaoren1.skel", "dasaixiaoren1", "effect_loop", 2)

	arg_23_0.dasaixiaoren1:anchorPoint(cc.p(0.5, 0.5)):xy(display.sizeInView.width / 2 + 800, display.sizeInView.height / 2 + 60)

	arg_23_0.dasaixiaoren2 = widget.addAnimationByKey(var_23_0, "fishing/dasaixiaoren2.skel", "dasaixiaoren2", "effect_loop", 2)

	arg_23_0.dasaixiaoren2:anchorPoint(cc.p(0.5, 0.5)):xy(display.sizeInView.width / 2 + 600, display.sizeInView.height / 2 - 20)
end

function var_0_1.onThrow(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8)
	arg_24_0.partner:setTouchEnabled(false)
	itertools.invoke({
		arg_24_0.btnThrow,
		arg_24_0.timesPanel,
		arg_24_0.btnRules,
		arg_24_0.recordPanel,
		arg_24_0.leftPanel,
		arg_24_0.activityTip
	}, "hide")
	arg_24_0.diaoyuActionSkel:play("effect_paoxian")

	arg_24_0.exitType = var_0_3.SHOWTIP

	gGameApp:requestServer("/game/fishing/once/start", function(arg_25_0)
		arg_24_0.fishTab = arg_24_0.fishTabs:atproxy(arg_25_0.view.fish)

		local var_25_0 = math.random(arg_24_0.fishTab.time[1], arg_24_0.fishTab.time[2])
		local var_25_1 = arg_24_3 == 0 and arg_24_3 or arg_24_3 - 1
		local var_25_2 = arg_24_5
		local var_25_3 = arg_24_0.idx == game.FISHING_GAME and arg_24_0.fishTab.competitionSpeed ~= 0 and arg_24_0.fishTab.competitionSpeed or arg_24_0.fishTab.speed
		local var_25_4 = arg_24_0.idx == game.FISHING_GAME and arg_24_0.fishTab.competitionEscape ~= 0 and arg_24_0.fishTab.competitionEscape or arg_24_0.fishTab.escape
		local var_25_5 = arg_24_1 + arg_24_8
		local var_25_6 = arg_24_2
		local var_25_7 = math.ceil(var_25_0 * (1 - (arg_24_4 + arg_24_6 + arg_24_7)))

		arg_24_0.fishhook:height(arg_24_0.fishhook:height() + arg_24_0.fishhook:height() * var_25_1)

		local var_25_8 = math.max(var_25_0 - var_25_7, gCommonConfigCsv.fishingLowestWaitTimes)

		performWithDelay(arg_24_0.diaoyuActionSkel, function()
			arg_24_0.waitPanel:show()
			arg_24_0.diaoyuActionSkel:play("dengdai_loop")
			performWithDelay(arg_24_0, function()
				gGameApp:requestServer("/game/fishing/once/doing", function(arg_28_0)
					arg_24_0.partner:setTouchEnabled(false)
					arg_24_0.titleBack:hide()
					arg_24_0.waitPanel:hide()
					arg_24_0.diaoyuActionSkel:play("shougan2_loop")

					arg_24_0.exitType = var_0_3.CLOSE

					itertools.invoke({
						arg_24_0.btnTake,
						arg_24_0.centerPanel,
						arg_24_0.imgTip,
						arg_24_0.timesPanel
					}, "show")
					arg_24_0.fish:y(arg_24_0.fishBg:height() / 2)
					arg_24_0.fishhook:y(arg_24_0.fishBg:height() / 2)
					arg_24_0.scoreBar:setPercent(33.333333333333336)
					arg_24_0:angling(var_25_3, var_25_4, var_25_5, var_25_6)
					arg_24_0:fishMove(var_25_2, arg_24_0.fishTab.deadTime)
					arg_24_0:loosen()
					arg_24_0:lineChange()
				end, arg_25_0.view.fish)
			end, var_25_8)
		end, 3)
	end)
end

function var_0_1.angling(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local var_29_0 = 0
	local var_29_1 = (arg_29_1 + arg_29_1 * arg_29_3) / 20
	local var_29_2, var_29_3 = (arg_29_2 - arg_29_2 * arg_29_4) / 20, var_29_1

	arg_29_0:enableSchedule()
	arg_29_0:schedule(function()
		local var_30_0 = arg_29_0.fishhook:getBoundingBox()
		local var_30_1, var_30_2 = arg_29_0.fish:xy()

		arg_29_0.barVal = arg_29_0.scoreBar:getPercent()

		if cc.rectContainsPoint(var_30_0, cc.p(var_30_1, var_30_2)) then
			var_29_0 = 0

			if arg_29_0.skelState == var_0_2.OUTSIDE then
				arg_29_0.diaoyuActionSkel:play("shougan2_loop")

				arg_29_0.skelState = var_0_2.INSIDE
			end

			arg_29_0.scoreBar:setPercent(arg_29_0.barVal + var_29_3)

			if arg_29_0.barVal >= 100 then
				arg_29_0:finish(true)
			end
		else
			if arg_29_0.skelState == var_0_2.INSIDE then
				arg_29_0.diaoyuActionSkel:play("shougan_loop")

				arg_29_0.skelState = var_0_2.OUTSIDE
			end

			arg_29_0.scoreBar:setPercent(arg_29_0.barVal - var_29_2)

			if arg_29_0.barVal <= 0 then
				var_29_0 = var_29_0 + 0.05

				if var_29_0 >= 1 then
					arg_29_0:finish()
				end
			end
		end
	end, 0.05, 0, 1)
end

function var_0_1.fishMove(arg_31_0, arg_31_1, arg_31_2)
	arg_31_0:enableSchedule()

	local var_31_0 = arg_31_1
	local var_31_1 = arg_31_0.fishBg:height()
	local var_31_2 = arg_31_0.fishingPanel:height()
	local var_31_3 = arg_31_0.fish:height() / 2
	local var_31_4 = 0 + var_31_3
	local var_31_5 = var_31_1 - var_31_3 - 130
	local var_31_6 = {
		arg_31_0.fishTab.randMove[1],
		arg_31_0.fishTab.randMove[2]
	}

	if arg_31_0.idx == game.FISHING_GAME and arg_31_0.fishTab.competitionRandMove[1] then
		var_31_6 = {
			arg_31_0.fishTab.competitionRandMove[1],
			arg_31_0.fishTab.competitionRandMove[2]
		}
	end

	local var_31_7 = 2
	local var_31_8 = arg_31_2
	local var_31_9 = 0

	arg_31_0:schedule(function()
		local var_32_0 = math.random(var_31_6[1], var_31_6[2])
		local var_32_1 = var_31_1 * (var_32_0 / 100) - var_31_1 * (var_32_0 / 100) * var_31_0

		if math.random(0, 1) == 1 then
			var_32_1 = -var_32_1
		end

		local var_32_2 = arg_31_0.fish:y() + var_32_1

		if var_32_2 >= var_31_5 then
			var_32_2 = var_31_5
		elseif var_32_2 <= var_31_4 then
			var_32_2 = var_31_4
		end

		local var_32_3 = var_32_2

		if var_31_9 == 0 then
			var_32_3 = var_32_2
			var_31_7 = var_31_7 - 1

			if var_31_7 <= 0 then
				var_31_9 = 1
				var_31_8 = arg_31_2
			end
		end

		if var_31_9 == 1 then
			var_32_3 = arg_31_0.fish:y()
			var_31_8 = var_31_8 - 1

			if var_31_8 <= 0 then
				var_31_9 = 0
				var_31_7 = 2
			end
		end

		transition.executeParallel(arg_31_0.fish, true):moveTo(1, arg_31_0.fish:x(), var_32_3)
	end, 1, 0, 2)
end

function var_0_1.onTake(arg_33_0)
	arg_33_0:enableSchedule():unSchedule(4)

	local var_33_0 = arg_33_0.fishBg:height() / 2
	local var_33_1 = arg_33_0.fishhook:height() / 2
	local var_33_2 = arg_33_0.fishBg:y() + (var_33_0 - var_33_1 - 40)
	local var_33_3 = 25

	arg_33_0:schedule(function()
		local var_34_0 = arg_33_0.fishhook:y() + var_33_3

		if arg_33_0.fishhook:y() >= var_33_2 then
			var_34_0 = var_33_2
		elseif arg_33_0.fishhook:y() + var_33_3 > var_33_2 and arg_33_0.fishhook:y() < var_33_2 then
			var_34_0 = arg_33_0.fishhook:y() + var_33_3 - (arg_33_0.fishhook:y() + var_33_3 - var_33_2)
		end

		transition.executeParallel(arg_33_0.fishhook):moveTo(0.05, arg_33_0.fishhook:x(), var_34_0, true)
	end, 0.05, 0, 3)
end

function var_0_1.loosen(arg_35_0)
	arg_35_0:enableSchedule():unSchedule(3)

	local var_35_0 = arg_35_0.fishBg:height() / 2
	local var_35_1 = arg_35_0.fishhook:height() / 2
	local var_35_2 = arg_35_0.fishBg:y() - (var_35_0 - var_35_1 - 40)
	local var_35_3 = 0
	local var_35_4 = -5
	local var_35_5 = -25

	arg_35_0:schedule(function()
		var_35_3 = var_35_3 + 0.05

		if var_35_3 >= 0.6 and var_35_4 > var_35_5 then
			var_35_4 = var_35_4 - 1.5
		end

		local var_36_0 = arg_35_0.fishhook:y() + var_35_4

		if arg_35_0.fishhook:y() <= var_35_2 then
			var_36_0 = var_35_2
		elseif arg_35_0.fishhook:y() + var_35_4 < var_35_2 and arg_35_0.fishhook:y() > var_35_2 then
			var_36_0 = arg_35_0.fishhook:y() + var_35_4 - (arg_35_0.fishhook:y() + var_35_4 - var_35_2)
		end

		transition.executeParallel(arg_35_0.fishhook):moveTo(0.05, arg_35_0.fishhook:x(), var_36_0, true)
	end, 0.05, 0, 4)
end

function var_0_1.lineChange(arg_37_0)
	arg_37_0:schedule(function()
		local var_38_0 = arg_37_0.fishBg:height() / 2
		local var_38_1 = arg_37_0.fishhook:y()

		arg_37_0.line:height(var_38_0 - 120 + (var_38_0 - var_38_1) < 67 and 67 or var_38_0 - 120 + (var_38_0 - var_38_1))
	end, 0.01, 0, 5)
end

function var_0_1.finish(arg_39_0, arg_39_1)
	arg_39_0:enableSchedule():unScheduleAll()
	arg_39_0.diaoyuActionSkel:play("daiji_loop")
	arg_39_0.fishhook:height(220)

	if arg_39_0.idx == game.FISHING_GAME then
		local var_39_0 = dataEasy.isUnlock(gUnlockCsv.gameAutoFish)

		arg_39_0.partner:setTouchEnabled(var_39_0)
		arg_39_0:fishingGameTimer()
	else
		local var_39_1 = dataEasy.isUnlock(gUnlockCsv.autoFish)

		arg_39_0.partner:setTouchEnabled(var_39_1)
	end

	itertools.invoke({
		arg_39_0.centerPanel,
		arg_39_0.btnTake,
		arg_39_0.imgTip
	}, "hide")
	itertools.invoke({
		arg_39_0.btnThrow,
		arg_39_0.timesPanel,
		arg_39_0.btnRules,
		arg_39_0.recordPanel,
		arg_39_0.leftPanel,
		arg_39_0.titleBack
	}, "show")

	local var_39_2 = "fail"

	if arg_39_1 then
		var_39_2 = "win"
	end

	local var_39_3 = arg_39_0.fishTab.csvId
	local var_39_4 = arg_39_0.fishModel:read()
	local var_39_5 = var_39_4[var_39_3] and var_39_4[var_39_3].length_max or 0
	local var_39_6 = arg_39_0.fishLevel:read()
	local var_39_7 = gGameModel.fishing:read("point")
	local var_39_8 = {
		false
	}

	gGameApp:requestServerCustom("/game/fishing/once/end"):params(var_39_3, var_39_2):onResponse(function(arg_40_0)
		if var_39_2 == "win" and arg_39_0.idx == game.FISHING_GAME then
			local var_40_0 = {}

			if arg_40_0.view and arg_40_0.view.top3 then
				for iter_40_0, iter_40_1 in ipairs(arg_40_0.view.top3) do
					table.insert(var_40_0, iter_40_1)
				end

				arg_39_0.ranksData:update(var_40_0)
			end
		end

		var_39_8[1] = true
	end):wait(var_39_8):doit(function(arg_41_0)
		if arg_39_1 then
			if arg_39_0.fishLevel:read() > var_39_6 then
				gGameUI:stackUI("city.adventure.fishing.upgrade", nil, nil, arg_39_0:createHandler("fishSprite", arg_41_0.view, var_39_3, var_39_5, var_39_7))
			else
				arg_39_0:fishSprite(arg_41_0.view, var_39_3, var_39_5, var_39_7)
			end
		else
			gGameUI:showTip(gLanguageCsv.fishLose)
		end
	end)
end

function var_0_1.fishSprite(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	if arg_42_1.award.carddbIDs then
		local var_42_0, var_42_1, var_42_2 = dataEasy.mergeRawDate(arg_42_1.award)

		gGameUI:stackUI("common.gain_sprite", {
			cb = arg_42_0:createHandler("fishResult", arg_42_2, arg_42_1.length, arg_42_1.award, arg_42_3, arg_42_4)
		}, {
			full = true
		}, var_42_0[1])
	else
		arg_42_0:fishResult(arg_42_2, arg_42_1.length, arg_42_1.award, arg_42_3, arg_42_4)
	end
end

function var_0_1.fishResult(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	gGameUI:stackUI("city.adventure.fishing.result", nil, {
		clickClose = true
	}, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_0.idx, arg_43_5)
end

function var_0_1.onBtnLv(arg_44_0)
	gGameUI:stackUI("city.adventure.fishing.level")
end

function var_0_1.onBtnHandbook(arg_45_0)
	gGameUI:stackUI("city.adventure.fishing.book")
end

function var_0_1.onBtnShop(arg_46_0)
	if not gGameUI:goBackInStackUI("city.shop") then
		gGameApp:requestServer("/game/fishing/shop/get", function(arg_47_0)
			gGameUI:stackUI("city.shop", nil, {
				full = true
			}, game.SHOP_INIT.FISHING_SHOP)
		end)
	end
end

function var_0_1.onBtnRank(arg_48_0)
	gGameApp:requestServer("/game/cross/fishing/rank", function(arg_49_0)
		gGameUI:stackUI("city.adventure.fishing.rank", nil, nil, arg_49_0.view)
	end)
end

function var_0_1.onBtnTools(arg_50_0)
	gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_50_0.idx)
end

function var_0_1.onBtnBait(arg_51_0)
	gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 2, arg_51_0.idx)
end

function var_0_1.onBtnRod(arg_52_0)
	gGameUI:stackUI("city.adventure.fishing.bag", nil, nil, 1, arg_52_0.idx)
end

function var_0_1.onPartnerClick(arg_53_0, arg_53_1)
	local var_53_0 = {
		"#C0x5B545B#" .. gLanguageCsv.isAutoFishing,
		"#C0x999999#" .. gLanguageCsv.autoFishCanLose
	}
	local var_53_1 = true

	if arg_53_1 == "start" and arg_53_0.onAutoBtn:read() == 0 and arg_53_0.idx ~= game.FISHING_GAME then
		var_53_0 = {
			gLanguageCsv.fishGameStartIsAutoFishing
		}
		var_53_1 = false
	elseif arg_53_1 == "closed" and arg_53_0.idx == game.FISHING_GAME then
		gGameUI:showTip(gLanguageCsv.theContestIsOverCantFishing)

		return
	end

	gGameUI:showDialog({
		fontSize = 40,
		clearFast = true,
		btnType = 2,
		strs = var_53_0,
		cb = function()
			arg_53_0.onAutoBtn:set(1)
			arg_53_0:autoFishing("click")
		end,
		isRich = var_53_1
	})
end

function var_0_1.autoFishing(arg_55_0, arg_55_1)
	arg_55_0.autoType = var_0_4.BEGAN

	arg_55_0.auto:show()
	arg_55_0.btnThrow:hide()
	arg_55_0.auto:get("txt"):text(gLanguageCsv.canBackToCity)

	local var_55_0 = arg_55_0.fishLevel:read()

	arg_55_0:enableSchedule()

	if arg_55_1 == "click" then
		arg_55_0.partner:setTouchEnabled(false)
		gGameApp:requestServer("/game/fishing/auto/start")
	else
		gGameApp:requestServer("/game/fishing/main", function(arg_56_0)
			if arg_55_0.idx == game.FISHING_GAME then
				local var_56_0 = {}

				if arg_56_0.view and arg_56_0.view.top3 then
					for iter_56_0, iter_56_1 in ipairs(arg_56_0.view.top3) do
						table.insert(var_56_0, iter_56_1)
					end

					arg_55_0.ranksData:update(var_56_0)
				end
			end
		end)
	end

	local var_55_1 = 0

	idlereasy.when(arg_55_0.autoStartTime, function(arg_57_0, arg_57_1)
		local var_57_0 = time.getTimestamp(time.getNowDate())
		local var_57_1 = gCommonConfigCsv.fishingAutoDuration + 1

		arg_55_0.delta = var_57_1 - (var_57_0 - arg_57_1) % var_57_1

		local var_57_2 = time.getCutDown(var_57_1 - (var_57_0 - arg_57_1) % var_57_1)

		var_55_1 = var_57_2.min * 60 + var_57_2.sec

		arg_55_0:schedule(function()
			local var_58_0 = time.getTimestamp(time.getNowDate())

			arg_55_0.delta = arg_55_0.delta - 1

			if arg_55_0.delta < 0 then
				if arg_55_0.nowTimes == 0 then
					arg_55_0.txtRefreshTime:hide()
					arg_55_0.refreshTime:hide()
				end

				arg_55_0.delta = var_57_1 - (var_58_0 - arg_57_1) % var_57_1
			end

			arg_55_0.deltaTime:set(arg_55_0.delta)
		end, 1, 0, 7000)
	end)
	arg_55_0.txtRefreshTime:text(gLanguageCsv.nextFishing)
	adapt.oneLinePos(arg_55_0.txtRefreshTime, arg_55_0.refreshTime, cc.p(0, 0), "left")

	local function var_55_2()
		local var_59_0 = gCommonConfigCsv.fishingAutoDuration + 1

		arg_55_0:schedule(function()
			gGameApp:requestServer("/game/fishing/main", function(arg_61_0)
				if arg_55_0.idx == game.FISHING_GAME then
					local var_61_0 = {}

					if arg_61_0.view and arg_61_0.view.top3 then
						for iter_61_0, iter_61_1 in ipairs(arg_61_0.view.top3) do
							table.insert(var_61_0, iter_61_1)
						end

						arg_55_0.ranksData:update(var_61_0)
					end
				end
			end)
		end, var_59_0, 0, 6000)
	end

	if arg_55_1 == "click" then
		var_55_2()
	else
		performWithDelay(arg_55_0, function()
			var_55_2()
		end, var_55_1 - 1)
	end

	idlereasy.any({
		arg_55_0.autoStopped,
		arg_55_0.autoAward,
		arg_55_0.autoWinCounter,
		arg_55_0.autoFailCounter
	}, function(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
		local var_63_0 = {}

		arg_55_0.auto:get("btnOk"):visible(arg_63_1 == true)
		arg_55_0.auto:get("btnStop"):visible(arg_63_1 == false)
		arg_55_0.auto:get("tipView"):visible(arg_63_1 == false)
		arg_55_0.txtRefreshTime:visible(arg_63_1 == false)
		arg_55_0.refreshTime:visible(arg_63_1 == false)
		arg_55_0.auto:get("tipOver"):visible(arg_63_1 == true and arg_55_0.nowTimes == 0 or arg_63_1 == true and arg_55_0.baitCount and arg_55_0.nowTimes > 0)
		arg_55_0.auto:get("tipOver1"):visible(arg_63_1 == true and not arg_55_0.baitCount and arg_55_0.nowTimes > 0)
		arg_55_0.autoFish:get("txt2"):text(arg_63_3 + arg_63_4)
		arg_55_0.autoFish:get("txt4"):text(arg_63_3)
		arg_55_0.autoFish:get("txt6"):text(arg_63_4)
		adapt.oneLinePos(arg_55_0.autoFish:get("txt1"), {
			arg_55_0.autoFish:get("txt2"),
			arg_55_0.autoFish:get("txt3"),
			arg_55_0.autoFish:get("txt4"),
			arg_55_0.autoFish:get("txt5"),
			arg_55_0.autoFish:get("txt6"),
			arg_55_0.autoFish:get("txt7")
		}, cc.p(5, 0), "left")

		if arg_63_2.fish then
			arg_55_0.autoFishCfg:set(arg_63_2.fish)
		end

		if arg_63_2.type1 then
			for iter_63_0, iter_63_1 in pairs(arg_63_2.type1) do
				table.insert(var_63_0, {
					key = iter_63_0,
					val = iter_63_1
				})
			end
		end

		if arg_63_2.type2 then
			for iter_63_2, iter_63_3 in pairs(arg_63_2.type2) do
				table.insert(var_63_0, {
					key = iter_63_2,
					val = iter_63_3
				})
			end
		end

		if arg_63_2.cards then
			for iter_63_4, iter_63_5 in pairs(arg_63_2.cards) do
				table.insert(var_63_0, {
					key = "id",
					val = iter_63_5.id
				})
			end
		end

		arg_55_0.autoAwardCfg:update(var_63_0)
	end)

	local function var_55_3()
		arg_55_0:enableSchedule():unSchedule(6000)
		arg_55_0:enableSchedule():unSchedule(7000)

		arg_55_0.autoType = var_0_4.END

		arg_55_0.auto:hide()
		arg_55_0.btnThrow:show()
		arg_55_0.autoFishCfg:set({})

		local var_64_0 = dataEasy.isUnlock(gUnlockCsv.autoFish)

		arg_55_0.partner:setTouchEnabled(var_64_0)

		if arg_55_0.fishLevel:read() > var_55_0 then
			gGameUI:stackUI("city.adventure.fishing.upgrade")
		end
	end

	bind.touch(arg_55_0, arg_55_0.auto:get("btnOk"), {
		methods = {
			ended = function()
				gGameApp:requestServer("/game/fishing/auto/end", var_55_3)
			end
		}
	})
	bind.touch(arg_55_0, arg_55_0.auto:get("btnStop"), {
		methods = {
			ended = function()
				gGameApp:requestServer("/game/fishing/auto/end", var_55_3)
			end
		}
	})
end

function var_0_1.onShowRule(arg_67_0)
	local var_67_0 = arg_67_0:createHandler("getRuleContext")

	if arg_67_0.idx == game.FISHING_GAME then
		var_67_0 = arg_67_0:createHandler("getGameRuleContext")
	end

	gGameUI:stackUI("common.rule", nil, nil, var_67_0, {
		width = 1800
	})
end

function var_0_1.getRuleContext(arg_68_0, arg_68_1)
	local var_68_0 = adaptContext

	return {
		var_68_0.clone(arg_68_1.title, function(arg_69_0)
			arg_69_0:get("text"):text(gLanguageCsv.angling)
		end),
		var_68_0.noteText(93001, 94000)
	}
end

function var_0_1.getGameRuleContext(arg_70_0, arg_70_1)
	local var_70_0 = adaptContext

	return {
		var_70_0.clone(arg_70_1.title, function(arg_71_0)
			arg_71_0:get("text"):text(gLanguageCsv.FishingCompetition)
		end),
		var_70_0.noteText(94001, 95000)
	}
end

function var_0_1.initActivityTip(arg_72_0, arg_72_1)
	if arg_72_1 == nil or arg_72_1 == "closed" then
		arg_72_0.activityTip:hide()
		arg_72_0.activityTip:removeChildByName("gojt")

		return
	end

	widget.addAnimationByKey(arg_72_0.activityTip, "huodongtixing/huodongtixing.skel", "gojt", "effect_loop", 1):alignCenter(arg_72_0.activityTip:size())
	bind.touch(arg_72_0, arg_72_0.activityTip, {
		methods = {
			ended = function()
				gGameApp:requestServer("/game/fishing/main", function(arg_74_0)
					if arg_72_0.isAuto:read() == true then
						gGameUI:showTip(gLanguageCsv.switchSenceNeedStopAutoFishing)
					elseif arg_72_1 == "closed" then
						arg_72_0.activityTip:hide()
						arg_72_0.activityTip:removeChildByName("gojt")
						gGameUI:showDialog({
							fontSize = 50,
							clearFast = true,
							btnType = 1,
							strs = {
								"#C0x5B545B#" .. gLanguageCsv.theContestIsOver
							}
						})

						return
					else
						gGameApp:requestServer("/game/cross/fishing/rank", function(arg_75_0)
							arg_72_0:getParent().showTab:set(game.FISHING_GAME)
							var_0_0.onClose(arg_72_0)
							gGameApp:requestServer("/game/fishing/prepare", nil, "scene", game.FISHING_GAME)
							gGameUI:stackUI("city.adventure.fishing.view", nil, {
								full = true
							}, game.FISHING_GAME, arg_75_0.view)
						end)
					end
				end)
			end
		}
	})
	arg_72_0.activityTip:show()
end

function var_0_1.fishingGameTimer(arg_76_0)
	local var_76_0 = 82800
	local var_76_1 = time.getNowDate()
	local var_76_2 = var_76_0 - (var_76_1.hour * 3600 + var_76_1.min * 60 + var_76_1.sec) + 2

	arg_76_0:enableSchedule()
	arg_76_0:schedule(function()
		var_76_2 = var_76_2 - 1

		if var_76_2 <= 0 then
			arg_76_0.timer:hide()
		end

		arg_76_0.gameTimer:set(var_76_2)
	end, 1, 0, 8000)
end

function var_0_1.onitemClick(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	gGameUI:showItemDetail(arg_78_2, {
		key = "card",
		num = arg_78_4.val
	})
end

function var_0_1.onClose(arg_79_0)
	if arg_79_0.exitType == var_0_3.SHOWTIP then
		gGameUI:showDialog({
			fontSize = 50,
			clearFast = true,
			btnType = 2,
			isRich = true,
			strs = {
				"#C0x5B545B#" .. gLanguageCsv.stopFishingAndExit
			},
			cb = function()
				arg_79_0:addCallbackOnExit(arg_79_0.cb)
				var_0_0.onClose(arg_79_0)
			end
		})
	else
		arg_79_0:addCallbackOnExit(arg_79_0.cb)
		var_0_0.onClose(arg_79_0)
	end
end

return var_0_1
