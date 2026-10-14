local var_0_0 = require("app.views.city.card.helditem.tools")
local var_0_1 = class("BagHandbookView", Dialog)
local var_0_2 = "city/card/helditem/bag/"
local var_0_3 = {
	"btn_red_1.png",
	"btn_orange_1.png",
	"btn_purple_1.png",
	"btn_blue_1.png",
	"btn_green_1.png"
}
local var_0_4 = {
	"btn_red.png",
	"btn_orange.png",
	"btn_purple.png",
	"btn_blue.png",
	"btn_green.png"
}
local var_0_5 = {
	"label_red.png",
	"label_orange.png",
	"label_purple.png",
	"label_blue.png",
	"label_green.png"
}
local var_0_6 = {
	1,
	5,
	4,
	3,
	2
}

for iter_0_0, iter_0_1 in ipairs(var_0_6) do
	var_0_6[iter_0_1] = iter_0_0
end

var_0_1.RESOURCE_FILENAME = "held_item_bag_handbook.json"
var_0_1.RESOURCE_BINDING = {
	["right.item"] = "rightItem",
	innweList = "innweList",
	["right.center.list"] = "rightCenterList",
	["right.center"] = "rightCenter",
	icon = "icon",
	item1 = "item1",
	item = "item",
	attrInnerList = "attrInnerList",
	left = "left",
	["right.rightInfo"] = "rightInfo",
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					size = 3,
					color = ui.NEWCOLORS.OUTLINE.YELLOW1
				}
			}
		}
	},
	right = {
		varname = "rightPanel",
		binds = {
			event = "visible",
			idler = bindHelper.self("isVisibleRight")
		}
	},
	["left.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				leftPadding = 10,
				asyncPreload = 20,
				topPadding = 10,
				columnSize = 4,
				data = bindHelper.self("heldItems"),
				item = bindHelper.self("innweList"),
				cell = bindHelper.self("item"),
				itemAction = {
					isAction = true,
					alwaysShow = true
				},
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					arg_1_1:get("imgSel"):visible(arg_1_3.isSel)

					local var_1_0 = csv.held_item.items
					local var_1_1 = csv.held_item.effect

					bind.extend(arg_1_0, arg_1_1, {
						class = "icon_key",
						props = {
							noListener = true,
							data = {
								key = arg_1_3.csvId
							},
							onNode = function(arg_2_0)
								local var_2_0 = arg_1_0:getIdx(arg_1_2)

								bind.click(arg_1_0, arg_2_0, {
									method = functools.partial(arg_1_0.clickCell, var_2_0, arg_1_3)
								})
							end
						}
					})
				end
			},
			handlers = {
				clickCell = bindHelper.self("onItemClick")
			}
		}
	},
	["right.textName"] = {
		varname = "heldItemName",
		binds = {
			event = "text",
			idler = bindHelper.self("itemName")
		}
	},
	["right.list"] = {
		varname = "rightlist",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("attrs"),
				item = bindHelper.self("attrInnerList"),
				cell = bindHelper.self("item1"),
				onCell = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					local var_3_0 = game.ATTRDEF_TABLE[arg_3_3.attr]
					local var_3_1 = gLanguageCsv["attr" .. string.caption(var_3_0)]
					local var_3_2 = ui.ATTR_LOGO[var_3_0]

					arg_3_1:get("imgIcon"):texture(var_3_2)
					arg_3_1:get("textAttrName"):text(var_3_1)
					arg_3_1:get("textAttrNum"):text("+" .. arg_3_3.val)
					adapt.oneLinePos(arg_3_1:get("textAttrName"), arg_3_1:get("textAttrNum"), cc.p(10, 0), "left")
				end
			}
		}
	},
	["right.center.btnInfo"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onInfoClick")
			}
		}
	},
	["right.rightInfo.rightIcon1"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_4_0)
					arg_4_0:selectQuality(1)
				end)
			}
		}
	},
	["right.rightInfo.rightIcon2"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_5_0)
					arg_5_0:selectQuality(5)
				end)
			}
		}
	},
	["right.rightInfo.rightIcon3"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_6_0)
					arg_6_0:selectQuality(4)
				end)
			}
		}
	},
	["right.rightInfo.rightIcon4"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_7_0)
					arg_7_0:selectQuality(3)
				end)
			}
		}
	},
	["right.rightInfo.rightIcon5"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.defer(function(arg_8_0)
					arg_8_0:selectQuality(2)
				end)
			}
		}
	}
}

