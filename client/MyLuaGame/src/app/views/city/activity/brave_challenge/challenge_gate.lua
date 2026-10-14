local var_0_0 = require("app.views.city.activity.brave_challenge.adapt")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("BraveChallengeGateView", var_0_1)
local var_0_3 = 0.5
local var_0_4 = 1
local var_0_5 = {
	ui.COLORS.NORMAL.WHITE,
	ui.COLORS.NORMAL.DEFAULT,
	ui.COLORS.NORMAL.GRAY
}

var_0_2.RESOURCE_FILENAME = "activity_brave_challenge_gate.json"
var_0_2.RESOURCE_BINDING = {
	item01 = "item01",
	["panelTop.listInfoLineUp"] = "listInfoLineUp",
	panelLeft = "panelLeft",
	panelTop = "panelTop",
	panelDown = "panelDown",
	itemGate = "itemGate",
	["itemGate.imgAward.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["panelTop.enemyText"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(91, 84, 91, 255)
				}
			}
		}
	},
	["panelLeft.listGate"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 10,
				data = bindHelper.self("gateDatas"),
				item = bindHelper.self("itemGate"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("imgDi01", "imgDi02", "imgDi03", "txtInfo", "imgAward")

					var_1_0.imgDi01:visible(arg_1_3.sign == 1)
					var_1_0.imgDi02:visible(arg_1_3.sign == 2)
					var_1_0.imgDi03:visible(arg_1_3.sign == 3)
					text.addEffect(var_1_0.txtInfo, {
						color = var_0_5[arg_1_3.sign]
					})
					var_1_0.txtInfo:text(arg_1_3.name)
					var_1_0.imgAward:texture(arg_1_3.firstPass and "activity/brave_challenge/icon_yztz_box1.png" or "activity/brave_challenge/icon_yztz_box2.png")
					var_1_0.imgAward:get("txt"):text(arg_1_3.firstPass and gLanguageCsv.bcGateTip04 or gLanguageCsv.bcGateTip03)
					var_1_0.imgAward:visible(arg_1_3.sign >= 2)

					if not arg_1_3.firstPass then
						bind.touch(arg_1_0, var_1_0.imgAward, {
							methods = {
								ended = functools.partial(arg_1_0.showAward, arg_1_2, arg_1_3)
							}
						})
					end
				end,
				preloadCenter = bindHelper.self("floorID")
			},
			handlers = {
				showAward = bindHelper.self("onShowAward")
			}
		}
	},
	["panelTop.listEnemyLineUp"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("enemyDatas"),
				item = bindHelper.self("item01"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "card_icon",
						props = {
							showAttribute = true,
							unitId = arg_2_3.unitId,
							rarity = arg_2_3.rarity,
							advance = arg_2_3.advance,
							isBoss = arg_2_3.isBoss,
							levelProps = {
								data = arg_2_3.level
							},
							onNode = function(arg_3_0)
								local var_3_0, var_3_1 = arg_3_0:xy()

								arg_3_0:scale(0.8)
								arg_2_1:scale(arg_2_3.isBoss and 1 or 0.9)
							end
						}
					})
				end
			}
		}
	},
	["panelTop.btnBadge"] = {
		varname = "btnBadge",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnBadge")
			}
		}
	},
	["panelDown.btnReady"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnReady")
			}
		}
	},
	["panelDown.btnReady.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.ORANGE
				}
			}
		}
	},
	["panelDown.btnQuit"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onBtnQuit")
			}
		}
	},
	["panelDown.btnQuit.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.OUTLINE.DEFAULT
				}
			}
		}
	},
	["panelTop.btnBadge.txtBadge02"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(244, 144, 15, 255)
				}
			}
		}
	},
	["panelTop.btnBadge.txtRareBadgeNum"] = {
		binds = {
			{
				event = "text",
				idler = bindHelper.self("rateBadge")
			},
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.OUTLINE.ORANGE
					}
				}
			}
		}
	},
	["panelTop.btnBadge.txtGenBadgeNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("genBadge")
		}
	}
}

