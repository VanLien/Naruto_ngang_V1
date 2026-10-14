local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CloneBattleRoomView", var_0_0)
local var_0_2 = {
	binds = {
		event = "effect",
		data = {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.BLACK
			}
		}
	}
}

;({}).binds = {
	event = "effect",
	data = {
		outline = {
			color = ui.NEWCOLORS.OUTLINE.YELLOW
		}
	}
}
var_0_1.RESOURCE_FILENAME = "clone_battle_room.json"
var_0_1.RESOURCE_BINDING = {
	["leftPanel.textPanel"] = "textPanel",
	["leftPanel.spriteArea.item"] = "sprItem",
	["leftPanel.awardArea.item"] = "awardItem",
	["rightPanel.centerPanel.normalItem"] = "normalItem",
	["leftPanel.natureArea"] = "natureArea",
	["rightPanel.centerPanel.btnJoinItem"] = "btnJoinItem",
	["rightPanel.centerPanel"] = "centerPanel",
	["rightPanel.topPanel.list"] = "attrList",
	["rightPanel.topPanel.item"] = "attrItem",
	["rightPanel.topPanel.img"] = "topImg",
	["rightPanel.centerPanel.mainItem"] = "mainItem",
	["leftPanel.btnRule"] = {
		varname = "btnRule",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRule")
			}
		}
	},
	["leftPanel.btnRule.text"] = var_0_2,
	["leftPanel.btnRecord"] = {
		varname = "btnRecord",
		binds = {
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onRecord")
				}
			},
			{
				event = "extend",
				class = "red_hint",
				props = {
					specialTag = {
						"cloneBattleHistory"
					}
				}
			}
		}
	},
	["leftPanel.btnRecord.text"] = var_0_2,
	["leftPanel.spriteArea.text"] = var_0_2,
	["leftPanel.spriteArea.item.baseNode.maskOutBox.text"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLACK
					}
				}
			}
		}
	},
	["leftPanel.spriteArea.list"] = {
		varname = "sprList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("monstersData"),
				item = bindHelper.self("sprItem"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_3.cfg
					local var_1_1 = arg_1_1:get("baseNode")
					local var_1_2 = var_1_1:multiget("selected", "rarity", "bg", "text", "img", "maskLock", "maskOutBox")

					var_1_2.rarity:texture(ui.RARITY_ICON[var_1_0.rarity])
					var_1_2.text:text(var_1_0.name)
					text.addEffect(var_1_2.text, {
						outline = {
							color = ui.COLORS.OUTLINE.WHITE
						}
					})
					var_1_2.img:texture(var_1_0.cardIcon2)
					var_1_2.selected:visible(arg_1_3.selected)

					local var_1_3 = arg_1_3.selected and 1.1 or 1

					arg_1_1:scale(var_1_3, 1)
					var_1_1:scale(1, var_1_3)

					if not arg_1_3.selected then
						var_1_2.maskOutBox:visible(not arg_1_3.inBox)
						var_1_2.maskLock:visible(arg_1_3.inBox and arg_1_3.locked)

						if arg_1_3.inBox then
							bind.touch(arg_1_0, arg_1_1, {
								methods = {
									ended = functools.partial(arg_1_0.clickCell, arg_1_2, arg_1_3)
								}
							})
						end
					end
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTargetClick")
			}
		}
	},
	["leftPanel.awardArea.list"] = {
		varname = "awardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("awardData"),
				item = bindHelper.self("awardItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "icon_key",
						props = {
							data = arg_2_3
						}
					})
				end
			}
		}
	},
	["rightPanel.topPanel.attrText"] = {
		varname = "attrText",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.topPanel.text"] = {
		varname = "topText"
	},
	["rightPanel.bottomPanel.btnQuit"] = {
		varname = "btnQuit",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onQuitRoom")
			}
		}
	},
	["rightPanel.bottomPanel.btnRefresh"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRefresh")
			}
		}
	},
	["rightPanel.bottomPanel.btnKick"] = {
		varname = "btnKick",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onKick")
			}
		}
	},
	["rightPanel.bottomPanel.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChallange")
			}
		}
	},
	["rightPanel.bottomPanel.btnQuit.text"] = var_0_2,
	["rightPanel.bottomPanel.btnRefresh.text"] = var_0_2,
	["rightPanel.bottomPanel.btnRobot"] = {
		varname = "btnRobot",
		binds = {
			event = "click",
			method = bindHelper.self("onRobotEnable")
		}
	},
	["rightPanel.bottomPanel.btnRobot.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.topPanel.textNote"] = {
		varname = "timeNote",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.topPanel.textTime"] = {
		varname = "textCd",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.centerPanel.mainItem.btnWorldInvited.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightPanel.centerPanel.mainItem.btnUnionInvited.text"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLUE
				}
			}
		}
	}
}