function var_0_1.onCreate(arg_9_0, arg_9_1)
	arg_9_0:initModel()

	arg_9_0.cardDbId = arg_9_1 or arg_9_0.cards:read()[1]
	arg_9_0.isVisibleRight = idler.new(false)
	arg_9_0.heldItems = idlers.newWithMap({})
	arg_9_0.showLeftSelected = idler.new(1)
	arg_9_0.showRightSelected = idler.new(1)

	arg_9_0.attrInnerList:setScrollBarEnabled(false)

	arg_9_0.itemName = idler.new("")
	arg_9_0.curBtnState = idler.new(1)
	arg_9_0.attrs = idlers.newWithMap({})

	idlereasy.when(arg_9_0.isVisibleRight, function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = display.sizeInView.width / 2
		local var_10_1 = arg_9_0.left:size().width
		local var_10_2 = arg_10_1 and var_10_0 - var_10_1 / 2 - 17 or var_10_0

		arg_9_0.left:x(var_10_2)
	end)

	local var_9_0 = csv.held_item.items

	local function var_9_1(arg_11_0, arg_11_1)
		local var_11_0 = var_9_0[arg_11_0.csvId]
		local var_11_1 = var_9_0[arg_11_1.csvId]

		if var_11_0.quality ~= var_11_1.quality then
			return var_11_0.quality > var_11_1.quality
		end

		if arg_11_0.isExc ~= arg_11_1.isExc then
			return arg_11_0.isExc
		end

		if arg_11_0.csvId ~= arg_11_1.csvId then
			return arg_11_0.csvId < arg_11_1.csvId
		end

		return arg_11_0.num < arg_11_1.num
	end

	idlereasy.any({
		arg_9_0.showLeftSelected,
		arg_9_0.showRightSelected,
		arg_9_0.refreshFlag,
		arg_9_0.quality
	}, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		local var_12_0 = {}
		local var_12_1 = 0

		for iter_12_0, iter_12_1 in ipairs(arg_9_0.tableDatas) do
			var_12_1 = var_12_1 + 1

			if arg_12_4 ~= 1 then
				if var_9_0[iter_12_1.csvId].quality == arg_12_4 then
					table.insert(var_12_0, clone(iter_12_1))
				end
			else
				table.insert(var_12_0, clone(iter_12_1))
			end
		end

		table.sort(var_12_0, function(arg_13_0, arg_13_1)
			if arg_12_2 == 1 then
				return var_9_1(arg_13_0, arg_13_1)
			end
		end)

		var_12_0[1].isSel = true

		arg_9_0.heldItems:update(var_12_0)
		arg_9_0.selIdx:modify(function(arg_14_0)
			return true, 1
		end, true)
		arg_9_0.isVisibleRight:set(var_12_1 > 0)
	end)
	arg_9_0.selIdx:addListener(function(arg_15_0, arg_15_1)
		if arg_15_1 ~= arg_15_0 then
			if arg_15_1 ~= -1 and arg_9_0.heldItems:atproxy(arg_15_1) and arg_9_0.heldItems:atproxy(arg_15_1).isSel ~= false then
				arg_9_0.heldItems:atproxy(arg_15_1).isSel = false
			end

			if arg_9_0.heldItems:atproxy(arg_15_0).isSel ~= true then
				arg_9_0.heldItems:atproxy(arg_15_0).isSel = true
			end
		end

		local var_15_0 = csv.held_item.items
		local var_15_1 = csv.held_item.effect
		local var_15_2 = arg_9_0.heldItems:atproxy(arg_15_0)
		local var_15_3 = 1
		local var_15_4 = gLanguageCsv.spaceEquip
		local var_15_5 = var_15_2.cfg.name

		if var_15_2.advance > 0 then
			var_15_5 = string.format("%s +%d", var_15_2.cfg.name, var_15_2.advance)
		end

		arg_9_0.itemName:set(var_15_5)
		text.addEffect(arg_9_0.heldItemName, {
			color = var_15_2.cfg.quality == 1 and ui.COLORS.NORMAL.DEFAULT or ui.COLORS.QUALITY[var_15_2.cfg.quality]
		})
		bind.extend(arg_9_0, arg_9_0.rightItem, {
			class = "icon_key",
			props = {
				noListener = true,
				data = {
					key = var_15_2.csvId
				}
			}
		})

		local var_15_6 = var_15_2.cfg.attrTypes
		local var_15_7 = var_15_2.cfg.attrNumRates
		local var_15_8 = csv.held_item.advance_attrs[var_15_2.advance]
		local var_15_9 = var_15_8["attrNum" .. var_15_2.cfg.advanceAttrSeq]
		local var_15_10 = var_15_8["attrRate" .. var_15_2.cfg.advanceAttrSeq]
		local var_15_11 = csv.held_item.level_attrs[var_15_2.lv]["attrNum" .. var_15_2.cfg.strengthAttrSeq]
		local var_15_12 = {}

		for iter_15_0, iter_15_1 in ipairs(var_15_6) do
			local var_15_13 = {
				attr = iter_15_1,
				val = math.floor(var_15_7[iter_15_0] * var_15_10[iter_15_0] * (var_15_11[iter_15_0] + var_15_9[iter_15_0]))
			}

			table.insert(var_15_12, var_15_13)
		end

		arg_9_0.attrs:update(var_15_12)

		local var_15_14 = {}
		local var_15_15 = "#C0x62440e#"

		for iter_15_2 = 1, 100 do
			local var_15_16 = var_15_2.cfg[string.format("effect%dLevelAdvSeq", iter_15_2)]
			local var_15_17 = 0

			if not var_15_2.cfg["effect" .. iter_15_2] or var_15_2.cfg["effect" .. iter_15_2] == 0 or not var_15_16 or var_15_17 < var_15_16[1] then
				break
			end

			local var_15_18 = var_0_0.getStrinigByData(iter_15_2, var_15_2, var_15_15)

			table.insert(var_15_14, var_15_18)
		end

		local var_15_19 = var_15_15 .. table.concat(var_15_14, "\n")
		local var_15_20 = beauty.textScroll({
			isRich = true,
			fontSize = 40,
			list = arg_9_0.rightCenterList,
			strs = var_15_19
		})
	end)
	arg_9_0.quality:addListener(function(arg_16_0, arg_16_1)
		if arg_16_0 ~= arg_16_1 then
			arg_16_0 = var_0_6[arg_16_0]
			arg_16_1 = var_0_6[arg_16_1]

			arg_9_0.icon:texture(var_0_2 .. var_0_5[arg_16_0])
			arg_9_0.rightInfo:get("rightIcon" .. arg_16_0):texture(var_0_2 .. var_0_3[arg_16_0])
			arg_9_0.rightInfo:get("rightIcon" .. arg_16_0):get("txt"):visible(true)
			arg_9_0.rightInfo:get("rightIcon" .. arg_16_0):get("txt1"):visible(false)
			arg_9_0.rightInfo:get("rightIcon" .. arg_16_1):texture(var_0_2 .. var_0_4[arg_16_1])
			arg_9_0.rightInfo:get("rightIcon" .. arg_16_1):get("txt"):visible(false)
			arg_9_0.rightInfo:get("rightIcon" .. arg_16_1):get("txt1"):visible(true)
		else
			for iter_16_0 = 2, 5 do
				arg_9_0.rightInfo:get("rightIcon" .. iter_16_0):get("txt"):visible(false)
			end

			arg_9_0.rightInfo:get("rightIcon1"):get("txt1"):visible(false)
		end
	end)
	Dialog.onCreate(arg_9_0)
