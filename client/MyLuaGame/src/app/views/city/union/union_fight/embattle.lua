local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("EmbattleView", var_0_0)
local var_0_2 = 6
local var_0_3 = 12
local var_0_4 = {
	{
		1,
		2,
		3,
		4,
		5,
		6
	},
	{
		1,
		2,
		3,
		4,
		5,
		6
	}
}
local var_0_5 = {
	6,
	6,
	6,
	8,
	12
}

local function var_0_6(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:x()
	local var_1_1 = arg_1_1:x()
	local var_1_2 = arg_1_0:width()
	local var_1_3 = arg_1_1:width()

	arg_1_0:x(var_1_0 - (var_1_3 - var_1_2) / 2 + 30)
	arg_1_1:x(var_1_1 - (var_1_3 - var_1_2) / 2 + 40)
end

local var_0_7 = {
	{
		cc.p(630, 425),
		cc.p(1350, 425)
	},
	{
		cc.p(570, 425),
		cc.p(1210, 425),
		cc.p(1850, 425)
	}
}

var_0_1.RESOURCE_FILENAME = "union_embattle.json"
var_0_1.RESOURCE_BINDING = {
	right = "right",
	["upPosition.strengthNum"] = "strengthNum",
	movecard = "movecard",
	upPosition = "upPosition",
	leftitem = "leftitem",
	battlePanel = "battlePanel",
	["rightPanel.item"] = "natureLimitItem",
	bottomPanel = "bottomPanel",
	rightPanel = "rightPanel",
	btnOneKeySet = {
		varname = "rightDown",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("oneKeyEmbattleBtn")
			}
		}
	},
	leftList = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				padding = 4,
				data = bindHelper.self("leftData"),
				item = bindHelper.self("leftitem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("name", "line", "btn")

					if arg_2_3.select then
						var_2_0.btn:visible(true)
						var_2_0.btn:get("title"):text(arg_2_3.text)
						text.addEffect(var_2_0.btn:get("title"), {
							outline = {
								color = ui.NEWCOLORS.OUTLINE.YELLOW1
							}
						})
					else
						var_2_0.btn:visible(false)
					end

					var_2_0.name:text(arg_2_3.text)
					var_2_0.name:setOpacity(178)
					text.addEffect(var_2_0.name, {
						outline = {
							size = 2,
							color = cc.c4b(255, 252, 237, 255)
						}
					})
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("clickBtn")
			}
		}
	},
	["btnOneKeySet.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["upPosition.icon.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.NORMAL.BLACK
					}
				}
			}
		}
	},
	["upPosition.icon.title1"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.NORMAL.BLACK
					}
				}
			}
		}
	},
	["upPosition.title"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.NORMAL.BLACK
					}
				}
			}
		}
	},
	["upPosition.count"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						color = ui.COLORS.NORMAL.BLACK
					}
				}
			}
		}
	},
	["rightPanel.text1"] = {
		varname = "text",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.BLACK
				}
			}
		}
	},
	["rightPanel.list"] = {
		varname = "natureLimitList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("natureLimitData"),
				item = bindHelper.self("natureLimitItem"),
				onItem = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:texture(ui.ATTR_ICON[arg_3_3])
				end
			}
		}
	},
	title = {
		varname = "title",
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(133, 82, 15, 255)
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0)
	gGameUI.topuiManager:createView("title", arg_4_0, {
		onClose = arg_4_0:createHandler("onClose")
	}):init({
		subTitle = "FORMATION",
		title = "common/txt/txt_bt_wodeduiwu.png"
	})
	arg_4_0.text:getVirtualRenderer():setLineSpacing(-15)
	adapt.setAutoMultiLine(arg_4_0.text, nil, 800, -10)

	arg_4_0.dbidData = {}
	arg_4_0.nature_limit = {}

	arg_4_0:initModel()
	arg_4_0:initStartInfo()
	arg_4_0:updateData()
	arg_4_0:initHeroSprite()
	arg_4_0:initBottomList()
	arg_4_0:initScreenView()
	arg_4_0.btnTab:addListener(function(arg_5_0, arg_5_1, arg_5_2)
		arg_4_0.leftData:atproxy(arg_5_1).select = false
		arg_4_0.leftData:atproxy(arg_5_0).select = true
	end)
	idlereasy.when(gGameModel.union_fight:getIdler("round"), function(arg_6_0, arg_6_1)
		if arg_4_0.wday == arg_4_0.btnState + 1 and (arg_6_1 == "battle" or arg_6_1 == "prepare") then
			arg_4_0.title:visible(true)
			arg_4_0.title:text(gLanguageCsv.unionfightDeployLimit)
		end
	end)
end

function var_0_1.initModel(arg_7_0)
	arg_7_0.cards = gGameModel.role:getIdler("cards")
	arg_7_0.clientBattleCards = idlertable.new({
		{},
		{},
		{}
	})
	arg_7_0.battleCardsData = idlertable.new({})
	arg_7_0.allCardDatas = idlers.new({})
	arg_7_0.natureLimitData = idlers.new({})
	arg_7_0.selectIndex = idlertable.new({})
	arg_7_0.btnTab = idler.new(1)
	arg_7_0.leftData = idlers.newWithMap({
		{
			card_id = 1,
			text = gLanguageCsv.firstRound
		},
		{
			card_id = 2,
			text = gLanguageCsv.theSecondRound
		},
		{
			card_id = 3,
			text = gLanguageCsv.thridRound
		},
		{
			card_id = 4,
			text = gLanguageCsv.theFourthRoundOf
		},
		{
			card_id = 5,
			text = gLanguageCsv.BattleLine
		}
	})
