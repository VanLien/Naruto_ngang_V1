local var_0_0 = class("CardEquipStrengthenView", cc.load("mvc").ViewBase)
local var_0_1 = require("app.views.city.card.equip.view")

var_0_0.RESOURCE_FILENAME = "card_equip_strengthen.json"
var_0_0.RESOURCE_BINDING = {
	["panel.upgradePanel.qualityItem"] = "qualityItem",
	panel = "panel",
	["panel.strengthenPanel"] = "strengthenPanel",
	["panel.pos"] = "pos",
	["panel.strengthenPanel.levelItem"] = "levelItem",
	["panel.upgradePanel.list"] = "list",
	item = "item",
	mask = "mask",
	["panel.upgradePanel"] = "upgradePanel",
	["panel.listAttr"] = {
		varname = "listAttr",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("item"),
				levelItem = bindHelper.self("levelItem"),
				qualityItem = bindHelper.self("qualityItem"),
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

					if arg_1_3.playSpine then
						if arg_1_2 == #arg_1_0.data then
							if arg_1_0.levelItem:get("spine") then
								arg_1_0.levelItem:get("spine"):play("effect")
							else
								widget.addAnimationByKey(arg_1_0.levelItem, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(arg_1_0.levelItem:size().width / 2 - 90, arg_1_0.levelItem:size().height / 2 + 5):scale(0.5)
							end

							if arg_1_0.qualityItem:get("spine") then
								arg_1_0.qualityItem:get("spine"):play("effect")
							else
								widget.addAnimationByKey(arg_1_0.qualityItem, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(arg_1_0.qualityItem:size().width / 2 - 90, arg_1_0.qualityItem:size().height / 2 + 5):scale(0.5)
							end
						end

						widget.addAnimationByKey(arg_1_1, "effect/shuzisaoguang.skel", "spine", "effect", 122):xy(arg_1_1:size().width / 2 - 90, arg_1_1:size().height / 2 + 5):scale(0.5)
					end

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
	["panel.strengthenPanel.btnStrengthen"] = {
		varname = "btnStrengthen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthen")
			}
		}
	},
	["panel.strengthenPanel.btnOne"] = {
		varname = "btnOne",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthenOne")
			}
		}
	},
	["panel.strengthenPanel.btnFast"] = {
		varname = "btnFast",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthenFast")
			}
		}
	},
	["panel.upgradePanel.btnUpgrade"] = {
		varname = "btnUpgrade",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAdvance")
			}
		}
	},
	["panel.strengthenPanel.btnFast.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["panel.strengthenPanel.btnOne.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["panel.upgradePanel.btnUpgrade.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	},
	["panel.strengthenPanel.btnStrengthen.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.WHITE
				}
			}
		}
	}
}

function var_0_0.onCreate(arg_2_0, arg_2_1)
	arg_2_0.selectDbId, arg_2_0.equipIndex, arg_2_0.tabKey, arg_2_0.state = arg_2_1()

	arg_2_0:enableSchedule()
	arg_2_0:initModel()

	arg_2_0.shiningSpine = widget.addAnimation(arg_2_0.pos, "effect/shipinfaguang.skel", "effect_loop", 20):scale(0.75):xy(-55, 50)
	arg_2_0.attrDatas = idlers.newWithMap({})
	arg_2_0.baseT = {}

	for iter_2_0, iter_2_1 in csvMapPairs(csv.base_attribute.equip_advance) do
		arg_2_0.baseT[iter_2_1.equip_id] = arg_2_0.baseT[iter_2_1.equip_id] or {}
		arg_2_0.baseT[iter_2_1.equip_id][iter_2_1.stage] = iter_2_1
	end

	idlereasy.any({
		arg_2_0.equips,
		arg_2_0.equipIndex,
		arg_2_0.level,
		arg_2_0.gold,
		arg_2_0.tabKey
	}, function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
		local var_3_0 = arg_3_1[arg_3_2]

		arg_2_0.upLevel = 0

		local var_3_1 = arg_3_4
		local var_3_2 = csv.equips[var_3_0.equip_id]
		local var_3_3 = var_3_2.strengthMax[var_3_0.advance]

		if var_3_3 > var_3_0.level then
			for iter_3_0 = var_3_0.level, var_3_3 do
				var_3_1 = var_3_1 - csv.base_attribute.equip_strength[iter_3_0]["costGold" .. var_3_2.strengthSeqID]

				if var_3_1 < 0 then
					arg_2_0.upLevel = iter_3_0

					break
				elseif iter_3_0 == var_3_3 then
					arg_2_0.upLevel = var_3_3
				end
			end
		end

		arg_2_0.data = var_3_0

		arg_2_0:onOneKeyPlayEnd(true)

		if not arg_2_0.isOneKeyBegin then
			arg_2_0:update(var_3_0, arg_3_3, arg_3_4)
		end
	end)
	dataEasy.getListenUnlock(gUnlockCsv.fastStrengthen, function(arg_4_0)
		nodetools.invoke(arg_2_0.strengthenPanel, {
			"btnFast",
			"txt5",
			"txt6"
		}, arg_4_0 and "show" or "hide")

		local var_4_0 = arg_2_0.btnFast:x()

		if arg_4_0 then
			var_4_0 = (var_4_0 + arg_2_0.btnStrengthen:x()) / 2
		end

		arg_2_0.btnOne:x(var_4_0)

		if matchLanguage({
			"en"
		}) then
			arg_2_0.strengthenPanel:get("txt5"):x(arg_2_0.strengthenPanel:get("txt3"):x())
			adapt.oneLinePos(arg_2_0.strengthenPanel:get("txt5"), arg_2_0.strengthenPanel:get("txt6"), cc.p(5, 0), "left")
		end
	end)
