local var_0_0 = {
	"city/card/ability/panel_jctx.png",
	"city/card/ability/panel_pttx.png",
	"city/card/ability/panel_hxtx.png"
}
local var_0_1 = {
	cc.c4b(97, 145, 192, 255),
	cc.c4b(139, 92, 153, 255),
	(cc.c4b(250, 105, 74, 255))
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0:multiget("textNote", "textNum", "iconCoin")
	local var_1_1 = ui.COLORS.NORMAL.ALERT_ORANGE

	if arg_1_2 <= arg_1_1 then
		var_1_1 = ui.NEWCOLORS.BROWN1
	end

	var_1_0.textNum:text(arg_1_2)
	text.addEffect(var_1_0.textNum, {
		color = var_1_1
	})

	local var_1_2 = arg_1_0:size()

	adapt.oneLineCenterPos(cc.p(var_1_2.width / 2, var_1_2.height / 2), {
		var_1_0.textNote,
		var_1_0.textNum,
		var_1_0.iconCoin
	}, cc.p(15, 0))
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = csv.card_ability[arg_2_1]
	local var_2_1 = arg_2_0[var_2_0.position] or 0
	local var_2_2 = {}
	local var_2_3 = 0

	if var_2_1 < var_2_0.strengthMax then
		local var_2_4 = csv.card_ability_cost[var_2_1 + 1]["costItemMap" .. var_2_0.strengthSeqID]

		var_2_3 = var_2_4.gold or 0

		for iter_2_0, iter_2_1 in csvMapPairs(var_2_4) do
			if iter_2_0 ~= "gold" then
				table.insert(var_2_2, {
					key = iter_2_0,
					num = arg_2_2[iter_2_0] or 0,
					targetNum = iter_2_1
				})
			end
		end
	end

	return var_2_2, var_2_3
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = string.split(arg_3_0, "$")
	local var_3_1 = ""

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_2 = iter_3_1

		if string.find(var_3_2, "skillLevel") then
			local var_3_3 = ""

			if var_3_0[iter_3_0 + 1] and string.find(var_3_0[iter_3_0 + 1], "^%%") then
				var_3_3 = "%"
				var_3_0[iter_3_0 + 1] = string.gsub(var_3_0[iter_3_0 + 1], "^%%", "")
			end

			local var_3_4 = eval.doFormula(iter_3_1, {
				skillLevel = arg_3_1,
				math = math
			}, arg_3_0)

			if arg_3_1 == 0 then
				var_3_4 = 0
			end

			local var_3_5 = eval.doFormula(iter_3_1, {
				skillLevel = arg_3_1 + 1,
				math = math
			}, arg_3_0)

			var_3_2 = var_3_4 .. var_3_3

			local var_3_6 = var_3_5 - var_3_4 .. var_3_3

			if tonumber(var_3_4) < tonumber(var_3_5) and arg_3_1 < arg_3_2 then
				var_3_2 = string.format(gLanguageCsv.abilitySkillAddDesc, var_3_2, var_3_6)
			end

			var_3_2 = "#C0x01A001#+" .. var_3_2 .. "#C0x5B545B#"
		end

		var_3_1 = var_3_1 .. var_3_2
	end

	return var_3_1
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0[arg_4_1] or 0
	local var_4_1 = arg_4_0[arg_4_4] or 0
	local var_4_2 = ""

	if string.find(var_4_0, "%%") then
		var_4_0 = string.gsub(var_4_0, "%%", "")
		var_4_2 = "%"
	end

	if string.find(var_4_1, "%%") then
		var_4_1 = string.gsub(var_4_1, "%%", "")
		var_4_2 = "%"
	end

	local var_4_3 = dataEasy.getAttrValueString(arg_4_3, var_4_0 .. var_4_2)
	local var_4_4 = dataEasy.getAttrValueString(arg_4_3, var_4_1 - var_4_0 .. var_4_2)

	if tonumber(var_4_0) < tonumber(var_4_1) and arg_4_1 < arg_4_2 then
		var_4_3 = string.format(gLanguageCsv.abilitySkillAddDesc, var_4_3, var_4_4)
	end

	return "#C0x01A001#+" .. var_4_3 .. "#C0x5B545B#"
end

local function var_0_6(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = ""
	local var_5_1 = arg_5_3 or arg_5_2 + 1

	if arg_5_1.effectType == 2 then
		var_5_0 = string.format(arg_5_1.desc, var_0_4(csv.skill[arg_5_1.skillID].describe, arg_5_2, arg_5_1.strengthMax))
	end

	if arg_5_1.effectType == 1 then
		local var_5_2 = {}

		for iter_5_0 = 1, 2 do
			local var_5_3 = arg_5_1["attrType" .. iter_5_0]

			if var_5_3 ~= 0 then
				table.insert(var_5_2, getLanguageAttr(var_5_3))
				table.insert(var_5_2, var_0_5(arg_5_1["attrNum" .. iter_5_0], arg_5_2, arg_5_1.strengthMax, var_5_3, var_5_1))
			end
		end

		var_5_0 = string.format(arg_5_1.desc, unpack(var_5_2))
	end

	beauty.textScroll({
		isRich = true,
		verticalSpace = 10,
		list = arg_5_0,
		strs = "#C0x5B545B#" .. var_5_0
	})
end

local var_0_7 = {
	1.1,
	1,
	0.9
}
local var_0_8 = require("app.views.city.card.ability.tools")
local var_0_9 = class("CardAbilityStrengthenView", cc.load("mvc").ViewBase)

var_0_9.RESOURCE_FILENAME = "card_ability_strengthen.json"
var_0_9.RESOURCE_BINDING = {
	["panel.textLvNum"] = "textLvNum",
	["panel.descList"] = "descList",
	panel = "panel",
	["panel.imgMax"] = "imgMax",
	["panel.iconMax"] = "iconMax",
	["panel.costInfo"] = "costInfo",
	["panel.iconPanel"] = "iconPanel",
	["panel.textNum"] = "textNum",
	["panel.textCondition2"] = "textCondition2",
	["panel.iconArrow"] = "iconArrow",
	item = "item",
	["panel.textCondition1"] = "textCondition1",
	["panel.textLvMaxNum"] = "textLvMaxNum",
	["panel.textName"] = "textName",
	["panel.textNextNum"] = "textNextNum",
	["panel.btnSure"] = {
		varname = "btnStrengthen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthenClick")
			}
		}
	},
	["panel.btnSureOne"] = {
		varname = "btnStrengthenOneKey",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthenOneKeyClick")
			}
		}
	},
	["panel.btnSure.textNote"] = {
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
	["panel.btnSureOne.textNote"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			}
		}
	},
	["panel.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("cb")
			}
		}
	},
	["panel.itemList"] = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("eventDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					local var_6_0 = arg_6_3.num < arg_6_3.targetNum and 1 or 0
					local var_6_1 = arg_6_1:multiget("itemPanel", "textName")
					local var_6_2 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_6_3.key,
								num = arg_6_3.num,
								targetNum = arg_6_3.targetNum
							},
							grayState = var_6_0,
							onNode = function(arg_7_0)
								arg_7_0:setTouchEnabled(false)
							end
						}
					}

					bind.extend(arg_6_0, var_6_1.itemPanel, var_6_2)
					arg_6_1:get("mask"):visible(arg_6_3.num < arg_6_3.targetNum)
					bind.touch(arg_6_0, arg_6_1, {
						methods = {
							ended = functools.partial(arg_6_0.itemClick, arg_6_2, arg_6_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCostItemClick")
			}
		}
	}
}

