local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("GymChallengeEmbattleView", var_0_0)

var_0_1.RESOURCE_FILENAME = "gym_embattle3.json"
var_0_1.RESOURCE_BINDING = {
	["rightTop.imgBg"] = "attrBg",
	bottomPanel = "bottomPanel",
	rightDown = "rightDown",
	upItem = "upItem",
	["rightTop.textNote"] = "textNote",
	rightTop = "rightTop",
	battlePanel = "battlePanel",
	textNotRole = "emptyTxt",
	["fightNote.textFightPoint"] = "textFightPoint",
	spritePanel = "spriteItem",
	attrItem = "attrItem",
	["battlePanel.ahead.txt"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["battlePanel.back.txt"] = {
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
				ended = bindHelper.self("fightBtn")
			}
		}
	},
	["rightDown.btnChallenge.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightDown.btnOneKeySet"] = {
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
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["rightTop.arrList"] = {
		varname = "arrList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("limitInfo"),
				item = bindHelper.self("attrItem"),
				textNote = bindHelper.self("textNote"),
				attrBg = bindHelper.self("attrBg"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgIcon"):texture(ui.ATTR_ICON[arg_1_3])
				end,
				onAfterBuild = function(arg_2_0)
					local var_2_0 = arg_2_0.item:size()
					local var_2_1 = csvSize(arg_2_0.data)
					local var_2_2 = var_2_0.width * var_2_1 + arg_2_0:getItemsMargin() * (var_2_1 - 1)

					arg_2_0:setAnchorPoint(cc.p(1, 0.5))
					arg_2_0:width(var_2_2)
					arg_2_0:xy(cc.p(600, 50))
					adapt.oneLinePos(arg_2_0, arg_2_0.textNote, cc.p(0, 0), "right")
					arg_2_0.attrBg:width(var_2_2 + arg_2_0.textNote:width() + 40)
					arg_2_0.attrBg:x(arg_2_0.textNote:x() - 40)
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_3_0, arg_3_1)
	gGameUI.topuiManager:createView("title", arg_3_0, {
		onClose = arg_3_0:createHandler("onClose", false)
	}):init({
		subTitle = "FORMATION",
		title = "common/txt/txt_bt_buzhen.png"
	})
	arg_3_0:initDefine(arg_3_1)
	arg_3_0:initParams(arg_3_1)
	arg_3_0:initModel(arg_3_1)
	arg_3_0:initRoundUIPanel()
	arg_3_0:initHeroSprite()
	arg_3_0:initBottomList()
	arg_3_0.battleCardsData:set(arg_3_0:getOneKeyCardDatas())
	arg_3_0.textFightPoint:setString(arg_3_0:getFightSumNum(arg_3_0:getOneKeyCardDatas()))
end

function var_0_1.initDefine(arg_4_0, arg_4_1)
	arg_4_0.deployNum = csv.gym.gate[arg_4_1.gateId].deployNum
	arg_4_0.oneTeamNum = csv.gym.gate[arg_4_1.gateId].deployCardNumLimit
	arg_4_0.embattleMax = arg_4_0.deployNum * arg_4_0.oneTeamNum
	arg_4_0.panelNum = arg_4_0.deployNum * 6
	arg_4_0.gymId = arg_4_1.gymId
	arg_4_0.k = arg_4_1.k
end

function var_0_1.initParams(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}
	arg_5_0.from = game.EMBATTLE_FROM_TABLE.onekey
	arg_5_0.sceneType = game.SCENE_TYPE.gym
	arg_5_0.fightCb = arg_5_1.fightCb
	arg_5_0.limitInfo = csv.gym.gate[arg_5_1.gateId].deployNatureLimit
	arg_5_0.checkBattleArr = arg_5_1.checkBattleArr or function()
		return true
	end
end

function var_0_1.initRoundUIPanel(arg_7_0)
	adapt.centerWithScreen("left", "right", nil, {
		{
			arg_7_0.rightDown,
			"pos",
			"right"
		},
		{
			arg_7_0.rightTop,
			"pos",
			"right"
		}
	})

	if itertools.size(arg_7_0.limitInfo) == 0 then
		arg_7_0.rightTop:hide()
	end
end

function var_0_1.limtFunc(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10)
	local var_8_0 = itertools.map(arg_8_0.limitInfo or {}, function(arg_9_0, arg_9_1)
		return arg_9_1, 1
	end)
	local var_8_1 = csv.cards[arg_8_2]
	local var_8_2 = csv.unit[var_8_1.unitID]

	if csvSize(arg_8_0.limitInfo) == 0 or var_8_0[var_8_2.natureType] or var_8_0[var_8_2.natureType2] then
		return var_0_0.limtFunc(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10)
	else
		return nil
	end
end

function var_0_1.getOneKeyCardDatas(arg_10_0)
	local var_10_0 = itertools.values(arg_10_0.allCardDatas)

	table.sort(var_10_0, function(arg_11_0, arg_11_1)
		arg_11_0, arg_11_1 = arg_11_0:read(), arg_11_1:read()

		if arg_11_0.fighting_point == arg_11_1.fighting_point then
			return arg_11_0.rarity > arg_11_1.rarity
		else
			return arg_11_0.fighting_point > arg_11_1.fighting_point
		end
	end)

	local var_10_1 = {}
	local var_10_2 = {}
	local var_10_3 = 0

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		iter_10_1 = iter_10_1:read()

		local var_10_4 = arg_10_0:getCardAttr(iter_10_1.dbid, "card_id")
		local var_10_5 = csv.cards[var_10_4]

		if arg_10_0:embattleBtnFunc(var_10_1, iter_10_1) then
			var_10_3 = var_10_3 + 1
			var_10_2[var_10_3] = iter_10_1.dbid
			var_10_1[var_10_5.cardMarkID] = {
				dbid = iter_10_1.dbid,
				fighting_point = iter_10_1.fighting_point,
				rarity = iter_10_1.rarity
			}

			if var_10_3 == arg_10_0.oneTeamNum * arg_10_0.deployNum then
				break
			end
		end
	end

	local var_10_6 = itertools.size(var_10_2)
	local var_10_7 = {}
	local var_10_8 = 0
	local var_10_9 = false

	for iter_10_2 = 1, arg_10_0.deployNum do
		for iter_10_3 = 1, arg_10_0.oneTeamNum do
			var_10_8 = var_10_8 + 1
			var_10_7[6 * (iter_10_2 - 1) + iter_10_3] = clone(var_10_2[var_10_8])

			local var_10_10 = arg_10_0.deployNum - iter_10_2
			local var_10_11 = var_10_6 - var_10_8

			if var_10_6 - var_10_8 == arg_10_0.deployNum - iter_10_2 and var_10_6 - var_10_8 ~= 0 then
				var_10_9 = true

				break
			end
		end

		if var_10_9 == true then
			break
		end
	end

	if var_10_9 then
		for iter_10_4 = 1, arg_10_0.deployNum do
			if not var_10_7[6 * (iter_10_4 - 1) + 1] then
				var_10_8 = var_10_8 + 1
				var_10_7[6 * (iter_10_4 - 1) + 1] = clone(var_10_2[var_10_8])
			end
		end
	end

	return var_10_7
end

function var_0_1.initBottomList(arg_12_0)
	arg_12_0.cardListView = gGameUI:createView("city.adventure.gym_challenge.card_list3", arg_12_0.bottomPanel):init({
		base = arg_12_0,
		clientBattleCards = arg_12_0.clientBattleCards,
		battleCardsData = arg_12_0.battleCardsData,
		deleteMovingItem = arg_12_0.deleteMovingItem,
		createMovePanel = arg_12_0.createMovePanel,
		moveMovePanel = arg_12_0.moveMovePanel,
		isMovePanelExist = arg_12_0.isMovePanelExist,
		onCardClick = arg_12_0.onCardClick,
		allCardDatas = arg_12_0.allCardDatas,
		moveEndMovePanel = arg_12_0.moveEndMovePanel,
		limtFunc = arg_12_0.limtFunc
	}, true)
end

function var_0_1.initHeroSprite(arg_13_0)
	arg_13_0.heroSprite = {}

	local var_13_0 = 50
	local var_13_1 = arg_13_0.upItem:width()
	local var_13_2 = arg_13_0.battlePanel:size()
	local var_13_3 = 0
	local var_13_4 = (var_13_1 + var_13_0) * (arg_13_0.deployNum - 1)
	local var_13_5 = var_13_2.width / 2 - var_13_4 / 2

	for iter_13_0 = 1, arg_13_0.deployNum do
		local var_13_6 = arg_13_0.upItem:clone():show():addTo(arg_13_0.battlePanel, 2, "panel" .. iter_13_0):xy(var_13_5 + (iter_13_0 - 1) * (var_13_1 + var_13_0), var_13_2.height / 2 + 110)

		var_13_6:get("imgOrangeBg.textNote"):text(string.format(gLanguageCsv.unionFightTeam, gLanguageCsv["symbolNumber" .. iter_13_0]))

		for iter_13_1 = 1, 6 do
			local var_13_7 = (iter_13_0 - 1) * 6 + iter_13_1

			arg_13_0.heroSprite[var_13_7] = {
				sprite = var_13_6:get("panel" .. iter_13_1),
				idx = var_13_7
			}
		end
	end

	local var_13_8 = {}

	idlereasy.when(arg_13_0.clientBattleCards, function(arg_14_0, arg_14_1)
		local var_14_0 = true
		local var_14_1 = {}
		local var_14_2 = {}

		for iter_14_0 = 1, arg_13_0.deployNum do
			var_14_1[iter_14_0] = 0
			var_14_2[iter_14_0] = {}

			for iter_14_1 = 1, 6 do
				local var_14_3 = (iter_14_0 - 1) * 6 + iter_14_1
				local var_14_4 = arg_13_0.heroSprite[var_14_3].sprite
				local var_14_5 = arg_14_1[var_14_3]

				var_14_2[iter_14_0][iter_14_1] = var_14_5

				var_14_4:get("head"):onTouch(functools.partial(arg_13_0.onBattleCardTouch, arg_13_0, var_14_3))

				if var_14_5 then
					local var_14_6 = gGameModel.cards:find(var_14_5)
					local var_14_7 = var_14_6:read("card_id")
					local var_14_8 = var_14_6:read("skin_id")
					local var_14_9 = dataEasy.getUnitId(var_14_7, var_14_8)

					var_14_4:get("imgEmpty"):hide()
					bind.extend(arg_13_0, var_14_4:get("head"):show(), {
						class = "card_icon",
						props = {
							unitId = var_14_9,
							cardId = var_14_7,
							rarity = var_14_6:read("rarity"),
							advance = var_14_6:read("advance"),
							star = var_14_6:read("star"),
							levelProps = {
								data = var_14_6:read("level")
							},
							onNode = function(arg_15_0)
								arg_15_0:xy(-6, -6)
							end
						}
					})

					var_14_1[iter_14_0] = var_14_1[iter_14_0] + 1
				else
					var_14_4:get("head"):hide()
					var_14_4:get("imgEmpty"):show()
				end

				if not var_13_8[arg_14_1[iter_14_0]] and arg_14_1[iter_14_0] then
					var_14_0 = false
				end
			end
		end

		if not var_14_0 or itertools.size(var_13_8) ~= var_14_1 then
			var_13_8 = itertools.map(arg_14_1, function(arg_16_0, arg_16_1)
				return arg_16_1, arg_16_0
			end)

			for iter_14_2 = 1, arg_13_0.deployNum do
				arg_13_0.battlePanel:get("panel" .. iter_14_2):get("textNum"):get():text(var_14_1[iter_14_2] .. "/" .. arg_13_0.oneTeamNum)
				arg_13_0:refreshTeamBuff(var_14_2[iter_14_2], iter_14_2)
				arg_13_0:refreshFightPoint(var_14_2[iter_14_2], iter_14_2)
			end
		end

		arg_13_0.textFightPoint:setString(arg_13_0:getFightSumNum(arg_13_0.clientBattleCards:read()))
	end)
end

function var_0_1.refreshTeamBuff(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = {}
	local var_17_1 = true

	for iter_17_0 = 1, 6 do
		local var_17_2 = arg_17_1[iter_17_0]
		local var_17_3 = arg_17_0:getCardAttrs(var_17_2)

		if var_17_3 then
			local var_17_4 = csv.cards[var_17_3.card_id]
			local var_17_5 = csv.unit[var_17_4.unitID]

			var_17_0[iter_17_0] = {
				var_17_5.natureType,
				var_17_5.natureType2
			}
		end
	end

	if not var_17_1 then
		var_17_0 = {}
	end

	local var_17_6 = dataEasy.getTeamBuffBest(var_17_0)

	arg_17_0.battlePanel:get("panel" .. arg_17_2):get("imgBuf"):texture(var_17_6.buf.imgPath)
end

function var_0_1.refreshFightPoint(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = 0

	for iter_18_0, iter_18_1 in pairs(arg_18_1) do
		var_18_0 = var_18_0 + arg_18_0:getCardAttr(iter_18_1, "fighting_point")
	end

	arg_18_0.battlePanel:get("panel" .. arg_18_2):get("textZl"):text(var_18_0)
end

function var_0_1.createMovePanel(arg_19_0, arg_19_1)
	if arg_19_0.movePanel then
		arg_19_0.movePanel:removeSelf()
	end

	local var_19_0 = arg_19_0.spriteItem:clone():addTo(arg_19_0:getResourceNode(), 1000)

	bind.extend(arg_19_0, var_19_0, {
		class = "card_icon",
		props = {
			unitId = arg_19_1.unit_id,
			advance = arg_19_1.advance,
			rarity = arg_19_1.rarity,
			star = arg_19_1.star,
			levelProps = {
				data = arg_19_1.level
			},
			onNode = function(arg_20_0)
				arg_20_0:xy(-2, -2)
			end
		}
	})
	var_19_0:show()

	arg_19_0.movePanel = var_19_0

	return var_19_0
end

function var_0_1.onBattleCardTouch(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.clientBattleCards:read()[arg_21_1]

	if not var_21_0 then
		return
	end

	local var_21_1 = arg_21_0:getCardAttrs(var_21_0)

	if arg_21_2.name == "began" then
		arg_21_0:createMovePanel(var_21_1)
		arg_21_0.selectIndex:set(arg_21_1)
		arg_21_0.heroSprite[arg_21_1].sprite:get("head"):hide()
		arg_21_0.heroSprite[arg_21_1].sprite:get("imgEmpty"):show()
		arg_21_0.movePanel:xy(arg_21_2.x, arg_21_2.y)
	elseif arg_21_2.name == "moved" then
		arg_21_0:moveMovePanel(arg_21_2)
	elseif arg_21_2.name == "ended" or arg_21_2.name == "cancelled" then
		arg_21_0.heroSprite[arg_21_1].sprite:get("head"):show()
		arg_21_0.heroSprite[arg_21_1].sprite:get("imgEmpty"):hide()
		arg_21_0:deleteMovingItem()

		if arg_21_2.y < 340 then
			arg_21_0:onCardClick(var_21_1, true)
		else
			local var_21_2 = arg_21_0:whichEmbattleTargetPos(arg_21_2)

			if var_21_2 then
				if var_21_2 ~= arg_21_1 then
					arg_21_0:onCardMove(var_21_1, var_21_2, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_21_0:onCardMove(var_21_1, var_21_2, false)
				end
			else
				arg_21_0:onCardMove(var_21_1, arg_21_1, false)
			end
		end
	end
end

function var_0_1.getIdxByDbId(arg_22_0, arg_22_1)
	if arg_22_1 then
		for iter_22_0 = 1, arg_22_0.panelNum do
			if arg_22_0.clientBattleCards:read()[iter_22_0] == arg_22_1 then
				return iter_22_0
			end
		end
	end

	for iter_22_1 = 1, arg_22_0.deployNum do
		local var_22_0 = 0
		local var_22_1 = (iter_22_1 - 1) * 6 + 1

		for iter_22_2 = var_22_1, var_22_1 + 5 do
			if arg_22_0.clientBattleCards:read()[iter_22_2] then
				var_22_0 = var_22_0 + 1
			end
		end

		if var_22_0 < arg_22_0.oneTeamNum then
			for iter_22_3 = var_22_1, var_22_1 + 5 do
				if not arg_22_0.clientBattleCards:read()[iter_22_3] then
					return iter_22_3
				end
			end
		end
	end
end

function var_0_1.whichEmbattleTargetPos(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in pairs(arg_23_0.heroSprite) do
		local var_23_0 = iter_23_1.sprite
		local var_23_1 = var_23_0:box()
		local var_23_2 = var_23_0:getParent():convertToWorldSpace(cc.p(var_23_1.x, var_23_1.y))

		var_23_1.x, var_23_1.y = var_23_2.x, var_23_2.y

		if cc.rectContainsPoint(var_23_1, arg_23_1) then
			return iter_23_0
		end
	end
end

function var_0_1.onCardMove(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0
	local var_24_1 = arg_24_1.dbid
	local var_24_2 = arg_24_0:getIdxByDbId(var_24_1)
	local var_24_3 = arg_24_0.clientBattleCards:read()[arg_24_2]
	local var_24_4 = arg_24_0:getCardAttrs(var_24_3)
	local var_24_5 = arg_24_0:getBattle(var_24_2)

	if not arg_24_2 then
		-- block empty
	else
		local var_24_6 = arg_24_0:getBattle(arg_24_2)

		if arg_24_1.battle > 0 then
			if var_24_6 ~= arg_24_1.battle and arg_24_0:getCardNum(arg_24_1.battle) == 1 and var_24_3 == nil then
				var_24_0 = gLanguageCsv.battleNumberNo
			elseif var_24_6 ~= arg_24_1.battle and arg_24_0:getCardNum(var_24_6) == arg_24_0.oneTeamNum and var_24_3 == nil then
				var_24_0 = gLanguageCsv.battleCardCountEnough
			else
				if arg_24_0:getCardAttrs(var_24_3) then
					arg_24_0:getCardAttrs(var_24_3).battle = arg_24_0:getBattle(var_24_2)
				end

				if arg_24_0:getCardAttrs(var_24_1) then
					arg_24_0:getCardAttrs(var_24_1).battle = arg_24_0:getBattle(arg_24_2)
				end

				arg_24_0.clientBattleCards:modify(function(arg_25_0)
					arg_25_0[var_24_2], arg_25_0[arg_24_2] = arg_25_0[arg_24_2], arg_25_0[var_24_2]

					return true, arg_25_0
				end, true)
			end
		else
			local var_24_7 = arg_24_0:hasSameMarkIDCard(arg_24_1)

			if var_24_7 and var_24_7 ~= arg_24_2 then
				var_24_0 = gLanguageCsv.alreadyHaveSameSprite
			elseif not var_24_3 and not arg_24_0:canBattleUp(var_24_6) then
				var_24_0 = gLanguageCsv.battleCardCountEnough
			else
				arg_24_0:upBattle(var_24_1, arg_24_2)

				var_24_0 = gLanguageCsv.addToEmbattle
			end
		end
	end

	if arg_24_3 and var_24_0 then
		gGameUI:showTip(var_24_0)
	end
end

function var_0_1.canBattleDown(arg_26_0, arg_26_1)
	local var_26_0 = 0
	local var_26_1 = (arg_26_1 - 1) * 6 + 1

	for iter_26_0 = var_26_1, var_26_1 + 5 do
		if arg_26_0.clientBattleCards:read()[iter_26_0] then
			var_26_0 = var_26_0 + 1
		end
	end

	return var_26_0 > 1
end

function var_0_1.canBattleUp(arg_27_0, arg_27_1)
	if arg_27_1 == nil then
		for iter_27_0 = 1, arg_27_0.deployNum do
			local var_27_0 = 0
			local var_27_1 = (iter_27_0 - 1) * 6 + 1

			for iter_27_1 = var_27_1, var_27_1 + 5 do
				if arg_27_0.clientBattleCards:read()[iter_27_1] then
					var_27_0 = var_27_0 + 1
				end
			end

			if var_27_0 < arg_27_0.oneTeamNum then
				return true
			end
		end

		return false
	else
		local var_27_2 = 0
		local var_27_3 = (arg_27_1 - 1) * 6 + 1

		for iter_27_2 = var_27_3, var_27_3 + 5 do
			if arg_27_0.clientBattleCards:read()[iter_27_2] then
				var_27_2 = var_27_2 + 1
			end
		end

		return var_27_2 < arg_27_0.oneTeamNum
	end
end

function var_0_1.getCardNum(arg_28_0, arg_28_1)
	local var_28_0 = 0
	local var_28_1 = (arg_28_1 - 1) * 6 + 1

	for iter_28_0 = var_28_1, var_28_1 + 5 do
		if arg_28_0.clientBattleCards:read()[iter_28_0] then
			var_28_0 = var_28_0 + 1
		end
	end

	return var_28_0
end

function var_0_1.onClose(arg_29_0)
	local var_29_0 = gGameModel.gym:read("date")
	local var_29_1 = arg_29_0.clientBattleCards:read()
	local var_29_2 = {}

	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		var_29_2[iter_29_0] = stringz.bintohex(iter_29_1)
	end

	cc.load("mvc").ViewBase.onClose(arg_29_0)
end

return var_0_1
