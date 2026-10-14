local var_0_0 = class("CardEquipStarView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.equip.view")

var_0_0.RESOURCE_FILENAME = "card_equip_star.json"
var_0_0.RESOURCE_BINDING = {
	["panel.potentialPanel.talentEffect"] = "talentEffect",
	["panel.starPanel"] = "starPanel",
	["panel.potentialPanel.talentLeftEffect"] = "talentLeftEffect",
	["panel.starPanel.name"] = "starName",
	["panel.starPanel.leftStar"] = "leftStar",
	["panel.starPanel.arrow"] = "arrow",
	["panel.potentialPanel.arrow"] = "potentialArrow",
	["panel.pos"] = "pos",
	["panel.potentialPanel.talentName"] = "talentName",
	["panel.bottomPanel.itemPanel"] = "itemPanel",
	["panel.starPanel.none"] = "none",
	item = "item",
	["panel.potentialPanel.rightPotential"] = "rightPotential",
	["panel.max"] = "max",
	["panel.bottomPanel"] = "bottomPanel",
	["panel.potentialPanel.none"] = "potentialNone",
	["panel.potentialPanel.leftPotential"] = "leftPotential",
	potentialItem = "potentialItem",
	["panel.potentialPanel.arrow1"] = "effectArrow",
	["panel.starPanel.rightStar"] = "rightStar",
	["panel.potentialPanel.talentRightEffect"] = "talentRightEffect",
	["panel.potentialPanel"] = "potentialPanel",
	["panel.potentialPanel.name"] = "potentialName",
	["panel.starPanel.list"] = {
		varname = "starList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("name", "left", "right", "arrow")
					local var_1_1 = game.ATTRDEF_TABLE[arg_1_3.attr]
					local var_1_2 = "attr" .. string.caption(var_1_1)

					if arg_1_3.nextVal ~= 0 then
						var_1_0.right:text(math.round(arg_1_3.nextVal))
					end

					var_1_0.right:visible(arg_1_3.nextVal ~= 0)
					var_1_0.arrow:visible(arg_1_3.nextVal ~= 0)
					var_1_0.left:text(math.round(arg_1_3.currVal))
					var_1_0.name:text(gLanguageCsv[var_1_2] .. ": ")
					adapt.oneLinePos(var_1_0.name, {
						var_1_0.left,
						var_1_0.arrow,
						var_1_0.right
					}, {
						cc.p(15, 0),
						cc.p(25, 0),
						cc.p(25, 0)
					}, "left")
				end
			}
		}
	},
	["panel.potentialPanel.list"] = {
		varname = "potentialList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrPotentialDatas"),
				item = bindHelper.self("potentialItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1:multiget("name", "left", "right", "arrow")
					local var_2_1 = game.ATTRDEF_TABLE[arg_2_3.attr]
					local var_2_2 = "attr" .. string.caption(var_2_1)

					if arg_2_3.nextVal ~= 0 then
						var_2_0.right:text(math.round(arg_2_3.nextVal))
					end

					var_2_0.right:visible(arg_2_3.nextVal ~= 0)
					var_2_0.arrow:visible(arg_2_3.nextVal ~= 0)
					var_2_0.left:text(math.round(arg_2_3.currVal))
					var_2_0.name:text(gLanguageCsv[var_2_2] .. ": ")
					adapt.oneLinePos(var_2_0.name, {
						var_2_0.left,
						var_2_0.arrow,
						var_2_0.right
					}, {
						cc.p(15, 0),
						cc.p(25, 0),
						cc.p(25, 0)
					}, "left")
				end
			}
		}
	},
	["panel.potentialPanel.leftPotential.starNum"] = {
		varname = "leftStarNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c3b(179, 68, 48)
				}
			}
		}
	},
	["panel.potentialPanel.rightPotential.starNum"] = {
		varname = "rightStarNum",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = cc.c3b(179, 68, 48)
				}
			}
		}
	},
	["panel.btnStarPotential"] = {
		varname = "btnStarPotential",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("starPotential")
			}
		}
	},
	["panel.btnStarPotential.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["panel.btnDown"] = {
		varname = "btnDown",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDown")
			}
		}
	},
	["panel.bottomPanel.btnUpgrade"] = {
		varname = "btnUpgrade",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUp")
			}
		}
	},
	["panel.bottomPanel.btnUpgrade.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["panel.bottomPanel.btnUpgradeAfter"] = {
		varname = "btnUpgradePotential",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUpgradePotential")
			}
		}
	},
	["panel.bottomPanel.btnUpgradeAfter.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["panel.bottomPanel.btnUpgradeAfterFast"] = {
		varname = "btnUpgradePotentialFast",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onUpgradePotentialFast")
			}
		}
	},
	["panel.bottomPanel.icon"] = {
		varname = "icon",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowGold")
		}
	},
	["panel.bottomPanel.txt"] = {
		varname = "txt",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowGold")
		}
	},
	["panel.bottomPanel.cost"] = {
		varname = "cost",
		binds = {
			event = "visible",
			idler = bindHelper.self("isShowGold")
		}
	}
}

