local var_0_0 = class("GemDrawResultView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "gem_result.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	subList = "subList",
	bgPanel = "bgPanel",
	["downPanel.costInfo.textNote"] = "textNote",
	["downPanel.costInfo.imgIcon"] = "costIcon",
	downPanel = "downPanel",
	["downPanel.costInfo.textCost"] = "textCost",
	["bgPanel.yinjibg"] = "yinjibg",
	list = "list",
	movePanel = "movePanel",
	["downPanel.btnOk"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["downPanel.btnOk.textNote"] = {
		binds = {
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	["downPanel.btnAgain"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("drawAgain")
			}
		}
	},
	["downPanel.btnAgain.textNote"] = {
		binds = {
			{
				event = "text",
				data = bindHelper.self("drawAgainStr")
			},
			{
				event = "effect",
				data = {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				}
			}
		}
	},
	effect = {
		varname = "effect",
		binds = {
			{
				event = "click",
				method = bindHelper.self("onClickEffect")
			},
			{
				event = "visible",
				idler = bindHelper.self("showEffect")
			}
		}
	}
}

local var_0_1 = {
	gold = {
		[1] = "effect",
		[10] = "effect"
	},
	rmb = {
		[1] = "effect",
		[10] = "effect"
	}
}
local var_0_2 = {
	[1] = "effect",
	[10] = "effect"
}
local var_0_3 = {
	gold = {
		[1] = "gem_draw_1.mp3",
		[10] = "gem_gold_10.mp3"
	},
	rmb = {
		[1] = "gem_draw_1.mp3",
		[10] = "gem_diamond_10.mp3"
	}
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0.bgPanel:get("cover"):visible(false)

	arg_1_0.costType = arg_1_2
	arg_1_0.drawTimes = arg_1_3
	arg_1_0.againCb = arg_1_6
	arg_1_0.costNum = arg_1_4
	arg_1_0.ticketKey = arg_1_5
	arg_1_0.gemUp = arg_1_7
	arg_1_0.isJump = false

	arg_1_0.item:visible(false)

	arg_1_0.showEffect = idler.new(false)

	arg_1_0.item:visible(false)

	arg_1_0.drawAgainStr = string.format(gLanguageCsv.drawNum, arg_1_3)

	local var_1_0 = arg_1_7 and 0 or 2
	local var_1_1
	local var_1_2
	local var_1_3

	if not arg_1_7 then
		var_1_2 = widget.addAnimationByKey(arg_1_0.bgPanel, "effect/shipinchouka.skel", "effectBg", var_0_1[arg_1_2][arg_1_3], 1):alignCenter(arg_1_0.bgPanel:size()):scale(2):xy(arg_1_0.bgPanel:size().width / 2, 0)
		var_1_3 = 0
	else
		var_1_3 = arg_1_3 == 1 and 2.4 or 8
	end

	arg_1_0.list:setClippingEnabled(false)
	arg_1_0.downPanel:visible(false)
	arg_1_0.list:setScrollBarEnabled(false)
	audio.pauseMusic()
	audio.playEffectWithWeekBGM(var_0_3[arg_1_2][arg_1_3])

	if arg_1_7 then
		if var_1_2 then
			var_1_2:removeFromParent()
		end

		widget.addAnimationByKey(arg_1_0.bgPanel, "effect/gongxihuode.skel", "efc1", "effect_loop", 11):scale(1):alignCenter(arg_1_0.bgPanel:size()):y(1120)
		arg_1_0:showItems(arg_1_1)
		arg_1_0.yinjibg:visible(true)
	else
		performWithDelay(arg_1_0, function()
			performWithDelay(arg_1_0, function()
				if var_1_2 then
					var_1_2:removeFromParent()
				end

				local var_3_0 = widget.addAnimationByKey(arg_1_0.bgPanel, "effect/gongxihuode.skel", "efc1", "effect_loop", 11):scale(1):alignCenter(arg_1_0.bgPanel:size()):y(1120)

				arg_1_0:showItems(arg_1_1)
			end, var_1_3)
		end, var_1_0)
		arg_1_0.yinjibg:visible(true)
	end

	arg_1_0:initModel()

	local var_1_4 = idler.new()

	idlereasy.when(arg_1_0.items, function(arg_4_0, arg_4_1)
		var_1_4:set(arg_4_1[arg_1_0.ticketKey])
	end)
	idlereasy.any({
		arg_1_0[arg_1_2],
		var_1_4
	}, function()
		local var_5_0 = dataEasy.getNumByKey(arg_1_0.ticketKey)

		if var_5_0 >= arg_1_0.drawTimes and not arg_1_7 then
			arg_1_0.textCost:text(var_5_0 .. "/" .. arg_1_0.drawTimes)
			arg_1_0.costIcon:texture(dataEasy.getIconResByKey(arg_1_0.ticketKey))
		else
			arg_1_0.textCost:text(arg_1_0.costNum)

			local var_5_1 = dataEasy.getNumByKey(arg_1_0.costType) >= arg_1_0.costNum

			text.addEffect(arg_1_0.textCost, {
				color = var_5_1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED
			})
			arg_1_0.costIcon:texture(dataEasy.getIconResByKey(arg_1_0.costType))
		end
	end)
end

function var_0_0.onClickEffect(arg_6_0)
	arg_6_0.showEffect:set(false)

	arg_6_0.isJump = true
end

function var_0_0.showItems(arg_7_0, arg_7_1)
	arg_7_0.decomposedItems = {}

	arg_7_0.list:removeAllItems()
	arg_7_0.downPanel:visible(false)
	arg_7_0.movePanel:visible(true)

	arg_7_0.data = arg_7_1

	arg_7_0:getResourceNode():removeChildByName("centerItem")
	arg_7_0.bgPanel:get("cover"):visible(true)
	arg_7_0:showOneItem(1)
end

function var_0_0.showOneItem(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.data[arg_8_1]

	if not var_8_0 then
		arg_8_0:showEnd()

		return
	end

	local var_8_1 = arg_8_0.item:clone():show()

	var_8_1:get("textName"):visible(false)
	var_8_1:get("imgBg"):visible(false)
	arg_8_0:pushBackCustomItem(var_8_1)

	local var_8_2 = arg_8_0.item:get("icon"):clone():addTo(arg_8_0.movePanel):visible(false)

	bind.extend(arg_8_0, var_8_2, {
		class = "icon_key",
		props = {
			data = {
				key = var_8_0.key
			}
		}
	})

	local var_8_3 = 0.1

	performWithDelay(arg_8_0, function()
		local var_9_0 = cc.p(0, 0)

		if arg_8_0.drawTimes == 10 then
			var_9_0 = gGameUI:getConvertPosAR(var_8_1:get("icon"), arg_8_0.movePanel)
		end

		var_8_2:xy(1280, 120):visible(true):scale(0)
		var_8_2:runAction(cc.Sequence:create(cc.MoveTo:create(var_8_3, cc.p(var_9_0.x + arg_8_0.movePanel:width() / 2, var_9_0.y + arg_8_0.movePanel:height() / 2)), cc.CallFunc:create(function()
			bind.extend(arg_8_0, var_8_1:get("icon"), {
				class = "icon_key",
				props = {
					effect = "drawcard",
					data = {
						key = var_8_0.key,
						num = var_8_0.num
					}
				}
			})

			if var_8_0.decomposed then
				var_8_1:get("textName"):text(gLanguageCsv.decomposed):color(ui.NEWCOLORS.GREENLIGHT)
				table.insert(arg_8_0.decomposedItems, {
					var_8_1,
					var_8_0
				})
			else
				local var_10_0, var_10_1 = uiEasy.setIconName(var_8_0.key)

				var_8_1:get("textName"):text(var_10_0)
				text.addEffect(var_8_1:get("textName"), var_10_1)
			end

			var_8_1:get("textName"):visible(true)
			var_8_1:get("imgBg"):visible(true)
			var_8_2:removeSelf()
		end)))
		var_8_2:runAction(cc.Spawn:create(cc.RotateTo:create(var_8_3, 720), cc.ScaleTo:create(var_8_3, 1)))
		performWithDelay(arg_8_0, function()
			arg_8_0:showOneItem(arg_8_1 + 1)
		end, 0.03)
	end, 0.02)
end

function var_0_0.pushBackCustomItem(arg_12_0, arg_12_1)
	if arg_12_0.drawTimes == 1 then
		arg_12_0:getResourceNode():add(arg_12_1, 100)
		arg_12_1:alignCenter(arg_12_0:getResourceNode():size())
		arg_12_1:setName("centerItem"):y(620)

		return
	end

	local var_12_0
	local var_12_1 = arg_12_0.list:getItems()

	if #var_12_1 > 0 then
		var_12_0 = var_12_1[#var_12_1]
	else
		var_12_0 = arg_12_0.subList:clone()

		var_12_0:setScrollBarEnabled(false)
		arg_12_0.list:pushBackCustomItem(var_12_0)
	end

	if #var_12_0:getItems() > 4 then
		var_12_0 = arg_12_0.subList:clone()

		var_12_0:setScrollBarEnabled(false)
		arg_12_0.list:pushBackCustomItem(var_12_0)
	end

	var_12_0:pushBackCustomItem(arg_12_1)
	var_12_0:setClippingEnabled(false)
end

function var_0_0.showEnd(arg_13_0)
	audio.stopAllSounds()
	audio.resumeMusic()
	arg_13_0.downPanel:visible(true)
	adapt.oneLineCenterPos(cc.p(139, 35), {
		arg_13_0.textNote,
		arg_13_0.textCost,
		arg_13_0.costIcon
	})

	local var_13_0 = 1

	arg_13_0:enableSchedule():schedule(function(arg_14_0)
		var_13_0 = var_13_0 + 1

		for iter_14_0, iter_14_1 in ipairs(arg_13_0.decomposedItems) do
			local var_14_0 = iter_14_1[1]
			local var_14_1 = iter_14_1[2]

			if var_13_0 % 2 == 1 then
				bind.extend(arg_13_0, var_14_0:get("icon"), {
					class = "icon_key",
					props = {
						data = {
							key = var_14_1.key,
							num = var_14_1.num
						}
					}
				})
			else
				local var_14_2 = csv.gem.gem[var_14_1.key]
				local var_14_3, var_14_4 = csvNext(var_14_2.decomposeReturn)

				bind.extend(arg_13_0, var_14_0:get("icon"), {
					class = "icon_key",
					props = {
						data = {
							key = var_14_1.decomposed.key,
							num = var_14_1.decomposed.num
						}
					}
				})
			end
		end
	end, 1, 0, "playEffect")
end

function var_0_0.drawAgain(arg_15_0)
	if arg_15_0.againCb then
		if arg_15_0.gemUp then
			arg_15_0.againCb(arg_15_0.drawTimes, function(arg_16_0)
				arg_15_0:showItems(arg_16_0)
			end)
		else
			arg_15_0.againCb(arg_15_0.costType, arg_15_0.drawTimes, function(arg_17_0)
				arg_15_0:showItems(arg_17_0)
			end)
		end
	end
end

function var_0_0.initModel(arg_18_0)
	arg_18_0.gold = gGameModel.role:getIdler("gold")
	arg_18_0.rmb = gGameModel.role:getIdler("rmb")
	arg_18_0.items = gGameModel.role:getIdler("items")
end

return var_0_0