end

function var_0_1.initStartInfo(arg_8_0)
	for iter_8_0, iter_8_1 in orderCsvPairs(csv.union_fight.nature_limit) do
		arg_8_0.nature_limit[iter_8_1.weekDay] = iter_8_1.natureLimit
	end

	local var_8_0 = time.getNowDate().wday

	arg_8_0.wday = var_8_0 == 1 and 7 or var_8_0 - 1
	arg_8_0.unionCombet = arg_8_0.wday == 7 and true
	arg_8_0.wday = arg_8_0.wday == 7 and 2 or arg_8_0.wday
	arg_8_0.btnState = arg_8_0.wday - 1

	arg_8_0.natureLimitData:update(arg_8_0.nature_limit[arg_8_0.wday])
	arg_8_0.btnTab:set(arg_8_0.btnState)
end

function var_0_1.updateData(arg_9_0)
	local var_9_0 = gGameModel.union_fight:read("role_info").cards
	local var_9_1 = {
		{},
		{},
		{}
	}

	arg_9_0.cardsNumAll = false

	local var_9_2 = arg_9_0.btnState < 5 and 2 or 3

	for iter_9_0 = 1, var_9_2 do
		if itertools.size(var_9_0[arg_9_0.btnState + 1][iter_9_0]) <= 0 then
			arg_9_0.cardsNumAll = true
		end
	end

	for iter_9_1, iter_9_2 in pairs(var_9_0[arg_9_0.btnState + 1]) do
		var_9_1[iter_9_1] = {}

		for iter_9_3 = 1, var_0_2 do
			local var_9_3 = iter_9_2[iter_9_3]

			if var_9_3 and csvSize(var_9_3) >= 1 then
				var_9_1[iter_9_1][iter_9_3] = {
					dbid = var_9_3[1],
					fighting_point = var_9_3[4],
					level = var_9_3[5],
					star = var_9_3[6],
					advance = var_9_3[7],
					card_id = var_9_3[2],
					skin_id = var_9_3[3]
				}
				arg_9_0.dbidData[var_9_3[1]] = 1
			end
		end
	end

	arg_9_0.battleCardsData:set(var_9_1)
	arg_9_0.clientBattleCards:set(var_9_1)

	local var_9_4 = arg_9_0.cards:read()
	local var_9_5 = {}
	local var_9_6 = {}
	local var_9_7 = os.clock()

	for iter_9_4, iter_9_5 in ipairs(var_9_4) do
		local var_9_8 = true
		local var_9_9 = gGameModel.cards:find(iter_9_5):read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time", "nature_choose")
		local var_9_10 = csv.cards[var_9_9.card_id]
		local var_9_11 = csv.unit[var_9_10.unitID]
		local var_9_12 = arg_9_0.nature_limit[arg_9_0.btnState + 1]

		if itertools.size(var_9_12) > 0 then
			var_9_8 = itertools.include(var_9_12, var_9_11.natureType) or itertools.include(var_9_12, var_9_11.natureType2)
		end

		if var_9_8 then
			var_9_5[iter_9_5] = arg_9_0:limtFunc(iter_9_5, var_9_9.card_id, var_9_9.skin_id, var_9_9.fighting_point, var_9_9.level, var_9_9.star, var_9_9.advance, var_9_9.created_time, var_9_9.nature_choose, arg_9_0.dbidData[iter_9_5] and 1 or 0)

			table.insert(var_9_6, var_9_5[iter_9_5])
		end
	end

	arg_9_0.oneKeyAllCards = var_9_6
end