end

function var_0_0.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = csv.equips[arg_5_1.equip_id]
	local var_5_1 = arg_5_1.advance
	local var_5_2 = var_5_0.strengthMax[var_5_1]

	arg_5_2 = arg_5_2 or arg_5_0.level:read()
	arg_5_3 = arg_5_3 or arg_5_0.gold:read()

	local var_5_3 = {}
	local var_5_4 = var_5_0.strengthMax[csvSize(var_5_0.strengthMax)]

	if var_5_2 > arg_5_1.level then
		for iter_5_0 = 1, math.huge do
			local var_5_5, var_5_6, var_5_7 = var_0_1.getAttrNum(arg_5_1, iter_5_0, "strengthen")

			if var_5_5 == 0 then
				break
			end

			table.insert(var_5_3, {
				attr = var_5_5,
				currVal = var_5_6,
				nextVal = var_5_7
			})
		end

		local var_5_8 = arg_5_0.levelItem:multiget("name", "arrow", "leftPanel", "rightPanel")
		local var_5_9 = var_5_8.leftPanel:get("level")
		local var_5_10 = var_5_8.rightPanel:get("level")

		var_5_9:text(arg_5_1.level)
		var_5_10:text(arg_5_1.level + 1)

		local var_5_11 = var_5_8.leftPanel:get("lv")
		local var_5_12 = var_5_8.rightPanel:get("lv")

		adapt.oneLinePos(var_5_11, var_5_9, nil, "left")
		adapt.oneLinePos(var_5_12, var_5_10, nil, "left")
		var_5_8.leftPanel:size(var_5_11:size().width + var_5_9:size().width, var_5_8.leftPanel:size().height)
		var_5_8.rightPanel:size(var_5_12:size().width + var_5_10:size().width, var_5_8.rightPanel:size().height)
		adapt.oneLinePos(var_5_8.name, {
			var_5_8.leftPanel,
			var_5_8.arrow,
			var_5_8.rightPanel
		}, {
			cc.p(15, 0),
			cc.p(25, 0),
			cc.p(25, 0)
		}, "left")

		local var_5_13 = csv.base_attribute.equip_strength[arg_5_1.level]["costGold" .. var_5_0.strengthSeqID]
		local var_5_14 = arg_5_0.strengthenPanel:multiget("cost", "icon", "txt")

		text.addEffect(var_5_14.cost, {
			color = var_5_13 <= arg_5_3 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
		})

		arg_5_0.isEnoughGoldStrengthen = var_5_13 <= arg_5_3

		var_5_14.cost:text(var_5_13)
		adapt.oneLineCenterPos(cc.p(arg_5_0.btnStrengthen:x(), arg_5_0.btnStrengthen:y() + 90), {
			var_5_14.txt,
			var_5_14.cost,
			var_5_14.icon
		})
		var_5_14.cost:visible(var_5_13 > 0)
		var_5_14.icon:visible(var_5_13 > 0)
		var_5_14.txt:visible(var_5_13 > 0)
	else
		for iter_5_1 = 1, math.huge do
			local var_5_15, var_5_16, var_5_17 = var_0_1.getAttrNum(arg_5_1, iter_5_1, "advance")

			if var_5_15 == 0 then
				break
			end

			table.insert(var_5_3, {
				attr = var_5_15,
				currVal = var_5_16,
				nextVal = var_5_17
			})
		end

		local var_5_18, var_5_19 = dataEasy.getQuality(arg_5_1.advance)
		local var_5_20, var_5_21 = dataEasy.getQuality(arg_5_1.advance + 1)
		local var_5_22 = arg_5_0.qualityItem:multiget("name", "arrow", "leftQuality", "rightQuality")

		var_5_22.leftQuality:text(gLanguageCsv[ui.QUALITY_COLOR_SINGLE_TEXT[var_5_18]] .. var_5_19)
		var_5_22.rightQuality:text(gLanguageCsv[ui.QUALITY_COLOR_SINGLE_TEXT[var_5_20]] .. var_5_21)
		text.addEffect(var_5_22.leftQuality, {
			color = var_5_18 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_5_18]
		})
		text.addEffect(var_5_22.rightQuality, {
			color = var_5_20 == 1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.QUALITY[var_5_20]
		})

		if matchLanguage({
			"cn",
			"tw",
			"kr"
		}) then
			adapt.oneLinePos(var_5_22.name, {
				var_5_22.leftQuality,
				var_5_22.arrow,
				var_5_22.rightQuality
			}, {
				cc.p(15, 0),
				cc.p(25, 0),
				cc.p(25, 0)
			}, "left")
		elseif matchLanguage({
			"en"
		}) then
			var_5_22.name:y(79)
			var_5_22.leftQuality:x(9)
			adapt.oneLinePos(var_5_22.leftQuality, {
				var_5_22.arrow,
				var_5_22.rightQuality
			}, {
				cc.p(25, 0),
				cc.p(25, 0)
			}, "left")
		end

		local var_5_23 = {}

		arg_5_0.isEnoughItem = true

		for iter_5_2, iter_5_3 in csvMapPairs(gEquipAdvanceCsv[arg_5_1.equip_id][arg_5_1.advance].costItemMap) do
			local var_5_24 = dataEasy.getNumByKey(iter_5_2)

			if var_5_24 < iter_5_3 and arg_5_0.isEnoughItem then
				arg_5_0.isEnoughItem = false
			end

			table.insert(var_5_23, {
				key = iter_5_2,
				targetNum = iter_5_3,
				num = var_5_24,
				grayState = var_5_24 < iter_5_3 and 1 or 0
			})
		end

		uiEasy.createItemsToList(arg_5_0, arg_5_0.list, var_5_23, {
			margin = 20,
			scale = 0.9,
			onAfterBuild = function(arg_6_0)
				arg_6_0:setItemAlignCenter()
				arg_6_0:setClippingEnabled(false)
			end,
			onNode = function(arg_7_0, arg_7_1)
				bind.click(arg_5_0.list, arg_7_0, {
					method = function()
						jumpEasy.jumpTo("gainWay", arg_7_1.key, nil, arg_7_1.targetNum)
					end
				})

				local var_7_0 = arg_7_0:size()
				local var_7_1 = arg_7_0:get("addIcon")

				if arg_7_1.targetNum > arg_7_1.num then
					if not var_7_1 then
						ccui.ImageView:create("common/btn/btn_add_icon.png"):xy(var_7_0.width / 2, var_7_0.height / 2):addTo(arg_7_0, 60, "addIcon")
					else
						var_7_1:show()
					end
				elseif var_7_1 then
					var_7_1:hide()
				end
			end
		})

		local var_5_25 = arg_5_0.upgradePanel:multiget("cost", "icon", "txt")
		local var_5_26 = gEquipAdvanceCsv[arg_5_1.equip_id][arg_5_1.advance].costGold
		local var_5_27 = var_5_0.roleLevelMax[arg_5_1.advance]

		itertools.invoke({
			var_5_25.icon,
			var_5_25.txt
		}, "visible", var_5_27 <= arg_5_2)

		if arg_5_2 < var_5_27 then
			var_5_25.cost:text(string.format(gLanguageCsv.equipAdvanceAddLevelCondition, var_5_27))
			text.addEffect(var_5_25.cost, {
				color = ui.COLORS.NORMAL.ALERT_ORANGE
			})
		else
			var_5_25.cost:text(var_5_26)
			text.addEffect(var_5_25.cost, {
				color = var_5_26 <= arg_5_3 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.ALERT_ORANGE
			})
			adapt.oneLinePos(var_5_25.txt, {
				var_5_25.cost,
				var_5_25.icon
			})
			adapt.oneLineCenterPos(cc.p(arg_5_0.btnUpgrade:x(), arg_5_0.btnUpgrade:y() + 90), {
				var_5_25.txt,
				var_5_25.cost,
				var_5_25.icon
			})
			var_5_25.cost:visible(var_5_26 > 0)
			var_5_25.icon:visible(var_5_26 > 0)
			var_5_25.txt:visible(var_5_26 > 0)
		end

		arg_5_0.isEnoughLevel = var_5_27 <= arg_5_2
		arg_5_0.isEnoughGoldAdvance = var_5_26 <= arg_5_3
	end

	arg_5_0.attrDatas:update(var_5_3)
	arg_5_0.strengthenPanel:visible(var_5_2 > arg_5_1.level)
	arg_5_0.upgradePanel:visible(var_5_2 <= arg_5_1.level)
