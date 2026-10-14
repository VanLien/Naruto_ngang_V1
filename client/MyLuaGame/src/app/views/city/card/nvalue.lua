local function var_0_0(arg_1_0, arg_1_1)
	return rich.createByStr(arg_1_0, 40, nil, nil, cc.p(0, 0.5)):anchorPoint(0, 0.5):xy(5, 25):addTo(arg_1_1, 6)
end

local var_0_1 = class("CardNvalueView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "card_nvalue.json"
var_0_1.RESOURCE_BINDING = {
	["panel.down.img"] = "downImg",
	["panel.down.costInfo.textCostNum"] = "textCostNum",
	item = "item",
	["panel.down.costInfo.imgIcon"] = "imgCostIcon",
	["panel.down.costInfo"] = "costInfo",
	["panel.down.tipPanel"] = "tipPanel",
	["content.bottom.listBg"] = "listBg",
	["panel.down.costInfo.textCostNote"] = "textCostNote",
	["panel.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onShowRule")
			}
		}
	},
	["panel.down.btnReset.textNote"] = {
		varname = "btnResetText",
		binds = {
			event = "effect",
			data = {
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["panel.down.btnReset"] = {
		varname = "btnReset",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onNvalueClick")
			}
		}
	},
	["panel.down.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				asyncPreload = 3,
				data = bindHelper.self("itemData"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.num < (arg_2_3.targetNum or 0)

					arg_2_1:get("btnAdd"):visible(var_2_0)
					arg_2_1:get("imgMask"):visible(var_2_0)

					local var_2_1 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.id,
								num = arg_2_3.num,
								targetNum = arg_2_3.targetNum
							},
							onNode = function(arg_3_0)
								arg_3_0:setTouchEnabled(false)
							end
						}
					}

					bind.extend(arg_2_0, arg_2_1, var_2_1)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_3)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	panel = {
		varname = "bg",
		binds = {
			event = "extend",
			class = "draw_attr",
			props = {
				type = "big",
				lock = true,
				nvalue = bindHelper.self("showNValue"),
				nvalueLocked = bindHelper.self("nvalueLocked"),
				effectAni = bindHelper.self("animationEffect"),
				selectDbId = bindHelper.self("selectDbId"),
				offsetPos = {
					{
						x = -120,
						y = -100
					},
					{
						x = 10,
						y = -160
					},
					{
						x = 10,
						y = -260
					},
					{
						x = -120,
						y = -320
					},
					{
						y = -260,
						x = matchLanguage({
							"kr",
							"en"
						}) and -265 or -210
					},
					{
						y = -160,
						x = matchLanguage({
							"kr",
							"en"
						}) and -265 or -210
					}
				},
				lockCb = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
					if arg_4_3 >= 6 and arg_4_4 == true then
						gGameUI:showDialog({
							btnType = 2,
							title = gLanguageCsv.tips,
							content = gLanguageCsv.nvalueAllLockedTip,
							cb = function()
								gGameApp:requestServer("/game/card/nvalue/locked/switch", nil, arg_4_2, game.ATTRDEF_SIMPLE_TABLE[arg_4_1])
							end
						})

						return
					end

					gGameApp:requestServer("/game/card/nvalue/locked/switch", nil, arg_4_2, game.ATTRDEF_SIMPLE_TABLE[arg_4_1])
				end,
				onNode = function(arg_6_0)
					arg_6_0:xy(350, 600):scale(1.2)

					local var_6_0 = arg_6_0:parent()
					local var_6_1 = arg_6_0:get("img")
					local var_6_2 = var_6_1:size()
					local var_6_3 = var_6_0.effectAni

					var_6_3:removeFromParent()
					var_6_3:addTo(var_6_1):xy(var_6_2.width / 2, var_6_2.height / 2)
				end,
				offset = {
					x = 230,
					y = 250
				}
			}
		}
	}
}