end

function var_0_1.refreshData(arg_17_0)
	arg_17_0.tableDatas = {}

	local var_17_0 = {}
	local var_17_1 = {}
	local var_17_2 = csv.held_item.items

	for iter_17_0, iter_17_1 in orderCsvPairs(var_17_2) do
		if iter_17_1.itemsShow then
			local var_17_3 = {
				cfg = iter_17_1,
				csvId = iter_17_0
			}

			var_17_3.num = 1
			var_17_3.isSel = false
			var_17_3.lv = 1
			var_17_3.cardDbID = iter_17_0
			var_17_3.advance = 0

			local var_17_4, var_17_5 = var_0_0.isExclusive(var_17_3)

			var_17_3.isExc = var_17_5

			table.insert(var_17_1, var_17_3)
		end
	end

	arg_17_0.tableDatas = var_17_1

	arg_17_0.refreshFlag:set(true, true)
end

function var_0_1.initModel(arg_18_0)
	arg_18_0.quality = idler.new(1)
	arg_18_0.qualityTextNum = idler.new(1)
	arg_18_0.myHeldItem = gGameModel.role:getIdler("held_items")
	arg_18_0.cards = gGameModel.role:getIdler("cards")
	arg_18_0.refreshFlag = idler.new(false)
	arg_18_0.selIdx = idler.new(1)

	arg_18_0:refreshData()
	arg_18_0.item:visible(false)
	arg_18_0.item1:visible(false)
end

function var_0_1.onInfoClick(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.heldItems:atproxy(arg_19_0.selIdx:read())
	local var_19_1, var_19_2 = arg_19_1:getPosition()
	local var_19_3 = arg_19_1:getParent():convertToWorldSpace(cc.p(var_19_1, var_19_2))
	local var_19_4 = {
		offy = 120,
		offx = 256,
		data = var_19_0,
		target = arg_19_1,
		x = var_19_3.x,
		y = var_19_3.y
	}

	gGameUI:stackUI("city.card.helditem.advance_detail", nil, nil, var_19_4)
end

function var_0_1.onItemClick(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0.selIdx:set(arg_20_2.k)
	arg_20_0.isVisibleRight:set(true)
end

function var_0_1.selectQuality(arg_21_0, arg_21_1)
	arg_21_0.quality:set(arg_21_1)
end

function var_0_1.onClose(arg_22_0)
	local var_22_0 = gGameModel.cards:find(arg_22_0.cardDbId):read("held_item")

	Dialog.onClose(arg_22_0)
end

return var_0_1