function var_0_1.clickBtn(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_0.btnTab:read() ~= arg_10_3.card_id then
		arg_10_0:sendRequeat(function(...)
			return
		end, true, true)
		arg_10_0.btnTab:set(arg_10_3.card_id)

		arg_10_0.btnState = arg_10_3.card_id

		arg_10_0:initScreenView()
		arg_10_0.natureLimitData:update(arg_10_0.nature_limit[arg_10_3.card_id + 1])

		arg_10_0.dbidData = {}

		arg_10_0:updateData()
		arg_10_0:initHeroSprite()
	end
end

function var_0_1.initScreenView(arg_12_0)
	local var_12_0 = arg_12_0:unionState()

	cache.setShader(arg_12_0.cardListView.bagFilter, false, var_12_0 and "normal" or "hsl_gray")
	arg_12_0.cardListView.bagFilter.selBtn:setTouchEnabled(var_12_0)
	arg_12_0.cardListView.bagFilter:initData()
end

function var_0_1.initBottomList(arg_13_0)
	arg_13_0.cardListView = gGameUI:createView("city.card.embattle.union_fight_card_list", arg_13_0.bottomPanel):init({
		base = arg_13_0,
		clientBattleCards = arg_13_0.clientBattleCards,
		battleCardsData = arg_13_0.battleCardsData,
		deleteMovingItem = arg_13_0.deleteMovingItem,
		createMovePanel = arg_13_0.createMovePanel,
		moveMovePanel = arg_13_0.moveMovePanel,
		isMovePanelExist = arg_13_0.isMovePanelExist,
		onCardClick = arg_13_0.onCardClick,
		allCardDatas = arg_13_0.allCardDatas,
		moveEndMovePanel = arg_13_0.moveEndMovePanel,
		limtFunc = arg_13_0.limtFunc
	}, false)

	arg_13_0.cardListView:y(arg_13_0.cardListView:y() - 57)
	arg_13_0.cardListView.btnPanel:y(arg_13_0.cardListView.btnPanel:y() - 7)
end

function var_0_1.createMovePanel(arg_14_0, arg_14_1)
	if not arg_14_0:unionState() then
		return
	end

	if not arg_14_1 then
		return
	end

	if not gGameModel.cards:find(arg_14_1.dbid) then
		return
	end

	if arg_14_0.movePanel then
		arg_14_0.movePanel:removeSelf()
	end

	local var_14_0 = arg_14_0.movecard:clone():addTo(arg_14_0:getResourceNode(), 1000)

	var_14_0:scale(0.9)

	arg_14_0.movePanel = var_14_0

	return arg_14_0:itemSkin(var_14_0, arg_14_1.dbid)
end

function var_0_1.deleteMovingItem(arg_15_0)
	if not arg_15_0:unionState() then
		return
	end

	arg_15_0.selectIndex:set({
		0,
		0
	})

	if arg_15_0.movePanel then
		arg_15_0.movePanel:removeSelf()

		arg_15_0.movePanel = nil
	end
end

function var_0_1.moveMovePanel(arg_16_0, arg_16_1)
	if not arg_16_0:unionState() then
		return
	end

	if arg_16_0.movePanel then
		arg_16_0.movePanel:xy(arg_16_1)

		local var_16_0, var_16_1, var_16_2 = arg_16_0:whichEmbattleTargetPos(arg_16_1)

		arg_16_0.selectIndex:set({
			var_16_1,
			var_16_2
		})
	end
end

function var_0_1.isMovePanelExist(arg_17_0)
	return arg_17_0.movePanel ~= nil
end

function var_0_1.moveEndMovePanel(arg_18_0, arg_18_1)
	if not arg_18_0.movePanel then
		return
	end

	local var_18_0 = arg_18_0.selectIndex:read()

	if var_18_0[1] and var_18_0[2] then
		arg_18_0:resetBattle(var_18_0[1], var_18_0[2], arg_18_1)
	end

	arg_18_0:deleteMovingItem()
end

function var_0_1.onCardClick(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0:unionState() then
		return
	end

	if arg_19_1.inMeteor then
		gGameUI:showTip(gLanguageCsv.cardInMeteorites)

		return
	end

	local var_19_0
	local var_19_1 = arg_19_1.dbid
	local var_19_2 = arg_19_0:getIdxByDbId(var_19_1)

	if arg_19_1.battle > 0 then
		if arg_19_0:spriteNumber(var_19_1) > 1 then
			arg_19_0:downHero(var_19_1, true)
		else
			var_19_0 = gLanguageCsv.battleCannotEmpty
		end
	else
		local var_19_3, var_19_4, var_19_5 = arg_19_0:spriteNumber(var_19_1)

		if var_19_5 <= var_19_4 then
			var_19_0 = gLanguageCsv.battleCardCountEnough
		elseif arg_19_0:hasSameMarkIDCard(arg_19_1.card_id) then
			var_19_0 = gLanguageCsv.alreadyHaveSameSprite
		else
			arg_19_0:upHero(var_19_1, false)
		end
	end

	if arg_19_2 and var_19_0 then
		gGameUI:showTip(var_19_0)
	end
end

function var_0_1.itemSkin(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = gGameModel.cards:find(arg_20_2)
	local var_20_1 = var_20_0:read("card_id")
	local var_20_2 = var_20_0:read("skin_id")
	local var_20_3 = var_20_0:read("advance")
	local var_20_4 = var_20_0:read("level")
	local var_20_5 = csv.cards[var_20_1]
	local var_20_6 = csv.unit[var_20_5.unitID]
	local var_20_7 = dataEasy.getUnitId(var_20_1, var_20_2)

	bind.extend(arg_20_0, arg_20_1, {
		class = "card_icon",
		props = {
			unitId = var_20_7,
			rarity = var_20_6.rarity,
			advance = var_20_3,
			star = arg_20_3,
			levelProps = {
				data = var_20_4
			}
		}
	})

	return arg_20_1
end

function var_0_1.unionState(arg_21_0)
	local var_21_0 = gGameModel.union_fight:read("round")

	if arg_21_0.cardsNumAll then
		return false
	end

	if arg_21_0.wday > arg_21_0.btnState + 1 or arg_21_0.wday == 7 then
		return false
	end

	if arg_21_0.wday == arg_21_0.btnState + 1 and var_21_0 == "over" then
		return false
	end

	if (var_21_0 == "battle" or var_21_0 == "prepare") and arg_21_0.wday == arg_21_0.btnState + 1 then
		gGameUI:showTip(gLanguageCsv.unionfightDeployLimit)

		return false
	end

	if arg_21_0.unionCombet then
		return false
	end

	return true
end

function var_0_1.initHeroSprite(arg_22_0)
	local var_22_0 = gGameModel.union_fight:read("round")

	arg_22_0.title:visible(false)

	if arg_22_0.wday > arg_22_0.btnState + 1 or arg_22_0.wday == 7 then
		arg_22_0.title:visible(true)
		arg_22_0.title:text(gLanguageCsv.combatFinish)
	end

	if arg_22_0.wday == arg_22_0.btnState + 1 and (var_22_0 == "battle" or var_22_0 == "prepare") then
		arg_22_0.title:visible(true)
		arg_22_0.title:text(gLanguageCsv.unionfightDeployLimit)
	end

	if arg_22_0.wday == arg_22_0.btnState + 1 and var_22_0 == "over" then
		arg_22_0.title:visible(true)
		arg_22_0.title:text(gLanguageCsv.combatFinish)
	end

	if arg_22_0.cardsNumAll then
		arg_22_0.title:visible(true)
		arg_22_0.title:text(gLanguageCsv.cardsNotNum)
	end

	if arg_22_0.unionCombet then
		arg_22_0.title:visible(true)
		arg_22_0.title:text(gLanguageCsv.combatFinish)
	end

	arg_22_0.battlePanel:removeAllChildren()

	arg_22_0.heroSprite = {}

	arg_22_0.upPosition:visible(false)

	local var_22_1 = arg_22_0.btnState < 5 and 1 or 2
	local var_22_2 = arg_22_0.btnState < 5 and 1 or 2
	local var_22_3 = arg_22_0.btnState < 5 and 2 or 3

	arg_22_0.rightPanel:visible(var_22_2 ~= 2)

	local var_22_4 = arg_22_0.btnState <= 4 and 3 or 4

	arg_22_0.fightingTab = {}
	arg_22_0.panelTab = {}

	local var_22_5
	local var_22_6
	local var_22_7
	local var_22_8
	local var_22_9
	local var_22_10
	local var_22_11

	for iter_22_0 = 1, var_22_3 do
		local var_22_12 = 0
		local var_22_13 = 0
		local var_22_14 = arg_22_0.clientBattleCards:read()[iter_22_0]
		local var_22_15 = arg_22_0.upPosition:clone():addTo(arg_22_0.battlePanel, 999, "name" .. iter_22_0)

		adapt.setAutoText(var_22_15:get("behind"), nil, 120)
		adapt.setAutoText(var_22_15:get("front"), nil, 120)
		var_22_15:xy(var_0_7[var_22_1][iter_22_0])
		var_22_15:visible(true)
		var_22_15:get("icon"):get("title1"):text(iter_22_0)

		arg_22_0.heroSprite[iter_22_0] = {}
		arg_22_0.panelTab[iter_22_0] = {}
		arg_22_0.panelTab[iter_22_0].panel = var_22_15

		if not var_22_14 then
			return false
		end

		for iter_22_1 = 1, var_0_2 do
			local var_22_16 = var_22_15:get("icon" .. iter_22_1)

			if var_22_14[iter_22_1] and csvSize(var_22_14[iter_22_1]) > 1 then
				var_22_13 = var_22_13 + 1

				local var_22_17 = var_22_14[iter_22_1].card_id

				var_22_12 = var_22_12 + var_22_14[iter_22_1].fighting_point

				local var_22_18 = var_22_14[iter_22_1].advance

				var_22_7 = csv.cards[var_22_17]

				local var_22_19 = csv.unit[var_22_7.unitID]
				local var_22_20 = dataEasy.getUnitId(var_22_14[iter_22_1].card_id, var_22_14[iter_22_1].skin_id)

				bind.extend(arg_22_0, var_22_16, {
					class = "card_icon",
					props = {
						unitId = var_22_20,
						rarity = var_22_19.rarity,
						advance = var_22_18,
						star = var_22_14[iter_22_1].star,
						levelProps = {
							data = var_22_14[iter_22_1].level
						}
					}
				})
				var_22_16:scale(0.9)
				var_22_16:show()
			end

			var_22_16:onTouch(functools.partial(arg_22_0.onBattleCardTouch, arg_22_0, iter_22_0, iter_22_1))

			arg_22_0.heroSprite[iter_22_0][iter_22_1] = {}
			arg_22_0.heroSprite[iter_22_0][iter_22_1] = {
				sprite = var_22_16,
				dbid = var_22_14[iter_22_1] and var_22_14[iter_22_1].dbid or nil,
				markId = var_22_7 and var_22_7.cardMarkID or nil
			}
		end

		arg_22_0.fightingTab[iter_22_0] = var_22_12

		var_22_15:get("count"):text(var_22_13 .. "/" .. var_22_4)
		var_22_15:get("strengthNum"):setString(var_22_12)
	end
end

function var_0_1.onBattleCardTouch(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if not arg_23_0:unionState() then
		return
	end

	local var_23_0 = arg_23_0.clientBattleCards:read()[arg_23_1][arg_23_2]

	if itertools.isempty(var_23_0) then
		return
	end

	if var_23_0.inMeteor then
		gGameUI:showTip(gLanguageCsv.cardInMeteorites)

		return
	end

	if arg_23_3.name == "began" then
		arg_23_0.moved = false

		arg_23_0:createMovePanel(var_23_0)
	elseif arg_23_3.name == "moved" then
		arg_23_0.moved = true

		arg_23_0:moveMovePanel(arg_23_3)
	elseif arg_23_3.name == "ended" or arg_23_3.name == "cancelled" then
		if not var_23_0 then
			arg_23_0:deleteMovingItem()

			return
		end

		if arg_23_0.moved == false or arg_23_3.y < 340 then
			if arg_23_0:spriteNumber(var_23_0.dbid) > 1 then
				arg_23_0:downHero(var_23_0.dbid, true)
			else
				gGameUI:showTip(gLanguageCsv.battleCannotEmpty)
			end
		else
			local var_23_1, var_23_2, var_23_3 = arg_23_0:whichEmbattleTargetPos(arg_23_3)

			arg_23_0:changeHero(var_23_0.dbid, var_23_1, var_23_2, var_23_3)
		end

		arg_23_0:deleteMovingItem()
	end
end

function var_0_1.oneKeyEmbattleBtn(arg_24_0)
	if not arg_24_0:unionState() then
		return
	end

	if arg_24_0.cardsNumAll then
		return
	end

	local var_24_0
	local var_24_1

	if arg_24_0.btnState <= 4 then
		var_24_0 = 3

		local var_24_2 = 6
	else
		var_24_0 = 4

		local var_24_3 = 12
	end

	local var_24_4 = 0
	local var_24_5 = arg_24_0.btnState < 5 and 2 or 3

	for iter_24_0 = 1, var_24_5 do
		for iter_24_1 = 1, 6 do
			arg_24_0.clientBattleCards:modify(function(arg_25_0)
				if arg_25_0[iter_24_0][iter_24_1] and arg_24_0.allCardDatas:atproxy(arg_25_0[iter_24_0][iter_24_1].dbid) then
					arg_24_0.allCardDatas:atproxy(arg_25_0[iter_24_0][iter_24_1].dbid).battle = 0
				end

				return true, arg_25_0
			end)
		end
	end

	if arg_24_0.oneKeyAllCards then
		table.sort(arg_24_0.oneKeyAllCards, function(arg_26_0, arg_26_1)
			if arg_26_0.fighting_point ~= arg_26_1.fighting_point then
				return arg_26_0.fighting_point > arg_26_1.fighting_point
			end

			return arg_26_0.rarity > arg_26_1.rarity
		end)

		arg_24_0.oneKeyCards = {}

		local var_24_6 = {}
		local var_24_7 = 0

		for iter_24_2, iter_24_3 in ipairs(arg_24_0.oneKeyAllCards) do
			if not var_24_6[iter_24_3.markId] and not iter_24_3.inMeteor then
				var_24_6[iter_24_3.markId] = true

				table.insert(arg_24_0.oneKeyCards, iter_24_3.dbid)

				var_24_7 = var_24_7 + 1

				if var_24_7 == var_0_3 then
					break
				end
			end
		end

		arg_24_0.oneKeyAllCards = nil
	end

	for iter_24_4 = 1, var_0_2 do
		for iter_24_5 = 1, var_24_5 do
			arg_24_0.clientBattleCards:modify(function(arg_27_0)
				if iter_24_4 <= var_24_0 then
					var_24_4 = var_24_4 + 1

					if arg_24_0.oneKeyCards[var_24_4] then
						if arg_24_0.allCardDatas:atproxy(arg_24_0.oneKeyCards[var_24_4]) then
							arg_24_0.allCardDatas:atproxy(arg_24_0.oneKeyCards[var_24_4]).battle = 1
						end

						local var_27_0 = gGameModel.cards:find(arg_24_0.oneKeyCards[var_24_4])
						local var_27_1 = var_27_0:read("card_id")
						local var_27_2 = var_27_0:read("skin_id")
						local var_27_3 = csv.cards[var_27_1]
						local var_27_4 = var_27_0:read("level")
						local var_27_5 = var_27_0:read("star")
						local var_27_6 = var_27_0:read("fighting_point")
						local var_27_7 = var_27_0:read("advance")

						arg_27_0[iter_24_5][iter_24_4] = {
							dbid = arg_24_0.oneKeyCards[var_24_4],
							fighting_point = var_27_6,
							level = var_27_4,
							star = var_27_5,
							advance = var_27_7,
							card_id = var_27_1,
							skin_id = var_27_2
						}
					else
						arg_27_0[iter_24_5][iter_24_4] = {}
					end
				else
					arg_27_0[iter_24_5][iter_24_4] = {}
				end

				return true, arg_27_0
			end)
		end
	end

	gGameUI:showTip(gLanguageCsv.addToEmbattle)
	arg_24_0:initHeroSprite()
end

function var_0_1.whichEmbattleTargetPos(arg_28_0, arg_28_1)
	for iter_28_0, iter_28_1 in pairs(arg_28_0.heroSprite) do
		for iter_28_2, iter_28_3 in pairs(iter_28_1) do
			local var_28_0 = iter_28_3.sprite
			local var_28_1 = var_28_0:box()
			local var_28_2 = var_28_0:getParent():convertToWorldSpace(cc.p(var_28_1.x, var_28_1.y))

			var_28_1.x, var_28_1.y = var_28_2.x, var_28_2.y

			if cc.rectContainsPoint(var_28_1, arg_28_1) then
				return iter_28_3.dbid, iter_28_0, iter_28_2
			end
		end
	end
end

function var_0_1.spriteNumber(arg_29_0, arg_29_1)
	local var_29_0 = 0
	local var_29_1 = 0
	local var_29_2 = 0
	local var_29_3
	local var_29_4 = arg_29_0.btnState <= 4 and 6 or 12

	for iter_29_0, iter_29_1 in pairs(arg_29_0.heroSprite) do
		for iter_29_2, iter_29_3 in pairs(iter_29_1) do
			if iter_29_3.dbid then
				var_29_0 = var_29_0 + 1
			end

			if iter_29_3.dbid == arg_29_1 then
				var_29_3 = iter_29_0
			end
		end
	end

	if var_29_3 then
		for iter_29_4, iter_29_5 in pairs(arg_29_0.heroSprite[var_29_3]) do
			if iter_29_5.dbid then
				var_29_1 = var_29_1 + 1
			end
		end
	end

	return var_29_1, var_29_0, var_29_4, var_29_3
end

function var_0_1.getIdxByDbId(arg_30_0, arg_30_1)
	if not arg_30_1 then
		return
	end

	for iter_30_0, iter_30_1 in pairs(arg_30_0.heroSprite) do
		for iter_30_2, iter_30_3 in pairs(iter_30_1) do
			if iter_30_3.dbid == arg_30_1 then
				return iter_30_0, iter_30_2
			end
		end
	end
end

function var_0_1.hasSameMarkIDCard(arg_31_0, arg_31_1)
	local var_31_0 = csv.cards[arg_31_1].cardMarkID

	for iter_31_0, iter_31_1 in pairs(arg_31_0.heroSprite) do
		for iter_31_2, iter_31_3 in pairs(iter_31_1) do
			if iter_31_3.markId == var_31_0 then
				return true
			end
		end
	end

	return false
end

function var_0_1.downHero(arg_32_0, arg_32_1, arg_32_2)
	if arg_32_1 then
		if arg_32_0.allCardDatas:atproxy(arg_32_1) then
			arg_32_0.allCardDatas:atproxy(arg_32_1).battle = 0
		end

		local var_32_0, var_32_1 = arg_32_0:getIdxByDbId(arg_32_1)

		arg_32_0.clientBattleCards:modify(function(arg_33_0)
			arg_32_0.dbidData[arg_32_1] = nil
			arg_33_0[var_32_0][var_32_1] = nil

			arg_32_0.heroSprite[var_32_0][var_32_1].sprite:hide()

			arg_32_0.heroSprite[var_32_0][var_32_1].dbid = nil
			arg_32_0.heroSprite[var_32_0][var_32_1].markId = nil

			local var_33_0 = arg_32_0.fightingTab[var_32_0] - gGameModel.cards:find(arg_32_1):read("fighting_point")

			arg_32_0.panelTab[var_32_0].panel:get("strengthNum"):setString(var_33_0)

			arg_32_0.fightingTab[var_32_0] = var_33_0

			return true, arg_33_0
		end)
		arg_32_0:initHeroSprite()

		if arg_32_2 then
			gGameUI:showTip(gLanguageCsv.downToEmbattle)
		end
	end
end

function var_0_1.upHero(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local function var_34_0(arg_35_0)
		local var_35_0 = arg_34_0.btnState <= 4 and 3 or 4
		local var_35_1 = 0

		for iter_35_0, iter_35_1 in pairs(arg_34_0.heroSprite[arg_35_0]) do
			if iter_35_1.dbid then
				var_35_1 = var_35_1 + 1
			end
		end

		if var_35_0 <= var_35_1 then
			return false
		end

		return true
	end

	local var_34_1
	local var_34_2
	local var_34_3 = false
	local var_34_4 = arg_34_0.btnState < 5 and 2 or 3

	if not arg_34_2 then
		for iter_34_0 = 1, var_0_2 do
			for iter_34_1 = 1, var_34_4 do
				if itertools.isempty(arg_34_0.clientBattleCards:read()[iter_34_1][iter_34_0]) and not var_34_3 and var_34_0(iter_34_1) then
					var_34_1, var_34_2 = iter_34_1, iter_34_0
					var_34_3 = true

					break
				end
			end

			if var_34_3 then
				break
			end
		end
	else
		var_34_1, var_34_2 = arg_34_3, arg_34_4
	end

	arg_34_0.clientBattleCards:modify(function(arg_36_0)
		if arg_34_0.allCardDatas:atproxy(arg_34_1) then
			arg_34_0.allCardDatas:atproxy(arg_34_1).battle = 1
		end

		arg_34_0.dbidData[arg_34_1] = 1

		local var_36_0 = gGameModel.cards:find(arg_34_1)
		local var_36_1 = var_36_0:read("card_id")
		local var_36_2 = var_36_0:read("skin_id")
		local var_36_3 = var_36_0:read("advance")
		local var_36_4 = csv.cards[var_36_1]
		local var_36_5 = var_36_0:read("level")
		local var_36_6 = var_36_0:read("star")
		local var_36_7 = var_36_0:read("fighting_point")

		arg_36_0[var_34_1][var_34_2] = {
			dbid = arg_34_1,
			fighting_point = var_36_7,
			level = var_36_5,
			star = var_36_6,
			advance = var_36_3,
			card_id = var_36_1,
			skin_id = var_36_2
		}

		local var_36_8 = arg_34_0.panelTab[var_34_1].panel:get("icon" .. var_34_2)

		arg_34_0.heroSprite[var_34_1][var_34_2] = {
			sprite = var_36_8,
			dbid = arg_34_1,
			markId = var_36_4.cardMarkID
		}

		arg_34_0:itemSkin(var_36_8, arg_34_1)
		var_36_8:show()

		local var_36_9 = arg_34_0.fightingTab[var_34_1] + var_36_7

		arg_34_0.fightingTab[var_34_1] = var_36_9

		arg_34_0.panelTab[var_34_1].panel:get("strengthNum"):setString(var_36_9)

		return true, arg_36_0
	end, true)
	audio.playEffectWithWeekBGM("formation.mp3")
	gGameUI:showTip(gLanguageCsv.addToEmbattle)
	arg_34_0:initHeroSprite()
end

function var_0_1.cardNumberFunc(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.btnState <= 4 and 3 or 4
	local var_37_1 = 0

	for iter_37_0, iter_37_1 in pairs(arg_37_0.heroSprite[arg_37_1]) do
		if iter_37_1.dbid then
			var_37_1 = var_37_1 + 1
		end
	end

	if var_37_0 <= var_37_1 then
		return false
	end

	return true
end

function var_0_1.equalCardMarkView(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_1 or not arg_38_2 then
		return false
	end

	if csv.cards[arg_38_1].cardMarkID == csv.cards[arg_38_2].cardMarkID then
		return true
	end

	return false
end

function var_0_1.resetBattle(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = arg_39_0.clientBattleCards:read()[arg_39_1][arg_39_2] and arg_39_0.clientBattleCards:read()[arg_39_1][arg_39_2].dbid or nil

	if arg_39_3.battle == 0 then
		if not var_39_0 then
			if arg_39_0:hasSameMarkIDCard(arg_39_3.card_id) then
				gGameUI:showTip(gLanguageCsv.alreadyHaveSameSprite)

				return
			elseif not arg_39_0:cardNumberFunc(arg_39_1) then
				gGameUI:showTip(gLanguageCsv.battleCardCountEnough)

				return
			end
		else
			local var_39_1 = gGameModel.cards:find(var_39_0):read("card_id")

			if arg_39_0:equalCardMarkView(var_39_1, arg_39_3.card_id) then
				arg_39_0:downHero(var_39_0, false)
				arg_39_0:upHero(arg_39_3.dbid, true, arg_39_1, arg_39_2)

				return
			end
		end

		if arg_39_0:hasSameMarkIDCard(arg_39_3.card_id) then
			gGameUI:showTip(gLanguageCsv.alreadyHaveSameSprite)

			return
		else
			arg_39_0:downHero(var_39_0, false)
			arg_39_0:upHero(arg_39_3.dbid, true, arg_39_1, arg_39_2)
		end
	elseif var_39_0 then
		if var_39_0 == arg_39_3.dbid then
			return
		end

		arg_39_0:changeHero(var_39_0, arg_39_3.dbid)
	else
		arg_39_0:changeHero(arg_39_3.dbid, nil, arg_39_1, arg_39_2)
	end
end

function var_0_1.changeHero(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	if not arg_40_2 and not arg_40_3 then
		return
	end

	if not arg_40_2 then
		local var_40_0, var_40_1, var_40_2, var_40_3 = arg_40_0:spriteNumber(arg_40_1)
		local var_40_4 = 0

		if var_40_0 == 1 and var_40_3 ~= arg_40_3 then
			gGameUI:showTip(gLanguageCsv.battleNumberNo)

			return
		end

		local var_40_5 = arg_40_0.btnState < 5 and 3 or 4

		for iter_40_0, iter_40_1 in pairs(arg_40_0.heroSprite[arg_40_3]) do
			if iter_40_1.dbid then
				var_40_4 = var_40_4 + 1
			end
		end

		if var_40_4 == var_40_5 and var_40_3 ~= arg_40_3 then
			gGameUI:showTip(gLanguageCsv.battleCardCountEnough)

			return
		end
	end

	local var_40_6
	local var_40_7
	local var_40_8
	local var_40_9
	local var_40_10 = true
	local var_40_11 = true

	for iter_40_2, iter_40_3 in pairs(arg_40_0.heroSprite) do
		for iter_40_4, iter_40_5 in pairs(iter_40_3) do
			if iter_40_5.dbid == arg_40_1 and var_40_10 then
				var_40_6 = iter_40_2
				var_40_7 = iter_40_4
				var_40_10 = false
			end

			if arg_40_2 and iter_40_5.dbid == arg_40_2 and var_40_11 then
				var_40_8 = iter_40_2
				var_40_9 = iter_40_4
				var_40_11 = false
			end
		end
	end

	var_40_8 = var_40_8 or arg_40_3 or var_40_8
	var_40_9 = var_40_9 or arg_40_4 or var_40_9

	arg_40_0.clientBattleCards:modify(function(arg_41_0)
		arg_41_0[var_40_6][var_40_7], arg_41_0[var_40_8][var_40_9] = arg_41_0[var_40_8][var_40_9], arg_41_0[var_40_6][var_40_7]

		arg_40_0:initHeroSprite()

		return true, arg_41_0
	end)
end

function var_0_1.onClose(arg_42_0)
	arg_42_0:sendRequeat(functools.partial(var_0_0.onClose, arg_42_0), true)
end

function var_0_1.limtFunc(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9, arg_43_10)
	local var_43_0 = csv.cards[arg_43_2]
	local var_43_1 = csv.unit[var_43_0.unitID]
	local var_43_2 = arg_43_0.nature_limit[arg_43_0.btnState + 1]
	local var_43_3 = true

	if itertools.size(var_43_2) > 0 then
		local var_43_4 = csv.unit[var_43_0.unitID]

		var_43_3 = itertools.include(var_43_2, var_43_4.natureType) or itertools.include(var_43_2, var_43_4.natureType2)
	end

	if not var_43_3 then
		return nil
	end

	local var_43_5 = dataEasy.getInMeteorCardsHash()
	local var_43_6 = csv.cards[arg_43_2]
	local var_43_7 = csv.unit[var_43_6.unitID]
	local var_43_8 = dataEasy.getUnitId(arg_43_2, arg_43_3)

	return {
		card_id = arg_43_2,
		unit_id = var_43_8,
		rarity = var_43_7.rarity,
		attr1 = var_43_7.natureType,
		attr2 = var_43_7.natureType2,
		fighting_point = arg_43_4,
		level = arg_43_5,
		star = arg_43_6,
		getTime = arg_43_8,
		dbid = arg_43_1,
		advance = arg_43_7,
		battle = arg_43_10,
		markId = var_43_6.cardMarkID,
		atkType = var_43_6.atkType,
		nature_choose = arg_43_9,
		inMeteor = var_43_5[arg_43_1]
	}
end

function var_0_1.sendRequeat(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = {}
	local var_44_1 = {}
	local var_44_2 = {}
	local var_44_3 = {}
	local var_44_4

	var_44_4 = arg_44_0.btnState < 5 and 2 or 3

	local var_44_5

	var_44_5 = arg_44_0.btnState > 4 and 4 or 3

	local var_44_6 = arg_44_0.btnState < 5 and 2 or 3

	for iter_44_0 = 1, var_44_6 do
		var_44_0[iter_44_0] = {}

		for iter_44_1 = 1, var_0_2 do
			if arg_44_0.clientBattleCards:read()[iter_44_0][iter_44_1] and arg_44_0.clientBattleCards:read()[iter_44_0][iter_44_1].dbid then
				var_44_0[iter_44_0][iter_44_1] = arg_44_0.clientBattleCards:read()[iter_44_0][iter_44_1].dbid
			else
				var_44_0[iter_44_0][iter_44_1] = ""
			end
		end
	end

	local var_44_7 = gGameModel.union_fight:read("role_info").cards

	for iter_44_2, iter_44_3 in pairs(var_44_7[arg_44_0.btnState + 1]) do
		var_44_1[iter_44_2] = {}

		for iter_44_4 = 1, var_0_2 do
			if iter_44_3[iter_44_4] and csvSize(iter_44_3[iter_44_4]) >= 1 then
				var_44_1[iter_44_2][iter_44_4] = iter_44_3[iter_44_4][1]
			else
				var_44_1[iter_44_2][iter_44_4] = ""
			end
		end
	end

	local var_44_8 = itertools.equal(var_44_0, var_44_1)

	if arg_44_3 then
		if not var_44_8 then
			gGameApp:requestServer("/game/union/fight/battle/deploy", function(arg_45_0)
				gGameUI:showTip(gLanguageCsv.positionSave)
			end, arg_44_0.btnState + 1, var_44_0)

			return
		end
	elseif not var_44_8 then
		if not arg_44_0.clientBattleCards:read() then
			if arg_44_2 then
				arg_44_1()
			else
				gGameUI:showTip(gLanguageCsv.lineupInconsistency)
			end

			return
		end

		gGameApp:requestServer("/game/union/fight/battle/deploy", function(arg_46_0)
			var_0_0.onClose(arg_44_0)
			gGameUI:showTip(gLanguageCsv.positionSave)
		end, arg_44_0.btnState + 1, var_44_0)
	else
		arg_44_1()
	end
end

return var_0_1
