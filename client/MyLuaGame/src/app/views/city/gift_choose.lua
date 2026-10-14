local var_0_0 = cc.load("mvc").ViewBase
local var_0_1 = class("GiftChooseView", Dialog)

var_0_1.RESOURCE_FILENAME = "gift_choose.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	rightBg = "rightBg",
	["open.textNum"] = "textNum",
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	btnOpen = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onOpen")
			}
		}
	},
	["btnOpen.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	list = {
		varname = "list",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("itemDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					bind.extend(arg_1_0, arg_1_1:get("panel"), {
						class = "icon_key",
						props = {
							data = {
								key = arg_1_3.key,
								num = arg_1_3.num
							},
							onNode = function(arg_2_0)
								bind.click(arg_1_0, arg_2_0, {
									method = functools.partial(arg_1_0.itemClick, arg_2_0, arg_1_2, arg_1_3)
								})
							end
						}
					})
					arg_1_1:removeChildByName("label")

					local var_1_0 = {}

					if arg_1_3.key == "card" then
						local var_1_1 = csv.cards[arg_1_3.num]

						var_1_0 = csv.unit[var_1_1.unitID]
					else
						var_1_0 = dataEasy.getCfgByKey(arg_1_3.key)
					end

					local var_1_2 = beauty.singleTextLimitWord(var_1_0.name, {
						fontSize = 40
					}, {
						width = 240
					}):xy(125, 26):addTo(arg_1_1, 2, "label")

					text.addEffect(var_1_2, {
						color = ui.COLORS.NORMAL.DEFAULT
					})
					arg_1_1:get("choose"):visible(arg_1_3.isSel)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["sliderPanel.subBtn"] = {
		varname = "sliderSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_3_0, arg_3_1, arg_3_2)
				return arg_3_0:onChangeNum(arg_3_1, arg_3_2, -1)
			end)
		}
	},
	["sliderPanel.addBtn"] = {
		varname = "sliderAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, 1)
			end)
		}
	},
	["sliderPanel.sunbtn10"] = {
		varname = "sliderSubBtn10",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, -10)
			end)
		}
	},
	["sliderPanel.addBtn10"] = {
		varname = "sliderAddBtn10",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_6_0, arg_6_1, arg_6_2)
				return arg_6_0:onChangeNum(arg_6_1, arg_6_2, 10)
			end)
		}
	},
	["sliderPanel.subBtns"] = {
		varname = "sliderSubBtnMax",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_7_0, arg_7_1, arg_7_2)
				return arg_7_0:onChangeNum(arg_7_1, arg_7_2, -100000)
			end)
		}
	},
	["sliderPanel.addBtnl"] = {
		varname = "sliderAddBtnMax",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_8_0, arg_8_1, arg_8_2)
				return arg_8_0:onChangeNum(arg_8_1, arg_8_2, 100000)
			end)
		}
	},
	["title.textNote"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["title.textNote2"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	}
}

