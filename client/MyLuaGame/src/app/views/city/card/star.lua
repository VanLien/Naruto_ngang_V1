local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	bind.extend(arg_1_0, arg_1_1, {
		class = "card_icon",
		props = {
			unitId = arg_1_2.unitId,
			advance = arg_1_2.advance,
			rarity = arg_1_2.rarity,
			star = arg_1_2.star,
			levelProps = {
				data = arg_1_2.level
			},
			params = {
				starScale = 0.37,
				starInterval = 14.560000000000002
			},
			onNode = function(arg_2_0)
				arg_2_0:get("star"):y(-40)
			end
		}
	})
end

local function var_0_1(arg_3_0, arg_3_1, arg_3_2)
	bind.extend(arg_3_0, arg_3_1, {
		class = "icon_key",
		props = {
			data = {
				key = arg_3_2.key,
				num = arg_3_2.num
			},
			onNode = function(arg_4_0)
				arg_4_0:setTouchEnabled(false):scale(0.9)
			end
		}
	})
end

local function var_0_2(arg_5_0, arg_5_1)
	arg_5_0:removeAllChildren()

	local var_5_0 = 15
	local var_5_1 = arg_5_1 > 6 and 6 or arg_5_1

	for iter_5_0 = 1, var_5_1 do
		local var_5_2 = arg_5_1 - 6
		local var_5_3 = "common/icon/icon_star_d.png"

		if iter_5_0 <= arg_5_1 then
			var_5_3 = dataEasy.getStarRes(arg_5_1, iter_5_0)
		end

		ccui.ImageView:create(var_5_3):xy(99 - var_5_0 * (var_5_1 + 1 - 2 * iter_5_0), -20):addTo(arg_5_0, 4, "star"):scale(0.35)
	end
end

local function var_0_3()
	local var_6_0 = {}
	local var_6_1 = gGameModel.role:read("battle_cards")

	for iter_6_0, iter_6_1 in pairs(var_6_1) do
		table.insert(var_6_0, iter_6_1)
	end

	local var_6_2 = gGameModel.role:read("card_deployment").arena

	for iter_6_2, iter_6_3 in pairs(var_6_2.defence_cards or {}) do
		table.insert(var_6_0, iter_6_3)
	end

	return var_6_0
end

