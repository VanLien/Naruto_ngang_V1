local var_0_0 = {
	cc.c4b(97, 145, 192, 255),
	cc.c4b(139, 92, 153, 255),
	(cc.c4b(250, 105, 74, 255))
}
local var_0_1 = {
	1.1,
	1,
	0.9
}
local var_0_2 = {
	"city/card/ability/panel_jctx.png",
	"city/card/ability/panel_pttx.png",
	"city/card/ability/panel_hxtx.png"
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = csv.card_ability[arg_1_1]
	local var_1_1 = arg_1_0[var_1_0.position] or 0
	local var_1_2 = {}
	local var_1_3 = 0
	local var_1_4 = var_1_1

	for iter_1_0 = var_1_1, arg_1_3 - 1 do
		if var_1_1 < var_1_0.strengthMax then
			local var_1_5 = csv.card_ability_cost[iter_1_0 + 1]["costItemMap" .. var_1_0.strengthSeqID]

			var_1_3 = var_1_5.gold and var_1_3 + var_1_5.gold or var_1_3 + 0
			var_1_4 = var_1_4 + 1

			for iter_1_1, iter_1_2 in csvMapPairs(var_1_5) do
				if iter_1_1 ~= "gold" then
					local var_1_6 = false

					for iter_1_3, iter_1_4 in ipairs(var_1_2) do
						if iter_1_4.key == iter_1_1 then
							iter_1_4.targetNum = iter_1_4.targetNum + iter_1_2
							var_1_6 = true
						end

						if iter_1_4.num < iter_1_4.targetNum then
							return var_1_2, var_1_3, var_1_4 - 1
						end
					end

					if var_1_6 == false then
						table.insert(var_1_2, {
							key = iter_1_1,
							num = arg_1_2[iter_1_1] or 0,
							targetNum = iter_1_2
						})
					end
				end
			end
		end
	end

	return var_1_2, var_1_3, var_1_4
end

local var_0_4 = require("app.views.city.card.ability.tools")
local var_0_5 = cc.load("mvc").ViewBase
local var_0_6 = class("CardAbilityStrengthenOneKeyView", var_0_5)

var_0_6.RESOURCE_FILENAME = "card_ability_strengthen_onekey.json"
var_0_6.RESOURCE_BINDING = {
	panel = "panel",
	["panel.textLvNum"] = "textLvNum",
	["panel.iconPanel"] = "iconPanel",
	["panel.textNum"] = "textNum",
	item = "item",
	["panel.icon"] = "icon",
	["panel.numPanel"] = "numPanel",
	["panel.textLvMaxNum"] = "textLvMaxNum",
	["panel.textName"] = "textName",
	["panel.textNote1"] = "textNote1",
	["panel.btnSure"] = {
		varname = "btnStrengthen",
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onStrengthenClick")
			}
		}
	},
	["title.btnClose"] = {
		binds = {
			event = "touch",
			methods = {
				ended = bindHelper.self("onClose")
			}
		}
	},
	["title.textTitle"] = {
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
	["title.textTitle1"] = {
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
	["panel.itemList"] = {
		varname = "itemList",
		binds = {
			event = "extend",
			class = "listview",
			props = {
				data = bindHelper.self("eventDatas"),
				item = bindHelper.self("item"),
				onItem = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					local var_2_0 = arg_2_3.num < arg_2_3.targetNum and 1 or 0
					local var_2_1 = arg_2_1:multiget("itemPanel", "textName")
					local var_2_2 = {
						class = "icon_key",
						props = {
							data = {
								key = arg_2_3.key,
								num = arg_2_3.num,
								targetNum = arg_2_3.targetNum
							},
							grayState = var_2_0,
							onNode = function(arg_3_0)
								arg_3_0:setTouchEnabled(false)
							end
						}
					}

					bind.extend(arg_2_0, var_2_1.itemPanel, var_2_2)
					arg_2_1:get("mask"):visible(arg_2_3.num < arg_2_3.targetNum)
					bind.touch(arg_2_0, arg_2_1, {
						methods = {
							ended = functools.partial(arg_2_0.itemClick, arg_2_2, arg_2_3)
						}
					})
				end
			},
			handlers = {
				itemClick = bindHelper.self("onCostItemClick")
			}
		}
	},
	["panel.numPanel.subBtn"] = {
		varname = "numSubBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_4_0, arg_4_1, arg_4_2)
				return arg_4_0:onChangeNum(arg_4_1, arg_4_2, -1)
			end)
		}
	},
	["panel.numPanel.addBtn"] = {
		varname = "numAddBtn",
		binds = {
			event = "touch",
			longtouch = true,
			method = bindHelper.defer(function(arg_5_0, arg_5_1, arg_5_2)
				return arg_5_0:onChangeNum(arg_5_1, arg_5_2, 1)
			end)
		}
	}
}

