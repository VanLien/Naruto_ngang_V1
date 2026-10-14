local var_0_0 = require("app.views.city.zawake.tools")
local var_0_1 = class("MegaView", cc.load("mvc").ViewBase)

local function var_0_2(arg_1_0)
	local var_1_0 = dataEasy.stringMapingID(arg_1_0)
	local var_1_1 = csv.card_mega_convert[var_1_0]

	if not var_1_1 then
		return 0
	end

	return var_1_1.type
end

var_0_1.RESOURCE_FILENAME = "card_mega.json"
var_0_1.RESOURCE_BINDING = {
	anima = "anima",
	item = "item",
	panel = "panel",
	itemPanel = "itemPanel",
	["itemPanel.attrItem"] = "attrItem",
	megaOk = "megaOk",
	animaCard = "animaCard",
	titlePanel = "titlePanel",
	["itemPanel.starItem"] = "starItem",
	["rightPanel.item"] = "rightItem",
	rightPanel = "rightPanel",
	list = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 6,
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1:get("item"), {
						class = "card_icon",
						props = {
							cardId = arg_2_3.id,
							rarity = arg_2_3.unitCfg.rarity,
							grayState = arg_2_3.isHas and 0 or 2,
							onNode = function(arg_3_0)
								arg_3_0:xy(20, 10):z(5)
							end
						}
					})
					arg_2_1:get("item.select"):visible(arg_2_3.isSel)
					arg_2_1:get("item.hint"):visible(not arg_2_3.canDevelop)
					bind.extend(arg_2_0, arg_2_1, {
						class = "red_hint",
						props = {
							specialTag = "cardMega",
							state = not arg_2_3.isSel,
							listenData = {
								megaId = arg_2_3.id
							},
							onNode = function(arg_4_0)
								arg_4_0:xy(200, 180)
							end
						}
					})
					bind.touch(arg_2_0, arg_2_1:get("item"), {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTabItemClick")
			}
		}
	},
	book = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("bookFunc")
			}
		}
	},
	["book.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["itemPanel.starList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("cardStarData"),
				item = bindHelper.self("starItem"),
				onItem = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:get("star"):texture(arg_5_3.icon)
				end
			}
		}
	},
	["itemPanel.attrList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrItem"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1:texture(ui.ATTR_ICON[arg_6_3]):scale(0.8)
				end
			}
		}
	},
	["panel.txt1"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["panel.gold"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["titlePanel.num"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = ui.COLORS.NORMAL.WHITE
				}
			}
		}
	},
	["rightPanel.rule"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("ruleFunc")
			}
		}
	},
	["rightPanel.card.item"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					return arg_7_0:chooseCard()
				end)
			}
		}
	},
	["rightPanel.list"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("rightDatas"),
				item = bindHelper.self("rightItem"),
				dataOrderCmp = function(arg_8_0, arg_8_1)
					local var_8_0 = var_0_2(arg_8_0.key)
					local var_8_1 = var_0_2(arg_8_1.key)

					if var_8_0 ~= var_8_1 then
						return var_8_0 < var_8_1
					end

					return dataEasy.stringMapingID(arg_8_0.key) < dataEasy.stringMapingID(arg_8_1.key)
				end,
				onItem = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					local var_9_0 = arg_9_1:multiget("item", "btn", "num1", "num2")

					itertools.invoke({
						var_9_0.btn,
						var_9_0.num1,
						var_9_0.num2
					}, "hide")

					if arg_9_3.costCards then
						local var_9_1 = itertools.size(arg_9_3.subCardData)
						local var_9_2 = var_9_1 >= arg_9_3.costCards.num

						var_9_0.item:get("add"):visible(not var_9_2)
						var_9_0.num1:show():text(var_9_1)
						var_9_0.num2:show():text("/" .. arg_9_3.costCards.num)
						text.addEffect(var_9_0.num1, {
							color = var_9_2 and ui.COLORS.NORMAL.FRIEND_GREEN or ui.COLORS.NORMAL.ALERT_ORANGE,
							outline = {
								color = ui.COLORS.NORMAL.WHITE
							}
						})
						text.addEffect(var_9_0.num2, {
							outline = {
								color = ui.COLORS.NORMAL.WHITE
							}
						})
						adapt.oneLineCenterPos(cc.p(105, 100), {
							var_9_0.num1,
							var_9_0.num2
						})

						local var_9_3 = arg_9_3.costCards.markID or 1
						local var_9_4 = csv.cards[var_9_3].unitID
						local var_9_5 = csv.unit[var_9_4]

						bind.extend(arg_9_0, var_9_0.item, {
							class = "card_icon",
							props = {
								cardId = var_9_3,
								star = arg_9_3.costCards.star,
								rarity = var_9_5.rarity,
								grayState = var_9_2 and 0 or 1,
								onNode = function(arg_10_0)
									if not arg_9_3.costCards.markID then
										arg_10_0:getChildByName("icon"):texture("config/item/icon_sjjl.png")
									end
								end
							}
						})
						bind.touch(arg_9_0, var_9_0.item, {
							methods = {
								ended = function()
									arg_9_0.chooseCard(arg_9_2, arg_9_3)
								end
							}
						})
					else
						local var_9_6 = arg_9_3.selectNum
						local var_9_7 = var_9_6 >= arg_9_3.val

						var_9_0.item:get("add"):visible(not var_9_7)
						bind.extend(arg_9_0, var_9_0.item, {
							class = "icon_key",
							props = {
								noListener = true,
								grayState = var_9_7 and 0 or 1,
								data = {
									key = arg_9_3.key,
									num = var_9_6,
									targetNum = arg_9_3.val
								},
								onNode = function(arg_12_0)
									arg_12_0:setTouchEnabled(false)
								end
							}
						})
						bind.touch(arg_9_0, var_9_0.item, {
							methods = {
								ended = function()
									jumpEasy.jumpTo("gainWay", arg_9_3.key, nil, arg_9_3.val)
								end
							}
						})

						local var_9_8 = csv.card_mega_convert[arg_9_3.key]

						var_9_0.btn:hide()

						if var_9_8 then
							var_9_0.btn:show()
							bind.touch(arg_9_0, var_9_0.btn, {
								methods = {
									ended = function()
										gGameUI:stackUI("city.card.mega.conversion", nil, nil, {
											id = arg_9_3.key,
											num = arg_9_3.val
										})
									end
								}
							})
						end
					end
				end,
				onAfterBuild = function(arg_15_0)
					arg_15_0:refreshView()

					local var_15_0 = arg_15_0:getChildrenCount()

					if var_15_0 > 0 and var_15_0 < 4 then
						local var_15_1 = {
							0,
							80,
							40
						}

						arg_15_0:setItemsMargin(var_15_1[var_15_0])
					else
						arg_15_0:setItemsMargin(0)
					end

					arg_15_0:setItemAlignCenter()
				end
			},
			handlers = {
				chooseCard = bindHelper.self("chooseCard")
			}
		}
	},
	btn = {
		varname = "conversion",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("conversionClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.topUi = gGameUI.topuiManager:createView("default", arg_16_0, {
		onClose = arg_16_0:createHandler("onClose")
	}):init({
		subTitle = "EVOLUTION MEGA",
		title = gLanguageCsv.megaHouse
	})

	arg_16_0:initModel()
	arg_16_0.anima:hide()

	arg_16_0.cardId = arg_16_1
	arg_16_0.cb = arg_16_2
	arg_16_0.attrDatas = idlers.newWithMap({})
	arg_16_0.rightDatas = idlers.newWithMap({})
	arg_16_0.selectedData = {}
	arg_16_0.tabDatas = idlers.new({})
	arg_16_0.cardSelected = idler.new(1)
	arg_16_0.cardStarData = idlers.new({})

	idlereasy.any({
		arg_16_0.cards,
		arg_16_0.items
	}, function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = {}
		local var_17_1 = {}

		for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
			local var_17_2 = gGameModel.cards:find(iter_17_1)

			if var_17_2 then
				var_17_1[var_17_2:read("card_id")] = true
			end
		end

		for iter_17_2, iter_17_3 in pairs(gCardsMega) do
			local var_17_3 = csv.cards[iter_17_3.key]
			local var_17_4 = csv.unit[var_17_3.unitID]

			table.insert(var_17_0, {
				isSel = false,
				id = iter_17_3.key,
				unitCfg = var_17_4,
				canDevelop = iter_17_3.canDevelop,
				whetherMega = iter_17_3.canDevelop and 1 or 0,
				isHas = var_17_1[iter_17_3.key] ~= nil,
				megaIndex = iter_17_2,
				dbid = dbid,
				markId = var_17_3.cardMarkID
			})
		end

		table.sort(var_17_0, function(arg_18_0, arg_18_1)
			if arg_18_0.whetherMega ~= arg_18_1.whetherMega then
				return arg_18_0.whetherMega > arg_18_1.whetherMega
			end

			if arg_18_0.unitCfg.rarity ~= arg_18_1.unitCfg.rarity then
				return arg_18_0.unitCfg.rarity > arg_18_1.unitCfg.rarity
			end

			return arg_18_0.id < arg_18_1.id
		end)
		arg_16_0.tabDatas:update(var_17_0)

		if arg_16_0.cardId then
			local var_17_5 = false

			for iter_17_4, iter_17_5 in ipairs(var_17_0) do
				if iter_17_5.id == arg_16_0.cardId and iter_17_5.canDevelop then
					var_17_5 = true

					arg_16_0.cardSelected:set(iter_17_4)

					break
				end
			end

			if not var_17_5 then
				local var_17_6 = csv.cards[arg_16_0.cardId].cardMarkID

				for iter_17_6, iter_17_7 in ipairs(var_17_0) do
					if iter_17_7.markId == var_17_6 and iter_17_7.canDevelop then
						local var_17_7 = true

						arg_16_0.cardSelected:set(iter_17_6)

						break
					end
				end
			end
		end

		local var_17_8 = arg_16_0.cardSelected:read()

		arg_16_0:onTabItemClick(nil, var_17_8, arg_16_0.tabDatas:atproxy(var_17_8))
	end)
	arg_16_0.cardSelected:addListener(function(arg_19_0, arg_19_1)
		arg_16_0.tabDatas:atproxy(arg_19_1).isSel = false
		arg_16_0.tabDatas:atproxy(arg_19_0).isSel = true
	end)
	idlereasy.when(arg_16_0.gold, functools.partial(arg_16_0.costGoldUpdate, arg_16_0))
