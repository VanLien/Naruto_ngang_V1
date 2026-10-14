local var_0_0 = class("CardBagFilterView", cc.load("mvc").ViewBase)

local function var_0_1(arg_1_0)
	local var_1_0 = ""

	if not arg_1_0 then
		local var_1_1 = clone(ui.ATTR_ICON)

		table.insert(var_1_1, var_1_0)

		return var_1_1
	end

	return ui.ATTR_ICON[arg_1_0] or var_1_0, not ui.ATTR_ICON[arg_1_0]
end

local function var_0_2(arg_2_0)
	local var_2_0 = ""

	if not arg_2_0 then
		local var_2_1 = clone(ui.RARITY_ICON)

		var_2_1[table.maxn(var_2_1) + 1] = var_2_0

		return var_2_1
	end

	return ui.RARITY_ICON[arg_2_0] or var_2_0, not ui.RARITY_ICON[arg_2_0]
end

var_0_0.RESOURCE_FILENAME = "card_bag_filter.json"
var_0_0.RESOURCE_BINDING = {
	filterBtn = "filterBtn",
	["filterBtn.btn"] = "selBtn",
	["filterBtn.rarityListPanel.item"] = "rarityItem",
	["filterBtn.rarityListPanel.subList"] = "raritySubList",
	["filterBtn.attrListPanel.subList"] = "attrSubList",
	["filterBtn.attrListPanel.item"] = "attrItem",
	["filterBtn.btn.title"] = {
		varname = "btnTitle",
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 1,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["filterBtn.filterPanel"] = {
		varname = "filterPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("showfilterPanel")
		}
	},
	["filterBtn.filterPanel.cancle"] = {
		varname = "cancleBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onCancleClick")
			}
		}
	},
	["filterBtn.filterPanel.cancle.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.BLUE1
				}
			}
		}
	},
	["filterBtn.filterPanel.sure"] = {
		varname = "sureBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSureClick")
			}
		}
	},
	["filterBtn.filterPanel.sure.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["filterBtn.filterPanel.attr1Btn"] = {
		varname = "attr1Btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAttr1Click")
			}
		}
	},
	["filterBtn.filterPanel.attr2Btn"] = {
		varname = "attr2Btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onAttr2Click")
			}
		}
	},
	["filterBtn.filterPanel.rarityBtn"] = {
		varname = "rarityBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onRarityClick")
			}
		}
	},
	["filterBtn.filterPanel.atk1Btn"] = {
		varname = "atk1Btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_3_0)
					return arg_3_0:onAtkClick(game.ATTRDEF_ENUM_TABLE.damage)
				end)
			}
		}
	},
	["filterBtn.filterPanel.atk2Btn"] = {
		varname = "atk2Btn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					return arg_4_0:onAtkClick(game.ATTRDEF_ENUM_TABLE.specialDamage)
				end)
			}
		}
	},
	closePanel = {
		varname = "closePanel",
		binds = {
			{
				event = "visible",
				idler = bindHelper.self("showfilterPanel")
			},
			{
				event = "touch",
				methods = {
					ended = bindHelper.self("onClosePanel")
				}
			}
		}
	},
	["filterBtn.attrListPanel"] = {
		varname = "attrListPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("showAttrList")
		}
	},
	["filterBtn.attrListPanel.list"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 6,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("attrSubList"),
				cell = bindHelper.self("attrItem"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					arg_5_1:get("icon"):texture(arg_5_3.icon)

					local var_5_0 = arg_5_0:getIdx(arg_5_2)

					arg_5_1:onClick(functools.partial(arg_5_0.itemClick, var_5_0, arg_5_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onAttrItemClick")
			}
		}
	},
	["filterBtn.attrListPanel.allBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					return arg_6_0:onAttrItemClick(nil, {
						k = ui.ATTR_MAX
					})
				end)
			}
		}
	},
	["filterBtn.attrListPanel.allBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.BLACK,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["filterBtn.rarityListPanel.allBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.BLACK,
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	["filterBtn.rarityListPanel"] = {
		varname = "rarityListPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("showRarityList")
		}
	},
	["filterBtn.rarityListPanel.allBtn"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onSelectedAll")
			}
		}
	},
	["filterBtn.rarityListPanel.list"] = {
		varname = "rarityList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 4,
				data = bindHelper.self("rarityDatas"),
				item = bindHelper.self("raritySubList"),
				cell = bindHelper.self("rarityItem"),
				onCell = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					local var_7_0 = var_0_2(arg_7_3.rarity)

					arg_7_1:get("icon"):texture(var_7_0)
					arg_7_1:onClick(functools.partial(arg_7_0.itemClick, arg_7_0:getIdx(arg_7_2), arg_7_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onRarityItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_8_0, arg_8_1)
	arg_8_0.cb = arg_8_1.cb

	if arg_8_1.showIdler then
		arg_8_0.showIdler = arg_8_1.showIdler()
	end

	local var_8_0 = arg_8_1.others or {}
	local var_8_1 = var_8_0.width
	local var_8_2 = var_8_0.height
	local var_8_3 = var_8_0.x
	local var_8_4 = var_8_0.y
	local var_8_5 = var_8_0.scale
	local var_8_6 = var_8_0.btn
	local var_8_7 = var_8_0.panelOrder or false
	local var_8_8 = var_8_0.panelOffsetX or 760
	local var_8_9 = var_8_0.panelOffsetY or 0

	if var_8_1 and var_8_2 then
		arg_8_0.selBtn:size(var_8_1, var_8_2)
	end

	if var_8_5 then
		arg_8_0.selBtn:scale(var_8_5)
	end

	if var_8_3 then
		arg_8_0.filterBtn:xy(var_8_3, var_8_4)
	end

	if var_8_6 then
		arg_8_0.selBtn:visible(false)

		arg_8_0.selBtn = var_8_6
	end

	if var_8_7 then
		local var_8_10 = arg_8_0.filterPanel:y()
		local var_8_11 = 120 - var_8_9

		arg_8_0.filterPanel:xy(var_8_8, var_8_11)
		arg_8_0.attrListPanel:xy(var_8_8, var_8_11 + arg_8_0.attrListPanel:y() - var_8_10)
		arg_8_0.rarityListPanel:xy(var_8_8, var_8_11 + arg_8_0.rarityListPanel:y() - var_8_10)
	end

	if var_8_0.subPanelOrder then
		arg_8_0.attrListPanel:y(arg_8_0.attrListPanel:y() - 100 - arg_8_0.attrListPanel:height())
		arg_8_0.rarityListPanel:y(arg_8_0.rarityListPanel:y() - 60 - arg_8_0.rarityListPanel:height())
	end

	arg_8_0.attr12Choose = 1
	arg_8_0.attr1 = idler.new(ui.ATTR_MAX)
	arg_8_0.attr2 = idler.new(ui.ATTR_MAX)
	arg_8_0.rarity = idler.new(ui.RARITY_LAST_VAL)
	arg_8_0.atkType = idlertable.new({
		[game.ATTRDEF_ENUM_TABLE.damage] = true,
		[game.ATTRDEF_ENUM_TABLE.specialDamage] = true
	})
	arg_8_0.rarityDatas = {}
	arg_8_0.attrDatas = {}

	for iter_8_0 = 1, 5 do
		arg_8_0.attrDatas[iter_8_0] = {
			icon = ui.ATTR_ICON[iter_8_0]
		}
	end

	for iter_8_1 = 1, 6 do
		arg_8_0.rarityDatas[iter_8_1] = {
			rarity = iter_8_1
		}
	end

	arg_8_0.showAttrList = idler.new(false)
	arg_8_0.showRarityList = idler.new(false)
	arg_8_0.showfilterPanel = idler.new(false)

	idlereasy.when(arg_8_0.attr1, function(arg_9_0, arg_9_1)
		local var_9_0, var_9_1 = var_0_1(arg_9_1)

		if var_9_1 then
			arg_8_0.attr1Btn:get("img1"):hide()
			arg_8_0.attr1Btn:get("all"):show()
		else
			arg_8_0.attr1Btn:get("img1"):show():texture(var_9_0)
			arg_8_0.attr1Btn:get("all"):hide()
		end
	end)
	idlereasy.when(arg_8_0.attr2, function(arg_10_0, arg_10_1)
		local var_10_0, var_10_1 = var_0_1(arg_10_1)

		if var_10_1 then
			arg_8_0.attr2Btn:get("img1"):hide()
			arg_8_0.attr2Btn:get("all"):show()
		else
			arg_8_0.attr2Btn:get("img1"):show():texture(var_10_0)
			arg_8_0.attr2Btn:get("all"):hide()
		end
	end)
	idlereasy.when(arg_8_0.rarity, function(arg_11_0, arg_11_1)
		local var_11_0, var_11_1 = var_0_2(arg_11_1)

		if var_11_1 then
			arg_8_0.rarityBtn:get("img1"):hide()
			arg_8_0.rarityBtn:get("all"):show()
		else
			arg_8_0.rarityBtn:get("img1"):show():texture(var_11_0)
			arg_8_0.rarityBtn:get("all"):hide()
		end
	end)
	idlereasy.when(arg_8_0.atkType, function(arg_12_0, arg_12_1)
		arg_8_0.atk1Btn:get("checkBox"):setSelectedState(arg_12_1[game.ATTRDEF_ENUM_TABLE.damage])
		arg_8_0.atk2Btn:get("checkBox"):setSelectedState(arg_12_1[game.ATTRDEF_ENUM_TABLE.specialDamage])
	end)
	bind.touch(arg_8_0, arg_8_0.selBtn, {
		methods = {
			ended = function()
				arg_8_0:onFilterClick()
			end
		}
	})
	arg_8_0:initData()
end

function var_0_0.initData(arg_14_0)
	arg_14_0.attr1:set(ui.ATTR_MAX)
	arg_14_0.attr2:set(ui.ATTR_MAX)
	arg_14_0.rarity:set(ui.RARITY_LAST_VAL)
	arg_14_0.atkType:set({
		[game.ATTRDEF_ENUM_TABLE.damage] = true,
		[game.ATTRDEF_ENUM_TABLE.specialDamage] = true
	}, true)
	arg_14_0:onSureClick()
end

function var_0_0.onClosePanel(arg_15_0)
	itertools.invoke({
		arg_15_0.showAttrList,
		arg_15_0.showRarityList,
		arg_15_0.showfilterPanel
	}, "set", false)
end

function var_0_0.onAttrItemClick(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_0.attr12Choose == 1 then
		arg_16_0.attr1:set(arg_16_2.k)
	else
		arg_16_0.attr2:set(arg_16_2.k)
	end

	arg_16_0.showAttrList:set(false)
end

function var_0_0.onSelectedAll(arg_17_0)
	arg_17_0.rarity:set(table.maxn(var_0_2()))
	arg_17_0.showRarityList:set(false)
end

function var_0_0.onRarityItemClick(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0.rarity:set(arg_18_3.rarity)
	arg_18_0.showRarityList:set(false)
end

function var_0_0.onAttr1Click(arg_19_0)
	arg_19_0.showRarityList:set(false)

	if not arg_19_0.showAttrList:read() then
		arg_19_0.attr12Choose = 1

		arg_19_0.attr1Btn:get("img2"):scaleY(-0.8)
		arg_19_0.showAttrList:set(true)

		return
	end

	arg_19_0.attr1Btn:get("img2"):scaleY(0.8)
	arg_19_0.showAttrList:set(false)
end

function var_0_0.onAttr2Click(arg_20_0)
	arg_20_0.showRarityList:set(false)

	if not arg_20_0.showAttrList:read() then
		arg_20_0.attr12Choose = 2

		arg_20_0.attr2Btn:get("img2"):scaleY(-0.8)
		arg_20_0.showAttrList:set(true)

		return
	end

	arg_20_0.attr2Btn:get("img2"):scaleY(0.8)
	arg_20_0.showAttrList:set(false)
end

function var_0_0.onRarityClick(arg_21_0)
	arg_21_0.showAttrList:set(false)

	if not arg_21_0.showRarityList:read() then
		arg_21_0.rarityBtn:get("img2"):scaleY(-0.8)
	else
		arg_21_0.rarityBtn:get("img2"):scaleY(0.8)
	end

	arg_21_0.showRarityList:modify(function(arg_22_0)
		return true, not arg_22_0
	end)
end

function var_0_0.onCancleClick(arg_23_0)
	arg_23_0:onClosePanel()
end

function var_0_0.onSureClick(arg_24_0)
	arg_24_0.cb(arg_24_0.attr1:read(), arg_24_0.attr2:read(), arg_24_0.rarity:read(), arg_24_0.atkType:read())
	arg_24_0:onClosePanel()
end

function var_0_0.onFilterClick(arg_25_0)
	if arg_25_0.showIdler then
		arg_25_0.showIdler:set(false)
	end

	itertools.invoke({
		arg_25_0.showAttrList,
		arg_25_0.showRarityList
	}, "set", false)
	arg_25_0.showfilterPanel:modify(function(arg_26_0)
		return true, not arg_26_0
	end)
end

function var_0_0.onAtkClick(arg_27_0, arg_27_1)
	arg_27_0.atkType:modify(function(arg_28_0)
		arg_28_0[arg_27_1] = not arg_28_0[arg_27_1]

		return true, arg_28_0
	end)
end

return var_0_0
