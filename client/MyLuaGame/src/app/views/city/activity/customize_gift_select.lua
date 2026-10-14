local var_0_0 = class("ActivityCustomizeGiftSelectDialog", Dialog)

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	bind.extend(arg_1_0, arg_1_1, {
		class = "icon_key",
		props = {
			data = arg_1_2,
			onNode = function(arg_2_0)
				arg_2_0:setTouchEnabled(arg_1_3)
			end
		}
	})
end

var_0_0.RESOURCE_FILENAME = "activity_customize_gift_select.json"
var_0_0.RESOURCE_BINDING = {
	subList = "subList",
	slotIcon = "slotIcon",
	title = "title",
	iconItem = "iconItem",
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				yMargin = 0,
				leftPadding = 0,
				xMargin = 20,
				topPadding = 20,
				data = bindHelper.self("selectListData"),
				columnSize = bindHelper.self("midColumnSize"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("iconItem"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:multiget("pic", "select").select:visible(arg_3_3.choose)
					var_0_1(arg_3_0, arg_3_1:get("pic"), dataEasy.getItemData(arg_3_3.detail)[1], arg_3_3.choose)

					if not arg_3_3.choose then
						bind.touch(arg_3_0, arg_3_1:get("pic"), {
							clicksafe = false,
							methods = {
								ended = functools.partial(arg_3_0.clickSelectIcon, arg_3_3.num, arg_3_3)
							}
						})
					end
				end
			},
			handlers = {
				clickSelectIcon = bindHelper.self("clickSelectIcon")
			}
		}
	},
	slotList = {
		varname = "slotList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				margin = 30,
				data = bindHelper.self("slotListData"),
				item = bindHelper.self("slotIcon"),
				onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					local var_4_0 = arg_4_1:multiget("pic", "select", "add")

					var_4_0.select:visible(arg_4_3.select)
					var_4_0.add:visible(not arg_4_3.detail)

					if arg_4_3.detail then
						var_0_1(arg_4_0, arg_4_1:get("pic"), dataEasy.getItemData(arg_4_3.detail)[1], false)
					end

					bind.touch(arg_4_0, arg_4_1:get("pic"), {
						clicksafe = false,
						methods = {
							ended = functools.partial(arg_4_0.clickSlotIcon, arg_4_2, arg_4_3)
						}
					})
				end,
				onAfterBuild = function(arg_5_0)
					arg_5_0:setItemAlignCenter()
				end
			},
			handlers = {
				clickSlotIcon = bindHelper.self("clickSlotIcon")
			}
		}
	},
	tip2 = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = cc.c4b(239, 133, 97, 255)
				}
			}
		}
	},
	btn = {
		varname = "btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("clickSureBtn")
			}
		}
	},
	close = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	}
}

