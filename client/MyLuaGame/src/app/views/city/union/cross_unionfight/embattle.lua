local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = require("app.views.city.card.embattle.base")
local var_0_2 = class("CrossAreanEmbattleView", var_0_1)
local var_0_3 = {
	PANEL = {
		6,
		6,
		3
	},
	TEAM_NUM = {
		6,
		4,
		3
	},
	TEAM_SUM = {
		12,
		18,
		9
	},
	TEAMS = {
		2,
		3,
		3
	}
}

var_0_2.RESOURCE_FILENAME = "cross_union_fight_battle.json"
var_0_2.RESOURCE_BINDING = {
	bottomPanel = "bottomPanel",
	panelTip = "panelTip",
	battlePanel1 = "battlePanel1",
	topTableItem = "topTableItem",
	tips = "tips",
	rightDown = "rightDown",
	leftTableItem = "leftTableItem",
	spritePanel = "spriteItem",
	["battlePanel1.fightNote.btnGHimg"] = {
		varname = "btnGHimg",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onTeamBuffClick1")
			}
		}
	},
	["rightDown.btnOneKeySet"] = {
		varname = "btnOneKeySet",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEmbattleBtn")
			}
		}
	},
	["rightDown.btnOneKeySet.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["rightDown.btnChallenge"] = {
		varname = "btnChallenge",
		binds = {
			clicksafe = true,
			event = "touch",
			methods = {
				ended = bindHelper.self("teamSaveBtn")
			}
		}
	},
	["rightDown.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.back.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.imgDuiwu.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel1.fightNote.textFightPoint"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("fightSumNum1")
		}
	},
	teamList = {
		varname = "teamList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("topTabDatas"),
				item = bindHelper.self("topTableItem"),
				showTab = bindHelper.self("topTab"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:get("normal")
					local var_1_1 = arg_1_1:get("selected")
					local var_1_2

					if arg_1_3.select then
						var_1_0:hide()

						var_1_2 = var_1_1:show()
					else
						var_1_1:hide()

						var_1_2 = var_1_0:show()
					end

					if arg_1_3.sign == 1 then
						arg_1_1:get("sign"):show()
					else
						arg_1_1:get("sign"):hide()
					end

					var_1_2:get("txt"):text(arg_1_3.name)
					var_1_1:setTouchEnabled(false)
					bind.touch(arg_1_0, var_1_0, {
						methods = {
							ended = functools.partial(arg_1_0.clickCell, arg_1_2, 1)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	procList = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("leftTabDatas"),
				item = bindHelper.self("leftTableItem"),
				showTab = bindHelper.self("leftTab"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("normal")
					local var_2_1 = arg_2_1:get("selected")
					local var_2_2

					if arg_2_3.select then
						var_2_0:hide()

						var_2_2 = var_2_1:show()
					else
						var_2_1:hide()

						var_2_2 = var_2_0:show()
					end

					var_2_2:get("txt"):text(arg_2_3.name)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, 2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabClick")
			}
		}
	},
	["panelTip.tip2"] = {
		varname = "tip2",
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(251, 209, 60, 255),
				outline = {
					size = 4,
					color = cc.c4b(184, 52, 11, 255)
				}
			}
		}
	},
	["panelTip.tip1"] = {
		varname = "tip1",
		binds = {
			event = "effect",
			data = {
				color = cc.c4b(226, 89, 52, 255)
			}
		}
	},
	txtTip = {
		varname = "txtTip",
		binds = {
			event = "effect",
			data = {
				size = 50,
				color = ui.COLORS.NORMAL.DEFAULT
			}
		}
	}
}