function var_0_9.onCreate(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.itemList:setClippingEnabled(false)

	arg_8_0.refreshData = arg_8_1()
	arg_8_0.cb = arg_8_2

	arg_8_0:initModel()

	arg_8_0.eventDatas = idlers.new()
	arg_8_0.oneKeyLevel = idler.new(0)

	idlereasy.any({
		arg_8_0.abilities,
		arg_8_0.items,
		arg_8_0.refreshData
	}, function(arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = csv.card_ability[arg_8_0.abilityId]

		if var_9_0 then
			local var_9_1 = var_9_0.strengthMax

			arg_8_0.textName:text(var_9_0.name)
			text.addEffect(arg_8_0.textName, {
				color = var_0_1[var_9_0.type]
			})
			arg_8_0.iconPanel:get("icon"):texture(var_9_0.icon):scale(var_0_7[var_9_0.type] * 2)
			arg_8_0.iconPanel:get("iconBg"):texture(var_0_0[var_9_0.type]):scale(var_0_7[var_9_0.type])

			local var_9_2 = arg_9_1[var_9_0.position] or 0

			arg_8_0.textLvNum:text(var_9_2)

			arg_8_0.level = var_9_2

			arg_8_0.textLvMaxNum:text("/" .. var_9_1)
			adapt.oneLinePos(arg_8_0.textLvNum, arg_8_0.textLvMaxNum, cc.p(3, 0), "left")
			arg_8_0.textNum:text(var_9_2 == 0 and gLanguageCsv.notActivatedTip or "Lv" .. var_9_2):setFontSize(var_9_2 == 0 and 40 or 50)
			arg_8_0.textNextNum:text("Lv" .. math.min(var_9_2 + 1, var_9_1))

			local var_9_3 = var_9_1 <= var_9_2

			itertools.invoke({
				arg_8_0.iconMax,
				arg_8_0.imgMax
			}, var_9_3 and "show" or "hide")
			itertools.invoke({
				arg_8_0.btnStrengthen,
				arg_8_0.iconArrow,
				arg_8_0.textNextNum
			}, not var_9_3 and "show" or "hide")

			local var_9_4 = var_0_8.getConditionStr(arg_8_0.selectDbId, arg_8_0.abilityId)

			for iter_9_0 = 1, 2 do
				if var_9_4[iter_9_0] then
					arg_8_0["textCondition" .. iter_9_0]:show():text(var_9_4[iter_9_0])
				else
					arg_8_0["textCondition" .. iter_9_0]:hide()
				end
			end

			local var_9_5 = var_9_2 == 0 and gLanguageCsv.spaceActive or gLanguageCsv.spaceStrengthen

			arg_8_0.btnStrengthen:get("textNote"):text(var_9_5)
			uiEasy.setBtnShader(arg_8_0.btnStrengthen, arg_8_0.btnStrengthen:get("textNote"), #var_9_4 == 0 and 1 or 3)
			uiEasy.setBtnShader(arg_8_0.btnStrengthenOneKey, arg_8_0.btnStrengthenOneKey:get("textNote"), #var_9_4 == 0 and 1 or 3)

			if #var_9_4 == 0 then
				text.addEffect(arg_8_0.btnStrengthen:get("textNote"), {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
				text.addEffect(arg_8_0.btnStrengthenOneKey:get("textNote"), {
					outline = {
						size = 4,
						color = ui.NEWCOLORS.OUTLINE.YELLOW
					}
				})
			else
				text.deleteAllEffect(arg_8_0.btnStrengthen:get("textNote"))
				text.deleteAllEffect(arg_8_0.btnStrengthenOneKey:get("textNote"))
			end

			local var_9_6, var_9_7 = var_0_3(arg_9_1, arg_8_0.abilityId, arg_9_2)

			arg_8_0.eventDatas:update(var_9_6)

			if #var_9_6 == 1 or #var_9_6 == 2 then
				local var_9_8 = arg_8_0.item:size().width
				local var_9_9 = #var_9_6 * var_9_8 + (#var_9_6 - 1) * 120

				arg_8_0.itemList:x(953 - var_9_9 / 2)
			end

			local var_9_10 = next(var_9_4) == nil and var_9_7 > 0

			arg_8_0.costInfo:visible(var_9_10)

			if var_9_10 then
				var_0_2(arg_8_0.costInfo, arg_8_0.gold:read(), var_9_7)
			end

			var_0_6(arg_8_0.descList, var_9_0, var_9_2)

			if dataEasy.isUnlock(gUnlockCsv.potentialOneKey) and not var_9_3 then
				arg_8_0.btnStrengthen:x(673)
				arg_8_0.btnStrengthenOneKey:show()
				arg_8_0.btnStrengthenOneKey:x(1233)
				arg_8_0.costInfo:x(673)
			else
				arg_8_0.btnStrengthen:x(953)
				arg_8_0.btnStrengthenOneKey:hide()
				arg_8_0.costInfo:x(953)
			end

			arg_8_0.oneKeyLevel:set(0)
		end
	end)
	idlereasy.when(arg_8_0.oneKeyLevel, function(arg_10_0, arg_10_1)
		if arg_10_1 ~= 0 then
			local var_10_0 = csv.card_ability[arg_8_0.abilityId]

			if var_10_0 then
				var_0_6(arg_8_0.descList, var_10_0, arg_8_0.level, arg_10_1)
				arg_8_0.textNextNum:text(arg_10_1)
			end

			arg_8_0:onStrengthenClick()
		end
	end)
end

function var_0_9.initModel(arg_11_0)
	arg_11_0.gold = gGameModel.role:getIdler("gold")
	arg_11_0.items = gGameModel.role:getIdler("items")

	idlereasy.when(arg_11_0.refreshData, function(arg_12_0, arg_12_1)
		arg_11_0.selectDbId = arg_12_1.cardDbid
		arg_11_0.abilityId = arg_12_1.id

		if assertInWindows(arg_11_0.selectDbId, "val:%s", tostring(arg_11_0.selectDbId)) then
			return
		end

		local var_12_0 = gGameModel.cards:find(arg_11_0.selectDbId)

		arg_11_0.advance = idlereasy.assign(var_12_0:getIdler("advance"), arg_11_0.advance)
		arg_11_0.cardId = idlereasy.assign(var_12_0:getIdler("card_id"), arg_11_0.cardId)
		arg_11_0.cardLv = idlereasy.assign(var_12_0:getIdler("level"), arg_11_0.cardLv)
		arg_11_0.abilities = idlereasy.assign(var_12_0:getIdler("abilities"), arg_11_0.abilities)
	end)
end

function var_0_9.onCostItemClick(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_13_3.key, nil, arg_13_3.targetNum)
end

function var_0_9.onStrengthenClick(arg_14_0)
	if #var_0_8.getConditionStr(arg_14_0.selectDbId, arg_14_0.abilityId, true) > 0 then
		gGameUI:showTip(gLanguageCsv.activeSlotNotEnough)

		return
	end

	local var_14_0, var_14_1 = var_0_3(arg_14_0.abilities:read(), arg_14_0.abilityId, arg_14_0.items:read())

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if iter_14_1.num < iter_14_1.targetNum then
			gGameUI:showTip(gLanguageCsv.materialsNotEnough)

			return
		end
	end

	if var_14_1 > arg_14_0.gold:read() then
		gGameUI:showTip(gLanguageCsv.goldNotEnough)

		return
	end

	local var_14_2 = arg_14_0.abilities:read()
	local var_14_3 = csv.card_ability[arg_14_0.abilityId]
	local var_14_4 = {
		false
	}
	local var_14_5 = arg_14_0.oneKeyLevel:read() == 0 and 1 or arg_14_0.oneKeyLevel:read() - arg_14_0.level

	gGameApp:requestServerCustom("/game/card/ability/strength"):params(arg_14_0.selectDbId, var_14_3.position, var_14_5):onResponse(function(arg_15_0)
		local var_15_0 = var_14_2[var_14_3.position] == 1 and gLanguageCsv.activeSuccess or gLanguageCsv.strengthenSuccess

		gGameUI:showTip(var_15_0)
		var_0_8.setEffect({
			effectName = "effect",
			spinePath = "effect/texing_saoguang.skel",
			parent = arg_14_0.panel:get("pos")
		})

		var_14_4[1] = true
	end):wait(var_14_4):doit()
end

function var_0_9.onStrengthenOneKeyClick(arg_16_0)
	if #var_0_8.getConditionStr(arg_16_0.selectDbId, arg_16_0.abilityId, true) > 0 then
		gGameUI:showTip(gLanguageCsv.activeSlotNotEnough)

		return
	end

	local var_16_0, var_16_1 = var_0_3(arg_16_0.abilities:read(), arg_16_0.abilityId, arg_16_0.items:read())

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if iter_16_1.num < iter_16_1.targetNum then
			gGameUI:showTip(gLanguageCsv.materialsNotEnough)

			return
		end
	end

	gGameUI:stackUI("city.card.ability.strengthen_onekey", nil, {
		blackLayer = true,
		clickClose = true
	}, {
		refreshData = arg_16_0.refreshData:read(),
		oneKeyLevel = arg_16_0.oneKeyLevel
	})
end

function var_0_9.sendParams(arg_17_0)
	return arg_17_0.refreshData, arg_17_0.oneKeyLevel
end

return var_0_9
