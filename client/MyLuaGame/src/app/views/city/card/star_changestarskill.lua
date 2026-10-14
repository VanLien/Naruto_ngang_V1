local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("CardStarChangeSkillView", Dialog)

local function var_0_2(arg_1_0)
	local var_1_0 = csv.cards[arg_1_0.id]
	local var_1_1 = gGameModel.cards:find(arg_1_0.dbid):read("getstar")
	local var_1_2 = arg_1_0.star
	local var_1_3 = 1

	if var_1_1 < var_1_2 then
		for iter_1_0 = var_1_1, var_1_2 - 1 do
			local var_1_4 = gStarCsv[var_1_0.starTypeID][iter_1_0]

			if var_1_4 then
				var_1_3 = var_1_3 + var_1_4.costCardNum
			end
		end
	end

	return var_1_3
end

var_0_1.RESOURCE_FILENAME = "card_star_skill.json"
var_0_1.RESOURCE_BINDING = {
	["selectPanel.textNum"] = "textNum",
	["barPanel.needFrags"] = "needFrags",
	item = "item",
	cardPanel2 = "cardPanel2",
	textTips = "textTips",
	["selectPanel.subList"] = "subList",
	cardItem = "cardItem",
	["selectPanel.bg.bgIcon"] = "bgIcon",
	["barPanel.bar"] = "slider",
	barPanel = "barPanel",
	combTipPos = "combTipPos",
	cardPanel1 = "cardPanel1",
	["barPanel.myFrags"] = "myFrags",
	closeBtn = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	titleTxt = {
		varname = "title",
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.BLUE1
					}
				}
			}
		}
	},
	btnList = {
		varname = "btnList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:get("btn")
					local var_2_1 = arg_2_1:get("title")

					var_2_1:text(arg_2_3.name)
					var_2_0:setBright(not arg_2_3.isSelected)
					arg_2_1:onClick(functools.partial(arg_2_0.itemClick, arg_2_2))

					if arg_2_3.isSelected then
						text.addEffect(var_2_1, {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.YELLOW
							},
							color = ui.COLORS.NORMAL.YELLOW
						})
					else
						text.addEffect(var_2_1, {
							outline = {
								size = 4,
								color = ui.NEWCOLORS.OUTLINE.BLUE
							},
							color = ui.COLORS.NORMAL.WHITE
						})
					end
				end
			},
			handlers = {
				itemClick = bindHelper.self("onChangePage")
			}
		}
	},
	["cardPanel2.card1"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFragClick")
			}
		}
	},
	["cardPanel2.btnFrags"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUniversalFragClick")
			}
		}
	},
	["cardPanel2.btnFrags.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["barPanel.subBtn"] = {
		varname = "subBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onReduceClick")
			}
		}
	},
	["barPanel.addBtn"] = {
		varname = "addBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddClick")
			}
		}
	},
	changeBtn = {
		varname = "changeBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["changeBtn.title"] = {
		varname = "btnTxt",
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["selectPanel.progressBar2"] = {
		binds = {
			event = "extend",
			class = "loadingbar",
			props = {
				maskImg = "common/icon/mask_bar_red.png",
				data = bindHelper.self("chipBarPercent")
			}
		}
	},
	["selectPanel.textHasNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("chipNum")
		}
	},
	["selectPanel.textNeedNum"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("chipNeed")
		}
	},
	["selectPanel.btnFrags"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUniversalFragClick")
			}
		}
	},
	["selectPanel.btnFrags.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["selectPanel.btnAdd"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onGainWayClick")
			}
		}
	},
	selectPanel = {
		varname = "selectPanel",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("selectPanelState")
			},
			{
				event = "click",
				method = bindHelper.self("onSelectPanelClick")
			}
		}
	},
	["selectPanel.btnCombine"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCombClick")
			}
		}
	},
	["selectPanel.btnCombine.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["selectPanel.btnSure"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["selectPanel.btnSure.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["selectPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 8,
				columnSize = 2,
				data = bindHelper.self("cardInfos"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("cardItem"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_0:getIdx(arg_3_2)

					arg_3_1:name("item" .. var_3_0.k)
					bind.extend(arg_3_0, arg_3_1:get("iconPanel"), {
						class = "card_icon",
						props = {
							cardId = arg_3_3.id,
							advance = arg_3_3.advance,
							rarity = arg_3_3.rarity,
							star = arg_3_3.star,
							levelProps = {
								data = arg_3_3.level
							},
							params = {
								starScale = 0.37,
								starInterval = 14
							}
						}
					})
					uiEasy.setIconName("card", arg_3_3.id, {
						space = true,
						node = arg_3_1:get("textName"),
						name = arg_3_3.name,
						advance = arg_3_3.advance
					})
					arg_3_1:get("textFight"):text(arg_3_3.fight)
					arg_3_1:get("iconLock"):visible(arg_3_3.locked)
					arg_3_1:get("textPanel"):visible(arg_3_3.battleType ~= nil)

					if arg_3_3.battleType and ui.CARD_USING_TXTS[arg_3_3.battleType] then
						local var_3_1 = arg_3_1:get("textPanel"):get("text")

						var_3_1:text(gLanguageCsv[ui.CARD_USING_TXTS[arg_3_3.battleType]])
						uiEasy.addTextEffect1(var_3_1)
					end

					adapt.oneLinePos(arg_3_1:get("textFightNote"), arg_3_1:get("textFight"))
					arg_3_1:get("mask"):visible(arg_3_3.status ~= 0)
					arg_3_1:get("iconSelect"):visible(arg_3_3.selectState == true)
					arg_3_1:setTouchEnabled(arg_3_3.status == 0)

					if arg_3_3.canSelect == false and arg_3_3.selectState == false then
						arg_3_1:setTouchEnabled(false)
						arg_3_1:get("mask"):show()
					end

					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.itemClick, arg_3_0:getIdx(arg_3_2), arg_3_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCardItemClick")
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0.selectDbId = arg_4_1()
	arg_4_0.chipBarPercent = idler.new(0)
	arg_4_0.chipNum = idler.new(0)
	arg_4_0.chipNeed = idler.new(0)
	arg_4_0.needCash = idler.new(0)
	arg_4_0.selectPanelState = idler.new(false)
	arg_4_0.cardInfos = idlers.new()
	arg_4_0.selectIdx = idler.new()
	arg_4_0.costNum = idler.new(0)
	arg_4_0.getNum = idler.new(0)
	arg_4_0.selectEpNum = idler.new(0)
	arg_4_0.selectedFragId = idler.new(0)

	arg_4_0:initModel()

	local var_4_0 = {}
	local var_4_1 = arg_4_0.cardId:read()
	local var_4_2 = {
		{
			isSelected = false,
			name = gLanguageCsv.cardChange
		},
		{
			isSelected = false,
			name = gLanguageCsv.fragChange
		}
	}

	arg_4_0.tabIdx = idler.new(1)

	local var_4_3 = csv.cards[csv.cards[var_4_1].cardMarkID].starSkillSeqID
	local var_4_4 = csv.card_star_skill[var_4_3].cardExchangeRate

	arg_4_0.fragExchangeRate = csv.card_star_skill[var_4_3].fragExchangeRate

	local var_4_5 = csv.card_star_skill[var_4_3].universalCards

	idlereasy.any({
		arg_4_0.costNum,
		arg_4_0.tabIdx,
		arg_4_0.getNum
	}, function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = arg_4_0.cardPanel1

		var_5_0:setVisible(arg_5_2 == 1)

		local var_5_1 = csv.cards[var_4_1]
		local var_5_2 = csv.unit[var_5_1.unitID]
		local var_5_3 = dataEasy.getCfgByKey(csv.cards[var_4_1].fragID).quality
		local var_5_4 = ui.COLORS.QUALITY[var_5_3]

		if arg_5_2 == 1 then
			local var_5_5 = arg_5_1 < 1 and 1 or 0
			local var_5_6 = {
				class = "card_icon",
				props = {
					cardId = var_4_1,
					rarity = var_5_2.rarity,
					grayState = var_5_5,
					advance = var_5_2.advance,
					star = var_5_2.star,
					levelProps = {
						data = var_5_2.level
					},
					onNode = function(arg_6_0)
						arg_6_0:setTouchEnabled(false)

						local var_6_0 = arg_6_0:box()

						arg_6_0:alignCenter(var_6_0)
						uiEasy.setCardNum(arg_6_0, arg_5_1, nil, var_5_3)

						if arg_5_1 == 0 then
							arg_6_0:get("num"):text(arg_5_1)
						end
					end
				}
			}

			bind.extend(arg_4_0, var_5_0:get("card1"), var_5_6)
			var_5_0:get("card1.imgAdd"):visible(var_5_5 == 1)
			uiEasy.setIconName("card", var_4_1, {
				space = true,
				node = var_5_0:get("textName1"),
				name = var_5_1.name,
				advance = var_5_1.advance
			})
			text.addEffect(var_5_0:get("textName1"), {
				color = var_5_4
			})
			bind.touch(arg_4_0, var_5_0:get("card1"), {
				methods = {
					ended = function()
						arg_4_0.selectPanelState:set(true)
					end
				}
			})

			local var_5_7 = "star_skill_points_" .. var_5_1.cardMarkID
			local var_5_8 = var_4_4 * arg_5_3

			bind.extend(arg_4_0, var_5_0:get("card2"), {
				class = "icon_key",
				props = {
					data = {
						key = var_5_7,
						num = var_5_8
					},
					onNode = function(arg_8_0)
						if var_4_4 * arg_5_3 == 0 then
							arg_8_0:get("num"):text(0)
						end
					end
				}
			})
			uiEasy.setIconName(var_5_7, var_5_8, {
				node = var_5_0:get("textName2")
			})
			text.addEffect(var_5_0:get("textName2"), {
				color = var_5_4
			})
			arg_4_0.barPanel:hide()
		end
	end)

	local var_4_6 = 0

	idlereasy.any({
		arg_4_0.selectedFragId,
		arg_4_0.selectEpNum,
		arg_4_0.tabIdx,
		arg_4_0.frags
	}, function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		local var_9_0 = arg_4_0.cardPanel2

		var_9_0:setVisible(arg_9_3 == 2)

		local var_9_1 = csv.cards[var_4_1]
		local var_9_2 = csv.unit[var_9_1.unitID]
		local var_9_3 = dataEasy.getCfgByKey(csv.cards[var_4_1].fragID).quality
		local var_9_4 = ui.COLORS.QUALITY[var_9_3]

		if arg_9_3 == 2 then
			local var_9_5 = 0

			if arg_9_1 > 0 then
				var_9_5 = dataEasy.getNumByKey(arg_9_1)

				local var_9_6 = {
					class = "icon_key",
					props = {
						data = {
							key = arg_9_1,
							num = var_9_5
						},
						onNode = function(arg_10_0)
							arg_10_0:setTouchEnabled(false)
						end
					}
				}

				var_9_0:get("textName1"):text(uiEasy.setIconName(arg_9_1))
				bind.extend(arg_4_0, var_9_0:get("card1.icon"), var_9_6)
				text.addEffect(var_9_0:get("textName1"), {
					color = var_9_4
				})
			else
				var_9_0:get("textName1"):text(gLanguageCsv.selectFragment)
				text.addEffect(var_9_0:get("textName1"), {
					color = ui.COLORS.NORMAL.DEFAULT
				})
			end

			var_9_0:get("card1.imgAdd"):visible(arg_9_1 == 0)
			var_9_0:get("card1.icon"):visible(arg_9_1 > 0)

			local var_9_7 = "star_skill_points_" .. var_9_1.cardMarkID
			local var_9_8 = arg_9_2

			bind.extend(arg_4_0, var_9_0:get("card2"), {
				class = "icon_key",
				props = {
					data = {
						key = var_9_7,
						num = math.max(var_9_8, 1)
					}
				}
			})
			uiEasy.setIconName(var_9_7, var_9_8, {
				node = var_9_0:get("textName2")
			})
			text.addEffect(var_9_0:get("textName2"), {
				color = var_9_4
			})

			var_4_6 = var_9_5

			if not arg_4_0.slider:isHighlighted() then
				local var_9_9 = math.ceil(arg_9_2 / var_4_6 * 100)

				arg_4_0.slider:setPercent(var_9_9)

				if var_4_6 == 0 then
					arg_4_0.slider:setTouchEnabled(false)
				else
					arg_4_0.slider:setTouchEnabled(true)
				end
			end

			arg_4_0.barPanel:show()
			arg_4_0.needFrags:text("/" .. var_4_6)
			arg_4_0.myFrags:text(arg_9_2)
			adapt.oneLineCenterPos(cc.p(arg_4_0.barPanel:size().width / 2, arg_4_0.myFrags:y()), {
				arg_4_0.myFrags,
				arg_4_0.needFrags
			})
			uiEasy.setBtnShader(arg_4_0.addBtn, nil, arg_9_2 + arg_4_0.fragExchangeRate <= var_4_6 and 1 or 2)
			uiEasy.setBtnShader(arg_4_0.subBtn, nil, arg_9_2 > 0 and 1 or 2)
		end
	end)
	arg_4_0.slider:setPercent(0)
	arg_4_0.slider:addEventListener(function(arg_11_0, arg_11_1)
		if arg_11_1 == ccui.SliderEventType.percentChanged then
			local var_11_0 = arg_11_0:getPercent()
			local var_11_1 = math.ceil(var_4_6 * var_11_0 / 100)
			local var_11_2 = math.floor(var_11_1 / arg_4_0.fragExchangeRate) * arg_4_0.fragExchangeRate

			arg_4_0.selectEpNum:set(var_11_2)
		end
	end)

	arg_4_0.tabDatas = idlers.newWithMap(var_4_2)

	arg_4_0.tabIdx:addListener(function(arg_12_0, arg_12_1, arg_12_2)
		if arg_4_0.tabDatas:atproxy(arg_12_1) then
			arg_4_0.tabDatas:atproxy(arg_12_1).isSelected = false
		end

		if arg_4_0.tabDatas:atproxy(arg_12_0) then
			arg_4_0.tabDatas:atproxy(arg_12_0).isSelected = true
		end

		local var_12_0 = ""

		if arg_12_0 == 1 then
			local var_12_1 = csv.cards[var_4_1]
			local var_12_2 = csv.unit[var_12_1.unitID]
			local var_12_3 = dataEasy.getCfgByKey(csv.cards[var_4_1].fragID).quality
			local var_12_4 = ui.QUALITYCOLOR[var_12_3]
			local var_12_5 = csv.unit[var_12_1.unitID].rarity

			var_12_0 = string.format(gLanguageCsv.starSkillCardChangeTips, var_12_4 .. gLanguageCsv["rarityCard" .. var_12_5 - 1], var_4_4)
		else
			var_12_0 = string.format(gLanguageCsv.starSkillFragChangeTips, arg_4_0.fragExchangeRate)
		end

		arg_4_0.combTipPos:removeChildByName("richTxt")
		rich.createByStr(var_12_0, 40):anchorPoint(0.5, 0.5):addTo(arg_4_0.combTipPos, 6, "richTxt")
		arg_4_0.btnTxt:text(gLanguageCsv.spaceExchange)
	end)
	idlereasy.when(arg_4_0.frags, function(arg_13_0, arg_13_1)
		arg_4_0:setFragsPanel()
	end)
	idlereasy.when(arg_4_0.cards, function(arg_14_0, arg_14_1)
		arg_4_0:setCardDatas(arg_14_1, var_4_5)
	end)
	idlereasy.when(arg_4_0.selectIdx, function(arg_15_0, arg_15_1)
		arg_4_0.textNum:text("0")

		if arg_4_0.cardInfos:atproxy(arg_15_1) then
			local var_15_0 = arg_4_0.cardInfos:atproxy(arg_15_1)

			var_15_0.selectState = not var_15_0.selectState

			local var_15_1 = 0
			local var_15_2 = {}

			for iter_15_0 = 1, arg_4_0.cardInfos:size() do
				local var_15_3 = arg_4_0.cardInfos:atproxy(iter_15_0)

				if var_15_3.selectState == true then
					var_15_1 = var_15_1 + 1

					table.insert(var_15_2, var_15_3.dbid)
				end
			end

			arg_4_0.selectNum = var_15_1

			arg_4_0.textNum:text(var_15_1)

			for iter_15_1 = 1, arg_4_0.cardInfos:size() do
				arg_4_0.cardInfos:atproxy(iter_15_1).canSelect = true
			end
		end
	end)

	if matchLanguage({
		"en"
	}) then
		adapt.setTextAdaptWithSize(arg_4_0.textTips, {
			vertical = "center",
			size = cc.size(800, 120)
		})
	end

	Dialog.onCreate(arg_4_0)
end

function var_0_1.initModel(arg_16_0)
	arg_16_0.cards = gGameModel.role:getIdler("cards")
	arg_16_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_16_0.frags = gGameModel.role:getIdler("frags")

	idlereasy.when(arg_16_0.selectDbId, function(arg_17_0, arg_17_1)
		arg_16_0.costCardIDs = {}

		local var_17_0 = gGameModel.cards:find(arg_17_1)

		arg_16_0.cardId = idlereasy.assign(var_17_0:getIdler("card_id"), arg_16_0.cardId)
		arg_16_0.star = idlereasy.assign(var_17_0:getIdler("star"), arg_16_0.star)
	end)
end

function var_0_1.onAddClick(arg_18_0)
	arg_18_0.selectEpNum:set(arg_18_0.selectEpNum:read() + arg_18_0.fragExchangeRate)
end

function var_0_1.onReduceClick(arg_19_0)
	arg_19_0.selectEpNum:set(arg_19_0.selectEpNum:read() - arg_19_0.fragExchangeRate)
end

function var_0_1.onChangePage(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.tabIdx:set(arg_20_2)
end

function var_0_1.onChangeClick(arg_21_0)
	if arg_21_0.tabIdx:read() == 1 then
		if #arg_21_0.costCardIDs == 0 then
			gGameUI:showTip(string.format(gLanguageCsv.pleaseSelectNumber, gLanguageCsv.starSkillExchange))

			return
		end

		gGameApp:requestServer("/game/card/star/skill/card/exchange", function(arg_22_0)
			gGameUI:showGainDisplay(arg_22_0)
			arg_21_0.costNum:set(0)
			arg_21_0.getNum:set(0)

			arg_21_0.costCardIDs = {}
		end, arg_21_0.selectDbId:read(), arg_21_0.costCardIDs)
	else
		if arg_21_0.selectedFragId:read() == 0 then
			gGameUI:showTip(string.format(gLanguageCsv.selectFragment))

			return
		end

		if arg_21_0.selectEpNum:read() == 0 then
			gGameUI:showTip(string.format(gLanguageCsv.pleaseSelectNumber, gLanguageCsv.starSkillExchange))

			return
		end

		gGameApp:requestServer("/game/card/star/skill/frag/exchange", function(arg_23_0)
			gGameUI:showGainDisplay(arg_23_0)
			arg_21_0.selectEpNum:set(0)
			arg_21_0.slider:setPercent(0)
			arg_21_0.selectedFragId:set(0)
		end, arg_21_0.selectDbId:read(), arg_21_0.selectedFragId:read(), arg_21_0.selectEpNum:read())
	end
end

function var_0_1.onCombClick(arg_24_0)
	if itertools.size(arg_24_0.cards:read()) >= arg_24_0.cardCapacity:read() then
		gGameUI:showTip(gLanguageCsv.cardBagHaveBeenFull)

		return
	end

	local var_24_0 = csv.cards[arg_24_0.cardId:read()]
	local var_24_1 = csv.cards[var_24_0.cardMarkID]
	local var_24_2 = csv.fragments[var_24_1.fragID]

	if arg_24_0.chipNum:read() < var_24_2.combCount then
		gGameUI:showTip(gLanguageCsv.fragCombfragNotEnough)

		return
	end

	local var_24_3 = {
		string.format("#C0x5b545b#" .. gLanguageCsv.wantConsumeFragsCombCard, var_24_2.combCount, "#C0x01A001#" .. var_24_2.name .. "#C0x5b545b#", "#C0x01A001#" .. var_24_1.name)
	}

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		content = var_24_3,
		cb = function()
			gGameApp:requestServer("/game/role/frag/comb", function(arg_26_0)
				gGameUI:stackUI("common.gain_sprite", nil, {
					full = true
				}, arg_26_0.view, nil, false, arg_24_0:createHandler("resetSelectNum"))
			end, var_24_1.fragID)
		end
	})
end

function var_0_1.onUniversalFragClick(arg_27_0)
	gGameUI:stackUI("city.card.star_changefrags", nil, nil, arg_27_0.selectDbId:read())
end

function var_0_1.onGainWayClick(arg_28_0)
	local var_28_0 = csv.cards[arg_28_0.cardId:read()].fragID
	local var_28_1 = csv.fragments[var_28_0].combCount

	gGameUI:stackUI("common.gain_way", nil, nil, var_28_0, nil, var_28_1)
end

local function var_0_3(arg_29_0, arg_29_1, arg_29_2)
	bind.extend(arg_29_0, arg_29_1, {
		class = "icon_key",
		props = {
			data = {
				key = arg_29_2.key,
				num = arg_29_2.num
			},
			onNode = function(arg_30_0)
				arg_30_0:setTouchEnabled(false):scale(0.9)
			end
		}
	})
end

function var_0_1.setFragsPanel(arg_31_0)
	local var_31_0 = csv.cards[arg_31_0.cardId:read()].fragID
	local var_31_1 = csv.fragments[var_31_0].combCount
	local var_31_2 = dataEasy.getNumByKey(var_31_0)

	bind.extend(arg_31_0, arg_31_0.selectPanel:get("iconPanel"), {
		class = "icon_key",
		props = {
			data = {
				key = var_31_0,
				num = var_31_2
			},
			onNode = function(arg_32_0)
				arg_32_0:setTouchEnabled(false):scale(0.9)
			end
		}
	})
	arg_31_0.chipNum:set(var_31_2)
	arg_31_0.chipNeed:set("/" .. var_31_1)

	local var_31_3 = cc.clampf(var_31_2 / var_31_1 * 100, 0, 100)

	arg_31_0.chipBarPercent:set(var_31_3)
end

function var_0_1.onSureClick(arg_33_0)
	arg_33_0.costCardIDs = {}

	local var_33_0 = 0

	for iter_33_0, iter_33_1 in arg_33_0.cardInfos:pairs() do
		local var_33_1 = iter_33_1:proxy()

		if var_33_1.selectState then
			table.insert(arg_33_0.costCardIDs, var_33_1.dbid)

			var_33_0 = var_33_0 + var_0_2(var_33_1)
		end
	end

	arg_33_0.costNum:set(#arg_33_0.costCardIDs)
	arg_33_0.getNum:set(var_33_0)
	arg_33_0.selectPanelState:set(false)
end

function var_0_1.onSelectPanelClick(arg_34_0)
	arg_34_0.selectPanelState:set(false)
end

function var_0_1.setCardDatas(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = csv.cards[arg_35_0.cardId:read()]

	arg_35_0.selectNum = 0

	arg_35_0.selectIdx:set(0)

	local var_35_1 = csv.cards[arg_35_0.cardId:read()].cardMarkID
	local var_35_2 = dataEasy.inUsingCardsHash()

	if arg_35_2 then
		arg_35_2 = itertools.map(arg_35_2, function(arg_36_0, arg_36_1)
			return arg_36_1, arg_36_0
		end)
	else
		arg_35_2 = {}
	end

	local var_35_3 = {}

	for iter_35_0, iter_35_1 in pairs(arg_35_1) do
		local var_35_4 = gGameModel.cards:find(iter_35_1)

		if var_35_4 then
			local var_35_5 = var_35_4:read("card_id", "name", "fighting_point", "locked", "level", "star", "advance")
			local var_35_6 = csv.cards[var_35_5.card_id]
			local var_35_7 = csv.unit[var_35_6.unitID]
			local var_35_8 = 0

			if var_35_5.locked then
				var_35_8 = 1
			elseif var_35_2[iter_35_1] then
				var_35_8 = 3
			elseif var_35_5.star > arg_35_0.star:read() then
				var_35_8 = 4
			end

			if var_35_6.cardMarkID == var_35_1 and arg_35_0.selectDbId:read() ~= iter_35_1 or arg_35_2[var_35_5.card_id] then
				local var_35_9 = {
					selectState = false,
					id = var_35_5.card_id,
					rarity = var_35_7.rarity,
					attr1 = var_35_7.natureType,
					attr2 = var_35_7.natureType2,
					level = var_35_5.level,
					star = var_35_5.star,
					name = var_35_5.name,
					locked = var_35_5.locked,
					advance = var_35_5.advance,
					fight = var_35_5.fighting_point,
					dbid = iter_35_1,
					status = var_35_8,
					battleType = var_35_2[iter_35_1],
					universal = arg_35_2[var_35_5.card_id]
				}

				table.insert(var_35_3, var_35_9)
			end
		end
	end

	arg_35_0.selectPanel:get("empty"):visible(#var_35_3 == 0)
	arg_35_0.bgIcon:visible(#var_35_3 ~= 0)
	table.sort(var_35_3, function(arg_37_0, arg_37_1)
		if arg_37_0.universal and not arg_37_1.universal then
			return true
		elseif not arg_37_0.universal and arg_37_1.universal then
			return false
		end

		return arg_37_0.fight > arg_37_1.fight
	end)
	arg_35_0.cardInfos:update(var_35_3)
end

function var_0_1.onCardItemClick(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = gGameModel.cards:find(arg_38_3.dbid):read("getstar")

	if arg_38_3.selectState == false and (var_38_0 < arg_38_3.star or arg_38_3.level > 1 or arg_38_3.advance > 1 or arg_38_0:getDevelopState(arg_38_3.dbid)) then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = gLanguageCsv.starSkillChangeTips,
			cb = function()
				arg_38_0.selectIdx:set(arg_38_2.k, true)
			end
		})
	else
		arg_38_0.selectIdx:set(arg_38_2.k, true)
	end
end

function var_0_1.getDevelopState(arg_40_0, arg_40_1)
	local var_40_0 = gGameModel.cards:find(arg_40_1)
	local var_40_1 = var_40_0:read("effort_values")
	local var_40_2 = var_40_0:read("equips")
	local var_40_3 = var_40_0:read("skills")
	local var_40_4 = var_40_0:read("card_id")

	for iter_40_0, iter_40_1 in pairs(var_40_3) do
		if iter_40_1 > 1 then
			return true
		end
	end

	local var_40_5 = csv.cards[var_40_4]

	if var_40_4 > csv.fragments[var_40_5.fragID].combID then
		return true
	end

	for iter_40_2, iter_40_3 in pairs(var_40_1) do
		if iter_40_3 > 0 then
			return true
		end
	end

	for iter_40_4, iter_40_5 in pairs(var_40_2) do
		if iter_40_5.level > 1 or iter_40_5.star > 0 or iter_40_5.awake > 0 then
			return true
		end
	end

	return false
end

function var_0_1.onFragClick(arg_41_0)
	local var_41_0 = {
		selectedFragId = arg_41_0.selectedFragId,
		cardId = arg_41_0.cardId:read()
	}

	gGameUI:stackUI("city.card.star_selectfrag", nil, nil, var_41_0)
end

return var_0_1