end

function var_0_1.initModel(arg_20_0)
	arg_20_0.pokedex = gGameModel.role:getIdler("pokedex")
	arg_20_0.cards = gGameModel.role:getIdler("cards")
	arg_20_0.items = gGameModel.role:getIdler("items")
	arg_20_0.gold = gGameModel.role:getIdler("gold")
end

function var_0_1.onTabItemClick(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if not arg_21_3.canDevelop then
		gGameUI:showTip(gLanguageCsv.comingSoon)

		return
	end

	arg_21_0.cardId = arg_21_3.id

	arg_21_0.megaOk:visible(arg_21_3.isHas)

	if arg_21_2 ~= arg_21_0.cardSelected:read() or not arg_21_0.selectedData.subCardData then
		arg_21_0.selectedData = {
			key = "main",
			cardId = arg_21_3.id,
			megaIndex = arg_21_3.megaIndex,
			subCardData = {}
		}
	end

	arg_21_0.itemPanel:get("icon"):texture(ui.RARITY_ICON[arg_21_3.unitCfg.rarity])

	local var_21_0 = {}

	table.insert(var_21_0, arg_21_3.unitCfg.natureType)

	if arg_21_3.unitCfg.natureType2 then
		table.insert(var_21_0, arg_21_3.unitCfg.natureType2)
	end

	arg_21_0.attrDatas:update(var_21_0)

	if arg_21_0.cardSprite then
		arg_21_0.cardSprite:removeFromParent()

		arg_21_0.cardSprite = nil
	end

	arg_21_0.cardSprite = widget.addAnimation(arg_21_0.animaCard, arg_21_3.unitCfg.unitRes, "standby_loop", 5):alignCenter(arg_21_0.animaCard:size()):scale(arg_21_3.unitCfg.scaleU * 3):y(-100)

	arg_21_0.cardSprite:setSkin(arg_21_3.unitCfg.skin)
	arg_21_0:cardItemUpdate()

	local var_21_1 = csv.card_mega[arg_21_3.megaIndex]
	local var_21_2 = {}

	if csvSize(var_21_1.costCards) > 0 then
		table.insert(var_21_2, {
			costCards = var_21_1.costCards,
			subCardData = arg_21_0.selectedData.subCardData
		})
	end

	for iter_21_0, iter_21_1 in csvMapPairs(var_21_1.costItems) do
		if iter_21_0 ~= "gold" then
			table.insert(var_21_2, {
				key = iter_21_0,
				val = iter_21_1,
				selectNum = dataEasy.getNumByKey(iter_21_0)
			})
		end
	end

	arg_21_0.rightDatas:update(var_21_2)
	arg_21_0.cardSelected:set(arg_21_2, true)
	arg_21_0:costGoldUpdate()

	local var_21_3 = var_21_1.condition[1] == 1 and string.format(gLanguageCsv.roleLevelReach, var_21_1.condition[2]) or string.format(gLanguageCsv.roleCardLevelReach, var_21_1.condition[2])

	arg_21_0.titlePanel:get("num"):text(var_21_3)
	bind.extend(arg_21_0, arg_21_0.conversion, {
		class = "red_hint",
		props = {
			specialTag = "cardMega",
			listenData = {
				megaId = arg_21_3.id
			},
			onNode = function(arg_22_0)
				arg_22_0:xy(400, 160)
			end
		}
	})
end

function var_0_1.costGoldUpdate(arg_23_0)
	local var_23_0 = csv.card_mega[arg_23_0.selectedData.megaIndex].costItems.gold

	if var_23_0 then
		arg_23_0.panel:show()
		arg_23_0.panel:get("gold"):text(var_23_0)

		local var_23_1 = gGameModel.role:read("gold")

		text.addEffect(arg_23_0.panel:get("gold"), {
			color = var_23_0 <= var_23_1 and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.NORMAL.ALERT_ORANGE
		})
		adapt.oneLineCenterPos(cc.p(400, 40), {
			arg_23_0.panel:get("txt1"),
			arg_23_0.panel:get("gold"),
			arg_23_0.panel:get("icon")
		}, cc.p(8, 0))
	else
		arg_23_0.panel:hide()
	end
end

function var_0_1.cardStarUpdate(arg_24_0, arg_24_1)
	local var_24_0 = csv.card_mega[arg_24_0.selectedData.megaIndex]

	arg_24_1 = arg_24_1 or var_24_0.card[2]

	local var_24_1 = {}
	local var_24_2 = arg_24_1 - 6

	for iter_24_0 = 1, 6 do
		local var_24_3 = "common/icon/icon_star_d.png"

		if iter_24_0 <= arg_24_1 then
			var_24_3 = dataEasy.getStarRes(arg_24_1, iter_24_0)
		end

		table.insert(var_24_1, {
			icon = var_24_3
		})
	end

	arg_24_0.cardStarData:update(var_24_1)
end

function var_0_1.cardItemUpdate(arg_25_0)
	local var_25_0 = arg_25_0.selectedData.cardDbid
	local var_25_1
	local var_25_2

	if var_25_0 then
		local var_25_3 = gGameModel.cards:find(var_25_0)

		var_25_1 = var_25_3:read("star")
		var_25_2 = var_25_3:read("advance")
	end

	uiEasy.setIconName("card", arg_25_0.cardId, {
		space = true,
		node = arg_25_0.itemPanel:get("name"),
		advance = var_25_2
	})
	arg_25_0:cardStarUpdate(var_25_1)

	local var_25_4 = arg_25_0.selectedData.megaIndex
	local var_25_5 = csv.card_mega[var_25_4]
	local var_25_6 = arg_25_0.selectedData.cardDbid
	local var_25_7 = arg_25_0.rightPanel:get("card.txt1")
	local var_25_8 = arg_25_0.rightPanel:get("card.txt2")

	var_25_7:text(var_25_6 and 1 or 0)
	var_25_8:text("/" .. 1)
	text.addEffect(var_25_7, {
		color = var_25_6 and ui.COLORS.NORMAL.FRIEND_GREEN or ui.COLORS.NORMAL.ALERT_ORANGE,
		outline = {
			color = ui.COLORS.NORMAL.WHITE
		}
	})
	text.addEffect(var_25_8, {
		outline = {
			color = ui.COLORS.NORMAL.WHITE
		}
	})
	adapt.oneLineCenterPos(cc.p(140, -20), {
		var_25_7,
		var_25_8
	})
	arg_25_0.rightPanel:get("card.item.add"):visible(var_25_6 == nil)

	local var_25_9 = var_25_5.card[1]
	local var_25_10 = var_25_5.card[2]
	local var_25_11 = 0
	local var_25_12 = csv.cards[var_25_9].unitID
	local var_25_13 = csv.unit[var_25_12].rarity
	local var_25_14 = false
	local var_25_15 = false

	if var_25_6 then
		local var_25_16 = gGameModel.cards:find(var_25_6)

		var_25_9 = var_25_16:read("card_id")
		var_25_11 = var_25_16:read("skin_id")
		var_25_10 = var_25_16:read("star")
		var_25_14 = var_25_16:read("advance")
		var_25_15 = var_25_16:read("level")
	end

	local var_25_17 = dataEasy.getUnitId(var_25_9, var_25_11)
	local var_25_18 = arg_25_0.rightPanel:get("card.item")

	bind.extend(arg_25_0, var_25_18, {
		class = "card_icon",
		props = {
			unitId = var_25_17,
			star = var_25_10,
			rarity = var_25_13,
			advance = var_25_14,
			levelProps = {
				data = var_25_15
			},
			grayState = var_25_6 and 0 or 1,
			onNode = function(arg_26_0)
				arg_26_0:scale(1.3)
				arg_26_0:alignCenter(var_25_18:size())
			end
		}
	})
end

function var_0_1.chooseCard(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0.selectedData.chooseIdx = arg_27_2

	gGameUI:stackUI("city.card.mega.choose_card", nil, nil, arg_27_0.selectedData, arg_27_0:createHandler("itemCallback"))
end

function var_0_1.itemCallback(arg_28_0)
	if arg_28_0.selectedData.chooseIdx then
		arg_28_0.rightDatas:atproxy(arg_28_0.selectedData.chooseIdx).subCardData = arg_28_0.selectedData.subCardData
	else
		arg_28_0:cardItemUpdate()
	end
end

function var_0_1.animaFunc(arg_29_0, arg_29_1)
	arg_29_0.megaOk:hide()
	arg_29_0.cardSprite:hide()
	arg_29_0.anima:show()
	arg_29_0.topUi:hide()
	audio.playEffectWithWeekBGM("maga.mp3")

	local var_29_0 = csv.cards[arg_29_1].unitID
	local var_29_1 = csv.cards[arg_29_0.cardId].unitID
	local var_29_2 = csv.unit[var_29_0].unitRes
	local var_29_3 = csv.unit[var_29_1].unitRes

	arg_29_0.animaHou = widget.addAnimationByKey(arg_29_0.anima, "chaojinhua/chaojinhua.skel", "hou", "chaojinhua_effect_hou", 1):alignCenter(arg_29_0.anima:size()):scale(2)
	arg_29_0.cardSprite1 = widget.addAnimationByKey(arg_29_0.anima, var_29_2, "cards1", "standby_loop", 3):alignCenter(arg_29_0.anima:size())
	arg_29_0.cardSprite2 = widget.addAnimationByKey(arg_29_0.anima, var_29_3, "cards2", "standby_loop", 2):alignCenter(arg_29_0.anima:size())

	arg_29_0.cardSprite2:hide()

	arg_29_0.animaQian = widget.addAnimationByKey(arg_29_0.anima, "chaojinhua/chaojinhua.skel", "qian", "chaojinhua_effect_qian", 4):alignCenter(arg_29_0.anima:size()):scale(2)

	local var_29_4 = "juese_move"
	local var_29_5 = cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function()
		local var_30_0, var_30_1 = arg_29_0.animaHou:getPosition()
		local var_30_2 = arg_29_0.animaHou:getScaleX()
		local var_30_3 = arg_29_0.animaHou:getScaleY()
		local var_30_4 = arg_29_0.animaHou:getBonePosition(var_29_4)
		local var_30_5 = arg_29_0.animaHou:getBoneRotation(var_29_4)
		local var_30_6 = arg_29_0.animaHou:getBoneScaleX(var_29_4)
		local var_30_7 = arg_29_0.animaHou:getBoneScaleY(var_29_4)

		arg_29_0.cardSprite1:rotate(-var_30_5):scaleX(var_30_6 * 2):scaleY(var_30_7 * 2):xy(cc.p(var_30_4.x * var_30_2 + var_30_0, var_30_4.y * var_30_3 + var_30_1))
		arg_29_0.cardSprite2:rotate(-var_30_5):scaleX(var_30_6 * 2):scaleY(var_30_7 * 2):xy(cc.p(var_30_4.x * var_30_2 + var_30_0, var_30_4.y * var_30_3 + var_30_1))
	end)))

	arg_29_0.cardSprite1:runAction(var_29_5)
	arg_29_0.cardSprite2:runAction(var_29_5)
	performWithDelay(arg_29_0, function(...)
		local var_31_0 = 2
		local var_31_1 = {
			255,
			255,
			255,
			1
		}

		arg_29_0.cardSprite1:setHSLShader(var_31_1[1], var_31_1[2], var_31_1[3], var_31_1[4], var_31_1[5], var_31_0)
	end, 2)
	performWithDelay(arg_29_0, function()
		arg_29_0.cardSprite1:hide()
		arg_29_0.cardSprite2:show()
	end, 5.5)
	performWithDelay(arg_29_0, function()
		arg_29_0.cardSprite:show()
		arg_29_0.cardSprite1:removeAllChildren()
		arg_29_0.cardSprite2:removeAllChildren()
		arg_29_0.anima:removeAllChildren()
		arg_29_0.anima:hide()

		arg_29_0.animaQian = nil
		arg_29_0.animaHou = nil

		arg_29_0.topUi:show()

		local var_33_0 = arg_29_0.tabDatas:atproxy(arg_29_0.cardSelected:read()).isHas

		arg_29_0.megaOk:visible(var_33_0)
	end, 7.5)