function var_0_0.onCreate(arg_3_0, arg_3_1)
	arg_3_0.panel = panel
	arg_3_0.selectDbId, arg_3_0.equipIndex = arg_3_1()

	arg_3_0:initModel()

	arg_3_0.spine = widget.addAnimation(arg_3_0.pos, "effect/shipinfaguang.skel", "effect_loop", 20):scale(0.75):xy(-55, 50)
	arg_3_0.attrDatas = idlertable.new({})
	arg_3_0.attrPotentialDatas = idlertable.new({})
	arg_3_0.originX = arg_3_0.btnDown:x()
	arg_3_0.isShowGold = idler.new(true)
	arg_3_0.startPotentialFastUnlock = dataEasy.getListenUnlock(gUnlockCsv.starPotentialFast)

	idlereasy.any({
		arg_3_0.equips,
		arg_3_0.equipIndex,
		arg_3_0.gold,
		arg_3_0.startPotentialFastUnlock
	}, function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = arg_4_1[arg_4_2]
		local var_4_1 = csv.equips[var_4_0.equip_id]

		arg_3_0.data = var_4_0
		arg_3_0.starNum = var_4_0.star

		arg_3_0.none:visible(var_4_0.star == 0)
		arg_3_0.arrow:visible(var_4_0.star ~= var_4_1.starMax)

		if var_4_0.star ~= 0 then
			arg_3_0:setStar(arg_3_0.leftStar, var_4_0.star)
		end

		arg_3_0.leftStar:visible(var_4_0.star ~= 0 and var_4_0.ability == 0)
		arg_3_0.rightStar:visible(var_4_0.star ~= var_4_1.starMax and var_4_0.ability == 0)

		if var_4_0.star < var_4_1.starMax then
			arg_3_0:setStar(arg_3_0.rightStar, var_4_0.star + 1)
		end

		adapt.oneLinePos(arg_3_0.starName, {
			arg_3_0.none,
			arg_3_0.leftStar,
			arg_3_0.arrow,
			arg_3_0.rightStar
		}, {
			cc.p(10, 0),
			cc.p(25, 0),
			cc.p(25, 0),
			cc.p(25, 0)
		}, "left")

		arg_3_0.ability = var_4_0.ability or 0

		arg_3_0.potentialNone:visible(false)
		arg_3_0.potentialArrow:visible(arg_3_0.ability ~= var_4_1.abilityMax and arg_3_0.ability > 0 and var_4_0.star == var_4_1.starMax)

		if arg_3_0.ability ~= 0 then
			arg_3_0.talentLeftEffect:text("+" .. var_4_1.abilityAttr[arg_3_0.ability])
			arg_3_0.leftStarNum:text(arg_3_0.ability)
		end

		if arg_3_0.ability > 0 and arg_3_0.ability < var_4_1.abilityMax and var_4_0.star == var_4_1.starMax then
			arg_3_0.talentRightEffect:text("+" .. var_4_1.abilityAttr[arg_3_0.ability + 1])
			arg_3_0.rightStarNum:text(arg_3_0.ability + 1)
		end

		arg_3_0.isShowGold:set(not var_4_0.star == var_4_1.starMax)

		if arg_3_0.ability >= 0 and arg_3_0.starNum == var_4_1.starMax then
			for iter_4_0, iter_4_1 in csvMapPairs(csv.base_attribute.equip_ability[arg_3_0.ability]["costItemMap" .. var_4_1.abilitySeqID]) do
				if iter_4_0 ~= "gold" then
					local var_4_2 = dataEasy.getNumByKey(iter_4_0)

					arg_3_0.itemPanel:get("btnAdd"):visible(var_4_2 < iter_4_1)
					bind.extend(arg_3_0, arg_3_0.itemPanel, {
						class = "icon_key",
						props = {
							data = {
								key = iter_4_0,
								num = var_4_2,
								targetNum = iter_4_1
							},
							grayState = var_4_2 < iter_4_1 and 1 or 0,
							onNode = function(arg_5_0)
								bind.click(arg_3_0, arg_5_0, {
									method = function()
										jumpEasy.jumpTo("gainWay", iter_4_0, nil, iter_4_1)
									end
								})
							end
						}
					})

					arg_3_0.isEnoughItems = iter_4_1 <= var_4_2

					arg_3_0.btnUpgradePotential:xy(250, 160)

					if arg_4_4 then
						arg_3_0.btnUpgradePotential:xy(-40, 160)
						arg_3_0.btnUpgradePotentialFast:xy(540, 160)
					end
				else
					arg_3_0.isShowGold:set(iter_4_1 > 0)
					arg_3_0.cost:text(iter_4_1)

					arg_3_0.isEnoughGold = iter_4_1 <= arg_4_3

					text.addEffect(arg_3_0.cost, {
						color = iter_4_1 <= arg_4_3 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
					})
					arg_3_0.btnUpgradePotential:xy(239, 95)

					if arg_4_4 then
						arg_3_0.btnUpgradePotential:xy(-51, 95)
						arg_3_0.btnUpgradePotentialFast:xy(529, 95)
					end

					adapt.oneLineCenterPos(cc.p(arg_3_0.btnUpgradePotential:x(), arg_3_0.btnUpgradePotential:y() + 90), {
						arg_3_0.txt,
						arg_3_0.cost,
						arg_3_0.icon
					})
				end
			end
		else
			for iter_4_2, iter_4_3 in csvMapPairs(csv.base_attribute.equip_star[var_4_0.star]["costItemMap" .. var_4_1.starSeqID]) do
				if iter_4_2 ~= "gold" then
					local var_4_3 = dataEasy.getNumByKey(iter_4_2)

					arg_3_0.itemPanel:get("btnAdd"):visible(var_4_3 < iter_4_3)
					bind.extend(arg_3_0, arg_3_0.itemPanel, {
						class = "icon_key",
						props = {
							data = {
								key = iter_4_2,
								num = var_4_3,
								targetNum = iter_4_3
							},
							grayState = var_4_3 < iter_4_3 and 1 or 0,
							onNode = function(arg_7_0)
								bind.click(arg_3_0, arg_7_0, {
									method = function()
										jumpEasy.jumpTo("gainWay", iter_4_2, nil, iter_4_3)
									end
								})
							end
						}
					})

					arg_3_0.isEnoughItems = iter_4_3 <= var_4_3
				else
					arg_3_0.isShowGold:set(iter_4_3 > 0)
					arg_3_0.cost:text(iter_4_3)

					arg_3_0.isEnoughGold = iter_4_3 <= arg_4_3

					text.addEffect(arg_3_0.cost, {
						color = iter_4_3 <= arg_4_3 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
					})
					adapt.oneLineCenterPos(cc.p(arg_3_0.btnUpgrade:x(), arg_3_0.btnUpgrade:y() + 90), {
						arg_3_0.txt,
						arg_3_0.cost,
						arg_3_0.icon
					})
				end
			end
		end

		arg_3_0.btnUpgrade:visible(var_4_0.star ~= var_4_1.starMax)
		arg_3_0.bottomPanel:visible(var_4_0.star ~= var_4_1.starMax or var_4_0.star == var_4_1.starMax and var_4_0.ability > 0)
		arg_3_0.max:visible(var_4_0.star == var_4_1.starMax and var_4_0.ability == 0)
		arg_3_0.btnStarPotential:visible(dataEasy.isShow(gUnlockCsv.equipAbility) and var_4_0.star == var_4_1.starMax and var_4_0.ability == 0)
		arg_3_0.starPanel:visible(var_4_0.star <= var_4_1.starMax and var_4_0.ability == 0)
		arg_3_0.starList:visible(var_4_0.star <= var_4_1.starMax and var_4_0.ability == 0)
		arg_3_0.potentialList:visible(var_4_0.star == var_4_1.starMax)
		arg_3_0.btnUpgradePotential:visible(var_4_0.ability > 0)
		arg_3_0.btnUpgradePotentialFast:visible(var_4_0.ability > 0 and arg_4_4)
		arg_3_0.potentialPanel:visible(arg_3_0.ability > 0)
		arg_3_0.leftPotential:visible(var_4_0.ability ~= 0)
		arg_3_0.rightPotential:visible(var_4_0.ability ~= var_4_1.abilityMax and var_4_0.star == var_4_1.starMax)
		arg_3_0.talentRightEffect:visible(var_4_0.ability ~= var_4_1.abilityMax and var_4_0.star == var_4_1.starMax)
		arg_3_0.effectArrow:visible(var_4_0.ability ~= var_4_1.abilityMax and var_4_0.star == var_4_1.starMax)
		uiEasy.setBtnShader(arg_3_0.btnUpgradePotential, nil, var_4_0.ability ~= var_4_1.abilityMax and 1 or 3)

		if var_4_0.ability ~= var_4_1.abilityMax then
			text.addEffect(arg_3_0.btnUpgradePotential:get("textNote"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			})
		else
			text.deleteAllEffect(arg_3_0.btnUpgradePotential:get("textNote"))
		end

		if var_4_0.ability == var_4_1.abilityMax then
			arg_3_0.btnUpgradePotentialFast:loadTextureNormal("common/btn/btn_normal.png")
			arg_3_0.btnUpgradePotentialFast:get("textNote"):setTextColor(ui.COLORS.NORMAL.YELLOW)
			arg_3_0.btnUpgradePotentialFast:get("textNote"):enableGlow(ui.COLORS.GLOW.WHITE)
			uiEasy.setBtnShader(arg_3_0.btnUpgradePotentialFast, nil, 3)
		else
			arg_3_0.btnUpgradePotentialFast:loadTextureNormal("common/btn/btn_normal.png")
			arg_3_0.btnUpgradePotentialFast:get("textNote"):disableEffect()
			arg_3_0.btnUpgradePotentialFast:get("textNote"):setTextColor(ui.COLORS.NORMAL.YELLOW)
			text.addEffect(arg_3_0.btnUpgradePotentialFast:get("textNote"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			})
			uiEasy.setBtnShader(arg_3_0.btnUpgradePotentialFast, nil, 1)
		end

		adapt.oneLinePos(arg_3_0.potentialName, {
			arg_3_0.leftPotential,
			arg_3_0.potentialArrow,
			arg_3_0.rightPotential
		}, {
			cc.p(5, 0),
			cc.p(25, 0),
			cc.p(25, 0)
		}, "left")

		if matchLanguage({
			"kr"
		}) then
			adapt.oneLinePos(arg_3_0.talentName, {
				arg_3_0.talentLeftEffect,
				arg_3_0.effectArrow,
				arg_3_0.talentRightEffect
			}, {
				cc.p(0, 0),
				cc.p(15, 0),
				cc.p(15, 0)
			}, "left")
		else
			adapt.oneLinePos(arg_3_0.talentName, {
				arg_3_0.talentLeftEffect,
				arg_3_0.effectArrow,
				arg_3_0.talentRightEffect
			}, {
				cc.p(0, 0),
				cc.p(25, 0),
				cc.p(25, 0)
			}, "left")
		end

		local var_4_4 = {}

		for iter_4_4 = 1, math.huge do
			local var_4_5, var_4_6, var_4_7 = var_0_1.getAttrNum(var_4_0, iter_4_4, "star")

			if var_4_5 == 0 then
				break
			end

			table.insert(var_4_4, {
				attr = var_4_5,
				currVal = var_4_6,
				nextVal = var_4_7
			})
		end

		arg_3_0.attrDatas:set(var_4_4)

		local var_4_8 = {}

		for iter_4_5 = 1, math.huge do
			local var_4_9, var_4_10, var_4_11 = var_0_1.getAttrNum(var_4_0, iter_4_5, "ability")

			if var_4_9 == 0 then
				break
			end

			table.insert(var_4_8, {
				attr = var_4_9,
				currVal = var_4_10,
				nextVal = var_4_11
			})
		end

		arg_3_0.attrPotentialDatas:set(var_4_8)

		if var_4_0.star > 0 then
			arg_3_0.btnDown:texture("city/card/equip/icon_star_down2.png")
		else
			arg_3_0.btnDown:texture("city/card/equip/icon_star_down1.png")
		end

		arg_3_0.btnDown:x((var_4_0.star ~= var_4_1.starMax or var_4_0.star == var_4_1.starMax and var_4_0.ability > 0) and arg_3_0.originX - 150 or arg_3_0.originX)
	end)