function var_0_1.showAnimation(arg_7_0)
	if not arg_7_0.showNValue then
		local var_7_0 = clone(arg_7_0.realNValue:read())

		arg_7_0.showNValue = idlertable.new(var_7_0)
	end

	local var_7_1 = 0.3
	local var_7_2 = arg_7_0.realNValue:read()
	local var_7_3 = arg_7_0.showNValue:read()
	local var_7_4 = true

	for iter_7_0, iter_7_1 in pairs(var_7_3) do
		if var_7_3[iter_7_0] ~= var_7_2[iter_7_0] then
			var_7_4 = false

			break
		end
	end

	if var_7_4 then
		return
	end

	local var_7_5 = {}
	local var_7_6 = 0

	arg_7_0:enableSchedule():schedule(function(arg_8_0)
		if var_7_6 == 0 then
			for iter_8_0, iter_8_1 in pairs(var_7_3) do
				var_7_5[iter_8_0] = var_7_2[iter_8_0] - var_7_3[iter_8_0]
			end

			if arg_7_0.animationEffect and arg_7_0.canPlayAni then
				audio.playEffectWithWeekBGM("refinement.mp3")
				arg_7_0.animationEffect:show()
				arg_7_0.animationEffect:play("effect")

				arg_7_0.canPlayAni = nil
			end
		end

		var_7_6 = var_7_6 + arg_8_0

		if var_7_6 >= var_7_1 then
			arg_7_0:unSchedule("nValueChange")
			arg_7_0.showNValue:set(clone(arg_7_0.realNValue:read()))
		else
			local var_8_0 = {}

			for iter_8_2, iter_8_3 in pairs(var_7_3) do
				var_8_0[iter_8_2] = math.floor(var_7_3[iter_8_2] + var_7_5[iter_8_2] * var_7_6 / var_7_1)
			end

			arg_7_0.showNValue:set(var_8_0)
		end
	end, 0.03, var_7_1, "nValueChange")
end

