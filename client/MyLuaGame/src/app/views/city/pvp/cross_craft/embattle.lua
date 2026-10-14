local var_0_0 = require("app.views.city.pvp.cross_craft.view")
local var_0_1 = cc.load("mvc").ViewBase
local var_0_2 = class("CrossCraftEmbattleView", var_0_1)
local var_0_3 = 12

var_0_2.RESOURCE_FILENAME = "cross_craft_embattle.json"
var_0_2.RESOURCE_BINDING = {
	["up.list"] = "upList",
	["up.item"] = "upItem",
	["up.groupItem"] = "upGroupItem",
	["prepare.round"] = "prepareRound",
	up = "upPanel",
	["prepare.title"] = "prepareTitle",
	item = "item",
	["up.special"] = "upSpecialPanel",
	down = "downPanel",
	["down.emptyTip"] = "downEmptyTip",
	prepare = "preparePanel",
	["item.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["up.text"] = {
		varname = "upText"
	},
	["up.countdown"] = {
		varname = "upCountdown"
	},
	["down.num"] = {
		varname = "downNum"
	},
	["down.btnOneKey"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOneKeyClick")
			}
		}
	},
	["down.btnSave"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSaveClick")
			}
		}
	},
	["down.btnSave.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["down.btnOneKey.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["prepare.btnSave"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSaveClick")
			}
		}
	},
	["prepare.btnCancle"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["prepare.btnSave.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["prepare.btnCancle.txt"] = {
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

function var_0_2.onCreate(arg_1_0)
	arg_1_0.node = arg_1_0:getResourceNode()
	arg_1_0.topuiView = gGameUI.topuiManager:createView("default", arg_1_0, {
		onClose = arg_1_0:createHandler("onClose")
	}):init({
		subTitle = "MY TEAM",
		title = "common/txt/txt_bt_wodeduiwu.png"
	})

	arg_1_0:enableSchedule()
	arg_1_0:initModel()
	arg_1_0:initUpPanel()
	arg_1_0:initBottomList()

	arg_1_0.showDownPanel = idler.new()

	idlereasy.when(arg_1_0.showDownPanel, function(arg_2_0, arg_2_1)
		arg_1_0:onBoardChange(arg_2_1)

		if arg_1_0.battleCardsObj then
			arg_1_0.battleCardsRect = {}

			for iter_2_0 = 1, var_0_3 do
				local var_2_0 = arg_1_0.battleCardsObj[iter_2_0]
				local var_2_1 = var_2_0:box()
				local var_2_2 = var_2_0:getParent():convertToWorldSpace(cc.p(var_2_1.x, var_2_1.y))

				var_2_1.x, var_2_1.y = var_2_2.x, var_2_2.y
				arg_1_0.battleCardsRect[iter_2_0] = var_2_1
			end
		end
	end, true)

	local var_1_0 = false

	idlereasy.when(arg_1_0.round, function(arg_3_0, arg_3_1)
		if var_1_0 and (arg_3_1 == "prepare" or string.find(arg_3_1, "_lock$")) then
			arg_1_0.ignoreCurMovingItem = true

			arg_1_0:deleteMovingItem()

			if arg_1_0:isCardChanged() then
				local var_3_0 = gGameModel.cross_craft:read("cards")

				arg_1_0.battleCards = table.deepcopy(var_3_0, true)

				arg_1_0.clientBattleCards:set(arg_1_0.battleCards)
				gGameUI:showTip(gLanguageCsv.crossCraftEmbattleBattleStart)
			end
		else
			var_1_0 = true
		end

		if arg_3_1 == "signup" then
			arg_1_0.showDownPanel:set(true)
		else
			arg_1_0.showDownPanel:set(false)
		end

		arg_1_0:setCountdownState(arg_3_1)
		arg_1_0:setTileState(arg_3_1)

		for iter_3_0 = 1, 4 do
			arg_1_0:refreshUpPanelResult(iter_3_0)
			arg_1_0:refreshUpPanelTitle(iter_3_0)
		end

		for iter_3_1 = 1, var_0_3 do
			arg_1_0:refreshBattleSprite(iter_3_1)
		end

		if arg_3_1 == "closed" then
			gGameUI:showTip(gLanguageCsv.crossCraftOver)
			performWithDelay(arg_1_0, function()
				var_0_1.onClose(arg_1_0)
			end, 0)

			return
		end
	end)
	idlereasy.when(arg_1_0.clientBattleCards, function(arg_5_0, arg_5_1)
		arg_1_0.downNum:text(string.format("%d/%d", arg_1_0.clientBattleCards:size(), var_0_3))
	end)
end

function var_0_2.initModel(arg_6_0)
	arg_6_0.round = gGameModel.cross_craft:getIdler("round")
	arg_6_0.allCardDatas = idlers.newWithMap({})

	local var_6_0 = gGameModel.cross_craft:read("cards")

	arg_6_0.clientBattleCards = idlertable.new(table.deepcopy(var_6_0, true))
	arg_6_0.selectIndex = idler.new(0)
end

function var_0_2.onClose(arg_7_0)
	if arg_7_0:isCardChanged() then
		gGameUI:showDialog({
			clearFast = true,
			btnType = 2,
			cb = function()
				arg_7_0:onSaveClick()
			end,
			cancelCb = function()
				var_0_1.onClose(arg_7_0)
			end,
			content = gLanguageCsv.isSaveCurBattle
		})
	else
		var_0_1.onClose(arg_7_0)
	end
end

function var_0_2.onBoardChange(arg_10_0, arg_10_1)
	if arg_10_1 then
		arg_10_0.upPanel:y(816)
		arg_10_0.preparePanel:hide()
		arg_10_0.downPanel:show()

		local var_10_0 = gGameModel.cross_craft:read("cards")
		local var_10_1 = gGameModel.role:read("cards")
		local var_10_2 = itertools.map(var_10_0, function(arg_11_0, arg_11_1)
			return arg_11_1, arg_11_0
		end)
		local var_10_3 = {}
		local var_10_4 = {}
		local var_10_5 = dataEasy.getInMeteorCardsHash()

		for iter_10_0, iter_10_1 in ipairs(var_10_1) do
			local var_10_6 = gGameModel.cards:find(iter_10_1):read("card_id", "skin_id", "fighting_point", "level", "star", "advance", "created_time")
			local var_10_7 = csv.cards[var_10_6.card_id]
			local var_10_8 = csv.unit[var_10_7.unitID]
			local var_10_9 = dataEasy.getUnitId(var_10_6.card_id, var_10_6.skin_id)

			var_10_3[iter_10_1] = {
				dbid = iter_10_1,
				unit_id = var_10_9,
				card_id = var_10_6.card_id,
				fighting_point = var_10_6.fighting_point,
				level = var_10_6.level,
				star = var_10_6.star,
				created_time = var_10_6.created_time,
				advance = var_10_6.advance,
				rarity = var_10_8.rarity,
				attr1 = var_10_8.natureType,
				attr2 = var_10_8.natureType2,
				battle = var_10_2[iter_10_1] and 1 or 0,
				markId = var_10_7.cardMarkID,
				atkType = var_10_7.atkType,
				inMeteor = var_10_5[iter_10_1]
			}

			table.insert(var_10_4, var_10_3[iter_10_1])
		end

		arg_10_0.allCardDatas:update(var_10_3)
		table.sort(var_10_4, function(arg_12_0, arg_12_1)
			if arg_12_0.fighting_point ~= arg_12_1.fighting_point then
				return arg_12_0.fighting_point > arg_12_1.fighting_point
			end

			return arg_12_0.rarity > arg_12_1.rarity
		end)

		arg_10_0.oneKeyCards = {}

		local var_10_10 = {}
		local var_10_11 = 0

		for iter_10_2, iter_10_3 in ipairs(var_10_4) do
			if not var_10_10[iter_10_3.markId] and not iter_10_3.inMeteor then
				var_10_10[iter_10_3.markId] = true

				table.insert(arg_10_0.oneKeyCards, iter_10_3.dbid)

				var_10_11 = var_10_11 + 1

				if var_10_11 == var_0_3 then
					break
				end
			end
		end
	else
		arg_10_0.upPanel:y(676)
		arg_10_0.preparePanel:show()
		arg_10_0.downPanel:hide()
		arg_10_0.allCardDatas:update({})

		local var_10_12 = gGameModel.cross_craft:read("card_attrs")

		arg_10_0.cardAttrs = {}

		for iter_10_4, iter_10_5 in pairs(var_10_12) do
			local var_10_13 = csv.cards[iter_10_5.card_id]
			local var_10_14 = csv.unit[var_10_13.unitID]
			local var_10_15 = dataEasy.getUnitId(iter_10_5.card_id, iter_10_5.skin_id)

			arg_10_0.cardAttrs[iter_10_5.id] = {
				battle = 1,
				dbid = iter_10_5.id,
				unit_id = var_10_15,
				card_id = iter_10_5.card_id,
				fighting_point = iter_10_5.fighting_point,
				level = iter_10_5.level,
				star = iter_10_5.star,
				created_time = iter_10_5.created_time,
				advance = iter_10_5.advance,
				rarity = var_10_14.rarity,
				attr1 = var_10_14.natureType,
				attr2 = var_10_14.natureType2,
				markId = var_10_13.cardMarkID,
				atkType = var_10_13.atkType
			}
		end
	end
end

function var_0_2.getCardAttrs(arg_13_0, arg_13_1)
	if arg_13_0.showDownPanel:read() then
		return arg_13_0.allCardDatas:atproxy(arg_13_1)
	end

	return arg_13_0.cardAttrs[arg_13_1]
end

function var_0_2.refreshUpPanelResult(arg_14_0, arg_14_1)
	local var_14_0 = gGameModel.cross_craft:read("history")
	local var_14_1 = var_0_0.getArrayRoundResult(arg_14_1, arg_14_0.round:read(), var_14_0)
	local var_14_2 = arg_14_0.groupItemObj[arg_14_1]
	local var_14_3 = var_14_2:multiget("bg", "result", "state", "title", "backup")
	local var_14_4 = matchLanguage({
		"en"
	}) and 0.7 or 0.8

	var_14_3.result:hide()
	var_14_3.state:hide()
	var_14_2:removeChildByName("stateEffect")

	local var_14_5, var_14_6 = var_14_3.state:xy()

	if var_14_1 == "inBattle" then
		widget.addAnimationByKey(var_14_2, "kuafushiying/wz.skel", "stateEffect", "effect_zdz_loop", 10):scale(var_14_4):xy(80, 710)
	elseif var_14_1 == "inPrepare" then
		widget.addAnimationByKey(var_14_2, "kuafushiying/wz.skel", "stateEffect", "effect_bzz_loop", 10):scale(var_14_4):xy(80, 710)
	elseif var_14_1 == "win" then
		var_14_3.result:texture("city/pvp/craft/icon_win.png"):show()
	elseif var_14_1 == "fail" then
		var_14_3.result:texture("city/pvp/craft/icon_lose.png"):show()
	end
end

function var_0_2.refreshUpPanelTitle(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.groupItemObj[arg_15_1]:multiget("bg", "result", "state", "title", "backup")

	var_15_0.title:show()
	var_15_0.backup:hide()

	local var_15_1 = gGameModel.cross_craft:read("history")
	local var_15_2 = var_0_0.getArrayRoundRes(arg_15_1, arg_15_0.round:read(), var_15_1)

	if var_15_2 then
		var_15_0.title:texture(var_15_2):show()
		var_15_0.bg:texture("city/pvp/cross_craft/myteam/box_wddw2.png")
	else
		var_15_0.title:hide()
		var_15_0.backup:show()
		var_15_0.bg:texture("city/pvp/cross_craft/myteam/box_wddw3.png")
	end
end

function var_0_2.initUpPanel(arg_16_0)
	arg_16_0.upList:setScrollBarEnabled(false)
	arg_16_0.upGroupItem:get("list"):setScrollBarEnabled(false)

	arg_16_0.groupItemObj = {}
	arg_16_0.battleCardsObj = {}

	for iter_16_0 = 1, 4 do
		local var_16_0 = arg_16_0.upGroupItem:clone()

		arg_16_0.upList:pushBackCustomItem(var_16_0)

		arg_16_0.groupItemObj[iter_16_0] = var_16_0

		for iter_16_1 = 1, 3 do
			local var_16_1 = iter_16_1 + (iter_16_0 - 1) * 3
			local var_16_2 = arg_16_0.upItem:clone()

			var_16_2:get("tagIdx"):text(iter_16_1)
			var_16_2:show()
			var_16_0:get("list"):pushBackCustomItem(var_16_2)

			arg_16_0.battleCardsObj[var_16_1] = var_16_2

			var_16_2:onTouch(functools.partial(arg_16_0.onBattleCardTouch, arg_16_0, var_16_1))
		end

		var_16_0:get("list"):refreshView()
		var_16_0:show()
	end

	arg_16_0.upList:refreshView()
end

function var_0_2.initBottomList(arg_17_0)
	arg_17_0.cardListView = gGameUI:createView("city.card.embattle.embattle_card_list", arg_17_0.downPanel):init({
		base = arg_17_0,
		clientBattleCards = arg_17_0.clientBattleCards,
		battleCardsData = arg_17_0.battleCardsData,
		deleteMovingItem = arg_17_0.deleteMovingItem,
		createMovePanel = arg_17_0.createMovePanel,
		moveMovePanel = arg_17_0.moveMovePanel,
		isMovePanelExist = arg_17_0.isMovePanelExist,
		onCardClick = arg_17_0.onCardClick,
		allCardDatas = arg_17_0.allCardDatas,
		moveEndMovePanel = arg_17_0.moveEndMovePanel,
		limtFunc = arg_17_0.limtFunc
	}, false)

	arg_17_0.cardListView:xy(0, -34)
end

function var_0_2.refreshBattleSprite(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.clientBattleCards:read()[arg_18_1]
	local var_18_1 = arg_18_0.battleCardsObj[arg_18_1]

	var_18_1:removeChildByName("starPanel")

	if not var_18_0 then
		var_18_1:get("empty"):show()
		var_18_1:get("info"):hide()

		return
	end

	var_18_1:get("empty"):hide()
	var_18_1:get("info"):show()

	local var_18_2 = arg_18_0:getCardAttrs(var_18_0)
	local var_18_3 = var_18_1:get("info"):multiget("head", "level", "text", "fightPoint", "attr1", "attr2")

	var_18_3.level:text("Lv" .. var_18_2.level)
	var_18_3.fightPoint:text(var_18_2.fighting_point)
	adapt.oneLinePos(var_18_3.text, var_18_3.fightPoint, cc.p(5, 0))
	var_18_3.attr1:texture(ui.ATTR_ICON[var_18_2.attr1])
	var_18_3.attr2:visible(var_18_2.attr2 and true or false)

	if var_18_2.attr2 then
		var_18_3.attr2:texture(ui.ATTR_ICON[var_18_2.attr2])
	end

	uiEasy.getStarPanel(var_18_2.star, {
		interval = -5,
		align = "left"
	}):scale(0.35):xy(230, 120):addTo(var_18_1, 2)
	bind.extend(arg_18_0, var_18_3.head, {
		class = "card_icon",
		props = {
			unitId = var_18_2.unit_id,
			rarity = var_18_2.rarity,
			advance = var_18_2.advance,
			grayState = arg_18_0:cardInBattle(arg_18_1) and 1 or 0,
			onNode = function(arg_19_0)
				arg_19_0:xy(-6, -6)
			end
		}
	})
end

function var_0_2.onBattleFilter(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_0.filterCondition:set({
		attr1 = arg_20_1,
		attr2 = arg_20_2,
		rarity = arg_20_3,
		atkType = arg_20_4
	}, true)
end

function var_0_2.isCardChanged(arg_21_0)
	local var_21_0 = gGameModel.cross_craft:read("cards")

	for iter_21_0 = 1, var_0_3 do
		if arg_21_0.clientBattleCards:read()[iter_21_0] ~= var_21_0[iter_21_0] then
			return true
		end
	end

	return false
end

function var_0_2.setCountdownState(arg_22_0, arg_22_1)
	arg_22_0:unSchedule(1)

	if arg_22_0.upCountdownTip then
		arg_22_0.upCountdownTip:removeSelf()

		arg_22_0.upCountdownTip = nil
	end

	arg_22_0.upCountdown:stopAllActions()

	local var_22_0 = false
	local var_22_1 = gLanguageCsv.crossCraftBattleCountdown

	if string.find(arg_22_1, "_lock$") then
		var_22_1 = gLanguageCsv.crossCraftInBattle .. ":"
	elseif string.find(arg_22_1, "^pre%d") or string.find(arg_22_1, "^top") or string.find(arg_22_1, "^final") then
		var_22_1 = gLanguageCsv.stateReady .. ":"
		var_22_0 = true
	end

	arg_22_0.upText:text(var_22_1)
	adapt.oneLineCenterPos(cc.p(arg_22_0.upPanel:width() - 320, 840), {
		arg_22_0.upText,
		arg_22_0.upCountdown
	}, cc.p(12, 0))

	local var_22_2 = 0

	local function var_22_3()
		local var_23_0 = var_0_0.getNextStateTime(nil, true)

		if arg_22_1 == "signup" then
			var_23_0 = var_0_0.getNextStateTime("prepare", true)
		elseif arg_22_1 == "halftime" then
			var_23_0 = var_0_0.getNextStateTime("prepare2", true)
		end

		local var_23_1 = time.getCutDown(var_23_0)

		arg_22_0.upCountdown:text(var_23_1.short_clock_str)

		if var_22_0 and var_23_0 <= 10 and not arg_22_0.upCountdownTip then
			arg_22_0.upCountdownTip = label.create(gLanguageCsv.crossCraftEmbattleAutoSave, {
				fontSize = 36,
				fontPath = "font/youmi.ttf",
				color = ui.COLORS.NORMAL.RED,
				effect = {
					outline = {
						size = 2,
						color = ui.COLORS.OUTLINE.DEFAULT
					}
				}
			})

			arg_22_0.upCountdown:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.2, 1), cc.DelayTime:create(0.6), cc.ScaleTo:create(0.2, 1.3))))
			adapt.oneLineCenterPos(cc.p(arg_22_0.upPanel:width() / 2, 870), {
				arg_22_0.upText,
				arg_22_0.upCountdown
			}, cc.p(12, 0))
			arg_22_0.upCountdownTip:addTo(arg_22_0.upPanel, 5):xy(arg_22_0.upPanel:width() / 2, 810)
		end
	end

	var_22_3()
	arg_22_0:schedule(function()
		if var_22_2 < 0 then
			return false
		end

		var_22_3()
	end, 1, 1, 1)
end

function var_0_2.setTileState(arg_25_0, arg_25_1)
	local var_25_0
	local var_25_1

	if arg_25_1 == "prepare" or string.find(arg_25_1, "^pre1") then
		var_25_0 = "txt_yxs"
		var_25_1 = "txt_1l"
	elseif string.find(arg_25_1, "^pre2") then
		var_25_0 = "txt_yxs"
		var_25_1 = "txt_2l"
	elseif arg_25_1 == "halftime" or arg_25_1 == "prepare2" or string.find(arg_25_1, "^pre3") then
		var_25_0 = "txt_yxs"
		var_25_1 = "txt_3l"
	elseif string.find(arg_25_1, "^top") then
		var_25_0 = "txt_jjs"
	elseif string.find(arg_25_1, "^final") then
		var_25_0 = "txt_dfs"
	end

	arg_25_0.prepareTitle:hide()

	if var_25_0 then
		arg_25_0.prepareTitle:show():texture("city/pvp/cross_craft/txt/" .. var_25_0 .. ".png")
	end

	arg_25_0.prepareRound:hide()

	if var_25_1 then
		arg_25_0.prepareRound:show()
		arg_25_0.prepareRound:get("now"):texture("city/pvp/cross_craft/txt/" .. var_25_1 .. ".png")
	end
end

function var_0_2.onOneKeyClick(arg_26_0)
	local var_26_0 = arg_26_0.clientBattleCards:read()

	if not var_26_0 then
		return
	end

	if itertools.equal(arg_26_0.oneKeyCards, var_26_0) then
		gGameUI:showTip(gLanguageCsv.embattleNotChange)

		return
	end

	for iter_26_0 = 1, var_0_3 do
		if var_26_0[iter_26_0] then
			arg_26_0:getCardAttrs(var_26_0[iter_26_0]).battle = 0
		end
	end

	arg_26_0.clientBattleCards:set(clone(arg_26_0.oneKeyCards))

	for iter_26_1 = 1, var_0_3 do
		arg_26_0:getCardAttrs(arg_26_0.clientBattleCards:read()[iter_26_1]).battle = 1

		arg_26_0:refreshBattleSprite(iter_26_1)
	end

	gGameUI:showTip(gLanguageCsv.oneKeySuccess)
end

function var_0_2.onSaveClick(arg_27_0, arg_27_1)
	if arg_27_0.clientBattleCards:size() < var_0_3 then
		gGameUI:showTip(gLanguageCsv.crossCraftEmbattleNotEnough)

		return
	end

	if not arg_27_0:isCardChanged() then
		gGameUI:showTip(gLanguageCsv.embattleNotChange)

		return
	end

	if not var_0_0.isSigned() then
		gGameApp:requestServer("/game/cross/craft/signup", function()
			var_0_1.onClose(arg_27_0)
			gGameUI:showTip(gLanguageCsv.signUpSuccess)
		end, arg_27_0.clientBattleCards:read())

		return
	end

	gGameApp:requestServer("/game/cross/craft/battle/deploy", function()
		var_0_1.onClose(arg_27_0)
		gGameUI:showTip(gLanguageCsv.battleResetSuccess)
	end, arg_27_0.clientBattleCards:read())
end

function var_0_2.onBattleCardTouch(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.clientBattleCards:read()[arg_30_1]

	if not arg_30_0.clientBattleCards:read()[arg_30_1] then
		return
	end

	if arg_30_0:cardInBattle(arg_30_1) then
		return
	end

	if arg_30_2.name == "began" then
		arg_30_0.touchBeganPos = arg_30_2
		arg_30_0.ignoreCurMovingItem = false
		arg_30_0.hasMovingItem = nil

		arg_30_0:deleteMovingItem()
	elseif arg_30_2.name == "moved" then
		if arg_30_0.ignoreCurMovingItem then
			return
		end

		local var_30_1 = math.abs(arg_30_2.x - arg_30_0.touchBeganPos.x)
		local var_30_2 = math.abs(arg_30_2.y - arg_30_0.touchBeganPos.y)

		if arg_30_0.hasMovingItem == nil and (var_30_1 >= ui.TOUCH_MOVED_THRESHOLD or var_30_2 >= ui.TOUCH_MOVED_THRESHOLD) then
			arg_30_0.hasMovingItem = true

			local var_30_3 = arg_30_0:getCardAttrs(var_30_0)

			arg_30_0:createMovePanel(var_30_3)
		end

		arg_30_0:moveMovePanel(arg_30_2)
	elseif arg_30_2.name == "ended" or arg_30_2.name == "cancelled" then
		if arg_30_0.ignoreCurMovingItem then
			return
		end

		local var_30_4 = arg_30_0:getCardAttrs(arg_30_0.clientBattleCards:read()[arg_30_1])

		if arg_30_0.hasMovingItem == nil then
			arg_30_0:onCardClick(var_30_4, true)
		end

		arg_30_0.hasMovingItem = nil

		if arg_30_0:deleteMovingItem() then
			if arg_30_2.y < 340 then
				arg_30_0:onCardClick(var_30_4, true)
			else
				local var_30_5 = arg_30_0:whichEmbattleTargetPos(arg_30_2)

				if var_30_5 and var_30_5 ~= arg_30_1 then
					arg_30_0:onCardMove(var_30_4, var_30_5, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				end
			end
		end
	end
end

function var_0_2.deleteMovingItem(arg_31_0)
	arg_31_0.selectIndex:set(0)

	if arg_31_0.movePanel then
		arg_31_0.movePanel:removeSelf()

		arg_31_0.movePanel = nil

		return true
	end
end

function var_0_2.createMovePanel(arg_32_0, arg_32_1)
	if arg_32_0.movePanel then
		arg_32_0.movePanel:removeSelf()
	end

	local var_32_0 = arg_32_0.item:clone():addTo(arg_32_0:getResourceNode(), 1000)

	bind.extend(arg_32_0, var_32_0, {
		class = "card_icon",
		props = {
			unitId = arg_32_1.unit_id,
			advance = arg_32_1.advance,
			rarity = arg_32_1.rarity,
			star = arg_32_1.star,
			levelProps = {
				data = arg_32_1.level
			},
			onNode = function(arg_33_0)
				arg_33_0:xy(-2, -2)
			end
		}
	})
	var_32_0:show()
	var_32_0:get("txt"):hide()

	arg_32_0.movePanel = var_32_0

	return var_32_0
end

function var_0_2.moveMovePanel(arg_34_0, arg_34_1)
	if arg_34_0.movePanel then
		arg_34_0.movePanel:xy(arg_34_1)
		arg_34_0.selectIndex:set(arg_34_0:whichEmbattleTargetPos(arg_34_1))
	end
end

function var_0_2.isMovePanelExist(arg_35_0)
	return arg_35_0.movePanel ~= nil
end

function var_0_2.moveEndMovePanel(arg_36_0, arg_36_1)
	if not arg_36_0.movePanel then
		return
	end

	local var_36_0 = arg_36_0.selectIndex:read()

	arg_36_0:onCardMove(arg_36_1, var_36_0, true)
	arg_36_0:deleteMovingItem()
end

function var_0_2.onCardClick(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.showDownPanel:read() then
		return
	end

	if arg_37_1.inMeteor then
		gGameUI:showTip(gLanguageCsv.cardInMeteorites)

		return
	end

	local var_37_0
	local var_37_1 = arg_37_1.dbid

	if arg_37_1.battle == 1 then
		local var_37_2 = arg_37_0:getIdxByDbId(var_37_1)

		if not arg_37_0:cardInBattle(var_37_2) then
			arg_37_0:downBattle(var_37_1, var_37_2)

			var_37_0 = gLanguageCsv.downToEmbattle
		else
			var_37_0 = gLanguageCsv.crossCraftEmbattleInBattle
		end
	else
		local var_37_3 = arg_37_0:getIdxByDbId()

		if not arg_37_0:cardInBattle(var_37_3) then
			if arg_37_0.clientBattleCards:size() == var_0_3 then
				var_37_0 = gLanguageCsv.battleCardCountEnough
			elseif arg_37_0:hasSameMarkIDCard(arg_37_1) then
				var_37_0 = gLanguageCsv.alreadyHaveSameSprite
			else
				arg_37_0:upCard(var_37_1, var_37_3)

				var_37_0 = gLanguageCsv.addToEmbattle
			end
		else
			var_37_0 = gLanguageCsv.crossCraftEmbattleInBattle
		end
	end

	if arg_37_2 and var_37_0 then
		gGameUI:showTip(var_37_0)
	end
end

function var_0_2.onCardMove(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0
	local var_38_1 = arg_38_1.dbid
	local var_38_2 = arg_38_0:getIdxByDbId(var_38_1)
	local var_38_3
	local var_38_4 = arg_38_0.clientBattleCards:read()[arg_38_2]

	if arg_38_0:cardInBattle(var_38_2) or arg_38_0:cardInBattle(arg_38_2) then
		var_38_0 = gLanguageCsv.crossCraftEmbattleInBattle
	elseif not arg_38_2 then
		arg_38_0:onCardClick(arg_38_1, arg_38_3)
	elseif arg_38_1.battle == 1 and (not var_38_4 or true) then
		arg_38_0.clientBattleCards:modify(function(arg_39_0)
			arg_39_0[var_38_2], arg_39_0[arg_38_2] = arg_39_0[arg_38_2], arg_39_0[var_38_2]

			return true, arg_39_0
		end, true)
		arg_38_0:refreshBattleSprite(var_38_2)
		arg_38_0:refreshBattleSprite(arg_38_2)
	else
		local var_38_5 = arg_38_0:hasSameMarkIDCard(arg_38_1)

		if var_38_5 and var_38_5 ~= arg_38_2 then
			var_38_0 = gLanguageCsv.alreadyHaveSameSprite
		else
			if var_38_4 then
				arg_38_0:getCardAttrs(var_38_4).battle = 0
			end

			arg_38_0:upCard(var_38_1, arg_38_2)
		end
	end

	if arg_38_3 and var_38_0 then
		gGameUI:showTip(var_38_0)
	end
end

function var_0_2.whichEmbattleTargetPos(arg_40_0, arg_40_1)
	for iter_40_0 = 1, var_0_3 do
		local var_40_0 = arg_40_0.battleCardsRect[iter_40_0]

		if cc.rectContainsPoint(var_40_0, arg_40_1) then
			return iter_40_0
		end
	end
end

function var_0_2.getIdxByDbId(arg_41_0, arg_41_1)
	for iter_41_0 = 1, var_0_3 do
		if arg_41_0.clientBattleCards:read()[iter_41_0] == arg_41_1 then
			return iter_41_0
		end
	end
end

function var_0_2.hasSameMarkIDCard(arg_42_0, arg_42_1)
	for iter_42_0 = 1, var_0_3 do
		local var_42_0 = arg_42_0.clientBattleCards:read()[iter_42_0]

		if var_42_0 and arg_42_0:getCardAttrs(var_42_0).markId == arg_42_1.markId then
			return iter_42_0
		end
	end

	return false
end

function var_0_2.downBattle(arg_43_0, arg_43_1, arg_43_2)
	arg_43_0:getCardAttrs(arg_43_1).battle = 0

	arg_43_0.clientBattleCards:modify(function(arg_44_0)
		arg_44_0[arg_43_2] = nil

		return true, arg_44_0
	end, true)
	arg_43_0:refreshBattleSprite(arg_43_2)
end

function var_0_2.upCard(arg_45_0, arg_45_1, arg_45_2)
	arg_45_0.clientBattleCards:modify(function(arg_46_0)
		arg_46_0[arg_45_2] = arg_45_1
		arg_45_0:getCardAttrs(arg_45_1).battle = 1

		return true, arg_46_0
	end, true)
	arg_45_0:refreshBattleSprite(arg_45_2)
end

function var_0_2.cardInBattle(arg_47_0, arg_47_1)
	if arg_47_1 == nil then
		return false
	end

	local var_47_0 = arg_47_0.round:read()
	local var_47_1 = var_0_0.getArrayRoundIdx(var_47_0)

	if not string.find(var_47_0, "_lock$") then
		var_47_1 = var_47_1 - 1
	end

	return arg_47_1 <= var_47_1 * 3
end

function var_0_2.limtFunc(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, arg_48_6, arg_48_7, arg_48_8, arg_48_9, arg_48_10)
	local var_48_0 = dataEasy.getInMeteorCardsHash()
	local var_48_1 = csv.cards[arg_48_2]
	local var_48_2 = csv.unit[var_48_1.unitID]
	local var_48_3 = dataEasy.getUnitId(arg_48_2, arg_48_3)

	return {
		card_id = arg_48_2,
		unit_id = var_48_3,
		rarity = var_48_2.rarity,
		attr1 = var_48_2.natureType,
		attr2 = var_48_2.natureType2,
		fighting_point = arg_48_4,
		level = arg_48_5,
		star = arg_48_6,
		getTime = arg_48_8,
		dbid = arg_48_1,
		advance = arg_48_7,
		battle = arg_48_10,
		atkType = var_48_1.atkType,
		markId = var_48_1.cardMarkID,
		nature_choose = arg_48_9,
		inMeteor = var_48_0[arg_48_1]
	}
end

return var_0_2