function var_0_0.onCreate(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	arg_6_0.activityId = arg_6_1

	arg_6_0:initModel(arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	Dialog.onCreate(arg_6_0)
end

function var_0_0.calcuteSelectState(arg_7_0, arg_7_1)
	local var_7_0 = true
	local var_7_1 = 0
	local var_7_2 = 0

	for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
		if iter_7_1 == 0 then
			var_7_0 = false
			var_7_1 = var_7_1 + 1
			var_7_2 = iter_7_0
		end
	end

	arg_7_0.selectState = {
		var_7_0,
		var_7_1,
		var_7_2
	}

	return var_7_0, var_7_1, var_7_2
end

function var_0_0.initModel(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_0.midColumnSize = 5
	arg_8_0.selectPanelData = {}
	arg_8_0.originalSelectPanelChooseData = {}
	arg_8_0.selectPanelChooseData = idlertable.new({})
	arg_8_0.selectState = {
		false,
		0,
		0
	}
	arg_8_0.slotListData = idlertable.new({})
	arg_8_0.selectListData = idlers.new()
	arg_8_0.chooseIconNum = idler.new(0)
	arg_8_0.chooseSlotNum = idler.new(1)
	arg_8_0.csvId = arg_8_1.csvId

	arg_8_0:initData(arg_8_1, arg_8_4, arg_8_3, arg_8_5)
	arg_8_0.chooseSlotNum:set(arg_8_3)
	arg_8_0.chooseIconNum:set(arg_8_5)
	idlereasy.when(arg_8_0.selectPanelChooseData, function(arg_9_0, arg_9_1)
		local var_9_0, var_9_1, var_9_2 = arg_8_0:calcuteSelectState(arg_9_1)
		local var_9_3 = var_9_1 == 1 and var_9_2 == arg_8_0.chooseSlotNum:read()

		arg_8_0.btn:setTouchEnabled(not var_9_3)

		if var_9_3 then
			cache.setShader(arg_8_0.btn, false, "hsl_gray")
			text.deleteEffect(arg_8_0.btn:get("label"), {
				"outline"
			})
			text.addEffect(arg_8_0.btn:get("label"), {
				color = ui.NEWCOLORS.OUTLINE.YELLOW1
			})
			cache.setShader(arg_8_0.btn:get("label"), false, "hsl_gray")
		else
			cache.setShader(arg_8_0.btn, false, "normal")
			text.addEffect(arg_8_0.btn:get("label"), {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			})
		end

		if var_9_1 > 1 or var_9_1 == 1 and var_9_2 ~= arg_8_0.chooseSlotNum:read() then
			arg_8_0.btn:get("label"):text(gLanguageCsv.nextOneChoose)
		else
			arg_8_0.btn:get("label"):text(gLanguageCsv.chooseLock)
		end
	end)
	arg_8_0.chooseSlotNum:addListener(function(arg_10_0, arg_10_1)
		if arg_10_0 ~= arg_10_1 and arg_10_0 > 0 then
			if arg_10_1 > 0 then
				arg_8_0.slotListData:proxy()[arg_10_1].select = false
			end

			arg_8_0.slotListData:proxy()[arg_10_0].select = true
		end

		arg_8_0.selectListData:update(arg_8_0.selectPanelData[arg_10_0])
		arg_8_0.chooseIconNum:set(arg_8_0.selectPanelChooseData:proxy()[arg_10_0])
	end)
	arg_8_0.chooseIconNum:addListener(function(arg_11_0, arg_11_1)
		local var_11_0 = arg_8_0.chooseSlotNum:read()

		if arg_11_0 > 0 then
			if arg_11_1 > 0 and arg_8_0.selectListData:atproxy(arg_11_1) then
				arg_8_0.selectListData:atproxy(arg_11_1).choose = false
			end

			arg_8_0.selectListData:atproxy(arg_11_0).choose = true

			if arg_8_0.selectPanelData[var_11_0][arg_11_0] then
				arg_8_0.slotListData:proxy()[var_11_0].detail = arg_8_0.selectPanelData[var_11_0][arg_11_0].detail
			end
		end

		for iter_11_0, iter_11_1 in ipairs(arg_8_0.selectPanelData[var_11_0]) do
			iter_11_1.choose = iter_11_0 == arg_11_0
		end

		arg_8_0.selectPanelChooseData:proxy()[var_11_0] = arg_11_0
	end)
end

function var_0_0.initData(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = {}
	local var_12_1 = {}
	local var_12_2 = {}
	local var_12_3 = {}

	for iter_12_0, iter_12_1 in ipairs(arg_12_1.awards) do
		local var_12_4 = {}

		if not iter_12_1.isFixAwards then
			local var_12_5 = 0

			for iter_12_2, iter_12_3 in ipairs(iter_12_1.showAwards) do
				local var_12_6 = false

				if iter_12_1.choose ~= nil then
					var_12_6 = iter_12_1.choose == iter_12_2
				end

				if var_12_6 then
					var_12_5 = iter_12_2
				end

				table.insert(var_12_4, {
					num = iter_12_2,
					detail = iter_12_3,
					choose = var_12_6
				})
			end

			table.insert(var_12_2, {
				detail = iter_12_1.showAwards[var_12_5],
				select = arg_12_3 == iter_12_1.optionSlotNum
			})
			table.insert(var_12_1, var_12_5)
			table.insert(var_12_0, var_12_4)
		end
	end

	for iter_12_4, iter_12_5 in ipairs(arg_12_2) do
		table.insert(var_12_3, {
			num = iter_12_4,
			detail = iter_12_5,
			choose = iter_12_4 == choose
		})
	end

	arg_12_0.originalSelectPanelChooseData = table.deepcopy(var_12_1, true)

	arg_12_0.selectPanelChooseData:set(var_12_1)

	arg_12_0.selectPanelData = var_12_0

	arg_12_0.slotListData:set(var_12_2)
	arg_12_0.selectListData:update(var_12_3)
end

function var_0_0.findNextZeroValue(arg_13_0)
	for iter_13_0, iter_13_1 in arg_13_0.selectPanelChooseData:ipairs() do
		if iter_13_0 > arg_13_0.chooseSlotNum:read() and iter_13_1 == 0 then
			return iter_13_0
		end
	end

	for iter_13_2, iter_13_3 in arg_13_0.selectPanelChooseData:ipairs() do
		if iter_13_3 == 0 then
			return iter_13_2
		end
	end
end

function var_0_0.clickSureBtn(arg_14_0)
	if arg_14_0.selectState[1] then
		arg_14_0:onClose()
	end

	if arg_14_0.selectState[2] > 1 or arg_14_0.selectState[2] == 1 and arg_14_0.selectState[3] ~= arg_14_0.chooseSlotNum:read() then
		arg_14_0.chooseSlotNum:set(arg_14_0:findNextZeroValue())
	end
end

function var_0_0.clickSlotIcon(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.chooseSlotNum:set(arg_15_2)
end

function var_0_0.clickSelectIcon(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.chooseIconNum:set(arg_16_2)
end

function var_0_0.isDataChange(arg_17_0)
	local var_17_0 = {}
	local var_17_1 = false

	for iter_17_0, iter_17_1 in arg_17_0.selectPanelChooseData:ipairs() do
		if arg_17_0.originalSelectPanelChooseData[iter_17_0] ~= iter_17_1 then
			var_17_1 = true
		end

		var_17_0[iter_17_0] = iter_17_1
	end

	return var_17_1, var_17_0
end

function var_0_0.onClose(arg_18_0)
	local var_18_0, var_18_1 = arg_18_0:isDataChange()

	if not var_18_0 then
		Dialog.onClose(arg_18_0)

		return
	end

	gGameApp:requestServer("/game/yy/customize/gift", function(arg_19_0)
		Dialog.onClose(arg_18_0)
	end, arg_18_0.activityId, arg_18_0.csvId, var_18_1)
end

return var_0_0
