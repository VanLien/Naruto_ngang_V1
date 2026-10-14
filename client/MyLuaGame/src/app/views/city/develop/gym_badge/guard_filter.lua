local var_0_0 = class("CardGuardFilterView", cc.load("mvc").ViewBase)
local var_0_1 = #ui.ATTR_ICON + 1
local var_0_2 = table.maxn(ui.RARITY_ICON) + 1

local function var_0_3(arg_1_0)
	local var_1_0 = ""

	if not arg_1_0 then
		local var_1_1 = clone(ui.ATTR_ICON)

		table.insert(var_1_1, var_1_0)

		return var_1_1
	end

	return ui.ATTR_ICON[arg_1_0] or var_1_0, not ui.ATTR_ICON[arg_1_0]
end

local function var_0_4(arg_2_0)
	local var_2_0 = ""

	if not arg_2_0 then
		local var_2_1 = clone(ui.RARITY_ICON)

		var_2_1[table.maxn(var_2_1) + 1] = var_2_0

		return var_2_1
	end

	return ui.RARITY_ICON[arg_2_0] or var_2_0, not ui.RARITY_ICON[arg_2_0]
end

var_0_0.RESOURCE_FILENAME = "gym_badge_filter.json"
var_0_0.RESOURCE_BINDING = {
	filterBtn = "filterBtn",
	["filterBtn.rarityListPanel.item"] = "rarityItem",
	["filterBtn.rarityListPanel.subList"] = "raritySubList",
	["filterBtn.attrListPanel.subList"] = "attrSubList",
	["filterBtn.attrListPanel.item"] = "attrItem",
	["filterBtn.btn"] = {
		varname = "selBtn",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onFilterClick")
			}
		}
	},
	["filterBtn.btn.title"] = {
		varname = "btnTitle",
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 2,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["filterBtn.attrListPanel.allBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["filterBtn.rarityListPanel.allBtn.title"] = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
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
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:get("icon"):texture(arg_3_3.icon)

					local var_3_0 = arg_3_0:getIdx(arg_3_2)

					arg_3_1:onClick(functools.partial(arg_3_0.itemClick, var_3_0, arg_3_3))
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
				ended = bindHelper.defer(function(arg_4_0)
					return arg_4_0:onAttrItemClick(nil, {
						k = var_0_1
					})
				end)
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
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = var_0_4(arg_5_3.rarity)

					arg_5_1:get("icon"):texture(var_5_0)
					arg_5_1:onClick(functools.partial(arg_5_0.itemClick, arg_5_0:getIdx(arg_5_2), arg_5_3))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onRarityItemClick")
			}
		}
	}
}

function var_0_0.onCreate(arg_6_0, arg_6_1)
	arg_6_0.cb = arg_6_1.cb

	if arg_6_1.showIdler then
		arg_6_0.showIdler = arg_6_1.showIdler()
	end

	local var_6_0 = arg_6_1.others or {}
	local var_6_1 = var_6_0.width
	local var_6_2 = var_6_0.height
	local var_6_3 = var_6_0.x
	local var_6_4 = var_6_0.y
	local var_6_5 = var_6_0.panelOrder or false

	arg_6_0.selBtn:xy(250, -125)

	if var_6_5 then
		arg_6_0.filterPanel:xy(335, -1093)
		arg_6_0.attrListPanel:xy(348, -736)
		arg_6_0.rarityListPanel:xy(351, -652)
	end

	arg_6_0.attr12Choose = 1
	arg_6_0.attr1 = idler.new(5)
	arg_6_0.attr2 = idler.new(5)
	arg_6_0.rarity = idler.new(var_0_2)
	arg_6_0.atkType = idlertable.new({
		[game.ATTRDEF_ENUM_TABLE.damage] = true,
		[game.ATTRDEF_ENUM_TABLE.specialDamage] = true
	})

	local var_6_6 = {}
	local var_6_7 = {}

	for iter_6_0 = 1, 5 do
		table.insert(var_6_6, ui.ATTR_ICON[iter_6_0])
	end

	for iter_6_1 = 1, 5 do
		table.insert(var_6_7, ui.RARITY_DATAS[iter_6_1])
	end

	arg_6_0.attrDatas = arraytools.map(var_6_6, function(arg_7_0, arg_7_1)
		return {
			icon = arg_7_1
		}
	end)
	arg_6_0.rarityDatas = var_6_7
	arg_6_0.showAttrList = idler.new(false)
	arg_6_0.showRarityList = idler.new(false)
	arg_6_0.showfilterPanel = idler.new(false)

	idlereasy.when(arg_6_0.attr1, function(arg_8_0, arg_8_1)
		local var_8_0, var_8_1 = var_0_3(arg_8_1)

		if var_8_1 then
			arg_6_0.attr1Btn:get("img1"):hide()
			arg_6_0.attr1Btn:get("all"):show()
		else
			arg_6_0.attr1Btn:get("img1"):show():texture(var_8_0)
			arg_6_0.attr1Btn:get("all"):hide()
		end
	end)
	idlereasy.when(arg_6_0.attr2, function(arg_9_0, arg_9_1)
		local var_9_0, var_9_1 = var_0_3(arg_9_1)

		if var_9_1 then
			arg_6_0.attr2Btn:get("img1"):hide()
			arg_6_0.attr2Btn:get("all"):show()
		else
			arg_6_0.attr2Btn:get("img1"):show():texture(var_9_0)
			arg_6_0.attr2Btn:get("all"):hide()
		end
	end)
	idlereasy.when(arg_6_0.rarity, function(arg_10_0, arg_10_1)
		local var_10_0, var_10_1 = var_0_4(arg_10_1)

		if var_10_1 then
			arg_6_0.rarityBtn:get("img1"):hide()
			arg_6_0.rarityBtn:get("all"):show()
		else
			arg_6_0.rarityBtn:get("img1"):show():texture(var_10_0)
			arg_6_0.rarityBtn:get("all"):hide()
		end
	end)
	arg_6_0:initData()
