local var_0_0 = class("ChipDrawResultView", cc.load("mvc").ViewBase)

var_0_0.RESOURCE_FILENAME = "gem_result.json"
var_0_0.RESOURCE_BINDING = {
	item = "item",
	subList = "subList",
	bgPanel = "bgPanel",
	["downPanel.costInfo.textNote"] = "textNote",
	["downPanel.costInfo.textCost"] = "textCost",
	downPanel = "downPanel",
	["downPanel.costInfo.imgIcon"] = "costIcon",
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
var_0_0.RESOURCE_STYLES = {
	full = true
}

function var_0_0.onCreate(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0.bgPanel:get("cover"):visible(false)

	arg_1_0.costType = arg_1_2
	arg_1_0.drawTimes = arg_1_3
	arg_1_0.againCb = arg_1_6
	arg_1_0.costNum = arg_1_4
	arg_1_0.ticketKey = arg_1_5
	arg_1_0.isJump = false

	arg_1_0.item:visible(false)

	arg_1_0.showEffect = idler.new(false)

	arg_1_0.item:visible(false)

	arg_1_0.drawAgainStr = string.format(gLanguageCsv.drawNum, arg_1_3)

	local var_1_0 = 0
	local var_1_1 = 0

	arg_1_0.list:setClippingEnabled(false)
	arg_1_0.downPanel:visible(false)
	arg_1_0.list:setScrollBarEnabled(false)
	performWithDelay(arg_1_0, function()
		performWithDelay(arg_1_0, function()
			local var_3_0 = widget.addAnimationByKey(arg_1_0.bgPanel, "effect/gongxihuode.skel", "efc1", "effect", 11):scale(1):alignCenter(arg_1_0.bgPanel:size()):y(1120)

			arg_1_0:showItems(arg_1_1)
		end, var_1_1)
	end, var_1_0)
	arg_1_0:initModel()

	local var_1_2 = idler.new()

	idlereasy.when(arg_1_0.items, function(arg_4_0, arg_4_1)
		var_1_2:set(arg_4_1[arg_1_0.ticketKey])
	end)
	idlereasy.any({
		arg_1_0.rmb,
		var_1_2
	}, function()
		local var_5_0 = dataEasy.getNumByKey(arg_1_0.ticketKey)
		local var_5_1 = true

		if arg_1_0.costType == "rmb" then
			if var_5_0 >= arg_1_0.drawTimes then
				arg_1_0.textCost:text(var_5_0 .. "/" .. arg_1_0.drawTimes)
				arg_1_0.costIcon:texture(dataEasy.getIconResByKey(arg_1_0.ticketKey))
			else
				arg_1_0.textCost:text(arg_1_0.costNum)
				arg_1_0.costIcon:texture(dataEasy.getIconResByKey(arg_1_0.costType))

				var_5_1 = dataEasy.getNumByKey(arg_1_0.costType) >= arg_1_0.costNum
			end
		elseif arg_1_0.costType == "item" then
			local var_5_2 = dataEasy.getNumByKey(arg_1_0.ticketKey)

			arg_1_0.textCost:text(var_5_2 .. "/" .. arg_1_0.costNum)
			arg_1_0.costIcon:texture(dataEasy.getIconResByKey(arg_1_0.ticketKey))

			var_5_1 = var_5_2 > arg_1_0.costNum
		end

		text.addEffect(arg_1_0.textCost, {
			color = var_5_1 and ui.COLORS.NORMAL.WHITE or ui.COLORS.NORMAL.RED
		})
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

	if arg_7_0.drawTimes > 1 then
		arg_7_0.bgPanel:get("cover"):visible(true)
	end

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
				key = var_8_0.key,
				dbId = var_8_0.dbId
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
						num = var_8_0.num,
						dbId = var_8_0.dbId
					}
				}
			})

			if var_8_0.decomposed then
				var_8_1:get("textName"):text(gLanguageCsv.decomposed):color(ui.COLORS.GREEN)
				table.insert(arg_8_0.decomposedItems, {
					var_8_1,
					var_8_0
				})
			else
				local var_10_0, var_10_1 = uiEasy.setIconName(var_8_0.key)
				local var_10_2 = beauty.singleTextLimitWord(var_10_0, {
					fontSize = 40
				}, {
					width = 240,
					onlyText = true
				})

				var_8_1:get("textName"):text(var_10_2)
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
							num = var_14_1.num,
							dbId = var_14_1.dbId
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
		arg_15_0.againCb(arg_15_0.costType, arg_15_0.drawTimes, function(arg_16_0)
			arg_15_0:showItems(arg_16_0)
		end)
	end
end

function var_0_0.initModel(arg_17_0)
	arg_17_0.rmb = gGameModel.role:getIdler("rmb")
	arg_17_0.items = gGameModel.role:getIdler("items")
end

return var_0_0
