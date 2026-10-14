local var_0_0 = require("app.views.city.card.helditem.tools")
local var_0_1 = class("HeldItemDetailView", cc.load("mvc").ViewBase)

var_0_1.RESOURCE_FILENAME = "common_helditem_detail.json"
var_0_1.RESOURCE_BINDING = {
	item = "item",
	["baseNode.imgBg"] = "bgImg",
	item1 = "item1",
	baseNode = "baseNode",
	["baseNode.center"] = "center",
	["baseNode.center.list"] = "centerList",
	innerList = "innerList",
	["baseNode.item"] = {
		binds = {
			event = "extend",
			class = "icon_key",
			props = {
				noListener = true,
				data = bindHelper.self("data")
			}
		}
	},
	["baseNode.textName"] = {
		varname = "textName",
		binds = {
			event = "text",
			idler = bindHelper.self("nameStr")
		}
	},
	["baseNode.textLv"] = {
		binds = {
			event = "text",
			idler = bindHelper.self("level")
		}
	},
	["baseNode.down"] = {
		binds = {
			event = "visible",
			idler = bindHelper.self("hasShowCards")
		}
	},
	["baseNode.top.list"] = {
		varname = "attrList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				columnSize = 2,
				data = bindHelper.self("attrs"),
				item = bindHelper.self("innerList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
					local var_1_0 = game.ATTRDEF_TABLE[arg_1_3.attr]
					local var_1_1 = gLanguageCsv["attr" .. string.caption(var_1_0)] .. ": "
					local var_1_2 = ui.ATTR_LOGO[var_1_0]

					arg_1_1:get("imgIcon"):texture(var_1_2)
					arg_1_1:get("textName"):text(var_1_1)
					arg_1_1:get("textVal"):text("+" .. arg_1_3.val)
					adapt.oneLinePos(arg_1_1:get("textName"), arg_1_1:get("textVal"), cc.p(10, 0), "left")
				end
			}
		}
	},
	["baseNode.down.list"] = {
		varname = "downlist",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("tabCards"),
				item = bindHelper.self("item1"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					bind.extend(arg_2_0, arg_2_1, {
						class = "card_icon",
						props = {
							rarity = arg_2_3.rarity,
							cardId = arg_2_3.card.id,
							onNode = function(arg_3_0)
								arg_3_0:scale(0.9)
								arg_3_0:alignCenter(arg_2_1:size())
							end
						}
					})
				end
			}
		}
	}
}