local function var_0_4(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = 0

	arg_7_2 = arg_7_2 or 1

	for iter_7_0 = 1, arg_7_2 do
		if csv.base_attribute.skill_level[arg_7_0 + iter_7_0 - 1] then
			var_7_0 = var_7_0 + csv.base_attribute.skill_level[arg_7_0 + iter_7_0 - 1]["itemNum" .. arg_7_1]
		end
	end

	return var_7_0
end

local var_0_5 = require("app.views.city.card.rebirth.tools")
local var_0_6 = class("CardStarView", cc.load("mvc").ViewBase)

var_0_6.RESOURCE_FILENAME = "card_star.json"
var_0_6.RESOURCE_BINDING = {
	["panel.costInfo.textCostNote"] = "costTxt",
	["selectPanel.textNum"] = "textNum",
	["extremePanel.item"] = "extremeItem",
	["panel.costInfo.imgIcon"] = "costIcon",
	cardItem = "cardItem",
	item = "item",
	["selectPanel.empty.text"] = "txtEmpty",
	effectItem = "effectItem",
	panel = "panel",
	["panel.costInfo"] = "costInfo",
	["panel.costInfo.textCostNum"] = "needGoldTxt",
	["selectPanel.subList"] = "subList",
	["extremePanel.subList"] = "extremeSubList",
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
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["selectPanel.btnFrags.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
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
				outline = {
					size = 1,
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
				outline = {
					size = 1,
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
				onCell = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					local var_8_0 = arg_8_0:getIdx(arg_8_2)

					arg_8_1:name("item" .. var_8_0.k)
					bind.extend(arg_8_0, arg_8_1:get("iconPanel"), {
						class = "card_icon",
						props = {
							unitId = arg_8_3.unitId,
							advance = arg_8_3.advance,
							rarity = arg_8_3.rarity,
							star = arg_8_3.star,
							levelProps = {
								data = arg_8_3.level
							},
							params = {
								starScale = 0.37,
								starInterval = 14
							}
						}
					})
					uiEasy.setIconName("card", arg_8_3.id, {
						space = true,
						node = arg_8_1:get("textName"),
						name = arg_8_3.name,
						advance = arg_8_3.advance
					})
					arg_8_1:get("textFight"):text(arg_8_3.fight)
					arg_8_1:get("iconLock"):visible(arg_8_3.locked)
					arg_8_1:get("textPanel"):visible(arg_8_3.battleType ~= nil)

					if arg_8_3.battleType and ui.CARD_USING_TXTS[arg_8_3.battleType] then
						local var_8_1 = arg_8_1:get("textPanel"):get("text")

						var_8_1:text(gLanguageCsv[ui.CARD_USING_TXTS[arg_8_3.battleType]])
						arg_8_1:get("textPanel"):get("bg"):size(var_8_1:size().width + 50, 60)
					end

					adapt.oneLinePos(arg_8_1:get("textFightNote"), arg_8_1:get("textFight"))
					arg_8_1:get("mask"):visible(arg_8_3.status ~= 0)
					arg_8_1:get("iconSelect"):visible(arg_8_3.selectState == true)
					arg_8_1:setTouchEnabled(arg_8_3.status == 0)

					if arg_8_3.canSelect == true and arg_8_3.selectState == false then
						arg_8_1:setTouchEnabled(false)
						arg_8_1:get("mask"):show()
					end

					bind.touch(arg_8_0, arg_8_1, {
						methods = {
							ended = functools.partial(arg_8_0.itemClick, arg_8_0:getIdx(arg_8_2), arg_8_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCardItemClick")
			}
		}
	},
	extremePanel = {
		varname = "extremePanel",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("extremePanelState")
			},
			{
				event = "click",
				method = bindHelper.self("closeExtreme")
			}
		}
	},
	["extremePanel.imgBg.textExtremePoint"] = {
		varname = "textExtremePoint",
		binds = {
			event = "text",
			idler = bindHelper.self("extremePoint")
		}
	},
	["extremePanel.imgBg"] = {
		varname = "btnAddExtrePoint",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAddExtrePointClick")
			}
		}
	},
	["extremePanel.btnReset"] = {
		varname = "btnResetEp",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onResetEp")
			}
		}
	},
	["extremePanel.textResetEpCost"] = {
		varname = "textResetEpCost",
		binds = {
			event = "text",
			idler = bindHelper.self("resetEpCost")
		}
	},
	["extremePanel.imgBg.imgIcon"] = {
		binds = {
			event = "texture",
			idler = bindHelper.self("starSkillIcon")
		}
	},
	["extremePanel.list"] = {
		varname = "extremeList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				margin = 0,
				columnSize = 2,
				asyncPreload = 6,
				data = bindHelper.self("starSkills"),
				item = bindHelper.self("extremeSubList"),
				cell = bindHelper.self("extremeItem"),
				cardId = bindHelper.self("cardId"),
				onCell = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
					arg_9_1:get("textLv"):text(arg_9_3.skillLevel)

					local var_9_0 = csv.skill[arg_9_3.skillId]
					local var_9_1 = string.format("#C0x5b545b#%s", eval.doMixedFormula(var_9_0.describe, {
						skillLevel = arg_9_3.skillLevel or 1,
						math = math
					}, nil) or "no desc")
					local var_9_2 = matchLanguage({
						"kr",
						"en"
					}) and 30 or 42
					local var_9_3 = rich.createWithWidth(var_9_1, var_9_2, cc.size(400, 130), 400, 20):anchorPoint(0, 1):xy(60, 220):addTo(arg_9_1):z(2)

					arg_9_1:get("imgIcon"):texture(arg_9_3.icon)

					local var_9_4 = csv.skill[arg_9_3.skillId].costID
					local var_9_5 = var_0_4(arg_9_3.skillLevel, var_9_4)

					arg_9_1:get("textNum3"):text(var_9_5)

					if csv.cards[arg_9_3.cardId].starSkillMaxLevel < arg_9_3.skillLevel + 1 then
						uiEasy.setBtnShader(arg_9_1:get("btnAdd"), nil, 3)
					end

					bind.touch(arg_9_0, arg_9_1:get("btnAdd"), {
						methods = {
							ended = functools.partial(arg_9_0.clickAdd, arg_9_2, arg_9_3, var_9_5)
						}
					})
				end
			},
			handlers = {
				clickAdd = bindHelper.self("onEpUpClick")
			}
		}
	},
	["panel.btnChange"] = {
		varname = "panelBtnChange",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onChangeClick")
			}
		}
	},
	["panel.effectList"] = {
		varname = "effectList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("effectStartConfig"),
				item = bindHelper.self("effectItem"),
				itemAction = {
					isAction = true
				},
				onItem = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					local var_10_0 = arg_10_1:multiget("textNote", "iconStar")
					local var_10_1 = rich.createWithWidth(string.format("%s%s", arg_10_3.color, "x" .. arg_10_3.value .. ": "), 44, nil, 200, 5):anchorPoint(0, 0.5):addTo(var_10_0.textNote, 6)
					local var_10_2 = rich.createWithWidth(arg_10_3.str, 44, nil, 800, 5):anchorPoint(0, 0.5):addTo(var_10_0.textNote, 6)
					local var_10_3 = var_10_1:size().height - 46
					local var_10_4 = var_10_2:size().height - 46

					var_10_1:y(var_10_4 - var_10_3 - 0)
					var_10_2:y(var_10_4 / 2)
					var_10_2:x(var_10_2:x() + 100)
					arg_10_1:size(879, var_10_4 + 74)

					local var_10_5 = ""

					if arg_10_3.value > 18 then
						var_10_5 = "_c"
					elseif arg_10_3.value > 12 then
						var_10_5 = "_h"
					elseif arg_10_3.value > 6 then
						var_10_5 = "_z"
					end

					local var_10_6 = string.format("common/icon/icon_star%s.png", var_10_5)

					var_10_0.iconStar:texture(var_10_6):y(arg_10_1:size().height / 2 + var_10_4 / 2):scale(0.75)
					var_10_0.textNote:text("")
				end
			}
		}
	},
	["panel.btnOk"] = {
		varname = "btnOk",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStarClick")
			}
		}
	},
	["panel.btnOk.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.btnExtreme"] = {
		varname = "btnExtreme",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onExtremeClick")
			}
		}
	},
	["panel.btnExtreme.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.itemList"] = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 4,
				data = bindHelper.self("costItems"),
				item = bindHelper.self("item"),
				onItem = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
					arg_11_1:name("item" .. arg_11_0:getIdx(arg_11_2))

					local var_11_0 = arg_11_3.num < arg_11_3.targetNum and 1 or 0

					arg_11_1:get("cardIcon"):visible(arg_11_3.typ == "card")
					arg_11_1:get("itemIcon"):visible(arg_11_3.typ ~= "card")

					if arg_11_3.typ == "card" then
						bind.extend(arg_11_0, arg_11_1:get("cardIcon"), {
							class = "card_icon",
							props = {
								cardId = arg_11_3.id,
								rarity = arg_11_3.rarity,
								grayState = var_11_0,
								onNode = function(arg_12_0)
									uiEasy.setCardNum(arg_12_0, arg_11_3.num, arg_11_3.targetNum, 1)
									arg_12_0:setTouchEnabled(false)
								end
							}
						})
					else
						local var_11_1 = {
							class = "icon_key",
							props = {
								data = {
									key = arg_11_3.id,
									num = arg_11_3.num,
									targetNum = arg_11_3.targetNum
								},
								grayState = var_11_0,
								onNode = function(arg_13_0)
									arg_13_0:setTouchEnabled(false)
								end
							}
						}

						bind.extend(arg_11_0, arg_11_1, var_11_1)
					end

					arg_11_1:get("mask"):visible(arg_11_3.num < arg_11_3.targetNum)
					bind.touch(arg_11_0, arg_11_1, {
						methods = {
							ended = functools.partial(arg_11_0.itemClick, arg_11_2, arg_11_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCostItemClick")
			}
		}
	}
}

