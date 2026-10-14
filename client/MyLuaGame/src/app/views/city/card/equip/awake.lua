local var_0_0 = require("app.views.city.card.equip.view")
local var_0_1 = class("CardEquipAwakeView", cc.load("mvc").ViewBase)
local var_0_2 = {
	cc.c4b(91, 84, 91, 255),
	cc.c4b(92, 153, 112, 255),
	cc.c4b(61, 138, 153, 255),
	cc.c4b(138, 92, 153, 255),
	cc.c4b(230, 153, 0, 255),
	cc.c4b(230, 116, 34, 255)
}

var_0_1.RESOURCE_FILENAME = "card_equip_awake.json"
var_0_1.RESOURCE_BINDING = {
	["panel.abilityNamePanel.name2"] = "abilityRight",
	["panel.bottomPanel.icon"] = "icon",
	["panel.namePanel"] = "namePanel",
	["panel.pos"] = "pos",
	["panel.bottomPanel.cost"] = "cost",
	["panel.abilityNamePanel.arrow"] = "abilityArrow",
	["panel.abilityNamePanel.name1"] = "abilityLeft",
	["panel.bottomPanel.itemPanel"] = "itemPanel",
	item = "item",
	["panel.bottomPanel.txt"] = "txt",
	["panel.max"] = "max",
	["panel.bottomPanel"] = "bottomPanel",
	["panel.abilityNamePanel"] = "abilityNamePanel",
	["panel.btnDown"] = {
		varname = "btnDown",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onDown")
			}
		}
	},
	["panel.bottomPanel.btnAwake"] = {
		varname = "btnAwake",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwake")
			}
		}
	},
	["panel.bottomPanel.btnAwake.textNote"] = {
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["panel.bottomPanel.btnAwakeFast"] = {
		varname = "btnAwakeFast",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwakeAbilityFast")
			}
		}
	},
	["panel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("showTexts"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = arg_1_1:multiget("name", "left", "right", "arrow")

					var_1_0.name:text(arg_1_3.name .. ":")
					var_1_0.left:text("+" .. arg_1_3.num)
					var_1_0.right:text("+" .. arg_1_3.nextNum):visible(not arg_1_3.isMax)
					var_1_0.arrow:visible(not arg_1_3.isMax)

					if matchLanguage({
						"kr"
					}) then
						adapt.oneLinePos(var_1_0.name, {
							var_1_0.left,
							var_1_0.arrow,
							var_1_0.right
						}, cc.p(10, 0))
					elseif arg_1_3.type == "ability" then
						adapt.oneLinePos(var_1_0.name, {
							var_1_0.left,
							var_1_0.arrow,
							var_1_0.right
						}, {
							cc.p(5, 0),
							cc.p(20, 0),
							cc.p(20, 0)
						}, "left")
					else
						adapt.oneLinePos(var_1_0.name, {
							var_1_0.left,
							var_1_0.arrow,
							var_1_0.right
						}, cc.p(30, 0))
					end
				end
			}
		}
	},
	["panel.btnAwakeAbility"] = {
		varname = "btnAwakeAbility",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAwakeAbility")
			}
		}
	},
	["panel.btnAwakeAbility.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_2_0, arg_2_1)
	arg_2_0.selectDbId, arg_2_0.equipIndex = arg_2_1()

	arg_2_0:initModel()

	arg_2_0.spine = widget.addAnimation(arg_2_0.pos, "effect/shipinfaguang.skel", "effect_loop", 20):scale(0.75):xy(-55, 50)
	arg_2_0.showTexts = idlers.newWithMap({})

	idlereasy.any({
		arg_2_0.equips,
		arg_2_0.equipIndex,
		arg_2_0.gold,
		arg_2_0.awakeAbilityFastUnlock
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = arg_3_1[arg_3_2]
		local var_3_1 = csv.equips[var_3_0.equip_id]

		arg_2_0.data = var_3_0

		local var_3_2 = gLanguageCsv.equipAwakeDetail
		local var_3_3 = {}
		local var_3_4 = var_3_0.awake or 0
		local var_3_5 = var_3_4 >= var_3_1.awakeMax and var_3_1.awakeMax or var_3_4 + 1
		local var_3_6 = var_3_0.awake_ability or 0
		local var_3_7 = var_3_6 >= var_3_1.awakeAbilityMax and var_3_1.awakeAbilityMax or var_3_6 + 1

		if var_3_6 > 0 and var_3_4 == var_3_1.awakeMax and dataEasy.isUnlock(gUnlockCsv.equipAwakeAbility) then
			arg_2_0.abilityNamePanel:visible(true)
			arg_2_0.namePanel:visible(false)

			local var_3_8 = arg_2_0.abilityNamePanel:multiget("name1", "name2", "arrow")

			var_3_8.name1:text("+" .. var_3_6)
			var_3_8.name2:text("+" .. var_3_7)
			var_3_8.name2:visible(var_3_6 < var_3_1.awakeAbilityMax)
			var_3_8.arrow:visible(var_3_6 < var_3_1.awakeAbilityMax)
			adapt.oneLinePos(var_3_8.name1, {
				var_3_8.arrow,
				var_3_8.name2
			}, cc.p(30, 0))

			local var_3_9 = {}

			for iter_3_0 = 1, math.huge do
				local var_3_10 = var_3_1["awakeAbilityAttrType" .. iter_3_0]

				if not var_3_10 or var_3_10 == 0 then
					break
				end

				local var_3_11 = game.ATTRDEF_TABLE[var_3_10]
				local var_3_12 = "attr" .. string.caption(var_3_11)
				local var_3_13, var_3_14 = dataEasy.getAttrValueAndNextValue(var_3_10, var_3_1["awakeAbilityAttrNum" .. iter_3_0][var_3_6] or 0, var_3_1["awakeAbilityAttrNum" .. iter_3_0][var_3_7])

				table.insert(var_3_9, {
					type = "ability",
					name = gLanguageCsv[var_3_12],
					num = var_3_13,
					nextNum = var_3_14,
					isMax = var_3_6 >= var_3_1.awakeAbilityMax
				})
			end

			arg_2_0.showTexts:update(var_3_9)
			itertools.invoke({
				arg_2_0.cost,
				arg_2_0.icon,
				arg_2_0.txt
			}, "hide")

			for iter_3_1, iter_3_2 in csvMapPairs(csv.base_attribute.equip_awake_ability[var_3_6]["costItemMap" .. var_3_1.awakeAbilitySeqID]) do
				if iter_3_1 ~= "gold" then
					local var_3_15 = dataEasy.getNumByKey(iter_3_1)

					arg_2_0.itemPanel:get("btnAdd"):visible(var_3_15 < iter_3_2)
					bind.extend(arg_2_0, arg_2_0.itemPanel, {
						class = "icon_key",
						props = {
							data = {
								key = iter_3_1,
								num = var_3_15,
								targetNum = iter_3_2
							},
							grayState = var_3_15 < iter_3_2 and 1 or 0,
							onNode = function(arg_4_0)
								bind.click(arg_2_0, arg_4_0, {
									method = function()
										jumpEasy.jumpTo("gainWay", iter_3_1, nil, iter_3_2)
									end
								})
							end
						}
					})

					arg_2_0.isEnoughItems = iter_3_2 <= var_3_15
				elseif iter_3_2 > 0 then
					arg_2_0.cost:text(iter_3_2)
					arg_2_0.cost:show()
					arg_2_0.icon:show()
					arg_2_0.txt:show()

					arg_2_0.isEnoughGold = iter_3_2 <= arg_3_3

					text.addEffect(arg_2_0.cost, {
						color = iter_3_2 <= arg_3_3 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
					})
				end
			end
		elseif var_3_6 == 0 and var_3_4 == var_3_1.awakeMax and dataEasy.isUnlock(gUnlockCsv.equipAwakeAbility) then
			arg_2_0.abilityNamePanel:visible(false)
			arg_2_0.namePanel:visible(true)

			local var_3_16 = arg_2_0.namePanel:multiget("name1", "name2", "arrow")
			local var_3_17 = gLanguageCsv["symbolRome" .. var_3_4] or ""
			local var_3_18 = gLanguageCsv["symbolRome" .. var_3_5]

			if var_3_4 == 0 then
				var_3_17 = gLanguageCsv.notAwake
			end

			var_3_16.name1:text(var_3_17)
			var_3_16.name2:text(var_3_18)
			var_3_16.name2:visible(var_3_4 < var_3_1.awakeMax)
			var_3_16.arrow:visible(var_3_4 < var_3_1.awakeMax)
			adapt.oneLinePos(var_3_16.name1, {
				var_3_16.arrow,
				var_3_16.name2
			}, cc.p(30, 0))

			for iter_3_3 = 1, math.huge do
				local var_3_19 = var_3_1["awakeAttrType" .. iter_3_3]

				if not var_3_19 or var_3_19 == 0 then
					break
				end

				local var_3_20 = game.ATTRDEF_TABLE[var_3_19]
				local var_3_21 = "attr" .. string.caption(var_3_20)
				local var_3_22, var_3_23 = dataEasy.getAttrValueAndNextValue(var_3_19, var_3_1["awakeAttrNum" .. iter_3_3][var_3_4] or 0, var_3_1["awakeAttrNum" .. iter_3_3][var_3_5])

				table.insert(var_3_3, {
					type = "awake",
					name = gLanguageCsv[var_3_21],
					num = var_3_22,
					nextNum = var_3_23,
					isMax = var_3_4 >= var_3_1.awakeMax
				})
			end

			arg_2_0.showTexts:update(var_3_3)
			itertools.invoke({
				arg_2_0.cost,
				arg_2_0.icon,
				arg_2_0.txt
			}, "hide")

			for iter_3_4, iter_3_5 in csvMapPairs(csv.base_attribute.equip_awake_ability[var_3_6]["costItemMap" .. var_3_1.awakeAbilitySeqID]) do
				if iter_3_4 ~= "gold" then
					local var_3_24 = dataEasy.getNumByKey(iter_3_4)

					arg_2_0.itemPanel:get("btnAdd"):visible(var_3_24 < iter_3_5)
					bind.extend(arg_2_0, arg_2_0.itemPanel, {
						class = "icon_key",
						props = {
							data = {
								key = iter_3_4,
								num = var_3_24,
								targetNum = iter_3_5
							},
							grayState = var_3_24 < iter_3_5 and 1 or 0,
							onNode = function(arg_6_0)
								bind.click(arg_2_0, arg_6_0, {
									method = function()
										jumpEasy.jumpTo("gainWay", iter_3_4, nil, iter_3_5)
									end
								})
							end
						}
					})

					arg_2_0.isEnoughItems = iter_3_5 <= var_3_24
				elseif iter_3_5 > 0 then
					arg_2_0.cost:text(iter_3_5)
					arg_2_0.cost:show()
					arg_2_0.icon:show()
					arg_2_0.txt:show()

					arg_2_0.isEnoughGold = iter_3_5 <= arg_3_3

					text.addEffect(arg_2_0.cost, {
						color = iter_3_5 <= arg_3_3 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
					})
				end
			end
		else
			arg_2_0.abilityNamePanel:visible(false)
			arg_2_0.namePanel:visible(true)

			local var_3_25 = arg_2_0.namePanel:multiget("name1", "name2", "arrow")
			local var_3_26 = gLanguageCsv["symbolRome" .. var_3_4] or ""
			local var_3_27 = gLanguageCsv["symbolRome" .. var_3_5]

			if var_3_4 == 0 then
				var_3_26 = gLanguageCsv.notAwake
			end

			var_3_25.name1:text(var_3_26)
			var_3_25.name2:visible(var_3_4 < var_3_1.awakeMax)

			if var_3_27 then
				var_3_25.name2:text(var_3_27)
			end

			var_3_25.arrow:visible(var_3_4 < var_3_1.awakeMax)
			adapt.oneLinePos(var_3_25.name1, {
				var_3_25.arrow,
				var_3_25.name2
			}, cc.p(30, 0))

			for iter_3_6 = 1, math.huge do
				local var_3_28 = var_3_1["awakeAttrType" .. iter_3_6]

				if not var_3_28 or var_3_28 == 0 then
					break
				end

				local var_3_29 = game.ATTRDEF_TABLE[var_3_28]
				local var_3_30 = "attr" .. string.caption(var_3_29)
				local var_3_31, var_3_32 = dataEasy.getAttrValueAndNextValue(var_3_28, var_3_1["awakeAttrNum" .. iter_3_6][var_3_4] or 0, var_3_1["awakeAttrNum" .. iter_3_6][var_3_5])

				table.insert(var_3_3, {
					type = "awake",
					name = gLanguageCsv[var_3_30],
					num = var_3_31,
					nextNum = var_3_32,
					isMax = var_3_4 >= var_3_1.awakeMax
				})
			end

			arg_2_0.showTexts:update(var_3_3)
			itertools.invoke({
				arg_2_0.cost,
				arg_2_0.icon,
				arg_2_0.txt
			}, "hide")

			for iter_3_7, iter_3_8 in csvMapPairs(csv.base_attribute.equip_awake[var_3_4]["costItemMap" .. var_3_1.awakeSeqID]) do
				if iter_3_7 ~= "gold" then
					local var_3_33 = dataEasy.getNumByKey(iter_3_7)

					arg_2_0.itemPanel:get("btnAdd"):visible(var_3_33 < iter_3_8)
					bind.extend(arg_2_0, arg_2_0.itemPanel, {
						class = "icon_key",
						props = {
							data = {
								key = iter_3_7,
								num = var_3_33,
								targetNum = iter_3_8
							},
							grayState = var_3_33 < iter_3_8 and 1 or 0,
							onNode = function(arg_8_0)
								bind.click(arg_2_0, arg_8_0, {
									method = function()
										jumpEasy.jumpTo("gainWay", iter_3_7, nil, iter_3_8)
									end
								})
							end
						}
					})
				elseif iter_3_8 > 0 then
					arg_2_0.cost:text(iter_3_8)
					arg_2_0.cost:show()
					arg_2_0.icon:show()
					arg_2_0.txt:show()
				end
			end
		end

		arg_2_0.btnAwakeAbility:visible(dataEasy.isUnlock(gUnlockCsv.equipAwakeAbility) and var_3_6 == 0 and var_3_4 == var_3_1.awakeMax)
		arg_2_0.bottomPanel:visible(var_3_4 ~= var_3_1.awakeMax or var_3_6 > 0)
		arg_2_0.max:visible(var_3_4 == var_3_1.awakeMax and var_3_6 == 0)
		uiEasy.setBtnShader(arg_2_0.btnAwake, nil, var_3_6 ~= var_3_1.awakeAbilityMax and 1 or 3)

		if var_3_6 ~= var_3_1.awakeAbilityMax then
			text.addEffect(arg_2_0.btnAwake:get("textNote"), {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			})
		else
			text.deleteAllEffect(arg_2_0.btnAwake:get("textNote"))
		end

		if arg_3_4 and dataEasy.isShow(gUnlockCsv.equipAwakeAbility) and var_3_6 >= 0 and var_3_4 == var_3_1.awakeMax then
			arg_2_0.btnAwake:x(-52)
			arg_2_0.btnAwakeFast:x(528):show()

			if var_3_6 == var_3_1.awakeAbilityMax then
				arg_2_0.btnAwakeFast:loadTextureNormal("common/btn/btn_normal.png")
				arg_2_0.btnAwakeFast:get("textNote"):setTextColor(ui.COLORS.NORMAL.YELLOW)
				arg_2_0.btnAwakeFast:get("textNote"):enableGlow(ui.COLORS.GLOW.WHITE)
				uiEasy.setBtnShader(arg_2_0.btnAwakeFast, nil, 3)
				text.deleteAllEffect(arg_2_0.btnAwakeFast:get("textNote"))
			else
				arg_2_0.btnAwakeFast:loadTextureNormal("common/btn/btn_normal.png")
				arg_2_0.btnAwakeFast:get("textNote"):disableEffect()
				arg_2_0.btnAwakeFast:get("textNote"):setTextColor(ui.COLORS.NORMAL.YELLOW)
				uiEasy.setBtnShader(arg_2_0.btnAwakeFast, nil, 1)
				text.addEffect(arg_2_0.btnAwakeFast:get("textNote"), {
					outline = {
						size = 1,
						color = ui.NEWCOLORS.OUTLINE.YELLOW1
					}
				})
			end
		else
			arg_2_0.btnAwake:x(238)
			arg_2_0.btnAwakeFast:hide()
		end

		if var_3_4 == var_3_1.awakeMax then
			-- block empty
		elseif var_3_0.star < var_3_1.awakeStar[var_3_4 + 1] then
			arg_2_0.cost:show()
			arg_2_0.icon:hide()
			arg_2_0.txt:hide()
			arg_2_0.cost:text(string.format(gLanguageCsv.needEquipStar, var_3_1.awakeStar[var_3_4 + 1]))
			text.addEffect(arg_2_0.cost, {
				color = ui.COLORS.NORMAL.ALERT_ORANGE
			})
		end

		if var_3_4 > 0 or var_3_6 > 0 then
			arg_2_0.btnDown:texture("city/card/equip/icon_jj.png")
		else
			arg_2_0.btnDown:texture("city/card/equip/icon_jj_h.png")
		end

		arg_2_0.btnDown:x(var_3_4 == var_3_1.awakeMax and var_3_6 == 0 and arg_2_0.max:x() + 327 or arg_2_0.max:x() + 177)
	end)
end

function var_0_1.initModel(arg_10_0)
	idlereasy.when(arg_10_0.selectDbId, function(arg_11_0, arg_11_1)
		local var_11_0 = gGameModel.cards:find(arg_11_1)

		arg_10_0.equips = idlereasy.assign(var_11_0:getIdler("equips"), arg_10_0.equips)
		arg_10_0.fight = idlereasy.assign(var_11_0:getIdler("fighting_point"), arg_10_0.fight)
	end)

	arg_10_0.level = gGameModel.role:getIdler("level")
	arg_10_0.gold = gGameModel.role:getIdler("gold")
	arg_10_0.rmb = gGameModel.role:getIdler("rmb")
	arg_10_0.awakeAbilityFastUnlock = dataEasy.getListenUnlock(gUnlockCsv.awakePotentialFast)
end

function var_0_1.onAwake(arg_12_0)
	local var_12_0 = arg_12_0.fight:read()
	local var_12_1 = clone(arg_12_0.data)
	local var_12_2 = csv.equips[var_12_1.equip_id]
	local var_12_3 = var_12_1.awake or 0
	local var_12_4 = var_12_3 >= var_12_2.awakeMax and var_12_2.awakeMax or var_12_3 + 1
	local var_12_5 = var_12_1.awake_ability or 0

	if var_12_2.awakeRoleLevelMax[var_12_4] > arg_12_0.level:read() then
		gGameUI:showTip(gLanguageCsv.currentLevelNotAvailable)

		return
	end

	if var_12_1.star < var_12_2.awakeStar[var_12_4] then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughStar)

		return
	end

	local var_12_6 = {
		false
	}

	if var_12_5 >= 0 and var_12_3 == var_12_2.awakeMax and dataEasy.isUnlock(gUnlockCsv.equipAwakeAbility) then
		if var_12_5 == var_12_2.awakeAbilityMax then
			gGameUI:showTip(gLanguageCsv.awakeAbilityMax)

			return false
		end

		if arg_12_0.isEnoughItems == false then
			gGameUI:showTip(gLanguageCsv.equipNotEnoughAwakeItems)

			return
		end

		if arg_12_0.isEnoughGold == false then
			gGameUI:showTip(gLanguageCsv.goldNotEnough)

			return
		end

		gGameApp:requestServerCustom("/game/equip/awake/ability"):params(arg_12_0.selectDbId, var_12_2.part):onResponse(function(arg_13_0)
			idlereasy.do_(function(arg_14_0, arg_14_1)
				arg_12_0:playSpine(1, function()
					var_12_6[1] = true
				end)
			end, arg_12_0.equips, arg_12_0.equipIndex)
		end):wait(var_12_6):doit()
	else
		local var_12_7, var_12_8 = csvNext(csv.base_attribute.equip_awake[var_12_3]["costItemMap" .. var_12_2.awakeSeqID])

		if var_12_8 > dataEasy.getNumByKey(var_12_7) then
			gGameUI:showTip(gLanguageCsv.equipNotEnoughAwakeItems)

			return
		end

		gGameApp:requestServerCustom("/game/equip/awake"):params(arg_12_0.selectDbId, var_12_2.part):onResponse(function(arg_16_0)
			idlereasy.do_(function(arg_17_0, arg_17_1)
				arg_12_0:playSpine(1, function()
					gGameUI:stackUI("city.card.equip.success", nil, {
						blackLayer = true
					}, {
						type = "awake",
						leftItem = var_12_1,
						rightItem = arg_17_0[arg_17_1],
						fight = var_12_0,
						cardDbid = arg_12_0.selectDbId:read()
					})

					var_12_6[1] = true
				end)
			end, arg_12_0.equips, arg_12_0.equipIndex)
		end):wait(var_12_6):doit()
	end
end

function var_0_1.onDown(arg_19_0)
	local var_19_0 = arg_19_0.data.awake
	local var_19_1 = arg_19_0.data.awake_ability or 0

	if var_19_0 <= 0 and var_19_1 <= 0 then
		gGameUI:showTip(gLanguageCsv.currentAwakeCannotReduced)

		return
	end

	local var_19_2 = csv.equips[arg_19_0.data.equip_id]
	local var_19_3 = gCostCsv.equip_drop_cost
	local var_19_4 = math.min(var_19_0, table.length(var_19_3))
	local var_19_5 = 0
	local var_19_6 = {}
	local var_19_7 = {}
	local var_19_8 = 1

	if var_19_1 > 0 then
		local var_19_9 = csv.equips[arg_19_0.data.equip_id]

		var_19_5 = var_19_3[math.min(var_19_9.awakeMax + var_19_1, table.length(var_19_3))]
		var_19_8 = 2
		var_19_6 = {
			string.format(gLanguageCsv.equipAwakeAbilityDownCost, var_19_5)
		}

		for iter_19_0 = 0, var_19_1 - 1 do
			for iter_19_1, iter_19_2 in csvMapPairs(csv.base_attribute.equip_awake_ability[iter_19_0]["costItemMap" .. var_19_9.awakeAbilitySeqID]) do
				if not var_19_7[iter_19_1] then
					var_19_7[iter_19_1] = 0
				end

				var_19_7[iter_19_1] = var_19_7[iter_19_1] + iter_19_2
			end
		end
	else
		var_19_5 = var_19_3[var_19_0]
		var_19_6 = {
			string.format(gLanguageCsv.equipStarDownCost, var_19_5),
			string.format(gLanguageCsv.equipStarDownReturn, gLanguageCsv.awake)
		}
	end

	gGameUI:showDialog({
		isRich = true,
		clearFast = true,
		align = "left",
		strs = var_19_6,
		cb = function()
			if var_19_5 > arg_19_0.rmb:read() then
				gGameUI:showTip(gLanguageCsv.rmbNotEnough)

				return
			end

			gGameApp:requestServer("/game/equip/awake/drop", function(arg_21_0)
				for iter_21_0 = 0, var_19_0 - 1 do
					for iter_21_1, iter_21_2 in csvMapPairs(csv.base_attribute.equip_awake[iter_21_0]["costItemMap" .. var_19_2.awakeSeqID]) do
						if not var_19_7[iter_21_1] then
							var_19_7[iter_21_1] = 0
						end

						var_19_7[iter_21_1] = var_19_7[iter_21_1] + iter_21_2
					end
				end

				gGameUI:showGainDisplay(var_19_7)
			end, arg_19_0.selectDbId, var_19_2.part)
		end,
		btnType = var_19_8,
		dialogParams = {
			clickClose = false
		}
	})
end

function var_0_1.playSpine(arg_22_0, arg_22_1, arg_22_2)
	for iter_22_0, iter_22_1 in pairs(arg_22_0.list:getChildren()) do
		local var_22_0 = iter_22_1:get("spine")

		if not var_22_0 then
			var_22_0 = widget.addAnimationByKey(iter_22_1, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(iter_22_1:get("arrow"):x() - 40, iter_22_1:size().height / 2 + 5):scale(0.5)
		else
			var_22_0:xy(iter_22_1:get("arrow"):x() - 40, iter_22_1:size().height / 2 + 5):play("effect")
		end
	end

	local var_22_1 = arg_22_0.pos:get("effect")

	if var_22_1 then
		var_22_1:setTimeScale(arg_22_1 or 1)
		var_22_1:play("fangguang2")
	else
		var_22_1 = widget.addAnimationByKey(arg_22_0.pos, "koudai_gonghuixunlian/gonghuixunlian.skel", "effect", "fangguang2", 10000)

		var_22_1:xy(arg_22_0.pos:size().width / 2, 0)
	end

	var_22_1:setSpriteEventHandler(function(arg_23_0, arg_23_1)
		if arg_22_2 then
			arg_22_2()
		end
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_1.onAwakeAbility(arg_24_0)
	local var_24_0 = clone(arg_24_0.data)
	local var_24_1 = csv.equips[var_24_0.equip_id]
	local var_24_2 = var_24_0.awake_ability or 0

	if not dataEasy.isUnlock(gUnlockCsv.equipAwakeAbility) then
		gGameUI:showTip(dataEasy.getUnlockTip(gUnlockCsv.equipAwakeAbility))

		return
	end

	arg_24_0.btnAwakeAbility:visible(false)
	arg_24_0:playSpine(1, nil)
	arg_24_0.max:visible(false)
	arg_24_0.abilityNamePanel:visible(true)
	arg_24_0.namePanel:visible(false)
	arg_24_0.abilityLeft:text("+" .. var_24_2)
	arg_24_0.abilityRight:text("+" .. var_24_2 + 1)
	arg_24_0.bottomPanel:visible(true)
	arg_24_0.btnDown:x(arg_24_0.max:x() + 180)

	local var_24_3 = {}

	for iter_24_0 = 1, math.huge do
		local var_24_4 = var_24_1["awakeAbilityAttrType" .. iter_24_0]

		if not var_24_4 or var_24_4 == 0 then
			break
		end

		local var_24_5 = game.ATTRDEF_TABLE[var_24_4]
		local var_24_6 = "attr" .. string.caption(var_24_5)
		local var_24_7, var_24_8 = dataEasy.getAttrValueAndNextValue(var_24_4, var_24_1["awakeAbilityAttrNum" .. iter_24_0][var_24_2] or 0, var_24_1["awakeAbilityAttrNum" .. iter_24_0][var_24_2 + 1])

		table.insert(var_24_3, {
			type = "ability",
			name = gLanguageCsv[var_24_6],
			num = var_24_7,
			nextNum = var_24_8,
			isMax = var_24_2 >= var_24_1.awakeAbilityMax
		})
	end

	arg_24_0.showTexts:update(var_24_3)
end

function var_0_1.onAwakeAbilityFast(arg_25_0)
	local var_25_0 = clone(arg_25_0.data)
	local var_25_1 = csv.equips[var_25_0.equip_id]
	local var_25_2 = var_25_0.awake or 0
	local var_25_3 = var_25_0.awake_ability or 0
	local var_25_4 = var_25_2 >= var_25_1.awakeMax and var_25_1.awakeMax or var_25_2 + 1
	local var_25_5 = var_25_1.awakeRoleLevelMax[var_25_4]

	if var_25_3 == var_25_1.awakeAbilityMax then
		gGameUI:showTip(gLanguageCsv.awakeAbilityMax)

		return false
	end

	if var_25_5 > arg_25_0.level:read() then
		gGameUI:showTip(gLanguageCsv.currentLevelNotAvailable)

		return
	end

	if var_25_0.star < var_25_1.awakeStar[var_25_4] then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughStar)

		return
	end

	if arg_25_0.isEnoughItems == false then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughAwakeItems)

		return
	end

	if arg_25_0.isEnoughGold == false then
		gGameUI:showTip(gLanguageCsv.goldNotEnough)

		return
	end

	gGameUI:stackUI("city.card.equip.fast_awake", nil, nil, arg_25_0.selectDbId:read(), arg_25_0.data.equip_id, arg_25_0:createHandler("playSpine"))
end

return var_0_1