function var_0_1.onCreate(arg_4_0, arg_4_1)
	arg_4_0:getResourceNode():setTouchEnabled(false)

	local var_4_0 = arg_4_1.key
	local var_4_1 = arg_4_1.num
	local var_4_2 = arg_4_1.dbId

	arg_4_0.data = {
		key = var_4_0,
		dbId = var_4_2
	}

	local var_4_3 = arg_4_1.level or 1
	local var_4_4 = arg_4_1.advance or 0

	if var_4_2 then
		local var_4_5 = gGameModel.held_items:find(var_4_2)

		var_4_3 = var_4_5:read("level")
		var_4_4 = var_4_5:read("advance")
	end

	local var_4_6 = csv.held_item.items[var_4_0]
	local var_4_7 = var_4_6.name

	if var_4_4 > 0 then
		var_4_7 = var_4_7 .. " +" .. var_4_4
	end

	arg_4_0.nameStr = idler.new(var_4_7)

	text.addEffect(arg_4_0.textName, {
		color = ui.COLORS.QUALITY[var_4_6.quality]
	})

	arg_4_0.level = idler.new("Lv" .. var_4_3)
	arg_4_0.attrs = idlers.newWithMap({})
	arg_4_0.tabCards = idlers.newWithMap({})

	local var_4_8 = var_4_6.attrTypes
	local var_4_9 = var_4_6.attrNumRates
	local var_4_10 = csv.held_item.advance_attrs[var_4_4]
	local var_4_11 = var_4_10["attrNum" .. var_4_6.advanceAttrSeq]
	local var_4_12 = var_4_10["attrRate" .. var_4_6.advanceAttrSeq]
	local var_4_13 = csv.held_item.level_attrs[var_4_3]["attrNum" .. var_4_6.strengthAttrSeq]
	local var_4_14 = {}

	for iter_4_0, iter_4_1 in ipairs(var_4_8) do
		local var_4_15 = {
			attr = iter_4_1,
			val = math.floor(var_4_9[iter_4_0] * var_4_12[iter_4_0] * (var_4_13[iter_4_0] + var_4_11[iter_4_0]))
		}

		table.insert(var_4_14, var_4_15)
	end

	arg_4_0.attrs:update(var_4_14)

	local var_4_16 = csv.held_item.effect[var_4_6.effect1]
	local var_4_17 = {}

	for iter_4_2, iter_4_3 in csvMapPairs(var_4_16.exclusiveCards) do
		for iter_4_4, iter_4_5 in pairs(gCardsCsv[iter_4_3]) do
			for iter_4_6, iter_4_7 in pairs(iter_4_5) do
				local var_4_18 = csv.unit[iter_4_7.unitID]

				table.insert(var_4_17, {
					card = iter_4_7,
					rarity = var_4_18.rarity
				})
			end
		end
	end

	arg_4_0.tabCards:update(var_4_17)

	local var_4_19 = #var_4_17 > 0

	arg_4_0.hasShowCards = idler.new(var_4_19)

	local var_4_20 = {}
	local var_4_21 = "#C0xFFFFFF#"

	for iter_4_8 = 1, 100 do
		local var_4_22 = var_4_6[string.format("effect%dLevelAdvSeq", iter_4_8)]

		if not var_4_6["effect" .. iter_4_8] or var_4_6["effect" .. iter_4_8] == 0 or not var_4_22 or var_4_4 < var_4_22[1] then
			break
		end

		local var_4_23 = {
			cfg = var_4_6,
			advance = var_4_4,
			csvId = var_4_0
		}
		local var_4_24 = var_0_0.getStrinigByData(iter_4_8, var_4_23, var_4_21)

		table.insert(var_4_20, var_4_24)
	end

	local var_4_25 = var_4_21 .. table.concat(var_4_20, "\n")

	arg_4_0.descList = beauty.textScroll({
		isRich = true,
		fontSize = 40,
		list = arg_4_0.centerList,
		strs = var_4_25
	})

	local var_4_26 = arg_4_0.baseNode:size()
	local var_4_27 = arg_4_0.bgImg:size()
	local var_4_28 = arg_4_0.baseNode:getChildren()

	if not var_4_19 then
		local var_4_29 = 0

		for iter_4_9, iter_4_10 in ipairs(arg_4_0.centerList:getChildren()) do
			var_4_29 = var_4_29 + iter_4_10:size().height
		end

		local var_4_30 = 275
		local var_4_31 = arg_4_0.centerList:size().height

		if var_4_29 < var_4_31 then
			var_4_30 = 275 + var_4_31 - var_4_29
		end

		arg_4_0.bgImg:size(var_4_27.width, var_4_27.height - var_4_30)
		arg_4_0.baseNode:size(var_4_26.width, var_4_26.height - var_4_30)

		for iter_4_11, iter_4_12 in ipairs(var_4_28) do
			iter_4_12:y(iter_4_12:y() - var_4_30)
		end

		arg_4_0.bgImg:y(arg_4_0.bgImg:y() + var_4_30 / 2)
	end
end

function var_0_1.hitTestPanel(arg_5_0, arg_5_1)
	if arg_5_0.descList:isTouchEnabled() then
		local var_5_0 = arg_5_0.baseNode
		local var_5_1 = var_5_0:box()
		local var_5_2 = var_5_0:parent():convertToWorldSpace(cc.p(var_5_1.x, var_5_1.y))

		var_5_1.x = var_5_2.x
		var_5_1.y = var_5_2.y

		return cc.rectContainsPoint(var_5_1, arg_5_1)
	end

	return false
end

return var_0_1