function var_0_1.onCreate(arg_9_0, arg_9_1)
	arg_9_0.stopAni = false
	arg_9_0.showNValue = nil
	arg_9_0.selectDbId = arg_9_1()

	arg_9_0:initModel()

	for iter_9_0, iter_9_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
		arg_9_0[iter_9_1] = idler.new("")
	end

	arg_9_0.canClick = true
	arg_9_0.havePerfect = false
	arg_9_0.lockNum = idler.new(0)
	arg_9_0.animationEffect = widget.addAnimation(arg_9_0:getResourceNode(), "effect/xilian.skel", "effect", 0)

	arg_9_0.animationEffect:hide()
	arg_9_0.animationEffect:setSpriteEventHandler(function(arg_10_0, arg_10_1)
		if arg_10_0 == sp.EventType.ANIMATION_COMPLETE then
			arg_9_0.animationEffect:hide()
		end
	end)

	local var_9_0 = csv.card_recast
	local var_9_1 = {}

	for iter_9_2, iter_9_3 in ipairs(var_9_0) do
		var_9_1[iter_9_3.lockNum] = iter_9_3.costItems
	end

	arg_9_0.nvalueGold = idler.new(0)
	arg_9_0.nvalueRmb = idler.new(0)
	arg_9_0.lackMaterial = idler.new(false)
	arg_9_0.itemData = idlertable.new({})

	idlereasy.when(arg_9_0.nvalueLocked, function(arg_11_0, arg_11_1)
		local var_11_0 = 0

		for iter_11_0, iter_11_1 in ipairs(game.ATTRDEF_SIMPLE_TABLE) do
			if arg_11_1[iter_11_1] then
				var_11_0 = var_11_0 + 1
			end
		end

		arg_9_0.lockNum:set(var_11_0)
	end)
	idlereasy.any({
		arg_9_0.lockNum,
		arg_9_0.items
	}, function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = var_9_1[arg_12_1]
		local var_12_1 = {}

		arg_9_0.lackMaterial:set(false)

		for iter_12_0, iter_12_1 in csvPairs(var_12_0) do
			local var_12_2 = arg_12_2[iter_12_0] or 0

			table.insert(var_12_1, {
				id = iter_12_0,
				num = var_12_2,
				targetNum = iter_12_1
			})

			if var_12_2 < iter_12_1 then
				arg_9_0.lackMaterial:set(true)
			end
		end

		if var_12_0.gold then
			table.insert(var_12_1, {
				id = "gold",
				num = var_12_0.gold
			})
		end

		arg_9_0.nvalueGold:set(var_12_0.gold)
		arg_9_0.itemData:set(var_12_1)
		arg_9_0.nvalueRmb:set(var_12_0.rmb)
		arg_9_0.textCostNum:text(var_12_0.rmb)
		arg_9_0.costInfo:visible(var_12_0.rmb and var_12_0.rmb > 0 or false)
		adapt.oneLineCenterPos(cc.p(arg_9_0.costInfo:width() / 2, arg_9_0.costInfo:height() / 2), {
			arg_9_0.textCostNote,
			arg_9_0.textCostNum,
			arg_9_0.imgCostIcon
		}, cc.p(6, 0))

		if arg_12_1 >= 6 then
			cache.setShader(arg_9_0.btnReset, false, "hsl_gray")
			text.deleteAllEffect(arg_9_0.btnResetText)
			text.addEffect(arg_9_0.btnResetText, {
				color = ui.COLORS.DISABLED.WHITE
			})
		else
			cache.setShader(arg_9_0.btnReset, false, "normal")
			text.addEffect(arg_9_0.btnResetText, {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		end
	end)

	arg_9_0.upGradeData1 = {
		{},
		{},
		{},
		{},
		{},
		{}
	}
	arg_9_0.upGradeData = idlers.newWithMap(arg_9_0.upGradeData1)

	idlereasy.when(arg_9_0.items, function(arg_13_0, arg_13_1)
		for iter_13_0, iter_13_1 in ipairs(gCardExpItemCsv) do
			local var_13_0 = iter_13_1.id

			arg_9_0.upGradeData:at(iter_13_0):modify(function(arg_14_0)
				arg_14_0.num = arg_13_1[var_13_0] or 0
				arg_14_0.quality = iter_13_1.quality
				arg_14_0.id = var_13_0
			end, true)
		end
	end)
	idlereasy.any({
		arg_9_0.realNValue,
		arg_9_0.nvalueLocked
	}, function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = false

		for iter_15_0, iter_15_1 in pairs(arg_15_1) do
			if iter_15_1 >= game.NVALUE_ATTR_LIMIT and not arg_15_2[iter_15_0] then
				var_15_0 = true
			end
		end

		arg_9_0.havePerfect = var_15_0

		if arg_9_0.stopAni then
			local var_15_1 = clone(arg_9_0.realNValue:read())

			arg_9_0.showNValue:set(var_15_1)
		else
			arg_9_0:showAnimation()
		end
	end)

	local var_9_2 = arg_9_0.tipPanel:get("text1Panel")
	local var_9_3 = arg_9_0.tipPanel:get("text2Panel")

	arg_9_0:enableSchedule()

	if not matchLanguage({
		"cn",
		"tw",
		"kr"
	}) then
		arg_9_0.tipPanel:size(820, 50)
		arg_9_0.tipPanel:x(arg_9_0.tipPanel:x() - 150)
		adapt.oneLinePos(arg_9_0.tipPanel, arg_9_0.downImg, nil, "right")
	end

	idlereasy.when(arg_9_0.selectDbId, function(arg_16_0, arg_16_1)
		local var_16_0 = arg_9_0.tipPanel:size()

		var_9_2:x(var_16_0.width)
		var_9_3:x(1)

		local var_16_1 = false
		local var_16_2 = 0

		arg_9_0:unSchedule("CardNvalueView")
		arg_9_0:schedule(function()
			if var_9_2:getChildrenCount() == 0 then
				var_9_3:x(1)
				arg_9_0:unSchedule("CardNvalueView")
			else
				local var_17_0 = var_16_2 % 2 == 0 and var_16_0.width or 1
				local var_17_1 = var_16_2 % 2 == 0 and 1 or var_16_0.width

				var_9_2:x(var_17_0)
				var_9_3:x(var_17_1)
				transition.executeSequence(var_9_2):moveTo(0.3, var_17_0 - var_16_0.width, 25):done()
				transition.executeSequence(var_9_3):moveTo(0.3, var_17_1 - var_16_0.width, 25):done()
			end

			var_16_2 = var_16_2 + 1
		end, 5, 5, "CardNvalueView")
	end)
	idlereasy.when(arg_9_0.nvalueRecastTotal, function(arg_18_0, arg_18_1)
		local var_18_0 = 0
		local var_18_1 = 0
		local var_18_2 = 0

		for iter_18_0, iter_18_1 in orderCsvPairs(csv.nvalue_min_value) do
			if arg_18_1 >= iter_18_1.nvalueTimes - 1 and var_18_0 < iter_18_1.minValue then
				var_18_0 = iter_18_1.minValue
			end

			if arg_18_1 < iter_18_1.nvalueTimes - 1 and var_18_2 == 0 then
				var_18_1 = iter_18_1.nvalueTimes - 1 - arg_18_1
				var_18_2 = iter_18_1.minValue
			end
		end

		if var_18_2 == 0 then
			arg_9_0:unSchedule("CardNvalueView")
			var_9_3:x(0)
		end

		var_9_2:removeAllChildren()
		var_9_3:removeAllChildren()

		if var_18_2 > 0 then
			var_0_0(string.format(gLanguageCsv.nvalueTip1, var_18_1, var_18_2), var_9_2)
		end

		var_0_0(string.format(gLanguageCsv.nvalueTip2, var_18_0), var_9_3)
	end)
end

function var_0_1.initModel(arg_19_0)
	arg_19_0.items = gGameModel.role:getIdler("items")
	arg_19_0.rmb = gGameModel.role:getIdler("rmb")
	arg_19_0.gold = gGameModel.role:getIdler("gold")

	idlereasy.when(arg_19_0.selectDbId, function(arg_20_0, arg_20_1)
		local var_20_0 = gGameModel.cards:find(arg_20_1)

		arg_19_0.stopAni = true
		arg_19_0.realNValue = idlereasy.assign(var_20_0:getIdler("nvalue"), arg_19_0.realNValue)
		arg_19_0.stopAni = false
		arg_19_0.nvalueLocked = idlereasy.assign(var_20_0:getIdler("nvalue_locked"), arg_19_0.nvalueLocked)
		arg_19_0.nvalueRecastTotal = idlereasy.assign(var_20_0:getIdler("nvalue_recast_total"), arg_19_0.nvalueRecastTotal)
	end)
end

function var_0_1.onItemClick(arg_21_0, arg_21_1, arg_21_2)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_21_2.id, nil, arg_21_2.targetNum)
end

function var_0_1.onNvalueClick(arg_22_0)
	if not arg_22_0.canClick then
		return
	end

	if arg_22_0.lockNum:read() >= 6 then
		gGameUI:showTip(gLanguageCsv.nvalueAllLocked)

		return
	end

	local var_22_0 = arg_22_0.nvalueRmb:read()

	if var_22_0 and var_22_0 > 0 and var_22_0 > arg_22_0.rmb:read() then
		uiEasy.showDialog("rmb", {
			onClose = arg_22_0:createHandler("onClose")
		})

		return
	end

	local var_22_1 = arg_22_0.nvalueGold:read()

	if var_22_1 and var_22_1 > 0 and var_22_1 > arg_22_0.gold:read() then
		gGameUI:showTip(gLanguageCsv.nvalueLackGold)

		return
	end

	if arg_22_0.lackMaterial:read() then
		gGameUI:showTip(gLanguageCsv.nvalueLackMaterial)

		return
	end

	arg_22_0.canClick = false

	local function var_22_2(arg_23_0)
		local function var_23_0()
			gGameApp:requestServer("/game/card/nvalue/recast", function(arg_25_0)
				arg_22_0.canPlayAni = true
				arg_22_0.canClick = true
			end, arg_22_0.selectDbId)
		end

		if var_22_0 and var_22_0 > 0 then
			dataEasy.sureUsingDiamonds(var_23_0, var_22_0, function()
				arg_22_0.canClick = true

				if arg_23_0 then
					arg_22_0.havePerfect = true
				end
			end)
		else
			var_23_0()
		end
	end

	if arg_22_0.havePerfect then
		gGameUI:showDialog({
			btnType = 2,
			isRich = true,
			content = "#C0x5B545B#" .. gLanguageCsv.perfectNvalueTips,
			btnStr = gLanguageCsv.nvalueContinue,
			cb = function()
				arg_22_0.havePerfect = false

				var_22_2(true)
			end,
			closeCb = function()
				arg_22_0.canClick = true
			end
		})

		return
	end

	var_22_2()
end

function var_0_1.onShowRule(arg_29_0)
	gGameUI:stackUI("common.rule", nil, nil, arg_29_0:createHandler("getRuleContext"))
end

function var_0_1.getRuleContext(arg_30_0, arg_30_1)
	local var_30_0 = adaptContext

	return {
		var_30_0.clone(arg_30_1.title, function(arg_31_0)
			arg_31_0:get("text"):text(gLanguageCsv.nvalueText)
		end),
		var_30_0.noteText(73001, 73003)
	}
end

return var_0_1
