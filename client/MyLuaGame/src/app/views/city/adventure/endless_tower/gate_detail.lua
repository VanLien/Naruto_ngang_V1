local var_0_0 = {
	{
		typ = 1,
		note = gLanguageCsv.elementAttributeRestrictionCanBattle
	},
	{
		typ = 1,
		note = gLanguageCsv.elementAttributeRestrictionNotBattle
	},
	{
		typ = 2,
		note = gLanguageCsv.attributeCorrection,
		txt1 = gLanguageCsv.weSpirit,
		parameter = {
			[0] = gLanguageCsv.increase,
			gLanguageCsv.reduce
		}
	},
	{
		typ = 2,
		note = gLanguageCsv.attributeCorrection,
		txt1 = gLanguageCsv.enemySpirit,
		parameter = {
			[0] = gLanguageCsv.increase,
			gLanguageCsv.reduce
		}
	},
	{
		typ = 2,
		note = gLanguageCsv.attributeCorrection,
		txt1 = gLanguageCsv.bothSpirit,
		parameter = {
			[0] = gLanguageCsv.increase,
			gLanguageCsv.reduce
		}
	},
	{
		typ = 3,
		note = gLanguageCsv.limitPlayingCards,
		txt1 = gLanguageCsv.forceIntoBattle,
		txt2 = gLanguageCsv.someSpriteSomeNum
	}
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	return ccui.ImageView:create(arg_1_0):anchorPoint(0, 0.5):xy(arg_1_1, arg_1_2):scale(arg_1_3):addTo(arg_1_4, 6)
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return rich.createByStr(arg_2_0, 40):anchorPoint(0, 0.5):xy(arg_2_1, arg_2_2):addTo(arg_2_3, 6)
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_0[arg_3_0.limitType]

	arg_3_1:text(var_3_0.note)

	local var_3_1 = arg_3_1:size()
	local var_3_2 = var_3_1.width + 22
	local var_3_3 = var_3_1.height / 2

	if var_3_0.typ == 1 then
		for iter_3_0, iter_3_1 in orderCsvPairs(arg_3_0.limitArg) do
			var_3_2 = var_3_2 + var_0_1(ui.ATTR_ICON[iter_3_1], var_3_2, var_3_3, 0.63, arg_3_1):size().width * 0.63 + 20
		end
	elseif var_3_0.typ == 2 then
		local var_3_4 = var_0_2(arg_3_2 .. var_3_0.txt1, var_3_2, var_3_3, arg_3_1)

		var_3_4:formatText()

		var_3_2 = var_3_2 + var_3_4:size().width

		for iter_3_2, iter_3_3 in csvPairs(arg_3_0.limitArg) do
			local var_3_5 = iter_3_3[2] == 0 and "#C0x60C456#" or "#C0xF76B45#"
			local var_3_6 = iter_3_3[2] == 0 and "common/icon/logo_arrow_green.png" or "common/icon/logo_arrow_red.png"
			local var_3_7 = arg_3_2 .. getLanguageAttr(iter_3_3[1]) .. var_3_0.parameter[iter_3_3[2]] .. " " .. var_3_5 .. dataEasy.getAttrValueString(iter_3_3[1], iter_3_3[3])
			local var_3_8 = var_0_2(var_3_7, var_3_2, var_3_3, arg_3_1)

			var_3_8:formatText()

			var_3_2 = var_3_2 + var_3_8:size().width
			var_3_2 = var_3_2 + var_0_1(var_3_6, var_3_2, var_3_3, 1, arg_3_1):size().width + 10
		end
	else
		local var_3_9 = var_0_2(arg_3_2 .. var_3_0.txt1, var_3_2, var_3_3, arg_3_1)

		var_3_9:formatText()

		local var_3_10 = var_3_2 + var_3_9:size().width + 5

		for iter_3_4, iter_3_5 in csvPairs(arg_3_0.limitArg) do
			var_3_10 = var_3_10 + var_0_1(ui.RARITY_ICON[iter_3_5[1]], var_3_10, var_3_3, 0.7, arg_3_1):size().width * 0.7 + 5

			local var_3_11 = (arg_3_2 .. string.format(var_3_0.txt2, "", iter_3_5[2])) .. (iter_3_4 < itertools.size(arg_3_0.limitArg) and gLanguageCsv.symbolDot or gLanguageCsv.symbolPeriod)
			local var_3_12 = var_0_2(var_3_11, var_3_10, var_3_3, arg_3_1)

			var_3_12:formatText()

			var_3_10 = var_3_10 + var_3_12:size().width
		end
	end
end

local var_0_4 = cc.load("mvc").ViewBase
local var_0_5 = class("EndlessTowerGateDetail", Dialog)

var_0_5.RESOURCE_FILENAME = "endless_tower_gate_detail.json"
var_0_5.RESOURCE_BINDING = {
	conditionNote = "conditionNote",
	rewardImg = "rewardImg",
	["skipBtn.skipNote"] = "skipNote",
	sureBtn = "sureBtn",
	item = "item",
	battleBtn = "battleBtn",
	rewardNote = "rewardNote",
	gateText = "gateText",
	sweepBtn = "sweepBtn",
	btnClose = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	title1 = {
		varname = "title1",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title2 = {
		varname = "title2",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	title3 = {
		varname = "title3",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	enemyList = {
		varname = "enemyList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				padding = 10,
				data = bindHelper.self("combatDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					arg_4_1:get("icon"):hide()
					bind.extend(arg_4_0, arg_4_1, {
						class = "card_icon",
						props = {
							showAttribute = true,
							unitId = arg_4_3.id,
							advance = arg_4_3.advance,
							levelProps = {
								data = arg_4_3.level
							},
							isBoss = arg_4_3.isBoss,
							rarity = arg_4_3.rarity,
							onNode = function(arg_5_0)
								local var_5_0, var_5_1 = arg_5_0:xy()

								arg_4_1:scale(arg_4_3.isBoss and 1 or 0.9)
							end
						}
					})
				end
			}
		}
	},
	rewardList = {
		varname = "rewardList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				padding = 10,
				data = bindHelper.self("rewardDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:get("icon"):visible(arg_6_3.showIcon == 1)

					local var_6_0 = arg_6_1:size()
					local var_6_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_6_3.key,
								num = arg_6_3.num
							},
							onNode = function(arg_7_0)
								arg_7_0:xy(var_6_0.width / 2 - 14, var_6_0.height / 2)
							end
						}
					}

					bind.extend(arg_6_0, arg_6_1, var_6_1)
				end
			}
		}
	},
	["sweepBtn.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSweepClick")
			}
		}
	},
	["sweepBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.BLUE
				}
			}
		}
	},
	skipBtn = {
		varname = "selectSkip",
		binds = {
			event = "click",
			method = bindHelper.self("onSkipClick")
		}
	},
	["battleBtn.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBattleClick")
			}
		}
	},
	["battleBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["videoBtn.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onVideoClick")
			}
		}
	},
	["sureBtn.btn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["sureBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	}
}