function var_0_2.onCreate(arg_4_0, arg_4_1)
	arg_4_0:initModel()

	arg_4_0.parent = arg_4_1.parent
	arg_4_0.gateDatas = idlertable.new({})
	arg_4_0.enemyDatas = idlertable.new({})
	arg_4_0.genBadge = idler.new(0)
	arg_4_0.rateBadge = idler.new(0)
	arg_4_0.floorID = 1
	arg_4_0.floorDatas = {}
	arg_4_0.sign = false
	arg_4_0.badgeSign = true
	arg_4_0.startGenBader = 0
	arg_4_0.startRateBader = 0
	arg_4_0.lastCards = clone(arg_4_0.gameInfo:read().cards)
	arg_4_0.diffCardHash = {}

	arg_4_0:initFloor()
	idlereasy.when(arg_4_0.gameInfo, function(arg_5_0, arg_5_1)
		if arg_5_1.floorID == 0 or arg_5_1.monsterID == 0 then
			return
		end

		arg_4_0.floorID = arg_4_0.floorDatas[arg_5_1.floorID] or 1

		arg_4_0:getFloorConfig(arg_4_0.floorID)
		arg_4_0:initMonsterEmbattle(arg_5_1.monsterID)
		arg_4_0:initMonsterInfo(arg_5_1.floorID, arg_5_1.monsterID)

		if arg_5_1.new_badges and table.nums(arg_5_1.new_badges) > 0 then
			arg_4_0:showSelectBadge(arg_5_1.new_badges)
		end

		arg_4_0:setCardSprite(arg_5_1.deployments)
		arg_4_0:getDiffCardhash(arg_5_1.cards)
	end)
	idlereasy.when(arg_4_0.badges, function(arg_6_0, arg_6_1)
		arg_4_0:getNumByType(arg_6_1)
	end)
	arg_4_0:runStartAction()
end

function var_0_2.initModel(arg_7_0)
	arg_7_0.id = gGameModel.brave_challenge:getIdler("yyID")
	arg_7_0.status = gGameModel.brave_challenge:getIdler("status")
	arg_7_0.gameInfo = gGameModel.brave_challenge:getIdler("game")
	arg_7_0.badges = gGameModel.brave_challenge:getIdler("badges")
	arg_7_0.floors = gGameModel.brave_challenge:getIdler("floors")
	arg_7_0.passTimes = gGameModel.brave_challenge:getIdler("pass_times")
end

function var_0_2.judgeGameIsOver(arg_8_0)
	if arg_8_0.parent.comingSoon then
		performWithDelay(arg_8_0, function()
			arg_8_0.parent:onClose()
		end, 0.016666666666666666)
	end
end

function var_0_2.initFloor(arg_10_0)
	arg_10_0.floorDatas = {}

	local var_10_0 = arg_10_0.parent:getBaseInfo()

	for iter_10_0, iter_10_1 in csvPairs(var_10_0.gateSeq) do
		arg_10_0.floorDatas[iter_10_1] = iter_10_0
	end
end

function var_0_2.runStartAction(arg_11_0)
	local var_11_0, var_11_1 = arg_11_0.panelDown:xy()
	local var_11_2, var_11_3 = arg_11_0.panelLeft:xy()
	local var_11_4, var_11_5 = arg_11_0.panelTop:xy()

	arg_11_0.panelDown:xy(var_11_0, var_11_1 - 300)
	arg_11_0.panelLeft:xy(var_11_2 - 650, var_11_3)
	arg_11_0.panelTop:xy(var_11_4, var_11_5 + 400)
	arg_11_0.parent:showCardPanel(false)
	performWithDelay(arg_11_0, function()
		arg_11_0.panelDown:runAction(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_11_0, var_11_1)), var_0_3))
		arg_11_0.panelLeft:runAction(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_11_2, var_11_3)), var_0_3))
		arg_11_0.panelTop:runAction(cc.Sequence:create(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_11_4, var_11_5)), var_0_3), cc.CallFunc:create(function()
			arg_11_0.parent:showCardPanel(true)
			arg_11_0:openAchievementView()
			arg_11_0:judgeGameIsOver()
		end), nil))
		arg_11_0.parent:setType(3)
	end, 0.016666666666666666)
end

function var_0_2.getDiffCardhash(arg_14_0, arg_14_1)
	arg_14_0.diffCardHash = {}

	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		if not arg_14_0.lastCards[iter_14_0] then
			arg_14_0.diffCardHash[iter_14_0] = true
		end
	end

	arg_14_0.lastCards = clone(arg_14_1)
end

function var_0_2.runEndAction(arg_15_0)
	arg_15_0.parent:showCardPanel(false)

	local var_15_0, var_15_1 = arg_15_0.panelDown:xy()
	local var_15_2, var_15_3 = arg_15_0.panelLeft:xy()
	local var_15_4, var_15_5 = arg_15_0.panelTop:xy()

	arg_15_0.panelDown:runAction(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_15_0, var_15_1 - 300)), var_0_3))
	arg_15_0.panelLeft:runAction(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_15_2 - 650, var_15_3)), var_0_3))
	arg_15_0.panelTop:runAction(cc.EaseOut:create(cc.MoveTo:create(var_0_3, cc.p(var_15_4, var_15_5 + 400)), var_0_3))