function var_0_6.onCreate(arg_6_0, arg_6_1)
	arg_6_0:enableSchedule()
	arg_6_0.itemList:setClippingEnabled(false)

	arg_6_0.refreshData = arg_6_1.refreshData
	arg_6_0.oneKeyLevel = arg_6_1.oneKeyLevel

	arg_6_0:initModel()

	arg_6_0.eventDatas = idlers.new()

	local var_6_0 = csv.card_ability[arg_6_0.abilityId]

	if var_6_0 then
		local var_6_1 = var_6_0.strengthMax

		arg_6_0.textName:text(var_6_0.name)
		text.addEffect(arg_6_0.textName, {
			color = var_0_0[var_6_0.type]
		})
		arg_6_0.iconPanel:get("icon"):texture(var_6_0.icon):scale(var_0_1[var_6_0.type] * 2)
		arg_6_0.iconPanel:get("iconBg"):texture(var_0_2[var_6_0.type]):scale(var_0_1[var_6_0.type])

		local var_6_2 = arg_6_0.abilities:read()[var_6_0.position] or 0

		arg_6_0.level = var_6_2 + 1

		arg_6_0.textLvNum:text(var_6_2)
		arg_6_0.textLvMaxNum:text("/" .. var_6_1)

		local var_6_3, var_6_4, var_6_5 = var_0_3(arg_6_0.abilities:read(), arg_6_0.abilityId, arg_6_0.items:read(), var_6_1)

		arg_6_0.maxNum = var_6_5 or 20

		adapt.oneLinePos(arg_6_0.textLvNum, arg_6_0.textLvMaxNum, cc.p(3, 0), "left")

		arg_6_0.num = idler.new(arg_6_0.maxNum)

		local var_6_6 = var_0_4.getConditionStr(arg_6_0.selectDbId, arg_6_0.abilityId)

		uiEasy.setBtnShader(arg_6_0.btnStrengthen, arg_6_0.btnStrengthen:get("textNote"), #var_6_6 == 0 and 1 or 3)

		if #var_6_6 == 0 then
			text.addEffect(arg_6_0.btnStrengthen:get("textNote"), {
				color = ui.COLORS.NORMAL.YELLOW,
				outline = {
					size = 4,
					color = ui.NEWCOLORS.OUTLINE.YELLOW
				}
			})
		else
			text.deleteAllEffect(arg_6_0.btnStrengthen:get("textNote"))
		end
	end

	idlereasy.any({
		arg_6_0.abilities,
		arg_6_0.items,
		arg_6_0.num,
		arg_6_0.gold
	}, function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		arg_6_0.numPanel:get("num"):text(arg_7_3)

		local var_7_0 = csv.card_ability[arg_6_0.abilityId]

		arg_6_0.numSubBtn:setTouchEnabled(arg_7_3 > arg_6_0.level)
		arg_6_0.numAddBtn:setTouchEnabled(arg_7_3 < arg_6_0.maxNum)
		cache.setShader(arg_6_0.numSubBtn, false, arg_7_3 > arg_6_0.level and "normal" or "hsl_gray")
		cache.setShader(arg_6_0.numAddBtn, false, arg_7_3 < arg_6_0.maxNum and "normal" or "hsl_gray")

		if var_7_0 then
			local var_7_1, var_7_2 = var_0_3(arg_7_1, arg_6_0.abilityId, arg_7_2, arg_7_3)

			arg_6_0.textNum:text(var_7_2)

			local var_7_3 = arg_7_4 < var_7_2 and ui.COLORS.NORMAL.RED or ui.COLORS.NORMAL.DEFAULT

			text.addEffect(arg_6_0.textNum, {
				color = var_7_3
			})
			adapt.oneLineCenterPos(cc.p(1710, 835), {
				arg_6_0.textNote1,
				arg_6_0.textNum,
				arg_6_0.icon
			}, cc.p(15, 0))
			arg_6_0.eventDatas:update(var_7_1)

			if #var_7_1 == 1 or #var_7_1 == 2 then
				local var_7_4 = arg_6_0.item:size().width
				local var_7_5 = #var_7_1 * var_7_4 + (#var_7_1 - 1) * 120

				arg_6_0.itemList:x(arg_6_0.btnStrengthen:x() - var_7_5 / 2)
			end
		end
	end)
end

function var_0_6.initModel(arg_8_0)
	arg_8_0.gold = gGameModel.role:getIdler("gold")
	arg_8_0.items = gGameModel.role:getIdler("items")
	arg_8_0.selectDbId = arg_8_0.refreshData.cardDbid
	arg_8_0.abilityId = arg_8_0.refreshData.id

	if assertInWindows(arg_8_0.selectDbId, "val:%s", tostring(arg_8_0.selectDbId)) then
		return
	end

	local var_8_0 = gGameModel.cards:find(arg_8_0.selectDbId)

	arg_8_0.advance = idlereasy.assign(var_8_0:getIdler("advance"), arg_8_0.advance)
	arg_8_0.cardId = idlereasy.assign(var_8_0:getIdler("card_id"), arg_8_0.cardId)
	arg_8_0.cardLv = idlereasy.assign(var_8_0:getIdler("level"), arg_8_0.cardLv)
	arg_8_0.abilities = idlereasy.assign(var_8_0:getIdler("abilities"), arg_8_0.abilities)
end

function var_0_6.onCostItemClick(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	gGameUI:stackUI("common.gain_way", nil, nil, arg_9_3.key, nil, arg_9_3.targetNum)
end

function var_0_6.onStrengthenClick(arg_10_0)
	if #var_0_4.getConditionStr(arg_10_0.selectDbId, arg_10_0.abilityId, true) > 0 then
		gGameUI:showTip(gLanguageCsv.activeSlotNotEnough)

		return
	end

	local var_10_0, var_10_1 = var_0_3(arg_10_0.abilities:read(), arg_10_0.abilityId, arg_10_0.items:read(), arg_10_0.num:read())

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if iter_10_1.num < iter_10_1.targetNum then
			gGameUI:showTip(gLanguageCsv.materialsNotEnough)

			return
		end
	end

	if var_10_1 > arg_10_0.gold:read() then
		uiEasy.showDialog("gold", nil, {
			dialog = true
		})

		return
	end

	arg_10_0.oneKeyLevel:set(arg_10_0.num:read())
	arg_10_0:onClose()
end

function var_0_6.onIncreaseNum(arg_11_0, arg_11_1)
	arg_11_0.num:modify(function(arg_12_0)
		return true, cc.clampf(arg_12_0 + arg_11_1, arg_11_0.level, math.max(arg_11_0.maxNum, 1))
	end)
end

function var_0_6.onChangeNum(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_2.name == "click" then
		arg_13_0:unScheduleAll()
		arg_13_0:onIncreaseNum(arg_13_3)
	elseif arg_13_2.name == "began" then
		arg_13_0:schedule(function()
			arg_13_0:onIncreaseNum(arg_13_3)
		end, 0.05, 0, 1)
	elseif arg_13_2.name == "ended" or arg_13_2.name == "cancelled" then
		arg_13_0:unScheduleAll()
	end
end

return var_0_6