end

function var_0_0.setStar(arg_9_0, arg_9_1, arg_9_2)
	arg_9_1:removeAllChildren()

	for iter_9_0 = 1, arg_9_2 do
		ccui.ImageView:create("common/icon/icon_star.png"):anchorPoint(cc.p(0, 0.5)):xy((iter_9_0 - 1) * 32, 25):addTo(arg_9_1, 4, "star"):scale(0.4)
	end

	arg_9_1:size(cc.size(arg_9_2 * 32 + 15, 53))
end

function var_0_0.initModel(arg_10_0)
	idlereasy.when(arg_10_0.selectDbId, function(arg_11_0, arg_11_1)
		local var_11_0 = gGameModel.cards:find(arg_11_1)

		arg_10_0.equips = idlereasy.assign(var_11_0:getIdler("equips"), arg_10_0.equips)
		arg_10_0.fight = idlereasy.assign(var_11_0:getIdler("fighting_point"), arg_10_0.fight)
	end)

	arg_10_0.gold = gGameModel.role:getIdler("gold")
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.level = gGameModel.role:getIdler("level")
end

function var_0_0.onUp(arg_12_0)
	local var_12_0 = csv.equips[arg_12_0.data.equip_id]
	local var_12_1 = clone(arg_12_0.data)

	if not arg_12_0.isEnoughItems then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughStarItems)

		return
	end

	if not arg_12_0.isEnoughGold then
		gGameUI:showTip(gLanguageCsv.cardStarGoldNotEnough)

		return
	end

	local var_12_2 = arg_12_0.fight:read()
	local var_12_3 = {
		false
	}

	gGameApp:requestServerCustom("/game/equip/star"):params(arg_12_0.selectDbId, var_12_0.part):onResponse(function(arg_13_0)
		idlereasy.do_(function(arg_14_0, arg_14_1)
			audio.playEffectWithWeekBGM("circle.mp3")
			arg_12_0:playSpine(1, function()
				gGameUI:stackUI("city.card.equip.success", nil, {
					blackLayer = true
				}, {
					type = "star",
					leftItem = var_12_1,
					rightItem = arg_14_0[arg_14_1],
					fight = var_12_2,
					cardDbid = arg_12_0.selectDbId:read()
				})

				var_12_3[1] = true
			end, 1)
		end, arg_12_0.equips, arg_12_0.equipIndex)
	end):wait(var_12_3):doit()