end

function var_0_2.getFloorConfig(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.parent:getBaseInfo()
	local var_16_1 = csv.brave_challenge.floor
	local var_16_2 = {}
	local var_16_3 = arg_16_0.floors:read()

	for iter_16_0, iter_16_1 in csvPairs(var_16_0.gateSeq) do
		local var_16_4 = var_16_1[iter_16_1]
		local var_16_5 = {
			id = iter_16_0,
			firstAward = var_16_4.firstAward,
			monsterDesc = var_16_4.monsterDesc,
			name = var_16_4.name,
			desc = var_16_4.desc,
			floor = var_16_4.floor,
			sign = arg_16_1 < iter_16_0 and 3 or iter_16_0 == arg_16_1 and 2 or 1,
			firstPass = var_16_3[var_16_4.floor] == 1
		}

		table.insert(var_16_2, var_16_5)
	end

	arg_16_0.gateDatas:set(var_16_2)
end

function var_0_2.initMonsterEmbattle(arg_17_0, arg_17_1)
	local var_17_0 = csv.brave_challenge.monster[arg_17_1]
	local var_17_1 = csv.brave_challenge.cards
	local var_17_2 = {}

	for iter_17_0, iter_17_1 in csvPairs(var_17_0.cards) do
		local var_17_3 = var_17_1[iter_17_1]

		if var_17_3 then
			local var_17_4 = csv.cards[var_17_3.cardID].unitID
			local var_17_5 = csv.unit[var_17_4]
			local var_17_6 = {
				isBoss = false,
				cardId = var_17_3.cardID,
				unitId = var_17_4,
				level = var_17_3.level,
				star = var_17_3.star,
				advance = var_17_3.advance,
				rarity = var_17_5.rarity,
				attr1 = var_17_5.natureType,
				attr2 = var_17_5.natureType2
			}

			for iter_17_2, iter_17_3 in csvPairs(var_17_0.boss) do
				if iter_17_3 == iter_17_1 then
					var_17_6.isBoss = true
				end
			end

			table.insert(var_17_2, var_17_6)
		end
	end

	table.sort(var_17_2, function(arg_18_0, arg_18_1)
		if arg_18_0.isBoss ~= arg_18_1.isBoss then
			return arg_18_0.isBoss
		end

		return arg_18_0.advance > arg_18_1.advance
	end)
	arg_17_0.enemyDatas:set(var_17_2)
end

function var_0_2.openAchievementView(arg_19_0)
	if arg_19_0.gameInfo:read().pass then
		local var_19_0 = arg_19_0.parent:getBaseInfo()
		local var_19_1 = {}
		local var_19_2 = arg_19_0.passTimes:read() == 1

		var_19_1[var_19_0.achievementID] = 1

		if var_19_0.achievementID == 0 then
			local var_19_3 = var_19_0.gateSeq[table.nums(var_19_0.gateSeq)]

			var_19_1 = csv.brave_challenge.floor[var_19_3].extraAward
			var_19_2 = true
		end

		gGameUI:stackUI("city.activity.brave_challenge.gain_achievement", nil, nil, {
			itemData = var_19_1,
			sendQuit = arg_19_0:createHandler("sendQuit"),
			got = var_19_2,
			lastAnimation = var_19_0.lastAnimation
		})
	end
end

function var_0_2.initMonsterInfo(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = csv.brave_challenge.floor[arg_20_1]
	local var_20_1 = csv.brave_challenge.monster[arg_20_2]

	beauty.textScroll({
		isRich = true,
		list = arg_20_0.listInfoLineUp,
		strs = string.format(gLanguageCsv.bcGateTip01, var_20_1.desc == "" and var_20_0.desc or var_20_1.desc)
	})
end

function var_0_2.playBadgeEffect(arg_21_0, arg_21_1)
	if arg_21_0.badgeSign then
		arg_21_0.startGenBader = arg_21_1[1] or 0
		arg_21_0.startRateBader = arg_21_1[2] or 0
		arg_21_0.badgeSign = false
		arg_21_0.effectGen = widget.addAnimationByKey(arg_21_0, "effect/xunzhangxuanze.skel", "effectGen", "", 100)

		arg_21_0.effectGen:xy(1270, 635)
		arg_21_0.effectGen:scale(2)

		arg_21_0.effectRate = widget.addAnimationByKey(arg_21_0, "effect/xunzhangxuanze.skel", "effectRate", "", 100)

		arg_21_0.effectRate:xy(1270, 700)
		arg_21_0.effectRate:scale(2)
	else
		local var_21_0 = arg_21_1[1] or 0

		if arg_21_0.startGenBader ~= var_21_0 then
			arg_21_0.effectGen:play("effect_hou")

			arg_21_0.startGenBader = var_21_0
		end

		local var_21_1 = arg_21_1[2] or 0

		if arg_21_0.startRateBader ~= var_21_1 then
			arg_21_0.effectRate:play("effect_hou")

			arg_21_0.startRateBader = var_21_1
		end
	end
end

function var_0_2.getNumByType(arg_22_0, arg_22_1)
	local var_22_0 = csv.brave_challenge.badge
	local var_22_1 = {}

	for iter_22_0, iter_22_1 in pairs(arg_22_1) do
		for iter_22_2, iter_22_3 in pairs(iter_22_1) do
			local var_22_2 = var_22_0[iter_22_3]

			if var_22_1[var_22_2.rarity] == nil then
				var_22_1[var_22_2.rarity] = 1
			else
				var_22_1[var_22_2.rarity] = var_22_1[var_22_2.rarity] + 1
			end
		end
	end

	arg_22_0:playBadgeEffect(var_22_1)
	arg_22_0.genBadge:set(var_22_1[1] or 0)
	arg_22_0.rateBadge:set(var_22_1[2] or 0)
end

function var_0_2.setCardSprite(arg_23_0, arg_23_1)
	local var_23_0 = csv.brave_challenge.cards
	local var_23_1 = {}

	for iter_23_0, iter_23_1 in ipairs(arg_23_1) do
		local var_23_2 = var_23_0[iter_23_1]

		if var_23_2 then
			local var_23_3 = csv.cards[var_23_2.cardID].unitID

			var_23_1[#var_23_1 + 1] = {
				csvID = iter_23_1,
				unit_id = var_23_3
			}
		end
	end

	arg_23_0.sign = #var_23_1 == 0

	arg_23_0.parent:showCardsDeployments(var_23_1)
end

function var_0_2.showSelectBadge(arg_24_0, arg_24_1)
	performWithDelay(arg_24_0, function()
		gGameUI:stackUI("city.activity.brave_challenge.select_badge", nil, nil, arg_24_1)
	end, 0.016666666666666666)
end

function var_0_2.onShowAward(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if itertools.size(arg_26_3.firstAward) ~= 0 then
		local var_26_0 = gLanguageCsv.braveChallengeFirstBox

		gGameUI:showBoxDetail({
			state = 1,
			data = arg_26_3.firstAward,
			content = var_26_0
		})
	end
end

function var_0_2.onBtnBadge(arg_27_0)
	local var_27_0 = {}

	for iter_27_0, iter_27_1 in pairs(arg_27_0.badges:read()) do
		for iter_27_2, iter_27_3 in pairs(iter_27_1) do
			table.insert(var_27_0, iter_27_3)
		end
	end

	gGameUI:stackUI("city.activity.brave_challenge.badge", nil, nil, var_27_0, 1)
end

function var_0_2.onBtnReady(arg_28_0)
	gGameUI:disableTouchDispatch(nil, false)

	local function var_28_0()
		gGameUI:stackUI("city.activity.brave_challenge.embattle", nil, {
			full = true
		}, {
			fightCb = arg_28_0:createHandler("startFighting"),
			newCards = arg_28_0.diffCardHash
		})
		arg_28_0.parent:resetPanelPos()
		gGameUI:disableTouchDispatch(nil, true)
	end

	if arg_28_0.sign then
		var_28_0()
	else
		arg_28_0.parent:runCardAction()
		arg_28_0:runAction(cc.Sequence:create(cc.DelayTime:create(var_0_4), cc.CallFunc:create(var_28_0), nil))
	end
end

function var_0_2.startFighting(arg_30_0, arg_30_1, arg_30_2)
	arg_30_0.parent:startFighting(arg_30_1, arg_30_2)
end

function var_0_2.sendQuit(arg_31_0, arg_31_1)
	gGameApp:requestServer(var_0_0.url("quit"), function(arg_32_0)
		arg_31_0.parent:onClose()

		if not arg_31_1 then
			gGameUI:showDialog({
				btnType = 1,
				strs = {
					gLanguageCsv.bcGateTip05
				},
				dialogParams = {
					clickClose = false
				}
			})
		end
	end, arg_31_0.id:read())
end

function var_0_2.onBtnQuit(arg_33_0)
	gGameUI:showDialog({
		btnType = 2,
		strs = {
			gLanguageCsv.bcGateTip02
		},
		cb = function()
			arg_33_0:sendQuit(false)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

return var_0_2
