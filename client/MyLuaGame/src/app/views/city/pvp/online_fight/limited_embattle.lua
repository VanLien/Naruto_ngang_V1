local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_2.cardId
	local var_1_1 = gOnlineFightCards[var_1_0]
	local var_1_2 = csv.cards[var_1_0]
	local var_1_3 = csv.unit[var_1_2.unitID]

	bind.extend(arg_1_0, arg_1_1, {
		class = "card_icon",
		props = {
			cardId = var_1_0,
			star = var_1_1.star,
			rarity = var_1_3.rarity,
			advance = var_1_1.advance,
			onNode = function(arg_2_0)
				local var_2_0 = arg_2_0:box()

				arg_2_0:alignCenter(var_2_0)
				arg_2_0:size(var_2_0)
			end
		}
	})
end

local function var_0_1(arg_3_0, arg_3_1)
	if arg_3_0.rarity ~= arg_3_1.rarity then
		return arg_3_0.rarity > arg_3_1.rarity
	end

	return arg_3_0.cardId < arg_3_1.cardId
end

local var_0_2 = cc.load("mvc").ViewBase
local var_0_3 = class("OnlineFightLimitedEmbattleView", var_0_2)

var_0_3.RESOURCE_FILENAME = "online_fight_limited_embattle.json"
var_0_3.RESOURCE_BINDING = {
	leftPanel = "leftPanel",
	subList = "subList",
	item = "item",
	["leftPanel.emptyPanel"] = "leftEmptyPanel",
	desc = "desc",
	["rightPanel.numTip"] = "numTip",
	["leftPanel.filterBtn"] = "filterBtn",
	rightPanel = "rightPanel",
	title = {
		binds = {
			event = "effect",
			data = {
				outline = {
					color = cc.c4b(50, 18, 6, 255)
				}
			}
		}
	},
	["leftPanel.filterBtn.name"] = {
		binds = {
			event = "effect",
			data = {
				color = ui.COLORS.NORMAL.WHITE,
				glow = {
					color = ui.COLORS.GLOW.WHITE
				}
			}
		}
	},
	["leftPanel.list"] = {
		varname = "leftList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 34,
				topPadding = 16,
				columnSize = 5,
				data = bindHelper.self("leftCards"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				leftEmptyPanel = bindHelper.self("leftEmptyPanel"),
				dataFilterGen = bindHelper.self("onFilterCards", true),
				dataOrderCmp = var_0_1,
				itemAction = {
					isAction = true
				},
				onCell = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					var_0_0(arg_4_0, arg_4_1, arg_4_3)
					arg_4_1:onTouch(functools.partial(arg_4_0.itemClick, arg_4_1, arg_4_2, arg_4_3, 1))
				end,
				onBeforeBuild = function(arg_5_0)
					arg_5_0.leftEmptyPanel:hide()
				end,
				onAfterBuild = function(arg_6_0)
					arg_6_0.leftEmptyPanel:visible(arg_6_0:getChildrenCount() <= 2)
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	},
	["rightPanel.list"] = {
		varname = "rightList",
		binds = {
			event = "extend",
			class = "tableview",
			props = {
				asyncPreload = 34,
				topPadding = 16,
				columnSize = 5,
				data = bindHelper.self("rightCards"),
				item = bindHelper.self("subList"),
				cell = bindHelper.self("item"),
				dataOrderCmp = var_0_1,
				itemAction = {
					isAction = true
				},
				onCell = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					var_0_0(arg_7_0, arg_7_1, arg_7_3)
					arg_7_1:onTouch(functools.partial(arg_7_0.itemClick, arg_7_1, arg_7_2, arg_7_3, 2))
				end
			},
			handlers = {
				itemClick = bindHelper.self("onItemClick")
			}
		}
	}
}
var_0_3.RESOURCE_STYLES = {
	full = true
}

function var_0_3.onCreate(arg_8_0)
	gGameUI.topuiManager:createView("title", arg_8_0, {
		onClose = arg_8_0:createHandler("onClose")
	}):init({
		subTitle = "PREPARE A FORMATION",
		title = "common/txt/txt_bt_wodeduiwu.png"
	})

	local var_8_0 = csv.cross.online_fight.base[1]

	arg_8_0.leastCardNum = var_8_0.leastCardNum
	arg_8_0.mostCardNum = var_8_0.mostCardNum

	arg_8_0.desc:getVirtualRenderer():setLineSpacing(10)
	arg_8_0.numTip:text(string.format(gLanguageCsv.onlineFightEmbattleNumTip, arg_8_0.leastCardNum))

	local var_8_1 = {}

	for iter_8_0, iter_8_1 in ipairs(gGameModel.role:read("cards")) do
		local var_8_2 = gGameModel.cards:find(iter_8_1)

		var_8_1[csv.cards[var_8_2:read("card_id")].cardMarkID] = true
	end

	local var_8_3 = {}

	for iter_8_2, iter_8_3 in orderCsvPairs(csv.cross.online_fight.cards) do
		if var_8_1[csv.cards[iter_8_3.cardId].cardMarkID] then
			var_8_3[iter_8_3.cardId] = true
		end
	end

	local var_8_4 = gGameModel.role:read("cross_online_fight_limited_cards")
	local var_8_5 = arraytools.hash(var_8_4)
	local var_8_6 = {}
	local var_8_7 = {}

	for iter_8_4, iter_8_5 in pairs(var_8_3) do
		local var_8_8 = csv.cards[iter_8_4]
		local var_8_9 = csv.unit[var_8_8.unitID]
		local var_8_10 = {
			cardId = iter_8_4,
			rarity = var_8_9.rarity,
			attr1 = var_8_9.natureType,
			attr2 = var_8_9.natureType2,
			atkType = var_8_8.atkType
		}

		if var_8_5[iter_8_4] then
			var_8_7[iter_8_4] = var_8_10
		else
			var_8_6[iter_8_4] = var_8_10
		end
	end

	arg_8_0.leftCards = idlertable.new(var_8_6)
	arg_8_0.rightCards = idlertable.new(var_8_7)

	arg_8_0.leftPanel:removeChildByName("num")
	rich.createByStr("#C0x5B5559##L10#" .. gLanguageCsv.onlineFightEmbattleNumDesc1 .. " " .. itertools.size(var_8_3), 50):anchorPoint(1, 0.5):xy(1020, 1120):addTo(arg_8_0.leftPanel, 5, "num")
	idlereasy.when(arg_8_0.rightCards, function(arg_9_0, arg_9_1)
		arg_8_0.rightPanel:removeChildByName("num")

		local var_9_0 = itertools.size(arg_9_1)
		local var_9_1 = var_9_0 >= arg_8_0.leastCardNum and "#C0x88C855#" or "#C0xF13B54#"

		rich.createByStr("#C0x5B5559##L10#" .. gLanguageCsv.onlineFightEmbattleNumDesc2 .. string.format(" %s%d#C0x5B5559#/%d", var_9_1, var_9_0, arg_8_0.mostCardNum), 50):anchorPoint(1, 0.5):xy(1020, 1120):addTo(arg_8_0.rightPanel, 5, "num")
		arg_8_0.rightPanel:get("emptyPanel"):visible(var_9_0 == 0)
	end)
	arg_8_0:initFilterBtn()
end

function var_0_3.changeCard(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 == 1 and itertools.size(arg_10_0.rightCards:read()) >= arg_10_0.mostCardNum then
		gGameUI:showTip(gLanguageCsv.onlineFightEmbattleNumMax)

		return
	end

	dataEasy.tryCallFunc(arg_10_0.leftList, "updatePreloadCenterIndex")
	dataEasy.tryCallFunc(arg_10_0.rightList, "updatePreloadCenterIndex")

	local var_10_0 = arg_10_1 == 1 and arg_10_0.leftCards or arg_10_0.rightCards
	local var_10_1 = arg_10_1 == 1 and arg_10_0.rightCards or arg_10_0.leftCards

	var_10_0:modify(function(arg_11_0)
		arg_11_0[arg_10_2.cardId] = nil

		return true, arg_11_0
	end)
	var_10_1:modify(function(arg_12_0)
		arg_12_0[arg_10_2.cardId] = arg_10_2

		return true, arg_12_0
	end)
end

function var_0_3.createMovingItem(arg_13_0, arg_13_1)
	if not arg_13_0.hasMovingItem then
		arg_13_0.hasMovingItem = true
		arg_13_0.movePanel = arg_13_0.item:clone():addTo(arg_13_0:getResourceNode(), 1000, "movePanel")

		var_0_0(arg_13_0, arg_13_0.movePanel, arg_13_1)
	end
end

function var_0_3.deleteMovingItem(arg_14_0)
	if arg_14_0.movePanel then
		arg_14_0.movePanel:removeSelf()

		arg_14_0.movePanel = nil

		return true
	end
end

function var_0_3.onItemClick(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	if arg_15_6.name == "began" then
		arg_15_0.touchBeganPos = arg_15_6
		arg_15_0.hasMovingItem = nil
		arg_15_0.movingTime = 0

		arg_15_0:deleteMovingItem()
		arg_15_1:enableSchedule()
		arg_15_1:schedule(function(arg_16_0)
			arg_15_0.movingTime = arg_15_0.movingTime + arg_16_0

			if arg_15_0.movingTime >= 0.5 then
				arg_15_0:createMovingItem(arg_15_4)
				arg_15_0.movePanel:xy(arg_15_6)

				return false
			end
		end, 0.1, nil, "onItemClick")
	elseif arg_15_6.name == "moved" then
		local var_15_0 = math.abs(arg_15_6.x - arg_15_0.touchBeganPos.x)
		local var_15_1 = math.abs(arg_15_6.y - arg_15_0.touchBeganPos.y)

		if arg_15_0.hasMovingItem == nil and (var_15_0 >= ui.TOUCH_MOVED_THRESHOLD or var_15_1 >= ui.TOUCH_MOVED_THRESHOLD) then
			arg_15_1:unSchedule("onItemClick")

			arg_15_0.hasMovingItem = false

			if var_15_0 > var_15_1 * 0.7 then
				arg_15_0:createMovingItem(arg_15_4)
			end
		end

		arg_15_0.leftList:setTouchEnabled(not arg_15_0.hasMovingItem)

		if arg_15_0.movePanel then
			arg_15_0.movePanel:xy(arg_15_6)
		end
	elseif arg_15_6.name == "ended" or arg_15_6.name == "cancelled" then
		arg_15_1:unSchedule("onItemClick")

		if arg_15_0.hasMovingItem == nil then
			arg_15_0:changeCard(arg_15_5, arg_15_4)
		end

		arg_15_0.hasMovingItem = nil

		if arg_15_0:deleteMovingItem() then
			if arg_15_5 == 1 and cc.rectContainsPoint(arg_15_0.rightPanel:box(), arg_15_6) then
				arg_15_0:changeCard(arg_15_5, arg_15_4)
			elseif arg_15_5 == 2 and cc.rectContainsPoint(arg_15_0.leftPanel:box(), arg_15_6) then
				arg_15_0:changeCard(arg_15_5, arg_15_4)
			end
		end
	end
end

function var_0_3.onClose(arg_17_0)
	local var_17_0 = gGameModel.role:read("cross_online_fight_limited_cards")
	local var_17_1 = arg_17_0.rightCards:read()
	local var_17_2 = itertools.map(var_17_1, function(arg_18_0, arg_18_1)
		return arg_18_1.cardId
	end)

	table.sort(var_17_2, function(arg_19_0, arg_19_1)
		return arg_19_0 < arg_19_1
	end)

	if not itertools.equal(var_17_0, var_17_2) then
		local function var_17_3()
			gGameApp:requestServer("/game/cross/online/deploy", function(arg_21_0)
				var_0_2.onClose(arg_17_0)
				gGameUI:showTip(gLanguageCsv.positionSave)
			end, var_17_2, 2)
		end

		if itertools.size(var_17_2) < arg_17_0.leastCardNum then
			gGameUI:showDialog({
				btnType = 2,
				clearFast = true,
				isRich = true,
				content = string.format(gLanguageCsv.onlineFightEmbattleCloseTip, arg_17_0.leastCardNum),
				cb = var_17_3
			})
		else
			var_17_3()
		end
	else
		var_0_2.onClose(arg_17_0)
	end
end

function var_0_3.initFilterBtn(arg_22_0)
	arg_22_0.filterCondition = idlertable.new()

	idlereasy.when(arg_22_0.filterCondition, function()
		dataEasy.tryCallFunc(arg_22_0.leftList, "filterSortItems", false)
	end)

	local var_22_0 = arg_22_0.filterBtn:parent():convertToWorldSpace(arg_22_0.filterBtn:box())
	local var_22_1 = arg_22_0:convertToNodeSpace(var_22_0)

	gGameUI:createView("city.card.bag_filter", arg_22_0.filterBtn):init({
		cb = arg_22_0:createHandler("onBattleFilter"),
		others = {
			width = 280,
			height = 122,
			panelOffsetX = 730,
			subPanelOrder = true,
			panelOrder = true,
			scale = 0.8,
			panelOffsetY = 620,
			x = gGameUI:getConvertPos(arg_22_0.filterBtn, arg_22_0:getResourceNode())
		}
	}):z(19):xy(-var_22_1.x, -var_22_1.y)
end

function var_0_3.onBattleFilter(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	arg_24_0.filterCondition:set({
		attr1 = arg_24_1,
		attr2 = arg_24_2,
		rarity = arg_24_3,
		atkType = arg_24_4
	}, true)
end

function var_0_3.onFilterCards(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.filterCondition:read()
	local var_25_1 = {}

	if not itertools.isempty(var_25_0) then
		var_25_1 = {
			{
				"rarity",
				var_25_0.rarity < ui.RARITY_LAST_VAL and var_25_0.rarity or nil
			},
			{
				"attr2",
				var_25_0.attr2 < ui.ATTR_MAX and var_25_0.attr2 or nil
			},
			{
				"attr1",
				var_25_0.attr1 < ui.ATTR_MAX and var_25_0.attr1 or nil
			},
			{
				"atkType",
				var_25_0.atkType
			}
		}
	end

	local function var_25_2(arg_26_0, arg_26_1, arg_26_2)
		if arg_26_0[arg_26_1] == nil and (arg_26_1 ~= "attr2" or arg_26_0.attr1 == arg_26_2) then
			return true
		end

		if arg_26_1 == "atkType" then
			for iter_26_0, iter_26_1 in ipairs(arg_26_0.atkType) do
				if arg_26_2[iter_26_1] then
					return true
				end
			end

			return false
		end

		if arg_26_0[arg_26_1] == arg_26_2 then
			return true
		end

		return false
	end

	return function(arg_27_0, arg_27_1)
		for iter_27_0 = 1, #var_25_1 do
			local var_27_0 = var_25_1[iter_27_0]

			if var_27_0[2] and not var_25_2(arg_27_1, var_27_0[1], var_27_0[2]) then
				return false
			end
		end

		return true, arg_27_0
	end
end

return var_0_3
