local var_0_0 = 0.08
local var_0_1 = require("app.views.city.card.helditem.tools")

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_0.attrNumRates
	local var_1_1 = csv.held_item.advance_attrs[arg_1_2]
	local var_1_2 = var_1_1["attrNum" .. arg_1_0.advanceAttrSeq]
	local var_1_3 = var_1_1["attrRate" .. arg_1_0.advanceAttrSeq]
	local var_1_4 = csv.held_item.level_attrs[arg_1_1]["attrNum" .. arg_1_0.strengthAttrSeq]

	return var_1_0[arg_1_3] * var_1_3[arg_1_3] * (var_1_4[arg_1_3] + var_1_2[arg_1_3])
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	bind.extend(arg_2_0, arg_2_1, {
		class = "icon_key",
		props = {
			data = {
				key = arg_2_2.csvId,
				csvId = arg_2_2.csvId,
				dbId = arg_2_2.dbId
			},
			specialKey = {
				lv = arg_2_2.lv
			},
			onNode = function(arg_3_0)
				arg_3_0:setTouchEnabled(false)
			end
		}
	})
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:show()

	local var_4_0 = csv.held_item.items[arg_4_1]
	local var_4_1 = {
		cfg = var_4_0
	}

	var_4_0.advance = arg_4_2
	var_4_0.csvId = arg_4_1

	local var_4_2 = "#C0x5B545B#"
	local var_4_3 = var_0_1.getStrinigByData(2, var_4_1, var_4_2)
	local var_4_4 = table.concat({
		var_4_3
	}, "\n")
	local var_4_5 = rich.createByStr(var_4_2 .. var_4_4, 40, nil):anchorPoint(0, 0.5):xy(220, 23):addTo(arg_4_0, 10, "attrText")

	var_4_5:formatText()
	adapt.oneLinePos(var_4_5, arg_4_0:get("arrow"), cc.p(8, 2), "left")
end

local var_0_5 = class("HeldItemCommonSuccessView", cc.load("mvc").ViewBase)

var_0_5.RESOURCE_FILENAME = "held_item_common_success.json"
var_0_5.RESOURCE_BINDING = {
	centerPos = "centerPos",
	["centerPanel.subList"] = "subList",
	item = "item",
	titlePos = "titlePos",
	centerPanel = "centerPanel",
	descNote = "descNote",
	bg = {
		binds = {
			event = "click",
			method = bindHelper.self("onClose")
		}
	},
	["centerPanel.list"] = {
		varname = "list",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 6,
				columnSize = 2,
				data = bindHelper.self("attrDatas"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				onCell = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
					local var_5_0 = arg_5_1:multiget("note", "txt1", "txt2", "icon", "iconArrow")

					var_5_0.note:setString(arg_5_3.note)
					var_5_0.txt1:setString(math.floor(arg_5_3.txt1))
					var_5_0.txt2:setString(math.floor(arg_5_3.txt2))
					var_5_0.icon:loadTexture(arg_5_3.icon)

					local var_5_1 = arg_5_0:getIdx(arg_5_2).k
					local var_5_2 = var_0_0 * (3 + var_5_1)

					uiEasy.setExecuteSequence({
						var_5_0.icon,
						var_5_0.note
					}, {
						delayTime = var_5_2
					})
					uiEasy.setExecuteSequence(var_5_0.txt1, {
						delayTime = var_5_2 + var_0_0
					})
					uiEasy.setExecuteSequence(var_5_0.iconArrow, {
						delayTime = var_5_2 + var_0_0 * 2
					})
					uiEasy.setExecuteSequence(var_5_0.txt2, {
						delayTime = var_5_2 + var_0_0 * 3
					})
				end
			}
		}
	}
}