function var_0_2.onCreate(arg_3_0, arg_3_1)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_3_0.rightDown,
			"pos",
			"right"
		}
	})
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose", true)
	}):init({
		subTitle = "FORMATION",
		title = gLanguageCsv.ministryHouseBattle
	})

	arg_3_0.topTabDatas = idlers.newWithMap({
		{
			sign = 0,
			type = 1,
			name = gLanguageCsv.crossUnionFightEmbattle1,
			id = arg_3_0.activityId
		},
		{
			sign = 0,
			type = 2,
			name = gLanguageCsv.crossUnionFightEmbattle2,
			id = arg_3_0.activityId
		},
		{
			sign = 0,
			type = 3,
			name = gLanguageCsv.crossUnionFightEmbattle3,
			id = arg_3_0.activityId
		}
	})

	local var_3_0 = {
		{
			select = false,
			type = 1,
			name = gLanguageCsv.team .. 1,
			id = arg_3_0.activityId
		},
		{
			select = false,
			type = 2,
			name = gLanguageCsv.team .. 2,
			id = arg_3_0.activityId
		}
	}
	local var_3_1 = {
		{
			select = false,
			type = 1,
			name = gLanguageCsv.team .. 1,
			id = arg_3_0.activityId
		},
		{
			select = false,
			type = 2,
			name = gLanguageCsv.team .. 2,
			id = arg_3_0.activityId
		},
		{
			select = false,
			type = 3,
			name = gLanguageCsv.team .. 3,
			id = arg_3_0.activityId
		}
	}

	arg_3_0.leftTabDatas = idlers.newWithMap({
		{
			type = 1,
			name = gLanguageCsv.team .. 1,
			id = arg_3_0.activityId
		},
		{
			type = 2,
			name = gLanguageCsv.team .. 2,
			id = arg_3_0.activityId
		},
		{
			type = 3,
			name = gLanguageCsv.team .. 3,
			id = arg_3_0.activityId
		}
	})
	arg_3_0.oldTopVal = 0
	arg_3_0.indexProject = arg_3_1.sign or 0

	arg_3_0:initModel(arg_3_1)
	arg_3_0:initBattlePanel()
	arg_3_0:initBottomList()
	idlereasy.any({
		arg_3_0.clientBattleCards,
		arg_3_0.leftTab
	}, function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_3_0.topTab:read()
		local var_4_1 = var_0_3.TEAM_NUM
		local var_4_2 = var_0_3.PANEL

		arg_3_0.embattleMax = var_4_1[var_4_0]
		arg_3_0.panelNum = var_4_2[var_4_0]

		arg_3_0.fightSumNum1:set(arg_3_0:getFightSumNum(1))
		arg_3_0:refreshTeamBuff(1)
		arg_3_0.rightDown:get("textNum"):text(arg_3_0:calcCardsNum(arg_4_1, var_4_0, arg_4_2) .. "/" .. arg_3_0.embattleMax)
		adapt.oneLineCenterPos(cc.p(163, 300), {
			arg_3_0.rightDown:get("textNote"),
			arg_3_0.rightDown:get("textNum")
		}, cc.p(5, 0))

		if var_4_0 == 3 then
			arg_3_0:resetPanel(3)
		else
			arg_3_0:resetPanel(6)
		end

		for iter_4_0 = 1, arg_3_0.panelNum do
			arg_3_0:refreshBattleSprite(iter_4_0)
		end
	end)
	idlereasy.any({
		arg_3_0.userInfo
	}, function(arg_5_0, arg_5_1)
		local var_5_0 = gGameModel.role:read("id")
		local var_5_1 = {}

		for iter_5_0, iter_5_1 in pairs(arg_5_1 or {}) do
			if iter_5_0 == var_5_0 then
				var_5_1 = iter_5_1

				break
			end
		end

		if not itertools.isempty(var_5_1) then
			arg_3_0.indexProject = var_5_1.projects[arg_3_1.type]

			for iter_5_2 = 1, 3 do
				if arg_3_0.indexProject == iter_5_2 then
					arg_3_0.topTabDatas:atproxy(iter_5_2).sign = 1
				else
					arg_3_0.topTabDatas:atproxy(iter_5_2).sign = 0
				end
			end
		end
	end)
	arg_3_0.topTab:addListener(function(arg_6_0, arg_6_1)
		arg_3_0.topTabDatas:atproxy(arg_6_1).select = false
		arg_3_0.topTabDatas:atproxy(arg_6_0).select = true
		arg_3_0.oldTopVal = arg_6_1

		if arg_6_0 < 2 then
			for iter_6_0, iter_6_1 in ipairs(var_3_0) do
				iter_6_1.select = false
			end

			arg_3_0.leftTabDatas:update(var_3_0)
		else
			for iter_6_2, iter_6_3 in ipairs(var_3_1) do
				iter_6_3.select = false
			end

			arg_3_0.leftTabDatas:update(var_3_1)
		end

		arg_3_0.leftTab:set(1, true)
		arg_3_0:changeAllCard(arg_6_0)
	end)
	arg_3_0.leftTab:addListener(function(arg_7_0, arg_7_1)
		if arg_3_0.topTab:read() == 1 and arg_7_1 > 2 then
			arg_7_1 = 1
		end

		arg_3_0.leftTabDatas:atproxy(arg_7_1).select = false
		arg_3_0.leftTabDatas:atproxy(arg_7_0).select = true

		for iter_7_0 = 1, arg_3_0.panelNum do
			arg_3_0:refreshBattleSprite(iter_7_0)
		end
	end)
	arg_3_0.tip2:text(gLanguageCsv.crossUnionFightEmbattleTip1)
	arg_3_0.tip1:text(gLanguageCsv.crossUnionFightEmbattleTip2)
	arg_3_0.tips:hide()
	idlereasy.when(arg_3_0.status, function(arg_8_0, arg_8_1)
		local var_8_0 = arg_3_0.indexProject ~= 0 and arg_3_0.indexProject or 1

		if arg_8_1 ~= "topPrepare" and arg_8_1 ~= "prePrepare" then
			arg_3_0.bottomPanel:hide()
			arg_3_0.rightDown:hide()
			arg_3_0.teamList:hide()
			arg_3_0.tips:show()
			arg_3_0.tips:text(arg_3_0.topTabDatas:atproxy(var_8_0).name)
			arg_3_0.txtTip:show()
			arg_3_0.txtTip:text(gLanguageCsv.crossUnionFightNotEmbattle)
			arg_3_0.tip2:hide()
			arg_3_0.tip1:hide()
		else
			arg_3_0.bottomPanel:show()
			arg_3_0.rightDown:show()
			arg_3_0.teamList:show()
			arg_3_0.tips:hide()
			arg_3_0.txtTip:hide()
			arg_3_0.tips:text("")
			arg_3_0.tip2:show()
			arg_3_0.tip1:show()
		end
	end)
end

