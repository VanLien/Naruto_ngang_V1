local var_0_0 = require("app.views.city.card.embattle.base")
local var_0_1 = class("GymChallengeEmbattleView", var_0_0)

var_0_1.RESOURCE_FILENAME = "gym_embattle2.json"
var_0_1.RESOURCE_BINDING = {
	bottomPanel = "bottomPanel",
	["rightTop.imgBg"] = "attrBg",
	textNotRole = "emptyTxt",
	upItem = "upItem",
	["rightTop.textNote"] = "textNote",
	rightTop = "rightTop",
	battlePanel = "battlePanel",
	rightDown = "rightDown",
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
	},
	["textPanel.textNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("battleNum")
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
end

function var_0_1.initDefine(arg_4_0, arg_4_1)
	arg_4_0.embattleMax = csv.gym.gate[arg_4_1.gateId].deployCardNumLimit
	arg_4_0.panelNum = arg_4_0.embattleMax
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

function var_0_1.initHeroSprite(arg_10_0)
	arg_10_0.heroSprite = {}

	for iter_10_0 = 1, arg_10_0.embattleMax do
		local var_10_0 = arg_10_0.upItem:clone():addTo(arg_10_0.battlePanel, 2, "panel" .. iter_10_0)

		var_10_0:show()

		arg_10_0.heroSprite[iter_10_0] = {
			sprite = var_10_0,
			idx = iter_10_0
		}
	end

	local var_10_1 = 50
	local var_10_2 = arg_10_0.upItem:width()
	local var_10_3 = arg_10_0.battlePanel:size()
	local var_10_4 = 0

	if arg_10_0.embattleMax <= 6 then
		local var_10_5 = (var_10_2 + var_10_1) * (arg_10_0.embattleMax - 1)
		local var_10_6 = var_10_3.width / 2 - var_10_5 / 2

		for iter_10_1 = 1, arg_10_0.embattleMax do
			arg_10_0.heroSprite[iter_10_1].sprite:xy(var_10_6 + (iter_10_1 - 1) * (var_10_2 + var_10_1), var_10_3.height / 2 + 110)
		end
	else
		local var_10_7 = (var_10_2 + var_10_1) * (math.ceil(arg_10_0.embattleMax / 2) - 1)
		local var_10_8 = var_10_3.width / 2 - var_10_7 / 2
		local var_10_9 = arg_10_0.upItem:height()

		for iter_10_2 = 1, arg_10_0.embattleMax do
			local var_10_10 = arg_10_0.embattleMax - math.floor(arg_10_0.embattleMax / 2)

			if iter_10_2 <= math.ceil(arg_10_0.embattleMax / 2) then
				arg_10_0.heroSprite[iter_10_2].sprite:xy(var_10_8 + (iter_10_2 - 1) * (var_10_2 + var_10_1), var_10_3.height / 2 + 120 + var_10_9 / 2 + 5)
			else
				arg_10_0.heroSprite[iter_10_2].sprite:xy(var_10_8 + (iter_10_2 - var_10_10 - 1) * (var_10_2 + var_10_1), var_10_3.height / 2 + 120 - var_10_9 / 2 - 5)
			end
		end
	end

	local var_10_11 = {}

	idlereasy.when(arg_10_0.clientBattleCards, function(arg_11_0, arg_11_1)
		local var_11_0 = 0
		local var_11_1 = true

		for iter_11_0 = 1, arg_10_0.embattleMax do
			local var_11_2 = arg_10_0.heroSprite[iter_11_0]
			local var_11_3 = var_11_2.sprite
			local var_11_4 = arg_11_1[iter_11_0]

			var_11_2.sprite:get("tagIdx"):text(string.format(gLanguageCsv.unionFightRound, iter_11_0))
			var_11_3:onTouch(functools.partial(arg_10_0.onBattleCardTouch, arg_10_0, iter_11_0))

			if var_11_4 then
				local var_11_5 = gGameModel.cards:find(var_11_4)

				var_11_3:get("add"):hide()

				local var_11_6 = var_11_3:get("info"):show()
				local var_11_7 = var_11_6:multiget("head", "level", "text", "fightPoint", "attr1", "attr2")

				var_11_7.fightPoint:text(var_11_5:read("fighting_point"))
				adapt.oneLineCenterPos(cc.p(170, 50), {
					var_11_7.text,
					var_11_7.fightPoint
				}, cc.p(5, 0))
				var_11_7.level:text("Lv" .. var_11_5:read("level"))

				local var_11_8 = dataEasy.getUnitId(var_11_5:read("card_id"), var_11_5:read("skin_id"))
				local var_11_9 = csv.unit[var_11_8]
				local var_11_10 = var_11_9.natureType
				local var_11_11 = var_11_9.natureType2

				var_11_7.attr1:texture(ui.ATTR_ICON[var_11_10])
				var_11_7.attr2:visible(var_11_11 and true or false)
				adapt.oneLineCenterPos(cc.p(170, 140), {
					var_11_7.level,
					var_11_7.attr1,
					var_11_7.attr2
				}, cc.p(5, 0))

				if var_11_11 then
					var_11_7.attr2:texture(ui.ATTR_ICON[var_11_11])
				end

				var_11_6:removeChildByName("starPanel")
				uiEasy.getStarPanel(var_11_5:read("star"), {
					interval = -5,
					align = "center"
				}):scale(0.35):xy(170, 100):addTo(var_11_6, 2)
				bind.extend(arg_10_0, var_11_7.head, {
					class = "card_icon",
					props = {
						unitId = var_11_8,
						rarity = var_11_5:read("rarity"),
						advance = var_11_5:read("advance"),
						onNode = function(arg_12_0)
							arg_12_0:xy(-6, -6)
						end
					}
				})

				var_11_0 = var_11_0 + 1
			else
				var_11_3:get("add"):show()
				var_11_3:get("info"):hide()
			end

			if not var_10_11[arg_11_1[iter_11_0]] and arg_11_1[iter_11_0] then
				var_11_1 = false
			end
		end

		if not var_11_1 or itertools.size(var_10_11) ~= var_11_0 then
			var_10_11 = itertools.map(arg_11_1, function(arg_13_0, arg_13_1)
				return arg_13_1, arg_13_0
			end)
		end

		arg_10_0.battleNum:set(var_11_0 .. "/" .. arg_10_0.embattleMax)
	end)
end

function var_0_1.createMovePanel(arg_14_0, arg_14_1)
	if arg_14_0.movePanel then
		arg_14_0.movePanel:removeSelf()
	end

	local var_14_0 = arg_14_0.spriteItem:clone():addTo(arg_14_0:getResourceNode(), 1000)

	bind.extend(arg_14_0, var_14_0, {
		class = "card_icon",
		props = {
			unitId = arg_14_1.unit_id,
			advance = arg_14_1.advance,
			rarity = arg_14_1.rarity,
			star = arg_14_1.star,
			levelProps = {
				data = arg_14_1.level
			},
			onNode = function(arg_15_0)
				arg_15_0:xy(-2, -2)
			end
		}
	})
	var_14_0:show()

	arg_14_0.movePanel = var_14_0

	return var_14_0
end

function var_0_1.onBattleCardTouch(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.clientBattleCards:read()[arg_16_1]

	if not var_16_0 then
		return
	end

	local var_16_1 = arg_16_0:getCardAttrs(var_16_0)

	if arg_16_2.name == "began" then
		arg_16_0:createMovePanel(var_16_1)
		arg_16_0.selectIndex:set(arg_16_1)
		arg_16_0.heroSprite[arg_16_1].sprite:get("info"):hide()
		arg_16_0.heroSprite[arg_16_1].sprite:get("add"):show()
		arg_16_0.movePanel:xy(arg_16_2.x, arg_16_2.y)
	elseif arg_16_2.name == "moved" then
		arg_16_0:moveMovePanel(arg_16_2)
	elseif arg_16_2.name == "ended" or arg_16_2.name == "cancelled" then
		arg_16_0.heroSprite[arg_16_1].sprite:get("info"):show()
		arg_16_0.heroSprite[arg_16_1].sprite:get("add"):hide()
		arg_16_0:deleteMovingItem()

		if arg_16_2.y < 340 then
			arg_16_0:onCardClick(var_16_1, true)
		else
			local var_16_2 = arg_16_0:whichEmbattleTargetPos(arg_16_2)

			if var_16_2 then
				if var_16_2 ~= arg_16_1 then
					arg_16_0:onCardMove(var_16_1, var_16_2, true)
					audio.playEffectWithWeekBGM("formation.mp3")
				else
					arg_16_0:onCardMove(var_16_1, var_16_2, false)
				end
			else
				arg_16_0:onCardMove(var_16_1, arg_16_1, false)
			end
		end
	end
end

function var_0_1.whichEmbattleTargetPos(arg_17_0, arg_17_1)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.heroSprite) do
		local var_17_0 = iter_17_1.sprite
		local var_17_1 = var_17_0:box()
		local var_17_2 = var_17_0:getParent():convertToWorldSpace(cc.p(var_17_1.x, var_17_1.y))

		var_17_1.x, var_17_1.y = var_17_2.x, var_17_2.y

		if cc.rectContainsPoint(var_17_1, arg_17_1) then
			return iter_17_0
		end
	end
end

function var_0_1.onClose(arg_18_0)
	local var_18_0 = gGameModel.gym:read("date")
	local var_18_1 = arg_18_0.clientBattleCards:read()
	local var_18_2 = {}

	for iter_18_0, iter_18_1 in pairs(var_18_1) do
		var_18_2[iter_18_0] = stringz.bintohex(iter_18_1)
	end

	cc.load("mvc").ViewBase.onClose(arg_18_0)
end

return var_0_1