local function var_0_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = 0

	local function var_3_1()
		if type(arg_3_1) == "string" then
			return arg_3_0[arg_3_1]
		else
			return arg_3_1
		end
	end

	local var_3_2 = var_3_1()
	local var_3_3 = ui.NEWCOLORS.OUTLINE.YELLOW

	text.deleteAllEffect(var_3_2:get("text"))

	if arg_3_1 == "btnUnionInvited" then
		var_3_3 = ui.NEWCOLORS.OUTLINE.BLUE
	end

	local var_3_4 = var_3_2:get("text"):text()
	local var_3_5 = var_3_2:name() .. var_3_2:tag()

	arg_3_0:enableSchedule():schedule(function(arg_5_0)
		if var_3_0 == 0 then
			cache.setShader(var_3_2, false, "hsl_gray")
			var_3_2:setTouchEnabled(false)
		end

		local var_5_0 = string.format(arg_3_2, math.floor(arg_3_3 - var_3_0))

		if var_3_2 ~= var_3_1() then
			var_3_2 = var_3_1()

			cache.setShader(var_3_2, false, "hsl_gray")
			var_3_2:setTouchEnabled(false)
		end

		var_3_2:get("text"):text(var_5_0)

		var_3_0 = var_3_0 + arg_5_0

		if var_3_0 > arg_3_3 then
			cache.setShader(var_3_2, false, "normal")
			var_3_2:get("text"):text(var_3_4)
			text.addEffect(var_3_2:get("text"), {
				outline = {
					color = var_3_3
				}
			})
			arg_3_0:unSchedule(var_3_5)
			var_3_2:setTouchEnabled(true)
		end
	end, 0.1, 0, var_3_5)
end