function var_0_2.calcCardsNum(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = var_0_3.PANEL
	local var_9_1 = 0

	for iter_9_0 = 1 + (arg_9_3 - 1) * var_9_0[arg_9_2], arg_9_3 * var_9_0[arg_9_2] do
		if arg_9_1[iter_9_0] then
			var_9_1 = var_9_1 + 1
		end
	end

	return var_9_1
end

function var_0_2.initModel(arg_10_0, arg_10_1)
	arg_10_0.status = gGameModel.cross_union_fight:getIdler("status")
	arg_10_0.topTab = idler.new(arg_10_1.sign ~= 0 and arg_10_1.sign or 1)
	arg_10_0.leftTab = idler.new(1)
	arg_10_0.fightSumNum1 = idler.new(0)
	arg_10_0.cards = gGameModel.role:getIdler("cards")
	arg_10_0.userInfo = gGameModel.cross_union_fight:getIdler("roles")
	arg_10_0.type = arg_10_1.type or 1
	arg_10_0.fightCb = arg_10_1.fightCb
	arg_10_0.allCardDatas = idlers.newWithMap({})
	arg_10_0.selectIndex = idler.new(0)
	arg_10_0.cards = gGameModel.cross_union_fight:getIdler("cards")

	local function var_10_0(arg_11_0)
		local var_11_0 = gGameModel.role:read("cards")
		local var_11_1 = {}
		local var_11_2 = {}

		for iter_11_0, iter_11_1 in ipairs(var_11_0) do
			local var_11_3 = gGameModel.cards:find(iter_11_1):read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

			var_11_1[iter_11_1] = arg_10_0.limtFunc(arg_10_0, iter_11_1, var_11_3.card_id, var_11_3.skin_id, var_11_3.fighting_point, var_11_3.level, var_11_3.star, var_11_3.advance, var_11_3.created_time, var_11_3.nature_choose, false)

			if var_11_1[iter_11_1] then
				table.insert(var_11_2, var_11_1[iter_11_1])
			end
		end

		table.sort(var_11_2, function(arg_12_0, arg_12_1)
			if arg_12_0.fighting_point ~= arg_12_1.fighting_point then
				return arg_12_0.fighting_point > arg_12_1.fighting_point
			end

			return arg_12_0.rarity > arg_12_1.rarity
		end)

		local var_11_4 = {}
		local var_11_5 = {}
		local var_11_6 = 0

		for iter_11_2, iter_11_3 in ipairs(var_11_2) do
			if not var_11_5[iter_11_3.markId] and not iter_11_3.inMeteor then
				var_11_5[iter_11_3.markId] = true

				table.insert(var_11_4, iter_11_3.dbid)

				var_11_6 = var_11_6 + 1

				if var_11_6 == 12 then
					break
				end
			end
		end

		local var_11_7 = {}
		local var_11_8 = 1

		for iter_11_4 = 1, var_0_3.TEAMS[arg_11_0] do
			for iter_11_5 = 1, var_0_3.PANEL[arg_11_0] do
				if iter_11_5 > var_0_3.TEAM_NUM[arg_11_0] then
					var_11_7[(iter_11_4 - 1) * var_0_3.PANEL[arg_11_0] + iter_11_5] = nil
				else
					var_11_7[(iter_11_4 - 1) * var_0_3.PANEL[arg_11_0] + iter_11_5] = var_11_4[var_11_8]
					var_11_8 = var_11_8 + 1
				end
			end
		end

		return var_11_7
	end

	local var_10_1 = {
		var_10_0(1),
		var_10_0(2),
		(var_10_0(3))
	}

	idlereasy.any({
		arg_10_0.cards
	}, function(arg_13_0, arg_13_1)
		local var_13_0 = arg_13_1[arg_10_1.type]

		arg_10_0.allBattleCardsData = {
			{},
			{},
			{}
		}

		local var_13_1 = {
			2,
			3,
			3
		}
		local var_13_2 = 1

		for iter_13_0 = 1, 3 do
			if not itertools.isempty(var_13_0[iter_13_0]) then
				for iter_13_1 = 1, var_0_3.TEAM_SUM[iter_13_0] do
					arg_10_0.allBattleCardsData[iter_13_0][iter_13_1] = var_13_0[iter_13_0][iter_13_1]
					var_13_2 = var_13_2 + 1
				end
			else
				arg_10_0.allBattleCardsData[iter_13_0] = var_10_1[iter_13_0]
			end
		end

		arg_10_0.beforeBattleCards = table.deepcopy(arg_10_0.allBattleCardsData, true)
	end)

	arg_10_0.battleCardsData = idlertable.new(arg_10_0.allBattleCardsData[arg_10_0.topTab:read()])
	arg_10_0.clientBattleCards = idlertable.new(arg_10_0.allBattleCardsData[arg_10_0.topTab:read()])

	arg_10_0:initDefine()
	arg_10_0:initAllCards()
end

function var_0_2.changeAllCard(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.allBattleCardsData[arg_14_1]

	for iter_14_0 = 1, 18 do
		if arg_14_0.clientBattleCards:read()[iter_14_0] then
			arg_14_0:getCardAttrs(arg_14_0.clientBattleCards:read()[iter_14_0]).battle = 0
		end
	end

	for iter_14_1 = 1, 18 do
		local var_14_1 = var_14_0[iter_14_1]

		if var_14_1 then
			arg_14_0:getCardAttrs(var_14_1).battle = arg_14_0:getBattle(iter_14_1)
		end
	end

	arg_14_0.allBattleCardsData[arg_14_1] = var_14_0

	arg_14_0.clientBattleCards:set(var_14_0, true)
end

function var_0_2.initDefine(arg_15_0)
	local var_15_0 = var_0_3.TEAM_NUM
	local var_15_1 = var_0_3.PANEL

	arg_15_0.embattleMax = var_15_0[arg_15_0.topTab:read()]
	arg_15_0.panelNum = var_15_1[arg_15_0.topTab:read()]
end

function var_0_2.resetPanel(arg_16_0, arg_16_1)
	if arg_16_1 == 3 then
		local var_16_0 = arg_16_0.battlePanel1:multiget("item4", "item5", "item6", "ahead", "back")

		for iter_16_0, iter_16_1 in pairs(var_16_0) do
			iter_16_1:hide()
		end

		local var_16_1 = arg_16_0.battlePanel1:multiget("item1", "item2", "item3")
		local var_16_2 = {
			278,
			825,
			1366
		}

		for iter_16_2, iter_16_3 in pairs(var_16_1) do
			iter_16_3:get("imgBg"):scale(1, 1)
			iter_16_3:size(cc.size(500, 300))
		end

		var_16_1.item1:xy(338, 750)
		var_16_1.item2:xy(905, 730)
		var_16_1.item3:xy(1366, 730)
		arg_16_0.battlePanel1:get("place"):show()
	else
		local var_16_3 = arg_16_0.battlePanel1:multiget("item4", "item5", "item6", "ahead", "back")

		for iter_16_4, iter_16_5 in pairs(var_16_3) do
			iter_16_5:show()
		end

		local var_16_4 = arg_16_0.battlePanel1:multiget("item1", "item2", "item3")
		local var_16_5 = {
			1302,
			1165,
			997
		}
		local var_16_6 = {
			987,
			746,
			524
		}
		local var_16_7 = {
			0.6,
			0.8,
			1
		}
		local var_16_8 = {
			cc.size(367, 255),
			cc.size(387, 225),
			cc.size(500, 225)
		}

		for iter_16_6 = 1, 3 do
			var_16_4["item" .. iter_16_6]:xy(var_16_5[iter_16_6], var_16_6[iter_16_6]):size(var_16_8[iter_16_6])
			var_16_4["item" .. iter_16_6]:xy(var_16_5[iter_16_6], var_16_6[iter_16_6])
			var_16_4["item" .. iter_16_6]:get("imgBg"):scale(var_16_7[iter_16_6])
		end

		arg_16_0.battlePanel1:get("place"):hide()
	end

	arg_16_0.battleCardsRect = {}
	arg_16_0.battleCards = {}

	for iter_16_7 = 1, arg_16_0.panelNum do
		local var_16_9 = arg_16_0.battlePanel1:get("item" .. iter_16_7)
		local var_16_10 = var_16_9:box()
		local var_16_11 = var_16_9:getParent():convertToWorldSpace(cc.p(var_16_10.x, var_16_10.y))

		var_16_10.x, var_16_10.y = var_16_11.x, var_16_11.y

		local var_16_12 = iter_16_7

		arg_16_0.battleCardsRect[var_16_12] = var_16_10
		arg_16_0.battleCards[var_16_12] = var_16_9

		var_16_9:onTouch(functools.partial(arg_16_0.onBattleCardTouch, arg_16_0, var_16_12))
	end

	for iter_16_8 = 1, arg_16_0.panelNum do
		local var_16_13 = arg_16_0.battleCards[iter_16_8]:get("imgBg")
		local var_16_14 = var_16_13:get("imgSel")
		local var_16_15 = var_16_13:size()

		if not var_16_14 then
			widget.addAnimationByKey(var_16_13, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_16_15.width / 2, var_16_15.height / 2 + 15):visible(false)
		end
	end
end

function var_0_2.initAllCards(arg_17_0)
	local var_17_0 = gGameModel.role:read("cards")
	local var_17_1 = itertools.map(arg_17_0.clientBattleCards:read(), function(arg_18_0, arg_18_1)
		return arg_18_1, arg_18_0
	end)
	local var_17_2 = {}

	arg_17_0.oneKeyAllCards = {}

	for iter_17_0, iter_17_1 in ipairs(var_17_0) do
		local var_17_3 = gGameModel.cards:find(iter_17_1)
		local var_17_4 = arg_17_0:getBattle(var_17_1[iter_17_1])
		local var_17_5 = var_17_3:read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")

		var_17_2[iter_17_1] = arg_17_0.limtFunc(arg_17_0, iter_17_1, var_17_5.card_id, var_17_5.skin_id, var_17_5.fighting_point, var_17_5.level, var_17_5.star, var_17_5.advance, var_17_5.created_time, var_17_5.nature_choose, var_17_4)

		if var_17_2[iter_17_1] then
			table.insert(arg_17_0.oneKeyAllCards, var_17_2[iter_17_1])
		end
	end

	arg_17_0.allCardDatas:update(var_17_2)
	table.sort(arg_17_0.oneKeyAllCards, function(arg_19_0, arg_19_1)
		if arg_19_0.fighting_point ~= arg_19_1.fighting_point then
			return arg_19_0.fighting_point > arg_19_1.fighting_point
		end

		return arg_19_0.rarity > arg_19_1.rarity
	end)

	arg_17_0.oneKeyCards = {}

	local var_17_6 = {}
	local var_17_7 = 0

	for iter_17_2, iter_17_3 in ipairs(arg_17_0.oneKeyAllCards) do
		if not var_17_6[iter_17_3.markId] and not iter_17_3.inMeteor then
			var_17_6[iter_17_3.markId] = true

			table.insert(arg_17_0.oneKeyCards, iter_17_3.dbid)

			var_17_7 = var_17_7 + 1

			if var_17_7 == 12 then
				break
			end
		end
	end
end

function var_0_2.initBattlePanel(arg_20_0)
	arg_20_0.battleCardsRect = {}
	arg_20_0.battleCards = {}

	for iter_20_0 = 1, arg_20_0.panelNum do
		local var_20_0 = arg_20_0.battlePanel1:get("item" .. iter_20_0)
		local var_20_1 = var_20_0:box()
		local var_20_2 = var_20_0:getParent():convertToWorldSpace(cc.p(var_20_1.x, var_20_1.y))

		var_20_1.x, var_20_1.y = var_20_2.x, var_20_2.y

		local var_20_3 = iter_20_0

		arg_20_0.battleCardsRect[var_20_3] = var_20_1
		arg_20_0.battleCards[var_20_3] = var_20_0

		var_20_0:onTouch(functools.partial(arg_20_0.onBattleCardTouch, arg_20_0, var_20_3))
	end

	for iter_20_1 = 1, arg_20_0.panelNum do
		local var_20_4 = arg_20_0.battleCards[iter_20_1]:get("imgBg")
		local var_20_5 = var_20_4:get("imgSel")
		local var_20_6 = var_20_4:size()
		local var_20_7

		var_20_7 = var_20_5 or widget.addAnimationByKey(var_20_4, "effect/buzhen2.skel", "imgSel", "effect_loop", 2):xy(var_20_6.width / 2, var_20_6.height / 2 + 15)
	end

	idlereasy.when(arg_20_0.selectIndex, function(arg_21_0, arg_21_1)
		for iter_21_0 = 1, arg_20_0.panelNum do
			arg_20_0.battleCards[iter_21_0]:get("imgBg.imgSel"):visible(arg_21_1 == iter_21_0)
		end
	end)

	arg_20_0.draggingIndex = idler.new(0)

	idlereasy.when(arg_20_0.draggingIndex, function(arg_22_0, arg_22_1)
		for iter_22_0 = 1, arg_20_0.panelNum do
			local var_22_0 = arg_20_0.battleCards[iter_22_0]:get("sprite")

			if var_22_0 then
				var_22_0:setCascadeOpacityEnabled(true)

				if arg_22_1 == 0 then
					var_22_0:opacity(255)
				elseif arg_22_1 == -1 then
					var_22_0:opacity(155)
				elseif arg_22_1 == iter_22_0 then
					var_22_0:opacity(255)
				else
					var_22_0:opacity(155)
				end
			end
		end
	end)
end

function var_0_2.refreshBattlePanel(arg_23_0)
	return
end

function var_0_2.initBottomList(arg_24_0)
	arg_24_0.cardListView = gGameUI:createView("city.card.embattle.cross_union_fight_card_list", arg_24_0.bottomPanel):init({
		base = arg_24_0,
		clientBattleCards = arg_24_0.clientBattleCards,
		battleCardsData = arg_24_0.battleCardsData,
		selectIndex = arg_24_0.selectIndex,
		deleteMovingItem = arg_24_0.deleteMovingItem,
		createMovePanel = arg_24_0.createMovePanel,
		moveMovePanel = arg_24_0.moveMovePanel,
		isMovePanelExist = arg_24_0.isMovePanelExist,
		onCardClick = arg_24_0.onCardClick,
		allCardDatas = arg_24_0.allCardDatas,
		moveEndMovePanel = arg_24_0.moveEndMovePanel,
		limtFunc = arg_24_0.limtFunc
	}, true)
end

function var_0_2.getCardAttrIdler(arg_25_0, arg_25_1, arg_25_2)
	return gGameModel.cards:find(arg_25_1):getIdler(arg_25_2)
end

function var_0_2.getFightSumNum(arg_26_0, arg_26_1)
	local var_26_0 = 0
	local var_26_1 = arg_26_0.topTab:read()
	local var_26_2 = arg_26_0.leftTab:read()
	local var_26_3 = 1 + (var_26_2 - 1) * var_0_3.PANEL[var_26_1]
	local var_26_4 = var_26_2 * var_0_3.PANEL[var_26_1]

	for iter_26_0 = var_26_3, var_26_4 do
		if arg_26_0.clientBattleCards:read()[iter_26_0] then
			var_26_0 = var_26_0 + arg_26_0:getCardAttrs(arg_26_0.clientBattleCards:read()[iter_26_0]).fighting_point
		end
	end

	return var_26_0
end

function var_0_2.getCardNum(arg_27_0, arg_27_1)
	local var_27_0 = 0
	local var_27_1 = arg_27_0.topTab:read()
	local var_27_2 = arg_27_0.leftTab:read()
	local var_27_3 = 1 + (var_27_2 - 1) * var_0_3.PANEL[var_27_1]
	local var_27_4 = var_27_2 * var_0_3.PANEL[var_27_1]

	for iter_27_0 = var_27_3, var_27_4 do
		if arg_27_0.clientBattleCards:read()[iter_27_0] then
			var_27_0 = var_27_0 + 1
		end
	end

	return var_27_0
end

function var_0_2.refreshTeamBuff(arg_28_0)
	local var_28_0 = arg_28_0.topTab:read()
	local var_28_1 = arg_28_0.leftTab:read()

	arg_28_0.btnGHimg:show()

	if var_28_0 ~= 1 then
		arg_28_0.btnGHimg:hide()

		return
	end

	local var_28_2 = {}
	local var_28_3 = 1 + (var_28_1 - 1) * 6

	for iter_28_0 = var_28_3, var_28_3 + 5 do
		local var_28_4 = arg_28_0:getCardAttrs(arg_28_0.clientBattleCards:read()[iter_28_0])

		if var_28_4 then
			local var_28_5 = csv.cards[var_28_4.card_id]
			local var_28_6 = csv.unit[var_28_5.unitID]

			var_28_2[iter_28_0 - var_28_3 + 1] = {
				var_28_6.natureType,
				var_28_6.natureType2
			}
		end
	end

	local var_28_7 = dataEasy.getTeamBuffBest(var_28_2)

	arg_28_0.btnGHimg:texture(var_28_7.buf.imgPath)

	arg_28_0.teamBuffs1 = var_28_7
end

function var_0_2.oneKeyEmbattleBtn(arg_29_0)
	local var_29_0 = arg_29_0.topTab:read()
	local var_29_1 = {}
	local var_29_2 = 1

	for iter_29_0 = 1, var_0_3.TEAMS[var_29_0] do
		for iter_29_1 = 1, var_0_3.PANEL[var_29_0] do
			if iter_29_1 > var_0_3.TEAM_NUM[var_29_0] then
				var_29_1[(iter_29_0 - 1) * var_0_3.PANEL[var_29_0] + iter_29_1] = nil
			else
				var_29_1[(iter_29_0 - 1) * var_0_3.PANEL[var_29_0] + iter_29_1] = arg_29_0.oneKeyCards[var_29_2]
				var_29_2 = var_29_2 + 1
			end
		end
	end

	if not arg_29_0.clientBattleCards:read() then
		return
	end

	if itertools.equal(var_29_1, arg_29_0.clientBattleCards:read()) then
		gGameUI:showTip(gLanguageCsv.embattleNotChange)

		return
	end

	for iter_29_2 = 1, 18 do
		if arg_29_0.clientBattleCards:read()[iter_29_2] then
			arg_29_0:getCardAttrs(arg_29_0.clientBattleCards:read()[iter_29_2]).battle = 0
		end
	end

	for iter_29_3 = 1, var_0_3.TEAM_SUM[var_29_0] do
		local var_29_3 = var_29_1[iter_29_3]

		if var_29_3 then
			arg_29_0:getCardAttrs(var_29_3).battle = arg_29_0:getBattle(iter_29_3)
		end
	end

	arg_29_0.allBattleCardsData[var_29_0] = var_29_1

	arg_29_0.clientBattleCards:set(var_29_1, true)
	gGameUI:showTip(gLanguageCsv.oneKeySuccess)
end

function var_0_2.onChangeBattle(arg_30_0)
	arg_30_0.clientBattleCards:modify(function(arg_31_0)
		for iter_31_0 = 1, 6 do
			arg_31_0[iter_31_0], arg_31_0[iter_31_0 + 6] = arg_31_0[iter_31_0 + 6], arg_31_0[iter_31_0]
		end

		for iter_31_1 = 1, arg_30_0.panelNum do
			local var_31_0 = arg_30_0.clientBattleCards:read()[iter_31_1]

			if arg_30_0:getCardAttrs(var_31_0) then
				arg_30_0:getCardAttrs(var_31_0).battle = arg_30_0:getBattle(iter_31_1)
			end
		end

		arg_30_0.allBattleCardsData[arg_30_0.topTab:read()] = arg_31_0
	end, true)
end

function var_0_2.teamSaveBtn(arg_32_0)
	local var_32_0 = arg_32_0.topTab:read()

	gGameUI:showDialog({
		fontSize = 50,
		btnType = 2,
		isRich = true,
		title = gLanguageCsv.tips,
		content = string.format(gLanguageCsv.crossUnionFightEmbattle, gLanguageCsv["crossUnionFightEmbattle" .. var_32_0]),
		cb = function()
			arg_32_0:saveBtn()
		end
	})
end

function var_0_2.saveBtn(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0.status:read() ~= "topPrepare" and arg_34_0.status:read() ~= "prePrepare" then
		gGameUI:showTip(gLanguageCsv.crossUnionFightCantEmbattle)

		return
	end

	local var_34_0 = arg_34_0.topTab:read()
	local var_34_1, var_34_2 = arg_34_0:lastModify()

	if var_34_1 and var_34_0 == arg_34_0.indexProject then
		gGameUI:showTip(gLanguageCsv.embattleNotChange)

		return 1
	end

	if type(arg_34_1) ~= "number" then
		arg_34_1 = var_34_0
	end

	local var_34_3 = arg_34_0.allBattleCardsData[arg_34_1]
	local var_34_4 = 0

	for iter_34_0 = 1, var_0_3.TEAMS[arg_34_1] do
		if var_0_3.TEAM_NUM[arg_34_1] ~= arg_34_0:calcCardsNum(var_34_3, arg_34_1, iter_34_0) then
			var_34_4 = iter_34_0
		end
	end

	if var_34_4 == 0 then
		gGameApp:requestServer("/game/cross/union/fight/battle/deploy", function(arg_35_0)
			if type(arg_34_2) == "function" then
				arg_34_2()
			else
				gGameUI:showTip(gLanguageCsv.positionSave)
			end
		end, arg_34_0.type, arg_34_1, var_34_3)
	else
		gGameUI:showTip(string.format(gLanguageCsv.crossUnionFightCardNotEnough, gLanguageCsv["symbolNumber" .. var_34_4]))

		return 1
	end
end

function var_0_2.onTeamBuffClick1(arg_36_0)
	local var_36_0 = arg_36_0.teamBuffs1 and arg_36_0.teamBuffs1.buf.teamBuffs or {}

	gGameUI:stackUI("city.card.embattle.attr_dialog", nil, {}, var_36_0)
end

function var_0_2.refreshBattleSprite(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.battleCards[arg_37_1]
	local var_37_1 = var_0_3.PANEL
	local var_37_2 = arg_37_0:getCardAttrs(arg_37_0.clientBattleCards:read()[arg_37_1 + (arg_37_0.leftTab:read() - 1) * var_37_1[arg_37_0.topTab:read()]])

	if not var_37_2 then
		if var_37_0:getChildByName("sprite") then
			var_37_0:getChildByName("sprite"):hide()
		end

		var_37_0:get("attrBg"):hide()

		return
	end

	local var_37_3 = var_37_2.card_id
	local var_37_4 = csv.unit[var_37_2.unit_id]
	local var_37_5 = arg_37_0.battleCards[arg_37_1]:get("imgBg")

	if var_37_0.spriteId == var_37_3 and var_37_0:getChildByName("sprite") then
		var_37_0:getChildByName("sprite"):show()
	else
		var_37_0:removeChildByName("sprite")
		widget.addAnimationByKey(var_37_0, var_37_4.unitRes, "sprite", "standby_loop", 4):scale(var_37_4.scale * 0.8):xy(var_37_5:x(), var_37_5:y() + 15):setSkin(var_37_4.skin)

		var_37_0.spriteId = var_37_3
	end

	local var_37_6 = arg_37_1 > 6 and 2 or 1
	local var_37_7 = arg_37_0["teamBuffs" .. var_37_6] and arg_37_0["teamBuffs" .. var_37_6].flags or {
		1,
		1,
		1,
		1,
		1,
		1
	}
	local var_37_8 = var_37_7[arg_37_1] or var_37_7[arg_37_1 - 6]

	uiEasy.setTeamBuffItem(var_37_0, var_37_3, var_37_8)
end

function var_0_2.onBattleCardTouch(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_0.status:read() ~= "topPrepare" and arg_38_0.status:read() ~= "prePrepare" then
		return
	end

	local var_38_0 = var_0_3.PANEL

	if not arg_38_0.clientBattleCards:read()[arg_38_1 + (arg_38_0.leftTab:read() - 1) * var_38_0[arg_38_0.topTab:read()]] then
		return
	end

	local var_38_1 = arg_38_0:getCardAttrs(arg_38_0.clientBattleCards:read()[arg_38_1 + (arg_38_0.leftTab:read() - 1) * var_38_0[arg_38_0.topTab:read()]])

	if arg_38_2.name == "began" then
		arg_38_0:deleteMovingItem()
		arg_38_0:createMovePanel(var_38_1)

		local var_38_2 = arg_38_0.battleCards[arg_38_1]

		var_38_2:get("sprite"):hide()
		var_38_2:get("attrBg"):hide()
		arg_38_0:moveMovePanel(arg_38_2)
	elseif arg_38_2.name == "moved" then
		arg_38_0:moveMovePanel(arg_38_2)
	elseif arg_38_2.name == "ended" or arg_38_2.name == "cancelled" then
		local var_38_3 = arg_38_0.battleCards[arg_38_1]

		var_38_3:get("sprite"):show()
		var_38_3:get("attrBg"):show()
		arg_38_0:deleteMovingItem()

		if arg_38_2.y < 340 then
			arg_38_0:onCardClick(var_38_1, true)
		else
			local var_38_4 = arg_38_0:whichEmbattleTargetPos(arg_38_2)

			if var_38_4 then
				if var_38_4 ~= arg_38_1 then
					arg_38_0:onCardMove(var_38_1, var_38_4, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_38_0:onCardMove(var_38_1, var_38_4, false)
				end
			else
				arg_38_0:onCardMove(var_38_1, arg_38_1, false)
			end
		end
	end
end

function var_0_2.onCardMove(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = var_0_3.PANEL

	arg_39_2 = arg_39_2 and arg_39_2 + (arg_39_0.leftTab:read() - 1) * var_39_0[arg_39_0.topTab:read()]

	local var_39_1
	local var_39_2 = arg_39_1.dbid
	local var_39_3 = arg_39_0:getIdxByDbId(var_39_2)
	local var_39_4 = arg_39_0.clientBattleCards:read()[arg_39_2]
	local var_39_5 = arg_39_0:getCardAttrs(var_39_4)
	local var_39_6 = arg_39_0:getBattle(var_39_3)

	if not arg_39_2 then
		-- block empty
	else
		local var_39_7 = arg_39_0:getBattle(arg_39_2)

		if arg_39_1.battle > 0 then
			if var_39_7 ~= arg_39_1.battle and arg_39_0:getCardNum(arg_39_1.battle) == 1 and var_39_4 == nil then
				var_39_1 = gLanguageCsv.battleNumberNo

				arg_39_0:refreshBattleSprite(var_39_3)
			else
				if arg_39_0:getCardAttrs(var_39_4) then
					arg_39_0:getCardAttrs(var_39_4).battle = arg_39_0:getBattle(var_39_3)
				end

				if arg_39_0:getCardAttrs(var_39_2) then
					arg_39_0:getCardAttrs(var_39_2).battle = arg_39_0:getBattle(arg_39_2)
				end

				arg_39_0.clientBattleCards:modify(function(arg_40_0)
					arg_40_0[var_39_3], arg_40_0[arg_39_2] = arg_40_0[arg_39_2], arg_40_0[var_39_3]
					arg_39_0.allBattleCardsData[arg_39_0.topTab:read()] = arg_40_0

					return true, arg_40_0
				end, true)
			end
		else
			local var_39_8 = arg_39_0:hasSameMarkIDCard(arg_39_1)

			if var_39_8 and var_39_8 ~= arg_39_2 then
				var_39_1 = gLanguageCsv.alreadyHaveSameSprite
			elseif not var_39_4 and not arg_39_0:canBattleUp() then
				var_39_1 = gLanguageCsv.battleCardCountEnough
			else
				if var_39_4 then
					arg_39_0:getCardAttrs(var_39_4).battle = 0
				end

				arg_39_0:getCardAttrs(var_39_2).battle = arg_39_0:getBattle(arg_39_2)

				arg_39_0.clientBattleCards:modify(function(arg_41_0)
					arg_41_0[arg_39_2] = var_39_2
					arg_39_0.allBattleCardsData[arg_39_0.topTab:read()] = arg_41_0

					return true, arg_41_0
				end, true)

				var_39_1 = gLanguageCsv.addToEmbattle
			end
		end
	end

	if arg_39_3 and var_39_1 then
		gGameUI:showTip(var_39_1)
	end
end

function var_0_2.canBattleDown(arg_42_0, arg_42_1)
	return arg_42_0:getCardNum(arg_42_1) > 1
end

function var_0_2.downBattle(arg_43_0, arg_43_1)
	arg_43_0.allCardDatas:atproxy(arg_43_1).battle = 0

	local var_43_0 = arg_43_0:getIdxByDbId(arg_43_1)

	arg_43_0.clientBattleCards:modify(function(arg_44_0)
		arg_44_0[var_43_0] = nil
		arg_43_0.allBattleCardsData[arg_43_0.topTab:read()] = arg_44_0

		return true, arg_44_0
	end, true)
end

function var_0_2.upBattle(arg_45_0, arg_45_1, arg_45_2)
	arg_45_0:getCardAttrs(arg_45_1).battle = arg_45_0:getBattle(arg_45_2)

	arg_45_0.clientBattleCards:modify(function(arg_46_0)
		arg_46_0[arg_45_2] = arg_45_1
		arg_45_0.allBattleCardsData[arg_45_0.topTab:read()] = arg_46_0

		return true, arg_46_0
	end, true)
end

function var_0_2.whichEmbattleTargetPos(arg_47_0, arg_47_1)
	for iter_47_0 = arg_47_0.panelNum, 1, -1 do
		local var_47_0 = arg_47_0.battleCardsRect[iter_47_0]

		if cc.rectContainsPoint(var_47_0, arg_47_1) then
			return iter_47_0
		end
	end
end

function var_0_2.hasSameMarkIDCard(arg_48_0, arg_48_1)
	local var_48_0 = {
		12,
		18,
		9
	}

	for iter_48_0 = 1, var_48_0[arg_48_0.topTab:read()] do
		local var_48_1 = arg_48_0.clientBattleCards:read()[iter_48_0]

		if var_48_1 and arg_48_0:getCardAttrs(var_48_1).markId == arg_48_1.markId then
			return iter_48_0
		end
	end

	return false
end

function var_0_2.sendRequeat(arg_49_0, arg_49_1, arg_49_2)
	if arg_49_0.status:read() ~= "topPrepare" and arg_49_0.status:read() ~= "prePrepare" then
		arg_49_1()

		return
	end

	local var_49_0, var_49_1 = arg_49_0:lastModify()
	local var_49_2 = arg_49_0.indexProject
	local var_49_3 = arg_49_0.topTab:read()

	if not var_49_0 then
		local function var_49_4()
			gGameUI:showTip(gLanguageCsv.positionSave)
			arg_49_1()
		end

		if var_49_2 ~= var_49_1 then
			gGameUI:showDialog({
				fontSize = 50,
				clearFast = true,
				btnType = 2,
				isRich = true,
				title = gLanguageCsv.crossUnionFightEmbattleTitle,
				content = string.format(gLanguageCsv.crossUnionFightEmbattleSave, gLanguageCsv["crossUnionFightEmbattle" .. var_49_1]),
				cb = function()
					arg_49_0:saveBtn(var_49_1, var_49_4)
				end,
				cancelCb = arg_49_1
			})
		else
			gGameUI:showDialog({
				fontSize = 50,
				clearFast = true,
				btnType = 2,
				isRich = true,
				title = gLanguageCsv.crossUnionFightEmbattleTitle,
				content = string.format(gLanguageCsv.crossUnionFightEmbattleSave, gLanguageCsv["crossUnionFightEmbattle" .. var_49_1]),
				cb = function()
					arg_49_0:saveBtn(var_49_1, var_49_4)
				end,
				cancelCb = arg_49_1
			})
		end
	else
		arg_49_1()
	end
end

function var_0_2.lastModify(arg_53_0)
	local var_53_0 = 0
	local var_53_1 = arg_53_0.topTab:read()
	local var_53_2 = {
		0,
		0,
		0
	}

	for iter_53_0 = 1, 3 do
		if not itertools.equal(arg_53_0.allBattleCardsData[iter_53_0], arg_53_0.beforeBattleCards[iter_53_0]) then
			var_53_2[iter_53_0] = 1
			var_53_0 = 1
		end
	end

	if var_53_0 == 0 then
		return true
	end

	if var_53_2[var_53_1] == 1 then
		return false, var_53_1
	end

	if var_53_2[arg_53_0.oldTopVal] == 1 then
		return false, arg_53_0.oldTopVal
	end

	for iter_53_1, iter_53_2 in ipairs(var_53_2) do
		if iter_53_2 == 1 then
			return false, iter_53_1
		end
	end
end

function var_0_2.getBattle(arg_54_0, arg_54_1)
	local var_54_0 = var_0_3.PANEL

	if arg_54_1 and arg_54_1 ~= 0 then
		return math.ceil(arg_54_1 / var_54_0[arg_54_0.topTab:read()])
	else
		return 0
	end
end

function var_0_2.onTabClick(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	arg_55_0[({
		"topTab",
		"leftTab"
	})[arg_55_3]]:set(arg_55_2)
end

function var_0_2.getIdxByDbId(arg_56_0, arg_56_1)
	if not arg_56_1 then
		local var_56_0 = var_0_3.PANEL
		local var_56_1 = arg_56_0.clientBattleCards:read()
		local var_56_2 = arg_56_0.topTab:read()
		local var_56_3 = arg_56_0.leftTab:read()

		for iter_56_0 = 1 + (var_56_3 - 1) * var_56_0[var_56_2], var_56_3 * var_56_0[var_56_2] do
			if var_56_1[iter_56_0] == arg_56_1 then
				return iter_56_0
			end
		end
	else
		local var_56_4 = var_0_3.TEAM_SUM

		for iter_56_1 = 1, var_56_4[arg_56_0.topTab:read()] do
			if arg_56_0.clientBattleCards:read()[iter_56_1] == arg_56_1 then
				return iter_56_1
			end
		end
	end
end

function var_0_2.canBattleUp(arg_57_0)
	local var_57_0 = var_0_3.TEAM_NUM
	local var_57_1 = arg_57_0.clientBattleCards:read()
	local var_57_2 = arg_57_0.topTab:read()
	local var_57_3 = arg_57_0.leftTab:read()

	return arg_57_0:calcCardsNum(var_57_1, var_57_2, var_57_3) < var_57_0[var_57_2]
end

return var_0_2