end

function var_0_0.initData(arg_11_0)
	arg_11_0.attr1:set(19)
	arg_11_0.attr2:set(19)
	arg_11_0.rarity:set(var_0_2)
	arg_11_0.atkType:set({
		[game.ATTRDEF_ENUM_TABLE.damage] = true,
		[game.ATTRDEF_ENUM_TABLE.specialDamage] = true
	}, true)
	arg_11_0:onSureClick()
end

function var_0_0.onClosePanel(arg_12_0)
	itertools.invoke({
		arg_12_0.showAttrList,
		arg_12_0.showRarityList,
		arg_12_0.showfilterPanel
	}, "set", false)
end

function var_0_0.onAttrItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0.attr12Choose == 1 then
		arg_13_0.attr1:set(arg_13_2.k)
	else
		arg_13_0.attr2:set(arg_13_2.k)
	end

	arg_13_0.showAttrList:set(false)
end

function var_0_0.onSelectedAll(arg_14_0)
	arg_14_0.rarity:set(table.maxn(var_0_4()))
	arg_14_0.showRarityList:set(false)
end

function var_0_0.onRarityItemClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0.rarity:set(arg_15_3.rarity)
	arg_15_0.showRarityList:set(false)
end

function var_0_0.onAttr1Click(arg_16_0)
	arg_16_0.showRarityList:set(false)

	if not arg_16_0.showAttrList:read() then
		arg_16_0.attr12Choose = 1

		arg_16_0.showAttrList:set(true)

		return
	end

	arg_16_0.showAttrList:set(false)
end

function var_0_0.onAttr2Click(arg_17_0)
	arg_17_0.showRarityList:set(false)

	if not arg_17_0.showAttrList:read() then
		arg_17_0.attr12Choose = 2

		arg_17_0.showAttrList:set(true)

		return
	end

	arg_17_0.showAttrList:set(false)
end

function var_0_0.onRarityClick(arg_18_0)
	arg_18_0.showAttrList:set(false)
	arg_18_0.showRarityList:modify(function(arg_19_0)
		return true, not arg_19_0
	end)
end

function var_0_0.onCancleClick(arg_20_0)
	arg_20_0:onClosePanel()
end

function var_0_0.onSureClick(arg_21_0)
	arg_21_0.cb(arg_21_0.attr1:read(), arg_21_0.attr2:read(), arg_21_0.rarity:read(), arg_21_0.atkType:read())
	arg_21_0:onClosePanel()
end

function var_0_0.onFilterClick(arg_22_0)
	if arg_22_0.showIdler then
		arg_22_0.showIdler:set(false)
	end

	itertools.invoke({
		arg_22_0.showAttrList,
		arg_22_0.showRarityList
	}, "set", false)
	arg_22_0.showfilterPanel:modify(function(arg_23_0)
		return true, not arg_23_0
	end)
end

return var_0_0