end

function var_0_0.onDown(arg_16_0)
	local var_16_0 = arg_16_0.data.star
	local var_16_1 = arg_16_0.data.ability

	if var_16_0 <= 0 then
		gGameUI:showTip(gLanguageCsv.currentStarCannotReduced)

		return
	end

	local var_16_2 = csv.equips[arg_16_0.data.equip_id]
	local var_16_3 = gCostCsv.equip_drop_cost
	local var_16_4 = 0
	local var_16_5 = {}
	local var_16_6 = {}

	if var_16_1 > 0 then
		local var_16_7 = csv.equips[arg_16_0.data.equip_id]

		var_16_4 = var_16_3[math.min(var_16_1 + var_16_7.starMax, table.length(var_16_3))]
		var_16_5 = {
			string.format(gLanguageCsv.equipStarDownCost, var_16_4),
			string.format(gLanguageCsv.equipStarDownReturn, gLanguageCsv.starUp)
		}

		for iter_16_0 = 0, var_16_1 - 1 do
			for iter_16_1, iter_16_2 in csvMapPairs(csv.base_attribute.equip_ability[iter_16_0]["costItemMap" .. var_16_7.abilitySeqID]) do
				if not var_16_6[iter_16_1] then
					var_16_6[iter_16_1] = 0
				end

				var_16_6[iter_16_1] = var_16_6[iter_16_1] + iter_16_2
			end
		end
	else
		var_16_4 = var_16_3[var_16_0]
		var_16_5 = {
			string.format(gLanguageCsv.equipStarDownCost, var_16_4),
			string.format(gLanguageCsv.equipStarDownReturn, gLanguageCsv.starUp)
		}
	end

	gGameUI:showDialog({
		isRich = true,
		clearFast = true,
		btnType = 1,
		align = "left",
		strs = var_16_5,
		cb = function()
			if var_16_4 > arg_16_0.rmb:read() then
				gGameUI:showTip(gLanguageCsv.dropEquipStarRmbUp)

				return
			end

			gGameApp:requestServer("/game/equip/star/drop", function(arg_18_0)
				for iter_18_0 = 0, var_16_0 - 1 do
					for iter_18_1, iter_18_2 in csvMapPairs(csv.base_attribute.equip_star[iter_18_0]["costItemMap" .. var_16_2.starSeqID]) do
						if not var_16_6[iter_18_1] then
							var_16_6[iter_18_1] = 0
						end

						var_16_6[iter_18_1] = var_16_6[iter_18_1] + iter_18_2
					end
				end

				gGameUI:showGainDisplay(var_16_6)
			end, arg_16_0.selectDbId, var_16_2.part)
		end,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_0.playSpine(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = {}

	if arg_19_3 == 1 then
		var_19_0 = arg_19_0.starList:getChildren()
	elseif arg_19_3 == 2 then
		var_19_0 = arg_19_0.potentialList:getChildren()
	end

	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		local var_19_1 = iter_19_1:get("spine")

		if not var_19_1 then
			var_19_1 = widget.addAnimationByKey(iter_19_1, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(iter_19_1:get("arrow"):x() - 40, iter_19_1:size().height / 2 + 5):scale(0.5)
		else
			var_19_1:play("effect")
		end
	end

	local var_19_2 = arg_19_0.pos:get("effect")

	if var_19_2 then
		var_19_2:setTimeScale(arg_19_1 or 1)
		var_19_2:play("fangguang2")
	else
		var_19_2 = widget.addAnimationByKey(arg_19_0.pos, "koudai_gonghuixunlian/gonghuixunlian.skel", "effect", "fangguang2", 10000)

		var_19_2:xy(arg_19_0.pos:size().width / 2, 0)
	end

	var_19_2:setSpriteEventHandler(function(arg_20_0, arg_20_1)
		if arg_19_2 then
			arg_19_2()
		end
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_0.starPotential(arg_21_0)
	local var_21_0 = csv.equips[arg_21_0.data.equip_id]

	if not dataEasy.isUnlock(gUnlockCsv.equipAbility) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.equipAbility))

		return
	end

	arg_21_0.max:visible(false)
	arg_21_0.starPanel:visible(false)
	arg_21_0.potentialPanel:visible(true)
	arg_21_0.btnStarPotential:visible(false)
	arg_21_0.bottomPanel:visible(true)
	arg_21_0.btnUpgradePotential:visible(true)
	arg_21_0.btnUpgradePotentialFast:visible(dataEasy.isUnlock(gUnlockCsv.starPotentialFast))
	arg_21_0:playSpine(1, nil)
	arg_21_0.rightStarNum:text(1)
	arg_21_0.potentialNone:visible(true)
	arg_21_0.potentialArrow:visible(true)
	arg_21_0.effectArrow:visible(true)
	arg_21_0.talentLeftEffect:text("+0%")
	arg_21_0.talentRightEffect:text("+" .. var_21_0.abilityAttr[arg_21_0.ability + 1])
	adapt.oneLinePos(arg_21_0.itemPanel, arg_21_0.btnDown, cc.p(331, 0))
	adapt.oneLinePos(arg_21_0.potentialName, {
		arg_21_0.potentialNone,
		arg_21_0.potentialArrow,
		arg_21_0.rightPotential
	}, {
		cc.p(5, 0),
		cc.p(25, 0),
		cc.p(25, 0)
	}, "left")
	adapt.oneLinePos(arg_21_0.talentName, {
		arg_21_0.talentLeftEffect,
		arg_21_0.effectArrow,
		arg_21_0.talentRightEffect
	}, {
		cc.p(0, 0),
		cc.p(25, 0),
		cc.p(25, 0)
	}, "left")
	arg_21_0.btnUpgradePotential:xy(239, 95)

	if dataEasy.isUnlock(gUnlockCsv.starPotentialFast) then
		arg_21_0.btnUpgradePotential:xy(-51, 95)
		arg_21_0.btnUpgradePotentialFast:xy(529, 95)
	end

	if arg_21_0.isShowGold:read() then
		adapt.oneLineCenterPos(cc.p(arg_21_0.btnUpgradePotential:x(), arg_21_0.btnUpgradePotential:y() + 90), {
			arg_21_0.txt,
			arg_21_0.cost,
			arg_21_0.icon
		})
	end
end

function var_0_0.onUpgradePotential(arg_22_0)
	local var_22_0 = csv.equips[arg_22_0.data.equip_id]

	if arg_22_0.ability == var_22_0.abilityMax then
		gGameUI:showTip(gLanguageCsv.abilityMax)

		return false
	end

	if not arg_22_0.isEnoughItems then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughStarItems)

		return
	end

	if not arg_22_0.isEnoughGold then
		gGameUI:showTip(gLanguageCsv.cardStarGoldNotEnough)

		return
	end

	local var_22_1 = arg_22_0.fight:read()
	local var_22_2 = {
		false
	}

	gGameApp:requestServerCustom("/game/equip/ability"):params(arg_22_0.selectDbId, var_22_0.part):onResponse(function(arg_23_0)
		idlereasy.do_(function(arg_24_0, arg_24_1)
			audio.playEffectWithWeekBGM("circle.mp3")
			arg_22_0:playSpine(1, function()
				var_22_2[1] = true
			end, 2)
		end, arg_22_0.equips, arg_22_0.equipIndex)
	end):wait(var_22_2):doit()
end

function var_0_0.onUpgradePotentialFast(arg_26_0)
	local var_26_0 = csv.equips[arg_26_0.data.equip_id]

	if arg_26_0.ability == var_26_0.abilityMax then
		gGameUI:showTip(gLanguageCsv.abilityMax)

		return false
	end

	if not arg_26_0.isEnoughItems then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughStarItems)

		return
	end

	if not arg_26_0.isEnoughGold then
		gGameUI:showTip(gLanguageCsv.cardStarGoldNotEnough)

		return
	end

	gGameUI:stackUI("city.card.equip.fast_star", nil, nil, arg_26_0.selectDbId:read(), arg_26_0.data.equip_id, arg_26_0:createHandler("playSpine", 1, nil, 2))
end

return var_0_0