end

function var_0_1.conversionClick(arg_34_0)
	if not arg_34_0.selectedData.cardDbid then
		gGameUI:showTip(gLanguageCsv.megaMaterialsNotEnough)

		return
	end

	local var_34_0 = csv.card_mega[arg_34_0.selectedData.megaIndex]

	if csvSize(var_34_0.costCards) ~= 0 and itertools.size(arg_34_0.selectedData.subCardData) < var_34_0.costCards.num then
		gGameUI:showTip(gLanguageCsv.megaMaterialsNotEnough)

		return
	end

	local var_34_1 = gGameModel.cards:find(arg_34_0.selectedData.cardDbid)

	if var_34_0.condition[1] == 1 and gGameModel.role:read("level") < var_34_0.condition[2] then
		gGameUI:showTip(gLanguageCsv.cardDissatisfy)

		return
	end

	if var_34_0.condition[1] == 2 and var_34_1:read("level") < var_34_0.condition[2] then
		gGameUI:showTip(string.format(gLanguageCsv.roleCardLevelReach, var_34_0.condition[2]))

		return
	end

	for iter_34_0, iter_34_1 in csvMapPairs(var_34_0.costItems) do
		if iter_34_0 ~= "gold" and iter_34_1 > dataEasy.getNumByKey(iter_34_0) then
			gGameUI:showTip(gLanguageCsv.megaMaterialsNotEnough)

			return
		end
	end

	local var_34_2 = gGameModel.role:read("gold")

	if var_34_0.costItems.gold and var_34_2 < var_34_0.costItems.gold then
		gGameUI:showTip(gLanguageCsv.goldNotEnough)

		return
	end

	local var_34_3 = clone(var_34_1:read("attrs"))
	local var_34_4 = var_34_1:read("card_id")
	local var_34_5 = var_34_1:read("id")
	local var_34_6 = var_34_1:read("fighting_point")
	local var_34_7 = csv.cards[arg_34_0.cardId].branch
	local var_34_8 = {}

	for iter_34_2 in pairs(arg_34_0.selectedData.subCardData) do
		table.insert(var_34_8, iter_34_2)
	end

	local var_34_9 = arg_34_0.tabDatas:atproxy(arg_34_0.cardSelected:read()).isHas
	local var_34_10 = gLanguageCsv.whetherMega
	local var_34_11 = csv.cards[var_34_4].zawakeID
	local var_34_12, var_34_13 = var_0_0.getMaxStageLevel(var_34_11)

	if var_34_12 then
		local var_34_14 = csv.cards[var_34_4].name
		local var_34_15 = gLanguageCsv["symbolRome" .. var_34_12]

		var_34_10 = string.format(gLanguageCsv.zawakeMegaTip, var_34_14, var_34_15)
	end

	gGameUI:showDialog({
		fontSize = 50,
		btnType = 2,
		isRich = true,
		title = gLanguageCsv.spaceTips,
		content = var_34_10,
		cb = function()
			local var_35_0 = {
				false
			}
			local var_35_1 = arg_34_0.selectedData.cardDbid

			arg_34_0.selectedData.cardDbid = nil
			arg_34_0.selectedData.subCardData = nil

			gGameApp:requestServerCustom("/game/develop/mega"):params(var_34_5, var_34_7, var_34_8):onResponse(function(arg_36_0)
				arg_34_0:animaFunc(var_34_4)
				performWithDelay(arg_34_0, function()
					arg_34_0.anima:hide()

					if arg_34_0.cb then
						arg_34_0.cb()
					end

					var_35_0[1] = true
				end, 7.5)
			end):wait(var_35_0):doit(function(arg_38_0)
				local function var_38_0()
					gGameUI:stackUI("city.card.common_success", nil, {
						blackLayer = true
					}, var_35_1, var_34_6, {
						mega = true,
						cardOld = var_34_4,
						attrs = var_34_3
					})
				end

				if not itertools.isempty(arg_38_0.view) then
					gGameUI:showGainDisplay(arg_38_0.view, {
						cb = var_38_0
					})
				else
					var_38_0()
				end
			end)
		end
	})
end

function var_0_1.bookFunc(arg_40_0)
	gGameUI:stackUI("city.handbook.view", nil, {
		full = true
	}, {
		cardId = arg_40_0.cardId
	})
end

function var_0_1.ruleFunc(arg_41_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_41_0:createHandler("getRuleContext"), {
		width = 1300
	})
end

function var_0_1.getRuleContext(arg_42_0, arg_42_1)
	local var_42_0 = {
		95001,
		95010
	}
	local var_42_1 = adaptContext

	return {
		var_42_1.clone(arg_42_1.title, function(arg_43_0)
			arg_43_0:get("text"):text(gLanguageCsv.megaHouse)
		end),
		var_42_1.noteText(unpack(var_42_0))
	}
end

return var_0_1