end

function var_0_0.onStrengthen(arg_9_0)
	local var_9_0 = csv.equips[arg_9_0.data.equip_id]

	if not arg_9_0.isEnoughGoldStrengthen then
		gGameUI:showTip(gLanguageCsv.strengthGoldNotEnough)

		return
	end

	arg_9_0.shiningSpine:hide()
	gGameApp:requestServer("/game/equip/strength", function(arg_10_0)
		performWithDelay(arg_9_0, function()
			arg_9_0:playSpine(1, function()
				arg_9_0.shiningSpine:show()
			end)
			gGameUI:showTip(gLanguageCsv.strengthenSuccess)
			audio.playEffectWithWeekBGM("circle.mp3")
		end, 0.01)
	end, arg_9_0.selectDbId, var_9_0.part, 1)
end

function var_0_0.playSpine(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.pos:get("effect")

	if var_13_0 then
		var_13_0:setTimeScale(arg_13_1 or 1)
		var_13_0:play("fangguang2")
	else
		var_13_0 = widget.addAnimationByKey(arg_13_0.pos, "koudai_gonghuixunlian/gonghuixunlian.skel", "effect", "fangguang2", 10000)

		var_13_0:xy(arg_13_0.pos:size().width / 2, 0)
	end

	arg_13_0.shiningSpine:hide()

	for iter_13_0, iter_13_1 in arg_13_0.attrDatas:ipairs() do
		iter_13_1:proxy().playSpine = true

		performWithDelay(arg_13_0, function()
			iter_13_1:proxy().playSpine = false
		end, 0.2)
	end

	var_13_0:setSpriteEventHandler(function(arg_15_0, arg_15_1)
		if arg_13_2 then
			arg_13_2()
		end
	end, sp.EventType.ANIMATION_COMPLETE)
end

function var_0_0.onStrengthenFast(arg_16_0)
	arg_16_0.oldFight = arg_16_0.fight:read()
	arg_16_0.leftData = clone(arg_16_0.data)

	gGameUI:stackUI("city.card.equip.fast_strengthen", nil, nil, arg_16_0.selectDbId:read(), arg_16_0.data.equip_id, arg_16_0:createHandler("onSuccess"))
end

function var_0_0.onSuccess(arg_17_0, arg_17_1)
	arg_17_0.shiningSpine:hide()
	arg_17_0:playSpine(1, function()
		arg_17_0.shiningSpine:show()
	end)

	if arg_17_1 then
		idlereasy.do_(function(arg_19_0, arg_19_1)
			gGameUI:stackUI("city.card.equip.success", nil, {
				blackLayer = true
			}, {
				type = "quick",
				leftItem = arg_17_0.leftData,
				rightItem = clone(arg_19_0[arg_19_1]),
				fight = arg_17_0.oldFight,
				cardDbid = arg_17_0.selectDbId:read()
			})
		end, arg_17_0.equips, arg_17_0.equipIndex)
	else
		gGameUI:showTip(gLanguageCsv.strengthenSuccess)
	end
end

function var_0_0.onStrengthenOne(arg_20_0)
	local var_20_0 = csv.equips[arg_20_0.data.equip_id]

	if not arg_20_0.isEnoughGoldStrengthen then
		gGameUI:showTip(gLanguageCsv.strengthGoldNotEnough)

		return
	end

	local var_20_1 = clone(arg_20_0.data)
	local var_20_2 = arg_20_0.data.level - 1
	local var_20_3 = arg_20_0.data.level - 1
	local var_20_4 = arg_20_0.upLevel

	arg_20_0.shiningSpine:hide()
	arg_20_0.mask:hide()

	arg_20_0.isOneKeyBegin = true

	gGameApp:requestServer("/game/equip/strength", function(arg_21_0)
		arg_20_0.isOneKeyPlaying = true

		arg_20_0.strengthenPanel:setEnabled(false)
		arg_20_0:schedule(function(arg_22_0)
			var_20_3 = var_20_3 + 1

			local var_22_0 = clone(var_20_1)

			var_22_0.level = var_20_3

			arg_20_0:update(var_22_0)
			arg_20_0:playSpine(1)
			audio.playEffectWithWeekBGM("circle.mp3")

			if var_20_3 == var_20_4 then
				arg_20_0:onOneKeyPlayEnd()
			end
		end, 0.1, 0.01, "strength")
	end, arg_20_0.selectDbId, var_20_0.part, var_20_4, true)
end

function var_0_0.onOneKeyPlayEnd(arg_23_0, arg_23_1)
	if not arg_23_0.isOneKeyPlaying then
		return
	end

	gGameUI:showTip(gLanguageCsv.strengthenSuccess)
	arg_23_0:unScheduleAll()

	arg_23_0.isOneKeyPlaying = false
	arg_23_0.isOneKeyBegin = false

	arg_23_0.mask:hide()
	arg_23_0.shiningSpine:visible(not arg_23_1)
	arg_23_0.strengthenPanel:setEnabled(true)
end

function var_0_0.initModel(arg_24_0)
	idlereasy.when(arg_24_0.selectDbId, function(arg_25_0, arg_25_1)
		local var_25_0 = gGameModel.cards:find(arg_25_1)

		arg_24_0.equips = idlereasy.assign(var_25_0:getIdler("equips"), arg_24_0.equips)
		arg_24_0.fight = idlereasy.assign(var_25_0:getIdler("fighting_point"), arg_24_0.fight)
	end)

	arg_24_0.gold = gGameModel.role:getIdler("gold")
	arg_24_0.level = gGameModel.role:getIdler("level")
end

function var_0_0.onAdvance(arg_26_0)
	if not arg_26_0.isEnoughLevel then
		gGameUI:showTip(gLanguageCsv.currentLevelNotAvailable)

		return
	end

	if not arg_26_0.isEnoughItem then
		gGameUI:showTip(gLanguageCsv.equipNotEnoughAdvanceItems)

		return
	end

	if not arg_26_0.isEnoughGoldAdvance then
		gGameUI:showTip(gLanguageCsv.equipAdvanceGoldNotEnough)

		return
	end

	arg_26_0.shiningSpine:hide()

	local var_26_0 = arg_26_0.fight:read()
	local var_26_1 = csv.equips[arg_26_0.data.equip_id]
	local var_26_2 = clone(arg_26_0.data)
	local var_26_3 = {
		false
	}

	gGameApp:requestServerCustom("/game/equip/advance"):params(arg_26_0.selectDbId, var_26_1.part):onResponse(function(arg_27_0)
		arg_26_0:playSpine(1, function()
			arg_26_0.shiningSpine:show()

			var_26_3[1] = true
		end)
	end):wait(var_26_3):doit(function(arg_29_0)
		idlereasy.do_(function(arg_30_0, arg_30_1)
			gGameUI:stackUI("city.card.equip.success", nil, {
				blackLayer = true
			}, {
				type = "advance",
				leftItem = var_26_2,
				rightItem = arg_30_0[arg_30_1],
				fight = var_26_0,
				cardDbid = arg_26_0.selectDbId:read()
			})
		end, arg_26_0.equips, arg_26_0.equipIndex)
	end)
end

return var_0_0