function var_0_5.onCreate(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0.gateId = arg_8_2 or 100000 + arg_8_1
	arg_8_0.handler = arg_8_3
	arg_8_0.idx = arg_8_1

	arg_8_0:initModel()
	arg_8_0.title2:text(arg_8_1)
	adapt.oneLinePos(arg_8_0.title1, {
		arg_8_0.title2,
		arg_8_0.title3
	}, cc.p(5, 0))

	local var_8_0 = csv.endless_tower_scene[arg_8_0.gateId]

	var_0_3(var_8_0, arg_8_0.conditionNote, "#C0x57472E#")
	arg_8_0.gateText:text(var_8_0.gateDesc)

	local function var_8_1(arg_9_0, arg_9_1)
		local var_9_0 = {}

		for iter_9_0, iter_9_1 in ipairs(arg_9_0) do
			local var_9_1 = csv.unit[iter_9_1.unitId]

			table.insert(var_9_0, {
				id = iter_9_1.unitId,
				level = iter_9_1.level,
				advance = iter_9_1.advance,
				rarity = var_9_1.rarity,
				isBoss = arg_9_1
			})
		end

		table.sort(var_9_0, function(arg_10_0, arg_10_1)
			return arg_10_0.advance > arg_10_1.advance
		end)

		return var_9_0
	end

	local var_8_2 = var_8_1(var_8_0.boss, true)
	local var_8_3 = var_8_1(var_8_0.monsters, false)

	arg_8_0.combatDatas = arraytools.merge({
		var_8_2,
		var_8_3
	})
	arg_8_0.rewardDatas = idlertable.new()

	idlereasy.any({
		arg_8_0.maxGateId,
		arg_8_0.curChallengeId
	}, function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_11_1 < arg_8_0.gateId

		arg_8_0.isFirst = var_11_0

		local var_11_1 = var_11_0 and gLanguageCsv.firstPassAward or gLanguageCsv.sweepingReward

		arg_8_0.rewardImg:visible(var_11_0)
		arg_8_0.rewardNote:text(var_11_1)

		local var_11_2 = arg_11_2 == arg_8_0.gateId and not var_11_0
		local var_11_3 = var_11_0 or var_11_2

		arg_8_0.skipNote:visible(var_11_3)
		arg_8_0.selectSkip:visible(var_11_3)
		arg_8_0.battleBtn:visible(var_11_3)
		arg_8_0.sweepBtn:visible(var_11_2)
		arg_8_0.sureBtn:visible(not var_11_3)

		local var_11_4 = var_11_0 and "st" or "gl"

		arg_8_0.item:get("icon"):texture(string.format("city/adventure/endless_tower/icon_%s.png", var_11_4))

		local var_11_5 = var_11_0 and var_8_0.firstAwardShow or var_8_0.saodangAwardShow
		local var_11_6 = {}

		for iter_11_0, iter_11_1 in csvPairs(var_11_5) do
			table.insert(var_11_6, {
				key = iter_11_1[1],
				num = iter_11_1[2],
				showIcon = iter_11_1[3]
			})
		end

		table.sort(var_11_6, function(arg_12_0, arg_12_1)
			if arg_12_0.showIcon ~= arg_12_1.showIcon then
				return arg_12_0.showIcon > arg_12_1.showIcon
			end

			return dataEasy.sortItemCmp(arg_12_0, arg_12_1)
		end)
		arg_8_0.rewardDatas:set(var_11_6)
	end)

	local var_8_4 = userDefault.getForeverLocalKey("endlessTowerSkipBattle", false)

	arg_8_0.selectSkip:get("skipBtn"):setSelectedState(var_8_4)
	Dialog.onCreate(arg_8_0)
end

function var_0_5.initModel(arg_13_0)
	arg_13_0.cards = gGameModel.role:getIdler("cards")
	arg_13_0.roleLv = gGameModel.role:getIdler("level")
	arg_13_0.maxGateId = gGameModel.role:getIdler("endless_tower_max_gate")
	arg_13_0.curChallengeId = gGameModel.role:getIdler("endless_tower_current")
	arg_13_0.battleCards = idlertable.new({})

	local var_13_0 = csv.endless_tower_scene[arg_13_0.gateId]
	local var_13_1 = var_13_0.limitType
	local var_13_2 = var_13_0.limitArg

	idlereasy.when(gGameModel.role:getIdler("huodong_cards"), function(arg_14_0, arg_14_1)
		arg_13_0.isChangeBattleCards = false

		local var_14_0 = arg_14_1[game.EMBATTLE_HOUDONG_ID.endlessTower] or table.deepcopy(gGameModel.role:read("battle_cards"), true)
		local var_14_1 = itertools.map(var_13_2 or {}, function(arg_15_0, arg_15_1)
			return arg_15_1, 1
		end)
		local var_14_2 = {}

		for iter_14_0, iter_14_1 in pairs(var_14_0) do
			local var_14_3 = gGameModel.cards:find(iter_14_1):read("card_id")
			local var_14_4 = csv.cards[var_14_3]
			local var_14_5 = csv.unit[var_14_4.unitID]

			if not var_13_1 or var_13_1 > 2 and var_13_1 < 7 or var_13_1 == 1 and (var_14_1[var_14_5.natureType] or var_14_1[var_14_5.natureType2]) or var_13_1 == 2 and not var_14_1[var_14_5.natureType] and not var_14_1[var_14_5.natureType2] then
				var_14_2[iter_14_0] = iter_14_1
			elseif iter_14_1 then
				arg_13_0.isChangeBattleCards = true
			end
		end

		arg_13_0.battleCards:set(var_14_2)
	end)

	arg_13_0.rarityDatas = {}
	arg_13_0.allCardCount = 0

	idlereasy.when(arg_13_0.cards, function(arg_16_0, arg_16_1)
		local var_16_0 = itertools.map(var_13_2 or {}, function(arg_17_0, arg_17_1)
			return arg_17_1, 1
		end)
		local var_16_1 = {}
		local var_16_2 = -1

		for iter_16_0, iter_16_1 in ipairs(arg_16_1) do
			local var_16_3 = gGameModel.cards:find(iter_16_1):read("card_id", "fighting_point", "level", "star", "advance", "created_time")
			local var_16_4 = csv.cards[var_16_3.card_id]
			local var_16_5 = csv.unit[var_16_4.unitID]

			if not var_13_1 or var_13_1 > 2 and var_13_1 < 7 or var_13_1 == 1 and (var_16_0[var_16_5.natureType] or var_16_0[var_16_5.natureType2]) or var_13_1 == 2 and not var_16_0[var_16_5.natureType] and not var_16_0[var_16_5.natureType2] then
				if var_16_2 < var_16_3.fighting_point then
					var_16_2 = var_16_3.fighting_point
					arg_13_0.maxFightPointDbId = iter_16_1
				end

				arg_13_0.allCardCount = arg_13_0.allCardCount + 1
			end

			local var_16_6 = var_16_5.rarity

			if not arg_13_0.rarityDatas[var_16_6] then
				arg_13_0.rarityDatas[var_16_6] = 0
			end

			arg_13_0.rarityDatas[var_16_6] = arg_13_0.rarityDatas[var_16_6] + 1
		end
	end)
end

function var_0_5.onSweepClick(arg_18_0)
	local var_18_0 = gGameModel.capture:read("limit_sprites")

	gGameApp:requestServer("/game/endless/saodang", function(arg_19_0)
		local var_19_0 = {}

		for iter_19_0, iter_19_1 in ipairs(arg_19_0.view.result) do
			local var_19_1 = {
				items = {}
			}

			for iter_19_2, iter_19_3 in pairs(iter_19_1) do
				if iter_19_2 ~= "gold" then
					var_19_1.items[iter_19_2] = iter_19_3
				else
					var_19_1.gold = iter_19_3
				end
			end

			table.insert(var_19_0, var_19_1)
		end

		gGameUI:stackUI("city.gate.sweep", nil, nil, {
			showType = 2,
			from = "endlessTower",
			hasExtra = false,
			sweepData = var_19_0,
			oldRoleLv = arg_18_0.roleLv:read(),
			startGateId = arg_18_0.gateId,
			oldCapture = var_18_0,
			isDouble = dataEasy.isGateIdDoubleDrop(arg_18_0.gateId)
		})

		if arg_18_0.handler then
			arg_18_0.handler(arg_18_0.idx, true)
		end
	end, arg_18_0.gateId)
end

function var_0_5.onSkipClick(arg_20_0)
	local var_20_0 = userDefault.getForeverLocalKey("endlessTowerSkipBattle", false)

	arg_20_0.selectSkip:get("skipBtn"):setSelectedState(not var_20_0)
	userDefault.setForeverLocalKey("endlessTowerSkipBattle", not var_20_0)
end

function var_0_5.onBattleClick(arg_21_0)
	local var_21_0 = csv.endless_tower_scene[arg_21_0.gateId]
	local var_21_1 = var_21_0.limitType
	local var_21_2 = var_21_0.limitArg

	if var_21_1 == 6 then
		for iter_21_0, iter_21_1 in csvPairs(var_21_2) do
			if (arg_21_0.rarityDatas[iter_21_1[1]] or 0) < iter_21_1[2] then
				gGameUI:showTip(gLanguageCsv.notHasRole)

				return
			end
		end
	end

	if arg_21_0.allCardCount < 1 and arg_21_0.battleCards:size() < 1 then
		gGameUI:showTip(gLanguageCsv.notHasRole)

		return
	end

	if userDefault.getForeverLocalKey("endlessTowerSkipBattle", false) and arg_21_0:correctEnbattle() and not arg_21_0.isChangeBattleCards then
		arg_21_0:startFighting()

		return
	end

	local var_21_3 = {
		[var_21_1] = var_21_2
	}

	gGameUI:stackUI("city.card.embattle.endless", nil, {
		full = true
	}, {
		from = "huodong",
		team = true,
		fromId = game.EMBATTLE_HOUDONG_ID.endlessTower,
		limitInfo = var_21_3,
		startCb = arg_21_0:createHandler("showTip"),
		fightCb = arg_21_0:createHandler("startFighting"),
		checkBattleArr = arg_21_0:createHandler("correctEnbattle")
	})
end

function var_0_5.showTip(arg_22_0, arg_22_1)
	if userDefault.getForeverLocalKey("endlessTowerSkipBattle", false) and not arg_22_0:correctEnbattle() then
		gGameUI:showTip(gLanguageCsv.lineupInconsistency)
	end

	if arg_22_0.allCardCount > 0 and arg_22_0.battleCards:size() < 1 then
		arg_22_0.battleCards:proxy()[1] = arg_22_0.maxFightPointDbId
	end

	local var_22_0 = csv.endless_tower_scene[arg_22_0.gateId]

	var_0_3(var_22_0, arg_22_1.textLimit, "#C0xFFFFFF#")

	return table.deepcopy(arg_22_0.battleCards:proxy(), true)
end

function var_0_5.correctEnbattle(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or arg_23_0.battleCards:read()

	local var_23_0 = csv.endless_tower_scene[arg_23_0.gateId]
	local var_23_1 = var_0_0[var_23_0.limitType]

	if var_23_1.typ == 1 then
		for iter_23_0, iter_23_1 in pairs(arg_23_1) do
			local var_23_2 = gGameModel.cards:find(iter_23_1):read("card_id")
			local var_23_3 = csv.cards[var_23_2]
			local var_23_4 = csv.unit[var_23_3.unitID]
			local var_23_5 = var_23_4.natureType
			local var_23_6 = var_23_4.natureType2
			local var_23_7 = itertools.map(var_23_0.limitArg, function(arg_24_0, arg_24_1)
				return arg_24_1, arg_24_0
			end)

			if var_23_0.limitType == 2 and var_23_7[var_23_5] or var_23_6 and var_23_0.limitType == 2 and var_23_7[var_23_6] then
				return false
			end

			if var_23_0.limitType == 1 and not var_23_7[var_23_5] and (not var_23_6 or var_23_6 and not var_23_7[var_23_6]) then
				return false
			end
		end
	elseif var_23_1.typ == 3 then
		local var_23_8 = {}

		for iter_23_2, iter_23_3 in pairs(arg_23_1) do
			local var_23_9 = gGameModel.cards:find(iter_23_3):read("card_id")
			local var_23_10 = csv.cards[var_23_9]
			local var_23_11 = csv.unit[var_23_10.unitID].rarity

			if not var_23_8[var_23_11] then
				var_23_8[var_23_11] = 0
			end

			var_23_8[var_23_11] = var_23_8[var_23_11] + 1
		end

		for iter_23_4, iter_23_5 in csvPairs(var_23_0.limitArg) do
			if not var_23_8[iter_23_5[1]] or var_23_8[iter_23_5[1]] < iter_23_5[2] then
				return false
			end
		end
	end

	return true
end

function var_0_5.startFighting(arg_25_0, arg_25_1)
	if not arg_25_0:correctEnbattle() then
		gGameUI:showTip(gLanguageCsv.lineupInconsistency)

		return
	end

	local var_25_0 = arg_25_0.gateId
	local var_25_1 = arg_25_0.isFirst
	local var_25_2 = table.deepcopy(arg_25_0.battleCards, true)

	battleEntrance.battleRequest("/game/endless/battle/start", var_25_0, var_25_2):onStartOK(function(arg_26_0)
		if arg_25_1 then
			arg_25_1:onClose(false)

			arg_25_1 = nil
		end

		if not tolua.isnull(arg_25_0) then
			var_0_4.onClose(arg_25_0)
		end

		arg_26_0.isFirst = var_25_1
		arg_26_0.battleCards = var_25_2
	end):show()
end

function var_0_5.onVideoClick(arg_27_0)
	gGameApp:requestServer("/game/endless/plays/list", function(arg_28_0)
		gGameUI:stackUI("city.adventure.endless_tower.battle_video", nil, {
			dialog = true
		}, arg_28_0.view.latesPlays or {})
	end, arg_27_0.gateId)
end

return var_0_5