function var_0_1.onCreate(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.itemDatasId = arg_9_1
	arg_9_0.itemDatas = idlers.new()

	arg_9_0:enableSchedule()

	local var_9_0 = {}
	local var_9_1 = dataEasy.getCfgByKey(arg_9_1)

	for iter_9_0, iter_9_1 in csvMapPairs(var_9_1.specialArgsMap) do
		if not iter_9_1.card then
			for iter_9_2, iter_9_3 in csvMapPairs(iter_9_1) do
				table.insert(var_9_0, {
					isSel = false,
					key = iter_9_2,
					num = iter_9_3,
					choose = iter_9_0
				})
			end
		end

		if iter_9_1.card then
			for iter_9_4, iter_9_5 in csvMapPairs(iter_9_1.card) do
				table.insert(var_9_0, {
					key = "card",
					isSel = false,
					num = iter_9_5,
					choose = iter_9_0
				})
			end
		end
	end

	table.sort(var_9_0, dataEasy.sortItemCmp)
	arg_9_0.itemDatas:update(var_9_0)

	arg_9_0.choose = idler.new(1)

	arg_9_0.choose:addListener(function(arg_10_0, arg_10_1)
		if arg_9_0.itemDatas:atproxy(arg_10_1) then
			arg_9_0.itemDatas:atproxy(arg_10_1).isSel = false
		end

		arg_9_0.itemDatas:atproxy(arg_10_0).isSel = true
		arg_9_0.params = {
			key = var_9_0[arg_10_0].key,
			num = var_9_0[arg_10_0].num
		}
	end)

	arg_9_0.cb = arg_9_3

	local var_9_2 = 0.5

	arg_9_0.num = arg_9_2.num and arg_9_2.num() or idler.new(1)
	arg_9_0.maxNum = arg_9_2.maxNum or 1

	idlereasy.when(arg_9_0.num, function(arg_11_0, arg_11_1)
		arg_9_0.sliderSubBtn:setTouchEnabled(arg_11_1 > 1)
		arg_9_0.sliderAddBtn:setTouchEnabled(arg_11_1 < arg_9_0.maxNum)
		arg_9_0.sliderSubBtn10:setTouchEnabled(arg_11_1 > 1)
		arg_9_0.sliderAddBtn10:setTouchEnabled(arg_11_1 < arg_9_0.maxNum)
		arg_9_0.sliderSubBtnMax:setTouchEnabled(arg_11_1 > 1)
		arg_9_0.sliderAddBtnMax:setTouchEnabled(arg_11_1 < arg_9_0.maxNum)
		cache.setShader(arg_9_0.sliderSubBtn, false, arg_11_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_9_0.sliderAddBtn, false, arg_11_1 < arg_9_0.maxNum and "normal" or "hsl_gray")
		cache.setShader(arg_9_0.sliderSubBtn10, false, arg_11_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_9_0.sliderAddBtn10, false, arg_11_1 < arg_9_0.maxNum and "normal" or "hsl_gray")
		cache.setShader(arg_9_0.sliderSubBtnMax, false, arg_11_1 > 1 and "normal" or "hsl_gray")
		cache.setShader(arg_9_0.sliderAddBtnMax, false, arg_11_1 < arg_9_0.maxNum and "normal" or "hsl_gray")
		arg_9_0.textNum:text(arg_9_0.num:read() .. "/" .. arg_9_0.maxNum)
	end)

	local var_9_3 = arg_9_0.list:width()
	local var_9_4 = #var_9_0
	local var_9_5, var_9_6 = arg_9_0.list:xy()
	local var_9_7 = arg_9_0.list:size()
	local var_9_8 = var_9_6 + var_9_7.height / 2
	local var_9_9 = arg_9_0.list:getItemsMargin()
	local var_9_10 = var_9_3 < arg_9_0.item:size().width * var_9_4 + (var_9_4 - 1) * var_9_9 and var_9_3 or arg_9_0.item:size().width * var_9_4 + (var_9_4 - 1) * var_9_9

	arg_9_0.list:size(var_9_10, var_9_7.height)
	arg_9_0.list:anchorPoint(0.5, 0.5)
	arg_9_0.list:xy(display.sizeInView.width / 2, var_9_8)
	arg_9_0.list:onScroll(function(arg_12_0)
		local var_12_0 = arg_9_0.list:getIndex(arg_9_0.list:getRightmostItemInCurrentView())

		arg_9_0.rightBg:visible(var_12_0 + 1 < var_9_4)
	end)
	Dialog.onCreate(arg_9_0)
end

function var_0_1.onOpen(arg_13_0)
	local var_13_0 = arg_13_0.num:read()
	local var_13_1 = arg_13_0.itemDatas:atproxy(arg_13_0.choose:read()).choose
	local var_13_2 = arg_13_0.params.key
	local var_13_3 = arg_13_0.params.num
	local var_13_4 = uiEasy.setIconName(var_13_2, var_13_3)

	if var_13_3 > 1 and var_13_2 ~= "card" and var_13_2 ~= "explore" then
		var_13_4 = gLanguageCsv.symbolBracketLeft .. var_13_4 .. "x" .. var_13_3 .. gLanguageCsv.symbolBracketRight
	end

	gGameUI:showDialog({
		isRich = true,
		btnType = 2,
		strs = {
			string.format(gLanguageCsv.sureProp, var_13_4, var_13_0)
		},
		cb = function()
			arg_13_0:addCallbackOnExit(functools.partial(arg_13_0.cb, var_13_0, var_13_1))
			var_0_0.onClose(arg_13_0)
		end
	})
end

function var_0_1.onItemClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if arg_15_0.choose:read() ~= arg_15_3 then
		arg_15_0.choose:set(arg_15_3)
	else
		gGameUI:showItemDetail(arg_15_2, arg_15_0.params)
	end
end

function var_0_1.onIncreaseNum(arg_16_0, arg_16_1)
	arg_16_0.num:modify(function(arg_17_0)
		return true, cc.clampf(arg_17_0 + arg_16_1, 1, arg_16_0.maxNum)
	end)
end

function var_0_1.onChangeNum(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_2.name == "click" then
		arg_18_0:unScheduleAll()
		arg_18_0:onIncreaseNum(arg_18_3)
	elseif arg_18_2.name == "began" then
		arg_18_0:schedule(function()
			arg_18_0:onIncreaseNum(arg_18_3)
		end, 0.05, 0, 100)
	elseif arg_18_2.name == "ended" or arg_18_2.name == "cancelled" then
		arg_18_0:unScheduleAll()
	end
end

return var_0_1
