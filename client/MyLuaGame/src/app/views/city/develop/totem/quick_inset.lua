local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("QuickInsetView", var_0_0)
local var_0_2 = {
	forbid = 3,
	can = 1,
	on = 2
}

local function var_0_3(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:multiget("icon", "name", "num")
	local var_1_1 = arg_1_1.attr
	local var_1_2 = ui.ATTR_LOGO[game.ATTRDEF_TABLE[var_1_1]]

	var_1_0.icon:texture(var_1_2)
	var_1_0.name:text(getLanguageAttr(var_1_1))
	text.addEffect(var_1_0.name, {
		outline = {
			size = 3,
			color = ui.COLORS.NORMAL.DEFAULT
		}
	})
	var_1_0.num:text("+" .. dataEasy.getAttrValueString(var_1_1, arg_1_1.num))
	adapt.oneLinePos(var_1_0.icon, {
		var_1_0.name,
		var_1_0.num
	}, {
		cc.p(10, 0),
		cc.p(10, 0)
	}, "left")
end

var_0_1.RESOURCE_FILENAME = "totem_quick_inset.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	subList = "subList",
	topPanel = "topPanel",
	["item.selectPanel"] = "selectPanel",
	["topPanel.btnItem"] = "btnItem",
	["item.attributePanel"] = "attributePanel",
	slider = "slider",
	label1 = "label1",
	["topPanel.btnList"] = {
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("topDatas"),
				item = bindHelper.self("btnItem"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_1.get(arg_2_1, "normal")
					local var_2_1 = arg_2_1.get(arg_2_1, "select")
					local var_2_2

					if arg_2_3.select then
						var_2_0.hide(var_2_0)

						var_2_2 = var_2_1.show(var_2_1)
					else
						var_2_1.hide(var_2_1)

						var_2_2 = var_2_0.show(var_2_0)
					end

					var_2_2:get("txt"):text(arg_2_3.name)
					var_2_1:setTouchEnabled(false)
					bind.touch(arg_2_0, var_2_0, {
						methods = {
							ended = functools.partial(arg_2_0.clickCell, arg_2_2)
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onTopItemClick")
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				xMargin = 15,
				asyncPreload = 10,
				columnSize = 2,
				data = bindHelper.self("showDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				sliderBg = bindHelper.self("slider"),
				itemAction = {
					isAction = true
				},
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = arg_3_1:multiget("name", "list", "icon", "attributePanel", "selectPanel")

					var_3_0.icon:hide()
					var_3_0.name:text(csv.totem.symbol[arg_3_3.id].name)
					text.addEffect(var_3_0.name, {
						outline = {
							size = 3,
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
					var_3_0.attributePanel:visible(arg_3_3.showTab == 2)
					var_3_0.list:visible(arg_3_3.showTab == 1)
					arg_3_1:get("selectPanel"):get("selectBtn"):setSelectedState(arg_3_3.state == var_0_2.on)
					cache.setShader(arg_3_1, false, arg_3_3.state ~= var_0_2.forbid and "normal" or "hsl_gray")

					local var_3_1 = var_3_0.attributePanel:get("energy"):multiget("icon", "txt", "txtEnergyNum")
					local var_3_2 = "+" .. csv.totem.symbol[arg_3_3.id].power

					var_3_1.txtEnergyNum:text(var_3_2)
					text.addEffect(var_3_1.txt, {
						outline = {
							size = 3,
							color = ui.COLORS.NORMAL.DEFAULT
						}
					})
					adapt.oneLinePos(var_3_1.icon, {
						var_3_1.txt,
						var_3_1.txtEnergyNum
					}, {
						cc.p(10, 0),
						cc.p(20, 0)
					}, "left")

					local var_3_3 = var_3_0.attributePanel:multiget("img1", "effect1", "effect2")

					for iter_3_0 = 1, itertools.size(arg_3_3.normalData) do
						if itertools.size(arg_3_3.normalData) == 1 then
							var_3_3.effect2:hide()
						end

						var_0_3(var_3_0.attributePanel:get(string.format("effect" .. iter_3_0)), arg_3_3.normalData[iter_3_0])
					end

					local var_3_4 = var_3_0.attributePanel:multiget("img2", "extra1", "extra2", "element")

					if itertools.size(arg_3_3.extraData) == 0 then
						itertools.invoke(var_3_4, "hide")
					else
						for iter_3_1 = 1, 3 do
							local var_3_5 = string.format("icon" .. iter_3_1)

							var_3_4.element:get(var_3_5):texture(ui.ATTR_ICON[arg_3_3.extraData[1].nature[iter_3_1]])

							if iter_3_1 >= 2 then
								if arg_3_3.extraData[iter_3_1] == nil then
									local var_3_6 = string.format("extra" .. iter_3_1 - 1)

									var_3_0.attributePanel:get(var_3_6):hide()
								else
									var_0_3(var_3_0.attributePanel:get(string.format("extra" .. iter_3_1 - 1)), arg_3_3.extraData[iter_3_1])
								end
							end
						end
					end

					bind.extend(arg_3_0, arg_3_1.get(arg_3_1, "list"), {
						class = "listview",
						props = {
							data = arg_3_3.totems,
							item = var_3_0.icon,
							onItem = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
								local var_4_0 = arg_4_1:multiget("yellow", "img", "light")
								local var_4_1 = csv.items[arg_4_3.id]
								local var_4_2 = var_4_1.icon
								local var_4_3 = var_4_1.specialArgsMap.ease and 2 or 1

								var_4_0.light:visible(arg_4_3.isAbleToActive)
								var_4_0.yellow:hide()
								var_4_0.img:texture(var_4_2)

								if not arg_4_3.isActive and var_4_3 == 2 then
									var_4_0.yellow:show()
									var_4_0.yellow:texture(var_4_2)
									var_4_0.img:hide()
								end
							end
						}
					})
					bind.touch(arg_3_0, arg_3_1, {
						methods = {
							ended = functools.partial(arg_3_0.clickCell, arg_3_1, arg_3_2, arg_3_3)
						}
					})
				end,
				onBeforeBuild = function(arg_5_0)
					local var_5_0, var_5_1 = arg_5_0:xy()
					local var_5_2 = arg_5_0:size()
					local var_5_3, var_5_4 = arg_5_0.sliderBg:xy()
					local var_5_5 = arg_5_0.sliderBg:size()

					arg_5_0:setScrollBarEnabled(true)
					arg_5_0:setScrollBarColor(cc.c3b(241, 59, 84))
					arg_5_0:setScrollBarOpacity(255)
					arg_5_0:setScrollBarAutoHideEnabled(false)
					arg_5_0:setScrollBarPositionFromCorner(cc.p(var_5_0 + var_5_2.width - var_5_3, (var_5_2.height - var_5_5.height) / 2 + 5))
					arg_5_0:setScrollBarWidth(var_5_5.width)
					arg_5_0:refreshView()
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	sureBtn = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			clicksafe = true,
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["sureBtn.label"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
			}
		}
	},
	["topPanel.btnItem.select.txt"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = cc.c3b(91, 84, 91)
				}
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
	},
	allPanel = {
		varname = "allPanel",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAllChoose")
			}
		}
	}
}

function var_0_1.onCreate(arg_6_0, arg_6_1)
	arg_6_0.id = arg_6_1.id
	arg_6_0.cb = arg_6_1.cb
	arg_6_0.success = false
	arg_6_0.isAllChoose = false
	arg_6_0.stoneData = {}
	arg_6_0.selectedData = {}
	arg_6_0.topDatas = idlers.newWithMap({
		{
			name = gLanguageCsv.totemTab
		},
		{
			name = gLanguageCsv.totemEffectTab
		}
	})
	arg_6_0.showTab = idler.new(1)
	arg_6_0.showDatas = idlers.new({})

	arg_6_0.showTab:addListener(function(arg_7_0, arg_7_1)
		arg_6_0.topDatas:atproxy(arg_7_1).select = false
		arg_6_0.topDatas:atproxy(arg_7_0).select = true

		arg_6_0.list:jumpToTop()
		arg_6_0:initStoneData()
	end)
	arg_6_0:onAllChoose()
	arg_6_0.allPanel:width(arg_6_0.allPanel:get("txt"):width() + 150)
	adapt.oneLinePos(arg_6_0.sureBtn, arg_6_0.allPanel, cc.p(5, 0), "right")
end

function var_0_1.initStoneData(arg_8_0)
	arg_8_0.stoneData = {}

	local var_8_0 = gGameModel.totem:read("totem_insetted")
	local var_8_1 = gGameModel.role:read("items")

	for iter_8_0, iter_8_1 in orderCsvPairs(csv.totem.symbol) do
		if iter_8_1.symbolGroupType == arg_8_0.id then
			local var_8_2 = {}
			local var_8_3 = 0
			local var_8_4 = 0

			for iter_8_2, iter_8_3 in ipairs(iter_8_1.totemGroup1) do
				local var_8_5 = var_8_0[iter_8_1.id] and var_8_0[iter_8_1.id][iter_8_2] and true or false
				local var_8_6 = not var_8_5 and (var_8_1[iter_8_3] or 0) > 0

				table.insert(var_8_2, {
					index = iter_8_2,
					id = iter_8_3,
					isActive = var_8_5,
					isAbleToInset = var_8_6
				})

				if var_8_5 then
					var_8_3 = var_8_3 + 1
				end

				if var_8_6 then
					var_8_4 = var_8_4 + 1
				end
			end

			local var_8_7 = iter_8_1.id
			local var_8_8 = csv.totem.symbol[var_8_7]
			local var_8_9 = {}
			local var_8_10 = {}
			local var_8_11 = var_8_8.nature or {}

			for iter_8_4 = 1, 2 do
				if var_8_8["attrType" .. iter_8_4] > 0 then
					table.insert(var_8_9, {
						show = index == 1,
						attr = var_8_8["attrType" .. iter_8_4],
						num = var_8_8["attrNum" .. iter_8_4]
					})
				end
			end

			if var_8_8.extraAttrsType1 > 0 then
				table.insert(var_8_10, {
					nature = var_8_11
				})
			end

			for iter_8_5 = 1, 2 do
				if var_8_8["extraAttrsType" .. iter_8_5] > 0 then
					table.insert(var_8_10, {
						show = false,
						attr = var_8_8["extraAttrsType" .. iter_8_5],
						num = var_8_8["extraAttrNum" .. iter_8_5]
					})
				end
			end

			if itertools.size(iter_8_1.totemGroup1) - var_8_3 - var_8_4 == 0 and var_8_4 > 0 then
				table.insert(arg_8_0.stoneData, {
					id = iter_8_1.id,
					totemsNum = itertools.size(iter_8_1.totemGroup1),
					totems = var_8_2,
					hasBeenInset = var_8_3 > 0,
					activeNum = var_8_3,
					limitToActiveNum = itertools.size(iter_8_1.totemGroup1) - var_8_3 - var_8_4,
					showTab = arg_8_0.showTab:read(),
					normalData = var_8_9,
					extraData = var_8_10,
					state = var_0_2.can
				})
			end
		end
	end

	table.sort(arg_8_0.stoneData, function(arg_9_0, arg_9_1)
		if arg_9_0.totemsNum ~= arg_9_1.totemsNum then
			return arg_9_1.totemsNum < arg_9_0.totemsNum
		end

		if arg_9_0.hasBeenInset ~= arg_9_1.hasBeenInset then
			return arg_9_0.hasBeenInset and not arg_9_1.hasBeenInset
		end

		if arg_9_0.limitToActiveNum ~= arg_9_1.limitToActiveNum then
			return arg_9_0.limitToActiveNum < arg_9_1.limitToActiveNum
		end

		return arg_9_0.id < arg_9_1.id
	end)
	arg_8_0.refreshStoneData(arg_8_0)
end

function var_0_1.refreshStoneData(arg_10_0)
	local var_10_0 = table.deepcopy(gGameModel.role:read("items"), true) or {}

	for iter_10_0, iter_10_1 in ipairs(arg_10_0.stoneData) do
		if arg_10_0.selectedData[iter_10_1.id] then
			for iter_10_2, iter_10_3 in ipairs(iter_10_1.totems) do
				if iter_10_3.isAbleToInset then
					var_10_0[iter_10_3.id] = var_10_0[iter_10_3.id] - 1
					iter_10_3.isAbleToActive = true
				end
			end

			iter_10_1.state = var_0_2.on
		end
	end

	for iter_10_4, iter_10_5 in ipairs(arg_10_0.stoneData) do
		if not arg_10_0.selectedData[iter_10_5.id] then
			local var_10_1 = 0

			iter_10_5.state = var_0_2.can

			local var_10_2 = {}

			for iter_10_6, iter_10_7 in ipairs(iter_10_5.totems) do
				if iter_10_7.isAbleToInset then
					if (var_10_0[iter_10_7.id] or 0) - (var_10_2[iter_10_7.id] or 0) > 0 then
						table.insert(var_10_2, iter_10_7.id)

						iter_10_7.isAbleToActive = true
						var_10_1 = var_10_1 + 1
					else
						iter_10_5.state = var_0_2.forbid
						iter_10_7.isAbleToActive = false
					end
				end
			end

			if iter_10_5.state == var_0_2.can and arg_10_0.canAllChoose then
				iter_10_5.state = var_0_2.on

				for iter_10_8, iter_10_9 in ipairs(var_10_2) do
					var_10_0[iter_10_9] = var_10_0[iter_10_9] - 1
				end

				arg_10_0.selectedData[iter_10_5.id] = true
			end

			iter_10_5.limitToActiveNum = iter_10_5.totemsNum - var_10_1 - iter_10_5.activeNum
		end
	end

	arg_10_0.canAllChoose = false

	local var_10_3 = 0

	for iter_10_10, iter_10_11 in ipairs(arg_10_0.stoneData) do
		if arg_10_0.selectedData[iter_10_11.id] then
			var_10_3 = var_10_3 + 1
		end
	end

	if var_10_3 == 0 then
		arg_10_0.allPanel:get("orderBtn"):setSelectedState(false)

		arg_10_0.isAllChoose = false
	end

	arg_10_0.label1:text(string.format(gLanguageCsv.totemCanMaxActive, var_10_3))
	dataEasy.tryCallFunc(arg_10_0.list, "updatePreloadCenterIndex")
	arg_10_0.showDatas:update(table.deepcopy(arg_10_0.stoneData))
end

function var_0_1.onItemClick(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if arg_11_4.state == var_0_2.forbid then
		gGameUI:showTip(gLanguageCsv.totemReusedOrLack)

		return
	end

	arg_11_0.selectedData[arg_11_4.id] = not arg_11_0.selectedData[arg_11_4.id]

	arg_11_0.refreshStoneData(arg_11_0)
end

function var_0_1.onSureClick(arg_12_0)
	local var_12_0 = {}

	for iter_12_0, iter_12_1 in ipairs(arg_12_0.stoneData) do
		if arg_12_0.selectedData[iter_12_1.id] then
			local var_12_1 = {}

			for iter_12_2, iter_12_3 in ipairs(iter_12_1.totems) do
				if iter_12_3.isAbleToActive then
					table.insert(var_12_1, iter_12_3.index)
				end
			end

			var_12_0[iter_12_1.id] = var_12_1
		end
	end

	if itertools.size(var_12_0) > 0 then
		gGameApp:requestServer("/game/totem/inset", function(arg_13_0)
			arg_12_0:setSuccess()

			if itertools.size(arg_13_0.view.activeSymbol) > 0 then
				local var_13_0 = arg_13_0.view.activeSymbol

				arg_12_0:addCallbackOnExit(function()
					gGameUI:stackUI("city.develop.totem.gain", nil, {}, {
						sort = true,
						csvIds = var_13_0
					})
				end)
			end

			arg_12_0:onClose()
		end, var_12_0)
	else
		gGameUI:showTip(gLanguageCsv.totemEmptyTips)
	end
end

function var_0_1.setSuccess(arg_15_0)
	arg_15_0.success = true
end

function var_0_1.onClose(arg_16_0)
	if arg_16_0.success and arg_16_0.cb then
		arg_16_0.addCallbackOnExit(arg_16_0, arg_16_0.cb)
	end

	var_0_0.onClose(arg_16_0)
end

function var_0_1.onAllChoose(arg_17_0)
	arg_17_0.isAllChoose = not arg_17_0.isAllChoose
	arg_17_0.selectedData = {}
	arg_17_0.canAllChoose = arg_17_0.isAllChoose

	arg_17_0.allPanel:get("orderBtn"):setSelectedState(arg_17_0.isAllChoose)
	arg_17_0.showTab:notify()
end

function var_0_1.onTopItemClick(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0.showTab:set(arg_18_2)
end

return var_0_1