function var_0_6.onCreate(arg_14_0, arg_14_1)
	arg_14_0.selectDbId = arg_14_1()

	arg_14_0:initModel()
	arg_14_0.txtEmpty:anchorPoint(0.5, 0.5)
	arg_14_0.txtEmpty:x(arg_14_0.txtEmpty:x() + 250)

	arg_14_0.costCardIDs = {}
	arg_14_0.chipBarPercent = idler.new(0)
	arg_14_0.chipNum = idler.new(0)
	arg_14_0.chipNeed = idler.new(0)
	arg_14_0.needCash = idler.new(0)
	arg_14_0.effectStartConfig = idlers.new()
	arg_14_0.selectPanelState = idler.new(false)
	arg_14_0.extremePanelState = idler.new(false)
	arg_14_0.cardInfos = idlers.new()
	arg_14_0.costItems = idlers.new()
	arg_14_0.selectIdx = idler.new()
	arg_14_0.eps = idlers.new()
	arg_14_0.extremePoint = idler.new(0)
	arg_14_0.starSkillIcon = idler.new()
	arg_14_0.resetEpCost = idler.new(gCommonConfigCsv.cardStarSkillResetCostRMB)
	arg_14_0.starSkills = idlers.new()
	arg_14_0.canResetEp = idler.new(false)

	local var_14_0 = 0

	idlereasy.any({
		arg_14_0.cardId,
		arg_14_0.star,
		arg_14_0.frags,
		arg_14_0.cards,
		arg_14_0.items,
		arg_14_0.extremePoints
	}, function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
		var_14_0 = var_14_0 + 1

		performWithDelay(arg_14_0, function()
			if var_14_0 > 0 then
				arg_14_0:refreshView()

				var_14_0 = 0
			end
		end, 0)
	end)
	idlereasy.when(arg_14_0.canResetEp, function(arg_17_0, arg_17_1)
		uiEasy.setBtnShader(arg_14_0.btnResetEp, nil, arg_17_1 and 1 or 3)

		if arg_17_1 then
			text.addEffect(arg_14_0.btnResetEp:get("textNote"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_14_0.btnResetEp:get("textNote"))
		end
	end)
	idlereasy.when(arg_14_0.gold, function(arg_18_0, arg_18_1)
		local var_18_0 = csv.cards[arg_14_0.cardId:read()]
		local var_18_1 = arg_18_1 >= gStarCsv[var_18_0.starTypeID][arg_14_0.star:read()].gold and ui.NEWCOLORS.WHITE or ui.NEWCOLORS.REDLIGHT

		text.addEffect(arg_14_0.needGoldTxt, {
			color = var_18_1
		})
	end)

	arg_14_0.selectMax = idler.new(1)
	arg_14_0.selectNum = 0

	idlereasy.any({
		arg_14_0.selectIdx,
		arg_14_0.selectMax
	}, function(arg_19_0, arg_19_1, arg_19_2)
		arg_14_0.textNum:text("0/" .. arg_19_2)

		if arg_14_0.cardInfos:atproxy(arg_19_1) then
			local var_19_0 = arg_14_0.cardInfos:atproxy(arg_19_1)

			if arg_19_2 <= arg_14_0.selectNum and var_19_0.selectState == false then
				return
			end

			var_19_0.selectState = not var_19_0.selectState

			local var_19_1 = 0
			local var_19_2 = {}

			for iter_19_0 = 1, arg_14_0.cardInfos:size() do
				local var_19_3 = arg_14_0.cardInfos:atproxy(iter_19_0)

				if var_19_3.selectState == true then
					var_19_1 = var_19_1 + 1

					table.insert(var_19_2, var_19_3.dbid)
				end
			end

			arg_14_0.selectNum = var_19_1

			arg_14_0.textNum:text(var_19_1 .. "/" .. arg_19_2)

			for iter_19_1 = 1, arg_14_0.cardInfos:size() do
				arg_14_0.cardInfos:atproxy(iter_19_1).canSelect = arg_19_2 <= var_19_1
			end
		end
	end)
end

function var_0_6.refreshView(arg_20_0)
	local var_20_0 = arg_20_0.cardId:read()
	local var_20_1 = arg_20_0.skinId:read()
	local var_20_2 = arg_20_0.star:read()
	local var_20_3 = arg_20_0.frags:read()
	local var_20_4 = arg_20_0.extremePoints:read()
	local var_20_5 = csv.cards[var_20_0]

	arg_20_0.panelBtnChange:visible(var_20_5.cardType == 1)

	local var_20_6 = table.length(gStarCsv[var_20_5.starTypeID])

	arg_20_0:setEffectPanel(var_20_2, gStarEffectCsv[var_20_5.starEffectIndex])

	local var_20_7 = gStarCsv[var_20_5.starTypeID][var_20_2]

	arg_20_0:setCostDatas(var_20_7, var_20_0, var_20_5)
	arg_20_0.panel:get("costInfo"):visible(var_20_2 < var_20_6)
	arg_20_0.panel:get("btnOk"):visible(var_20_2 < var_20_6)

	local var_20_8 = csv.cards[var_20_5.cardMarkID]
	local var_20_9 = var_20_8.starSkillSeqID
	local var_20_10 = csv.card_star_skill[var_20_9].starSkillList

	if dataEasy.isUnlock(gUnlockCsv.extremityProperty) and var_20_6 <= var_20_2 and itertools.size(var_20_10) > 0 then
		arg_20_0.panel:get("btnExtreme"):show()
		arg_20_0.panel:get("iconMax"):hide()
	else
		arg_20_0.panel:get("iconMax"):visible(var_20_6 <= var_20_2)
		arg_20_0.panel:get("btnExtreme"):hide()
	end

	arg_20_0:setFragsPanel(var_20_5, var_20_3)

	local var_20_11 = dataEasy.getUnitId(var_20_0, var_20_1)
	local var_20_12 = csv.unit[var_20_5.unitID]
	local var_20_13 = {
		id = var_20_0,
		unitId = var_20_11,
		advance = arg_20_0.advance:read(),
		rarity = var_20_12.rarity,
		star = var_20_2,
		level = arg_20_0.level:read()
	}

	var_0_0(arg_20_0, arg_20_0.panel:get("iconPanel1"), var_20_13)

	var_20_13.star = math.min(var_20_2 + 1, var_20_6)

	var_0_0(arg_20_0, arg_20_0.panel:get("iconPanel2"), var_20_13)

	if var_20_7 then
		arg_20_0.needCash:set(var_20_7.gold)
		arg_20_0.needGoldTxt:text(var_20_7.gold)
		arg_20_0.costInfo:visible(var_20_7.gold and var_20_7.gold > 0)

		local var_20_14 = dataEasy.getNumByKey("gold") >= var_20_7.gold and ui.NEWCOLORS.WHITE or ui.NEWCOLORS.REDLIGHT

		text.addEffect(arg_20_0.needGoldTxt, {
			color = var_20_14
		})

		local var_20_15, var_20_16 = arg_20_0.btnOk:xy()

		arg_20_0.costInfo:xy(var_20_15, var_20_16 + arg_20_0.btnOk:height() / 2 + 52)
		adapt.oneLineCenterPos(cc.p(arg_20_0.costInfo:width() / 2, arg_20_0.costInfo:height() / 2), {
			arg_20_0.costTxt,
			arg_20_0.needGoldTxt,
			arg_20_0.costIcon
		}, cc.p(10, 0))
	end

	arg_20_0:setCardDatas(var_20_7)

	if dataEasy.isUnlock(gUnlockCsv.extremityProperty) then
		arg_20_0.extremePoint:set(var_20_4[var_20_5.cardMarkID] or 0)

		local var_20_17 = var_20_8.starSkillSeqID

		arg_20_0.starSkillIcon:set(csv.unit[var_20_8.unitID].iconSimple)

		local var_20_18 = {}
		local var_20_19 = csv.card_star_skill[var_20_17].starSkillList
		local var_20_20 = false

		for iter_20_0, iter_20_1 in ipairs(var_20_19) do
			local var_20_21 = arg_20_0.skills:read()[iter_20_1] or 0

			if var_20_21 > 0 then
				var_20_20 = true
			end

			var_20_18[iter_20_1] = {
				fastUpgradeNum = 1,
				cardId = arg_20_0.cardId:read(),
				skillId = iter_20_1,
				skillLevel = var_20_21,
				clientGold = arg_20_0.gold:read(),
				icon = arg_20_0.starSkillIcon:read()
			}
		end

		arg_20_0.canResetEp:set(var_20_20)
		arg_20_0.starSkills:update(var_20_18)
	end
end

function var_0_6.initModel(arg_21_0)
	arg_21_0.gold = gGameModel.role:getIdler("gold")
	arg_21_0.items = gGameModel.role:getIdler("items")
	arg_21_0.frags = gGameModel.role:getIdler("frags")
	arg_21_0.cards = gGameModel.role:getIdler("cards")
	arg_21_0.cardCapacity = gGameModel.role:getIdler("card_capacity")
	arg_21_0.extremePoints = gGameModel.role:getIdler("star_skill_points")

	idlereasy.when(arg_21_0.selectDbId, function(arg_22_0, arg_22_1)
		arg_21_0.costCardIDs = {}

		local var_22_0 = gGameModel.cards:find(arg_22_1)

		arg_21_0.level = idlereasy.assign(var_22_0:getIdler("level"), arg_21_0.level)
		arg_21_0.cardId = idlereasy.assign(var_22_0:getIdler("card_id"), arg_21_0.cardId)
		arg_21_0.skinId = idlereasy.assign(var_22_0:getIdler("skin_id"), arg_21_0.skinId)
		arg_21_0.fight = idlereasy.assign(var_22_0:getIdler("fighting_point"), arg_21_0.fight)
		arg_21_0.advance = idlereasy.assign(var_22_0:getIdler("advance"), arg_21_0.advance)
		arg_21_0.attrs = idlereasy.assign(var_22_0:getIdler("attrs"), arg_21_0.attrs)
		arg_21_0.skills = idlereasy.assign(var_22_0:getIdler("skills"), arg_21_0.skills)
		arg_21_0.star = idlereasy.assign(var_22_0:getIdler("star"), arg_21_0.star)
	end)
end

function var_0_6.setFragsPanel(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = csv.fragments[arg_23_1.fragID].combCount
	local var_23_1 = dataEasy.getNumByKey(arg_23_1.fragID)

	var_0_1(arg_23_0, arg_23_0.selectPanel:get("iconPanel"), {
		key = arg_23_1.fragID,
		num = var_23_1
	})
	arg_23_0.chipNum:set(var_23_1)
	arg_23_0.chipNeed:set("/" .. var_23_0)

	local var_23_2 = cc.clampf(var_23_1 / var_23_0 * 100, 0, 100)

	arg_23_0.chipBarPercent:set(var_23_2)
end

function var_0_6.setCostDatas(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = {}
	local var_24_1 = {}

	if arg_24_1 then
		if arg_24_1.costCardNum > 0 then
			local var_24_2 = csv.unit[arg_24_3.unitID].rarity

			if arg_24_3.megaIndex > 0 then
				local var_24_3 = csv.cards[arg_24_0.cardId:read()].cardMarkID
				local var_24_4 = arg_24_0.cards:read()

				for iter_24_0, iter_24_1 in pairs(var_24_4) do
					local var_24_5 = gGameModel.cards:find(iter_24_1)
					local var_24_6 = gGameModel.cards:find(iter_24_1):read("card_id")
					local var_24_7 = csv.cards[var_24_6]

					if var_24_7.cardMarkID == var_24_3 and var_24_2 > csv.unit[var_24_7.unitID].rarity then
						var_24_2 = csv.unit[var_24_7.unitID].rarity
					end
				end
			end

			table.insert(var_24_0, {
				typ = "card",
				num = 0,
				id = arg_24_3.cardMarkID,
				rarity = var_24_2,
				targetNum = arg_24_1.costCardNum
			})
		end

		for iter_24_2, iter_24_3 in csvPairs(arg_24_1.costItems) do
			table.insert(var_24_0, {
				id = iter_24_2,
				num = dataEasy.getNumByKey(iter_24_2),
				targetNum = iter_24_3
			})
		end
	end

	arg_24_0.costItems:update(var_24_0)
end

function var_0_6.setCardDatas(arg_25_0, arg_25_1)
	arg_25_0.selectNum = 0

	arg_25_0.selectIdx:set(0)

	local var_25_0 = arg_25_0.cards:read()
	local var_25_1 = csv.cards[arg_25_0.cardId:read()].cardMarkID
	local var_25_2 = dataEasy.inUsingCardsHash()
	local var_25_3 = {}

	if arg_25_1 and arg_25_1.universalCards then
		var_25_3 = itertools.map(arg_25_1.universalCards, function(arg_26_0, arg_26_1)
			return arg_26_1, arg_26_0
		end)
	end

	local var_25_4 = {}

	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		local var_25_5 = gGameModel.cards:find(iter_25_1)

		if var_25_5 then
			local var_25_6 = var_25_5:read("card_id", "unit_id", "skin_id", "name", "fighting_point", "locked", "level", "star", "advance")
			local var_25_7 = csv.cards[var_25_6.card_id]
			local var_25_8 = dataEasy.getUnitId(var_25_6.card_id, var_25_6.skin_id)
			local var_25_9 = csv.unit[var_25_6.unit_id]
			local var_25_10 = 0

			if var_25_6.locked then
				var_25_10 = 1
			elseif var_25_2[iter_25_1] then
				var_25_10 = 3
			elseif var_25_6.star > arg_25_0.star:read() then
				var_25_10 = 4
			end

			if var_25_7.cardMarkID == var_25_1 and arg_25_0.selectDbId:read() ~= iter_25_1 or var_25_3[var_25_6.card_id] then
				local var_25_11 = {
					selectState = false,
					id = var_25_6.card_id,
					unitId = var_25_8,
					rarity = var_25_9.rarity,
					attr1 = var_25_9.natureType,
					attr2 = var_25_9.natureType2,
					level = var_25_6.level,
					star = var_25_6.star,
					name = var_25_6.name,
					locked = var_25_6.locked,
					advance = var_25_6.advance,
					fight = var_25_6.fighting_point,
					dbid = iter_25_1,
					status = var_25_10,
					battleType = var_25_2[iter_25_1],
					universal = var_25_3[var_25_6.card_id]
				}

				table.insert(var_25_4, var_25_11)
			end
		end
	end

	arg_25_0.selectPanel:get("empty"):visible(#var_25_4 == 0)
	table.sort(var_25_4, function(arg_27_0, arg_27_1)
		if arg_27_0.universal and not arg_27_1.universal then
			return true
		elseif not arg_27_0.universal and arg_27_1.universal then
			return false
		end

		return arg_27_0.fight > arg_27_1.fight
	end)
	arg_25_0.cardInfos:update(var_25_4)
end

function var_0_6.setEffectPanel(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = itertools.keys(arg_28_2)
	local var_28_1 = "#C0xFFFFFF##F44#"
	local var_28_2 = "#C0x25EA11##F44#"

	table.sort(var_28_0)

	local var_28_3 = {}

	for iter_28_0, iter_28_1 in ipairs(var_28_0) do
		local var_28_4 = arg_28_2[iter_28_1]
		local var_28_5 = ""
		local var_28_6 = {}
		local var_28_7 = arg_28_1 < iter_28_1 and "#C0x989898#" or "#C0xFFFFFF#"
		local var_28_8 = iter_28_1 <= arg_28_1 and var_28_1 or "#C0x989898#"
		local var_28_9 = iter_28_1 <= arg_28_1 and var_28_2 or "#C0x989898#"

		for iter_28_2, iter_28_3 in csvPairs(var_28_4.attrNum) do
			local var_28_10 = game.ATTRDEF_TABLE[iter_28_2]
			local var_28_11 = gLanguageCsv["attr" .. string.caption(var_28_10)]
			local var_28_12 = "+" .. dataEasy.getAttrValueString(iter_28_2, iter_28_3)

			table.insert(var_28_6, var_28_8 .. var_28_11 .. var_28_9 .. var_28_12)
		end

		local var_28_13 = table.concat(var_28_6, " ") .. var_28_8 .. (var_28_4.effectDesc or "")

		var_28_3[iter_28_0] = {
			str = var_28_13,
			value = iter_28_1,
			star = arg_28_1,
			color = var_28_7
		}
	end

	arg_28_0.effectStartConfig:update(var_28_3)
end

function var_0_6.onGainWayClick(arg_29_0)
	local var_29_0 = csv.cards[arg_29_0.cardId:read()].fragID
	local var_29_1 = csv.fragments[var_29_0].combCount

	gGameUI:stackUI("common.gain_way", nil, nil, var_29_0, nil, var_29_1)
end

function var_0_6.onCombClick(arg_30_0)
	if itertools.size(arg_30_0.cards:read()) >= arg_30_0.cardCapacity:read() then
		gGameUI:showTip(gLanguageCsv.cardBagHaveBeenFull)

		return
	end

	local var_30_0 = csv.cards[arg_30_0.cardId:read()]
	local var_30_1 = csv.cards[var_30_0.cardMarkID]
	local var_30_2 = csv.fragments[var_30_1.fragID]

	if arg_30_0.chipNum:read() < var_30_2.combCount then
		gGameUI:showTip(gLanguageCsv.fragCombfragNotEnough)

		return
	end

	local var_30_3 = {
		string.format("#C0x5b545b#" .. gLanguageCsv.wantConsumeFragsCombCard, var_30_2.combCount, "#C0x01A001#" .. var_30_2.name .. "#C0x5b545b#", "#C0x01A001#" .. var_30_1.name)
	}

	gGameUI:showDialog({
		btnType = 2,
		clearFast = true,
		isRich = true,
		content = var_30_3,
		cb = function()
			gGameApp:requestServer("/game/role/frag/comb", function(arg_32_0)
				gGameUI:stackUI("common.gain_sprite", nil, {
					full = true
				}, arg_32_0.view, nil, false, arg_30_0:createHandler("resetSelectNum"))
			end, var_30_1.fragID)
		end
	})
end

function var_0_6.resetSelectNum(arg_33_0)
	arg_33_0.selectNum = 0
end

function var_0_6.onCardItemClick(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = gGameModel.cards:find(arg_34_3.dbid):read("getstar")

	if arg_34_3.selectState == false and (var_34_0 < arg_34_3.star or arg_34_3.level > 1 or arg_34_3.advance > 1 or arg_34_0:getDevelopState(arg_34_3.dbid)) then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = gLanguageCsv.tipsForSelectingMaterials,
			cb = function()
				arg_34_0.selectIdx:set(arg_34_2.k, true)
			end
		})
	else
		arg_34_0.selectIdx:set(arg_34_2.k, true)
	end
end

function var_0_6.getDevelopState(arg_36_0, arg_36_1)
	local var_36_0 = gGameModel.cards:find(arg_36_1)
	local var_36_1 = var_36_0:read("effort_values")
	local var_36_2 = var_36_0:read("equips")
	local var_36_3 = var_36_0:read("skills")
	local var_36_4 = var_36_0:read("card_id")

	for iter_36_0, iter_36_1 in pairs(var_36_3) do
		if iter_36_1 > 1 then
			return true
		end
	end

	local var_36_5 = csv.cards[var_36_4]

	if var_36_4 > csv.fragments[var_36_5.fragID].combID then
		return true
	end

	for iter_36_2, iter_36_3 in pairs(var_36_1) do
		if iter_36_3 > 0 then
			return true
		end
	end

	for iter_36_4, iter_36_5 in pairs(var_36_2) do
		if iter_36_5.level > 1 or iter_36_5.star > 0 or iter_36_5.awake > 0 then
			return true
		end
	end

	return false
end

function var_0_6.onSureClick(arg_37_0)
	arg_37_0.costCardIDs = {}

	local var_37_0 = {}

	for iter_37_0, iter_37_1 in arg_37_0.cardInfos:pairs() do
		local var_37_1 = iter_37_1:proxy()

		if var_37_1.selectState then
			table.insert(arg_37_0.costCardIDs, var_37_1.dbid)
		end
	end

	arg_37_0.costItems:atproxy(1).num = arg_37_0.selectNum

	arg_37_0.selectPanelState:set(false)
end

function var_0_6.onSelectPanelClick(arg_38_0)
	arg_38_0.selectPanelState:set(false)
end

function var_0_6.onCostItemClick(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	if arg_39_3.typ == "card" then
		arg_39_0.selectMax:set(arg_39_3.targetNum)
		arg_39_0.selectPanelState:set(not arg_39_0.selectPanelState:read())
	else
		gGameUI:stackUI("common.gain_way", nil, nil, arg_39_3.id, nil, arg_39_3.targetNum)
	end
end

function var_0_6.onStarSkillCostItemClick(arg_40_0)
	arg_40_0.selectMax:set(1)
	arg_40_0.selectPanelState:set(true)
end

function var_0_6.onChangeClick(arg_41_0)
	if arg_41_0.star:read() == 24 and not dataEasy.isUnlock(gUnlockCsv.extremityProperty) then
		gGameUI:showTip(gLanguageCsv.cardStarMaxErr)

		return
	end

	gGameUI:stackUI("city.card.star_changefrags", nil, nil, arg_41_0.selectDbId:read())
end

function var_0_6.onStarClick(arg_42_0)
	if arg_42_0.star:read() == 24 then
		gGameUI:showTip(gLanguageCsv.cardStarMaxErr)

		return
	end

	if dataEasy.getNumByKey("gold") < arg_42_0.needCash:read() then
		gGameUI:showTip(gLanguageCsv.starNoEnoughGold)

		return
	end

	for iter_42_0, iter_42_1 in arg_42_0.costItems:ipairs() do
		local var_42_0 = iter_42_1:proxy()

		if var_42_0.num < var_42_0.targetNum then
			gGameUI:showTip(gLanguageCsv.starMaterialsNotEnough)

			return
		end
	end

	local var_42_1 = arg_42_0.fight:read()
	local var_42_2 = clone(arg_42_0.attrs:read())

	local function var_42_3()
		gGameApp:requestServer("/game/card/star", function(arg_44_0)
			arg_42_0.selectNum = 0

			gGameUI:stackUI("city.card.common_success", nil, {
				blackLayer = true
			}, arg_42_0.selectDbId:read(), var_42_1, {
				starOld = true,
				attrs = var_42_2,
				skills = arg_42_0.skills:read()
			})
			audio.playEffectWithWeekBGM("star.mp3")
		end, arg_42_0.selectDbId, arg_42_0.costCardIDs)
	end

	local var_42_4 = false

	for iter_42_2, iter_42_3 in arg_42_0.cardInfos:pairs() do
		if iter_42_3:proxy().star > arg_42_0.star:read() then
			var_42_4 = true
		end
	end

	if var_42_4 then
		local var_42_5 = gLanguageCsv.moreStarTips

		gGameUI:showDialog({
			btnType = 2,
			clearFast = true,
			content = var_42_5,
			cb = var_42_3
		})
	else
		var_42_3()
	end
end

function var_0_6.onExtremeClick(arg_45_0)
	arg_45_0.extremePanelState:set(true)
end

function var_0_6.closeExtreme(arg_46_0)
	arg_46_0.extremePanelState:set(false)
end

function var_0_6.onAddExtrePointClick(arg_47_0)
	gGameUI:stackUI("city.card.star_changestarskill", nil, nil, arg_47_0:createHandler("selectDbId"))
end

function var_0_6.onResetEp(arg_48_0)
	if gGameModel.role:read("rmb") < arg_48_0.resetEpCost:read() then
		uiEasy.showDialog("rmb")
	else
		if arg_48_0.canResetEp:read() == false then
			gGameUI:showTip(gLanguageCsv.haveNotUpStarSkill)

			return false
		end

		local var_48_0 = arg_48_0.cardId:read()
		local var_48_1 = csv.unit[csv.cards[var_48_0].unitID].name
		local var_48_2 = dataEasy.getCfgByKey(csv.cards[var_48_0].fragID).quality
		local var_48_3 = ui.QUALITYCOLOR[var_48_2]

		gGameUI:showDialog({
			isRich = true,
			btnType = 2,
			title = "",
			content = string.format(gLanguageCsv.starSkillResetTips, arg_48_0.resetEpCost:read(), var_48_3 .. var_48_1),
			cb = function()
				gGameApp:requestServer("/game/card/star/skill/reset", function(arg_50_0)
					gGameUI:showGainDisplay(arg_50_0)
				end, arg_48_0.selectDbId:read())
			end
		})
	end
end

function var_0_6.onEpUpClick(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	if csv.cards[arg_51_3.cardId].starSkillMaxLevel < arg_51_3.skillLevel + 1 then
		gGameUI:showTip(gLanguageCsv.starSkillMaxTips)

		return
	end

	if arg_51_4 <= arg_51_0.extremePoint:read() then
		gGameApp:requestServer("/game/card/skill/level/up", function(arg_52_0)
			return
		end, arg_51_0.selectDbId, arg_51_3.skillId, arg_51_3.fastUpgradeNum)
	else
		arg_51_0:onAddExtrePointClick()
	end
end

return var_0_6