function var_0_1.onCreate(arg_6_0, arg_6_1)
	arg_6_0.cloneBattleWorningSee = userDefault.getForeverLocalKey("cloneBattleWorningSee", false)
	arg_6_0.baseView = arg_6_1
	arg_6_0.manberCount = 1

	gGameModel.forever_dispatch:getIdlerOrigin("cloneBattleLookHistory"):set(0)
	arg_6_0:initModel()

	local var_6_0 = rich.createByStr(gLanguageCsv.elementChallengeTips, 40):addTo(arg_6_0.textPanel, 10):anchorPoint(cc.p(0.5, 0.5))

	arg_6_0:initCountDown()
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.beasIdler = {
		natureId = gGameModel.clone_room:getIdler("nature_id"),
		roomLeader = gGameModel.clone_room:getIdler("leader"),
		roomId = gGameModel.clone_room:getIdler("id"),
		date = gGameModel.clone_room:getIdler("date"),
		finishNum = gGameModel.clone_room:getIdler("finish_num"),
		monsters = gGameModel.clone_room:getIdler("monsters"),
		places = gGameModel.clone_room:getIdler("places"),
		fast = gGameModel.clone_room:getIdler("fast"),
		discard = gGameModel.clone_room:getIdler("discard"),
		createTime = gGameModel.clone_room:getIdler("create_time"),
		voteRound = gGameModel.clone_room:getIdler("vote_round")
	}
	arg_7_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_7_0.monstersData = idlertable.new({})
	arg_7_0.monsterCur = idler.new(1)
	arg_7_0.awardData = idlertable.new({})

	idlereasy.when(arg_7_0.beasIdler.natureId, function(arg_8_0, arg_8_1)
		local var_8_0 = game.NATURE_TABLE[arg_8_1]
		local var_8_1 = gLanguageCsv[var_8_0] .. gLanguageCsv.natureRoom

		arg_7_0.topText:text(var_8_1)
		arg_7_0.topImg:texture(string.format("city/adventure/clone_battle/bg_yuansu_%s.png", var_8_0))

		local var_8_2 = arg_7_0.topText:size()

		arg_7_0.topImg:size(cc.size(var_8_2.width + 40, var_8_2.height + 13))
		adapt.oneLinePos(arg_7_0.topImg, {
			arg_7_0.timeNote,
			arg_7_0.textCd
		}, cc.p(5, 0), "left")

		local var_8_3 = arg_7_0.natureArea:size()
		local var_8_4 = csv.clone.nature[arg_8_1]
		local var_8_5 = var_8_4.spine

		widget.addAnimation(arg_7_0.natureArea, var_8_5, "effect2_" .. arg_8_1 .. "_loop", 1):scale(3):xy(var_8_3.width / 2, var_8_3.height / 2 + 40)
		arg_7_0:resetAttrList(var_8_4.recommendAttr)
	end)
	idlereasy.when(arg_7_0.beasIdler.roomLeader, function(arg_9_0, arg_9_1)
		arg_7_0.isLeader = arg_9_1 == gGameModel.role:read("id")
	end)
	idlereasy.any({
		arg_7_0.beasIdler.places,
		arg_7_0.beasIdler.voteRound,
		arg_7_0.beasIdler.fast
	}, function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = gGameModel.role:read("id")
		local var_10_1 = {}

		arg_7_0.battleCards = {}
		arg_7_0.manberCount = 0

		for iter_10_0 = 1, 5 do
			local var_10_2 = arg_7_0.centerPanel:get("pleace" .. iter_10_0)

			var_10_2:removeAllChildren()

			local var_10_3 = arg_10_1[iter_10_0]

			if var_10_3 then
				local var_10_4 = iter_10_0 == 1
				local var_10_5 = var_10_0 == var_10_3.id
				local var_10_6 = var_10_4 and arg_7_0.mainItem or arg_7_0.normalItem

				arg_7_0.manberCount = arg_7_0.manberCount + 1
				var_10_1[var_10_3.id] = true

				local var_10_7 = var_10_6:clone()

				arg_7_0:setItem(var_10_2, var_10_7, iter_10_0, var_10_3, var_10_5)
				var_10_7:get("selfCheck"):visible(var_10_5)

				if var_10_5 then
					arg_7_0:initSelfInfo(var_10_3)
				end

				if var_10_4 then
					arg_7_0.radioJoin = var_10_7:get("radioJoin")
					arg_7_0.btnUnionInvited = var_10_7:get("btnUnionInvited")
					arg_7_0.btnWorldInvited = var_10_7:get("btnWorldInvited")

					bind.touch(arg_7_0, arg_7_0.radioJoin, {
						methods = {
							ended = functools.partial(arg_7_0.onFastJoin, arg_7_0)
						}
					})
					bind.touch(arg_7_0, arg_7_0.btnWorldInvited, {
						methods = {
							ended = functools.partial(arg_7_0.onWorldInvite, arg_7_0, "btnWorldInvited")
						}
					})
					bind.touch(arg_7_0, arg_7_0.btnUnionInvited, {
						methods = {
							ended = functools.partial(arg_7_0.onUnionInvite, arg_7_0, "btnUnionInvited")
						}
					})

					if arg_10_2 == "start" and arg_7_0.isLeader then
						var_10_7:get("icon"):hide()
					else
						var_10_7:get("icon"):show()
					end
				end
			else
				local var_10_8 = arg_7_0.btnJoinItem:clone()
				local var_10_9 = var_10_2:size()

				var_10_8:show()
				var_10_8:addTo(var_10_2):xy(var_10_9.width / 2, var_10_9.height / 2)
				bind.touch(arg_7_0, var_10_8, {
					methods = {
						ended = functools.partial(arg_7_0.onPosItemClick, arg_7_0, var_10_8, data)
					}
				})
			end
		end

		arg_7_0:refreshTimeLabel()

		arg_7_0.roleIdInRoom = var_10_1

		arg_7_0.radioJoin:get("radio.img"):visible(not arg_10_3)
	end)
	idlereasy.when(arg_7_0.beasIdler.voteRound, function(arg_11_0, arg_11_1)
		if arg_7_0.isLeader then
			if arg_11_1 == "start" and arg_7_0.cloneBattleWorningSee == false then
				gGameUI:showDialog({
					btnType = 1,
					title = "",
					isRich = true,
					content = "#C0x5b545b#" .. gLanguageCsv.cloneBattleKickWorningTip
				})
				userDefault.setForeverLocalKey("cloneBattleWorningSee", true)
			elseif arg_11_1 ~= "start" then
				userDefault.setForeverLocalKey("cloneBattleWorningSee", false)
			end
		end
	end)
	idlereasy.any({
		arg_7_0.pokedex,
		arg_7_0.beasIdler.monsters,
		arg_7_0.monsterCur
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = {}

		for iter_12_0, iter_12_1 in pairs(arg_12_1) do
			var_12_0[csv.cards[iter_12_0].cardMarkID] = true
		end

		local var_12_1 = {}

		for iter_12_2, iter_12_3 in pairs(arg_12_2) do
			local var_12_2 = csv.clone.monster[iter_12_3].cardID
			local var_12_3 = csv.cards[var_12_2]
			local var_12_4 = var_12_3.unitID
			local var_12_5 = var_12_3.cardMarkID
			local var_12_6 = csv.unit[var_12_4] or csv.unit[1]

			var_12_1[iter_12_2] = {
				selected = false,
				unitId = var_12_4,
				cardId = var_12_2,
				inBox = var_12_0[var_12_5] and true or false,
				cfg = var_12_6,
				locked = arg_7_0.curMonsterLock
			}

			if arg_12_3 == iter_12_2 and var_12_0[var_12_5] then
				var_12_1[iter_12_2].selected = true
				arg_7_0.cardName = var_12_6.name
			elseif arg_12_3 == iter_12_2 then
				arg_12_3 = math.min(arg_12_3 + 1, #arg_12_2)
			end
		end

		arg_7_0.monsterCur:set(arg_12_3)
		arg_7_0.monstersData:set(var_12_1)
	end)
	idlereasy.when(arg_7_0.monsterCur, function(arg_13_0, arg_13_1)
		local var_13_0 = arg_7_0.beasIdler.monsters:read()[arg_13_1]
		local var_13_1 = dataEasy.getItemData(csv.clone.monster[var_13_0].extraAward) or {}

		arg_7_0.awardData:set(var_13_1)

		local var_13_2 = #var_13_1
		local var_13_3 = arg_7_0.awardItem:size()
		local var_13_4 = arg_7_0.awardList:size().width
		local var_13_5 = var_13_2 * var_13_3.width + (var_13_2 - 1) * 20

		arg_7_0.awardList:size(var_13_5, var_13_3.height)
		arg_7_0.awardList:x(arg_7_0.awardList:x() - (var_13_5 - var_13_4) / 2)
	end)
	idlereasy.any({
		arg_7_0.beasIdler.places,
		arg_7_0.beasIdler.voteRound
	}, function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = gGameModel.role:read("id")
		local var_14_1 = 0

		for iter_14_0, iter_14_1 in pairs(arg_14_1) do
			if iter_14_1.id == var_14_0 then
				var_14_1 = iter_14_1.play
			end
		end

		if arg_14_2 == "start" and var_14_1 >= 3 then
			arg_7_0.btnKick:show()
		else
			arg_7_0.btnKick:hide()
		end
	end)

	local var_7_0 = "Time_Robot_Schedule"

	arg_7_0:enableSchedule():schedule(function(arg_15_0)
		if arg_7_0:refreshTimeLabel() then
			arg_7_0:enableSchedule():unSchedule(var_7_0)
		end
	end, 1, nil, var_7_0)
end

function var_0_1.refreshTimeLabel(arg_16_0)
	local var_16_0 = arg_16_0.beasIdler.createTime:read()
	local var_16_1 = time.getTime()
	local var_16_2 = var_16_1 - var_16_0
	local var_16_3 = time.getNumTimestamp(time.getTodayStrInClock(), 12, 0) - var_16_1

	if var_16_3 < 0 then
		var_16_3 = var_16_3 + 86400
	end

	local var_16_4 = var_16_2 >= gCommonConfigCsv.cloneRobotTime * 60
	local var_16_5 = var_16_3 <= gCommonConfigCsv.cloneRobotRefreshTime * 60
	local var_16_6 = arg_16_0.manberCount >= 5
	local var_16_7 = var_16_4 or var_16_5

	arg_16_0.btnRobot:visible(var_16_7 and not var_16_6)
	gGameModel.forever_dispatch:getIdlerOrigin("cloneBattleLookRobot"):set(var_16_7 or var_16_6)

	return var_16_7
end

function var_0_1.setItem(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = arg_17_1:size()

	arg_17_2:addTo(arg_17_1):xy(var_17_0.width / 2, var_17_0.height / 2)
	arg_17_2:show()
	arg_17_2:get("name"):text(arg_17_4.name)

	if arg_17_4.monster == -1 then
		arg_17_2:get("playPanel.ready"):show()
		arg_17_2:get("playPanel.fighting"):hide()
	elseif arg_17_4.play >= 3 then
		arg_17_2:get("playPanel.complete"):show()
	else
		arg_17_2:get("playPanel.fighting"):show()
		arg_17_2:get("playPanel.ready"):hide()
		arg_17_2:get("playPanel.fighting.text"):text(string.format(gLanguageCsv.challengeTime, arg_17_4.play, 3))
		adapt.setTextScaleWithWidth(arg_17_2:get("playPanel.fighting.text"), nil, 290)
	end

	local var_17_1 = arg_17_4.card
	local var_17_2 = arg_17_4.time
	local var_17_3 = arg_17_4.play
	local var_17_4 = csv.cards[var_17_1.card_id]
	local var_17_5 = csv.unit[var_17_4.unitID]
	local var_17_6 = dataEasy.getUnitId(var_17_1.card_id, var_17_1.skin_id)

	bind.extend(arg_17_0, arg_17_2:get("sprImg"), {
		class = "card_icon",
		props = {
			unitId = var_17_6,
			star = var_17_1.star,
			rarity = var_17_5.rarity,
			onNodeClick = function(arg_18_0)
				arg_17_0:onSpriteClick(arg_17_2, arg_17_4, arg_17_5, arg_17_3)
			end,
			onNode = function(arg_19_0)
				arg_19_0:anchorPoint(0.5, 0.5)
				arg_19_0:xy(arg_17_2:get("sprImg"):width() / 2, arg_17_2:get("sprImg"):height() / 2)
			end
		}
	})

	local var_17_7 = arg_17_2:get("text1")
	local var_17_8 = arg_17_2:get("text2")

	var_17_8:text(var_17_1.fighting_point)

	local var_17_9, var_17_10 = var_17_7:xy()
	local var_17_11, var_17_12 = var_17_8:xy()
	local var_17_13 = cc.p(var_17_0.width / 2, (var_17_10 + var_17_12) / 2)

	adapt.oneLineCenterPos(var_17_13, {
		var_17_7,
		var_17_8
	}, cc.p(10, 0))

	arg_17_0.battleCards[var_17_1.id] = var_17_1
end

function var_0_1.initSelfInfo(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.play < 3

	cache.setShader(arg_20_0.btnChallenge, false, var_20_0 and "normal" or "hsl_gray")
	arg_20_0.btnChallenge:setTouchEnabled(var_20_0)
	arg_20_0.btnChallenge:get("text"):text(var_20_0 and gLanguageCsv.startChallenge or gLanguageCsv.complete)

	if var_20_0 then
		text.addEffect(arg_20_0.btnChallenge:get("text"), {
			outline = {
				color = ui.NEWCOLORS.OUTLINE.YELLOW
			}
		})
	else
		text.deleteAllEffect(arg_20_0.btnChallenge:get("text"))
	end

	adapt.setTextScaleWithWidth(arg_20_0.btnChallenge:get("text"), nil, 280)

	if arg_20_1.monster ~= -1 then
		local var_20_1 = arg_20_0.beasIdler.monsters:read()

		for iter_20_0, iter_20_1 in pairs(var_20_1) do
			if iter_20_1 == arg_20_1.monster then
				arg_20_0.monsterCur:set(iter_20_0)

				break
			end
		end

		arg_20_0.btnQuit:visible(false)

		arg_20_0.curMonsterLock = true
	end

	arg_20_0.canBattle = var_20_0
	arg_20_0.monster = arg_20_1.monster
	arg_20_0.curCardId = arg_20_1.card.id
	arg_20_0.battle_deploy = {}

	for iter_20_2, iter_20_3 in pairs(arg_20_1.battle_deploy or {}) do
		arg_20_0.battle_deploy[iter_20_3] = iter_20_2
	end

	arg_20_0.need_robot = arg_20_1.need_robot

	arg_20_0.btnRobot:get("img"):visible(arg_20_1.need_robot == true)
end

function var_0_1.onQuitRoom(arg_21_0)
	gGameApp:requestServer("/game/clone/room/quit", function(arg_22_0)
		arg_21_0.baseView:refreshView(arg_22_0.view)
	end)
end

function var_0_1.onRefresh(arg_23_0)
	arg_23_0.baseView:refresh()
end

function var_0_1.onChallange(arg_24_0)
	local function var_24_0()
		local var_25_0 = {}
		local var_25_1 = {}
		local var_25_2 = clone(arg_24_0.battleCards)

		for iter_25_0, iter_25_1 in pairs(arg_24_0.battle_deploy) do
			local var_25_3 = var_25_2[iter_25_0]

			if var_25_3 then
				var_25_0[iter_25_1] = iter_25_0
				var_25_1[var_25_3.id] = var_25_3
				var_25_2[iter_25_0] = nil
			end
		end

		local function var_25_4(arg_26_0)
			for iter_26_0 = 1, 6 do
				if not var_25_0[iter_26_0] then
					local var_26_0, var_26_1 = next(arg_26_0)

					if var_26_0 and var_26_1 then
						var_25_0[iter_26_0] = var_26_0
						var_25_1[var_26_1.id] = var_26_1
						arg_26_0[var_26_0] = nil
					end
				end
			end
		end

		arg_24_0:sendServerRequest("/game/clone/battle/deploy/enter", nil, function(arg_27_0)
			local var_27_0 = clone(arg_27_0.robots)

			var_25_4(var_25_2)
			var_25_4(var_27_0)
			gGameUI:stackUI("city.card.embattle.clone_battle", nil, {
				full = true
			}, {
				fightCb = arg_24_0:createHandler("startFighting"),
				inputCards = idlertable.new(var_25_0),
				inputCardAttrs = idlertable.new(var_25_1)
			})
		end)
	end

	if not arg_24_0.curMonsterLock then
		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			strs = string.format(gLanguageCsv.cloneBattleFightTip, arg_24_0.cardName),
			cb = function()
				var_24_0()
			end
		})
	else
		var_24_0()
	end
end

function var_0_1.startFighting(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0.beasIdler.monsters:read()[arg_29_0.monsterCur:read()]
	local var_29_1 = arg_29_2:read() or {}

	if not arg_29_2 then
		for iter_29_0 = 1, 6 do
			var_29_1[iter_29_0] = arg_29_0.battleCards[iter_29_0] and arg_29_0.battleCards[iter_29_0].id or ""
		end
	end

	arg_29_0:disableSchedule()
	battleEntrance.battleRequest("/game/clone/battle/start", var_29_0, var_29_1):onStartOK(function(arg_30_0)
		if arg_29_1 then
			arg_29_1:onClose(false)

			arg_29_1 = nil
		end
	end):onRequestCustom(function(arg_31_0)
		arg_31_0:onErrClose(function()
			if arg_29_1 then
				arg_29_1:onClose()

				arg_29_1 = nil
			end

			arg_29_0:onRefresh()
		end)
	end):show()
end

function var_0_1.resetAttrList(arg_33_0, arg_33_1)
	arg_33_0.attrList:removeAllChildren()

	local var_33_0 = csvSize(arg_33_1)
	local var_33_1 = arg_33_0.attrItem:size().width
	local var_33_2 = arg_33_0.attrItem:size().height

	for iter_33_0, iter_33_1 in orderCsvPairs(arg_33_1) do
		local var_33_3 = arg_33_0.attrItem:clone()

		var_33_3:get("img"):texture(ui.ATTR_ICON[iter_33_1])
		arg_33_0.attrList:insertCustomItem(var_33_3, 0)
	end

	arg_33_0.attrList:size(cc.size(var_33_1 * var_33_0, var_33_2))
	adapt.oneLinePos(arg_33_0.attrList, arg_33_0.attrText, cc.p(10, 0), "right")
end

function var_0_1.onFastJoin(arg_34_0)
	if not arg_34_0.isLeader then
		gGameUI:showTip(gLanguageCsv.isNotLeader)

		return
	end

	local var_34_0 = arg_34_0.beasIdler.fast:read()

	arg_34_0:sendServerRequest("/game/clone/room/join/fast/enable", nil, function(arg_35_0)
		return
	end, not var_34_0)
end

function var_0_1.onWorldInvite(arg_36_0, arg_36_1)
	if not arg_36_0.isLeader then
		gGameUI:showTip(gLanguageCsv.isNotLeader)

		return
	end

	arg_36_0:sendServerRequest("/game/clone/invite", nil, function(arg_37_0)
		var_0_3(arg_36_0, arg_36_1, "(%s S)", 30)
	end, "world")
end

function var_0_1.onUnionInvite(arg_38_0, arg_38_1)
	if not arg_38_0.isLeader then
		gGameUI:showTip(gLanguageCsv.isNotLeader)

		return
	end

	arg_38_0:sendServerRequest("/game/clone/invite", nil, function(arg_39_0)
		var_0_3(arg_38_0, arg_38_1, "(%s S)", 30)
	end, "union")
end

function var_0_1.onPosItemClick(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.isLeader then
		gGameUI:showTip(gLanguageCsv.isNotLeader)

		return
	end

	arg_40_0:sendServerRequest("/game/clone/friend/online/list", nil, function(arg_41_0)
		local var_41_0 = clone(arg_41_0.view.roles)
		local var_41_1 = arg_41_0.view.size

		for iter_41_0 = 1, var_41_1 do
			local var_41_2 = var_41_0[iter_41_0]

			if arg_40_0.roleIdInRoom[var_41_2.id] then
				var_41_0[iter_41_0] = nil
				var_41_1 = var_41_1 - 1
			end
		end

		gGameUI:stackUI("city.adventure.clone_battle.invite", nil, nil, {
			roles = var_41_0,
			size = var_41_1
		}, arg_40_0:createHandler("inviteFunc"))
	end)
end

function var_0_1.inviteFunc(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = {
		id = arg_42_1.id,
		level = arg_42_1.level,
		logo = arg_42_1.logo,
		name = arg_42_1.name,
		vip = arg_42_1.vip_level,
		frame = arg_42_1.frame
	}

	arg_42_0:sendServerRequest("/game/clone/invite", function()
		if arg_42_2 then
			arg_42_2:onCloseFast()
		end

		arg_42_0:onRefresh()
	end, function(arg_44_0)
		var_0_3(arg_42_2, arg_42_3, "(%s S)", 30)
	end, "friend", var_42_0)
end

function var_0_1.onRobotEnable(arg_45_0)
	local var_45_0 = not arg_45_0.need_robot

	arg_45_0:sendServerRequest("/game/clone/room/robot/enable", nil, function(arg_46_0)
		if var_45_0 then
			gGameUI:showTip(gLanguageCsv.cloneRobotTextOn)
		else
			gGameUI:showTip(gLanguageCsv.cloneRobotTextOff)
		end
	end, var_45_0)
end

function var_0_1.onSpriteClick(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	if arg_47_3 then
		gGameUI:createView("city.adventure.clone_battle.choose", arg_47_0):init(arg_47_0.curCardId)

		return
	end

	local var_47_0, var_47_1 = arg_47_1:xy()
	local var_47_2 = arg_47_1:getParent():convertToWorldSpace(cc.p(var_47_0, var_47_1))

	var_47_2.x = var_47_2.x - 1000

	local var_47_3 = 0

	if arg_47_4 == 1 or arg_47_0.isLeader then
		var_47_3 = arg_47_4
	end

	gGameUI:stackUI("city.chat.personal_info", nil, nil, var_47_2, {
		role = arg_47_2
	}, {
		isKickNum = var_47_3,
		isLeader = arg_47_0.isLeader
	})
end

function var_0_1.onTargetClick(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if arg_48_0.curMonsterLock then
		gGameUI:showTip(gLanguageCsv.cloneMonsterCannotChoose)

		return
	end

	if arg_48_0.monsterCur:read() ~= arg_48_2 and arg_48_3.inBox then
		arg_48_0.monsterCur:set(arg_48_2)
	end
end

function var_0_1.onRule(arg_49_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_49_0:createHandler("getRuleContext"))
end

function var_0_1.getRuleContext(arg_50_0, arg_50_1)
	local var_50_0 = adaptContext
	local var_50_1 = {
		var_50_0.clone(arg_50_1.title, function(arg_51_0)
			arg_51_0:get("text"):text(gLanguageCsv.cloneBattleRuleTitle)
		end),
		var_50_0.noteText(111),
		var_50_0.noteText(62001, 62010)
	}

	if dataEasy.isUnlock(gUnlockCsv.cloneBattleKick) then
		table.insert(var_50_1, var_50_0.noteText(150))
		table.insert(var_50_1, var_50_0.noteText(105001, 105010))
	end

	return var_50_1
end

function var_0_1.sendServerRequest(arg_52_0, arg_52_1, arg_52_2, arg_52_3, ...)
	gGameApp:requestServerCustom(arg_52_1):onErrClose(arg_52_2 or function()
		arg_52_0:onRefresh()
	end):params(...):doit(arg_52_3)
end

function var_0_1.onRecord(arg_54_0)
	local var_54_0 = gGameModel.clone_room:read("history") or {}
	local var_54_1 = {}

	for iter_54_0, iter_54_1 in ipairs(var_54_0) do
		table.insert(var_54_1, {
			time = iter_54_1.time,
			name = iter_54_1.name,
			type = iter_54_1.type % 7 == 0 and 7 or iter_54_1.type % 7
		})
	end

	gGameUI:stackUI("city.adventure.clone_battle.history", nil, nil, {
		historyTab = var_54_1,
		refreshNumber = arg_54_0.refreshNumber
	})
end

function var_0_1.initCountDown(arg_55_0)
	local var_55_0 = arg_55_0.textCd
	local var_55_1 = time.getTodayStrInClock(12)
	local var_55_2 = time.getNumTimestamp(var_55_1, 12) + 86400

	local function var_55_3()
		local var_56_0 = time.getCutDown(var_55_2 - time.getTime())

		var_55_0:text(var_56_0.str)
		adapt.oneLinePos(arg_55_0.timeNote, var_55_0, cc.p(5, 0))

		if var_55_2 - time.getTime() <= 0 then
			arg_55_0.baseView:refresh()

			var_55_1 = time.getTodayStrInClock(12)
		end

		return true
	end

	arg_55_0:enableSchedule()
	arg_55_0:schedule(function(arg_57_0)
		if not var_55_3() then
			return false
		end
	end, 1, 0, 1)
end

function var_0_1.onKick(arg_58_0)
	gGameUI:stackUI("city.adventure.clone_battle.vote", nil, {
		clickClose = true
	})
end

return var_0_1