function var_0_5.onCreate(arg_6_0, arg_6_1)
	arg_6_0.dbId = arg_6_1.dbId

	arg_6_0:initModel()

	local var_6_0 = csv.held_item.items[arg_6_0.heldItemId]

	arg_6_0.attrDatas = idlers.new()

	local var_6_1 = {}

	for iter_6_0, iter_6_1 in ipairs(var_6_0.attrTypes) do
		local var_6_2 = {}
		local var_6_3 = game.ATTRDEF_TABLE[iter_6_1]

		var_6_2.note = gLanguageCsv["attr" .. string.caption(var_6_3)]
		var_6_2.txt1 = var_0_2(var_6_0, arg_6_1.level, arg_6_1.advance, iter_6_0)
		var_6_2.txt2 = var_0_2(var_6_0, arg_6_0.newLevel, arg_6_0.newAdvance, iter_6_0)
		var_6_2.icon = ui.ATTR_LOGO[var_6_3]

		table.insert(var_6_1, var_6_2)
	end

	arg_6_0.attrDatas:update(var_6_1)
	arg_6_0:setCenterPanel(var_6_0, arg_6_1.level, arg_6_1.advance, 1, arg_6_1.typ)
	arg_6_0:setCenterPanel(var_6_0, arg_6_0.newLevel, arg_6_0.newAdvance, 2, arg_6_1.typ)

	local var_6_4 = "xjiesuan_qianghuazi"

	if arg_6_1.typ == "advance" then
		var_6_4 = "xjiesuan_tupozi"
	end

	uiEasy.setTitleEffect(arg_6_0.centerPos, var_6_4)
	arg_6_0.descNote:hide()

	if var_6_0.effect2LevelAdvSeq[1] == arg_6_0.newAdvance and arg_6_1.typ == "advance" then
		arg_6_0.descNote:show()
		var_0_4(arg_6_0.descNote, arg_6_0.heldItemId, arg_6_0.newAdvance)
		arg_6_0.centerPanel:y(arg_6_0.centerPos:y() + 40)
		uiEasy.setExecuteSequence(arg_6_0.descNote, {
			delayTime = var_0_0 * 5
		})
	end

	arg_6_0:setFight(arg_6_1.fight, arg_6_1.cardDbId)
end

function var_0_5.initModel(arg_7_0)
	local var_7_0 = gGameModel.held_items:find(arg_7_0.dbId):read("held_item_id", "advance", "level", "card_db_id")

	arg_7_0.heldItemId = var_7_0.held_item_id
	arg_7_0.newLevel = var_7_0.level
	arg_7_0.newAdvance = var_7_0.advance
	arg_7_0.cardDbId = var_7_0.card_db_id
end

function var_0_5.setCenterPanel(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_0.centerPanel:multiget("card1", "card2", "name1", "name2", "level1", "level2", "cardImg")
	local var_8_1 = var_8_0["card" .. arg_8_4]
	local var_8_2 = var_8_0["name" .. arg_8_4]
	local var_8_3 = var_8_0["level" .. arg_8_4]
	local var_8_4 = "Lv" .. arg_8_2

	if arg_8_5 == "advance" then
		var_8_4 = arg_8_3 > 0 and "+" .. arg_8_3 or ""
	end

	var_8_3:text(var_8_4)
	var_8_2:text(arg_8_1.name)
	text.addEffect(var_8_2, {
		color = ui.COLORS.QUALITY[arg_8_1.quality]
	})
	text.addEffect(var_8_3, {
		color = ui.COLORS.QUALITY[arg_8_1.quality]
	})
	adapt.oneLineCenterPos(cc.p(var_8_1:x(), var_8_2:y()), {
		var_8_2,
		var_8_3
	}, cc.p(8, 0))
	var_0_3(arg_8_0, var_8_1, {
		csvId = arg_8_0.heldItemId,
		isExc = csvSize(arg_8_1.exclusiveCards) > 0,
		lv = arg_8_2,
		dbId = arg_8_0.dbId
	})

	local var_8_5 = var_0_0 * (arg_8_4 == 1 and 0.1 or 2)

	uiEasy.setExecuteSequence(var_8_1, {
		delayTime = var_8_5
	})
	uiEasy.setExecuteSequence(var_8_2, {
		delayTime = var_8_5
	})
	uiEasy.setExecuteSequence(var_8_3, {
		delayTime = var_8_5
	})

	if arg_8_4 == 2 then
		uiEasy.setExecuteSequence({
			var_8_0.cardImg
		}, {
			delayTime = var_0_0
		})
	end
end

function var_0_5.setFight(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.centerPanel:multiget("fight1", "fight2", "fightBg")

	if arg_9_2 == nil then
		itertools.invoke({
			var_9_0.fight1,
			var_9_0.fight2,
			var_9_0.fightBg
		}, "hide")
	else
		local var_9_1 = gGameModel.cards:find(arg_9_2):read("fighting_point")

		var_9_0.fight1:text(arg_9_1)
		var_9_0.fight2:text(var_9_1)
		uiEasy.setExecuteSequence(var_9_0.fightBg, {
			delayTime = var_0_0 * 3
		})
		uiEasy.setExecuteSequence(var_9_0.fight1, {
			delayTime = var_0_0 * 4
		})
		uiEasy.setExecuteSequence(var_9_0.fight2, {
			delayTime = var_0_0 * 5
		})
	end
end

return var_0_5
